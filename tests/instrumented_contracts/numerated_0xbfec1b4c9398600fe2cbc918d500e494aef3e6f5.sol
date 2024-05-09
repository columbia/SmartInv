1 pragma solidity 0.6.12;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 library SafeMath {
15     
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `*` operator.
59      *
60      * Requirements:
61      *
62      * - Multiplication cannot overflow.
63      */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the integer division of two unsigned integers. Reverts on
80      * division by zero. The result is rounded towards zero.
81      *
82      * Counterpart to Solidity's `/` operator. Note: this function uses a
83      * `revert` opcode (which leaves remaining gas untouched) while Solidity
84      * uses an invalid opcode to revert (consuming all remaining gas).
85      *
86      * Requirements:
87      *
88      * - The divisor cannot be zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
116      * Reverts when dividing by zero.
117      *
118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
119      * opcode (which leaves remaining gas untouched) while Solidity uses an
120      * invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         return mod(a, b, "SafeMath: modulo by zero");
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts with custom message when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b != 0, errorMessage);
144         return a % b;
145     }
146 }
147 
148 /**
149  * @dev Collection of functions related to the address type
150  */
151 library Address {
152     /**
153      * @dev Returns true if `account` is a contract.
154      *
155      * [IMPORTANT]
156      * ====
157      * It is unsafe to assume that an address for which this function returns
158      * false is an externally-owned account (EOA) and not a contract.
159      *
160      * Among others, `isContract` will return false for the following
161      * types of addresses:
162      *
163      *  - an externally-owned account
164      *  - a contract in construction
165      *  - an address where a contract will be created
166      *  - an address where a contract lived, but was destroyed
167      * ====
168      */
169     function isContract(address account) internal view returns (bool) {
170         // This method relies on extcodesize, which returns 0 for contracts in
171         // construction, since the code is only stored at the end of the
172         // constructor execution.
173 
174         uint256 size;
175         // solhint-disable-next-line no-inline-assembly
176         assembly { size := extcodesize(account) }
177         return size > 0;
178     }
179 
180     /**
181      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
182      * `recipient`, forwarding all available gas and reverting on errors.
183      *
184      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
185      * of certain opcodes, possibly making contracts go over the 2300 gas limit
186      * imposed by `transfer`, making them unable to receive funds via
187      * `transfer`. {sendValue} removes this limitation.
188      *
189      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
190      *
191      * IMPORTANT: because control is transferred to `recipient`, care must be
192      * taken to not create reentrancy vulnerabilities. Consider using
193      * {ReentrancyGuard} or the
194      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
195      */
196     function sendValue(address payable recipient, uint256 amount) internal {
197         require(address(this).balance >= amount, "Address: insufficient balance");
198 
199         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
200         (bool success, ) = recipient.call{ value: amount }("");
201         require(success, "Address: unable to send value, recipient may have reverted");
202     }
203 
204     /**
205      * @dev Performs a Solidity function call using a low level `call`. A
206      * plain`call` is an unsafe replacement for a function call: use this
207      * function instead.
208      *
209      * If `target` reverts with a revert reason, it is bubbled up by this
210      * function (like regular Solidity function calls).
211      *
212      * Returns the raw returned data. To convert to the expected return value,
213      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
214      *
215      * Requirements:
216      *
217      * - `target` must be a contract.
218      * - calling `target` with `data` must not revert.
219      *
220      * _Available since v3.1._
221      */
222     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
223         return functionCall(target, data, "Address: low-level call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
228      * `errorMessage` as a fallback revert reason when `target` reverts.
229      *
230      * _Available since v3.1._
231      */
232     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, 0, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but also transferring `value` wei to `target`.
239      *
240      * Requirements:
241      *
242      * - the calling contract must have an ETH balance of at least `value`.
243      * - the called Solidity function must be `payable`.
244      *
245      * _Available since v3.1._
246      */
247     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
248         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
253      * with `errorMessage` as a fallback revert reason when `target` reverts.
254      *
255      * _Available since v3.1._
256      */
257     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
258         require(address(this).balance >= value, "Address: insufficient balance for call");
259         require(isContract(target), "Address: call to non-contract");
260 
261         // solhint-disable-next-line avoid-low-level-calls
262         (bool success, bytes memory returndata) = target.call{ value: value }(data);
263         return _verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
268      * but performing a static call.
269      *
270      * _Available since v3.3._
271      */
272     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
273         return functionStaticCall(target, data, "Address: low-level static call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
278      * but performing a static call.
279      *
280      * _Available since v3.3._
281      */
282     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
283         require(isContract(target), "Address: static call to non-contract");
284 
285         // solhint-disable-next-line avoid-low-level-calls
286         (bool success, bytes memory returndata) = target.staticcall(data);
287         return _verifyCallResult(success, returndata, errorMessage);
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
292      * but performing a delegate call.
293      *
294      * _Available since v3.3._
295      */
296     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
297         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
302      * but performing a delegate call.
303      *
304      * _Available since v3.3._
305      */
306     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
307         require(isContract(target), "Address: delegate call to non-contract");
308 
309         // solhint-disable-next-line avoid-low-level-calls
310         (bool success, bytes memory returndata) = target.delegatecall(data);
311         return _verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
315         if (success) {
316             return returndata;
317         } else {
318             // Look for revert reason and bubble it up if present
319             if (returndata.length > 0) {
320                 // The easiest way to bubble the revert reason is using memory via assembly
321 
322                 // solhint-disable-next-line no-inline-assembly
323                 assembly {
324                     let returndata_size := mload(returndata)
325                     revert(add(32, returndata), returndata_size)
326                 }
327             } else {
328                 revert(errorMessage);
329             }
330         }
331     }
332 }
333 
334 /**
335  * @dev Interface of the ERC20 standard as defined in the EIP.
336  */
337 interface IERC20 {
338     /**
339      * @dev Returns the amount of tokens in existence.
340      */
341     function totalSupply() external view returns (uint256);
342 
343     /**
344      * @dev Returns the amount of tokens owned by `account`.
345      */
346     function balanceOf(address account) external view returns (uint256);
347 
348     /**
349      * @dev Moves `amount` tokens from the caller's account to `recipient`.
350      *
351      * Returns a boolean value indicating whether the operation succeeded.
352      *
353      * Emits a {Transfer} event.
354      */
355     function transfer(address recipient, uint256 amount) external returns (bool);
356 
357     /**
358      * @dev Returns the remaining number of tokens that `spender` will be
359      * allowed to spend on behalf of `owner` through {transferFrom}. This is
360      * zero by default.
361      *
362      * This value changes when {approve} or {transferFrom} are called.
363      */
364     function allowance(address owner, address spender) external view returns (uint256);
365 
366     /**
367      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
368      *
369      * Returns a boolean value indicating whether the operation succeeded.
370      *
371      * IMPORTANT: Beware that changing an allowance with this method brings the risk
372      * that someone may use both the old and the new allowance by unfortunate
373      * transaction ordering. One possible solution to mitigate this race
374      * condition is to first reduce the spender's allowance to 0 and set the
375      * desired value afterwards:
376      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
377      *
378      * Emits an {Approval} event.
379      */
380     function approve(address spender, uint256 amount) external returns (bool);
381 
382     /**
383      * @dev Moves `amount` tokens from `sender` to `recipient` using the
384      * allowance mechanism. `amount` is then deducted from the caller's
385      * allowance.
386      *
387      * Returns a boolean value indicating whether the operation succeeded.
388      *
389      * Emits a {Transfer} event.
390      */
391     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
392 
393     /**
394      * @dev Emitted when `value` tokens are moved from one account (`from`) to
395      * another (`to`).
396      *
397      * Note that `value` may be zero.
398      */
399     event Transfer(address indexed from, address indexed to, uint256 value);
400 
401     /**
402      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
403      * a call to {approve}. `value` is the new allowance.
404      */
405     event Approval(address indexed owner, address indexed spender, uint256 value);
406 }
407 
408 /**
409  * @dev Implementation of the {IERC20} interface.
410  *
411  * This implementation is agnostic to the way tokens are created. This means
412  * that a supply mechanism has to be added in a derived contract using {_mint}.
413  * For a generic mechanism see {ERC20PresetMinterPauser}.
414  *
415  * TIP: For a detailed writeup see our guide
416  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
417  * to implement supply mechanisms].
418  *
419  * We have followed general OpenZeppelin guidelines: functions revert instead
420  * of returning `false` on failure. This behavior is nonetheless conventional
421  * and does not conflict with the expectations of ERC20 applications.
422  *
423  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
424  * This allows applications to reconstruct the allowance for all accounts just
425  * by listening to said events. Other implementations of the EIP may not emit
426  * these events, as it isn't required by the specification.
427  *
428  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
429  * functions have been added to mitigate the well-known issues around setting
430  * allowances. See {IERC20-approve}.
431  */
432 contract ERC20 is Context, IERC20 {
433     using SafeMath for uint256;
434     using Address for address;
435 
436     mapping (address => uint256) private _balances;
437     mapping (address => mapping (address => uint256)) private _allowances;
438     mapping (address => bool) public _whitelistedAddresses;
439 
440     uint256 private _totalSupply;
441     uint256 private _burnedSupply;
442     uint256 private _minSupply;
443     uint256 private _burnRate;
444     string private _name;
445     string private _symbol;
446     uint256 private _decimals;
447 
448     /**
449      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
450      * a default value of 18.
451      *
452      * To select a different value for {decimals}, use {_setupDecimals}.
453      *
454      * All three of these values are immutable: they can only be set once during
455      * construction.
456      */
457     constructor (string memory name, string memory symbol, uint256 decimals, uint256 burnrate, uint256 initSupply, uint256 minSupply) public {
458         _name = name;
459         _symbol = symbol;
460         _decimals = decimals;
461         _burnRate = burnrate;
462         _totalSupply = 0;
463         _mint(msg.sender, initSupply*(10**_decimals));
464         _burnedSupply = 0;
465         _minSupply = minSupply*(10**_decimals);
466     }
467 
468     /**
469      * @dev Returns the name of the token.
470      */
471     function name() public view returns (string memory) {
472         return _name;
473     }
474 
475     /**
476      * @dev Returns the symbol of the token, usually a shorter version of the
477      * name.
478      */
479     function symbol() public view returns (string memory) {
480         return _symbol;
481     }
482 
483     /**
484      * @dev Returns the number of decimals used to get its user representation.
485      * For example, if `decimals` equals `2`, a balance of `505` tokens should
486      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
487      *
488      * Tokens usually opt for a value of 18, imitating the relationship between
489      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
490      * called.
491      *
492      * NOTE: This information is only used for _display_ purposes: it in
493      * no way affects any of the arithmetic of the contract, including
494      * {IERC20-balanceOf} and {IERC20-transfer}.
495      */
496     function decimals() public view returns (uint256) {
497         return _decimals;
498     }
499 
500     /**
501      * @dev See {IERC20-totalSupply}.
502      */
503     function totalSupply() public view override returns (uint256) {
504         return _totalSupply;
505     }
506 
507     /**
508      * @dev Returns the amount of burned tokens.
509      */
510     function burnedSupply() public view returns (uint256) {
511         return _burnedSupply;
512     }
513     
514     function minSupply() public view returns (uint256) {
515         return _minSupply;
516     }
517 
518     /**
519      * @dev Returns the burnrate.
520      */
521     function burnRate() public view returns (uint256) {
522         return _burnRate;
523     }
524 
525     /**
526      * @dev See {IERC20-balanceOf}.
527      */
528     function balanceOf(address account) public view override returns (uint256) {
529         return _balances[account];
530     }
531 
532     /**
533      * @dev See {IERC20-transfer}.
534      *
535      * Requirements:
536      *
537      * - `recipient` cannot be the zero address.
538      * - the caller must have a balance of at least `amount`.
539      */
540     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
541         _transfer(_msgSender(), recipient, amount);
542         return true;
543     }
544 
545     /**
546      * @dev See {IERC20-transfer}.
547      *
548      * Requirements:
549      *
550      * - `account` cannot be the zero address.
551      * - the caller must have a balance of at least `amount`.
552      */
553     function burn(uint256 amount) public virtual returns (bool) {
554         _burn(_msgSender(), amount);
555         return true;
556     }
557 
558     /**
559      * @dev See {IERC20-allowance}.
560      */
561     function allowance(address owner, address spender) public view virtual override returns (uint256) {
562         return _allowances[owner][spender];
563     }
564 
565     /**
566      * @dev See {IERC20-approve}.
567      *
568      * Requirements:
569      *
570      * - `spender` cannot be the zero address.
571      */
572     function approve(address spender, uint256 amount) public virtual override returns (bool) {
573         _approve(_msgSender(), spender, amount);
574         return true;
575     }
576 
577     /**
578      * @dev See {IERC20-transferFrom}.
579      *
580      * Emits an {Approval} event indicating the updated allowance. This is not
581      * required by the EIP. See the note at the beginning of {ERC20};
582      *
583      * Requirements:
584      * - `sender` and `recipient` cannot be the zero address.
585      * - `sender` must have a balance of at least `amount`.
586      * - the caller must have allowance for ``sender``'s tokens of at least
587      * `amount`.
588      */
589     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
590         _transfer(sender, recipient, amount);
591         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
592         return true;
593     }
594 
595     /**
596      * @dev Atomically increases the allowance granted to `spender` by the caller.
597      *
598      * This is an alternative to {approve} that can be used as a mitigation for
599      * problems described in {IERC20-approve}.
600      *
601      * Emits an {Approval} event indicating the updated allowance.
602      *
603      * Requirements:
604      *
605      * - `spender` cannot be the zero address.
606      */
607     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
608         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
609         return true;
610     }
611 
612     /**
613      * @dev Atomically decreases the allowance granted to `spender` by the caller.
614      *
615      * This is an alternative to {approve} that can be used as a mitigation for
616      * problems described in {IERC20-approve}.
617      *
618      * Emits an {Approval} event indicating the updated allowance.
619      *
620      * Requirements:
621      *
622      * - `spender` cannot be the zero address.
623      * - `spender` must have allowance for the caller of at least
624      * `subtractedValue`.
625      */
626     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
627         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
628         return true;
629     }
630 
631     /**
632      * @dev Moves tokens `amount` from `sender` to `recipient`.
633      *
634      * This is internal function is equivalent to {transfer}, and can be used to
635      * e.g. implement automatic token fees, slashing mechanisms, etc.
636      *
637      * Emits a {Transfer} event.
638      *
639      * Requirements:
640      *
641      * - `sender` cannot be the zero address.
642      * - `recipient` cannot be the zero address.
643      * - `sender` must have a balance of at least `amount`.
644      */
645     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
646         require(sender != address(0), "ERC20: transfer from the zero address");
647         require(recipient != address(0), "ERC20: transfer to the zero address");
648 
649         if (_whitelistedAddresses[sender] == true || _whitelistedAddresses[recipient] == true) {
650             _beforeTokenTransfer(sender, recipient, amount);
651             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
652             _balances[recipient] = _balances[recipient].add(amount);
653             emit Transfer(sender, recipient, amount);
654         } else {
655             uint256 amount_burn = amount.mul(_burnRate).div(1000);
656             uint256 amount_send = amount.sub(amount_burn);
657             require(amount == amount_send + amount_burn, "Burn value invalid");
658             if(_totalSupply.sub(amount_burn) >= _minSupply) {
659                 _burn(sender, amount_burn);
660                 amount = amount_send;
661             } else {
662                 amount = amount_send + amount_burn;
663             }
664             _beforeTokenTransfer(sender, recipient, amount);
665             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
666             _balances[recipient] = _balances[recipient].add(amount);
667             emit Transfer(sender, recipient, amount);
668         }
669     }
670 
671     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
672      * the total supply.
673      *
674      * Emits a {Transfer} event with `from` set to the zero address.
675      *
676      * Requirements
677      *
678      * - `to` cannot be the zero address.
679      *
680      * HINT: This function is 'internal' and therefore can only be called from another
681      * function inside this contract!
682      */
683     function _mint(address account, uint256 amount) internal virtual {
684         require(account != address(0), "ERC20: mint to the zero address");
685         _beforeTokenTransfer(address(0), account, amount);
686         _totalSupply = _totalSupply.add(amount);
687         _balances[account] = _balances[account].add(amount);
688         emit Transfer(address(0), account, amount);
689     }
690 
691     /**
692      * @dev Destroys `amount` tokens from `account`, reducing the
693      * total supply.
694      *
695      * Emits a {Transfer} event with `to` set to the zero address.
696      *
697      * Requirements
698      *
699      * - `account` cannot be the zero address.
700      * - `account` must have at least `amount` tokens.
701      */
702     function _burn(address account, uint256 amount) internal virtual {
703         require(account != address(0), "ERC20: burn from the zero address");
704         _beforeTokenTransfer(account, address(0), amount);
705         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
706         _totalSupply = _totalSupply.sub(amount);
707         _burnedSupply = _burnedSupply.add(amount);
708         emit Transfer(account, address(0), amount);
709     }
710 
711     /**
712      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
713      *
714      * This is internal function is equivalent to `approve`, and can be used to
715      * e.g. set automatic allowances for certain subsystems, etc.
716      *
717      * Emits an {Approval} event.
718      *
719      * Requirements:
720      *
721      * - `owner` cannot be the zero address.
722      * - `spender` cannot be the zero address.
723      */
724     function _approve(address owner, address spender, uint256 amount) internal virtual {
725         require(owner != address(0), "ERC20: approve from the zero address");
726         require(spender != address(0), "ERC20: approve to the zero address");
727         _allowances[owner][spender] = amount;
728         emit Approval(owner, spender, amount);
729     }
730 
731     /**
732      * @dev Sets {burnRate} to a value other than the initial one.
733      */
734     function _setupBurnrate(uint8 burnrate_) internal virtual {
735         _burnRate = burnrate_;
736     }
737 
738     /**
739      * @dev Hook that is called before any transfer of tokens. This includes
740      * minting and burning.
741      *
742      * Calling conditions:
743      *
744      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
745      * will be to transferred to `to`.
746      * - when `from` is zero, `amount` tokens will be minted for `to`.
747      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
748      * - `from` and `to` are never both zero.
749      *
750      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
751      */
752     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
753 }
754 
755 /**
756  * @dev Contract module which provides a basic access control mechanism, where
757  * there is an account (an owner) that can be granted exclusive access to
758  * specific functions.
759  *
760  * By default, the owner account will be the one that deploys the contract. This
761  * can later be changed with {transferOwnership}.
762  *
763  * This module is used through inheritance. It will make available the modifier
764  * `onlyOwner`, which can be applied to your functions to restrict their use to
765  * the owner.
766  */
767 contract Ownable is Context {
768     address private _owner;
769 
770     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
771 
772     /**
773      * @dev Initializes the contract setting the deployer as the initial owner.
774      */
775     constructor () internal {
776         address msgSender = _msgSender();
777         _owner = msgSender;
778         emit OwnershipTransferred(address(0), msgSender);
779     }
780 
781     /**
782      * @dev Returns the address of the current owner.
783      */
784     function owner() public view returns (address) {
785         return _owner;
786     }
787 
788     /**
789      * @dev Throws if called by any account other than the owner.
790      */
791     modifier onlyOwner() {
792         require(_owner == _msgSender(), "Ownable: caller is not the owner");
793         _;
794     }
795 
796     /**
797      * @dev Leaves the contract without owner. It will not be possible to call
798      * `onlyOwner` functions anymore. Can only be called by the current owner.
799      *
800      * NOTE: Renouncing ownership will leave the contract without an owner,
801      * thereby removing any functionality that is only available to the owner.
802      */
803     function renounceOwnership() public virtual onlyOwner {
804         emit OwnershipTransferred(_owner, address(0));
805         _owner = address(0);
806     }
807 
808     /**
809      * @dev Transfers ownership of the contract to a new account (`newOwner`).
810      * Can only be called by the current owner.
811      */
812     function transferOwnership(address newOwner) public virtual onlyOwner {
813         require(newOwner != address(0), "Ownable: new owner is the zero address");
814         emit OwnershipTransferred(_owner, newOwner);
815         _owner = newOwner;
816     }
817 }
818 
819 /**
820  * @dev Contract module which provides a basic access control mechanism, where
821  * there is an account (an minter) that can be granted exclusive access to
822  * specific functions.
823  *
824  * By default, the minter account will be the one that deploys the contract. This
825  * can later be changed with {transferMintership}.
826  *
827  * This module is used through inheritance. It will make available the modifier
828  * `onlyMinter`, which can be applied to your functions to restrict their use to
829  * the minter.
830  */
831 contract Mintable is Context {
832 
833     /**
834      * @dev So here we seperate the rights of the classic ownership into 'owner' and 'minter'
835      * this way the developer/owner stays the 'owner' and can make changes like adding a pool
836      * at any time but cannot mint anymore as soon as the 'minter' gets changes (to the chef contract)
837      */
838     address private _minter;
839 
840     event MintershipTransferred(address indexed previousMinter, address indexed newMinter);
841 
842     /**
843      * @dev Initializes the contract setting the deployer as the initial minter.
844      */
845     constructor () internal {
846         address msgSender = _msgSender();
847         _minter = msgSender;
848         emit MintershipTransferred(address(0), msgSender);
849     }
850 
851     /**
852      * @dev Returns the address of the current minter.
853      */
854     function minter() public view returns (address) {
855         return _minter;
856     }
857 
858     /**
859      * @dev Throws if called by any account other than the minter.
860      */
861     modifier onlyMinter() {
862         require(_minter == _msgSender(), "Mintable: caller is not the minter");
863         _;
864     }
865 
866     /**
867      * @dev Transfers mintership of the contract to a new account (`newMinter`).
868      * Can only be called by the current minter.
869      */
870     function transferMintership(address newMinter) public virtual onlyMinter {
871         require(newMinter != address(0), "Mintable: new minter is the zero address");
872         emit MintershipTransferred(_minter, newMinter);
873         _minter = newMinter;
874     }
875 }
876 
877 contract DopeSwap is ERC20("DopeSwap", "DOPE", 18, 25, 1000, 500), Ownable, Mintable {
878     /// @notice Creates `_amount` token to `_to`. Must only be called by the minter (DopeDealer).
879     function mint(address _to, uint256 _amount) public onlyMinter {
880         _mint(_to, _amount);
881     }
882 
883     function setBurnrate(uint8 burnrate_) public onlyOwner {
884         _setupBurnrate(burnrate_);
885     }
886 
887     function addWhitelistedAddress(address _address) public onlyOwner {
888         _whitelistedAddresses[_address] = true;
889     }
890 
891     function removeWhitelistedAddress(address _address) public onlyOwner {
892         _whitelistedAddresses[_address] = false;
893     }
894 }