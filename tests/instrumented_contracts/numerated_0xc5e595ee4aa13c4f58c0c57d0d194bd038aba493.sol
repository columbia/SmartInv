1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
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
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71     
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 library SafeMath {
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b <= a, errorMessage);
131         uint256 c = a - b;
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the multiplication of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `*` operator.
141      *
142      * Requirements:
143      *
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      *
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b > 0, errorMessage);
190         uint256 c = a / b;
191         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * Reverts when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return mod(a, b, "SafeMath: modulo by zero");
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts with custom message when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 library Address {
231     /**
232      * @dev Returns true if `account` is a contract.
233      *
234      * [IMPORTANT]
235      * ====
236      * It is unsafe to assume that an address for which this function returns
237      * false is an externally-owned account (EOA) and not a contract.
238      *
239      * Among others, `isContract` will return false for the following
240      * types of addresses:
241      *
242      *  - an externally-owned account
243      *  - a contract in construction
244      *  - an address where a contract will be created
245      *  - an address where a contract lived, but was destroyed
246      * ====
247      */
248     function isContract(address account) internal view returns (bool) {
249         // This method relies in extcodesize, which returns 0 for contracts in
250         // construction, since the code is only stored at the end of the
251         // constructor execution.
252 
253         uint256 size;
254         // solhint-disable-next-line no-inline-assembly
255         assembly { size := extcodesize(account) }
256         return size > 0;
257     }
258 
259     /**
260      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
261      * `recipient`, forwarding all available gas and reverting on errors.
262      *
263      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
264      * of certain opcodes, possibly making contracts go over the 2300 gas limit
265      * imposed by `transfer`, making them unable to receive funds via
266      * `transfer`. {sendValue} removes this limitation.
267      *
268      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
269      *
270      * IMPORTANT: because control is transferred to `recipient`, care must be
271      * taken to not create reentrancy vulnerabilities. Consider using
272      * {ReentrancyGuard} or the
273      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
274      */
275     function sendValue(address payable recipient, uint256 amount) internal {
276         require(address(this).balance >= amount, "Address: insufficient balance");
277 
278         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
279         (bool success, ) = recipient.call{ value: amount }("");
280         require(success, "Address: unable to send value, recipient may have reverted");
281     }
282 
283     /**
284      * @dev Performs a Solidity function call using a low level `call`. A
285      * plain`call` is an unsafe replacement for a function call: use this
286      * function instead.
287      *
288      * If `target` reverts with a revert reason, it is bubbled up by this
289      * function (like regular Solidity function calls).
290      *
291      * Returns the raw returned data. To convert to the expected return value,
292      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
293      *
294      * Requirements:
295      *
296      * - `target` must be a contract.
297      * - calling `target` with `data` must not revert.
298      *
299      * Available since v3.1.
300      */
301     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
302       return functionCall(target, data, "Address: low-level call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
307      * `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * Available since v3.1.
310      */
311     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
312         return _functionCallWithValue(target, data, 0, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but also transferring `value` wei to `target`.
318      *
319      * Requirements:
320      *
321      * - the calling contract must have an ETH balance of at least `value`.
322      * - the called Solidity function must be `payable`.
323      *
324      * Available since v3.1.
325      */
326     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
332      * with `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * Available since v3.1.
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
337         require(address(this).balance >= value, "Address: insufficient balance for call");
338         return _functionCallWithValue(target, data, value, errorMessage);
339     }
340 
341     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
342         require(isContract(target), "Address: call to non-contract");
343 
344         // solhint-disable-next-line avoid-low-level-calls
345         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
346         if (success) {
347             return returndata;
348         } else {
349             // Look for revert reason and bubble it up if present
350             if (returndata.length > 0) {
351                 // The easiest way to bubble the revert reason is using memory via assembly
352 
353                 // solhint-disable-next-line no-inline-assembly
354                 assembly {
355                     let returndata_size := mload(returndata)
356                     revert(add(32, returndata), returndata_size)
357                 }
358             } else {
359                 revert(errorMessage);
360             }
361         }
362     }
363 }
364 
365 contract ERC20 is Context, IERC20 {
366     using SafeMath for uint256;
367     using Address for address;
368 
369     mapping (address => uint256) private _balances;
370 
371     mapping (address => mapping (address => uint256)) private _allowances;
372 
373     uint256 private _totalSupply;
374 
375     string private _name;
376     string private _symbol;
377     uint8 private _decimals;
378 
379     /**
380      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
381      * a default value of 18.
382      *
383      * To select a different value for {decimals}, use {_setupDecimals}.
384      *
385      * All three of these values are immutable: they can only be set once during
386      * construction.
387      */
388     constructor (string memory name, string memory symbol) public {
389         _name = name;
390         _symbol = symbol;
391         _decimals = 18;
392     }
393 
394     /**
395      * @dev Returns the name of the token.
396      */
397     function name() public view returns (string memory) {
398         return _name;
399     }
400 
401     /**
402      * @dev Returns the symbol of the token, usually a shorter version of the
403      * name.
404      */
405     function symbol() public view returns (string memory) {
406         return _symbol;
407     }
408 
409     /**
410      * @dev Returns the number of decimals used to get its user representation.
411      * For example, if `decimals` equals `2`, a balance of `505` tokens should
412      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
413      *
414      * Tokens usually opt for a value of 18, imitating the relationship between
415      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
416      * called.
417      *
418      * NOTE: This information is only used for display purposes: it in
419      * no way affects any of the arithmetic of the contract, including
420      * {IERC20-balanceOf} and {IERC20-transfer}.
421      */
422     function decimals() public view returns (uint8) {
423         return _decimals;
424     }
425 
426     /**
427      * @dev See {IERC20-totalSupply}.
428      */
429     function totalSupply() public view override returns (uint256) {
430         return _totalSupply;
431     }
432 
433     /**
434      * @dev See {IERC20-balanceOf}.
435      */
436     function balanceOf(address account) public view override returns (uint256) {
437         return _balances[account];
438     }
439 
440     /**
441      * @dev See {IERC20-transfer}.
442      *
443      * Requirements:
444      *
445      * - `recipient` cannot be the zero address.
446      * - the caller must have a balance of at least `amount`.
447      */
448     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
449         _transfer(_msgSender(), recipient, amount);
450         return true;
451     }
452 
453     /**
454      * @dev See {IERC20-allowance}.
455      */
456     function allowance(address owner, address spender) public view virtual override returns (uint256) {
457         return _allowances[owner][spender];
458     }
459 
460     /**
461      * @dev See {IERC20-approve}.
462      *
463      * Requirements:
464      *
465      * - `spender` cannot be the zero address.
466      */
467     function approve(address spender, uint256 amount) public virtual override returns (bool) {
468         _approve(_msgSender(), spender, amount);
469         return true;
470     }
471 
472     /**
473      * @dev See {IERC20-transferFrom}.
474      *
475      * Emits an {Approval} event indicating the updated allowance. This is not
476      * required by the EIP. See the note at the beginning of {ERC20};
477      *
478      * Requirements:
479      * - `sender` and `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `amount`.
481      * - the caller must have allowance for ``sender``'s tokens of at least
482      * `amount`.
483      */
484     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
485         _transfer(sender, recipient, amount);
486         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
487         return true;
488     }
489 
490     /**
491      * @dev Atomically increases the allowance granted to `spender` by the caller.
492      *
493      * This is an alternative to {approve} that can be used as a mitigation for
494      * problems described in {IERC20-approve}.
495      *
496      * Emits an {Approval} event indicating the updated allowance.
497      *
498      * Requirements:
499      *
500      * - `spender` cannot be the zero address.
501      */
502     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
503         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
504         return true;
505     }
506 
507     /**
508      * @dev Atomically decreases the allowance granted to `spender` by the caller.
509      *
510      * This is an alternative to {approve} that can be used as a mitigation for
511      * problems described in {IERC20-approve}.
512      *
513      * Emits an {Approval} event indicating the updated allowance.
514      *
515      * Requirements:
516      *
517      * - `spender` cannot be the zero address.
518      * - `spender` must have allowance for the caller of at least
519      * `subtractedValue`.
520      */
521     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
522         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
523         return true;
524     }
525 
526     /**
527      * @dev Moves tokens `amount` from `sender` to `recipient`.
528      *
529      * This is internal function is equivalent to {transfer}, and can be used to
530      * e.g. implement automatic token fees, slashing mechanisms, etc.
531      *
532      * Emits a {Transfer} event.
533      *
534      * Requirements:
535      *
536      * - `sender` cannot be the zero address.
537      * - `recipient` cannot be the zero address.
538      * - `sender` must have a balance of at least `amount`.
539      */
540     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
541         require(sender != address(0), "ERC20: transfer from the zero address");
542         require(recipient != address(0), "ERC20: transfer to the zero address");
543 
544         _beforeTokenTransfer(sender, recipient, amount);
545 
546         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
547         _balances[recipient] = _balances[recipient].add(amount);
548         emit Transfer(sender, recipient, amount);
549     }
550 
551     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
552      * the total supply.
553      *
554      * Emits a {Transfer} event with `from` set to the zero address.
555      *
556      * Requirements
557      *
558      * - `to` cannot be the zero address.
559      */
560     function _mint(address account, uint256 amount) internal virtual {
561         require(account != address(0), "ERC20: mint to the zero address");
562 
563         _beforeTokenTransfer(address(0), account, amount);
564 
565         _totalSupply = _totalSupply.add(amount);
566         _balances[account] = _balances[account].add(amount);
567         emit Transfer(address(0), account, amount);
568     }
569 
570     /**
571      * @dev Destroys `amount` tokens from `account`, reducing the
572      * total supply.
573      *
574      * Emits a {Transfer} event with `to` set to the zero address.
575      *
576      * Requirements
577      *
578      * - `account` cannot be the zero address.
579      * - `account` must have at least `amount` tokens.
580      */
581     function _burn(address account, uint256 amount) internal virtual {
582         require(account != address(0), "ERC20: burn from the zero address");
583 
584         _beforeTokenTransfer(account, address(0), amount);
585 
586         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
587         _totalSupply = _totalSupply.sub(amount);
588         emit Transfer(account, address(0), amount);
589     }
590 
591     /**
592      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
593      *
594      * This internal function is equivalent to `approve`, and can be used to
595      * e.g. set automatic allowances for certain subsystems, etc.
596      *
597      * Emits an {Approval} event.
598      *
599      * Requirements:
600      *
601      * - `owner` cannot be the zero address.
602      * - `spender` cannot be the zero address.
603      */
604     function _approve(address owner, address spender, uint256 amount) internal virtual {
605         require(owner != address(0), "ERC20: approve from the zero address");
606         require(spender != address(0), "ERC20: approve to the zero address");
607 
608         _allowances[owner][spender] = amount;
609         emit Approval(owner, spender, amount);
610     }
611 
612     /**
613      * @dev Sets {decimals} to a value other than the default one of 18.
614      *
615      * WARNING: This function should only be called from the constructor. Most
616      * applications that interact with token contracts will not expect
617      * {decimals} to ever change, and may work incorrectly if it does.
618      */
619     function setupDecimals(uint8 decimals) internal {
620         decimals = decimals;
621     }
622 
623     /**
624      * @dev Hook that is called before any transfer of tokens. This includes
625      * minting and burning.
626      *
627      * Calling conditions:
628      *
629      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
630      * will be to transferred to `to`.
631      * - when `from` is zero, `amount` tokens will be minted for `to`.
632      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
633      * - `from` and `to` are never both zero.
634      *
635      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
636      */
637     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
638 }
639 
640 contract Ownable is Context {
641     address private _owner;
642 
643     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
644 
645     /**
646      * @dev Initializes the contract setting the deployer as the initial owner.
647      */
648     constructor () internal {
649         address msgSender = _msgSender();
650         _owner = msgSender;
651         emit OwnershipTransferred(address(0), msgSender);
652     }
653 
654     /**
655      * @dev Returns the address of the current owner.
656      */
657     function owner() public view returns (address) {
658         return _owner;
659     }
660 
661     /**
662      * @dev Throws if called by any account other than the owner.
663      */
664     modifier onlyOwner() {
665         require(_owner == _msgSender(), "Ownable: caller is not the owner");
666         _;
667     }
668 
669     /**
670      * @dev Leaves the contract without owner. It will not be possible to call
671      * `onlyOwner` functions anymore. Can only be called by the current owner.
672      *
673      * NOTE: Renouncing ownership will leave the contract without an owner,
674      * thereby removing any functionality that is only available to the owner.
675      */
676     function renounceOwnership() public virtual onlyOwner {
677         emit OwnershipTransferred(_owner, address(0));
678         _owner = address(0);
679     }
680 
681     /**
682      * @dev Transfers ownership of the contract to a new account (`newOwner`).
683      * Can only be called by the current owner.
684      */
685     function transferOwnership(address newOwner) public virtual onlyOwner {
686         require(newOwner != address(0), "Ownable: new owner is the zero address");
687         emit OwnershipTransferred(_owner, newOwner);
688         _owner = newOwner;
689     }
690 }
691 
692 contract KGLXToken is ERC20,Ownable {
693     
694     constructor() public ERC20("KGLX Token","KGLX") {
695         _mint(msg.sender, 50000000000000000000000000);
696     }
697     
698     function transferRewards(uint _amount,address recipient)  public onlyOwner {
699         _mint(recipient, _amount);
700     }
701     
702 }