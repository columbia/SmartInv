1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.7.0;
3 
4 // _   _ _     __  ___ _  
5 //| |_| | |_/ / /\| |_) | Hikari.Finance
6 //|_| |_|_| \/_/--\_| \_| Coded by nashec using Solidity 0.7.0
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 contract ERC20 is Context, IERC20 {
90     using SafeMath for uint256;
91     using Address for address;
92 
93     mapping (address => uint256) private _balances;
94 
95     mapping (address => mapping (address => uint256)) private _allowances;
96 
97     uint256 private _totalSupply;
98 
99     string private _name;
100     string private _symbol;
101     uint8 private _decimals;
102 
103     /**
104      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
105      * a default value of 18.
106      *
107      * To select a different value for {decimals}, use {_setupDecimals}.
108      *
109      * All three of these values are immutable: they can only be set once during
110      * construction.
111      */
112     constructor (string memory name_, string memory symbol_) {
113         _name = name_;
114         _symbol = symbol_;
115         _decimals = 18;
116     }
117 
118     /**
119      * @dev Returns the name of the token.
120      */
121     function name() public view returns (string memory) {
122         return _name;
123     }
124 
125     /**
126      * @dev Returns the symbol of the token, usually a shorter version of the
127      * name.
128      */
129     function symbol() public view returns (string memory) {
130         return _symbol;
131     }
132 
133     /**
134      * @dev Returns the number of decimals used to get its user representation.
135      * For example, if `decimals` equals `2`, a balance of `505` tokens should
136      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
137      *
138      * Tokens usually opt for a value of 18, imitating the relationship between
139      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
140      * called.
141      *
142      * NOTE: This information is only used for _display_ purposes: it in
143      * no way affects any of the arithmetic of the contract, including
144      * {IERC20-balanceOf} and {IERC20-transfer}.
145      */
146     function decimals() public view returns (uint8) {
147         return _decimals;
148     }
149 
150     /**
151      * @dev See {IERC20-totalSupply}.
152      */
153     function totalSupply() public view override returns (uint256) {
154         return _totalSupply;
155     }
156 
157     /**
158      * @dev See {IERC20-balanceOf}.
159      */
160     function balanceOf(address account) public view override returns (uint256) {
161         return _balances[account];
162     }
163 
164     /**
165      * @dev See {IERC20-transfer}.
166      *
167      * Requirements:
168      *
169      * - `recipient` cannot be the zero address.
170      * - the caller must have a balance of at least `amount`.
171      */
172     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
173         _transfer(_msgSender(), recipient, amount);
174         return true;
175     }
176 
177     /**
178      * @dev See {IERC20-allowance}.
179      */
180     function allowance(address owner, address spender) public view virtual override returns (uint256) {
181         return _allowances[owner][spender];
182     }
183 
184     /**
185      * @dev See {IERC20-approve}.
186      *
187      * Requirements:
188      *
189      * - `spender` cannot be the zero address.
190      */
191     function approve(address spender, uint256 amount) public virtual override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     /**
197      * @dev See {IERC20-transferFrom}.
198      *
199      * Emits an {Approval} event indicating the updated allowance. This is not
200      * required by the EIP. See the note at the beginning of {ERC20};
201      *
202      * Requirements:
203      * - `sender` and `recipient` cannot be the zero address.
204      * - `sender` must have a balance of at least `amount`.
205      * - the caller must have allowance for ``sender``'s tokens of at least
206      * `amount`.
207      */
208     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214     /**
215      * @dev Atomically increases the allowance granted to `spender` by the caller.
216      *
217      * This is an alternative to {approve} that can be used as a mitigation for
218      * problems described in {IERC20-approve}.
219      *
220      * Emits an {Approval} event indicating the updated allowance.
221      *
222      * Requirements:
223      *
224      * - `spender` cannot be the zero address.
225      */
226     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
227         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
228         return true;
229     }
230 
231     /**
232      * @dev Atomically decreases the allowance granted to `spender` by the caller.
233      *
234      * This is an alternative to {approve} that can be used as a mitigation for
235      * problems described in {IERC20-approve}.
236      *
237      * Emits an {Approval} event indicating the updated allowance.
238      *
239      * Requirements:
240      *
241      * - `spender` cannot be the zero address.
242      * - `spender` must have allowance for the caller of at least
243      * `subtractedValue`.
244      */
245     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
246         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
247         return true;
248     }
249 
250     /**
251      * @dev Moves tokens `amount` from `sender` to `recipient`.
252      *
253      * This is internal function is equivalent to {transfer}, and can be used to
254      * e.g. implement automatic token fees, slashing mechanisms, etc.
255      *
256      * Emits a {Transfer} event.
257      *
258      * Requirements:
259      *
260      * - `sender` cannot be the zero address.
261      * - `recipient` cannot be the zero address.
262      * - `sender` must have a balance of at least `amount`.
263      */
264     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
265         require(sender != address(0), "ERC20: transfer from the zero address");
266         require(recipient != address(0), "ERC20: transfer to the zero address");
267 
268         _beforeTokenTransfer(sender, recipient, amount);
269 
270         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
271         _balances[recipient] = _balances[recipient].add(amount);
272         emit Transfer(sender, recipient, amount);
273     }
274 
275     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
276      * the total supply.
277      *
278      * Emits a {Transfer} event with `from` set to the zero address.
279      *
280      * Requirements
281      *
282      * - `to` cannot be the zero address.
283      */
284     function _mint(address account, uint256 amount) internal virtual {
285         require(account != address(0), "ERC20: mint to the zero address");
286 
287         _beforeTokenTransfer(address(0), account, amount);
288 
289         _totalSupply = _totalSupply.add(amount);
290         _balances[account] = _balances[account].add(amount);
291         emit Transfer(address(0), account, amount);
292     }
293 
294     /**
295      * @dev Destroys `amount` tokens from `account`, reducing the
296      * total supply.
297      *
298      * Emits a {Transfer} event with `to` set to the zero address.
299      *
300      * Requirements
301      *
302      * - `account` cannot be the zero address.
303      * - `account` must have at least `amount` tokens.
304      */
305     function _burn(address account, uint256 amount) internal virtual {
306         require(account != address(0), "ERC20: burn from the zero address");
307 
308         _beforeTokenTransfer(account, address(0), amount);
309 
310         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
311         _totalSupply = _totalSupply.sub(amount);
312         emit Transfer(account, address(0), amount);
313     }
314 
315     /**
316      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
317      *
318      * This internal function is equivalent to `approve`, and can be used to
319      * e.g. set automatic allowances for certain subsystems, etc.
320      *
321      * Emits an {Approval} event.
322      *
323      * Requirements:
324      *
325      * - `owner` cannot be the zero address.
326      * - `spender` cannot be the zero address.
327      */
328     function _approve(address owner, address spender, uint256 amount) internal virtual {
329         require(owner != address(0), "ERC20: approve from the zero address");
330         require(spender != address(0), "ERC20: approve to the zero address");
331 
332         _allowances[owner][spender] = amount;
333         emit Approval(owner, spender, amount);
334     }
335 
336     /**
337      * @dev Sets {decimals} to a value other than the default one of 18.
338      *
339      * WARNING: This function should only be called from the constructor. Most
340      * applications that interact with token contracts will not expect
341      * {decimals} to ever change, and may work incorrectly if it does.
342      */
343     function _setupDecimals(uint8 decimals_) internal {
344         _decimals = decimals_;
345     }
346 
347     /**
348      * @dev Hook that is called before any transfer of tokens. This includes
349      * minting and burning.
350      *
351      * Calling conditions:
352      *
353      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
354      * will be to transferred to `to`.
355      * - when `from` is zero, `amount` tokens will be minted for `to`.
356      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
357      * - `from` and `to` are never both zero.
358      *
359      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
360      */
361     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
362 }
363 
364 library SafeERC20 {
365     using SafeMath for uint256;
366     using Address for address;
367 
368     function safeTransfer(IERC20 token, address to, uint256 value) internal {
369         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
370     }
371 
372     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
373         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
374     }
375 
376     /**
377      * @dev Deprecated. This function has issues similar to the ones found in
378      * {IERC20-approve}, and its usage is discouraged.
379      *
380      * Whenever possible, use {safeIncreaseAllowance} and
381      * {safeDecreaseAllowance} instead.
382      */
383     function safeApprove(IERC20 token, address spender, uint256 value) internal {
384         // safeApprove should only be called when setting an initial allowance,
385         // or when resetting it to zero. To increase and decrease it, use
386         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
387         // solhint-disable-next-line max-line-length
388         require((value == 0) || (token.allowance(address(this), spender) == 0),
389             "SafeERC20: approve from non-zero to non-zero allowance"
390         );
391         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
392     }
393 
394     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
395         uint256 newAllowance = token.allowance(address(this), spender).add(value);
396         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
397     }
398 
399     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
400         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
401         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
402     }
403 
404     /**
405      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
406      * on the return value: the return value is optional (but if data is returned, it must not be false).
407      * @param token The token targeted by the call.
408      * @param data The call data (encoded using abi.encode or one of its variants).
409      */
410     function _callOptionalReturn(IERC20 token, bytes memory data) private {
411         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
412         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
413         // the target address contains contract code and also asserts for success in the low-level call.
414 
415         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
416         if (returndata.length > 0) { // Return data is optional
417             // solhint-disable-next-line max-line-length
418             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
419         }
420     }
421 }
422 library SafeMath {
423     /**
424      * @dev Returns the addition of two unsigned integers, reverting on
425      * overflow.
426      *
427      * Counterpart to Solidity's `+` operator.
428      *
429      * Requirements:
430      *
431      * - Addition cannot overflow.
432      */
433     function add(uint256 a, uint256 b) internal pure returns (uint256) {
434         uint256 c = a + b;
435         require(c >= a, "SafeMath: addition overflow");
436 
437         return c;
438     }
439 
440     /**
441      * @dev Returns the subtraction of two unsigned integers, reverting on
442      * overflow (when the result is negative).
443      *
444      * Counterpart to Solidity's `-` operator.
445      *
446      * Requirements:
447      *
448      * - Subtraction cannot overflow.
449      */
450     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
451         return sub(a, b, "SafeMath: subtraction overflow");
452     }
453 
454     /**
455      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
456      * overflow (when the result is negative).
457      *
458      * Counterpart to Solidity's `-` operator.
459      *
460      * Requirements:
461      *
462      * - Subtraction cannot overflow.
463      */
464     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
465         require(b <= a, errorMessage);
466         uint256 c = a - b;
467 
468         return c;
469     }
470 
471     /**
472      * @dev Returns the multiplication of two unsigned integers, reverting on
473      * overflow.
474      *
475      * Counterpart to Solidity's `*` operator.
476      *
477      * Requirements:
478      *
479      * - Multiplication cannot overflow.
480      */
481     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
482         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
483         // benefit is lost if 'b' is also tested.
484         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
485         if (a == 0) {
486             return 0;
487         }
488 
489         uint256 c = a * b;
490         require(c / a == b, "SafeMath: multiplication overflow");
491 
492         return c;
493     }
494 
495     /**
496      * @dev Returns the integer division of two unsigned integers. Reverts on
497      * division by zero. The result is rounded towards zero.
498      *
499      * Counterpart to Solidity's `/` operator. Note: this function uses a
500      * `revert` opcode (which leaves remaining gas untouched) while Solidity
501      * uses an invalid opcode to revert (consuming all remaining gas).
502      *
503      * Requirements:
504      *
505      * - The divisor cannot be zero.
506      */
507     function div(uint256 a, uint256 b) internal pure returns (uint256) {
508         return div(a, b, "SafeMath: division by zero");
509     }
510 
511     /**
512      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
513      * division by zero. The result is rounded towards zero.
514      *
515      * Counterpart to Solidity's `/` operator. Note: this function uses a
516      * `revert` opcode (which leaves remaining gas untouched) while Solidity
517      * uses an invalid opcode to revert (consuming all remaining gas).
518      *
519      * Requirements:
520      *
521      * - The divisor cannot be zero.
522      */
523     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
524         require(b > 0, errorMessage);
525         uint256 c = a / b;
526         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
527 
528         return c;
529     }
530 
531     /**
532      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
533      * Reverts when dividing by zero.
534      *
535      * Counterpart to Solidity's `%` operator. This function uses a `revert`
536      * opcode (which leaves remaining gas untouched) while Solidity uses an
537      * invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
544         return mod(a, b, "SafeMath: modulo by zero");
545     }
546 
547     /**
548      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
549      * Reverts with custom message when dividing by zero.
550      *
551      * Counterpart to Solidity's `%` operator. This function uses a `revert`
552      * opcode (which leaves remaining gas untouched) while Solidity uses an
553      * invalid opcode to revert (consuming all remaining gas).
554      *
555      * Requirements:
556      *
557      * - The divisor cannot be zero.
558      */
559     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
560         require(b != 0, errorMessage);
561         return a % b;
562     }
563 }
564 
565 library Address {
566     /**
567      * @dev Returns true if `account` is a contract.
568      *
569      * [IMPORTANT]
570      * ====
571      * It is unsafe to assume that an address for which this function returns
572      * false is an externally-owned account (EOA) and not a contract.
573      *
574      * Among others, `isContract` will return false for the following
575      * types of addresses:
576      *
577      *  - an externally-owned account
578      *  - a contract in construction
579      *  - an address where a contract will be created
580      *  - an address where a contract lived, but was destroyed
581      * ====
582      */
583     function isContract(address account) internal view returns (bool) {
584         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
585         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
586         // for accounts without code, i.e. `keccak256('')`
587         bytes32 codehash;
588         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
589         // solhint-disable-next-line no-inline-assembly
590         assembly { codehash := extcodehash(account) }
591         return (codehash != accountHash && codehash != 0x0);
592     }
593 
594     /**
595      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
596      * `recipient`, forwarding all available gas and reverting on errors.
597      *
598      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
599      * of certain opcodes, possibly making contracts go over the 2300 gas limit
600      * imposed by `transfer`, making them unable to receive funds via
601      * `transfer`. {sendValue} removes this limitation.
602      *
603      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
604      *
605      * IMPORTANT: because control is transferred to `recipient`, care must be
606      * taken to not create reentrancy vulnerabilities. Consider using
607      * {ReentrancyGuard} or the
608      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
609      */
610     function sendValue(address payable recipient, uint256 amount) internal {
611         require(address(this).balance >= amount, "Address: insufficient balance");
612 
613         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
614         (bool success, ) = recipient.call{ value: amount }("");
615         require(success, "Address: unable to send value, recipient may have reverted");
616     }
617 
618     /**
619      * @dev Performs a Solidity function call using a low level `call`. A
620      * plain`call` is an unsafe replacement for a function call: use this
621      * function instead.
622      *
623      * If `target` reverts with a revert reason, it is bubbled up by this
624      * function (like regular Solidity function calls).
625      *
626      * Returns the raw returned data. To convert to the expected return value,
627      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
628      *
629      * Requirements:
630      *
631      * - `target` must be a contract.
632      * - calling `target` with `data` must not revert.
633      *
634      * _Available since v3.1._
635      */
636     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
637       return functionCall(target, data, "Address: low-level call failed");
638     }
639 
640     /**
641      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
642      * `errorMessage` as a fallback revert reason when `target` reverts.
643      *
644      * _Available since v3.1._
645      */
646     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
647         return _functionCallWithValue(target, data, 0, errorMessage);
648     }
649 
650     /**
651      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
652      * but also transferring `value` wei to `target`.
653      *
654      * Requirements:
655      *
656      * - the calling contract must have an ETH balance of at least `value`.
657      * - the called Solidity function must be `payable`.
658      *
659      * _Available since v3.1._
660      */
661     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
662         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
667      * with `errorMessage` as a fallback revert reason when `target` reverts.
668      *
669      * _Available since v3.1._
670      */
671     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
672         require(address(this).balance >= value, "Address: insufficient balance for call");
673         return _functionCallWithValue(target, data, value, errorMessage);
674     }
675 
676     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
677         require(isContract(target), "Address: call to non-contract");
678 
679         // solhint-disable-next-line avoid-low-level-calls
680         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
681         if (success) {
682             return returndata;
683         } else {
684             // Look for revert reason and bubble it up if present
685             if (returndata.length > 0) {
686                 // The easiest way to bubble the revert reason is using memory via assembly
687 
688                 // solhint-disable-next-line no-inline-assembly
689                 assembly {
690                     let returndata_size := mload(returndata)
691                     revert(add(32, returndata), returndata_size)
692                 }
693             } else {
694                 revert(errorMessage);
695             }
696         }
697     }
698 }
699 
700 contract Hikari is ERC20 {
701 
702     using SafeERC20 for IERC20;
703     using SafeMath for uint256;
704 
705     address owner;
706     address private hikariFundingAddress;
707     address private yamiFundingAddress;
708 
709     uint256 private InitialSupply = 40000;
710 
711     IERC20 private hikari;
712     IERC20 private yami;
713 
714     modifier _onlyOwner(){require(msg.sender == owner);_;}
715     constructor() payable ERC20("Hikari.Finance", "HIKARI") {owner = msg.sender;  _mint(msg.sender, InitialSupply.mul(10 ** 18));
716         hikariFundingAddress = msg.sender; yamiFundingAddress = msg.sender;
717     }
718 
719     function setHikariAddress(address hikariAddress) public _onlyOwner{hikari = IERC20(hikariAddress);}
720     function setYamiAddress(address yamiAddress) public _onlyOwner{yami = IERC20(yamiAddress);}
721 
722     function setHikariFundingAddress(address _hikariFundingAddress) public _onlyOwner returns(uint256){hikariFundingAddress = _hikariFundingAddress;}
723     function setYamiFundingAddress(address _yamiFundingAddress) public _onlyOwner returns(uint256){yamiFundingAddress = _yamiFundingAddress;}
724     
725     function getFundingHikariAddress() public view returns (address){hikariFundingAddress;}
726     function getFundingYamiAddress() public view returns (address){yamiFundingAddress;}
727 
728     function getFundedHikari() public view returns (uint256){hikari.balanceOf(owner);}
729     function getFundedYami() public view returns (uint256){yami.balanceOf(owner);}
730 
731     function transferFundedHikari(uint256 amount) public {
732         hikari.safeTransfer(hikariFundingAddress, amount);
733     }
734 
735     function transferFundedYami(uint256 amount) public {
736         yami.safeTransfer(yamiFundingAddress, amount);
737     }
738 }