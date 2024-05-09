1 // hevm: flattened sources of src/pickle-jar.sol
2 pragma solidity >=0.4.23 >=0.6.0 <0.7.0 >=0.6.2 <0.7.0 >=0.6.7 <0.7.0;
3 
4 ////// src/interfaces/controller.sol
5 
6 
7 /* pragma solidity ^0.6.0; */
8 
9 interface IController {
10     function jars(address) external view returns (address);
11 
12     function rewards() external view returns (address);
13 
14     function devfund() external view returns (address);
15 
16     function treasury() external view returns (address);
17 
18     function balanceOf(address) external view returns (uint256);
19 
20     function withdraw(address, uint256) external;
21 
22     function earn(address, uint256) external;
23 }
24 
25 ////// src/lib/safe-math.sol
26 
27 
28 /* pragma solidity ^0.6.0; */
29 
30 /**
31  * @dev Wrappers over Solidity's arithmetic operations with added overflow
32  * checks.
33  *
34  * Arithmetic operations in Solidity wrap on overflow. This can easily result
35  * in bugs, because programmers usually assume that an overflow raises an
36  * error, which is the standard behavior in high level programming languages.
37  * `SafeMath` restores this intuition by reverting the transaction when an
38  * operation overflows.
39  *
40  * Using this library instead of the unchecked operations eliminates an entire
41  * class of bugs, so it's recommended to use it always.
42  */
43 library SafeMath {
44     /**
45      * @dev Returns the addition of two unsigned integers, reverting on
46      * overflow.
47      *
48      * Counterpart to Solidity's `+` operator.
49      *
50      * Requirements:
51      *
52      * - Addition cannot overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "SafeMath: addition overflow");
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting on
63      * overflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      *
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     /**
76      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
77      * overflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      *
83      * - Subtraction cannot overflow.
84      */
85     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         require(b <= a, errorMessage);
87         uint256 c = a - b;
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the multiplication of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `*` operator.
97      *
98      * Requirements:
99      *
100      * - Multiplication cannot overflow.
101      */
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104         // benefit is lost if 'b' is also tested.
105         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      *
126      * - The divisor cannot be zero.
127      */
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         return div(a, b, "SafeMath: division by zero");
130     }
131 
132     /**
133      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
134      * division by zero. The result is rounded towards zero.
135      *
136      * Counterpart to Solidity's `/` operator. Note: this function uses a
137      * `revert` opcode (which leaves remaining gas untouched) while Solidity
138      * uses an invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      *
142      * - The divisor cannot be zero.
143      */
144     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         require(b > 0, errorMessage);
146         uint256 c = a / b;
147         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
154      * Reverts when dividing by zero.
155      *
156      * Counterpart to Solidity's `%` operator. This function uses a `revert`
157      * opcode (which leaves remaining gas untouched) while Solidity uses an
158      * invalid opcode to revert (consuming all remaining gas).
159      *
160      * Requirements:
161      *
162      * - The divisor cannot be zero.
163      */
164     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
165         return mod(a, b, "SafeMath: modulo by zero");
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
170      * Reverts with custom message when dividing by zero.
171      *
172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
173      * opcode (which leaves remaining gas untouched) while Solidity uses an
174      * invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      *
178      * - The divisor cannot be zero.
179      */
180     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181         require(b != 0, errorMessage);
182         return a % b;
183     }
184 }
185 ////// src/lib/erc20.sol
186 
187 // File: contracts/GSN/Context.sol
188 
189 
190 
191 /* pragma solidity ^0.6.0; */
192 
193 /* import "./safe-math.sol"; */
194 
195 /*
196  * @dev Provides information about the current execution context, including the
197  * sender of the transaction and its data. While these are generally available
198  * via msg.sender and msg.data, they should not be accessed in such a direct
199  * manner, since when dealing with GSN meta-transactions the account sending and
200  * paying for execution may not be the actual sender (as far as an application
201  * is concerned).
202  *
203  * This contract is only required for intermediate, library-like contracts.
204  */
205 abstract contract Context {
206     function _msgSender() internal view virtual returns (address payable) {
207         return msg.sender;
208     }
209 
210     function _msgData() internal view virtual returns (bytes memory) {
211         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
212         return msg.data;
213     }
214 }
215 
216 // File: contracts/token/ERC20/IERC20.sol
217 
218 
219 /**
220  * @dev Interface of the ERC20 standard as defined in the EIP.
221  */
222 interface IERC20 {
223     /**
224      * @dev Returns the amount of tokens in existence.
225      */
226     function totalSupply() external view returns (uint256);
227 
228     /**
229      * @dev Returns the amount of tokens owned by `account`.
230      */
231     function balanceOf(address account) external view returns (uint256);
232 
233     /**
234      * @dev Moves `amount` tokens from the caller's account to `recipient`.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * Emits a {Transfer} event.
239      */
240     function transfer(address recipient, uint256 amount) external returns (bool);
241 
242     /**
243      * @dev Returns the remaining number of tokens that `spender` will be
244      * allowed to spend on behalf of `owner` through {transferFrom}. This is
245      * zero by default.
246      *
247      * This value changes when {approve} or {transferFrom} are called.
248      */
249     function allowance(address owner, address spender) external view returns (uint256);
250 
251     /**
252      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * IMPORTANT: Beware that changing an allowance with this method brings the risk
257      * that someone may use both the old and the new allowance by unfortunate
258      * transaction ordering. One possible solution to mitigate this race
259      * condition is to first reduce the spender's allowance to 0 and set the
260      * desired value afterwards:
261      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262      *
263      * Emits an {Approval} event.
264      */
265     function approve(address spender, uint256 amount) external returns (bool);
266 
267     /**
268      * @dev Moves `amount` tokens from `sender` to `recipient` using the
269      * allowance mechanism. `amount` is then deducted from the caller's
270      * allowance.
271      *
272      * Returns a boolean value indicating whether the operation succeeded.
273      *
274      * Emits a {Transfer} event.
275      */
276     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
277 
278     /**
279      * @dev Emitted when `value` tokens are moved from one account (`from`) to
280      * another (`to`).
281      *
282      * Note that `value` may be zero.
283      */
284     event Transfer(address indexed from, address indexed to, uint256 value);
285 
286     /**
287      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
288      * a call to {approve}. `value` is the new allowance.
289      */
290     event Approval(address indexed owner, address indexed spender, uint256 value);
291 }
292 
293 // File: contracts/utils/Address.sol
294 
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301      * @dev Returns true if `account` is a contract.
302      *
303      * [IMPORTANT]
304      * ====
305      * It is unsafe to assume that an address for which this function returns
306      * false is an externally-owned account (EOA) and not a contract.
307      *
308      * Among others, `isContract` will return false for the following
309      * types of addresses:
310      *
311      *  - an externally-owned account
312      *  - a contract in construction
313      *  - an address where a contract will be created
314      *  - an address where a contract lived, but was destroyed
315      * ====
316      */
317     function isContract(address account) internal view returns (bool) {
318         // This method relies on extcodesize, which returns 0 for contracts in
319         // construction, since the code is only stored at the end of the
320         // constructor execution.
321 
322         uint256 size;
323         // solhint-disable-next-line no-inline-assembly
324         assembly { size := extcodesize(account) }
325         return size > 0;
326     }
327 
328     /**
329      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
330      * `recipient`, forwarding all available gas and reverting on errors.
331      *
332      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
333      * of certain opcodes, possibly making contracts go over the 2300 gas limit
334      * imposed by `transfer`, making them unable to receive funds via
335      * `transfer`. {sendValue} removes this limitation.
336      *
337      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
338      *
339      * IMPORTANT: because control is transferred to `recipient`, care must be
340      * taken to not create reentrancy vulnerabilities. Consider using
341      * {ReentrancyGuard} or the
342      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
343      */
344     function sendValue(address payable recipient, uint256 amount) internal {
345         require(address(this).balance >= amount, "Address: insufficient balance");
346 
347         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
348         (bool success, ) = recipient.call{ value: amount }("");
349         require(success, "Address: unable to send value, recipient may have reverted");
350     }
351 
352     /**
353      * @dev Performs a Solidity function call using a low level `call`. A
354      * plain`call` is an unsafe replacement for a function call: use this
355      * function instead.
356      *
357      * If `target` reverts with a revert reason, it is bubbled up by this
358      * function (like regular Solidity function calls).
359      *
360      * Returns the raw returned data. To convert to the expected return value,
361      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
362      *
363      * Requirements:
364      *
365      * - `target` must be a contract.
366      * - calling `target` with `data` must not revert.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
371       return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376      * `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
381         return _functionCallWithValue(target, data, 0, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but also transferring `value` wei to `target`.
387      *
388      * Requirements:
389      *
390      * - the calling contract must have an ETH balance of at least `value`.
391      * - the called Solidity function must be `payable`.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
401      * with `errorMessage` as a fallback revert reason when `target` reverts.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
406         require(address(this).balance >= value, "Address: insufficient balance for call");
407         return _functionCallWithValue(target, data, value, errorMessage);
408     }
409 
410     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
411         require(isContract(target), "Address: call to non-contract");
412 
413         // solhint-disable-next-line avoid-low-level-calls
414         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
415         if (success) {
416             return returndata;
417         } else {
418             // Look for revert reason and bubble it up if present
419             if (returndata.length > 0) {
420                 // The easiest way to bubble the revert reason is using memory via assembly
421 
422                 // solhint-disable-next-line no-inline-assembly
423                 assembly {
424                     let returndata_size := mload(returndata)
425                     revert(add(32, returndata), returndata_size)
426                 }
427             } else {
428                 revert(errorMessage);
429             }
430         }
431     }
432 }
433 
434 // File: contracts/token/ERC20/ERC20.sol
435 
436 /**
437  * @dev Implementation of the {IERC20} interface.
438  *
439  * This implementation is agnostic to the way tokens are created. This means
440  * that a supply mechanism has to be added in a derived contract using {_mint}.
441  * For a generic mechanism see {ERC20PresetMinterPauser}.
442  *
443  * TIP: For a detailed writeup see our guide
444  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
445  * to implement supply mechanisms].
446  *
447  * We have followed general OpenZeppelin guidelines: functions revert instead
448  * of returning `false` on failure. This behavior is nonetheless conventional
449  * and does not conflict with the expectations of ERC20 applications.
450  *
451  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
452  * This allows applications to reconstruct the allowance for all accounts just
453  * by listening to said events. Other implementations of the EIP may not emit
454  * these events, as it isn't required by the specification.
455  *
456  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
457  * functions have been added to mitigate the well-known issues around setting
458  * allowances. See {IERC20-approve}.
459  */
460 contract ERC20 is Context, IERC20 {
461     using SafeMath for uint256;
462     using Address for address;
463 
464     mapping (address => uint256) private _balances;
465 
466     mapping (address => mapping (address => uint256)) private _allowances;
467 
468     uint256 private _totalSupply;
469 
470     string private _name;
471     string private _symbol;
472     uint8 private _decimals;
473 
474     /**
475      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
476      * a default value of 18.
477      *
478      * To select a different value for {decimals}, use {_setupDecimals}.
479      *
480      * All three of these values are immutable: they can only be set once during
481      * construction.
482      */
483     constructor (string memory name, string memory symbol) public {
484         _name = name;
485         _symbol = symbol;
486         _decimals = 18;
487     }
488 
489     /**
490      * @dev Returns the name of the token.
491      */
492     function name() public view returns (string memory) {
493         return _name;
494     }
495 
496     /**
497      * @dev Returns the symbol of the token, usually a shorter version of the
498      * name.
499      */
500     function symbol() public view returns (string memory) {
501         return _symbol;
502     }
503 
504     /**
505      * @dev Returns the number of decimals used to get its user representation.
506      * For example, if `decimals` equals `2`, a balance of `505` tokens should
507      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
508      *
509      * Tokens usually opt for a value of 18, imitating the relationship between
510      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
511      * called.
512      *
513      * NOTE: This information is only used for _display_ purposes: it in
514      * no way affects any of the arithmetic of the contract, including
515      * {IERC20-balanceOf} and {IERC20-transfer}.
516      */
517     function decimals() public view returns (uint8) {
518         return _decimals;
519     }
520 
521     /**
522      * @dev See {IERC20-totalSupply}.
523      */
524     function totalSupply() public view override returns (uint256) {
525         return _totalSupply;
526     }
527 
528     /**
529      * @dev See {IERC20-balanceOf}.
530      */
531     function balanceOf(address account) public view override returns (uint256) {
532         return _balances[account];
533     }
534 
535     /**
536      * @dev See {IERC20-transfer}.
537      *
538      * Requirements:
539      *
540      * - `recipient` cannot be the zero address.
541      * - the caller must have a balance of at least `amount`.
542      */
543     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
544         _transfer(_msgSender(), recipient, amount);
545         return true;
546     }
547 
548     /**
549      * @dev See {IERC20-allowance}.
550      */
551     function allowance(address owner, address spender) public view virtual override returns (uint256) {
552         return _allowances[owner][spender];
553     }
554 
555     /**
556      * @dev See {IERC20-approve}.
557      *
558      * Requirements:
559      *
560      * - `spender` cannot be the zero address.
561      */
562     function approve(address spender, uint256 amount) public virtual override returns (bool) {
563         _approve(_msgSender(), spender, amount);
564         return true;
565     }
566 
567     /**
568      * @dev See {IERC20-transferFrom}.
569      *
570      * Emits an {Approval} event indicating the updated allowance. This is not
571      * required by the EIP. See the note at the beginning of {ERC20};
572      *
573      * Requirements:
574      * - `sender` and `recipient` cannot be the zero address.
575      * - `sender` must have a balance of at least `amount`.
576      * - the caller must have allowance for ``sender``'s tokens of at least
577      * `amount`.
578      */
579     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
580         _transfer(sender, recipient, amount);
581         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
582         return true;
583     }
584 
585     /**
586      * @dev Atomically increases the allowance granted to `spender` by the caller.
587      *
588      * This is an alternative to {approve} that can be used as a mitigation for
589      * problems described in {IERC20-approve}.
590      *
591      * Emits an {Approval} event indicating the updated allowance.
592      *
593      * Requirements:
594      *
595      * - `spender` cannot be the zero address.
596      */
597     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
598         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
599         return true;
600     }
601 
602     /**
603      * @dev Atomically decreases the allowance granted to `spender` by the caller.
604      *
605      * This is an alternative to {approve} that can be used as a mitigation for
606      * problems described in {IERC20-approve}.
607      *
608      * Emits an {Approval} event indicating the updated allowance.
609      *
610      * Requirements:
611      *
612      * - `spender` cannot be the zero address.
613      * - `spender` must have allowance for the caller of at least
614      * `subtractedValue`.
615      */
616     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
617         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
618         return true;
619     }
620 
621     /**
622      * @dev Moves tokens `amount` from `sender` to `recipient`.
623      *
624      * This is internal function is equivalent to {transfer}, and can be used to
625      * e.g. implement automatic token fees, slashing mechanisms, etc.
626      *
627      * Emits a {Transfer} event.
628      *
629      * Requirements:
630      *
631      * - `sender` cannot be the zero address.
632      * - `recipient` cannot be the zero address.
633      * - `sender` must have a balance of at least `amount`.
634      */
635     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
636         require(sender != address(0), "ERC20: transfer from the zero address");
637         require(recipient != address(0), "ERC20: transfer to the zero address");
638 
639         _beforeTokenTransfer(sender, recipient, amount);
640 
641         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
642         _balances[recipient] = _balances[recipient].add(amount);
643         emit Transfer(sender, recipient, amount);
644     }
645 
646     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
647      * the total supply.
648      *
649      * Emits a {Transfer} event with `from` set to the zero address.
650      *
651      * Requirements
652      *
653      * - `to` cannot be the zero address.
654      */
655     function _mint(address account, uint256 amount) internal virtual {
656         require(account != address(0), "ERC20: mint to the zero address");
657 
658         _beforeTokenTransfer(address(0), account, amount);
659 
660         _totalSupply = _totalSupply.add(amount);
661         _balances[account] = _balances[account].add(amount);
662         emit Transfer(address(0), account, amount);
663     }
664 
665     /**
666      * @dev Destroys `amount` tokens from `account`, reducing the
667      * total supply.
668      *
669      * Emits a {Transfer} event with `to` set to the zero address.
670      *
671      * Requirements
672      *
673      * - `account` cannot be the zero address.
674      * - `account` must have at least `amount` tokens.
675      */
676     function _burn(address account, uint256 amount) internal virtual {
677         require(account != address(0), "ERC20: burn from the zero address");
678 
679         _beforeTokenTransfer(account, address(0), amount);
680 
681         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
682         _totalSupply = _totalSupply.sub(amount);
683         emit Transfer(account, address(0), amount);
684     }
685 
686     /**
687      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
688      *
689      * This internal function is equivalent to `approve`, and can be used to
690      * e.g. set automatic allowances for certain subsystems, etc.
691      *
692      * Emits an {Approval} event.
693      *
694      * Requirements:
695      *
696      * - `owner` cannot be the zero address.
697      * - `spender` cannot be the zero address.
698      */
699     function _approve(address owner, address spender, uint256 amount) internal virtual {
700         require(owner != address(0), "ERC20: approve from the zero address");
701         require(spender != address(0), "ERC20: approve to the zero address");
702 
703         _allowances[owner][spender] = amount;
704         emit Approval(owner, spender, amount);
705     }
706 
707     /**
708      * @dev Sets {decimals} to a value other than the default one of 18.
709      *
710      * WARNING: This function should only be called from the constructor. Most
711      * applications that interact with token contracts will not expect
712      * {decimals} to ever change, and may work incorrectly if it does.
713      */
714     function _setupDecimals(uint8 decimals_) internal {
715         _decimals = decimals_;
716     }
717 
718     /**
719      * @dev Hook that is called before any transfer of tokens. This includes
720      * minting and burning.
721      *
722      * Calling conditions:
723      *
724      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
725      * will be to transferred to `to`.
726      * - when `from` is zero, `amount` tokens will be minted for `to`.
727      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
728      * - `from` and `to` are never both zero.
729      *
730      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
731      */
732     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
733 }
734 
735 /**
736  * @title SafeERC20
737  * @dev Wrappers around ERC20 operations that throw on failure (when the token
738  * contract returns false). Tokens that return no value (and instead revert or
739  * throw on failure) are also supported, non-reverting calls are assumed to be
740  * successful.
741  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
742  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
743  */
744 library SafeERC20 {
745     using SafeMath for uint256;
746     using Address for address;
747 
748     function safeTransfer(IERC20 token, address to, uint256 value) internal {
749         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
750     }
751 
752     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
753         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
754     }
755 
756     /**
757      * @dev Deprecated. This function has issues similar to the ones found in
758      * {IERC20-approve}, and its usage is discouraged.
759      *
760      * Whenever possible, use {safeIncreaseAllowance} and
761      * {safeDecreaseAllowance} instead.
762      */
763     function safeApprove(IERC20 token, address spender, uint256 value) internal {
764         // safeApprove should only be called when setting an initial allowance,
765         // or when resetting it to zero. To increase and decrease it, use
766         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
767         // solhint-disable-next-line max-line-length
768         require((value == 0) || (token.allowance(address(this), spender) == 0),
769             "SafeERC20: approve from non-zero to non-zero allowance"
770         );
771         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
772     }
773 
774     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
775         uint256 newAllowance = token.allowance(address(this), spender).add(value);
776         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
777     }
778 
779     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
780         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
781         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
782     }
783 
784     /**
785      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
786      * on the return value: the return value is optional (but if data is returned, it must not be false).
787      * @param token The token targeted by the call.
788      * @param data The call data (encoded using abi.encode or one of its variants).
789      */
790     function _callOptionalReturn(IERC20 token, bytes memory data) private {
791         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
792         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
793         // the target address contains contract code and also asserts for success in the low-level call.
794 
795         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
796         if (returndata.length > 0) { // Return data is optional
797             // solhint-disable-next-line max-line-length
798             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
799         }
800     }
801 }
802 ////// src/pickle-jar.sol
803 // https://github.com/iearn-finance/vaults/blob/master/contracts/vaults/yVault.sol
804 
805 /* pragma solidity ^0.6.7; */
806 
807 /* import "./interfaces/controller.sol"; */
808 
809 /* import "./lib/erc20.sol"; */
810 /* import "./lib/safe-math.sol"; */
811 
812 contract PickleJar is ERC20 {
813     using SafeERC20 for IERC20;
814     using Address for address;
815     using SafeMath for uint256;
816 
817     IERC20 public token;
818 
819     uint256 public min = 9500;
820     uint256 public constant max = 10000;
821 
822     address public governance;
823     address public timelock;
824     address public controller;
825 
826     constructor(address _token, address _governance, address _timelock, address _controller)
827         public
828         ERC20(
829             string(abi.encodePacked("pickling ", ERC20(_token).name())),
830             string(abi.encodePacked("p", ERC20(_token).symbol()))
831         )
832     {
833         _setupDecimals(ERC20(_token).decimals());
834         token = IERC20(_token);
835         governance = _governance;
836         timelock = _timelock;
837         controller = _controller;
838     }
839 
840     function balance() public view returns (uint256) {
841         return
842             token.balanceOf(address(this)).add(
843                 IController(controller).balanceOf(address(token))
844             );
845     }
846 
847     function setMin(uint256 _min) external {
848         require(msg.sender == governance, "!governance");
849         min = _min;
850     }
851 
852     function setGovernance(address _governance) public {
853         require(msg.sender == governance, "!governance");
854         governance = _governance;
855     }
856 
857     function setTimelock(address _timelock) public {
858         require(msg.sender == timelock, "!timelock");
859         timelock = _timelock;
860     }
861 
862     function setController(address _controller) public {
863         require(msg.sender == timelock, "!timelock");
864         controller = _controller;
865     }
866 
867     // Custom logic in here for how much the jars allows to be borrowed
868     // Sets minimum required on-hand to keep small withdrawals cheap
869     function available() public view returns (uint256) {
870         return token.balanceOf(address(this)).mul(min).div(max);
871     }
872 
873     function earn() public {
874         uint256 _bal = available();
875         token.safeTransfer(controller, _bal);
876         IController(controller).earn(address(token), _bal);
877     }
878 
879     function depositAll() external {
880         deposit(token.balanceOf(msg.sender));
881     }
882 
883     function deposit(uint256 _amount) public {
884         uint256 _pool = balance();
885         uint256 _before = token.balanceOf(address(this));
886         token.safeTransferFrom(msg.sender, address(this), _amount);
887         uint256 _after = token.balanceOf(address(this));
888         _amount = _after.sub(_before); // Additional check for deflationary tokens
889         uint256 shares = 0;
890         if (totalSupply() == 0) {
891             shares = _amount;
892         } else {
893             shares = (_amount.mul(totalSupply())).div(_pool);
894         }
895         _mint(msg.sender, shares);
896     }
897 
898     function withdrawAll() external {
899         withdraw(balanceOf(msg.sender));
900     }
901 
902     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
903     function harvest(address reserve, uint256 amount) external {
904         require(msg.sender == controller, "!controller");
905         require(reserve != address(token), "token");
906         IERC20(reserve).safeTransfer(controller, amount);
907     }
908 
909     // No rebalance implementation for lower fees and faster swaps
910     function withdraw(uint256 _shares) public {
911         uint256 r = (balance().mul(_shares)).div(totalSupply());
912         _burn(msg.sender, _shares);
913 
914         // Check balance
915         uint256 b = token.balanceOf(address(this));
916         if (b < r) {
917             uint256 _withdraw = r.sub(b);
918             IController(controller).withdraw(address(token), _withdraw);
919             uint256 _after = token.balanceOf(address(this));
920             uint256 _diff = _after.sub(b);
921             if (_diff < _withdraw) {
922                 r = b.add(_diff);
923             }
924         }
925 
926         token.safeTransfer(msg.sender, r);
927     }
928 
929     function getRatio() public view returns (uint256) {
930         return balance().mul(1e18).div(totalSupply());
931     }
932 }