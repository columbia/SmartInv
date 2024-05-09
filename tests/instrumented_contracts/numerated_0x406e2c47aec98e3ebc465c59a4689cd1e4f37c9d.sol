1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-07
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.6.0;
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
28 pragma solidity ^0.6.0;
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102  
103 pragma solidity ^0.6.0;
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
260 pragma solidity ^0.6.2;
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
284         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
285         // for accounts without code, i.e. `keccak256('')`
286         bytes32 codehash;
287         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
288         // solhint-disable-next-line no-inline-assembly
289         assembly { codehash := extcodehash(account) }
290         return (codehash != accountHash && codehash != 0x0);
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
313         (bool success, ) = recipient.call{ value: amount }("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain`call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336         return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
346         return _functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         return _functionCallWithValue(target, data, value, errorMessage);
373     }
374 
375     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
376         require(isContract(target), "Address: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 // solhint-disable-next-line no-inline-assembly
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398  
399 pragma solidity ^0.6.0;
400 /**
401  * @dev Implementation of the {IERC20} interface.
402  *
403  * This implementation is agnostic to the way tokens are created. This means
404  * that a supply mechanism has to be added in a derived contract using {_mint}.
405  * For a generic mechanism see {ERC20PresetMinterPauser}.
406  *
407  * TIP: For a detailed writeup see our guide
408  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
409  * to implement supply mechanisms].
410  *
411  * We have followed general OpenZeppelin guidelines: functions revert instead
412  * of returning `false` on failure. This behavior is nonetheless conventional
413  * and does not conflict with the expectations of ERC20 applications.
414  *
415  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
416  * This allows applications to reconstruct the allowance for all accounts just
417  * by listening to said events. Other implementations of the EIP may not emit
418  * these events, as it isn't required by the specification.
419  *
420  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
421  * functions have been added to mitigate the well-known issues around setting
422  * allowances. See {IERC20-approve}.
423  */
424 contract ERC20 is Context, IERC20 {
425     using SafeMath for uint256;
426     using Address for address;
427 
428     mapping (address => uint256) private _balances;
429 
430     mapping (address => mapping (address => uint256)) private _allowances;
431 
432     uint256 private _totalSupply;
433 
434     string private _name;
435     string private _symbol;
436     uint8 private _decimals;
437 
438     /**
439      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
440      * a default value of 18.
441      *
442      * To select a different value for {decimals}, use {_setupDecimals}.
443      *
444      * All three of these values are immutable: they can only be set once during
445      * construction.
446      */
447     constructor (string memory name, string memory symbol) public {
448         _name = name;
449         _symbol = symbol;
450         _decimals = 18;
451         _mint(msg.sender, 3e26);
452     }
453 
454     /**
455      * @dev Returns the name of the token.
456      */
457     function name() public view returns (string memory) {
458         return _name;
459     }
460 
461     /**
462      * @dev Returns the symbol of the token, usually a shorter version of the
463      * name.
464      */
465     function symbol() public view returns (string memory) {
466         return _symbol;
467     }
468 
469     /**
470      * @dev Returns the number of decimals used to get its user representation.
471      * For example, if `decimals` equals `2`, a balance of `505` tokens should
472      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
473      *
474      * Tokens usually opt for a value of 18, imitating the relationship between
475      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
476      * called.
477      *
478      * NOTE: This information is only used for _display_ purposes: it in
479      * no way affects any of the arithmetic of the contract, including
480      * {IERC20-balanceOf} and {IERC20-transfer}.
481      */
482     function decimals() public view returns (uint8) {
483         return _decimals;
484     }
485 
486     /**
487      * @dev See {IERC20-totalSupply}.
488      */
489     function totalSupply() public view override returns (uint256) {
490         return _totalSupply;
491     }
492 
493     /**
494      * @dev See {IERC20-balanceOf}.
495      */
496     function balanceOf(address account) public view override returns (uint256) {
497         return _balances[account];
498     }
499 
500     /**
501      * @dev See {IERC20-transfer}.
502      *
503      * Requirements:
504      *
505      * - `recipient` cannot be the zero address.
506      * - the caller must have a balance of at least `amount`.
507      */
508     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
509         _transfer(_msgSender(), recipient, amount);
510         return true;
511     }
512 
513     /**
514      * @dev See {IERC20-allowance}.
515      */
516     function allowance(address owner, address spender) public view virtual override returns (uint256) {
517         return _allowances[owner][spender];
518     }
519 
520     /**
521      * @dev See {IERC20-approve}.
522      *
523      * Requirements:
524      *
525      * - `spender` cannot be the zero address.
526      */
527     function approve(address spender, uint256 amount) public virtual override returns (bool) {
528         _approve(_msgSender(), spender, amount);
529         return true;
530     }
531 
532     /**
533      * @dev See {IERC20-transferFrom}.
534      *
535      * Emits an {Approval} event indicating the updated allowance. This is not
536      * required by the EIP. See the note at the beginning of {ERC20};
537      *
538      * Requirements:
539      * - `sender` and `recipient` cannot be the zero address.
540      * - `sender` must have a balance of at least `amount`.
541      * - the caller must have allowance for ``sender``'s tokens of at least
542      * `amount`.
543      */
544     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
545         _transfer(sender, recipient, amount);
546         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
547         return true;
548     }
549 
550     /**
551      * @dev Atomically increases the allowance granted to `spender` by the caller.
552      *
553      * This is an alternative to {approve} that can be used as a mitigation for
554      * problems described in {IERC20-approve}.
555      *
556      * Emits an {Approval} event indicating the updated allowance.
557      *
558      * Requirements:
559      *
560      * - `spender` cannot be the zero address.
561      */
562     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
563         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
564         return true;
565     }
566 
567     /**
568      * @dev Atomically decreases the allowance granted to `spender` by the caller.
569      *
570      * This is an alternative to {approve} that can be used as a mitigation for
571      * problems described in {IERC20-approve}.
572      *
573      * Emits an {Approval} event indicating the updated allowance.
574      *
575      * Requirements:
576      *
577      * - `spender` cannot be the zero address.
578      * - `spender` must have allowance for the caller of at least
579      * `subtractedValue`.
580      */
581     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
582         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
583         return true;
584     }
585 
586     /**
587      * @dev Moves tokens `amount` from `sender` to `recipient`.
588      *
589      * This is internal function is equivalent to {transfer}, and can be used to
590      * e.g. implement automatic token fees, slashing mechanisms, etc.
591      *
592      * Emits a {Transfer} event.
593      *
594      * Requirements:
595      *
596      * - `sender` cannot be the zero address.
597      * - `recipient` cannot be the zero address.
598      * - `sender` must have a balance of at least `amount`.
599      */
600     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
601         require(sender != address(0), "ERC20: transfer from the zero address");
602         require(recipient != address(0), "ERC20: transfer to the zero address");
603 
604         _beforeTokenTransfer(sender, recipient, amount);
605 
606         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
607         _balances[recipient] = _balances[recipient].add(amount);
608         emit Transfer(sender, recipient, amount);
609     }
610 
611     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
612      * the total supply.
613      *
614      * Emits a {Transfer} event with `from` set to the zero address.
615      *
616      * Requirements
617      *
618      * - `to` cannot be the zero address.
619      */
620     function _mint(address account, uint256 amount) internal virtual {
621         require(account != address(0), "ERC20: mint to the zero address");
622 
623         _beforeTokenTransfer(address(0), account, amount);
624 
625         _totalSupply = _totalSupply.add(amount);
626         _balances[account] = _balances[account].add(amount);
627         emit Transfer(address(0), account, amount);
628     }
629 
630     /**
631      * @dev Destroys `amount` tokens from `account`, reducing the
632      * total supply.
633      *
634      * Emits a {Transfer} event with `to` set to the zero address.
635      *
636      * Requirements
637      *
638      * - `account` cannot be the zero address.
639      * - `account` must have at least `amount` tokens.
640      */
641     function _burn(address account, uint256 amount) internal virtual {
642         require(account != address(0), "ERC20: burn from the zero address");
643 
644         _beforeTokenTransfer(account, address(0), amount);
645 
646         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
647         _totalSupply = _totalSupply.sub(amount);
648         emit Transfer(account, address(0), amount);
649     }
650 
651     /**
652      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
653      *
654      * This is internal function is equivalent to `approve`, and can be used to
655      * e.g. set automatic allowances for certain subsystems, etc.
656      *
657      * Emits an {Approval} event.
658      *
659      * Requirements:
660      *
661      * - `owner` cannot be the zero address.
662      * - `spender` cannot be the zero address.
663      */
664     function _approve(address owner, address spender, uint256 amount) internal virtual {
665         require(owner != address(0), "ERC20: approve from the zero address");
666         require(spender != address(0), "ERC20: approve to the zero address");
667 
668         _allowances[owner][spender] = amount;
669         emit Approval(owner, spender, amount);
670     }
671 
672     /**
673      * @dev Sets {decimals} to a value other than the default one of 18.
674      *
675      * WARNING: This function should only be called from the constructor. Most
676      * applications that interact with token contracts will not expect
677      * {decimals} to ever change, and may work incorrectly if it does.
678      */
679     function _setupDecimals(uint8 decimals_) internal {
680         _decimals = decimals_;
681     }
682 
683     /**
684      * @dev Hook that is called before any transfer of tokens. This includes
685      * minting and burning.
686      *
687      * Calling conditions:
688      *
689      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
690      * will be to transferred to `to`.
691      * - when `from` is zero, `amount` tokens will be minted for `to`.
692      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
693      * - `from` and `to` are never both zero.
694      *
695      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
696      */
697     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
698 }
699  
700 pragma solidity ^0.6.0;
701 /**
702  * @dev Contract module which provides a basic access control mechanism, where
703  * there is an account (an owner) that can be granted exclusive access to
704  * specific functions.
705  *
706  * By default, the owner account will be the one that deploys the contract. This
707  * can later be changed with {transferOwnership}.
708  *
709  * This module is used through inheritance. It will make available the modifier
710  * `onlyOwner`, which can be applied to your functions to restrict their use to
711  * the owner.
712  */
713 contract Ownable is Context {
714     address private _owner;
715 
716     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
717 
718     /**
719      * @dev Initializes the contract setting the deployer as the initial owner.
720      */
721     constructor () internal {
722         address msgSender = _msgSender();
723         _owner = msgSender;
724         emit OwnershipTransferred(address(0), msgSender);
725     }
726 
727     /**
728      * @dev Returns the address of the current owner.
729      */
730     function owner() public view returns (address) {
731         return _owner;
732     }
733 
734     /**
735      * @dev Throws if called by any account other than the owner.
736      */
737     modifier onlyOwner() {
738         require(_owner == _msgSender(), "Ownable: caller is not the owner");
739         _;
740     }
741 
742     /**
743      * @dev Leaves the contract without owner. It will not be possible to call
744      * `onlyOwner` functions anymore. Can only be called by the current owner.
745      *
746      * NOTE: Renouncing ownership will leave the contract without an owner,
747      * thereby removing any functionality that is only available to the owner.
748      */
749     function renounceOwnership() public virtual onlyOwner {
750         emit OwnershipTransferred(_owner, address(0));
751         _owner = address(0);
752     }
753 
754     /**
755      * @dev Transfers ownership of the contract to a new account (`newOwner`).
756      * Can only be called by the current owner.
757      */
758     function transferOwnership(address newOwner) public virtual onlyOwner {
759         require(newOwner != address(0), "Ownable: new owner is the zero address");
760         emit OwnershipTransferred(_owner, newOwner);
761         _owner = newOwner;
762     }
763 }
764   
765 pragma solidity 0.6.12; 
766 
767 contract MWCTOken is ERC20("M-wheel", "MWC"), Ownable {
768 
769     
770     /// @notice Creates `_amount` token to `_to`. Must only be called by the Governance Contracts
771     function burn(uint256 _amount) public virtual returns (bool) {
772         _burn(msg.sender, _amount);
773         return true;
774     }
775 
776    
777 }