1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.8.10;
4 
5 
6 
7 
8 
9 abstract contract IDFSRegistry {
10  
11     function getAddr(bytes4 _id) public view virtual returns (address);
12 
13     function addNewContract(
14         bytes32 _id,
15         address _contractAddr,
16         uint256 _waitPeriod
17     ) public virtual;
18 
19     function startContractChange(bytes32 _id, address _newContractAddr) public virtual;
20 
21     function approveContractChange(bytes32 _id) public virtual;
22 
23     function cancelContractChange(bytes32 _id) public virtual;
24 
25     function changeWaitPeriod(bytes32 _id, uint256 _newWaitPeriod) public virtual;
26 }
27 
28 
29 
30 
31 
32 interface IERC20 {
33     function name() external view returns (string memory);
34     function symbol() external view returns (string memory);
35     function decimals() external view returns (uint256 digits);
36     function totalSupply() external view returns (uint256 supply);
37 
38     function balanceOf(address _owner) external view returns (uint256 balance);
39 
40     function transfer(address _to, uint256 _value) external returns (bool success);
41 
42     function transferFrom(
43         address _from,
44         address _to,
45         uint256 _value
46     ) external returns (bool success);
47 
48     function approve(address _spender, uint256 _value) external returns (bool success);
49 
50     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
51 
52     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53 }
54 
55 
56 
57 
58 
59 library Address {
60     //insufficient balance
61     error InsufficientBalance(uint256 available, uint256 required);
62     //unable to send value, recipient may have reverted
63     error SendingValueFail();
64     //insufficient balance for call
65     error InsufficientBalanceForCall(uint256 available, uint256 required);
66     //call to non-contract
67     error NonContractCall();
68     
69     function isContract(address account) internal view returns (bool) {
70         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
71         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
72         // for accounts without code, i.e. `keccak256('')`
73         bytes32 codehash;
74         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
75         // solhint-disable-next-line no-inline-assembly
76         assembly {
77             codehash := extcodehash(account)
78         }
79         return (codehash != accountHash && codehash != 0x0);
80     }
81 
82     function sendValue(address payable recipient, uint256 amount) internal {
83         uint256 balance = address(this).balance;
84         if (balance < amount){
85             revert InsufficientBalance(balance, amount);
86         }
87 
88         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
89         (bool success, ) = recipient.call{value: amount}("");
90         if (!(success)){
91             revert SendingValueFail();
92         }
93     }
94 
95     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
96         return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return _functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     function functionCallWithValue(
108         address target,
109         bytes memory data,
110         uint256 value
111     ) internal returns (bytes memory) {
112         return
113             functionCallWithValue(target, data, value, "Address: low-level call with value failed");
114     }
115 
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value,
120         string memory errorMessage
121     ) internal returns (bytes memory) {
122         uint256 balance = address(this).balance;
123         if (balance < value){
124             revert InsufficientBalanceForCall(balance, value);
125         }
126         return _functionCallWithValue(target, data, value, errorMessage);
127     }
128 
129     function _functionCallWithValue(
130         address target,
131         bytes memory data,
132         uint256 weiValue,
133         string memory errorMessage
134     ) private returns (bytes memory) {
135         if (!(isContract(target))){
136             revert NonContractCall();
137         }
138 
139         // solhint-disable-next-line avoid-low-level-calls
140         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
141         if (success) {
142             return returndata;
143         } else {
144             // Look for revert reason and bubble it up if present
145             if (returndata.length > 0) {
146                 // The easiest way to bubble the revert reason is using memory via assembly
147 
148                 // solhint-disable-next-line no-inline-assembly
149                 assembly {
150                     let returndata_size := mload(returndata)
151                     revert(add(32, returndata), returndata_size)
152                 }
153             } else {
154                 revert(errorMessage);
155             }
156         }
157     }
158 }
159 
160 
161 
162 
163 library SafeMath {
164     function add(uint256 a, uint256 b) internal pure returns (uint256) {
165         uint256 c = a + b;
166         require(c >= a, "SafeMath: addition overflow");
167 
168         return c;
169     }
170 
171     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
172         return sub(a, b, "SafeMath: subtraction overflow");
173     }
174 
175     function sub(
176         uint256 a,
177         uint256 b,
178         string memory errorMessage
179     ) internal pure returns (uint256) {
180         require(b <= a, errorMessage);
181         uint256 c = a - b;
182 
183         return c;
184     }
185 
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     function div(
205         uint256 a,
206         uint256 b,
207         string memory errorMessage
208     ) internal pure returns (uint256) {
209         require(b > 0, errorMessage);
210         uint256 c = a / b;
211         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
212 
213         return c;
214     }
215 
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     function mod(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 
231 
232 
233 
234 
235 
236 library SafeERC20 {
237     using SafeMath for uint256;
238     using Address for address;
239 
240     function safeTransfer(
241         IERC20 token,
242         address to,
243         uint256 value
244     ) internal {
245         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
246     }
247 
248     function safeTransferFrom(
249         IERC20 token,
250         address from,
251         address to,
252         uint256 value
253     ) internal {
254         _callOptionalReturn(
255             token,
256             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
257         );
258     }
259 
260     /// @dev Edited so it always first approves 0 and then the value, because of non standard tokens
261     function safeApprove(
262         IERC20 token,
263         address spender,
264         uint256 value
265     ) internal {
266         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
267         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
268     }
269 
270     function safeIncreaseAllowance(
271         IERC20 token,
272         address spender,
273         uint256 value
274     ) internal {
275         uint256 newAllowance = token.allowance(address(this), spender).add(value);
276         _callOptionalReturn(
277             token,
278             abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
279         );
280     }
281 
282     function safeDecreaseAllowance(
283         IERC20 token,
284         address spender,
285         uint256 value
286     ) internal {
287         uint256 newAllowance = token.allowance(address(this), spender).sub(
288             value,
289             "SafeERC20: decreased allowance below zero"
290         );
291         _callOptionalReturn(
292             token,
293             abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
294         );
295     }
296 
297     function _callOptionalReturn(IERC20 token, bytes memory data) private {
298         bytes memory returndata = address(token).functionCall(
299             data,
300             "SafeERC20: low-level call failed"
301         );
302         if (returndata.length > 0) {
303             // Return data is optional
304             // solhint-disable-next-line max-line-length
305             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
306         }
307     }
308 }
309 
310 
311 
312 
313 
314 contract MainnetAuthAddresses {
315     address internal constant ADMIN_VAULT_ADDR = 0xCCf3d848e08b94478Ed8f46fFead3008faF581fD;
316     address internal constant FACTORY_ADDRESS = 0x5a15566417e6C1c9546523066500bDDBc53F88C7;
317     address internal constant ADMIN_ADDR = 0x25eFA336886C74eA8E282ac466BdCd0199f85BB9; // USED IN ADMIN VAULT CONSTRUCTOR
318 }
319 
320 
321 
322 
323 
324 contract AuthHelper is MainnetAuthAddresses {
325 }
326 
327 
328 
329 
330 
331 contract AdminVault is AuthHelper {
332     address public owner;
333     address public admin;
334 
335     error SenderNotAdmin();
336 
337     constructor() {
338         owner = msg.sender;
339         admin = ADMIN_ADDR;
340     }
341 
342     /// @notice Admin is able to change owner
343     /// @param _owner Address of new owner
344     function changeOwner(address _owner) public {
345         if (admin != msg.sender){
346             revert SenderNotAdmin();
347         }
348         owner = _owner;
349     }
350 
351     /// @notice Admin is able to set new admin
352     /// @param _admin Address of multisig that becomes new admin
353     function changeAdmin(address _admin) public {
354         if (admin != msg.sender){
355             revert SenderNotAdmin();
356         }
357         admin = _admin;
358     }
359 
360 }
361 
362 
363 
364 
365 
366 
367 
368 
369 contract AdminAuth is AuthHelper {
370     using SafeERC20 for IERC20;
371 
372     AdminVault public constant adminVault = AdminVault(ADMIN_VAULT_ADDR);
373 
374     error SenderNotOwner();
375     error SenderNotAdmin();
376 
377     modifier onlyOwner() {
378         if (adminVault.owner() != msg.sender){
379             revert SenderNotOwner();
380         }
381         _;
382     }
383 
384     modifier onlyAdmin() {
385         if (adminVault.admin() != msg.sender){
386             revert SenderNotAdmin();
387         }
388         _;
389     }
390 
391     /// @notice withdraw stuck funds
392     function withdrawStuckFunds(address _token, address _receiver, uint256 _amount) public onlyOwner {
393         if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
394             payable(_receiver).transfer(_amount);
395         } else {
396             IERC20(_token).safeTransfer(_receiver, _amount);
397         }
398     }
399 
400     /// @notice Destroy the contract
401     function kill() public onlyAdmin {
402         selfdestruct(payable(msg.sender));
403     }
404 }
405 
406 
407 
408 
409 
410 contract DFSRegistry is AdminAuth {
411     error EntryAlreadyExistsError(bytes4);
412     error EntryNonExistentError(bytes4);
413     error EntryNotInChangeError(bytes4);
414     error ChangeNotReadyError(uint256,uint256);
415     error EmptyPrevAddrError(bytes4);
416     error AlreadyInContractChangeError(bytes4);
417     error AlreadyInWaitPeriodChangeError(bytes4);
418 
419     event AddNewContract(address,bytes4,address,uint256);
420     event RevertToPreviousAddress(address,bytes4,address,address);
421     event StartContractChange(address,bytes4,address,address);
422     event ApproveContractChange(address,bytes4,address,address);
423     event CancelContractChange(address,bytes4,address,address);
424     event StartWaitPeriodChange(address,bytes4,uint256);
425     event ApproveWaitPeriodChange(address,bytes4,uint256,uint256);
426     event CancelWaitPeriodChange(address,bytes4,uint256,uint256);
427 
428     struct Entry {
429         address contractAddr;
430         uint256 waitPeriod;
431         uint256 changeStartTime;
432         bool inContractChange;
433         bool inWaitPeriodChange;
434         bool exists;
435     }
436 
437     mapping(bytes4 => Entry) public entries;
438     mapping(bytes4 => address) public previousAddresses;
439 
440     mapping(bytes4 => address) public pendingAddresses;
441     mapping(bytes4 => uint256) public pendingWaitTimes;
442 
443     /// @notice Given an contract id returns the registered address
444     /// @dev Id is keccak256 of the contract name
445     /// @param _id Id of contract
446     function getAddr(bytes4 _id) public view returns (address) {
447         return entries[_id].contractAddr;
448     }
449 
450     /// @notice Helper function to easily query if id is registered
451     /// @param _id Id of contract
452     function isRegistered(bytes4 _id) public view returns (bool) {
453         return entries[_id].exists;
454     }
455 
456     /////////////////////////// OWNER ONLY FUNCTIONS ///////////////////////////
457 
458     /// @notice Adds a new contract to the registry
459     /// @param _id Id of contract
460     /// @param _contractAddr Address of the contract
461     /// @param _waitPeriod Amount of time to wait before a contract address can be changed
462     function addNewContract(
463         bytes4 _id,
464         address _contractAddr,
465         uint256 _waitPeriod
466     ) public onlyOwner {
467         if (entries[_id].exists){
468             revert EntryAlreadyExistsError(_id);
469         }
470 
471         entries[_id] = Entry({
472             contractAddr: _contractAddr,
473             waitPeriod: _waitPeriod,
474             changeStartTime: 0,
475             inContractChange: false,
476             inWaitPeriodChange: false,
477             exists: true
478         });
479 
480         emit AddNewContract(msg.sender, _id, _contractAddr, _waitPeriod);
481     }
482 
483     /// @notice Reverts to the previous address immediately
484     /// @dev In case the new version has a fault, a quick way to fallback to the old contract
485     /// @param _id Id of contract
486     function revertToPreviousAddress(bytes4 _id) public onlyOwner {
487         if (!(entries[_id].exists)){
488             revert EntryNonExistentError(_id);
489         }
490         if (previousAddresses[_id] == address(0)){
491             revert EmptyPrevAddrError(_id);
492         }
493 
494         address currentAddr = entries[_id].contractAddr;
495         entries[_id].contractAddr = previousAddresses[_id];
496 
497         emit RevertToPreviousAddress(msg.sender, _id, currentAddr, previousAddresses[_id]);
498     }
499 
500     /// @notice Starts an address change for an existing entry
501     /// @dev Can override a change that is currently in progress
502     /// @param _id Id of contract
503     /// @param _newContractAddr Address of the new contract
504     function startContractChange(bytes4 _id, address _newContractAddr) public onlyOwner {
505         if (!entries[_id].exists){
506             revert EntryNonExistentError(_id);
507         }
508         if (entries[_id].inWaitPeriodChange){
509             revert AlreadyInWaitPeriodChangeError(_id);
510         }
511 
512         entries[_id].changeStartTime = block.timestamp; // solhint-disable-line
513         entries[_id].inContractChange = true;
514 
515         pendingAddresses[_id] = _newContractAddr;
516 
517         emit StartContractChange(msg.sender, _id, entries[_id].contractAddr, _newContractAddr);
518     }
519 
520     /// @notice Changes new contract address, correct time must have passed
521     /// @param _id Id of contract
522     function approveContractChange(bytes4 _id) public onlyOwner {
523         if (!entries[_id].exists){
524             revert EntryNonExistentError(_id);
525         }
526         if (!entries[_id].inContractChange){
527             revert EntryNotInChangeError(_id);
528         }
529         if (block.timestamp < (entries[_id].changeStartTime + entries[_id].waitPeriod)){// solhint-disable-line
530             revert ChangeNotReadyError(block.timestamp, (entries[_id].changeStartTime + entries[_id].waitPeriod));
531         }
532 
533         address oldContractAddr = entries[_id].contractAddr;
534         entries[_id].contractAddr = pendingAddresses[_id];
535         entries[_id].inContractChange = false;
536         entries[_id].changeStartTime = 0;
537 
538         pendingAddresses[_id] = address(0);
539         previousAddresses[_id] = oldContractAddr;
540 
541         emit ApproveContractChange(msg.sender, _id, oldContractAddr, entries[_id].contractAddr);
542     }
543 
544     /// @notice Cancel pending change
545     /// @param _id Id of contract
546     function cancelContractChange(bytes4 _id) public onlyOwner {
547         if (!entries[_id].exists){
548             revert EntryNonExistentError(_id);
549         }
550         if (!entries[_id].inContractChange){
551             revert EntryNotInChangeError(_id);
552         }
553 
554         address oldContractAddr = pendingAddresses[_id];
555 
556         pendingAddresses[_id] = address(0);
557         entries[_id].inContractChange = false;
558         entries[_id].changeStartTime = 0;
559 
560         emit CancelContractChange(msg.sender, _id, oldContractAddr, entries[_id].contractAddr);
561     }
562 
563     /// @notice Starts the change for waitPeriod
564     /// @param _id Id of contract
565     /// @param _newWaitPeriod New wait time
566     function startWaitPeriodChange(bytes4 _id, uint256 _newWaitPeriod) public onlyOwner {
567         if (!entries[_id].exists){
568             revert EntryNonExistentError(_id);
569         }
570         if (entries[_id].inContractChange){
571             revert AlreadyInContractChangeError(_id);
572         }
573 
574         pendingWaitTimes[_id] = _newWaitPeriod;
575 
576         entries[_id].changeStartTime = block.timestamp; // solhint-disable-line
577         entries[_id].inWaitPeriodChange = true;
578 
579         emit StartWaitPeriodChange(msg.sender, _id, _newWaitPeriod);
580     }
581 
582     /// @notice Changes new wait period, correct time must have passed
583     /// @param _id Id of contract
584     function approveWaitPeriodChange(bytes4 _id) public onlyOwner {
585         if (!entries[_id].exists){
586             revert EntryNonExistentError(_id);
587         }
588         if (!entries[_id].inWaitPeriodChange){
589             revert EntryNotInChangeError(_id);
590         }
591         if (block.timestamp < (entries[_id].changeStartTime + entries[_id].waitPeriod)){ // solhint-disable-line
592             revert ChangeNotReadyError(block.timestamp, (entries[_id].changeStartTime + entries[_id].waitPeriod));
593         }
594 
595         uint256 oldWaitTime = entries[_id].waitPeriod;
596         entries[_id].waitPeriod = pendingWaitTimes[_id];
597         
598         entries[_id].inWaitPeriodChange = false;
599         entries[_id].changeStartTime = 0;
600 
601         pendingWaitTimes[_id] = 0;
602 
603         emit ApproveWaitPeriodChange(msg.sender, _id, oldWaitTime, entries[_id].waitPeriod);
604     }
605 
606     /// @notice Cancel wait period change
607     /// @param _id Id of contract
608     function cancelWaitPeriodChange(bytes4 _id) public onlyOwner {
609         if (!entries[_id].exists){
610             revert EntryNonExistentError(_id);
611         }
612         if (!entries[_id].inWaitPeriodChange){
613             revert EntryNotInChangeError(_id);
614         }
615 
616         uint256 oldWaitPeriod = pendingWaitTimes[_id];
617 
618         pendingWaitTimes[_id] = 0;
619         entries[_id].inWaitPeriodChange = false;
620         entries[_id].changeStartTime = 0;
621 
622         emit CancelWaitPeriodChange(msg.sender, _id, oldWaitPeriod, entries[_id].waitPeriod);
623     }
624 }
625 
626 
627 
628 
629 
630 contract StrategyModel {
631         
632     /// @dev Group of strategies bundled together so user can sub to multiple strategies at once
633     /// @param creator Address of the user who created the bundle
634     /// @param strategyIds Array of strategy ids stored in StrategyStorage
635     struct StrategyBundle {
636         address creator;
637         uint64[] strategyIds;
638     }
639 
640     /// @dev Template/Class which defines a Strategy
641     /// @param name Name of the strategy useful for logging what strategy is executing
642     /// @param creator Address of the user which created the strategy
643     /// @param triggerIds Array of identifiers for trigger - bytes4(keccak256(TriggerName))
644     /// @param actionIds Array of identifiers for actions - bytes4(keccak256(ActionName))
645     /// @param paramMapping Describes how inputs to functions are piped from return/subbed values
646     /// @param continuous If the action is repeated (continuos) or one time
647     struct Strategy {
648         string name;
649         address creator;
650         bytes4[] triggerIds;
651         bytes4[] actionIds;
652         uint8[][] paramMapping;
653         bool continuous;
654     }
655 
656     /// @dev List of actions grouped as a recipe
657     /// @param name Name of the recipe useful for logging what recipe is executing
658     /// @param callData Array of calldata inputs to each action
659     /// @param subData Used only as part of strategy, subData injected from StrategySub.subData
660     /// @param actionIds Array of identifiers for actions - bytes4(keccak256(ActionName))
661     /// @param paramMapping Describes how inputs to functions are piped from return/subbed values
662     struct Recipe {
663         string name;
664         bytes[] callData;
665         bytes32[] subData;
666         bytes4[] actionIds;
667         uint8[][] paramMapping;
668     }
669 
670     /// @dev Actual data of the sub we store on-chain
671     /// @dev In order to save on gas we store a keccak256(StrategySub) and verify later on
672     /// @param userProxy Address of the users smart wallet/proxy
673     /// @param isEnabled Toggle if the subscription is active
674     /// @param strategySubHash Hash of the StrategySub data the user inputted
675     struct StoredSubData {
676         bytes20 userProxy; // address but put in bytes20 for gas savings
677         bool isEnabled;
678         bytes32 strategySubHash;
679     }
680 
681     /// @dev Instance of a strategy, user supplied data
682     /// @param strategyOrBundleId Id of the strategy or bundle, depending on the isBundle bool
683     /// @param isBundle If true the id points to bundle, if false points directly to strategyId
684     /// @param triggerData User supplied data needed for checking trigger conditions
685     /// @param subData User supplied data used in recipe
686     struct StrategySub {
687         uint64 strategyOrBundleId;
688         bool isBundle;
689         bytes[] triggerData;
690         bytes32[] subData;
691     }
692 }
693 
694 
695 
696 
697 
698 contract BotAuth is AdminAuth {
699     mapping(address => bool) public approvedCallers;
700 
701     /// @notice Checks if the caller is approved for the specific subscription
702     /// @dev First param is subId but it's not used in this implementation 
703     /// @dev Currently auth callers are approved for all strategies
704     /// @param _caller Address of the caller
705     function isApproved(uint256, address _caller) public view returns (bool) {
706         return approvedCallers[_caller];
707     }
708 
709     /// @notice Adds a new bot address which will be able to call executeStrategy()
710     /// @param _caller Bot address
711     function addCaller(address _caller) public onlyOwner {
712         approvedCallers[_caller] = true;
713     }
714 
715     /// @notice Removes a bot address so it can't call executeStrategy()
716     /// @param _caller Bot address
717     function removeCaller(address _caller) public onlyOwner {
718         approvedCallers[_caller] = false;
719     }
720 }
721 
722 
723 
724 
725 
726 abstract contract IDSProxy {
727     // function execute(bytes memory _code, bytes memory _data)
728     //     public
729     //     payable
730     //     virtual
731     //     returns (address, bytes32);
732 
733     function execute(address _target, bytes memory _data) public payable virtual returns (bytes32);
734 
735     function setCache(address _cacheAddr) public payable virtual returns (bool);
736 
737     function owner() public view virtual returns (address);
738 }
739 
740 
741 
742 
743 
744 contract MainnetCoreAddresses {
745     address internal constant REGISTRY_ADDR = 0x287778F121F134C66212FB16c9b53eC991D32f5b;
746     address internal constant PROXY_AUTH_ADDR = 0x149667b6FAe2c63D1B4317C716b0D0e4d3E2bD70;
747     address internal constant DEFISAVER_LOGGER = 0xcE7a977Cac4a481bc84AC06b2Da0df614e621cf3;
748 
749     address internal constant SUB_STORAGE_ADDR = 0x1612fc28Ee0AB882eC99842Cde0Fc77ff0691e90;
750     address internal constant BUNDLE_STORAGE_ADDR = 0x223c6aDE533851Df03219f6E3D8B763Bd47f84cf;
751     address internal constant STRATEGY_STORAGE_ADDR = 0xF52551F95ec4A2B4299DcC42fbbc576718Dbf933;
752 
753 }
754 
755 
756 
757 
758 
759 contract CoreHelper is MainnetCoreAddresses {
760 }
761 
762 
763 
764 
765 
766 
767 
768 contract ProxyAuth is AdminAuth, CoreHelper {
769     IDFSRegistry public constant registry = IDFSRegistry(REGISTRY_ADDR);
770 
771     bytes4 constant STRATEGY_EXECUTOR_ID = bytes4(keccak256("StrategyExecutorID"));
772 
773     error SenderNotExecutorError(address, address);
774 
775     modifier onlyExecutor {
776         address executorAddr = registry.getAddr(STRATEGY_EXECUTOR_ID);
777 
778         if (msg.sender != executorAddr){
779             revert SenderNotExecutorError(msg.sender, executorAddr);
780         }
781 
782         _;
783     }
784 
785     /// @notice Calls the .execute() method of the specified users DSProxy
786     /// @dev Contract gets the authority from the user to call it, only callable by Executor
787     /// @param _proxyAddr Address of the users DSProxy
788     /// @param _contractAddr Address of the contract which to execute
789     /// @param _callData Call data of the function to be called
790     function callExecute(
791         address _proxyAddr,
792         address _contractAddr,
793         bytes memory _callData
794     ) public payable onlyExecutor {
795         IDSProxy(_proxyAddr).execute{value: msg.value}(_contractAddr, _callData);
796     }
797 }
798 
799 
800 
801 
802 
803 
804 contract StrategyStorage is StrategyModel, AdminAuth {
805 
806     Strategy[] public strategies;
807     bool public openToPublic = false;
808 
809     error NoAuthToCreateStrategy(address,bool);
810     event StrategyCreated(uint256 indexed strategyId);
811 
812     modifier onlyAuthCreators {
813         if (adminVault.owner() != msg.sender && openToPublic == false) {
814             revert NoAuthToCreateStrategy(msg.sender, openToPublic);
815         }
816 
817         _;
818     }
819 
820     /// @notice Creates a new strategy and writes the data in an array
821     /// @dev Can only be called by auth addresses if it's not open to public
822     /// @param _name Name of the strategy useful for logging what strategy is executing
823     /// @param _triggerIds Array of identifiers for trigger - bytes4(keccak256(TriggerName))
824     /// @param _actionIds Array of identifiers for actions - bytes4(keccak256(ActionName))
825     /// @param _paramMapping Describes how inputs to functions are piped from return/subbed values
826     /// @param _continuous If the action is repeated (continuos) or one time
827     function createStrategy(
828         string memory _name,
829         bytes4[] memory _triggerIds,
830         bytes4[] memory _actionIds,
831         uint8[][] memory _paramMapping,
832         bool _continuous
833     ) public onlyAuthCreators returns (uint256) {
834         strategies.push(Strategy({
835                 name: _name,
836                 creator: msg.sender,
837                 triggerIds: _triggerIds,
838                 actionIds: _actionIds,
839                 paramMapping: _paramMapping,
840                 continuous : _continuous
841         }));
842 
843         emit StrategyCreated(strategies.length - 1);
844 
845         return strategies.length - 1;
846     }
847 
848     /// @notice Switch to determine if bundles can be created by anyone
849     /// @dev Callable only by the owner
850     /// @param _openToPublic Flag if true anyone can create bundles
851     function changeEditPermission(bool _openToPublic) public onlyOwner {
852         openToPublic = _openToPublic;
853     }
854 
855     ////////////////////////////// VIEW METHODS /////////////////////////////////
856 
857     function getStrategy(uint _strategyId) public view returns (Strategy memory) {
858         return strategies[_strategyId];
859     }
860     function getStrategyCount() public view returns (uint256) {
861         return strategies.length;
862     }
863 
864     function getPaginatedStrategies(uint _page, uint _perPage) public view returns (Strategy[] memory) {
865         Strategy[] memory strategiesPerPage = new Strategy[](_perPage);
866 
867         uint start = _page * _perPage;
868         uint end = start + _perPage;
869 
870         end = (end > strategies.length) ? strategies.length : end;
871 
872         uint count = 0;
873         for (uint i = start; i < end; i++) {
874             strategiesPerPage[count] = strategies[i];
875             count++;
876         }
877 
878         return strategiesPerPage;
879     }
880 
881 }
882 
883 
884 
885 
886 
887 
888 
889 
890 
891 contract BundleStorage is StrategyModel, AdminAuth, CoreHelper {
892 
893     DFSRegistry public constant registry = DFSRegistry(REGISTRY_ADDR);
894 
895     StrategyBundle[] public bundles;
896     bool public openToPublic = false;
897 
898     error NoAuthToCreateBundle(address,bool);
899     error DiffTriggersInBundle(uint64[]);
900 
901     event BundleCreated(uint256 indexed bundleId);
902 
903     modifier onlyAuthCreators {
904         if (adminVault.owner() != msg.sender && openToPublic == false) {
905             revert NoAuthToCreateBundle(msg.sender, openToPublic);
906         }
907 
908         _;
909     }
910 
911     /// @dev Checks if the triggers in strategies are the same (order also relevant)
912     /// @dev If the caller is not owner we do additional checks, we skip those checks for gas savings
913     modifier sameTriggers(uint64[] memory _strategyIds) {
914         if (msg.sender != adminVault.owner()) {
915             Strategy memory firstStrategy = StrategyStorage(STRATEGY_STORAGE_ADDR).getStrategy(_strategyIds[0]);
916 
917             bytes32 firstStrategyTriggerHash = keccak256(abi.encode(firstStrategy.triggerIds));
918 
919             for (uint256 i = 1; i < _strategyIds.length; ++i) {
920                 Strategy memory s = StrategyStorage(STRATEGY_STORAGE_ADDR).getStrategy(_strategyIds[i]);
921 
922                 if (firstStrategyTriggerHash != keccak256(abi.encode(s.triggerIds))) {
923                     revert DiffTriggersInBundle(_strategyIds);
924                 }
925             }
926         }
927 
928         _;
929     }
930 
931     /// @notice Adds a new bundle to array
932     /// @dev Can only be called by auth addresses if it's not open to public
933     /// @dev Strategies need to have the same number of triggers and ids exists
934     /// @param _strategyIds Array of strategyIds that go into a bundle
935     function createBundle(
936         uint64[] memory _strategyIds
937     ) public onlyAuthCreators sameTriggers(_strategyIds) returns (uint256) {
938 
939         bundles.push(StrategyBundle({
940             creator: msg.sender,
941             strategyIds: _strategyIds
942         }));
943 
944         emit BundleCreated(bundles.length - 1);
945 
946         return bundles.length - 1;
947     }
948 
949     /// @notice Switch to determine if bundles can be created by anyone
950     /// @dev Callable only by the owner
951     /// @param _openToPublic Flag if true anyone can create bundles
952     function changeEditPermission(bool _openToPublic) public onlyOwner {
953         openToPublic = _openToPublic;
954     }
955 
956     ////////////////////////////// VIEW METHODS /////////////////////////////////
957 
958     function getStrategyId(uint256 _bundleId, uint256 _strategyIndex) public view returns (uint256) {
959         return bundles[_bundleId].strategyIds[_strategyIndex];
960     }
961 
962     function getBundle(uint _bundleId) public view returns (StrategyBundle memory) {
963         return bundles[_bundleId];
964     }
965     function getBundleCount() public view returns (uint256) {
966         return bundles.length;
967     }
968 
969     function getPaginatedBundles(uint _page, uint _perPage) public view returns (StrategyBundle[] memory) {
970         StrategyBundle[] memory bundlesPerPage = new StrategyBundle[](_perPage);
971         uint start = _page * _perPage;
972         uint end = start + _perPage;
973 
974         end = (end > bundles.length) ? bundles.length : end;
975 
976         uint count = 0;
977         for (uint i = start; i < end; i++) {
978             bundlesPerPage[count] = bundles[i];
979             count++;
980         }
981 
982         return bundlesPerPage;
983     }
984 
985 }
986 
987 
988 
989 
990 
991 
992 
993 
994 
995 contract SubStorage is StrategyModel, AdminAuth, CoreHelper {
996     error SenderNotSubOwnerError(address, uint256);
997     error UserPositionsEmpty();
998     error SubIdOutOfRange(uint256, bool);
999 
1000     event Subscribe(uint256 indexed subId, address indexed proxy, bytes32 indexed subHash, StrategySub subStruct);
1001     event UpdateData(uint256 indexed subId, bytes32 indexed subHash, StrategySub subStruct);
1002     event ActivateSub(uint256 indexed subId);
1003     event DeactivateSub(uint256 indexed subId);
1004 
1005     DFSRegistry public constant registry = DFSRegistry(REGISTRY_ADDR);
1006 
1007     StoredSubData[] public strategiesSubs;
1008 
1009     /// @notice Checks if subId is init. and if the sender is the owner
1010     modifier onlySubOwner(uint256 _subId) {
1011         if (address(strategiesSubs[_subId].userProxy) != msg.sender) {
1012             revert SenderNotSubOwnerError(msg.sender, _subId);
1013         }
1014         _;
1015     }
1016 
1017     /// @notice Checks if the id is valid (points to a stored bundle/sub)
1018     modifier isValidId(uint256 _id, bool _isBundle) {
1019         if (_isBundle) {
1020             if (_id > (BundleStorage(BUNDLE_STORAGE_ADDR).getBundleCount() - 1)) {
1021                 revert SubIdOutOfRange(_id, _isBundle);
1022             }
1023         } else {
1024             if (_id > (StrategyStorage(STRATEGY_STORAGE_ADDR).getStrategyCount() - 1)) {
1025                 revert SubIdOutOfRange(_id, _isBundle);
1026             }
1027         }
1028 
1029         _;
1030     }
1031 
1032     /// @notice Adds users info and records StoredSubData, logs StrategySub
1033     /// @dev To save on gas we don't store the whole struct but rather the hash of the struct
1034     /// @param _sub Subscription struct of the user (is not stored on chain, only the hash)
1035     function subscribeToStrategy(
1036         StrategySub memory _sub
1037     ) public isValidId(_sub.strategyOrBundleId, _sub.isBundle) returns (uint256) {
1038 
1039         bytes32 subStorageHash = keccak256(abi.encode(_sub));
1040 
1041         strategiesSubs.push(StoredSubData(
1042             bytes20(msg.sender),
1043             true,
1044             subStorageHash
1045         ));
1046 
1047         uint256 currentId = strategiesSubs.length - 1;
1048 
1049         emit Subscribe(currentId, msg.sender, subStorageHash, _sub);
1050 
1051         return currentId;
1052     }
1053 
1054     /// @notice Updates the users subscription data
1055     /// @dev Only callable by proxy who created the sub.
1056     /// @param _subId Id of the subscription to update
1057     /// @param _sub Subscription struct of the user (needs whole struct so we can hash it)
1058     function updateSubData(
1059         uint256 _subId,
1060         StrategySub calldata _sub
1061     ) public onlySubOwner(_subId) isValidId(_sub.strategyOrBundleId, _sub.isBundle)  {
1062         StoredSubData storage storedSubData = strategiesSubs[_subId];
1063 
1064         bytes32 subStorageHash = keccak256(abi.encode(_sub));
1065 
1066         storedSubData.strategySubHash = subStorageHash;
1067 
1068         emit UpdateData(_subId, subStorageHash, _sub);
1069     }
1070 
1071     /// @notice Enables the subscription for execution if disabled
1072     /// @dev Must own the sub. to be able to enable it
1073     /// @param _subId Id of subscription to enable
1074     function activateSub(
1075         uint _subId
1076     ) public onlySubOwner(_subId) {
1077         StoredSubData storage sub = strategiesSubs[_subId];
1078 
1079         sub.isEnabled = true;
1080 
1081         emit ActivateSub(_subId);
1082     }
1083 
1084     /// @notice Disables the subscription (will not be able to execute the strategy for the user)
1085     /// @dev Must own the sub. to be able to disable it
1086     /// @param _subId Id of subscription to disable
1087     function deactivateSub(
1088         uint _subId
1089     ) public onlySubOwner(_subId) {
1090         StoredSubData storage sub = strategiesSubs[_subId];
1091 
1092         sub.isEnabled = false;
1093 
1094         emit DeactivateSub(_subId);
1095     }
1096 
1097     ///////////////////// VIEW ONLY FUNCTIONS ////////////////////////////
1098 
1099     function getSub(uint _subId) public view returns (StoredSubData memory) {
1100         return strategiesSubs[_subId];
1101     }
1102 
1103     function getSubsCount() public view returns (uint256) {
1104         return strategiesSubs.length;
1105     }
1106 }
1107 
1108 
1109 
1110 
1111 
1112 
1113 
1114 
1115 
1116 
1117 contract StrategyExecutor is StrategyModel, AdminAuth, CoreHelper {
1118 
1119     DFSRegistry public constant registry = DFSRegistry(REGISTRY_ADDR);
1120 
1121     bytes4 constant BOT_AUTH_ID = bytes4(keccak256("BotAuth"));
1122     address constant internal RECIPE_EXECUTOR_ADDR = 0x1D6DEdb49AF91A11B5C5F34954FD3E8cC4f03A86;
1123 
1124     error BotNotApproved(address, uint256);
1125     error SubNotEnabled(uint256);
1126     error SubDatHashMismatch(uint256, bytes32, bytes32);
1127 
1128     /// @notice Checks all the triggers and executes actions
1129     /// @dev Only authorized callers can execute it
1130     /// @param _subId Id of the subscription
1131     /// @param _strategyIndex Which strategy in a bundle, need to specify because when sub is part of a bundle
1132     /// @param _triggerCallData All input data needed to execute triggers
1133     /// @param _actionsCallData All input data needed to execute actions
1134     /// @param _sub StrategySub struct needed because on-chain we store only the hash
1135     function executeStrategy(
1136         uint256 _subId,
1137         uint256 _strategyIndex,
1138         bytes[] calldata _triggerCallData,
1139         bytes[] calldata _actionsCallData,
1140         StrategySub memory _sub
1141     ) public {
1142         // check bot auth
1143         if (!checkCallerAuth(_subId)) {
1144             revert BotNotApproved(msg.sender, _subId);
1145         }
1146 
1147         StoredSubData memory storedSubData = SubStorage(SUB_STORAGE_ADDR).getSub(_subId);
1148 
1149         bytes32 subDataHash = keccak256(abi.encode(_sub));
1150 
1151         // data sent from the caller must match the stored hash of the data
1152         if (subDataHash != storedSubData.strategySubHash) {
1153             revert SubDatHashMismatch(_subId, subDataHash, storedSubData.strategySubHash);
1154         }
1155 
1156         // subscription must be enabled
1157         if (!storedSubData.isEnabled) {
1158             revert SubNotEnabled(_subId);
1159         }
1160 
1161         // execute actions
1162         callActions(_subId, _actionsCallData, _triggerCallData, _strategyIndex, _sub, address(storedSubData.userProxy));
1163     }
1164 
1165     /// @notice Checks if msg.sender has auth, reverts if not
1166     /// @param _subId Id of the strategy
1167     function checkCallerAuth(uint256 _subId) internal view returns (bool) {
1168         return BotAuth(registry.getAddr(BOT_AUTH_ID)).isApproved(_subId, msg.sender);
1169     }
1170 
1171 
1172     /// @notice Calls ProxyAuth which has the auth from the DSProxy which will call RecipeExecutor
1173     /// @param _subId Strategy data we have in storage
1174     /// @param _actionsCallData All input data needed to execute actions
1175     /// @param _triggerCallData All input data needed to check triggers
1176     /// @param _strategyIndex Which strategy in a bundle, need to specify because when sub is part of a bundle
1177     /// @param _sub StrategySub struct needed because on-chain we store only the hash
1178     /// @param _userProxy StrategySub struct needed because on-chain we store only the hash
1179     function callActions(
1180         uint256 _subId,
1181         bytes[] calldata _actionsCallData,
1182         bytes[] calldata _triggerCallData,
1183         uint256 _strategyIndex,
1184         StrategySub memory _sub,
1185         address _userProxy
1186     ) internal {
1187         ProxyAuth(PROXY_AUTH_ADDR).callExecute{value: msg.value}(
1188             _userProxy,
1189             RECIPE_EXECUTOR_ADDR,
1190             abi.encodeWithSignature(
1191                 "executeRecipeFromStrategy(uint256,bytes[],bytes[],uint256,(uint64,bool,bytes[],bytes32[]))",
1192                 _subId,
1193                 _actionsCallData,
1194                 _triggerCallData,
1195                 _strategyIndex,
1196                 _sub
1197             )
1198         );
1199     }
1200 }
