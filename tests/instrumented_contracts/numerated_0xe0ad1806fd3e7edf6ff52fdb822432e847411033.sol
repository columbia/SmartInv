1 // SPDX-License-Identifier: MIT
2 
3 /*
4 >OnX.finance Token Contract [ONX]
5 */
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor () internal {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 }
93 
94 /**
95  * @dev Interface of the ERC20 standard as defined in the EIP.
96  */
97 interface IERC20 {
98     /**
99      * @dev Returns the amount of tokens in existence.
100      */
101     function totalSupply() external view returns (uint256);
102 
103     /**
104      * @dev Returns the amount of tokens owned by `account`.
105      */
106     function balanceOf(address account) external view returns (uint256);
107 
108     /**
109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transfer(address recipient, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Returns the remaining number of tokens that `spender` will be
119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
120      * zero by default.
121      *
122      * This value changes when {approve} or {transferFrom} are called.
123      */
124     function allowance(address owner, address spender) external view returns (uint256);
125 
126     /**
127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
132      * that someone may use both the old and the new allowance by unfortunate
133      * transaction ordering. One possible solution to mitigate this race
134      * condition is to first reduce the spender's allowance to 0 and set the
135      * desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address spender, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
144      * allowance mechanism. `amount` is then deducted from the caller's
145      * allowance.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Emitted when `value` tokens are moved from one account (`from`) to
155      * another (`to`).
156      *
157      * Note that `value` may be zero.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 value);
160 
161     /**
162      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
163      * a call to {approve}. `value` is the new allowance.
164      */
165     event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 /**
169  * @dev Wrappers over Solidity's arithmetic operations with added overflow
170  * checks.
171  *
172  * Arithmetic operations in Solidity wrap on overflow. This can easily result
173  * in bugs, because programmers usually assume that an overflow raises an
174  * error, which is the standard behavior in high level programming languages.
175  * `SafeMath` restores this intuition by reverting the transaction when an
176  * operation overflows.
177  *
178  * Using this library instead of the unchecked operations eliminates an entire
179  * class of bugs, so it's recommended to use it always.
180  */
181 library SafeMath {
182     /**
183      * @dev Returns the addition of two unsigned integers, reverting on
184      * overflow.
185      *
186      * Counterpart to Solidity's `+` operator.
187      *
188      * Requirements:
189      *
190      * - Addition cannot overflow.
191      */
192     function add(uint256 a, uint256 b) internal pure returns (uint256) {
193         uint256 c = a + b;
194         require(c >= a, "SafeMath: addition overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the subtraction of two unsigned integers, reverting on
201      * overflow (when the result is negative).
202      *
203      * Counterpart to Solidity's `-` operator.
204      *
205      * Requirements:
206      *
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         return sub(a, b, "SafeMath: subtraction overflow");
211     }
212 
213     /**
214      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
215      * overflow (when the result is negative).
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
220      *
221      * - Subtraction cannot overflow.
222      */
223     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b <= a, errorMessage);
225         uint256 c = a - b;
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the multiplication of two unsigned integers, reverting on
232      * overflow.
233      *
234      * Counterpart to Solidity's `*` operator.
235      *
236      * Requirements:
237      *
238      * - Multiplication cannot overflow.
239      */
240     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
241         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
242         // benefit is lost if 'b' is also tested.
243         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
244         if (a == 0) {
245             return 0;
246         }
247 
248         uint256 c = a * b;
249         require(c / a == b, "SafeMath: multiplication overflow");
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers. Reverts on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator. Note: this function uses a
259      * `revert` opcode (which leaves remaining gas untouched) while Solidity
260      * uses an invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function div(uint256 a, uint256 b) internal pure returns (uint256) {
267         return div(a, b, "SafeMath: division by zero");
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator. Note: this function uses a
275      * `revert` opcode (which leaves remaining gas untouched) while Solidity
276      * uses an invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         require(b > 0, errorMessage);
284         uint256 c = a / b;
285         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
286 
287         return c;
288     }
289 
290     /**
291      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
292      * Reverts when dividing by zero.
293      *
294      * Counterpart to Solidity's `%` operator. This function uses a `revert`
295      * opcode (which leaves remaining gas untouched) while Solidity uses an
296      * invalid opcode to revert (consuming all remaining gas).
297      *
298      * Requirements:
299      *
300      * - The divisor cannot be zero.
301      */
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         return mod(a, b, "SafeMath: modulo by zero");
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts with custom message when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
319         require(b != 0, errorMessage);
320         return a % b;
321     }
322 }
323 
324 /**
325  * @dev Collection of functions related to the address type
326  */
327 library Address {
328     /**
329      * @dev Returns true if `account` is a contract.
330      *
331      * [IMPORTANT]
332      * ====
333      * It is unsafe to assume that an address for which this function returns
334      * false is an externally-owned account (EOA) and not a contract.
335      *
336      * Among others, `isContract` will return false for the following
337      * types of addresses:
338      *
339      *  - an externally-owned account
340      *  - a contract in construction
341      *  - an address where a contract will be created
342      *  - an address where a contract lived, but was destroyed
343      * ====
344      */
345     function isContract(address account) internal view returns (bool) {
346         // This method relies on extcodesize, which returns 0 for contracts in
347         // construction, since the code is only stored at the end of the
348         // constructor execution.
349 
350         uint256 size;
351         // solhint-disable-next-line no-inline-assembly
352         assembly { size := extcodesize(account) }
353         return size > 0;
354     }
355 
356     /**
357      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
358      * `recipient`, forwarding all available gas and reverting on errors.
359      *
360      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
361      * of certain opcodes, possibly making contracts go over the 2300 gas limit
362      * imposed by `transfer`, making them unable to receive funds via
363      * `transfer`. {sendValue} removes this limitation.
364      *
365      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
366      *
367      * IMPORTANT: because control is transferred to `recipient`, care must be
368      * taken to not create reentrancy vulnerabilities. Consider using
369      * {ReentrancyGuard} or the
370      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
371      */
372     function sendValue(address payable recipient, uint256 amount) internal {
373         require(address(this).balance >= amount, "Address: insufficient balance");
374 
375         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
376         (bool success, ) = recipient.call{ value: amount }("");
377         require(success, "Address: unable to send value, recipient may have reverted");
378     }
379 
380     /**
381      * @dev Performs a Solidity function call using a low level `call`. A
382      * plain`call` is an unsafe replacement for a function call: use this
383      * function instead.
384      *
385      * If `target` reverts with a revert reason, it is bubbled up by this
386      * function (like regular Solidity function calls).
387      *
388      * Returns the raw returned data. To convert to the expected return value,
389      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
390      *
391      * Requirements:
392      *
393      * - `target` must be a contract.
394      * - calling `target` with `data` must not revert.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
399       return functionCall(target, data, "Address: low-level call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
404      * `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
409         return functionCallWithValue(target, data, 0, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but also transferring `value` wei to `target`.
415      *
416      * Requirements:
417      *
418      * - the calling contract must have an ETH balance of at least `value`.
419      * - the called Solidity function must be `payable`.
420      *
421      * _Available since v3.1._
422      */
423     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429      * with `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
434         require(address(this).balance >= value, "Address: insufficient balance for call");
435         require(isContract(target), "Address: call to non-contract");
436 
437         // solhint-disable-next-line avoid-low-level-calls
438         (bool success, bytes memory returndata) = target.call{ value: value }(data);
439         return _verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
449         return functionStaticCall(target, data, "Address: low-level static call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
459         require(isContract(target), "Address: static call to non-contract");
460 
461         // solhint-disable-next-line avoid-low-level-calls
462         (bool success, bytes memory returndata) = target.staticcall(data);
463         return _verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a delegate call.
469      *
470      * _Available since v3.3._
471      */
472     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
473         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.3._
481      */
482     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
483         require(isContract(target), "Address: delegate call to non-contract");
484 
485         // solhint-disable-next-line avoid-low-level-calls
486         (bool success, bytes memory returndata) = target.delegatecall(data);
487         return _verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
491         if (success) {
492             return returndata;
493         } else {
494             // Look for revert reason and bubble it up if present
495             if (returndata.length > 0) {
496                 // The easiest way to bubble the revert reason is using memory via assembly
497 
498                 // solhint-disable-next-line no-inline-assembly
499                 assembly {
500                     let returndata_size := mload(returndata)
501                     revert(add(32, returndata), returndata_size)
502                 }
503             } else {
504                 revert(errorMessage);
505             }
506         }
507     }
508 }
509 
510 /**
511  * @dev Implementation of the {IERC20} interface.
512  *
513  * This implementation is agnostic to the way tokens are created. This means
514  * that a supply mechanism has to be added in a derived contract using {_mint}.
515  * For a generic mechanism see {ERC20PresetMinterPauser}.
516  *
517  * TIP: For a detailed writeup see our guide
518  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
519  * to implement supply mechanisms].
520  *
521  * We have followed general OpenZeppelin guidelines: functions revert instead
522  * of returning `false` on failure. This behavior is nonetheless conventional
523  * and does not conflict with the expectations of ERC20 applications.
524  *
525  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
526  * This allows applications to reconstruct the allowance for all accounts just
527  * by listening to said events. Other implementations of the EIP may not emit
528  * these events, as it isn't required by the specification.
529  *
530  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
531  * functions have been added to mitigate the well-known issues around setting
532  * allowances. See {IERC20-approve}.
533  */
534 contract ERC20 is Context, IERC20, Ownable {
535     using SafeMath for uint256;
536 
537     mapping (address => uint256) private _balances;
538 
539     mapping (address => mapping (address => uint256)) private _allowances;
540 
541     uint256 private _totalSupply;
542 
543     string private _name;
544     string private _symbol;
545     uint8 private _decimals;
546 
547     /**
548      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
549      * a default value of 18.
550      *
551      * To select a different value for {decimals}, use {_setupDecimals}.
552      *
553      * All three of these values are immutable: they can only be set once during
554      * construction.
555      */
556     constructor (string memory name_, string memory symbol_) public {
557         _name = name_;
558         _symbol = symbol_;
559         _decimals = 18;
560     }
561 
562     /**
563      * @dev Returns the name of the token.
564      */
565     function name() public view returns (string memory) {
566         return _name;
567     }
568 
569     /**
570      * @dev Returns the symbol of the token, usually a shorter version of the
571      * name.
572      */
573     function symbol() public view returns (string memory) {
574         return _symbol;
575     }
576 
577     /**
578      * @dev Returns the number of decimals used to get its user representation.
579      * For example, if `decimals` equals `2`, a balance of `505` tokens should
580      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
581      *
582      * Tokens usually opt for a value of 18, imitating the relationship between
583      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
584      * called.
585      *
586      * NOTE: This information is only used for _display_ purposes: it in
587      * no way affects any of the arithmetic of the contract, including
588      * {IERC20-balanceOf} and {IERC20-transfer}.
589      */
590     function decimals() public view returns (uint8) {
591         return _decimals;
592     }
593 
594     /**
595      * @dev See {IERC20-totalSupply}.
596      */
597     function totalSupply() public view override returns (uint256) {
598         return _totalSupply;
599     }
600 
601     /**
602      * @dev See {IERC20-balanceOf}.
603      */
604     function balanceOf(address account) public view override returns (uint256) {
605         return _balances[account];
606     }
607 
608     /**
609      * @dev See {IERC20-transfer}.
610      *
611      * Requirements:
612      *
613      * - `recipient` cannot be the zero address.
614      * - the caller must have a balance of at least `amount`.
615      */
616     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
617         _transfer(_msgSender(), recipient, amount);
618         return true;
619     }
620 
621     /**
622      * @dev See {IERC20-allowance}.
623      */
624     function allowance(address owner, address spender) public view virtual override returns (uint256) {
625         return _allowances[owner][spender];
626     }
627 
628     /**
629      * @dev See {IERC20-approve}.
630      *
631      * Requirements:
632      *
633      * - `spender` cannot be the zero address.
634      */
635     function approve(address spender, uint256 amount) public virtual override returns (bool) {
636         _approve(_msgSender(), spender, amount);
637         return true;
638     }
639 
640     /**
641      * @dev See {IERC20-transferFrom}.
642      *
643      * Emits an {Approval} event indicating the updated allowance. This is not
644      * required by the EIP. See the note at the beginning of {ERC20}.
645      *
646      * Requirements:
647      *
648      * - `sender` and `recipient` cannot be the zero address.
649      * - `sender` must have a balance of at least `amount`.
650      * - the caller must have allowance for ``sender``'s tokens of at least
651      * `amount`.
652      */
653     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
654         _transfer(sender, recipient, amount);
655         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
656         return true;
657     }
658 
659     /**
660      * @dev Atomically increases the allowance granted to `spender` by the caller.
661      *
662      * This is an alternative to {approve} that can be used as a mitigation for
663      * problems described in {IERC20-approve}.
664      *
665      * Emits an {Approval} event indicating the updated allowance.
666      *
667      * Requirements:
668      *
669      * - `spender` cannot be the zero address.
670      */
671     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
672         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
673         return true;
674     }
675 
676     /**
677      * @dev Atomically decreases the allowance granted to `spender` by the caller.
678      *
679      * This is an alternative to {approve} that can be used as a mitigation for
680      * problems described in {IERC20-approve}.
681      *
682      * Emits an {Approval} event indicating the updated allowance.
683      *
684      * Requirements:
685      *
686      * - `spender` cannot be the zero address.
687      * - `spender` must have allowance for the caller of at least
688      * `subtractedValue`.
689      */
690     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
691         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
692         return true;
693     }
694 
695     /**
696      * @dev Moves tokens `amount` from `sender` to `recipient`.
697      *
698      * This is internal function is equivalent to {transfer}, and can be used to
699      * e.g. implement automatic token fees, slashing mechanisms, etc.
700      *
701      * Emits a {Transfer} event.
702      *
703      * Requirements:
704      *
705      * - `sender` cannot be the zero address.
706      * - `recipient` cannot be the zero address.
707      * - `sender` must have a balance of at least `amount`.
708      */
709     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
710         require(sender != address(0), "ERC20: transfer from the zero address");
711         require(recipient != address(0), "ERC20: transfer to the zero address");
712 
713         _beforeTokenTransfer(sender, recipient, amount);
714 
715         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
716         _balances[recipient] = _balances[recipient].add(amount);
717         emit Transfer(sender, recipient, amount);
718     }
719 
720     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
721      * the total supply.
722      *
723      * Emits a {Transfer} event with `from` set to the zero address.
724      *
725      * Requirements:
726      *
727      * - `to` cannot be the zero address.
728      */
729     function _mint(address account, uint256 amount) internal virtual {
730         require(account != address(0), "ERC20: mint to the zero address");
731 
732         _beforeTokenTransfer(address(0), account, amount);
733 
734         _totalSupply = _totalSupply.add(amount);
735         _balances[account] = _balances[account].add(amount);
736         emit Transfer(address(0), account, amount);
737     }
738 
739     /**
740      * @dev Destroys `amount` tokens from `account`, reducing the
741      * total supply.
742      *
743      * Emits a {Transfer} event with `to` set to the zero address.
744      *
745      * Requirements:
746      *
747      * - `account` cannot be the zero address.
748      * - `account` must have at least `amount` tokens.
749      */
750     function _burn(address account, uint256 amount) internal virtual {
751         require(account != address(0), "ERC20: burn from the zero address");
752 
753         _beforeTokenTransfer(account, address(0), amount);
754 
755         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
756         _totalSupply = _totalSupply.sub(amount);
757         emit Transfer(account, address(0), amount);
758     }
759 
760     /**
761      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
762      *
763      * This internal function is equivalent to `approve`, and can be used to
764      * e.g. set automatic allowances for certain subsystems, etc.
765      *
766      * Emits an {Approval} event.
767      *
768      * Requirements:
769      *
770      * - `owner` cannot be the zero address.
771      * - `spender` cannot be the zero address.
772      */
773     function _approve(address owner, address spender, uint256 amount) internal virtual {
774         require(owner != address(0), "ERC20: approve from the zero address");
775         require(spender != address(0), "ERC20: approve to the zero address");
776 
777         _allowances[owner][spender] = amount;
778         emit Approval(owner, spender, amount);
779     }
780 
781     /**
782      * @dev Sets {decimals} to a value other than the default one of 18.
783      *
784      * WARNING: This function should only be called from the constructor. Most
785      * applications that interact with token contracts will not expect
786      * {decimals} to ever change, and may work incorrectly if it does.
787      */
788     function _setupDecimals(uint8 decimals_) internal {
789         _decimals = decimals_;
790     }
791 
792     /**
793      * @dev Hook that is called before any transfer of tokens. This includes
794      * minting and burning.
795      *
796      * Calling conditions:
797      *
798      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
799      * will be to transferred to `to`.
800      * - when `from` is zero, `amount` tokens will be minted for `to`.
801      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
802      * - `from` and `to` are never both zero.
803      *
804      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
805      */
806     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
807 }
808 
809 contract ONXToken is ERC20('OnX.finance', 'ONX') {
810 
811     address public exchangeAirdropCampaign;
812     address public treasuryAddress;
813 
814     // mints 400,000 OnX for Exchange airdrop & 275,685 for Development Fund >
815     constructor (address _exchange, address _treasury) public {
816 
817         exchangeAirdropCampaign = _exchange;
818         treasuryAddress = _treasury;
819 
820         mintTo(exchangeAirdropCampaign, 400000000000000000000000);
821         mintTo(treasuryAddress, 275685000000000000000000);
822     }
823 
824     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner.
825     function mintTo(address _to, uint256 _amount) public onlyOwner {
826         _mint(_to, _amount);
827     }
828 
829 }