1 /**
2 Optigirl
3 
4 Everyone please welcome Optigirl  to the family!
5 
6 She's a little fiesty and might bite, so watch out!
7 
8 https://twitter.com/OptimusAI_Token/status/1628529785701015553
9 
10 https://twitter.com/OptimusAI_Token/status/1628972922026053633
11 
12 
13 
14 
15 TG: https://t.me/optigirl
16 
17 TWITTER: https://twitter.com/OPTIGIRLTOKEN
18 
19 
20 
21 */
22 
23 
24 // SPDX-License-Identifier: MIT
25 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
26 pragma experimental ABIEncoderV2;
27 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
28 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
29 /* pragma solidity ^0.8.0; */
30 
31 
32 /**
33  * @dev Provides information about the current execution context, including the
34  * sender of the transaction and its data. While these are generally available
35  * via msg.sender and msg.data, they should not be accessed in such a direct
36  * manner, since when dealing with meta-transactions the account sending and
37  * paying for execution may not be the actual sender (as far as an application
38  * is concerned).
39  *
40  * This contract is only required for intermediate, library-like contracts.
41  */
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address) {
44         return msg.sender;
45     }
46 
47     function _msgData() internal view virtual returns (bytes calldata) {
48         return msg.data;
49     }
50 }
51 
52 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
53 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
54 
55 /* pragma solidity ^0.8.0; */
56 
57 /* import "../utils/Context.sol"; */
58 
59 /**
60  * @dev Contract module which provides a basic access control mechanism, where
61  * there is an account (an owner) that can be granted exclusive access to
62  * specific functions.
63  *
64  * By default, the owner account will be the one that deploys the contract. This
65  * can later be changed with {transferOwnership}.
66  *
67  * This module is used through inheritance. It will make available the modifier
68  * `onlyOwner`, which can be applied to your functions to restrict their use to
69  * the owner.
70  */
71 abstract contract Ownable is Context {
72     address private _owner;
73 
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     /**
77      * @dev Initializes the contract setting the deployer as the initial owner.
78      */
79     constructor() {
80         _transferOwnership(_msgSender());
81     }
82 
83     /**
84      * @dev Returns the address of the current owner.
85      */
86     function owner() public view virtual returns (address) {
87         return _owner;
88     }
89 
90     /**
91      * @dev Throws if called by any account other than the owner.
92      */
93     modifier onlyOwner() {
94         require(owner() == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     /**
99      * @dev Leaves the contract without owner. It will not be possible to call
100      * `onlyOwner` functions anymore. Can only be called by the current owner.
101      *
102      * NOTE: Renouncing ownership will leave the contract without an owner,
103      * thereby removing any functionality that is only available to the owner.
104      */
105     function renounceOwnership() public virtual onlyOwner {
106         _transferOwnership(address(0));
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Can only be called by the current owner.
112      */
113     function transferOwnership(address newOwner) public virtual onlyOwner {
114         require(newOwner != address(0), "Ownable: new owner is the zero address");
115         _transferOwnership(newOwner);
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Internal function without access restriction.
121      */
122     function _transferOwnership(address newOwner) internal virtual {
123         address oldOwner = _owner;
124         _owner = newOwner;
125         emit OwnershipTransferred(oldOwner, newOwner);
126     }
127 }
128 
129 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
130 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
131 
132 /* pragma solidity ^0.8.0; */
133 
134 /**
135  * @dev Interface of the ERC20 standard as defined in the EIP.
136  */
137 interface IERC20 {
138     /**
139      * @dev Returns the amount of tokens in existence.
140      */
141     function totalSupply() external view returns (uint256);
142 
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148     /**
149      * @dev Moves `amount` tokens from the caller's account to `recipient`.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transfer(address recipient, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
160      * zero by default.
161      *
162      * This value changes when {approve} or {transferFrom} are called.
163      */
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     /**
167      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * IMPORTANT: Beware that changing an allowance with this method brings the risk
172      * that someone may use both the old and the new allowance by unfortunate
173      * transaction ordering. One possible solution to mitigate this race
174      * condition is to first reduce the spender's allowance to 0 and set the
175      * desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address spender, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Moves `amount` tokens from `sender` to `recipient` using the
184      * allowance mechanism. `amount` is then deducted from the caller's
185      * allowance.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(
192         address sender,
193         address recipient,
194         uint256 amount
195     ) external returns (bool);
196 
197     /**
198      * @dev Emitted when `value` tokens are moved from one account (`from`) to
199      * another (`to`).
200      *
201      * Note that `value` may be zero.
202      */
203     event Transfer(address indexed from, address indexed to, uint256 value);
204 
205     /**
206      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
207      * a call to {approve}. `value` is the new allowance.
208      */
209     event Approval(address indexed owner, address indexed spender, uint256 value);
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
241 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
242 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
243 
244 /* pragma solidity ^0.8.0; */
245 
246 /* import "./IERC20.sol"; */
247 /* import "./extensions/IERC20Metadata.sol"; */
248 /* import "../../utils/Context.sol"; */
249 
250 /**
251  * @dev Implementation of the {IERC20} interface.
252  *
253  * This implementation is agnostic to the way tokens are created. This means
254  * that a supply mechanism has to be added in a derived contract using {_mint}.
255  * For a generic mechanism see {ERC20PresetMinterPauser}.
256  *
257  * TIP: For a detailed writeup see our guide
258  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
259  * to implement supply mechanisms].
260  *
261  * We have followed general OpenZeppelin Contracts guidelines: functions revert
262  * instead returning `false` on failure. This behavior is nonetheless
263  * conventional and does not conflict with the expectations of ERC20
264  * applications.
265  *
266  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
267  * This allows applications to reconstruct the allowance for all accounts just
268  * by listening to said events. Other implementations of the EIP may not emit
269  * these events, as it isn't required by the specification.
270  *
271  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
272  * functions have been added to mitigate the well-known issues around setting
273  * allowances. See {IERC20-approve}.
274  */
275 contract ERC20 is Context, IERC20, IERC20Metadata {
276     mapping(address => uint256) private _balances;
277 
278     mapping(address => mapping(address => uint256)) private _allowances;
279 
280     uint256 private _totalSupply;
281 
282     string private _name;
283     string private _symbol;
284 
285     /**
286      * @dev Sets the values for {name} and {symbol}.
287      *
288      * The default value of {decimals} is 18. To select a different value for
289      * {decimals} you should overload it.
290      *
291      * All two of these values are immutable: they can only be set once during
292      * construction.
293      */
294     constructor(string memory name_, string memory symbol_) {
295         _name = name_;
296         _symbol = symbol_;
297     }
298 
299     /**
300      * @dev Returns the name of the token.
301      */
302     function name() public view virtual override returns (string memory) {
303         return _name;
304     }
305 
306     /**
307      * @dev Returns the symbol of the token, usually a shorter version of the
308      * name.
309      */
310     function symbol() public view virtual override returns (string memory) {
311         return _symbol;
312     }
313 
314     /**
315      * @dev Returns the number of decimals used to get its user representation.
316      * For example, if `decimals` equals `2`, a balance of `505` tokens should
317      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
318      *
319      * Tokens usually opt for a value of 18, imitating the relationship between
320      * Ether and Wei. This is the value {ERC20} uses, unless this function is
321      * overridden;
322      *
323      * NOTE: This information is only used for _display_ purposes: it in
324      * no way affects any of the arithmetic of the contract, including
325      * {IERC20-balanceOf} and {IERC20-transfer}.
326      */
327     function decimals() public view virtual override returns (uint8) {
328         return 18;
329     }
330 
331     /**
332      * @dev See {IERC20-totalSupply}.
333      */
334     function totalSupply() public view virtual override returns (uint256) {
335         return _totalSupply;
336     }
337 
338     /**
339      * @dev See {IERC20-balanceOf}.
340      */
341     function balanceOf(address account) public view virtual override returns (uint256) {
342         return _balances[account];
343     }
344 
345     /**
346      * @dev See {IERC20-transfer}.
347      *
348      * Requirements:
349      *
350      * - `recipient` cannot be the zero address.
351      * - the caller must have a balance of at least `amount`.
352      */
353     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
354         _transfer(_msgSender(), recipient, amount);
355         return true;
356     }
357 
358     /**
359      * @dev See {IERC20-allowance}.
360      */
361     function allowance(address owner, address spender) public view virtual override returns (uint256) {
362         return _allowances[owner][spender];
363     }
364 
365     /**
366      * @dev See {IERC20-approve}.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      */
372     function approve(address spender, uint256 amount) public virtual override returns (bool) {
373         _approve(_msgSender(), spender, amount);
374         return true;
375     }
376 
377     /**
378      * @dev See {IERC20-transferFrom}.
379      *
380      * Emits an {Approval} event indicating the updated allowance. This is not
381      * required by the EIP. See the note at the beginning of {ERC20}.
382      *
383      * Requirements:
384      *
385      * - `sender` and `recipient` cannot be the zero address.
386      * - `sender` must have a balance of at least `amount`.
387      * - the caller must have allowance for ``sender``'s tokens of at least
388      * `amount`.
389      */
390     function transferFrom(
391         address sender,
392         address recipient,
393         uint256 amount
394     ) public virtual override returns (bool) {
395         _transfer(sender, recipient, amount);
396 
397         uint256 currentAllowance = _allowances[sender][_msgSender()];
398         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
399         unchecked {
400             _approve(sender, _msgSender(), currentAllowance - amount);
401         }
402 
403         return true;
404     }
405 
406     /**
407      * @dev Atomically increases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      */
418     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
419         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
420         return true;
421     }
422 
423     /**
424      * @dev Atomically decreases the allowance granted to `spender` by the caller.
425      *
426      * This is an alternative to {approve} that can be used as a mitigation for
427      * problems described in {IERC20-approve}.
428      *
429      * Emits an {Approval} event indicating the updated allowance.
430      *
431      * Requirements:
432      *
433      * - `spender` cannot be the zero address.
434      * - `spender` must have allowance for the caller of at least
435      * `subtractedValue`.
436      */
437     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
438         uint256 currentAllowance = _allowances[_msgSender()][spender];
439         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
440         unchecked {
441             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
442         }
443 
444         return true;
445     }
446 
447     /**
448      * @dev Moves `amount` of tokens from `sender` to `recipient`.
449      *
450      * This internal function is equivalent to {transfer}, and can be used to
451      * e.g. implement automatic token fees, slashing mechanisms, etc.
452      *
453      * Emits a {Transfer} event.
454      *
455      * Requirements:
456      *
457      * - `sender` cannot be the zero address.
458      * - `recipient` cannot be the zero address.
459      * - `sender` must have a balance of at least `amount`.
460      */
461     function _transfer(
462         address sender,
463         address recipient,
464         uint256 amount
465     ) internal virtual {
466         require(sender != address(0), "ERC20: transfer from the zero address");
467         require(recipient != address(0), "ERC20: transfer to the zero address");
468 
469         _beforeTokenTransfer(sender, recipient, amount);
470 
471         uint256 senderBalance = _balances[sender];
472         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
473         unchecked {
474             _balances[sender] = senderBalance - amount;
475         }
476         _balances[recipient] += amount;
477 
478         emit Transfer(sender, recipient, amount);
479 
480         _afterTokenTransfer(sender, recipient, amount);
481     }
482 
483     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
484      * the total supply.
485      *
486      * Emits a {Transfer} event with `from` set to the zero address.
487      *
488      * Requirements:
489      *
490      * - `account` cannot be the zero address.
491      */
492     function _mint(address account, uint256 amount) internal virtual {
493         require(account != address(0), "ERC20: mint to the zero address");
494 
495         _beforeTokenTransfer(address(0), account, amount);
496 
497         _totalSupply += amount;
498         _balances[account] += amount;
499         emit Transfer(address(0), account, amount);
500 
501         _afterTokenTransfer(address(0), account, amount);
502     }
503 
504     /**
505      * @dev Destroys `amount` tokens from `account`, reducing the
506      * total supply.
507      *
508      * Emits a {Transfer} event with `to` set to the zero address.
509      *
510      * Requirements:
511      *
512      * - `account` cannot be the zero address.
513      * - `account` must have at least `amount` tokens.
514      */
515     function _burn(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: burn from the zero address");
517 
518         _beforeTokenTransfer(account, address(0), amount);
519 
520         uint256 accountBalance = _balances[account];
521         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
522         unchecked {
523             _balances[account] = accountBalance - amount;
524         }
525         _totalSupply -= amount;
526 
527         emit Transfer(account, address(0), amount);
528 
529         _afterTokenTransfer(account, address(0), amount);
530     }
531 
532     /**
533      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
534      *
535      * This internal function is equivalent to `approve`, and can be used to
536      * e.g. set automatic allowances for certain subsystems, etc.
537      *
538      * Emits an {Approval} event.
539      *
540      * Requirements:
541      *
542      * - `owner` cannot be the zero address.
543      * - `spender` cannot be the zero address.
544      */
545     function _approve(
546         address owner,
547         address spender,
548         uint256 amount
549     ) internal virtual {
550         require(owner != address(0), "ERC20: approve from the zero address");
551         require(spender != address(0), "ERC20: approve to the zero address");
552 
553         _allowances[owner][spender] = amount;
554         emit Approval(owner, spender, amount);
555     }
556 
557     /**
558      * @dev Hook that is called before any transfer of tokens. This includes
559      * minting and burning.
560      *
561      * Calling conditions:
562      *
563      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
564      * will be transferred to `to`.
565      * - when `from` is zero, `amount` tokens will be minted for `to`.
566      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
567      * - `from` and `to` are never both zero.
568      *
569      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
570      */
571     function _beforeTokenTransfer(
572         address from,
573         address to,
574         uint256 amount
575     ) internal virtual {}
576 
577     /**
578      * @dev Hook that is called after any transfer of tokens. This includes
579      * minting and burning.
580      *
581      * Calling conditions:
582      *
583      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
584      * has been transferred to `to`.
585      * - when `from` is zero, `amount` tokens have been minted for `to`.
586      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
587      * - `from` and `to` are never both zero.
588      *
589      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
590      */
591     function _afterTokenTransfer(
592         address from,
593         address to,
594         uint256 amount
595     ) internal virtual {}
596 }
597 
598 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
599 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
600 
601 /* pragma solidity ^0.8.0; */
602 
603 // CAUTION
604 // This version of SafeMath should only be used with Solidity 0.8 or later,
605 // because it relies on the compiler's built in overflow checks.
606 
607 /**
608  * @dev Wrappers over Solidity's arithmetic operations.
609  *
610  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
611  * now has built in overflow checking.
612  */
613 library SafeMath {
614     /**
615      * @dev Returns the addition of two unsigned integers, with an overflow flag.
616      *
617      * _Available since v3.4._
618      */
619     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             uint256 c = a + b;
622             if (c < a) return (false, 0);
623             return (true, c);
624         }
625     }
626 
627     /**
628      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
629      *
630      * _Available since v3.4._
631      */
632     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
633         unchecked {
634             if (b > a) return (false, 0);
635             return (true, a - b);
636         }
637     }
638 
639     /**
640      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
641      *
642      * _Available since v3.4._
643      */
644     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
645         unchecked {
646             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
647             // benefit is lost if 'b' is also tested.
648             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
649             if (a == 0) return (true, 0);
650             uint256 c = a * b;
651             if (c / a != b) return (false, 0);
652             return (true, c);
653         }
654     }
655 
656     /**
657      * @dev Returns the division of two unsigned integers, with a division by zero flag.
658      *
659      * _Available since v3.4._
660      */
661     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
662         unchecked {
663             if (b == 0) return (false, 0);
664             return (true, a / b);
665         }
666     }
667 
668     /**
669      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
670      *
671      * _Available since v3.4._
672      */
673     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
674         unchecked {
675             if (b == 0) return (false, 0);
676             return (true, a % b);
677         }
678     }
679 
680     /**
681      * @dev Returns the addition of two unsigned integers, reverting on
682      * overflow.
683      *
684      * Counterpart to Solidity's `+` operator.
685      *
686      * Requirements:
687      *
688      * - Addition cannot overflow.
689      */
690     function add(uint256 a, uint256 b) internal pure returns (uint256) {
691         return a + b;
692     }
693 
694     /**
695      * @dev Returns the subtraction of two unsigned integers, reverting on
696      * overflow (when the result is negative).
697      *
698      * Counterpart to Solidity's `-` operator.
699      *
700      * Requirements:
701      *
702      * - Subtraction cannot overflow.
703      */
704     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
705         return a - b;
706     }
707 
708     /**
709      * @dev Returns the multiplication of two unsigned integers, reverting on
710      * overflow.
711      *
712      * Counterpart to Solidity's `*` operator.
713      *
714      * Requirements:
715      *
716      * - Multiplication cannot overflow.
717      */
718     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
719         return a * b;
720     }
721 
722     /**
723      * @dev Returns the integer division of two unsigned integers, reverting on
724      * division by zero. The result is rounded towards zero.
725      *
726      * Counterpart to Solidity's `/` operator.
727      *
728      * Requirements:
729      *
730      * - The divisor cannot be zero.
731      */
732     function div(uint256 a, uint256 b) internal pure returns (uint256) {
733         return a / b;
734     }
735 
736     /**
737      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
738      * reverting when dividing by zero.
739      *
740      * Counterpart to Solidity's `%` operator. This function uses a `revert`
741      * opcode (which leaves remaining gas untouched) while Solidity uses an
742      * invalid opcode to revert (consuming all remaining gas).
743      *
744      * Requirements:
745      *
746      * - The divisor cannot be zero.
747      */
748     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
749         return a % b;
750     }
751 
752     /**
753      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
754      * overflow (when the result is negative).
755      *
756      * CAUTION: This function is deprecated because it requires allocating memory for the error
757      * message unnecessarily. For custom revert reasons use {trySub}.
758      *
759      * Counterpart to Solidity's `-` operator.
760      *
761      * Requirements:
762      *
763      * - Subtraction cannot overflow.
764      */
765     function sub(
766         uint256 a,
767         uint256 b,
768         string memory errorMessage
769     ) internal pure returns (uint256) {
770         unchecked {
771             require(b <= a, errorMessage);
772             return a - b;
773         }
774     }
775 
776     /**
777      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
778      * division by zero. The result is rounded towards zero.
779      *
780      * Counterpart to Solidity's `/` operator. Note: this function uses a
781      * `revert` opcode (which leaves remaining gas untouched) while Solidity
782      * uses an invalid opcode to revert (consuming all remaining gas).
783      *
784      * Requirements:
785      *
786      * - The divisor cannot be zero.
787      */
788     function div(
789         uint256 a,
790         uint256 b,
791         string memory errorMessage
792     ) internal pure returns (uint256) {
793         unchecked {
794             require(b > 0, errorMessage);
795             return a / b;
796         }
797     }
798 
799     /**
800      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
801      * reverting with custom message when dividing by zero.
802      *
803      * CAUTION: This function is deprecated because it requires allocating memory for the error
804      * message unnecessarily. For custom revert reasons use {tryMod}.
805      *
806      * Counterpart to Solidity's `%` operator. This function uses a `revert`
807      * opcode (which leaves remaining gas untouched) while Solidity uses an
808      * invalid opcode to revert (consuming all remaining gas).
809      *
810      * Requirements:
811      *
812      * - The divisor cannot be zero.
813      */
814     function mod(
815         uint256 a,
816         uint256 b,
817         string memory errorMessage
818     ) internal pure returns (uint256) {
819         unchecked {
820             require(b > 0, errorMessage);
821             return a % b;
822         }
823     }
824 }
825 
826 /* pragma solidity 0.8.10; */
827 /* pragma experimental ABIEncoderV2; */
828 
829 interface IUniswapV2Factory {
830     event PairCreated(
831         address indexed token0,
832         address indexed token1,
833         address pair,
834         uint256
835     );
836 
837     function feeTo() external view returns (address);
838 
839     function feeToSetter() external view returns (address);
840 
841     function getPair(address tokenA, address tokenB)
842         external
843         view
844         returns (address pair);
845 
846     function allPairs(uint256) external view returns (address pair);
847 
848     function allPairsLength() external view returns (uint256);
849 
850     function createPair(address tokenA, address tokenB)
851         external
852         returns (address pair);
853 
854     function setFeeTo(address) external;
855 
856     function setFeeToSetter(address) external;
857 }
858 
859 /* pragma solidity 0.8.10; */
860 /* pragma experimental ABIEncoderV2; */ 
861 
862 interface IUniswapV2Pair {
863     event Approval(
864         address indexed owner,
865         address indexed spender,
866         uint256 value
867     );
868     event Transfer(address indexed from, address indexed to, uint256 value);
869 
870     function name() external pure returns (string memory);
871 
872     function symbol() external pure returns (string memory);
873 
874     function decimals() external pure returns (uint8);
875 
876     function totalSupply() external view returns (uint256);
877 
878     function balanceOf(address owner) external view returns (uint256);
879 
880     function allowance(address owner, address spender)
881         external
882         view
883         returns (uint256);
884 
885     function approve(address spender, uint256 value) external returns (bool);
886 
887     function transfer(address to, uint256 value) external returns (bool);
888 
889     function transferFrom(
890         address from,
891         address to,
892         uint256 value
893     ) external returns (bool);
894 
895     function DOMAIN_SEPARATOR() external view returns (bytes32);
896 
897     function PERMIT_TYPEHASH() external pure returns (bytes32);
898 
899     function nonces(address owner) external view returns (uint256);
900 
901     function permit(
902         address owner,
903         address spender,
904         uint256 value,
905         uint256 deadline,
906         uint8 v,
907         bytes32 r,
908         bytes32 s
909     ) external;
910 
911     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
912     event Burn(
913         address indexed sender,
914         uint256 amount0,
915         uint256 amount1,
916         address indexed to
917     );
918     event Swap(
919         address indexed sender,
920         uint256 amount0In,
921         uint256 amount1In,
922         uint256 amount0Out,
923         uint256 amount1Out,
924         address indexed to
925     );
926     event Sync(uint112 reserve0, uint112 reserve1);
927 
928     function MINIMUM_LIQUIDITY() external pure returns (uint256);
929 
930     function factory() external view returns (address);
931 
932     function token0() external view returns (address);
933 
934     function token1() external view returns (address);
935 
936     function getReserves()
937         external
938         view
939         returns (
940             uint112 reserve0,
941             uint112 reserve1,
942             uint32 blockTimestampLast
943         );
944 
945     function price0CumulativeLast() external view returns (uint256);
946 
947     function price1CumulativeLast() external view returns (uint256);
948 
949     function kLast() external view returns (uint256);
950 
951     function mint(address to) external returns (uint256 liquidity);
952 
953     function burn(address to)
954         external
955         returns (uint256 amount0, uint256 amount1);
956 
957     function swap(
958         uint256 amount0Out,
959         uint256 amount1Out,
960         address to,
961         bytes calldata data
962     ) external;
963 
964     function skim(address to) external;
965 
966     function sync() external;
967 
968     function initialize(address, address) external;
969 }
970 
971 /* pragma solidity 0.8.10; */
972 /* pragma experimental ABIEncoderV2; */
973 
974 interface IUniswapV2Router02 {
975     function factory() external pure returns (address);
976 
977     function WETH() external pure returns (address);
978 
979     function addLiquidity(
980         address tokenA,
981         address tokenB,
982         uint256 amountADesired,
983         uint256 amountBDesired,
984         uint256 amountAMin,
985         uint256 amountBMin,
986         address to,
987         uint256 deadline
988     )
989         external
990         returns (
991             uint256 amountA,
992             uint256 amountB,
993             uint256 liquidity
994         );
995 
996     function addLiquidityETH(
997         address token,
998         uint256 amountTokenDesired,
999         uint256 amountTokenMin,
1000         uint256 amountETHMin,
1001         address to,
1002         uint256 deadline
1003     )
1004         external
1005         payable
1006         returns (
1007             uint256 amountToken,
1008             uint256 amountETH,
1009             uint256 liquidity
1010         );
1011 
1012     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1013         uint256 amountIn,
1014         uint256 amountOutMin,
1015         address[] calldata path,
1016         address to,
1017         uint256 deadline
1018     ) external;
1019 
1020     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1021         uint256 amountOutMin,
1022         address[] calldata path,
1023         address to,
1024         uint256 deadline
1025     ) external payable;
1026 
1027     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1028         uint256 amountIn,
1029         uint256 amountOutMin,
1030         address[] calldata path,
1031         address to,
1032         uint256 deadline
1033     ) external;
1034 }
1035 
1036 /* pragma solidity >=0.8.10; */
1037 
1038 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1039 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1040 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1041 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1042 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1043 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1044 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1045 
1046 contract Optigirl is ERC20, Ownable {
1047     using SafeMath for uint256;
1048 
1049     IUniswapV2Router02 public immutable uniswapV2Router;
1050     address public immutable uniswapV2Pair;
1051     address public constant deadAddress = address(0xdead);
1052 
1053     bool private swapping;
1054 
1055 	address public charityWallet;
1056     address public marketingWallet;
1057     address public devWallet;
1058 
1059     uint256 public maxTransactionAmount;
1060     uint256 public swapTokensAtAmount;
1061     uint256 public maxWallet;
1062 
1063     bool public limitsInEffect = true;
1064     bool public tradingActive = true;
1065     bool public swapEnabled = true;
1066 
1067     // Anti-bot and anti-whale mappings and variables
1068     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1069     bool public transferDelayEnabled = true;
1070 
1071     uint256 public buyTotalFees;
1072 	uint256 public buyCharityFee;
1073     uint256 public buyMarketingFee;
1074     uint256 public buyLiquidityFee;
1075     uint256 public buyDevFee;
1076 
1077     uint256 public sellTotalFees;
1078 	uint256 public sellCharityFee;
1079     uint256 public sellMarketingFee;
1080     uint256 public sellLiquidityFee;
1081     uint256 public sellDevFee;
1082 
1083 	uint256 public tokensForCharity;
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
1107     event SwapAndLiquify(
1108         uint256 tokensSwapped,
1109         uint256 ethReceived,
1110         uint256 tokensIntoLiquidity
1111     );
1112 
1113     constructor() ERC20("Optigirl ", "OPTIGIRL") {
1114         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1115             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1116         );
1117 
1118         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1119         uniswapV2Router = _uniswapV2Router;
1120 
1121         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1122             .createPair(address(this), _uniswapV2Router.WETH());
1123         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1124         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1125 
1126 		uint256 _buyCharityFee = 0;
1127         uint256 _buyMarketingFee = 12;
1128         uint256 _buyLiquidityFee = 0;
1129         uint256 _buyDevFee = 13;
1130 
1131 		uint256 _sellCharityFee = 0;
1132         uint256 _sellMarketingFee = 12;
1133         uint256 _sellLiquidityFee = 0;
1134         uint256 _sellDevFee = 13;
1135 
1136         uint256 totalSupply = 100000000 * 1e18;
1137 
1138         maxTransactionAmount = 1000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1139         maxWallet = 2000000 * 1e18; // 2% from total supply maxWallet
1140         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1141 
1142 		buyCharityFee = _buyCharityFee;
1143         buyMarketingFee = _buyMarketingFee;
1144         buyLiquidityFee = _buyLiquidityFee;
1145         buyDevFee = _buyDevFee;
1146         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1147 
1148 		sellCharityFee = _sellCharityFee;
1149         sellMarketingFee = _sellMarketingFee;
1150         sellLiquidityFee = _sellLiquidityFee;
1151         sellDevFee = _sellDevFee;
1152         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1153 
1154 		charityWallet = address(0x8Fdc8d35c32a0B122Dd5D22feB3167C833b99D2f); // set as charity wallet
1155         marketingWallet = address(0xF4Ac42f3527081D003C1d03883893c9972a43F1D); // set as marketing wallet
1156         devWallet = address(0x79265363295B0df0FB80d2DDD124f5c6e1d26C65); // set as dev wallet
1157 
1158         // exclude from paying fees or having max transaction amount
1159         excludeFromFees(owner(), true);
1160         excludeFromFees(address(this), true);
1161         excludeFromFees(address(0xdead), true);
1162 
1163         excludeFromMaxTransaction(owner(), true);
1164         excludeFromMaxTransaction(address(this), true);
1165         excludeFromMaxTransaction(address(0xdead), true);
1166 
1167         /*
1168             _mint is an internal function in ERC20.sol that is only called here,
1169             and CANNOT be called ever again
1170         */
1171         _mint(msg.sender, totalSupply);
1172     }
1173 
1174     receive() external payable {}
1175 
1176     // once enabled, can never be turned off
1177     function enableTrading() external onlyOwner {
1178         tradingActive = true;
1179         swapEnabled = true;
1180     }
1181 
1182     // remove limits after token is stable
1183     function removeLimits() external onlyOwner returns (bool) {
1184         limitsInEffect = false;
1185         return true;
1186     }
1187 
1188     // disable Transfer delay - cannot be reenabled
1189     function disableTransferDelay() external onlyOwner returns (bool) {
1190         transferDelayEnabled = false;
1191         return true;
1192     }
1193 
1194     // change the minimum amount of tokens to sell from fees
1195     function updateSwapTokensAtAmount(uint256 newAmount)
1196         external
1197         onlyOwner
1198         returns (bool)
1199     {
1200         require(
1201             newAmount >= (totalSupply() * 1) / 100000,
1202             "Swap amount cannot be lower than 0.001% total supply."
1203         );
1204         require(
1205             newAmount <= (totalSupply() * 5) / 1000,
1206             "Swap amount cannot be higher than 0.5% total supply."
1207         );
1208         swapTokensAtAmount = newAmount;
1209         return true;
1210     }
1211 
1212     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1213         require(
1214             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1215             "Cannot set maxTransactionAmount lower than 0.5%"
1216         );
1217         maxTransactionAmount = newNum * (10**18);
1218     }
1219 
1220     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1221         require(
1222             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1223             "Cannot set maxWallet lower than 0.5%"
1224         );
1225         maxWallet = newNum * (10**18);
1226     }
1227 	
1228     function excludeFromMaxTransaction(address updAds, bool isEx)
1229         public
1230         onlyOwner
1231     {
1232         _isExcludedMaxTransactionAmount[updAds] = isEx;
1233     }
1234 
1235     // only use to disable contract sales if absolutely necessary (emergency use only)
1236     function updateSwapEnabled(bool enabled) external onlyOwner {
1237         swapEnabled = enabled;
1238     }
1239 
1240     function updateBuyFees(
1241 		uint256 _charityFee,
1242         uint256 _marketingFee,
1243         uint256 _liquidityFee,
1244         uint256 _devFee
1245     ) external onlyOwner {
1246 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1247 		buyCharityFee = _charityFee;
1248         buyMarketingFee = _marketingFee;
1249         buyLiquidityFee = _liquidityFee;
1250         buyDevFee = _devFee;
1251         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1252      }
1253 
1254     function updateSellFees(
1255 		uint256 _charityFee,
1256         uint256 _marketingFee,
1257         uint256 _liquidityFee,
1258         uint256 _devFee
1259     ) external onlyOwner {
1260 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1261 		sellCharityFee = _charityFee;
1262         sellMarketingFee = _marketingFee;
1263         sellLiquidityFee = _liquidityFee;
1264         sellDevFee = _devFee;
1265         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1266     }
1267 
1268     function excludeFromFees(address account, bool excluded) public onlyOwner {
1269         _isExcludedFromFees[account] = excluded;
1270         emit ExcludeFromFees(account, excluded);
1271     }
1272 
1273     function setAutomatedMarketMakerPair(address pair, bool value)
1274         public
1275         onlyOwner
1276     {
1277         require(
1278             pair != uniswapV2Pair,
1279             "The pair cannot be removed from automatedMarketMakerPairs"
1280         );
1281 
1282         _setAutomatedMarketMakerPair(pair, value);
1283     }
1284 
1285     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1286         automatedMarketMakerPairs[pair] = value;
1287 
1288         emit SetAutomatedMarketMakerPair(pair, value);
1289     }
1290 
1291     function isExcludedFromFees(address account) public view returns (bool) {
1292         return _isExcludedFromFees[account];
1293     }
1294 
1295     function _transfer(
1296         address from,
1297         address to,
1298         uint256 amount
1299     ) internal override {
1300         require(from != address(0), "ERC20: transfer from the zero address");
1301         require(to != address(0), "ERC20: transfer to the zero address");
1302 
1303         if (amount == 0) {
1304             super._transfer(from, to, 0);
1305             return;
1306         }
1307 
1308         if (limitsInEffect) {
1309             if (
1310                 from != owner() &&
1311                 to != owner() &&
1312                 to != address(0) &&
1313                 to != address(0xdead) &&
1314                 !swapping
1315             ) {
1316                 if (!tradingActive) {
1317                     require(
1318                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1319                         "Trading is not active."
1320                     );
1321                 }
1322 
1323                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1324                 if (transferDelayEnabled) {
1325                     if (
1326                         to != owner() &&
1327                         to != address(uniswapV2Router) &&
1328                         to != address(uniswapV2Pair)
1329                     ) {
1330                         require(
1331                             _holderLastTransferTimestamp[tx.origin] <
1332                                 block.number,
1333                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1334                         );
1335                         _holderLastTransferTimestamp[tx.origin] = block.number;
1336                     }
1337                 }
1338 
1339                 //when buy
1340                 if (
1341                     automatedMarketMakerPairs[from] &&
1342                     !_isExcludedMaxTransactionAmount[to]
1343                 ) {
1344                     require(
1345                         amount <= maxTransactionAmount,
1346                         "Buy transfer amount exceeds the maxTransactionAmount."
1347                     );
1348                     require(
1349                         amount + balanceOf(to) <= maxWallet,
1350                         "Max wallet exceeded"
1351                     );
1352                 }
1353                 //when sell
1354                 else if (
1355                     automatedMarketMakerPairs[to] &&
1356                     !_isExcludedMaxTransactionAmount[from]
1357                 ) {
1358                     require(
1359                         amount <= maxTransactionAmount,
1360                         "Sell transfer amount exceeds the maxTransactionAmount."
1361                     );
1362                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1363                     require(
1364                         amount + balanceOf(to) <= maxWallet,
1365                         "Max wallet exceeded"
1366                     );
1367                 }
1368             }
1369         }
1370 
1371         uint256 contractTokenBalance = balanceOf(address(this));
1372 
1373         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1374 
1375         if (
1376             canSwap &&
1377             swapEnabled &&
1378             !swapping &&
1379             !automatedMarketMakerPairs[from] &&
1380             !_isExcludedFromFees[from] &&
1381             !_isExcludedFromFees[to]
1382         ) {
1383             swapping = true;
1384 
1385             swapBack();
1386 
1387             swapping = false;
1388         }
1389 
1390         bool takeFee = !swapping;
1391 
1392         // if any account belongs to _isExcludedFromFee account then remove the fee
1393         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1394             takeFee = false;
1395         }
1396 
1397         uint256 fees = 0;
1398         // only take fees on buys/sells, do not take on wallet transfers
1399         if (takeFee) {
1400             // on sell
1401             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1402                 fees = amount.mul(sellTotalFees).div(100);
1403 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1404                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1405                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1406                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1407             }
1408             // on buy
1409             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1410                 fees = amount.mul(buyTotalFees).div(100);
1411 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1412                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1413                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1414                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1415             }
1416 
1417             if (fees > 0) {
1418                 super._transfer(from, address(this), fees);
1419             }
1420 
1421             amount -= fees;
1422         }
1423 
1424         super._transfer(from, to, amount);
1425     }
1426 
1427     function swapTokensForEth(uint256 tokenAmount) private {
1428         // generate the uniswap pair path of token -> weth
1429         address[] memory path = new address[](2);
1430         path[0] = address(this);
1431         path[1] = uniswapV2Router.WETH();
1432 
1433         _approve(address(this), address(uniswapV2Router), tokenAmount);
1434 
1435         // make the swap
1436         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1437             tokenAmount,
1438             0, // accept any amount of ETH
1439             path,
1440             address(this),
1441             block.timestamp
1442         );
1443     }
1444 
1445     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1446         // approve token transfer to cover all possible scenarios
1447         _approve(address(this), address(uniswapV2Router), tokenAmount);
1448 
1449         // add the liquidity
1450         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1451             address(this),
1452             tokenAmount,
1453             0, // slippage is unavoidable
1454             0, // slippage is unavoidable
1455             devWallet,
1456             block.timestamp
1457         );
1458     }
1459 
1460     function swapBack() private {
1461         uint256 contractBalance = balanceOf(address(this));
1462         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1463         bool success;
1464 
1465         if (contractBalance == 0 || totalTokensToSwap == 0) {
1466             return;
1467         }
1468 
1469         if (contractBalance > swapTokensAtAmount * 20) {
1470             contractBalance = swapTokensAtAmount * 20;
1471         }
1472 
1473         // Halve the amount of liquidity tokens
1474         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1475         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1476 
1477         uint256 initialETHBalance = address(this).balance;
1478 
1479         swapTokensForEth(amountToSwapForETH);
1480 
1481         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1482 
1483 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1484         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1485         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1486 
1487         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1488 
1489         tokensForLiquidity = 0;
1490 		tokensForCharity = 0;
1491         tokensForMarketing = 0;
1492         tokensForDev = 0;
1493 
1494         (success, ) = address(devWallet).call{value: ethForDev}("");
1495         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1496 
1497 
1498         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1499             addLiquidity(liquidityTokens, ethForLiquidity);
1500             emit SwapAndLiquify(
1501                 amountToSwapForETH,
1502                 ethForLiquidity,
1503                 tokensForLiquidity
1504             );
1505         }
1506 
1507         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1508     }
1509 
1510 }