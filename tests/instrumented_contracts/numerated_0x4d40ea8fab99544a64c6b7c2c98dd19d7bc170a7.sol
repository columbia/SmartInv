1 /*
2 
3 $$\   $$\ $$$$$$$$\        $$\     $$\                                 $$$$$$$\             $$\     
4 $$ |  $$ |$$  _____|       $$ |    $$ |                                $$  __$$\            $$ |    
5 \$$\ $$  |$$ |   $$$$$$\ $$$$$$\   $$$$$$$\   $$$$$$\   $$$$$$\        $$ |  $$ | $$$$$$\ $$$$$$\   
6  \$$$$  / $$$$$\ \____$$\\_$$  _|  $$  __$$\ $$  __$$\ $$  __$$\       $$$$$$$\ |$$  __$$\\_$$  _|  
7  $$  $$<  $$  __|$$$$$$$ | $$ |    $$ |  $$ |$$$$$$$$ |$$ |  \__|      $$  __$$\ $$ /  $$ | $$ |    
8 $$  /\$$\ $$ |  $$  __$$ | $$ |$$\ $$ |  $$ |$$   ____|$$ |            $$ |  $$ |$$ |  $$ | $$ |$$\ 
9 $$ /  $$ |$$ |  \$$$$$$$ | \$$$$  |$$ |  $$ |\$$$$$$$\ $$ |            $$$$$$$  |\$$$$$$  | \$$$$  |
10 \__|  \__|\__|   \_______|  \____/ \__|  \__| \_______|\__|            \_______/  \______/   \____/ 
11                                                                                                     
12                                                                                                     
13 Website: https://xfatherbot.app
14 Telegram: https://t.me/XFatherBotPortal
15 Twitter: https://twitter.com/Xfather_bot           
16 Revenue Share: https://revenueshare.xfatherbot.app                                                                                        
17 
18 */
19 // SPDX-License-Identifier: MIT
20 pragma solidity 0.8.17;
21 pragma experimental ABIEncoderV2;
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 /**
44  * @dev Contract module which provides a basic access control mechanism, where
45  * there is an account (an owner) that can be granted exclusive access to
46  * specific functions.
47  *
48  * By default, the owner account will be the one that deploys the contract. This
49  * can later be changed with {transferOwnership}.
50  *
51  * This module is used through inheritance. It will make available the modifier
52  * `onlyOwner`, which can be applied to your functions to restrict their use to
53  * the owner.
54  */
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(
59         address indexed previousOwner,
60         address indexed newOwner
61     );
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(
102             newOwner != address(0),
103             "Ownable: new owner is the zero address"
104         );
105         _transferOwnership(newOwner);
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Internal function without access restriction.
111      */
112     function _transferOwnership(address newOwner) internal virtual {
113         address oldOwner = _owner;
114         _owner = newOwner;
115         emit OwnershipTransferred(oldOwner, newOwner);
116     }
117 }
118 
119 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
120 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
121 
122 /* pragma solidity ^0.8.0; */
123 
124 /**
125  * @dev Interface of the ERC20 standard as defined in the EIP.
126  */
127 interface IERC20 {
128     /**
129      * @dev Returns the amount of tokens in existence.
130      */
131     function totalSupply() external view returns (uint256);
132 
133     /**
134      * @dev Returns the amount of tokens owned by `account`.
135      */
136     function balanceOf(address account) external view returns (uint256);
137 
138     /**
139      * @dev Moves `amount` tokens from the caller's account to `recipient`.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transfer(
146         address recipient,
147         uint256 amount
148     ) external returns (bool);
149 
150     /**
151      * @dev Returns the remaining number of tokens that `spender` will be
152      * allowed to spend on behalf of `owner` through {transferFrom}. This is
153      * zero by default.
154      *
155      * This value changes when {approve} or {transferFrom} are called.
156      */
157     function allowance(
158         address owner,
159         address spender
160     ) external view returns (uint256);
161 
162     /**
163      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * IMPORTANT: Beware that changing an allowance with this method brings the risk
168      * that someone may use both the old and the new allowance by unfortunate
169      * transaction ordering. One possible solution to mitigate this race
170      * condition is to first reduce the spender's allowance to 0 and set the
171      * desired value afterwards:
172      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173      *
174      * Emits an {Approval} event.
175      */
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178     /**
179      * @dev Moves `amount` tokens from `sender` to `recipient` using the
180      * allowance mechanism. `amount` is then deducted from the caller's
181      * allowance.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transferFrom(
188         address sender,
189         address recipient,
190         uint256 amount
191     ) external returns (bool);
192 
193     /**
194      * @dev Emitted when `value` tokens are moved from one account (`from`) to
195      * another (`to`).
196      *
197      * Note that `value` may be zero.
198      */
199     event Transfer(address indexed from, address indexed to, uint256 value);
200 
201     /**
202      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
203      * a call to {approve}. `value` is the new allowance.
204      */
205     event Approval(
206         address indexed owner,
207         address indexed spender,
208         uint256 value
209     );
210 }
211 
212 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
213 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
214 
215 /* pragma solidity ^0.8.0; */
216 
217 /* import "../IERC20.sol"; */
218 
219 /**
220  * @dev Interface for the optional metadata functions from the ERC20 standard.
221  *
222  * _Available since v4.1._
223  */
224 interface IERC20Metadata is IERC20 {
225     /**
226      * @dev Returns the name of the token.
227      */
228     function name() external view returns (string memory);
229 
230     /**
231      * @dev Returns the symbol of the token.
232      */
233     function symbol() external view returns (string memory);
234 
235     /**
236      * @dev Returns the decimals places of the token.
237      */
238     function decimals() external view returns (uint8);
239 }
240 
241 /**
242  * @dev Implementation of the {IERC20} interface.
243  *
244  * This implementation is agnostic to the way tokens are created. This means
245  * that a supply mechanism has to be added in a derived contract using {_mint}.
246  * For a generic mechanism see {ERC20PresetMinterPauser}.
247  *
248  * TIP: For a detailed writeup see our guide
249  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
250  * to implement supply mechanisms].
251  *
252  * We have followed general OpenZeppelin Contracts guidelines: functions revert
253  * instead returning `false` on failure. This behavior is nonetheless
254  * conventional and does not conflict with the expectations of ERC20
255  * applications.
256  *
257  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
258  * This allows applications to reconstruct the allowance for all accounts just
259  * by listening to said events. Other implementations of the EIP may not emit
260  * these events, as it isn't required by the specification.
261  *
262  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
263  * functions have been added to mitigate the well-known issues around setting
264  * allowances. See {IERC20-approve}.
265  */
266 contract ERC20 is Context, IERC20, IERC20Metadata {
267     mapping(address => uint256) private _balances;
268 
269     mapping(address => mapping(address => uint256)) private _allowances;
270 
271     uint256 private _totalSupply;
272 
273     string private _name;
274     string private _symbol;
275 
276     /**
277      * @dev Sets the values for {name} and {symbol}.
278      *
279      * The default value of {decimals} is 18. To select a different value for
280      * {decimals} you should overload it.
281      *
282      * All two of these values are immutable: they can only be set once during
283      * construction.
284      */
285     constructor(string memory name_, string memory symbol_) {
286         _name = name_;
287         _symbol = symbol_;
288     }
289 
290     /**
291      * @dev Returns the name of the token.
292      */
293     function name() public view virtual override returns (string memory) {
294         return _name;
295     }
296 
297     /**
298      * @dev Returns the symbol of the token, usually a shorter version of the
299      * name.
300      */
301     function symbol() public view virtual override returns (string memory) {
302         return _symbol;
303     }
304 
305     /**
306      * @dev Returns the number of decimals used to get its user representation.
307      * For example, if `decimals` equals `2`, a balance of `505` tokens should
308      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
309      *
310      * Tokens usually opt for a value of 18, imitating the relationship between
311      * Ether and Wei. This is the value {ERC20} uses, unless this function is
312      * overridden;
313      *
314      * NOTE: This information is only used for _display_ purposes: it in
315      * no way affects any of the arithmetic of the contract, including
316      * {IERC20-balanceOf} and {IERC20-transfer}.
317      */
318     function decimals() public view virtual override returns (uint8) {
319         return 18;
320     }
321 
322     /**
323      * @dev See {IERC20-totalSupply}.
324      */
325     function totalSupply() public view virtual override returns (uint256) {
326         return _totalSupply;
327     }
328 
329     /**
330      * @dev See {IERC20-balanceOf}.
331      */
332     function balanceOf(
333         address account
334     ) public view virtual override returns (uint256) {
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
346     function transfer(
347         address recipient,
348         uint256 amount
349     ) public virtual override returns (bool) {
350         _transfer(_msgSender(), recipient, amount);
351         return true;
352     }
353 
354     /**
355      * @dev See {IERC20-allowance}.
356      */
357     function allowance(
358         address owner,
359         address spender
360     ) public view virtual override returns (uint256) {
361         return _allowances[owner][spender];
362     }
363 
364     /**
365      * @dev See {IERC20-approve}.
366      *
367      * Requirements:
368      *
369      * - `spender` cannot be the zero address.
370      */
371     function approve(
372         address spender,
373         uint256 amount
374     ) public virtual override returns (bool) {
375         _approve(_msgSender(), spender, amount);
376         return true;
377     }
378 
379     /**
380      * @dev See {IERC20-transferFrom}.
381      *
382      * Emits an {Approval} event indicating the updated allowance. This is not
383      * required by the EIP. See the note at the beginning of {ERC20}.
384      *
385      * Requirements:
386      *
387      * - `sender` and `recipient` cannot be the zero address.
388      * - `sender` must have a balance of at least `amount`.
389      * - the caller must have allowance for ``sender``'s tokens of at least
390      * `amount`.
391      */
392     function transferFrom(
393         address sender,
394         address recipient,
395         uint256 amount
396     ) public virtual override returns (bool) {
397         _transfer(sender, recipient, amount);
398 
399         uint256 currentAllowance = _allowances[sender][_msgSender()];
400         require(
401             currentAllowance >= amount,
402             "ERC20: transfer amount exceeds allowance"
403         );
404         unchecked {
405             _approve(sender, _msgSender(), currentAllowance - amount);
406         }
407 
408         return true;
409     }
410 
411     /**
412      * @dev Atomically increases the allowance granted to `spender` by the caller.
413      *
414      * This is an alternative to {approve} that can be used as a mitigation for
415      * problems described in {IERC20-approve}.
416      *
417      * Emits an {Approval} event indicating the updated allowance.
418      *
419      * Requirements:
420      *
421      * - `spender` cannot be the zero address.
422      */
423     function increaseAllowance(
424         address spender,
425         uint256 addedValue
426     ) public virtual returns (bool) {
427         _approve(
428             _msgSender(),
429             spender,
430             _allowances[_msgSender()][spender] + addedValue
431         );
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
449     function decreaseAllowance(
450         address spender,
451         uint256 subtractedValue
452     ) public virtual returns (bool) {
453         uint256 currentAllowance = _allowances[_msgSender()][spender];
454         require(
455             currentAllowance >= subtractedValue,
456             "ERC20: decreased allowance below zero"
457         );
458         unchecked {
459             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
460         }
461 
462         return true;
463     }
464 
465     /**
466      * @dev Moves `amount` of tokens from `sender` to `recipient`.
467      *
468      * This internal function is equivalent to {transfer}, and can be used to
469      * e.g. implement automatic token fees, slashing mechanisms, etc.
470      *
471      * Emits a {Transfer} event.
472      *
473      * Requirements:
474      *
475      * - `sender` cannot be the zero address.
476      * - `recipient` cannot be the zero address.
477      * - `sender` must have a balance of at least `amount`.
478      */
479     function _transfer(
480         address sender,
481         address recipient,
482         uint256 amount
483     ) internal virtual {
484         require(sender != address(0), "ERC20: transfer from the zero address");
485         require(recipient != address(0), "ERC20: transfer to the zero address");
486 
487         _beforeTokenTransfer(sender, recipient, amount);
488 
489         uint256 senderBalance = _balances[sender];
490         require(
491             senderBalance >= amount,
492             "ERC20: transfer amount exceeds balance"
493         );
494         unchecked {
495             _balances[sender] = senderBalance - amount;
496         }
497         _balances[recipient] += amount;
498 
499         emit Transfer(sender, recipient, amount);
500 
501         _afterTokenTransfer(sender, recipient, amount);
502     }
503 
504     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
505      * the total supply.
506      *
507      * Emits a {Transfer} event with `from` set to the zero address.
508      *
509      * Requirements:
510      *
511      * - `account` cannot be the zero address.
512      */
513     function _mint(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: mint to the zero address");
515 
516         _beforeTokenTransfer(address(0), account, amount);
517 
518         _totalSupply += amount;
519         _balances[account] += amount;
520         emit Transfer(address(0), account, amount);
521 
522         _afterTokenTransfer(address(0), account, amount);
523     }
524 
525     /**
526      * @dev Destroys `amount` tokens from `account`, reducing the
527      * total supply.
528      *
529      * Emits a {Transfer} event with `to` set to the zero address.
530      *
531      * Requirements:
532      *
533      * - `account` cannot be the zero address.
534      * - `account` must have at least `amount` tokens.
535      */
536     function _burn(address account, uint256 amount) internal virtual {
537         require(account != address(0), "ERC20: burn from the zero address");
538 
539         _beforeTokenTransfer(account, address(0), amount);
540 
541         uint256 accountBalance = _balances[account];
542         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
543         unchecked {
544             _balances[account] = accountBalance - amount;
545         }
546         _totalSupply -= amount;
547 
548         emit Transfer(account, address(0), amount);
549 
550         _afterTokenTransfer(account, address(0), amount);
551     }
552 
553     /**
554      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
555      *
556      * This internal function is equivalent to `approve`, and can be used to
557      * e.g. set automatic allowances for certain subsystems, etc.
558      *
559      * Emits an {Approval} event.
560      *
561      * Requirements:
562      *
563      * - `owner` cannot be the zero address.
564      * - `spender` cannot be the zero address.
565      */
566     function _approve(
567         address owner,
568         address spender,
569         uint256 amount
570     ) internal virtual {
571         require(owner != address(0), "ERC20: approve from the zero address");
572         require(spender != address(0), "ERC20: approve to the zero address");
573 
574         _allowances[owner][spender] = amount;
575         emit Approval(owner, spender, amount);
576     }
577 
578     /**
579      * @dev Hook that is called before any transfer of tokens. This includes
580      * minting and burning.
581      *
582      * Calling conditions:
583      *
584      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
585      * will be transferred to `to`.
586      * - when `from` is zero, `amount` tokens will be minted for `to`.
587      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
588      * - `from` and `to` are never both zero.
589      *
590      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
591      */
592     function _beforeTokenTransfer(
593         address from,
594         address to,
595         uint256 amount
596     ) internal virtual {}
597 
598     /**
599      * @dev Hook that is called after any transfer of tokens. This includes
600      * minting and burning.
601      *
602      * Calling conditions:
603      *
604      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
605      * has been transferred to `to`.
606      * - when `from` is zero, `amount` tokens have been minted for `to`.
607      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
608      * - `from` and `to` are never both zero.
609      *
610      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
611      */
612     function _afterTokenTransfer(
613         address from,
614         address to,
615         uint256 amount
616     ) internal virtual {}
617 }
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
631     function tryAdd(
632         uint256 a,
633         uint256 b
634     ) internal pure returns (bool, uint256) {
635         unchecked {
636             uint256 c = a + b;
637             if (c < a) return (false, 0);
638             return (true, c);
639         }
640     }
641 
642     /**
643      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
644      *
645      * _Available since v3.4._
646      */
647     function trySub(
648         uint256 a,
649         uint256 b
650     ) internal pure returns (bool, uint256) {
651         unchecked {
652             if (b > a) return (false, 0);
653             return (true, a - b);
654         }
655     }
656 
657     /**
658      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
659      *
660      * _Available since v3.4._
661      */
662     function tryMul(
663         uint256 a,
664         uint256 b
665     ) internal pure returns (bool, uint256) {
666         unchecked {
667             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
668             // benefit is lost if 'b' is also tested.
669             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
670             if (a == 0) return (true, 0);
671             uint256 c = a * b;
672             if (c / a != b) return (false, 0);
673             return (true, c);
674         }
675     }
676 
677     /**
678      * @dev Returns the division of two unsigned integers, with a division by zero flag.
679      *
680      * _Available since v3.4._
681      */
682     function tryDiv(
683         uint256 a,
684         uint256 b
685     ) internal pure returns (bool, uint256) {
686         unchecked {
687             if (b == 0) return (false, 0);
688             return (true, a / b);
689         }
690     }
691 
692     /**
693      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
694      *
695      * _Available since v3.4._
696      */
697     function tryMod(
698         uint256 a,
699         uint256 b
700     ) internal pure returns (bool, uint256) {
701         unchecked {
702             if (b == 0) return (false, 0);
703             return (true, a % b);
704         }
705     }
706 
707     /**
708      * @dev Returns the addition of two unsigned integers, reverting on
709      * overflow.
710      *
711      * Counterpart to Solidity's `+` operator.
712      *
713      * Requirements:
714      *
715      * - Addition cannot overflow.
716      */
717     function add(uint256 a, uint256 b) internal pure returns (uint256) {
718         return a + b;
719     }
720 
721     /**
722      * @dev Returns the subtraction of two unsigned integers, reverting on
723      * overflow (when the result is negative).
724      *
725      * Counterpart to Solidity's `-` operator.
726      *
727      * Requirements:
728      *
729      * - Subtraction cannot overflow.
730      */
731     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
732         return a - b;
733     }
734 
735     /**
736      * @dev Returns the multiplication of two unsigned integers, reverting on
737      * overflow.
738      *
739      * Counterpart to Solidity's `*` operator.
740      *
741      * Requirements:
742      *
743      * - Multiplication cannot overflow.
744      */
745     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
746         return a * b;
747     }
748 
749     /**
750      * @dev Returns the integer division of two unsigned integers, reverting on
751      * division by zero. The result is rounded towards zero.
752      *
753      * Counterpart to Solidity's `/` operator.
754      *
755      * Requirements:
756      *
757      * - The divisor cannot be zero.
758      */
759     function div(uint256 a, uint256 b) internal pure returns (uint256) {
760         return a / b;
761     }
762 
763     /**
764      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
765      * reverting when dividing by zero.
766      *
767      * Counterpart to Solidity's `%` operator. This function uses a `revert`
768      * opcode (which leaves remaining gas untouched) while Solidity uses an
769      * invalid opcode to revert (consuming all remaining gas).
770      *
771      * Requirements:
772      *
773      * - The divisor cannot be zero.
774      */
775     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
776         return a % b;
777     }
778 
779     /**
780      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
781      * overflow (when the result is negative).
782      *
783      * CAUTION: This function is deprecated because it requires allocating memory for the error
784      * message unnecessarily. For custom revert reasons use {trySub}.
785      *
786      * Counterpart to Solidity's `-` operator.
787      *
788      * Requirements:
789      *
790      * - Subtraction cannot overflow.
791      */
792     function sub(
793         uint256 a,
794         uint256 b,
795         string memory errorMessage
796     ) internal pure returns (uint256) {
797         unchecked {
798             require(b <= a, errorMessage);
799             return a - b;
800         }
801     }
802 
803     /**
804      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
805      * division by zero. The result is rounded towards zero.
806      *
807      * Counterpart to Solidity's `/` operator. Note: this function uses a
808      * `revert` opcode (which leaves remaining gas untouched) while Solidity
809      * uses an invalid opcode to revert (consuming all remaining gas).
810      *
811      * Requirements:
812      *
813      * - The divisor cannot be zero.
814      */
815     function div(
816         uint256 a,
817         uint256 b,
818         string memory errorMessage
819     ) internal pure returns (uint256) {
820         unchecked {
821             require(b > 0, errorMessage);
822             return a / b;
823         }
824     }
825 
826     /**
827      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
828      * reverting with custom message when dividing by zero.
829      *
830      * CAUTION: This function is deprecated because it requires allocating memory for the error
831      * message unnecessarily. For custom revert reasons use {tryMod}.
832      *
833      * Counterpart to Solidity's `%` operator. This function uses a `revert`
834      * opcode (which leaves remaining gas untouched) while Solidity uses an
835      * invalid opcode to revert (consuming all remaining gas).
836      *
837      * Requirements:
838      *
839      * - The divisor cannot be zero.
840      */
841     function mod(
842         uint256 a,
843         uint256 b,
844         string memory errorMessage
845     ) internal pure returns (uint256) {
846         unchecked {
847             require(b > 0, errorMessage);
848             return a % b;
849         }
850     }
851 }
852 
853 interface IUniswapV2Factory {
854     event PairCreated(
855         address indexed token0,
856         address indexed token1,
857         address pair,
858         uint256
859     );
860 
861     function feeTo() external view returns (address);
862 
863     function feeToSetter() external view returns (address);
864 
865     function getPair(
866         address tokenA,
867         address tokenB
868     ) external view returns (address pair);
869 
870     function allPairs(uint256) external view returns (address pair);
871 
872     function allPairsLength() external view returns (uint256);
873 
874     function createPair(
875         address tokenA,
876         address tokenB
877     ) external returns (address pair);
878 
879     function setFeeTo(address) external;
880 
881     function setFeeToSetter(address) external;
882 }
883 
884 ////// src/IUniswapV2Pair.sol
885 /* pragma solidity 0.8.10; */
886 /* pragma experimental ABIEncoderV2; */
887 
888 interface IUniswapV2Pair {
889     event Approval(
890         address indexed owner,
891         address indexed spender,
892         uint256 value
893     );
894     event Transfer(address indexed from, address indexed to, uint256 value);
895 
896     function name() external pure returns (string memory);
897 
898     function symbol() external pure returns (string memory);
899 
900     function decimals() external pure returns (uint8);
901 
902     function totalSupply() external view returns (uint256);
903 
904     function balanceOf(address owner) external view returns (uint256);
905 
906     function allowance(
907         address owner,
908         address spender
909     ) external view returns (uint256);
910 
911     function approve(address spender, uint256 value) external returns (bool);
912 
913     function transfer(address to, uint256 value) external returns (bool);
914 
915     function transferFrom(
916         address from,
917         address to,
918         uint256 value
919     ) external returns (bool);
920 
921     function DOMAIN_SEPARATOR() external view returns (bytes32);
922 
923     function PERMIT_TYPEHASH() external pure returns (bytes32);
924 
925     function nonces(address owner) external view returns (uint256);
926 
927     function permit(
928         address owner,
929         address spender,
930         uint256 value,
931         uint256 deadline,
932         uint8 v,
933         bytes32 r,
934         bytes32 s
935     ) external;
936 
937     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
938     event Burn(
939         address indexed sender,
940         uint256 amount0,
941         uint256 amount1,
942         address indexed to
943     );
944     event Swap(
945         address indexed sender,
946         uint256 amount0In,
947         uint256 amount1In,
948         uint256 amount0Out,
949         uint256 amount1Out,
950         address indexed to
951     );
952     event Sync(uint112 reserve0, uint112 reserve1);
953 
954     function MINIMUM_LIQUIDITY() external pure returns (uint256);
955 
956     function factory() external view returns (address);
957 
958     function token0() external view returns (address);
959 
960     function token1() external view returns (address);
961 
962     function getReserves()
963         external
964         view
965         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
966 
967     function price0CumulativeLast() external view returns (uint256);
968 
969     function price1CumulativeLast() external view returns (uint256);
970 
971     function kLast() external view returns (uint256);
972 
973     function mint(address to) external returns (uint256 liquidity);
974 
975     function burn(
976         address to
977     ) external returns (uint256 amount0, uint256 amount1);
978 
979     function swap(
980         uint256 amount0Out,
981         uint256 amount1Out,
982         address to,
983         bytes calldata data
984     ) external;
985 
986     function skim(address to) external;
987 
988     function sync() external;
989 
990     function initialize(address, address) external;
991 }
992 
993 interface IUniswapV2Router02 {
994     function factory() external pure returns (address);
995 
996     function WETH() external pure returns (address);
997 
998     function addLiquidity(
999         address tokenA,
1000         address tokenB,
1001         uint256 amountADesired,
1002         uint256 amountBDesired,
1003         uint256 amountAMin,
1004         uint256 amountBMin,
1005         address to,
1006         uint256 deadline
1007     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
1008 
1009     function addLiquidityETH(
1010         address token,
1011         uint256 amountTokenDesired,
1012         uint256 amountTokenMin,
1013         uint256 amountETHMin,
1014         address to,
1015         uint256 deadline
1016     )
1017         external
1018         payable
1019         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
1020 
1021     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1022         uint256 amountIn,
1023         uint256 amountOutMin,
1024         address[] calldata path,
1025         address to,
1026         uint256 deadline
1027     ) external;
1028 
1029     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1030         uint256 amountOutMin,
1031         address[] calldata path,
1032         address to,
1033         uint256 deadline
1034     ) external payable;
1035 
1036     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1037         uint256 amountIn,
1038         uint256 amountOutMin,
1039         address[] calldata path,
1040         address to,
1041         uint256 deadline
1042     ) external;
1043 }
1044 
1045 contract XFatherBot is ERC20, Ownable {
1046     using SafeMath for uint256;
1047 
1048     IUniswapV2Router02 public immutable uniswapV2Router;
1049     address public immutable uniswapV2Pair;
1050     address public constant deadAddress = address(0xdead);
1051 
1052     bool private swapping;
1053 
1054     address public revShareWallet;
1055     address public teamWallet;
1056 
1057     uint256 public maxTransactionAmount;
1058     uint256 public swapTokensAtAmount;
1059     uint256 public maxWallet;
1060 
1061     bool public limitsInEffect = true;
1062     bool public tradingActive = false;
1063     bool public swapEnabled = false;
1064 
1065     bool public blacklistRenounced = false;
1066 
1067     // Anti-bot and anti-whale mappings and variables
1068     mapping(address => bool) blacklisted;
1069 
1070     uint256 public buyTotalFees;
1071     uint256 public buyRevShareFee;
1072     uint256 public buyLiquidityFee;
1073     uint256 public buyTeamFee;
1074 
1075     uint256 public sellTotalFees;
1076     uint256 public sellRevShareFee;
1077     uint256 public sellLiquidityFee;
1078     uint256 public sellTeamFee;
1079 
1080     uint256 public tokensForRevShare;
1081     uint256 public tokensForLiquidity;
1082     uint256 public tokensForTeam;
1083 
1084     /******************/
1085 
1086     // exclude from fees and max transaction amount
1087     mapping(address => bool) private _isExcludedFromFees;
1088     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1089 
1090     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1091     // could be subject to a maximum transfer amount
1092     mapping(address => bool) public automatedMarketMakerPairs;
1093 
1094     bool public preMigrationPhase = true;
1095     mapping(address => bool) public preMigrationTransferrable;
1096 
1097     event UpdateUniswapV2Router(
1098         address indexed newAddress,
1099         address indexed oldAddress
1100     );
1101 
1102     event ExcludeFromFees(address indexed account, bool isExcluded);
1103 
1104     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1105 
1106     event revShareWalletUpdated(
1107         address indexed newWallet,
1108         address indexed oldWallet
1109     );
1110 
1111     event teamWalletUpdated(
1112         address indexed newWallet,
1113         address indexed oldWallet
1114     );
1115 
1116     event SwapAndLiquify(
1117         uint256 tokensSwapped,
1118         uint256 ethReceived,
1119         uint256 tokensIntoLiquidity
1120     );
1121 
1122     constructor(
1123         address _addressOne
1124     ) ERC20("XFather Bot", "XFBOT") {
1125         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1126             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1127         );
1128 
1129         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1130         uniswapV2Router = _uniswapV2Router;
1131 
1132         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1133             .createPair(address(this), _uniswapV2Router.WETH());
1134         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1135         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1136 
1137         uint256 _buyRevShareFee = 2;
1138         uint256 _buyLiquidityFee = 1;
1139         uint256 _buyTeamFee = 2;
1140 
1141         uint256 _sellRevShareFee = 2;
1142         uint256 _sellLiquidityFee = 1;
1143         uint256 _sellTeamFee = 2;
1144 
1145         uint256 totalSupply = 500_000_000 * 1e18;
1146 
1147         maxTransactionAmount = 5_000_000 * 1e18; // 1%
1148         maxWallet = 5_000_000 * 1e18; // 1%
1149         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05%
1150 
1151         buyRevShareFee = _buyRevShareFee;
1152         buyLiquidityFee = _buyLiquidityFee;
1153         buyTeamFee = _buyTeamFee;
1154         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1155 
1156         sellRevShareFee = _sellRevShareFee;
1157         sellLiquidityFee = _sellLiquidityFee;
1158         sellTeamFee = _sellTeamFee;
1159         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1160 
1161         revShareWallet = address(0xFD236a7fc2C15F5eD9CAAD99c2C70494e6424fd3); // set as revShare wallet
1162         teamWallet = _addressOne; // set as team wallet
1163 
1164         // exclude from paying fees or having max transaction amount
1165         excludeFromFees(owner(), true);
1166         excludeFromFees(address(this), true);
1167         excludeFromFees(address(0xdead), true);
1168 
1169         excludeFromMaxTransaction(owner(), true);
1170         excludeFromMaxTransaction(address(this), true);
1171         excludeFromMaxTransaction(address(0xdead), true);
1172 
1173         preMigrationTransferrable[owner()] = true;
1174 
1175         /*
1176             _mint is an internal function in ERC20.sol that is only called here,
1177             and CANNOT be called ever again
1178         */
1179         _mint(msg.sender, totalSupply);
1180     }
1181 
1182     receive() external payable {}
1183 
1184     // once enabled, can never be turned off
1185     function enableTrading() external onlyOwner {
1186         tradingActive = true;
1187         swapEnabled = true;
1188         preMigrationPhase = false;
1189 
1190         buyRevShareFee = 2;
1191         buyLiquidityFee = 3;
1192         buyTeamFee = 10;
1193         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1194 
1195         sellRevShareFee = 2;
1196         sellLiquidityFee = 3;
1197         sellTeamFee = 10;
1198         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1199     }
1200 
1201     function removeLimitsFee() external onlyOwner {
1202         buyRevShareFee = 2;
1203         buyLiquidityFee = 1;
1204         buyTeamFee = 2;
1205         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1206 
1207         sellRevShareFee = 2;
1208         sellLiquidityFee = 1;
1209         sellTeamFee = 2;
1210         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1211     }
1212 
1213     // remove limits after token is stable
1214     function removeLimits() external onlyOwner returns (bool) {
1215         limitsInEffect = false;
1216         return true;
1217     }
1218 
1219     // change the minimum amount of tokens to sell from fees
1220     function updateSwapTokensAtAmount(
1221         uint256 newAmount
1222     ) external onlyOwner returns (bool) {
1223         require(
1224             newAmount >= (totalSupply() * 1) / 100000,
1225             "Swap amount cannot be lower than 0.001% total supply."
1226         );
1227         require(
1228             newAmount <= (totalSupply() * 5) / 1000,
1229             "Swap amount cannot be higher than 0.5% total supply."
1230         );
1231         swapTokensAtAmount = newAmount;
1232         return true;
1233     }
1234 
1235     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1236         require(
1237             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1238             "Cannot set maxTransactionAmount lower than 0.5%"
1239         );
1240         maxTransactionAmount = newNum * (10 ** 18);
1241     }
1242 
1243     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1244         require(
1245             newNum >= ((totalSupply() * 10) / 1000) / 1e18,
1246             "Cannot set maxWallet lower than 1.0%"
1247         );
1248         maxWallet = newNum * (10 ** 18);
1249     }
1250 
1251     function excludeFromMaxTransaction(
1252         address updAds,
1253         bool isEx
1254     ) public onlyOwner {
1255         _isExcludedMaxTransactionAmount[updAds] = isEx;
1256     }
1257 
1258     // only use to disable contract sales if absolutely necessary (emergency use only)
1259     function updateSwapEnabled(bool enabled) external onlyOwner {
1260         swapEnabled = enabled;
1261     }
1262 
1263     function updateBuyFees(
1264         uint256 _revShareFee,
1265         uint256 _liquidityFee,
1266         uint256 _teamFee
1267     ) external onlyOwner {
1268         buyRevShareFee = _revShareFee;
1269         buyLiquidityFee = _liquidityFee;
1270         buyTeamFee = _teamFee;
1271         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1272         require(buyTotalFees <= 5, "Buy fees must be <= 5.");
1273     }
1274 
1275     function updateSellFees(
1276         uint256 _revShareFee,
1277         uint256 _liquidityFee,
1278         uint256 _teamFee
1279     ) external onlyOwner {
1280         sellRevShareFee = _revShareFee;
1281         sellLiquidityFee = _liquidityFee;
1282         sellTeamFee = _teamFee;
1283         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1284         require(sellTotalFees <= 5, "Sell fees must be <= 5.");
1285     }
1286 
1287     function excludeFromFees(address account, bool excluded) public onlyOwner {
1288         _isExcludedFromFees[account] = excluded;
1289         emit ExcludeFromFees(account, excluded);
1290     }
1291 
1292     function setAutomatedMarketMakerPair(
1293         address pair,
1294         bool value
1295     ) public onlyOwner {
1296         require(
1297             pair != uniswapV2Pair,
1298             "The pair cannot be removed from automatedMarketMakerPairs"
1299         );
1300 
1301         _setAutomatedMarketMakerPair(pair, value);
1302     }
1303 
1304     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1305         automatedMarketMakerPairs[pair] = value;
1306 
1307         emit SetAutomatedMarketMakerPair(pair, value);
1308     }
1309 
1310     function updateRevShareWallet(
1311         address newRevShareWallet
1312     ) external onlyOwner {
1313         emit revShareWalletUpdated(newRevShareWallet, revShareWallet);
1314         revShareWallet = newRevShareWallet;
1315     }
1316 
1317     function updateTeamWallet(address newWallet) external onlyOwner {
1318         emit teamWalletUpdated(newWallet, teamWallet);
1319         teamWallet = newWallet;
1320     }
1321 
1322     function isExcludedFromFees(address account) public view returns (bool) {
1323         return _isExcludedFromFees[account];
1324     }
1325 
1326     function isBlacklisted(address account) public view returns (bool) {
1327         return blacklisted[account];
1328     }
1329 
1330     function _transfer(
1331         address from,
1332         address to,
1333         uint256 amount
1334     ) internal override {
1335         require(from != address(0), "ERC20: transfer from the zero address");
1336         require(to != address(0), "ERC20: transfer to the zero address");
1337         require(!blacklisted[from], "Sender blacklisted");
1338         require(!blacklisted[to], "Receiver blacklisted");
1339 
1340         if (preMigrationPhase) {
1341             require(
1342                 preMigrationTransferrable[from],
1343                 "Not authorized to transfer pre-migration."
1344             );
1345         }
1346 
1347         if (amount == 0) {
1348             super._transfer(from, to, 0);
1349             return;
1350         }
1351 
1352         if (limitsInEffect) {
1353             if (
1354                 from != owner() &&
1355                 to != owner() &&
1356                 to != address(0) &&
1357                 to != address(0xdead) &&
1358                 !swapping
1359             ) {
1360                 if (!tradingActive) {
1361                     require(
1362                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1363                         "Trading is not active."
1364                     );
1365                 }
1366 
1367                 //when buy
1368                 if (
1369                     automatedMarketMakerPairs[from] &&
1370                     !_isExcludedMaxTransactionAmount[to]
1371                 ) {
1372                     require(
1373                         amount <= maxTransactionAmount,
1374                         "Buy transfer amount exceeds the maxTransactionAmount."
1375                     );
1376                     require(
1377                         amount + balanceOf(to) <= maxWallet,
1378                         "Max wallet exceeded"
1379                     );
1380                 }
1381                 //when sell
1382                 else if (
1383                     automatedMarketMakerPairs[to] &&
1384                     !_isExcludedMaxTransactionAmount[from]
1385                 ) {
1386                     require(
1387                         amount <= maxTransactionAmount,
1388                         "Sell transfer amount exceeds the maxTransactionAmount."
1389                     );
1390                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1391                     require(
1392                         amount + balanceOf(to) <= maxWallet,
1393                         "Max wallet exceeded"
1394                     );
1395                 }
1396             }
1397         }
1398 
1399         uint256 contractTokenBalance = balanceOf(address(this));
1400 
1401         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1402 
1403         if (
1404             canSwap &&
1405             swapEnabled &&
1406             !swapping &&
1407             !automatedMarketMakerPairs[from] &&
1408             !_isExcludedFromFees[from] &&
1409             !_isExcludedFromFees[to]
1410         ) {
1411             swapping = true;
1412 
1413             swapBack();
1414 
1415             swapping = false;
1416         }
1417 
1418         bool takeFee = !swapping;
1419 
1420         // if any account belongs to _isExcludedFromFee account then remove the fee
1421         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1422             takeFee = false;
1423         }
1424 
1425         uint256 fees = 0;
1426         // only take fees on buys/sells, do not take on wallet transfers
1427         if (takeFee) {
1428             // on sell
1429             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1430                 fees = amount.mul(sellTotalFees).div(100);
1431                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1432                 tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
1433                 tokensForRevShare += (fees * sellRevShareFee) / sellTotalFees;
1434             }
1435             // on buy
1436             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1437                 fees = amount.mul(buyTotalFees).div(100);
1438                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1439                 tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
1440                 tokensForRevShare += (fees * buyRevShareFee) / buyTotalFees;
1441             }
1442 
1443             if (fees > 0) {
1444                 super._transfer(from, address(this), fees);
1445             }
1446 
1447             amount -= fees;
1448         }
1449 
1450         super._transfer(from, to, amount);
1451     }
1452 
1453     function swapTokensForEth(uint256 tokenAmount) private {
1454         // generate the uniswap pair path of token -> weth
1455         address[] memory path = new address[](2);
1456         path[0] = address(this);
1457         path[1] = uniswapV2Router.WETH();
1458 
1459         _approve(address(this), address(uniswapV2Router), tokenAmount);
1460 
1461         // make the swap
1462         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1463             tokenAmount,
1464             0, // accept any amount of ETH
1465             path,
1466             address(this),
1467             block.timestamp
1468         );
1469     }
1470 
1471     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1472         // approve token transfer to cover all possible scenarios
1473         _approve(address(this), address(uniswapV2Router), tokenAmount);
1474 
1475         // add the liquidity
1476         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1477             address(this),
1478             tokenAmount,
1479             0, // slippage is unavoidable
1480             0, // slippage is unavoidable
1481             owner(),
1482             block.timestamp
1483         );
1484     }
1485 
1486     function swapBack() private {
1487         uint256 contractBalance = balanceOf(address(this));
1488         uint256 totalTokensToSwap = tokensForLiquidity +
1489             tokensForRevShare +
1490             tokensForTeam;
1491         bool success;
1492 
1493         if (contractBalance == 0 || totalTokensToSwap == 0) {
1494             return;
1495         }
1496 
1497         if (contractBalance > swapTokensAtAmount * 20) {
1498             contractBalance = swapTokensAtAmount * 20;
1499         }
1500 
1501         // Halve the amount of liquidity tokens
1502         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1503             totalTokensToSwap /
1504             2;
1505         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1506 
1507         uint256 initialETHBalance = address(this).balance;
1508 
1509         swapTokensForEth(amountToSwapForETH);
1510 
1511         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1512 
1513         uint256 ethForRevShare = ethBalance.mul(tokensForRevShare).div(
1514             totalTokensToSwap - (tokensForLiquidity / 2)
1515         );
1516 
1517         uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(
1518             totalTokensToSwap - (tokensForLiquidity / 2)
1519         );
1520 
1521         uint256 ethForLiquidity = ethBalance - ethForRevShare - ethForTeam;
1522 
1523         tokensForLiquidity = 0;
1524         tokensForRevShare = 0;
1525         tokensForTeam = 0;
1526 
1527         (success, ) = address(teamWallet).call{value: ethForTeam}("");
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
1538         (success, ) = address(revShareWallet).call{
1539             value: address(this).balance
1540         }("");
1541     }
1542 
1543     function withdrawStuckXFather() external onlyOwner {
1544         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1545         IERC20(address(this)).transfer(msg.sender, balance);
1546         payable(msg.sender).transfer(address(this).balance);
1547     }
1548 
1549     function withdrawStuckToken(
1550         address _token,
1551         address _to
1552     ) external onlyOwner {
1553         require(_token != address(0), "_token address cannot be 0");
1554         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1555         IERC20(_token).transfer(_to, _contractBalance);
1556     }
1557 
1558     function withdrawStuckEth(address toAddr) external onlyOwner {
1559         (bool success, ) = toAddr.call{value: address(this).balance}("");
1560         require(success);
1561     }
1562 
1563     // @dev team renounce blacklist commands
1564     function renounceBlacklist() public onlyOwner {
1565         blacklistRenounced = true;
1566     }
1567 
1568     function blacklist(address _addr) public onlyOwner {
1569         require(!blacklistRenounced, "Team has revoked blacklist rights");
1570         require(
1571             _addr != address(uniswapV2Pair) &&
1572                 _addr != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D),
1573             "Cannot blacklist token's v2 router or v2 pool."
1574         );
1575         blacklisted[_addr] = true;
1576     }
1577 
1578     // @dev blacklist v3 pools; can unblacklist() down the road to suit project and community
1579     function blacklistLiquidityPool(address lpAddress) public onlyOwner {
1580         require(!blacklistRenounced, "Team has revoked blacklist rights");
1581         require(
1582             lpAddress != address(uniswapV2Pair) &&
1583                 lpAddress !=
1584                 address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D),
1585             "Cannot blacklist token's v2 router or v2 pool."
1586         );
1587         blacklisted[lpAddress] = true;
1588     }
1589 
1590     // @dev unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
1591     function unblacklist(address _addr) public onlyOwner {
1592         blacklisted[_addr] = false;
1593     }
1594 
1595     function setPreMigrationTransferable(
1596         address _addr,
1597         bool isAuthorized
1598     ) public onlyOwner {
1599         preMigrationTransferrable[_addr] = isAuthorized;
1600         excludeFromFees(_addr, isAuthorized);
1601         excludeFromMaxTransaction(_addr, isAuthorized);
1602     }
1603 }