1 /*
2 
3 
4                              https://MagicLiquidity.com
5     
6                                     ▒▒▒▒▒▒▒▒▒▒▒▒▒▒                                
7                               ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                        
8                         ▒▒▒▒▒▒▒▒▒▒▒▒              ▒▒▒▒▒▒▒▒▒▒▒▒                    
9                       ▒▒▒▒▒▒▒▒      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒      ▒▒▒▒▒▒▒▒▒▒                
10                   ▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒              
11                 ▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒▒▒██████████████▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒            
12               ▒▒▒▒▒▒    ▒▒▒▒▒▒██████████████████████████▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒          
13             ▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒████████              ██████████▒▒▒▒▒▒  ▒▒▒▒▒▒        
14           ▒▒▒▒▒▒  ▒▒▒▒▒▒████████                        ██████▒▒▒▒▒▒  ▒▒▒▒▒▒      
15           ▒▒▒▒  ▒▒▒▒▒▒██████                              ██████▒▒▒▒▒▒  ▒▒▒▒      
16         ▒▒▒▒    ▒▒▒▒██████                                  ██████▒▒▒▒    ▒▒▒▒    
17         ▒▒▒▒  ▒▒▒▒██████                                      ██████▒▒▒▒  ▒▒▒▒    
18       ▒▒▒▒    ▒▒▒▒████                                          ████▒▒▒▒    ▒▒▒▒  
19       ▒▒▒▒  ▒▒▒▒██████                                            ████▒▒▒▒  ▒▒▒▒  
20       ▒▒▒▒  ▒▒▒▒████                                              ████▒▒▒▒  ▒▒▒▒  
21     ▒▒▒▒  ▒▒▒▒██████                                              ██████▒▒▒▒  ▒▒▒▒
22     ▒▒▒▒  ▒▒▒▒████                                                  ████▒▒▒▒  ▒▒▒▒
23     ▒▒▒▒  ▒▒▒▒████                                                  ████▒▒▒▒  ▒▒▒▒
24     ▒▒▒▒  ▒▒▒▒████                                                  ████▒▒▒▒  ▒▒▒▒
25 
26                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
27                            THE MAGIC LIQUIDITY $RAINBOW
28 
29 
30  */
31 
32 
33 // File: @openzeppelin/contracts/GSN/Context.sol
34 pragma solidity ^0.6.0;
35 
36 /*
37  * @dev Provides information about the current execution context, including the
38  * sender of the transaction and its data. While these are generally available
39  * via msg.sender and msg.data, they should not be accessed in such a direct
40  * manner, since when dealing with GSN meta-transactions the account sending and
41  * paying for execution may not be the actual sender (as far as an application
42  * is concerned).
43  *
44  * This contract is only required for intermediate, library-like contracts.
45  */
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address payable) {
48         return msg.sender;
49     }
50 
51     function _msgData() internal view virtual returns (bytes memory) {
52         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
53         return msg.data;
54     }
55 }
56 
57 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
58 
59 /**
60  * @dev Interface of the ERC20 standard as defined in the EIP.
61  */
62 interface IERC20 {
63     /**
64      * @dev Returns the amount of tokens in existence.
65      */
66     function totalSupply() external view returns (uint256);
67 
68     /**
69      * @dev Returns the amount of tokens owned by `account`.
70      */
71     function balanceOf(address account) external view returns (uint256);
72 
73     /**
74      * @dev Moves `amount` tokens from the caller's account to `recipient`.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transfer(address recipient, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Returns the remaining number of tokens that `spender` will be
84      * allowed to spend on behalf of `owner` through {transferFrom}. This is
85      * zero by default.
86      *
87      * This value changes when {approve} or {transferFrom} are called.
88      */
89     function allowance(address owner, address spender) external view returns (uint256);
90 
91     /**
92      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * IMPORTANT: Beware that changing an allowance with this method brings the risk
97      * that someone may use both the old and the new allowance by unfortunate
98      * transaction ordering. One possible solution to mitigate this race
99      * condition is to first reduce the spender's allowance to 0 and set the
100      * desired value afterwards:
101      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
102      *
103      * Emits an {Approval} event.
104      */
105     function approve(address spender, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Moves `amount` tokens from `sender` to `recipient` using the
109      * allowance mechanism. `amount` is then deducted from the caller's
110      * allowance.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Emitted when `value` tokens are moved from one account (`from`) to
120      * another (`to`).
121      *
122      * Note that `value` may be zero.
123      */
124     event Transfer(address indexed from, address indexed to, uint256 value);
125 
126     /**
127      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
128      * a call to {approve}. `value` is the new allowance.
129      */
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 // File: @openzeppelin/contracts/math/SafeMath.sol
134 
135 
136 /**
137  * @dev Wrappers over Solidity's arithmetic operations with added overflow
138  * checks.
139  *
140  * Arithmetic operations in Solidity wrap on overflow. This can easily result
141  * in bugs, because programmers usually assume that an overflow raises an
142  * error, which is the standard behavior in high level programming languages.
143  * `SafeMath` restores this intuition by reverting the transaction when an
144  * operation overflows.
145  *
146  * Using this library instead of the unchecked operations eliminates an entire
147  * class of bugs, so it's recommended to use it always.
148  */
149 library SafeMath {
150     /**
151      * @dev Returns the addition of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `+` operator.
155      *
156      * Requirements:
157      *
158      * - Addition cannot overflow.
159      */
160     function add(uint256 a, uint256 b) internal pure returns (uint256) {
161         uint256 c = a + b;
162         require(c >= a, "SafeMath: addition overflow");
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting on
169      * overflow (when the result is negative).
170      *
171      * Counterpart to Solidity's `-` operator.
172      *
173      * Requirements:
174      *
175      * - Subtraction cannot overflow.
176      */
177     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
178         return sub(a, b, "SafeMath: subtraction overflow");
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
183      * overflow (when the result is negative).
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      *
189      * - Subtraction cannot overflow.
190      */
191     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b <= a, errorMessage);
193         uint256 c = a - b;
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the multiplication of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `*` operator.
203      *
204      * Requirements:
205      *
206      * - Multiplication cannot overflow.
207      */
208     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
210         // benefit is lost if 'b' is also tested.
211         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
212         if (a == 0) {
213             return 0;
214         }
215 
216         uint256 c = a * b;
217         require(c / a == b, "SafeMath: multiplication overflow");
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers. Reverts on
224      * division by zero. The result is rounded towards zero.
225      *
226      * Counterpart to Solidity's `/` operator. Note: this function uses a
227      * `revert` opcode (which leaves remaining gas untouched) while Solidity
228      * uses an invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function div(uint256 a, uint256 b) internal pure returns (uint256) {
235         return div(a, b, "SafeMath: division by zero");
236     }
237 
238     /**
239      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
240      * division by zero. The result is rounded towards zero.
241      *
242      * Counterpart to Solidity's `/` operator. Note: this function uses a
243      * `revert` opcode (which leaves remaining gas untouched) while Solidity
244      * uses an invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b > 0, errorMessage);
252         uint256 c = a / b;
253         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
254 
255         return c;
256     }
257 
258     /**
259      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
260      * Reverts when dividing by zero.
261      *
262      * Counterpart to Solidity's `%` operator. This function uses a `revert`
263      * opcode (which leaves remaining gas untouched) while Solidity uses an
264      * invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      *
268      * - The divisor cannot be zero.
269      */
270     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
271         return mod(a, b, "SafeMath: modulo by zero");
272     }
273 
274     /**
275      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
276      * Reverts with custom message when dividing by zero.
277      *
278      * Counterpart to Solidity's `%` operator. This function uses a `revert`
279      * opcode (which leaves remaining gas untouched) while Solidity uses an
280      * invalid opcode to revert (consuming all remaining gas).
281      *
282      * Requirements:
283      *
284      * - The divisor cannot be zero.
285      */
286     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
287         require(b != 0, errorMessage);
288         return a % b;
289     }
290 }
291 
292 // File: @openzeppelin/contracts/utils/Address.sol
293 
294 /**
295  * @dev Collection of functions related to the address type
296  */
297 library Address {
298     /**
299      * @dev Returns true if `account` is a contract.
300      *
301      * [IMPORTANT]
302      * ====
303      * It is unsafe to assume that an address for which this function returns
304      * false is an externally-owned account (EOA) and not a contract.
305      *
306      * Among others, `isContract` will return false for the following
307      * types of addresses:
308      *
309      *  - an externally-owned account
310      *  - a contract in construction
311      *  - an address where a contract will be created
312      *  - an address where a contract lived, but was destroyed
313      * ====
314      */
315     function isContract(address account) internal view returns (bool) {
316         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
317         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
318         // for accounts without code, i.e. `keccak256('')`
319         bytes32 codehash;
320         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
321         // solhint-disable-next-line no-inline-assembly
322         assembly { codehash := extcodehash(account) }
323         return (codehash != accountHash && codehash != 0x0);
324     }
325 
326     /**
327      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
328      * `recipient`, forwarding all available gas and reverting on errors.
329      *
330      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
331      * of certain opcodes, possibly making contracts go over the 2300 gas limit
332      * imposed by `transfer`, making them unable to receive funds via
333      * `transfer`. {sendValue} removes this limitation.
334      *
335      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
336      *
337      * IMPORTANT: because control is transferred to `recipient`, care must be
338      * taken to not create reentrancy vulnerabilities. Consider using
339      * {ReentrancyGuard} or the
340      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
341      */
342     function sendValue(address payable recipient, uint256 amount) internal {
343         require(address(this).balance >= amount, "Address: insufficient balance");
344 
345         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
346         (bool success, ) = recipient.call{ value: amount }("");
347         require(success, "Address: unable to send value, recipient may have reverted");
348     }
349 
350     /**
351      * @dev Performs a Solidity function call using a low level `call`. A
352      * plain`call` is an unsafe replacement for a function call: use this
353      * function instead.
354      *
355      * If `target` reverts with a revert reason, it is bubbled up by this
356      * function (like regular Solidity function calls).
357      *
358      * Returns the raw returned data. To convert to the expected return value,
359      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
360      *
361      * Requirements:
362      *
363      * - `target` must be a contract.
364      * - calling `target` with `data` must not revert.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
369       return functionCall(target, data, "Address: low-level call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
374      * `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
379         return _functionCallWithValue(target, data, 0, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but also transferring `value` wei to `target`.
385      *
386      * Requirements:
387      *
388      * - the calling contract must have an ETH balance of at least `value`.
389      * - the called Solidity function must be `payable`.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
399      * with `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
404         require(address(this).balance >= value, "Address: insufficient balance for call");
405         return _functionCallWithValue(target, data, value, errorMessage);
406     }
407 
408     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
409         require(isContract(target), "Address: call to non-contract");
410 
411         // solhint-disable-next-line avoid-low-level-calls
412         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
413         if (success) {
414             return returndata;
415         } else {
416             // Look for revert reason and bubble it up if present
417             if (returndata.length > 0) {
418                 // The easiest way to bubble the revert reason is using memory via assembly
419 
420                 // solhint-disable-next-line no-inline-assembly
421                 assembly {
422                     let returndata_size := mload(returndata)
423                     revert(add(32, returndata), returndata_size)
424                 }
425             } else {
426                 revert(errorMessage);
427             }
428         }
429     }
430 }
431 
432 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
433 
434 
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
687      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
688      *
689      * This is internal function is equivalent to `approve`, and can be used to
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
735 // File: @openzeppelin/contracts/access/Ownable.sol
736 
737 /**
738  * @dev Contract module which provides a basic access control mechanism, where
739  * there is an account (an owner) that can be granted exclusive access to
740  * specific functions.
741  *
742  * By default, the owner account will be the one that deploys the contract. This
743  * can later be changed with {transferOwnership}.
744  *
745  * This module is used through inheritance. It will make available the modifier
746  * `onlyOwner`, which can be applied to your functions to restrict their use to
747  * the owner.
748  */
749 contract Ownable is Context {
750     address private _owner;
751 
752     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
753 
754     /**
755      * @dev Initializes the contract setting the deployer as the initial owner.
756      */
757     constructor () internal {
758         address msgSender = _msgSender();
759         _owner = msgSender;
760         emit OwnershipTransferred(address(0), msgSender);
761     }
762 
763     /**
764      * @dev Returns the address of the current owner.
765      */
766     function owner() public view returns (address) {
767         return _owner;
768     }
769 
770     /**
771      * @dev Throws if called by any account other than the owner.
772      */
773     modifier onlyOwner() {
774         require(_owner == _msgSender(), "Ownable: caller is not the owner");
775         _;
776     }
777 
778     /**
779      * @dev Leaves the contract without owner. It will not be possible to call
780      * `onlyOwner` functions anymore. Can only be called by the current owner.
781      *
782      * NOTE: Renouncing ownership will leave the contract without an owner,
783      * thereby removing any functionality that is only available to the owner.
784      */
785     function renounceOwnership() public virtual onlyOwner {
786         emit OwnershipTransferred(_owner, address(0));
787         _owner = address(0);
788     }
789 
790     /**
791      * @dev Transfers ownership of the contract to a new account (`newOwner`).
792      * Can only be called by the current owner.
793      */
794     function transferOwnership(address newOwner) public virtual onlyOwner {
795         require(newOwner != address(0), "Ownable: new owner is the zero address");
796         emit OwnershipTransferred(_owner, newOwner);
797         _owner = newOwner;
798     }
799 }
800 
801 // File: contracts/RainbowToken.sol
802 
803 
804 
805 
806 // RainbowToken with Governance.
807 contract RainbowToken is ERC20("RainbowToken", "RAINBOW"), Ownable {
808     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner.
809     function mint(address _to, uint256 _amount) public onlyOwner {
810         _mint(_to, _amount);
811         _moveDelegates(address(0), _delegates[_to], _amount);
812     }
813 
814     // Copied and modified from YAM code:
815     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
816     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
817     // Which is copied and modified from COMPOUND:
818     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
819 
820     /// @notice A record of each accounts delegate
821     mapping (address => address) internal _delegates;
822 
823     /// @notice A checkpoint for marking number of votes from a given block
824     struct Checkpoint {
825         uint32 fromBlock;
826         uint256 votes;
827     }
828 
829     /// @notice A record of votes checkpoints for each account, by index
830     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
831 
832     /// @notice The number of checkpoints for each account
833     mapping (address => uint32) public numCheckpoints;
834 
835     /// @notice The EIP-712 typehash for the contract's domain
836     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
837 
838     /// @notice The EIP-712 typehash for the delegation struct used by the contract
839     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
840 
841     /// @notice A record of states for signing / validating signatures
842     mapping (address => uint) public nonces;
843 
844       /// @notice An event thats emitted when an account changes its delegate
845     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
846 
847     /// @notice An event thats emitted when a delegate account's vote balance changes
848     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
849 
850     /**
851      * @notice Delegate votes from `msg.sender` to `delegatee`
852      * @param delegator The address to get delegatee for
853      */
854     function delegates(address delegator)
855         external
856         view
857         returns (address)
858     {
859         return _delegates[delegator];
860     }
861 
862    /**
863     * @notice Delegate votes from `msg.sender` to `delegatee`
864     * @param delegatee The address to delegate votes to
865     */
866     function delegate(address delegatee) external {
867         return _delegate(msg.sender, delegatee);
868     }
869 
870     /**
871      * @notice Delegates votes from signatory to `delegatee`
872      * @param delegatee The address to delegate votes to
873      * @param nonce The contract state required to match the signature
874      * @param expiry The time at which to expire the signature
875      * @param v The recovery byte of the signature
876      * @param r Half of the ECDSA signature pair
877      * @param s Half of the ECDSA signature pair
878      */
879     function delegateBySig(
880         address delegatee,
881         uint nonce,
882         uint expiry,
883         uint8 v,
884         bytes32 r,
885         bytes32 s
886     )
887         external
888     {
889         bytes32 domainSeparator = keccak256(
890             abi.encode(
891                 DOMAIN_TYPEHASH,
892                 keccak256(bytes(name())),
893                 getChainId(),
894                 address(this)
895             )
896         );
897 
898         bytes32 structHash = keccak256(
899             abi.encode(
900                 DELEGATION_TYPEHASH,
901                 delegatee,
902                 nonce,
903                 expiry
904             )
905         );
906 
907         bytes32 digest = keccak256(
908             abi.encodePacked(
909                 "\x19\x01",
910                 domainSeparator,
911                 structHash
912             )
913         );
914 
915         address signatory = ecrecover(digest, v, r, s);
916         require(signatory != address(0), "RAINBOW::delegateBySig: invalid signature");
917         require(nonce == nonces[signatory]++, "RAINBOW::delegateBySig: invalid nonce");
918         require(now <= expiry, "RAINBOW::delegateBySig: signature expired");
919         return _delegate(signatory, delegatee);
920     }
921 
922     /**
923      * @notice Gets the current votes balance for `account`
924      * @param account The address to get votes balance
925      * @return The number of current votes for `account`
926      */
927     function getCurrentVotes(address account)
928         external
929         view
930         returns (uint256)
931     {
932         uint32 nCheckpoints = numCheckpoints[account];
933         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
934     }
935 
936     /**
937      * @notice Determine the prior number of votes for an account as of a block number
938      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
939      * @param account The address of the account to check
940      * @param blockNumber The block number to get the vote balance at
941      * @return The number of votes the account had as of the given block
942      */
943     function getPriorVotes(address account, uint blockNumber)
944         external
945         view
946         returns (uint256)
947     {
948         require(blockNumber < block.number, "RAINBOW::getPriorVotes: not yet determined");
949 
950         uint32 nCheckpoints = numCheckpoints[account];
951         if (nCheckpoints == 0) {
952             return 0;
953         }
954 
955         // First check most recent balance
956         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
957             return checkpoints[account][nCheckpoints - 1].votes;
958         }
959 
960         // Next check implicit zero balance
961         if (checkpoints[account][0].fromBlock > blockNumber) {
962             return 0;
963         }
964 
965         uint32 lower = 0;
966         uint32 upper = nCheckpoints - 1;
967         while (upper > lower) {
968             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
969             Checkpoint memory cp = checkpoints[account][center];
970             if (cp.fromBlock == blockNumber) {
971                 return cp.votes;
972             } else if (cp.fromBlock < blockNumber) {
973                 lower = center;
974             } else {
975                 upper = center - 1;
976             }
977         }
978         return checkpoints[account][lower].votes;
979     }
980 
981     function _delegate(address delegator, address delegatee)
982         internal
983     {
984         address currentDelegate = _delegates[delegator];
985         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying RAINBOWs (not scaled);
986         _delegates[delegator] = delegatee;
987 
988         emit DelegateChanged(delegator, currentDelegate, delegatee);
989 
990         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
991     }
992 
993     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
994         if (srcRep != dstRep && amount > 0) {
995             if (srcRep != address(0)) {
996                 // decrease old representative
997                 uint32 srcRepNum = numCheckpoints[srcRep];
998                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
999                 uint256 srcRepNew = srcRepOld.sub(amount);
1000                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1001             }
1002 
1003             if (dstRep != address(0)) {
1004                 // increase new representative
1005                 uint32 dstRepNum = numCheckpoints[dstRep];
1006                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1007                 uint256 dstRepNew = dstRepOld.add(amount);
1008                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1009             }
1010         }
1011     }
1012 
1013     function _writeCheckpoint(
1014         address delegatee,
1015         uint32 nCheckpoints,
1016         uint256 oldVotes,
1017         uint256 newVotes
1018     )
1019         internal
1020     {
1021         uint32 blockNumber = safe32(block.number, "RAINBOW::_writeCheckpoint: block number exceeds 32 bits");
1022 
1023         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1024             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1025         } else {
1026             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1027             numCheckpoints[delegatee] = nCheckpoints + 1;
1028         }
1029 
1030         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1031     }
1032 
1033     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1034         require(n < 2**32, errorMessage);
1035         return uint32(n);
1036     }
1037 
1038     function getChainId() internal pure returns (uint) {
1039         uint256 chainId;
1040         assembly { chainId := chainid() }
1041         return chainId;
1042     }
1043 }