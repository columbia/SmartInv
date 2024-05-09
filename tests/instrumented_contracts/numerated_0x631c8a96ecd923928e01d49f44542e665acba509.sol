1 pragma solidity ^0.8.0;
2 
3 // Part: IDragos - Needed to interface with the Dragos NFT contract
4 
5 interface IDragos {
6     function ownerOf(uint256 tokenId) external view returns (address owner);
7     function transferFrom(address from, address to, uint256 tokenId) external;
8 }
9 
10 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Address
11 
12 /**
13  * @dev Collection of functions related to the address type
14  */
15 library Address {
16     /**
17      * @dev Returns true if `account` is a contract.
18      *
19      * [IMPORTANT]
20      * ====
21      * It is unsafe to assume that an address for which this function returns
22      * false is an externally-owned account (EOA) and not a contract.
23      *
24      * Among others, `isContract` will return false for the following
25      * types of addresses:
26      *
27      *  - an externally-owned account
28      *  - a contract in construction
29      *  - an address where a contract will be created
30      *  - an address where a contract lived, but was destroyed
31      * ====
32      */
33     function isContract(address account) internal view returns (bool) {
34         // This method relies in extcodesize, which returns 0 for contracts in
35         // construction, since the code is only stored at the end of the
36         // constructor execution.
37 
38         uint256 size;
39         // solhint-disable-next-line no-inline-assembly
40         assembly { size := extcodesize(account) }
41         return size > 0;
42     }
43 
44     /**
45      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
46      * `recipient`, forwarding all available gas and reverting on errors.
47      *
48      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
49      * of certain opcodes, possibly making contracts go over the 2300 gas limit
50      * imposed by `transfer`, making them unable to receive funds via
51      * `transfer`. {sendValue} removes this limitation.
52      *
53      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
54      *
55      * IMPORTANT: because control is transferred to `recipient`, care must be
56      * taken to not create reentrancy vulnerabilities. Consider using
57      * {ReentrancyGuard} or the
58      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
59      */
60     function sendValue(address payable recipient, uint256 amount) internal {
61         require(address(this).balance >= amount, "Address: insufficient balance");
62 
63         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
64         (bool success, ) = recipient.call{ value: amount }("");
65         require(success, "Address: unable to send value, recipient may have reverted");
66     }
67 
68     /**
69      * @dev Performs a Solidity function call using a low level `call`. A
70      * plain`call` is an unsafe replacement for a function call: use this
71      * function instead.
72      *
73      * If `target` reverts with a revert reason, it is bubbled up by this
74      * function (like regular Solidity function calls).
75      *
76      * Returns the raw returned data. To convert to the expected return value,
77      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
78      *
79      * Requirements:
80      *
81      * - `target` must be a contract.
82      * - calling `target` with `data` must not revert.
83      *
84      * _Available since v3.1._
85      */
86     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
87       return functionCall(target, data, "Address: low-level call failed");
88     }
89 
90     /**
91      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
92      * `errorMessage` as a fallback revert reason when `target` reverts.
93      *
94      * _Available since v3.1._
95      */
96     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
97         return _functionCallWithValue(target, data, 0, errorMessage);
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
102      * but also transferring `value` wei to `target`.
103      *
104      * Requirements:
105      *
106      * - the calling contract must have an ETH balance of at least `value`.
107      * - the called Solidity function must be `payable`.
108      *
109      * _Available since v3.1._
110      */
111     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
112         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
113     }
114 
115     /**
116      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
117      * with `errorMessage` as a fallback revert reason when `target` reverts.
118      *
119      * _Available since v3.1._
120      */
121     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
122         require(address(this).balance >= value, "Address: insufficient balance for call");
123         return _functionCallWithValue(target, data, value, errorMessage);
124     }
125 
126     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
127         require(isContract(target), "Address: call to non-contract");
128 
129         // solhint-disable-next-line avoid-low-level-calls
130         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
131         if (success) {
132             return returndata;
133         } else {
134             // Look for revert reason and bubble it up if present
135             if (returndata.length > 0) {
136                 // The easiest way to bubble the revert reason is using memory via assembly
137 
138                 // solhint-disable-next-line no-inline-assembly
139                 assembly {
140                     let returndata_size := mload(returndata)
141                     revert(add(32, returndata), returndata_size)
142                 }
143             } else {
144                 revert(errorMessage);
145             }
146         }
147     }
148 }
149 
150 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Context
151 
152 /*
153  * @dev Provides information about the current execution context, including the
154  * sender of the transaction and its data. While these are generally available
155  * via msg.sender and msg.data, they should not be accessed in such a direct
156  * manner, since when dealing with GSN meta-transactions the account sending and
157  * paying for execution may not be the actual sender (as far as an application
158  * is concerned).
159  *
160  * This contract is only required for intermediate, library-like contracts.
161  */
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address payable) {
164         return payable(msg.sender);
165     }
166 
167     function _msgData() internal view virtual returns (bytes memory) {
168         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
169         return msg.data;
170     }
171 }
172 
173 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC20
174 
175 /**
176  * @dev Interface of the ERC20 standard as defined in the EIP.
177  */
178 interface IERC20 {
179     /**
180      * @dev Returns the amount of tokens in existence.
181      */
182     function totalSupply() external view returns (uint256);
183 
184     /**
185      * @dev Returns the amount of tokens owned by `account`.
186      */
187     function balanceOf(address account) external view returns (uint256);
188 
189     /**
190      * @dev Moves `amount` tokens from the caller's account to `recipient`.
191      *
192      * Returns a boolean value indicating whether the operation succeeded.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transfer(address recipient, uint256 amount) external returns (bool);
197 
198     /**
199      * @dev Returns the remaining number of tokens that `spender` will be
200      * allowed to spend on behalf of `owner` through {transferFrom}. This is
201      * zero by default.
202      *
203      * This value changes when {approve} or {transferFrom} are called.
204      */
205     function allowance(address owner, address spender) external view returns (uint256);
206 
207     /**
208      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * IMPORTANT: Beware that changing an allowance with this method brings the risk
213      * that someone may use both the old and the new allowance by unfortunate
214      * transaction ordering. One possible solution to mitigate this race
215      * condition is to first reduce the spender's allowance to 0 and set the
216      * desired value afterwards:
217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218      *
219      * Emits an {Approval} event.
220      */
221     function approve(address spender, uint256 amount) external returns (bool);
222 
223     /**
224      * @dev Moves `amount` tokens from `sender` to `recipient` using the
225      * allowance mechanism. `amount` is then deducted from the caller's
226      * allowance.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * Emits a {Transfer} event.
231      */
232     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
233 
234     /**
235      * @dev Emitted when `value` tokens are moved from one account (`from`) to
236      * another (`to`).
237      *
238      * Note that `value` may be zero.
239      */
240     event Transfer(address indexed from, address indexed to, uint256 value);
241 
242     /**
243      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
244      * a call to {approve}. `value` is the new allowance.
245      */
246     event Approval(address indexed owner, address indexed spender, uint256 value);
247 }
248 
249 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeMath
250 
251 /**
252  * @dev Wrappers over Solidity's arithmetic operations with added overflow
253  * checks.
254  *
255  * Arithmetic operations in Solidity wrap on overflow. This can easily result
256  * in bugs, because programmers usually assume that an overflow raises an
257  * error, which is the standard behavior in high level programming languages.
258  * `SafeMath` restores this intuition by reverting the transaction when an
259  * operation overflows.
260  *
261  * Using this library instead of the unchecked operations eliminates an entire
262  * class of bugs, so it's recommended to use it always.
263  */
264 library SafeMath {
265     /**
266      * @dev Returns the addition of two unsigned integers, reverting on
267      * overflow.
268      *
269      * Counterpart to Solidity's `+` operator.
270      *
271      * Requirements:
272      *
273      * - Addition cannot overflow.
274      */
275     function add(uint256 a, uint256 b) internal pure returns (uint256) {
276         uint256 c = a + b;
277         require(c >= a, "SafeMath: addition overflow");
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the subtraction of two unsigned integers, reverting on
284      * overflow (when the result is negative).
285      *
286      * Counterpart to Solidity's `-` operator.
287      *
288      * Requirements:
289      *
290      * - Subtraction cannot overflow.
291      */
292     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
293         return sub(a, b, "SafeMath: subtraction overflow");
294     }
295 
296     /**
297      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
298      * overflow (when the result is negative).
299      *
300      * Counterpart to Solidity's `-` operator.
301      *
302      * Requirements:
303      *
304      * - Subtraction cannot overflow.
305      */
306     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
307         require(b <= a, errorMessage);
308         uint256 c = a - b;
309 
310         return c;
311     }
312 
313     /**
314      * @dev Returns the multiplication of two unsigned integers, reverting on
315      * overflow.
316      *
317      * Counterpart to Solidity's `*` operator.
318      *
319      * Requirements:
320      *
321      * - Multiplication cannot overflow.
322      */
323     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
324         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
325         // benefit is lost if 'b' is also tested.
326         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
327         if (a == 0) {
328             return 0;
329         }
330 
331         uint256 c = a * b;
332         require(c / a == b, "SafeMath: multiplication overflow");
333 
334         return c;
335     }
336 
337     /**
338      * @dev Returns the integer division of two unsigned integers. Reverts on
339      * division by zero. The result is rounded towards zero.
340      *
341      * Counterpart to Solidity's `/` operator. Note: this function uses a
342      * `revert` opcode (which leaves remaining gas untouched) while Solidity
343      * uses an invalid opcode to revert (consuming all remaining gas).
344      *
345      * Requirements:
346      *
347      * - The divisor cannot be zero.
348      */
349     function div(uint256 a, uint256 b) internal pure returns (uint256) {
350         return div(a, b, "SafeMath: division by zero");
351     }
352 
353     /**
354      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
355      * division by zero. The result is rounded towards zero.
356      *
357      * Counterpart to Solidity's `/` operator. Note: this function uses a
358      * `revert` opcode (which leaves remaining gas untouched) while Solidity
359      * uses an invalid opcode to revert (consuming all remaining gas).
360      *
361      * Requirements:
362      *
363      * - The divisor cannot be zero.
364      */
365     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
366         require(b > 0, errorMessage);
367         uint256 c = a / b;
368         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
369 
370         return c;
371     }
372 
373     /**
374      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
375      * Reverts when dividing by zero.
376      *
377      * Counterpart to Solidity's `%` operator. This function uses a `revert`
378      * opcode (which leaves remaining gas untouched) while Solidity uses an
379      * invalid opcode to revert (consuming all remaining gas).
380      *
381      * Requirements:
382      *
383      * - The divisor cannot be zero.
384      */
385     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
386         return mod(a, b, "SafeMath: modulo by zero");
387     }
388 
389     /**
390      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
391      * Reverts with custom message when dividing by zero.
392      *
393      * Counterpart to Solidity's `%` operator. This function uses a `revert`
394      * opcode (which leaves remaining gas untouched) while Solidity uses an
395      * invalid opcode to revert (consuming all remaining gas).
396      *
397      * Requirements:
398      *
399      * - The divisor cannot be zero.
400      */
401     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
402         require(b != 0, errorMessage);
403         return a % b;
404     }
405 }
406 
407 /**
408  * @dev Contract module which provides a basic access control mechanism, where
409  * there is an account (an owner) that can be granted exclusive access to
410  * specific functions.
411  *
412  * By default, the owner account will be the one that deploys the contract. This
413  * can later be changed with {transferOwnership}.
414  *
415  * This module is used through inheritance. It will make available the modifier
416  * `onlyOwner`, which can be applied to your functions to restrict their use to
417  * the owner.
418  */
419 abstract contract Ownable is Context {
420     address private _owner;
421 
422     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
423 
424     /**
425      * @dev Initializes the contract setting the deployer as the initial owner.
426      */
427     constructor() {
428         _setOwner(_msgSender());
429     }
430 
431     /**
432      * @dev Returns the address of the current owner.
433      */
434     function owner() public view virtual returns (address) {
435         return _owner;
436     }
437 
438     /**
439      * @dev Throws if called by any account other than the owner.
440      */
441     modifier onlyOwner() {
442         require(owner() == _msgSender(), "Ownable: caller is not the owner");
443         _;
444     }
445 
446     /**
447      * @dev Leaves the contract without owner. It will not be possible to call
448      * `onlyOwner` functions anymore. Can only be called by the current owner.
449      *
450      * NOTE: Renouncing ownership will leave the contract without an owner,
451      * thereby removing any functionality that is only available to the owner.
452      */
453     function renounceOwnership() public virtual onlyOwner {
454         _setOwner(address(0));
455     }
456 
457     /**
458      * @dev Transfers ownership of the contract to a new account (`newOwner`).
459      * Can only be called by the current owner.
460      */
461     function transferOwnership(address newOwner) public virtual onlyOwner {
462         require(newOwner != address(0), "Ownable: new owner is the zero address");
463         _setOwner(newOwner);
464     }
465 
466     function _setOwner(address newOwner) private {
467         address oldOwner = _owner;
468         _owner = newOwner;
469         emit OwnershipTransferred(oldOwner, newOwner);
470     }
471 }
472 
473 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC20
474 
475 /**
476  * @dev Implementation of the {IERC20} interface.
477  *
478  * This implementation is agnostic to the way tokens are created. This means
479  * that a supply mechanism has to be added in a derived contract using {_mint}.
480  * For a generic mechanism see {ERC20PresetMinterPauser}.
481  *
482  * TIP: For a detailed writeup see our guide
483  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
484  * to implement supply mechanisms].
485  *
486  * We have followed general OpenZeppelin guidelines: functions revert instead
487  * of returning `false` on failure. This behavior is nonetheless conventional
488  * and does not conflict with the expectations of ERC20 applications.
489  *
490  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
491  * This allows applications to reconstruct the allowance for all accounts just
492  * by listening to said events. Other implementations of the EIP may not emit
493  * these events, as it isn't required by the specification.
494  *
495  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
496  * functions have been added to mitigate the well-known issues around setting
497  * allowances. See {IERC20-approve}.
498  */
499 contract ERC20 is Context, IERC20 {
500     using SafeMath for uint256;
501     using Address for address;
502 
503     mapping (address => uint256) private _balances;
504 
505     mapping (address => mapping (address => uint256)) private _allowances;
506 
507     uint256 private _totalSupply;
508 
509     string private _name;
510     string private _symbol;
511     uint8 private _decimals;
512 
513     /**
514      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
515      * a default value of 18.
516      *
517      * To select a different value for {decimals}, use {_setupDecimals}.
518      *
519      * All three of these values are immutable: they can only be set once during
520      * construction.
521      */
522     constructor (string memory name, string memory symbol) public {
523         _name = name;
524         _symbol = symbol;
525         _decimals = 18;
526     }
527 
528     /**
529      * @dev Returns the name of the token.
530      */
531     function name() public view returns (string memory) {
532         return _name;
533     }
534 
535     /**
536      * @dev Returns the symbol of the token, usually a shorter version of the
537      * name.
538      */
539     function symbol() public view returns (string memory) {
540         return _symbol;
541     }
542 
543     /**
544      * @dev Returns the number of decimals used to get its user representation.
545      * For example, if `decimals` equals `2`, a balance of `505` tokens should
546      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
547      *
548      * Tokens usually opt for a value of 18, imitating the relationship between
549      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
550      * called.
551      *
552      * NOTE: This information is only used for _display_ purposes: it in
553      * no way affects any of the arithmetic of the contract, including
554      * {IERC20-balanceOf} and {IERC20-transfer}.
555      */
556     function decimals() public view returns (uint8) {
557         return _decimals;
558     }
559 
560     /**
561      * @dev See {IERC20-totalSupply}.
562      */
563     function totalSupply() public view override returns (uint256) {
564         return _totalSupply;
565     }
566 
567     /**
568      * @dev See {IERC20-balanceOf}.
569      */
570     function balanceOf(address account) public view override returns (uint256) {
571         return _balances[account];
572     }
573 
574     /**
575      * @dev See {IERC20-transfer}.
576      *
577      * Requirements:
578      *
579      * - `recipient` cannot be the zero address.
580      * - the caller must have a balance of at least `amount`.
581      */
582     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
583         _transfer(_msgSender(), recipient, amount);
584         return true;
585     }
586 
587     /**
588      * @dev See {IERC20-allowance}.
589      */
590     function allowance(address owner, address spender) public view virtual override returns (uint256) {
591         return _allowances[owner][spender];
592     }
593 
594     /**
595      * @dev See {IERC20-approve}.
596      *
597      * Requirements:
598      *
599      * - `spender` cannot be the zero address.
600      */
601     function approve(address spender, uint256 amount) public virtual override returns (bool) {
602         _approve(_msgSender(), spender, amount);
603         return true;
604     }
605 
606     /**
607      * @dev See {IERC20-transferFrom}.
608      *
609      * Emits an {Approval} event indicating the updated allowance. This is not
610      * required by the EIP. See the note at the beginning of {ERC20};
611      *
612      * Requirements:
613      * - `sender` and `recipient` cannot be the zero address.
614      * - `sender` must have a balance of at least `amount`.
615      * - the caller must have allowance for ``sender``'s tokens of at least
616      * `amount`.
617      */
618     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
619         _transfer(sender, recipient, amount);
620         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
621         return true;
622     }
623 
624     /**
625      * @dev Atomically increases the allowance granted to `spender` by the caller.
626      *
627      * This is an alternative to {approve} that can be used as a mitigation for
628      * problems described in {IERC20-approve}.
629      *
630      * Emits an {Approval} event indicating the updated allowance.
631      *
632      * Requirements:
633      *
634      * - `spender` cannot be the zero address.
635      */
636     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
637         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
638         return true;
639     }
640 
641     /**
642      * @dev Atomically decreases the allowance granted to `spender` by the caller.
643      *
644      * This is an alternative to {approve} that can be used as a mitigation for
645      * problems described in {IERC20-approve}.
646      *
647      * Emits an {Approval} event indicating the updated allowance.
648      *
649      * Requirements:
650      *
651      * - `spender` cannot be the zero address.
652      * - `spender` must have allowance for the caller of at least
653      * `subtractedValue`.
654      */
655     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
656         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
657         return true;
658     }
659 
660     /**
661      * @dev Moves tokens `amount` from `sender` to `recipient`.
662      *
663      * This is internal function is equivalent to {transfer}, and can be used to
664      * e.g. implement automatic token fees, slashing mechanisms, etc.
665      *
666      * Emits a {Transfer} event.
667      *
668      * Requirements:
669      *
670      * - `sender` cannot be the zero address.
671      * - `recipient` cannot be the zero address.
672      * - `sender` must have a balance of at least `amount`.
673      */
674     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
675         require(sender != address(0), "ERC20: transfer from the zero address");
676         require(recipient != address(0), "ERC20: transfer to the zero address");
677 
678         _beforeTokenTransfer(sender, recipient, amount);
679 
680         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
681         _balances[recipient] = _balances[recipient].add(amount);
682         emit Transfer(sender, recipient, amount);
683     }
684 
685     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
686      * the total supply.
687      *
688      * Emits a {Transfer} event with `from` set to the zero address.
689      *
690      * Requirements
691      *
692      * - `to` cannot be the zero address.
693      */
694     function _mint(address account, uint256 amount) internal virtual {
695         require(account != address(0), "ERC20: mint to the zero address");
696 
697         _beforeTokenTransfer(address(0), account, amount);
698 
699         _totalSupply = _totalSupply.add(amount);
700         _balances[account] = _balances[account].add(amount);
701         emit Transfer(address(0), account, amount);
702     }
703 
704     /**
705      * @dev Destroys `amount` tokens from `account`, reducing the
706      * total supply.
707      *
708      * Emits a {Transfer} event with `to` set to the zero address.
709      *
710      * Requirements
711      *
712      * - `account` cannot be the zero address.
713      * - `account` must have at least `amount` tokens.
714      */
715     function _burn(address account, uint256 amount) internal virtual {
716         require(account != address(0), "ERC20: burn from the zero address");
717 
718         _beforeTokenTransfer(account, address(0), amount);
719 
720         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
721         _totalSupply = _totalSupply.sub(amount);
722         emit Transfer(account, address(0), amount);
723     }
724 
725     /**
726      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
727      *
728      * This internal function is equivalent to `approve`, and can be used to
729      * e.g. set automatic allowances for certain subsystems, etc.
730      *
731      * Emits an {Approval} event.
732      *
733      * Requirements:
734      *
735      * - `owner` cannot be the zero address.
736      * - `spender` cannot be the zero address.
737      */
738     function _approve(address owner, address spender, uint256 amount) internal virtual {
739         require(owner != address(0), "ERC20: approve from the zero address");
740         require(spender != address(0), "ERC20: approve to the zero address");
741 
742         _allowances[owner][spender] = amount;
743         emit Approval(owner, spender, amount);
744     }
745 
746     /**
747      * @dev Sets {decimals} to a value other than the default one of 18.
748      *
749      * WARNING: This function should only be called from the constructor. Most
750      * applications that interact with token contracts will not expect
751      * {decimals} to ever change, and may work incorrectly if it does.
752      */
753     function _setupDecimals(uint8 decimals_) internal {
754         _decimals = decimals_;
755     }
756 
757     /**
758      * @dev Hook that is called before any transfer of tokens. This includes
759      * minting and burning.
760      *
761      * Calling conditions:
762      *
763      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
764      * will be to transferred to `to`.
765      * - when `from` is zero, `amount` tokens will be minted for `to`.
766      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
767      * - `from` and `to` are never both zero.
768      *
769      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
770      */
771     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
772 }
773 
774 // File: DragosContract.sol
775 
776 contract DragosToken is Ownable, ERC20("DragosToken", "DRGSTKN") {
777 	using SafeMath for uint256;
778 
779     mapping(uint256 => address) public addressOfDragosStaker;
780     mapping(uint256 => uint256) public tokenStakePayout;
781     mapping(address => uint256[]) public dragosStakedAddress;
782     mapping(address => uint256) public dragosAddressStakeLength;
783 
784     mapping(uint256 => uint256) public dragosClaimDate;
785     mapping(uint256 => uint256) public dragosStakeDate;
786 
787     bool public stakingOpen;
788 
789     uint256[] stakeLengths = [
790         1 days,
791         30 days,
792         60 days
793     ];
794 
795     uint256[] rewardRates = [
796         1,
797         30,
798         120
799     ];
800 
801 	IDragos public dragosContract;
802 
803 	event RewardPaid(address indexed user, uint256 reward);
804 
805 	constructor() {
806         
807         dragosContract = IDragos(0xB0858AC51bca73c11BA3203712E319b7C45b0896);
808 	}
809 
810     // Necessary function letting the sending contract know this contract
811     // Is prepared to hold an ERC721 token
812     function onERC721Received(
813         address operator,
814         address from,
815         uint256 tokenId,
816         bytes calldata data
817     ) public pure returns (bytes4) {
818         return this.onERC721Received.selector ^ 0x23b872dd;
819     }
820 
821     function stakeDragos(uint256[] memory dragosTokenId, uint256 stakingTypeIndex) external 
822     {
823         require(stakingOpen, "Staking is not open");
824         uint256 claimDate = block.timestamp + stakeLengths[stakingTypeIndex - 1];
825         uint256 reward = rewardRates[stakingTypeIndex - 1];
826 
827         address from = _msgSender();
828         for(uint256 i = 0; i < dragosTokenId.length; i++)
829         {
830             require(dragosContract.ownerOf(dragosTokenId[i]) == from, "You don't own that Dragos");
831 
832             dragosContract.transferFrom(from, address(this), dragosTokenId[i]);
833 
834             dragosStakedAddress[from].push(dragosTokenId[i]);
835             dragosAddressStakeLength[from]++;
836 
837             tokenStakePayout[dragosTokenId[i]] = reward;
838             addressOfDragosStaker[dragosTokenId[i]] = from;
839             if(stakingTypeIndex > 1)
840             {
841                 dragosClaimDate[dragosTokenId[i]] = claimDate;
842             }
843             dragosStakeDate[dragosTokenId[i]] = block.timestamp;
844         }
845     }
846 
847     function calculateReward(uint256 tokenId) internal view returns(uint256)
848     {
849         uint256 payout;
850         if(tokenStakePayout[tokenId] == 1)
851         {
852             payout = (((block.timestamp - dragosStakeDate[tokenId]) * 1 ether) / 1 days) / 2;
853 
854             if(payout > (29 * 1 ether))
855             {
856                 payout = 29 * 1 ether;
857             }
858         }
859         else{
860             return tokenStakePayout[tokenId] * 1 ether;
861         }
862 
863         return payout;
864     }
865 
866     function claimDragos(uint256[] memory dragosTokenId) external
867     {
868         uint256 reward;
869         address _to = _msgSender();
870         for(uint256 i = 0; i < dragosTokenId.length; i++)
871         {
872             require(addressOfDragosStaker[dragosTokenId[i]] == _to, "You are not the staker of this Dragos");
873             require(block.timestamp >= dragosClaimDate[dragosTokenId[i]], "Dragos cannot be unstaked yet");
874 
875             reward += calculateReward(dragosTokenId[i]);
876 
877             delete tokenStakePayout[dragosTokenId[i]];
878             delete addressOfDragosStaker[dragosTokenId[i]];
879             delete dragosClaimDate[dragosTokenId[i]];
880             delete dragosStakeDate[dragosTokenId[i]];
881 
882             dragosContract.transferFrom(address(this), _to, dragosTokenId[i]);
883         }
884 
885          _mint(_to, reward);
886         emit RewardPaid(_to, reward);
887     }
888 
889     function hasDragosBeenStaked(uint256 tokenId) public view returns(bool)
890     {
891         if(addressOfDragosStaker[tokenId] == address(0))
892         {
893             return false;
894         }
895 
896         return true;
897     }
898 
899     function currentTime() external view returns(uint256){
900         return block.timestamp;
901     }
902 
903     function dragosUnstakeTime(uint256 tokenId) external view returns(uint256){
904         require(dragosClaimDate[tokenId] > 0, "Dragos has not been staked");
905         return dragosClaimDate[tokenId];
906     }
907 
908     function setStakingOpen() external onlyOwner {
909         stakingOpen = !stakingOpen;
910     }
911 
912     function setDragosContract(address _address) public onlyOwner {
913         dragosContract = IDragos(_address);
914     }
915 
916 	function burn(address _from, uint256 _amount) external {
917 		require(_from == _msgSender(), "You do not own those tokens");
918 		_burn(_from, _amount);
919 	}
920 }