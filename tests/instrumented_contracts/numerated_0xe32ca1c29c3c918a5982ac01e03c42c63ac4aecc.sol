1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 Please see: https://dogoodcrypto.eth.link/
6 
7 
8 **/
9 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
10 pragma experimental ABIEncoderV2;
11 
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Internal function without access restriction.
96      */
97     function _transferOwnership(address newOwner) internal virtual {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 
105 /**
106  * @dev Interface of the ERC20 standard as defined in the EIP.
107  */
108 interface IERC20 {
109     /**
110      * @dev Returns the amount of tokens in existence.
111      */
112     function totalSupply() external view returns (uint256);
113 
114     /**
115      * @dev Returns the amount of tokens owned by `account`.
116      */
117     function balanceOf(address account) external view returns (uint256);
118 
119     /**
120      * @dev Moves `amount` tokens from the caller's account to `recipient`.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transfer(address recipient, uint256 amount) external returns (bool);
127 
128     /**
129      * @dev Returns the remaining number of tokens that `spender` will be
130      * allowed to spend on behalf of `owner` through {transferFrom}. This is
131      * zero by default.
132      *
133      * This value changes when {approve} or {transferFrom} are called.
134      */
135     function allowance(address owner, address spender) external view returns (uint256);
136 
137     /**
138      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * IMPORTANT: Beware that changing an allowance with this method brings the risk
143      * that someone may use both the old and the new allowance by unfortunate
144      * transaction ordering. One possible solution to mitigate this race
145      * condition is to first reduce the spender's allowance to 0 and set the
146      * desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address spender, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Moves `amount` tokens from `sender` to `recipient` using the
155      * allowance mechanism. `amount` is then deducted from the caller's
156      * allowance.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transferFrom(
163         address sender,
164         address recipient,
165         uint256 amount
166     ) external returns (bool);
167 
168     /**
169      * @dev Emitted when `value` tokens are moved from one account (`from`) to
170      * another (`to`).
171      *
172      * Note that `value` may be zero.
173      */
174     event Transfer(address indexed from, address indexed to, uint256 value);
175 
176     /**
177      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
178      * a call to {approve}. `value` is the new allowance.
179      */
180     event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 
184 
185 /**
186  * @dev Interface for the optional metadata functions from the ERC20 standard.
187  *
188  * _Available since v4.1._
189  */
190 interface IERC20Metadata is IERC20 {
191     /**
192      * @dev Returns the name of the token.
193      */
194     function name() external view returns (string memory);
195 
196     /**
197      * @dev Returns the symbol of the token.
198      */
199     function symbol() external view returns (string memory);
200 
201     /**
202      * @dev Returns the decimals places of the token.
203      */
204     function decimals() external view returns (uint8);
205 }
206 
207 
208 /**
209  * @dev Implementation of the {IERC20} interface.
210  *
211  * This implementation is agnostic to the way tokens are created. This means
212  * that a supply mechanism has to be added in a derived contract using {_mint}.
213  * For a generic mechanism see {ERC20PresetMinterPauser}.
214  *
215  * TIP: For a detailed writeup see our guide
216  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
217  * to implement supply mechanisms].
218  *
219  * We have followed general OpenZeppelin Contracts guidelines: functions revert
220  * instead returning `false` on failure. This behavior is nonetheless
221  * conventional and does not conflict with the expectations of ERC20
222  * applications.
223  *
224  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
225  * This allows applications to reconstruct the allowance for all accounts just
226  * by listening to said events. Other implementations of the EIP may not emit
227  * these events, as it isn't required by the specification.
228  *
229  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
230  * functions have been added to mitigate the well-known issues around setting
231  * allowances. See {IERC20-approve}.
232  */
233 contract ERC20 is Context, IERC20, IERC20Metadata {
234     mapping(address => uint256) private _balances;
235 
236     mapping(address => mapping(address => uint256)) private _allowances;
237 
238     uint256 private _totalSupply;
239 
240     string private _name;
241     string private _symbol;
242 
243     /**
244      * @dev Sets the values for {name} and {symbol}.
245      *
246      * The default value of {decimals} is 18. To select a different value for
247      * {decimals} you should overload it.
248      *
249      * All two of these values are immutable: they can only be set once during
250      * construction.
251      */
252     constructor(string memory name_, string memory symbol_) {
253         _name = name_;
254         _symbol = symbol_;
255     }
256 
257     /**
258      * @dev Returns the name of the token.
259      */
260     function name() public view virtual override returns (string memory) {
261         return _name;
262     }
263 
264     /**
265      * @dev Returns the symbol of the token, usually a shorter version of the
266      * name.
267      */
268     function symbol() public view virtual override returns (string memory) {
269         return _symbol;
270     }
271 
272     /**
273      * @dev Returns the number of decimals used to get its user representation.
274      * For example, if `decimals` equals `2`, a balance of `505` tokens should
275      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
276      *
277      * Tokens usually opt for a value of 18, imitating the relationship between
278      * Ether and Wei. This is the value {ERC20} uses, unless this function is
279      * overridden;
280      *
281      * NOTE: This information is only used for _display_ purposes: it in
282      * no way affects any of the arithmetic of the contract, including
283      * {IERC20-balanceOf} and {IERC20-transfer}.
284      */
285     function decimals() public view virtual override returns (uint8) {
286         return 18;
287     }
288 
289     /**
290      * @dev See {IERC20-totalSupply}.
291      */
292     function totalSupply() public view virtual override returns (uint256) {
293         return _totalSupply;
294     }
295 
296     /**
297      * @dev See {IERC20-balanceOf}.
298      */
299     function balanceOf(address account) public view virtual override returns (uint256) {
300         return _balances[account];
301     }
302 
303     /**
304      * @dev See {IERC20-transfer}.
305      *
306      * Requirements:
307      *
308      * - `recipient` cannot be the zero address.
309      * - the caller must have a balance of at least `amount`.
310      */
311     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
312         _transfer(_msgSender(), recipient, amount);
313         return true;
314     }
315 
316     /**
317      * @dev See {IERC20-allowance}.
318      */
319     function allowance(address owner, address spender) public view virtual override returns (uint256) {
320         return _allowances[owner][spender];
321     }
322 
323     /**
324      * @dev See {IERC20-approve}.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      */
330     function approve(address spender, uint256 amount) public virtual override returns (bool) {
331         _approve(_msgSender(), spender, amount);
332         return true;
333     }
334 
335     /**
336      * @dev See {IERC20-transferFrom}.
337      *
338      * Emits an {Approval} event indicating the updated allowance. This is not
339      * required by the EIP. See the note at the beginning of {ERC20}.
340      *
341      * Requirements:
342      *
343      * - `sender` and `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `amount`.
345      * - the caller must have allowance for ``sender``'s tokens of at least
346      * `amount`.
347      */
348     function transferFrom(
349         address sender,
350         address recipient,
351         uint256 amount
352     ) public virtual override returns (bool) {
353         _transfer(sender, recipient, amount);
354 
355         uint256 currentAllowance = _allowances[sender][_msgSender()];
356         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
357         unchecked {
358             _approve(sender, _msgSender(), currentAllowance - amount);
359         }
360 
361         return true;
362     }
363 
364     /**
365      * @dev Atomically increases the allowance granted to `spender` by the caller.
366      *
367      * This is an alternative to {approve} that can be used as a mitigation for
368      * problems described in {IERC20-approve}.
369      *
370      * Emits an {Approval} event indicating the updated allowance.
371      *
372      * Requirements:
373      *
374      * - `spender` cannot be the zero address.
375      */
376     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
377         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
378         return true;
379     }
380 
381     /**
382      * @dev Atomically decreases the allowance granted to `spender` by the caller.
383      *
384      * This is an alternative to {approve} that can be used as a mitigation for
385      * problems described in {IERC20-approve}.
386      *
387      * Emits an {Approval} event indicating the updated allowance.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      * - `spender` must have allowance for the caller of at least
393      * `subtractedValue`.
394      */
395     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
396         uint256 currentAllowance = _allowances[_msgSender()][spender];
397         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
398         unchecked {
399             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
400         }
401 
402         return true;
403     }
404 
405     /**
406      * @dev Moves `amount` of tokens from `sender` to `recipient`.
407      *
408      * This internal function is equivalent to {transfer}, and can be used to
409      * e.g. implement automatic token fees, slashing mechanisms, etc.
410      *
411      * Emits a {Transfer} event.
412      *
413      * Requirements:
414      *
415      * - `sender` cannot be the zero address.
416      * - `recipient` cannot be the zero address.
417      * - `sender` must have a balance of at least `amount`.
418      */
419     function _transfer(
420         address sender,
421         address recipient,
422         uint256 amount
423     ) internal virtual {
424         require(sender != address(0), "ERC20: transfer from the zero address");
425         require(recipient != address(0), "ERC20: transfer to the zero address");
426 
427         _beforeTokenTransfer(sender, recipient, amount);
428 
429         uint256 senderBalance = _balances[sender];
430         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
431         unchecked {
432             _balances[sender] = senderBalance - amount;
433         }
434         _balances[recipient] += amount;
435 
436         emit Transfer(sender, recipient, amount);
437 
438         _afterTokenTransfer(sender, recipient, amount);
439     }
440 
441     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
442      * the total supply.
443      *
444      * Emits a {Transfer} event with `from` set to the zero address.
445      *
446      * Requirements:
447      *
448      * - `account` cannot be the zero address.
449      */
450     function _mint(address account, uint256 amount) internal virtual {
451         require(account != address(0), "ERC20: mint to the zero address");
452 
453         _beforeTokenTransfer(address(0), account, amount);
454 
455         _totalSupply += amount;
456         _balances[account] += amount;
457         emit Transfer(address(0), account, amount);
458 
459         _afterTokenTransfer(address(0), account, amount);
460     }
461 
462     /**
463      * @dev Destroys `amount` tokens from `account`, reducing the
464      * total supply.
465      *
466      * Emits a {Transfer} event with `to` set to the zero address.
467      *
468      * Requirements:
469      *
470      * - `account` cannot be the zero address.
471      * - `account` must have at least `amount` tokens.
472      */
473     function _burn(address account, uint256 amount) internal virtual {
474         require(account != address(0), "ERC20: burn from the zero address");
475 
476         _beforeTokenTransfer(account, address(0), amount);
477 
478         uint256 accountBalance = _balances[account];
479         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
480         unchecked {
481             _balances[account] = accountBalance - amount;
482         }
483         _totalSupply -= amount;
484 
485         emit Transfer(account, address(0), amount);
486 
487         _afterTokenTransfer(account, address(0), amount);
488     }
489 
490     /**
491      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
492      *
493      * This internal function is equivalent to `approve`, and can be used to
494      * e.g. set automatic allowances for certain subsystems, etc.
495      *
496      * Emits an {Approval} event.
497      *
498      * Requirements:
499      *
500      * - `owner` cannot be the zero address.
501      * - `spender` cannot be the zero address.
502      */
503     function _approve(
504         address owner,
505         address spender,
506         uint256 amount
507     ) internal virtual {
508         require(owner != address(0), "ERC20: approve from the zero address");
509         require(spender != address(0), "ERC20: approve to the zero address");
510 
511         _allowances[owner][spender] = amount;
512         emit Approval(owner, spender, amount);
513     }
514 
515     /**
516      * @dev Hook that is called before any transfer of tokens. This includes
517      * minting and burning.
518      *
519      * Calling conditions:
520      *
521      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
522      * will be transferred to `to`.
523      * - when `from` is zero, `amount` tokens will be minted for `to`.
524      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
525      * - `from` and `to` are never both zero.
526      *
527      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
528      */
529     function _beforeTokenTransfer(
530         address from,
531         address to,
532         uint256 amount
533     ) internal virtual {}
534 
535     /**
536      * @dev Hook that is called after any transfer of tokens. This includes
537      * minting and burning.
538      *
539      * Calling conditions:
540      *
541      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
542      * has been transferred to `to`.
543      * - when `from` is zero, `amount` tokens have been minted for `to`.
544      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
545      * - `from` and `to` are never both zero.
546      *
547      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
548      */
549     function _afterTokenTransfer(
550         address from,
551         address to,
552         uint256 amount
553     ) internal virtual {}
554 }
555 
556 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
557 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
558 
559 /* pragma solidity ^0.8.0; */
560 
561 // CAUTION
562 // This version of SafeMath should only be used with Solidity 0.8 or later,
563 // because it relies on the compiler's built in overflow checks.
564 
565 /**
566  * @dev Wrappers over Solidity's arithmetic operations.
567  *
568  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
569  * now has built in overflow checking.
570  */
571 library SafeMath {
572     /**
573      * @dev Returns the addition of two unsigned integers, with an overflow flag.
574      *
575      * _Available since v3.4._
576      */
577     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
578         unchecked {
579             uint256 c = a + b;
580             if (c < a) return (false, 0);
581             return (true, c);
582         }
583     }
584 
585     /**
586      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
587      *
588      * _Available since v3.4._
589      */
590     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
591         unchecked {
592             if (b > a) return (false, 0);
593             return (true, a - b);
594         }
595     }
596 
597     /**
598      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
599      *
600      * _Available since v3.4._
601      */
602     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
603         unchecked {
604             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
605             // benefit is lost if 'b' is also tested.
606             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
607             if (a == 0) return (true, 0);
608             uint256 c = a * b;
609             if (c / a != b) return (false, 0);
610             return (true, c);
611         }
612     }
613 
614     /**
615      * @dev Returns the division of two unsigned integers, with a division by zero flag.
616      *
617      * _Available since v3.4._
618      */
619     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             if (b == 0) return (false, 0);
622             return (true, a / b);
623         }
624     }
625 
626     /**
627      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
628      *
629      * _Available since v3.4._
630      */
631     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
632         unchecked {
633             if (b == 0) return (false, 0);
634             return (true, a % b);
635         }
636     }
637 
638     /**
639      * @dev Returns the addition of two unsigned integers, reverting on
640      * overflow.
641      *
642      * Counterpart to Solidity's `+` operator.
643      *
644      * Requirements:
645      *
646      * - Addition cannot overflow.
647      */
648     function add(uint256 a, uint256 b) internal pure returns (uint256) {
649         return a + b;
650     }
651 
652     /**
653      * @dev Returns the subtraction of two unsigned integers, reverting on
654      * overflow (when the result is negative).
655      *
656      * Counterpart to Solidity's `-` operator.
657      *
658      * Requirements:
659      *
660      * - Subtraction cannot overflow.
661      */
662     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
663         return a - b;
664     }
665 
666     /**
667      * @dev Returns the multiplication of two unsigned integers, reverting on
668      * overflow.
669      *
670      * Counterpart to Solidity's `*` operator.
671      *
672      * Requirements:
673      *
674      * - Multiplication cannot overflow.
675      */
676     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
677         return a * b;
678     }
679 
680     /**
681      * @dev Returns the integer division of two unsigned integers, reverting on
682      * division by zero. The result is rounded towards zero.
683      *
684      * Counterpart to Solidity's `/` operator.
685      *
686      * Requirements:
687      *
688      * - The divisor cannot be zero.
689      */
690     function div(uint256 a, uint256 b) internal pure returns (uint256) {
691         return a / b;
692     }
693 
694     /**
695      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
696      * reverting when dividing by zero.
697      *
698      * Counterpart to Solidity's `%` operator. This function uses a `revert`
699      * opcode (which leaves remaining gas untouched) while Solidity uses an
700      * invalid opcode to revert (consuming all remaining gas).
701      *
702      * Requirements:
703      *
704      * - The divisor cannot be zero.
705      */
706     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
707         return a % b;
708     }
709 
710     /**
711      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
712      * overflow (when the result is negative).
713      *
714      * CAUTION: This function is deprecated because it requires allocating memory for the error
715      * message unnecessarily. For custom revert reasons use {trySub}.
716      *
717      * Counterpart to Solidity's `-` operator.
718      *
719      * Requirements:
720      *
721      * - Subtraction cannot overflow.
722      */
723     function sub(
724         uint256 a,
725         uint256 b,
726         string memory errorMessage
727     ) internal pure returns (uint256) {
728         unchecked {
729             require(b <= a, errorMessage);
730             return a - b;
731         }
732     }
733 
734     /**
735      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
736      * division by zero. The result is rounded towards zero.
737      *
738      * Counterpart to Solidity's `/` operator. Note: this function uses a
739      * `revert` opcode (which leaves remaining gas untouched) while Solidity
740      * uses an invalid opcode to revert (consuming all remaining gas).
741      *
742      * Requirements:
743      *
744      * - The divisor cannot be zero.
745      */
746     function div(
747         uint256 a,
748         uint256 b,
749         string memory errorMessage
750     ) internal pure returns (uint256) {
751         unchecked {
752             require(b > 0, errorMessage);
753             return a / b;
754         }
755     }
756 
757     /**
758      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
759      * reverting with custom message when dividing by zero.
760      *
761      * CAUTION: This function is deprecated because it requires allocating memory for the error
762      * message unnecessarily. For custom revert reasons use {tryMod}.
763      *
764      * Counterpart to Solidity's `%` operator. This function uses a `revert`
765      * opcode (which leaves remaining gas untouched) while Solidity uses an
766      * invalid opcode to revert (consuming all remaining gas).
767      *
768      * Requirements:
769      *
770      * - The divisor cannot be zero.
771      */
772     function mod(
773         uint256 a,
774         uint256 b,
775         string memory errorMessage
776     ) internal pure returns (uint256) {
777         unchecked {
778             require(b > 0, errorMessage);
779             return a % b;
780         }
781     }
782 }
783 
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
815 
816 interface IUniswapV2Pair {
817     event Approval(
818         address indexed owner,
819         address indexed spender,
820         uint256 value
821     );
822     event Transfer(address indexed from, address indexed to, uint256 value);
823 
824     function name() external pure returns (string memory);
825 
826     function symbol() external pure returns (string memory);
827 
828     function decimals() external pure returns (uint8);
829 
830     function totalSupply() external view returns (uint256);
831 
832     function balanceOf(address owner) external view returns (uint256);
833 
834     function allowance(address owner, address spender)
835         external
836         view
837         returns (uint256);
838 
839     function approve(address spender, uint256 value) external returns (bool);
840 
841     function transfer(address to, uint256 value) external returns (bool);
842 
843     function transferFrom(
844         address from,
845         address to,
846         uint256 value
847     ) external returns (bool);
848 
849     function DOMAIN_SEPARATOR() external view returns (bytes32);
850 
851     function PERMIT_TYPEHASH() external pure returns (bytes32);
852 
853     function nonces(address owner) external view returns (uint256);
854 
855     function permit(
856         address owner,
857         address spender,
858         uint256 value,
859         uint256 deadline,
860         uint8 v,
861         bytes32 r,
862         bytes32 s
863     ) external;
864 
865     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
866     event Burn(
867         address indexed sender,
868         uint256 amount0,
869         uint256 amount1,
870         address indexed to
871     );
872     event Swap(
873         address indexed sender,
874         uint256 amount0In,
875         uint256 amount1In,
876         uint256 amount0Out,
877         uint256 amount1Out,
878         address indexed to
879     );
880     event Sync(uint112 reserve0, uint112 reserve1);
881 
882     function MINIMUM_LIQUIDITY() external pure returns (uint256);
883 
884     function factory() external view returns (address);
885 
886     function token0() external view returns (address);
887 
888     function token1() external view returns (address);
889 
890     function getReserves()
891         external
892         view
893         returns (
894             uint112 reserve0,
895             uint112 reserve1,
896             uint32 blockTimestampLast
897         );
898 
899     function price0CumulativeLast() external view returns (uint256);
900 
901     function price1CumulativeLast() external view returns (uint256);
902 
903     function kLast() external view returns (uint256);
904 
905     function mint(address to) external returns (uint256 liquidity);
906 
907     function burn(address to)
908         external
909         returns (uint256 amount0, uint256 amount1);
910 
911     function swap(
912         uint256 amount0Out,
913         uint256 amount1Out,
914         address to,
915         bytes calldata data
916     ) external;
917 
918     function skim(address to) external;
919 
920     function sync() external;
921 
922     function initialize(address, address) external;
923 }
924 
925 
926 interface IUniswapV2Router02 {
927     function factory() external pure returns (address);
928 
929     function WETH() external pure returns (address);
930 
931     function addLiquidity(
932         address tokenA,
933         address tokenB,
934         uint256 amountADesired,
935         uint256 amountBDesired,
936         uint256 amountAMin,
937         uint256 amountBMin,
938         address to,
939         uint256 deadline
940     )
941         external
942         returns (
943             uint256 amountA,
944             uint256 amountB,
945             uint256 liquidity
946         );
947 
948     function addLiquidityETH(
949         address token,
950         uint256 amountTokenDesired,
951         uint256 amountTokenMin,
952         uint256 amountETHMin,
953         address to,
954         uint256 deadline
955     )
956         external
957         payable
958         returns (
959             uint256 amountToken,
960             uint256 amountETH,
961             uint256 liquidity
962         );
963 
964     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
965         uint256 amountIn,
966         uint256 amountOutMin,
967         address[] calldata path,
968         address to,
969         uint256 deadline
970     ) external;
971 
972     function swapExactETHForTokensSupportingFeeOnTransferTokens(
973         uint256 amountOutMin,
974         address[] calldata path,
975         address to,
976         uint256 deadline
977     ) external payable;
978 
979     function swapExactTokensForETHSupportingFeeOnTransferTokens(
980         uint256 amountIn,
981         uint256 amountOutMin,
982         address[] calldata path,
983         address to,
984         uint256 deadline
985     ) external;
986 }
987 
988 
989 contract DoGood is ERC20, Ownable {
990     using SafeMath for uint256;
991 
992     IUniswapV2Router02 public immutable uniswapV2Router;
993     address public immutable uniswapV2Pair;
994     address public constant deadAddress = address(0xdead);
995 
996     bool private swapping;
997     uint256 golive;
998     address public DoGoodWallet;
999     address public DoGoodWalletTwo;
1000     address public devWallet;
1001     address public RandomDoGoodWallet;
1002 
1003     uint256 public maxTransactionAmount;
1004     uint256 public swapTokensAtAmount;
1005     uint256 public maxWallet;
1006 
1007     uint256 public percentForLPBurn = 25; // 25 = .25%
1008     bool public lpBurnEnabled = true;
1009     uint256 public lpBurnFrequency = 3800 seconds;
1010     uint256 public lastLpBurnTime;
1011 
1012     uint256 public manualBurnFrequency = 40 minutes;
1013     uint256 public lastManualLpBurnTime;
1014 
1015 
1016     bool public limitsInEffect = true;
1017     bool public tradingActive = false;
1018     bool public swapEnabled = false;
1019 
1020     // Anti-bot and anti-whale mappings and variables
1021     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1022     bool public transferDelayEnabled = true;
1023 
1024     uint256 public buyTotalFees;
1025     uint256 public buyDoGoodFee;
1026     uint256 public buyLiquidityFee;
1027     uint256 public buyDevFee;
1028 
1029     uint256 public sellTotalFees;
1030     uint256 public sellDoGoodFee;
1031     uint256 public sellLiquidityFee;
1032     uint256 public sellDevFee;
1033 
1034     uint256 public tokensForCharity;
1035     uint256 public tokensForLiquidity;
1036     uint256 public tokensForDev;
1037 
1038     /******************/
1039 
1040     // exclude from fees and maxtx amount
1041     mapping(address => bool) private _isExcludedFromFees;
1042     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1043 
1044     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1045     // could be subject to a maximum transfer amount
1046     mapping(address => bool) public automatedMarketMakerPairs;
1047 
1048     event UpdateUniswapV2Router(
1049         address indexed newAddress,
1050         address indexed oldAddress
1051     );
1052 
1053     event ExcludeFromFees(address indexed account, bool isExcluded);
1054 
1055     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1056 
1057     event DoGoodWalletUpdated(
1058         address indexed newWallet,
1059         address indexed oldWallet
1060     );
1061 
1062     event DoGoodWalletTwoUpdated(
1063         address indexed newWallet,
1064         address indexed oldWallet
1065     );
1066 
1067     event devWalletUpdated(
1068         address indexed newWallet,
1069         address indexed oldWallet
1070     );
1071 
1072     event SwapAndLiquify(
1073         uint256 tokensSwapped,
1074         uint256 ethReceived,
1075         uint256 tokensIntoLiquidity
1076     );
1077 
1078     event AutoNukeLP();
1079 
1080     event ManualNukeLP();
1081 
1082     constructor() ERC20("Do Good", "DGD") {
1083         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1084             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1085         );
1086 
1087         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1088         uniswapV2Router = _uniswapV2Router;
1089 
1090         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1091             .createPair(address(this), _uniswapV2Router.WETH());
1092         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1093         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1094 
1095         int blocknum;
1096 
1097         uint256 addtime;
1098         uint256 currenttime;
1099 
1100         bool oddeven;
1101 
1102         uint256 _buyDoGoodFee = 1;
1103         uint256 _buyLiquidityFee = 1;
1104         uint256 _buyDevFee = 1;
1105 
1106         uint256 _sellDoGoodFee = 3;
1107         uint256 _sellLiquidityFee = 1;
1108         uint256 _sellDevFee = 3;
1109 
1110 
1111         uint256 totalSupply = 1_000_000_000 * 1e18;
1112 
1113         maxTransactionAmount = 15_000_00 * 1e18; // 0.15% from total supply maxTransactionAmountTxn at launch
1114         maxWallet = 3_000_000 * 1e18; // 0.3% from total supply maxWallet at launch
1115         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1116 
1117         buyDoGoodFee = _buyDoGoodFee;
1118         buyLiquidityFee = _buyLiquidityFee;
1119         buyDevFee = _buyDevFee;
1120         buyTotalFees = buyDoGoodFee + buyLiquidityFee + buyDevFee;
1121 
1122         sellDoGoodFee = _sellDoGoodFee;
1123         sellLiquidityFee = _sellLiquidityFee;
1124         sellDevFee = _sellDevFee;
1125         sellTotalFees = sellDoGoodFee + sellLiquidityFee + sellDevFee;
1126 
1127         DoGoodWallet = address(0x707A0A00E2Fcf5329816b5223C91Ea38F22d31a0); // set as DoGoodWallet
1128         DoGoodWalletTwo = address(0xe481387CA21AeA113180a184d14B64D804027deb); // set as DoGoodWalletTwo
1129         devWallet = address(0xeA62D6D5a0e4F38594dAB884a61B9A5d7a9D6aa4); // set as dev wallet
1130 
1131         // exclude from paying fees or having max transaction amount
1132         excludeFromFees(owner(), true);
1133         excludeFromFees(address(this), true);
1134         excludeFromFees(address(0xdead), true);
1135 
1136         excludeFromMaxTransaction(owner(), true);
1137         excludeFromMaxTransaction(address(this), true);
1138         excludeFromMaxTransaction(address(0xdead), true);
1139 
1140         /*
1141             _mint is an internal function in ERC20.sol that is only called here,
1142             and CANNOT be called ever again
1143         */
1144         _mint(msg.sender, totalSupply);
1145     }
1146 
1147     receive() external payable {}
1148 
1149 
1150     function random(uint number) public view returns(uint){
1151         return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,
1152         msg.sender))) % number;
1153     }
1154 
1155     // once enabled, can never be turned off
1156     function enableTrading(uint256 blockeroos) external onlyOwner {
1157         uint256 addtime = random(blockeroos);
1158         if (addtime < 11) {
1159             addtime = addtime + 20;
1160             }
1161         uint256 currenttime = block.timestamp;
1162         golive = (currenttime + addtime * 1 seconds);
1163         tradingActive = true;
1164         swapEnabled = true;
1165         lastLpBurnTime = block.timestamp;
1166     }
1167 
1168     // remove limits after token is stable
1169     function removeLimits() external onlyOwner returns (bool) {
1170         limitsInEffect = false;
1171         return true;
1172     }
1173 
1174     // disable Transfer delay - cannot be reenabled
1175     function disableTransferDelay() external onlyOwner returns (bool) {
1176         transferDelayEnabled = false;
1177         return true;
1178     }
1179 
1180     // change the minimum amount of tokens to sell from fees
1181     function updateSwapTokensAtAmount(uint256 newAmount)
1182         external
1183         onlyOwner
1184         returns (bool)
1185     {
1186         require(
1187             newAmount >= (totalSupply() * 1) / 100000,
1188             "Swap amount cannot be lower than 0.001% total supply."
1189         );
1190         require(
1191             newAmount <= (totalSupply() * 5) / 1000,
1192             "Swap amount cannot be higher than 0.5% total supply."
1193         );
1194         swapTokensAtAmount = newAmount;
1195         return true;
1196     }
1197 
1198     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1199         require(
1200             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1201             "No scamming sir! You cannot set maxTransactionAmount lower than 0.1%"
1202         );
1203         maxTransactionAmount = newNum * (10**18);
1204     }
1205 
1206     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1207         require(
1208             newNum >= ((totalSupply() * 2) / 1000) / 1e18,
1209             "Sorry but you cannot set maxWallet lower than 2%"
1210         );
1211         maxWallet = newNum * (10**18);
1212     }
1213 
1214     function excludeFromMaxTransaction(address updAds, bool isEx)
1215         public
1216         onlyOwner
1217     {
1218         _isExcludedMaxTransactionAmount[updAds] = isEx;
1219     }
1220 
1221     // only use to disable contract sales if absolutely necessary (emergency use only)
1222     function updateSwapEnabled(bool enabled) external onlyOwner {
1223         swapEnabled = enabled;
1224     }
1225 
1226     function updateBuyFees(
1227         uint256 _DoGoodFee,
1228         uint256 _liquidityFee,
1229         uint256 _devFee
1230     ) external onlyOwner {
1231         buyDoGoodFee = _DoGoodFee;
1232         buyLiquidityFee = _liquidityFee;
1233         buyDevFee = _devFee;
1234         buyTotalFees = buyDoGoodFee + buyLiquidityFee + buyDevFee;
1235         require(buyTotalFees <= 10, "Must keep buy fees at 10% or less - dont be greedy!");
1236     }
1237 
1238     function updateSellFees(
1239         uint256 _DoGoodFee,
1240         uint256 _liquidityFee,
1241         uint256 _devFee
1242     ) external onlyOwner {
1243         sellDoGoodFee = _DoGoodFee;
1244         sellLiquidityFee = _liquidityFee;
1245         sellDevFee = _devFee;
1246         sellTotalFees = sellDoGoodFee + sellLiquidityFee + sellDevFee;
1247         require(sellTotalFees <= 10, "Must keep sell fees at 10% or less - dont be greedy!");
1248     }
1249 
1250     function excludeFromFees(address account, bool excluded) public onlyOwner {
1251         _isExcludedFromFees[account] = excluded;
1252         emit ExcludeFromFees(account, excluded);
1253     }
1254 
1255     function setAutomatedMarketMakerPair(address pair, bool value)
1256         public
1257         onlyOwner
1258     {
1259         require(
1260             pair != uniswapV2Pair,
1261             "The pair cannot be removed from automatedMarketMakerPairs"
1262         );
1263 
1264         _setAutomatedMarketMakerPair(pair, value);
1265     }
1266 
1267 
1268 
1269     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1270         automatedMarketMakerPairs[pair] = value;
1271 
1272         emit SetAutomatedMarketMakerPair(pair, value);
1273     }
1274 
1275     function updateDoGoodWallet(address newDoGoodWallet)
1276         external
1277         onlyOwner
1278     {
1279         emit DoGoodWalletUpdated(newDoGoodWallet, DoGoodWallet);
1280         DoGoodWallet = newDoGoodWallet;
1281     }
1282 
1283     function updateDoGoodWalletTwo(address newDoGoodWalletTwo)
1284         external
1285         onlyOwner
1286     {
1287         emit DoGoodWalletTwoUpdated(newDoGoodWalletTwo, DoGoodWalletTwo);
1288         DoGoodWalletTwo = newDoGoodWalletTwo;
1289     }
1290 
1291     function updateDevWallet(address newWallet) external onlyOwner {
1292         emit devWalletUpdated(newWallet, devWallet);
1293         devWallet = newWallet;
1294     }
1295 
1296     function isExcludedFromFees(address account) public view returns (bool) {
1297         return _isExcludedFromFees[account];
1298     }
1299 
1300     event BoughtEarly(address indexed sniper);
1301 
1302     function _transfer(
1303         address from,
1304         address to,
1305         uint256 amount
1306     ) internal override {
1307         require(from != address(0), "ERC20: transfer from the zero address");
1308         require(to != address(0), "ERC20: transfer to the zero address");
1309 
1310         if (amount == 0) {
1311             super._transfer(from, to, 0);
1312             return;
1313         }
1314 
1315         if (limitsInEffect) {
1316             if (
1317                 from != owner() &&
1318                 to != owner() &&
1319                 to != address(0) &&
1320                 to != address(0xdead) &&
1321                 !swapping
1322             ) {
1323                 if (!tradingActive) {
1324                     require(
1325                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1326                         "Trading is not active."
1327                     );
1328 
1329 
1330                 }
1331 
1332                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1333                 if (transferDelayEnabled) {
1334                     if (
1335                         to != owner() &&
1336                         to != address(uniswapV2Router) &&
1337                         to != address(uniswapV2Pair)
1338                     ) {
1339                         require(
1340                             _holderLastTransferTimestamp[tx.origin] <
1341                                 block.number,
1342                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1343                         );
1344                         _holderLastTransferTimestamp[tx.origin] = block.number;
1345                     }
1346                 }
1347 
1348                 //when buy
1349                 if (
1350                     automatedMarketMakerPairs[from] &&
1351                     !_isExcludedMaxTransactionAmount[to]
1352                 ) {
1353                     require(
1354                         amount <= maxTransactionAmount,
1355                         "Buy transfer amount exceeds the maxTransactionAmount."
1356                     );
1357                     require(
1358                         amount + balanceOf(to) <= maxWallet,
1359                         "Max wallet exceeded"
1360                     );
1361 
1362                     require(
1363                         block.timestamp > golive,
1364                         "Wait a little."
1365                     );
1366                 }
1367                 //when sell
1368                 else if (
1369                     automatedMarketMakerPairs[to] &&
1370                     !_isExcludedMaxTransactionAmount[from]
1371                 ) {
1372                     require(
1373                         amount <= maxTransactionAmount,
1374                         "Sell transfer amount exceeds the maxTransactionAmount."
1375                     );
1376                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1377                     require(
1378                         amount + balanceOf(to) <= maxWallet,
1379                         "Max wallet exceeded"
1380                     );
1381                 }
1382             }
1383         }
1384 
1385         uint256 contractTokenBalance = balanceOf(address(this));
1386 
1387         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1388 
1389         if (
1390             canSwap &&
1391             swapEnabled &&
1392             !swapping &&
1393             !automatedMarketMakerPairs[from] &&
1394             !_isExcludedFromFees[from] &&
1395             !_isExcludedFromFees[to]
1396         ) {
1397             swapping = true;
1398 
1399             swapBack();
1400 
1401             swapping = false;
1402         }
1403 
1404         if (
1405             !swapping &&
1406             automatedMarketMakerPairs[to] &&
1407             lpBurnEnabled &&
1408             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1409             !_isExcludedFromFees[from]
1410         ) {
1411             autoBurnLiquidityPairTokens();
1412         }
1413 
1414         bool takeFee = !swapping;
1415 
1416         // if any account belongs to _isExcludedFromFee account then remove the fee
1417         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1418             takeFee = false;
1419         }
1420 
1421         uint256 fees = 0;
1422         // only take fees on buys/sells, do not take on wallet transfers
1423         if (takeFee) {
1424             // on sell
1425             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1426                 fees = amount.mul(sellTotalFees).div(100);
1427                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1428                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1429                 tokensForCharity += (fees * sellDoGoodFee) / sellTotalFees;
1430             }
1431             // on buy
1432             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1433                 fees = amount.mul(buyTotalFees).div(100);
1434                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1435                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1436                 tokensForCharity += (fees * buyDoGoodFee) / buyTotalFees;
1437             }
1438 
1439             if (fees > 0) {
1440                 super._transfer(from, address(this), fees);
1441             }
1442 
1443             amount -= fees;
1444         }
1445 
1446         super._transfer(from, to, amount);
1447     }
1448 
1449     function swapTokensForEth(uint256 tokenAmount) private {
1450         // generate the uniswap pair path of token -> weth
1451         address[] memory path = new address[](2);
1452         path[0] = address(this);
1453         path[1] = uniswapV2Router.WETH();
1454 
1455         _approve(address(this), address(uniswapV2Router), tokenAmount);
1456 
1457         // make the swap
1458         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1459             tokenAmount,
1460             0, // accept any amount of ETH
1461             path,
1462             address(this),
1463             block.timestamp
1464         );
1465     }
1466 
1467     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1468         // approve token transfer to cover all possible scenarios
1469         _approve(address(this), address(uniswapV2Router), tokenAmount);
1470 
1471         // add the liquidity
1472         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1473             address(this),
1474             tokenAmount,
1475             0, // slippage is unavoidable
1476             0, // slippage is unavoidable
1477             deadAddress,
1478             block.timestamp
1479         );
1480     }
1481 
1482     function swapBack() private {
1483         uint256 contractBalance = balanceOf(address(this));
1484         uint256 totalTokensToSwap = tokensForLiquidity +
1485             tokensForCharity +
1486             tokensForDev;
1487         bool success;
1488 
1489         if (contractBalance == 0 || totalTokensToSwap == 0) {
1490             return;
1491         }
1492 
1493         if (contractBalance > swapTokensAtAmount * 20) {
1494             contractBalance = swapTokensAtAmount * 20;
1495         }
1496 
1497         // Halve the amount of liquidity tokens
1498         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1499             totalTokensToSwap /
1500             2;
1501         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1502 
1503         uint256 initialETHBalance = address(this).balance;
1504 
1505         swapTokensForEth(amountToSwapForETH);
1506 
1507         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1508 
1509         uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(
1510             totalTokensToSwap
1511         );
1512         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1513 
1514         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForDev;
1515 
1516         tokensForLiquidity = 0;
1517         tokensForCharity = 0;
1518         tokensForDev = 0;
1519 
1520         (success, ) = address(devWallet).call{value: ethForDev}("");
1521 
1522         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1523             addLiquidity(liquidityTokens, ethForLiquidity);
1524 
1525             if(block.timestamp%2==0)
1526             {
1527                 RandomDoGoodWallet=DoGoodWallet;
1528             }
1529             else
1530             {
1531                 RandomDoGoodWallet=DoGoodWalletTwo;
1532             }
1533 
1534             emit SwapAndLiquify(
1535                 amountToSwapForETH,
1536                 ethForLiquidity,
1537                 tokensForLiquidity
1538             );
1539         }
1540 
1541         (success, ) = address(RandomDoGoodWallet).call{
1542             value: address(this).balance
1543         }("");
1544     }
1545 
1546     function setAutoLPBurnSettings(
1547         uint256 _frequencyInSeconds,
1548         uint256 _percent,
1549         bool _Enabled
1550     ) external onlyOwner {
1551         require(
1552             _frequencyInSeconds >= 600,
1553             "cannot set buyback more often than every 10 minutes"
1554         );
1555         require(
1556             _percent <= 1000 && _percent >= 0,
1557             "Must set auto LP burn percent between 0% and 10%"
1558         );
1559         lpBurnFrequency = _frequencyInSeconds;
1560         percentForLPBurn = _percent;
1561         lpBurnEnabled = _Enabled;
1562     }
1563 
1564     function autoBurnLiquidityPairTokens() internal returns (bool) {
1565         lastLpBurnTime = block.timestamp;
1566 
1567         // get balance of liquidity pair
1568         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1569 
1570         // calculate amount to burn
1571         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1572             10000
1573         );
1574 
1575         // pull tokens from pancakePair liquidity and move to dead address permanently
1576         if (amountToBurn > 0) {
1577             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1578         }
1579 
1580         //sync price since this is not in a swap transaction!
1581         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1582         pair.sync();
1583         emit AutoNukeLP();
1584         return true;
1585     }
1586 
1587     function manualBurnLiquidityPairTokens(uint256 percent)
1588         external
1589         onlyOwner
1590         returns (bool)
1591     {
1592         require(
1593             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1594             "Must wait for cooldown to finish"
1595         );
1596         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1597         lastManualLpBurnTime = block.timestamp;
1598 
1599         // get balance of liquidity pair
1600         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1601 
1602         // calculate amount to burn
1603         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1604 
1605         // pull tokens from pancakePair liquidity and move to dead address permanently
1606         if (amountToBurn > 0) {
1607             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1608         }
1609 
1610         //sync price since this is not in a swap transaction!
1611         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1612         pair.sync();
1613         emit ManualNukeLP();
1614         return true;
1615     }
1616 }