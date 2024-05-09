1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-16
3 */
4 
5 // SPDX-License-Identifier: NONE
6 
7 pragma solidity 0.6.12;
8 
9 
10 
11 // Part: IApes
12 
13 interface IApes {
14 	function ownerOf(uint256 _user) external view returns(address);
15 }
16 
17 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Address
18 
19 /**
20  * @dev Collection of functions related to the address type
21  */
22 library Address {
23     /**
24      * @dev Returns true if `account` is a contract.
25      *
26      * [IMPORTANT]
27      * ====
28      * It is unsafe to assume that an address for which this function returns
29      * false is an externally-owned account (EOA) and not a contract.
30      *
31      * Among others, `isContract` will return false for the following
32      * types of addresses:
33      *
34      *  - an externally-owned account
35      *  - a contract in construction
36      *  - an address where a contract will be created
37      *  - an address where a contract lived, but was destroyed
38      * ====
39      */
40     function isContract(address account) internal view returns (bool) {
41         // This method relies in extcodesize, which returns 0 for contracts in
42         // construction, since the code is only stored at the end of the
43         // constructor execution.
44 
45         uint256 size;
46         // solhint-disable-next-line no-inline-assembly
47         assembly { size := extcodesize(account) }
48         return size > 0;
49     }
50 
51     /**
52      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
53      * `recipient`, forwarding all available gas and reverting on errors.
54      *
55      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
56      * of certain opcodes, possibly making contracts go over the 2300 gas limit
57      * imposed by `transfer`, making them unable to receive funds via
58      * `transfer`. {sendValue} removes this limitation.
59      *
60      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
61      *
62      * IMPORTANT: because control is transferred to `recipient`, care must be
63      * taken to not create reentrancy vulnerabilities. Consider using
64      * {ReentrancyGuard} or the
65      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
66      */
67     function sendValue(address payable recipient, uint256 amount) internal {
68         require(address(this).balance >= amount, "Address: insufficient balance");
69 
70         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
71         (bool success, ) = recipient.call{ value: amount }("");
72         require(success, "Address: unable to send value, recipient may have reverted");
73     }
74 
75     /**
76      * @dev Performs a Solidity function call using a low level `call`. A
77      * plain`call` is an unsafe replacement for a function call: use this
78      * function instead.
79      *
80      * If `target` reverts with a revert reason, it is bubbled up by this
81      * function (like regular Solidity function calls).
82      *
83      * Returns the raw returned data. To convert to the expected return value,
84      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
85      *
86      * Requirements:
87      *
88      * - `target` must be a contract.
89      * - calling `target` with `data` must not revert.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
94       return functionCall(target, data, "Address: low-level call failed");
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
99      * `errorMessage` as a fallback revert reason when `target` reverts.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
104         return _functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but also transferring `value` wei to `target`.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least `value`.
114      * - the called Solidity function must be `payable`.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
124      * with `errorMessage` as a fallback revert reason when `target` reverts.
125      *
126      * _Available since v3.1._
127      */
128     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
129         require(address(this).balance >= value, "Address: insufficient balance for call");
130         return _functionCallWithValue(target, data, value, errorMessage);
131     }
132 
133     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
134         require(isContract(target), "Address: call to non-contract");
135 
136         // solhint-disable-next-line avoid-low-level-calls
137         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
138         if (success) {
139             return returndata;
140         } else {
141             // Look for revert reason and bubble it up if present
142             if (returndata.length > 0) {
143                 // The easiest way to bubble the revert reason is using memory via assembly
144 
145                 // solhint-disable-next-line no-inline-assembly
146                 assembly {
147                     let returndata_size := mload(returndata)
148                     revert(add(32, returndata), returndata_size)
149                 }
150             } else {
151                 revert(errorMessage);
152             }
153         }
154     }
155 }
156 
157 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Context
158 
159 /*
160  * @dev Provides information about the current execution context, including the
161  * sender of the transaction and its data. While these are generally available
162  * via msg.sender and msg.data, they should not be accessed in such a direct
163  * manner, since when dealing with GSN meta-transactions the account sending and
164  * paying for execution may not be the actual sender (as far as an application
165  * is concerned).
166  *
167  * This contract is only required for intermediate, library-like contracts.
168  */
169 abstract contract Context {
170     function _msgSender() internal view virtual returns (address payable) {
171         return msg.sender;
172     }
173 
174     function _msgData() internal view virtual returns (bytes memory) {
175         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
176         return msg.data;
177     }
178 }
179 
180 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC20
181 
182 /**
183  * @dev Interface of the ERC20 standard as defined in the EIP.
184  */
185 interface IERC20 {
186     /**
187      * @dev Returns the amount of tokens in existence.
188      */
189     function totalSupply() external view returns (uint256);
190 
191     /**
192      * @dev Returns the amount of tokens owned by `account`.
193      */
194     function balanceOf(address account) external view returns (uint256);
195 
196     /**
197      * @dev Moves `amount` tokens from the caller's account to `recipient`.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transfer(address recipient, uint256 amount) external returns (bool);
204 
205     /**
206      * @dev Returns the remaining number of tokens that `spender` will be
207      * allowed to spend on behalf of `owner` through {transferFrom}. This is
208      * zero by default.
209      *
210      * This value changes when {approve} or {transferFrom} are called.
211      */
212     function allowance(address owner, address spender) external view returns (uint256);
213 
214     /**
215      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
216      *
217      * Returns a boolean value indicating whether the operation succeeded.
218      *
219      * IMPORTANT: Beware that changing an allowance with this method brings the risk
220      * that someone may use both the old and the new allowance by unfortunate
221      * transaction ordering. One possible solution to mitigate this race
222      * condition is to first reduce the spender's allowance to 0 and set the
223      * desired value afterwards:
224      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225      *
226      * Emits an {Approval} event.
227      */
228     function approve(address spender, uint256 amount) external returns (bool);
229 
230     /**
231      * @dev Moves `amount` tokens from `sender` to `recipient` using the
232      * allowance mechanism. `amount` is then deducted from the caller's
233      * allowance.
234      *
235      * Returns a boolean value indicating whether the operation succeeded.
236      *
237      * Emits a {Transfer} event.
238      */
239     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Emitted when `value` tokens are moved from one account (`from`) to
243      * another (`to`).
244      *
245      * Note that `value` may be zero.
246      */
247     event Transfer(address indexed from, address indexed to, uint256 value);
248 
249     /**
250      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
251      * a call to {approve}. `value` is the new allowance.
252      */
253     event Approval(address indexed owner, address indexed spender, uint256 value);
254 }
255 
256 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeMath
257 
258 /**
259  * @dev Wrappers over Solidity's arithmetic operations with added overflow
260  * checks.
261  *
262  * Arithmetic operations in Solidity wrap on overflow. This can easily result
263  * in bugs, because programmers usually assume that an overflow raises an
264  * error, which is the standard behavior in high level programming languages.
265  * `SafeMath` restores this intuition by reverting the transaction when an
266  * operation overflows.
267  *
268  * Using this library instead of the unchecked operations eliminates an entire
269  * class of bugs, so it's recommended to use it always.
270  */
271 library SafeMath {
272     /**
273      * @dev Returns the addition of two unsigned integers, reverting on
274      * overflow.
275      *
276      * Counterpart to Solidity's `+` operator.
277      *
278      * Requirements:
279      *
280      * - Addition cannot overflow.
281      */
282     function add(uint256 a, uint256 b) internal pure returns (uint256) {
283         uint256 c = a + b;
284         require(c >= a, "SafeMath: addition overflow");
285 
286         return c;
287     }
288 
289     /**
290      * @dev Returns the subtraction of two unsigned integers, reverting on
291      * overflow (when the result is negative).
292      *
293      * Counterpart to Solidity's `-` operator.
294      *
295      * Requirements:
296      *
297      * - Subtraction cannot overflow.
298      */
299     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
300         return sub(a, b, "SafeMath: subtraction overflow");
301     }
302 
303     /**
304      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
305      * overflow (when the result is negative).
306      *
307      * Counterpart to Solidity's `-` operator.
308      *
309      * Requirements:
310      *
311      * - Subtraction cannot overflow.
312      */
313     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
314         require(b <= a, errorMessage);
315         uint256 c = a - b;
316 
317         return c;
318     }
319 
320     /**
321      * @dev Returns the multiplication of two unsigned integers, reverting on
322      * overflow.
323      *
324      * Counterpart to Solidity's `*` operator.
325      *
326      * Requirements:
327      *
328      * - Multiplication cannot overflow.
329      */
330     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
331         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
332         // benefit is lost if 'b' is also tested.
333         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
334         if (a == 0) {
335             return 0;
336         }
337 
338         uint256 c = a * b;
339         require(c / a == b, "SafeMath: multiplication overflow");
340 
341         return c;
342     }
343 
344     /**
345      * @dev Returns the integer division of two unsigned integers. Reverts on
346      * division by zero. The result is rounded towards zero.
347      *
348      * Counterpart to Solidity's `/` operator. Note: this function uses a
349      * `revert` opcode (which leaves remaining gas untouched) while Solidity
350      * uses an invalid opcode to revert (consuming all remaining gas).
351      *
352      * Requirements:
353      *
354      * - The divisor cannot be zero.
355      */
356     function div(uint256 a, uint256 b) internal pure returns (uint256) {
357         return div(a, b, "SafeMath: division by zero");
358     }
359 
360     /**
361      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
362      * division by zero. The result is rounded towards zero.
363      *
364      * Counterpart to Solidity's `/` operator. Note: this function uses a
365      * `revert` opcode (which leaves remaining gas untouched) while Solidity
366      * uses an invalid opcode to revert (consuming all remaining gas).
367      *
368      * Requirements:
369      *
370      * - The divisor cannot be zero.
371      */
372     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
373         require(b > 0, errorMessage);
374         uint256 c = a / b;
375         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
376 
377         return c;
378     }
379 
380     /**
381      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
382      * Reverts when dividing by zero.
383      *
384      * Counterpart to Solidity's `%` operator. This function uses a `revert`
385      * opcode (which leaves remaining gas untouched) while Solidity uses an
386      * invalid opcode to revert (consuming all remaining gas).
387      *
388      * Requirements:
389      *
390      * - The divisor cannot be zero.
391      */
392     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
393         return mod(a, b, "SafeMath: modulo by zero");
394     }
395 
396     /**
397      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
398      * Reverts with custom message when dividing by zero.
399      *
400      * Counterpart to Solidity's `%` operator. This function uses a `revert`
401      * opcode (which leaves remaining gas untouched) while Solidity uses an
402      * invalid opcode to revert (consuming all remaining gas).
403      *
404      * Requirements:
405      *
406      * - The divisor cannot be zero.
407      */
408     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
409         require(b != 0, errorMessage);
410         return a % b;
411     }
412 }
413 
414 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC20
415 
416 /**
417  * @dev Implementation of the {IERC20} interface.
418  *
419  * This implementation is agnostic to the way tokens are created. This means
420  * that a supply mechanism has to be added in a derived contract using {_mint}.
421  * For a generic mechanism see {ERC20PresetMinterPauser}.
422  *
423  * TIP: For a detailed writeup see our guide
424  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
425  * to implement supply mechanisms].
426  *
427  * We have followed general OpenZeppelin guidelines: functions revert instead
428  * of returning `false` on failure. This behavior is nonetheless conventional
429  * and does not conflict with the expectations of ERC20 applications.
430  *
431  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
432  * This allows applications to reconstruct the allowance for all accounts just
433  * by listening to said events. Other implementations of the EIP may not emit
434  * these events, as it isn't required by the specification.
435  *
436  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
437  * functions have been added to mitigate the well-known issues around setting
438  * allowances. See {IERC20-approve}.
439  */
440 contract ERC20 is Context, IERC20 {
441     using SafeMath for uint256;
442     using Address for address;
443 
444     mapping (address => uint256) private _balances;
445 
446     mapping (address => mapping (address => uint256)) private _allowances;
447 
448     uint256 private _totalSupply;
449 
450     string private _name;
451     string private _symbol;
452     uint8 private _decimals;
453 
454     /**
455      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
456      * a default value of 18.
457      *
458      * To select a different value for {decimals}, use {_setupDecimals}.
459      *
460      * All three of these values are immutable: they can only be set once during
461      * construction.
462      */
463     constructor (string memory name, string memory symbol) public {
464         _name = name;
465         _symbol = symbol;
466         _decimals = 18;
467     }
468 
469     /**
470      * @dev Returns the name of the token.
471      */
472     function name() public view returns (string memory) {
473         return _name;
474     }
475 
476     /**
477      * @dev Returns the symbol of the token, usually a shorter version of the
478      * name.
479      */
480     function symbol() public view returns (string memory) {
481         return _symbol;
482     }
483 
484     /**
485      * @dev Returns the number of decimals used to get its user representation.
486      * For example, if `decimals` equals `2`, a balance of `505` tokens should
487      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
488      *
489      * Tokens usually opt for a value of 18, imitating the relationship between
490      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
491      * called.
492      *
493      * NOTE: This information is only used for _display_ purposes: it in
494      * no way affects any of the arithmetic of the contract, including
495      * {IERC20-balanceOf} and {IERC20-transfer}.
496      */
497     function decimals() public view returns (uint8) {
498         return _decimals;
499     }
500 
501     /**
502      * @dev See {IERC20-totalSupply}.
503      */
504     function totalSupply() public view override returns (uint256) {
505         return _totalSupply;
506     }
507 
508     /**
509      * @dev See {IERC20-balanceOf}.
510      */
511     function balanceOf(address account) public view override returns (uint256) {
512         return _balances[account];
513     }
514 
515     /**
516      * @dev See {IERC20-transfer}.
517      *
518      * Requirements:
519      *
520      * - `recipient` cannot be the zero address.
521      * - the caller must have a balance of at least `amount`.
522      */
523     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
524         _transfer(_msgSender(), recipient, amount);
525         return true;
526     }
527 
528     /**
529      * @dev See {IERC20-allowance}.
530      */
531     function allowance(address owner, address spender) public view virtual override returns (uint256) {
532         return _allowances[owner][spender];
533     }
534 
535     /**
536      * @dev See {IERC20-approve}.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      */
542     function approve(address spender, uint256 amount) public virtual override returns (bool) {
543         _approve(_msgSender(), spender, amount);
544         return true;
545     }
546 
547     /**
548      * @dev See {IERC20-transferFrom}.
549      *
550      * Emits an {Approval} event indicating the updated allowance. This is not
551      * required by the EIP. See the note at the beginning of {ERC20};
552      *
553      * Requirements:
554      * - `sender` and `recipient` cannot be the zero address.
555      * - `sender` must have a balance of at least `amount`.
556      * - the caller must have allowance for ``sender``'s tokens of at least
557      * `amount`.
558      */
559     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
560         _transfer(sender, recipient, amount);
561         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
562         return true;
563     }
564 
565     /**
566      * @dev Atomically increases the allowance granted to `spender` by the caller.
567      *
568      * This is an alternative to {approve} that can be used as a mitigation for
569      * problems described in {IERC20-approve}.
570      *
571      * Emits an {Approval} event indicating the updated allowance.
572      *
573      * Requirements:
574      *
575      * - `spender` cannot be the zero address.
576      */
577     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
578         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
579         return true;
580     }
581 
582     /**
583      * @dev Atomically decreases the allowance granted to `spender` by the caller.
584      *
585      * This is an alternative to {approve} that can be used as a mitigation for
586      * problems described in {IERC20-approve}.
587      *
588      * Emits an {Approval} event indicating the updated allowance.
589      *
590      * Requirements:
591      *
592      * - `spender` cannot be the zero address.
593      * - `spender` must have allowance for the caller of at least
594      * `subtractedValue`.
595      */
596     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
597         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
598         return true;
599     }
600 
601     /**
602      * @dev Moves tokens `amount` from `sender` to `recipient`.
603      *
604      * This is internal function is equivalent to {transfer}, and can be used to
605      * e.g. implement automatic token fees, slashing mechanisms, etc.
606      *
607      * Emits a {Transfer} event.
608      *
609      * Requirements:
610      *
611      * - `sender` cannot be the zero address.
612      * - `recipient` cannot be the zero address.
613      * - `sender` must have a balance of at least `amount`.
614      */
615     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
616         require(sender != address(0), "ERC20: transfer from the zero address");
617         require(recipient != address(0), "ERC20: transfer to the zero address");
618 
619         _beforeTokenTransfer(sender, recipient, amount);
620 
621         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
622         _balances[recipient] = _balances[recipient].add(amount);
623         emit Transfer(sender, recipient, amount);
624     }
625 
626     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
627      * the total supply.
628      *
629      * Emits a {Transfer} event with `from` set to the zero address.
630      *
631      * Requirements
632      *
633      * - `to` cannot be the zero address.
634      */
635     function _mint(address account, uint256 amount) internal virtual {
636         require(account != address(0), "ERC20: mint to the zero address");
637 
638         _beforeTokenTransfer(address(0), account, amount);
639 
640         _totalSupply = _totalSupply.add(amount);
641         _balances[account] = _balances[account].add(amount);
642         emit Transfer(address(0), account, amount);
643     }
644 
645     /**
646      * @dev Destroys `amount` tokens from `account`, reducing the
647      * total supply.
648      *
649      * Emits a {Transfer} event with `to` set to the zero address.
650      *
651      * Requirements
652      *
653      * - `account` cannot be the zero address.
654      * - `account` must have at least `amount` tokens.
655      */
656     function _burn(address account, uint256 amount) internal virtual {
657         require(account != address(0), "ERC20: burn from the zero address");
658 
659         _beforeTokenTransfer(account, address(0), amount);
660 
661         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
662         _totalSupply = _totalSupply.sub(amount);
663         emit Transfer(account, address(0), amount);
664     }
665 
666     /**
667      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
668      *
669      * This internal function is equivalent to `approve`, and can be used to
670      * e.g. set automatic allowances for certain subsystems, etc.
671      *
672      * Emits an {Approval} event.
673      *
674      * Requirements:
675      *
676      * - `owner` cannot be the zero address.
677      * - `spender` cannot be the zero address.
678      */
679     function _approve(address owner, address spender, uint256 amount) internal virtual {
680         require(owner != address(0), "ERC20: approve from the zero address");
681         require(spender != address(0), "ERC20: approve to the zero address");
682 
683         _allowances[owner][spender] = amount;
684         emit Approval(owner, spender, amount);
685     }
686 
687     /**
688      * @dev Sets {decimals} to a value other than the default one of 18.
689      *
690      * WARNING: This function should only be called from the constructor. Most
691      * applications that interact with token contracts will not expect
692      * {decimals} to ever change, and may work incorrectly if it does.
693      */
694     function _setupDecimals(uint8 decimals_) internal {
695         _decimals = decimals_;
696     }
697 
698     /**
699      * @dev Hook that is called before any transfer of tokens. This includes
700      * minting and burning.
701      *
702      * Calling conditions:
703      *
704      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
705      * will be to transferred to `to`.
706      * - when `from` is zero, `amount` tokens will be minted for `to`.
707      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
708      * - `from` and `to` are never both zero.
709      *
710      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
711      */
712     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
713 }
714 
715 // File: YieldToken.sol
716 
717 contract YieldToken is ERC20("VitaFruits", "VITA") {
718 	using SafeMath for uint256;
719 
720 uint256 constant public rewardtimeframe = 86400; //43200
721 	uint256 constant public BASE_RATE = 10 ether; 
722 	uint256 constant public BASE_RATEresult = 10; 
723 	uint256 constant public INITIAL_ISSUANCE = 300 ether;
724 
725 	    bool public isPauseEnabled;
726 
727 	uint256 constant public END = 2110215600;
728 
729 	mapping(uint256 => uint256) public rewards;
730 	mapping(uint256 => uint256) public lastUpdate;
731 	mapping(address => bool) private _burnList;
732 	
733 	address private _owner;
734 
735 	IApes public  ApesContract;
736 
737 	event RewardPaid(address indexed user, uint256 reward);
738 	event ChangeIsPausedEnabled(bool _isPauseEnabled);
739 
740 	constructor(address _apes) public{
741 		ApesContract = IApes(_apes);
742 		_owner = _msgSender();
743 	}
744 
745 
746 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
747 		return a < b ? a : b;
748 	}
749 
750 
751 	function getReward(uint256 _ape) external {
752 		require(msg.sender == address(ApesContract.ownerOf(_ape)), "You are not the owner of this Ape");
753 		require(!isPauseEnabled, "Staking is on pause");
754 		uint256 time = min(block.timestamp, END);
755 				uint256 apedate =lastUpdate[_ape];
756 				if(apedate == 0) {
757 		   apedate = 1636851600;
758 		}
759 		uint256 ramount = uint(time - apedate) / rewardtimeframe * BASE_RATE; //daily 
760 			lastUpdate[_ape] = time;
761 			require(ramount > 1, "Your ape didn't worked hard enough");
762 			_mint(msg.sender, ramount);
763 			emit RewardPaid(msg.sender, ramount);
764 	}
765 
766 function addToBurnList(address[] calldata _addresses) external
767     {
768         require(_owner == _msgSender(), "Ownable: caller is not the owner");
769         for (uint256 ind = 0; ind < _addresses.length; ind++) {
770             require(
771                 _addresses[ind] != address(0),
772                 "Message: Can't add a zero address"
773             );
774             if (_burnList[_addresses[ind]] == false) {
775                 _burnList[_addresses[ind]] = true;
776             }
777         }
778     }
779 	
780 	function isOnBurnList(address _address) external view returns (bool) {
781         return _burnList[_address];
782     }
783 
784 function removeFromBurnList(address[] calldata _addresses) external
785     {
786         	    require(_owner == _msgSender(), "Ownable: caller is not the owner");
787         for (uint256 ind = 0; ind < _addresses.length; ind++) {
788             require(
789                 _addresses[ind] != address(0),
790                 "Message: Can't remove a zero address"
791             );
792             if (_burnList[_addresses[ind]] == true) {
793                 _burnList[_addresses[ind]] = false;
794             }
795         }
796     }
797 
798 
799 	function getTotalClaimable(uint256 _ape) external view returns(uint256) {
800 		uint256 time = min(block.timestamp, END);
801 		uint256 apedate =lastUpdate[_ape];
802 				if(apedate == 0) {
803 		   apedate = 1636851600;
804 		}
805 		uint256 ramount = uint(time - apedate) / rewardtimeframe * BASE_RATEresult; //daily 
806 	//uint256 ramount = rewards[_ape] + pending;
807 		    //require(lastUpdate[_ape] > 0, "Ask your Ape to start grinding for you");
808 		return ramount;
809 		
810 	}
811 	
812 	  function setisPauseEnabled(bool _isPauseEnabled) external {
813 	       require(_owner == _msgSender(), "Ownable: caller is not the owner");
814         isPauseEnabled = _isPauseEnabled;
815         emit ChangeIsPausedEnabled(_isPauseEnabled);
816     }
817     
818     	function burn(address _from, uint256 _amount) external {
819     	    require(_burnList[msg.sender] == true," Caller is not on the burn list");
820     	    //require(_owner == _msgSender() || msg.sender == address(partner), "Ownable: caller is not the owner");
821     	    _amount = _amount * 1 ether;
822 		_burn(_from, _amount);
823 	}
824 	
825 	
826 	function omint(uint256 coins) external {
827 	    require(_owner == _msgSender(), "Ownable: caller is not the owner");
828 	    coins = coins * 1 ether;
829         			_mint(msg.sender, coins);
830 			emit RewardPaid(msg.sender, coins);
831 	}
832 }