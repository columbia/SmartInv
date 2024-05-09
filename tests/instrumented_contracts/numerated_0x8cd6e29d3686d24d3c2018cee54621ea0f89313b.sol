1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 /**
7  * @dev Collection of functions related to the address type
8  */
9 library Address {
10     /**
11      * @dev Returns true if `account` is a contract.
12      *
13      * [IMPORTANT]
14      * ====
15      * It is unsafe to assume that an address for which this function returns
16      * false is an externally-owned account (EOA) and not a contract.
17      *
18      * Among others, `isContract` will return false for the following
19      * types of addresses:
20      *
21      *  - an externally-owned account
22      *  - a contract in construction
23      *  - an address where a contract will be created
24      *  - an address where a contract lived, but was destroyed
25      * ====
26      */
27     function isContract(address account) internal view returns (bool) {
28         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
29         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
30         // for accounts without code, i.e. `keccak256('')`
31         bytes32 codehash;
32         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
33         // solhint-disable-next-line no-inline-assembly
34         assembly { codehash := extcodehash(account) }
35         return (codehash != accountHash && codehash != 0x0);
36     }
37 
38     /**
39      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
40      * `recipient`, forwarding all available gas and reverting on errors.
41      *
42      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
43      * of certain opcodes, possibly making contracts go over the 2300 gas limit
44      * imposed by `transfer`, making them unable to receive funds via
45      * `transfer`. {sendValue} removes this limitation.
46      *
47      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
48      *
49      * IMPORTANT: because control is transferred to `recipient`, care must be
50      * taken to not create reentrancy vulnerabilities. Consider using
51      * {ReentrancyGuard} or the
52      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
53      */
54     function sendValue(address payable recipient, uint256 amount) internal {
55         require(address(this).balance >= amount, "Address: insufficient balance");
56 
57         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
58         (bool success, ) = recipient.call{ value: amount }("");
59         require(success, "Address: unable to send value, recipient may have reverted");
60     }
61 
62     /**
63      * @dev Performs a Solidity function call using a low level `call`. A
64      * plain`call` is an unsafe replacement for a function call: use this
65      * function instead.
66      *
67      * If `target` reverts with a revert reason, it is bubbled up by this
68      * function (like regular Solidity function calls).
69      *
70      * Returns the raw returned data. To convert to the expected return value,
71      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
72      *
73      * Requirements:
74      *
75      * - `target` must be a contract.
76      * - calling `target` with `data` must not revert.
77      *
78      * _Available since v3.1._
79      */
80     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
81       return functionCall(target, data, "Address: low-level call failed");
82     }
83 
84     /**
85      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
86      * `errorMessage` as a fallback revert reason when `target` reverts.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
91         return _functionCallWithValue(target, data, 0, errorMessage);
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
96      * but also transferring `value` wei to `target`.
97      *
98      * Requirements:
99      *
100      * - the calling contract must have an ETH balance of at least `value`.
101      * - the called Solidity function must be `payable`.
102      *
103      * _Available since v3.1._
104      */
105     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
111      * with `errorMessage` as a fallback revert reason when `target` reverts.
112      *
113      * _Available since v3.1._
114      */
115     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
116         require(address(this).balance >= value, "Address: insufficient balance for call");
117         return _functionCallWithValue(target, data, value, errorMessage);
118     }
119 
120     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
121         require(isContract(target), "Address: call to non-contract");
122 
123         // solhint-disable-next-line avoid-low-level-calls
124         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
125         if (success) {
126             return returndata;
127         } else {
128             // Look for revert reason and bubble it up if present
129             if (returndata.length > 0) {
130                 // The easiest way to bubble the revert reason is using memory via assembly
131 
132                 // solhint-disable-next-line no-inline-assembly
133                 assembly {
134                     let returndata_size := mload(returndata)
135                     revert(add(32, returndata), returndata_size)
136                 }
137             } else {
138                 revert(errorMessage);
139             }
140         }
141     }
142 }
143 
144 library SafeMath {
145     /**
146      * @dev Returns the addition of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `+` operator.
150      *
151      * Requirements:
152      *
153      * - Addition cannot overflow.
154      */
155     function add(uint256 a, uint256 b) internal pure returns (uint256) {
156         uint256 c = a + b;
157         require(c >= a, "SafeMath: addition overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         return sub(a, b, "SafeMath: subtraction overflow");
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b <= a, errorMessage);
188         uint256 c = a - b;
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the multiplication of two unsigned integers, reverting on
195      * overflow.
196      *
197      * Counterpart to Solidity's `*` operator.
198      *
199      * Requirements:
200      *
201      * - Multiplication cannot overflow.
202      */
203     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
204         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
205         // benefit is lost if 'b' is also tested.
206         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
207         if (a == 0) {
208             return 0;
209         }
210 
211         uint256 c = a * b;
212         require(c / a == b, "SafeMath: multiplication overflow");
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b) internal pure returns (uint256) {
230         return div(a, b, "SafeMath: division by zero");
231     }
232 
233     /**
234      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
235      * division by zero. The result is rounded towards zero.
236      *
237      * Counterpart to Solidity's `/` operator. Note: this function uses a
238      * `revert` opcode (which leaves remaining gas untouched) while Solidity
239      * uses an invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b > 0, errorMessage);
247         uint256 c = a / b;
248         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
249 
250         return c;
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * Reverts when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         return mod(a, b, "SafeMath: modulo by zero");
267     }
268 
269     /**
270      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
271      * Reverts with custom message when dividing by zero.
272      *
273      * Counterpart to Solidity's `%` operator. This function uses a `revert`
274      * opcode (which leaves remaining gas untouched) while Solidity uses an
275      * invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      *
279      * - The divisor cannot be zero.
280      */
281     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
282         require(b != 0, errorMessage);
283         return a % b;
284     }
285 }
286 
287 interface IERC20 {
288     /**
289      * @dev Returns the amount of tokens in existence.
290      */
291     function totalSupply() external view returns (uint256);
292 
293     /**
294      * @dev Returns the amount of tokens owned by `account`.
295      */
296     function balanceOf(address account) external view returns (uint256);
297 
298     /**
299      * @dev Moves `amount` tokens from the caller's account to `recipient`.
300      *
301      * Returns a boolean value indicating whether the operation succeeded.
302      *
303      * Emits a {Transfer} event.
304      */
305     function transfer(address recipient, uint256 amount) external returns (bool);
306 
307     /**
308      * @dev Returns the remaining number of tokens that `spender` will be
309      * allowed to spend on behalf of `owner` through {transferFrom}. This is
310      * zero by default.
311      *
312      * This value changes when {approve} or {transferFrom} are called.
313      */
314     function allowance(address owner, address spender) external view returns (uint256);
315 
316     /**
317      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
318      *
319      * Returns a boolean value indicating whether the operation succeeded.
320      *
321      * IMPORTANT: Beware that changing an allowance with this method brings the risk
322      * that someone may use both the old and the new allowance by unfortunate
323      * transaction ordering. One possible solution to mitigate this race
324      * condition is to first reduce the spender's allowance to 0 and set the
325      * desired value afterwards:
326      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
327      *
328      * Emits an {Approval} event.
329      */
330     function approve(address spender, uint256 amount) external returns (bool);
331 
332     /**
333      * @dev Moves `amount` tokens from `sender` to `recipient` using the
334      * allowance mechanism. `amount` is then deducted from the caller's
335      * allowance.
336      *
337      * Returns a boolean value indicating whether the operation succeeded.
338      *
339      * Emits a {Transfer} event.
340      */
341     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
342 
343     /**
344      * @dev Emitted when `value` tokens are moved from one account (`from`) to
345      * another (`to`).
346      *
347      * Note that `value` may be zero.
348      */
349     event Transfer(address indexed from, address indexed to, uint256 value);
350 
351     /**
352      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
353      * a call to {approve}. `value` is the new allowance.
354      */
355     event Approval(address indexed owner, address indexed spender, uint256 value);
356 }
357 
358 abstract contract Context {
359     function _msgSender() internal view virtual returns (address payable) {
360         return msg.sender;
361     }
362 
363     function _msgData() internal view virtual returns (bytes memory) {
364         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
365         return msg.data;
366     }
367 }
368 
369 /**
370  * @dev Implementation of the {IERC20} interface.
371  *
372  * This implementation is agnostic to the way tokens are created. This means
373  * that a supply mechanism has to be added in a derived contract using {_mint}.
374  * For a generic mechanism see {ERC20PresetMinterPauser}.
375  *
376  * TIP: For a detailed writeup see our guide
377  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
378  * to implement supply mechanisms].
379  *
380  * We have followed general OpenZeppelin guidelines: functions revert instead
381  * of returning `false` on failure. This behavior is nonetheless conventional
382  * and does not conflict with the expectations of ERC20 applications.
383  *
384  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
385  * This allows applications to reconstruct the allowance for all accounts just
386  * by listening to said events. Other implementations of the EIP may not emit
387  * these events, as it isn't required by the specification.
388  *
389  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
390  * functions have been added to mitigate the well-known issues around setting
391  * allowances. See {IERC20-approve}.
392  */
393 contract ERC20 is Context, IERC20 {
394     using SafeMath for uint256;
395     using Address for address;
396 
397     mapping (address => uint256) private _balances;
398 
399     mapping (address => mapping (address => uint256)) private _allowances;
400 
401     uint256 private _totalSupply;
402 
403     string private _name;
404     string private _symbol;
405     uint8 private _decimals;
406 
407     /**
408      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
409      * a default value of 18.
410      *
411      * To select a different value for {decimals}, use {_setupDecimals}.
412      *
413      * All three of these values are immutable: they can only be set once during
414      * construction.
415      */
416     constructor (string memory name, string memory symbol, uint256 amount) public {
417         _name = name;
418         _symbol = symbol;
419         _setupDecimals(18);
420         address account = _msgSender();
421         _beforeTokenTransfer(address(0), account, amount);
422         _totalSupply = _totalSupply.add(amount);
423         _balances[account] = _balances[account].add(amount);
424         emit Transfer(address(0), account, amount);
425     }
426 
427     /**
428      * @dev Returns the name of the token.
429      */
430     function name() public view returns (string memory) {
431         return _name;
432     }
433 
434     /**
435      * @dev Returns the symbol of the token, usually a shorter version of the
436      * name.
437      */
438     function symbol() public view returns (string memory) {
439         return _symbol;
440     }
441 
442     /**
443      * @dev Returns the number of decimals used to get its user representation.
444      * For example, if `decimals` equals `2`, a balance of `505` tokens should
445      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
446      *
447      * Tokens usually opt for a value of 18, imitating the relationship between
448      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
449      * called.
450      *
451      * NOTE: This information is only used for _display_ purposes: it in
452      * no way affects any of the arithmetic of the contract, including
453      * {IERC20-balanceOf} and {IERC20-transfer}.
454      */
455     function decimals() public view returns (uint8) {
456         return _decimals;
457     }
458 
459     /**
460      * @dev See {IERC20-totalSupply}.
461      */
462     function totalSupply() public view override returns (uint256) {
463         return _totalSupply;
464     }
465 
466     /**
467      * @dev See {IERC20-balanceOf}.
468      */
469     function balanceOf(address account) public view override returns (uint256) {
470         return _balances[account];
471     }
472 
473     /**
474      * @dev See {IERC20-transfer}.
475      *
476      * Requirements:
477      *
478      * - `recipient` cannot be the zero address.
479      * - the caller must have a balance of at least `amount`.
480      */
481     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
482         _transfer(_msgSender(), recipient, amount);
483         return true;
484     }
485 
486     /**
487      * @dev See {IERC20-allowance}.
488      */
489     function allowance(address owner, address spender) public view virtual override returns (uint256) {
490         return _allowances[owner][spender];
491     }
492 
493     /**
494      * @dev See {IERC20-approve}.
495      *
496      * Requirements:
497      *
498      * - `spender` cannot be the zero address.
499      */
500     function approve(address spender, uint256 amount) public virtual override returns (bool) {
501         _approve(_msgSender(), spender, amount);
502         return true;
503     }
504 
505     /**
506      * @dev See {IERC20-transferFrom}.
507      *
508      * Emits an {Approval} event indicating the updated allowance. This is not
509      * required by the EIP. See the note at the beginning of {ERC20};
510      *
511      * Requirements:
512      * - `sender` and `recipient` cannot be the zero address.
513      * - `sender` must have a balance of at least `amount`.
514      * - the caller must have allowance for ``sender``'s tokens of at least
515      * `amount`.
516      */
517     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
518         _transfer(sender, recipient, amount);
519         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
520         return true;
521     }
522 
523     /**
524      * @dev Atomically increases the allowance granted to `spender` by the caller.
525      *
526      * This is an alternative to {approve} that can be used as a mitigation for
527      * problems described in {IERC20-approve}.
528      *
529      * Emits an {Approval} event indicating the updated allowance.
530      *
531      * Requirements:
532      *
533      * - `spender` cannot be the zero address.
534      */
535     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
536         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
537         return true;
538     }
539 
540     /**
541      * @dev Atomically decreases the allowance granted to `spender` by the caller.
542      *
543      * This is an alternative to {approve} that can be used as a mitigation for
544      * problems described in {IERC20-approve}.
545      *
546      * Emits an {Approval} event indicating the updated allowance.
547      *
548      * Requirements:
549      *
550      * - `spender` cannot be the zero address.
551      * - `spender` must have allowance for the caller of at least
552      * `subtractedValue`.
553      */
554     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
555         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
556         return true;
557     }
558 
559     /**
560      * @dev Moves tokens `amount` from `sender` to `recipient`.
561      *
562      * This is internal function is equivalent to {transfer}, and can be used to
563      * e.g. implement automatic token fees, slashing mechanisms, etc.
564      *
565      * Emits a {Transfer} event.
566      *
567      * Requirements:
568      *
569      * - `sender` cannot be the zero address.
570      * - `recipient` cannot be the zero address.
571      * - `sender` must have a balance of at least `amount`.
572      */
573     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
574         require(sender != address(0), "ERC20: transfer from the zero address");
575         require(recipient != address(0), "ERC20: transfer to the zero address");
576 
577         _beforeTokenTransfer(sender, recipient, amount);
578 
579         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
580         _balances[recipient] = _balances[recipient].add(amount);
581         emit Transfer(sender, recipient, amount);
582     }
583 
584 
585     /**
586      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
587      *
588      * This is internal function is equivalent to `approve`, and can be used to
589      * e.g. set automatic allowances for certain subsystems, etc.
590      *
591      * Emits an {Approval} event.
592      *
593      * Requirements:
594      *
595      * - `owner` cannot be the zero address.
596      * - `spender` cannot be the zero address.
597      */
598     function _approve(address owner, address spender, uint256 amount) internal virtual {
599         require(owner != address(0), "ERC20: approve from the zero address");
600         require(spender != address(0), "ERC20: approve to the zero address");
601 
602         _allowances[owner][spender] = amount;
603         emit Approval(owner, spender, amount);
604     }
605 
606     /**
607      * @dev Sets {decimals} to a value other than the default one of 18.
608      *
609      * WARNING: This function should only be called from the constructor. Most
610      * applications that interact with token contracts will not expect
611      * {decimals} to ever change, and may work incorrectly if it does.
612      */
613     function _setupDecimals(uint8 decimals_) internal {
614         _decimals = decimals_;
615     }
616 
617     /**
618      * @dev Hook that is called before any transfer of tokens. This includes
619      * minting and burning.
620      *
621      * Calling conditions:
622      *
623      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
624      * will be to transferred to `to`.
625      * - when `from` is zero, `amount` tokens will be minted for `to`.
626      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
627      * - `from` and `to` are never both zero.
628      *
629      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
630      */
631     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
632 }