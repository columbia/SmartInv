1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-26
3  */
4 
5 // File: @openzeppelin/contracts/GSN/Context.sol
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
30 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount)
56         external
57         returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender)
67         external
68         view
69         returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `sender` to `recipient` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address sender,
98         address recipient,
99         uint256 amount
100     ) external returns (bool);
101 
102     /**
103      * @dev Emitted when `value` tokens are moved from one account (`from`) to
104      * another (`to`).
105      *
106      * Note that `value` may be zero.
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112      * a call to {approve}. `value` is the new allowance.
113      */
114     event Approval(
115         address indexed owner,
116         address indexed spender,
117         uint256 value
118     );
119 }
120 
121 // File: @openzeppelin/contracts/math/SafeMath.sol
122 
123 pragma solidity ^0.6.0;
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations with added overflow
127  * checks.
128  *
129  * Arithmetic operations in Solidity wrap on overflow. This can easily result
130  * in bugs, because programmers usually assume that an overflow raises an
131  * error, which is the standard behavior in high level programming languages.
132  * `SafeMath` restores this intuition by reverting the transaction when an
133  * operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  */
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `+` operator.
144      *
145      * Requirements:
146      *
147      * - Addition cannot overflow.
148      */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a, "SafeMath: addition overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         return sub(a, b, "SafeMath: subtraction overflow");
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(
181         uint256 a,
182         uint256 b,
183         string memory errorMessage
184     ) internal pure returns (uint256) {
185         require(b <= a, errorMessage);
186         uint256 c = a - b;
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
203         // benefit is lost if 'b' is also tested.
204         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
205         if (a == 0) {
206             return 0;
207         }
208 
209         uint256 c = a * b;
210         require(c / a == b, "SafeMath: multiplication overflow");
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b) internal pure returns (uint256) {
228         return div(a, b, "SafeMath: division by zero");
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function div(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         require(b > 0, errorMessage);
249         uint256 c = a / b;
250         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
268         return mod(a, b, "SafeMath: modulo by zero");
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
273      * Reverts with custom message when dividing by zero.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(
284         uint256 a,
285         uint256 b,
286         string memory errorMessage
287     ) internal pure returns (uint256) {
288         require(b != 0, errorMessage);
289         return a % b;
290     }
291 }
292 
293 // File: @openzeppelin/contracts/utils/Address.sol
294 
295 pragma solidity ^0.6.2;
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
320         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
321         // for accounts without code, i.e. `keccak256('')`
322         bytes32 codehash;
323 
324 
325             bytes32 accountHash
326          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
327         // solhint-disable-next-line no-inline-assembly
328         assembly {
329             codehash := extcodehash(account)
330         }
331         return (codehash != accountHash && codehash != 0x0);
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(
352             address(this).balance >= amount,
353             "Address: insufficient balance"
354         );
355 
356         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
357         (bool success, ) = recipient.call{value: amount}("");
358         require(
359             success,
360             "Address: unable to send value, recipient may have reverted"
361         );
362     }
363 
364     /**
365      * @dev Performs a Solidity function call using a low level `call`. A
366      * plain`call` is an unsafe replacement for a function call: use this
367      * function instead.
368      *
369      * If `target` reverts with a revert reason, it is bubbled up by this
370      * function (like regular Solidity function calls).
371      *
372      * Returns the raw returned data. To convert to the expected return value,
373      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
374      *
375      * Requirements:
376      *
377      * - `target` must be a contract.
378      * - calling `target` with `data` must not revert.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(address target, bytes memory data)
383         internal
384         returns (bytes memory)
385     {
386         return functionCall(target, data, "Address: low-level call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
391      * `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         return _functionCallWithValue(target, data, 0, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but also transferring `value` wei to `target`.
406      *
407      * Requirements:
408      *
409      * - the calling contract must have an ETH balance of at least `value`.
410      * - the called Solidity function must be `payable`.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value
418     ) internal returns (bytes memory) {
419         return
420             functionCallWithValue(
421                 target,
422                 data,
423                 value,
424                 "Address: low-level call with value failed"
425             );
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
430      * with `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(
435         address target,
436         bytes memory data,
437         uint256 value,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         require(
441             address(this).balance >= value,
442             "Address: insufficient balance for call"
443         );
444         return _functionCallWithValue(target, data, value, errorMessage);
445     }
446 
447     function _functionCallWithValue(
448         address target,
449         bytes memory data,
450         uint256 weiValue,
451         string memory errorMessage
452     ) private returns (bytes memory) {
453         require(isContract(target), "Address: call to non-contract");
454 
455         // solhint-disable-next-line avoid-low-level-calls
456         (bool success, bytes memory returndata) = target.call{value: weiValue}(
457             data
458         );
459         if (success) {
460             return returndata;
461         } else {
462             // Look for revert reason and bubble it up if present
463             if (returndata.length > 0) {
464                 // The easiest way to bubble the revert reason is using memory via assembly
465 
466                 // solhint-disable-next-line no-inline-assembly
467                 assembly {
468                     let returndata_size := mload(returndata)
469                     revert(add(32, returndata), returndata_size)
470                 }
471             } else {
472                 revert(errorMessage);
473             }
474         }
475     }
476 }
477 
478 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
479 
480 pragma solidity ^0.6.0;
481 
482 /**
483  * @dev Implementation of the {IERC20} interface.
484  *
485  * This implementation is agnostic to the way tokens are created. This means
486  * that a supply mechanism has to be added in a derived contract using {_mint}.
487  * For a generic mechanism see {ERC20PresetMinterPauser}.
488  *
489  * TIP: For a detailed writeup see our guide
490  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
491  * to implement supply mechanisms].
492  *
493  * We have followed general OpenZeppelin guidelines: functions revert instead
494  * of returning `false` on failure. This behavior is nonetheless conventional
495  * and does not conflict with the expectations of ERC20 applications.
496  *
497  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
498  * This allows applications to reconstruct the allowance for all accounts just
499  * by listening to said events. Other implementations of the EIP may not emit
500  * these events, as it isn't required by the specification.
501  *
502  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
503  * functions have been added to mitigate the well-known issues around setting
504  * allowances. See {IERC20-approve}.
505  */
506 contract ERC20 is Context, IERC20 {
507     using SafeMath for uint256;
508     using Address for address;
509 
510     mapping(address => uint256) private _balances;
511 
512     mapping(address => mapping(address => uint256)) private _allowances;
513 
514     uint256 private _totalSupply;
515 
516     string private _name;
517     string private _symbol;
518     uint8 private _decimals;
519 
520     /**
521      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
522      * a default value of 18.
523      *
524      * To select a different value for {decimals}, use {_setupDecimals}.
525      *
526      * All three of these values are immutable: they can only be set once during
527      * construction.
528      */
529     constructor(string memory name, string memory symbol) public {
530         _name = name;
531         _symbol = symbol;
532         _decimals = 18;
533     }
534 
535     /**
536      * @dev Returns the name of the token.
537      */
538     function name() public view returns (string memory) {
539         return _name;
540     }
541 
542     /**
543      * @dev Returns the symbol of the token, usually a shorter version of the
544      * name.
545      */
546     function symbol() public view returns (string memory) {
547         return _symbol;
548     }
549 
550     /**
551      * @dev Returns the number of decimals used to get its user representation.
552      * For example, if `decimals` equals `2`, a balance of `505` tokens should
553      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
554      *
555      * Tokens usually opt for a value of 18, imitating the relationship between
556      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
557      * called.
558      *
559      * NOTE: This information is only used for _display_ purposes: it in
560      * no way affects any of the arithmetic of the contract, including
561      * {IERC20-balanceOf} and {IERC20-transfer}.
562      */
563     function decimals() public view returns (uint8) {
564         return _decimals;
565     }
566 
567     /**
568      * @dev See {IERC20-totalSupply}.
569      */
570     function totalSupply() public override view returns (uint256) {
571         return _totalSupply;
572     }
573 
574     /**
575      * @dev See {IERC20-balanceOf}.
576      */
577     function balanceOf(address account) public override view returns (uint256) {
578         return _balances[account];
579     }
580 
581     /**
582      * @dev See {IERC20-transfer}.
583      *
584      * Requirements:
585      *
586      * - `recipient` cannot be the zero address.
587      * - the caller must have a balance of at least `amount`.
588      */
589     function transfer(address recipient, uint256 amount)
590         public
591         virtual
592         override
593         returns (bool)
594     {
595         _transfer(_msgSender(), recipient, amount);
596         return true;
597     }
598 
599     /**
600      * @dev See {IERC20-allowance}.
601      */
602     function allowance(address owner, address spender)
603         public
604         virtual
605         override
606         view
607         returns (uint256)
608     {
609         return _allowances[owner][spender];
610     }
611 
612     /**
613      * @dev See {IERC20-approve}.
614      *
615      * Requirements:
616      *
617      * - `spender` cannot be the zero address.
618      */
619     function approve(address spender, uint256 amount)
620         public
621         virtual
622         override
623         returns (bool)
624     {
625         _approve(_msgSender(), spender, amount);
626         return true;
627     }
628 
629     /**
630      * @dev See {IERC20-transferFrom}.
631      *
632      * Emits an {Approval} event indicating the updated allowance. This is not
633      * required by the EIP. See the note at the beginning of {ERC20};
634      *
635      * Requirements:
636      * - `sender` and `recipient` cannot be the zero address.
637      * - `sender` must have a balance of at least `amount`.
638      * - the caller must have allowance for ``sender``'s tokens of at least
639      * `amount`.
640      */
641     function transferFrom(
642         address sender,
643         address recipient,
644         uint256 amount
645     ) public virtual override returns (bool) {
646         _transfer(sender, recipient, amount);
647         _approve(
648             sender,
649             _msgSender(),
650             _allowances[sender][_msgSender()].sub(
651                 amount,
652                 "ERC20: transfer amount exceeds allowance"
653             )
654         );
655         return true;
656     }
657 
658     /**
659      * @dev Atomically increases the allowance granted to `spender` by the caller.
660      *
661      * This is an alternative to {approve} that can be used as a mitigation for
662      * problems described in {IERC20-approve}.
663      *
664      * Emits an {Approval} event indicating the updated allowance.
665      *
666      * Requirements:
667      *
668      * - `spender` cannot be the zero address.
669      */
670     function increaseAllowance(address spender, uint256 addedValue)
671         public
672         virtual
673         returns (bool)
674     {
675         _approve(
676             _msgSender(),
677             spender,
678             _allowances[_msgSender()][spender].add(addedValue)
679         );
680         return true;
681     }
682 
683     /**
684      * @dev Atomically decreases the allowance granted to `spender` by the caller.
685      *
686      * This is an alternative to {approve} that can be used as a mitigation for
687      * problems described in {IERC20-approve}.
688      *
689      * Emits an {Approval} event indicating the updated allowance.
690      *
691      * Requirements:
692      *
693      * - `spender` cannot be the zero address.
694      * - `spender` must have allowance for the caller of at least
695      * `subtractedValue`.
696      */
697     function decreaseAllowance(address spender, uint256 subtractedValue)
698         public
699         virtual
700         returns (bool)
701     {
702         _approve(
703             _msgSender(),
704             spender,
705             _allowances[_msgSender()][spender].sub(
706                 subtractedValue,
707                 "ERC20: decreased allowance below zero"
708             )
709         );
710         return true;
711     }
712 
713     /**
714      * @dev Moves tokens `amount` from `sender` to `recipient`.
715      *
716      * This is internal function is equivalent to {transfer}, and can be used to
717      * e.g. implement automatic token fees, slashing mechanisms, etc.
718      *
719      * Emits a {Transfer} event.
720      *
721      * Requirements:
722      *
723      * - `sender` cannot be the zero address.
724      * - `recipient` cannot be the zero address.
725      * - `sender` must have a balance of at least `amount`.
726      */
727     function _transfer(
728         address sender,
729         address recipient,
730         uint256 amount
731     ) internal virtual {
732         require(sender != address(0), "ERC20: transfer from the zero address");
733         require(recipient != address(0), "ERC20: transfer to the zero address");
734 
735         _beforeTokenTransfer(sender, recipient, amount);
736 
737         _balances[sender] = _balances[sender].sub(
738             amount,
739             "ERC20: transfer amount exceeds balance"
740         );
741         _balances[recipient] = _balances[recipient].add(amount);
742         emit Transfer(sender, recipient, amount);
743     }
744 
745     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
746      * the total supply.
747      *
748      * Emits a {Transfer} event with `from` set to the zero address.
749      *
750      * Requirements
751      *
752      * - `to` cannot be the zero address.
753      */
754     function _mint(address account, uint256 amount) internal virtual {
755         require(account != address(0), "ERC20: mint to the zero address");
756 
757         _beforeTokenTransfer(address(0), account, amount);
758 
759         _totalSupply = _totalSupply.add(amount);
760         _balances[account] = _balances[account].add(amount);
761         emit Transfer(address(0), account, amount);
762     }
763 
764     /**
765      * @dev Destroys `amount` tokens from `account`, reducing the
766      * total supply.
767      *
768      * Emits a {Transfer} event with `to` set to the zero address.
769      *
770      * Requirements
771      *
772      * - `account` cannot be the zero address.
773      * - `account` must have at least `amount` tokens.
774      */
775     function _burn(address account, uint256 amount) internal virtual {
776         require(account != address(0), "ERC20: burn from the zero address");
777 
778         _beforeTokenTransfer(account, address(0), amount);
779 
780         _balances[account] = _balances[account].sub(
781             amount,
782             "ERC20: burn amount exceeds balance"
783         );
784         _totalSupply = _totalSupply.sub(amount);
785         emit Transfer(account, address(0), amount);
786     }
787 
788     /**
789      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
790      *
791      * This is internal function is equivalent to `approve`, and can be used to
792      * e.g. set automatic allowances for certain subsystems, etc.
793      *
794      * Emits an {Approval} event.
795      *
796      * Requirements:
797      *
798      * - `owner` cannot be the zero address.
799      * - `spender` cannot be the zero address.
800      */
801     function _approve(
802         address owner,
803         address spender,
804         uint256 amount
805     ) internal virtual {
806         require(owner != address(0), "ERC20: approve from the zero address");
807         require(spender != address(0), "ERC20: approve to the zero address");
808 
809         _allowances[owner][spender] = amount;
810         emit Approval(owner, spender, amount);
811     }
812 
813     /**
814      * @dev Sets {decimals} to a value other than the default one of 18.
815      *
816      * WARNING: This function should only be called from the constructor. Most
817      * applications that interact with token contracts will not expect
818      * {decimals} to ever change, and may work incorrectly if it does.
819      */
820     function _setupDecimals(uint8 decimals_) internal {
821         _decimals = decimals_;
822     }
823 
824     /**
825      * @dev Hook that is called before any transfer of tokens. This includes
826      * minting and burning.
827      *
828      * Calling conditions:
829      *
830      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
831      * will be to transferred to `to`.
832      * - when `from` is zero, `amount` tokens will be minted for `to`.
833      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
834      * - `from` and `to` are never both zero.
835      *
836      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
837      */
838     function _beforeTokenTransfer(
839         address from,
840         address to,
841         uint256 amount
842     ) internal virtual {}
843 }
844 
845 // File: @openzeppelin/contracts/access/Ownable.sol
846 
847 pragma solidity ^0.6.0;
848 
849 /**
850  * @dev Contract module which provides a basic access control mechanism, where
851  * there is an account (an owner) that can be granted exclusive access to
852  * specific functions.
853  *
854  * By default, the owner account will be the one that deploys the contract. This
855  * can later be changed with {transferOwnership}.
856  *
857  * This module is used through inheritance. It will make available the modifier
858  * `onlyOwner`, which can be applied to your functions to restrict their use to
859  * the owner.
860  */
861 contract Ownable is Context {
862     address private _owner;
863 
864     event OwnershipTransferred(
865         address indexed previousOwner,
866         address indexed newOwner
867     );
868 
869     /**
870      * @dev Initializes the contract setting the deployer as the initial owner.
871      */
872     constructor() internal {
873         address msgSender = _msgSender();
874         _owner = msgSender;
875         emit OwnershipTransferred(address(0), msgSender);
876     }
877 
878     /**
879      * @dev Returns the address of the current owner.
880      */
881     function owner() public view returns (address) {
882         return _owner;
883     }
884 
885     /**
886      * @dev Throws if called by any account other than the owner.
887      */
888     modifier onlyOwner() {
889         require(_owner == _msgSender(), "Ownable: caller is not the owner");
890         _;
891     }
892 
893     /**
894      * @dev Leaves the contract without owner. It will not be possible to call
895      * `onlyOwner` functions anymore. Can only be called by the current owner.
896      *
897      * NOTE: Renouncing ownership will leave the contract without an owner,
898      * thereby removing any functionality that is only available to the owner.
899      */
900     function renounceOwnership() public virtual onlyOwner {
901         emit OwnershipTransferred(_owner, address(0));
902         _owner = address(0);
903     }
904 
905     /**
906      * @dev Transfers ownership of the contract to a new account (`newOwner`).
907      * Can only be called by the current owner.
908      */
909     function transferOwnership(address newOwner) public virtual onlyOwner {
910         require(
911             newOwner != address(0),
912             "Ownable: new owner is the zero address"
913         );
914         emit OwnershipTransferred(_owner, newOwner);
915         _owner = newOwner;
916     }
917 }
918 
919 pragma solidity 0.6.12;
920 
921 // DeFiXToken with Governance.
922 contract DeFiXToken is ERC20("DeFi-X Token", "TGX"), Ownable {
923     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
924     function mint(address _to, uint256 _amount) public onlyOwner {
925         _mint(_to, _amount);
926         _moveDelegates(address(0), _delegates[_to], _amount);
927     }
928 
929     // Copied and modified from YAM code:
930     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
931     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
932     // Which is copied and modified from COMPOUND:
933     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
934 
935     /// @notice A record of each accounts delegate
936     mapping(address => address) internal _delegates;
937 
938     /// @notice A checkpoint for marking number of votes from a given block
939     struct Checkpoint {
940         uint32 fromBlock;
941         uint256 votes;
942     }
943 
944     /// @notice A record of votes checkpoints for each account, by index
945     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
946 
947     /// @notice The number of checkpoints for each account
948     mapping(address => uint32) public numCheckpoints;
949 
950     /// @notice The EIP-712 typehash for the contract's domain
951     bytes32 public constant DOMAIN_TYPEHASH = keccak256(
952         "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
953     );
954 
955     /// @notice The EIP-712 typehash for the delegation struct used by the contract
956     bytes32 public constant DELEGATION_TYPEHASH = keccak256(
957         "Delegation(address delegatee,uint256 nonce,uint256 expiry)"
958     );
959 
960     /// @notice A record of states for signing / validating signatures
961     mapping(address => uint256) public nonces;
962 
963     /// @notice An event thats emitted when an account changes its delegate
964     event DelegateChanged(
965         address indexed delegator,
966         address indexed fromDelegate,
967         address indexed toDelegate
968     );
969 
970     /// @notice An event thats emitted when a delegate account's vote balance changes
971     event DelegateVotesChanged(
972         address indexed delegate,
973         uint256 previousBalance,
974         uint256 newBalance
975     );
976 
977     /**
978      * @notice Delegate votes from `msg.sender` to `delegatee`
979      * @param delegator The address to get delegatee for
980      */
981     function delegates(address delegator) external view returns (address) {
982         return _delegates[delegator];
983     }
984 
985     /**
986      * @notice Delegate votes from `msg.sender` to `delegatee`
987      * @param delegatee The address to delegate votes to
988      */
989     function delegate(address delegatee) external {
990         return _delegate(msg.sender, delegatee);
991     }
992 
993     /**
994      * @notice Delegates votes from signatory to `delegatee`
995      * @param delegatee The address to delegate votes to
996      * @param nonce The contract state required to match the signature
997      * @param expiry The time at which to expire the signature
998      * @param v The recovery byte of the signature
999      * @param r Half of the ECDSA signature pair
1000      * @param s Half of the ECDSA signature pair
1001      */
1002     function delegateBySig(
1003         address delegatee,
1004         uint256 nonce,
1005         uint256 expiry,
1006         uint8 v,
1007         bytes32 r,
1008         bytes32 s
1009     ) external {
1010         bytes32 domainSeparator = keccak256(
1011             abi.encode(
1012                 DOMAIN_TYPEHASH,
1013                 keccak256(bytes(name())),
1014                 getChainId(),
1015                 address(this)
1016             )
1017         );
1018 
1019         bytes32 structHash = keccak256(
1020             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
1021         );
1022 
1023         bytes32 digest = keccak256(
1024             abi.encodePacked("\x19\x01", domainSeparator, structHash)
1025         );
1026 
1027         address signatory = ecrecover(digest, v, r, s);
1028         require(
1029             signatory != address(0),
1030             "DEFI-X::delegateBySig: invalid signature"
1031         );
1032         require(
1033             nonce == nonces[signatory]++,
1034             "DEFI-X::delegateBySig: invalid nonce"
1035         );
1036         require(now <= expiry, "DEFI-X::delegateBySig: signature expired");
1037         return _delegate(signatory, delegatee);
1038     }
1039 
1040     /**
1041      * @notice Gets the current votes balance for `account`
1042      * @param account The address to get votes balance
1043      * @return The number of current votes for `account`
1044      */
1045     function getCurrentVotes(address account) external view returns (uint256) {
1046         uint32 nCheckpoints = numCheckpoints[account];
1047         return
1048             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1049     }
1050 
1051     /**
1052      * @notice Determine the prior number of votes for an account as of a block number
1053      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1054      * @param account The address of the account to check
1055      * @param blockNumber The block number to get the vote balance at
1056      * @return The number of votes the account had as of the given block
1057      */
1058     function getPriorVotes(address account, uint256 blockNumber)
1059         external
1060         view
1061         returns (uint256)
1062     {
1063         require(
1064             blockNumber < block.number,
1065             "DEFI-X::getPriorVotes: not yet determined"
1066         );
1067 
1068         uint32 nCheckpoints = numCheckpoints[account];
1069         if (nCheckpoints == 0) {
1070             return 0;
1071         }
1072 
1073         // First check most recent balance
1074         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1075             return checkpoints[account][nCheckpoints - 1].votes;
1076         }
1077 
1078         // Next check implicit zero balance
1079         if (checkpoints[account][0].fromBlock > blockNumber) {
1080             return 0;
1081         }
1082 
1083         uint32 lower = 0;
1084         uint32 upper = nCheckpoints - 1;
1085         while (upper > lower) {
1086             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1087             Checkpoint memory cp = checkpoints[account][center];
1088             if (cp.fromBlock == blockNumber) {
1089                 return cp.votes;
1090             } else if (cp.fromBlock < blockNumber) {
1091                 lower = center;
1092             } else {
1093                 upper = center - 1;
1094             }
1095         }
1096         return checkpoints[account][lower].votes;
1097     }
1098 
1099     function _delegate(address delegator, address delegatee) internal {
1100         address currentDelegate = _delegates[delegator];
1101         uint256 delegatorBalance = balanceOf(delegator);
1102         _delegates[delegator] = delegatee;
1103 
1104         emit DelegateChanged(delegator, currentDelegate, delegatee);
1105 
1106         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1107     }
1108 
1109     function _moveDelegates(
1110         address srcRep,
1111         address dstRep,
1112         uint256 amount
1113     ) internal {
1114         if (srcRep != dstRep && amount > 0) {
1115             if (srcRep != address(0)) {
1116                 // decrease old representative
1117                 uint32 srcRepNum = numCheckpoints[srcRep];
1118                 uint256 srcRepOld = srcRepNum > 0
1119                     ? checkpoints[srcRep][srcRepNum - 1].votes
1120                     : 0;
1121                 uint256 srcRepNew = srcRepOld.sub(amount);
1122                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1123             }
1124 
1125             if (dstRep != address(0)) {
1126                 // increase new representative
1127                 uint32 dstRepNum = numCheckpoints[dstRep];
1128                 uint256 dstRepOld = dstRepNum > 0
1129                     ? checkpoints[dstRep][dstRepNum - 1].votes
1130                     : 0;
1131                 uint256 dstRepNew = dstRepOld.add(amount);
1132                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1133             }
1134         }
1135     }
1136 
1137     function _writeCheckpoint(
1138         address delegatee,
1139         uint32 nCheckpoints,
1140         uint256 oldVotes,
1141         uint256 newVotes
1142     ) internal {
1143         uint32 blockNumber = safe32(
1144             block.number,
1145             "DEFI-X::_writeCheckpoint: block number exceeds 32 bits"
1146         );
1147 
1148         if (
1149             nCheckpoints > 0 &&
1150             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
1151         ) {
1152             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1153         } else {
1154             checkpoints[delegatee][nCheckpoints] = Checkpoint(
1155                 blockNumber,
1156                 newVotes
1157             );
1158             numCheckpoints[delegatee] = nCheckpoints + 1;
1159         }
1160 
1161         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1162     }
1163 
1164     function safe32(uint256 n, string memory errorMessage)
1165         internal
1166         pure
1167         returns (uint32)
1168     {
1169         require(n < 2**32, errorMessage);
1170         return uint32(n);
1171     }
1172 
1173     function getChainId() internal pure returns (uint256) {
1174         uint256 chainId;
1175         assembly {
1176             chainId := chainid()
1177         }
1178         return chainId;
1179     }
1180 }