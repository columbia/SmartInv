1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly {
38             size := extcodesize(account)
39         }
40         return size > 0;
41     }
42 
43     /**
44      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
45      * `recipient`, forwarding all available gas and reverting on errors.
46      *
47      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
48      * of certain opcodes, possibly making contracts go over the 2300 gas limit
49      * imposed by `transfer`, making them unable to receive funds via
50      * `transfer`. {sendValue} removes this limitation.
51      *
52      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
53      *
54      * IMPORTANT: because control is transferred to `recipient`, care must be
55      * taken to not create reentrancy vulnerabilities. Consider using
56      * {ReentrancyGuard} or the
57      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
58      */
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(
61             address(this).balance >= amount,
62             "Address: insufficient balance"
63         );
64 
65         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
66         (bool success, ) = recipient.call{value: amount}("");
67         require(
68             success,
69             "Address: unable to send value, recipient may have reverted"
70         );
71     }
72 
73     /**
74      * @dev Performs a Solidity function call using a low level `call`. A
75      * plain`call` is an unsafe replacement for a function call: use this
76      * function instead.
77      *
78      * If `target` reverts with a revert reason, it is bubbled up by this
79      * function (like regular Solidity function calls).
80      *
81      * Returns the raw returned data. To convert to the expected return value,
82      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
83      *
84      * Requirements:
85      *
86      * - `target` must be a contract.
87      * - calling `target` with `data` must not revert.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data)
92         internal
93         returns (bytes memory)
94     {
95         return functionCall(target, data, "Address: low-level call failed");
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
100      * `errorMessage` as a fallback revert reason when `target` reverts.
101      *
102      * _Available since v3.1._
103      */
104     function functionCall(
105         address target,
106         bytes memory data,
107         string memory errorMessage
108     ) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, 0, errorMessage);
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
114      * but also transferring `value` wei to `target`.
115      *
116      * Requirements:
117      *
118      * - the calling contract must have an ETH balance of at least `value`.
119      * - the called Solidity function must be `payable`.
120      *
121      * _Available since v3.1._
122      */
123     function functionCallWithValue(
124         address target,
125         bytes memory data,
126         uint256 value
127     ) internal returns (bytes memory) {
128         return
129             functionCallWithValue(
130                 target,
131                 data,
132                 value,
133                 "Address: low-level call with value failed"
134             );
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
139      * with `errorMessage` as a fallback revert reason when `target` reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(
144         address target,
145         bytes memory data,
146         uint256 value,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         require(
150             address(this).balance >= value,
151             "Address: insufficient balance for call"
152         );
153         require(isContract(target), "Address: call to non-contract");
154 
155         // solhint-disable-next-line avoid-low-level-calls
156         (bool success, bytes memory returndata) = target.call{value: value}(
157             data
158         );
159         return _verifyCallResult(success, returndata, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
164      * but performing a static call.
165      *
166      * _Available since v3.3._
167      */
168     function functionStaticCall(address target, bytes memory data)
169         internal
170         view
171         returns (bytes memory)
172     {
173         return
174             functionStaticCall(
175                 target,
176                 data,
177                 "Address: low-level static call failed"
178             );
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a static call.
184      *
185      * _Available since v3.3._
186      */
187     function functionStaticCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal view returns (bytes memory) {
192         require(isContract(target), "Address: static call to non-contract");
193 
194         // solhint-disable-next-line avoid-low-level-calls
195         (bool success, bytes memory returndata) = target.staticcall(data);
196         return _verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
201      * but performing a delegate call.
202      *
203      * _Available since v3.3._
204      */
205     function functionDelegateCall(address target, bytes memory data)
206         internal
207         returns (bytes memory)
208     {
209         return
210             functionDelegateCall(
211                 target,
212                 data,
213                 "Address: low-level delegate call failed"
214             );
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
219      * but performing a delegate call.
220      *
221      * _Available since v3.3._
222      */
223     function functionDelegateCall(
224         address target,
225         bytes memory data,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(isContract(target), "Address: delegate call to non-contract");
229 
230         // solhint-disable-next-line avoid-low-level-calls
231         (bool success, bytes memory returndata) = target.delegatecall(data);
232         return _verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     function _verifyCallResult(
236         bool success,
237         bytes memory returndata,
238         string memory errorMessage
239     ) private pure returns (bytes memory) {
240         if (success) {
241             return returndata;
242         } else {
243             // Look for revert reason and bubble it up if present
244             if (returndata.length > 0) {
245                 // The easiest way to bubble the revert reason is using memory via assembly
246 
247                 // solhint-disable-next-line no-inline-assembly
248                 assembly {
249                     let returndata_size := mload(returndata)
250                     revert(add(32, returndata), returndata_size)
251                 }
252             } else {
253                 revert(errorMessage);
254             }
255         }
256     }
257 }
258 
259 // Part: Context
260 
261 /*
262  * @dev Provides information about the current execution context, including the
263  * sender of the transaction and its data. While these are generally available
264  * via msg.sender and msg.data, they should not be accessed in such a direct
265  * manner, since when dealing with GSN meta-transactions the account sending and
266  * paying for execution may not be the actual sender (as far as an application
267  * is concerned).
268  *
269  * This contract is only required for intermediate, library-like contracts.
270  */
271 abstract contract Context {
272     function _msgSender() internal virtual view returns (address payable) {
273         return msg.sender;
274     }
275 
276     function _msgData() internal virtual view returns (bytes memory) {
277         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
278         return msg.data;
279     }
280 }
281 
282 // Part: IERC20
283 
284 /**
285  * @dev Interface of the ERC20 standard as defined in the EIP.
286  */
287 interface IERC20 {
288     /**
289      * @dev Returns the amount of tokens in existence.
290      */
291     function totalSupply() external view returns (uint256);
292 
293     /**
294      * @dev Returns the amount of tokens owned by `account`.
295      */
296     function balanceOf(address account) external view returns (uint256);
297 
298     /**
299      * @dev Moves `amount` tokens from the caller's account to `recipient`.
300      *
301      * Returns a boolean value indicating whether the operation succeeded.
302      *
303      * Emits a {Transfer} event.
304      */
305     function transfer(address recipient, uint256 amount)
306         external
307         returns (bool);
308 
309     /**
310      * @dev Returns the remaining number of tokens that `spender` will be
311      * allowed to spend on behalf of `owner` through {transferFrom}. This is
312      * zero by default.
313      *
314      * This value changes when {approve} or {transferFrom} are called.
315      */
316     function allowance(address owner, address spender)
317         external
318         view
319         returns (uint256);
320 
321     /**
322      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
323      *
324      * Returns a boolean value indicating whether the operation succeeded.
325      *
326      * IMPORTANT: Beware that changing an allowance with this method brings the risk
327      * that someone may use both the old and the new allowance by unfortunate
328      * transaction ordering. One possible solution to mitigate this race
329      * condition is to first reduce the spender's allowance to 0 and set the
330      * desired value afterwards:
331      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
332      *
333      * Emits an {Approval} event.
334      */
335     function approve(address spender, uint256 amount) external returns (bool);
336 
337     /**
338      * @dev Moves `amount` tokens from `sender` to `recipient` using the
339      * allowance mechanism. `amount` is then deducted from the caller's
340      * allowance.
341      *
342      * Returns a boolean value indicating whether the operation succeeded.
343      *
344      * Emits a {Transfer} event.
345      */
346     function transferFrom(
347         address sender,
348         address recipient,
349         uint256 amount
350     ) external returns (bool);
351 
352     /**
353      * @dev Emitted when `value` tokens are moved from one account (`from`) to
354      * another (`to`).
355      *
356      * Note that `value` may be zero.
357      */
358     event Transfer(address indexed from, address indexed to, uint256 value);
359 
360     /**
361      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
362      * a call to {approve}. `value` is the new allowance.
363      */
364     event Approval(
365         address indexed owner,
366         address indexed spender,
367         uint256 value
368     );
369 }
370 
371 // Part: SafeMath
372 
373 /**
374  * @dev Wrappers over Solidity's arithmetic operations with added overflow
375  * checks.
376  *
377  * Arithmetic operations in Solidity wrap on overflow. This can easily result
378  * in bugs, because programmers usually assume that an overflow raises an
379  * error, which is the standard behavior in high level programming languages.
380  * `SafeMath` restores this intuition by reverting the transaction when an
381  * operation overflows.
382  *
383  * Using this library instead of the unchecked operations eliminates an entire
384  * class of bugs, so it's recommended to use it always.
385  */
386 library SafeMath {
387     /**
388      * @dev Returns the addition of two unsigned integers, reverting on overflow.
389      *
390      * Counterpart to Solidity's `+` operator.
391      *
392      * Requirements:
393      * - Addition cannot overflow.
394      */
395     function add(uint256 a, uint256 b) internal pure returns (uint256) {
396         uint256 c = a + b;
397         require(c >= a, "add: +");
398 
399         return c;
400     }
401 
402     /**
403      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
404      *
405      * Counterpart to Solidity's `+` operator.
406      *
407      * Requirements:
408      * - Addition cannot overflow.
409      */
410     function add(
411         uint256 a,
412         uint256 b,
413         string memory errorMessage
414     ) internal pure returns (uint256) {
415         uint256 c = a + b;
416         require(c >= a, errorMessage);
417 
418         return c;
419     }
420 
421     /**
422      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
423      *
424      * Counterpart to Solidity's `-` operator.
425      *
426      * Requirements:
427      * - Subtraction cannot underflow.
428      */
429     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
430         return sub(a, b, "sub: -");
431     }
432 
433     /**
434      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
435      *
436      * Counterpart to Solidity's `-` operator.
437      *
438      * Requirements:
439      * - Subtraction cannot underflow.
440      */
441     function sub(
442         uint256 a,
443         uint256 b,
444         string memory errorMessage
445     ) internal pure returns (uint256) {
446         require(b <= a, errorMessage);
447         uint256 c = a - b;
448 
449         return c;
450     }
451 
452     /**
453      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
454      *
455      * Counterpart to Solidity's `*` operator.
456      *
457      * Requirements:
458      * - Multiplication cannot overflow.
459      */
460     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
461         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
462         // benefit is lost if 'b' is also tested.
463         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
464         if (a == 0) {
465             return 0;
466         }
467 
468         uint256 c = a * b;
469         require(c / a == b, "mul: *");
470 
471         return c;
472     }
473 
474     /**
475      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
476      *
477      * Counterpart to Solidity's `*` operator.
478      *
479      * Requirements:
480      * - Multiplication cannot overflow.
481      */
482     function mul(
483         uint256 a,
484         uint256 b,
485         string memory errorMessage
486     ) internal pure returns (uint256) {
487         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
488         // benefit is lost if 'b' is also tested.
489         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
490         if (a == 0) {
491             return 0;
492         }
493 
494         uint256 c = a * b;
495         require(c / a == b, errorMessage);
496 
497         return c;
498     }
499 
500     /**
501      * @dev Returns the integer division of two unsigned integers.
502      * Reverts on division by zero. The result is rounded towards zero.
503      *
504      * Counterpart to Solidity's `/` operator. Note: this function uses a
505      * `revert` opcode (which leaves remaining gas untouched) while Solidity
506      * uses an invalid opcode to revert (consuming all remaining gas).
507      *
508      * Requirements:
509      * - The divisor cannot be zero.
510      */
511     function div(uint256 a, uint256 b) internal pure returns (uint256) {
512         return div(a, b, "div: /");
513     }
514 
515     /**
516      * @dev Returns the integer division of two unsigned integers.
517      * Reverts with custom message on division by zero. The result is rounded towards zero.
518      *
519      * Counterpart to Solidity's `/` operator. Note: this function uses a
520      * `revert` opcode (which leaves remaining gas untouched) while Solidity
521      * uses an invalid opcode to revert (consuming all remaining gas).
522      *
523      * Requirements:
524      * - The divisor cannot be zero.
525      */
526     function div(
527         uint256 a,
528         uint256 b,
529         string memory errorMessage
530     ) internal pure returns (uint256) {
531         // Solidity only automatically asserts when dividing by 0
532         require(b > 0, errorMessage);
533         uint256 c = a / b;
534         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
535 
536         return c;
537     }
538 
539     /**
540      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
541      * Reverts when dividing by zero.
542      *
543      * Counterpart to Solidity's `%` operator. This function uses a `revert`
544      * opcode (which leaves remaining gas untouched) while Solidity uses an
545      * invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      * - The divisor cannot be zero.
549      */
550     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
551         return mod(a, b, "mod: %");
552     }
553 
554     /**
555      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
556      * Reverts with custom message when dividing by zero.
557      *
558      * Counterpart to Solidity's `%` operator. This function uses a `revert`
559      * opcode (which leaves remaining gas untouched) while Solidity uses an
560      * invalid opcode to revert (consuming all remaining gas).
561      *
562      * Requirements:
563      * - The divisor cannot be zero.
564      */
565     function mod(
566         uint256 a,
567         uint256 b,
568         string memory errorMessage
569     ) internal pure returns (uint256) {
570         require(b != 0, errorMessage);
571         return a % b;
572     }
573 }
574 
575 // Part: ERC20
576 
577 // File: contracts/token/ERC20/ERC20.sol
578 
579 /**
580  * @dev Implementation of the {IERC20} interface.
581  *
582  * This implementation is agnostic to the way tokens are created. This means
583  * that a supply mechanism has to be added in a derived contract using {_mint}.
584  * For a generic mechanism see {ERC20PresetMinterPauser}.
585  *
586  * TIP: For a detailed writeup see our guide
587  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
588  * to implement supply mechanisms].
589  *
590  * We have followed general OpenZeppelin guidelines: functions revert instead
591  * of returning `false` on failure. This behavior is nonetheless conventional
592  * and does not conflict with the expectations of ERC20 applications.
593  *
594  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
595  * This allows applications to reconstruct the allowance for all accounts just
596  * by listening to said events. Other implementations of the EIP may not emit
597  * these events, as it isn't required by the specification.
598  *
599  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
600  * functions have been added to mitigate the well-known issues around setting
601  * allowances. See {IERC20-approve}.
602  */
603 contract ERC20 is Context, IERC20 {
604     using SafeMath for uint256;
605     using Address for address;
606 
607     mapping(address => uint256) private _balances;
608 
609     mapping(address => mapping(address => uint256)) private _allowances;
610 
611     uint256 private _totalSupply;
612 
613     string private _name;
614     string private _symbol;
615     uint8 private _decimals;
616 
617     /**
618      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
619      * a default value of 18.
620      *
621      * To select a different value for {decimals}, use {_setupDecimals}.
622      *
623      * All three of these values are immutable: they can only be set once during
624      * construction.
625      */
626     constructor(string memory name, string memory symbol) public {
627         _name = name;
628         _symbol = symbol;
629         _decimals = 18;
630     }
631 
632     /**
633      * @dev Returns the name of the token.
634      */
635     function name() public view returns (string memory) {
636         return _name;
637     }
638 
639     /**
640      * @dev Returns the symbol of the token, usually a shorter version of the
641      * name.
642      */
643     function symbol() public view returns (string memory) {
644         return _symbol;
645     }
646 
647     /**
648      * @dev Returns the number of decimals used to get its user representation.
649      * For example, if `decimals` equals `2`, a balance of `505` tokens should
650      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
651      *
652      * Tokens usually opt for a value of 18, imitating the relationship between
653      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
654      * called.
655      *
656      * NOTE: This information is only used for _display_ purposes: it in
657      * no way affects any of the arithmetic of the contract, including
658      * {IERC20-balanceOf} and {IERC20-transfer}.
659      */
660     function decimals() public view returns (uint8) {
661         return _decimals;
662     }
663 
664     /**
665      * @dev See {IERC20-totalSupply}.
666      */
667     function totalSupply() public override view returns (uint256) {
668         return _totalSupply;
669     }
670 
671     /**
672      * @dev See {IERC20-balanceOf}.
673      */
674     function balanceOf(address account) public override view returns (uint256) {
675         return _balances[account];
676     }
677 
678     /**
679      * @dev See {IERC20-transfer}.
680      *
681      * Requirements:
682      *
683      * - `recipient` cannot be the zero address.
684      * - the caller must have a balance of at least `amount`.
685      */
686     function transfer(address recipient, uint256 amount)
687         public
688         virtual
689         override
690         returns (bool)
691     {
692         _transfer(_msgSender(), recipient, amount);
693         return true;
694     }
695 
696     /**
697      * @dev See {IERC20-allowance}.
698      */
699     function allowance(address owner, address spender)
700         public
701         virtual
702         override
703         view
704         returns (uint256)
705     {
706         return _allowances[owner][spender];
707     }
708 
709     /**
710      * @dev See {IERC20-approve}.
711      *
712      * Requirements:
713      *
714      * - `spender` cannot be the zero address.
715      */
716     function approve(address spender, uint256 amount)
717         public
718         virtual
719         override
720         returns (bool)
721     {
722         _approve(_msgSender(), spender, amount);
723         return true;
724     }
725 
726     /**
727      * @dev See {IERC20-transferFrom}.
728      *
729      * Emits an {Approval} event indicating the updated allowance. This is not
730      * required by the EIP. See the note at the beginning of {ERC20};
731      *
732      * Requirements:
733      * - `sender` and `recipient` cannot be the zero address.
734      * - `sender` must have a balance of at least `amount`.
735      * - the caller must have allowance for ``sender``'s tokens of at least
736      * `amount`.
737      */
738     function transferFrom(
739         address sender,
740         address recipient,
741         uint256 amount
742     ) public virtual override returns (bool) {
743         _transfer(sender, recipient, amount);
744         _approve(
745             sender,
746             _msgSender(),
747             _allowances[sender][_msgSender()].sub(
748                 amount,
749                 "ERC20: transfer amount exceeds allowance"
750             )
751         );
752         return true;
753     }
754 
755     /**
756      * @dev Atomically increases the allowance granted to `spender` by the caller.
757      *
758      * This is an alternative to {approve} that can be used as a mitigation for
759      * problems described in {IERC20-approve}.
760      *
761      * Emits an {Approval} event indicating the updated allowance.
762      *
763      * Requirements:
764      *
765      * - `spender` cannot be the zero address.
766      */
767     function increaseAllowance(address spender, uint256 addedValue)
768         public
769         virtual
770         returns (bool)
771     {
772         _approve(
773             _msgSender(),
774             spender,
775             _allowances[_msgSender()][spender].add(addedValue)
776         );
777         return true;
778     }
779 
780     /**
781      * @dev Atomically decreases the allowance granted to `spender` by the caller.
782      *
783      * This is an alternative to {approve} that can be used as a mitigation for
784      * problems described in {IERC20-approve}.
785      *
786      * Emits an {Approval} event indicating the updated allowance.
787      *
788      * Requirements:
789      *
790      * - `spender` cannot be the zero address.
791      * - `spender` must have allowance for the caller of at least
792      * `subtractedValue`.
793      */
794     function decreaseAllowance(address spender, uint256 subtractedValue)
795         public
796         virtual
797         returns (bool)
798     {
799         _approve(
800             _msgSender(),
801             spender,
802             _allowances[_msgSender()][spender].sub(
803                 subtractedValue,
804                 "ERC20: decreased allowance below zero"
805             )
806         );
807         return true;
808     }
809 
810     /**
811      * @dev Moves tokens `amount` from `sender` to `recipient`.
812      *
813      * This is internal function is equivalent to {transfer}, and can be used to
814      * e.g. implement automatic token fees, slashing mechanisms, etc.
815      *
816      * Emits a {Transfer} event.
817      *
818      * Requirements:
819      *
820      * - `sender` cannot be the zero address.
821      * - `recipient` cannot be the zero address.
822      * - `sender` must have a balance of at least `amount`.
823      */
824     function _transfer(
825         address sender,
826         address recipient,
827         uint256 amount
828     ) internal virtual {
829         require(sender != address(0), "ERC20: transfer from the zero address");
830         require(recipient != address(0), "ERC20: transfer to the zero address");
831 
832         _beforeTokenTransfer(sender, recipient, amount);
833 
834         _balances[sender] = _balances[sender].sub(
835             amount,
836             "ERC20: transfer amount exceeds balance"
837         );
838         _balances[recipient] = _balances[recipient].add(amount);
839         emit Transfer(sender, recipient, amount);
840     }
841 
842     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
843      * the total supply.
844      *
845      * Emits a {Transfer} event with `from` set to the zero address.
846      *
847      * Requirements
848      *
849      * - `to` cannot be the zero address.
850      */
851     function _mint(address account, uint256 amount) internal virtual {
852         require(account != address(0), "ERC20: mint to the zero address");
853 
854         _beforeTokenTransfer(address(0), account, amount);
855 
856         _totalSupply = _totalSupply.add(amount);
857         _balances[account] = _balances[account].add(amount);
858         emit Transfer(address(0), account, amount);
859     }
860 
861     /**
862      * @dev Destroys `amount` tokens from `account`, reducing the
863      * total supply.
864      *
865      * Emits a {Transfer} event with `to` set to the zero address.
866      *
867      * Requirements
868      *
869      * - `account` cannot be the zero address.
870      * - `account` must have at least `amount` tokens.
871      */
872     function _burn(address account, uint256 amount) internal virtual {
873         require(account != address(0), "ERC20: burn from the zero address");
874 
875         _beforeTokenTransfer(account, address(0), amount);
876 
877         _balances[account] = _balances[account].sub(
878             amount,
879             "ERC20: burn amount exceeds balance"
880         );
881         _totalSupply = _totalSupply.sub(amount);
882         emit Transfer(account, address(0), amount);
883     }
884 
885     /**
886      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
887      *
888      * This internal function is equivalent to `approve`, and can be used to
889      * e.g. set automatic allowances for certain subsystems, etc.
890      *
891      * Emits an {Approval} event.
892      *
893      * Requirements:
894      *
895      * - `owner` cannot be the zero address.
896      * - `spender` cannot be the zero address.
897      */
898     function _approve(
899         address owner,
900         address spender,
901         uint256 amount
902     ) internal virtual {
903         require(owner != address(0), "ERC20: approve from the zero address");
904         require(spender != address(0), "ERC20: approve to the zero address");
905 
906         _allowances[owner][spender] = amount;
907         emit Approval(owner, spender, amount);
908     }
909 
910     /**
911      * @dev Sets {decimals} to a value other than the default one of 18.
912      *
913      * WARNING: This function should only be called from the constructor. Most
914      * applications that interact with token contracts will not expect
915      * {decimals} to ever change, and may work incorrectly if it does.
916      */
917     function _setupDecimals(uint8 decimals_) internal {
918         _decimals = decimals_;
919     }
920 
921     /**
922      * @dev Hook that is called before any transfer of tokens. This includes
923      * minting and burning.
924      *
925      * Calling conditions:
926      *
927      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
928      * will be to transferred to `to`.
929      * - when `from` is zero, `amount` tokens will be minted for `to`.
930      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
931      * - `from` and `to` are never both zero.
932      *
933      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
934      */
935     function _beforeTokenTransfer(
936         address from,
937         address to,
938         uint256 amount
939     ) internal virtual {}
940 }
941 
942 // Part: Ownable
943 
944 /**
945  * @dev Contract module which provides a basic access control mechanism, where
946  * there is an account (an owner) that can be granted exclusive access to
947  * specific functions.
948  *
949  * By default, the owner account will be the one that deploys the contract. This
950  * can later be changed with {transferOwnership}.
951  *
952  * This module is used through inheritance. It will make available the modifier
953  * `onlyOwner`, which can be applied to your functions to restrict their use to
954  * the owner.
955  */
956 contract Ownable is Context {
957     address private _owner;
958 
959     event OwnershipTransferred(
960         address indexed previousOwner,
961         address indexed newOwner
962     );
963 
964     /**
965      * @dev Initializes the contract setting the deployer as the initial owner.
966      */
967     constructor() internal {
968         address msgSender = _msgSender();
969         _owner = msgSender;
970         emit OwnershipTransferred(address(0), msgSender);
971     }
972 
973     /**
974      * @dev Returns the address of the current owner.
975      */
976     function owner() public view returns (address) {
977         return _owner;
978     }
979 
980     /**
981      * @dev Throws if called by any account other than the owner.
982      */
983     modifier onlyOwner() {
984         require(_owner == _msgSender(), "Ownable: caller is not the owner");
985         _;
986     }
987 
988     /**
989      * @dev Leaves the contract without owner. It will not be possible to call
990      * `onlyOwner` functions anymore. Can only be called by the current owner.
991      *
992      * NOTE: Renouncing ownership will leave the contract without an owner,
993      * thereby removing any functionality that is only available to the owner.
994      */
995     function renounceOwnership() public virtual onlyOwner {
996         emit OwnershipTransferred(_owner, address(0));
997         _owner = address(0);
998     }
999 
1000     /**
1001      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1002      * Can only be called by the current owner.
1003      */
1004     function transferOwnership(address newOwner) public virtual onlyOwner {
1005         require(
1006             newOwner != address(0),
1007             "Ownable: new owner is the zero address"
1008         );
1009         emit OwnershipTransferred(_owner, newOwner);
1010         _owner = newOwner;
1011     }
1012 }
1013 
1014 // Part: SafeERC20
1015 
1016 /**
1017  * @title SafeERC20
1018  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1019  * contract returns false). Tokens that return no value (and instead revert or
1020  * throw on failure) are also supported, non-reverting calls are assumed to be
1021  * successful.
1022  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1023  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1024  */
1025 library SafeERC20 {
1026     using SafeMath for uint256;
1027     using Address for address;
1028 
1029     function safeTransfer(
1030         IERC20 token,
1031         address to,
1032         uint256 value
1033     ) internal {
1034         _callOptionalReturn(
1035             token,
1036             abi.encodeWithSelector(token.transfer.selector, to, value)
1037         );
1038     }
1039 
1040     function safeTransferFrom(
1041         IERC20 token,
1042         address from,
1043         address to,
1044         uint256 value
1045     ) internal {
1046         _callOptionalReturn(
1047             token,
1048             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1049         );
1050     }
1051 
1052     /**
1053      * @dev Deprecated. This function has issues similar to the ones found in
1054      * {IERC20-approve}, and its usage is discouraged.
1055      *
1056      * Whenever possible, use {safeIncreaseAllowance} and
1057      * {safeDecreaseAllowance} instead.
1058      */
1059     function safeApprove(
1060         IERC20 token,
1061         address spender,
1062         uint256 value
1063     ) internal {
1064         // safeApprove should only be called when setting an initial allowance,
1065         // or when resetting it to zero. To increase and decrease it, use
1066         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1067         // solhint-disable-next-line max-line-length
1068         require(
1069             (value == 0) || (token.allowance(address(this), spender) == 0),
1070             "SafeERC20: approve from non-zero to non-zero allowance"
1071         );
1072         _callOptionalReturn(
1073             token,
1074             abi.encodeWithSelector(token.approve.selector, spender, value)
1075         );
1076     }
1077 
1078     function safeIncreaseAllowance(
1079         IERC20 token,
1080         address spender,
1081         uint256 value
1082     ) internal {
1083         uint256 newAllowance = token.allowance(address(this), spender).add(
1084             value
1085         );
1086         _callOptionalReturn(
1087             token,
1088             abi.encodeWithSelector(
1089                 token.approve.selector,
1090                 spender,
1091                 newAllowance
1092             )
1093         );
1094     }
1095 
1096     function safeDecreaseAllowance(
1097         IERC20 token,
1098         address spender,
1099         uint256 value
1100     ) internal {
1101         uint256 newAllowance = token.allowance(address(this), spender).sub(
1102             value,
1103             "SafeERC20: decreased allowance below zero"
1104         );
1105         _callOptionalReturn(
1106             token,
1107             abi.encodeWithSelector(
1108                 token.approve.selector,
1109                 spender,
1110                 newAllowance
1111             )
1112         );
1113     }
1114 
1115     /**
1116      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1117      * on the return value: the return value is optional (but if data is returned, it must not be false).
1118      * @param token The token targeted by the call.
1119      * @param data The call data (encoded using abi.encode or one of its variants).
1120      */
1121     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1122         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1123         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1124         // the target address contains contract code and also asserts for success in the low-level call.
1125 
1126         bytes memory returndata = address(token).functionCall(
1127             data,
1128             "SafeERC20: low-level call failed"
1129         );
1130         if (returndata.length > 0) {
1131             // Return data is optional
1132             // solhint-disable-next-line max-line-length
1133             require(
1134                 abi.decode(returndata, (bool)),
1135                 "SafeERC20: ERC20 operation did not succeed"
1136             );
1137         }
1138     }
1139 }
1140 
1141 // Part: StakeDaoToken
1142 
1143 // StakeDaoToken with Governance.
1144 contract StakeDaoToken is ERC20("Stake Dao Token", "SDT"), Ownable {
1145     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1146     function mint(address _to, uint256 _amount) public onlyOwner {
1147         _mint(_to, _amount);
1148     }
1149 }
1150 
1151 // File: MasterChef.sol
1152 
1153 // MasterChef was the master of sdt. He now governs over SDT. He can make SDTs and he is a fair guy.
1154 //
1155 // Note that it's ownable and the owner wields tremendous power. The ownership
1156 // will be transferred to a governance smart contract once SDTS is sufficiently
1157 // distributed and the community can show to govern itself.
1158 //
1159 // Have fun reading it. Hopefully it's bug-free. God bless.
1160 contract MasterChef is Ownable {
1161     using SafeMath for uint256;
1162     using SafeERC20 for IERC20;
1163 
1164     // Info of each user.
1165     struct UserInfo {
1166         uint256 amount; // How many LP tokens the user has provided.
1167         uint256 rewardDebt; // Reward debt. See explanation below.
1168         //
1169         // We do some fancy math here. Basically, any point in time, the amount of SDTs
1170         // entitled to a user but is pending to be distributed is:
1171         //
1172         //   pending reward = (user.amount * pool.accSdtPerShare) - user.rewardDebt
1173         //
1174         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1175         //   1. The pool's `accSdtPerShare` (and `lastRewardBlock`) gets updated.
1176         //   2. User receives the pending reward sent to his/her address.
1177         //   3. User's `amount` gets updated.
1178         //   4. User's `rewardDebt` gets updated.
1179     }
1180 
1181     // Info of each pool.
1182     struct PoolInfo {
1183         IERC20 lpToken; // Address of LP token contract.
1184         uint256 allocPoint; // How many allocation points assigned to this pool. SDTs to distribute per block.
1185         uint256 lastRewardBlock; // Last block number that SDTs distribution occurs.
1186         uint256 accSdtPerShare; // Accumulated SDTs per share, times 1e12. See below.
1187     }
1188 
1189     // The SDT TOKEN!
1190     StakeDaoToken public sdt;
1191     // Dev fund (2%, initially)
1192     uint256 public devFundDivRate = 50;
1193     // Dev address.
1194     address public devaddr;
1195     // Block number when bonus SDT period ends.
1196     uint256 public bonusEndBlock;
1197     // SDT tokens created per block.
1198     uint256 public sdtPerBlock;
1199     // Bonus muliplier for early sdt makers.
1200     uint256 public constant BONUS_MULTIPLIER = 2;
1201 
1202     // Info of each pool.
1203     PoolInfo[] public poolInfo;
1204     // Info of each user that stakes LP tokens.
1205     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1206     // Total allocation points. Must be the sum of all allocation points in all pools.
1207     uint256 public totalAllocPoint = 0;
1208     // The block number when SDT mining starts.
1209     uint256 public startBlock;
1210 
1211     // Events
1212     event Recovered(address token, uint256 amount);
1213     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1214     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1215     event EmergencyWithdraw(
1216         address indexed user,
1217         uint256 indexed pid,
1218         uint256 amount
1219     );
1220 
1221     constructor(
1222         StakeDaoToken _sdt,
1223         address _devaddr,
1224         uint256 _sdtPerBlock,
1225         uint256 _startBlock,
1226         uint256 _bonusEndBlock
1227     ) public {
1228         sdt = _sdt;
1229         devaddr = _devaddr;
1230         sdtPerBlock = _sdtPerBlock;
1231         bonusEndBlock = _bonusEndBlock;
1232         startBlock = _startBlock;
1233     }
1234 
1235     function poolLength() external view returns (uint256) {
1236         return poolInfo.length;
1237     }
1238 
1239     // Add a new lp to the pool. Can only be called by the owner.
1240     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1241     function add(
1242         uint256 _allocPoint,
1243         IERC20 _lpToken,
1244         bool _withUpdate
1245     ) public onlyOwner {
1246         if (_withUpdate) {
1247             massUpdatePools();
1248         }
1249         uint256 lastRewardBlock = block.number > startBlock
1250             ? block.number
1251             : startBlock;
1252         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1253         poolInfo.push(
1254             PoolInfo({
1255                 lpToken: _lpToken,
1256                 allocPoint: _allocPoint,
1257                 lastRewardBlock: lastRewardBlock,
1258                 accSdtPerShare: 0
1259             })
1260         );
1261     }
1262 
1263     // Update the given pool's SDT allocation point. Can only be called by the owner.
1264     function set(
1265         uint256 _pid,
1266         uint256 _allocPoint,
1267         bool _withUpdate
1268     ) public onlyOwner {
1269         if (_withUpdate) {
1270             massUpdatePools();
1271         }
1272         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1273             _allocPoint
1274         );
1275         poolInfo[_pid].allocPoint = _allocPoint;
1276     }
1277 
1278     // Return reward multiplier over the given _from to _to block.
1279     function getMultiplier(uint256 _from, uint256 _to)
1280         public
1281         view
1282         returns (uint256)
1283     {
1284         if (_to <= bonusEndBlock) {
1285             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1286         } else if (_from >= bonusEndBlock) {
1287             return _to.sub(_from);
1288         } else {
1289             return
1290                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1291                     _to.sub(bonusEndBlock)
1292                 );
1293         }
1294     }
1295 
1296     // View function to see pending SDTs on frontend.
1297     function pendingSdt(uint256 _pid, address _user)
1298         external
1299         view
1300         returns (uint256)
1301     {
1302         PoolInfo storage pool = poolInfo[_pid];
1303         UserInfo storage user = userInfo[_pid][_user];
1304         uint256 accSdtPerShare = pool.accSdtPerShare;
1305         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1306         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1307             uint256 multiplier = getMultiplier(
1308                 pool.lastRewardBlock,
1309                 block.number
1310             );
1311             uint256 sdtReward = multiplier
1312                 .mul(sdtPerBlock)
1313                 .mul(pool.allocPoint)
1314                 .div(totalAllocPoint);
1315             accSdtPerShare = accSdtPerShare.add(
1316                 sdtReward.mul(1e12).div(lpSupply)
1317             );
1318         }
1319         return user.amount.mul(accSdtPerShare).div(1e12).sub(user.rewardDebt);
1320     }
1321 
1322     // Update reward vairables for all pools. Be careful of gas spending!
1323     function massUpdatePools() public {
1324         uint256 length = poolInfo.length;
1325         for (uint256 pid = 0; pid < length; ++pid) {
1326             updatePool(pid);
1327         }
1328     }
1329 
1330     // Update reward variables of the given pool to be up-to-date.
1331     function updatePool(uint256 _pid) public {
1332         PoolInfo storage pool = poolInfo[_pid];
1333         if (block.number <= pool.lastRewardBlock) {
1334             return;
1335         }
1336         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1337         if (lpSupply == 0) {
1338             pool.lastRewardBlock = block.number;
1339             return;
1340         }
1341         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1342         uint256 sdtReward = multiplier
1343             .mul(sdtPerBlock)
1344             .mul(pool.allocPoint)
1345             .div(totalAllocPoint);
1346         sdt.mint(devaddr, sdtReward.div(devFundDivRate));
1347         sdt.mint(address(this), sdtReward);
1348         pool.accSdtPerShare = pool.accSdtPerShare.add(
1349             sdtReward.mul(1e12).div(lpSupply)
1350         );
1351         pool.lastRewardBlock = block.number;
1352     }
1353 
1354     // Deposit LP tokens to MasterChef for SDT allocation.
1355     function deposit(uint256 _pid, uint256 _amount) public {
1356         PoolInfo storage pool = poolInfo[_pid];
1357         UserInfo storage user = userInfo[_pid][msg.sender];
1358         updatePool(_pid);
1359         if (user.amount > 0) {
1360             uint256 pending = user
1361                 .amount
1362                 .mul(pool.accSdtPerShare)
1363                 .div(1e12)
1364                 .sub(user.rewardDebt);
1365             safeSdtTransfer(msg.sender, pending);
1366         }
1367         pool.lpToken.safeTransferFrom(
1368             address(msg.sender),
1369             address(this),
1370             _amount
1371         );
1372         user.amount = user.amount.add(_amount);
1373         user.rewardDebt = user.amount.mul(pool.accSdtPerShare).div(1e12);
1374         emit Deposit(msg.sender, _pid, _amount);
1375     }
1376 
1377     // Withdraw LP tokens from MasterChef.
1378     function withdraw(uint256 _pid, uint256 _amount) public {
1379         PoolInfo storage pool = poolInfo[_pid];
1380         UserInfo storage user = userInfo[_pid][msg.sender];
1381         require(user.amount >= _amount, "withdraw: not good");
1382         updatePool(_pid);
1383         uint256 pending = user.amount.mul(pool.accSdtPerShare).div(1e12).sub(
1384             user.rewardDebt
1385         );
1386         safeSdtTransfer(msg.sender, pending);
1387         user.amount = user.amount.sub(_amount);
1388         user.rewardDebt = user.amount.mul(pool.accSdtPerShare).div(1e12);
1389         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1390         emit Withdraw(msg.sender, _pid, _amount);
1391     }
1392 
1393     // Withdraw without caring about rewards. EMERGENCY ONLY.
1394     function emergencyWithdraw(uint256 _pid) public {
1395         PoolInfo storage pool = poolInfo[_pid];
1396         UserInfo storage user = userInfo[_pid][msg.sender];
1397         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1398         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1399         user.amount = 0;
1400         user.rewardDebt = 0;
1401     }
1402 
1403     // Safe sdt transfer function, just in case if rounding error causes pool to not have enough SDTs.
1404     function safeSdtTransfer(address _to, uint256 _amount) internal {
1405         uint256 sdtBal = sdt.balanceOf(address(this));
1406         if (_amount > sdtBal) {
1407             sdt.transfer(_to, sdtBal);
1408         } else {
1409             sdt.transfer(_to, _amount);
1410         }
1411     }
1412 
1413     // Update dev address by the previous dev.
1414     function dev(address _devaddr) public {
1415         require(msg.sender == devaddr, "dev: wut?");
1416         devaddr = _devaddr;
1417     }
1418 
1419     // **** Additional functions separate from the original masterchef contract ****
1420 
1421     function setSdtPerBlock(uint256 _sdtPerBlock) public onlyOwner {
1422         require(_sdtPerBlock > 0, "!sdtPerBlock-0");
1423 
1424         sdtPerBlock = _sdtPerBlock;
1425     }
1426 
1427     function setBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {
1428         bonusEndBlock = _bonusEndBlock;
1429     }
1430 
1431     function setDevFundDivRate(uint256 _devFundDivRate) public onlyOwner {
1432         require(_devFundDivRate > 0, "!devFundDivRate-0");
1433         devFundDivRate = _devFundDivRate;
1434     }
1435 }
