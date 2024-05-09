1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 
16 
17 /**
18  * @dev Interface of the ERC20 standard as defined in the EIP.
19  */
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 
236 /**
237  * @dev Collection of functions related to the address type
238  */
239 library Address {
240     /**
241      * @dev Returns true if `account` is a contract.
242      *
243      * [IMPORTANT]
244      * ====
245      * It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      *
248      * Among others, `isContract` will return false for the following
249      * types of addresses:
250      *
251      *  - an externally-owned account
252      *  - a contract in construction
253      *  - an address where a contract will be created
254      *  - an address where a contract lived, but was destroyed
255      * ====
256      */
257     function isContract(address account) internal view returns (bool) {
258         // This method relies in extcodesize, which returns 0 for contracts in
259         // construction, since the code is only stored at the end of the
260         // constructor execution.
261 
262         uint256 size;
263         // solhint-disable-next-line no-inline-assembly
264         assembly { size := extcodesize(account) }
265         return size > 0;
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
288         (bool success, ) = recipient.call{ value: amount }("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain`call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
311       return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316      * `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
321         return _functionCallWithValue(target, data, 0, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but also transferring `value` wei to `target`.
327      *
328      * Requirements:
329      *
330      * - the calling contract must have an ETH balance of at least `value`.
331      * - the called Solidity function must be `payable`.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
336         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
341      * with `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
346         require(address(this).balance >= value, "Address: insufficient balance for call");
347         return _functionCallWithValue(target, data, value, errorMessage);
348     }
349 
350     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
351         require(isContract(target), "Address: call to non-contract");
352 
353         // solhint-disable-next-line avoid-low-level-calls
354         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
355         if (success) {
356             return returndata;
357         } else {
358             // Look for revert reason and bubble it up if present
359             if (returndata.length > 0) {
360                 // The easiest way to bubble the revert reason is using memory via assembly
361 
362                 // solhint-disable-next-line no-inline-assembly
363                 assembly {
364                     let returndata_size := mload(returndata)
365                     revert(add(32, returndata), returndata_size)
366                 }
367             } else {
368                 revert(errorMessage);
369             }
370         }
371     }
372 }
373 
374 contract ERC20 is Context, IERC20 {
375     using SafeMath for uint256;
376     using Address for address;
377 
378     mapping (address => uint256) private _balances;
379 
380     mapping (address => mapping (address => uint256)) private _allowances;
381 
382     uint256 private _totalSupply;
383 
384     string private _name;
385     string private _symbol;
386     uint8 private _decimals;
387 
388     /**
389      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
390      * a default value of 18.
391      *
392      * To select a different value for {decimals}, use {_setupDecimals}.
393      *
394      * All three of these values are immutable: they can only be set once during
395      * construction.
396      */
397     constructor (string memory name, string memory symbol) public {
398         _name = name;
399         _symbol = symbol;
400         _decimals = 18;
401     }
402 
403     /**
404      * @dev Returns the name of the token.
405      */
406     function name() public view returns (string memory) {
407         return _name;
408     }
409 
410     /**
411      * @dev Returns the symbol of the token, usually a shorter version of the
412      * name.
413      */
414     function symbol() public view returns (string memory) {
415         return _symbol;
416     }
417 
418     /**
419      * @dev Returns the number of decimals used to get its user representation.
420      * For example, if `decimals` equals `2`, a balance of `505` tokens should
421      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
422      *
423      * Tokens usually opt for a value of 18, imitating the relationship between
424      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
425      * called.
426      *
427      * NOTE: This information is only used for _display_ purposes: it in
428      * no way affects any of the arithmetic of the contract, including
429      * {IERC20-balanceOf} and {IERC20-transfer}.
430      */
431     function decimals() public view returns (uint8) {
432         return _decimals;
433     }
434 
435     /**
436      * @dev See {IERC20-totalSupply}.
437      */
438     function totalSupply() public view override returns (uint256) {
439         return _totalSupply;
440     }
441 
442     /**
443      * @dev See {IERC20-balanceOf}.
444      */
445     function balanceOf(address account) public view override returns (uint256) {
446         return _balances[account];
447     }
448 
449     /**
450      * @dev See {IERC20-transfer}.
451      *
452      * Requirements:
453      *
454      * - `recipient` cannot be the zero address.
455      * - the caller must have a balance of at least `amount`.
456      */
457     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
458         _transfer(_msgSender(), recipient, amount);
459         return true;
460     }
461 
462     /**
463      * @dev See {IERC20-allowance}.
464      */
465     function allowance(address owner, address spender) public view virtual override returns (uint256) {
466         return _allowances[owner][spender];
467     }
468 
469     /**
470      * @dev See {IERC20-approve}.
471      *
472      * Requirements:
473      *
474      * - `spender` cannot be the zero address.
475      */
476     function approve(address spender, uint256 amount) public virtual override returns (bool) {
477         _approve(_msgSender(), spender, amount);
478         return true;
479     }
480 
481     /**
482      * @dev See {IERC20-transferFrom}.
483      *
484      * Emits an {Approval} event indicating the updated allowance. This is not
485      * required by the EIP. See the note at the beginning of {ERC20};
486      *
487      * Requirements:
488      * - `sender` and `recipient` cannot be the zero address.
489      * - `sender` must have a balance of at least `amount`.
490      * - the caller must have allowance for ``sender``'s tokens of at least
491      * `amount`.
492      */
493     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
494         _transfer(sender, recipient, amount);
495         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
496         return true;
497     }
498 
499     /**
500      * @dev Atomically increases the allowance granted to `spender` by the caller.
501      *
502      * This is an alternative to {approve} that can be used as a mitigation for
503      * problems described in {IERC20-approve}.
504      *
505      * Emits an {Approval} event indicating the updated allowance.
506      *
507      * Requirements:
508      *
509      * - `spender` cannot be the zero address.
510      */
511     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
512         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
513         return true;
514     }
515 
516     /**
517      * @dev Atomically decreases the allowance granted to `spender` by the caller.
518      *
519      * This is an alternative to {approve} that can be used as a mitigation for
520      * problems described in {IERC20-approve}.
521      *
522      * Emits an {Approval} event indicating the updated allowance.
523      *
524      * Requirements:
525      *
526      * - `spender` cannot be the zero address.
527      * - `spender` must have allowance for the caller of at least
528      * `subtractedValue`.
529      */
530     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
531         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
532         return true;
533     }
534 
535     /**
536      * @dev Moves tokens `amount` from `sender` to `recipient`.
537      *
538      * This is internal function is equivalent to {transfer}, and can be used to
539      * e.g. implement automatic token fees, slashing mechanisms, etc.
540      *
541      * Emits a {Transfer} event.
542      *
543      * Requirements:
544      *
545      * - `sender` cannot be the zero address.
546      * - `recipient` cannot be the zero address.
547      * - `sender` must have a balance of at least `amount`.
548      */
549     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
550         require(sender != address(0), "ERC20: transfer from the zero address");
551         require(recipient != address(0), "ERC20: transfer to the zero address");
552 
553         _beforeTokenTransfer(sender, recipient, amount);
554 
555         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
556         _balances[recipient] = _balances[recipient].add(amount);
557         emit Transfer(sender, recipient, amount);
558     }
559 
560     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
561      * the total supply.
562      *
563      * Emits a {Transfer} event with `from` set to the zero address.
564      *
565      * Requirements
566      *
567      * - `to` cannot be the zero address.
568      */
569     function _mint(address account, uint256 amount) internal virtual {
570         require(account != address(0), "ERC20: mint to the zero address");
571 
572         _beforeTokenTransfer(address(0), account, amount);
573 
574         _totalSupply = _totalSupply.add(amount);
575         _balances[account] = _balances[account].add(amount);
576         emit Transfer(address(0), account, amount);
577     }
578 
579     /**
580      * @dev Destroys `amount` tokens from `account`, reducing the
581      * total supply.
582      *
583      * Emits a {Transfer} event with `to` set to the zero address.
584      *
585      * Requirements
586      *
587      * - `account` cannot be the zero address.
588      * - `account` must have at least `amount` tokens.
589      */
590     function _burn(address account, uint256 amount) internal virtual {
591         require(account != address(0), "ERC20: burn from the zero address");
592 
593         _beforeTokenTransfer(account, address(0), amount);
594 
595         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
596         _totalSupply = _totalSupply.sub(amount);
597         emit Transfer(account, address(0), amount);
598     }
599 
600     /**
601      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
602      *
603      * This is internal function is equivalent to `approve`, and can be used to
604      * e.g. set automatic allowances for certain subsystems, etc.
605      *
606      * Emits an {Approval} event.
607      *
608      * Requirements:
609      *
610      * - `owner` cannot be the zero address.
611      * - `spender` cannot be the zero address.
612      */
613     function _approve(address owner, address spender, uint256 amount) internal virtual {
614         require(owner != address(0), "ERC20: approve from the zero address");
615         require(spender != address(0), "ERC20: approve to the zero address");
616 
617         _allowances[owner][spender] = amount;
618         emit Approval(owner, spender, amount);
619     }
620 
621     /**
622      * @dev Sets {decimals} to a value other than the default one of 18.
623      *
624      * WARNING: This function should only be called from the constructor. Most
625      * applications that interact with token contracts will not expect
626      * {decimals} to ever change, and may work incorrectly if it does.
627      */
628     function _setupDecimals(uint8 decimals_) internal {
629         _decimals = decimals_;
630     }
631 
632     /**
633      * @dev Hook that is called before any transfer of tokens. This includes
634      * minting and burning.
635      *
636      * Calling conditions:
637      *
638      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
639      * will be to transferred to `to`.
640      * - when `from` is zero, `amount` tokens will be minted for `to`.
641      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
642      * - `from` and `to` are never both zero.
643      *
644      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
645      */
646     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
647 }
648 
649 
650 
651 contract SonToken is ERC20{
652 
653     constructor(address devAddress,address distributeAddress) public ERC20("SONTOKEN","SON"){
654         uint256 _totalSupply = 90730 * 10 ** 18;
655 
656         uint256 toDev =  (_totalSupply * 5) / 100;
657 
658         uint256 toDistribute = _totalSupply - toDev;
659 
660         _mint(devAddress,toDev);
661         
662         _mint(distributeAddress,toDistribute);
663     }
664 
665 }