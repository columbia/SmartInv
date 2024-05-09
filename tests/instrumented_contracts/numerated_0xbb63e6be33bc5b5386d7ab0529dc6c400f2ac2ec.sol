1 // SPDX-License-Identifier: MIT
2 
3 
4 /*
5 
6 If you like to watch jeets get fucked, come cuck em'
7 
8 https://t.me/cuckadoodledooeth
9 
10 */
11 
12 
13 pragma solidity ^0.8.18;
14 pragma experimental ABIEncoderV2;
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
107 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
108 
109 /* pragma solidity ^0.8.0; */
110 
111 /**
112  * @dev Interface of the ERC20 standard as defined in the EIP.
113  */
114 interface IERC20 {
115     /**
116      * @dev Returns the amount of tokens in existence.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     /**
121      * @dev Returns the amount of tokens owned by `account`.
122      */
123     function balanceOf(address account) external view returns (uint256);
124 
125     /**
126      * @dev Moves `amount` tokens from the caller's account to `recipient`.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transfer(address recipient, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Returns the remaining number of tokens that `spender` will be
136      * allowed to spend on behalf of `owner` through {transferFrom}. This is
137      * zero by default.
138      *
139      * This value changes when {approve} or {transferFrom} are called.
140      */
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     /**
144      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * IMPORTANT: Beware that changing an allowance with this method brings the risk
149      * that someone may use both the old and the new allowance by unfortunate
150      * transaction ordering. One possible solution to mitigate this race
151      * condition is to first reduce the spender's allowance to 0 and set the
152      * desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address spender, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Moves `amount` tokens from `sender` to `recipient` using the
161      * allowance mechanism. `amount` is then deducted from the caller's
162      * allowance.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
190 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
191 
192 /* pragma solidity ^0.8.0; */
193 
194 /* import "../IERC20.sol"; */
195 
196 /**
197  * @dev Interface for the optional metadata functions from the ERC20 standard.
198  *
199  * _Available since v4.1._
200  */
201 interface IERC20Metadata is IERC20 {
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() external view returns (string memory);
206 
207     /**
208      * @dev Returns the symbol of the token.
209      */
210     function symbol() external view returns (string memory);
211 
212     /**
213      * @dev Returns the decimals places of the token.
214      */
215     function decimals() external view returns (uint8);
216 }
217 
218 /**
219  * @dev Implementation of the {IERC20} interface.
220  *
221  * This implementation is agnostic to the way tokens are created. This means
222  * that a supply mechanism has to be added in a derived contract using {_mint}.
223  * For a generic mechanism see {ERC20PresetMinterPauser}.
224  *
225  * TIP: For a detailed writeup see our guide
226  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
227  * to implement supply mechanisms].
228  *
229  * We have followed general OpenZeppelin Contracts guidelines: functions revert
230  * instead returning `false` on failure. This behavior is nonetheless
231  * conventional and does not conflict with the expectations of ERC20
232  * applications.
233  *
234  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
235  * This allows applications to reconstruct the allowance for all accounts just
236  * by listening to said events. Other implementations of the EIP may not emit
237  * these events, as it isn't required by the specification.
238  *
239  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
240  * functions have been added to mitigate the well-known issues around setting
241  * allowances. See {IERC20-approve}.
242  */
243 contract ERC20 is Context, IERC20, IERC20Metadata {
244     mapping(address => uint256) private _balances;
245 
246     mapping(address => mapping(address => uint256)) private _allowances;
247 
248     uint256 private _totalSupply;
249 
250     string private _name;
251     string private _symbol;
252 
253     /**
254      * @dev Sets the values for {name} and {symbol}.
255      *
256      * The default value of {decimals} is 18. To select a different value for
257      * {decimals} you should overload it.
258      *
259      * All two of these values are immutable: they can only be set once during
260      * construction.
261      */
262     constructor(string memory name_, string memory symbol_) {
263         _name = name_;
264         _symbol = symbol_;
265     }
266 
267     /**
268      * @dev Returns the name of the token.
269      */
270     function name() public view virtual override returns (string memory) {
271         return _name;
272     }
273 
274     /**
275      * @dev Returns the symbol of the token, usually a shorter version of the
276      * name.
277      */
278     function symbol() public view virtual override returns (string memory) {
279         return _symbol;
280     }
281 
282     /**
283      * @dev Returns the number of decimals used to get its user representation.
284      * For example, if `decimals` equals `2`, a balance of `505` tokens should
285      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
286      *
287      * Tokens usually opt for a value of 18, imitating the relationship between
288      * Ether and Wei. This is the value {ERC20} uses, unless this function is
289      * overridden;
290      *
291      * NOTE: This information is only used for _display_ purposes: it in
292      * no way affects any of the arithmetic of the contract, including
293      * {IERC20-balanceOf} and {IERC20-transfer}.
294      */
295     function decimals() public view virtual override returns (uint8) {
296         return 18;
297     }
298 
299     /**
300      * @dev See {IERC20-totalSupply}.
301      */
302     function totalSupply() public view virtual override returns (uint256) {
303         return _totalSupply;
304     }
305 
306     /**
307      * @dev See {IERC20-balanceOf}.
308      */
309     function balanceOf(address account) public view virtual override returns (uint256) {
310         return _balances[account];
311     }
312 
313     /**
314      * @dev See {IERC20-transfer}.
315      *
316      * Requirements:
317      *
318      * - `recipient` cannot be the zero address.
319      * - the caller must have a balance of at least `amount`.
320      */
321     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
322         _transfer(_msgSender(), recipient, amount);
323         return true;
324     }
325 
326     /**
327      * @dev See {IERC20-allowance}.
328      */
329     function allowance(address owner, address spender) public view virtual override returns (uint256) {
330         return _allowances[owner][spender];
331     }
332 
333     /**
334      * @dev See {IERC20-approve}.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      */
340     function approve(address spender, uint256 amount) public virtual override returns (bool) {
341         _approve(_msgSender(), spender, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-transferFrom}.
347      *
348      * Emits an {Approval} event indicating the updated allowance. This is not
349      * required by the EIP. See the note at the beginning of {ERC20}.
350      *
351      * Requirements:
352      *
353      * - `sender` and `recipient` cannot be the zero address.
354      * - `sender` must have a balance of at least `amount`.
355      * - the caller must have allowance for ``sender``'s tokens of at least
356      * `amount`.
357      */
358     function transferFrom(
359         address sender,
360         address recipient,
361         uint256 amount
362     ) public virtual override returns (bool) {
363         _transfer(sender, recipient, amount);
364 
365         uint256 currentAllowance = _allowances[sender][_msgSender()];
366         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
367         unchecked {
368             _approve(sender, _msgSender(), currentAllowance - amount);
369         }
370 
371         return true;
372     }
373 
374     /**
375      * @dev Atomically increases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to {approve} that can be used as a mitigation for
378      * problems described in {IERC20-approve}.
379      *
380      * Emits an {Approval} event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      */
386     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
387         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
388         return true;
389     }
390 
391     /**
392      * @dev Atomically decreases the allowance granted to `spender` by the caller.
393      *
394      * This is an alternative to {approve} that can be used as a mitigation for
395      * problems described in {IERC20-approve}.
396      *
397      * Emits an {Approval} event indicating the updated allowance.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      * - `spender` must have allowance for the caller of at least
403      * `subtractedValue`.
404      */
405     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
406         uint256 currentAllowance = _allowances[_msgSender()][spender];
407         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
408         unchecked {
409             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
410         }
411 
412         return true;
413     }
414 
415     /**
416      * @dev Moves `amount` of tokens from `sender` to `recipient`.
417      *
418      * This internal function is equivalent to {transfer}, and can be used to
419      * e.g. implement automatic token fees, slashing mechanisms, etc.
420      *
421      * Emits a {Transfer} event.
422      *
423      * Requirements:
424      *
425      * - `sender` cannot be the zero address.
426      * - `recipient` cannot be the zero address.
427      * - `sender` must have a balance of at least `amount`.
428      */
429     function _transfer(
430         address sender,
431         address recipient,
432         uint256 amount
433     ) internal virtual {
434         require(sender != address(0), "ERC20: transfer from the zero address");
435         require(recipient != address(0), "ERC20: transfer to the zero address");
436 
437         _beforeTokenTransfer(sender, recipient, amount);
438 
439         uint256 senderBalance = _balances[sender];
440         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
441         unchecked {
442             _balances[sender] = senderBalance - amount;
443         }
444         _balances[recipient] += amount;
445 
446         emit Transfer(sender, recipient, amount);
447 
448         _afterTokenTransfer(sender, recipient, amount);
449     }
450 
451     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
452      * the total supply.
453      *
454      * Emits a {Transfer} event with `from` set to the zero address.
455      *
456      * Requirements:
457      *
458      * - `account` cannot be the zero address.
459      */
460     function _mint(address account, uint256 amount) internal virtual {
461         require(account != address(0), "ERC20: mint to the zero address");
462 
463         _beforeTokenTransfer(address(0), account, amount);
464 
465         _totalSupply += amount;
466         _balances[account] += amount;
467         emit Transfer(address(0), account, amount);
468 
469         _afterTokenTransfer(address(0), account, amount);
470     }
471 
472     /**
473      * @dev Destroys `amount` tokens from `account`, reducing the
474      * total supply.
475      *
476      * Emits a {Transfer} event with `to` set to the zero address.
477      *
478      * Requirements:
479      *
480      * - `account` cannot be the zero address.
481      * - `account` must have at least `amount` tokens.
482      */
483     function _burn(address account, uint256 amount) internal virtual {
484         require(account != address(0), "ERC20: burn from the zero address");
485 
486         _beforeTokenTransfer(account, address(0), amount);
487 
488         uint256 accountBalance = _balances[account];
489         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
490         unchecked {
491             _balances[account] = accountBalance - amount;
492         }
493         _totalSupply -= amount;
494 
495         emit Transfer(account, address(0), amount);
496 
497         _afterTokenTransfer(account, address(0), amount);
498     }
499 
500     /**
501      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
502      *
503      * This internal function is equivalent to `approve`, and can be used to
504      * e.g. set automatic allowances for certain subsystems, etc.
505      *
506      * Emits an {Approval} event.
507      *
508      * Requirements:
509      *
510      * - `owner` cannot be the zero address.
511      * - `spender` cannot be the zero address.
512      */
513     function _approve(
514         address owner,
515         address spender,
516         uint256 amount
517     ) internal virtual {
518         require(owner != address(0), "ERC20: approve from the zero address");
519         require(spender != address(0), "ERC20: approve to the zero address");
520 
521         _allowances[owner][spender] = amount;
522         emit Approval(owner, spender, amount);
523     }
524 
525     /**
526      * @dev Hook that is called before any transfer of tokens. This includes
527      * minting and burning.
528      *
529      * Calling conditions:
530      *
531      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
532      * will be transferred to `to`.
533      * - when `from` is zero, `amount` tokens will be minted for `to`.
534      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
535      * - `from` and `to` are never both zero.
536      *
537      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
538      */
539     function _beforeTokenTransfer(
540         address from,
541         address to,
542         uint256 amount
543     ) internal virtual {}
544 
545     /**
546      * @dev Hook that is called after any transfer of tokens. This includes
547      * minting and burning.
548      *
549      * Calling conditions:
550      *
551      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
552      * has been transferred to `to`.
553      * - when `from` is zero, `amount` tokens have been minted for `to`.
554      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
555      * - `from` and `to` are never both zero.
556      *
557      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
558      */
559     function _afterTokenTransfer(
560         address from,
561         address to,
562         uint256 amount
563     ) internal virtual {}
564 }
565 
566 /**
567  * @dev Wrappers over Solidity's arithmetic operations.
568  *
569  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
570  * now has built in overflow checking.
571  */
572 library SafeMath {
573     /**
574      * @dev Returns the addition of two unsigned integers, with an overflow flag.
575      *
576      * _Available since v3.4._
577      */
578     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
579         unchecked {
580             uint256 c = a + b;
581             if (c < a) return (false, 0);
582             return (true, c);
583         }
584     }
585 
586     /**
587      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
588      *
589      * _Available since v3.4._
590      */
591     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
592         unchecked {
593             if (b > a) return (false, 0);
594             return (true, a - b);
595         }
596     }
597 
598     /**
599      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
600      *
601      * _Available since v3.4._
602      */
603     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
604         unchecked {
605             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
606             // benefit is lost if 'b' is also tested.
607             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
608             if (a == 0) return (true, 0);
609             uint256 c = a * b;
610             if (c / a != b) return (false, 0);
611             return (true, c);
612         }
613     }
614 
615     /**
616      * @dev Returns the division of two unsigned integers, with a division by zero flag.
617      *
618      * _Available since v3.4._
619      */
620     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
621         unchecked {
622             if (b == 0) return (false, 0);
623             return (true, a / b);
624         }
625     }
626 
627     /**
628      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
629      *
630      * _Available since v3.4._
631      */
632     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
633         unchecked {
634             if (b == 0) return (false, 0);
635             return (true, a % b);
636         }
637     }
638 
639     /**
640      * @dev Returns the addition of two unsigned integers, reverting on
641      * overflow.
642      *
643      * Counterpart to Solidity's `+` operator.
644      *
645      * Requirements:
646      *
647      * - Addition cannot overflow.
648      */
649     function add(uint256 a, uint256 b) internal pure returns (uint256) {
650         return a + b;
651     }
652 
653     /**
654      * @dev Returns the subtraction of two unsigned integers, reverting on
655      * overflow (when the result is negative).
656      *
657      * Counterpart to Solidity's `-` operator.
658      *
659      * Requirements:
660      *
661      * - Subtraction cannot overflow.
662      */
663     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
664         return a - b;
665     }
666 
667     /**
668      * @dev Returns the multiplication of two unsigned integers, reverting on
669      * overflow.
670      *
671      * Counterpart to Solidity's `*` operator.
672      *
673      * Requirements:
674      *
675      * - Multiplication cannot overflow.
676      */
677     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
678         return a * b;
679     }
680 
681     /**
682      * @dev Returns the integer division of two unsigned integers, reverting on
683      * division by zero. The result is rounded towards zero.
684      *
685      * Counterpart to Solidity's `/` operator.
686      *
687      * Requirements:
688      *
689      * - The divisor cannot be zero.
690      */
691     function div(uint256 a, uint256 b) internal pure returns (uint256) {
692         return a / b;
693     }
694 
695     /**
696      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
697      * reverting when dividing by zero.
698      *
699      * Counterpart to Solidity's `%` operator. This function uses a `revert`
700      * opcode (which leaves remaining gas untouched) while Solidity uses an
701      * invalid opcode to revert (consuming all remaining gas).
702      *
703      * Requirements:
704      *
705      * - The divisor cannot be zero.
706      */
707     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
708         return a % b;
709     }
710 
711     /**
712      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
713      * overflow (when the result is negative).
714      *
715      * CAUTION: This function is deprecated because it requires allocating memory for the error
716      * message unnecessarily. For custom revert reasons use {trySub}.
717      *
718      * Counterpart to Solidity's `-` operator.
719      *
720      * Requirements:
721      *
722      * - Subtraction cannot overflow.
723      */
724     function sub(
725         uint256 a,
726         uint256 b,
727         string memory errorMessage
728     ) internal pure returns (uint256) {
729         unchecked {
730             require(b <= a, errorMessage);
731             return a - b;
732         }
733     }
734 
735     /**
736      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
737      * division by zero. The result is rounded towards zero.
738      *
739      * Counterpart to Solidity's `/` operator. Note: this function uses a
740      * `revert` opcode (which leaves remaining gas untouched) while Solidity
741      * uses an invalid opcode to revert (consuming all remaining gas).
742      *
743      * Requirements:
744      *
745      * - The divisor cannot be zero.
746      */
747     function div(
748         uint256 a,
749         uint256 b,
750         string memory errorMessage
751     ) internal pure returns (uint256) {
752         unchecked {
753             require(b > 0, errorMessage);
754             return a / b;
755         }
756     }
757 
758     /**
759      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
760      * reverting with custom message when dividing by zero.
761      *
762      * CAUTION: This function is deprecated because it requires allocating memory for the error
763      * message unnecessarily. For custom revert reasons use {tryMod}.
764      *
765      * Counterpart to Solidity's `%` operator. This function uses a `revert`
766      * opcode (which leaves remaining gas untouched) while Solidity uses an
767      * invalid opcode to revert (consuming all remaining gas).
768      *
769      * Requirements:
770      *
771      * - The divisor cannot be zero.
772      */
773     function mod(
774         uint256 a,
775         uint256 b,
776         string memory errorMessage
777     ) internal pure returns (uint256) {
778         unchecked {
779             require(b > 0, errorMessage);
780             return a % b;
781         }
782     }
783 }
784 
785 interface IUniswapV2Factory {
786     event PairCreated(
787         address indexed token0,
788         address indexed token1,
789         address pair,
790         uint256
791     );
792 
793     function feeTo() external view returns (address);
794 
795     function feeToSetter() external view returns (address);
796 
797     function getPair(address tokenA, address tokenB)
798         external
799         view
800         returns (address pair);
801 
802     function allPairs(uint256) external view returns (address pair);
803 
804     function allPairsLength() external view returns (uint256);
805 
806     function createPair(address tokenA, address tokenB)
807         external
808         returns (address pair);
809 
810     function setFeeTo(address) external;
811 
812     function setFeeToSetter(address) external;
813 }
814 
815 ////// src/IUniswapV2Pair.sol
816 /* pragma solidity 0.8.10; */
817 /* pragma experimental ABIEncoderV2; */
818 
819 interface IUniswapV2Pair {
820     event Approval(
821         address indexed owner,
822         address indexed spender,
823         uint256 value
824     );
825     event Transfer(address indexed from, address indexed to, uint256 value);
826 
827     function name() external pure returns (string memory);
828 
829     function symbol() external pure returns (string memory);
830 
831     function decimals() external pure returns (uint8);
832 
833     function totalSupply() external view returns (uint256);
834 
835     function balanceOf(address owner) external view returns (uint256);
836 
837     function allowance(address owner, address spender)
838         external
839         view
840         returns (uint256);
841 
842     function approve(address spender, uint256 value) external returns (bool);
843 
844     function transfer(address to, uint256 value) external returns (bool);
845 
846     function transferFrom(
847         address from,
848         address to,
849         uint256 value
850     ) external returns (bool);
851 
852     function DOMAIN_SEPARATOR() external view returns (bytes32);
853 
854     function PERMIT_TYPEHASH() external pure returns (bytes32);
855 
856     function nonces(address owner) external view returns (uint256);
857 
858     function permit(
859         address owner,
860         address spender,
861         uint256 value,
862         uint256 deadline,
863         uint8 v,
864         bytes32 r,
865         bytes32 s
866     ) external;
867 
868     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
869     event Burn(
870         address indexed sender,
871         uint256 amount0,
872         uint256 amount1,
873         address indexed to
874     );
875     event Swap(
876         address indexed sender,
877         uint256 amount0In,
878         uint256 amount1In,
879         uint256 amount0Out,
880         uint256 amount1Out,
881         address indexed to
882     );
883     event Sync(uint112 reserve0, uint112 reserve1);
884 
885     function MINIMUM_LIQUIDITY() external pure returns (uint256);
886 
887     function factory() external view returns (address);
888 
889     function token0() external view returns (address);
890 
891     function token1() external view returns (address);
892 
893     function getReserves()
894         external
895         view
896         returns (
897             uint112 reserve0,
898             uint112 reserve1,
899             uint32 blockTimestampLast
900         );
901 
902     function price0CumulativeLast() external view returns (uint256);
903 
904     function price1CumulativeLast() external view returns (uint256);
905 
906     function kLast() external view returns (uint256);
907 
908     function mint(address to) external returns (uint256 liquidity);
909 
910     function burn(address to)
911         external
912         returns (uint256 amount0, uint256 amount1);
913 
914     function swap(
915         uint256 amount0Out,
916         uint256 amount1Out,
917         address to,
918         bytes calldata data
919     ) external;
920 
921     function skim(address to) external;
922 
923     function sync() external;
924 
925     function initialize(address, address) external;
926 }
927 
928 interface IUniswapV2Router02 {
929     function factory() external pure returns (address);
930 
931     function WETH() external pure returns (address);
932 
933     function addLiquidity(
934         address tokenA,
935         address tokenB,
936         uint256 amountADesired,
937         uint256 amountBDesired,
938         uint256 amountAMin,
939         uint256 amountBMin,
940         address to,
941         uint256 deadline
942     )
943         external
944         returns (
945             uint256 amountA,
946             uint256 amountB,
947             uint256 liquidity
948         );
949 
950     function addLiquidityETH(
951         address token,
952         uint256 amountTokenDesired,
953         uint256 amountTokenMin,
954         uint256 amountETHMin,
955         address to,
956         uint256 deadline
957     )
958         external
959         payable
960         returns (
961             uint256 amountToken,
962             uint256 amountETH,
963             uint256 liquidity
964         );
965 
966     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
967         uint256 amountIn,
968         uint256 amountOutMin,
969         address[] calldata path,
970         address to,
971         uint256 deadline
972     ) external;
973 
974     function swapExactETHForTokensSupportingFeeOnTransferTokens(
975         uint256 amountOutMin,
976         address[] calldata path,
977         address to,
978         uint256 deadline
979     ) external payable;
980 
981     function swapExactTokensForETHSupportingFeeOnTransferTokens(
982         uint256 amountIn,
983         uint256 amountOutMin,
984         address[] calldata path,
985         address to,
986         uint256 deadline
987     ) external;
988 }
989 
990 contract Cuckadoodledoo is ERC20, Ownable {
991     using SafeMath for uint256;
992 
993     IUniswapV2Router02 public immutable uniswapV2Router;
994     address public immutable uniswapV2Pair;
995     address public constant deadAddress = address(0x0);
996 
997     bool private swapping;
998 
999     address public teamWallet;
1000 
1001     uint256 public maxTransactionAmount;
1002     uint256 public swapTokensAtAmount;
1003     uint256 public maxWallet;
1004 
1005     bool public limitsInEffect = true;
1006     bool public tradingActive = false;
1007     bool public swapEnabled = false;
1008 
1009     bool public blacklistRenounced = false;
1010 
1011     // Anti-bot and anti-whale mappings and variables
1012     mapping(address => bool) blacklisted;
1013 
1014     uint256 public buyTotalFees;
1015     uint256 public buyBurnFee;
1016     uint256 public buyLiquidityFee;
1017     uint256 public buyTeamFee;
1018 
1019     uint256 public sellTotalFees;
1020     uint256 public sellBurnFee;
1021     uint256 public sellLiquidityFee;
1022     uint256 public sellTeamFee;
1023 
1024     uint256 public tokensForBurn;
1025     uint256 public tokensForLiquidity;
1026     uint256 public tokensForTeam;
1027 
1028     /******************/
1029 
1030     // exclude from fees and max transaction amount
1031     mapping(address => bool) private _isExcludedFromFees;
1032     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1033 
1034     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1035     // could be subject to a maximum transfer amount
1036     mapping(address => bool) public automatedMarketMakerPairs;
1037 
1038     bool public preMigrationPhase = true;
1039     mapping(address => bool) public preMigrationTransferrable;
1040 
1041     event UpdateUniswapV2Router(
1042         address indexed newAddress,
1043         address indexed oldAddress
1044     );
1045 
1046     event ExcludeFromFees(address indexed account, bool isExcluded);
1047 
1048     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1049 
1050     event teamWalletUpdated(
1051         address indexed newWallet,
1052         address indexed oldWallet
1053     );
1054 
1055     event SwapAndLiquify(
1056         uint256 tokensSwapped,
1057         uint256 ethReceived,
1058         uint256 tokensIntoLiquidity
1059     );
1060 
1061     constructor() ERC20("Cuckadoodledoo", "CUCK") {
1062         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1063            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1064         );
1065 
1066         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1067         uniswapV2Router = _uniswapV2Router;
1068 
1069         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1070             .createPair(address(this), _uniswapV2Router.WETH());
1071         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1072         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1073 
1074         uint256 _buyBurnFee = 1;
1075         uint256 _buyLiquidityFee = 1;
1076         uint256 _buyTeamFee = 1;
1077 
1078         uint256 _sellBurnFee = 1;
1079         uint256 _sellLiquidityFee = 1;
1080         uint256 _sellTeamFee = 1;
1081 
1082         uint256 totalSupply = 42_000_000 * 1e18;
1083 
1084         maxTransactionAmount = 420_000 * 1e18; // 1%
1085         maxWallet = 420_000 * 1e18; // 1% 
1086         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% 
1087 
1088         buyBurnFee = _buyBurnFee;
1089         buyLiquidityFee = _buyLiquidityFee;
1090         buyTeamFee = _buyTeamFee;
1091         buyTotalFees = buyBurnFee + buyLiquidityFee + buyTeamFee;
1092 
1093         sellBurnFee = _sellBurnFee;
1094         sellLiquidityFee = _sellLiquidityFee;
1095         sellTeamFee = _sellTeamFee;
1096         sellTotalFees = sellBurnFee + sellLiquidityFee + sellTeamFee;
1097         teamWallet = owner(); // set as team wallet
1098 
1099         // exclude from paying fees or having max transaction amount
1100         excludeFromFees(owner(), true);
1101         excludeFromFees(address(this), true);
1102         excludeFromFees(deadAddress, true);
1103         
1104 
1105         excludeFromMaxTransaction(owner(), true);
1106         excludeFromMaxTransaction(address(this), true);
1107         excludeFromMaxTransaction(deadAddress, true);
1108 
1109         preMigrationTransferrable[owner()] = true;
1110 
1111         /*
1112             _mint is an internal function in ERC20.sol that is only called here,
1113             and CANNOT be called ever again
1114         */
1115         _mint(msg.sender, totalSupply);
1116     }
1117 
1118     receive() external payable {}
1119 
1120     // once enabled, can never be turned off
1121     function enableTrading() external onlyOwner {
1122         tradingActive = true;
1123         swapEnabled = true;
1124         preMigrationPhase = false;
1125     }
1126 
1127     // remove limits after token is stable
1128     function removeLimits() external onlyOwner returns (bool) {
1129         limitsInEffect = false;
1130         return true;
1131     }
1132 
1133     // change the minimum amount of tokens to sell from fees
1134     function updateSwapTokensAtAmount(uint256 newAmount)
1135         external
1136         onlyOwner
1137         returns (bool)
1138     {
1139         require(
1140             newAmount >= (totalSupply() * 1) / 100000,
1141             "Swap amount cannot be lower than 0.001% total supply."
1142         );
1143         require(
1144             newAmount <= (totalSupply() * 5) / 1000,
1145             "Swap amount cannot be higher than 0.5% total supply."
1146         );
1147         swapTokensAtAmount = newAmount;
1148         return true;
1149     }
1150 
1151     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1152         require(
1153             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1154             "Cannot set maxTransactionAmount lower than 0.5%"
1155         );
1156         maxTransactionAmount = newNum * (10**18);
1157     }
1158 
1159     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1160         require(
1161             newNum >= ((totalSupply() * 10) / 1000) / 1e18,
1162             "Cannot set maxWallet lower than 1.0%"
1163         );
1164         maxWallet = newNum * (10**18);
1165     }
1166 
1167     function excludeFromMaxTransaction(address updAds, bool isEx)
1168         public
1169         onlyOwner
1170     {
1171         _isExcludedMaxTransactionAmount[updAds] = isEx;
1172     }
1173 
1174     // only use to disable contract sales if absolutely necessary (emergency use only)
1175     function updateSwapEnabled(bool enabled) external onlyOwner {
1176         swapEnabled = enabled;
1177     }
1178 
1179     function updateBuyFees(
1180         uint256 _burnFee,
1181         uint256 _liquidityFee,
1182         uint256 _teamFee
1183     ) external onlyOwner {
1184         buyBurnFee = _burnFee;
1185         buyLiquidityFee = _liquidityFee;
1186         buyTeamFee = _teamFee;
1187         buyTotalFees = buyBurnFee + buyLiquidityFee + buyTeamFee;
1188         require(buyTotalFees <= 5, "Buy fees must be <= 5.");
1189     }
1190 
1191     function updateSellFees(
1192         uint256 _burnFee,
1193         uint256 _liquidityFee,
1194         uint256 _teamFee
1195     ) external onlyOwner {
1196         sellBurnFee = _burnFee;
1197         sellLiquidityFee = _liquidityFee;
1198         sellTeamFee = _teamFee;
1199         sellTotalFees = sellBurnFee + sellLiquidityFee + sellTeamFee;
1200         require(sellTotalFees <= 5, "Sell fees must be <= 5.");
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
1226     function updateTeamWallet(address newWallet) external onlyOwner {
1227         emit teamWalletUpdated(newWallet, teamWallet);
1228         teamWallet = newWallet;
1229     }
1230 
1231     function isExcludedFromFees(address account) public view returns (bool) {
1232         return _isExcludedFromFees[account];
1233     }
1234 
1235     function isBlacklisted(address account) public view returns (bool) {
1236         return blacklisted[account];
1237     }
1238 
1239     function _transfer(
1240         address from,
1241         address to,
1242         uint256 amount
1243     ) internal override {
1244         require(from != address(0), "ERC20: transfer from the zero address");
1245         require(to != address(0), "ERC20: transfer to the zero address");
1246         require(!blacklisted[from],"Sender blacklisted");
1247         require(!blacklisted[to],"Receiver blacklisted");
1248 
1249         if (preMigrationPhase) {
1250             require(preMigrationTransferrable[from], "Not authorized to transfer pre-migration.");
1251         }
1252 
1253         if (amount == 0) {
1254             super._transfer(from, to, 0);
1255             return;
1256         }
1257 
1258         if (limitsInEffect) {
1259             if (
1260                 from != owner() &&
1261                 to != owner() &&
1262                 to != address(0) &&
1263                 to != deadAddress &&
1264                 !swapping
1265             ) {
1266                 if (!tradingActive) {
1267                     require(
1268                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1269                         "Trading is not active."
1270                     );
1271                 }
1272 
1273                 //when buy
1274                 if (
1275                     automatedMarketMakerPairs[from] &&
1276                     !_isExcludedMaxTransactionAmount[to]
1277                 ) {
1278                     require(
1279                         amount <= maxTransactionAmount,
1280                         "Buy transfer amount exceeds the maxTransactionAmount."
1281                     );
1282                     require(
1283                         amount + balanceOf(to) <= maxWallet,
1284                         "Max wallet exceeded"
1285                     );
1286                 }
1287                 //when sell
1288                 else if (
1289                     automatedMarketMakerPairs[to] &&
1290                     !_isExcludedMaxTransactionAmount[from]
1291                 ) {
1292                     require(
1293                         amount <= maxTransactionAmount,
1294                         "Sell transfer amount exceeds the maxTransactionAmount."
1295                     );
1296                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1297                     require(
1298                         amount + balanceOf(to) <= maxWallet,
1299                         "Max wallet exceeded"
1300                     );
1301                 }
1302             }
1303         }
1304 
1305         uint256 contractTokenBalance = balanceOf(address(this));
1306 
1307         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1308 
1309         if (
1310             canSwap &&
1311             swapEnabled &&
1312             !swapping &&
1313             !automatedMarketMakerPairs[from] &&
1314             !_isExcludedFromFees[from] &&
1315             !_isExcludedFromFees[to]
1316         ) {
1317             swapping = true;
1318 
1319             swapBack();
1320 
1321             swapping = false;
1322         }
1323 
1324         bool takeFee = !swapping;
1325 
1326         // if any account belongs to _isExcludedFromFee account then remove the fee
1327         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1328             takeFee = false;
1329         }
1330 
1331         uint256 fees = 0;
1332         // only take fees on buys/sells, do not take on wallet transfers
1333         if (takeFee) {
1334             // on sell
1335             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1336                 fees = amount.mul(sellTotalFees).div(100);
1337                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1338                 tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
1339                 tokensForBurn += (fees * sellBurnFee) / sellTotalFees;
1340             }
1341             // on buy
1342             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1343                 fees = amount.mul(buyTotalFees).div(100);
1344                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1345                 tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
1346                 tokensForBurn += (fees * buyBurnFee) / buyTotalFees;
1347             }
1348 
1349             if (fees > 0) {
1350                 super._transfer(from, address(this), fees);
1351             }
1352 			
1353 			if (tokensForBurn > 0) {
1354 				super._transfer(from, deadAddress, tokensForBurn);
1355 				tokensForBurn = 0;
1356 			}
1357 
1358             amount -= fees;
1359         }
1360 
1361         super._transfer(from, to, amount);
1362     }
1363 
1364     function swapTokensForEth(uint256 tokenAmount) private {
1365         // generate the uniswap pair path of token -> weth
1366         address[] memory path = new address[](2);
1367         path[0] = address(this);
1368         path[1] = uniswapV2Router.WETH();
1369 
1370         _approve(address(this), address(uniswapV2Router), tokenAmount);
1371 
1372         // make the swap
1373         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1374             tokenAmount,
1375             0, // accept any amount of ETH
1376             path,
1377             address(this),
1378             block.timestamp
1379         );
1380     }
1381 
1382     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1383         // approve token transfer to cover all possible scenarios
1384         _approve(address(this), address(uniswapV2Router), tokenAmount);
1385 
1386         // add the liquidity
1387         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1388             address(this),
1389             tokenAmount,
1390             0, // slippage is unavoidable
1391             0, // slippage is unavoidable
1392             owner(),
1393             block.timestamp
1394         );
1395     }
1396 
1397     function swapBack() private {
1398         uint256 contractBalance = balanceOf(address(this));
1399         uint256 totalTokensToSwap = tokensForLiquidity +
1400             tokensForTeam;
1401         bool success;
1402 
1403         if (contractBalance == 0 || totalTokensToSwap == 0) {
1404             return;
1405         }
1406 
1407         if (contractBalance > swapTokensAtAmount * 20) {
1408             contractBalance = swapTokensAtAmount * 20;
1409         }
1410 
1411         // Halve the amount of liquidity tokens
1412         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1413             totalTokensToSwap /
1414             2;
1415         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1416 
1417         uint256 initialETHBalance = address(this).balance;
1418 
1419         swapTokensForEth(amountToSwapForETH);
1420 
1421         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1422 
1423         uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(totalTokensToSwap - (tokensForLiquidity / 2));
1424 
1425         uint256 ethForLiquidity = ethBalance - ethForTeam;
1426 
1427         tokensForLiquidity = 0;
1428         tokensForTeam = 0;
1429 
1430         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1431             addLiquidity(liquidityTokens, ethForLiquidity);
1432             emit SwapAndLiquify(
1433                 amountToSwapForETH,
1434                 ethForLiquidity,
1435                 tokensForLiquidity
1436             );
1437         }
1438 
1439         (success, ) = address(teamWallet).call{value: address(this).balance}("");
1440     }
1441 
1442     function withdrawStuckStealth() external onlyOwner {
1443         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1444         IERC20(address(this)).transfer(msg.sender, balance);
1445         payable(msg.sender).transfer(address(this).balance);
1446     }
1447 
1448     function withdrawStuckToken(address _token, address _to) external onlyOwner {
1449         require(_token != address(0), "_token address cannot be 0");
1450         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1451         IERC20(_token).transfer(_to, _contractBalance);
1452     }
1453 
1454     function withdrawStuckEth(address toAddr) external onlyOwner {
1455         (bool success, ) = toAddr.call{
1456             value: address(this).balance
1457         } ("");
1458         require(success);
1459     }
1460 
1461     // @dev team renounce blacklist commands
1462     function renounceBlacklist() public onlyOwner {
1463         blacklistRenounced = true;
1464     }
1465 
1466     function blacklist(address _addr) public onlyOwner {
1467         require(!blacklistRenounced, "Team has revoked blacklist rights");
1468         require(
1469             _addr != address(uniswapV2Pair) && _addr != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1470             "Cannot blacklist token's v2 router or v2 pool."
1471         );
1472         blacklisted[_addr] = true;
1473     }
1474 
1475     // @dev blacklist v3 pools; can unblacklist() down the road to suit project and community
1476     function blacklistLiquidityPool(address lpAddress) public onlyOwner {
1477         require(!blacklistRenounced, "Team has revoked blacklist rights");
1478         require(
1479             lpAddress != address(uniswapV2Pair) && lpAddress != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1480             "Cannot blacklist token's v2 router or v2 pool."
1481         );
1482         blacklisted[lpAddress] = true;
1483     }
1484 
1485     // @dev unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
1486     function unblacklist(address _addr) public onlyOwner {
1487         blacklisted[_addr] = false;
1488     }
1489 
1490     function setPreMigrationTransferable(address _addr, bool isAuthorized) public onlyOwner {
1491         preMigrationTransferrable[_addr] = isAuthorized;
1492         excludeFromFees(_addr, isAuthorized);
1493         excludeFromMaxTransaction(_addr, isAuthorized);
1494     }
1495 }