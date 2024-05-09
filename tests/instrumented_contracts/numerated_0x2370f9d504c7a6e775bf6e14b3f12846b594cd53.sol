1 pragma solidity ^0.6.2;
2 
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a {Transfer} event.
20      */
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through {transferFrom}. This is
26      * zero by default.
27      *
28      * This value changes when {approve} or {transferFrom} are called.
29      */
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     /**
33      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * IMPORTANT: Beware that changing an allowance with this method brings the risk
38      * that someone may use both the old and the new allowance by unfortunate
39      * transaction ordering. One possible solution to mitigate this race
40      * condition is to first reduce the spender's allowance to 0 and set the
41      * desired value afterwards:
42      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43      *
44      * Emits an {Approval} event.
45      */
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Moves `amount` tokens from `sender` to `recipient` using the
50      * allowance mechanism. `amount` is then deducted from the caller's
51      * allowance.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Emitted when `value` tokens are moved from one account (`from`) to
61      * another (`to`).
62      *
63      * Note that `value` may be zero.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /**
68      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69      * a call to {approve}. `value` is the new allowance.
70      */
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 abstract contract Context {
75     function _msgSender() internal view virtual returns (address payable) {
76         return msg.sender;
77     }
78 
79     function _msgData() internal view virtual returns (bytes memory) {
80         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
81         return msg.data;
82     }
83 }
84 
85 contract ERC20 is Context, IERC20 {
86     using SafeMath for uint256;
87     using Address for address;
88 
89     mapping (address => uint256) private _balances;
90 
91     mapping (address => mapping (address => uint256)) private _allowances;
92 
93     uint256 private _totalSupply;
94 
95     string private _name;
96     string private _symbol;
97     uint8 private _decimals;
98 
99     /**
100      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
101      * a default value of 18.
102      *
103      * To select a different value for {decimals}, use {_setupDecimals}.
104      *
105      * All three of these values are immutable: they can only be set once during
106      * construction.
107      */
108     constructor (string memory name, string memory symbol) public {
109         _name = name;
110         _symbol = symbol;
111         _decimals = 18;
112     }
113 
114     /**
115      * @dev Returns the name of the token.
116      */
117     function name() public view returns (string memory) {
118         return _name;
119     }
120 
121     /**
122      * @dev Returns the symbol of the token, usually a shorter version of the
123      * name.
124      */
125     function symbol() public view returns (string memory) {
126         return _symbol;
127     }
128 
129     /**
130      * @dev Returns the number of decimals used to get its user representation.
131      * For example, if `decimals` equals `2`, a balance of `505` tokens should
132      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
133      *
134      * Tokens usually opt for a value of 18, imitating the relationship between
135      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
136      * called.
137      *
138      * NOTE: This information is only used for _display_ purposes: it in
139      * no way affects any of the arithmetic of the contract, including
140      * {IERC20-balanceOf} and {IERC20-transfer}.
141      */
142     function decimals() public view returns (uint8) {
143         return _decimals;
144     }
145 
146     /**
147      * @dev See {IERC20-totalSupply}.
148      */
149     function totalSupply() public view override returns (uint256) {
150         return _totalSupply;
151     }
152 
153     /**
154      * @dev See {IERC20-balanceOf}.
155      */
156     function balanceOf(address account) public view override returns (uint256) {
157         return _balances[account];
158     }
159 
160     /**
161      * @dev See {IERC20-transfer}.
162      *
163      * Requirements:
164      *
165      * - `recipient` cannot be the zero address.
166      * - the caller must have a balance of at least `amount`.
167      */
168     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
169         _transfer(_msgSender(), recipient, amount);
170         return true;
171     }
172 
173     /**
174      * @dev See {IERC20-allowance}.
175      */
176     function allowance(address owner, address spender) public view virtual override returns (uint256) {
177         return _allowances[owner][spender];
178     }
179 
180     /**
181      * @dev See {IERC20-approve}.
182      *
183      * Requirements:
184      *
185      * - `spender` cannot be the zero address.
186      */
187     function approve(address spender, uint256 amount) public virtual override returns (bool) {
188         _approve(_msgSender(), spender, amount);
189         return true;
190     }
191 
192     /**
193      * @dev See {IERC20-transferFrom}.
194      *
195      * Emits an {Approval} event indicating the updated allowance. This is not
196      * required by the EIP. See the note at the beginning of {ERC20};
197      *
198      * Requirements:
199      * - `sender` and `recipient` cannot be the zero address.
200      * - `sender` must have a balance of at least `amount`.
201      * - the caller must have allowance for ``sender``'s tokens of at least
202      * `amount`.
203      */
204     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
205         _transfer(sender, recipient, amount);
206         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207         return true;
208     }
209 
210     /**
211      * @dev Atomically increases the allowance granted to `spender` by the caller.
212      *
213      * This is an alternative to {approve} that can be used as a mitigation for
214      * problems described in {IERC20-approve}.
215      *
216      * Emits an {Approval} event indicating the updated allowance.
217      *
218      * Requirements:
219      *
220      * - `spender` cannot be the zero address.
221      */
222     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
223         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
224         return true;
225     }
226 
227     /**
228      * @dev Atomically decreases the allowance granted to `spender` by the caller.
229      *
230      * This is an alternative to {approve} that can be used as a mitigation for
231      * problems described in {IERC20-approve}.
232      *
233      * Emits an {Approval} event indicating the updated allowance.
234      *
235      * Requirements:
236      *
237      * - `spender` cannot be the zero address.
238      * - `spender` must have allowance for the caller of at least
239      * `subtractedValue`.
240      */
241     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
242         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
243         return true;
244     }
245 
246     /**
247      * @dev Moves tokens `amount` from `sender` to `recipient`.
248      *
249      * This is internal function is equivalent to {transfer}, and can be used to
250      * e.g. implement automatic token fees, slashing mechanisms, etc.
251      *
252      * Emits a {Transfer} event.
253      *
254      * Requirements:
255      *
256      * - `sender` cannot be the zero address.
257      * - `recipient` cannot be the zero address.
258      * - `sender` must have a balance of at least `amount`.
259      */
260     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
261         require(sender != address(0), "ERC20: transfer from the zero address");
262         require(recipient != address(0), "ERC20: transfer to the zero address");
263 
264         _beforeTokenTransfer(sender, recipient, amount);
265 
266         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
267         _balances[recipient] = _balances[recipient].add(amount);
268         emit Transfer(sender, recipient, amount);
269     }
270 
271     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
272      * the total supply.
273      *
274      * Emits a {Transfer} event with `from` set to the zero address.
275      *
276      * Requirements
277      *
278      * - `to` cannot be the zero address.
279      */
280     function _mint(address account, uint256 amount) internal virtual {
281         require(account != address(0), "ERC20: mint to the zero address");
282 
283         _beforeTokenTransfer(address(0), account, amount);
284 
285         _totalSupply = _totalSupply.add(amount);
286         _balances[account] = _balances[account].add(amount);
287         emit Transfer(address(0), account, amount);
288     }
289 
290     /**
291      * @dev Destroys `amount` tokens from `account`, reducing the
292      * total supply.
293      *
294      * Emits a {Transfer} event with `to` set to the zero address.
295      *
296      * Requirements
297      *
298      * - `account` cannot be the zero address.
299      * - `account` must have at least `amount` tokens.
300      */
301     function _burn(address account, uint256 amount) internal virtual {
302         require(account != address(0), "ERC20: burn from the zero address");
303 
304         _beforeTokenTransfer(account, address(0), amount);
305 
306         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
307         _totalSupply = _totalSupply.sub(amount);
308         emit Transfer(account, address(0), amount);
309     }
310 
311     /**
312      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
313      *
314      * This is internal function is equivalent to `approve`, and can be used to
315      * e.g. set automatic allowances for certain subsystems, etc.
316      *
317      * Emits an {Approval} event.
318      *
319      * Requirements:
320      *
321      * - `owner` cannot be the zero address.
322      * - `spender` cannot be the zero address.
323      */
324     function _approve(address owner, address spender, uint256 amount) internal virtual {
325         require(owner != address(0), "ERC20: approve from the zero address");
326         require(spender != address(0), "ERC20: approve to the zero address");
327 
328         _allowances[owner][spender] = amount;
329         emit Approval(owner, spender, amount);
330     }
331 
332     /**
333      * @dev Sets {decimals} to a value other than the default one of 18.
334      *
335      * WARNING: This function should only be called from the constructor. Most
336      * applications that interact with token contracts will not expect
337      * {decimals} to ever change, and may work incorrectly if it does.
338      */
339     function _setupDecimals(uint8 decimals_) internal {
340         _decimals = decimals_;
341     }
342 
343     /**
344      * @dev Hook that is called before any transfer of tokens. This includes
345      * minting and burning.
346      *
347      * Calling conditions:
348      *
349      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
350      * will be to transferred to `to`.
351      * - when `from` is zero, `amount` tokens will be minted for `to`.
352      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
353      * - `from` and `to` are never both zero.
354      *
355      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
356      */
357     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
358 }
359 
360 contract owned {
361     constructor() public { owner = msg.sender; }
362     address payable owner;
363 
364     // This contract only defines a modifier but does not use
365     // it: it will be used in derived contracts.
366     // The function body is inserted where the special symbol
367     // `_;` in the definition of a modifier appears.
368     // This means that if the owner calls this function, the
369     // function is executed and otherwise, an exception is
370     // thrown.
371     modifier onlyOwner {
372         require(
373             msg.sender == owner,
374             "Only owner can call this function."
375         );
376         _;
377     }
378 }
379 
380 contract JPYC is ERC20, owned {
381 
382   string private _name = "JPY Coin";
383   string private _symbol = "JPYC";
384   address private _supplyer;
385 
386   uint value = 100000000e18;
387 
388   constructor() ERC20(_name, _symbol) public {
389     _mint(msg.sender, value);
390     _supplyer = msg.sender;
391 
392     _transfer(msg.sender, 0xe3F345ef7695535387e792e3057492F2635316A0, 10000000e18);
393     _transfer(msg.sender, 0x3e4b1BBb86399bB0716C287BBaC8CaB19440E101, 10000000e18);
394     _transfer(msg.sender, 0x67eF210F4232c7c133fc955707036bdDA236B388, 10000000e18);
395     _transfer(msg.sender, 0x9dA232019d5FfB079bb2de216b7fe5F093B90Ea8, 10000000e18);
396     _transfer(msg.sender, 0xC841077406fF128B03c50f2625b38c08C05B959B, 10000000e18);
397     _transfer(msg.sender, 0x1184CFde16593dB91938cc6F73240a53B20D6EA4, 10000000e18);
398     _transfer(msg.sender, 0x9700D276fe9Bd24327C7a2b6E54e0BF320efff2f, 10000000e18);
399     _transfer(msg.sender, 0xED64754fDa773980f583690a4ED3BA88822696E1, 10000000e18);
400     _transfer(msg.sender, 0xFeDd04ee9e6625184d33E50650dC061c31f7CF35, 10000000e18);
401     _transfer(msg.sender, 0xBC7824469E942B145B64deBaF50A51D00829471f, 10000000e18);
402   }
403   
404   
405   function mint(address to, uint256 amount) public virtual onlyOwner  {
406         _mint(to, amount);
407     }
408 }
409 
410 library Address {
411     /**
412      * @dev Returns true if `account` is a contract.
413      *
414      * [IMPORTANT]
415      * ====
416      * It is unsafe to assume that an address for which this function returns
417      * false is an externally-owned account (EOA) and not a contract.
418      *
419      * Among others, `isContract` will return false for the following
420      * types of addresses:
421      *
422      *  - an externally-owned account
423      *  - a contract in construction
424      *  - an address where a contract will be created
425      *  - an address where a contract lived, but was destroyed
426      * ====
427      */
428     function isContract(address account) internal view returns (bool) {
429         // This method relies in extcodesize, which returns 0 for contracts in
430         // construction, since the code is only stored at the end of the
431         // constructor execution.
432 
433         uint256 size;
434         // solhint-disable-next-line no-inline-assembly
435         assembly { size := extcodesize(account) }
436         return size > 0;
437     }
438 
439     /**
440      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
441      * `recipient`, forwarding all available gas and reverting on errors.
442      *
443      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
444      * of certain opcodes, possibly making contracts go over the 2300 gas limit
445      * imposed by `transfer`, making them unable to receive funds via
446      * `transfer`. {sendValue} removes this limitation.
447      *
448      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
449      *
450      * IMPORTANT: because control is transferred to `recipient`, care must be
451      * taken to not create reentrancy vulnerabilities. Consider using
452      * {ReentrancyGuard} or the
453      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
454      */
455     function sendValue(address payable recipient, uint256 amount) internal {
456         require(address(this).balance >= amount, "Address: insufficient balance");
457 
458         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
459         (bool success, ) = recipient.call{ value: amount }("");
460         require(success, "Address: unable to send value, recipient may have reverted");
461     }
462 
463     /**
464      * @dev Performs a Solidity function call using a low level `call`. A
465      * plain`call` is an unsafe replacement for a function call: use this
466      * function instead.
467      *
468      * If `target` reverts with a revert reason, it is bubbled up by this
469      * function (like regular Solidity function calls).
470      *
471      * Returns the raw returned data. To convert to the expected return value,
472      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
473      *
474      * Requirements:
475      *
476      * - `target` must be a contract.
477      * - calling `target` with `data` must not revert.
478      *
479      * _Available since v3.1._
480      */
481     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
482       return functionCall(target, data, "Address: low-level call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
487      * `errorMessage` as a fallback revert reason when `target` reverts.
488      *
489      * _Available since v3.1._
490      */
491     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
492         return _functionCallWithValue(target, data, 0, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but also transferring `value` wei to `target`.
498      *
499      * Requirements:
500      *
501      * - the calling contract must have an ETH balance of at least `value`.
502      * - the called Solidity function must be `payable`.
503      *
504      * _Available since v3.1._
505      */
506     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
507         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
512      * with `errorMessage` as a fallback revert reason when `target` reverts.
513      *
514      * _Available since v3.1._
515      */
516     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
517         require(address(this).balance >= value, "Address: insufficient balance for call");
518         return _functionCallWithValue(target, data, value, errorMessage);
519     }
520 
521     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
522         require(isContract(target), "Address: call to non-contract");
523 
524         // solhint-disable-next-line avoid-low-level-calls
525         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
526         if (success) {
527             return returndata;
528         } else {
529             // Look for revert reason and bubble it up if present
530             if (returndata.length > 0) {
531                 // The easiest way to bubble the revert reason is using memory via assembly
532 
533                 // solhint-disable-next-line no-inline-assembly
534                 assembly {
535                     let returndata_size := mload(returndata)
536                     revert(add(32, returndata), returndata_size)
537                 }
538             } else {
539                 revert(errorMessage);
540             }
541         }
542     }
543 }
544 
545 library SafeMath {
546     /**
547      * @dev Returns the addition of two unsigned integers, reverting on
548      * overflow.
549      *
550      * Counterpart to Solidity's `+` operator.
551      *
552      * Requirements:
553      *
554      * - Addition cannot overflow.
555      */
556     function add(uint256 a, uint256 b) internal pure returns (uint256) {
557         uint256 c = a + b;
558         require(c >= a, "SafeMath: addition overflow");
559 
560         return c;
561     }
562 
563     /**
564      * @dev Returns the subtraction of two unsigned integers, reverting on
565      * overflow (when the result is negative).
566      *
567      * Counterpart to Solidity's `-` operator.
568      *
569      * Requirements:
570      *
571      * - Subtraction cannot overflow.
572      */
573     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
574         return sub(a, b, "SafeMath: subtraction overflow");
575     }
576 
577     /**
578      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
579      * overflow (when the result is negative).
580      *
581      * Counterpart to Solidity's `-` operator.
582      *
583      * Requirements:
584      *
585      * - Subtraction cannot overflow.
586      */
587     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
588         require(b <= a, errorMessage);
589         uint256 c = a - b;
590 
591         return c;
592     }
593 
594     /**
595      * @dev Returns the multiplication of two unsigned integers, reverting on
596      * overflow.
597      *
598      * Counterpart to Solidity's `*` operator.
599      *
600      * Requirements:
601      *
602      * - Multiplication cannot overflow.
603      */
604     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
605         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
606         // benefit is lost if 'b' is also tested.
607         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
608         if (a == 0) {
609             return 0;
610         }
611 
612         uint256 c = a * b;
613         require(c / a == b, "SafeMath: multiplication overflow");
614 
615         return c;
616     }
617 
618     /**
619      * @dev Returns the integer division of two unsigned integers. Reverts on
620      * division by zero. The result is rounded towards zero.
621      *
622      * Counterpart to Solidity's `/` operator. Note: this function uses a
623      * `revert` opcode (which leaves remaining gas untouched) while Solidity
624      * uses an invalid opcode to revert (consuming all remaining gas).
625      *
626      * Requirements:
627      *
628      * - The divisor cannot be zero.
629      */
630     function div(uint256 a, uint256 b) internal pure returns (uint256) {
631         return div(a, b, "SafeMath: division by zero");
632     }
633 
634     /**
635      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
636      * division by zero. The result is rounded towards zero.
637      *
638      * Counterpart to Solidity's `/` operator. Note: this function uses a
639      * `revert` opcode (which leaves remaining gas untouched) while Solidity
640      * uses an invalid opcode to revert (consuming all remaining gas).
641      *
642      * Requirements:
643      *
644      * - The divisor cannot be zero.
645      */
646     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
647         require(b > 0, errorMessage);
648         uint256 c = a / b;
649         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
650 
651         return c;
652     }
653 
654     /**
655      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
656      * Reverts when dividing by zero.
657      *
658      * Counterpart to Solidity's `%` operator. This function uses a `revert`
659      * opcode (which leaves remaining gas untouched) while Solidity uses an
660      * invalid opcode to revert (consuming all remaining gas).
661      *
662      * Requirements:
663      *
664      * - The divisor cannot be zero.
665      */
666     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
667         return mod(a, b, "SafeMath: modulo by zero");
668     }
669 
670     /**
671      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
672      * Reverts with custom message when dividing by zero.
673      *
674      * Counterpart to Solidity's `%` operator. This function uses a `revert`
675      * opcode (which leaves remaining gas untouched) while Solidity uses an
676      * invalid opcode to revert (consuming all remaining gas).
677      *
678      * Requirements:
679      *
680      * - The divisor cannot be zero.
681      */
682     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
683         require(b != 0, errorMessage);
684         return a % b;
685     }
686 }