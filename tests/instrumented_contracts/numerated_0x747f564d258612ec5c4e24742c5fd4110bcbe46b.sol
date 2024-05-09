1 // SPDX-License-Identifier: MIT
2 /*
3  * @dev Provides information about the current execution context, including the
4  * sender of the transaction and its data. While these are generally available
5  * via msg.sender and msg.data, they should not be accessed in such a direct
6  * manner, since when dealing with GSN meta-transactions the account sending and
7  * paying for execution may not be the actual sender (as far as an application
8  * is concerned).
9  *
10  * This contract is only required for intermediate, library-like contracts.
11  */
12 
13 pragma solidity ^0.6.12;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 
28 
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b <= a, errorMessage);
149         uint256 c = a - b;
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      *
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166         // benefit is lost if 'b' is also tested.
167         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "SafeMath: multiplication overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b) internal pure returns (uint256) {
191         return div(a, b, "SafeMath: division by zero");
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b > 0, errorMessage);
208         uint256 c = a / b;
209         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return mod(a, b, "SafeMath: modulo by zero");
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts with custom message when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b != 0, errorMessage);
244         return a % b;
245     }
246 }
247 
248 
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
269         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
270         // for accounts without code, i.e. `keccak256('')`
271         bytes32 codehash;
272         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { codehash := extcodehash(account) }
275         return (codehash != accountHash && codehash != 0x0);
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{ value: amount }("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321       return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331         return _functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         return _functionCallWithValue(target, data, value, errorMessage);
358     }
359 
360     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
361         require(isContract(target), "Address: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371 
372                 // solhint-disable-next-line no-inline-assembly
373                 assembly {
374                     let returndata_size := mload(returndata)
375                     revert(add(32, returndata), returndata_size)
376                 }
377             } else {
378                 revert(errorMessage);
379             }
380         }
381     }
382 }
383 
384 
385 
386 
387 
388 
389 
390 
391 
392 
393 
394 
395 
396 
397 
398 
399 
400 
401 
402 
403 
404 
405 
406 
407 contract ERC20 is Context, IERC20 {
408     using SafeMath for uint256;
409     using Address for address;
410 
411     mapping (address => uint256) private _balances;
412 
413     mapping (address => mapping (address => uint256)) private _allowances;
414 
415     uint256 private _totalSupply;
416 
417     string private _name;
418     string private _symbol;
419     uint8 private _decimals;
420 
421     /**
422      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
423      * a default value of 18.
424      *
425      * To select a different value for {decimals}, use {_setupDecimals}.
426      *
427      * All three of these values are immutable: they can only be set once during
428      * construction.
429      */
430     constructor (string memory name, string memory symbol) public {
431         _name = name;
432         _symbol = symbol;
433         _decimals = 18;
434     }
435 
436     /**
437      * @dev Returns the name of the token.
438      */
439     function name() public view returns (string memory) {
440         return _name;
441     }
442 
443     /**
444      * @dev Returns the symbol of the token, usually a shorter version of the
445      * name.
446      */
447     function symbol() public view returns (string memory) {
448         return _symbol;
449     }
450 
451     /**
452      * @dev Returns the number of decimals used to get its user representation.
453      * For example, if `decimals` equals `2`, a balance of `505` tokens should
454      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
455      *
456      * Tokens usually opt for a value of 18, imitating the relationship between
457      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
458      * called.
459      *
460      * NOTE: This information is only used for _display_ purposes: it in
461      * no way affects any of the arithmetic of the contract, including
462      * {IERC20-balanceOf} and {IERC20-transfer}.
463      */
464     function decimals() public view returns (uint8) {
465         return _decimals;
466     }
467 
468     /**
469      * @dev See {IERC20-totalSupply}.
470      */
471     function totalSupply() public view override returns (uint256) {
472         return _totalSupply;
473     }
474 
475     /**
476      * @dev See {IERC20-balanceOf}.
477      */
478     function balanceOf(address account) public view override returns (uint256) {
479         return _balances[account];
480     }
481 
482     /**
483      * @dev See {IERC20-transfer}.
484      *
485      * Requirements:
486      *
487      * - `recipient` cannot be the zero address.
488      * - the caller must have a balance of at least `amount`.
489      */
490     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
491         _transfer(_msgSender(), recipient, amount);
492         return true;
493     }
494 
495     /**
496      * @dev See {IERC20-allowance}.
497      */
498     function allowance(address owner, address spender) public view virtual override returns (uint256) {
499         return _allowances[owner][spender];
500     }
501 
502     /**
503      * @dev See {IERC20-approve}.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      */
509     function approve(address spender, uint256 amount) public virtual override returns (bool) {
510         _approve(_msgSender(), spender, amount);
511         return true;
512     }
513 
514     /**
515      * @dev See {IERC20-transferFrom}.
516      *
517      * Emits an {Approval} event indicating the updated allowance. This is not
518      * required by the EIP. See the note at the beginning of {ERC20};
519      *
520      * Requirements:
521      * - `sender` and `recipient` cannot be the zero address.
522      * - `sender` must have a balance of at least `amount`.
523      * - the caller must have allowance for ``sender``'s tokens of at least
524      * `amount`.
525      */
526     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
527         _transfer(sender, recipient, amount);
528         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
529         return true;
530     }
531 
532     /**
533      * @dev Atomically increases the allowance granted to `spender` by the caller.
534      *
535      * This is an alternative to {approve} that can be used as a mitigation for
536      * problems described in {IERC20-approve}.
537      *
538      * Emits an {Approval} event indicating the updated allowance.
539      *
540      * Requirements:
541      *
542      * - `spender` cannot be the zero address.
543      */
544     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
545         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
546         return true;
547     }
548 
549     /**
550      * @dev Atomically decreases the allowance granted to `spender` by the caller.
551      *
552      * This is an alternative to {approve} that can be used as a mitigation for
553      * problems described in {IERC20-approve}.
554      *
555      * Emits an {Approval} event indicating the updated allowance.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      * - `spender` must have allowance for the caller of at least
561      * `subtractedValue`.
562      */
563     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
564         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
565         return true;
566     }
567 
568     /**
569      * @dev Moves tokens `amount` from `sender` to `recipient`.
570      *
571      * This is internal function is equivalent to {transfer}, and can be used to
572      * e.g. implement automatic token fees, slashing mechanisms, etc.
573      *
574      * Emits a {Transfer} event.
575      *
576      * Requirements:
577      *
578      * - `sender` cannot be the zero address.
579      * - `recipient` cannot be the zero address.
580      * - `sender` must have a balance of at least `amount`.
581      */
582     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
583         require(sender != address(0), "ERC20: transfer from the zero address");
584         require(recipient != address(0), "ERC20: transfer to the zero address");
585 
586         _beforeTokenTransfer(sender, recipient, amount);
587 
588         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
589         _balances[recipient] = _balances[recipient].add(amount);
590         emit Transfer(sender, recipient, amount);
591     }
592 
593     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
594      * the total supply.
595      *
596      * Emits a {Transfer} event with `from` set to the zero address.
597      *
598      * Requirements
599      *
600      * - `to` cannot be the zero address.
601      */
602     function _supply(address account, uint256 amount) internal virtual {
603         require(account != address(0), "ERC20: supply to the zero address");
604 
605         _beforeTokenTransfer(address(0), account, amount);
606 
607         _totalSupply = _totalSupply.add(amount);
608         _balances[account] = _balances[account].add(amount);
609         emit Transfer(address(0), account, amount);
610     }
611 
612     /**
613      * @dev Destroys `amount` tokens from `account`, reducing the
614      * total supply.
615      *
616      * Emits a {Transfer} event with `to` set to the zero address.
617      *
618      * Requirements
619      *
620      * - `account` cannot be the zero address.
621      * - `account` must have at least `amount` tokens.
622      */
623     function _burn(address account, uint256 amount) internal virtual {
624         require(account != address(0), "ERC20: burn from the zero address");
625 
626         _beforeTokenTransfer(account, address(0), amount);
627 
628         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
629         _totalSupply = _totalSupply.sub(amount);
630         emit Transfer(account, address(0), amount);
631     }
632 
633     /**
634      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
635      *
636      * This is internal function is equivalent to `approve`, and can be used to
637      * e.g. set automatic allowances for certain subsystems, etc.
638      *
639      * Emits an {Approval} event.
640      *
641      * Requirements:
642      *
643      * - `owner` cannot be the zero address.
644      * - `spender` cannot be the zero address.
645      */
646     function _approve(address owner, address spender, uint256 amount) internal virtual {
647         require(owner != address(0), "ERC20: approve from the zero address");
648         require(spender != address(0), "ERC20: approve to the zero address");
649 
650         _allowances[owner][spender] = amount;
651         emit Approval(owner, spender, amount);
652     }
653 
654     /**
655      * @dev Sets {decimals} to a value other than the default one of 18.
656      *
657      * WARNING: This function should only be called from the constructor. Most
658      * applications that interact with token contracts will not expect
659      * {decimals} to ever change, and may work incorrectly if it does.
660      */
661     function _setupDecimals(uint8 decimals_) internal {
662         _decimals = decimals_;
663     }
664 
665     /**
666      * @dev Hook that is called before any transfer of tokens. This includes
667      * supplying and burning.
668      *
669      * Calling conditions:
670      *
671      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
672      * will be to transferred to `to`.
673      * - when `from` is zero, `amount` tokens will be supplyed for `to`.
674      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
675      * - `from` and `to` are never both zero.
676      *
677      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
678      */
679     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
680 }
681 
682 
683 /**
684  * @dev Contract module which provides a basic access control mechanism, where
685  * there is an account (an owner) that can be granted exclusive access to
686  * specific functions.
687  *
688  * By default, the owner account will be the one that deploys the contract. This
689  * can later be changed with {transferOwnership}.
690  *
691  * This module is used through inheritance. It will make available the modifier
692  * `onlyOwner`, which can be applied to your functions to restrict their use to
693  * the owner.
694  */
695 contract Ownable is Context {
696     address private _owner;
697 
698     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
699 
700     /**
701      * @dev Initializes the contract setting the deployer as the initial owner.
702      */
703     constructor () internal {
704         address msgSender = _msgSender();
705         _owner = msgSender;
706         emit OwnershipTransferred(address(0), msgSender);
707     }
708 
709     /**
710      * @dev Returns the address of the current owner.
711      */
712     function owner() public view returns (address) {
713         return _owner;
714     }
715 
716     /**
717      * @dev Throws if called by any account other than the owner.
718      */
719     modifier onlyOwner() {
720         require(_owner == _msgSender(), "Ownable: caller is not the owner");
721         _;
722     }
723 
724     /**
725      * @dev Leaves the contract without owner. It will not be possible to call
726      * `onlyOwner` functions anymore. Can only be called by the current owner.
727      *
728      * NOTE: Renouncing ownership will leave the contract without an owner,
729      * thereby removing any functionality that is only available to the owner.
730      */
731     function renounceOwnership() public virtual onlyOwner {
732         emit OwnershipTransferred(_owner, address(0));
733         _owner = address(0);
734     }
735 
736     /**
737      * @dev Transfers ownership of the contract to a new account (`newOwner`).
738      * Can only be called by the current owner.
739      */
740     function transferOwnership(address newOwner) public virtual onlyOwner {
741         require(newOwner != address(0), "Ownable: new owner is the zero address");
742         emit OwnershipTransferred(_owner, newOwner);
743         _owner = newOwner;
744     }
745 }
746 
747 contract NDS is ERC20("Nodeseeds.com Token", "NDS"), Ownable {
748     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
749     function supply(address _to, uint256 _amount) public onlyOwner {
750         _supply(_to, _amount);
751     }
752     
753     
754      function burn(address _to, uint256 _amount) public onlyOwner {
755         _burn(_to, _amount);
756     }
757     
758     
759     
760     
761     
762     }