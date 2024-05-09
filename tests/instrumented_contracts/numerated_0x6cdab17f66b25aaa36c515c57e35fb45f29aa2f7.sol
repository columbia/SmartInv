1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 /**
6 
7                        _.-**-._
8                     _,(        ),_
9                  .-"   '-^----'   "-.
10               .-'                    '-.
11             .'                          '.
12           .'    __.--**'""""""'**--.__    '.
13          /_.-*"'__.--**'""""""'**--.__'"*-._\
14         /_..-*"'   .-*"*-.  .-*"*-.   '"*-.._\                  http://ericcartmancoin.com
15        :          /       ;:       \          ;                   
16        :         :     *  !!  *     :         ;
17         \        '.     .'  '.     .'        /                  https://t.me/EricCartmanCoin
18          \         '-.-'      '-.-'         /                       
19       .-*''.                              .'-.
20    .-'      '.                          .'    '.
21   :           '-.        _.._        .-'        '._
22  ;"*-._          '-._  --___ `   _.-'        _.*'  '*.
23 :      '.            `"*-.__.-*"`           (        :
24  ;      ;                 *|                 '-.     ;
25   '---*'                   |                    ""--'
26    :                      *|                      :
27    '.                      |                     .'
28      '.._                 *|        ____----.._-'
29       \  """----_____------'-----"""         /
30        \  __..-------.._        ___..---._  /
31        :'"              '-..--''          "';
32         '""""""""""""""""' '"""""""""""""""'
33 
34 
35 
36 
37 */
38 
39 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
40 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
41 
42 /* pragma solidity ^0.8.0; */
43 
44 /**
45  * @dev Provides information about the current execution context, including the
46  * sender of the transaction and its data. While these are generally available
47  * via msg.sender and msg.data, they should not be accessed in such a direct
48  * manner, since when dealing with meta-transactions the account sending and
49  * paying for execution may not be the actual sender (as far as an application
50  * is concerned).
51  *
52  * This contract is only required for intermediate, library-like contracts.
53  */
54 abstract contract Context {
55     function _msgSender() internal view virtual returns (address) {
56         return msg.sender;
57     }
58 
59     function _msgData() internal view virtual returns (bytes calldata) {
60         return msg.data;
61     }
62 }
63 
64 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
65 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
66 
67 /* pragma solidity ^0.8.0; */
68 
69 /* import "../utils/Context.sol"; */
70 
71 /**
72  * @dev Contract module which provides a basic access control mechanism, where
73  * there is an account (an owner) that can be granted exclusive access to
74  * specific functions.
75  *
76  * By default, the owner account will be the one that deploys the contract. This
77  * can later be changed with {transferOwnership}.
78  *
79  * This module is used through inheritance. It will make available the modifier
80  * `onlyOwner`, which can be applied to your functions to restrict their use to
81  * the owner.
82  */
83 abstract contract Ownable is Context {
84     address private _owner;
85 
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     /**
89      * @dev Initializes the contract setting the deployer as the initial owner.
90      */
91     constructor() {
92         _transferOwnership(_msgSender());
93     }
94 
95     /**
96      * @dev Returns the address of the current owner.
97      */
98     function owner() public view virtual returns (address) {
99         return _owner;
100     }
101 
102     /**
103      * @dev Throws if called by any account other than the owner.
104      */
105     modifier onlyOwner() {
106         require(owner() == _msgSender(), "Ownable: caller is not the owner");
107         _;
108     }
109 
110     /**
111      * @dev Leaves the contract without owner. It will not be possible to call
112      * `onlyOwner` functions anymore. Can only be called by the current owner.
113      *
114      * NOTE: Renouncing ownership will leave the contract without an owner,
115      * thereby removing any functionality that is only available to the owner.
116      */
117     function renounceOwnership() public virtual onlyOwner {
118         _transferOwnership(address(0));
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      * Can only be called by the current owner.
124      */
125     function transferOwnership(address newOwner) public virtual onlyOwner {
126         require(newOwner != address(0), "Ownable: new owner is the zero address");
127         _transferOwnership(newOwner);
128     }
129 
130     /**
131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
132      * Internal function without access restriction.
133      */
134     function _transferOwnership(address newOwner) internal virtual {
135         address oldOwner = _owner;
136         _owner = newOwner;
137         emit OwnershipTransferred(oldOwner, newOwner);
138     }
139 }
140 
141 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
142 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
143 
144 /* pragma solidity ^0.8.0; */
145 
146 /**
147  * @dev Interface of the ERC20 standard as defined in the EIP.
148  */
149 interface IERC20 {
150     /**
151      * @dev Returns the amount of tokens in existence.
152      */
153     function totalSupply() external view returns (uint256);
154 
155     /**
156      * @dev Returns the amount of tokens owned by `account`.
157      */
158     function balanceOf(address account) external view returns (uint256);
159 
160     /**
161      * @dev Moves `amount` tokens from the caller's account to `recipient`.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transfer(address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Returns the remaining number of tokens that `spender` will be
171      * allowed to spend on behalf of `owner` through {transferFrom}. This is
172      * zero by default.
173      *
174      * This value changes when {approve} or {transferFrom} are called.
175      */
176     function allowance(address owner, address spender) external view returns (uint256);
177 
178     /**
179      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * IMPORTANT: Beware that changing an allowance with this method brings the risk
184      * that someone may use both the old and the new allowance by unfortunate
185      * transaction ordering. One possible solution to mitigate this race
186      * condition is to first reduce the spender's allowance to 0 and set the
187      * desired value afterwards:
188      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189      *
190      * Emits an {Approval} event.
191      */
192     function approve(address spender, uint256 amount) external returns (bool);
193 
194     /**
195      * @dev Moves `amount` tokens from `sender` to `recipient` using the
196      * allowance mechanism. `amount` is then deducted from the caller's
197      * allowance.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address sender,
205         address recipient,
206         uint256 amount
207     ) external returns (bool);
208 
209     /**
210      * @dev Emitted when `value` tokens are moved from one account (`from`) to
211      * another (`to`).
212      *
213      * Note that `value` may be zero.
214      */
215     event Transfer(address indexed from, address indexed to, uint256 value);
216 
217     /**
218      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
219      * a call to {approve}. `value` is the new allowance.
220      */
221     event Approval(address indexed owner, address indexed spender, uint256 value);
222 }
223 
224 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
225 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
226 
227 /* pragma solidity ^0.8.0; */
228 
229 /* import "../IERC20.sol"; */
230 
231 /**
232  * @dev Interface for the optional metadata functions from the ERC20 standard.
233  *
234  * _Available since v4.1._
235  */
236 interface IERC20Metadata is IERC20 {
237     /**
238      * @dev Returns the name of the token.
239      */
240     function name() external view returns (string memory);
241 
242     /**
243      * @dev Returns the symbol of the token.
244      */
245     function symbol() external view returns (string memory);
246 
247     /**
248      * @dev Returns the decimals places of the token.
249      */
250     function decimals() external view returns (uint8);
251 }
252 
253 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
254 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
255 
256 /* pragma solidity ^0.8.0; */
257 
258 /* import "./IERC20.sol"; */
259 /* import "./extensions/IERC20Metadata.sol"; */
260 /* import "../../utils/Context.sol"; */
261 
262 /**
263  * @dev Implementation of the {IERC20} interface.
264  *
265  * This implementation is agnostic to the way tokens are created. This means
266  * that a supply mechanism has to be added in a derived contract using {_mint}.
267  * For a generic mechanism see {ERC20PresetMinterPauser}.
268  *
269  * TIP: For a detailed writeup see our guide
270  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
271  * to implement supply mechanisms].
272  *
273  * We have followed general OpenZeppelin Contracts guidelines: functions revert
274  * instead returning `false` on failure. This behavior is nonetheless
275  * conventional and does not conflict with the expectations of ERC20
276  * applications.
277  *
278  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
279  * This allows applications to reconstruct the allowance for all accounts just
280  * by listening to said events. Other implementations of the EIP may not emit
281  * these events, as it isn't required by the specification.
282  *
283  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
284  * functions have been added to mitigate the well-known issues around setting
285  * allowances. See {IERC20-approve}.
286  */
287 contract ERC20 is Context, IERC20, IERC20Metadata {
288     mapping(address => uint256) private _balances;
289 
290     mapping(address => mapping(address => uint256)) private _allowances;
291 
292     uint256 private _totalSupply;
293 
294     string private _name;
295     string private _symbol;
296 
297     /**
298      * @dev Sets the values for {name} and {symbol}.
299      *
300      * The default value of {decimals} is 18. To select a different value for
301      * {decimals} you should overload it.
302      *
303      * All two of these values are immutable: they can only be set once during
304      * construction.
305      */
306     constructor(string memory name_, string memory symbol_) {
307         _name = name_;
308         _symbol = symbol_;
309     }
310 
311     /**
312      * @dev Returns the name of the token.
313      */
314     function name() public view virtual override returns (string memory) {
315         return _name;
316     }
317 
318     /**
319      * @dev Returns the symbol of the token, usually a shorter version of the
320      * name.
321      */
322     function symbol() public view virtual override returns (string memory) {
323         return _symbol;
324     }
325 
326     /**
327      * @dev Returns the number of decimals used to get its user representation.
328      * For example, if `decimals` equals `2`, a balance of `505` tokens should
329      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
330      *
331      * Tokens usually opt for a value of 18, imitating the relationship between
332      * Ether and Wei. This is the value {ERC20} uses, unless this function is
333      * overridden;
334      *
335      * NOTE: This information is only used for _display_ purposes: it in
336      * no way affects any of the arithmetic of the contract, including
337      * {IERC20-balanceOf} and {IERC20-transfer}.
338      */
339     function decimals() public view virtual override returns (uint8) {
340         return 18;
341     }
342 
343     /**
344      * @dev See {IERC20-totalSupply}.
345      */
346     function totalSupply() public view virtual override returns (uint256) {
347         return _totalSupply;
348     }
349 
350     /**
351      * @dev See {IERC20-balanceOf}.
352      */
353     function balanceOf(address account) public view virtual override returns (uint256) {
354         return _balances[account];
355     }
356 
357     /**
358      * @dev See {IERC20-transfer}.
359      *
360      * Requirements:
361      *
362      * - `recipient` cannot be the zero address.
363      * - the caller must have a balance of at least `amount`.
364      */
365     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
366         _transfer(_msgSender(), recipient, amount);
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-allowance}.
372      */
373     function allowance(address owner, address spender) public view virtual override returns (uint256) {
374         return _allowances[owner][spender];
375     }
376 
377     /**
378      * @dev See {IERC20-approve}.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      */
384     function approve(address spender, uint256 amount) public virtual override returns (bool) {
385         _approve(_msgSender(), spender, amount);
386         return true;
387     }
388 
389     /**
390      * @dev See {IERC20-transferFrom}.
391      *
392      * Emits an {Approval} event indicating the updated allowance. This is not
393      * required by the EIP. See the note at the beginning of {ERC20}.
394      *
395      * Requirements:
396      *
397      * - `sender` and `recipient` cannot be the zero address.
398      * - `sender` must have a balance of at least `amount`.
399      * - the caller must have allowance for ``sender``'s tokens of at least
400      * `amount`.
401      */
402     function transferFrom(
403         address sender,
404         address recipient,
405         uint256 amount
406     ) public virtual override returns (bool) {
407         _transfer(sender, recipient, amount);
408 
409         uint256 currentAllowance = _allowances[sender][_msgSender()];
410         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
411         unchecked {
412             _approve(sender, _msgSender(), currentAllowance - amount);
413         }
414 
415         return true;
416     }
417 
418     /**
419      * @dev Atomically increases the allowance granted to `spender` by the caller.
420      *
421      * This is an alternative to {approve} that can be used as a mitigation for
422      * problems described in {IERC20-approve}.
423      *
424      * Emits an {Approval} event indicating the updated allowance.
425      *
426      * Requirements:
427      *
428      * - `spender` cannot be the zero address.
429      */
430     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
431         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
432         return true;
433     }
434 
435     /**
436      * @dev Atomically decreases the allowance granted to `spender` by the caller.
437      *
438      * This is an alternative to {approve} that can be used as a mitigation for
439      * problems described in {IERC20-approve}.
440      *
441      * Emits an {Approval} event indicating the updated allowance.
442      *
443      * Requirements:
444      *
445      * - `spender` cannot be the zero address.
446      * - `spender` must have allowance for the caller of at least
447      * `subtractedValue`.
448      */
449     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
450         uint256 currentAllowance = _allowances[_msgSender()][spender];
451         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
452         unchecked {
453             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
454         }
455 
456         return true;
457     }
458 
459     /**
460      * @dev Moves `amount` of tokens from `sender` to `recipient`.
461      *
462      * This internal function is equivalent to {transfer}, and can be used to
463      * e.g. implement automatic token fees, slashing mechanisms, etc.
464      *
465      * Emits a {Transfer} event.
466      *
467      * Requirements:
468      *
469      * - `sender` cannot be the zero address.
470      * - `recipient` cannot be the zero address.
471      * - `sender` must have a balance of at least `amount`.
472      */
473     function _transfer(
474         address sender,
475         address recipient,
476         uint256 amount
477     ) internal virtual {
478         require(sender != address(0), "ERC20: transfer from the zero address");
479         require(recipient != address(0), "ERC20: transfer to the zero address");
480 
481         _beforeTokenTransfer(sender, recipient, amount);
482 
483         uint256 senderBalance = _balances[sender];
484         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
485         unchecked {
486             _balances[sender] = senderBalance - amount;
487         }
488         _balances[recipient] += amount;
489 
490         emit Transfer(sender, recipient, amount);
491 
492         _afterTokenTransfer(sender, recipient, amount);
493     }
494 
495     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
496      * the total supply.
497      *
498      * Emits a {Transfer} event with `from` set to the zero address.
499      *
500      * Requirements:
501      *
502      * - `account` cannot be the zero address.
503      */
504     function _mint(address account, uint256 amount) internal virtual {
505         require(account != address(0), "ERC20: mint to the zero address");
506 
507         _beforeTokenTransfer(address(0), account, amount);
508 
509         _totalSupply += amount;
510         _balances[account] += amount;
511         emit Transfer(address(0), account, amount);
512 
513         _afterTokenTransfer(address(0), account, amount);
514     }
515 
516     /**
517      * @dev Destroys `amount` tokens from `account`, reducing the
518      * total supply.
519      *
520      * Emits a {Transfer} event with `to` set to the zero address.
521      *
522      * Requirements:
523      *
524      * - `account` cannot be the zero address.
525      * - `account` must have at least `amount` tokens.
526      */
527     function _burn(address account, uint256 amount) internal virtual {
528         require(account != address(0), "ERC20: burn from the zero address");
529 
530         _beforeTokenTransfer(account, address(0), amount);
531 
532         uint256 accountBalance = _balances[account];
533         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
534         unchecked {
535             _balances[account] = accountBalance - amount;
536         }
537         _totalSupply -= amount;
538 
539         emit Transfer(account, address(0), amount);
540 
541         _afterTokenTransfer(account, address(0), amount);
542     }
543 
544     /**
545      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
546      *
547      * This internal function is equivalent to `approve`, and can be used to
548      * e.g. set automatic allowances for certain subsystems, etc.
549      *
550      * Emits an {Approval} event.
551      *
552      * Requirements:
553      *
554      * - `owner` cannot be the zero address.
555      * - `spender` cannot be the zero address.
556      */
557     function _approve(
558         address owner,
559         address spender,
560         uint256 amount
561     ) internal virtual {
562         require(owner != address(0), "ERC20: approve from the zero address");
563         require(spender != address(0), "ERC20: approve to the zero address");
564 
565         _allowances[owner][spender] = amount;
566         emit Approval(owner, spender, amount);
567     }
568 
569     /**
570      * @dev Hook that is called before any transfer of tokens. This includes
571      * minting and burning.
572      *
573      * Calling conditions:
574      *
575      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
576      * will be transferred to `to`.
577      * - when `from` is zero, `amount` tokens will be minted for `to`.
578      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
579      * - `from` and `to` are never both zero.
580      *
581      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
582      */
583     function _beforeTokenTransfer(
584         address from,
585         address to,
586         uint256 amount
587     ) internal virtual {}
588 
589     /**
590      * @dev Hook that is called after any transfer of tokens. This includes
591      * minting and burning.
592      *
593      * Calling conditions:
594      *
595      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
596      * has been transferred to `to`.
597      * - when `from` is zero, `amount` tokens have been minted for `to`.
598      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
599      * - `from` and `to` are never both zero.
600      *
601      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
602      */
603     function _afterTokenTransfer(
604         address from,
605         address to,
606         uint256 amount
607     ) internal virtual {}
608 }
609 
610 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
611 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
612 
613 /* pragma solidity ^0.8.0; */
614 
615 // CAUTION
616 // This version of SafeMath should only be used with Solidity 0.8 or later,
617 // because it relies on the compiler's built in overflow checks.
618 
619 /**
620  * @dev Wrappers over Solidity's arithmetic operations.
621  *
622  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
623  * now has built in overflow checking.
624  */
625 library SafeMath {
626     /**
627      * @dev Returns the addition of two unsigned integers, with an overflow flag.
628      *
629      * _Available since v3.4._
630      */
631     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
632         unchecked {
633             uint256 c = a + b;
634             if (c < a) return (false, 0);
635             return (true, c);
636         }
637     }
638 
639     /**
640      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
641      *
642      * _Available since v3.4._
643      */
644     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
645         unchecked {
646             if (b > a) return (false, 0);
647             return (true, a - b);
648         }
649     }
650 
651     /**
652      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
653      *
654      * _Available since v3.4._
655      */
656     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
657         unchecked {
658             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
659             // benefit is lost if 'b' is also tested.
660             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
661             if (a == 0) return (true, 0);
662             uint256 c = a * b;
663             if (c / a != b) return (false, 0);
664             return (true, c);
665         }
666     }
667 
668     /**
669      * @dev Returns the division of two unsigned integers, with a division by zero flag.
670      *
671      * _Available since v3.4._
672      */
673     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
674         unchecked {
675             if (b == 0) return (false, 0);
676             return (true, a / b);
677         }
678     }
679 
680     /**
681      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
682      *
683      * _Available since v3.4._
684      */
685     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
686         unchecked {
687             if (b == 0) return (false, 0);
688             return (true, a % b);
689         }
690     }
691 
692     /**
693      * @dev Returns the addition of two unsigned integers, reverting on
694      * overflow.
695      *
696      * Counterpart to Solidity's `+` operator.
697      *
698      * Requirements:
699      *
700      * - Addition cannot overflow.
701      */
702     function add(uint256 a, uint256 b) internal pure returns (uint256) {
703         return a + b;
704     }
705 
706     /**
707      * @dev Returns the subtraction of two unsigned integers, reverting on
708      * overflow (when the result is negative).
709      *
710      * Counterpart to Solidity's `-` operator.
711      *
712      * Requirements:
713      *
714      * - Subtraction cannot overflow.
715      */
716     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
717         return a - b;
718     }
719 
720     /**
721      * @dev Returns the multiplication of two unsigned integers, reverting on
722      * overflow.
723      *
724      * Counterpart to Solidity's `*` operator.
725      *
726      * Requirements:
727      *
728      * - Multiplication cannot overflow.
729      */
730     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
731         return a * b;
732     }
733 
734     /**
735      * @dev Returns the integer division of two unsigned integers, reverting on
736      * division by zero. The result is rounded towards zero.
737      *
738      * Counterpart to Solidity's `/` operator.
739      *
740      * Requirements:
741      *
742      * - The divisor cannot be zero.
743      */
744     function div(uint256 a, uint256 b) internal pure returns (uint256) {
745         return a / b;
746     }
747 
748     /**
749      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
750      * reverting when dividing by zero.
751      *
752      * Counterpart to Solidity's `%` operator. This function uses a `revert`
753      * opcode (which leaves remaining gas untouched) while Solidity uses an
754      * invalid opcode to revert (consuming all remaining gas).
755      *
756      * Requirements:
757      *
758      * - The divisor cannot be zero.
759      */
760     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
761         return a % b;
762     }
763 
764     /**
765      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
766      * overflow (when the result is negative).
767      *
768      * CAUTION: This function is deprecated because it requires allocating memory for the error
769      * message unnecessarily. For custom revert reasons use {trySub}.
770      *
771      * Counterpart to Solidity's `-` operator.
772      *
773      * Requirements:
774      *
775      * - Subtraction cannot overflow.
776      */
777     function sub(
778         uint256 a,
779         uint256 b,
780         string memory errorMessage
781     ) internal pure returns (uint256) {
782         unchecked {
783             require(b <= a, errorMessage);
784             return a - b;
785         }
786     }
787 
788     /**
789      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
790      * division by zero. The result is rounded towards zero.
791      *
792      * Counterpart to Solidity's `/` operator. Note: this function uses a
793      * `revert` opcode (which leaves remaining gas untouched) while Solidity
794      * uses an invalid opcode to revert (consuming all remaining gas).
795      *
796      * Requirements:
797      *
798      * - The divisor cannot be zero.
799      */
800     function div(
801         uint256 a,
802         uint256 b,
803         string memory errorMessage
804     ) internal pure returns (uint256) {
805         unchecked {
806             require(b > 0, errorMessage);
807             return a / b;
808         }
809     }
810 
811     /**
812      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
813      * reverting with custom message when dividing by zero.
814      *
815      * CAUTION: This function is deprecated because it requires allocating memory for the error
816      * message unnecessarily. For custom revert reasons use {tryMod}.
817      *
818      * Counterpart to Solidity's `%` operator. This function uses a `revert`
819      * opcode (which leaves remaining gas untouched) while Solidity uses an
820      * invalid opcode to revert (consuming all remaining gas).
821      *
822      * Requirements:
823      *
824      * - The divisor cannot be zero.
825      */
826     function mod(
827         uint256 a,
828         uint256 b,
829         string memory errorMessage
830     ) internal pure returns (uint256) {
831         unchecked {
832             require(b > 0, errorMessage);
833             return a % b;
834         }
835     }
836 }
837 
838 /* pragma solidity 0.8.10; */
839 /* pragma experimental ABIEncoderV2; */
840 
841 interface IUniswapV2Factory {
842     event PairCreated(
843         address indexed token0,
844         address indexed token1,
845         address pair,
846         uint256
847     );
848 
849     function feeTo() external view returns (address);
850 
851     function feeToSetter() external view returns (address);
852 
853     function getPair(address tokenA, address tokenB)
854         external
855         view
856         returns (address pair);
857 
858     function allPairs(uint256) external view returns (address pair);
859 
860     function allPairsLength() external view returns (uint256);
861 
862     function createPair(address tokenA, address tokenB)
863         external
864         returns (address pair);
865 
866     function setFeeTo(address) external;
867 
868     function setFeeToSetter(address) external;
869 }
870 
871 /* pragma solidity 0.8.10; */
872 /* pragma experimental ABIEncoderV2; */
873 
874 interface IUniswapV2Pair {
875     event Approval(
876         address indexed owner,
877         address indexed spender,
878         uint256 value
879     );
880     event Transfer(address indexed from, address indexed to, uint256 value);
881 
882     function name() external pure returns (string memory);
883 
884     function symbol() external pure returns (string memory);
885 
886     function decimals() external pure returns (uint8);
887 
888     function totalSupply() external view returns (uint256);
889 
890     function balanceOf(address owner) external view returns (uint256);
891 
892     function allowance(address owner, address spender)
893         external
894         view
895         returns (uint256);
896 
897     function approve(address spender, uint256 value) external returns (bool);
898 
899     function transfer(address to, uint256 value) external returns (bool);
900 
901     function transferFrom(
902         address from,
903         address to,
904         uint256 value
905     ) external returns (bool);
906 
907     function DOMAIN_SEPARATOR() external view returns (bytes32);
908 
909     function PERMIT_TYPEHASH() external pure returns (bytes32);
910 
911     function nonces(address owner) external view returns (uint256);
912 
913     function permit(
914         address owner,
915         address spender,
916         uint256 value,
917         uint256 deadline,
918         uint8 v,
919         bytes32 r,
920         bytes32 s
921     ) external;
922 
923     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
924     event Burn(
925         address indexed sender,
926         uint256 amount0,
927         uint256 amount1,
928         address indexed to
929     );
930     event Swap(
931         address indexed sender,
932         uint256 amount0In,
933         uint256 amount1In,
934         uint256 amount0Out,
935         uint256 amount1Out,
936         address indexed to
937     );
938     event Sync(uint112 reserve0, uint112 reserve1);
939 
940     function MINIMUM_LIQUIDITY() external pure returns (uint256);
941 
942     function factory() external view returns (address);
943 
944     function token0() external view returns (address);
945 
946     function token1() external view returns (address);
947 
948     function getReserves()
949         external
950         view
951         returns (
952             uint112 reserve0,
953             uint112 reserve1,
954             uint32 blockTimestampLast
955         );
956 
957     function price0CumulativeLast() external view returns (uint256);
958 
959     function price1CumulativeLast() external view returns (uint256);
960 
961     function kLast() external view returns (uint256);
962 
963     function mint(address to) external returns (uint256 liquidity);
964 
965     function burn(address to)
966         external
967         returns (uint256 amount0, uint256 amount1);
968 
969     function swap(
970         uint256 amount0Out,
971         uint256 amount1Out,
972         address to,
973         bytes calldata data
974     ) external;
975 
976     function skim(address to) external;
977 
978     function sync() external;
979 
980     function initialize(address, address) external;
981 }
982 
983 /* pragma solidity 0.8.10; */
984 /* pragma experimental ABIEncoderV2; */
985 
986 interface IUniswapV2Router02 {
987     function factory() external pure returns (address);
988 
989     function WETH() external pure returns (address);
990 
991     function addLiquidity(
992         address tokenA,
993         address tokenB,
994         uint256 amountADesired,
995         uint256 amountBDesired,
996         uint256 amountAMin,
997         uint256 amountBMin,
998         address to,
999         uint256 deadline
1000     )
1001         external
1002         returns (
1003             uint256 amountA,
1004             uint256 amountB,
1005             uint256 liquidity
1006         );
1007 
1008     function addLiquidityETH(
1009         address token,
1010         uint256 amountTokenDesired,
1011         uint256 amountTokenMin,
1012         uint256 amountETHMin,
1013         address to,
1014         uint256 deadline
1015     )
1016         external
1017         payable
1018         returns (
1019             uint256 amountToken,
1020             uint256 amountETH,
1021             uint256 liquidity
1022         );
1023 
1024     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1025         uint256 amountIn,
1026         uint256 amountOutMin,
1027         address[] calldata path,
1028         address to,
1029         uint256 deadline
1030     ) external;
1031 
1032     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1033         uint256 amountOutMin,
1034         address[] calldata path,
1035         address to,
1036         uint256 deadline
1037     ) external payable;
1038 
1039     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1040         uint256 amountIn,
1041         uint256 amountOutMin,
1042         address[] calldata path,
1043         address to,
1044         uint256 deadline
1045     ) external;
1046 }
1047 
1048 /* pragma solidity >=0.8.10; */
1049 
1050 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1051 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1052 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1053 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1054 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1055 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1056 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1057 
1058 contract ERIC is ERC20, Ownable {
1059     using SafeMath for uint256;
1060 
1061     IUniswapV2Router02 public immutable uniswapV2Router;
1062     address public immutable uniswapV2Pair;
1063     address public constant deadAddress = address(0xdead);
1064 
1065     bool private swapping;
1066 
1067 	address public charityWallet;
1068     address public marketingWallet;
1069     address public devWallet;
1070 
1071     uint256 public maxTransactionAmount;
1072     uint256 public swapTokensAtAmount;
1073     uint256 public maxWallet;
1074 
1075     bool public limitsInEffect = true;
1076     bool public tradingActive = true;
1077     bool public swapEnabled = true;
1078 
1079     // Anti-bot and anti-whale mappings and variables
1080     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1081     bool public transferDelayEnabled = true;
1082 
1083     uint256 public buyTotalFees;
1084 	uint256 public buyCharityFee;
1085     uint256 public buyMarketingFee;
1086     uint256 public buyLiquidityFee;
1087     uint256 public buyDevFee;
1088 
1089     uint256 public sellTotalFees;
1090 	uint256 public sellCharityFee;
1091     uint256 public sellMarketingFee;
1092     uint256 public sellLiquidityFee;
1093     uint256 public sellDevFee;
1094 
1095 	uint256 public tokensForCharity;
1096     uint256 public tokensForMarketing;
1097     uint256 public tokensForLiquidity;
1098     uint256 public tokensForDev;
1099 
1100     /******************/
1101 
1102     // exlcude from fees and max transaction amount
1103     mapping(address => bool) private _isExcludedFromFees;
1104     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1105 
1106     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1107     // could be subject to a maximum transfer amount
1108     mapping(address => bool) public automatedMarketMakerPairs;
1109 
1110     event UpdateUniswapV2Router(
1111         address indexed newAddress,
1112         address indexed oldAddress
1113     );
1114 
1115     event ExcludeFromFees(address indexed account, bool isExcluded);
1116 
1117     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1118 
1119     event SwapAndLiquify(
1120         uint256 tokensSwapped,
1121         uint256 ethReceived,
1122         uint256 tokensIntoLiquidity
1123     );
1124 
1125     constructor() ERC20("Eric Cartman", "ERIC") {
1126         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1127             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1128         );
1129 
1130         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1131         uniswapV2Router = _uniswapV2Router;
1132 
1133         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1134             .createPair(address(this), _uniswapV2Router.WETH());
1135         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1136         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1137 
1138 		uint256 _buyCharityFee = 0;
1139         uint256 _buyMarketingFee = 0;
1140         uint256 _buyLiquidityFee = 0;
1141         uint256 _buyDevFee = 20;
1142 
1143 		uint256 _sellCharityFee = 0;
1144         uint256 _sellMarketingFee = 0;
1145         uint256 _sellLiquidityFee = 0;
1146         uint256 _sellDevFee = 20;
1147 
1148         uint256 totalSupply = 690000000000 * 1e18;
1149 
1150         maxTransactionAmount = 6900000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1151         maxWallet = 13800000000 * 1e18; // 2% from total supply maxWallet
1152         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1153 
1154 		buyCharityFee = _buyCharityFee;
1155         buyMarketingFee = _buyMarketingFee;
1156         buyLiquidityFee = _buyLiquidityFee;
1157         buyDevFee = _buyDevFee;
1158         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1159 
1160 		sellCharityFee = _sellCharityFee;
1161         sellMarketingFee = _sellMarketingFee;
1162         sellLiquidityFee = _sellLiquidityFee;
1163         sellDevFee = _sellDevFee;
1164         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1165 
1166 		charityWallet = address(0xe262CF1eb75321274B964FC03D207ab71A926370); // 
1167         marketingWallet = address(0xe262CF1eb75321274B964FC03D207ab71A926370); // 
1168         devWallet = address(0x7120B6E8841eFbca71D96207dAfbd5a6f7CFF0E2); // 
1169 
1170         // exclude from paying fees or having max transaction amount
1171         excludeFromFees(owner(), true);
1172         excludeFromFees(address(this), true);
1173         excludeFromFees(address(0xdead), true);
1174 
1175         excludeFromMaxTransaction(owner(), true);
1176         excludeFromMaxTransaction(address(this), true);
1177         excludeFromMaxTransaction(address(0xdead), true);
1178 
1179         /*
1180             _mint is an internal function in ERC20.sol that is only called here,
1181             and CANNOT be called ever again
1182         */
1183         _mint(msg.sender, totalSupply);
1184     }
1185 
1186     receive() external payable {}
1187 
1188     // once enabled, can never be turned off
1189     function enableTrading() external onlyOwner {
1190         tradingActive = true;
1191         swapEnabled = true;
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
1226             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1227             "Cannot set maxTransactionAmount lower than 0.5%"
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
1253 		uint256 _charityFee,
1254         uint256 _marketingFee,
1255         uint256 _liquidityFee,
1256         uint256 _devFee
1257     ) external onlyOwner {
1258 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1259 		buyCharityFee = _charityFee;
1260         buyMarketingFee = _marketingFee;
1261         buyLiquidityFee = _liquidityFee;
1262         buyDevFee = _devFee;
1263         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1264      }
1265 
1266     function updateSellFees(
1267 		uint256 _charityFee,
1268         uint256 _marketingFee,
1269         uint256 _liquidityFee,
1270         uint256 _devFee
1271     ) external onlyOwner {
1272 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1273 		sellCharityFee = _charityFee;
1274         sellMarketingFee = _marketingFee;
1275         sellLiquidityFee = _liquidityFee;
1276         sellDevFee = _devFee;
1277         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1278     }
1279 
1280     function excludeFromFees(address account, bool excluded) public onlyOwner {
1281         _isExcludedFromFees[account] = excluded;
1282         emit ExcludeFromFees(account, excluded);
1283     }
1284 
1285     function setAutomatedMarketMakerPair(address pair, bool value)
1286         public
1287         onlyOwner
1288     {
1289         require(
1290             pair != uniswapV2Pair,
1291             "The pair cannot be removed from automatedMarketMakerPairs"
1292         );
1293 
1294         _setAutomatedMarketMakerPair(pair, value);
1295     }
1296 
1297     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1298         automatedMarketMakerPairs[pair] = value;
1299 
1300         emit SetAutomatedMarketMakerPair(pair, value);
1301     }
1302 
1303     function isExcludedFromFees(address account) public view returns (bool) {
1304         return _isExcludedFromFees[account];
1305     }
1306 
1307     function _transfer(
1308         address from,
1309         address to,
1310         uint256 amount
1311     ) internal override {
1312         require(from != address(0), "ERC20: transfer from the zero address");
1313         require(to != address(0), "ERC20: transfer to the zero address");
1314 
1315         if (amount == 0) {
1316             super._transfer(from, to, 0);
1317             return;
1318         }
1319 
1320         if (limitsInEffect) {
1321             if (
1322                 from != owner() &&
1323                 to != owner() &&
1324                 to != address(0) &&
1325                 to != address(0xdead) &&
1326                 !swapping
1327             ) {
1328                 if (!tradingActive) {
1329                     require(
1330                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1331                         "Trading is not active."
1332                     );
1333                 }
1334 
1335                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1336                 if (transferDelayEnabled) {
1337                     if (
1338                         to != owner() &&
1339                         to != address(uniswapV2Router) &&
1340                         to != address(uniswapV2Pair)
1341                     ) {
1342                         require(
1343                             _holderLastTransferTimestamp[tx.origin] <
1344                                 block.number,
1345                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1346                         );
1347                         _holderLastTransferTimestamp[tx.origin] = block.number;
1348                     }
1349                 }
1350 
1351                 //when buy
1352                 if (
1353                     automatedMarketMakerPairs[from] &&
1354                     !_isExcludedMaxTransactionAmount[to]
1355                 ) {
1356                     require(
1357                         amount <= maxTransactionAmount,
1358                         "Buy transfer amount exceeds the maxTransactionAmount."
1359                     );
1360                     require(
1361                         amount + balanceOf(to) <= maxWallet,
1362                         "Max wallet exceeded"
1363                     );
1364                 }
1365                 //when sell
1366                 else if (
1367                     automatedMarketMakerPairs[to] &&
1368                     !_isExcludedMaxTransactionAmount[from]
1369                 ) {
1370                     require(
1371                         amount <= maxTransactionAmount,
1372                         "Sell transfer amount exceeds the maxTransactionAmount."
1373                     );
1374                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1375                     require(
1376                         amount + balanceOf(to) <= maxWallet,
1377                         "Max wallet exceeded"
1378                     );
1379                 }
1380             }
1381         }
1382 
1383         uint256 contractTokenBalance = balanceOf(address(this));
1384 
1385         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1386 
1387         if (
1388             canSwap &&
1389             swapEnabled &&
1390             !swapping &&
1391             !automatedMarketMakerPairs[from] &&
1392             !_isExcludedFromFees[from] &&
1393             !_isExcludedFromFees[to]
1394         ) {
1395             swapping = true;
1396 
1397             swapBack();
1398 
1399             swapping = false;
1400         }
1401 
1402         bool takeFee = !swapping;
1403 
1404         // if any account belongs to _isExcludedFromFee account then remove the fee
1405         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1406             takeFee = false;
1407         }
1408 
1409         uint256 fees = 0;
1410         // only take fees on buys/sells, do not take on wallet transfers
1411         if (takeFee) {
1412             // on sell
1413             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1414                 fees = amount.mul(sellTotalFees).div(100);
1415 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1416                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1417                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1418                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1419             }
1420             // on buy
1421             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1422                 fees = amount.mul(buyTotalFees).div(100);
1423 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1424                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1425                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1426                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1427             }
1428 
1429             if (fees > 0) {
1430                 super._transfer(from, address(this), fees);
1431             }
1432 
1433             amount -= fees;
1434         }
1435 
1436         super._transfer(from, to, amount);
1437     }
1438 
1439     function swapTokensForEth(uint256 tokenAmount) private {
1440         // generate the uniswap pair path of token -> weth
1441         address[] memory path = new address[](2);
1442         path[0] = address(this);
1443         path[1] = uniswapV2Router.WETH();
1444 
1445         _approve(address(this), address(uniswapV2Router), tokenAmount);
1446 
1447         // make the swap
1448         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1449             tokenAmount,
1450             0, // accept any amount of ETH
1451             path,
1452             address(this),
1453             block.timestamp
1454         );
1455     }
1456 
1457     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1458         // approve token transfer to cover all possible scenarios
1459         _approve(address(this), address(uniswapV2Router), tokenAmount);
1460 
1461         // add the liquidity
1462         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1463             address(this),
1464             tokenAmount,
1465             0, // slippage is unavoidable
1466             0, // slippage is unavoidable
1467             devWallet,
1468             block.timestamp
1469         );
1470     }
1471 
1472     function swapBack() private {
1473         uint256 contractBalance = balanceOf(address(this));
1474         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1475         bool success;
1476 
1477         if (contractBalance == 0 || totalTokensToSwap == 0) {
1478             return;
1479         }
1480 
1481         if (contractBalance > swapTokensAtAmount * 20) {
1482             contractBalance = swapTokensAtAmount * 20;
1483         }
1484 
1485         // Halve the amount of liquidity tokens
1486         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1487         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1488 
1489         uint256 initialETHBalance = address(this).balance;
1490 
1491         swapTokensForEth(amountToSwapForETH);
1492 
1493         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1494 
1495 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1496         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1497         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1498 
1499         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1500 
1501         tokensForLiquidity = 0;
1502 		tokensForCharity = 0;
1503         tokensForMarketing = 0;
1504         tokensForDev = 0;
1505 
1506         (success, ) = address(devWallet).call{value: ethForDev}("");
1507         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1508 
1509 
1510         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1511             addLiquidity(liquidityTokens, ethForLiquidity);
1512             emit SwapAndLiquify(
1513                 amountToSwapForETH,
1514                 ethForLiquidity,
1515                 tokensForLiquidity
1516             );
1517         }
1518 
1519         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1520     }
1521 
1522 }