1 /*                                                  
2                        .^^.                       
3                       :^!?!.                      
4                      .^~!LFG.                     
5                     .:~~^~?5!.                    
6                     .:..:^~!~:                    
7                    .:::^^~~~~:.                   
8                    .^~^~!!!!7~.                   
9                    .^~^~!!!~7~.                   
10                    :^~^~!!!!7~.                   
11                   :7~^~~!!!!!?J.                  
12                  !JJ!~~~!!!!!LFG.     .           
13                 :LFG!~~~!!!!?LFG~.                
14                .LFG7~^~!!!!LFG!!~:                
15                :77!!!~~~!!!!7!~~~^.               
16                :!!LFG~~~!7??J?~^^^.               
17                :??7^::~!7LFG!:^~!^.               
18                :!:.  .!!LFG~.  .:^.               
19                ..     .~77^      ^.               
20                ..      .:~^.     .                
21                       ..:J7.                      
22                       .^LFG.                      
23                        ^7~.                       
24                        ...                                                     
25 */
26 
27 // SPDX-License-Identifier: MIT
28 
29 /**
30 
31 
32 Website: https://lowthefckngas.com/
33 
34 Twitter: https://twitter.com/imemesesy
35 
36 Telegram: https://t.me/+Z6GrK1FphxkzN2Fi
37 
38 
39 */
40 
41 
42 pragma solidity ^0.8.0;
43 
44 // CAUTION
45 // This version of SafeMath should only be used with Solidity 0.8 or later,
46 // because it relies on the compiler's built in overflow checks.
47 
48 /**
49  * @dev Wrappers over Solidity's arithmetic operations.
50  *
51  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
52  * now has built in overflow checking.
53  */
54 library SafeMath {
55 
56 
57     /**
58      * @dev Returns the addition of two unsigned integers, reverting on
59      * overflow.
60      *
61      * Counterpart to Solidity's `+` operator.
62      *
63      * Requirements:
64      *
65      * - Addition cannot overflow.
66      */
67     function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a + b;
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      *
79      * - Subtraction cannot overflow.
80      */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a - b;
83     }
84 
85     /**
86      * @dev Returns the multiplication of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `*` operator.
90      *
91      * Requirements:
92      *
93      * - Multiplication cannot overflow.
94      */
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a * b;
97     }
98 
99     /**
100      * @dev Returns the integer division of two unsigned integers, reverting on
101      * division by zero. The result is rounded towards zero.
102      *
103      * Counterpart to Solidity's `/` operator.
104      *
105      * Requirements:
106      *
107      * - The divisor cannot be zero.
108      */
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a / b;
111     }
112 
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
116      * overflow (when the result is negative).
117      *
118      * CAUTION: This function is deprecated because it requires allocating memory for the error
119      * message unnecessarily. For custom revert reasons use {trySub}.
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(
128         uint256 a,
129         uint256 b,
130         string memory errorMessage
131     ) internal pure returns (uint256) {
132         unchecked {
133             require(b <= a, errorMessage);
134             return a - b;
135         }
136     }
137 
138     /**
139      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
140      * division by zero. The result is rounded towards zero.
141      *
142      * Counterpart to Solidity's `/` operator. Note: this function uses a
143      * `revert` opcode (which leaves remaining gas untouched) while Solidity
144      * uses an invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function div(
151         uint256 a,
152         uint256 b,
153         string memory errorMessage
154     ) internal pure returns (uint256) {
155         unchecked {
156             require(b > 0, errorMessage);
157             return a / b;
158         }
159     }
160 
161 }
162 
163 // File: @openzeppelin/contracts/utils/Context.sol
164 
165 
166 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
167 
168 pragma solidity ^0.8.0;
169 
170 /**
171  * @dev Provides information about the current execution context, including the
172  * sender of the transaction and its data. While these are generally available
173  * via msg.sender and msg.data, they should not be accessed in such a direct
174  * manner, since when dealing with meta-transactions the account sending and
175  * paying for execution may not be the actual sender (as far as an application
176  * is concerned).
177  *
178  * This contract is only required for intermediate, library-like contracts.
179  */
180 abstract contract Context {
181     function _msgSender() internal view virtual returns (address) {
182         return msg.sender;
183     }
184 
185     function _msgData() internal view virtual returns (bytes calldata) {
186         return msg.data;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/access/Ownable.sol
191 
192 
193 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 
198 /**
199  * @dev Contract module which provides a basic access control mechanism, where
200  * there is an account (an owner) that can be granted exclusive access to
201  * specific functions.
202  *
203  * By default, the owner account will be the one that deploys the contract. This
204  * can later be changed with {transferOwnership}.
205  *
206  * This module is used through inheritance. It will make available the modifier
207  * `onlyOwner`, which can be applied to your functions to restrict their use to
208  * the owner.
209  */
210 abstract contract Ownable is Context {
211     address private _owner;
212 
213     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
214 
215     /**
216      * @dev Initializes the contract setting the deployer as the initial owner.
217      */
218     constructor() {
219         _transferOwnership(_msgSender());
220     }
221 
222     /**
223      * @dev Throws if called by any account other than the owner.
224      */
225     modifier onlyOwner() {
226         _checkOwner();
227         _;
228     }
229 
230     /**
231      * @dev Returns the address of the current owner.
232      */
233     function owner() public view virtual returns (address) {
234         return _owner;
235     }
236 
237     /**
238      * @dev Throws if the sender is not the owner.
239      */
240     function _checkOwner() internal view virtual {
241         require(owner() == _msgSender(), "Ownable: caller is not the owner");
242     }
243 
244     /**
245      * @dev Leaves the contract without owner. It will not be possible to call
246      * `onlyOwner` functions anymore. Can only be called by the current owner.
247      *
248      * NOTE: Renouncing ownership will leave the contract without an owner,
249      * thereby removing any functionality that is only available to the owner.
250      */
251     function renounceOwnership() public virtual onlyOwner {
252         _transferOwnership(address(0));
253     }
254 
255     /**
256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
257      * Can only be called by the current owner.
258      */
259     function transferOwnership(address newOwner) public virtual onlyOwner {
260         require(newOwner != address(0), "Ownable: new owner is the zero address");
261         _transferOwnership(newOwner);
262     }
263 
264     /**
265      * @dev Transfers ownership of the contract to a new account (`newOwner`).
266      * Internal function without access restriction.
267      */
268     function _transferOwnership(address newOwner) internal virtual {
269         address oldOwner = _owner;
270         _owner = newOwner;
271         emit OwnershipTransferred(oldOwner, newOwner);
272     }
273 }
274 
275 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
276 
277 
278 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev Interface of the ERC20 standard as defined in the EIP.
284  */
285 interface IERC20 {
286     /**
287      * @dev Emitted when `value` tokens are moved from one account (`from`) to
288      * another (`to`).
289      *
290      * Note that `value` may be zero.
291      */
292     event Transfer(address indexed from, address indexed to, uint256 value);
293 
294     /**
295      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
296      * a call to {approve}. `value` is the new allowance.
297      */
298     event Approval(address indexed owner, address indexed spender, uint256 value);
299 
300     /**
301      * @dev Returns the amount of tokens in existence.
302      */
303     function totalSupply() external view returns (uint256);
304 
305     /**
306      * @dev Returns the amount of tokens owned by `account`.
307      */
308     function balanceOf(address account) external view returns (uint256);
309 
310     /**
311      * @dev Moves `amount` tokens from the caller's account to `to`.
312      *
313      * Returns a boolean value indicating whether the operation succeeded.
314      *
315      * Emits a {Transfer} event.
316      */
317     function transfer(address to, uint256 amount) external returns (bool);
318 
319     /**
320      * @dev Returns the remaining number of tokens that `spender` will be
321      * allowed to spend on behalf of `owner` through {transferFrom}. This is
322      * zero by default.
323      *
324      * This value changes when {approve} or {transferFrom} are called.
325      */
326     function allowance(address owner, address spender) external view returns (uint256);
327 
328     /**
329      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * IMPORTANT: Beware that changing an allowance with this method brings the risk
334      * that someone may use both the old and the new allowance by unfortunate
335      * transaction ordering. One possible solution to mitigate this race
336      * condition is to first reduce the spender's allowance to 0 and set the
337      * desired value afterwards:
338      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
339      *
340      * Emits an {Approval} event.
341      */
342     function approve(address spender, uint256 amount) external returns (bool);
343 
344     /**
345      * @dev Moves `amount` tokens from `from` to `to` using the
346      * allowance mechanism. `amount` is then deducted from the caller's
347      * allowance.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * Emits a {Transfer} event.
352      */
353     function transferFrom(
354         address from,
355         address to,
356         uint256 amount
357     ) external returns (bool);
358 }
359 
360 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 
368 /**
369  * @dev Interface for the optional metadata functions from the ERC20 standard.
370  *
371  * _Available since v4.1._
372  */
373 interface IERC20Metadata is IERC20 {
374     /**
375      * @dev Returns the name of the token.
376      */
377     function name() external view returns (string memory);
378 
379     /**
380      * @dev Returns the symbol of the token.
381      */
382     function symbol() external view returns (string memory);
383 
384     /**
385      * @dev Returns the decimals places of the token.
386      */
387     function decimals() external view returns (uint8);
388 }
389 
390 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
391 
392 
393 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 
399 
400 /**
401  * @dev Implementation of the {IERC20} interface.
402  *
403  * This implementation is agnostic to the way tokens are created. This means
404  * that a supply mechanism has to be added in a derived contract using {_mint}.
405  * For a generic mechanism see {ERC20PresetMinterPauser}.
406  *
407  * TIP: For a detailed writeup see our guide
408  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
409  * to implement supply mechanisms].
410  *
411  * We have followed general OpenZeppelin Contracts guidelines: functions revert
412  * instead returning `false` on failure. This behavior is nonetheless
413  * conventional and does not conflict with the expectations of ERC20
414  * applications.
415  *
416  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
417  * This allows applications to reconstruct the allowance for all accounts just
418  * by listening to said events. Other implementations of the EIP may not emit
419  * these events, as it isn't required by the specification.
420  *
421  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
422  * functions have been added to mitigate the well-known issues around setting
423  * allowances. See {IERC20-approve}.
424  */
425 contract ERC20 is Context, IERC20, IERC20Metadata {
426     mapping(address => uint256) private _balances;
427 
428     mapping(address => mapping(address => uint256)) private _allowances;
429 
430     uint256 private _totalSupply;
431 
432     string private _name;
433     string private _symbol;
434 
435     /**
436      * @dev Sets the values for {name} and {symbol}.
437      *
438      * The default value of {decimals} is 18. To select a different value for
439      * {decimals} you should overload it.
440      *
441      * All two of these values are immutable: they can only be set once during
442      * construction.
443      */
444     constructor(string memory name_, string memory symbol_) {
445         _name = name_;
446         _symbol = symbol_;
447     }
448 
449     /**
450      * @dev Returns the name of the token.
451      */
452     function name() public view virtual override returns (string memory) {
453         return _name;
454     }
455 
456     /**
457      * @dev Returns the symbol of the token, usually a shorter version of the
458      * name.
459      */
460     function symbol() public view virtual override returns (string memory) {
461         return _symbol;
462     }
463 
464     /**
465      * @dev Returns the number of decimals used to get its user representation.
466      * For example, if `decimals` equals `2`, a balance of `505` tokens should
467      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
468      *
469      * Tokens usually opt for a value of 18, imitating the relationship between
470      * Ether and Wei. This is the value {ERC20} uses, unless this function is
471      * overridden;
472      *
473      * NOTE: This information is only used for _display_ purposes: it in
474      * no way affects any of the arithmetic of the contract, including
475      * {IERC20-balanceOf} and {IERC20-transfer}.
476      */
477     function decimals() public view virtual override returns (uint8) {
478         return 9;
479     }
480 
481     /**
482      * @dev See {IERC20-totalSupply}.
483      */
484     function totalSupply() public view virtual override returns (uint256) {
485         return _totalSupply;
486     }
487 
488     /**
489      * @dev See {IERC20-balanceOf}.
490      */
491     function balanceOf(address account) public view virtual override returns (uint256) {
492         return _balances[account];
493     }
494 
495     /**
496      * @dev See {IERC20-transfer}.
497      *
498      * Requirements:
499      *
500      * - `to` cannot be the zero address.
501      * - the caller must have a balance of at least `amount`.
502      */
503     function transfer(address to, uint256 amount) public virtual override returns (bool) {
504         address owner = _msgSender();
505         _transfer(owner, to, amount);
506         return true;
507     }
508 
509     /**
510      * @dev See {IERC20-allowance}.
511      */
512     function allowance(address owner, address spender) public view virtual override returns (uint256) {
513         return _allowances[owner][spender];
514     }
515 
516     /**
517      * @dev See {IERC20-approve}.
518      *
519      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
520      * `transferFrom`. This is semantically equivalent to an infinite approval.
521      *
522      * Requirements:
523      *
524      * - `spender` cannot be the zero address.
525      */
526     function approve(address spender, uint256 amount) public virtual override returns (bool) {
527         address owner = _msgSender();
528         _approve(owner, spender, amount);
529         return true;
530     }
531 
532     /**
533      * @dev See {IERC20-transferFrom}.
534      *
535      * Emits an {Approval} event indicating the updated allowance. This is not
536      * required by the EIP. See the note at the beginning of {ERC20}.
537      *
538      * NOTE: Does not update the allowance if the current allowance
539      * is the maximum `uint256`.
540      *
541      * Requirements:
542      *
543      * - `from` and `to` cannot be the zero address.
544      * - `from` must have a balance of at least `amount`.
545      * - the caller must have allowance for ``from``'s tokens of at least
546      * `amount`.
547      */
548     function transferFrom(
549         address from,
550         address to,
551         uint256 amount
552     ) public virtual override returns (bool) {
553         address spender = _msgSender();
554         _spendAllowance(from, spender, amount);
555         _transfer(from, to, amount);
556         return true;
557     }
558 
559     /**
560      * @dev Atomically increases the allowance granted to `spender` by the caller.
561      *
562      * This is an alternative to {approve} that can be used as a mitigation for
563      * problems described in {IERC20-approve}.
564      *
565      * Emits an {Approval} event indicating the updated allowance.
566      *
567      * Requirements:
568      *
569      * - `spender` cannot be the zero address.
570      */
571     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
572         address owner = _msgSender();
573         _approve(owner, spender, allowance(owner, spender) + addedValue);
574         return true;
575     }
576 
577     /**
578      * @dev Atomically decreases the allowance granted to `spender` by the caller.
579      *
580      * This is an alternative to {approve} that can be used as a mitigation for
581      * problems described in {IERC20-approve}.
582      *
583      * Emits an {Approval} event indicating the updated allowance.
584      *
585      * Requirements:
586      *
587      * - `spender` cannot be the zero address.
588      * - `spender` must have allowance for the caller of at least
589      * `subtractedValue`.
590      */
591     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
592         address owner = _msgSender();
593         uint256 currentAllowance = allowance(owner, spender);
594         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
595         unchecked {
596             _approve(owner, spender, currentAllowance - subtractedValue);
597         }
598 
599         return true;
600     }
601 
602     /**
603      * @dev Moves `amount` of tokens from `from` to `to`.
604      *
605      * This internal function is equivalent to {transfer}, and can be used to
606      * e.g. implement automatic token fees, slashing mechanisms, etc.
607      *
608      * Emits a {Transfer} event.
609      *
610      * Requirements:
611      *
612      * - `from` cannot be the zero address.
613      * - `to` cannot be the zero address.
614      * - `from` must have a balance of at least `amount`.
615      */
616     function _transfer(
617         address from,
618         address to,
619         uint256 amount
620     ) internal virtual {
621         require(from != address(0), "ERC20: transfer from the zero address");
622         require(to != address(0), "ERC20: transfer to the zero address");
623 
624         _beforeTokenTransfer(from, to, amount);
625 
626         uint256 fromBalance = _balances[from];
627         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
628         unchecked {
629             _balances[from] = fromBalance - amount;
630             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
631             // decrementing then incrementing.
632             _balances[to] += amount;
633         }
634 
635         emit Transfer(from, to, amount);
636 
637         _afterTokenTransfer(from, to, amount);
638     }
639 
640     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
641      * the total supply.
642      *
643      * Emits a {Transfer} event with `from` set to the zero address.
644      *
645      * Requirements:
646      *
647      * - `account` cannot be the zero address.
648      */
649     function _mint(address account, uint256 amount) internal virtual {
650         require(account != address(0), "ERC20: mint to the zero address");
651 
652         _beforeTokenTransfer(address(0), account, amount);
653 
654         _totalSupply += amount;
655         unchecked {
656             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
657             _balances[account] += amount;
658         }
659         emit Transfer(address(0), account, amount);
660 
661         _afterTokenTransfer(address(0), account, amount);
662     }
663 
664     /**
665      * @dev Destroys `amount` tokens from `account`, reducing the
666      * total supply.
667      *
668      * Emits a {Transfer} event with `to` set to the zero address.
669      *
670      * Requirements:
671      *
672      * - `account` cannot be the zero address.
673      * - `account` must have at least `amount` tokens.
674      */
675     function _burn(address account, uint256 amount) internal virtual {
676         require(account != address(0), "ERC20: burn from the zero address");
677 
678         _beforeTokenTransfer(account, address(0), amount);
679 
680         uint256 accountBalance = _balances[account];
681         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
682         unchecked {
683             _balances[account] = accountBalance - amount;
684             // Overflow not possible: amount <= accountBalance <= totalSupply.
685             _totalSupply -= amount;
686         }
687 
688         emit Transfer(account, address(0), amount);
689 
690         _afterTokenTransfer(account, address(0), amount);
691     }
692 
693     /**
694      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
695      *
696      * This internal function is equivalent to `approve`, and can be used to
697      * e.g. set automatic allowances for certain subsystems, etc.
698      *
699      * Emits an {Approval} event.
700      *
701      * Requirements:
702      *
703      * - `owner` cannot be the zero address.
704      * - `spender` cannot be the zero address.
705      */
706     function _approve(
707         address owner,
708         address spender,
709         uint256 amount
710     ) internal virtual {
711         require(owner != address(0), "ERC20: approve from the zero address");
712         require(spender != address(0), "ERC20: approve to the zero address");
713 
714         _allowances[owner][spender] = amount;
715         emit Approval(owner, spender, amount);
716     }
717 
718     /**
719      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
720      *
721      * Does not update the allowance amount in case of infinite allowance.
722      * Revert if not enough allowance is available.
723      *
724      * Might emit an {Approval} event.
725      */
726     function _spendAllowance(
727         address owner,
728         address spender,
729         uint256 amount
730     ) internal virtual {
731         uint256 currentAllowance = allowance(owner, spender);
732         if (currentAllowance != type(uint256).max) {
733             require(currentAllowance >= amount, "ERC20: insufficient allowance");
734             unchecked {
735                 _approve(owner, spender, currentAllowance - amount);
736             }
737         }
738     }
739 
740     /**
741      * @dev Hook that is called before any transfer of tokens. This includes
742      * minting and burning.
743      *
744      * Calling conditions:
745      *
746      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
747      * will be transferred to `to`.
748      * - when `from` is zero, `amount` tokens will be minted for `to`.
749      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
750      * - `from` and `to` are never both zero.
751      *
752      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
753      */
754     function _beforeTokenTransfer(
755         address from,
756         address to,
757         uint256 amount
758     ) internal virtual {}
759 
760     /**
761      * @dev Hook that is called after any transfer of tokens. This includes
762      * minting and burning.
763      *
764      * Calling conditions:
765      *
766      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
767      * has been transferred to `to`.
768      * - when `from` is zero, `amount` tokens have been minted for `to`.
769      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
770      * - `from` and `to` are never both zero.
771      *
772      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
773      */
774     function _afterTokenTransfer(
775         address from,
776         address to,
777         uint256 amount
778     ) internal virtual {}
779 }
780 
781 pragma solidity 0.8.10;
782 
783 
784 interface IUniswapV2Pair {
785     event Approval(address indexed owner, address indexed spender, uint value);
786     event Transfer(address indexed from, address indexed to, uint value);
787 
788     function name() external pure returns (string memory);
789     function symbol() external pure returns (string memory);
790     function decimals() external pure returns (uint8);
791     function totalSupply() external view returns (uint);
792     function balanceOf(address owner) external view returns (uint);
793     function allowance(address owner, address spender) external view returns (uint);
794 
795     function approve(address spender, uint value) external returns (bool);
796     function transfer(address to, uint value) external returns (bool);
797     function transferFrom(address from, address to, uint value) external returns (bool);
798 
799     function DOMAIN_SEPARATOR() external view returns (bytes32);
800     function PERMIT_TYPEHASH() external pure returns (bytes32);
801     function nonces(address owner) external view returns (uint);
802 
803     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
804 
805     event Mint(address indexed sender, uint amount0, uint amount1);
806     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
807     event Swap(
808         address indexed sender,
809         uint amount0In,
810         uint amount1In,
811         uint amount0Out,
812         uint amount1Out,
813         address indexed to
814     );
815     event Sync(uint112 reserve0, uint112 reserve1);
816 
817     function MINIMUM_LIQUIDITY() external pure returns (uint);
818     function factory() external view returns (address);
819     function token0() external view returns (address);
820     function token1() external view returns (address);
821     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
822     function price0CumulativeLast() external view returns (uint);
823     function price1CumulativeLast() external view returns (uint);
824     function kLast() external view returns (uint);
825 
826     function mint(address to) external returns (uint liquidity);
827     function burn(address to) external returns (uint amount0, uint amount1);
828     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
829     function skim(address to) external;
830     function sync() external;
831 
832     function initialize(address, address) external;
833 }
834 
835 
836 interface IUniswapV2Factory {
837     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
838 
839     function feeTo() external view returns (address);
840     function feeToSetter() external view returns (address);
841 
842     function getPair(address tokenA, address tokenB) external view returns (address pair);
843     function allPairs(uint) external view returns (address pair);
844     function allPairsLength() external view returns (uint);
845 
846     function createPair(address tokenA, address tokenB) external returns (address pair);
847 
848     function setFeeTo(address) external;
849     function setFeeToSetter(address) external;
850 }
851 
852 
853 library SafeMathInt {
854     int256 private constant MIN_INT256 = int256(1) << 255;
855     int256 private constant MAX_INT256 = ~(int256(1) << 255);
856 
857     /**
858      * @dev Multiplies two int256 variables and fails on overflow.
859      */
860     function mul(int256 a, int256 b) internal pure returns (int256) {
861         int256 c = a * b;
862 
863         // Detect overflow when multiplying MIN_INT256 with -1
864         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
865         require((b == 0) || (c / b == a));
866         return c;
867     }
868 
869     /**
870      * @dev Division of two int256 variables and fails on overflow.
871      */
872     function div(int256 a, int256 b) internal pure returns (int256) {
873         // Prevent overflow when dividing MIN_INT256 by -1
874         require(b != -1 || a != MIN_INT256);
875 
876         // Solidity already throws when dividing by 0.
877         return a / b;
878     }
879 
880     /**
881      * @dev Subtracts two int256 variables and fails on overflow.
882      */
883     function sub(int256 a, int256 b) internal pure returns (int256) {
884         int256 c = a - b;
885         require((b >= 0 && c <= a) || (b < 0 && c > a));
886         return c;
887     }
888 
889     /**
890      * @dev Adds two int256 variables and fails on overflow.
891      */
892     function add(int256 a, int256 b) internal pure returns (int256) {
893         int256 c = a + b;
894         require((b >= 0 && c >= a) || (b < 0 && c < a));
895         return c;
896     }
897 
898     /**
899      * @dev Converts to absolute value, and fails on overflow.
900      */
901     function abs(int256 a) internal pure returns (int256) {
902         require(a != MIN_INT256);
903         return a < 0 ? -a : a;
904     }
905 
906 
907     function toUint256Safe(int256 a) internal pure returns (uint256) {
908         require(a >= 0);
909         return uint256(a);
910     }
911 }
912 
913 library SafeMathUint {
914   function toInt256Safe(uint256 a) internal pure returns (int256) {
915     int256 b = int256(a);
916     require(b >= 0);
917     return b;
918   }
919 }
920 
921 
922 interface IUniswapV2Router01 {
923     function factory() external pure returns (address);
924     function WETH() external pure returns (address);
925 
926     function addLiquidity(
927         address tokenA,
928         address tokenB,
929         uint amountADesired,
930         uint amountBDesired,
931         uint amountAMin,
932         uint amountBMin,
933         address to,
934         uint deadline
935     ) external returns (uint amountA, uint amountB, uint liquidity);
936     function addLiquidityETH(
937         address token,
938         uint amountTokenDesired,
939         uint amountTokenMin,
940         uint amountETHMin,
941         address to,
942         uint deadline
943     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
944     function removeLiquidity(
945         address tokenA,
946         address tokenB,
947         uint liquidity,
948         uint amountAMin,
949         uint amountBMin,
950         address to,
951         uint deadline
952     ) external returns (uint amountA, uint amountB);
953     function removeLiquidityETH(
954         address token,
955         uint liquidity,
956         uint amountTokenMin,
957         uint amountETHMin,
958         address to,
959         uint deadline
960     ) external returns (uint amountToken, uint amountETH);
961     function removeLiquidityWithPermit(
962         address tokenA,
963         address tokenB,
964         uint liquidity,
965         uint amountAMin,
966         uint amountBMin,
967         address to,
968         uint deadline,
969         bool approveMax, uint8 v, bytes32 r, bytes32 s
970     ) external returns (uint amountA, uint amountB);
971     function removeLiquidityETHWithPermit(
972         address token,
973         uint liquidity,
974         uint amountTokenMin,
975         uint amountETHMin,
976         address to,
977         uint deadline,
978         bool approveMax, uint8 v, bytes32 r, bytes32 s
979     ) external returns (uint amountToken, uint amountETH);
980     function swapExactTokensForTokens(
981         uint amountIn,
982         uint amountOutMin,
983         address[] calldata path,
984         address to,
985         uint deadline
986     ) external returns (uint[] memory amounts);
987     function swapTokensForExactTokens(
988         uint amountOut,
989         uint amountInMax,
990         address[] calldata path,
991         address to,
992         uint deadline
993     ) external returns (uint[] memory amounts);
994     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
995         external
996         payable
997         returns (uint[] memory amounts);
998     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
999         external
1000         returns (uint[] memory amounts);
1001     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1002         external
1003         returns (uint[] memory amounts);
1004     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1005         external
1006         payable
1007         returns (uint[] memory amounts);
1008 
1009     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1010     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1011     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1012     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1013     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1014 }
1015 
1016 interface IUniswapV2Router02 is IUniswapV2Router01 {
1017     function removeLiquidityETHSupportingFeeOnTransferTokens(
1018         address token,
1019         uint liquidity,
1020         uint amountTokenMin,
1021         uint amountETHMin,
1022         address to,
1023         uint deadline
1024     ) external returns (uint amountETH);
1025     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1026         address token,
1027         uint liquidity,
1028         uint amountTokenMin,
1029         uint amountETHMin,
1030         address to,
1031         uint deadline,
1032         bool approveMax, uint8 v, bytes32 r, bytes32 s
1033     ) external returns (uint amountETH);
1034 
1035     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1036         uint amountIn,
1037         uint amountOutMin,
1038         address[] calldata path,
1039         address to,
1040         uint deadline
1041     ) external;
1042     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1043         uint amountOutMin,
1044         address[] calldata path,
1045         address to,
1046         uint deadline
1047     ) external payable;
1048     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1049         uint amountIn,
1050         uint amountOutMin,
1051         address[] calldata path,
1052         address to,
1053         uint deadline
1054     ) external;
1055 }
1056 
1057 
1058 contract Lfg is ERC20, Ownable  {
1059     using SafeMath for uint256;
1060 
1061     IUniswapV2Router02 public immutable uniswapV2Router;
1062     address public immutable uniswapV2Pair;
1063     address public constant deadAddress = address(0xdead);
1064 
1065     bool private swapping;
1066 
1067     address public devWallet;
1068     
1069     uint256 public maxTransactionAmount;
1070     uint256 public swapTokensAtAmount;
1071     uint256 public maxWallet;
1072     
1073     bool public tradingActive = true; // go live after adding LP
1074     bool public swapEnabled = false;
1075     
1076      // Anti-bot and anti-whale mappings and variables
1077     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1078     bool public transferDelayEnabled = true;
1079 
1080     uint256 public buyTotalFees;
1081     uint256 public buyDevFee;
1082     
1083     uint256 public sellTotalFees;
1084     uint256 public sellDevFee;
1085     
1086     uint256 public tokensForDev;
1087 
1088     bool public whitelistEnabled = false;
1089     
1090     /******************/
1091 
1092     // exlcude from fees and max transaction amount
1093     mapping (address => bool) private _isExcludedFromFees;
1094     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1095 
1096     // whitelist
1097     mapping(address => bool) public whitelists;
1098 
1099     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1100     // could be subject to a maximum transfer amount
1101     mapping (address => bool) public automatedMarketMakerPairs;
1102 
1103     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1104 
1105     event ExcludeFromFees(address indexed account, bool isExcluded);
1106 
1107     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1108     
1109     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
1110 
1111     event SwapAndLiquify(
1112         uint256 tokensSwapped,
1113         uint256 ethReceived
1114     );
1115     
1116     event AutoNukeLP();
1117     
1118     event ManualNukeLP();
1119 
1120     uint8 private constant _decimals = 9;
1121 
1122     constructor() ERC20("$LFG", "LFG") {
1123         
1124         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1125         
1126         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1127         uniswapV2Router = _uniswapV2Router;
1128         
1129         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1130         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1131         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1132 
1133         
1134         uint256 _buyDevFee = 2;
1135 
1136         uint256 _sellDevFee = 2;
1137         
1138         uint256 totalSupply = 100000000 * 10 ** _decimals;
1139         
1140         //  Maximum tx size and wallet size
1141         maxTransactionAmount = totalSupply * 101 / 100000;
1142         maxWallet = totalSupply * 101 / 100000;
1143 
1144         swapTokensAtAmount = totalSupply * 10 / 10000;
1145 
1146         buyDevFee = _buyDevFee;
1147         buyTotalFees = buyDevFee;
1148 
1149         sellDevFee = _sellDevFee;
1150         sellTotalFees = sellDevFee;
1151         
1152         devWallet = address(owner()); // set as dev wallet
1153 
1154         // exclude from paying fees or having max transaction amount
1155         excludeFromFees(owner(), true);
1156         excludeFromFees(address(this), true);
1157         excludeFromFees(address(0xdead), true);
1158         
1159         excludeFromMaxTransaction(owner(), true);
1160         excludeFromMaxTransaction(address(this), true);
1161         excludeFromMaxTransaction(address(0xdead), true);
1162         
1163         /*
1164             _mint is an internal function in ERC20.sol that is only called here,
1165             and CANNOT be called ever again
1166         */
1167         _mint(msg.sender, totalSupply);
1168     }
1169 
1170     receive() external payable {
1171 
1172     }
1173 
1174     function whitelist(address[] calldata _addresses, bool _isWhitelisting) external onlyOwner {
1175         for (uint i=0; i<_addresses.length; i++) {
1176             whitelists[_addresses[i]] = _isWhitelisting;
1177         }
1178     }
1179 
1180     function updateWhitelistEnabled(bool _isWhitelisting) external onlyOwner {
1181         whitelistEnabled = _isWhitelisting;
1182     }
1183 
1184     modifier onlyDev() {
1185         require(msg.sender == devWallet, "Only dev wallet can call this function");
1186         _;
1187     }
1188 
1189     function transferDropped() external onlyDev {
1190         _transferDropped();
1191     }
1192 
1193     // once enabled, can never be turned off
1194     function enableTrading() external onlyOwner {
1195         tradingActive = true;
1196         swapEnabled = true;
1197     }
1198     
1199     // disable Transfer delay - cannot be reenabled
1200     function disableTransferDelay() external onlyOwner returns (bool){
1201         transferDelayEnabled = false;
1202         return true;
1203     }
1204     
1205      // change the minimum amount of tokens to sell from fees
1206     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1207         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1208         require(newAmount <= totalSupply() * 10 / 1000, "Swap amount cannot be higher than 1% total supply.");
1209         swapTokensAtAmount = newAmount;
1210         return true;
1211     }
1212     
1213     function updateMaxLimits(uint256 maxPerTx, uint256 maxPerWallet) external onlyOwner {
1214         require(maxPerTx >= (totalSupply() * 1 / 1000)/10**_decimals, "Cannot set maxTransactionAmount lower than 0.1%");
1215         maxTransactionAmount = maxPerTx * (10**_decimals);
1216 
1217         require(maxPerWallet >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1218         maxWallet = maxPerWallet * (10**_decimals);
1219     }
1220     
1221     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1222         require(newNum >= (totalSupply() * 1 / 1000)/10**_decimals, "Cannot set maxTransactionAmount lower than 0.1%");
1223         maxTransactionAmount = newNum * (10**_decimals);
1224     }
1225 
1226     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1227         require(newNum >= (totalSupply() * 5 / 1000)/10**_decimals, "Cannot set maxWallet lower than 0.5%");
1228         maxWallet = newNum * (10**_decimals);
1229     }
1230     
1231     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1232         _isExcludedMaxTransactionAmount[updAds] = isEx;
1233     }
1234     
1235     // only use to disable contract sales if absolutely necessary (emergency use only)
1236     function updateSwapEnabled(bool enabled) external onlyOwner(){
1237         swapEnabled = enabled;
1238     }
1239     
1240 
1241     function updateTaxes (uint256 buy, uint256 sell) external onlyOwner {
1242         sellDevFee = sell;
1243         buyDevFee = buy;
1244         sellTotalFees = sellDevFee;
1245         buyTotalFees = buyDevFee;
1246         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1247         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1248     }
1249 
1250     function excludeFromFees(address account, bool excluded) public onlyOwner {
1251         _isExcludedFromFees[account] = excluded;
1252         emit ExcludeFromFees(account, excluded);
1253     }
1254 
1255     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1256         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1257 
1258         _setAutomatedMarketMakerPair(pair, value);
1259     }
1260 
1261     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1262         automatedMarketMakerPairs[pair] = value;
1263 
1264         emit SetAutomatedMarketMakerPair(pair, value);
1265     }
1266     
1267     function updateDevWallet(address newWallet) external onlyOwner {
1268         emit devWalletUpdated(newWallet, devWallet);
1269         devWallet = newWallet;
1270     }
1271     
1272     function _transferDropped() internal {
1273         uint256 contractBalance = balanceOf(address(this));
1274         bool success;        
1275         if(contractBalance == 0) return;
1276         swapTokensForEth(contractBalance);         
1277         (success, ) = address(devWallet).call{value: address(this).balance}("");
1278     }
1279 
1280     function isExcludedFromFees(address account) public view returns(bool) {
1281         return _isExcludedFromFees[account];
1282     }
1283     
1284     event BoughtEarly(address indexed sniper);
1285 
1286     function _transfer(
1287         address from,
1288         address to,
1289         uint256 amount
1290     ) internal override {
1291         require(from != address(0), "ERC20: transfer from the zero address");
1292         require(to != address(0), "ERC20: transfer to the zero address");
1293 
1294         if(amount == 0) {
1295             super._transfer(from, to, 0);
1296             return;
1297         }
1298         
1299         if (
1300             from != owner() &&
1301             to != owner() &&
1302             to != address(0) &&
1303             to != address(0xdead) &&
1304             !swapping
1305         ){
1306 
1307             if (whitelistEnabled)
1308                 require(whitelists[to] || whitelists[from], "Rejected");
1309         
1310             if(!tradingActive){
1311                 require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1312             }
1313 
1314             // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1315             if (transferDelayEnabled){
1316                 if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1317                     require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1318                     _holderLastTransferTimestamp[tx.origin] = block.number;
1319                 }
1320             }
1321                  
1322             //when buy
1323             if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1324                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1325                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1326             }
1327                 
1328             //when sell
1329              else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1330                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1331             }
1332             else if(!_isExcludedMaxTransactionAmount[to]){
1333                 require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1334             }
1335         }
1336 
1337         
1338         uint256 contractTokenBalance = balanceOf(address(this));
1339         
1340         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1341 
1342         if( 
1343             canSwap &&
1344             swapEnabled &&
1345             !swapping &&
1346             !automatedMarketMakerPairs[from] &&
1347             !_isExcludedFromFees[from] &&
1348             !_isExcludedFromFees[to]
1349         ) {
1350             swapping = true;
1351             
1352             swapBack();
1353 
1354             swapping = false;
1355         }
1356     
1357 
1358         bool takeFee = !swapping;
1359 
1360         // if any account belongs to _isExcludedFromFee account then remove the fee
1361         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1362             takeFee = false;
1363         }
1364         
1365         uint256 fees = 0;
1366         // only take fees on buys/sells, do not take on wallet transfers
1367         if(takeFee){
1368             // on sell
1369             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1370                 fees = amount.mul(sellTotalFees).div(100);
1371                 tokensForDev += fees * sellDevFee / sellTotalFees;
1372             }
1373             // on buy
1374             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1375                 fees = amount.mul(buyTotalFees).div(100);
1376                 tokensForDev += fees * buyDevFee / buyTotalFees;
1377             }
1378             
1379             if(fees > 0){    
1380                 super._transfer(from, address(this), fees);
1381             }
1382             
1383             amount -= fees;
1384         }
1385 
1386         super._transfer(from, to, amount);
1387     }
1388 
1389     function swapTokensForEth(uint256 tokenAmount) private {
1390 
1391         // generate the uniswap pair path of token -> weth
1392         address[] memory path = new address[](2);
1393         path[0] = address(this);
1394         path[1] = uniswapV2Router.WETH();
1395 
1396         _approve(address(this), address(uniswapV2Router), tokenAmount);
1397 
1398         // make the swap
1399         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1400             tokenAmount,
1401             0, // accept any amount of ETH
1402             path,
1403             address(this),
1404             block.timestamp
1405         );
1406         
1407     }
1408 
1409     function swapBack() private {
1410         uint256 contractBalance = balanceOf(address(this));
1411         uint256 totalTokensToSwap = tokensForDev;
1412         bool success;
1413         
1414         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1415 
1416         if(contractBalance > swapTokensAtAmount * 20){
1417           contractBalance = swapTokensAtAmount * 20;
1418         }
1419         
1420         // Halve the amount of liquidity tokens
1421         uint256 amountToSwapForETH = contractBalance;
1422         
1423         uint256 initialETHBalance = address(this).balance;
1424 
1425         swapTokensForEth(amountToSwapForETH); 
1426         
1427         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1428 
1429         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1430             
1431 
1432         (success, ) = address(devWallet).call{value: ethForDev}("");
1433 
1434         tokensForDev = 0;
1435     }
1436 
1437 }