1 /**
2  * SPDX-License-Identifier: MIT
3  */
4 pragma solidity >=0.8.16;
5 pragma experimental ABIEncoderV2;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
18 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
19 
20 /* pragma solidity ^0.8.0; */
21 
22 /* import "../utils/Context.sol"; */
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev Initializes the contract setting the deployer as the initial owner.
43      */
44     constructor() {
45         _transferOwnership(_msgSender());
46     }
47 
48     /**
49      * @dev Returns the address of the current owner.
50      */
51     function owner() public view virtual returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(owner() == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     /**
64      * @dev Leaves the contract without owner. It will not be possible to call
65      * `onlyOwner` functions anymore. Can only be called by the current owner.
66      *
67      * NOTE: Renouncing ownership will leave the contract without an owner,
68      * thereby removing any functionality that is only available to the owner.
69      */
70     function renounceOwnership() public virtual onlyOwner {
71         _transferOwnership(address(0));
72     }
73 
74     /**
75      * @dev Transfers ownership of the contract to a new account (`newOwner`).
76      * Can only be called by the current owner.
77      */
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         _transferOwnership(newOwner);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Internal function without access restriction.
86      */
87     function _transferOwnership(address newOwner) internal virtual {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
95 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
96 
97 /* pragma solidity ^0.8.0; */
98 
99 /**
100  * @dev Interface of the ERC20 standard as defined in the EIP.
101  */
102 interface IERC20 {
103     /**
104      * @dev Returns the amount of tokens in existence.
105      */
106     function totalSupply() external view returns (uint256);
107 
108     /**
109      * @dev Returns the amount of tokens owned by `account`.
110      */
111     function balanceOf(address account) external view returns (uint256);
112 
113     /**
114      * @dev Moves `amount` tokens from the caller's account to `recipient`.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transfer(address recipient, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Returns the remaining number of tokens that `spender` will be
124      * allowed to spend on behalf of `owner` through {transferFrom}. This is
125      * zero by default.
126      *
127      * This value changes when {approve} or {transferFrom} are called.
128      */
129     function allowance(address owner, address spender) external view returns (uint256);
130 
131     /**
132      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * IMPORTANT: Beware that changing an allowance with this method brings the risk
137      * that someone may use both the old and the new allowance by unfortunate
138      * transaction ordering. One possible solution to mitigate this race
139      * condition is to first reduce the spender's allowance to 0 and set the
140      * desired value afterwards:
141      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address spender, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Moves `amount` tokens from `sender` to `recipient` using the
149      * allowance mechanism. `amount` is then deducted from the caller's
150      * allowance.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transferFrom(
157         address sender,
158         address recipient,
159         uint256 amount
160     ) external returns (bool);
161 
162     /**
163      * @dev Emitted when `value` tokens are moved from one account (`from`) to
164      * another (`to`).
165      *
166      * Note that `value` may be zero.
167      */
168     event Transfer(address indexed from, address indexed to, uint256 value);
169 
170     /**
171      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
172      * a call to {approve}. `value` is the new allowance.
173      */
174     event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
178 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
179 
180 /* pragma solidity ^0.8.0; */
181 
182 /* import "../IERC20.sol"; */
183 
184 /**
185  * @dev Interface for the optional metadata functions from the ERC20 standard.
186  *
187  * _Available since v4.1._
188  */
189 interface IERC20Metadata is IERC20 {
190     /**
191      * @dev Returns the name of the token.
192      */
193     function name() external view returns (string memory);
194 
195     /**
196      * @dev Returns the symbol of the token.
197      */
198     function symbol() external view returns (string memory);
199 
200     /**
201      * @dev Returns the decimals places of the token.
202      */
203     function decimals() external view returns (uint8);
204 }
205 
206 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
207 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
208 
209 /* pragma solidity ^0.8.0; */
210 
211 /* import "./IERC20.sol"; */
212 /* import "./extensions/IERC20Metadata.sol"; */
213 /* import "../../utils/Context.sol"; */
214 
215 /**
216  * @dev Implementation of the {IERC20} interface.
217  *
218  * This implementation is agnostic to the way tokens are created. This means
219  * that a supply mechanism has to be added in a derived contract using {_mint}.
220  * For a generic mechanism see {ERC20PresetMinterPauser}.
221  *
222  * TIP: For a detailed writeup see our guide
223  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
224  * to implement supply mechanisms].
225  *
226  * We have followed general OpenZeppelin Contracts guidelines: functions revert
227  * instead returning `false` on failure. This behavior is nonetheless
228  * conventional and does not conflict with the expectations of ERC20
229  * applications.
230  *
231  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
232  * This allows applications to reconstruct the allowance for all accounts just
233  * by listening to said events. Other implementations of the EIP may not emit
234  * these events, as it isn't required by the specification.
235  *
236  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
237  * functions have been added to mitigate the well-known issues around setting
238  * allowances. See {IERC20-approve}.
239  */
240 contract ERC20 is Context, IERC20, IERC20Metadata {
241     mapping(address => uint256) private _balances;
242 
243     mapping(address => mapping(address => uint256)) private _allowances;
244 
245     uint256 private _totalSupply;
246 
247     string private _name;
248     string private _symbol;
249 
250     /**
251      * @dev Sets the values for {name} and {symbol}.
252      *
253      * The default value of {decimals} is 18. To select a different value for
254      * {decimals} you should overload it.
255      *
256      * All two of these values are immutable: they can only be set once during
257      * construction.
258      */
259     constructor(string memory name_, string memory symbol_) {
260         _name = name_;
261         _symbol = symbol_;
262     }
263 
264     /**
265      * @dev Returns the name of the token.
266      */
267     function name() public view virtual override returns (string memory) {
268         return _name;
269     }
270 
271     /**
272      * @dev Returns the symbol of the token, usually a shorter version of the
273      * name.
274      */
275     function symbol() public view virtual override returns (string memory) {
276         return _symbol;
277     }
278 
279     /**
280      * @dev Returns the number of decimals used to get its user representation.
281      * For example, if `decimals` equals `2`, a balance of `505` tokens should
282      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
283      *
284      * Tokens usually opt for a value of 18, imitating the relationship between
285      * Ether and Wei. This is the value {ERC20} uses, unless this function is
286      * overridden;
287      *
288      * NOTE: This information is only used for _display_ purposes: it in
289      * no way affects any of the arithmetic of the contract, including
290      * {IERC20-balanceOf} and {IERC20-transfer}.
291      */
292     function decimals() public view virtual override returns (uint8) {
293         return 18;
294     }
295 
296     /**
297      * @dev See {IERC20-totalSupply}.
298      */
299     function totalSupply() public view virtual override returns (uint256) {
300         return _totalSupply;
301     }
302 
303     /**
304      * @dev See {IERC20-balanceOf}.
305      */
306     function balanceOf(address account) public view virtual override returns (uint256) {
307         return _balances[account];
308     }
309 
310     /**
311      * @dev See {IERC20-transfer}.
312      *
313      * Requirements:
314      *
315      * - `recipient` cannot be the zero address.
316      * - the caller must have a balance of at least `amount`.
317      */
318     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
319         _transfer(_msgSender(), recipient, amount);
320         return true;
321     }
322 
323     /**
324      * @dev See {IERC20-allowance}.
325      */
326     function allowance(address owner, address spender) public view virtual override returns (uint256) {
327         return _allowances[owner][spender];
328     }
329 
330     /**
331      * @dev See {IERC20-approve}.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      */
337     function approve(address spender, uint256 amount) public virtual override returns (bool) {
338         _approve(_msgSender(), spender, amount);
339         return true;
340     }
341 
342     /**
343      * @dev See {IERC20-transferFrom}.
344      *
345      * Emits an {Approval} event indicating the updated allowance. This is not
346      * required by the EIP. See the note at the beginning of {ERC20}.
347      *
348      * Requirements:
349      *
350      * - `sender` and `recipient` cannot be the zero address.
351      * - `sender` must have a balance of at least `amount`.
352      * - the caller must have allowance for ``sender``'s tokens of at least
353      * `amount`.
354      */
355     function transferFrom(
356         address sender,
357         address recipient,
358         uint256 amount
359     ) public virtual override returns (bool) {
360         _transfer(sender, recipient, amount);
361 
362         uint256 currentAllowance = _allowances[sender][_msgSender()];
363         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
364         unchecked {
365             _approve(sender, _msgSender(), currentAllowance - amount);
366         }
367 
368         return true;
369     }
370 
371     /**
372      * @dev Atomically increases the allowance granted to `spender` by the caller.
373      *
374      * This is an alternative to {approve} that can be used as a mitigation for
375      * problems described in {IERC20-approve}.
376      *
377      * Emits an {Approval} event indicating the updated allowance.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      */
383     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
384         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
385         return true;
386     }
387 
388     /**
389      * @dev Atomically decreases the allowance granted to `spender` by the caller.
390      *
391      * This is an alternative to {approve} that can be used as a mitigation for
392      * problems described in {IERC20-approve}.
393      *
394      * Emits an {Approval} event indicating the updated allowance.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      * - `spender` must have allowance for the caller of at least
400      * `subtractedValue`.
401      */
402     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
403         uint256 currentAllowance = _allowances[_msgSender()][spender];
404         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
405         unchecked {
406             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
407         }
408 
409         return true;
410     }
411 
412     /**
413      * @dev Moves `amount` of tokens from `sender` to `recipient`.
414      *
415      * This internal function is equivalent to {transfer}, and can be used to
416      * e.g. implement automatic token fees, slashing mechanisms, etc.
417      *
418      * Emits a {Transfer} event.
419      *
420      * Requirements:
421      *
422      * - `sender` cannot be the zero address.
423      * - `recipient` cannot be the zero address.
424      * - `sender` must have a balance of at least `amount`.
425      */
426     function _transfer(
427         address sender,
428         address recipient,
429         uint256 amount
430     ) internal virtual {
431         require(sender != address(0), "ERC20: transfer from the zero address");
432         require(recipient != address(0), "ERC20: transfer to the zero address");
433 
434         _beforeTokenTransfer(sender, recipient, amount);
435 
436         uint256 senderBalance = _balances[sender];
437         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
438         unchecked {
439             _balances[sender] = senderBalance - amount;
440         }
441         _balances[recipient] += amount;
442 
443         emit Transfer(sender, recipient, amount);
444 
445         _afterTokenTransfer(sender, recipient, amount);
446     }
447 
448     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
449      * the total supply.
450      *
451      * Emits a {Transfer} event with `from` set to the zero address.
452      *
453      * Requirements:
454      *
455      * - `account` cannot be the zero address.
456      */
457     function _mint(address account, uint256 amount) internal virtual {
458         require(account != address(0), "ERC20: mint to the zero address");
459 
460         _beforeTokenTransfer(address(0), account, amount);
461 
462         _totalSupply += amount;
463         _balances[account] += amount;
464         emit Transfer(address(0), account, amount);
465 
466         _afterTokenTransfer(address(0), account, amount);
467     }
468 
469     /**
470      * @dev Destroys `amount` tokens from `account`, reducing the
471      * total supply.
472      *
473      * Emits a {Transfer} event with `to` set to the zero address.
474      *
475      * Requirements:
476      *
477      * - `account` cannot be the zero address.
478      * - `account` must have at least `amount` tokens.
479      */
480     function _burn(address account, uint256 amount) internal virtual {
481         require(account != address(0), "ERC20: burn from the zero address");
482 
483         _beforeTokenTransfer(account, address(0), amount);
484 
485         uint256 accountBalance = _balances[account];
486         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
487         unchecked {
488             _balances[account] = accountBalance - amount;
489         }
490         _totalSupply -= amount;
491 
492         emit Transfer(account, address(0), amount);
493 
494         _afterTokenTransfer(account, address(0), amount);
495     }
496 
497     /**
498      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
499      *
500      * This internal function is equivalent to `approve`, and can be used to
501      * e.g. set automatic allowances for certain subsystems, etc.
502      *
503      * Emits an {Approval} event.
504      *
505      * Requirements:
506      *
507      * - `owner` cannot be the zero address.
508      * - `spender` cannot be the zero address.
509      */
510     function _approve(
511         address owner,
512         address spender,
513         uint256 amount
514     ) internal virtual {
515         require(owner != address(0), "ERC20: approve from the zero address");
516         require(spender != address(0), "ERC20: approve to the zero address");
517 
518         _allowances[owner][spender] = amount;
519         emit Approval(owner, spender, amount);
520     }
521 
522     /**
523      * @dev Hook that is called before any transfer of tokens. This includes
524      * minting and burning.
525      *
526      * Calling conditions:
527      *
528      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
529      * will be transferred to `to`.
530      * - when `from` is zero, `amount` tokens will be minted for `to`.
531      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
532      * - `from` and `to` are never both zero.
533      *
534      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
535      */
536     function _beforeTokenTransfer(
537         address from,
538         address to,
539         uint256 amount
540     ) internal virtual {}
541 
542     /**
543      * @dev Hook that is called after any transfer of tokens. This includes
544      * minting and burning.
545      *
546      * Calling conditions:
547      *
548      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
549      * has been transferred to `to`.
550      * - when `from` is zero, `amount` tokens have been minted for `to`.
551      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
552      * - `from` and `to` are never both zero.
553      *
554      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
555      */
556     function _afterTokenTransfer(
557         address from,
558         address to,
559         uint256 amount
560     ) internal virtual {}
561 }
562 
563 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
564 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
565 
566 /* pragma solidity ^0.8.0; */
567 
568 // CAUTION
569 // This version of SafeMath should only be used with Solidity 0.8 or later,
570 // because it relies on the compiler's built in overflow checks.
571 
572 /**
573  * @dev Wrappers over Solidity's arithmetic operations.
574  *
575  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
576  * now has built in overflow checking.
577  */
578 library SafeMath {
579     /**
580      * @dev Returns the addition of two unsigned integers, with an overflow flag.
581      *
582      * _Available since v3.4._
583      */
584     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
585         unchecked {
586             uint256 c = a + b;
587             if (c < a) return (false, 0);
588             return (true, c);
589         }
590     }
591 
592     /**
593      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
594      *
595      * _Available since v3.4._
596      */
597     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
598         unchecked {
599             if (b > a) return (false, 0);
600             return (true, a - b);
601         }
602     }
603 
604     /**
605      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
606      *
607      * _Available since v3.4._
608      */
609     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
610         unchecked {
611             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
612             // benefit is lost if 'b' is also tested.
613             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
614             if (a == 0) return (true, 0);
615             uint256 c = a * b;
616             if (c / a != b) return (false, 0);
617             return (true, c);
618         }
619     }
620 
621     /**
622      * @dev Returns the division of two unsigned integers, with a division by zero flag.
623      *
624      * _Available since v3.4._
625      */
626     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
627         unchecked {
628             if (b == 0) return (false, 0);
629             return (true, a / b);
630         }
631     }
632 
633     /**
634      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
635      *
636      * _Available since v3.4._
637      */
638     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
639         unchecked {
640             if (b == 0) return (false, 0);
641             return (true, a % b);
642         }
643     }
644 
645     /**
646      * @dev Returns the addition of two unsigned integers, reverting on
647      * overflow.
648      *
649      * Counterpart to Solidity's `+` operator.
650      *
651      * Requirements:
652      *
653      * - Addition cannot overflow.
654      */
655     function add(uint256 a, uint256 b) internal pure returns (uint256) {
656         return a + b;
657     }
658 
659     /**
660      * @dev Returns the subtraction of two unsigned integers, reverting on
661      * overflow (when the result is negative).
662      *
663      * Counterpart to Solidity's `-` operator.
664      *
665      * Requirements:
666      *
667      * - Subtraction cannot overflow.
668      */
669     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
670         return a - b;
671     }
672 
673     /**
674      * @dev Returns the multiplication of two unsigned integers, reverting on
675      * overflow.
676      *
677      * Counterpart to Solidity's `*` operator.
678      *
679      * Requirements:
680      *
681      * - Multiplication cannot overflow.
682      */
683     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
684         return a * b;
685     }
686 
687     /**
688      * @dev Returns the integer division of two unsigned integers, reverting on
689      * division by zero. The result is rounded towards zero.
690      *
691      * Counterpart to Solidity's `/` operator.
692      *
693      * Requirements:
694      *
695      * - The divisor cannot be zero.
696      */
697     function div(uint256 a, uint256 b) internal pure returns (uint256) {
698         return a / b;
699     }
700 
701     /**
702      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
703      * reverting when dividing by zero.
704      *
705      * Counterpart to Solidity's `%` operator. This function uses a `revert`
706      * opcode (which leaves remaining gas untouched) while Solidity uses an
707      * invalid opcode to revert (consuming all remaining gas).
708      *
709      * Requirements:
710      *
711      * - The divisor cannot be zero.
712      */
713     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
714         return a % b;
715     }
716 
717     /**
718      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
719      * overflow (when the result is negative).
720      *
721      * CAUTION: This function is deprecated because it requires allocating memory for the error
722      * message unnecessarily. For custom revert reasons use {trySub}.
723      *
724      * Counterpart to Solidity's `-` operator.
725      *
726      * Requirements:
727      *
728      * - Subtraction cannot overflow.
729      */
730     function sub(
731         uint256 a,
732         uint256 b,
733         string memory errorMessage
734     ) internal pure returns (uint256) {
735         unchecked {
736             require(b <= a, errorMessage);
737             return a - b;
738         }
739     }
740 
741     /**
742      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
743      * division by zero. The result is rounded towards zero.
744      *
745      * Counterpart to Solidity's `/` operator. Note: this function uses a
746      * `revert` opcode (which leaves remaining gas untouched) while Solidity
747      * uses an invalid opcode to revert (consuming all remaining gas).
748      *
749      * Requirements:
750      *
751      * - The divisor cannot be zero.
752      */
753     function div(
754         uint256 a,
755         uint256 b,
756         string memory errorMessage
757     ) internal pure returns (uint256) {
758         unchecked {
759             require(b > 0, errorMessage);
760             return a / b;
761         }
762     }
763 
764     /**
765      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
766      * reverting with custom message when dividing by zero.
767      *
768      * CAUTION: This function is deprecated because it requires allocating memory for the error
769      * message unnecessarily. For custom revert reasons use {tryMod}.
770      *
771      * Counterpart to Solidity's `%` operator. This function uses a `revert`
772      * opcode (which leaves remaining gas untouched) while Solidity uses an
773      * invalid opcode to revert (consuming all remaining gas).
774      *
775      * Requirements:
776      *
777      * - The divisor cannot be zero.
778      */
779     function mod(
780         uint256 a,
781         uint256 b,
782         string memory errorMessage
783     ) internal pure returns (uint256) {
784         unchecked {
785             require(b > 0, errorMessage);
786             return a % b;
787         }
788     }
789 }
790 
791 ////// src/IUniswapV2Factory.sol
792 /* pragma solidity 0.8.10; */
793 /* pragma experimental ABIEncoderV2; */
794 
795 interface IUniswapV2Factory {
796     event PairCreated(
797         address indexed token0,
798         address indexed token1,
799         address pair,
800         uint256
801     );
802 
803     function feeTo() external view returns (address);
804 
805     function feeToSetter() external view returns (address);
806 
807     function getPair(address tokenA, address tokenB)
808         external
809         view
810         returns (address pair);
811 
812     function allPairs(uint256) external view returns (address pair);
813 
814     function allPairsLength() external view returns (uint256);
815 
816     function createPair(address tokenA, address tokenB)
817         external
818         returns (address pair);
819 
820     function setFeeTo(address) external;
821 
822     function setFeeToSetter(address) external;
823 }
824 
825 ////// src/IUniswapV2Pair.sol
826 /* pragma solidity 0.8.10; */
827 /* pragma experimental ABIEncoderV2; */
828 
829 interface IUniswapV2Pair {
830     event Approval(
831         address indexed owner,
832         address indexed spender,
833         uint256 value
834     );
835     event Transfer(address indexed from, address indexed to, uint256 value);
836 
837     function name() external pure returns (string memory);
838 
839     function symbol() external pure returns (string memory);
840 
841     function decimals() external pure returns (uint8);
842 
843     function totalSupply() external view returns (uint256);
844 
845     function balanceOf(address owner) external view returns (uint256);
846 
847     function allowance(address owner, address spender)
848         external
849         view
850         returns (uint256);
851 
852     function approve(address spender, uint256 value) external returns (bool);
853 
854     function transfer(address to, uint256 value) external returns (bool);
855 
856     function transferFrom(
857         address from,
858         address to,
859         uint256 value
860     ) external returns (bool);
861 
862     function DOMAIN_SEPARATOR() external view returns (bytes32);
863 
864     function PERMIT_TYPEHASH() external pure returns (bytes32);
865 
866     function nonces(address owner) external view returns (uint256);
867 
868     function permit(
869         address owner,
870         address spender,
871         uint256 value,
872         uint256 deadline,
873         uint8 v,
874         bytes32 r,
875         bytes32 s
876     ) external;
877 
878     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
879     event Burn(
880         address indexed sender,
881         uint256 amount0,
882         uint256 amount1,
883         address indexed to
884     );
885     event Swap(
886         address indexed sender,
887         uint256 amount0In,
888         uint256 amount1In,
889         uint256 amount0Out,
890         uint256 amount1Out,
891         address indexed to
892     );
893     event Sync(uint112 reserve0, uint112 reserve1);
894 
895     function MINIMUM_LIQUIDITY() external pure returns (uint256);
896 
897     function factory() external view returns (address);
898 
899     function token0() external view returns (address);
900 
901     function token1() external view returns (address);
902 
903     function getReserves()
904         external
905         view
906         returns (
907             uint112 reserve0,
908             uint112 reserve1,
909             uint32 blockTimestampLast
910         );
911 
912     function price0CumulativeLast() external view returns (uint256);
913 
914     function price1CumulativeLast() external view returns (uint256);
915 
916     function kLast() external view returns (uint256);
917 
918     function mint(address to) external returns (uint256 liquidity);
919 
920     function burn(address to)
921         external
922         returns (uint256 amount0, uint256 amount1);
923 
924     function swap(
925         uint256 amount0Out,
926         uint256 amount1Out,
927         address to,
928         bytes calldata data
929     ) external;
930 
931     function skim(address to) external;
932 
933     function sync() external;
934 
935     function initialize(address, address) external;
936 }
937 
938 ////// src/IUniswapV2Router02.sol
939 /* pragma solidity 0.8.10; */
940 /* pragma experimental ABIEncoderV2; */
941 
942 interface IUniswapV2Router02 {
943     function factory() external pure returns (address);
944 
945     function WETH() external pure returns (address);
946 
947     function addLiquidity(
948         address tokenA,
949         address tokenB,
950         uint256 amountADesired,
951         uint256 amountBDesired,
952         uint256 amountAMin,
953         uint256 amountBMin,
954         address to,
955         uint256 deadline
956     )
957         external
958         returns (
959             uint256 amountA,
960             uint256 amountB,
961             uint256 liquidity
962         );
963 
964     function addLiquidityETH(
965         address token,
966         uint256 amountTokenDesired,
967         uint256 amountTokenMin,
968         uint256 amountETHMin,
969         address to,
970         uint256 deadline
971     )
972         external
973         payable
974         returns (
975             uint256 amountToken,
976             uint256 amountETH,
977             uint256 liquidity
978         );
979 
980     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
981         uint256 amountIn,
982         uint256 amountOutMin,
983         address[] calldata path,
984         address to,
985         uint256 deadline
986     ) external;
987 
988     function swapExactETHForTokensSupportingFeeOnTransferTokens(
989         uint256 amountOutMin,
990         address[] calldata path,
991         address to,
992         uint256 deadline
993     ) external payable;
994 
995     function swapExactTokensForETHSupportingFeeOnTransferTokens(
996         uint256 amountIn,
997         uint256 amountOutMin,
998         address[] calldata path,
999         address to,
1000         uint256 deadline
1001     ) external;
1002 }
1003 
1004 /* pragma solidity >=0.8.10; */
1005 
1006 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1007 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1008 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1009 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1010 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1011 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1012 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1013 
1014 contract CHEW is ERC20, Ownable {
1015     using SafeMath for uint256;
1016 
1017     IUniswapV2Router02 public immutable uniswapV2Router;
1018     address public immutable uniswapV2Pair;
1019     address public constant deadAddress = address(0xdead);
1020 
1021     bool private swapping;
1022 
1023     address public marketingWallet;
1024     address public devWallet;
1025     address public lpWallet;
1026 
1027     uint256 public maxTransactionAmount;
1028     uint256 public swapTokensAtAmount;
1029     uint256 public maxWallet;
1030 
1031     uint256 public percentForLPBurn = 25; // 25 = .25%
1032     bool public lpBurnEnabled = true;
1033     uint256 public lpBurnFrequency = 3600 seconds;
1034     uint256 public lastLpBurnTime;
1035 
1036     uint256 public manualBurnFrequency = 30 minutes;
1037     uint256 public lastManualLpBurnTime;
1038 
1039     bool public limitsInEffect = true;
1040     bool public tradingActive = false;
1041     bool public swapEnabled = false;
1042 
1043     // Anti-bot and anti-whale mappings and variables
1044     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1045     bool public transferDelayEnabled = true;
1046 
1047     uint256 public buyTotalFees;
1048     uint256 public buyMarketingFee;
1049     uint256 public buyLiquidityFee;
1050     uint256 public buyDevFee;
1051 
1052     uint256 public sellTotalFees;
1053     uint256 public sellMarketingFee;
1054     uint256 public sellLiquidityFee;
1055     uint256 public sellDevFee;
1056 
1057     uint256 public tokensForMarketing;
1058     uint256 public tokensForLiquidity;
1059     uint256 public tokensForDev;
1060 
1061     /******************/
1062 
1063     // exlcude from fees and max transaction amount
1064     mapping(address => bool) private _isExcludedFromFees;
1065     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1066 
1067     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1068     // could be subject to a maximum transfer amount
1069     mapping(address => bool) public automatedMarketMakerPairs;
1070 
1071     event UpdateUniswapV2Router(
1072         address indexed newAddress,
1073         address indexed oldAddress
1074     );
1075 
1076     event ExcludeFromFees(address indexed account, bool isExcluded);
1077 
1078     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1079 
1080     event marketingWalletUpdated(
1081         address indexed newWallet,
1082         address indexed oldWallet
1083     );
1084 
1085     event devWalletUpdated(
1086         address indexed newWallet,
1087         address indexed oldWallet
1088     );
1089 
1090     event SwapAndLiquify(
1091         uint256 tokensSwapped,
1092         uint256 ethReceived,
1093         uint256 tokensIntoLiquidity
1094     );
1095 
1096     constructor() ERC20("CHEW", "CHEW") {
1097         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1098             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1099         );
1100 
1101         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1102         uniswapV2Router = _uniswapV2Router;
1103 
1104         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1105             .createPair(address(this), _uniswapV2Router.WETH());
1106         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1107         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1108 
1109         uint256 _buyMarketingFee = 8;
1110         uint256 _buyLiquidityFee = 2;
1111         uint256 _buyDevFee = 0;
1112 
1113         uint256 _sellMarketingFee = 9;
1114         uint256 _sellLiquidityFee = 6;
1115         uint256 _sellDevFee = 0;
1116 
1117         uint256 totalSupply = 1000000000 * 1e18;
1118 
1119         maxTransactionAmount = (totalSupply) / 100;
1120         maxWallet = (totalSupply) / 100;
1121         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1122 
1123         buyMarketingFee = _buyMarketingFee;
1124         buyLiquidityFee = _buyLiquidityFee;
1125         buyDevFee = _buyDevFee;
1126         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1127 
1128         sellMarketingFee = _sellMarketingFee;
1129         sellLiquidityFee = _sellLiquidityFee;
1130         sellDevFee = _sellDevFee;
1131         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1132 
1133         marketingWallet = address(0xdA2572efd681921f3B266b7a808791DeB6038BaC); 
1134         devWallet = address(0xf3FF20903Ff771a8109C308ecf5925329A37f908);
1135         lpWallet = msg.sender;
1136 
1137         // exclude from paying fees or having max transaction amount
1138         excludeFromFees(owner(), true);
1139         excludeFromFees(address(this), true);
1140         excludeFromFees(address(0xdead), true);
1141         excludeFromFees(marketingWallet, true);
1142 
1143         excludeFromMaxTransaction(owner(), true);
1144         excludeFromMaxTransaction(address(this), true);
1145         excludeFromMaxTransaction(address(0xdead), true);
1146         excludeFromMaxTransaction(marketingWallet, true);
1147 
1148         /*
1149             _mint is an internal function in ERC20.sol that is only called here,
1150             and CANNOT be called ever again
1151         */
1152         _mint(msg.sender, totalSupply);
1153     }
1154 
1155     receive() external payable {}
1156 
1157     // once enabled, can never be turned off
1158     function enableTrading() external onlyOwner {
1159         tradingActive = true;
1160         swapEnabled = true;
1161         lastLpBurnTime = block.timestamp;
1162     }
1163 
1164     // remove limits after token is stable
1165     function removeLimits() external onlyOwner returns (bool) {
1166         limitsInEffect = false;
1167         return true;
1168     }
1169 
1170     // disable Transfer delay - cannot be reenabled
1171     function disableTransferDelay() external onlyOwner returns (bool) {
1172         transferDelayEnabled = false;
1173         return true;
1174     }
1175 
1176     // change the minimum amount of tokens to sell from fees
1177     function updateSwapTokensAtAmount(uint256 newAmount)
1178         external
1179         onlyOwner
1180         returns (bool)
1181     {
1182         require(
1183             newAmount >= (totalSupply() * 1) / 100000,
1184             "Swap amount cannot be lower than 0.001% total supply."
1185         );
1186         require(
1187             newAmount <= (totalSupply() * 5) / 1000,
1188             "Swap amount cannot be higher than 0.5% total supply."
1189         );
1190         swapTokensAtAmount = newAmount;
1191         return true;
1192     }
1193 
1194     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1195         require(
1196             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1197             "Cannot set maxTransactionAmount lower than 0.1%"
1198         );
1199         maxTransactionAmount = newNum * (10**18);
1200     }
1201 
1202     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1203         require(
1204             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1205             "Cannot set maxWallet lower than 0.5%"
1206         );
1207         maxWallet = newNum * (10**18);
1208     }
1209 
1210     function excludeFromMaxTransaction(address updAds, bool isEx)
1211         public
1212         onlyOwner
1213     {
1214         _isExcludedMaxTransactionAmount[updAds] = isEx;
1215     }
1216 
1217     // only use to disable contract sales if absolutely necessary (emergency use only)
1218     function updateSwapEnabled(bool enabled) external onlyOwner {
1219         swapEnabled = enabled;
1220     }
1221 
1222     function updateBuyFees(
1223         uint256 _marketingFee,
1224         uint256 _liquidityFee,
1225         uint256 _devFee
1226     ) external onlyOwner {
1227         buyMarketingFee = _marketingFee;
1228         buyLiquidityFee = _liquidityFee;
1229         buyDevFee = _devFee;
1230         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1231         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1232     }
1233 
1234     function updateSellFees(
1235         uint256 _marketingFee,
1236         uint256 _liquidityFee,
1237         uint256 _devFee
1238     ) external onlyOwner {
1239         sellMarketingFee = _marketingFee;
1240         sellLiquidityFee = _liquidityFee;
1241         sellDevFee = _devFee;
1242         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1243         require(sellTotalFees <= 20, "Must keep fees at  20% or less");
1244     }
1245 
1246     function excludeFromFees(address account, bool excluded) public onlyOwner {
1247         _isExcludedFromFees[account] = excluded;
1248         emit ExcludeFromFees(account, excluded);
1249     }
1250 
1251     function setAutomatedMarketMakerPair(address pair, bool value)
1252         public
1253         onlyOwner
1254     {
1255         require(
1256             pair != uniswapV2Pair,
1257             "The pair cannot be removed from automatedMarketMakerPairs"
1258         );
1259 
1260         _setAutomatedMarketMakerPair(pair, value);
1261     }
1262 
1263     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1264         automatedMarketMakerPairs[pair] = value;
1265 
1266         emit SetAutomatedMarketMakerPair(pair, value);
1267     }
1268 
1269     function updateMarketingWallet(address newMarketingWallet)
1270         external
1271         onlyOwner
1272     {
1273         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1274         marketingWallet = newMarketingWallet;
1275     }
1276 
1277     function updateLPWallet(address newLPWallet)
1278         external
1279         onlyOwner
1280     {
1281         lpWallet = newLPWallet;
1282     }
1283 
1284     function updateDevWallet(address newWallet) external onlyOwner {
1285         emit devWalletUpdated(newWallet, devWallet);
1286         devWallet = newWallet;
1287     }
1288 
1289     function isExcludedFromFees(address account) public view returns (bool) {
1290         return _isExcludedFromFees[account];
1291     }
1292 
1293     event BoughtEarly(address indexed sniper);
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
1390         if (
1391             !swapping &&
1392             automatedMarketMakerPairs[to] &&
1393             lpBurnEnabled &&
1394             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1395             !_isExcludedFromFees[from]
1396         ) {
1397             autoBurnLiquidityPairTokens();
1398         }
1399 
1400         bool takeFee = !swapping;
1401 
1402         // if any account belongs to _isExcludedFromFee account then remove the fee
1403         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1404             takeFee = false;
1405         }
1406 
1407         uint256 fees = 0;
1408         // only take fees on buys/sells, do not take on wallet transfers
1409         if (takeFee) {
1410             // on sell
1411             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1412                 fees = amount.mul(sellTotalFees).div(100);
1413                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1414                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1415                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1416             }
1417             // on buy
1418             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1419                 fees = amount.mul(buyTotalFees).div(100);
1420                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1421                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1422                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1423             }
1424 
1425             if (fees > 0) {
1426                 super._transfer(from, address(this), fees);
1427             }
1428 
1429             amount -= fees;
1430         }
1431 
1432         super._transfer(from, to, amount);
1433     }
1434 
1435     function swapTokensForEth(uint256 tokenAmount) private {
1436         // generate the uniswap pair path of token -> weth
1437         address[] memory path = new address[](2);
1438         path[0] = address(this);
1439         path[1] = uniswapV2Router.WETH();
1440 
1441         _approve(address(this), address(uniswapV2Router), tokenAmount);
1442 
1443         // make the swap
1444         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1445             tokenAmount,
1446             0, // accept any amount of ETH
1447             path,
1448             address(this),
1449             block.timestamp
1450         );
1451     }
1452 
1453     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1454         // approve token transfer to cover all possible scenarios
1455         _approve(address(this), address(uniswapV2Router), tokenAmount);
1456 
1457         // add the liquidity
1458         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1459             address(this),
1460             tokenAmount,
1461             0, // slippage is unavoidable
1462             0, // slippage is unavoidable
1463             lpWallet,
1464             block.timestamp
1465         );
1466     }
1467 
1468     function swapBack() private {
1469         uint256 contractBalance = balanceOf(address(this));
1470         uint256 totalTokensToSwap = tokensForLiquidity +
1471             tokensForMarketing +
1472             tokensForDev;
1473         bool success;
1474 
1475         if (contractBalance == 0 || totalTokensToSwap == 0) {
1476             return;
1477         }
1478 
1479         if (contractBalance > swapTokensAtAmount * 20) {
1480             contractBalance = swapTokensAtAmount * 20;
1481         }
1482 
1483         // Halve the amount of liquidity tokens
1484         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1485             totalTokensToSwap /
1486             2;
1487         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1488 
1489         uint256 initialETHBalance = address(this).balance;
1490 
1491         swapTokensForEth(amountToSwapForETH);
1492 
1493         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1494 
1495         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1496             totalTokensToSwap
1497         );
1498         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1499 
1500         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1501 
1502         tokensForLiquidity = 0;
1503         tokensForMarketing = 0;
1504         tokensForDev = 0;
1505 
1506         (success, ) = address(devWallet).call{value: ethForDev}("");
1507 
1508         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1509             addLiquidity(liquidityTokens, ethForLiquidity);
1510             emit SwapAndLiquify(
1511                 amountToSwapForETH,
1512                 ethForLiquidity,
1513                 tokensForLiquidity
1514             );
1515         }
1516 
1517         (success, ) = address(marketingWallet).call{
1518             value: address(this).balance
1519         }("");
1520     }
1521 
1522     function setAutoLPBurnSettings(
1523         uint256 _frequencyInSeconds,
1524         uint256 _percent,
1525         bool _Enabled
1526     ) external onlyOwner {
1527         require(
1528             _frequencyInSeconds >= 600,
1529             "cannot set buyback more often than every 10 minutes"
1530         );
1531         require(
1532             _percent <= 1000 && _percent >= 0,
1533             "Must set auto LP burn percent between 0% and 10%"
1534         );
1535         lpBurnFrequency = _frequencyInSeconds;
1536         percentForLPBurn = _percent;
1537         lpBurnEnabled = _Enabled;
1538     }
1539 
1540     function autoBurnLiquidityPairTokens() internal returns (bool) {
1541         lastLpBurnTime = block.timestamp;
1542 
1543         // get balance of liquidity pair
1544         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1545 
1546         // calculate amount to burn
1547         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1548             10000
1549         );
1550 
1551         // pull tokens from pancakePair liquidity and move to dead address permanently
1552         if (amountToBurn > 0) {
1553             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1554         }
1555 
1556         //sync price since this is not in a swap transaction!
1557         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1558         pair.sync();
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
1588         return true;
1589     }
1590 }