1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 library SafeMath {
15     /**
16      * @dev Returns the addition of two unsigned integers, reverting on
17      * overflow.
18      *
19      * Counterpart to Solidity's `+` operator.
20      *
21      * Requirements:
22      *
23      * - Addition cannot overflow.
24      */
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28 
29         return c;
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, reverting on
34      * overflow (when the result is negative).
35      *
36      * Counterpart to Solidity's `-` operator.
37      *
38      * Requirements:
39      *
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      *
54      * - Subtraction cannot overflow.
55      */
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     /**
64      * @dev Returns the multiplication of two unsigned integers, reverting on
65      * overflow.
66      *
67      * Counterpart to Solidity's `*` operator.
68      *
69      * Requirements:
70      *
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      *
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      *
113      * - The divisor cannot be zero.
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
125      * Reverts when dividing by zero.
126      *
127      * Counterpart to Solidity's `%` operator. This function uses a `revert`
128      * opcode (which leaves remaining gas untouched) while Solidity uses an
129      * invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b != 0, errorMessage);
153         return a % b;
154     }
155 }
156 
157 library Address {
158     /**
159      * @dev Returns true if `account` is a contract.
160      *
161      * [IMPORTANT]
162      * ====
163      * It is unsafe to assume that an address for which this function returns
164      * false is an externally-owned account (EOA) and not a contract.
165      *
166      * Among others, `isContract` will return false for the following
167      * types of addresses:
168      *
169      *  - an externally-owned account
170      *  - a contract in construction
171      *  - an address where a contract will be created
172      *  - an address where a contract lived, but was destroyed
173      * ====
174      */
175     function isContract(address account) internal view returns (bool) {
176         // This method relies in extcodesize, which returns 0 for contracts in
177         // construction, since the code is only stored at the end of the
178         // constructor execution.
179 
180         uint256 size;
181         // solhint-disable-next-line no-inline-assembly
182         assembly { size := extcodesize(account) }
183         return size > 0;
184     }
185 
186     /**
187      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
188      * `recipient`, forwarding all available gas and reverting on errors.
189      *
190      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
191      * of certain opcodes, possibly making contracts go over the 2300 gas limit
192      * imposed by `transfer`, making them unable to receive funds via
193      * `transfer`. {sendValue} removes this limitation.
194      *
195      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
196      *
197      * IMPORTANT: because control is transferred to `recipient`, care must be
198      * taken to not create reentrancy vulnerabilities. Consider using
199      * {ReentrancyGuard} or the
200      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
201      */
202     function sendValue(address payable recipient, uint256 amount) internal {
203         require(address(this).balance >= amount, "Address: insufficient balance");
204 
205         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
206         (bool success, ) = recipient.call{ value: amount }("");
207         require(success, "Address: unable to send value, recipient may have reverted");
208     }
209 
210     /**
211      * @dev Performs a Solidity function call using a low level `call`. A
212      * plain`call` is an unsafe replacement for a function call: use this
213      * function instead.
214      *
215      * If `target` reverts with a revert reason, it is bubbled up by this
216      * function (like regular Solidity function calls).
217      *
218      * Returns the raw returned data. To convert to the expected return value,
219      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
220      *
221      * Requirements:
222      *
223      * - `target` must be a contract.
224      * - calling `target` with `data` must not revert.
225      *
226      * _Available since v3.1._
227      */
228     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
229       return functionCall(target, data, "Address: low-level call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
234      * `errorMessage` as a fallback revert reason when `target` reverts.
235      *
236      * _Available since v3.1._
237      */
238     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
239         return _functionCallWithValue(target, data, 0, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but also transferring `value` wei to `target`.
245      *
246      * Requirements:
247      *
248      * - the calling contract must have an ETH balance of at least `value`.
249      * - the called Solidity function must be `payable`.
250      *
251      * _Available since v3.1._
252      */
253     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
254         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
259      * with `errorMessage` as a fallback revert reason when `target` reverts.
260      *
261      * _Available since v3.1._
262      */
263     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
264         require(address(this).balance >= value, "Address: insufficient balance for call");
265         return _functionCallWithValue(target, data, value, errorMessage);
266     }
267 
268     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
269         require(isContract(target), "Address: call to non-contract");
270 
271         // solhint-disable-next-line avoid-low-level-calls
272         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 // solhint-disable-next-line no-inline-assembly
281                 assembly {
282                     let returndata_size := mload(returndata)
283                     revert(add(32, returndata), returndata_size)
284                 }
285             } else {
286                 revert(errorMessage);
287             }
288         }
289     }
290 }
291 
292 /**
293  * @dev Interface of the ERC20 standard as defined in the EIP.
294  */
295 interface IERC20 {
296     /**
297      * @dev Returns the amount of tokens in existence.
298      */
299     function totalSupply() external view returns (uint256);
300 
301     /**
302      * @dev Returns the amount of tokens owned by `account`.
303      */
304     function balanceOf(address account) external view returns (uint256);
305 
306     /**
307      * @dev Moves `amount` tokens from the caller's account to `recipient`.
308      *
309      * Returns a boolean value indicating whether the operation succeeded.
310      *
311      * Emits a {Transfer} event.
312      */
313     function transfer(address recipient, uint256 amount) external returns (bool);
314 
315     /**
316      * @dev Returns the remaining number of tokens that `spender` will be
317      * allowed to spend on behalf of `owner` through {transferFrom}. This is
318      * zero by default.
319      *
320      * This value changes when {approve} or {transferFrom} are called.
321      */
322     function allowance(address owner, address spender) external view returns (uint256);
323 
324     /**
325      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * IMPORTANT: Beware that changing an allowance with this method brings the risk
330      * that someone may use both the old and the new allowance by unfortunate
331      * transaction ordering. One possible solution to mitigate this race
332      * condition is to first reduce the spender's allowance to 0 and set the
333      * desired value afterwards:
334      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
335      *
336      * Emits an {Approval} event.
337      */
338     function approve(address spender, uint256 amount) external returns (bool);
339 
340     /**
341      * @dev Moves `amount` tokens from `sender` to `recipient` using the
342      * allowance mechanism. `amount` is then deducted from the caller's
343      * allowance.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * Emits a {Transfer} event.
348      */
349     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
350 
351     /**
352      * @dev Emitted when `value` tokens are moved from one account (`from`) to
353      * another (`to`).
354      *
355      * Note that `value` may be zero.
356      */
357     event Transfer(address indexed from, address indexed to, uint256 value);
358 
359     /**
360      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
361      * a call to {approve}. `value` is the new allowance.
362      */
363     event Approval(address indexed owner, address indexed spender, uint256 value);
364 }
365 
366 
367 /**
368  * @dev Implementation of the {IERC20} interface.
369  *
370  * This implementation is agnostic to the way tokens are created. This means
371  * that a supply mechanism has to be added in a derived contract using {_mint}.
372  * For a generic mechanism see {ERC20PresetMinterPauser}.
373  *
374  * TIP: For a detailed writeup see our guide
375  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
376  * to implement supply mechanisms].
377  *
378  * We have followed general OpenZeppelin guidelines: functions revert instead
379  * of returning `false` on failure. This behavior is nonetheless conventional
380  * and does not conflict with the expectations of ERC20 applications.
381  *
382  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
383  * This allows applications to reconstruct the allowance for all accounts just
384  * by listening to said events. Other implementations of the EIP may not emit
385  * these events, as it isn't required by the specification.
386  *
387  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
388  * functions have been added to mitigate the well-known issues around setting
389  * allowances. See {IERC20-approve}.
390  */
391 contract ERC20 is Context, IERC20 {
392     using SafeMath for uint256;
393     using Address for address;
394 
395     mapping (address => uint256) private _balances;
396 
397     mapping (address => mapping (address => uint256)) private _allowances;
398 
399     uint256 private _totalSupply;
400 
401     string private _name;
402     string private _symbol;
403     uint8 private _decimals;
404 
405     /**
406      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
407      * a default value of 18.
408      *
409      * To select a different value for {decimals}, use {_setupDecimals}.
410      *
411      * All three of these values are immutable: they can only be set once during
412      * construction.
413      */
414     constructor (string memory name, string memory symbol) public {
415         _name = name;
416         _symbol = symbol;
417         _decimals = 18;
418     }
419 
420     /**
421      * @dev Returns the name of the token.
422      */
423     function name() public view returns (string memory) {
424         return _name;
425     }
426 
427     /**
428      * @dev Returns the symbol of the token, usually a shorter version of the
429      * name.
430      */
431     function symbol() public view returns (string memory) {
432         return _symbol;
433     }
434 
435     /**
436      * @dev Returns the number of decimals used to get its user representation.
437      * For example, if `decimals` equals `2`, a balance of `505` tokens should
438      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
439      *
440      * Tokens usually opt for a value of 18, imitating the relationship between
441      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
442      * called.
443      *
444      * NOTE: This information is only used for _display_ purposes: it in
445      * no way affects any of the arithmetic of the contract, including
446      * {IERC20-balanceOf} and {IERC20-transfer}.
447      */
448     function decimals() public view returns (uint8) {
449         return _decimals;
450     }
451 
452     /**
453      * @dev See {IERC20-totalSupply}.
454      */
455     function totalSupply() public view override returns (uint256) {
456         return _totalSupply;
457     }
458 
459     /**
460      * @dev See {IERC20-balanceOf}.
461      */
462     function balanceOf(address account) public view override returns (uint256) {
463         return _balances[account];
464     }
465 
466     /**
467      * @dev See {IERC20-transfer}.
468      *
469      * Requirements:
470      *
471      * - `recipient` cannot be the zero address.
472      * - the caller must have a balance of at least `amount`.
473      */
474     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
475         _transfer(_msgSender(), recipient, amount);
476         return true;
477     }
478 
479     /**
480      * @dev See {IERC20-allowance}.
481      */
482     function allowance(address owner, address spender) public view virtual override returns (uint256) {
483         return _allowances[owner][spender];
484     }
485 
486     /**
487      * @dev See {IERC20-approve}.
488      *
489      * Requirements:
490      *
491      * - `spender` cannot be the zero address.
492      */
493     function approve(address spender, uint256 amount) public virtual override returns (bool) {
494         _approve(_msgSender(), spender, amount);
495         return true;
496     }
497 
498     /**
499      * @dev See {IERC20-transferFrom}.
500      *
501      * Emits an {Approval} event indicating the updated allowance. This is not
502      * required by the EIP. See the note at the beginning of {ERC20};
503      *
504      * Requirements:
505      * - `sender` and `recipient` cannot be the zero address.
506      * - `sender` must have a balance of at least `amount`.
507      * - the caller must have allowance for ``sender``'s tokens of at least
508      * `amount`.
509      */
510     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
511         _transfer(sender, recipient, amount);
512         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
513         return true;
514     }
515 
516     /**
517      * @dev Atomically increases the allowance granted to `spender` by the caller.
518      *
519      * This is an alternative to {approve} that can be used as a mitigation for
520      * problems described in {IERC20-approve}.
521      *
522      * Emits an {Approval} event indicating the updated allowance.
523      *
524      * Requirements:
525      *
526      * - `spender` cannot be the zero address.
527      */
528     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
529         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
530         return true;
531     }
532 
533     /**
534      * @dev Atomically decreases the allowance granted to `spender` by the caller.
535      *
536      * This is an alternative to {approve} that can be used as a mitigation for
537      * problems described in {IERC20-approve}.
538      *
539      * Emits an {Approval} event indicating the updated allowance.
540      *
541      * Requirements:
542      *
543      * - `spender` cannot be the zero address.
544      * - `spender` must have allowance for the caller of at least
545      * `subtractedValue`.
546      */
547     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
548         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
549         return true;
550     }
551 
552     /**
553      * @dev Moves tokens `amount` from `sender` to `recipient`.
554      *
555      * This is internal function is equivalent to {transfer}, and can be used to
556      * e.g. implement automatic token fees, slashing mechanisms, etc.
557      *
558      * Emits a {Transfer} event.
559      *
560      * Requirements:
561      *
562      * - `sender` cannot be the zero address.
563      * - `recipient` cannot be the zero address.
564      * - `sender` must have a balance of at least `amount`.
565      */
566     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
567         require(sender != address(0), "ERC20: transfer from the zero address");
568         require(recipient != address(0), "ERC20: transfer to the zero address");
569 
570         _beforeTokenTransfer(sender, recipient, amount);
571 
572         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
573         _balances[recipient] = _balances[recipient].add(amount);
574         emit Transfer(sender, recipient, amount);
575     }
576 
577     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
578      * the total supply.
579      *
580      * Emits a {Transfer} event with `from` set to the zero address.
581      *
582      * Requirements
583      *
584      * - `to` cannot be the zero address.
585      */
586     function _mint(address account, uint256 amount) internal virtual {
587         require(account != address(0), "ERC20: mint to the zero address");
588 
589         _beforeTokenTransfer(address(0), account, amount);
590 
591         _totalSupply = _totalSupply.add(amount);
592         _balances[account] = _balances[account].add(amount);
593         emit Transfer(address(0), account, amount);
594     }
595 
596     /**
597      * @dev Destroys `amount` tokens from `account`, reducing the
598      * total supply.
599      *
600      * Emits a {Transfer} event with `to` set to the zero address.
601      *
602      * Requirements
603      *
604      * - `account` cannot be the zero address.
605      * - `account` must have at least `amount` tokens.
606      */
607     function _burn(address account, uint256 amount) internal virtual {
608         require(account != address(0), "ERC20: burn from the zero address");
609 
610         _beforeTokenTransfer(account, address(0), amount);
611 
612         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
613         _totalSupply = _totalSupply.sub(amount);
614         emit Transfer(account, address(0), amount);
615     }
616 
617     /**
618      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
619      *
620      * This internal function is equivalent to `approve`, and can be used to
621      * e.g. set automatic allowances for certain subsystems, etc.
622      *
623      * Emits an {Approval} event.
624      *
625      * Requirements:
626      *
627      * - `owner` cannot be the zero address.
628      * - `spender` cannot be the zero address.
629      */
630     function _approve(address owner, address spender, uint256 amount) internal virtual {
631         require(owner != address(0), "ERC20: approve from the zero address");
632         require(spender != address(0), "ERC20: approve to the zero address");
633 
634         _allowances[owner][spender] = amount;
635         emit Approval(owner, spender, amount);
636     }
637 
638     /**
639      * @dev Sets {decimals} to a value other than the default one of 18.
640      *
641      * WARNING: This function should only be called from the constructor. Most
642      * applications that interact with token contracts will not expect
643      * {decimals} to ever change, and may work incorrectly if it does.
644      */
645     function _setupDecimals(uint8 decimals_) internal {
646         _decimals = decimals_;
647     }
648 
649     /**
650      * @dev Hook that is called before any transfer of tokens. This includes
651      * minting and burning.
652      *
653      * Calling conditions:
654      *
655      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
656      * will be to transferred to `to`.
657      * - when `from` is zero, `amount` tokens will be minted for `to`.
658      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
659      * - `from` and `to` are never both zero.
660      *
661      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
662      */
663     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
664 }
665 
666 /**
667  * @dev Contract module which provides a basic access control mechanism, where
668  * there is an account (an owner) that can be granted exclusive access to
669  * specific functions.
670  *
671  * By default, the owner account will be the one that deploys the contract. This
672  * can later be changed with {transferOwnership}.
673  *
674  * This module is used through inheritance. It will make available the modifier
675  * `onlyOwner`, which can be applied to your functions to restrict their use to
676  * the owner.
677  */
678 contract Ownable is Context {
679     address private _owner;
680 
681     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
682 
683     /**
684      * @dev Initializes the contract setting the deployer as the initial owner.
685      */
686     constructor () internal {
687         address msgSender = _msgSender();
688         _owner = msgSender;
689         emit OwnershipTransferred(address(0), msgSender);
690     }
691 
692     /**
693      * @dev Returns the address of the current owner.
694      */
695     function owner() public view returns (address) {
696         return _owner;
697     }
698 
699     /**
700      * @dev Throws if called by any account other than the owner.
701      */
702     modifier onlyOwner() {
703         require(_owner == _msgSender(), "Ownable: caller is not the owner");
704         _;
705     }
706 
707     /**
708      * @dev Leaves the contract without owner. It will not be possible to call
709      * `onlyOwner` functions anymore. Can only be called by the current owner.
710      *
711      * NOTE: Renouncing ownership will leave the contract without an owner,
712      * thereby removing any functionality that is only available to the owner.
713      */
714     function renounceOwnership() public virtual onlyOwner {
715         emit OwnershipTransferred(_owner, address(0));
716         _owner = address(0);
717     }
718 
719     /**
720      * @dev Transfers ownership of the contract to a new account (`newOwner`).
721      * Can only be called by the current owner.
722      */
723     function transferOwnership(address newOwner) public virtual onlyOwner {
724         require(newOwner != address(0), "Ownable: new owner is the zero address");
725         emit OwnershipTransferred(_owner, newOwner);
726         _owner = newOwner;
727     }
728 }
729 
730 // This token is owned by Timelock.
731 contract ROC is ERC20("Roxe Cash", "ROC"), Ownable {
732 
733     mapping(address => bool) public issuerMap;
734 
735     modifier onlyIssuer() {
736         require(issuerMap[msg.sender], "The caller does not have issuer role privileges");
737         _;
738     }
739 
740     function setIssuer(address _issuer, bool _isIssuer) external onlyOwner {
741         issuerMap[_issuer] = _isIssuer;
742     }
743 
744     /// @notice Creates `_amount` token to `_to`.
745     function mint(address _to, uint256 _amount) external onlyIssuer {
746         _mint(_to, _amount);
747         _moveDelegates(address(0), _delegates[_to], _amount);
748     }
749 
750     // transfers delegate authority when sending a token.
751     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
752         super._transfer(sender, recipient, amount);
753         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
754     }
755 
756     function burn(uint256 _amount) external {
757         _burn(_msgSender(), _amount);
758         _moveDelegates(_delegates[_msgSender()], address(0), _amount);
759     }
760 
761     /// @dev @notice A record of each accounts delegate
762     mapping (address => address) internal _delegates;
763 
764     /// @notice A checkpoint for marking number of votes from a given block
765     struct Checkpoint {
766         uint32 fromBlock;
767         uint256 votes;
768     }
769 
770     /// @notice A record of votes checkpoints for each account, by index
771     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
772 
773     /// @notice The number of checkpoints for each account
774     mapping (address => uint32) public numCheckpoints;
775 
776     /// @notice The EIP-712 typehash for the contract's domain
777     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
778 
779     /// @notice The EIP-712 typehash for the delegation struct used by the contract
780     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
781 
782     /// @notice A record of states for signing / validating signatures
783     mapping (address => uint) public nonces;
784 
785       /// @notice An event thats emitted when an account changes its delegate
786     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
787 
788     /// @notice An event thats emitted when a delegate account's vote balance changes
789     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
790 
791     /**
792      * @notice Delegate votes from `msg.sender` to `delegatee`
793      * @param delegator The address to get delegatee for
794      */
795     function delegates(address delegator)
796         external
797         view
798         returns (address)
799     {
800         return _delegates[delegator];
801     }
802 
803    /**
804     * @notice Delegate votes from `msg.sender` to `delegatee`
805     * @param delegatee The address to delegate votes to
806     */
807     function delegate(address delegatee) external {
808         return _delegate(msg.sender, delegatee);
809     }
810 
811     /**
812      * @notice Delegates votes from signatory to `delegatee`
813      * @param delegatee The address to delegate votes to
814      * @param nonce The contract state required to match the signature
815      * @param expiry The time at which to expire the signature
816      * @param v The recovery byte of the signature
817      * @param r Half of the ECDSA signature pair
818      * @param s Half of the ECDSA signature pair
819      */
820     function delegateBySig(
821         address delegatee,
822         uint nonce,
823         uint expiry,
824         uint8 v,
825         bytes32 r,
826         bytes32 s
827     )
828         external
829     {
830         bytes32 domainSeparator = keccak256(
831             abi.encode(
832                 DOMAIN_TYPEHASH,
833                 keccak256(bytes(name())),
834                 getChainId(),
835                 address(this)
836             )
837         );
838 
839         bytes32 structHash = keccak256(
840             abi.encode(
841                 DELEGATION_TYPEHASH,
842                 delegatee,
843                 nonce,
844                 expiry
845             )
846         );
847 
848         bytes32 digest = keccak256(
849             abi.encodePacked(
850                 "\x19\x01",
851                 domainSeparator,
852                 structHash
853             )
854         );
855 
856         address signatory = ecrecover(digest, v, r, s);
857         require(signatory != address(0), "ROC::delegateBySig: invalid signature");
858         require(nonce == nonces[signatory]++, "ROC::delegateBySig: invalid nonce");
859         require(now <= expiry, "ROC::delegateBySig: signature expired");
860         return _delegate(signatory, delegatee);
861     }
862 
863     /**
864      * @notice Gets the current votes balance for `account`
865      * @param account The address to get votes balance
866      * @return The number of current votes for `account`
867      */
868     function getCurrentVotes(address account)
869         external
870         view
871         returns (uint256)
872     {
873         uint32 nCheckpoints = numCheckpoints[account];
874         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
875     }
876 
877     /**
878      * @notice Determine the prior number of votes for an account as of a block number
879      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
880      * @param account The address of the account to check
881      * @param blockNumber The block number to get the vote balance at
882      * @return The number of votes the account had as of the given block
883      */
884     function getPriorVotes(address account, uint blockNumber)
885         external
886         view
887         returns (uint256)
888     {
889         require(blockNumber < block.number, "ROC::getPriorVotes: not yet determined");
890 
891         uint32 nCheckpoints = numCheckpoints[account];
892         if (nCheckpoints == 0) {
893             return 0;
894         }
895 
896         // First check most recent balance
897         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
898             return checkpoints[account][nCheckpoints - 1].votes;
899         }
900 
901         // Next check implicit zero balance
902         if (checkpoints[account][0].fromBlock > blockNumber) {
903             return 0;
904         }
905 
906         uint32 lower = 0;
907         uint32 upper = nCheckpoints - 1;
908         while (upper > lower) {
909             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
910             Checkpoint memory cp = checkpoints[account][center];
911             if (cp.fromBlock == blockNumber) {
912                 return cp.votes;
913             } else if (cp.fromBlock < blockNumber) {
914                 lower = center;
915             } else {
916                 upper = center - 1;
917             }
918         }
919         return checkpoints[account][lower].votes;
920     }
921 
922     function _delegate(address delegator, address delegatee)
923         internal
924     {
925         address currentDelegate = _delegates[delegator];
926         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying ROCs (not scaled);
927         _delegates[delegator] = delegatee;
928 
929         emit DelegateChanged(delegator, currentDelegate, delegatee);
930 
931         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
932     }
933 
934     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
935         if (srcRep != dstRep && amount > 0) {
936             if (srcRep != address(0)) {
937                 // decrease old representative
938                 uint32 srcRepNum = numCheckpoints[srcRep];
939                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
940                 uint256 srcRepNew = srcRepOld.sub(amount);
941                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
942             }
943 
944             if (dstRep != address(0)) {
945                 // increase new representative
946                 uint32 dstRepNum = numCheckpoints[dstRep];
947                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
948                 uint256 dstRepNew = dstRepOld.add(amount);
949                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
950             }
951         }
952     }
953 
954     function _writeCheckpoint(
955         address delegatee,
956         uint32 nCheckpoints,
957         uint256 oldVotes,
958         uint256 newVotes
959     )
960         internal
961     {
962         uint32 blockNumber = safe32(block.number, "ROC::_writeCheckpoint: block number exceeds 32 bits");
963 
964         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
965             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
966         } else {
967             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
968             numCheckpoints[delegatee] = nCheckpoints + 1;
969         }
970 
971         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
972     }
973 
974     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
975         require(n < 2**32, errorMessage);
976         return uint32(n);
977     }
978 
979     function getChainId() internal pure returns (uint) {
980         uint256 chainId;
981         assembly { chainId := chainid() }
982         return chainId;
983     }
984 }