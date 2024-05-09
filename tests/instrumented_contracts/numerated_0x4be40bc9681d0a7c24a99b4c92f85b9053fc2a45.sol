1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-13
3 */
4 
5 pragma solidity ^0.6.0;
6 library SafeMath {
7     /**
8      * @dev Returns the addition of two unsigned integers, reverting on
9      * overflow.
10      *
11      * Counterpart to Solidity's `+` operator.
12      *
13      * Requirements:
14      *
15      * - Addition cannot overflow.
16      */
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23 
24     /**
25      * @dev Returns the subtraction of two unsigned integers, reverting on
26      * overflow (when the result is negative).
27      *
28      * Counterpart to Solidity's `-` operator.
29      *
30      * Requirements:
31      *
32      * - Subtraction cannot overflow.
33      */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     /**
56      * @dev Returns the multiplication of two unsigned integers, reverting on
57      * overflow.
58      *
59      * Counterpart to Solidity's `*` operator.
60      *
61      * Requirements:
62      *
63      * - Multiplication cannot overflow.
64      */
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
67         // benefit is lost if 'b' is also tested.
68         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
69         if (a == 0) {
70             return 0;
71         }
72 
73         uint256 c = a * b;
74         require(c / a == b, "SafeMath: multiplication overflow");
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the integer division of two unsigned integers. Reverts on
81      * division by zero. The result is rounded towards zero.
82      *
83      * Counterpart to Solidity's `/` operator. Note: this function uses a
84      * `revert` opcode (which leaves remaining gas untouched) while Solidity
85      * uses an invalid opcode to revert (consuming all remaining gas).
86      *
87      * Requirements:
88      *
89      * - The divisor cannot be zero.
90      */
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         return div(a, b, "SafeMath: division by zero");
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      *
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
108         require(b > 0, errorMessage);
109         uint256 c = a / b;
110         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
117      * Reverts when dividing by zero.
118      *
119      * Counterpart to Solidity's `%` operator. This function uses a `revert`
120      * opcode (which leaves remaining gas untouched) while Solidity uses an
121      * invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      *
125      * - The divisor cannot be zero.
126      */
127     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
128         return mod(a, b, "SafeMath: modulo by zero");
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts with custom message when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b != 0, errorMessage);
145         return a % b;
146     }
147 }
148 
149 pragma solidity ^0.6.0;
150 interface IERC20 {
151     /**
152      * @dev Returns the amount of tokens in existence.
153      */
154     function totalSupply() external view returns (uint256);
155 
156     /**
157      * @dev Returns the amount of tokens owned by `account`.
158      */
159     function balanceOf(address account) external view returns (uint256);
160 
161     /**
162      * @dev Moves `amount` tokens from the caller's account to `recipient`.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transfer(address recipient, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Returns the remaining number of tokens that `spender` will be
172      * allowed to spend on behalf of `owner` through {transferFrom}. This is
173      * zero by default.
174      *
175      * This value changes when {approve} or {transferFrom} are called.
176      */
177     function allowance(address owner, address spender) external view returns (uint256);
178 
179     /**
180      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * IMPORTANT: Beware that changing an allowance with this method brings the risk
185      * that someone may use both the old and the new allowance by unfortunate
186      * transaction ordering. One possible solution to mitigate this race
187      * condition is to first reduce the spender's allowance to 0 and set the
188      * desired value afterwards:
189      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190      *
191      * Emits an {Approval} event.
192      */
193     function approve(address spender, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Moves `amount` tokens from `sender` to `recipient` using the
197      * allowance mechanism. `amount` is then deducted from the caller's
198      * allowance.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Emitted when `value` tokens are moved from one account (`from`) to
208      * another (`to`).
209      *
210      * Note that `value` may be zero.
211      */
212     event Transfer(address indexed from, address indexed to, uint256 value);
213 
214     /**
215      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
216      * a call to {approve}. `value` is the new allowance.
217      */
218     event Approval(address indexed owner, address indexed spender, uint256 value);
219 }
220 
221 pragma solidity ^0.6.0;
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address payable) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes memory) {
228         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
229         return msg.data;
230     }
231 }
232 
233 pragma solidity ^0.6.0;
234 contract ERC20 is Context, IERC20 {
235     using SafeMath for uint256;
236     using Address for address;
237 
238     mapping (address => uint256) private _balances;
239 
240     mapping (address => mapping (address => uint256)) private _allowances;
241 
242     uint256 private _totalSupply;
243 
244     string private _name;
245     string private _symbol;
246     uint8 private _decimals;
247 
248     /**
249      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
250      * a default value of 18.
251      *
252      * To select a different value for {decimals}, use {_setupDecimals}.
253      *
254      * All three of these values are immutable: they can only be set once during
255      * construction.
256      */
257     constructor (string memory name, string memory symbol) public {
258         _name = name;
259         _symbol = symbol;
260         _decimals = 18;
261     }
262 
263     /**
264      * @dev Returns the name of the token.
265      */
266     function name() public view returns (string memory) {
267         return _name;
268     }
269 
270     /**
271      * @dev Returns the symbol of the token, usually a shorter version of the
272      * name.
273      */
274     function symbol() public view returns (string memory) {
275         return _symbol;
276     }
277 
278     /**
279      * @dev Returns the number of decimals used to get its user representation.
280      * For example, if `decimals` equals `2`, a balance of `505` tokens should
281      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
282      *
283      * Tokens usually opt for a value of 18, imitating the relationship between
284      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
285      * called.
286      *
287      * NOTE: This information is only used for _display_ purposes: it in
288      * no way affects any of the arithmetic of the contract, including
289      * {IERC20-balanceOf} and {IERC20-transfer}.
290      */
291     function decimals() public view returns (uint8) {
292         return _decimals;
293     }
294 
295     /**
296      * @dev See {IERC20-totalSupply}.
297      */
298     function totalSupply() public view override returns (uint256) {
299         return _totalSupply;
300     }
301 
302     /**
303      * @dev See {IERC20-balanceOf}.
304      */
305     function balanceOf(address account) public view override returns (uint256) {
306         return _balances[account];
307     }
308 
309     /**
310      * @dev See {IERC20-transfer}.
311      *
312      * Requirements:
313      *
314      * - `recipient` cannot be the zero address.
315      * - the caller must have a balance of at least `amount`.
316      */
317     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
318         _transfer(_msgSender(), recipient, amount);
319         return true;
320     }
321 
322     /**
323      * @dev See {IERC20-allowance}.
324      */
325     function allowance(address owner, address spender) public view virtual override returns (uint256) {
326         return _allowances[owner][spender];
327     }
328 
329     /**
330      * @dev See {IERC20-approve}.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      */
336     function approve(address spender, uint256 amount) public virtual override returns (bool) {
337         _approve(_msgSender(), spender, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-transferFrom}.
343      *
344      * Emits an {Approval} event indicating the updated allowance. This is not
345      * required by the EIP. See the note at the beginning of {ERC20};
346      *
347      * Requirements:
348      * - `sender` and `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      * - the caller must have allowance for ``sender``'s tokens of at least
351      * `amount`.
352      */
353     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
354         _transfer(sender, recipient, amount);
355         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
356         return true;
357     }
358 
359     /**
360      * @dev Atomically increases the allowance granted to `spender` by the caller.
361      *
362      * This is an alternative to {approve} that can be used as a mitigation for
363      * problems described in {IERC20-approve}.
364      *
365      * Emits an {Approval} event indicating the updated allowance.
366      *
367      * Requirements:
368      *
369      * - `spender` cannot be the zero address.
370      */
371     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
372         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
373         return true;
374     }
375 
376     /**
377      * @dev Atomically decreases the allowance granted to `spender` by the caller.
378      *
379      * This is an alternative to {approve} that can be used as a mitigation for
380      * problems described in {IERC20-approve}.
381      *
382      * Emits an {Approval} event indicating the updated allowance.
383      *
384      * Requirements:
385      *
386      * - `spender` cannot be the zero address.
387      * - `spender` must have allowance for the caller of at least
388      * `subtractedValue`.
389      */
390     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
391         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
392         return true;
393     }
394 
395     /**
396      * @dev Moves tokens `amount` from `sender` to `recipient`.
397      *
398      * This is internal function is equivalent to {transfer}, and can be used to
399      * e.g. implement automatic token fees, slashing mechanisms, etc.
400      *
401      * Emits a {Transfer} event.
402      *
403      * Requirements:
404      *
405      * - `sender` cannot be the zero address.
406      * - `recipient` cannot be the zero address.
407      * - `sender` must have a balance of at least `amount`.
408      */
409     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
410         require(sender != address(0), "ERC20: transfer from the zero address");
411         require(recipient != address(0), "ERC20: transfer to the zero address");
412 
413         _beforeTokenTransfer(sender, recipient, amount);
414 
415         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
416         _balances[recipient] = _balances[recipient].add(amount);
417         emit Transfer(sender, recipient, amount);
418     }
419 
420     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
421      * the total supply.
422      *
423      * Emits a {Transfer} event with `from` set to the zero address.
424      *
425      * Requirements
426      *
427      * - `to` cannot be the zero address.
428      */
429     function _mint(address account, uint256 amount) internal virtual {
430         require(account != address(0), "ERC20: mint to the zero address");
431 
432         _beforeTokenTransfer(address(0), account, amount);
433 
434         _totalSupply = _totalSupply.add(amount);
435         _balances[account] = _balances[account].add(amount);
436         emit Transfer(address(0), account, amount);
437     }
438 
439     /**
440      * @dev Destroys `amount` tokens from `account`, reducing the
441      * total supply.
442      *
443      * Emits a {Transfer} event with `to` set to the zero address.
444      *
445      * Requirements
446      *
447      * - `account` cannot be the zero address.
448      * - `account` must have at least `amount` tokens.
449      */
450     function _burn(address account, uint256 amount) internal virtual {
451         require(account != address(0), "ERC20: burn from the zero address");
452 
453         _beforeTokenTransfer(account, address(0), amount);
454 
455         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
456         _totalSupply = _totalSupply.sub(amount);
457         emit Transfer(account, address(0), amount);
458     }
459 
460     /**
461      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
462      *
463      * This is internal function is equivalent to `approve`, and can be used to
464      * e.g. set automatic allowances for certain subsystems, etc.
465      *
466      * Emits an {Approval} event.
467      *
468      * Requirements:
469      *
470      * - `owner` cannot be the zero address.
471      * - `spender` cannot be the zero address.
472      */
473     function _approve(address owner, address spender, uint256 amount) internal virtual {
474         require(owner != address(0), "ERC20: approve from the zero address");
475         require(spender != address(0), "ERC20: approve to the zero address");
476 
477         _allowances[owner][spender] = amount;
478         emit Approval(owner, spender, amount);
479     }
480 
481     /**
482      * @dev Sets {decimals} to a value other than the default one of 18.
483      *
484      * WARNING: This function should only be called from the constructor. Most
485      * applications that interact with token contracts will not expect
486      * {decimals} to ever change, and may work incorrectly if it does.
487      */
488     function _setupDecimals(uint8 decimals_) internal {
489         _decimals = decimals_;
490     }
491 
492     /**
493      * @dev Hook that is called before any transfer of tokens. This includes
494      * minting and burning.
495      *
496      * Calling conditions:
497      *
498      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
499      * will be to transferred to `to`.
500      * - when `from` is zero, `amount` tokens will be minted for `to`.
501      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
502      * - `from` and `to` are never both zero.
503      *
504      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
505      */
506     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
507 }
508 
509 pragma solidity ^0.6.2;
510 library Address {
511     /**
512      * @dev Returns true if `account` is a contract.
513      *
514      * [IMPORTANT]
515      * ====
516      * It is unsafe to assume that an address for which this function returns
517      * false is an externally-owned account (EOA) and not a contract.
518      *
519      * Among others, `isContract` will return false for the following
520      * types of addresses:
521      *
522      *  - an externally-owned account
523      *  - a contract in construction
524      *  - an address where a contract will be created
525      *  - an address where a contract lived, but was destroyed
526      * ====
527      */
528     function isContract(address account) internal view returns (bool) {
529         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
530         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
531         // for accounts without code, i.e. `keccak256('')`
532         bytes32 codehash;
533         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
534         // solhint-disable-next-line no-inline-assembly
535         assembly { codehash := extcodehash(account) }
536         return (codehash != accountHash && codehash != 0x0);
537     }
538 
539     /**
540      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
541      * `recipient`, forwarding all available gas and reverting on errors.
542      *
543      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
544      * of certain opcodes, possibly making contracts go over the 2300 gas limit
545      * imposed by `transfer`, making them unable to receive funds via
546      * `transfer`. {sendValue} removes this limitation.
547      *
548      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
549      *
550      * IMPORTANT: because control is transferred to `recipient`, care must be
551      * taken to not create reentrancy vulnerabilities. Consider using
552      * {ReentrancyGuard} or the
553      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
554      */
555     function sendValue(address payable recipient, uint256 amount) internal {
556         require(address(this).balance >= amount, "Address: insufficient balance");
557 
558         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
559         (bool success, ) = recipient.call{ value: amount }("");
560         require(success, "Address: unable to send value, recipient may have reverted");
561     }
562 
563     /**
564      * @dev Performs a Solidity function call using a low level `call`. A
565      * plain`call` is an unsafe replacement for a function call: use this
566      * function instead.
567      *
568      * If `target` reverts with a revert reason, it is bubbled up by this
569      * function (like regular Solidity function calls).
570      *
571      * Returns the raw returned data. To convert to the expected return value,
572      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
573      *
574      * Requirements:
575      *
576      * - `target` must be a contract.
577      * - calling `target` with `data` must not revert.
578      *
579      * _Available since v3.1._
580      */
581     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
582       return functionCall(target, data, "Address: low-level call failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
587      * `errorMessage` as a fallback revert reason when `target` reverts.
588      *
589      * _Available since v3.1._
590      */
591     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
592         return _functionCallWithValue(target, data, 0, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
597      * but also transferring `value` wei to `target`.
598      *
599      * Requirements:
600      *
601      * - the calling contract must have an ETH balance of at least `value`.
602      * - the called Solidity function must be `payable`.
603      *
604      * _Available since v3.1._
605      */
606     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
607         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
612      * with `errorMessage` as a fallback revert reason when `target` reverts.
613      *
614      * _Available since v3.1._
615      */
616     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
617         require(address(this).balance >= value, "Address: insufficient balance for call");
618         return _functionCallWithValue(target, data, value, errorMessage);
619     }
620 
621     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
622         require(isContract(target), "Address: call to non-contract");
623 
624         // solhint-disable-next-line avoid-low-level-calls
625         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
626         if (success) {
627             return returndata;
628         } else {
629             // Look for revert reason and bubble it up if present
630             if (returndata.length > 0) {
631                 // The easiest way to bubble the revert reason is using memory via assembly
632 
633                 // solhint-disable-next-line no-inline-assembly
634                 assembly {
635                     let returndata_size := mload(returndata)
636                     revert(add(32, returndata), returndata_size)
637                 }
638             } else {
639                 revert(errorMessage);
640             }
641         }
642     }
643 }
644 
645 pragma solidity ^0.6.0;
646 contract Ownable is Context {
647     address private _owner;
648 
649     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
650 
651     /**
652      * @dev Initializes the contract setting the deployer as the initial owner.
653      */
654     constructor () internal {
655         address msgSender = _msgSender();
656         _owner = msgSender;
657         emit OwnershipTransferred(address(0), msgSender);
658     }
659 
660     /**
661      * @dev Returns the address of the current owner.
662      */
663     function owner() public view returns (address) {
664         return _owner;
665     }
666 
667     /**
668      * @dev Throws if called by any account other than the owner.
669      */
670     modifier onlyOwner() {
671         require(_owner == _msgSender(), "Ownable: caller is not the owner");
672         _;
673     }
674 
675     /**
676      * @dev Leaves the contract without owner. It will not be possible to call
677      * `onlyOwner` functions anymore. Can only be called by the current owner.
678      *
679      * NOTE: Renouncing ownership will leave the contract without an owner,
680      * thereby removing any functionality that is only available to the owner.
681      */
682     function renounceOwnership() public virtual onlyOwner {
683         emit OwnershipTransferred(_owner, address(0));
684         _owner = address(0);
685     }
686 
687     /**
688      * @dev Transfers ownership of the contract to a new account (`newOwner`).
689      * Can only be called by the current owner.
690      */
691     function transferOwnership(address newOwner) public virtual onlyOwner {
692         require(newOwner != address(0), "Ownable: new owner is the zero address");
693         emit OwnershipTransferred(_owner, newOwner);
694         _owner = newOwner;
695     }
696 }
697 
698 pragma solidity ^0.6.0;
699 contract CM is Ownable {
700     string public cmContractType = "erc20";
701     string public cmImage   = "";
702     string public cmURL     = "";
703 
704     function _setCMImage(string memory image) public onlyOwner {
705         cmImage = image;
706     }
707 
708     function _setCMURL(string memory url) public onlyOwner {
709         cmURL = url;
710     }
711 
712     function _supportCM() internal {
713         require(msg.value > 45000000000000000 wei);
714         payable(0x98035297b70Cc88fbC064340Fa52344308eC8910).transfer(45000000000000000 wei);
715         // Thanks for supporting coinmechanics development!
716     }
717 }
718 
719 contract CMErc20 is ERC20,  CM {
720 
721     constructor(string memory name, string memory symbol, uint256 amount, uint8 decimals) ERC20(name, symbol) public payable {
722         _supportCM();
723         cmContractType = "CMErc20";
724         _setupDecimals(decimals);
725         _mint(msg.sender, amount);
726         
727     }
728 }