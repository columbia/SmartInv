1 /**
2  *Submitted for verification at polygonscan.com on 2022-05-12
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0-or-later
6 pragma solidity ^0.8.6;
7 
8 /// IApp interface of the application
9 interface IApp {
10     /// (required) call on the destination chain to exec the interaction
11     function anyExecute(bytes calldata _data) external returns (bool success, bytes memory result);
12 
13     /// (optional,advised) call back on the originating chain if the cross chain interaction fails
14     function anyFallback(address _to, bytes calldata _data) external;
15 }
16 
17 /// anycall executor is the delegator to execute contract calling (like a sandbox)
18 contract AnyCallExecutor {
19     struct Context {
20         address from;
21         uint256 fromChainID;
22         uint256 nonce;
23     }
24 
25     Context public context;
26     address public creator;
27 
28     constructor() {
29         creator = msg.sender;
30     }
31 
32     function execute(
33         address _to,
34         bytes calldata _data,
35         address _from,
36         uint256 _fromChainID,
37         uint256 _nonce
38     ) external returns (bool success, bytes memory result) {
39         if (msg.sender != creator) {
40             return (false, "AnyCallExecutor: caller is not the creator");
41         }
42         context = Context({from: _from, fromChainID: _fromChainID, nonce: _nonce});
43         (success, result) = IApp(_to).anyExecute(_data);
44         context = Context({from: address(0), fromChainID: 0, nonce: 0});
45     }
46 }
47 
48 /// anycall proxy is a universal protocal to complete cross-chain interaction.
49 /// 1. the client call `anyCall` on the originating chain
50 ///         to submit a request for a cross chain interaction
51 /// 2. the mpc network verify the request and call `anyExec` on the destination chain
52 ///         to execute a cross chain interaction
53 /// 3. if step 2 failed and step 1 has set non-zero fallback,
54 ///         then call `anyFallback` on the originating chain
55 contract AnyCallV6Proxy {
56     // Packed fee information (only 1 storage slot)
57     struct FeeData {
58         uint128 accruedFees;
59         uint128 premium;
60     }
61 
62     // App config
63     struct AppConfig {
64         address app; // the application contract address
65         address appAdmin; // account who admin the application's config
66         uint256 appFlags; // flags of the application
67     }
68 
69     // Src fee is (baseFees + msg.data.length*feesPerByte)
70     struct SrcFeeConfig {
71         uint256 baseFees;
72         uint256 feesPerByte;
73     }
74 
75     // Exec record
76     struct ExecRecord {
77         address to;
78         bytes data;
79     }
80 
81     // Context of the request on originating chain
82     struct RequestContext {
83         bytes32 txhash;
84         address from;
85         uint256 fromChainID;
86         uint256 nonce;
87         uint256 flags;
88     }
89 
90     // anycall version
91     string constant ANYCALL_VERSION = "v6.0";
92 
93     // Flags constant
94     uint256 public constant FLAG_MERGE_CONFIG_FLAGS = 0x1;
95     uint256 public constant FLAG_PAY_FEE_ON_SRC = 0x1 << 1;
96 
97     // App Modes constant
98     uint256 public constant APPMODE_USE_CUSTOM_SRC_FEES = 0x1;
99 
100     // Modes constant
101     uint256 public constant PERMISSIONLESS_MODE = 0x1;
102     uint256 public constant FREE_MODE = 0x1 << 1;
103 
104     // Extra cost of execution (SSTOREs.SLOADs,ADDs,etc..)
105     // TODO: analysis to verify the correct overhead gas usage
106     uint256 constant EXECUTION_OVERHEAD = 100000;
107 
108     // key is app address
109     mapping(address => string) public appIdentifier;
110 
111     // key is appID, a unique identifier for each project
112     mapping(string => AppConfig) public appConfig;
113     mapping(string => mapping(address => bool)) public appExecWhitelist;
114     mapping(string => address[]) public appHistoryWhitelist;
115     mapping(string => bool) public appBlacklist;
116     mapping(uint256 => SrcFeeConfig) public srcDefaultFees; // key is chainID
117     mapping(string => mapping(uint256 => SrcFeeConfig)) public srcCustomFees;
118     mapping(string => uint256) public appDefaultModes;
119     mapping(string => mapping(uint256 => uint256)) public appCustomModes;
120 
121     mapping(address => bool) public isAdmin;
122     address[] public admins;
123 
124     address public mpc;
125     address public pendingMPC;
126 
127     uint256 public mode;
128     bool public paused;
129 
130     uint256 public minReserveBudget;
131     mapping(address => uint256) public executionBudget;
132     FeeData private _feeData;
133 
134     // applications should give permission to this executor
135     AnyCallExecutor public executor;
136 
137     mapping(bytes32 => ExecRecord) public retryExecRecords;
138 
139     mapping(bytes32 => bool) public execCompleted;
140     uint256 nonce;
141 
142     uint private unlocked = 1;
143     modifier lock() {
144         require(unlocked == 1);
145         unlocked = 0;
146         _;
147         unlocked = 1;
148     }
149 
150     event LogAnyCall(
151         address indexed from,
152         address indexed to,
153         bytes data,
154         address _fallback,
155         uint256 indexed toChainID,
156         uint256 flags,
157         string appID,
158         uint256 nonce
159     );
160 
161     event LogAnyExec(
162         bytes32 indexed txhash,
163         address indexed from,
164         address indexed to,
165         uint256 fromChainID,
166         uint256 nonce,
167         bool success,
168         bytes result
169     );
170 
171     event Deposit(address indexed account, uint256 amount);
172     event Withdraw(address indexed account, uint256 amount);
173     event SetBlacklist(string appID, bool flag);
174     event SetWhitelist(string appID, address indexed whitelist, bool flag);
175     event UpdatePremium(uint256 oldPremium, uint256 newPremium);
176     event AddAdmin(address admin);
177     event RemoveAdmin(address admin);
178     event ChangeMPC(address indexed oldMPC, address indexed newMPC, uint256 timestamp);
179     event ApplyMPC(address indexed oldMPC, address indexed newMPC, uint256 timestamp);
180     event SetAppConfig(string appID, address indexed app, address indexed appAdmin, uint256 appFlags);
181     event UpgradeApp(string appID, address indexed oldApp, address indexed newApp);
182     event StoreRetryExecRecord(bytes32 indexed txhash, address indexed from, address indexed to, uint256 fromChainID, uint256 nonce, bytes data);
183     event DoneRetryExecRecord(bytes32 indexed txhash, address indexed from, uint256 fromChainID, uint256 nonce);
184 
185     constructor(
186         address _admin,
187         address _mpc,
188         uint128 _premium,
189         uint256 _mode
190     ) {
191         require(_mpc != address(0), "zero mpc address");
192         if (_admin != address(0)) {
193             isAdmin[_admin] = true;
194             admins.push(_admin);
195         }
196         if (_mpc != _admin) {
197             isAdmin[_mpc] = true;
198             admins.push(_mpc);
199         }
200 
201         mpc = _mpc;
202         _feeData.premium = _premium;
203         mode = _mode;
204 
205         executor = new AnyCallExecutor();
206 
207         emit ApplyMPC(address(0), _mpc, block.timestamp);
208         emit UpdatePremium(0, _premium);
209     }
210 
211     /// @dev Access control function
212     modifier onlyMPC() {
213         require(msg.sender == mpc, "only MPC");
214         _;
215     }
216 
217     /// @dev Access control function
218     modifier onlyAdmin() {
219         require(isAdmin[msg.sender], "only admin");
220         _;
221     }
222 
223     /// @dev pausable control function
224     modifier whenNotPaused() {
225         require(!paused, "paused");
226         _;
227     }
228 
229     /// @dev Charge an account for execution costs on this chain
230     /// @param _from The account to charge for execution costs
231     modifier charge(address _from, uint256 _flags) {
232         uint256 gasUsed;
233 
234         // Prepare charge fee on the destination chain
235         if (!_isSet(mode, FREE_MODE)) {
236             if (!_isSet(_flags, FLAG_PAY_FEE_ON_SRC)) {
237                 require(executionBudget[_from] >= minReserveBudget, "less than min budget");
238                 gasUsed = gasleft() + EXECUTION_OVERHEAD;
239             }
240         }
241 
242         _;
243 
244         // Charge fee on the dest chain
245         if (gasUsed > 0) {
246             uint256 totalCost = (gasUsed - gasleft()) * (tx.gasprice + _feeData.premium);
247             uint256 budget = executionBudget[_from];
248             require(budget > totalCost, "no enough budget");
249             executionBudget[_from] = budget - totalCost;
250             _feeData.accruedFees += uint128(totalCost);
251         }
252     }
253 
254     /// @dev set paused flag to pause/unpause functions
255     function setPaused(bool _paused) external onlyAdmin {
256         paused = _paused;
257     }
258 
259     function _paySrcFees(uint256 fees) internal {
260         require(msg.value >= fees, "no enough src fee");
261         if (fees > 0) { // pay fees
262             (bool success,) = mpc.call{value: fees}("");
263             require(success);
264         }
265         if (msg.value > fees) { // return remaining amount
266             (bool success,) = msg.sender.call{value: msg.value - fees}("");
267             require(success);
268         }
269     }
270 
271     /**
272         @notice Submit a request for a cross chain interaction
273         @param _to The target to interact with on `_toChainID`
274         @param _data The calldata supplied for the interaction with `_to`
275         @param _fallback The address to call back on the originating chain
276             if the cross chain interaction fails
277             for security reason, it must be zero or `msg.sender` address
278         @param _toChainID The target chain id to interact with
279         @param _flags The flags of app on the originating chain
280     */
281     function anyCall(
282         address _to,
283         bytes calldata _data,
284         address _fallback,
285         uint256 _toChainID,
286         uint256 _flags
287     ) external lock payable whenNotPaused {
288         require(_fallback == address(0) || _fallback == msg.sender, "wrong fallback");
289         string memory _appID = appIdentifier[msg.sender];
290 
291         require(!appBlacklist[_appID], "blacklist");
292 
293         bool _permissionlessMode = _isSet(mode, PERMISSIONLESS_MODE);
294         if (!_permissionlessMode) {
295             require(appExecWhitelist[_appID][msg.sender], "no permission");
296         }
297 
298         if (!_isSet(mode, FREE_MODE)) {
299             AppConfig storage config = appConfig[_appID];
300             require(
301                 (_permissionlessMode && config.app == address(0)) ||
302                 msg.sender == config.app,
303                 "app not exist"
304             );
305 
306             if (_isSet(_flags, FLAG_MERGE_CONFIG_FLAGS) && config.app == msg.sender) {
307                 _flags |= config.appFlags;
308             }
309 
310             if (_isSet(_flags, FLAG_PAY_FEE_ON_SRC)) {
311                 uint256 fees = _calcSrcFees(_appID, _toChainID, _data.length);
312                 _paySrcFees(fees);
313             } else if (msg.value > 0) {
314                 _paySrcFees(0);
315             }
316         }
317 
318         nonce++;
319         emit LogAnyCall(msg.sender, _to, _data, _fallback, _toChainID, _flags, _appID, nonce);
320     }
321 
322     /**
323         @notice Execute a cross chain interaction
324         @dev Only callable by the MPC
325         @param _to The cross chain interaction target
326         @param _data The calldata supplied for interacting with target
327         @param _fallback The address to call on originating chain if the interaction fails
328         @param _appID The app identifier to check whitelist
329         @param _ctx The context of the request on originating chain
330     */
331     function anyExec(
332         address _to,
333         bytes memory _data,
334         address _fallback,
335         string memory _appID,
336         RequestContext memory _ctx
337     ) external lock whenNotPaused charge(_ctx.from, _ctx.flags) onlyMPC {
338         address _from = _ctx.from;
339 
340         require(_fallback == address(0) || _fallback == _from, "wrong fallback");
341 
342         require(!appBlacklist[_appID], "blacklist");
343 
344         if (!_isSet(mode, PERMISSIONLESS_MODE)) {
345             require(appExecWhitelist[_appID][_to], "no permission");
346         }
347 
348         bytes32 uniqID = calcUniqID(_ctx.txhash, _from, _ctx.fromChainID, _ctx.nonce);
349         require(!execCompleted[uniqID], "exec completed");
350 
351         bool success;
352         {
353             bytes memory result;
354             try executor.execute(_to, _data, _from, _ctx.fromChainID, _ctx.nonce) returns (bool succ, bytes memory res) {
355                 (success, result) = (succ, res);
356             } catch Error(string memory reason) {
357                 result = bytes(reason);
358             } catch (bytes memory reason) {
359                 result = reason;
360             }
361             emit LogAnyExec(_ctx.txhash, _from, _to, _ctx.fromChainID, _ctx.nonce, success, result);
362         }
363 
364         if (success) {
365             execCompleted[uniqID] = true;
366         } else if (_fallback == address(0)) {
367             retryExecRecords[uniqID] = ExecRecord(_to, _data);
368             emit StoreRetryExecRecord(_ctx.txhash, _from, _to, _ctx.fromChainID, _ctx.nonce, _data);
369         } else {
370             // Call the fallback on the originating chain with the call information (to, data)
371             nonce++;
372             emit LogAnyCall(
373                 _from,
374                 _fallback,
375                 abi.encodeWithSelector(IApp.anyFallback.selector, _to, _data),
376                 address(0),
377                 _ctx.fromChainID,
378                 0, // pay fee on dest chain
379                 _appID,
380                 nonce);
381         }
382     }
383 
384     function _isSet(uint256 _value, uint256 _testBits) internal pure returns (bool) {
385         return (_value & _testBits) == _testBits;
386     }
387 
388     // @notice Calc unique ID
389     function calcUniqID(bytes32 _txhash, address _from, uint256 _fromChainID, uint256 _nonce) public pure returns (bytes32) {
390         return keccak256(abi.encode(_txhash, _from, _fromChainID, _nonce));
391     }
392 
393     /// @notice Retry stored exec record
394     function retryExec(bytes32 _txhash, address _from, uint256 _fromChainID, uint256 _nonce) external {
395         bytes32 uniqID = calcUniqID(_txhash, _from, _fromChainID, _nonce);
396         require(!execCompleted[uniqID], "exec completed");
397 
398         ExecRecord storage record = retryExecRecords[uniqID];
399         require(record.to != address(0), "no retry record");
400 
401         address _to = record.to;
402         bytes memory _data = record.data;
403 
404         // Clear record
405         record.to = address(0);
406         record.data = "";
407 
408         (bool success,) = executor.execute(_to, _data, _from, _fromChainID, _nonce);
409         require(success);
410 
411         execCompleted[uniqID] = true;
412         emit DoneRetryExecRecord(_txhash, _from, _fromChainID, _nonce);
413     }
414 
415     /// @notice Deposit native currency crediting `_account` for execution costs on this chain
416     /// @param _account The account to deposit and credit for
417     function deposit(address _account) external payable {
418         executionBudget[_account] += msg.value;
419         emit Deposit(_account, msg.value);
420     }
421 
422     /// @notice Withdraw a previous deposit from your account
423     /// @param _amount The amount to withdraw from your account
424     function withdraw(uint256 _amount) external {
425         executionBudget[msg.sender] -= _amount;
426         emit Withdraw(msg.sender, _amount);
427         (bool success,) = msg.sender.call{value: _amount}("");
428         require(success);
429     }
430 
431     /// @notice Withdraw all accrued execution fees
432     /// @dev The MPC is credited in the native currency
433     function withdrawAccruedFees() external {
434         uint256 fees = _feeData.accruedFees;
435         _feeData.accruedFees = 0;
436         (bool success,) = mpc.call{value: fees}("");
437         require(success);
438     }
439 
440     /// @notice Set app blacklist
441     function setBlacklist(string calldata _appID, bool _flag) external onlyAdmin {
442         appBlacklist[_appID] = _flag;
443         emit SetBlacklist(_appID, _flag);
444     }
445 
446     /// @notice Set app blacklist in batch
447     function setBlacklists(string[] calldata _appIDs, bool _flag) external onlyAdmin {
448         for (uint256 i = 0; i < _appIDs.length; i++) {
449             this.setBlacklist(_appIDs[i], _flag);
450         }
451     }
452 
453     /// @notice Set the premimum for cross chain executions
454     /// @param _premium The premium per gas
455     function setPremium(uint128 _premium) external onlyAdmin {
456         emit UpdatePremium(_feeData.premium, _premium);
457         _feeData.premium = _premium;
458     }
459 
460     /// @notice Set minimum exection budget for cross chain executions
461     /// @param _minBudget The minimum exection budget
462     function setMinReserveBudget(uint128 _minBudget) external onlyAdmin {
463         minReserveBudget = _minBudget;
464     }
465 
466     /// @notice Set mode
467     function setMode(uint256 _mode) external onlyAdmin {
468         mode = _mode;
469     }
470 
471     /// @notice Change mpc
472     function changeMPC(address _mpc) external onlyMPC {
473         pendingMPC = _mpc;
474         emit ChangeMPC(mpc, _mpc, block.timestamp);
475     }
476 
477     /// @notice Apply mpc
478     function applyMPC() external {
479         require(msg.sender == pendingMPC);
480         emit ApplyMPC(mpc, pendingMPC, block.timestamp);
481         mpc = pendingMPC;
482         pendingMPC = address(0);
483     }
484 
485     /// @notice Get the total accrued fees in native currency
486     /// @dev Fees increase when executing cross chain requests
487     function accruedFees() external view returns(uint128) {
488         return _feeData.accruedFees;
489     }
490 
491     /// @notice Get the gas premium cost
492     /// @dev This is similar to priority fee in eip-1559, except instead of going
493     ///     to the miner it is given to the MPC executing cross chain requests
494     function premium() external view returns(uint128) {
495         return _feeData.premium;
496     }
497 
498     /// @notice Add admin
499     function addAdmin(address _admin) external onlyMPC {
500         require(!isAdmin[_admin]);
501         isAdmin[_admin] = true;
502         admins.push(_admin);
503         emit AddAdmin(_admin);
504     }
505 
506     /// @notice Remove admin
507     function removeAdmin(address _admin) external onlyMPC {
508         require(isAdmin[_admin]);
509         isAdmin[_admin] = false;
510         uint256 length = admins.length;
511         for (uint256 i = 0; i < length - 1; i++) {
512             if (admins[i] == _admin) {
513                 admins[i] = admins[length - 1];
514                 break;
515             }
516         }
517         admins.pop();
518         emit RemoveAdmin(_admin);
519     }
520 
521     /// @notice Get all admins
522     function getAllAdmins() external view returns (address[] memory) {
523         return admins;
524     }
525 
526     /// @notice Init app config
527     function initAppConfig(
528         string calldata _appID,
529         address _app,
530         address _admin,
531         uint256 _flags,
532         address[] calldata _whitelist
533     ) external onlyAdmin {
534         require(bytes(_appID).length > 0, "empty appID");
535         require(_app != address(0), "zero app address");
536 
537         AppConfig storage config = appConfig[_appID];
538         require(config.app == address(0), "app exist");
539 
540         appIdentifier[_app] = _appID;
541 
542         config.app = _app;
543         config.appAdmin = _admin;
544         config.appFlags = _flags;
545 
546         address[] memory whitelist = new address[](1+_whitelist.length);
547         whitelist[0] = _app;
548         for (uint256 i = 0; i < _whitelist.length; i++) {
549             whitelist[i+1] = _whitelist[i];
550         }
551         _setAppWhitelist(_appID, whitelist, true);
552 
553         emit SetAppConfig(_appID, _app, _admin, _flags);
554     }
555 
556     /// @notice Update app config
557     /// can be operated only by mpc or app admin
558     /// the config.app will always keep unchanged here
559     function updateAppConfig(
560         address _app,
561         address _admin,
562         uint256 _flags,
563         address[] calldata _whitelist
564     ) external {
565         string memory _appID = appIdentifier[_app];
566         AppConfig storage config = appConfig[_appID];
567 
568         require(config.app == _app && _app != address(0), "app not exist");
569         require(msg.sender == mpc || msg.sender == config.appAdmin, "forbid");
570 
571         if (_admin != address(0)) {
572             config.appAdmin = _admin;
573         }
574         config.appFlags = _flags;
575         if (_whitelist.length > 0) {
576             _setAppWhitelist(_appID, _whitelist, true);
577         }
578 
579         emit SetAppConfig(_appID, _app, _admin, _flags);
580     }
581 
582     /// @notice Upgrade app
583     /// can be operated only by mpc or app admin
584     /// change config.app to a new address
585     /// require the `_newApp` is not inited
586     function upgradeApp(address _oldApp, address _newApp) external {
587         string memory _appID = appIdentifier[_oldApp];
588         AppConfig storage config = appConfig[_appID];
589 
590         require(config.app == _oldApp && _oldApp != address(0), "app not exist");
591         require(msg.sender == mpc || msg.sender == config.appAdmin, "forbid");
592         require(bytes(appIdentifier[_newApp]).length == 0, "new app is inited");
593 
594         config.app = _newApp;
595 
596         emit UpgradeApp(_appID, _oldApp, _newApp);
597     }
598 
599     /// @notice Add whitelist
600     function addWhitelist(address _app, address[] memory _whitelist) external {
601         string memory _appID = appIdentifier[_app];
602         AppConfig storage config = appConfig[_appID];
603 
604         require(config.app == _app && _app != address(0), "app not exist");
605         require(msg.sender == mpc || msg.sender == config.appAdmin, "forbid");
606 
607         _setAppWhitelist(_appID, _whitelist, true);
608     }
609 
610     /// @notice Remove whitelist
611     function removeWhitelist(address _app, address[] memory _whitelist) external {
612         string memory _appID = appIdentifier[_app];
613         AppConfig storage config = appConfig[_appID];
614 
615         require(config.app == _app && _app != address(0), "app not exist");
616         require(msg.sender == mpc || msg.sender == config.appAdmin, "forbid");
617 
618         _setAppWhitelist(_appID, _whitelist, false);
619     }
620 
621     function _setAppWhitelist(string memory _appID, address[] memory _whitelist, bool _flag) internal {
622         mapping(address => bool) storage whitelist = appExecWhitelist[_appID];
623         address[] storage historyWhitelist = appHistoryWhitelist[_appID];
624         address addr;
625         for (uint256 i = 0; i < _whitelist.length; i++) {
626             addr = _whitelist[i];
627             if (whitelist[addr] == _flag) {
628                 continue;
629             }
630             if (_flag) {
631                 historyWhitelist.push(addr);
632             }
633             whitelist[addr] = _flag;
634             emit SetWhitelist(_appID, addr, _flag);
635         }
636     }
637 
638     /// @notice Get history whitelist length
639     function getHistoryWhitelistLength(string memory _appID) external view returns (uint256) {
640         return appHistoryWhitelist[_appID].length;
641     }
642 
643     /// @notice Get all history whitelist
644     function getAllHistoryWhitelist(string memory _appID) external view returns (address[] memory) {
645         return appHistoryWhitelist[_appID];
646     }
647 
648     /// @notice Tidy history whitelist to be same with actual whitelist
649     function tidyHistoryWhitelist(string memory _appID) external {
650         mapping(address => bool) storage actualWhitelist = appExecWhitelist[_appID];
651         address[] storage historyWhitelist = appHistoryWhitelist[_appID];
652         uint256 histLength = historyWhitelist.length;
653         uint256 popIndex = histLength;
654         address addr;
655         for (uint256 i = 0; i < popIndex; ) {
656             addr = historyWhitelist[i];
657             if (actualWhitelist[addr]) {
658                 i++;
659             } else {
660                 popIndex--;
661                 historyWhitelist[i] = historyWhitelist[popIndex];
662             }
663         }
664         for (uint256 i = popIndex; i < histLength; i++) {
665             historyWhitelist.pop();
666         }
667     }
668 
669     /// @notice Set default src fees
670     function setDefaultSrcFees(
671         uint256[] calldata _toChainIDs,
672         uint256[] calldata _baseFees,
673         uint256[] calldata _feesPerByte
674     ) external onlyAdmin {
675         uint256 length = _toChainIDs.length;
676         require(length == _baseFees.length && length == _feesPerByte.length);
677 
678         for (uint256 i = 0; i < length; i++) {
679             srcDefaultFees[_toChainIDs[i]] = SrcFeeConfig(_baseFees[i], _feesPerByte[i]);
680         }
681     }
682 
683     /// @notice Set custom src fees
684     function setCustomSrcFees(
685         address _app,
686         uint256[] calldata _toChainIDs,
687         uint256[] calldata _baseFees,
688         uint256[] calldata _feesPerByte
689     ) external onlyAdmin {
690         string memory _appID = appIdentifier[_app];
691         AppConfig storage config = appConfig[_appID];
692 
693         require(config.app == _app && _app != address(0), "app not exist");
694         require(_isSet(config.appFlags, FLAG_PAY_FEE_ON_SRC), "flag not set");
695 
696         uint256 length = _toChainIDs.length;
697         require(length == _baseFees.length && length == _feesPerByte.length);
698 
699         mapping(uint256 => SrcFeeConfig) storage _srcFees = srcCustomFees[_appID];
700         for (uint256 i = 0; i < length; i++) {
701             _srcFees[_toChainIDs[i]] = SrcFeeConfig(_baseFees[i], _feesPerByte[i]);
702         }
703     }
704 
705     /// @notice Set app modes
706     function setAppModes(
707         address _app,
708         uint256 _appDefaultMode,
709         uint256[] calldata _toChainIDs,
710         uint256[] calldata _appCustomModes
711     ) external onlyAdmin {
712         string memory _appID = appIdentifier[_app];
713         AppConfig storage config = appConfig[_appID];
714         require(config.app == _app && _app != address(0), "app not exist");
715 
716         uint256 length = _toChainIDs.length;
717         require(length == _appCustomModes.length);
718 
719         appDefaultModes[_appID] = _appDefaultMode;
720 
721         for (uint256 i = 0; i < length; i++) {
722             appCustomModes[_appID][_toChainIDs[i]] = _appCustomModes[i];
723         }
724     }
725 
726     /// @notice Calc fees
727     function calcSrcFees(
728         address _app,
729         uint256 _toChainID,
730         uint256 _dataLength
731     ) external view returns (uint256) {
732         string memory _appID = appIdentifier[_app];
733         return _calcSrcFees(_appID, _toChainID, _dataLength);
734     }
735 
736     /// @notice Calc fees
737     function calcSrcFees(
738         string calldata _appID,
739         uint256 _toChainID,
740         uint256 _dataLength
741     ) external view returns (uint256) {
742         return _calcSrcFees(_appID, _toChainID, _dataLength);
743     }
744 
745     /// @notice Is use custom src fees
746     function isUseCustomSrcFees(string memory _appID, uint256 _toChainID) public view returns (bool) {
747         uint256 _appMode = appCustomModes[_appID][_toChainID];
748         if (_isSet(_appMode, APPMODE_USE_CUSTOM_SRC_FEES)) {
749             return true;
750         }
751         _appMode = appDefaultModes[_appID];
752         return _isSet(_appMode, APPMODE_USE_CUSTOM_SRC_FEES);
753     }
754 
755     function _calcSrcFees(
756         string memory _appID,
757         uint256 _toChainID,
758         uint256 _dataLength
759     ) internal view returns (uint256) {
760         SrcFeeConfig memory customFees = srcCustomFees[_appID][_toChainID];
761         uint256 customBaseFees = customFees.baseFees;
762         uint256 customFeesPerBytes = customFees.feesPerByte;
763 
764         if (isUseCustomSrcFees(_appID, _toChainID)) {
765             return customBaseFees + _dataLength * customFeesPerBytes;
766         }
767 
768         SrcFeeConfig memory defaultFees = srcDefaultFees[_toChainID];
769         uint256 defaultBaseFees = defaultFees.baseFees;
770         uint256 defaultFeesPerBytes = defaultFees.feesPerByte;
771 
772         uint256 baseFees = (customBaseFees > defaultBaseFees) ? customBaseFees : defaultBaseFees;
773         uint256 feesPerByte = (customFeesPerBytes > defaultFeesPerBytes) ? customFeesPerBytes : defaultFeesPerBytes;
774 
775         return baseFees + _dataLength * feesPerByte;
776     }
777 }