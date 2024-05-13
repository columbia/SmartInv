1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 pragma experimental ABIEncoderV2;
4 
5 // ============ Internal Imports ============
6 import {Home} from "../Home.sol";
7 import {Version0} from "../Version0.sol";
8 import {XAppConnectionManager, TypeCasts} from "../XAppConnectionManager.sol";
9 import {IMessageRecipient} from "../../interfaces/IMessageRecipient.sol";
10 import {GovernanceMessage} from "./GovernanceMessage.sol";
11 // ============ External Imports ============
12 import {Initializable} from "@openzeppelin/contracts/proxy/Initializable.sol";
13 import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
14 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
15 
16 contract GovernanceRouter is Version0, Initializable, IMessageRecipient {
17     // ============ Libraries ============
18 
19     using SafeMath for uint256;
20     using TypedMemView for bytes;
21     using TypedMemView for bytes29;
22     using GovernanceMessage for bytes29;
23 
24     // ============== Enums ==============
25 
26     // The status of a batch of governance calls
27     enum BatchStatus {
28         Unknown, // 0
29         Pending, // 1
30         Complete // 2
31     }
32 
33     // ============ Immutables ============
34 
35     uint32 public immutable localDomain;
36     // number of seconds before recovery can be activated
37     uint256 public immutable recoveryTimelock;
38 
39     // ============ Public Storage ============
40 
41     // timestamp when recovery timelock expires; 0 if timelock has not been initiated
42     uint256 public recoveryActiveAt;
43     // the address of the recovery manager multisig
44     address public recoveryManager;
45     // the local entity empowered to call governance functions, set to 0x0 on non-Governor chains
46     address public governor;
47     // domain of Governor chain -- for accepting incoming messages from Governor
48     uint32 public governorDomain;
49     // xAppConnectionManager contract which stores Replica addresses
50     XAppConnectionManager public xAppConnectionManager;
51     // domain -> remote GovernanceRouter contract address
52     mapping(uint32 => bytes32) public routers;
53     // array of all domains with registered GovernanceRouter
54     uint32[] public domains;
55     // call hash -> call status
56     mapping(bytes32 => BatchStatus) public inboundCallBatches;
57 
58     // ============ Upgrade Gap ============
59 
60     // gap for upgrade safety
61     uint256[42] private __GAP;
62 
63     // ============ Events ============
64 
65     /**
66      * @notice Emitted a remote GovernanceRouter address is added, removed, or changed
67      * @param domain the domain of the remote Router
68      * @param previousRouter the previously registered router; 0 if router is being added
69      * @param newRouter the new registered router; 0 if router is being removed
70      */
71     event SetRouter(
72         uint32 indexed domain,
73         bytes32 previousRouter,
74         bytes32 newRouter
75     );
76 
77     /**
78      * @notice Emitted when the Governor role is transferred
79      * @param previousGovernorDomain the domain of the previous Governor
80      * @param newGovernorDomain the domain of the new Governor
81      * @param previousGovernor the address of the previous Governor; 0 if the governor was remote
82      * @param newGovernor the address of the new Governor; 0 if the governor is remote
83      */
84     event TransferGovernor(
85         uint32 previousGovernorDomain,
86         uint32 newGovernorDomain,
87         address indexed previousGovernor,
88         address indexed newGovernor
89     );
90 
91     /**
92      * @notice Emitted when the RecoveryManager role is transferred
93      * @param previousRecoveryManager the address of the previous RecoveryManager
94      * @param newRecoveryManager the address of the new RecoveryManager
95      */
96     event TransferRecoveryManager(
97         address indexed previousRecoveryManager,
98         address indexed newRecoveryManager
99     );
100 
101     /**
102      * @notice Emitted when recovery state is initiated by the RecoveryManager
103      * @param recoveryManager the address of the current RecoveryManager who
104      * initiated the transition
105      * @param recoveryActiveAt the block at which recovery state will be active
106      */
107     event InitiateRecovery(
108         address indexed recoveryManager,
109         uint256 recoveryActiveAt
110     );
111 
112     /**
113      * @notice Emitted when recovery state is exited by the RecoveryManager
114      * @param recoveryManager the address of the current RecoveryManager who
115      * initiated the transition
116      */
117     event ExitRecovery(address recoveryManager);
118 
119     /**
120      * @notice Emitted when a batch of governance instructions from the
121      * governing remote router is received and ready for execution
122      * @param batchHash A hash committing to the batch of calls to be executed
123      */
124     event BatchReceived(bytes32 indexed batchHash);
125 
126     /**
127      * @notice Emitted when a batch of governance instructions from the
128      * governing remote router is executed
129      * @param batchHash A hash committing to the batch of calls to be executed
130      */
131     event BatchExecuted(bytes32 indexed batchHash);
132 
133     modifier typeAssert(bytes29 _view, GovernanceMessage.Types _type) {
134         _view.assertType(uint40(_type));
135         _;
136     }
137 
138     // ============ Modifiers ============
139 
140     modifier onlyReplica() {
141         require(xAppConnectionManager.isReplica(msg.sender), "!replica");
142         _;
143     }
144 
145     modifier onlyGovernorRouter(uint32 _domain, bytes32 _address) {
146         require(_isGovernorRouter(_domain, _address), "!governorRouter");
147         _;
148     }
149 
150     modifier onlyGovernor() {
151         require(
152             msg.sender == governor || msg.sender == address(this),
153             "! called by governor"
154         );
155         _;
156     }
157 
158     modifier onlyRecoveryManager() {
159         require(msg.sender == recoveryManager, "! called by recovery manager");
160         _;
161     }
162 
163     modifier onlyInRecovery() {
164         require(inRecovery(), "! in recovery");
165         _;
166     }
167 
168     modifier onlyNotInRecovery() {
169         require(!inRecovery(), "in recovery");
170         _;
171     }
172 
173     modifier onlyGovernorOrRecoveryManager() {
174         if (!inRecovery()) {
175             require(
176                 msg.sender == governor || msg.sender == address(this),
177                 "! called by governor"
178             );
179         } else {
180             require(
181                 msg.sender == recoveryManager || msg.sender == address(this),
182                 "! called by recovery manager"
183             );
184         }
185         _;
186     }
187 
188     // ============ Constructor ============
189 
190     constructor(uint32 _localDomain, uint256 _recoveryTimelock) {
191         localDomain = _localDomain;
192         recoveryTimelock = _recoveryTimelock;
193     }
194 
195     // ============ Initializer ============
196 
197     function initialize(
198         address _xAppConnectionManager,
199         address _recoveryManager
200     ) public initializer {
201         // initialize governor
202         address _governorAddr = msg.sender;
203         bool _isLocalGovernor = true;
204         _transferGovernor(localDomain, _governorAddr, _isLocalGovernor);
205         // initialize recovery manager
206         recoveryManager = _recoveryManager;
207         // initialize XAppConnectionManager
208         setXAppConnectionManager(_xAppConnectionManager);
209         require(
210             xAppConnectionManager.localDomain() == localDomain,
211             "XAppConnectionManager bad domain"
212         );
213     }
214 
215     // ============ External Functions ============
216 
217     /**
218      * @notice Handle Nomad messages
219      * For all non-Governor chains to handle messages
220      * sent from the Governor chain via Nomad.
221      * Governor chain should never receive messages,
222      * because non-Governor chains are not able to send them
223      * @param _origin The domain (of the Governor Router)
224      * @param _sender The message sender (must be the Governor Router)
225      * @param _message The message
226      */
227     function handle(
228         uint32 _origin,
229         uint32, // _nonce (unused)
230         bytes32 _sender,
231         bytes memory _message
232     ) external override onlyReplica onlyGovernorRouter(_origin, _sender) {
233         bytes29 _msg = _message.ref(0);
234         bytes29 _view = _msg.tryAsBatch();
235         if (_view.notNull()) {
236             _handleBatch(_view);
237             return;
238         }
239         _view = _msg.tryAsTransferGovernor();
240         if (_view.notNull()) {
241             _handleTransferGovernor(_view);
242             return;
243         }
244         require(false, "!valid message type");
245     }
246 
247     /**
248      * @notice Dispatch a set of local and remote calls
249      * Local calls are executed immediately.
250      * Remote calls are dispatched to the remote domain for processing and
251      * execution.
252      * @dev The contents of the _domains array at the same index
253      * will determine the destination of messages in that _remoteCalls array.
254      * As such, all messages in an array MUST have the same destination.
255      * Missing destinations or too many will result in reverts.
256      * @param _localCalls An array of local calls
257      * @param _remoteCalls An array of arrays of remote calls
258      */
259     function executeGovernanceActions(
260         GovernanceMessage.Call[] calldata _localCalls,
261         uint32[] calldata _domains,
262         GovernanceMessage.Call[][] calldata _remoteCalls
263     ) external onlyGovernorOrRecoveryManager {
264         require(
265             _domains.length == _remoteCalls.length,
266             "!domains length matches calls length"
267         );
268         // remote calls are disallowed while in recovery
269         require(
270             _remoteCalls.length == 0 || !inRecovery(),
271             "!remote calls in recovery mode"
272         );
273         // _localCall loop
274         for (uint256 i = 0; i < _localCalls.length; i++) {
275             _callLocal(_localCalls[i]);
276         }
277         // remote calls loop
278         for (uint256 i = 0; i < _remoteCalls.length; i++) {
279             uint32 destination = _domains[i];
280             _callRemote(destination, _remoteCalls[i]);
281         }
282     }
283 
284     /**
285      * @notice Dispatch calls on a remote chain via the remote GovernanceRouter
286      * @param _destination The domain of the remote chain
287      * @param _calls The calls
288      */
289     function _callRemote(
290         uint32 _destination,
291         GovernanceMessage.Call[] calldata _calls
292     ) internal onlyGovernor onlyNotInRecovery {
293         // ensure that destination chain has enrolled router
294         bytes32 _router = _mustHaveRouter(_destination);
295         // format batch message
296         bytes memory _msg = GovernanceMessage.formatBatch(_calls);
297         // dispatch call message using Nomad
298         Home(xAppConnectionManager.home()).dispatch(
299             _destination,
300             _router,
301             _msg
302         );
303     }
304 
305     /**
306      * @notice Transfer governorship
307      * @param _newDomain The domain of the new governor
308      * @param _newGovernor The address of the new governor
309      */
310     function transferGovernor(uint32 _newDomain, address _newGovernor)
311         external
312         onlyGovernor
313         onlyNotInRecovery
314     {
315         bool _isLocalGovernor = _isLocalDomain(_newDomain);
316         // transfer the governor locally
317         _transferGovernor(_newDomain, _newGovernor, _isLocalGovernor);
318         // if the governor domain is local, we only need to change the governor address locally
319         // no need to message remote routers; they should already have the same domain set and governor = bytes32(0)
320         if (_isLocalGovernor) {
321             return;
322         }
323         // format transfer governor message
324         bytes memory _transferGovernorMessage = GovernanceMessage
325             .formatTransferGovernor(
326                 _newDomain,
327                 TypeCasts.addressToBytes32(_newGovernor)
328             );
329         // send transfer governor message to all remote routers
330         // note: this assumes that the Router is on the global GovernorDomain;
331         // this causes a process error when relinquishing governorship
332         // on a newly deployed domain which is not the GovernorDomain
333         _sendToAllRemoteRouters(_transferGovernorMessage);
334     }
335 
336     /**
337      * @notice Transfer recovery manager role
338      * @dev callable by the recoveryManager at any time to transfer the role
339      * @param _newRecoveryManager The address of the new recovery manager
340      */
341     function transferRecoveryManager(address _newRecoveryManager)
342         external
343         onlyRecoveryManager
344     {
345         emit TransferRecoveryManager(recoveryManager, _newRecoveryManager);
346         recoveryManager = _newRecoveryManager;
347     }
348 
349     /**
350      * @notice Set the router address for a given domain and
351      * dispatch the change to all remote routers
352      * @param _domain The domain
353      * @param _router The address of the new router
354      */
355     function setRouterGlobal(uint32 _domain, bytes32 _router)
356         external
357         onlyGovernor
358         onlyNotInRecovery
359     {
360         _setRouterGlobal(_domain, _router);
361     }
362 
363     function _setRouterGlobal(uint32 _domain, bytes32 _router) internal {
364         Home _home = Home(xAppConnectionManager.home());
365         // Set up the call for use in the loop.
366         // Because each domain's governance router may be different, we cannot
367         // serialize the `Call` once and then reuse it. We have to re-serialize
368         // the call, adjusting its `to` value on each step of the loop.
369         GovernanceMessage.Call[] memory _calls = new GovernanceMessage.Call[](
370             1
371         );
372         _calls[0].data = abi.encodeWithSignature(
373             "setRouterLocal(uint32,bytes32)",
374             _domain,
375             _router
376         );
377         for (uint256 i = 0; i < domains.length; i++) {
378             uint32 _destination = domains[i];
379             if (_destination != uint32(0)) {
380                 // set to, and dispatch
381                 bytes32 _recipient = routers[_destination];
382                 _calls[0].to = _recipient;
383                 bytes memory _msg = GovernanceMessage.formatBatch(_calls);
384                 _home.dispatch(_destination, _recipient, _msg);
385             }
386         }
387         // set the router locally
388         _setRouter(_domain, _router);
389     }
390 
391     /**
392      * @notice Set the router address *locally only*
393      * @dev For use in deploy to setup the router mapping locally
394      * @param _domain The domain
395      * @param _router The new router
396      */
397     function setRouterLocal(uint32 _domain, bytes32 _router)
398         external
399         onlyGovernorOrRecoveryManager
400     {
401         // set the router locally
402         _setRouter(_domain, _router);
403     }
404 
405     /**
406      * @notice Set the address of the XAppConnectionManager
407      * @dev Domain/address validation helper
408      * @param _xAppConnectionManager The address of the new xAppConnectionManager
409      */
410     function setXAppConnectionManager(address _xAppConnectionManager)
411         public
412         onlyGovernorOrRecoveryManager
413     {
414         xAppConnectionManager = XAppConnectionManager(_xAppConnectionManager);
415     }
416 
417     /**
418      * @notice Initiate the recovery timelock
419      * @dev callable by the recovery manager
420      */
421     function initiateRecoveryTimelock()
422         external
423         onlyNotInRecovery
424         onlyRecoveryManager
425     {
426         require(recoveryActiveAt == 0, "recovery already initiated");
427         // set the time that recovery will be active
428         recoveryActiveAt = block.timestamp.add(recoveryTimelock);
429         emit InitiateRecovery(recoveryManager, recoveryActiveAt);
430     }
431 
432     /**
433      * @notice Exit recovery mode
434      * @dev callable by the recovery manager to end recovery mode
435      */
436     function exitRecovery() external onlyRecoveryManager {
437         require(recoveryActiveAt != 0, "recovery not initiated");
438         delete recoveryActiveAt;
439         emit ExitRecovery(recoveryManager);
440     }
441 
442     // ============ Public Functions ============
443 
444     /**
445      * @notice Check if the contract is in recovery mode currently
446      * @return TRUE iff the contract is actively in recovery mode currently
447      */
448     function inRecovery() public view returns (bool) {
449         uint256 _recoveryActiveAt = recoveryActiveAt;
450         bool _recoveryInitiated = _recoveryActiveAt != 0;
451         bool _recoveryActive = _recoveryActiveAt <= block.timestamp;
452         return _recoveryInitiated && _recoveryActive;
453     }
454 
455     // ============ Internal Functions ============
456 
457     /**
458      * @notice Handle message dispatching calls locally
459      * @dev We considered requiring the batch was not previously known.
460      *      However, this would prevent us from ever processing identical
461      *      batches, which seems desirable in some cases.
462      *      As a result, we simply set it to pending.
463      * @param _msg The message
464      */
465     function _handleBatch(bytes29 _msg)
466         internal
467         typeAssert(_msg, GovernanceMessage.Types.Batch)
468     {
469         bytes32 _batchHash = _msg.batchHash();
470         // prevent accidental SSTORE and extra event if already pending
471         if (inboundCallBatches[_batchHash] == BatchStatus.Pending) return;
472         inboundCallBatches[_batchHash] = BatchStatus.Pending;
473         emit BatchReceived(_batchHash);
474     }
475 
476     /**
477      * @notice execute a pending batch of messages
478      */
479     function executeCallBatch(GovernanceMessage.Call[] calldata _calls)
480         external
481     {
482         bytes32 _batchHash = GovernanceMessage.getBatchHash(_calls);
483         require(
484             inboundCallBatches[_batchHash] == BatchStatus.Pending,
485             "!batch pending"
486         );
487         inboundCallBatches[_batchHash] = BatchStatus.Complete;
488         for (uint256 i = 0; i < _calls.length; i++) {
489             _callLocal(_calls[i]);
490         }
491         emit BatchExecuted(_batchHash);
492     }
493 
494     /**
495      * @notice Handle message transferring governorship to a new Governor
496      * @param _msg The message
497      */
498     function _handleTransferGovernor(bytes29 _msg)
499         internal
500         typeAssert(_msg, GovernanceMessage.Types.TransferGovernor)
501     {
502         uint32 _newDomain = _msg.domain();
503         address _newGovernor = TypeCasts.bytes32ToAddress(_msg.governor());
504         bool _isLocalGovernor = _isLocalDomain(_newDomain);
505         _transferGovernor(_newDomain, _newGovernor, _isLocalGovernor);
506     }
507 
508     /**
509      * @notice Dispatch message to all remote routers
510      * @param _msg The message
511      */
512     function _sendToAllRemoteRouters(bytes memory _msg) internal {
513         Home _home = Home(xAppConnectionManager.home());
514 
515         for (uint256 i = 0; i < domains.length; i++) {
516             if (domains[i] != uint32(0)) {
517                 _home.dispatch(domains[i], routers[domains[i]], _msg);
518             }
519         }
520     }
521 
522     /**
523      * @notice Dispatch call locally
524      * @param _call The call
525      * @return _ret
526      */
527     function _callLocal(GovernanceMessage.Call memory _call)
528         internal
529         returns (bytes memory _ret)
530     {
531         address _toContract = TypeCasts.bytes32ToAddress(_call.to);
532         // attempt to dispatch using low-level call
533         bool _success;
534         (_success, _ret) = _toContract.call(_call.data);
535         // revert if the call failed
536         require(_success, "call failed");
537     }
538 
539     /**
540      * @notice Transfer governorship within this contract's state
541      * @param _newDomain The domain of the new governor
542      * @param _newGovernor The address of the new governor
543      * @param _isLocalGovernor True if the newDomain is the localDomain
544      */
545     function _transferGovernor(
546         uint32 _newDomain,
547         address _newGovernor,
548         bool _isLocalGovernor
549     ) internal {
550         // require that the governor domain has a valid router
551         if (!_isLocalGovernor) {
552             _mustHaveRouter(_newDomain);
553         }
554         // Governor is 0x0 unless the governor is local
555         address _newGov = _isLocalGovernor ? _newGovernor : address(0);
556         // emit event before updating state variables
557         emit TransferGovernor(governorDomain, _newDomain, governor, _newGov);
558         // update state
559         governorDomain = _newDomain;
560         governor = _newGov;
561     }
562 
563     /**
564      * @notice Set the router for a given domain
565      * @param _domain The domain
566      * @param _newRouter The new router
567      */
568     function _setRouter(uint32 _domain, bytes32 _newRouter) internal {
569         // ignore local domain in router mapping
570         require(!_isLocalDomain(_domain), "can't set local router");
571         // store previous router in memory
572         bytes32 _previousRouter = routers[_domain];
573         // if router is being removed,
574         if (_newRouter == bytes32(0)) {
575             // remove domain from array
576             _removeDomain(_domain);
577             // remove router from mapping
578             delete routers[_domain];
579         } else {
580             // if router was not previously added,
581             if (_previousRouter == bytes32(0)) {
582                 // add domain to array
583                 _addDomain(_domain);
584             }
585             // set router in mapping (add or change)
586             routers[_domain] = _newRouter;
587         }
588         // emit event
589         emit SetRouter(_domain, _previousRouter, _newRouter);
590     }
591 
592     /**
593      * @notice Add a domain that has a router
594      * @param _domain The domain
595      */
596     function _addDomain(uint32 _domain) internal {
597         domains.push(_domain);
598     }
599 
600     /**
601      * @notice Remove a domain from array
602      * @param _domain The domain
603      */
604     function _removeDomain(uint32 _domain) internal {
605         // find the index of the domain to remove & delete it from domains[]
606         for (uint256 i = 0; i < domains.length; i++) {
607             if (domains[i] == _domain) {
608                 delete domains[i];
609                 return;
610             }
611         }
612     }
613 
614     /**
615      * @notice Determine if a given domain and address is the Governor Router
616      * @param _domain The domain
617      * @param _address The address of the domain's router
618      * @return _ret True if the given domain/address is the
619      * Governor Router.
620      */
621     function _isGovernorRouter(uint32 _domain, bytes32 _address)
622         internal
623         view
624         returns (bool)
625     {
626         return _domain == governorDomain && _address == routers[_domain];
627     }
628 
629     /**
630      * @notice Determine if a given domain is the local domain
631      * @param _domain The domain
632      * @return _ret - True if the given domain is the local domain
633      */
634     function _isLocalDomain(uint32 _domain) internal view returns (bool) {
635         return _domain == localDomain;
636     }
637 
638     /**
639      * @notice Require that a domain has a router and returns the router
640      * @param _domain The domain
641      * @return _router - The domain's router
642      */
643     function _mustHaveRouter(uint32 _domain)
644         internal
645         view
646         returns (bytes32 _router)
647     {
648         _router = routers[_domain];
649         require(_router != bytes32(0), "!router");
650     }
651 }
