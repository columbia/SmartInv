1 // Verified using https://dapp.tools
2 // hevm: flattened sources of src/pickle-jar.sol
3 pragma solidity >=0.4.23 >=0.6.0 <0.7.0 >=0.6.2 <0.7.0 >=0.6.7 <0.7.0;
4 
5 ////// src/interfaces/controller.sol
6 // SPDX-License-Identifier: MIT
7 
8 /* pragma solidity ^0.6.0; */
9 
10 interface IController {
11     function jars(address) external view returns (address);
12 
13     function rewards() external view returns (address);
14 
15     function devfund() external view returns (address);
16 
17     function treasury() external view returns (address);
18 
19     function balanceOf(address) external view returns (uint256);
20 
21     function withdraw(address, uint256) external;
22 
23     function earn(address, uint256) external;
24 }
25 
26 ////// src/lib/safe-math.sol
27 // SPDX-License-Identifier: MIT
28 
29 /* pragma solidity ^0.6.0; */
30 
31 /**
32  * @dev Wrappers over Solidity's arithmetic operations with added overflow
33  * checks.
34  *
35  * Arithmetic operations in Solidity wrap on overflow. This can easily result
36  * in bugs, because programmers usually assume that an overflow raises an
37  * error, which is the standard behavior in high level programming languages.
38  * `SafeMath` restores this intuition by reverting the transaction when an
39  * operation overflows.
40  *
41  * Using this library instead of the unchecked operations eliminates an entire
42  * class of bugs, so it's recommended to use it always.
43  */
44 library SafeMath {
45     /**
46      * @dev Returns the addition of two unsigned integers, reverting on
47      * overflow.
48      *
49      * Counterpart to Solidity's `+` operator.
50      *
51      * Requirements:
52      *
53      * - Addition cannot overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      *
70      * - Subtraction cannot overflow.
71      */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
78      * overflow (when the result is negative).
79      *
80      * Counterpart to Solidity's `-` operator.
81      *
82      * Requirements:
83      *
84      * - Subtraction cannot overflow.
85      */
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      *
101      * - Multiplication cannot overflow.
102      */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105         // benefit is lost if 'b' is also tested.
106         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
107         if (a == 0) {
108             return 0;
109         }
110 
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      *
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return div(a, b, "SafeMath: division by zero");
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator. Note: this function uses a
138      * `revert` opcode (which leaves remaining gas untouched) while Solidity
139      * uses an invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b > 0, errorMessage);
147         uint256 c = a / b;
148         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         return mod(a, b, "SafeMath: modulo by zero");
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts with custom message when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b != 0, errorMessage);
183         return a % b;
184     }
185 }
186 ////// src/lib/erc20.sol
187 
188 // File: contracts/GSN/Context.sol
189 
190 // SPDX-License-Identifier: MIT
191 
192 /* pragma solidity ^0.6.0; */
193 
194 /* import "./safe-math.sol"; */
195 
196 /*
197  * @dev Provides information about the current execution context, including the
198  * sender of the transaction and its data. While these are generally available
199  * via msg.sender and msg.data, they should not be accessed in such a direct
200  * manner, since when dealing with GSN meta-transactions the account sending and
201  * paying for execution may not be the actual sender (as far as an application
202  * is concerned).
203  *
204  * This contract is only required for intermediate, library-like contracts.
205  */
206 abstract contract Context {
207     function _msgSender() internal view virtual returns (address payable) {
208         return msg.sender;
209     }
210 
211     function _msgData() internal view virtual returns (bytes memory) {
212         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
213         return msg.data;
214     }
215 }
216 
217 // File: contracts/token/ERC20/IERC20.sol
218 
219 
220 /**
221  * @dev Interface of the ERC20 standard as defined in the EIP.
222  */
223 interface IERC20 {
224     /**
225      * @dev Returns the amount of tokens in existence.
226      */
227     function totalSupply() external view returns (uint256);
228 
229     /**
230      * @dev Returns the amount of tokens owned by `account`.
231      */
232     function balanceOf(address account) external view returns (uint256);
233 
234     /**
235      * @dev Moves `amount` tokens from the caller's account to `recipient`.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transfer(address recipient, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Returns the remaining number of tokens that `spender` will be
245      * allowed to spend on behalf of `owner` through {transferFrom}. This is
246      * zero by default.
247      *
248      * This value changes when {approve} or {transferFrom} are called.
249      */
250     function allowance(address owner, address spender) external view returns (uint256);
251 
252     /**
253      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * IMPORTANT: Beware that changing an allowance with this method brings the risk
258      * that someone may use both the old and the new allowance by unfortunate
259      * transaction ordering. One possible solution to mitigate this race
260      * condition is to first reduce the spender's allowance to 0 and set the
261      * desired value afterwards:
262      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263      *
264      * Emits an {Approval} event.
265      */
266     function approve(address spender, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Moves `amount` tokens from `sender` to `recipient` using the
270      * allowance mechanism. `amount` is then deducted from the caller's
271      * allowance.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * Emits a {Transfer} event.
276      */
277     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
278 
279     /**
280      * @dev Emitted when `value` tokens are moved from one account (`from`) to
281      * another (`to`).
282      *
283      * Note that `value` may be zero.
284      */
285     event Transfer(address indexed from, address indexed to, uint256 value);
286 
287     /**
288      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
289      * a call to {approve}. `value` is the new allowance.
290      */
291     event Approval(address indexed owner, address indexed spender, uint256 value);
292 }
293 
294 // File: contracts/utils/Address.sol
295 
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
319         // This method relies on extcodesize, which returns 0 for contracts in
320         // construction, since the code is only stored at the end of the
321         // constructor execution.
322 
323         uint256 size;
324         // solhint-disable-next-line no-inline-assembly
325         assembly { size := extcodesize(account) }
326         return size > 0;
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
349         (bool success, ) = recipient.call{ value: amount }("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain`call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372       return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
382         return _functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
407         require(address(this).balance >= value, "Address: insufficient balance for call");
408         return _functionCallWithValue(target, data, value, errorMessage);
409     }
410 
411     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
412         require(isContract(target), "Address: call to non-contract");
413 
414         // solhint-disable-next-line avoid-low-level-calls
415         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 // solhint-disable-next-line no-inline-assembly
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 // File: contracts/token/ERC20/ERC20.sol
436 
437 /**
438  * @dev Implementation of the {IERC20} interface.
439  *
440  * This implementation is agnostic to the way tokens are created. This means
441  * that a supply mechanism has to be added in a derived contract using {_mint}.
442  * For a generic mechanism see {ERC20PresetMinterPauser}.
443  *
444  * TIP: For a detailed writeup see our guide
445  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
446  * to implement supply mechanisms].
447  *
448  * We have followed general OpenZeppelin guidelines: functions revert instead
449  * of returning `false` on failure. This behavior is nonetheless conventional
450  * and does not conflict with the expectations of ERC20 applications.
451  *
452  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
453  * This allows applications to reconstruct the allowance for all accounts just
454  * by listening to said events. Other implementations of the EIP may not emit
455  * these events, as it isn't required by the specification.
456  *
457  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
458  * functions have been added to mitigate the well-known issues around setting
459  * allowances. See {IERC20-approve}.
460  */
461 contract ERC20 is Context, IERC20 {
462     using SafeMath for uint256;
463     using Address for address;
464 
465     mapping (address => uint256) private _balances;
466 
467     mapping (address => mapping (address => uint256)) private _allowances;
468 
469     uint256 private _totalSupply;
470 
471     string private _name;
472     string private _symbol;
473     uint8 private _decimals;
474 
475     /**
476      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
477      * a default value of 18.
478      *
479      * To select a different value for {decimals}, use {_setupDecimals}.
480      *
481      * All three of these values are immutable: they can only be set once during
482      * construction.
483      */
484     constructor (string memory name, string memory symbol) public {
485         _name = name;
486         _symbol = symbol;
487         _decimals = 18;
488     }
489 
490     /**
491      * @dev Returns the name of the token.
492      */
493     function name() public view returns (string memory) {
494         return _name;
495     }
496 
497     /**
498      * @dev Returns the symbol of the token, usually a shorter version of the
499      * name.
500      */
501     function symbol() public view returns (string memory) {
502         return _symbol;
503     }
504 
505     /**
506      * @dev Returns the number of decimals used to get its user representation.
507      * For example, if `decimals` equals `2`, a balance of `505` tokens should
508      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
509      *
510      * Tokens usually opt for a value of 18, imitating the relationship between
511      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
512      * called.
513      *
514      * NOTE: This information is only used for _display_ purposes: it in
515      * no way affects any of the arithmetic of the contract, including
516      * {IERC20-balanceOf} and {IERC20-transfer}.
517      */
518     function decimals() public view returns (uint8) {
519         return _decimals;
520     }
521 
522     /**
523      * @dev See {IERC20-totalSupply}.
524      */
525     function totalSupply() public view override returns (uint256) {
526         return _totalSupply;
527     }
528 
529     /**
530      * @dev See {IERC20-balanceOf}.
531      */
532     function balanceOf(address account) public view override returns (uint256) {
533         return _balances[account];
534     }
535 
536     /**
537      * @dev See {IERC20-transfer}.
538      *
539      * Requirements:
540      *
541      * - `recipient` cannot be the zero address.
542      * - the caller must have a balance of at least `amount`.
543      */
544     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
545         _transfer(_msgSender(), recipient, amount);
546         return true;
547     }
548 
549     /**
550      * @dev See {IERC20-allowance}.
551      */
552     function allowance(address owner, address spender) public view virtual override returns (uint256) {
553         return _allowances[owner][spender];
554     }
555 
556     /**
557      * @dev See {IERC20-approve}.
558      *
559      * Requirements:
560      *
561      * - `spender` cannot be the zero address.
562      */
563     function approve(address spender, uint256 amount) public virtual override returns (bool) {
564         _approve(_msgSender(), spender, amount);
565         return true;
566     }
567 
568     /**
569      * @dev See {IERC20-transferFrom}.
570      *
571      * Emits an {Approval} event indicating the updated allowance. This is not
572      * required by the EIP. See the note at the beginning of {ERC20};
573      *
574      * Requirements:
575      * - `sender` and `recipient` cannot be the zero address.
576      * - `sender` must have a balance of at least `amount`.
577      * - the caller must have allowance for ``sender``'s tokens of at least
578      * `amount`.
579      */
580     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
581         _transfer(sender, recipient, amount);
582         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
583         return true;
584     }
585 
586     /**
587      * @dev Atomically increases the allowance granted to `spender` by the caller.
588      *
589      * This is an alternative to {approve} that can be used as a mitigation for
590      * problems described in {IERC20-approve}.
591      *
592      * Emits an {Approval} event indicating the updated allowance.
593      *
594      * Requirements:
595      *
596      * - `spender` cannot be the zero address.
597      */
598     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
599         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
600         return true;
601     }
602 
603     /**
604      * @dev Atomically decreases the allowance granted to `spender` by the caller.
605      *
606      * This is an alternative to {approve} that can be used as a mitigation for
607      * problems described in {IERC20-approve}.
608      *
609      * Emits an {Approval} event indicating the updated allowance.
610      *
611      * Requirements:
612      *
613      * - `spender` cannot be the zero address.
614      * - `spender` must have allowance for the caller of at least
615      * `subtractedValue`.
616      */
617     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
618         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
619         return true;
620     }
621 
622     /**
623      * @dev Moves tokens `amount` from `sender` to `recipient`.
624      *
625      * This is internal function is equivalent to {transfer}, and can be used to
626      * e.g. implement automatic token fees, slashing mechanisms, etc.
627      *
628      * Emits a {Transfer} event.
629      *
630      * Requirements:
631      *
632      * - `sender` cannot be the zero address.
633      * - `recipient` cannot be the zero address.
634      * - `sender` must have a balance of at least `amount`.
635      */
636     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
637         require(sender != address(0), "ERC20: transfer from the zero address");
638         require(recipient != address(0), "ERC20: transfer to the zero address");
639 
640         _beforeTokenTransfer(sender, recipient, amount);
641 
642         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
643         _balances[recipient] = _balances[recipient].add(amount);
644         emit Transfer(sender, recipient, amount);
645     }
646 
647     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
648      * the total supply.
649      *
650      * Emits a {Transfer} event with `from` set to the zero address.
651      *
652      * Requirements
653      *
654      * - `to` cannot be the zero address.
655      */
656     function _mint(address account, uint256 amount) internal virtual {
657         require(account != address(0), "ERC20: mint to the zero address");
658 
659         _beforeTokenTransfer(address(0), account, amount);
660 
661         _totalSupply = _totalSupply.add(amount);
662         _balances[account] = _balances[account].add(amount);
663         emit Transfer(address(0), account, amount);
664     }
665 
666     /**
667      * @dev Destroys `amount` tokens from `account`, reducing the
668      * total supply.
669      *
670      * Emits a {Transfer} event with `to` set to the zero address.
671      *
672      * Requirements
673      *
674      * - `account` cannot be the zero address.
675      * - `account` must have at least `amount` tokens.
676      */
677     function _burn(address account, uint256 amount) internal virtual {
678         require(account != address(0), "ERC20: burn from the zero address");
679 
680         _beforeTokenTransfer(account, address(0), amount);
681 
682         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
683         _totalSupply = _totalSupply.sub(amount);
684         emit Transfer(account, address(0), amount);
685     }
686 
687     /**
688      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
689      *
690      * This internal function is equivalent to `approve`, and can be used to
691      * e.g. set automatic allowances for certain subsystems, etc.
692      *
693      * Emits an {Approval} event.
694      *
695      * Requirements:
696      *
697      * - `owner` cannot be the zero address.
698      * - `spender` cannot be the zero address.
699      */
700     function _approve(address owner, address spender, uint256 amount) internal virtual {
701         require(owner != address(0), "ERC20: approve from the zero address");
702         require(spender != address(0), "ERC20: approve to the zero address");
703 
704         _allowances[owner][spender] = amount;
705         emit Approval(owner, spender, amount);
706     }
707 
708     /**
709      * @dev Sets {decimals} to a value other than the default one of 18.
710      *
711      * WARNING: This function should only be called from the constructor. Most
712      * applications that interact with token contracts will not expect
713      * {decimals} to ever change, and may work incorrectly if it does.
714      */
715     function _setupDecimals(uint8 decimals_) internal {
716         _decimals = decimals_;
717     }
718 
719     /**
720      * @dev Hook that is called before any transfer of tokens. This includes
721      * minting and burning.
722      *
723      * Calling conditions:
724      *
725      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
726      * will be to transferred to `to`.
727      * - when `from` is zero, `amount` tokens will be minted for `to`.
728      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
729      * - `from` and `to` are never both zero.
730      *
731      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
732      */
733     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
734 }
735 
736 /**
737  * @title SafeERC20
738  * @dev Wrappers around ERC20 operations that throw on failure (when the token
739  * contract returns false). Tokens that return no value (and instead revert or
740  * throw on failure) are also supported, non-reverting calls are assumed to be
741  * successful.
742  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
743  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
744  */
745 library SafeERC20 {
746     using SafeMath for uint256;
747     using Address for address;
748 
749     function safeTransfer(IERC20 token, address to, uint256 value) internal {
750         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
751     }
752 
753     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
754         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
755     }
756 
757     /**
758      * @dev Deprecated. This function has issues similar to the ones found in
759      * {IERC20-approve}, and its usage is discouraged.
760      *
761      * Whenever possible, use {safeIncreaseAllowance} and
762      * {safeDecreaseAllowance} instead.
763      */
764     function safeApprove(IERC20 token, address spender, uint256 value) internal {
765         // safeApprove should only be called when setting an initial allowance,
766         // or when resetting it to zero. To increase and decrease it, use
767         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
768         // solhint-disable-next-line max-line-length
769         require((value == 0) || (token.allowance(address(this), spender) == 0),
770             "SafeERC20: approve from non-zero to non-zero allowance"
771         );
772         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
773     }
774 
775     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
776         uint256 newAllowance = token.allowance(address(this), spender).add(value);
777         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
778     }
779 
780     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
781         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
782         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
783     }
784 
785     /**
786      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
787      * on the return value: the return value is optional (but if data is returned, it must not be false).
788      * @param token The token targeted by the call.
789      * @param data The call data (encoded using abi.encode or one of its variants).
790      */
791     function _callOptionalReturn(IERC20 token, bytes memory data) private {
792         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
793         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
794         // the target address contains contract code and also asserts for success in the low-level call.
795 
796         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
797         if (returndata.length > 0) { // Return data is optional
798             // solhint-disable-next-line max-line-length
799             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
800         }
801     }
802 }
803 ////// src/pickle-jar.sol
804 // https://github.com/iearn-finance/vaults/blob/master/contracts/vaults/yVault.sol
805 
806 /* pragma solidity ^0.6.7; */
807 
808 /* import "./interfaces/controller.sol"; */
809 
810 /* import "./lib/erc20.sol"; */
811 /* import "./lib/safe-math.sol"; */
812 
813 contract PickleJar is ERC20 {
814     using SafeERC20 for IERC20;
815     using Address for address;
816     using SafeMath for uint256;
817 
818     IERC20 public token;
819 
820     uint256 public min = 9500;
821     uint256 public constant max = 10000;
822 
823     address public governance;
824     address public timelock;
825     address public controller;
826 
827     constructor(address _token, address _governance, address _timelock, address _controller)
828         public
829         ERC20(
830             string(abi.encodePacked("pickling ", ERC20(_token).name())),
831             string(abi.encodePacked("p", ERC20(_token).symbol()))
832         )
833     {
834         _setupDecimals(ERC20(_token).decimals());
835         token = IERC20(_token);
836         governance = _governance;
837         timelock = _timelock;
838         controller = _controller;
839     }
840 
841     function balance() public view returns (uint256) {
842         return
843             token.balanceOf(address(this)).add(
844                 IController(controller).balanceOf(address(token))
845             );
846     }
847 
848     function setMin(uint256 _min) external {
849         require(msg.sender == governance, "!governance");
850         min = _min;
851     }
852 
853     function setGovernance(address _governance) public {
854         require(msg.sender == governance, "!governance");
855         governance = _governance;
856     }
857 
858     function setTimelock(address _timelock) public {
859         require(msg.sender == timelock, "!timelock");
860         timelock = _timelock;
861     }
862 
863     function setController(address _controller) public {
864         require(msg.sender == timelock, "!timelock");
865         controller = _controller;
866     }
867 
868     // Custom logic in here for how much the jars allows to be borrowed
869     // Sets minimum required on-hand to keep small withdrawals cheap
870     function available() public view returns (uint256) {
871         return token.balanceOf(address(this)).mul(min).div(max);
872     }
873 
874     function earn() public {
875         uint256 _bal = available();
876         token.safeTransfer(controller, _bal);
877         IController(controller).earn(address(token), _bal);
878     }
879 
880     function depositAll() external {
881         deposit(token.balanceOf(msg.sender));
882     }
883 
884     function deposit(uint256 _amount) public {
885         uint256 _pool = balance();
886         uint256 _before = token.balanceOf(address(this));
887         token.safeTransferFrom(msg.sender, address(this), _amount);
888         uint256 _after = token.balanceOf(address(this));
889         _amount = _after.sub(_before); // Additional check for deflationary tokens
890         uint256 shares = 0;
891         if (totalSupply() == 0) {
892             shares = _amount;
893         } else {
894             shares = (_amount.mul(totalSupply())).div(_pool);
895         }
896         _mint(msg.sender, shares);
897     }
898 
899     function withdrawAll() external {
900         withdraw(balanceOf(msg.sender));
901     }
902 
903     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
904     function harvest(address reserve, uint256 amount) external {
905         require(msg.sender == controller, "!controller");
906         require(reserve != address(token), "token");
907         IERC20(reserve).safeTransfer(controller, amount);
908     }
909 
910     // No rebalance implementation for lower fees and faster swaps
911     function withdraw(uint256 _shares) public {
912         uint256 r = (balance().mul(_shares)).div(totalSupply());
913         _burn(msg.sender, _shares);
914 
915         // Check balance
916         uint256 b = token.balanceOf(address(this));
917         if (b < r) {
918             uint256 _withdraw = r.sub(b);
919             IController(controller).withdraw(address(token), _withdraw);
920             uint256 _after = token.balanceOf(address(this));
921             uint256 _diff = _after.sub(b);
922             if (_diff < _withdraw) {
923                 r = b.add(_diff);
924             }
925         }
926 
927         token.safeTransfer(msg.sender, r);
928     }
929 
930     function getRatio() public view returns (uint256) {
931         return balance().mul(1e18).div(totalSupply());
932     }
933 }
