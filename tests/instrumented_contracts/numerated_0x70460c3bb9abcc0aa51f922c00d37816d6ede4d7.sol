1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.6.12;
4 
5 
6 // 
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
28 // 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor () internal {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(_owner == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         emit OwnershipTransferred(_owner, newOwner);
89         _owner = newOwner;
90     }
91 }
92 
93 // 
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
168 // 
169 /**
170  * @dev Wrappers over Solidity's arithmetic operations with added overflow
171  * checks.
172  *
173  * Arithmetic operations in Solidity wrap on overflow. This can easily result
174  * in bugs, because programmers usually assume that an overflow raises an
175  * error, which is the standard behavior in high level programming languages.
176  * `SafeMath` restores this intuition by reverting the transaction when an
177  * operation overflows.
178  *
179  * Using this library instead of the unchecked operations eliminates an entire
180  * class of bugs, so it's recommended to use it always.
181  */
182 library SafeMath {
183     /**
184      * @dev Returns the addition of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `+` operator.
188      *
189      * Requirements:
190      *
191      * - Addition cannot overflow.
192      */
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         require(c >= a, "SafeMath: addition overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         return sub(a, b, "SafeMath: subtraction overflow");
212     }
213 
214     /**
215      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
216      * overflow (when the result is negative).
217      *
218      * Counterpart to Solidity's `-` operator.
219      *
220      * Requirements:
221      *
222      * - Subtraction cannot overflow.
223      */
224     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b <= a, errorMessage);
226         uint256 c = a - b;
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, reverting on
233      * overflow.
234      *
235      * Counterpart to Solidity's `*` operator.
236      *
237      * Requirements:
238      *
239      * - Multiplication cannot overflow.
240      */
241     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
242         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
243         // benefit is lost if 'b' is also tested.
244         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
245         if (a == 0) {
246             return 0;
247         }
248 
249         uint256 c = a * b;
250         require(c / a == b, "SafeMath: multiplication overflow");
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the integer division of two unsigned integers. Reverts on
257      * division by zero. The result is rounded towards zero.
258      *
259      * Counterpart to Solidity's `/` operator. Note: this function uses a
260      * `revert` opcode (which leaves remaining gas untouched) while Solidity
261      * uses an invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function div(uint256 a, uint256 b) internal pure returns (uint256) {
268         return div(a, b, "SafeMath: division by zero");
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b > 0, errorMessage);
285         uint256 c = a / b;
286         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
304         return mod(a, b, "SafeMath: modulo by zero");
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * Reverts with custom message when dividing by zero.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b != 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 // 
326 /**
327  * @dev Collection of functions related to the address type
328  */
329 library Address {
330     /**
331      * @dev Returns true if `account` is a contract.
332      *
333      * [IMPORTANT]
334      * ====
335      * It is unsafe to assume that an address for which this function returns
336      * false is an externally-owned account (EOA) and not a contract.
337      *
338      * Among others, `isContract` will return false for the following
339      * types of addresses:
340      *
341      *  - an externally-owned account
342      *  - a contract in construction
343      *  - an address where a contract will be created
344      *  - an address where a contract lived, but was destroyed
345      * ====
346      */
347     function isContract(address account) internal view returns (bool) {
348         // This method relies in extcodesize, which returns 0 for contracts in
349         // construction, since the code is only stored at the end of the
350         // constructor execution.
351 
352         uint256 size;
353         // solhint-disable-next-line no-inline-assembly
354         assembly { size := extcodesize(account) }
355         return size > 0;
356     }
357 
358     /**
359      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
360      * `recipient`, forwarding all available gas and reverting on errors.
361      *
362      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
363      * of certain opcodes, possibly making contracts go over the 2300 gas limit
364      * imposed by `transfer`, making them unable to receive funds via
365      * `transfer`. {sendValue} removes this limitation.
366      *
367      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
368      *
369      * IMPORTANT: because control is transferred to `recipient`, care must be
370      * taken to not create reentrancy vulnerabilities. Consider using
371      * {ReentrancyGuard} or the
372      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
373      */
374     function sendValue(address payable recipient, uint256 amount) internal {
375         require(address(this).balance >= amount, "Address: insufficient balance");
376 
377         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
378         (bool success, ) = recipient.call{ value: amount }("");
379         require(success, "Address: unable to send value, recipient may have reverted");
380     }
381 
382     /**
383      * @dev Performs a Solidity function call using a low level `call`. A
384      * plain`call` is an unsafe replacement for a function call: use this
385      * function instead.
386      *
387      * If `target` reverts with a revert reason, it is bubbled up by this
388      * function (like regular Solidity function calls).
389      *
390      * Returns the raw returned data. To convert to the expected return value,
391      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
392      *
393      * Requirements:
394      *
395      * - `target` must be a contract.
396      * - calling `target` with `data` must not revert.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
401       return functionCall(target, data, "Address: low-level call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
406      * `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
411         return _functionCallWithValue(target, data, 0, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but also transferring `value` wei to `target`.
417      *
418      * Requirements:
419      *
420      * - the calling contract must have an ETH balance of at least `value`.
421      * - the called Solidity function must be `payable`.
422      *
423      * _Available since v3.1._
424      */
425     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
426         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
431      * with `errorMessage` as a fallback revert reason when `target` reverts.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
436         require(address(this).balance >= value, "Address: insufficient balance for call");
437         return _functionCallWithValue(target, data, value, errorMessage);
438     }
439 
440     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
441         require(isContract(target), "Address: call to non-contract");
442 
443         // solhint-disable-next-line avoid-low-level-calls
444         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 // solhint-disable-next-line no-inline-assembly
453                 assembly {
454                     let returndata_size := mload(returndata)
455                     revert(add(32, returndata), returndata_size)
456                 }
457             } else {
458                 revert(errorMessage);
459             }
460         }
461     }
462 }
463 
464 // 
465 /**
466  * @dev Implementation of the {IERC20} interface.
467  *
468  * This implementation is agnostic to the way tokens are created. This means
469  * that a supply mechanism has to be added in a derived contract using {_mint}.
470  * For a generic mechanism see {ERC20PresetMinterPauser}.
471  *
472  * TIP: For a detailed writeup see our guide
473  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
474  * to implement supply mechanisms].
475  *
476  * We have followed general OpenZeppelin guidelines: functions revert instead
477  * of returning `false` on failure. This behavior is nonetheless conventional
478  * and does not conflict with the expectations of ERC20 applications.
479  *
480  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
481  * This allows applications to reconstruct the allowance for all accounts just
482  * by listening to said events. Other implementations of the EIP may not emit
483  * these events, as it isn't required by the specification.
484  *
485  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
486  * functions have been added to mitigate the well-known issues around setting
487  * allowances. See {IERC20-approve}.
488  */
489 contract ERC20BurnableMaxSupply is Context, IERC20 {
490     using SafeMath for uint256;
491     using Address for address;
492 
493     mapping (address => uint256) private _balances;
494 
495     mapping (address => mapping (address => uint256)) private _allowances;
496 
497     uint256 private _totalSupply;
498 
499     string private _name;
500     string private _symbol;
501     uint8 private _decimals;
502 
503     /**
504      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
505      * a default value of 18.
506      *
507      * To select a different value for {decimals}, use {_setupDecimals}.
508      *
509      * All three of these values are immutable: they can only be set once during
510      * construction.
511      */
512     constructor (string memory name, string memory symbol) public {
513         _name = name;
514         _symbol = symbol;
515         _decimals = 18;
516     }
517 
518     /**
519      * @dev Returns the name of the token.
520      */
521     function name() public view returns (string memory) {
522         return _name;
523     }
524 
525     /**
526      * @dev Returns the symbol of the token, usually a shorter version of the
527      * name.
528      */
529     function symbol() public view returns (string memory) {
530         return _symbol;
531     }
532 
533     /**
534      * @dev Returns the number of decimals used to get its user representation.
535      * For example, if `decimals` equals `2`, a balance of `505` tokens should
536      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
537      *
538      * Tokens usually opt for a value of 18, imitating the relationship between
539      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
540      * called.
541      *
542      * NOTE: This information is only used for _display_ purposes: it in
543      * no way affects any of the arithmetic of the contract, including
544      * {IERC20-balanceOf} and {IERC20-transfer}.
545      */
546     function decimals() public view returns (uint8) {
547         return _decimals;
548     }
549 
550     /**
551      * @dev See {IERC20-totalSupply}.
552      */
553     function totalSupply() public view override returns (uint256) {
554         return _totalSupply;
555     }
556 
557     /**
558      * @dev See {IERC20-balanceOf}.
559      */
560     function balanceOf(address account) public view override returns (uint256) {
561         return _balances[account];
562     }
563 
564     /**
565      * @dev See {IERC20-transfer}.
566      *
567      * Requirements:
568      *
569      * - `recipient` cannot be the zero address.
570      * - the caller must have a balance of at least `amount`.
571      */
572     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
573         _transfer(_msgSender(), recipient, amount);
574         return true;
575     }
576 
577     /**
578      * @dev See {IERC20-allowance}.
579      */
580     function allowance(address owner, address spender) public view virtual override returns (uint256) {
581         return _allowances[owner][spender];
582     }
583 
584     /**
585      * @dev See {IERC20-approve}.
586      *
587      * Requirements:
588      *
589      * - `spender` cannot be the zero address.
590      */
591     function approve(address spender, uint256 amount) public virtual override returns (bool) {
592         _approve(_msgSender(), spender, amount);
593         return true;
594     }
595 
596     /**
597      * @dev See {IERC20-transferFrom}.
598      *
599      * Emits an {Approval} event indicating the updated allowance. This is not
600      * required by the EIP. See the note at the beginning of {ERC20};
601      *
602      * Requirements:
603      * - `sender` and `recipient` cannot be the zero address.
604      * - `sender` must have a balance of at least `amount`.
605      * - the caller must have allowance for ``sender``'s tokens of at least
606      * `amount`.
607      */
608     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
609         _transfer(sender, recipient, amount);
610         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
611         return true;
612     }
613 
614     /**
615      * @dev Atomically increases the allowance granted to `spender` by the caller.
616      *
617      * This is an alternative to {approve} that can be used as a mitigation for
618      * problems described in {IERC20-approve}.
619      *
620      * Emits an {Approval} event indicating the updated allowance.
621      *
622      * Requirements:
623      *
624      * - `spender` cannot be the zero address.
625      */
626     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
627         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
628         return true;
629     }
630 
631     /**
632      * @dev Atomically decreases the allowance granted to `spender` by the caller.
633      *
634      * This is an alternative to {approve} that can be used as a mitigation for
635      * problems described in {IERC20-approve}.
636      *
637      * Emits an {Approval} event indicating the updated allowance.
638      *
639      * Requirements:
640      *
641      * - `spender` cannot be the zero address.
642      * - `spender` must have allowance for the caller of at least
643      * `subtractedValue`.
644      */
645     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
646         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
647         return true;
648     }
649 
650     /**
651      * @dev Moves tokens `amount` from `sender` to `recipient`.
652      *
653      * This is internal function is equivalent to {transfer}, and can be used to
654      * e.g. implement automatic token fees, slashing mechanisms, etc.
655      *
656      * Emits a {Transfer} event.
657      *
658      * Requirements:
659      *
660      * - `sender` cannot be the zero address.
661      * - `recipient` cannot be the zero address.
662      * - `sender` must have a balance of at least `amount`.
663      */
664     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
665         require(sender != address(0), "ERC20: transfer from the zero address");
666         require(recipient != address(0), "ERC20: transfer to the zero address");
667 
668         _beforeTokenTransfer(sender, recipient, amount);
669 
670         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
671         _balances[recipient] = _balances[recipient].add(amount);
672         emit Transfer(sender, recipient, amount);
673     }
674 
675     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
676      * the total supply.
677      *
678      * ADJUSTMENTS: Can only mint up to 13k (13e21) BBRA (burn + farm rewards have to be stable at lower than 13k)
679      *
680      * Emits a {Transfer} event with `from` set to the zero address.
681      *
682      * Requirements
683      *
684      * - `to` cannot be the zero address.
685      */
686     function _mint(address account, uint256 amount) internal virtual {
687         require(account != address(0), "ERC20: mint to the zero address");
688 
689         _beforeTokenTransfer(address(0), account, amount);
690 
691         if (_totalSupply.add(amount) > 13e21) {
692             // if supply is over 13k after adding 'amount' check what is available to be minted (13e21 - current supply)
693             // if it's greater than 0 then we can mint up to that amount
694             // Eg totalSupply = 12,999e18 BBRA and amount to be minted is 10e18 BBRA. We can't mint 10e18 because it takes us over
695             // hard cap. However we can mint a partial amount aka 13e21 - 12,999e18 = 1e18
696             amount = uint256(13e21).sub(_totalSupply);
697 
698             // can't mint even a partial amount so we must exit the function
699             if (amount == 0)
700                 return;
701         }
702 
703         _totalSupply = _totalSupply.add(amount);
704         _balances[account] = _balances[account].add(amount);
705         emit Transfer(address(0), account, amount);
706     }
707 
708     /**
709      * @dev Destroys `amount` tokens from `account`, reducing the
710      * total supply.
711      *
712      * Emits a {Transfer} event with `to` set to the zero address.
713      *
714      * Requirements
715      *
716      * - `account` cannot be the zero address.
717      * - `account` must have at least `amount` tokens.
718      */
719     function _burn(address account, uint256 amount) internal virtual {
720         require(account != address(0), "ERC20: burn from the zero address");
721 
722         _beforeTokenTransfer(account, address(0), amount);
723 
724         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
725         _totalSupply = _totalSupply.sub(amount);
726         emit Transfer(account, address(0), amount);
727     }
728 
729     /**
730      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
731      *
732      * This internal function is equivalent to `approve`, and can be used to
733      * e.g. set automatic allowances for certain subsystems, etc.
734      *
735      * Emits an {Approval} event.
736      *
737      * Requirements:
738      *
739      * - `owner` cannot be the zero address.
740      * - `spender` cannot be the zero address.
741      */
742     function _approve(address owner, address spender, uint256 amount) internal virtual {
743         require(owner != address(0), "ERC20: approve from the zero address");
744         require(spender != address(0), "ERC20: approve to the zero address");
745 
746         _allowances[owner][spender] = amount;
747         emit Approval(owner, spender, amount);
748     }
749 
750     /**
751      * @dev Sets {decimals} to a value other than the default one of 18.
752      *
753      * WARNING: This function should only be called from the constructor. Most
754      * applications that interact with token contracts will not expect
755      * {decimals} to ever change, and may work incorrectly if it does.
756      */
757     function _setupDecimals(uint8 decimals_) internal {
758         _decimals = decimals_;
759     }
760 
761     /**
762      * @dev Hook that is called before any transfer of tokens. This includes
763      * minting and burning.
764      *
765      * Calling conditions:
766      *
767      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
768      * will be to transferred to `to`.
769      * - when `from` is zero, `amount` tokens will be minted for `to`.
770      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
771      * - `from` and `to` are never both zero.
772      *
773      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
774      */
775     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
776 }
777 
778 interface IUniswapV2Router01 {
779     function factory() external pure returns (address);
780     function WETH() external pure returns (address);
781 
782     function addLiquidity(
783         address tokenA,
784         address tokenB,
785         uint amountADesired,
786         uint amountBDesired,
787         uint amountAMin,
788         uint amountBMin,
789         address to,
790         uint deadline
791     ) external returns (uint amountA, uint amountB, uint liquidity);
792     function addLiquidityETH(
793         address token,
794         uint amountTokenDesired,
795         uint amountTokenMin,
796         uint amountETHMin,
797         address to,
798         uint deadline
799     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
800     function removeLiquidity(
801         address tokenA,
802         address tokenB,
803         uint liquidity,
804         uint amountAMin,
805         uint amountBMin,
806         address to,
807         uint deadline
808     ) external returns (uint amountA, uint amountB);
809     function removeLiquidityETH(
810         address token,
811         uint liquidity,
812         uint amountTokenMin,
813         uint amountETHMin,
814         address to,
815         uint deadline
816     ) external returns (uint amountToken, uint amountETH);
817     function removeLiquidityWithPermit(
818         address tokenA,
819         address tokenB,
820         uint liquidity,
821         uint amountAMin,
822         uint amountBMin,
823         address to,
824         uint deadline,
825         bool approveMax, uint8 v, bytes32 r, bytes32 s
826     ) external returns (uint amountA, uint amountB);
827     function removeLiquidityETHWithPermit(
828         address token,
829         uint liquidity,
830         uint amountTokenMin,
831         uint amountETHMin,
832         address to,
833         uint deadline,
834         bool approveMax, uint8 v, bytes32 r, bytes32 s
835     ) external returns (uint amountToken, uint amountETH);
836     function swapExactTokensForTokens(
837         uint amountIn,
838         uint amountOutMin,
839         address[] calldata path,
840         address to,
841         uint deadline
842     ) external returns (uint[] memory amounts);
843     function swapTokensForExactTokens(
844         uint amountOut,
845         uint amountInMax,
846         address[] calldata path,
847         address to,
848         uint deadline
849     ) external returns (uint[] memory amounts);
850     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
851         external
852         payable
853         returns (uint[] memory amounts);
854     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
855         external
856         returns (uint[] memory amounts);
857     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
858         external
859         returns (uint[] memory amounts);
860     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
861         external
862         payable
863         returns (uint[] memory amounts);
864 
865     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
866     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
867     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
868     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
869     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
870 }
871 
872 interface IUniswapV2Router02 is IUniswapV2Router01 {
873     function removeLiquidityETHSupportingFeeOnTransferTokens(
874         address token,
875         uint liquidity,
876         uint amountTokenMin,
877         uint amountETHMin,
878         address to,
879         uint deadline
880     ) external returns (uint amountETH);
881     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
882         address token,
883         uint liquidity,
884         uint amountTokenMin,
885         uint amountETHMin,
886         address to,
887         uint deadline,
888         bool approveMax, uint8 v, bytes32 r, bytes32 s
889     ) external returns (uint amountETH);
890 
891     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
892         uint amountIn,
893         uint amountOutMin,
894         address[] calldata path,
895         address to,
896         uint deadline
897     ) external;
898     function swapExactETHForTokensSupportingFeeOnTransferTokens(
899         uint amountOutMin,
900         address[] calldata path,
901         address to,
902         uint deadline
903     ) external payable;
904     function swapExactTokensForETHSupportingFeeOnTransferTokens(
905         uint amountIn,
906         uint amountOutMin,
907         address[] calldata path,
908         address to,
909         uint deadline
910     ) external;
911 }
912 
913 interface IUniswapV2Factory {
914     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
915 
916     function feeTo() external view returns (address);
917     function feeToSetter() external view returns (address);
918 
919     function getPair(address tokenA, address tokenB) external view returns (address pair);
920     function allPairs(uint) external view returns (address pair);
921     function allPairsLength() external view returns (uint);
922 
923     function createPair(address tokenA, address tokenB) external returns (address pair);
924 
925     function setFeeTo(address) external;
926     function setFeeToSetter(address) external;
927 }
928 
929 // 
930 /**
931  * @dev Contract module which provides a basic access control mechanism, where
932  * there is an account (an admin) that can be granted exclusive access to
933  * specific functions.
934  *
935  * By default, the admin account will be the one that deploys the contract. This
936  * can later be changed with {transferAdmin}.
937  *
938  * This module is used through inheritance. It will make available the modifier
939  * `onlyAdmin`, which can be applied to your functions to restrict their use to
940  * the owner.
941  */
942 contract Administrable is Context {
943     address private _admin;
944 
945     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
946 
947     /**
948      * @dev Initializes the contract setting the deployer as the initial admin.
949      */
950     constructor () internal {
951         address msgSender = _msgSender();
952         _admin = msgSender;
953         emit AdminTransferred(address(0), msgSender);
954     }
955 
956     /**
957      * @dev Returns the address of the current admin.
958      */
959     function admin() public view returns (address) {
960         return _admin;
961     }
962 
963     /**
964      * @dev Throws if called by any account other than the admin.
965      */
966     modifier onlyAdmin() {
967         require(_admin == _msgSender(), "Administrable: caller is not the admin");
968         _;
969     }
970 
971     /**
972      * @dev Leaves the contract without admin. It will not be possible to call
973      * `onlyAdmin` functions anymore. Can only be called by the current admin.
974      *
975      * NOTE: Renouncing admin will leave the contract without an admin,
976      * thereby removing any functionality that is only available to the admin.
977      */
978     function renounceAdmin() public virtual onlyAdmin {
979         emit AdminTransferred(_admin, address(0));
980         _admin = address(0);
981     }
982 
983     /**
984      * @dev Transfers admin of the contract to a new account (`newAdmin`).
985      * Can only be called by the current ad,om.
986      */
987     function transferAdmin(address newAdmin) public virtual onlyAdmin {
988         require(newAdmin != address(0), "Administrable: new admin is the zero address");
989         emit AdminTransferred(_admin, newAdmin);
990         _admin = newAdmin;
991     }
992 }
993 
994 // 
995 abstract contract ERC20Payable {
996 
997     event Received(address indexed sender, uint256 amount);
998 
999     receive() external payable {
1000         emit Received(msg.sender, msg.value);
1001     }
1002 }
1003 
1004 // 
1005 interface ISecondaryToken {
1006     // placeholder interface for tokens generate from burn
1007     // could be used in future to pass the responsibility to a contract that
1008     // would then mint the burn with dynamic variables from nfts
1009 
1010     function mint(
1011         address account,
1012         uint256 amount
1013     ) external;
1014 }
1015 
1016 // 
1017 interface IProtocolAdapter {
1018     // Gets adapted burn divisor
1019     function getBurnDivisor(address _user, uint256 _currentBurnDivisor) external view returns (uint256);
1020 
1021     // Gets adapted farm rewards multiplier
1022     function getRewardsMultiplier(address _user, uint256 _currentRewardsMultiplier) external view returns (uint256);
1023 }
1024 
1025 // 
1026 /**
1027  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1028  * tokens and those that they have an allowance for, in a way that can be
1029  * recognized off-chain (via event analysis).
1030  */
1031 abstract contract ERC20Burnable is Context, ERC20BurnableMaxSupply {
1032     /**
1033      * @dev Destroys `amount` tokens from the caller. CANNOT BE USED TO BURN OTHER PEOPLES TOKENS
1034      * ONLY BBRA AND ONLY FROM THE PERSON CALLING THE FUNCTION
1035      *
1036      * See {ERC20-_burn}.
1037      */
1038     function burn(uint256 amount) public virtual {
1039         _burn(_msgSender(), amount);
1040     }
1041 }
1042 
1043 // 
1044 // Boo with Governance.
1045 // Ownership given to Farming contract and Adminship can be given to DAO contract
1046 contract BooBankerResearchAssociation is ERC20BurnableMaxSupply("BooBanker Research Association", "BBRA"), ERC20Burnable, Ownable, Administrable, ERC20Payable {
1047     using SafeMath for uint256;
1048 
1049     // uniswap info
1050     address public uniswapV2Router;
1051     address public uniswapV2Pair;
1052     address public uniswapV2Factory;
1053 
1054     // the amount burned tokens every transfer, i.e. 255 = 0.4%, 100 = 1%, 50 = 2%, 40 = 2.5%
1055     uint256 public burnDivisor;
1056     // the amount tokens saved for liquidity lock every transfer, i.e. 255 = 0.4%, 100 = 1%, 50 = 2%, 40 = 2.5%
1057     uint256 public liquidityDivisor;
1058 
1059     // If any token should be minted from burned $bbra (not $brra)
1060     ISecondaryToken public burnToken;
1061 
1062     // Dynamic burn regulator (less burn with a certain number of nfts etc)
1063     IProtocolAdapter public protocolAdapter;
1064 
1065     // Whether the protocol should reward those that spend their gas fees locking liquidity
1066     bool public rewardLiquidityLockCaller;
1067 
1068     // Pause trading after listing until x block - can only be used once
1069     bool public canPause;
1070     uint256 public pauseUntilBlock;
1071 
1072     // Timestamp of last liquidity lock call
1073     uint256 public lastLiquidityLock;
1074 
1075     // 1% of all transfers are sent to marketing fund
1076     address public _devaddr;
1077 
1078     // Events
1079     event LiquidityLock(uint256 tokenAmount, uint256 ethAmount);
1080     event LiquidityBurn(uint256 lpTokenAmount);
1081     event CallerReward(address caller, uint256 tokenAmount);
1082     event BuyBack(uint256 ethAmount, uint256 tokenAmount);
1083     event ProtocolAdapterChange(address _newProtocol);
1084 
1085     constructor(uint256 _burnDivisor, uint256 _liquidityDivisor) public {
1086 
1087         burnDivisor = _burnDivisor;
1088         liquidityDivisor = _liquidityDivisor;
1089         _devaddr = msg.sender;
1090         rewardLiquidityLockCaller = true;
1091         canPause = true;
1092         // initial quantity, 13k tokens
1093         _mint(msg.sender, 13e21);
1094     }
1095 
1096     function transferFrom(address sender, address recipient, uint256 amount) public checkRunning virtual override returns (bool) {
1097         uint256 onePct = amount.div(100);
1098         uint256 liquidityAmount = amount.div(liquidityDivisor);
1099         // Use dynamic burn divisor if Adapter contract is set
1100         uint256 burnAmount = amount.div(
1101             ( address(protocolAdapter) != address(0)
1102                 ? protocolAdapter.getBurnDivisor(pickHuman(sender, recipient), burnDivisor)
1103                 : burnDivisor
1104             )
1105         );
1106 
1107         _burn(sender, burnAmount);
1108 
1109         // Should a secondary token be given to recipient from burn amount?
1110         //
1111         if(address(burnToken) != address(0)) {
1112             burnToken.mint(recipient, burnAmount);
1113         }
1114 
1115         super.transferFrom(sender, _devaddr, onePct);
1116         super.transferFrom(sender, address(this), liquidityAmount);
1117         return super.transferFrom(sender, recipient, amount.sub(burnAmount).sub(liquidityAmount).sub(onePct));
1118     }
1119 
1120     function transfer(address recipient, uint256 amount) public checkRunning virtual override returns (bool) {
1121         uint256 onePct = amount.div(100);
1122         uint256 liquidityAmount = amount.div(liquidityDivisor);
1123         // Use dynamic burn divisor if Adapter contract is set
1124         uint256 burnAmount = amount.div(
1125             ( address(protocolAdapter) != address(0)
1126                 ? protocolAdapter.getBurnDivisor(pickHuman(msg.sender, recipient), burnDivisor)
1127                 : burnDivisor
1128             )
1129         );
1130 
1131         // do nft adapter
1132         _burn(msg.sender, burnAmount);
1133 
1134         // Should a secondary token be given to recipient from burn amount?
1135         if(address(burnToken) != address(0)) {
1136             burnToken.mint(recipient, burnAmount);
1137         }
1138 
1139         super.transfer(_devaddr, onePct);
1140         super.transfer(address(this), liquidityAmount);
1141         return super.transfer(recipient, amount.sub(burnAmount).sub(liquidityAmount).sub(onePct));
1142     }
1143 
1144     // Check if _from is human when calculating ProtocolAdapter settings (like burn)
1145     // so that if you're buying from Uniswap the adjusted burn still works
1146     function pickHuman(address _from, address _to) public view returns (address) {
1147         uint256 _codeLength;
1148         assembly {_codeLength := extcodesize(_from)}
1149         return _codeLength == 0 ? _from : _to;
1150     }
1151 
1152     /**
1153      * @dev Throws if called by any account other than the admin or owner.
1154      */
1155     modifier onlyAdminOrOwner() {
1156         require(admin() == _msgSender() || owner() == _msgSender(), "Ownable: caller is not the admin");
1157         _;
1158     }
1159 
1160     // To be used to stop trading at listing - prevent bots from buying
1161     modifier checkRunning(){
1162         require(block.number > pauseUntilBlock, "Go away bot");
1163         _;
1164     }
1165 
1166     // Trading can only be paused once, ever. Setting pauseUntilBlock to 0 resumes trading after pausing.
1167     function setPauseUntilBlock(uint256 _pauseUntilBlock) public onlyAdminOrOwner {
1168         require(canPause || _pauseUntilBlock == 0, 'Pause has already been used once. If disabling pause set block to 0');
1169         pauseUntilBlock = _pauseUntilBlock;
1170         // after the first pause we can no longer pause the protocol
1171         canPause = false;
1172     }
1173 
1174     /**
1175      * @dev prevents contracts from interacting with functions that have this modifier
1176      */
1177     modifier isHuman() {
1178         address _addr = msg.sender;
1179         uint256 _codeLength;
1180 
1181         assembly {_codeLength := extcodesize(_addr)}
1182 
1183 //        if (_codeLength == 0) {
1184 //            // use assert to consume all of the bots gas, kek
1185 //            assert(true == false, 'oh boy - bots get rekt');
1186 //        }
1187         require(_codeLength == 0, "sorry humans only");
1188         _;
1189     }
1190 
1191     // Sell half of burned tokens, provides liquidity and locks it away forever
1192     // can only be called when balance is > 1 and last lock is more than 2 hours ago
1193     function lockLiquidity() public isHuman() {
1194         // bbra balance
1195         uint256 _bal = balanceOf(address(this));
1196         require(uniswapV2Pair != address(0), "UniswapV2Pair not set in contract yet");
1197         require(uniswapV2Router != address(0), "UniswapV2Router not set in contract yet");
1198         require(_bal >= 1e18, "Minimum of 1 BBRA before we can lock liquidity");
1199         require(balanceOf(msg.sender) >= 5e18, "You must own at least 5 BBra to call lock");
1200 
1201         // caller rewards
1202         uint256 _callerReward = 0;
1203         if (rewardLiquidityLockCaller) {
1204             // subtract caller fee - 2% always
1205             _callerReward = _bal.div(50);
1206             _bal = _bal.sub(_callerReward);
1207         }
1208 
1209         // calculate ratios of bbra-eth for lp
1210         uint256 bbraToEth = _bal.div(2);
1211         uint256 brraForLiq = _bal.sub(bbraToEth);
1212 
1213         // Eth Balance before swap
1214         uint256 startingBalance = address(this).balance;
1215         swapTokensForWeth(bbraToEth);
1216 
1217         // due to price movements after selling it is likely that less than the amount of
1218         // eth received will be used for locking
1219         // instead of making the left over eth locked away forever we can call buyAndBurn() to buy back Bbra with leftover Eth
1220         uint256 ethFromBbra = address(this).balance.sub(startingBalance);
1221         addLiquidity(brraForLiq, ethFromBbra);
1222 
1223         emit LiquidityLock(brraForLiq, ethFromBbra);
1224 
1225         // only reward caller after trade to prevent any possible reentrancy
1226         // check balance is still available
1227         if (_callerReward != 0) {
1228             // in case LP takes more tokens than we are expecting reward _callerReward or balanceOf(this) - whichever is smallest
1229             if(balanceOf(address(this)) >= _callerReward) {
1230                 transfer(msg.sender, _callerReward);
1231             } else {
1232                 transfer(msg.sender, balanceOf(address(this)));
1233             }
1234         }
1235 
1236         lastLiquidityLock = block.timestamp;
1237     }
1238 
1239     // If for some reason we get more eth than expect from uniswap at time of locking liquidity
1240     // we buy and burn whatever amount of Bbra we get
1241     // can optout of burn so that instead it's added to the next liquidity lock instead
1242 
1243     // NOTE: Buy back not working due to address(this) being the token that we're buying from uniswap - apparently they
1244     // don't accept that. Leaving the code here however for anyone that wishes to adapt it and "fix" it
1245 //    function buyAndBurn(bool _burnTokens) public {
1246 //        // check minimum amount
1247 //        uint256 startingBbra = balanceOf(address(this));
1248 //        uint256 startingEth = address(this).balance;
1249 //
1250 //        require(startingEth >= 5e16, 'Contract balance must be at least 0.05 eth before invoking buyAndBurn');
1251 //
1252 //        swapWethForTokens(address(this).balance);
1253 //        uint256 buyBackAmount = startingBbra.sub(balanceOf(address(this)));
1254 //
1255 //        // if burn is active and we have bought some tokens back successfuly then burnnnn
1256 //        // if burn == false then tokens purchased will be used in liquidity at next lockLiquidity() call
1257 //        if(_burnTokens && buyBackAmount != 0) {
1258 //            // burn whatever amount was bought
1259 //            _burn(address(this), buyBackAmount);
1260 //        }
1261 //        emit BuyBack(startingEth.sub(address(this).balance), buyBackAmount);
1262 //    }
1263 //
1264 //    // buys bbra with left over eth - only called by liquidity lock function or buy&burn function
1265 //    function swapWethForTokens(uint256 ethAmount) internal {
1266 //        address[] memory uniswapPairPath = new address[](2);
1267 //        uniswapPairPath[0] = IUniswapV2Router02(uniswapV2Router).WETH();
1268 //        uniswapPairPath[1] = address(this);
1269 //
1270 //        IUniswapV2Router02(uniswapV2Router)
1271 //        .swapExactETHForTokensSupportingFeeOnTransferTokens{
1272 //        value: ethAmount
1273 //        }(
1274 //            0,
1275 //            uniswapPairPath,
1276 //            address(this),
1277 //            block.timestamp
1278 //        );
1279 //    }
1280 
1281     // swaps bra for eth - only called by liquidity lock function
1282     function swapTokensForWeth(uint256 tokenAmount) internal {
1283         address[] memory uniswapPairPath = new address[](2);
1284         uniswapPairPath[0] = address(this);
1285         uniswapPairPath[1] = IUniswapV2Router02(uniswapV2Router).WETH();
1286 
1287         _approve(address(this), uniswapV2Router, tokenAmount);
1288 
1289         IUniswapV2Router02(uniswapV2Router)
1290         .swapExactTokensForETHSupportingFeeOnTransferTokens(
1291             tokenAmount,
1292             0,
1293             uniswapPairPath,
1294             address(this),
1295             block.timestamp
1296         );
1297     }
1298 
1299     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
1300         // approve uniswapV2Router to transfer Brra
1301         _approve(address(this), uniswapV2Router, tokenAmount);
1302 
1303         // provide liquidity
1304         IUniswapV2Router02(uniswapV2Router)
1305         .addLiquidityETH{
1306             value: ethAmount
1307         }(
1308             address(this),
1309             tokenAmount,
1310             0,
1311             0,
1312             address(this),
1313             block.timestamp
1314         );
1315 
1316         // check LP balance
1317         uint256 _lpBalance = IERC20(uniswapV2Pair).balanceOf(address(this));
1318         if (_lpBalance != 0) {
1319             // transfer LP to burn address (aka locked forever)
1320             IERC20(uniswapV2Pair).transfer(address(0), _lpBalance);
1321             // any left over eth is sent to marketing for buy backs - will be a very minimal amount
1322             payable(_devaddr).transfer(address(this).balance);
1323             emit LiquidityBurn(_lpBalance);
1324         }
1325     }
1326 
1327     // returns amount of LP locked permanently
1328     function lockedLpAmount() public view returns(uint256) {
1329         if (uniswapV2Pair == address(0)) {
1330             return 0;
1331         }
1332 
1333         return IERC20(uniswapV2Pair).balanceOf(address(0));
1334     }
1335 
1336     // Whether Bbra should reward the person that pays for the gas calling the liquidity lock
1337     function setRewardLiquidityLockCaller(bool _rewardLiquidityLockCaller) public onlyAdminOrOwner {
1338         rewardLiquidityLockCaller = _rewardLiquidityLockCaller;
1339     }
1340 
1341     // Updates secondary token that could be minted from burned supply of BBRA (like BOOB mints ECTO on burn)
1342     function setSecondaryBurnToken(ISecondaryToken _token) public onlyAdminOrOwner {
1343         // this prevents the secondary token being itself and therefore negating burn
1344         require(address(_token) != address(this), 'Secondary token cannot be itself');
1345         // can be anything else, 0x0 disables secondary token usage
1346         burnToken = _token;
1347     }
1348 
1349     // Sets contract that regulates dynamic burn rates (changeable by DAO)
1350     function setProtocolAdapter(IProtocolAdapter _contract) public onlyAdminOrOwner {
1351         // setting to 0x0 disabled dynamic burn and is defaulted to regular burn
1352         protocolAdapter = _contract;
1353         emit ProtocolAdapterChange(address(_contract));
1354     }
1355 
1356     // self explanatory
1357     function setBurnRate(uint256 _burnDivisor) public onlyAdminOrOwner {
1358         require(_burnDivisor != 0, "Boo: burnDivisor must be bigger than 0");
1359         burnDivisor = _burnDivisor;
1360     }
1361 
1362     // self explanatory
1363     function setLiquidityDivisor(uint256 _liquidityDivisor) public onlyAdminOrOwner {
1364         require(_liquidityDivisor != 0, "Boo: _liquidityDivisor must be bigger than 0");
1365         liquidityDivisor = _liquidityDivisor;
1366     }
1367 
1368     /// @dev Creates `_amount` token to `_to`. Must only be called by the owner (MrBanker), used to mint farming rewards
1369     // and nothing else
1370     function mint(address _to, uint256 _amount) public onlyOwner {
1371         _mint(_to, _amount);
1372         _moveDelegates(address(0), _delegates[_to], _amount);
1373     }
1374 
1375     // Sets marketing address (where 1% is deposited)
1376     // Only owner can modify this (MrBanker)
1377     function setDevAddr(address _dev) public onlyOwner {
1378         _devaddr = _dev;
1379     }
1380 
1381     // sets uniswap router and LP pair addresses (needed for buy-back/sell and liquidity lock)
1382     function setUniswapAddresses(address _uniswapV2Factory, address _uniswapV2Router) public onlyAdminOrOwner {
1383         require(_uniswapV2Factory != address(0) && _uniswapV2Router != address(0), 'Uniswap addresses cannot be empty');
1384         uniswapV2Factory = _uniswapV2Factory;
1385         uniswapV2Router = _uniswapV2Router;
1386 
1387         if (uniswapV2Pair == address(0)) {
1388             createUniswapPair();
1389         }
1390     }
1391 
1392     // create LP pair if one hasn't been created
1393     // can be public, doesn't matter who calls it
1394     function createUniswapPair() public {
1395         require(uniswapV2Pair == address(0), "Pair has already been created");
1396         require(uniswapV2Factory != address(0) && uniswapV2Router != address(0), "Uniswap addresses have not been set");
1397 
1398         uniswapV2Pair = IUniswapV2Factory(uniswapV2Factory).createPair(
1399                 IUniswapV2Router02(uniswapV2Router).WETH(),
1400                 address(this)
1401         );
1402     }
1403 
1404     // Copied and modified from YAM code:
1405     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1406     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1407     // Which is copied and modified from COMPOUND:
1408     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1409 
1410     /// @dev A record of each accounts delegate
1411     mapping (address => address) internal _delegates;
1412 
1413     /// @dev A checkpoint for marking number of votes from a given block
1414     struct Checkpoint {
1415         uint32 fromBlock;
1416         uint256 votes;
1417     }
1418 
1419     /// @dev A record of votes checkpoints for each account, by index
1420     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1421 
1422     /// @dev The number of checkpoints for each account
1423     mapping (address => uint32) public numCheckpoints;
1424 
1425     /// @dev The EIP-712 typehash for the contract's domain
1426     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1427 
1428     /// @dev The EIP-712 typehash for the delegation struct used by the contract
1429     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1430 
1431     /// @dev A record of states for signing / validating signatures
1432     mapping (address => uint) public nonces;
1433 
1434     /// @dev An event thats emitted when an account changes its delegate
1435     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1436 
1437     /// @dev An event thats emitted when a delegate account's vote balance changes
1438     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1439 
1440     /**
1441      * @dev Delegate votes from `msg.sender` to `delegatee`
1442      * @param delegator The address to get delegatee for
1443      */
1444     function delegates(address delegator)
1445     external
1446     view
1447     returns (address)
1448     {
1449         return _delegates[delegator];
1450     }
1451 
1452     /**
1453      * @dev Delegate votes from `msg.sender` to `delegatee`
1454      * @param delegatee The address to delegate votes to
1455      */
1456     function delegate(address delegatee) external {
1457         return _delegate(msg.sender, delegatee);
1458     }
1459 
1460     /**
1461      * @dev Delegates votes from signatory to `delegatee`
1462      * @param delegatee The address to delegate votes to
1463      * @param nonce The contract state required to match the signature
1464      * @param expiry The time at which to expire the signature
1465      * @param v The recovery byte of the signature
1466      * @param r Half of the ECDSA signature pair
1467      * @param s Half of the ECDSA signature pair
1468      */
1469     function delegateBySig(
1470         address delegatee,
1471         uint nonce,
1472         uint expiry,
1473         uint8 v,
1474         bytes32 r,
1475         bytes32 s
1476     )
1477     external
1478     {
1479         bytes32 domainSeparator = keccak256(
1480             abi.encode(
1481                 DOMAIN_TYPEHASH,
1482                 keccak256(bytes(name())),
1483                 getChainId(),
1484                 address(this)
1485             )
1486         );
1487 
1488         bytes32 structHash = keccak256(
1489             abi.encode(
1490                 DELEGATION_TYPEHASH,
1491                 delegatee,
1492                 nonce,
1493                 expiry
1494             )
1495         );
1496 
1497         bytes32 digest = keccak256(
1498             abi.encodePacked(
1499                 "\x19\x01",
1500                 domainSeparator,
1501                 structHash
1502             )
1503         );
1504 
1505         address signatory = ecrecover(digest, v, r, s);
1506         require(signatory != address(0), "BOOB::delegateBySig: invalid signature");
1507         require(nonce == nonces[signatory]++, "BOOB::delegateBySig: invalid nonce");
1508         require(now <= expiry, "BOOB::delegateBySig: signature expired");
1509         return _delegate(signatory, delegatee);
1510     }
1511 
1512     /**
1513      * @dev Gets the current votes balance for `account`
1514      * @param account The address to get votes balance
1515      * @return The number of current votes for `account`
1516      */
1517     function getCurrentVotes(address account)
1518     external
1519     view
1520     returns (uint256)
1521     {
1522         uint32 nCheckpoints = numCheckpoints[account];
1523         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1524     }
1525 
1526     /**
1527      * @dev Determine the prior number of votes for an account as of a block number
1528      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1529      * @param account The address of the account to check
1530      * @param blockNumber The block number to get the vote balance at
1531      * @return The number of votes the account had as of the given block
1532      */
1533     function getPriorVotes(address account, uint blockNumber)
1534     external
1535     view
1536     returns (uint256)
1537     {
1538         require(blockNumber < block.number, "BOOB::getPriorVotes: not yet determined");
1539 
1540         uint32 nCheckpoints = numCheckpoints[account];
1541         if (nCheckpoints == 0) {
1542             return 0;
1543         }
1544 
1545         // First check most recent balance
1546         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1547             return checkpoints[account][nCheckpoints - 1].votes;
1548         }
1549 
1550         // Next check implicit zero balance
1551         if (checkpoints[account][0].fromBlock > blockNumber) {
1552             return 0;
1553         }
1554 
1555         uint32 lower = 0;
1556         uint32 upper = nCheckpoints - 1;
1557         while (upper > lower) {
1558             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1559             Checkpoint memory cp = checkpoints[account][center];
1560             if (cp.fromBlock == blockNumber) {
1561                 return cp.votes;
1562             } else if (cp.fromBlock < blockNumber) {
1563                 lower = center;
1564             } else {
1565                 upper = center - 1;
1566             }
1567         }
1568         return checkpoints[account][lower].votes;
1569     }
1570 
1571     function _delegate(address delegator, address delegatee)
1572     internal
1573     {
1574         address currentDelegate = _delegates[delegator];
1575         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying BOOBs (not scaled);
1576         _delegates[delegator] = delegatee;
1577 
1578         emit DelegateChanged(delegator, currentDelegate, delegatee);
1579 
1580         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1581     }
1582 
1583     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1584         if (srcRep != dstRep && amount > 0) {
1585             if (srcRep != address(0)) {
1586                 // decrease old representative
1587                 uint32 srcRepNum = numCheckpoints[srcRep];
1588                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1589                 uint256 srcRepNew = srcRepOld.sub(amount);
1590                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1591             }
1592 
1593             if (dstRep != address(0)) {
1594                 // increase new representative
1595                 uint32 dstRepNum = numCheckpoints[dstRep];
1596                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1597                 uint256 dstRepNew = dstRepOld.add(amount);
1598                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1599             }
1600         }
1601     }
1602 
1603     function _writeCheckpoint(
1604         address delegatee,
1605         uint32 nCheckpoints,
1606         uint256 oldVotes,
1607         uint256 newVotes
1608     )
1609     internal
1610     {
1611         uint32 blockNumber = safe32(block.number, "BOOB::_writeCheckpoint: block number exceeds 32 bits");
1612 
1613         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1614             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1615         } else {
1616             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1617             numCheckpoints[delegatee] = nCheckpoints + 1;
1618         }
1619 
1620         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1621     }
1622 
1623     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1624         require(n < 2**32, errorMessage);
1625         return uint32(n);
1626     }
1627 
1628     function getChainId() internal pure returns (uint) {
1629         uint256 chainId;
1630         assembly { chainId := chainid() }
1631         return chainId;
1632     }
1633 }