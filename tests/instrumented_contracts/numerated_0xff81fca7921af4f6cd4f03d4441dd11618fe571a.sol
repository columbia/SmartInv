1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC20 {
6     /**
7      * @dev Emitted when `value` tokens are moved from one account (`from`) to
8      * another (`to`).
9      *
10      * Note that `value` may be zero.
11      */
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     /**
15      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
16      * a call to {approve}. `value` is the new allowance.
17      */
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `to`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address to, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `from` to `to` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address from, address to, uint256 amount) external returns (bool);
74 }
75 
76 
77 
78 pragma solidity ^0.8.0;
79 
80 
81 /**
82  * @dev Interface for the optional metadata functions from the ERC20 standard.
83  *
84  * _Available since v4.1._
85  */
86 interface IERC20Metadata is IERC20 {
87     /**
88      * @dev Returns the name of the token.
89      */
90     function name() external view returns (string memory);
91 
92     /**
93      * @dev Returns the symbol of the token.
94      */
95     function symbol() external view returns (string memory);
96 
97     /**
98      * @dev Returns the decimals places of the token.
99      */
100     function decimals() external view returns (uint8);
101 }
102 
103 // File: @openzeppelin/contracts/utils/Address.sol
104 
105 
106 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
107 
108 pragma solidity ^0.8.1;
109 
110 /**
111  * @dev Collection of functions related to the address type
112  */
113 library Address {
114     /**
115      * @dev Returns true if `account` is a contract.
116      *
117      * [IMPORTANT]
118      * ====
119      * It is unsafe to assume that an address for which this function returns
120      * false is an externally-owned account (EOA) and not a contract.
121      *
122      * Among others, `isContract` will return false for the following
123      * types of addresses:
124      *
125      *  - an externally-owned account
126      *  - a contract in construction
127      *  - an address where a contract will be created
128      *  - an address where a contract lived, but was destroyed
129      *
130      * Furthermore, `isContract` will also return true if the target contract within
131      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
132      * which only has an effect at the end of a transaction.
133      * ====
134      *
135      * [IMPORTANT]
136      * ====
137      * You shouldn't rely on `isContract` to protect against flash loan attacks!
138      *
139      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
140      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
141      * constructor.
142      * ====
143      */
144     function isContract(address account) internal view returns (bool) {
145         // This method relies on extcodesize/address.code.length, which returns 0
146         // for contracts in construction, since the code is only stored at the end
147         // of the constructor execution.
148 
149         return account.code.length > 0;
150     }
151 
152     /**
153      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
154      * `recipient`, forwarding all available gas and reverting on errors.
155      *
156      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
157      * of certain opcodes, possibly making contracts go over the 2300 gas limit
158      * imposed by `transfer`, making them unable to receive funds via
159      * `transfer`. {sendValue} removes this limitation.
160      *
161      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
162      *
163      * IMPORTANT: because control is transferred to `recipient`, care must be
164      * taken to not create reentrancy vulnerabilities. Consider using
165      * {ReentrancyGuard} or the
166      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
167      */
168     function sendValue(address payable recipient, uint256 amount) internal {
169         require(address(this).balance >= amount, "Address: insufficient balance");
170 
171         (bool success, ) = recipient.call{value: amount}("");
172         require(success, "Address: unable to send value, recipient may have reverted");
173     }
174 
175     /**
176      * @dev Performs a Solidity function call using a low level `call`. A
177      * plain `call` is an unsafe replacement for a function call: use this
178      * function instead.
179      *
180      * If `target` reverts with a revert reason, it is bubbled up by this
181      * function (like regular Solidity function calls).
182      *
183      * Returns the raw returned data. To convert to the expected return value,
184      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
185      *
186      * Requirements:
187      *
188      * - `target` must be a contract.
189      * - calling `target` with `data` must not revert.
190      *
191      * _Available since v3.1._
192      */
193     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
199      * `errorMessage` as a fallback revert reason when `target` reverts.
200      *
201      * _Available since v3.1._
202      */
203     function functionCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, 0, errorMessage);
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
213      * but also transferring `value` wei to `target`.
214      *
215      * Requirements:
216      *
217      * - the calling contract must have an ETH balance of at least `value`.
218      * - the called Solidity function must be `payable`.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
223         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
228      * with `errorMessage` as a fallback revert reason when `target` reverts.
229      *
230      * _Available since v3.1._
231      */
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         require(address(this).balance >= value, "Address: insufficient balance for call");
239         (bool success, bytes memory returndata) = target.call{value: value}(data);
240         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but performing a static call.
246      *
247      * _Available since v3.3._
248      */
249     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
250         return functionStaticCall(target, data, "Address: low-level static call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
255      * but performing a static call.
256      *
257      * _Available since v3.3._
258      */
259     function functionStaticCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal view returns (bytes memory) {
264         (bool success, bytes memory returndata) = target.staticcall(data);
265         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
275         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(
285         address target,
286         bytes memory data,
287         string memory errorMessage
288     ) internal returns (bytes memory) {
289         (bool success, bytes memory returndata) = target.delegatecall(data);
290         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
291     }
292 
293     /**
294      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
295      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
296      *
297      * _Available since v4.8._
298      */
299     function verifyCallResultFromTarget(
300         address target,
301         bool success,
302         bytes memory returndata,
303         string memory errorMessage
304     ) internal view returns (bytes memory) {
305         if (success) {
306             if (returndata.length == 0) {
307                 // only check isContract if the call was successful and the return data is empty
308                 // otherwise we already know that it was a contract
309                 require(isContract(target), "Address: call to non-contract");
310             }
311             return returndata;
312         } else {
313             _revert(returndata, errorMessage);
314         }
315     }
316 
317     /**
318      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
319      * revert reason or using the provided one.
320      *
321      * _Available since v4.3._
322      */
323     function verifyCallResult(
324         bool success,
325         bytes memory returndata,
326         string memory errorMessage
327     ) internal pure returns (bytes memory) {
328         if (success) {
329             return returndata;
330         } else {
331             _revert(returndata, errorMessage);
332         }
333     }
334 
335     function _revert(bytes memory returndata, string memory errorMessage) private pure {
336         // Look for revert reason and bubble it up if present
337         if (returndata.length > 0) {
338             // The easiest way to bubble the revert reason is using memory via assembly
339             /// @solidity memory-safe-assembly
340             assembly {
341                 let returndata_size := mload(returndata)
342                 revert(add(32, returndata), returndata_size)
343             }
344         } else {
345             revert(errorMessage);
346         }
347     }
348 }
349 
350 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
351 
352 
353 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 // CAUTION
358 // This version of SafeMath should only be used with Solidity 0.8 or later,
359 // because it relies on the compiler's built in overflow checks.
360 
361 /**
362  * @dev Wrappers over Solidity's arithmetic operations.
363  *
364  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
365  * now has built in overflow checking.
366  */
367 library SafeMath {
368     /**
369      * @dev Returns the addition of two unsigned integers, with an overflow flag.
370      *
371      * _Available since v3.4._
372      */
373     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
374         unchecked {
375             uint256 c = a + b;
376             if (c < a) return (false, 0);
377             return (true, c);
378         }
379     }
380 
381     /**
382      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
383      *
384      * _Available since v3.4._
385      */
386     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
387         unchecked {
388             if (b > a) return (false, 0);
389             return (true, a - b);
390         }
391     }
392 
393     /**
394      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
395      *
396      * _Available since v3.4._
397      */
398     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
399         unchecked {
400             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
401             // benefit is lost if 'b' is also tested.
402             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
403             if (a == 0) return (true, 0);
404             uint256 c = a * b;
405             if (c / a != b) return (false, 0);
406             return (true, c);
407         }
408     }
409 
410     /**
411      * @dev Returns the division of two unsigned integers, with a division by zero flag.
412      *
413      * _Available since v3.4._
414      */
415     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
416         unchecked {
417             if (b == 0) return (false, 0);
418             return (true, a / b);
419         }
420     }
421 
422     /**
423      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
424      *
425      * _Available since v3.4._
426      */
427     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
428         unchecked {
429             if (b == 0) return (false, 0);
430             return (true, a % b);
431         }
432     }
433 
434     /**
435      * @dev Returns the addition of two unsigned integers, reverting on
436      * overflow.
437      *
438      * Counterpart to Solidity's `+` operator.
439      *
440      * Requirements:
441      *
442      * - Addition cannot overflow.
443      */
444     function add(uint256 a, uint256 b) internal pure returns (uint256) {
445         return a + b;
446     }
447 
448     /**
449      * @dev Returns the subtraction of two unsigned integers, reverting on
450      * overflow (when the result is negative).
451      *
452      * Counterpart to Solidity's `-` operator.
453      *
454      * Requirements:
455      *
456      * - Subtraction cannot overflow.
457      */
458     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
459         return a - b;
460     }
461 
462     /**
463      * @dev Returns the multiplication of two unsigned integers, reverting on
464      * overflow.
465      *
466      * Counterpart to Solidity's `*` operator.
467      *
468      * Requirements:
469      *
470      * - Multiplication cannot overflow.
471      */
472     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
473         return a * b;
474     }
475 
476     /**
477      * @dev Returns the integer division of two unsigned integers, reverting on
478      * division by zero. The result is rounded towards zero.
479      *
480      * Counterpart to Solidity's `/` operator.
481      *
482      * Requirements:
483      *
484      * - The divisor cannot be zero.
485      */
486     function div(uint256 a, uint256 b) internal pure returns (uint256) {
487         return a / b;
488     }
489 
490     /**
491      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
492      * reverting when dividing by zero.
493      *
494      * Counterpart to Solidity's `%` operator. This function uses a `revert`
495      * opcode (which leaves remaining gas untouched) while Solidity uses an
496      * invalid opcode to revert (consuming all remaining gas).
497      *
498      * Requirements:
499      *
500      * - The divisor cannot be zero.
501      */
502     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
503         return a % b;
504     }
505 
506     /**
507      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
508      * overflow (when the result is negative).
509      *
510      * CAUTION: This function is deprecated because it requires allocating memory for the error
511      * message unnecessarily. For custom revert reasons use {trySub}.
512      *
513      * Counterpart to Solidity's `-` operator.
514      *
515      * Requirements:
516      *
517      * - Subtraction cannot overflow.
518      */
519     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
520         unchecked {
521             require(b <= a, errorMessage);
522             return a - b;
523         }
524     }
525 
526     /**
527      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
528      * division by zero. The result is rounded towards zero.
529      *
530      * Counterpart to Solidity's `/` operator. Note: this function uses a
531      * `revert` opcode (which leaves remaining gas untouched) while Solidity
532      * uses an invalid opcode to revert (consuming all remaining gas).
533      *
534      * Requirements:
535      *
536      * - The divisor cannot be zero.
537      */
538     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
539         unchecked {
540             require(b > 0, errorMessage);
541             return a / b;
542         }
543     }
544 
545     /**
546      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
547      * reverting with custom message when dividing by zero.
548      *
549      * CAUTION: This function is deprecated because it requires allocating memory for the error
550      * message unnecessarily. For custom revert reasons use {tryMod}.
551      *
552      * Counterpart to Solidity's `%` operator. This function uses a `revert`
553      * opcode (which leaves remaining gas untouched) while Solidity uses an
554      * invalid opcode to revert (consuming all remaining gas).
555      *
556      * Requirements:
557      *
558      * - The divisor cannot be zero.
559      */
560     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
561         unchecked {
562             require(b > 0, errorMessage);
563             return a % b;
564         }
565     }
566 }
567 
568 // File: @openzeppelin/contracts/utils/Context.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @dev Provides information about the current execution context, including the
577  * sender of the transaction and its data. While these are generally available
578  * via msg.sender and msg.data, they should not be accessed in such a direct
579  * manner, since when dealing with meta-transactions the account sending and
580  * paying for execution may not be the actual sender (as far as an application
581  * is concerned).
582  *
583  * This contract is only required for intermediate, library-like contracts.
584  */
585 abstract contract Context {
586     function _msgSender() internal view virtual returns (address) {
587         return msg.sender;
588     }
589 
590     function _msgData() internal view virtual returns (bytes calldata) {
591         return msg.data;
592     }
593 }
594 
595 
596 pragma solidity ^0.8.0;
597 
598 
599 
600 
601 /**
602  * @dev Implementation of the {IERC20} interface.
603  *
604  * This implementation is agnostic to the way tokens are created. This means
605  * that a supply mechanism has to be added in a derived contract using {_mint}.
606  * For a generic mechanism see {ERC20PresetMinterPauser}.
607  *
608  * TIP: For a detailed writeup see our guide
609  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
610  * to implement supply mechanisms].
611  *
612  * The default value of {decimals} is 18. To change this, you should override
613  * this function so it returns a different value.
614  *
615  * We have followed general OpenZeppelin Contracts guidelines: functions revert
616  * instead returning `false` on failure. This behavior is nonetheless
617  * conventional and does not conflict with the expectations of ERC20
618  * applications.
619  *
620  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
621  * This allows applications to reconstruct the allowance for all accounts just
622  * by listening to said events. Other implementations of the EIP may not emit
623  * these events, as it isn't required by the specification.
624  *
625  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
626  * functions have been added to mitigate the well-known issues around setting
627  * allowances. See {IERC20-approve}.
628  */
629 contract ERC20 is Context, IERC20, IERC20Metadata {
630     mapping(address => uint256) private _balances;
631 
632     mapping(address => mapping(address => uint256)) private _allowances;
633 
634     uint256 private _totalSupply;
635 
636     string private _name;
637     string private _symbol;
638 
639     /**
640      * @dev Sets the values for {name} and {symbol}.
641      *
642      * All two of these values are immutable: they can only be set once during
643      * construction.
644      */
645     constructor(string memory name_, string memory symbol_) {
646         _name = name_;
647         _symbol = symbol_;
648     }
649 
650     /**
651      * @dev Returns the name of the token.
652      */
653     function name() public view virtual override returns (string memory) {
654         return _name;
655     }
656 
657     /**
658      * @dev Returns the symbol of the token, usually a shorter version of the
659      * name.
660      */
661     function symbol() public view virtual override returns (string memory) {
662         return _symbol;
663     }
664 
665     /**
666      * @dev Returns the number of decimals used to get its user representation.
667      * For example, if `decimals` equals `2`, a balance of `505` tokens should
668      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
669      *
670      * Tokens usually opt for a value of 18, imitating the relationship between
671      * Ether and Wei. This is the default value returned by this function, unless
672      * it's overridden.
673      *
674      * NOTE: This information is only used for _display_ purposes: it in
675      * no way affects any of the arithmetic of the contract, including
676      * {IERC20-balanceOf} and {IERC20-transfer}.
677      */
678     function decimals() public view virtual override returns (uint8) {
679         return 18;
680     }
681 
682     /**
683      * @dev See {IERC20-totalSupply}.
684      */
685     function totalSupply() public view virtual override returns (uint256) {
686         return _totalSupply;
687     }
688 
689     /**
690      * @dev See {IERC20-balanceOf}.
691      */
692     function balanceOf(address account) public view virtual override returns (uint256) {
693         return _balances[account];
694     }
695 
696     /**
697      * @dev See {IERC20-transfer}.
698      *
699      * Requirements:
700      *
701      * - `to` cannot be the zero address.
702      * - the caller must have a balance of at least `amount`.
703      */
704     function transfer(address to, uint256 amount) public virtual override returns (bool) {
705         address owner = _msgSender();
706         _transfer(owner, to, amount);
707         return true;
708     }
709 
710     /**
711      * @dev See {IERC20-allowance}.
712      */
713     function allowance(address owner, address spender) public view virtual override returns (uint256) {
714         return _allowances[owner][spender];
715     }
716 
717     /**
718      * @dev See {IERC20-approve}.
719      *
720      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
721      * `transferFrom`. This is semantically equivalent to an infinite approval.
722      *
723      * Requirements:
724      *
725      * - `spender` cannot be the zero address.
726      */
727     function approve(address spender, uint256 amount) public virtual override returns (bool) {
728         address owner = _msgSender();
729         _approve(owner, spender, amount);
730         return true;
731     }
732 
733     /**
734      * @dev See {IERC20-transferFrom}.
735      *
736      * Emits an {Approval} event indicating the updated allowance. This is not
737      * required by the EIP. See the note at the beginning of {ERC20}.
738      *
739      * NOTE: Does not update the allowance if the current allowance
740      * is the maximum `uint256`.
741      *
742      * Requirements:
743      *
744      * - `from` and `to` cannot be the zero address.
745      * - `from` must have a balance of at least `amount`.
746      * - the caller must have allowance for ``from``'s tokens of at least
747      * `amount`.
748      */
749     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
750         address spender = _msgSender();
751         _spendAllowance(from, spender, amount);
752         _transfer(from, to, amount);
753         return true;
754     }
755 
756     /**
757      * @dev Atomically increases the allowance granted to `spender` by the caller.
758      *
759      * This is an alternative to {approve} that can be used as a mitigation for
760      * problems described in {IERC20-approve}.
761      *
762      * Emits an {Approval} event indicating the updated allowance.
763      *
764      * Requirements:
765      *
766      * - `spender` cannot be the zero address.
767      */
768     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
769         address owner = _msgSender();
770         _approve(owner, spender, allowance(owner, spender) + addedValue);
771         return true;
772     }
773 
774     /**
775      * @dev Atomically decreases the allowance granted to `spender` by the caller.
776      *
777      * This is an alternative to {approve} that can be used as a mitigation for
778      * problems described in {IERC20-approve}.
779      *
780      * Emits an {Approval} event indicating the updated allowance.
781      *
782      * Requirements:
783      *
784      * - `spender` cannot be the zero address.
785      * - `spender` must have allowance for the caller of at least
786      * `subtractedValue`.
787      */
788     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
789         address owner = _msgSender();
790         uint256 currentAllowance = allowance(owner, spender);
791         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
792         unchecked {
793             _approve(owner, spender, currentAllowance - subtractedValue);
794         }
795 
796         return true;
797     }
798 
799     /**
800      * @dev Moves `amount` of tokens from `from` to `to`.
801      *
802      * This internal function is equivalent to {transfer}, and can be used to
803      * e.g. implement automatic token fees, slashing mechanisms, etc.
804      *
805      * Emits a {Transfer} event.
806      *
807      * Requirements:
808      *
809      * - `from` cannot be the zero address.
810      * - `to` cannot be the zero address.
811      * - `from` must have a balance of at least `amount`.
812      */
813     function _transfer(address from, address to, uint256 amount) internal virtual {
814         require(from != address(0), "ERC20: transfer from the zero address");
815         require(to != address(0), "ERC20: transfer to the zero address");
816 
817         _beforeTokenTransfer(from, to, amount);
818 
819         uint256 fromBalance = _balances[from];
820         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
821         unchecked {
822             _balances[from] = fromBalance - amount;
823             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
824             // decrementing then incrementing.
825             _balances[to] += amount;
826         }
827 
828         emit Transfer(from, to, amount);
829 
830         _afterTokenTransfer(from, to, amount);
831     }
832 
833     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
834      * the total supply.
835      *
836      * Emits a {Transfer} event with `from` set to the zero address.
837      *
838      * Requirements:
839      *
840      * - `account` cannot be the zero address.
841      */
842     function _mint(address account, uint256 amount) internal virtual {
843         require(account != address(0), "ERC20: mint to the zero address");
844 
845         _beforeTokenTransfer(address(0), account, amount);
846 
847         _totalSupply += amount;
848         unchecked {
849             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
850             _balances[account] += amount;
851         }
852         emit Transfer(address(0), account, amount);
853 
854         _afterTokenTransfer(address(0), account, amount);
855     }
856 
857     /**
858      * @dev Destroys `amount` tokens from `account`, reducing the
859      * total supply.
860      *
861      * Emits a {Transfer} event with `to` set to the zero address.
862      *
863      * Requirements:
864      *
865      * - `account` cannot be the zero address.
866      * - `account` must have at least `amount` tokens.
867      */
868     function _burn(address account, uint256 amount) internal virtual {
869         require(account != address(0), "ERC20: burn from the zero address");
870 
871         _beforeTokenTransfer(account, address(0), amount);
872 
873         uint256 accountBalance = _balances[account];
874         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
875         unchecked {
876             _balances[account] = accountBalance - amount;
877             // Overflow not possible: amount <= accountBalance <= totalSupply.
878             _totalSupply -= amount;
879         }
880 
881         emit Transfer(account, address(0), amount);
882 
883         _afterTokenTransfer(account, address(0), amount);
884     }
885 
886     /**
887      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
888      *
889      * This internal function is equivalent to `approve`, and can be used to
890      * e.g. set automatic allowances for certain subsystems, etc.
891      *
892      * Emits an {Approval} event.
893      *
894      * Requirements:
895      *
896      * - `owner` cannot be the zero address.
897      * - `spender` cannot be the zero address.
898      */
899     function _approve(address owner, address spender, uint256 amount) internal virtual {
900         require(owner != address(0), "ERC20: approve from the zero address");
901         require(spender != address(0), "ERC20: approve to the zero address");
902 
903         _allowances[owner][spender] = amount;
904         emit Approval(owner, spender, amount);
905     }
906 
907     /**
908      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
909      *
910      * Does not update the allowance amount in case of infinite allowance.
911      * Revert if not enough allowance is available.
912      *
913      * Might emit an {Approval} event.
914      */
915     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
916         uint256 currentAllowance = allowance(owner, spender);
917         if (currentAllowance != type(uint256).max) {
918             require(currentAllowance >= amount, "ERC20: insufficient allowance");
919             unchecked {
920                 _approve(owner, spender, currentAllowance - amount);
921             }
922         }
923     }
924 
925     /**
926      * @dev Hook that is called before any transfer of tokens. This includes
927      * minting and burning.
928      *
929      * Calling conditions:
930      *
931      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
932      * will be transferred to `to`.
933      * - when `from` is zero, `amount` tokens will be minted for `to`.
934      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
935      * - `from` and `to` are never both zero.
936      *
937      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
938      */
939     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
940 
941     /**
942      * @dev Hook that is called after any transfer of tokens. This includes
943      * minting and burning.
944      *
945      * Calling conditions:
946      *
947      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
948      * has been transferred to `to`.
949      * - when `from` is zero, `amount` tokens have been minted for `to`.
950      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
951      * - `from` and `to` are never both zero.
952      *
953      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
954      */
955     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
956 }
957 
958 // File: @openzeppelin/contracts/access/Ownable.sol
959 
960 
961 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
962 
963 pragma solidity ^0.8.0;
964 
965 
966 /**
967  * @dev Contract module which provides a basic access control mechanism, where
968  * there is an account (an owner) that can be granted exclusive access to
969  * specific functions.
970  *
971  * By default, the owner account will be the one that deploys the contract. This
972  * can later be changed with {transferOwnership}.
973  *
974  * This module is used through inheritance. It will make available the modifier
975  * `onlyOwner`, which can be applied to your functions to restrict their use to
976  * the owner.
977  */
978 abstract contract Ownable is Context {
979     address private _owner;
980 
981     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
982 
983     /**
984      * @dev Initializes the contract setting the deployer as the initial owner.
985      */
986     constructor() {
987         _transferOwnership(_msgSender());
988     }
989 
990     /**
991      * @dev Throws if called by any account other than the owner.
992      */
993     modifier onlyOwner() {
994         _checkOwner();
995         _;
996     }
997 
998     /**
999      * @dev Returns the address of the current owner.
1000      */
1001     function owner() public view virtual returns (address) {
1002         return _owner;
1003     }
1004 
1005     /**
1006      * @dev Throws if the sender is not the owner.
1007      */
1008     function _checkOwner() internal view virtual {
1009         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1010     }
1011 
1012     /**
1013      * @dev Leaves the contract without owner. It will not be possible to call
1014      * `onlyOwner` functions. Can only be called by the current owner.
1015      *
1016      * NOTE: Renouncing ownership will leave the contract without an owner,
1017      * thereby disabling any functionality that is only available to the owner.
1018      */
1019     function renounceOwnership() public virtual onlyOwner {
1020         _transferOwnership(address(0));
1021     }
1022 
1023     /**
1024      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1025      * Can only be called by the current owner.
1026      */
1027     function transferOwnership(address newOwner) public virtual onlyOwner {
1028         require(newOwner != address(0), "Ownable: new owner is the zero address");
1029         _transferOwnership(newOwner);
1030     }
1031 
1032     /**
1033      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1034      * Internal function without access restriction.
1035      */
1036     function _transferOwnership(address newOwner) internal virtual {
1037         address oldOwner = _owner;
1038         _owner = newOwner;
1039         emit OwnershipTransferred(oldOwner, newOwner);
1040     }
1041 }
1042 
1043 
1044 
1045 pragma solidity >= 0.8.0;
1046 
1047 
1048 
1049 
1050 
1051 contract DNDToken is ERC20, Ownable {
1052     using SafeMath for uint256;
1053     using Address for address;
1054     uint256 private constant preMineSupply = 100000000 * 1e18;
1055 
1056     constructor() ERC20("Depend New Dawn", "DND") {
1057         _mint(msg.sender, preMineSupply);
1058     }
1059 
1060 }