1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 // ============ Internal Imports ============
6 import {Home} from "../Home.sol";
7 import {Version0} from "../Version0.sol";
8 import {XAppConnectionManager, TypeCasts} from "../XAppConnectionManager.sol";
9 import {IMessageRecipient} from "../interfaces/IMessageRecipient.sol";
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
163     modifier onlyNotInRecovery() {
164         require(!inRecovery(), "in recovery");
165         _;
166     }
167 
168     modifier onlyGovernorOrRecoveryManager() {
169         if (!inRecovery()) {
170             require(
171                 msg.sender == governor || msg.sender == address(this),
172                 "! called by governor"
173             );
174         } else {
175             require(
176                 msg.sender == recoveryManager || msg.sender == address(this),
177                 "! called by recovery manager"
178             );
179         }
180         _;
181     }
182 
183     // ============ Constructor ============
184 
185     constructor(uint32 _localDomain, uint256 _recoveryTimelock) {
186         localDomain = _localDomain;
187         recoveryTimelock = _recoveryTimelock;
188     }
189 
190     // ============ Initializer ============
191 
192     function initialize(
193         address _xAppConnectionManager,
194         address _recoveryManager
195     ) public initializer {
196         // initialize governor
197         address _governorAddr = msg.sender;
198         bool _isLocalGovernor = true;
199         _transferGovernor(localDomain, _governorAddr, _isLocalGovernor);
200         // initialize recovery manager
201         recoveryManager = _recoveryManager;
202         // initialize XAppConnectionManager
203         setXAppConnectionManager(_xAppConnectionManager);
204     }
205 
206     // ============ External Functions ============
207 
208     /**
209      * @notice Handle Nomad messages
210      * For all non-Governor chains to handle messages
211      * sent from the Governor chain via Nomad.
212      * Governor chain should never receive messages,
213      * because non-Governor chains are not able to send them
214      * @param _origin The domain (of the Governor Router)
215      * @param _sender The message sender (must be the Governor Router)
216      * @param _message The message
217      */
218     function handle(
219         uint32 _origin,
220         uint32, // _nonce (unused)
221         bytes32 _sender,
222         bytes memory _message
223     ) external override onlyReplica onlyGovernorRouter(_origin, _sender) {
224         bytes29 _msg = _message.ref(0);
225         bytes29 _view = _msg.tryAsBatch();
226         if (_view.notNull()) {
227             _handleBatch(_view);
228             return;
229         }
230         _view = _msg.tryAsTransferGovernor();
231         if (_view.notNull()) {
232             _handleTransferGovernor(_view);
233             return;
234         }
235         require(false, "!valid message type");
236     }
237 
238     /**
239      * @notice Dispatch a set of local and remote calls
240      * Local calls are executed immediately.
241      * Remote calls are dispatched to the remote domain for processing and
242      * execution.
243      * @dev The contents of the _domains array at the same index
244      * will determine the destination of messages in that _remoteCalls array.
245      * As such, all messages in an array MUST have the same destination.
246      * Missing destinations or too many will result in reverts.
247      * @param _localCalls An array of local calls
248      * @param _remoteCalls An array of arrays of remote calls
249      */
250     function executeGovernanceActions(
251         GovernanceMessage.Call[] calldata _localCalls,
252         uint32[] calldata _domains,
253         GovernanceMessage.Call[][] calldata _remoteCalls
254     ) external onlyGovernorOrRecoveryManager {
255         // extend the access modifier onlyGovernor, limiting the call to
256         // external actors. This is to protect against governanceRouter calling
257         // the function through executeCallBatch.
258         // executeGovernanceActions is intended to be executed ONLY by external actors,
259         // namely either the governor or the recovery manager
260         require(msg.sender != address(this), "!sender is an external address");
261         require(
262             _domains.length == _remoteCalls.length,
263             "!domains length matches calls length"
264         );
265         // remote calls are disallowed while in recovery
266         require(
267             _remoteCalls.length == 0 || !inRecovery(),
268             "!remote calls in recovery mode"
269         );
270         // _localCall loop
271         for (uint256 i = 0; i < _localCalls.length; i++) {
272             _callLocal(_localCalls[i]);
273         }
274         // remote calls loop
275         for (uint256 i = 0; i < _remoteCalls.length; i++) {
276             uint32 destination = _domains[i];
277             _callRemote(destination, _remoteCalls[i]);
278         }
279     }
280 
281     /**
282      * @notice Dispatch calls on a remote chain via the remote GovernanceRouter
283      * @param _destination The domain of the remote chain
284      * @param _calls The calls
285      */
286     function _callRemote(
287         uint32 _destination,
288         GovernanceMessage.Call[] calldata _calls
289     ) internal onlyGovernor onlyNotInRecovery {
290         // ensure that destination chain has enrolled router
291         bytes32 _router = _mustHaveRouter(_destination);
292         // format batch message
293         bytes memory _msg = GovernanceMessage.formatBatch(_calls);
294         // dispatch call message using Nomad
295         Home(xAppConnectionManager.home()).dispatch(
296             _destination,
297             _router,
298             _msg
299         );
300     }
301 
302     /**
303      * @notice Transfer governorship
304      * @param _newDomain The domain of the new governor
305      * @param _newGovernor The address of the new governor
306      */
307     function transferGovernor(uint32 _newDomain, address _newGovernor)
308         external
309         onlyGovernor
310         onlyNotInRecovery
311     {
312         bool _isLocalGovernor = _isLocalDomain(_newDomain);
313         // transfer the governor locally
314         _transferGovernor(_newDomain, _newGovernor, _isLocalGovernor);
315         // if the governor domain is local, we only need to change the governor address locally
316         // no need to message remote routers; they should already have the same domain set and governor = bytes32(0)
317         if (_isLocalGovernor) {
318             return;
319         }
320         // format transfer governor message
321         bytes memory _transferGovernorMessage = GovernanceMessage
322             .formatTransferGovernor(
323                 _newDomain,
324                 TypeCasts.addressToBytes32(_newGovernor)
325             );
326         // send transfer governor message to all remote routers
327         // note: this assumes that the Router is on the global GovernorDomain;
328         // this causes a process error when relinquishing governorship
329         // on a newly deployed domain which is not the GovernorDomain
330         _sendToAllRemoteRouters(_transferGovernorMessage);
331     }
332 
333     /**
334      * @notice Transfer recovery manager role
335      * @dev callable by the recoveryManager at any time to transfer the role
336      * @param _newRecoveryManager The address of the new recovery manager
337      */
338     function transferRecoveryManager(address _newRecoveryManager)
339         external
340         onlyRecoveryManager
341     {
342         emit TransferRecoveryManager(recoveryManager, _newRecoveryManager);
343         recoveryManager = _newRecoveryManager;
344     }
345 
346     /**
347      * @notice Set the router address for a given domain and
348      * dispatch the change to all remote routers
349      * @param _domain The domain
350      * @param _router The address of the new router
351      */
352     function setRouterGlobal(uint32 _domain, bytes32 _router)
353         external
354         onlyGovernor
355         onlyNotInRecovery
356     {
357         _setRouterGlobal(_domain, _router);
358     }
359 
360     function _setRouterGlobal(uint32 _domain, bytes32 _router) internal {
361         Home _home = Home(xAppConnectionManager.home());
362         // Set up the call for use in the loop.
363         // Because each domain's governance router may be different, we cannot
364         // serialize the `Call` once and then reuse it. We have to re-serialize
365         // the call, adjusting its `to` value on each step of the loop.
366         GovernanceMessage.Call[] memory _calls = new GovernanceMessage.Call[](
367             1
368         );
369         _calls[0].data = abi.encodeWithSignature(
370             "setRouterLocal(uint32,bytes32)",
371             _domain,
372             _router
373         );
374         for (uint256 i = 0; i < domains.length; i++) {
375             uint32 _destination = domains[i];
376             if (_destination != uint32(0)) {
377                 // set to, and dispatch
378                 bytes32 _recipient = routers[_destination];
379                 _calls[0].to = _recipient;
380                 bytes memory _msg = GovernanceMessage.formatBatch(_calls);
381                 _home.dispatch(_destination, _recipient, _msg);
382             }
383         }
384         // set the router locally
385         _setRouter(_domain, _router);
386     }
387 
388     /**
389      * @notice Set the router address *locally only*
390      * @dev For use in deploy to setup the router mapping locally
391      * @param _domain The domain
392      * @param _router The new router
393      */
394     function setRouterLocal(uint32 _domain, bytes32 _router)
395         external
396         onlyGovernorOrRecoveryManager
397     {
398         // set the router locally
399         _setRouter(_domain, _router);
400     }
401 
402     /**
403      * @notice Set the address of the XAppConnectionManager
404      * @dev Domain/address validation helper
405      * @param _xAppConnectionManager The address of the new xAppConnectionManager
406      */
407     function setXAppConnectionManager(address _xAppConnectionManager)
408         public
409         onlyGovernorOrRecoveryManager
410     {
411         xAppConnectionManager = XAppConnectionManager(_xAppConnectionManager);
412         require(
413             xAppConnectionManager.localDomain() == localDomain,
414             "XAppConnectionManager bad domain"
415         );
416     }
417 
418     /**
419      * @notice Initiate the recovery timelock
420      * @dev callable by the recovery manager
421      */
422     function initiateRecoveryTimelock()
423         external
424         onlyNotInRecovery
425         onlyRecoveryManager
426     {
427         require(recoveryActiveAt == 0, "recovery already initiated");
428         // set the time that recovery will be active
429         recoveryActiveAt = block.timestamp.add(recoveryTimelock);
430         emit InitiateRecovery(recoveryManager, recoveryActiveAt);
431     }
432 
433     /**
434      * @notice Exit recovery mode
435      * @dev callable by the recovery manager to end recovery mode
436      */
437     function exitRecovery() external onlyRecoveryManager {
438         require(recoveryActiveAt != 0, "recovery not initiated");
439         delete recoveryActiveAt;
440         emit ExitRecovery(recoveryManager);
441     }
442 
443     // ============ Public Functions ============
444 
445     /**
446      * @notice Check if the contract is in recovery mode currently
447      * @return TRUE iff the contract is actively in recovery mode currently
448      */
449     function inRecovery() public view returns (bool) {
450         uint256 _recoveryActiveAt = recoveryActiveAt;
451         bool _recoveryInitiated = _recoveryActiveAt != 0;
452         bool _recoveryActive = _recoveryActiveAt <= block.timestamp;
453         return _recoveryInitiated && _recoveryActive;
454     }
455 
456     // ============ Internal Functions ============
457 
458     /**
459      * @notice Handle message storing batch of calls to be executed locally
460      * @dev If a second, identical batch is attempted to deliver while
461      *      the first is still pending, the second delivery will revert,
462      *      allowing the second batch to be delivered later after the first is executed.
463      * @param _msg The message
464      */
465     function _handleBatch(bytes29 _msg)
466         internal
467         typeAssert(_msg, GovernanceMessage.Types.Batch)
468     {
469         bytes32 _batchHash = _msg.batchHash();
470         // prevent delivery of identical batches while one is still pending
471         require(
472             inboundCallBatches[_batchHash] != BatchStatus.Pending,
473             "BatchStatus is Pending"
474         );
475         // set batch to pending & emit
476         inboundCallBatches[_batchHash] = BatchStatus.Pending;
477         emit BatchReceived(_batchHash);
478     }
479 
480     /**
481      * @notice execute a pending batch of messages
482      */
483     function executeCallBatch(GovernanceMessage.Call[] calldata _calls)
484         external
485     {
486         bytes32 _batchHash = GovernanceMessage.getBatchHash(_calls);
487         require(
488             inboundCallBatches[_batchHash] == BatchStatus.Pending,
489             "!batch pending"
490         );
491         inboundCallBatches[_batchHash] = BatchStatus.Complete;
492         for (uint256 i = 0; i < _calls.length; i++) {
493             _callLocal(_calls[i]);
494         }
495         emit BatchExecuted(_batchHash);
496     }
497 
498     /**
499      * @notice Handle message transferring governorship to a new Governor
500      * @param _msg The message
501      */
502     function _handleTransferGovernor(bytes29 _msg)
503         internal
504         typeAssert(_msg, GovernanceMessage.Types.TransferGovernor)
505     {
506         uint32 _newDomain = _msg.domain();
507         address _newGovernor = TypeCasts.bytes32ToAddress(_msg.governor());
508         bool _isLocalGovernor = _isLocalDomain(_newDomain);
509         _transferGovernor(_newDomain, _newGovernor, _isLocalGovernor);
510     }
511 
512     /**
513      * @notice Dispatch message to all remote routers
514      * @param _msg The message
515      */
516     function _sendToAllRemoteRouters(bytes memory _msg) internal {
517         Home _home = Home(xAppConnectionManager.home());
518 
519         for (uint256 i = 0; i < domains.length; i++) {
520             if (domains[i] != uint32(0)) {
521                 _home.dispatch(domains[i], routers[domains[i]], _msg);
522             }
523         }
524     }
525 
526     /**
527      * @notice Dispatch call locally
528      * @param _call The call
529      * @return _ret
530      */
531     function _callLocal(GovernanceMessage.Call memory _call)
532         internal
533         returns (bytes memory _ret)
534     {
535         address _toContract = TypeCasts.bytes32ToAddress(_call.to);
536         // attempt to dispatch using low-level call
537         bool _success;
538         (_success, _ret) = _toContract.call(_call.data);
539         // revert if the call failed
540         require(_success, "call failed");
541     }
542 
543     /**
544      * @notice Transfer governorship within this contract's state
545      * @param _newDomain The domain of the new governor
546      * @param _newGovernor The address of the new governor
547      * @param _isLocalGovernor True if the newDomain is the localDomain
548      */
549     function _transferGovernor(
550         uint32 _newDomain,
551         address _newGovernor,
552         bool _isLocalGovernor
553     ) internal {
554         // require that the new governor is not the zero address
555         require(_newGovernor != address(0), "cannot renounce governor");
556         // require that the governor domain has a valid router
557         if (!_isLocalGovernor) {
558             _mustHaveRouter(_newDomain);
559         }
560         // Governor is 0x0 unless the governor is local
561         address _newGov = _isLocalGovernor ? _newGovernor : address(0);
562         // emit event before updating state variables
563         emit TransferGovernor(governorDomain, _newDomain, governor, _newGov);
564         // update state
565         governorDomain = _newDomain;
566         governor = _newGov;
567     }
568 
569     /**
570      * @notice Set the router for a given domain
571      * @param _domain The domain
572      * @param _newRouter The new router
573      */
574     function _setRouter(uint32 _domain, bytes32 _newRouter) internal {
575         // ignore local domain in router mapping
576         require(!_isLocalDomain(_domain), "can't set local router");
577         // store previous router in memory
578         bytes32 _previousRouter = routers[_domain];
579         // if router is being removed,
580         if (_newRouter == bytes32(0)) {
581             // remove domain from array
582             _removeDomain(_domain);
583             // remove router from mapping
584             delete routers[_domain];
585         } else {
586             // if router was not previously added,
587             if (_previousRouter == bytes32(0)) {
588                 // add domain to array
589                 _addDomain(_domain);
590             }
591             // set router in mapping (add or change)
592             routers[_domain] = _newRouter;
593         }
594         // emit event
595         emit SetRouter(_domain, _previousRouter, _newRouter);
596     }
597 
598     /**
599      * @notice Add a domain that has a router
600      * @param _domain The domain
601      */
602     function _addDomain(uint32 _domain) internal {
603         domains.push(_domain);
604     }
605 
606     /**
607      * @notice Remove a domain from array
608      * @param _domain The domain
609      */
610     function _removeDomain(uint32 _domain) internal {
611         // find the index of the domain to remove & delete it from domains[]
612         for (uint256 i = 0; i < domains.length; i++) {
613             if (domains[i] == _domain) {
614                 delete domains[i];
615                 return;
616             }
617         }
618     }
619 
620     /**
621      * @notice Determine if a given domain and address is the Governor Router
622      * @param _domain The domain
623      * @param _address The address of the domain's router
624      * @return _ret True if the given domain/address is the
625      * Governor Router.
626      */
627     function _isGovernorRouter(uint32 _domain, bytes32 _address)
628         internal
629         view
630         returns (bool)
631     {
632         return
633             _domain == governorDomain &&
634             _address == routers[_domain] &&
635             _address != 0;
636     }
637 
638     /**
639      * @notice Determine if a given domain is the local domain
640      * @param _domain The domain
641      * @return _ret - True if the given domain is the local domain
642      */
643     function _isLocalDomain(uint32 _domain) internal view returns (bool) {
644         return _domain == localDomain;
645     }
646 
647     /**
648      * @notice Require that a domain has a router and returns the router
649      * @param _domain The domain
650      * @return _router - The domain's router
651      */
652     function _mustHaveRouter(uint32 _domain)
653         internal
654         view
655         returns (bytes32 _router)
656     {
657         _router = routers[_domain];
658         require(_router != bytes32(0), "!router");
659     }
660 }
