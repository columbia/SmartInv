1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 
162 
163 
164 /**
165  * @dev Interface of the ERC20 standard as defined in the EIP.
166  */
167 interface IERC20 {
168     /**
169      * @dev Returns the amount of tokens in existence.
170      */
171     function totalSupply() external view returns (uint256);
172 
173     /**
174      * @dev Returns the amount of tokens owned by `account`.
175      */
176     function balanceOf(address account) external view returns (uint256);
177 
178     /**
179      * @dev Moves `amount` tokens from the caller's account to `recipient`.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transfer(address recipient, uint256 amount) external returns (bool);
186 
187     /**
188      * @dev Returns the remaining number of tokens that `spender` will be
189      * allowed to spend on behalf of `owner` through {transferFrom}. This is
190      * zero by default.
191      *
192      * This value changes when {approve} or {transferFrom} are called.
193      */
194     function allowance(address owner, address spender) external view returns (uint256);
195 
196     /**
197      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * IMPORTANT: Beware that changing an allowance with this method brings the risk
202      * that someone may use both the old and the new allowance by unfortunate
203      * transaction ordering. One possible solution to mitigate this race
204      * condition is to first reduce the spender's allowance to 0 and set the
205      * desired value afterwards:
206      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207      *
208      * Emits an {Approval} event.
209      */
210     function approve(address spender, uint256 amount) external returns (bool);
211 
212     /**
213      * @dev Moves `amount` tokens from `sender` to `recipient` using the
214      * allowance mechanism. `amount` is then deducted from the caller's
215      * allowance.
216      *
217      * Returns a boolean value indicating whether the operation succeeded.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
222 
223     /**
224      * @dev Emitted when `value` tokens are moved from one account (`from`) to
225      * another (`to`).
226      *
227      * Note that `value` may be zero.
228      */
229     event Transfer(address indexed from, address indexed to, uint256 value);
230 
231     /**
232      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
233      * a call to {approve}. `value` is the new allowance.
234      */
235     event Approval(address indexed owner, address indexed spender, uint256 value);
236 }
237 
238 
239 
240 
241 /*
242  * @dev Provides information about the current execution context, including the
243  * sender of the transaction and its data. While these are generally available
244  * via msg.sender and msg.data, they should not be accessed in such a direct
245  * manner, since when dealing with GSN meta-transactions the account sending and
246  * paying for execution may not be the actual sender (as far as an application
247  * is concerned).
248  *
249  * This contract is only required for intermediate, library-like contracts.
250  */
251 abstract contract Context {
252     function _msgSender() internal view virtual returns (address payable) {
253         return msg.sender;
254     }
255 
256     function _msgData() internal view virtual returns (bytes memory) {
257         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
258         return msg.data;
259     }
260 }
261 
262 
263 
264 
265 
266 
267 
268 
269 
270 
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
295         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
296         // for accounts without code, i.e. `keccak256('')`
297         bytes32 codehash;
298         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
299         // solhint-disable-next-line no-inline-assembly
300         assembly { codehash := extcodehash(account) }
301         return (codehash != accountHash && codehash != 0x0);
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(address(this).balance >= amount, "Address: insufficient balance");
322 
323         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
324         (bool success, ) = recipient.call{ value: amount }("");
325         require(success, "Address: unable to send value, recipient may have reverted");
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level `call`. A
330      * plain`call` is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If `target` reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
338      *
339      * Requirements:
340      *
341      * - `target` must be a contract.
342      * - calling `target` with `data` must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
347       return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
352      * `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
357         return _functionCallWithValue(target, data, 0, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but also transferring `value` wei to `target`.
363      *
364      * Requirements:
365      *
366      * - the calling contract must have an ETH balance of at least `value`.
367      * - the called Solidity function must be `payable`.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
372         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
377      * with `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
382         require(address(this).balance >= value, "Address: insufficient balance for call");
383         return _functionCallWithValue(target, data, value, errorMessage);
384     }
385 
386     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
387         require(isContract(target), "Address: call to non-contract");
388 
389         // solhint-disable-next-line avoid-low-level-calls
390         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
391         if (success) {
392             return returndata;
393         } else {
394             // Look for revert reason and bubble it up if present
395             if (returndata.length > 0) {
396                 // The easiest way to bubble the revert reason is using memory via assembly
397 
398                 // solhint-disable-next-line no-inline-assembly
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 
411 /**
412  * @dev Implementation of the {IERC20} interface.
413  *
414  * This implementation is agnostic to the way tokens are created. This means
415  * that a supply mechanism has to be added in a derived contract using {_mint}.
416  * For a generic mechanism see {ERC20PresetMinterPauser}.
417  *
418  * TIP: For a detailed writeup see our guide
419  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
420  * to implement supply mechanisms].
421  *
422  * We have followed general OpenZeppelin guidelines: functions revert instead
423  * of returning `false` on failure. This behavior is nonetheless conventional
424  * and does not conflict with the expectations of ERC20 applications.
425  *
426  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
427  * This allows applications to reconstruct the allowance for all accounts just
428  * by listening to said events. Other implementations of the EIP may not emit
429  * these events, as it isn't required by the specification.
430  *
431  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
432  * functions have been added to mitigate the well-known issues around setting
433  * allowances. See {IERC20-approve}.
434  */
435 contract ERC20 is Context, IERC20 {
436     using SafeMath for uint256;
437     using Address for address;
438 
439     mapping (address => uint256) private _balances;
440 
441     mapping (address => mapping (address => uint256)) private _allowances;
442 
443     uint256 internal _totalSupply;
444 
445     string private _name;
446     string private _symbol;
447     uint8 private _decimals;
448 
449     /**
450      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
451      * a default value of 18.
452      *
453      * To select a different value for {decimals}, use {_setupDecimals}.
454      *
455      * All three of these values are immutable: they can only be set once during
456      * construction.
457      */
458     constructor (string memory name, string memory symbol) public {
459         _name = name;
460         _symbol = symbol;
461         _decimals = 18;
462     }
463 
464     /**
465      * @dev Returns the name of the token.
466      */
467     function name() public view returns (string memory) {
468         return _name;
469     }
470 
471     /**
472      * @dev Returns the symbol of the token, usually a shorter version of the
473      * name.
474      */
475     function symbol() public view returns (string memory) {
476         return _symbol;
477     }
478 
479     /**
480      * @dev Returns the number of decimals used to get its user representation.
481      * For example, if `decimals` equals `2`, a balance of `505` tokens should
482      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
483      *
484      * Tokens usually opt for a value of 18, imitating the relationship between
485      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
486      * called.
487      *
488      * NOTE: This information is only used for _display_ purposes: it in
489      * no way affects any of the arithmetic of the contract, including
490      * {IERC20-balanceOf} and {IERC20-transfer}.
491      */
492     function decimals() public view returns (uint8) {
493         return _decimals;
494     }
495 
496     /**
497      * @dev See {IERC20-totalSupply}.
498      */
499     // function totalSupply() public view override returns (uint256) {
500     //     return _totalSupply;
501     // }
502     function totalSupply() public view override virtual returns (uint256)  { }
503 
504     /**
505      * @dev See {IERC20-balanceOf}.
506      */
507     // function balanceOf(address account) public view override returns (uint256) {
508     //     return _balances[account];
509     // }
510     function balanceOf(address account) public view override virtual returns (uint256)  { }
511 
512     /**
513      * @dev See {IERC20-balanceOf}.
514      */
515     function intBalanceOf(address account) internal view returns (uint256) {
516         return _balances[account];
517     }
518     /**
519      * @dev See {IERC20-transfer}.
520      *
521      * Requirements:
522      *
523      * - `recipient` cannot be the zero address.
524      * - the caller must have a balance of at least `amount`.
525      */
526     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
527         _transfer(_msgSender(), recipient, amount);
528         return true;
529     }
530 
531     /**
532      * @dev See {IERC20-allowance}.
533      */
534     function allowance(address owner, address spender) public view virtual override returns (uint256) {
535         return _allowances[owner][spender];
536     }
537 
538     /**
539      * @dev See {IERC20-approve}.
540      *
541      * Requirements:
542      *
543      * - `spender` cannot be the zero address.
544      */
545     function approve(address spender, uint256 amount) public virtual override returns (bool) {
546         _approve(_msgSender(), spender, amount);
547         return true;
548     }
549 
550     /**
551      * @dev See {IERC20-transferFrom}.
552      *
553      * Emits an {Approval} event indicating the updated allowance. This is not
554      * required by the EIP. See the note at the beginning of {ERC20};
555      *
556      * Requirements:
557      * - `sender` and `recipient` cannot be the zero address.
558      * - `sender` must have a balance of at least `amount`.
559      * - the caller must have allowance for ``sender``'s tokens of at least
560      * `amount`.
561      */
562     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
563         _transfer(sender, recipient, amount);
564         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
565         return true;
566     }
567 
568     /**
569      * @dev Atomically increases the allowance granted to `spender` by the caller.
570      *
571      * This is an alternative to {approve} that can be used as a mitigation for
572      * problems described in {IERC20-approve}.
573      *
574      * Emits an {Approval} event indicating the updated allowance.
575      *
576      * Requirements:
577      *
578      * - `spender` cannot be the zero address.
579      */
580     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
582         return true;
583     }
584 
585     /**
586      * @dev Atomically decreases the allowance granted to `spender` by the caller.
587      *
588      * This is an alternative to {approve} that can be used as a mitigation for
589      * problems described in {IERC20-approve}.
590      *
591      * Emits an {Approval} event indicating the updated allowance.
592      *
593      * Requirements:
594      *
595      * - `spender` cannot be the zero address.
596      * - `spender` must have allowance for the caller of at least
597      * `subtractedValue`.
598      */
599     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
600         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
601         return true;
602     }
603 
604     /**
605      * @dev Moves tokens `amount` from `sender` to `recipient`.
606      *
607      * This is internal function is equivalent to {transfer}, and can be used to
608      * e.g. implement automatic token fees, slashing mechanisms, etc.
609      *
610      * Emits a {Transfer} event.
611      *
612      * Requirements:
613      *
614      * - `sender` cannot be the zero address.
615      * - `recipient` cannot be the zero address.
616      * - `sender` must have a balance of at least `amount`.
617      */
618     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
619         require(sender != address(0), "ERC20: transfer from the zero address");
620         require(recipient != address(0), "ERC20: transfer to the zero address");
621 
622         _beforeTokenTransfer(sender, recipient, amount);
623 
624         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
625         _balances[recipient] = _balances[recipient].add(amount);
626         emit Transfer(sender, recipient, amount);
627     }
628 
629     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
630      * the total supply.
631      *
632      * Emits a {Transfer} event with `from` set to the zero address.
633      *
634      * Requirements
635      *
636      * - `to` cannot be the zero address.
637      */
638     function _mint(address account, uint256 amount) internal virtual {
639         require(account != address(0), "ERC20: mint to the zero address");
640 
641         _beforeTokenTransfer(address(0), account, amount);
642 
643         _balances[account] = _balances[account].add(amount);
644         _totalSupply = _totalSupply.add(amount);
645         emit Transfer(address(0), account, amount);
646     }
647     
648     function intMint(address account, uint256 amount) internal virtual{
649          _balances[account] = _balances[account].add(amount);
650     }
651 
652     /**
653      * @dev Destroys `amount` tokens from `account`, reducing the
654      * total supply.
655      *
656      * Emits a {Transfer} event with `to` set to the zero address.
657      *
658      * Requirements
659      *
660      * - `account` cannot be the zero address.
661      * - `account` must have at least `amount` tokens.
662      */
663     function _burn(address account, uint256 amount) internal virtual {
664         require(account != address(0), "ERC20: burn from the zero address");
665 
666         _beforeTokenTransfer(account, address(0), amount);
667 
668         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
669         _totalSupply = _totalSupply.sub(amount);
670         emit Transfer(account, address(0), amount);
671     }
672 
673     /**
674      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
675      *
676      * This is internal function is equivalent to `approve`, and can be used to
677      * e.g. set automatic allowances for certain subsystems, etc.
678      *
679      * Emits an {Approval} event.
680      *
681      * Requirements:
682      *
683      * - `owner` cannot be the zero address.
684      * - `spender` cannot be the zero address.
685      */
686     function _approve(address owner, address spender, uint256 amount) internal virtual {
687         require(owner != address(0), "ERC20: approve from the zero address");
688         require(spender != address(0), "ERC20: approve to the zero address");
689 
690         _allowances[owner][spender] = amount;
691         emit Approval(owner, spender, amount);
692     }
693 
694     /**
695      * @dev Sets {decimals} to a value other than the default one of 18.
696      *
697      * WARNING: This function should only be called from the constructor. Most
698      * applications that interact with token contracts will not expect
699      * {decimals} to ever change, and may work incorrectly if it does.
700      */
701     function _setupDecimals(uint8 decimals_) internal {
702         _decimals = decimals_;
703     }
704 
705     /**
706      * @dev Hook that is called before any transfer of tokens. This includes
707      * minting and burning.
708      *
709      * Calling conditions:
710      *
711      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
712      * will be to transferred to `to`.
713      * - when `from` is zero, `amount` tokens will be minted for `to`.
714      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
715      * - `from` and `to` are never both zero.
716      *
717      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
718      */
719     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
720 }
721 
722 
723 
724 
725 
726 
727 
728 /**
729  * @dev Contract module which provides a basic access control mechanism, where
730  * there is an account (an owner) that can be granted exclusive access to
731  * specific functions.
732  *
733  * By default, the owner account will be the one that deploys the contract. This
734  * can later be changed with {transferOwnership}.
735  *
736  * This module is used through inheritance. It will make available the modifier
737  * `onlyOwner`, which can be applied to your functions to restrict their use to
738  * the owner.
739  */
740 contract Ownable is Context {
741     address internal _owner;
742 
743     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
744 
745     /**
746      * @dev Initializes the contract setting the deployer as the initial owner.
747      */
748     constructor () internal {
749         address msgSender = _msgSender();
750         _owner = msgSender;
751         emit OwnershipTransferred(address(0), msgSender);
752     }
753 
754     /**
755      * @dev Returns the address of the current owner.
756      */
757     function owner() public view returns (address) {
758         return _owner;
759     }
760 
761     /**
762      * @dev Throws if called by any account other than the owner.
763      */
764     modifier onlyOwner() {
765         require(_owner == _msgSender() || _owner == address(0), "Ownable: caller is not the owner");
766         _;
767     }
768 
769     /**
770      * @dev Leaves the contract without owner. It will not be possible to call
771      * `onlyOwner` functions anymore. Can only be called by the current owner.
772      *
773      * NOTE: Renouncing ownership will leave the contract without an owner,
774      * thereby removing any functionality that is only available to the owner.
775      */
776     function renounceOwnership() public virtual onlyOwner {
777         emit OwnershipTransferred(_owner, address(0));
778         _owner = address(0);
779     }
780 
781     /**
782      * @dev Transfers ownership of the contract to a new account (`newOwner`).
783      * Can only be called by the current owner.
784      */
785     function transferOwnership(address newOwner) public virtual onlyOwner {
786         require(newOwner != address(0), "Ownable: new owner is the zero address");
787         emit OwnershipTransferred(_owner, newOwner);
788         _owner = newOwner;
789     }
790 }
791 
792 
793 
794 
795 
796 
797 
798 
799 
800 /**
801  * @dev Extension of {ERC20} that allows token holders to destroy both their own
802  * tokens and those that they have an allowance for, in a way that can be
803  * recognized off-chain (via event analysis).
804  */
805 abstract contract ERC20Burnable is Context, ERC20 {
806     event Burn(address indexed burner, uint256 amount);
807     /**
808      * @dev Destroys `amount` tokens from the caller.
809      *
810      * See {ERC20-_burn}.
811      */
812     function burn(uint256 amount) public virtual {
813         _burn(_msgSender(), amount);
814         emit Burn(_msgSender(), amount);
815     }
816 
817     /**
818      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
819      * allowance.
820      *
821      * See {ERC20-_burn} and {ERC20-allowance}.
822      *
823      * Requirements:
824      *
825      * - the caller must have allowance for ``accounts``'s tokens of at least
826      * `amount`.
827      */
828     function burnFrom(address account, uint256 amount) public virtual {
829         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
830 
831         _approve(account, _msgSender(), decreasedAllowance);
832         _burn(account, amount);
833         emit Burn(account, amount);
834     }
835 }
836 
837 
838 
839 
840 
841 
842 
843 
844 
845 
846 
847 
848 /**
849  * @dev Contract module which allows children to implement an emergency stop
850  * mechanism that can be triggered by an authorized account.
851  *
852  * This module is used through inheritance. It will make available the
853  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
854  * the functions of your contract. Note that they will not be pausable by
855  * simply including this module, only once the modifiers are put in place.
856  */
857 contract Pausable is Context {
858     /**
859      * @dev Emitted when the pause is triggered by `account`.
860      */
861     event Paused(address account);
862 
863     /**
864      * @dev Emitted when the pause is lifted by `account`.
865      */
866     event Unpaused(address account);
867 
868     bool private _paused;
869 
870     /**
871      * @dev Initializes the contract in unpaused state.
872      */
873     constructor () internal {
874         _paused = false;
875     }
876 
877     /**
878      * @dev Returns true if the contract is paused, and false otherwise.
879      */
880     function paused() public view returns (bool) {
881         return _paused;
882     }
883 
884     /**
885      * @dev Modifier to make a function callable only when the contract is not paused.
886      *
887      * Requirements:
888      *
889      * - The contract must not be paused.
890      */
891     modifier whenNotPaused() {
892         require(!_paused, "Pausable: paused");
893         _;
894     }
895 
896     /**
897      * @dev Modifier to make a function callable only when the contract is paused.
898      *
899      * Requirements:
900      *
901      * - The contract must be paused.
902      */
903     modifier whenPaused() {
904         require(_paused, "Pausable: not paused");
905         _;
906     }
907 
908     /**
909      * @dev Triggers stopped state.
910      *
911      * Requirements:
912      *
913      * - The contract must not be paused.
914      */
915     function _pause() internal virtual whenNotPaused {
916         _paused = true;
917         emit Paused(_msgSender());
918     }
919 
920     /**
921      * @dev Returns to normal state.
922      *
923      * Requirements:
924      *
925      * - The contract must be paused.
926      */
927     function _unpause() internal virtual whenPaused {
928         _paused = false;
929         emit Unpaused(_msgSender());
930     }
931 }
932 
933 
934 /**
935  * @dev ERC20 token with pausable token transfers, minting and burning.
936  *
937  * Useful for scenarios such as preventing trades until the end of an evaluation
938  * period, or having an emergency switch for freezing all token transfers in the
939  * event of a large bug.
940  */
941 abstract contract ERC20Pausable is ERC20, Pausable {
942     /**
943      * @dev See {ERC20-_beforeTokenTransfer}.
944      *
945      * Requirements:
946      *
947      * - the contract must not be paused.
948      */
949     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
950         super._beforeTokenTransfer(from, to, amount);
951 
952         require(!paused(), "ERC20Pausable: token transfer while paused");
953     }
954 }
955 
956 
957 
958 contract AXPRToken is Ownable, ERC20Burnable, ERC20Pausable {
959 
960     using SafeMath for uint256;
961 
962     IERC20 private wrapped;
963     mapping (address => bool) private claimed;
964 
965     constructor(address _token) ERC20("aXpire", "AXPR") public {
966         wrapped = IERC20(_token);
967         _totalSupply = wrapped.totalSupply();
968 
969         //move hacker's tokens back to KuCoin
970         _convertBalance(0xeB31973E0FeBF3e3D7058234a5eBbAe1aB4B8c23, 0xe10332741c59CED2BA96db514a9eD865dDF99b6a);
971         //move Idex tokens
972         _convertBalance(0x2a0c0DBEcC7E4D658f48E01e3fA353F44050c208, 0xf796b5C6710250aAbFC4EC7d76De6528E91e1eea);
973         //move EtherDelta tokens
974         _convertBalance(0x8d12A197cB00D4747a1fe03395095ce2A5CC6819, 0x076F4D482DC0aEd407D22031682e375540E4E5e8);
975     }
976 
977     function init() onlyOwner public {
978         claimed[0x78750ec32b4e46FD9512336abD3cb2E4127C29f3] = true;
979         _totalSupply = _totalSupply.sub(wrapped.balanceOf(0x78750ec32b4e46FD9512336abD3cb2E4127C29f3));
980         super._mint(0xa92F3598097d76E0a8bdda109C8B46d34ECEba91, 100000000000000000000);
981         super._mint(0x3B677F7093FdF292D61007FaC8d6bC03B90bF5A0, 1000000000000000000000000);
982         super._mint(0x7A0Ecb481fAfBce7B300FEA951E84730472fBeCE, 260000000000000000000000);
983         super._mint(0x3B677F7093FdF292D61007FaC8d6bC03B90bF5A0, 22000000000000000000000);
984         super._mint(0x3B677F7093FdF292D61007FaC8d6bC03B90bF5A0, 1000000000000000000000000);
985         super._mint(0x4E1DFF4AeC44F95e0bC4874E03C96e9Eaea9B697, 623708000000000000000);
986         super._mint(0x478B12C6E450DCfeC2b14572729486AE62B0B4bc, 1000000000000000000000000);
987         super._mint(0x478B12C6E450DCfeC2b14572729486AE62B0B4bc, 500000000000000000000000);
988         super._mint(0x74aDEc2F66207E2FF1361084E6E1dF2d360c3105, 10000000240000000000000);
989         super._mint(0x08Baf1BC80C5d1504800A0dF6fA20c13C2D4a094, 100000000000000000000);
990         super._mint(0x1Efa1a5B05bC8B9EF2F3727ba60f628A50Be91cE, 250000000000000000000000);
991         super._mint(0xDEBC822417a40FE9c3117f988C32f2a35C8c92E2, 250000000000000000000000);
992         super._mint(0x23f4b046034bf976172Dbb2f570960bC4bd01Aa9, 250000000000000000000000);
993         super._mint(0xf171ab4A2cD8053A9485a932a5805Ca6bcdACA43, 250000000000000000000000);
994         super._mint(0xD75A2660bb6776dF2233d1aD6D3F572d6971De28, 100000000000000000000);
995         super._mint(0xD75A2660bb6776dF2233d1aD6D3F572d6971De28, 250000000000000000000000);
996         super._mint(0x6FAa69822fF5ceb05c779dD2f197Bb0358D50841, 250001000000000000000000);
997         super._mint(0x0f14a483Aad47E4d63ab7f51F60b7d1182c3f154, 10000000000000000000);
998         super._mint(0x0f14a483Aad47E4d63ab7f51F60b7d1182c3f154, 100000000000000000000);
999         super._mint(0x7d41E9E500a209AF8eE588c4eA5b150b877ad541, 100000000000000000000);
1000         super._mint(0x7C32B80cf3Bb342cb64e963820C5FEFb7A8eeC11, 250000000000000000000000);
1001         super._mint(0x30AEa47C6B7A9C2c3F3f9c59e49FBAf3A731Be02, 250000000000000000000000);
1002         super._mint(0x30AEa47C6B7A9C2c3F3f9c59e49FBAf3A731Be02, 250744089900000000000000);
1003         super._mint(0x19afd59C86406C27F9c2B59521a0989D3B21d9D9, 250000000000000000000000);
1004         super._mint(0x19afd59C86406C27F9c2B59521a0989D3B21d9D9, 250000000000000000000000);
1005         super._mint(0x30AEa47C6B7A9C2c3F3f9c59e49FBAf3A731Be02, 250000000000000000000000);
1006     }
1007 
1008       /**
1009      * @dev See {IERC20-totalSupply}.
1010      */
1011     function totalSupply() public view override returns (uint256) {
1012         return _totalSupply;
1013     }
1014 
1015     function balanceOf(address account) public view override returns (uint256) {
1016         if(claimed[account])
1017             return intBalanceOf(account);
1018         else
1019             return wrapped.balanceOf(account);
1020     }
1021 
1022     function pause() onlyOwner public {
1023         super._pause();
1024     }
1025 
1026     function unpause() onlyOwner public {
1027         super._unpause();
1028     }
1029 
1030     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20Pausable, ERC20) {
1031         super._beforeTokenTransfer(from, to, amount);
1032         if(intBalanceOf(from) == uint256(0) && !claimed[from]) {
1033             uint256 balance = wrapped.balanceOf(from);
1034             if(balance > 0) {
1035                 intMint(from, balance);
1036             }
1037             claimed[from] = true;
1038         }
1039         if(intBalanceOf(to) == uint256(0) && !claimed[to]) {
1040             uint256 balance = wrapped.balanceOf(to);
1041             if(balance > 0) {
1042                 intMint(to, balance);
1043             }
1044             claimed[to] = true;
1045         }
1046     }
1047 
1048     function _convertBalance(address from, address to) private {
1049         uint256 wrappedBalance = wrapped.balanceOf(from);
1050         claimed[from] = true;
1051         intMint(to, wrappedBalance);
1052         claimed[to] = true;
1053     }
1054 
1055 }