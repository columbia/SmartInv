1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address payable) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     /**
23      * @dev Initializes the contract setting the deployer as the initial owner.
24      */
25     constructor () internal {
26         address msgSender = _msgSender();
27         _owner = msgSender;
28         emit OwnershipTransferred(address(0), msgSender);
29     }
30 
31     /**
32      * @dev Returns the address of the current owner.
33      */
34     function owner() public view returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(_owner == _msgSender(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     /**
47      * @dev Leaves the contract without owner. It will not be possible to call
48      * `onlyOwner` functions anymore. Can only be called by the current owner.
49      *
50      * NOTE: Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public virtual onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Transfers ownership of the contract to a new account (`newOwner`).
60      * Can only be called by the current owner.
61      */
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 /**
70  * @dev Interface of the ERC20 standard as defined in the EIP.
71  */
72 interface IERC20 {
73     /**
74      * @dev Returns the amount of tokens in existence.
75      */
76     function totalSupply() external view returns (uint256);
77 
78     /**
79      * @dev Returns the amount of tokens owned by `account`.
80      */
81     function balanceOf(address account) external view returns (uint256);
82 
83     /**
84      * @dev Moves `amount` tokens from the caller's account to `recipient`.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transfer(address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Returns the remaining number of tokens that `spender` will be
94      * allowed to spend on behalf of `owner` through {transferFrom}. This is
95      * zero by default.
96      *
97      * This value changes when {approve} or {transferFrom} are called.
98      */
99     function allowance(address owner, address spender) external view returns (uint256);
100 
101     /**
102      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * IMPORTANT: Beware that changing an allowance with this method brings the risk
107      * that someone may use both the old and the new allowance by unfortunate
108      * transaction ordering. One possible solution to mitigate this race
109      * condition is to first reduce the spender's allowance to 0 and set the
110      * desired value afterwards:
111      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address spender, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Moves `amount` tokens from `sender` to `recipient` using the
119      * allowance mechanism. `amount` is then deducted from the caller's
120      * allowance.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
127 
128     /**
129      * @dev Emitted when `value` tokens are moved from one account (`from`) to
130      * another (`to`).
131      *
132      * Note that `value` may be zero.
133      */
134     event Transfer(address indexed from, address indexed to, uint256 value);
135 
136     /**
137      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
138      * a call to {approve}. `value` is the new allowance.
139      */
140     event Approval(address indexed owner, address indexed spender, uint256 value);
141 }
142 
143 library SafeMath {
144     /**
145      * @dev Returns the addition of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `+` operator.
149      *
150      * Requirements:
151      *
152      * - Addition cannot overflow.
153      */
154     function add(uint256 a, uint256 b) internal pure returns (uint256) {
155         uint256 c = a + b;
156         require(c >= a, "SafeMath: addition overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
172         return sub(a, b, "SafeMath: subtraction overflow");
173     }
174 
175     /**
176      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
177      * overflow (when the result is negative).
178      *
179      * Counterpart to Solidity's `-` operator.
180      *
181      * Requirements:
182      *
183      * - Subtraction cannot overflow.
184      */
185     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
186         require(b <= a, errorMessage);
187         uint256 c = a - b;
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the multiplication of two unsigned integers, reverting on
194      * overflow.
195      *
196      * Counterpart to Solidity's `*` operator.
197      *
198      * Requirements:
199      *
200      * - Multiplication cannot overflow.
201      */
202     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
203         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
204         // benefit is lost if 'b' is also tested.
205         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
206         if (a == 0) {
207             return 0;
208         }
209 
210         uint256 c = a * b;
211         require(c / a == b, "SafeMath: multiplication overflow");
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b) internal pure returns (uint256) {
229         return div(a, b, "SafeMath: division by zero");
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
245         require(b > 0, errorMessage);
246         uint256 c = a / b;
247         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
265         return mod(a, b, "SafeMath: modulo by zero");
266     }
267 
268     /**
269      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270      * Reverts with custom message when dividing by zero.
271      *
272      * Counterpart to Solidity's `%` operator. This function uses a `revert`
273      * opcode (which leaves remaining gas untouched) while Solidity uses an
274      * invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         require(b != 0, errorMessage);
282         return a % b;
283     }
284 }
285 
286 library Address {
287     /**
288      * @dev Returns true if `account` is a contract.
289      *
290      * [IMPORTANT]
291      * ====
292      * It is unsafe to assume that an address for which this function returns
293      * false is an externally-owned account (EOA) and not a contract.
294      *
295      * Among others, `isContract` will return false for the following
296      * types of addresses:
297      *
298      *  - an externally-owned account
299      *  - a contract in construction
300      *  - an address where a contract will be created
301      *  - an address where a contract lived, but was destroyed
302      * ====
303      */
304     function isContract(address account) internal view returns (bool) {
305         // This method relies on extcodesize, which returns 0 for contracts in
306         // construction, since the code is only stored at the end of the
307         // constructor execution.
308 
309         uint256 size;
310         // solhint-disable-next-line no-inline-assembly
311         assembly { size := extcodesize(account) }
312         return size > 0;
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      */
331     function sendValue(address payable recipient, uint256 amount) internal {
332         require(address(this).balance >= amount, "Address: insufficient balance");
333 
334         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
335         (bool success, ) = recipient.call{ value: amount }("");
336         require(success, "Address: unable to send value, recipient may have reverted");
337     }
338 
339     /**
340      * @dev Performs a Solidity function call using a low level `call`. A
341      * plain`call` is an unsafe replacement for a function call: use this
342      * function instead.
343      *
344      * If `target` reverts with a revert reason, it is bubbled up by this
345      * function (like regular Solidity function calls).
346      *
347      * Returns the raw returned data. To convert to the expected return value,
348      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
349      *
350      * Requirements:
351      *
352      * - `target` must be a contract.
353      * - calling `target` with `data` must not revert.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
358       return functionCall(target, data, "Address: low-level call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
363      * `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, 0, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but also transferring `value` wei to `target`.
374      *
375      * Requirements:
376      *
377      * - the calling contract must have an ETH balance of at least `value`.
378      * - the called Solidity function must be `payable`.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388      * with `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
393         require(address(this).balance >= value, "Address: insufficient balance for call");
394         require(isContract(target), "Address: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.call{ value: value }(data);
398         return _verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
408         return functionStaticCall(target, data, "Address: low-level static call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
418         require(isContract(target), "Address: static call to non-contract");
419 
420         // solhint-disable-next-line avoid-low-level-calls
421         (bool success, bytes memory returndata) = target.staticcall(data);
422         return _verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.3._
430      */
431     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
432         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a delegate call.
438      *
439      * _Available since v3.3._
440      */
441     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
442         require(isContract(target), "Address: delegate call to non-contract");
443 
444         // solhint-disable-next-line avoid-low-level-calls
445         (bool success, bytes memory returndata) = target.delegatecall(data);
446         return _verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
450         if (success) {
451             return returndata;
452         } else {
453             // Look for revert reason and bubble it up if present
454             if (returndata.length > 0) {
455                 // The easiest way to bubble the revert reason is using memory via assembly
456 
457                 // solhint-disable-next-line no-inline-assembly
458                 assembly {
459                     let returndata_size := mload(returndata)
460                     revert(add(32, returndata), returndata_size)
461                 }
462             } else {
463                 revert(errorMessage);
464             }
465         }
466     }
467 }
468 
469 contract Token is Context, IERC20 {
470     using SafeMath for uint256;
471     using Address for address;
472 
473     // Logged when the owner of a node assigns a new owner to a subnode.
474     event Initialized(address member, uint timestamp);
475 
476     mapping (address => uint256) private _balances;
477 
478     mapping (address => mapping (address => uint256)) private _allowances;
479 
480     uint256 private _totalSupply;
481     string private _name;
482     string private _symbol;
483     uint8 private _decimals;
484 
485     /**
486      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
487      * a default value of 18.
488      *
489      * To select a different value for {decimals}, use {_setupDecimals}.
490      *
491      * All three of these values are immutable: they can only be set once during
492      * construction.
493      */
494     
495     modifier NotInitialized() {
496         require(_totalSupply == 0, "Error: Contract already initialized");
497         _;
498     }
499     
500     function initialize (string memory name, string memory symbol, uint256 supply, address member) NotInitialized public {
501         _name = name;
502         _symbol = symbol;
503         _decimals = 0;
504         _totalSupply = supply;
505         _balances[member] = supply;
506         emit Initialized(member, now);
507     }
508 
509     /**
510      * @dev Returns the name of the token.
511      */
512     function name() public view returns (string memory) {
513         return _name;
514     }
515 
516     /**
517      * @dev Returns the symbol of the token, usually a shorter version of the
518      * name.
519      */
520     function symbol() public view returns (string memory) {
521         return _symbol;
522     }
523 
524     /**
525      * @dev Returns the number of decimals used to get its user representation.
526      * For example, if `decimals` equals `2`, a balance of `505` tokens should
527      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
528      *
529      * Tokens usually opt for a value of 18, imitating the relationship between
530      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
531      * called.
532      *
533      * NOTE: This information is only used for _display_ purposes: it in
534      * no way affects any of the arithmetic of the contract, including
535      * {IERC20-balanceOf} and {IERC20-transfer}.
536      */
537     function decimals() public view returns (uint8) {
538         return _decimals;
539     }
540 
541     /**
542      * @dev See {IERC20-totalSupply}.
543      */
544     function totalSupply() public view override returns (uint256) {
545         return _totalSupply;
546     }
547 
548     /**
549      * @dev See {IERC20-balanceOf}.
550      */
551     function balanceOf(address account) public view override returns (uint256) {
552         return _balances[account];
553     }
554 
555     /**
556      * @dev See {IERC20-transfer}.
557      *
558      * Requirements:
559      *
560      * - `recipient` cannot be the zero address.
561      * - the caller must have a balance of at least `amount`.
562      */
563     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
564         _transfer(_msgSender(), recipient, amount);
565         return true;
566     }
567 
568     /**
569      * @dev See {IERC20-allowance}.
570      */
571     function allowance(address owner, address spender) public view virtual override returns (uint256) {
572         return _allowances[owner][spender];
573     }
574 
575     /**
576      * @dev See {IERC20-approve}.
577      *
578      * Requirements:
579      *
580      * - `spender` cannot be the zero address.
581      */
582     function approve(address spender, uint256 amount) public virtual override returns (bool) {
583         _approve(_msgSender(), spender, amount);
584         return true;
585     }
586 
587     /**
588      * @dev See {IERC20-transferFrom}.
589      *
590      * Emits an {Approval} event indicating the updated allowance. This is not
591      * required by the EIP. See the note at the beginning of {ERC20};
592      *
593      * Requirements:
594      * - `sender` and `recipient` cannot be the zero address.
595      * - `sender` must have a balance of at least `amount`.
596      * - the caller must have allowance for ``sender``'s tokens of at least
597      * `amount`.
598      */
599     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
600         _transfer(sender, recipient, amount);
601         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
602         return true;
603     }
604 
605     /**
606      * @dev Atomically increases the allowance granted to `spender` by the caller.
607      *
608      * This is an alternative to {approve} that can be used as a mitigation for
609      * problems described in {IERC20-approve}.
610      *
611      * Emits an {Approval} event indicating the updated allowance.
612      *
613      * Requirements:
614      *
615      * - `spender` cannot be the zero address.
616      */
617     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
618         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
619         return true;
620     }
621 
622     /**
623      * @dev Atomically decreases the allowance granted to `spender` by the caller.
624      *
625      * This is an alternative to {approve} that can be used as a mitigation for
626      * problems described in {IERC20-approve}.
627      *
628      * Emits an {Approval} event indicating the updated allowance.
629      *
630      * Requirements:
631      *
632      * - `spender` cannot be the zero address.
633      * - `spender` must have allowance for the caller of at least
634      * `subtractedValue`.
635      */
636     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
637         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
638         return true;
639     }
640 
641     /**
642      * @dev Moves tokens `amount` from `sender` to `recipient`.
643      *
644      * This is internal function is equivalent to {transfer}, and can be used to
645      * e.g. implement automatic token fees, slashing mechanisms, etc.
646      *
647      * Emits a {Transfer} event.
648      *
649      * Requirements:
650      *
651      * - `sender` cannot be the zero address.
652      * - `recipient` cannot be the zero address.
653      * - `sender` must have a balance of at least `amount`.
654      */
655     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
656         require(sender != address(0), "ERC20: transfer from the zero address");
657         require(recipient != address(0), "ERC20: transfer to the zero address");
658 
659         _beforeTokenTransfer(sender, recipient, amount);
660 
661         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
662         _balances[recipient] = _balances[recipient].add(amount);
663         emit Transfer(sender, recipient, amount);
664     }
665 
666 
667     /**
668      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
669      *
670      * This internal function is equivalent to `approve`, and can be used to
671      * e.g. set automatic allowances for certain subsystems, etc.
672      *
673      * Emits an {Approval} event.
674      *
675      * Requirements:
676      *
677      * - `owner` cannot be the zero address.
678      * - `spender` cannot be the zero address.
679      */
680     function _approve(address owner, address spender, uint256 amount) internal virtual {
681         require(owner != address(0), "ERC20: approve from the zero address");
682         require(spender != address(0), "ERC20: approve to the zero address");
683 
684         _allowances[owner][spender] = amount;
685         emit Approval(owner, spender, amount);
686     }
687 
688     /**
689      * @dev Sets {decimals} to a value other than the default one of 18.
690      *
691      * WARNING: This function should only be called from the constructor. Most
692      * applications that interact with token contracts will not expect
693      * {decimals} to ever change, and may work incorrectly if it does.
694      */
695     function _setupDecimals(uint8 decimals_) internal {
696         _decimals = decimals_;
697     }
698 
699     /**
700      * @dev Hook that is called before any transfer of tokens. This includes
701      * minting and burning.
702      *
703      * Calling conditions:
704      *
705      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
706      * will be to transferred to `to`.
707      * - when `from` is zero, `amount` tokens will be minted for `to`.
708      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
709      * - `from` and `to` are never both zero.
710      *
711      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
712      */
713     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
714 }