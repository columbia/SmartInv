1 pragma solidity ^0.6.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal virtual view returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal virtual view returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 pragma solidity ^0.6.0;
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount)
48         external
49         returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender)
59         external
60         view
61         returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(
89         address sender,
90         address recipient,
91         uint256 amount
92     ) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(
107         address indexed owner,
108         address indexed spender,
109         uint256 value
110     );
111 }
112 
113 pragma solidity ^0.6.0;
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      *
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157         return sub(a, b, "SafeMath: subtraction overflow");
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         uint256 c = a - b;
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      *
189      * - Multiplication cannot overflow.
190      */
191     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
193         // benefit is lost if 'b' is also tested.
194         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
195         if (a == 0) {
196             return 0;
197         }
198 
199         uint256 c = a * b;
200         require(c / a == b, "SafeMath: multiplication overflow");
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         return div(a, b, "SafeMath: division by zero");
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(
234         uint256 a,
235         uint256 b,
236         string memory errorMessage
237     ) internal pure returns (uint256) {
238         require(b > 0, errorMessage);
239         uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
258         return mod(a, b, "SafeMath: modulo by zero");
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * Reverts with custom message when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function mod(
274         uint256 a,
275         uint256 b,
276         string memory errorMessage
277     ) internal pure returns (uint256) {
278         require(b != 0, errorMessage);
279         return a % b;
280     }
281 }
282 
283 pragma solidity ^0.6.2;
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     /**
290      * @dev Returns true if `account` is a contract.
291      *
292      * [IMPORTANT]
293      * ====
294      * It is unsafe to assume that an address for which this function returns
295      * false is an externally-owned account (EOA) and not a contract.
296      *
297      * Among others, `isContract` will return false for the following
298      * types of addresses:
299      *
300      *  - an externally-owned account
301      *  - a contract in construction
302      *  - an address where a contract will be created
303      *  - an address where a contract lived, but was destroyed
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // This method relies in extcodesize, which returns 0 for contracts in
308         // construction, since the code is only stored at the end of the
309         // constructor execution.
310 
311         uint256 size;
312         // solhint-disable-next-line no-inline-assembly
313         assembly {
314             size := extcodesize(account)
315         }
316         return size > 0;
317     }
318 
319     /**
320      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
321      * `recipient`, forwarding all available gas and reverting on errors.
322      *
323      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
324      * of certain opcodes, possibly making contracts go over the 2300 gas limit
325      * imposed by `transfer`, making them unable to receive funds via
326      * `transfer`. {sendValue} removes this limitation.
327      *
328      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
329      *
330      * IMPORTANT: because control is transferred to `recipient`, care must be
331      * taken to not create reentrancy vulnerabilities. Consider using
332      * {ReentrancyGuard} or the
333      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
334      */
335     function sendValue(address payable recipient, uint256 amount) internal {
336         require(
337             address(this).balance >= amount,
338             "Address: insufficient balance"
339         );
340 
341         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
342         (bool success, ) = recipient.call{value: amount}("");
343         require(
344             success,
345             "Address: unable to send value, recipient may have reverted"
346         );
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain`call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data)
368         internal
369         returns (bytes memory)
370     {
371         return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376      * `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         return _functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value
403     ) internal returns (bytes memory) {
404         return
405             functionCallWithValue(
406                 target,
407                 data,
408                 value,
409                 "Address: low-level call with value failed"
410             );
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
415      * with `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         require(
426             address(this).balance >= value,
427             "Address: insufficient balance for call"
428         );
429         return _functionCallWithValue(target, data, value, errorMessage);
430     }
431 
432     function _functionCallWithValue(
433         address target,
434         bytes memory data,
435         uint256 weiValue,
436         string memory errorMessage
437     ) private returns (bytes memory) {
438         require(isContract(target), "Address: call to non-contract");
439 
440         // solhint-disable-next-line avoid-low-level-calls
441         (bool success, bytes memory returndata) = target.call{value: weiValue}(
442             data
443         );
444         if (success) {
445             return returndata;
446         } else {
447             // Look for revert reason and bubble it up if present
448             if (returndata.length > 0) {
449                 // The easiest way to bubble the revert reason is using memory via assembly
450 
451                 // solhint-disable-next-line no-inline-assembly
452                 assembly {
453                     let returndata_size := mload(returndata)
454                     revert(add(32, returndata), returndata_size)
455                 }
456             } else {
457                 revert(errorMessage);
458             }
459         }
460     }
461 }
462 
463 pragma solidity ^0.6.0;
464 
465 /**
466  * @dev Implementation of the {IERC20} interface.
467  *
468  * This implementation is agnostic to the way tokens are created. This means
469  * that a supply mechanism has to be added in a derived contract using {_mint}.
470  * For a generic mechanism see {ERC20PresetMinterPauser}.
471  *
472  * TIP: For a detailed writeup see our guide
473  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
474  * to implement supply mechanisms].
475  *
476  * We have followed general OpenZeppelin guidelines: functions revert instead
477  * of returning `false` on failure. This behavior is nonetheless conventional
478  * and does not conflict with the expectations of ERC20 applications.
479  *
480  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
481  * This allows applications to reconstruct the allowance for all accounts just
482  * by listening to said events. Other implementations of the EIP may not emit
483  * these events, as it isn't required by the specification.
484  *
485  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
486  * functions have been added to mitigate the well-known issues around setting
487  * allowances. See {IERC20-approve}.
488  */
489 contract ERC20 is Context, IERC20 {
490     using SafeMath for uint256;
491     using Address for address;
492 
493     mapping(address => uint256) private _balances;
494 
495     mapping(address => mapping(address => uint256)) private _allowances;
496 
497     uint256 private _totalSupply;
498 
499     string private _name;
500     string private _symbol;
501     uint8 private _decimals;
502 
503     /**
504      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
505      * a default value of 18.
506      *
507      * To select a different value for {decimals}, use {_setupDecimals}.
508      *
509      * All three of these values are immutable: they can only be set once during
510      * construction.
511      */
512     constructor(string memory name, string memory symbol) public {
513         _name = name;
514         _symbol = symbol;
515         _decimals = 18;
516     }
517 
518     /**
519      * @dev Returns the name of the token.
520      */
521     function name() public view returns (string memory) {
522         return _name;
523     }
524 
525     /**
526      * @dev Returns the symbol of the token, usually a shorter version of the
527      * name.
528      */
529     function symbol() public view returns (string memory) {
530         return _symbol;
531     }
532 
533     /**
534      * @dev Returns the number of decimals used to get its user representation.
535      * For example, if `decimals` equals `2`, a balance of `505` tokens should
536      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
537      *
538      * Tokens usually opt for a value of 18, imitating the relationship between
539      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
540      * called.
541      *
542      * NOTE: This information is only used for _display_ purposes: it in
543      * no way affects any of the arithmetic of the contract, including
544      * {IERC20-balanceOf} and {IERC20-transfer}.
545      */
546     function decimals() public view returns (uint8) {
547         return _decimals;
548     }
549 
550     /**
551      * @dev See {IERC20-totalSupply}.
552      */
553     function totalSupply() public override view returns (uint256) {
554         return _totalSupply;
555     }
556 
557     /**
558      * @dev See {IERC20-balanceOf}.
559      */
560     function balanceOf(address account) public override view returns (uint256) {
561         return _balances[account];
562     }
563 
564     /**
565      * @dev See {IERC20-transfer}.
566      *
567      * Requirements:
568      *
569      * - `recipient` cannot be the zero address.
570      * - the caller must have a balance of at least `amount`.
571      */
572     function transfer(address recipient, uint256 amount)
573         public
574         virtual
575         override
576         returns (bool)
577     {
578         _transfer(_msgSender(), recipient, amount);
579         return true;
580     }
581 
582     /**
583      * @dev See {IERC20-allowance}.
584      */
585     function allowance(address owner, address spender)
586         public
587         virtual
588         override
589         view
590         returns (uint256)
591     {
592         return _allowances[owner][spender];
593     }
594 
595     /**
596      * @dev See {IERC20-approve}.
597      *
598      * Requirements:
599      *
600      * - `spender` cannot be the zero address.
601      */
602     function approve(address spender, uint256 amount)
603         public
604         virtual
605         override
606         returns (bool)
607     {
608         _approve(_msgSender(), spender, amount);
609         return true;
610     }
611 
612     /**
613      * @dev See {IERC20-transferFrom}.
614      *
615      * Emits an {Approval} event indicating the updated allowance. This is not
616      * required by the EIP. See the note at the beginning of {ERC20};
617      *
618      * Requirements:
619      * - `sender` and `recipient` cannot be the zero address.
620      * - `sender` must have a balance of at least `amount`.
621      * - the caller must have allowance for ``sender``'s tokens of at least
622      * `amount`.
623      */
624     function transferFrom(
625         address sender,
626         address recipient,
627         uint256 amount
628     ) public virtual override returns (bool) {
629         _transfer(sender, recipient, amount);
630         _approve(
631             sender,
632             _msgSender(),
633             _allowances[sender][_msgSender()].sub(
634                 amount,
635                 "ERC20: transfer amount exceeds allowance"
636             )
637         );
638         return true;
639     }
640 
641     /**
642      * @dev Atomically increases the allowance granted to `spender` by the caller.
643      *
644      * This is an alternative to {approve} that can be used as a mitigation for
645      * problems described in {IERC20-approve}.
646      *
647      * Emits an {Approval} event indicating the updated allowance.
648      *
649      * Requirements:
650      *
651      * - `spender` cannot be the zero address.
652      */
653     function increaseAllowance(address spender, uint256 addedValue)
654         public
655         virtual
656         returns (bool)
657     {
658         _approve(
659             _msgSender(),
660             spender,
661             _allowances[_msgSender()][spender].add(addedValue)
662         );
663         return true;
664     }
665 
666     /**
667      * @dev Atomically decreases the allowance granted to `spender` by the caller.
668      *
669      * This is an alternative to {approve} that can be used as a mitigation for
670      * problems described in {IERC20-approve}.
671      *
672      * Emits an {Approval} event indicating the updated allowance.
673      *
674      * Requirements:
675      *
676      * - `spender` cannot be the zero address.
677      * - `spender` must have allowance for the caller of at least
678      * `subtractedValue`.
679      */
680     function decreaseAllowance(address spender, uint256 subtractedValue)
681         public
682         virtual
683         returns (bool)
684     {
685         _approve(
686             _msgSender(),
687             spender,
688             _allowances[_msgSender()][spender].sub(
689                 subtractedValue,
690                 "ERC20: decreased allowance below zero"
691             )
692         );
693         return true;
694     }
695 
696     /**
697      * @dev Moves tokens `amount` from `sender` to `recipient`.
698      *
699      * This is internal function is equivalent to {transfer}, and can be used to
700      * e.g. implement automatic token fees, slashing mechanisms, etc.
701      *
702      * Emits a {Transfer} event.
703      *
704      * Requirements:
705      *
706      * - `sender` cannot be the zero address.
707      * - `recipient` cannot be the zero address.
708      * - `sender` must have a balance of at least `amount`.
709      */
710     function _transfer(
711         address sender,
712         address recipient,
713         uint256 amount
714     ) internal virtual {
715         require(sender != address(0), "ERC20: transfer from the zero address");
716         require(recipient != address(0), "ERC20: transfer to the zero address");
717 
718         _beforeTokenTransfer(sender, recipient, amount);
719 
720         _balances[sender] = _balances[sender].sub(
721             amount,
722             "ERC20: transfer amount exceeds balance"
723         );
724         _balances[recipient] = _balances[recipient].add(amount);
725         emit Transfer(sender, recipient, amount);
726     }
727 
728     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
729      * the total supply.
730      *
731      * Emits a {Transfer} event with `from` set to the zero address.
732      *
733      * Requirements
734      *
735      * - `to` cannot be the zero address.
736      */
737     function _mint(address account, uint256 amount) internal virtual {
738         require(account != address(0), "ERC20: mint to the zero address");
739 
740         _beforeTokenTransfer(address(0), account, amount);
741 
742         _totalSupply = _totalSupply.add(amount);
743         _balances[account] = _balances[account].add(amount);
744         emit Transfer(address(0), account, amount);
745     }
746 
747     /**
748      * @dev Destroys `amount` tokens from `account`, reducing the
749      * total supply.
750      *
751      * Emits a {Transfer} event with `to` set to the zero address.
752      *
753      * Requirements
754      *
755      * - `account` cannot be the zero address.
756      * - `account` must have at least `amount` tokens.
757      */
758     function _burn(address account, uint256 amount) internal virtual {
759         require(account != address(0), "ERC20: burn from the zero address");
760 
761         _beforeTokenTransfer(account, address(0), amount);
762 
763         _balances[account] = _balances[account].sub(
764             amount,
765             "ERC20: burn amount exceeds balance"
766         );
767         _totalSupply = _totalSupply.sub(amount);
768         emit Transfer(account, address(0), amount);
769     }
770 
771     /**
772      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
773      *
774      * This internal function is equivalent to `approve`, and can be used to
775      * e.g. set automatic allowances for certain subsystems, etc.
776      *
777      * Emits an {Approval} event.
778      *
779      * Requirements:
780      *
781      * - `owner` cannot be the zero address.
782      * - `spender` cannot be the zero address.
783      */
784     function _approve(
785         address owner,
786         address spender,
787         uint256 amount
788     ) internal virtual {
789         require(owner != address(0), "ERC20: approve from the zero address");
790         require(spender != address(0), "ERC20: approve to the zero address");
791 
792         _allowances[owner][spender] = amount;
793         emit Approval(owner, spender, amount);
794     }
795 
796     /**
797      * @dev Sets {decimals} to a value other than the default one of 18.
798      *
799      * WARNING: This function should only be called from the constructor. Most
800      * applications that interact with token contracts will not expect
801      * {decimals} to ever change, and may work incorrectly if it does.
802      */
803     function _setupDecimals(uint8 decimals_) internal {
804         _decimals = decimals_;
805     }
806 
807     /**
808      * @dev Hook that is called before any transfer of tokens. This includes
809      * minting and burning.
810      *
811      * Calling conditions:
812      *
813      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
814      * will be to transferred to `to`.
815      * - when `from` is zero, `amount` tokens will be minted for `to`.
816      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
817      * - `from` and `to` are never both zero.
818      *
819      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
820      */
821     function _beforeTokenTransfer(
822         address from,
823         address to,
824         uint256 amount
825     ) internal virtual {}
826 }
827 
828 pragma solidity >=0.6.0;
829 
830 contract ToshiToken is ERC20 {
831     constructor() public ERC20("Toshi Token", "TOSHI") {
832         _mint(msg.sender, 100000 * (10**18));
833     }
834 }