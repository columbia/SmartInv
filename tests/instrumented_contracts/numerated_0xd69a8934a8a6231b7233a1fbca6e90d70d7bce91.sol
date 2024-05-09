1 pragma solidity ^0.6.0;
2 pragma experimental ABIEncoderV2;
3 
4    abstract contract Manager {
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
22 }   abstract contract Vat {
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
47 }   abstract contract PipInterface {
48     function read() public virtual returns (bytes32);
49 }   abstract contract Spotter {
50     struct Ilk {
51         PipInterface pip;
52         uint256 mat;
53     }
54 
55     mapping (bytes32 => Ilk) public ilks;
56 
57     uint256 public par;
58 
59 }   contract DSMath {
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
137 }   interface ERC20 {
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
155 }   library Address {
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
214 }   library SafeMath {
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
267 }   library SafeERC20 {
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
306 }   contract AdminAuth {
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
324         owner = msg.sender;
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
366 }   contract DefisaverLogger {
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
380 }   abstract contract GasTokenInterface is ERC20 {
381     function free(uint256 value) public virtual returns (bool success);
382 
383     function freeUpTo(uint256 value) public virtual returns (uint256 freed);
384 
385     function freeFrom(address from, uint256 value) public virtual returns (bool success);
386 
387     function freeFromUpTo(address from, uint256 value) public virtual returns (uint256 freed);
388 }   contract GasBurner {
389     // solhint-disable-next-line const-name-snakecase
390     GasTokenInterface public constant gasToken = GasTokenInterface(0x0000000000b3F879cb30FE243b4Dfee438691c04);
391 
392     modifier burnGas(uint _amount) {
393         if (gasToken.balanceOf(address(this)) >= _amount) {
394             gasToken.free(_amount);
395         }
396 
397         _;
398     }
399 }   contract BotRegistry is AdminAuth {
400 
401     mapping (address => bool) public botList;
402 
403     constructor() public {
404         botList[0x776B4a13093e30B05781F97F6A4565B6aa8BE330] = true;
405 
406         botList[0xAED662abcC4FA3314985E67Ea993CAD064a7F5cF] = true;
407         botList[0xa5d330F6619d6bF892A5B87D80272e1607b3e34D] = true;
408         botList[0x5feB4DeE5150B589a7f567EA7CADa2759794A90A] = true;
409         botList[0x7ca06417c1d6f480d3bB195B80692F95A6B66158] = true;
410     }
411 
412     function setBot(address _botAddr, bool _state) public onlyOwner {
413         botList[_botAddr] = _state;
414     }
415 
416 }      
417 
418 contract DFSExchangeData {
419 
420     // first is empty to keep the legacy order in place
421     enum ExchangeType { _, OASIS, KYBER, UNISWAP, ZEROX }
422 
423     enum ActionType { SELL, BUY }
424 
425     struct OffchainData {
426         address wrapper;
427         address exchangeAddr;
428         address allowanceTarget;
429         uint256 price;
430         uint256 protocolFee;
431         bytes callData;
432     }
433 
434     struct ExchangeData {
435         address srcAddr;
436         address destAddr;
437         uint256 srcAmount;
438         uint256 destAmount;
439         uint256 minPrice;
440         uint256 dfsFeeDivider; // service fee divider
441         address user; // user to check special fee
442         address wrapper;
443         bytes wrapperData;
444         OffchainData offchainData;
445     }
446 
447     function packExchangeData(ExchangeData memory _exData) public pure returns(bytes memory) {
448         return abi.encode(_exData);
449     }
450 
451     function unpackExchangeData(bytes memory _data) public pure returns(ExchangeData memory _exData) {
452         _exData = abi.decode(_data, (ExchangeData));
453     }
454 }   /// @title Implements enum Method
455 abstract contract StaticV2 {
456 
457     enum Method { Boost, Repay }
458 
459     struct CdpHolder {
460         uint128 minRatio;
461         uint128 maxRatio;
462         uint128 optimalRatioBoost;
463         uint128 optimalRatioRepay;
464         address owner;
465         uint cdpId;
466         bool boostEnabled;
467         bool nextPriceEnabled;
468     }
469 
470     struct SubPosition {
471         uint arrPos;
472         bool subscribed;
473     }
474 }      
475 
476 
477 
478 abstract contract ISubscriptionsV2 is StaticV2 {
479 
480     function getOwner(uint _cdpId) external view virtual returns(address);
481     function getSubscribedInfo(uint _cdpId) public view virtual returns(bool, uint128, uint128, uint128, uint128, address, uint coll, uint debt);
482     function getCdpHolder(uint _cdpId) public view virtual returns (bool subscribed, CdpHolder memory);
483 }   abstract contract DSProxyInterface {
484 
485     /// Truffle wont compile if this isn't commented
486     // function execute(bytes memory _code, bytes memory _data)
487     //     public virtual
488     //     payable
489     //     returns (address, bytes32);
490 
491     function execute(address _target, bytes memory _data) public virtual payable returns (bytes32);
492 
493     function setCache(address _cacheAddr) public virtual payable returns (bool);
494 
495     function owner() public virtual returns (address);
496 }   /// @title Implements logic for calling MCDSaverProxy always from same contract
497 contract MCDMonitorProxyV2 is AdminAuth {
498 
499     uint public CHANGE_PERIOD;
500     uint public MIN_CHANGE_PERIOD = 6 * 1 hours;
501     address public monitor;
502     address public newMonitor;
503     address public lastMonitor;
504     uint public changeRequestedTimestamp;
505 
506     event MonitorChangeInitiated(address oldMonitor, address newMonitor);
507     event MonitorChangeCanceled();
508     event MonitorChangeFinished(address monitor);
509     event MonitorChangeReverted(address monitor);
510 
511     modifier onlyMonitor() {
512         require (msg.sender == monitor);
513         _;
514     }
515 
516     constructor(uint _changePeriod) public {
517         CHANGE_PERIOD = _changePeriod * 1 hours;
518     }
519 
520     /// @notice Only monitor contract is able to call execute on users proxy
521     /// @param _owner Address of cdp owner (users DSProxy address)
522     /// @param _saverProxy Address of MCDSaverProxy
523     /// @param _data Data to send to MCDSaverProxy
524     function callExecute(address _owner, address _saverProxy, bytes memory _data) public payable onlyMonitor {
525         // execute reverts if calling specific method fails
526         DSProxyInterface(_owner).execute{value: msg.value}(_saverProxy, _data);
527 
528         // return if anything left
529         if (address(this).balance > 0) {
530             msg.sender.transfer(address(this).balance);
531         }
532     }
533 
534     /// @notice Allowed users are able to set Monitor contract without any waiting period first time
535     /// @param _monitor Address of Monitor contract
536     function setMonitor(address _monitor) public onlyOwner {
537         require(monitor == address(0));
538         monitor = _monitor;
539     }
540 
541     /// @notice Allowed users are able to start procedure for changing monitor
542     /// @dev after CHANGE_PERIOD needs to call confirmNewMonitor to actually make a change
543     /// @param _newMonitor address of new monitor
544     function changeMonitor(address _newMonitor) public onlyOwner {
545         require(changeRequestedTimestamp == 0);
546 
547         changeRequestedTimestamp = now;
548         lastMonitor = monitor;
549         newMonitor = _newMonitor;
550 
551         emit MonitorChangeInitiated(lastMonitor, newMonitor);
552     }
553 
554     /// @notice At any point allowed users are able to cancel monitor change
555     function cancelMonitorChange() public onlyOwner {
556         require(changeRequestedTimestamp > 0);
557 
558         changeRequestedTimestamp = 0;
559         newMonitor = address(0);
560 
561         emit MonitorChangeCanceled();
562     }
563 
564     /// @notice Anyone is able to confirm new monitor after CHANGE_PERIOD if process is started
565     function confirmNewMonitor() public onlyOwner {
566         require((changeRequestedTimestamp + CHANGE_PERIOD) < now);
567         require(changeRequestedTimestamp != 0);
568         require(newMonitor != address(0));
569 
570         monitor = newMonitor;
571         newMonitor = address(0);
572         changeRequestedTimestamp = 0;
573 
574         emit MonitorChangeFinished(monitor);
575     }
576 
577     /// @notice Its possible to revert monitor to last used monitor
578     function revertMonitor() public onlyOwner {
579         require(lastMonitor != address(0));
580 
581         monitor = lastMonitor;
582 
583         emit MonitorChangeReverted(monitor);
584     }
585 
586     function setChangePeriod(uint _periodInHours) public onlyOwner {
587         require(_periodInHours * 1 hours > MIN_CHANGE_PERIOD);
588 
589         CHANGE_PERIOD = _periodInHours * 1 hours;
590     }
591 
592 }      
593 
594 
595 
596 
597 
598 
599 
600 
601 
602 
603 
604 
605 
606 
607 
608 
609 
610 /// @title Implements logic that allows bots to call Boost and Repay
611 contract MCDMonitorV2 is DSMath, AdminAuth, GasBurner, StaticV2 {
612 
613     uint public REPAY_GAS_TOKEN = 25;
614     uint public BOOST_GAS_TOKEN = 25;
615 
616     uint public MAX_GAS_PRICE = 800000000000; // 800 gwei
617 
618     uint public REPAY_GAS_COST = 1000000;
619     uint public BOOST_GAS_COST = 1000000;
620 
621     bytes4 public REPAY_SELECTOR = 0xf360ce20;
622     bytes4 public BOOST_SELECTOR = 0x8ec2ae25;
623 
624     MCDMonitorProxyV2 public monitorProxyContract;
625     ISubscriptionsV2 public subscriptionsContract;
626     address public mcdSaverTakerAddress;
627 
628     address public constant BOT_REGISTRY_ADDRESS = 0x637726f8b08a7ABE3aE3aCaB01A80E2d8ddeF77B;
629 
630     address public constant PROXY_PERMISSION_ADDR = 0x5a4f877CA808Cca3cB7c2A194F80Ab8588FAE26B;
631 
632     Manager public manager = Manager(0x5ef30b9986345249bc32d8928B7ee64DE9435E39);
633     Vat public vat = Vat(0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
634     Spotter public spotter = Spotter(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
635 
636     DefisaverLogger public constant logger = DefisaverLogger(0x5c55B921f590a89C1Ebe84dF170E655a82b62126);
637 
638     modifier onlyApproved() {
639         require(BotRegistry(BOT_REGISTRY_ADDRESS).botList(msg.sender), "Not auth bot");
640         _;
641     }
642 
643     constructor(address _monitorProxy, address _subscriptions, address _mcdSaverTakerAddress) public {
644         monitorProxyContract = MCDMonitorProxyV2(_monitorProxy);
645         subscriptionsContract = ISubscriptionsV2(_subscriptions);
646         mcdSaverTakerAddress = _mcdSaverTakerAddress;
647     }
648 
649     /// @notice Bots call this method to repay for user when conditions are met
650     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
651     function repayFor(
652         DFSExchangeData.ExchangeData memory _exchangeData,
653         uint _cdpId,
654         uint _nextPrice,
655         address _joinAddr
656     ) public payable onlyApproved burnGas(REPAY_GAS_TOKEN) {
657 
658         (bool isAllowed, uint ratioBefore) = canCall(Method.Repay, _cdpId, _nextPrice);
659         require(isAllowed);
660 
661         uint gasCost = calcGasCost(REPAY_GAS_COST);
662 
663         address owner = subscriptionsContract.getOwner(_cdpId);
664 
665         monitorProxyContract.callExecute{value: msg.value}(
666             owner,
667             mcdSaverTakerAddress,
668             abi.encodeWithSelector(REPAY_SELECTOR, _exchangeData, _cdpId, gasCost, _joinAddr, 0));
669 
670 
671         (bool isGoodRatio, uint ratioAfter) = ratioGoodAfter(Method.Repay, _cdpId, _nextPrice);
672         require(isGoodRatio);
673 
674         returnEth();
675 
676         logger.Log(address(this), owner, "AutomaticMCDRepay", abi.encode(ratioBefore, ratioAfter));
677     }
678 
679     /// @notice Bots call this method to boost for user when conditions are met
680     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
681     function boostFor(
682         DFSExchangeData.ExchangeData memory _exchangeData,
683         uint _cdpId,
684         uint _nextPrice,
685         address _joinAddr
686     ) public payable onlyApproved burnGas(BOOST_GAS_TOKEN)  {
687 
688         (bool isAllowed, uint ratioBefore) = canCall(Method.Boost, _cdpId, _nextPrice);
689         require(isAllowed);
690 
691         uint gasCost = calcGasCost(BOOST_GAS_COST);
692 
693         address owner = subscriptionsContract.getOwner(_cdpId);
694 
695         monitorProxyContract.callExecute{value: msg.value}(
696             owner,
697             mcdSaverTakerAddress,
698             abi.encodeWithSelector(BOOST_SELECTOR, _exchangeData, _cdpId, gasCost, _joinAddr, 0));
699 
700         (bool isGoodRatio, uint ratioAfter) = ratioGoodAfter(Method.Boost, _cdpId, _nextPrice);
701         require(isGoodRatio);
702 
703         returnEth();
704 
705         logger.Log(address(this), owner, "AutomaticMCDBoost", abi.encode(ratioBefore, ratioAfter));
706     }
707 
708 /******************* INTERNAL METHODS ********************************/
709     function returnEth() internal {
710         // return if some eth left
711         if (address(this).balance > 0) {
712             msg.sender.transfer(address(this).balance);
713         }
714     }
715 
716 /******************* STATIC METHODS ********************************/
717 
718     /// @notice Returns an address that owns the CDP
719     /// @param _cdpId Id of the CDP
720     function getOwner(uint _cdpId) public view returns(address) {
721         return manager.owns(_cdpId);
722     }
723 
724     /// @notice Gets CDP info (collateral, debt)
725     /// @param _cdpId Id of the CDP
726     /// @param _ilk Ilk of the CDP
727     function getCdpInfo(uint _cdpId, bytes32 _ilk) public view returns (uint, uint) {
728         address urn = manager.urns(_cdpId);
729 
730         (uint collateral, uint debt) = vat.urns(_ilk, urn);
731         (,uint rate,,,) = vat.ilks(_ilk);
732 
733         return (collateral, rmul(debt, rate));
734     }
735 
736     /// @notice Gets a price of the asset
737     /// @param _ilk Ilk of the CDP
738     function getPrice(bytes32 _ilk) public view returns (uint) {
739         (, uint mat) = spotter.ilks(_ilk);
740         (,,uint spot,,) = vat.ilks(_ilk);
741 
742         return rmul(rmul(spot, spotter.par()), mat);
743     }
744 
745     /// @notice Gets CDP ratio
746     /// @param _cdpId Id of the CDP
747     /// @param _nextPrice Next price for user
748     function getRatio(uint _cdpId, uint _nextPrice) public view returns (uint) {
749         bytes32 ilk = manager.ilks(_cdpId);
750         uint price = (_nextPrice == 0) ? getPrice(ilk) : _nextPrice;
751 
752         (uint collateral, uint debt) = getCdpInfo(_cdpId, ilk);
753 
754         if (debt == 0) return 0;
755 
756         return rdiv(wmul(collateral, price), debt) / (10 ** 18);
757     }
758 
759     /// @notice Checks if Boost/Repay could be triggered for the CDP
760     /// @dev Called by MCDMonitor to enforce the min/max check
761     function canCall(Method _method, uint _cdpId, uint _nextPrice) public view returns(bool, uint) {
762         bool subscribed;
763         CdpHolder memory holder;
764         (subscribed, holder) = subscriptionsContract.getCdpHolder(_cdpId);
765 
766         // check if cdp is subscribed
767         if (!subscribed) return (false, 0);
768 
769         // check if using next price is allowed
770         if (_nextPrice > 0 && !holder.nextPriceEnabled) return (false, 0);
771 
772         // check if boost and boost allowed
773         if (_method == Method.Boost && !holder.boostEnabled) return (false, 0);
774 
775         // check if owner is still owner
776         if (getOwner(_cdpId) != holder.owner) return (false, 0);
777 
778         uint currRatio = getRatio(_cdpId, _nextPrice);
779 
780         if (_method == Method.Repay) {
781             return (currRatio < holder.minRatio, currRatio);
782         } else if (_method == Method.Boost) {
783             return (currRatio > holder.maxRatio, currRatio);
784         }
785     }
786 
787     /// @dev After the Boost/Repay check if the ratio doesn't trigger another call
788     function ratioGoodAfter(Method _method, uint _cdpId, uint _nextPrice) public view returns(bool, uint) {
789         CdpHolder memory holder;
790 
791         (, holder) = subscriptionsContract.getCdpHolder(_cdpId);
792 
793         uint currRatio = getRatio(_cdpId, _nextPrice);
794 
795         if (_method == Method.Repay) {
796             return (currRatio < holder.maxRatio, currRatio);
797         } else if (_method == Method.Boost) {
798             return (currRatio > holder.minRatio, currRatio);
799         }
800     }
801 
802     /// @notice Calculates gas cost (in Eth) of tx
803     /// @dev Gas price is limited to MAX_GAS_PRICE to prevent attack of draining user CDP
804     /// @param _gasAmount Amount of gas used for the tx
805     function calcGasCost(uint _gasAmount) public view returns (uint) {
806         uint gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;
807 
808         return mul(gasPrice, _gasAmount);
809     }
810 
811 /******************* OWNER ONLY OPERATIONS ********************************/
812 
813     /// @notice Allows owner to change gas cost for boost operation, but only up to 3 millions
814     /// @param _gasCost New gas cost for boost method
815     function changeBoostGasCost(uint _gasCost) public onlyOwner {
816         require(_gasCost < 3000000);
817 
818         BOOST_GAS_COST = _gasCost;
819     }
820 
821     /// @notice Allows owner to change gas cost for repay operation, but only up to 3 millions
822     /// @param _gasCost New gas cost for repay method
823     function changeRepayGasCost(uint _gasCost) public onlyOwner {
824         require(_gasCost < 3000000);
825 
826         REPAY_GAS_COST = _gasCost;
827     }
828 
829     /// @notice Allows owner to change max gas price
830     /// @param _maxGasPrice New max gas price
831     function changeMaxGasPrice(uint _maxGasPrice) public onlyOwner {
832         require(_maxGasPrice < 1000000000000);
833 
834         MAX_GAS_PRICE = _maxGasPrice;
835     }
836 
837     /// @notice Allows owner to change the amount of gas token burned per function call
838     /// @param _gasAmount Amount of gas token
839     /// @param _isRepay Flag to know for which function we are setting the gas token amount
840     function changeGasTokenAmount(uint _gasAmount, bool _isRepay) public onlyOwner {
841         if (_isRepay) {
842             REPAY_GAS_TOKEN = _gasAmount;
843         } else {
844             BOOST_GAS_TOKEN = _gasAmount;
845         }
846     }
847 }