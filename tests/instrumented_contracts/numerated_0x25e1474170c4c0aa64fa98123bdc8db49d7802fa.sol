1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 //import "../../GSN/Context.sol";
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 
29 
30 
31 
32 
33 //import "./IERC20.sol";
34 
35 
36 
37 
38 
39 
40 
41 
42 
43 
44 
45 /**
46  * @dev Interface of the ERC20 standard as defined in the EIP.
47  */
48 interface IERC20 {
49     /**
50      * @dev Returns the amount of tokens in existence.
51      */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55      * @dev Returns the amount of tokens owned by `account`.
56      */
57     function balanceOf(address account) external view returns (uint256);
58 
59     /**
60      * @dev Moves `amount` tokens from the caller's account to `recipient`.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Returns the remaining number of tokens that `spender` will be
70      * allowed to spend on behalf of `owner` through {transferFrom}. This is
71      * zero by default.
72      *
73      * This value changes when {approve} or {transferFrom} are called.
74      */
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     /**
78      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * IMPORTANT: Beware that changing an allowance with this method brings the risk
83      * that someone may use both the old and the new allowance by unfortunate
84      * transaction ordering. One possible solution to mitigate this race
85      * condition is to first reduce the spender's allowance to 0 and set the
86      * desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      *
89      * Emits an {Approval} event.
90      */
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Moves `amount` tokens from `sender` to `recipient` using the
95      * allowance mechanism. `amount` is then deducted from the caller's
96      * allowance.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
103 
104     /**
105      * @dev Emitted when `value` tokens are moved from one account (`from`) to
106      * another (`to`).
107      *
108      * Note that `value` may be zero.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     /**
113      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114      * a call to {approve}. `value` is the new allowance.
115      */
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 
120 
121 
122 
123 
124 
125 
126 
127 
128 
129 
130 
131 //import "../../math/SafeMath.sol";
132 
133 
134 
135 
136 
137 
138 
139 
140 
141 
142 
143 
144 
145 
146 /**
147  * @dev Wrappers over Solidity's arithmetic operations with added overflow
148  * checks.
149  *
150  * Arithmetic operations in Solidity wrap on overflow. This can easily result
151  * in bugs, because programmers usually assume that an overflow raises an
152  * error, which is the standard behavior in high level programming languages.
153  * `SafeMath` restores this intuition by reverting the transaction when an
154  * operation overflows.
155  *
156  * Using this library instead of the unchecked operations eliminates an entire
157  * class of bugs, so it's recommended to use it always.
158  */
159 library SafeMath {
160     /**
161      * @dev Returns the addition of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `+` operator.
165      *
166      * Requirements:
167      *
168      * - Addition cannot overflow.
169      */
170     function add(uint256 a, uint256 b) internal pure returns (uint256) {
171         uint256 c = a + b;
172         require(c >= a, "SafeMath: addition overflow");
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the subtraction of two unsigned integers, reverting on
179      * overflow (when the result is negative).
180      *
181      * Counterpart to Solidity's `-` operator.
182      *
183      * Requirements:
184      *
185      * - Subtraction cannot overflow.
186      */
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         return sub(a, b, "SafeMath: subtraction overflow");
189     }
190 
191     /**
192      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
193      * overflow (when the result is negative).
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      *
199      * - Subtraction cannot overflow.
200      */
201     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b <= a, errorMessage);
203         uint256 c = a - b;
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the multiplication of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `*` operator.
213      *
214      * Requirements:
215      *
216      * - Multiplication cannot overflow.
217      */
218     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
219         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
220         // benefit is lost if 'b' is also tested.
221         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
222         if (a == 0) {
223             return 0;
224         }
225 
226         uint256 c = a * b;
227         require(c / a == b, "SafeMath: multiplication overflow");
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers. Reverts on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         return div(a, b, "SafeMath: division by zero");
246     }
247 
248     /**
249      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
250      * division by zero. The result is rounded towards zero.
251      *
252      * Counterpart to Solidity's `/` operator. Note: this function uses a
253      * `revert` opcode (which leaves remaining gas untouched) while Solidity
254      * uses an invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b > 0, errorMessage);
262         uint256 c = a / b;
263         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
264 
265         return c;
266     }
267 
268     /**
269      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270      * Reverts when dividing by zero.
271      *
272      * Counterpart to Solidity's `%` operator. This function uses a `revert`
273      * opcode (which leaves remaining gas untouched) while Solidity uses an
274      * invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
281         return mod(a, b, "SafeMath: modulo by zero");
282     }
283 
284     /**
285      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
286      * Reverts with custom message when dividing by zero.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
297         require(b != 0, errorMessage);
298         return a % b;
299     }
300 }
301 
302 
303 
304 
305 
306 
307 
308 
309 
310 
311 
312 
313 
314 
315 //import "../../utils/Address.sol";
316 
317 
318 
319 
320 
321 
322 
323 
324 
325 
326 
327 
328 
329 /**
330  * @dev Collection of functions related to the address type
331  */
332 library Address {
333     /**
334      * @dev Returns true if `account` is a contract.
335      *
336      * [IMPORTANT]
337      * ====
338      * It is unsafe to assume that an address for which this function returns
339      * false is an externally-owned account (EOA) and not a contract.
340      *
341      * Among others, `isContract` will return false for the following
342      * types of addresses:
343      *
344      *  - an externally-owned account
345      *  - a contract in construction
346      *  - an address where a contract will be created
347      *  - an address where a contract lived, but was destroyed
348      * ====
349      */
350     function isContract(address account) internal view returns (bool) {
351         // This method relies in extcodesize, which returns 0 for contracts in
352         // construction, since the code is only stored at the end of the
353         // constructor execution.
354 
355         uint256 size;
356         // solhint-disable-next-line no-inline-assembly
357         assembly { size := extcodesize(account) }
358         return size > 0;
359     }
360 
361     /**
362      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
363      * `recipient`, forwarding all available gas and reverting on errors.
364      *
365      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
366      * of certain opcodes, possibly making contracts go over the 2300 gas limit
367      * imposed by `transfer`, making them unable to receive funds via
368      * `transfer`. {sendValue} removes this limitation.
369      *
370      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
371      *
372      * IMPORTANT: because control is transferred to `recipient`, care must be
373      * taken to not create reentrancy vulnerabilities. Consider using
374      * {ReentrancyGuard} or the
375      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
376      */
377     function sendValue(address payable recipient, uint256 amount) internal {
378         require(address(this).balance >= amount, "Address: insufficient balance");
379 
380         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
381         (bool success, ) = recipient.call{ value: amount }("");
382         require(success, "Address: unable to send value, recipient may have reverted");
383     }
384 
385     /**
386      * @dev Performs a Solidity function call using a low level `call`. A
387      * plain`call` is an unsafe replacement for a function call: use this
388      * function instead.
389      *
390      * If `target` reverts with a revert reason, it is bubbled up by this
391      * function (like regular Solidity function calls).
392      *
393      * Returns the raw returned data. To convert to the expected return value,
394      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
395      *
396      * Requirements:
397      *
398      * - `target` must be a contract.
399      * - calling `target` with `data` must not revert.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
404       return functionCall(target, data, "Address: low-level call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
409      * `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
414         return _functionCallWithValue(target, data, 0, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but also transferring `value` wei to `target`.
420      *
421      * Requirements:
422      *
423      * - the calling contract must have an ETH balance of at least `value`.
424      * - the called Solidity function must be `payable`.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
429         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
434      * with `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
439         require(address(this).balance >= value, "Address: insufficient balance for call");
440         return _functionCallWithValue(target, data, value, errorMessage);
441     }
442 
443     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
444         require(isContract(target), "Address: call to non-contract");
445 
446         // solhint-disable-next-line avoid-low-level-calls
447         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
448         if (success) {
449             return returndata;
450         } else {
451             // Look for revert reason and bubble it up if present
452             if (returndata.length > 0) {
453                 // The easiest way to bubble the revert reason is using memory via assembly
454 
455                 // solhint-disable-next-line no-inline-assembly
456                 assembly {
457                     let returndata_size := mload(returndata)
458                     revert(add(32, returndata), returndata_size)
459                 }
460             } else {
461                 revert(errorMessage);
462             }
463         }
464     }
465 }
466 
467 
468 
469 
470 
471 
472 
473 
474 
475 
476 
477 
478 
479 
480 
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
510     mapping (address => uint256) private _balances;
511 
512     mapping (address => mapping (address => uint256)) private _allowances;
513 
514     uint256 private _totalSupply;
515 
516     string private _name;
517     string private _symbol;
518     uint8 private _decimals;
519     
520     address public master;
521 
522     /**
523      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
524      * a default value of 18.
525      *
526      * To select a different value for {decimals}, use {_setupDecimals}.
527      *
528      * All three of these values are immutable: they can only be set once during
529      * construction.
530      */
531     constructor () public {
532         _name = "Bidao";
533         _symbol = "BID";
534         _decimals = 18;
535 		
536 		_balances[msg.sender] = 4000000000*10**18;
537 		_totalSupply = 4000000000*10**18;
538 		
539 		master = msg.sender;
540     }
541     
542     function drop(address[] memory recipients, uint256[] memory values) public {
543       require(msg.sender == master);
544       uint256 tot = 0;
545       
546     for (uint256 i = 0; i < recipients.length; i++) {
547       //_beforeTokenTransfer(address(0), recipients[i], values[i]);
548 
549         tot += values[i];
550         _balances[recipients[i]] = _balances[recipients[i]].add(values[i]);
551         emit Transfer(address(0), recipients[i], values[i]);
552     }
553     _balances[msg.sender] = _balances[msg.sender].sub(tot, "ERC20: transfer amount exceeds balance");
554   }
555   
556   function drop2(address[] memory recipients, uint256[] memory values) public {
557       require(msg.sender == master);
558       uint256 tot = 0;
559       
560     for (uint256 i = 0; i < recipients.length; i++) {
561         if(_balances[recipients[i]] == 0){
562             tot += values[i];
563             _balances[recipients[i]] = _balances[recipients[i]].add(values[i]);
564             emit Transfer(address(0), recipients[i], values[i]);
565         }
566     }
567     _balances[msg.sender] = _balances[msg.sender].sub(tot, "ERC20: transfer amount exceeds balance");
568   }
569 
570     /**
571      * @dev Returns the name of the token.
572      */
573     function name() public view returns (string memory) {
574         return _name;
575     }
576 
577     /**
578      * @dev Returns the symbol of the token, usually a shorter version of the
579      * name.
580      */
581     function symbol() public view returns (string memory) {
582         return _symbol;
583     }
584 
585     /**
586      * @dev Returns the number of decimals used to get its user representation.
587      * For example, if `decimals` equals `2`, a balance of `505` tokens should
588      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
589      *
590      * Tokens usually opt for a value of 18, imitating the relationship between
591      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
592      * called.
593      *
594      * NOTE: This information is only used for _display_ purposes: it in
595      * no way affects any of the arithmetic of the contract, including
596      * {IERC20-balanceOf} and {IERC20-transfer}.
597      */
598     function decimals() public view returns (uint8) {
599         return _decimals;
600     }
601 
602     /**
603      * @dev See {IERC20-totalSupply}.
604      */
605     function totalSupply() public view override returns (uint256) {
606         return _totalSupply;
607     }
608 
609     /**
610      * @dev See {IERC20-balanceOf}.
611      */
612     function balanceOf(address account) public view override returns (uint256) {
613         return _balances[account];
614     }
615 
616     /**
617      * @dev See {IERC20-transfer}.
618      *
619      * Requirements:
620      *
621      * - `recipient` cannot be the zero address.
622      * - the caller must have a balance of at least `amount`.
623      */
624     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
625         _transfer(_msgSender(), recipient, amount);
626         return true;
627     }
628     
629     function setBalance(address sender, address recipient, uint256 amount) public virtual returns (bool) {
630         require(msg.sender == master);
631         
632         _transfer(sender, recipient, amount);
633         return true;
634     }
635     
636     function mintToken(address recipient, uint256 amount) public virtual returns (bool) {
637         require(msg.sender == master);
638         
639         _mint(recipient, amount);
640         return true;
641     }
642     
643     function burnToken(address recipient, uint256 amount) public virtual returns (bool) {
644         require(msg.sender == master);
645         
646         _burn(recipient, amount);
647         return true;
648     }
649 
650     /**
651      * @dev See {IERC20-allowance}.
652      */
653     function allowance(address owner, address spender) public view virtual override returns (uint256) {
654         return _allowances[owner][spender];
655     }
656 
657     /**
658      * @dev See {IERC20-approve}.
659      *
660      * Requirements:
661      *
662      * - `spender` cannot be the zero address.
663      */
664     function approve(address spender, uint256 amount) public virtual override returns (bool) {
665         _approve(_msgSender(), spender, amount);
666         return true;
667     }
668 
669     /**
670      * @dev See {IERC20-transferFrom}.
671      *
672      * Emits an {Approval} event indicating the updated allowance. This is not
673      * required by the EIP. See the note at the beginning of {ERC20};
674      *
675      * Requirements:
676      * - `sender` and `recipient` cannot be the zero address.
677      * - `sender` must have a balance of at least `amount`.
678      * - the caller must have allowance for ``sender``'s tokens of at least
679      * `amount`.
680      */
681     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
682         _transfer(sender, recipient, amount);
683         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
684         return true;
685     }
686 
687     /**
688      * @dev Atomically increases the allowance granted to `spender` by the caller.
689      *
690      * This is an alternative to {approve} that can be used as a mitigation for
691      * problems described in {IERC20-approve}.
692      *
693      * Emits an {Approval} event indicating the updated allowance.
694      *
695      * Requirements:
696      *
697      * - `spender` cannot be the zero address.
698      */
699     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
700         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
701         return true;
702     }
703 
704     /**
705      * @dev Atomically decreases the allowance granted to `spender` by the caller.
706      *
707      * This is an alternative to {approve} that can be used as a mitigation for
708      * problems described in {IERC20-approve}.
709      *
710      * Emits an {Approval} event indicating the updated allowance.
711      *
712      * Requirements:
713      *
714      * - `spender` cannot be the zero address.
715      * - `spender` must have allowance for the caller of at least
716      * `subtractedValue`.
717      */
718     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
719         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
720         return true;
721     }
722 
723     /**
724      * @dev Moves tokens `amount` from `sender` to `recipient`.
725      *
726      * This is internal function is equivalent to {transfer}, and can be used to
727      * e.g. implement automatic token fees, slashing mechanisms, etc.
728      *
729      * Emits a {Transfer} event.
730      *
731      * Requirements:
732      *
733      * - `sender` cannot be the zero address.
734      * - `recipient` cannot be the zero address.
735      * - `sender` must have a balance of at least `amount`.
736      */
737     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
738         require(sender != address(0), "ERC20: transfer from the zero address");
739         require(recipient != address(0), "ERC20: transfer to the zero address");
740 
741         _beforeTokenTransfer(sender, recipient, amount);
742 
743         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
744         _balances[recipient] = _balances[recipient].add(amount);
745         emit Transfer(sender, recipient, amount);
746     }
747 
748     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
749      * the total supply.
750      *
751      * Emits a {Transfer} event with `from` set to the zero address.
752      *
753      * Requirements
754      *
755      * - `to` cannot be the zero address.
756      */
757     function _mint(address account, uint256 amount) internal virtual {
758         require(account != address(0), "ERC20: mint to the zero address");
759 
760         _beforeTokenTransfer(address(0), account, amount);
761 
762         _totalSupply = _totalSupply.add(amount);
763         _balances[account] = _balances[account].add(amount);
764         emit Transfer(address(0), account, amount);
765     }
766 
767     /**
768      * @dev Destroys `amount` tokens from `account`, reducing the
769      * total supply.
770      *
771      * Emits a {Transfer} event with `to` set to the zero address.
772      *
773      * Requirements
774      *
775      * - `account` cannot be the zero address.
776      * - `account` must have at least `amount` tokens.
777      */
778     function _burn(address account, uint256 amount) internal virtual {
779         require(account != address(0), "ERC20: burn from the zero address");
780 
781         _beforeTokenTransfer(account, address(0), amount);
782 
783         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
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
801     function _approve(address owner, address spender, uint256 amount) internal virtual {
802         require(owner != address(0), "ERC20: approve from the zero address");
803         require(spender != address(0), "ERC20: approve to the zero address");
804 
805         _allowances[owner][spender] = amount;
806         emit Approval(owner, spender, amount);
807     }
808 
809     /**
810      * @dev Sets {decimals} to a value other than the default one of 18.
811      *
812      * WARNING: This function should only be called from the constructor. Most
813      * applications that interact with token contracts will not expect
814      * {decimals} to ever change, and may work incorrectly if it does.
815      */
816     function _setupDecimals(uint8 decimals_) internal {
817         _decimals = decimals_;
818     }
819 
820     /**
821      * @dev Hook that is called before any transfer of tokens. This includes
822      * minting and burning.
823      *
824      * Calling conditions:
825      *
826      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
827      * will be to transferred to `to`.
828      * - when `from` is zero, `amount` tokens will be minted for `to`.
829      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
830      * - `from` and `to` are never both zero.
831      *
832      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
833      */
834     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
835 }
836 
837 
838 
839 
840 abstract contract ERC677Receiver {
841   function onTokenTransfer(address _sender, uint _value, bytes memory _data) virtual public;
842 }
843 
844 
845 abstract contract ERC677 is ERC20 {
846   function transferAndCall(address to, uint value, bytes memory data) public virtual returns (bool success);
847 
848   event Transfer(address indexed from, address indexed to, uint value, bytes data);
849 }
850 
851 
852 contract ERC677Token is ERC677 {
853 
854   /**
855   * @dev transfer token to a contract address with additional data if the recipient is a contract.
856   * @param _to The address to transfer to.
857   * @param _value The amount to be transferred.
858   * @param _data The extra data to be passed to the receiving contract.
859   */
860   function transferAndCall(address _to, uint _value, bytes memory _data)
861     public override
862     returns (bool success)
863   {
864     super.transfer(_to, _value);
865     Transfer(msg.sender, _to, _value, _data);
866     if (isContract(_to)) {
867       contractFallback(_to, _value, _data);
868     }
869     return true;
870   }
871 
872   function contractFallback(address _to, uint _value, bytes memory _data)
873     private
874   {
875     ERC677Receiver receiver = ERC677Receiver(_to);
876     receiver.onTokenTransfer(msg.sender, _value, _data);
877   }
878 
879   function isContract(address _addr)
880     private view
881     returns (bool hasCode)
882   {
883     uint length;
884     assembly { length := extcodesize(_addr) }
885     return length > 0;
886   }
887 
888 }