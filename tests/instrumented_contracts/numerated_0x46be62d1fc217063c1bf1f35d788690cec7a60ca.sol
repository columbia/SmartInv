1 /*
2 Retsuko | $SUKO
3 
4 Suko follows this ethos “AGGRESSIVE BY NATURE, SUKO BY CHOICE” simply showing it’s a way of life.
5 
6 💬 https://t.me/RetsukoOfficial
7 🌐 https://retsuko.io
8 Ⓜ️ https://medium.com/@RetsukoERC
9 🐤 https://twitter.com/RetsukoOfficial
10 📷 https://www.instagram.com/retsukoerc/
11 */
12 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
13 pragma experimental ABIEncoderV2;
14 
15 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
16 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
17 
18 /* pragma solidity ^0.8.0; */
19 
20 /**
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         return msg.data;
37     }
38 }
39 
40 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
41 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
42 
43 /* pragma solidity ^0.8.0; */
44 
45 /* import "../utils/Context.sol"; */
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 abstract contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor() {
68         _transferOwnership(_msgSender());
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
118 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
119 
120 /* pragma solidity ^0.8.0; */
121 
122 /**
123  * @dev Interface of the ERC20 standard as defined in the EIP.
124  */
125 interface IERC20 {
126     /**
127      * @dev Returns the amount of tokens in existence.
128      */
129     function totalSupply() external view returns (uint256);
130 
131     /**
132      * @dev Returns the amount of tokens owned by `account`.
133      */
134     function balanceOf(address account) external view returns (uint256);
135 
136     /**
137      * @dev Moves `amount` tokens from the caller's account to `recipient`.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transfer(address recipient, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Returns the remaining number of tokens that `spender` will be
147      * allowed to spend on behalf of `owner` through {transferFrom}. This is
148      * zero by default.
149      *
150      * This value changes when {approve} or {transferFrom} are called.
151      */
152     function allowance(address owner, address spender) external view returns (uint256);
153 
154     /**
155      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * IMPORTANT: Beware that changing an allowance with this method brings the risk
160      * that someone may use both the old and the new allowance by unfortunate
161      * transaction ordering. One possible solution to mitigate this race
162      * condition is to first reduce the spender's allowance to 0 and set the
163      * desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      *
166      * Emits an {Approval} event.
167      */
168     function approve(address spender, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Moves `amount` tokens from `sender` to `recipient` using the
172      * allowance mechanism. `amount` is then deducted from the caller's
173      * allowance.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transferFrom(
180         address sender,
181         address recipient,
182         uint256 amount
183     ) external returns (bool);
184 
185     /**
186      * @dev Emitted when `value` tokens are moved from one account (`from`) to
187      * another (`to`).
188      *
189      * Note that `value` may be zero.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     /**
194      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
195      * a call to {approve}. `value` is the new allowance.
196      */
197     event Approval(address indexed owner, address indexed spender, uint256 value);
198 }
199 
200 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
201 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
202 
203 /* pragma solidity ^0.8.0; */
204 
205 /* import "../IERC20.sol"; */
206 
207 /**
208  * @dev Interface for the optional metadata functions from the ERC20 standard.
209  *
210  * _Available since v4.1._
211  */
212 interface IERC20Metadata is IERC20 {
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the symbol of the token.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the decimals places of the token.
225      */
226     function decimals() external view returns (uint8);
227 }
228 
229 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
230 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
231 
232 /* pragma solidity ^0.8.0; */
233 
234 /* import "./IERC20.sol"; */
235 /* import "./extensions/IERC20Metadata.sol"; */
236 /* import "../../utils/Context.sol"; */
237 
238 /**
239  * @dev Implementation of the {IERC20} interface.
240  *
241  * This implementation is agnostic to the way tokens are created. This means
242  * that a supply mechanism has to be added in a derived contract using {_mint}.
243  * For a generic mechanism see {ERC20PresetMinterPauser}.
244  *
245  * TIP: For a detailed writeup see our guide
246  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
247  * to implement supply mechanisms].
248  *
249  * We have followed general OpenZeppelin Contracts guidelines: functions revert
250  * instead returning `false` on failure. This behavior is nonetheless
251  * conventional and does not conflict with the expectations of ERC20
252  * applications.
253  *
254  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
255  * This allows applications to reconstruct the allowance for all accounts just
256  * by listening to said events. Other implementations of the EIP may not emit
257  * these events, as it isn't required by the specification.
258  *
259  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
260  * functions have been added to mitigate the well-known issues around setting
261  * allowances. See {IERC20-approve}.
262  */
263 contract ERC20 is Context, IERC20, IERC20Metadata {
264     mapping(address => uint256) private _balances;
265 
266     mapping(address => mapping(address => uint256)) private _allowances;
267 
268     uint256 private _totalSupply;
269 
270     string private _name;
271     string private _symbol;
272 
273     /**
274      * @dev Sets the values for {name} and {symbol}.
275      *
276      * The default value of {decimals} is 18. To select a different value for
277      * {decimals} you should overload it.
278      *
279      * All two of these values are immutable: they can only be set once during
280      * construction.
281      */
282     constructor(string memory name_, string memory symbol_) {
283         _name = name_;
284         _symbol = symbol_;
285     }
286 
287     /**
288      * @dev Returns the name of the token.
289      */
290     function name() public view virtual override returns (string memory) {
291         return _name;
292     }
293 
294     /**
295      * @dev Returns the symbol of the token, usually a shorter version of the
296      * name.
297      */
298     function symbol() public view virtual override returns (string memory) {
299         return _symbol;
300     }
301 
302     /**
303      * @dev Returns the number of decimals used to get its user representation.
304      * For example, if `decimals` equals `2`, a balance of `505` tokens should
305      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
306      *
307      * Tokens usually opt for a value of 18, imitating the relationship between
308      * Ether and Wei. This is the value {ERC20} uses, unless this function is
309      * overridden;
310      *
311      * NOTE: This information is only used for _display_ purposes: it in
312      * no way affects any of the arithmetic of the contract, including
313      * {IERC20-balanceOf} and {IERC20-transfer}.
314      */
315     function decimals() public view virtual override returns (uint8) {
316         return 18;
317     }
318 
319     /**
320      * @dev See {IERC20-totalSupply}.
321      */
322     function totalSupply() public view virtual override returns (uint256) {
323         return _totalSupply;
324     }
325 
326     /**
327      * @dev See {IERC20-balanceOf}.
328      */
329     function balanceOf(address account) public view virtual override returns (uint256) {
330         return _balances[account];
331     }
332 
333     /**
334      * @dev See {IERC20-transfer}.
335      *
336      * Requirements:
337      *
338      * - `recipient` cannot be the zero address.
339      * - the caller must have a balance of at least `amount`.
340      */
341     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
342         _transfer(_msgSender(), recipient, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-allowance}.
348      */
349     function allowance(address owner, address spender) public view virtual override returns (uint256) {
350         return _allowances[owner][spender];
351     }
352 
353     /**
354      * @dev See {IERC20-approve}.
355      *
356      * Requirements:
357      *
358      * - `spender` cannot be the zero address.
359      */
360     function approve(address spender, uint256 amount) public virtual override returns (bool) {
361         _approve(_msgSender(), spender, amount);
362         return true;
363     }
364 
365     /**
366      * @dev See {IERC20-transferFrom}.
367      *
368      * Emits an {Approval} event indicating the updated allowance. This is not
369      * required by the EIP. See the note at the beginning of {ERC20}.
370      *
371      * Requirements:
372      *
373      * - `sender` and `recipient` cannot be the zero address.
374      * - `sender` must have a balance of at least `amount`.
375      * - the caller must have allowance for ``sender``'s tokens of at least
376      * `amount`.
377      */
378     function transferFrom(
379         address sender,
380         address recipient,
381         uint256 amount
382     ) public virtual override returns (bool) {
383         _transfer(sender, recipient, amount);
384 
385         uint256 currentAllowance = _allowances[sender][_msgSender()];
386         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
387         unchecked {
388             _approve(sender, _msgSender(), currentAllowance - amount);
389         }
390 
391         return true;
392     }
393 
394     /**
395      * @dev Atomically increases the allowance granted to `spender` by the caller.
396      *
397      * This is an alternative to {approve} that can be used as a mitigation for
398      * problems described in {IERC20-approve}.
399      *
400      * Emits an {Approval} event indicating the updated allowance.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      */
406     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
407         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
408         return true;
409     }
410 
411     /**
412      * @dev Atomically decreases the allowance granted to `spender` by the caller.
413      *
414      * This is an alternative to {approve} that can be used as a mitigation for
415      * problems described in {IERC20-approve}.
416      *
417      * Emits an {Approval} event indicating the updated allowance.
418      *
419      * Requirements:
420      *
421      * - `spender` cannot be the zero address.
422      * - `spender` must have allowance for the caller of at least
423      * `subtractedValue`.
424      */
425     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
426         uint256 currentAllowance = _allowances[_msgSender()][spender];
427         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
428         unchecked {
429             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
430         }
431 
432         return true;
433     }
434 
435     /**
436      * @dev Moves `amount` of tokens from `sender` to `recipient`.
437      *
438      * This internal function is equivalent to {transfer}, and can be used to
439      * e.g. implement automatic token fees, slashing mechanisms, etc.
440      *
441      * Emits a {Transfer} event.
442      *
443      * Requirements:
444      *
445      * - `sender` cannot be the zero address.
446      * - `recipient` cannot be the zero address.
447      * - `sender` must have a balance of at least `amount`.
448      */
449     function _transfer(
450         address sender,
451         address recipient,
452         uint256 amount
453     ) internal virtual {
454         require(sender != address(0), "ERC20: transfer from the zero address");
455         require(recipient != address(0), "ERC20: transfer to the zero address");
456 
457         _beforeTokenTransfer(sender, recipient, amount);
458 
459         uint256 senderBalance = _balances[sender];
460         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
461         unchecked {
462             _balances[sender] = senderBalance - amount;
463         }
464         _balances[recipient] += amount;
465 
466         emit Transfer(sender, recipient, amount);
467 
468         _afterTokenTransfer(sender, recipient, amount);
469     }
470 
471     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
472      * the total supply.
473      *
474      * Emits a {Transfer} event with `from` set to the zero address.
475      *
476      * Requirements:
477      *
478      * - `account` cannot be the zero address.
479      */
480     function _mint(address account, uint256 amount) internal virtual {
481         require(account != address(0), "ERC20: mint to the zero address");
482 
483         _beforeTokenTransfer(address(0), account, amount);
484 
485         _totalSupply += amount;
486         _balances[account] += amount;
487         emit Transfer(address(0), account, amount);
488 
489         _afterTokenTransfer(address(0), account, amount);
490     }
491 
492     /**
493      * @dev Destroys `amount` tokens from `account`, reducing the
494      * total supply.
495      *
496      * Emits a {Transfer} event with `to` set to the zero address.
497      *
498      * Requirements:
499      *
500      * - `account` cannot be the zero address.
501      * - `account` must have at least `amount` tokens.
502      */
503     function _burn(address account, uint256 amount) internal virtual {
504         require(account != address(0), "ERC20: burn from the zero address");
505 
506         _beforeTokenTransfer(account, address(0), amount);
507 
508         uint256 accountBalance = _balances[account];
509         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
510         unchecked {
511             _balances[account] = accountBalance - amount;
512         }
513         _totalSupply -= amount;
514 
515         emit Transfer(account, address(0), amount);
516 
517         _afterTokenTransfer(account, address(0), amount);
518     }
519 
520     /**
521      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
522      *
523      * This internal function is equivalent to `approve`, and can be used to
524      * e.g. set automatic allowances for certain subsystems, etc.
525      *
526      * Emits an {Approval} event.
527      *
528      * Requirements:
529      *
530      * - `owner` cannot be the zero address.
531      * - `spender` cannot be the zero address.
532      */
533     function _approve(
534         address owner,
535         address spender,
536         uint256 amount
537     ) internal virtual {
538         require(owner != address(0), "ERC20: approve from the zero address");
539         require(spender != address(0), "ERC20: approve to the zero address");
540 
541         _allowances[owner][spender] = amount;
542         emit Approval(owner, spender, amount);
543     }
544 
545     /**
546      * @dev Hook that is called before any transfer of tokens. This includes
547      * minting and burning.
548      *
549      * Calling conditions:
550      *
551      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
552      * will be transferred to `to`.
553      * - when `from` is zero, `amount` tokens will be minted for `to`.
554      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
555      * - `from` and `to` are never both zero.
556      *
557      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
558      */
559     function _beforeTokenTransfer(
560         address from,
561         address to,
562         uint256 amount
563     ) internal virtual {}
564 
565     /**
566      * @dev Hook that is called after any transfer of tokens. This includes
567      * minting and burning.
568      *
569      * Calling conditions:
570      *
571      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
572      * has been transferred to `to`.
573      * - when `from` is zero, `amount` tokens have been minted for `to`.
574      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
575      * - `from` and `to` are never both zero.
576      *
577      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
578      */
579     function _afterTokenTransfer(
580         address from,
581         address to,
582         uint256 amount
583     ) internal virtual {}
584 }
585 
586 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
587 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
588 
589 /* pragma solidity ^0.8.0; */
590 
591 // CAUTION
592 // This version of SafeMath should only be used with Solidity 0.8 or later,
593 // because it relies on the compiler's built in overflow checks.
594 
595 /**
596  * @dev Wrappers over Solidity's arithmetic operations.
597  *
598  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
599  * now has built in overflow checking.
600  */
601 library SafeMath {
602     /**
603      * @dev Returns the addition of two unsigned integers, with an overflow flag.
604      *
605      * _Available since v3.4._
606      */
607     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
608         unchecked {
609             uint256 c = a + b;
610             if (c < a) return (false, 0);
611             return (true, c);
612         }
613     }
614 
615     /**
616      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
617      *
618      * _Available since v3.4._
619      */
620     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
621         unchecked {
622             if (b > a) return (false, 0);
623             return (true, a - b);
624         }
625     }
626 
627     /**
628      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
629      *
630      * _Available since v3.4._
631      */
632     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
633         unchecked {
634             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
635             // benefit is lost if 'b' is also tested.
636             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
637             if (a == 0) return (true, 0);
638             uint256 c = a * b;
639             if (c / a != b) return (false, 0);
640             return (true, c);
641         }
642     }
643 
644     /**
645      * @dev Returns the division of two unsigned integers, with a division by zero flag.
646      *
647      * _Available since v3.4._
648      */
649     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
650         unchecked {
651             if (b == 0) return (false, 0);
652             return (true, a / b);
653         }
654     }
655 
656     /**
657      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
658      *
659      * _Available since v3.4._
660      */
661     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
662         unchecked {
663             if (b == 0) return (false, 0);
664             return (true, a % b);
665         }
666     }
667 
668     /**
669      * @dev Returns the addition of two unsigned integers, reverting on
670      * overflow.
671      *
672      * Counterpart to Solidity's `+` operator.
673      *
674      * Requirements:
675      *
676      * - Addition cannot overflow.
677      */
678     function add(uint256 a, uint256 b) internal pure returns (uint256) {
679         return a + b;
680     }
681 
682     /**
683      * @dev Returns the subtraction of two unsigned integers, reverting on
684      * overflow (when the result is negative).
685      *
686      * Counterpart to Solidity's `-` operator.
687      *
688      * Requirements:
689      *
690      * - Subtraction cannot overflow.
691      */
692     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
693         return a - b;
694     }
695 
696     /**
697      * @dev Returns the multiplication of two unsigned integers, reverting on
698      * overflow.
699      *
700      * Counterpart to Solidity's `*` operator.
701      *
702      * Requirements:
703      *
704      * - Multiplication cannot overflow.
705      */
706     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
707         return a * b;
708     }
709 
710     /**
711      * @dev Returns the integer division of two unsigned integers, reverting on
712      * division by zero. The result is rounded towards zero.
713      *
714      * Counterpart to Solidity's `/` operator.
715      *
716      * Requirements:
717      *
718      * - The divisor cannot be zero.
719      */
720     function div(uint256 a, uint256 b) internal pure returns (uint256) {
721         return a / b;
722     }
723 
724     /**
725      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
726      * reverting when dividing by zero.
727      *
728      * Counterpart to Solidity's `%` operator. This function uses a `revert`
729      * opcode (which leaves remaining gas untouched) while Solidity uses an
730      * invalid opcode to revert (consuming all remaining gas).
731      *
732      * Requirements:
733      *
734      * - The divisor cannot be zero.
735      */
736     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
737         return a % b;
738     }
739 
740     /**
741      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
742      * overflow (when the result is negative).
743      *
744      * CAUTION: This function is deprecated because it requires allocating memory for the error
745      * message unnecessarily. For custom revert reasons use {trySub}.
746      *
747      * Counterpart to Solidity's `-` operator.
748      *
749      * Requirements:
750      *
751      * - Subtraction cannot overflow.
752      */
753     function sub(
754         uint256 a,
755         uint256 b,
756         string memory errorMessage
757     ) internal pure returns (uint256) {
758         unchecked {
759             require(b <= a, errorMessage);
760             return a - b;
761         }
762     }
763 
764     /**
765      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
766      * division by zero. The result is rounded towards zero.
767      *
768      * Counterpart to Solidity's `/` operator. Note: this function uses a
769      * `revert` opcode (which leaves remaining gas untouched) while Solidity
770      * uses an invalid opcode to revert (consuming all remaining gas).
771      *
772      * Requirements:
773      *
774      * - The divisor cannot be zero.
775      */
776     function div(
777         uint256 a,
778         uint256 b,
779         string memory errorMessage
780     ) internal pure returns (uint256) {
781         unchecked {
782             require(b > 0, errorMessage);
783             return a / b;
784         }
785     }
786 
787     /**
788      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
789      * reverting with custom message when dividing by zero.
790      *
791      * CAUTION: This function is deprecated because it requires allocating memory for the error
792      * message unnecessarily. For custom revert reasons use {tryMod}.
793      *
794      * Counterpart to Solidity's `%` operator. This function uses a `revert`
795      * opcode (which leaves remaining gas untouched) while Solidity uses an
796      * invalid opcode to revert (consuming all remaining gas).
797      *
798      * Requirements:
799      *
800      * - The divisor cannot be zero.
801      */
802     function mod(
803         uint256 a,
804         uint256 b,
805         string memory errorMessage
806     ) internal pure returns (uint256) {
807         unchecked {
808             require(b > 0, errorMessage);
809             return a % b;
810         }
811     }
812 }
813 
814 ////// src/IUniswapV2Factory.sol
815 /* pragma solidity 0.8.10; */
816 /* pragma experimental ABIEncoderV2; */
817 
818 interface IUniswapV2Factory {
819     event PairCreated(
820         address indexed token0,
821         address indexed token1,
822         address pair,
823         uint256
824     );
825 
826     function feeTo() external view returns (address);
827 
828     function feeToSetter() external view returns (address);
829 
830     function getPair(address tokenA, address tokenB)
831         external
832         view
833         returns (address pair);
834 
835     function allPairs(uint256) external view returns (address pair);
836 
837     function allPairsLength() external view returns (uint256);
838 
839     function createPair(address tokenA, address tokenB)
840         external
841         returns (address pair);
842 
843     function setFeeTo(address) external;
844 
845     function setFeeToSetter(address) external;
846 }
847 
848 ////// src/IUniswapV2Pair.sol
849 /* pragma solidity 0.8.10; */
850 /* pragma experimental ABIEncoderV2; */
851 
852 interface IUniswapV2Pair {
853     event Approval(
854         address indexed owner,
855         address indexed spender,
856         uint256 value
857     );
858     event Transfer(address indexed from, address indexed to, uint256 value);
859 
860     function name() external pure returns (string memory);
861 
862     function symbol() external pure returns (string memory);
863 
864     function decimals() external pure returns (uint8);
865 
866     function totalSupply() external view returns (uint256);
867 
868     function balanceOf(address owner) external view returns (uint256);
869 
870     function allowance(address owner, address spender)
871         external
872         view
873         returns (uint256);
874 
875     function approve(address spender, uint256 value) external returns (bool);
876 
877     function transfer(address to, uint256 value) external returns (bool);
878 
879     function transferFrom(
880         address from,
881         address to,
882         uint256 value
883     ) external returns (bool);
884 
885     function DOMAIN_SEPARATOR() external view returns (bytes32);
886 
887     function PERMIT_TYPEHASH() external pure returns (bytes32);
888 
889     function nonces(address owner) external view returns (uint256);
890 
891     function permit(
892         address owner,
893         address spender,
894         uint256 value,
895         uint256 deadline,
896         uint8 v,
897         bytes32 r,
898         bytes32 s
899     ) external;
900 
901     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
902     event Burn(
903         address indexed sender,
904         uint256 amount0,
905         uint256 amount1,
906         address indexed to
907     );
908     event Swap(
909         address indexed sender,
910         uint256 amount0In,
911         uint256 amount1In,
912         uint256 amount0Out,
913         uint256 amount1Out,
914         address indexed to
915     );
916     event Sync(uint112 reserve0, uint112 reserve1);
917 
918     function MINIMUM_LIQUIDITY() external pure returns (uint256);
919 
920     function factory() external view returns (address);
921 
922     function token0() external view returns (address);
923 
924     function token1() external view returns (address);
925 
926     function getReserves()
927         external
928         view
929         returns (
930             uint112 reserve0,
931             uint112 reserve1,
932             uint32 blockTimestampLast
933         );
934 
935     function price0CumulativeLast() external view returns (uint256);
936 
937     function price1CumulativeLast() external view returns (uint256);
938 
939     function kLast() external view returns (uint256);
940 
941     function mint(address to) external returns (uint256 liquidity);
942 
943     function burn(address to)
944         external
945         returns (uint256 amount0, uint256 amount1);
946 
947     function swap(
948         uint256 amount0Out,
949         uint256 amount1Out,
950         address to,
951         bytes calldata data
952     ) external;
953 
954     function skim(address to) external;
955 
956     function sync() external;
957 
958     function initialize(address, address) external;
959 }
960 
961 ////// src/IUniswapV2Router02.sol
962 /* pragma solidity 0.8.10; */
963 /* pragma experimental ABIEncoderV2; */
964 
965 interface IUniswapV2Router02 {
966     function factory() external pure returns (address);
967 
968     function WETH() external pure returns (address);
969 
970     function addLiquidity(
971         address tokenA,
972         address tokenB,
973         uint256 amountADesired,
974         uint256 amountBDesired,
975         uint256 amountAMin,
976         uint256 amountBMin,
977         address to,
978         uint256 deadline
979     )
980         external
981         returns (
982             uint256 amountA,
983             uint256 amountB,
984             uint256 liquidity
985         );
986 
987     function addLiquidityETH(
988         address token,
989         uint256 amountTokenDesired,
990         uint256 amountTokenMin,
991         uint256 amountETHMin,
992         address to,
993         uint256 deadline
994     )
995         external
996         payable
997         returns (
998             uint256 amountToken,
999             uint256 amountETH,
1000             uint256 liquidity
1001         );
1002 
1003     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1004         uint256 amountIn,
1005         uint256 amountOutMin,
1006         address[] calldata path,
1007         address to,
1008         uint256 deadline
1009     ) external;
1010 
1011     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1012         uint256 amountOutMin,
1013         address[] calldata path,
1014         address to,
1015         uint256 deadline
1016     ) external payable;
1017 
1018     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1019         uint256 amountIn,
1020         uint256 amountOutMin,
1021         address[] calldata path,
1022         address to,
1023         uint256 deadline
1024     ) external;
1025 }
1026 
1027 /* pragma solidity >=0.8.10; */
1028 
1029 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1030 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1031 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1032 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1033 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1034 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1035 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1036 //****************************************************************************************\\
1037 //// Congratulations! By buying into this contract you are signing \\\\
1038 //// up to book your place into the biggest memecoin of 2023! \\\\
1039 //// Aggressive By Nature, Suko By Choice. \\\\
1040 //****************************************************************************************\\
1041 contract Retsuko is ERC20, Ownable {
1042     using SafeMath for uint256;
1043 
1044     IUniswapV2Router02 public immutable uniswapV2Router;
1045     address public immutable uniswapV2Pair;
1046     address public constant deadAddress = address(0xdead);
1047 
1048     bool private swapping;
1049 
1050     address public marketingWallet;
1051     address public daoWallet;
1052 
1053     uint256 public maxTransactionAmount;
1054     uint256 public swapTokensAtAmount;
1055     uint256 public maxWallet;
1056 
1057     uint256 public percentForLPBurn = 25; // 25 = .25%
1058     bool public lpBurnEnabled = false;
1059     uint256 public lpBurnFrequency = 3600 seconds;
1060     uint256 public lastLpBurnTime;
1061 
1062     uint256 public manualBurnFrequency = 30 minutes;
1063     uint256 public lastManualLpBurnTime;
1064 
1065     bool public limitsInEffect = true;
1066     bool public tradingActive = false;
1067     bool public swapEnabled = false;
1068 
1069     // Anti-bot and anti-whale mappings and variables
1070     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1071     bool public transferDelayEnabled = false;
1072 
1073     uint256 public buyTotalFees;
1074     uint256 public buyMarketingFee;
1075     uint256 public buyLiquidityFee;
1076     uint256 public buyDaoFee;
1077 
1078     uint256 public sellTotalFees;
1079     uint256 public sellMarketingFee;
1080     uint256 public sellLiquidityFee;
1081     uint256 public sellDaoFee;
1082 
1083     uint256 public tokensForMarketing;
1084     uint256 public tokensForLiquidity;
1085     uint256 public tokensForDev;
1086 
1087     /******************/
1088 
1089     // exlcude from fees and max transaction amount
1090     mapping(address => bool) private _isExcludedFromFees;
1091     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1092 
1093     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1094     // could be subject to a maximum transfer amount
1095     mapping(address => bool) public automatedMarketMakerPairs;
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
1106     event marketingWalletUpdated(
1107         address indexed newWallet,
1108         address indexed oldWallet
1109     );
1110 
1111     event daoWalletUpdated(
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
1122     event AutoNukeLP();
1123 
1124     event ManualNukeLP();
1125 
1126     constructor() ERC20("Retsuko", "SUKO") {
1127         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1128             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1129         );
1130 
1131         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1132         uniswapV2Router = _uniswapV2Router;
1133 
1134         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1135             .createPair(address(this), _uniswapV2Router.WETH());
1136         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1137         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1138 
1139         uint256 _buyMarketingFee = 2;
1140         uint256 _buyLiquidityFee = 0;
1141         uint256 _buyDaoFee = 3;
1142 
1143         uint256 _sellMarketingFee = 2;
1144         uint256 _sellLiquidityFee = 0;
1145         uint256 _sellDaoFee = 3;
1146 
1147         uint256 totalSupply = 100_000_000 * 1e18;
1148 
1149         maxTransactionAmount = 1_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1150         maxWallet = 1_000_000 * 1e18; // 1% from total supply maxWallet
1151         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1152 
1153         buyMarketingFee = _buyMarketingFee;
1154         buyLiquidityFee = _buyLiquidityFee;
1155         buyDaoFee = _buyDaoFee;
1156         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDaoFee;
1157 
1158         sellMarketingFee = _sellMarketingFee;
1159         sellLiquidityFee = _sellLiquidityFee;
1160         sellDaoFee = _sellDaoFee;
1161         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDaoFee;
1162 
1163         marketingWallet = address(0xB137d8DB3B22dCddb01af211B2cF5e6F0DAA1492); // set as marketing wallet
1164         daoWallet = address(0x2726d583d5ad81120E332a170084D025b9f1309d); // set as dao wallet
1165 
1166         // exclude from paying fees or having max transaction amount
1167         excludeFromFees(owner(), true);
1168         excludeFromFees(address(this), true);
1169         excludeFromFees(address(0xdead), true);
1170 
1171         excludeFromMaxTransaction(owner(), true);
1172         excludeFromMaxTransaction(address(this), true);
1173         excludeFromMaxTransaction(address(0xdead), true);
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
1188         lastLpBurnTime = block.timestamp;
1189     }
1190 
1191     // remove limits after token is stable
1192     function removeLimits() external onlyOwner returns (bool) {
1193         limitsInEffect = false;
1194         return true;
1195     }
1196 
1197     // disable Transfer delay - cannot be reenabled
1198     function disableTransferDelay() external onlyOwner returns (bool) {
1199         transferDelayEnabled = false;
1200         return true;
1201     }
1202 
1203     // change the minimum amount of tokens to sell from fees
1204     function updateSwapTokensAtAmount(uint256 newAmount)
1205         external
1206         onlyOwner
1207         returns (bool)
1208     {
1209         require(
1210             newAmount >= (totalSupply() * 1) / 100000,
1211             "Swap amount cannot be lower than 0.001% total supply."
1212         );
1213         require(
1214             newAmount <= (totalSupply() * 5) / 1000,
1215             "Swap amount cannot be higher than 0.5% total supply."
1216         );
1217         swapTokensAtAmount = newAmount;
1218         return true;
1219     }
1220 
1221     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1222         require(
1223             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1224             "Cannot set maxTransactionAmount lower than 0.1%"
1225         );
1226         maxTransactionAmount = newNum * (10**18);
1227     }
1228 
1229     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1230         require(
1231             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1232             "Cannot set maxWallet lower than 0.5%"
1233         );
1234         maxWallet = newNum * (10**18);
1235     }
1236 
1237     function excludeFromMaxTransaction(address updAds, bool isEx)
1238         public
1239         onlyOwner
1240     {
1241         _isExcludedMaxTransactionAmount[updAds] = isEx;
1242     }
1243 
1244     // only use to disable contract sales if absolutely necessary (emergency use only)
1245     function updateSwapEnabled(bool enabled) external onlyOwner {
1246         swapEnabled = enabled;
1247     }
1248 
1249     function updateBuyFees(
1250         uint256 _marketingFee,
1251         uint256 _liquidityFee,
1252         uint256 _DaoFee
1253     ) external onlyOwner {
1254         buyMarketingFee = _marketingFee;
1255         buyLiquidityFee = _liquidityFee;
1256         buyDaoFee = _DaoFee;
1257         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDaoFee;
1258         require(buyTotalFees <= 95, "Must keep fees at 95% or less");
1259     }
1260 
1261     function updateSellFees(
1262         uint256 _marketingFee,
1263         uint256 _liquidityFee,
1264         uint256 _DaoFee
1265     ) external onlyOwner {
1266         sellMarketingFee = _marketingFee;
1267         sellLiquidityFee = _liquidityFee;
1268         sellDaoFee = _DaoFee;
1269         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDaoFee;
1270         require(sellTotalFees <= 95, "Must keep fees at 95% or less");
1271     }
1272 
1273     function excludeFromFees(address account, bool excluded) public onlyOwner {
1274         _isExcludedFromFees[account] = excluded;
1275         emit ExcludeFromFees(account, excluded);
1276     }
1277 
1278     function setAutomatedMarketMakerPair(address pair, bool value)
1279         public
1280         onlyOwner
1281     {
1282         require(
1283             pair != uniswapV2Pair,
1284             "The pair cannot be removed from automatedMarketMakerPairs"
1285         );
1286 
1287         _setAutomatedMarketMakerPair(pair, value);
1288     }
1289 
1290     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1291         automatedMarketMakerPairs[pair] = value;
1292 
1293         emit SetAutomatedMarketMakerPair(pair, value);
1294     }
1295 
1296     function updateMarketingWallet(address newMarketingWallet)
1297         external
1298         onlyOwner
1299     {
1300         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1301         marketingWallet = newMarketingWallet;
1302     }
1303 
1304     function updatedaoWallet(address newWallet) external onlyOwner {
1305         emit daoWalletUpdated(newWallet, daoWallet);
1306         daoWallet = newWallet;
1307     }
1308 
1309     function isExcludedFromFees(address account) public view returns (bool) {
1310         return _isExcludedFromFees[account];
1311     }
1312 
1313     event BoughtEarly(address indexed sniper);
1314 
1315     function _transfer(
1316         address from,
1317         address to,
1318         uint256 amount
1319     ) internal override {
1320         require(from != address(0), "ERC20: transfer from the zero address");
1321         require(to != address(0), "ERC20: transfer to the zero address");
1322 
1323         if (amount == 0) {
1324             super._transfer(from, to, 0);
1325             return;
1326         }
1327 
1328         if (limitsInEffect) {
1329             if (
1330                 from != owner() &&
1331                 to != owner() &&
1332                 to != address(0) &&
1333                 to != address(0xdead) &&
1334                 !swapping
1335             ) {
1336                 if (!tradingActive) {
1337                     require(
1338                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1339                         "Trading is not active."
1340                     );
1341                 }
1342 
1343                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1344                 if (transferDelayEnabled) {
1345                     if (
1346                         to != owner() &&
1347                         to != address(uniswapV2Router) &&
1348                         to != address(uniswapV2Pair)
1349                     ) {
1350                         require(
1351                             _holderLastTransferTimestamp[tx.origin] <
1352                                 block.number,
1353                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1354                         );
1355                         _holderLastTransferTimestamp[tx.origin] = block.number;
1356                     }
1357                 }
1358 
1359                 //when buy
1360                 if (
1361                     automatedMarketMakerPairs[from] &&
1362                     !_isExcludedMaxTransactionAmount[to]
1363                 ) {
1364                     require(
1365                         amount <= maxTransactionAmount,
1366                         "Buy transfer amount exceeds the maxTransactionAmount."
1367                     );
1368                     require(
1369                         amount + balanceOf(to) <= maxWallet,
1370                         "Max wallet exceeded"
1371                     );
1372                 }
1373                 //when sell
1374                 else if (
1375                     automatedMarketMakerPairs[to] &&
1376                     !_isExcludedMaxTransactionAmount[from]
1377                 ) {
1378                     require(
1379                         amount <= maxTransactionAmount,
1380                         "Sell transfer amount exceeds the maxTransactionAmount."
1381                     );
1382                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1383                     require(
1384                         amount + balanceOf(to) <= maxWallet,
1385                         "Max wallet exceeded"
1386                     );
1387                 }
1388             }
1389         }
1390 
1391         uint256 contractTokenBalance = balanceOf(address(this));
1392 
1393         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1394 
1395         if (
1396             canSwap &&
1397             swapEnabled &&
1398             !swapping &&
1399             !automatedMarketMakerPairs[from] &&
1400             !_isExcludedFromFees[from] &&
1401             !_isExcludedFromFees[to]
1402         ) {
1403             swapping = true;
1404 
1405             swapBack();
1406 
1407             swapping = false;
1408         }
1409 
1410         if (
1411             !swapping &&
1412             automatedMarketMakerPairs[to] &&
1413             lpBurnEnabled &&
1414             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1415             !_isExcludedFromFees[from]
1416         ) {
1417             autoBurnLiquidityPairTokens();
1418         }
1419 
1420         bool takeFee = !swapping;
1421 
1422         // if any account belongs to _isExcludedFromFee account then remove the fee
1423         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1424             takeFee = false;
1425         }
1426 
1427         uint256 fees = 0;
1428         // only take fees on buys/sells, do not take on wallet transfers
1429         if (takeFee) {
1430             // on sell
1431             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1432                 fees = amount.mul(sellTotalFees).div(100);
1433                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1434                 tokensForDev += (fees * sellDaoFee) / sellTotalFees;
1435                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1436             }
1437             // on buy
1438             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1439                 fees = amount.mul(buyTotalFees).div(100);
1440                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1441                 tokensForDev += (fees * buyDaoFee) / buyTotalFees;
1442                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1443             }
1444 
1445             if (fees > 0) {
1446                 super._transfer(from, address(this), fees);
1447             }
1448 
1449             amount -= fees;
1450         }
1451 
1452         super._transfer(from, to, amount);
1453     }
1454 
1455     function swapTokensForEth(uint256 tokenAmount) private {
1456         // generate the uniswap pair path of token -> weth
1457         address[] memory path = new address[](2);
1458         path[0] = address(this);
1459         path[1] = uniswapV2Router.WETH();
1460 
1461         _approve(address(this), address(uniswapV2Router), tokenAmount);
1462 
1463         // make the swap
1464         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1465             tokenAmount,
1466             0, // accept any amount of ETH
1467             path,
1468             address(this),
1469             block.timestamp
1470         );
1471     }
1472 
1473     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1474         // approve token transfer to cover all possible scenarios
1475         _approve(address(this), address(uniswapV2Router), tokenAmount);
1476 
1477         // add the liquidity
1478         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1479             address(this),
1480             tokenAmount,
1481             0, // slippage is unavoidable
1482             0, // slippage is unavoidable
1483             deadAddress,
1484             block.timestamp
1485         );
1486     }
1487 
1488     function swapBack() private {
1489         uint256 contractBalance = balanceOf(address(this));
1490         uint256 totalTokensToSwap = tokensForLiquidity +
1491             tokensForMarketing +
1492             tokensForDev;
1493         bool success;
1494 
1495         if (contractBalance == 0 || totalTokensToSwap == 0) {
1496             return;
1497         }
1498 
1499         if (contractBalance > swapTokensAtAmount * 20) {
1500             contractBalance = swapTokensAtAmount * 20;
1501         }
1502 
1503         // Halve the amount of liquidity tokens
1504         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1505             totalTokensToSwap /
1506             2;
1507         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1508 
1509         uint256 initialETHBalance = address(this).balance;
1510 
1511         swapTokensForEth(amountToSwapForETH);
1512 
1513         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1514 
1515         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1516             totalTokensToSwap
1517         );
1518         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1519 
1520         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1521 
1522         tokensForLiquidity = 0;
1523         tokensForMarketing = 0;
1524         tokensForDev = 0;
1525 
1526         (success, ) = address(daoWallet).call{value: ethForDev}("");
1527 
1528         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1529             addLiquidity(liquidityTokens, ethForLiquidity);
1530             emit SwapAndLiquify(
1531                 amountToSwapForETH,
1532                 ethForLiquidity,
1533                 tokensForLiquidity
1534             );
1535         }
1536 
1537         (success, ) = address(marketingWallet).call{
1538             value: address(this).balance
1539         }("");
1540     }
1541 
1542     function setAutoLPBurnSettings(
1543         uint256 _frequencyInSeconds,
1544         uint256 _percent,
1545         bool _Enabled
1546     ) external onlyOwner {
1547         require(
1548             _frequencyInSeconds >= 600,
1549             "cannot set buyback more often than every 10 minutes"
1550         );
1551         require(
1552             _percent <= 1000 && _percent >= 0,
1553             "Must set auto LP burn percent between 0% and 10%"
1554         );
1555         lpBurnFrequency = _frequencyInSeconds;
1556         percentForLPBurn = _percent;
1557         lpBurnEnabled = _Enabled;
1558     }
1559 
1560     function autoBurnLiquidityPairTokens() internal returns (bool) {
1561         lastLpBurnTime = block.timestamp;
1562 
1563         // get balance of liquidity pair
1564         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1565 
1566         // calculate amount to burn
1567         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1568             10000
1569         );
1570 
1571         // pull tokens from pancakePair liquidity and move to dead address permanently
1572         if (amountToBurn > 0) {
1573             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1574         }
1575 
1576         //sync price since this is not in a swap transaction!
1577         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1578         pair.sync();
1579         emit AutoNukeLP();
1580         return true;
1581     }
1582 
1583     function manualBurnLiquidityPairTokens(uint256 percent)
1584         external
1585         onlyOwner
1586         returns (bool)
1587     {
1588         require(
1589             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1590             "Must wait for cooldown to finish"
1591         );
1592         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1593         lastManualLpBurnTime = block.timestamp;
1594 
1595         // get balance of liquidity pair
1596         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1597 
1598         // calculate amount to burn
1599         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1600 
1601         // pull tokens from pancakePair liquidity and move to dead address permanently
1602         if (amountToBurn > 0) {
1603             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1604         }
1605 
1606         //sync price since this is not in a swap transaction!
1607         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1608         pair.sync();
1609         emit ManualNukeLP();
1610         return true;
1611     }
1612 }