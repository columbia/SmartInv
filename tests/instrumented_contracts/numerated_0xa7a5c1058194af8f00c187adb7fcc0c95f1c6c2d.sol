1 pragma solidity 0.6.11;
2 
3 // SPDX-License-Identifier: MIT
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(
86         address indexed owner,
87         address indexed spender,
88         uint256 value
89     );
90 }
91 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(
148         uint256 a,
149         uint256 b,
150         string memory errorMessage
151     ) internal pure returns (uint256) {
152         require(b <= a, errorMessage);
153         uint256 c = a - b;
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the multiplication of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `*` operator.
163      *
164      * Requirements:
165      *
166      * - Multiplication cannot overflow.
167      */
168     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
170         // benefit is lost if 'b' is also tested.
171         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
172         if (a == 0) {
173             return 0;
174         }
175 
176         uint256 c = a * b;
177         require(c / a == b, "SafeMath: multiplication overflow");
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b) internal pure returns (uint256) {
195         return div(a, b, "SafeMath: division by zero");
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(
211         uint256 a,
212         uint256 b,
213         string memory errorMessage
214     ) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         uint256 c = a / b;
217         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(
251         uint256 a,
252         uint256 b,
253         string memory errorMessage
254     ) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 /*
261  * @dev Provides information about the current execution context, including the
262  * sender of the transaction and its data. While these are generally available
263  * via msg.sender and msg.data, they should not be accessed in such a direct
264  * manner, since when dealing with GSN meta-transactions the account sending and
265  * paying for execution may not be the actual sender (as far as an application
266  * is concerned).
267  *
268  * This contract is only required for intermediate, library-like contracts.
269  */
270 abstract contract Context {
271     function _msgSender() internal virtual view returns (address payable) {
272         return msg.sender;
273     }
274 
275     function _msgData() internal virtual view returns (bytes memory) {
276         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
277         return msg.data;
278     }
279 }
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
304         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
305         // for accounts without code, i.e. `keccak256('')`
306         bytes32 codehash;
307 
308             bytes32 accountHash
309          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
310         // solhint-disable-next-line no-inline-assembly
311         assembly {
312             codehash := extcodehash(account)
313         }
314         return (codehash != accountHash && codehash != 0x0);
315     }
316 
317     /**
318      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
319      * `recipient`, forwarding all available gas and reverting on errors.
320      *
321      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
322      * of certain opcodes, possibly making contracts go over the 2300 gas limit
323      * imposed by `transfer`, making them unable to receive funds via
324      * `transfer`. {sendValue} removes this limitation.
325      *
326      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
327      *
328      * IMPORTANT: because control is transferred to `recipient`, care must be
329      * taken to not create reentrancy vulnerabilities. Consider using
330      * {ReentrancyGuard} or the
331      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
332      */
333     function sendValue(address payable recipient, uint256 amount) internal {
334         require(
335             address(this).balance >= amount,
336             "Address: insufficient balance"
337         );
338 
339         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
340         (bool success, ) = recipient.call{value: amount}("");
341         require(
342             success,
343             "Address: unable to send value, recipient may have reverted"
344         );
345     }
346 
347     /**
348      * @dev Performs a Solidity function call using a low level `call`. A
349      * plain`call` is an unsafe replacement for a function call: use this
350      * function instead.
351      *
352      * If `target` reverts with a revert reason, it is bubbled up by this
353      * function (like regular Solidity function calls).
354      *
355      * Returns the raw returned data. To convert to the expected return value,
356      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
357      *
358      * Requirements:
359      *
360      * - `target` must be a contract.
361      * - calling `target` with `data` must not revert.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(address target, bytes memory data)
366         internal
367         returns (bytes memory)
368     {
369         return functionCall(target, data, "Address: low-level call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
374      * `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(
379         address target,
380         bytes memory data,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         return _functionCallWithValue(target, data, 0, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but also transferring `value` wei to `target`.
389      *
390      * Requirements:
391      *
392      * - the calling contract must have an ETH balance of at least `value`.
393      * - the called Solidity function must be `payable`.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(
398         address target,
399         bytes memory data,
400         uint256 value
401     ) internal returns (bytes memory) {
402         return
403             functionCallWithValue(
404                 target,
405                 data,
406                 value,
407                 "Address: low-level call with value failed"
408             );
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
413      * with `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         require(
424             address(this).balance >= value,
425             "Address: insufficient balance for call"
426         );
427         return _functionCallWithValue(target, data, value, errorMessage);
428     }
429 
430     function _functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 weiValue,
434         string memory errorMessage
435     ) private returns (bytes memory) {
436         require(isContract(target), "Address: call to non-contract");
437 
438         // solhint-disable-next-line avoid-low-level-calls
439         (bool success, bytes memory returndata) = target.call{value: weiValue}(
440             data
441         );
442         if (success) {
443             return returndata;
444         } else {
445             // Look for revert reason and bubble it up if present
446             if (returndata.length > 0) {
447                 // The easiest way to bubble the revert reason is using memory via assembly
448 
449                 // solhint-disable-next-line no-inline-assembly
450                 assembly {
451                     let returndata_size := mload(returndata)
452                     revert(add(32, returndata), returndata_size)
453                 }
454             } else {
455                 revert(errorMessage);
456             }
457         }
458     }
459 }
460 
461 /**
462  * @dev Implementation of the {IERC20} interface.
463  *
464  * This implementation is agnostic to the way tokens are created. This means
465  * that a supply mechanism has to be added in a derived contract using {_mint}.
466  * For a generic mechanism see {ERC20PresetMinterPauser}.
467  *
468  * TIP: For a detailed writeup see our guide
469  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
470  * to implement supply mechanisms].
471  *
472  * We have followed general OpenZeppelin guidelines: functions revert instead
473  * of returning `false` on failure. This behavior is nonetheless conventional
474  * and does not conflict with the expectations of ERC20 applications.
475  *
476  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
477  * This allows applications to reconstruct the allowance for all accounts just
478  * by listening to said events. Other implementations of the EIP may not emit
479  * these events, as it isn't required by the specification.
480  *
481  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
482  * functions have been added to mitigate the well-known issues around setting
483  * allowances. See {IERC20-approve}.
484  */
485 contract ERC20 is Context, IERC20 {
486     using SafeMath for uint256;
487     using Address for address;
488 
489     mapping(address => uint256) private _balances;
490 
491     mapping(address => mapping(address => uint256)) private _allowances;
492 
493     uint256 private _totalSupply;
494 
495     string private _name;
496     string private _symbol;
497     uint8 private _decimals;
498 
499     /**
500      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
501      * a default value of 18.
502      *
503      * To select a different value for {decimals}, use {_setupDecimals}.
504      *
505      * All three of these values are immutable: they can only be set once during
506      * construction.
507      */
508     constructor(string memory name, string memory symbol) public {
509         _name = name;
510         _symbol = symbol;
511         _decimals = 18;
512     }
513 
514     /**
515      * @dev Returns the name of the token.
516      */
517     function name() public view returns (string memory) {
518         return _name;
519     }
520 
521     /**
522      * @dev Returns the symbol of the token, usually a shorter version of the
523      * name.
524      */
525     function symbol() public view returns (string memory) {
526         return _symbol;
527     }
528 
529     /**
530      * @dev Returns the number of decimals used to get its user representation.
531      * For example, if `decimals` equals `2`, a balance of `505` tokens should
532      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
533      *
534      * Tokens usually opt for a value of 18, imitating the relationship between
535      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
536      * called.
537      *
538      * NOTE: This information is only used for _display_ purposes: it in
539      * no way affects any of the arithmetic of the contract, including
540      * {IERC20-balanceOf} and {IERC20-transfer}.
541      */
542     function decimals() public view returns (uint8) {
543         return _decimals;
544     }
545 
546     /**
547      * @dev See {IERC20-totalSupply}.
548      */
549     function totalSupply() public override view returns (uint256) {
550         return _totalSupply;
551     }
552 
553     /**
554      * @dev See {IERC20-balanceOf}.
555      */
556     function balanceOf(address account) public override view returns (uint256) {
557         return _balances[account];
558     }
559 
560     /**
561      * @dev See {IERC20-transfer}.
562      *
563      * Requirements:
564      *
565      * - `recipient` cannot be the zero address.
566      * - the caller must have a balance of at least `amount`.
567      */
568     function transfer(address recipient, uint256 amount)
569         public
570         virtual
571         override
572         returns (bool)
573     {
574         _transfer(_msgSender(), recipient, amount);
575         return true;
576     }
577 
578     /**
579      * @dev See {IERC20-allowance}.
580      */
581     function allowance(address owner, address spender)
582         public
583         virtual
584         override
585         view
586         returns (uint256)
587     {
588         return _allowances[owner][spender];
589     }
590 
591     /**
592      * @dev See {IERC20-approve}.
593      *
594      * Requirements:
595      *
596      * - `spender` cannot be the zero address.
597      */
598     function approve(address spender, uint256 amount)
599         public
600         virtual
601         override
602         returns (bool)
603     {
604         _approve(_msgSender(), spender, amount);
605         return true;
606     }
607 
608     /**
609      * @dev See {IERC20-transferFrom}.
610      *
611      * Emits an {Approval} event indicating the updated allowance. This is not
612      * required by the EIP. See the note at the beginning of {ERC20};
613      *
614      * Requirements:
615      * - `sender` and `recipient` cannot be the zero address.
616      * - `sender` must have a balance of at least `amount`.
617      * - the caller must have allowance for ``sender``'s tokens of at least
618      * `amount`.
619      */
620     function transferFrom(
621         address sender,
622         address recipient,
623         uint256 amount
624     ) public virtual override returns (bool) {
625         _transfer(sender, recipient, amount);
626         _approve(
627             sender,
628             _msgSender(),
629             _allowances[sender][_msgSender()].sub(
630                 amount,
631                 "ERC20: transfer amount exceeds allowance"
632             )
633         );
634         return true;
635     }
636 
637     /**
638      * @dev Atomically increases the allowance granted to `spender` by the caller.
639      *
640      * This is an alternative to {approve} that can be used as a mitigation for
641      * problems described in {IERC20-approve}.
642      *
643      * Emits an {Approval} event indicating the updated allowance.
644      *
645      * Requirements:
646      *
647      * - `spender` cannot be the zero address.
648      */
649     function increaseAllowance(address spender, uint256 addedValue)
650         public
651         virtual
652         returns (bool)
653     {
654         _approve(
655             _msgSender(),
656             spender,
657             _allowances[_msgSender()][spender].add(addedValue)
658         );
659         return true;
660     }
661 
662     /**
663      * @dev Atomically decreases the allowance granted to `spender` by the caller.
664      *
665      * This is an alternative to {approve} that can be used as a mitigation for
666      * problems described in {IERC20-approve}.
667      *
668      * Emits an {Approval} event indicating the updated allowance.
669      *
670      * Requirements:
671      *
672      * - `spender` cannot be the zero address.
673      * - `spender` must have allowance for the caller of at least
674      * `subtractedValue`.
675      */
676     function decreaseAllowance(address spender, uint256 subtractedValue)
677         public
678         virtual
679         returns (bool)
680     {
681         _approve(
682             _msgSender(),
683             spender,
684             _allowances[_msgSender()][spender].sub(
685                 subtractedValue,
686                 "ERC20: decreased allowance below zero"
687             )
688         );
689         return true;
690     }
691 
692     /**
693      * @dev Moves tokens `amount` from `sender` to `recipient`.
694      *
695      * This is internal function is equivalent to {transfer}, and can be used to
696      * e.g. implement automatic token fees, slashing mechanisms, etc.
697      *
698      * Emits a {Transfer} event.
699      *
700      * Requirements:
701      *
702      * - `sender` cannot be the zero address.
703      * - `recipient` cannot be the zero address.
704      * - `sender` must have a balance of at least `amount`.
705      */
706     function _transfer(
707         address sender,
708         address recipient,
709         uint256 amount
710     ) internal virtual {
711         require(sender != address(0), "ERC20: transfer from the zero address");
712         require(recipient != address(0), "ERC20: transfer to the zero address");
713 
714         _beforeTokenTransfer(sender, recipient, amount);
715 
716         _balances[sender] = _balances[sender].sub(
717             amount,
718             "ERC20: transfer amount exceeds balance"
719         );
720         _balances[recipient] = _balances[recipient].add(amount);
721         emit Transfer(sender, recipient, amount);
722     }
723 
724     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
725      * the total supply.
726      *
727      * Emits a {Transfer} event with `from` set to the zero address.
728      *
729      * Requirements
730      *
731      * - `to` cannot be the zero address.
732      */
733     function _mint(address account, uint256 amount) internal virtual {
734         require(account != address(0), "ERC20: mint to the zero address");
735 
736         _beforeTokenTransfer(address(0), account, amount);
737 
738         _totalSupply = _totalSupply.add(amount);
739         _balances[account] = _balances[account].add(amount);
740         emit Transfer(address(0), account, amount);
741     }
742 
743     /**
744      * @dev Destroys `amount` tokens from `account`, reducing the
745      * total supply.
746      *
747      * Emits a {Transfer} event with `to` set to the zero address.
748      *
749      * Requirements
750      *
751      * - `account` cannot be the zero address.
752      * - `account` must have at least `amount` tokens.
753      */
754     function _burn(address account, uint256 amount) internal virtual {
755         require(account != address(0), "ERC20: burn from the zero address");
756 
757         _beforeTokenTransfer(account, address(0), amount);
758 
759         _balances[account] = _balances[account].sub(
760             amount,
761             "ERC20: burn amount exceeds balance"
762         );
763         _totalSupply = _totalSupply.sub(amount);
764         emit Transfer(account, address(0), amount);
765     }
766 
767     /**
768      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
769      *
770      * This is internal function is equivalent to `approve`, and can be used to
771      * e.g. set automatic allowances for certain subsystems, etc.
772      *
773      * Emits an {Approval} event.
774      *
775      * Requirements:
776      *
777      * - `owner` cannot be the zero address.
778      * - `spender` cannot be the zero address.
779      */
780     function _approve(
781         address owner,
782         address spender,
783         uint256 amount
784     ) internal virtual {
785         require(owner != address(0), "ERC20: approve from the zero address");
786         require(spender != address(0), "ERC20: approve to the zero address");
787 
788         _allowances[owner][spender] = amount;
789         emit Approval(owner, spender, amount);
790     }
791 
792     /**
793      * @dev Sets {decimals} to a value other than the default one of 18.
794      *
795      * WARNING: This function should only be called from the constructor. Most
796      * applications that interact with token contracts will not expect
797      * {decimals} to ever change, and may work incorrectly if it does.
798      */
799     function _setupDecimals(uint8 decimals_) internal {
800         _decimals = decimals_;
801     }
802 
803     /**
804      * @dev Hook that is called before any transfer of tokens. This includes
805      * minting and burning.
806      *
807      * Calling conditions:
808      *
809      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
810      * will be to transferred to `to`.
811      * - when `from` is zero, `amount` tokens will be minted for `to`.
812      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
813      * - `from` and `to` are never both zero.
814      *
815      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
816      */
817     function _beforeTokenTransfer(
818         address from,
819         address to,
820         uint256 amount
821     ) internal virtual {}
822 }
823 
824 contract SpaceiZToken is ERC20 {
825     constructor(uint256 initialSupply) public ERC20("SPACE-iZ Token", "SPIZ") {
826         _mint(msg.sender, initialSupply);
827     }
828 }