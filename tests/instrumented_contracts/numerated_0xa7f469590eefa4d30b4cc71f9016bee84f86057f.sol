1 pragma solidity ^0.6.0;
2 pragma experimental ABIEncoderV2;
3 
4 interface ERC20 {
5     function totalSupply() external view returns (uint256 supply);
6 
7     function balanceOf(address _owner) external view returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value) external returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint256 _value)
12         external
13         returns (bool success);
14 
15     function approve(address _spender, uint256 _value) external returns (bool success);
16 
17     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
18 
19     function decimals() external view returns (uint256 digits);
20 
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 } library Address {
23     function isContract(address account) internal view returns (bool) {
24         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
25         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
26         // for accounts without code, i.e. `keccak256('')`
27         bytes32 codehash;
28         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
29         // solhint-disable-next-line no-inline-assembly
30         assembly { codehash := extcodehash(account) }
31         return (codehash != accountHash && codehash != 0x0);
32     }
33 
34     function sendValue(address payable recipient, uint256 amount) internal {
35         require(address(this).balance >= amount, "Address: insufficient balance");
36 
37         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
38         (bool success, ) = recipient.call{ value: amount }("");
39         require(success, "Address: unable to send value, recipient may have reverted");
40     }
41 
42     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
43       return functionCall(target, data, "Address: low-level call failed");
44     }
45 
46     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
47         return _functionCallWithValue(target, data, 0, errorMessage);
48     }
49 
50     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
51         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
52     }
53 
54     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
55         require(address(this).balance >= value, "Address: insufficient balance for call");
56         return _functionCallWithValue(target, data, value, errorMessage);
57     }
58 
59     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
60         require(isContract(target), "Address: call to non-contract");
61 
62         // solhint-disable-next-line avoid-low-level-calls
63         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
64         if (success) {
65             return returndata;
66         } else {
67             // Look for revert reason and bubble it up if present
68             if (returndata.length > 0) {
69                 // The easiest way to bubble the revert reason is using memory via assembly
70 
71                 // solhint-disable-next-line no-inline-assembly
72                 assembly {
73                     let returndata_size := mload(returndata)
74                     revert(add(32, returndata), returndata_size)
75                 }
76             } else {
77                 revert(errorMessage);
78             }
79         }
80     }
81 } library SafeMath {
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a, "SafeMath: addition overflow");
85 
86         return c;
87     }
88 
89     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90         return sub(a, b, "SafeMath: subtraction overflow");
91     }
92 
93     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         require(b <= a, errorMessage);
95         uint256 c = a - b;
96 
97         return c;
98     }
99 
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
102         // benefit is lost if 'b' is also tested.
103         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
104         if (a == 0) {
105             return 0;
106         }
107 
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110 
111         return c;
112     }
113 
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117 
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         return mod(a, b, "SafeMath: modulo by zero");
128     }
129 
130     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b != 0, errorMessage);
132         return a % b;
133     }
134 } library SafeERC20 {
135     using SafeMath for uint256;
136     using Address for address;
137 
138     function safeTransfer(ERC20 token, address to, uint256 value) internal {
139         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
140     }
141 
142     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
143         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
144     }
145 
146     /**
147      * @dev Deprecated. This function has issues similar to the ones found in
148      * {IERC20-approve}, and its usage is discouraged.
149      */
150     function safeApprove(ERC20 token, address spender, uint256 value) internal {
151         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
152         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
153     }
154 
155     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
156         uint256 newAllowance = token.allowance(address(this), spender).add(value);
157         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
158     }
159 
160     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
161         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
162         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
163     }
164 
165     function _callOptionalReturn(ERC20 token, bytes memory data) private {
166 
167         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
168         if (returndata.length > 0) { // Return data is optional
169             // solhint-disable-next-line max-line-length
170             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
171         }
172     }
173 } contract AdminAuth {
174 
175     using SafeERC20 for ERC20;
176 
177     address public owner;
178     address public admin;
179 
180     modifier onlyOwner() {
181         require(owner == msg.sender);
182         _;
183     }
184 
185     modifier onlyAdmin() {
186         require(admin == msg.sender);
187         _;
188     }
189 
190     constructor() public {
191         owner = 0xBc841B0dE0b93205e912CFBBd1D0c160A1ec6F00;
192         admin = 0x25eFA336886C74eA8E282ac466BdCd0199f85BB9;
193     }
194 
195     /// @notice Admin is set by owner first time, after that admin is super role and has permission to change owner
196     /// @param _admin Address of multisig that becomes admin
197     function setAdminByOwner(address _admin) public {
198         require(msg.sender == owner);
199         require(admin == address(0));
200 
201         admin = _admin;
202     }
203 
204     /// @notice Admin is able to set new admin
205     /// @param _admin Address of multisig that becomes new admin
206     function setAdminByAdmin(address _admin) public {
207         require(msg.sender == admin);
208 
209         admin = _admin;
210     }
211 
212     /// @notice Admin is able to change owner
213     /// @param _owner Address of new owner
214     function setOwnerByAdmin(address _owner) public {
215         require(msg.sender == admin);
216 
217         owner = _owner;
218     }
219 
220     /// @notice Destroy the contract
221     function kill() public onlyOwner {
222         selfdestruct(payable(owner));
223     }
224 
225     /// @notice  withdraw stuck funds
226     function withdrawStuckFunds(address _token, uint _amount) public onlyOwner {
227         if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
228             payable(owner).transfer(_amount);
229         } else {
230             ERC20(_token).safeTransfer(owner, _amount);
231         }
232     }
233 } contract BotRegistry is AdminAuth {
234 
235     mapping (address => bool) public botList;
236 
237     constructor() public {
238         botList[0x776B4a13093e30B05781F97F6A4565B6aa8BE330] = true;
239 
240         botList[0xAED662abcC4FA3314985E67Ea993CAD064a7F5cF] = true;
241         botList[0xa5d330F6619d6bF892A5B87D80272e1607b3e34D] = true;
242         botList[0x5feB4DeE5150B589a7f567EA7CADa2759794A90A] = true;
243         botList[0x7ca06417c1d6f480d3bB195B80692F95A6B66158] = true;
244     }
245 
246     function setBot(address _botAddr, bool _state) public onlyOwner {
247         botList[_botAddr] = _state;
248     }
249 
250 } abstract contract DSProxyInterface {
251 
252     /// Truffle wont compile if this isn't commented
253     // function execute(bytes memory _code, bytes memory _data)
254     //     public virtual
255     //     payable
256     //     returns (address, bytes32);
257 
258     function execute(address _target, bytes memory _data) public virtual payable returns (bytes32);
259 
260     function setCache(address _cacheAddr) public virtual payable returns (bool);
261 
262     function owner() public virtual returns (address);
263 } /// @title Contract with the actuall DSProxy permission calls the automation operations
264 contract CompoundMonitorProxy is AdminAuth {
265 
266     using SafeERC20 for ERC20;
267 
268     uint public CHANGE_PERIOD;
269     address public monitor;
270     address public newMonitor;
271     address public lastMonitor;
272     uint public changeRequestedTimestamp;
273 
274     mapping(address => bool) public allowed;
275 
276     event MonitorChangeInitiated(address oldMonitor, address newMonitor);
277     event MonitorChangeCanceled();
278     event MonitorChangeFinished(address monitor);
279     event MonitorChangeReverted(address monitor);
280 
281     // if someone who is allowed become malicious, owner can't be changed
282     modifier onlyAllowed() {
283         require(allowed[msg.sender] || msg.sender == owner);
284         _;
285     }
286 
287     modifier onlyMonitor() {
288         require (msg.sender == monitor);
289         _;
290     }
291 
292     constructor(uint _changePeriod) public {
293         CHANGE_PERIOD = _changePeriod * 1 days;
294     }
295 
296     /// @notice Only monitor contract is able to call execute on users proxy
297     /// @param _owner Address of cdp owner (users DSProxy address)
298     /// @param _compoundSaverProxy Address of CompoundSaverProxy
299     /// @param _data Data to send to CompoundSaverProxy
300     function callExecute(address _owner, address _compoundSaverProxy, bytes memory _data) public payable onlyMonitor {
301         // execute reverts if calling specific method fails
302         DSProxyInterface(_owner).execute{value: msg.value}(_compoundSaverProxy, _data);
303 
304         // return if anything left
305         if (address(this).balance > 0) {
306             msg.sender.transfer(address(this).balance);
307         }
308     }
309 
310     /// @notice Allowed users are able to set Monitor contract without any waiting period first time
311     /// @param _monitor Address of Monitor contract
312     function setMonitor(address _monitor) public onlyAllowed {
313         require(monitor == address(0));
314         monitor = _monitor;
315     }
316 
317     /// @notice Allowed users are able to start procedure for changing monitor
318     /// @dev after CHANGE_PERIOD needs to call confirmNewMonitor to actually make a change
319     /// @param _newMonitor address of new monitor
320     function changeMonitor(address _newMonitor) public onlyAllowed {
321         require(changeRequestedTimestamp == 0);
322 
323         changeRequestedTimestamp = now;
324         lastMonitor = monitor;
325         newMonitor = _newMonitor;
326 
327         emit MonitorChangeInitiated(lastMonitor, newMonitor);
328     }
329 
330     /// @notice At any point allowed users are able to cancel monitor change
331     function cancelMonitorChange() public onlyAllowed {
332         require(changeRequestedTimestamp > 0);
333 
334         changeRequestedTimestamp = 0;
335         newMonitor = address(0);
336 
337         emit MonitorChangeCanceled();
338     }
339 
340     /// @notice Anyone is able to confirm new monitor after CHANGE_PERIOD if process is started
341     function confirmNewMonitor() public onlyAllowed {
342         require((changeRequestedTimestamp + CHANGE_PERIOD) < now);
343         require(changeRequestedTimestamp != 0);
344         require(newMonitor != address(0));
345 
346         monitor = newMonitor;
347         newMonitor = address(0);
348         changeRequestedTimestamp = 0;
349 
350         emit MonitorChangeFinished(monitor);
351     }
352 
353     /// @notice Its possible to revert monitor to last used monitor
354     function revertMonitor() public onlyAllowed {
355         require(lastMonitor != address(0));
356 
357         monitor = lastMonitor;
358 
359         emit MonitorChangeReverted(monitor);
360     }
361 
362 
363     /// @notice Allowed users are able to add new allowed user
364     /// @param _user Address of user that will be allowed
365     function addAllowed(address _user) public onlyAllowed {
366         allowed[_user] = true;
367     }
368 
369     /// @notice Allowed users are able to remove allowed user
370     /// @dev owner is always allowed even if someone tries to remove it from allowed mapping
371     /// @param _user Address of allowed user
372     function removeAllowed(address _user) public onlyAllowed {
373         allowed[_user] = false;
374     }
375 
376     function setChangePeriod(uint _periodInDays) public onlyAllowed {
377         require(_periodInDays * 1 days > CHANGE_PERIOD);
378 
379         CHANGE_PERIOD = _periodInDays * 1 days;
380     }
381 
382     /// @notice In case something is left in contract, owner is able to withdraw it
383     /// @param _token address of token to withdraw balance
384     function withdrawToken(address _token) public onlyOwner {
385         uint balance = ERC20(_token).balanceOf(address(this));
386         ERC20(_token).safeTransfer(msg.sender, balance);
387     }
388 
389     /// @notice In case something is left in contract, owner is able to withdraw it
390     function withdrawEth() public onlyOwner {
391         uint balance = address(this).balance;
392         msg.sender.transfer(balance);
393     }
394 } 
395 
396 
397 
398 /// @title Stores subscription information for Compound automatization
399 contract CompoundSubscriptions is AdminAuth {
400 
401     struct CompoundHolder {
402         address user;
403         uint128 minRatio;
404         uint128 maxRatio;
405         uint128 optimalRatioBoost;
406         uint128 optimalRatioRepay;
407         bool boostEnabled;
408     }
409 
410     struct SubPosition {
411         uint arrPos;
412         bool subscribed;
413     }
414 
415     CompoundHolder[] public subscribers;
416     mapping (address => SubPosition) public subscribersPos;
417 
418     uint public changeIndex;
419 
420     event Subscribed(address indexed user);
421     event Unsubscribed(address indexed user);
422     event Updated(address indexed user);
423     event ParamUpdates(address indexed user, uint128, uint128, uint128, uint128, bool);
424 
425     /// @dev Called by the DSProxy contract which owns the Compound position
426     /// @notice Adds the users Compound poistion in the list of subscriptions so it can be monitored
427     /// @param _minRatio Minimum ratio below which repay is triggered
428     /// @param _maxRatio Maximum ratio after which boost is triggered
429     /// @param _optimalBoost Ratio amount which boost should target
430     /// @param _optimalRepay Ratio amount which repay should target
431     /// @param _boostEnabled Boolean determing if boost is enabled
432     function subscribe(uint128 _minRatio, uint128 _maxRatio, uint128 _optimalBoost, uint128 _optimalRepay, bool _boostEnabled) external {
433 
434         // if boost is not enabled, set max ratio to max uint
435         uint128 localMaxRatio = _boostEnabled ? _maxRatio : uint128(-1);
436         require(checkParams(_minRatio, localMaxRatio), "Must be correct params");
437 
438         SubPosition storage subInfo = subscribersPos[msg.sender];
439 
440         CompoundHolder memory subscription = CompoundHolder({
441                 minRatio: _minRatio,
442                 maxRatio: localMaxRatio,
443                 optimalRatioBoost: _optimalBoost,
444                 optimalRatioRepay: _optimalRepay,
445                 user: msg.sender,
446                 boostEnabled: _boostEnabled
447             });
448 
449         changeIndex++;
450 
451         if (subInfo.subscribed) {
452             subscribers[subInfo.arrPos] = subscription;
453 
454             emit Updated(msg.sender);
455             emit ParamUpdates(msg.sender, _minRatio, localMaxRatio, _optimalBoost, _optimalRepay, _boostEnabled);
456         } else {
457             subscribers.push(subscription);
458 
459             subInfo.arrPos = subscribers.length - 1;
460             subInfo.subscribed = true;
461 
462             emit Subscribed(msg.sender);
463         }
464     }
465 
466     /// @notice Called by the users DSProxy
467     /// @dev Owner who subscribed cancels his subscription
468     function unsubscribe() external {
469         _unsubscribe(msg.sender);
470     }
471 
472     /// @dev Checks limit if minRatio is bigger than max
473     /// @param _minRatio Minimum ratio, bellow which repay can be triggered
474     /// @param _maxRatio Maximum ratio, over which boost can be triggered
475     /// @return Returns bool if the params are correct
476     function checkParams(uint128 _minRatio, uint128 _maxRatio) internal pure returns (bool) {
477 
478         if (_minRatio > _maxRatio) {
479             return false;
480         }
481 
482         return true;
483     }
484 
485     /// @dev Internal method to remove a subscriber from the list
486     /// @param _user The actual address that owns the Compound position
487     function _unsubscribe(address _user) internal {
488         require(subscribers.length > 0, "Must have subscribers in the list");
489 
490         SubPosition storage subInfo = subscribersPos[_user];
491 
492         require(subInfo.subscribed, "Must first be subscribed");
493 
494         address lastOwner = subscribers[subscribers.length - 1].user;
495 
496         SubPosition storage subInfo2 = subscribersPos[lastOwner];
497         subInfo2.arrPos = subInfo.arrPos;
498 
499         subscribers[subInfo.arrPos] = subscribers[subscribers.length - 1];
500         subscribers.pop(); // remove last element and reduce arr length
501 
502         changeIndex++;
503         subInfo.subscribed = false;
504         subInfo.arrPos = 0;
505 
506         emit Unsubscribed(msg.sender);
507     }
508 
509     /// @dev Checks if the user is subscribed
510     /// @param _user The actual address that owns the Compound position
511     /// @return If the user is subscribed
512     function isSubscribed(address _user) public view returns (bool) {
513         SubPosition storage subInfo = subscribersPos[_user];
514 
515         return subInfo.subscribed;
516     }
517 
518     /// @dev Returns subscribtion information about a user
519     /// @param _user The actual address that owns the Compound position
520     /// @return Subscription information about the user if exists
521     function getHolder(address _user) public view returns (CompoundHolder memory) {
522         SubPosition storage subInfo = subscribersPos[_user];
523 
524         return subscribers[subInfo.arrPos];
525     }
526 
527     /// @notice Helper method to return all the subscribed CDPs
528     /// @return List of all subscribers
529     function getSubscribers() public view returns (CompoundHolder[] memory) {
530         return subscribers;
531     }
532 
533     /// @notice Helper method for the frontend, returns all the subscribed CDPs paginated
534     /// @param _page What page of subscribers you want
535     /// @param _perPage Number of entries per page
536     /// @return List of all subscribers for that page
537     function getSubscribersByPage(uint _page, uint _perPage) public view returns (CompoundHolder[] memory) {
538         CompoundHolder[] memory holders = new CompoundHolder[](_perPage);
539 
540         uint start = _page * _perPage;
541         uint end = start + _perPage;
542 
543         end = (end > holders.length) ? holders.length : end;
544 
545         uint count = 0;
546         for (uint i = start; i < end; i++) {
547             holders[count] = subscribers[i];
548             count++;
549         }
550 
551         return holders;
552     }
553 
554     ////////////// ADMIN METHODS ///////////////////
555 
556     /// @notice Admin function to unsubscribe a CDP
557     /// @param _user The actual address that owns the Compound position
558     function unsubscribeByAdmin(address _user) public onlyOwner {
559         SubPosition storage subInfo = subscribersPos[_user];
560 
561         if (subInfo.subscribed) {
562             _unsubscribe(_user);
563         }
564     }
565 } contract DSMath {
566     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
567         require((z = x + y) >= x);
568     }
569 
570     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
571         require((z = x - y) <= x);
572     }
573 
574     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
575         require(y == 0 || (z = x * y) / y == x);
576     }
577 
578     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
579         return x / y;
580     }
581 
582     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
583         return x <= y ? x : y;
584     }
585 
586     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
587         return x >= y ? x : y;
588     }
589 
590     function imin(int256 x, int256 y) internal pure returns (int256 z) {
591         return x <= y ? x : y;
592     }
593 
594     function imax(int256 x, int256 y) internal pure returns (int256 z) {
595         return x >= y ? x : y;
596     }
597 
598     uint256 constant WAD = 10**18;
599     uint256 constant RAY = 10**27;
600 
601     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
602         z = add(mul(x, y), WAD / 2) / WAD;
603     }
604 
605     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
606         z = add(mul(x, y), RAY / 2) / RAY;
607     }
608 
609     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
610         z = add(mul(x, WAD), y / 2) / y;
611     }
612 
613     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
614         z = add(mul(x, RAY), y / 2) / y;
615     }
616 
617     // This famous algorithm is called "exponentiation by squaring"
618     // and calculates x^n with x as fixed-point and n as regular unsigned.
619     //
620     // It's O(log n), instead of O(n) for naive repeated multiplication.
621     //
622     // These facts are why it works:
623     //
624     //  If n is even, then x^n = (x^2)^(n/2).
625     //  If n is odd,  then x^n = x * x^(n-1),
626     //   and applying the equation for even x gives
627     //    x^n = x * (x^2)^((n-1) / 2).
628     //
629     //  Also, EVM division is flooring and
630     //    floor[(n-1) / 2] = floor[n / 2].
631     //
632     function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
633         z = n % 2 != 0 ? x : RAY;
634 
635         for (n /= 2; n != 0; n /= 2) {
636             x = rmul(x, x);
637 
638             if (n % 2 != 0) {
639                 z = rmul(z, x);
640             }
641         }
642     }
643 } contract DefisaverLogger {
644     event LogEvent(
645         address indexed contractAddress,
646         address indexed caller,
647         string indexed logName,
648         bytes data
649     );
650 
651     // solhint-disable-next-line func-name-mixedcase
652     function Log(address _contract, address _caller, string memory _logName, bytes memory _data)
653         public
654     {
655         emit LogEvent(_contract, _caller, _logName, _data);
656     }
657 } abstract contract CompoundOracleInterface {
658     function getUnderlyingPrice(address cToken) external view virtual returns (uint);
659 }  
660 
661 abstract contract ComptrollerInterface {
662     struct CompMarketState {
663         uint224 index;
664         uint32 block;
665     }
666 
667     function claimComp(address holder) public virtual;
668     function claimComp(address holder, address[] memory cTokens) public virtual;
669     function claimComp(address[] memory holders, address[] memory cTokens, bool borrowers, bool suppliers) public virtual;
670 
671     function compSupplyState(address) public view virtual returns (CompMarketState memory);
672     function compSupplierIndex(address,address) public view virtual returns (uint);
673     function compAccrued(address) public view virtual returns (uint);
674 
675     function compBorrowState(address) public view virtual returns (CompMarketState memory);
676     function compBorrowerIndex(address,address) public view virtual returns (uint);
677 
678     function enterMarkets(address[] calldata cTokens) external virtual returns (uint256[] memory);
679 
680     function exitMarket(address cToken) external virtual returns (uint256);
681 
682     function getAssetsIn(address account) external virtual view returns (address[] memory);
683 
684     function markets(address account) public virtual view returns (bool, uint256);
685 
686     function getAccountLiquidity(address account) external virtual view returns (uint256, uint256, uint256);
687 
688     function oracle() public virtual view returns (address);
689 
690     mapping(address => uint) public compSpeeds;
691 
692     mapping(address => uint) public borrowCaps;
693 } abstract contract CTokenInterface is ERC20 {
694     function mint(uint256 mintAmount) external virtual returns (uint256);
695 
696     // function mint() external virtual payable;
697 
698     function accrueInterest() public virtual returns (uint);
699 
700     function redeem(uint256 redeemTokens) external virtual returns (uint256);
701 
702     function redeemUnderlying(uint256 redeemAmount) external virtual returns (uint256);
703 
704     function borrow(uint256 borrowAmount) external virtual returns (uint256);
705     function borrowIndex() public view virtual returns (uint);
706     function borrowBalanceStored(address) public view virtual returns(uint);
707 
708     function repayBorrow(uint256 repayAmount) external virtual returns (uint256);
709 
710     function repayBorrow() external virtual payable;
711 
712     function repayBorrowBehalf(address borrower, uint256 repayAmount) external virtual returns (uint256);
713 
714     function repayBorrowBehalf(address borrower) external virtual payable;
715 
716     function liquidateBorrow(address borrower, uint256 repayAmount, address cTokenCollateral)
717         external virtual
718         returns (uint256);
719 
720     function liquidateBorrow(address borrower, address cTokenCollateral) external virtual payable;
721 
722     function exchangeRateCurrent() external virtual returns (uint256);
723 
724     function supplyRatePerBlock() external virtual returns (uint256);
725 
726     function borrowRatePerBlock() external virtual returns (uint256);
727 
728     function totalReserves() external virtual returns (uint256);
729 
730     function reserveFactorMantissa() external virtual returns (uint256);
731 
732     function borrowBalanceCurrent(address account) external virtual returns (uint256);
733 
734     function totalBorrowsCurrent() external virtual returns (uint256);
735 
736     function getCash() external virtual returns (uint256);
737 
738     function balanceOfUnderlying(address owner) external virtual returns (uint256);
739 
740     function underlying() external virtual returns (address);
741 
742     function getAccountSnapshot(address account) external virtual view returns (uint, uint, uint, uint);
743 } contract CarefulMath {
744 
745     /**
746      * @dev Possible error codes that we can return
747      */
748     enum MathError {
749         NO_ERROR,
750         DIVISION_BY_ZERO,
751         INTEGER_OVERFLOW,
752         INTEGER_UNDERFLOW
753     }
754 
755     /**
756     * @dev Multiplies two numbers, returns an error on overflow.
757     */
758     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
759         if (a == 0) {
760             return (MathError.NO_ERROR, 0);
761         }
762 
763         uint c = a * b;
764 
765         if (c / a != b) {
766             return (MathError.INTEGER_OVERFLOW, 0);
767         } else {
768             return (MathError.NO_ERROR, c);
769         }
770     }
771 
772     /**
773     * @dev Integer division of two numbers, truncating the quotient.
774     */
775     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
776         if (b == 0) {
777             return (MathError.DIVISION_BY_ZERO, 0);
778         }
779 
780         return (MathError.NO_ERROR, a / b);
781     }
782 
783     /**
784     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
785     */
786     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
787         if (b <= a) {
788             return (MathError.NO_ERROR, a - b);
789         } else {
790             return (MathError.INTEGER_UNDERFLOW, 0);
791         }
792     }
793 
794     /**
795     * @dev Adds two numbers, returns an error on overflow.
796     */
797     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
798         uint c = a + b;
799 
800         if (c >= a) {
801             return (MathError.NO_ERROR, c);
802         } else {
803             return (MathError.INTEGER_OVERFLOW, 0);
804         }
805     }
806 
807     /**
808     * @dev add a and b and then subtract c
809     */
810     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
811         (MathError err0, uint sum) = addUInt(a, b);
812 
813         if (err0 != MathError.NO_ERROR) {
814             return (err0, 0);
815         }
816 
817         return subUInt(sum, c);
818     }
819 } contract Exponential is CarefulMath {
820     uint constant expScale = 1e18;
821     uint constant doubleScale = 1e36;
822     uint constant halfExpScale = expScale/2;
823     uint constant mantissaOne = expScale;
824 
825     struct Exp {
826         uint mantissa;
827     }
828 
829     struct Double {
830         uint mantissa;
831     }
832 
833     /**
834      * @dev Creates an exponential from numerator and denominator values.
835      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
836      *            or if `denom` is zero.
837      */
838     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
839         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
840         if (err0 != MathError.NO_ERROR) {
841             return (err0, Exp({mantissa: 0}));
842         }
843 
844         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
845         if (err1 != MathError.NO_ERROR) {
846             return (err1, Exp({mantissa: 0}));
847         }
848 
849         return (MathError.NO_ERROR, Exp({mantissa: rational}));
850     }
851 
852     /**
853      * @dev Adds two exponentials, returning a new exponential.
854      */
855     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
856         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
857 
858         return (error, Exp({mantissa: result}));
859     }
860 
861     /**
862      * @dev Subtracts two exponentials, returning a new exponential.
863      */
864     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
865         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
866 
867         return (error, Exp({mantissa: result}));
868     }
869 
870     /**
871      * @dev Multiply an Exp by a scalar, returning a new Exp.
872      */
873     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
874         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
875         if (err0 != MathError.NO_ERROR) {
876             return (err0, Exp({mantissa: 0}));
877         }
878 
879         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
880     }
881 
882     /**
883      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
884      */
885     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
886         (MathError err, Exp memory product) = mulScalar(a, scalar);
887         if (err != MathError.NO_ERROR) {
888             return (err, 0);
889         }
890 
891         return (MathError.NO_ERROR, truncate(product));
892     }
893 
894     /**
895      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
896      */
897     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
898         (MathError err, Exp memory product) = mulScalar(a, scalar);
899         if (err != MathError.NO_ERROR) {
900             return (err, 0);
901         }
902 
903         return addUInt(truncate(product), addend);
904     }
905 
906     /**
907      * @dev Divide an Exp by a scalar, returning a new Exp.
908      */
909     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
910         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
911         if (err0 != MathError.NO_ERROR) {
912             return (err0, Exp({mantissa: 0}));
913         }
914 
915         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
916     }
917 
918     /**
919      * @dev Divide a scalar by an Exp, returning a new Exp.
920      */
921     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
922         /*
923           We are doing this as:
924           getExp(mulUInt(expScale, scalar), divisor.mantissa)
925 
926           How it works:
927           Exp = a / b;
928           Scalar = s;
929           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
930         */
931         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
932         if (err0 != MathError.NO_ERROR) {
933             return (err0, Exp({mantissa: 0}));
934         }
935         return getExp(numerator, divisor.mantissa);
936     }
937 
938     /**
939      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
940      */
941     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
942         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
943         if (err != MathError.NO_ERROR) {
944             return (err, 0);
945         }
946 
947         return (MathError.NO_ERROR, truncate(fraction));
948     }
949 
950     /**
951      * @dev Multiplies two exponentials, returning a new exponential.
952      */
953     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
954 
955         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
956         if (err0 != MathError.NO_ERROR) {
957             return (err0, Exp({mantissa: 0}));
958         }
959 
960         // We add half the scale before dividing so that we get rounding instead of truncation.
961         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
962         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
963         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
964         if (err1 != MathError.NO_ERROR) {
965             return (err1, Exp({mantissa: 0}));
966         }
967 
968         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
969         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
970         assert(err2 == MathError.NO_ERROR);
971 
972         return (MathError.NO_ERROR, Exp({mantissa: product}));
973     }
974 
975     /**
976      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
977      */
978     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
979         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
980     }
981 
982     /**
983      * @dev Multiplies three exponentials, returning a new exponential.
984      */
985     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
986         (MathError err, Exp memory ab) = mulExp(a, b);
987         if (err != MathError.NO_ERROR) {
988             return (err, ab);
989         }
990         return mulExp(ab, c);
991     }
992 
993     /**
994      * @dev Divides two exponentials, returning a new exponential.
995      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
996      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
997      */
998     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
999         return getExp(a.mantissa, b.mantissa);
1000     }
1001 
1002     /**
1003      * @dev Truncates the given exp to a whole number value.
1004      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
1005      */
1006     function truncate(Exp memory exp) pure internal returns (uint) {
1007         // Note: We are not using careful math here as we're performing a division that cannot fail
1008         return exp.mantissa / expScale;
1009     }
1010 
1011     /**
1012      * @dev Checks if first Exp is less than second Exp.
1013      */
1014     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
1015         return left.mantissa < right.mantissa;
1016     }
1017 
1018     /**
1019      * @dev Checks if left Exp <= right Exp.
1020      */
1021     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
1022         return left.mantissa <= right.mantissa;
1023     }
1024 
1025     /**
1026      * @dev Checks if left Exp > right Exp.
1027      */
1028     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
1029         return left.mantissa > right.mantissa;
1030     }
1031 
1032     /**
1033      * @dev returns true if Exp is exactly zero
1034      */
1035     function isZeroExp(Exp memory value) pure internal returns (bool) {
1036         return value.mantissa == 0;
1037     }
1038 
1039     function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1040         return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
1041     }
1042 
1043     function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
1044         return Double({mantissa: sub_(a.mantissa, b.mantissa)});
1045     }
1046 
1047     function sub_(uint a, uint b) pure internal returns (uint) {
1048         return sub_(a, b, "subtraction underflow");
1049     }
1050 
1051     function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1052         require(b <= a, errorMessage);
1053         return a - b;
1054     }
1055 
1056     function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1057         return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
1058     }
1059 
1060     function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
1061         return Exp({mantissa: mul_(a.mantissa, b)});
1062     }
1063 
1064     function mul_(uint a, Exp memory b) pure internal returns (uint) {
1065         return mul_(a, b.mantissa) / expScale;
1066     }
1067 
1068     function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
1069         return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
1070     }
1071 
1072     function mul_(Double memory a, uint b) pure internal returns (Double memory) {
1073         return Double({mantissa: mul_(a.mantissa, b)});
1074     }
1075 
1076     function mul_(uint a, Double memory b) pure internal returns (uint) {
1077         return mul_(a, b.mantissa) / doubleScale;
1078     }
1079 
1080     function mul_(uint a, uint b) pure internal returns (uint) {
1081         return mul_(a, b, "multiplication overflow");
1082     }
1083 
1084     function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1085         if (a == 0 || b == 0) {
1086             return 0;
1087         }
1088         uint c = a * b;
1089         require(c / a == b, errorMessage);
1090         return c;
1091     }
1092 
1093     function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1094         return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
1095     }
1096 
1097     function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
1098         return Exp({mantissa: div_(a.mantissa, b)});
1099     }
1100 
1101     function div_(uint a, Exp memory b) pure internal returns (uint) {
1102         return div_(mul_(a, expScale), b.mantissa);
1103     }
1104 
1105     function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
1106         return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
1107     }
1108 
1109     function div_(Double memory a, uint b) pure internal returns (Double memory) {
1110         return Double({mantissa: div_(a.mantissa, b)});
1111     }
1112 
1113     function div_(uint a, Double memory b) pure internal returns (uint) {
1114         return div_(mul_(a, doubleScale), b.mantissa);
1115     }
1116 
1117     function div_(uint a, uint b) pure internal returns (uint) {
1118         return div_(a, b, "divide by zero");
1119     }
1120 
1121     function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1122         require(b > 0, errorMessage);
1123         return a / b;
1124     }
1125 
1126     function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1127         return Exp({mantissa: add_(a.mantissa, b.mantissa)});
1128     }
1129 
1130     function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
1131         return Double({mantissa: add_(a.mantissa, b.mantissa)});
1132     }
1133 
1134     function add_(uint a, uint b) pure internal returns (uint) {
1135         return add_(a, b, "addition overflow");
1136     }
1137 
1138     function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1139         uint c = a + b;
1140         require(c >= a, errorMessage);
1141         return c;
1142     }
1143 } contract CompoundSafetyRatio is Exponential, DSMath {
1144     // solhint-disable-next-line const-name-snakecase
1145     ComptrollerInterface public constant comp = ComptrollerInterface(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
1146 
1147     /// @notice Calcualted the ratio of debt / adjusted collateral
1148     /// @param _user Address of the user
1149     function getSafetyRatio(address _user) public view returns (uint) {
1150         // For each asset the account is in
1151         address[] memory assets = comp.getAssetsIn(_user);
1152         address oracleAddr = comp.oracle();
1153 
1154 
1155         uint sumCollateral = 0;
1156         uint sumBorrow = 0;
1157 
1158         for (uint i = 0; i < assets.length; i++) {
1159             address asset = assets[i];
1160 
1161             (, uint cTokenBalance, uint borrowBalance, uint exchangeRateMantissa)
1162                                         = CTokenInterface(asset).getAccountSnapshot(_user);
1163 
1164             Exp memory oraclePrice;
1165 
1166             if (cTokenBalance != 0 || borrowBalance != 0) {
1167                 oraclePrice = Exp({mantissa: CompoundOracleInterface(oracleAddr).getUnderlyingPrice(asset)});
1168             }
1169 
1170             // Sum up collateral in Usd
1171             if (cTokenBalance != 0) {
1172 
1173                 (, uint collFactorMantissa) = comp.markets(address(asset));
1174 
1175                 Exp memory collateralFactor = Exp({mantissa: collFactorMantissa});
1176                 Exp memory exchangeRate = Exp({mantissa: exchangeRateMantissa});
1177 
1178                 (, Exp memory tokensToUsd) = mulExp3(collateralFactor, exchangeRate, oraclePrice);
1179 
1180                 (, sumCollateral) = mulScalarTruncateAddUInt(tokensToUsd, cTokenBalance, sumCollateral);
1181             }
1182 
1183             // Sum up debt in Usd
1184             if (borrowBalance != 0) {
1185                 (, sumBorrow) = mulScalarTruncateAddUInt(oraclePrice, borrowBalance, sumBorrow);
1186             }
1187         }
1188 
1189         if (sumBorrow == 0) return uint(-1);
1190 
1191         uint borrowPowerUsed = (sumBorrow * 10**18) / sumCollateral;
1192         return wdiv(1e18, borrowPowerUsed);
1193     }
1194 }  
1195 
1196 contract DFSExchangeData {
1197 
1198     // first is empty to keep the legacy order in place
1199     enum ExchangeType { _, OASIS, KYBER, UNISWAP, ZEROX }
1200 
1201     enum ActionType { SELL, BUY }
1202 
1203     struct OffchainData {
1204         address wrapper;
1205         address exchangeAddr;
1206         address allowanceTarget;
1207         uint256 price;
1208         uint256 protocolFee;
1209         bytes callData;
1210     }
1211 
1212     struct ExchangeData {
1213         address srcAddr;
1214         address destAddr;
1215         uint256 srcAmount;
1216         uint256 destAmount;
1217         uint256 minPrice;
1218         uint256 dfsFeeDivider; // service fee divider
1219         address user; // user to check special fee
1220         address wrapper;
1221         bytes wrapperData;
1222         OffchainData offchainData;
1223     }
1224 
1225     function packExchangeData(ExchangeData memory _exData) public pure returns(bytes memory) {
1226         return abi.encode(_exData);
1227     }
1228 
1229     function unpackExchangeData(bytes memory _data) public pure returns(ExchangeData memory _exData) {
1230         _exData = abi.decode(_data, (ExchangeData));
1231     }
1232 }
1233 
1234  
1235 
1236 /**
1237  * @title LendingPoolAddressesProvider contract
1238  * @dev Main registry of addresses part of or connected to the protocol, including permissioned roles
1239  * - Acting also as factory of proxies and admin of those, so with right to change its implementations
1240  * - Owned by the Aave Governance
1241  * @author Aave
1242  **/
1243 interface ILendingPoolAddressesProviderV2 {
1244   event LendingPoolUpdated(address indexed newAddress);
1245   event ConfigurationAdminUpdated(address indexed newAddress);
1246   event EmergencyAdminUpdated(address indexed newAddress);
1247   event LendingPoolConfiguratorUpdated(address indexed newAddress);
1248   event LendingPoolCollateralManagerUpdated(address indexed newAddress);
1249   event PriceOracleUpdated(address indexed newAddress);
1250   event LendingRateOracleUpdated(address indexed newAddress);
1251   event ProxyCreated(bytes32 id, address indexed newAddress);
1252   event AddressSet(bytes32 id, address indexed newAddress, bool hasProxy);
1253 
1254   function setAddress(bytes32 id, address newAddress) external;
1255 
1256   function setAddressAsProxy(bytes32 id, address impl) external;
1257 
1258   function getAddress(bytes32 id) external view returns (address);
1259 
1260   function getLendingPool() external view returns (address);
1261 
1262   function setLendingPoolImpl(address pool) external;
1263 
1264   function getLendingPoolConfigurator() external view returns (address);
1265 
1266   function setLendingPoolConfiguratorImpl(address configurator) external;
1267 
1268   function getLendingPoolCollateralManager() external view returns (address);
1269 
1270   function setLendingPoolCollateralManager(address manager) external;
1271 
1272   function getPoolAdmin() external view returns (address);
1273 
1274   function setPoolAdmin(address admin) external;
1275 
1276   function getEmergencyAdmin() external view returns (address);
1277 
1278   function setEmergencyAdmin(address admin) external;
1279 
1280   function getPriceOracle() external view returns (address);
1281 
1282   function setPriceOracle(address priceOracle) external;
1283 
1284   function getLendingRateOracle() external view returns (address);
1285 
1286   function setLendingRateOracle(address lendingRateOracle) external;
1287 }
1288 
1289 library DataTypes {
1290   // refer to the whitepaper, section 1.1 basic concepts for a formal description of these properties.
1291   struct ReserveData {
1292     //stores the reserve configuration
1293     ReserveConfigurationMap configuration;
1294     //the liquidity index. Expressed in ray
1295     uint128 liquidityIndex;
1296     //variable borrow index. Expressed in ray
1297     uint128 variableBorrowIndex;
1298     //the current supply rate. Expressed in ray
1299     uint128 currentLiquidityRate;
1300     //the current variable borrow rate. Expressed in ray
1301     uint128 currentVariableBorrowRate;
1302     //the current stable borrow rate. Expressed in ray
1303     uint128 currentStableBorrowRate;
1304     uint40 lastUpdateTimestamp;
1305     //tokens addresses
1306     address aTokenAddress;
1307     address stableDebtTokenAddress;
1308     address variableDebtTokenAddress;
1309     //address of the interest rate strategy
1310     address interestRateStrategyAddress;
1311     //the id of the reserve. Represents the position in the list of the active reserves
1312     uint8 id;
1313   }
1314 
1315   struct ReserveConfigurationMap {
1316     //bit 0-15: LTV
1317     //bit 16-31: Liq. threshold
1318     //bit 32-47: Liq. bonus
1319     //bit 48-55: Decimals
1320     //bit 56: Reserve is active
1321     //bit 57: reserve is frozen
1322     //bit 58: borrowing is enabled
1323     //bit 59: stable rate borrowing enabled
1324     //bit 60-63: reserved
1325     //bit 64-79: reserve factor
1326     uint256 data;
1327   }
1328 
1329   struct UserConfigurationMap {
1330     uint256 data;
1331   }
1332 
1333   enum InterestRateMode {NONE, STABLE, VARIABLE}
1334 }
1335 
1336 interface ILendingPoolV2 {
1337   /**
1338    * @dev Emitted on deposit()
1339    * @param reserve The address of the underlying asset of the reserve
1340    * @param user The address initiating the deposit
1341    * @param onBehalfOf The beneficiary of the deposit, receiving the aTokens
1342    * @param amount The amount deposited
1343    * @param referral The referral code used
1344    **/
1345   event Deposit(
1346     address indexed reserve,
1347     address user,
1348     address indexed onBehalfOf,
1349     uint256 amount,
1350     uint16 indexed referral
1351   );
1352 
1353   /**
1354    * @dev Emitted on withdraw()
1355    * @param reserve The address of the underlyng asset being withdrawn
1356    * @param user The address initiating the withdrawal, owner of aTokens
1357    * @param to Address that will receive the underlying
1358    * @param amount The amount to be withdrawn
1359    **/
1360   event Withdraw(address indexed reserve, address indexed user, address indexed to, uint256 amount);
1361 
1362   /**
1363    * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
1364    * @param reserve The address of the underlying asset being borrowed
1365    * @param user The address of the user initiating the borrow(), receiving the funds on borrow() or just
1366    * initiator of the transaction on flashLoan()
1367    * @param onBehalfOf The address that will be getting the debt
1368    * @param amount The amount borrowed out
1369    * @param borrowRateMode The rate mode: 1 for Stable, 2 for Variable
1370    * @param borrowRate The numeric rate at which the user has borrowed
1371    * @param referral The referral code used
1372    **/
1373   event Borrow(
1374     address indexed reserve,
1375     address user,
1376     address indexed onBehalfOf,
1377     uint256 amount,
1378     uint256 borrowRateMode,
1379     uint256 borrowRate,
1380     uint16 indexed referral
1381   );
1382 
1383   /**
1384    * @dev Emitted on repay()
1385    * @param reserve The address of the underlying asset of the reserve
1386    * @param user The beneficiary of the repayment, getting his debt reduced
1387    * @param repayer The address of the user initiating the repay(), providing the funds
1388    * @param amount The amount repaid
1389    **/
1390   event Repay(
1391     address indexed reserve,
1392     address indexed user,
1393     address indexed repayer,
1394     uint256 amount
1395   );
1396 
1397   /**
1398    * @dev Emitted on swapBorrowRateMode()
1399    * @param reserve The address of the underlying asset of the reserve
1400    * @param user The address of the user swapping his rate mode
1401    * @param rateMode The rate mode that the user wants to swap to
1402    **/
1403   event Swap(address indexed reserve, address indexed user, uint256 rateMode);
1404 
1405   /**
1406    * @dev Emitted on setUserUseReserveAsCollateral()
1407    * @param reserve The address of the underlying asset of the reserve
1408    * @param user The address of the user enabling the usage as collateral
1409    **/
1410   event ReserveUsedAsCollateralEnabled(address indexed reserve, address indexed user);
1411 
1412   /**
1413    * @dev Emitted on setUserUseReserveAsCollateral()
1414    * @param reserve The address of the underlying asset of the reserve
1415    * @param user The address of the user enabling the usage as collateral
1416    **/
1417   event ReserveUsedAsCollateralDisabled(address indexed reserve, address indexed user);
1418 
1419   /**
1420    * @dev Emitted on rebalanceStableBorrowRate()
1421    * @param reserve The address of the underlying asset of the reserve
1422    * @param user The address of the user for which the rebalance has been executed
1423    **/
1424   event RebalanceStableBorrowRate(address indexed reserve, address indexed user);
1425 
1426   /**
1427    * @dev Emitted on flashLoan()
1428    * @param target The address of the flash loan receiver contract
1429    * @param initiator The address initiating the flash loan
1430    * @param asset The address of the asset being flash borrowed
1431    * @param amount The amount flash borrowed
1432    * @param premium The fee flash borrowed
1433    * @param referralCode The referral code used
1434    **/
1435   event FlashLoan(
1436     address indexed target,
1437     address indexed initiator,
1438     address indexed asset,
1439     uint256 amount,
1440     uint256 premium,
1441     uint16 referralCode
1442   );
1443 
1444   /**
1445    * @dev Emitted when the pause is triggered.
1446    */
1447   event Paused();
1448 
1449   /**
1450    * @dev Emitted when the pause is lifted.
1451    */
1452   event Unpaused();
1453 
1454   /**
1455    * @dev Emitted when a borrower is liquidated. This event is emitted by the LendingPool via
1456    * LendingPoolCollateral manager using a DELEGATECALL
1457    * This allows to have the events in the generated ABI for LendingPool.
1458    * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
1459    * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
1460    * @param user The address of the borrower getting liquidated
1461    * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
1462    * @param liquidatedCollateralAmount The amount of collateral received by the liiquidator
1463    * @param liquidator The address of the liquidator
1464    * @param receiveAToken `true` if the liquidators wants to receive the collateral aTokens, `false` if he wants
1465    * to receive the underlying collateral asset directly
1466    **/
1467   event LiquidationCall(
1468     address indexed collateralAsset,
1469     address indexed debtAsset,
1470     address indexed user,
1471     uint256 debtToCover,
1472     uint256 liquidatedCollateralAmount,
1473     address liquidator,
1474     bool receiveAToken
1475   );
1476 
1477   /**
1478    * @dev Emitted when the state of a reserve is updated. NOTE: This event is actually declared
1479    * in the ReserveLogic library and emitted in the updateInterestRates() function. Since the function is internal,
1480    * the event will actually be fired by the LendingPool contract. The event is therefore replicated here so it
1481    * gets added to the LendingPool ABI
1482    * @param reserve The address of the underlying asset of the reserve
1483    * @param liquidityRate The new liquidity rate
1484    * @param stableBorrowRate The new stable borrow rate
1485    * @param variableBorrowRate The new variable borrow rate
1486    * @param liquidityIndex The new liquidity index
1487    * @param variableBorrowIndex The new variable borrow index
1488    **/
1489   event ReserveDataUpdated(
1490     address indexed reserve,
1491     uint256 liquidityRate,
1492     uint256 stableBorrowRate,
1493     uint256 variableBorrowRate,
1494     uint256 liquidityIndex,
1495     uint256 variableBorrowIndex
1496   );
1497 
1498   /**
1499    * @dev Deposits an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
1500    * - E.g. User deposits 100 USDC and gets in return 100 aUSDC
1501    * @param asset The address of the underlying asset to deposit
1502    * @param amount The amount to be deposited
1503    * @param onBehalfOf The address that will receive the aTokens, same as msg.sender if the user
1504    *   wants to receive them on his own wallet, or a different address if the beneficiary of aTokens
1505    *   is a different wallet
1506    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
1507    *   0 if the action is executed directly by the user, without any middle-man
1508    **/
1509   function deposit(
1510     address asset,
1511     uint256 amount,
1512     address onBehalfOf,
1513     uint16 referralCode
1514   ) external;
1515 
1516   /**
1517    * @dev Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
1518    * E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
1519    * @param asset The address of the underlying asset to withdraw
1520    * @param amount The underlying amount to be withdrawn
1521    *   - Send the value type(uint256).max in order to withdraw the whole aToken balance
1522    * @param to Address that will receive the underlying, same as msg.sender if the user
1523    *   wants to receive it on his own wallet, or a different address if the beneficiary is a
1524    *   different wallet
1525    **/
1526   function withdraw(
1527     address asset,
1528     uint256 amount,
1529     address to
1530   ) external;
1531 
1532   /**
1533    * @dev Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
1534    * already deposited enough collateral, or he was given enough allowance by a credit delegator on the
1535    * corresponding debt token (StableDebtToken or VariableDebtToken)
1536    * - E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
1537    *   and 100 stable/variable debt tokens, depending on the `interestRateMode`
1538    * @param asset The address of the underlying asset to borrow
1539    * @param amount The amount to be borrowed
1540    * @param interestRateMode The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable
1541    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
1542    *   0 if the action is executed directly by the user, without any middle-man
1543    * @param onBehalfOf Address of the user who will receive the debt. Should be the address of the borrower itself
1544    * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
1545    * if he has been given credit delegation allowance
1546    **/
1547   function borrow(
1548     address asset,
1549     uint256 amount,
1550     uint256 interestRateMode,
1551     uint16 referralCode,
1552     address onBehalfOf
1553   ) external;
1554 
1555   /**
1556    * @notice Repays a borrowed `amount` on a specific reserve, burning the equivalent debt tokens owned
1557    * - E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address
1558    * @param asset The address of the borrowed underlying asset previously borrowed
1559    * @param amount The amount to repay
1560    * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
1561    * @param rateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
1562    * @param onBehalfOf Address of the user who will get his debt reduced/removed. Should be the address of the
1563    * user calling the function if he wants to reduce/remove his own debt, or the address of any other
1564    * other borrower whose debt should be removed
1565    **/
1566   function repay(
1567     address asset,
1568     uint256 amount,
1569     uint256 rateMode,
1570     address onBehalfOf
1571   ) external;
1572 
1573   /**
1574    * @dev Allows a borrower to swap his debt between stable and variable mode, or viceversa
1575    * @param asset The address of the underlying asset borrowed
1576    * @param rateMode The rate mode that the user wants to swap to
1577    **/
1578   function swapBorrowRateMode(address asset, uint256 rateMode) external;
1579 
1580   /**
1581    * @dev Rebalances the stable interest rate of a user to the current stable rate defined on the reserve.
1582    * - Users can be rebalanced if the following conditions are satisfied:
1583    *     1. Usage ratio is above 95%
1584    *     2. the current deposit APY is below REBALANCE_UP_THRESHOLD * maxVariableBorrowRate, which means that too much has been
1585    *        borrowed at a stable rate and depositors are not earning enough
1586    * @param asset The address of the underlying asset borrowed
1587    * @param user The address of the user to be rebalanced
1588    **/
1589   function rebalanceStableBorrowRate(address asset, address user) external;
1590 
1591   /**
1592    * @dev Allows depositors to enable/disable a specific deposited asset as collateral
1593    * @param asset The address of the underlying asset deposited
1594    * @param useAsCollateral `true` if the user wants to use the deposit as collateral, `false` otherwise
1595    **/
1596   function setUserUseReserveAsCollateral(address asset, bool useAsCollateral) external;
1597 
1598   /**
1599    * @dev Function to liquidate a non-healthy position collateral-wise, with Health Factor below 1
1600    * - The caller (liquidator) covers `debtToCover` amount of debt of the user getting liquidated, and receives
1601    *   a proportionally amount of the `collateralAsset` plus a bonus to cover market risk
1602    * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
1603    * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
1604    * @param user The address of the borrower getting liquidated
1605    * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
1606    * @param receiveAToken `true` if the liquidators wants to receive the collateral aTokens, `false` if he wants
1607    * to receive the underlying collateral asset directly
1608    **/
1609   function liquidationCall(
1610     address collateralAsset,
1611     address debtAsset,
1612     address user,
1613     uint256 debtToCover,
1614     bool receiveAToken
1615   ) external;
1616 
1617   /**
1618    * @dev Allows smartcontracts to access the liquidity of the pool within one transaction,
1619    * as long as the amount taken plus a fee is returned.
1620    * IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept into consideration.
1621    * For further details please visit https://developers.aave.com
1622    * @param receiverAddress The address of the contract receiving the funds, implementing the IFlashLoanReceiver interface
1623    * @param assets The addresses of the assets being flash-borrowed
1624    * @param amounts The amounts amounts being flash-borrowed
1625    * @param modes Types of the debt to open if the flash loan is not returned:
1626    *   0 -> Don't open any debt, just revert if funds can't be transferred from the receiver
1627    *   1 -> Open debt at stable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
1628    *   2 -> Open debt at variable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
1629    * @param onBehalfOf The address  that will receive the debt in the case of using on `modes` 1 or 2
1630    * @param params Variadic packed params to pass to the receiver as extra information
1631    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
1632    *   0 if the action is executed directly by the user, without any middle-man
1633    **/
1634   function flashLoan(
1635     address receiverAddress,
1636     address[] calldata assets,
1637     uint256[] calldata amounts,
1638     uint256[] calldata modes,
1639     address onBehalfOf,
1640     bytes calldata params,
1641     uint16 referralCode
1642   ) external;
1643 
1644   /**
1645    * @dev Returns the user account data across all the reserves
1646    * @param user The address of the user
1647    * @return totalCollateralETH the total collateral in ETH of the user
1648    * @return totalDebtETH the total debt in ETH of the user
1649    * @return availableBorrowsETH the borrowing power left of the user
1650    * @return currentLiquidationThreshold the liquidation threshold of the user
1651    * @return ltv the loan to value of the user
1652    * @return healthFactor the current health factor of the user
1653    **/
1654   function getUserAccountData(address user)
1655     external
1656     view
1657     returns (
1658       uint256 totalCollateralETH,
1659       uint256 totalDebtETH,
1660       uint256 availableBorrowsETH,
1661       uint256 currentLiquidationThreshold,
1662       uint256 ltv,
1663       uint256 healthFactor
1664     );
1665 
1666   function initReserve(
1667     address reserve,
1668     address aTokenAddress,
1669     address stableDebtAddress,
1670     address variableDebtAddress,
1671     address interestRateStrategyAddress
1672   ) external;
1673 
1674   function setReserveInterestRateStrategyAddress(address reserve, address rateStrategyAddress)
1675     external;
1676 
1677   function setConfiguration(address reserve, uint256 configuration) external;
1678 
1679   /**
1680    * @dev Returns the configuration of the reserve
1681    * @param asset The address of the underlying asset of the reserve
1682    * @return The configuration of the reserve
1683    **/
1684   function getConfiguration(address asset) external view returns (DataTypes.ReserveConfigurationMap memory);
1685 
1686   /**
1687    * @dev Returns the configuration of the user across all the reserves
1688    * @param user The user address
1689    * @return The configuration of the user
1690    **/
1691   function getUserConfiguration(address user) external view returns (DataTypes.UserConfigurationMap memory);
1692 
1693   /**
1694    * @dev Returns the normalized income normalized income of the reserve
1695    * @param asset The address of the underlying asset of the reserve
1696    * @return The reserve's normalized income
1697    */
1698   function getReserveNormalizedIncome(address asset) external view returns (uint256);
1699 
1700   /**
1701    * @dev Returns the normalized variable debt per unit of asset
1702    * @param asset The address of the underlying asset of the reserve
1703    * @return The reserve normalized variable debt
1704    */
1705   function getReserveNormalizedVariableDebt(address asset) external view returns (uint256);
1706 
1707   /**
1708    * @dev Returns the state and configuration of the reserve
1709    * @param asset The address of the underlying asset of the reserve
1710    * @return The state of the reserve
1711    **/
1712   function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);
1713 
1714   function finalizeTransfer(
1715     address asset,
1716     address from,
1717     address to,
1718     uint256 amount,
1719     uint256 balanceFromAfter,
1720     uint256 balanceToBefore
1721   ) external;
1722 
1723   function getReservesList() external view returns (address[] memory);
1724 
1725   function getAddressesProvider() external view returns (ILendingPoolAddressesProviderV2);
1726 
1727   function setPause(bool val) external;
1728 
1729   function paused() external view returns (bool);
1730 }
1731 
1732 
1733 interface IFlashLoans {
1734     function flashLoan(
1735         address recipient,
1736         address[] memory tokens,
1737         uint256[] memory amounts,
1738         bytes memory userData
1739     ) external;
1740 }
1741 
1742  
1743 
1744 abstract contract IAaveProtocolDataProviderV2 {
1745 
1746   struct TokenData {
1747     string symbol;
1748     address tokenAddress;
1749   }
1750 
1751   function getAllReservesTokens() external virtual view returns (TokenData[] memory);
1752 
1753   function getAllATokens() external virtual view returns (TokenData[] memory);
1754 
1755   function getReserveConfigurationData(address asset)
1756     external virtual
1757     view
1758     returns (
1759       uint256 decimals,
1760       uint256 ltv,
1761       uint256 liquidationThreshold,
1762       uint256 liquidationBonus,
1763       uint256 reserveFactor,
1764       bool usageAsCollateralEnabled,
1765       bool borrowingEnabled,
1766       bool stableBorrowRateEnabled,
1767       bool isActive,
1768       bool isFrozen
1769     );
1770 
1771   function getReserveData(address asset)
1772     external virtual
1773     view
1774     returns (
1775       uint256 availableLiquidity,
1776       uint256 totalStableDebt,
1777       uint256 totalVariableDebt,
1778       uint256 liquidityRate,
1779       uint256 variableBorrowRate,
1780       uint256 stableBorrowRate,
1781       uint256 averageStableBorrowRate,
1782       uint256 liquidityIndex,
1783       uint256 variableBorrowIndex,
1784       uint40 lastUpdateTimestamp
1785     );
1786 
1787   function getUserReserveData(address asset, address user)
1788     external virtual
1789     view
1790     returns (
1791       uint256 currentATokenBalance,
1792       uint256 currentStableDebt,
1793       uint256 currentVariableDebt,
1794       uint256 principalStableDebt,
1795       uint256 scaledVariableDebt,
1796       uint256 stableBorrowRate,
1797       uint256 liquidityRate,
1798       uint40 stableRateLastUpdated,
1799       bool usageAsCollateralEnabled
1800     );
1801 
1802   function getReserveTokensAddresses(address asset)
1803     external virtual
1804     view
1805     returns (
1806       address aTokenAddress,
1807       address stableDebtTokenAddress,
1808       address variableDebtTokenAddress
1809     );
1810 } /// @title Helper contract for getting AaveV2/Balancer flash loans
1811 contract FLHelper {
1812 
1813     address internal constant AAVE_MARKET_ADDR = 0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5;
1814     address internal constant BALANCER_VAULT_ADDR = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
1815     uint16 internal constant AAVE_REFERRAL_CODE = 64;
1816 
1817     address internal constant WETH_ADDR = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1818     address internal constant ETH_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1819 
1820     enum FLType {
1821         AAVE_V2,
1822         BALANCER,
1823         NO_LOAN
1824     }
1825 
1826     function _getFL(
1827         FLType _flType,
1828         address _tokenAddr,
1829         uint256 _flAmount,
1830         bytes memory _callData,
1831         address _receiverAddr
1832     ) internal {
1833         _tokenAddr = _tokenAddr== ETH_ADDR ? WETH_ADDR: _tokenAddr;
1834 
1835         address[] memory tokens = new address[](1);
1836         tokens[0] = _tokenAddr;
1837 
1838         uint256[] memory amounts = new uint256[](1);
1839         amounts[0] = _flAmount;
1840 
1841         if (_flType == FLType.AAVE_V2) {
1842             address lendingPool = ILendingPoolAddressesProviderV2(AAVE_MARKET_ADDR)
1843                 .getLendingPool();
1844 
1845             uint256[] memory modes = new uint256[](1);
1846             modes[0] = 0;
1847 
1848             ILendingPoolV2(lendingPool).flashLoan(
1849                 _receiverAddr,
1850                 tokens,
1851                 amounts,
1852                 modes,
1853                 address(this),
1854                 _callData,
1855                 AAVE_REFERRAL_CODE
1856             );
1857         } else {
1858             IFlashLoans(BALANCER_VAULT_ADDR).flashLoan(_receiverAddr, tokens, amounts, _callData);
1859         }
1860     }
1861 
1862     function getProtocolLiq(address _tokenAddr, uint256 _desiredAmount) public view returns (FLType flType) {
1863         uint256 flLiquidity = getFLLiquidity(FLType.BALANCER, _tokenAddr);
1864 
1865         if (flLiquidity >= _desiredAmount) return FLType.BALANCER;
1866 
1867         flLiquidity = getFLLiquidity(FLType.AAVE_V2, _tokenAddr);
1868 
1869         if (flLiquidity >= _desiredAmount) return FLType.AAVE_V2;
1870 
1871         return FLType.NO_LOAN;
1872     }
1873 
1874     function getFLLiquidity(FLType _flType, address _tokenAddr) public view returns (uint256 liquidity) {
1875         _tokenAddr = _tokenAddr== ETH_ADDR ? WETH_ADDR: _tokenAddr;
1876 
1877         if (_flType == FLType.AAVE_V2) {
1878             IAaveProtocolDataProviderV2 dataProvider = getDataProvider(AAVE_MARKET_ADDR);
1879             (liquidity, , , , , , , , , ) = dataProvider.getReserveData(_tokenAddr);
1880         } else {
1881             liquidity = ERC20(_tokenAddr).balanceOf(BALANCER_VAULT_ADDR);
1882         }
1883     }
1884 
1885     function getDataProvider(address _market) internal view returns (IAaveProtocolDataProviderV2) {
1886         return
1887             IAaveProtocolDataProviderV2(
1888                 ILendingPoolAddressesProviderV2(_market).getAddress(
1889                     0x0100000000000000000000000000000000000000000000000000000000000000
1890                 )
1891             );
1892     }
1893 
1894 }  
1895 
1896 
1897 
1898 
1899 
1900 
1901 
1902 
1903 
1904 
1905 
1906 
1907 /// @title Contract implements logic of calling boost/repay in the automatic system
1908 contract CompoundMonitor is AdminAuth, DSMath, CompoundSafetyRatio {
1909     using SafeERC20 for ERC20;
1910 
1911     enum Method {
1912         Boost,
1913         Repay
1914     }
1915 
1916     uint256 public MAX_GAS_PRICE = 800 gwei;
1917 
1918     uint256 public REPAY_GAS_COST = 1_500_000;
1919     uint256 public BOOST_GAS_COST = 1_000_000;
1920 
1921     address public constant DEFISAVER_LOGGER = 0x5c55B921f590a89C1Ebe84dF170E655a82b62126;
1922     address public constant BOT_REGISTRY_ADDRESS = 0x637726f8b08a7ABE3aE3aCaB01A80E2d8ddeF77B;
1923 
1924     CompoundMonitorProxy public compoundMonitorProxy = CompoundMonitorProxy(0xB1cF8DE8e791E4Ed1Bd86c03E2fc1f14389Cb10a);
1925     CompoundSubscriptions public subscriptionsContract = CompoundSubscriptions(0x52015EFFD577E08f498a0CCc11905925D58D6207);
1926     address public compoundFlashLoanTakerAddress;
1927     address internal compoundSaverFlashLoan;
1928 
1929     DefisaverLogger public logger = DefisaverLogger(DEFISAVER_LOGGER);
1930 
1931     modifier onlyApproved() {
1932         require(BotRegistry(BOT_REGISTRY_ADDRESS).botList(msg.sender), "Not auth bot");
1933         _;
1934     }
1935 
1936     /// @param _newCompoundFlashLoanTaker Contract that actually performs Repay/Boost
1937     /// @param _compoundSaverFlashLoan Intermediary contract used as input to _newCompoundFlashLoanTaker
1938     constructor(
1939         address _newCompoundFlashLoanTaker,
1940         address _compoundSaverFlashLoan
1941     ) public {
1942         compoundFlashLoanTakerAddress = _newCompoundFlashLoanTaker;
1943         compoundSaverFlashLoan = _compoundSaverFlashLoan;
1944     }
1945 
1946     /// @notice Bots call this method to repay for user when conditions are met
1947     /// @dev If the contract owns gas token it will try and use it for gas price reduction
1948     /// @param _exData Exchange data
1949     /// @param _cAddresses cTokens addresses and exchange [cCollAddress, cBorrowAddress, exchangeAddress]
1950     /// @param _user The actual address that owns the Compound position
1951     /// @param _flType Type of Flashloan we want to use 0 - AAVE_V2, 1 - Balancer
1952     function repayFor(
1953         DFSExchangeData.ExchangeData memory _exData,
1954         address[2] memory _cAddresses, // cCollAddress, cBorrowAddress
1955         address _user,
1956         FLHelper.FLType _flType
1957     ) public payable onlyApproved {
1958         bool isAllowed;
1959         uint256 ratioBefore;
1960         string memory errReason;
1961 
1962         CompoundSubscriptions.CompoundHolder memory holder = subscriptionsContract.getHolder(_user);
1963 
1964         (isAllowed, ratioBefore, errReason) = checkPreconditions(holder, Method.Repay, _user);
1965         require(isAllowed, errReason); // check if conditions are met
1966 
1967         uint256 gasCost = calcGasCost(REPAY_GAS_COST);
1968 
1969         compoundMonitorProxy.callExecute{value: msg.value}(
1970             _user,
1971             compoundFlashLoanTakerAddress,
1972             abi.encodeWithSignature(
1973                 "repayWithLoan((address,address,uint256,uint256,uint256,uint256,address,address,bytes,(address,address,address,uint256,uint256,bytes)),address[2],uint256,uint8,address)",
1974                 _exData,
1975                 _cAddresses,
1976                 gasCost,
1977                 _flType,
1978                 compoundSaverFlashLoan
1979             )
1980         );
1981 
1982         bool isGoodRatio;
1983         uint256 ratioAfter;
1984 
1985         (isGoodRatio, ratioAfter, errReason) = ratioGoodAfter(
1986             holder,
1987             Method.Repay,
1988             _user,
1989             ratioBefore
1990         );
1991         require(isGoodRatio, errReason); // check if the after result of the actions is good
1992 
1993         returnEth();
1994 
1995         logger.Log(
1996             address(this),
1997             _user,
1998             "AutomaticCompoundRepay",
1999             abi.encode(ratioBefore, ratioAfter)
2000         );
2001     }
2002 
2003     /// @notice Bots call this method to boost for user when conditions are met
2004     /// @dev If the contract owns gas token it will try and use it for gas price reduction
2005     /// @param _exData Exchange data
2006     /// @param _cAddresses cTokens addresses and exchange [cCollAddress, cBorrowAddress, exchangeAddress]
2007     /// @param _user The actual address that owns the Compound position
2008     /// @param _flType Type of Flashloan we want to use 0 - AAVE_V2, 1 - Balancer
2009     function boostFor(
2010         DFSExchangeData.ExchangeData memory _exData,
2011         address[2] memory _cAddresses, // cCollAddress, cBorrowAddress
2012         address _user,
2013         FLHelper.FLType _flType
2014     ) public payable onlyApproved {
2015         string memory errReason;
2016         bool isAllowed;
2017         uint256 ratioBefore;
2018 
2019         CompoundSubscriptions.CompoundHolder memory holder = subscriptionsContract.getHolder(_user);
2020 
2021         (isAllowed, ratioBefore, errReason) = checkPreconditions(holder, Method.Boost, _user);
2022         require(isAllowed, errReason); // check if conditions are met
2023 
2024         uint256 gasCost = calcGasCost(BOOST_GAS_COST);
2025 
2026         compoundMonitorProxy.callExecute{value: msg.value}(
2027             _user,
2028             compoundFlashLoanTakerAddress,
2029             abi.encodeWithSignature(
2030                 "boostWithLoan((address,address,uint256,uint256,uint256,uint256,address,address,bytes,(address,address,address,uint256,uint256,bytes)),address[2],uint256,uint8,address)",
2031                 _exData,
2032                 _cAddresses,
2033                 gasCost,
2034                 _flType,
2035                 compoundSaverFlashLoan
2036             )
2037         );
2038 
2039         bool isGoodRatio;
2040         uint256 ratioAfter;
2041 
2042         (isGoodRatio, ratioAfter, errReason) = ratioGoodAfter(
2043             holder,
2044             Method.Boost,
2045             _user,
2046             ratioBefore
2047         );
2048         require(isGoodRatio, errReason); // check if the after result of the actions is good
2049 
2050         returnEth();
2051 
2052         logger.Log(
2053             address(this),
2054             _user,
2055             "AutomaticCompoundBoost",
2056             abi.encode(ratioBefore, ratioAfter)
2057         );
2058     }
2059 
2060     /******************* INTERNAL METHODS ********************************/
2061     function returnEth() internal {
2062         // return if some eth left
2063         if (address(this).balance > 0) {
2064             msg.sender.transfer(address(this).balance);
2065         }
2066     }
2067 
2068     /******************* STATIC METHODS ********************************/
2069 
2070     /// @notice Checks if Boost/Repay could be triggered for the CDP
2071     /// @dev Called by MCDMonitor to enforce the min/max check
2072     /// @param _method Type of action to be called
2073     /// @param _user The actual address that owns the Compound position
2074     /// @return Boolean if it can be called and the ratio
2075     function checkPreconditions(
2076         CompoundSubscriptions.CompoundHolder memory _holder,
2077         Method _method,
2078         address _user
2079     )
2080         public
2081         view
2082         returns (
2083             bool,
2084             uint256,
2085             string memory
2086         )
2087     {
2088         bool subscribed = subscriptionsContract.isSubscribed(_user);
2089 
2090         // check if user is subscribed
2091         if (!subscribed) return (false, 0, "User not subbed");
2092 
2093         // check if boost and boost allowed
2094         if (_method == Method.Boost && !_holder.boostEnabled)
2095             return (false, 0, "Boost not enabled");
2096 
2097         uint256 currRatio = getSafetyRatio(_user);
2098 
2099         if (_method == Method.Repay) {
2100             if (currRatio > _holder.minRatio) return (false, 0, "Ratio not under min");
2101         } else if (_method == Method.Boost) {
2102             if (currRatio < _holder.maxRatio) return (false, 0, "Ratio not over max");
2103         }
2104 
2105         return (true, currRatio, "");
2106     }
2107 
2108     /// @dev After the Boost/Repay check if the ratio doesn't trigger another call
2109     /// @param _method Type of action to be called
2110     /// @param _user The actual address that owns the Compound position
2111     /// @param _beforeRatio Ratio before boost
2112     /// @return Boolean if the recent action preformed correctly and the ratio
2113     function ratioGoodAfter(
2114         CompoundSubscriptions.CompoundHolder memory _holder,
2115         Method _method,
2116         address _user,
2117         uint256 _beforeRatio
2118     )
2119         public
2120         view
2121         returns (
2122             bool,
2123             uint256,
2124             string memory
2125         )
2126     {
2127         uint256 currRatio = getSafetyRatio(_user);
2128 
2129         if (_method == Method.Repay) {
2130             if (currRatio >= _holder.maxRatio)
2131                 return (false, currRatio, "Repay increased ratio over max");
2132             if (currRatio <= _beforeRatio) return (false, currRatio, "Repay made ratio worse");
2133         } else if (_method == Method.Boost) {
2134             if (currRatio <= _holder.minRatio)
2135                 return (false, currRatio, "Boost lowered ratio over min");
2136             if (currRatio >= _beforeRatio) return (false, currRatio, "Boost didn't lower ratio");
2137         }
2138 
2139         return (true, currRatio, "");
2140     }
2141 
2142     /// @notice Calculates gas cost (in Eth) of tx
2143     /// @dev Gas price is limited to MAX_GAS_PRICE to prevent attack of draining user CDP
2144     /// @param _gasAmount Amount of gas used for the tx
2145     function calcGasCost(uint256 _gasAmount) public view returns (uint256) {
2146         uint256 gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;
2147 
2148         return mul(gasPrice, _gasAmount);
2149     }
2150 
2151     /******************* OWNER ONLY OPERATIONS ********************************/
2152 
2153     /// @notice Allows owner to change gas cost for boost operation, but only up to 3 millions
2154     /// @param _gasCost New gas cost for boost method
2155     function changeBoostGasCost(uint256 _gasCost) public onlyOwner {
2156         require(_gasCost < 3_000_000, "Boost gas cost over limit");
2157 
2158         BOOST_GAS_COST = _gasCost;
2159     }
2160 
2161     /// @notice Allows owner to change gas cost for repay operation, but only up to 3 millions
2162     /// @param _gasCost New gas cost for repay method
2163     function changeRepayGasCost(uint256 _gasCost) public onlyOwner {
2164         require(_gasCost < 3_000_000, "Repay gas cost over limit");
2165 
2166         REPAY_GAS_COST = _gasCost;
2167     }
2168 
2169     /// @notice Owner can change the maximum the contract can take for gas price
2170     /// @param _maxGasPrice New Max gas price
2171     function changeMaxGasPrice(uint256 _maxGasPrice) public onlyOwner {
2172         require(_maxGasPrice < 2000 gwei, "Max gas price over the limit");
2173 
2174         MAX_GAS_PRICE = _maxGasPrice;
2175     }
2176 }