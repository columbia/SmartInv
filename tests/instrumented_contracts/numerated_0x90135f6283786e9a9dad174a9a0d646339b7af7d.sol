1 /*
2   ___ ___ ._______________________________                          
3  /   |   \|   \______   \______   \_____  \                         
4 /    ~    \   ||     ___/|     ___//   |   \                        
5 \    Y    /   ||    |    |    |   /    |    \                       
6  \___|_  /|___||____|    |____|   \_______  /                       
7        \/                                 \/                        
8 ___________.___ _______      _____    _______  _________ ___________
9 \_   _____/|   |\      \    /  _  \   \      \ \_   ___ \\_   _____/
10  |    __)  |   |/   |   \  /  /_\  \  /   |   \/    \  \/ |    __)_ 
11  |     \   |   /    |    \/    |    \/    |    \     \____|        \
12  \___  /   |___\____|__  /\____|__  /\____|__  /\______  /_______  /
13      \/                \/         \/         \/        \/        \/ 
14 */
15 
16 // SPDX-License-Identifier: MIT
17 // File: @openzeppelin/contracts/GSN/Context.sol
18 
19 
20 
21 pragma solidity ^0.6.0;
22 
23 /*
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with GSN meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address payable) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes memory) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
45 
46 
47 
48 pragma solidity ^0.6.0;
49 
50 /**
51  * @dev Interface of the ERC20 standard as defined in the EIP.
52  */
53 interface IERC20 {
54     /**
55      * @dev Returns the amount of tokens in existence.
56      */
57     function totalSupply() external view returns (uint256);
58 
59     /**
60      * @dev Returns the amount of tokens owned by `account`.
61      */
62     function balanceOf(address account) external view returns (uint256);
63 
64     /**
65      * @dev Moves `amount` tokens from the caller's account to `recipient`.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transfer(address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Returns the remaining number of tokens that `spender` will be
75      * allowed to spend on behalf of `owner` through {transferFrom}. This is
76      * zero by default.
77      *
78      * This value changes when {approve} or {transferFrom} are called.
79      */
80     function allowance(address owner, address spender) external view returns (uint256);
81 
82     /**
83      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * IMPORTANT: Beware that changing an allowance with this method brings the risk
88      * that someone may use both the old and the new allowance by unfortunate
89      * transaction ordering. One possible solution to mitigate this race
90      * condition is to first reduce the spender's allowance to 0 and set the
91      * desired value afterwards:
92      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
93      *
94      * Emits an {Approval} event.
95      */
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Moves `amount` tokens from `sender` to `recipient` using the
100      * allowance mechanism. `amount` is then deducted from the caller's
101      * allowance.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
108 
109     /**
110      * @dev Emitted when `value` tokens are moved from one account (`from`) to
111      * another (`to`).
112      *
113      * Note that `value` may be zero.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 
117     /**
118      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
119      * a call to {approve}. `value` is the new allowance.
120      */
121     event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 // File: @openzeppelin/contracts/math/SafeMath.sol
125 
126 
127 
128 pragma solidity ^0.6.0;
129 
130 /**
131  * @dev Wrappers over Solidity's arithmetic operations with added overflow
132  * checks.
133  *
134  * Arithmetic operations in Solidity wrap on overflow. This can easily result
135  * in bugs, because programmers usually assume that an overflow raises an
136  * error, which is the standard behavior in high level programming languages.
137  * `SafeMath` restores this intuition by reverting the transaction when an
138  * operation overflows.
139  *
140  * Using this library instead of the unchecked operations eliminates an entire
141  * class of bugs, so it's recommended to use it always.
142  */
143 library SafeMath {
144     /**
145      * @dev Returns the addition of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `+` operator.
149      *
150      * Requirements:
151      *
152      * - Addition cannot overflow.
153      */
154     function add(uint256 a, uint256 b) internal pure returns (uint256) {
155         uint256 c = a + b;
156         require(c >= a, "SafeMath: addition overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
172         return sub(a, b, "SafeMath: subtraction overflow");
173     }
174 
175     /**
176      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
177      * overflow (when the result is negative).
178      *
179      * Counterpart to Solidity's `-` operator.
180      *
181      * Requirements:
182      *
183      * - Subtraction cannot overflow.
184      */
185     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
186         require(b <= a, errorMessage);
187         uint256 c = a - b;
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the multiplication of two unsigned integers, reverting on
194      * overflow.
195      *
196      * Counterpart to Solidity's `*` operator.
197      *
198      * Requirements:
199      *
200      * - Multiplication cannot overflow.
201      */
202     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
203         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
204         // benefit is lost if 'b' is also tested.
205         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
206         if (a == 0) {
207             return 0;
208         }
209 
210         uint256 c = a * b;
211         require(c / a == b, "SafeMath: multiplication overflow");
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b) internal pure returns (uint256) {
229         return div(a, b, "SafeMath: division by zero");
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
244     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
245         require(b > 0, errorMessage);
246         uint256 c = a / b;
247         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
265         return mod(a, b, "SafeMath: modulo by zero");
266     }
267 
268     /**
269      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270      * Reverts with custom message when dividing by zero.
271      *
272      * Counterpart to Solidity's `%` operator. This function uses a `revert`
273      * opcode (which leaves remaining gas untouched) while Solidity uses an
274      * invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         require(b != 0, errorMessage);
282         return a % b;
283     }
284 }
285 
286 // File: @openzeppelin/contracts/utils/Address.sol
287 
288 
289 
290 pragma solidity ^0.6.2;
291 
292 /**
293  * @dev Collection of functions related to the address type
294  */
295 library Address {
296     /**
297      * @dev Returns true if `account` is a contract.
298      *
299      * [IMPORTANT]
300      * ====
301      * It is unsafe to assume that an address for which this function returns
302      * false is an externally-owned account (EOA) and not a contract.
303      *
304      * Among others, `isContract` will return false for the following
305      * types of addresses:
306      *
307      *  - an externally-owned account
308      *  - a contract in construction
309      *  - an address where a contract will be created
310      *  - an address where a contract lived, but was destroyed
311      * ====
312      */
313     function isContract(address account) internal view returns (bool) {
314         // This method relies in extcodesize, which returns 0 for contracts in
315         // construction, since the code is only stored at the end of the
316         // constructor execution.
317 
318         uint256 size;
319         // solhint-disable-next-line no-inline-assembly
320         assembly { size := extcodesize(account) }
321         return size > 0;
322     }
323 
324     /**
325      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
326      * `recipient`, forwarding all available gas and reverting on errors.
327      *
328      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
329      * of certain opcodes, possibly making contracts go over the 2300 gas limit
330      * imposed by `transfer`, making them unable to receive funds via
331      * `transfer`. {sendValue} removes this limitation.
332      *
333      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
334      *
335      * IMPORTANT: because control is transferred to `recipient`, care must be
336      * taken to not create reentrancy vulnerabilities. Consider using
337      * {ReentrancyGuard} or the
338      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
339      */
340     function sendValue(address payable recipient, uint256 amount) internal {
341         require(address(this).balance >= amount, "Address: insufficient balance");
342 
343         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
344         (bool success, ) = recipient.call{ value: amount }("");
345         require(success, "Address: unable to send value, recipient may have reverted");
346     }
347 
348     /**
349      * @dev Performs a Solidity function call using a low level `call`. A
350      * plain`call` is an unsafe replacement for a function call: use this
351      * function instead.
352      *
353      * If `target` reverts with a revert reason, it is bubbled up by this
354      * function (like regular Solidity function calls).
355      *
356      * Returns the raw returned data. To convert to the expected return value,
357      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
358      *
359      * Requirements:
360      *
361      * - `target` must be a contract.
362      * - calling `target` with `data` must not revert.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
367       return functionCall(target, data, "Address: low-level call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
372      * `errorMessage` as a fallback revert reason when `target` reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
377         return _functionCallWithValue(target, data, 0, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but also transferring `value` wei to `target`.
383      *
384      * Requirements:
385      *
386      * - the calling contract must have an ETH balance of at least `value`.
387      * - the called Solidity function must be `payable`.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
392         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
397      * with `errorMessage` as a fallback revert reason when `target` reverts.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
402         require(address(this).balance >= value, "Address: insufficient balance for call");
403         return _functionCallWithValue(target, data, value, errorMessage);
404     }
405 
406     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
407         require(isContract(target), "Address: call to non-contract");
408 
409         // solhint-disable-next-line avoid-low-level-calls
410         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
411         if (success) {
412             return returndata;
413         } else {
414             // Look for revert reason and bubble it up if present
415             if (returndata.length > 0) {
416                 // The easiest way to bubble the revert reason is using memory via assembly
417 
418                 // solhint-disable-next-line no-inline-assembly
419                 assembly {
420                     let returndata_size := mload(returndata)
421                     revert(add(32, returndata), returndata_size)
422                 }
423             } else {
424                 revert(errorMessage);
425             }
426         }
427     }
428 }
429 
430 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
431 
432 
433 
434 pragma solidity ^0.6.0;
435 
436 
437 
438 
439 
440 /**
441  * @dev Implementation of the {IERC20} interface.
442  *
443  * This implementation is agnostic to the way tokens are created. This means
444  * that a supply mechanism has to be added in a derived contract using {_mint}.
445  * For a generic mechanism see {ERC20PresetMinterPauser}.
446  *
447  * TIP: For a detailed writeup see our guide
448  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
449  * to implement supply mechanisms].
450  *
451  * We have followed general OpenZeppelin guidelines: functions revert instead
452  * of returning `false` on failure. This behavior is nonetheless conventional
453  * and does not conflict with the expectations of ERC20 applications.
454  *
455  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
456  * This allows applications to reconstruct the allowance for all accounts just
457  * by listening to said events. Other implementations of the EIP may not emit
458  * these events, as it isn't required by the specification.
459  *
460  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
461  * functions have been added to mitigate the well-known issues around setting
462  * allowances. See {IERC20-approve}.
463  */
464 contract ERC20 is Context, IERC20 {
465     using SafeMath for uint256;
466     using Address for address;
467 
468     mapping (address => uint256) private _balances;
469 
470     mapping (address => mapping (address => uint256)) private _allowances;
471 
472     uint256 private _totalSupply;
473 
474     string private _name;
475     string private _symbol;
476     uint8 private _decimals;
477 
478     /**
479      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
480      * a default value of 18.
481      *
482      * To select a different value for {decimals}, use {_setupDecimals}.
483      *
484      * All three of these values are immutable: they can only be set once during
485      * construction.
486      */
487     constructor (string memory name, string memory symbol) public {
488         _name = name;
489         _symbol = symbol;
490         _decimals = 18;
491     }
492 
493     /**
494      * @dev Returns the name of the token.
495      */
496     function name() public view returns (string memory) {
497         return _name;
498     }
499 
500     /**
501      * @dev Returns the symbol of the token, usually a shorter version of the
502      * name.
503      */
504     function symbol() public view returns (string memory) {
505         return _symbol;
506     }
507 
508     /**
509      * @dev Returns the number of decimals used to get its user representation.
510      * For example, if `decimals` equals `2`, a balance of `505` tokens should
511      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
512      *
513      * Tokens usually opt for a value of 18, imitating the relationship between
514      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
515      * called.
516      *
517      * NOTE: This information is only used for _display_ purposes: it in
518      * no way affects any of the arithmetic of the contract, including
519      * {IERC20-balanceOf} and {IERC20-transfer}.
520      */
521     function decimals() public view returns (uint8) {
522         return _decimals;
523     }
524 
525     /**
526      * @dev See {IERC20-totalSupply}.
527      */
528     function totalSupply() public view override returns (uint256) {
529         return _totalSupply;
530     }
531 
532     /**
533      * @dev See {IERC20-balanceOf}.
534      */
535     function balanceOf(address account) public view override returns (uint256) {
536         return _balances[account];
537     }
538 
539     /**
540      * @dev See {IERC20-transfer}.
541      *
542      * Requirements:
543      *
544      * - `recipient` cannot be the zero address.
545      * - the caller must have a balance of at least `amount`.
546      */
547     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
548         _transfer(_msgSender(), recipient, amount);
549         return true;
550     }
551 
552     /**
553      * @dev See {IERC20-allowance}.
554      */
555     function allowance(address owner, address spender) public view virtual override returns (uint256) {
556         return _allowances[owner][spender];
557     }
558 
559     /**
560      * @dev See {IERC20-approve}.
561      *
562      * Requirements:
563      *
564      * - `spender` cannot be the zero address.
565      */
566     function approve(address spender, uint256 amount) public virtual override returns (bool) {
567         _approve(_msgSender(), spender, amount);
568         return true;
569     }
570 
571     /**
572      * @dev See {IERC20-transferFrom}.
573      *
574      * Emits an {Approval} event indicating the updated allowance. This is not
575      * required by the EIP. See the note at the beginning of {ERC20};
576      *
577      * Requirements:
578      * - `sender` and `recipient` cannot be the zero address.
579      * - `sender` must have a balance of at least `amount`.
580      * - the caller must have allowance for ``sender``'s tokens of at least
581      * `amount`.
582      */
583     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
584         _transfer(sender, recipient, amount);
585         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
586         return true;
587     }
588 
589     /**
590      * @dev Atomically increases the allowance granted to `spender` by the caller.
591      *
592      * This is an alternative to {approve} that can be used as a mitigation for
593      * problems described in {IERC20-approve}.
594      *
595      * Emits an {Approval} event indicating the updated allowance.
596      *
597      * Requirements:
598      *
599      * - `spender` cannot be the zero address.
600      */
601     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
602         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
603         return true;
604     }
605 
606     /**
607      * @dev Atomically decreases the allowance granted to `spender` by the caller.
608      *
609      * This is an alternative to {approve} that can be used as a mitigation for
610      * problems described in {IERC20-approve}.
611      *
612      * Emits an {Approval} event indicating the updated allowance.
613      *
614      * Requirements:
615      *
616      * - `spender` cannot be the zero address.
617      * - `spender` must have allowance for the caller of at least
618      * `subtractedValue`.
619      */
620     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
621         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
622         return true;
623     }
624 
625     /**
626      * @dev Moves tokens `amount` from `sender` to `recipient`.
627      *
628      * This is internal function is equivalent to {transfer}, and can be used to
629      * e.g. implement automatic token fees, slashing mechanisms, etc.
630      *
631      * Emits a {Transfer} event.
632      *
633      * Requirements:
634      *
635      * - `sender` cannot be the zero address.
636      * - `recipient` cannot be the zero address.
637      * - `sender` must have a balance of at least `amount`.
638      */
639     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
640         require(sender != address(0), "ERC20: transfer from the zero address");
641         require(recipient != address(0), "ERC20: transfer to the zero address");
642 
643         _beforeTokenTransfer(sender, recipient, amount);
644 
645         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
646         _balances[recipient] = _balances[recipient].add(amount);
647         emit Transfer(sender, recipient, amount);
648     }
649 
650     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
651      * the total supply.
652      *
653      * Emits a {Transfer} event with `from` set to the zero address.
654      *
655      * Requirements
656      *
657      * - `to` cannot be the zero address.
658      */
659     function _mint(address account, uint256 amount) internal virtual {
660         require(account != address(0), "ERC20: mint to the zero address");
661 
662         _beforeTokenTransfer(address(0), account, amount);
663 
664         _totalSupply = _totalSupply.add(amount);
665         _balances[account] = _balances[account].add(amount);
666         emit Transfer(address(0), account, amount);
667     }
668 
669     /**
670      * @dev Destroys `amount` tokens from `account`, reducing the
671      * total supply.
672      *
673      * Emits a {Transfer} event with `to` set to the zero address.
674      *
675      * Requirements
676      *
677      * - `account` cannot be the zero address.
678      * - `account` must have at least `amount` tokens.
679      */
680     function _burn(address account, uint256 amount) internal virtual {
681         require(account != address(0), "ERC20: burn from the zero address");
682 
683         _beforeTokenTransfer(account, address(0), amount);
684 
685         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
686         _totalSupply = _totalSupply.sub(amount);
687         emit Transfer(account, address(0), amount);
688     }
689 
690     /**
691      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
692      *
693      * This internal function is equivalent to `approve`, and can be used to
694      * e.g. set automatic allowances for certain subsystems, etc.
695      *
696      * Emits an {Approval} event.
697      *
698      * Requirements:
699      *
700      * - `owner` cannot be the zero address.
701      * - `spender` cannot be the zero address.
702      */
703     function _approve(address owner, address spender, uint256 amount) internal virtual {
704         require(owner != address(0), "ERC20: approve from the zero address");
705         require(spender != address(0), "ERC20: approve to the zero address");
706 
707         _allowances[owner][spender] = amount;
708         emit Approval(owner, spender, amount);
709     }
710 
711     /**
712      * @dev Sets {decimals} to a value other than the default one of 18.
713      *
714      * WARNING: This function should only be called from the constructor. Most
715      * applications that interact with token contracts will not expect
716      * {decimals} to ever change, and may work incorrectly if it does.
717      */
718     function _setupDecimals(uint8 decimals_) internal {
719         _decimals = decimals_;
720     }
721 
722     /**
723      * @dev Hook that is called before any transfer of tokens. This includes
724      * minting and burning.
725      *
726      * Calling conditions:
727      *
728      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
729      * will be to transferred to `to`.
730      * - when `from` is zero, `amount` tokens will be minted for `to`.
731      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
732      * - `from` and `to` are never both zero.
733      *
734      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
735      */
736     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
737 }
738 
739 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
740 
741 
742 
743 pragma solidity ^0.6.0;
744 
745 
746 
747 
748 /**
749  * @title SafeERC20
750  * @dev Wrappers around ERC20 operations that throw on failure (when the token
751  * contract returns false). Tokens that return no value (and instead revert or
752  * throw on failure) are also supported, non-reverting calls are assumed to be
753  * successful.
754  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
755  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
756  */
757 library SafeERC20 {
758     using SafeMath for uint256;
759     using Address for address;
760 
761     function safeTransfer(IERC20 token, address to, uint256 value) internal {
762         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
763     }
764 
765     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
766         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
767     }
768 
769     /**
770      * @dev Deprecated. This function has issues similar to the ones found in
771      * {IERC20-approve}, and its usage is discouraged.
772      *
773      * Whenever possible, use {safeIncreaseAllowance} and
774      * {safeDecreaseAllowance} instead.
775      */
776     function safeApprove(IERC20 token, address spender, uint256 value) internal {
777         // safeApprove should only be called when setting an initial allowance,
778         // or when resetting it to zero. To increase and decrease it, use
779         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
780         // solhint-disable-next-line max-line-length
781         require((value == 0) || (token.allowance(address(this), spender) == 0),
782             "SafeERC20: approve from non-zero to non-zero allowance"
783         );
784         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
785     }
786 
787     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
788         uint256 newAllowance = token.allowance(address(this), spender).add(value);
789         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
790     }
791 
792     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
793         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
794         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
795     }
796 
797     /**
798      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
799      * on the return value: the return value is optional (but if data is returned, it must not be false).
800      * @param token The token targeted by the call.
801      * @param data The call data (encoded using abi.encode or one of its variants).
802      */
803     function _callOptionalReturn(IERC20 token, bytes memory data) private {
804         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
805         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
806         // the target address contains contract code and also asserts for success in the low-level call.
807 
808         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
809         if (returndata.length > 0) { // Return data is optional
810             // solhint-disable-next-line max-line-length
811             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
812         }
813     }
814 }
815 
816 // File: @openzeppelin/contracts/access/Ownable.sol
817 
818 
819 
820 pragma solidity ^0.6.0;
821 
822 /**
823  * @dev Contract module which provides a basic access control mechanism, where
824  * there is an account (an owner) that can be granted exclusive access to
825  * specific functions.
826  *
827  * By default, the owner account will be the one that deploys the contract. This
828  * can later be changed with {transferOwnership}.
829  *
830  * This module is used through inheritance. It will make available the modifier
831  * `onlyOwner`, which can be applied to your functions to restrict their use to
832  * the owner.
833  */
834 contract Ownable is Context {
835     address private _owner;
836 
837     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
838 
839     /**
840      * @dev Initializes the contract setting the deployer as the initial owner.
841      */
842     constructor () internal {
843         address msgSender = _msgSender();
844         _owner = msgSender;
845         emit OwnershipTransferred(address(0), msgSender);
846     }
847 
848     /**
849      * @dev Returns the address of the current owner.
850      */
851     function owner() public view returns (address) {
852         return _owner;
853     }
854 
855     /**
856      * @dev Throws if called by any account other than the owner.
857      */
858     modifier onlyOwner() {
859         require(_owner == _msgSender(), "Ownable: caller is not the owner");
860         _;
861     }
862 
863     /**
864      * @dev Leaves the contract without owner. It will not be possible to call
865      * `onlyOwner` functions anymore. Can only be called by the current owner.
866      *
867      * NOTE: Renouncing ownership will leave the contract without an owner,
868      * thereby removing any functionality that is only available to the owner.
869      */
870     function renounceOwnership() public virtual onlyOwner {
871         emit OwnershipTransferred(_owner, address(0));
872         _owner = address(0);
873     }
874 
875     /**
876      * @dev Transfers ownership of the contract to a new account (`newOwner`).
877      * Can only be called by the current owner.
878      */
879     function transferOwnership(address newOwner) public virtual onlyOwner {
880         require(newOwner != address(0), "Ownable: new owner is the zero address");
881         emit OwnershipTransferred(_owner, newOwner);
882         _owner = newOwner;
883     }
884 }
885 
886 // File: contracts/DarkHippo.sol
887 
888 pragma solidity 0.6.12;
889 
890 
891 
892 
893 
894 contract DarkHippo is ERC20("DarkHippoV2", "dHIPPOv2"), Ownable {
895     using SafeMath for uint256;
896 
897     using SafeERC20 for IERC20;
898     using SafeMath for uint256;
899 
900     // Addresses
901     address public devAddress;
902     address public fundAddress;
903 
904     // Reward
905     uint256 public rewardPerBlock;
906     uint256 public rewardPerBlockLP;
907 
908     // Rate of Reward
909     uint256 public rateDevFee = 5;
910     uint256 public rateReward = 75;
911     uint256 public rateFund = 20;
912     uint256 public start_block = 0;
913 
914     // Addresses for stake
915     IERC20 public HippoToken;
916     IERC20 public HippoLPToken;
917 
918     // Start?
919     bool public isStart;
920 
921 
922     // Stakeaddress
923     struct stakeTracker {
924         uint256 lastBlock;
925         uint256 lastBlockLP;
926         uint256 rewards;
927         uint256 rewardsLP;
928         uint256 stakedHIPPO;
929         uint256 stakedHippoLP;
930     }
931     mapping(address => stakeTracker) public staked;
932 
933     // Amount
934     uint256 private totalStakedAmount = 0; // for HIPPO
935     uint256 private totalStakedAmountLP = 0; // for HIPPO/ETH
936 
937 
938     constructor(
939         address hippoToken,
940         address _devAddress,
941         address _fundAddress,
942         uint256 _start_block
943     ) public {
944         _mint(msg.sender, 500 * 1000000000000000000);
945         devAddress = _devAddress;
946         fundAddress = _fundAddress;
947         rewardPerBlock = 0.01 * 1000000000000000000;
948         rewardPerBlockLP = 0 * 1000000000000000000;
949         start_block = _start_block;
950         HippoToken = IERC20(address(hippoToken));
951         isStart = false;
952     }
953 
954 
955     // Events
956     event Staked(address indexed user, uint256 amount, uint256 total);
957     event Unstaked(address indexed user, uint256 amount, uint256 total);
958     event StakedLP(address indexed user, uint256 amount, uint256 total);
959     event UnstakedLP(address indexed user, uint256 amount, uint256 total);
960     event Rewards(address indexed user, uint256 amount);
961 
962 
963     // Reward Updater
964     modifier updateStakingReward(address account) {
965 
966         uint256 h = 0;
967         uint256 lastBlock = staked[account].lastBlock;
968         if(block.number > staked[account].lastBlock && totalStakedAmount != 0) {
969             uint256 multiplier = block.number.sub(lastBlock);
970             uint256 hippoReward = multiplier.mul(rewardPerBlock);
971             h = hippoReward.mul(staked[account].stakedHIPPO).div(totalStakedAmount);
972             staked[account].rewards = staked[account].rewards.add(h);
973             staked[account].lastBlock = block.number;
974         }
975 
976         _;
977     }
978 
979 
980     // Reward Updater LP
981     modifier updateStakingRewardLP(address account) {
982 
983         uint256 h = 0;
984         uint256 lastBlockLP = staked[account].lastBlockLP;
985         if(block.number > staked[account].lastBlockLP && totalStakedAmountLP != 0) {
986             uint256 multiplier = block.number.sub(lastBlockLP);
987             uint256 hippoReward = multiplier.mul(rewardPerBlockLP);
988             h = hippoReward.mul(staked[account].stakedHippoLP).div(totalStakedAmountLP);
989             staked[account].rewardsLP = staked[account].rewardsLP.add(h);
990             staked[account].lastBlockLP = block.number;
991         }
992 
993         _;
994     }
995 
996 
997 
998     function setHippoToken(address _addr) public onlyOwner {
999         HippoToken = IERC20(address(_addr));
1000     }
1001 
1002     function setHippoLPToken(address _addr) public onlyOwner {
1003         HippoLPToken = IERC20(address(_addr));
1004     }
1005 
1006 
1007     // Set Rewards both
1008     function setRewardPerBlockBoth(uint256 _hippo, uint256 _lp) public onlyOwner {
1009         rewardPerBlock = _hippo;
1010         rewardPerBlockLP = _lp;
1011     }
1012 
1013     // Set Reward Per Block
1014     function setRewardPerBlock(uint256 _amount) public onlyOwner {
1015         rewardPerBlock = _amount;
1016     }
1017 
1018     // Set Reward Per Block - LP
1019     function setRewardPerBlockLP(uint256 _amount) public onlyOwner {
1020         rewardPerBlockLP = _amount;
1021     }
1022 
1023     // Set Reward
1024     function setDevAddress(address addr) public onlyOwner {
1025         devAddress = addr;
1026     }
1027 
1028     // Set Funding Contract
1029     function setFundAddress(address addr) public onlyOwner {
1030         fundAddress = addr;
1031     }
1032 
1033 
1034     // Stake $HIPPO
1035     function stake(uint256 amount) public updateStakingReward(msg.sender) {
1036         require(isStart, "not started");
1037         require(0 < amount, ":stake: Fund Error");
1038         totalStakedAmount = totalStakedAmount.add(amount);
1039         staked[msg.sender].stakedHIPPO = staked[msg.sender].stakedHIPPO.add(amount);
1040         HippoToken.safeTransferFrom(msg.sender, address(this), amount);
1041         staked[msg.sender].lastBlock = block.number;
1042         emit Staked(msg.sender, amount, totalStakedAmount);
1043     }
1044 
1045     // Unstake $HIPPO
1046     function unstake(uint256 amount) public updateStakingReward(msg.sender) {
1047         require(isStart, "not started");
1048         require(amount <= staked[msg.sender].stakedHIPPO, ":unstake: Fund ERROR");
1049         require(0 < amount, ":unstake: Fund Error 2");
1050         totalStakedAmount = totalStakedAmount.sub(amount);
1051         staked[msg.sender].stakedHIPPO = staked[msg.sender].stakedHIPPO.sub(amount);
1052         HippoToken.safeTransfer(msg.sender, amount);
1053         staked[msg.sender].lastBlock = block.number;
1054         emit Unstaked(msg.sender, amount, totalStakedAmount);
1055     }
1056 
1057     // Stake $HIPPO/ETH
1058     function stakeLP(uint256 amount) public updateStakingRewardLP(msg.sender) {
1059         require(isStart, "not started");
1060         require(0 < amount, ":stakeLP: Fund Error");
1061         totalStakedAmountLP = totalStakedAmountLP.add(amount);
1062         staked[msg.sender].stakedHippoLP = staked[msg.sender].stakedHippoLP.add(amount);
1063         HippoLPToken.safeTransferFrom(msg.sender, address(this), amount);
1064         staked[msg.sender].lastBlockLP = block.number;
1065         emit StakedLP(msg.sender, amount, totalStakedAmount);
1066     }
1067 
1068     // Unstake $HIPPO/ETH
1069     function unstakeLP(uint256 amount) public updateStakingRewardLP(msg.sender) {
1070         require(isStart, "not started");
1071         require(amount <= staked[msg.sender].stakedHippoLP, ":unstakeLP: Fund ERROR, amount <= stakedHippo");
1072         require(0 < amount, ":unstakeLP: Fund Error 2");
1073         totalStakedAmountLP = totalStakedAmountLP.sub(amount);
1074         staked[msg.sender].stakedHippoLP = staked[msg.sender].stakedHippoLP.sub(amount);
1075         HippoLPToken.safeTransfer(msg.sender, amount);
1076         staked[msg.sender].lastBlockLP = block.number;
1077         emit UnstakedLP(msg.sender, amount, totalStakedAmountLP);
1078     }   
1079 
1080     // Claim
1081     function sendReward() public updateStakingReward(msg.sender) {
1082         require(isStart, "not started");
1083         require(0 < staked[msg.sender].rewards, "More than 0");
1084         uint256 reward = staked[msg.sender].rewards;
1085         staked[msg.sender].rewards = 0;
1086         uint256 totalWeight = rateReward.add(rateDevFee).add(rateFund);
1087         // 75% to User
1088         _mint(msg.sender, reward.div(totalWeight).mul(rateReward));
1089         // 20% to Funding event
1090         _mint(fundAddress, reward.div(totalWeight).mul(rateFund));
1091         // 5% to DevFee
1092         _mint(devAddress, reward.div(totalWeight).mul(rateDevFee));
1093         emit Rewards(msg.sender, reward);
1094     }
1095     
1096 
1097     // Claim LP
1098     function sendRewardLP() public updateStakingRewardLP(msg.sender) {
1099         require(isStart, "not started");
1100         require(0 < staked[msg.sender].rewardsLP, "More than 0");
1101         uint256 reward = staked[msg.sender].rewardsLP;
1102         staked[msg.sender].rewardsLP = 0;
1103         uint256 totalWeight = rateReward.add(rateDevFee).add(rateFund);
1104         // 75% to User
1105         _mint(msg.sender, reward.div(totalWeight).mul(rateReward));
1106         // 20% to Funding event
1107         _mint(fundAddress, reward.div(totalWeight).mul(rateFund));
1108         // 5% to DevFee
1109         _mint(devAddress, reward.div(totalWeight).mul(rateDevFee));
1110         emit Rewards(msg.sender, reward);
1111     }
1112 
1113     function setStart() public onlyOwner {
1114         isStart = true;
1115     }
1116 
1117     // Get my reward
1118     function getHippoReward(address account) public view returns (uint256) {
1119         uint256 h = 0;
1120         uint256 lastBlock = staked[account].lastBlock;
1121         if(block.number > staked[account].lastBlock && totalStakedAmount != 0) {
1122             uint256 multiplier = block.number.sub(lastBlock);
1123             uint256 hippoReward = multiplier.mul(rewardPerBlock);
1124             h = hippoReward.mul(staked[account].stakedHIPPO).div(totalStakedAmount);
1125         }
1126         return staked[account].rewards.add(h);
1127     }
1128 
1129     function getHippoLPReward(address account) public view returns (uint256) {
1130         uint256 h = 0;
1131         uint256 lastBlock = staked[account].lastBlockLP;
1132         if(block.number > staked[account].lastBlockLP && totalStakedAmountLP != 0) {
1133             uint256 multiplier = block.number.sub(lastBlock);
1134             uint256 hippoReward = multiplier.mul(rewardPerBlockLP);
1135             h = hippoReward.mul(staked[account].stakedHippoLP).div(totalStakedAmountLP);
1136         }
1137         return staked[account].rewardsLP.add(h);
1138     }
1139 
1140     // Get staked amount of angry hippo
1141     function getStakedAmount(address _account) public view returns (uint256) {
1142         return staked[_account].stakedHIPPO;
1143     }
1144     
1145     // Get staked amount of angry hippo / eth
1146     function getStakedAmountOfLP(address _account) public view returns (uint256) {
1147         return staked[_account].stakedHippoLP;
1148     }
1149 
1150     // Get total staked aHIPPO
1151     function getTotalStakedAmount() public view returns (uint256) {
1152         return totalStakedAmount;
1153     }
1154 
1155     // Get total staked aHIPPO/ETH
1156     function getTotalStakedAmountLP() public view returns (uint256) {
1157         return totalStakedAmountLP;
1158     }
1159 }