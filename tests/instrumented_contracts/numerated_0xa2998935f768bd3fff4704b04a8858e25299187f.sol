1 pragma solidity ^0.6.0;
2 pragma experimental ABIEncoderV2;
3 
4 abstract contract StaticV2 {
5 
6     enum Method { Boost, Repay }
7 
8     struct CdpHolder {
9         uint128 minRatio;
10         uint128 maxRatio;
11         uint128 optimalRatioBoost;
12         uint128 optimalRatioRepay;
13         address owner;
14         uint cdpId;
15         bool boostEnabled;
16         bool nextPriceEnabled;
17     }
18 
19     struct SubPosition {
20         uint arrPos;
21         bool subscribed;
22     }
23 }
24 
25 abstract contract ISubscriptionsV2 is StaticV2 {
26 
27     function getOwner(uint _cdpId) external view virtual returns(address);
28     function getSubscribedInfo(uint _cdpId) public view virtual returns(bool, uint128, uint128, uint128, uint128, address, uint coll, uint debt);
29     function getCdpHolder(uint _cdpId) public view virtual returns (bool subscribed, CdpHolder memory);
30 } 
31 
32 abstract contract DSProxyInterface {
33     function execute(address _target, bytes memory _data) public virtual payable returns (bytes32);
34     function owner() public virtual returns (address);
35 } 
36 
37 interface ERC20 {
38     function totalSupply() external view returns (uint256 supply);
39 
40     function balanceOf(address _owner) external view returns (uint256 balance);
41 
42     function transfer(address _to, uint256 _value) external returns (bool success);
43 
44     function transferFrom(address _from, address _to, uint256 _value)
45         external
46         returns (bool success);
47 
48     function approve(address _spender, uint256 _value) external returns (bool success);
49 
50     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
51 
52     function decimals() external view returns (uint256 digits);
53 
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 } 
56 
57 library Address {
58     function isContract(address account) internal view returns (bool) {
59         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
60         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
61         // for accounts without code, i.e. `keccak256('')`
62         bytes32 codehash;
63         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
64         // solhint-disable-next-line no-inline-assembly
65         assembly { codehash := extcodehash(account) }
66         return (codehash != accountHash && codehash != 0x0);
67     }
68 
69     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
70       return functionCall(target, data, "Address: low-level call failed");
71     }
72 
73     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
74         return _functionCallWithValue(target, data, 0, errorMessage);
75     }
76 
77 
78     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
79         require(isContract(target), "Address: call to non-contract");
80 
81         // solhint-disable-next-line avoid-low-level-calls
82         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
83         if (success) {
84             return returndata;
85         } else {
86             // Look for revert reason and bubble it up if present
87             if (returndata.length > 0) {
88                 // The easiest way to bubble the revert reason is using memory via assembly
89 
90                 // solhint-disable-next-line no-inline-assembly
91                 assembly {
92                     let returndata_size := mload(returndata)
93                     revert(add(32, returndata), returndata_size)
94                 }
95             } else {
96                 revert(errorMessage);
97             }
98         }
99     }
100 }
101 
102 
103 library SafeMath {
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return sub(a, b, "SafeMath: subtraction overflow");
113     }
114 
115     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         require(b <= a, errorMessage);
117         uint256 c = a - b;
118 
119         return c;
120     }
121 
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
124         // benefit is lost if 'b' is also tested.
125         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
126         if (a == 0) {
127             return 0;
128         }
129 
130         uint256 c = a * b;
131         require(c / a == b, "SafeMath: multiplication overflow");
132 
133         return c;
134     }
135 
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return div(a, b, "SafeMath: division by zero");
138     }
139 
140     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b > 0, errorMessage);
142         uint256 c = a / b;
143         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144 
145         return c;
146     }
147 }
148 
149 
150 library SafeERC20 {
151     using SafeMath for uint256;
152     using Address for address;
153 
154     function safeTransfer(ERC20 token, address to, uint256 value) internal {
155         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
156     }
157 
158     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
159         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
160     }
161 
162     /**
163      * @dev Deprecated. This function has issues similar to the ones found in
164      * {IERC20-approve}, and its usage is discouraged.
165      */
166     function safeApprove(ERC20 token, address spender, uint256 value) internal {
167         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
168     }
169 
170     function _callOptionalReturn(ERC20 token, bytes memory data) private {
171 
172         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
173         if (returndata.length > 0) { // Return data is optional
174             // solhint-disable-next-line max-line-length
175             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
176         }
177     }
178 } 
179 
180 
181 contract AdminAuth {
182 
183     using SafeERC20 for ERC20;
184 
185     address public owner;
186     address public admin;
187 
188     modifier onlyOwner() {
189         require(owner == msg.sender);
190         _;
191     }
192 
193     constructor() public {
194         owner = msg.sender;
195     }
196 
197     /// @notice Admin is set by owner first time, after that admin is super role and has permission to change owner
198     /// @param _admin Address of multisig that becomes admin
199     function setAdminByOwner(address _admin) public {
200         require(msg.sender == owner);
201         require(admin == address(0));
202 
203         admin = _admin;
204     }
205 
206     /// @notice Admin is able to set new admin
207     /// @param _admin Address of multisig that becomes new admin
208     function setAdminByAdmin(address _admin) public {
209         require(msg.sender == admin);
210 
211         admin = _admin;
212     }
213 
214     /// @notice Admin is able to change owner
215     /// @param _owner Address of new owner
216     function setOwnerByAdmin(address _owner) public {
217         require(msg.sender == admin);
218 
219         owner = _owner;
220     }
221 
222     /// @notice Destroy the contract
223     function kill() public onlyOwner {
224         selfdestruct(payable(owner));
225     }
226 
227     /// @notice  withdraw stuck funds
228     function withdrawStuckFunds(address _token, uint _amount) public onlyOwner {
229         if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
230             payable(owner).transfer(_amount);
231         } else {
232             ERC20(_token).safeTransfer(owner, _amount);
233         }
234     }
235 } 
236 
237 contract MCDMonitorProxyV2 {
238     function callExecute(address _owner, address _saverProxy, bytes memory _data) public payable {}
239 } 
240 
241 contract ConstantAddressesMainnet {
242     address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000b3F879cb30FE243b4Dfee438691c04;
243     address public constant AUTOMATIC_LOGGER_ADDRESS = 0xAD32Ce09DE65971fFA8356d7eF0B783B82Fd1a9A;
244 
245     // new MCD contracts
246     address public constant MANAGER_ADDRESS = 0x5ef30b9986345249bc32d8928B7ee64DE9435E39;
247     address public constant VAT_ADDRESS = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
248     address public constant SPOTTER_ADDRESS = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;
249 }
250 
251 
252 contract ConstantAddresses is ConstantAddressesMainnet {} 
253 
254 
255 abstract contract GasTokenInterface is ERC20 {
256     function free(uint256 value) public virtual returns (bool success);
257 } 
258 
259 contract DSMath {
260     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
261         require((z = x + y) >= x);
262     }
263 
264 
265     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
266         require(y == 0 || (z = x * y) / y == x);
267     }
268 
269 
270     uint256 constant WAD = 10**18;
271     uint256 constant RAY = 10**27;
272 
273     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
274         z = add(mul(x, y), WAD / 2) / WAD;
275     }
276 
277     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
278         z = add(mul(x, y), RAY / 2) / RAY;
279     }
280 
281 
282     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
283         z = add(mul(x, RAY), y / 2) / y;
284     }
285 
286 } 
287 
288 abstract contract Manager {
289     function last(address) virtual public returns (uint);
290     function cdpCan(address, uint, address) virtual public view returns (uint);
291     function ilks(uint) virtual public view returns (bytes32);
292     function owns(uint) virtual public view returns (address);
293     function urns(uint) virtual public view returns (address);
294     function vat() virtual public view returns (address);
295     function open(bytes32, address) virtual public returns (uint);
296     function give(uint, address) virtual public;
297     function cdpAllow(uint, address, uint) virtual public;
298     function urnAllow(address, uint) virtual public;
299     function frob(uint, int, int) virtual public;
300     function flux(uint, address, uint) virtual public;
301     function move(uint, address, uint) virtual public;
302     function exit(address, uint, address, uint) virtual public;
303     function quit(uint, address) virtual public;
304     function enter(address, uint) virtual public;
305     function shift(uint, uint) virtual public;
306 } 
307 
308 abstract contract Vat {
309 
310     struct Urn {
311         uint256 ink;   // Locked Collateral  [wad]
312         uint256 art;   // Normalised Debt    [wad]
313     }
314 
315     struct Ilk {
316         uint256 Art;   // Total Normalised Debt     [wad]
317         uint256 rate;  // Accumulated Rates         [ray]
318         uint256 spot;  // Price with Safety Margin  [ray]
319         uint256 line;  // Debt Ceiling              [rad]
320         uint256 dust;  // Urn Debt Floor            [rad]
321     }
322 
323     mapping (bytes32 => mapping (address => Urn )) public urns;
324     mapping (bytes32 => Ilk)                       public ilks;
325     mapping (bytes32 => mapping (address => uint)) public gem;  // [wad]
326 
327     function can(address, address) virtual public view returns (uint);
328     function dai(address) virtual public view returns (uint);
329     function frob(bytes32, address, address, address, int, int) virtual public;
330     function hope(address) virtual public;
331     function move(address, address, uint) virtual public;
332     function fork(bytes32, address, address, int, int) virtual public;
333 } 
334 
335 abstract contract PipInterface {
336     function read() public virtual returns (bytes32);
337 } 
338 
339 abstract contract Spotter {
340     struct Ilk {
341         PipInterface pip;
342         uint256 mat;
343     }
344 
345     mapping (bytes32 => Ilk) public ilks;
346 
347     uint256 public par;
348 
349 } 
350 
351 contract AutomaticLogger {
352     event CdpRepay(uint indexed cdpId, address indexed caller, uint amount, uint beforeRatio, uint afterRatio, address logger);
353     event CdpBoost(uint indexed cdpId, address indexed caller, uint amount, uint beforeRatio, uint afterRatio, address logger);
354 
355     function logRepay(uint cdpId, address caller, uint amount, uint beforeRatio, uint afterRatio) public {
356         emit CdpRepay(cdpId, caller, amount, beforeRatio, afterRatio, msg.sender);
357     }
358 
359     function logBoost(uint cdpId, address caller, uint amount, uint beforeRatio, uint afterRatio) public {
360         emit CdpBoost(cdpId, caller, amount, beforeRatio, afterRatio, msg.sender);
361     }
362 }
363 
364 
365 /// @title Implements logic that allows bots to call Boost and Repay
366 contract MCDMonitorV2 is AdminAuth, ConstantAddresses, DSMath, StaticV2 {
367 
368     uint public REPAY_GAS_TOKEN = 25;
369     uint public BOOST_GAS_TOKEN = 25;
370 
371     uint public MAX_GAS_PRICE = 200000000000; // 200 gwei
372 
373     uint public REPAY_GAS_COST = 2000000;
374     uint public BOOST_GAS_COST = 2000000;
375 
376     MCDMonitorProxyV2 public monitorProxyContract;
377     ISubscriptionsV2 public subscriptionsContract;
378     GasTokenInterface gasToken = GasTokenInterface(GAS_TOKEN_INTERFACE_ADDRESS);
379     address public automaticSaverProxyAddress;
380 
381     Manager public manager = Manager(MANAGER_ADDRESS);
382     Vat public vat = Vat(VAT_ADDRESS);
383     Spotter public spotter = Spotter(SPOTTER_ADDRESS);
384     AutomaticLogger public logger = AutomaticLogger(AUTOMATIC_LOGGER_ADDRESS);
385 
386     /// @dev Addresses that are able to call methods for repay and boost
387     mapping(address => bool) public approvedCallers;
388 
389     modifier onlyApproved() {
390         require(approvedCallers[msg.sender]);
391         _;
392     }
393 
394     constructor(address _monitorProxy, address _subscriptions, address _automaticSaverProxyAddress) public {
395         approvedCallers[msg.sender] = true;
396         approvedCallers[0xAED662abcC4FA3314985E67Ea993CAD064a7F5cF] = true;
397         approvedCallers[0xa5d330F6619d6bF892A5B87D80272e1607b3e34D] = true;
398         approvedCallers[0x5feB4DeE5150B589a7f567EA7CADa2759794A90A] = true;
399         approvedCallers[0x7ca06417c1d6f480d3bB195B80692F95A6B66158] = true;
400 
401         monitorProxyContract = MCDMonitorProxyV2(_monitorProxy);
402         subscriptionsContract = ISubscriptionsV2(_subscriptions);
403         automaticSaverProxyAddress = _automaticSaverProxyAddress;
404     }
405 
406     /// @notice Bots call this method to repay for user when conditions are met
407     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
408     /// @param _data Array of uints representing [cdpId, daiAmount, minPrice, exchangeType, gasCost, 0xPrice]
409     /// @param _nextPrice Next price in Maker protocol
410     /// @param _joinAddr Address of collateral join for specific CDP
411     /// @param _exchangeAddress Address to call 0x exchange
412     /// @param _callData Bytes representing call data for 0x exchange
413     function repayFor(
414         uint[6] memory _data, // cdpId, daiAmount, minPrice, exchangeType, gasCost, 0xPrice
415         uint256 _nextPrice,
416         address _joinAddr,
417         address _exchangeAddress,
418         bytes memory _callData
419     ) public payable onlyApproved {
420         if (gasToken.balanceOf(address(this)) >= REPAY_GAS_TOKEN) {
421             gasToken.free(REPAY_GAS_TOKEN);
422         }
423 
424         uint ratioBefore;
425         bool isAllowed;
426         (isAllowed, ratioBefore) = canCall(Method.Repay, _data[0], _nextPrice);
427         require(isAllowed);
428 
429         uint gasCost = calcGasCost(REPAY_GAS_COST);
430         _data[4] = gasCost;
431 
432         monitorProxyContract.callExecute{value: msg.value}(subscriptionsContract.getOwner(_data[0]), automaticSaverProxyAddress, abi.encodeWithSignature("automaticRepay(uint256[6],address,address,bytes)", _data, _joinAddr, _exchangeAddress, _callData));
433 
434         uint ratioAfter;
435         bool isGoodRatio;
436         (isGoodRatio, ratioAfter) = ratioGoodAfter(Method.Repay, _data[0], _nextPrice);
437         // doesn't allow user to repay too much
438         require(isGoodRatio);
439 
440         returnEth();
441 
442         logger.logRepay(_data[0], msg.sender, _data[1], ratioBefore, ratioAfter);
443     }
444 
445     /// @notice Bots call this method to boost for user when conditions are met
446     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
447     /// @param _data Array of uints representing [cdpId, collateralAmount, minPrice, exchangeType, gasCost, 0xPrice]
448     /// @param _nextPrice Next price in Maker protocol
449     /// @param _joinAddr Address of collateral join for specific CDP
450     /// @param _exchangeAddress Address to call 0x exchange
451     /// @param _callData Bytes representing call data for 0x exchange
452     function boostFor(
453         uint[6] memory _data, // cdpId, daiAmount, minPrice, exchangeType, gasCost, 0xPrice
454         uint256 _nextPrice,
455         address _joinAddr,
456         address _exchangeAddress,
457         bytes memory _callData
458     ) public payable onlyApproved {
459         if (gasToken.balanceOf(address(this)) >= BOOST_GAS_TOKEN) {
460             gasToken.free(BOOST_GAS_TOKEN);
461         }
462 
463         uint ratioBefore;
464         bool isAllowed;
465         (isAllowed, ratioBefore) = canCall(Method.Boost, _data[0], _nextPrice);
466         require(isAllowed);
467 
468         uint gasCost = calcGasCost(BOOST_GAS_COST);
469         _data[4] = gasCost;
470 
471         monitorProxyContract.callExecute{value: msg.value}(subscriptionsContract.getOwner(_data[0]), automaticSaverProxyAddress, abi.encodeWithSignature("automaticBoost(uint256[6],address,address,bytes)", _data, _joinAddr, _exchangeAddress, _callData));
472 
473         uint ratioAfter;
474         bool isGoodRatio;
475         (isGoodRatio, ratioAfter) = ratioGoodAfter(Method.Boost, _data[0], _nextPrice);
476         // doesn't allow user to boost too much
477         require(isGoodRatio);
478 
479         returnEth();
480 
481         logger.logBoost(_data[0], msg.sender, _data[1], ratioBefore, ratioAfter);
482     }
483 
484 /******************* INTERNAL METHODS ********************************/
485     function returnEth() internal {
486         // return if some eth left
487         if (address(this).balance > 0) {
488             msg.sender.transfer(address(this).balance);
489         }
490     }
491 
492 /******************* STATIC METHODS ********************************/
493 
494     /// @notice Returns an address that owns the CDP
495     /// @param _cdpId Id of the CDP
496     function getOwner(uint _cdpId) public view returns(address) {
497         return manager.owns(_cdpId);
498     }
499 
500     /// @notice Gets CDP info (collateral, debt)
501     /// @param _cdpId Id of the CDP
502     /// @param _ilk Ilk of the CDP
503     function getCdpInfo(uint _cdpId, bytes32 _ilk) public view returns (uint, uint) {
504         address urn = manager.urns(_cdpId);
505 
506         (uint collateral, uint debt) = vat.urns(_ilk, urn);
507         (,uint rate,,,) = vat.ilks(_ilk);
508 
509         return (collateral, rmul(debt, rate));
510     }
511 
512     /// @notice Gets a price of the asset
513     /// @param _ilk Ilk of the CDP
514     function getPrice(bytes32 _ilk) public view returns (uint) {
515         (, uint mat) = spotter.ilks(_ilk);
516         (,,uint spot,,) = vat.ilks(_ilk);
517 
518         return rmul(rmul(spot, spotter.par()), mat);
519     }
520 
521     /// @notice Gets CDP ratio
522     /// @param _cdpId Id of the CDP
523     /// @param _nextPrice Next price for user
524     function getRatio(uint _cdpId, uint _nextPrice) public view returns (uint) {
525         bytes32 ilk = manager.ilks(_cdpId);
526         uint price = (_nextPrice == 0) ? getPrice(ilk) : _nextPrice;
527 
528         (uint collateral, uint debt) = getCdpInfo(_cdpId, ilk);
529 
530         if (debt == 0) return 0;
531 
532         return rdiv(wmul(collateral, price), debt) / (10 ** 18);
533     }
534 
535     /// @notice Checks if Boost/Repay could be triggered for the CDP
536     /// @dev Called by MCDMonitor to enforce the min/max check
537     function canCall(Method _method, uint _cdpId, uint _nextPrice) public view returns(bool, uint) {
538         bool subscribed;
539         CdpHolder memory holder;
540         (subscribed, holder) = subscriptionsContract.getCdpHolder(_cdpId);
541 
542         // check if cdp is subscribed
543         if (!subscribed) return (false, 0);
544 
545         // check if using next price is allowed
546         if (_nextPrice > 0 && !holder.nextPriceEnabled) return (false, 0);
547 
548         // check if boost and boost allowed
549         if (_method == Method.Boost && !holder.boostEnabled) return (false, 0);
550 
551         // check if owner is still owner
552         if (getOwner(_cdpId) != holder.owner) return (false, 0);
553 
554         uint currRatio = getRatio(_cdpId, _nextPrice);
555 
556         if (_method == Method.Repay) {
557             return (currRatio < holder.minRatio, currRatio);
558         } else if (_method == Method.Boost) {
559             return (currRatio > holder.maxRatio, currRatio);
560         }
561     }
562 
563     /// @dev After the Boost/Repay check if the ratio doesn't trigger another call
564     function ratioGoodAfter(Method _method, uint _cdpId, uint _nextPrice) public view returns(bool, uint) {
565         CdpHolder memory holder;
566 
567         (, holder) = subscriptionsContract.getCdpHolder(_cdpId);
568 
569         uint currRatio = getRatio(_cdpId, _nextPrice);
570 
571         if (_method == Method.Repay) {
572             return (currRatio < holder.maxRatio, currRatio);
573         } else if (_method == Method.Boost) {
574             return (currRatio > holder.minRatio, currRatio);
575         }
576     }
577 
578     /// @notice Calculates gas cost (in Eth) of tx
579     /// @dev Gas price is limited to MAX_GAS_PRICE to prevent attack of draining user CDP
580     /// @param _gasAmount Amount of gas used for the tx
581     function calcGasCost(uint _gasAmount) public view returns (uint) {
582         uint gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;
583 
584         return mul(gasPrice, _gasAmount);
585     }
586 
587 /******************* OWNER ONLY OPERATIONS ********************************/
588 
589     /// @notice Allows owner to change gas cost for boost operation, but only up to 3 millions
590     /// @param _gasCost New gas cost for boost method
591     function changeBoostGasCost(uint _gasCost) public onlyOwner {
592         require(_gasCost < 3000000);
593 
594         BOOST_GAS_COST = _gasCost;
595     }
596 
597     /// @notice Allows owner to change gas cost for repay operation, but only up to 3 millions
598     /// @param _gasCost New gas cost for repay method
599     function changeRepayGasCost(uint _gasCost) public onlyOwner {
600         require(_gasCost < 3000000);
601 
602         REPAY_GAS_COST = _gasCost;
603     }
604 
605     /// @notice Allows owner to change max gas price
606     /// @param _maxGasPrice New max gas price
607     function changeMaxGasPrice(uint _maxGasPrice) public onlyOwner {
608         require(_maxGasPrice < 500000000000);
609 
610         MAX_GAS_PRICE = _maxGasPrice;
611     }
612 
613     /// @notice Allows owner to change the amount of gas token burned per function call
614     /// @param _gasAmount Amount of gas token
615     /// @param _isRepay Flag to know for which function we are setting the gas token amount
616     function changeGasTokenAmount(uint _gasAmount, bool _isRepay) public onlyOwner {
617         if (_isRepay) {
618             REPAY_GAS_TOKEN = _gasAmount;
619         } else {
620             BOOST_GAS_TOKEN = _gasAmount;
621         }
622     }
623 
624     /// @notice Adds a new bot address which will be able to call repay/boost
625     /// @param _caller Bot address
626     function addCaller(address _caller) public onlyOwner {
627         approvedCallers[_caller] = true;
628     }
629 
630     /// @notice Removes a bot address so it can't call repay/boost
631     /// @param _caller Bot address
632     function removeCaller(address _caller) public onlyOwner {
633         approvedCallers[_caller] = false;
634     }
635 
636 }