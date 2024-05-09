1 pragma solidity 0.6.12;
2 // SPDX-License-Identifier: Unlicensed
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6 
7     /**
8      * @dev Returns the amount of tokens owned by `account`.
9      */
10     function balanceOf(address account) external view returns (uint256);
11 
12     /**
13      * @dev Moves `amount` tokens from the caller's account to `recipient`.
14      *
15      * Returns a boolean value indicating whether the operation succeeded.
16      *
17      * Emits a {Transfer} event.
18      */
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     /**
22      * @dev Returns the remaining number of tokens that `spender` will be
23      * allowed to spend on behalf of `owner` through {transferFrom}. This is
24      * zero by default.
25      *
26      * This value changes when {approve} or {transferFrom} are called.
27      */
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     /**
31      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * IMPORTANT: Beware that changing an allowance with this method brings the risk
36      * that someone may use both the old and the new allowance by unfortunate
37      * transaction ordering. One possible solution to mitigate this race
38      * condition is to first reduce the spender's allowance to 0 and set the
39      * desired value afterwards:
40      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
41      *
42      * Emits an {Approval} event.
43      */
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Moves `amount` tokens from `sender` to `recipient` using the
48      * allowance mechanism. `amount` is then deducted from the caller's
49      * allowance.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Emitted when `value` tokens are moved from one account (`from`) to
59      * another (`to`).
60      *
61      * Note that `value` may be zero.
62      */
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     /**
66      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
67      * a call to {approve}. `value` is the new allowance.
68      */
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 /*
72  * @dev Provides information about the current execution context, including the
73  * sender of the transaction and its data. While these are generally available
74  * via msg.sender and msg.data, they should not be accessed in such a direct
75  * manner, since when dealing with GSN meta-transactions the account sending and
76  * paying for execution may not be the actual sender (as far as an application
77  * is concerned).
78  *
79  * This contract is only required for intermediate, library-like contracts.
80  */
81 contract Context {
82   // Empty internal constructor, to prevent people from mistakenly deploying
83   // an instance of this contract, which should be used via inheritance.
84   constructor () internal { }
85 
86   function _msgSender() internal view returns (address payable) {
87     return msg.sender;
88   }
89 
90   function _msgData() internal view returns (bytes memory) {
91     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
92     return msg.data;
93   }
94 }
95 
96 /**
97  * @dev Wrappers over Solidity's arithmetic operations with added overflow
98  * checks.
99  *
100  * Arithmetic operations in Solidity wrap on overflow. This can easily result
101  * in bugs, because programmers usually assume that an overflow raises an
102  * error, which is the standard behavior in high level programming languages.
103  * `SafeMath` restores this intuition by reverting the transaction when an
104  * operation overflows.
105  *
106  * Using this library instead of the unchecked operations eliminates an entire
107  * class of bugs, so it's recommended to use it always.
108  */
109 library SafeMath {
110   /**
111    * @dev Returns the addition of two unsigned integers, reverting on
112    * overflow.
113    *
114    * Counterpart to Solidity's `+` operator.
115    *
116    * Requirements:
117    * - Addition cannot overflow.
118    */
119   function add(uint256 a, uint256 b) internal pure returns (uint256) {
120     uint256 c = a + b;
121     require(c >= a, "SafeMath: addition overflow");
122 
123     return c;
124   }
125 
126   /**
127    * @dev Returns the subtraction of two unsigned integers, reverting on
128    * overflow (when the result is negative).
129    *
130    * Counterpart to Solidity's `-` operator.
131    *
132    * Requirements:
133    * - Subtraction cannot overflow.
134    */
135   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136     return sub(a, b, "SafeMath: subtraction overflow");
137   }
138 
139   /**
140    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
141    * overflow (when the result is negative).
142    *
143    * Counterpart to Solidity's `-` operator.
144    *
145    * Requirements:
146    * - Subtraction cannot overflow.
147    */
148   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149     require(b <= a, errorMessage);
150     uint256 c = a - b;
151 
152     return c;
153   }
154 
155   /**
156    * @dev Returns the multiplication of two unsigned integers, reverting on
157    * overflow.
158    *
159    * Counterpart to Solidity's `*` operator.
160    *
161    * Requirements:
162    * - Multiplication cannot overflow.
163    */
164   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166     // benefit is lost if 'b' is also tested.
167     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168     if (a == 0) {
169       return 0;
170     }
171 
172     uint256 c = a * b;
173     require(c / a == b, "SafeMath: multiplication overflow");
174 
175     return c;
176   }
177 
178   /**
179    * @dev Returns the integer division of two unsigned integers. Reverts on
180    * division by zero. The result is rounded towards zero.
181    *
182    * Counterpart to Solidity's `/` operator. Note: this function uses a
183    * `revert` opcode (which leaves remaining gas untouched) while Solidity
184    * uses an invalid opcode to revert (consuming all remaining gas).
185    *
186    * Requirements:
187    * - The divisor cannot be zero.
188    */
189   function div(uint256 a, uint256 b) internal pure returns (uint256) {
190     return div(a, b, "SafeMath: division by zero");
191   }
192 
193   /**
194    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
195    * division by zero. The result is rounded towards zero.
196    *
197    * Counterpart to Solidity's `/` operator. Note: this function uses a
198    * `revert` opcode (which leaves remaining gas untouched) while Solidity
199    * uses an invalid opcode to revert (consuming all remaining gas).
200    *
201    * Requirements:
202    * - The divisor cannot be zero.
203    */
204   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205     // Solidity only automatically asserts when dividing by 0
206     require(b > 0, errorMessage);
207     uint256 c = a / b;
208     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209 
210     return c;
211   }
212 
213   /**
214    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215    * Reverts when dividing by zero.
216    *
217    * Counterpart to Solidity's `%` operator. This function uses a `revert`
218    * opcode (which leaves remaining gas untouched) while Solidity uses an
219    * invalid opcode to revert (consuming all remaining gas).
220    *
221    * Requirements:
222    * - The divisor cannot be zero.
223    */
224   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
225     return mod(a, b, "SafeMath: modulo by zero");
226   }
227 
228   /**
229    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230    * Reverts with custom message when dividing by zero.
231    *
232    * Counterpart to Solidity's `%` operator. This function uses a `revert`
233    * opcode (which leaves remaining gas untouched) while Solidity uses an
234    * invalid opcode to revert (consuming all remaining gas).
235    *
236    * Requirements:
237    * - The divisor cannot be zero.
238    */
239   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240     require(b != 0, errorMessage);
241     return a % b;
242   }
243 }
244 
245 library Address {
246     /**
247      * @dev Returns true if `account` is a contract.
248      *
249      * [IMPORTANT]
250      * ====
251      * It is unsafe to assume that an address for which this function returns
252      * false is an externally-owned account (EOA) and not a contract.
253      *
254      * Among others, `isContract` will return false for the following
255      * types of addresses:
256      *
257      *  - an externally-owned account
258      *  - a contract in construction
259      *  - an address where a contract will be created
260      *  - an address where a contract lived, but was destroyed
261      * ====
262      */
263     function isContract(address account) internal view returns (bool) {
264         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
265         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
266         // for accounts without code, i.e. `keccak256('')`
267         bytes32 codehash;
268         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
269         // solhint-disable-next-line no-inline-assembly
270         assembly { codehash := extcodehash(account) }
271         return (codehash != accountHash && codehash != 0x0);
272     }
273 
274     /**
275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276      * `recipient`, forwarding all available gas and reverting on errors.
277      *
278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
280      * imposed by `transfer`, making them unable to receive funds via
281      * `transfer`. {sendValue} removes this limitation.
282      *
283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284      *
285      * IMPORTANT: because control is transferred to `recipient`, care must be
286      * taken to not create reentrancy vulnerabilities. Consider using
287      * {ReentrancyGuard} or the
288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289      */
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
294         (bool success, ) = recipient.call{ value: amount }("");
295         require(success, "Address: unable to send value, recipient may have reverted");
296     }
297 
298     /**
299      * @dev Performs a Solidity function call using a low level `call`. A
300      * plain`call` is an unsafe replacement for a function call: use this
301      * function instead.
302      *
303      * If `target` reverts with a revert reason, it is bubbled up by this
304      * function (like regular Solidity function calls).
305      *
306      * Returns the raw returned data. To convert to the expected return value,
307      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
308      *
309      * Requirements:
310      *
311      * - `target` must be a contract.
312      * - calling `target` with `data` must not revert.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
317       return functionCall(target, data, "Address: low-level call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
322      * `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
327         return _functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         return _functionCallWithValue(target, data, value, errorMessage);
354     }
355 
356     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
357         require(isContract(target), "Address: call to non-contract");
358 
359         // solhint-disable-next-line avoid-low-level-calls
360         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
361         if (success) {
362             return returndata;
363         } else {
364             // Look for revert reason and bubble it up if present
365             if (returndata.length > 0) {
366                 // The easiest way to bubble the revert reason is using memory via assembly
367 
368                 // solhint-disable-next-line no-inline-assembly
369                 assembly {
370                     let returndata_size := mload(returndata)
371                     revert(add(32, returndata), returndata_size)
372                 }
373             } else {
374                 revert(errorMessage);
375             }
376         }
377     }
378 }
379 
380 
381 contract Ownable is Context {
382   address private _owner;
383 
384   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
385 
386   /**
387    * @dev Initializes the contract setting the deployer as the initial owner.
388    */
389   constructor () internal {
390     address msgSender = _msgSender();
391     _owner = msgSender;
392     emit OwnershipTransferred(address(0), msgSender);
393   }
394 
395   /**
396    * @dev Returns the address of the current owner.
397    */
398   function owner() public view returns (address) {
399     return _owner;
400   }
401 
402   /**
403    * @dev Throws if called by any account other than the owner.
404    */
405   modifier onlyOwner() {
406     require(_owner == _msgSender(), "Ownable: caller is not the owner");
407     _;
408   }
409 
410   /**
411    * @dev Leaves the contract without owner. It will not be possible to call
412    * `onlyOwner` functions anymore. Can only be called by the current owner.
413    *
414    * NOTE: Renouncing ownership will leave the contract without an owner,
415    * thereby removing any functionality that is only available to the owner.
416    */
417   function renounceOwnership() public onlyOwner {
418     emit OwnershipTransferred(_owner, address(0));
419     _owner = address(0);
420   }
421 
422   /**
423    * @dev Transfers ownership of the contract to a new account (`newOwner`).
424    * Can only be called by the current owner.
425    */
426   function transferOwnership(address newOwner) public onlyOwner {
427     _transferOwnership(newOwner);
428   }
429 
430   /**
431    * @dev Transfers ownership of the contract to a new account (`newOwner`).
432    */
433   function _transferOwnership(address newOwner) internal {
434     require(newOwner != address(0), "Ownable: new owner is the zero address");
435     emit OwnershipTransferred(_owner, newOwner);
436     _owner = newOwner;
437   }
438 }
439 
440 contract BSHO is Context, IERC20, Ownable {
441   using SafeMath for uint256;
442   using Address for address;
443   
444 
445   mapping (address => uint256) private _balances;
446 
447   mapping (address => mapping (address => uint256)) private _allowances;
448 
449   uint256 private _totalSupply;
450   uint8 public _decimals;
451   string public _symbol;
452   string public _name;
453 
454   constructor() public {
455     _name = "BSHO";
456     _symbol = "BSHO";
457     _decimals = 18;
458     _totalSupply = 21000000 * 10 ** uint256(_decimals);
459     _balances[msg.sender] = _totalSupply;
460     emit Transfer(address(0), msg.sender, _totalSupply);
461   }
462 
463   /**
464    * @dev Returns the bep token owner.
465    */
466   function getOwner() external view returns (address) {
467     return owner();
468   }
469 
470   /**
471    * @dev Returns the token decimals.
472    */
473   function decimals() external view returns (uint8) {
474     return _decimals;
475   }
476 
477   /**
478    * @dev Returns the token symbol.
479    */
480   function symbol() external view returns (string memory) {
481     return _symbol;
482   }
483 
484   /**
485   * @dev Returns the token name.
486   */
487   function name() external view returns (string memory) {
488     return _name;
489   }
490 
491   /**
492    * @dev See {ERC20-totalSupply}.
493    */
494   function totalSupply() public view override returns (uint256) {
495     return _totalSupply;
496   }
497 
498   /**
499    * @dev See {ERC20-balanceOf}.
500    */
501   function balanceOf(address account) public view override returns (uint256) {
502     return _balances[account];
503   }
504 
505   /**
506    * @dev See {ERC20-transfer}.
507    *
508    * Requirements:
509    *
510    * - `recipient` cannot be the zero address.
511    * - the caller must have a balance of at least `amount`.
512    */
513   function transfer(address recipient, uint256 amount) public override returns (bool) {
514     _transfer(_msgSender(), recipient, amount);
515     return true;
516   }
517 
518   /**
519    * @dev See {ERC20-allowance}.
520    */
521   function allowance(address owner, address spender) public view override returns (uint256) {
522     return _allowances[owner][spender];
523   }
524 
525   /**
526    * @dev See {ERC20-approve}.
527    *
528    * Requirements:
529    *
530    * - `spender` cannot be the zero address.
531    */
532   function approve(address spender, uint256 amount) public override returns (bool) {
533     _approve(_msgSender(), spender, amount);
534     return true;
535   }
536 
537   /**
538    * @dev See {ERC20-transferFrom}.
539    *
540    * Emits an {Approval} event indicating the updated allowance. This is not
541    * required by the EIP. See the note at the beginning of {ERC20};
542    *
543    * Requirements:
544    * - `sender` and `recipient` cannot be the zero address.
545    * - `sender` must have a balance of at least `amount`.
546    * - the caller must have allowance for `sender`'s tokens of at least
547    * `amount`.
548    */
549   function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
550     _transfer(sender, recipient, amount);
551     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
552     return true;
553   }
554 
555   /**
556    * @dev Atomically increases the allowance granted to `spender` by the caller.
557    *
558    * This is an alternative to {approve} that can be used as a mitigation for
559    * problems described in {ERC20-approve}.
560    *
561    * Emits an {Approval} event indicating the updated allowance.
562    *
563    * Requirements:
564    *
565    * - `spender` cannot be the zero address.
566    */
567   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
568     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
569     return true;
570   }
571 
572   /**
573    * @dev Atomically decreases the allowance granted to `spender` by the caller.
574    *
575    * This is an alternative to {approve} that can be used as a mitigation for
576    * problems described in {ERC20-approve}.
577    *
578    * Emits an {Approval} event indicating the updated allowance.
579    *
580    * Requirements:
581    *
582    * - `spender` cannot be the zero address.
583    * - `spender` must have allowance for the caller of at least
584    * `subtractedValue`.
585    */
586   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
587     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
588     return true;
589   }
590 
591   /**
592    * @dev Burn `amount` tokens and decreasing the total supply.
593    */
594   function burn(uint256 amount) public returns (bool) {
595     _burn(_msgSender(), amount);
596     return true;
597   }
598   
599 
600   /**
601    * @dev Moves tokens `amount` from `sender` to `recipient`.
602    *
603    * This is internal function is equivalent to {transfer}, and can be used to
604    * e.g. implement automatic token fees, slashing mechanisms, etc.
605    *
606    * Emits a {Transfer} event.
607    *
608    * Requirements:
609    *
610    * - `sender` cannot be the zero address.
611    * - `recipient` cannot be the zero address.
612    * - `sender` must have a balance of at least `amount`.
613    */
614   function _transfer(address sender, address recipient, uint256 amount) internal {
615     require(sender != address(0), "ERC20: transfer from the zero address");
616     require(recipient != address(0), "ERC20: transfer to the zero address");
617 
618     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
619     _balances[recipient] = _balances[recipient].add(amount);
620     emit Transfer(sender, recipient, amount);
621   }
622 
623   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
624    * the total supply.
625    *
626    * Emits a {Transfer} event with `from` set to the zero address.
627    *
628    * Requirements
629    *
630    * - `to` cannot be the zero address.
631    */
632   function _mint(address account, uint256 amount) internal {
633     require(account != address(0), "ERC20: mint to the zero address");
634 
635     _totalSupply = _totalSupply.add(amount);
636     _balances[account] = _balances[account].add(amount);
637     emit Transfer(address(0), account, amount);
638   }
639 
640   /**
641    * @dev Destroys `amount` tokens from `account`, reducing the
642    * total supply.
643    *
644    * Emits a {Transfer} event with `to` set to the zero address.
645    *
646    * Requirements
647    *
648    * - `account` cannot be the zero address.
649    * - `account` must have at least `amount` tokens.
650    */
651   function _burn(address account, uint256 amount) internal {
652     require(account != address(0), "ERC20: burn from the zero address");
653 
654     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
655     _totalSupply = _totalSupply.sub(amount);
656     emit Transfer(account, address(0), amount);
657   }
658 
659   /**
660    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
661    *
662    * This is internal function is equivalent to `approve`, and can be used to
663    * e.g. set automatic allowances for certain subsystems, etc.
664    *
665    * Emits an {Approval} event.
666    *
667    * Requirements:
668    *
669    * - `owner` cannot be the zero address.
670    * - `spender` cannot be the zero address.
671    */
672   function _approve(address owner, address spender, uint256 amount) internal {
673     require(owner != address(0), "ERC20: approve from the zero address");
674     require(spender != address(0), "ERC20: approve to the zero address");
675 
676     _allowances[owner][spender] = amount;
677     emit Approval(owner, spender, amount);
678   }
679 
680   /**
681    * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
682    * from the caller's allowance.
683    *
684    * See {_burn} and {_approve}.
685    */
686   function _burnFrom(address account, uint256 amount) internal {
687     _burn(account, amount);
688     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
689   }
690   
691 
692   function withdrawStuckTokens(IERC20 token, address to, uint256 amount) public onlyOwner {       
693         token.transfer(to, amount);
694   }
695 
696   
697   function withdrawStuckEth(address payable to) public onlyOwner {
698         to.transfer(address(this).balance);
699   }
700         
701    receive() external payable {}
702     
703 }