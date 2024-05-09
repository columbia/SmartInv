1 pragma solidity ^0.6.0; 
2 pragma experimental ABIEncoderV2;
3 
4  abstract contract Manager {
5     function last(address) virtual public returns (uint);
6     function cdpCan(address, uint, address) virtual public view returns (uint);
7     function ilks(uint) virtual public view returns (bytes32);
8     function owns(uint) virtual public view returns (address);
9     function urns(uint) virtual public view returns (address);
10     function vat() virtual public view returns (address);
11     function open(bytes32, address) virtual public returns (uint);
12     function give(uint, address) virtual public;
13     function cdpAllow(uint, address, uint) virtual public;
14     function urnAllow(address, uint) virtual public;
15     function frob(uint, int, int) virtual public;
16     function flux(uint, address, uint) virtual public;
17     function move(uint, address, uint) virtual public;
18     function exit(address, uint, address, uint) virtual public;
19     function quit(uint, address) virtual public;
20     function enter(address, uint) virtual public;
21     function shift(uint, uint) virtual public;
22 }  abstract contract Vat {
23 
24     struct Urn {
25         uint256 ink;   // Locked Collateral  [wad]
26         uint256 art;   // Normalised Debt    [wad]
27     }
28 
29     struct Ilk {
30         uint256 Art;   // Total Normalised Debt     [wad]
31         uint256 rate;  // Accumulated Rates         [ray]
32         uint256 spot;  // Price with Safety Margin  [ray]
33         uint256 line;  // Debt Ceiling              [rad]
34         uint256 dust;  // Urn Debt Floor            [rad]
35     }
36 
37     mapping (bytes32 => mapping (address => Urn )) public urns;
38     mapping (bytes32 => Ilk)                       public ilks;
39     mapping (bytes32 => mapping (address => uint)) public gem;  // [wad]
40 
41     function can(address, address) virtual public view returns (uint);
42     function dai(address) virtual public view returns (uint);
43     function frob(bytes32, address, address, address, int, int) virtual public;
44     function hope(address) virtual public;
45     function move(address, address, uint) virtual public;
46     function fork(bytes32, address, address, int, int) virtual public;
47 }  abstract contract PipInterface {
48     function read() public virtual returns (bytes32);
49 }  abstract contract Spotter {
50     struct Ilk {
51         PipInterface pip;
52         uint256 mat;
53     }
54 
55     mapping (bytes32 => Ilk) public ilks;
56 
57     uint256 public par;
58 
59 }  contract DSMath {
60     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
61         require((z = x + y) >= x);
62     }
63 
64     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
65         require((z = x - y) <= x);
66     }
67 
68     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
69         require(y == 0 || (z = x * y) / y == x);
70     }
71 
72     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
73         return x / y;
74     }
75 
76     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
77         return x <= y ? x : y;
78     }
79 
80     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
81         return x >= y ? x : y;
82     }
83 
84     function imin(int256 x, int256 y) internal pure returns (int256 z) {
85         return x <= y ? x : y;
86     }
87 
88     function imax(int256 x, int256 y) internal pure returns (int256 z) {
89         return x >= y ? x : y;
90     }
91 
92     uint256 constant WAD = 10**18;
93     uint256 constant RAY = 10**27;
94 
95     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
96         z = add(mul(x, y), WAD / 2) / WAD;
97     }
98 
99     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
100         z = add(mul(x, y), RAY / 2) / RAY;
101     }
102 
103     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
104         z = add(mul(x, WAD), y / 2) / y;
105     }
106 
107     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
108         z = add(mul(x, RAY), y / 2) / y;
109     }
110 
111     // This famous algorithm is called "exponentiation by squaring"
112     // and calculates x^n with x as fixed-point and n as regular unsigned.
113     //
114     // It's O(log n), instead of O(n) for naive repeated multiplication.
115     //
116     // These facts are why it works:
117     //
118     //  If n is even, then x^n = (x^2)^(n/2).
119     //  If n is odd,  then x^n = x * x^(n-1),
120     //   and applying the equation for even x gives
121     //    x^n = x * (x^2)^((n-1) / 2).
122     //
123     //  Also, EVM division is flooring and
124     //    floor[(n-1) / 2] = floor[n / 2].
125     //
126     function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
127         z = n % 2 != 0 ? x : RAY;
128 
129         for (n /= 2; n != 0; n /= 2) {
130             x = rmul(x, x);
131 
132             if (n % 2 != 0) {
133                 z = rmul(z, x);
134             }
135         }
136     }
137 }  interface ERC20 {
138     function totalSupply() external view returns (uint256 supply);
139 
140     function balanceOf(address _owner) external view returns (uint256 balance);
141 
142     function transfer(address _to, uint256 _value) external returns (bool success);
143 
144     function transferFrom(address _from, address _to, uint256 _value)
145         external
146         returns (bool success);
147 
148     function approve(address _spender, uint256 _value) external returns (bool success);
149 
150     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
151 
152     function decimals() external view returns (uint256 digits);
153 
154     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
155 }  library Address {
156     function isContract(address account) internal view returns (bool) {
157         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
158         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
159         // for accounts without code, i.e. `keccak256('')`
160         bytes32 codehash;
161         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
162         // solhint-disable-next-line no-inline-assembly
163         assembly { codehash := extcodehash(account) }
164         return (codehash != accountHash && codehash != 0x0);
165     }
166 
167     function sendValue(address payable recipient, uint256 amount) internal {
168         require(address(this).balance >= amount, "Address: insufficient balance");
169 
170         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
171         (bool success, ) = recipient.call{ value: amount }("");
172         require(success, "Address: unable to send value, recipient may have reverted");
173     }
174 
175     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
176       return functionCall(target, data, "Address: low-level call failed");
177     }
178 
179     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
180         return _functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
185     }
186 
187     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
188         require(address(this).balance >= value, "Address: insufficient balance for call");
189         return _functionCallWithValue(target, data, value, errorMessage);
190     }
191 
192     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
193         require(isContract(target), "Address: call to non-contract");
194 
195         // solhint-disable-next-line avoid-low-level-calls
196         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
197         if (success) {
198             return returndata;
199         } else {
200             // Look for revert reason and bubble it up if present
201             if (returndata.length > 0) {
202                 // The easiest way to bubble the revert reason is using memory via assembly
203 
204                 // solhint-disable-next-line no-inline-assembly
205                 assembly {
206                     let returndata_size := mload(returndata)
207                     revert(add(32, returndata), returndata_size)
208                 }
209             } else {
210                 revert(errorMessage);
211             }
212         }
213     }
214 }  library SafeMath {
215     function add(uint256 a, uint256 b) internal pure returns (uint256) {
216         uint256 c = a + b;
217         require(c >= a, "SafeMath: addition overflow");
218 
219         return c;
220     }
221 
222     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223         return sub(a, b, "SafeMath: subtraction overflow");
224     }
225 
226     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b <= a, errorMessage);
228         uint256 c = a - b;
229 
230         return c;
231     }
232 
233     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
234         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
235         // benefit is lost if 'b' is also tested.
236         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
237         if (a == 0) {
238             return 0;
239         }
240 
241         uint256 c = a * b;
242         require(c / a == b, "SafeMath: multiplication overflow");
243 
244         return c;
245     }
246 
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         return div(a, b, "SafeMath: division by zero");
249     }
250 
251     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b > 0, errorMessage);
253         uint256 c = a / b;
254         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
255 
256         return c;
257     }
258 
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         return mod(a, b, "SafeMath: modulo by zero");
261     }
262 
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }  library SafeERC20 {
268     using SafeMath for uint256;
269     using Address for address;
270 
271     function safeTransfer(ERC20 token, address to, uint256 value) internal {
272         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
273     }
274 
275     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
276         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
277     }
278 
279     /**
280      * @dev Deprecated. This function has issues similar to the ones found in
281      * {IERC20-approve}, and its usage is discouraged.
282      */
283     function safeApprove(ERC20 token, address spender, uint256 value) internal {
284         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
285         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
286     }
287 
288     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
289         uint256 newAllowance = token.allowance(address(this), spender).add(value);
290         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
291     }
292 
293     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
294         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
295         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
296     }
297 
298     function _callOptionalReturn(ERC20 token, bytes memory data) private {
299 
300         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
301         if (returndata.length > 0) { // Return data is optional
302             // solhint-disable-next-line max-line-length
303             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
304         }
305     }
306 }  contract AdminAuth {
307 
308     using SafeERC20 for ERC20;
309 
310     address public owner;
311     address public admin;
312 
313     modifier onlyOwner() {
314         require(owner == msg.sender);
315         _;
316     }
317 
318     modifier onlyAdmin() {
319         require(admin == msg.sender);
320         _;
321     }
322 
323     constructor() public {
324         owner = 0xBc841B0dE0b93205e912CFBBd1D0c160A1ec6F00;
325         admin = 0x25eFA336886C74eA8E282ac466BdCd0199f85BB9;
326     }
327 
328     /// @notice Admin is set by owner first time, after that admin is super role and has permission to change owner
329     /// @param _admin Address of multisig that becomes admin
330     function setAdminByOwner(address _admin) public {
331         require(msg.sender == owner);
332         require(admin == address(0));
333 
334         admin = _admin;
335     }
336 
337     /// @notice Admin is able to set new admin
338     /// @param _admin Address of multisig that becomes new admin
339     function setAdminByAdmin(address _admin) public {
340         require(msg.sender == admin);
341 
342         admin = _admin;
343     }
344 
345     /// @notice Admin is able to change owner
346     /// @param _owner Address of new owner
347     function setOwnerByAdmin(address _owner) public {
348         require(msg.sender == admin);
349 
350         owner = _owner;
351     }
352 
353     /// @notice Destroy the contract
354     function kill() public onlyOwner {
355         selfdestruct(payable(owner));
356     }
357 
358     /// @notice  withdraw stuck funds
359     function withdrawStuckFunds(address _token, uint _amount) public onlyOwner {
360         if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
361             payable(owner).transfer(_amount);
362         } else {
363             ERC20(_token).safeTransfer(owner, _amount);
364         }
365     }
366 }  contract DefisaverLogger {
367     event LogEvent(
368         address indexed contractAddress,
369         address indexed caller,
370         string indexed logName,
371         bytes data
372     );
373 
374     // solhint-disable-next-line func-name-mixedcase
375     function Log(address _contract, address _caller, string memory _logName, bytes memory _data)
376         public
377     {
378         emit LogEvent(_contract, _caller, _logName, _data);
379     }
380 }  contract BotRegistry is AdminAuth {
381 
382     mapping (address => bool) public botList;
383 
384     constructor() public {
385         botList[0x776B4a13093e30B05781F97F6A4565B6aa8BE330] = true;
386 
387         botList[0xAED662abcC4FA3314985E67Ea993CAD064a7F5cF] = true;
388         botList[0xa5d330F6619d6bF892A5B87D80272e1607b3e34D] = true;
389         botList[0x5feB4DeE5150B589a7f567EA7CADa2759794A90A] = true;
390         botList[0x7ca06417c1d6f480d3bB195B80692F95A6B66158] = true;
391     }
392 
393     function setBot(address _botAddr, bool _state) public onlyOwner {
394         botList[_botAddr] = _state;
395     }
396 
397 }  
398 
399 contract DFSExchangeData {
400 
401     // first is empty to keep the legacy order in place
402     enum ExchangeType { _, OASIS, KYBER, UNISWAP, ZEROX }
403 
404     enum ActionType { SELL, BUY }
405 
406     struct OffchainData {
407         address wrapper;
408         address exchangeAddr;
409         address allowanceTarget;
410         uint256 price;
411         uint256 protocolFee;
412         bytes callData;
413     }
414 
415     struct ExchangeData {
416         address srcAddr;
417         address destAddr;
418         uint256 srcAmount;
419         uint256 destAmount;
420         uint256 minPrice;
421         uint256 dfsFeeDivider; // service fee divider
422         address user; // user to check special fee
423         address wrapper;
424         bytes wrapperData;
425         OffchainData offchainData;
426     }
427 
428     function packExchangeData(ExchangeData memory _exData) public pure returns(bytes memory) {
429         return abi.encode(_exData);
430     }
431 
432     function unpackExchangeData(bytes memory _data) public pure returns(ExchangeData memory _exData) {
433         _exData = abi.decode(_data, (ExchangeData));
434     }
435 }  /// @title Implements enum Method
436 abstract contract StaticV2 {
437 
438     enum Method { Boost, Repay }
439 
440     struct CdpHolder {
441         uint128 minRatio;
442         uint128 maxRatio;
443         uint128 optimalRatioBoost;
444         uint128 optimalRatioRepay;
445         address owner;
446         uint cdpId;
447         bool boostEnabled;
448         bool nextPriceEnabled;
449     }
450 
451     struct SubPosition {
452         uint arrPos;
453         bool subscribed;
454     }
455 }    
456 
457 
458 
459 abstract contract ISubscriptionsV2 is StaticV2 {
460 
461     function getOwner(uint _cdpId) external view virtual returns(address);
462     function getSubscribedInfo(uint _cdpId) public view virtual returns(bool, uint128, uint128, uint128, uint128, address, uint coll, uint debt);
463     function getCdpHolder(uint _cdpId) public view virtual returns (bool subscribed, CdpHolder memory);
464 }  abstract contract DSProxyInterface {
465 
466     /// Truffle wont compile if this isn't commented
467     // function execute(bytes memory _code, bytes memory _data)
468     //     public virtual
469     //     payable
470     //     returns (address, bytes32);
471 
472     function execute(address _target, bytes memory _data) public virtual payable returns (bytes32);
473 
474     function setCache(address _cacheAddr) public virtual payable returns (bool);
475 
476     function owner() public virtual returns (address);
477 }  /// @title Implements logic for calling MCDSaverProxy always from same contract
478 contract MCDMonitorProxyV2 is AdminAuth {
479 
480     uint public CHANGE_PERIOD;
481     uint public MIN_CHANGE_PERIOD = 6 * 1 hours;
482     address public monitor;
483     address public newMonitor;
484     address public lastMonitor;
485     uint public changeRequestedTimestamp;
486 
487     event MonitorChangeInitiated(address oldMonitor, address newMonitor);
488     event MonitorChangeCanceled();
489     event MonitorChangeFinished(address monitor);
490     event MonitorChangeReverted(address monitor);
491 
492     modifier onlyMonitor() {
493         require (msg.sender == monitor);
494         _;
495     }
496 
497     constructor(uint _changePeriod) public {
498         CHANGE_PERIOD = _changePeriod * 1 hours;
499     }
500 
501     /// @notice Only monitor contract is able to call execute on users proxy
502     /// @param _owner Address of cdp owner (users DSProxy address)
503     /// @param _saverProxy Address of MCDSaverProxy
504     /// @param _data Data to send to MCDSaverProxy
505     function callExecute(address _owner, address _saverProxy, bytes memory _data) public payable onlyMonitor {
506         // execute reverts if calling specific method fails
507         DSProxyInterface(_owner).execute{value: msg.value}(_saverProxy, _data);
508 
509         // return if anything left
510         if (address(this).balance > 0) {
511             msg.sender.transfer(address(this).balance);
512         }
513     }
514 
515     /// @notice Allowed users are able to set Monitor contract without any waiting period first time
516     /// @param _monitor Address of Monitor contract
517     function setMonitor(address _monitor) public onlyOwner {
518         require(monitor == address(0));
519         monitor = _monitor;
520     }
521 
522     /// @notice Allowed users are able to start procedure for changing monitor
523     /// @dev after CHANGE_PERIOD needs to call confirmNewMonitor to actually make a change
524     /// @param _newMonitor address of new monitor
525     function changeMonitor(address _newMonitor) public onlyOwner {
526         require(changeRequestedTimestamp == 0);
527 
528         changeRequestedTimestamp = now;
529         lastMonitor = monitor;
530         newMonitor = _newMonitor;
531 
532         emit MonitorChangeInitiated(lastMonitor, newMonitor);
533     }
534 
535     /// @notice At any point allowed users are able to cancel monitor change
536     function cancelMonitorChange() public onlyOwner {
537         require(changeRequestedTimestamp > 0);
538 
539         changeRequestedTimestamp = 0;
540         newMonitor = address(0);
541 
542         emit MonitorChangeCanceled();
543     }
544 
545     /// @notice Anyone is able to confirm new monitor after CHANGE_PERIOD if process is started
546     function confirmNewMonitor() public onlyOwner {
547         require((changeRequestedTimestamp + CHANGE_PERIOD) < now);
548         require(changeRequestedTimestamp != 0);
549         require(newMonitor != address(0));
550 
551         monitor = newMonitor;
552         newMonitor = address(0);
553         changeRequestedTimestamp = 0;
554 
555         emit MonitorChangeFinished(monitor);
556     }
557 
558     /// @notice Its possible to revert monitor to last used monitor
559     function revertMonitor() public onlyOwner {
560         require(lastMonitor != address(0));
561 
562         monitor = lastMonitor;
563 
564         emit MonitorChangeReverted(monitor);
565     }
566 
567     function setChangePeriod(uint _periodInHours) public onlyOwner {
568         require(_periodInHours * 1 hours > MIN_CHANGE_PERIOD);
569 
570         CHANGE_PERIOD = _periodInHours * 1 hours;
571     }
572 
573 }    
574 
575 
576 
577 
578 
579 
580 
581 
582 
583 
584 
585 
586 
587 
588 
589 /// @title Implements logic that allows bots to call Boost and Repay
590 contract MCDMonitorV2 is DSMath, AdminAuth, StaticV2 {
591     uint256 public MAX_GAS_PRICE = 800 gwei; // 800 gwei
592 
593     uint256 public REPAY_GAS_COST = 1_000_000;
594     uint256 public BOOST_GAS_COST = 1_000_000;
595 
596     bytes4 public REPAY_SELECTOR = 0xf360ce20; // repayWithLoan(...)
597     bytes4 public BOOST_SELECTOR = 0x8ec2ae25; // boostWithLoan(...)
598 
599     MCDMonitorProxyV2 public monitorProxyContract = MCDMonitorProxyV2(0x1816A86C4DA59395522a42b871bf11A4E96A1C7a);
600     ISubscriptionsV2 public subscriptionsContract = ISubscriptionsV2(0xC45d4f6B6bf41b6EdAA58B01c4298B8d9078269a);
601     address public mcdSaverTakerAddress;
602 
603     address public constant BOT_REGISTRY_ADDRESS = 0x637726f8b08a7ABE3aE3aCaB01A80E2d8ddeF77B;
604     address public constant PROXY_PERMISSION_ADDR = 0x5a4f877CA808Cca3cB7c2A194F80Ab8588FAE26B;
605 
606     Manager public manager = Manager(0x5ef30b9986345249bc32d8928B7ee64DE9435E39);
607     Vat public vat = Vat(0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
608     Spotter public spotter = Spotter(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
609 
610     DefisaverLogger public constant logger =
611         DefisaverLogger(0x5c55B921f590a89C1Ebe84dF170E655a82b62126);
612 
613     modifier onlyApproved() {
614         require(BotRegistry(BOT_REGISTRY_ADDRESS).botList(msg.sender), "Not auth bot");
615         _;
616     }
617 
618     constructor(
619         address _newMcdSaverTakerAddress
620     ) public {
621         mcdSaverTakerAddress = _newMcdSaverTakerAddress;
622     }
623 
624     /// @notice Bots call this method to repay for user when conditions are met
625     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
626     function repayFor(
627         DFSExchangeData.ExchangeData memory _exchangeData,
628         uint256 _cdpId,
629         uint256 _nextPrice,
630         address _joinAddr
631     ) public payable onlyApproved {
632         bool isAllowed;
633         uint256 ratioBefore;
634         string memory errReason;
635 
636         (isAllowed, ratioBefore, errReason) = checkPreconditions(
637             Method.Repay,
638             _cdpId,
639             _nextPrice
640         );
641         require(isAllowed, errReason);
642 
643         uint256 gasCost = calcGasCost(REPAY_GAS_COST);
644 
645         address usersProxy = subscriptionsContract.getOwner(_cdpId);
646 
647         monitorProxyContract.callExecute{value: msg.value}(
648             usersProxy,
649             mcdSaverTakerAddress,
650             abi.encodeWithSelector(REPAY_SELECTOR, _exchangeData, _cdpId, gasCost, _joinAddr, 0)
651         );
652 
653         bool isGoodRatio;
654         uint256 ratioAfter;
655 
656         (isGoodRatio, ratioAfter, errReason) = ratioGoodAfter(
657             Method.Repay,
658             _cdpId,
659             _nextPrice,
660             ratioBefore
661         );
662         require(isGoodRatio, errReason);
663 
664         returnEth();
665 
666         logger.Log(
667             address(this),
668             usersProxy,
669             "AutomaticMCDRepay",
670             abi.encode(ratioBefore, ratioAfter)
671         );
672     }
673 
674     /// @notice Bots call this method to boost for user when conditions are met
675     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
676     function boostFor(
677         DFSExchangeData.ExchangeData memory _exchangeData,
678         uint256 _cdpId,
679         uint256 _nextPrice,
680         address _joinAddr
681     ) public payable onlyApproved {
682         bool isAllowed;
683         uint256 ratioBefore;
684         string memory errReason;
685 
686         (isAllowed, ratioBefore, errReason) = checkPreconditions(
687             Method.Boost,
688             _cdpId,
689             _nextPrice
690         );
691         require(isAllowed, errReason);
692 
693         uint256 gasCost = calcGasCost(BOOST_GAS_COST);
694 
695         address usersProxy = subscriptionsContract.getOwner(_cdpId);
696 
697         monitorProxyContract.callExecute{value: msg.value}(
698             usersProxy,
699             mcdSaverTakerAddress,
700             abi.encodeWithSelector(BOOST_SELECTOR, _exchangeData, _cdpId, gasCost, _joinAddr, 0)
701         );
702 
703         bool isGoodRatio;
704         uint256 ratioAfter;
705 
706         (isGoodRatio, ratioAfter, errReason) = ratioGoodAfter(
707             Method.Boost,
708             _cdpId,
709             _nextPrice,
710             ratioBefore
711         );
712         require(isGoodRatio, errReason);
713 
714         returnEth();
715 
716         logger.Log(
717             address(this),
718             usersProxy,
719             "AutomaticMCDBoost",
720             abi.encode(ratioBefore, ratioAfter)
721         );
722     }
723 
724     /******************* INTERNAL METHODS ********************************/
725     function returnEth() internal {
726         // return if some eth left
727         if (address(this).balance > 0) {
728             msg.sender.transfer(address(this).balance);
729         }
730     }
731 
732     /******************* STATIC METHODS ********************************/
733 
734     /// @notice Returns an address that owns the CDP
735     /// @param _cdpId Id of the CDP
736     function getOwner(uint256 _cdpId) public view returns (address) {
737         return manager.owns(_cdpId);
738     }
739 
740     /// @notice Gets CDP info (collateral, debt)
741     /// @param _cdpId Id of the CDP
742     /// @param _ilk Ilk of the CDP
743     function getCdpInfo(uint256 _cdpId, bytes32 _ilk) public view returns (uint256, uint256) {
744         address urn = manager.urns(_cdpId);
745 
746         (uint256 collateral, uint256 debt) = vat.urns(_ilk, urn);
747         (, uint256 rate, , , ) = vat.ilks(_ilk);
748 
749         return (collateral, rmul(debt, rate));
750     }
751 
752     /// @notice Gets a price of the asset
753     /// @param _ilk Ilk of the CDP
754     function getPrice(bytes32 _ilk) public view returns (uint256) {
755         (, uint256 mat) = spotter.ilks(_ilk);
756         (, , uint256 spot, , ) = vat.ilks(_ilk);
757 
758         return rmul(rmul(spot, spotter.par()), mat);
759     }
760 
761     /// @notice Gets CDP ratio
762     /// @param _cdpId Id of the CDP
763     /// @param _nextPrice Next price for user
764     function getRatio(uint256 _cdpId, uint256 _nextPrice) public view returns (uint256) {
765         bytes32 ilk = manager.ilks(_cdpId);
766         uint256 price = (_nextPrice == 0) ? getPrice(ilk) : _nextPrice;
767 
768         (uint256 collateral, uint256 debt) = getCdpInfo(_cdpId, ilk);
769 
770         if (debt == 0) return 0;
771 
772         return rdiv(wmul(collateral, price), debt) / (10**18);
773     }
774 
775     /// @notice Checks if Boost/Repay could be triggered for the CDP
776     /// @dev Called by MCDMonitor to enforce the min/max check
777     function checkPreconditions(
778         Method _method,
779         uint256 _cdpId,
780         uint256 _nextPrice
781     )
782         public
783         view
784         returns (
785             bool,
786             uint256,
787             string memory
788         )
789     {
790 
791         (bool subscribed, CdpHolder memory holder) = subscriptionsContract.getCdpHolder(_cdpId);
792 
793         // check if cdp is subscribed
794         if (!subscribed) return (false, 0, "Cdp not sub");
795 
796         // check if using next price is allowed
797         if (_nextPrice > 0 && !holder.nextPriceEnabled)
798             return (false, 0, "Next price send but not enabled");
799 
800         // check if boost and boost allowed
801         if (_method == Method.Boost && !holder.boostEnabled)
802             return (false, 0, "Boost not enabled");
803 
804         // check if owner is still owner
805         if (getOwner(_cdpId) != holder.owner) return (false, 0, "EOA not subbed owner");
806 
807         uint256 currRatio = getRatio(_cdpId, _nextPrice);
808 
809         if (_method == Method.Repay) {
810             if (currRatio > holder.minRatio) return (false, 0, "Ratio is bigger than min");
811         } else if (_method == Method.Boost) {
812             if (currRatio < holder.maxRatio) return (false, 0, "Ratio is less than max");
813         }
814 
815         return (true, currRatio, "");
816     }
817 
818     /// @dev After the Boost/Repay check if the ratio doesn't trigger another call
819     function ratioGoodAfter(
820         Method _method,
821         uint256 _cdpId,
822         uint256 _nextPrice,
823         uint256 _beforeRatio
824     )
825         public
826         view
827         returns (
828             bool,
829             uint256,
830             string memory
831         )
832     {
833 
834         (, CdpHolder memory holder) = subscriptionsContract.getCdpHolder(_cdpId);
835         uint256 currRatio = getRatio(_cdpId, _nextPrice);
836 
837         if (_method == Method.Repay) {
838             if (currRatio >= holder.maxRatio)
839                 return (false, currRatio, "Repay increased ratio over max");
840             if (currRatio <= _beforeRatio) return (false, currRatio, "Repay made ratio worse");
841         } else if (_method == Method.Boost) {
842             if (currRatio <= holder.minRatio)
843                 return (false, currRatio, "Boost lowered ratio over min");
844             if (currRatio >= _beforeRatio) return (false, currRatio, "Boost didn't lower ratio");
845         }
846 
847         return (true, currRatio, "");
848     }
849 
850     /// @notice Calculates gas cost (in Eth) of tx
851     /// @dev Gas price is limited to MAX_GAS_PRICE to prevent attack of draining user CDP
852     /// @param _gasAmount Amount of gas used for the tx
853     function calcGasCost(uint256 _gasAmount) public view returns (uint256) {
854         uint256 gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;
855 
856         return mul(gasPrice, _gasAmount);
857     }
858 
859     /******************* OWNER ONLY OPERATIONS ********************************/
860 
861     /// @notice Allows owner to change gas cost for boost operation, but only up to 3 millions
862     /// @param _gasCost New gas cost for boost method
863     function changeBoostGasCost(uint256 _gasCost) public onlyOwner {
864         require(_gasCost < 3_000_000, "Boost gas cost over limit");
865 
866         BOOST_GAS_COST = _gasCost;
867     }
868 
869     /// @notice Allows owner to change gas cost for repay operation, but only up to 3 millions
870     /// @param _gasCost New gas cost for repay method
871     function changeRepayGasCost(uint256 _gasCost) public onlyOwner {
872         require(_gasCost < 3_000_000, "Repay gas cost over limit");
873 
874         REPAY_GAS_COST = _gasCost;
875     }
876 
877     /// @notice Allows owner to change max gas price
878     /// @param _maxGasPrice New max gas price
879     function changeMaxGasPrice(uint256 _maxGasPrice) public onlyOwner {
880         require(_maxGasPrice < 2000 gwei, "Max gas price over the limit");
881 
882         MAX_GAS_PRICE = _maxGasPrice;
883     }
884 }