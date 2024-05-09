1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-21
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
7 pragma experimental ABIEncoderV2;
8 
9     /**
10      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
11      *
12      * Returns a boolean value indicating whether the operation succeeded.
13      *
14      * IMPORTANT: Beware that changing an allowance with this method brings the risk
15      * that someone may use both the old and the new allowance by unfortunate
16      * transaction ordering. One possible solution to mitigate this race
17      * condition is to first reduce the spender's allowance to 0 and set the
18      * desired value afterwards:
19      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
20      *
21      * Emits an {Approval} event.
22      */
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48 
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     function renounceOwnership() public virtual onlyOwner {
77         _transferOwnership(address(0));
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         _transferOwnership(newOwner);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Internal function without access restriction.
92      */
93     function _transferOwnership(address newOwner) internal virtual {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
101 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
102 
103 /* pragma solidity ^0.8.0; */
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
183 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
184 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
185 
186 /* pragma solidity ^0.8.0; */
187 
188 /* import "../IERC20.sol"; */
189 
190 /**
191  * @dev Interface for the optional metadata functions from the ERC20 standard.
192  *
193  * _Available since v4.1._
194  */
195 interface IERC20Metadata is IERC20 {
196     /**
197      * @dev Returns the name of the token.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the symbol of the token.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the decimals places of the token.
208      */
209     function decimals() external view returns (uint8);
210 }
211 
212 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
213 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
214 
215 /* pragma solidity ^0.8.0; */
216 
217 /* import "./IERC20.sol"; */
218 /* import "./extensions/IERC20Metadata.sol"; */
219 /* import "../../utils/Context.sol"; */
220 
221 /**
222  * @dev Implementation of the {IERC20} interface.
223  *
224  * This implementation is agnostic to the way tokens are created. This means
225  * that a supply mechanism has to be added in a derived contract using {_mint}.
226  * For a generic mechanism see {ERC20PresetMinterPauser}.
227  *
228  * TIP: For a detailed writeup see our guide
229  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
230  * to implement supply mechanisms].
231  *
232  * We have followed general OpenZeppelin Contracts guidelines: functions revert
233  * instead returning `false` on failure. This behavior is nonetheless
234  * conventional and does not conflict with the expectations of ERC20
235  * applications.
236  *
237  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
238  * This allows applications to reconstruct the allowance for all accounts just
239  * by listening to said events. Other implementations of the EIP may not emit
240  * these events, as it isn't required by the specification.
241  *
242  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
243  * functions have been added to mitigate the well-known issues around setting
244  * allowances. See {IERC20-approve}.
245  */
246 contract ERC20 is Context, IERC20, IERC20Metadata {
247     mapping(address => uint256) private _balances;
248 
249     mapping(address => mapping(address => uint256)) private _allowances;
250 
251     uint256 private _totalSupply;
252 
253     string private _name;
254     string private _symbol;
255 
256     /**
257      * @dev Sets the values for {name} and {symbol}.
258      *
259      * The default value of {decimals} is 18. To select a different value for
260      * {decimals} you should overload it.
261      *
262      * All two of these values are immutable: they can only be set once during
263      * construction.
264      */
265     constructor(string memory name_, string memory symbol_) {
266         _name = name_;
267         _symbol = symbol_;
268     }
269 
270     /**
271      * @dev Returns the name of the token.
272      */
273     function name() public view virtual override returns (string memory) {
274         return _name;
275     }
276 
277     /**
278      * @dev Returns the symbol of the token, usually a shorter version of the
279      * name.
280      */
281     function symbol() public view virtual override returns (string memory) {
282         return _symbol;
283     }
284 
285     /**
286      * @dev Returns the number of decimals used to get its user representation.
287      * For example, if `decimals` equals `2`, a balance of `505` tokens should
288      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
289      *
290      * Tokens usually opt for a value of 18, imitating the relationship between
291      * Ether and Wei. This is the value {ERC20} uses, unless this function is
292      * overridden;
293      *
294      * NOTE: This information is only used for _display_ purposes: it in
295      * no way affects any of the arithmetic of the contract, including
296      * {IERC20-balanceOf} and {IERC20-transfer}.
297      */
298     function decimals() public view virtual override returns (uint8) {
299         return 18;
300     }
301 
302     /**
303      * @dev See {IERC20-totalSupply}.
304      */
305     function totalSupply() public view virtual override returns (uint256) {
306         return _totalSupply;
307     }
308 
309     /**
310      * @dev See {IERC20-balanceOf}.
311      */
312     function balanceOf(address account) public view virtual override returns (uint256) {
313         return _balances[account];
314     }
315 
316     /**
317      * @dev See {IERC20-transfer}.
318      *
319      * Requirements:
320      *
321      * - `recipient` cannot be the zero address.
322      * - the caller must have a balance of at least `amount`.
323      */
324     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
325         _transfer(_msgSender(), recipient, amount);
326         return true;
327     }
328 
329     /**
330      * @dev See {IERC20-allowance}.
331      */
332     function allowance(address owner, address spender) public view virtual override returns (uint256) {
333         return _allowances[owner][spender];
334     }
335 
336     /**
337      * @dev See {IERC20-approve}.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      */
343     function approve(address spender, uint256 amount) public virtual override returns (bool) {
344         _approve(_msgSender(), spender, amount);
345         return true;
346     }
347 
348     /**
349      * @dev See {IERC20-transferFrom}.
350      *
351      * Emits an {Approval} event indicating the updated allowance. This is not
352      * required by the EIP. See the note at the beginning of {ERC20}.
353      *
354      * Requirements:
355      *
356      * - `sender` and `recipient` cannot be the zero address.
357      * - `sender` must have a balance of at least `amount`.
358      * - the caller must have allowance for ``sender``'s tokens of at least
359      * `amount`.
360      */
361     function transferFrom(
362         address sender,
363         address recipient,
364         uint256 amount
365     ) public virtual override returns (bool) {
366         _transfer(sender, recipient, amount);
367 
368         uint256 currentAllowance = _allowances[sender][_msgSender()];
369         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
370         unchecked {
371             _approve(sender, _msgSender(), currentAllowance - amount);
372         }
373 
374         return true;
375     }
376 
377     /**
378      * @dev Atomically increases the allowance granted to `spender` by the caller.
379      *
380      * This is an alternative to {approve} that can be used as a mitigation for
381      * problems described in {IERC20-approve}.
382      *
383      * Emits an {Approval} event indicating the updated allowance.
384      *
385      * Requirements:
386      *
387      * - `spender` cannot be the zero address.
388      */
389     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
390         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
391         return true;
392     }
393 
394     /**
395      * @dev Atomically decreases the allowance granted to `spender` by the caller.
396      *
397      * This is an alternative to {approve} that can be used as a mitigation for
398      * problems described in {IERC20-approve}.
399      *
400      * Emits an {Approval} event indicating the updated allowance.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      * - `spender` must have allowance for the caller of at least
406      * `subtractedValue`.
407      */
408     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
409         uint256 currentAllowance = _allowances[_msgSender()][spender];
410         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
411         unchecked {
412             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
413         }
414 
415         return true;
416     }
417 
418     /**
419      * @dev Moves `amount` of tokens from `sender` to `recipient`.
420      *
421      * This internal function is equivalent to {transfer}, and can be used to
422      * e.g. implement automatic token fees, slashing mechanisms, etc.
423      *
424      * Emits a {Transfer} event.
425      *
426      * Requirements:
427      *
428      * - `sender` cannot be the zero address.
429      * - `recipient` cannot be the zero address.
430      * - `sender` must have a balance of at least `amount`.
431      */
432     function _transfer(
433         address sender,
434         address recipient,
435         uint256 amount
436     ) internal virtual {
437         require(sender != address(0), "ERC20: transfer from the zero address");
438         require(recipient != address(0), "ERC20: transfer to the zero address");
439 
440         _beforeTokenTransfer(sender, recipient, amount);
441 
442         uint256 senderBalance = _balances[sender];
443         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
444         unchecked {
445             _balances[sender] = senderBalance - amount;
446         }
447         _balances[recipient] += amount;
448 
449         emit Transfer(sender, recipient, amount);
450 
451         _afterTokenTransfer(sender, recipient, amount);
452     }
453 
454     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
455      * the total supply.
456      *
457      * Emits a {Transfer} event with `from` set to the zero address.
458      *
459      * Requirements:
460      *
461      * - `account` cannot be the zero address.
462      */
463     function _mint(address account, uint256 amount) internal virtual {
464         require(account != address(0), "ERC20: mint to the zero address");
465 
466         _beforeTokenTransfer(address(0), account, amount);
467 
468         _totalSupply += amount;
469         _balances[account] += amount;
470         emit Transfer(address(0), account, amount);
471 
472         _afterTokenTransfer(address(0), account, amount);
473     }
474 
475     /**
476      * @dev Destroys `amount` tokens from `account`, reducing the
477      * total supply.
478      *
479      * Emits a {Transfer} event with `to` set to the zero address.
480      *
481      * Requirements:
482      *
483      * - `account` cannot be the zero address.
484      * - `account` must have at least `amount` tokens.
485      */
486     function _burn(address account, uint256 amount) internal virtual {
487         require(account != address(0), "ERC20: burn from the zero address");
488 
489         _beforeTokenTransfer(account, address(0), amount);
490 
491         uint256 accountBalance = _balances[account];
492         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
493         unchecked {
494             _balances[account] = accountBalance - amount;
495         }
496         _totalSupply -= amount;
497 
498         emit Transfer(account, address(0), amount);
499 
500         _afterTokenTransfer(account, address(0), amount);
501     }
502 
503     /**
504      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
505      *
506      * This internal function is equivalent to `approve`, and can be used to
507      * e.g. set automatic allowances for certain subsystems, etc.
508      *
509      * Emits an {Approval} event.
510      *
511      * Requirements:
512      *
513      * - `owner` cannot be the zero address.
514      * - `spender` cannot be the zero address.
515      */
516     function _approve(
517         address owner,
518         address spender,
519         uint256 amount
520     ) internal virtual {
521         require(owner != address(0), "ERC20: approve from the zero address");
522         require(spender != address(0), "ERC20: approve to the zero address");
523 
524         _allowances[owner][spender] = amount;
525         emit Approval(owner, spender, amount);
526     }
527 
528     /**
529      * @dev Hook that is called before any transfer of tokens. This includes
530      * minting and burning.
531      *
532      * Calling conditions:
533      *
534      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
535      * will be transferred to `to`.
536      * - when `from` is zero, `amount` tokens will be minted for `to`.
537      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
538      * - `from` and `to` are never both zero.
539      *
540      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
541      */
542     function _beforeTokenTransfer(
543         address from,
544         address to,
545         uint256 amount
546     ) internal virtual {}
547 
548     /**
549      * @dev Hook that is called after any transfer of tokens. This includes
550      * minting and burning.
551      *
552      * Calling conditions:
553      *
554      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
555      * has been transferred to `to`.
556      * - when `from` is zero, `amount` tokens have been minted for `to`.
557      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
558      * - `from` and `to` are never both zero.
559      *
560      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
561      */
562     function _afterTokenTransfer(
563         address from,
564         address to,
565         uint256 amount
566     ) internal virtual {}
567 }
568 
569 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
570 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
571 
572 /* pragma solidity ^0.8.0; */
573 
574 // CAUTION
575 // This version of SafeMath should only be used with Solidity 0.8 or later,
576 // because it relies on the compiler's built in overflow checks.
577 
578 /**
579  * @dev Wrappers over Solidity's arithmetic operations.
580  *
581  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
582  * now has built in overflow checking.
583  */
584 library SafeMath {
585     /**
586      * @dev Returns the addition of two unsigned integers, with an overflow flag.
587      *
588      * _Available since v3.4._
589      */
590     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
591         unchecked {
592             uint256 c = a + b;
593             if (c < a) return (false, 0);
594             return (true, c);
595         }
596     }
597 
598     /**
599      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
600      *
601      * _Available since v3.4._
602      */
603     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
604         unchecked {
605             if (b > a) return (false, 0);
606             return (true, a - b);
607         }
608     }
609 
610     /**
611      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
612      *
613      * _Available since v3.4._
614      */
615     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
616         unchecked {
617             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
618             // benefit is lost if 'b' is also tested.
619             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
620             if (a == 0) return (true, 0);
621             uint256 c = a * b;
622             if (c / a != b) return (false, 0);
623             return (true, c);
624         }
625     }
626 
627     /**
628      * @dev Returns the division of two unsigned integers, with a division by zero flag.
629      *
630      * _Available since v3.4._
631      */
632     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
633         unchecked {
634             if (b == 0) return (false, 0);
635             return (true, a / b);
636         }
637     }
638 
639     /**
640      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
641      *
642      * _Available since v3.4._
643      */
644     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
645         unchecked {
646             if (b == 0) return (false, 0);
647             return (true, a % b);
648         }
649     }
650 
651     /**
652      * @dev Returns the addition of two unsigned integers, reverting on
653      * overflow.
654      *
655      * Counterpart to Solidity's `+` operator.
656      *
657      * Requirements:
658      *
659      * - Addition cannot overflow.
660      */
661     function add(uint256 a, uint256 b) internal pure returns (uint256) {
662         return a + b;
663     }
664 
665     /**
666      * @dev Returns the subtraction of two unsigned integers, reverting on
667      * overflow (when the result is negative).
668      *
669      * Counterpart to Solidity's `-` operator.
670      *
671      * Requirements:
672      *
673      * - Subtraction cannot overflow.
674      */
675     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
676         return a - b;
677     }
678 
679     /**
680      * @dev Returns the multiplication of two unsigned integers, reverting on
681      * overflow.
682      *
683      * Counterpart to Solidity's `*` operator.
684      *
685      * Requirements:
686      *
687      * - Multiplication cannot overflow.
688      */
689     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
690         return a * b;
691     }
692 
693     /**
694      * @dev Returns the integer division of two unsigned integers, reverting on
695      * division by zero. The result is rounded towards zero.
696      *
697      * Counterpart to Solidity's `/` operator.
698      *
699      * Requirements:
700      *
701      * - The divisor cannot be zero.
702      */
703     function div(uint256 a, uint256 b) internal pure returns (uint256) {
704         return a / b;
705     }
706 
707     /**
708      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
709      * reverting when dividing by zero.
710      *
711      * Counterpart to Solidity's `%` operator. This function uses a `revert`
712      * opcode (which leaves remaining gas untouched) while Solidity uses an
713      * invalid opcode to revert (consuming all remaining gas).
714      *
715      * Requirements:
716      *
717      * - The divisor cannot be zero.
718      */
719     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
720         return a % b;
721     }
722 
723     /**
724      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
725      * overflow (when the result is negative).
726      *
727      * CAUTION: This function is deprecated because it requires allocating memory for the error
728      * message unnecessarily. For custom revert reasons use {trySub}.
729      *
730      * Counterpart to Solidity's `-` operator.
731      *
732      * Requirements:
733      *
734      * - Subtraction cannot overflow.
735      */
736     function sub(
737         uint256 a,
738         uint256 b,
739         string memory errorMessage
740     ) internal pure returns (uint256) {
741         unchecked {
742             require(b <= a, errorMessage);
743             return a - b;
744         }
745     }
746 
747     /**
748      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
749      * division by zero. The result is rounded towards zero.
750      *
751      * Counterpart to Solidity's `/` operator. Note: this function uses a
752      * `revert` opcode (which leaves remaining gas untouched) while Solidity
753      * uses an invalid opcode to revert (consuming all remaining gas).
754      *
755      * Requirements:
756      *
757      * - The divisor cannot be zero.
758      */
759     function div(
760         uint256 a,
761         uint256 b,
762         string memory errorMessage
763     ) internal pure returns (uint256) {
764         unchecked {
765             require(b > 0, errorMessage);
766             return a / b;
767         }
768     }
769 
770     /**
771      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
772      * reverting with custom message when dividing by zero.
773      *
774      * CAUTION: This function is deprecated because it requires allocating memory for the error
775      * message unnecessarily. For custom revert reasons use {tryMod}.
776      *
777      * Counterpart to Solidity's `%` operator. This function uses a `revert`
778      * opcode (which leaves remaining gas untouched) while Solidity uses an
779      * invalid opcode to revert (consuming all remaining gas).
780      *
781      * Requirements:
782      *
783      * - The divisor cannot be zero.
784      */
785     function mod(
786         uint256 a,
787         uint256 b,
788         string memory errorMessage
789     ) internal pure returns (uint256) {
790         unchecked {
791             require(b > 0, errorMessage);
792             return a % b;
793         }
794     }
795 }
796 
797 ////// src/IUniswapV2Factory.sol
798 /* pragma solidity 0.8.10; */
799 /* pragma experimental ABIEncoderV2; */
800 
801 interface IUniswapV2Factory {
802     event PairCreated(
803         address indexed token0,
804         address indexed token1,
805         address pair,
806         uint256
807     );
808 
809     function feeTo() external view returns (address);
810 
811     function feeToSetter() external view returns (address);
812 
813     function getPair(address tokenA, address tokenB)
814         external
815         view
816         returns (address pair);
817 
818     function allPairs(uint256) external view returns (address pair);
819 
820     function allPairsLength() external view returns (uint256);
821 
822     function createPair(address tokenA, address tokenB)
823         external
824         returns (address pair);
825 
826     function setFeeTo(address) external;
827 
828     function setFeeToSetter(address) external;
829 }
830 
831 ////// src/IUniswapV2Pair.sol
832 /* pragma solidity 0.8.10; */
833 /* pragma experimental ABIEncoderV2; */
834 
835 interface IUniswapV2Pair {
836     event Approval(
837         address indexed owner,
838         address indexed spender,
839         uint256 value
840     );
841     event Transfer(address indexed from, address indexed to, uint256 value);
842 
843     function name() external pure returns (string memory);
844 
845     function symbol() external pure returns (string memory);
846 
847     function decimals() external pure returns (uint8);
848 
849     function totalSupply() external view returns (uint256);
850 
851     function balanceOf(address owner) external view returns (uint256);
852 
853     function allowance(address owner, address spender)
854         external
855         view
856         returns (uint256);
857 
858     function approve(address spender, uint256 value) external returns (bool);
859 
860     function transfer(address to, uint256 value) external returns (bool);
861 
862     function transferFrom(
863         address from,
864         address to,
865         uint256 value
866     ) external returns (bool);
867 
868     function DOMAIN_SEPARATOR() external view returns (bytes32);
869 
870     function PERMIT_TYPEHASH() external pure returns (bytes32);
871 
872     function nonces(address owner) external view returns (uint256);
873 
874     function permit(
875         address owner,
876         address spender,
877         uint256 value,
878         uint256 deadline,
879         uint8 v,
880         bytes32 r,
881         bytes32 s
882     ) external;
883 
884     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
885     event Burn(
886         address indexed sender,
887         uint256 amount0,
888         uint256 amount1,
889         address indexed to
890     );
891     event Swap(
892         address indexed sender,
893         uint256 amount0In,
894         uint256 amount1In,
895         uint256 amount0Out,
896         uint256 amount1Out,
897         address indexed to
898     );
899     event Sync(uint112 reserve0, uint112 reserve1);
900 
901     function MINIMUM_LIQUIDITY() external pure returns (uint256);
902 
903     function factory() external view returns (address);
904 
905     function token0() external view returns (address);
906 
907     function token1() external view returns (address);
908 
909     function getReserves()
910         external
911         view
912         returns (
913             uint112 reserve0,
914             uint112 reserve1,
915             uint32 blockTimestampLast
916         );
917 
918     function price0CumulativeLast() external view returns (uint256);
919 
920     function price1CumulativeLast() external view returns (uint256);
921 
922     function kLast() external view returns (uint256);
923 
924     function mint(address to) external returns (uint256 liquidity);
925 
926     function burn(address to)
927         external
928         returns (uint256 amount0, uint256 amount1);
929 
930     function swap(
931         uint256 amount0Out,
932         uint256 amount1Out,
933         address to,
934         bytes calldata data
935     ) external;
936 
937     function skim(address to) external;
938 
939     function sync() external;
940 
941     function initialize(address, address) external;
942 }
943 
944 ////// src/IUniswapV2Router02.sol
945 /* pragma solidity 0.8.10; */
946 /* pragma experimental ABIEncoderV2; */
947 
948 interface IUniswapV2Router02 {
949     function factory() external pure returns (address);
950 
951     function WETH() external pure returns (address);
952 
953     function addLiquidity(
954         address tokenA,
955         address tokenB,
956         uint256 amountADesired,
957         uint256 amountBDesired,
958         uint256 amountAMin,
959         uint256 amountBMin,
960         address to,
961         uint256 deadline
962     )
963         external
964         returns (
965             uint256 amountA,
966             uint256 amountB,
967             uint256 liquidity
968         );
969 
970     function addLiquidityETH(
971         address token,
972         uint256 amountTokenDesired,
973         uint256 amountTokenMin,
974         uint256 amountETHMin,
975         address to,
976         uint256 deadline
977     )
978         external
979         payable
980         returns (
981             uint256 amountToken,
982             uint256 amountETH,
983             uint256 liquidity
984         );
985 
986     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
987         uint256 amountIn,
988         uint256 amountOutMin,
989         address[] calldata path,
990         address to,
991         uint256 deadline
992     ) external;
993 
994     function swapExactETHForTokensSupportingFeeOnTransferTokens(
995         uint256 amountOutMin,
996         address[] calldata path,
997         address to,
998         uint256 deadline
999     ) external payable;
1000 
1001     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1002         uint256 amountIn,
1003         uint256 amountOutMin,
1004         address[] calldata path,
1005         address to,
1006         uint256 deadline
1007     ) external;
1008 }
1009 
1010 /* pragma solidity >=0.8.10; */
1011 
1012 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1013 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1014 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1015 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1016 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1017 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1018 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1019 
1020 contract NOTHING is ERC20, Ownable {
1021     using SafeMath for uint256;
1022 
1023     IUniswapV2Router02 public immutable uniswapV2Router;
1024     address public immutable uniswapV2Pair;
1025     address public constant deadAddress = address(0xdead);
1026 
1027     bool private swapping;
1028 
1029     address public marketingWallet;
1030     address public devWallet;
1031 
1032     uint256 public maxTransactionAmount;
1033     uint256 public swapTokensAtAmount;
1034     uint256 public maxWallet;
1035 
1036     uint256 public percentForLPBurn = 25; // 25 = .25%
1037     bool public lpBurnEnabled = false;
1038     uint256 public lpBurnFrequency = 3600 seconds;
1039     uint256 public lastLpBurnTime;
1040 
1041     uint256 public manualBurnFrequency = 30 minutes;
1042     uint256 public lastManualLpBurnTime;
1043 
1044     bool public limitsInEffect = true;
1045     bool public tradingActive = true;
1046     bool public swapEnabled = true;
1047 
1048     // Anti-bot and anti-whale mappings and variables
1049     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1050     bool public transferDelayEnabled = false;
1051 
1052     uint256 public buyTotalFees;
1053     uint256 public buyMarketingFee;
1054     uint256 public buyLiquidityFee;
1055     uint256 public buyDevFee;
1056 
1057     uint256 public sellTotalFees;
1058     uint256 public sellMarketingFee;
1059     uint256 public sellLiquidityFee;
1060     uint256 public sellDevFee;
1061 
1062     uint256 public tokensForMarketing;
1063     uint256 public tokensForLiquidity;
1064     uint256 public tokensForDev;
1065 
1066     /******************/
1067 
1068     // exlcude from fees and max transaction amount
1069     mapping(address => bool) private _isExcludedFromFees;
1070     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1071 
1072     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1073     // could be subject to a maximum transfer amount
1074     mapping(address => bool) public automatedMarketMakerPairs;
1075 
1076     event UpdateUniswapV2Router(
1077         address indexed newAddress,
1078         address indexed oldAddress
1079     );
1080 
1081     event ExcludeFromFees(address indexed account, bool isExcluded);
1082 
1083     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1084 
1085     event marketingWalletUpdated(
1086         address indexed newWallet,
1087         address indexed oldWallet
1088     );
1089 
1090     event devWalletUpdated(
1091         address indexed newWallet,
1092         address indexed oldWallet
1093     );
1094 
1095     event SwapAndLiquify(
1096         uint256 tokensSwapped,
1097         uint256 ethReceived,
1098         uint256 tokensIntoLiquidity
1099     );
1100 
1101     event AutoNukeLP();
1102 
1103     event ManualNukeLP();
1104 
1105     constructor() ERC20("Nothing Protocol", "Nothing") {
1106         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1107             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1108         );
1109 
1110         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1111         uniswapV2Router = _uniswapV2Router;
1112 
1113         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1114             .createPair(address(this), _uniswapV2Router.WETH());
1115         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1116         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1117 
1118         uint256 _buyMarketingFee = 4;
1119         uint256 _buyLiquidityFee = 0;
1120         uint256 _buyDevFee = 1;
1121 
1122         uint256 _sellMarketingFee = 4;
1123         uint256 _sellLiquidityFee = 0;
1124         uint256 _sellDevFee = 1;
1125 
1126         uint256 totalSupply = 1_000_000_000 * 1e18;
1127 
1128         maxTransactionAmount = 20_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1129         maxWallet = 30_000_000 * 1e18; // 3% from total supply maxWallet
1130         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1131 
1132         buyMarketingFee = _buyMarketingFee;
1133         buyLiquidityFee = _buyLiquidityFee;
1134         buyDevFee = _buyDevFee;
1135         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1136 
1137         sellMarketingFee = _sellMarketingFee;
1138         sellLiquidityFee = _sellLiquidityFee;
1139         sellDevFee = _sellDevFee;
1140         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1141 
1142         marketingWallet = address(0xfCFC23Fc2d8C573220363CADb7581D2928925341); // set as marketing wallet
1143         devWallet = address(0xfCFC23Fc2d8C573220363CADb7581D2928925341); // set as dev wallet
1144 
1145         // exclude from paying fees or having max transaction amount
1146         excludeFromFees(owner(), true);
1147         excludeFromFees(address(this), true);
1148         excludeFromFees(address(0xdead), true);
1149 
1150         excludeFromMaxTransaction(owner(), true);
1151         excludeFromMaxTransaction(address(this), true);
1152         excludeFromMaxTransaction(address(0xdead), true);
1153 
1154         /*
1155             _mint is an internal function in ERC20.sol that is only called here,
1156             and CANNOT be called ever again
1157         */
1158         _mint(msg.sender, totalSupply);
1159     }
1160 
1161     receive() external payable {}
1162 
1163     // once enabled, can never be turned off
1164     function enableTrading() external onlyOwner {
1165         tradingActive = true;
1166         swapEnabled = true;
1167         lastLpBurnTime = block.timestamp;
1168     }
1169 
1170     // remove limits after token is stable
1171     function removeLimits() external onlyOwner returns (bool) {
1172         limitsInEffect = false;
1173         return true;
1174     }
1175 
1176     // disable Transfer delay - cannot be reenabled
1177     function disableTransferDelay() external onlyOwner returns (bool) {
1178         transferDelayEnabled = false;
1179         return true;
1180     }
1181 
1182     // change the minimum amount of tokens to sell from fees
1183     function updateSwapTokensAtAmount(uint256 newAmount)
1184         external
1185         onlyOwner
1186         returns (bool)
1187     {
1188         require(
1189             newAmount >= (totalSupply() * 1) / 100000,
1190             "Swap amount cannot be lower than 0.001% total supply."
1191         );
1192         require(
1193             newAmount <= (totalSupply() * 5) / 1000,
1194             "Swap amount cannot be higher than 0.5% total supply."
1195         );
1196         swapTokensAtAmount = newAmount;
1197         return true;
1198     }
1199 
1200     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1201         require(
1202             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1203             "Cannot set maxTransactionAmount lower than 0.1%"
1204         );
1205         maxTransactionAmount = newNum * (10**18);
1206     }
1207 
1208     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1209         require(
1210             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1211             "Cannot set maxWallet lower than 0.5%"
1212         );
1213         maxWallet = newNum * (10**18);
1214     }
1215 
1216     function excludeFromMaxTransaction(address updAds, bool isEx)
1217         public
1218         onlyOwner
1219     {
1220         _isExcludedMaxTransactionAmount[updAds] = isEx;
1221     }
1222 
1223     // only use to disable contract sales if absolutely necessary (emergency use only)
1224     function updateSwapEnabled(bool enabled) external onlyOwner {
1225         swapEnabled = enabled;
1226     }
1227 
1228     function updateBuyFees(
1229         uint256 _marketingFee,
1230         uint256 _liquidityFee,
1231         uint256 _devFee
1232     ) external onlyOwner {
1233         buyMarketingFee = _marketingFee;
1234         buyLiquidityFee = _liquidityFee;
1235         buyDevFee = _devFee;
1236         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1237         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1238     }
1239 
1240     function updateSellFees(
1241         uint256 _marketingFee,
1242         uint256 _liquidityFee,
1243         uint256 _devFee
1244     ) external onlyOwner {
1245         sellMarketingFee = _marketingFee;
1246         sellLiquidityFee = _liquidityFee;
1247         sellDevFee = _devFee;
1248         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1249         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1250     }
1251 
1252     function excludeFromFees(address account, bool excluded) public onlyOwner {
1253         _isExcludedFromFees[account] = excluded;
1254         emit ExcludeFromFees(account, excluded);
1255     }
1256 
1257     function setAutomatedMarketMakerPair(address pair, bool value)
1258         public
1259         onlyOwner
1260     {
1261         require(
1262             pair != uniswapV2Pair,
1263             "The pair cannot be removed from automatedMarketMakerPairs"
1264         );
1265 
1266         _setAutomatedMarketMakerPair(pair, value);
1267     }
1268 
1269     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1270         automatedMarketMakerPairs[pair] = value;
1271 
1272         emit SetAutomatedMarketMakerPair(pair, value);
1273     }
1274 
1275     function updateMarketingWallet(address newMarketingWallet)
1276         external
1277         onlyOwner
1278     {
1279         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1280         marketingWallet = newMarketingWallet;
1281     }
1282 
1283     function updateDevWallet(address newWallet) external onlyOwner {
1284         emit devWalletUpdated(newWallet, devWallet);
1285         devWallet = newWallet;
1286     }
1287 
1288     function isExcludedFromFees(address account) public view returns (bool) {
1289         return _isExcludedFromFees[account];
1290     }
1291 
1292     event BoughtEarly(address indexed sniper);
1293 
1294     function _transfer(
1295         address from,
1296         address to,
1297         uint256 amount
1298     ) internal override {
1299         require(from != address(0), "ERC20: transfer from the zero address");
1300         require(to != address(0), "ERC20: transfer to the zero address");
1301 
1302         if (amount == 0) {
1303             super._transfer(from, to, 0);
1304             return;
1305         }
1306 
1307         if (limitsInEffect) {
1308             if (
1309                 from != owner() &&
1310                 to != owner() &&
1311                 to != address(0) &&
1312                 to != address(0xdead) &&
1313                 !swapping
1314             ) {
1315                 if (!tradingActive) {
1316                     require(
1317                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1318                         "Trading is not active."
1319                     );
1320                 }
1321 
1322                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1323                 if (transferDelayEnabled) {
1324                     if (
1325                         to != owner() &&
1326                         to != address(uniswapV2Router) &&
1327                         to != address(uniswapV2Pair)
1328                     ) {
1329                         require(
1330                             _holderLastTransferTimestamp[tx.origin] <
1331                                 block.number,
1332                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1333                         );
1334                         _holderLastTransferTimestamp[tx.origin] = block.number;
1335                     }
1336                 }
1337 
1338                 //when buy
1339                 if (
1340                     automatedMarketMakerPairs[from] &&
1341                     !_isExcludedMaxTransactionAmount[to]
1342                 ) {
1343                     require(
1344                         amount <= maxTransactionAmount,
1345                         "Buy transfer amount exceeds the maxTransactionAmount."
1346                     );
1347                     require(
1348                         amount + balanceOf(to) <= maxWallet,
1349                         "Max wallet exceeded"
1350                     );
1351                 }
1352                 //when sell
1353                 else if (
1354                     automatedMarketMakerPairs[to] &&
1355                     !_isExcludedMaxTransactionAmount[from]
1356                 ) {
1357                     require(
1358                         amount <= maxTransactionAmount,
1359                         "Sell transfer amount exceeds the maxTransactionAmount."
1360                     );
1361                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1362                     require(
1363                         amount + balanceOf(to) <= maxWallet,
1364                         "Max wallet exceeded"
1365                     );
1366                 }
1367             }
1368         }
1369 
1370         uint256 contractTokenBalance = balanceOf(address(this));
1371 
1372         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1373 
1374         if (
1375             canSwap &&
1376             swapEnabled &&
1377             !swapping &&
1378             !automatedMarketMakerPairs[from] &&
1379             !_isExcludedFromFees[from] &&
1380             !_isExcludedFromFees[to]
1381         ) {
1382             swapping = true;
1383 
1384             swapBack();
1385 
1386             swapping = false;
1387         }
1388 
1389         if (
1390             !swapping &&
1391             automatedMarketMakerPairs[to] &&
1392             lpBurnEnabled &&
1393             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1394             !_isExcludedFromFees[from]
1395         ) {
1396             autoBurnLiquidityPairTokens();
1397         }
1398 
1399         bool takeFee = !swapping;
1400 
1401         // if any account belongs to _isExcludedFromFee account then remove the fee
1402         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1403             takeFee = false;
1404         }
1405 
1406         uint256 fees = 0;
1407         // only take fees on buys/sells, do not take on wallet transfers
1408         if (takeFee) {
1409             // on sell
1410             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1411                 fees = amount.mul(sellTotalFees).div(100);
1412                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1413                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1414                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1415             }
1416             // on buy
1417             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1418                 fees = amount.mul(buyTotalFees).div(100);
1419                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1420                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1421                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1422             }
1423 
1424             if (fees > 0) {
1425                 super._transfer(from, address(this), fees);
1426             }
1427 
1428             amount -= fees;
1429         }
1430 
1431         super._transfer(from, to, amount);
1432     }
1433 
1434     function swapTokensForEth(uint256 tokenAmount) private {
1435         // generate the uniswap pair path of token -> weth
1436         address[] memory path = new address[](2);
1437         path[0] = address(this);
1438         path[1] = uniswapV2Router.WETH();
1439 
1440         _approve(address(this), address(uniswapV2Router), tokenAmount);
1441 
1442         // make the swap
1443         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1444             tokenAmount,
1445             0, // accept any amount of ETH
1446             path,
1447             address(this),
1448             block.timestamp
1449         );
1450     }
1451 
1452     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1453         // approve token transfer to cover all possible scenarios
1454         _approve(address(this), address(uniswapV2Router), tokenAmount);
1455 
1456         // add the liquidity
1457         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1458             address(this),
1459             tokenAmount,
1460             0, // slippage is unavoidable
1461             0, // slippage is unavoidable
1462             deadAddress,
1463             block.timestamp
1464         );
1465     }
1466 
1467     function swapBack() private {
1468         uint256 contractBalance = balanceOf(address(this));
1469         uint256 totalTokensToSwap = tokensForLiquidity +
1470             tokensForMarketing +
1471             tokensForDev;
1472         bool success;
1473 
1474         if (contractBalance == 0 || totalTokensToSwap == 0) {
1475             return;
1476         }
1477 
1478         if (contractBalance > swapTokensAtAmount * 20) {
1479             contractBalance = swapTokensAtAmount * 20;
1480         }
1481 
1482         // Halve the amount of liquidity tokens
1483         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1484             totalTokensToSwap /
1485             2;
1486         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1487 
1488         uint256 initialETHBalance = address(this).balance;
1489 
1490         swapTokensForEth(amountToSwapForETH);
1491 
1492         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1493 
1494         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1495             totalTokensToSwap
1496         );
1497         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1498 
1499         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1500 
1501         tokensForLiquidity = 0;
1502         tokensForMarketing = 0;
1503         tokensForDev = 0;
1504 
1505         (success, ) = address(devWallet).call{value: ethForDev}("");
1506 
1507         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1508             addLiquidity(liquidityTokens, ethForLiquidity);
1509             emit SwapAndLiquify(
1510                 amountToSwapForETH,
1511                 ethForLiquidity,
1512                 tokensForLiquidity
1513             );
1514         }
1515 
1516         (success, ) = address(marketingWallet).call{
1517             value: address(this).balance
1518         }("");
1519     }
1520 
1521     function setAutoLPBurnSettings(
1522         uint256 _frequencyInSeconds,
1523         uint256 _percent,
1524         bool _Enabled
1525     ) external onlyOwner {
1526         require(
1527             _frequencyInSeconds >= 600,
1528             "cannot set buyback more often than every 10 minutes"
1529         );
1530         require(
1531             _percent <= 1000 && _percent >= 0,
1532             "Must set auto LP burn percent between 0% and 10%"
1533         );
1534         lpBurnFrequency = _frequencyInSeconds;
1535         percentForLPBurn = _percent;
1536         lpBurnEnabled = _Enabled;
1537     }
1538 
1539     function autoBurnLiquidityPairTokens() internal returns (bool) {
1540         lastLpBurnTime = block.timestamp;
1541 
1542         // get balance of liquidity pair
1543         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1544 
1545         // calculate amount to burn
1546         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1547 10000
1548         );
1549 
1550         // pull tokens from pancakePair liquidity and move to dead address permanently
1551         if (amountToBurn > 0) {
1552             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1553         }
1554 
1555         //sync price since this is not in a swap transaction!
1556         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1557         pair.sync();
1558         emit AutoNukeLP();
1559         return true;
1560     }
1561 
1562     function manualBurnLiquidityPairTokens(uint256 percent)
1563         external
1564         onlyOwner
1565         returns (bool)
1566     {
1567         require(
1568             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1569             "Must wait for cooldown to finish"
1570         );
1571         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1572         lastManualLpBurnTime = block.timestamp;
1573 
1574         // get balance of liquidity pair
1575         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1576 
1577         // calculate amount to burn
1578         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1579 
1580         // pull tokens from pancakePair liquidity and move to dead address permanently
1581         if (amountToBurn > 0) {
1582             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1583         }
1584 
1585         //sync price since this is not in a swap transaction!
1586         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1587         pair.sync();
1588         emit ManualNukeLP();
1589         return true;
1590     }
1591 }