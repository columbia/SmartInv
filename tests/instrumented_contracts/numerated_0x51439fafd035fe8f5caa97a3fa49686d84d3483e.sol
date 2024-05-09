1 //SPDX-License-Identifier: Unlicensed
2 pragma solidity >=0.7.0 <0.9.0;
3 abstract contract Context {
4     function _msgSender() internal view returns (address payable) {
5         return payable(msg.sender);
6     }
7 
8     function _msgData() internal view returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 /**
15  * @dev Collection of functions related to the address type
16  */
17 library Address {
18     /**
19      * @dev Returns true if `account` is a contract.
20      *
21      * [IMPORTANT]
22      * ====
23      * It is unsafe to assume that an address for which this function returns
24      * false is an externally-owned account (EOA) and not a contract.
25      *
26      * Among others, `isContract` will return false for the following
27      * types of addresses:
28      *
29      *  - an externally-owned account
30      *  - a contract in construction
31      *  - an address where a contract will be created
32      *  - an address where a contract lived, but was destroyed
33      * ====
34      *
35      * [IMPORTANT]
36      * ====
37      * You shouldn't rely on `isContract` to protect against flash loan attacks!
38      *
39      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
40      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
41      * constructor.
42      * ====
43      */
44     function isContract(address account) internal view returns (bool) {
45         // This method relies on extcodesize/address.code.length, which returns 0
46         // for contracts in construction, since the code is only stored at the end
47         // of the constructor execution.
48 
49         return account.code.length > 0;
50     }
51 
52     /**
53      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
54      * `recipient`, forwarding all available gas and reverting on errors.
55      *
56      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
57      * of certain opcodes, possibly making contracts go over the 2300 gas limit
58      * imposed by `transfer`, making them unable to receive funds via
59      * `transfer`. {sendValue} removes this limitation.
60      *
61      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
62      *
63      * IMPORTANT: because control is transferred to `recipient`, care must be
64      * taken to not create reentrancy vulnerabilities. Consider using
65      * {ReentrancyGuard} or the
66      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
67      */
68     function sendValue(address payable recipient, uint256 amount) internal {
69         require(address(this).balance >= amount, "Address: insufficient balance");
70 
71         (bool success, ) = recipient.call{value: amount}("");
72         require(success, "Address: unable to send value, recipient may have reverted");
73     }
74 
75     /**
76      * @dev Performs a Solidity function call using a low level `call`. A
77      * plain `call` is an unsafe replacement for a function call: use this
78      * function instead.
79      *
80      * If `target` reverts with a revert reason, it is bubbled up by this
81      * function (like regular Solidity function calls).
82      *
83      * Returns the raw returned data. To convert to the expected return value,
84      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
85      *
86      * Requirements:
87      *
88      * - `target` must be a contract.
89      * - calling `target` with `data` must not revert.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
99      * `errorMessage` as a fallback revert reason when `target` reverts.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(
104         address target,
105         bytes memory data,
106         string memory errorMessage
107     ) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, 0, errorMessage);
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
113      * but also transferring `value` wei to `target`.
114      *
115      * Requirements:
116      *
117      * - the calling contract must have an ETH balance of at least `value`.
118      * - the called Solidity function must be `payable`.
119      *
120      * _Available since v3.1._
121      */
122     function functionCallWithValue(
123         address target,
124         bytes memory data,
125         uint256 value
126     ) internal returns (bytes memory) {
127         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
128     }
129 
130     /**
131      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
132      * with `errorMessage` as a fallback revert reason when `target` reverts.
133      *
134      * _Available since v3.1._
135      */
136     function functionCallWithValue(
137         address target,
138         bytes memory data,
139         uint256 value,
140         string memory errorMessage
141     ) internal returns (bytes memory) {
142         require(address(this).balance >= value, "Address: insufficient balance for call");
143         (bool success, bytes memory returndata) = target.call{value: value}(data);
144         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
149      * but performing a static call.
150      *
151      * _Available since v3.3._
152      */
153     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
154         return functionStaticCall(target, data, "Address: low-level static call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
159      * but performing a static call.
160      *
161      * _Available since v3.3._
162      */
163     function functionStaticCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal view returns (bytes memory) {
168         (bool success, bytes memory returndata) = target.staticcall(data);
169         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
199      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
200      *
201      * _Available since v4.8._
202      */
203     function verifyCallResultFromTarget(
204         address target,
205         bool success,
206         bytes memory returndata,
207         string memory errorMessage
208     ) internal view returns (bytes memory) {
209         if (success) {
210             if (returndata.length == 0) {
211                 // only check isContract if the call was successful and the return data is empty
212                 // otherwise we already know that it was a contract
213                 require(isContract(target), "Address: call to non-contract");
214             }
215             return returndata;
216         } else {
217             _revert(returndata, errorMessage);
218         }
219     }
220 
221     /**
222      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
223      * revert reason or using the provided one.
224      *
225      * _Available since v4.3._
226      */
227     function verifyCallResult(
228         bool success,
229         bytes memory returndata,
230         string memory errorMessage
231     ) internal pure returns (bytes memory) {
232         if (success) {
233             return returndata;
234         } else {
235             _revert(returndata, errorMessage);
236         }
237     }
238 
239     function _revert(bytes memory returndata, string memory errorMessage) private pure {
240         // Look for revert reason and bubble it up if present
241         if (returndata.length > 0) {
242             // The easiest way to bubble the revert reason is using memory via assembly
243             /// @solidity memory-safe-assembly
244             assembly {
245                 let returndata_size := mload(returndata)
246                 revert(add(32, returndata), returndata_size)
247             }
248         } else {
249             revert(errorMessage);
250         }
251     }
252 }
253 
254 // CAUTION
255 // This version of SafeMath should only be used with Solidity 0.8 or later,
256 // because it relies on the compiler's built in overflow checks.
257 
258 /**
259  * @dev Wrappers over Solidity's arithmetic operations.
260  *
261  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
262  * now has built in overflow checking.
263  */
264 library SafeMath {
265     /**
266      * @dev Returns the addition of two unsigned integers, with an overflow flag.
267      *
268      * _Available since v3.4._
269      */
270     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         unchecked {
272             uint256 c = a + b;
273             if (c < a) return (false, 0);
274             return (true, c);
275         }
276     }
277 
278     /**
279      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
280      *
281      * _Available since v3.4._
282      */
283     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
284         unchecked {
285             if (b > a) return (false, 0);
286             return (true, a - b);
287         }
288     }
289 
290     /**
291      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
292      *
293      * _Available since v3.4._
294      */
295     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
296         unchecked {
297             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
298             // benefit is lost if 'b' is also tested.
299             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
300             if (a == 0) return (true, 0);
301             uint256 c = a * b;
302             if (c / a != b) return (false, 0);
303             return (true, c);
304         }
305     }
306 
307     /**
308      * @dev Returns the division of two unsigned integers, with a division by zero flag.
309      *
310      * _Available since v3.4._
311      */
312     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
313         unchecked {
314             if (b == 0) return (false, 0);
315             return (true, a / b);
316         }
317     }
318 
319     /**
320      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
321      *
322      * _Available since v3.4._
323      */
324     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
325         unchecked {
326             if (b == 0) return (false, 0);
327             return (true, a % b);
328         }
329     }
330 
331     /**
332      * @dev Returns the addition of two unsigned integers, reverting on
333      * overflow.
334      *
335      * Counterpart to Solidity's `+` operator.
336      *
337      * Requirements:
338      *
339      * - Addition cannot overflow.
340      */
341     function add(uint256 a, uint256 b) internal pure returns (uint256) {
342         return a + b;
343     }
344 
345     /**
346      * @dev Returns the subtraction of two unsigned integers, reverting on
347      * overflow (when the result is negative).
348      *
349      * Counterpart to Solidity's `-` operator.
350      *
351      * Requirements:
352      *
353      * - Subtraction cannot overflow.
354      */
355     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
356         return a - b;
357     }
358 
359     /**
360      * @dev Returns the multiplication of two unsigned integers, reverting on
361      * overflow.
362      *
363      * Counterpart to Solidity's `*` operator.
364      *
365      * Requirements:
366      *
367      * - Multiplication cannot overflow.
368      */
369     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
370         return a * b;
371     }
372 
373     /**
374      * @dev Returns the integer division of two unsigned integers, reverting on
375      * division by zero. The result is rounded towards zero.
376      *
377      * Counterpart to Solidity's `/` operator.
378      *
379      * Requirements:
380      *
381      * - The divisor cannot be zero.
382      */
383     function div(uint256 a, uint256 b) internal pure returns (uint256) {
384         return a / b;
385     }
386 
387     /**
388      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
389      * reverting when dividing by zero.
390      *
391      * Counterpart to Solidity's `%` operator. This function uses a `revert`
392      * opcode (which leaves remaining gas untouched) while Solidity uses an
393      * invalid opcode to revert (consuming all remaining gas).
394      *
395      * Requirements:
396      *
397      * - The divisor cannot be zero.
398      */
399     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
400         return a % b;
401     }
402 
403     /**
404      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
405      * overflow (when the result is negative).
406      *
407      * CAUTION: This function is deprecated because it requires allocating memory for the error
408      * message unnecessarily. For custom revert reasons use {trySub}.
409      *
410      * Counterpart to Solidity's `-` operator.
411      *
412      * Requirements:
413      *
414      * - Subtraction cannot overflow.
415      */
416     function sub(
417         uint256 a,
418         uint256 b,
419         string memory errorMessage
420     ) internal pure returns (uint256) {
421         unchecked {
422             require(b <= a, errorMessage);
423             return a - b;
424         }
425     }
426 
427     /**
428      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
429      * division by zero. The result is rounded towards zero.
430      *
431      * Counterpart to Solidity's `/` operator. Note: this function uses a
432      * `revert` opcode (which leaves remaining gas untouched) while Solidity
433      * uses an invalid opcode to revert (consuming all remaining gas).
434      *
435      * Requirements:
436      *
437      * - The divisor cannot be zero.
438      */
439     function div(
440         uint256 a,
441         uint256 b,
442         string memory errorMessage
443     ) internal pure returns (uint256) {
444         unchecked {
445             require(b > 0, errorMessage);
446             return a / b;
447         }
448     }
449 
450     /**
451      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
452      * reverting with custom message when dividing by zero.
453      *
454      * CAUTION: This function is deprecated because it requires allocating memory for the error
455      * message unnecessarily. For custom revert reasons use {tryMod}.
456      *
457      * Counterpart to Solidity's `%` operator. This function uses a `revert`
458      * opcode (which leaves remaining gas untouched) while Solidity uses an
459      * invalid opcode to revert (consuming all remaining gas).
460      *
461      * Requirements:
462      *
463      * - The divisor cannot be zero.
464      */
465     function mod(
466         uint256 a,
467         uint256 b,
468         string memory errorMessage
469     ) internal pure returns (uint256) {
470         unchecked {
471             require(b > 0, errorMessage);
472             return a % b;
473         }
474     }
475 }
476 
477 interface IERC20 {
478     function totalSupply() external view returns (uint256);
479     function decimals() external view returns (uint8);
480     function symbol() external view returns (string memory);
481     function name() external view returns (string memory);
482     function balanceOf(address account) external view returns (uint256);
483     function transfer(address recipient, uint256 amount) external returns (bool);
484     function allowance(address _owner, address spender) external view returns (uint256);
485     function approve(address spender, uint256 amount) external returns (bool);
486     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
487     event Transfer(address indexed from, address indexed to, uint256 value);
488     event Approval(address indexed owner, address indexed spender, uint256 value);
489 }
490 
491 /**
492  * @dev Implementation of the {IERC20} interface.
493  *
494  * This implementation is agnostic to the way tokens are created. This means
495  * that a supply mechanism has to be added in a derived contract using {_mint}.
496  * For a generic mechanism see {ERC20PresetMinterPauser}.
497  *
498  * TIP: For a detailed writeup see our guide
499  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
500  * to implement supply mechanisms].
501  *
502  * We have followed general OpenZeppelin Contracts guidelines: functions revert
503  * instead returning `false` on failure. This behavior is nonetheless
504  * conventional and does not conflict with the expectations of ERC20
505  * applications.
506  *
507  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
508  * This allows applications to reconstruct the allowance for all accounts just
509  * by listening to said events. Other implementations of the EIP may not emit
510  * these events, as it isn't required by the specification.
511  *
512  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
513  * functions have been added to mitigate the well-known issues around setting
514  * allowances. See {IERC20-approve}.
515  */
516 contract ERC20 is Context, IERC20 {
517     mapping(address => uint256) public _balances;
518 
519     mapping(address => mapping(address => uint256)) private _allowances;
520 
521     uint256 private _totalSupply;
522 
523     string private _name;
524     string private _symbol;
525 
526     /**
527      * @dev Sets the values for {name} and {symbol}.
528      *
529      * The default value of {decimals} is 18. To select a different value for
530      * {decimals} you should overload it.
531      *
532      * All two of these values are immutable: they can only be set once during
533      * construction.
534      */
535     constructor(string memory name_, string memory symbol_) {
536         _name = name_;
537         _symbol = symbol_;
538     }
539 
540     /**
541      * @dev Returns the name of the token.
542      */
543     function name() public view virtual override returns (string memory) {
544         return _name;
545     }
546 
547     /**
548      * @dev Returns the symbol of the token, usually a shorter version of the
549      * name.
550      */
551     function symbol() public view virtual override returns (string memory) {
552         return _symbol;
553     }
554 
555     /**
556      * @dev Returns the number of decimals used to get its user representation.
557      * For example, if `decimals` equals `2`, a balance of `505` tokens should
558      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
559      *
560      * Tokens usually opt for a value of 18, imitating the relationship between
561      * Ether and Wei. This is the value {ERC20} uses, unless this function is
562      * overridden;
563      *
564      * NOTE: This information is only used for _display_ purposes: it in
565      * no way affects any of the arithmetic of the contract, including
566      * {IERC20-balanceOf} and {IERC20-transfer}.
567      */
568     function decimals() public view virtual override returns (uint8) {
569         return 18;
570     }
571 
572     /**
573      * @dev See {IERC20-totalSupply}.
574      */
575     function totalSupply() public view virtual override returns (uint256) {
576         return _totalSupply;
577     }
578 
579     /**
580      * @dev See {IERC20-balanceOf}.
581      */
582     function balanceOf(address account) public view virtual override returns (uint256) {
583         return _balances[account];
584     }
585 
586     /**
587      * @dev See {IERC20-transfer}.
588      *
589      * Requirements:
590      *
591      * - `to` cannot be the zero address.
592      * - the caller must have a balance of at least `amount`.
593      */
594     function transfer(address to, uint256 amount) public virtual override returns (bool) {
595         address owner = _msgSender();
596         _transfer(owner, to, amount);
597         return true;
598     }
599 
600     /**
601      * @dev See {IERC20-allowance}.
602      */
603     function allowance(address owner, address spender) public view virtual override returns (uint256) {
604         return _allowances[owner][spender];
605     }
606 
607     /**
608      * @dev See {IERC20-approve}.
609      *
610      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
611      * `transferFrom`. This is semantically equivalent to an infinite approval.
612      *
613      * Requirements:
614      *
615      * - `spender` cannot be the zero address.
616      */
617     function approve(address spender, uint256 amount) public virtual override returns (bool) {
618         address owner = _msgSender();
619         _approve(owner, spender, amount);
620         return true;
621     }
622 
623     /**
624      * @dev See {IERC20-transferFrom}.
625      *
626      * Emits an {Approval} event indicating the updated allowance. This is not
627      * required by the EIP. See the note at the beginning of {ERC20}.
628      *
629      * NOTE: Does not update the allowance if the current allowance
630      * is the maximum `uint256`.
631      *
632      * Requirements:
633      *
634      * - `from` and `to` cannot be the zero address.
635      * - `from` must have a balance of at least `amount`.
636      * - the caller must have allowance for ``from``'s tokens of at least
637      * `amount`.
638      */
639     function transferFrom(
640         address from,
641         address to,
642         uint256 amount
643     ) public virtual override returns (bool) {
644         address spender = _msgSender();
645         _spendAllowance(from, spender, amount);
646         _transfer(from, to, amount);
647         return true;
648     }
649 
650     /**
651      * @dev Atomically increases the allowance granted to `spender` by the caller.
652      *
653      * This is an alternative to {approve} that can be used as a mitigation for
654      * problems described in {IERC20-approve}.
655      *
656      * Emits an {Approval} event indicating the updated allowance.
657      *
658      * Requirements:
659      *
660      * - `spender` cannot be the zero address.
661      */
662     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
663         address owner = _msgSender();
664         _approve(owner, spender, allowance(owner, spender) + addedValue);
665         return true;
666     }
667 
668     /**
669      * @dev Atomically decreases the allowance granted to `spender` by the caller.
670      *
671      * This is an alternative to {approve} that can be used as a mitigation for
672      * problems described in {IERC20-approve}.
673      *
674      * Emits an {Approval} event indicating the updated allowance.
675      *
676      * Requirements:
677      *
678      * - `spender` cannot be the zero address.
679      * - `spender` must have allowance for the caller of at least
680      * `subtractedValue`.
681      */
682     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
683         address owner = _msgSender();
684         uint256 currentAllowance = allowance(owner, spender);
685         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
686         unchecked {
687             _approve(owner, spender, currentAllowance - subtractedValue);
688         }
689 
690         return true;
691     }
692 
693     /**
694      * @dev Moves `amount` of tokens from `from` to `to`.
695      *
696      * This internal function is equivalent to {transfer}, and can be used to
697      * e.g. implement automatic token fees, slashing mechanisms, etc.
698      *
699      * Emits a {Transfer} event.
700      *
701      * Requirements:
702      *
703      * - `from` cannot be the zero address.
704      * - `to` cannot be the zero address.
705      * - `from` must have a balance of at least `amount`.
706      */
707     function _transfer(
708         address from,
709         address to,
710         uint256 amount
711     ) internal virtual {
712         require(from != address(0), "ERC20: transfer from the zero address");
713         require(to != address(0), "ERC20: transfer to the zero address");
714 
715         _beforeTokenTransfer(from, to, amount);
716 
717         uint256 fromBalance = _balances[from];
718         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
719         unchecked {
720             _balances[from] = fromBalance - amount;
721             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
722             // decrementing then incrementing.
723             _balances[to] += amount;
724         }
725 
726         emit Transfer(from, to, amount);
727 
728         _afterTokenTransfer(from, to, amount);
729     }
730 
731     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
732      * the total supply.
733      *
734      * Emits a {Transfer} event with `from` set to the zero address.
735      *
736      * Requirements:
737      *
738      * - `account` cannot be the zero address.
739      */
740     function _mint(address account, uint256 amount) internal virtual {
741         require(account != address(0), "ERC20: mint to the zero address");
742 
743         _beforeTokenTransfer(address(0), account, amount);
744 
745         _totalSupply += amount;
746         unchecked {
747             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
748             _balances[account] += amount;
749         }
750         emit Transfer(address(0), account, amount);
751 
752         _afterTokenTransfer(address(0), account, amount);
753     }
754 
755     /**
756      * @dev Destroys `amount` tokens from `account`, reducing the
757      * total supply.
758      *
759      * Emits a {Transfer} event with `to` set to the zero address.
760      *
761      * Requirements:
762      *
763      * - `account` cannot be the zero address.
764      * - `account` must have at least `amount` tokens.
765      */
766     function _burn(address account, uint256 amount) internal virtual {
767         require(account != address(0), "ERC20: burn from the zero address");
768 
769         _beforeTokenTransfer(account, address(0), amount);
770 
771         uint256 accountBalance = _balances[account];
772         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
773         unchecked {
774             _balances[account] = accountBalance - amount;
775             // Overflow not possible: amount <= accountBalance <= totalSupply.
776             _totalSupply -= amount;
777         }
778 
779         emit Transfer(account, address(0), amount);
780 
781         _afterTokenTransfer(account, address(0), amount);
782     }
783 
784     /**
785      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
786      *
787      * This internal function is equivalent to `approve`, and can be used to
788      * e.g. set automatic allowances for certain subsystems, etc.
789      *
790      * Emits an {Approval} event.
791      *
792      * Requirements:
793      *
794      * - `owner` cannot be the zero address.
795      * - `spender` cannot be the zero address.
796      */
797     function _approve(
798         address owner,
799         address spender,
800         uint256 amount
801     ) internal virtual {
802         require(owner != address(0), "ERC20: approve from the zero address");
803         require(spender != address(0), "ERC20: approve to the zero address");
804 
805         _allowances[owner][spender] = amount;
806         emit Approval(owner, spender, amount);
807     }
808 
809     /**
810      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
811      *
812      * Does not update the allowance amount in case of infinite allowance.
813      * Revert if not enough allowance is available.
814      *
815      * Might emit an {Approval} event.
816      */
817     function _spendAllowance(
818         address owner,
819         address spender,
820         uint256 amount
821     ) internal virtual {
822         uint256 currentAllowance = allowance(owner, spender);
823         if (currentAllowance != type(uint256).max) {
824             require(currentAllowance >= amount, "ERC20: insufficient allowance");
825             unchecked {
826                 _approve(owner, spender, currentAllowance - amount);
827             }
828         }
829     }
830 
831     /**
832      * @dev Hook that is called before any transfer of tokens. This includes
833      * minting and burning.
834      *
835      * Calling conditions:
836      *
837      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
838      * will be transferred to `to`.
839      * - when `from` is zero, `amount` tokens will be minted for `to`.
840      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
841      * - `from` and `to` are never both zero.
842      *
843      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
844      */
845     function _beforeTokenTransfer(
846         address from,
847         address to,
848         uint256 amount
849     ) internal virtual {}
850 
851     /**
852      * @dev Hook that is called after any transfer of tokens. This includes
853      * minting and burning.
854      *
855      * Calling conditions:
856      *
857      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
858      * has been transferred to `to`.
859      * - when `from` is zero, `amount` tokens have been minted for `to`.
860      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
861      * - `from` and `to` are never both zero.
862      *
863      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
864      */
865     function _afterTokenTransfer(
866         address from,
867         address to,
868         uint256 amount
869     ) internal virtual {}
870 }
871 
872 interface IUniswapV2Factory {
873     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
874 
875     function feeTo() external view returns (address);
876     function feeToSetter() external view returns (address);
877 
878     function getPair(address tokenA, address tokenB) external view returns (address pair);
879     function allPairs(uint) external view returns (address pair);
880     function allPairsLength() external view returns (uint);
881 
882     function createPair(address tokenA, address tokenB) external returns (address pair);
883 
884     function setFeeTo(address) external;
885     function setFeeToSetter(address) external;
886 }
887 
888 interface IUniswapV2Pair {
889     event Approval(address indexed owner, address indexed spender, uint value);
890     event Transfer(address indexed from, address indexed to, uint value);
891 
892     function name() external pure returns (string memory);
893     function symbol() external pure returns (string memory);
894     function decimals() external pure returns (uint8);
895     function totalSupply() external view returns (uint);
896     function balanceOf(address owner) external view returns (uint);
897     function allowance(address owner, address spender) external view returns (uint);
898 
899     function approve(address spender, uint value) external returns (bool);
900     function transfer(address to, uint value) external returns (bool);
901     function transferFrom(address from, address to, uint value) external returns (bool);
902 
903     function DOMAIN_SEPARATOR() external view returns (bytes32);
904     function PERMIT_TYPEHASH() external pure returns (bytes32);
905     function nonces(address owner) external view returns (uint);
906 
907     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
908 
909     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
910     event Swap(
911         address indexed sender,
912         uint amount0In,
913         uint amount1In,
914         uint amount0Out,
915         uint amount1Out,
916         address indexed to
917     );
918     event Sync(uint112 reserve0, uint112 reserve1);
919 
920     function MINIMUM_LIQUIDITY() external pure returns (uint);
921     function factory() external view returns (address);
922     function token0() external view returns (address);
923     function token1() external view returns (address);
924     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
925     function price0CumulativeLast() external view returns (uint);
926     function price1CumulativeLast() external view returns (uint);
927     function kLast() external view returns (uint);
928 
929     function burn(address to) external returns (uint amount0, uint amount1);
930     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
931     function skim(address to) external;
932     function sync() external;
933 
934     function initialize(address, address) external;
935 }
936 
937 interface IUniswapV2Router01 {
938     function factory() external pure returns (address);
939     function WETH() external pure returns (address);
940 
941     function addLiquidity(
942         address tokenA,
943         address tokenB,
944         uint amountADesired,
945         uint amountBDesired,
946         uint amountAMin,
947         uint amountBMin,
948         address to,
949         uint deadline
950     ) external returns (uint amountA, uint amountB, uint liquidity);
951     function addLiquidityETH(
952         address token,
953         uint amountTokenDesired,
954         uint amountTokenMin,
955         uint amountETHMin,
956         address to,
957         uint deadline
958     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
959     function removeLiquidity(
960         address tokenA,
961         address tokenB,
962         uint liquidity,
963         uint amountAMin,
964         uint amountBMin,
965         address to,
966         uint deadline
967     ) external returns (uint amountA, uint amountB);
968     function removeLiquidityETH(
969         address token,
970         uint liquidity,
971         uint amountTokenMin,
972         uint amountETHMin,
973         address to,
974         uint deadline
975     ) external returns (uint amountToken, uint amountETH);
976     function removeLiquidityWithPermit(
977         address tokenA,
978         address tokenB,
979         uint liquidity,
980         uint amountAMin,
981         uint amountBMin,
982         address to,
983         uint deadline,
984         bool approveMax, uint8 v, bytes32 r, bytes32 s
985     ) external returns (uint amountA, uint amountB);
986     function removeLiquidityETHWithPermit(
987         address token,
988         uint liquidity,
989         uint amountTokenMin,
990         uint amountETHMin,
991         address to,
992         uint deadline,
993         bool approveMax, uint8 v, bytes32 r, bytes32 s
994     ) external returns (uint amountToken, uint amountETH);
995     function swapExactTokensForTokens(
996         uint amountIn,
997         uint amountOutMin,
998         address[] calldata path,
999         address to,
1000         uint deadline
1001     ) external returns (uint[] memory amounts);
1002     function swapTokensForExactTokens(
1003         uint amountOut,
1004         uint amountInMax,
1005         address[] calldata path,
1006         address to,
1007         uint deadline
1008     ) external returns (uint[] memory amounts);
1009     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1010         external
1011         payable
1012         returns (uint[] memory amounts);
1013     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1014         external
1015         returns (uint[] memory amounts);
1016     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1017         external
1018         returns (uint[] memory amounts);
1019     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1020         external
1021         payable
1022         returns (uint[] memory amounts);
1023 
1024     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1025     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1026     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1027     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1028     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1029 }
1030 
1031 interface IUniswapV2Router02 is IUniswapV2Router01 {
1032     function removeLiquidityETHSupportingFeeOnTransferTokens(
1033         address token,
1034         uint liquidity,
1035         uint amountTokenMin,
1036         uint amountETHMin,
1037         address to,
1038         uint deadline
1039     ) external returns (uint amountETH);
1040     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1041         address token,
1042         uint liquidity,
1043         uint amountTokenMin,
1044         uint amountETHMin,
1045         address to,
1046         uint deadline,
1047         bool approveMax, uint8 v, bytes32 r, bytes32 s
1048     ) external returns (uint amountETH);
1049 
1050     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1051         uint amountIn,
1052         uint amountOutMin,
1053         address[] calldata path,
1054         address to,
1055         uint deadline
1056     ) external;
1057     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1058         uint amountOutMin,
1059         address[] calldata path,
1060         address to,
1061         uint deadline
1062     ) external payable;
1063     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1064         uint amountIn,
1065         uint amountOutMin,
1066         address[] calldata path,
1067         address to,
1068         uint deadline
1069     ) external;
1070 }
1071 
1072 contract Token is ERC20 {
1073     using Address for address;
1074 
1075     mapping(address => uint256) cooldown;
1076     mapping(address => bool) isCooldownExempt;
1077     mapping(address => bool) isFeeExempt;
1078     mapping(address => bool) isMaxWalletExempt;
1079     mapping(address => bool) lpHolder;
1080     mapping(address => bool) lpPairs;
1081 
1082     address public owner;
1083     address public autoLiquidityReceiver;
1084     address public treasuryFeeReceiver;
1085     address public pair;
1086 
1087     uint256 _totalSupply = 1_000_000_000_000 * (10**9); // total supply amount
1088     uint256 totalFee;
1089     uint256 feeAmount;
1090     uint256 burnedTokens;
1091     uint feeDenominator = 1000;
1092     bool tradingOpen;
1093     struct IFees {
1094         uint16 liquidityFee;
1095         uint16 treasuryFee;
1096         uint16 totalFee;
1097     }
1098     struct ICooldown {
1099         bool buycooldownEnabled;
1100         bool sellcooldownEnabled;
1101         uint8 cooldownLimit;
1102         uint8 cooldownTime;
1103     }
1104     struct ITransactionSettings {
1105         uint256 maxTxAmount;
1106         uint256 maxWalletAmount;
1107         bool txLimits;
1108     }     
1109     struct ILiquiditySettings {
1110         uint256 liquidityFeeAccumulator;
1111         uint256 treasuryFees;
1112         uint256 numTokensToSwap;
1113         uint256 lastSwap;
1114         uint8 swapInterval;
1115         bool swapEnabled;
1116         bool inSwap;
1117         bool feesEnabled;
1118         bool autoLiquifyEnabled;
1119     } 
1120     ICooldown public cooldownInfo;
1121     IFees public BuyFees;
1122     IFees public MaxFees;
1123     IFees public SellFees;
1124     IFees public TransferFees;
1125     ILiquiditySettings public LiquiditySettings;
1126     ITransactionSettings TransactionSettings;
1127     IUniswapV2Router02 public router;
1128     modifier onlyOwner() {
1129         require(isOwner(msg.sender), "You are not the owner");
1130         _;
1131     }
1132     modifier swapping() {
1133         LiquiditySettings.inSwap = true;
1134         _;
1135         LiquiditySettings.inSwap = false;
1136     }
1137 
1138     constructor(string memory name, string memory symbol, address lpReceiver, address treasuryReceiver) ERC20(name, symbol) {
1139         owner = _msgSender();
1140         setFeeReceivers(lpReceiver, treasuryReceiver);
1141         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1142         pair = IUniswapV2Factory(router.factory()).createPair(router.WETH(), address(this));
1143         lpHolder[_msgSender()] = true;
1144         lpPairs[pair] = true;
1145 
1146         _approve(address(this), address(router), type(uint256).max);
1147         _approve(_msgSender(), address(router), type(uint256).max);
1148 
1149         isMaxWalletExempt[_msgSender()] = true;
1150         isMaxWalletExempt[address(this)] = true;
1151         isMaxWalletExempt[pair] = true;
1152 
1153         isFeeExempt[address(this)] = true;
1154         isFeeExempt[_msgSender()] = true;
1155 
1156         isCooldownExempt[_msgSender()] = true;
1157         isCooldownExempt[pair] = true;
1158         isCooldownExempt[address(this)] = true;
1159         isCooldownExempt[address(router)] = true;
1160 
1161         cooldownInfo.buycooldownEnabled = true;
1162         cooldownInfo.sellcooldownEnabled = true;
1163         cooldownInfo.cooldownTime = 30; // one transaction every 30 seconds per address
1164         cooldownInfo.cooldownLimit = 60; // cooldown cannot go over 60 seconds
1165 
1166         TransactionSettings.txLimits = true; // limits in effect
1167 
1168         TransactionSettings.maxTxAmount = (_totalSupply * 1) / (100); // 1% max transaction
1169         TransactionSettings.maxWalletAmount = (_totalSupply * 2) / 100; // 2% max wallet
1170 
1171         BuyFees = IFees({
1172             liquidityFee: 0,
1173             treasuryFee: 10,
1174             totalFee: 10 // 1%
1175         });
1176         SellFees = IFees({
1177             liquidityFee: 0,
1178             treasuryFee: 10,
1179             totalFee: 10 // 1%
1180         });    
1181         MaxFees.totalFee = 100; // 20% roundtrip
1182 
1183         LiquiditySettings.swapEnabled = true;
1184         LiquiditySettings.autoLiquifyEnabled = true;
1185         LiquiditySettings.swapInterval = 5;
1186         LiquiditySettings.numTokensToSwap = (_totalSupply * (10)) / (10000);
1187         LiquiditySettings.feesEnabled = true;
1188 
1189         _mint(_msgSender(), _totalSupply);
1190     }
1191     
1192     receive() external payable {}
1193 
1194     // =============================================================
1195     //                      OWNERSHIP OPERATIONS
1196     // =============================================================   
1197     function renounceOwnership(bool keepLimits) public onlyOwner {
1198         emit OwnershipRenounced();
1199         setExemptions(owner, false, false, false, false);
1200         limitsInEffect(keepLimits);
1201         owner = address(0);
1202     }
1203 
1204     function transferOwnership(address newOwner) public onlyOwner {
1205         require(newOwner != address(0), "Ownable: new owner is the zero address, use renounceOwnership Function");
1206         emit OwnershipTransferred(owner, newOwner);
1207 
1208         if(balanceOf(owner) > 0) _basicTransfer(owner, newOwner, balanceOf(owner));
1209         setExemptions(owner, false, false, false, false);
1210         setExemptions(newOwner, true, true, true, false);
1211 
1212         owner = newOwner;
1213     }
1214 
1215     // =============================================================
1216     //                      ADMIN OPERATIONS
1217     // =============================================================  
1218 
1219     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
1220         require(amountPercentage <= 100);
1221         uint256 amountEth = address(this).balance;
1222         payable(treasuryFeeReceiver).transfer(
1223             (amountEth * amountPercentage) / 100
1224         );
1225         LiquiditySettings.treasuryFees += amountEth * amountPercentage;
1226     }
1227 
1228     function clearStuckTokens(address _token, address _to) external onlyOwner returns (bool _sent) {
1229         require(_token != address(0) && _token != address(this));
1230         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1231         _sent = IERC20(_token).transfer(_to, _contractBalance);
1232     }
1233 
1234     function setWalletLimits(uint256 percent, uint256 divisor, bool txOrWallet) external onlyOwner() {
1235         if(txOrWallet){
1236             require(percent >= 1 && divisor <= 1000, "Max Transaction must be set above .1%");
1237             TransactionSettings.maxTxAmount = (_totalSupply * percent) / (divisor);
1238             emit TxLimitUpdated(TransactionSettings.maxTxAmount);
1239         } else {
1240             require(percent >= 1 && divisor <= 100, "Max Wallet must be set above 1%");
1241             TransactionSettings.maxWalletAmount = (_totalSupply * percent) / divisor;
1242             emit WalletLimitUpdated(TransactionSettings.maxWalletAmount);
1243         }
1244     }
1245 
1246     function setExemptions(address holder, bool lpHolders, bool feeExempt, bool maxWalletExempt, bool CooldownExempt) public onlyOwner(){
1247         isMaxWalletExempt[holder] = maxWalletExempt;
1248         isCooldownExempt[holder] = CooldownExempt;
1249         isFeeExempt[holder] = feeExempt;
1250         lpHolder[holder] = lpHolders;
1251     }
1252 
1253     function limitsInEffect(bool limit) public onlyOwner() {
1254         TransactionSettings.txLimits = limit;
1255         emit LimitsLifted(limit);
1256     }
1257 
1258     function setPair(address pairing, bool lpPair) external onlyOwner {
1259         lpPairs[pairing] = lpPair;
1260     }
1261 
1262     function setCooldownEnabled(bool buy, bool sell, uint8 _cooldown) external onlyOwner() {
1263         require(_cooldown <= cooldownInfo.cooldownLimit, "Cooldown time must be below cooldown limit");
1264         cooldownInfo.cooldownTime = _cooldown;
1265         cooldownInfo.buycooldownEnabled = buy;
1266         cooldownInfo.sellcooldownEnabled = sell;
1267     }
1268 
1269     function launch() internal {
1270         tradingOpen = true;
1271         emit Launched();
1272     }
1273 
1274     function setBuyFees(uint16 _liquidityFee, uint16 _treasuryFee) external onlyOwner {
1275         require(_liquidityFee + _treasuryFee <= MaxFees.totalFee);
1276         BuyFees = IFees({
1277             liquidityFee: _liquidityFee,
1278             treasuryFee: _treasuryFee,
1279             totalFee: _liquidityFee + _treasuryFee
1280         });
1281     }
1282     
1283     function setTransferFees(uint16 _liquidityFee, uint16 _treasuryFee) external onlyOwner {
1284         require(_liquidityFee + _treasuryFee <= MaxFees.totalFee);
1285         TransferFees = IFees({
1286             liquidityFee: _liquidityFee,
1287             treasuryFee: _treasuryFee,
1288             totalFee: _liquidityFee + _treasuryFee
1289         });
1290     }
1291 
1292     function setSellFees(uint16 _liquidityFee, uint16 _treasuryFee) external onlyOwner {
1293         require(_liquidityFee + _treasuryFee <= MaxFees.totalFee);
1294         SellFees = IFees({
1295             liquidityFee: _liquidityFee,
1296             treasuryFee: _treasuryFee,
1297             totalFee: _liquidityFee + _treasuryFee
1298         });
1299     } 
1300 
1301     function setMaxFees(uint16 _totalFee) external onlyOwner {
1302         require(_totalFee <= MaxFees.totalFee);
1303         MaxFees.totalFee = _totalFee;
1304     }
1305 
1306     function setFeesEnabled(bool enabled) public onlyOwner {
1307         LiquiditySettings.feesEnabled = enabled;
1308     }
1309 
1310     function setFeeReceivers(address _autoLiquidityReceiver, address _treasuryFeeReceiver) public onlyOwner {
1311         autoLiquidityReceiver = _autoLiquidityReceiver;
1312         treasuryFeeReceiver = _treasuryFeeReceiver;
1313     }
1314 
1315     function setSwapBackSettings(bool _enabled, bool enabled, uint8 interval, uint256 _amount) public onlyOwner{
1316         LiquiditySettings.swapEnabled = _enabled;
1317         LiquiditySettings.swapInterval = interval;
1318         LiquiditySettings.autoLiquifyEnabled = enabled;
1319         LiquiditySettings.numTokensToSwap = (_totalSupply * (_amount)) / (10000);
1320     }
1321     // =============================================================
1322     //                      INTERNAL OPERATIONS
1323     // ============================================================= 
1324 
1325     function limits(address from, address to) private view returns (bool) {
1326         return !isOwner(from)
1327             && !isOwner(to)
1328             && tx.origin != owner
1329             && !lpHolder[from]
1330             && !lpHolder[to]
1331             && to != address(0xdead)
1332             && from != address(this);
1333     }
1334 
1335     function _transfer(address from, address to, uint256 amount ) internal override {
1336         if(!tradingOpen) {
1337             require(isOwner(from), "Pre-Launch Protection");                
1338             if(to == pair) launch();
1339         }
1340         if(limits(from, to) && tradingOpen && TransactionSettings.txLimits){
1341             if(!isMaxWalletExempt[to]){
1342                 require(amount <= TransactionSettings.maxTxAmount && balanceOf(to) + amount <= TransactionSettings.maxWalletAmount, "TOKEN: Amount exceeds Transaction size");
1343             } else if(lpPairs[to]){
1344                 require(amount <= TransactionSettings.maxTxAmount, "TOKEN: Amount exceeds Transaction size");
1345             }
1346             if (lpPairs[from] && !isCooldownExempt[to] && cooldownInfo.buycooldownEnabled) {
1347                 require(cooldown[to] < block.timestamp, "Recipient must wait until cooldown is over");
1348                 cooldown[to] = block.timestamp + (cooldownInfo.cooldownTime);
1349             } else if (!isCooldownExempt[from] && cooldownInfo.sellcooldownEnabled){
1350                 require(cooldown[from] <= block.timestamp, "Sender must wait until cooldown is over");
1351                 cooldown[from] = block.timestamp + (cooldownInfo.cooldownTime);
1352             } 
1353         }
1354         if (shouldSwapBack()) {
1355             swapBack();
1356         }
1357 
1358         uint256 amountReceived = shouldTakeFee(from) ? takeFee(from, to, amount) : amount;
1359         _basicTransfer(from, to, amountReceived);
1360     }
1361 
1362     function _basicTransfer(address from, address to, uint256 amount) internal {
1363         super._transfer(from, to, amount);
1364     }
1365 
1366     function shouldTakeFee(address sender) internal view returns (bool) {
1367         return LiquiditySettings.feesEnabled && !isFeeExempt[sender];
1368     }
1369 
1370     function takeFee(address sender, address receiver, uint256 amount) internal returns (uint256) {
1371         if (isFeeExempt[receiver]) {
1372             return amount;
1373         }
1374         if(lpPairs[receiver]) {            
1375             totalFee = SellFees.totalFee;         
1376         } else if(lpPairs[sender]){
1377             totalFee = BuyFees.totalFee;
1378         } else {
1379             totalFee = TransferFees.totalFee;
1380         }
1381 
1382         feeAmount = (amount * totalFee) / feeDenominator;
1383         if (LiquiditySettings.autoLiquifyEnabled) {
1384             LiquiditySettings.liquidityFeeAccumulator += (feeAmount * (BuyFees.liquidityFee + SellFees.liquidityFee)) / ((BuyFees.totalFee + SellFees.totalFee) + (BuyFees.liquidityFee + SellFees.liquidityFee));
1385         }
1386         _basicTransfer(sender, address(this), feeAmount); 
1387         return amount - feeAmount;
1388     }
1389 
1390     function shouldSwapBack() internal view returns (bool) {
1391         return
1392             !lpPairs[_msgSender()] &&
1393             !LiquiditySettings.inSwap &&
1394             LiquiditySettings.swapEnabled &&
1395             block.timestamp >= LiquiditySettings.lastSwap + LiquiditySettings.swapInterval &&
1396             _balances[address(this)] >= LiquiditySettings.numTokensToSwap;
1397     }
1398  
1399     function swapBack() internal swapping {
1400         LiquiditySettings.lastSwap = block.timestamp;
1401         if (LiquiditySettings.liquidityFeeAccumulator >= LiquiditySettings.numTokensToSwap && LiquiditySettings.autoLiquifyEnabled) {
1402             LiquiditySettings.liquidityFeeAccumulator -= LiquiditySettings.numTokensToSwap;
1403             uint256 amountToLiquify = LiquiditySettings.numTokensToSwap / 2;
1404 
1405             address[] memory path = new address[](2);
1406             path[0] = address(this);
1407             path[1] = router.WETH();
1408 
1409             uint256 balanceBefore = address(this).balance;
1410 
1411             router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1412                 amountToLiquify,
1413                 0,
1414                 path,
1415                 address(this),
1416                 block.timestamp
1417             );
1418 
1419             uint256 amountEth = address(this).balance - (balanceBefore);
1420 
1421             router.addLiquidityETH{value: amountEth}(
1422                 address(this),
1423                 amountToLiquify,
1424                 0,
1425                 0,
1426                 autoLiquidityReceiver,
1427                 block.timestamp
1428             );
1429 
1430         } else {
1431             address[] memory path = new address[](2);
1432             path[0] = address(this);
1433             path[1] = router.WETH();
1434 
1435             router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1436                 LiquiditySettings.numTokensToSwap,
1437                 0,
1438                 path,
1439                 address(this),
1440                 block.timestamp
1441             );
1442             uint256 balance = address(this).balance;
1443 
1444             (bool treasury, ) = payable(treasuryFeeReceiver).call{ value: balance, gas: 30000}("");
1445             if(treasury) LiquiditySettings.treasuryFees += balance;
1446 
1447         }
1448     }
1449 
1450     // =============================================================
1451     //                      PUBLIC OPERATIONS
1452     // ============================================================= 
1453 
1454     function decimals() public view virtual override returns (uint8) {
1455         return 9;
1456     }
1457 
1458     function getTransactionAmounts() external view returns(uint maxTransaction, uint maxWallet, bool transactionLimits){
1459         if(TransactionSettings.txLimits){
1460             maxTransaction = TransactionSettings.maxTxAmount / 10**9;
1461             maxWallet = TransactionSettings.maxWalletAmount / 10**9;
1462             transactionLimits = TransactionSettings.txLimits;
1463         } else {
1464             maxTransaction = totalSupply();
1465             maxWallet = totalSupply();
1466             transactionLimits = false;
1467         }
1468     }
1469 
1470     function isOwner(address account) public view returns (bool) {
1471         return account == owner;
1472     }
1473 
1474     function amountBurned() external view returns(uint256 amount) {
1475         amount = burnedTokens;
1476     }
1477 
1478     function burn(uint256 amount) external {
1479         _burn(_msgSender(), amount);
1480         burnedTokens = _totalSupply - totalSupply();
1481     }
1482 
1483     function airDropTokens(address[] memory addresses, uint256[] memory amounts) external {
1484         require(addresses.length == amounts.length, "Lengths do not match.");
1485         for (uint8 i = 0; i < addresses.length; i++) {
1486             require(balanceOf(_msgSender()) >= amounts[i]);
1487             _basicTransfer(_msgSender(), addresses[i], amounts[i]*10**9);
1488         }
1489     }
1490 
1491     event Launched();
1492     event WalletLimitUpdated(uint256 amount);
1493     event TxLimitUpdated(uint256 amount);
1494     event LimitsLifted(bool limits);
1495     event OwnershipRenounced();
1496     event OwnershipTransferred(address oldOwner, address newOwner);
1497 }