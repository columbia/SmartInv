1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor () internal {
25         address msgSender = _msgSender();
26         _owner = msgSender;
27         emit OwnershipTransferred(address(0), msgSender);
28     }
29 
30     /**
31      * @dev Returns the address of the current owner.
32      */
33     function owner() public view returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(_owner == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     /**
46      * @dev Leaves the contract without owner. It will not be possible to call
47      * `onlyOwner` functions anymore. Can only be called by the current owner.
48      *
49      * NOTE: Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public virtual onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Transfers ownership of the contract to a new account (`newOwner`).
59      * Can only be called by the current owner.
60      */
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         emit OwnershipTransferred(_owner, newOwner);
64         _owner = newOwner;
65     }
66 }
67 
68 library SafeMath {
69     /**
70      * @dev Returns the addition of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `+` operator.
74      *
75      * Requirements:
76      *
77      * - Addition cannot overflow.
78      */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      *
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
111         require(b <= a, errorMessage);
112         uint256 c = a - b;
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the multiplication of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `*` operator.
122      *
123      * Requirements:
124      *
125      * - Multiplication cannot overflow.
126      */
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129         // benefit is lost if 'b' is also tested.
130         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
131         if (a == 0) {
132             return 0;
133         }
134 
135         uint256 c = a * b;
136         require(c / a == b, "SafeMath: multiplication overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers. Reverts on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator. Note: this function uses a
146      * `revert` opcode (which leaves remaining gas untouched) while Solidity
147      * uses an invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function div(uint256 a, uint256 b) internal pure returns (uint256) {
154         return div(a, b, "SafeMath: division by zero");
155     }
156 
157     /**
158      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
159      * division by zero. The result is rounded towards zero.
160      *
161      * Counterpart to Solidity's `/` operator. Note: this function uses a
162      * `revert` opcode (which leaves remaining gas untouched) while Solidity
163      * uses an invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b > 0, errorMessage);
171         uint256 c = a / b;
172         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         return mod(a, b, "SafeMath: modulo by zero");
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts with custom message when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b != 0, errorMessage);
207         return a % b;
208     }
209 }
210 
211 library Address {
212     /**
213      * @dev Returns true if `account` is a contract.
214      *
215      * [IMPORTANT]
216      * ====
217      * It is unsafe to assume that an address for which this function returns
218      * false is an externally-owned account (EOA) and not a contract.
219      *
220      * Among others, `isContract` will return false for the following
221      * types of addresses:
222      *
223      *  - an externally-owned account
224      *  - a contract in construction
225      *  - an address where a contract will be created
226      *  - an address where a contract lived, but was destroyed
227      * ====
228      */
229     function isContract(address account) internal view returns (bool) {
230         // This method relies on extcodesize, which returns 0 for contracts in
231         // construction, since the code is only stored at the end of the
232         // constructor execution.
233 
234         uint256 size;
235         // solhint-disable-next-line no-inline-assembly
236         assembly { size := extcodesize(account) }
237         return size > 0;
238     }
239 
240     /**
241      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
242      * `recipient`, forwarding all available gas and reverting on errors.
243      *
244      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
245      * of certain opcodes, possibly making contracts go over the 2300 gas limit
246      * imposed by `transfer`, making them unable to receive funds via
247      * `transfer`. {sendValue} removes this limitation.
248      *
249      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
250      *
251      * IMPORTANT: because control is transferred to `recipient`, care must be
252      * taken to not create reentrancy vulnerabilities. Consider using
253      * {ReentrancyGuard} or the
254      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
255      */
256     function sendValue(address payable recipient, uint256 amount) internal {
257         require(address(this).balance >= amount, "Address: insufficient balance");
258 
259         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
260         (bool success, ) = recipient.call{ value: amount }("");
261         require(success, "Address: unable to send value, recipient may have reverted");
262     }
263 
264     /**
265      * @dev Performs a Solidity function call using a low level `call`. A
266      * plain`call` is an unsafe replacement for a function call: use this
267      * function instead.
268      *
269      * If `target` reverts with a revert reason, it is bubbled up by this
270      * function (like regular Solidity function calls).
271      *
272      * Returns the raw returned data. To convert to the expected return value,
273      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
274      *
275      * Requirements:
276      *
277      * - `target` must be a contract.
278      * - calling `target` with `data` must not revert.
279      *
280      * _Available since v3.1._
281      */
282     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
283       return functionCall(target, data, "Address: low-level call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
288      * `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, 0, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but also transferring `value` wei to `target`.
299      *
300      * Requirements:
301      *
302      * - the calling contract must have an ETH balance of at least `value`.
303      * - the called Solidity function must be `payable`.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
308         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
313      * with `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
318         require(address(this).balance >= value, "Address: insufficient balance for call");
319         require(isContract(target), "Address: call to non-contract");
320 
321         // solhint-disable-next-line avoid-low-level-calls
322         (bool success, bytes memory returndata) = target.call{ value: value }(data);
323         return _verifyCallResult(success, returndata, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but performing a static call.
329      *
330      * _Available since v3.3._
331      */
332     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
333         return functionStaticCall(target, data, "Address: low-level static call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
343         require(isContract(target), "Address: static call to non-contract");
344 
345         // solhint-disable-next-line avoid-low-level-calls
346         (bool success, bytes memory returndata) = target.staticcall(data);
347         return _verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.3._
355      */
356     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.3._
365      */
366     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
367         require(isContract(target), "Address: delegate call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.delegatecall(data);
371         return _verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 // solhint-disable-next-line no-inline-assembly
383                 assembly {
384                     let returndata_size := mload(returndata)
385                     revert(add(32, returndata), returndata_size)
386                 }
387             } else {
388                 revert(errorMessage);
389             }
390         }
391     }
392 }
393 
394 interface IERC20 {
395     /**
396      * @dev Returns the amount of tokens in existence.
397      */
398     function totalSupply() external view returns (uint256);
399 
400     /**
401      * @dev Returns the amount of tokens owned by `account`.
402      */
403     function balanceOf(address account) external view returns (uint256);
404 
405     /**
406      * @dev Moves `amount` tokens from the caller's account to `recipient`.
407      *
408      * Returns a boolean value indicating whether the operation succeeded.
409      *
410      * Emits a {Transfer} event.
411      */
412     function transfer(address recipient, uint256 amount) external returns (bool);
413 
414     /**
415      * @dev Returns the remaining number of tokens that `spender` will be
416      * allowed to spend on behalf of `owner` through {transferFrom}. This is
417      * zero by default.
418      *
419      * This value changes when {approve} or {transferFrom} are called.
420      */
421     function allowance(address owner, address spender) external view returns (uint256);
422 
423     /**
424      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
425      *
426      * Returns a boolean value indicating whether the operation succeeded.
427      *
428      * IMPORTANT: Beware that changing an allowance with this method brings the risk
429      * that someone may use both the old and the new allowance by unfortunate
430      * transaction ordering. One possible solution to mitigate this race
431      * condition is to first reduce the spender's allowance to 0 and set the
432      * desired value afterwards:
433      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
434      *
435      * Emits an {Approval} event.
436      */
437     function approve(address spender, uint256 amount) external returns (bool);
438 
439     /**
440      * @dev Moves `amount` tokens from `sender` to `recipient` using the
441      * allowance mechanism. `amount` is then deducted from the caller's
442      * allowance.
443      *
444      * Returns a boolean value indicating whether the operation succeeded.
445      *
446      * Emits a {Transfer} event.
447      */
448     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
449 
450     /**
451      * @dev Emitted when `value` tokens are moved from one account (`from`) to
452      * another (`to`).
453      *
454      * Note that `value` may be zero.
455      */
456     event Transfer(address indexed from, address indexed to, uint256 value);
457 
458     /**
459      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
460      * a call to {approve}. `value` is the new allowance.
461      */
462     event Approval(address indexed owner, address indexed spender, uint256 value);
463 }
464 
465 contract ERC20 is Context, IERC20 {
466     using SafeMath for uint256;
467     using Address for address;
468 
469     mapping (address => uint256) private _balances;
470 
471     mapping (address => mapping (address => uint256)) private _allowances;
472 
473     uint256 private _totalSupply;
474 
475     string private _name;
476     string private _symbol;
477     uint8 private _decimals;
478 
479     /**
480      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
481      * a default value of 18.
482      *
483      * To select a different value for {decimals}, use {_setupDecimals}.
484      *
485      * All three of these values are immutable: they can only be set once during
486      * construction.
487      */
488     constructor (string memory name, string memory symbol) public {
489         _name = name;
490         _symbol = symbol;
491         _decimals = 18;
492     }
493 
494     /**
495      * @dev Returns the name of the token.
496      */
497     function name() public view returns (string memory) {
498         return _name;
499     }
500 
501     /**
502      * @dev Returns the symbol of the token, usually a shorter version of the
503      * name.
504      */
505     function symbol() public view returns (string memory) {
506         return _symbol;
507     }
508 
509     /**
510      * @dev Returns the number of decimals used to get its user representation.
511      * For example, if `decimals` equals `2`, a balance of `505` tokens should
512      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
513      *
514      * Tokens usually opt for a value of 18, imitating the relationship between
515      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
516      * called.
517      *
518      * NOTE: This information is only used for _display_ purposes: it in
519      * no way affects any of the arithmetic of the contract, including
520      * {IERC20-balanceOf} and {IERC20-transfer}.
521      */
522     function decimals() public view returns (uint8) {
523         return _decimals;
524     }
525 
526     /**
527      * @dev See {IERC20-totalSupply}.
528      */
529     function totalSupply() public view override returns (uint256) {
530         return _totalSupply;
531     }
532 
533     /**
534      * @dev See {IERC20-balanceOf}.
535      */
536     function balanceOf(address account) public view override returns (uint256) {
537         return _balances[account];
538     }
539 
540     /**
541      * @dev See {IERC20-transfer}.
542      *
543      * Requirements:
544      *
545      * - `recipient` cannot be the zero address.
546      * - the caller must have a balance of at least `amount`.
547      */
548     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
549         _transfer(_msgSender(), recipient, amount);
550         return true;
551     }
552 
553     /**
554      * @dev See {IERC20-allowance}.
555      */
556     function allowance(address owner, address spender) public view virtual override returns (uint256) {
557         return _allowances[owner][spender];
558     }
559 
560     /**
561      * @dev See {IERC20-approve}.
562      *
563      * Requirements:
564      *
565      * - `spender` cannot be the zero address.
566      */
567     function approve(address spender, uint256 amount) public virtual override returns (bool) {
568         _approve(_msgSender(), spender, amount);
569         return true;
570     }
571 
572     /**
573      * @dev See {IERC20-transferFrom}.
574      *
575      * Emits an {Approval} event indicating the updated allowance. This is not
576      * required by the EIP. See the note at the beginning of {ERC20};
577      *
578      * Requirements:
579      * - `sender` and `recipient` cannot be the zero address.
580      * - `sender` must have a balance of at least `amount`.
581      * - the caller must have allowance for ``sender``'s tokens of at least
582      * `amount`.
583      */
584     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
585         _transfer(sender, recipient, amount);
586         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
587         return true;
588     }
589 
590     /**
591      * @dev Atomically increases the allowance granted to `spender` by the caller.
592      *
593      * This is an alternative to {approve} that can be used as a mitigation for
594      * problems described in {IERC20-approve}.
595      *
596      * Emits an {Approval} event indicating the updated allowance.
597      *
598      * Requirements:
599      *
600      * - `spender` cannot be the zero address.
601      */
602     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
603         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
604         return true;
605     }
606 
607     /**
608      * @dev Atomically decreases the allowance granted to `spender` by the caller.
609      *
610      * This is an alternative to {approve} that can be used as a mitigation for
611      * problems described in {IERC20-approve}.
612      *
613      * Emits an {Approval} event indicating the updated allowance.
614      *
615      * Requirements:
616      *
617      * - `spender` cannot be the zero address.
618      * - `spender` must have allowance for the caller of at least
619      * `subtractedValue`.
620      */
621     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
622         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
623         return true;
624     }
625 
626     /**
627      * @dev Moves tokens `amount` from `sender` to `recipient`.
628      *
629      * This is internal function is equivalent to {transfer}, and can be used to
630      * e.g. implement automatic token fees, slashing mechanisms, etc.
631      *
632      * Emits a {Transfer} event.
633      *
634      * Requirements:
635      *
636      * - `sender` cannot be the zero address.
637      * - `recipient` cannot be the zero address.
638      * - `sender` must have a balance of at least `amount`.
639      */
640     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
641         require(sender != address(0), "ERC20: transfer from the zero address");
642         require(recipient != address(0), "ERC20: transfer to the zero address");
643 
644         _beforeTokenTransfer(sender, recipient, amount);
645 
646         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
647         _balances[recipient] = _balances[recipient].add(amount);
648         emit Transfer(sender, recipient, amount);
649     }
650 
651     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
652      * the total supply.
653      *
654      * Emits a {Transfer} event with `from` set to the zero address.
655      *
656      * Requirements
657      *
658      * - `to` cannot be the zero address.
659      */
660     function _mint(address account, uint256 amount) internal virtual {
661         require(account != address(0), "ERC20: mint to the zero address");
662 
663         _beforeTokenTransfer(address(0), account, amount);
664 
665         _totalSupply = _totalSupply.add(amount);
666         _balances[account] = _balances[account].add(amount);
667         emit Transfer(address(0), account, amount);
668     }
669 
670     /**
671      * @dev Destroys `amount` tokens from `account`, reducing the
672      * total supply.
673      *
674      * Emits a {Transfer} event with `to` set to the zero address.
675      *
676      * Requirements
677      *
678      * - `account` cannot be the zero address.
679      * - `account` must have at least `amount` tokens.
680      */
681     function _burn(address account, uint256 amount) internal virtual {
682         require(account != address(0), "ERC20: burn from the zero address");
683 
684         _beforeTokenTransfer(account, address(0), amount);
685 
686         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
687         _totalSupply = _totalSupply.sub(amount);
688         emit Transfer(account, address(0), amount);
689     }
690 
691     /**
692      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
693      *
694      * This internal function is equivalent to `approve`, and can be used to
695      * e.g. set automatic allowances for certain subsystems, etc.
696      *
697      * Emits an {Approval} event.
698      *
699      * Requirements:
700      *
701      * - `owner` cannot be the zero address.
702      * - `spender` cannot be the zero address.
703      */
704     function _approve(address owner, address spender, uint256 amount) internal virtual {
705         require(owner != address(0), "ERC20: approve from the zero address");
706         require(spender != address(0), "ERC20: approve to the zero address");
707 
708         _allowances[owner][spender] = amount;
709         emit Approval(owner, spender, amount);
710     }
711 
712     /**
713      * @dev Sets {decimals} to a value other than the default one of 18.
714      *
715      * WARNING: This function should only be called from the constructor. Most
716      * applications that interact with token contracts will not expect
717      * {decimals} to ever change, and may work incorrectly if it does.
718      */
719     function _setupDecimals(uint8 decimals_) internal {
720         _decimals = decimals_;
721     }
722 
723     /**
724      * @dev Hook that is called before any transfer of tokens. This includes
725      * minting and burning.
726      *
727      * Calling conditions:
728      *
729      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
730      * will be to transferred to `to`.
731      * - when `from` is zero, `amount` tokens will be minted for `to`.
732      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
733      * - `from` and `to` are never both zero.
734      *
735      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
736      */
737     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
738 }
739 
740 contract BasketCoin is ERC20, Ownable {
741     using SafeMath for uint256;
742     using Address for address;
743     
744     uint256 public burnFee = 1;
745     uint256 public stakeFee = 1;
746     uint256 public minTotalSupplyToBurn = 21e23;
747     
748     address public rewardContract;
749     
750     uint256 public maxPurchasableETHForPresale = 5e18;      // max purchable ETH amount in presale = 5 ETH
751     uint256 public publicSaleRate = 10000;                  // 10000 BSKT per 1 ETH
752     uint256 public preSaleRate = 11000;                     // 11000 BSKT per 1 ETH
753     
754     bool public saleStatus;                                 // false: sale impossible, true: sale possible
755     bool public saleMode;                                   // false: presale, true: public sale
756     mapping (address => uint256) public purchaseMap;
757     mapping (address => bool) public whiteList;
758     uint256 public preSaleSum;
759     uint256 public publicSaleSum;
760     
761     event Purchased(address indexed purchaser, uint256 purchasedETH);
762     event RewardContractUpdated(address indexed stakeContract);
763     event SaleModeUpdated(bool saleMode);
764     event SaleStatusUpdated(bool saleStatus);
765     
766     constructor(
767     ) public ERC20("BasketCoin", "BSKT") {
768         _mint(_msgSender(), 546e22);
769         _mint(address(this), 1554e22);
770     }
771     
772     function _transfer(
773         address from,
774         address to,
775         uint256 amount
776     ) internal override {
777         require(rewardContract != address(0), 'BSKT: rewardContract is zeor address.');
778         
779         if(from == owner() || to == owner()) {
780             super._transfer(from, to,  amount);
781         } else {
782             uint256 burnAmount = amount.mul(burnFee).div(100);
783             uint256 stakeAmount = amount.mul(stakeFee).div(100);
784             
785             if(totalSupply().sub(burnAmount) >= minTotalSupplyToBurn) {
786                 super._burn(from, burnAmount);
787                 super._transfer(from, rewardContract,  stakeAmount);
788                 super._transfer(from, to,  amount.sub(stakeAmount).sub(burnAmount));
789             } else {
790                 super._transfer(from, rewardContract,  stakeAmount.add(burnAmount));
791                 super._transfer(from, to,  amount.sub(stakeAmount).sub(burnAmount));
792             }
793         }
794     }
795 
796     receive() external payable { purchase(); }
797     
798     function min(uint256 value1, uint256 value2) internal pure returns (uint256) {
799         if(value1 <= value2)
800             return value1;
801         else
802             return value2;
803     }
804 
805     function purchase() public payable {
806         require(saleStatus, 'BSKT: sale not started yet.');
807         
808         uint256 purchaseTokenAmount;
809         uint256 purchasableETH;
810         if(!saleMode) {
811             require(whiteList[_msgSender()], 'BSKT: you are not in white list.');
812             require(purchaseMap[_msgSender()] < maxPurchasableETHForPresale, 'BSKT: you already purchased max.');
813             
814             purchasableETH = min(maxPurchasableETHForPresale.sub(purchaseMap[_msgSender()]), msg.value);
815             purchaseTokenAmount = purchasableETH.mul(preSaleRate);
816             preSaleSum = preSaleSum.add(purchaseTokenAmount);
817             uint256 refundETH = msg.value.sub(purchasableETH);
818             
819             purchaseMap[_msgSender()] = purchaseMap[_msgSender()].add(purchasableETH);
820 
821             if(refundETH > 0) {
822                 (bool success,) = _msgSender().call{ value: refundETH }("");
823                 require(success, "refund failed");
824             }
825         } else {
826             purchasableETH = msg.value;
827             purchaseTokenAmount = purchasableETH.mul(publicSaleRate);
828             publicSaleSum = publicSaleSum.add(purchaseTokenAmount);
829         }
830         
831         super._transfer(address(this), _msgSender(), purchaseTokenAmount);
832         Purchased(_msgSender(), purchasableETH);
833     }
834     
835     function burn(uint256 amount) external onlyOwner {
836         super._burn(_msgSender(), amount);
837     }
838     
839     function withdrawETH() public onlyOwner {
840         (bool success,) = _msgSender().call{ value: address(this).balance }("");
841         require(success, "withdraw failed");
842     }
843     
844     function withdrawALL() public onlyOwner {
845         super._transfer(address(this), _msgSender(), balanceOf(address(this)));
846     }
847     
848     function updateRewardContract(address _rewardContract) public onlyOwner {
849         require(_rewardContract != address(0), 'BSKT: rewardContract is zeor address.');
850         rewardContract = _rewardContract;
851         emit RewardContractUpdated(_rewardContract);
852     }
853     
854     function updateSaleMode(bool _saleMode) public onlyOwner {
855         if(saleMode != _saleMode) {
856             saleMode = _saleMode;
857             SaleModeUpdated(saleMode);
858         }
859     }
860     
861     function updateSaleStatus(bool _saleStatus) public onlyOwner {
862         if(saleStatus != _saleStatus) {
863             saleStatus = _saleStatus;
864             SaleStatusUpdated(saleStatus);
865         }
866     }
867     
868     function addAddressToWhiteList(address account) public onlyOwner {
869         whiteList[account] = true;
870     }
871     
872     function removeAddressFromWhiteList(address account) public onlyOwner {
873         whiteList[account] = false;
874     }
875 }