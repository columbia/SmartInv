1 //SPDX-License-Identifier: MIT
2 // File: contracts/Context.sol
3 
4 pragma solidity ^0.6.0;
5 
6 abstract contract Context {
7     function _msgSender() internal virtual view returns (address payable) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal virtual view returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 // File: contracts/IERC20.sol
18 
19 pragma solidity ^0.6.0;
20 
21 /**
22  * @dev Interface of the ERC20 standard as defined in the EIP.
23  */
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount)
43         external
44         returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender)
54         external
55         view
56         returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(
102         address indexed owner,
103         address indexed spender,
104         uint256 value
105     );
106 }
107 
108 // File: contracts/SafeMath.sol
109 
110 pragma solidity ^0.6.0;
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(
168         uint256 a,
169         uint256 b,
170         string memory errorMessage
171     ) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         uint256 c = a - b;
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `*` operator.
183      *
184      * Requirements:
185      *
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(a, b, "SafeMath: division by zero");
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(
231         uint256 a,
232         uint256 b,
233         string memory errorMessage
234     ) internal pure returns (uint256) {
235         require(b > 0, errorMessage);
236         uint256 c = a / b;
237         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
238 
239         return c;
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
255         return mod(a, b, "SafeMath: modulo by zero");
256     }
257 
258     /**
259      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
260      * Reverts with custom message when dividing by zero.
261      *
262      * Counterpart to Solidity's `%` operator. This function uses a `revert`
263      * opcode (which leaves remaining gas untouched) while Solidity uses an
264      * invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      *
268      * - The divisor cannot be zero.
269      */
270     function mod(
271         uint256 a,
272         uint256 b,
273         string memory errorMessage
274     ) internal pure returns (uint256) {
275         require(b != 0, errorMessage);
276         return a % b;
277     }
278 }
279 
280 // File: contracts/AddressLib.sol
281 
282 pragma solidity ^0.6.0;
283 
284 /**
285  * @dev Collection of functions related to the address type
286  */
287 library Address {
288     /**
289      * @dev Returns true if `account` is a contract.
290      *
291      * [IMPORTANT]
292      * ====
293      * It is unsafe to assume that an address for which this function returns
294      * false is an externally-owned account (EOA) and not a contract.
295      *
296      * Among others, `isContract` will return false for the following
297      * types of addresses:
298      *
299      *  - an externally-owned account
300      *  - a contract in construction
301      *  - an address where a contract will be created
302      *  - an address where a contract lived, but was destroyed
303      * ====
304      */
305     function isContract(address account) internal view returns (bool) {
306         // This method relies in extcodesize, which returns 0 for contracts in
307         // construction, since the code is only stored at the end of the
308         // constructor execution.
309 
310         uint256 size;
311         // solhint-disable-next-line no-inline-assembly
312         assembly {
313             size := extcodesize(account)
314         }
315         return size > 0;
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(
336             address(this).balance >= amount,
337             "Address: insufficient balance"
338         );
339 
340         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
341         (bool success, ) = recipient.call{value: amount}("");
342         require(
343             success,
344             "Address: unable to send value, recipient may have reverted"
345         );
346     }
347 
348     /**
349      * @dev Performs a Solidity function call using a low level `call`. A
350      * plain`call` is an unsafe replacement for a function call: use this
351      * function instead.
352      *
353      * If `target` reverts with a revert reason, it is bubbled up by this
354      * function (like regular Solidity function calls).
355      *
356      * Returns the raw returned data. To convert to the expected return value,
357      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
358      *
359      * Requirements:
360      *
361      * - `target` must be a contract.
362      * - calling `target` with `data` must not revert.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data)
367         internal
368         returns (bytes memory)
369     {
370         return functionCall(target, data, "Address: low-level call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375      * `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         return _functionCallWithValue(target, data, 0, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but also transferring `value` wei to `target`.
390      *
391      * Requirements:
392      *
393      * - the calling contract must have an ETH balance of at least `value`.
394      * - the called Solidity function must be `payable`.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value
402     ) internal returns (bytes memory) {
403         return
404             functionCallWithValue(
405                 target,
406                 data,
407                 value,
408                 "Address: low-level call with value failed"
409             );
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
414      * with `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(
425             address(this).balance >= value,
426             "Address: insufficient balance for call"
427         );
428         return _functionCallWithValue(target, data, value, errorMessage);
429     }
430 
431     function _functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 weiValue,
435         string memory errorMessage
436     ) private returns (bytes memory) {
437         require(isContract(target), "Address: call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) = target.call{value: weiValue}(
441             data
442         );
443         if (success) {
444             return returndata;
445         } else {
446             // Look for revert reason and bubble it up if present
447             if (returndata.length > 0) {
448                 // The easiest way to bubble the revert reason is using memory via assembly
449 
450                 // solhint-disable-next-line no-inline-assembly
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 // File: contracts/ERC20.sol
463 
464 pragma solidity ^0.6.0;
465 
466 contract ERC20 is Context, IERC20 {
467     using SafeMath for uint256;
468     using Address for address;
469 
470     mapping(address => uint256) private _balances;
471 
472     mapping(address => mapping(address => uint256)) private _allowances;
473 
474     uint256 private _totalSupply;
475 
476     string private _name;
477     string private _symbol;
478     uint8 private _decimals;
479 
480     /**
481      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
482      * a default value of 18.
483      *
484      * To select a different value for {decimals}, use {_setupDecimals}.
485      *
486      * All three of these values are immutable: they can only be set once during
487      * construction.
488      */
489     constructor(string memory name, string memory symbol) public {
490         _name = name;
491         _symbol = symbol;
492         _decimals = 18;
493     }
494 
495     /**
496      * @dev Returns the name of the token.
497      */
498     function name() public view returns (string memory) {
499         return _name;
500     }
501 
502     /**
503      * @dev Returns the symbol of the token, usually a shorter version of the
504      * name.
505      */
506     function symbol() public view returns (string memory) {
507         return _symbol;
508     }
509 
510     /**
511      * @dev Returns the number of decimals used to get its user representation.
512      * For example, if `decimals` equals `2`, a balance of `505` tokens should
513      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
514      *
515      * Tokens usually opt for a value of 18, imitating the relationship between
516      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
517      * called.
518      *
519      * NOTE: This information is only used for _display_ purposes: it in
520      * no way affects any of the arithmetic of the contract, including
521      * {IERC20-balanceOf} and {IERC20-transfer}.
522      */
523     function decimals() public view returns (uint8) {
524         return _decimals;
525     }
526 
527     /**
528      * @dev See {IERC20-totalSupply}.
529      */
530     function totalSupply() public override view returns (uint256) {
531         return _totalSupply;
532     }
533 
534     /**
535      * @dev See {IERC20-balanceOf}.
536      */
537     function balanceOf(address account) public override view returns (uint256) {
538         return _balances[account];
539     }
540 
541     /**
542      * @dev See {IERC20-transfer}.
543      *
544      * Requirements:
545      *
546      * - `recipient` cannot be the zero address.
547      * - the caller must have a balance of at least `amount`.
548      */
549     function transfer(address recipient, uint256 amount)
550         public
551         virtual
552         override
553         returns (bool)
554     {
555         _transfer(_msgSender(), recipient, amount);
556         return true;
557     }
558 
559     /**
560      * @dev See {IERC20-allowance}.
561      */
562     function allowance(address owner, address spender)
563         public
564         virtual
565         override
566         view
567         returns (uint256)
568     {
569         return _allowances[owner][spender];
570     }
571 
572     /**
573      * @dev See {IERC20-approve}.
574      *
575      * Requirements:
576      *
577      * - `spender` cannot be the zero address.
578      */
579     function approve(address spender, uint256 amount)
580         public
581         virtual
582         override
583         returns (bool)
584     {
585         _approve(_msgSender(), spender, amount);
586         return true;
587     }
588 
589     /**
590      * @dev See {IERC20-transferFrom}.
591      *
592      * Emits an {Approval} event indicating the updated allowance. This is not
593      * required by the EIP. See the note at the beginning of {ERC20};
594      *
595      * Requirements:
596      * - `sender` and `recipient` cannot be the zero address.
597      * - `sender` must have a balance of at least `amount`.
598      * - the caller must have allowance for ``sender``'s tokens of at least
599      * `amount`.
600      */
601     function transferFrom(
602         address sender,
603         address recipient,
604         uint256 amount
605     ) public virtual override returns (bool) {
606         _transfer(sender, recipient, amount);
607         _approve(
608             sender,
609             _msgSender(),
610             _allowances[sender][_msgSender()].sub(
611                 amount,
612                 "ERC20: transfer amount exceeds allowance"
613             )
614         );
615         return true;
616     }
617 
618     /**
619      * @dev Atomically increases the allowance granted to `spender` by the caller.
620      *
621      * This is an alternative to {approve} that can be used as a mitigation for
622      * problems described in {IERC20-approve}.
623      *
624      * Emits an {Approval} event indicating the updated allowance.
625      *
626      * Requirements:
627      *
628      * - `spender` cannot be the zero address.
629      */
630     function increaseAllowance(address spender, uint256 addedValue)
631         public
632         virtual
633         returns (bool)
634     {
635         _approve(
636             _msgSender(),
637             spender,
638             _allowances[_msgSender()][spender].add(addedValue)
639         );
640         return true;
641     }
642 
643     /**
644      * @dev Atomically decreases the allowance granted to `spender` by the caller.
645      *
646      * This is an alternative to {approve} that can be used as a mitigation for
647      * problems described in {IERC20-approve}.
648      *
649      * Emits an {Approval} event indicating the updated allowance.
650      *
651      * Requirements:
652      *
653      * - `spender` cannot be the zero address.
654      * - `spender` must have allowance for the caller of at least
655      * `subtractedValue`.
656      */
657     function decreaseAllowance(address spender, uint256 subtractedValue)
658         public
659         virtual
660         returns (bool)
661     {
662         _approve(
663             _msgSender(),
664             spender,
665             _allowances[_msgSender()][spender].sub(
666                 subtractedValue,
667                 "ERC20: decreased allowance below zero"
668             )
669         );
670         return true;
671     }
672 
673     /**
674      * @dev Moves tokens `amount` from `sender` to `recipient`.
675      *
676      * This is internal function is equivalent to {transfer}, and can be used to
677      * e.g. implement automatic token fees, slashing mechanisms, etc.
678      *
679      * Emits a {Transfer} event.
680      *
681      * Requirements:
682      *
683      * - `sender` cannot be the zero address.
684      * - `recipient` cannot be the zero address.
685      * - `sender` must have a balance of at least `amount`.
686      */
687     function _transfer(
688         address sender,
689         address recipient,
690         uint256 amount
691     ) internal virtual {
692         require(sender != address(0), "ERC20: transfer from the zero address");
693         require(recipient != address(0), "ERC20: transfer to the zero address");
694 
695         _beforeTokenTransfer(sender, recipient, amount);
696 
697         _balances[sender] = _balances[sender].sub(
698             amount,
699             "ERC20: transfer amount exceeds balance"
700         );
701         _balances[recipient] = _balances[recipient].add(amount);
702         emit Transfer(sender, recipient, amount);
703     }
704 
705     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
706      * the total supply.
707      *
708      * Emits a {Transfer} event with `from` set to the zero address.
709      *
710      * Requirements
711      *
712      * - `to` cannot be the zero address.
713      */
714     function _mint(address account, uint256 amount) internal virtual {
715         require(account != address(0), "ERC20: mint to the zero address");
716 
717         _beforeTokenTransfer(address(0), account, amount);
718 
719         _totalSupply = _totalSupply.add(amount);
720         _balances[account] = _balances[account].add(amount);
721         emit Transfer(address(0), account, amount);
722     }
723 
724     /**
725      * @dev Destroys `amount` tokens from `account`, reducing the
726      * total supply.
727      *
728      * Emits a {Transfer} event with `to` set to the zero address.
729      *
730      * Requirements
731      *
732      * - `account` cannot be the zero address.
733      * - `account` must have at least `amount` tokens.
734      */
735     function _burn(address account, uint256 amount) internal virtual {
736         require(account != address(0), "ERC20: burn from the zero address");
737 
738         _beforeTokenTransfer(account, address(0), amount);
739 
740         _balances[account] = _balances[account].sub(
741             amount,
742             "ERC20: burn amount exceeds balance"
743         );
744         _totalSupply = _totalSupply.sub(amount);
745         emit Transfer(account, address(0), amount);
746     }
747 
748     /**
749      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
750      *
751      * This internal function is equivalent to `approve`, and can be used to
752      * e.g. set automatic allowances for certain subsystems, etc.
753      *
754      * Emits an {Approval} event.
755      *
756      * Requirements:
757      *
758      * - `owner` cannot be the zero address.
759      * - `spender` cannot be the zero address.
760      */
761     function _approve(
762         address owner,
763         address spender,
764         uint256 amount
765     ) internal virtual {
766         require(owner != address(0), "ERC20: approve from the zero address");
767         require(spender != address(0), "ERC20: approve to the zero address");
768 
769         _allowances[owner][spender] = amount;
770         emit Approval(owner, spender, amount);
771     }
772 
773     /**
774      * @dev Sets {decimals} to a value other than the default one of 18.
775      *
776      * WARNING: This function should only be called from the constructor. Most
777      * applications that interact with token contracts will not expect
778      * {decimals} to ever change, and may work incorrectly if it does.
779      */
780     function _setupDecimals(uint8 decimals_) internal {
781         _decimals = decimals_;
782     }
783 
784     /**
785      * @dev Hook that is called before any transfer of tokens. This includes
786      * minting and burning.
787      *
788      * Calling conditions:
789      *
790      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
791      * will be to transferred to `to`.
792      * - when `from` is zero, `amount` tokens will be minted for `to`.
793      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
794      * - `from` and `to` are never both zero.
795      *
796      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
797      */
798     function _beforeTokenTransfer(
799         address from,
800         address to,
801         uint256 amount
802     ) internal virtual {}
803 }
804 
805 // File: contracts/Ownable.sol
806 
807 pragma solidity ^0.6.0;
808 
809 /**
810  * @dev Contract module which provides a basic access control mechanism, where
811  * there is an account (an owner) that can be granted exclusive access to
812  * specific functions.
813  *
814  * By default, the owner account will be the one that deploys the contract. This
815  * can later be changed with {transferOwnership}.
816  *
817  * This module is used through inheritance. It will make available the modifier
818  * `onlyOwner`, which can be applied to your functions to restrict their use to
819  * the owner.
820  */
821 contract Ownable is Context {
822     address private _owner;
823 
824     event OwnershipTransferred(
825         address indexed previousOwner,
826         address indexed newOwner
827     );
828 
829     /**
830      * @dev Initializes the contract setting the deployer as the initial owner.
831      */
832     constructor() internal {
833         address msgSender = _msgSender();
834         _owner = msgSender;
835         emit OwnershipTransferred(address(0), msgSender);
836     }
837 
838     /**
839      * @dev Returns the address of the current owner.
840      */
841     function owner() public view returns (address) {
842         return _owner;
843     }
844 
845     /**
846      * @dev Throws if called by any account other than the owner.
847      */
848     modifier onlyOwner() {
849         require(_owner == _msgSender(), "Ownable: caller is not the owner");
850         _;
851     }
852 
853     /**
854      * @dev Leaves the contract without owner. It will not be possible to call
855      * `onlyOwner` functions anymore. Can only be called by the current owner.
856      *
857      * NOTE: Renouncing ownership will leave the contract without an owner,
858      * thereby removing any functionality that is only available to the owner.
859      */
860     function renounceOwnership() public virtual onlyOwner {
861         emit OwnershipTransferred(_owner, address(0));
862         _owner = address(0);
863     }
864 
865     /**
866      * @dev Transfers ownership of the contract to a new account (`newOwner`).
867      * Can only be called by the current owner.
868      */
869     function transferOwnership(address newOwner) public virtual onlyOwner {
870         require(
871             newOwner != address(0),
872             "Ownable: new owner is the zero address"
873         );
874         emit OwnershipTransferred(_owner, newOwner);
875         _owner = newOwner;
876     }
877 }
878 
879 // File: contracts/YFBTC.sol
880 
881 pragma solidity 0.6.12;
882 
883 // YFBitcoin with Governance.
884 contract YFBitcoin is ERC20("YFBitcoin", "YFBTC"), Ownable {
885     uint256 public transferFee = 1;
886 
887     uint256 public devFee = 300;
888 
889     address public devAddress;
890 
891     uint256 public cap;
892 
893     constructor(uint256 _cap, address _devAddress) public {
894         cap = _cap;
895         devAddress = _devAddress;
896     }
897 
898     function setTransferFee(uint256 _fee) public onlyOwner {
899         require(
900             _fee > 0 && _fee < 1000,
901             "YFBTC: fee should be between 0 and 10"
902         );
903         transferFee = _fee;
904     }
905 
906     function setDevAddress(address _devAddress) public onlyOwner {
907         devAddress = _devAddress;
908     }
909 
910     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
911     function mint(address _to, uint256 _amount) public onlyOwner {
912         _mint(_to, _amount);
913         _moveDelegates(address(0), _delegates[_to], _amount);
914     }
915 
916     function transfer(address recipient, uint256 amount)
917         public
918         virtual
919         override
920         returns (bool)
921     {
922         uint256 fee = amount.mul(transferFee).div(10000);
923         uint256 devAmount = fee.mul(devFee).div(10000);
924         _transfer(_msgSender(), devAddress, devAmount);
925         _burn(_msgSender(), fee.sub(devAmount));
926         _transfer(_msgSender(), recipient, amount.sub(fee));
927         return true;
928     }
929 
930     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
931         uint256 fee = amount.mul(transferFee).div(10000);
932         uint256 devAmount = fee.mul(devFee).div(10000);
933         _transfer(sender, devAddress , devAmount);
934         uint256 allowedAmount = allowance(sender,_msgSender());
935         _burn(sender, fee.sub(devAmount));
936         _transfer(sender, recipient,amount.sub(fee));
937         _approve(sender, _msgSender(),allowedAmount.sub(amount, "ERC20: transfer amount exceeds allowance"));
938         return true;
939     }
940 
941     // Copied and modified from YAM code:
942     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
943     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
944     // Which is copied and modified from COMPOUND:
945     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
946 
947     mapping(address => address) internal _delegates;
948 
949     /// @notice A checkpoint for marking number of votes from a given block
950     struct Checkpoint {
951         uint32 fromBlock;
952         uint256 votes;
953     }
954 
955     /// @notice A record of votes checkpoints for each account, by index
956     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
957 
958     /// @notice The number of checkpoints for each account
959     mapping(address => uint32) public numCheckpoints;
960 
961     /// @notice The EIP-712 typehash for the contract's domain
962     bytes32 public constant DOMAIN_TYPEHASH = keccak256(
963         "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
964     );
965 
966     /// @notice The EIP-712 typehash for the delegation struct used by the contract
967     bytes32 public constant DELEGATION_TYPEHASH = keccak256(
968         "Delegation(address delegatee,uint256 nonce,uint256 expiry)"
969     );
970 
971     /// @notice A record of states for signing / validating signatures
972     mapping(address => uint256) public nonces;
973 
974     /// @notice An event thats emitted when an account changes its delegate
975     event DelegateChanged(
976         address indexed delegator,
977         address indexed fromDelegate,
978         address indexed toDelegate
979     );
980 
981     /// @notice An event thats emitted when a delegate account's vote balance changes
982     event DelegateVotesChanged(
983         address indexed delegate,
984         uint256 previousBalance,
985         uint256 newBalance
986     );
987 
988     /**
989      * @notice Delegate votes from `msg.sender` to `delegatee`
990      * @param delegator The address to get delegatee for
991      */
992     function delegates(address delegator) external view returns (address) {
993         return _delegates[delegator];
994     }
995 
996     /**
997      * @notice Delegate votes from `msg.sender` to `delegatee`
998      * @param delegatee The address to delegate votes to
999      */
1000     function delegate(address delegatee) external {
1001         return _delegate(msg.sender, delegatee);
1002     }
1003 
1004     /**
1005      * @notice Delegates votes from signatory to `delegatee`
1006      * @param delegatee The address to delegate votes to
1007      * @param nonce The contract state required to match the signature
1008      * @param expiry The time at which to expire the signature
1009      * @param v The recovery byte of the signature
1010      * @param r Half of the ECDSA signature pair
1011      * @param s Half of the ECDSA signature pair
1012      */
1013     function delegateBySig(
1014         address delegatee,
1015         uint256 nonce,
1016         uint256 expiry,
1017         uint8 v,
1018         bytes32 r,
1019         bytes32 s
1020     ) external {
1021         bytes32 domainSeparator = keccak256(
1022             abi.encode(
1023                 DOMAIN_TYPEHASH,
1024                 keccak256(bytes(name())),
1025                 getChainId(),
1026                 address(this)
1027             )
1028         );
1029 
1030         bytes32 structHash = keccak256(
1031             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
1032         );
1033 
1034         bytes32 digest = keccak256(
1035             abi.encodePacked("\x19\x01", domainSeparator, structHash)
1036         );
1037 
1038         address signatory = ecrecover(digest, v, r, s);
1039         require(
1040             signatory != address(0),
1041             "YFBTC::delegateBySig: invalid signature"
1042         );
1043         require(
1044             nonce == nonces[signatory]++,
1045             "YFBTC::delegateBySig: invalid nonce"
1046         );
1047         require(now <= expiry, "YFBTC::delegateBySig: signature expired");
1048         return _delegate(signatory, delegatee);
1049     }
1050 
1051     /**
1052      * @notice Gets the current votes balance for `account`
1053      * @param account The address to get votes balance
1054      * @return The number of current votes for `account`
1055      */
1056     function getCurrentVotes(address account) external view returns (uint256) {
1057         uint32 nCheckpoints = numCheckpoints[account];
1058         return
1059             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1060     }
1061 
1062     /**
1063      * @notice Determine the prior number of votes for an account as of a block number
1064      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1065      * @param account The address of the account to check
1066      * @param blockNumber The block number to get the vote balance at
1067      * @return The number of votes the account had as of the given block
1068      */
1069     function getPriorVotes(address account, uint256 blockNumber)
1070         external
1071         view
1072         returns (uint256)
1073     {
1074         require(
1075             blockNumber < block.number,
1076             "YFBTC::getPriorVotes: not yet determined"
1077         );
1078 
1079         uint32 nCheckpoints = numCheckpoints[account];
1080         if (nCheckpoints == 0) {
1081             return 0;
1082         }
1083 
1084         // First check most recent balance
1085         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1086             return checkpoints[account][nCheckpoints - 1].votes;
1087         }
1088 
1089         // Next check implicit zero balance
1090         if (checkpoints[account][0].fromBlock > blockNumber) {
1091             return 0;
1092         }
1093 
1094         uint32 lower = 0;
1095         uint32 upper = nCheckpoints - 1;
1096         while (upper > lower) {
1097             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1098             Checkpoint memory cp = checkpoints[account][center];
1099             if (cp.fromBlock == blockNumber) {
1100                 return cp.votes;
1101             } else if (cp.fromBlock < blockNumber) {
1102                 lower = center;
1103             } else {
1104                 upper = center - 1;
1105             }
1106         }
1107         return checkpoints[account][lower].votes;
1108     }
1109 
1110     function _delegate(address delegator, address delegatee) internal {
1111         address currentDelegate = _delegates[delegator];
1112         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying YFEs (not scaled);
1113         _delegates[delegator] = delegatee;
1114 
1115         emit DelegateChanged(delegator, currentDelegate, delegatee);
1116 
1117         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1118     }
1119 
1120     function _moveDelegates(
1121         address srcRep,
1122         address dstRep,
1123         uint256 amount
1124     ) internal {
1125         if (srcRep != dstRep && amount > 0) {
1126             if (srcRep != address(0)) {
1127                 // decrease old representative
1128                 uint32 srcRepNum = numCheckpoints[srcRep];
1129                 uint256 srcRepOld = srcRepNum > 0
1130                     ? checkpoints[srcRep][srcRepNum - 1].votes
1131                     : 0;
1132                 uint256 srcRepNew = srcRepOld.sub(amount);
1133                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1134             }
1135 
1136             if (dstRep != address(0)) {
1137                 // increase new representative
1138                 uint32 dstRepNum = numCheckpoints[dstRep];
1139                 uint256 dstRepOld = dstRepNum > 0
1140                     ? checkpoints[dstRep][dstRepNum - 1].votes
1141                     : 0;
1142                 uint256 dstRepNew = dstRepOld.add(amount);
1143                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1144             }
1145         }
1146     }
1147 
1148     function _writeCheckpoint(
1149         address delegatee,
1150         uint32 nCheckpoints,
1151         uint256 oldVotes,
1152         uint256 newVotes
1153     ) internal {
1154         uint32 blockNumber = safe32(
1155             block.number,
1156             "YFBTC::_writeCheckpoint: block number exceeds 32 bits"
1157         );
1158 
1159         if (
1160             nCheckpoints > 0 &&
1161             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
1162         ) {
1163             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1164         } else {
1165             checkpoints[delegatee][nCheckpoints] = Checkpoint(
1166                 blockNumber,
1167                 newVotes
1168             );
1169             numCheckpoints[delegatee] = nCheckpoints + 1;
1170         }
1171 
1172         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1173     }
1174 
1175     function safe32(uint256 n, string memory errorMessage)
1176         internal
1177         pure
1178         returns (uint32)
1179     {
1180         require(n < 2**32, errorMessage);
1181         return uint32(n);
1182     }
1183 
1184     function getChainId() internal pure returns (uint256) {
1185         uint256 chainId;
1186         assembly {
1187             chainId := chainid()
1188         }
1189         return chainId;
1190     }
1191 
1192     /**
1193      * @dev See {ERC20-_beforeTokenTransfer}.
1194      *
1195      * Requirements:
1196      *
1197      * - minted tokens must not cause the total supply to go over the cap.
1198      */
1199     function _beforeTokenTransfer(
1200         address from,
1201         address to,
1202         uint256 amount
1203     ) internal virtual override {
1204         super._beforeTokenTransfer(from, to, amount);
1205 
1206         if (from == address(0)) {
1207             // When minting tokens
1208             require(totalSupply().add(amount) <= cap, "YFBTC:: cap exceeded");
1209         }
1210     }
1211 }