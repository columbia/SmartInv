1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 
160     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
161     function sqrrt(uint256 a) internal pure returns (uint c) {
162         if (a > 3) {
163             c = a;
164             uint b = add( div( a, 2), 1 );
165             while (b < c) {
166                 c = b;
167                 b = div( add( div( a, b ), b), 2 );
168             }
169         } else if (a != 0) {
170             c = 1;
171         }
172     }
173 
174     /*
175      * Expects percentage to be trailed by 00,
176     */
177     function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {
178         return div( mul( total_, percentage_ ), 1000 );
179     }
180 
181     /*
182      * Expects percentage to be trailed by 00,
183     */
184     function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {
185         return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );
186     }
187 
188     function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {
189         return div( mul(part_, 100) , total_ );
190     }
191 
192     /**
193      * Taken from Hypersonic https://github.com/M2629/HyperSonic/blob/main/Math.sol
194      * @dev Returns the average of two numbers. The result is rounded towards
195      * zero.
196      */
197     function average(uint256 a, uint256 b) internal pure returns (uint256) {
198         // (a + b) / 2 can overflow, so we distribute
199         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
200     }
201 
202     function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {
203         return sqrrt( mul( multiplier_, payment_ ) );
204     }
205 
206   function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {
207       return mul( multiplier_, supply_ );
208   }
209 }
210 
211 library Address {
212     /**
213      * @dev Returns true if `account` is a contract.
214      *
215      * [IMPORTANT]
216      * ====
217      * It is unsafe to assume that an address for which this function returns
218      * false is an externally-owned account (EOA) and not a contract.
219      *
220      * Among others, `isContract` will return false for the following
221      * types of addresses:
222      *
223      *  - an externally-owned account
224      *  - a contract in construction
225      *  - an address where a contract will be created
226      *  - an address where a contract lived, but was destroyed
227      * ====
228      */
229     function isContract(address account) internal view returns (bool) {
230         // This method relies in extcodesize, which returns 0 for contracts in
231         // construction, since the code is only stored at the end of the
232         // constructor execution.
233 
234         uint256 size;
235         // solhint-disable-next-line no-inline-assembly
236         assembly { size := extcodesize(account) }
237         return size > 0;
238     }
239 
240     /**
241      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
242      * `recipient`, forwarding all available gas and reverting on errors.
243      *
244      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
245      * of certain opcodes, possibly making contracts go over the 2300 gas limit
246      * imposed by `transfer`, making them unable to receive funds via
247      * `transfer`. {sendValue} removes this limitation.
248      *
249      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
250      *
251      * IMPORTANT: because control is transferred to `recipient`, care must be
252      * taken to not create reentrancy vulnerabilities. Consider using
253      * {ReentrancyGuard} or the
254      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
255      */
256     function sendValue(address payable recipient, uint256 amount) internal {
257         require(address(this).balance >= amount, "Address: insufficient balance");
258 
259         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
260         (bool success, ) = recipient.call{ value: amount }("");
261         require(success, "Address: unable to send value, recipient may have reverted");
262     }
263 
264     /**
265      * @dev Performs a Solidity function call using a low level `call`. A
266      * plain`call` is an unsafe replacement for a function call: use this
267      * function instead.
268      *
269      * If `target` reverts with a revert reason, it is bubbled up by this
270      * function (like regular Solidity function calls).
271      *
272      * Returns the raw returned data. To convert to the expected return value,
273      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
274      *
275      * Requirements:
276      *
277      * - `target` must be a contract.
278      * - calling `target` with `data` must not revert.
279      *
280      * _Available since v3.1._
281      */
282     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
283       return functionCall(target, data, "Address: low-level call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
288      * `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
293         return _functionCallWithValue(target, data, 0, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but also transferring `value` wei to `target`.
299      *
300      * Requirements:
301      *
302      * - the calling contract must have an ETH balance of at least `value`.
303      * - the called Solidity function must be `payable`.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
308         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
313      * with `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     // function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
318     //     require(address(this).balance >= value, "Address: insufficient balance for call");
319     //     return _functionCallWithValue(target, data, value, errorMessage);
320     // }
321     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
322         require(address(this).balance >= value, "Address: insufficient balance for call");
323         require(isContract(target), "Address: call to non-contract");
324 
325         // solhint-disable-next-line avoid-low-level-calls
326         (bool success, bytes memory returndata) = target.call{ value: value }(data);
327         return _verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
331         require(isContract(target), "Address: call to non-contract");
332 
333         // solhint-disable-next-line avoid-low-level-calls
334         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
335         if (success) {
336             return returndata;
337         } else {
338             // Look for revert reason and bubble it up if present
339             if (returndata.length > 0) {
340                 // The easiest way to bubble the revert reason is using memory via assembly
341 
342                 // solhint-disable-next-line no-inline-assembly
343                 assembly {
344                     let returndata_size := mload(returndata)
345                     revert(add(32, returndata), returndata_size)
346                 }
347             } else {
348                 revert(errorMessage);
349             }
350         }
351     }
352 
353   /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
360         return functionStaticCall(target, data, "Address: low-level static call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
370         require(isContract(target), "Address: static call to non-contract");
371 
372         // solhint-disable-next-line avoid-low-level-calls
373         (bool success, bytes memory returndata) = target.staticcall(data);
374         return _verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but performing a delegate call.
380      *
381      * _Available since v3.3._
382      */
383     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
384         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.3._
392      */
393     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
394         require(isContract(target), "Address: delegate call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.delegatecall(data);
398         return _verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
402         if (success) {
403             return returndata;
404         } else {
405             // Look for revert reason and bubble it up if present
406             if (returndata.length > 0) {
407                 // The easiest way to bubble the revert reason is using memory via assembly
408 
409                 // solhint-disable-next-line no-inline-assembly
410                 assembly {
411                     let returndata_size := mload(returndata)
412                     revert(add(32, returndata), returndata_size)
413                 }
414             } else {
415                 revert(errorMessage);
416             }
417         }
418     }
419 
420     function addressToString(address _address) internal pure returns(string memory) {
421         bytes32 _bytes = bytes32(uint256(_address));
422         bytes memory HEX = "0123456789abcdef";
423         bytes memory _addr = new bytes(42);
424 
425         _addr[0] = '0';
426         _addr[1] = 'x';
427 
428         for(uint256 i = 0; i < 20; i++) {
429             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
430             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
431         }
432 
433         return string(_addr);
434 
435     }
436 }
437 
438 interface IERC20 {
439   /**
440    * @dev Returns the amount of tokens in existence.
441    */
442   function totalSupply() external view returns (uint256);
443 
444   /**
445    * @dev Returns the amount of tokens owned by `account`.
446    */
447   function balanceOf(address account) external view returns (uint256);
448 
449   /**
450    * @dev Moves `amount` tokens from the caller's account to `recipient`.
451    *
452    * Returns a boolean value indicating whether the operation succeeded.
453    *
454    * Emits a {Transfer} event.
455    */
456   function transfer(address recipient, uint256 amount) external returns (bool);
457 
458   /**
459    * @dev Returns the remaining number of tokens that `spender` will be
460    * allowed to spend on behalf of `owner` through {transferFrom}. This is
461    * zero by default.
462    *
463    * This value changes when {approve} or {transferFrom} are called.
464    */
465   function allowance(address owner, address spender) external view returns (uint256);
466 
467   /**
468    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
469    *
470    * Returns a boolean value indicating whether the operation succeeded.
471    *
472    * IMPORTANT: Beware that changing an allowance with this method brings the risk
473    * that someone may use both the old and the new allowance by unfortunate
474    * transaction ordering. One possible solution to mitigate this race
475    * condition is to first reduce the spender's allowance to 0 and set the
476    * desired value afterwards:
477    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
478    *
479    * Emits an {Approval} event.
480    */
481   function approve(address spender, uint256 amount) external returns (bool);
482 
483   /**
484    * @dev Moves `amount` tokens from `sender` to `recipient` using the
485    * allowance mechanism. `amount` is then deducted from the caller's
486    * allowance.
487    *
488    * Returns a boolean value indicating whether the operation succeeded.
489    *
490    * Emits a {Transfer} event.
491    */
492   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
493 
494   /**
495    * @dev Emitted when `value` tokens are moved from one account (`from`) to
496    * another (`to`).
497    *
498    * Note that `value` may be zero.
499    */
500   event Transfer(address indexed from, address indexed to, uint256 value);
501 
502   /**
503    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
504    * a call to {approve}. `value` is the new allowance.
505    */
506   event Approval(address indexed owner, address indexed spender, uint256 value);
507 }
508 
509 abstract contract ERC20
510   is 
511     IERC20
512   {
513 
514   using SafeMath for uint256;
515 
516   // TODO comment actual hash value.
517   bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
518     
519   // Present in ERC777
520   mapping (address => uint256) internal _balances;
521 
522   // Present in ERC777
523   mapping (address => mapping (address => uint256)) internal _allowances;
524 
525   // Present in ERC777
526   uint256 internal _totalSupply;
527 
528   // Present in ERC777
529   string internal _name;
530     
531   // Present in ERC777
532   string internal _symbol;
533     
534   // Present in ERC777
535   uint8 internal _decimals;
536 
537   /**
538    * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
539    * a default value of 18.
540    *
541    * To select a different value for {decimals}, use {_setupDecimals}.
542    *
543    * All three of these values are immutable: they can only be set once during
544    * construction.
545    */
546   constructor (string memory name_, string memory symbol_, uint8 decimals_) {
547     _name = name_;
548     _symbol = symbol_;
549     _decimals = decimals_;
550   }
551 
552   /**
553    * @dev Returns the name of the token.
554    */
555   // Present in ERC777
556   function name() public view returns (string memory) {
557     return _name;
558   }
559 
560   /**
561    * @dev Returns the symbol of the token, usually a shorter version of the
562    * name.
563    */
564   // Present in ERC777
565   function symbol() public view returns (string memory) {
566     return _symbol;
567   }
568 
569   /**
570    * @dev Returns the number of decimals used to get its user representation.
571    * For example, if `decimals` equals `2`, a balance of `505` tokens should
572    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
573    *
574    * Tokens usually opt for a value of 18, imitating the relationship between
575    * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
576    * called.
577    *
578    * NOTE: This information is only used for _display_ purposes: it in
579    * no way affects any of the arithmetic of the contract, including
580    * {IERC20-balanceOf} and {IERC20-transfer}.
581    */
582   // Present in ERC777
583   function decimals() public view returns (uint8) {
584     return _decimals;
585   }
586 
587   /**
588    * @dev See {IERC20-totalSupply}.
589    */
590   // Present in ERC777
591   function totalSupply() public view override returns (uint256) {
592     return _totalSupply;
593   }
594 
595   /**
596    * @dev See {IERC20-balanceOf}.
597    */
598   // Present in ERC777
599   function balanceOf(address account) public view virtual override returns (uint256) {
600     return _balances[account];
601   }
602 
603   /**
604    * @dev See {IERC20-transfer}.
605    *
606    * Requirements:
607    *
608    * - `recipient` cannot be the zero address.
609    * - the caller must have a balance of at least `amount`.
610    */
611   // Overrideen in ERC777
612   // Confirm that this behavior changes 
613   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
614     _transfer(msg.sender, recipient, amount);
615     return true;
616   }
617 
618     /**
619      * @dev See {IERC20-allowance}.
620      */
621     // Present in ERC777
622     function allowance(address owner, address spender) public view virtual override returns (uint256) {
623         return _allowances[owner][spender];
624     }
625 
626     /**
627      * @dev See {IERC20-approve}.
628      *
629      * Requirements:
630      *
631      * - `spender` cannot be the zero address.
632      */
633     // Present in ERC777
634     function approve(address spender, uint256 amount) public virtual override returns (bool) {
635         _approve(msg.sender, spender, amount);
636         return true;
637     }
638 
639     /**
640      * @dev See {IERC20-transferFrom}.
641      *
642      * Emits an {Approval} event indicating the updated allowance. This is not
643      * required by the EIP. See the note at the beginning of {ERC20}.
644      *
645      * Requirements:
646      *
647      * - `sender` and `recipient` cannot be the zero address.
648      * - `sender` must have a balance of at least `amount`.
649      * - the caller must have allowance for ``sender``'s tokens of at least
650      * `amount`.
651      */
652     // Present in ERC777
653     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
654         _transfer(sender, recipient, amount);
655         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
656         return true;
657     }
658 
659     /**
660      * @dev Atomically increases the allowance granted to `spender` by the caller.
661      *
662      * This is an alternative to {approve} that can be used as a mitigation for
663      * problems described in {IERC20-approve}.
664      *
665      * Emits an {Approval} event indicating the updated allowance.
666      *
667      * Requirements:
668      *
669      * - `spender` cannot be the zero address.
670      */
671     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
672         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
673         return true;
674     }
675 
676     /**
677      * @dev Atomically decreases the allowance granted to `spender` by the caller.
678      *
679      * This is an alternative to {approve} that can be used as a mitigation for
680      * problems described in {IERC20-approve}.
681      *
682      * Emits an {Approval} event indicating the updated allowance.
683      *
684      * Requirements:
685      *
686      * - `spender` cannot be the zero address.
687      * - `spender` must have allowance for the caller of at least
688      * `subtractedValue`.
689      */
690     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
691         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
692         return true;
693     }
694 
695   /**
696    * @dev Moves tokens `amount` from `sender` to `recipient`.
697    *
698    * This is internal function is equivalent to {transfer}, and can be used to
699    * e.g. implement automatic token fees, slashing mechanisms, etc.
700    *
701    * Emits a {Transfer} event.
702    *
703    * Requirements:
704    *
705    * - `sender` cannot be the zero address.
706    * - `recipient` cannot be the zero address.
707    * - `sender` must have a balance of at least `amount`.
708    */
709   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
710     require(sender != address(0), "ERC20: transfer from the zero address");
711     require(recipient != address(0), "ERC20: transfer to the zero address");
712 
713     _beforeTokenTransfer(sender, recipient, amount);
714 
715     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
716     _balances[recipient] = _balances[recipient].add(amount);
717     emit Transfer(sender, recipient, amount);
718   }
719 
720     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
721      * the total supply.
722      *
723      * Emits a {Transfer} event with `from` set to the zero address.
724      *
725      * Requirements:
726      *
727      * - `to` cannot be the zero address.
728      */
729     // Present in ERC777
730     function _mint(address account_, uint256 ammount_) internal virtual {
731         require(account_ != address(0), "ERC20: mint to the zero address");
732         _beforeTokenTransfer(address( this ), account_, ammount_);
733         _totalSupply = _totalSupply.add(ammount_);
734         _balances[account_] = _balances[account_].add(ammount_);
735         emit Transfer(address( this ), account_, ammount_);
736     }
737 
738     /**
739      * @dev Destroys `amount` tokens from `account`, reducing the
740      * total supply.
741      *
742      * Emits a {Transfer} event with `to` set to the zero address.
743      *
744      * Requirements:
745      *
746      * - `account` cannot be the zero address.
747      * - `account` must have at least `amount` tokens.
748      */
749     // Present in ERC777
750     function _burn(address account, uint256 amount) internal virtual {
751         require(account != address(0), "ERC20: burn from the zero address");
752 
753         _beforeTokenTransfer(account, address(0), amount);
754 
755         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
756         _totalSupply = _totalSupply.sub(amount);
757         emit Transfer(account, address(0), amount);
758     }
759 
760     /**
761      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
762      *
763      * This internal function is equivalent to `approve`, and can be used to
764      * e.g. set automatic allowances for certain subsystems, etc.
765      *
766      * Emits an {Approval} event.
767      *
768      * Requirements:
769      *
770      * - `owner` cannot be the zero address.
771      * - `spender` cannot be the zero address.
772      */
773     // Present in ERC777
774     function _approve(address owner, address spender, uint256 amount) internal virtual {
775         require(owner != address(0), "ERC20: approve from the zero address");
776         require(spender != address(0), "ERC20: approve to the zero address");
777 
778         _allowances[owner][spender] = amount;
779         emit Approval(owner, spender, amount);
780     }
781 
782     /**
783      * @dev Sets {decimals} to a value other than the default one of 18.
784      *
785      * WARNING: This function should only be called from the constructor. Most
786      * applications that interact with token contracts will not expect
787      * {decimals} to ever change, and may work incorrectly if it does.
788      */
789     // Considering deprication to reduce size of bytecode as changing _decimals to internal acheived the same functionality.
790     // function _setupDecimals(uint8 decimals_) internal {
791     //     _decimals = decimals_;
792     // }
793 
794   /**
795    * @dev Hook that is called before any transfer of tokens. This includes
796    * minting and burning.
797    *
798    * Calling conditions:
799    *
800    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
801    * will be to transferred to `to`.
802    * - when `from` is zero, `amount` tokens will be minted for `to`.
803    * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
804    * - `from` and `to` are never both zero.
805    *
806    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
807    */
808   // Present in ERC777
809   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
810 }
811 
812 library Counters {
813     using SafeMath for uint256;
814 
815     struct Counter {
816         // This variable should never be directly accessed by users of the library: interactions must be restricted to
817         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
818         // this feature: see https://github.com/ethereum/solidity/issues/4637
819         uint256 _value; // default: 0
820     }
821 
822     function current(Counter storage counter) internal view returns (uint256) {
823         return counter._value;
824     }
825 
826     function increment(Counter storage counter) internal {
827         // The {SafeMath} overflow check can be skipped here, see the comment at the top
828         counter._value += 1;
829     }
830 
831     function decrement(Counter storage counter) internal {
832         counter._value = counter._value.sub(1);
833     }
834 }
835 
836 interface IERC2612Permit {
837     /**
838      * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
839      * given `owner`'s signed approval.
840      *
841      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
842      * ordering also apply here.
843      *
844      * Emits an {Approval} event.
845      *
846      * Requirements:
847      *
848      * - `owner` cannot be the zero address.
849      * - `spender` cannot be the zero address.
850      * - `deadline` must be a timestamp in the future.
851      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
852      * over the EIP712-formatted function arguments.
853      * - the signature must use ``owner``'s current nonce (see {nonces}).
854      *
855      * For more information on the signature format, see the
856      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
857      * section].
858      */
859     function permit(
860         address owner,
861         address spender,
862         uint256 amount,
863         uint256 deadline,
864         uint8 v,
865         bytes32 r,
866         bytes32 s
867     ) external;
868 
869     /**
870      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
871      * included whenever a signature is generated for {permit}.
872      *
873      * Every successful call to {permit} increases ``owner``'s nonce by one. This
874      * prevents a signature from being used multiple times.
875      */
876     function nonces(address owner) external view returns (uint256);
877 }
878 
879 abstract contract ERC20Permit is ERC20, IERC2612Permit {
880     using Counters for Counters.Counter;
881 
882     mapping(address => Counters.Counter) private _nonces;
883 
884     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
885     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
886 
887     bytes32 public DOMAIN_SEPARATOR;
888 
889     constructor() {
890 
891         uint256 chainID;
892         assembly {
893             chainID := chainid()
894         }
895 
896         DOMAIN_SEPARATOR = keccak256(abi.encode(
897             keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
898             keccak256(bytes(name())),
899             keccak256(bytes("1")), // Version
900             chainID,
901             address(this)
902         ));
903     }
904 
905     /**
906      * @dev See {IERC2612Permit-permit}.
907      *
908      */
909     function permit(
910         address owner,
911         address spender,
912         uint256 amount,
913         uint256 deadline,
914         uint8 v,
915         bytes32 r,
916         bytes32 s
917     ) public virtual override {
918         require(block.timestamp <= deadline, "Permit: expired deadline");
919 
920         bytes32 hashStruct =
921             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
922 
923         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
924 
925         address signer = ecrecover(_hash, v, r, s);
926         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
927 
928         _nonces[owner].increment();
929         _approve(owner, spender, amount);
930     }
931 
932     /**
933      * @dev See {IERC2612Permit-nonces}.
934      */
935     function nonces(address owner) public view override returns (uint256) {
936         return _nonces[owner].current();
937     }
938 }
939 
940 interface IOwnable {
941   function manager() external view returns (address);
942 
943   function renounceManagement() external;
944   
945   function pushManagement( address newOwner_ ) external;
946   
947   function pullManagement() external;
948 }
949 
950 contract Ownable is IOwnable {
951 
952     address internal _owner;
953     address internal _newOwner;
954 
955     event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
956     event OwnershipPulled(address indexed previousOwner, address indexed newOwner);
957 
958     constructor () {
959         _owner = msg.sender;
960         emit OwnershipPushed( address(0), _owner );
961     }
962 
963     function manager() public view override returns (address) {
964         return _owner;
965     }
966 
967     modifier onlyManager() {
968         require( _owner == msg.sender, "Ownable: caller is not the owner" );
969         _;
970     }
971 
972     function renounceManagement() public virtual override onlyManager() {
973         emit OwnershipPushed( _owner, address(0) );
974         _owner = address(0);
975     }
976 
977     function pushManagement( address newOwner_ ) public virtual override onlyManager() {
978         require( newOwner_ != address(0), "Ownable: new owner is the zero address");
979         emit OwnershipPushed( _owner, newOwner_ );
980         _newOwner = newOwner_;
981     }
982     
983     function pullManagement() public virtual override {
984         require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
985         emit OwnershipPulled( _owner, _newOwner );
986         _owner = _newOwner;
987     }
988 }
989 
990 abstract contract FrozenToken is ERC20Permit, Ownable {
991 
992   using SafeMath for uint256;
993 
994   bool public isTokenFrozen = true;
995   mapping (address => bool ) public isAuthorisedOperators;
996 
997 
998   modifier onlyAuthorisedOperators () {
999     require(!isTokenFrozen || isAuthorisedOperators[msg.sender], 'Frozen: token frozen or msg.sender not authorised');
1000     _;
1001   }
1002 
1003 
1004   function unFreezeToken () external onlyManager () {
1005     isTokenFrozen = false;
1006   }
1007 
1008   function changeAuthorisation (address operator, bool status) public onlyManager {
1009     require(operator != address(0), "Frozen: new operator cant be zero address");
1010     isAuthorisedOperators[operator] = status; 
1011   }
1012 
1013 
1014   function addBatchAuthorisedOperators(address[] memory authorisedOperatorsArray) external onlyManager {
1015     for (uint i = 0; i < authorisedOperatorsArray.length; i++) {
1016     changeAuthorisation(authorisedOperatorsArray[i],true);
1017     }
1018   }
1019 
1020 }
1021 
1022 contract xBTRFLY is FrozenToken {
1023 
1024     using SafeMath for uint256;
1025 
1026     modifier onlyStakingContract() {
1027         require( msg.sender == stakingContract );
1028         _;
1029     }
1030 
1031     address public stakingContract;
1032     address public initializer;
1033 
1034     event LogSupply(uint256 indexed epoch, uint256 timestamp, uint256 totalSupply );
1035     event LogRebase( uint256 indexed epoch, uint256 rebase, uint256 index );
1036     event LogStakingContractUpdated( address stakingContract );
1037 
1038     struct Rebase {
1039         uint epoch;
1040         uint rebase; // 18 decimals
1041         uint totalStakedBefore;
1042         uint totalStakedAfter;
1043         uint amountRebased;
1044         uint index;
1045         uint blockNumberOccured;
1046     }
1047     Rebase[] public rebases;
1048 
1049     uint public INDEX;
1050 
1051     uint256 private constant MAX_UINT256 = ~uint256(0);
1052     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 5000000 * 10**9;
1053 
1054     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
1055     // Use the highest value that fits in a uint256 for max granularity.
1056     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
1057 
1058     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
1059     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
1060 
1061     uint256 private _gonsPerFragment;
1062     mapping(address => uint256) private _gonBalances;
1063 
1064     mapping ( address => mapping ( address => uint256 ) ) private _allowedValue;
1065 
1066     constructor() ERC20("xBTRFLY", "xBTRFLY", 9) ERC20Permit() {
1067         initializer = msg.sender;
1068         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
1069         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
1070     }
1071 
1072     function initialize( address stakingContract_ ) external returns ( bool ) {
1073         require( msg.sender == initializer );
1074         require( stakingContract_ != address(0) );
1075         stakingContract = stakingContract_;
1076         _gonBalances[ stakingContract ] = TOTAL_GONS;
1077 
1078         emit Transfer( address(0x0), stakingContract, _totalSupply );
1079         emit LogStakingContractUpdated( stakingContract_ );
1080         
1081         initializer = address(0);
1082         return true;
1083     }
1084 
1085     function setIndex( uint _INDEX ) external onlyManager() returns ( bool ) {
1086         require( INDEX == 0 );
1087         INDEX = gonsForBalance( _INDEX );
1088         return true;
1089     }
1090 
1091     /**
1092         @notice increases sBTRFLY supply to increase staking balances relative to profit_
1093         @param profit_ uint256
1094         @return uint256
1095      */
1096     function rebase( uint256 profit_, uint epoch_ ) public onlyStakingContract() returns ( uint256 ) {
1097         uint256 rebaseAmount;
1098         uint256 circulatingSupply_ = circulatingSupply();
1099 
1100         if ( profit_ == 0 ) {
1101             emit LogSupply( epoch_, block.timestamp, _totalSupply );
1102             emit LogRebase( epoch_, 0, index() );
1103             return _totalSupply;
1104         } else if ( circulatingSupply_ > 0 ){
1105             rebaseAmount = profit_.mul( _totalSupply ).div( circulatingSupply_ );
1106         } else {
1107             rebaseAmount = profit_;
1108         }
1109 
1110         _totalSupply = _totalSupply.add( rebaseAmount );
1111 
1112         if ( _totalSupply > MAX_SUPPLY ) {
1113             _totalSupply = MAX_SUPPLY;
1114         }
1115 
1116         _gonsPerFragment = TOTAL_GONS.div( _totalSupply );
1117 
1118         _storeRebase( circulatingSupply_, profit_, epoch_ );
1119 
1120         return _totalSupply;
1121     }
1122 
1123     /**
1124         @notice emits event with data about rebase
1125         @param previousCirculating_ uint
1126         @param profit_ uint
1127         @param epoch_ uint
1128         @return bool
1129      */
1130     function _storeRebase( uint previousCirculating_, uint profit_, uint epoch_ ) internal returns ( bool ) {
1131         uint rebasePercent = profit_.mul( 1e18 ).div( previousCirculating_ );
1132 
1133         rebases.push( Rebase ( {
1134             epoch: epoch_,
1135             rebase: rebasePercent, // 18 decimals
1136             totalStakedBefore: previousCirculating_,
1137             totalStakedAfter: circulatingSupply(),
1138             amountRebased: profit_,
1139             index: index(),
1140             blockNumberOccured: block.number
1141         }));
1142         
1143         emit LogSupply( epoch_, block.timestamp, _totalSupply );
1144         emit LogRebase( epoch_, rebasePercent, index() );
1145 
1146         return true;
1147     }
1148 
1149     function balanceOf( address who ) public view override returns ( uint256 ) {
1150         return _gonBalances[ who ].div( _gonsPerFragment );
1151     }
1152 
1153     function gonsForBalance( uint amount ) public view returns ( uint ) {
1154         return amount.mul( _gonsPerFragment );
1155     }
1156 
1157     function balanceForGons( uint gons ) public view returns ( uint ) {
1158         return gons.div( _gonsPerFragment );
1159     }
1160 
1161     // Staking contract holds excess sBTRFLY
1162     function circulatingSupply() public view returns ( uint ) {
1163         return _totalSupply.sub( balanceOf( stakingContract ) );
1164     }
1165 
1166     function index() public view returns ( uint ) {
1167         return balanceForGons( INDEX );
1168     }
1169 
1170     function transfer( address to, uint256 value ) public override onlyAuthorisedOperators returns (bool) {
1171         uint256 gonValue = value.mul( _gonsPerFragment );
1172         _gonBalances[ msg.sender ] = _gonBalances[ msg.sender ].sub( gonValue );
1173         _gonBalances[ to ] = _gonBalances[ to ].add( gonValue );
1174         emit Transfer( msg.sender, to, value );
1175         return true;
1176     }
1177 
1178     function allowance( address owner_, address spender ) public view override returns ( uint256 ) {
1179         return _allowedValue[ owner_ ][ spender ];
1180     }
1181 
1182     function transferFrom( address from, address to, uint256 value ) public override onlyAuthorisedOperators returns ( bool ) {
1183        _allowedValue[ from ][ msg.sender ] = _allowedValue[ from ][ msg.sender ].sub( value );
1184        emit Approval( from, msg.sender,  _allowedValue[ from ][ msg.sender ] );
1185 
1186         uint256 gonValue = gonsForBalance( value );
1187         _gonBalances[ from ] = _gonBalances[from].sub( gonValue );
1188         _gonBalances[ to ] = _gonBalances[to].add( gonValue );
1189         emit Transfer( from, to, value );
1190 
1191         return true;
1192     }
1193 
1194     function approve( address spender, uint256 value ) public override returns (bool) {
1195          _allowedValue[ msg.sender ][ spender ] = value;
1196          emit Approval( msg.sender, spender, value );
1197          return true;
1198     }
1199 
1200     // What gets called in a permit
1201     function _approve( address owner, address spender, uint256 value ) internal override virtual {
1202         _allowedValue[owner][spender] = value;
1203         emit Approval( owner, spender, value );
1204     }
1205 
1206     function increaseAllowance( address spender, uint256 addedValue ) public override returns (bool) {
1207         _allowedValue[ msg.sender ][ spender ] = _allowedValue[ msg.sender ][ spender ].add( addedValue );
1208         emit Approval( msg.sender, spender, _allowedValue[ msg.sender ][ spender ] );
1209         return true;
1210     }
1211 
1212     function decreaseAllowance( address spender, uint256 subtractedValue ) public override returns (bool) {
1213         uint256 oldValue = _allowedValue[ msg.sender ][ spender ];
1214         if (subtractedValue >= oldValue) {
1215             _allowedValue[ msg.sender ][ spender ] = 0;
1216         } else {
1217             _allowedValue[ msg.sender ][ spender ] = oldValue.sub( subtractedValue );
1218         }
1219         emit Approval( msg.sender, spender, _allowedValue[ msg.sender ][ spender ] );
1220         return true;
1221     }
1222 }