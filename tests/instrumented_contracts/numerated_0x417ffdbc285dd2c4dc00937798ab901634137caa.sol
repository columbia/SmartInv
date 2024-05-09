1 /**
2  * 
3  * Market has owned you?
4  * Now you will own the market
5  * 
6  * Loading blackfisk.ai
7  * 
8  *           .ooooooooooooooooooooooooooo+                                                       
9                 .ooooooooooooooooooooooooooo+                                                       
10                 .ooooooooooooooooooooooooooo+                                                       
11                 .ooooooooooooooooooooooooooo+                                                       
12        :+++++++++oooooooooooooooooooooooooooo+++++++++`                                             
13        /oooooooooooooooooooooooooooooooooooooooooooooo`                                             
14        /oooooooooooooooooooooooooooooooooooooooooooooo`                                             
15        /oooooooooooooooooooooooooooooooooooooooooooooo`                                             
16        /oooooooooooooooooooooooooooooooooooooooooooooo.````````                                     
17        /oooooooooooooooooooooooooooooooooooooooooooooooooooooo-                                     
18        /oooooooooooooooooooooooooooooooooooooooooooooooooooooo-                                     
19        /oooooooooooooooooooooooooooooooooooooooooooooooooooooo-                                     
20        /oooooooooooooooooooooooooooooooooooooooooooooooooooooo-                                     
21        .--------/ooooooooooooooooooooooooooooooooooooooooooooo-                                     
22                 .ooooooooooooooooooooooooo++++ooooooooo++++ooo-                                     
23                 .oooooooooooooooooooooooo+---:oooooooo+:--:+oo-                                     
24                 .oooooooooooooooooooooooo+----oooooooo+---:+oo-                                     
25                 .oooooooooooooooooooooooo+----oooooooo+---:+oo-                                     
26                  `````````````````/oooooo+::::oooooooo+:::/+oo-                                     
27                                   :ooooooooooooooooooooooooooo-                                     
28                                   :ooooooooooooooooooooooooooo-                                     
29                                   :ooooooooooooooooooooooooooo-                                     
30         ``````````````````````````/ooooooooooooooooooooooooooo:`````````````````````````````        
31         /oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo/        
32         /oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo/        
33         /oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo/        
34         /oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo/        
35         /ooooooooo+::::::::ooooooooooooooooooooooooooo:::::::::/ooooooooo::::::::+ooooooooo/        
36         /ooooooooo/        +oooooooooooooooooooooooooo`        -oooooooo+        /ooooooooo/        
37         /ooooooooo/        +oooooooooooooooooooooooooo`        -oooooooo+        /ooooooooo/        
38         /ooooooooo/        +oooooooooooooooooooooooooo`        -oooooooo+        /ooooooooo/        
39 ......../ooooooooo+........ooooooooooooooooooooooooooo`        -ooooooooo........+ooooooooo/........
40 ooooooooo-```````-ooooooooo.```````/oooooooooooooooooo`        `````````.ooooooooo-```````-ooooooooo
41 ooooooooo-       .ooooooooo`       :oooooooooooooooooo`                 `ooooooooo.       -ooooooooo
42 ooooooooo-       .ooooooooo`       :oooooooooooooooooo`                 `ooooooooo.       -ooooooooo
43 ooooooooo-       .ooooooooo`       :oooooooooooooooooo`                 `ooooooooo.       -ooooooooo
44 ooooooooo-       .ooooooooo`       :ooooooooo+.......+/////////-        `ooooooooo.       -ooooooooo
45 ooooooooo-       .ooooooooo`       :ooooooooo+       +ooooooooo:        `ooooooooo.       -ooooooooo
46 ooooooooo-       .ooooooooo`       :ooooooooo+       +ooooooooo:        `ooooooooo.       -ooooooooo
47 ooooooooo-       .ooooooooo`       :ooooooooo+       +ooooooooo:        `ooooooooo.       -ooooooooo
48 ooooooooo-       .ooooooooo`       :ooooooooo+       +ooooooooo:        `ooooooooo.       -ooooooooo
49 
50  */ 
51 pragma solidity ^0.6.0;
52 
53 
54 abstract contract Context {
55     function _msgSender() internal view virtual returns (address payable) {
56         return msg.sender;
57     }
58 
59     function _msgData() internal view virtual returns (bytes memory) {
60         this;
61         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
62         return msg.data;
63     }
64 }
65 
66 interface IERC20 {
67     /**
68      * @dev Returns the amount of tokens in existence.
69      */
70     function totalSupply() external view returns (uint256);
71 
72     /**
73      * @dev Returns the amount of tokens owned by `account`.
74      */
75     function balanceOf(address account) external view returns (uint256);
76 
77     /**
78      * @dev Moves `amount` tokens from the caller's account to `recipient`.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transfer(address recipient, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Returns the remaining number of tokens that `spender` will be
88      * allowed to spend on behalf of `owner` through {transferFrom}. This is
89      * zero by default.
90      *
91      * This value changes when {approve} or {transferFrom} are called.
92      */
93     function allowance(address owner, address spender) external view returns (uint256);
94 
95     /**
96      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * IMPORTANT: Beware that changing an allowance with this method brings the risk
101      * that someone may use both the old and the new allowance by unfortunate
102      * transaction ordering. One possible solution to mitigate this race
103      * condition is to first reduce the spender's allowance to 0 and set the
104      * desired value afterwards:
105      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106      *
107      * Emits an {Approval} event.
108      */
109     function approve(address spender, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Moves `amount` tokens from `sender` to `recipient` using the
113      * allowance mechanism. `amount` is then deducted from the caller's
114      * allowance.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Emitted when `value` tokens are moved from one account (`from`) to
124      * another (`to`).
125      *
126      * Note that `value` may be zero.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 
130     /**
131      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
132      * a call to {approve}. `value` is the new allowance.
133      */
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `+` operator.
144      *
145      * Requirements:
146      *
147      * - Addition cannot overflow.
148      */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a, "SafeMath: addition overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         return sub(a, b, "SafeMath: subtraction overflow");
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181         require(b <= a, errorMessage);
182         uint256 c = a - b;
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `*` operator.
192      *
193      * Requirements:
194      *
195      * - Multiplication cannot overflow.
196      */
197     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
199         // benefit is lost if 'b' is also tested.
200         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
201         if (a == 0) {
202             return 0;
203         }
204 
205         uint256 c = a * b;
206         require(c / a == b, "SafeMath: multiplication overflow");
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b) internal pure returns (uint256) {
224         return div(a, b, "SafeMath: division by zero");
225     }
226 
227     /**
228      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
229      * division by zero. The result is rounded towards zero.
230      *
231      * Counterpart to Solidity's `/` operator. Note: this function uses a
232      * `revert` opcode (which leaves remaining gas untouched) while Solidity
233      * uses an invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b > 0, errorMessage);
241         uint256 c = a / b;
242         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         return mod(a, b, "SafeMath: modulo by zero");
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265      * Reverts with custom message when dividing by zero.
266      *
267      * Counterpart to Solidity's `%` operator. This function uses a `revert`
268      * opcode (which leaves remaining gas untouched) while Solidity uses an
269      * invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b != 0, errorMessage);
277         return a % b;
278     }
279 }
280 
281 
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [IMPORTANT]
287      * ====
288      * It is unsafe to assume that an address for which this function returns
289      * false is an externally-owned account (EOA) and not a contract.
290      *
291      * Among others, `isContract` will return false for the following
292      * types of addresses:
293      *
294      *  - an externally-owned account
295      *  - a contract in construction
296      *  - an address where a contract will be created
297      *  - an address where a contract lived, but was destroyed
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
302         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
303         // for accounts without code, i.e. `keccak256('')`
304         bytes32 codehash;
305         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
306         // solhint-disable-next-line no-inline-assembly
307         assembly {codehash := extcodehash(account)}
308         return (codehash != accountHash && codehash != 0x0);
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(address(this).balance >= amount, "Address: insufficient balance");
329 
330         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
331         (bool success,) = recipient.call{value : amount}("");
332         require(success, "Address: unable to send value, recipient may have reverted");
333     }
334 
335     /**
336      * @dev Performs a Solidity function call using a low level `call`. A
337      * plain`call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
364         return _functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
384      * with `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         return _functionCallWithValue(target, data, value, errorMessage);
391     }
392 
393     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
394         require(isContract(target), "Address: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 // solhint-disable-next-line no-inline-assembly
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 contract Ownable is Context {
418     address private _owner;
419 
420     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
421 
422     /**
423      * @dev Initializes the contract setting the deployer as the initial owner.
424      */
425     constructor () internal {
426         address msgSender = _msgSender();
427         _owner = msgSender;
428         emit OwnershipTransferred(address(0), msgSender);
429     }
430 
431     /**
432      * @dev Returns the address of the current owner.
433      */
434     function owner() public view returns (address) {
435         return _owner;
436     }
437 
438     /**
439      * @dev Throws if called by any account other than the owner.
440      */
441     modifier onlyOwner() {
442         require(_owner == _msgSender(), "Ownable: caller is not the owner");
443         _;
444     }
445 
446     /**
447      * @dev Leaves the contract without owner. It will not be possible to call
448      * `onlyOwner` functions anymore. Can only be called by the current owner.
449      *
450      * NOTE: Renouncing ownership will leave the contract without an owner,
451      * thereby removing any functionality that is only available to the owner.
452      */
453     function renounceOwnership() public virtual onlyOwner {
454         emit OwnershipTransferred(_owner, address(0));
455         _owner = address(0);
456     }
457 
458     /**
459      * @dev Transfers ownership of the contract to a new account (`newOwner`).
460      * Can only be called by the current owner.
461      */
462     function transferOwnership(address newOwner) public virtual onlyOwner {
463         require(newOwner != address(0), "Ownable: new owner is the zero address");
464         emit OwnershipTransferred(_owner, newOwner);
465         _owner = newOwner;
466     }
467 }
468 
469 contract ERC20 is Context, IERC20 {
470     using SafeMath for uint256;
471     using Address for address;
472 
473     mapping(address => uint256) private _balances;
474 
475     mapping(address => mapping(address => uint256)) private _allowances;
476 
477     uint256 private _totalSupply;
478 
479     string private _name;
480     string private _symbol;
481     uint8 private _decimals;
482 
483     /**
484      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
485      * a default value of 18.
486      *
487      * To select a different value for {decimals}, use {_setupDecimals}.
488      *
489      * All three of these values are immutable: they can only be set once during
490      * construction.
491      */
492     constructor (string memory name, string memory symbol) public {
493         _name = name;
494         _symbol = symbol;
495         _decimals = 18;
496     }
497 
498     /**
499      * @dev Returns the name of the token.
500      */
501     function name() public view returns (string memory) {
502         return _name;
503     }
504 
505     /**
506      * @dev Returns the symbol of the token, usually a shorter version of the
507      * name.
508      */
509     function symbol() public view returns (string memory) {
510         return _symbol;
511     }
512 
513     /**
514      * @dev Returns the number of decimals used to get its user representation.
515      * For example, if `decimals` equals `2`, a balance of `505` tokens should
516      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
517      *
518      * Tokens usually opt for a value of 18, imitating the relationship between
519      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
520      * called.
521      *
522      * NOTE: This information is only used for _display_ purposes: it in
523      * no way affects any of the arithmetic of the contract, including
524      * {IERC20-balanceOf} and {IERC20-transfer}.
525      */
526     function decimals() public view returns (uint8) {
527         return _decimals;
528     }
529 
530     /**
531      * @dev See {IERC20-totalSupply}.
532      */
533     function totalSupply() public view override returns (uint256) {
534         return _totalSupply;
535     }
536 
537     /**
538      * @dev See {IERC20-balanceOf}.
539      */
540     function balanceOf(address account) public view override returns (uint256) {
541         return _balances[account];
542     }
543 
544     /**
545      * @dev See {IERC20-transfer}.
546      *
547      * Requirements:
548      *
549      * - `recipient` cannot be the zero address.
550      * - the caller must have a balance of at least `amount`.
551      */
552     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
553         _transfer(_msgSender(), recipient, amount);
554         return true;
555     }
556 
557     /**
558      * @dev See {IERC20-allowance}.
559      */
560     function allowance(address owner, address spender) public view virtual override returns (uint256) {
561         return _allowances[owner][spender];
562     }
563 
564     /**
565      * @dev See {IERC20-approve}.
566      *
567      * Requirements:
568      *
569      * - `spender` cannot be the zero address.
570      */
571     function approve(address spender, uint256 amount) public virtual override returns (bool) {
572         _approve(_msgSender(), spender, amount);
573         return true;
574     }
575 
576     /**
577      * @dev See {IERC20-transferFrom}.
578      *
579      * Emits an {Approval} event indicating the updated allowance. This is not
580      * required by the EIP. See the note at the beginning of {ERC20};
581      *
582      * Requirements:
583      * - `sender` and `recipient` cannot be the zero address.
584      * - `sender` must have a balance of at least `amount`.
585      * - the caller must have allowance for ``sender``'s tokens of at least
586      * `amount`.
587      */
588     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
589         _transfer(sender, recipient, amount);
590         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
591         return true;
592     }
593 
594     /**
595      * @dev Atomically increases the allowance granted to `spender` by the caller.
596      *
597      * This is an alternative to {approve} that can be used as a mitigation for
598      * problems described in {IERC20-approve}.
599      *
600      * Emits an {Approval} event indicating the updated allowance.
601      *
602      * Requirements:
603      *
604      * - `spender` cannot be the zero address.
605      */
606     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
607         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
608         return true;
609     }
610 
611     /**
612      * @dev Atomically decreases the allowance granted to `spender` by the caller.
613      *
614      * This is an alternative to {approve} that can be used as a mitigation for
615      * problems described in {IERC20-approve}.
616      *
617      * Emits an {Approval} event indicating the updated allowance.
618      *
619      * Requirements:
620      *
621      * - `spender` cannot be the zero address.
622      * - `spender` must have allowance for the caller of at least
623      * `subtractedValue`.
624      */
625     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
626         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
627         return true;
628     }
629 
630     /**
631      * @dev Moves tokens `amount` from `sender` to `recipient`.
632      *
633      * This is internal function is equivalent to {transfer}, and can be used to
634      * e.g. implement automatic token fees, slashing mechanisms, etc.
635      *
636      * Emits a {Transfer} event.
637      *
638      * Requirements:
639      *
640      * - `sender` cannot be the zero address.
641      * - `recipient` cannot be the zero address.
642      * - `sender` must have a balance of at least `amount`.
643      */
644     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
645         require(sender != address(0), "ERC20: transfer from the zero address");
646         require(recipient != address(0), "ERC20: transfer to the zero address");
647 
648         _beforeTokenTransfer(sender, recipient, amount);
649 
650         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
651         _balances[recipient] = _balances[recipient].add(amount);
652         emit Transfer(sender, recipient, amount);
653     }
654 
655     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
656      * the total supply.
657      *
658      * Emits a {Transfer} event with `from` set to the zero address.
659      *
660      * Requirements
661      *
662      * - `to` cannot be the zero address.
663      */
664     function _mint(address account, uint256 amount) internal virtual {
665         require(account != address(0), "ERC20: mint to the zero address");
666 
667         _beforeTokenTransfer(address(0), account, amount);
668 
669         _totalSupply = _totalSupply.add(amount);
670         _balances[account] = _balances[account].add(amount);
671         emit Transfer(address(0), account, amount);
672     }
673 
674     /**
675      * @dev Destroys `amount` tokens from `account`, reducing the
676      * total supply.
677      *
678      * Emits a {Transfer} event with `to` set to the zero address.
679      *
680      * Requirements
681      *
682      * - `account` cannot be the zero address.
683      * - `account` must have at least `amount` tokens.
684      */
685     function _burn(address account, uint256 amount) internal virtual {
686         require(account != address(0), "ERC20: burn from the zero address");
687 
688         _beforeTokenTransfer(account, address(0), amount);
689 
690         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
691         _totalSupply = _totalSupply.sub(amount);
692         emit Transfer(account, address(0), amount);
693     }
694 
695     /**
696      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
697      *
698      * This is internal function is equivalent to `approve`, and can be used to
699      * e.g. set automatic allowances for certain subsystems, etc.
700      *
701      * Emits an {Approval} event.
702      *
703      * Requirements:
704      *
705      * - `owner` cannot be the zero address.
706      * - `spender` cannot be the zero address.
707      */
708     function _approve(address owner, address spender, uint256 amount) internal virtual {
709         require(owner != address(0), "ERC20: approve from the zero address");
710         require(spender != address(0), "ERC20: approve to the zero address");
711 
712         _allowances[owner][spender] = amount;
713         emit Approval(owner, spender, amount);
714     }
715 
716     /**
717      * @dev Sets {decimals} to a value other than the default one of 18.
718      *
719      * WARNING: This function should only be called from the constructor. Most
720      * applications that interact with token contracts will not expect
721      * {decimals} to ever change, and may work incorrectly if it does.
722      */
723     function _setupDecimals(uint8 decimals_) internal {
724         _decimals = decimals_;
725     }
726 
727     /**
728      * @dev Hook that is called before any transfer of tokens. This includes
729      * minting and burning.
730      *
731      * Calling conditions:
732      *
733      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
734      * will be to transferred to `to`.
735      * - when `from` is zero, `amount` tokens will be minted for `to`.
736      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
737      * - `from` and `to` are never both zero.
738      *
739      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
740      */
741     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
742 }
743 
744 
745 contract BlackFisk is ERC20("BlackFisk", "BLFI"), Ownable {
746 
747     uint256 public total = 140000;
748 
749     constructor () public {
750         // mint tokens
751         _mint(msg.sender, total.mul(10 ** 18));
752     }
753 
754     function burn(uint256 _amount) public {
755         _burn(msg.sender, _amount);
756     }
757 }