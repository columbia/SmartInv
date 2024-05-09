1 pragma solidity >=0.4.22 <0.8.0;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15 
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22 
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30 
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37 
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b > 0, errorMessage);
40         uint256 c = a / b;
41 
42         return c;
43     }
44 
45     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46         return mod(a, b, "SafeMath: modulo by zero");
47     }
48 
49     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b != 0, errorMessage);
51         return a % b;
52     }
53 
54     function pow(uint256 base, uint256 exponent) internal pure returns (uint256) {
55         if (exponent == 0) {
56             return 1;
57         }
58         else if (exponent == 1) {
59             return base;
60         }
61         else if (base == 0 && exponent != 0) {
62             return 0;
63         }
64         else {
65             uint256 z = base;
66             for (uint256 i = 1; i < exponent; i++)
67                 z = mul(z, base);
68             return z;
69         }
70     }
71 }
72 
73 library FixedPointMath {
74   uint256 public constant DECIMALS = 18;
75   uint256 public constant SCALAR = 10**DECIMALS;
76 
77   struct FixedDecimal {
78     uint256 x;
79   }
80 
81   function fromU256(uint256 value) internal pure returns (FixedDecimal memory) {
82     uint256 x;
83     require(value == 0 || (x = value * SCALAR) / SCALAR == value);
84     return FixedDecimal(x);
85   }
86 
87   function maximumValue() internal pure returns (FixedDecimal memory) {
88     return FixedDecimal(uint256(-1));
89   }
90 
91   function add(FixedDecimal memory self, FixedDecimal memory value) internal pure returns (FixedDecimal memory) {
92     uint256 x;
93     require((x = self.x + value.x) >= self.x);
94     return FixedDecimal(x);
95   }
96 
97   function add(FixedDecimal memory self, uint256 value) internal pure returns (FixedDecimal memory) {
98     return add(self, fromU256(value));
99   }
100 
101   function sub(FixedDecimal memory self, FixedDecimal memory value) internal pure returns (FixedDecimal memory) {
102     uint256 x;
103     require((x = self.x - value.x) <= self.x);
104     return FixedDecimal(x);
105   }
106 
107   function sub(FixedDecimal memory self, uint256 value) internal pure returns (FixedDecimal memory) {
108     return sub(self, fromU256(value));
109   }
110 
111   function mul(FixedDecimal memory self, uint256 value) internal pure returns (FixedDecimal memory) {
112     uint256 x;
113     require(value == 0 || (x = self.x * value) / value == self.x);
114     return FixedDecimal(x);
115   }
116 
117   function div(FixedDecimal memory self, uint256 value) internal pure returns (FixedDecimal memory) {
118     require(value != 0);
119     return FixedDecimal(self.x / value);
120   }
121 
122   function cmp(FixedDecimal memory self, FixedDecimal memory value) internal pure returns (int256) {
123     if (self.x < value.x) {
124       return -1;
125     }
126 
127     if (self.x > value.x) {
128       return 1;
129     }
130 
131     return 0;
132   }
133 
134   function decode(FixedDecimal memory self) internal pure returns (uint256) {
135     return self.x / SCALAR;
136   }
137 }
138 
139 library Address {
140     /**
141      * @dev Returns true if `account` is a contract.
142      *
143      * [IMPORTANT]
144      * ====
145      * It is unsafe to assume that an address for which this function returns
146      * false is an externally-owned account (EOA) and not a contract.
147      *
148      * Among others, `isContract` will return false for the following
149      * types of addresses:
150      *
151      *  - an externally-owned account
152      *  - a contract in construction
153      *  - an address where a contract will be created
154      *  - an address where a contract lived, but was destroyed
155      * ====
156      */
157     function isContract(address account) internal view returns (bool) {
158         // This method relies on extcodesize, which returns 0 for contracts in
159         // construction, since the code is only stored at the end of the
160         // constructor execution.
161 
162         uint256 size;
163         // solhint-disable-next-line no-inline-assembly
164         assembly { size := extcodesize(account) }
165         return size > 0;
166     }
167 
168     /**
169      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
170      * `recipient`, forwarding all available gas and reverting on errors.
171      *
172      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
173      * of certain opcodes, possibly making contracts go over the 2300 gas limit
174      * imposed by `transfer`, making them unable to receive funds via
175      * `transfer`. {sendValue} removes this limitation.
176      *
177      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
178      *
179      * IMPORTANT: because control is transferred to `recipient`, care must be
180      * taken to not create reentrancy vulnerabilities. Consider using
181      * {ReentrancyGuard} or the
182      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
183      */
184     function sendValue(address payable recipient, uint256 amount) internal {
185         require(address(this).balance >= amount, "Address: insufficient balance");
186 
187         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
188         (bool success, ) = recipient.call{ value: amount }("");
189         require(success, "Address: unable to send value, recipient may have reverted");
190     }
191 
192     /**
193      * @dev Performs a Solidity function call using a low level `call`. A
194      * plain`call` is an unsafe replacement for a function call: use this
195      * function instead.
196      *
197      * If `target` reverts with a revert reason, it is bubbled up by this
198      * function (like regular Solidity function calls).
199      *
200      * Returns the raw returned data. To convert to the expected return value,
201      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
202      *
203      * Requirements:
204      *
205      * - `target` must be a contract.
206      * - calling `target` with `data` must not revert.
207      *
208      * _Available since v3.1._
209      */
210     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
211         return functionCall(target, data, "Address: low-level call failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
216      * `errorMessage` as a fallback revert reason when `target` reverts.
217      *
218      * _Available since v3.1._
219      */
220     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
221         return functionCallWithValue(target, data, 0, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but also transferring `value` wei to `target`.
227      *
228      * Requirements:
229      *
230      * - the calling contract must have an ETH balance of at least `value`.
231      * - the called Solidity function must be `payable`.
232      *
233      * _Available since v3.1._
234      */
235     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
236         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
241      * with `errorMessage` as a fallback revert reason when `target` reverts.
242      *
243      * _Available since v3.1._
244      */
245     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
246         require(address(this).balance >= value, "Address: insufficient balance for call");
247         require(isContract(target), "Address: call to non-contract");
248 
249         // solhint-disable-next-line avoid-low-level-calls
250         (bool success, bytes memory returndata) = target.call{ value: value }(data);
251         return _verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but performing a static call.
257      *
258      * _Available since v3.3._
259      */
260     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
261         return functionStaticCall(target, data, "Address: low-level static call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
266      * but performing a static call.
267      *
268      * _Available since v3.3._
269      */
270     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
271         require(isContract(target), "Address: static call to non-contract");
272 
273         // solhint-disable-next-line avoid-low-level-calls
274         (bool success, bytes memory returndata) = target.staticcall(data);
275         return _verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
290      * but performing a delegate call.
291      *
292      * _Available since v3.4._
293      */
294     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
295         require(isContract(target), "Address: delegate call to non-contract");
296 
297         // solhint-disable-next-line avoid-low-level-calls
298         (bool success, bytes memory returndata) = target.delegatecall(data);
299         return _verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
303         if (success) {
304             return returndata;
305         } else {
306             // Look for revert reason and bubble it up if present
307             if (returndata.length > 0) {
308                 // The easiest way to bubble the revert reason is using memory via assembly
309 
310                 // solhint-disable-next-line no-inline-assembly
311                 assembly {
312                     let returndata_size := mload(returndata)
313                     revert(add(32, returndata), returndata_size)
314                 }
315             } else {
316                 revert(errorMessage);
317             }
318         }
319     }
320 }
321 
322 
323 library SafeERC20 {
324     using SafeMath for uint256;
325     using Address for address;
326 
327     function safeTransfer(IERC20 token, address to, uint256 value) internal {
328         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
329     }
330 
331     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
332         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
333     }
334 
335     /**
336      * @dev Deprecated. This function has issues similar to the ones found in
337      * {IERC20-approve}, and its usage is discouraged.
338      *
339      * Whenever possible, use {safeIncreaseAllowance} and
340      * {safeDecreaseAllowance} instead.
341      */
342     function safeApprove(IERC20 token, address spender, uint256 value) internal {
343         // safeApprove should only be called when setting an initial allowance,
344         // or when resetting it to zero. To increase and decrease it, use
345         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
346         // solhint-disable-next-line max-line-length
347         require((value == 0) || (token.allowance(address(this), spender) == 0),
348             "SafeERC20: approve from non-zero to non-zero allowance"
349         );
350         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
351     }
352 
353     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
354         uint256 newAllowance = token.allowance(address(this), spender).add(value);
355         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
356     }
357 
358     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
359         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
360         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
361     }
362 
363     /**
364      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
365      * on the return value: the return value is optional (but if data is returned, it must not be false).
366      * @param token The token targeted by the call.
367      * @param data The call data (encoded using abi.encode or one of its variants).
368      */
369     function _callOptionalReturn(IERC20 token, bytes memory data) private {
370         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
371         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
372         // the target address contains contract code and also asserts for success in the low-level call.
373 
374         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
375         if (returndata.length > 0) { // Return data is optional
376             // solhint-disable-next-line max-line-length
377             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
378         }
379     }
380 }
381 
382 contract Context {
383     function _msgSender() internal view returns (address payable) {
384         return msg.sender;
385     }
386 
387     function _msgData() internal view returns (bytes memory) {
388         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
389         return msg.data;
390     }
391 }
392 
393 contract Ownable is Context {
394     address private _owner;
395 
396     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
397 
398     constructor() {
399         address msgSender = _msgSender();
400         _owner = msgSender;
401         emit OwnershipTransferred(address(0), msgSender);
402     }
403 
404     function owner() public view returns (address) {
405         return _owner;
406     }
407 
408     modifier onlyOwner() {
409         require(_owner == _msgSender(), "Ownable: caller is not the owner");
410         _;
411     }
412 
413     function transferOwnership(address newOwner) public onlyOwner {
414         require(newOwner != address(0), "Ownable: new owner is the zero address");
415         emit OwnershipTransferred(_owner, newOwner);
416         _owner = newOwner;
417     }
418 }
419 
420 contract Accessible is Ownable {
421     mapping(address => bool) private access;
422     
423     constructor() {
424         access[msg.sender] = true;
425     }
426     
427      modifier hasAccess() {
428         require(checkAccess(msg.sender));
429         _;
430     }
431     
432     function checkAccess(address sender) public view returns (bool) {
433         if (access[sender] == true) 
434             return true;
435         return false;
436     }
437     
438     function removeAccess(address addr) public hasAccess returns (bool success) {
439         access[addr] = false;
440         return true;
441     }
442     
443     function addAccess(address addr) public hasAccess returns (bool) {
444         access[addr] = true;
445         return true;
446     }
447 }
448 
449 contract ExternalAccessible {
450     
451     address public accessContract;
452 
453     function checkAccess(address sender) public returns (bool) {
454         bool result = Accessible(accessContract).checkAccess(sender);
455         require(result == true);
456         return true;
457     }
458 
459     modifier hasAccess() {
460         require(checkAccess(msg.sender));
461         _;
462     }
463 }
464 
465 interface IERC20 {
466     function totalSupply() external view returns (uint256);
467     function balanceOf(address account) external view returns (uint256);
468     function transfer(address recipient, uint256 amount) external returns (bool);
469     function allowance(address owner, address spender) external view returns (uint256);
470     function approve(address spender, uint256 amount) external returns (bool);
471     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
472     event Transfer(address indexed from, address indexed to, uint256 value);
473     event Approval(address indexed owner, address indexed spender, uint256 value);
474 }
475 
476 abstract contract ERC20 is Context, IERC20, ExternalAccessible {
477     using SafeMath for uint256;
478 
479     mapping (address => uint256) private _balances;
480 
481     mapping (address => mapping (address => uint256)) private _allowances;
482 
483     uint256 private _totalSupply;
484 
485     string public _name;
486     string public _symbol;
487     uint8 public _decimals;
488 
489     function name() public view returns (string memory) {
490         return _name;
491     }
492 
493     function symbol() public view returns (string memory) {
494         return _symbol;
495     }
496 
497     function decimals() public view returns (uint8) {
498         return _decimals;
499     }
500 
501     function totalSupply() public view override returns (uint256) {
502         return _totalSupply;
503     }
504 
505     function balanceOf(address account) public view override returns (uint256) {
506         return _balances[account];
507     }
508 
509     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
510         _transfer(_msgSender(), recipient, amount);
511         return true;
512     }
513 
514     function allowance(address owner, address spender) public view virtual override returns (uint256) {
515         return _allowances[owner][spender];
516     }
517 
518     function approve(address spender, uint256 amount) public virtual override returns (bool) {
519         _approve(_msgSender(), spender, amount);
520         return true;
521     }
522 
523     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
524         _transfer(sender, recipient, amount);
525         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
526         return true;
527     }
528 
529     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
530         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
531         return true;
532     }
533 
534     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
535         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
536         return true;
537     }
538 
539     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
540         require(sender != address(0), "ERC20: transfer from the zero address");
541         require(recipient != address(0), "ERC20: transfer to the zero address");
542 
543         _beforeTokenTransfer(sender, recipient, amount);
544 
545         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
546         _balances[recipient] = _balances[recipient].add(amount);
547         emit Transfer(sender, recipient, amount);
548     }
549 
550     function _mint(address account, uint256 amount) external virtual hasAccess {
551         require(account != address(0), "ERC20: mint to the zero address");
552 
553         _beforeTokenTransfer(address(0), account, amount);
554 
555         _totalSupply = _totalSupply.add(amount);
556         _balances[account] = _balances[account].add(amount);
557         emit Transfer(address(0), account, amount);
558     }
559 
560     function _burn(address account, uint256 amount) external virtual hasAccess {
561         require(account != address(0), "ERC20: burn from the zero address");
562 
563         _beforeTokenTransfer(account, address(0), amount);
564 
565         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
566         _totalSupply = _totalSupply.sub(amount);
567         emit Transfer(account, address(0), amount);
568     }
569 
570     function _approve(address owner, address spender, uint256 amount) internal virtual {
571         require(owner != address(0), "ERC20: approve from the zero address");
572         require(spender != address(0), "ERC20: approve to the zero address");
573 
574         _allowances[owner][spender] = amount;
575         emit Approval(owner, spender, amount);
576     }
577 
578     function _setupDecimals(uint8 decimals_) internal {
579         _decimals = decimals_;
580     }
581 
582     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
583 }
584 
585 contract wXEQ is ERC20 {
586     
587     constructor(address _accessContract) {
588         _name = "Wrapped Equilibria v2";
589         _symbol = "wXEQ";
590         _decimals = 18;
591         accessContract = _accessContract;
592     }
593 }
594 
595 /**
596  * @title Helps contracts guard agains rentrancy attacks.
597  * @author Remco Bloemen <remco@2π.com>
598  * @notice If you mark a function `nonReentrant`, you should also
599  * mark it `external`.
600  */
601 contract ReentrancyGuard {
602 
603   /**
604    * @dev We use a single lock for the whole contract.
605    */
606   bool private rentrancy_lock = false;
607 
608   /**
609    * @dev Prevents a contract from calling itself, directly or indirectly.
610    * @notice If you mark a function `nonReentrant`, you should also
611    * mark it `external`. Calling one nonReentrant function from
612    * another is not supported. Instead, you can implement a
613    * `private` function doing the actual work, and a `external`
614    * wrapper marked as `nonReentrant`.
615    */
616   modifier nonReentrant() {
617     require(!rentrancy_lock);
618     rentrancy_lock = true;
619     _;
620     rentrancy_lock = false;
621   }
622 
623 }
624 
625 library Pool {
626   using FixedPointMath for FixedPointMath.FixedDecimal;
627   using Pool for Pool.Data;
628   using Pool for Pool.List;
629   using SafeMath for uint256;
630 
631   struct Context {
632     uint256 rewardRate;
633     uint256 totalRewardWeight;
634   }
635 
636   struct Data {
637     IERC20 token;
638     uint256 totalDeposited;
639     uint256 rewardWeight;
640     FixedPointMath.FixedDecimal accumulatedRewardWeight;
641     uint256 lastUpdatedBlock;
642   }
643 
644   struct List {
645     Data[] elements;
646   }
647 
648   /// @dev Updates the pool.
649   ///
650   /// @param _ctx the pool context.
651   function update(Data storage _data, Context storage _ctx) internal {
652     _data.accumulatedRewardWeight = _data.getUpdatedAccumulatedRewardWeight(_ctx);
653     _data.lastUpdatedBlock = block.number;
654   }
655 
656   /// @dev Gets the rate at which the pool will distribute rewards to stakers.
657   ///
658   /// @param _ctx the pool context.
659   ///
660   /// @return the reward rate of the pool in tokens per block.
661   function getRewardRate(Data storage _data, Context storage _ctx)
662     internal view
663     returns (uint256)
664   {
665     // console.log("get reward rate");
666     // console.log(uint(_data.rewardWeight));
667     // console.log(uint(_ctx.totalRewardWeight));
668     // console.log(uint(_ctx.rewardRate));
669     return _ctx.rewardRate.mul(_data.rewardWeight).div(_ctx.totalRewardWeight);
670   }
671 
672   /// @dev Gets the accumulated reward weight of a pool.
673   ///
674   /// @param _ctx the pool context.
675   ///
676   /// @return the accumulated reward weight.
677   function getUpdatedAccumulatedRewardWeight(Data storage _data, Context storage _ctx)
678     internal view
679     returns (FixedPointMath.FixedDecimal memory)
680   {
681     if (_data.totalDeposited == 0) {
682       return _data.accumulatedRewardWeight;
683     }
684 
685     uint256 _elapsedTime = block.number.sub(_data.lastUpdatedBlock);
686     if (_elapsedTime == 0) {
687       return _data.accumulatedRewardWeight;
688     }
689 
690     uint256 _rewardRate = _data.getRewardRate(_ctx);
691     uint256 _distributeAmount = _rewardRate.mul(_elapsedTime);
692 
693     if (_distributeAmount == 0) {
694       return _data.accumulatedRewardWeight;
695     }
696 
697     FixedPointMath.FixedDecimal memory _rewardWeight = FixedPointMath.fromU256(_distributeAmount).div(_data.totalDeposited);
698     return _data.accumulatedRewardWeight.add(_rewardWeight);
699   }
700 
701   /// @dev Adds an element to the list.
702   ///
703   /// @param _element the element to add.
704   function push(List storage _self, Data memory _element) internal {
705     _self.elements.push(_element);
706   }
707 
708   /// @dev Gets an element from the list.
709   ///
710   /// @param _index the index in the list.
711   ///
712   /// @return the element at the specified index.
713   function get(List storage _self, uint256 _index) internal view returns (Data storage) {
714     return _self.elements[_index];
715   }
716 
717   /// @dev Gets the last element in the list.
718   ///
719   /// This function will revert if there are no elements in the list.
720   ///ck
721   /// @return the last element in the list.
722   function last(List storage _self) internal view returns (Data storage) {
723     return _self.elements[_self.lastIndex()];
724   }
725 
726   /// @dev Gets the index of the last element in the list.
727   ///
728   /// This function will revert if there are no elements in the list.
729   ///
730   /// @return the index of the last element.
731   function lastIndex(List storage _self) internal view returns (uint256) {
732     uint256 _length = _self.length();
733     return _length.sub(1, "Pool.List: list is empty");
734   }
735 
736   /// @dev Gets the number of elements in the list.
737   ///
738   /// @return the number of elements.
739   function length(List storage _self) internal view returns (uint256) {
740     return _self.elements.length;
741   }
742 }
743 
744 /// @title Stake
745 ///
746 /// @dev A library which provides the Stake data struct and associated functions.
747 library Stake {
748   using FixedPointMath for FixedPointMath.FixedDecimal;
749   using Pool for Pool.Data;
750   using SafeMath for uint256;
751   using Stake for Stake.Data;
752 
753   struct Data {
754     uint256 totalDeposited;
755     uint256 totalUnclaimed;
756     FixedPointMath.FixedDecimal lastAccumulatedWeight;
757   }
758 
759   function update(Data storage _self, Pool.Data storage _pool, Pool.Context storage _ctx) internal {
760     _self.totalUnclaimed = _self.getUpdatedTotalUnclaimed(_pool, _ctx);
761     _self.lastAccumulatedWeight = _pool.getUpdatedAccumulatedRewardWeight(_ctx);
762   }
763 
764   function getUpdatedTotalUnclaimed(Data storage _self, Pool.Data storage _pool, Pool.Context storage _ctx)
765     internal view
766     returns (uint256)
767   {
768     FixedPointMath.FixedDecimal memory _currentAccumulatedWeight = _pool.getUpdatedAccumulatedRewardWeight(_ctx);
769     FixedPointMath.FixedDecimal memory _lastAccumulatedWeight = _self.lastAccumulatedWeight;
770 
771     if (_currentAccumulatedWeight.cmp(_lastAccumulatedWeight) == 0) {
772       return _self.totalUnclaimed;
773     }
774 
775     uint256 _distributedAmount = _currentAccumulatedWeight
776       .sub(_lastAccumulatedWeight)
777       .mul(_self.totalDeposited)
778       .decode();
779 
780     return _self.totalUnclaimed.add(_distributedAmount);
781   }
782 }
783 
784 interface IDetailedERC20 is IERC20 {
785   function name() external returns (string memory);
786   function symbol() external returns (string memory);
787   function decimals() external returns (uint8);
788 }
789 
790 interface IMintableERC20 is IDetailedERC20{
791   function _mint(address _recipient, uint256 _amount) external;
792   function _burn(address account, uint256 amount) external;
793 }
794 
795 contract StakingPools is ReentrancyGuard {
796   using FixedPointMath for FixedPointMath.FixedDecimal;
797   using Pool for Pool.Data;
798   using Pool for Pool.List;
799   using SafeERC20 for IERC20;
800   using SafeMath for uint256;
801   using Stake for Stake.Data;
802 
803   event PendingGovernanceUpdated(
804     address pendingGovernance
805   );
806 
807   event GovernanceUpdated(
808     address governance
809   );
810 
811   event RewardRateUpdated(
812     uint256 rewardRate
813   );
814 
815   event PoolRewardWeightUpdated(
816     uint256 indexed poolId,
817     uint256 rewardWeight
818   );
819 
820   event PoolCreated(
821     uint256 indexed poolId,
822     IERC20 indexed token
823   );
824 
825   event TokensDeposited(
826     address indexed user,
827     uint256 indexed poolId,
828     uint256 amount
829   );
830 
831   event TokensWithdrawn(
832     address indexed user,
833     uint256 indexed poolId,
834     uint256 amount
835   );
836 
837   event TokensClaimed(
838     address indexed user,
839     uint256 indexed poolId,
840     uint256 amount
841   );
842 
843   /// @dev The token which will be minted as a reward for staking.
844   IMintableERC20 public reward;
845 
846   /// @dev The address of the account which currently has administrative capabilities over this contract.
847   address public governance;
848 
849   address public pendingGovernance;
850 
851   /// @dev Tokens are mapped to their pool identifier plus one. Tokens that do not have an associated pool
852   /// will return an identifier of zero.
853   mapping(IERC20 => uint256) public tokenPoolIds;
854 
855   /// @dev The context shared between the pools.
856   Pool.Context private _ctx;
857 
858   /// @dev A list of all of the pools.
859   Pool.List private _pools;
860 
861   /// @dev A mapping of all of the user stakes mapped first by pool and then by address.
862   mapping(address => mapping(uint256 => Stake.Data)) private _stakes;
863   
864   /// @dev Tracks the total amount of tokens claimed as rewards.
865   uint256 public totalTokensClaimed;
866 
867   constructor(
868     IMintableERC20 _reward,
869     address _governance
870   ) public {
871     require(_governance != address(0), "StakingPools: governance address cannot be 0x0");
872 
873     reward = _reward;
874     governance = _governance;
875     // 2083333300000000
876   }
877 
878   /// @dev A modifier which reverts when the caller is not the governance.
879   modifier onlyGovernance() {
880     require(msg.sender == governance, "StakingPools: only governance");
881     _;
882   }
883 
884   /// @dev Sets the governance.
885   ///
886   /// This function can only called by the current governance.
887   ///
888   /// @param _pendingGovernance the new pending governance.
889   function setPendingGovernance(address _pendingGovernance) external onlyGovernance {
890     require(_pendingGovernance != address(0), "StakingPools: pending governance address cannot be 0x0");
891     pendingGovernance = _pendingGovernance;
892 
893     emit PendingGovernanceUpdated(_pendingGovernance);
894   }
895 
896   function acceptGovernance() external {
897     require(msg.sender == pendingGovernance, "StakingPools: only pending governance");
898 
899     address _pendingGovernance = pendingGovernance;
900     governance = _pendingGovernance;
901 
902     emit GovernanceUpdated(_pendingGovernance);
903   }
904 
905   /// @dev Sets the distribution reward rate.
906   ///
907   /// This will update all of the pools.
908   ///
909   /// @param _rewardRate The number of tokens to distribute per second.
910   function setRewardRate(uint256 _rewardRate) external onlyGovernance {
911     _updatePools(); // 951293760000000
912 
913     _ctx.rewardRate = _rewardRate;
914 
915     emit RewardRateUpdated(_rewardRate);
916   }
917 
918   /// @dev Creates a new pool.
919   ///
920   /// The created pool will need to have its reward weight initialized before it begins generating rewards.
921   ///
922   /// @param _token The token the pool will accept for staking.
923   ///
924   /// @return the identifier for the newly created pool.
925   function createPool(IERC20 _token) external onlyGovernance returns (uint256) {
926     require(tokenPoolIds[_token] == 0, "StakingPools: token already has a pool");
927 
928     uint256 _poolId = _pools.length();
929 
930     _pools.push(Pool.Data({
931       token: _token,
932       totalDeposited: 0,
933       rewardWeight: 0,
934       accumulatedRewardWeight: FixedPointMath.FixedDecimal(0),
935       lastUpdatedBlock: block.number
936     }));
937 
938     tokenPoolIds[_token] = _poolId + 1;
939 
940     emit PoolCreated(_poolId, _token);
941 
942     return _poolId;
943   }
944 
945   /// @dev Sets the reward weights of all of the pools.
946   ///
947   /// @param _rewardWeights The reward weights of all of the pools.
948   function setRewardWeights(uint256[] calldata _rewardWeights) external onlyGovernance {
949     require(_rewardWeights.length == _pools.length(), "StakingPools: weights length mismatch");
950 
951     _updatePools();
952 
953     uint256 _totalRewardWeight = _ctx.totalRewardWeight;
954     for (uint256 _poolId = 0; _poolId < _pools.length(); _poolId++) {
955       Pool.Data storage _pool = _pools.get(_poolId);
956 
957       uint256 _currentRewardWeight = _pool.rewardWeight;
958       if (_currentRewardWeight == _rewardWeights[_poolId]) {
959         continue;
960       }
961 
962       // FIXME
963       _totalRewardWeight = _totalRewardWeight.sub(_currentRewardWeight).add(_rewardWeights[_poolId]);
964       _pool.rewardWeight = _rewardWeights[_poolId];
965 
966       emit PoolRewardWeightUpdated(_poolId, _rewardWeights[_poolId]);
967     }
968 
969     _ctx.totalRewardWeight = _totalRewardWeight;
970   }
971 
972   /// @dev Stakes tokens into a pool.
973   ///
974   /// @param _poolId        the pool to deposit tokens into.
975   /// @param _depositAmount the amount of tokens to deposit.
976   function deposit(uint256 _poolId, uint256 _depositAmount) external nonReentrant {
977     Pool.Data storage _pool = _pools.get(_poolId);
978     _pool.update(_ctx);
979 
980     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
981     _stake.update(_pool, _ctx);
982 
983     _deposit(_poolId, _depositAmount);
984   }
985 
986   /// @dev Withdraws staked tokens from a pool.
987   ///
988   /// @param _poolId          The pool to withdraw staked tokens from.
989   /// @param _withdrawAmount  The number of tokens to withdraw.
990   function withdraw(uint256 _poolId, uint256 _withdrawAmount) external nonReentrant {
991     Pool.Data storage _pool = _pools.get(_poolId);
992     _pool.update(_ctx);
993 
994     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
995     _stake.update(_pool, _ctx);
996     
997     _claim(_poolId);
998     _withdraw(_poolId, _withdrawAmount);
999   }
1000 
1001   /// @dev Claims all rewarded tokens from a pool.
1002   ///
1003   /// @param _poolId The pool to claim rewards from.
1004   ///
1005   /// @notice use this function to claim the tokens from a corresponding pool by ID.
1006   function claim(uint256 _poolId) external nonReentrant {
1007     Pool.Data storage _pool = _pools.get(_poolId);
1008     _pool.update(_ctx);
1009 
1010     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1011     _stake.update(_pool, _ctx);
1012 
1013     _claim(_poolId);
1014   }
1015 
1016   /// @dev Claims all rewards from a pool and then withdraws all staked tokens.
1017   ///
1018   /// @param _poolId the pool to exit from.
1019   function exit(uint256 _poolId) external nonReentrant {
1020     Pool.Data storage _pool = _pools.get(_poolId);
1021     _pool.update(_ctx);
1022 
1023     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1024     _stake.update(_pool, _ctx);
1025 
1026     _claim(_poolId);
1027     _withdraw(_poolId, _stake.totalDeposited);
1028   }
1029 
1030   /// @dev Gets the rate at which tokens are minted to stakers for all pools.
1031   ///
1032   /// @return the reward rate.
1033   function rewardRate() external view returns (uint256) {
1034     return _ctx.rewardRate;
1035   }
1036 
1037   /// @dev Gets the total reward weight between all the pools.
1038   ///
1039   /// @return the total reward weight.
1040   function totalRewardWeight() external view returns (uint256) {
1041     return _ctx.totalRewardWeight;
1042   }
1043 
1044   /// @dev Gets the number of pools that exist.
1045   ///
1046   /// @return the pool count.
1047   function poolCount() external view returns (uint256) {
1048     return _pools.length();
1049   }
1050 
1051   /// @dev Gets the token a pool accepts.
1052   ///
1053   /// @param _poolId the identifier of the pool.
1054   ///
1055   /// @return the token.
1056   function getPoolToken(uint256 _poolId) external view returns (IERC20) {
1057     Pool.Data storage _pool = _pools.get(_poolId);
1058     return _pool.token;
1059   }
1060 
1061   /// @dev Gets the total amount of funds staked in a pool.
1062   ///
1063   /// @param _poolId the identifier of the pool.
1064   ///
1065   /// @return the total amount of staked or deposited tokens.
1066   function getPoolTotalDeposited(uint256 _poolId) external view returns (uint256) {
1067     Pool.Data storage _pool = _pools.get(_poolId);
1068     return _pool.totalDeposited;
1069   }
1070 
1071   /// @dev Gets the reward weight of a pool which determines how much of the total rewards it receives per block.
1072   ///
1073   /// @param _poolId the identifier of the pool.
1074   ///
1075   /// @return the pool reward weight.
1076   function getPoolRewardWeight(uint256 _poolId) external view returns (uint256) {
1077     Pool.Data storage _pool = _pools.get(_poolId);
1078     return _pool.rewardWeight;
1079   }
1080 
1081   /// @dev Gets the amount of tokens per block being distributed to stakers for a pool.
1082   ///
1083   /// @param _poolId the identifier of the pool.
1084   ///
1085   /// @return the pool reward rate.
1086   function getPoolRewardRate(uint256 _poolId) external view returns (uint256) {
1087     Pool.Data storage _pool = _pools.get(_poolId);
1088     return _pool.getRewardRate(_ctx);
1089   }
1090 
1091   /// @dev Gets the number of tokens a user has staked into a pool.
1092   ///
1093   /// @param _account The account to query.
1094   /// @param _poolId  the identifier of the pool.
1095   ///
1096   /// @return the amount of deposited tokens.
1097   function getStakeTotalDeposited(address _account, uint256 _poolId) external view returns (uint256) {
1098     Stake.Data storage _stake = _stakes[_account][_poolId];
1099     return _stake.totalDeposited;
1100   }
1101 
1102   /// @dev Gets the number of unclaimed reward tokens a user can claim from a pool.
1103   ///
1104   /// @param _account The account to get the unclaimed balance of.
1105   /// @param _poolId  The pool to check for unclaimed rewards.
1106   ///
1107   /// @return the amount of unclaimed reward tokens a user has in a pool.
1108   function getStakeTotalUnclaimed(address _account, uint256 _poolId) external view returns (uint256) {
1109     Stake.Data storage _stake = _stakes[_account][_poolId];
1110     return _stake.getUpdatedTotalUnclaimed(_pools.get(_poolId), _ctx);
1111   }
1112 
1113   /// @dev Updates all of the pools.
1114   function _updatePools() internal {
1115     for (uint256 _poolId = 0; _poolId < _pools.length(); _poolId++) {
1116       Pool.Data storage _pool = _pools.get(_poolId);
1117       _pool.update(_ctx);
1118     }
1119   }
1120 
1121   /// @dev Stakes tokens into a pool.
1122   ///
1123   /// The pool and stake MUST be updated before calling this function.
1124   ///
1125   /// @param _poolId        the pool to deposit tokens into.
1126   /// @param _depositAmount the amount of tokens to deposit.
1127   function _deposit(uint256 _poolId, uint256 _depositAmount) internal {
1128     Pool.Data storage _pool = _pools.get(_poolId);
1129     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1130 
1131     _pool.totalDeposited = _pool.totalDeposited.add(_depositAmount);
1132     _stake.totalDeposited = _stake.totalDeposited.add(_depositAmount);
1133 
1134     _pool.token.safeTransferFrom(msg.sender, address(this), _depositAmount);
1135 
1136     emit TokensDeposited(msg.sender, _poolId, _depositAmount);
1137   }
1138 
1139   /// @dev Withdraws staked tokens from a pool.
1140   ///
1141   /// The pool and stake MUST be updated before calling this function.
1142   ///
1143   /// @param _poolId          The pool to withdraw staked tokens from.
1144   /// @param _withdrawAmount  The number of tokens to withdraw.
1145   function _withdraw(uint256 _poolId, uint256 _withdrawAmount) internal {
1146     Pool.Data storage _pool = _pools.get(_poolId);
1147     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1148 
1149     _pool.totalDeposited = _pool.totalDeposited.sub(_withdrawAmount);
1150     _stake.totalDeposited = _stake.totalDeposited.sub(_withdrawAmount);
1151 
1152     _pool.token.safeTransfer(msg.sender, _withdrawAmount);
1153 
1154     emit TokensWithdrawn(msg.sender, _poolId, _withdrawAmount);
1155   }
1156 
1157   /// @dev Claims all rewarded tokens from a pool.
1158   ///
1159   /// The pool and stake MUST be updated before calling this function.
1160   ///
1161   /// @param _poolId The pool to claim rewards from.
1162   ///
1163   /// @notice use this function to claim the tokens from a corresponding pool by ID.
1164   function _claim(uint256 _poolId) internal {
1165     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1166 
1167     uint256 _claimAmount = _stake.totalUnclaimed;
1168     _stake.totalUnclaimed = 0;
1169     
1170     reward._mint(msg.sender, _claimAmount);
1171     totalTokensClaimed = totalTokensClaimed.add(_claimAmount);
1172 
1173     emit TokensClaimed(msg.sender, _poolId, _claimAmount);
1174   }
1175 }
1176 
1177 contract Snapshot is Ownable {
1178     
1179     address[] public addressList;
1180     address public oldContract;
1181     address public newContract;
1182     
1183     mapping(address => bool) public hasClaimed;
1184     
1185     constructor(address _oldContract, address _newContract) {
1186         oldContract = _oldContract;
1187         newContract = _newContract;
1188     }
1189     
1190     function swapTokens(uint loops) public onlyOwner {
1191 
1192         for (uint x = 0; x < loops; x++) {
1193             if (hasClaimed[addressList[x]] == false) {
1194                 uint256 bal = ERC20(oldContract).balanceOf(addressList[x]);
1195                 if (bal > 0)
1196                     ERC20(newContract)._mint(addressList[x], bal);
1197                 hasClaimed[addressList[x]] = true;
1198             }
1199         }
1200     }
1201     
1202     function numberOfAddresses() public view returns (uint256) {
1203         return addressList.length;
1204     }
1205     
1206     function addAddresses(address[] calldata _addressList) public onlyOwner {
1207         for (uint i = 0; i < _addressList.length; i++) {
1208             addressList.push(_addressList[i]);
1209         }
1210     }
1211 }
1212 
1213 contract XEQSwaps is ExternalAccessible, Ownable {
1214     using SafeMath for *;
1215     
1216     wXEQ wXEQContract;
1217 
1218     uint256 public wXEQMinted;
1219     uint256 public wXEQBurned;
1220     uint256 public teamFees;
1221 
1222     uint256 teamAmount;
1223     uint256 burntAmount;
1224     uint256 devFeePercent;
1225 
1226     //txHash -> eth address of tx mint
1227     
1228     mapping(string => bool) xeq_complete;
1229     mapping(string => uint256) xeq_amounts;
1230     mapping(string => address) eth_addresses;
1231 
1232     
1233     constructor(address _wxeq, address _accessContract) {
1234         accessContract = _accessContract;
1235         wXEQContract = wXEQ(_wxeq);
1236         wXEQMinted = 0;
1237         transferOwnership(msg.sender);
1238         teamAmount = 4000;
1239         burntAmount = 6000;
1240         devFeePercent = 100;
1241         
1242     }
1243     
1244     event NewMint(address indexed account, uint256 amount, uint256 devFee, uint256 amountBurnt);
1245     
1246     function devFee(uint256 _value, uint256 devFeeVal1) public pure returns (uint256) {
1247         return ((_value.mul(devFeeVal1)).div(10000));
1248     }
1249     
1250     function claim_wxeq(string memory tx_hash) public returns (bool) {
1251         require(xeq_amounts[tx_hash] != 0);
1252         require(eth_addresses[tx_hash] != address(0));
1253         require(!xeq_complete[tx_hash]);
1254         require(eth_addresses[tx_hash] == msg.sender);
1255         xeq_complete[tx_hash] = true;
1256         uint256 fee = devFee(xeq_amounts[tx_hash], devFeePercent);
1257         uint256 teamFee = devFee(fee, teamAmount);
1258         uint256 burnt = devFee(fee, burntAmount);
1259         wXEQContract._mint(eth_addresses[tx_hash], xeq_amounts[tx_hash]);
1260         wXEQContract._mint(owner(), teamFee);
1261         wXEQBurned = wXEQBurned.add(burnt);
1262         wXEQMinted = wXEQMinted.add(xeq_amounts[tx_hash]);
1263         teamFees = teamFees.add(teamFee);
1264         emit NewMint(eth_addresses[tx_hash], xeq_amounts[tx_hash], teamFee, burnt);
1265         return true;
1266     }
1267     
1268     
1269     function register_transaction(address account, string memory tx_hash, uint256 amount) public hasAccess returns (bool) {
1270         require(!xeq_complete[tx_hash]);
1271         require(xeq_amounts[tx_hash] == 0);
1272         require(eth_addresses[tx_hash] == address(0));
1273         
1274         eth_addresses[tx_hash] = account;
1275         xeq_amounts[tx_hash] = amount;
1276         return true;
1277     }
1278     
1279     function isSwapRegistered(string memory tx_hash) public view returns (bool) {
1280         if(xeq_amounts[tx_hash] == 0) 
1281         {
1282             return false;
1283         }
1284         return true;
1285     }
1286     
1287     function testDevFeeVals(uint256 _value, uint256 val1, uint256 val2) public pure returns (uint256) {
1288         return (_value.mul(val1)).div(val2);
1289     }
1290     
1291     function setDevFee(uint256 val) public hasAccess returns (bool) {
1292         devFeePercent = val;
1293         assert(devFeePercent == val);
1294         return true;
1295     }
1296 
1297      function setBurntAmount(uint256 val) public hasAccess returns (bool) {
1298         burntAmount = val;
1299         assert(burntAmount == val);
1300         return true;
1301     }
1302 
1303     function setTeamAmount(uint256 val) public hasAccess returns (bool) {
1304         teamAmount = val;
1305         assert(teamAmount == val);
1306         return true;
1307     }
1308 
1309     function devFee(uint _value) public view returns (uint256) {
1310         return ((_value.mul(devFeePercent)).div(10000));
1311     }
1312 }