1 // File: @laborx/solidity-shared-lib/contracts/ERC20Interface.sol
2 
3 /**
4 * Copyright 2017–2018, LaborX PTY
5 * Licensed under the AGPL Version 3 license.
6 */
7 
8 pragma solidity ^0.4.23;
9 
10 
11 /// @title Defines an interface for EIP20 token smart contract
12 contract ERC20Interface {
13     
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed from, address indexed spender, uint256 value);
16 
17     string public symbol;
18 
19     function decimals() public view returns (uint8);
20     function totalSupply() public view returns (uint256 supply);
21 
22     function balanceOf(address _owner) public view returns (uint256 balance);
23     function transfer(address _to, uint256 _value) public returns (bool success);
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
25     function approve(address _spender, uint256 _value) public returns (bool success);
26     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
27 }
28 
29 // File: @laborx/solidity-eventshistory-lib/contracts/EventsHistorySourceAdapter.sol
30 
31 /**
32 * Copyright 2017–2018, LaborX PTY
33 * Licensed under the AGPL Version 3 license.
34 */
35 
36 pragma solidity ^0.4.21;
37 
38 
39 /**
40  * @title EventsHistory Source Adapter.
41  */
42 contract EventsHistorySourceAdapter {
43 
44     // It is address of MultiEventsHistory caller assuming we are inside of delegate call.
45     function _self()
46     internal
47     view
48     returns (address)
49     {
50         return msg.sender;
51     }
52 }
53 
54 // File: @laborx/solidity-eventshistory-lib/contracts/MultiEventsHistoryAdapter.sol
55 
56 /**
57 * Copyright 2017–2018, LaborX PTY
58 * Licensed under the AGPL Version 3 license.
59 */
60 
61 pragma solidity ^0.4.21;
62 
63 
64 
65 /**
66  * @title General MultiEventsHistory user.
67  */
68 contract MultiEventsHistoryAdapter is EventsHistorySourceAdapter {
69 
70     address internal localEventsHistory;
71 
72     event ErrorCode(address indexed self, uint errorCode);
73 
74     function getEventsHistory()
75     public
76     view
77     returns (address)
78     {
79         address _eventsHistory = localEventsHistory;
80         return _eventsHistory != 0x0 ? _eventsHistory : this;
81     }
82 
83     function emitErrorCode(uint _errorCode) public {
84         emit ErrorCode(_self(), _errorCode);
85     }
86 
87     function _setEventsHistory(address _eventsHistory) internal returns (bool) {
88         localEventsHistory = _eventsHistory;
89         return true;
90     }
91     
92     function _emitErrorCode(uint _errorCode) internal returns (uint) {
93         MultiEventsHistoryAdapter(getEventsHistory()).emitErrorCode(_errorCode);
94         return _errorCode;
95     }
96 }
97 
98 // File: contracts/ChronoBankPlatformEmitter.sol
99 
100 /**
101  * Copyright 2017–2018, LaborX PTY
102  * Licensed under the AGPL Version 3 license.
103  */
104 
105 pragma solidity ^0.4.21;
106 
107 
108 
109 /// @title ChronoBank Platform Emitter.
110 ///
111 /// Contains all the original event emitting function definitions and events.
112 /// In case of new events needed later, additional emitters can be developed.
113 /// All the functions is meant to be called using delegatecall.
114 contract ChronoBankPlatformEmitter is MultiEventsHistoryAdapter {
115 
116     event Transfer(address indexed from, address indexed to, bytes32 indexed symbol, uint value, string reference);
117     event Issue(bytes32 indexed symbol, uint value, address indexed by);
118     event Revoke(bytes32 indexed symbol, uint value, address indexed by);
119     event RevokeExternal(bytes32 indexed symbol, uint value, address indexed by, string externalReference);
120     event OwnershipChange(address indexed from, address indexed to, bytes32 indexed symbol);
121     event Approve(address indexed from, address indexed spender, bytes32 indexed symbol, uint value);
122     event Recovery(address indexed from, address indexed to, address by);
123 
124     function emitTransfer(address _from, address _to, bytes32 _symbol, uint _value, string _reference) public {
125         emit Transfer(_from, _to, _symbol, _value, _reference);
126     }
127 
128     function emitIssue(bytes32 _symbol, uint _value, address _by) public {
129         emit Issue(_symbol, _value, _by);
130     }
131 
132     function emitRevoke(bytes32 _symbol, uint _value, address _by) public {
133         emit Revoke(_symbol, _value, _by);
134     }
135 
136     function emitRevokeExternal(bytes32 _symbol, uint _value, address _by, string _externalReference) public {
137         emit RevokeExternal(_symbol, _value, _by, _externalReference);
138     }
139 
140     function emitOwnershipChange(address _from, address _to, bytes32 _symbol) public {
141         emit OwnershipChange(_from, _to, _symbol);
142     }
143 
144     function emitApprove(address _from, address _spender, bytes32 _symbol, uint _value) public {
145         emit Approve(_from, _spender, _symbol, _value);
146     }
147 
148     function emitRecovery(address _from, address _to, address _by) public {
149         emit Recovery(_from, _to, _by);
150     }
151 }
152 
153 // File: contracts/ChronoBankPlatformInterface.sol
154 
155 /**
156  * Copyright 2017–2018, LaborX PTY
157  * Licensed under the AGPL Version 3 license.
158  */
159 
160 pragma solidity ^0.4.11;
161 
162 
163 
164 contract ChronoBankPlatformInterface is ChronoBankPlatformEmitter {
165     mapping(bytes32 => address) public proxies;
166 
167     function symbols(uint _idx) public view returns (bytes32);
168     function symbolsCount() public view returns (uint);
169     function isCreated(bytes32 _symbol) public view returns(bool);
170     function isOwner(address _owner, bytes32 _symbol) public view returns(bool);
171     function owner(bytes32 _symbol) public view returns(address);
172 
173     function setProxy(address _address, bytes32 _symbol) public returns(uint errorCode);
174 
175     function name(bytes32 _symbol) public view returns(string);
176 
177     function totalSupply(bytes32 _symbol) public view returns(uint);
178     function balanceOf(address _holder, bytes32 _symbol) public view returns(uint);
179     function allowance(address _from, address _spender, bytes32 _symbol) public view returns(uint);
180     function baseUnit(bytes32 _symbol) public view returns(uint8);
181     function description(bytes32 _symbol) public view returns(string);
182     function isReissuable(bytes32 _symbol) public view returns(bool);
183     function blockNumber(bytes32 _symbol) public view returns (uint);
184 
185     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns(uint errorCode);
186     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns(uint errorCode);
187 
188     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns(uint errorCode);
189 
190     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, uint _blockNumber) public returns(uint errorCode);
191     function issueAssetWithInitialReceiver(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, uint _blockNumber, address _account) public returns(uint errorCode);
192 
193     function reissueAsset(bytes32 _symbol, uint _value) public returns(uint errorCode);
194     function reissueAssetToRecepient(bytes32 _symbol, uint _value, address _to) public returns (uint);
195 
196     function revokeAsset(bytes32 _symbol, uint _value) public returns(uint errorCode);
197     function revokeAssetWithExternalReference(bytes32 _symbol, uint _value, string _externalReference) public returns (uint);
198 
199     function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool);
200     function isDesignatedAssetManager(address _account, bytes32 _symbol) public view returns (bool);
201     function changeOwnership(bytes32 _symbol, address _newOwner) public returns(uint errorCode);
202 }
203 
204 // File: contracts/ChronoBankAssetInterface.sol
205 
206 /**
207  * Copyright 2017–2018, LaborX PTY
208  * Licensed under the AGPL Version 3 license.
209  */
210 
211 pragma solidity ^0.4.21;
212 
213 
214 contract ChronoBankAssetInterface {
215     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
216     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
217     function __approve(address _spender, uint _value, address _sender) public returns(bool);
218     function __process(bytes /*_data*/, address /*_sender*/) public payable {
219         revert("ASSET_PROCESS_NOT_SUPPORTED");
220     }
221 }
222 
223 // File: contracts/assets/ChronoBankAssetChainableInterface.sol
224 
225 /**
226 * Copyright 2017–2018, LaborX PTY
227 * Licensed under the AGPL Version 3 license.
228 */
229 
230 pragma solidity ^0.4.24;
231 
232 
233 contract ChronoBankAssetChainableInterface {
234 
235     function assetType() public pure returns (bytes32);
236 
237     function getPreviousAsset() public view returns (ChronoBankAssetChainableInterface);
238     function getNextAsset() public view returns (ChronoBankAssetChainableInterface);
239 
240     function getChainedAssets() public view returns (bytes32[] _types, address[] _assets);
241     function getAssetByType(bytes32 _assetType) public view returns (address);
242 
243     function chainAssets(ChronoBankAssetChainableInterface[] _assets) external returns (bool);
244     function __chainAssetsFromIdx(ChronoBankAssetChainableInterface[] _assets, uint _startFromIdx) external returns (bool);
245 
246     function finalizeAssetChaining() public;
247 }
248 
249 // File: contracts/assets/ChronoBankAssetUtils.sol
250 
251 /**
252 * Copyright 2017–2018, LaborX PTY
253 * Licensed under the AGPL Version 3 license.
254 */
255 
256 pragma solidity ^0.4.24;
257 
258 
259 
260 library ChronoBankAssetUtils {
261 
262     uint constant ASSETS_CHAIN_MAX_LENGTH = 20;
263 
264     function getChainedAssets(ChronoBankAssetChainableInterface _asset)
265     public
266     view
267     returns (bytes32[] _types, address[] _assets)
268     {
269         bytes32[] memory _tempTypes = new bytes32[](ASSETS_CHAIN_MAX_LENGTH);
270         address[] memory _tempAssets = new address[](ASSETS_CHAIN_MAX_LENGTH);
271 
272         ChronoBankAssetChainableInterface _next = getHeadAsset(_asset);
273         uint _counter = 0;
274         do {
275             _tempTypes[_counter] = _next.assetType();
276             _tempAssets[_counter] = address(_next);
277             _counter += 1;
278 
279             _next = _next.getNextAsset();
280         } while (address(_next) != 0x0);
281 
282         _types = new bytes32[](_counter);
283         _assets = new address[](_counter);
284         for (uint _assetIdx = 0; _assetIdx < _counter; ++_assetIdx) {
285             _types[_assetIdx] = _tempTypes[_assetIdx];
286             _assets[_assetIdx] = _tempAssets[_assetIdx];
287         }
288     }
289 
290     function getAssetByType(ChronoBankAssetChainableInterface _asset, bytes32 _assetType)
291     public
292     view
293     returns (address)
294     {
295         ChronoBankAssetChainableInterface _next = getHeadAsset(_asset);
296         do {
297             if (_next.assetType() == _assetType) {
298                 return address(_next);
299             }
300 
301             _next = _next.getNextAsset();
302         } while (address(_next) != 0x0);
303     }
304 
305     function containsAssetInChain(ChronoBankAssetChainableInterface _asset, address _checkAsset)
306     public
307     view
308     returns (bool)
309     {
310         ChronoBankAssetChainableInterface _next = getHeadAsset(_asset);
311         do {
312             if (address(_next) == _checkAsset) {
313                 return true;
314             }
315 
316             _next = _next.getNextAsset();
317         } while (address(_next) != 0x0);
318     }
319 
320     function getHeadAsset(ChronoBankAssetChainableInterface _asset)
321     public
322     view
323     returns (ChronoBankAssetChainableInterface)
324     {
325         ChronoBankAssetChainableInterface _head = _asset;
326         ChronoBankAssetChainableInterface _previousAsset;
327         do {
328             _previousAsset = _head.getPreviousAsset();
329             if (address(_previousAsset) == 0x0) {
330                 return _head;
331             }
332             _head = _previousAsset;
333         } while (true);
334     }
335 }
336 
337 // File: contracts/ChronoBankAssetProxy.sol
338 
339 /**
340  * Copyright 2017–2018, LaborX PTY
341  * Licensed under the AGPL Version 3 license.
342  */
343 
344 pragma solidity ^0.4.21;
345 
346 
347 contract ERC20 is ERC20Interface {}
348 
349 contract ChronoBankPlatform is ChronoBankPlatformInterface {}
350 
351 contract ChronoBankAsset is ChronoBankAssetInterface {}
352 
353 
354 
355 /// @title ChronoBank Asset Proxy.
356 ///
357 /// Proxy implements ERC20 interface and acts as a gateway to a single platform asset.
358 /// Proxy adds symbol and caller(sender) when forwarding requests to platform.
359 /// Every request that is made by caller first sent to the specific asset implementation
360 /// contract, which then calls back to be forwarded onto platform.
361 ///
362 /// Calls flow: Caller ->
363 ///             Proxy.func(...) ->
364 ///             Asset.__func(..., Caller.address) ->
365 ///             Proxy.__func(..., Caller.address) ->
366 ///             Platform.proxyFunc(..., symbol, Caller.address)
367 ///
368 /// Asset implementation contract is mutable, but each user have an option to stick with
369 /// old implementation, through explicit decision made in timely manner, if he doesn't agree
370 /// with new rules.
371 /// Each user have a possibility to upgrade to latest asset contract implementation, without the
372 /// possibility to rollback.
373 ///
374 /// Note: all the non constant functions return false instead of throwing in case if state change
375 /// didn't happen yet.
376 contract ChronoBankAssetProxy is ERC20 {
377 
378     /// @dev Supports ChronoBankPlatform ability to return error codes from methods
379     uint constant OK = 1;
380 
381     /// @dev Assigned platform, immutable.
382     ChronoBankPlatform public chronoBankPlatform;
383 
384     /// @dev Assigned symbol, immutable.
385     bytes32 public smbl;
386 
387     /// @dev Assigned name, immutable.
388     string public name;
389 
390     /// @dev Assigned symbol (from ERC20 standard), immutable
391     string public symbol;
392 
393     /// @notice Sets platform address, assigns symbol and name.
394     /// Can be set only once.
395     /// @param _chronoBankPlatform platform contract address.
396     /// @param _symbol assigned symbol.
397     /// @param _name assigned name.
398     /// @return success.
399     function init(ChronoBankPlatform _chronoBankPlatform, string _symbol, string _name) public returns (bool) {
400         if (address(chronoBankPlatform) != 0x0) {
401             return false;
402         }
403 
404         chronoBankPlatform = _chronoBankPlatform;
405         symbol = _symbol;
406         smbl = stringToBytes32(_symbol);
407         name = _name;
408         return true;
409     }
410 
411     function stringToBytes32(string memory source) public pure returns (bytes32 result) {
412         assembly {
413            result := mload(add(source, 32))
414         }
415     }
416 
417     /// @dev Only platform is allowed to call.
418     modifier onlyChronoBankPlatform {
419         if (msg.sender == address(chronoBankPlatform)) {
420             _;
421         }
422     }
423 
424     /// @dev Only current asset owner is allowed to call.
425     modifier onlyAssetOwner {
426         if (chronoBankPlatform.isOwner(msg.sender, smbl)) {
427             _;
428         }
429     }
430 
431     /// @dev Returns asset implementation contract for current caller.
432     /// @return asset implementation contract.
433     function _getAsset() internal view returns (ChronoBankAsset) {
434         return ChronoBankAsset(getVersionFor(msg.sender));
435     }
436 
437     /// @notice Returns asset total supply.
438     /// @return asset total supply.
439     function totalSupply() public view returns (uint) {
440         return chronoBankPlatform.totalSupply(smbl);
441     }
442 
443     /// @notice Returns asset balance for a particular holder.
444     /// @param _owner holder address.
445     /// @return holder balance.
446     function balanceOf(address _owner) public view returns (uint) {
447         return chronoBankPlatform.balanceOf(_owner, smbl);
448     }
449 
450     /// @notice Returns asset allowance from one holder to another.
451     /// @param _from holder that allowed spending.
452     /// @param _spender holder that is allowed to spend.
453     /// @return holder to spender allowance.
454     function allowance(address _from, address _spender) public view returns (uint) {
455         return chronoBankPlatform.allowance(_from, _spender, smbl);
456     }
457 
458     /// @notice Returns asset decimals.
459     /// @return asset decimals.
460     function decimals() public view returns (uint8) {
461         return chronoBankPlatform.baseUnit(smbl);
462     }
463 
464     /// @notice Transfers asset balance from the caller to specified receiver.
465     /// @param _to holder address to give to.
466     /// @param _value amount to transfer.
467     /// @return success.
468     function transfer(address _to, uint _value) public returns (bool) {
469         if (_to != 0x0) {
470             return _transferWithReference(_to, _value, "");
471         }
472     }
473 
474     /// @notice Transfers asset balance from the caller to specified receiver adding specified comment.
475     /// @param _to holder address to give to.
476     /// @param _value amount to transfer.
477     /// @param _reference transfer comment to be included in a platform's Transfer event.
478     /// @return success.
479     function transferWithReference(address _to, uint _value, string _reference) public returns (bool) {
480         if (_to != 0x0) {
481             return _transferWithReference(_to, _value, _reference);
482         }
483     }
484 
485     /// @notice Resolves asset implementation contract for the caller and forwards there arguments along with
486     /// the caller address.
487     /// @return success.
488     function _transferWithReference(address _to, uint _value, string _reference) internal returns (bool) {
489         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
490     }
491 
492     /// @notice Performs transfer call on the platform by the name of specified sender.
493     ///
494     /// Can only be called by asset implementation contract assigned to sender.
495     ///
496     /// @param _to holder address to give to.
497     /// @param _value amount to transfer.
498     /// @param _reference transfer comment to be included in a platform's Transfer event.
499     /// @param _sender initial caller.
500     ///
501     /// @return success.
502     function __transferWithReference(
503         address _to, 
504         uint _value, 
505         string _reference, 
506         address _sender
507     ) 
508     onlyAccess(_sender) 
509     public 
510     returns (bool) 
511     {
512         return chronoBankPlatform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
513     }
514 
515     /// @notice Performs allowance transfer of asset balance between holders.
516     /// @param _from holder address to take from.
517     /// @param _to holder address to give to.
518     /// @param _value amount to transfer.
519     /// @return success.
520     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
521         if (_to != 0x0) {
522             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
523         }
524     }
525 
526     /// @notice Performs allowance transfer call on the platform by the name of specified sender.
527     ///
528     /// Can only be called by asset implementation contract assigned to sender.
529     ///
530     /// @param _from holder address to take from.
531     /// @param _to holder address to give to.
532     /// @param _value amount to transfer.
533     /// @param _reference transfer comment to be included in a platform's Transfer event.
534     /// @param _sender initial caller.
535     ///
536     /// @return success.
537     function __transferFromWithReference(
538         address _from, 
539         address _to, 
540         uint _value, 
541         string _reference, 
542         address _sender
543     ) 
544     onlyAccess(_sender) 
545     public 
546     returns (bool) 
547     {
548         return chronoBankPlatform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
549     }
550 
551     /// @notice Sets asset spending allowance for a specified spender.
552     /// @param _spender holder address to set allowance to.
553     /// @param _value amount to allow.
554     /// @return success.
555     function approve(address _spender, uint _value) public returns (bool) {
556         if (_spender != 0x0) {
557             return _getAsset().__approve(_spender, _value, msg.sender);
558         }
559     }
560 
561     /// @notice Performs allowance setting call on the platform by the name of specified sender.
562     /// Can only be called by asset implementation contract assigned to sender.
563     /// @param _spender holder address to set allowance to.
564     /// @param _value amount to allow.
565     /// @param _sender initial caller.
566     /// @return success.
567     function __approve(address _spender, uint _value, address _sender) onlyAccess(_sender) public returns (bool) {
568         return chronoBankPlatform.proxyApprove(_spender, _value, smbl, _sender) == OK;
569     }
570 
571     /// @notice Emits ERC20 Transfer event on this contract.
572     /// Can only be, and, called by assigned platform when asset transfer happens.
573     function emitTransfer(address _from, address _to, uint _value) onlyChronoBankPlatform public {
574         emit Transfer(_from, _to, _value);
575     }
576 
577     /// @notice Emits ERC20 Approval event on this contract.
578     /// Can only be, and, called by assigned platform when asset allowance set happens.
579     function emitApprove(address _from, address _spender, uint _value) onlyChronoBankPlatform public {
580         emit Approval(_from, _spender, _value);
581     }
582 
583     /// @notice Resolves asset implementation contract for the caller and forwards there transaction data,
584     /// along with the value. This allows for proxy interface growth.
585     function () public payable {
586         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
587     }
588 
589     /// @dev Indicates an upgrade freeze-time start, and the next asset implementation contract.
590     event UpgradeProposal(address newVersion);
591 
592     /// @dev Current asset implementation contract address.
593     address latestVersion;
594 
595     /// @dev Proposed next asset implementation contract address.
596     address pendingVersion;
597 
598     /// @dev Upgrade freeze-time start.
599     uint pendingVersionTimestamp;
600 
601     /// @dev Timespan for users to review the new implementation and make decision.
602     uint constant UPGRADE_FREEZE_TIME = 3 days;
603 
604     /// @dev Asset implementation contract address that user decided to stick with.
605     /// 0x0 means that user uses latest version.
606     mapping(address => address) userOptOutVersion;
607 
608     /// @dev Only asset implementation contract assigned to sender is allowed to call.
609     modifier onlyAccess(address _sender) {
610         address _versionFor = getVersionFor(_sender);
611         if (msg.sender == _versionFor ||
612             ChronoBankAssetUtils.containsAssetInChain(ChronoBankAssetChainableInterface(_versionFor), msg.sender)
613         ) {
614             _;
615         }
616     }
617 
618     /// @notice Returns asset implementation contract address assigned to sender.
619     /// @param _sender sender address.
620     /// @return asset implementation contract address.
621     function getVersionFor(address _sender) public view returns (address) {
622         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
623     }
624 
625     /// @notice Returns current asset implementation contract address.
626     /// @return asset implementation contract address.
627     function getLatestVersion() public view returns (address) {
628         return latestVersion;
629     }
630 
631     /// @notice Returns proposed next asset implementation contract address.
632     /// @return asset implementation contract address.
633     function getPendingVersion() public view returns (address) {
634         return pendingVersion;
635     }
636 
637     /// @notice Returns upgrade freeze-time start.
638     /// @return freeze-time start.
639     function getPendingVersionTimestamp() public view returns (uint) {
640         return pendingVersionTimestamp;
641     }
642 
643     /// @notice Propose next asset implementation contract address.
644     /// Can only be called by current asset owner.
645     /// Note: freeze-time should not be applied for the initial setup.
646     /// @param _newVersion asset implementation contract address.
647     /// @return success.
648     function proposeUpgrade(address _newVersion) onlyAssetOwner public returns (bool) {
649         // Should not already be in the upgrading process.
650         if (pendingVersion != 0x0) {
651             return false;
652         }
653 
654         // New version address should be other than 0x0.
655         if (_newVersion == 0x0) {
656             return false;
657         }
658 
659         // Don't apply freeze-time for the initial setup.
660         if (latestVersion == 0x0) {
661             latestVersion = _newVersion;
662             return true;
663         }
664 
665         pendingVersion = _newVersion;
666         pendingVersionTimestamp = now;
667 
668         emit UpgradeProposal(_newVersion);
669         return true;
670     }
671 
672     /// @notice Cancel the pending upgrade process.
673     /// Can only be called by current asset owner.
674     /// @return success.
675     function purgeUpgrade() public onlyAssetOwner returns (bool) {
676         if (pendingVersion == 0x0) {
677             return false;
678         }
679 
680         delete pendingVersion;
681         delete pendingVersionTimestamp;
682         return true;
683     }
684 
685     /// @notice Finalize an upgrade process setting new asset implementation contract address.
686     /// Can only be called after an upgrade freeze-time.
687     /// @return success.
688     function commitUpgrade() public returns (bool) {
689         if (pendingVersion == 0x0) {
690             return false;
691         }
692 
693         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
694             return false;
695         }
696 
697         latestVersion = pendingVersion;
698         delete pendingVersion;
699         delete pendingVersionTimestamp;
700         return true;
701     }
702 
703     /// @notice Disagree with proposed upgrade, and stick with current asset implementation
704     /// until further explicit agreement to upgrade.
705     /// @return success.
706     function optOut() public returns (bool) {
707         if (userOptOutVersion[msg.sender] != 0x0) {
708             return false;
709         }
710         userOptOutVersion[msg.sender] = latestVersion;
711         return true;
712     }
713 
714     /// @notice Implicitly agree to upgrade to current and future asset implementation upgrades,
715     /// until further explicit disagreement.
716     /// @return success.
717     function optIn() public returns (bool) {
718         delete userOptOutVersion[msg.sender];
719         return true;
720     }
721 }