1 pragma solidity ^0.6.0;
2 
3 /*      
4 
5         ___.                    _____.__                                   
6         \_ |________________  _/ ____\__| ____ _____    ____   ____  ____  
7          | __ \_  __ \_  __ \ \   __\|  |/    \\__  \  /    \_/ ___\/ __ \ 
8          | \_\ \  | \/|  | \/  |  |  |  |   |  \/ __ \|   |  \  \__\  ___/ 
9          |___  /__|   |__|     |__|  |__|___|  (____  /___|  /\___  >___  >
10              \/                              \/     \/     \/     \/    \/ 
11             
12             
13         --------------------------------------------------------------------
14                             https://brr.finance
15         --------------------------------------------------------------------
16         
17                          -- March 25, 2020 --
18  Senate approves $2.2 trillion coronavirus bill aimed at slowing economic free fall
19                         
20                         
21 */
22 
23 // 
24 /*
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with GSN meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address payable) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes memory) {
40         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
41         return msg.data;
42     }
43 }
44 
45 // 
46 /**
47  * @dev Interface of the ERC20 standard as defined in the EIP.
48  */
49 interface IERC20 {
50     /**
51      * @dev Returns the amount of tokens in existence.
52      */
53     function totalSupply() external view returns (uint256);
54 
55     /**
56      * @dev Returns the amount of tokens owned by `account`.
57      */
58     function balanceOf(address account) external view returns (uint256);
59 
60     /**
61      * @dev Moves `amount` tokens from the caller's account to `recipient`.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through {transferFrom}. This is
72      * zero by default.
73      *
74      * This value changes when {approve} or {transferFrom} are called.
75      */
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     /**
79      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * IMPORTANT: Beware that changing an allowance with this method brings the risk
84      * that someone may use both the old and the new allowance by unfortunate
85      * transaction ordering. One possible solution to mitigate this race
86      * condition is to first reduce the spender's allowance to 0 and set the
87      * desired value afterwards:
88      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89      *
90      * Emits an {Approval} event.
91      */
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Moves `amount` tokens from `sender` to `recipient` using the
96      * allowance mechanism. `amount` is then deducted from the caller's
97      * allowance.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Emitted when `value` tokens are moved from one account (`from`) to
107      * another (`to`).
108      *
109      * Note that `value` may be zero.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 value);
112 
113     /**
114      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
115      * a call to {approve}. `value` is the new allowance.
116      */
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // 
121 /**
122  * @dev Wrappers over Solidity's arithmetic operations with added overflow
123  * checks.
124  *
125  * Arithmetic operations in Solidity wrap on overflow. This can easily result
126  * in bugs, because programmers usually assume that an overflow raises an
127  * error, which is the standard behavior in high level programming languages.
128  * `SafeMath` restores this intuition by reverting the transaction when an
129  * operation overflows.
130  *
131  * Using this library instead of the unchecked operations eliminates an entire
132  * class of bugs, so it's recommended to use it always.
133  */
134 library SafeMath {
135     /**
136      * @dev Returns the addition of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `+` operator.
140      *
141      * Requirements:
142      *
143      * - Addition cannot overflow.
144      */
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         require(c >= a, "SafeMath: addition overflow");
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163         return sub(a, b, "SafeMath: subtraction overflow");
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b <= a, errorMessage);
178         uint256 c = a - b;
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      *
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
195         // benefit is lost if 'b' is also tested.
196         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
197         if (a == 0) {
198             return 0;
199         }
200 
201         uint256 c = a * b;
202         require(c / a == b, "SafeMath: multiplication overflow");
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return div(a, b, "SafeMath: division by zero");
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator. Note: this function uses a
228      * `revert` opcode (which leaves remaining gas untouched) while Solidity
229      * uses an invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b > 0, errorMessage);
237         uint256 c = a / b;
238         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return mod(a, b, "SafeMath: modulo by zero");
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts with custom message when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b != 0, errorMessage);
273         return a % b;
274     }
275 }
276 
277 // 
278 /**
279  * @dev Collection of functions related to the address type
280  */
281 library Address {
282     /**
283      * @dev Returns true if `account` is a contract.
284      *
285      * [IMPORTANT]
286      * ====
287      * It is unsafe to assume that an address for which this function returns
288      * false is an externally-owned account (EOA) and not a contract.
289      *
290      * Among others, `isContract` will return false for the following
291      * types of addresses:
292      *
293      *  - an externally-owned account
294      *  - a contract in construction
295      *  - an address where a contract will be created
296      *  - an address where a contract lived, but was destroyed
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
301         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
302         // for accounts without code, i.e. `keccak256('')`
303         bytes32 codehash;
304         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
305         // solhint-disable-next-line no-inline-assembly
306         assembly { codehash := extcodehash(account) }
307         return (codehash != accountHash && codehash != 0x0);
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
330         (bool success, ) = recipient.call{ value: amount }("");
331         require(success, "Address: unable to send value, recipient may have reverted");
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain`call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353       return functionCall(target, data, "Address: low-level call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358      * `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
363         return _functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
388         require(address(this).balance >= value, "Address: insufficient balance for call");
389         return _functionCallWithValue(target, data, value, errorMessage);
390     }
391 
392     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
393         require(isContract(target), "Address: call to non-contract");
394 
395         // solhint-disable-next-line avoid-low-level-calls
396         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403 
404                 // solhint-disable-next-line no-inline-assembly
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 // 
417 /**
418  * @dev Implementation of the {IERC20} interface.
419  *
420  * This implementation is agnostic to the way tokens are created. This means
421  * that a supply mechanism has to be added in a derived contract using {_mint}.
422  * For a generic mechanism see {ERC20PresetMinterPauser}.
423  *
424  * TIP: For a detailed writeup see our guide
425  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
426  * to implement supply mechanisms].
427  *
428  * We have followed general OpenZeppelin guidelines: functions revert instead
429  * of returning `false` on failure. This behavior is nonetheless conventional
430  * and does not conflict with the expectations of ERC20 applications.
431  *
432  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
433  * This allows applications to reconstruct the allowance for all accounts just
434  * by listening to said events. Other implementations of the EIP may not emit
435  * these events, as it isn't required by the specification.
436  *
437  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
438  * functions have been added to mitigate the well-known issues around setting
439  * allowances. See {IERC20-approve}.
440  */
441 contract ERC20 is Context, IERC20 {
442     using SafeMath for uint256;
443     using Address for address;
444 
445     mapping (address => uint256) internal _balances;
446 
447     mapping (address => mapping (address => uint256)) private _allowances;
448 
449     uint256 internal _totalSupply;
450 
451     string private _name;
452     string private _symbol;
453     uint8 private _decimals;
454 
455     /**
456      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
457      * a default value of 18.
458      *
459      * To select a different value for {decimals}, use {_setupDecimals}.
460      *
461      * All three of these values are immutable: they can only be set once during
462      * construction.
463      */
464     constructor (string memory name, string memory symbol) public {
465         _name = name;
466         _symbol = symbol;
467         _decimals = 18;
468     }
469 
470     /**
471      * @dev Returns the name of the token.
472      */
473     function name() public view returns (string memory) {
474         return _name;
475     }
476 
477     /**
478      * @dev Returns the symbol of the token, usually a shorter version of the
479      * name.
480      */
481     function symbol() public view returns (string memory) {
482         return _symbol;
483     }
484 
485     /**
486      * @dev Returns the number of decimals used to get its user representation.
487      * For example, if `decimals` equals `2`, a balance of `505` tokens should
488      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
489      *
490      * Tokens usually opt for a value of 18, imitating the relationship between
491      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
492      * called.
493      *
494      * NOTE: This information is only used for _display_ purposes: it in
495      * no way affects any of the arithmetic of the contract, including
496      * {IERC20-balanceOf} and {IERC20-transfer}.
497      */
498     function decimals() public view returns (uint8) {
499         return _decimals;
500     }
501 
502     /**
503      * @dev See {IERC20-totalSupply}.
504      */
505     function totalSupply() public view override returns (uint256) {
506         return _totalSupply;
507     }
508 
509     /**
510      * @dev See {IERC20-balanceOf}.
511      */
512     function balanceOf(address account) public view override returns (uint256) {
513         return _balances[account];
514     }
515 
516     /**
517      * @dev See {IERC20-transfer}.
518      *
519      * Requirements:
520      *
521      * - `recipient` cannot be the zero address.
522      * - the caller must have a balance of at least `amount`.
523      */
524     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
525         _transfer(_msgSender(), recipient, amount);
526         return true;
527     }
528 
529     /**
530      * @dev See {IERC20-allowance}.
531      */
532     function allowance(address owner, address spender) public view virtual override returns (uint256) {
533         return _allowances[owner][spender];
534     }
535 
536     /**
537      * @dev See {IERC20-approve}.
538      *
539      * Requirements:
540      *
541      * - `spender` cannot be the zero address.
542      */
543     function approve(address spender, uint256 amount) public virtual override returns (bool) {
544         _approve(_msgSender(), spender, amount);
545         return true;
546     }
547 
548     /**
549      * @dev See {IERC20-transferFrom}.
550      *
551      * Emits an {Approval} event indicating the updated allowance. This is not
552      * required by the EIP. See the note at the beginning of {ERC20};
553      *
554      * Requirements:
555      * - `sender` and `recipient` cannot be the zero address.
556      * - `sender` must have a balance of at least `amount`.
557      * - the caller must have allowance for ``sender``'s tokens of at least
558      * `amount`.
559      */
560     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
561         _transfer(sender, recipient, amount);
562         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
563         return true;
564     }
565 
566     /**
567      * @dev Atomically increases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      */
578     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
580         return true;
581     }
582 
583     /**
584      * @dev Atomically decreases the allowance granted to `spender` by the caller.
585      *
586      * This is an alternative to {approve} that can be used as a mitigation for
587      * problems described in {IERC20-approve}.
588      *
589      * Emits an {Approval} event indicating the updated allowance.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      * - `spender` must have allowance for the caller of at least
595      * `subtractedValue`.
596      */
597     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
598         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
599         return true;
600     }
601 
602     /**
603      * @dev Moves tokens `amount` from `sender` to `recipient`.
604      *
605      * This is internal function is equivalent to {transfer}, and can be used to
606      * e.g. implement automatic token fees, slashing mechanisms, etc.
607      *
608      * Emits a {Transfer} event.
609      *
610      * Requirements:
611      *
612      * - `sender` cannot be the zero address.
613      * - `recipient` cannot be the zero address.
614      * - `sender` must have a balance of at least `amount`.
615      */
616     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
617         require(sender != address(0), "ERC20: transfer from the zero address");
618         require(recipient != address(0), "ERC20: transfer to the zero address");
619 
620         _beforeTokenTransfer(sender, recipient, amount);
621 
622         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
623         _balances[recipient] = _balances[recipient].add(amount);
624         emit Transfer(sender, recipient, amount);
625     }
626 
627     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
628      * the total supply.
629      *
630      * Emits a {Transfer} event with `from` set to the zero address.
631      *
632      * Requirements
633      *
634      * - `to` cannot be the zero address.
635      */
636     function _mint(address account, uint256 amount) internal virtual {
637         require(account != address(0), "ERC20: mint to the zero address");
638 
639         _beforeTokenTransfer(address(0), account, amount);
640 
641         _totalSupply = _totalSupply.add(amount);
642         _balances[account] = _balances[account].add(amount);
643         emit Transfer(address(0), account, amount);
644     }
645 
646     /**
647      * @dev Destroys `amount` tokens from `account`, reducing the
648      * total supply.
649      *
650      * Emits a {Transfer} event with `to` set to the zero address.
651      *
652      * Requirements
653      *
654      * - `account` cannot be the zero address.
655      * - `account` must have at least `amount` tokens.
656      */
657     function _burn(address account, uint256 amount) internal virtual {
658         require(account != address(0), "ERC20: burn from the zero address");
659 
660         _beforeTokenTransfer(account, address(0), amount);
661 
662         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
663         _totalSupply = _totalSupply.sub(amount);
664         emit Transfer(account, address(0), amount);
665     }
666 
667     /**
668      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
669      *
670      * This is internal function is equivalent to `approve`, and can be used to
671      * e.g. set automatic allowances for certain subsystems, etc.
672      *
673      * Emits an {Approval} event.
674      *
675      * Requirements:
676      *
677      * - `owner` cannot be the zero address.
678      * - `spender` cannot be the zero address.
679      */
680     function _approve(address owner, address spender, uint256 amount) internal virtual {
681         require(owner != address(0), "ERC20: approve from the zero address");
682         require(spender != address(0), "ERC20: approve to the zero address");
683 
684         _allowances[owner][spender] = amount;
685         emit Approval(owner, spender, amount);
686     }
687 
688     /**
689      * @dev Sets {decimals} to a value other than the default one of 18.
690      *
691      * WARNING: This function should only be called from the constructor. Most
692      * applications that interact with token contracts will not expect
693      * {decimals} to ever change, and may work incorrectly if it does.
694      */
695     function _setupDecimals(uint8 decimals_) internal {
696         _decimals = decimals_;
697     }
698 
699     /**
700      * @dev Hook that is called before any transfer of tokens. This includes
701      * minting and burning.
702      *
703      * Calling conditions:
704      *
705      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
706      * will be to transferred to `to`.
707      * - when `from` is zero, `amount` tokens will be minted for `to`.
708      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
709      * - `from` and `to` are never both zero.
710      *
711      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
712      */
713     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
714 }
715 
716 // 
717 /**
718  * @dev Contract module which provides a basic access control mechanism, where
719  * there is an account (an owner) that can be granted exclusive access to
720  * specific functions.
721  *
722  * By default, the owner account will be the one that deploys the contract. This
723  * can later be changed with {transferOwnership}.
724  *
725  * This module is used through inheritance. It will make available the modifier
726  * `onlyOwner`, which can be applied to your functions to restrict their use to
727  * the owner.
728  */
729 contract Ownable is Context {
730     address private _owner;
731 
732     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
733 
734     /**
735      * @dev Initializes the contract setting the deployer as the initial owner.
736      */
737     constructor () internal {
738         address msgSender = _msgSender();
739         _owner = msgSender;
740         emit OwnershipTransferred(address(0), msgSender);
741     }
742 
743     /**
744      * @dev Returns the address of the current owner.
745      */
746     function owner() public view returns (address) {
747         return _owner;
748     }
749 
750     /**
751      * @dev Throws if called by any account other than the owner.
752      */
753     modifier onlyOwner() {
754         require(_owner == _msgSender(), "Ownable: caller is not the owner");
755         _;
756     }
757 
758     /**
759      * @dev Leaves the contract without owner. It will not be possible to call
760      * `onlyOwner` functions anymore. Can only be called by the current owner.
761      *
762      * NOTE: Renouncing ownership will leave the contract without an owner,
763      * thereby removing any functionality that is only available to the owner.
764      */
765     function renounceOwnership() public virtual onlyOwner {
766         emit OwnershipTransferred(_owner, address(0));
767         _owner = address(0);
768     }
769 
770     /**
771      * @dev Transfers ownership of the contract to a new account (`newOwner`).
772      * Can only be called by the current owner.
773      */
774     function transferOwnership(address newOwner) public virtual onlyOwner {
775         require(newOwner != address(0), "Ownable: new owner is the zero address");
776         emit OwnershipTransferred(_owner, newOwner);
777         _owner = newOwner;
778     }
779 }
780 
781 // 
782 interface IUniswapV2Pair {
783     function sync() external;
784 }
785 
786 interface IUniswapV2Factory {
787     function createPair(address tokenA, address tokenB) external returns (address pair);
788 }
789 
790 /*      
791 
792     ___.                    _____.__                                   
793     \_ |________________  _/ ____\__| ____ _____    ____   ____  ____  
794      | __ \_  __ \_  __ \ \   __\|  |/    \\__  \  /    \_/ ___\/ __ \ 
795      | \_\ \  | \/|  | \/  |  |  |  |   |  \/ __ \|   |  \  \__\  ___/ 
796      |___  /__|   |__|     |__|  |__|___|  (____  /___|  /\___  >___  >
797          \/                              \/     \/     \/     \/    \/ 
798             
799         
800     --------------------------------------------------------------------
801                         https://www.brr.finance
802     --------------------------------------------------------------------
803                         
804                         
805 */
806 contract BrrToken is ERC20, Ownable {
807     using SafeMath for uint256;
808 
809     // BRR
810 
811     uint256 public lastBrrTime;
812 
813     uint256 public totalBrred;
814 
815     uint256 public constant BRR_RATE = 4; // brr rate per day (4%)
816 
817     uint256 public constant BRR_REWARD = 1;
818 
819     // REWARDS
820 
821     uint256 public constant POOL_REWARD = 48;
822 
823     uint256 public lastRewardTime;
824 
825     uint256 public rewardPool;
826 
827     mapping (address => uint256) public claimedRewards;
828 
829     mapping (address => uint256) public unclaimedRewards;
830 
831     // mapping of top holders that owner update before paying out rewards
832     mapping (uint256 => address) public topHolder;
833 
834     // maximum of top topHolder
835     uint256 public constant MAX_TOP_HOLDERS = 50;
836 
837     uint256 internal totalTopHolders;
838 
839     // Pause for allowing tokens to only become transferable at the end of sale
840 
841     address public pauser;
842 
843     bool public paused;
844 
845     // UNISWAP
846 
847     ERC20 internal WETH = ERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
848 
849     IUniswapV2Factory public uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
850 
851     address public uniswapPool;
852 
853     // MODIFIERS
854 
855     modifier onlyPauser() {
856         require(pauser == _msgSender(), "BrrToken: caller is not the pauser.");
857         _;
858     }
859 
860     modifier whenNotPaused() {
861         require(!paused, "BrrToken: paused");
862         _;
863     }
864 
865     modifier when3DaysBetweenLastSnapshot() {
866         require((now - lastRewardTime) >= 3 days, "BrrToken: not enough days since last snapshot taken.");
867         _;
868     }
869 
870     // EVENTS
871 
872     event PoolBrred(address brrer, uint256 brrAmount, uint256 newTotalSupply, uint256 newUniswapPoolSupply, uint256 userReward, uint256 newPoolReward);
873 
874     event PayoutSnapshotTaken(uint256 totalTopHolders, uint256 totalPayout, uint256 snapshot);
875 
876     event PayoutClaimed(address indexed topHolderAddress, uint256 claimedReward);
877 
878     constructor()
879     public
880     Ownable()
881     ERC20("Brr Token", "BRR")
882     {
883         /*
884         
885             -- March 25, 2020 --
886             Senate approves $2.2 trillion coronavirus bill aimed at slowing economic free fall
887             
888         */
889         uint256 initialSupply = 2_200_000_000_000 * 1e18;
890         _mint(msg.sender, initialSupply);
891         setPauser(msg.sender);
892         paused = true;
893     }
894 
895     function setUniswapPool() external onlyOwner {
896         require(uniswapPool == address(0), "BrrToken: pool already created");
897         uniswapPool = uniswapFactory.createPair(address(WETH), address(this));
898     }
899 
900     // PAUSE
901 
902     function setPauser(address newPauser) public onlyOwner {
903         require(newPauser != address(0), "BrrToken: pauser is the zero address.");
904         pauser = newPauser;
905     }
906 
907     function unpause() external onlyPauser {
908         paused = false;
909 
910         // Start brring
911         lastBrrTime = now;
912         lastRewardTime = now;
913         rewardPool = 0;
914     }
915 
916     // TOKEN TRANSFER HOOK
917 
918     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
919         super._beforeTokenTransfer(from, to, amount);
920         require(!paused || msg.sender == pauser, "BrrToken: token transfer while paused and not pauser role.");
921     }
922 
923     // BRRERS
924 
925     function getInfoFor(address addr) public view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
926         return (
927             balanceOf(addr),
928             claimedRewards[addr],
929             balanceOf(uniswapPool),
930             _totalSupply,
931             totalBrred,
932             getBrrAmount(),
933             lastBrrTime,
934             lastRewardTime,
935             rewardPool
936         );
937     }
938 
939     function brrPool() external {
940         uint256 brrAmount = getBrrAmount();
941         require(brrAmount >= 1 * 1e18, "brrPool: min brr amount not reached.");
942 
943         // Reset last brr time
944         lastBrrTime = now;
945 
946         uint256 userReward = brrAmount.mul(BRR_REWARD).div(100);
947         uint256 poolReward = brrAmount.mul(POOL_REWARD).div(100);
948         uint256 finalBrr = brrAmount.sub(userReward).sub(poolReward);
949 
950         _totalSupply = _totalSupply.sub(finalBrr);
951         _balances[uniswapPool] = _balances[uniswapPool].sub(brrAmount);
952 
953         totalBrred = totalBrred.add(finalBrr);
954         rewardPool = rewardPool.add(poolReward);
955 
956         _balances[msg.sender] = _balances[msg.sender].add(userReward);
957 
958         IUniswapV2Pair(uniswapPool).sync();
959 
960         emit PoolBrred(msg.sender, brrAmount, _totalSupply, balanceOf(uniswapPool), userReward, poolReward);
961     }
962 
963     function getBrrAmount() public view returns (uint256) {
964         if (paused) return 0;
965         uint256 timeBetweenLastBrr = now - lastBrrTime;
966         uint256 tokensInUniswapPool = balanceOf(uniswapPool);
967         uint256 dayInSeconds = 1 days;
968         return (tokensInUniswapPool.mul(BRR_RATE)
969             .mul(timeBetweenLastBrr))
970             .div(dayInSeconds)
971             .div(100);
972     }
973 
974     // Rewards
975 
976     function updateTopHolders(address[] calldata holders) external onlyOwner when3DaysBetweenLastSnapshot {
977         totalTopHolders = holders.length < MAX_TOP_HOLDERS ? holders.length : MAX_TOP_HOLDERS;
978 
979         // Calculate payout and take snapshot
980         uint256 toPayout = rewardPool.div(totalTopHolders);
981         uint256 totalPayoutSent = rewardPool;
982         for (uint256 i = 0; i < totalTopHolders; i++) {
983             unclaimedRewards[holders[i]] = unclaimedRewards[holders[i]].add(toPayout);
984         }
985 
986         // Reset rewards pool
987         lastRewardTime = now;
988         rewardPool = 0;
989 
990         emit PayoutSnapshotTaken(totalTopHolders, totalPayoutSent, now);
991     }
992 
993     function claimRewards() external {
994         require(unclaimedRewards[msg.sender] > 0, "BrrToken: nothing left to claim.");
995 
996         uint256 unclaimedReward = unclaimedRewards[msg.sender];
997         unclaimedRewards[msg.sender] = 0;
998         claimedRewards[msg.sender] = claimedRewards[msg.sender].add(unclaimedReward);
999         _balances[msg.sender] = _balances[msg.sender].add(unclaimedReward);
1000 
1001         emit PayoutClaimed(msg.sender, unclaimedReward);
1002     }
1003 }