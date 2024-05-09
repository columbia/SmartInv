1 //SPDX-License-Identifier: Unlicensed
2 pragma solidity >=0.7.0 <0.9.0;
3 /**
4     Fuck the feds, fuck inflated interest rates, we will soar while their plans crash.
5 
6     Fuck you, we're mooning.
7 
8     Sound like a good plan to you?
9 
10     This is クラッシュ (Kurasshu)
11 
12     Telegram: https://t.me/KurasshuEntryPortal
13 
14     Twitter: https://twitter.com/KurasshuEth
15 
16     Website: https://kurasshu.com/
17 
18     Taxes? None to speak of. We’re not the enemy, they are
19 */
20 abstract contract Context {
21     function _msgSender() internal view returns (address payable) {
22         return payable(msg.sender);
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 /**
32  * @dev Collection of functions related to the address type
33  */
34 library Address {
35     /**
36      * @dev Returns true if `account` is a contract.
37      *
38      * [IMPORTANT]
39      * ====
40      * It is unsafe to assume that an address for which this function returns
41      * false is an externally-owned account (EOA) and not a contract.
42      *
43      * Among others, `isContract` will return false for the following
44      * types of addresses:
45      *
46      *  - an externally-owned account
47      *  - a contract in construction
48      *  - an address where a contract will be created
49      *  - an address where a contract lived, but was destroyed
50      * ====
51      *
52      * [IMPORTANT]
53      * ====
54      * You shouldn't rely on `isContract` to protect against flash loan attacks!
55      *
56      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
57      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
58      * constructor.
59      * ====
60      */
61     function isContract(address account) internal view returns (bool) {
62         // This method relies on extcodesize/address.code.length, which returns 0
63         // for contracts in construction, since the code is only stored at the end
64         // of the constructor execution.
65 
66         return account.code.length > 0;
67     }
68 
69     /**
70      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
71      * `recipient`, forwarding all available gas and reverting on errors.
72      *
73      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
74      * of certain opcodes, possibly making contracts go over the 2300 gas limit
75      * imposed by `transfer`, making them unable to receive funds via
76      * `transfer`. {sendValue} removes this limitation.
77      *
78      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
79      *
80      * IMPORTANT: because control is transferred to `recipient`, care must be
81      * taken to not create reentrancy vulnerabilities. Consider using
82      * {ReentrancyGuard} or the
83      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
84      */
85     function sendValue(address payable recipient, uint256 amount) internal {
86         require(address(this).balance >= amount, "Address: insufficient balance");
87 
88         (bool success, ) = recipient.call{value: amount}("");
89         require(success, "Address: unable to send value, recipient may have reverted");
90     }
91 
92     /**
93      * @dev Performs a Solidity function call using a low level `call`. A
94      * plain `call` is an unsafe replacement for a function call: use this
95      * function instead.
96      *
97      * If `target` reverts with a revert reason, it is bubbled up by this
98      * function (like regular Solidity function calls).
99      *
100      * Returns the raw returned data. To convert to the expected return value,
101      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
102      *
103      * Requirements:
104      *
105      * - `target` must be a contract.
106      * - calling `target` with `data` must not revert.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
112     }
113 
114     /**
115      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
116      * `errorMessage` as a fallback revert reason when `target` reverts.
117      *
118      * _Available since v3.1._
119      */
120     function functionCall(
121         address target,
122         bytes memory data,
123         string memory errorMessage
124     ) internal returns (bytes memory) {
125         return functionCallWithValue(target, data, 0, errorMessage);
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
130      * but also transferring `value` wei to `target`.
131      *
132      * Requirements:
133      *
134      * - the calling contract must have an ETH balance of at least `value`.
135      * - the called Solidity function must be `payable`.
136      *
137      * _Available since v3.1._
138      */
139     function functionCallWithValue(
140         address target,
141         bytes memory data,
142         uint256 value
143     ) internal returns (bytes memory) {
144         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
149      * with `errorMessage` as a fallback revert reason when `target` reverts.
150      *
151      * _Available since v3.1._
152      */
153     function functionCallWithValue(
154         address target,
155         bytes memory data,
156         uint256 value,
157         string memory errorMessage
158     ) internal returns (bytes memory) {
159         require(address(this).balance >= value, "Address: insufficient balance for call");
160         (bool success, bytes memory returndata) = target.call{value: value}(data);
161         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
166      * but performing a static call.
167      *
168      * _Available since v3.3._
169      */
170     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
171         return functionStaticCall(target, data, "Address: low-level static call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
176      * but performing a static call.
177      *
178      * _Available since v3.3._
179      */
180     function functionStaticCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal view returns (bytes memory) {
185         (bool success, bytes memory returndata) = target.staticcall(data);
186         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
191      * but performing a delegate call.
192      *
193      * _Available since v3.4._
194      */
195     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
196         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
201      * but performing a delegate call.
202      *
203      * _Available since v3.4._
204      */
205     function functionDelegateCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         (bool success, bytes memory returndata) = target.delegatecall(data);
211         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
216      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
217      *
218      * _Available since v4.8._
219      */
220     function verifyCallResultFromTarget(
221         address target,
222         bool success,
223         bytes memory returndata,
224         string memory errorMessage
225     ) internal view returns (bytes memory) {
226         if (success) {
227             if (returndata.length == 0) {
228                 // only check isContract if the call was successful and the return data is empty
229                 // otherwise we already know that it was a contract
230                 require(isContract(target), "Address: call to non-contract");
231             }
232             return returndata;
233         } else {
234             _revert(returndata, errorMessage);
235         }
236     }
237 
238     /**
239      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
240      * revert reason or using the provided one.
241      *
242      * _Available since v4.3._
243      */
244     function verifyCallResult(
245         bool success,
246         bytes memory returndata,
247         string memory errorMessage
248     ) internal pure returns (bytes memory) {
249         if (success) {
250             return returndata;
251         } else {
252             _revert(returndata, errorMessage);
253         }
254     }
255 
256     function _revert(bytes memory returndata, string memory errorMessage) private pure {
257         // Look for revert reason and bubble it up if present
258         if (returndata.length > 0) {
259             // The easiest way to bubble the revert reason is using memory via assembly
260             /// @solidity memory-safe-assembly
261             assembly {
262                 let returndata_size := mload(returndata)
263                 revert(add(32, returndata), returndata_size)
264             }
265         } else {
266             revert(errorMessage);
267         }
268     }
269 }
270 
271 // CAUTION
272 // This version of SafeMath should only be used with Solidity 0.8 or later,
273 // because it relies on the compiler's built in overflow checks.
274 
275 /**
276  * @dev Wrappers over Solidity's arithmetic operations.
277  *
278  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
279  * now has built in overflow checking.
280  */
281 library SafeMath {
282     /**
283      * @dev Returns the addition of two unsigned integers, with an overflow flag.
284      *
285      * _Available since v3.4._
286      */
287     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
288         unchecked {
289             uint256 c = a + b;
290             if (c < a) return (false, 0);
291             return (true, c);
292         }
293     }
294 
295     /**
296      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
297      *
298      * _Available since v3.4._
299      */
300     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
301         unchecked {
302             if (b > a) return (false, 0);
303             return (true, a - b);
304         }
305     }
306 
307     /**
308      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
309      *
310      * _Available since v3.4._
311      */
312     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
313         unchecked {
314             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
315             // benefit is lost if 'b' is also tested.
316             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
317             if (a == 0) return (true, 0);
318             uint256 c = a * b;
319             if (c / a != b) return (false, 0);
320             return (true, c);
321         }
322     }
323 
324     /**
325      * @dev Returns the division of two unsigned integers, with a division by zero flag.
326      *
327      * _Available since v3.4._
328      */
329     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
330         unchecked {
331             if (b == 0) return (false, 0);
332             return (true, a / b);
333         }
334     }
335 
336     /**
337      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
338      *
339      * _Available since v3.4._
340      */
341     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
342         unchecked {
343             if (b == 0) return (false, 0);
344             return (true, a % b);
345         }
346     }
347 
348     /**
349      * @dev Returns the addition of two unsigned integers, reverting on
350      * overflow.
351      *
352      * Counterpart to Solidity's `+` operator.
353      *
354      * Requirements:
355      *
356      * - Addition cannot overflow.
357      */
358     function add(uint256 a, uint256 b) internal pure returns (uint256) {
359         return a + b;
360     }
361 
362     /**
363      * @dev Returns the subtraction of two unsigned integers, reverting on
364      * overflow (when the result is negative).
365      *
366      * Counterpart to Solidity's `-` operator.
367      *
368      * Requirements:
369      *
370      * - Subtraction cannot overflow.
371      */
372     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
373         return a - b;
374     }
375 
376     /**
377      * @dev Returns the multiplication of two unsigned integers, reverting on
378      * overflow.
379      *
380      * Counterpart to Solidity's `*` operator.
381      *
382      * Requirements:
383      *
384      * - Multiplication cannot overflow.
385      */
386     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
387         return a * b;
388     }
389 
390     /**
391      * @dev Returns the integer division of two unsigned integers, reverting on
392      * division by zero. The result is rounded towards zero.
393      *
394      * Counterpart to Solidity's `/` operator.
395      *
396      * Requirements:
397      *
398      * - The divisor cannot be zero.
399      */
400     function div(uint256 a, uint256 b) internal pure returns (uint256) {
401         return a / b;
402     }
403 
404     /**
405      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
406      * reverting when dividing by zero.
407      *
408      * Counterpart to Solidity's `%` operator. This function uses a `revert`
409      * opcode (which leaves remaining gas untouched) while Solidity uses an
410      * invalid opcode to revert (consuming all remaining gas).
411      *
412      * Requirements:
413      *
414      * - The divisor cannot be zero.
415      */
416     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
417         return a % b;
418     }
419 
420     /**
421      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
422      * overflow (when the result is negative).
423      *
424      * CAUTION: This function is deprecated because it requires allocating memory for the error
425      * message unnecessarily. For custom revert reasons use {trySub}.
426      *
427      * Counterpart to Solidity's `-` operator.
428      *
429      * Requirements:
430      *
431      * - Subtraction cannot overflow.
432      */
433     function sub(
434         uint256 a,
435         uint256 b,
436         string memory errorMessage
437     ) internal pure returns (uint256) {
438         unchecked {
439             require(b <= a, errorMessage);
440             return a - b;
441         }
442     }
443 
444     /**
445      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
446      * division by zero. The result is rounded towards zero.
447      *
448      * Counterpart to Solidity's `/` operator. Note: this function uses a
449      * `revert` opcode (which leaves remaining gas untouched) while Solidity
450      * uses an invalid opcode to revert (consuming all remaining gas).
451      *
452      * Requirements:
453      *
454      * - The divisor cannot be zero.
455      */
456     function div(
457         uint256 a,
458         uint256 b,
459         string memory errorMessage
460     ) internal pure returns (uint256) {
461         unchecked {
462             require(b > 0, errorMessage);
463             return a / b;
464         }
465     }
466 
467     /**
468      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
469      * reverting with custom message when dividing by zero.
470      *
471      * CAUTION: This function is deprecated because it requires allocating memory for the error
472      * message unnecessarily. For custom revert reasons use {tryMod}.
473      *
474      * Counterpart to Solidity's `%` operator. This function uses a `revert`
475      * opcode (which leaves remaining gas untouched) while Solidity uses an
476      * invalid opcode to revert (consuming all remaining gas).
477      *
478      * Requirements:
479      *
480      * - The divisor cannot be zero.
481      */
482     function mod(
483         uint256 a,
484         uint256 b,
485         string memory errorMessage
486     ) internal pure returns (uint256) {
487         unchecked {
488             require(b > 0, errorMessage);
489             return a % b;
490         }
491     }
492 }
493 
494 interface IERC20 {
495     function totalSupply() external view returns (uint256);
496     function decimals() external view returns (uint8);
497     function symbol() external view returns (string memory);
498     function name() external view returns (string memory);
499     function balanceOf(address account) external view returns (uint256);
500     function transfer(address recipient, uint256 amount) external returns (bool);
501     function allowance(address _owner, address spender) external view returns (uint256);
502     function approve(address spender, uint256 amount) external returns (bool);
503     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
504     event Transfer(address indexed from, address indexed to, uint256 value);
505     event Approval(address indexed owner, address indexed spender, uint256 value);
506 }
507 
508 /**
509  * @dev Implementation of the {IERC20} interface.
510  *
511  * This implementation is agnostic to the way tokens are created. This means
512  * that a supply mechanism has to be added in a derived contract using {_mint}.
513  * For a generic mechanism see {ERC20PresetMinterPauser}.
514  *
515  * TIP: For a detailed writeup see our guide
516  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
517  * to implement supply mechanisms].
518  *
519  * We have followed general OpenZeppelin Contracts guidelines: functions revert
520  * instead returning `false` on failure. This behavior is nonetheless
521  * conventional and does not conflict with the expectations of ERC20
522  * applications.
523  *
524  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
525  * This allows applications to reconstruct the allowance for all accounts just
526  * by listening to said events. Other implementations of the EIP may not emit
527  * these events, as it isn't required by the specification.
528  *
529  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
530  * functions have been added to mitigate the well-known issues around setting
531  * allowances. See {IERC20-approve}.
532  */
533 contract ERC20 is Context, IERC20 {
534     mapping(address => uint256) public _balances;
535 
536     mapping(address => mapping(address => uint256)) private _allowances;
537 
538     uint256 private _totalSupply;
539 
540     string private _name;
541     string private _symbol;
542 
543     /**
544      * @dev Sets the values for {name} and {symbol}.
545      *
546      * The default value of {decimals} is 18. To select a different value for
547      * {decimals} you should overload it.
548      *
549      * All two of these values are immutable: they can only be set once during
550      * construction.
551      */
552     constructor(string memory name_, string memory symbol_) {
553         _name = name_;
554         _symbol = symbol_;
555     }
556 
557     /**
558      * @dev Returns the name of the token.
559      */
560     function name() public view virtual override returns (string memory) {
561         return _name;
562     }
563 
564     /**
565      * @dev Returns the symbol of the token, usually a shorter version of the
566      * name.
567      */
568     function symbol() public view virtual override returns (string memory) {
569         return _symbol;
570     }
571 
572     /**
573      * @dev Returns the number of decimals used to get its user representation.
574      * For example, if `decimals` equals `2`, a balance of `505` tokens should
575      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
576      *
577      * Tokens usually opt for a value of 18, imitating the relationship between
578      * Ether and Wei. This is the value {ERC20} uses, unless this function is
579      * overridden;
580      *
581      * NOTE: This information is only used for _display_ purposes: it in
582      * no way affects any of the arithmetic of the contract, including
583      * {IERC20-balanceOf} and {IERC20-transfer}.
584      */
585     function decimals() public view virtual override returns (uint8) {
586         return 18;
587     }
588 
589     /**
590      * @dev See {IERC20-totalSupply}.
591      */
592     function totalSupply() public view virtual override returns (uint256) {
593         return _totalSupply;
594     }
595 
596     /**
597      * @dev See {IERC20-balanceOf}.
598      */
599     function balanceOf(address account) public view virtual override returns (uint256) {
600         return _balances[account];
601     }
602 
603     /**
604      * @dev See {IERC20-transfer}.
605      *
606      * Requirements:
607      *
608      * - `to` cannot be the zero address.
609      * - the caller must have a balance of at least `amount`.
610      */
611     function transfer(address to, uint256 amount) public virtual override returns (bool) {
612         address owner = _msgSender();
613         _transfer(owner, to, amount);
614         return true;
615     }
616 
617     /**
618      * @dev See {IERC20-allowance}.
619      */
620     function allowance(address owner, address spender) public view virtual override returns (uint256) {
621         return _allowances[owner][spender];
622     }
623 
624     /**
625      * @dev See {IERC20-approve}.
626      *
627      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
628      * `transferFrom`. This is semantically equivalent to an infinite approval.
629      *
630      * Requirements:
631      *
632      * - `spender` cannot be the zero address.
633      */
634     function approve(address spender, uint256 amount) public virtual override returns (bool) {
635         address owner = _msgSender();
636         _approve(owner, spender, amount);
637         return true;
638     }
639 
640     /**
641      * @dev See {IERC20-transferFrom}.
642      *
643      * Emits an {Approval} event indicating the updated allowance. This is not
644      * required by the EIP. See the note at the beginning of {ERC20}.
645      *
646      * NOTE: Does not update the allowance if the current allowance
647      * is the maximum `uint256`.
648      *
649      * Requirements:
650      *
651      * - `from` and `to` cannot be the zero address.
652      * - `from` must have a balance of at least `amount`.
653      * - the caller must have allowance for ``from``'s tokens of at least
654      * `amount`.
655      */
656     function transferFrom(
657         address from,
658         address to,
659         uint256 amount
660     ) public virtual override returns (bool) {
661         address spender = _msgSender();
662         _spendAllowance(from, spender, amount);
663         _transfer(from, to, amount);
664         return true;
665     }
666 
667     /**
668      * @dev Atomically increases the allowance granted to `spender` by the caller.
669      *
670      * This is an alternative to {approve} that can be used as a mitigation for
671      * problems described in {IERC20-approve}.
672      *
673      * Emits an {Approval} event indicating the updated allowance.
674      *
675      * Requirements:
676      *
677      * - `spender` cannot be the zero address.
678      */
679     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
680         address owner = _msgSender();
681         _approve(owner, spender, allowance(owner, spender) + addedValue);
682         return true;
683     }
684 
685     /**
686      * @dev Atomically decreases the allowance granted to `spender` by the caller.
687      *
688      * This is an alternative to {approve} that can be used as a mitigation for
689      * problems described in {IERC20-approve}.
690      *
691      * Emits an {Approval} event indicating the updated allowance.
692      *
693      * Requirements:
694      *
695      * - `spender` cannot be the zero address.
696      * - `spender` must have allowance for the caller of at least
697      * `subtractedValue`.
698      */
699     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
700         address owner = _msgSender();
701         uint256 currentAllowance = allowance(owner, spender);
702         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
703         unchecked {
704             _approve(owner, spender, currentAllowance - subtractedValue);
705         }
706 
707         return true;
708     }
709 
710     /**
711      * @dev Moves `amount` of tokens from `from` to `to`.
712      *
713      * This internal function is equivalent to {transfer}, and can be used to
714      * e.g. implement automatic token fees, slashing mechanisms, etc.
715      *
716      * Emits a {Transfer} event.
717      *
718      * Requirements:
719      *
720      * - `from` cannot be the zero address.
721      * - `to` cannot be the zero address.
722      * - `from` must have a balance of at least `amount`.
723      */
724     function _transfer(
725         address from,
726         address to,
727         uint256 amount
728     ) internal virtual {
729         require(from != address(0), "ERC20: transfer from the zero address");
730         require(to != address(0), "ERC20: transfer to the zero address");
731 
732         _beforeTokenTransfer(from, to, amount);
733 
734         uint256 fromBalance = _balances[from];
735         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
736         unchecked {
737             _balances[from] = fromBalance - amount;
738             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
739             // decrementing then incrementing.
740             _balances[to] += amount;
741         }
742 
743         emit Transfer(from, to, amount);
744 
745         _afterTokenTransfer(from, to, amount);
746     }
747 
748     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
749      * the total supply.
750      *
751      * Emits a {Transfer} event with `from` set to the zero address.
752      *
753      * Requirements:
754      *
755      * - `account` cannot be the zero address.
756      */
757     function _mint(address account, uint256 amount) internal virtual {
758         require(account != address(0), "ERC20: mint to the zero address");
759 
760         _beforeTokenTransfer(address(0), account, amount);
761 
762         _totalSupply += amount;
763         unchecked {
764             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
765             _balances[account] += amount;
766         }
767         emit Transfer(address(0), account, amount);
768 
769         _afterTokenTransfer(address(0), account, amount);
770     }
771 
772     /**
773      * @dev Destroys `amount` tokens from `account`, reducing the
774      * total supply.
775      *
776      * Emits a {Transfer} event with `to` set to the zero address.
777      *
778      * Requirements:
779      *
780      * - `account` cannot be the zero address.
781      * - `account` must have at least `amount` tokens.
782      */
783     function _burn(address account, uint256 amount) internal virtual {
784         require(account != address(0), "ERC20: burn from the zero address");
785 
786         _beforeTokenTransfer(account, address(0), amount);
787 
788         uint256 accountBalance = _balances[account];
789         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
790         unchecked {
791             _balances[account] = accountBalance - amount;
792             // Overflow not possible: amount <= accountBalance <= totalSupply.
793             _totalSupply -= amount;
794         }
795 
796         emit Transfer(account, address(0), amount);
797 
798         _afterTokenTransfer(account, address(0), amount);
799     }
800 
801     /**
802      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
803      *
804      * This internal function is equivalent to `approve`, and can be used to
805      * e.g. set automatic allowances for certain subsystems, etc.
806      *
807      * Emits an {Approval} event.
808      *
809      * Requirements:
810      *
811      * - `owner` cannot be the zero address.
812      * - `spender` cannot be the zero address.
813      */
814     function _approve(
815         address owner,
816         address spender,
817         uint256 amount
818     ) internal virtual {
819         require(owner != address(0), "ERC20: approve from the zero address");
820         require(spender != address(0), "ERC20: approve to the zero address");
821 
822         _allowances[owner][spender] = amount;
823         emit Approval(owner, spender, amount);
824     }
825 
826     /**
827      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
828      *
829      * Does not update the allowance amount in case of infinite allowance.
830      * Revert if not enough allowance is available.
831      *
832      * Might emit an {Approval} event.
833      */
834     function _spendAllowance(
835         address owner,
836         address spender,
837         uint256 amount
838     ) internal virtual {
839         uint256 currentAllowance = allowance(owner, spender);
840         if (currentAllowance != type(uint256).max) {
841             require(currentAllowance >= amount, "ERC20: insufficient allowance");
842             unchecked {
843                 _approve(owner, spender, currentAllowance - amount);
844             }
845         }
846     }
847 
848     /**
849      * @dev Hook that is called before any transfer of tokens. This includes
850      * minting and burning.
851      *
852      * Calling conditions:
853      *
854      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
855      * will be transferred to `to`.
856      * - when `from` is zero, `amount` tokens will be minted for `to`.
857      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
858      * - `from` and `to` are never both zero.
859      *
860      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
861      */
862     function _beforeTokenTransfer(
863         address from,
864         address to,
865         uint256 amount
866     ) internal virtual {}
867 
868     /**
869      * @dev Hook that is called after any transfer of tokens. This includes
870      * minting and burning.
871      *
872      * Calling conditions:
873      *
874      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
875      * has been transferred to `to`.
876      * - when `from` is zero, `amount` tokens have been minted for `to`.
877      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
878      * - `from` and `to` are never both zero.
879      *
880      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
881      */
882     function _afterTokenTransfer(
883         address from,
884         address to,
885         uint256 amount
886     ) internal virtual {}
887 }
888 
889 interface IUniswapV2Factory {
890     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
891 
892     function feeTo() external view returns (address);
893     function feeToSetter() external view returns (address);
894 
895     function getPair(address tokenA, address tokenB) external view returns (address pair);
896     function allPairs(uint) external view returns (address pair);
897     function allPairsLength() external view returns (uint);
898 
899     function createPair(address tokenA, address tokenB) external returns (address pair);
900 
901     function setFeeTo(address) external;
902     function setFeeToSetter(address) external;
903 }
904 
905 interface IUniswapV2Pair {
906     event Approval(address indexed owner, address indexed spender, uint value);
907     event Transfer(address indexed from, address indexed to, uint value);
908 
909     function name() external pure returns (string memory);
910     function symbol() external pure returns (string memory);
911     function decimals() external pure returns (uint8);
912     function totalSupply() external view returns (uint);
913     function balanceOf(address owner) external view returns (uint);
914     function allowance(address owner, address spender) external view returns (uint);
915 
916     function approve(address spender, uint value) external returns (bool);
917     function transfer(address to, uint value) external returns (bool);
918     function transferFrom(address from, address to, uint value) external returns (bool);
919 
920     function DOMAIN_SEPARATOR() external view returns (bytes32);
921     function PERMIT_TYPEHASH() external pure returns (bytes32);
922     function nonces(address owner) external view returns (uint);
923 
924     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
925 
926     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
927     event Swap(
928         address indexed sender,
929         uint amount0In,
930         uint amount1In,
931         uint amount0Out,
932         uint amount1Out,
933         address indexed to
934     );
935     event Sync(uint112 reserve0, uint112 reserve1);
936 
937     function MINIMUM_LIQUIDITY() external pure returns (uint);
938     function factory() external view returns (address);
939     function token0() external view returns (address);
940     function token1() external view returns (address);
941     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
942     function price0CumulativeLast() external view returns (uint);
943     function price1CumulativeLast() external view returns (uint);
944     function kLast() external view returns (uint);
945 
946     function burn(address to) external returns (uint amount0, uint amount1);
947     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
948     function skim(address to) external;
949     function sync() external;
950 
951     function initialize(address, address) external;
952 }
953 
954 interface IUniswapV2Router01 {
955     function factory() external pure returns (address);
956     function WETH() external pure returns (address);
957 
958     function addLiquidity(
959         address tokenA,
960         address tokenB,
961         uint amountADesired,
962         uint amountBDesired,
963         uint amountAMin,
964         uint amountBMin,
965         address to,
966         uint deadline
967     ) external returns (uint amountA, uint amountB, uint liquidity);
968     function addLiquidityETH(
969         address token,
970         uint amountTokenDesired,
971         uint amountTokenMin,
972         uint amountETHMin,
973         address to,
974         uint deadline
975     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
976     function removeLiquidity(
977         address tokenA,
978         address tokenB,
979         uint liquidity,
980         uint amountAMin,
981         uint amountBMin,
982         address to,
983         uint deadline
984     ) external returns (uint amountA, uint amountB);
985     function removeLiquidityETH(
986         address token,
987         uint liquidity,
988         uint amountTokenMin,
989         uint amountETHMin,
990         address to,
991         uint deadline
992     ) external returns (uint amountToken, uint amountETH);
993     function removeLiquidityWithPermit(
994         address tokenA,
995         address tokenB,
996         uint liquidity,
997         uint amountAMin,
998         uint amountBMin,
999         address to,
1000         uint deadline,
1001         bool approveMax, uint8 v, bytes32 r, bytes32 s
1002     ) external returns (uint amountA, uint amountB);
1003     function removeLiquidityETHWithPermit(
1004         address token,
1005         uint liquidity,
1006         uint amountTokenMin,
1007         uint amountETHMin,
1008         address to,
1009         uint deadline,
1010         bool approveMax, uint8 v, bytes32 r, bytes32 s
1011     ) external returns (uint amountToken, uint amountETH);
1012     function swapExactTokensForTokens(
1013         uint amountIn,
1014         uint amountOutMin,
1015         address[] calldata path,
1016         address to,
1017         uint deadline
1018     ) external returns (uint[] memory amounts);
1019     function swapTokensForExactTokens(
1020         uint amountOut,
1021         uint amountInMax,
1022         address[] calldata path,
1023         address to,
1024         uint deadline
1025     ) external returns (uint[] memory amounts);
1026     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1027         external
1028         payable
1029         returns (uint[] memory amounts);
1030     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1031         external
1032         returns (uint[] memory amounts);
1033     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1034         external
1035         returns (uint[] memory amounts);
1036     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1037         external
1038         payable
1039         returns (uint[] memory amounts);
1040 
1041     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1042     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1043     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1044     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1045     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1046 }
1047 
1048 interface IUniswapV2Router02 is IUniswapV2Router01 {
1049     function removeLiquidityETHSupportingFeeOnTransferTokens(
1050         address token,
1051         uint liquidity,
1052         uint amountTokenMin,
1053         uint amountETHMin,
1054         address to,
1055         uint deadline
1056     ) external returns (uint amountETH);
1057     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1058         address token,
1059         uint liquidity,
1060         uint amountTokenMin,
1061         uint amountETHMin,
1062         address to,
1063         uint deadline,
1064         bool approveMax, uint8 v, bytes32 r, bytes32 s
1065     ) external returns (uint amountETH);
1066 
1067     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1068         uint amountIn,
1069         uint amountOutMin,
1070         address[] calldata path,
1071         address to,
1072         uint deadline
1073     ) external;
1074     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1075         uint amountOutMin,
1076         address[] calldata path,
1077         address to,
1078         uint deadline
1079     ) external payable;
1080     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1081         uint amountIn,
1082         uint amountOutMin,
1083         address[] calldata path,
1084         address to,
1085         uint deadline
1086     ) external;
1087 }
1088 
1089 contract Token is ERC20 {
1090     using Address for address;
1091 
1092     mapping(address => bool) public banned;
1093     mapping(address => uint256) cooldown;
1094     mapping(address => bool) isCooldownExempt;
1095     mapping(address => bool) isFeeExempt;
1096     mapping(address => bool) isMaxWalletExempt;
1097     mapping(address => bool) lpHolder;
1098     mapping(address => bool) lpPairs;
1099 
1100     address public owner;
1101     address public autoLiquidityReceiver;
1102     address public treasuryFeeReceiver;
1103     address public pair;
1104 
1105     uint256 _totalSupply = 70_000_000 * (10**9); // total supply amount
1106     uint256 totalFee;
1107     uint256 feeAmount;
1108     uint256 burnedTokens;
1109     uint feeDenominator = 1000;
1110     struct IFees {
1111         uint16 liquidityFee;
1112         uint16 treasuryFee;
1113         uint16 totalFee;
1114     }
1115     struct ICooldown {
1116         bool buycooldownEnabled;
1117         bool sellcooldownEnabled;
1118         uint8 cooldownLimit;
1119         uint8 cooldownTime;
1120     }
1121     struct ITransactionSettings {
1122         uint256 maxTxAmount;
1123         uint256 maxWalletAmount;
1124         bool txLimits;
1125     }     
1126     struct ILiquiditySettings {
1127         uint256 liquidityFeeAccumulator;
1128         uint256 treasuryFees;
1129         uint256 numTokensToSwap;
1130         uint256 lastSwap;
1131         uint8 swapInterval;
1132         bool swapEnabled;
1133         bool inSwap;
1134         bool feesEnabled;
1135         bool autoLiquifyEnabled;
1136     } 
1137     struct ILaunch {
1138         uint256 launchBlock;
1139         uint8 sniperBlocks;
1140         uint snipersCaught;
1141         bool tradingOpen;
1142         bool launchProtection;
1143     }
1144     ICooldown public cooldownInfo;
1145     IFees public BuyFees;
1146     IFees public MaxFees;
1147     IFees public SellFees;
1148     IFees public TransferFees;
1149     ILaunch public Launch;
1150     ILiquiditySettings public LiquiditySettings;
1151     ITransactionSettings TransactionSettings;
1152     IUniswapV2Router02 public router;
1153     modifier onlyOwner() {
1154         require(isOwner(msg.sender), "You are not the owner");
1155         _;
1156     }
1157     modifier swapping() {
1158         LiquiditySettings.inSwap = true;
1159         _;
1160         LiquiditySettings.inSwap = false;
1161     }
1162     constructor(string memory name, string memory symbol, address lpReceiver, address treasuryReceiver) ERC20(name, symbol) {
1163         owner = _msgSender();
1164         setFeeReceivers(lpReceiver, treasuryReceiver);
1165         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1166         pair = IUniswapV2Factory(router.factory()).createPair(router.WETH(), address(this));
1167         lpHolder[_msgSender()] = true;
1168         lpPairs[pair] = true;
1169 
1170         _approve(address(this), address(router), type(uint256).max);
1171         _approve(_msgSender(), address(router), type(uint256).max);
1172 
1173         isMaxWalletExempt[_msgSender()] = true;
1174         isMaxWalletExempt[address(this)] = true;
1175         isMaxWalletExempt[pair] = true;
1176 
1177         isFeeExempt[address(this)] = true;
1178         isFeeExempt[_msgSender()] = true;
1179 
1180         isCooldownExempt[_msgSender()] = true;
1181         isCooldownExempt[pair] = true;
1182         isCooldownExempt[address(this)] = true;
1183         isCooldownExempt[address(router)] = true;
1184 
1185         cooldownInfo.buycooldownEnabled = true;
1186         cooldownInfo.sellcooldownEnabled = true;
1187         cooldownInfo.cooldownTime = 30; // one transaction every 30 seconds per address
1188         cooldownInfo.cooldownLimit = 60; // cooldown cannot go over 60 seconds
1189 
1190         TransactionSettings.txLimits = true; // limits in effect
1191 
1192         TransactionSettings.maxTxAmount = (_totalSupply * 1) / (100); // 1% max transaction
1193         TransactionSettings.maxWalletAmount = (_totalSupply * 2) / 100; // 2% max wallet
1194 
1195 
1196         BuyFees = IFees({
1197             liquidityFee: 20,
1198             treasuryFee: 50,
1199             totalFee: 20 + 50 // 7%
1200         });
1201         SellFees = IFees({
1202             liquidityFee: 20,
1203             treasuryFee: 50,
1204             totalFee: 20 + 50 // 7%
1205         });    
1206         MaxFees.totalFee = 100; // 20% roundtrip
1207 
1208         LiquiditySettings.swapEnabled = true;
1209         LiquiditySettings.autoLiquifyEnabled = true;
1210         LiquiditySettings.swapInterval = 5;
1211         LiquiditySettings.numTokensToSwap = (_totalSupply * (10)) / (10000);
1212         LiquiditySettings.feesEnabled = true;
1213 
1214         _mint(_msgSender(), _totalSupply);
1215     }
1216     
1217     receive() external payable {}
1218 
1219     // =============================================================
1220     //                      OWNERSHIP OPERATIONS
1221     // =============================================================   
1222     /**
1223      * @dev Leaves the contract without owner. It will not be possible to call
1224      * `onlyOwner` functions anymore. Can only be called by the current owner.
1225      *
1226      * NOTE: Renouncing ownership will leave the contract without an owner,
1227      * thereby removing any functionality that is only available to the owner.
1228      */
1229     function renounceOwnership(bool keepLimits) public onlyOwner {
1230         emit OwnershipRenounced();
1231         setExemptions(owner, false, false, false, false);
1232         limitsInEffect(keepLimits);
1233         owner = address(0);
1234     }
1235 
1236     /**
1237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1238      * Can only be called by the current owner.
1239      */
1240     function transferOwnership(address newOwner) public onlyOwner {
1241         require(newOwner != address(0), "Ownable: new owner is the zero address, use renounceOwnership Function");
1242         emit OwnershipTransferred(owner, newOwner);
1243 
1244         if(balanceOf(owner) > 0) _basicTransfer(owner, newOwner, balanceOf(owner));
1245         setExemptions(owner, false, false, false, false);
1246         setExemptions(newOwner, true, true, true, false);
1247 
1248         owner = newOwner;
1249     }
1250 
1251     // =============================================================
1252     //                      ADMIN OPERATIONS
1253     // =============================================================  
1254 
1255     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
1256         require(amountPercentage <= 100);
1257         uint256 amountEth = address(this).balance;
1258         payable(treasuryFeeReceiver).transfer(
1259             (amountEth * amountPercentage) / 100
1260         );
1261         LiquiditySettings.treasuryFees += amountEth * amountPercentage;
1262     }
1263 
1264     function clearStuckTokens(address _token, address _to) external onlyOwner returns (bool _sent) {
1265         require(_token != address(0) && _token != address(this));
1266         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1267         _sent = IERC20(_token).transfer(_to, _contractBalance);
1268     }
1269 
1270     function setWalletLimits(uint256 percent, uint256 divisor, bool txOrWallet) external onlyOwner() {
1271         if(txOrWallet){
1272             require(percent >= 1 && divisor <= 1000, "Max Transaction must be set above .1%");
1273             TransactionSettings.maxTxAmount = (_totalSupply * percent) / (divisor);
1274             emit TxLimitUpdated(TransactionSettings.maxTxAmount);
1275         } else {
1276             require(percent >= 1 && divisor <= 100, "Max Wallet must be set above 1%");
1277             TransactionSettings.maxWalletAmount = (_totalSupply * percent) / divisor;
1278             emit WalletLimitUpdated(TransactionSettings.maxWalletAmount);
1279         }
1280     }
1281 
1282     function setExemptions(address holder, bool lpHolders, bool feeExempt, bool maxWalletExempt, bool CooldownExempt) public onlyOwner(){
1283         isMaxWalletExempt[holder] = maxWalletExempt;
1284         isCooldownExempt[holder] = CooldownExempt;
1285         isFeeExempt[holder] = feeExempt;
1286         lpHolder[holder] = lpHolders;
1287     }
1288 
1289     function limitsInEffect(bool limit) public onlyOwner() {
1290         TransactionSettings.txLimits = limit;
1291         emit LimitsLifted(limit);
1292     }
1293 
1294     function setPair(address pairing, bool lpPair) external onlyOwner {
1295         lpPairs[pairing] = lpPair;
1296     }
1297 
1298     function setCooldownEnabled(bool buy, bool sell, uint8 _cooldown) external onlyOwner() {
1299         require(_cooldown <= cooldownInfo.cooldownLimit, "Cooldown time must be below cooldown limit");
1300         cooldownInfo.cooldownTime = _cooldown;
1301         cooldownInfo.buycooldownEnabled = buy;
1302         cooldownInfo.sellcooldownEnabled = sell;
1303     }
1304 
1305     function launch(uint8 sniperBlocks) internal {
1306         Launch.tradingOpen = true;
1307         Launch.launchBlock = block.number;
1308         Launch.sniperBlocks = sniperBlocks;
1309         Launch.launchProtection = true;
1310         emit Launched();
1311     }
1312 
1313     function setBuyFees(uint16 _liquidityFee, uint16 _treasuryFee) external onlyOwner {
1314         require(_liquidityFee + _treasuryFee <= MaxFees.totalFee);
1315         BuyFees = IFees({
1316             liquidityFee: _liquidityFee,
1317             treasuryFee: _treasuryFee,
1318             totalFee: _liquidityFee + _treasuryFee
1319         });
1320     }
1321     
1322     function setTransferFees(uint16 _liquidityFee, uint16 _treasuryFee) external onlyOwner {
1323         require(_liquidityFee + _treasuryFee <= MaxFees.totalFee);
1324         TransferFees = IFees({
1325             liquidityFee: _liquidityFee,
1326             treasuryFee: _treasuryFee,
1327             totalFee: _liquidityFee + _treasuryFee
1328         });
1329     }
1330 
1331     function setSellFees(uint16 _liquidityFee, uint16 _treasuryFee) external onlyOwner {
1332         require(_liquidityFee + _treasuryFee <= MaxFees.totalFee);
1333         SellFees = IFees({
1334             liquidityFee: _liquidityFee,
1335             treasuryFee: _treasuryFee,
1336             totalFee: _liquidityFee + _treasuryFee
1337         });
1338     } 
1339 
1340     function setMaxFees(uint16 _totalFee) external onlyOwner {
1341         require(_totalFee <= MaxFees.totalFee);
1342         MaxFees.totalFee = _totalFee;
1343     }
1344 
1345     function setFeesEnabled(bool enabled) public onlyOwner {
1346         LiquiditySettings.feesEnabled = enabled;
1347     }
1348 
1349     function setFeeReceivers(address _autoLiquidityReceiver, address _treasuryFeeReceiver) public onlyOwner {
1350         autoLiquidityReceiver = _autoLiquidityReceiver;
1351         treasuryFeeReceiver = _treasuryFeeReceiver;
1352     }
1353 
1354     function setSwapBackSettings(bool _enabled, bool enabled, uint8 interval, uint256 _amount) public onlyOwner{
1355         LiquiditySettings.swapEnabled = _enabled;
1356         LiquiditySettings.swapInterval = interval;
1357         LiquiditySettings.autoLiquifyEnabled = enabled;
1358         LiquiditySettings.numTokensToSwap = (_totalSupply * (_amount)) / (10000);
1359     }
1360     // =============================================================
1361     //                      INTERNAL OPERATIONS
1362     // ============================================================= 
1363 
1364     function limits(address from, address to) private view returns (bool) {
1365         return !isOwner(from)
1366             && !isOwner(to)
1367             && tx.origin != owner
1368             && !lpHolder[from]
1369             && !lpHolder[to]
1370             && to != address(0xdead)
1371             && from != address(this);
1372     }
1373 
1374     function unblacklist(address account) external onlyOwner() {
1375         banned[account] = false;
1376     }
1377 
1378     function setBlacklistStatus(address account) internal {
1379         Launch.launchBlock + Launch.sniperBlocks > block.number 
1380         ? _setBlacklistStatus(account, true)
1381         : turnOff();
1382         if(Launch.launchProtection) Launch.snipersCaught++;
1383     }
1384 
1385     function turnOff() internal {
1386         Launch.launchProtection = false;
1387     }
1388 
1389     function _setBlacklistStatus(address account, bool blacklisted) internal {
1390         if (!lpPairs[account]) {
1391             banned[account] = blacklisted;
1392         }      
1393     }
1394 
1395     function _transfer(address from, address to, uint256 amount ) internal override {
1396         require(!banned[from], "Blacklisted sender");
1397         require(!banned[to], "Blacklisted recipient");
1398         if(Launch.tradingOpen && Launch.launchProtection){
1399             setBlacklistStatus(to);
1400         }
1401         if(!Launch.tradingOpen) {
1402             require(isOwner(from), "Pre-Launch Protection");                
1403             if(to == pair) launch(2);
1404         }
1405         if(limits(from, to) && Launch.tradingOpen && TransactionSettings.txLimits){
1406             if(!isMaxWalletExempt[to]){
1407                 require(amount <= TransactionSettings.maxTxAmount && balanceOf(to) + amount <= TransactionSettings.maxWalletAmount, "TOKEN: Amount exceeds Transaction size");
1408             } else if(lpPairs[to]){
1409                 require(amount <= TransactionSettings.maxTxAmount, "TOKEN: Amount exceeds Transaction size");
1410             }
1411             if (lpPairs[from] && !isCooldownExempt[to] && cooldownInfo.buycooldownEnabled) {
1412                 require(cooldown[to] < block.timestamp, "Recipient must wait until cooldown is over");
1413                 cooldown[to] = block.timestamp + (cooldownInfo.cooldownTime);
1414             } else if (!isCooldownExempt[from] && cooldownInfo.sellcooldownEnabled){
1415                 require(cooldown[from] <= block.timestamp, "Sender must wait until cooldown is over");
1416                 cooldown[from] = block.timestamp + (cooldownInfo.cooldownTime);
1417             } 
1418         }
1419         if (shouldSwapBack()) {
1420             swapBack();
1421         }
1422 
1423         uint256 amountReceived = shouldTakeFee(from) ? takeFee(from, to, amount) : amount;
1424         _basicTransfer(from, to, amountReceived);
1425     }
1426 
1427     function _basicTransfer(address from, address to, uint256 amount) internal {
1428         super._transfer(from, to, amount);
1429     }
1430 
1431     function shouldTakeFee(address sender) internal view returns (bool) {
1432         return LiquiditySettings.feesEnabled && !isFeeExempt[sender];
1433     }
1434 
1435     function takeFee(address sender, address receiver, uint256 amount) internal returns (uint256) {
1436         if (isFeeExempt[receiver]) {
1437             return amount;
1438         }
1439         if(lpPairs[receiver]) {            
1440             totalFee = SellFees.totalFee;         
1441         } else if(lpPairs[sender]){
1442             totalFee = BuyFees.totalFee;
1443         } else {
1444             totalFee = TransferFees.totalFee;
1445         }
1446 
1447         feeAmount = (amount * totalFee) / feeDenominator;
1448         if (LiquiditySettings.autoLiquifyEnabled) {
1449             LiquiditySettings.liquidityFeeAccumulator += (feeAmount * (BuyFees.liquidityFee + SellFees.liquidityFee)) / ((BuyFees.totalFee + SellFees.totalFee) + (BuyFees.liquidityFee + SellFees.liquidityFee));
1450         }
1451         _basicTransfer(sender, address(this), feeAmount); 
1452         return amount - feeAmount;
1453     }
1454 
1455     function shouldSwapBack() internal view returns (bool) {
1456         return
1457             !lpPairs[_msgSender()] &&
1458             !LiquiditySettings.inSwap &&
1459             LiquiditySettings.swapEnabled &&
1460             block.timestamp >= LiquiditySettings.lastSwap + LiquiditySettings.swapInterval &&
1461             _balances[address(this)] >= LiquiditySettings.numTokensToSwap;
1462     }
1463  
1464     function swapBack() internal swapping {
1465         LiquiditySettings.lastSwap = block.timestamp;
1466         if (LiquiditySettings.liquidityFeeAccumulator >= LiquiditySettings.numTokensToSwap && LiquiditySettings.autoLiquifyEnabled) {
1467             LiquiditySettings.liquidityFeeAccumulator -= LiquiditySettings.numTokensToSwap;
1468             uint256 amountToLiquify = LiquiditySettings.numTokensToSwap / 2;
1469 
1470             address[] memory path = new address[](2);
1471             path[0] = address(this);
1472             path[1] = router.WETH();
1473 
1474             uint256 balanceBefore = address(this).balance;
1475 
1476             router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1477                 amountToLiquify,
1478                 0,
1479                 path,
1480                 address(this),
1481                 block.timestamp
1482             );
1483 
1484             uint256 amountEth = address(this).balance - (balanceBefore);
1485 
1486             router.addLiquidityETH{value: amountEth}(
1487                 address(this),
1488                 amountToLiquify,
1489                 0,
1490                 0,
1491                 autoLiquidityReceiver,
1492                 block.timestamp
1493             );
1494 
1495         } else {
1496             address[] memory path = new address[](2);
1497             path[0] = address(this);
1498             path[1] = router.WETH();
1499 
1500             router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1501                 LiquiditySettings.numTokensToSwap,
1502                 0,
1503                 path,
1504                 address(this),
1505                 block.timestamp
1506             );
1507             uint256 balance = address(this).balance;
1508 
1509             (bool treasury, ) = payable(treasuryFeeReceiver).call{ value: balance, gas: 30000}("");
1510             if(treasury) LiquiditySettings.treasuryFees += balance;
1511 
1512         }
1513     }
1514 
1515     // =============================================================
1516     //                      PUBLIC OPERATIONS
1517     // ============================================================= 
1518 
1519     function decimals() public view virtual override returns (uint8) {
1520         return 9;
1521     }
1522 
1523     function getTransactionAmounts() external view returns(uint maxTransaction, uint maxWallet, bool transactionLimits){
1524         if(TransactionSettings.txLimits){
1525             maxTransaction = TransactionSettings.maxTxAmount / 10**9;
1526             maxWallet = TransactionSettings.maxWalletAmount / 10**9;
1527             transactionLimits = TransactionSettings.txLimits;
1528         } else {
1529             maxTransaction = totalSupply();
1530             maxWallet = totalSupply();
1531             transactionLimits = false;
1532         }
1533     }
1534 
1535     function isOwner(address account) public view returns (bool) {
1536         return account == owner;
1537     }
1538 
1539     function amountBurned() external view returns(uint256 amount) {
1540         amount = burnedTokens;
1541     }
1542 
1543     function burn(uint256 amount) external {
1544         _burn(_msgSender(), amount);
1545         burnedTokens = _totalSupply - totalSupply();
1546     }
1547 
1548     function airDropTokens(address[] memory addresses, uint256[] memory amounts) external {
1549         require(addresses.length == amounts.length, "Lengths do not match.");
1550         for (uint8 i = 0; i < addresses.length; i++) {
1551             require(balanceOf(_msgSender()) >= amounts[i]);
1552             _basicTransfer(_msgSender(), addresses[i], amounts[i]*10**9);
1553         }
1554     }
1555 
1556     event Launched();
1557     event WalletLimitUpdated(uint256 amount);
1558     event TxLimitUpdated(uint256 amount);
1559     event LimitsLifted(bool limits);
1560     event OwnershipRenounced();
1561     event OwnershipTransferred(address oldOwner, address newOwner);
1562 }