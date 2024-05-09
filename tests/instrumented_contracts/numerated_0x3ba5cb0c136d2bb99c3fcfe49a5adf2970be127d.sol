1 // File: openzeppelin-solidity/contracts/utils/math/SafeMath.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
231 
232 
233 // OpenZeppelin Contracts v4.3.2 (utils/Context.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev Provides information about the current execution context, including the
239  * sender of the transaction and its data. While these are generally available
240  * via msg.sender and msg.data, they should not be accessed in such a direct
241  * manner, since when dealing with meta-transactions the account sending and
242  * paying for execution may not be the actual sender (as far as an application
243  * is concerned).
244  *
245  * This contract is only required for intermediate, library-like contracts.
246  */
247 abstract contract Context {
248     function _msgSender() internal view virtual returns (address) {
249         return msg.sender;
250     }
251 
252     function _msgData() internal view virtual returns (bytes calldata) {
253         return msg.data;
254     }
255 }
256 
257 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
258 
259 
260 // OpenZeppelin Contracts v4.3.2 (token/ERC20/IERC20.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev Interface of the ERC20 standard as defined in the EIP.
266  */
267 interface IERC20 {
268     /**
269      * @dev Returns the amount of tokens in existence.
270      */
271     function totalSupply() external view returns (uint256);
272 
273     /**
274      * @dev Returns the amount of tokens owned by `account`.
275      */
276     function balanceOf(address account) external view returns (uint256);
277 
278     /**
279      * @dev Moves `amount` tokens from the caller's account to `recipient`.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transfer(address recipient, uint256 amount) external returns (bool);
286 
287     /**
288      * @dev Returns the remaining number of tokens that `spender` will be
289      * allowed to spend on behalf of `owner` through {transferFrom}. This is
290      * zero by default.
291      *
292      * This value changes when {approve} or {transferFrom} are called.
293      */
294     function allowance(address owner, address spender) external view returns (uint256);
295 
296     /**
297      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
298      *
299      * Returns a boolean value indicating whether the operation succeeded.
300      *
301      * IMPORTANT: Beware that changing an allowance with this method brings the risk
302      * that someone may use both the old and the new allowance by unfortunate
303      * transaction ordering. One possible solution to mitigate this race
304      * condition is to first reduce the spender's allowance to 0 and set the
305      * desired value afterwards:
306      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
307      *
308      * Emits an {Approval} event.
309      */
310     function approve(address spender, uint256 amount) external returns (bool);
311 
312     /**
313      * @dev Moves `amount` tokens from `sender` to `recipient` using the
314      * allowance mechanism. `amount` is then deducted from the caller's
315      * allowance.
316      *
317      * Returns a boolean value indicating whether the operation succeeded.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transferFrom(
322         address sender,
323         address recipient,
324         uint256 amount
325     ) external returns (bool);
326 
327     /**
328      * @dev Emitted when `value` tokens are moved from one account (`from`) to
329      * another (`to`).
330      *
331      * Note that `value` may be zero.
332      */
333     event Transfer(address indexed from, address indexed to, uint256 value);
334 
335     /**
336      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
337      * a call to {approve}. `value` is the new allowance.
338      */
339     event Approval(address indexed owner, address indexed spender, uint256 value);
340 }
341 
342 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
343 
344 
345 // OpenZeppelin Contracts v4.3.2 (token/ERC20/extensions/IERC20Metadata.sol)
346 
347 pragma solidity ^0.8.0;
348 
349 
350 /**
351  * @dev Interface for the optional metadata functions from the ERC20 standard.
352  *
353  * _Available since v4.1._
354  */
355 interface IERC20Metadata is IERC20 {
356     /**
357      * @dev Returns the name of the token.
358      */
359     function name() external view returns (string memory);
360 
361     /**
362      * @dev Returns the symbol of the token.
363      */
364     function symbol() external view returns (string memory);
365 
366     /**
367      * @dev Returns the decimals places of the token.
368      */
369     function decimals() external view returns (uint8);
370 }
371 
372 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
373 
374 
375 // OpenZeppelin Contracts v4.3.2 (token/ERC20/ERC20.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 
380 
381 
382 /**
383  * @dev Implementation of the {IERC20} interface.
384  *
385  * This implementation is agnostic to the way tokens are created. This means
386  * that a supply mechanism has to be added in a derived contract using {_mint}.
387  * For a generic mechanism see {ERC20PresetMinterPauser}.
388  *
389  * TIP: For a detailed writeup see our guide
390  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
391  * to implement supply mechanisms].
392  *
393  * We have followed general OpenZeppelin Contracts guidelines: functions revert
394  * instead returning `false` on failure. This behavior is nonetheless
395  * conventional and does not conflict with the expectations of ERC20
396  * applications.
397  *
398  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
399  * This allows applications to reconstruct the allowance for all accounts just
400  * by listening to said events. Other implementations of the EIP may not emit
401  * these events, as it isn't required by the specification.
402  *
403  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
404  * functions have been added to mitigate the well-known issues around setting
405  * allowances. See {IERC20-approve}.
406  */
407 contract ERC20 is Context, IERC20, IERC20Metadata {
408     mapping(address => uint256) private _balances;
409 
410     mapping(address => mapping(address => uint256)) private _allowances;
411 
412     uint256 private _totalSupply;
413 
414     string private _name;
415     string private _symbol;
416 
417     /**
418      * @dev Sets the values for {name} and {symbol}.
419      *
420      * The default value of {decimals} is 18. To select a different value for
421      * {decimals} you should overload it.
422      *
423      * All two of these values are immutable: they can only be set once during
424      * construction.
425      */
426     constructor(string memory name_, string memory symbol_) {
427         _name = name_;
428         _symbol = symbol_;
429     }
430 
431     /**
432      * @dev Returns the name of the token.
433      */
434     function name() public view virtual override returns (string memory) {
435         return _name;
436     }
437 
438     /**
439      * @dev Returns the symbol of the token, usually a shorter version of the
440      * name.
441      */
442     function symbol() public view virtual override returns (string memory) {
443         return _symbol;
444     }
445 
446     /**
447      * @dev Returns the number of decimals used to get its user representation.
448      * For example, if `decimals` equals `2`, a balance of `505` tokens should
449      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
450      *
451      * Tokens usually opt for a value of 18, imitating the relationship between
452      * Ether and Wei. This is the value {ERC20} uses, unless this function is
453      * overridden;
454      *
455      * NOTE: This information is only used for _display_ purposes: it in
456      * no way affects any of the arithmetic of the contract, including
457      * {IERC20-balanceOf} and {IERC20-transfer}.
458      */
459     function decimals() public view virtual override returns (uint8) {
460         return 18;
461     }
462 
463     /**
464      * @dev See {IERC20-totalSupply}.
465      */
466     function totalSupply() public view virtual override returns (uint256) {
467         return _totalSupply;
468     }
469 
470     /**
471      * @dev See {IERC20-balanceOf}.
472      */
473     function balanceOf(address account) public view virtual override returns (uint256) {
474         return _balances[account];
475     }
476 
477     /**
478      * @dev See {IERC20-transfer}.
479      *
480      * Requirements:
481      *
482      * - `recipient` cannot be the zero address.
483      * - the caller must have a balance of at least `amount`.
484      */
485     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
486         _transfer(_msgSender(), recipient, amount);
487         return true;
488     }
489 
490     /**
491      * @dev See {IERC20-allowance}.
492      */
493     function allowance(address owner, address spender) public view virtual override returns (uint256) {
494         return _allowances[owner][spender];
495     }
496 
497     /**
498      * @dev See {IERC20-approve}.
499      *
500      * Requirements:
501      *
502      * - `spender` cannot be the zero address.
503      */
504     function approve(address spender, uint256 amount) public virtual override returns (bool) {
505         _approve(_msgSender(), spender, amount);
506         return true;
507     }
508 
509     /**
510      * @dev See {IERC20-transferFrom}.
511      *
512      * Emits an {Approval} event indicating the updated allowance. This is not
513      * required by the EIP. See the note at the beginning of {ERC20}.
514      *
515      * Requirements:
516      *
517      * - `sender` and `recipient` cannot be the zero address.
518      * - `sender` must have a balance of at least `amount`.
519      * - the caller must have allowance for ``sender``'s tokens of at least
520      * `amount`.
521      */
522     function transferFrom(
523         address sender,
524         address recipient,
525         uint256 amount
526     ) public virtual override returns (bool) {
527         _transfer(sender, recipient, amount);
528 
529         uint256 currentAllowance = _allowances[sender][_msgSender()];
530         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
531         unchecked {
532             _approve(sender, _msgSender(), currentAllowance - amount);
533         }
534 
535         return true;
536     }
537 
538     /**
539      * @dev Atomically increases the allowance granted to `spender` by the caller.
540      *
541      * This is an alternative to {approve} that can be used as a mitigation for
542      * problems described in {IERC20-approve}.
543      *
544      * Emits an {Approval} event indicating the updated allowance.
545      *
546      * Requirements:
547      *
548      * - `spender` cannot be the zero address.
549      */
550     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
551         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
552         return true;
553     }
554 
555     /**
556      * @dev Atomically decreases the allowance granted to `spender` by the caller.
557      *
558      * This is an alternative to {approve} that can be used as a mitigation for
559      * problems described in {IERC20-approve}.
560      *
561      * Emits an {Approval} event indicating the updated allowance.
562      *
563      * Requirements:
564      *
565      * - `spender` cannot be the zero address.
566      * - `spender` must have allowance for the caller of at least
567      * `subtractedValue`.
568      */
569     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
570         uint256 currentAllowance = _allowances[_msgSender()][spender];
571         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
572         unchecked {
573             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
574         }
575 
576         return true;
577     }
578 
579     /**
580      * @dev Moves `amount` of tokens from `sender` to `recipient`.
581      *
582      * This internal function is equivalent to {transfer}, and can be used to
583      * e.g. implement automatic token fees, slashing mechanisms, etc.
584      *
585      * Emits a {Transfer} event.
586      *
587      * Requirements:
588      *
589      * - `sender` cannot be the zero address.
590      * - `recipient` cannot be the zero address.
591      * - `sender` must have a balance of at least `amount`.
592      */
593     function _transfer(
594         address sender,
595         address recipient,
596         uint256 amount
597     ) internal virtual {
598         require(sender != address(0), "ERC20: transfer from the zero address");
599         require(recipient != address(0), "ERC20: transfer to the zero address");
600 
601         _beforeTokenTransfer(sender, recipient, amount);
602 
603         uint256 senderBalance = _balances[sender];
604         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
605         unchecked {
606             _balances[sender] = senderBalance - amount;
607         }
608         _balances[recipient] += amount;
609 
610         emit Transfer(sender, recipient, amount);
611 
612         _afterTokenTransfer(sender, recipient, amount);
613     }
614 
615     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
616      * the total supply.
617      *
618      * Emits a {Transfer} event with `from` set to the zero address.
619      *
620      * Requirements:
621      *
622      * - `account` cannot be the zero address.
623      */
624     function _mint(address account, uint256 amount) internal virtual {
625         require(account != address(0), "ERC20: mint to the zero address");
626 
627         _beforeTokenTransfer(address(0), account, amount);
628 
629         _totalSupply += amount;
630         _balances[account] += amount;
631         emit Transfer(address(0), account, amount);
632 
633         _afterTokenTransfer(address(0), account, amount);
634     }
635 
636     /**
637      * @dev Destroys `amount` tokens from `account`, reducing the
638      * total supply.
639      *
640      * Emits a {Transfer} event with `to` set to the zero address.
641      *
642      * Requirements:
643      *
644      * - `account` cannot be the zero address.
645      * - `account` must have at least `amount` tokens.
646      */
647     function _burn(address account, uint256 amount) internal virtual {
648         require(account != address(0), "ERC20: burn from the zero address");
649 
650         _beforeTokenTransfer(account, address(0), amount);
651 
652         uint256 accountBalance = _balances[account];
653         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
654         unchecked {
655             _balances[account] = accountBalance - amount;
656         }
657         _totalSupply -= amount;
658 
659         emit Transfer(account, address(0), amount);
660 
661         _afterTokenTransfer(account, address(0), amount);
662     }
663 
664     /**
665      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
666      *
667      * This internal function is equivalent to `approve`, and can be used to
668      * e.g. set automatic allowances for certain subsystems, etc.
669      *
670      * Emits an {Approval} event.
671      *
672      * Requirements:
673      *
674      * - `owner` cannot be the zero address.
675      * - `spender` cannot be the zero address.
676      */
677     function _approve(
678         address owner,
679         address spender,
680         uint256 amount
681     ) internal virtual {
682         require(owner != address(0), "ERC20: approve from the zero address");
683         require(spender != address(0), "ERC20: approve to the zero address");
684 
685         _allowances[owner][spender] = amount;
686         emit Approval(owner, spender, amount);
687     }
688 
689     /**
690      * @dev Hook that is called before any transfer of tokens. This includes
691      * minting and burning.
692      *
693      * Calling conditions:
694      *
695      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
696      * will be transferred to `to`.
697      * - when `from` is zero, `amount` tokens will be minted for `to`.
698      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
699      * - `from` and `to` are never both zero.
700      *
701      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
702      */
703     function _beforeTokenTransfer(
704         address from,
705         address to,
706         uint256 amount
707     ) internal virtual {}
708 
709     /**
710      * @dev Hook that is called after any transfer of tokens. This includes
711      * minting and burning.
712      *
713      * Calling conditions:
714      *
715      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
716      * has been transferred to `to`.
717      * - when `from` is zero, `amount` tokens have been minted for `to`.
718      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
719      * - `from` and `to` are never both zero.
720      *
721      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
722      */
723     function _afterTokenTransfer(
724         address from,
725         address to,
726         uint256 amount
727     ) internal virtual {}
728 }
729 
730 // File: Artifacts/cosmicToken.sol
731 
732 pragma solidity 0.8.7;
733 
734 
735 
736 /// SPDX-License-Identifier: UNLICENSED
737 
738 interface IDuck {
739 	function balanceOG(address _user) external view returns(uint256);
740 }
741 
742 contract CosmicToken is ERC20("CosmicUtilityToken", "CUT") 
743 {
744    
745     using SafeMath for uint256;
746    
747     uint256 public totalTokensBurned = 0;
748     address[] internal stakeholders;
749     address  payable private owner;
750     
751 
752     //token Genesis per day
753     uint256 constant public GENESIS_RATE = 20 ether; 
754     
755     //token duck per day
756     uint256 constant public DUCK_RATE = 5 ether; 
757     
758     //token for  genesis minting
759 	uint256 constant public GENESIS_ISSUANCE = 280 ether;
760 	
761 	//token for duck minting
762 	uint256 constant public DUCK_ISSUANCE = 70 ether;
763 	
764 	
765 	
766 	// Tue Mar 18 2031 17:46:47 GMT+0000
767 	uint256 constant public END = 1931622407;
768 
769 	mapping(address => uint256) public rewards;
770 	mapping(address => uint256) public lastUpdate;
771 	
772 	
773     IDuck public ducksContract;
774    
775     constructor(address initDuckContract) 
776     {
777         owner = payable(msg.sender);
778         ducksContract = IDuck(initDuckContract);
779     }
780    
781 
782     function WhoOwns() public view returns (address) {
783         return owner;
784     }
785    
786     modifier Owned {
787          require(msg.sender == owner);
788          _;
789  }
790    
791     function getContractAddress() public view returns (address) {
792         return address(this);
793     }
794 
795 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
796 		return a < b ? a : b;
797 	}    
798 	
799 	modifier contractAddressOnly
800     {
801          require(msg.sender == address(ducksContract));
802          _;
803     }
804     
805    	// called when minting many NFTs
806 	function updateRewardOnMint(address _user, uint256 _tokenId) external contractAddressOnly
807 	{
808 	    if(_tokenId <= 1000)
809 		{
810             _mint(_user,GENESIS_ISSUANCE);	  	        
811 		}
812 		else if(_tokenId >= 1001)
813 		{
814             _mint(_user,DUCK_ISSUANCE);	  	        	        
815 		}
816 	}
817 	
818 
819 	function getReward(address _to, uint256 totalPayout) external contractAddressOnly
820 	{
821 		_mint(_to, (totalPayout * 10 ** 18));
822 		
823 	}
824 	
825 	function burn(address _from, uint256 _amount) external 
826 	{
827 	    require(msg.sender == _from, "You do not own these tokens");
828 		_burn(_from, _amount);
829 		totalTokensBurned += _amount;
830 	}
831 
832 
833   
834    
835 }