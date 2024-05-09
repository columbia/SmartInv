1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5     /**
6      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
7      *
8      * Returns a boolean value indicating whether the operation succeeded.
9      *
10      * IMPORTANT: Beware that changing an allowance with this method brings the risk
11      * that someone may use both the old and the new allowance by unfortunate
12      * transaction ordering. One possible solution to mitigate this race
13      * condition is to first reduce the spender's allowance to 0 and set the
14      * desired value afterwards:
15      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
16      *
17      * Emits an {Approval} event.
18      */
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30     /**
31      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * IMPORTANT: Beware that changing an allowance with this method brings the risk
36      * that someone may use both the old and the new allowance by unfortunate
37      * transaction ordering. One possible solution to mitigate this race
38      * condition is to first reduce the spender's allowance to 0 and set the
39      * desired value afterwards:
40      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
41      *
42      * Emits an {Approval} event.
43      */
44 
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     function renounceOwnership() public virtual onlyOwner {
73         _transferOwnership(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Internal function without access restriction.
88      */
89     function _transferOwnership(address newOwner) internal virtual {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
97 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
98 
99 /* pragma solidity ^0.8.0; */
100 
101 /**
102  * @dev Interface of the ERC20 standard as defined in the EIP.
103  */
104 interface IERC20 {
105     /**
106      * @dev Returns the amount of tokens in existence.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     /**
111      * @dev Returns the amount of tokens owned by `account`.
112      */
113     function balanceOf(address account) external view returns (uint256);
114 
115     /**
116      * @dev Moves `amount` tokens from the caller's account to `recipient`.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transfer(address recipient, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Returns the remaining number of tokens that `spender` will be
126      * allowed to spend on behalf of `owner` through {transferFrom}. This is
127      * zero by default.
128      *
129      * This value changes when {approve} or {transferFrom} are called.
130      */
131     function allowance(address owner, address spender) external view returns (uint256);
132 
133     /**
134      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * IMPORTANT: Beware that changing an allowance with this method brings the risk
139      * that someone may use both the old and the new allowance by unfortunate
140      * transaction ordering. One possible solution to mitigate this race
141      * condition is to first reduce the spender's allowance to 0 and set the
142      * desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address spender, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Moves `amount` tokens from `sender` to `recipient` using the
151      * allowance mechanism. `amount` is then deducted from the caller's
152      * allowance.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transferFrom(
159         address sender,
160         address recipient,
161         uint256 amount
162     ) external returns (bool);
163 
164     /**
165      * @dev Emitted when `value` tokens are moved from one account (`from`) to
166      * another (`to`).
167      *
168      * Note that `value` may be zero.
169      */
170     event Transfer(address indexed from, address indexed to, uint256 value);
171 
172     /**
173      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
174      * a call to {approve}. `value` is the new allowance.
175      */
176     event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
180 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
181 
182 /* pragma solidity ^0.8.0; */
183 
184 /* import "../IERC20.sol"; */
185 
186 /**
187  * @dev Interface for the optional metadata functions from the ERC20 standard.
188  *
189  * _Available since v4.1._
190  */
191 interface IERC20Metadata is IERC20 {
192     /**
193      * @dev Returns the name of the token.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the symbol of the token.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the decimals places of the token.
204      */
205     function decimals() external view returns (uint8);
206 }
207 
208 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
209 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
210 
211 /* pragma solidity ^0.8.0; */
212 
213 /* import "./IERC20.sol"; */
214 /* import "./extensions/IERC20Metadata.sol"; */
215 /* import "../../utils/Context.sol"; */
216 
217 /**
218  * @dev Implementation of the {IERC20} interface.
219  *
220  * This implementation is agnostic to the way tokens are created. This means
221  * that a supply mechanism has to be added in a derived contract using {_mint}.
222  * For a generic mechanism see {ERC20PresetMinterPauser}.
223  *
224  * TIP: For a detailed writeup see our guide
225  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
226  * to implement supply mechanisms].
227  *
228  * We have followed general OpenZeppelin Contracts guidelines: functions revert
229  * instead returning `false` on failure. This behavior is nonetheless
230  * conventional and does not conflict with the expectations of ERC20
231  * applications.
232  *
233  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
234  * This allows applications to reconstruct the allowance for all accounts just
235  * by listening to said events. Other implementations of the EIP may not emit
236  * these events, as it isn't required by the specification.
237  *
238  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
239  * functions have been added to mitigate the well-known issues around setting
240  * allowances. See {IERC20-approve}.
241  */
242 contract ERC20 is Context, IERC20, IERC20Metadata {
243     mapping(address => uint256) private _balances;
244 
245     mapping(address => mapping(address => uint256)) private _allowances;
246 
247     uint256 private _totalSupply;
248 
249     string private _name;
250     string private _symbol;
251 
252     /**
253      * @dev Sets the values for {name} and {symbol}.
254      *
255      * The default value of {decimals} is 18. To select a different value for
256      * {decimals} you should overload it.
257      *
258      * All two of these values are immutable: they can only be set once during
259      * construction.
260      */
261     constructor(string memory name_, string memory symbol_) {
262         _name = name_;
263         _symbol = symbol_;
264     }
265 
266     /**
267      * @dev Returns the name of the token.
268      */
269     function name() public view virtual override returns (string memory) {
270         return _name;
271     }
272 
273     /**
274      * @dev Returns the symbol of the token, usually a shorter version of the
275      * name.
276      */
277     function symbol() public view virtual override returns (string memory) {
278         return _symbol;
279     }
280 
281     /**
282      * @dev Returns the number of decimals used to get its user representation.
283      * For example, if `decimals` equals `2`, a balance of `505` tokens should
284      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
285      *
286      * Tokens usually opt for a value of 18, imitating the relationship between
287      * Ether and Wei. This is the value {ERC20} uses, unless this function is
288      * overridden;
289      *
290      * NOTE: This information is only used for _display_ purposes: it in
291      * no way affects any of the arithmetic of the contract, including
292      * {IERC20-balanceOf} and {IERC20-transfer}.
293      */
294     function decimals() public view virtual override returns (uint8) {
295         return 18;
296     }
297 
298     /**
299      * @dev See {IERC20-totalSupply}.
300      */
301     function totalSupply() public view virtual override returns (uint256) {
302         return _totalSupply;
303     }
304 
305     /**
306      * @dev See {IERC20-balanceOf}.
307      */
308     function balanceOf(address account) public view virtual override returns (uint256) {
309         return _balances[account];
310     }
311 
312     /**
313      * @dev See {IERC20-transfer}.
314      *
315      * Requirements:
316      *
317      * - `recipient` cannot be the zero address.
318      * - the caller must have a balance of at least `amount`.
319      */
320     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
321         _transfer(_msgSender(), recipient, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-allowance}.
327      */
328     function allowance(address owner, address spender) public view virtual override returns (uint256) {
329         return _allowances[owner][spender];
330     }
331 
332     /**
333      * @dev See {IERC20-approve}.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function approve(address spender, uint256 amount) public virtual override returns (bool) {
340         _approve(_msgSender(), spender, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-transferFrom}.
346      *
347      * Emits an {Approval} event indicating the updated allowance. This is not
348      * required by the EIP. See the note at the beginning of {ERC20}.
349      *
350      * Requirements:
351      *
352      * - `sender` and `recipient` cannot be the zero address.
353      * - `sender` must have a balance of at least `amount`.
354      * - the caller must have allowance for ``sender``'s tokens of at least
355      * `amount`.
356      */
357     function transferFrom(
358         address sender,
359         address recipient,
360         uint256 amount
361     ) public virtual override returns (bool) {
362         _transfer(sender, recipient, amount);
363 
364         uint256 currentAllowance = _allowances[sender][_msgSender()];
365         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
366         unchecked {
367             _approve(sender, _msgSender(), currentAllowance - amount);
368         }
369 
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
405         uint256 currentAllowance = _allowances[_msgSender()][spender];
406         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
407         unchecked {
408             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
409         }
410 
411         return true;
412     }
413 
414     /**
415      * @dev Moves `amount` of tokens from `sender` to `recipient`.
416      *
417      * This internal function is equivalent to {transfer}, and can be used to
418      * e.g. implement automatic token fees, slashing mechanisms, etc.
419      *
420      * Emits a {Transfer} event.
421      *
422      * Requirements:
423      *
424      * - `sender` cannot be the zero address.
425      * - `recipient` cannot be the zero address.
426      * - `sender` must have a balance of at least `amount`.
427      */
428     function _transfer(
429         address sender,
430         address recipient,
431         uint256 amount
432     ) internal virtual {
433         require(sender != address(0), "ERC20: transfer from the zero address");
434         require(recipient != address(0), "ERC20: transfer to the zero address");
435 
436         _beforeTokenTransfer(sender, recipient, amount);
437 
438         uint256 senderBalance = _balances[sender];
439         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
440         unchecked {
441             _balances[sender] = senderBalance - amount;
442         }
443         _balances[recipient] += amount;
444 
445         emit Transfer(sender, recipient, amount);
446 
447         _afterTokenTransfer(sender, recipient, amount);
448     }
449 
450     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
451      * the total supply.
452      *
453      * Emits a {Transfer} event with `from` set to the zero address.
454      *
455      * Requirements:
456      *
457      * - `account` cannot be the zero address.
458      */
459     function _mint(address account, uint256 amount) internal virtual {
460         require(account != address(0), "ERC20: mint to the zero address");
461 
462         _beforeTokenTransfer(address(0), account, amount);
463 
464         _totalSupply += amount;
465         _balances[account] += amount;
466         emit Transfer(address(0), account, amount);
467 
468         _afterTokenTransfer(address(0), account, amount);
469     }
470 
471     /**
472      * @dev Destroys `amount` tokens from `account`, reducing the
473      * total supply.
474      *
475      * Emits a {Transfer} event with `to` set to the zero address.
476      *
477      * Requirements:
478      *
479      * - `account` cannot be the zero address.
480      * - `account` must have at least `amount` tokens.
481      */
482     function _burn(address account, uint256 amount) internal virtual {
483         require(account != address(0), "ERC20: burn from the zero address");
484 
485         _beforeTokenTransfer(account, address(0), amount);
486 
487         uint256 accountBalance = _balances[account];
488         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
489         unchecked {
490             _balances[account] = accountBalance - amount;
491         }
492         _totalSupply -= amount;
493 
494         emit Transfer(account, address(0), amount);
495 
496         _afterTokenTransfer(account, address(0), amount);
497     }
498 
499     /**
500      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
501      *
502      * This internal function is equivalent to `approve`, and can be used to
503      * e.g. set automatic allowances for certain subsystems, etc.
504      *
505      * Emits an {Approval} event.
506      *
507      * Requirements:
508      *
509      * - `owner` cannot be the zero address.
510      * - `spender` cannot be the zero address.
511      */
512     function _approve(
513         address owner,
514         address spender,
515         uint256 amount
516     ) internal virtual {
517         require(owner != address(0), "ERC20: approve from the zero address");
518         require(spender != address(0), "ERC20: approve to the zero address");
519 
520         _allowances[owner][spender] = amount;
521         emit Approval(owner, spender, amount);
522     }
523 
524     /**
525      * @dev Hook that is called before any transfer of tokens. This includes
526      * minting and burning.
527      *
528      * Calling conditions:
529      *
530      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
531      * will be transferred to `to`.
532      * - when `from` is zero, `amount` tokens will be minted for `to`.
533      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
534      * - `from` and `to` are never both zero.
535      *
536      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
537      */
538     function _beforeTokenTransfer(
539         address from,
540         address to,
541         uint256 amount
542     ) internal virtual {}
543 
544     /**
545      * @dev Hook that is called after any transfer of tokens. This includes
546      * minting and burning.
547      *
548      * Calling conditions:
549      *
550      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
551      * has been transferred to `to`.
552      * - when `from` is zero, `amount` tokens have been minted for `to`.
553      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
554      * - `from` and `to` are never both zero.
555      *
556      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
557      */
558     function _afterTokenTransfer(
559         address from,
560         address to,
561         uint256 amount
562     ) internal virtual {}
563 }
564 
565 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
566 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
567 
568 /* pragma solidity ^0.8.0; */
569 
570 // CAUTION
571 // This version of SafeMath should only be used with Solidity 0.8 or later,
572 // because it relies on the compiler's built in overflow checks.
573 
574 /**
575  * @dev Wrappers over Solidity's arithmetic operations.
576  *
577  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
578  * now has built in overflow checking.
579  */
580 library SafeMath {
581     /**
582      * @dev Returns the addition of two unsigned integers, with an overflow flag.
583      *
584      * _Available since v3.4._
585      */
586     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
587         unchecked {
588             uint256 c = a + b;
589             if (c < a) return (false, 0);
590             return (true, c);
591         }
592     }
593 
594     /**
595      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
596      *
597      * _Available since v3.4._
598      */
599     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
600         unchecked {
601             if (b > a) return (false, 0);
602             return (true, a - b);
603         }
604     }
605 
606     /**
607      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
608      *
609      * _Available since v3.4._
610      */
611     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
612         unchecked {
613             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
614             // benefit is lost if 'b' is also tested.
615             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
616             if (a == 0) return (true, 0);
617             uint256 c = a * b;
618             if (c / a != b) return (false, 0);
619             return (true, c);
620         }
621     }
622 
623     /**
624      * @dev Returns the division of two unsigned integers, with a division by zero flag.
625      *
626      * _Available since v3.4._
627      */
628     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
629         unchecked {
630             if (b == 0) return (false, 0);
631             return (true, a / b);
632         }
633     }
634 
635     /**
636      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
637      *
638      * _Available since v3.4._
639      */
640     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
641         unchecked {
642             if (b == 0) return (false, 0);
643             return (true, a % b);
644         }
645     }
646 
647     /**
648      * @dev Returns the addition of two unsigned integers, reverting on
649      * overflow.
650      *
651      * Counterpart to Solidity's `+` operator.
652      *
653      * Requirements:
654      *
655      * - Addition cannot overflow.
656      */
657     function add(uint256 a, uint256 b) internal pure returns (uint256) {
658         return a + b;
659     }
660 
661     /**
662      * @dev Returns the subtraction of two unsigned integers, reverting on
663      * overflow (when the result is negative).
664      *
665      * Counterpart to Solidity's `-` operator.
666      *
667      * Requirements:
668      *
669      * - Subtraction cannot overflow.
670      */
671     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
672         return a - b;
673     }
674 
675     /**
676      * @dev Returns the multiplication of two unsigned integers, reverting on
677      * overflow.
678      *
679      * Counterpart to Solidity's `*` operator.
680      *
681      * Requirements:
682      *
683      * - Multiplication cannot overflow.
684      */
685     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
686         return a * b;
687     }
688 
689     /**
690      * @dev Returns the integer division of two unsigned integers, reverting on
691      * division by zero. The result is rounded towards zero.
692      *
693      * Counterpart to Solidity's `/` operator.
694      *
695      * Requirements:
696      *
697      * - The divisor cannot be zero.
698      */
699     function div(uint256 a, uint256 b) internal pure returns (uint256) {
700         return a / b;
701     }
702 
703     /**
704      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
705      * reverting when dividing by zero.
706      *
707      * Counterpart to Solidity's `%` operator. This function uses a `revert`
708      * opcode (which leaves remaining gas untouched) while Solidity uses an
709      * invalid opcode to revert (consuming all remaining gas).
710      *
711      * Requirements:
712      *
713      * - The divisor cannot be zero.
714      */
715     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
716         return a % b;
717     }
718 
719     /**
720      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
721      * overflow (when the result is negative).
722      *
723      * CAUTION: This function is deprecated because it requires allocating memory for the error
724      * message unnecessarily. For custom revert reasons use {trySub}.
725      *
726      * Counterpart to Solidity's `-` operator.
727      *
728      * Requirements:
729      *
730      * - Subtraction cannot overflow.
731      */
732     function sub(
733         uint256 a,
734         uint256 b,
735         string memory errorMessage
736     ) internal pure returns (uint256) {
737         unchecked {
738             require(b <= a, errorMessage);
739             return a - b;
740         }
741     }
742 
743     /**
744      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
745      * division by zero. The result is rounded towards zero.
746      *
747      * Counterpart to Solidity's `/` operator. Note: this function uses a
748      * `revert` opcode (which leaves remaining gas untouched) while Solidity
749      * uses an invalid opcode to revert (consuming all remaining gas).
750      *
751      * Requirements:
752      *
753      * - The divisor cannot be zero.
754      */
755     function div(
756         uint256 a,
757         uint256 b,
758         string memory errorMessage
759     ) internal pure returns (uint256) {
760         unchecked {
761             require(b > 0, errorMessage);
762             return a / b;
763         }
764     }
765 
766     /**
767      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
768      * reverting with custom message when dividing by zero.
769      *
770      * CAUTION: This function is deprecated because it requires allocating memory for the error
771      * message unnecessarily. For custom revert reasons use {tryMod}.
772      *
773      * Counterpart to Solidity's `%` operator. This function uses a `revert`
774      * opcode (which leaves remaining gas untouched) while Solidity uses an
775      * invalid opcode to revert (consuming all remaining gas).
776      *
777      * Requirements:
778      *
779      * - The divisor cannot be zero.
780      */
781     function mod(
782         uint256 a,
783         uint256 b,
784         string memory errorMessage
785     ) internal pure returns (uint256) {
786         unchecked {
787             require(b > 0, errorMessage);
788             return a % b;
789         }
790     }
791 }
792 
793 ////// src/IUniswapV2Factory.sol
794 /* pragma solidity 0.8.10; */
795 /* pragma experimental ABIEncoderV2; */
796 
797 interface IUniswapV2Factory {
798     event PairCreated(
799         address indexed token0,
800         address indexed token1,
801         address pair,
802         uint256
803     );
804 
805     function feeTo() external view returns (address);
806 
807     function feeToSetter() external view returns (address);
808 
809     function getPair(address tokenA, address tokenB)
810         external
811         view
812         returns (address pair);
813 
814     function allPairs(uint256) external view returns (address pair);
815 
816     function allPairsLength() external view returns (uint256);
817 
818     function createPair(address tokenA, address tokenB)
819         external
820         returns (address pair);
821 
822     function setFeeTo(address) external;
823 
824     function setFeeToSetter(address) external;
825 }
826 
827 ////// src/IUniswapV2Pair.sol
828 /* pragma solidity 0.8.10; */
829 /* pragma experimental ABIEncoderV2; */
830 
831 interface IUniswapV2Pair {
832     event Approval(
833         address indexed owner,
834         address indexed spender,
835         uint256 value
836     );
837     event Transfer(address indexed from, address indexed to, uint256 value);
838 
839     function name() external pure returns (string memory);
840 
841     function symbol() external pure returns (string memory);
842 
843     function decimals() external pure returns (uint8);
844 
845     function totalSupply() external view returns (uint256);
846 
847     function balanceOf(address owner) external view returns (uint256);
848 
849     function allowance(address owner, address spender)
850         external
851         view
852         returns (uint256);
853 
854     function approve(address spender, uint256 value) external returns (bool);
855 
856     function transfer(address to, uint256 value) external returns (bool);
857 
858     function transferFrom(
859         address from,
860         address to,
861         uint256 value
862     ) external returns (bool);
863 
864     function DOMAIN_SEPARATOR() external view returns (bytes32);
865 
866     function PERMIT_TYPEHASH() external pure returns (bytes32);
867 
868     function nonces(address owner) external view returns (uint256);
869 
870     function permit(
871         address owner,
872         address spender,
873         uint256 value,
874         uint256 deadline,
875         uint8 v,
876         bytes32 r,
877         bytes32 s
878     ) external;
879 
880     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
881     event Burn(
882         address indexed sender,
883         uint256 amount0,
884         uint256 amount1,
885         address indexed to
886     );
887     event Swap(
888         address indexed sender,
889         uint256 amount0In,
890         uint256 amount1In,
891         uint256 amount0Out,
892         uint256 amount1Out,
893         address indexed to
894     );
895     event Sync(uint112 reserve0, uint112 reserve1);
896 
897     function MINIMUM_LIQUIDITY() external pure returns (uint256);
898 
899     function factory() external view returns (address);
900 
901     function token0() external view returns (address);
902 
903     function token1() external view returns (address);
904 
905     function getReserves()
906         external
907         view
908         returns (
909             uint112 reserve0,
910             uint112 reserve1,
911             uint32 blockTimestampLast
912         );
913 
914     function price0CumulativeLast() external view returns (uint256);
915 
916     function price1CumulativeLast() external view returns (uint256);
917 
918     function kLast() external view returns (uint256);
919 
920     function mint(address to) external returns (uint256 liquidity);
921 
922     function burn(address to)
923         external
924         returns (uint256 amount0, uint256 amount1);
925 
926     function swap(
927         uint256 amount0Out,
928         uint256 amount1Out,
929         address to,
930         bytes calldata data
931     ) external;
932 
933     function skim(address to) external;
934 
935     function sync() external;
936 
937     function initialize(address, address) external;
938 }
939 
940 ////// src/IUniswapV2Router02.sol
941 /* pragma solidity 0.8.10; */
942 /* pragma experimental ABIEncoderV2; */
943 
944 interface IUniswapV2Router02 {
945     function factory() external pure returns (address);
946 
947     function WETH() external pure returns (address);
948 
949     function addLiquidity(
950         address tokenA,
951         address tokenB,
952         uint256 amountADesired,
953         uint256 amountBDesired,
954         uint256 amountAMin,
955         uint256 amountBMin,
956         address to,
957         uint256 deadline
958     )
959         external
960         returns (
961             uint256 amountA,
962             uint256 amountB,
963             uint256 liquidity
964         );
965 
966     function addLiquidityETH(
967         address token,
968         uint256 amountTokenDesired,
969         uint256 amountTokenMin,
970         uint256 amountETHMin,
971         address to,
972         uint256 deadline
973     )
974         external
975         payable
976         returns (
977             uint256 amountToken,
978             uint256 amountETH,
979             uint256 liquidity
980         );
981 
982     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
983         uint256 amountIn,
984         uint256 amountOutMin,
985         address[] calldata path,
986         address to,
987         uint256 deadline
988     ) external;
989 
990     function swapExactETHForTokensSupportingFeeOnTransferTokens(
991         uint256 amountOutMin,
992         address[] calldata path,
993         address to,
994         uint256 deadline
995     ) external payable;
996 
997     function swapExactTokensForETHSupportingFeeOnTransferTokens(
998         uint256 amountIn,
999         uint256 amountOutMin,
1000         address[] calldata path,
1001         address to,
1002         uint256 deadline
1003     ) external;
1004 }
1005 
1006 /* pragma solidity >=0.8.10; */
1007 
1008 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1009 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1010 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1011 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1012 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1013 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1014 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1015 
1016 contract ERC is ERC20, Ownable {
1017     using SafeMath for uint256;
1018 
1019     IUniswapV2Router02 public immutable uniswapV2Router;
1020     address public immutable uniswapV2Pair;
1021     address public constant deadAddress = address(0xdead);
1022 
1023     bool private swapping;
1024 
1025     address public marketingWallet;
1026     address public devWallet;
1027 
1028     uint256 public maxTransactionAmount;
1029     uint256 public swapTokensAtAmount;
1030     uint256 public maxWallet;
1031 
1032     uint256 public percentForLPBurn = 25; // 25 = .25%
1033     bool public lpBurnEnabled = false;
1034     uint256 public lpBurnFrequency = 3600 seconds;
1035     uint256 public lastLpBurnTime;
1036 
1037     uint256 public manualBurnFrequency = 30 minutes;
1038     uint256 public lastManualLpBurnTime;
1039 
1040     bool public limitsInEffect = true;
1041     bool public tradingActive = true;
1042     bool public swapEnabled = true;
1043 
1044     // Anti-bot and anti-whale mappings and variables
1045     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1046     bool public transferDelayEnabled = false;
1047 
1048     uint256 public buyTotalFees;
1049     uint256 public buyMarketingFee;
1050     uint256 public buyLiquidityFee;
1051     uint256 public buyDevFee;
1052 
1053     uint256 public sellTotalFees;
1054     uint256 public sellMarketingFee;
1055     uint256 public sellLiquidityFee;
1056     uint256 public sellDevFee;
1057 
1058     uint256 public tokensForMarketing;
1059     uint256 public tokensForLiquidity;
1060     uint256 public tokensForDev;
1061 
1062     /******************/
1063 
1064     // exlcude from fees and max transaction amount
1065     mapping(address => bool) private _isExcludedFromFees;
1066     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1067 
1068     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1069     // could be subject to a maximum transfer amount
1070     mapping(address => bool) public automatedMarketMakerPairs;
1071 
1072     event UpdateUniswapV2Router(
1073         address indexed newAddress,
1074         address indexed oldAddress
1075     );
1076 
1077     event ExcludeFromFees(address indexed account, bool isExcluded);
1078 
1079     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1080 
1081     event marketingWalletUpdated(
1082         address indexed newWallet,
1083         address indexed oldWallet
1084     );
1085 
1086     event devWalletUpdated(
1087         address indexed newWallet,
1088         address indexed oldWallet
1089     );
1090 
1091     event SwapAndLiquify(
1092         uint256 tokensSwapped,
1093         uint256 ethReceived,
1094         uint256 tokensIntoLiquidity
1095     );
1096 
1097     event AutoNukeLP();
1098 
1099     event ManualNukeLP();
1100 
1101     constructor() ERC20("7", "$7") {
1102         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1103             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1104         );
1105 
1106         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1107         uniswapV2Router = _uniswapV2Router;
1108 
1109         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1110             .createPair(address(this), _uniswapV2Router.WETH());
1111         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1112         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1113 
1114         uint256 _buyMarketingFee = 3;
1115         uint256 _buyLiquidityFee = 0;
1116         uint256 _buyDevFee = 1;
1117 
1118         uint256 _sellMarketingFee = 3;
1119         uint256 _sellLiquidityFee = 0;
1120         uint256 _sellDevFee = 1;
1121 
1122         uint256 totalSupply = 1_000_000_000 * 1e18;
1123 
1124         maxTransactionAmount = 30_000_000 * 1e18; // 3% from total supply maxTransactionAmountTxn
1125         maxWallet = 30_000_000 * 1e18; // 3% from total supply maxWallet
1126         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1127 
1128         buyMarketingFee = _buyMarketingFee;
1129         buyLiquidityFee = _buyLiquidityFee;
1130         buyDevFee = _buyDevFee;
1131         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1132 
1133         sellMarketingFee = _sellMarketingFee;
1134         sellLiquidityFee = _sellLiquidityFee;
1135         sellDevFee = _sellDevFee;
1136         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1137 
1138         marketingWallet = address(0xfd85319d69F54d3798FaBCE8144DD302C6d9Bb29); // set as marketing wallet
1139         devWallet = address(0xfd85319d69F54d3798FaBCE8144DD302C6d9Bb29); // set as dev wallet
1140 
1141         // exclude from paying fees or having max transaction amount
1142         excludeFromFees(owner(), true);
1143         excludeFromFees(address(this), true);
1144         excludeFromFees(address(0xdead), true);
1145 
1146         excludeFromMaxTransaction(owner(), true);
1147         excludeFromMaxTransaction(address(this), true);
1148         excludeFromMaxTransaction(address(0xdead), true);
1149 
1150         /*
1151             _mint is an internal function in ERC20.sol that is only called here,
1152             and CANNOT be called ever again
1153         */
1154         _mint(msg.sender, totalSupply);
1155     }
1156 
1157     receive() external payable {}
1158 
1159     // once enabled, can never be turned off
1160     function enableTrading() external onlyOwner {
1161         tradingActive = true;
1162         swapEnabled = true;
1163         lastLpBurnTime = block.timestamp;
1164     }
1165 
1166     // remove limits after token is stable
1167     function removeLimits() external onlyOwner returns (bool) {
1168         limitsInEffect = false;
1169         return true;
1170     }
1171 
1172     // disable Transfer delay - cannot be reenabled
1173     function disableTransferDelay() external onlyOwner returns (bool) {
1174         transferDelayEnabled = false;
1175         return true;
1176     }
1177 
1178     // change the minimum amount of tokens to sell from fees
1179     function updateSwapTokensAtAmount(uint256 newAmount)
1180         external
1181         onlyOwner
1182         returns (bool)
1183     {
1184         require(
1185             newAmount >= (totalSupply() * 1) / 100000,
1186             "Swap amount cannot be lower than 0.001% total supply."
1187         );
1188         require(
1189             newAmount <= (totalSupply() * 5) / 1000,
1190             "Swap amount cannot be higher than 0.5% total supply."
1191         );
1192         swapTokensAtAmount = newAmount;
1193         return true;
1194     }
1195 
1196     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1197         require(
1198             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1199             "Cannot set maxTransactionAmount lower than 0.1%"
1200         );
1201         maxTransactionAmount = newNum * (10**18);
1202     }
1203 
1204     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1205         require(
1206             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1207             "Cannot set maxWallet lower than 0.5%"
1208         );
1209         maxWallet = newNum * (10**18);
1210     }
1211 
1212     function excludeFromMaxTransaction(address updAds, bool isEx)
1213         public
1214         onlyOwner
1215     {
1216         _isExcludedMaxTransactionAmount[updAds] = isEx;
1217     }
1218 
1219     // only use to disable contract sales if absolutely necessary (emergency use only)
1220     function updateSwapEnabled(bool enabled) external onlyOwner {
1221         swapEnabled = enabled;
1222     }
1223 
1224     function updateBuyFees(
1225         uint256 _marketingFee,
1226         uint256 _liquidityFee,
1227         uint256 _devFee
1228     ) external onlyOwner {
1229         buyMarketingFee = _marketingFee;
1230         buyLiquidityFee = _liquidityFee;
1231         buyDevFee = _devFee;
1232         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1233         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1234     }
1235 
1236     function updateSellFees(
1237         uint256 _marketingFee,
1238         uint256 _liquidityFee,
1239         uint256 _devFee
1240     ) external onlyOwner {
1241         sellMarketingFee = _marketingFee;
1242         sellLiquidityFee = _liquidityFee;
1243         sellDevFee = _devFee;
1244         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1245         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1246     }
1247 
1248     function excludeFromFees(address account, bool excluded) public onlyOwner {
1249         _isExcludedFromFees[account] = excluded;
1250         emit ExcludeFromFees(account, excluded);
1251     }
1252 
1253     function setAutomatedMarketMakerPair(address pair, bool value)
1254         public
1255         onlyOwner
1256     {
1257         require(
1258             pair != uniswapV2Pair,
1259             "The pair cannot be removed from automatedMarketMakerPairs"
1260         );
1261 
1262         _setAutomatedMarketMakerPair(pair, value);
1263     }
1264 
1265     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1266         automatedMarketMakerPairs[pair] = value;
1267 
1268         emit SetAutomatedMarketMakerPair(pair, value);
1269     }
1270 
1271     function updateMarketingWallet(address newMarketingWallet)
1272         external
1273         onlyOwner
1274     {
1275         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1276         marketingWallet = newMarketingWallet;
1277     }
1278 
1279     function updateDevWallet(address newWallet) external onlyOwner {
1280         emit devWalletUpdated(newWallet, devWallet);
1281         devWallet = newWallet;
1282     }
1283 
1284     function isExcludedFromFees(address account) public view returns (bool) {
1285         return _isExcludedFromFees[account];
1286     }
1287 
1288     event BoughtEarly(address indexed sniper);
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
1385         if (
1386             !swapping &&
1387             automatedMarketMakerPairs[to] &&
1388             lpBurnEnabled &&
1389             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1390             !_isExcludedFromFees[from]
1391         ) {
1392             autoBurnLiquidityPairTokens();
1393         }
1394 
1395         bool takeFee = !swapping;
1396 
1397         // if any account belongs to _isExcludedFromFee account then remove the fee
1398         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1399             takeFee = false;
1400         }
1401 
1402         uint256 fees = 0;
1403         // only take fees on buys/sells, do not take on wallet transfers
1404         if (takeFee) {
1405             // on sell
1406             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1407                 fees = amount.mul(sellTotalFees).div(100);
1408                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1409                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1410                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1411             }
1412             // on buy
1413             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1414                 fees = amount.mul(buyTotalFees).div(100);
1415                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1416                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1417                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1418             }
1419 
1420             if (fees > 0) {
1421                 super._transfer(from, address(this), fees);
1422             }
1423 
1424             amount -= fees;
1425         }
1426 
1427         super._transfer(from, to, amount);
1428     }
1429 
1430     function swapTokensForEth(uint256 tokenAmount) private {
1431         // generate the uniswap pair path of token -> weth
1432         address[] memory path = new address[](2);
1433         path[0] = address(this);
1434         path[1] = uniswapV2Router.WETH();
1435 
1436         _approve(address(this), address(uniswapV2Router), tokenAmount);
1437 
1438         // make the swap
1439         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1440             tokenAmount,
1441             0, // accept any amount of ETH
1442             path,
1443             address(this),
1444             block.timestamp
1445         );
1446     }
1447 
1448     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1449         // approve token transfer to cover all possible scenarios
1450         _approve(address(this), address(uniswapV2Router), tokenAmount);
1451 
1452         // add the liquidity
1453         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1454             address(this),
1455             tokenAmount,
1456             0, // slippage is unavoidable
1457             0, // slippage is unavoidable
1458             deadAddress,
1459             block.timestamp
1460         );
1461     }
1462 
1463     function swapBack() private {
1464         uint256 contractBalance = balanceOf(address(this));
1465         uint256 totalTokensToSwap = tokensForLiquidity +
1466             tokensForMarketing +
1467             tokensForDev;
1468         bool success;
1469 
1470         if (contractBalance == 0 || totalTokensToSwap == 0) {
1471             return;
1472         }
1473 
1474         if (contractBalance > swapTokensAtAmount * 20) {
1475             contractBalance = swapTokensAtAmount * 20;
1476         }
1477 
1478         // Halve the amount of liquidity tokens
1479         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1480             totalTokensToSwap /
1481             2;
1482         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1483 
1484         uint256 initialETHBalance = address(this).balance;
1485 
1486         swapTokensForEth(amountToSwapForETH);
1487 
1488         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1489 
1490         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1491             totalTokensToSwap
1492         );
1493         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1494 
1495         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1496 
1497         tokensForLiquidity = 0;
1498         tokensForMarketing = 0;
1499         tokensForDev = 0;
1500 
1501         (success, ) = address(devWallet).call{value: ethForDev}("");
1502 
1503         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1504             addLiquidity(liquidityTokens, ethForLiquidity);
1505             emit SwapAndLiquify(
1506                 amountToSwapForETH,
1507                 ethForLiquidity,
1508                 tokensForLiquidity
1509             );
1510         }
1511 
1512         (success, ) = address(marketingWallet).call{
1513             value: address(this).balance
1514         }("");
1515     }
1516 
1517     function setAutoLPBurnSettings(
1518         uint256 _frequencyInSeconds,
1519         uint256 _percent,
1520         bool _Enabled
1521     ) external onlyOwner {
1522         require(
1523             _frequencyInSeconds >= 600,
1524             "cannot set buyback more often than every 10 minutes"
1525         );
1526         require(
1527             _percent <= 1000 && _percent >= 0,
1528             "Must set auto LP burn percent between 0% and 10%"
1529         );
1530         lpBurnFrequency = _frequencyInSeconds;
1531         percentForLPBurn = _percent;
1532         lpBurnEnabled = _Enabled;
1533     }
1534 
1535     function autoBurnLiquidityPairTokens() internal returns (bool) {
1536         lastLpBurnTime = block.timestamp;
1537 
1538         // get balance of liquidity pair
1539         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1540 
1541         // calculate amount to burn
1542         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1543             10000
1544         );
1545 
1546         // pull tokens from pancakePair liquidity and move to dead address permanently
1547         if (amountToBurn > 0) {
1548             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1549         }
1550 
1551         //sync price since this is not in a swap transaction!
1552         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1553         pair.sync();
1554         emit AutoNukeLP();
1555         return true;
1556     }
1557 
1558     function manualBurnLiquidityPairTokens(uint256 percent)
1559         external
1560         onlyOwner
1561         returns (bool)
1562     {
1563         require(
1564             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1565             "Must wait for cooldown to finish"
1566         );
1567         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1568         lastManualLpBurnTime = block.timestamp;
1569 
1570         // get balance of liquidity pair
1571         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1572 
1573         // calculate amount to burn
1574         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1575 
1576         // pull tokens from pancakePair liquidity and move to dead address permanently
1577         if (amountToBurn > 0) {
1578             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1579         }
1580 
1581         //sync price since this is not in a swap transaction!
1582         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1583         pair.sync();
1584         emit ManualNukeLP();
1585         return true;
1586     }
1587 }