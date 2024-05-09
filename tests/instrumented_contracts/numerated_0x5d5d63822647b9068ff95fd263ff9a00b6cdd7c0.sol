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
22 } abstract contract Vat {
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
47 } abstract contract PipInterface {
48     function read() public virtual returns (bytes32);
49 } abstract contract Spotter {
50     struct Ilk {
51         PipInterface pip;
52         uint256 mat;
53     }
54 
55     mapping (bytes32 => Ilk) public ilks;
56 
57     uint256 public par;
58 
59 } contract DSMath {
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
137 } interface ERC20 {
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
155 } library Address {
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
214 } library SafeMath {
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
267 } library SafeERC20 {
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
306 } contract AdminAuth {
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
366 } contract DefisaverLogger {
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
380 } contract BotRegistry is AdminAuth {
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
435 } /// @title Implements enum Method
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
464 } abstract contract DSProxyInterface {
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
477 } /// @title Implements logic for calling MCDSaverProxy always from same contract
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
577 /**
578  * @title LendingPoolAddressesProvider contract
579  * @dev Main registry of addresses part of or connected to the protocol, including permissioned roles
580  * - Acting also as factory of proxies and admin of those, so with right to change its implementations
581  * - Owned by the Aave Governance
582  * @author Aave
583  **/
584 interface ILendingPoolAddressesProviderV2 {
585   event LendingPoolUpdated(address indexed newAddress);
586   event ConfigurationAdminUpdated(address indexed newAddress);
587   event EmergencyAdminUpdated(address indexed newAddress);
588   event LendingPoolConfiguratorUpdated(address indexed newAddress);
589   event LendingPoolCollateralManagerUpdated(address indexed newAddress);
590   event PriceOracleUpdated(address indexed newAddress);
591   event LendingRateOracleUpdated(address indexed newAddress);
592   event ProxyCreated(bytes32 id, address indexed newAddress);
593   event AddressSet(bytes32 id, address indexed newAddress, bool hasProxy);
594 
595   function setAddress(bytes32 id, address newAddress) external;
596 
597   function setAddressAsProxy(bytes32 id, address impl) external;
598 
599   function getAddress(bytes32 id) external view returns (address);
600 
601   function getLendingPool() external view returns (address);
602 
603   function setLendingPoolImpl(address pool) external;
604 
605   function getLendingPoolConfigurator() external view returns (address);
606 
607   function setLendingPoolConfiguratorImpl(address configurator) external;
608 
609   function getLendingPoolCollateralManager() external view returns (address);
610 
611   function setLendingPoolCollateralManager(address manager) external;
612 
613   function getPoolAdmin() external view returns (address);
614 
615   function setPoolAdmin(address admin) external;
616 
617   function getEmergencyAdmin() external view returns (address);
618 
619   function setEmergencyAdmin(address admin) external;
620 
621   function getPriceOracle() external view returns (address);
622 
623   function setPriceOracle(address priceOracle) external;
624 
625   function getLendingRateOracle() external view returns (address);
626 
627   function setLendingRateOracle(address lendingRateOracle) external;
628 }
629 
630 library DataTypes {
631   // refer to the whitepaper, section 1.1 basic concepts for a formal description of these properties.
632   struct ReserveData {
633     //stores the reserve configuration
634     ReserveConfigurationMap configuration;
635     //the liquidity index. Expressed in ray
636     uint128 liquidityIndex;
637     //variable borrow index. Expressed in ray
638     uint128 variableBorrowIndex;
639     //the current supply rate. Expressed in ray
640     uint128 currentLiquidityRate;
641     //the current variable borrow rate. Expressed in ray
642     uint128 currentVariableBorrowRate;
643     //the current stable borrow rate. Expressed in ray
644     uint128 currentStableBorrowRate;
645     uint40 lastUpdateTimestamp;
646     //tokens addresses
647     address aTokenAddress;
648     address stableDebtTokenAddress;
649     address variableDebtTokenAddress;
650     //address of the interest rate strategy
651     address interestRateStrategyAddress;
652     //the id of the reserve. Represents the position in the list of the active reserves
653     uint8 id;
654   }
655 
656   struct ReserveConfigurationMap {
657     //bit 0-15: LTV
658     //bit 16-31: Liq. threshold
659     //bit 32-47: Liq. bonus
660     //bit 48-55: Decimals
661     //bit 56: Reserve is active
662     //bit 57: reserve is frozen
663     //bit 58: borrowing is enabled
664     //bit 59: stable rate borrowing enabled
665     //bit 60-63: reserved
666     //bit 64-79: reserve factor
667     uint256 data;
668   }
669 
670   struct UserConfigurationMap {
671     uint256 data;
672   }
673 
674   enum InterestRateMode {NONE, STABLE, VARIABLE}
675 }
676 
677 interface ILendingPoolV2 {
678   /**
679    * @dev Emitted on deposit()
680    * @param reserve The address of the underlying asset of the reserve
681    * @param user The address initiating the deposit
682    * @param onBehalfOf The beneficiary of the deposit, receiving the aTokens
683    * @param amount The amount deposited
684    * @param referral The referral code used
685    **/
686   event Deposit(
687     address indexed reserve,
688     address user,
689     address indexed onBehalfOf,
690     uint256 amount,
691     uint16 indexed referral
692   );
693 
694   /**
695    * @dev Emitted on withdraw()
696    * @param reserve The address of the underlyng asset being withdrawn
697    * @param user The address initiating the withdrawal, owner of aTokens
698    * @param to Address that will receive the underlying
699    * @param amount The amount to be withdrawn
700    **/
701   event Withdraw(address indexed reserve, address indexed user, address indexed to, uint256 amount);
702 
703   /**
704    * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
705    * @param reserve The address of the underlying asset being borrowed
706    * @param user The address of the user initiating the borrow(), receiving the funds on borrow() or just
707    * initiator of the transaction on flashLoan()
708    * @param onBehalfOf The address that will be getting the debt
709    * @param amount The amount borrowed out
710    * @param borrowRateMode The rate mode: 1 for Stable, 2 for Variable
711    * @param borrowRate The numeric rate at which the user has borrowed
712    * @param referral The referral code used
713    **/
714   event Borrow(
715     address indexed reserve,
716     address user,
717     address indexed onBehalfOf,
718     uint256 amount,
719     uint256 borrowRateMode,
720     uint256 borrowRate,
721     uint16 indexed referral
722   );
723 
724   /**
725    * @dev Emitted on repay()
726    * @param reserve The address of the underlying asset of the reserve
727    * @param user The beneficiary of the repayment, getting his debt reduced
728    * @param repayer The address of the user initiating the repay(), providing the funds
729    * @param amount The amount repaid
730    **/
731   event Repay(
732     address indexed reserve,
733     address indexed user,
734     address indexed repayer,
735     uint256 amount
736   );
737 
738   /**
739    * @dev Emitted on swapBorrowRateMode()
740    * @param reserve The address of the underlying asset of the reserve
741    * @param user The address of the user swapping his rate mode
742    * @param rateMode The rate mode that the user wants to swap to
743    **/
744   event Swap(address indexed reserve, address indexed user, uint256 rateMode);
745 
746   /**
747    * @dev Emitted on setUserUseReserveAsCollateral()
748    * @param reserve The address of the underlying asset of the reserve
749    * @param user The address of the user enabling the usage as collateral
750    **/
751   event ReserveUsedAsCollateralEnabled(address indexed reserve, address indexed user);
752 
753   /**
754    * @dev Emitted on setUserUseReserveAsCollateral()
755    * @param reserve The address of the underlying asset of the reserve
756    * @param user The address of the user enabling the usage as collateral
757    **/
758   event ReserveUsedAsCollateralDisabled(address indexed reserve, address indexed user);
759 
760   /**
761    * @dev Emitted on rebalanceStableBorrowRate()
762    * @param reserve The address of the underlying asset of the reserve
763    * @param user The address of the user for which the rebalance has been executed
764    **/
765   event RebalanceStableBorrowRate(address indexed reserve, address indexed user);
766 
767   /**
768    * @dev Emitted on flashLoan()
769    * @param target The address of the flash loan receiver contract
770    * @param initiator The address initiating the flash loan
771    * @param asset The address of the asset being flash borrowed
772    * @param amount The amount flash borrowed
773    * @param premium The fee flash borrowed
774    * @param referralCode The referral code used
775    **/
776   event FlashLoan(
777     address indexed target,
778     address indexed initiator,
779     address indexed asset,
780     uint256 amount,
781     uint256 premium,
782     uint16 referralCode
783   );
784 
785   /**
786    * @dev Emitted when the pause is triggered.
787    */
788   event Paused();
789 
790   /**
791    * @dev Emitted when the pause is lifted.
792    */
793   event Unpaused();
794 
795   /**
796    * @dev Emitted when a borrower is liquidated. This event is emitted by the LendingPool via
797    * LendingPoolCollateral manager using a DELEGATECALL
798    * This allows to have the events in the generated ABI for LendingPool.
799    * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
800    * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
801    * @param user The address of the borrower getting liquidated
802    * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
803    * @param liquidatedCollateralAmount The amount of collateral received by the liiquidator
804    * @param liquidator The address of the liquidator
805    * @param receiveAToken `true` if the liquidators wants to receive the collateral aTokens, `false` if he wants
806    * to receive the underlying collateral asset directly
807    **/
808   event LiquidationCall(
809     address indexed collateralAsset,
810     address indexed debtAsset,
811     address indexed user,
812     uint256 debtToCover,
813     uint256 liquidatedCollateralAmount,
814     address liquidator,
815     bool receiveAToken
816   );
817 
818   /**
819    * @dev Emitted when the state of a reserve is updated. NOTE: This event is actually declared
820    * in the ReserveLogic library and emitted in the updateInterestRates() function. Since the function is internal,
821    * the event will actually be fired by the LendingPool contract. The event is therefore replicated here so it
822    * gets added to the LendingPool ABI
823    * @param reserve The address of the underlying asset of the reserve
824    * @param liquidityRate The new liquidity rate
825    * @param stableBorrowRate The new stable borrow rate
826    * @param variableBorrowRate The new variable borrow rate
827    * @param liquidityIndex The new liquidity index
828    * @param variableBorrowIndex The new variable borrow index
829    **/
830   event ReserveDataUpdated(
831     address indexed reserve,
832     uint256 liquidityRate,
833     uint256 stableBorrowRate,
834     uint256 variableBorrowRate,
835     uint256 liquidityIndex,
836     uint256 variableBorrowIndex
837   );
838 
839   /**
840    * @dev Deposits an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
841    * - E.g. User deposits 100 USDC and gets in return 100 aUSDC
842    * @param asset The address of the underlying asset to deposit
843    * @param amount The amount to be deposited
844    * @param onBehalfOf The address that will receive the aTokens, same as msg.sender if the user
845    *   wants to receive them on his own wallet, or a different address if the beneficiary of aTokens
846    *   is a different wallet
847    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
848    *   0 if the action is executed directly by the user, without any middle-man
849    **/
850   function deposit(
851     address asset,
852     uint256 amount,
853     address onBehalfOf,
854     uint16 referralCode
855   ) external;
856 
857   /**
858    * @dev Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
859    * E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
860    * @param asset The address of the underlying asset to withdraw
861    * @param amount The underlying amount to be withdrawn
862    *   - Send the value type(uint256).max in order to withdraw the whole aToken balance
863    * @param to Address that will receive the underlying, same as msg.sender if the user
864    *   wants to receive it on his own wallet, or a different address if the beneficiary is a
865    *   different wallet
866    **/
867   function withdraw(
868     address asset,
869     uint256 amount,
870     address to
871   ) external;
872 
873   /**
874    * @dev Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
875    * already deposited enough collateral, or he was given enough allowance by a credit delegator on the
876    * corresponding debt token (StableDebtToken or VariableDebtToken)
877    * - E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
878    *   and 100 stable/variable debt tokens, depending on the `interestRateMode`
879    * @param asset The address of the underlying asset to borrow
880    * @param amount The amount to be borrowed
881    * @param interestRateMode The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable
882    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
883    *   0 if the action is executed directly by the user, without any middle-man
884    * @param onBehalfOf Address of the user who will receive the debt. Should be the address of the borrower itself
885    * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
886    * if he has been given credit delegation allowance
887    **/
888   function borrow(
889     address asset,
890     uint256 amount,
891     uint256 interestRateMode,
892     uint16 referralCode,
893     address onBehalfOf
894   ) external;
895 
896   /**
897    * @notice Repays a borrowed `amount` on a specific reserve, burning the equivalent debt tokens owned
898    * - E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address
899    * @param asset The address of the borrowed underlying asset previously borrowed
900    * @param amount The amount to repay
901    * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
902    * @param rateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
903    * @param onBehalfOf Address of the user who will get his debt reduced/removed. Should be the address of the
904    * user calling the function if he wants to reduce/remove his own debt, or the address of any other
905    * other borrower whose debt should be removed
906    **/
907   function repay(
908     address asset,
909     uint256 amount,
910     uint256 rateMode,
911     address onBehalfOf
912   ) external;
913 
914   /**
915    * @dev Allows a borrower to swap his debt between stable and variable mode, or viceversa
916    * @param asset The address of the underlying asset borrowed
917    * @param rateMode The rate mode that the user wants to swap to
918    **/
919   function swapBorrowRateMode(address asset, uint256 rateMode) external;
920 
921   /**
922    * @dev Rebalances the stable interest rate of a user to the current stable rate defined on the reserve.
923    * - Users can be rebalanced if the following conditions are satisfied:
924    *     1. Usage ratio is above 95%
925    *     2. the current deposit APY is below REBALANCE_UP_THRESHOLD * maxVariableBorrowRate, which means that too much has been
926    *        borrowed at a stable rate and depositors are not earning enough
927    * @param asset The address of the underlying asset borrowed
928    * @param user The address of the user to be rebalanced
929    **/
930   function rebalanceStableBorrowRate(address asset, address user) external;
931 
932   /**
933    * @dev Allows depositors to enable/disable a specific deposited asset as collateral
934    * @param asset The address of the underlying asset deposited
935    * @param useAsCollateral `true` if the user wants to use the deposit as collateral, `false` otherwise
936    **/
937   function setUserUseReserveAsCollateral(address asset, bool useAsCollateral) external;
938 
939   /**
940    * @dev Function to liquidate a non-healthy position collateral-wise, with Health Factor below 1
941    * - The caller (liquidator) covers `debtToCover` amount of debt of the user getting liquidated, and receives
942    *   a proportionally amount of the `collateralAsset` plus a bonus to cover market risk
943    * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
944    * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
945    * @param user The address of the borrower getting liquidated
946    * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
947    * @param receiveAToken `true` if the liquidators wants to receive the collateral aTokens, `false` if he wants
948    * to receive the underlying collateral asset directly
949    **/
950   function liquidationCall(
951     address collateralAsset,
952     address debtAsset,
953     address user,
954     uint256 debtToCover,
955     bool receiveAToken
956   ) external;
957 
958   /**
959    * @dev Allows smartcontracts to access the liquidity of the pool within one transaction,
960    * as long as the amount taken plus a fee is returned.
961    * IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept into consideration.
962    * For further details please visit https://developers.aave.com
963    * @param receiverAddress The address of the contract receiving the funds, implementing the IFlashLoanReceiver interface
964    * @param assets The addresses of the assets being flash-borrowed
965    * @param amounts The amounts amounts being flash-borrowed
966    * @param modes Types of the debt to open if the flash loan is not returned:
967    *   0 -> Don't open any debt, just revert if funds can't be transferred from the receiver
968    *   1 -> Open debt at stable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
969    *   2 -> Open debt at variable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
970    * @param onBehalfOf The address  that will receive the debt in the case of using on `modes` 1 or 2
971    * @param params Variadic packed params to pass to the receiver as extra information
972    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
973    *   0 if the action is executed directly by the user, without any middle-man
974    **/
975   function flashLoan(
976     address receiverAddress,
977     address[] calldata assets,
978     uint256[] calldata amounts,
979     uint256[] calldata modes,
980     address onBehalfOf,
981     bytes calldata params,
982     uint16 referralCode
983   ) external;
984 
985   /**
986    * @dev Returns the user account data across all the reserves
987    * @param user The address of the user
988    * @return totalCollateralETH the total collateral in ETH of the user
989    * @return totalDebtETH the total debt in ETH of the user
990    * @return availableBorrowsETH the borrowing power left of the user
991    * @return currentLiquidationThreshold the liquidation threshold of the user
992    * @return ltv the loan to value of the user
993    * @return healthFactor the current health factor of the user
994    **/
995   function getUserAccountData(address user)
996     external
997     view
998     returns (
999       uint256 totalCollateralETH,
1000       uint256 totalDebtETH,
1001       uint256 availableBorrowsETH,
1002       uint256 currentLiquidationThreshold,
1003       uint256 ltv,
1004       uint256 healthFactor
1005     );
1006 
1007   function initReserve(
1008     address reserve,
1009     address aTokenAddress,
1010     address stableDebtAddress,
1011     address variableDebtAddress,
1012     address interestRateStrategyAddress
1013   ) external;
1014 
1015   function setReserveInterestRateStrategyAddress(address reserve, address rateStrategyAddress)
1016     external;
1017 
1018   function setConfiguration(address reserve, uint256 configuration) external;
1019 
1020   /**
1021    * @dev Returns the configuration of the reserve
1022    * @param asset The address of the underlying asset of the reserve
1023    * @return The configuration of the reserve
1024    **/
1025   function getConfiguration(address asset) external view returns (DataTypes.ReserveConfigurationMap memory);
1026 
1027   /**
1028    * @dev Returns the configuration of the user across all the reserves
1029    * @param user The user address
1030    * @return The configuration of the user
1031    **/
1032   function getUserConfiguration(address user) external view returns (DataTypes.UserConfigurationMap memory);
1033 
1034   /**
1035    * @dev Returns the normalized income normalized income of the reserve
1036    * @param asset The address of the underlying asset of the reserve
1037    * @return The reserve's normalized income
1038    */
1039   function getReserveNormalizedIncome(address asset) external view returns (uint256);
1040 
1041   /**
1042    * @dev Returns the normalized variable debt per unit of asset
1043    * @param asset The address of the underlying asset of the reserve
1044    * @return The reserve normalized variable debt
1045    */
1046   function getReserveNormalizedVariableDebt(address asset) external view returns (uint256);
1047 
1048   /**
1049    * @dev Returns the state and configuration of the reserve
1050    * @param asset The address of the underlying asset of the reserve
1051    * @return The state of the reserve
1052    **/
1053   function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);
1054 
1055   function finalizeTransfer(
1056     address asset,
1057     address from,
1058     address to,
1059     uint256 amount,
1060     uint256 balanceFromAfter,
1061     uint256 balanceToBefore
1062   ) external;
1063 
1064   function getReservesList() external view returns (address[] memory);
1065 
1066   function getAddressesProvider() external view returns (ILendingPoolAddressesProviderV2);
1067 
1068   function setPause(bool val) external;
1069 
1070   function paused() external view returns (bool);
1071 } 
1072 
1073 
1074 interface IFlashLoans {
1075     function flashLoan(
1076         address recipient,
1077         address[] memory tokens,
1078         uint256[] memory amounts,
1079         bytes memory userData
1080     ) external;
1081 } 
1082 
1083 
1084 
1085 abstract contract IAaveProtocolDataProviderV2 {
1086 
1087   struct TokenData {
1088     string symbol;
1089     address tokenAddress;
1090   }
1091 
1092   function getAllReservesTokens() external virtual view returns (TokenData[] memory);
1093 
1094   function getAllATokens() external virtual view returns (TokenData[] memory);
1095 
1096   function getReserveConfigurationData(address asset)
1097     external virtual
1098     view
1099     returns (
1100       uint256 decimals,
1101       uint256 ltv,
1102       uint256 liquidationThreshold,
1103       uint256 liquidationBonus,
1104       uint256 reserveFactor,
1105       bool usageAsCollateralEnabled,
1106       bool borrowingEnabled,
1107       bool stableBorrowRateEnabled,
1108       bool isActive,
1109       bool isFrozen
1110     );
1111 
1112   function getReserveData(address asset)
1113     external virtual
1114     view
1115     returns (
1116       uint256 availableLiquidity,
1117       uint256 totalStableDebt,
1118       uint256 totalVariableDebt,
1119       uint256 liquidityRate,
1120       uint256 variableBorrowRate,
1121       uint256 stableBorrowRate,
1122       uint256 averageStableBorrowRate,
1123       uint256 liquidityIndex,
1124       uint256 variableBorrowIndex,
1125       uint40 lastUpdateTimestamp
1126     );
1127 
1128   function getUserReserveData(address asset, address user)
1129     external virtual
1130     view
1131     returns (
1132       uint256 currentATokenBalance,
1133       uint256 currentStableDebt,
1134       uint256 currentVariableDebt,
1135       uint256 principalStableDebt,
1136       uint256 scaledVariableDebt,
1137       uint256 stableBorrowRate,
1138       uint256 liquidityRate,
1139       uint40 stableRateLastUpdated,
1140       bool usageAsCollateralEnabled
1141     );
1142 
1143   function getReserveTokensAddresses(address asset)
1144     external virtual
1145     view
1146     returns (
1147       address aTokenAddress,
1148       address stableDebtTokenAddress,
1149       address variableDebtTokenAddress
1150     );
1151 } /// @title Helper contract for getting AaveV2/Balancer flash loans
1152 contract FLHelper {
1153 
1154     address internal constant AAVE_MARKET_ADDR = 0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5;
1155     address internal constant BALANCER_VAULT_ADDR = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
1156     uint16 internal constant AAVE_REFERRAL_CODE = 64;
1157 
1158     address internal constant WETH_ADDR = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1159     address internal constant ETH_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1160 
1161     enum FLType {
1162         AAVE_V2,
1163         BALANCER,
1164         NO_LOAN
1165     }
1166 
1167     function _getFL(
1168         FLType _flType,
1169         address _tokenAddr,
1170         uint256 _flAmount,
1171         bytes memory _callData,
1172         address _receiverAddr
1173     ) internal {
1174         _tokenAddr = _tokenAddr== ETH_ADDR ? WETH_ADDR: _tokenAddr;
1175 
1176         address[] memory tokens = new address[](1);
1177         tokens[0] = _tokenAddr;
1178 
1179         uint256[] memory amounts = new uint256[](1);
1180         amounts[0] = _flAmount;
1181 
1182         if (_flType == FLType.AAVE_V2) {
1183             address lendingPool = ILendingPoolAddressesProviderV2(AAVE_MARKET_ADDR)
1184                 .getLendingPool();
1185 
1186             uint256[] memory modes = new uint256[](1);
1187             modes[0] = 0;
1188 
1189             ILendingPoolV2(lendingPool).flashLoan(
1190                 _receiverAddr,
1191                 tokens,
1192                 amounts,
1193                 modes,
1194                 address(this),
1195                 _callData,
1196                 AAVE_REFERRAL_CODE
1197             );
1198         } else {
1199             IFlashLoans(BALANCER_VAULT_ADDR).flashLoan(_receiverAddr, tokens, amounts, _callData);
1200         }
1201     }
1202 
1203     function getProtocolLiq(address _tokenAddr, uint256 _desiredAmount) public view returns (FLType flType) {
1204         uint256 flLiquidity = getFLLiquidity(FLType.BALANCER, _tokenAddr);
1205 
1206         if (flLiquidity >= _desiredAmount) return FLType.BALANCER;
1207 
1208         flLiquidity = getFLLiquidity(FLType.AAVE_V2, _tokenAddr);
1209 
1210         if (flLiquidity >= _desiredAmount) return FLType.AAVE_V2;
1211 
1212         return FLType.NO_LOAN;
1213     }
1214 
1215     function getFLLiquidity(FLType _flType, address _tokenAddr) public view returns (uint256 liquidity) {
1216         _tokenAddr = _tokenAddr== ETH_ADDR ? WETH_ADDR: _tokenAddr;
1217 
1218         if (_flType == FLType.AAVE_V2) {
1219             IAaveProtocolDataProviderV2 dataProvider = getDataProvider(AAVE_MARKET_ADDR);
1220             (liquidity, , , , , , , , , ) = dataProvider.getReserveData(_tokenAddr);
1221         } else {
1222             liquidity = ERC20(_tokenAddr).balanceOf(BALANCER_VAULT_ADDR);
1223         }
1224     }
1225 
1226     function getDataProvider(address _market) internal view returns (IAaveProtocolDataProviderV2) {
1227         return
1228             IAaveProtocolDataProviderV2(
1229                 ILendingPoolAddressesProviderV2(_market).getAddress(
1230                     0x0100000000000000000000000000000000000000000000000000000000000000
1231                 )
1232             );
1233     }
1234 
1235 }  
1236 
1237 
1238 
1239 
1240 
1241 
1242 
1243 
1244 
1245 
1246 
1247 
1248 
1249 
1250 /// @title Implements logic that allows bots to call Boost and Repay
1251 contract MCDMonitorV2 is DSMath, AdminAuth, StaticV2 {
1252     uint256 public MAX_GAS_PRICE = 800 gwei; // 800 gwei
1253 
1254     uint256 public REPAY_GAS_COST = 1_000_000;
1255     uint256 public BOOST_GAS_COST = 1_000_000;
1256 
1257     bytes4 public REPAY_SELECTOR = 0xee98485d; // repayWithLoan(...)
1258     bytes4 public BOOST_SELECTOR = 0x63ed7d63; // boostWithLoan(...)
1259 
1260     MCDMonitorProxyV2 public monitorProxyContract = MCDMonitorProxyV2(0x1816A86C4DA59395522a42b871bf11A4E96A1C7a);
1261     ISubscriptionsV2 public subscriptionsContract = ISubscriptionsV2(0xC45d4f6B6bf41b6EdAA58B01c4298B8d9078269a);
1262     address public mcdSaverTakerAddress;
1263     address internal mcdSaverFlashLoan;
1264 
1265     address public constant BOT_REGISTRY_ADDRESS = 0x637726f8b08a7ABE3aE3aCaB01A80E2d8ddeF77B;
1266     address public constant PROXY_PERMISSION_ADDR = 0x5a4f877CA808Cca3cB7c2A194F80Ab8588FAE26B;
1267 
1268     Manager public manager = Manager(0x5ef30b9986345249bc32d8928B7ee64DE9435E39);
1269     Vat public vat = Vat(0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
1270     Spotter public spotter = Spotter(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
1271 
1272     DefisaverLogger public constant logger =
1273         DefisaverLogger(0x5c55B921f590a89C1Ebe84dF170E655a82b62126);
1274 
1275     modifier onlyApproved() {
1276         require(BotRegistry(BOT_REGISTRY_ADDRESS).botList(msg.sender), "Not auth bot");
1277         _;
1278     }
1279 
1280     constructor(
1281         address _newMcdSaverTakerAddress,
1282         address _mcdSaverFlashLoan
1283     ) public {
1284         mcdSaverTakerAddress = _newMcdSaverTakerAddress;
1285         mcdSaverFlashLoan = _mcdSaverFlashLoan;
1286     }
1287 
1288     /// @notice Bots call this method to repay for user when conditions are met
1289     /// @dev If the contract owns gas token it will try and use it for gas price reduction
1290     function repayFor(
1291         DFSExchangeData.ExchangeData memory _exchangeData,
1292         uint256 _cdpId,
1293         uint256 _nextPrice,
1294         address _joinAddr,
1295         FLHelper.FLType _flType
1296     ) public payable onlyApproved {
1297         uint256 ratioBefore;
1298         string memory errReason;
1299 
1300         { // for stack to deep, scope variables not used later on
1301             bool isAllowed;
1302 
1303             (isAllowed, ratioBefore, errReason) = checkPreconditions(
1304                 Method.Repay,
1305                 _cdpId,
1306                 _nextPrice
1307             );
1308             require(isAllowed, errReason);
1309         }
1310 
1311         uint256 gasCost = calcGasCost(REPAY_GAS_COST);
1312 
1313         address usersProxy = subscriptionsContract.getOwner(_cdpId);
1314 
1315         monitorProxyContract.callExecute{value: msg.value}(
1316             usersProxy,
1317             mcdSaverTakerAddress,
1318             abi.encodeWithSelector(REPAY_SELECTOR, _exchangeData, _cdpId, gasCost, _joinAddr, 0, _flType, mcdSaverFlashLoan)
1319         );
1320 
1321         bool isGoodRatio;
1322         uint256 ratioAfter;
1323 
1324         (isGoodRatio, ratioAfter, errReason) = ratioGoodAfter(
1325             Method.Repay,
1326             _cdpId,
1327             _nextPrice,
1328             ratioBefore
1329         );
1330         require(isGoodRatio, errReason);
1331 
1332         returnEth();
1333 
1334         logger.Log(
1335             address(this),
1336             usersProxy,
1337             "AutomaticMCDRepay",
1338             abi.encode(ratioBefore, ratioAfter)
1339         );
1340     }
1341 
1342     /// @notice Bots call this method to boost for user when conditions are met
1343     /// @dev If the contract owns gas token it will try and use it for gas price reduction
1344     function boostFor(
1345         DFSExchangeData.ExchangeData memory _exchangeData,
1346         uint256 _cdpId,
1347         uint256 _nextPrice,
1348         address _joinAddr,
1349         FLHelper.FLType _flType
1350     ) public payable onlyApproved {
1351         uint256 ratioBefore;
1352         string memory errReason;
1353 
1354         { // for stack to deep, scope variables not used alter on
1355             bool isAllowed;
1356 
1357             (isAllowed, ratioBefore, errReason) = checkPreconditions(
1358                 Method.Boost,
1359                 _cdpId,
1360                 _nextPrice
1361             );
1362             require(isAllowed, errReason);
1363         }
1364 
1365         uint256 gasCost = calcGasCost(BOOST_GAS_COST);
1366 
1367         address usersProxy = subscriptionsContract.getOwner(_cdpId);
1368 
1369         monitorProxyContract.callExecute{value: msg.value}(
1370             usersProxy,
1371             mcdSaverTakerAddress,
1372             abi.encodeWithSelector(BOOST_SELECTOR, _exchangeData, _cdpId, gasCost, _joinAddr, 0, _flType, mcdSaverFlashLoan)
1373         );
1374 
1375         bool isGoodRatio;
1376         uint256 ratioAfter;
1377 
1378         (isGoodRatio, ratioAfter, errReason) = ratioGoodAfter(
1379             Method.Boost,
1380             _cdpId,
1381             _nextPrice,
1382             ratioBefore
1383         );
1384         require(isGoodRatio, errReason);
1385 
1386         returnEth();
1387 
1388         logger.Log(
1389             address(this),
1390             usersProxy,
1391             "AutomaticMCDBoost",
1392             abi.encode(ratioBefore, ratioAfter)
1393         );
1394     }
1395 
1396     /******************* INTERNAL METHODS ********************************/
1397     function returnEth() internal {
1398         // return if some eth left
1399         if (address(this).balance > 0) {
1400             msg.sender.transfer(address(this).balance);
1401         }
1402     }
1403 
1404     /******************* STATIC METHODS ********************************/
1405 
1406     /// @notice Returns an address that owns the CDP
1407     /// @param _cdpId Id of the CDP
1408     function getOwner(uint256 _cdpId) public view returns (address) {
1409         return manager.owns(_cdpId);
1410     }
1411 
1412     /// @notice Gets CDP info (collateral, debt)
1413     /// @param _cdpId Id of the CDP
1414     /// @param _ilk Ilk of the CDP
1415     function getCdpInfo(uint256 _cdpId, bytes32 _ilk) public view returns (uint256, uint256) {
1416         address urn = manager.urns(_cdpId);
1417 
1418         (uint256 collateral, uint256 debt) = vat.urns(_ilk, urn);
1419         (, uint256 rate, , , ) = vat.ilks(_ilk);
1420 
1421         return (collateral, rmul(debt, rate));
1422     }
1423 
1424     /// @notice Gets a price of the asset
1425     /// @param _ilk Ilk of the CDP
1426     function getPrice(bytes32 _ilk) public view returns (uint256) {
1427         (, uint256 mat) = spotter.ilks(_ilk);
1428         (, , uint256 spot, , ) = vat.ilks(_ilk);
1429 
1430         return rmul(rmul(spot, spotter.par()), mat);
1431     }
1432 
1433     /// @notice Gets CDP ratio
1434     /// @param _cdpId Id of the CDP
1435     /// @param _nextPrice Next price for user
1436     function getRatio(uint256 _cdpId, uint256 _nextPrice) public view returns (uint256) {
1437         bytes32 ilk = manager.ilks(_cdpId);
1438         uint256 price = (_nextPrice == 0) ? getPrice(ilk) : _nextPrice;
1439 
1440         (uint256 collateral, uint256 debt) = getCdpInfo(_cdpId, ilk);
1441 
1442         if (debt == 0) return 0;
1443 
1444         return rdiv(wmul(collateral, price), debt) / (10**18);
1445     }
1446 
1447     /// @notice Checks if Boost/Repay could be triggered for the CDP
1448     /// @dev Called by MCDMonitor to enforce the min/max check
1449     function checkPreconditions(
1450         Method _method,
1451         uint256 _cdpId,
1452         uint256 _nextPrice
1453     )
1454         public
1455         view
1456         returns (
1457             bool,
1458             uint256,
1459             string memory
1460         )
1461     {
1462 
1463         (bool subscribed, CdpHolder memory holder) = subscriptionsContract.getCdpHolder(_cdpId);
1464 
1465         // check if cdp is subscribed
1466         if (!subscribed) return (false, 0, "Cdp not sub");
1467 
1468         // check if using next price is allowed
1469         if (_nextPrice > 0 && !holder.nextPriceEnabled)
1470             return (false, 0, "Next price send but not enabled");
1471 
1472         // check if boost and boost allowed
1473         if (_method == Method.Boost && !holder.boostEnabled)
1474             return (false, 0, "Boost not enabled");
1475 
1476         // check if owner is still owner
1477         if (getOwner(_cdpId) != holder.owner) return (false, 0, "EOA not subbed owner");
1478 
1479         uint256 currRatio = getRatio(_cdpId, _nextPrice);
1480 
1481         if (_method == Method.Repay) {
1482             if (currRatio > holder.minRatio) return (false, 0, "Ratio is bigger than min");
1483         } else if (_method == Method.Boost) {
1484             if (currRatio < holder.maxRatio) return (false, 0, "Ratio is less than max");
1485         }
1486 
1487         return (true, currRatio, "");
1488     }
1489 
1490     /// @dev After the Boost/Repay check if the ratio doesn't trigger another call
1491     function ratioGoodAfter(
1492         Method _method,
1493         uint256 _cdpId,
1494         uint256 _nextPrice,
1495         uint256 _beforeRatio
1496     )
1497         public
1498         view
1499         returns (
1500             bool,
1501             uint256,
1502             string memory
1503         )
1504     {
1505 
1506         (, CdpHolder memory holder) = subscriptionsContract.getCdpHolder(_cdpId);
1507         uint256 currRatio = getRatio(_cdpId, _nextPrice);
1508 
1509         if (_method == Method.Repay) {
1510             if (currRatio >= holder.maxRatio)
1511                 return (false, currRatio, "Repay increased ratio over max");
1512             if (currRatio <= _beforeRatio) return (false, currRatio, "Repay made ratio worse");
1513         } else if (_method == Method.Boost) {
1514             if (currRatio <= holder.minRatio)
1515                 return (false, currRatio, "Boost lowered ratio over min");
1516             if (currRatio >= _beforeRatio) return (false, currRatio, "Boost didn't lower ratio");
1517         }
1518 
1519         return (true, currRatio, "");
1520     }
1521 
1522     /// @notice Calculates gas cost (in Eth) of tx
1523     /// @dev Gas price is limited to MAX_GAS_PRICE to prevent attack of draining user CDP
1524     /// @param _gasAmount Amount of gas used for the tx
1525     function calcGasCost(uint256 _gasAmount) public view returns (uint256) {
1526         uint256 gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;
1527 
1528         return mul(gasPrice, _gasAmount);
1529     }
1530 
1531     /******************* OWNER ONLY OPERATIONS ********************************/
1532 
1533     /// @notice Allows owner to change gas cost for boost operation, but only up to 3 millions
1534     /// @param _gasCost New gas cost for boost method
1535     function changeBoostGasCost(uint256 _gasCost) public onlyOwner {
1536         require(_gasCost < 3_000_000, "Boost gas cost over limit");
1537 
1538         BOOST_GAS_COST = _gasCost;
1539     }
1540 
1541     /// @notice Allows owner to change gas cost for repay operation, but only up to 3 millions
1542     /// @param _gasCost New gas cost for repay method
1543     function changeRepayGasCost(uint256 _gasCost) public onlyOwner {
1544         require(_gasCost < 3_000_000, "Repay gas cost over limit");
1545 
1546         REPAY_GAS_COST = _gasCost;
1547     }
1548 
1549     /// @notice Allows owner to change max gas price
1550     /// @param _maxGasPrice New max gas price
1551     function changeMaxGasPrice(uint256 _maxGasPrice) public onlyOwner {
1552         require(_maxGasPrice < 2000 gwei, "Max gas price over the limit");
1553 
1554         MAX_GAS_PRICE = _maxGasPrice;
1555     }
1556 }