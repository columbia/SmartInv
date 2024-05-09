1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount)
50         external
51         returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender)
61         external
62         view
63         returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(
91         address sender,
92         address recipient,
93         uint256 amount
94     ) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(
109         address indexed owner,
110         address indexed spender,
111         uint256 value
112     );
113 }
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
283 /**
284  * @dev Implementation of the {IERC20} interface.
285  *
286  * This implementation is agnostic to the way tokens are created. This means
287  * that a supply mechanism has to be added in a derived contract using {_mint}.
288  * For a generic mechanism see {ERC20PresetMinterPauser}.
289  *
290  * TIP: For a detailed writeup see our guide
291  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
292  * to implement supply mechanisms].
293  *
294  * We have followed general OpenZeppelin guidelines: functions revert instead
295  * of returning `false` on failure. This behavior is nonetheless conventional
296  * and does not conflict with the expectations of ERC20 applications.
297  *
298  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
299  * This allows applications to reconstruct the allowance for all accounts just
300  * by listening to said events. Other implementations of the EIP may not emit
301  * these events, as it isn't required by the specification.
302  *
303  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
304  * functions have been added to mitigate the well-known issues around setting
305  * allowances. See {IERC20-approve}.
306  */
307 contract ERC20 is Context, IERC20 {
308     using SafeMath for uint256;
309 
310     mapping(address => uint256) private _balances;
311 
312     mapping(address => mapping(address => uint256)) private _allowances;
313 
314     uint256 private _totalSupply;
315 
316     string private _name;
317     string private _symbol;
318     uint8 private _decimals;
319 
320     /**
321      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
322      * a default value of 18.
323      *
324      * To select a different value for {decimals}, use {_setupDecimals}.
325      *
326      * All three of these values are immutable: they can only be set once during
327      * construction.
328      */
329     constructor(string memory name_, string memory symbol_) public {
330         _name = name_;
331         _symbol = symbol_;
332         _decimals = 18;
333     }
334 
335     /**
336      * @dev Returns the name of the token.
337      */
338     function name() public view returns (string memory) {
339         return _name;
340     }
341 
342     /**
343      * @dev Returns the symbol of the token, usually a shorter version of the
344      * name.
345      */
346     function symbol() public view returns (string memory) {
347         return _symbol;
348     }
349 
350     /**
351      * @dev Returns the number of decimals used to get its user representation.
352      * For example, if `decimals` equals `2`, a balance of `505` tokens should
353      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
354      *
355      * Tokens usually opt for a value of 18, imitating the relationship between
356      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
357      * called.
358      *
359      * NOTE: This information is only used for _display_ purposes: it in
360      * no way affects any of the arithmetic of the contract, including
361      * {IERC20-balanceOf} and {IERC20-transfer}.
362      */
363     function decimals() public view returns (uint8) {
364         return _decimals;
365     }
366 
367     /**
368      * @dev See {IERC20-totalSupply}.
369      */
370     function totalSupply() public view override returns (uint256) {
371         return _totalSupply;
372     }
373 
374     /**
375      * @dev See {IERC20-balanceOf}.
376      */
377     function balanceOf(address account) public view override returns (uint256) {
378         return _balances[account];
379     }
380 
381     /**
382      * @dev See {IERC20-transfer}.
383      *
384      * Requirements:
385      *
386      * - `recipient` cannot be the zero address.
387      * - the caller must have a balance of at least `amount`.
388      */
389     function transfer(address recipient, uint256 amount)
390         public
391         virtual
392         override
393         returns (bool)
394     {
395         _transfer(_msgSender(), recipient, amount);
396         return true;
397     }
398 
399     /**
400      * @dev See {IERC20-allowance}.
401      */
402     function allowance(address owner, address spender)
403         public
404         view
405         virtual
406         override
407         returns (uint256)
408     {
409         return _allowances[owner][spender];
410     }
411 
412     /**
413      * @dev See {IERC20-approve}.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      */
419     function approve(address spender, uint256 amount)
420         public
421         virtual
422         override
423         returns (bool)
424     {
425         _approve(_msgSender(), spender, amount);
426         return true;
427     }
428 
429     /**
430      * @dev See {IERC20-transferFrom}.
431      *
432      * Emits an {Approval} event indicating the updated allowance. This is not
433      * required by the EIP. See the note at the beginning of {ERC20}.
434      *
435      * Requirements:
436      *
437      * - `sender` and `recipient` cannot be the zero address.
438      * - `sender` must have a balance of at least `amount`.
439      * - the caller must have allowance for ``sender``'s tokens of at least
440      * `amount`.
441      */
442     function transferFrom(
443         address sender,
444         address recipient,
445         uint256 amount
446     ) public virtual override returns (bool) {
447         _transfer(sender, recipient, amount);
448         _approve(
449             sender,
450             _msgSender(),
451             _allowances[sender][_msgSender()].sub(
452                 amount,
453                 "ERC20: transfer amount exceeds allowance"
454             )
455         );
456         return true;
457     }
458 
459     /**
460      * @dev Atomically increases the allowance granted to `spender` by the caller.
461      *
462      * This is an alternative to {approve} that can be used as a mitigation for
463      * problems described in {IERC20-approve}.
464      *
465      * Emits an {Approval} event indicating the updated allowance.
466      *
467      * Requirements:
468      *
469      * - `spender` cannot be the zero address.
470      */
471     function increaseAllowance(address spender, uint256 addedValue)
472         public
473         virtual
474         returns (bool)
475     {
476         _approve(
477             _msgSender(),
478             spender,
479             _allowances[_msgSender()][spender].add(addedValue)
480         );
481         return true;
482     }
483 
484     /**
485      * @dev Atomically decreases the allowance granted to `spender` by the caller.
486      *
487      * This is an alternative to {approve} that can be used as a mitigation for
488      * problems described in {IERC20-approve}.
489      *
490      * Emits an {Approval} event indicating the updated allowance.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      * - `spender` must have allowance for the caller of at least
496      * `subtractedValue`.
497      */
498     function decreaseAllowance(address spender, uint256 subtractedValue)
499         public
500         virtual
501         returns (bool)
502     {
503         _approve(
504             _msgSender(),
505             spender,
506             _allowances[_msgSender()][spender].sub(
507                 subtractedValue,
508                 "ERC20: decreased allowance below zero"
509             )
510         );
511         return true;
512     }
513 
514     /**
515      * @dev Moves tokens `amount` from `sender` to `recipient`.
516      *
517      * This is internal function is equivalent to {transfer}, and can be used to
518      * e.g. implement automatic token fees, slashing mechanisms, etc.
519      *
520      * Emits a {Transfer} event.
521      *
522      * Requirements:
523      *
524      * - `sender` cannot be the zero address.
525      * - `recipient` cannot be the zero address.
526      * - `sender` must have a balance of at least `amount`.
527      */
528     function _transfer(
529         address sender,
530         address recipient,
531         uint256 amount
532     ) internal virtual {
533         require(sender != address(0), "ERC20: transfer from the zero address");
534         require(recipient != address(0), "ERC20: transfer to the zero address");
535 
536         _beforeTokenTransfer(sender, recipient, amount);
537 
538         _balances[sender] = _balances[sender].sub(
539             amount,
540             "ERC20: transfer amount exceeds balance"
541         );
542         _balances[recipient] = _balances[recipient].add(amount);
543         emit Transfer(sender, recipient, amount);
544     }
545 
546     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
547      * the total supply.
548      *
549      * Emits a {Transfer} event with `from` set to the zero address.
550      *
551      * Requirements:
552      *
553      * - `to` cannot be the zero address.
554      */
555     function _mint(address account, uint256 amount) internal virtual {
556         require(account != address(0), "ERC20: mint to the zero address");
557 
558         _beforeTokenTransfer(address(0), account, amount);
559 
560         _totalSupply = _totalSupply.add(amount);
561         _balances[account] = _balances[account].add(amount);
562         emit Transfer(address(0), account, amount);
563     }
564 
565     /**
566      * @dev Destroys `amount` tokens from `account`, reducing the
567      * total supply.
568      *
569      * Emits a {Transfer} event with `to` set to the zero address.
570      *
571      * Requirements:
572      *
573      * - `account` cannot be the zero address.
574      * - `account` must have at least `amount` tokens.
575      */
576     function _burn(address account, uint256 amount) internal virtual {
577         require(account != address(0), "ERC20: burn from the zero address");
578 
579         _beforeTokenTransfer(account, address(0), amount);
580 
581         _balances[account] = _balances[account].sub(
582             amount,
583             "ERC20: burn amount exceeds balance"
584         );
585         _totalSupply = _totalSupply.sub(amount);
586         emit Transfer(account, address(0), amount);
587     }
588 
589     /**
590      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
591      *
592      * This internal function is equivalent to `approve`, and can be used to
593      * e.g. set automatic allowances for certain subsystems, etc.
594      *
595      * Emits an {Approval} event.
596      *
597      * Requirements:
598      *
599      * - `owner` cannot be the zero address.
600      * - `spender` cannot be the zero address.
601      */
602     function _approve(
603         address owner,
604         address spender,
605         uint256 amount
606     ) internal virtual {
607         require(owner != address(0), "ERC20: approve from the zero address");
608         require(spender != address(0), "ERC20: approve to the zero address");
609 
610         _allowances[owner][spender] = amount;
611         emit Approval(owner, spender, amount);
612     }
613 
614     /**
615      * @dev Sets {decimals} to a value other than the default one of 18.
616      *
617      * WARNING: This function should only be called from the constructor. Most
618      * applications that interact with token contracts will not expect
619      * {decimals} to ever change, and may work incorrectly if it does.
620      */
621     function _setupDecimals(uint8 decimals_) internal {
622         _decimals = decimals_;
623     }
624 
625     /**
626      * @dev Hook that is called before any transfer of tokens. This includes
627      * minting and burning.
628      *
629      * Calling conditions:
630      *
631      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
632      * will be to transferred to `to`.
633      * - when `from` is zero, `amount` tokens will be minted for `to`.
634      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
635      * - `from` and `to` are never both zero.
636      *
637      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
638      */
639     function _beforeTokenTransfer(
640         address from,
641         address to,
642         uint256 amount
643     ) internal virtual {}
644 }
645 
646 /**
647  * @dev Collection of functions related to the address type
648  */
649 library Address {
650     /**
651      * @dev Returns true if `account` is a contract.
652      *
653      * [IMPORTANT]
654      * ====
655      * It is unsafe to assume that an address for which this function returns
656      * false is an externally-owned account (EOA) and not a contract.
657      *
658      * Among others, `isContract` will return false for the following
659      * types of addresses:
660      *
661      *  - an externally-owned account
662      *  - a contract in construction
663      *  - an address where a contract will be created
664      *  - an address where a contract lived, but was destroyed
665      * ====
666      */
667     function isContract(address account) internal view returns (bool) {
668         // This method relies on extcodesize, which returns 0 for contracts in
669         // construction, since the code is only stored at the end of the
670         // constructor execution.
671 
672         uint256 size;
673         // solhint-disable-next-line no-inline-assembly
674         assembly {
675             size := extcodesize(account)
676         }
677         return size > 0;
678     }
679 
680     /**
681      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
682      * `recipient`, forwarding all available gas and reverting on errors.
683      *
684      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
685      * of certain opcodes, possibly making contracts go over the 2300 gas limit
686      * imposed by `transfer`, making them unable to receive funds via
687      * `transfer`. {sendValue} removes this limitation.
688      *
689      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
690      *
691      * IMPORTANT: because control is transferred to `recipient`, care must be
692      * taken to not create reentrancy vulnerabilities. Consider using
693      * {ReentrancyGuard} or the
694      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
695      */
696     function sendValue(address payable recipient, uint256 amount) internal {
697         require(
698             address(this).balance >= amount,
699             "Address: insufficient balance"
700         );
701 
702         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
703         (bool success, ) = recipient.call{value: amount}("");
704         require(
705             success,
706             "Address: unable to send value, recipient may have reverted"
707         );
708     }
709 
710     /**
711      * @dev Performs a Solidity function call using a low level `call`. A
712      * plain`call` is an unsafe replacement for a function call: use this
713      * function instead.
714      *
715      * If `target` reverts with a revert reason, it is bubbled up by this
716      * function (like regular Solidity function calls).
717      *
718      * Returns the raw returned data. To convert to the expected return value,
719      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
720      *
721      * Requirements:
722      *
723      * - `target` must be a contract.
724      * - calling `target` with `data` must not revert.
725      *
726      * _Available since v3.1._
727      */
728     function functionCall(address target, bytes memory data)
729         internal
730         returns (bytes memory)
731     {
732         return functionCall(target, data, "Address: low-level call failed");
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
737      * `errorMessage` as a fallback revert reason when `target` reverts.
738      *
739      * _Available since v3.1._
740      */
741     function functionCall(
742         address target,
743         bytes memory data,
744         string memory errorMessage
745     ) internal returns (bytes memory) {
746         return functionCallWithValue(target, data, 0, errorMessage);
747     }
748 
749     /**
750      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
751      * but also transferring `value` wei to `target`.
752      *
753      * Requirements:
754      *
755      * - the calling contract must have an ETH balance of at least `value`.
756      * - the called Solidity function must be `payable`.
757      *
758      * _Available since v3.1._
759      */
760     function functionCallWithValue(
761         address target,
762         bytes memory data,
763         uint256 value
764     ) internal returns (bytes memory) {
765         return
766             functionCallWithValue(
767                 target,
768                 data,
769                 value,
770                 "Address: low-level call with value failed"
771             );
772     }
773 
774     /**
775      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
776      * with `errorMessage` as a fallback revert reason when `target` reverts.
777      *
778      * _Available since v3.1._
779      */
780     function functionCallWithValue(
781         address target,
782         bytes memory data,
783         uint256 value,
784         string memory errorMessage
785     ) internal returns (bytes memory) {
786         require(
787             address(this).balance >= value,
788             "Address: insufficient balance for call"
789         );
790         require(isContract(target), "Address: call to non-contract");
791 
792         // solhint-disable-next-line avoid-low-level-calls
793         (bool success, bytes memory returndata) =
794             target.call{value: value}(data);
795         return _verifyCallResult(success, returndata, errorMessage);
796     }
797 
798     /**
799      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
800      * but performing a static call.
801      *
802      * _Available since v3.3._
803      */
804     function functionStaticCall(address target, bytes memory data)
805         internal
806         view
807         returns (bytes memory)
808     {
809         return
810             functionStaticCall(
811                 target,
812                 data,
813                 "Address: low-level static call failed"
814             );
815     }
816 
817     /**
818      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
819      * but performing a static call.
820      *
821      * _Available since v3.3._
822      */
823     function functionStaticCall(
824         address target,
825         bytes memory data,
826         string memory errorMessage
827     ) internal view returns (bytes memory) {
828         require(isContract(target), "Address: static call to non-contract");
829 
830         // solhint-disable-next-line avoid-low-level-calls
831         (bool success, bytes memory returndata) = target.staticcall(data);
832         return _verifyCallResult(success, returndata, errorMessage);
833     }
834 
835     function _verifyCallResult(
836         bool success,
837         bytes memory returndata,
838         string memory errorMessage
839     ) private pure returns (bytes memory) {
840         if (success) {
841             return returndata;
842         } else {
843             // Look for revert reason and bubble it up if present
844             if (returndata.length > 0) {
845                 // The easiest way to bubble the revert reason is using memory via assembly
846 
847                 // solhint-disable-next-line no-inline-assembly
848                 assembly {
849                     let returndata_size := mload(returndata)
850                     revert(add(32, returndata), returndata_size)
851                 }
852             } else {
853                 revert(errorMessage);
854             }
855         }
856     }
857 }
858 
859 /**
860  * @title SafeERC20
861  * @dev Wrappers around ERC20 operations that throw on failure (when the token
862  * contract returns false). Tokens that return no value (and instead revert or
863  * throw on failure) are also supported, non-reverting calls are assumed to be
864  * successful.
865  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
866  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
867  */
868 library SafeERC20 {
869     using SafeMath for uint256;
870     using Address for address;
871 
872     function safeTransfer(
873         IERC20 token,
874         address to,
875         uint256 value
876     ) internal {
877         _callOptionalReturn(
878             token,
879             abi.encodeWithSelector(token.transfer.selector, to, value)
880         );
881     }
882 
883     function safeTransferFrom(
884         IERC20 token,
885         address from,
886         address to,
887         uint256 value
888     ) internal {
889         _callOptionalReturn(
890             token,
891             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
892         );
893     }
894 
895     /**
896      * @dev Deprecated. This function has issues similar to the ones found in
897      * {IERC20-approve}, and its usage is discouraged.
898      *
899      * Whenever possible, use {safeIncreaseAllowance} and
900      * {safeDecreaseAllowance} instead.
901      */
902     function safeApprove(
903         IERC20 token,
904         address spender,
905         uint256 value
906     ) internal {
907         // safeApprove should only be called when setting an initial allowance,
908         // or when resetting it to zero. To increase and decrease it, use
909         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
910         // solhint-disable-next-line max-line-length
911         require(
912             (value == 0) || (token.allowance(address(this), spender) == 0),
913             "SafeERC20: approve from non-zero to non-zero allowance"
914         );
915         _callOptionalReturn(
916             token,
917             abi.encodeWithSelector(token.approve.selector, spender, value)
918         );
919     }
920 
921     function safeIncreaseAllowance(
922         IERC20 token,
923         address spender,
924         uint256 value
925     ) internal {
926         uint256 newAllowance =
927             token.allowance(address(this), spender).add(value);
928         _callOptionalReturn(
929             token,
930             abi.encodeWithSelector(
931                 token.approve.selector,
932                 spender,
933                 newAllowance
934             )
935         );
936     }
937 
938     function safeDecreaseAllowance(
939         IERC20 token,
940         address spender,
941         uint256 value
942     ) internal {
943         uint256 newAllowance =
944             token.allowance(address(this), spender).sub(
945                 value,
946                 "SafeERC20: decreased allowance below zero"
947             );
948         _callOptionalReturn(
949             token,
950             abi.encodeWithSelector(
951                 token.approve.selector,
952                 spender,
953                 newAllowance
954             )
955         );
956     }
957 
958     /**
959      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
960      * on the return value: the return value is optional (but if data is returned, it must not be false).
961      * @param token The token targeted by the call.
962      * @param data The call data (encoded using abi.encode or one of its variants).
963      */
964     function _callOptionalReturn(IERC20 token, bytes memory data) private {
965         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
966         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
967         // the target address contains contract code and also asserts for success in the low-level call.
968 
969         bytes memory returndata =
970             address(token).functionCall(
971                 data,
972                 "SafeERC20: low-level call failed"
973             );
974         if (returndata.length > 0) {
975             // Return data is optional
976             // solhint-disable-next-line max-line-length
977             require(
978                 abi.decode(returndata, (bool)),
979                 "SafeERC20: ERC20 operation did not succeed"
980             );
981         }
982     }
983 }
984 
985 contract GamyFi is ERC20 {
986     using SafeERC20 for IERC20;
987     using Address for address;
988     using SafeMath for uint256;
989     uint256 public _maxSupply = 0;
990     uint256 private _totalSupply;
991 
992     address public governance;
993     mapping(address => bool) public minters;
994 
995     constructor() public ERC20("GamyFi", "GFX") {
996         governance = msg.sender;
997         _maxSupply = 10000000 * (10**18);
998     }
999 
1000     function mint(address account, uint256 amount) public {
1001         require(minters[msg.sender], "!minter");
1002         uint256 newMintSupply = _totalSupply.add(amount);
1003         require(newMintSupply <= _maxSupply, "supply is max!");
1004         _totalSupply = _totalSupply.add(amount);
1005         _mint(account, amount);
1006     }
1007 
1008     function burn(uint256 amount) public {
1009         _burn(msg.sender, amount);
1010     }
1011 
1012     function setGovernance(address _governance) public {
1013         require(msg.sender == governance, "!governance");
1014         governance = _governance;
1015     }
1016 
1017     function addMinter(address _minter) public {
1018         require(msg.sender == governance, "!governance");
1019         minters[_minter] = true;
1020     }
1021 
1022     function removeMinter(address _minter) public {
1023         require(msg.sender == governance, "!governance");
1024         minters[_minter] = false;
1025     }
1026 }