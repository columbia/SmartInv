1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18   /**
19    * @dev Returns the addition of two unsigned integers, reverting on
20    * overflow.
21    *
22    * Counterpart to Solidity's `+` operator.
23    *
24    * Requirements:
25    *
26    * - Addition cannot overflow.
27    */
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     require(c >= a, "SafeMath: addition overflow");
31 
32     return c;
33   }
34 
35   /**
36    * @dev Returns the subtraction of two unsigned integers, reverting on
37    * overflow (when the result is negative).
38    *
39    * Counterpart to Solidity's `-` operator.
40    *
41    * Requirements:
42    *
43    * - Subtraction cannot overflow.
44    */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     return sub(a, b, "SafeMath: subtraction overflow");
47   }
48 
49   /**
50    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51    * overflow (when the result is negative).
52    *
53    * Counterpart to Solidity's `-` operator.
54    *
55    * Requirements:
56    *
57    * - Subtraction cannot overflow.
58    */
59   function sub(
60     uint256 a,
61     uint256 b,
62     string memory errorMessage
63   ) internal pure returns (uint256) {
64     require(b <= a, errorMessage);
65     uint256 c = a - b;
66 
67     return c;
68   }
69 
70   /**
71    * @dev Returns the multiplication of two unsigned integers, reverting on
72    * overflow.
73    *
74    * Counterpart to Solidity's `*` operator.
75    *
76    * Requirements:
77    *
78    * - Multiplication cannot overflow.
79    */
80   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82     // benefit is lost if 'b' is also tested.
83     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84     if (a == 0) {
85       return 0;
86     }
87 
88     uint256 c = a * b;
89     require(c / a == b, "SafeMath: multiplication overflow");
90 
91     return c;
92   }
93 
94   /**
95    * @dev Returns the integer division of two unsigned integers. Reverts on
96    * division by zero. The result is rounded towards zero.
97    *
98    * Counterpart to Solidity's `/` operator. Note: this function uses a
99    * `revert` opcode (which leaves remaining gas untouched) while Solidity
100    * uses an invalid opcode to revert (consuming all remaining gas).
101    *
102    * Requirements:
103    *
104    * - The divisor cannot be zero.
105    */
106   function div(uint256 a, uint256 b) internal pure returns (uint256) {
107     return div(a, b, "SafeMath: division by zero");
108   }
109 
110   /**
111    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
112    * division by zero. The result is rounded towards zero.
113    *
114    * Counterpart to Solidity's `/` operator. Note: this function uses a
115    * `revert` opcode (which leaves remaining gas untouched) while Solidity
116    * uses an invalid opcode to revert (consuming all remaining gas).
117    *
118    * Requirements:
119    *
120    * - The divisor cannot be zero.
121    */
122   function div(
123     uint256 a,
124     uint256 b,
125     string memory errorMessage
126   ) internal pure returns (uint256) {
127     require(b > 0, errorMessage);
128     uint256 c = a / b;
129     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131     return c;
132   }
133 
134   /**
135    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136    * Reverts when dividing by zero.
137    *
138    * Counterpart to Solidity's `%` operator. This function uses a `revert`
139    * opcode (which leaves remaining gas untouched) while Solidity uses an
140    * invalid opcode to revert (consuming all remaining gas).
141    *
142    * Requirements:
143    *
144    * - The divisor cannot be zero.
145    */
146   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147     return mod(a, b, "SafeMath: modulo by zero");
148   }
149 
150   /**
151    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152    * Reverts with custom message when dividing by zero.
153    *
154    * Counterpart to Solidity's `%` operator. This function uses a `revert`
155    * opcode (which leaves remaining gas untouched) while Solidity uses an
156    * invalid opcode to revert (consuming all remaining gas).
157    *
158    * Requirements:
159    *
160    * - The divisor cannot be zero.
161    */
162   function mod(
163     uint256 a,
164     uint256 b,
165     string memory errorMessage
166   ) internal pure returns (uint256) {
167     require(b != 0, errorMessage);
168     return a % b;
169   }
170 
171   // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
172   function sqrrt(uint256 a) internal pure returns (uint256 c) {
173     if (a > 3) {
174       c = a;
175       uint256 b = add(div(a, 2), 1);
176       while (b < c) {
177         c = b;
178         b = div(add(div(a, b), b), 2);
179       }
180     } else if (a != 0) {
181       c = 1;
182     }
183   }
184 
185   /*
186    * Expects percentage to be trailed by 00,
187    */
188   function percentageAmount(uint256 total_, uint8 percentage_)
189     internal
190     pure
191     returns (uint256 percentAmount_)
192   {
193     return div(mul(total_, percentage_), 1000);
194   }
195 
196   /*
197    * Expects percentage to be trailed by 00,
198    */
199   function substractPercentage(uint256 total_, uint8 percentageToSub_)
200     internal
201     pure
202     returns (uint256 result_)
203   {
204     return sub(total_, div(mul(total_, percentageToSub_), 1000));
205   }
206 
207   function percentageOfTotal(uint256 part_, uint256 total_)
208     internal
209     pure
210     returns (uint256 percent_)
211   {
212     return div(mul(part_, 100), total_);
213   }
214 
215   /**
216    * Taken from Hypersonic https://github.com/M2629/HyperSonic/blob/main/Math.sol
217    * @dev Returns the average of two numbers. The result is rounded towards
218    * zero.
219    */
220   function average(uint256 a, uint256 b) internal pure returns (uint256) {
221     // (a + b) / 2 can overflow, so we distribute
222     return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
223   }
224 
225   function quadraticPricing(uint256 payment_, uint256 multiplier_)
226     internal
227     pure
228     returns (uint256)
229   {
230     return sqrrt(mul(multiplier_, payment_));
231   }
232 
233   function bondingCurve(uint256 supply_, uint256 multiplier_)
234     internal
235     pure
236     returns (uint256)
237   {
238     return mul(multiplier_, supply_);
239   }
240 }
241 
242 library Address {
243   /**
244    * @dev Returns true if `account` is a contract.
245    *
246    * [IMPORTANT]
247    * ====
248    * It is unsafe to assume that an address for which this function returns
249    * false is an externally-owned account (EOA) and not a contract.
250    *
251    * Among others, `isContract` will return false for the following
252    * types of addresses:
253    *
254    *  - an externally-owned account
255    *  - a contract in construction
256    *  - an address where a contract will be created
257    *  - an address where a contract lived, but was destroyed
258    * ====
259    */
260   function isContract(address account) internal view returns (bool) {
261     // This method relies in extcodesize, which returns 0 for contracts in
262     // construction, since the code is only stored at the end of the
263     // constructor execution.
264 
265     uint256 size;
266     // solhint-disable-next-line no-inline-assembly
267     assembly {
268       size := extcodesize(account)
269     }
270     return size > 0;
271   }
272 
273   /**
274    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275    * `recipient`, forwarding all available gas and reverting on errors.
276    *
277    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278    * of certain opcodes, possibly making contracts go over the 2300 gas limit
279    * imposed by `transfer`, making them unable to receive funds via
280    * `transfer`. {sendValue} removes this limitation.
281    *
282    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283    *
284    * IMPORTANT: because control is transferred to `recipient`, care must be
285    * taken to not create reentrancy vulnerabilities. Consider using
286    * {ReentrancyGuard} or the
287    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288    */
289   function sendValue(address payable recipient, uint256 amount) internal {
290     require(address(this).balance >= amount, "Address: insufficient balance");
291 
292     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
293     (bool success, ) = recipient.call{value: amount}("");
294     require(
295       success,
296       "Address: unable to send value, recipient may have reverted"
297     );
298   }
299 
300   /**
301    * @dev Performs a Solidity function call using a low level `call`. A
302    * plain`call` is an unsafe replacement for a function call: use this
303    * function instead.
304    *
305    * If `target` reverts with a revert reason, it is bubbled up by this
306    * function (like regular Solidity function calls).
307    *
308    * Returns the raw returned data. To convert to the expected return value,
309    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310    *
311    * Requirements:
312    *
313    * - `target` must be a contract.
314    * - calling `target` with `data` must not revert.
315    *
316    * _Available since v3.1._
317    */
318   function functionCall(address target, bytes memory data)
319     internal
320     returns (bytes memory)
321   {
322     return functionCall(target, data, "Address: low-level call failed");
323   }
324 
325   /**
326    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327    * `errorMessage` as a fallback revert reason when `target` reverts.
328    *
329    * _Available since v3.1._
330    */
331   function functionCall(
332     address target,
333     bytes memory data,
334     string memory errorMessage
335   ) internal returns (bytes memory) {
336     return _functionCallWithValue(target, data, 0, errorMessage);
337   }
338 
339   /**
340    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341    * but also transferring `value` wei to `target`.
342    *
343    * Requirements:
344    *
345    * - the calling contract must have an ETH balance of at least `value`.
346    * - the called Solidity function must be `payable`.
347    *
348    * _Available since v3.1._
349    */
350   function functionCallWithValue(
351     address target,
352     bytes memory data,
353     uint256 value
354   ) internal returns (bytes memory) {
355     return
356       functionCallWithValue(
357         target,
358         data,
359         value,
360         "Address: low-level call with value failed"
361       );
362   }
363 
364   /**
365    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366    * with `errorMessage` as a fallback revert reason when `target` reverts.
367    *
368    * _Available since v3.1._
369    */
370   // function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
371   //     require(address(this).balance >= value, "Address: insufficient balance for call");
372   //     return _functionCallWithValue(target, data, value, errorMessage);
373   // }
374   function functionCallWithValue(
375     address target,
376     bytes memory data,
377     uint256 value,
378     string memory errorMessage
379   ) internal returns (bytes memory) {
380     require(
381       address(this).balance >= value,
382       "Address: insufficient balance for call"
383     );
384     require(isContract(target), "Address: call to non-contract");
385 
386     // solhint-disable-next-line avoid-low-level-calls
387     (bool success, bytes memory returndata) = target.call{value: value}(data);
388     return _verifyCallResult(success, returndata, errorMessage);
389   }
390 
391   function _functionCallWithValue(
392     address target,
393     bytes memory data,
394     uint256 weiValue,
395     string memory errorMessage
396   ) private returns (bytes memory) {
397     require(isContract(target), "Address: call to non-contract");
398 
399     // solhint-disable-next-line avoid-low-level-calls
400     (bool success, bytes memory returndata) = target.call{value: weiValue}(
401       data
402     );
403     if (success) {
404       return returndata;
405     } else {
406       // Look for revert reason and bubble it up if present
407       if (returndata.length > 0) {
408         // The easiest way to bubble the revert reason is using memory via assembly
409 
410         // solhint-disable-next-line no-inline-assembly
411         assembly {
412           let returndata_size := mload(returndata)
413           revert(add(32, returndata), returndata_size)
414         }
415       } else {
416         revert(errorMessage);
417       }
418     }
419   }
420 
421   /**
422    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423    * but performing a static call.
424    *
425    * _Available since v3.3._
426    */
427   function functionStaticCall(address target, bytes memory data)
428     internal
429     view
430     returns (bytes memory)
431   {
432     return
433       functionStaticCall(target, data, "Address: low-level static call failed");
434   }
435 
436   /**
437    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438    * but performing a static call.
439    *
440    * _Available since v3.3._
441    */
442   function functionStaticCall(
443     address target,
444     bytes memory data,
445     string memory errorMessage
446   ) internal view returns (bytes memory) {
447     require(isContract(target), "Address: static call to non-contract");
448 
449     // solhint-disable-next-line avoid-low-level-calls
450     (bool success, bytes memory returndata) = target.staticcall(data);
451     return _verifyCallResult(success, returndata, errorMessage);
452   }
453 
454   /**
455    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
456    * but performing a delegate call.
457    *
458    * _Available since v3.3._
459    */
460   function functionDelegateCall(address target, bytes memory data)
461     internal
462     returns (bytes memory)
463   {
464     return
465       functionDelegateCall(
466         target,
467         data,
468         "Address: low-level delegate call failed"
469       );
470   }
471 
472   /**
473    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474    * but performing a delegate call.
475    *
476    * _Available since v3.3._
477    */
478   function functionDelegateCall(
479     address target,
480     bytes memory data,
481     string memory errorMessage
482   ) internal returns (bytes memory) {
483     require(isContract(target), "Address: delegate call to non-contract");
484 
485     // solhint-disable-next-line avoid-low-level-calls
486     (bool success, bytes memory returndata) = target.delegatecall(data);
487     return _verifyCallResult(success, returndata, errorMessage);
488   }
489 
490   function _verifyCallResult(
491     bool success,
492     bytes memory returndata,
493     string memory errorMessage
494   ) private pure returns (bytes memory) {
495     if (success) {
496       return returndata;
497     } else {
498       // Look for revert reason and bubble it up if present
499       if (returndata.length > 0) {
500         // The easiest way to bubble the revert reason is using memory via assembly
501 
502         // solhint-disable-next-line no-inline-assembly
503         assembly {
504           let returndata_size := mload(returndata)
505           revert(add(32, returndata), returndata_size)
506         }
507       } else {
508         revert(errorMessage);
509       }
510     }
511   }
512 
513   function addressToString(address _address)
514     internal
515     pure
516     returns (string memory)
517   {
518     bytes32 _bytes = bytes32(uint256(_address));
519     bytes memory HEX = "0123456789abcdef";
520     bytes memory _addr = new bytes(42);
521 
522     _addr[0] = "0";
523     _addr[1] = "x";
524 
525     for (uint256 i = 0; i < 20; i++) {
526       _addr[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
527       _addr[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
528     }
529 
530     return string(_addr);
531   }
532 }
533 
534 interface IERC20 {
535   /**
536    * @dev Returns the amount of tokens in existence.
537    */
538   function totalSupply() external view returns (uint256);
539 
540   /**
541    * @dev Returns the amount of tokens owned by `account`.
542    */
543   function balanceOf(address account) external view returns (uint256);
544 
545   /**
546    * @dev Moves `amount` tokens from the caller's account to `recipient`.
547    *
548    * Returns a boolean value indicating whether the operation succeeded.
549    *
550    * Emits a {Transfer} event.
551    */
552   function transfer(address recipient, uint256 amount) external returns (bool);
553 
554   /**
555    * @dev Returns the remaining number of tokens that `spender` will be
556    * allowed to spend on behalf of `owner` through {transferFrom}. This is
557    * zero by default.
558    *
559    * This value changes when {approve} or {transferFrom} are called.
560    */
561   function allowance(address owner, address spender)
562     external
563     view
564     returns (uint256);
565 
566   /**
567    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
568    *
569    * Returns a boolean value indicating whether the operation succeeded.
570    *
571    * IMPORTANT: Beware that changing an allowance with this method brings the risk
572    * that someone may use both the old and the new allowance by unfortunate
573    * transaction ordering. One possible solution to mitigate this race
574    * condition is to first reduce the spender's allowance to 0 and set the
575    * desired value afterwards:
576    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
577    *
578    * Emits an {Approval} event.
579    */
580   function approve(address spender, uint256 amount) external returns (bool);
581 
582   /**
583    * @dev Moves `amount` tokens from `sender` to `recipient` using the
584    * allowance mechanism. `amount` is then deducted from the caller's
585    * allowance.
586    *
587    * Returns a boolean value indicating whether the operation succeeded.
588    *
589    * Emits a {Transfer} event.
590    */
591   function transferFrom(
592     address sender,
593     address recipient,
594     uint256 amount
595   ) external returns (bool);
596 
597   /**
598    * @dev Emitted when `value` tokens are moved from one account (`from`) to
599    * another (`to`).
600    *
601    * Note that `value` may be zero.
602    */
603   event Transfer(address indexed from, address indexed to, uint256 value);
604 
605   /**
606    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
607    * a call to {approve}. `value` is the new allowance.
608    */
609   event Approval(address indexed owner, address indexed spender, uint256 value);
610 }
611 
612 abstract contract ERC20 is IERC20 {
613   using SafeMath for uint256;
614 
615   // TODO comment actual hash value.
616   bytes32 private constant ERC20TOKEN_ERC1820_INTERFACE_ID =
617     keccak256("ERC20Token");
618 
619   // Present in ERC777
620   mapping(address => uint256) internal _balances;
621 
622   // Present in ERC777
623   mapping(address => mapping(address => uint256)) internal _allowances;
624 
625   // Present in ERC777
626   uint256 internal _totalSupply;
627 
628   // Present in ERC777
629   string internal _name;
630 
631   // Present in ERC777
632   string internal _symbol;
633 
634   // Present in ERC777
635   uint8 internal _decimals;
636 
637   /**
638    * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
639    * a default value of 18.
640    *
641    * To select a different value for {decimals}, use {_setupDecimals}.
642    *
643    * All three of these values are immutable: they can only be set once during
644    * construction.
645    */
646   constructor(
647     string memory name_,
648     string memory symbol_,
649     uint8 decimals_
650   ) {
651     _name = name_;
652     _symbol = symbol_;
653     _decimals = decimals_;
654   }
655 
656   /**
657    * @dev Returns the name of the token.
658    */
659   // Present in ERC777
660   function name() public view returns (string memory) {
661     return _name;
662   }
663 
664   /**
665    * @dev Returns the symbol of the token, usually a shorter version of the
666    * name.
667    */
668   // Present in ERC777
669   function symbol() public view returns (string memory) {
670     return _symbol;
671   }
672 
673   /**
674    * @dev Returns the number of decimals used to get its user representation.
675    * For example, if `decimals` equals `2`, a balance of `505` tokens should
676    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
677    *
678    * Tokens usually opt for a value of 18, imitating the relationship between
679    * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
680    * called.
681    *
682    * NOTE: This information is only used for _display_ purposes: it in
683    * no way affects any of the arithmetic of the contract, including
684    * {IERC20-balanceOf} and {IERC20-transfer}.
685    */
686   // Present in ERC777
687   function decimals() public view returns (uint8) {
688     return _decimals;
689   }
690 
691   /**
692    * @dev See {IERC20-totalSupply}.
693    */
694   // Present in ERC777
695   function totalSupply() public view override returns (uint256) {
696     return _totalSupply;
697   }
698 
699   /**
700    * @dev See {IERC20-balanceOf}.
701    */
702   // Present in ERC777
703   function balanceOf(address account)
704     public
705     view
706     virtual
707     override
708     returns (uint256)
709   {
710     return _balances[account];
711   }
712 
713   /**
714    * @dev See {IERC20-transfer}.
715    *
716    * Requirements:
717    *
718    * - `recipient` cannot be the zero address.
719    * - the caller must have a balance of at least `amount`.
720    */
721   // Overrideen in ERC777
722   // Confirm that this behavior changes
723   function transfer(address recipient, uint256 amount)
724     public
725     virtual
726     override
727     returns (bool)
728   {
729     _transfer(msg.sender, recipient, amount);
730     return true;
731   }
732 
733   /**
734    * @dev See {IERC20-allowance}.
735    */
736   // Present in ERC777
737   function allowance(address owner, address spender)
738     public
739     view
740     virtual
741     override
742     returns (uint256)
743   {
744     return _allowances[owner][spender];
745   }
746 
747   /**
748    * @dev See {IERC20-approve}.
749    *
750    * Requirements:
751    *
752    * - `spender` cannot be the zero address.
753    */
754   // Present in ERC777
755   function approve(address spender, uint256 amount)
756     public
757     virtual
758     override
759     returns (bool)
760   {
761     _approve(msg.sender, spender, amount);
762     return true;
763   }
764 
765   /**
766    * @dev See {IERC20-transferFrom}.
767    *
768    * Emits an {Approval} event indicating the updated allowance. This is not
769    * required by the EIP. See the note at the beginning of {ERC20}.
770    *
771    * Requirements:
772    *
773    * - `sender` and `recipient` cannot be the zero address.
774    * - `sender` must have a balance of at least `amount`.
775    * - the caller must have allowance for ``sender``'s tokens of at least
776    * `amount`.
777    */
778   // Present in ERC777
779   function transferFrom(
780     address sender,
781     address recipient,
782     uint256 amount
783   ) public virtual override returns (bool) {
784     _transfer(sender, recipient, amount);
785     _approve(
786       sender,
787       msg.sender,
788       _allowances[sender][msg.sender].sub(
789         amount,
790         "ERC20: transfer amount exceeds allowance"
791       )
792     );
793     return true;
794   }
795 
796   /**
797    * @dev Atomically increases the allowance granted to `spender` by the caller.
798    *
799    * This is an alternative to {approve} that can be used as a mitigation for
800    * problems described in {IERC20-approve}.
801    *
802    * Emits an {Approval} event indicating the updated allowance.
803    *
804    * Requirements:
805    *
806    * - `spender` cannot be the zero address.
807    */
808   function increaseAllowance(address spender, uint256 addedValue)
809     public
810     virtual
811     returns (bool)
812   {
813     _approve(
814       msg.sender,
815       spender,
816       _allowances[msg.sender][spender].add(addedValue)
817     );
818     return true;
819   }
820 
821   /**
822    * @dev Atomically decreases the allowance granted to `spender` by the caller.
823    *
824    * This is an alternative to {approve} that can be used as a mitigation for
825    * problems described in {IERC20-approve}.
826    *
827    * Emits an {Approval} event indicating the updated allowance.
828    *
829    * Requirements:
830    *
831    * - `spender` cannot be the zero address.
832    * - `spender` must have allowance for the caller of at least
833    * `subtractedValue`.
834    */
835   function decreaseAllowance(address spender, uint256 subtractedValue)
836     public
837     virtual
838     returns (bool)
839   {
840     _approve(
841       msg.sender,
842       spender,
843       _allowances[msg.sender][spender].sub(
844         subtractedValue,
845         "ERC20: decreased allowance below zero"
846       )
847     );
848     return true;
849   }
850 
851   /**
852    * @dev Moves tokens `amount` from `sender` to `recipient`.
853    *
854    * This is internal function is equivalent to {transfer}, and can be used to
855    * e.g. implement automatic token fees, slashing mechanisms, etc.
856    *
857    * Emits a {Transfer} event.
858    *
859    * Requirements:
860    *
861    * - `sender` cannot be the zero address.
862    * - `recipient` cannot be the zero address.
863    * - `sender` must have a balance of at least `amount`.
864    */
865   function _transfer(
866     address sender,
867     address recipient,
868     uint256 amount
869   ) internal virtual {
870     require(sender != address(0), "ERC20: transfer from the zero address");
871     require(recipient != address(0), "ERC20: transfer to the zero address");
872 
873     _beforeTokenTransfer(sender, recipient, amount);
874 
875     _balances[sender] = _balances[sender].sub(
876       amount,
877       "ERC20: transfer amount exceeds balance"
878     );
879     _balances[recipient] = _balances[recipient].add(amount);
880     emit Transfer(sender, recipient, amount);
881   }
882 
883   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
884    * the total supply.
885    *
886    * Emits a {Transfer} event with `from` set to the zero address.
887    *
888    * Requirements:
889    *
890    * - `to` cannot be the zero address.
891    */
892   // Present in ERC777
893   function _mint(address account_, uint256 ammount_) internal virtual {
894     require(account_ != address(0), "ERC20: mint to the zero address");
895     _beforeTokenTransfer(address(this), account_, ammount_);
896     _totalSupply = _totalSupply.add(ammount_);
897     _balances[account_] = _balances[account_].add(ammount_);
898     emit Transfer(address(this), account_, ammount_);
899   }
900 
901   /**
902    * @dev Destroys `amount` tokens from `account`, reducing the
903    * total supply.
904    *
905    * Emits a {Transfer} event with `to` set to the zero address.
906    *
907    * Requirements:
908    *
909    * - `account` cannot be the zero address.
910    * - `account` must have at least `amount` tokens.
911    */
912   // Present in ERC777
913   function _burn(address account, uint256 amount) internal virtual {
914     require(account != address(0), "ERC20: burn from the zero address");
915 
916     _beforeTokenTransfer(account, address(0), amount);
917 
918     _balances[account] = _balances[account].sub(
919       amount,
920       "ERC20: burn amount exceeds balance"
921     );
922     _totalSupply = _totalSupply.sub(amount);
923     emit Transfer(account, address(0), amount);
924   }
925 
926   /**
927    * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
928    *
929    * This internal function is equivalent to `approve`, and can be used to
930    * e.g. set automatic allowances for certain subsystems, etc.
931    *
932    * Emits an {Approval} event.
933    *
934    * Requirements:
935    *
936    * - `owner` cannot be the zero address.
937    * - `spender` cannot be the zero address.
938    */
939   // Present in ERC777
940   function _approve(
941     address owner,
942     address spender,
943     uint256 amount
944   ) internal virtual {
945     require(owner != address(0), "ERC20: approve from the zero address");
946     require(spender != address(0), "ERC20: approve to the zero address");
947 
948     _allowances[owner][spender] = amount;
949     emit Approval(owner, spender, amount);
950   }
951 
952   /**
953    * @dev Sets {decimals} to a value other than the default one of 18.
954    *
955    * WARNING: This function should only be called from the constructor. Most
956    * applications that interact with token contracts will not expect
957    * {decimals} to ever change, and may work incorrectly if it does.
958    */
959   // Considering deprication to reduce size of bytecode as changing _decimals to internal acheived the same functionality.
960   // function _setupDecimals(uint8 decimals_) internal {
961   //     _decimals = decimals_;
962   // }
963 
964   /**
965    * @dev Hook that is called before any transfer of tokens. This includes
966    * minting and burning.
967    *
968    * Calling conditions:
969    *
970    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
971    * will be to transferred to `to`.
972    * - when `from` is zero, `amount` tokens will be minted for `to`.
973    * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
974    * - `from` and `to` are never both zero.
975    *
976    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
977    */
978   // Present in ERC777
979   function _beforeTokenTransfer(
980     address from_,
981     address to_,
982     uint256 amount_
983   ) internal virtual {}
984 }
985 
986 library Counters {
987   using SafeMath for uint256;
988 
989   struct Counter {
990     // This variable should never be directly accessed by users of the library: interactions must be restricted to
991     // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
992     // this feature: see https://github.com/ethereum/solidity/issues/4637
993     uint256 _value; // default: 0
994   }
995 
996   function current(Counter storage counter) internal view returns (uint256) {
997     return counter._value;
998   }
999 
1000   function increment(Counter storage counter) internal {
1001     // The {SafeMath} overflow check can be skipped here, see the comment at the top
1002     counter._value += 1;
1003   }
1004 
1005   function decrement(Counter storage counter) internal {
1006     counter._value = counter._value.sub(1);
1007   }
1008 }
1009 
1010 interface IERC2612Permit {
1011   /**
1012    * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
1013    * given `owner`'s signed approval.
1014    *
1015    * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1016    * ordering also apply here.
1017    *
1018    * Emits an {Approval} event.
1019    *
1020    * Requirements:
1021    *
1022    * - `owner` cannot be the zero address.
1023    * - `spender` cannot be the zero address.
1024    * - `deadline` must be a timestamp in the future.
1025    * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1026    * over the EIP712-formatted function arguments.
1027    * - the signature must use ``owner``'s current nonce (see {nonces}).
1028    *
1029    * For more information on the signature format, see the
1030    * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1031    * section].
1032    */
1033   function permit(
1034     address owner,
1035     address spender,
1036     uint256 amount,
1037     uint256 deadline,
1038     uint8 v,
1039     bytes32 r,
1040     bytes32 s
1041   ) external;
1042 
1043   /**
1044    * @dev Returns the current ERC2612 nonce for `owner`. This value must be
1045    * included whenever a signature is generated for {permit}.
1046    *
1047    * Every successful call to {permit} increases ``owner``'s nonce by one. This
1048    * prevents a signature from being used multiple times.
1049    */
1050   function nonces(address owner) external view returns (uint256);
1051 }
1052 
1053 abstract contract ERC20Permit is ERC20, IERC2612Permit {
1054   using Counters for Counters.Counter;
1055 
1056   mapping(address => Counters.Counter) private _nonces;
1057 
1058   // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1059   bytes32 public constant PERMIT_TYPEHASH =
1060     0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1061 
1062   bytes32 public DOMAIN_SEPARATOR;
1063 
1064   constructor() {
1065     uint256 chainID;
1066     assembly {
1067       chainID := chainid()
1068     }
1069 
1070     DOMAIN_SEPARATOR = keccak256(
1071       abi.encode(
1072         keccak256(
1073           "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1074         ),
1075         keccak256(bytes(name())),
1076         keccak256(bytes("1")), // Version
1077         chainID,
1078         address(this)
1079       )
1080     );
1081   }
1082 
1083   /**
1084    * @dev See {IERC2612Permit-permit}.
1085    *
1086    */
1087   function permit(
1088     address owner,
1089     address spender,
1090     uint256 amount,
1091     uint256 deadline,
1092     uint8 v,
1093     bytes32 r,
1094     bytes32 s
1095   ) public virtual override {
1096     require(block.timestamp <= deadline, "Permit: expired deadline");
1097 
1098     bytes32 hashStruct = keccak256(
1099       abi.encode(
1100         PERMIT_TYPEHASH,
1101         owner,
1102         spender,
1103         amount,
1104         _nonces[owner].current(),
1105         deadline
1106       )
1107     );
1108 
1109     bytes32 _hash = keccak256(
1110       abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct)
1111     );
1112 
1113     address signer = ecrecover(_hash, v, r, s);
1114     require(
1115       signer != address(0) && signer == owner,
1116       "ZeroSwapPermit: Invalid signature"
1117     );
1118 
1119     _nonces[owner].increment();
1120     _approve(owner, spender, amount);
1121   }
1122 
1123   /**
1124    * @dev See {IERC2612Permit-nonces}.
1125    */
1126   function nonces(address owner) public view override returns (uint256) {
1127     return _nonces[owner].current();
1128   }
1129 }
1130 
1131 interface IOwnable {
1132   function manager() external view returns (address);
1133 
1134   function renounceManagement() external;
1135 
1136   function pushManagement(address newOwner_) external;
1137 
1138   function pullManagement() external;
1139 }
1140 
1141 contract Ownable is IOwnable {
1142   address internal _owner;
1143   address internal _newOwner;
1144 
1145   event OwnershipPushed(
1146     address indexed previousOwner,
1147     address indexed newOwner
1148   );
1149   event OwnershipPulled(
1150     address indexed previousOwner,
1151     address indexed newOwner
1152   );
1153 
1154   constructor() {
1155     _owner = msg.sender;
1156     emit OwnershipPushed(address(0), _owner);
1157   }
1158 
1159   function manager() public view override returns (address) {
1160     return _owner;
1161   }
1162 
1163   modifier onlyManager() {
1164     require(_owner == msg.sender, "Ownable: caller is not the owner");
1165     _;
1166   }
1167 
1168   function renounceManagement() public virtual override onlyManager {
1169     emit OwnershipPushed(_owner, address(0));
1170     _owner = address(0);
1171   }
1172 
1173   function pushManagement(address newOwner_)
1174     public
1175     virtual
1176     override
1177     onlyManager
1178   {
1179     require(newOwner_ != address(0), "Ownable: new owner is the zero address");
1180     emit OwnershipPushed(_owner, newOwner_);
1181     _newOwner = newOwner_;
1182   }
1183 
1184   function pullManagement() public virtual override {
1185     require(msg.sender == _newOwner, "Ownable: must be new owner to pull");
1186     emit OwnershipPulled(_owner, _newOwner);
1187     _owner = _newOwner;
1188   }
1189 }
1190 
1191 contract StakedLobiERC20 is ERC20Permit, Ownable {
1192   using SafeMath for uint256;
1193 
1194   modifier onlyStakingContract() {
1195     require(msg.sender == stakingContract);
1196     _;
1197   }
1198 
1199   address public stakingContract;
1200   address public initializer;
1201 
1202   event LogSupply(
1203     uint256 indexed epoch,
1204     uint256 timestamp,
1205     uint256 totalSupply
1206   );
1207   event LogRebase(uint256 indexed epoch, uint256 rebase, uint256 index);
1208   event LogStakingContractUpdated(address stakingContract);
1209 
1210   struct Rebase {
1211     uint256 epoch;
1212     uint256 rebase; // 18 decimals
1213     uint256 totalStakedBefore;
1214     uint256 totalStakedAfter;
1215     uint256 amountRebased;
1216     uint256 index;
1217     uint256 blockNumberOccured;
1218   }
1219   Rebase[] public rebases;
1220 
1221   uint256 public INDEX;
1222 
1223   uint256 private constant MAX_UINT256 = ~uint256(0);
1224   uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 5000000 * 10**9;
1225 
1226   // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
1227   // Use the highest value that fits in a uint256 for max granularity.
1228   uint256 private constant TOTAL_GONS =
1229     MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
1230 
1231   // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
1232   uint256 private constant MAX_SUPPLY = ~uint128(0); // (2^128) - 1
1233 
1234   uint256 private _gonsPerFragment;
1235   mapping(address => uint256) private _gonBalances;
1236 
1237   mapping(address => mapping(address => uint256)) private _allowedValue;
1238 
1239   constructor() ERC20("Staked Lobi", "sLOBI", 9) ERC20Permit() {
1240     initializer = msg.sender;
1241     _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
1242     _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
1243   }
1244 
1245   function initialize(address stakingContract_) external returns (bool) {
1246     require(msg.sender == initializer);
1247     require(stakingContract_ != address(0));
1248     stakingContract = stakingContract_;
1249     _gonBalances[stakingContract] = TOTAL_GONS;
1250 
1251     emit Transfer(address(0x0), stakingContract, _totalSupply);
1252     emit LogStakingContractUpdated(stakingContract_);
1253 
1254     initializer = address(0);
1255     return true;
1256   }
1257 
1258   function setIndex(uint256 _INDEX) external onlyManager returns (bool) {
1259     require(INDEX == 0);
1260     INDEX = gonsForBalance(_INDEX);
1261     return true;
1262   }
1263 
1264   /**
1265         @notice increases sLOBI supply to increase staking balances relative to profit_
1266         @param profit_ uint256
1267         @return uint256
1268      */
1269   function rebase(uint256 profit_, uint256 epoch_)
1270     public
1271     onlyStakingContract
1272     returns (uint256)
1273   {
1274     uint256 rebaseAmount;
1275     uint256 circulatingSupply_ = circulatingSupply();
1276 
1277     if (profit_ == 0) {
1278       emit LogSupply(epoch_, block.timestamp, _totalSupply);
1279       emit LogRebase(epoch_, 0, index());
1280       return _totalSupply;
1281     } else if (circulatingSupply_ > 0) {
1282       rebaseAmount = profit_.mul(_totalSupply).div(circulatingSupply_);
1283     } else {
1284       rebaseAmount = profit_;
1285     }
1286 
1287     _totalSupply = _totalSupply.add(rebaseAmount);
1288 
1289     if (_totalSupply > MAX_SUPPLY) {
1290       _totalSupply = MAX_SUPPLY;
1291     }
1292 
1293     _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
1294 
1295     _storeRebase(circulatingSupply_, profit_, epoch_);
1296 
1297     return _totalSupply;
1298   }
1299 
1300   /**
1301         @notice emits event with data about rebase
1302         @param previousCirculating_ uint
1303         @param profit_ uint
1304         @param epoch_ uint
1305         @return bool
1306      */
1307   function _storeRebase(
1308     uint256 previousCirculating_,
1309     uint256 profit_,
1310     uint256 epoch_
1311   ) internal returns (bool) {
1312     uint256 rebasePercent = profit_.mul(1e18).div(previousCirculating_);
1313 
1314     rebases.push(
1315       Rebase({
1316         epoch: epoch_,
1317         rebase: rebasePercent, // 18 decimals
1318         totalStakedBefore: previousCirculating_,
1319         totalStakedAfter: circulatingSupply(),
1320         amountRebased: profit_,
1321         index: index(),
1322         blockNumberOccured: block.number
1323       })
1324     );
1325 
1326     emit LogSupply(epoch_, block.timestamp, _totalSupply);
1327     emit LogRebase(epoch_, rebasePercent, index());
1328 
1329     return true;
1330   }
1331 
1332   function balanceOf(address who) public view override returns (uint256) {
1333     return _gonBalances[who].div(_gonsPerFragment);
1334   }
1335 
1336   function gonsForBalance(uint256 amount) public view returns (uint256) {
1337     return amount.mul(_gonsPerFragment);
1338   }
1339 
1340   function balanceForGons(uint256 gons) public view returns (uint256) {
1341     return gons.div(_gonsPerFragment);
1342   }
1343 
1344   // Staking contract holds excess sLOBI
1345   function circulatingSupply() public view returns (uint256) {
1346     return _totalSupply.sub(balanceOf(stakingContract));
1347   }
1348 
1349   function index() public view returns (uint256) {
1350     return balanceForGons(INDEX);
1351   }
1352 
1353   function transfer(address to, uint256 value) public override returns (bool) {
1354     uint256 gonValue = value.mul(_gonsPerFragment);
1355     _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
1356     _gonBalances[to] = _gonBalances[to].add(gonValue);
1357     emit Transfer(msg.sender, to, value);
1358     return true;
1359   }
1360 
1361   function allowance(address owner_, address spender)
1362     public
1363     view
1364     override
1365     returns (uint256)
1366   {
1367     return _allowedValue[owner_][spender];
1368   }
1369 
1370   function transferFrom(
1371     address from,
1372     address to,
1373     uint256 value
1374   ) public override returns (bool) {
1375     _allowedValue[from][msg.sender] = _allowedValue[from][msg.sender].sub(
1376       value
1377     );
1378     emit Approval(from, msg.sender, _allowedValue[from][msg.sender]);
1379 
1380     uint256 gonValue = gonsForBalance(value);
1381     _gonBalances[from] = _gonBalances[from].sub(gonValue);
1382     _gonBalances[to] = _gonBalances[to].add(gonValue);
1383     emit Transfer(from, to, value);
1384 
1385     return true;
1386   }
1387 
1388   function approve(address spender, uint256 value)
1389     public
1390     override
1391     returns (bool)
1392   {
1393     _allowedValue[msg.sender][spender] = value;
1394     emit Approval(msg.sender, spender, value);
1395     return true;
1396   }
1397 
1398   // What gets called in a permit
1399   function _approve(
1400     address owner,
1401     address spender,
1402     uint256 value
1403   ) internal virtual override {
1404     _allowedValue[owner][spender] = value;
1405     emit Approval(owner, spender, value);
1406   }
1407 
1408   function increaseAllowance(address spender, uint256 addedValue)
1409     public
1410     override
1411     returns (bool)
1412   {
1413     _allowedValue[msg.sender][spender] = _allowedValue[msg.sender][spender].add(
1414       addedValue
1415     );
1416     emit Approval(msg.sender, spender, _allowedValue[msg.sender][spender]);
1417     return true;
1418   }
1419 
1420   function decreaseAllowance(address spender, uint256 subtractedValue)
1421     public
1422     override
1423     returns (bool)
1424   {
1425     uint256 oldValue = _allowedValue[msg.sender][spender];
1426     if (subtractedValue >= oldValue) {
1427       _allowedValue[msg.sender][spender] = 0;
1428     } else {
1429       _allowedValue[msg.sender][spender] = oldValue.sub(subtractedValue);
1430     }
1431     emit Approval(msg.sender, spender, _allowedValue[msg.sender][spender]);
1432     return true;
1433   }
1434 }