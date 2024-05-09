1 // SPDX-License-Identifier: MIT
2 //                                                                              
3 //             @@@@@@@@                                          @@@@@@@@          
4 //            /@@@@@@@@@                                        @@@@@@@@@,         
5 //            @@@@@@@@@@&                                      @@@@@@@@@@@         
6 //           *@@@@@@@@@@@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%&@@@@@@@@@@@         
7 //           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        
8 //          .@@@@@@@@*          @@@@@@@@@@@@@@@@@@@@@@@@          /@@@@@@@@        
9 //          @@@@@#               @@@@@@@@@@@@@@@@@@@@@@               &@@@@@       
10 //         *@@@@                  /@@@@@@@@@@@@@@@@@@*                 /@@@@       
11 //      /@@@@@@@                                                        @@@@@@@*   
12 //    @@@@@@@@@*      @@@@@@@/                            &@@@@@@@      *@@@@@@@@& 
13 //    @@@@@@@@@       @@@@@@@@                            @@@@@@@@       @@@@@@@@@ 
14 //   *@@@@@@@@@      .@@@@@@@@                            @@@@@@@@       @@@@@@@@@ 
15 //   *@@@@@@@@@      *@@@@@@@@                            @@@@@@@@       @@@@@@@@@ 
16 //    @@@@@@@@@      .@@@@@@@@                            @@@@@@@@       @@@@@@@@@ 
17 //    @@@@@@@@@       @@@@@@@@                            @@@@@@@@      ,@@@@@@@@@ 
18 //      @@@@@@@&                                                        @@@@@@@@   
19 //         /@@@@                   &@@@@@@@@@@@@@@@@#                   @@@@       
20 //          @@@@@                &@@@@@@@@@@@@@@@@@@@@(               .@@@@%       
21 //           (@@@@@@            &@@@@@@@@@@@@@@@@@@@@@@(           ,@@@@@@,        
22 //             ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           
23 //                  (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,                                                                                                                                                                             
24 // 
25 //           The #1 Discord trading tool, sniper & wallet - https://discord.gg/membot
26 //                   https://twitter.com/MembotETH | https://membot.tools
27 // 
28  
29 pragma solidity 0.8.20;
30 
31 /**
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         return msg.data;
48     }
49 }
50 
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * By default, the owner account will be the one that deploys the contract. This
57  * can later be changed with {transferOwnership}.
58  *
59  * This module is used through inheritance. It will make available the modifier
60  * `onlyOwner`, which can be applied to your functions to restrict their use to
61  * the owner.
62  */
63 abstract contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev Initializes the contract setting the deployer as the initial owner.
70      */
71     constructor() {
72         _transferOwnership(_msgSender());
73     }
74 
75     /**
76      * @dev Returns the address of the current owner.
77      */
78     function owner() public view virtual returns (address) {
79         return _owner;
80     }
81 
82     /**
83      * @dev Throws if called by any account other than the owner.
84      */
85     modifier onlyOwner() {
86         require(owner() == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     /**
91      * @dev Leaves the contract without owner. It will not be possible to call
92      * `onlyOwner` functions anymore. Can only be called by the current owner.
93      *
94      * NOTE: Renouncing ownership will leave the contract without an owner,
95      * thereby removing any functionality that is only available to the owner.
96      */
97     function renounceOwnership() public virtual onlyOwner {
98         _transferOwnership(address(0));
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Can only be called by the current owner.
104      */
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         _transferOwnership(newOwner);
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Internal function without access restriction.
113      */
114     function _transferOwnership(address newOwner) internal virtual {
115         address oldOwner = _owner;
116         _owner = newOwner;
117         emit OwnershipTransferred(oldOwner, newOwner);
118     }
119 }
120 
121 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
122 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
123 
124 /* pragma solidity ^0.8.0; */
125 
126 /**
127  * @dev Interface of the ERC20 standard as defined in the EIP.
128  */
129 interface IERC20 {
130     /**
131      * @dev Returns the amount of tokens in existence.
132      */
133     function totalSupply() external view returns (uint256);
134 
135     /**
136      * @dev Returns the amount of tokens owned by `account`.
137      */
138     function balanceOf(address account) external view returns (uint256);
139 
140     /**
141      * @dev Moves `amount` tokens from the caller's account to `recipient`.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transfer(address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Returns the remaining number of tokens that `spender` will be
151      * allowed to spend on behalf of `owner` through {transferFrom}. This is
152      * zero by default.
153      *
154      * This value changes when {approve} or {transferFrom} are called.
155      */
156     function allowance(address owner, address spender) external view returns (uint256);
157 
158     /**
159      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * IMPORTANT: Beware that changing an allowance with this method brings the risk
164      * that someone may use both the old and the new allowance by unfortunate
165      * transaction ordering. One possible solution to mitigate this race
166      * condition is to first reduce the spender's allowance to 0 and set the
167      * desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      *
170      * Emits an {Approval} event.
171      */
172     function approve(address spender, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Moves `amount` tokens from `sender` to `recipient` using the
176      * allowance mechanism. `amount` is then deducted from the caller's
177      * allowance.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transferFrom(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) external returns (bool);
188 
189     /**
190      * @dev Emitted when `value` tokens are moved from one account (`from`) to
191      * another (`to`).
192      *
193      * Note that `value` may be zero.
194      */
195     event Transfer(address indexed from, address indexed to, uint256 value);
196 
197     /**
198      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
199      * a call to {approve}. `value` is the new allowance.
200      */
201     event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
205 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
206 
207 /* pragma solidity ^0.8.0; */
208 
209 /* import "../IERC20.sol"; */
210 
211 /**
212  * @dev Interface for the optional metadata functions from the ERC20 standard.
213  *
214  * _Available since v4.1._
215  */
216 interface IERC20Metadata is IERC20 {
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the symbol of the token.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the decimals places of the token.
229      */
230     function decimals() external view returns (uint8);
231 }
232 
233 /**
234  * @dev Implementation of the {IERC20} interface.
235  *
236  * This implementation is agnostic to the way tokens are created. This means
237  * that a supply mechanism has to be added in a derived contract using {_mint}.
238  * For a generic mechanism see {ERC20PresetMinterPauser}.
239  *
240  * TIP: For a detailed writeup see our guide
241  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
242  * to implement supply mechanisms].
243  *
244  * We have followed general OpenZeppelin Contracts guidelines: functions revert
245  * instead returning `false` on failure. This behavior is nonetheless
246  * conventional and does not conflict with the expectations of ERC20
247  * applications.
248  *
249  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
250  * This allows applications to reconstruct the allowance for all accounts just
251  * by listening to said events. Other implementations of the EIP may not emit
252  * these events, as it isn't required by the specification.
253  *
254  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
255  * functions have been added to mitigate the well-known issues around setting
256  * allowances. See {IERC20-approve}.
257  */
258 contract ERC20 is Context, IERC20, IERC20Metadata {
259     mapping(address => uint256) private _balances;
260 
261     mapping(address => mapping(address => uint256)) private _allowances;
262 
263     uint256 private _totalSupply;
264 
265     string private _name;
266     string private _symbol;
267 
268     /**
269      * @dev Sets the values for {name} and {symbol}.
270      *
271      * The default value of {decimals} is 18. To select a different value for
272      * {decimals} you should overload it.
273      *
274      * All two of these values are immutable: they can only be set once during
275      * construction.
276      */
277     constructor(string memory name_, string memory symbol_) {
278         _name = name_;
279         _symbol = symbol_;
280     }
281 
282     /**
283      * @dev Returns the name of the token.
284      */
285     function name() public view virtual override returns (string memory) {
286         return _name;
287     }
288 
289     /**
290      * @dev Returns the symbol of the token, usually a shorter version of the
291      * name.
292      */
293     function symbol() public view virtual override returns (string memory) {
294         return _symbol;
295     }
296 
297     /**
298      * @dev Returns the number of decimals used to get its user representation.
299      * For example, if `decimals` equals `2`, a balance of `505` tokens should
300      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
301      *
302      * Tokens usually opt for a value of 18, imitating the relationship between
303      * Ether and Wei. This is the value {ERC20} uses, unless this function is
304      * overridden;
305      *
306      * NOTE: This information is only used for _display_ purposes: it in
307      * no way affects any of the arithmetic of the contract, including
308      * {IERC20-balanceOf} and {IERC20-transfer}.
309      */
310     function decimals() public view virtual override returns (uint8) {
311         return 18;
312     }
313 
314     /**
315      * @dev See {IERC20-totalSupply}.
316      */
317     function totalSupply() public view virtual override returns (uint256) {
318         return _totalSupply;
319     }
320 
321     /**
322      * @dev See {IERC20-balanceOf}.
323      */
324     function balanceOf(address account) public view virtual override returns (uint256) {
325         return _balances[account];
326     }
327 
328     /**
329      * @dev See {IERC20-transfer}.
330      *
331      * Requirements:
332      *
333      * - `recipient` cannot be the zero address.
334      * - the caller must have a balance of at least `amount`.
335      */
336     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
337         _transfer(_msgSender(), recipient, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-allowance}.
343      */
344     function allowance(address owner, address spender) public view virtual override returns (uint256) {
345         return _allowances[owner][spender];
346     }
347 
348     /**
349      * @dev See {IERC20-approve}.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      */
355     function approve(address spender, uint256 amount) public virtual override returns (bool) {
356         _approve(_msgSender(), spender, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-transferFrom}.
362      *
363      * Emits an {Approval} event indicating the updated allowance. This is not
364      * required by the EIP. See the note at the beginning of {ERC20}.
365      *
366      * Requirements:
367      *
368      * - `sender` and `recipient` cannot be the zero address.
369      * - `sender` must have a balance of at least `amount`.
370      * - the caller must have allowance for ``sender``'s tokens of at least
371      * `amount`.
372      */
373     function transferFrom(
374         address sender,
375         address recipient,
376         uint256 amount
377     ) public virtual override returns (bool) {
378         _transfer(sender, recipient, amount);
379 
380         uint256 currentAllowance = _allowances[sender][_msgSender()];
381         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
382         unchecked {
383             _approve(sender, _msgSender(), currentAllowance - amount);
384         }
385 
386         return true;
387     }
388 
389     /**
390      * @dev Atomically increases the allowance granted to `spender` by the caller.
391      *
392      * This is an alternative to {approve} that can be used as a mitigation for
393      * problems described in {IERC20-approve}.
394      *
395      * Emits an {Approval} event indicating the updated allowance.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
402         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
403         return true;
404     }
405 
406     /**
407      * @dev Atomically decreases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      * - `spender` must have allowance for the caller of at least
418      * `subtractedValue`.
419      */
420     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
421         uint256 currentAllowance = _allowances[_msgSender()][spender];
422         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
423         unchecked {
424             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
425         }
426 
427         return true;
428     }
429 
430     /**
431      * @dev Moves `amount` of tokens from `sender` to `recipient`.
432      *
433      * This internal function is equivalent to {transfer}, and can be used to
434      * e.g. implement automatic token fees, slashing mechanisms, etc.
435      *
436      * Emits a {Transfer} event.
437      *
438      * Requirements:
439      *
440      * - `sender` cannot be the zero address.
441      * - `recipient` cannot be the zero address.
442      * - `sender` must have a balance of at least `amount`.
443      */
444     function _transfer(
445         address sender,
446         address recipient,
447         uint256 amount
448     ) internal virtual {
449         require(sender != address(0), "ERC20: transfer from the zero address");
450         require(recipient != address(0), "ERC20: transfer to the zero address");
451 
452         _beforeTokenTransfer(sender, recipient, amount);
453 
454         uint256 senderBalance = _balances[sender];
455         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
456         unchecked {
457             _balances[sender] = senderBalance - amount;
458         }
459         _balances[recipient] += amount;
460 
461         emit Transfer(sender, recipient, amount);
462 
463         _afterTokenTransfer(sender, recipient, amount);
464     }
465 
466     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
467      * the total supply.
468      *
469      * Emits a {Transfer} event with `from` set to the zero address.
470      *
471      * Requirements:
472      *
473      * - `account` cannot be the zero address.
474      */
475     function _mint(address account, uint256 amount) internal virtual {
476         require(account != address(0), "ERC20: mint to the zero address");
477 
478         _beforeTokenTransfer(address(0), account, amount);
479 
480         _totalSupply += amount;
481         _balances[account] += amount;
482         emit Transfer(address(0), account, amount);
483 
484         _afterTokenTransfer(address(0), account, amount);
485     }
486 
487     /**
488      * @dev Destroys `amount` tokens from `account`, reducing the
489      * total supply.
490      *
491      * Emits a {Transfer} event with `to` set to the zero address.
492      *
493      * Requirements:
494      *
495      * - `account` cannot be the zero address.
496      * - `account` must have at least `amount` tokens.
497      */
498     function _burn(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: burn from the zero address");
500 
501         _beforeTokenTransfer(account, address(0), amount);
502 
503         uint256 accountBalance = _balances[account];
504         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
505         unchecked {
506             _balances[account] = accountBalance - amount;
507         }
508         _totalSupply -= amount;
509 
510         emit Transfer(account, address(0), amount);
511 
512         _afterTokenTransfer(account, address(0), amount);
513     }
514 
515     /**
516      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
517      *
518      * This internal function is equivalent to `approve`, and can be used to
519      * e.g. set automatic allowances for certain subsystems, etc.
520      *
521      * Emits an {Approval} event.
522      *
523      * Requirements:
524      *
525      * - `owner` cannot be the zero address.
526      * - `spender` cannot be the zero address.
527      */
528     function _approve(
529         address owner,
530         address spender,
531         uint256 amount
532     ) internal virtual {
533         require(owner != address(0), "ERC20: approve from the zero address");
534         require(spender != address(0), "ERC20: approve to the zero address");
535 
536         _allowances[owner][spender] = amount;
537         emit Approval(owner, spender, amount);
538     }
539 
540     /**
541      * @dev Hook that is called before any transfer of tokens. This includes
542      * minting and burning.
543      *
544      * Calling conditions:
545      *
546      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
547      * will be transferred to `to`.
548      * - when `from` is zero, `amount` tokens will be minted for `to`.
549      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
550      * - `from` and `to` are never both zero.
551      *
552      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
553      */
554     function _beforeTokenTransfer(
555         address from,
556         address to,
557         uint256 amount
558     ) internal virtual {}
559 
560     /**
561      * @dev Hook that is called after any transfer of tokens. This includes
562      * minting and burning.
563      *
564      * Calling conditions:
565      *
566      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
567      * has been transferred to `to`.
568      * - when `from` is zero, `amount` tokens have been minted for `to`.
569      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
570      * - `from` and `to` are never both zero.
571      *
572      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
573      */
574     function _afterTokenTransfer(
575         address from,
576         address to,
577         uint256 amount
578     ) internal virtual {}
579 }
580 
581 /**
582  * @dev Wrappers over Solidity's arithmetic operations.
583  *
584  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
585  * now has built in overflow checking.
586  */
587 library SafeMath {
588     /**
589      * @dev Returns the addition of two unsigned integers, with an overflow flag.
590      *
591      * _Available since v3.4._
592      */
593     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
594         unchecked {
595             uint256 c = a + b;
596             if (c < a) return (false, 0);
597             return (true, c);
598         }
599     }
600 
601     /**
602      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
603      *
604      * _Available since v3.4._
605      */
606     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
607         unchecked {
608             if (b > a) return (false, 0);
609             return (true, a - b);
610         }
611     }
612 
613     /**
614      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
615      *
616      * _Available since v3.4._
617      */
618     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
619         unchecked {
620             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
621             // benefit is lost if 'b' is also tested.
622             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
623             if (a == 0) return (true, 0);
624             uint256 c = a * b;
625             if (c / a != b) return (false, 0);
626             return (true, c);
627         }
628     }
629 
630     /**
631      * @dev Returns the division of two unsigned integers, with a division by zero flag.
632      *
633      * _Available since v3.4._
634      */
635     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
636         unchecked {
637             if (b == 0) return (false, 0);
638             return (true, a / b);
639         }
640     }
641 
642     /**
643      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
644      *
645      * _Available since v3.4._
646      */
647     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
648         unchecked {
649             if (b == 0) return (false, 0);
650             return (true, a % b);
651         }
652     }
653 
654     /**
655      * @dev Returns the addition of two unsigned integers, reverting on
656      * overflow.
657      *
658      * Counterpart to Solidity's `+` operator.
659      *
660      * Requirements:
661      *
662      * - Addition cannot overflow.
663      */
664     function add(uint256 a, uint256 b) internal pure returns (uint256) {
665         return a + b;
666     }
667 
668     /**
669      * @dev Returns the subtraction of two unsigned integers, reverting on
670      * overflow (when the result is negative).
671      *
672      * Counterpart to Solidity's `-` operator.
673      *
674      * Requirements:
675      *
676      * - Subtraction cannot overflow.
677      */
678     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
679         return a - b;
680     }
681 
682     /**
683      * @dev Returns the multiplication of two unsigned integers, reverting on
684      * overflow.
685      *
686      * Counterpart to Solidity's `*` operator.
687      *
688      * Requirements:
689      *
690      * - Multiplication cannot overflow.
691      */
692     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
693         return a * b;
694     }
695 
696     /**
697      * @dev Returns the integer division of two unsigned integers, reverting on
698      * division by zero. The result is rounded towards zero.
699      *
700      * Counterpart to Solidity's `/` operator.
701      *
702      * Requirements:
703      *
704      * - The divisor cannot be zero.
705      */
706     function div(uint256 a, uint256 b) internal pure returns (uint256) {
707         return a / b;
708     }
709 
710     /**
711      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
712      * reverting when dividing by zero.
713      *
714      * Counterpart to Solidity's `%` operator. This function uses a `revert`
715      * opcode (which leaves remaining gas untouched) while Solidity uses an
716      * invalid opcode to revert (consuming all remaining gas).
717      *
718      * Requirements:
719      *
720      * - The divisor cannot be zero.
721      */
722     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
723         return a % b;
724     }
725 
726     /**
727      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
728      * overflow (when the result is negative).
729      *
730      * CAUTION: This function is deprecated because it requires allocating memory for the error
731      * message unnecessarily. For custom revert reasons use {trySub}.
732      *
733      * Counterpart to Solidity's `-` operator.
734      *
735      * Requirements:
736      *
737      * - Subtraction cannot overflow.
738      */
739     function sub(
740         uint256 a,
741         uint256 b,
742         string memory errorMessage
743     ) internal pure returns (uint256) {
744         unchecked {
745             require(b <= a, errorMessage);
746             return a - b;
747         }
748     }
749 
750     /**
751      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
752      * division by zero. The result is rounded towards zero.
753      *
754      * Counterpart to Solidity's `/` operator. Note: this function uses a
755      * `revert` opcode (which leaves remaining gas untouched) while Solidity
756      * uses an invalid opcode to revert (consuming all remaining gas).
757      *
758      * Requirements:
759      *
760      * - The divisor cannot be zero.
761      */
762     function div(
763         uint256 a,
764         uint256 b,
765         string memory errorMessage
766     ) internal pure returns (uint256) {
767         unchecked {
768             require(b > 0, errorMessage);
769             return a / b;
770         }
771     }
772 
773     /**
774      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
775      * reverting with custom message when dividing by zero.
776      *
777      * CAUTION: This function is deprecated because it requires allocating memory for the error
778      * message unnecessarily. For custom revert reasons use {tryMod}.
779      *
780      * Counterpart to Solidity's `%` operator. This function uses a `revert`
781      * opcode (which leaves remaining gas untouched) while Solidity uses an
782      * invalid opcode to revert (consuming all remaining gas).
783      *
784      * Requirements:
785      *
786      * - The divisor cannot be zero.
787      */
788     function mod(
789         uint256 a,
790         uint256 b,
791         string memory errorMessage
792     ) internal pure returns (uint256) {
793         unchecked {
794             require(b > 0, errorMessage);
795             return a % b;
796         }
797     }
798 }
799 
800 interface IUniswapV2Factory {
801     event PairCreated(
802         address indexed token0,
803         address indexed token1,
804         address pair,
805         uint256
806     );
807 
808     function feeTo() external view returns (address);
809 
810     function feeToSetter() external view returns (address);
811 
812     function getPair(address tokenA, address tokenB)
813         external
814         view
815         returns (address pair);
816 
817     function allPairs(uint256) external view returns (address pair);
818 
819     function allPairsLength() external view returns (uint256);
820 
821     function createPair(address tokenA, address tokenB)
822         external
823         returns (address pair);
824 
825     function setFeeTo(address) external;
826 
827     function setFeeToSetter(address) external;
828 }
829 
830 ////// src/IUniswapV2Pair.sol
831 /* pragma solidity 0.8.10; */
832 /* pragma experimental ABIEncoderV2; */
833 
834 interface IUniswapV2Pair {
835     event Approval(
836         address indexed owner,
837         address indexed spender,
838         uint256 value
839     );
840     event Transfer(address indexed from, address indexed to, uint256 value);
841 
842     function name() external pure returns (string memory);
843 
844     function symbol() external pure returns (string memory);
845 
846     function decimals() external pure returns (uint8);
847 
848     function totalSupply() external view returns (uint256);
849 
850     function balanceOf(address owner) external view returns (uint256);
851 
852     function allowance(address owner, address spender)
853         external
854         view
855         returns (uint256);
856 
857     function approve(address spender, uint256 value) external returns (bool);
858 
859     function transfer(address to, uint256 value) external returns (bool);
860 
861     function transferFrom(
862         address from,
863         address to,
864         uint256 value
865     ) external returns (bool);
866 
867     function DOMAIN_SEPARATOR() external view returns (bytes32);
868 
869     function PERMIT_TYPEHASH() external pure returns (bytes32);
870 
871     function nonces(address owner) external view returns (uint256);
872 
873     function permit(
874         address owner,
875         address spender,
876         uint256 value,
877         uint256 deadline,
878         uint8 v,
879         bytes32 r,
880         bytes32 s
881     ) external;
882 
883     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
884     event Burn(
885         address indexed sender,
886         uint256 amount0,
887         uint256 amount1,
888         address indexed to
889     );
890     event Swap(
891         address indexed sender,
892         uint256 amount0In,
893         uint256 amount1In,
894         uint256 amount0Out,
895         uint256 amount1Out,
896         address indexed to
897     );
898     event Sync(uint112 reserve0, uint112 reserve1);
899 
900     function MINIMUM_LIQUIDITY() external pure returns (uint256);
901 
902     function factory() external view returns (address);
903 
904     function token0() external view returns (address);
905 
906     function token1() external view returns (address);
907 
908     function getReserves()
909         external
910         view
911         returns (
912             uint112 reserve0,
913             uint112 reserve1,
914             uint32 blockTimestampLast
915         );
916 
917     function price0CumulativeLast() external view returns (uint256);
918 
919     function price1CumulativeLast() external view returns (uint256);
920 
921     function kLast() external view returns (uint256);
922 
923     function mint(address to) external returns (uint256 liquidity);
924 
925     function burn(address to)
926         external
927         returns (uint256 amount0, uint256 amount1);
928 
929     function swap(
930         uint256 amount0Out,
931         uint256 amount1Out,
932         address to,
933         bytes calldata data
934     ) external;
935 
936     function skim(address to) external;
937 
938     function sync() external;
939 
940     function initialize(address, address) external;
941 }
942 
943 interface IUniswapV2Router02 {
944     function factory() external pure returns (address);
945 
946     function WETH() external pure returns (address);
947 
948     function addLiquidity(
949         address tokenA,
950         address tokenB,
951         uint256 amountADesired,
952         uint256 amountBDesired,
953         uint256 amountAMin,
954         uint256 amountBMin,
955         address to,
956         uint256 deadline
957     )
958         external
959         returns (
960             uint256 amountA,
961             uint256 amountB,
962             uint256 liquidity
963         );
964 
965     function addLiquidityETH(
966         address token,
967         uint256 amountTokenDesired,
968         uint256 amountTokenMin,
969         uint256 amountETHMin,
970         address to,
971         uint256 deadline
972     )
973         external
974         payable
975         returns (
976             uint256 amountToken,
977             uint256 amountETH,
978             uint256 liquidity
979         );
980 
981     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
982         uint256 amountIn,
983         uint256 amountOutMin,
984         address[] calldata path,
985         address to,
986         uint256 deadline
987     ) external;
988 
989     function swapExactETHForTokensSupportingFeeOnTransferTokens(
990         uint256 amountOutMin,
991         address[] calldata path,
992         address to,
993         uint256 deadline
994     ) external payable;
995 
996     function swapExactTokensForETHSupportingFeeOnTransferTokens(
997         uint256 amountIn,
998         uint256 amountOutMin,
999         address[] calldata path,
1000         address to,
1001         uint256 deadline
1002     ) external;
1003 }
1004 
1005 contract Membot is ERC20, Ownable {
1006 
1007     IUniswapV2Router02 public immutable uniswapV2Router;
1008     address public immutable uniswapV2Pair;
1009     bool private swapping;
1010 
1011     address public immutable revShareWallet;
1012 
1013     uint256 public maxTransactionAmount;
1014     uint256 immutable public swapTokensAtAmount;
1015     uint256 public maxWallet;
1016 
1017     bool public tradingActive = false;
1018     bool public swapEnabled = false;
1019 
1020     // Anti-bot and anti-whale mappings and variables
1021     mapping(address => bool) blacklisted;
1022 
1023     uint256 public buyTotalFees;
1024     uint256 public buyRevShareFee;
1025     uint256 public buyLiquidityFee;
1026 
1027     uint256 public sellTotalFees;
1028     uint256 public sellRevShareFee;
1029     uint256 public sellLiquidityFee;
1030 
1031     uint256 public tokensForRevShare;
1032     uint256 public tokensForLiquidity;
1033 
1034     // Exclude from fees and max transaction amount
1035     mapping(address => bool) private _isExcludedFromFees;
1036     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1037 
1038     // Store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1039     // could be subject to a maximum transfer amount
1040     mapping(address => bool) public automatedMarketMakerPairs;
1041 
1042     event UpdateUniswapV2Router(
1043         address indexed newAddress,
1044         address indexed oldAddress
1045     );
1046 
1047     event ExcludeFromFees(address indexed account, bool isExcluded);
1048 
1049     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1050 
1051     event SwapAndLiquify(
1052         uint256 tokensSwapped,
1053         uint256 ethReceived,
1054         uint256 tokensIntoLiquidity
1055     );
1056 
1057     constructor() ERC20("Membot", "MEMBOT") {
1058         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1059             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D //Uniswap V2 Router
1060         );
1061 
1062         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1063         uniswapV2Router = _uniswapV2Router;
1064 
1065         // Creates the Uniswap Pair
1066         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1067             .createPair(address(this), _uniswapV2Router.WETH());
1068         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1069         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1070 
1071         uint256 _buyRevShareFee = 8; // Lowered to 4% after launch
1072         uint256 _buyLiquidityFee = 2; // Lowered to 1% after launch
1073 
1074         uint256 _sellRevShareFee = 8; // Lowered to 4% after launch
1075         uint256 _sellLiquidityFee = 2; // Lowered to 1% after launch
1076 
1077         uint256 totalSupply = 1_000_000_000 * 1e18; // 1 million
1078 
1079         maxTransactionAmount = 5000000 * 1e18; // 0.5%
1080         maxWallet = 5000000 * 1e18; // 0.5% 
1081         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% 
1082 
1083         buyRevShareFee = _buyRevShareFee;
1084         buyLiquidityFee = _buyLiquidityFee;
1085         buyTotalFees = buyRevShareFee + buyLiquidityFee;
1086 
1087         sellRevShareFee = _sellRevShareFee;
1088         sellLiquidityFee = _sellLiquidityFee;
1089         sellTotalFees = sellRevShareFee + sellLiquidityFee;
1090 
1091         revShareWallet = address(0x621761e815c634cE1143a1dCd186221644884A6f ); // Set as revShare wallet - Helper Contract
1092 
1093         // Exclude from paying fees or having max transaction amount if; is owner, is deployer, is dead address. 
1094         excludeFromFees(owner(), true);
1095         excludeFromFees(address(this), true);
1096         excludeFromFees(address(0xdead), true);
1097 
1098         excludeFromMaxTransaction(owner(), true);
1099         excludeFromMaxTransaction(address(this), true);
1100         excludeFromMaxTransaction(address(0xdead), true);
1101 
1102         /*
1103             _mint is an internal function in ERC20.sol that is only called here,
1104             and CANNOT be called ever again
1105         */
1106         _mint(msg.sender, totalSupply);
1107     }
1108 
1109     receive() external payable {}
1110 
1111     // Will enable trading, once this is toggeled, it will not be able to be turned off.
1112     function enableTrading() external onlyOwner {
1113         tradingActive = true;
1114         swapEnabled = true;
1115     }
1116 
1117     // Trigger this post launch once price is more stable. Made to avoid whales and snipers hogging supply.
1118     function updateLimitsAndFees() external onlyOwner {
1119         maxTransactionAmount = 10_000_000 * (10**18); // 1%
1120         maxWallet = 25_000_000 * (10**18); // 2.5%
1121     
1122         buyRevShareFee = 4; // 4%
1123         buyLiquidityFee = 1; // 1%
1124         buyTotalFees = 5;
1125 
1126         sellRevShareFee = 4; // 4%
1127         sellLiquidityFee = 1; // 1%
1128         sellTotalFees = 5;
1129     }
1130 
1131     function excludeFromMaxTransaction(address updAds, bool isEx)
1132         public
1133         onlyOwner
1134     {
1135         _isExcludedMaxTransactionAmount[updAds] = isEx;
1136     }
1137 
1138     function excludeFromFees(address account, bool excluded) public onlyOwner {
1139         _isExcludedFromFees[account] = excluded;
1140         emit ExcludeFromFees(account, excluded);
1141     }
1142 
1143     function setAutomatedMarketMakerPair(address pair, bool value)
1144         public
1145         onlyOwner
1146     {
1147         require(
1148             pair != uniswapV2Pair,
1149             "The pair cannot be removed from automatedMarketMakerPairs"
1150         );
1151 
1152         _setAutomatedMarketMakerPair(pair, value);
1153     }
1154 
1155     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1156         automatedMarketMakerPairs[pair] = value;
1157 
1158         emit SetAutomatedMarketMakerPair(pair, value);
1159     }
1160 
1161     function isExcludedFromFees(address account) public view returns (bool) {
1162         return _isExcludedFromFees[account];
1163     }
1164 
1165     function isBlacklisted(address account) public view returns (bool) {
1166         return blacklisted[account];
1167     }
1168 
1169     function _transfer(
1170         address from,
1171         address to,
1172         uint256 amount
1173     ) internal override {
1174         require(from != address(0), "ERC20: transfer from the zero address");
1175         require(to != address(0), "ERC20: transfer to the zero address");
1176         require(!blacklisted[from],"Sender blacklisted");
1177         require(!blacklisted[to],"Receiver blacklisted");
1178 
1179         if (amount == 0) {
1180             super._transfer(from, to, 0);
1181             return;
1182         }
1183 
1184         if (
1185                 from != owner() &&
1186                 to != owner() &&
1187                 to != address(0) &&
1188                 to != address(0xdead) &&
1189                 !swapping
1190             ) {
1191                 if (!tradingActive) {
1192                     require(
1193                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1194                         "Trading is not active."
1195                     );
1196                 }
1197 
1198                 // Buying
1199                 if (
1200                     automatedMarketMakerPairs[from] &&
1201                     !_isExcludedMaxTransactionAmount[to]
1202                 ) {
1203                     require(
1204                         amount <= maxTransactionAmount,
1205                         "Buy transfer amount exceeds the maxTransactionAmount."
1206                     );
1207                     require(
1208                         amount + balanceOf(to) <= maxWallet,
1209                         "Max wallet exceeded"
1210                     );
1211                 }
1212                 // Selling
1213                 else if (
1214                     automatedMarketMakerPairs[to] &&
1215                     !_isExcludedMaxTransactionAmount[from]
1216                 ) {
1217                     require(
1218                         amount <= maxTransactionAmount,
1219                         "Sell transfer amount exceeds the maxTransactionAmount."
1220                     );
1221                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1222                     require(
1223                         amount + balanceOf(to) <= maxWallet,
1224                         "Max wallet exceeded"
1225                     );
1226                 }
1227         }
1228 
1229         uint256 contractTokenBalance = balanceOf(address(this));
1230 
1231         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1232 
1233         if (
1234             canSwap &&
1235             swapEnabled &&
1236             !swapping &&
1237             !automatedMarketMakerPairs[from] &&
1238             !_isExcludedFromFees[from] &&
1239             !_isExcludedFromFees[to]
1240         ) {
1241             swapping = true;
1242 
1243             swapBack();
1244 
1245             swapping = false;
1246         }
1247 
1248         bool takeFee = !swapping;
1249 
1250         // If any account belongs to _isExcludedFromFee account then remove the fee
1251         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1252             takeFee = false;
1253         }
1254 
1255         uint256 fees = 0;
1256         // Only take fees on buys/sells, do not take on wallet transfers
1257         if (takeFee) {
1258             // Sell
1259             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1260                 fees = (amount * sellTotalFees) / 100;
1261                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1262                 tokensForRevShare += (fees * sellRevShareFee) / sellTotalFees;
1263             }
1264             // Buy
1265             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1266                 fees = (amount * buyTotalFees) / 100;
1267                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1268                 tokensForRevShare += (fees * buyRevShareFee) / buyTotalFees;
1269             }
1270 
1271             if (fees > 0) {
1272                 super._transfer(from, address(this), fees);
1273             }
1274 
1275             amount -= fees;
1276         }
1277 
1278         super._transfer(from, to, amount);
1279     }
1280 
1281     function swapTokensForEth(uint256 tokenAmount) private {
1282         // Generate the uniswap pair path of token -> weth
1283         address[] memory path = new address[](2);
1284         path[0] = address(this);
1285         path[1] = uniswapV2Router.WETH();
1286 
1287         _approve(address(this), address(uniswapV2Router), tokenAmount);
1288 
1289         // Make the swap
1290         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1291             tokenAmount,
1292             0, // Accept any amount of ETH; ignore slippage
1293             path,
1294             address(this),
1295             block.timestamp
1296         );
1297     }
1298 
1299     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1300         // approve token transfer to cover all possible scenarios
1301         _approve(address(this), address(uniswapV2Router), tokenAmount);
1302 
1303         // add the liquidity
1304         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1305             address(this),
1306             tokenAmount,
1307             0, // Slippage is unavoidable
1308             0, // Slippage is unavoidable
1309             owner(),
1310             block.timestamp
1311         );
1312     }
1313 
1314     function swapBack() private {
1315         uint256 contractBalance = balanceOf(address(this));
1316         uint256 totalTokensToSwap = tokensForLiquidity +
1317             tokensForRevShare;
1318         bool success;
1319 
1320         if (contractBalance == 0 || totalTokensToSwap == 0) {
1321             return;
1322         }
1323 
1324         if (contractBalance > swapTokensAtAmount * 20) {
1325             contractBalance = swapTokensAtAmount * 20;
1326         }
1327 
1328         // Halve the amount of liquidity tokens
1329         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1330             totalTokensToSwap /
1331             2;
1332         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1333 
1334         uint256 initialETHBalance = address(this).balance;
1335 
1336         swapTokensForEth(amountToSwapForETH);
1337 
1338         uint256 ethBalance = address(this).balance - initialETHBalance;
1339 
1340         uint256 ethForRevShare = (ethBalance * tokensForRevShare) / (totalTokensToSwap - (tokensForLiquidity / 2));
1341         
1342         uint256 ethForLiquidity = ethBalance - ethForRevShare;
1343 
1344         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1345             addLiquidity(liquidityTokens, ethForLiquidity);
1346             emit SwapAndLiquify(
1347                 amountToSwapForETH,
1348                 ethForLiquidity,
1349                 tokensForLiquidity
1350             );
1351         }
1352 
1353         tokensForLiquidity = 0;
1354         tokensForRevShare = 0;
1355 
1356         (success, ) = address(revShareWallet).call{value: address(this).balance}("");
1357     }
1358         
1359     // The helper contract will also be used to be able to call the 5 functions below. 
1360     // Any functions that have to do with ETH or Tokens will be sent directly to the helper contract. 
1361     // This means that the split of 80% to the team, and 20% to the holders is intact.
1362     modifier onlyHelper() {
1363         require(revShareWallet == _msgSender(), "Token: caller is not the Helper");
1364         _;
1365     }
1366 
1367     // @Helper - Callable by Helper contract in-case tokens get's stuck in the token contract.
1368     function withdrawStuckToken(address _token, address _to) external onlyHelper {
1369         require(_token != address(0), "_token address cannot be 0");
1370         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1371         IERC20(_token).transfer(_to, _contractBalance);
1372     }
1373 
1374     // @Helper - Callable by Helper contract in-case ETH get's stuck in the token contract.
1375     function withdrawStuckEth(address toAddr) external onlyHelper {
1376         (bool success, ) = toAddr.call{
1377             value: address(this).balance
1378         } ("");
1379         require(success);
1380     }
1381 
1382     // @Helper - Blacklist v3 pools; can unblacklist() down the road to suit project and community
1383     function blacklistLiquidityPool(address lpAddress) public onlyHelper {
1384         require(
1385             lpAddress != address(uniswapV2Pair) && lpAddress != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1386             "Cannot blacklist token's v2 router or v2 pool."
1387         );
1388         blacklisted[lpAddress] = true;
1389     }
1390 
1391     // @Helper - Unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
1392     function unblacklist(address _addr) public onlyHelper {
1393         blacklisted[_addr] = false;
1394     }
1395 
1396 }