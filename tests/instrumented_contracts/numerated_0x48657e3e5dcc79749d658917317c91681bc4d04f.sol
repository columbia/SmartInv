1 pragma solidity ^0.6.0; 
2 pragma experimental ABIEncoderV2;
3 
4  interface ERC20 {
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
22 }  library Address {
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
81 }  library SafeMath {
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
134 }  library SafeERC20 {
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
173 }  contract AdminAuth {
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
191         owner = msg.sender;
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
233 }  contract BotRegistry is AdminAuth {
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
250 }  abstract contract GasTokenInterface is ERC20 {
251     function free(uint256 value) public virtual returns (bool success);
252 
253     function freeUpTo(uint256 value) public virtual returns (uint256 freed);
254 
255     function freeFrom(address from, uint256 value) public virtual returns (bool success);
256 
257     function freeFromUpTo(address from, uint256 value) public virtual returns (uint256 freed);
258 }  contract GasBurner {
259     // solhint-disable-next-line const-name-snakecase
260     GasTokenInterface public constant gasToken = GasTokenInterface(0x0000000000b3F879cb30FE243b4Dfee438691c04);
261 
262     modifier burnGas(uint _amount) {
263         if (gasToken.balanceOf(address(this)) >= _amount) {
264             gasToken.free(_amount);
265         }
266 
267         _;
268     }
269 }  abstract contract DSProxyInterface {
270 
271     /// Truffle wont compile if this isn't commented
272     // function execute(bytes memory _code, bytes memory _data)
273     //     public virtual
274     //     payable
275     //     returns (address, bytes32);
276 
277     function execute(address _target, bytes memory _data) public virtual payable returns (bytes32);
278 
279     function setCache(address _cacheAddr) public virtual payable returns (bool);
280 
281     function owner() public virtual returns (address);
282 }  /// @title Contract with the actuall DSProxy permission calls the automation operations
283 contract CompoundMonitorProxy is AdminAuth {
284 
285     using SafeERC20 for ERC20;
286 
287     uint public CHANGE_PERIOD;
288     address public monitor;
289     address public newMonitor;
290     address public lastMonitor;
291     uint public changeRequestedTimestamp;
292 
293     mapping(address => bool) public allowed;
294 
295     event MonitorChangeInitiated(address oldMonitor, address newMonitor);
296     event MonitorChangeCanceled();
297     event MonitorChangeFinished(address monitor);
298     event MonitorChangeReverted(address monitor);
299 
300     // if someone who is allowed become malicious, owner can't be changed
301     modifier onlyAllowed() {
302         require(allowed[msg.sender] || msg.sender == owner);
303         _;
304     }
305 
306     modifier onlyMonitor() {
307         require (msg.sender == monitor);
308         _;
309     }
310 
311     constructor(uint _changePeriod) public {
312         CHANGE_PERIOD = _changePeriod * 1 days;
313     }
314 
315     /// @notice Only monitor contract is able to call execute on users proxy
316     /// @param _owner Address of cdp owner (users DSProxy address)
317     /// @param _compoundSaverProxy Address of CompoundSaverProxy
318     /// @param _data Data to send to CompoundSaverProxy
319     function callExecute(address _owner, address _compoundSaverProxy, bytes memory _data) public payable onlyMonitor {
320         // execute reverts if calling specific method fails
321         DSProxyInterface(_owner).execute{value: msg.value}(_compoundSaverProxy, _data);
322 
323         // return if anything left
324         if (address(this).balance > 0) {
325             msg.sender.transfer(address(this).balance);
326         }
327     }
328 
329     /// @notice Allowed users are able to set Monitor contract without any waiting period first time
330     /// @param _monitor Address of Monitor contract
331     function setMonitor(address _monitor) public onlyAllowed {
332         require(monitor == address(0));
333         monitor = _monitor;
334     }
335 
336     /// @notice Allowed users are able to start procedure for changing monitor
337     /// @dev after CHANGE_PERIOD needs to call confirmNewMonitor to actually make a change
338     /// @param _newMonitor address of new monitor
339     function changeMonitor(address _newMonitor) public onlyAllowed {
340         require(changeRequestedTimestamp == 0);
341 
342         changeRequestedTimestamp = now;
343         lastMonitor = monitor;
344         newMonitor = _newMonitor;
345 
346         emit MonitorChangeInitiated(lastMonitor, newMonitor);
347     }
348 
349     /// @notice At any point allowed users are able to cancel monitor change
350     function cancelMonitorChange() public onlyAllowed {
351         require(changeRequestedTimestamp > 0);
352 
353         changeRequestedTimestamp = 0;
354         newMonitor = address(0);
355 
356         emit MonitorChangeCanceled();
357     }
358 
359     /// @notice Anyone is able to confirm new monitor after CHANGE_PERIOD if process is started
360     function confirmNewMonitor() public onlyAllowed {
361         require((changeRequestedTimestamp + CHANGE_PERIOD) < now);
362         require(changeRequestedTimestamp != 0);
363         require(newMonitor != address(0));
364 
365         monitor = newMonitor;
366         newMonitor = address(0);
367         changeRequestedTimestamp = 0;
368 
369         emit MonitorChangeFinished(monitor);
370     }
371 
372     /// @notice Its possible to revert monitor to last used monitor
373     function revertMonitor() public onlyAllowed {
374         require(lastMonitor != address(0));
375 
376         monitor = lastMonitor;
377 
378         emit MonitorChangeReverted(monitor);
379     }
380 
381 
382     /// @notice Allowed users are able to add new allowed user
383     /// @param _user Address of user that will be allowed
384     function addAllowed(address _user) public onlyAllowed {
385         allowed[_user] = true;
386     }
387 
388     /// @notice Allowed users are able to remove allowed user
389     /// @dev owner is always allowed even if someone tries to remove it from allowed mapping
390     /// @param _user Address of allowed user
391     function removeAllowed(address _user) public onlyAllowed {
392         allowed[_user] = false;
393     }
394 
395     function setChangePeriod(uint _periodInDays) public onlyAllowed {
396         require(_periodInDays * 1 days > CHANGE_PERIOD);
397 
398         CHANGE_PERIOD = _periodInDays * 1 days;
399     }
400 
401     /// @notice In case something is left in contract, owner is able to withdraw it
402     /// @param _token address of token to withdraw balance
403     function withdrawToken(address _token) public onlyOwner {
404         uint balance = ERC20(_token).balanceOf(address(this));
405         ERC20(_token).safeTransfer(msg.sender, balance);
406     }
407 
408     /// @notice In case something is left in contract, owner is able to withdraw it
409     function withdrawEth() public onlyOwner {
410         uint balance = address(this).balance;
411         msg.sender.transfer(balance);
412     }
413 }  
414 
415 
416 
417 /// @title Stores subscription information for Compound automatization
418 contract CompoundSubscriptions is AdminAuth {
419 
420     struct CompoundHolder {
421         address user;
422         uint128 minRatio;
423         uint128 maxRatio;
424         uint128 optimalRatioBoost;
425         uint128 optimalRatioRepay;
426         bool boostEnabled;
427     }
428 
429     struct SubPosition {
430         uint arrPos;
431         bool subscribed;
432     }
433 
434     CompoundHolder[] public subscribers;
435     mapping (address => SubPosition) public subscribersPos;
436 
437     uint public changeIndex;
438 
439     event Subscribed(address indexed user);
440     event Unsubscribed(address indexed user);
441     event Updated(address indexed user);
442     event ParamUpdates(address indexed user, uint128, uint128, uint128, uint128, bool);
443 
444     /// @dev Called by the DSProxy contract which owns the Compound position
445     /// @notice Adds the users Compound poistion in the list of subscriptions so it can be monitored
446     /// @param _minRatio Minimum ratio below which repay is triggered
447     /// @param _maxRatio Maximum ratio after which boost is triggered
448     /// @param _optimalBoost Ratio amount which boost should target
449     /// @param _optimalRepay Ratio amount which repay should target
450     /// @param _boostEnabled Boolean determing if boost is enabled
451     function subscribe(uint128 _minRatio, uint128 _maxRatio, uint128 _optimalBoost, uint128 _optimalRepay, bool _boostEnabled) external {
452 
453         // if boost is not enabled, set max ratio to max uint
454         uint128 localMaxRatio = _boostEnabled ? _maxRatio : uint128(-1);
455         require(checkParams(_minRatio, localMaxRatio), "Must be correct params");
456 
457         SubPosition storage subInfo = subscribersPos[msg.sender];
458 
459         CompoundHolder memory subscription = CompoundHolder({
460                 minRatio: _minRatio,
461                 maxRatio: localMaxRatio,
462                 optimalRatioBoost: _optimalBoost,
463                 optimalRatioRepay: _optimalRepay,
464                 user: msg.sender,
465                 boostEnabled: _boostEnabled
466             });
467 
468         changeIndex++;
469 
470         if (subInfo.subscribed) {
471             subscribers[subInfo.arrPos] = subscription;
472 
473             emit Updated(msg.sender);
474             emit ParamUpdates(msg.sender, _minRatio, localMaxRatio, _optimalBoost, _optimalRepay, _boostEnabled);
475         } else {
476             subscribers.push(subscription);
477 
478             subInfo.arrPos = subscribers.length - 1;
479             subInfo.subscribed = true;
480 
481             emit Subscribed(msg.sender);
482         }
483     }
484 
485     /// @notice Called by the users DSProxy
486     /// @dev Owner who subscribed cancels his subscription
487     function unsubscribe() external {
488         _unsubscribe(msg.sender);
489     }
490 
491     /// @dev Checks limit if minRatio is bigger than max
492     /// @param _minRatio Minimum ratio, bellow which repay can be triggered
493     /// @param _maxRatio Maximum ratio, over which boost can be triggered
494     /// @return Returns bool if the params are correct
495     function checkParams(uint128 _minRatio, uint128 _maxRatio) internal pure returns (bool) {
496 
497         if (_minRatio > _maxRatio) {
498             return false;
499         }
500 
501         return true;
502     }
503 
504     /// @dev Internal method to remove a subscriber from the list
505     /// @param _user The actual address that owns the Compound position
506     function _unsubscribe(address _user) internal {
507         require(subscribers.length > 0, "Must have subscribers in the list");
508 
509         SubPosition storage subInfo = subscribersPos[_user];
510 
511         require(subInfo.subscribed, "Must first be subscribed");
512 
513         address lastOwner = subscribers[subscribers.length - 1].user;
514 
515         SubPosition storage subInfo2 = subscribersPos[lastOwner];
516         subInfo2.arrPos = subInfo.arrPos;
517 
518         subscribers[subInfo.arrPos] = subscribers[subscribers.length - 1];
519         subscribers.pop(); // remove last element and reduce arr length
520 
521         changeIndex++;
522         subInfo.subscribed = false;
523         subInfo.arrPos = 0;
524 
525         emit Unsubscribed(msg.sender);
526     }
527 
528     /// @dev Checks if the user is subscribed
529     /// @param _user The actual address that owns the Compound position
530     /// @return If the user is subscribed
531     function isSubscribed(address _user) public view returns (bool) {
532         SubPosition storage subInfo = subscribersPos[_user];
533 
534         return subInfo.subscribed;
535     }
536 
537     /// @dev Returns subscribtion information about a user
538     /// @param _user The actual address that owns the Compound position
539     /// @return Subscription information about the user if exists
540     function getHolder(address _user) public view returns (CompoundHolder memory) {
541         SubPosition storage subInfo = subscribersPos[_user];
542 
543         return subscribers[subInfo.arrPos];
544     }
545 
546     /// @notice Helper method to return all the subscribed CDPs
547     /// @return List of all subscribers
548     function getSubscribers() public view returns (CompoundHolder[] memory) {
549         return subscribers;
550     }
551 
552     /// @notice Helper method for the frontend, returns all the subscribed CDPs paginated
553     /// @param _page What page of subscribers you want
554     /// @param _perPage Number of entries per page
555     /// @return List of all subscribers for that page
556     function getSubscribersByPage(uint _page, uint _perPage) public view returns (CompoundHolder[] memory) {
557         CompoundHolder[] memory holders = new CompoundHolder[](_perPage);
558 
559         uint start = _page * _perPage;
560         uint end = start + _perPage;
561 
562         end = (end > holders.length) ? holders.length : end;
563 
564         uint count = 0;
565         for (uint i = start; i < end; i++) {
566             holders[count] = subscribers[i];
567             count++;
568         }
569 
570         return holders;
571     }
572 
573     ////////////// ADMIN METHODS ///////////////////
574 
575     /// @notice Admin function to unsubscribe a CDP
576     /// @param _user The actual address that owns the Compound position
577     function unsubscribeByAdmin(address _user) public onlyOwner {
578         SubPosition storage subInfo = subscribersPos[_user];
579 
580         if (subInfo.subscribed) {
581             _unsubscribe(_user);
582         }
583     }
584 }  contract DSMath {
585     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
586         require((z = x + y) >= x);
587     }
588 
589     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
590         require((z = x - y) <= x);
591     }
592 
593     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
594         require(y == 0 || (z = x * y) / y == x);
595     }
596 
597     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
598         return x / y;
599     }
600 
601     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
602         return x <= y ? x : y;
603     }
604 
605     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
606         return x >= y ? x : y;
607     }
608 
609     function imin(int256 x, int256 y) internal pure returns (int256 z) {
610         return x <= y ? x : y;
611     }
612 
613     function imax(int256 x, int256 y) internal pure returns (int256 z) {
614         return x >= y ? x : y;
615     }
616 
617     uint256 constant WAD = 10**18;
618     uint256 constant RAY = 10**27;
619 
620     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
621         z = add(mul(x, y), WAD / 2) / WAD;
622     }
623 
624     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
625         z = add(mul(x, y), RAY / 2) / RAY;
626     }
627 
628     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
629         z = add(mul(x, WAD), y / 2) / y;
630     }
631 
632     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
633         z = add(mul(x, RAY), y / 2) / y;
634     }
635 
636     // This famous algorithm is called "exponentiation by squaring"
637     // and calculates x^n with x as fixed-point and n as regular unsigned.
638     //
639     // It's O(log n), instead of O(n) for naive repeated multiplication.
640     //
641     // These facts are why it works:
642     //
643     //  If n is even, then x^n = (x^2)^(n/2).
644     //  If n is odd,  then x^n = x * x^(n-1),
645     //   and applying the equation for even x gives
646     //    x^n = x * (x^2)^((n-1) / 2).
647     //
648     //  Also, EVM division is flooring and
649     //    floor[(n-1) / 2] = floor[n / 2].
650     //
651     function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
652         z = n % 2 != 0 ? x : RAY;
653 
654         for (n /= 2; n != 0; n /= 2) {
655             x = rmul(x, x);
656 
657             if (n % 2 != 0) {
658                 z = rmul(z, x);
659             }
660         }
661     }
662 }  contract DefisaverLogger {
663     event LogEvent(
664         address indexed contractAddress,
665         address indexed caller,
666         string indexed logName,
667         bytes data
668     );
669 
670     // solhint-disable-next-line func-name-mixedcase
671     function Log(address _contract, address _caller, string memory _logName, bytes memory _data)
672         public
673     {
674         emit LogEvent(_contract, _caller, _logName, _data);
675     }
676 }  abstract contract CompoundOracleInterface {
677     function getUnderlyingPrice(address cToken) external view virtual returns (uint);
678 }     
679 
680 abstract contract ComptrollerInterface {
681     struct CompMarketState {
682         uint224 index;
683         uint32 block;
684     }
685 
686     function claimComp(address holder) public virtual;
687     function claimComp(address holder, address[] memory cTokens) public virtual;
688     function claimComp(address[] memory holders, address[] memory cTokens, bool borrowers, bool suppliers) public virtual;
689 
690     function compSupplyState(address) public view virtual returns (CompMarketState memory);
691     function compSupplierIndex(address,address) public view virtual returns (uint);
692     function compAccrued(address) public view virtual returns (uint);
693 
694     function compBorrowState(address) public view virtual returns (CompMarketState memory);
695     function compBorrowerIndex(address,address) public view virtual returns (uint);
696 
697     function enterMarkets(address[] calldata cTokens) external virtual returns (uint256[] memory);
698 
699     function exitMarket(address cToken) external virtual returns (uint256);
700 
701     function getAssetsIn(address account) external virtual view returns (address[] memory);
702 
703     function markets(address account) public virtual view returns (bool, uint256);
704 
705     function getAccountLiquidity(address account) external virtual view returns (uint256, uint256, uint256);
706 
707     function oracle() public virtual view returns (address);
708 }  abstract contract CTokenInterface is ERC20 {
709     function mint(uint256 mintAmount) external virtual returns (uint256);
710 
711     // function mint() external virtual payable;
712 
713     function accrueInterest() public virtual returns (uint);
714 
715     function redeem(uint256 redeemTokens) external virtual returns (uint256);
716 
717     function redeemUnderlying(uint256 redeemAmount) external virtual returns (uint256);
718 
719     function borrow(uint256 borrowAmount) external virtual returns (uint256);
720     function borrowIndex() public view virtual returns (uint);
721     function borrowBalanceStored(address) public view virtual returns(uint);
722 
723     function repayBorrow(uint256 repayAmount) external virtual returns (uint256);
724 
725     function repayBorrow() external virtual payable;
726 
727     function repayBorrowBehalf(address borrower, uint256 repayAmount) external virtual returns (uint256);
728 
729     function repayBorrowBehalf(address borrower) external virtual payable;
730 
731     function liquidateBorrow(address borrower, uint256 repayAmount, address cTokenCollateral)
732         external virtual
733         returns (uint256);
734 
735     function liquidateBorrow(address borrower, address cTokenCollateral) external virtual payable;
736 
737     function exchangeRateCurrent() external virtual returns (uint256);
738 
739     function supplyRatePerBlock() external virtual returns (uint256);
740 
741     function borrowRatePerBlock() external virtual returns (uint256);
742 
743     function totalReserves() external virtual returns (uint256);
744 
745     function reserveFactorMantissa() external virtual returns (uint256);
746 
747     function borrowBalanceCurrent(address account) external virtual returns (uint256);
748 
749     function totalBorrowsCurrent() external virtual returns (uint256);
750 
751     function getCash() external virtual returns (uint256);
752 
753     function balanceOfUnderlying(address owner) external virtual returns (uint256);
754 
755     function underlying() external virtual returns (address);
756 
757     function getAccountSnapshot(address account) external virtual view returns (uint, uint, uint, uint);
758 }  contract CarefulMath {
759 
760     /**
761      * @dev Possible error codes that we can return
762      */
763     enum MathError {
764         NO_ERROR,
765         DIVISION_BY_ZERO,
766         INTEGER_OVERFLOW,
767         INTEGER_UNDERFLOW
768     }
769 
770     /**
771     * @dev Multiplies two numbers, returns an error on overflow.
772     */
773     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
774         if (a == 0) {
775             return (MathError.NO_ERROR, 0);
776         }
777 
778         uint c = a * b;
779 
780         if (c / a != b) {
781             return (MathError.INTEGER_OVERFLOW, 0);
782         } else {
783             return (MathError.NO_ERROR, c);
784         }
785     }
786 
787     /**
788     * @dev Integer division of two numbers, truncating the quotient.
789     */
790     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
791         if (b == 0) {
792             return (MathError.DIVISION_BY_ZERO, 0);
793         }
794 
795         return (MathError.NO_ERROR, a / b);
796     }
797 
798     /**
799     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
800     */
801     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
802         if (b <= a) {
803             return (MathError.NO_ERROR, a - b);
804         } else {
805             return (MathError.INTEGER_UNDERFLOW, 0);
806         }
807     }
808 
809     /**
810     * @dev Adds two numbers, returns an error on overflow.
811     */
812     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
813         uint c = a + b;
814 
815         if (c >= a) {
816             return (MathError.NO_ERROR, c);
817         } else {
818             return (MathError.INTEGER_OVERFLOW, 0);
819         }
820     }
821 
822     /**
823     * @dev add a and b and then subtract c
824     */
825     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
826         (MathError err0, uint sum) = addUInt(a, b);
827 
828         if (err0 != MathError.NO_ERROR) {
829             return (err0, 0);
830         }
831 
832         return subUInt(sum, c);
833     }
834 }  contract Exponential is CarefulMath {
835     uint constant expScale = 1e18;
836     uint constant doubleScale = 1e36;
837     uint constant halfExpScale = expScale/2;
838     uint constant mantissaOne = expScale;
839 
840     struct Exp {
841         uint mantissa;
842     }
843 
844     struct Double {
845         uint mantissa;
846     }
847 
848     /**
849      * @dev Creates an exponential from numerator and denominator values.
850      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
851      *            or if `denom` is zero.
852      */
853     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
854         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
855         if (err0 != MathError.NO_ERROR) {
856             return (err0, Exp({mantissa: 0}));
857         }
858 
859         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
860         if (err1 != MathError.NO_ERROR) {
861             return (err1, Exp({mantissa: 0}));
862         }
863 
864         return (MathError.NO_ERROR, Exp({mantissa: rational}));
865     }
866 
867     /**
868      * @dev Adds two exponentials, returning a new exponential.
869      */
870     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
871         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
872 
873         return (error, Exp({mantissa: result}));
874     }
875 
876     /**
877      * @dev Subtracts two exponentials, returning a new exponential.
878      */
879     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
880         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
881 
882         return (error, Exp({mantissa: result}));
883     }
884 
885     /**
886      * @dev Multiply an Exp by a scalar, returning a new Exp.
887      */
888     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
889         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
890         if (err0 != MathError.NO_ERROR) {
891             return (err0, Exp({mantissa: 0}));
892         }
893 
894         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
895     }
896 
897     /**
898      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
899      */
900     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
901         (MathError err, Exp memory product) = mulScalar(a, scalar);
902         if (err != MathError.NO_ERROR) {
903             return (err, 0);
904         }
905 
906         return (MathError.NO_ERROR, truncate(product));
907     }
908 
909     /**
910      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
911      */
912     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
913         (MathError err, Exp memory product) = mulScalar(a, scalar);
914         if (err != MathError.NO_ERROR) {
915             return (err, 0);
916         }
917 
918         return addUInt(truncate(product), addend);
919     }
920 
921     /**
922      * @dev Divide an Exp by a scalar, returning a new Exp.
923      */
924     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
925         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
926         if (err0 != MathError.NO_ERROR) {
927             return (err0, Exp({mantissa: 0}));
928         }
929 
930         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
931     }
932 
933     /**
934      * @dev Divide a scalar by an Exp, returning a new Exp.
935      */
936     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
937         /*
938           We are doing this as:
939           getExp(mulUInt(expScale, scalar), divisor.mantissa)
940 
941           How it works:
942           Exp = a / b;
943           Scalar = s;
944           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
945         */
946         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
947         if (err0 != MathError.NO_ERROR) {
948             return (err0, Exp({mantissa: 0}));
949         }
950         return getExp(numerator, divisor.mantissa);
951     }
952 
953     /**
954      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
955      */
956     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
957         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
958         if (err != MathError.NO_ERROR) {
959             return (err, 0);
960         }
961 
962         return (MathError.NO_ERROR, truncate(fraction));
963     }
964 
965     /**
966      * @dev Multiplies two exponentials, returning a new exponential.
967      */
968     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
969 
970         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
971         if (err0 != MathError.NO_ERROR) {
972             return (err0, Exp({mantissa: 0}));
973         }
974 
975         // We add half the scale before dividing so that we get rounding instead of truncation.
976         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
977         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
978         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
979         if (err1 != MathError.NO_ERROR) {
980             return (err1, Exp({mantissa: 0}));
981         }
982 
983         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
984         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
985         assert(err2 == MathError.NO_ERROR);
986 
987         return (MathError.NO_ERROR, Exp({mantissa: product}));
988     }
989 
990     /**
991      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
992      */
993     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
994         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
995     }
996 
997     /**
998      * @dev Multiplies three exponentials, returning a new exponential.
999      */
1000     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
1001         (MathError err, Exp memory ab) = mulExp(a, b);
1002         if (err != MathError.NO_ERROR) {
1003             return (err, ab);
1004         }
1005         return mulExp(ab, c);
1006     }
1007 
1008     /**
1009      * @dev Divides two exponentials, returning a new exponential.
1010      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
1011      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
1012      */
1013     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
1014         return getExp(a.mantissa, b.mantissa);
1015     }
1016 
1017     /**
1018      * @dev Truncates the given exp to a whole number value.
1019      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
1020      */
1021     function truncate(Exp memory exp) pure internal returns (uint) {
1022         // Note: We are not using careful math here as we're performing a division that cannot fail
1023         return exp.mantissa / expScale;
1024     }
1025 
1026     /**
1027      * @dev Checks if first Exp is less than second Exp.
1028      */
1029     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
1030         return left.mantissa < right.mantissa;
1031     }
1032 
1033     /**
1034      * @dev Checks if left Exp <= right Exp.
1035      */
1036     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
1037         return left.mantissa <= right.mantissa;
1038     }
1039 
1040     /**
1041      * @dev Checks if left Exp > right Exp.
1042      */
1043     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
1044         return left.mantissa > right.mantissa;
1045     }
1046 
1047     /**
1048      * @dev returns true if Exp is exactly zero
1049      */
1050     function isZeroExp(Exp memory value) pure internal returns (bool) {
1051         return value.mantissa == 0;
1052     }
1053 
1054     function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1055         return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
1056     }
1057 
1058     function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
1059         return Double({mantissa: sub_(a.mantissa, b.mantissa)});
1060     }
1061 
1062     function sub_(uint a, uint b) pure internal returns (uint) {
1063         return sub_(a, b, "subtraction underflow");
1064     }
1065 
1066     function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1067         require(b <= a, errorMessage);
1068         return a - b;
1069     }
1070 
1071     function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1072         return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
1073     }
1074 
1075     function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
1076         return Exp({mantissa: mul_(a.mantissa, b)});
1077     }
1078 
1079     function mul_(uint a, Exp memory b) pure internal returns (uint) {
1080         return mul_(a, b.mantissa) / expScale;
1081     }
1082 
1083     function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
1084         return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
1085     }
1086 
1087     function mul_(Double memory a, uint b) pure internal returns (Double memory) {
1088         return Double({mantissa: mul_(a.mantissa, b)});
1089     }
1090 
1091     function mul_(uint a, Double memory b) pure internal returns (uint) {
1092         return mul_(a, b.mantissa) / doubleScale;
1093     }
1094 
1095     function mul_(uint a, uint b) pure internal returns (uint) {
1096         return mul_(a, b, "multiplication overflow");
1097     }
1098 
1099     function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1100         if (a == 0 || b == 0) {
1101             return 0;
1102         }
1103         uint c = a * b;
1104         require(c / a == b, errorMessage);
1105         return c;
1106     }
1107 
1108     function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1109         return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
1110     }
1111 
1112     function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
1113         return Exp({mantissa: div_(a.mantissa, b)});
1114     }
1115 
1116     function div_(uint a, Exp memory b) pure internal returns (uint) {
1117         return div_(mul_(a, expScale), b.mantissa);
1118     }
1119 
1120     function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
1121         return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
1122     }
1123 
1124     function div_(Double memory a, uint b) pure internal returns (Double memory) {
1125         return Double({mantissa: div_(a.mantissa, b)});
1126     }
1127 
1128     function div_(uint a, Double memory b) pure internal returns (uint) {
1129         return div_(mul_(a, doubleScale), b.mantissa);
1130     }
1131 
1132     function div_(uint a, uint b) pure internal returns (uint) {
1133         return div_(a, b, "divide by zero");
1134     }
1135 
1136     function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1137         require(b > 0, errorMessage);
1138         return a / b;
1139     }
1140 
1141     function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1142         return Exp({mantissa: add_(a.mantissa, b.mantissa)});
1143     }
1144 
1145     function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
1146         return Double({mantissa: add_(a.mantissa, b.mantissa)});
1147     }
1148 
1149     function add_(uint a, uint b) pure internal returns (uint) {
1150         return add_(a, b, "addition overflow");
1151     }
1152 
1153     function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1154         uint c = a + b;
1155         require(c >= a, errorMessage);
1156         return c;
1157     }
1158 }  contract CompoundSafetyRatio is Exponential, DSMath {
1159     // solhint-disable-next-line const-name-snakecase
1160     ComptrollerInterface public constant comp = ComptrollerInterface(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
1161 
1162     /// @notice Calcualted the ratio of debt / adjusted collateral
1163     /// @param _user Address of the user
1164     function getSafetyRatio(address _user) public view returns (uint) {
1165         // For each asset the account is in
1166         address[] memory assets = comp.getAssetsIn(_user);
1167         address oracleAddr = comp.oracle();
1168 
1169 
1170         uint sumCollateral = 0;
1171         uint sumBorrow = 0;
1172 
1173         for (uint i = 0; i < assets.length; i++) {
1174             address asset = assets[i];
1175 
1176             (, uint cTokenBalance, uint borrowBalance, uint exchangeRateMantissa)
1177                                         = CTokenInterface(asset).getAccountSnapshot(_user);
1178 
1179             Exp memory oraclePrice;
1180 
1181             if (cTokenBalance != 0 || borrowBalance != 0) {
1182                 oraclePrice = Exp({mantissa: CompoundOracleInterface(oracleAddr).getUnderlyingPrice(asset)});
1183             }
1184 
1185             // Sum up collateral in Usd
1186             if (cTokenBalance != 0) {
1187 
1188                 (, uint collFactorMantissa) = comp.markets(address(asset));
1189 
1190                 Exp memory collateralFactor = Exp({mantissa: collFactorMantissa});
1191                 Exp memory exchangeRate = Exp({mantissa: exchangeRateMantissa});
1192 
1193                 (, Exp memory tokensToUsd) = mulExp3(collateralFactor, exchangeRate, oraclePrice);
1194 
1195                 (, sumCollateral) = mulScalarTruncateAddUInt(tokensToUsd, cTokenBalance, sumCollateral);
1196             }
1197 
1198             // Sum up debt in Usd
1199             if (borrowBalance != 0) {
1200                 (, sumBorrow) = mulScalarTruncateAddUInt(oraclePrice, borrowBalance, sumBorrow);
1201             }
1202         }
1203 
1204         if (sumBorrow == 0) return uint(-1);
1205 
1206         uint borrowPowerUsed = (sumBorrow * 10**18) / sumCollateral;
1207         return wdiv(1e18, borrowPowerUsed);
1208     }
1209 }  abstract contract TokenInterface {
1210     function allowance(address, address) public virtual returns (uint256);
1211 
1212     function balanceOf(address) public virtual returns (uint256);
1213 
1214     function approve(address, uint256) public virtual;
1215 
1216     function transfer(address, uint256) public virtual returns (bool);
1217 
1218     function transferFrom(address, address, uint256) public virtual returns (bool);
1219 
1220     function deposit() public virtual payable;
1221 
1222     function withdraw(uint256) public virtual;
1223 }  interface ExchangeInterfaceV2 {
1224     function sell(address _srcAddr, address _destAddr, uint _srcAmount) external payable returns (uint);
1225 
1226     function buy(address _srcAddr, address _destAddr, uint _destAmount) external payable returns(uint);
1227 
1228     function getSellRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);
1229 
1230     function getBuyRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);
1231 }  contract ZrxAllowlist is AdminAuth {
1232 
1233     mapping (address => bool) public zrxAllowlist;
1234     mapping(address => bool) private nonPayableAddrs;
1235 
1236     constructor() public {
1237         zrxAllowlist[0x6958F5e95332D93D21af0D7B9Ca85B8212fEE0A5] = true;
1238         zrxAllowlist[0x61935CbDd02287B511119DDb11Aeb42F1593b7Ef] = true;
1239         zrxAllowlist[0xDef1C0ded9bec7F1a1670819833240f027b25EfF] = true;
1240         zrxAllowlist[0x080bf510FCbF18b91105470639e9561022937712] = true;
1241 
1242         nonPayableAddrs[0x080bf510FCbF18b91105470639e9561022937712] = true;
1243     }
1244 
1245     function setAllowlistAddr(address _zrxAddr, bool _state) public onlyOwner {
1246         zrxAllowlist[_zrxAddr] = _state;
1247     }
1248 
1249     function isZrxAddr(address _zrxAddr) public view returns (bool) {
1250         return zrxAllowlist[_zrxAddr];
1251     }
1252 
1253     function addNonPayableAddr(address _nonPayableAddr) public onlyOwner {
1254 		nonPayableAddrs[_nonPayableAddr] = true;
1255 	}
1256 
1257 	function removeNonPayableAddr(address _nonPayableAddr) public onlyOwner {
1258 		nonPayableAddrs[_nonPayableAddr] = false;
1259 	}
1260 
1261 	function isNonPayableAddr(address _addr) public view returns(bool) {
1262 		return nonPayableAddrs[_addr];
1263 	}
1264 }  contract Discount {
1265     address public owner;
1266     mapping(address => CustomServiceFee) public serviceFees;
1267 
1268     uint256 constant MAX_SERVICE_FEE = 400;
1269 
1270     struct CustomServiceFee {
1271         bool active;
1272         uint256 amount;
1273     }
1274 
1275     constructor() public {
1276         owner = msg.sender;
1277     }
1278 
1279     function isCustomFeeSet(address _user) public view returns (bool) {
1280         return serviceFees[_user].active;
1281     }
1282 
1283     function getCustomServiceFee(address _user) public view returns (uint256) {
1284         return serviceFees[_user].amount;
1285     }
1286 
1287     function setServiceFee(address _user, uint256 _fee) public {
1288         require(msg.sender == owner, "Only owner");
1289         require(_fee >= MAX_SERVICE_FEE || _fee == 0);
1290 
1291         serviceFees[_user] = CustomServiceFee({active: true, amount: _fee});
1292     }
1293 
1294     function disableServiceFee(address _user) public {
1295         require(msg.sender == owner, "Only owner");
1296 
1297         serviceFees[_user] = CustomServiceFee({active: false, amount: 0});
1298     }
1299 }  contract SaverExchangeHelper {
1300 
1301     using SafeERC20 for ERC20;
1302 
1303     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1304     address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1305 
1306     address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
1307     address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;
1308     address public constant SAVER_EXCHANGE_REGISTRY = 0x25dd3F51e0C3c3Ff164DDC02A8E4D65Bb9cBB12D;
1309 
1310     address public constant ERC20_PROXY_0X = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
1311     address public constant ZRX_ALLOWLIST_ADDR = 0x4BA1f38427b33B8ab7Bb0490200dAE1F1C36823F;
1312 
1313 
1314     function getDecimals(address _token) internal view returns (uint256) {
1315         if (_token == KYBER_ETH_ADDRESS) return 18;
1316 
1317         return ERC20(_token).decimals();
1318     }
1319 
1320     function getBalance(address _tokenAddr) internal view returns (uint balance) {
1321         if (_tokenAddr == KYBER_ETH_ADDRESS) {
1322             balance = address(this).balance;
1323         } else {
1324             balance = ERC20(_tokenAddr).balanceOf(address(this));
1325         }
1326     }
1327 
1328     function approve0xProxy(address _tokenAddr, uint _amount) internal {
1329         if (_tokenAddr != KYBER_ETH_ADDRESS) {
1330             ERC20(_tokenAddr).safeApprove(address(ERC20_PROXY_0X), _amount);
1331         }
1332     }
1333 
1334     function sendLeftover(address _srcAddr, address _destAddr, address payable _to) internal {
1335         // send back any leftover ether or tokens
1336         if (address(this).balance > 0) {
1337             _to.transfer(address(this).balance);
1338         }
1339 
1340         if (getBalance(_srcAddr) > 0) {
1341             ERC20(_srcAddr).safeTransfer(_to, getBalance(_srcAddr));
1342         }
1343 
1344         if (getBalance(_destAddr) > 0) {
1345             ERC20(_destAddr).safeTransfer(_to, getBalance(_destAddr));
1346         }
1347     }
1348 
1349     function sliceUint(bytes memory bs, uint256 start) internal pure returns (uint256) {
1350         require(bs.length >= start + 32, "slicing out of range");
1351 
1352         uint256 x;
1353         assembly {
1354             x := mload(add(bs, add(0x20, start)))
1355         }
1356 
1357         return x;
1358     }
1359 }  contract SaverExchangeRegistry is AdminAuth {
1360 
1361 	mapping(address => bool) private wrappers;
1362 
1363 	constructor() public {
1364 		wrappers[0x880A845A85F843a5c67DB2061623c6Fc3bB4c511] = true;
1365 		wrappers[0x4c9B55f2083629A1F7aDa257ae984E03096eCD25] = true;
1366 		wrappers[0x42A9237b872368E1bec4Ca8D26A928D7d39d338C] = true;
1367 	}
1368 
1369 	function addWrapper(address _wrapper) public onlyOwner {
1370 		wrappers[_wrapper] = true;
1371 	}
1372 
1373 	function removeWrapper(address _wrapper) public onlyOwner {
1374 		wrappers[_wrapper] = false;
1375 	}
1376 
1377 	function isWrapper(address _wrapper) public view returns(bool) {
1378 		return wrappers[_wrapper];
1379 	}
1380 }     
1381 
1382 
1383 
1384 
1385 
1386 
1387 
1388 
1389 contract SaverExchangeCore is SaverExchangeHelper, DSMath {
1390 
1391     // first is empty to keep the legacy order in place
1392     enum ExchangeType { _, OASIS, KYBER, UNISWAP, ZEROX }
1393 
1394     enum ActionType { SELL, BUY }
1395 
1396     struct ExchangeData {
1397         address srcAddr;
1398         address destAddr;
1399         uint srcAmount;
1400         uint destAmount;
1401         uint minPrice;
1402         address wrapper;
1403         address exchangeAddr;
1404         bytes callData;
1405         uint256 price0x;
1406     }
1407 
1408     /// @notice Internal method that preforms a sell on 0x/on-chain
1409     /// @dev Usefull for other DFS contract to integrate for exchanging
1410     /// @param exData Exchange data struct
1411     /// @return (address, uint) Address of the wrapper used and destAmount
1412     function _sell(ExchangeData memory exData) internal returns (address, uint) {
1413 
1414         address wrapper;
1415         uint swapedTokens;
1416         bool success;
1417         uint tokensLeft = exData.srcAmount;
1418 
1419         // if selling eth, convert to weth
1420         if (exData.srcAddr == KYBER_ETH_ADDRESS) {
1421             exData.srcAddr = ethToWethAddr(exData.srcAddr);
1422             TokenInterface(WETH_ADDRESS).deposit.value(exData.srcAmount)();
1423         }
1424 
1425         // Try 0x first and then fallback on specific wrapper
1426         if (exData.price0x > 0) {
1427             approve0xProxy(exData.srcAddr, exData.srcAmount);
1428 
1429             uint ethAmount = getProtocolFee(exData.srcAddr, exData.srcAmount);
1430             (success, swapedTokens, tokensLeft) = takeOrder(exData, ethAmount, ActionType.SELL);
1431 
1432             if (success) {
1433                 wrapper = exData.exchangeAddr;
1434             }
1435         }
1436 
1437         // fallback to desired wrapper if 0x failed
1438         if (!success) {
1439             swapedTokens = saverSwap(exData, ActionType.SELL);
1440             wrapper = exData.wrapper;
1441         }
1442 
1443         require(getBalance(exData.destAddr) >= wmul(exData.minPrice, exData.srcAmount), "Final amount isn't correct");
1444 
1445         // if anything is left in weth, pull it to user as eth
1446         if (getBalance(WETH_ADDRESS) > 0) {
1447             TokenInterface(WETH_ADDRESS).withdraw(
1448                 TokenInterface(WETH_ADDRESS).balanceOf(address(this))
1449             );
1450         }
1451 
1452         return (wrapper, swapedTokens);
1453     }
1454 
1455     /// @notice Internal method that preforms a buy on 0x/on-chain
1456     /// @dev Usefull for other DFS contract to integrate for exchanging
1457     /// @param exData Exchange data struct
1458     /// @return (address, uint) Address of the wrapper used and srcAmount
1459     function _buy(ExchangeData memory exData) internal returns (address, uint) {
1460 
1461         address wrapper;
1462         uint swapedTokens;
1463         bool success;
1464 
1465         require(exData.destAmount != 0, "Dest amount must be specified");
1466 
1467         // if selling eth, convert to weth
1468         if (exData.srcAddr == KYBER_ETH_ADDRESS) {
1469             exData.srcAddr = ethToWethAddr(exData.srcAddr);
1470             TokenInterface(WETH_ADDRESS).deposit.value(exData.srcAmount)();
1471         }
1472 
1473         if (exData.price0x > 0) {
1474             approve0xProxy(exData.srcAddr, exData.srcAmount);
1475 
1476             uint ethAmount = getProtocolFee(exData.srcAddr, exData.srcAmount);
1477             (success, swapedTokens,) = takeOrder(exData, ethAmount, ActionType.BUY);
1478 
1479             if (success) {
1480                 wrapper = exData.exchangeAddr;
1481             }
1482         }
1483 
1484         // fallback to desired wrapper if 0x failed
1485         if (!success) {
1486             swapedTokens = saverSwap(exData, ActionType.BUY);
1487             wrapper = exData.wrapper;
1488         }
1489 
1490         require(getBalance(exData.destAddr) >= exData.destAmount, "Final amount isn't correct");
1491 
1492         // if anything is left in weth, pull it to user as eth
1493         if (getBalance(WETH_ADDRESS) > 0) {
1494             TokenInterface(WETH_ADDRESS).withdraw(
1495                 TokenInterface(WETH_ADDRESS).balanceOf(address(this))
1496             );
1497         }
1498 
1499         return (wrapper, getBalance(exData.destAddr));
1500     }
1501 
1502     /// @notice Takes order from 0x and returns bool indicating if it is successful
1503     /// @param _exData Exchange data
1504     /// @param _ethAmount Ether fee needed for 0x order
1505     function takeOrder(
1506         ExchangeData memory _exData,
1507         uint256 _ethAmount,
1508         ActionType _type
1509     ) private returns (bool success, uint256, uint256) {
1510 
1511         // write in the exact amount we are selling/buing in an order
1512         if (_type == ActionType.SELL) {
1513             writeUint256(_exData.callData, 36, _exData.srcAmount);
1514         } else {
1515             writeUint256(_exData.callData, 36, _exData.destAmount);
1516         }
1517 
1518         if (ZrxAllowlist(ZRX_ALLOWLIST_ADDR).isNonPayableAddr(_exData.exchangeAddr)) {
1519             _ethAmount = 0;
1520         }
1521 
1522         uint256 tokensBefore = getBalance(_exData.destAddr);
1523 
1524         if (ZrxAllowlist(ZRX_ALLOWLIST_ADDR).isZrxAddr(_exData.exchangeAddr)) {
1525             (success, ) = _exData.exchangeAddr.call{value: _ethAmount}(_exData.callData);
1526         } else {
1527             success = false;
1528         }
1529 
1530         uint256 tokensSwaped = 0;
1531         uint256 tokensLeft = _exData.srcAmount;
1532 
1533         if (success) {
1534             // check to see if any _src tokens are left over after exchange
1535             tokensLeft = getBalance(_exData.srcAddr);
1536 
1537             // convert weth -> eth if needed
1538             if (_exData.destAddr == KYBER_ETH_ADDRESS) {
1539                 TokenInterface(WETH_ADDRESS).withdraw(
1540                     TokenInterface(WETH_ADDRESS).balanceOf(address(this))
1541                 );
1542             }
1543 
1544             // get the current balance of the swaped tokens
1545             tokensSwaped = getBalance(_exData.destAddr) - tokensBefore;
1546         }
1547 
1548         return (success, tokensSwaped, tokensLeft);
1549     }
1550 
1551     /// @notice Calls wraper contract for exchage to preform an on-chain swap
1552     /// @param _exData Exchange data struct
1553     /// @param _type Type of action SELL|BUY
1554     /// @return swapedTokens For Sell that the destAmount, for Buy thats the srcAmount
1555     function saverSwap(ExchangeData memory _exData, ActionType _type) internal returns (uint swapedTokens) {
1556         require(SaverExchangeRegistry(SAVER_EXCHANGE_REGISTRY).isWrapper(_exData.wrapper), "Wrapper is not valid");
1557 
1558         uint ethValue = 0;
1559 
1560         ERC20(_exData.srcAddr).safeTransfer(_exData.wrapper, _exData.srcAmount);
1561 
1562         if (_type == ActionType.SELL) {
1563             swapedTokens = ExchangeInterfaceV2(_exData.wrapper).
1564                     sell{value: ethValue}(_exData.srcAddr, _exData.destAddr, _exData.srcAmount);
1565         } else {
1566             swapedTokens = ExchangeInterfaceV2(_exData.wrapper).
1567                     buy{value: ethValue}(_exData.srcAddr, _exData.destAddr, _exData.destAmount);
1568         }
1569     }
1570 
1571     function writeUint256(bytes memory _b, uint256 _index, uint _input) internal pure {
1572         if (_b.length < _index + 32) {
1573             revert("Incorrent lengt while writting bytes32");
1574         }
1575 
1576         bytes32 input = bytes32(_input);
1577 
1578         _index += 32;
1579 
1580         // Read the bytes32 from array memory
1581         assembly {
1582             mstore(add(_b, _index), input)
1583         }
1584     }
1585 
1586     /// @notice Converts Kybers Eth address -> Weth
1587     /// @param _src Input address
1588     function ethToWethAddr(address _src) internal pure returns (address) {
1589         return _src == KYBER_ETH_ADDRESS ? WETH_ADDRESS : _src;
1590     }
1591 
1592     /// @notice Calculates protocol fee
1593     /// @param _srcAddr selling token address (if eth should be WETH)
1594     /// @param _srcAmount amount we are selling
1595     function getProtocolFee(address _srcAddr, uint256 _srcAmount) internal view returns(uint256) {
1596         // if we are not selling ETH msg value is always the protocol fee
1597         if (_srcAddr != WETH_ADDRESS) return address(this).balance;
1598 
1599         // if msg value is larger than srcAmount, that means that msg value is protocol fee + srcAmount, so we subsctract srcAmount from msg value
1600         // we have an edge case here when protocol fee is higher than selling amount
1601         if (address(this).balance > _srcAmount) return address(this).balance - _srcAmount;
1602 
1603         // if msg value is lower than src amount, that means that srcAmount isn't included in msg value, so we return msg value
1604         return address(this).balance;
1605     }
1606 
1607     function packExchangeData(ExchangeData memory _exData) public pure returns(bytes memory) {
1608         // splitting in two different bytes and encoding all because of stack too deep in decoding part
1609 
1610         bytes memory part1 = abi.encode(
1611             _exData.srcAddr,
1612             _exData.destAddr,
1613             _exData.srcAmount,
1614             _exData.destAmount
1615         );
1616 
1617         bytes memory part2 = abi.encode(
1618             _exData.minPrice,
1619             _exData.wrapper,
1620             _exData.exchangeAddr,
1621             _exData.callData,
1622             _exData.price0x
1623         );
1624 
1625 
1626         return abi.encode(part1, part2);
1627     }
1628 
1629     function unpackExchangeData(bytes memory _data) public pure returns(ExchangeData memory _exData) {
1630         (
1631             bytes memory part1,
1632             bytes memory part2
1633         ) = abi.decode(_data, (bytes,bytes));
1634 
1635         (
1636             _exData.srcAddr,
1637             _exData.destAddr,
1638             _exData.srcAmount,
1639             _exData.destAmount
1640         ) = abi.decode(part1, (address,address,uint256,uint256));
1641 
1642         (
1643             _exData.minPrice,
1644             _exData.wrapper,
1645             _exData.exchangeAddr,
1646             _exData.callData,
1647             _exData.price0x
1648         )
1649         = abi.decode(part2, (uint256,address,address,bytes,uint256));
1650     }
1651 
1652     // solhint-disable-next-line no-empty-blocks
1653     receive() external virtual payable {}
1654 }     
1655 
1656 
1657 
1658 
1659 
1660 
1661 
1662 
1663 
1664 
1665 
1666 
1667 /// @title Contract implements logic of calling boost/repay in the automatic system
1668 contract CompoundMonitor is AdminAuth, DSMath, CompoundSafetyRatio, GasBurner {
1669 
1670     using SafeERC20 for ERC20;
1671 
1672     enum Method { Boost, Repay }
1673 
1674     uint public REPAY_GAS_TOKEN = 20;
1675     uint public BOOST_GAS_TOKEN = 20;
1676 
1677     uint constant public MAX_GAS_PRICE = 500000000000; // 500 gwei
1678 
1679     uint public REPAY_GAS_COST = 2000000;
1680     uint public BOOST_GAS_COST = 2000000;
1681 
1682     address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000b3F879cb30FE243b4Dfee438691c04;
1683     address public constant DEFISAVER_LOGGER = 0x5c55B921f590a89C1Ebe84dF170E655a82b62126;
1684     address public constant BOT_REGISTRY_ADDRESS = 0x637726f8b08a7ABE3aE3aCaB01A80E2d8ddeF77B;
1685 
1686     CompoundMonitorProxy public compoundMonitorProxy;
1687     CompoundSubscriptions public subscriptionsContract;
1688     address public compoundFlashLoanTakerAddress;
1689 
1690     DefisaverLogger public logger = DefisaverLogger(DEFISAVER_LOGGER);
1691 
1692     modifier onlyApproved() {
1693         require(BotRegistry(BOT_REGISTRY_ADDRESS).botList(msg.sender), "Not auth bot");
1694         _;
1695     }
1696 
1697     /// @param _compoundMonitorProxy Proxy contracts that actually is authorized to call DSProxy
1698     /// @param _subscriptions Subscriptions contract for Compound positions
1699     /// @param _compoundFlashLoanTaker Contract that actually performs Repay/Boost
1700     constructor(address _compoundMonitorProxy, address _subscriptions, address _compoundFlashLoanTaker) public {
1701         compoundMonitorProxy = CompoundMonitorProxy(_compoundMonitorProxy);
1702         subscriptionsContract = CompoundSubscriptions(_subscriptions);
1703         compoundFlashLoanTakerAddress = _compoundFlashLoanTaker;
1704     }
1705 
1706     /// @notice Bots call this method to repay for user when conditions are met
1707     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
1708     /// @param _exData Exchange data
1709     /// @param _cAddresses cTokens addreses and exchange [cCollAddress, cBorrowAddress, exchangeAddress]
1710     /// @param _user The actual address that owns the Compound position
1711     function repayFor(
1712         SaverExchangeCore.ExchangeData memory _exData,
1713         address[2] memory _cAddresses, // cCollAddress, cBorrowAddress
1714         address _user
1715     ) public payable onlyApproved burnGas(REPAY_GAS_TOKEN) {
1716 
1717         (bool isAllowed, uint ratioBefore) = canCall(Method.Repay, _user);
1718         require(isAllowed); // check if conditions are met
1719 
1720         uint256 gasCost = calcGasCost(REPAY_GAS_COST);
1721 
1722         compoundMonitorProxy.callExecute{value: msg.value}(
1723             _user,
1724             compoundFlashLoanTakerAddress,
1725             abi.encodeWithSignature(
1726                 "repayWithLoan((address,address,uint256,uint256,uint256,address,address,bytes,uint256),address[2],uint256)",
1727                 _exData,
1728                 _cAddresses,
1729                 gasCost
1730             )
1731         );
1732 
1733         (bool isGoodRatio, uint ratioAfter) = ratioGoodAfter(Method.Repay, _user);
1734         require(isGoodRatio); // check if the after result of the actions is good
1735 
1736         returnEth();
1737 
1738         logger.Log(address(this), _user, "AutomaticCompoundRepay", abi.encode(ratioBefore, ratioAfter));
1739     }
1740 
1741     /// @notice Bots call this method to boost for user when conditions are met
1742     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
1743     /// @param _exData Exchange data
1744     /// @param _cAddresses cTokens addreses and exchange [cCollAddress, cBorrowAddress, exchangeAddress]
1745     /// @param _user The actual address that owns the Compound position
1746     function boostFor(
1747         SaverExchangeCore.ExchangeData memory _exData,
1748         address[2] memory _cAddresses, // cCollAddress, cBorrowAddress
1749         address _user
1750     ) public payable onlyApproved burnGas(BOOST_GAS_TOKEN) {
1751 
1752         (bool isAllowed, uint ratioBefore) = canCall(Method.Boost, _user);
1753         require(isAllowed); // check if conditions are met
1754 
1755         uint256 gasCost = calcGasCost(BOOST_GAS_COST);
1756 
1757         compoundMonitorProxy.callExecute{value: msg.value}(
1758             _user,
1759             compoundFlashLoanTakerAddress,
1760             abi.encodeWithSignature(
1761                 "boostWithLoan((address,address,uint256,uint256,uint256,address,address,bytes,uint256),address[2],uint256)",
1762                 _exData,
1763                 _cAddresses,
1764                 gasCost
1765             )
1766         );
1767 
1768 
1769         (bool isGoodRatio, uint ratioAfter) = ratioGoodAfter(Method.Boost, _user);
1770         require(isGoodRatio);  // check if the after result of the actions is good
1771 
1772         returnEth();
1773 
1774         logger.Log(address(this), _user, "AutomaticCompoundBoost", abi.encode(ratioBefore, ratioAfter));
1775     }
1776 
1777 /******************* INTERNAL METHODS ********************************/
1778     function returnEth() internal {
1779         // return if some eth left
1780         if (address(this).balance > 0) {
1781             msg.sender.transfer(address(this).balance);
1782         }
1783     }
1784 
1785 /******************* STATIC METHODS ********************************/
1786 
1787     /// @notice Checks if Boost/Repay could be triggered for the CDP
1788     /// @dev Called by MCDMonitor to enforce the min/max check
1789     /// @param _method Type of action to be called
1790     /// @param _user The actual address that owns the Compound position
1791     /// @return Boolean if it can be called and the ratio
1792     function canCall(Method _method, address _user) public view returns(bool, uint) {
1793         bool subscribed = subscriptionsContract.isSubscribed(_user);
1794         CompoundSubscriptions.CompoundHolder memory holder = subscriptionsContract.getHolder(_user);
1795 
1796         // check if cdp is subscribed
1797         if (!subscribed) return (false, 0);
1798 
1799         // check if boost and boost allowed
1800         if (_method == Method.Boost && !holder.boostEnabled) return (false, 0);
1801 
1802         uint currRatio = getSafetyRatio(_user);
1803 
1804         if (_method == Method.Repay) {
1805             return (currRatio < holder.minRatio, currRatio);
1806         } else if (_method == Method.Boost) {
1807             return (currRatio > holder.maxRatio, currRatio);
1808         }
1809     }
1810 
1811     /// @dev After the Boost/Repay check if the ratio doesn't trigger another call
1812     /// @param _method Type of action to be called
1813     /// @param _user The actual address that owns the Compound position
1814     /// @return Boolean if the recent action preformed correctly and the ratio
1815     function ratioGoodAfter(Method _method, address _user) public view returns(bool, uint) {
1816         CompoundSubscriptions.CompoundHolder memory holder;
1817 
1818         holder= subscriptionsContract.getHolder(_user);
1819 
1820         uint currRatio = getSafetyRatio(_user);
1821 
1822         if (_method == Method.Repay) {
1823             return (currRatio < holder.maxRatio, currRatio);
1824         } else if (_method == Method.Boost) {
1825             return (currRatio > holder.minRatio, currRatio);
1826         }
1827     }
1828 
1829     /// @notice Calculates gas cost (in Eth) of tx
1830     /// @dev Gas price is limited to MAX_GAS_PRICE to prevent attack of draining user CDP
1831     /// @param _gasAmount Amount of gas used for the tx
1832     function calcGasCost(uint _gasAmount) public view returns (uint) {
1833         uint gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;
1834 
1835         return mul(gasPrice, _gasAmount);
1836     }
1837 
1838 /******************* OWNER ONLY OPERATIONS ********************************/
1839 
1840     /// @notice As the code is new, have a emergancy admin saver proxy change
1841     function changeCompoundFlashLoanTaker(address _newCompoundFlashLoanTakerAddress) public onlyAdmin {
1842         compoundFlashLoanTakerAddress = _newCompoundFlashLoanTakerAddress;
1843     }
1844 
1845     /// @notice Allows owner to change gas cost for boost operation, but only up to 3 millions
1846     /// @param _gasCost New gas cost for boost method
1847     function changeBoostGasCost(uint _gasCost) public onlyOwner {
1848         require(_gasCost < 3000000);
1849 
1850         BOOST_GAS_COST = _gasCost;
1851     }
1852 
1853     /// @notice Allows owner to change gas cost for repay operation, but only up to 3 millions
1854     /// @param _gasCost New gas cost for repay method
1855     function changeRepayGasCost(uint _gasCost) public onlyOwner {
1856         require(_gasCost < 3000000);
1857 
1858         REPAY_GAS_COST = _gasCost;
1859     }
1860 
1861     /// @notice If any tokens gets stuck in the contract owner can withdraw it
1862     /// @param _tokenAddress Address of the ERC20 token
1863     /// @param _to Address of the receiver
1864     /// @param _amount The amount to be sent
1865     function transferERC20(address _tokenAddress, address _to, uint _amount) public onlyOwner {
1866         ERC20(_tokenAddress).safeTransfer(_to, _amount);
1867     }
1868 
1869     /// @notice If any Eth gets stuck in the contract owner can withdraw it
1870     /// @param _to Address of the receiver
1871     /// @param _amount The amount to be sent
1872     function transferEth(address payable _to, uint _amount) public onlyOwner {
1873         _to.transfer(_amount);
1874     }
1875 }