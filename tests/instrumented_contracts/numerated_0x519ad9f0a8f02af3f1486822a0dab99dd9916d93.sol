1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.6;
4 
5 interface IERC20 {
6   function totalSupply() external view returns (uint);
7   function balanceOf(address account) external view returns (uint);
8   function transfer(address recipient, uint256 amount) external returns (bool);
9   function allowance(address owner, address spender) external view returns (uint);
10   function symbol() external view returns (string memory);
11   function decimals() external view returns (uint);
12   function approve(address spender, uint amount) external returns (bool);
13   function mint(address account, uint amount) external;
14   function burn(address account, uint amount) external;
15   function transferFrom(address sender, address recipient, uint amount) external returns (bool);
16   event Transfer(address indexed from, address indexed to, uint value);
17   event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 interface ILPTokenMaster is IERC20 {
21   function initialize() external;
22   function transferOwnership(address newOwner) external;
23   function underlying() external view returns(address);
24   function owner() external view returns(address);
25   function lendingPair() external view returns(address);
26   function selfBurn(uint _amount) external;
27 }
28 
29 interface ILendingPair {
30   function checkAccountHealth(address _account) external view;
31   function accrueAccount(address _account) external;
32   function accrue() external;
33   function accountHealth(address _account) external view returns(uint);
34   function totalDebt(address _token) external view returns(uint);
35   function tokenA() external view returns(address);
36   function tokenB() external view returns(address);
37   function lpToken(address _token) external view returns(IERC20);
38   function debtOf(address _account, address _token) external view returns(uint);
39   function pendingDebtTotal(address _token) external view returns(uint);
40   function pendingSupplyTotal(address _token) external view returns(uint);
41   function deposit(address _token, uint _amount) external;
42   function withdraw(address _token, uint _amount) external;
43   function borrow(address _token, uint _amount) external;
44   function repay(address _token, uint _amount) external;
45   function withdrawBorrow(address _token, uint _amount) external;
46   function controller() external view returns(IController);
47 
48   function borrowBalance(
49     address _account,
50     address _borrowedToken,
51     address _returnToken
52   ) external view returns(uint);
53 
54   function convertTokenValues(
55     address _fromToken,
56     address _toToken,
57     uint    _inputAmount
58   ) external view returns(uint);
59 }
60 
61 interface IInterestRateModel {
62   function systemRate(ILendingPair _pair, address _token) external view returns(uint);
63   function supplyRatePerBlock(ILendingPair _pair, address _token) external view returns(uint);
64   function borrowRatePerBlock(ILendingPair _pair, address _token) external view returns(uint);
65 }
66 
67 interface IController {
68   function interestRateModel() external view returns(IInterestRateModel);
69   function rewardDistribution() external view returns(IRewardDistribution);
70   function feeRecipient() external view returns(address);
71   function LIQ_MIN_HEALTH() external view returns(uint);
72   function minBorrowUSD() external view returns(uint);
73   function liqFeeSystem(address _token) external view returns(uint);
74   function liqFeeCaller(address _token) external view returns(uint);
75   function liqFeesTotal(address _token) external view returns(uint);
76   function colFactor(address _token) external view returns(uint);
77   function depositLimit(address _lendingPair, address _token) external view returns(uint);
78   function borrowLimit(address _lendingPair, address _token) external view returns(uint);
79   function originFee(address _token) external view returns(uint);
80   function depositsEnabled() external view returns(bool);
81   function borrowingEnabled() external view returns(bool);
82   function setFeeRecipient(address _feeRecipient) external;
83   function tokenPrice(address _token) external view returns(uint);
84   function tokenSupported(address _token) external view returns(bool);
85 }
86 
87 interface IRewardDistribution {
88   function distributeReward(address _account, address _token) external;
89 }
90 
91 interface IWETH {
92   function deposit() external payable;
93   function withdraw(uint wad) external;
94   function balanceOf(address account) external view returns (uint);
95   function transfer(address recipient, uint amount) external returns (bool);
96   function approve(address spender, uint amount) external returns (bool);
97 }
98 
99 library Math {
100 
101   function max(uint256 a, uint256 b) internal pure returns (uint256) {
102     return a >= b ? a : b;
103   }
104 
105   function min(uint256 a, uint256 b) internal pure returns (uint256) {
106     return a < b ? a : b;
107   }
108 
109   function average(uint256 a, uint256 b) internal pure returns (uint256) {
110     // (a + b) / 2 can overflow, so we distribute.
111     return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
112   }
113 
114   function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
115     // (a + b - 1) / b can overflow on addition, so we distribute.
116     return a / b + (a % b == 0 ? 0 : 1);
117   }
118 }
119 
120 library Address {
121     /**
122      * @dev Returns true if `account` is a contract.
123      *
124      * [IMPORTANT]
125      * ====
126      * It is unsafe to assume that an address for which this function returns
127      * false is an externally-owned account (EOA) and not a contract.
128      *
129      * Among others, `isContract` will return false for the following
130      * types of addresses:
131      *
132      *  - an externally-owned account
133      *  - a contract in construction
134      *  - an address where a contract will be created
135      *  - an address where a contract lived, but was destroyed
136      * ====
137      */
138     function isContract(address account) internal view returns (bool) {
139         // This method relies on extcodesize, which returns 0 for contracts in
140         // construction, since the code is only stored at the end of the
141         // constructor execution.
142 
143         uint256 size;
144         // solhint-disable-next-line no-inline-assembly
145         assembly { size := extcodesize(account) }
146         return size > 0;
147     }
148 
149     /**
150      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
151      * `recipient`, forwarding all available gas and reverting on errors.
152      *
153      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
154      * of certain opcodes, possibly making contracts go over the 2300 gas limit
155      * imposed by `transfer`, making them unable to receive funds via
156      * `transfer`. {sendValue} removes this limitation.
157      *
158      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
159      *
160      * IMPORTANT: because control is transferred to `recipient`, care must be
161      * taken to not create reentrancy vulnerabilities. Consider using
162      * {ReentrancyGuard} or the
163      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
164      */
165     function sendValue(address payable recipient, uint256 amount) internal {
166         require(address(this).balance >= amount, "Address: insufficient balance");
167 
168         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
169         (bool success, ) = recipient.call{ value: amount }("");
170         require(success, "Address: unable to send value, recipient may have reverted");
171     }
172 
173     /**
174      * @dev Performs a Solidity function call using a low level `call`. A
175      * plain`call` is an unsafe replacement for a function call: use this
176      * function instead.
177      *
178      * If `target` reverts with a revert reason, it is bubbled up by this
179      * function (like regular Solidity function calls).
180      *
181      * Returns the raw returned data. To convert to the expected return value,
182      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
183      *
184      * Requirements:
185      *
186      * - `target` must be a contract.
187      * - calling `target` with `data` must not revert.
188      *
189      * _Available since v3.1._
190      */
191     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
192       return functionCall(target, data, "Address: low-level call failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
197      * `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, 0, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but also transferring `value` wei to `target`.
208      *
209      * Requirements:
210      *
211      * - the calling contract must have an ETH balance of at least `value`.
212      * - the called Solidity function must be `payable`.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
217         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
222      * with `errorMessage` as a fallback revert reason when `target` reverts.
223      *
224      * _Available since v3.1._
225      */
226     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
227         require(address(this).balance >= value, "Address: insufficient balance for call");
228         require(isContract(target), "Address: call to non-contract");
229 
230         // solhint-disable-next-line avoid-low-level-calls
231         (bool success, bytes memory returndata) = target.call{ value: value }(data);
232         return _verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
242         return functionStaticCall(target, data, "Address: low-level static call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
252         require(isContract(target), "Address: static call to non-contract");
253 
254         // solhint-disable-next-line avoid-low-level-calls
255         (bool success, bytes memory returndata) = target.staticcall(data);
256         return _verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
266         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
271      * but performing a delegate call.
272      *
273      * _Available since v3.4._
274      */
275     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
276         require(isContract(target), "Address: delegate call to non-contract");
277 
278         // solhint-disable-next-line avoid-low-level-calls
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return _verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
284         if (success) {
285             return returndata;
286         } else {
287             // Look for revert reason and bubble it up if present
288             if (returndata.length > 0) {
289                 // The easiest way to bubble the revert reason is using memory via assembly
290 
291                 // solhint-disable-next-line no-inline-assembly
292                 assembly {
293                     let returndata_size := mload(returndata)
294                     revert(add(32, returndata), returndata_size)
295                 }
296             } else {
297                 revert(errorMessage);
298             }
299         }
300     }
301 }
302 
303 library Clones {
304     /**
305      * @dev Deploys and returns the address of a clone that mimics the behaviour of `master`.
306      *
307      * This function uses the create opcode, which should never revert.
308      */
309     function clone(address master) internal returns (address instance) {
310         // solhint-disable-next-line no-inline-assembly
311         assembly {
312             let ptr := mload(0x40)
313             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
314             mstore(add(ptr, 0x14), shl(0x60, master))
315             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
316             instance := create(0, ptr, 0x37)
317         }
318         require(instance != address(0), "ERC1167: create failed");
319     }
320 
321     /**
322      * @dev Deploys and returns the address of a clone that mimics the behaviour of `master`.
323      *
324      * This function uses the create2 opcode and a `salt` to deterministically deploy
325      * the clone. Using the same `master` and `salt` multiple time will revert, since
326      * the clones cannot be deployed twice at the same address.
327      */
328     function cloneDeterministic(address master, bytes32 salt) internal returns (address instance) {
329         // solhint-disable-next-line no-inline-assembly
330         assembly {
331             let ptr := mload(0x40)
332             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
333             mstore(add(ptr, 0x14), shl(0x60, master))
334             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
335             instance := create2(0, ptr, 0x37, salt)
336         }
337         require(instance != address(0), "ERC1167: create2 failed");
338     }
339 
340     /**
341      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
342      */
343     function predictDeterministicAddress(address master, bytes32 salt, address deployer) internal pure returns (address predicted) {
344         // solhint-disable-next-line no-inline-assembly
345         assembly {
346             let ptr := mload(0x40)
347             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
348             mstore(add(ptr, 0x14), shl(0x60, master))
349             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
350             mstore(add(ptr, 0x38), shl(0x60, deployer))
351             mstore(add(ptr, 0x4c), salt)
352             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
353             predicted := keccak256(add(ptr, 0x37), 0x55)
354         }
355     }
356 
357     /**
358      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
359      */
360     function predictDeterministicAddress(address master, bytes32 salt) internal view returns (address predicted) {
361         return predictDeterministicAddress(master, salt, address(this));
362     }
363 }
364 
365 library SafeERC20 {
366 
367     using Address for address;
368 
369     function safeTransfer(
370         IERC20 token,
371         address to,
372         uint256 value
373     ) internal {
374         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
375     }
376 
377     function safeTransferFrom(
378         IERC20 token,
379         address from,
380         address to,
381         uint256 value
382     ) internal {
383         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
384     }
385 
386     /**
387      * @dev Deprecated. This function has issues similar to the ones found in
388      * {IERC20-approve}, and its usage is discouraged.
389      *
390      * Whenever possible, use {safeIncreaseAllowance} and
391      * {safeDecreaseAllowance} instead.
392      */
393     function safeApprove(
394         IERC20 token,
395         address spender,
396         uint256 value
397     ) internal {
398         // safeApprove should only be called when setting an initial allowance,
399         // or when resetting it to zero. To increase and decrease it, use
400         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
401         require(
402             (value == 0) || (token.allowance(address(this), spender) == 0),
403             "SafeERC20: approve from non-zero to non-zero allowance"
404         );
405         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
406     }
407 
408     function safeIncreaseAllowance(
409         IERC20 token,
410         address spender,
411         uint256 value
412     ) internal {
413         uint256 newAllowance = token.allowance(address(this), spender) + value;
414         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
415     }
416 
417     function safeDecreaseAllowance(
418         IERC20 token,
419         address spender,
420         uint256 value
421     ) internal {
422         unchecked {
423             uint256 oldAllowance = token.allowance(address(this), spender);
424             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
425             uint256 newAllowance = oldAllowance - value;
426             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
427         }
428     }
429 
430     /**
431      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
432      * on the return value: the return value is optional (but if data is returned, it must not be false).
433      * @param token The token targeted by the call.
434      * @param data The call data (encoded using abi.encode or one of its variants).
435      */
436     function _callOptionalReturn(IERC20 token, bytes memory data) private {
437         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
438         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
439         // the target address contains contract code and also asserts for success in the low-level call.
440 
441         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
442         if (returndata.length > 0) {
443             // Return data is optional
444             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
445         }
446     }
447 }
448 
449 contract Ownable {
450 
451   address public owner;
452   address public pendingOwner;
453 
454   event OwnershipTransferInitiated(address indexed previousOwner, address indexed newOwner);
455   event OwnershipTransferConfirmed(address indexed previousOwner, address indexed newOwner);
456 
457   constructor() {
458     owner = msg.sender;
459     emit OwnershipTransferConfirmed(address(0), owner);
460   }
461 
462   modifier onlyOwner() {
463     require(isOwner(), "Ownable: caller is not the owner");
464     _;
465   }
466 
467   function isOwner() public view returns (bool) {
468     return msg.sender == owner;
469   }
470 
471   function transferOwnership(address _newOwner) external onlyOwner {
472     require(_newOwner != address(0), "Ownable: new owner is the zero address");
473     emit OwnershipTransferInitiated(owner, _newOwner);
474     pendingOwner = _newOwner;
475   }
476 
477   function acceptOwnership() external {
478     require(msg.sender == pendingOwner, "Ownable: caller is not pending owner");
479     emit OwnershipTransferConfirmed(owner, pendingOwner);
480     owner = pendingOwner;
481     pendingOwner = address(0);
482   }
483 }
484 
485 contract ERC20 is Ownable {
486 
487   event Transfer(address indexed from, address indexed to, uint value);
488   event Approval(address indexed owner, address indexed spender, uint value);
489 
490   mapping (address => uint) public balanceOf;
491   mapping (address => mapping (address => uint)) public allowance;
492 
493   string public name;
494   string public symbol;
495   uint8 public immutable decimals;
496   uint public totalSupply;
497 
498   constructor(
499     string memory _name,
500     string memory _symbol,
501     uint8 _decimals
502   ) {
503     name = _name;
504     symbol = _symbol;
505     decimals = _decimals;
506     require(_decimals > 0, "decimals");
507   }
508 
509   function transfer(address _recipient, uint _amount) external returns (bool) {
510     _transfer(msg.sender, _recipient, _amount);
511     return true;
512   }
513 
514   function approve(address _spender, uint _amount) external returns (bool) {
515     _approve(msg.sender, _spender, _amount);
516     return true;
517   }
518 
519   function transferFrom(address _sender, address _recipient, uint _amount) external returns (bool) {
520     require(allowance[_sender][msg.sender] >= _amount, "ERC20: insufficient approval");
521     _transfer(_sender, _recipient, _amount);
522     _approve(_sender, msg.sender, allowance[_sender][msg.sender] - _amount);
523     return true;
524   }
525 
526   function mint(address _account, uint _amount) external onlyOwner {
527     _mint(_account, _amount);
528   }
529 
530   function burn(address _account, uint _amount) external onlyOwner {
531     _burn(_account, _amount);
532   }
533 
534   function _transfer(address _sender, address _recipient, uint _amount) internal {
535     require(_sender != address(0), "ERC20: transfer from the zero address");
536     require(_recipient != address(0), "ERC20: transfer to the zero address");
537     require(balanceOf[_sender] >= _amount, "ERC20: insufficient funds");
538 
539     balanceOf[_sender] -= _amount;
540     balanceOf[_recipient] += _amount;
541     emit Transfer(_sender, _recipient, _amount);
542   }
543 
544   function _mint(address _account, uint _amount) internal {
545     require(_account != address(0), "ERC20: mint to the zero address");
546 
547     totalSupply += _amount;
548     balanceOf[_account] += _amount;
549     emit Transfer(address(0), _account, _amount);
550   }
551 
552   function _burn(address _account, uint _amount) internal {
553     require(_account != address(0), "ERC20: burn from the zero address");
554 
555     balanceOf[_account] -= _amount;
556     totalSupply -= _amount;
557     emit Transfer(_account, address(0), _amount);
558   }
559 
560   function _approve(address _owner, address _spender, uint _amount) internal {
561     require(_owner != address(0), "ERC20: approve from the zero address");
562     require(_spender != address(0), "ERC20: approve to the zero address");
563 
564     allowance[_owner][_spender] = _amount;
565     emit Approval(_owner, _spender, _amount);
566   }
567 }
568 
569 contract ReentrancyGuard {
570   uint256 private constant _NOT_ENTERED = 1;
571   uint256 private constant _ENTERED = 2;
572 
573   uint256 private _status;
574 
575   constructor () {
576     _status = _NOT_ENTERED;
577   }
578 
579   modifier nonReentrant() {
580     require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
581     _status = _ENTERED;
582     _;
583     _status = _NOT_ENTERED;
584   }
585 }
586 
587 contract TransferHelper {
588 
589   using SafeERC20 for IERC20;
590 
591   // Mainnet
592   IWETH internal constant WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
593 
594   // Kovan
595   // IWETH internal constant WETH = IWETH(0xd0A1E359811322d97991E03f863a0C30C2cF029C);
596 
597   function _safeTransferFrom(address _token, address _sender, uint _amount) internal virtual {
598     require(_amount > 0, "TransferHelper: amount must be > 0");
599     IERC20(_token).safeTransferFrom(_sender, address(this), _amount);
600   }
601 
602   function _safeTransfer(address _token, address _recipient, uint _amount) internal virtual {
603     require(_amount > 0, "TransferHelper: amount must be > 0");
604     IERC20(_token).safeTransfer(_recipient, _amount);
605   }
606 
607   function _wethWithdrawTo(address _to, uint _amount) internal virtual {
608     require(_amount > 0, "TransferHelper: amount must be > 0");
609     require(_to != address(0), "TransferHelper: invalid recipient");
610 
611     WETH.withdraw(_amount);
612     (bool success, ) = _to.call { value: _amount }(new bytes(0));
613     require(success, 'TransferHelper: ETH transfer failed');
614   }
615 
616   function _depositWeth() internal {
617     require(msg.value > 0, "TransferHelper: amount must be > 0");
618     WETH.deposit { value: msg.value }();
619   }
620 }
621 
622 contract LendingPair is TransferHelper, ReentrancyGuard {
623 
624   // Prevents division by zero and other undesirable behaviour
625   uint private constant MIN_RESERVE = 1000;
626 
627   using Address for address;
628   using Clones for address;
629 
630   mapping (address => mapping (address => uint)) public debtOf;
631   mapping (address => mapping (address => uint)) public accountInterestSnapshot;
632   mapping (address => uint) public cumulativeInterestRate; // 100e18 = 100%
633   mapping (address => uint) public totalDebt;
634   mapping (address => IERC20) public lpToken;
635 
636   IController public controller;
637   address public tokenA;
638   address public tokenB;
639   uint public lastBlockAccrued;
640 
641   event Liquidation(
642     address indexed account,
643     address indexed repayToken,
644     address indexed supplyToken,
645     uint repayAmount,
646     uint supplyAmount
647   );
648 
649   event Deposit(address indexed account, address indexed token, uint amount);
650   event Withdraw(address indexed token, uint amount);
651   event Borrow(address indexed token, uint amount);
652   event Repay(address indexed account, address indexed token, uint amount);
653 
654   receive() external payable {}
655 
656   function initialize(
657     address _lpTokenMaster,
658     address _controller,
659     IERC20 _tokenA,
660     IERC20 _tokenB
661   ) external {
662     require(address(tokenA) == address(0), "LendingPair: already initialized");
663     require(address(_tokenA) != address(0) && address(_tokenB) != address(0), "LendingPair: cannot be ZERO address");
664 
665     controller = IController(_controller);
666     tokenA = address(_tokenA);
667     tokenB = address(_tokenB);
668     lastBlockAccrued = block.number;
669 
670     lpToken[tokenA] = _createLpToken(_lpTokenMaster);
671     lpToken[tokenB] = _createLpToken(_lpTokenMaster);
672   }
673 
674   function depositRepay(address _account, address _token, uint _amount) external nonReentrant {
675     _validateToken(_token);
676     accrueAccount(_account);
677 
678     _depositRepay(_account, _token, _amount);
679     _safeTransferFrom(_token, msg.sender, _amount);
680   }
681 
682   function depositRepayETH(address _account) external payable nonReentrant {
683     _validateToken(address(WETH));
684     accrueAccount(_account);
685 
686     _depositRepay(_account, address(WETH), msg.value);
687     _depositWeth();
688   }
689 
690   function deposit(address _account, address _token, uint _amount) external nonReentrant {
691     _validateToken(_token);
692     accrueAccount(_account);
693 
694     _deposit(_account, _token, _amount);
695     _safeTransferFrom(_token, msg.sender, _amount);
696   }
697 
698   function withdrawBorrow(address _token, uint _amount) external nonReentrant {
699     _validateToken(_token);
700     accrueAccount(msg.sender);
701 
702     _withdrawBorrow(_token, _amount);
703     _safeTransfer(_token, msg.sender, _amount);
704   }
705 
706   function withdrawBorrowETH(uint _amount) external nonReentrant {
707     _validateToken(address(WETH));
708     accrueAccount(msg.sender);
709 
710     _withdrawBorrow(address(WETH), _amount);
711     _wethWithdrawTo(msg.sender, _amount);
712   }
713 
714   function withdraw(address _token, uint _amount) external nonReentrant {
715     _validateToken(_token);
716     accrueAccount(msg.sender);
717 
718     _withdraw(_token, _amount);
719     _safeTransfer(_token, msg.sender, _amount);
720   }
721 
722   function withdrawAll(address _token) external nonReentrant {
723     _validateToken(_token);
724     accrueAccount(msg.sender);
725 
726     uint amount = lpToken[_token].balanceOf(msg.sender);
727     _withdraw(_token, amount);
728     _safeTransfer(_token, msg.sender, amount);
729   }
730 
731   function withdrawAllETH() external nonReentrant {
732     _validateToken(address(WETH));
733     accrueAccount(msg.sender);
734 
735     uint amount = lpToken[address(WETH)].balanceOf(msg.sender);
736     _withdraw(address(WETH), amount);
737     _wethWithdrawTo(msg.sender, amount);
738   }
739 
740   function borrow(address _token, uint _amount) external nonReentrant {
741     _validateToken(_token);
742     accrueAccount(msg.sender);
743 
744     _borrow(_token, _amount);
745     _safeTransfer(_token, msg.sender, _amount);
746   }
747 
748   function repayAll(address _account, address _token) external nonReentrant {
749     _validateToken(_token);
750     _requireAccountNotAccrued(_token, _account);
751     accrueAccount(_account);
752 
753     uint amount = debtOf[_token][_account];
754     _repay(_account, _token, amount);
755     _safeTransferFrom(_token, msg.sender, amount);
756   }
757 
758   function repayAllETH(address _account) external payable nonReentrant {
759     _validateToken(address(WETH));
760     _requireAccountNotAccrued(address(WETH), _account);
761     accrueAccount(_account);
762 
763     uint amount = debtOf[address(WETH)][_account];
764     require(msg.value >= amount, "LendingPair: insufficient ETH deposit");
765 
766     _depositWeth();
767     _repay(_account, address(WETH), amount);
768     uint refundAmount = msg.value > amount ? (msg.value - amount) : 0;
769 
770     if (refundAmount > 0) {
771       _wethWithdrawTo(msg.sender, refundAmount);
772     }
773   }
774 
775   function repay(address _account, address _token, uint _amount) external nonReentrant {
776     _validateToken(_token);
777     accrueAccount(_account);
778 
779     _repay(_account, _token, _amount);
780     _safeTransferFrom(_token, msg.sender, _amount);
781   }
782 
783   function accrue() public {
784     if (lastBlockAccrued < block.number) {
785       _accrueInterest(tokenA);
786       _accrueInterest(tokenB);
787       lastBlockAccrued = block.number;
788     }
789   }
790 
791   function accrueAccount(address _account) public {
792     _distributeReward(_account);
793     accrue();
794     _accrueAccountInterest(_account);
795 
796     if (_account != feeRecipient()) {
797       _accrueAccountInterest(feeRecipient());
798     }
799   }
800 
801   // Sell collateral to reduce debt and increase accountHealth
802   // Set _repayAmount to uint(-1) to repay all debt, inc. pending interest
803   function liquidateAccount(
804     address _account,
805     address _repayToken,
806     uint    _repayAmount,
807     uint    _minSupplyOutput
808   ) external nonReentrant {
809 
810     // Input validation and adjustments
811 
812     _validateToken(_repayToken);
813     address supplyToken = _repayToken == tokenA ? tokenB : tokenA;
814 
815     // Check account is underwater after interest
816 
817     accrueAccount(_account);
818     uint health = accountHealth(_account);
819     require(health < controller.LIQ_MIN_HEALTH(), "LendingPair: account health < LIQ_MIN_HEALTH");
820 
821     // Calculate balance adjustments
822 
823     _repayAmount = Math.min(_repayAmount, debtOf[_repayToken][_account]);
824 
825     uint supplyDebt   = _convertTokenValues(_repayToken, supplyToken, _repayAmount);
826     uint callerFee    = supplyDebt * controller.liqFeeCaller(_repayToken) / 100e18;
827     uint systemFee    = supplyDebt * controller.liqFeeSystem(_repayToken) / 100e18;
828     uint supplyBurn   = supplyDebt + callerFee + systemFee;
829     uint supplyOutput = supplyDebt + callerFee;
830 
831     require(supplyOutput >= _minSupplyOutput, "LendingPair: supplyOutput >= _minSupplyOutput");
832 
833     // Adjust balances
834 
835     _burnSupply(supplyToken, _account, supplyBurn);
836     _mintSupply(supplyToken, feeRecipient(), systemFee);
837     _burnDebt(_repayToken, _account, _repayAmount);
838 
839     // Settle token transfers
840 
841     _safeTransferFrom(_repayToken, msg.sender, _repayAmount);
842     _mintSupply(supplyToken, msg.sender, supplyOutput);
843 
844     emit Liquidation(_account, _repayToken, supplyToken, _repayAmount, supplyOutput);
845   }
846 
847   function accountHealth(address _account) public view returns(uint) {
848 
849     if (debtOf[tokenA][_account] == 0 && debtOf[tokenB][_account] == 0) {
850       return controller.LIQ_MIN_HEALTH();
851     }
852 
853     uint totalAccountSupply  = _supplyCredit(_account, tokenA, tokenA)  + _supplyCredit(_account, tokenB, tokenA);
854     uint totalAccountBorrow = _borrowBalance(_account, tokenA, tokenA) + _borrowBalance(_account, tokenB, tokenA);
855 
856     return totalAccountSupply * 1e18 / totalAccountBorrow;
857   }
858 
859   // Get borow balance converted to the units of _returnToken
860   function borrowBalance(
861     address _account,
862     address _borrowedToken,
863     address _returnToken
864   ) external view returns(uint) {
865 
866     _validateToken(_borrowedToken);
867     _validateToken(_returnToken);
868 
869     return _borrowBalance(_account, _borrowedToken, _returnToken);
870   }
871 
872   function supplyBalance(
873     address _account,
874     address _suppliedToken,
875     address _returnToken
876   ) external view returns(uint) {
877 
878     _validateToken(_suppliedToken);
879     _validateToken(_returnToken);
880 
881     return _supplyBalance(_account, _suppliedToken, _returnToken);
882   }
883 
884   function supplyRatePerBlock(address _token) external view returns(uint) {
885     _validateToken(_token);
886     return controller.interestRateModel().supplyRatePerBlock(ILendingPair(address(this)), _token);
887   }
888 
889   function borrowRatePerBlock(address _token) external view returns(uint) {
890     _validateToken(_token);
891     return _borrowRatePerBlock(_token);
892   }
893 
894   function pendingSupplyInterest(address _token, address _account) external view returns(uint) {
895     _validateToken(_token);
896     uint newInterest = _newInterest(lpToken[_token].balanceOf(_account), _token, _account);
897     return newInterest * _lpRate(_token) / 100e18;
898   }
899 
900   function pendingBorrowInterest(address _token, address _account) external view returns(uint) {
901     _validateToken(_token);
902     return _pendingBorrowInterest(_token, _account);
903   }
904 
905   function feeRecipient() public view returns(address) {
906     return controller.feeRecipient();
907   }
908 
909   function checkAccountHealth(address _account) public view  {
910     uint health = accountHealth(_account);
911     require(health >= controller.LIQ_MIN_HEALTH(), "LendingPair: insufficient accountHealth");
912   }
913 
914   function convertTokenValues(
915     address _fromToken,
916     address _toToken,
917     uint    _inputAmount
918   ) external view returns(uint) {
919 
920     _validateToken(_fromToken);
921     _validateToken(_toToken);
922 
923     return _convertTokenValues(_fromToken, _toToken, _inputAmount);
924   }
925 
926   function _depositRepay(address _account, address _token, uint _amount) internal {
927 
928     uint debt = debtOf[_token][_account];
929     uint repayAmount = debt > _amount ? _amount : debt;
930 
931     if (repayAmount > 0) {
932       _repay(_account, _token, repayAmount);
933     }
934 
935     uint depositAmount = _amount - repayAmount;
936 
937     if (depositAmount > 0) {
938       _deposit(_account, _token, depositAmount);
939     }
940   }
941 
942   function _withdrawBorrow(address _token, uint _amount) internal {
943 
944     uint supplyAmount = lpToken[_token].balanceOf(msg.sender);
945     uint withdrawAmount = supplyAmount > _amount ? _amount : supplyAmount;
946 
947     if (withdrawAmount > 0) {
948       _withdraw(_token, withdrawAmount);
949     }
950 
951     uint borrowAmount = _amount - withdrawAmount;
952 
953     if (borrowAmount > 0) {
954       _borrow(_token, borrowAmount);
955     }
956   }
957 
958   function _distributeReward(address _account) internal {
959     IRewardDistribution rewardDistribution = controller.rewardDistribution();
960 
961     if (
962       address(rewardDistribution) != address(0) &&
963       _account != feeRecipient()
964     ) {
965       rewardDistribution.distributeReward(_account, tokenA);
966       rewardDistribution.distributeReward(_account, tokenB);
967     }
968   }
969 
970   function _mintSupply(address _token, address _account, uint _amount) internal {
971     if (_amount > 0) {
972       lpToken[_token].mint(_account, _amount);
973     }
974   }
975 
976   function _burnSupply(address _token, address _account, uint _amount) internal {
977     if (_amount > 0) {
978       lpToken[_token].burn(_account, _amount);
979     }
980   }
981 
982   function _mintDebt(address _token, address _account, uint _amount) internal {
983     debtOf[_token][_account] += _amount;
984     totalDebt[_token] += _amount;
985   }
986 
987   // Origination fee is earned entirely by the protocol and is not split with the LPs
988   // The goal is to prevent free flash loans
989   function _mintDebtWithOriginFee(address _token, address _account, uint _amount) internal {
990     uint originFee = _originationFee(_token, _amount);
991     _mintSupply(_token, feeRecipient(), originFee);
992     _mintDebt(_token, _account, _amount + originFee);
993   }
994 
995   function _burnDebt(address _token, address _account, uint _amount) internal {
996     debtOf[_token][_account] -= _amount;
997     totalDebt[_token] -= _amount;
998   }
999 
1000   function _accrueAccountInterest(address _account) internal {
1001     uint lpBalanceA = lpToken[tokenA].balanceOf(_account);
1002     uint lpBalanceB = lpToken[tokenB].balanceOf(_account);
1003 
1004     _accrueAccountSupply(tokenA, lpBalanceA, _account);
1005     _accrueAccountSupply(tokenB, lpBalanceB, _account);
1006     _accrueAccountDebt(tokenA, _account);
1007     _accrueAccountDebt(tokenB, _account);
1008 
1009     accountInterestSnapshot[tokenA][_account] = cumulativeInterestRate[tokenA];
1010     accountInterestSnapshot[tokenB][_account] = cumulativeInterestRate[tokenB];
1011   }
1012 
1013   function _accrueAccountSupply(address _token, uint _amount, address _account) internal {
1014     if (_amount > 0) {
1015       uint supplyInterest   = _newInterest(_amount, _token, _account);
1016       uint newSupplyAccount = supplyInterest * _lpRate(_token) / 100e18;
1017       uint newSupplySystem  = supplyInterest * _systemRate(_token) / 100e18;
1018 
1019       _mintSupply(_token, _account, newSupplyAccount);
1020       _mintSupply(_token, feeRecipient(), newSupplySystem);
1021     }
1022   }
1023 
1024   function _accrueAccountDebt(address _token, address _account) internal {
1025     if (debtOf[_token][_account] > 0) {
1026       uint newDebt = _pendingBorrowInterest(_token, _account);
1027       _mintDebt(_token, _account, newDebt);
1028     }
1029   }
1030 
1031   function _withdraw(address _token, uint _amount) internal {
1032 
1033     lpToken[_token].burn(msg.sender, _amount);
1034 
1035     checkAccountHealth(msg.sender);
1036 
1037     emit Withdraw(_token, _amount);
1038   }
1039 
1040   function _borrow(address _token, uint _amount) internal {
1041 
1042     require(lpToken[_token].balanceOf(msg.sender) == 0, "LendingPair: cannot borrow supplied token");
1043 
1044     _mintDebtWithOriginFee(_token, msg.sender, _amount);
1045 
1046     _checkBorrowLimits(_token, msg.sender);
1047     checkAccountHealth(msg.sender);
1048 
1049     emit Borrow(_token, _amount);
1050   }
1051 
1052   function _repay(address _account, address _token, uint _amount) internal {
1053     _burnDebt(_token, _account, _amount);
1054     emit Repay(_account, _token, _amount);
1055   }
1056 
1057   function _deposit(address _account, address _token, uint _amount) internal {
1058 
1059     _checkOracleSupport(tokenA);
1060     _checkOracleSupport(tokenB);
1061 
1062     require(debtOf[_token][_account] == 0, "LendingPair: cannot deposit borrowed token");
1063 
1064     _mintSupply(_token, _account, _amount);
1065     _checkDepositLimit(_token);
1066 
1067     emit Deposit(_account, _token, _amount);
1068   }
1069 
1070   function _accrueInterest(address _token) internal {
1071     cumulativeInterestRate[_token] += _pendingInterestRate(_token);
1072   }
1073 
1074   function _pendingInterestRate(address _token) internal view returns(uint) {
1075     uint blocksElapsed = block.number - lastBlockAccrued;
1076     return _borrowRatePerBlock(_token) * blocksElapsed;
1077   }
1078 
1079   function _createLpToken(address _lpTokenMaster) internal returns(IERC20) {
1080     ILPTokenMaster newLPToken = ILPTokenMaster(_lpTokenMaster.clone());
1081     newLPToken.initialize();
1082     return IERC20(newLPToken);
1083   }
1084 
1085   function _safeTransfer(address _token, address _recipient, uint _amount) internal override {
1086     TransferHelper._safeTransfer(_token, _recipient, _amount);
1087     _checkMinReserve(address(_token));
1088   }
1089 
1090   function _wethWithdrawTo(address _to, uint _amount) internal override {
1091     TransferHelper._wethWithdrawTo(_to, _amount);
1092     _checkMinReserve(address(WETH));
1093   }
1094 
1095   function _borrowRatePerBlock(address _token) internal view returns(uint) {
1096     return controller.interestRateModel().borrowRatePerBlock(ILendingPair(address(this)), _token);
1097   }
1098 
1099   function _pendingBorrowInterest(address _token, address _account) internal view returns(uint) {
1100     return _newInterest(debtOf[_token][_account], _token, _account);
1101   }
1102 
1103   function _borrowBalance(
1104     address _account,
1105     address _borrowedToken,
1106     address _returnToken
1107   ) internal view returns(uint) {
1108 
1109     return _convertTokenValues(_borrowedToken, _returnToken, debtOf[_borrowedToken][_account]);
1110   }
1111 
1112   // Get supply balance converted to the units of _returnToken
1113   function _supplyBalance(
1114     address _account,
1115     address _suppliedToken,
1116     address _returnToken
1117   ) internal view returns(uint) {
1118 
1119     return _convertTokenValues(_suppliedToken, _returnToken, lpToken[_suppliedToken].balanceOf(_account));
1120   }
1121 
1122   function _supplyCredit(
1123     address _account,
1124     address _suppliedToken,
1125     address _returnToken
1126   ) internal view returns(uint) {
1127 
1128     return _supplyBalance(_account, _suppliedToken, _returnToken) * controller.colFactor(_suppliedToken) / 100e18;
1129   }
1130 
1131   function _convertTokenValues(
1132     address _fromToken,
1133     address _toToken,
1134     uint    _inputAmount
1135   ) internal view returns(uint) {
1136 
1137     uint priceFrom = controller.tokenPrice(_fromToken) * 1e18 / 10 ** IERC20(_fromToken).decimals();
1138     uint priceTo   = controller.tokenPrice(_toToken)   * 1e18 / 10 ** IERC20(_toToken).decimals();
1139 
1140     return _inputAmount * priceFrom / priceTo;
1141   }
1142 
1143   function _validateToken(address _token) internal view {
1144     require(_token == tokenA || _token == tokenB, "LendingPair: invalid token");
1145   }
1146 
1147   function _checkOracleSupport(address _token) internal view {
1148     require(controller.tokenSupported(_token), "LendingPair: token not supported");
1149   }
1150 
1151   function _checkMinReserve(address _token) internal view {
1152     require(IERC20(_token).balanceOf(address(this)) >= MIN_RESERVE, "LendingPair: below MIN_RESERVE");
1153   }
1154 
1155   function _checkDepositLimit(address _token) internal view {
1156     require(controller.depositsEnabled(), "LendingPair: deposits disabled");
1157 
1158     uint depositLimit = controller.depositLimit(address(this), _token);
1159 
1160     if (depositLimit > 0) {
1161       require((lpToken[_token].totalSupply()) <= depositLimit, "LendingPair: deposit limit reached");
1162     }
1163   }
1164 
1165   function _checkBorrowLimits(address _token, address _account) internal view {
1166     require(controller.borrowingEnabled(), "LendingPair: borrowing disabled");
1167 
1168     uint accountBorrowUSD = debtOf[_token][_account] * controller.tokenPrice(_token) / 1e18;
1169     require(accountBorrowUSD >= controller.minBorrowUSD(), "LendingPair: borrow amount below minimum");
1170 
1171     uint borrowLimit = controller.borrowLimit(address(this), _token);
1172 
1173     if (borrowLimit > 0) {
1174       require(totalDebt[_token] <= borrowLimit, "LendingPair: borrow limit reached");
1175     }
1176   }
1177 
1178   function _originationFee(address _token, uint _amount) internal view returns(uint) {
1179     return _amount * controller.originFee(_token) / 100e18;
1180   }
1181 
1182   function _systemRate(address _token) internal view returns(uint) {
1183     return controller.interestRateModel().systemRate(ILendingPair(address(this)), _token);
1184   }
1185 
1186   function _lpRate(address _token) internal view returns(uint) {
1187     return 100e18 - _systemRate(_token);
1188   }
1189 
1190   function _newInterest(uint _balance, address _token, address _account) internal view returns(uint) {
1191     uint currentCumulativeRate = cumulativeInterestRate[_token] + _pendingInterestRate(_token);
1192     return _balance * (currentCumulativeRate - accountInterestSnapshot[_token][_account]) / 100e18;
1193   }
1194 
1195   // Used in repayAll and repayAllETH to prevent front-running
1196   // Potential attack:
1197   // Recipient account watches the mempool and takes out a large loan just before someone calls repayAll.
1198   // As a result, paying account would end up paying much more than anticipated
1199   function _requireAccountNotAccrued(address _token, address _account) internal view {
1200     if (lastBlockAccrued == block.number && cumulativeInterestRate[_token] > 0) {
1201       require(
1202         cumulativeInterestRate[_token] > accountInterestSnapshot[_token][_account],
1203         "LendingPair: account already accrued"
1204       );
1205     }
1206   }
1207 }