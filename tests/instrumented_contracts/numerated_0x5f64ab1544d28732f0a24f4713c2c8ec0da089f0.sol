1 // "../../GSN/Context.sol";
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.6.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal virtual view returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal virtual view returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // "./IERC20.sol";
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount)
51         external
52         returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender)
62         external
63         view
64         returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(
92         address sender,
93         address recipient,
94         uint256 amount
95     ) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(
110         address indexed owner,
111         address indexed spender,
112         uint256 value
113     );
114 }
115 
116 // "../../math/SafeMath.sol";
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(
174         uint256 a,
175         uint256 b,
176         string memory errorMessage
177     ) internal pure returns (uint256) {
178         require(b <= a, errorMessage);
179         uint256 c = a - b;
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         return div(a, b, "SafeMath: division by zero");
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(
237         uint256 a,
238         uint256 b,
239         string memory errorMessage
240     ) internal pure returns (uint256) {
241         require(b > 0, errorMessage);
242         uint256 c = a / b;
243         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
261         return mod(a, b, "SafeMath: modulo by zero");
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * Reverts with custom message when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function mod(
277         uint256 a,
278         uint256 b,
279         string memory errorMessage
280     ) internal pure returns (uint256) {
281         require(b != 0, errorMessage);
282         return a % b;
283     }
284 }
285 
286 // "../../utils/Address.sol";
287 
288 /**
289  * @dev Collection of functions related to the address type
290  */
291 library Address {
292     /**
293      * @dev Returns true if `account` is a contract.
294      *
295      * [IMPORTANT]
296      * ====
297      * It is unsafe to assume that an address for which this function returns
298      * false is an externally-owned account (EOA) and not a contract.
299      *
300      * Among others, `isContract` will return false for the following
301      * types of addresses:
302      *
303      *  - an externally-owned account
304      *  - a contract in construction
305      *  - an address where a contract will be created
306      *  - an address where a contract lived, but was destroyed
307      * ====
308      */
309     function isContract(address account) internal view returns (bool) {
310         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
311         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
312         // for accounts without code, i.e. `keccak256('')`
313         bytes32 codehash;
314 
315 
316             bytes32 accountHash
317          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
318         // solhint-disable-next-line no-inline-assembly
319         assembly {
320             codehash := extcodehash(account)
321         }
322         return (codehash != accountHash && codehash != 0x0);
323     }
324 
325     /**
326      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
327      * `recipient`, forwarding all available gas and reverting on errors.
328      *
329      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
330      * of certain opcodes, possibly making contracts go over the 2300 gas limit
331      * imposed by `transfer`, making them unable to receive funds via
332      * `transfer`. {sendValue} removes this limitation.
333      *
334      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
335      *
336      * IMPORTANT: because control is transferred to `recipient`, care must be
337      * taken to not create reentrancy vulnerabilities. Consider using
338      * {ReentrancyGuard} or the
339      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
340      */
341     function sendValue(address payable recipient, uint256 amount) internal {
342         require(
343             address(this).balance >= amount,
344             "Address: insufficient balance"
345         );
346 
347         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
348         (bool success, ) = recipient.call{value: amount}("");
349         require(
350             success,
351             "Address: unable to send value, recipient may have reverted"
352         );
353     }
354 
355     /**
356      * @dev Performs a Solidity function call using a low level `call`. A
357      * plain`call` is an unsafe replacement for a function call: use this
358      * function instead.
359      *
360      * If `target` reverts with a revert reason, it is bubbled up by this
361      * function (like regular Solidity function calls).
362      *
363      * Returns the raw returned data. To convert to the expected return value,
364      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
365      *
366      * Requirements:
367      *
368      * - `target` must be a contract.
369      * - calling `target` with `data` must not revert.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(address target, bytes memory data)
374         internal
375         returns (bytes memory)
376     {
377         return functionCall(target, data, "Address: low-level call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
382      * `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         return _functionCallWithValue(target, data, 0, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but also transferring `value` wei to `target`.
397      *
398      * Requirements:
399      *
400      * - the calling contract must have an ETH balance of at least `value`.
401      * - the called Solidity function must be `payable`.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(
406         address target,
407         bytes memory data,
408         uint256 value
409     ) internal returns (bytes memory) {
410         return
411             functionCallWithValue(
412                 target,
413                 data,
414                 value,
415                 "Address: low-level call with value failed"
416             );
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
421      * with `errorMessage` as a fallback revert reason when `target` reverts.
422      *
423      * _Available since v3.1._
424      */
425     function functionCallWithValue(
426         address target,
427         bytes memory data,
428         uint256 value,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         require(
432             address(this).balance >= value,
433             "Address: insufficient balance for call"
434         );
435         return _functionCallWithValue(target, data, value, errorMessage);
436     }
437 
438     function _functionCallWithValue(
439         address target,
440         bytes memory data,
441         uint256 weiValue,
442         string memory errorMessage
443     ) private returns (bytes memory) {
444         require(isContract(target), "Address: call to non-contract");
445 
446         // solhint-disable-next-line avoid-low-level-calls
447         (bool success, bytes memory returndata) = target.call{value: weiValue}(
448             data
449         );
450         if (success) {
451             return returndata;
452         } else {
453             // Look for revert reason and bubble it up if present
454             if (returndata.length > 0) {
455                 // The easiest way to bubble the revert reason is using memory via assembly
456 
457                 // solhint-disable-next-line no-inline-assembly
458                 assembly {
459                     let returndata_size := mload(returndata)
460                     revert(add(32, returndata), returndata_size)
461                 }
462             } else {
463                 revert(errorMessage);
464             }
465         }
466     }
467 }
468 
469 // "@openzeppelin/contracts/token/ERC20/ERC20.sol";
470 
471 /**
472  * @dev Implementation of the {IERC20} interface.
473  *
474  * This implementation is agnostic to the way tokens are created. This means
475  * that a supply mechanism has to be added in a derived contract using {_mint}.
476  * For a generic mechanism see {ERC20PresetMinterPauser}.
477  *
478  * TIP: For a detailed writeup see our guide
479  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
480  * to implement supply mechanisms].
481  *
482  * We have followed general OpenZeppelin guidelines: functions revert instead
483  * of returning `false` on failure. This behavior is nonetheless conventional
484  * and does not conflict with the expectations of ERC20 applications.
485  *
486  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
487  * This allows applications to reconstruct the allowance for all accounts just
488  * by listening to said events. Other implementations of the EIP may not emit
489  * these events, as it isn't required by the specification.
490  *
491  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
492  * functions have been added to mitigate the well-known issues around setting
493  * allowances. See {IERC20-approve}.
494  */
495 contract ERC20 is Context, IERC20 {
496     using SafeMath for uint256;
497     using Address for address;
498 
499     mapping(address => uint256) private _balances;
500 
501     mapping(address => mapping(address => uint256)) private _allowances;
502 
503     uint256 private _totalSupply;
504 
505     string private _name;
506     string private _symbol;
507     uint8 private _decimals;
508 
509     /**
510      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
511      * a default value of 18.
512      *
513      * To select a different value for {decimals}, use {_setupDecimals}.
514      *
515      * All three of these values are immutable: they can only be set once during
516      * construction.
517      */
518     constructor(string memory name, string memory symbol) public {
519         _name = name;
520         _symbol = symbol;
521         _decimals = 18;
522     }
523 
524     /**
525      * @dev Returns the name of the token.
526      */
527     function name() public view returns (string memory) {
528         return _name;
529     }
530 
531     /**
532      * @dev Returns the symbol of the token, usually a shorter version of the
533      * name.
534      */
535     function symbol() public view returns (string memory) {
536         return _symbol;
537     }
538 
539     /**
540      * @dev Returns the number of decimals used to get its user representation.
541      * For example, if `decimals` equals `2`, a balance of `505` tokens should
542      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
543      *
544      * Tokens usually opt for a value of 18, imitating the relationship between
545      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
546      * called.
547      *
548      * NOTE: This information is only used for _display_ purposes: it in
549      * no way affects any of the arithmetic of the contract, including
550      * {IERC20-balanceOf} and {IERC20-transfer}.
551      */
552     function decimals() public view returns (uint8) {
553         return _decimals;
554     }
555 
556     /**
557      * @dev See {IERC20-totalSupply}.
558      */
559     function totalSupply() public override view returns (uint256) {
560         return _totalSupply;
561     }
562 
563     /**
564      * @dev See {IERC20-balanceOf}.
565      */
566     function balanceOf(address account) public override view returns (uint256) {
567         return _balances[account];
568     }
569 
570     /**
571      * @dev See {IERC20-transfer}.
572      *
573      * Requirements:
574      *
575      * - `recipient` cannot be the zero address.
576      * - the caller must have a balance of at least `amount`.
577      */
578     function transfer(address recipient, uint256 amount)
579         public
580         virtual
581         override
582         returns (bool)
583     {
584         _transfer(_msgSender(), recipient, amount);
585         return true;
586     }
587 
588     /**
589      * @dev See {IERC20-allowance}.
590      */
591     function allowance(address owner, address spender)
592         public
593         virtual
594         override
595         view
596         returns (uint256)
597     {
598         return _allowances[owner][spender];
599     }
600 
601     /**
602      * @dev See {IERC20-approve}.
603      *
604      * Requirements:
605      *
606      * - `spender` cannot be the zero address.
607      */
608     function approve(address spender, uint256 amount)
609         public
610         virtual
611         override
612         returns (bool)
613     {
614         _approve(_msgSender(), spender, amount);
615         return true;
616     }
617 
618     /**
619      * @dev See {IERC20-transferFrom}.
620      *
621      * Emits an {Approval} event indicating the updated allowance. This is not
622      * required by the EIP. See the note at the beginning of {ERC20};
623      *
624      * Requirements:
625      * - `sender` and `recipient` cannot be the zero address.
626      * - `sender` must have a balance of at least `amount`.
627      * - the caller must have allowance for ``sender``'s tokens of at least
628      * `amount`.
629      */
630     function transferFrom(
631         address sender,
632         address recipient,
633         uint256 amount
634     ) public virtual override returns (bool) {
635         _transfer(sender, recipient, amount);
636         _approve(
637             sender,
638             _msgSender(),
639             _allowances[sender][_msgSender()].sub(
640                 amount,
641                 "ERC20: transfer amount exceeds allowance"
642             )
643         );
644         return true;
645     }
646 
647     /**
648      * @dev Atomically increases the allowance granted to `spender` by the caller.
649      *
650      * This is an alternative to {approve} that can be used as a mitigation for
651      * problems described in {IERC20-approve}.
652      *
653      * Emits an {Approval} event indicating the updated allowance.
654      *
655      * Requirements:
656      *
657      * - `spender` cannot be the zero address.
658      */
659     function increaseAllowance(address spender, uint256 addedValue)
660         public
661         virtual
662         returns (bool)
663     {
664         _approve(
665             _msgSender(),
666             spender,
667             _allowances[_msgSender()][spender].add(addedValue)
668         );
669         return true;
670     }
671 
672     /**
673      * @dev Atomically decreases the allowance granted to `spender` by the caller.
674      *
675      * This is an alternative to {approve} that can be used as a mitigation for
676      * problems described in {IERC20-approve}.
677      *
678      * Emits an {Approval} event indicating the updated allowance.
679      *
680      * Requirements:
681      *
682      * - `spender` cannot be the zero address.
683      * - `spender` must have allowance for the caller of at least
684      * `subtractedValue`.
685      */
686     function decreaseAllowance(address spender, uint256 subtractedValue)
687         public
688         virtual
689         returns (bool)
690     {
691         _approve(
692             _msgSender(),
693             spender,
694             _allowances[_msgSender()][spender].sub(
695                 subtractedValue,
696                 "ERC20: decreased allowance below zero"
697             )
698         );
699         return true;
700     }
701 
702     /**
703      * @dev Moves tokens `amount` from `sender` to `recipient`.
704      *
705      * This is internal function is equivalent to {transfer}, and can be used to
706      * e.g. implement automatic token fees, slashing mechanisms, etc.
707      *
708      * Emits a {Transfer} event.
709      *
710      * Requirements:
711      *
712      * - `sender` cannot be the zero address.
713      * - `recipient` cannot be the zero address.
714      * - `sender` must have a balance of at least `amount`.
715      */
716     function _transfer(
717         address sender,
718         address recipient,
719         uint256 amount
720     ) internal virtual {
721         require(sender != address(0), "ERC20: transfer from the zero address");
722         require(recipient != address(0), "ERC20: transfer to the zero address");
723 
724         _beforeTokenTransfer(sender, recipient, amount);
725 
726         _balances[sender] = _balances[sender].sub(
727             amount,
728             "ERC20: transfer amount exceeds balance"
729         );
730         _balances[recipient] = _balances[recipient].add(amount);
731         emit Transfer(sender, recipient, amount);
732     }
733 
734     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
735      * the total supply.
736      *
737      * Emits a {Transfer} event with `from` set to the zero address.
738      *
739      * Requirements
740      *
741      * - `to` cannot be the zero address.
742      */
743     function _mint(address account, uint256 amount) internal virtual {
744         require(account != address(0), "ERC20: mint to the zero address");
745 
746         _beforeTokenTransfer(address(0), account, amount);
747 
748         _totalSupply = _totalSupply.add(amount);
749         _balances[account] = _balances[account].add(amount);
750         emit Transfer(address(0), account, amount);
751     }
752 
753     /**
754      * @dev Destroys `amount` tokens from `account`, reducing the
755      * total supply.
756      *
757      * Emits a {Transfer} event with `to` set to the zero address.
758      *
759      * Requirements
760      *
761      * - `account` cannot be the zero address.
762      * - `account` must have at least `amount` tokens.
763      */
764     function _burn(address account, uint256 amount) internal virtual {
765         require(account != address(0), "ERC20: burn from the zero address");
766 
767         _beforeTokenTransfer(account, address(0), amount);
768 
769         _balances[account] = _balances[account].sub(
770             amount,
771             "ERC20: burn amount exceeds balance"
772         );
773         _totalSupply = _totalSupply.sub(amount);
774         emit Transfer(account, address(0), amount);
775     }
776 
777     /**
778      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
779      *
780      * This is internal function is equivalent to `approve`, and can be used to
781      * e.g. set automatic allowances for certain subsystems, etc.
782      *
783      * Emits an {Approval} event.
784      *
785      * Requirements:
786      *
787      * - `owner` cannot be the zero address.
788      * - `spender` cannot be the zero address.
789      */
790     function _approve(
791         address owner,
792         address spender,
793         uint256 amount
794     ) internal virtual {
795         require(owner != address(0), "ERC20: approve from the zero address");
796         require(spender != address(0), "ERC20: approve to the zero address");
797 
798         _allowances[owner][spender] = amount;
799         emit Approval(owner, spender, amount);
800     }
801 
802     /**
803      * @dev Sets {decimals} to a value other than the default one of 18.
804      *
805      * WARNING: This function should only be called from the constructor. Most
806      * applications that interact with token contracts will not expect
807      * {decimals} to ever change, and may work incorrectly if it does.
808      */
809     function _setupDecimals(uint8 decimals_) internal {
810         _decimals = decimals_;
811     }
812 
813     /**
814      * @dev Hook that is called before any transfer of tokens. This includes
815      * minting and burning.
816      *
817      * Calling conditions:
818      *
819      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
820      * will be to transferred to `to`.
821      * - when `from` is zero, `amount` tokens will be minted for `to`.
822      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
823      * - `from` and `to` are never both zero.
824      *
825      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
826      */
827     function _beforeTokenTransfer(
828         address from,
829         address to,
830         uint256 amount
831     ) internal virtual {}
832 }
833 
834 // contracts/DextfToken.sol
835 
836 contract DextfToken is ERC20 {
837     uint256 initialSupply = 10**8 * 10**18;
838 
839     constructor() public ERC20("DEXTF Token", "DEXTF") {
840         _mint(msg.sender, initialSupply);
841     }
842 }