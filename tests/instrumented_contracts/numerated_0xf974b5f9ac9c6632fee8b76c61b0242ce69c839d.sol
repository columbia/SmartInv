1 // File: @openzeppelin/contracts/GSN/Context.sol
2 pragma solidity ^0.6.0;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 // File: @openzeppelin/contracts/math/SafeMath.sol
102 
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 // File: @openzeppelin/contracts/utils/Address.sol
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
314         (bool success, ) = recipient.call{ value: amount }("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain`call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337         return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
347         return _functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         return _functionCallWithValue(target, data, value, errorMessage);
374     }
375 
376     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
377         require(isContract(target), "Address: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
401 
402 
403 
404 /**
405  * @dev Implementation of the {IERC20} interface.
406  *
407  * This implementation is agnostic to the way tokens are created. This means
408  * that a supply mechanism has to be added in a derived contract using {_mint}.
409  * For a generic mechanism see {ERC20PresetMinterPauser}.
410  *
411  * TIP: For a detailed writeup see our guide
412  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
413  * to implement supply mechanisms].
414  *
415  * We have followed general OpenZeppelin guidelines: functions revert instead
416  * of returning `false` on failure. This behavior is nonetheless conventional
417  * and does not conflict with the expectations of ERC20 applications.
418  *
419  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
420  * This allows applications to reconstruct the allowance for all accounts just
421  * by listening to said events. Other implementations of the EIP may not emit
422  * these events, as it isn't required by the specification.
423  *
424  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
425  * functions have been added to mitigate the well-known issues around setting
426  * allowances. See {IERC20-approve}.
427  */
428 contract ERC20 is Context, IERC20 {
429     using SafeMath for uint256;
430     using Address for address;
431 
432     mapping (address => uint256) private _balances;
433 
434     mapping (address => mapping (address => uint256)) private _allowances;
435 
436     uint256 private _totalSupply;
437 
438     string private _name;
439     string private _symbol;
440     uint8 private _decimals;
441 
442     /**
443      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
444      * a default value of 18.
445      *
446      * To select a different value for {decimals}, use {_setupDecimals}.
447      *
448      * All three of these values are immutable: they can only be set once during
449      * construction.
450      */
451     constructor (string memory name, string memory symbol) public {
452         _name = name;
453         _symbol = symbol;
454         _decimals = 18;
455     }
456 
457     /**
458      * @dev Returns the name of the token.
459      */
460     function name() public view returns (string memory) {
461         return _name;
462     }
463 
464     /**
465      * @dev Returns the symbol of the token, usually a shorter version of the
466      * name.
467      */
468     function symbol() public view returns (string memory) {
469         return _symbol;
470     }
471 
472     /**
473      * @dev Returns the number of decimals used to get its user representation.
474      * For example, if `decimals` equals `2`, a balance of `505` tokens should
475      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
476      *
477      * Tokens usually opt for a value of 18, imitating the relationship between
478      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
479      * called.
480      *
481      * NOTE: This information is only used for _display_ purposes: it in
482      * no way affects any of the arithmetic of the contract, including
483      * {IERC20-balanceOf} and {IERC20-transfer}.
484      */
485     function decimals() public view returns (uint8) {
486         return _decimals;
487     }
488 
489     /**
490      * @dev See {IERC20-totalSupply}.
491      */
492     function totalSupply() public view override returns (uint256) {
493         return _totalSupply;
494     }
495 
496     /**
497      * @dev See {IERC20-balanceOf}.
498      */
499     function balanceOf(address account) public view override returns (uint256) {
500         return _balances[account];
501     }
502 
503     /**
504      * @dev See {IERC20-transfer}.
505      *
506      * Requirements:
507      *
508      * - `recipient` cannot be the zero address.
509      * - the caller must have a balance of at least `amount`.
510      */
511     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
512         _transfer(_msgSender(), recipient, amount);
513         return true;
514     }
515 
516     /**
517      * @dev See {IERC20-allowance}.
518      */
519     function allowance(address owner, address spender) public view virtual override returns (uint256) {
520         return _allowances[owner][spender];
521     }
522 
523     /**
524      * @dev See {IERC20-approve}.
525      *
526      * Requirements:
527      *
528      * - `spender` cannot be the zero address.
529      */
530     function approve(address spender, uint256 amount) public virtual override returns (bool) {
531         _approve(_msgSender(), spender, amount);
532         return true;
533     }
534 
535     /**
536      * @dev See {IERC20-transferFrom}.
537      *
538      * Emits an {Approval} event indicating the updated allowance. This is not
539      * required by the EIP. See the note at the beginning of {ERC20};
540      *
541      * Requirements:
542      * - `sender` and `recipient` cannot be the zero address.
543      * - `sender` must have a balance of at least `amount`.
544      * - the caller must have allowance for ``sender``'s tokens of at least
545      * `amount`.
546      */
547     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
548         _transfer(sender, recipient, amount);
549         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
550         return true;
551     }
552 
553     /**
554      * @dev Atomically increases the allowance granted to `spender` by the caller.
555      *
556      * This is an alternative to {approve} that can be used as a mitigation for
557      * problems described in {IERC20-approve}.
558      *
559      * Emits an {Approval} event indicating the updated allowance.
560      *
561      * Requirements:
562      *
563      * - `spender` cannot be the zero address.
564      */
565     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
566         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
567         return true;
568     }
569 
570     /**
571      * @dev Atomically decreases the allowance granted to `spender` by the caller.
572      *
573      * This is an alternative to {approve} that can be used as a mitigation for
574      * problems described in {IERC20-approve}.
575      *
576      * Emits an {Approval} event indicating the updated allowance.
577      *
578      * Requirements:
579      *
580      * - `spender` cannot be the zero address.
581      * - `spender` must have allowance for the caller of at least
582      * `subtractedValue`.
583      */
584     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
585         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
586         return true;
587     }
588 
589     /**
590      * @dev Moves tokens `amount` from `sender` to `recipient`.
591      *
592      * This is internal function is equivalent to {transfer}, and can be used to
593      * e.g. implement automatic token fees, slashing mechanisms, etc.
594      *
595      * Emits a {Transfer} event.
596      *
597      * Requirements:
598      *
599      * - `sender` cannot be the zero address.
600      * - `recipient` cannot be the zero address.
601      * - `sender` must have a balance of at least `amount`.
602      */
603     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
604         require(sender != address(0), "ERC20: transfer from the zero address");
605         require(recipient != address(0), "ERC20: transfer to the zero address");
606 
607         _beforeTokenTransfer(sender, recipient, amount);
608 
609         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
610         _balances[recipient] = _balances[recipient].add(amount);
611         emit Transfer(sender, recipient, amount);
612     }
613 
614     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
615      * the total supply.
616      *
617      * Emits a {Transfer} event with `from` set to the zero address.
618      *
619      * Requirements
620      *
621      * - `to` cannot be the zero address.
622      */
623     function _mint(address account, uint256 amount) internal virtual {
624         require(account != address(0), "ERC20: mint to the zero address");
625 
626         _beforeTokenTransfer(address(0), account, amount);
627 
628         _totalSupply = _totalSupply.add(amount);
629         _balances[account] = _balances[account].add(amount);
630         emit Transfer(address(0), account, amount);
631     }
632 
633     /**
634      * @dev Destroys `amount` tokens from `account`, reducing the
635      * total supply.
636      *
637      * Emits a {Transfer} event with `to` set to the zero address.
638      *
639      * Requirements
640      *
641      * - `account` cannot be the zero address.
642      * - `account` must have at least `amount` tokens.
643      */
644     function _burn(address account, uint256 amount) internal virtual {
645         require(account != address(0), "ERC20: burn from the zero address");
646 
647         _beforeTokenTransfer(account, address(0), amount);
648 
649         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
650         _totalSupply = _totalSupply.sub(amount);
651         emit Transfer(account, address(0), amount);
652     }
653 
654     /**
655      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
656      *
657      * This is internal function is equivalent to `approve`, and can be used to
658      * e.g. set automatic allowances for certain subsystems, etc.
659      *
660      * Emits an {Approval} event.
661      *
662      * Requirements:
663      *
664      * - `owner` cannot be the zero address.
665      * - `spender` cannot be the zero address.
666      */
667     function _approve(address owner, address spender, uint256 amount) internal virtual {
668         require(owner != address(0), "ERC20: approve from the zero address");
669         require(spender != address(0), "ERC20: approve to the zero address");
670 
671         _allowances[owner][spender] = amount;
672         emit Approval(owner, spender, amount);
673     }
674 
675     /**
676      * @dev Sets {decimals} to a value other than the default one of 18.
677      *
678      * WARNING: This function should only be called from the constructor. Most
679      * applications that interact with token contracts will not expect
680      * {decimals} to ever change, and may work incorrectly if it does.
681      */
682     function _setupDecimals(uint8 decimals_) internal {
683         _decimals = decimals_;
684     }
685 
686     /**
687      * @dev Hook that is called before any transfer of tokens. This includes
688      * minting and burning.
689      *
690      * Calling conditions:
691      *
692      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
693      * will be to transferred to `to`.
694      * - when `from` is zero, `amount` tokens will be minted for `to`.
695      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
696      * - `from` and `to` are never both zero.
697      *
698      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
699      */
700     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
701 }
702 
703 // File: @openzeppelin/contracts/access/Ownable.sol
704 
705 /**
706  * @dev Contract module which provides a basic access control mechanism, where
707  * there is an account (an owner) that can be granted exclusive access to
708  * specific functions.
709  *
710  * By default, the owner account will be the one that deploys the contract. This
711  * can later be changed with {transferOwnership}.
712  *
713  * This module is used through inheritance. It will make available the modifier
714  * `onlyOwner`, which can be applied to your functions to restrict their use to
715  * the owner.
716  */
717 contract Ownable is Context {
718     address private _owner;
719 
720     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
721 
722     /**
723      * @dev Initializes the contract setting the deployer as the initial owner.
724      */
725     constructor () internal {
726         address msgSender = _msgSender();
727         _owner = msgSender;
728         emit OwnershipTransferred(address(0), msgSender);
729     }
730 
731     /**
732      * @dev Returns the address of the current owner.
733      */
734     function owner() public view returns (address) {
735         return _owner;
736     }
737 
738     /**
739      * @dev Throws if called by any account other than the owner.
740      */
741     modifier onlyOwner() {
742         require(_owner == _msgSender(), "Ownable: caller is not the owner");
743         _;
744     }
745 
746     /**
747      * @dev Leaves the contract without owner. It will not be possible to call
748      * `onlyOwner` functions anymore. Can only be called by the current owner.
749      *
750      * NOTE: Renouncing ownership will leave the contract without an owner,
751      * thereby removing any functionality that is only available to the owner.
752      */
753     function renounceOwnership() public virtual onlyOwner {
754         emit OwnershipTransferred(_owner, address(0));
755         _owner = address(0);
756     }
757 
758     /**
759      * @dev Transfers ownership of the contract to a new account (`newOwner`).
760      * Can only be called by the current owner.
761      */
762     function transferOwnership(address newOwner) public virtual onlyOwner {
763         require(newOwner != address(0), "Ownable: new owner is the zero address");
764         emit OwnershipTransferred(_owner, newOwner);
765         _owner = newOwner;
766     }
767 }
768 
769 
770 
771 contract ZyxToken is ERC20("ZyxToken", "ZYX"), Ownable {
772 
773     string public LastZyxId = "";
774     string public LastZYXAddress = "";
775 
776 
777     function mint(address _to, uint256 _amount) public onlyOwner {
778         _mint(_to, _amount);
779         _moveDelegates(address(0), _delegates[_to], _amount);
780     }
781 
782     function burn(address _account, uint256 _amount) public {
783         _burn(_account, _amount);
784         _moveDelegates(_delegates[_account] ,address(0), _amount);
785     }
786 
787     function mintBridge(address _to, uint256 _amount, string calldata last_zyx_id) public onlyOwner {
788         _mint(_to, _amount);
789         _moveDelegates(address(0), _delegates[_to], _amount);
790         LastZyxId = last_zyx_id;
791     }
792 
793     function burnBridge(address _account, uint256 _amount, string calldata last_zyx_address) public {
794         _burn(_account, _amount);
795         _moveDelegates(_delegates[_account] ,address(0), _amount);
796         LastZYXAddress = last_zyx_address;
797     }
798 
799     mapping (address => address) internal _delegates;
800 
801     /// @notice A checkpoint for marking number of votes from a given block
802     struct Checkpoint {
803         uint32 fromBlock;
804         uint256 votes;
805     }
806 
807     /// @notice A record of votes checkpoints for each account, by index
808     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
809 
810     /// @notice The number of checkpoints for each account
811     mapping (address => uint32) public numCheckpoints;
812 
813     /// @notice The EIP-712 typehash for the contract's domain
814     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
815 
816     /// @notice The EIP-712 typehash for the delegation struct used by the contract
817     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
818 
819     /// @notice A record of states for signing / validating signatures
820     mapping (address => uint) public nonces;
821 
822     /// @notice An event thats emitted when an account changes its delegate
823     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
824 
825     /// @notice An event thats emitted when a delegate account's vote balance changes
826     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
827 
828     /**
829      * @notice Delegate votes from `msg.sender` to `delegatee`
830      * @param delegator The address to get delegatee for
831      */
832     function delegates(address delegator)
833     external
834     view
835     returns (address)
836     {
837         return _delegates[delegator];
838     }
839 
840     /**
841      * @notice Delegate votes from `msg.sender` to `delegatee`
842      * @param delegatee The address to delegate votes to
843      */
844     function delegate(address delegatee) external {
845         return _delegate(msg.sender, delegatee);
846     }
847 
848     /**
849      * @notice Delegates votes from signatory to `delegatee`
850      * @param delegatee The address to delegate votes to
851      * @param nonce The contract state required to match the signature
852      * @param expiry The time at which to expire the signature
853      * @param v The recovery byte of the signature
854      * @param r Half of the ECDSA signature pair
855      * @param s Half of the ECDSA signature pair
856      */
857     function delegateBySig(
858         address delegatee,
859         uint nonce,
860         uint expiry,
861         uint8 v,
862         bytes32 r,
863         bytes32 s
864     )
865     external
866     {
867         bytes32 domainSeparator = keccak256(
868             abi.encode(
869                 DOMAIN_TYPEHASH,
870                 keccak256(bytes(name())),
871                 getChainId(),
872                 address(this)
873             )
874         );
875 
876         bytes32 structHash = keccak256(
877             abi.encode(
878                 DELEGATION_TYPEHASH,
879                 delegatee,
880                 nonce,
881                 expiry
882             )
883         );
884 
885         bytes32 digest = keccak256(
886             abi.encodePacked(
887                 "\x19\x01",
888                 domainSeparator,
889                 structHash
890             )
891         );
892 
893         address signatory = ecrecover(digest, v, r, s);
894         require(signatory != address(0), "ZYX::delegateBySig: invalid signature");
895         require(nonce == nonces[signatory]++, "ZYX::delegateBySig: invalid nonce");
896         require(now <= expiry, "ZYX::delegateBySig: signature expired");
897         return _delegate(signatory, delegatee);
898     }
899 
900     /**
901      * @notice Gets the current votes balance for `account`
902      * @param account The address to get votes balance
903      * @return The number of current votes for `account`
904      */
905     function getCurrentVotes(address account)
906     external
907     view
908     returns (uint256)
909     {
910         uint32 nCheckpoints = numCheckpoints[account];
911         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
912     }
913 
914     /**
915      * @notice Determine the prior number of votes for an account as of a block number
916      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
917      * @param account The address of the account to check
918      * @param blockNumber The block number to get the vote balance at
919      * @return The number of votes the account had as of the given block
920      */
921     function getPriorVotes(address account, uint blockNumber)
922 
923     external
924     view
925     returns (uint256)
926     {
927         require(blockNumber < block.number, "ZYX::getPriorVotes: not yet determined");
928 
929         uint32 nCheckpoints = numCheckpoints[account];
930         if (nCheckpoints == 0) {
931             return 0;
932         }
933 
934         // First check most recent balance
935         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
936             return checkpoints[account][nCheckpoints - 1].votes;
937         }
938 
939         // Next check implicit zero balance
940         if (checkpoints[account][0].fromBlock > blockNumber) {
941             return 0;
942         }
943 
944         uint32 lower = 0;
945         uint32 upper = nCheckpoints - 1;
946         while (upper > lower) {
947             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
948             Checkpoint memory cp = checkpoints[account][center];
949             if (cp.fromBlock == blockNumber) {
950                 return cp.votes;
951             } else if (cp.fromBlock < blockNumber) {
952                 lower = center;
953             } else {
954                 upper = center - 1;
955             }
956         }
957         return checkpoints[account][lower].votes;
958     }
959 
960     function _delegate(address delegator, address delegatee)
961     internal
962     {
963         address currentDelegate = _delegates[delegator];
964         uint256 delegatorBalance = balanceOf(delegator);
965         _delegates[delegator] = delegatee;
966 
967         emit DelegateChanged(delegator, currentDelegate, delegatee);
968 
969         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
970     }
971 
972     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
973         if (srcRep != dstRep && amount > 0) {
974             if (srcRep != address(0)) {
975                 // decrease old representative
976                 uint32 srcRepNum = numCheckpoints[srcRep];
977                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
978                 uint256 srcRepNew = srcRepOld.sub(amount);
979                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
980             }
981 
982             if (dstRep != address(0)) {
983                 // increase new representative
984                 uint32 dstRepNum = numCheckpoints[dstRep];
985                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
986                 uint256 dstRepNew = dstRepOld.add(amount);
987                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
988             }
989         }
990     }
991 
992     function _writeCheckpoint(
993         address delegatee,
994         uint32 nCheckpoints,
995         uint256 oldVotes,
996         uint256 newVotes
997     )
998     internal
999     {
1000         uint32 blockNumber = safe32(block.number, "ZYX::_writeCheckpoint: block number exceeds 32 bits");
1001 
1002         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1003             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1004         } else {
1005             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1006             numCheckpoints[delegatee] = nCheckpoints + 1;
1007         }
1008 
1009         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1010     }
1011 
1012     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1013         require(n < 2**32, errorMessage);
1014         return uint32(n);
1015     }
1016 
1017     function getChainId() internal pure returns (uint) {
1018         uint256 chainId;
1019         assembly { chainId := chainid() }
1020         return chainId;
1021     }
1022 }