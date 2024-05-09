1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-16
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal virtual view returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal virtual view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount)
52         external
53         returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender)
63         external
64         view
65         returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(
111         address indexed owner,
112         address indexed spender,
113         uint256 value
114     );
115 }
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations with added overflow
119  * checks.
120  *
121  * Arithmetic operations in Solidity wrap on overflow. This can easily result
122  * in bugs, because programmers usually assume that an overflow raises an
123  * error, which is the standard behavior in high level programming languages.
124  * `SafeMath` restores this intuition by reverting the transaction when an
125  * operation overflows.
126  *
127  * Using this library instead of the unchecked operations eliminates an entire
128  * class of bugs, so it's recommended to use it always.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `+` operator.
136      *
137      * Requirements:
138      *
139      * - Addition cannot overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159         return sub(a, b, "SafeMath: subtraction overflow");
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(
173         uint256 a,
174         uint256 b,
175         string memory errorMessage
176     ) internal pure returns (uint256) {
177         require(b <= a, errorMessage);
178         uint256 c = a - b;
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      *
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
195         // benefit is lost if 'b' is also tested.
196         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
197         if (a == 0) {
198             return 0;
199         }
200 
201         uint256 c = a * b;
202         require(c / a == b, "SafeMath: multiplication overflow");
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return div(a, b, "SafeMath: division by zero");
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator. Note: this function uses a
228      * `revert` opcode (which leaves remaining gas untouched) while Solidity
229      * uses an invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function div(
236         uint256 a,
237         uint256 b,
238         string memory errorMessage
239     ) internal pure returns (uint256) {
240         require(b > 0, errorMessage);
241         uint256 c = a / b;
242         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         return mod(a, b, "SafeMath: modulo by zero");
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265      * Reverts with custom message when dividing by zero.
266      *
267      * Counterpart to Solidity's `%` operator. This function uses a `revert`
268      * opcode (which leaves remaining gas untouched) while Solidity uses an
269      * invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function mod(
276         uint256 a,
277         uint256 b,
278         string memory errorMessage
279     ) internal pure returns (uint256) {
280         require(b != 0, errorMessage);
281         return a % b;
282     }
283 }
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
463 /**
464  * @dev Implementation of the {IERC20} interface.
465  *
466  * This implementation is agnostic to the way tokens are created. This means
467  * that a supply mechanism has to be added in a derived contract using {_mint}.
468  * For a generic mechanism see {ERC20PresetMinterPauser}.
469  *
470  * TIP: For a detailed writeup see our guide
471  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
472  * to implement supply mechanisms].
473  *
474  * We have followed general OpenZeppelin guidelines: functions revert instead
475  * of returning `false` on failure. This behavior is nonetheless conventional
476  * and does not conflict with the expectations of ERC20 applications.
477  *
478  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
479  * This allows applications to reconstruct the allowance for all accounts just
480  * by listening to said events. Other implementations of the EIP may not emit
481  * these events, as it isn't required by the specification.
482  *
483  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
484  * functions have been added to mitigate the well-known issues around setting
485  * allowances. See {IERC20-approve}.
486  */
487 contract ERC20 is Context, IERC20 {
488     using SafeMath for uint256;
489     using Address for address;
490 
491     mapping(address => uint256) private _balances;
492 
493     mapping(address => mapping(address => uint256)) private _allowances;
494 
495     uint256 private _totalSupply;
496 
497     string private _name;
498     string private _symbol;
499     uint8 private _decimals;
500 
501     /**
502      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
503      * a default value of 18.
504      *
505      * To select a different value for {decimals}, use {_setupDecimals}.
506      *
507      * All three of these values are immutable: they can only be set once during
508      * construction.
509      */
510     constructor(string memory name, string memory symbol) public {
511         _name = name;
512         _symbol = symbol;
513         _decimals = 18;
514     }
515 
516     /**
517      * @dev Returns the name of the token.
518      */
519     function name() public view returns (string memory) {
520         return _name;
521     }
522 
523     /**
524      * @dev Returns the symbol of the token, usually a shorter version of the
525      * name.
526      */
527     function symbol() public view returns (string memory) {
528         return _symbol;
529     }
530 
531     /**
532      * @dev Returns the number of decimals used to get its user representation.
533      * For example, if `decimals` equals `2`, a balance of `505` tokens should
534      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
535      *
536      * Tokens usually opt for a value of 18, imitating the relationship between
537      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
538      * called.
539      *
540      * NOTE: This information is only used for _display_ purposes: it in
541      * no way affects any of the arithmetic of the contract, including
542      * {IERC20-balanceOf} and {IERC20-transfer}.
543      */
544     function decimals() public view returns (uint8) {
545         return _decimals;
546     }
547 
548     /**
549      * @dev See {IERC20-totalSupply}.
550      */
551     function totalSupply() public override view returns (uint256) {
552         return _totalSupply;
553     }
554 
555     /**
556      * @dev See {IERC20-balanceOf}.
557      */
558     function balanceOf(address account) public override view returns (uint256) {
559         return _balances[account];
560     }
561 
562     /**
563      * @dev See {IERC20-transfer}.
564      *
565      * Requirements:
566      *
567      * - `recipient` cannot be the zero address.
568      * - the caller must have a balance of at least `amount`.
569      */
570     function transfer(address recipient, uint256 amount)
571         public
572         virtual
573         override
574         returns (bool)
575     {
576         _transfer(_msgSender(), recipient, amount);
577         return true;
578     }
579 
580     /**
581      * @dev See {IERC20-allowance}.
582      */
583     function allowance(address owner, address spender)
584         public
585         virtual
586         override
587         view
588         returns (uint256)
589     {
590         return _allowances[owner][spender];
591     }
592 
593     /**
594      * @dev See {IERC20-approve}.
595      *
596      * Requirements:
597      *
598      * - `spender` cannot be the zero address.
599      */
600     function approve(address spender, uint256 amount)
601         public
602         virtual
603         override
604         returns (bool)
605     {
606         _approve(_msgSender(), spender, amount);
607         return true;
608     }
609 
610     /**
611      * @dev See {IERC20-transferFrom}.
612      *
613      * Emits an {Approval} event indicating the updated allowance. This is not
614      * required by the EIP. See the note at the beginning of {ERC20};
615      *
616      * Requirements:
617      * - `sender` and `recipient` cannot be the zero address.
618      * - `sender` must have a balance of at least `amount`.
619      * - the caller must have allowance for ``sender``'s tokens of at least
620      * `amount`.
621      */
622     function transferFrom(
623         address sender,
624         address recipient,
625         uint256 amount
626     ) public virtual override returns (bool) {
627         _transfer(sender, recipient, amount);
628         _approve(
629             sender,
630             _msgSender(),
631             _allowances[sender][_msgSender()].sub(
632                 amount,
633                 "ERC20: transfer amount exceeds allowance"
634             )
635         );
636         return true;
637     }
638 
639     /**
640      * @dev Atomically increases the allowance granted to `spender` by the caller.
641      *
642      * This is an alternative to {approve} that can be used as a mitigation for
643      * problems described in {IERC20-approve}.
644      *
645      * Emits an {Approval} event indicating the updated allowance.
646      *
647      * Requirements:
648      *
649      * - `spender` cannot be the zero address.
650      */
651     function increaseAllowance(address spender, uint256 addedValue)
652         public
653         virtual
654         returns (bool)
655     {
656         _approve(
657             _msgSender(),
658             spender,
659             _allowances[_msgSender()][spender].add(addedValue)
660         );
661         return true;
662     }
663 
664     /**
665      * @dev Atomically decreases the allowance granted to `spender` by the caller.
666      *
667      * This is an alternative to {approve} that can be used as a mitigation for
668      * problems described in {IERC20-approve}.
669      *
670      * Emits an {Approval} event indicating the updated allowance.
671      *
672      * Requirements:
673      *
674      * - `spender` cannot be the zero address.
675      * - `spender` must have allowance for the caller of at least
676      * `subtractedValue`.
677      */
678     function decreaseAllowance(address spender, uint256 subtractedValue)
679         public
680         virtual
681         returns (bool)
682     {
683         _approve(
684             _msgSender(),
685             spender,
686             _allowances[_msgSender()][spender].sub(
687                 subtractedValue,
688                 "ERC20: decreased allowance below zero"
689             )
690         );
691         return true;
692     }
693 
694     /**
695      * @dev Moves tokens `amount` from `sender` to `recipient`.
696      *
697      * This is internal function is equivalent to {transfer}, and can be used to
698      * e.g. implement automatic token fees, slashing mechanisms, etc.
699      *
700      * Emits a {Transfer} event.
701      *
702      * Requirements:
703      *
704      * - `sender` cannot be the zero address.
705      * - `recipient` cannot be the zero address.
706      * - `sender` must have a balance of at least `amount`.
707      */
708     function _transfer(
709         address sender,
710         address recipient,
711         uint256 amount
712     ) internal virtual {
713         require(sender != address(0), "ERC20: transfer from the zero address");
714         require(recipient != address(0), "ERC20: transfer to the zero address");
715 
716         _beforeTokenTransfer(sender, recipient, amount);
717 
718         _balances[sender] = _balances[sender].sub(
719             amount,
720             "ERC20: transfer amount exceeds balance"
721         );
722         _balances[recipient] = _balances[recipient].add(amount);
723         emit Transfer(sender, recipient, amount);
724     }
725 
726     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
727      * the total supply.
728      *
729      * Emits a {Transfer} event with `from` set to the zero address.
730      *
731      * Requirements
732      *
733      * - `to` cannot be the zero address.
734      */
735     function _mint(address account, uint256 amount) internal virtual {
736         require(account != address(0), "ERC20: mint to the zero address");
737 
738         _beforeTokenTransfer(address(0), account, amount);
739 
740         _totalSupply = _totalSupply.add(amount);
741         _balances[account] = _balances[account].add(amount);
742         emit Transfer(address(0), account, amount);
743     }
744 
745     /**
746      * @dev Destroys `amount` tokens from `account`, reducing the
747      * total supply.
748      *
749      * Emits a {Transfer} event with `to` set to the zero address.
750      *
751      * Requirements
752      *
753      * - `account` cannot be the zero address.
754      * - `account` must have at least `amount` tokens.
755      */
756     function _burn(address account, uint256 amount) internal virtual {
757         require(account != address(0), "ERC20: burn from the zero address");
758 
759         _beforeTokenTransfer(account, address(0), amount);
760 
761         _balances[account] = _balances[account].sub(
762             amount,
763             "ERC20: burn amount exceeds balance"
764         );
765         _totalSupply = _totalSupply.sub(amount);
766         emit Transfer(account, address(0), amount);
767     }
768 
769     /**
770      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
771      *
772      * This internal function is equivalent to `approve`, and can be used to
773      * e.g. set automatic allowances for certain subsystems, etc.
774      *
775      * Emits an {Approval} event.
776      *
777      * Requirements:
778      *
779      * - `owner` cannot be the zero address.
780      * - `spender` cannot be the zero address.
781      */
782     function _approve(
783         address owner,
784         address spender,
785         uint256 amount
786     ) internal virtual {
787         require(owner != address(0), "ERC20: approve from the zero address");
788         require(spender != address(0), "ERC20: approve to the zero address");
789 
790         _allowances[owner][spender] = amount;
791         emit Approval(owner, spender, amount);
792     }
793 
794     /**
795      * @dev Sets {decimals} to a value other than the default one of 18.
796      *
797      * WARNING: This function should only be called from the constructor. Most
798      * applications that interact with token contracts will not expect
799      * {decimals} to ever change, and may work incorrectly if it does.
800      */
801     function _setupDecimals(uint8 decimals_) internal {
802         _decimals = decimals_;
803     }
804 
805     /**
806      * @dev Hook that is called before any transfer of tokens. This includes
807      * minting and burning.
808      *
809      * Calling conditions:
810      *
811      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
812      * will be to transferred to `to`.
813      * - when `from` is zero, `amount` tokens will be minted for `to`.
814      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
815      * - `from` and `to` are never both zero.
816      *
817      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
818      */
819     function _beforeTokenTransfer(
820         address from,
821         address to,
822         uint256 amount
823     ) internal virtual {}
824 }
825 
826 /**
827  * @dev Extension of {ERC20} that allows token holders to destroy both their own
828  * tokens and those that they have an allowance for, in a way that can be
829  * recognized off-chain (via event analysis).
830  */
831 abstract contract ERC20Burnable is Context, ERC20 {
832     /**
833      * @dev Destroys `amount` tokens from the caller.
834      *
835      * See {ERC20-_burn}.
836      */
837     function burn(uint256 amount) public virtual {
838         _burn(_msgSender(), amount);
839     }
840 
841     /**
842      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
843      * allowance.
844      *
845      * See {ERC20-_burn} and {ERC20-allowance}.
846      *
847      * Requirements:
848      *
849      * - the caller must have allowance for ``accounts``'s tokens of at least
850      * `amount`.
851      */
852     function burnFrom(address account, uint256 amount) public virtual {
853         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(
854             amount,
855             "ERC20: burn amount exceeds allowance"
856         );
857 
858         _approve(account, _msgSender(), decreasedAllowance);
859         _burn(account, amount);
860     }
861 }
862 
863 /**
864  * @dev Standard math utilities missing in the Solidity language.
865  */
866 library Math {
867     /**
868      * @dev Returns the largest of two numbers.
869      */
870     function max(uint256 a, uint256 b) internal pure returns (uint256) {
871         return a >= b ? a : b;
872     }
873 
874     /**
875      * @dev Returns the smallest of two numbers.
876      */
877     function min(uint256 a, uint256 b) internal pure returns (uint256) {
878         return a < b ? a : b;
879     }
880 
881     /**
882      * @dev Returns the average of two numbers. The result is rounded towards
883      * zero.
884      */
885     function average(uint256 a, uint256 b) internal pure returns (uint256) {
886         // (a + b) / 2 can overflow, so we distribute
887         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
888     }
889 }
890 
891 /**
892  * @dev L2 token is a mintable token.
893  *
894  * At construction, the deployer of the contract is the only minter.
895  */
896 contract L2 is ERC20Burnable {
897     // Address of the old token contract
898     IERC20 public legacyToken;
899 
900     // To save gas on transfer from allowance equal to the max uint256 will be
901     // considered infinite.
902     uint256 private constant INFINITY = type(uint256).max;
903 
904     constructor(IERC20 legacyToken_) public ERC20("Leverj Gluon", "L2") {
905         require(
906             address(legacyToken_) != address(0),
907             "L2: legacy token is the zero address"
908         );
909         legacyToken = legacyToken_;
910     }
911 
912     function migrate(address account, uint256 amount) public {
913         legacyToken.transferFrom(account, address(this), amount);
914         _mint(account, amount * 1000000000);
915     }
916 
917     /**
918      * @dev Transfers all of an account's allowed balance in the old token to
919      * this contract, and mints the same amount of new tokens for that account.
920      * @param account whose tokens will be migrated
921      */
922     function migrateAll(address account) public {
923         uint256 balance = legacyToken.balanceOf(account);
924         uint256 allowance = legacyToken.allowance(account, address(this));
925         uint256 amount = Math.min(balance, allowance);
926         migrate(account, amount);
927     }
928 
929     /**
930      * @dev See {IERC20-transferFrom}.
931      *
932      * Emits an {Approval} event indicating the updated allowance. This is not
933      * required by the EIP. See the note at the beginning of {ERC20};
934      *
935      * Requirements:
936      * - `sender` and `recipient` cannot be the zero address.
937      * - `sender` must have a balance of at least `amount`.
938      * - the caller must have allowance for ``sender``'s tokens of at least
939      * `amount`.
940      *
941      * Notes:
942      * - this version of the function will consider an allowance equal to the
943      * maximum value representable by uint256 as INFINITY, if this is the case,
944      * the allowance will remain untouched and no {Approval} event will be emited.
945      */
946     function transferFrom(
947         address sender,
948         address recipient,
949         uint256 amount
950     ) public virtual override returns (bool) {
951         _transfer(sender, recipient, amount);
952 
953         uint256 allowed = allowance(sender, _msgSender());
954         if (allowed == INFINITY) {
955             return true;
956         }
957 
958         _approve(
959             sender,
960             _msgSender(),
961             allowed.sub(amount, "ERC20: transfer amount exceeds allowance")
962         );
963         return true;
964     }
965 }