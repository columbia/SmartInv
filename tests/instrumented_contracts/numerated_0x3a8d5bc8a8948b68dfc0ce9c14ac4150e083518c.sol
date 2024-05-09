1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
32         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
33         // for accounts without code, i.e. `keccak256('')`
34         bytes32 codehash;
35         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { codehash := extcodehash(account) }
38         return (codehash != accountHash && codehash != 0x0);
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return _functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131             // Look for revert reason and bubble it up if present
132             if (returndata.length > 0) {
133                 // The easiest way to bubble the revert reason is using memory via assembly
134 
135                 // solhint-disable-next-line no-inline-assembly
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Context
148 
149 /*
150  * @dev Provides information about the current execution context, including the
151  * sender of the transaction and its data. While these are generally available
152  * via msg.sender and msg.data, they should not be accessed in such a direct
153  * manner, since when dealing with GSN meta-transactions the account sending and
154  * paying for execution may not be the actual sender (as far as an application
155  * is concerned).
156  *
157  * This contract is only required for intermediate, library-like contracts.
158  */
159 abstract contract Context {
160     function _msgSender() internal view virtual returns (address payable) {
161         return msg.sender;
162     }
163 
164     function _msgData() internal view virtual returns (bytes memory) {
165         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
166         return msg.data;
167     }
168 }
169 
170 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/IERC20
171 
172 /**
173  * @dev Interface of the ERC20 standard as defined in the EIP.
174  */
175 interface IERC20 {
176     /**
177      * @dev Returns the amount of tokens in existence.
178      */
179     function totalSupply() external view returns (uint256);
180 
181     /**
182      * @dev Returns the amount of tokens owned by `account`.
183      */
184     function balanceOf(address account) external view returns (uint256);
185 
186     /**
187      * @dev Moves `amount` tokens from the caller's account to `recipient`.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transfer(address recipient, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Returns the remaining number of tokens that `spender` will be
197      * allowed to spend on behalf of `owner` through {transferFrom}. This is
198      * zero by default.
199      *
200      * This value changes when {approve} or {transferFrom} are called.
201      */
202     function allowance(address owner, address spender) external view returns (uint256);
203 
204     /**
205      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * IMPORTANT: Beware that changing an allowance with this method brings the risk
210      * that someone may use both the old and the new allowance by unfortunate
211      * transaction ordering. One possible solution to mitigate this race
212      * condition is to first reduce the spender's allowance to 0 and set the
213      * desired value afterwards:
214      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215      *
216      * Emits an {Approval} event.
217      */
218     function approve(address spender, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Moves `amount` tokens from `sender` to `recipient` using the
222      * allowance mechanism. `amount` is then deducted from the caller's
223      * allowance.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * Emits a {Transfer} event.
228      */
229     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Emitted when `value` tokens are moved from one account (`from`) to
233      * another (`to`).
234      *
235      * Note that `value` may be zero.
236      */
237     event Transfer(address indexed from, address indexed to, uint256 value);
238 
239     /**
240      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
241      * a call to {approve}. `value` is the new allowance.
242      */
243     event Approval(address indexed owner, address indexed spender, uint256 value);
244 }
245 
246 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/SafeMath
247 
248 /**
249  * @dev Wrappers over Solidity's arithmetic operations with added overflow
250  * checks.
251  *
252  * Arithmetic operations in Solidity wrap on overflow. This can easily result
253  * in bugs, because programmers usually assume that an overflow raises an
254  * error, which is the standard behavior in high level programming languages.
255  * `SafeMath` restores this intuition by reverting the transaction when an
256  * operation overflows.
257  *
258  * Using this library instead of the unchecked operations eliminates an entire
259  * class of bugs, so it's recommended to use it always.
260  */
261 library SafeMath {
262     /**
263      * @dev Returns the addition of two unsigned integers, reverting on
264      * overflow.
265      *
266      * Counterpart to Solidity's `+` operator.
267      *
268      * Requirements:
269      *
270      * - Addition cannot overflow.
271      */
272     function add(uint256 a, uint256 b) internal pure returns (uint256) {
273         uint256 c = a + b;
274         require(c >= a, "SafeMath: addition overflow");
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the subtraction of two unsigned integers, reverting on
281      * overflow (when the result is negative).
282      *
283      * Counterpart to Solidity's `-` operator.
284      *
285      * Requirements:
286      *
287      * - Subtraction cannot overflow.
288      */
289     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
290         return sub(a, b, "SafeMath: subtraction overflow");
291     }
292 
293     /**
294      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
295      * overflow (when the result is negative).
296      *
297      * Counterpart to Solidity's `-` operator.
298      *
299      * Requirements:
300      *
301      * - Subtraction cannot overflow.
302      */
303     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
304         require(b <= a, errorMessage);
305         uint256 c = a - b;
306 
307         return c;
308     }
309 
310     /**
311      * @dev Returns the multiplication of two unsigned integers, reverting on
312      * overflow.
313      *
314      * Counterpart to Solidity's `*` operator.
315      *
316      * Requirements:
317      *
318      * - Multiplication cannot overflow.
319      */
320     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
321         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
322         // benefit is lost if 'b' is also tested.
323         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
324         if (a == 0) {
325             return 0;
326         }
327 
328         uint256 c = a * b;
329         require(c / a == b, "SafeMath: multiplication overflow");
330 
331         return c;
332     }
333 
334     /**
335      * @dev Returns the integer division of two unsigned integers. Reverts on
336      * division by zero. The result is rounded towards zero.
337      *
338      * Counterpart to Solidity's `/` operator. Note: this function uses a
339      * `revert` opcode (which leaves remaining gas untouched) while Solidity
340      * uses an invalid opcode to revert (consuming all remaining gas).
341      *
342      * Requirements:
343      *
344      * - The divisor cannot be zero.
345      */
346     function div(uint256 a, uint256 b) internal pure returns (uint256) {
347         return div(a, b, "SafeMath: division by zero");
348     }
349 
350     /**
351      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
352      * division by zero. The result is rounded towards zero.
353      *
354      * Counterpart to Solidity's `/` operator. Note: this function uses a
355      * `revert` opcode (which leaves remaining gas untouched) while Solidity
356      * uses an invalid opcode to revert (consuming all remaining gas).
357      *
358      * Requirements:
359      *
360      * - The divisor cannot be zero.
361      */
362     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
363         require(b > 0, errorMessage);
364         uint256 c = a / b;
365         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
366 
367         return c;
368     }
369 
370     /**
371      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
372      * Reverts when dividing by zero.
373      *
374      * Counterpart to Solidity's `%` operator. This function uses a `revert`
375      * opcode (which leaves remaining gas untouched) while Solidity uses an
376      * invalid opcode to revert (consuming all remaining gas).
377      *
378      * Requirements:
379      *
380      * - The divisor cannot be zero.
381      */
382     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
383         return mod(a, b, "SafeMath: modulo by zero");
384     }
385 
386     /**
387      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
388      * Reverts with custom message when dividing by zero.
389      *
390      * Counterpart to Solidity's `%` operator. This function uses a `revert`
391      * opcode (which leaves remaining gas untouched) while Solidity uses an
392      * invalid opcode to revert (consuming all remaining gas).
393      *
394      * Requirements:
395      *
396      * - The divisor cannot be zero.
397      */
398     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
399         require(b != 0, errorMessage);
400         return a % b;
401     }
402 }
403 
404 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/ERC20
405 
406 /**
407  * @dev Implementation of the {IERC20} interface.
408  *
409  * This implementation is agnostic to the way tokens are created. This means
410  * that a supply mechanism has to be added in a derived contract using {_mint}.
411  * For a generic mechanism see {ERC20PresetMinterPauser}.
412  *
413  * TIP: For a detailed writeup see our guide
414  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
415  * to implement supply mechanisms].
416  *
417  * We have followed general OpenZeppelin guidelines: functions revert instead
418  * of returning `false` on failure. This behavior is nonetheless conventional
419  * and does not conflict with the expectations of ERC20 applications.
420  *
421  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
422  * This allows applications to reconstruct the allowance for all accounts just
423  * by listening to said events. Other implementations of the EIP may not emit
424  * these events, as it isn't required by the specification.
425  *
426  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
427  * functions have been added to mitigate the well-known issues around setting
428  * allowances. See {IERC20-approve}.
429  */
430 contract ERC20 is Context, IERC20 {
431     using SafeMath for uint256;
432     using Address for address;
433 
434     mapping (address => uint256) private _balances;
435 
436     mapping (address => mapping (address => uint256)) private _allowances;
437 
438     uint256 private _totalSupply;
439 
440     string private _name;
441     string private _symbol;
442     uint8 private _decimals;
443 
444     /**
445      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
446      * a default value of 18.
447      *
448      * To select a different value for {decimals}, use {_setupDecimals}.
449      *
450      * All three of these values are immutable: they can only be set once during
451      * construction.
452      */
453     constructor (string memory name, string memory symbol) public {
454         _name = name;
455         _symbol = symbol;
456         _decimals = 18;
457     }
458 
459     /**
460      * @dev Returns the name of the token.
461      */
462     function name() public view returns (string memory) {
463         return _name;
464     }
465 
466     /**
467      * @dev Returns the symbol of the token, usually a shorter version of the
468      * name.
469      */
470     function symbol() public view returns (string memory) {
471         return _symbol;
472     }
473 
474     /**
475      * @dev Returns the number of decimals used to get its user representation.
476      * For example, if `decimals` equals `2`, a balance of `505` tokens should
477      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
478      *
479      * Tokens usually opt for a value of 18, imitating the relationship between
480      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
481      * called.
482      *
483      * NOTE: This information is only used for _display_ purposes: it in
484      * no way affects any of the arithmetic of the contract, including
485      * {IERC20-balanceOf} and {IERC20-transfer}.
486      */
487     function decimals() public view returns (uint8) {
488         return _decimals;
489     }
490 
491     /**
492      * @dev See {IERC20-totalSupply}.
493      */
494     function totalSupply() public view override returns (uint256) {
495         return _totalSupply;
496     }
497 
498     /**
499      * @dev See {IERC20-balanceOf}.
500      */
501     function balanceOf(address account) public view override returns (uint256) {
502         return _balances[account];
503     }
504 
505     /**
506      * @dev See {IERC20-transfer}.
507      *
508      * Requirements:
509      *
510      * - `recipient` cannot be the zero address.
511      * - the caller must have a balance of at least `amount`.
512      */
513     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
514         _transfer(_msgSender(), recipient, amount);
515         return true;
516     }
517 
518     /**
519      * @dev See {IERC20-allowance}.
520      */
521     function allowance(address owner, address spender) public view virtual override returns (uint256) {
522         return _allowances[owner][spender];
523     }
524 
525     /**
526      * @dev See {IERC20-approve}.
527      *
528      * Requirements:
529      *
530      * - `spender` cannot be the zero address.
531      */
532     function approve(address spender, uint256 amount) public virtual override returns (bool) {
533         _approve(_msgSender(), spender, amount);
534         return true;
535     }
536 
537     /**
538      * @dev See {IERC20-transferFrom}.
539      *
540      * Emits an {Approval} event indicating the updated allowance. This is not
541      * required by the EIP. See the note at the beginning of {ERC20};
542      *
543      * Requirements:
544      * - `sender` and `recipient` cannot be the zero address.
545      * - `sender` must have a balance of at least `amount`.
546      * - the caller must have allowance for ``sender``'s tokens of at least
547      * `amount`.
548      */
549     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
550         _transfer(sender, recipient, amount);
551         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
552         return true;
553     }
554 
555     /**
556      * @dev Atomically increases the allowance granted to `spender` by the caller.
557      *
558      * This is an alternative to {approve} that can be used as a mitigation for
559      * problems described in {IERC20-approve}.
560      *
561      * Emits an {Approval} event indicating the updated allowance.
562      *
563      * Requirements:
564      *
565      * - `spender` cannot be the zero address.
566      */
567     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
568         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
569         return true;
570     }
571 
572     /**
573      * @dev Atomically decreases the allowance granted to `spender` by the caller.
574      *
575      * This is an alternative to {approve} that can be used as a mitigation for
576      * problems described in {IERC20-approve}.
577      *
578      * Emits an {Approval} event indicating the updated allowance.
579      *
580      * Requirements:
581      *
582      * - `spender` cannot be the zero address.
583      * - `spender` must have allowance for the caller of at least
584      * `subtractedValue`.
585      */
586     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
587         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
588         return true;
589     }
590 
591     /**
592      * @dev Moves tokens `amount` from `sender` to `recipient`.
593      *
594      * This is internal function is equivalent to {transfer}, and can be used to
595      * e.g. implement automatic token fees, slashing mechanisms, etc.
596      *
597      * Emits a {Transfer} event.
598      *
599      * Requirements:
600      *
601      * - `sender` cannot be the zero address.
602      * - `recipient` cannot be the zero address.
603      * - `sender` must have a balance of at least `amount`.
604      */
605     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
606         require(sender != address(0), "ERC20: transfer from the zero address");
607         require(recipient != address(0), "ERC20: transfer to the zero address");
608 
609         _beforeTokenTransfer(sender, recipient, amount);
610 
611         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
612         _balances[recipient] = _balances[recipient].add(amount);
613         emit Transfer(sender, recipient, amount);
614     }
615 
616     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
617      * the total supply.
618      *
619      * Emits a {Transfer} event with `from` set to the zero address.
620      *
621      * Requirements
622      *
623      * - `to` cannot be the zero address.
624      */
625     function _mint(address account, uint256 amount) internal virtual {
626         require(account != address(0), "ERC20: mint to the zero address");
627 
628         _beforeTokenTransfer(address(0), account, amount);
629 
630         _totalSupply = _totalSupply.add(amount);
631         _balances[account] = _balances[account].add(amount);
632         emit Transfer(address(0), account, amount);
633     }
634 
635     /**
636      * @dev Destroys `amount` tokens from `account`, reducing the
637      * total supply.
638      *
639      * Emits a {Transfer} event with `to` set to the zero address.
640      *
641      * Requirements
642      *
643      * - `account` cannot be the zero address.
644      * - `account` must have at least `amount` tokens.
645      */
646     function _burn(address account, uint256 amount) internal virtual {
647         require(account != address(0), "ERC20: burn from the zero address");
648 
649         _beforeTokenTransfer(account, address(0), amount);
650 
651         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
652         _totalSupply = _totalSupply.sub(amount);
653         emit Transfer(account, address(0), amount);
654     }
655 
656     /**
657      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
658      *
659      * This is internal function is equivalent to `approve`, and can be used to
660      * e.g. set automatic allowances for certain subsystems, etc.
661      *
662      * Emits an {Approval} event.
663      *
664      * Requirements:
665      *
666      * - `owner` cannot be the zero address.
667      * - `spender` cannot be the zero address.
668      */
669     function _approve(address owner, address spender, uint256 amount) internal virtual {
670         require(owner != address(0), "ERC20: approve from the zero address");
671         require(spender != address(0), "ERC20: approve to the zero address");
672 
673         _allowances[owner][spender] = amount;
674         emit Approval(owner, spender, amount);
675     }
676 
677     /**
678      * @dev Sets {decimals} to a value other than the default one of 18.
679      *
680      * WARNING: This function should only be called from the constructor. Most
681      * applications that interact with token contracts will not expect
682      * {decimals} to ever change, and may work incorrectly if it does.
683      */
684     function _setupDecimals(uint8 decimals_) internal {
685         _decimals = decimals_;
686     }
687 
688     /**
689      * @dev Hook that is called before any transfer of tokens. This includes
690      * minting and burning.
691      *
692      * Calling conditions:
693      *
694      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
695      * will be to transferred to `to`.
696      * - when `from` is zero, `amount` tokens will be minted for `to`.
697      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
698      * - `from` and `to` are never both zero.
699      *
700      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
701      */
702     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
703 }
704 
705 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Ownable
706 
707 /**
708  * @dev Contract module which provides a basic access control mechanism, where
709  * there is an account (an owner) that can be granted exclusive access to
710  * specific functions.
711  *
712  * By default, the owner account will be the one that deploys the contract. This
713  * can later be changed with {transferOwnership}.
714  *
715  * This module is used through inheritance. It will make available the modifier
716  * `onlyOwner`, which can be applied to your functions to restrict their use to
717  * the owner.
718  */
719 contract Ownable is Context {
720     address private _owner;
721 
722     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
723 
724     /**
725      * @dev Initializes the contract setting the deployer as the initial owner.
726      */
727     constructor () internal {
728         address msgSender = _msgSender();
729         _owner = msgSender;
730         emit OwnershipTransferred(address(0), msgSender);
731     }
732 
733     /**
734      * @dev Returns the address of the current owner.
735      */
736     function owner() public view returns (address) {
737         return _owner;
738     }
739 
740     /**
741      * @dev Throws if called by any account other than the owner.
742      */
743     modifier onlyOwner() {
744         require(_owner == _msgSender(), "Ownable: caller is not the owner");
745         _;
746     }
747 
748     /**
749      * @dev Leaves the contract without owner. It will not be possible to call
750      * `onlyOwner` functions anymore. Can only be called by the current owner.
751      *
752      * NOTE: Renouncing ownership will leave the contract without an owner,
753      * thereby removing any functionality that is only available to the owner.
754      */
755     function renounceOwnership() public virtual onlyOwner {
756         emit OwnershipTransferred(_owner, address(0));
757         _owner = address(0);
758     }
759 
760     /**
761      * @dev Transfers ownership of the contract to a new account (`newOwner`).
762      * Can only be called by the current owner.
763      */
764     function transferOwnership(address newOwner) public virtual onlyOwner {
765         require(newOwner != address(0), "Ownable: new owner is the zero address");
766         emit OwnershipTransferred(_owner, newOwner);
767         _owner = newOwner;
768     }
769 }
770 
771 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/ERC20Burnable
772 
773 /**
774  * @dev Extension of {ERC20} that allows token holders to destroy both their own
775  * tokens and those that they have an allowance for, in a way that can be
776  * recognized off-chain (via event analysis).
777  */
778 abstract contract ERC20Burnable is Context, ERC20 {
779     /**
780      * @dev Destroys `amount` tokens from the caller.
781      *
782      * See {ERC20-_burn}.
783      */
784     function burn(uint256 amount) public virtual {
785         _burn(_msgSender(), amount);
786     }
787 
788     /**
789      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
790      * allowance.
791      *
792      * See {ERC20-_burn} and {ERC20-allowance}.
793      *
794      * Requirements:
795      *
796      * - the caller must have allowance for ``accounts``'s tokens of at least
797      * `amount`.
798      */
799     function burnFrom(address account, uint256 amount) public virtual {
800         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
801 
802         _approve(account, _msgSender(), decreasedAllowance);
803         _burn(account, amount);
804     }
805 }
806 
807 // File: ParaToken.sol
808 
809 contract ParaToken is ERC20, Ownable, ERC20Burnable {
810     constructor() public ERC20("Paralink Network", "PARA") {
811     }
812 
813     function mint(address to, uint256 amount) public virtual onlyOwner {
814         _mint(to, amount);
815         _moveDelegates(address(0), _delegates[to], amount);
816     }
817 
818     // Copied and modified from YAM code:
819     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
820     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
821     // Which is copied and modified from COMPOUND:
822     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
823 
824     /// @notice A record of each accounts delegate
825     mapping (address => address) internal _delegates;
826 
827     /// @notice A checkpoint for marking number of votes from a given block
828     struct Checkpoint {
829         uint32 fromBlock;
830         uint256 votes;
831     }
832 
833     /// @notice A record of votes checkpoints for each account, by index
834     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
835 
836     /// @notice The number of checkpoints for each account
837     mapping (address => uint32) public numCheckpoints;
838 
839     /// @notice The EIP-712 typehash for the contract's domain
840     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
841 
842     /// @notice The EIP-712 typehash for the delegation struct used by the contract
843     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
844 
845     /// @notice A record of states for signing / validating signatures
846     mapping (address => uint) public nonces;
847 
848     /// @notice An event thats emitted when an account changes its delegate
849     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
850 
851     /// @notice An event thats emitted when a delegate account's vote balance changes
852     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
853 
854     /**
855      * @notice Delegate votes from `msg.sender` to `delegatee`
856      * @param delegator The address to get delegatee for
857      */
858     function delegates(address delegator)
859         external
860         view
861         returns (address)
862     {
863         return _delegates[delegator];
864     }
865 
866    /**
867     * @notice Delegate votes from `msg.sender` to `delegatee`
868     * @param delegatee The address to delegate votes to
869     */
870     function delegate(address delegatee) external {
871         return _delegate(msg.sender, delegatee);
872     }
873 
874     /**
875      * @notice Delegates votes from signatory to `delegatee`
876      * @param delegatee The address to delegate votes to
877      * @param nonce The contract state required to match the signature
878      * @param expiry The time at which to expire the signature
879      * @param v The recovery byte of the signature
880      * @param r Half of the ECDSA signature pair
881      * @param s Half of the ECDSA signature pair
882      */
883     function delegateBySig(
884         address delegatee,
885         uint nonce,
886         uint expiry,
887         uint8 v,
888         bytes32 r,
889         bytes32 s
890     )
891         external
892     {
893         bytes32 domainSeparator = keccak256(
894             abi.encode(
895                 DOMAIN_TYPEHASH,
896                 keccak256(bytes(name())),
897                 getChainId(),
898                 address(this)
899             )
900         );
901 
902         bytes32 structHash = keccak256(
903             abi.encode(
904                 DELEGATION_TYPEHASH,
905                 delegatee,
906                 nonce,
907                 expiry
908             )
909         );
910 
911         bytes32 digest = keccak256(
912             abi.encodePacked(
913                 "\x19\x01",
914                 domainSeparator,
915                 structHash
916             )
917         );
918 
919         address signatory = ecrecover(digest, v, r, s);
920         require(signatory != address(0), "PARA::delegateBySig: invalid signature");
921         require(nonce == nonces[signatory]++, "PARA::delegateBySig: invalid nonce");
922         require(now <= expiry, "PARA::delegateBySig: signature expired");
923         return _delegate(signatory, delegatee);
924     }
925 
926     /**
927      * @notice Gets the current votes balance for `account`
928      * @param account The address to get votes balance
929      * @return The number of current votes for `account`
930      */
931     function getCurrentVotes(address account)
932         external
933         view
934         returns (uint256)
935     {
936         uint32 nCheckpoints = numCheckpoints[account];
937         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
938     }
939 
940     /**
941      * @notice Determine the prior number of votes for an account as of a block number
942      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
943      * @param account The address of the account to check
944      * @param blockNumber The block number to get the vote balance at
945      * @return The number of votes the account had as of the given block
946      */
947     function getPriorVotes(address account, uint blockNumber)
948         external
949         view
950         returns (uint256)
951     {
952         require(blockNumber < block.number, "PARA::getPriorVotes: not yet determined");
953 
954         uint32 nCheckpoints = numCheckpoints[account];
955         if (nCheckpoints == 0) {
956             return 0;
957         }
958 
959         // First check most recent balance
960         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
961             return checkpoints[account][nCheckpoints - 1].votes;
962         }
963 
964         // Next check implicit zero balance
965         if (checkpoints[account][0].fromBlock > blockNumber) {
966             return 0;
967         }
968 
969         uint32 lower = 0;
970         uint32 upper = nCheckpoints - 1;
971         while (upper > lower) {
972             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
973             Checkpoint memory cp = checkpoints[account][center];
974             if (cp.fromBlock == blockNumber) {
975                 return cp.votes;
976             } else if (cp.fromBlock < blockNumber) {
977                 lower = center;
978             } else {
979                 upper = center - 1;
980             }
981         }
982         return checkpoints[account][lower].votes;
983     }
984 
985     function _delegate(address delegator, address delegatee)
986         internal
987     {
988         address currentDelegate = _delegates[delegator];
989         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying PARA (not scaled);
990         _delegates[delegator] = delegatee;
991 
992         emit DelegateChanged(delegator, currentDelegate, delegatee);
993 
994         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
995     }
996 
997     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
998         if (srcRep != dstRep && amount > 0) {
999             if (srcRep != address(0)) {
1000                 // decrease old representative
1001                 uint32 srcRepNum = numCheckpoints[srcRep];
1002                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1003                 uint256 srcRepNew = srcRepOld.sub(amount);
1004                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1005             }
1006 
1007             if (dstRep != address(0)) {
1008                 // increase new representative
1009                 uint32 dstRepNum = numCheckpoints[dstRep];
1010                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1011                 uint256 dstRepNew = dstRepOld.add(amount);
1012                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1013             }
1014         }
1015     }
1016 
1017     function _writeCheckpoint(
1018         address delegatee,
1019         uint32 nCheckpoints,
1020         uint256 oldVotes,
1021         uint256 newVotes
1022     )
1023         internal
1024     {
1025         uint32 blockNumber = safe32(block.number, "PARA::_writeCheckpoint: block number exceeds 32 bits");
1026 
1027         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1028             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1029         } else {
1030             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1031             numCheckpoints[delegatee] = nCheckpoints + 1;
1032         }
1033 
1034         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1035     }
1036 
1037     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1038         require(n < 2**32, errorMessage);
1039         return uint32(n);
1040     }
1041 
1042     function getChainId() internal pure returns (uint) {
1043         uint256 chainId;
1044         assembly { chainId := chainid() }
1045         return chainId;
1046     }
1047 }
