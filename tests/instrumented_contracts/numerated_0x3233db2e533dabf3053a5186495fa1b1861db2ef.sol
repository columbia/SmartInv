1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 /**
6 
7 Welcome to Manybot - $MBOT your gateway to effortless bot creation, all within the Telegram ecosystem! 🤖
8 
9 
10 Homepage: https://manybot.pro/
11 Telegram: https://t.me/ManybotEntry
12 Twitter:  https://twitter.com/Manybotdev
13 
14 10,0000 $MBOT 
15 5% Tax
16 Stealth launch
17 
18 */
19 
20 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
21 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
22 
23 /* pragma solidity ^0.8.0; */
24 
25 /**
26  * @dev Provides information about the current execution context, including the
27  * sender of the transaction and its data. While these are generally available
28  * via msg.sender and msg.data, they should not be accessed in such a direct
29  * manner, since when dealing with meta-transactions the account sending and
30  * paying for execution may not be the actual sender (as far as an application
31  * is concerned).
32  *
33  * This contract is only required for intermediate, library-like contracts.
34  */
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address) {
37         return msg.sender;
38     }
39 
40     function _msgData() internal view virtual returns (bytes calldata) {
41         return msg.data;
42     }
43 }
44 
45 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
46 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
47 
48 /* pragma solidity ^0.8.0; */
49 
50 /* import "../utils/Context.sol"; */
51 
52 /**
53  * @dev Contract module which provides a basic access control mechanism, where
54  * there is an account (an owner) that can be granted exclusive access to
55  * specific functions.
56  *
57  * By default, the owner account will be the one that deploys the contract. This
58  * can later be changed with {transferOwnership}.
59  *
60  * This module is used through inheritance. It will make available the modifier
61  * `onlyOwner`, which can be applied to your functions to restrict their use to
62  * the owner.
63  */
64 abstract contract Ownable is Context {
65     address private _owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70      * @dev Initializes the contract setting the deployer as the initial owner.
71      */
72     constructor() {
73         _transferOwnership(_msgSender());
74     }
75 
76     /**
77      * @dev Returns the address of the current owner.
78      */
79     function owner() public view virtual returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if called by any account other than the owner.
85      */
86     modifier onlyOwner() {
87         require(owner() == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     /**
92      * @dev Leaves the contract without owner. It will not be possible to call
93      * `onlyOwner` functions anymore. Can only be called by the current owner.
94      *
95      * NOTE: Renouncing ownership will leave the contract without an owner,
96      * thereby removing any functionality that is only available to the owner.
97      */
98     function renounceOwnership() public virtual onlyOwner {
99         _transferOwnership(address(0));
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Can only be called by the current owner.
105      */
106     function transferOwnership(address newOwner) public virtual onlyOwner {
107         require(newOwner != address(0), "Ownable: new owner is the zero address");
108         _transferOwnership(newOwner);
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Internal function without access restriction.
114      */
115     function _transferOwnership(address newOwner) internal virtual {
116         address oldOwner = _owner;
117         _owner = newOwner;
118         emit OwnershipTransferred(oldOwner, newOwner);
119     }
120 }
121 
122 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
123 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
124 
125 /* pragma solidity ^0.8.0; */
126 
127 /**
128  * @dev Interface of the ERC20 standard as defined in the EIP.
129  */
130 interface IERC20 {
131     /**
132      * @dev Returns the amount of tokens in existence.
133      */
134     function totalSupply() external view returns (uint256);
135 
136     /**
137      * @dev Returns the amount of tokens owned by `account`.
138      */
139     function balanceOf(address account) external view returns (uint256);
140 
141     /**
142      * @dev Moves `amount` tokens from the caller's account to `recipient`.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transfer(address recipient, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Returns the remaining number of tokens that `spender` will be
152      * allowed to spend on behalf of `owner` through {transferFrom}. This is
153      * zero by default.
154      *
155      * This value changes when {approve} or {transferFrom} are called.
156      */
157     function allowance(address owner, address spender) external view returns (uint256);
158 
159     /**
160      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * IMPORTANT: Beware that changing an allowance with this method brings the risk
165      * that someone may use both the old and the new allowance by unfortunate
166      * transaction ordering. One possible solution to mitigate this race
167      * condition is to first reduce the spender's allowance to 0 and set the
168      * desired value afterwards:
169      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170      *
171      * Emits an {Approval} event.
172      */
173     function approve(address spender, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Moves `amount` tokens from `sender` to `recipient` using the
177      * allowance mechanism. `amount` is then deducted from the caller's
178      * allowance.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transferFrom(
185         address sender,
186         address recipient,
187         uint256 amount
188     ) external returns (bool);
189 
190     /**
191      * @dev Emitted when `value` tokens are moved from one account (`from`) to
192      * another (`to`).
193      *
194      * Note that `value` may be zero.
195      */
196     event Transfer(address indexed from, address indexed to, uint256 value);
197 
198     /**
199      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
200      * a call to {approve}. `value` is the new allowance.
201      */
202     event Approval(address indexed owner, address indexed spender, uint256 value);
203 }
204 
205 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
206 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
207 
208 /* pragma solidity ^0.8.0; */
209 
210 /* import "../IERC20.sol"; */
211 
212 /**
213  * @dev Interface for the optional metadata functions from the ERC20 standard.
214  *
215  * _Available since v4.1._
216  */
217 interface IERC20Metadata is IERC20 {
218     /**
219      * @dev Returns the name of the token.
220      */
221     function name() external view returns (string memory);
222 
223     /**
224      * @dev Returns the symbol of the token.
225      */
226     function symbol() external view returns (string memory);
227 
228     /**
229      * @dev Returns the decimals places of the token.
230      */
231     function decimals() external view returns (uint8);
232 }
233 
234 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
235 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
236 
237 /* pragma solidity ^0.8.0; */
238 
239 /* import "./IERC20.sol"; */
240 /* import "./extensions/IERC20Metadata.sol"; */
241 /* import "../../utils/Context.sol"; */
242 
243 /**
244  * @dev Implementation of the {IERC20} interface.
245  *
246  * This implementation is agnostic to the way tokens are created. This means
247  * that a supply mechanism has to be added in a derived contract using {_mint}.
248  * For a generic mechanism see {ERC20PresetMinterPauser}.
249  *
250  * TIP: For a detailed writeup see our guide
251  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
252  * to implement supply mechanisms].
253  *
254  * We have followed general OpenZeppelin Contracts guidelines: functions revert
255  * instead returning `false` on failure. This behavior is nonetheless
256  * conventional and does not conflict with the expectations of ERC20
257  * applications.
258  *
259  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
260  * This allows applications to reconstruct the allowance for all accounts just
261  * by listening to said events. Other implementations of the EIP may not emit
262  * these events, as it isn't required by the specification.
263  *
264  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
265  * functions have been added to mitigate the well-known issues around setting
266  * allowances. See {IERC20-approve}.
267  */
268 contract ERC20 is Context, IERC20, IERC20Metadata {
269     mapping(address => uint256) private _balances;
270 
271     mapping(address => mapping(address => uint256)) private _allowances;
272 
273     uint256 private _totalSupply;
274 
275     string private _name;
276     string private _symbol;
277 
278     /**
279      * @dev Sets the values for {name} and {symbol}.
280      *
281      * The default value of {decimals} is 18. To select a different value for
282      * {decimals} you should overload it.
283      *
284      * All two of these values are immutable: they can only be set once during
285      * construction.
286      */
287     constructor(string memory name_, string memory symbol_) {
288         _name = name_;
289         _symbol = symbol_;
290     }
291 
292     /**
293      * @dev Returns the name of the token.
294      */
295     function name() public view virtual override returns (string memory) {
296         return _name;
297     }
298 
299     /**
300      * @dev Returns the symbol of the token, usually a shorter version of the
301      * name.
302      */
303     function symbol() public view virtual override returns (string memory) {
304         return _symbol;
305     }
306 
307     /**
308      * @dev Returns the number of decimals used to get its user representation.
309      * For example, if `decimals` equals `2`, a balance of `505` tokens should
310      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
311      *
312      * Tokens usually opt for a value of 18, imitating the relationship between
313      * Ether and Wei. This is the value {ERC20} uses, unless this function is
314      * overridden;
315      *
316      * NOTE: This information is only used for _display_ purposes: it in
317      * no way affects any of the arithmetic of the contract, including
318      * {IERC20-balanceOf} and {IERC20-transfer}.
319      */
320     function decimals() public view virtual override returns (uint8) {
321         return 18;
322     }
323 
324     /**
325      * @dev See {IERC20-totalSupply}.
326      */
327     function totalSupply() public view virtual override returns (uint256) {
328         return _totalSupply;
329     }
330 
331     /**
332      * @dev See {IERC20-balanceOf}.
333      */
334     function balanceOf(address account) public view virtual override returns (uint256) {
335         return _balances[account];
336     }
337 
338     /**
339      * @dev See {IERC20-transfer}.
340      *
341      * Requirements:
342      *
343      * - `recipient` cannot be the zero address.
344      * - the caller must have a balance of at least `amount`.
345      */
346     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
347         _transfer(_msgSender(), recipient, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-allowance}.
353      */
354     function allowance(address owner, address spender) public view virtual override returns (uint256) {
355         return _allowances[owner][spender];
356     }
357 
358     /**
359      * @dev See {IERC20-approve}.
360      *
361      * Requirements:
362      *
363      * - `spender` cannot be the zero address.
364      */
365     function approve(address spender, uint256 amount) public virtual override returns (bool) {
366         _approve(_msgSender(), spender, amount);
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-transferFrom}.
372      *
373      * Emits an {Approval} event indicating the updated allowance. This is not
374      * required by the EIP. See the note at the beginning of {ERC20}.
375      *
376      * Requirements:
377      *
378      * - `sender` and `recipient` cannot be the zero address.
379      * - `sender` must have a balance of at least `amount`.
380      * - the caller must have allowance for ``sender``'s tokens of at least
381      * `amount`.
382      */
383     function transferFrom(
384         address sender,
385         address recipient,
386         uint256 amount
387     ) public virtual override returns (bool) {
388         _transfer(sender, recipient, amount);
389 
390         uint256 currentAllowance = _allowances[sender][_msgSender()];
391         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
392         unchecked {
393             _approve(sender, _msgSender(), currentAllowance - amount);
394         }
395 
396         return true;
397     }
398 
399     /**
400      * @dev Atomically increases the allowance granted to `spender` by the caller.
401      *
402      * This is an alternative to {approve} that can be used as a mitigation for
403      * problems described in {IERC20-approve}.
404      *
405      * Emits an {Approval} event indicating the updated allowance.
406      *
407      * Requirements:
408      *
409      * - `spender` cannot be the zero address.
410      */
411     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
412         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
413         return true;
414     }
415 
416     /**
417      * @dev Atomically decreases the allowance granted to `spender` by the caller.
418      *
419      * This is an alternative to {approve} that can be used as a mitigation for
420      * problems described in {IERC20-approve}.
421      *
422      * Emits an {Approval} event indicating the updated allowance.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      * - `spender` must have allowance for the caller of at least
428      * `subtractedValue`.
429      */
430     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
431         uint256 currentAllowance = _allowances[_msgSender()][spender];
432         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
433         unchecked {
434             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
435         }
436 
437         return true;
438     }
439 
440     /**
441      * @dev Moves `amount` of tokens from `sender` to `recipient`.
442      *
443      * This internal function is equivalent to {transfer}, and can be used to
444      * e.g. implement automatic token fees, slashing mechanisms, etc.
445      *
446      * Emits a {Transfer} event.
447      *
448      * Requirements:
449      *
450      * - `sender` cannot be the zero address.
451      * - `recipient` cannot be the zero address.
452      * - `sender` must have a balance of at least `amount`.
453      */
454     function _transfer(
455         address sender,
456         address recipient,
457         uint256 amount
458     ) internal virtual {
459         require(sender != address(0), "ERC20: transfer from the zero address");
460         require(recipient != address(0), "ERC20: transfer to the zero address");
461 
462         _beforeTokenTransfer(sender, recipient, amount);
463 
464         uint256 senderBalance = _balances[sender];
465         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
466         unchecked {
467             _balances[sender] = senderBalance - amount;
468         }
469         _balances[recipient] += amount;
470 
471         emit Transfer(sender, recipient, amount);
472 
473         _afterTokenTransfer(sender, recipient, amount);
474     }
475 
476     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
477      * the total supply.
478      *
479      * Emits a {Transfer} event with `from` set to the zero address.
480      *
481      * Requirements:
482      *
483      * - `account` cannot be the zero address.
484      */
485     function _mint(address account, uint256 amount) internal virtual {
486         require(account != address(0), "ERC20: mint to the zero address");
487 
488         _beforeTokenTransfer(address(0), account, amount);
489 
490         _totalSupply += amount;
491         _balances[account] += amount;
492         emit Transfer(address(0), account, amount);
493 
494         _afterTokenTransfer(address(0), account, amount);
495     }
496 
497     /**
498      * @dev Destroys `amount` tokens from `account`, reducing the
499      * total supply.
500      *
501      * Emits a {Transfer} event with `to` set to the zero address.
502      *
503      * Requirements:
504      *
505      * - `account` cannot be the zero address.
506      * - `account` must have at least `amount` tokens.
507      */
508     function _burn(address account, uint256 amount) internal virtual {
509         require(account != address(0), "ERC20: burn from the zero address");
510 
511         _beforeTokenTransfer(account, address(0), amount);
512 
513         uint256 accountBalance = _balances[account];
514         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
515         unchecked {
516             _balances[account] = accountBalance - amount;
517         }
518         _totalSupply -= amount;
519 
520         emit Transfer(account, address(0), amount);
521 
522         _afterTokenTransfer(account, address(0), amount);
523     }
524 
525     /**
526      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
527      *
528      * This internal function is equivalent to `approve`, and can be used to
529      * e.g. set automatic allowances for certain subsystems, etc.
530      *
531      * Emits an {Approval} event.
532      *
533      * Requirements:
534      *
535      * - `owner` cannot be the zero address.
536      * - `spender` cannot be the zero address.
537      */
538     function _approve(
539         address owner,
540         address spender,
541         uint256 amount
542     ) internal virtual {
543         require(owner != address(0), "ERC20: approve from the zero address");
544         require(spender != address(0), "ERC20: approve to the zero address");
545 
546         _allowances[owner][spender] = amount;
547         emit Approval(owner, spender, amount);
548     }
549 
550     /**
551      * @dev Hook that is called before any transfer of tokens. This includes
552      * minting and burning.
553      *
554      * Calling conditions:
555      *
556      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
557      * will be transferred to `to`.
558      * - when `from` is zero, `amount` tokens will be minted for `to`.
559      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
560      * - `from` and `to` are never both zero.
561      *
562      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
563      */
564     function _beforeTokenTransfer(
565         address from,
566         address to,
567         uint256 amount
568     ) internal virtual {}
569 
570     /**
571      * @dev Hook that is called after any transfer of tokens. This includes
572      * minting and burning.
573      *
574      * Calling conditions:
575      *
576      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
577      * has been transferred to `to`.
578      * - when `from` is zero, `amount` tokens have been minted for `to`.
579      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
580      * - `from` and `to` are never both zero.
581      *
582      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
583      */
584     function _afterTokenTransfer(
585         address from,
586         address to,
587         uint256 amount
588     ) internal virtual {}
589 }
590 
591 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
592 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
593 
594 /* pragma solidity ^0.8.0; */
595 
596 // CAUTION
597 // This version of SafeMath should only be used with Solidity 0.8 or later,
598 // because it relies on the compiler's built in overflow checks.
599 
600 /**
601  * @dev Wrappers over Solidity's arithmetic operations.
602  *
603  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
604  * now has built in overflow checking.
605  */
606 library SafeMath {
607     /**
608      * @dev Returns the addition of two unsigned integers, with an overflow flag.
609      *
610      * _Available since v3.4._
611      */
612     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
613         unchecked {
614             uint256 c = a + b;
615             if (c < a) return (false, 0);
616             return (true, c);
617         }
618     }
619 
620     /**
621      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
622      *
623      * _Available since v3.4._
624      */
625     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
626         unchecked {
627             if (b > a) return (false, 0);
628             return (true, a - b);
629         }
630     }
631 
632     /**
633      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
634      *
635      * _Available since v3.4._
636      */
637     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
638         unchecked {
639             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
640             // benefit is lost if 'b' is also tested.
641             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
642             if (a == 0) return (true, 0);
643             uint256 c = a * b;
644             if (c / a != b) return (false, 0);
645             return (true, c);
646         }
647     }
648 
649     /**
650      * @dev Returns the division of two unsigned integers, with a division by zero flag.
651      *
652      * _Available since v3.4._
653      */
654     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
655         unchecked {
656             if (b == 0) return (false, 0);
657             return (true, a / b);
658         }
659     }
660 
661     /**
662      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
663      *
664      * _Available since v3.4._
665      */
666     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
667         unchecked {
668             if (b == 0) return (false, 0);
669             return (true, a % b);
670         }
671     }
672 
673     /**
674      * @dev Returns the addition of two unsigned integers, reverting on
675      * overflow.
676      *
677      * Counterpart to Solidity's `+` operator.
678      *
679      * Requirements:
680      *
681      * - Addition cannot overflow.
682      */
683     function add(uint256 a, uint256 b) internal pure returns (uint256) {
684         return a + b;
685     }
686 
687     /**
688      * @dev Returns the subtraction of two unsigned integers, reverting on
689      * overflow (when the result is negative).
690      *
691      * Counterpart to Solidity's `-` operator.
692      *
693      * Requirements:
694      *
695      * - Subtraction cannot overflow.
696      */
697     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
698         return a - b;
699     }
700 
701     /**
702      * @dev Returns the multiplication of two unsigned integers, reverting on
703      * overflow.
704      *
705      * Counterpart to Solidity's `*` operator.
706      *
707      * Requirements:
708      *
709      * - Multiplication cannot overflow.
710      */
711     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
712         return a * b;
713     }
714 
715     /**
716      * @dev Returns the integer division of two unsigned integers, reverting on
717      * division by zero. The result is rounded towards zero.
718      *
719      * Counterpart to Solidity's `/` operator.
720      *
721      * Requirements:
722      *
723      * - The divisor cannot be zero.
724      */
725     function div(uint256 a, uint256 b) internal pure returns (uint256) {
726         return a / b;
727     }
728 
729     /**
730      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
731      * reverting when dividing by zero.
732      *
733      * Counterpart to Solidity's `%` operator. This function uses a `revert`
734      * opcode (which leaves remaining gas untouched) while Solidity uses an
735      * invalid opcode to revert (consuming all remaining gas).
736      *
737      * Requirements:
738      *
739      * - The divisor cannot be zero.
740      */
741     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
742         return a % b;
743     }
744 
745     /**
746      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
747      * overflow (when the result is negative).
748      *
749      * CAUTION: This function is deprecated because it requires allocating memory for the error
750      * message unnecessarily. For custom revert reasons use {trySub}.
751      *
752      * Counterpart to Solidity's `-` operator.
753      *
754      * Requirements:
755      *
756      * - Subtraction cannot overflow.
757      */
758     function sub(
759         uint256 a,
760         uint256 b,
761         string memory errorMessage
762     ) internal pure returns (uint256) {
763         unchecked {
764             require(b <= a, errorMessage);
765             return a - b;
766         }
767     }
768 
769     /**
770      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
771      * division by zero. The result is rounded towards zero.
772      *
773      * Counterpart to Solidity's `/` operator. Note: this function uses a
774      * `revert` opcode (which leaves remaining gas untouched) while Solidity
775      * uses an invalid opcode to revert (consuming all remaining gas).
776      *
777      * Requirements:
778      *
779      * - The divisor cannot be zero.
780      */
781     function div(
782         uint256 a,
783         uint256 b,
784         string memory errorMessage
785     ) internal pure returns (uint256) {
786         unchecked {
787             require(b > 0, errorMessage);
788             return a / b;
789         }
790     }
791 
792     /**
793      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
794      * reverting with custom message when dividing by zero.
795      *
796      * CAUTION: This function is deprecated because it requires allocating memory for the error
797      * message unnecessarily. For custom revert reasons use {tryMod}.
798      *
799      * Counterpart to Solidity's `%` operator. This function uses a `revert`
800      * opcode (which leaves remaining gas untouched) while Solidity uses an
801      * invalid opcode to revert (consuming all remaining gas).
802      *
803      * Requirements:
804      *
805      * - The divisor cannot be zero.
806      */
807     function mod(
808         uint256 a,
809         uint256 b,
810         string memory errorMessage
811     ) internal pure returns (uint256) {
812         unchecked {
813             require(b > 0, errorMessage);
814             return a % b;
815         }
816     }
817 }
818 
819 /* pragma solidity 0.8.10; */
820 /* pragma experimental ABIEncoderV2; */
821 
822 interface IUniswapV2Factory {
823     event PairCreated(
824         address indexed token0,
825         address indexed token1,
826         address pair,
827         uint256
828     );
829 
830     function feeTo() external view returns (address);
831 
832     function feeToSetter() external view returns (address);
833 
834     function getPair(address tokenA, address tokenB)
835         external
836         view
837         returns (address pair);
838 
839     function allPairs(uint256) external view returns (address pair);
840 
841     function allPairsLength() external view returns (uint256);
842 
843     function createPair(address tokenA, address tokenB)
844         external
845         returns (address pair);
846 
847     function setFeeTo(address) external;
848 
849     function setFeeToSetter(address) external;
850 }
851 
852 /* pragma solidity 0.8.10; */
853 /* pragma experimental ABIEncoderV2; */
854 
855 interface IUniswapV2Pair {
856     event Approval(
857         address indexed owner,
858         address indexed spender,
859         uint256 value
860     );
861     event Transfer(address indexed from, address indexed to, uint256 value);
862 
863     function name() external pure returns (string memory);
864 
865     function symbol() external pure returns (string memory);
866 
867     function decimals() external pure returns (uint8);
868 
869     function totalSupply() external view returns (uint256);
870 
871     function balanceOf(address owner) external view returns (uint256);
872 
873     function allowance(address owner, address spender)
874         external
875         view
876         returns (uint256);
877 
878     function approve(address spender, uint256 value) external returns (bool);
879 
880     function transfer(address to, uint256 value) external returns (bool);
881 
882     function transferFrom(
883         address from,
884         address to,
885         uint256 value
886     ) external returns (bool);
887 
888     function DOMAIN_SEPARATOR() external view returns (bytes32);
889 
890     function PERMIT_TYPEHASH() external pure returns (bytes32);
891 
892     function nonces(address owner) external view returns (uint256);
893 
894     function permit(
895         address owner,
896         address spender,
897         uint256 value,
898         uint256 deadline,
899         uint8 v,
900         bytes32 r,
901         bytes32 s
902     ) external;
903 
904     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
905     event Burn(
906         address indexed sender,
907         uint256 amount0,
908         uint256 amount1,
909         address indexed to
910     );
911     event Swap(
912         address indexed sender,
913         uint256 amount0In,
914         uint256 amount1In,
915         uint256 amount0Out,
916         uint256 amount1Out,
917         address indexed to
918     );
919     event Sync(uint112 reserve0, uint112 reserve1);
920 
921     function MINIMUM_LIQUIDITY() external pure returns (uint256);
922 
923     function factory() external view returns (address);
924 
925     function token0() external view returns (address);
926 
927     function token1() external view returns (address);
928 
929     function getReserves()
930         external
931         view
932         returns (
933             uint112 reserve0,
934             uint112 reserve1,
935             uint32 blockTimestampLast
936         );
937 
938     function price0CumulativeLast() external view returns (uint256);
939 
940     function price1CumulativeLast() external view returns (uint256);
941 
942     function kLast() external view returns (uint256);
943 
944     function mint(address to) external returns (uint256 liquidity);
945 
946     function burn(address to)
947         external
948         returns (uint256 amount0, uint256 amount1);
949 
950     function swap(
951         uint256 amount0Out,
952         uint256 amount1Out,
953         address to,
954         bytes calldata data
955     ) external;
956 
957     function skim(address to) external;
958 
959     function sync() external;
960 
961     function initialize(address, address) external;
962 }
963 
964 /* pragma solidity 0.8.10; */
965 /* pragma experimental ABIEncoderV2; */
966 
967 interface IUniswapV2Router02 {
968     function factory() external pure returns (address);
969 
970     function WETH() external pure returns (address);
971 
972     function addLiquidity(
973         address tokenA,
974         address tokenB,
975         uint256 amountADesired,
976         uint256 amountBDesired,
977         uint256 amountAMin,
978         uint256 amountBMin,
979         address to,
980         uint256 deadline
981     )
982         external
983         returns (
984             uint256 amountA,
985             uint256 amountB,
986             uint256 liquidity
987         );
988 
989     function addLiquidityETH(
990         address token,
991         uint256 amountTokenDesired,
992         uint256 amountTokenMin,
993         uint256 amountETHMin,
994         address to,
995         uint256 deadline
996     )
997         external
998         payable
999         returns (
1000             uint256 amountToken,
1001             uint256 amountETH,
1002             uint256 liquidity
1003         );
1004 
1005     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1006         uint256 amountIn,
1007         uint256 amountOutMin,
1008         address[] calldata path,
1009         address to,
1010         uint256 deadline
1011     ) external;
1012 
1013     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1014         uint256 amountOutMin,
1015         address[] calldata path,
1016         address to,
1017         uint256 deadline
1018     ) external payable;
1019 
1020     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1021         uint256 amountIn,
1022         uint256 amountOutMin,
1023         address[] calldata path,
1024         address to,
1025         uint256 deadline
1026     ) external;
1027 }
1028 
1029 /* pragma solidity >=0.8.10; */
1030 
1031 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1032 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1033 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1034 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1035 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1036 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1037 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1038 
1039 contract MBOT is ERC20, Ownable {
1040     using SafeMath for uint256;
1041 
1042     IUniswapV2Router02 public immutable uniswapV2Router;
1043     address public immutable uniswapV2Pair;
1044     address public constant deadAddress = address(0xdead);
1045 
1046     bool private swapping;
1047 
1048 	address public charityWallet;
1049     address public marketingWallet;
1050     address public devWallet;
1051 
1052     uint256 public maxTransactionAmount;
1053     uint256 public swapTokensAtAmount;
1054     uint256 public maxWallet;
1055 
1056     bool public limitsInEffect = true;
1057     bool public tradingActive = true;
1058     bool public swapEnabled = true;
1059 
1060     // Anti-bot and anti-whale mappings and variables
1061     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1062     bool public transferDelayEnabled = true;
1063 
1064     uint256 public buyTotalFees;
1065 	uint256 public buyCharityFee;
1066     uint256 public buyMarketingFee;
1067     uint256 public buyLiquidityFee;
1068     uint256 public buyDevFee;
1069 
1070     uint256 public sellTotalFees;
1071 	uint256 public sellCharityFee;
1072     uint256 public sellMarketingFee;
1073     uint256 public sellLiquidityFee;
1074     uint256 public sellDevFee;
1075 
1076 	uint256 public tokensForCharity;
1077     uint256 public tokensForMarketing;
1078     uint256 public tokensForLiquidity;
1079     uint256 public tokensForDev;
1080 
1081     /******************/
1082 
1083     // exlcude from fees and max transaction amount
1084     mapping(address => bool) private _isExcludedFromFees;
1085     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1086 
1087     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1088     // could be subject to a maximum transfer amount
1089     mapping(address => bool) public automatedMarketMakerPairs;
1090 
1091     event UpdateUniswapV2Router(
1092         address indexed newAddress,
1093         address indexed oldAddress
1094     );
1095 
1096     event ExcludeFromFees(address indexed account, bool isExcluded);
1097 
1098     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1099 
1100     event SwapAndLiquify(
1101         uint256 tokensSwapped,
1102         uint256 ethReceived,
1103         uint256 tokensIntoLiquidity
1104     );
1105 
1106     constructor() ERC20("MANYBOT", "MBOT") {
1107         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1108             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1109         );
1110 
1111         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1112         uniswapV2Router = _uniswapV2Router;
1113 
1114         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1115             .createPair(address(this), _uniswapV2Router.WETH());
1116         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1117         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1118 
1119 		uint256 _buyCharityFee = 0;
1120         uint256 _buyMarketingFee = 15;
1121         uint256 _buyLiquidityFee = 0;
1122         uint256 _buyDevFee = 10;
1123 
1124 		uint256 _sellCharityFee = 0;
1125         uint256 _sellMarketingFee = 15;
1126         uint256 _sellLiquidityFee = 0;
1127         uint256 _sellDevFee = 10;
1128 
1129         uint256 totalSupply = 100000 * 1e18;
1130 
1131         maxTransactionAmount = 1000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1132         maxWallet = 2000 * 1e18; // 2% from total supply maxWallet
1133         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1134 
1135 		buyCharityFee = _buyCharityFee;
1136         buyMarketingFee = _buyMarketingFee;
1137         buyLiquidityFee = _buyLiquidityFee;
1138         buyDevFee = _buyDevFee;
1139         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1140 
1141 		sellCharityFee = _sellCharityFee;
1142         sellMarketingFee = _sellMarketingFee;
1143         sellLiquidityFee = _sellLiquidityFee;
1144         sellDevFee = _sellDevFee;
1145         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1146 
1147 		charityWallet = address(0x6d55D8C4875e5f1586d1E7F1796843cb6D21Dbd4); // 
1148         marketingWallet = address(0x6d55D8C4875e5f1586d1E7F1796843cb6D21Dbd4); // 
1149         devWallet = address(0x6d55D8C4875e5f1586d1E7F1796843cb6D21Dbd4); // 
1150 
1151         // exclude from paying fees or having max transaction amount
1152         excludeFromFees(owner(), true);
1153         excludeFromFees(address(this), true);
1154         excludeFromFees(address(0xdead), true);
1155 
1156         excludeFromMaxTransaction(owner(), true);
1157         excludeFromMaxTransaction(address(this), true);
1158         excludeFromMaxTransaction(address(0xdead), true);
1159 
1160         /*
1161             _mint is an internal function in ERC20.sol that is only called here,
1162             and CANNOT be called ever again
1163         */
1164         _mint(msg.sender, totalSupply);
1165     }
1166 
1167     receive() external payable {}
1168 
1169     // once enabled, can never be turned off
1170     function enableTrading() external onlyOwner {
1171         tradingActive = true;
1172         swapEnabled = true;
1173     }
1174 
1175     // remove limits after token is stable
1176     function removeLimits() external onlyOwner returns (bool) {
1177         limitsInEffect = false;
1178         return true;
1179     }
1180 
1181     // disable Transfer delay - cannot be reenabled
1182     function disableTransferDelay() external onlyOwner returns (bool) {
1183         transferDelayEnabled = false;
1184         return true;
1185     }
1186 
1187     // change the minimum amount of tokens to sell from fees
1188     function updateSwapTokensAtAmount(uint256 newAmount)
1189         external
1190         onlyOwner
1191         returns (bool)
1192     {
1193         require(
1194             newAmount >= (totalSupply() * 1) / 100000,
1195             "Swap amount cannot be lower than 0.001% total supply."
1196         );
1197         require(
1198             newAmount <= (totalSupply() * 5) / 1000,
1199             "Swap amount cannot be higher than 0.5% total supply."
1200         );
1201         swapTokensAtAmount = newAmount;
1202         return true;
1203     }
1204 
1205     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1206         require(
1207             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1208             "Cannot set maxTransactionAmount lower than 0.5%"
1209         );
1210         maxTransactionAmount = newNum * (10**18);
1211     }
1212 
1213     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1214         require(
1215             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1216             "Cannot set maxWallet lower than 0.5%"
1217         );
1218         maxWallet = newNum * (10**18);
1219     }
1220 	
1221     function excludeFromMaxTransaction(address updAds, bool isEx)
1222         public
1223         onlyOwner
1224     {
1225         _isExcludedMaxTransactionAmount[updAds] = isEx;
1226     }
1227 
1228     // only use to disable contract sales if absolutely necessary (emergency use only)
1229     function updateSwapEnabled(bool enabled) external onlyOwner {
1230         swapEnabled = enabled;
1231     }
1232 
1233     function updateBuyFees(
1234 		uint256 _charityFee,
1235         uint256 _marketingFee,
1236         uint256 _liquidityFee,
1237         uint256 _devFee
1238     ) external onlyOwner {
1239 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1240 		buyCharityFee = _charityFee;
1241         buyMarketingFee = _marketingFee;
1242         buyLiquidityFee = _liquidityFee;
1243         buyDevFee = _devFee;
1244         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1245      }
1246 
1247     function updateSellFees(
1248 		uint256 _charityFee,
1249         uint256 _marketingFee,
1250         uint256 _liquidityFee,
1251         uint256 _devFee
1252     ) external onlyOwner {
1253 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1254 		sellCharityFee = _charityFee;
1255         sellMarketingFee = _marketingFee;
1256         sellLiquidityFee = _liquidityFee;
1257         sellDevFee = _devFee;
1258         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1259     }
1260 
1261     function excludeFromFees(address account, bool excluded) public onlyOwner {
1262         _isExcludedFromFees[account] = excluded;
1263         emit ExcludeFromFees(account, excluded);
1264     }
1265 
1266     function setAutomatedMarketMakerPair(address pair, bool value)
1267         public
1268         onlyOwner
1269     {
1270         require(
1271             pair != uniswapV2Pair,
1272             "The pair cannot be removed from automatedMarketMakerPairs"
1273         );
1274 
1275         _setAutomatedMarketMakerPair(pair, value);
1276     }
1277 
1278     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1279         automatedMarketMakerPairs[pair] = value;
1280 
1281         emit SetAutomatedMarketMakerPair(pair, value);
1282     }
1283 
1284     function isExcludedFromFees(address account) public view returns (bool) {
1285         return _isExcludedFromFees[account];
1286     }
1287 
1288     function _transfer(
1289         address from,
1290         address to,
1291         uint256 amount
1292     ) internal override {
1293         require(from != address(0), "ERC20: transfer from the zero address");
1294         require(to != address(0), "ERC20: transfer to the zero address");
1295 
1296         if (amount == 0) {
1297             super._transfer(from, to, 0);
1298             return;
1299         }
1300 
1301         if (limitsInEffect) {
1302             if (
1303                 from != owner() &&
1304                 to != owner() &&
1305                 to != address(0) &&
1306                 to != address(0xdead) &&
1307                 !swapping
1308             ) {
1309                 if (!tradingActive) {
1310                     require(
1311                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1312                         "Trading is not active."
1313                     );
1314                 }
1315 
1316                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1317                 if (transferDelayEnabled) {
1318                     if (
1319                         to != owner() &&
1320                         to != address(uniswapV2Router) &&
1321                         to != address(uniswapV2Pair)
1322                     ) {
1323                         require(
1324                             _holderLastTransferTimestamp[tx.origin] <
1325                                 block.number,
1326                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1327                         );
1328                         _holderLastTransferTimestamp[tx.origin] = block.number;
1329                     }
1330                 }
1331 
1332                 //when buy
1333                 if (
1334                     automatedMarketMakerPairs[from] &&
1335                     !_isExcludedMaxTransactionAmount[to]
1336                 ) {
1337                     require(
1338                         amount <= maxTransactionAmount,
1339                         "Buy transfer amount exceeds the maxTransactionAmount."
1340                     );
1341                     require(
1342                         amount + balanceOf(to) <= maxWallet,
1343                         "Max wallet exceeded"
1344                     );
1345                 }
1346                 //when sell
1347                 else if (
1348                     automatedMarketMakerPairs[to] &&
1349                     !_isExcludedMaxTransactionAmount[from]
1350                 ) {
1351                     require(
1352                         amount <= maxTransactionAmount,
1353                         "Sell transfer amount exceeds the maxTransactionAmount."
1354                     );
1355                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1356                     require(
1357                         amount + balanceOf(to) <= maxWallet,
1358                         "Max wallet exceeded"
1359                     );
1360                 }
1361             }
1362         }
1363 
1364         uint256 contractTokenBalance = balanceOf(address(this));
1365 
1366         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1367 
1368         if (
1369             canSwap &&
1370             swapEnabled &&
1371             !swapping &&
1372             !automatedMarketMakerPairs[from] &&
1373             !_isExcludedFromFees[from] &&
1374             !_isExcludedFromFees[to]
1375         ) {
1376             swapping = true;
1377 
1378             swapBack();
1379 
1380             swapping = false;
1381         }
1382 
1383         bool takeFee = !swapping;
1384 
1385         // if any account belongs to _isExcludedFromFee account then remove the fee
1386         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1387             takeFee = false;
1388         }
1389 
1390         uint256 fees = 0;
1391         // only take fees on buys/sells, do not take on wallet transfers
1392         if (takeFee) {
1393             // on sell
1394             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1395                 fees = amount.mul(sellTotalFees).div(100);
1396 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1397                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1398                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1399                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1400             }
1401             // on buy
1402             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1403                 fees = amount.mul(buyTotalFees).div(100);
1404 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1405                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1406                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1407                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1408             }
1409 
1410             if (fees > 0) {
1411                 super._transfer(from, address(this), fees);
1412             }
1413 
1414             amount -= fees;
1415         }
1416 
1417         super._transfer(from, to, amount);
1418     }
1419 
1420     function swapTokensForEth(uint256 tokenAmount) private {
1421         // generate the uniswap pair path of token -> weth
1422         address[] memory path = new address[](2);
1423         path[0] = address(this);
1424         path[1] = uniswapV2Router.WETH();
1425 
1426         _approve(address(this), address(uniswapV2Router), tokenAmount);
1427 
1428         // make the swap
1429         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1430             tokenAmount,
1431             0, // accept any amount of ETH
1432             path,
1433             address(this),
1434             block.timestamp
1435         );
1436     }
1437 
1438     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1439         // approve token transfer to cover all possible scenarios
1440         _approve(address(this), address(uniswapV2Router), tokenAmount);
1441 
1442         // add the liquidity
1443         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1444             address(this),
1445             tokenAmount,
1446             0, // slippage is unavoidable
1447             0, // slippage is unavoidable
1448             devWallet,
1449             block.timestamp
1450         );
1451     }
1452 
1453     function swapBack() private {
1454         uint256 contractBalance = balanceOf(address(this));
1455         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1456         bool success;
1457 
1458         if (contractBalance == 0 || totalTokensToSwap == 0) {
1459             return;
1460         }
1461 
1462         if (contractBalance > swapTokensAtAmount * 20) {
1463             contractBalance = swapTokensAtAmount * 20;
1464         }
1465 
1466         // Halve the amount of liquidity tokens
1467         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1468         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1469 
1470         uint256 initialETHBalance = address(this).balance;
1471 
1472         swapTokensForEth(amountToSwapForETH);
1473 
1474         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1475 
1476 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1477         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1478         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1479 
1480         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1481 
1482         tokensForLiquidity = 0;
1483 		tokensForCharity = 0;
1484         tokensForMarketing = 0;
1485         tokensForDev = 0;
1486 
1487         (success, ) = address(devWallet).call{value: ethForDev}("");
1488         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1489 
1490 
1491         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1492             addLiquidity(liquidityTokens, ethForLiquidity);
1493             emit SwapAndLiquify(
1494                 amountToSwapForETH,
1495                 ethForLiquidity,
1496                 tokensForLiquidity
1497             );
1498         }
1499 
1500         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1501     }
1502 
1503 }