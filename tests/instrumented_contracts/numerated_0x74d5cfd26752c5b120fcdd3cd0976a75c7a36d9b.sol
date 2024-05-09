1 pragma solidity ^0.6.0; 
2 pragma experimental ABIEncoderV2;
3 
4 
5 interface ERC20 {
6     function totalSupply() external view returns (uint256 supply);
7 
8     function balanceOf(address _owner) external view returns (uint256 balance);
9 
10     function transfer(address _to, uint256 _value) external returns (bool success);
11 
12     function transferFrom(address _from, address _to, uint256 _value)
13         external
14         returns (bool success);
15 
16     function approve(address _spender, uint256 _value) external returns (bool success);
17 
18     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
19 
20     function decimals() external view returns (uint256 digits);
21 
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 } abstract contract GasTokenInterface is ERC20 {
24     function free(uint256 value) public virtual returns (bool success);
25 
26     function freeUpTo(uint256 value) public virtual returns (uint256 freed);
27 
28     function freeFrom(address from, uint256 value) public virtual returns (bool success);
29 
30     function freeFromUpTo(address from, uint256 value) public virtual returns (uint256 freed);
31 } contract GasBurner {
32     // solhint-disable-next-line const-name-snakecase
33     GasTokenInterface public constant gasToken = GasTokenInterface(0x0000000000b3F879cb30FE243b4Dfee438691c04);
34 
35     modifier burnGas(uint _amount) {
36         if (gasToken.balanceOf(address(this)) >= _amount) {
37             gasToken.free(_amount);
38         }
39 
40         _;
41     }
42 } abstract contract DSProxyInterface {
43 
44     /// Truffle wont compile if this isn't commented
45     // function execute(bytes memory _code, bytes memory _data)
46     //     public virtual
47     //     payable
48     //     returns (address, bytes32);
49 
50     function execute(address _target, bytes memory _data) public virtual payable returns (bytes32);
51 
52     function setCache(address _cacheAddr) public virtual payable returns (bool);
53 
54     function owner() public virtual returns (address);
55 } library Address {
56     function isContract(address account) internal view returns (bool) {
57         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
58         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
59         // for accounts without code, i.e. `keccak256('')`
60         bytes32 codehash;
61         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
62         // solhint-disable-next-line no-inline-assembly
63         assembly { codehash := extcodehash(account) }
64         return (codehash != accountHash && codehash != 0x0);
65     }
66 
67     function sendValue(address payable recipient, uint256 amount) internal {
68         require(address(this).balance >= amount, "Address: insufficient balance");
69 
70         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
71         (bool success, ) = recipient.call{ value: amount }("");
72         require(success, "Address: unable to send value, recipient may have reverted");
73     }
74 
75     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
76       return functionCall(target, data, "Address: low-level call failed");
77     }
78 
79     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
80         return _functionCallWithValue(target, data, 0, errorMessage);
81     }
82 
83     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
84         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
85     }
86 
87     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
88         require(address(this).balance >= value, "Address: insufficient balance for call");
89         return _functionCallWithValue(target, data, value, errorMessage);
90     }
91 
92     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
93         require(isContract(target), "Address: call to non-contract");
94 
95         // solhint-disable-next-line avoid-low-level-calls
96         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
97         if (success) {
98             return returndata;
99         } else {
100             // Look for revert reason and bubble it up if present
101             if (returndata.length > 0) {
102                 // The easiest way to bubble the revert reason is using memory via assembly
103 
104                 // solhint-disable-next-line no-inline-assembly
105                 assembly {
106                     let returndata_size := mload(returndata)
107                     revert(add(32, returndata), returndata_size)
108                 }
109             } else {
110                 revert(errorMessage);
111             }
112         }
113     }
114 } library SafeMath {
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121 
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return sub(a, b, "SafeMath: subtraction overflow");
124     }
125 
126     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         require(b <= a, errorMessage);
128         uint256 c = a - b;
129 
130         return c;
131     }
132 
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146 
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         return div(a, b, "SafeMath: division by zero");
149     }
150 
151     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b > 0, errorMessage);
153         uint256 c = a / b;
154         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
155 
156         return c;
157     }
158 
159     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
160         return mod(a, b, "SafeMath: modulo by zero");
161     }
162 
163     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b != 0, errorMessage);
165         return a % b;
166     }
167 } library SafeERC20 {
168     using SafeMath for uint256;
169     using Address for address;
170 
171     function safeTransfer(ERC20 token, address to, uint256 value) internal {
172         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
173     }
174 
175     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
176         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
177     }
178 
179     /**
180      * @dev Deprecated. This function has issues similar to the ones found in
181      * {IERC20-approve}, and its usage is discouraged.
182      */
183     function safeApprove(ERC20 token, address spender, uint256 value) internal {
184         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
185         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
186     }
187 
188     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
189         uint256 newAllowance = token.allowance(address(this), spender).add(value);
190         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
191     }
192 
193     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
194         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
195         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
196     }
197 
198     function _callOptionalReturn(ERC20 token, bytes memory data) private {
199 
200         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
201         if (returndata.length > 0) { // Return data is optional
202             // solhint-disable-next-line max-line-length
203             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
204         }
205     }
206 } contract AdminAuth {
207 
208     using SafeERC20 for ERC20;
209 
210     address public owner;
211     address public admin;
212 
213     modifier onlyOwner() {
214         require(owner == msg.sender);
215         _;
216     }
217 
218     modifier onlyAdmin() {
219         require(admin == msg.sender);
220         _;
221     }
222 
223     constructor() public {
224         owner = msg.sender;
225         admin = 0x25eFA336886C74eA8E282ac466BdCd0199f85BB9;
226     }
227 
228     /// @notice Admin is set by owner first time, after that admin is super role and has permission to change owner
229     /// @param _admin Address of multisig that becomes admin
230     function setAdminByOwner(address _admin) public {
231         require(msg.sender == owner);
232         require(admin == address(0));
233 
234         admin = _admin;
235     }
236 
237     /// @notice Admin is able to set new admin
238     /// @param _admin Address of multisig that becomes new admin
239     function setAdminByAdmin(address _admin) public {
240         require(msg.sender == admin);
241 
242         admin = _admin;
243     }
244 
245     /// @notice Admin is able to change owner
246     /// @param _owner Address of new owner
247     function setOwnerByAdmin(address _owner) public {
248         require(msg.sender == admin);
249 
250         owner = _owner;
251     }
252 
253     /// @notice Destroy the contract
254     function kill() public onlyOwner {
255         selfdestruct(payable(owner));
256     }
257 
258     /// @notice  withdraw stuck funds
259     function withdrawStuckFunds(address _token, uint _amount) public onlyOwner {
260         if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
261             payable(owner).transfer(_amount);
262         } else {
263             ERC20(_token).safeTransfer(owner, _amount);
264         }
265     }
266 } /// @title Contract with the actuall DSProxy permission calls the automation operations
267 contract AaveMonitorProxy is AdminAuth {
268 
269     using SafeERC20 for ERC20;
270 
271     uint public CHANGE_PERIOD;
272     address public monitor;
273     address public newMonitor;
274     address public lastMonitor;
275     uint public changeRequestedTimestamp;
276 
277     mapping(address => bool) public allowed;
278 
279     event MonitorChangeInitiated(address oldMonitor, address newMonitor);
280     event MonitorChangeCanceled();
281     event MonitorChangeFinished(address monitor);
282     event MonitorChangeReverted(address monitor);
283 
284     // if someone who is allowed become malicious, owner can't be changed
285     modifier onlyAllowed() {
286         require(allowed[msg.sender] || msg.sender == owner);
287         _;
288     }
289 
290     modifier onlyMonitor() {
291         require (msg.sender == monitor);
292         _;
293     }
294 
295     constructor(uint _changePeriod) public {
296         CHANGE_PERIOD = _changePeriod * 1 days;
297     }
298 
299     /// @notice Only monitor contract is able to call execute on users proxy
300     /// @param _owner Address of cdp owner (users DSProxy address)
301     /// @param _aaveSaverProxy Address of AaveSaverProxy
302     /// @param _data Data to send to AaveSaverProxy
303     function callExecute(address _owner, address _aaveSaverProxy, bytes memory _data) public payable onlyMonitor {
304         // execute reverts if calling specific method fails
305         DSProxyInterface(_owner).execute{value: msg.value}(_aaveSaverProxy, _data);
306 
307         // return if anything left
308         if (address(this).balance > 0) {
309             msg.sender.transfer(address(this).balance);
310         }
311     }
312 
313     /// @notice Allowed users are able to set Monitor contract without any waiting period first time
314     /// @param _monitor Address of Monitor contract
315     function setMonitor(address _monitor) public onlyAllowed {
316         require(monitor == address(0));
317         monitor = _monitor;
318     }
319 
320     /// @notice Allowed users are able to start procedure for changing monitor
321     /// @dev after CHANGE_PERIOD needs to call confirmNewMonitor to actually make a change
322     /// @param _newMonitor address of new monitor
323     function changeMonitor(address _newMonitor) public onlyAllowed {
324         require(changeRequestedTimestamp == 0);
325 
326         changeRequestedTimestamp = now;
327         lastMonitor = monitor;
328         newMonitor = _newMonitor;
329 
330         emit MonitorChangeInitiated(lastMonitor, newMonitor);
331     }
332 
333     /// @notice At any point allowed users are able to cancel monitor change
334     function cancelMonitorChange() public onlyAllowed {
335         require(changeRequestedTimestamp > 0);
336 
337         changeRequestedTimestamp = 0;
338         newMonitor = address(0);
339 
340         emit MonitorChangeCanceled();
341     }
342 
343     /// @notice Anyone is able to confirm new monitor after CHANGE_PERIOD if process is started
344     function confirmNewMonitor() public onlyAllowed {
345         require((changeRequestedTimestamp + CHANGE_PERIOD) < now);
346         require(changeRequestedTimestamp != 0);
347         require(newMonitor != address(0));
348 
349         monitor = newMonitor;
350         newMonitor = address(0);
351         changeRequestedTimestamp = 0;
352 
353         emit MonitorChangeFinished(monitor);
354     }
355 
356     /// @notice Its possible to revert monitor to last used monitor
357     function revertMonitor() public onlyAllowed {
358         require(lastMonitor != address(0));
359 
360         monitor = lastMonitor;
361 
362         emit MonitorChangeReverted(monitor);
363     }
364 
365 
366     /// @notice Allowed users are able to add new allowed user
367     /// @param _user Address of user that will be allowed
368     function addAllowed(address _user) public onlyAllowed {
369         allowed[_user] = true;
370     }
371 
372     /// @notice Allowed users are able to remove allowed user
373     /// @dev owner is always allowed even if someone tries to remove it from allowed mapping
374     /// @param _user Address of allowed user
375     function removeAllowed(address _user) public onlyAllowed {
376         allowed[_user] = false;
377     }
378 
379     function setChangePeriod(uint _periodInDays) public onlyAllowed {
380         require(_periodInDays * 1 days > CHANGE_PERIOD);
381 
382         CHANGE_PERIOD = _periodInDays * 1 days;
383     }
384 
385     /// @notice In case something is left in contract, owner is able to withdraw it
386     /// @param _token address of token to withdraw balance
387     function withdrawToken(address _token) public onlyOwner {
388         uint balance = ERC20(_token).balanceOf(address(this));
389         ERC20(_token).safeTransfer(msg.sender, balance);
390     }
391 
392     /// @notice In case something is left in contract, owner is able to withdraw it
393     function withdrawEth() public onlyOwner {
394         uint balance = address(this).balance;
395         msg.sender.transfer(balance);
396     }
397 }
398 
399 
400 
401 /// @title Stores subscription information for Aave automatization
402 contract AaveSubscriptions is AdminAuth {
403 
404     struct AaveHolder {
405         address user;
406         uint128 minRatio;
407         uint128 maxRatio;
408         uint128 optimalRatioBoost;
409         uint128 optimalRatioRepay;
410         bool boostEnabled;
411     }
412 
413     struct SubPosition {
414         uint arrPos;
415         bool subscribed;
416     }
417 
418     AaveHolder[] public subscribers;
419     mapping (address => SubPosition) public subscribersPos;
420 
421     uint public changeIndex;
422 
423     event Subscribed(address indexed user);
424     event Unsubscribed(address indexed user);
425     event Updated(address indexed user);
426     event ParamUpdates(address indexed user, uint128, uint128, uint128, uint128, bool);
427 
428     /// @dev Called by the DSProxy contract which owns the Aave position
429     /// @notice Adds the users Aave poistion in the list of subscriptions so it can be monitored
430     /// @param _minRatio Minimum ratio below which repay is triggered
431     /// @param _maxRatio Maximum ratio after which boost is triggered
432     /// @param _optimalBoost Ratio amount which boost should target
433     /// @param _optimalRepay Ratio amount which repay should target
434     /// @param _boostEnabled Boolean determing if boost is enabled
435     function subscribe(uint128 _minRatio, uint128 _maxRatio, uint128 _optimalBoost, uint128 _optimalRepay, bool _boostEnabled) external {
436 
437         // if boost is not enabled, set max ratio to max uint
438         uint128 localMaxRatio = _boostEnabled ? _maxRatio : uint128(-1);
439         require(checkParams(_minRatio, localMaxRatio), "Must be correct params");
440 
441         SubPosition storage subInfo = subscribersPos[msg.sender];
442 
443         AaveHolder memory subscription = AaveHolder({
444                 minRatio: _minRatio,
445                 maxRatio: localMaxRatio,
446                 optimalRatioBoost: _optimalBoost,
447                 optimalRatioRepay: _optimalRepay,
448                 user: msg.sender,
449                 boostEnabled: _boostEnabled
450             });
451 
452         changeIndex++;
453 
454         if (subInfo.subscribed) {
455             subscribers[subInfo.arrPos] = subscription;
456 
457             emit Updated(msg.sender);
458             emit ParamUpdates(msg.sender, _minRatio, localMaxRatio, _optimalBoost, _optimalRepay, _boostEnabled);
459         } else {
460             subscribers.push(subscription);
461 
462             subInfo.arrPos = subscribers.length - 1;
463             subInfo.subscribed = true;
464 
465             emit Subscribed(msg.sender);
466         }
467     }
468 
469     /// @notice Called by the users DSProxy
470     /// @dev Owner who subscribed cancels his subscription
471     function unsubscribe() external {
472         _unsubscribe(msg.sender);
473     }
474 
475     /// @dev Checks limit if minRatio is bigger than max
476     /// @param _minRatio Minimum ratio, bellow which repay can be triggered
477     /// @param _maxRatio Maximum ratio, over which boost can be triggered
478     /// @return Returns bool if the params are correct
479     function checkParams(uint128 _minRatio, uint128 _maxRatio) internal pure returns (bool) {
480 
481         if (_minRatio > _maxRatio) {
482             return false;
483         }
484 
485         return true;
486     }
487 
488     /// @dev Internal method to remove a subscriber from the list
489     /// @param _user The actual address that owns the Aave position
490     function _unsubscribe(address _user) internal {
491         require(subscribers.length > 0, "Must have subscribers in the list");
492 
493         SubPosition storage subInfo = subscribersPos[_user];
494 
495         require(subInfo.subscribed, "Must first be subscribed");
496 
497         address lastOwner = subscribers[subscribers.length - 1].user;
498 
499         SubPosition storage subInfo2 = subscribersPos[lastOwner];
500         subInfo2.arrPos = subInfo.arrPos;
501 
502         subscribers[subInfo.arrPos] = subscribers[subscribers.length - 1];
503         subscribers.pop(); // remove last element and reduce arr length
504 
505         changeIndex++;
506         subInfo.subscribed = false;
507         subInfo.arrPos = 0;
508 
509         emit Unsubscribed(msg.sender);
510     }
511 
512     /// @dev Checks if the user is subscribed
513     /// @param _user The actual address that owns the Aave position
514     /// @return If the user is subscribed
515     function isSubscribed(address _user) public view returns (bool) {
516         SubPosition storage subInfo = subscribersPos[_user];
517 
518         return subInfo.subscribed;
519     }
520 
521     /// @dev Returns subscribtion information about a user
522     /// @param _user The actual address that owns the Aave position
523     /// @return Subscription information about the user if exists
524     function getHolder(address _user) public view returns (AaveHolder memory) {
525         SubPosition storage subInfo = subscribersPos[_user];
526 
527         return subscribers[subInfo.arrPos];
528     }
529 
530     /// @notice Helper method to return all the subscribed CDPs
531     /// @return List of all subscribers
532     function getSubscribers() public view returns (AaveHolder[] memory) {
533         return subscribers;
534     }
535 
536     /// @notice Helper method for the frontend, returns all the subscribed CDPs paginated
537     /// @param _page What page of subscribers you want
538     /// @param _perPage Number of entries per page
539     /// @return List of all subscribers for that page
540     function getSubscribersByPage(uint _page, uint _perPage) public view returns (AaveHolder[] memory) {
541         AaveHolder[] memory holders = new AaveHolder[](_perPage);
542 
543         uint start = _page * _perPage;
544         uint end = start + _perPage;
545 
546         end = (end > holders.length) ? holders.length : end;
547 
548         uint count = 0;
549         for (uint i = start; i < end; i++) {
550             holders[count] = subscribers[i];
551             count++;
552         }
553 
554         return holders;
555     }
556 
557     ////////////// ADMIN METHODS ///////////////////
558 
559     /// @notice Admin function to unsubscribe a position
560     /// @param _user The actual address that owns the Aave position
561     function unsubscribeByAdmin(address _user) public onlyOwner {
562         SubPosition storage subInfo = subscribersPos[_user];
563 
564         if (subInfo.subscribed) {
565             _unsubscribe(_user);
566         }
567     }
568 } contract DSMath {
569     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
570         require((z = x + y) >= x);
571     }
572 
573     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
574         require((z = x - y) <= x);
575     }
576 
577     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
578         require(y == 0 || (z = x * y) / y == x);
579     }
580 
581     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
582         return x / y;
583     }
584 
585     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
586         return x <= y ? x : y;
587     }
588 
589     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
590         return x >= y ? x : y;
591     }
592 
593     function imin(int256 x, int256 y) internal pure returns (int256 z) {
594         return x <= y ? x : y;
595     }
596 
597     function imax(int256 x, int256 y) internal pure returns (int256 z) {
598         return x >= y ? x : y;
599     }
600 
601     uint256 constant WAD = 10**18;
602     uint256 constant RAY = 10**27;
603 
604     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
605         z = add(mul(x, y), WAD / 2) / WAD;
606     }
607 
608     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
609         z = add(mul(x, y), RAY / 2) / RAY;
610     }
611 
612     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
613         z = add(mul(x, WAD), y / 2) / y;
614     }
615 
616     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
617         z = add(mul(x, RAY), y / 2) / y;
618     }
619 
620     // This famous algorithm is called "exponentiation by squaring"
621     // and calculates x^n with x as fixed-point and n as regular unsigned.
622     //
623     // It's O(log n), instead of O(n) for naive repeated multiplication.
624     //
625     // These facts are why it works:
626     //
627     //  If n is even, then x^n = (x^2)^(n/2).
628     //  If n is odd,  then x^n = x * x^(n-1),
629     //   and applying the equation for even x gives
630     //    x^n = x * (x^2)^((n-1) / 2).
631     //
632     //  Also, EVM division is flooring and
633     //    floor[(n-1) / 2] = floor[n / 2].
634     //
635     function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
636         z = n % 2 != 0 ? x : RAY;
637 
638         for (n /= 2; n != 0; n /= 2) {
639             x = rmul(x, x);
640 
641             if (n % 2 != 0) {
642                 z = rmul(z, x);
643             }
644         }
645     }
646 } contract DefisaverLogger {
647     event LogEvent(
648         address indexed contractAddress,
649         address indexed caller,
650         string indexed logName,
651         bytes data
652     );
653 
654     // solhint-disable-next-line func-name-mixedcase
655     function Log(address _contract, address _caller, string memory _logName, bytes memory _data)
656         public
657     {
658         emit LogEvent(_contract, _caller, _logName, _data);
659     }
660 } abstract contract DSAuthority {
661     function canCall(address src, address dst, bytes4 sig) public virtual view returns (bool);
662 } contract DSAuthEvents {
663     event LogSetAuthority(address indexed authority);
664     event LogSetOwner(address indexed owner);
665 }
666 
667 
668 contract DSAuth is DSAuthEvents {
669     DSAuthority public authority;
670     address public owner;
671 
672     constructor() public {
673         owner = msg.sender;
674         emit LogSetOwner(msg.sender);
675     }
676 
677     function setOwner(address owner_) public auth {
678         owner = owner_;
679         emit LogSetOwner(owner);
680     }
681 
682     function setAuthority(DSAuthority authority_) public auth {
683         authority = authority_;
684         emit LogSetAuthority(address(authority));
685     }
686 
687     modifier auth {
688         require(isAuthorized(msg.sender, msg.sig));
689         _;
690     }
691 
692     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
693         if (src == address(this)) {
694             return true;
695         } else if (src == owner) {
696             return true;
697         } else if (authority == DSAuthority(0)) {
698             return false;
699         } else {
700             return authority.canCall(src, address(this), sig);
701         }
702     }
703 } contract DSNote {
704     event LogNote(
705         bytes4 indexed sig,
706         address indexed guy,
707         bytes32 indexed foo,
708         bytes32 indexed bar,
709         uint256 wad,
710         bytes fax
711     ) anonymous;
712 
713     modifier note {
714         bytes32 foo;
715         bytes32 bar;
716 
717         assembly {
718             foo := calldataload(4)
719             bar := calldataload(36)
720         }
721 
722         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
723 
724         _;
725     }
726 } abstract contract DSProxy is DSAuth, DSNote {
727     DSProxyCache public cache; // global cache for contracts
728 
729     constructor(address _cacheAddr) public {
730         require(setCache(_cacheAddr));
731     }
732 
733     // solhint-disable-next-line no-empty-blocks
734     receive() external payable {}
735 
736     // use the proxy to execute calldata _data on contract _code
737     // function execute(bytes memory _code, bytes memory _data)
738     //     public
739     //     payable
740     //     virtual
741     //     returns (address target, bytes32 response);
742 
743     function execute(address _target, bytes memory _data)
744         public
745         payable
746         virtual
747         returns (bytes32 response);
748 
749     //set new cache
750     function setCache(address _cacheAddr) public virtual payable returns (bool);
751 }
752 
753 
754 contract DSProxyCache {
755     mapping(bytes32 => address) cache;
756 
757     function read(bytes memory _code) public view returns (address) {
758         bytes32 hash = keccak256(_code);
759         return cache[hash];
760     }
761 
762     function write(bytes memory _code) public returns (address target) {
763         assembly {
764             target := create(0, add(_code, 0x20), mload(_code))
765             switch iszero(extcodesize(target))
766                 case 1 {
767                     // throw if contract failed to deploy
768                     revert(0, 0)
769                 }
770         }
771         bytes32 hash = keccak256(_code);
772         cache[hash] = target;
773     }
774 } contract Discount {
775     address public owner;
776     mapping(address => CustomServiceFee) public serviceFees;
777 
778     uint256 constant MAX_SERVICE_FEE = 400;
779 
780     struct CustomServiceFee {
781         bool active;
782         uint256 amount;
783     }
784 
785     constructor() public {
786         owner = msg.sender;
787     }
788 
789     function isCustomFeeSet(address _user) public view returns (bool) {
790         return serviceFees[_user].active;
791     }
792 
793     function getCustomServiceFee(address _user) public view returns (uint256) {
794         return serviceFees[_user].amount;
795     }
796 
797     function setServiceFee(address _user, uint256 _fee) public {
798         require(msg.sender == owner, "Only owner");
799         require(_fee >= MAX_SERVICE_FEE || _fee == 0);
800 
801         serviceFees[_user] = CustomServiceFee({active: true, amount: _fee});
802     }
803 
804     function disableServiceFee(address _user) public {
805         require(msg.sender == owner, "Only owner");
806 
807         serviceFees[_user] = CustomServiceFee({active: false, amount: 0});
808     }
809 } abstract contract IAToken {
810     function redeem(uint256 _amount) external virtual;
811     function balanceOf(address _owner) external virtual view returns (uint256 balance);
812 } abstract contract ILendingPool {
813     function flashLoan( address payable _receiver, address _reserve, uint _amount, bytes calldata _params) external virtual;
814     function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external virtual payable;
815 	function setUserUseReserveAsCollateral(address _reserve, bool _useAsCollateral) external virtual;
816 	function borrow(address _reserve, uint256 _amount, uint256 _interestRateMode, uint16 _referralCode) external virtual;
817 	function repay( address _reserve, uint256 _amount, address payable _onBehalfOf) external virtual payable;
818 	function swapBorrowRateMode(address _reserve) external virtual;
819     function getReserves() external virtual view returns(address[] memory);
820 
821     /// @param _reserve underlying token address
822     function getReserveData(address _reserve)
823         external virtual
824         view
825         returns (
826             uint256 totalLiquidity,               // reserve total liquidity
827             uint256 availableLiquidity,           // reserve available liquidity for borrowing
828             uint256 totalBorrowsStable,           // total amount of outstanding borrows at Stable rate
829             uint256 totalBorrowsVariable,         // total amount of outstanding borrows at Variable rate
830             uint256 liquidityRate,                // current deposit APY of the reserve for depositors, in Ray units.
831             uint256 variableBorrowRate,           // current variable rate APY of the reserve pool, in Ray units.
832             uint256 stableBorrowRate,             // current stable rate APY of the reserve pool, in Ray units.
833             uint256 averageStableBorrowRate,      // current average stable borrow rate
834             uint256 utilizationRate,              // expressed as total borrows/total liquidity.
835             uint256 liquidityIndex,               // cumulative liquidity index
836             uint256 variableBorrowIndex,          // cumulative variable borrow index
837             address aTokenAddress,                // aTokens contract address for the specific _reserve
838             uint40 lastUpdateTimestamp            // timestamp of the last update of reserve data
839         );
840 
841     /// @param _user users address
842     function getUserAccountData(address _user)
843         external virtual
844         view
845         returns (
846             uint256 totalLiquidityETH,            // user aggregated deposits across all the reserves. In Wei
847             uint256 totalCollateralETH,           // user aggregated collateral across all the reserves. In Wei
848             uint256 totalBorrowsETH,              // user aggregated outstanding borrows across all the reserves. In Wei
849             uint256 totalFeesETH,                 // user aggregated current outstanding fees in ETH. In Wei
850             uint256 availableBorrowsETH,          // user available amount to borrow in ETH
851             uint256 currentLiquidationThreshold,  // user current average liquidation threshold across all the collaterals deposited
852             uint256 ltv,                          // user average Loan-to-Value between all the collaterals
853             uint256 healthFactor                  // user current Health Factor
854     );    
855 
856     /// @param _reserve underlying token address
857     /// @param _user users address
858     function getUserReserveData(address _reserve, address _user)
859         external virtual
860         view
861         returns (
862             uint256 currentATokenBalance,         // user current reserve aToken balance
863             uint256 currentBorrowBalance,         // user current reserve outstanding borrow balance
864             uint256 principalBorrowBalance,       // user balance of borrowed asset
865             uint256 borrowRateMode,               // user borrow rate mode either Stable or Variable
866             uint256 borrowRate,                   // user current borrow rate APY
867             uint256 liquidityRate,                // user current earn rate on _reserve
868             uint256 originationFee,               // user outstanding loan origination fee
869             uint256 variableBorrowIndex,          // user variable cumulative index
870             uint256 lastUpdateTimestamp,          // Timestamp of the last data update
871             bool usageAsCollateralEnabled         // Whether the user's current reserve is enabled as a collateral
872     );
873 
874     function getReserveConfigurationData(address _reserve)
875         external virtual
876         view
877         returns (
878             uint256 ltv,
879             uint256 liquidationThreshold,
880             uint256 liquidationBonus,
881             address rateStrategyAddress,
882             bool usageAsCollateralEnabled,
883             bool borrowingEnabled,
884             bool stableBorrowRateEnabled,
885             bool isActive
886     );
887 
888     // ------------------ LendingPoolCoreData ------------------------
889     function getReserveATokenAddress(address _reserve) public virtual view returns (address);
890     function getReserveConfiguration(address _reserve)
891         external virtual
892         view
893         returns (uint256, uint256, uint256, bool);
894     function getUserUnderlyingAssetBalance(address _reserve, address _user)
895         public virtual
896         view
897         returns (uint256);
898 
899     function getReserveCurrentLiquidityRate(address _reserve)
900         public virtual
901         view
902         returns (uint256);
903     function getReserveCurrentVariableBorrowRate(address _reserve)
904         public virtual
905         view
906         returns (uint256);
907     function getReserveCurrentStableBorrowRate(address _reserve) 
908         public virtual
909         view
910         returns (uint256);
911     function getReserveTotalLiquidity(address _reserve)
912         public virtual
913         view
914         returns (uint256);
915     function getReserveAvailableLiquidity(address _reserve)
916         public virtual
917         view
918         returns (uint256);
919     function getReserveTotalBorrowsVariable(address _reserve)
920         public virtual
921         view
922         returns (uint256);
923 
924     // ---------------- LendingPoolDataProvider ---------------------
925     function calculateUserGlobalData(address _user)
926         public virtual
927         view
928         returns (
929             uint256 totalLiquidityBalanceETH,
930             uint256 totalCollateralBalanceETH,
931             uint256 totalBorrowBalanceETH,
932             uint256 totalFeesETH,
933             uint256 currentLtv,
934             uint256 currentLiquidationThreshold,
935             uint256 healthFactor,
936             bool healthFactorBelowThreshold
937         );
938 } /**
939 @title ILendingPoolAddressesProvider interface
940 @notice provides the interface to fetch the LendingPoolCore address
941  */
942 abstract contract ILendingPoolAddressesProvider {
943 
944     function getLendingPool() public virtual view returns (address);
945     function getLendingPoolCore() public virtual view returns (address payable);
946     function getLendingPoolConfigurator() public virtual view returns (address);
947     function getLendingPoolDataProvider() public virtual view returns (address);
948     function getLendingPoolParametersProvider() public virtual view returns (address);
949     function getTokenDistributor() public virtual view returns (address);
950     function getFeeProvider() public virtual view returns (address);
951     function getLendingPoolLiquidationManager() public virtual view returns (address);
952     function getLendingPoolManager() public virtual view returns (address);
953     function getPriceOracle() public virtual view returns (address);
954     function getLendingRateOracle() public virtual view returns (address);
955 } /************
956 @title IPriceOracleGetterAave interface
957 @notice Interface for the Aave price oracle.*/
958 abstract contract IPriceOracleGetterAave {
959     function getAssetPrice(address _asset) external virtual view returns (uint256);
960     function getAssetsPrices(address[] calldata _assets) external virtual view returns(uint256[] memory);
961     function getSourceOfAsset(address _asset) external virtual view returns(address);
962     function getFallbackOracle() external virtual view returns(address);
963 } contract BotRegistry is AdminAuth {
964 
965     mapping (address => bool) public botList;
966 
967     constructor() public {
968         botList[0x776B4a13093e30B05781F97F6A4565B6aa8BE330] = true;
969 
970         botList[0xAED662abcC4FA3314985E67Ea993CAD064a7F5cF] = true;
971         botList[0xa5d330F6619d6bF892A5B87D80272e1607b3e34D] = true;
972         botList[0x5feB4DeE5150B589a7f567EA7CADa2759794A90A] = true;
973         botList[0x7ca06417c1d6f480d3bB195B80692F95A6B66158] = true;
974     }
975 
976     function setBot(address _botAddr, bool _state) public onlyOwner {
977         botList[_botAddr] = _state;
978     }
979 
980 } contract AaveHelper is DSMath {
981 
982     using SafeERC20 for ERC20;
983 
984     address payable public constant WALLET_ADDR = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
985     address public constant DISCOUNT_ADDR = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;
986 
987     uint public constant MANUAL_SERVICE_FEE = 400; // 0.25% Fee
988     uint public constant AUTOMATIC_SERVICE_FEE = 333; // 0.3% Fee
989 
990     address public constant BOT_REGISTRY_ADDRESS = 0x637726f8b08a7ABE3aE3aCaB01A80E2d8ddeF77B;
991 
992 	address public constant ETH_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
993     address public constant AAVE_LENDING_POOL_ADDRESSES = 0x24a42fD28C976A61Df5D00D0599C34c4f90748c8;
994     uint public constant NINETY_NINE_PERCENT_WEI = 990000000000000000;
995     uint16 public constant AAVE_REFERRAL_CODE = 64;
996 
997     /// @param _collateralAddress underlying token address
998     /// @param _user users address
999 	function getMaxCollateral(address _collateralAddress, address _user) public view returns (uint256) {
1000         address lendingPoolAddressDataProvider = ILendingPoolAddressesProvider(AAVE_LENDING_POOL_ADDRESSES).getLendingPoolDataProvider();
1001         address lendingPoolCoreAddress = ILendingPoolAddressesProvider(AAVE_LENDING_POOL_ADDRESSES).getLendingPoolCore();
1002         address priceOracleAddress = ILendingPoolAddressesProvider(AAVE_LENDING_POOL_ADDRESSES).getPriceOracle();
1003 
1004         uint256 pow10 = 10 ** (18 - _getDecimals(_collateralAddress));
1005 
1006         // fetch all needed data
1007         (,uint256 totalCollateralETH, uint256 totalBorrowsETH,,uint256 currentLTV,,,) = ILendingPool(lendingPoolAddressDataProvider).calculateUserGlobalData(_user);
1008         (,uint256 tokenLTV,,) = ILendingPool(lendingPoolCoreAddress).getReserveConfiguration(_collateralAddress);
1009         uint256 collateralPrice = IPriceOracleGetterAave(priceOracleAddress).getAssetPrice(_collateralAddress);
1010         uint256 userTokenBalance = ILendingPool(lendingPoolCoreAddress).getUserUnderlyingAssetBalance(_collateralAddress, _user);
1011         uint256 userTokenBalanceEth = wmul(userTokenBalance * pow10, collateralPrice);
1012 
1013 		// if borrow is 0, return whole user balance
1014         if (totalBorrowsETH == 0) {
1015         	return userTokenBalance;
1016         }
1017 
1018         uint256 maxCollateralEth = div(sub(mul(currentLTV, totalCollateralETH), mul(totalBorrowsETH, 100)), currentLTV);
1019 		/// @dev final amount can't be higher than users token balance
1020         maxCollateralEth = maxCollateralEth > userTokenBalanceEth ? userTokenBalanceEth : maxCollateralEth;
1021 
1022         // might happen due to wmul precision
1023         if (maxCollateralEth >= totalCollateralETH) {
1024         	return wdiv(totalCollateralETH, collateralPrice) / pow10;
1025         }
1026 
1027         // get sum of all other reserves multiplied with their liquidation thresholds by reversing formula
1028         uint256 a = sub(wmul(currentLTV, totalCollateralETH), wmul(tokenLTV, userTokenBalanceEth));
1029         // add new collateral amount multiplied by its threshold, and then divide with new total collateral
1030         uint256 newLiquidationThreshold = wdiv(add(a, wmul(sub(userTokenBalanceEth, maxCollateralEth), tokenLTV)), sub(totalCollateralETH, maxCollateralEth));
1031 
1032         // if new threshold is lower than first one, calculate new max collateral with newLiquidationThreshold
1033         if (newLiquidationThreshold < currentLTV) {
1034         	maxCollateralEth = div(sub(mul(newLiquidationThreshold, totalCollateralETH), mul(totalBorrowsETH, 100)), newLiquidationThreshold);
1035         	maxCollateralEth = maxCollateralEth > userTokenBalanceEth ? userTokenBalanceEth : maxCollateralEth;
1036         }
1037 
1038 		return wmul(wdiv(maxCollateralEth, collateralPrice) / pow10, NINETY_NINE_PERCENT_WEI);
1039 	}
1040 
1041 	/// @param _borrowAddress underlying token address
1042 	/// @param _user users address
1043 	function getMaxBorrow(address _borrowAddress, address _user) public view returns (uint256) {
1044 		address lendingPoolAddress = ILendingPoolAddressesProvider(AAVE_LENDING_POOL_ADDRESSES).getLendingPool();
1045 		address priceOracleAddress = ILendingPoolAddressesProvider(AAVE_LENDING_POOL_ADDRESSES).getPriceOracle();
1046 
1047 		(,,,,uint256 availableBorrowsETH,,,) = ILendingPool(lendingPoolAddress).getUserAccountData(_user);
1048 
1049 		uint256 borrowPrice = IPriceOracleGetterAave(priceOracleAddress).getAssetPrice(_borrowAddress);
1050 
1051 		return wmul(wdiv(availableBorrowsETH, borrowPrice) / (10 ** (18 - _getDecimals(_borrowAddress))), NINETY_NINE_PERCENT_WEI);
1052 	}
1053 
1054     function getMaxBoost(address _borrowAddress, address _collateralAddress, address _user) public view returns (uint256) {
1055         address lendingPoolAddressDataProvider = ILendingPoolAddressesProvider(AAVE_LENDING_POOL_ADDRESSES).getLendingPoolDataProvider();
1056         address lendingPoolCoreAddress = ILendingPoolAddressesProvider(AAVE_LENDING_POOL_ADDRESSES).getLendingPoolCore();
1057         address priceOracleAddress = ILendingPoolAddressesProvider(AAVE_LENDING_POOL_ADDRESSES).getPriceOracle();
1058 
1059         (,uint256 totalCollateralETH, uint256 totalBorrowsETH,,uint256 currentLTV,,,) = ILendingPool(lendingPoolAddressDataProvider).calculateUserGlobalData(_user);
1060         (,uint256 tokenLTV,,) = ILendingPool(lendingPoolCoreAddress).getReserveConfiguration(_collateralAddress);
1061         totalCollateralETH = div(mul(totalCollateralETH, currentLTV), 100);
1062 
1063         uint256 availableBorrowsETH = wmul(mul(div(sub(totalCollateralETH, totalBorrowsETH), sub(100, tokenLTV)), 100), NINETY_NINE_PERCENT_WEI);
1064         uint256 borrowPrice = IPriceOracleGetterAave(priceOracleAddress).getAssetPrice(_borrowAddress);
1065 
1066         return wdiv(availableBorrowsETH, borrowPrice) / (10 ** (18 - _getDecimals(_borrowAddress)));
1067     }
1068 
1069     /// @notice Calculates the fee amount
1070     /// @param _amount Amount that is converted
1071     /// @param _user Actuall user addr not DSProxy
1072     /// @param _gasCost Ether amount of gas we are spending for tx
1073     /// @param _tokenAddr token addr. of token we are getting for the fee
1074     /// @return feeAmount The amount we took for the fee
1075     function getFee(uint _amount, address _user, uint _gasCost, address _tokenAddr) internal returns (uint feeAmount) {
1076         address priceOracleAddress = ILendingPoolAddressesProvider(AAVE_LENDING_POOL_ADDRESSES).getPriceOracle();
1077 
1078         uint fee = MANUAL_SERVICE_FEE;
1079 
1080         if (BotRegistry(BOT_REGISTRY_ADDRESS).botList(tx.origin)) {
1081             fee = AUTOMATIC_SERVICE_FEE;
1082         }
1083 
1084         if (Discount(DISCOUNT_ADDR).isCustomFeeSet(_user)) {
1085             fee = Discount(DISCOUNT_ADDR).getCustomServiceFee(_user);
1086         }
1087 
1088         feeAmount = (fee == 0) ? 0 : (_amount / fee);
1089 
1090         if (_gasCost != 0) {
1091             uint256 price = IPriceOracleGetterAave(priceOracleAddress).getAssetPrice(_tokenAddr);
1092 
1093             _gasCost = wdiv(_gasCost, price) / (10 ** (18 - _getDecimals(_tokenAddr)));
1094 
1095             feeAmount = add(feeAmount, _gasCost);
1096         }
1097 
1098         // fee can't go over 20% of the whole amount
1099         if (feeAmount > (_amount / 5)) {
1100             feeAmount = _amount / 5;
1101         }
1102 
1103         if (_tokenAddr == ETH_ADDR) {
1104             WALLET_ADDR.transfer(feeAmount);
1105         } else {
1106             ERC20(_tokenAddr).safeTransfer(WALLET_ADDR, feeAmount);
1107         }
1108     }
1109 
1110     /// @notice Calculates the gas cost for transaction
1111     /// @param _amount Amount that is converted
1112     /// @param _user Actuall user addr not DSProxy
1113     /// @param _gasCost Ether amount of gas we are spending for tx
1114     /// @param _tokenAddr token addr. of token we are getting for the fee
1115     /// @return gasCost The amount we took for the gas cost
1116     function getGasCost(uint _amount, address _user, uint _gasCost, address _tokenAddr) internal returns (uint gasCost) {
1117         address priceOracleAddress = ILendingPoolAddressesProvider(AAVE_LENDING_POOL_ADDRESSES).getPriceOracle();
1118 
1119         if (_gasCost != 0) {
1120             uint256 price = IPriceOracleGetterAave(priceOracleAddress).getAssetPrice(_tokenAddr);
1121             _gasCost = wmul(_gasCost, price);
1122 
1123             gasCost = _gasCost;
1124         }
1125 
1126         // fee can't go over 20% of the whole amount
1127         if (gasCost > (_amount / 5)) {
1128             gasCost = _amount / 5;
1129         }
1130 
1131         if (_tokenAddr == ETH_ADDR) {
1132             WALLET_ADDR.transfer(gasCost);
1133         } else {
1134             ERC20(_tokenAddr).safeTransfer(WALLET_ADDR, gasCost);
1135         }
1136     }
1137 
1138 
1139     /// @notice Returns the owner of the DSProxy that called the contract
1140     function getUserAddress() internal view returns (address) {
1141         DSProxy proxy = DSProxy(payable(address(this)));
1142 
1143         return proxy.owner();
1144     }
1145 
1146     /// @notice Approves token contract to pull underlying tokens from the DSProxy
1147     /// @param _tokenAddr Token we are trying to approve
1148     /// @param _caller Address which will gain the approval
1149     function approveToken(address _tokenAddr, address _caller) internal {
1150         if (_tokenAddr != ETH_ADDR) {
1151             ERC20(_tokenAddr).safeApprove(_caller, uint256(-1));
1152         }
1153     }
1154 
1155     /// @notice Send specific amount from contract to specific user
1156     /// @param _token Token we are trying to send
1157     /// @param _user User that should receive funds
1158     /// @param _amount Amount that should be sent
1159     function sendContractBalance(address _token, address _user, uint _amount) public {
1160         if (_amount == 0) return;
1161 
1162         if (_token == ETH_ADDR) {
1163             payable(_user).transfer(_amount);
1164         } else {
1165             ERC20(_token).safeTransfer(_user, _amount);
1166         }
1167     }
1168 
1169     function sendFullContractBalance(address _token, address _user) public {
1170         if (_token == ETH_ADDR) {
1171             sendContractBalance(_token, _user, address(this).balance);
1172         } else {
1173             sendContractBalance(_token, _user, ERC20(_token).balanceOf(address(this)));
1174         }
1175     }
1176 
1177     function _getDecimals(address _token) internal view returns (uint256) {
1178         if (_token == ETH_ADDR) return 18;
1179 
1180         return ERC20(_token).decimals();
1181     }
1182 } contract AaveSafetyRatio is AaveHelper {
1183 
1184     function getSafetyRatio(address _user) public view returns(uint256) {
1185         address lendingPoolAddress = ILendingPoolAddressesProvider(AAVE_LENDING_POOL_ADDRESSES).getLendingPool();
1186         (,,uint256 totalBorrowsETH,,uint256 availableBorrowsETH,,,) = ILendingPool(lendingPoolAddress).getUserAccountData(_user);
1187 
1188         if (totalBorrowsETH == 0) return uint256(0);
1189 
1190         return wdiv(add(totalBorrowsETH, availableBorrowsETH), totalBorrowsETH);
1191     }
1192 } abstract contract TokenInterface {
1193     function allowance(address, address) public virtual returns (uint256);
1194 
1195     function balanceOf(address) public virtual returns (uint256);
1196 
1197     function approve(address, uint256) public virtual;
1198 
1199     function transfer(address, uint256) public virtual returns (bool);
1200 
1201     function transferFrom(address, address, uint256) public virtual returns (bool);
1202 
1203     function deposit() public virtual payable;
1204 
1205     function withdraw(uint256) public virtual;
1206 } interface ExchangeInterfaceV2 {
1207     function sell(address _srcAddr, address _destAddr, uint _srcAmount) external payable returns (uint);
1208 
1209     function buy(address _srcAddr, address _destAddr, uint _destAmount) external payable returns(uint);
1210 
1211     function getSellRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);
1212 
1213     function getBuyRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);
1214 } contract ZrxAllowlist is AdminAuth {
1215 
1216     mapping (address => bool) public zrxAllowlist;
1217     mapping(address => bool) private nonPayableAddrs;
1218 
1219     constructor() public {
1220         zrxAllowlist[0x6958F5e95332D93D21af0D7B9Ca85B8212fEE0A5] = true;
1221         zrxAllowlist[0x61935CbDd02287B511119DDb11Aeb42F1593b7Ef] = true;
1222         zrxAllowlist[0xDef1C0ded9bec7F1a1670819833240f027b25EfF] = true;
1223         zrxAllowlist[0x080bf510FCbF18b91105470639e9561022937712] = true;
1224 
1225         nonPayableAddrs[0x080bf510FCbF18b91105470639e9561022937712] = true;
1226     }
1227 
1228     function setAllowlistAddr(address _zrxAddr, bool _state) public onlyOwner {
1229         zrxAllowlist[_zrxAddr] = _state;
1230     }
1231 
1232     function isZrxAddr(address _zrxAddr) public view returns (bool) {
1233         return zrxAllowlist[_zrxAddr];
1234     }
1235 
1236     function addNonPayableAddr(address _nonPayableAddr) public onlyOwner {
1237 		nonPayableAddrs[_nonPayableAddr] = true;
1238 	}
1239 
1240 	function removeNonPayableAddr(address _nonPayableAddr) public onlyOwner {
1241 		nonPayableAddrs[_nonPayableAddr] = false;
1242 	}
1243 
1244 	function isNonPayableAddr(address _addr) public view returns(bool) {
1245 		return nonPayableAddrs[_addr];
1246 	}
1247 } contract SaverExchangeHelper {
1248 
1249     using SafeERC20 for ERC20;
1250 
1251     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1252     address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1253 
1254     address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
1255     address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;
1256     address public constant SAVER_EXCHANGE_REGISTRY = 0x25dd3F51e0C3c3Ff164DDC02A8E4D65Bb9cBB12D;
1257 
1258     address public constant ERC20_PROXY_0X = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
1259     address public constant ZRX_ALLOWLIST_ADDR = 0x4BA1f38427b33B8ab7Bb0490200dAE1F1C36823F;
1260 
1261 
1262     function getDecimals(address _token) internal view returns (uint256) {
1263         if (_token == KYBER_ETH_ADDRESS) return 18;
1264 
1265         return ERC20(_token).decimals();
1266     }
1267 
1268     function getBalance(address _tokenAddr) internal view returns (uint balance) {
1269         if (_tokenAddr == KYBER_ETH_ADDRESS) {
1270             balance = address(this).balance;
1271         } else {
1272             balance = ERC20(_tokenAddr).balanceOf(address(this));
1273         }
1274     }
1275 
1276     function approve0xProxy(address _tokenAddr, uint _amount) internal {
1277         if (_tokenAddr != KYBER_ETH_ADDRESS) {
1278             ERC20(_tokenAddr).safeApprove(address(ERC20_PROXY_0X), _amount);
1279         }
1280     }
1281 
1282     function sendLeftover(address _srcAddr, address _destAddr, address payable _to) internal {
1283         // send back any leftover ether or tokens
1284         if (address(this).balance > 0) {
1285             _to.transfer(address(this).balance);
1286         }
1287 
1288         if (getBalance(_srcAddr) > 0) {
1289             ERC20(_srcAddr).safeTransfer(_to, getBalance(_srcAddr));
1290         }
1291 
1292         if (getBalance(_destAddr) > 0) {
1293             ERC20(_destAddr).safeTransfer(_to, getBalance(_destAddr));
1294         }
1295     }
1296 
1297     function sliceUint(bytes memory bs, uint256 start) internal pure returns (uint256) {
1298         require(bs.length >= start + 32, "slicing out of range");
1299 
1300         uint256 x;
1301         assembly {
1302             x := mload(add(bs, add(0x20, start)))
1303         }
1304 
1305         return x;
1306     }
1307 } contract SaverExchangeRegistry is AdminAuth {
1308 
1309 	mapping(address => bool) private wrappers;
1310 
1311 	constructor() public {
1312 		wrappers[0x880A845A85F843a5c67DB2061623c6Fc3bB4c511] = true;
1313 		wrappers[0x4c9B55f2083629A1F7aDa257ae984E03096eCD25] = true;
1314 		wrappers[0x42A9237b872368E1bec4Ca8D26A928D7d39d338C] = true;
1315 	}
1316 
1317 	function addWrapper(address _wrapper) public onlyOwner {
1318 		wrappers[_wrapper] = true;
1319 	}
1320 
1321 	function removeWrapper(address _wrapper) public onlyOwner {
1322 		wrappers[_wrapper] = false;
1323 	}
1324 
1325 	function isWrapper(address _wrapper) public view returns(bool) {
1326 		return wrappers[_wrapper];
1327 	}
1328 }
1329 
1330 
1331 
1332 
1333 
1334 
1335 
1336 
1337 contract SaverExchangeCore is SaverExchangeHelper, DSMath {
1338 
1339     // first is empty to keep the legacy order in place
1340     enum ExchangeType { _, OASIS, KYBER, UNISWAP, ZEROX }
1341 
1342     enum ActionType { SELL, BUY }
1343 
1344     struct ExchangeData {
1345         address srcAddr;
1346         address destAddr;
1347         uint srcAmount;
1348         uint destAmount;
1349         uint minPrice;
1350         address wrapper;
1351         address exchangeAddr;
1352         bytes callData;
1353         uint256 price0x;
1354     }
1355 
1356     /// @notice Internal method that preforms a sell on 0x/on-chain
1357     /// @dev Usefull for other DFS contract to integrate for exchanging
1358     /// @param exData Exchange data struct
1359     /// @return (address, uint) Address of the wrapper used and destAmount
1360     function _sell(ExchangeData memory exData) internal returns (address, uint) {
1361 
1362         address wrapper;
1363         uint swapedTokens;
1364         bool success;
1365         uint tokensLeft = exData.srcAmount;
1366 
1367         // if selling eth, convert to weth
1368         if (exData.srcAddr == KYBER_ETH_ADDRESS) {
1369             exData.srcAddr = ethToWethAddr(exData.srcAddr);
1370             TokenInterface(WETH_ADDRESS).deposit.value(exData.srcAmount)();
1371         }
1372 
1373         // Try 0x first and then fallback on specific wrapper
1374         if (exData.price0x > 0) {
1375             approve0xProxy(exData.srcAddr, exData.srcAmount);
1376 
1377             uint ethAmount = getProtocolFee(exData.srcAddr, exData.srcAmount);
1378             (success, swapedTokens, tokensLeft) = takeOrder(exData, ethAmount, ActionType.SELL);
1379 
1380             if (success) {
1381                 wrapper = exData.exchangeAddr;
1382             }
1383         }
1384 
1385         // fallback to desired wrapper if 0x failed
1386         if (!success) {
1387             swapedTokens = saverSwap(exData, ActionType.SELL);
1388             wrapper = exData.wrapper;
1389         }
1390 
1391         require(getBalance(exData.destAddr) >= wmul(exData.minPrice, exData.srcAmount), "Final amount isn't correct");
1392 
1393         // if anything is left in weth, pull it to user as eth
1394         if (getBalance(WETH_ADDRESS) > 0) {
1395             TokenInterface(WETH_ADDRESS).withdraw(
1396                 TokenInterface(WETH_ADDRESS).balanceOf(address(this))
1397             );
1398         }
1399 
1400         return (wrapper, swapedTokens);
1401     }
1402 
1403     /// @notice Internal method that preforms a buy on 0x/on-chain
1404     /// @dev Usefull for other DFS contract to integrate for exchanging
1405     /// @param exData Exchange data struct
1406     /// @return (address, uint) Address of the wrapper used and srcAmount
1407     function _buy(ExchangeData memory exData) internal returns (address, uint) {
1408 
1409         address wrapper;
1410         uint swapedTokens;
1411         bool success;
1412 
1413         require(exData.destAmount != 0, "Dest amount must be specified");
1414 
1415         // if selling eth, convert to weth
1416         if (exData.srcAddr == KYBER_ETH_ADDRESS) {
1417             exData.srcAddr = ethToWethAddr(exData.srcAddr);
1418             TokenInterface(WETH_ADDRESS).deposit.value(exData.srcAmount)();
1419         }
1420 
1421         if (exData.price0x > 0) {
1422             approve0xProxy(exData.srcAddr, exData.srcAmount);
1423 
1424             uint ethAmount = getProtocolFee(exData.srcAddr, exData.srcAmount);
1425             (success, swapedTokens,) = takeOrder(exData, ethAmount, ActionType.BUY);
1426 
1427             if (success) {
1428                 wrapper = exData.exchangeAddr;
1429             }
1430         }
1431 
1432         // fallback to desired wrapper if 0x failed
1433         if (!success) {
1434             swapedTokens = saverSwap(exData, ActionType.BUY);
1435             wrapper = exData.wrapper;
1436         }
1437 
1438         require(getBalance(exData.destAddr) >= exData.destAmount, "Final amount isn't correct");
1439 
1440         // if anything is left in weth, pull it to user as eth
1441         if (getBalance(WETH_ADDRESS) > 0) {
1442             TokenInterface(WETH_ADDRESS).withdraw(
1443                 TokenInterface(WETH_ADDRESS).balanceOf(address(this))
1444             );
1445         }
1446 
1447         return (wrapper, getBalance(exData.destAddr));
1448     }
1449 
1450     /// @notice Takes order from 0x and returns bool indicating if it is successful
1451     /// @param _exData Exchange data
1452     /// @param _ethAmount Ether fee needed for 0x order
1453     function takeOrder(
1454         ExchangeData memory _exData,
1455         uint256 _ethAmount,
1456         ActionType _type
1457     ) private returns (bool success, uint256, uint256) {
1458 
1459         // write in the exact amount we are selling/buing in an order
1460         if (_type == ActionType.SELL) {
1461             writeUint256(_exData.callData, 36, _exData.srcAmount);
1462         } else {
1463             writeUint256(_exData.callData, 36, _exData.destAmount);
1464         }
1465 
1466         if (ZrxAllowlist(ZRX_ALLOWLIST_ADDR).isNonPayableAddr(_exData.exchangeAddr)) {
1467             _ethAmount = 0;
1468         }
1469 
1470         uint256 tokensBefore = getBalance(_exData.destAddr);
1471 
1472         if (ZrxAllowlist(ZRX_ALLOWLIST_ADDR).isZrxAddr(_exData.exchangeAddr)) {
1473             (success, ) = _exData.exchangeAddr.call{value: _ethAmount}(_exData.callData);
1474         } else {
1475             success = false;
1476         }
1477 
1478         uint256 tokensSwaped = 0;
1479         uint256 tokensLeft = _exData.srcAmount;
1480 
1481         if (success) {
1482             // check to see if any _src tokens are left over after exchange
1483             tokensLeft = getBalance(_exData.srcAddr);
1484 
1485             // convert weth -> eth if needed
1486             if (_exData.destAddr == KYBER_ETH_ADDRESS) {
1487                 TokenInterface(WETH_ADDRESS).withdraw(
1488                     TokenInterface(WETH_ADDRESS).balanceOf(address(this))
1489                 );
1490             }
1491 
1492             // get the current balance of the swaped tokens
1493             tokensSwaped = getBalance(_exData.destAddr) - tokensBefore;
1494         }
1495 
1496         return (success, tokensSwaped, tokensLeft);
1497     }
1498 
1499     /// @notice Calls wraper contract for exchage to preform an on-chain swap
1500     /// @param _exData Exchange data struct
1501     /// @param _type Type of action SELL|BUY
1502     /// @return swapedTokens For Sell that the destAmount, for Buy thats the srcAmount
1503     function saverSwap(ExchangeData memory _exData, ActionType _type) internal returns (uint swapedTokens) {
1504         require(SaverExchangeRegistry(SAVER_EXCHANGE_REGISTRY).isWrapper(_exData.wrapper), "Wrapper is not valid");
1505 
1506         uint ethValue = 0;
1507 
1508         ERC20(_exData.srcAddr).safeTransfer(_exData.wrapper, _exData.srcAmount);
1509 
1510         if (_type == ActionType.SELL) {
1511             swapedTokens = ExchangeInterfaceV2(_exData.wrapper).
1512                     sell{value: ethValue}(_exData.srcAddr, _exData.destAddr, _exData.srcAmount);
1513         } else {
1514             swapedTokens = ExchangeInterfaceV2(_exData.wrapper).
1515                     buy{value: ethValue}(_exData.srcAddr, _exData.destAddr, _exData.destAmount);
1516         }
1517     }
1518 
1519     function writeUint256(bytes memory _b, uint256 _index, uint _input) internal pure {
1520         if (_b.length < _index + 32) {
1521             revert("Incorrent lengt while writting bytes32");
1522         }
1523 
1524         bytes32 input = bytes32(_input);
1525 
1526         _index += 32;
1527 
1528         // Read the bytes32 from array memory
1529         assembly {
1530             mstore(add(_b, _index), input)
1531         }
1532     }
1533 
1534     /// @notice Converts Kybers Eth address -> Weth
1535     /// @param _src Input address
1536     function ethToWethAddr(address _src) internal pure returns (address) {
1537         return _src == KYBER_ETH_ADDRESS ? WETH_ADDRESS : _src;
1538     }
1539 
1540     /// @notice Calculates protocol fee
1541     /// @param _srcAddr selling token address (if eth should be WETH)
1542     /// @param _srcAmount amount we are selling
1543     function getProtocolFee(address _srcAddr, uint256 _srcAmount) internal view returns(uint256) {
1544         // if we are not selling ETH msg value is always the protocol fee
1545         if (_srcAddr != WETH_ADDRESS) return address(this).balance;
1546 
1547         // if msg value is larger than srcAmount, that means that msg value is protocol fee + srcAmount, so we subsctract srcAmount from msg value
1548         // we have an edge case here when protocol fee is higher than selling amount
1549         if (address(this).balance > _srcAmount) return address(this).balance - _srcAmount;
1550 
1551         // if msg value is lower than src amount, that means that srcAmount isn't included in msg value, so we return msg value
1552         return address(this).balance;
1553     }
1554 
1555     function packExchangeData(ExchangeData memory _exData) public pure returns(bytes memory) {
1556         // splitting in two different bytes and encoding all because of stack too deep in decoding part
1557 
1558         bytes memory part1 = abi.encode(
1559             _exData.srcAddr,
1560             _exData.destAddr,
1561             _exData.srcAmount,
1562             _exData.destAmount
1563         );
1564 
1565         bytes memory part2 = abi.encode(
1566             _exData.minPrice,
1567             _exData.wrapper,
1568             _exData.exchangeAddr,
1569             _exData.callData,
1570             _exData.price0x
1571         );
1572 
1573 
1574         return abi.encode(part1, part2);
1575     }
1576 
1577     function unpackExchangeData(bytes memory _data) public pure returns(ExchangeData memory _exData) {
1578         (
1579             bytes memory part1,
1580             bytes memory part2
1581         ) = abi.decode(_data, (bytes,bytes));
1582 
1583         (
1584             _exData.srcAddr,
1585             _exData.destAddr,
1586             _exData.srcAmount,
1587             _exData.destAmount
1588         ) = abi.decode(part1, (address,address,uint256,uint256));
1589 
1590         (
1591             _exData.minPrice,
1592             _exData.wrapper,
1593             _exData.exchangeAddr,
1594             _exData.callData,
1595             _exData.price0x
1596         )
1597         = abi.decode(part2, (uint256,address,address,bytes,uint256));
1598     }
1599 
1600     // solhint-disable-next-line no-empty-blocks
1601     receive() external virtual payable {}
1602 }
1603 
1604 
1605 
1606 
1607 
1608 
1609 
1610 
1611 
1612 
1613 /// @title Contract implements logic of calling boost/repay in the automatic system
1614 contract AaveMonitor is AdminAuth, DSMath, AaveSafetyRatio, GasBurner {
1615 
1616     using SafeERC20 for ERC20;
1617 
1618     enum Method { Boost, Repay }
1619 
1620     uint public REPAY_GAS_TOKEN = 20;
1621     uint public BOOST_GAS_TOKEN = 20;
1622 
1623     uint public MAX_GAS_PRICE = 400000000000; // 400 gwei
1624 
1625     uint public REPAY_GAS_COST = 2500000;
1626     uint public BOOST_GAS_COST = 2500000;
1627 
1628     address public constant DEFISAVER_LOGGER = 0x5c55B921f590a89C1Ebe84dF170E655a82b62126;
1629 
1630     AaveMonitorProxy public aaveMonitorProxy;
1631     AaveSubscriptions public subscriptionsContract;
1632     address public aaveSaverProxy;
1633 
1634     DefisaverLogger public logger = DefisaverLogger(DEFISAVER_LOGGER);
1635 
1636     modifier onlyApproved() {
1637         require(BotRegistry(BOT_REGISTRY_ADDRESS).botList(msg.sender), "Not auth bot");
1638         _;
1639     }
1640 
1641     /// @param _aaveMonitorProxy Proxy contracts that actually is authorized to call DSProxy
1642     /// @param _subscriptions Subscriptions contract for Aave positions
1643     /// @param _aaveSaverProxy Contract that actually performs Repay/Boost
1644     constructor(address _aaveMonitorProxy, address _subscriptions, address _aaveSaverProxy) public {
1645         aaveMonitorProxy = AaveMonitorProxy(_aaveMonitorProxy);
1646         subscriptionsContract = AaveSubscriptions(_subscriptions);
1647         aaveSaverProxy = _aaveSaverProxy;
1648     }
1649 
1650     /// @notice Bots call this method to repay for user when conditions are met
1651     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
1652     /// @param _exData Exchange data
1653     /// @param _user The actual address that owns the Aave position
1654     function repayFor(
1655         SaverExchangeCore.ExchangeData memory _exData,
1656         address _user
1657     ) public payable onlyApproved burnGas(REPAY_GAS_TOKEN) {
1658 
1659         (bool isAllowed, uint ratioBefore) = canCall(Method.Repay, _user);
1660         require(isAllowed); // check if conditions are met
1661 
1662         uint256 gasCost = calcGasCost(REPAY_GAS_COST);
1663 
1664         aaveMonitorProxy.callExecute{value: msg.value}(
1665             _user,
1666             aaveSaverProxy,
1667             abi.encodeWithSignature(
1668                 "repay((address,address,uint256,uint256,uint256,address,address,bytes,uint256),uint256)",
1669                 _exData,
1670                 gasCost
1671             )
1672         );
1673 
1674         (bool isGoodRatio, uint ratioAfter) = ratioGoodAfter(Method.Repay, _user);
1675         require(isGoodRatio); // check if the after result of the actions is good
1676 
1677         returnEth();
1678 
1679         logger.Log(address(this), _user, "AutomaticAaveRepay", abi.encode(ratioBefore, ratioAfter));
1680     }
1681 
1682     /// @notice Bots call this method to boost for user when conditions are met
1683     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
1684     /// @param _exData Exchange data
1685     /// @param _user The actual address that owns the Aave position
1686     function boostFor(
1687         SaverExchangeCore.ExchangeData memory _exData,
1688         address _user
1689     ) public payable onlyApproved burnGas(BOOST_GAS_TOKEN) {
1690 
1691         (bool isAllowed, uint ratioBefore) = canCall(Method.Boost, _user);
1692         require(isAllowed); // check if conditions are met
1693 
1694         uint256 gasCost = calcGasCost(BOOST_GAS_COST);
1695 
1696         aaveMonitorProxy.callExecute{value: msg.value}(
1697             _user,
1698             aaveSaverProxy,
1699             abi.encodeWithSignature(
1700                 "boost((address,address,uint256,uint256,uint256,address,address,bytes,uint256),uint256)",
1701                 _exData,
1702                 gasCost
1703             )
1704         );
1705 
1706 
1707         (bool isGoodRatio, uint ratioAfter) = ratioGoodAfter(Method.Boost, _user);
1708         require(isGoodRatio);  // check if the after result of the actions is good
1709 
1710         returnEth();
1711 
1712         logger.Log(address(this), _user, "AutomaticAaveBoost", abi.encode(ratioBefore, ratioAfter));
1713     }
1714 
1715 /******************* INTERNAL METHODS ********************************/
1716     function returnEth() internal {
1717         // return if some eth left
1718         if (address(this).balance > 0) {
1719             msg.sender.transfer(address(this).balance);
1720         }
1721     }
1722 
1723 /******************* STATIC METHODS ********************************/
1724 
1725     /// @notice Checks if Boost/Repay could be triggered for the CDP
1726     /// @dev Called by AaveMonitor to enforce the min/max check
1727     /// @param _method Type of action to be called
1728     /// @param _user The actual address that owns the Aave position
1729     /// @return Boolean if it can be called and the ratio
1730     function canCall(Method _method, address _user) public view returns(bool, uint) {
1731         bool subscribed = subscriptionsContract.isSubscribed(_user);
1732         AaveSubscriptions.AaveHolder memory holder = subscriptionsContract.getHolder(_user);
1733 
1734         // check if cdp is subscribed
1735         if (!subscribed) return (false, 0);
1736 
1737         // check if boost and boost allowed
1738         if (_method == Method.Boost && !holder.boostEnabled) return (false, 0);
1739 
1740         uint currRatio = getSafetyRatio(_user);
1741 
1742         if (_method == Method.Repay) {
1743             return (currRatio < holder.minRatio, currRatio);
1744         } else if (_method == Method.Boost) {
1745             return (currRatio > holder.maxRatio, currRatio);
1746         }
1747     }
1748 
1749     /// @dev After the Boost/Repay check if the ratio doesn't trigger another call
1750     /// @param _method Type of action to be called
1751     /// @param _user The actual address that owns the Aave position
1752     /// @return Boolean if the recent action preformed correctly and the ratio
1753     function ratioGoodAfter(Method _method, address _user) public view returns(bool, uint) {
1754         AaveSubscriptions.AaveHolder memory holder;
1755 
1756         holder= subscriptionsContract.getHolder(_user);
1757 
1758         uint currRatio = getSafetyRatio(_user);
1759 
1760         if (_method == Method.Repay) {
1761             return (currRatio < holder.maxRatio, currRatio);
1762         } else if (_method == Method.Boost) {
1763             return (currRatio > holder.minRatio, currRatio);
1764         }
1765     }
1766 
1767     /// @notice Calculates gas cost (in Eth) of tx
1768     /// @dev Gas price is limited to MAX_GAS_PRICE to prevent attack of draining user CDP
1769     /// @param _gasAmount Amount of gas used for the tx
1770     function calcGasCost(uint _gasAmount) public view returns (uint) {
1771         uint gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;
1772 
1773         return mul(gasPrice, _gasAmount);
1774     }
1775 
1776 /******************* OWNER ONLY OPERATIONS ********************************/
1777 
1778     /// @notice As the code is new, have a emergancy admin saver proxy change
1779     function changeAaveSaverProxy(address _newAaveSaverProxy) public onlyAdmin {
1780         aaveSaverProxy = _newAaveSaverProxy;
1781     }
1782 
1783     /// @notice Allows owner to change gas cost for boost operation, but only up to 3 millions
1784     /// @param _gasCost New gas cost for boost method
1785     function changeBoostGasCost(uint _gasCost) public onlyOwner {
1786         require(_gasCost < 3000000);
1787 
1788         BOOST_GAS_COST = _gasCost;
1789     }
1790 
1791     /// @notice Allows owner to change gas cost for repay operation, but only up to 3 millions
1792     /// @param _gasCost New gas cost for repay method
1793     function changeRepayGasCost(uint _gasCost) public onlyOwner {
1794         require(_gasCost < 3000000);
1795 
1796         REPAY_GAS_COST = _gasCost;
1797     }
1798 
1799     /// @notice Allows owner to change max gas price
1800     /// @param _maxGasPrice New max gas price
1801     function changeMaxGasPrice(uint _maxGasPrice) public onlyOwner {
1802         require(_maxGasPrice < 500000000000);
1803 
1804         MAX_GAS_PRICE = _maxGasPrice;
1805     }
1806 
1807     /// @notice Allows owner to change gas token amount
1808     /// @param _gasTokenAmount New gas token amount
1809     /// @param _repay true if repay gas token, false if boost gas token
1810     function changeGasTokenAmount(uint _gasTokenAmount, bool _repay) public onlyOwner {
1811         if (_repay) {
1812             REPAY_GAS_TOKEN = _gasTokenAmount;
1813         } else {
1814             BOOST_GAS_TOKEN = _gasTokenAmount;
1815         }
1816     }
1817 }