1 /*
2 
3                 https://www.narcotic.cash/
4 
5                 https://twitter.com/0x_NARCO
6 
7                 https://medium.com/@0xnarco/narcotic-ee9a3f6b4fde
8 
9                 https://t.me/NARCOTIC_PORTAL
10                 https://t.me/NARCOTIC_ANN
11 
12 */
13 
14 // hevm: flattened sources of src/Narcotic.sol
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
18 pragma experimental ABIEncoderV2;
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
819 ////// src/IUniswapV2Factory.sol
820 /* pragma solidity 0.8.10; */
821 /* pragma experimental ABIEncoderV2; */
822 
823 interface IUniswapV2Factory {
824     event PairCreated(
825         address indexed token0,
826         address indexed token1,
827         address pair,
828         uint256
829     );
830 
831     function feeTo() external view returns (address);
832 
833     function feeToSetter() external view returns (address);
834 
835     function getPair(address tokenA, address tokenB)
836         external
837         view
838         returns (address pair);
839 
840     function allPairs(uint256) external view returns (address pair);
841 
842     function allPairsLength() external view returns (uint256);
843 
844     function createPair(address tokenA, address tokenB)
845         external
846         returns (address pair);
847 
848     function setFeeTo(address) external;
849 
850     function setFeeToSetter(address) external;
851 }
852 
853 ////// src/IUniswapV2Pair.sol
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
966 ////// src/IUniswapV2Router02.sol
967 /* pragma solidity 0.8.10; */
968 /* pragma experimental ABIEncoderV2; */
969 
970 interface IUniswapV2Router02 {
971     function factory() external pure returns (address);
972 
973     function WETH() external pure returns (address);
974 
975     function addLiquidity(
976         address tokenA,
977         address tokenB,
978         uint256 amountADesired,
979         uint256 amountBDesired,
980         uint256 amountAMin,
981         uint256 amountBMin,
982         address to,
983         uint256 deadline
984     )
985         external
986         returns (
987             uint256 amountA,
988             uint256 amountB,
989             uint256 liquidity
990         );
991 
992     function addLiquidityETH(
993         address token,
994         uint256 amountTokenDesired,
995         uint256 amountTokenMin,
996         uint256 amountETHMin,
997         address to,
998         uint256 deadline
999     )
1000         external
1001         payable
1002         returns (
1003             uint256 amountToken,
1004             uint256 amountETH,
1005             uint256 liquidity
1006         );
1007 
1008     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1009         uint256 amountIn,
1010         uint256 amountOutMin,
1011         address[] calldata path,
1012         address to,
1013         uint256 deadline
1014     ) external;
1015 
1016     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1017         uint256 amountOutMin,
1018         address[] calldata path,
1019         address to,
1020         uint256 deadline
1021     ) external payable;
1022 
1023     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1024         uint256 amountIn,
1025         uint256 amountOutMin,
1026         address[] calldata path,
1027         address to,
1028         uint256 deadline
1029     ) external;
1030 }
1031 
1032 /* pragma solidity >=0.8.10; */
1033 
1034 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1035 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1036 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1037 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1038 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1039 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1040 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1041 
1042 contract NARCOTIC is ERC20, Ownable {
1043     using SafeMath for uint256;
1044 
1045     IUniswapV2Router02 public immutable uniswapV2Router;
1046     address public immutable uniswapV2Pair;
1047     address public constant deadAddress = address(0xdead);
1048 
1049     bool private swapping;
1050 
1051     address public marketingWallet;
1052     address public devWallet;
1053 
1054     uint256 public maxTransactionAmount;
1055     uint256 public swapTokensAtAmount;
1056     uint256 public maxWallet;
1057 
1058     uint256 public percentForLPBurn = 25; // 25 = .25%
1059     bool public lpBurnEnabled = true;
1060     uint256 public lpBurnFrequency = 3600 seconds;
1061     uint256 public lastLpBurnTime;
1062 
1063     uint256 public manualBurnFrequency = 30 minutes;
1064     uint256 public lastManualLpBurnTime;
1065 
1066     bool public limitsInEffect = true;
1067     bool public tradingActive = false;
1068     bool public swapEnabled = false;
1069 
1070     // Anti-bot and anti-whale mappings and variables
1071     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1072     bool public transferDelayEnabled = true;
1073 
1074     uint256 public buyTotalFees;
1075     uint256 public buyMarketingFee;
1076     uint256 public buyLiquidityFee;
1077     uint256 public buyDevFee;
1078 
1079     uint256 public sellTotalFees;
1080     uint256 public sellMarketingFee;
1081     uint256 public sellLiquidityFee;
1082     uint256 public sellDevFee;
1083 
1084     uint256 public tokensForMarketing;
1085     uint256 public tokensForLiquidity;
1086     uint256 public tokensForDev;
1087 
1088     /******************/
1089 
1090     // exlcude from fees and max transaction amount
1091     mapping(address => bool) private _isExcludedFromFees;
1092     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1093 
1094     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1095     // could be subject to a maximum transfer amount
1096     mapping(address => bool) public automatedMarketMakerPairs;
1097 
1098     event UpdateUniswapV2Router(
1099         address indexed newAddress,
1100         address indexed oldAddress
1101     );
1102 
1103     event ExcludeFromFees(address indexed account, bool isExcluded);
1104 
1105     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1106 
1107     event marketingWalletUpdated(
1108         address indexed newWallet,
1109         address indexed oldWallet
1110     );
1111 
1112     event devWalletUpdated(
1113         address indexed newWallet,
1114         address indexed oldWallet
1115     );
1116 
1117     event SwapAndLiquify(
1118         uint256 tokensSwapped,
1119         uint256 ethReceived,
1120         uint256 tokensIntoLiquidity
1121     );
1122 
1123     event AutoNukeLP();
1124 
1125     event ManualNukeLP();
1126 
1127     constructor() ERC20("NARCOTIC", "NARCO") {
1128         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1129             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1130         );
1131 
1132         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1133         uniswapV2Router = _uniswapV2Router;
1134 
1135         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1136             .createPair(address(this), _uniswapV2Router.WETH());
1137         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1138         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1139 
1140         uint256 _buyMarketingFee = 3;
1141         uint256 _buyLiquidityFee = 1;
1142         uint256 _buyDevFee = 1;
1143 
1144         uint256 _sellMarketingFee = 1;
1145         uint256 _sellLiquidityFee = 1;
1146         uint256 _sellDevFee = 3;
1147 
1148         uint256 totalSupply = 5_000_000_000 * 1e18;
1149 
1150         maxTransactionAmount = 25_000_000 * 1e18; // 0.5% from total supply maxTransactionAmountTxn
1151         maxWallet = 25_000_000 * 1e18; // 1% from total supply maxWallet
1152         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1153 
1154         buyMarketingFee = _buyMarketingFee;
1155         buyLiquidityFee = _buyLiquidityFee;
1156         buyDevFee = _buyDevFee;
1157         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1158 
1159         sellMarketingFee = _sellMarketingFee;
1160         sellLiquidityFee = _sellLiquidityFee;
1161         sellDevFee = _sellDevFee;
1162         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1163 
1164         marketingWallet = address(0xE362216409bCf824F7C9515F32F3452b83d90A72); // set as marketing wallet
1165         devWallet = address(0xE362216409bCf824F7C9515F32F3452b83d90A72); // set as dev wallet
1166 
1167         // exclude from paying fees or having max transaction amount
1168         excludeFromFees(owner(), true);
1169         excludeFromFees(address(this), true);
1170         excludeFromFees(address(0xdead), true);
1171 
1172         excludeFromMaxTransaction(owner(), true);
1173         excludeFromMaxTransaction(address(this), true);
1174         excludeFromMaxTransaction(address(0xdead), true);
1175 
1176         /*
1177             _mint is an internal function in ERC20.sol that is only called here,
1178             and CANNOT be called ever again
1179         */
1180         _mint(msg.sender, totalSupply);
1181     }
1182 
1183     receive() external payable {}
1184 
1185     // once enabled, can never be turned off
1186     function enableTrading() external onlyOwner {
1187         tradingActive = true;
1188         swapEnabled = true;
1189         lastLpBurnTime = block.timestamp;
1190     }
1191 
1192     // remove limits after token is stable
1193     function removeLimits() external onlyOwner returns (bool) {
1194         limitsInEffect = false;
1195         return true;
1196     }
1197 
1198     // disable Transfer delay - cannot be reenabled
1199     function disableTransferDelay() external onlyOwner returns (bool) {
1200         transferDelayEnabled = false;
1201         return true;
1202     }
1203 
1204     // change the minimum amount of tokens to sell from fees
1205     function updateSwapTokensAtAmount(uint256 newAmount)
1206         external
1207         onlyOwner
1208         returns (bool)
1209     {
1210         require(
1211             newAmount >= (totalSupply() * 1) / 100000,
1212             "Swap amount cannot be lower than 0.001% total supply."
1213         );
1214         require(
1215             newAmount <= (totalSupply() * 5) / 1000,
1216             "Swap amount cannot be higher than 0.5% total supply."
1217         );
1218         swapTokensAtAmount = newAmount;
1219         return true;
1220     }
1221 
1222     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1223         require(
1224             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1225             "Cannot set maxTransactionAmount lower than 0.1%"
1226         );
1227         maxTransactionAmount = newNum * (10**18);
1228     }
1229 
1230     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1231         require(
1232             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1233             "Cannot set maxWallet lower than 0.5%"
1234         );
1235         maxWallet = newNum * (10**18);
1236     }
1237 
1238     function excludeFromMaxTransaction(address updAds, bool isEx)
1239         public
1240         onlyOwner
1241     {
1242         _isExcludedMaxTransactionAmount[updAds] = isEx;
1243     }
1244 
1245     // only use to disable contract sales if absolutely necessary (emergency use only)
1246     function updateSwapEnabled(bool enabled) external onlyOwner {
1247         swapEnabled = enabled;
1248     }
1249 
1250     function updateBuyFees(
1251         uint256 _marketingFee,
1252         uint256 _liquidityFee,
1253         uint256 _devFee
1254     ) external onlyOwner {
1255         buyMarketingFee = _marketingFee;
1256         buyLiquidityFee = _liquidityFee;
1257         buyDevFee = _devFee;
1258         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1259         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1260     }
1261 
1262     function updateSellFees(
1263         uint256 _marketingFee,
1264         uint256 _liquidityFee,
1265         uint256 _devFee
1266     ) external onlyOwner {
1267         sellMarketingFee = _marketingFee;
1268         sellLiquidityFee = _liquidityFee;
1269         sellDevFee = _devFee;
1270         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1271         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1272     }
1273 
1274     function excludeFromFees(address account, bool excluded) public onlyOwner {
1275         _isExcludedFromFees[account] = excluded;
1276         emit ExcludeFromFees(account, excluded);
1277     }
1278 
1279     function setAutomatedMarketMakerPair(address pair, bool value)
1280         public
1281         onlyOwner
1282     {
1283         require(
1284             pair != uniswapV2Pair,
1285             "The pair cannot be removed from automatedMarketMakerPairs"
1286         );
1287 
1288         _setAutomatedMarketMakerPair(pair, value);
1289     }
1290 
1291     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1292         automatedMarketMakerPairs[pair] = value;
1293 
1294         emit SetAutomatedMarketMakerPair(pair, value);
1295     }
1296 
1297     function updateMarketingWallet(address newMarketingWallet)
1298         external
1299         onlyOwner
1300     {
1301         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1302         marketingWallet = newMarketingWallet;
1303     }
1304 
1305     function updateDevWallet(address newWallet) external onlyOwner {
1306         emit devWalletUpdated(newWallet, devWallet);
1307         devWallet = newWallet;
1308     }
1309 
1310     function isExcludedFromFees(address account) public view returns (bool) {
1311         return _isExcludedFromFees[account];
1312     }
1313 
1314     event BoughtEarly(address indexed sniper);
1315 
1316     function _transfer(
1317         address from,
1318         address to,
1319         uint256 amount
1320     ) internal override {
1321         require(from != address(0), "ERC20: transfer from the zero address");
1322         require(to != address(0), "ERC20: transfer to the zero address");
1323 
1324         if (amount == 0) {
1325             super._transfer(from, to, 0);
1326             return;
1327         }
1328 
1329         if (limitsInEffect) {
1330             if (
1331                 from != owner() &&
1332                 to != owner() &&
1333                 to != address(0) &&
1334                 to != address(0xdead) &&
1335                 !swapping
1336             ) {
1337                 if (!tradingActive) {
1338                     require(
1339                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1340                         "Trading is not active."
1341                     );
1342                 }
1343 
1344                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1345                 if (transferDelayEnabled) {
1346                     if (
1347                         to != owner() &&
1348                         to != address(uniswapV2Router) &&
1349                         to != address(uniswapV2Pair)
1350                     ) {
1351                         require(
1352                             _holderLastTransferTimestamp[tx.origin] <
1353                                 block.number,
1354                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1355                         );
1356                         _holderLastTransferTimestamp[tx.origin] = block.number;
1357                     }
1358                 }
1359 
1360                 //when buy
1361                 if (
1362                     automatedMarketMakerPairs[from] &&
1363                     !_isExcludedMaxTransactionAmount[to]
1364                 ) {
1365                     require(
1366                         amount <= maxTransactionAmount,
1367                         "Buy transfer amount exceeds the maxTransactionAmount."
1368                     );
1369                     require(
1370                         amount + balanceOf(to) <= maxWallet,
1371                         "Max wallet exceeded"
1372                     );
1373                 }
1374                 //when sell
1375                 else if (
1376                     automatedMarketMakerPairs[to] &&
1377                     !_isExcludedMaxTransactionAmount[from]
1378                 ) {
1379                     require(
1380                         amount <= maxTransactionAmount,
1381                         "Sell transfer amount exceeds the maxTransactionAmount."
1382                     );
1383                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1384                     require(
1385                         amount + balanceOf(to) <= maxWallet,
1386                         "Max wallet exceeded"
1387                     );
1388                 }
1389             }
1390         }
1391 
1392         uint256 contractTokenBalance = balanceOf(address(this));
1393 
1394         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1395 
1396         if (
1397             canSwap &&
1398             swapEnabled &&
1399             !swapping &&
1400             !automatedMarketMakerPairs[from] &&
1401             !_isExcludedFromFees[from] &&
1402             !_isExcludedFromFees[to]
1403         ) {
1404             swapping = true;
1405 
1406             swapBack();
1407 
1408             swapping = false;
1409         }
1410 
1411         if (
1412             !swapping &&
1413             automatedMarketMakerPairs[to] &&
1414             lpBurnEnabled &&
1415             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1416             !_isExcludedFromFees[from]
1417         ) {
1418             autoBurnLiquidityPairTokens();
1419         }
1420 
1421         bool takeFee = !swapping;
1422 
1423         // if any account belongs to _isExcludedFromFee account then remove the fee
1424         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1425             takeFee = false;
1426         }
1427 
1428         uint256 fees = 0;
1429         // only take fees on buys/sells, do not take on wallet transfers
1430         if (takeFee) {
1431             // on sell
1432             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1433                 fees = amount.mul(sellTotalFees).div(100);
1434                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1435                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1436                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1437             }
1438             // on buy
1439             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1440                 fees = amount.mul(buyTotalFees).div(100);
1441                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1442                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1443                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1444             }
1445 
1446             if (fees > 0) {
1447                 super._transfer(from, address(this), fees);
1448             }
1449 
1450             amount -= fees;
1451         }
1452 
1453         super._transfer(from, to, amount);
1454     }
1455 
1456     function swapTokensForEth(uint256 tokenAmount) private {
1457         // generate the uniswap pair path of token -> weth
1458         address[] memory path = new address[](2);
1459         path[0] = address(this);
1460         path[1] = uniswapV2Router.WETH();
1461 
1462         _approve(address(this), address(uniswapV2Router), tokenAmount);
1463 
1464         // make the swap
1465         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1466             tokenAmount,
1467             0, // accept any amount of ETH
1468             path,
1469             address(this),
1470             block.timestamp
1471         );
1472     }
1473 
1474     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1475         // approve token transfer to cover all possible scenarios
1476         _approve(address(this), address(uniswapV2Router), tokenAmount);
1477 
1478         // add the liquidity
1479         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1480             address(this),
1481             tokenAmount,
1482             0, // slippage is unavoidable
1483             0, // slippage is unavoidable
1484             deadAddress,
1485             block.timestamp
1486         );
1487     }
1488 
1489     function swapBack() private {
1490         uint256 contractBalance = balanceOf(address(this));
1491         uint256 totalTokensToSwap = tokensForLiquidity +
1492             tokensForMarketing +
1493             tokensForDev;
1494         bool success;
1495 
1496         if (contractBalance == 0 || totalTokensToSwap == 0) {
1497             return;
1498         }
1499 
1500         if (contractBalance > swapTokensAtAmount * 20) {
1501             contractBalance = swapTokensAtAmount * 20;
1502         }
1503 
1504         // Halve the amount of liquidity tokens
1505         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1506             totalTokensToSwap /
1507             2;
1508         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1509 
1510         uint256 initialETHBalance = address(this).balance;
1511 
1512         swapTokensForEth(amountToSwapForETH);
1513 
1514         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1515 
1516         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1517             totalTokensToSwap
1518         );
1519         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1520 
1521         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1522 
1523         tokensForLiquidity = 0;
1524         tokensForMarketing = 0;
1525         tokensForDev = 0;
1526 
1527         (success, ) = address(devWallet).call{value: ethForDev}("");
1528 
1529         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1530             addLiquidity(liquidityTokens, ethForLiquidity);
1531             emit SwapAndLiquify(
1532                 amountToSwapForETH,
1533                 ethForLiquidity,
1534                 tokensForLiquidity
1535             );
1536         }
1537 
1538         (success, ) = address(marketingWallet).call{
1539             value: address(this).balance
1540         }("");
1541     }
1542 
1543     function setAutoLPBurnSettings(
1544         uint256 _frequencyInSeconds,
1545         uint256 _percent,
1546         bool _Enabled
1547     ) external onlyOwner {
1548         require(
1549             _frequencyInSeconds >= 600,
1550             "cannot set buyback more often than every 10 minutes"
1551         );
1552         require(
1553             _percent <= 1000 && _percent >= 0,
1554             "Must set auto LP burn percent between 0% and 10%"
1555         );
1556         lpBurnFrequency = _frequencyInSeconds;
1557         percentForLPBurn = _percent;
1558         lpBurnEnabled = _Enabled;
1559     }
1560 
1561     function autoBurnLiquidityPairTokens() internal returns (bool) {
1562         lastLpBurnTime = block.timestamp;
1563 
1564         // get balance of liquidity pair
1565         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1566 
1567         // calculate amount to burn
1568         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1569             10000
1570         );
1571 
1572         // pull tokens from pancakePair liquidity and move to dead address permanently
1573         if (amountToBurn > 0) {
1574             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1575         }
1576 
1577         //sync price since this is not in a swap transaction!
1578         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1579         pair.sync();
1580         emit AutoNukeLP();
1581         return true;
1582     }
1583 
1584     function manualBurnLiquidityPairTokens(uint256 percent)
1585         external
1586         onlyOwner
1587         returns (bool)
1588     {
1589         require(
1590             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1591             "Must wait for cooldown to finish"
1592         );
1593         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1594         lastManualLpBurnTime = block.timestamp;
1595 
1596         // get balance of liquidity pair
1597         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1598 
1599         // calculate amount to burn
1600         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1601 
1602         // pull tokens from pancakePair liquidity and move to dead address permanently
1603         if (amountToBurn > 0) {
1604             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1605         }
1606 
1607         //sync price since this is not in a swap transaction!
1608         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1609         pair.sync();
1610         emit ManualNukeLP();
1611         return true;
1612     }
1613 }