1 // SPDX-License-Identifier: MIT
2 
3 /*
4  * Token was generated for FREE at https://vittominacori.github.io/erc20-generator/
5  *
6  * Author: @vittominacori (https://vittominacori.github.io)
7  *
8  * Smart Contract Source Code: https://github.com/vittominacori/erc20-generator
9  * Smart Contract Test Builds: https://travis-ci.com/github/vittominacori/erc20-generator
10  * Web Site Source Code: https://github.com/vittominacori/erc20-generator/tree/dapp
11  *
12  * Detailed Info: https://medium.com/@vittominacori/create-an-erc20-token-in-less-than-a-minute-2a8751c4d6f4
13  *
14  * Note: "Contract Source Code Verified (Similar Match)" means that this Token is similar to other tokens deployed
15  *  using the same generator. It is not an issue. It means that you won't need to verify your source code because of
16  *  it is already verified.
17  *
18  * Disclaimer: GENERATOR'S AUTHOR IS FREE OF ANY LIABILITY REGARDING THE TOKEN AND THE USE THAT IS MADE OF IT.
19  *  The following code is provided under MIT License. Anyone can use it as per their needs.
20  *  The generator's purpose is to make people able to tokenize their ideas without coding or paying for it.
21  *  Source code is well tested and continuously updated to reduce risk of bugs and introduce language optimizations.
22  *  Anyway the purchase of tokens involves a high degree of risk. Before acquiring tokens, it is recommended to
23  *  carefully weighs all the information and risks detailed in Token owner's Conditions.
24  */
25 
26 // File: @openzeppelin/contracts/GSN/Context.sol
27 
28 pragma solidity ^0.7.0;
29 
30 /*
31  * @dev Provides information about the current execution context, including the
32  * sender of the transaction and its data. While these are generally available
33  * via msg.sender and msg.data, they should not be accessed in such a direct
34  * manner, since when dealing with GSN meta-transactions the account sending and
35  * paying for execution may not be the actual sender (as far as an application
36  * is concerned).
37  *
38  * This contract is only required for intermediate, library-like contracts.
39  */
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address payable) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes memory) {
46         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
47         return msg.data;
48     }
49 }
50 
51 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
52 
53 pragma solidity ^0.7.0;
54 
55 /**
56  * @dev Interface of the ERC20 standard as defined in the EIP.
57  */
58 interface IERC20 {
59     /**
60      * @dev Returns the amount of tokens in existence.
61      */
62     function totalSupply() external view returns (uint256);
63 
64     /**
65      * @dev Returns the amount of tokens owned by `account`.
66      */
67     function balanceOf(address account) external view returns (uint256);
68 
69     /**
70      * @dev Moves `amount` tokens from the caller's account to `recipient`.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transfer(address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Returns the remaining number of tokens that `spender` will be
80      * allowed to spend on behalf of `owner` through {transferFrom}. This is
81      * zero by default.
82      *
83      * This value changes when {approve} or {transferFrom} are called.
84      */
85     function allowance(address owner, address spender) external view returns (uint256);
86 
87     /**
88      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * IMPORTANT: Beware that changing an allowance with this method brings the risk
93      * that someone may use both the old and the new allowance by unfortunate
94      * transaction ordering. One possible solution to mitigate this race
95      * condition is to first reduce the spender's allowance to 0 and set the
96      * desired value afterwards:
97      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98      *
99      * Emits an {Approval} event.
100      */
101     function approve(address spender, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Moves `amount` tokens from `sender` to `recipient` using the
105      * allowance mechanism. `amount` is then deducted from the caller's
106      * allowance.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
113 
114     /**
115      * @dev Emitted when `value` tokens are moved from one account (`from`) to
116      * another (`to`).
117      *
118      * Note that `value` may be zero.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 
122     /**
123      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
124      * a call to {approve}. `value` is the new allowance.
125      */
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 // File: @openzeppelin/contracts/math/SafeMath.sol
130 
131 pragma solidity ^0.7.0;
132 
133 /**
134  * @dev Wrappers over Solidity's arithmetic operations with added overflow
135  * checks.
136  *
137  * Arithmetic operations in Solidity wrap on overflow. This can easily result
138  * in bugs, because programmers usually assume that an overflow raises an
139  * error, which is the standard behavior in high level programming languages.
140  * `SafeMath` restores this intuition by reverting the transaction when an
141  * operation overflows.
142  *
143  * Using this library instead of the unchecked operations eliminates an entire
144  * class of bugs, so it's recommended to use it always.
145  */
146 library SafeMath {
147     /**
148      * @dev Returns the addition of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `+` operator.
152      *
153      * Requirements:
154      *
155      * - Addition cannot overflow.
156      */
157     function add(uint256 a, uint256 b) internal pure returns (uint256) {
158         uint256 c = a + b;
159         require(c >= a, "SafeMath: addition overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting on
166      * overflow (when the result is negative).
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175         return sub(a, b, "SafeMath: subtraction overflow");
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
180      * overflow (when the result is negative).
181      *
182      * Counterpart to Solidity's `-` operator.
183      *
184      * Requirements:
185      *
186      * - Subtraction cannot overflow.
187      */
188     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b <= a, errorMessage);
190         uint256 c = a - b;
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the multiplication of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `*` operator.
200      *
201      * Requirements:
202      *
203      * - Multiplication cannot overflow.
204      */
205     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
206         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
207         // benefit is lost if 'b' is also tested.
208         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
209         if (a == 0) {
210             return 0;
211         }
212 
213         uint256 c = a * b;
214         require(c / a == b, "SafeMath: multiplication overflow");
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers. Reverts on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(uint256 a, uint256 b) internal pure returns (uint256) {
232         return div(a, b, "SafeMath: division by zero");
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator. Note: this function uses a
240      * `revert` opcode (which leaves remaining gas untouched) while Solidity
241      * uses an invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b > 0, errorMessage);
249         uint256 c = a / b;
250         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
268         return mod(a, b, "SafeMath: modulo by zero");
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
273      * Reverts with custom message when dividing by zero.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b != 0, errorMessage);
285         return a % b;
286     }
287 }
288 
289 // File: @openzeppelin/contracts/utils/Address.sol
290 
291 pragma solidity ^0.7.0;
292 
293 /**
294  * @dev Collection of functions related to the address type
295  */
296 library Address {
297     /**
298      * @dev Returns true if `account` is a contract.
299      *
300      * [IMPORTANT]
301      * ====
302      * It is unsafe to assume that an address for which this function returns
303      * false is an externally-owned account (EOA) and not a contract.
304      *
305      * Among others, `isContract` will return false for the following
306      * types of addresses:
307      *
308      *  - an externally-owned account
309      *  - a contract in construction
310      *  - an address where a contract will be created
311      *  - an address where a contract lived, but was destroyed
312      * ====
313      */
314     function isContract(address account) internal view returns (bool) {
315         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
316         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
317         // for accounts without code, i.e. `keccak256('')`
318         bytes32 codehash;
319         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
320         // solhint-disable-next-line no-inline-assembly
321         assembly { codehash := extcodehash(account) }
322         return (codehash != accountHash && codehash != 0x0);
323     }
324 
325     /**
326      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
327      * `recipient`, forwarding all available gas and reverting on errors.
328      *
329      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
330      * of certain opcodes, possibly making contracts go over the 2300 gas limit
331      * imposed by `transfer`, making them unable to receive funds via
332      * `transfer`. {sendValue} removes this limitation.
333      *
334      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
335      *
336      * IMPORTANT: because control is transferred to `recipient`, care must be
337      * taken to not create reentrancy vulnerabilities. Consider using
338      * {ReentrancyGuard} or the
339      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
340      */
341     function sendValue(address payable recipient, uint256 amount) internal {
342         require(address(this).balance >= amount, "Address: insufficient balance");
343 
344         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
345         (bool success, ) = recipient.call{ value: amount }("");
346         require(success, "Address: unable to send value, recipient may have reverted");
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain`call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
368       return functionCall(target, data, "Address: low-level call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
373      * `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
378         return _functionCallWithValue(target, data, 0, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but also transferring `value` wei to `target`.
384      *
385      * Requirements:
386      *
387      * - the calling contract must have an ETH balance of at least `value`.
388      * - the called Solidity function must be `payable`.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
403         require(address(this).balance >= value, "Address: insufficient balance for call");
404         return _functionCallWithValue(target, data, value, errorMessage);
405     }
406 
407     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
408         require(isContract(target), "Address: call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
412         if (success) {
413             return returndata;
414         } else {
415             // Look for revert reason and bubble it up if present
416             if (returndata.length > 0) {
417                 // The easiest way to bubble the revert reason is using memory via assembly
418 
419                 // solhint-disable-next-line no-inline-assembly
420                 assembly {
421                     let returndata_size := mload(returndata)
422                     revert(add(32, returndata), returndata_size)
423                 }
424             } else {
425                 revert(errorMessage);
426             }
427         }
428     }
429 }
430 
431 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
432 
433 pragma solidity ^0.7.0;
434 
435 /**
436  * @dev Implementation of the {IERC20} interface.
437  *
438  * This implementation is agnostic to the way tokens are created. This means
439  * that a supply mechanism has to be added in a derived contract using {_mint}.
440  * For a generic mechanism see {ERC20PresetMinterPauser}.
441  *
442  * TIP: For a detailed writeup see our guide
443  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
444  * to implement supply mechanisms].
445  *
446  * We have followed general OpenZeppelin guidelines: functions revert instead
447  * of returning `false` on failure. This behavior is nonetheless conventional
448  * and does not conflict with the expectations of ERC20 applications.
449  *
450  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
451  * This allows applications to reconstruct the allowance for all accounts just
452  * by listening to said events. Other implementations of the EIP may not emit
453  * these events, as it isn't required by the specification.
454  *
455  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
456  * functions have been added to mitigate the well-known issues around setting
457  * allowances. See {IERC20-approve}.
458  */
459 contract ERC20 is Context, IERC20 {
460     using SafeMath for uint256;
461     using Address for address;
462 
463     mapping (address => uint256) private _balances;
464 
465     mapping (address => mapping (address => uint256)) private _allowances;
466 
467     uint256 private _totalSupply;
468 
469     string private _name;
470     string private _symbol;
471     uint8 private _decimals;
472 
473     /**
474      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
475      * a default value of 18.
476      *
477      * To select a different value for {decimals}, use {_setupDecimals}.
478      *
479      * All three of these values are immutable: they can only be set once during
480      * construction.
481      */
482     constructor (string memory name, string memory symbol) {
483         _name = name;
484         _symbol = symbol;
485         _decimals = 18;
486     }
487 
488     /**
489      * @dev Returns the name of the token.
490      */
491     function name() public view returns (string memory) {
492         return _name;
493     }
494 
495     /**
496      * @dev Returns the symbol of the token, usually a shorter version of the
497      * name.
498      */
499     function symbol() public view returns (string memory) {
500         return _symbol;
501     }
502 
503     /**
504      * @dev Returns the number of decimals used to get its user representation.
505      * For example, if `decimals` equals `2`, a balance of `505` tokens should
506      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
507      *
508      * Tokens usually opt for a value of 18, imitating the relationship between
509      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
510      * called.
511      *
512      * NOTE: This information is only used for _display_ purposes: it in
513      * no way affects any of the arithmetic of the contract, including
514      * {IERC20-balanceOf} and {IERC20-transfer}.
515      */
516     function decimals() public view returns (uint8) {
517         return _decimals;
518     }
519 
520     /**
521      * @dev See {IERC20-totalSupply}.
522      */
523     function totalSupply() public view override returns (uint256) {
524         return _totalSupply;
525     }
526 
527     /**
528      * @dev See {IERC20-balanceOf}.
529      */
530     function balanceOf(address account) public view override returns (uint256) {
531         return _balances[account];
532     }
533 
534     /**
535      * @dev See {IERC20-transfer}.
536      *
537      * Requirements:
538      *
539      * - `recipient` cannot be the zero address.
540      * - the caller must have a balance of at least `amount`.
541      */
542     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
543         _transfer(_msgSender(), recipient, amount);
544         return true;
545     }
546 
547     /**
548      * @dev See {IERC20-allowance}.
549      */
550     function allowance(address owner, address spender) public view virtual override returns (uint256) {
551         return _allowances[owner][spender];
552     }
553 
554     /**
555      * @dev See {IERC20-approve}.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      */
561     function approve(address spender, uint256 amount) public virtual override returns (bool) {
562         _approve(_msgSender(), spender, amount);
563         return true;
564     }
565 
566     /**
567      * @dev See {IERC20-transferFrom}.
568      *
569      * Emits an {Approval} event indicating the updated allowance. This is not
570      * required by the EIP. See the note at the beginning of {ERC20};
571      *
572      * Requirements:
573      * - `sender` and `recipient` cannot be the zero address.
574      * - `sender` must have a balance of at least `amount`.
575      * - the caller must have allowance for ``sender``'s tokens of at least
576      * `amount`.
577      */
578     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
579         _transfer(sender, recipient, amount);
580         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
581         return true;
582     }
583 
584     /**
585      * @dev Atomically increases the allowance granted to `spender` by the caller.
586      *
587      * This is an alternative to {approve} that can be used as a mitigation for
588      * problems described in {IERC20-approve}.
589      *
590      * Emits an {Approval} event indicating the updated allowance.
591      *
592      * Requirements:
593      *
594      * - `spender` cannot be the zero address.
595      */
596     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
597         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
598         return true;
599     }
600 
601     /**
602      * @dev Atomically decreases the allowance granted to `spender` by the caller.
603      *
604      * This is an alternative to {approve} that can be used as a mitigation for
605      * problems described in {IERC20-approve}.
606      *
607      * Emits an {Approval} event indicating the updated allowance.
608      *
609      * Requirements:
610      *
611      * - `spender` cannot be the zero address.
612      * - `spender` must have allowance for the caller of at least
613      * `subtractedValue`.
614      */
615     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
616         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
617         return true;
618     }
619 
620     /**
621      * @dev Moves tokens `amount` from `sender` to `recipient`.
622      *
623      * This is internal function is equivalent to {transfer}, and can be used to
624      * e.g. implement automatic token fees, slashing mechanisms, etc.
625      *
626      * Emits a {Transfer} event.
627      *
628      * Requirements:
629      *
630      * - `sender` cannot be the zero address.
631      * - `recipient` cannot be the zero address.
632      * - `sender` must have a balance of at least `amount`.
633      */
634     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
635         require(sender != address(0), "ERC20: transfer from the zero address");
636         require(recipient != address(0), "ERC20: transfer to the zero address");
637 
638         _beforeTokenTransfer(sender, recipient, amount);
639 
640         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
641         _balances[recipient] = _balances[recipient].add(amount);
642         emit Transfer(sender, recipient, amount);
643     }
644 
645     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
646      * the total supply.
647      *
648      * Emits a {Transfer} event with `from` set to the zero address.
649      *
650      * Requirements
651      *
652      * - `to` cannot be the zero address.
653      */
654     function _mint(address account, uint256 amount) internal virtual {
655         require(account != address(0), "ERC20: mint to the zero address");
656 
657         _beforeTokenTransfer(address(0), account, amount);
658 
659         _totalSupply = _totalSupply.add(amount);
660         _balances[account] = _balances[account].add(amount);
661         emit Transfer(address(0), account, amount);
662     }
663 
664     /**
665      * @dev Destroys `amount` tokens from `account`, reducing the
666      * total supply.
667      *
668      * Emits a {Transfer} event with `to` set to the zero address.
669      *
670      * Requirements
671      *
672      * - `account` cannot be the zero address.
673      * - `account` must have at least `amount` tokens.
674      */
675     function _burn(address account, uint256 amount) internal virtual {
676         require(account != address(0), "ERC20: burn from the zero address");
677 
678         _beforeTokenTransfer(account, address(0), amount);
679 
680         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
681         _totalSupply = _totalSupply.sub(amount);
682         emit Transfer(account, address(0), amount);
683     }
684 
685     /**
686      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
687      *
688      * This internal function is equivalent to `approve`, and can be used to
689      * e.g. set automatic allowances for certain subsystems, etc.
690      *
691      * Emits an {Approval} event.
692      *
693      * Requirements:
694      *
695      * - `owner` cannot be the zero address.
696      * - `spender` cannot be the zero address.
697      */
698     function _approve(address owner, address spender, uint256 amount) internal virtual {
699         require(owner != address(0), "ERC20: approve from the zero address");
700         require(spender != address(0), "ERC20: approve to the zero address");
701 
702         _allowances[owner][spender] = amount;
703         emit Approval(owner, spender, amount);
704     }
705 
706     /**
707      * @dev Sets {decimals} to a value other than the default one of 18.
708      *
709      * WARNING: This function should only be called from the constructor. Most
710      * applications that interact with token contracts will not expect
711      * {decimals} to ever change, and may work incorrectly if it does.
712      */
713     function _setupDecimals(uint8 decimals_) internal {
714         _decimals = decimals_;
715     }
716 
717     /**
718      * @dev Hook that is called before any transfer of tokens. This includes
719      * minting and burning.
720      *
721      * Calling conditions:
722      *
723      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
724      * will be to transferred to `to`.
725      * - when `from` is zero, `amount` tokens will be minted for `to`.
726      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
727      * - `from` and `to` are never both zero.
728      *
729      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
730      */
731     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
732 }
733 
734 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
735 
736 pragma solidity ^0.7.0;
737 
738 /**
739  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
740  */
741 abstract contract ERC20Capped is ERC20 {
742     using SafeMath for uint256;
743 
744     uint256 private _cap;
745 
746     /**
747      * @dev Sets the value of the `cap`. This value is immutable, it can only be
748      * set once during construction.
749      */
750     constructor (uint256 cap) {
751         require(cap > 0, "ERC20Capped: cap is 0");
752         _cap = cap;
753     }
754 
755     /**
756      * @dev Returns the cap on the token's total supply.
757      */
758     function cap() public view returns (uint256) {
759         return _cap;
760     }
761 
762     /**
763      * @dev See {ERC20-_beforeTokenTransfer}.
764      *
765      * Requirements:
766      *
767      * - minted tokens must not cause the total supply to go over the cap.
768      */
769     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
770         super._beforeTokenTransfer(from, to, amount);
771 
772         if (from == address(0)) { // When minting tokens
773             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
774         }
775     }
776 }
777 
778 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
779 
780 pragma solidity ^0.7.0;
781 
782 /**
783  * @dev Extension of {ERC20} that allows token holders to destroy both their own
784  * tokens and those that they have an allowance for, in a way that can be
785  * recognized off-chain (via event analysis).
786  */
787 abstract contract ERC20Burnable is Context, ERC20 {
788     using SafeMath for uint256;
789 
790     /**
791      * @dev Destroys `amount` tokens from the caller.
792      *
793      * See {ERC20-_burn}.
794      */
795     function burn(uint256 amount) public virtual {
796         _burn(_msgSender(), amount);
797     }
798 
799     /**
800      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
801      * allowance.
802      *
803      * See {ERC20-_burn} and {ERC20-allowance}.
804      *
805      * Requirements:
806      *
807      * - the caller must have allowance for ``accounts``'s tokens of at least
808      * `amount`.
809      */
810     function burnFrom(address account, uint256 amount) public virtual {
811         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
812 
813         _approve(account, _msgSender(), decreasedAllowance);
814         _burn(account, amount);
815     }
816 }
817 
818 // File: @openzeppelin/contracts/introspection/IERC165.sol
819 
820 pragma solidity ^0.7.0;
821 
822 /**
823  * @dev Interface of the ERC165 standard, as defined in the
824  * https://eips.ethereum.org/EIPS/eip-165[EIP].
825  *
826  * Implementers can declare support of contract interfaces, which can then be
827  * queried by others ({ERC165Checker}).
828  *
829  * For an implementation, see {ERC165}.
830  */
831 interface IERC165 {
832     /**
833      * @dev Returns true if this contract implements the interface defined by
834      * `interfaceId`. See the corresponding
835      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
836      * to learn more about how these ids are created.
837      *
838      * This function call must use less than 30 000 gas.
839      */
840     function supportsInterface(bytes4 interfaceId) external view returns (bool);
841 }
842 
843 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
844 
845 pragma solidity ^0.7.0;
846 
847 /**
848  * @title IERC1363 Interface
849  * @author Vittorio Minacori (https://github.com/vittominacori)
850  * @dev Interface for a Payable Token contract as defined in
851  *  https://eips.ethereum.org/EIPS/eip-1363
852  */
853 interface IERC1363 is IERC20, IERC165 {
854     /*
855      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
856      * 0x4bbee2df ===
857      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
858      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
859      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
860      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
861      */
862 
863     /*
864      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
865      * 0xfb9ec8ce ===
866      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
867      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
868      */
869 
870     /**
871      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
872      * @param to address The address which you want to transfer to
873      * @param value uint256 The amount of tokens to be transferred
874      * @return true unless throwing
875      */
876     function transferAndCall(address to, uint256 value) external returns (bool);
877 
878     /**
879      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
880      * @param to address The address which you want to transfer to
881      * @param value uint256 The amount of tokens to be transferred
882      * @param data bytes Additional data with no specified format, sent in call to `to`
883      * @return true unless throwing
884      */
885     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
886 
887     /**
888      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
889      * @param from address The address which you want to send tokens from
890      * @param to address The address which you want to transfer to
891      * @param value uint256 The amount of tokens to be transferred
892      * @return true unless throwing
893      */
894     function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
895 
896     /**
897      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
898      * @param from address The address which you want to send tokens from
899      * @param to address The address which you want to transfer to
900      * @param value uint256 The amount of tokens to be transferred
901      * @param data bytes Additional data with no specified format, sent in call to `to`
902      * @return true unless throwing
903      */
904     function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
905 
906     /**
907      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
908      * and then call `onApprovalReceived` on spender.
909      * Beware that changing an allowance with this method brings the risk that someone may use both the old
910      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
911      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
912      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
913      * @param spender address The address which will spend the funds
914      * @param value uint256 The amount of tokens to be spent
915      */
916     function approveAndCall(address spender, uint256 value) external returns (bool);
917 
918     /**
919      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
920      * and then call `onApprovalReceived` on spender.
921      * Beware that changing an allowance with this method brings the risk that someone may use both the old
922      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
923      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
924      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
925      * @param spender address The address which will spend the funds
926      * @param value uint256 The amount of tokens to be spent
927      * @param data bytes Additional data with no specified format, sent in call to `spender`
928      */
929     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
930 }
931 
932 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
933 
934 pragma solidity ^0.7.0;
935 
936 /**
937  * @title IERC1363Receiver Interface
938  * @author Vittorio Minacori (https://github.com/vittominacori)
939  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
940  *  from ERC1363 token contracts as defined in
941  *  https://eips.ethereum.org/EIPS/eip-1363
942  */
943 interface IERC1363Receiver {
944     /*
945      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
946      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
947      */
948 
949     /**
950      * @notice Handle the receipt of ERC1363 tokens
951      * @dev Any ERC1363 smart contract calls this function on the recipient
952      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
953      * transfer. Return of other than the magic value MUST result in the
954      * transaction being reverted.
955      * Note: the token contract address is always the message sender.
956      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
957      * @param from address The address which are token transferred from
958      * @param value uint256 The amount of tokens transferred
959      * @param data bytes Additional data with no specified format
960      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
961      *  unless throwing
962      */
963     function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4); // solhint-disable-line  max-line-length
964 }
965 
966 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
967 
968 pragma solidity ^0.7.0;
969 
970 /**
971  * @title IERC1363Spender Interface
972  * @author Vittorio Minacori (https://github.com/vittominacori)
973  * @dev Interface for any contract that wants to support approveAndCall
974  *  from ERC1363 token contracts as defined in
975  *  https://eips.ethereum.org/EIPS/eip-1363
976  */
977 interface IERC1363Spender {
978     /*
979      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
980      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
981      */
982 
983     /**
984      * @notice Handle the approval of ERC1363 tokens
985      * @dev Any ERC1363 smart contract calls this function on the recipient
986      * after an `approve`. This function MAY throw to revert and reject the
987      * approval. Return of other than the magic value MUST result in the
988      * transaction being reverted.
989      * Note: the token contract address is always the message sender.
990      * @param owner address The address which called `approveAndCall` function
991      * @param value uint256 The amount of tokens to be spent
992      * @param data bytes Additional data with no specified format
993      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
994      *  unless throwing
995      */
996     function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
997 }
998 
999 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
1000 
1001 pragma solidity ^0.7.0;
1002 
1003 /**
1004  * @dev Library used to query support of an interface declared via {IERC165}.
1005  *
1006  * Note that these functions return the actual result of the query: they do not
1007  * `revert` if an interface is not supported. It is up to the caller to decide
1008  * what to do in these cases.
1009  */
1010 library ERC165Checker {
1011     // As per the EIP-165 spec, no interface should ever match 0xffffffff
1012     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
1013 
1014     /*
1015      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1016      */
1017     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1018 
1019     /**
1020      * @dev Returns true if `account` supports the {IERC165} interface,
1021      */
1022     function supportsERC165(address account) internal view returns (bool) {
1023         // Any contract that implements ERC165 must explicitly indicate support of
1024         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1025         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
1026             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1027     }
1028 
1029     /**
1030      * @dev Returns true if `account` supports the interface defined by
1031      * `interfaceId`. Support for {IERC165} itself is queried automatically.
1032      *
1033      * See {IERC165-supportsInterface}.
1034      */
1035     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
1036         // query support of both ERC165 as per the spec and support of _interfaceId
1037         return supportsERC165(account) &&
1038             _supportsERC165Interface(account, interfaceId);
1039     }
1040 
1041     /**
1042      * @dev Returns true if `account` supports all the interfaces defined in
1043      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1044      *
1045      * Batch-querying can lead to gas savings by skipping repeated checks for
1046      * {IERC165} support.
1047      *
1048      * See {IERC165-supportsInterface}.
1049      */
1050     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1051         // query support of ERC165 itself
1052         if (!supportsERC165(account)) {
1053             return false;
1054         }
1055 
1056         // query support of each interface in _interfaceIds
1057         for (uint256 i = 0; i < interfaceIds.length; i++) {
1058             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1059                 return false;
1060             }
1061         }
1062 
1063         // all interfaces supported
1064         return true;
1065     }
1066 
1067     /**
1068      * @notice Query if a contract implements an interface, does not check ERC165 support
1069      * @param account The address of the contract to query for support of an interface
1070      * @param interfaceId The interface identifier, as specified in ERC-165
1071      * @return true if the contract at account indicates support of the interface with
1072      * identifier interfaceId, false otherwise
1073      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1074      * the behavior of this method is undefined. This precondition can be checked
1075      * with {supportsERC165}.
1076      * Interface identification is specified in ERC-165.
1077      */
1078     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1079         // success determines whether the staticcall succeeded and result determines
1080         // whether the contract at account indicates support of _interfaceId
1081         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1082 
1083         return (success && result);
1084     }
1085 
1086     /**
1087      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1088      * @param account The address of the contract to query for support of an interface
1089      * @param interfaceId The interface identifier, as specified in ERC-165
1090      * @return success true if the STATICCALL succeeded, false otherwise
1091      * @return result true if the STATICCALL succeeded and the contract at account
1092      * indicates support of the interface with identifier interfaceId, false otherwise
1093      */
1094     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1095         private
1096         view
1097         returns (bool, bool)
1098     {
1099         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1100         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
1101         if (result.length < 32) return (false, false);
1102         return (success, abi.decode(result, (bool)));
1103     }
1104 }
1105 
1106 // File: @openzeppelin/contracts/introspection/ERC165.sol
1107 
1108 pragma solidity ^0.7.0;
1109 
1110 /**
1111  * @dev Implementation of the {IERC165} interface.
1112  *
1113  * Contracts may inherit from this and call {_registerInterface} to declare
1114  * their support of an interface.
1115  */
1116 contract ERC165 is IERC165 {
1117     /*
1118      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1119      */
1120     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1121 
1122     /**
1123      * @dev Mapping of interface ids to whether or not it's supported.
1124      */
1125     mapping(bytes4 => bool) private _supportedInterfaces;
1126 
1127     constructor () {
1128         // Derived contracts need only register support for their own interfaces,
1129         // we register support for ERC165 itself here
1130         _registerInterface(_INTERFACE_ID_ERC165);
1131     }
1132 
1133     /**
1134      * @dev See {IERC165-supportsInterface}.
1135      *
1136      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1137      */
1138     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1139         return _supportedInterfaces[interfaceId];
1140     }
1141 
1142     /**
1143      * @dev Registers the contract as an implementer of the interface defined by
1144      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1145      * registering its interface id is not required.
1146      *
1147      * See {IERC165-supportsInterface}.
1148      *
1149      * Requirements:
1150      *
1151      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1152      */
1153     function _registerInterface(bytes4 interfaceId) internal virtual {
1154         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1155         _supportedInterfaces[interfaceId] = true;
1156     }
1157 }
1158 
1159 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1160 
1161 pragma solidity ^0.7.0;
1162 
1163 /**
1164  * @title ERC1363
1165  * @author Vittorio Minacori (https://github.com/vittominacori)
1166  * @dev Implementation of an ERC1363 interface
1167  */
1168 contract ERC1363 is ERC20, IERC1363, ERC165 {
1169     using Address for address;
1170 
1171     /*
1172      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1173      * 0x4bbee2df ===
1174      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1175      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1176      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1177      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1178      */
1179     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1180 
1181     /*
1182      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1183      * 0xfb9ec8ce ===
1184      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1185      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1186      */
1187     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1188 
1189     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1190     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
1191     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1192 
1193     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1194     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
1195     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1196 
1197     /**
1198      * @param name Name of the token
1199      * @param symbol A symbol to be used as ticker
1200      */
1201     constructor (string memory name, string memory symbol) ERC20(name, symbol) {
1202         // register the supported interfaces to conform to ERC1363 via ERC165
1203         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1204         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1205     }
1206 
1207     /**
1208      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1209      * @param to The address to transfer to.
1210      * @param value The amount to be transferred.
1211      * @return A boolean that indicates if the operation was successful.
1212      */
1213     function transferAndCall(address to, uint256 value) public override returns (bool) {
1214         return transferAndCall(to, value, "");
1215     }
1216 
1217     /**
1218      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1219      * @param to The address to transfer to
1220      * @param value The amount to be transferred
1221      * @param data Additional data with no specified format
1222      * @return A boolean that indicates if the operation was successful.
1223      */
1224     function transferAndCall(address to, uint256 value, bytes memory data) public override returns (bool) {
1225         transfer(to, value);
1226         require(_checkAndCallTransfer(_msgSender(), to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1227         return true;
1228     }
1229 
1230     /**
1231      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1232      * @param from The address which you want to send tokens from
1233      * @param to The address which you want to transfer to
1234      * @param value The amount of tokens to be transferred
1235      * @return A boolean that indicates if the operation was successful.
1236      */
1237     function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
1238         return transferFromAndCall(from, to, value, "");
1239     }
1240 
1241     /**
1242      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1243      * @param from The address which you want to send tokens from
1244      * @param to The address which you want to transfer to
1245      * @param value The amount of tokens to be transferred
1246      * @param data Additional data with no specified format
1247      * @return A boolean that indicates if the operation was successful.
1248      */
1249     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public override returns (bool) {
1250         transferFrom(from, to, value);
1251         require(_checkAndCallTransfer(from, to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1252         return true;
1253     }
1254 
1255     /**
1256      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1257      * @param spender The address allowed to transfer to
1258      * @param value The amount allowed to be transferred
1259      * @return A boolean that indicates if the operation was successful.
1260      */
1261     function approveAndCall(address spender, uint256 value) public override returns (bool) {
1262         return approveAndCall(spender, value, "");
1263     }
1264 
1265     /**
1266      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1267      * @param spender The address allowed to transfer to.
1268      * @param value The amount allowed to be transferred.
1269      * @param data Additional data with no specified format.
1270      * @return A boolean that indicates if the operation was successful.
1271      */
1272     function approveAndCall(address spender, uint256 value, bytes memory data) public override returns (bool) {
1273         approve(spender, value);
1274         require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove reverts");
1275         return true;
1276     }
1277 
1278     /**
1279      * @dev Internal function to invoke `onTransferReceived` on a target address
1280      *  The call is not executed if the target address is not a contract
1281      * @param from address Representing the previous owner of the given token value
1282      * @param to address Target address that will receive the tokens
1283      * @param value uint256 The amount mount of tokens to be transferred
1284      * @param data bytes Optional data to send along with the call
1285      * @return whether the call correctly returned the expected magic value
1286      */
1287     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
1288         if (!to.isContract()) {
1289             return false;
1290         }
1291         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
1292             _msgSender(), from, value, data
1293         );
1294         return (retval == _ERC1363_RECEIVED);
1295     }
1296 
1297     /**
1298      * @dev Internal function to invoke `onApprovalReceived` on a target address
1299      *  The call is not executed if the target address is not a contract
1300      * @param spender address The address which will spend the funds
1301      * @param value uint256 The amount of tokens to be spent
1302      * @param data bytes Optional data to send along with the call
1303      * @return whether the call correctly returned the expected magic value
1304      */
1305     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
1306         if (!spender.isContract()) {
1307             return false;
1308         }
1309         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1310             _msgSender(), value, data
1311         );
1312         return (retval == _ERC1363_APPROVED);
1313     }
1314 }
1315 
1316 // File: @openzeppelin/contracts/access/Ownable.sol
1317 
1318 pragma solidity ^0.7.0;
1319 
1320 /**
1321  * @dev Contract module which provides a basic access control mechanism, where
1322  * there is an account (an owner) that can be granted exclusive access to
1323  * specific functions.
1324  *
1325  * By default, the owner account will be the one that deploys the contract. This
1326  * can later be changed with {transferOwnership}.
1327  *
1328  * This module is used through inheritance. It will make available the modifier
1329  * `onlyOwner`, which can be applied to your functions to restrict their use to
1330  * the owner.
1331  */
1332 contract Ownable is Context {
1333     address private _owner;
1334 
1335     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1336 
1337     /**
1338      * @dev Initializes the contract setting the deployer as the initial owner.
1339      */
1340     constructor () {
1341         address msgSender = _msgSender();
1342         _owner = msgSender;
1343         emit OwnershipTransferred(address(0), msgSender);
1344     }
1345 
1346     /**
1347      * @dev Returns the address of the current owner.
1348      */
1349     function owner() public view returns (address) {
1350         return _owner;
1351     }
1352 
1353     /**
1354      * @dev Throws if called by any account other than the owner.
1355      */
1356     modifier onlyOwner() {
1357         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1358         _;
1359     }
1360 
1361     /**
1362      * @dev Leaves the contract without owner. It will not be possible to call
1363      * `onlyOwner` functions anymore. Can only be called by the current owner.
1364      *
1365      * NOTE: Renouncing ownership will leave the contract without an owner,
1366      * thereby removing any functionality that is only available to the owner.
1367      */
1368     function renounceOwnership() public virtual onlyOwner {
1369         emit OwnershipTransferred(_owner, address(0));
1370         _owner = address(0);
1371     }
1372 
1373     /**
1374      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1375      * Can only be called by the current owner.
1376      */
1377     function transferOwnership(address newOwner) public virtual onlyOwner {
1378         require(newOwner != address(0), "Ownable: new owner is the zero address");
1379         emit OwnershipTransferred(_owner, newOwner);
1380         _owner = newOwner;
1381     }
1382 }
1383 
1384 // File: eth-token-recover/contracts/TokenRecover.sol
1385 
1386 pragma solidity ^0.7.0;
1387 
1388 /**
1389  * @title TokenRecover
1390  * @author Vittorio Minacori (https://github.com/vittominacori)
1391  * @dev Allow to recover any ERC20 sent into the contract for error
1392  */
1393 contract TokenRecover is Ownable {
1394 
1395     /**
1396      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1397      * @param tokenAddress The token contract address
1398      * @param tokenAmount Number of tokens to be sent
1399      */
1400     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1401         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1402     }
1403 }
1404 
1405 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
1406 
1407 pragma solidity ^0.7.0;
1408 
1409 /**
1410  * @dev Library for managing
1411  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1412  * types.
1413  *
1414  * Sets have the following properties:
1415  *
1416  * - Elements are added, removed, and checked for existence in constant time
1417  * (O(1)).
1418  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1419  *
1420  * ```
1421  * contract Example {
1422  *     // Add the library methods
1423  *     using EnumerableSet for EnumerableSet.AddressSet;
1424  *
1425  *     // Declare a set state variable
1426  *     EnumerableSet.AddressSet private mySet;
1427  * }
1428  * ```
1429  *
1430  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1431  * (`UintSet`) are supported.
1432  */
1433 library EnumerableSet {
1434     // To implement this library for multiple types with as little code
1435     // repetition as possible, we write it in terms of a generic Set type with
1436     // bytes32 values.
1437     // The Set implementation uses private functions, and user-facing
1438     // implementations (such as AddressSet) are just wrappers around the
1439     // underlying Set.
1440     // This means that we can only create new EnumerableSets for types that fit
1441     // in bytes32.
1442 
1443     struct Set {
1444         // Storage of set values
1445         bytes32[] _values;
1446 
1447         // Position of the value in the `values` array, plus 1 because index 0
1448         // means a value is not in the set.
1449         mapping (bytes32 => uint256) _indexes;
1450     }
1451 
1452     /**
1453      * @dev Add a value to a set. O(1).
1454      *
1455      * Returns true if the value was added to the set, that is if it was not
1456      * already present.
1457      */
1458     function _add(Set storage set, bytes32 value) private returns (bool) {
1459         if (!_contains(set, value)) {
1460             set._values.push(value);
1461             // The value is stored at length-1, but we add 1 to all indexes
1462             // and use 0 as a sentinel value
1463             set._indexes[value] = set._values.length;
1464             return true;
1465         } else {
1466             return false;
1467         }
1468     }
1469 
1470     /**
1471      * @dev Removes a value from a set. O(1).
1472      *
1473      * Returns true if the value was removed from the set, that is if it was
1474      * present.
1475      */
1476     function _remove(Set storage set, bytes32 value) private returns (bool) {
1477         // We read and store the value's index to prevent multiple reads from the same storage slot
1478         uint256 valueIndex = set._indexes[value];
1479 
1480         if (valueIndex != 0) { // Equivalent to contains(set, value)
1481             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1482             // the array, and then remove the last element (sometimes called as 'swap and pop').
1483             // This modifies the order of the array, as noted in {at}.
1484 
1485             uint256 toDeleteIndex = valueIndex - 1;
1486             uint256 lastIndex = set._values.length - 1;
1487 
1488             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1489             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1490 
1491             bytes32 lastvalue = set._values[lastIndex];
1492 
1493             // Move the last value to the index where the value to delete is
1494             set._values[toDeleteIndex] = lastvalue;
1495             // Update the index for the moved value
1496             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1497 
1498             // Delete the slot where the moved value was stored
1499             set._values.pop();
1500 
1501             // Delete the index for the deleted slot
1502             delete set._indexes[value];
1503 
1504             return true;
1505         } else {
1506             return false;
1507         }
1508     }
1509 
1510     /**
1511      * @dev Returns true if the value is in the set. O(1).
1512      */
1513     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1514         return set._indexes[value] != 0;
1515     }
1516 
1517     /**
1518      * @dev Returns the number of values on the set. O(1).
1519      */
1520     function _length(Set storage set) private view returns (uint256) {
1521         return set._values.length;
1522     }
1523 
1524    /**
1525     * @dev Returns the value stored at position `index` in the set. O(1).
1526     *
1527     * Note that there are no guarantees on the ordering of values inside the
1528     * array, and it may change when more values are added or removed.
1529     *
1530     * Requirements:
1531     *
1532     * - `index` must be strictly less than {length}.
1533     */
1534     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1535         require(set._values.length > index, "EnumerableSet: index out of bounds");
1536         return set._values[index];
1537     }
1538 
1539     // AddressSet
1540 
1541     struct AddressSet {
1542         Set _inner;
1543     }
1544 
1545     /**
1546      * @dev Add a value to a set. O(1).
1547      *
1548      * Returns true if the value was added to the set, that is if it was not
1549      * already present.
1550      */
1551     function add(AddressSet storage set, address value) internal returns (bool) {
1552         return _add(set._inner, bytes32(uint256(value)));
1553     }
1554 
1555     /**
1556      * @dev Removes a value from a set. O(1).
1557      *
1558      * Returns true if the value was removed from the set, that is if it was
1559      * present.
1560      */
1561     function remove(AddressSet storage set, address value) internal returns (bool) {
1562         return _remove(set._inner, bytes32(uint256(value)));
1563     }
1564 
1565     /**
1566      * @dev Returns true if the value is in the set. O(1).
1567      */
1568     function contains(AddressSet storage set, address value) internal view returns (bool) {
1569         return _contains(set._inner, bytes32(uint256(value)));
1570     }
1571 
1572     /**
1573      * @dev Returns the number of values in the set. O(1).
1574      */
1575     function length(AddressSet storage set) internal view returns (uint256) {
1576         return _length(set._inner);
1577     }
1578 
1579    /**
1580     * @dev Returns the value stored at position `index` in the set. O(1).
1581     *
1582     * Note that there are no guarantees on the ordering of values inside the
1583     * array, and it may change when more values are added or removed.
1584     *
1585     * Requirements:
1586     *
1587     * - `index` must be strictly less than {length}.
1588     */
1589     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1590         return address(uint256(_at(set._inner, index)));
1591     }
1592 
1593 
1594     // UintSet
1595 
1596     struct UintSet {
1597         Set _inner;
1598     }
1599 
1600     /**
1601      * @dev Add a value to a set. O(1).
1602      *
1603      * Returns true if the value was added to the set, that is if it was not
1604      * already present.
1605      */
1606     function add(UintSet storage set, uint256 value) internal returns (bool) {
1607         return _add(set._inner, bytes32(value));
1608     }
1609 
1610     /**
1611      * @dev Removes a value from a set. O(1).
1612      *
1613      * Returns true if the value was removed from the set, that is if it was
1614      * present.
1615      */
1616     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1617         return _remove(set._inner, bytes32(value));
1618     }
1619 
1620     /**
1621      * @dev Returns true if the value is in the set. O(1).
1622      */
1623     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1624         return _contains(set._inner, bytes32(value));
1625     }
1626 
1627     /**
1628      * @dev Returns the number of values on the set. O(1).
1629      */
1630     function length(UintSet storage set) internal view returns (uint256) {
1631         return _length(set._inner);
1632     }
1633 
1634    /**
1635     * @dev Returns the value stored at position `index` in the set. O(1).
1636     *
1637     * Note that there are no guarantees on the ordering of values inside the
1638     * array, and it may change when more values are added or removed.
1639     *
1640     * Requirements:
1641     *
1642     * - `index` must be strictly less than {length}.
1643     */
1644     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1645         return uint256(_at(set._inner, index));
1646     }
1647 }
1648 
1649 // File: @openzeppelin/contracts/access/AccessControl.sol
1650 
1651 pragma solidity ^0.7.0;
1652 
1653 /**
1654  * @dev Contract module that allows children to implement role-based access
1655  * control mechanisms.
1656  *
1657  * Roles are referred to by their `bytes32` identifier. These should be exposed
1658  * in the external API and be unique. The best way to achieve this is by
1659  * using `public constant` hash digests:
1660  *
1661  * ```
1662  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1663  * ```
1664  *
1665  * Roles can be used to represent a set of permissions. To restrict access to a
1666  * function call, use {hasRole}:
1667  *
1668  * ```
1669  * function foo() public {
1670  *     require(hasRole(MY_ROLE, msg.sender));
1671  *     ...
1672  * }
1673  * ```
1674  *
1675  * Roles can be granted and revoked dynamically via the {grantRole} and
1676  * {revokeRole} functions. Each role has an associated admin role, and only
1677  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1678  *
1679  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1680  * that only accounts with this role will be able to grant or revoke other
1681  * roles. More complex role relationships can be created by using
1682  * {_setRoleAdmin}.
1683  *
1684  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1685  * grant and revoke this role. Extra precautions should be taken to secure
1686  * accounts that have been granted it.
1687  */
1688 abstract contract AccessControl is Context {
1689     using EnumerableSet for EnumerableSet.AddressSet;
1690     using Address for address;
1691 
1692     struct RoleData {
1693         EnumerableSet.AddressSet members;
1694         bytes32 adminRole;
1695     }
1696 
1697     mapping (bytes32 => RoleData) private _roles;
1698 
1699     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1700 
1701     /**
1702      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1703      *
1704      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1705      * {RoleAdminChanged} not being emitted signaling this.
1706      *
1707      * _Available since v3.1._
1708      */
1709     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1710 
1711     /**
1712      * @dev Emitted when `account` is granted `role`.
1713      *
1714      * `sender` is the account that originated the contract call, an admin role
1715      * bearer except when using {_setupRole}.
1716      */
1717     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1718 
1719     /**
1720      * @dev Emitted when `account` is revoked `role`.
1721      *
1722      * `sender` is the account that originated the contract call:
1723      *   - if using `revokeRole`, it is the admin role bearer
1724      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1725      */
1726     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1727 
1728     /**
1729      * @dev Returns `true` if `account` has been granted `role`.
1730      */
1731     function hasRole(bytes32 role, address account) public view returns (bool) {
1732         return _roles[role].members.contains(account);
1733     }
1734 
1735     /**
1736      * @dev Returns the number of accounts that have `role`. Can be used
1737      * together with {getRoleMember} to enumerate all bearers of a role.
1738      */
1739     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1740         return _roles[role].members.length();
1741     }
1742 
1743     /**
1744      * @dev Returns one of the accounts that have `role`. `index` must be a
1745      * value between 0 and {getRoleMemberCount}, non-inclusive.
1746      *
1747      * Role bearers are not sorted in any particular way, and their ordering may
1748      * change at any point.
1749      *
1750      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1751      * you perform all queries on the same block. See the following
1752      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1753      * for more information.
1754      */
1755     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1756         return _roles[role].members.at(index);
1757     }
1758 
1759     /**
1760      * @dev Returns the admin role that controls `role`. See {grantRole} and
1761      * {revokeRole}.
1762      *
1763      * To change a role's admin, use {_setRoleAdmin}.
1764      */
1765     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1766         return _roles[role].adminRole;
1767     }
1768 
1769     /**
1770      * @dev Grants `role` to `account`.
1771      *
1772      * If `account` had not been already granted `role`, emits a {RoleGranted}
1773      * event.
1774      *
1775      * Requirements:
1776      *
1777      * - the caller must have ``role``'s admin role.
1778      */
1779     function grantRole(bytes32 role, address account) public virtual {
1780         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1781 
1782         _grantRole(role, account);
1783     }
1784 
1785     /**
1786      * @dev Revokes `role` from `account`.
1787      *
1788      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1789      *
1790      * Requirements:
1791      *
1792      * - the caller must have ``role``'s admin role.
1793      */
1794     function revokeRole(bytes32 role, address account) public virtual {
1795         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1796 
1797         _revokeRole(role, account);
1798     }
1799 
1800     /**
1801      * @dev Revokes `role` from the calling account.
1802      *
1803      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1804      * purpose is to provide a mechanism for accounts to lose their privileges
1805      * if they are compromised (such as when a trusted device is misplaced).
1806      *
1807      * If the calling account had been granted `role`, emits a {RoleRevoked}
1808      * event.
1809      *
1810      * Requirements:
1811      *
1812      * - the caller must be `account`.
1813      */
1814     function renounceRole(bytes32 role, address account) public virtual {
1815         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1816 
1817         _revokeRole(role, account);
1818     }
1819 
1820     /**
1821      * @dev Grants `role` to `account`.
1822      *
1823      * If `account` had not been already granted `role`, emits a {RoleGranted}
1824      * event. Note that unlike {grantRole}, this function doesn't perform any
1825      * checks on the calling account.
1826      *
1827      * [WARNING]
1828      * ====
1829      * This function should only be called from the constructor when setting
1830      * up the initial roles for the system.
1831      *
1832      * Using this function in any other way is effectively circumventing the admin
1833      * system imposed by {AccessControl}.
1834      * ====
1835      */
1836     function _setupRole(bytes32 role, address account) internal virtual {
1837         _grantRole(role, account);
1838     }
1839 
1840     /**
1841      * @dev Sets `adminRole` as ``role``'s admin role.
1842      *
1843      * Emits a {RoleAdminChanged} event.
1844      */
1845     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1846         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1847         _roles[role].adminRole = adminRole;
1848     }
1849 
1850     function _grantRole(bytes32 role, address account) private {
1851         if (_roles[role].members.add(account)) {
1852             emit RoleGranted(role, account, _msgSender());
1853         }
1854     }
1855 
1856     function _revokeRole(bytes32 role, address account) private {
1857         if (_roles[role].members.remove(account)) {
1858             emit RoleRevoked(role, account, _msgSender());
1859         }
1860     }
1861 }
1862 
1863 // File: @vittominacori/erc20-token/contracts/access/Roles.sol
1864 
1865 pragma solidity ^0.7.0;
1866 
1867 contract Roles is AccessControl {
1868 
1869     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1870     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
1871 
1872     constructor () {
1873         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1874         _setupRole(MINTER_ROLE, _msgSender());
1875         _setupRole(OPERATOR_ROLE, _msgSender());
1876     }
1877 
1878     modifier onlyMinter() {
1879         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1880         _;
1881     }
1882 
1883     modifier onlyOperator() {
1884         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
1885         _;
1886     }
1887 }
1888 
1889 // File: @vittominacori/erc20-token/contracts/ERC20Base.sol
1890 
1891 pragma solidity ^0.7.0;
1892 
1893 /**
1894  * @title ERC20Base
1895  * @author Vittorio Minacori (https://github.com/vittominacori)
1896  * @dev Implementation of the ERC20Base
1897  */
1898 contract ERC20Base is ERC20Capped, ERC20Burnable, ERC1363, Roles, TokenRecover {
1899 
1900     // indicates if minting is finished
1901     bool private _mintingFinished = false;
1902 
1903     // indicates if transfer is enabled
1904     bool private _transferEnabled = false;
1905 
1906     /**
1907      * @dev Emitted during finish minting
1908      */
1909     event MintFinished();
1910 
1911     /**
1912      * @dev Emitted during transfer enabling
1913      */
1914     event TransferEnabled();
1915 
1916     /**
1917      * @dev Tokens can be minted only before minting finished.
1918      */
1919     modifier canMint() {
1920         require(!_mintingFinished, "ERC20Base: minting is finished");
1921         _;
1922     }
1923 
1924     /**
1925      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1926      */
1927     modifier canTransfer(address from) {
1928         require(
1929             _transferEnabled || hasRole(OPERATOR_ROLE, from),
1930             "ERC20Base: transfer is not enabled or from does not have the OPERATOR role"
1931         );
1932         _;
1933     }
1934 
1935     /**
1936      * @param name Name of the token
1937      * @param symbol A symbol to be used as ticker
1938      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1939      * @param cap Maximum number of tokens mintable
1940      * @param initialSupply Initial token supply
1941      * @param transferEnabled If transfer is enabled on token creation
1942      * @param mintingFinished If minting is finished after token creation
1943      */
1944     constructor(
1945         string memory name,
1946         string memory symbol,
1947         uint8 decimals,
1948         uint256 cap,
1949         uint256 initialSupply,
1950         bool transferEnabled,
1951         bool mintingFinished
1952     )
1953         ERC20Capped(cap)
1954         ERC1363(name, symbol)
1955     {
1956         require(
1957             mintingFinished == false || cap == initialSupply,
1958             "ERC20Base: if finish minting, cap must be equal to initialSupply"
1959         );
1960 
1961         _setupDecimals(decimals);
1962 
1963         if (initialSupply > 0) {
1964             _mint(owner(), initialSupply);
1965         }
1966 
1967         if (mintingFinished) {
1968             finishMinting();
1969         }
1970 
1971         if (transferEnabled) {
1972             enableTransfer();
1973         }
1974     }
1975 
1976     /**
1977      * @return if minting is finished or not.
1978      */
1979     function mintingFinished() public view returns (bool) {
1980         return _mintingFinished;
1981     }
1982 
1983     /**
1984      * @return if transfer is enabled or not.
1985      */
1986     function transferEnabled() public view returns (bool) {
1987         return _transferEnabled;
1988     }
1989 
1990     /**
1991      * @dev Function to mint tokens.
1992      * @param to The address that will receive the minted tokens
1993      * @param value The amount of tokens to mint
1994      */
1995     function mint(address to, uint256 value) public canMint onlyMinter {
1996         _mint(to, value);
1997     }
1998 
1999     /**
2000      * @dev Transfer tokens to a specified address.
2001      * @param to The address to transfer to
2002      * @param value The amount to be transferred
2003      * @return A boolean that indicates if the operation was successful.
2004      */
2005     function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(_msgSender()) returns (bool) {
2006         return super.transfer(to, value);
2007     }
2008 
2009     /**
2010      * @dev Transfer tokens from one address to another.
2011      * @param from The address which you want to send tokens from
2012      * @param to The address which you want to transfer to
2013      * @param value the amount of tokens to be transferred
2014      * @return A boolean that indicates if the operation was successful.
2015      */
2016     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
2017         return super.transferFrom(from, to, value);
2018     }
2019 
2020     /**
2021      * @dev Function to stop minting new tokens.
2022      */
2023     function finishMinting() public canMint onlyOwner {
2024         _mintingFinished = true;
2025 
2026         emit MintFinished();
2027     }
2028 
2029     /**
2030      * @dev Function to enable transfers.
2031      */
2032     function enableTransfer() public onlyOwner {
2033         _transferEnabled = true;
2034 
2035         emit TransferEnabled();
2036     }
2037 
2038     /**
2039      * @dev See {ERC20-_beforeTokenTransfer}.
2040      */
2041     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
2042         super._beforeTokenTransfer(from, to, amount);
2043     }
2044 }
2045 
2046 // File: contracts/BaseToken.sol
2047 
2048 pragma solidity ^0.7.1;
2049 
2050 /**
2051  * @title BaseToken
2052  * @author Vittorio Minacori (https://github.com/vittominacori)
2053  * @dev Implementation of the BaseToken
2054  */
2055 contract BaseToken is ERC20Base {
2056 
2057   string private constant _GENERATOR = "https://vittominacori.github.io/erc20-generator";
2058   string private constant _VERSION = "v3.2.0";
2059 
2060   constructor (
2061     string memory name,
2062     string memory symbol,
2063     uint8 decimals,
2064     uint256 cap,
2065     uint256 initialSupply,
2066     bool transferEnabled,
2067     bool mintingFinished
2068   ) ERC20Base(name, symbol, decimals, cap, initialSupply, transferEnabled, mintingFinished) {}
2069 
2070   /**
2071    * @dev Returns the token generator tool.
2072    */
2073   function generator() public pure returns (string memory) {
2074     return _GENERATOR;
2075   }
2076 
2077   /**
2078    * @dev Returns the token generator version.
2079    */
2080   function version() public pure returns (string memory) {
2081     return _VERSION;
2082   }
2083 }