1 /**
2  * @title SafeMath
3  * Decimals : 18
4  * TotalSupply : 40,000 XYfinance
5  * Source By MIT Licence 
6  **/
7 
8 pragma solidity ^0.6.6;
9 
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence. 
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      *
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 
265 /**
266  * @dev Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
288         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
289         // for accounts without code, i.e. `keccak256('')`
290         bytes32 codehash;
291         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { codehash := extcodehash(account) }
294         return (codehash != accountHash && codehash != 0x0);
295     }
296 
297     /**
298      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
299      * `recipient`, forwarding all available gas and reverting on errors.
300      *
301      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
302      * of certain opcodes, possibly making contracts go over the 2300 gas limit
303      * imposed by `transfer`, making them unable to receive funds via
304      * `transfer`. {sendValue} removes this limitation.
305      *
306      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
307      *
308      * IMPORTANT: because control is transferred to `recipient`, care must be
309      * taken to not create reentrancy vulnerabilities. Consider using
310      * {ReentrancyGuard} or the
311      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
312      */
313     function sendValue(address payable recipient, uint256 amount) internal {
314         require(address(this).balance >= amount, "Address: insufficient balance");
315 
316         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
317         (bool success, ) = recipient.call{ value: amount }("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 
321     /**
322      * @dev Performs a Solidity function call using a low level `call`. A
323      * plain`call` is an unsafe replacement for a function call: use this
324      * function instead.
325      *
326      * If `target` reverts with a revert reason, it is bubbled up by this
327      * function (like regular Solidity function calls).
328      *
329      * Returns the raw returned data. To convert to the expected return value,
330      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
331      *
332      * Requirements:
333      *
334      * - `target` must be a contract.
335      * - calling `target` with `data` must not revert.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
340       return functionCall(target, data, "Address: low-level call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
345      * `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
350         return _functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
370      * with `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         return _functionCallWithValue(target, data, value, errorMessage);
377     }
378 
379     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
380         require(isContract(target), "Address: call to non-contract");
381 
382         // solhint-disable-next-line avoid-low-level-calls
383         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390 
391                 // solhint-disable-next-line no-inline-assembly
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 /**
404  * @dev Implementation of the {IERC20} interface.
405  *
406  * This implementation is agnostic to the way tokens are created. This means
407  * that a supply mechanism has to be added in a derived contract using {_mint}.
408  * For a generic mechanism see {ERC20PresetMinterPauser}.
409  *
410  * TIP: For a detailed writeup see our guide
411  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
412  * to implement supply mechanisms].
413  *
414  * We have followed general OpenZeppelin guidelines: functions revert instead
415  * of returning `false` on failure. This behavior is nonetheless conventional
416  * and does not conflict with the expectations of ERC20 applications.
417  *
418  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
419  * This allows applications to reconstruct the allowance for all accounts just
420  * by listening to said events. Other implementations of the EIP may not emit
421  * these events, as it isn't required by the specification.
422  *
423  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
424  * functions have been added to mitigate the well-known issues around setting
425  * allowances. See {IERC20-approve}.
426  */
427 contract ERC20 is Context, IERC20 {
428     using SafeMath for uint256;
429     using Address for address;
430 
431     mapping (address => uint256) private _balances;
432 
433     mapping (address => mapping (address => uint256)) private _allowances;
434 
435     uint256 private _totalSupply;
436 
437     string private _name;
438     string private _symbol;
439     uint8 private _decimals;
440 
441     /**
442      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
443      * a default value of 18.
444      *
445      * To select a different value for {decimals}, use {_setupDecimals}.
446      *
447      * All three of these values are immutable: they can only be set once during
448      * construction.
449      */
450     constructor (string memory name, string memory symbol) public {
451         _name = name;
452         _symbol = symbol;
453         _decimals = 18;
454     }
455 
456     /**
457      * @dev Returns the name of the token.
458      */
459     function name() public view returns (string memory) {
460         return _name;
461     }
462 
463     /**
464      * @dev Returns the symbol of the token, usually a shorter version of the
465      * name.
466      */
467     function symbol() public view returns (string memory) {
468         return _symbol;
469     }
470 
471     /**
472      * @dev Returns the number of decimals used to get its user representation.
473      * For example, if `decimals` equals `2`, a balance of `505` tokens should
474      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
475      *
476      * Tokens usually opt for a value of 18, imitating the relationship between
477      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
478      * called.
479      *
480      * NOTE: This information is only used for _display_ purposes: it in
481      * no way affects any of the arithmetic of the contract, including
482      * {IERC20-balanceOf} and {IERC20-transfer}.
483      */
484     function decimals() public view returns (uint8) {
485         return _decimals;
486     }
487 
488     /**
489      * @dev See {IERC20-totalSupply}.
490      */
491     function totalSupply() public view override returns (uint256) {
492         return _totalSupply;
493     }
494 
495     /**
496      * @dev See {IERC20-balanceOf}.
497      */
498     function balanceOf(address account) public view override returns (uint256) {
499         return _balances[account];
500     }
501 
502     /**
503      * @dev See {IERC20-transfer}.
504      *
505      * Requirements:
506      *
507      * - `recipient` cannot be the zero address.
508      * - the caller must have a balance of at least `amount`.
509      */
510     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
511         _transfer(_msgSender(), recipient, amount);
512         return true;
513     }
514 
515     /**
516      * @dev See {IERC20-allowance}.
517      */
518     function allowance(address owner, address spender) public view virtual override returns (uint256) {
519         return _allowances[owner][spender];
520     }
521 
522     /**
523      * @dev See {IERC20-approve}.
524      *
525      * Requirements:
526      *
527      * - `spender` cannot be the zero address.
528      */
529     function approve(address spender, uint256 amount) public virtual override returns (bool) {
530         _approve(_msgSender(), spender, amount);
531         return true;
532     }
533 
534     /**
535      * @dev See {IERC20-transferFrom}.
536      *
537      * Emits an {Approval} event indicating the updated allowance. This is not
538      * required by the EIP. See the note at the beginning of {ERC20};
539      *
540      * Requirements:
541      * - `sender` and `recipient` cannot be the zero address.
542      * - `sender` must have a balance of at least `amount`.
543      * - the caller must have allowance for ``sender``'s tokens of at least
544      * `amount`.
545      */
546     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
547         _transfer(sender, recipient, amount);
548         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
549         return true;
550     }
551 
552     /**
553      * @dev Atomically increases the allowance granted to `spender` by the caller.
554      *
555      * This is an alternative to {approve} that can be used as a mitigation for
556      * problems described in {IERC20-approve}.
557      *
558      * Emits an {Approval} event indicating the updated allowance.
559      *
560      * Requirements:
561      *
562      * - `spender` cannot be the zero address.
563      */
564     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
565         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
566         return true;
567     }
568 
569     /**
570      * @dev Atomically decreases the allowance granted to `spender` by the caller.
571      *
572      * This is an alternative to {approve} that can be used as a mitigation for
573      * problems described in {IERC20-approve}.
574      *
575      * Emits an {Approval} event indicating the updated allowance.
576      *
577      * Requirements:
578      *
579      * - `spender` cannot be the zero address.
580      * - `spender` must have allowance for the caller of at least
581      * `subtractedValue`.
582      */
583     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
584         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
585         return true;
586     }
587 
588     /**
589      * @dev Moves tokens `amount` from `sender` to `recipient`.
590      *
591      * This is internal function is equivalent to {transfer}, and can be used to
592      * e.g. implement automatic token fees, slashing mechanisms, etc.
593      *
594      * Emits a {Transfer} event.
595      *
596      * Requirements:
597      *
598      * - `sender` cannot be the zero address.
599      * - `recipient` cannot be the zero address.
600      * - `sender` must have a balance of at least `amount`.
601      */
602     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
603         require(sender != address(0), "ERC20: transfer from the zero address");
604         require(recipient != address(0), "ERC20: transfer to the zero address");
605 
606         _beforeTokenTransfer(sender, recipient, amount);
607 
608         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
609         _balances[recipient] = _balances[recipient].add(amount);
610         emit Transfer(sender, recipient, amount);
611     }
612 
613     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
614      * the total supply.
615      *
616      * Emits a {Transfer} event with `from` set to the zero address.
617      *
618      * Requirements
619      *
620      * - `to` cannot be the zero address.
621      */
622     function _mint(address account, uint256 amount) internal virtual {
623         require(account != address(0), "ERC20: mint to the zero address");
624 
625         _beforeTokenTransfer(address(0), account, amount);
626 
627         _totalSupply = _totalSupply.add(amount);
628         _balances[account] = _balances[account].add(amount);
629         emit Transfer(address(0), account, amount);
630     }
631 
632     /**
633      * @dev Destroys `amount` tokens from `account`, reducing the
634      * total supply.
635      *
636      * Emits a {Transfer} event with `to` set to the zero address.
637      *
638      * Requirements
639      *
640      * - `account` cannot be the zero address.
641      * - `account` must have at least `amount` tokens.
642      */
643     function _burn(address account, uint256 amount) internal virtual {
644         require(account != address(0), "ERC20: burn from the zero address");
645 
646         _beforeTokenTransfer(account, address(0), amount);
647 
648         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
649         _totalSupply = _totalSupply.sub(amount);
650         emit Transfer(account, address(0), amount);
651     }
652 
653     /**
654      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
655      *
656      * This is internal function is equivalent to `approve`, and can be used to
657      * e.g. set automatic allowances for certain subsystems, etc.
658      *
659      * Emits an {Approval} event.
660      *
661      * Requirements:
662      *
663      * - `owner` cannot be the zero address.
664      * - `spender` cannot be the zero address.
665      */
666     function _approve(address owner, address spender, uint256 amount) internal virtual {
667         require(owner != address(0), "ERC20: approve from the zero address");
668         require(spender != address(0), "ERC20: approve to the zero address");
669 
670         _allowances[owner][spender] = amount;
671         emit Approval(owner, spender, amount);
672     }
673 
674     /**
675      * @dev Sets {decimals} to a value other than the default one of 18.
676      *
677      * WARNING: This function should only be called from the constructor. Most
678      * applications that interact with token contracts will not expect
679      * {decimals} to ever change, and may work incorrectly if it does.
680      */
681     function _setupDecimals(uint8 decimals_) internal {
682         _decimals = decimals_;
683     }
684 
685     /**
686      * @dev Hook that is called before any transfer of tokens. This includes
687      * minting and burning.
688      *
689      * Calling conditions:
690      *
691      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
692      * will be to transferred to `to`.
693      * - when `from` is zero, `amount` tokens will be minted for `to`.
694      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
695      * - `from` and `to` are never both zero.
696      *
697      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
698      */
699     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
700 }
701 
702 
703 contract XYfinance is ERC20 {
704     constructor ()
705         ERC20('XYfinance', 'XYFI')
706         public
707     {
708         _mint(0xA2C77c328Ff576D7c7a24f6c6CF0026B52779680, 40000 * 10 ** uint(decimals()));
709     }
710 }