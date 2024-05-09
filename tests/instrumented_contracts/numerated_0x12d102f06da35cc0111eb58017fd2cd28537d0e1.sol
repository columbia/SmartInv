1 pragma solidity 0.6.12;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Wrappers over Solidity's arithmetic operations with added overflow
26  * checks.
27  *
28  * Arithmetic operations in Solidity wrap on overflow. This can easily result
29  * in bugs, because programmers usually assume that an overflow raises an
30  * error, which is the standard behavior in high level programming languages.
31  * `SafeMath` restores this intuition by reverting the transaction when an
32  * operation overflows.
33  *
34  * Using this library instead of the unchecked operations eliminates an entire
35  * class of bugs, so it's recommended to use it always.
36  */
37 library SafeMath {
38     /**
39      * @dev Returns the addition of two unsigned integers, reverting on
40      * overflow.
41      *
42      * Counterpart to Solidity's `+` operator.
43      *
44      * Requirements:
45      *
46      * - Addition cannot overflow.
47      */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51 
52         return c;
53     }
54 
55     /**
56      * @dev Returns the subtraction of two unsigned integers, reverting on
57      * overflow (when the result is negative).
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      *
63      * - Subtraction cannot overflow.
64      */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return sub(a, b, "SafeMath: subtraction overflow");
67     }
68 
69     /**
70      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
71      * overflow (when the result is negative).
72      *
73      * Counterpart to Solidity's `-` operator.
74      *
75      * Requirements:
76      *
77      * - Subtraction cannot overflow.
78      */
79     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b <= a, errorMessage);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the multiplication of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `*` operator.
91      *
92      * Requirements:
93      *
94      * - Multiplication cannot overflow.
95      */
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
98         // benefit is lost if 'b' is also tested.
99         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
100         if (a == 0) {
101             return 0;
102         }
103 
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the integer division of two unsigned integers. Reverts on
112      * division by zero. The result is rounded towards zero.
113      *
114      * Counterpart to Solidity's `/` operator. Note: this function uses a
115      * `revert` opcode (which leaves remaining gas untouched) while Solidity
116      * uses an invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      *
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         return div(a, b, "SafeMath: division by zero");
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator. Note: this function uses a
131      * `revert` opcode (which leaves remaining gas untouched) while Solidity
132      * uses an invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b > 0, errorMessage);
140         uint256 c = a / b;
141         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         return mod(a, b, "SafeMath: modulo by zero");
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * Reverts with custom message when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b != 0, errorMessage);
176         return a % b;
177     }
178 }
179 
180 /**
181  * @dev Collection of functions related to the address type
182  */
183 library Address {
184     /**
185      * @dev Returns true if `account` is a contract.
186      *
187      * [IMPORTANT]
188      * ====
189      * It is unsafe to assume that an address for which this function returns
190      * false is an externally-owned account (EOA) and not a contract.
191      *
192      * Among others, `isContract` will return false for the following
193      * types of addresses:
194      *
195      *  - an externally-owned account
196      *  - a contract in construction
197      *  - an address where a contract will be created
198      *  - an address where a contract lived, but was destroyed
199      * ====
200      */
201     function isContract(address account) internal view returns (bool) {
202         // This method relies on extcodesize, which returns 0 for contracts in
203         // construction, since the code is only stored at the end of the
204         // constructor execution.
205 
206         uint256 size;
207         // solhint-disable-next-line no-inline-assembly
208         assembly { size := extcodesize(account) }
209         return size > 0;
210     }
211 
212     /**
213      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
214      * `recipient`, forwarding all available gas and reverting on errors.
215      *
216      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
217      * of certain opcodes, possibly making contracts go over the 2300 gas limit
218      * imposed by `transfer`, making them unable to receive funds via
219      * `transfer`. {sendValue} removes this limitation.
220      *
221      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
222      *
223      * IMPORTANT: because control is transferred to `recipient`, care must be
224      * taken to not create reentrancy vulnerabilities. Consider using
225      * {ReentrancyGuard} or the
226      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
227      */
228     function sendValue(address payable recipient, uint256 amount) internal {
229         require(address(this).balance >= amount, "Address: insufficient balance");
230 
231         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
232         (bool success, ) = recipient.call{ value: amount }("");
233         require(success, "Address: unable to send value, recipient may have reverted");
234     }
235 
236     /**
237      * @dev Performs a Solidity function call using a low level `call`. A
238      * plain`call` is an unsafe replacement for a function call: use this
239      * function instead.
240      *
241      * If `target` reverts with a revert reason, it is bubbled up by this
242      * function (like regular Solidity function calls).
243      *
244      * Returns the raw returned data. To convert to the expected return value,
245      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
246      *
247      * Requirements:
248      *
249      * - `target` must be a contract.
250      * - calling `target` with `data` must not revert.
251      *
252      * _Available since v3.1._
253      */
254     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
255       return functionCall(target, data, "Address: low-level call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
260      * `errorMessage` as a fallback revert reason when `target` reverts.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, 0, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but also transferring `value` wei to `target`.
271      *
272      * Requirements:
273      *
274      * - the calling contract must have an ETH balance of at least `value`.
275      * - the called Solidity function must be `payable`.
276      *
277      * _Available since v3.1._
278      */
279     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
280         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
285      * with `errorMessage` as a fallback revert reason when `target` reverts.
286      *
287      * _Available since v3.1._
288      */
289     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
290         require(address(this).balance >= value, "Address: insufficient balance for call");
291         require(isContract(target), "Address: call to non-contract");
292 
293         // solhint-disable-next-line avoid-low-level-calls
294         (bool success, bytes memory returndata) = target.call{ value: value }(data);
295         return _verifyCallResult(success, returndata, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but performing a static call.
301      *
302      * _Available since v3.3._
303      */
304     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
305         return functionStaticCall(target, data, "Address: low-level static call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
310      * but performing a static call.
311      *
312      * _Available since v3.3._
313      */
314     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
315         require(isContract(target), "Address: static call to non-contract");
316 
317         // solhint-disable-next-line avoid-low-level-calls
318         (bool success, bytes memory returndata) = target.staticcall(data);
319         return _verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but performing a delegate call.
325      *
326      * _Available since v3.3._
327      */
328     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
329         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
334      * but performing a delegate call.
335      *
336      * _Available since v3.3._
337      */
338     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
339         require(isContract(target), "Address: delegate call to non-contract");
340 
341         // solhint-disable-next-line avoid-low-level-calls
342         (bool success, bytes memory returndata) = target.delegatecall(data);
343         return _verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
347         if (success) {
348             return returndata;
349         } else {
350             // Look for revert reason and bubble it up if present
351             if (returndata.length > 0) {
352                 // The easiest way to bubble the revert reason is using memory via assembly
353 
354                 // solhint-disable-next-line no-inline-assembly
355                 assembly {
356                     let returndata_size := mload(returndata)
357                     revert(add(32, returndata), returndata_size)
358                 }
359             } else {
360                 revert(errorMessage);
361             }
362         }
363     }
364 }
365 
366 /**
367  * @dev Interface of the ERC20 standard as defined in the EIP.
368  */
369 interface IERC20 {
370     /**
371      * @dev Returns the amount of tokens in existence.
372      */
373     function totalSupply() external view returns (uint256);
374 
375     /**
376      * @dev Returns the amount of tokens owned by `account`.
377      */
378     function balanceOf(address account) external view returns (uint256);
379 
380     /**
381      * @dev Moves `amount` tokens from the caller's account to `recipient`.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * Emits a {Transfer} event.
386      */
387     function transfer(address recipient, uint256 amount) external returns (bool);
388 
389     /**
390      * @dev Returns the remaining number of tokens that `spender` will be
391      * allowed to spend on behalf of `owner` through {transferFrom}. This is
392      * zero by default.
393      *
394      * This value changes when {approve} or {transferFrom} are called.
395      */
396     function allowance(address owner, address spender) external view returns (uint256);
397 
398     /**
399      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
400      *
401      * Returns a boolean value indicating whether the operation succeeded.
402      *
403      * IMPORTANT: Beware that changing an allowance with this method brings the risk
404      * that someone may use both the old and the new allowance by unfortunate
405      * transaction ordering. One possible solution to mitigate this race
406      * condition is to first reduce the spender's allowance to 0 and set the
407      * desired value afterwards:
408      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
409      *
410      * Emits an {Approval} event.
411      */
412     function approve(address spender, uint256 amount) external returns (bool);
413 
414     /**
415      * @dev Moves `amount` tokens from `sender` to `recipient` using the
416      * allowance mechanism. `amount` is then deducted from the caller's
417      * allowance.
418      *
419      * Returns a boolean value indicating whether the operation succeeded.
420      *
421      * Emits a {Transfer} event.
422      */
423     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
424 
425     /**
426      * @dev Emitted when `value` tokens are moved from one account (`from`) to
427      * another (`to`).
428      *
429      * Note that `value` may be zero.
430      */
431     event Transfer(address indexed from, address indexed to, uint256 value);
432 
433     /**
434      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
435      * a call to {approve}. `value` is the new allowance.
436      */
437     event Approval(address indexed owner, address indexed spender, uint256 value);
438 }
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
469     mapping (address => mapping (address => uint256)) private _allowances;
470     mapping (address => bool) public _whitelistedAddresses;
471 
472     uint256 private _totalSupply;
473     uint256 private _burnedSupply;
474     uint256 private _burnRate;
475     string private _name;
476     string private _symbol;
477     uint256 private _decimals;
478 
479     /**
480      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
481      * a default value of 18.
482      *
483      * To select a different value for {decimals}, use {_setupDecimals}.
484      *
485      * All three of these values are immutable: they can only be set once during
486      * construction.
487      */
488     constructor (string memory name, string memory symbol, uint256 decimals, uint256 burnrate, uint256 initSupply) public {
489         _name = name;
490         _symbol = symbol;
491         _decimals = decimals;
492         _burnRate = burnrate;
493         _totalSupply = 0;
494         _mint(msg.sender, initSupply*(10**_decimals));
495         _burnedSupply = 0;
496     }
497 
498     /**
499      * @dev Returns the name of the token.
500      */
501     function name() public view returns (string memory) {
502         return _name;
503     }
504 
505     /**
506      * @dev Returns the symbol of the token, usually a shorter version of the
507      * name.
508      */
509     function symbol() public view returns (string memory) {
510         return _symbol;
511     }
512 
513     /**
514      * @dev Returns the number of decimals used to get its user representation.
515      * For example, if `decimals` equals `2`, a balance of `505` tokens should
516      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
517      *
518      * Tokens usually opt for a value of 18, imitating the relationship between
519      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
520      * called.
521      *
522      * NOTE: This information is only used for _display_ purposes: it in
523      * no way affects any of the arithmetic of the contract, including
524      * {IERC20-balanceOf} and {IERC20-transfer}.
525      */
526     function decimals() public view returns (uint256) {
527         return _decimals;
528     }
529 
530     /**
531      * @dev See {IERC20-totalSupply}.
532      */
533     function totalSupply() public view override returns (uint256) {
534         return _totalSupply;
535     }
536 
537     /**
538      * @dev Returns the amount of burned tokens.
539      */
540     function burnedSupply() public view returns (uint256) {
541         return _burnedSupply;
542     }
543 
544     /**
545      * @dev Returns the burnrate.
546      */
547     function burnRate() public view returns (uint256) {
548         return _burnRate;
549     }
550 
551     /**
552      * @dev See {IERC20-balanceOf}.
553      */
554     function balanceOf(address account) public view override returns (uint256) {
555         return _balances[account];
556     }
557 
558     /**
559      * @dev See {IERC20-transfer}.
560      *
561      * Requirements:
562      *
563      * - `recipient` cannot be the zero address.
564      * - the caller must have a balance of at least `amount`.
565      */
566     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
567         _transfer(_msgSender(), recipient, amount);
568         return true;
569     }
570 
571     /**
572      * @dev See {IERC20-transfer}.
573      *
574      * Requirements:
575      *
576      * - `account` cannot be the zero address.
577      * - the caller must have a balance of at least `amount`.
578      */
579     function burn(uint256 amount) public virtual returns (bool) {
580         _burn(_msgSender(), amount);
581         return true;
582     }
583 
584     /**
585      * @dev See {IERC20-allowance}.
586      */
587     function allowance(address owner, address spender) public view virtual override returns (uint256) {
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
598     function approve(address spender, uint256 amount) public virtual override returns (bool) {
599         _approve(_msgSender(), spender, amount);
600         return true;
601     }
602 
603     /**
604      * @dev See {IERC20-transferFrom}.
605      *
606      * Emits an {Approval} event indicating the updated allowance. This is not
607      * required by the EIP. See the note at the beginning of {ERC20};
608      *
609      * Requirements:
610      * - `sender` and `recipient` cannot be the zero address.
611      * - `sender` must have a balance of at least `amount`.
612      * - the caller must have allowance for ``sender``'s tokens of at least
613      * `amount`.
614      */
615     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
616         _transfer(sender, recipient, amount);
617         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
618         return true;
619     }
620 
621     /**
622      * @dev Atomically increases the allowance granted to `spender` by the caller.
623      *
624      * This is an alternative to {approve} that can be used as a mitigation for
625      * problems described in {IERC20-approve}.
626      *
627      * Emits an {Approval} event indicating the updated allowance.
628      *
629      * Requirements:
630      *
631      * - `spender` cannot be the zero address.
632      */
633     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
634         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
635         return true;
636     }
637 
638     /**
639      * @dev Atomically decreases the allowance granted to `spender` by the caller.
640      *
641      * This is an alternative to {approve} that can be used as a mitigation for
642      * problems described in {IERC20-approve}.
643      *
644      * Emits an {Approval} event indicating the updated allowance.
645      *
646      * Requirements:
647      *
648      * - `spender` cannot be the zero address.
649      * - `spender` must have allowance for the caller of at least
650      * `subtractedValue`.
651      */
652     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
653         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
654         return true;
655     }
656 
657     /**
658      * @dev Moves tokens `amount` from `sender` to `recipient`.
659      *
660      * This is internal function is equivalent to {transfer}, and can be used to
661      * e.g. implement automatic token fees, slashing mechanisms, etc.
662      *
663      * Emits a {Transfer} event.
664      *
665      * Requirements:
666      *
667      * - `sender` cannot be the zero address.
668      * - `recipient` cannot be the zero address.
669      * - `sender` must have a balance of at least `amount`.
670      */
671     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
672         require(sender != address(0), "ERC20: transfer from the zero address");
673         require(recipient != address(0), "ERC20: transfer to the zero address");
674 
675         if (_whitelistedAddresses[sender] == true || _whitelistedAddresses[recipient] == true) {
676             _beforeTokenTransfer(sender, recipient, amount);
677             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
678             _balances[recipient] = _balances[recipient].add(amount);
679             emit Transfer(sender, recipient, amount);
680         } else {
681             uint256 amount_burn = amount.mul(_burnRate).div(100);
682             uint256 amount_send = amount.sub(amount_burn);
683             require(amount == amount_send + amount_burn, "Burn value invalid");
684             _burn(sender, amount_burn);
685             amount = amount_send;
686             _beforeTokenTransfer(sender, recipient, amount);
687             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
688             _balances[recipient] = _balances[recipient].add(amount);
689             emit Transfer(sender, recipient, amount);
690         }
691     }
692 
693     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
694      * the total supply.
695      *
696      * Emits a {Transfer} event with `from` set to the zero address.
697      *
698      * Requirements
699      *
700      * - `to` cannot be the zero address.
701      * 
702      * HINT: This function is 'internal' and therefore can only be called from another
703      * function inside this contract!
704      */
705     function _mint(address account, uint256 amount) internal virtual {
706         require(account != address(0), "ERC20: mint to the zero address");
707         _beforeTokenTransfer(address(0), account, amount);
708         _totalSupply = _totalSupply.add(amount);
709         _balances[account] = _balances[account].add(amount);
710         emit Transfer(address(0), account, amount);
711     }
712 
713     /**
714      * @dev Destroys `amount` tokens from `account`, reducing the
715      * total supply.
716      *
717      * Emits a {Transfer} event with `to` set to the zero address.
718      *
719      * Requirements
720      *
721      * - `account` cannot be the zero address.
722      * - `account` must have at least `amount` tokens.
723      */
724     function _burn(address account, uint256 amount) internal virtual {
725         require(account != address(0), "ERC20: burn from the zero address");
726         _beforeTokenTransfer(account, address(0), amount);
727         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
728         _totalSupply = _totalSupply.sub(amount);
729         _burnedSupply = _burnedSupply.add(amount);
730         emit Transfer(account, address(0), amount);
731     }
732 
733     /**
734      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
735      *
736      * This is internal function is equivalent to `approve`, and can be used to
737      * e.g. set automatic allowances for certain subsystems, etc.
738      *
739      * Emits an {Approval} event.
740      *
741      * Requirements:
742      *
743      * - `owner` cannot be the zero address.
744      * - `spender` cannot be the zero address.
745      */
746     function _approve(address owner, address spender, uint256 amount) internal virtual {
747         require(owner != address(0), "ERC20: approve from the zero address");
748         require(spender != address(0), "ERC20: approve to the zero address");
749         _allowances[owner][spender] = amount;
750         emit Approval(owner, spender, amount);
751     }
752 
753     /**
754      * @dev Sets {burnRate} to a value other than the initial one.
755      */
756     function _setupBurnrate(uint8 burnrate_) internal virtual {
757         _burnRate = burnrate_;
758     }
759 
760     /**
761      * @dev Hook that is called before any transfer of tokens. This includes
762      * minting and burning.
763      *
764      * Calling conditions:
765      *
766      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
767      * will be to transferred to `to`.
768      * - when `from` is zero, `amount` tokens will be minted for `to`.
769      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
770      * - `from` and `to` are never both zero.
771      *
772      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
773      */
774     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
775 }
776 
777 /**
778  * @dev Contract module which provides a basic access control mechanism, where
779  * there is an account (an owner) that can be granted exclusive access to
780  * specific functions.
781  *
782  * By default, the owner account will be the one that deploys the contract. This
783  * can later be changed with {transferOwnership}.
784  *
785  * This module is used through inheritance. It will make available the modifier
786  * `onlyOwner`, which can be applied to your functions to restrict their use to
787  * the owner.
788  */
789 contract Ownable is Context {
790     address private _owner;
791 
792     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
793 
794     /**
795      * @dev Initializes the contract setting the deployer as the initial owner.
796      */
797     constructor () internal {
798         address msgSender = _msgSender();
799         _owner = msgSender;
800         emit OwnershipTransferred(address(0), msgSender);
801     }
802 
803     /**
804      * @dev Returns the address of the current owner.
805      */
806     function owner() public view returns (address) {
807         return _owner;
808     }
809 
810     /**
811      * @dev Throws if called by any account other than the owner.
812      */
813     modifier onlyOwner() {
814         require(_owner == _msgSender(), "Ownable: caller is not the owner");
815         _;
816     }
817 
818     /**
819      * @dev Leaves the contract without owner. It will not be possible to call
820      * `onlyOwner` functions anymore. Can only be called by the current owner.
821      *
822      * NOTE: Renouncing ownership will leave the contract without an owner,
823      * thereby removing any functionality that is only available to the owner.
824      */
825     function renounceOwnership() public virtual onlyOwner {
826         emit OwnershipTransferred(_owner, address(0));
827         _owner = address(0);
828     }
829 
830     /**
831      * @dev Transfers ownership of the contract to a new account (`newOwner`).
832      * Can only be called by the current owner.
833      */
834     function transferOwnership(address newOwner) public virtual onlyOwner {
835         require(newOwner != address(0), "Ownable: new owner is the zero address");
836         emit OwnershipTransferred(_owner, newOwner);
837         _owner = newOwner;
838     }
839 }
840 
841 /**
842  * @dev Contract module which provides a basic access control mechanism, where
843  * there is an account (an minter) that can be granted exclusive access to
844  * specific functions.
845  *
846  * By default, the minter account will be the one that deploys the contract. This
847  * can later be changed with {transferMintership}.
848  *
849  * This module is used through inheritance. It will make available the modifier
850  * `onlyMinter`, which can be applied to your functions to restrict their use to
851  * the minter.
852  */
853 contract Mintable is Context {
854 
855     /**
856      * @dev So here we seperate the rights of the classic ownership into 'owner' and 'minter'
857      * this way the developer/owner stays the 'owner' and can make changes like adding a pool
858      * at any time but cannot mint anymore as soon as the 'minter' gets changes (to the chef contract)
859      */
860     address private _minter;
861 
862     event MintershipTransferred(address indexed previousMinter, address indexed newMinter);
863 
864     /**
865      * @dev Initializes the contract setting the deployer as the initial minter.
866      */
867     constructor () internal {
868         address msgSender = _msgSender();
869         _minter = msgSender;
870         emit MintershipTransferred(address(0), msgSender);
871     }
872 
873     /**
874      * @dev Returns the address of the current minter.
875      */
876     function minter() public view returns (address) {
877         return _minter;
878     }
879 
880     /**
881      * @dev Throws if called by any account other than the minter.
882      */
883     modifier onlyMinter() {
884         require(_minter == _msgSender(), "Mintable: caller is not the minter");
885         _;
886     }
887 
888     /**
889      * @dev Transfers mintership of the contract to a new account (`newMinter`).
890      * Can only be called by the current minter.
891      */
892     function transferMintership(address newMinter) public virtual onlyMinter {
893         require(newMinter != address(0), "Mintable: new minter is the zero address");
894         emit MintershipTransferred(_minter, newMinter);
895         _minter = newMinter;
896     }
897 }
898 
899 /*
900 
901 website: vox.finance
902 
903  _    ______ _  __   ___________   _____    _   ______________
904 | |  / / __ \ |/ /  / ____/  _/ | / /   |  / | / / ____/ ____/
905 | | / / / / /   /  / /_   / //  |/ / /| | /  |/ / /   / __/   
906 | |/ / /_/ /   |_ / __/ _/ // /|  / ___ |/ /|  / /___/ /___   
907 |___/\____/_/|_(_)_/   /___/_/ |_/_/  |_/_/ |_/\____/_____/   
908                                                               
909 */
910 // VoxToken
911 contract VoxToken is ERC20("Vox.Finance", "VOX", 18, 0, 1250), Ownable, Mintable {
912     /// @notice Creates `_amount` token to `_to`. Must only be called by the minter (VoxMaster).
913     function mint(address _to, uint256 _amount) public onlyMinter {
914         _mint(_to, _amount);
915     }
916 
917     function setBurnrate(uint8 burnrate_) public onlyOwner {
918         _setupBurnrate(burnrate_);
919     }
920 
921     function addWhitelistedAddress(address _address) public onlyOwner {
922         _whitelistedAddresses[_address] = true;
923     }
924 
925     function removeWhitelistedAddress(address _address) public onlyOwner {
926         _whitelistedAddresses[_address] = false;
927     }
928 }