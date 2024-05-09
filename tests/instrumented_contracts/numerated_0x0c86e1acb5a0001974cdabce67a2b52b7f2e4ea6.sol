1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-12
3  */
4 
5 // SPDX-License-Identifier: AGPL-3.0-or-later
6 pragma solidity 0.7.5;
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations with added overflow
10  * checks.
11  *
12  * Arithmetic operations in Solidity wrap on overflow. This can easily result
13  * in bugs, because programmers usually assume that an overflow raises an
14  * error, which is the standard behavior in high level programming languages.
15  * `SafeMath` restores this intuition by reverting the transaction when an
16  * operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on
24      * overflow.
25      *
26      * Counterpart to Solidity's `+` operator.
27      *
28      * Requirements:
29      *
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      *
47      * - Subtraction cannot overflow.
48      */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
55      * overflow (when the result is negative).
56      *
57      * Counterpart to Solidity's `-` operator.
58      *
59      * Requirements:
60      *
61      * - Subtraction cannot overflow.
62      */
63     function sub(
64         uint256 a,
65         uint256 b,
66         string memory errorMessage
67     ) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `*` operator.
79      *
80      * Requirements:
81      *
82      * - Multiplication cannot overflow.
83      */
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the integer division of two unsigned integers. Reverts on
100      * division by zero. The result is rounded towards zero.
101      *
102      * Counterpart to Solidity's `/` operator. Note: this function uses a
103      * `revert` opcode (which leaves remaining gas untouched) while Solidity
104      * uses an invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      *
108      * - The divisor cannot be zero.
109      */
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function div(
127         uint256 a,
128         uint256 b,
129         string memory errorMessage
130     ) internal pure returns (uint256) {
131         require(b > 0, errorMessage);
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return mod(a, b, "SafeMath: modulo by zero");
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * Reverts with custom message when dividing by zero.
157      *
158      * Counterpart to Solidity's `%` operator. This function uses a `revert`
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function mod(
167         uint256 a,
168         uint256 b,
169         string memory errorMessage
170     ) internal pure returns (uint256) {
171         require(b != 0, errorMessage);
172         return a % b;
173     }
174 
175     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
176     function sqrrt(uint256 a) internal pure returns (uint256 c) {
177         if (a > 3) {
178             c = a;
179             uint256 b = add(div(a, 2), 1);
180             while (b < c) {
181                 c = b;
182                 b = div(add(div(a, b), b), 2);
183             }
184         } else if (a != 0) {
185             c = 1;
186         }
187     }
188 
189     /*
190      * Expects percentage to be trailed by 00,
191      */
192     function percentageAmount(uint256 total_, uint8 percentage_)
193         internal
194         pure
195         returns (uint256 percentAmount_)
196     {
197         return div(mul(total_, percentage_), 1000);
198     }
199 
200     /*
201      * Expects percentage to be trailed by 00,
202      */
203     function substractPercentage(uint256 total_, uint8 percentageToSub_)
204         internal
205         pure
206         returns (uint256 result_)
207     {
208         return sub(total_, div(mul(total_, percentageToSub_), 1000));
209     }
210 
211     function percentageOfTotal(uint256 part_, uint256 total_)
212         internal
213         pure
214         returns (uint256 percent_)
215     {
216         return div(mul(part_, 100), total_);
217     }
218 
219     /**
220      * Taken from Hypersonic https://github.com/M2629/HyperSonic/blob/main/Math.sol
221      * @dev Returns the average of two numbers. The result is rounded towards
222      * zero.
223      */
224     function average(uint256 a, uint256 b) internal pure returns (uint256) {
225         // (a + b) / 2 can overflow, so we distribute
226         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
227     }
228 
229     function quadraticPricing(uint256 payment_, uint256 multiplier_)
230         internal
231         pure
232         returns (uint256)
233     {
234         return sqrrt(mul(multiplier_, payment_));
235     }
236 
237     function bondingCurve(uint256 supply_, uint256 multiplier_)
238         internal
239         pure
240         returns (uint256)
241     {
242         return mul(multiplier_, supply_);
243     }
244 }
245 
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies in extcodesize, which returns 0 for contracts in
266         // construction, since the code is only stored at the end of the
267         // constructor execution.
268 
269         uint256 size;
270         // solhint-disable-next-line no-inline-assembly
271         assembly {
272             size := extcodesize(account)
273         }
274         return size > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(
295             address(this).balance >= amount,
296             "Address: insufficient balance"
297         );
298 
299         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300         (bool success, ) = recipient.call{value: amount}("");
301         require(
302             success,
303             "Address: unable to send value, recipient may have reverted"
304         );
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level `call`. A
309      * plain`call` is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If `target` reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
317      *
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data)
326         internal
327         returns (bytes memory)
328     {
329         return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         return _functionCallWithValue(target, data, 0, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but also transferring `value` wei to `target`.
349      *
350      * Requirements:
351      *
352      * - the calling contract must have an ETH balance of at least `value`.
353      * - the called Solidity function must be `payable`.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value
361     ) internal returns (bytes memory) {
362         return
363             functionCallWithValue(
364                 target,
365                 data,
366                 value,
367                 "Address: low-level call with value failed"
368             );
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
373      * with `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     // function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
378     //     require(address(this).balance >= value, "Address: insufficient balance for call");
379     //     return _functionCallWithValue(target, data, value, errorMessage);
380     // }
381     function functionCallWithValue(
382         address target,
383         bytes memory data,
384         uint256 value,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(
388             address(this).balance >= value,
389             "Address: insufficient balance for call"
390         );
391         require(isContract(target), "Address: call to non-contract");
392 
393         // solhint-disable-next-line avoid-low-level-calls
394         (bool success, bytes memory returndata) = target.call{value: value}(
395             data
396         );
397         return _verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     function _functionCallWithValue(
401         address target,
402         bytes memory data,
403         uint256 weiValue,
404         string memory errorMessage
405     ) private returns (bytes memory) {
406         require(isContract(target), "Address: call to non-contract");
407 
408         // solhint-disable-next-line avoid-low-level-calls
409         (bool success, bytes memory returndata) = target.call{value: weiValue}(
410             data
411         );
412         if (success) {
413             return returndata;
414         } else {
415             // Look for revert reason and bubble it up if present
416             if (returndata.length > 0) {
417                 // The easiest way to bubble the revert reason is using memory via assembly
418 
419                 // solhint-disable-next-line no-inline-assembly
420                 assembly {
421                     let returndata_size := mload(returndata)
422                     revert(add(32, returndata), returndata_size)
423                 }
424             } else {
425                 revert(errorMessage);
426             }
427         }
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a static call.
433      *
434      * _Available since v3.3._
435      */
436     function functionStaticCall(address target, bytes memory data)
437         internal
438         view
439         returns (bytes memory)
440     {
441         return
442             functionStaticCall(
443                 target,
444                 data,
445                 "Address: low-level static call failed"
446             );
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal view returns (bytes memory) {
460         require(isContract(target), "Address: static call to non-contract");
461 
462         // solhint-disable-next-line avoid-low-level-calls
463         (bool success, bytes memory returndata) = target.staticcall(data);
464         return _verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.3._
472      */
473     function functionDelegateCall(address target, bytes memory data)
474         internal
475         returns (bytes memory)
476     {
477         return
478             functionDelegateCall(
479                 target,
480                 data,
481                 "Address: low-level delegate call failed"
482             );
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.3._
490      */
491     function functionDelegateCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal returns (bytes memory) {
496         require(isContract(target), "Address: delegate call to non-contract");
497 
498         // solhint-disable-next-line avoid-low-level-calls
499         (bool success, bytes memory returndata) = target.delegatecall(data);
500         return _verifyCallResult(success, returndata, errorMessage);
501     }
502 
503     function _verifyCallResult(
504         bool success,
505         bytes memory returndata,
506         string memory errorMessage
507     ) private pure returns (bytes memory) {
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514 
515                 // solhint-disable-next-line no-inline-assembly
516                 assembly {
517                     let returndata_size := mload(returndata)
518                     revert(add(32, returndata), returndata_size)
519                 }
520             } else {
521                 revert(errorMessage);
522             }
523         }
524     }
525 
526     function addressToString(address _address)
527         internal
528         pure
529         returns (string memory)
530     {
531         bytes32 _bytes = bytes32(uint256(_address));
532         bytes memory HEX = "0123456789abcdef";
533         bytes memory _addr = new bytes(42);
534 
535         _addr[0] = "0";
536         _addr[1] = "x";
537 
538         for (uint256 i = 0; i < 20; i++) {
539             _addr[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
540             _addr[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
541         }
542 
543         return string(_addr);
544     }
545 }
546 
547 interface IERC20 {
548     /**
549      * @dev Returns the amount of tokens in existence.
550      */
551     function totalSupply() external view returns (uint256);
552 
553     /**
554      * @dev Returns the amount of tokens owned by `account`.
555      */
556     function balanceOf(address account) external view returns (uint256);
557 
558     /**
559      * @dev Moves `amount` tokens from the caller's account to `recipient`.
560      *
561      * Returns a boolean value indicating whether the operation succeeded.
562      *
563      * Emits a {Transfer} event.
564      */
565     function transfer(address recipient, uint256 amount)
566         external
567         returns (bool);
568 
569     /**
570      * @dev Returns the remaining number of tokens that `spender` will be
571      * allowed to spend on behalf of `owner` through {transferFrom}. This is
572      * zero by default.
573      *
574      * This value changes when {approve} or {transferFrom} are called.
575      */
576     function allowance(address owner, address spender)
577         external
578         view
579         returns (uint256);
580 
581     /**
582      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
583      *
584      * Returns a boolean value indicating whether the operation succeeded.
585      *
586      * IMPORTANT: Beware that changing an allowance with this method brings the risk
587      * that someone may use both the old and the new allowance by unfortunate
588      * transaction ordering. One possible solution to mitigate this race
589      * condition is to first reduce the spender's allowance to 0 and set the
590      * desired value afterwards:
591      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
592      *
593      * Emits an {Approval} event.
594      */
595     function approve(address spender, uint256 amount) external returns (bool);
596 
597     /**
598      * @dev Moves `amount` tokens from `sender` to `recipient` using the
599      * allowance mechanism. `amount` is then deducted from the caller's
600      * allowance.
601      *
602      * Returns a boolean value indicating whether the operation succeeded.
603      *
604      * Emits a {Transfer} event.
605      */
606     function transferFrom(
607         address sender,
608         address recipient,
609         uint256 amount
610     ) external returns (bool);
611 
612     /**
613      * @dev Emitted when `value` tokens are moved from one account (`from`) to
614      * another (`to`).
615      *
616      * Note that `value` may be zero.
617      */
618     event Transfer(address indexed from, address indexed to, uint256 value);
619 
620     /**
621      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
622      * a call to {approve}. `value` is the new allowance.
623      */
624     event Approval(
625         address indexed owner,
626         address indexed spender,
627         uint256 value
628     );
629 }
630 
631 abstract contract ERC20 is IERC20 {
632     using SafeMath for uint256;
633 
634     // TODO comment actual hash value.
635     bytes32 private constant ERC20TOKEN_ERC1820_INTERFACE_ID =
636         keccak256("ERC20Token");
637 
638     // Present in ERC777
639     mapping(address => uint256) internal _balances;
640 
641     // Present in ERC777
642     mapping(address => mapping(address => uint256)) internal _allowances;
643 
644     // Present in ERC777
645     uint256 internal _totalSupply;
646 
647     // Present in ERC777
648     string internal _name;
649 
650     // Present in ERC777
651     string internal _symbol;
652 
653     // Present in ERC777
654     uint8 internal _decimals;
655 
656     /**
657      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
658      * a default value of 18.
659      *
660      * To select a different value for {decimals}, use {_setupDecimals}.
661      *
662      * All three of these values are immutable: they can only be set once during
663      * construction.
664      */
665     constructor(
666         string memory name_,
667         string memory symbol_,
668         uint8 decimals_
669     ) {
670         _name = name_;
671         _symbol = symbol_;
672         _decimals = decimals_;
673     }
674 
675     /**
676      * @dev Returns the name of the token.
677      */
678     // Present in ERC777
679     function name() public view returns (string memory) {
680         return _name;
681     }
682 
683     /**
684      * @dev Returns the symbol of the token, usually a shorter version of the
685      * name.
686      */
687     // Present in ERC777
688     function symbol() public view returns (string memory) {
689         return _symbol;
690     }
691 
692     /**
693      * @dev Returns the number of decimals used to get its user representation.
694      * For example, if `decimals` equals `2`, a balance of `505` tokens should
695      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
696      *
697      * Tokens usually opt for a value of 18, imitating the relationship between
698      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
699      * called.
700      *
701      * NOTE: This information is only used for _display_ purposes: it in
702      * no way affects any of the arithmetic of the contract, including
703      * {IERC20-balanceOf} and {IERC20-transfer}.
704      */
705     // Present in ERC777
706     function decimals() public view returns (uint8) {
707         return _decimals;
708     }
709 
710     /**
711      * @dev See {IERC20-totalSupply}.
712      */
713     // Present in ERC777
714     function totalSupply() public view override returns (uint256) {
715         return _totalSupply;
716     }
717 
718     /**
719      * @dev See {IERC20-balanceOf}.
720      */
721     // Present in ERC777
722     function balanceOf(address account)
723         public
724         view
725         virtual
726         override
727         returns (uint256)
728     {
729         return _balances[account];
730     }
731 
732     /**
733      * @dev See {IERC20-transfer}.
734      *
735      * Requirements:
736      *
737      * - `recipient` cannot be the zero address.
738      * - the caller must have a balance of at least `amount`.
739      */
740     // Overrideen in ERC777
741     // Confirm that this behavior changes
742     function transfer(address recipient, uint256 amount)
743         public
744         virtual
745         override
746         returns (bool)
747     {
748         _transfer(msg.sender, recipient, amount);
749         return true;
750     }
751 
752     /**
753      * @dev See {IERC20-allowance}.
754      */
755     // Present in ERC777
756     function allowance(address owner, address spender)
757         public
758         view
759         virtual
760         override
761         returns (uint256)
762     {
763         return _allowances[owner][spender];
764     }
765 
766     /**
767      * @dev See {IERC20-approve}.
768      *
769      * Requirements:
770      *
771      * - `spender` cannot be the zero address.
772      */
773     // Present in ERC777
774     function approve(address spender, uint256 amount)
775         public
776         virtual
777         override
778         returns (bool)
779     {
780         _approve(msg.sender, spender, amount);
781         return true;
782     }
783 
784     /**
785      * @dev See {IERC20-transferFrom}.
786      *
787      * Emits an {Approval} event indicating the updated allowance. This is not
788      * required by the EIP. See the note at the beginning of {ERC20}.
789      *
790      * Requirements:
791      *
792      * - `sender` and `recipient` cannot be the zero address.
793      * - `sender` must have a balance of at least `amount`.
794      * - the caller must have allowance for ``sender``'s tokens of at least
795      * `amount`.
796      */
797     // Present in ERC777
798     function transferFrom(
799         address sender,
800         address recipient,
801         uint256 amount
802     ) public virtual override returns (bool) {
803         _transfer(sender, recipient, amount);
804         _approve(
805             sender,
806             msg.sender,
807             _allowances[sender][msg.sender].sub(
808                 amount,
809                 "ERC20: transfer amount exceeds allowance"
810             )
811         );
812         return true;
813     }
814 
815     /**
816      * @dev Atomically increases the allowance granted to `spender` by the caller.
817      *
818      * This is an alternative to {approve} that can be used as a mitigation for
819      * problems described in {IERC20-approve}.
820      *
821      * Emits an {Approval} event indicating the updated allowance.
822      *
823      * Requirements:
824      *
825      * - `spender` cannot be the zero address.
826      */
827     function increaseAllowance(address spender, uint256 addedValue)
828         public
829         virtual
830         returns (bool)
831     {
832         _approve(
833             msg.sender,
834             spender,
835             _allowances[msg.sender][spender].add(addedValue)
836         );
837         return true;
838     }
839 
840     /**
841      * @dev Atomically decreases the allowance granted to `spender` by the caller.
842      *
843      * This is an alternative to {approve} that can be used as a mitigation for
844      * problems described in {IERC20-approve}.
845      *
846      * Emits an {Approval} event indicating the updated allowance.
847      *
848      * Requirements:
849      *
850      * - `spender` cannot be the zero address.
851      * - `spender` must have allowance for the caller of at least
852      * `subtractedValue`.
853      */
854     function decreaseAllowance(address spender, uint256 subtractedValue)
855         public
856         virtual
857         returns (bool)
858     {
859         _approve(
860             msg.sender,
861             spender,
862             _allowances[msg.sender][spender].sub(
863                 subtractedValue,
864                 "ERC20: decreased allowance below zero"
865             )
866         );
867         return true;
868     }
869 
870     /**
871      * @dev Moves tokens `amount` from `sender` to `recipient`.
872      *
873      * This is internal function is equivalent to {transfer}, and can be used to
874      * e.g. implement automatic token fees, slashing mechanisms, etc.
875      *
876      * Emits a {Transfer} event.
877      *
878      * Requirements:
879      *
880      * - `sender` cannot be the zero address.
881      * - `recipient` cannot be the zero address.
882      * - `sender` must have a balance of at least `amount`.
883      */
884     function _transfer(
885         address sender,
886         address recipient,
887         uint256 amount
888     ) internal virtual {
889         require(sender != address(0), "ERC20: transfer from the zero address");
890         require(recipient != address(0), "ERC20: transfer to the zero address");
891 
892         _beforeTokenTransfer(sender, recipient, amount);
893 
894         _balances[sender] = _balances[sender].sub(
895             amount,
896             "ERC20: transfer amount exceeds balance"
897         );
898         _balances[recipient] = _balances[recipient].add(amount);
899         emit Transfer(sender, recipient, amount);
900     }
901 
902     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
903      * the total supply.
904      *
905      * Emits a {Transfer} event with `from` set to the zero address.
906      *
907      * Requirements:
908      *
909      * - `to` cannot be the zero address.
910      */
911     // Present in ERC777
912     function _mint(address account_, uint256 ammount_) internal virtual {
913         require(account_ != address(0), "ERC20: mint to the zero address");
914         _beforeTokenTransfer(address(this), account_, ammount_);
915         _totalSupply = _totalSupply.add(ammount_);
916         _balances[account_] = _balances[account_].add(ammount_);
917         emit Transfer(address(this), account_, ammount_);
918     }
919 
920     /**
921      * @dev Destroys `amount` tokens from `account`, reducing the
922      * total supply.
923      *
924      * Emits a {Transfer} event with `to` set to the zero address.
925      *
926      * Requirements:
927      *
928      * - `account` cannot be the zero address.
929      * - `account` must have at least `amount` tokens.
930      */
931     // Present in ERC777
932     function _burn(address account, uint256 amount) internal virtual {
933         require(account != address(0), "ERC20: burn from the zero address");
934 
935         _beforeTokenTransfer(account, address(0), amount);
936 
937         _balances[account] = _balances[account].sub(
938             amount,
939             "ERC20: burn amount exceeds balance"
940         );
941         _totalSupply = _totalSupply.sub(amount);
942         emit Transfer(account, address(0), amount);
943     }
944 
945     /**
946      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
947      *
948      * This internal function is equivalent to `approve`, and can be used to
949      * e.g. set automatic allowances for certain subsystems, etc.
950      *
951      * Emits an {Approval} event.
952      *
953      * Requirements:
954      *
955      * - `owner` cannot be the zero address.
956      * - `spender` cannot be the zero address.
957      */
958     // Present in ERC777
959     function _approve(
960         address owner,
961         address spender,
962         uint256 amount
963     ) internal virtual {
964         require(owner != address(0), "ERC20: approve from the zero address");
965         require(spender != address(0), "ERC20: approve to the zero address");
966 
967         _allowances[owner][spender] = amount;
968         emit Approval(owner, spender, amount);
969     }
970 
971     /**
972      * @dev Sets {decimals} to a value other than the default one of 18.
973      *
974      * WARNING: This function should only be called from the constructor. Most
975      * applications that interact with token contracts will not expect
976      * {decimals} to ever change, and may work incorrectly if it does.
977      */
978     // Considering deprication to reduce size of bytecode as changing _decimals to internal acheived the same functionality.
979     // function _setupDecimals(uint8 decimals_) internal {
980     //     _decimals = decimals_;
981     // }
982 
983     /**
984      * @dev Hook that is called before any transfer of tokens. This includes
985      * minting and burning.
986      *
987      * Calling conditions:
988      *
989      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
990      * will be to transferred to `to`.
991      * - when `from` is zero, `amount` tokens will be minted for `to`.
992      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
993      * - `from` and `to` are never both zero.
994      *
995      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
996      */
997     // Present in ERC777
998     function _beforeTokenTransfer(
999         address from_,
1000         address to_,
1001         uint256 amount_
1002     ) internal virtual {}
1003 }
1004 
1005 library Counters {
1006     using SafeMath for uint256;
1007 
1008     struct Counter {
1009         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1010         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1011         // this feature: see https://github.com/ethereum/solidity/issues/4637
1012         uint256 _value; // default: 0
1013     }
1014 
1015     function current(Counter storage counter) internal view returns (uint256) {
1016         return counter._value;
1017     }
1018 
1019     function increment(Counter storage counter) internal {
1020         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1021         counter._value += 1;
1022     }
1023 
1024     function decrement(Counter storage counter) internal {
1025         counter._value = counter._value.sub(1);
1026     }
1027 }
1028 
1029 interface IERC2612Permit {
1030     /**
1031      * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
1032      * given `owner`'s signed approval.
1033      *
1034      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1035      * ordering also apply here.
1036      *
1037      * Emits an {Approval} event.
1038      *
1039      * Requirements:
1040      *
1041      * - `owner` cannot be the zero address.
1042      * - `spender` cannot be the zero address.
1043      * - `deadline` must be a timestamp in the future.
1044      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1045      * over the EIP712-formatted function arguments.
1046      * - the signature must use ``owner``'s current nonce (see {nonces}).
1047      *
1048      * For more information on the signature format, see the
1049      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1050      * section].
1051      */
1052     function permit(
1053         address owner,
1054         address spender,
1055         uint256 amount,
1056         uint256 deadline,
1057         uint8 v,
1058         bytes32 r,
1059         bytes32 s
1060     ) external;
1061 
1062     /**
1063      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
1064      * included whenever a signature is generated for {permit}.
1065      *
1066      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1067      * prevents a signature from being used multiple times.
1068      */
1069     function nonces(address owner) external view returns (uint256);
1070 }
1071 
1072 abstract contract ERC20Permit is ERC20, IERC2612Permit {
1073     using Counters for Counters.Counter;
1074 
1075     mapping(address => Counters.Counter) private _nonces;
1076 
1077     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1078     bytes32 public constant PERMIT_TYPEHASH =
1079         0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1080 
1081     bytes32 public DOMAIN_SEPARATOR;
1082 
1083     constructor() {
1084         uint256 chainID;
1085         assembly {
1086             chainID := chainid()
1087         }
1088 
1089         DOMAIN_SEPARATOR = keccak256(
1090             abi.encode(
1091                 keccak256(
1092                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1093                 ),
1094                 keccak256(bytes(name())),
1095                 keccak256(bytes("1")), // Version
1096                 chainID,
1097                 address(this)
1098             )
1099         );
1100     }
1101 
1102     /**
1103      * @dev See {IERC2612Permit-permit}.
1104      *
1105      */
1106     function permit(
1107         address owner,
1108         address spender,
1109         uint256 amount,
1110         uint256 deadline,
1111         uint8 v,
1112         bytes32 r,
1113         bytes32 s
1114     ) public virtual override {
1115         require(block.timestamp <= deadline, "Permit: expired deadline");
1116 
1117         bytes32 hashStruct = keccak256(
1118             abi.encode(
1119                 PERMIT_TYPEHASH,
1120                 owner,
1121                 spender,
1122                 amount,
1123                 _nonces[owner].current(),
1124                 deadline
1125             )
1126         );
1127 
1128         bytes32 _hash = keccak256(
1129             abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct)
1130         );
1131 
1132         address signer = ecrecover(_hash, v, r, s);
1133         require(
1134             signer != address(0) && signer == owner,
1135             "ZeroSwapPermit: Invalid signature"
1136         );
1137 
1138         _nonces[owner].increment();
1139         _approve(owner, spender, amount);
1140     }
1141 
1142     /**
1143      * @dev See {IERC2612Permit-nonces}.
1144      */
1145     function nonces(address owner) public view override returns (uint256) {
1146         return _nonces[owner].current();
1147     }
1148 }
1149 
1150 interface IOwnable {
1151     function manager() external view returns (address);
1152 
1153     function renounceManagement() external;
1154 
1155     function pushManagement(address newOwner_) external;
1156 
1157     function pullManagement() external;
1158 }
1159 
1160 contract Ownable is IOwnable {
1161     address internal _owner;
1162     address internal _newOwner;
1163 
1164     event OwnershipPushed(
1165         address indexed previousOwner,
1166         address indexed newOwner
1167     );
1168     event OwnershipPulled(
1169         address indexed previousOwner,
1170         address indexed newOwner
1171     );
1172 
1173     constructor() {
1174         _owner = msg.sender;
1175         emit OwnershipPushed(address(0), _owner);
1176     }
1177 
1178     function manager() public view override returns (address) {
1179         return _owner;
1180     }
1181 
1182     modifier onlyManager() {
1183         require(_owner == msg.sender, "Ownable: caller is not the owner");
1184         _;
1185     }
1186 
1187     function renounceManagement() public virtual override onlyManager {
1188         emit OwnershipPushed(_owner, address(0));
1189         _owner = address(0);
1190     }
1191 
1192     function pushManagement(address newOwner_)
1193         public
1194         virtual
1195         override
1196         onlyManager
1197     {
1198         require(
1199             newOwner_ != address(0),
1200             "Ownable: new owner is the zero address"
1201         );
1202         emit OwnershipPushed(_owner, newOwner_);
1203         _newOwner = newOwner_;
1204     }
1205 
1206     function pullManagement() public virtual override {
1207         require(msg.sender == _newOwner, "Ownable: must be new owner to pull");
1208         emit OwnershipPulled(_owner, _newOwner);
1209         _owner = _newOwner;
1210     }
1211 }
1212 
1213 contract sAsgardERC20Token is ERC20Permit, Ownable {
1214     using SafeMath for uint256;
1215 
1216     modifier onlyStakingContract() {
1217         require(msg.sender == stakingContract);
1218         _;
1219     }
1220 
1221     address public stakingContract;
1222     address public initializer;
1223 
1224     event LogSupply(
1225         uint256 indexed epoch,
1226         uint256 timestamp,
1227         uint256 totalSupply
1228     );
1229     event LogRebase(uint256 indexed epoch, uint256 rebase, uint256 index);
1230     event LogStakingContractUpdated(address stakingContract);
1231 
1232     struct Rebase {
1233         uint256 epoch;
1234         uint256 rebase; // 18 decimals
1235         uint256 totalStakedBefore;
1236         uint256 totalStakedAfter;
1237         uint256 amountRebased;
1238         uint256 index;
1239         uint256 blockNumberOccured;
1240     }
1241     Rebase[] public rebases;
1242 
1243     uint256 public INDEX;
1244 
1245     uint256 private constant MAX_UINT256 = ~uint256(0);
1246     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 5000000 * 10**9;
1247 
1248     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
1249     // Use the highest value that fits in a uint256 for max granularity.
1250     uint256 private constant TOTAL_GONS =
1251         MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
1252 
1253     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
1254     uint256 private constant MAX_SUPPLY = ~uint128(0); // (2^128) - 1
1255 
1256     uint256 private _gonsPerFragment;
1257     mapping(address => uint256) private _gonBalances;
1258 
1259     mapping(address => mapping(address => uint256)) private _allowedValue;
1260 
1261     constructor() ERC20("Staked Asgard", "sASG", 9) ERC20Permit() {
1262         initializer = msg.sender;
1263         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
1264         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
1265     }
1266 
1267     function initialize(address stakingContract_) external returns (bool) {
1268         require(msg.sender == initializer);
1269         require(stakingContract_ != address(0));
1270         stakingContract = stakingContract_;
1271         _gonBalances[stakingContract] = TOTAL_GONS;
1272 
1273         emit Transfer(address(0x0), stakingContract, _totalSupply);
1274         emit LogStakingContractUpdated(stakingContract_);
1275 
1276         initializer = address(0);
1277         return true;
1278     }
1279 
1280     function setIndex(uint256 _INDEX) external onlyManager returns (bool) {
1281         require(INDEX == 0);
1282         INDEX = gonsForBalance(_INDEX);
1283         return true;
1284     }
1285 
1286     /**
1287         @notice increases sASG supply to increase staking balances relative to profit_
1288         @param profit_ uint256
1289         @return uint256
1290      */
1291     function rebase(uint256 profit_, uint256 epoch_)
1292         public
1293         onlyStakingContract
1294         returns (uint256)
1295     {
1296         uint256 rebaseAmount;
1297         uint256 circulatingSupply_ = circulatingSupply();
1298 
1299         if (profit_ == 0) {
1300             emit LogSupply(epoch_, block.timestamp, _totalSupply);
1301             emit LogRebase(epoch_, 0, index());
1302             return _totalSupply;
1303         } else if (circulatingSupply_ > 0) {
1304             rebaseAmount = profit_.mul(_totalSupply).div(circulatingSupply_);
1305         } else {
1306             rebaseAmount = profit_;
1307         }
1308 
1309         _totalSupply = _totalSupply.add(rebaseAmount);
1310 
1311         if (_totalSupply > MAX_SUPPLY) {
1312             _totalSupply = MAX_SUPPLY;
1313         }
1314         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
1315         _storeRebase(circulatingSupply_, profit_, epoch_);
1316         return _totalSupply;
1317     }
1318 
1319     /**
1320         @notice emits event with data about rebase
1321         @param previousCirculating_ uint
1322         @param profit_ uint
1323         @param epoch_ uint
1324         @return bool
1325      */
1326     function _storeRebase(
1327         uint256 previousCirculating_,
1328         uint256 profit_,
1329         uint256 epoch_
1330     ) internal returns (bool) {
1331         uint256 rebasePercent = profit_.mul(1e18).div(previousCirculating_);
1332         rebases.push(
1333             Rebase({
1334                 epoch: epoch_,
1335                 rebase: rebasePercent, // 18 decimals
1336                 totalStakedBefore: previousCirculating_,
1337                 totalStakedAfter: circulatingSupply(),
1338                 amountRebased: profit_,
1339                 index: index(),
1340                 blockNumberOccured: block.number
1341             })
1342         );
1343 
1344         emit LogSupply(epoch_, block.timestamp, _totalSupply);
1345         emit LogRebase(epoch_, rebasePercent, index());
1346 
1347         return true;
1348     }
1349 
1350     function balanceOf(address who) public view override returns (uint256) {
1351         return _gonBalances[who].div(_gonsPerFragment);
1352     }
1353 
1354     function gonsForBalance(uint256 amount) public view returns (uint256) {
1355         return amount.mul(_gonsPerFragment);
1356     }
1357 
1358     function balanceForGons(uint256 gons) public view returns (uint256) {
1359         return gons.div(_gonsPerFragment);
1360     }
1361 
1362     // Staking contract holds excess sASG
1363     function circulatingSupply() public view returns (uint256) {
1364         return _totalSupply.sub(balanceOf(stakingContract));
1365     }
1366 
1367     function index() public view returns (uint256) {
1368         return balanceForGons(INDEX);
1369     }
1370 
1371     function transfer(address to, uint256 value)
1372         public
1373         override
1374         returns (bool)
1375     {
1376         uint256 gonValue = value.mul(_gonsPerFragment);
1377         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
1378         _gonBalances[to] = _gonBalances[to].add(gonValue);
1379         emit Transfer(msg.sender, to, value);
1380         return true;
1381     }
1382 
1383     function allowance(address owner_, address spender)
1384         public
1385         view
1386         override
1387         returns (uint256)
1388     {
1389         return _allowedValue[owner_][spender];
1390     }
1391 
1392     function transferFrom(
1393         address from,
1394         address to,
1395         uint256 value
1396     ) public override returns (bool) {
1397         _allowedValue[from][msg.sender] = _allowedValue[from][msg.sender].sub(
1398             value
1399         );
1400         emit Approval(from, msg.sender, _allowedValue[from][msg.sender]);
1401 
1402         uint256 gonValue = gonsForBalance(value);
1403         _gonBalances[from] = _gonBalances[from].sub(gonValue);
1404         _gonBalances[to] = _gonBalances[to].add(gonValue);
1405         emit Transfer(from, to, value);
1406 
1407         return true;
1408     }
1409 
1410     function approve(address spender, uint256 value)
1411         public
1412         override
1413         returns (bool)
1414     {
1415         _allowedValue[msg.sender][spender] = value;
1416         emit Approval(msg.sender, spender, value);
1417         return true;
1418     }
1419 
1420     // What gets called in a permit
1421     function _approve(
1422         address owner,
1423         address spender,
1424         uint256 value
1425     ) internal virtual override {
1426         _allowedValue[owner][spender] = value;
1427         emit Approval(owner, spender, value);
1428     }
1429 
1430     function increaseAllowance(address spender, uint256 addedValue)
1431         public
1432         override
1433         returns (bool)
1434     {
1435         _allowedValue[msg.sender][spender] = _allowedValue[msg.sender][spender]
1436             .add(addedValue);
1437         emit Approval(msg.sender, spender, _allowedValue[msg.sender][spender]);
1438         return true;
1439     }
1440 
1441     function decreaseAllowance(address spender, uint256 subtractedValue)
1442         public
1443         override
1444         returns (bool)
1445     {
1446         uint256 oldValue = _allowedValue[msg.sender][spender];
1447         if (subtractedValue >= oldValue) {
1448             _allowedValue[msg.sender][spender] = 0;
1449         } else {
1450             _allowedValue[msg.sender][spender] = oldValue.sub(subtractedValue);
1451         }
1452         emit Approval(msg.sender, spender, _allowedValue[msg.sender][spender]);
1453         return true;
1454     }
1455 }