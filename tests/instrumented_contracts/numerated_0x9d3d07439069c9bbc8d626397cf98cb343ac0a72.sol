1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity ^0.7.0;
3 
4 /*
5 /* Project : TMN Global Token */
6 /* Description : ERC 20 Standard Token */
7 /* Project Website : https://tmn-global.com */
8 /* Author : TMN Global
9  *
10  * This contract is only required for intermediate, library-like contracts.
11  */
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
25 pragma solidity ^0.7.0;
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount)
49         external
50         returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender)
60         external
61         view
62         returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(
90         address sender,
91         address recipient,
92         uint256 amount
93     ) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(
108         address indexed owner,
109         address indexed spender,
110         uint256 value
111     );
112 }
113 
114 // File: @openzeppelin/contracts/math/SafeMath.sol
115 
116 pragma solidity ^0.7.0;
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(
174         uint256 a,
175         uint256 b,
176         string memory errorMessage
177     ) internal pure returns (uint256) {
178         require(b <= a, errorMessage);
179         uint256 c = a - b;
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         return div(a, b, "SafeMath: division by zero");
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(
237         uint256 a,
238         uint256 b,
239         string memory errorMessage
240     ) internal pure returns (uint256) {
241         require(b > 0, errorMessage);
242         uint256 c = a / b;
243         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
261         return mod(a, b, "SafeMath: modulo by zero");
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * Reverts with custom message when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function mod(
277         uint256 a,
278         uint256 b,
279         string memory errorMessage
280     ) internal pure returns (uint256) {
281         require(b != 0, errorMessage);
282         return a % b;
283     }
284 }
285 
286 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
287 
288 pragma solidity ^0.7.0;
289 
290 /**
291  * @dev Implementation of the {IERC20} interface.
292  *
293  * This implementation is agnostic to the way tokens are created. This means
294  * that a supply mechanism has to be added in a derived contract using {_mint}.
295  * For a generic mechanism see {ERC20PresetMinterPauser}.
296  *
297  * TIP: For a detailed writeup see our guide
298  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
299  * to implement supply mechanisms].
300  *
301  * We have followed general OpenZeppelin guidelines: functions revert instead
302  * of returning `false` on failure. This behavior is nonetheless conventional
303  * and does not conflict with the expectations of ERC20 applications.
304  *
305  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
306  * This allows applications to reconstruct the allowance for all accounts just
307  * by listening to said events. Other implementations of the EIP may not emit
308  * these events, as it isn't required by the specification.
309  *
310  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
311  * functions have been added to mitigate the well-known issues around setting
312  * allowances. See {IERC20-approve}.
313  */
314 contract ERC20 is Context, IERC20 {
315     using SafeMath for uint256;
316 
317     mapping(address => uint256) public _balances;
318 
319     mapping(address => mapping(address => uint256)) private _allowances;
320 
321     uint256 private _totalSupply;
322     string private _name;
323     string private _symbol;
324     bool public _mintable;
325     uint8 private _decimals;
326 
327     /**
328      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
329      * a default value of 18.
330      *
331      * To select a different value for {decimals}, use {_setupDecimals}.
332      *
333      * All three of these values are immutable: they can only be set once during
334      * construction.
335      */
336     constructor(string memory name_, string memory symbol_) {
337         _name = name_;
338         _symbol = symbol_;
339         _decimals = 18;
340         _mintable = true;
341     }
342 
343     /**
344      * @dev Returns the name of the token.
345      */
346     function name() public view returns (string memory) {
347         return _name;
348     }
349 
350     /**
351      * @dev Returns the symbol of the token, usually a shorter version of the
352      * name.
353      */
354     function symbol() public view returns (string memory) {
355         return _symbol;
356     }
357 
358     /**
359      * @dev Returns the number of decimals used to get its user representation.
360      * For example, if `decimals` equals `2`, a balance of `505` tokens should
361      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
362      *
363      * Tokens usually opt for a value of 18, imitating the relationship between
364      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
365      * called.
366      *
367      * NOTE: This information is only used for _display_ purposes: it in
368      * no way affects any of the arithmetic of the contract, including
369      * {IERC20-balanceOf} and {IERC20-transfer}.
370      */
371     function decimals() public view returns (uint8) {
372         return _decimals;
373     }
374 
375     /**
376      * @dev See {IERC20-totalSupply}.
377      */
378     function totalSupply() public view override returns (uint256) {
379         return _totalSupply;
380     }
381 
382     /**
383      * @dev See {IERC20-balanceOf}.
384      */
385     function balanceOf(address account) public view override returns (uint256) {
386         return _balances[account];
387     }
388 
389     /**
390      * @dev See {IERC20-transfer}.
391      *
392      * Requirements:
393      *
394      * - `recipient` cannot be the zero address.
395      * - the caller must have a balance of at least `amount`.
396      */
397     function transfer(address recipient, uint256 amount)
398         public
399         virtual
400         override
401         returns (bool)
402     {
403         _transfer(_msgSender(), recipient, amount);
404         return true;
405     }
406 
407     /**
408      * @dev See {IERC20-allowance}.
409      */
410     function allowance(address owner, address spender)
411         public
412         view
413         virtual
414         override
415         returns (uint256)
416     {
417         return _allowances[owner][spender];
418     }
419 
420     /**
421      * @dev See {IERC20-approve}.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      */
427     function approve(address spender, uint256 amount)
428         public
429         virtual
430         override
431         returns (bool)
432     {
433         _approve(_msgSender(), spender, amount);
434         return true;
435     }
436 
437     /**
438      * @dev See {IERC20-transferFrom}.
439      *
440      * Emits an {Approval} event indicating the updated allowance. This is not
441      * required by the EIP. See the note at the beginning of {ERC20}.
442      *
443      * Requirements:
444      *
445      * - `sender` and `recipient` cannot be the zero address.
446      * - `sender` must have a balance of at least `amount`.
447      * - the caller must have allowance for ``sender``'s tokens of at least
448      * `amount`.
449      */
450     function transferFrom(
451         address sender,
452         address recipient,
453         uint256 amount
454     ) public virtual override returns (bool) {
455         _transfer(sender, recipient, amount);
456         _approve(
457             sender,
458             _msgSender(),
459             _allowances[sender][_msgSender()].sub(
460                 amount,
461                 "ERC20: transfer amount exceeds allowance"
462             )
463         );
464         return true;
465     }
466 
467     /**
468      * @dev Atomically increases the allowance granted to `spender` by the caller.
469      *
470      * This is an alternative to {approve} that can be used as a mitigation for
471      * problems described in {IERC20-approve}.
472      *
473      * Emits an {Approval} event indicating the updated allowance.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      */
479     function increaseAllowance(address spender, uint256 addedValue)
480         public
481         virtual
482         returns (bool)
483     {
484         _approve(
485             _msgSender(),
486             spender,
487             _allowances[_msgSender()][spender].add(addedValue)
488         );
489         return true;
490     }
491 
492     /**
493      * @dev Atomically decreases the allowance granted to `spender` by the caller.
494      *
495      * This is an alternative to {approve} that can be used as a mitigation for
496      * problems described in {IERC20-approve}.
497      *
498      * Emits an {Approval} event indicating the updated allowance.
499      *
500      * Requirements:
501      *
502      * - `spender` cannot be the zero address.
503      * - `spender` must have allowance for the caller of at least
504      * `subtractedValue`.
505      */
506     function decreaseAllowance(address spender, uint256 subtractedValue)
507         public
508         virtual
509         returns (bool)
510     {
511         _approve(
512             _msgSender(),
513             spender,
514             _allowances[_msgSender()][spender].sub(
515                 subtractedValue,
516                 "ERC20: decreased allowance below zero"
517             )
518         );
519         return true;
520     }
521 
522     /**
523      * @dev Moves tokens `amount` from `sender` to `recipient`.
524      *
525      * This is internal function is equivalent to {transfer}, and can be used to
526      * e.g. implement automatic token fees, slashing mechanisms, etc.
527      *
528      * Emits a {Transfer} event.
529      *
530      * Requirements:
531      *
532      * - `sender` cannot be the zero address.
533      * - `recipient` cannot be the zero address.
534      * - `sender` must have a balance of at least `amount`.
535      */
536     function _transfer(
537         address sender,
538         address recipient,
539         uint256 amount
540     ) internal virtual {
541         require(sender != address(0), "ERC20: transfer from the zero address");
542         require(recipient != address(0), "ERC20: transfer to the zero address");
543 
544         _beforeTokenTransfer(sender, recipient, amount);
545 
546         _balances[sender] = _balances[sender].sub(
547             amount,
548             "ERC20: transfer amount exceeds balance"
549         );
550         _balances[recipient] = _balances[recipient].add(amount);
551         emit Transfer(sender, recipient, amount);
552     }
553 
554     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
555      * the total supply.
556      *
557      * Emits a {Transfer} event with `from` set to the zero address.
558      *
559      * Requirements:
560      *
561      * - `to` cannot be the zero address.
562      */
563     function _mint(address account, uint256 amount) internal virtual {
564         require(account != address(0), "ERC20: mint to the zero address");
565         require(_mintable);
566         _beforeTokenTransfer(address(0), account, amount);
567 
568         _totalSupply = _totalSupply.add(amount);
569         _balances[account] = _balances[account].add(amount);
570         _mintable = false;
571         emit Transfer(address(0), account, amount);
572     }
573 
574     /**
575      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
576      *
577      * This internal function is equivalent to `approve`, and can be used to
578      * e.g. set automatic allowances for certain subsystems, etc.
579      *
580      * Emits an {Approval} event.
581      *
582      * Requirements:
583      *
584      * - `owner` cannot be the zero address.
585      * - `spender` cannot be the zero address.
586      */
587     function _approve(
588         address owner,
589         address spender,
590         uint256 amount
591     ) internal virtual {
592         require(owner != address(0), "ERC20: approve from the zero address");
593         require(spender != address(0), "ERC20: approve to the zero address");
594 
595         _allowances[owner][spender] = amount;
596         emit Approval(owner, spender, amount);
597     }
598 
599     /**
600      * @dev Sets {decimals} to a value other than the default one of 18.
601      *
602      * WARNING: This function should only be called from the constructor. Most
603      * applications that interact with token contracts will not expect
604      * {decimals} to ever change, and may work incorrectly if it does.
605      */
606     function _setupDecimals(uint8 decimals_) internal {
607         _decimals = decimals_;
608     }
609 
610     /**
611      * @dev Hook that is called before any transfer of tokens. This includes
612      * minting and burning.
613      *
614      * Calling conditions:
615      *
616      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
617      * will be to transferred to `to`.
618      * - when `from` is zero, `amount` tokens will be minted for `to`.
619      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
620      * - `from` and `to` are never both zero.
621      *
622      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
623      */
624     function _beforeTokenTransfer(
625         address from,
626         address to,
627         uint256 amount
628     ) internal virtual {}
629 }
630 
631 pragma solidity ^0.7.0;
632 
633 library SafeERC20 {
634     using SafeMath for uint256;
635     using Address for address;
636 
637     function safeTransfer(
638         IERC20 token,
639         address to,
640         uint256 value
641     ) internal {
642         _callOptionalReturn(
643             token,
644             abi.encodeWithSelector(token.transfer.selector, to, value)
645         );
646     }
647 
648     function safeTransferFrom(
649         IERC20 token,
650         address from,
651         address to,
652         uint256 value
653     ) internal {
654         _callOptionalReturn(
655             token,
656             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
657         );
658     }
659 
660     /**
661      * @dev Deprecated. This function has issues similar to the ones found in
662      * {IERC20-approve}, and its usage is discouraged.
663      *
664      * Whenever possible, use {safeIncreaseAllowance} and
665      * {safeDecreaseAllowance} instead.
666      */
667     function safeApprove(
668         IERC20 token,
669         address spender,
670         uint256 value
671     ) internal {
672         // safeApprove should only be called when setting an initial allowance,
673         // or when resetting it to zero. To increase and decrease it, use
674         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
675         // solhint-disable-next-line max-line-length
676         require(
677             (value == 0) || (token.allowance(address(this), spender) == 0),
678             "SafeERC20: approve from non-zero to non-zero allowance"
679         );
680         _callOptionalReturn(
681             token,
682             abi.encodeWithSelector(token.approve.selector, spender, value)
683         );
684     }
685 
686     function safeIncreaseAllowance(
687         IERC20 token,
688         address spender,
689         uint256 value
690     ) internal {
691         uint256 newAllowance =
692             token.allowance(address(this), spender).add(value);
693         _callOptionalReturn(
694             token,
695             abi.encodeWithSelector(
696                 token.approve.selector,
697                 spender,
698                 newAllowance
699             )
700         );
701     }
702 
703     function safeDecreaseAllowance(
704         IERC20 token,
705         address spender,
706         uint256 value
707     ) internal {
708         uint256 newAllowance =
709             token.allowance(address(this), spender).sub(
710                 value,
711                 "SafeERC20: decreased allowance below zero"
712             );
713         _callOptionalReturn(
714             token,
715             abi.encodeWithSelector(
716                 token.approve.selector,
717                 spender,
718                 newAllowance
719             )
720         );
721     }
722 
723     /**
724      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
725      * on the return value: the return value is optional (but if data is returned, it must not be false).
726      * @param token The token targeted by the call.
727      * @param data The call data (encoded using abi.encode or one of its variants).
728      */
729     function _callOptionalReturn(IERC20 token, bytes memory data) private {
730         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
731         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
732         // the target address contains contract code and also asserts for success in the low-level call.
733 
734         bytes memory returndata =
735             address(token).functionCall(
736                 data,
737                 "SafeERC20: low-level call failed"
738             );
739         if (returndata.length > 0) {
740             // Return data is optional
741             // solhint-disable-next-line max-line-length
742             require(
743                 abi.decode(returndata, (bool)),
744                 "SafeERC20: ERC20 operation did not succeed"
745             );
746         }
747     }
748 }
749 
750 pragma solidity >=0.6.2 <0.8.0;
751 
752 /**
753  * @dev Collection of functions related to the address type
754  */
755 library Address {
756     /**
757      * @dev Returns true if `account` is a contract.
758      *
759      * [IMPORTANT]
760      * ====
761      * It is unsafe to assume that an address for which this function returns
762      * false is an externally-owned account (EOA) and not a contract.
763      *
764      * Among others, `isContract` will return false for the following
765      * types of addresses:
766      *
767      *  - an externally-owned account
768      *  - a contract in construction
769      *  - an address where a contract will be created
770      *  - an address where a contract lived, but was destroyed
771      * ====
772      */
773     function isContract(address account) internal view returns (bool) {
774         // This method relies on extcodesize, which returns 0 for contracts in
775         // construction, since the code is only stored at the end of the
776         // constructor execution.
777 
778         uint256 size;
779         // solhint-disable-next-line no-inline-assembly
780         assembly {
781             size := extcodesize(account)
782         }
783         return size > 0;
784     }
785 
786     /**
787      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
788      * `recipient`, forwarding all available gas and reverting on errors.
789      *
790      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
791      * of certain opcodes, possibly making contracts go over the 2300 gas limit
792      * imposed by `transfer`, making them unable to receive funds via
793      * `transfer`. {sendValue} removes this limitation.
794      *
795      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
796      *
797      * IMPORTANT: because control is transferred to `recipient`, care must be
798      * taken to not create reentrancy vulnerabilities. Consider using
799      * {ReentrancyGuard} or the
800      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
801      */
802     function sendValue(address payable recipient, uint256 amount) internal {
803         require(
804             address(this).balance >= amount,
805             "Address: insufficient balance"
806         );
807 
808         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
809         (bool success, ) = recipient.call{value: amount}("");
810         require(
811             success,
812             "Address: unable to send value, recipient may have reverted"
813         );
814     }
815 
816     /**
817      * @dev Performs a Solidity function call using a low level `call`. A
818      * plain`call` is an unsafe replacement for a function call: use this
819      * function instead.
820      *
821      * If `target` reverts with a revert reason, it is bubbled up by this
822      * function (like regular Solidity function calls).
823      *
824      * Returns the raw returned data. To convert to the expected return value,
825      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
826      *
827      * Requirements:
828      *
829      * - `target` must be a contract.
830      * - calling `target` with `data` must not revert.
831      *
832      * _Available since v3.1._
833      */
834     function functionCall(address target, bytes memory data)
835         internal
836         returns (bytes memory)
837     {
838         return functionCall(target, data, "Address: low-level call failed");
839     }
840 
841     /**
842      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
843      * `errorMessage` as a fallback revert reason when `target` reverts.
844      *
845      * _Available since v3.1._
846      */
847     function functionCall(
848         address target,
849         bytes memory data,
850         string memory errorMessage
851     ) internal returns (bytes memory) {
852         return functionCallWithValue(target, data, 0, errorMessage);
853     }
854 
855     /**
856      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
857      * but also transferring `value` wei to `target`.
858      *
859      * Requirements:
860      *
861      * - the calling contract must have an ETH balance of at least `value`.
862      * - the called Solidity function must be `payable`.
863      *
864      * _Available since v3.1._
865      */
866     function functionCallWithValue(
867         address target,
868         bytes memory data,
869         uint256 value
870     ) internal returns (bytes memory) {
871         return
872             functionCallWithValue(
873                 target,
874                 data,
875                 value,
876                 "Address: low-level call with value failed"
877             );
878     }
879 
880     /**
881      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
882      * with `errorMessage` as a fallback revert reason when `target` reverts.
883      *
884      * _Available since v3.1._
885      */
886     function functionCallWithValue(
887         address target,
888         bytes memory data,
889         uint256 value,
890         string memory errorMessage
891     ) internal returns (bytes memory) {
892         require(
893             address(this).balance >= value,
894             "Address: insufficient balance for call"
895         );
896         require(isContract(target), "Address: call to non-contract");
897 
898         // solhint-disable-next-line avoid-low-level-calls
899         (bool success, bytes memory returndata) =
900             target.call{value: value}(data);
901         return _verifyCallResult(success, returndata, errorMessage);
902     }
903 
904     /**
905      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
906      * but performing a static call.
907      *
908      * _Available since v3.3._
909      */
910     function functionStaticCall(address target, bytes memory data)
911         internal
912         view
913         returns (bytes memory)
914     {
915         return
916             functionStaticCall(
917                 target,
918                 data,
919                 "Address: low-level static call failed"
920             );
921     }
922 
923     /**
924      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
925      * but performing a static call.
926      *
927      * _Available since v3.3._
928      */
929     function functionStaticCall(
930         address target,
931         bytes memory data,
932         string memory errorMessage
933     ) internal view returns (bytes memory) {
934         require(isContract(target), "Address: static call to non-contract");
935 
936         // solhint-disable-next-line avoid-low-level-calls
937         (bool success, bytes memory returndata) = target.staticcall(data);
938         return _verifyCallResult(success, returndata, errorMessage);
939     }
940 
941     /**
942      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
943      * but performing a delegate call.
944      *
945      * _Available since v3.3._
946      */
947     function functionDelegateCall(address target, bytes memory data)
948         internal
949         returns (bytes memory)
950     {
951         return
952             functionDelegateCall(
953                 target,
954                 data,
955                 "Address: low-level delegate call failed"
956             );
957     }
958 
959     /**
960      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
961      * but performing a delegate call.
962      *
963      * _Available since v3.3._
964      */
965     function functionDelegateCall(
966         address target,
967         bytes memory data,
968         string memory errorMessage
969     ) internal returns (bytes memory) {
970         require(isContract(target), "Address: delegate call to non-contract");
971 
972         // solhint-disable-next-line avoid-low-level-calls
973         (bool success, bytes memory returndata) = target.delegatecall(data);
974         return _verifyCallResult(success, returndata, errorMessage);
975     }
976 
977     function _verifyCallResult(
978         bool success,
979         bytes memory returndata,
980         string memory errorMessage
981     ) private pure returns (bytes memory) {
982         if (success) {
983             return returndata;
984         } else {
985             // Look for revert reason and bubble it up if present
986             if (returndata.length > 0) {
987                 // The easiest way to bubble the revert reason is using memory via assembly
988 
989                 // solhint-disable-next-line no-inline-assembly
990                 assembly {
991                     let returndata_size := mload(returndata)
992                     revert(add(32, returndata), returndata_size)
993                 }
994             } else {
995                 revert(errorMessage);
996             }
997         }
998     }
999 }
1000 
1001 pragma solidity ^0.7.0;
1002 
1003 contract Token is ERC20 {
1004     using SafeMath for uint256;
1005     constructor() public ERC20("TMN Global", "TMNG") {
1006         _mint(msg.sender, 500000000 * (10**uint256(decimals())));
1007         
1008     }
1009 }