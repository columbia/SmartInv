1 /**
2  * The Firm wishes to advise all users of its $TRIUNE token that
3  * the firm is not in control of the cryptocurrency, and as a 
4  * decentralized asset, has no determining authority or influence 
5  * over it. As such, $TRIUNE is solely managed by the public blockchain
6  * network and the users of it who hold the asset. The Firm is not 
7  * liable for any loss or claim arising out of or in connection with any 
8  * acts related to SHIBA ecosystem.
9 **/
10 
11 // SPDX-License-Identifier: MIT
12 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
13 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 // CAUTION
18 // This version of SafeMath should only be used with Solidity 0.8 or later,
19 // because it relies on the compiler's built in overflow checks.
20 
21 /**
22  * @dev Wrappers over Solidity's arithmetic operations.
23  *
24  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
25  * now has built in overflow checking.
26  */
27 library SafeMath {
28     /**
29      * @dev Returns the addition of two unsigned integers, with an overflow flag.
30      *
31      * _Available since v3.4._
32      */
33     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             uint256 c = a + b;
36             if (c < a) return (false, 0);
37             return (true, c);
38         }
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             if (b > a) return (false, 0);
49             return (true, a - b);
50         }
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
55      *
56      * _Available since v3.4._
57      */
58     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61             // benefit is lost if 'b' is also tested.
62             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63             if (a == 0) return (true, 0);
64             uint256 c = a * b;
65             if (c / a != b) return (false, 0);
66             return (true, c);
67         }
68     }
69 
70     /**
71      * @dev Returns the division of two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b == 0) return (false, 0);
78             return (true, a / b);
79         }
80     }
81 
82     /**
83      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             if (b == 0) return (false, 0);
90             return (true, a % b);
91         }
92     }
93 
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         return a + b;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a - b;
120     }
121 
122     /**
123      * @dev Returns the multiplication of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `*` operator.
127      *
128      * Requirements:
129      *
130      * - Multiplication cannot overflow.
131      */
132     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133         return a * b;
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers, reverting on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator.
141      *
142      * Requirements:
143      *
144      * - The divisor cannot be zero.
145      */
146     function div(uint256 a, uint256 b) internal pure returns (uint256) {
147         return a / b;
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * reverting when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         return a % b;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168      * overflow (when the result is negative).
169      *
170      * CAUTION: This function is deprecated because it requires allocating memory for the error
171      * message unnecessarily. For custom revert reasons use {trySub}.
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(
180         uint256 a,
181         uint256 b,
182         string memory errorMessage
183     ) internal pure returns (uint256) {
184         unchecked {
185             require(b <= a, errorMessage);
186             return a - b;
187         }
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(
203         uint256 a,
204         uint256 b,
205         string memory errorMessage
206     ) internal pure returns (uint256) {
207         unchecked {
208             require(b > 0, errorMessage);
209             return a / b;
210         }
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * reverting with custom message when dividing by zero.
216      *
217      * CAUTION: This function is deprecated because it requires allocating memory for the error
218      * message unnecessarily. For custom revert reasons use {tryMod}.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(
229         uint256 a,
230         uint256 b,
231         string memory errorMessage
232     ) internal pure returns (uint256) {
233         unchecked {
234             require(b > 0, errorMessage);
235             return a % b;
236         }
237     }
238 }
239 
240 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
241 
242 
243 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev Interface of the ERC20 standard as defined in the EIP.
249  */
250 interface IERC20 {
251     /**
252      * @dev Emitted when `value` tokens are moved from one account (`from`) to
253      * another (`to`).
254      *
255      * Note that `value` may be zero.
256      */
257     event Transfer(address indexed from, address indexed to, uint256 value);
258 
259     /**
260      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
261      * a call to {approve}. `value` is the new allowance.
262      */
263     event Approval(address indexed owner, address indexed spender, uint256 value);
264 
265     /**
266      * @dev Returns the amount of tokens in existence.
267      */
268     function totalSupply() external view returns (uint256);
269 
270     /**
271      * @dev Returns the amount of tokens owned by `account`.
272      */
273     function balanceOf(address account) external view returns (uint256);
274 
275     /**
276      * @dev Moves `amount` tokens from the caller's account to `to`.
277      *
278      * Returns a boolean value indicating whether the operation succeeded.
279      *
280      * Emits a {Transfer} event.
281      */
282     function transfer(address to, uint256 amount) external returns (bool);
283 
284     /**
285      * @dev Returns the remaining number of tokens that `spender` will be
286      * allowed to spend on behalf of `owner` through {transferFrom}. This is
287      * zero by default.
288      *
289      * This value changes when {approve} or {transferFrom} are called.
290      */
291     function allowance(address owner, address spender) external view returns (uint256);
292 
293     /**
294      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
295      *
296      * Returns a boolean value indicating whether the operation succeeded.
297      *
298      * IMPORTANT: Beware that changing an allowance with this method brings the risk
299      * that someone may use both the old and the new allowance by unfortunate
300      * transaction ordering. One possible solution to mitigate this race
301      * condition is to first reduce the spender's allowance to 0 and set the
302      * desired value afterwards:
303      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
304      *
305      * Emits an {Approval} event.
306      */
307     function approve(address spender, uint256 amount) external returns (bool);
308 
309     /**
310      * @dev Moves `amount` tokens from `from` to `to` using the
311      * allowance mechanism. `amount` is then deducted from the caller's
312      * allowance.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * Emits a {Transfer} event.
317      */
318     function transferFrom(
319         address from,
320         address to,
321         uint256 amount
322     ) external returns (bool);
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 
333 /**
334  * @dev Interface for the optional metadata functions from the ERC20 standard.
335  *
336  * _Available since v4.1._
337  */
338 interface IERC20Metadata is IERC20 {
339     /**
340      * @dev Returns the name of the token.
341      */
342     function name() external view returns (string memory);
343 
344     /**
345      * @dev Returns the symbol of the token.
346      */
347     function symbol() external view returns (string memory);
348 
349     /**
350      * @dev Returns the decimals places of the token.
351      */
352     function decimals() external view returns (uint8);
353 }
354 
355 // File: @openzeppelin/contracts/utils/Context.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Provides information about the current execution context, including the
364  * sender of the transaction and its data. While these are generally available
365  * via msg.sender and msg.data, they should not be accessed in such a direct
366  * manner, since when dealing with meta-transactions the account sending and
367  * paying for execution may not be the actual sender (as far as an application
368  * is concerned).
369  *
370  * This contract is only required for intermediate, library-like contracts.
371  */
372 abstract contract Context {
373     function _msgSender() internal view virtual returns (address) {
374         return msg.sender;
375     }
376 
377     function _msgData() internal view virtual returns (bytes calldata) {
378         return msg.data;
379     }
380 }
381 
382 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
383 
384 
385 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 
391 
392 /**
393  * @dev Implementation of the {IERC20} interface.
394  *
395  * This implementation is agnostic to the way tokens are created. This means
396  * that a supply mechanism has to be added in a derived contract using {_mint}.
397  * For a generic mechanism see {ERC20PresetMinterPauser}.
398  *
399  * TIP: For a detailed writeup see our guide
400  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
401  * to implement supply mechanisms].
402  *
403  * We have followed general OpenZeppelin Contracts guidelines: functions revert
404  * instead returning `false` on failure. This behavior is nonetheless
405  * conventional and does not conflict with the expectations of ERC20
406  * applications.
407  *
408  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
409  * This allows applications to reconstruct the allowance for all accounts just
410  * by listening to said events. Other implementations of the EIP may not emit
411  * these events, as it isn't required by the specification.
412  *
413  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
414  * functions have been added to mitigate the well-known issues around setting
415  * allowances. See {IERC20-approve}.
416  */
417 contract ERC20 is Context, IERC20, IERC20Metadata {
418     mapping(address => uint256) private _balances;
419 
420     mapping(address => mapping(address => uint256)) private _allowances;
421 
422     uint256 private _totalSupply;
423 
424     string private _name;
425     string private _symbol;
426 
427     /**
428      * @dev Sets the values for {name} and {symbol}.
429      *
430      * The default value of {decimals} is 18. To select a different value for
431      * {decimals} you should overload it.
432      *
433      * All two of these values are immutable: they can only be set once during
434      * construction.
435      */
436     constructor(string memory name_, string memory symbol_) {
437         _name = name_;
438         _symbol = symbol_;
439     }
440 
441     /**
442      * @dev Returns the name of the token.
443      */
444     function name() public view virtual override returns (string memory) {
445         return _name;
446     }
447 
448     /**
449      * @dev Returns the symbol of the token, usually a shorter version of the
450      * name.
451      */
452     function symbol() public view virtual override returns (string memory) {
453         return _symbol;
454     }
455 
456     /**
457      * @dev Returns the number of decimals used to get its user representation.
458      * For example, if `decimals` equals `2`, a balance of `505` tokens should
459      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
460      *
461      * Tokens usually opt for a value of 18, imitating the relationship between
462      * Ether and Wei. This is the value {ERC20} uses, unless this function is
463      * overridden;
464      *
465      * NOTE: This information is only used for _display_ purposes: it in
466      * no way affects any of the arithmetic of the contract, including
467      * {IERC20-balanceOf} and {IERC20-transfer}.
468      */
469     function decimals() public view virtual override returns (uint8) {
470         return 18;
471     }
472 
473     /**
474      * @dev See {IERC20-totalSupply}.
475      */
476     function totalSupply() public view virtual override returns (uint256) {
477         return _totalSupply;
478     }
479 
480     /**
481      * @dev See {IERC20-balanceOf}.
482      */
483     function balanceOf(address account) public view virtual override returns (uint256) {
484         return _balances[account];
485     }
486 
487     /**
488      * @dev See {IERC20-transfer}.
489      *
490      * Requirements:
491      *
492      * - `to` cannot be the zero address.
493      * - the caller must have a balance of at least `amount`.
494      */
495     function transfer(address to, uint256 amount) public virtual override returns (bool) {
496         address owner = _msgSender();
497         _transfer(owner, to, amount);
498         return true;
499     }
500 
501     /**
502      * @dev See {IERC20-allowance}.
503      */
504     function allowance(address owner, address spender) public view virtual override returns (uint256) {
505         return _allowances[owner][spender];
506     }
507 
508     /**
509      * @dev See {IERC20-approve}.
510      *
511      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
512      * `transferFrom`. This is semantically equivalent to an infinite approval.
513      *
514      * Requirements:
515      *
516      * - `spender` cannot be the zero address.
517      */
518     function approve(address spender, uint256 amount) public virtual override returns (bool) {
519         address owner = _msgSender();
520         _approve(owner, spender, amount);
521         return true;
522     }
523 
524     /**
525      * @dev See {IERC20-transferFrom}.
526      *
527      * Emits an {Approval} event indicating the updated allowance. This is not
528      * required by the EIP. See the note at the beginning of {ERC20}.
529      *
530      * NOTE: Does not update the allowance if the current allowance
531      * is the maximum `uint256`.
532      *
533      * Requirements:
534      *
535      * - `from` and `to` cannot be the zero address.
536      * - `from` must have a balance of at least `amount`.
537      * - the caller must have allowance for ``from``'s tokens of at least
538      * `amount`.
539      */
540     function transferFrom(
541         address from,
542         address to,
543         uint256 amount
544     ) public virtual override returns (bool) {
545         address spender = _msgSender();
546         _spendAllowance(from, spender, amount);
547         _transfer(from, to, amount);
548         return true;
549     }
550 
551     /**
552      * @dev Atomically increases the allowance granted to `spender` by the caller.
553      *
554      * This is an alternative to {approve} that can be used as a mitigation for
555      * problems described in {IERC20-approve}.
556      *
557      * Emits an {Approval} event indicating the updated allowance.
558      *
559      * Requirements:
560      *
561      * - `spender` cannot be the zero address.
562      */
563     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
564         address owner = _msgSender();
565         _approve(owner, spender, allowance(owner, spender) + addedValue);
566         return true;
567     }
568 
569     /**
570      * @dev Atomically decreases the allowance granted to `spender` by the caller.
571      *
572      * This is an alternative to {approve} that can be used as a mitigation for
573      * problems described in {IERC20-approve}.
574      *
575      * Emits an {Approval} event indicating the updated allowance.
576      *
577      * Requirements:
578      *
579      * - `spender` cannot be the zero address.
580      * - `spender` must have allowance for the caller of at least
581      * `subtractedValue`.
582      */
583     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
584         address owner = _msgSender();
585         uint256 currentAllowance = allowance(owner, spender);
586         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
587         unchecked {
588             _approve(owner, spender, currentAllowance - subtractedValue);
589         }
590 
591         return true;
592     }
593 
594     /**
595      * @dev Moves `amount` of tokens from `from` to `to`.
596      *
597      * This internal function is equivalent to {transfer}, and can be used to
598      * e.g. implement automatic token fees, slashing mechanisms, etc.
599      *
600      * Emits a {Transfer} event.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `from` must have a balance of at least `amount`.
607      */
608     function _transfer(
609         address from,
610         address to,
611         uint256 amount
612     ) internal virtual {
613         require(from != address(0), "ERC20: transfer from the zero address");
614         require(to != address(0), "ERC20: transfer to the zero address");
615 
616         _beforeTokenTransfer(from, to, amount);
617 
618         uint256 fromBalance = _balances[from];
619         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
620         unchecked {
621             _balances[from] = fromBalance - amount;
622         }
623         _balances[to] += amount;
624 
625         emit Transfer(from, to, amount);
626 
627         _afterTokenTransfer(from, to, amount);
628     }
629 
630     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
631      * the total supply.
632      *
633      * Emits a {Transfer} event with `from` set to the zero address.
634      *
635      * Requirements:
636      *
637      * - `account` cannot be the zero address.
638      */
639     function _mint(address account, uint256 amount) internal virtual {
640         require(account != address(0), "ERC20: mint to the zero address");
641 
642         _beforeTokenTransfer(address(0), account, amount);
643 
644         _totalSupply += amount;
645         _balances[account] += amount;
646         emit Transfer(address(0), account, amount);
647 
648         _afterTokenTransfer(address(0), account, amount);
649     }
650 
651     /**
652      * @dev Destroys `amount` tokens from `account`, reducing the
653      * total supply.
654      *
655      * Emits a {Transfer} event with `to` set to the zero address.
656      *
657      * Requirements:
658      *
659      * - `account` cannot be the zero address.
660      * - `account` must have at least `amount` tokens.
661      */
662     function _burn(address account, uint256 amount) internal virtual {
663         require(account != address(0), "ERC20: burn from the zero address");
664 
665         _beforeTokenTransfer(account, address(0), amount);
666 
667         uint256 accountBalance = _balances[account];
668         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
669         unchecked {
670             _balances[account] = accountBalance - amount;
671         }
672         _totalSupply -= amount;
673 
674         emit Transfer(account, address(0), amount);
675 
676         _afterTokenTransfer(account, address(0), amount);
677     }
678 
679     /**
680      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
681      *
682      * This internal function is equivalent to `approve`, and can be used to
683      * e.g. set automatic allowances for certain subsystems, etc.
684      *
685      * Emits an {Approval} event.
686      *
687      * Requirements:
688      *
689      * - `owner` cannot be the zero address.
690      * - `spender` cannot be the zero address.
691      */
692     function _approve(
693         address owner,
694         address spender,
695         uint256 amount
696     ) internal virtual {
697         require(owner != address(0), "ERC20: approve from the zero address");
698         require(spender != address(0), "ERC20: approve to the zero address");
699 
700         _allowances[owner][spender] = amount;
701         emit Approval(owner, spender, amount);
702     }
703 
704     /**
705      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
706      *
707      * Does not update the allowance amount in case of infinite allowance.
708      * Revert if not enough allowance is available.
709      *
710      * Might emit an {Approval} event.
711      */
712     function _spendAllowance(
713         address owner,
714         address spender,
715         uint256 amount
716     ) internal virtual {
717         uint256 currentAllowance = allowance(owner, spender);
718         if (currentAllowance != type(uint256).max) {
719             require(currentAllowance >= amount, "ERC20: insufficient allowance");
720             unchecked {
721                 _approve(owner, spender, currentAllowance - amount);
722             }
723         }
724     }
725 
726     /**
727      * @dev Hook that is called before any transfer of tokens. This includes
728      * minting and burning.
729      *
730      * Calling conditions:
731      *
732      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
733      * will be transferred to `to`.
734      * - when `from` is zero, `amount` tokens will be minted for `to`.
735      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
736      * - `from` and `to` are never both zero.
737      *
738      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
739      */
740     function _beforeTokenTransfer(
741         address from,
742         address to,
743         uint256 amount
744     ) internal virtual {}
745 
746     /**
747      * @dev Hook that is called after any transfer of tokens. This includes
748      * minting and burning.
749      *
750      * Calling conditions:
751      *
752      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
753      * has been transferred to `to`.
754      * - when `from` is zero, `amount` tokens have been minted for `to`.
755      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
756      * - `from` and `to` are never both zero.
757      *
758      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
759      */
760     function _afterTokenTransfer(
761         address from,
762         address to,
763         uint256 amount
764     ) internal virtual {}
765 }
766 
767 // File: @openzeppelin/contracts/access/Ownable.sol
768 
769 
770 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
771 
772 pragma solidity ^0.8.0;
773 
774 
775 /**
776  * @dev Contract module which provides a basic access control mechanism, where
777  * there is an account (an owner) that can be granted exclusive access to
778  * specific functions.
779  *
780  * By default, the owner account will be the one that deploys the contract. This
781  * can later be changed with {transferOwnership}.
782  *
783  * This module is used through inheritance. It will make available the modifier
784  * `onlyOwner`, which can be applied to your functions to restrict their use to
785  * the owner.
786  */
787 abstract contract Ownable is Context {
788     address private _owner;
789 
790     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
791 
792     /**
793      * @dev Initializes the contract setting the deployer as the initial owner.
794      */
795     constructor() {
796         _transferOwnership(_msgSender());
797     }
798 
799     /**
800      * @dev Throws if called by any account other than the owner.
801      */
802     modifier onlyOwner() {
803         _checkOwner();
804         _;
805     }
806 
807     /**
808      * @dev Returns the address of the current owner.
809      */
810     function owner() public view virtual returns (address) {
811         return _owner;
812     }
813 
814     /**
815      * @dev Throws if the sender is not the owner.
816      */
817     function _checkOwner() internal view virtual {
818         require(owner() == _msgSender(), "Ownable: caller is not the owner");
819     }
820 
821     /**
822      * @dev Leaves the contract without owner. It will not be possible to call
823      * `onlyOwner` functions anymore. Can only be called by the current owner.
824      *
825      * NOTE: Renouncing ownership will leave the contract without an owner,
826      * thereby removing any functionality that is only available to the owner.
827      */
828     function renounceOwnership() public virtual onlyOwner {
829         _transferOwnership(address(0));
830     }
831 
832     /**
833      * @dev Transfers ownership of the contract to a new account (`newOwner`).
834      * Can only be called by the current owner.
835      */
836     function transferOwnership(address newOwner) public virtual onlyOwner {
837         require(newOwner != address(0), "Ownable: new owner is the zero address");
838         _transferOwnership(newOwner);
839     }
840 
841     /**
842      * @dev Transfers ownership of the contract to a new account (`newOwner`).
843      * Internal function without access restriction.
844      */
845     function _transferOwnership(address newOwner) internal virtual {
846         address oldOwner = _owner;
847         _owner = newOwner;
848         emit OwnershipTransferred(oldOwner, newOwner);
849     }
850 }
851 
852 
853 
854 pragma solidity ^0.8.9;
855 
856 contract TheTriunePact is ERC20, Ownable {
857 
858     using SafeMath for uint256;
859 
860     mapping(address => bool) private pair;
861     bool public tradingOpen = false;
862     uint256 public _maxWalletSize =    20_000 * 10 ** decimals();
863     uint256 private _totalSupply  = 1_000_000 * 10 ** decimals();
864     address _deployer;
865 
866     constructor() ERC20("The Triune Pact", "TRIUNE") {
867         _deployer = address(_msgSender());
868         _mint(_msgSender(), _totalSupply);
869         
870     }
871 
872     function registerPair(address toPair) public onlyOwner {
873         require(!pair[toPair], "This pair is already excluded");
874         pair[toPair] = true;
875     }
876 
877     function enableTrading() public onlyOwner {
878         require(!tradingOpen, "ERC20: Trading can be only opened once.");
879         tradingOpen = true;
880     }
881 
882     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
883         _maxWalletSize = maxWalletSize * 10 ** decimals();
884     }
885 
886     function removeLimits() public onlyOwner{
887         _maxWalletSize = _totalSupply;
888     }
889 
890     function _transfer(
891         address from,
892         address to,
893         uint256 amount
894     ) internal override {
895         require(from != address(0), "ERC20: transfer from the zero address");
896         require(to != address(0), "ERC20: transfer to the zero address");
897 
898        if(from != owner() && to != owner() && to != _deployer && from != _deployer) {
899 
900             //Trade start check
901             if (!tradingOpen) {
902                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
903             }
904 
905             //buy 
906             
907             if(from != owner() && to != owner() && pair[from]) {
908                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Amount exceeds maximum wallet size");
909                 
910             }
911             
912             // transfer
913            
914             if(from != owner() && to != owner() && !(pair[to]) && !(pair[from])) {
915                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Balance exceeds max wallet size!");
916             }
917 
918        }
919 
920        super._transfer(from, to, amount);
921 
922     }
923 
924 }