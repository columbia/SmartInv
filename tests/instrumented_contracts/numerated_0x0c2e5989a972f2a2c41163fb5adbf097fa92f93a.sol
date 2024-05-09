1 pragma solidity ^0.4.11;
2 
3 // File: @laborx/solidity-shared-lib/contracts/ERC20Interface.sol
4 
5 /**
6 * Copyright 2017–2018, LaborX PTY
7 * Licensed under the AGPL Version 3 license.
8 */
9 
10 pragma solidity ^0.4.23;
11 
12 
13 /// @title Defines an interface for EIP20 token smart contract
14 contract ERC20Interface {
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed from, address indexed spender, uint256 value);
18 
19     string public symbol;
20 
21     function decimals() public view returns (uint8);
22     function totalSupply() public view returns (uint256 supply);
23 
24     function balanceOf(address _owner) public view returns (uint256 balance);
25     function transfer(address _to, uint256 _value) public returns (bool success);
26     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
27     function approve(address _spender, uint256 _value) public returns (bool success);
28     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
29 }
30 
31 // File: contracts/assets/ChronoBankAssetChainableInterface.sol
32 
33 /**
34 * Copyright 2017–2018, LaborX PTY
35 * Licensed under the AGPL Version 3 license.
36 */
37 
38 pragma solidity ^0.4.24;
39 
40 
41 contract ChronoBankAssetChainableInterface {
42 
43     function assetType() public pure returns (bytes32);
44 
45     function getPreviousAsset() public view returns (ChronoBankAssetChainableInterface);
46     function getNextAsset() public view returns (ChronoBankAssetChainableInterface);
47 
48     function getChainedAssets() public view returns (bytes32[] _types, address[] _assets);
49     function getAssetByType(bytes32 _assetType) public view returns (address);
50 
51     function chainAssets(ChronoBankAssetChainableInterface[] _assets) external returns (bool);
52     function __chainAssetsFromIdx(ChronoBankAssetChainableInterface[] _assets, uint _startFromIdx) external returns (bool);
53 
54     function finalizeAssetChaining() public;
55 }
56 
57 // File: contracts/assets/ChronoBankAssetUtils.sol
58 
59 /**
60 * Copyright 2017–2018, LaborX PTY
61 * Licensed under the AGPL Version 3 license.
62 */
63 
64 pragma solidity ^0.4.24;
65 
66 
67 
68 library ChronoBankAssetUtils {
69 
70     uint constant ASSETS_CHAIN_MAX_LENGTH = 20;
71 
72     function getChainedAssets(ChronoBankAssetChainableInterface _asset)
73     public
74     view
75     returns (bytes32[] _types, address[] _assets)
76     {
77         bytes32[] memory _tempTypes = new bytes32[](ASSETS_CHAIN_MAX_LENGTH);
78         address[] memory _tempAssets = new address[](ASSETS_CHAIN_MAX_LENGTH);
79 
80         ChronoBankAssetChainableInterface _next = getHeadAsset(_asset);
81         uint _counter = 0;
82         do {
83             _tempTypes[_counter] = _next.assetType();
84             _tempAssets[_counter] = address(_next);
85             _counter += 1;
86 
87             _next = _next.getNextAsset();
88         } while (address(_next) != 0x0);
89 
90         _types = new bytes32[](_counter);
91         _assets = new address[](_counter);
92         for (uint _assetIdx = 0; _assetIdx < _counter; ++_assetIdx) {
93             _types[_assetIdx] = _tempTypes[_assetIdx];
94             _assets[_assetIdx] = _tempAssets[_assetIdx];
95         }
96     }
97 
98     function getAssetByType(ChronoBankAssetChainableInterface _asset, bytes32 _assetType)
99     public
100     view
101     returns (address)
102     {
103         ChronoBankAssetChainableInterface _next = getHeadAsset(_asset);
104         do {
105             if (_next.assetType() == _assetType) {
106                 return address(_next);
107             }
108 
109             _next = _next.getNextAsset();
110         } while (address(_next) != 0x0);
111     }
112 
113     function containsAssetInChain(ChronoBankAssetChainableInterface _asset, address _checkAsset)
114     public
115     view
116     returns (bool)
117     {
118         ChronoBankAssetChainableInterface _next = getHeadAsset(_asset);
119         do {
120             if (address(_next) == _checkAsset) {
121                 return true;
122             }
123 
124             _next = _next.getNextAsset();
125         } while (address(_next) != 0x0);
126     }
127 
128     function getHeadAsset(ChronoBankAssetChainableInterface _asset)
129     public
130     view
131     returns (ChronoBankAssetChainableInterface)
132     {
133         ChronoBankAssetChainableInterface _head = _asset;
134         ChronoBankAssetChainableInterface _previousAsset;
135         do {
136             _previousAsset = _head.getPreviousAsset();
137             if (address(_previousAsset) == 0x0) {
138                 return _head;
139             }
140             _head = _previousAsset;
141         } while (true);
142     }
143 }
144 
145 // File: @laborx/solidity-eventshistory-lib/contracts/EventsHistorySourceAdapter.sol
146 
147 /**
148 * Copyright 2017–2018, LaborX PTY
149 * Licensed under the AGPL Version 3 license.
150 */
151 
152 pragma solidity ^0.4.21;
153 
154 
155 /**
156  * @title EventsHistory Source Adapter.
157  */
158 contract EventsHistorySourceAdapter {
159 
160     // It is address of MultiEventsHistory caller assuming we are inside of delegate call.
161     function _self()
162     internal
163     view
164     returns (address)
165     {
166         return msg.sender;
167     }
168 }
169 
170 // File: @laborx/solidity-eventshistory-lib/contracts/MultiEventsHistoryAdapter.sol
171 
172 /**
173 * Copyright 2017–2018, LaborX PTY
174 * Licensed under the AGPL Version 3 license.
175 */
176 
177 pragma solidity ^0.4.21;
178 
179 
180 
181 /**
182  * @title General MultiEventsHistory user.
183  */
184 contract MultiEventsHistoryAdapter is EventsHistorySourceAdapter {
185 
186     address internal localEventsHistory;
187 
188     event ErrorCode(address indexed self, uint errorCode);
189 
190     function getEventsHistory()
191     public
192     view
193     returns (address)
194     {
195         address _eventsHistory = localEventsHistory;
196         return _eventsHistory != 0x0 ? _eventsHistory : this;
197     }
198 
199     function emitErrorCode(uint _errorCode) public {
200         emit ErrorCode(_self(), _errorCode);
201     }
202 
203     function _setEventsHistory(address _eventsHistory) internal returns (bool) {
204         localEventsHistory = _eventsHistory;
205         return true;
206     }
207 
208     function _emitErrorCode(uint _errorCode) internal returns (uint) {
209         MultiEventsHistoryAdapter(getEventsHistory()).emitErrorCode(_errorCode);
210         return _errorCode;
211     }
212 }
213 
214 // File: contracts/ChronoBankPlatformEmitter.sol
215 
216 /**
217  * Copyright 2017–2018, LaborX PTY
218  * Licensed under the AGPL Version 3 license.
219  */
220 
221 pragma solidity ^0.4.21;
222 
223 
224 
225 /// @title ChronoBank Platform Emitter.
226 ///
227 /// Contains all the original event emitting function definitions and events.
228 /// In case of new events needed later, additional emitters can be developed.
229 /// All the functions is meant to be called using delegatecall.
230 contract ChronoBankPlatformEmitter is MultiEventsHistoryAdapter {
231 
232     event Transfer(address indexed from, address indexed to, bytes32 indexed symbol, uint value, string reference);
233     event Issue(bytes32 indexed symbol, uint value, address indexed by);
234     event Revoke(bytes32 indexed symbol, uint value, address indexed by);
235     event RevokeExternal(bytes32 indexed symbol, uint value, address indexed by, string externalReference);
236     event OwnershipChange(address indexed from, address indexed to, bytes32 indexed symbol);
237     event Approve(address indexed from, address indexed spender, bytes32 indexed symbol, uint value);
238     event Recovery(address indexed from, address indexed to, address by);
239 
240     function emitTransfer(address _from, address _to, bytes32 _symbol, uint _value, string _reference) public {
241         emit Transfer(_from, _to, _symbol, _value, _reference);
242     }
243 
244     function emitIssue(bytes32 _symbol, uint _value, address _by) public {
245         emit Issue(_symbol, _value, _by);
246     }
247 
248     function emitRevoke(bytes32 _symbol, uint _value, address _by) public {
249         emit Revoke(_symbol, _value, _by);
250     }
251 
252     function emitRevokeExternal(bytes32 _symbol, uint _value, address _by, string _externalReference) public {
253         emit RevokeExternal(_symbol, _value, _by, _externalReference);
254     }
255 
256     function emitOwnershipChange(address _from, address _to, bytes32 _symbol) public {
257         emit OwnershipChange(_from, _to, _symbol);
258     }
259 
260     function emitApprove(address _from, address _spender, bytes32 _symbol, uint _value) public {
261         emit Approve(_from, _spender, _symbol, _value);
262     }
263 
264     function emitRecovery(address _from, address _to, address _by) public {
265         emit Recovery(_from, _to, _by);
266     }
267 }
268 
269 // File: contracts/ChronoBankPlatformInterface.sol
270 
271 /**
272  * Copyright 2017–2018, LaborX PTY
273  * Licensed under the AGPL Version 3 license.
274  */
275 
276 pragma solidity ^0.4.11;
277 
278 
279 
280 contract ChronoBankPlatformInterface is ChronoBankPlatformEmitter {
281     mapping(bytes32 => address) public proxies;
282 
283     function symbols(uint _idx) public view returns (bytes32);
284     function symbolsCount() public view returns (uint);
285     function isCreated(bytes32 _symbol) public view returns(bool);
286     function isOwner(address _owner, bytes32 _symbol) public view returns(bool);
287     function owner(bytes32 _symbol) public view returns(address);
288 
289     function setProxy(address _address, bytes32 _symbol) public returns(uint errorCode);
290 
291     function name(bytes32 _symbol) public view returns(string);
292 
293     function totalSupply(bytes32 _symbol) public view returns(uint);
294     function balanceOf(address _holder, bytes32 _symbol) public view returns(uint);
295     function allowance(address _from, address _spender, bytes32 _symbol) public view returns(uint);
296     function baseUnit(bytes32 _symbol) public view returns(uint8);
297     function description(bytes32 _symbol) public view returns(string);
298     function isReissuable(bytes32 _symbol) public view returns(bool);
299     function blockNumber(bytes32 _symbol) public view returns (uint);
300 
301     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns(uint errorCode);
302     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns(uint errorCode);
303 
304     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns(uint errorCode);
305 
306     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, uint _blockNumber) public returns(uint errorCode);
307     function issueAssetWithInitialReceiver(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, uint _blockNumber, address _account) public returns(uint errorCode);
308 
309     function reissueAsset(bytes32 _symbol, uint _value) public returns(uint errorCode);
310     function reissueAssetToRecepient(bytes32 _symbol, uint _value, address _to) public returns (uint);
311 
312     function revokeAsset(bytes32 _symbol, uint _value) public returns(uint errorCode);
313     function revokeAssetWithExternalReference(bytes32 _symbol, uint _value, string _externalReference) public returns (uint);
314 
315     function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool);
316     function isDesignatedAssetManager(address _account, bytes32 _symbol) public view returns (bool);
317     function changeOwnership(bytes32 _symbol, address _newOwner) public returns(uint errorCode);
318 }
319 
320 // File: contracts/ChronoBankAssetInterface.sol
321 
322 /**
323  * Copyright 2017–2018, LaborX PTY
324  * Licensed under the AGPL Version 3 license.
325  */
326 
327 pragma solidity ^0.4.21;
328 
329 
330 contract ChronoBankAssetInterface {
331     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
332     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
333     function __approve(address _spender, uint _value, address _sender) public returns(bool);
334     function __process(bytes /*_data*/, address /*_sender*/) public payable {
335         revert("ASSET_PROCESS_NOT_SUPPORTED");
336     }
337 }
338 
339 // File: contracts/ChronoBankAssetProxy.sol
340 
341 /**
342  * Copyright 2017–2018, LaborX PTY
343  * Licensed under the AGPL Version 3 license.
344  */
345 
346 pragma solidity ^0.4.21;
347 
348 
349 contract ERC20 is ERC20Interface {}
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
722 
723 // File: @laborx/solidity-shared-lib/contracts/Owned.sol
724 
725 /**
726 * Copyright 2017–2018, LaborX PTY
727 * Licensed under the AGPL Version 3 license.
728 */
729 
730 pragma solidity ^0.4.23;
731 
732 
733 
734 /// @title Owned contract with safe ownership pass.
735 ///
736 /// Note: all the non constant functions return false instead of throwing in case if state change
737 /// didn't happen yet.
738 contract Owned {
739 
740     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
741 
742     address public contractOwner;
743     address public pendingContractOwner;
744 
745     modifier onlyContractOwner {
746         if (msg.sender == contractOwner) {
747             _;
748         }
749     }
750 
751     constructor()
752     public
753     {
754         contractOwner = msg.sender;
755     }
756 
757     /// @notice Prepares ownership pass.
758     /// Can only be called by current owner.
759     /// @param _to address of the next owner.
760     /// @return success.
761     function changeContractOwnership(address _to)
762     public
763     onlyContractOwner
764     returns (bool)
765     {
766         if (_to == 0x0) {
767             return false;
768         }
769         pendingContractOwner = _to;
770         return true;
771     }
772 
773     /// @notice Finalize ownership pass.
774     /// Can only be called by pending owner.
775     /// @return success.
776     function claimContractOwnership()
777     public
778     returns (bool)
779     {
780         if (msg.sender != pendingContractOwner) {
781             return false;
782         }
783 
784         emit OwnershipTransferred(contractOwner, pendingContractOwner);
785         contractOwner = pendingContractOwner;
786         delete pendingContractOwner;
787         return true;
788     }
789 
790     /// @notice Allows the current owner to transfer control of the contract to a newOwner.
791     /// @param newOwner The address to transfer ownership to.
792     function transferOwnership(address newOwner)
793     public
794     onlyContractOwner
795     returns (bool)
796     {
797         if (newOwner == 0x0) {
798             return false;
799         }
800 
801         emit OwnershipTransferred(contractOwner, newOwner);
802         contractOwner = newOwner;
803         delete pendingContractOwner;
804         return true;
805     }
806 
807     /// @notice Allows the current owner to transfer control of the contract to a newOwner.
808     /// @dev Backward compatibility only.
809     /// @param newOwner The address to transfer ownership to.
810     function transferContractOwnership(address newOwner)
811     public
812     returns (bool)
813     {
814         return transferOwnership(newOwner);
815     }
816 
817     /// @notice Withdraw given tokens from contract to owner.
818     /// This method is only allowed for contact owner.
819     function withdrawTokens(address[] tokens)
820     public
821     onlyContractOwner
822     {
823         address _contractOwner = contractOwner;
824         for (uint i = 0; i < tokens.length; i++) {
825             ERC20Interface token = ERC20Interface(tokens[i]);
826             uint balance = token.balanceOf(this);
827             if (balance > 0) {
828                 token.transfer(_contractOwner, balance);
829             }
830         }
831     }
832 
833     /// @notice Withdraw ether from contract to owner.
834     /// This method is only allowed for contact owner.
835     function withdrawEther()
836     public
837     onlyContractOwner
838     {
839         uint balance = address(this).balance;
840         if (balance > 0)  {
841             contractOwner.transfer(balance);
842         }
843     }
844 
845     /// @notice Transfers ether to another address.
846     /// Allowed only for contract owners.
847     /// @param _to recepient address
848     /// @param _value wei to transfer; must be less or equal to total balance on the contract
849     function transferEther(address _to, uint256 _value)
850     public
851     onlyContractOwner
852     {
853         require(_to != 0x0, "INVALID_ETHER_RECEPIENT_ADDRESS");
854         if (_value > address(this).balance) {
855             revert("INVALID_VALUE_TO_TRANSFER_ETHER");
856         }
857 
858         _to.transfer(_value);
859     }
860 }
861 
862 // File: @laborx/solidity-storage-lib/contracts/Storage.sol
863 
864 /**
865  * Copyright 2017–2018, LaborX PTY
866  * Licensed under the AGPL Version 3 license.
867  */
868 
869 pragma solidity ^0.4.23;
870 
871 
872 
873 contract Manager {
874     function isAllowed(address _actor, bytes32 _role) public view returns (bool);
875     function hasAccess(address _actor) public view returns (bool);
876 }
877 
878 
879 contract Storage is Owned {
880     struct Crate {
881         mapping(bytes32 => uint) uints;
882         mapping(bytes32 => address) addresses;
883         mapping(bytes32 => bool) bools;
884         mapping(bytes32 => int) ints;
885         mapping(bytes32 => uint8) uint8s;
886         mapping(bytes32 => bytes32) bytes32s;
887         mapping(bytes32 => AddressUInt8) addressUInt8s;
888         mapping(bytes32 => string) strings;
889     }
890 
891     struct AddressUInt8 {
892         address _address;
893         uint8 _uint8;
894     }
895 
896     mapping(bytes32 => Crate) internal crates;
897     Manager public manager;
898 
899     modifier onlyAllowed(bytes32 _role) {
900         if (!(msg.sender == address(this) || manager.isAllowed(msg.sender, _role))) {
901             revert("STORAGE_FAILED_TO_ACCESS_PROTECTED_FUNCTION");
902         }
903         _;
904     }
905 
906     function setManager(Manager _manager)
907     external
908     onlyContractOwner
909     returns (bool)
910     {
911         manager = _manager;
912         return true;
913     }
914 
915     function setUInt(bytes32 _crate, bytes32 _key, uint _value)
916     public
917     onlyAllowed(_crate)
918     {
919         _setUInt(_crate, _key, _value);
920     }
921 
922     function _setUInt(bytes32 _crate, bytes32 _key, uint _value)
923     internal
924     {
925         crates[_crate].uints[_key] = _value;
926     }
927 
928 
929     function getUInt(bytes32 _crate, bytes32 _key)
930     public
931     view
932     returns (uint)
933     {
934         return crates[_crate].uints[_key];
935     }
936 
937     function setAddress(bytes32 _crate, bytes32 _key, address _value)
938     public
939     onlyAllowed(_crate)
940     {
941         _setAddress(_crate, _key, _value);
942     }
943 
944     function _setAddress(bytes32 _crate, bytes32 _key, address _value)
945     internal
946     {
947         crates[_crate].addresses[_key] = _value;
948     }
949 
950     function getAddress(bytes32 _crate, bytes32 _key)
951     public
952     view
953     returns (address)
954     {
955         return crates[_crate].addresses[_key];
956     }
957 
958     function setBool(bytes32 _crate, bytes32 _key, bool _value)
959     public
960     onlyAllowed(_crate)
961     {
962         _setBool(_crate, _key, _value);
963     }
964 
965     function _setBool(bytes32 _crate, bytes32 _key, bool _value)
966     internal
967     {
968         crates[_crate].bools[_key] = _value;
969     }
970 
971     function getBool(bytes32 _crate, bytes32 _key)
972     public
973     view
974     returns (bool)
975     {
976         return crates[_crate].bools[_key];
977     }
978 
979     function setInt(bytes32 _crate, bytes32 _key, int _value)
980     public
981     onlyAllowed(_crate)
982     {
983         _setInt(_crate, _key, _value);
984     }
985 
986     function _setInt(bytes32 _crate, bytes32 _key, int _value)
987     internal
988     {
989         crates[_crate].ints[_key] = _value;
990     }
991 
992     function getInt(bytes32 _crate, bytes32 _key)
993     public
994     view
995     returns (int)
996     {
997         return crates[_crate].ints[_key];
998     }
999 
1000     function setUInt8(bytes32 _crate, bytes32 _key, uint8 _value)
1001     public
1002     onlyAllowed(_crate)
1003     {
1004         _setUInt8(_crate, _key, _value);
1005     }
1006 
1007     function _setUInt8(bytes32 _crate, bytes32 _key, uint8 _value)
1008     internal
1009     {
1010         crates[_crate].uint8s[_key] = _value;
1011     }
1012 
1013     function getUInt8(bytes32 _crate, bytes32 _key)
1014     public
1015     view
1016     returns (uint8)
1017     {
1018         return crates[_crate].uint8s[_key];
1019     }
1020 
1021     function setBytes32(bytes32 _crate, bytes32 _key, bytes32 _value)
1022     public
1023     onlyAllowed(_crate)
1024     {
1025         _setBytes32(_crate, _key, _value);
1026     }
1027 
1028     function _setBytes32(bytes32 _crate, bytes32 _key, bytes32 _value)
1029     internal
1030     {
1031         crates[_crate].bytes32s[_key] = _value;
1032     }
1033 
1034     function getBytes32(bytes32 _crate, bytes32 _key)
1035     public
1036     view
1037     returns (bytes32)
1038     {
1039         return crates[_crate].bytes32s[_key];
1040     }
1041 
1042     function setAddressUInt8(bytes32 _crate, bytes32 _key, address _value, uint8 _value2)
1043     public
1044     onlyAllowed(_crate)
1045     {
1046         _setAddressUInt8(_crate, _key, _value, _value2);
1047     }
1048 
1049     function _setAddressUInt8(bytes32 _crate, bytes32 _key, address _value, uint8 _value2)
1050     internal
1051     {
1052         crates[_crate].addressUInt8s[_key] = AddressUInt8(_value, _value2);
1053     }
1054 
1055     function getAddressUInt8(bytes32 _crate, bytes32 _key)
1056     public
1057     view
1058     returns (address, uint8)
1059     {
1060         return (crates[_crate].addressUInt8s[_key]._address, crates[_crate].addressUInt8s[_key]._uint8);
1061     }
1062 
1063     function setString(bytes32 _crate, bytes32 _key, string _value)
1064     public
1065     onlyAllowed(_crate)
1066     {
1067         _setString(_crate, _key, _value);
1068     }
1069 
1070     function _setString(bytes32 _crate, bytes32 _key, string _value)
1071     internal
1072     {
1073         crates[_crate].strings[_key] = _value;
1074     }
1075 
1076     function getString(bytes32 _crate, bytes32 _key)
1077     public
1078     view
1079     returns (string)
1080     {
1081         return crates[_crate].strings[_key];
1082     }
1083 }
1084 
1085 // File: @laborx/solidity-storage-lib/contracts/StorageInterface.sol
1086 
1087 /**
1088  * Copyright 2017–2018, LaborX PTY
1089  * Licensed under the AGPL Version 3 license.
1090  */
1091 
1092 pragma solidity ^0.4.23;
1093 
1094 
1095 
1096 library StorageInterface {
1097     struct Config {
1098         Storage store;
1099         bytes32 crate;
1100     }
1101 
1102     struct UInt {
1103         bytes32 id;
1104     }
1105 
1106     struct UInt8 {
1107         bytes32 id;
1108     }
1109 
1110     struct Int {
1111         bytes32 id;
1112     }
1113 
1114     struct Address {
1115         bytes32 id;
1116     }
1117 
1118     struct Bool {
1119         bytes32 id;
1120     }
1121 
1122     struct Bytes32 {
1123         bytes32 id;
1124     }
1125 
1126     struct String {
1127         bytes32 id;
1128     }
1129 
1130     struct Mapping {
1131         bytes32 id;
1132     }
1133 
1134     struct StringMapping {
1135         String id;
1136     }
1137 
1138     struct UIntBoolMapping {
1139         Bool innerMapping;
1140     }
1141 
1142     struct UIntUIntMapping {
1143         Mapping innerMapping;
1144     }
1145 
1146     struct UIntBytes32Mapping {
1147         Mapping innerMapping;
1148     }
1149 
1150     struct UIntAddressMapping {
1151         Mapping innerMapping;
1152     }
1153 
1154     struct UIntEnumMapping {
1155         Mapping innerMapping;
1156     }
1157 
1158     struct AddressBoolMapping {
1159         Mapping innerMapping;
1160     }
1161 
1162     struct AddressUInt8Mapping {
1163         bytes32 id;
1164     }
1165 
1166     struct AddressUIntMapping {
1167         Mapping innerMapping;
1168     }
1169 
1170     struct AddressBytes32Mapping {
1171         Mapping innerMapping;
1172     }
1173 
1174     struct AddressAddressMapping {
1175         Mapping innerMapping;
1176     }
1177 
1178     struct Bytes32UIntMapping {
1179         Mapping innerMapping;
1180     }
1181 
1182     struct Bytes32UInt8Mapping {
1183         UInt8 innerMapping;
1184     }
1185 
1186     struct Bytes32BoolMapping {
1187         Bool innerMapping;
1188     }
1189 
1190     struct Bytes32Bytes32Mapping {
1191         Mapping innerMapping;
1192     }
1193 
1194     struct Bytes32AddressMapping {
1195         Mapping innerMapping;
1196     }
1197 
1198     struct Bytes32UIntBoolMapping {
1199         Bool innerMapping;
1200     }
1201 
1202     struct AddressAddressUInt8Mapping {
1203         Mapping innerMapping;
1204     }
1205 
1206     struct AddressAddressUIntMapping {
1207         Mapping innerMapping;
1208     }
1209 
1210     struct AddressUIntUIntMapping {
1211         Mapping innerMapping;
1212     }
1213 
1214     struct AddressUIntUInt8Mapping {
1215         Mapping innerMapping;
1216     }
1217 
1218     struct AddressBytes32Bytes32Mapping {
1219         Mapping innerMapping;
1220     }
1221 
1222     struct AddressBytes4BoolMapping {
1223         Mapping innerMapping;
1224     }
1225 
1226     struct AddressBytes4Bytes32Mapping {
1227         Mapping innerMapping;
1228     }
1229 
1230     struct UIntAddressUIntMapping {
1231         Mapping innerMapping;
1232     }
1233 
1234     struct UIntAddressAddressMapping {
1235         Mapping innerMapping;
1236     }
1237 
1238     struct UIntAddressBoolMapping {
1239         Mapping innerMapping;
1240     }
1241 
1242     struct UIntUIntAddressMapping {
1243         Mapping innerMapping;
1244     }
1245 
1246     struct UIntUIntBytes32Mapping {
1247         Mapping innerMapping;
1248     }
1249 
1250     struct UIntUIntUIntMapping {
1251         Mapping innerMapping;
1252     }
1253 
1254     struct Bytes32UIntUIntMapping {
1255         Mapping innerMapping;
1256     }
1257 
1258     struct AddressUIntUIntUIntMapping {
1259         Mapping innerMapping;
1260     }
1261 
1262     struct AddressUIntStructAddressUInt8Mapping {
1263         AddressUInt8Mapping innerMapping;
1264     }
1265 
1266     struct AddressUIntUIntStructAddressUInt8Mapping {
1267         AddressUInt8Mapping innerMapping;
1268     }
1269 
1270     struct AddressUIntUIntUIntStructAddressUInt8Mapping {
1271         AddressUInt8Mapping innerMapping;
1272     }
1273 
1274     struct AddressUIntUIntUIntUIntStructAddressUInt8Mapping {
1275         AddressUInt8Mapping innerMapping;
1276     }
1277 
1278     struct AddressUIntAddressUInt8Mapping {
1279         Mapping innerMapping;
1280     }
1281 
1282     struct AddressUIntUIntAddressUInt8Mapping {
1283         Mapping innerMapping;
1284     }
1285 
1286     struct AddressUIntUIntUIntAddressUInt8Mapping {
1287         Mapping innerMapping;
1288     }
1289 
1290     struct UIntAddressAddressBoolMapping {
1291         Bool innerMapping;
1292     }
1293 
1294     struct UIntUIntUIntBytes32Mapping {
1295         Mapping innerMapping;
1296     }
1297 
1298     struct Bytes32UIntUIntUIntMapping {
1299         Mapping innerMapping;
1300     }
1301 
1302     bytes32 constant SET_IDENTIFIER = "set";
1303 
1304     struct Set {
1305         UInt count;
1306         Mapping indexes;
1307         Mapping values;
1308     }
1309 
1310     struct AddressesSet {
1311         Set innerSet;
1312     }
1313 
1314     struct CounterSet {
1315         Set innerSet;
1316     }
1317 
1318     bytes32 constant ORDERED_SET_IDENTIFIER = "ordered_set";
1319 
1320     struct OrderedSet {
1321         UInt count;
1322         Bytes32 first;
1323         Bytes32 last;
1324         Mapping nextValues;
1325         Mapping previousValues;
1326     }
1327 
1328     struct OrderedUIntSet {
1329         OrderedSet innerSet;
1330     }
1331 
1332     struct OrderedAddressesSet {
1333         OrderedSet innerSet;
1334     }
1335 
1336     struct Bytes32SetMapping {
1337         Set innerMapping;
1338     }
1339 
1340     struct AddressesSetMapping {
1341         Bytes32SetMapping innerMapping;
1342     }
1343 
1344     struct UIntSetMapping {
1345         Bytes32SetMapping innerMapping;
1346     }
1347 
1348     struct Bytes32OrderedSetMapping {
1349         OrderedSet innerMapping;
1350     }
1351 
1352     struct UIntOrderedSetMapping {
1353         Bytes32OrderedSetMapping innerMapping;
1354     }
1355 
1356     struct AddressOrderedSetMapping {
1357         Bytes32OrderedSetMapping innerMapping;
1358     }
1359 
1360     // Can't use modifier due to a Solidity bug.
1361     function sanityCheck(bytes32 _currentId, bytes32 _newId) internal pure {
1362         if (_currentId != 0 || _newId == 0) {
1363             revert();
1364         }
1365     }
1366 
1367     function init(Config storage self, Storage _store, bytes32 _crate) internal {
1368         self.store = _store;
1369         self.crate = _crate;
1370     }
1371 
1372     function init(UInt8 storage self, bytes32 _id) internal {
1373         sanityCheck(self.id, _id);
1374         self.id = _id;
1375     }
1376 
1377     function init(UInt storage self, bytes32 _id) internal {
1378         sanityCheck(self.id, _id);
1379         self.id = _id;
1380     }
1381 
1382     function init(Int storage self, bytes32 _id) internal {
1383         sanityCheck(self.id, _id);
1384         self.id = _id;
1385     }
1386 
1387     function init(Address storage self, bytes32 _id) internal {
1388         sanityCheck(self.id, _id);
1389         self.id = _id;
1390     }
1391 
1392     function init(Bool storage self, bytes32 _id) internal {
1393         sanityCheck(self.id, _id);
1394         self.id = _id;
1395     }
1396 
1397     function init(Bytes32 storage self, bytes32 _id) internal {
1398         sanityCheck(self.id, _id);
1399         self.id = _id;
1400     }
1401 
1402     function init(String storage self, bytes32 _id) internal {
1403         sanityCheck(self.id, _id);
1404         self.id = _id;
1405     }
1406 
1407     function init(Mapping storage self, bytes32 _id) internal {
1408         sanityCheck(self.id, _id);
1409         self.id = _id;
1410     }
1411 
1412     function init(StringMapping storage self, bytes32 _id) internal {
1413         init(self.id, _id);
1414     }
1415 
1416     function init(UIntAddressMapping storage self, bytes32 _id) internal {
1417         init(self.innerMapping, _id);
1418     }
1419 
1420     function init(UIntUIntMapping storage self, bytes32 _id) internal {
1421         init(self.innerMapping, _id);
1422     }
1423 
1424     function init(UIntEnumMapping storage self, bytes32 _id) internal {
1425         init(self.innerMapping, _id);
1426     }
1427 
1428     function init(UIntBoolMapping storage self, bytes32 _id) internal {
1429         init(self.innerMapping, _id);
1430     }
1431 
1432     function init(UIntBytes32Mapping storage self, bytes32 _id) internal {
1433         init(self.innerMapping, _id);
1434     }
1435 
1436     function init(AddressAddressUIntMapping storage self, bytes32 _id) internal {
1437         init(self.innerMapping, _id);
1438     }
1439 
1440     function init(AddressBytes32Bytes32Mapping storage self, bytes32 _id) internal {
1441         init(self.innerMapping, _id);
1442     }
1443 
1444     function init(AddressUIntUIntMapping storage self, bytes32 _id) internal {
1445         init(self.innerMapping, _id);
1446     }
1447 
1448     function init(UIntAddressUIntMapping storage self, bytes32 _id) internal {
1449         init(self.innerMapping, _id);
1450     }
1451 
1452     function init(UIntAddressBoolMapping storage self, bytes32 _id) internal {
1453         init(self.innerMapping, _id);
1454     }
1455 
1456     function init(UIntUIntAddressMapping storage self, bytes32 _id) internal {
1457         init(self.innerMapping, _id);
1458     }
1459 
1460     function init(UIntAddressAddressMapping storage self, bytes32 _id) internal {
1461         init(self.innerMapping, _id);
1462     }
1463 
1464     function init(UIntUIntBytes32Mapping storage self, bytes32 _id) internal {
1465         init(self.innerMapping, _id);
1466     }
1467 
1468     function init(UIntUIntUIntMapping storage self, bytes32 _id) internal {
1469         init(self.innerMapping, _id);
1470     }
1471 
1472     function init(UIntAddressAddressBoolMapping storage self, bytes32 _id) internal {
1473         init(self.innerMapping, _id);
1474     }
1475 
1476     function init(UIntUIntUIntBytes32Mapping storage self, bytes32 _id) internal {
1477         init(self.innerMapping, _id);
1478     }
1479 
1480     function init(Bytes32UIntUIntMapping storage self, bytes32 _id) internal {
1481         init(self.innerMapping, _id);
1482     }
1483 
1484     function init(Bytes32UIntUIntUIntMapping storage self, bytes32 _id) internal {
1485         init(self.innerMapping, _id);
1486     }
1487 
1488     function init(AddressBoolMapping storage self, bytes32 _id) internal {
1489         init(self.innerMapping, _id);
1490     }
1491 
1492     function init(AddressUInt8Mapping storage self, bytes32 _id) internal {
1493         sanityCheck(self.id, _id);
1494         self.id = _id;
1495     }
1496 
1497     function init(AddressUIntMapping storage self, bytes32 _id) internal {
1498         init(self.innerMapping, _id);
1499     }
1500 
1501     function init(AddressBytes32Mapping storage self, bytes32 _id) internal {
1502         init(self.innerMapping, _id);
1503     }
1504 
1505     function init(AddressAddressMapping  storage self, bytes32 _id) internal {
1506         init(self.innerMapping, _id);
1507     }
1508 
1509     function init(AddressAddressUInt8Mapping storage self, bytes32 _id) internal {
1510         init(self.innerMapping, _id);
1511     }
1512 
1513     function init(AddressUIntUInt8Mapping storage self, bytes32 _id) internal {
1514         init(self.innerMapping, _id);
1515     }
1516 
1517     function init(AddressBytes4BoolMapping storage self, bytes32 _id) internal {
1518         init(self.innerMapping, _id);
1519     }
1520 
1521     function init(AddressBytes4Bytes32Mapping storage self, bytes32 _id) internal {
1522         init(self.innerMapping, _id);
1523     }
1524 
1525     function init(AddressUIntUIntUIntMapping storage self, bytes32 _id) internal {
1526         init(self.innerMapping, _id);
1527     }
1528 
1529     function init(AddressUIntStructAddressUInt8Mapping storage self, bytes32 _id) internal {
1530         init(self.innerMapping, _id);
1531     }
1532 
1533     function init(AddressUIntUIntStructAddressUInt8Mapping storage self, bytes32 _id) internal {
1534         init(self.innerMapping, _id);
1535     }
1536 
1537     function init(AddressUIntUIntUIntStructAddressUInt8Mapping storage self, bytes32 _id) internal {
1538         init(self.innerMapping, _id);
1539     }
1540 
1541     function init(AddressUIntUIntUIntUIntStructAddressUInt8Mapping storage self, bytes32 _id) internal {
1542         init(self.innerMapping, _id);
1543     }
1544 
1545     function init(AddressUIntAddressUInt8Mapping storage self, bytes32 _id) internal {
1546         init(self.innerMapping, _id);
1547     }
1548 
1549     function init(AddressUIntUIntAddressUInt8Mapping storage self, bytes32 _id) internal {
1550         init(self.innerMapping, _id);
1551     }
1552 
1553     function init(AddressUIntUIntUIntAddressUInt8Mapping storage self, bytes32 _id) internal {
1554         init(self.innerMapping, _id);
1555     }
1556 
1557     function init(Bytes32UIntMapping storage self, bytes32 _id) internal {
1558         init(self.innerMapping, _id);
1559     }
1560 
1561     function init(Bytes32UInt8Mapping storage self, bytes32 _id) internal {
1562         init(self.innerMapping, _id);
1563     }
1564 
1565     function init(Bytes32BoolMapping storage self, bytes32 _id) internal {
1566         init(self.innerMapping, _id);
1567     }
1568 
1569     function init(Bytes32Bytes32Mapping storage self, bytes32 _id) internal {
1570         init(self.innerMapping, _id);
1571     }
1572 
1573     function init(Bytes32AddressMapping  storage self, bytes32 _id) internal {
1574         init(self.innerMapping, _id);
1575     }
1576 
1577     function init(Bytes32UIntBoolMapping  storage self, bytes32 _id) internal {
1578         init(self.innerMapping, _id);
1579     }
1580 
1581     function init(Set storage self, bytes32 _id) internal {
1582         init(self.count, keccak256(abi.encodePacked(_id, "count")));
1583         init(self.indexes, keccak256(abi.encodePacked(_id, "indexes")));
1584         init(self.values, keccak256(abi.encodePacked(_id, "values")));
1585     }
1586 
1587     function init(AddressesSet storage self, bytes32 _id) internal {
1588         init(self.innerSet, _id);
1589     }
1590 
1591     function init(CounterSet storage self, bytes32 _id) internal {
1592         init(self.innerSet, _id);
1593     }
1594 
1595     function init(OrderedSet storage self, bytes32 _id) internal {
1596         init(self.count, keccak256(abi.encodePacked(_id, "uint/count")));
1597         init(self.first, keccak256(abi.encodePacked(_id, "uint/first")));
1598         init(self.last, keccak256(abi.encodePacked(_id, "uint/last")));
1599         init(self.nextValues, keccak256(abi.encodePacked(_id, "uint/next")));
1600         init(self.previousValues, keccak256(abi.encodePacked(_id, "uint/prev")));
1601     }
1602 
1603     function init(OrderedUIntSet storage self, bytes32 _id) internal {
1604         init(self.innerSet, _id);
1605     }
1606 
1607     function init(OrderedAddressesSet storage self, bytes32 _id) internal {
1608         init(self.innerSet, _id);
1609     }
1610 
1611     function init(Bytes32SetMapping storage self, bytes32 _id) internal {
1612         init(self.innerMapping, _id);
1613     }
1614 
1615     function init(AddressesSetMapping storage self, bytes32 _id) internal {
1616         init(self.innerMapping, _id);
1617     }
1618 
1619     function init(UIntSetMapping storage self, bytes32 _id) internal {
1620         init(self.innerMapping, _id);
1621     }
1622 
1623     function init(Bytes32OrderedSetMapping storage self, bytes32 _id) internal {
1624         init(self.innerMapping, _id);
1625     }
1626 
1627     function init(UIntOrderedSetMapping storage self, bytes32 _id) internal {
1628         init(self.innerMapping, _id);
1629     }
1630 
1631     function init(AddressOrderedSetMapping storage self, bytes32 _id) internal {
1632         init(self.innerMapping, _id);
1633     }
1634 
1635     /** `set` operation */
1636 
1637     function set(Config storage self, UInt storage item, uint _value) internal {
1638         self.store.setUInt(self.crate, item.id, _value);
1639     }
1640 
1641     function set(Config storage self, UInt storage item, bytes32 _salt, uint _value) internal {
1642         self.store.setUInt(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
1643     }
1644 
1645     function set(Config storage self, UInt8 storage item, uint8 _value) internal {
1646         self.store.setUInt8(self.crate, item.id, _value);
1647     }
1648 
1649     function set(Config storage self, UInt8 storage item, bytes32 _salt, uint8 _value) internal {
1650         self.store.setUInt8(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
1651     }
1652 
1653     function set(Config storage self, Int storage item, int _value) internal {
1654         self.store.setInt(self.crate, item.id, _value);
1655     }
1656 
1657     function set(Config storage self, Int storage item, bytes32 _salt, int _value) internal {
1658         self.store.setInt(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
1659     }
1660 
1661     function set(Config storage self, Address storage item, address _value) internal {
1662         self.store.setAddress(self.crate, item.id, _value);
1663     }
1664 
1665     function set(Config storage self, Address storage item, bytes32 _salt, address _value) internal {
1666         self.store.setAddress(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
1667     }
1668 
1669     function set(Config storage self, Bool storage item, bool _value) internal {
1670         self.store.setBool(self.crate, item.id, _value);
1671     }
1672 
1673     function set(Config storage self, Bool storage item, bytes32 _salt, bool _value) internal {
1674         self.store.setBool(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
1675     }
1676 
1677     function set(Config storage self, Bytes32 storage item, bytes32 _value) internal {
1678         self.store.setBytes32(self.crate, item.id, _value);
1679     }
1680 
1681     function set(Config storage self, Bytes32 storage item, bytes32 _salt, bytes32 _value) internal {
1682         self.store.setBytes32(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
1683     }
1684 
1685     function set(Config storage self, String storage item, string _value) internal {
1686         self.store.setString(self.crate, item.id, _value);
1687     }
1688 
1689     function set(Config storage self, String storage item, bytes32 _salt, string _value) internal {
1690         self.store.setString(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
1691     }
1692 
1693     function set(Config storage self, Mapping storage item, uint _key, uint _value) internal {
1694         self.store.setUInt(self.crate, keccak256(abi.encodePacked(item.id, _key)), _value);
1695     }
1696 
1697     function set(Config storage self, Mapping storage item, bytes32 _key, bytes32 _value) internal {
1698         self.store.setBytes32(self.crate, keccak256(abi.encodePacked(item.id, _key)), _value);
1699     }
1700 
1701     function set(Config storage self, StringMapping storage item, bytes32 _key, string _value) internal {
1702         set(self, item.id, _key, _value);
1703     }
1704 
1705     function set(Config storage self, AddressUInt8Mapping storage item, bytes32 _key, address _value1, uint8 _value2) internal {
1706         self.store.setAddressUInt8(self.crate, keccak256(abi.encodePacked(item.id, _key)), _value1, _value2);
1707     }
1708 
1709     function set(Config storage self, Mapping storage item, bytes32 _key, bytes32 _key2, bytes32 _value) internal {
1710         set(self, item, keccak256(abi.encodePacked(_key, _key2)), _value);
1711     }
1712 
1713     function set(Config storage self, Mapping storage item, bytes32 _key, bytes32 _key2, bytes32 _key3, bytes32 _value) internal {
1714         set(self, item, keccak256(abi.encodePacked(_key, _key2, _key3)), _value);
1715     }
1716 
1717     function set(Config storage self, Bool storage item, bytes32 _key, bytes32 _key2, bytes32 _key3, bool _value) internal {
1718         set(self, item, keccak256(abi.encodePacked(_key, _key2, _key3)), _value);
1719     }
1720 
1721     function set(Config storage self, UIntAddressMapping storage item, uint _key, address _value) internal {
1722         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
1723     }
1724 
1725     function set(Config storage self, UIntUIntMapping storage item, uint _key, uint _value) internal {
1726         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
1727     }
1728 
1729     function set(Config storage self, UIntBoolMapping storage item, uint _key, bool _value) internal {
1730         set(self, item.innerMapping, bytes32(_key), _value);
1731     }
1732 
1733     function set(Config storage self, UIntEnumMapping storage item, uint _key, uint8 _value) internal {
1734         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
1735     }
1736 
1737     function set(Config storage self, UIntBytes32Mapping storage item, uint _key, bytes32 _value) internal {
1738         set(self, item.innerMapping, bytes32(_key), _value);
1739     }
1740 
1741     function set(Config storage self, Bytes32UIntMapping storage item, bytes32 _key, uint _value) internal {
1742         set(self, item.innerMapping, _key, bytes32(_value));
1743     }
1744 
1745     function set(Config storage self, Bytes32UInt8Mapping storage item, bytes32 _key, uint8 _value) internal {
1746         set(self, item.innerMapping, _key, _value);
1747     }
1748 
1749     function set(Config storage self, Bytes32BoolMapping storage item, bytes32 _key, bool _value) internal {
1750         set(self, item.innerMapping, _key, _value);
1751     }
1752 
1753     function set(Config storage self, Bytes32Bytes32Mapping storage item, bytes32 _key, bytes32 _value) internal {
1754         set(self, item.innerMapping, _key, _value);
1755     }
1756 
1757     function set(Config storage self, Bytes32AddressMapping storage item, bytes32 _key, address _value) internal {
1758         set(self, item.innerMapping, _key, bytes32(_value));
1759     }
1760 
1761     function set(Config storage self, Bytes32UIntBoolMapping storage item, bytes32 _key, uint _key2, bool _value) internal {
1762         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2)), _value);
1763     }
1764 
1765     function set(Config storage self, AddressUIntMapping storage item, address _key, uint _value) internal {
1766         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
1767     }
1768 
1769     function set(Config storage self, AddressBoolMapping storage item, address _key, bool _value) internal {
1770         set(self, item.innerMapping, bytes32(_key), toBytes32(_value));
1771     }
1772 
1773     function set(Config storage self, AddressBytes32Mapping storage item, address _key, bytes32 _value) internal {
1774         set(self, item.innerMapping, bytes32(_key), _value);
1775     }
1776 
1777     function set(Config storage self, AddressAddressMapping storage item, address _key, address _value) internal {
1778         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
1779     }
1780 
1781     function set(Config storage self, AddressAddressUIntMapping storage item, address _key, address _key2, uint _value) internal {
1782         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1783     }
1784 
1785     function set(Config storage self, AddressUIntUIntMapping storage item, address _key, uint _key2, uint _value) internal {
1786         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1787     }
1788 
1789     function set(Config storage self, AddressAddressUInt8Mapping storage item, address _key, address _key2, uint8 _value) internal {
1790         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1791     }
1792 
1793     function set(Config storage self, AddressUIntUInt8Mapping storage item, address _key, uint _key2, uint8 _value) internal {
1794         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1795     }
1796 
1797     function set(Config storage self, AddressBytes32Bytes32Mapping storage item, address _key, bytes32 _key2, bytes32 _value) internal {
1798         set(self, item.innerMapping, bytes32(_key), _key2, _value);
1799     }
1800 
1801     function set(Config storage self, UIntAddressUIntMapping storage item, uint _key, address _key2, uint _value) internal {
1802         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1803     }
1804 
1805     function set(Config storage self, UIntAddressBoolMapping storage item, uint _key, address _key2, bool _value) internal {
1806         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), toBytes32(_value));
1807     }
1808 
1809     function set(Config storage self, UIntAddressAddressMapping storage item, uint _key, address _key2, address _value) internal {
1810         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1811     }
1812 
1813     function set(Config storage self, UIntUIntAddressMapping storage item, uint _key, uint _key2, address _value) internal {
1814         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1815     }
1816 
1817     function set(Config storage self, UIntUIntBytes32Mapping storage item, uint _key, uint _key2, bytes32 _value) internal {
1818         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), _value);
1819     }
1820 
1821     function set(Config storage self, UIntUIntUIntMapping storage item, uint _key, uint _key2, uint _value) internal {
1822         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1823     }
1824 
1825     function set(Config storage self, UIntAddressAddressBoolMapping storage item, uint _key, address _key2, address _key3, bool _value) internal {
1826         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3), _value);
1827     }
1828 
1829     function set(Config storage self, UIntUIntUIntBytes32Mapping storage item, uint _key, uint _key2,  uint _key3, bytes32 _value) internal {
1830         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3), _value);
1831     }
1832 
1833     function set(Config storage self, Bytes32UIntUIntMapping storage item, bytes32 _key, uint _key2, uint _value) internal {
1834         set(self, item.innerMapping, _key, bytes32(_key2), bytes32(_value));
1835     }
1836 
1837     function set(Config storage self, Bytes32UIntUIntUIntMapping storage item, bytes32 _key, uint _key2,  uint _key3, uint _value) internal {
1838         set(self, item.innerMapping, _key, bytes32(_key2), bytes32(_key3), bytes32(_value));
1839     }
1840 
1841     function set(Config storage self, AddressUIntUIntUIntMapping storage item, address _key, uint _key2,  uint _key3, uint _value) internal {
1842         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3), bytes32(_value));
1843     }
1844 
1845     function set(Config storage self, AddressUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, address _value, uint8 _value2) internal {
1846         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2)), _value, _value2);
1847     }
1848 
1849     function set(Config storage self, AddressUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, address _value, uint8 _value2) internal {
1850         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3)), _value, _value2);
1851     }
1852 
1853     function set(Config storage self, AddressUIntUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2,  uint _key3, uint _key4, address _value, uint8 _value2) internal {
1854         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4)), _value, _value2);
1855     }
1856 
1857     function set(Config storage self, AddressUIntUIntUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2,  uint _key3, uint _key4, uint _key5, address _value, uint8 _value2) internal {
1858         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4, _key5)), _value, _value2);
1859     }
1860 
1861     function set(Config storage self, AddressUIntAddressUInt8Mapping storage item, address _key, uint _key2, address _key3, uint8 _value) internal {
1862         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3)), bytes32(_value));
1863     }
1864 
1865     function set(Config storage self, AddressUIntUIntAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, address _key4, uint8 _value) internal {
1866         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4)), bytes32(_value));
1867     }
1868 
1869     function set(Config storage self, AddressUIntUIntUIntAddressUInt8Mapping storage item, address _key, uint _key2,  uint _key3, uint _key4, address _key5, uint8 _value) internal {
1870         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4, _key5)), bytes32(_value));
1871     }
1872 
1873     function set(Config storage self, AddressBytes4BoolMapping storage item, address _key, bytes4 _key2, bool _value) internal {
1874         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), toBytes32(_value));
1875     }
1876 
1877     function set(Config storage self, AddressBytes4Bytes32Mapping storage item, address _key, bytes4 _key2, bytes32 _value) internal {
1878         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), _value);
1879     }
1880 
1881 
1882     /** `add` operation */
1883 
1884     function add(Config storage self, Set storage item, bytes32 _value) internal {
1885         add(self, item, SET_IDENTIFIER, _value);
1886     }
1887 
1888     function add(Config storage self, Set storage item, bytes32 _salt, bytes32 _value) private {
1889         if (includes(self, item, _salt, _value)) {
1890             return;
1891         }
1892         uint newCount = count(self, item, _salt) + 1;
1893         set(self, item.values, _salt, bytes32(newCount), _value);
1894         set(self, item.indexes, _salt, _value, bytes32(newCount));
1895         set(self, item.count, _salt, newCount);
1896     }
1897 
1898     function add(Config storage self, AddressesSet storage item, address _value) internal {
1899         add(self, item.innerSet, bytes32(_value));
1900     }
1901 
1902     function add(Config storage self, CounterSet storage item) internal {
1903         add(self, item.innerSet, bytes32(count(self, item) + 1));
1904     }
1905 
1906     function add(Config storage self, OrderedSet storage item, bytes32 _value) internal {
1907         add(self, item, ORDERED_SET_IDENTIFIER, _value);
1908     }
1909 
1910     function add(Config storage self, OrderedSet storage item, bytes32 _salt, bytes32 _value) private {
1911         if (_value == 0x0) { revert(); }
1912 
1913         if (includes(self, item, _salt, _value)) { return; }
1914 
1915         if (count(self, item, _salt) == 0x0) {
1916             set(self, item.first, _salt, _value);
1917         }
1918 
1919         if (get(self, item.last, _salt) != 0x0) {
1920             _setOrderedSetLink(self, item.nextValues, _salt, get(self, item.last, _salt), _value);
1921             _setOrderedSetLink(self, item.previousValues, _salt, _value, get(self, item.last, _salt));
1922         }
1923 
1924         _setOrderedSetLink(self, item.nextValues, _salt,  _value, 0x0);
1925         set(self, item.last, _salt, _value);
1926         set(self, item.count, _salt, get(self, item.count, _salt) + 1);
1927     }
1928 
1929     function add(Config storage self, Bytes32SetMapping storage item, bytes32 _key, bytes32 _value) internal {
1930         add(self, item.innerMapping, _key, _value);
1931     }
1932 
1933     function add(Config storage self, AddressesSetMapping storage item, bytes32 _key, address _value) internal {
1934         add(self, item.innerMapping, _key, bytes32(_value));
1935     }
1936 
1937     function add(Config storage self, UIntSetMapping storage item, bytes32 _key, uint _value) internal {
1938         add(self, item.innerMapping, _key, bytes32(_value));
1939     }
1940 
1941     function add(Config storage self, Bytes32OrderedSetMapping storage item, bytes32 _key, bytes32 _value) internal {
1942         add(self, item.innerMapping, _key, _value);
1943     }
1944 
1945     function add(Config storage self, UIntOrderedSetMapping storage item, bytes32 _key, uint _value) internal {
1946         add(self, item.innerMapping, _key, bytes32(_value));
1947     }
1948 
1949     function add(Config storage self, AddressOrderedSetMapping storage item, bytes32 _key, address _value) internal {
1950         add(self, item.innerMapping, _key, bytes32(_value));
1951     }
1952 
1953     function add(Config storage self, OrderedUIntSet storage item, uint _value) internal {
1954         add(self, item.innerSet, bytes32(_value));
1955     }
1956 
1957     function add(Config storage self, OrderedAddressesSet storage item, address _value) internal {
1958         add(self, item.innerSet, bytes32(_value));
1959     }
1960 
1961     function set(Config storage self, Set storage item, bytes32 _oldValue, bytes32 _newValue) internal {
1962         set(self, item, SET_IDENTIFIER, _oldValue, _newValue);
1963     }
1964 
1965     function set(Config storage self, Set storage item, bytes32 _salt, bytes32 _oldValue, bytes32 _newValue) private {
1966         if (!includes(self, item, _salt, _oldValue)) {
1967             return;
1968         }
1969         uint index = uint(get(self, item.indexes, _salt, _oldValue));
1970         set(self, item.values, _salt, bytes32(index), _newValue);
1971         set(self, item.indexes, _salt, _newValue, bytes32(index));
1972         set(self, item.indexes, _salt, _oldValue, bytes32(0));
1973     }
1974 
1975     function set(Config storage self, AddressesSet storage item, address _oldValue, address _newValue) internal {
1976         set(self, item.innerSet, bytes32(_oldValue), bytes32(_newValue));
1977     }
1978 
1979     /** `remove` operation */
1980 
1981     function remove(Config storage self, Set storage item, bytes32 _value) internal {
1982         remove(self, item, SET_IDENTIFIER, _value);
1983     }
1984 
1985     function remove(Config storage self, Set storage item, bytes32 _salt, bytes32 _value) private {
1986         if (!includes(self, item, _salt, _value)) {
1987             return;
1988         }
1989         uint lastIndex = count(self, item, _salt);
1990         bytes32 lastValue = get(self, item.values, _salt, bytes32(lastIndex));
1991         uint index = uint(get(self, item.indexes, _salt, _value));
1992         if (index < lastIndex) {
1993             set(self, item.indexes, _salt, lastValue, bytes32(index));
1994             set(self, item.values, _salt, bytes32(index), lastValue);
1995         }
1996         set(self, item.indexes, _salt, _value, bytes32(0));
1997         set(self, item.values, _salt, bytes32(lastIndex), bytes32(0));
1998         set(self, item.count, _salt, lastIndex - 1);
1999     }
2000 
2001     function remove(Config storage self, AddressesSet storage item, address _value) internal {
2002         remove(self, item.innerSet, bytes32(_value));
2003     }
2004 
2005     function remove(Config storage self, CounterSet storage item, uint _value) internal {
2006         remove(self, item.innerSet, bytes32(_value));
2007     }
2008 
2009     function remove(Config storage self, OrderedSet storage item, bytes32 _value) internal {
2010         remove(self, item, ORDERED_SET_IDENTIFIER, _value);
2011     }
2012 
2013     function remove(Config storage self, OrderedSet storage item, bytes32 _salt, bytes32 _value) private {
2014         if (!includes(self, item, _salt, _value)) { return; }
2015 
2016         _setOrderedSetLink(self, item.nextValues, _salt, get(self, item.previousValues, _salt, _value), get(self, item.nextValues, _salt, _value));
2017         _setOrderedSetLink(self, item.previousValues, _salt, get(self, item.nextValues, _salt, _value), get(self, item.previousValues, _salt, _value));
2018 
2019         if (_value == get(self, item.first, _salt)) {
2020             set(self, item.first, _salt, get(self, item.nextValues, _salt, _value));
2021         }
2022 
2023         if (_value == get(self, item.last, _salt)) {
2024             set(self, item.last, _salt, get(self, item.previousValues, _salt, _value));
2025         }
2026 
2027         _deleteOrderedSetLink(self, item.nextValues, _salt, _value);
2028         _deleteOrderedSetLink(self, item.previousValues, _salt, _value);
2029 
2030         set(self, item.count, _salt, get(self, item.count, _salt) - 1);
2031     }
2032 
2033     function remove(Config storage self, OrderedUIntSet storage item, uint _value) internal {
2034         remove(self, item.innerSet, bytes32(_value));
2035     }
2036 
2037     function remove(Config storage self, OrderedAddressesSet storage item, address _value) internal {
2038         remove(self, item.innerSet, bytes32(_value));
2039     }
2040 
2041     function remove(Config storage self, Bytes32SetMapping storage item, bytes32 _key, bytes32 _value) internal {
2042         remove(self, item.innerMapping, _key, _value);
2043     }
2044 
2045     function remove(Config storage self, AddressesSetMapping storage item, bytes32 _key, address _value) internal {
2046         remove(self, item.innerMapping, _key, bytes32(_value));
2047     }
2048 
2049     function remove(Config storage self, UIntSetMapping storage item, bytes32 _key, uint _value) internal {
2050         remove(self, item.innerMapping, _key, bytes32(_value));
2051     }
2052 
2053     function remove(Config storage self, Bytes32OrderedSetMapping storage item, bytes32 _key, bytes32 _value) internal {
2054         remove(self, item.innerMapping, _key, _value);
2055     }
2056 
2057     function remove(Config storage self, UIntOrderedSetMapping storage item, bytes32 _key, uint _value) internal {
2058         remove(self, item.innerMapping, _key, bytes32(_value));
2059     }
2060 
2061     function remove(Config storage self, AddressOrderedSetMapping storage item, bytes32 _key, address _value) internal {
2062         remove(self, item.innerMapping, _key, bytes32(_value));
2063     }
2064 
2065     /** 'copy` operation */
2066 
2067     function copy(Config storage self, Set storage source, Set storage dest) internal {
2068         uint _destCount = count(self, dest);
2069         bytes32[] memory _toRemoveFromDest = new bytes32[](_destCount);
2070         uint _idx;
2071         uint _pointer = 0;
2072         for (_idx = 0; _idx < _destCount; ++_idx) {
2073             bytes32 _destValue = get(self, dest, _idx);
2074             if (!includes(self, source, _destValue)) {
2075                 _toRemoveFromDest[_pointer++] = _destValue;
2076             }
2077         }
2078 
2079         uint _sourceCount = count(self, source);
2080         for (_idx = 0; _idx < _sourceCount; ++_idx) {
2081             add(self, dest, get(self, source, _idx));
2082         }
2083 
2084         for (_idx = 0; _idx < _pointer; ++_idx) {
2085             remove(self, dest, _toRemoveFromDest[_idx]);
2086         }
2087     }
2088 
2089     function copy(Config storage self, AddressesSet storage source, AddressesSet storage dest) internal {
2090         copy(self, source.innerSet, dest.innerSet);
2091     }
2092 
2093     function copy(Config storage self, CounterSet storage source, CounterSet storage dest) internal {
2094         copy(self, source.innerSet, dest.innerSet);
2095     }
2096 
2097     /** `get` operation */
2098 
2099     function get(Config storage self, UInt storage item) internal view returns (uint) {
2100         return self.store.getUInt(self.crate, item.id);
2101     }
2102 
2103     function get(Config storage self, UInt storage item, bytes32 salt) internal view returns (uint) {
2104         return self.store.getUInt(self.crate, keccak256(abi.encodePacked(item.id, salt)));
2105     }
2106 
2107     function get(Config storage self, UInt8 storage item) internal view returns (uint8) {
2108         return self.store.getUInt8(self.crate, item.id);
2109     }
2110 
2111     function get(Config storage self, UInt8 storage item, bytes32 salt) internal view returns (uint8) {
2112         return self.store.getUInt8(self.crate, keccak256(abi.encodePacked(item.id, salt)));
2113     }
2114 
2115     function get(Config storage self, Int storage item) internal view returns (int) {
2116         return self.store.getInt(self.crate, item.id);
2117     }
2118 
2119     function get(Config storage self, Int storage item, bytes32 salt) internal view returns (int) {
2120         return self.store.getInt(self.crate, keccak256(abi.encodePacked(item.id, salt)));
2121     }
2122 
2123     function get(Config storage self, Address storage item) internal view returns (address) {
2124         return self.store.getAddress(self.crate, item.id);
2125     }
2126 
2127     function get(Config storage self, Address storage item, bytes32 salt) internal view returns (address) {
2128         return self.store.getAddress(self.crate, keccak256(abi.encodePacked(item.id, salt)));
2129     }
2130 
2131     function get(Config storage self, Bool storage item) internal view returns (bool) {
2132         return self.store.getBool(self.crate, item.id);
2133     }
2134 
2135     function get(Config storage self, Bool storage item, bytes32 salt) internal view returns (bool) {
2136         return self.store.getBool(self.crate, keccak256(abi.encodePacked(item.id, salt)));
2137     }
2138 
2139     function get(Config storage self, Bytes32 storage item) internal view returns (bytes32) {
2140         return self.store.getBytes32(self.crate, item.id);
2141     }
2142 
2143     function get(Config storage self, Bytes32 storage item, bytes32 salt) internal view returns (bytes32) {
2144         return self.store.getBytes32(self.crate, keccak256(abi.encodePacked(item.id, salt)));
2145     }
2146 
2147     function get(Config storage self, String storage item) internal view returns (string) {
2148         return self.store.getString(self.crate, item.id);
2149     }
2150 
2151     function get(Config storage self, String storage item, bytes32 salt) internal view returns (string) {
2152         return self.store.getString(self.crate, keccak256(abi.encodePacked(item.id, salt)));
2153     }
2154 
2155     function get(Config storage self, Mapping storage item, uint _key) internal view returns (uint) {
2156         return self.store.getUInt(self.crate, keccak256(abi.encodePacked(item.id, _key)));
2157     }
2158 
2159     function get(Config storage self, Mapping storage item, bytes32 _key) internal view returns (bytes32) {
2160         return self.store.getBytes32(self.crate, keccak256(abi.encodePacked(item.id, _key)));
2161     }
2162 
2163     function get(Config storage self, StringMapping storage item, bytes32 _key) internal view returns (string) {
2164         return get(self, item.id, _key);
2165     }
2166 
2167     function get(Config storage self, AddressUInt8Mapping storage item, bytes32 _key) internal view returns (address, uint8) {
2168         return self.store.getAddressUInt8(self.crate, keccak256(abi.encodePacked(item.id, _key)));
2169     }
2170 
2171     function get(Config storage self, Mapping storage item, bytes32 _key, bytes32 _key2) internal view returns (bytes32) {
2172         return get(self, item, keccak256(abi.encodePacked(_key, _key2)));
2173     }
2174 
2175     function get(Config storage self, Mapping storage item, bytes32 _key, bytes32 _key2, bytes32 _key3) internal view returns (bytes32) {
2176         return get(self, item, keccak256(abi.encodePacked(_key, _key2, _key3)));
2177     }
2178 
2179     function get(Config storage self, Bool storage item, bytes32 _key, bytes32 _key2, bytes32 _key3) internal view returns (bool) {
2180         return get(self, item, keccak256(abi.encodePacked(_key, _key2, _key3)));
2181     }
2182 
2183     function get(Config storage self, UIntBoolMapping storage item, uint _key) internal view returns (bool) {
2184         return get(self, item.innerMapping, bytes32(_key));
2185     }
2186 
2187     function get(Config storage self, UIntEnumMapping storage item, uint _key) internal view returns (uint8) {
2188         return uint8(get(self, item.innerMapping, bytes32(_key)));
2189     }
2190 
2191     function get(Config storage self, UIntUIntMapping storage item, uint _key) internal view returns (uint) {
2192         return uint(get(self, item.innerMapping, bytes32(_key)));
2193     }
2194 
2195     function get(Config storage self, UIntAddressMapping storage item, uint _key) internal view returns (address) {
2196         return address(get(self, item.innerMapping, bytes32(_key)));
2197     }
2198 
2199     function get(Config storage self, Bytes32UIntMapping storage item, bytes32 _key) internal view returns (uint) {
2200         return uint(get(self, item.innerMapping, _key));
2201     }
2202 
2203     function get(Config storage self, Bytes32AddressMapping storage item, bytes32 _key) internal view returns (address) {
2204         return address(get(self, item.innerMapping, _key));
2205     }
2206 
2207     function get(Config storage self, Bytes32UInt8Mapping storage item, bytes32 _key) internal view returns (uint8) {
2208         return get(self, item.innerMapping, _key);
2209     }
2210 
2211     function get(Config storage self, Bytes32BoolMapping storage item, bytes32 _key) internal view returns (bool) {
2212         return get(self, item.innerMapping, _key);
2213     }
2214 
2215     function get(Config storage self, Bytes32Bytes32Mapping storage item, bytes32 _key) internal view returns (bytes32) {
2216         return get(self, item.innerMapping, _key);
2217     }
2218 
2219     function get(Config storage self, Bytes32UIntBoolMapping storage item, bytes32 _key, uint _key2) internal view returns (bool) {
2220         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2)));
2221     }
2222 
2223     function get(Config storage self, UIntBytes32Mapping storage item, uint _key) internal view returns (bytes32) {
2224         return get(self, item.innerMapping, bytes32(_key));
2225     }
2226 
2227     function get(Config storage self, AddressUIntMapping storage item, address _key) internal view returns (uint) {
2228         return uint(get(self, item.innerMapping, bytes32(_key)));
2229     }
2230 
2231     function get(Config storage self, AddressBoolMapping storage item, address _key) internal view returns (bool) {
2232         return toBool(get(self, item.innerMapping, bytes32(_key)));
2233     }
2234 
2235     function get(Config storage self, AddressAddressMapping storage item, address _key) internal view returns (address) {
2236         return address(get(self, item.innerMapping, bytes32(_key)));
2237     }
2238 
2239     function get(Config storage self, AddressBytes32Mapping storage item, address _key) internal view returns (bytes32) {
2240         return get(self, item.innerMapping, bytes32(_key));
2241     }
2242 
2243     function get(Config storage self, UIntUIntBytes32Mapping storage item, uint _key, uint _key2) internal view returns (bytes32) {
2244         return get(self, item.innerMapping, bytes32(_key), bytes32(_key2));
2245     }
2246 
2247     function get(Config storage self, UIntUIntAddressMapping storage item, uint _key, uint _key2) internal view returns (address) {
2248         return address(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
2249     }
2250 
2251     function get(Config storage self, UIntUIntUIntMapping storage item, uint _key, uint _key2) internal view returns (uint) {
2252         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
2253     }
2254 
2255     function get(Config storage self, Bytes32UIntUIntMapping storage item, bytes32 _key, uint _key2) internal view returns (uint) {
2256         return uint(get(self, item.innerMapping, _key, bytes32(_key2)));
2257     }
2258 
2259     function get(Config storage self, Bytes32UIntUIntUIntMapping storage item, bytes32 _key, uint _key2, uint _key3) internal view returns (uint) {
2260         return uint(get(self, item.innerMapping, _key, bytes32(_key2), bytes32(_key3)));
2261     }
2262 
2263     function get(Config storage self, AddressAddressUIntMapping storage item, address _key, address _key2) internal view returns (uint) {
2264         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
2265     }
2266 
2267     function get(Config storage self, AddressAddressUInt8Mapping storage item, address _key, address _key2) internal view returns (uint8) {
2268         return uint8(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
2269     }
2270 
2271     function get(Config storage self, AddressUIntUIntMapping storage item, address _key, uint _key2) internal view returns (uint) {
2272         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
2273     }
2274 
2275     function get(Config storage self, AddressUIntUInt8Mapping storage item, address _key, uint _key2) internal view returns (uint) {
2276         return uint8(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
2277     }
2278 
2279     function get(Config storage self, AddressBytes32Bytes32Mapping storage item, address _key, bytes32 _key2) internal view returns (bytes32) {
2280         return get(self, item.innerMapping, bytes32(_key), _key2);
2281     }
2282 
2283     function get(Config storage self, AddressBytes4BoolMapping storage item, address _key, bytes4 _key2) internal view returns (bool) {
2284         return toBool(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
2285     }
2286 
2287     function get(Config storage self, AddressBytes4Bytes32Mapping storage item, address _key, bytes4 _key2) internal view returns (bytes32) {
2288         return get(self, item.innerMapping, bytes32(_key), bytes32(_key2));
2289     }
2290 
2291     function get(Config storage self, UIntAddressUIntMapping storage item, uint _key, address _key2) internal view returns (uint) {
2292         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
2293     }
2294 
2295     function get(Config storage self, UIntAddressBoolMapping storage item, uint _key, address _key2) internal view returns (bool) {
2296         return toBool(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
2297     }
2298 
2299     function get(Config storage self, UIntAddressAddressMapping storage item, uint _key, address _key2) internal view returns (address) {
2300         return address(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
2301     }
2302 
2303     function get(Config storage self, UIntAddressAddressBoolMapping storage item, uint _key, address _key2, address _key3) internal view returns (bool) {
2304         return get(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3));
2305     }
2306 
2307     function get(Config storage self, UIntUIntUIntBytes32Mapping storage item, uint _key, uint _key2, uint _key3) internal view returns (bytes32) {
2308         return get(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3));
2309     }
2310 
2311     function get(Config storage self, AddressUIntUIntUIntMapping storage item, address _key, uint _key2, uint _key3) internal view returns (uint) {
2312         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3)));
2313     }
2314 
2315     function get(Config storage self, AddressUIntStructAddressUInt8Mapping storage item, address _key, uint _key2) internal view returns (address, uint8) {
2316         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2)));
2317     }
2318 
2319     function get(Config storage self, AddressUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3) internal view returns (address, uint8) {
2320         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3)));
2321     }
2322 
2323     function get(Config storage self, AddressUIntUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, uint _key4) internal view returns (address, uint8) {
2324         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4)));
2325     }
2326 
2327     function get(Config storage self, AddressUIntUIntUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, uint _key4, uint _key5) internal view returns (address, uint8) {
2328         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4, _key5)));
2329     }
2330 
2331     function get(Config storage self, AddressUIntAddressUInt8Mapping storage item, address _key, uint _key2, address _key3) internal view returns (uint8) {
2332         return uint8(get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3))));
2333     }
2334 
2335     function get(Config storage self, AddressUIntUIntAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, address _key4) internal view returns (uint8) {
2336         return uint8(get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4))));
2337     }
2338 
2339     function get(Config storage self, AddressUIntUIntUIntAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, uint _key4, address _key5) internal view returns (uint8) {
2340         return uint8(get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4, _key5))));
2341     }
2342 
2343     /** `includes` operation */
2344 
2345     function includes(Config storage self, Set storage item, bytes32 _value) internal view returns (bool) {
2346         return includes(self, item, SET_IDENTIFIER, _value);
2347     }
2348 
2349     function includes(Config storage self, Set storage item, bytes32 _salt, bytes32 _value) internal view returns (bool) {
2350         return get(self, item.indexes, _salt, _value) != 0;
2351     }
2352 
2353     function includes(Config storage self, AddressesSet storage item, address _value) internal view returns (bool) {
2354         return includes(self, item.innerSet, bytes32(_value));
2355     }
2356 
2357     function includes(Config storage self, CounterSet storage item, uint _value) internal view returns (bool) {
2358         return includes(self, item.innerSet, bytes32(_value));
2359     }
2360 
2361     function includes(Config storage self, OrderedSet storage item, bytes32 _value) internal view returns (bool) {
2362         return includes(self, item, ORDERED_SET_IDENTIFIER, _value);
2363     }
2364 
2365     function includes(Config storage self, OrderedSet storage item, bytes32 _salt, bytes32 _value) private view returns (bool) {
2366         return _value != 0x0 && (get(self, item.nextValues, _salt, _value) != 0x0 || get(self, item.last, _salt) == _value);
2367     }
2368 
2369     function includes(Config storage self, OrderedUIntSet storage item, uint _value) internal view returns (bool) {
2370         return includes(self, item.innerSet, bytes32(_value));
2371     }
2372 
2373     function includes(Config storage self, OrderedAddressesSet storage item, address _value) internal view returns (bool) {
2374         return includes(self, item.innerSet, bytes32(_value));
2375     }
2376 
2377     function includes(Config storage self, Bytes32SetMapping storage item, bytes32 _key, bytes32 _value) internal view returns (bool) {
2378         return includes(self, item.innerMapping, _key, _value);
2379     }
2380 
2381     function includes(Config storage self, AddressesSetMapping storage item, bytes32 _key, address _value) internal view returns (bool) {
2382         return includes(self, item.innerMapping, _key, bytes32(_value));
2383     }
2384 
2385     function includes(Config storage self, UIntSetMapping storage item, bytes32 _key, uint _value) internal view returns (bool) {
2386         return includes(self, item.innerMapping, _key, bytes32(_value));
2387     }
2388 
2389     function includes(Config storage self, Bytes32OrderedSetMapping storage item, bytes32 _key, bytes32 _value) internal view returns (bool) {
2390         return includes(self, item.innerMapping, _key, _value);
2391     }
2392 
2393     function includes(Config storage self, UIntOrderedSetMapping storage item, bytes32 _key, uint _value) internal view returns (bool) {
2394         return includes(self, item.innerMapping, _key, bytes32(_value));
2395     }
2396 
2397     function includes(Config storage self, AddressOrderedSetMapping storage item, bytes32 _key, address _value) internal view returns (bool) {
2398         return includes(self, item.innerMapping, _key, bytes32(_value));
2399     }
2400 
2401     function getIndex(Config storage self, Set storage item, bytes32 _value) internal view returns (uint) {
2402         return getIndex(self, item, SET_IDENTIFIER, _value);
2403     }
2404 
2405     function getIndex(Config storage self, Set storage item, bytes32 _salt, bytes32 _value) private view returns (uint) {
2406         return uint(get(self, item.indexes, _salt, _value));
2407     }
2408 
2409     function getIndex(Config storage self, AddressesSet storage item, address _value) internal view returns (uint) {
2410         return getIndex(self, item.innerSet, bytes32(_value));
2411     }
2412 
2413     function getIndex(Config storage self, CounterSet storage item, uint _value) internal view returns (uint) {
2414         return getIndex(self, item.innerSet, bytes32(_value));
2415     }
2416 
2417     function getIndex(Config storage self, Bytes32SetMapping storage item, bytes32 _key, bytes32 _value) internal view returns (uint) {
2418         return getIndex(self, item.innerMapping, _key, _value);
2419     }
2420 
2421     function getIndex(Config storage self, AddressesSetMapping storage item, bytes32 _key, address _value) internal view returns (uint) {
2422         return getIndex(self, item.innerMapping, _key, bytes32(_value));
2423     }
2424 
2425     function getIndex(Config storage self, UIntSetMapping storage item, bytes32 _key, uint _value) internal view returns (uint) {
2426         return getIndex(self, item.innerMapping, _key, bytes32(_value));
2427     }
2428 
2429     /** `count` operation */
2430 
2431     function count(Config storage self, Set storage item) internal view returns (uint) {
2432         return count(self, item, SET_IDENTIFIER);
2433     }
2434 
2435     function count(Config storage self, Set storage item, bytes32 _salt) internal view returns (uint) {
2436         return get(self, item.count, _salt);
2437     }
2438 
2439     function count(Config storage self, AddressesSet storage item) internal view returns (uint) {
2440         return count(self, item.innerSet);
2441     }
2442 
2443     function count(Config storage self, CounterSet storage item) internal view returns (uint) {
2444         return count(self, item.innerSet);
2445     }
2446 
2447     function count(Config storage self, OrderedSet storage item) internal view returns (uint) {
2448         return count(self, item, ORDERED_SET_IDENTIFIER);
2449     }
2450 
2451     function count(Config storage self, OrderedSet storage item, bytes32 _salt) private view returns (uint) {
2452         return get(self, item.count, _salt);
2453     }
2454 
2455     function count(Config storage self, OrderedUIntSet storage item) internal view returns (uint) {
2456         return count(self, item.innerSet);
2457     }
2458 
2459     function count(Config storage self, OrderedAddressesSet storage item) internal view returns (uint) {
2460         return count(self, item.innerSet);
2461     }
2462 
2463     function count(Config storage self, Bytes32SetMapping storage item, bytes32 _key) internal view returns (uint) {
2464         return count(self, item.innerMapping, _key);
2465     }
2466 
2467     function count(Config storage self, AddressesSetMapping storage item, bytes32 _key) internal view returns (uint) {
2468         return count(self, item.innerMapping, _key);
2469     }
2470 
2471     function count(Config storage self, UIntSetMapping storage item, bytes32 _key) internal view returns (uint) {
2472         return count(self, item.innerMapping, _key);
2473     }
2474 
2475     function count(Config storage self, Bytes32OrderedSetMapping storage item, bytes32 _key) internal view returns (uint) {
2476         return count(self, item.innerMapping, _key);
2477     }
2478 
2479     function count(Config storage self, UIntOrderedSetMapping storage item, bytes32 _key) internal view returns (uint) {
2480         return count(self, item.innerMapping, _key);
2481     }
2482 
2483     function count(Config storage self, AddressOrderedSetMapping storage item, bytes32 _key) internal view returns (uint) {
2484         return count(self, item.innerMapping, _key);
2485     }
2486 
2487     function get(Config storage self, Set storage item) internal view returns (bytes32[] result) {
2488         result = get(self, item, SET_IDENTIFIER);
2489     }
2490 
2491     function get(Config storage self, Set storage item, bytes32 _salt) private view returns (bytes32[] result) {
2492         uint valuesCount = count(self, item, _salt);
2493         result = new bytes32[](valuesCount);
2494         for (uint i = 0; i < valuesCount; i++) {
2495             result[i] = get(self, item, _salt, i);
2496         }
2497     }
2498 
2499     function get(Config storage self, AddressesSet storage item) internal view returns (address[]) {
2500         return toAddresses(get(self, item.innerSet));
2501     }
2502 
2503     function get(Config storage self, CounterSet storage item) internal view returns (uint[]) {
2504         return toUInt(get(self, item.innerSet));
2505     }
2506 
2507     function get(Config storage self, Bytes32SetMapping storage item, bytes32 _key) internal view returns (bytes32[]) {
2508         return get(self, item.innerMapping, _key);
2509     }
2510 
2511     function get(Config storage self, AddressesSetMapping storage item, bytes32 _key) internal view returns (address[]) {
2512         return toAddresses(get(self, item.innerMapping, _key));
2513     }
2514 
2515     function get(Config storage self, UIntSetMapping storage item, bytes32 _key) internal view returns (uint[]) {
2516         return toUInt(get(self, item.innerMapping, _key));
2517     }
2518 
2519     function get(Config storage self, Set storage item, uint _index) internal view returns (bytes32) {
2520         return get(self, item, SET_IDENTIFIER, _index);
2521     }
2522 
2523     function get(Config storage self, Set storage item, bytes32 _salt, uint _index) private view returns (bytes32) {
2524         return get(self, item.values, _salt, bytes32(_index+1));
2525     }
2526 
2527     function get(Config storage self, AddressesSet storage item, uint _index) internal view returns (address) {
2528         return address(get(self, item.innerSet, _index));
2529     }
2530 
2531     function get(Config storage self, CounterSet storage item, uint _index) internal view returns (uint) {
2532         return uint(get(self, item.innerSet, _index));
2533     }
2534 
2535     function get(Config storage self, Bytes32SetMapping storage item, bytes32 _key, uint _index) internal view returns (bytes32) {
2536         return get(self, item.innerMapping, _key, _index);
2537     }
2538 
2539     function get(Config storage self, AddressesSetMapping storage item, bytes32 _key, uint _index) internal view returns (address) {
2540         return address(get(self, item.innerMapping, _key, _index));
2541     }
2542 
2543     function get(Config storage self, UIntSetMapping storage item, bytes32 _key, uint _index) internal view returns (uint) {
2544         return uint(get(self, item.innerMapping, _key, _index));
2545     }
2546 
2547     function getNextValue(Config storage self, OrderedSet storage item, bytes32 _value) internal view returns (bytes32) {
2548         return getNextValue(self, item, ORDERED_SET_IDENTIFIER, _value);
2549     }
2550 
2551     function getNextValue(Config storage self, OrderedSet storage item, bytes32 _salt, bytes32 _value) private view returns (bytes32) {
2552         return get(self, item.nextValues, _salt, _value);
2553     }
2554 
2555     function getNextValue(Config storage self, OrderedUIntSet storage item, uint _value) internal view returns (uint) {
2556         return uint(getNextValue(self, item.innerSet, bytes32(_value)));
2557     }
2558 
2559     function getNextValue(Config storage self, OrderedAddressesSet storage item, address _value) internal view returns (address) {
2560         return address(getNextValue(self, item.innerSet, bytes32(_value)));
2561     }
2562 
2563     function getPreviousValue(Config storage self, OrderedSet storage item, bytes32 _value) internal view returns (bytes32) {
2564         return getPreviousValue(self, item, ORDERED_SET_IDENTIFIER, _value);
2565     }
2566 
2567     function getPreviousValue(Config storage self, OrderedSet storage item, bytes32 _salt, bytes32 _value) private view returns (bytes32) {
2568         return get(self, item.previousValues, _salt, _value);
2569     }
2570 
2571     function getPreviousValue(Config storage self, OrderedUIntSet storage item, uint _value) internal view returns (uint) {
2572         return uint(getPreviousValue(self, item.innerSet, bytes32(_value)));
2573     }
2574 
2575     function getPreviousValue(Config storage self, OrderedAddressesSet storage item, address _value) internal view returns (address) {
2576         return address(getPreviousValue(self, item.innerSet, bytes32(_value)));
2577     }
2578 
2579     function toBool(bytes32 self) internal pure returns (bool) {
2580         return self != bytes32(0);
2581     }
2582 
2583     function toBytes32(bool self) internal pure returns (bytes32) {
2584         return bytes32(self ? 1 : 0);
2585     }
2586 
2587     function toAddresses(bytes32[] memory self) internal pure returns (address[]) {
2588         address[] memory result = new address[](self.length);
2589         for (uint i = 0; i < self.length; i++) {
2590             result[i] = address(self[i]);
2591         }
2592         return result;
2593     }
2594 
2595     function toUInt(bytes32[] memory self) internal pure returns (uint[]) {
2596         uint[] memory result = new uint[](self.length);
2597         for (uint i = 0; i < self.length; i++) {
2598             result[i] = uint(self[i]);
2599         }
2600         return result;
2601     }
2602 
2603     function _setOrderedSetLink(Config storage self, Mapping storage link, bytes32 _salt, bytes32 from, bytes32 to) private {
2604         if (from != 0x0) {
2605             set(self, link, _salt, from, to);
2606         }
2607     }
2608 
2609     function _deleteOrderedSetLink(Config storage self, Mapping storage link, bytes32 _salt, bytes32 from) private {
2610         if (from != 0x0) {
2611             set(self, link, _salt, from, 0x0);
2612         }
2613     }
2614 
2615     /** @title Structure to incapsulate and organize iteration through different kinds of collections */
2616     struct Iterator {
2617         uint limit;
2618         uint valuesLeft;
2619         bytes32 currentValue;
2620         bytes32 anchorKey;
2621     }
2622 
2623     function listIterator(Config storage self, OrderedSet storage item, bytes32 anchorKey, bytes32 startValue, uint limit) internal view returns (Iterator) {
2624         if (startValue == 0x0) {
2625             return listIterator(self, item, anchorKey, limit);
2626         }
2627 
2628         return createIterator(anchorKey, startValue, limit);
2629     }
2630 
2631     function listIterator(Config storage self, OrderedUIntSet storage item, bytes32 anchorKey, uint startValue, uint limit) internal view returns (Iterator) {
2632         return listIterator(self, item.innerSet, anchorKey, bytes32(startValue), limit);
2633     }
2634 
2635     function listIterator(Config storage self, OrderedAddressesSet storage item, bytes32 anchorKey, address startValue, uint limit) internal view returns (Iterator) {
2636         return listIterator(self, item.innerSet, anchorKey, bytes32(startValue), limit);
2637     }
2638 
2639     function listIterator(Config storage self, OrderedSet storage item, uint limit) internal view returns (Iterator) {
2640         return listIterator(self, item, ORDERED_SET_IDENTIFIER, limit);
2641     }
2642 
2643     function listIterator(Config storage self, OrderedSet storage item, bytes32 anchorKey, uint limit) internal view returns (Iterator) {
2644         return createIterator(anchorKey, get(self, item.first, anchorKey), limit);
2645     }
2646 
2647     function listIterator(Config storage self, OrderedUIntSet storage item, uint limit) internal view returns (Iterator) {
2648         return listIterator(self, item.innerSet, limit);
2649     }
2650 
2651     function listIterator(Config storage self, OrderedUIntSet storage item, bytes32 anchorKey, uint limit) internal view returns (Iterator) {
2652         return listIterator(self, item.innerSet, anchorKey, limit);
2653     }
2654 
2655     function listIterator(Config storage self, OrderedAddressesSet storage item, uint limit) internal view returns (Iterator) {
2656         return listIterator(self, item.innerSet, limit);
2657     }
2658 
2659     function listIterator(Config storage self, OrderedAddressesSet storage item, uint limit, bytes32 anchorKey) internal view returns (Iterator) {
2660         return listIterator(self, item.innerSet, anchorKey, limit);
2661     }
2662 
2663     function listIterator(Config storage self, OrderedSet storage item) internal view returns (Iterator) {
2664         return listIterator(self, item, ORDERED_SET_IDENTIFIER);
2665     }
2666 
2667     function listIterator(Config storage self, OrderedSet storage item, bytes32 anchorKey) internal view returns (Iterator) {
2668         return listIterator(self, item, anchorKey, get(self, item.count, anchorKey));
2669     }
2670 
2671     function listIterator(Config storage self, OrderedUIntSet storage item) internal view returns (Iterator) {
2672         return listIterator(self, item.innerSet);
2673     }
2674 
2675     function listIterator(Config storage self, OrderedUIntSet storage item, bytes32 anchorKey) internal view returns (Iterator) {
2676         return listIterator(self, item.innerSet, anchorKey);
2677     }
2678 
2679     function listIterator(Config storage self, OrderedAddressesSet storage item) internal view returns (Iterator) {
2680         return listIterator(self, item.innerSet);
2681     }
2682 
2683     function listIterator(Config storage self, OrderedAddressesSet storage item, bytes32 anchorKey) internal view returns (Iterator) {
2684         return listIterator(self, item.innerSet, anchorKey);
2685     }
2686 
2687     function listIterator(Config storage self, Bytes32OrderedSetMapping storage item, bytes32 _key) internal view returns (Iterator) {
2688         return listIterator(self, item.innerMapping, _key);
2689     }
2690 
2691     function listIterator(Config storage self, UIntOrderedSetMapping storage item, bytes32 _key) internal view returns (Iterator) {
2692         return listIterator(self, item.innerMapping, _key);
2693     }
2694 
2695     function listIterator(Config storage self, AddressOrderedSetMapping storage item, bytes32 _key) internal view returns (Iterator) {
2696         return listIterator(self, item.innerMapping, _key);
2697     }
2698 
2699     function createIterator(bytes32 anchorKey, bytes32 startValue, uint limit) internal pure returns (Iterator) {
2700         return Iterator({
2701             currentValue: startValue,
2702             limit: limit,
2703             valuesLeft: limit,
2704             anchorKey: anchorKey
2705         });
2706     }
2707 
2708     function getNextWithIterator(Config storage self, OrderedSet storage item, Iterator iterator) internal view returns (bytes32 _nextValue) {
2709         if (!canGetNextWithIterator(self, item, iterator)) { revert(); }
2710 
2711         _nextValue = iterator.currentValue;
2712 
2713         iterator.currentValue = getNextValue(self, item, iterator.anchorKey, iterator.currentValue);
2714         iterator.valuesLeft -= 1;
2715     }
2716 
2717     function getNextWithIterator(Config storage self, OrderedUIntSet storage item, Iterator iterator) internal view returns (uint _nextValue) {
2718         return uint(getNextWithIterator(self, item.innerSet, iterator));
2719     }
2720 
2721     function getNextWithIterator(Config storage self, OrderedAddressesSet storage item, Iterator iterator) internal view returns (address _nextValue) {
2722         return address(getNextWithIterator(self, item.innerSet, iterator));
2723     }
2724 
2725     function getNextWithIterator(Config storage self, Bytes32OrderedSetMapping storage item, Iterator iterator) internal view returns (bytes32 _nextValue) {
2726         return getNextWithIterator(self, item.innerMapping, iterator);
2727     }
2728 
2729     function getNextWithIterator(Config storage self, UIntOrderedSetMapping storage item, Iterator iterator) internal view returns (uint _nextValue) {
2730         return uint(getNextWithIterator(self, item.innerMapping, iterator));
2731     }
2732 
2733     function getNextWithIterator(Config storage self, AddressOrderedSetMapping storage item, Iterator iterator) internal view returns (address _nextValue) {
2734         return address(getNextWithIterator(self, item.innerMapping, iterator));
2735     }
2736 
2737     function canGetNextWithIterator(Config storage self, OrderedSet storage item, Iterator iterator) internal view returns (bool) {
2738         if (iterator.valuesLeft == 0 || !includes(self, item, iterator.anchorKey, iterator.currentValue)) {
2739             return false;
2740         }
2741 
2742         return true;
2743     }
2744 
2745     function canGetNextWithIterator(Config storage self, OrderedUIntSet storage item, Iterator iterator) internal view returns (bool) {
2746         return canGetNextWithIterator(self, item.innerSet, iterator);
2747     }
2748 
2749     function canGetNextWithIterator(Config storage self, OrderedAddressesSet storage item, Iterator iterator) internal view returns (bool) {
2750         return canGetNextWithIterator(self, item.innerSet, iterator);
2751     }
2752 
2753     function canGetNextWithIterator(Config storage self, Bytes32OrderedSetMapping storage item, Iterator iterator) internal view returns (bool) {
2754         return canGetNextWithIterator(self, item.innerMapping, iterator);
2755     }
2756 
2757     function canGetNextWithIterator(Config storage self, UIntOrderedSetMapping storage item, Iterator iterator) internal view returns (bool) {
2758         return canGetNextWithIterator(self, item.innerMapping, iterator);
2759     }
2760 
2761     function canGetNextWithIterator(Config storage self, AddressOrderedSetMapping storage item, Iterator iterator) internal view returns (bool) {
2762         return canGetNextWithIterator(self, item.innerMapping, iterator);
2763     }
2764 
2765     function count(Iterator iterator) internal pure returns (uint) {
2766         return iterator.valuesLeft;
2767     }
2768 }
2769 
2770 // File: @laborx/solidity-storage-lib/contracts/StorageContractAdapter.sol
2771 
2772 /**
2773  * Copyright 2017–2018, LaborX PTY
2774  * Licensed under the AGPL Version 3 license.
2775  */
2776 
2777 pragma solidity ^0.4.23;
2778 
2779 
2780 
2781 contract StorageContractAdapter {
2782 
2783     StorageInterface.Config internal store;
2784 
2785     constructor(Storage _store, bytes32 _crate) public {
2786         StorageInterface.init(store, _store, _crate);
2787     }
2788 }
2789 
2790 // File: @laborx/solidity-storage-lib/contracts/StorageInterfaceContract.sol
2791 
2792 /**
2793 * Copyright 2017–2018, LaborX PTY
2794 * Licensed under the AGPL Version 3 license.
2795 */
2796 
2797 pragma solidity ^0.4.23;
2798 
2799 
2800 
2801 
2802 contract StorageInterfaceContract is StorageContractAdapter, Storage {
2803 
2804     bytes32 constant SET_IDENTIFIER = "set";
2805     bytes32 constant ORDERED_SET_IDENTIFIER = "ordered_set";
2806 
2807     // Can't use modifier due to a Solidity bug.
2808     function sanityCheck(bytes32 _currentId, bytes32 _newId) internal pure {
2809         if (_currentId != 0 || _newId == 0) {
2810             revert("STORAGE_INTERFACE_CONTRACT_SANITY_CHECK_FAILED");
2811         }
2812     }
2813 
2814     function init(StorageInterface.Config storage self, bytes32 _crate) internal {
2815         self.crate = _crate;
2816     }
2817 
2818     function init(StorageInterface.UInt8 storage self, bytes32 _id) internal {
2819         sanityCheck(self.id, _id);
2820         self.id = _id;
2821     }
2822 
2823     function init(StorageInterface.UInt storage self, bytes32 _id) internal {
2824         sanityCheck(self.id, _id);
2825         self.id = _id;
2826     }
2827 
2828     function init(StorageInterface.Int storage self, bytes32 _id) internal {
2829         sanityCheck(self.id, _id);
2830         self.id = _id;
2831     }
2832 
2833     function init(StorageInterface.Address storage self, bytes32 _id) internal {
2834         sanityCheck(self.id, _id);
2835         self.id = _id;
2836     }
2837 
2838     function init(StorageInterface.Bool storage self, bytes32 _id) internal {
2839         sanityCheck(self.id, _id);
2840         self.id = _id;
2841     }
2842 
2843     function init(StorageInterface.Bytes32 storage self, bytes32 _id) internal {
2844         sanityCheck(self.id, _id);
2845         self.id = _id;
2846     }
2847 
2848     function init(StorageInterface.String storage self, bytes32 _id) internal {
2849         sanityCheck(self.id, _id);
2850         self.id = _id;
2851     }
2852 
2853     function init(StorageInterface.Mapping storage self, bytes32 _id) internal {
2854         sanityCheck(self.id, _id);
2855         self.id = _id;
2856     }
2857 
2858     function init(StorageInterface.StringMapping storage self, bytes32 _id) internal {
2859         init(self.id, _id);
2860     }
2861 
2862     function init(StorageInterface.UIntAddressMapping storage self, bytes32 _id) internal {
2863         init(self.innerMapping, _id);
2864     }
2865 
2866     function init(StorageInterface.UIntUIntMapping storage self, bytes32 _id) internal {
2867         init(self.innerMapping, _id);
2868     }
2869 
2870     function init(StorageInterface.UIntEnumMapping storage self, bytes32 _id) internal {
2871         init(self.innerMapping, _id);
2872     }
2873 
2874     function init(StorageInterface.UIntBoolMapping storage self, bytes32 _id) internal {
2875         init(self.innerMapping, _id);
2876     }
2877 
2878     function init(StorageInterface.UIntBytes32Mapping storage self, bytes32 _id) internal {
2879         init(self.innerMapping, _id);
2880     }
2881 
2882     function init(StorageInterface.AddressAddressUIntMapping storage self, bytes32 _id) internal {
2883         init(self.innerMapping, _id);
2884     }
2885 
2886     function init(StorageInterface.AddressBytes32Bytes32Mapping storage self, bytes32 _id) internal {
2887         init(self.innerMapping, _id);
2888     }
2889 
2890     function init(StorageInterface.AddressUIntUIntMapping storage self, bytes32 _id) internal {
2891         init(self.innerMapping, _id);
2892     }
2893 
2894     function init(StorageInterface.UIntAddressUIntMapping storage self, bytes32 _id) internal {
2895         init(self.innerMapping, _id);
2896     }
2897 
2898     function init(StorageInterface.UIntAddressBoolMapping storage self, bytes32 _id) internal {
2899         init(self.innerMapping, _id);
2900     }
2901 
2902     function init(StorageInterface.UIntUIntAddressMapping storage self, bytes32 _id) internal {
2903         init(self.innerMapping, _id);
2904     }
2905 
2906     function init(StorageInterface.UIntAddressAddressMapping storage self, bytes32 _id) internal {
2907         init(self.innerMapping, _id);
2908     }
2909 
2910     function init(StorageInterface.UIntUIntBytes32Mapping storage self, bytes32 _id) internal {
2911         init(self.innerMapping, _id);
2912     }
2913 
2914     function init(StorageInterface.UIntUIntUIntMapping storage self, bytes32 _id) internal {
2915         init(self.innerMapping, _id);
2916     }
2917 
2918     function init(StorageInterface.UIntAddressAddressBoolMapping storage self, bytes32 _id) internal {
2919         init(self.innerMapping, _id);
2920     }
2921 
2922     function init(StorageInterface.UIntUIntUIntBytes32Mapping storage self, bytes32 _id) internal {
2923         init(self.innerMapping, _id);
2924     }
2925 
2926     function init(StorageInterface.Bytes32UIntUIntMapping storage self, bytes32 _id) internal {
2927         init(self.innerMapping, _id);
2928     }
2929 
2930     function init(StorageInterface.Bytes32UIntUIntUIntMapping storage self, bytes32 _id) internal {
2931         init(self.innerMapping, _id);
2932     }
2933 
2934     function init(StorageInterface.AddressBoolMapping storage self, bytes32 _id) internal {
2935         init(self.innerMapping, _id);
2936     }
2937 
2938     function init(StorageInterface.AddressUInt8Mapping storage self, bytes32 _id) internal {
2939         sanityCheck(self.id, _id);
2940         self.id = _id;
2941     }
2942 
2943     function init(StorageInterface.AddressUIntMapping storage self, bytes32 _id) internal {
2944         init(self.innerMapping, _id);
2945     }
2946 
2947     function init(StorageInterface.AddressBytes32Mapping storage self, bytes32 _id) internal {
2948         init(self.innerMapping, _id);
2949     }
2950 
2951     function init(StorageInterface.AddressAddressMapping  storage self, bytes32 _id) internal {
2952         init(self.innerMapping, _id);
2953     }
2954 
2955     function init(StorageInterface.AddressAddressUInt8Mapping storage self, bytes32 _id) internal {
2956         init(self.innerMapping, _id);
2957     }
2958 
2959     function init(StorageInterface.AddressUIntUInt8Mapping storage self, bytes32 _id) internal {
2960         init(self.innerMapping, _id);
2961     }
2962 
2963     function init(StorageInterface.AddressBytes4BoolMapping storage self, bytes32 _id) internal {
2964         init(self.innerMapping, _id);
2965     }
2966 
2967     function init(StorageInterface.AddressBytes4Bytes32Mapping storage self, bytes32 _id) internal {
2968         init(self.innerMapping, _id);
2969     }
2970 
2971     function init(StorageInterface.AddressUIntUIntUIntMapping storage self, bytes32 _id) internal {
2972         init(self.innerMapping, _id);
2973     }
2974 
2975     function init(StorageInterface.AddressUIntStructAddressUInt8Mapping storage self, bytes32 _id) internal {
2976         init(self.innerMapping, _id);
2977     }
2978 
2979     function init(StorageInterface.AddressUIntUIntStructAddressUInt8Mapping storage self, bytes32 _id) internal {
2980         init(self.innerMapping, _id);
2981     }
2982 
2983     function init(StorageInterface.AddressUIntUIntUIntStructAddressUInt8Mapping storage self, bytes32 _id) internal {
2984         init(self.innerMapping, _id);
2985     }
2986 
2987     function init(StorageInterface.AddressUIntUIntUIntUIntStructAddressUInt8Mapping storage self, bytes32 _id) internal {
2988         init(self.innerMapping, _id);
2989     }
2990 
2991     function init(StorageInterface.AddressUIntAddressUInt8Mapping storage self, bytes32 _id) internal {
2992         init(self.innerMapping, _id);
2993     }
2994 
2995     function init(StorageInterface.AddressUIntUIntAddressUInt8Mapping storage self, bytes32 _id) internal {
2996         init(self.innerMapping, _id);
2997     }
2998 
2999     function init(StorageInterface.AddressUIntUIntUIntAddressUInt8Mapping storage self, bytes32 _id) internal {
3000         init(self.innerMapping, _id);
3001     }
3002 
3003     function init(StorageInterface.Bytes32UIntMapping storage self, bytes32 _id) internal {
3004         init(self.innerMapping, _id);
3005     }
3006 
3007     function init(StorageInterface.Bytes32UInt8Mapping storage self, bytes32 _id) internal {
3008         init(self.innerMapping, _id);
3009     }
3010 
3011     function init(StorageInterface.Bytes32BoolMapping storage self, bytes32 _id) internal {
3012         init(self.innerMapping, _id);
3013     }
3014 
3015     function init(StorageInterface.Bytes32Bytes32Mapping storage self, bytes32 _id) internal {
3016         init(self.innerMapping, _id);
3017     }
3018 
3019     function init(StorageInterface.Bytes32AddressMapping  storage self, bytes32 _id) internal {
3020         init(self.innerMapping, _id);
3021     }
3022 
3023     function init(StorageInterface.Bytes32UIntBoolMapping  storage self, bytes32 _id) internal {
3024         init(self.innerMapping, _id);
3025     }
3026 
3027     function init(StorageInterface.Set storage self, bytes32 _id) internal {
3028         init(self.count, keccak256(abi.encodePacked(_id, "count")));
3029         init(self.indexes, keccak256(abi.encodePacked(_id, "indexes")));
3030         init(self.values, keccak256(abi.encodePacked(_id, "values")));
3031     }
3032 
3033     function init(StorageInterface.AddressesSet storage self, bytes32 _id) internal {
3034         init(self.innerSet, _id);
3035     }
3036 
3037     function init(StorageInterface.CounterSet storage self, bytes32 _id) internal {
3038         init(self.innerSet, _id);
3039     }
3040 
3041     function init(StorageInterface.OrderedSet storage self, bytes32 _id) internal {
3042         init(self.count, keccak256(abi.encodePacked(_id, "uint/count")));
3043         init(self.first, keccak256(abi.encodePacked(_id, "uint/first")));
3044         init(self.last, keccak256(abi.encodePacked(_id, "uint/last")));
3045         init(self.nextValues, keccak256(abi.encodePacked(_id, "uint/next")));
3046         init(self.previousValues, keccak256(abi.encodePacked(_id, "uint/prev")));
3047     }
3048 
3049     function init(StorageInterface.OrderedUIntSet storage self, bytes32 _id) internal {
3050         init(self.innerSet, _id);
3051     }
3052 
3053     function init(StorageInterface.OrderedAddressesSet storage self, bytes32 _id) internal {
3054         init(self.innerSet, _id);
3055     }
3056 
3057     function init(StorageInterface.Bytes32SetMapping storage self, bytes32 _id) internal {
3058         init(self.innerMapping, _id);
3059     }
3060 
3061     function init(StorageInterface.AddressesSetMapping storage self, bytes32 _id) internal {
3062         init(self.innerMapping, _id);
3063     }
3064 
3065     function init(StorageInterface.UIntSetMapping storage self, bytes32 _id) internal {
3066         init(self.innerMapping, _id);
3067     }
3068 
3069     function init(StorageInterface.Bytes32OrderedSetMapping storage self, bytes32 _id) internal {
3070         init(self.innerMapping, _id);
3071     }
3072 
3073     function init(StorageInterface.UIntOrderedSetMapping storage self, bytes32 _id) internal {
3074         init(self.innerMapping, _id);
3075     }
3076 
3077     function init(StorageInterface.AddressOrderedSetMapping storage self, bytes32 _id) internal {
3078         init(self.innerMapping, _id);
3079     }
3080 
3081     /** `set` operation */
3082 
3083     function set(StorageInterface.Config storage self, StorageInterface.UInt storage item, uint _value) internal {
3084         _setUInt(self.crate, item.id, _value);
3085     }
3086 
3087     function set(StorageInterface.Config storage self, StorageInterface.UInt storage item, bytes32 _salt, uint _value) internal {
3088         _setUInt(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
3089     }
3090 
3091     function set(StorageInterface.Config storage self, StorageInterface.UInt8 storage item, uint8 _value) internal {
3092         _setUInt8(self.crate, item.id, _value);
3093     }
3094 
3095     function set(StorageInterface.Config storage self, StorageInterface.UInt8 storage item, bytes32 _salt, uint8 _value) internal {
3096         _setUInt8(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
3097     }
3098 
3099     function set(StorageInterface.Config storage self, StorageInterface.Int storage item, int _value) internal {
3100         _setInt(self.crate, item.id, _value);
3101     }
3102 
3103     function set(StorageInterface.Config storage self, StorageInterface.Int storage item, bytes32 _salt, int _value) internal {
3104         _setInt(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
3105     }
3106 
3107     function set(StorageInterface.Config storage self, StorageInterface.Address storage item, address _value) internal {
3108         _setAddress(self.crate, item.id, _value);
3109     }
3110 
3111     function set(StorageInterface.Config storage self, StorageInterface.Address storage item, bytes32 _salt, address _value) internal {
3112         _setAddress(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
3113     }
3114 
3115     function set(StorageInterface.Config storage self, StorageInterface.Bool storage item, bool _value) internal {
3116         _setBool(self.crate, item.id, _value);
3117     }
3118 
3119     function set(StorageInterface.Config storage self, StorageInterface.Bool storage item, bytes32 _salt, bool _value) internal {
3120         _setBool(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
3121     }
3122 
3123     function set(StorageInterface.Config storage self, StorageInterface.Bytes32 storage item, bytes32 _value) internal {
3124         _setBytes32(self.crate, item.id, _value);
3125     }
3126 
3127     function set(StorageInterface.Config storage self, StorageInterface.Bytes32 storage item, bytes32 _salt, bytes32 _value) internal {
3128         _setBytes32(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
3129     }
3130 
3131     function set(StorageInterface.Config storage self, StorageInterface.String storage item, string _value) internal {
3132         _setString(self.crate, item.id, _value);
3133     }
3134 
3135     function set(StorageInterface.Config storage self, StorageInterface.String storage item, bytes32 _salt, string _value) internal {
3136         _setString(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
3137     }
3138 
3139     function set(StorageInterface.Config storage self, StorageInterface.Mapping storage item, uint _key, uint _value) internal {
3140         _setUInt(self.crate, keccak256(abi.encodePacked(item.id, _key)), _value);
3141     }
3142 
3143     function set(StorageInterface.Config storage self, StorageInterface.Mapping storage item, bytes32 _key, bytes32 _value) internal {
3144         _setBytes32(self.crate, keccak256(abi.encodePacked(item.id, _key)), _value);
3145     }
3146 
3147     function set(StorageInterface.Config storage self, StorageInterface.StringMapping storage item, bytes32 _key, string _value) internal {
3148         set(self, item.id, _key, _value);
3149     }
3150 
3151     function set(StorageInterface.Config storage self, StorageInterface.AddressUInt8Mapping storage item, bytes32 _key, address _value1, uint8 _value2) internal {
3152         _setAddressUInt8(self.crate, keccak256(abi.encodePacked(item.id, _key)), _value1, _value2);
3153     }
3154 
3155     function set(StorageInterface.Config storage self, StorageInterface.Mapping storage item, bytes32 _key, bytes32 _key2, bytes32 _value) internal {
3156         set(self, item, keccak256(abi.encodePacked(_key, _key2)), _value);
3157     }
3158 
3159     function set(StorageInterface.Config storage self, StorageInterface.Mapping storage item, bytes32 _key, bytes32 _key2, bytes32 _key3, bytes32 _value) internal {
3160         set(self, item, keccak256(abi.encodePacked(_key, _key2, _key3)), _value);
3161     }
3162 
3163     function set(StorageInterface.Config storage self, StorageInterface.Bool storage item, bytes32 _key, bytes32 _key2, bytes32 _key3, bool _value) internal {
3164         set(self, item, keccak256(abi.encodePacked(_key, _key2, _key3)), _value);
3165     }
3166 
3167     function set(StorageInterface.Config storage self, StorageInterface.UIntAddressMapping storage item, uint _key, address _value) internal {
3168         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
3169     }
3170 
3171     function set(StorageInterface.Config storage self, StorageInterface.UIntUIntMapping storage item, uint _key, uint _value) internal {
3172         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
3173     }
3174 
3175     function set(StorageInterface.Config storage self, StorageInterface.UIntBoolMapping storage item, uint _key, bool _value) internal {
3176         set(self, item.innerMapping, bytes32(_key), _value);
3177     }
3178 
3179     function set(StorageInterface.Config storage self, StorageInterface.UIntEnumMapping storage item, uint _key, uint8 _value) internal {
3180         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
3181     }
3182 
3183     function set(StorageInterface.Config storage self, StorageInterface.UIntBytes32Mapping storage item, uint _key, bytes32 _value) internal {
3184         set(self, item.innerMapping, bytes32(_key), _value);
3185     }
3186 
3187     function set(StorageInterface.Config storage self, StorageInterface.Bytes32UIntMapping storage item, bytes32 _key, uint _value) internal {
3188         set(self, item.innerMapping, _key, bytes32(_value));
3189     }
3190 
3191     function set(StorageInterface.Config storage self, StorageInterface.Bytes32UInt8Mapping storage item, bytes32 _key, uint8 _value) internal {
3192         set(self, item.innerMapping, _key, _value);
3193     }
3194 
3195     function set(StorageInterface.Config storage self, StorageInterface.Bytes32BoolMapping storage item, bytes32 _key, bool _value) internal {
3196         set(self, item.innerMapping, _key, _value);
3197     }
3198 
3199     function set(StorageInterface.Config storage self, StorageInterface.Bytes32Bytes32Mapping storage item, bytes32 _key, bytes32 _value) internal {
3200         set(self, item.innerMapping, _key, _value);
3201     }
3202 
3203     function set(StorageInterface.Config storage self, StorageInterface.Bytes32AddressMapping storage item, bytes32 _key, address _value) internal {
3204         set(self, item.innerMapping, _key, bytes32(_value));
3205     }
3206 
3207     function set(StorageInterface.Config storage self, StorageInterface.Bytes32UIntBoolMapping storage item, bytes32 _key, uint _key2, bool _value) internal {
3208         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2)), _value);
3209     }
3210 
3211     function set(StorageInterface.Config storage self, StorageInterface.AddressUIntMapping storage item, address _key, uint _value) internal {
3212         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
3213     }
3214 
3215     function set(StorageInterface.Config storage self, StorageInterface.AddressBoolMapping storage item, address _key, bool _value) internal {
3216         set(self, item.innerMapping, bytes32(_key), toBytes32(_value));
3217     }
3218 
3219     function set(StorageInterface.Config storage self, StorageInterface.AddressBytes32Mapping storage item, address _key, bytes32 _value) internal {
3220         set(self, item.innerMapping, bytes32(_key), _value);
3221     }
3222 
3223     function set(StorageInterface.Config storage self, StorageInterface.AddressAddressMapping storage item, address _key, address _value) internal {
3224         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
3225     }
3226 
3227     function set(StorageInterface.Config storage self, StorageInterface.AddressAddressUIntMapping storage item, address _key, address _key2, uint _value) internal {
3228         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
3229     }
3230 
3231     function set(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntMapping storage item, address _key, uint _key2, uint _value) internal {
3232         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
3233     }
3234 
3235     function set(StorageInterface.Config storage self, StorageInterface.AddressAddressUInt8Mapping storage item, address _key, address _key2, uint8 _value) internal {
3236         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
3237     }
3238 
3239     function set(StorageInterface.Config storage self, StorageInterface.AddressUIntUInt8Mapping storage item, address _key, uint _key2, uint8 _value) internal {
3240         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
3241     }
3242 
3243     function set(StorageInterface.Config storage self, StorageInterface.AddressBytes32Bytes32Mapping storage item, address _key, bytes32 _key2, bytes32 _value) internal {
3244         set(self, item.innerMapping, bytes32(_key), _key2, _value);
3245     }
3246 
3247     function set(StorageInterface.Config storage self, StorageInterface.UIntAddressUIntMapping storage item, uint _key, address _key2, uint _value) internal {
3248         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
3249     }
3250 
3251     function set(StorageInterface.Config storage self, StorageInterface.UIntAddressBoolMapping storage item, uint _key, address _key2, bool _value) internal {
3252         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), toBytes32(_value));
3253     }
3254 
3255     function set(StorageInterface.Config storage self, StorageInterface.UIntAddressAddressMapping storage item, uint _key, address _key2, address _value) internal {
3256         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
3257     }
3258 
3259     function set(StorageInterface.Config storage self, StorageInterface.UIntUIntAddressMapping storage item, uint _key, uint _key2, address _value) internal {
3260         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
3261     }
3262 
3263     function set(StorageInterface.Config storage self, StorageInterface.UIntUIntBytes32Mapping storage item, uint _key, uint _key2, bytes32 _value) internal {
3264         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), _value);
3265     }
3266 
3267     function set(StorageInterface.Config storage self, StorageInterface.UIntUIntUIntMapping storage item, uint _key, uint _key2, uint _value) internal {
3268         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
3269     }
3270 
3271     function set(StorageInterface.Config storage self, StorageInterface.UIntAddressAddressBoolMapping storage item, uint _key, address _key2, address _key3, bool _value) internal {
3272         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3), _value);
3273     }
3274 
3275     function set(StorageInterface.Config storage self, StorageInterface.UIntUIntUIntBytes32Mapping storage item, uint _key, uint _key2,  uint _key3, bytes32 _value) internal {
3276         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3), _value);
3277     }
3278 
3279     function set(StorageInterface.Config storage self, StorageInterface.Bytes32UIntUIntMapping storage item, bytes32 _key, uint _key2, uint _value) internal {
3280         set(self, item.innerMapping, _key, bytes32(_key2), bytes32(_value));
3281     }
3282 
3283     function set(StorageInterface.Config storage self, StorageInterface.Bytes32UIntUIntUIntMapping storage item, bytes32 _key, uint _key2,  uint _key3, uint _value) internal {
3284         set(self, item.innerMapping, _key, bytes32(_key2), bytes32(_key3), bytes32(_value));
3285     }
3286 
3287     function set(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntUIntMapping storage item, address _key, uint _key2,  uint _key3, uint _value) internal {
3288         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3), bytes32(_value));
3289     }
3290 
3291     function set(StorageInterface.Config storage self, StorageInterface.AddressUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, address _value, uint8 _value2) internal {
3292         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2)), _value, _value2);
3293     }
3294 
3295     function set(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, address _value, uint8 _value2) internal {
3296         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3)), _value, _value2);
3297     }
3298 
3299     function set(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2,  uint _key3, uint _key4, address _value, uint8 _value2) internal {
3300         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4)), _value, _value2);
3301     }
3302 
3303     function set(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2,  uint _key3, uint _key4, uint _key5, address _value, uint8 _value2) internal {
3304         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4, _key5)), _value, _value2);
3305     }
3306 
3307     function set(StorageInterface.Config storage self, StorageInterface.AddressUIntAddressUInt8Mapping storage item, address _key, uint _key2, address _key3, uint8 _value) internal {
3308         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3)), bytes32(_value));
3309     }
3310 
3311     function set(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, address _key4, uint8 _value) internal {
3312         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4)), bytes32(_value));
3313     }
3314 
3315     function set(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntUIntAddressUInt8Mapping storage item, address _key, uint _key2,  uint _key3, uint _key4, address _key5, uint8 _value) internal {
3316         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4, _key5)), bytes32(_value));
3317     }
3318 
3319     function set(StorageInterface.Config storage self, StorageInterface.AddressBytes4BoolMapping storage item, address _key, bytes4 _key2, bool _value) internal {
3320         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), toBytes32(_value));
3321     }
3322 
3323     function set(StorageInterface.Config storage self, StorageInterface.AddressBytes4Bytes32Mapping storage item, address _key, bytes4 _key2, bytes32 _value) internal {
3324         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), _value);
3325     }
3326 
3327 
3328     /** `add` operation */
3329 
3330     function add(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _value) internal {
3331         add(self, item, SET_IDENTIFIER, _value);
3332     }
3333 
3334     function add(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _salt, bytes32 _value) private {
3335         if (includes(self, item, _salt, _value)) {
3336             return;
3337         }
3338         uint newCount = count(self, item, _salt) + 1;
3339         set(self, item.values, _salt, bytes32(newCount), _value);
3340         set(self, item.indexes, _salt, _value, bytes32(newCount));
3341         set(self, item.count, _salt, newCount);
3342     }
3343 
3344     function add(StorageInterface.Config storage self, StorageInterface.AddressesSet storage item, address _value) internal {
3345         add(self, item.innerSet, bytes32(_value));
3346     }
3347 
3348     function add(StorageInterface.Config storage self, StorageInterface.CounterSet storage item) internal {
3349         add(self, item.innerSet, bytes32(count(self, item) + 1));
3350     }
3351 
3352     function add(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 _value) internal {
3353         add(self, item, ORDERED_SET_IDENTIFIER, _value);
3354     }
3355 
3356     function add(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 _salt, bytes32 _value) private {
3357         if (_value == 0x0) { revert(); }
3358 
3359         if (includes(self, item, _salt, _value)) { return; }
3360 
3361         if (count(self, item, _salt) == 0x0) {
3362             set(self, item.first, _salt, _value);
3363         }
3364 
3365         if (get(self, item.last, _salt) != 0x0) {
3366             _setOrderedSetLink(self, item.nextValues, _salt, get(self, item.last, _salt), _value);
3367             _setOrderedSetLink(self, item.previousValues, _salt, _value, get(self, item.last, _salt));
3368         }
3369 
3370         _setOrderedSetLink(self, item.nextValues, _salt,  _value, 0x0);
3371         set(self, item.last, _salt, _value);
3372         set(self, item.count, _salt, get(self, item.count, _salt) + 1);
3373     }
3374 
3375     function add(StorageInterface.Config storage self, StorageInterface.Bytes32SetMapping storage item, bytes32 _key, bytes32 _value) internal {
3376         add(self, item.innerMapping, _key, _value);
3377     }
3378 
3379     function add(StorageInterface.Config storage self, StorageInterface.AddressesSetMapping storage item, bytes32 _key, address _value) internal {
3380         add(self, item.innerMapping, _key, bytes32(_value));
3381     }
3382 
3383     function add(StorageInterface.Config storage self, StorageInterface.UIntSetMapping storage item, bytes32 _key, uint _value) internal {
3384         add(self, item.innerMapping, _key, bytes32(_value));
3385     }
3386 
3387     function add(StorageInterface.Config storage self, StorageInterface.Bytes32OrderedSetMapping storage item, bytes32 _key, bytes32 _value) internal {
3388         add(self, item.innerMapping, _key, _value);
3389     }
3390 
3391     function add(StorageInterface.Config storage self, StorageInterface.UIntOrderedSetMapping storage item, bytes32 _key, uint _value) internal {
3392         add(self, item.innerMapping, _key, bytes32(_value));
3393     }
3394 
3395     function add(StorageInterface.Config storage self, StorageInterface.AddressOrderedSetMapping storage item, bytes32 _key, address _value) internal {
3396         add(self, item.innerMapping, _key, bytes32(_value));
3397     }
3398 
3399     function add(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item, uint _value) internal {
3400         add(self, item.innerSet, bytes32(_value));
3401     }
3402 
3403     function add(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item, address _value) internal {
3404         add(self, item.innerSet, bytes32(_value));
3405     }
3406 
3407     function set(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _oldValue, bytes32 _newValue) internal {
3408         set(self, item, SET_IDENTIFIER, _oldValue, _newValue);
3409     }
3410 
3411     function set(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _salt, bytes32 _oldValue, bytes32 _newValue) private {
3412         if (!includes(self, item, _salt, _oldValue)) {
3413             return;
3414         }
3415         uint index = uint(get(self, item.indexes, _salt, _oldValue));
3416         set(self, item.values, _salt, bytes32(index), _newValue);
3417         set(self, item.indexes, _salt, _newValue, bytes32(index));
3418         set(self, item.indexes, _salt, _oldValue, bytes32(0));
3419     }
3420 
3421     function set(StorageInterface.Config storage self, StorageInterface.AddressesSet storage item, address _oldValue, address _newValue) internal {
3422         set(self, item.innerSet, bytes32(_oldValue), bytes32(_newValue));
3423     }
3424 
3425     /** `remove` operation */
3426 
3427     function remove(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _value) internal {
3428         remove(self, item, SET_IDENTIFIER, _value);
3429     }
3430 
3431     function remove(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _salt, bytes32 _value) private {
3432         if (!includes(self, item, _salt, _value)) {
3433             return;
3434         }
3435         uint lastIndex = count(self, item, _salt);
3436         bytes32 lastValue = get(self, item.values, _salt, bytes32(lastIndex));
3437         uint index = uint(get(self, item.indexes, _salt, _value));
3438         if (index < lastIndex) {
3439             set(self, item.indexes, _salt, lastValue, bytes32(index));
3440             set(self, item.values, _salt, bytes32(index), lastValue);
3441         }
3442         set(self, item.indexes, _salt, _value, bytes32(0));
3443         set(self, item.values, _salt, bytes32(lastIndex), bytes32(0));
3444         set(self, item.count, _salt, lastIndex - 1);
3445     }
3446 
3447     function remove(StorageInterface.Config storage self, StorageInterface.AddressesSet storage item, address _value) internal {
3448         remove(self, item.innerSet, bytes32(_value));
3449     }
3450 
3451     function remove(StorageInterface.Config storage self, StorageInterface.CounterSet storage item, uint _value) internal {
3452         remove(self, item.innerSet, bytes32(_value));
3453     }
3454 
3455     function remove(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 _value) internal {
3456         remove(self, item, ORDERED_SET_IDENTIFIER, _value);
3457     }
3458 
3459     function remove(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 _salt, bytes32 _value) private {
3460         if (!includes(self, item, _salt, _value)) { return; }
3461 
3462         _setOrderedSetLink(self, item.nextValues, _salt, get(self, item.previousValues, _salt, _value), get(self, item.nextValues, _salt, _value));
3463         _setOrderedSetLink(self, item.previousValues, _salt, get(self, item.nextValues, _salt, _value), get(self, item.previousValues, _salt, _value));
3464 
3465         if (_value == get(self, item.first, _salt)) {
3466             set(self, item.first, _salt, get(self, item.nextValues, _salt, _value));
3467         }
3468 
3469         if (_value == get(self, item.last, _salt)) {
3470             set(self, item.last, _salt, get(self, item.previousValues, _salt, _value));
3471         }
3472 
3473         _deleteOrderedSetLink(self, item.nextValues, _salt, _value);
3474         _deleteOrderedSetLink(self, item.previousValues, _salt, _value);
3475 
3476         set(self, item.count, _salt, get(self, item.count, _salt) - 1);
3477     }
3478 
3479     function remove(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item, uint _value) internal {
3480         remove(self, item.innerSet, bytes32(_value));
3481     }
3482 
3483     function remove(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item, address _value) internal {
3484         remove(self, item.innerSet, bytes32(_value));
3485     }
3486 
3487     function remove(StorageInterface.Config storage self, StorageInterface.Bytes32SetMapping storage item, bytes32 _key, bytes32 _value) internal {
3488         remove(self, item.innerMapping, _key, _value);
3489     }
3490 
3491     function remove(StorageInterface.Config storage self, StorageInterface.AddressesSetMapping storage item, bytes32 _key, address _value) internal {
3492         remove(self, item.innerMapping, _key, bytes32(_value));
3493     }
3494 
3495     function remove(StorageInterface.Config storage self, StorageInterface.UIntSetMapping storage item, bytes32 _key, uint _value) internal {
3496         remove(self, item.innerMapping, _key, bytes32(_value));
3497     }
3498 
3499     function remove(StorageInterface.Config storage self, StorageInterface.Bytes32OrderedSetMapping storage item, bytes32 _key, bytes32 _value) internal {
3500         remove(self, item.innerMapping, _key, _value);
3501     }
3502 
3503     function remove(StorageInterface.Config storage self, StorageInterface.UIntOrderedSetMapping storage item, bytes32 _key, uint _value) internal {
3504         remove(self, item.innerMapping, _key, bytes32(_value));
3505     }
3506 
3507     function remove(StorageInterface.Config storage self, StorageInterface.AddressOrderedSetMapping storage item, bytes32 _key, address _value) internal {
3508         remove(self, item.innerMapping, _key, bytes32(_value));
3509     }
3510 
3511     /** 'copy` operation */
3512 
3513     function copy(StorageInterface.Config storage self, StorageInterface.Set storage source, StorageInterface.Set storage dest) internal {
3514         uint _destCount = count(self, dest);
3515         bytes32[] memory _toRemoveFromDest = new bytes32[](_destCount);
3516         uint _idx;
3517         uint _pointer = 0;
3518         for (_idx = 0; _idx < _destCount; ++_idx) {
3519             bytes32 _destValue = get(self, dest, _idx);
3520             if (!includes(self, source, _destValue)) {
3521                 _toRemoveFromDest[_pointer++] = _destValue;
3522             }
3523         }
3524 
3525         uint _sourceCount = count(self, source);
3526         for (_idx = 0; _idx < _sourceCount; ++_idx) {
3527             add(self, dest, get(self, source, _idx));
3528         }
3529 
3530         for (_idx = 0; _idx < _pointer; ++_idx) {
3531             remove(self, dest, _toRemoveFromDest[_idx]);
3532         }
3533     }
3534 
3535     function copy(StorageInterface.Config storage self, StorageInterface.AddressesSet storage source, StorageInterface.AddressesSet storage dest) internal {
3536         copy(self, source.innerSet, dest.innerSet);
3537     }
3538 
3539     function copy(StorageInterface.Config storage self, StorageInterface.CounterSet storage source, StorageInterface.CounterSet storage dest) internal {
3540         copy(self, source.innerSet, dest.innerSet);
3541     }
3542 
3543     /** `get` operation */
3544 
3545     function get(StorageInterface.Config storage self, StorageInterface.UInt storage item) internal view returns (uint) {
3546         return getUInt(self.crate, item.id);
3547     }
3548 
3549     function get(StorageInterface.Config storage self, StorageInterface.UInt storage item, bytes32 salt) internal view returns (uint) {
3550         return getUInt(self.crate, keccak256(abi.encodePacked(item.id, salt)));
3551     }
3552 
3553     function get(StorageInterface.Config storage self, StorageInterface.UInt8 storage item) internal view returns (uint8) {
3554         return getUInt8(self.crate, item.id);
3555     }
3556 
3557     function get(StorageInterface.Config storage self, StorageInterface.UInt8 storage item, bytes32 salt) internal view returns (uint8) {
3558         return getUInt8(self.crate, keccak256(abi.encodePacked(item.id, salt)));
3559     }
3560 
3561     function get(StorageInterface.Config storage self, StorageInterface.Int storage item) internal view returns (int) {
3562         return getInt(self.crate, item.id);
3563     }
3564 
3565     function get(StorageInterface.Config storage self, StorageInterface.Int storage item, bytes32 salt) internal view returns (int) {
3566         return getInt(self.crate, keccak256(abi.encodePacked(item.id, salt)));
3567     }
3568 
3569     function get(StorageInterface.Config storage self, StorageInterface.Address storage item) internal view returns (address) {
3570         return getAddress(self.crate, item.id);
3571     }
3572 
3573     function get(StorageInterface.Config storage self, StorageInterface.Address storage item, bytes32 salt) internal view returns (address) {
3574         return getAddress(self.crate, keccak256(abi.encodePacked(item.id, salt)));
3575     }
3576 
3577     function get(StorageInterface.Config storage self, StorageInterface.Bool storage item) internal view returns (bool) {
3578         return getBool(self.crate, item.id);
3579     }
3580 
3581     function get(StorageInterface.Config storage self, StorageInterface.Bool storage item, bytes32 salt) internal view returns (bool) {
3582         return getBool(self.crate, keccak256(abi.encodePacked(item.id, salt)));
3583     }
3584 
3585     function get(StorageInterface.Config storage self, StorageInterface.Bytes32 storage item) internal view returns (bytes32) {
3586         return getBytes32(self.crate, item.id);
3587     }
3588 
3589     function get(StorageInterface.Config storage self, StorageInterface.Bytes32 storage item, bytes32 salt) internal view returns (bytes32) {
3590         return getBytes32(self.crate, keccak256(abi.encodePacked(item.id, salt)));
3591     }
3592 
3593     function get(StorageInterface.Config storage self, StorageInterface.String storage item) internal view returns (string) {
3594         return getString(self.crate, item.id);
3595     }
3596 
3597     function get(StorageInterface.Config storage self, StorageInterface.String storage item, bytes32 salt) internal view returns (string) {
3598         return getString(self.crate, keccak256(abi.encodePacked(item.id, salt)));
3599     }
3600 
3601     function get(StorageInterface.Config storage self, StorageInterface.Mapping storage item, uint _key) internal view returns (uint) {
3602         return getUInt(self.crate, keccak256(abi.encodePacked(item.id, _key)));
3603     }
3604 
3605     function get(StorageInterface.Config storage self, StorageInterface.Mapping storage item, bytes32 _key) internal view returns (bytes32) {
3606         return getBytes32(self.crate, keccak256(abi.encodePacked(item.id, _key)));
3607     }
3608 
3609     function get(StorageInterface.Config storage self, StorageInterface.StringMapping storage item, bytes32 _key) internal view returns (string) {
3610         return get(self, item.id, _key);
3611     }
3612 
3613     function get(StorageInterface.Config storage self, StorageInterface.AddressUInt8Mapping storage item, bytes32 _key) internal view returns (address, uint8) {
3614         return getAddressUInt8(self.crate, keccak256(abi.encodePacked(item.id, _key)));
3615     }
3616 
3617     function get(StorageInterface.Config storage self, StorageInterface.Mapping storage item, bytes32 _key, bytes32 _key2) internal view returns (bytes32) {
3618         return get(self, item, keccak256(abi.encodePacked(_key, _key2)));
3619     }
3620 
3621     function get(StorageInterface.Config storage self, StorageInterface.Mapping storage item, bytes32 _key, bytes32 _key2, bytes32 _key3) internal view returns (bytes32) {
3622         return get(self, item, keccak256(abi.encodePacked(_key, _key2, _key3)));
3623     }
3624 
3625     function get(StorageInterface.Config storage self, StorageInterface.Bool storage item, bytes32 _key, bytes32 _key2, bytes32 _key3) internal view returns (bool) {
3626         return get(self, item, keccak256(abi.encodePacked(_key, _key2, _key3)));
3627     }
3628 
3629     function get(StorageInterface.Config storage self, StorageInterface.UIntBoolMapping storage item, uint _key) internal view returns (bool) {
3630         return get(self, item.innerMapping, bytes32(_key));
3631     }
3632 
3633     function get(StorageInterface.Config storage self, StorageInterface.UIntEnumMapping storage item, uint _key) internal view returns (uint8) {
3634         return uint8(get(self, item.innerMapping, bytes32(_key)));
3635     }
3636 
3637     function get(StorageInterface.Config storage self, StorageInterface.UIntUIntMapping storage item, uint _key) internal view returns (uint) {
3638         return uint(get(self, item.innerMapping, bytes32(_key)));
3639     }
3640 
3641     function get(StorageInterface.Config storage self, StorageInterface.UIntAddressMapping storage item, uint _key) internal view returns (address) {
3642         return address(get(self, item.innerMapping, bytes32(_key)));
3643     }
3644 
3645     function get(StorageInterface.Config storage self, StorageInterface.Bytes32UIntMapping storage item, bytes32 _key) internal view returns (uint) {
3646         return uint(get(self, item.innerMapping, _key));
3647     }
3648 
3649     function get(StorageInterface.Config storage self, StorageInterface.Bytes32AddressMapping storage item, bytes32 _key) internal view returns (address) {
3650         return address(get(self, item.innerMapping, _key));
3651     }
3652 
3653     function get(StorageInterface.Config storage self, StorageInterface.Bytes32UInt8Mapping storage item, bytes32 _key) internal view returns (uint8) {
3654         return get(self, item.innerMapping, _key);
3655     }
3656 
3657     function get(StorageInterface.Config storage self, StorageInterface.Bytes32BoolMapping storage item, bytes32 _key) internal view returns (bool) {
3658         return get(self, item.innerMapping, _key);
3659     }
3660 
3661     function get(StorageInterface.Config storage self, StorageInterface.Bytes32Bytes32Mapping storage item, bytes32 _key) internal view returns (bytes32) {
3662         return get(self, item.innerMapping, _key);
3663     }
3664 
3665     function get(StorageInterface.Config storage self, StorageInterface.Bytes32UIntBoolMapping storage item, bytes32 _key, uint _key2) internal view returns (bool) {
3666         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2)));
3667     }
3668 
3669     function get(StorageInterface.Config storage self, StorageInterface.UIntBytes32Mapping storage item, uint _key) internal view returns (bytes32) {
3670         return get(self, item.innerMapping, bytes32(_key));
3671     }
3672 
3673     function get(StorageInterface.Config storage self, StorageInterface.AddressUIntMapping storage item, address _key) internal view returns (uint) {
3674         return uint(get(self, item.innerMapping, bytes32(_key)));
3675     }
3676 
3677     function get(StorageInterface.Config storage self, StorageInterface.AddressBoolMapping storage item, address _key) internal view returns (bool) {
3678         return toBool(get(self, item.innerMapping, bytes32(_key)));
3679     }
3680 
3681     function get(StorageInterface.Config storage self, StorageInterface.AddressAddressMapping storage item, address _key) internal view returns (address) {
3682         return address(get(self, item.innerMapping, bytes32(_key)));
3683     }
3684 
3685     function get(StorageInterface.Config storage self, StorageInterface.AddressBytes32Mapping storage item, address _key) internal view returns (bytes32) {
3686         return get(self, item.innerMapping, bytes32(_key));
3687     }
3688 
3689     function get(StorageInterface.Config storage self, StorageInterface.UIntUIntBytes32Mapping storage item, uint _key, uint _key2) internal view returns (bytes32) {
3690         return get(self, item.innerMapping, bytes32(_key), bytes32(_key2));
3691     }
3692 
3693     function get(StorageInterface.Config storage self, StorageInterface.UIntUIntAddressMapping storage item, uint _key, uint _key2) internal view returns (address) {
3694         return address(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
3695     }
3696 
3697     function get(StorageInterface.Config storage self, StorageInterface.UIntUIntUIntMapping storage item, uint _key, uint _key2) internal view returns (uint) {
3698         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
3699     }
3700 
3701     function get(StorageInterface.Config storage self, StorageInterface.Bytes32UIntUIntMapping storage item, bytes32 _key, uint _key2) internal view returns (uint) {
3702         return uint(get(self, item.innerMapping, _key, bytes32(_key2)));
3703     }
3704 
3705     function get(StorageInterface.Config storage self, StorageInterface.Bytes32UIntUIntUIntMapping storage item, bytes32 _key, uint _key2, uint _key3) internal view returns (uint) {
3706         return uint(get(self, item.innerMapping, _key, bytes32(_key2), bytes32(_key3)));
3707     }
3708 
3709     function get(StorageInterface.Config storage self, StorageInterface.AddressAddressUIntMapping storage item, address _key, address _key2) internal view returns (uint) {
3710         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
3711     }
3712 
3713     function get(StorageInterface.Config storage self, StorageInterface.AddressAddressUInt8Mapping storage item, address _key, address _key2) internal view returns (uint8) {
3714         return uint8(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
3715     }
3716 
3717     function get(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntMapping storage item, address _key, uint _key2) internal view returns (uint) {
3718         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
3719     }
3720 
3721     function get(StorageInterface.Config storage self, StorageInterface.AddressUIntUInt8Mapping storage item, address _key, uint _key2) internal view returns (uint) {
3722         return uint8(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
3723     }
3724 
3725     function get(StorageInterface.Config storage self, StorageInterface.AddressBytes32Bytes32Mapping storage item, address _key, bytes32 _key2) internal view returns (bytes32) {
3726         return get(self, item.innerMapping, bytes32(_key), _key2);
3727     }
3728 
3729     function get(StorageInterface.Config storage self, StorageInterface.AddressBytes4BoolMapping storage item, address _key, bytes4 _key2) internal view returns (bool) {
3730         return toBool(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
3731     }
3732 
3733     function get(StorageInterface.Config storage self, StorageInterface.AddressBytes4Bytes32Mapping storage item, address _key, bytes4 _key2) internal view returns (bytes32) {
3734         return get(self, item.innerMapping, bytes32(_key), bytes32(_key2));
3735     }
3736 
3737     function get(StorageInterface.Config storage self, StorageInterface.UIntAddressUIntMapping storage item, uint _key, address _key2) internal view returns (uint) {
3738         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
3739     }
3740 
3741     function get(StorageInterface.Config storage self, StorageInterface.UIntAddressBoolMapping storage item, uint _key, address _key2) internal view returns (bool) {
3742         return toBool(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
3743     }
3744 
3745     function get(StorageInterface.Config storage self, StorageInterface.UIntAddressAddressMapping storage item, uint _key, address _key2) internal view returns (address) {
3746         return address(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
3747     }
3748 
3749     function get(StorageInterface.Config storage self, StorageInterface.UIntAddressAddressBoolMapping storage item, uint _key, address _key2, address _key3) internal view returns (bool) {
3750         return get(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3));
3751     }
3752 
3753     function get(StorageInterface.Config storage self, StorageInterface.UIntUIntUIntBytes32Mapping storage item, uint _key, uint _key2, uint _key3) internal view returns (bytes32) {
3754         return get(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3));
3755     }
3756 
3757     function get(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntUIntMapping storage item, address _key, uint _key2, uint _key3) internal view returns (uint) {
3758         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3)));
3759     }
3760 
3761     function get(StorageInterface.Config storage self, StorageInterface.AddressUIntStructAddressUInt8Mapping storage item, address _key, uint _key2) internal view returns (address, uint8) {
3762         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2)));
3763     }
3764 
3765     function get(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3) internal view returns (address, uint8) {
3766         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3)));
3767     }
3768 
3769     function get(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, uint _key4) internal view returns (address, uint8) {
3770         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4)));
3771     }
3772 
3773     function get(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, uint _key4, uint _key5) internal view returns (address, uint8) {
3774         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4, _key5)));
3775     }
3776 
3777     function get(StorageInterface.Config storage self, StorageInterface.AddressUIntAddressUInt8Mapping storage item, address _key, uint _key2, address _key3) internal view returns (uint8) {
3778         return uint8(get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3))));
3779     }
3780 
3781     function get(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, address _key4) internal view returns (uint8) {
3782         return uint8(get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4))));
3783     }
3784 
3785     function get(StorageInterface.Config storage self, StorageInterface.AddressUIntUIntUIntAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, uint _key4, address _key5) internal view returns (uint8) {
3786         return uint8(get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4, _key5))));
3787     }
3788 
3789     /** `includes` operation */
3790 
3791     function includes(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _value) internal view returns (bool) {
3792         return includes(self, item, SET_IDENTIFIER, _value);
3793     }
3794 
3795     function includes(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _salt, bytes32 _value) internal view returns (bool) {
3796         return get(self, item.indexes, _salt, _value) != 0;
3797     }
3798 
3799     function includes(StorageInterface.Config storage self, StorageInterface.AddressesSet storage item, address _value) internal view returns (bool) {
3800         return includes(self, item.innerSet, bytes32(_value));
3801     }
3802 
3803     function includes(StorageInterface.Config storage self, StorageInterface.CounterSet storage item, uint _value) internal view returns (bool) {
3804         return includes(self, item.innerSet, bytes32(_value));
3805     }
3806 
3807     function includes(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 _value) internal view returns (bool) {
3808         return includes(self, item, ORDERED_SET_IDENTIFIER, _value);
3809     }
3810 
3811     function includes(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 _salt, bytes32 _value) private view returns (bool) {
3812         return _value != 0x0 && (get(self, item.nextValues, _salt, _value) != 0x0 || get(self, item.last, _salt) == _value);
3813     }
3814 
3815     function includes(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item, uint _value) internal view returns (bool) {
3816         return includes(self, item.innerSet, bytes32(_value));
3817     }
3818 
3819     function includes(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item, address _value) internal view returns (bool) {
3820         return includes(self, item.innerSet, bytes32(_value));
3821     }
3822 
3823     function includes(StorageInterface.Config storage self, StorageInterface.Bytes32SetMapping storage item, bytes32 _key, bytes32 _value) internal view returns (bool) {
3824         return includes(self, item.innerMapping, _key, _value);
3825     }
3826 
3827     function includes(StorageInterface.Config storage self, StorageInterface.AddressesSetMapping storage item, bytes32 _key, address _value) internal view returns (bool) {
3828         return includes(self, item.innerMapping, _key, bytes32(_value));
3829     }
3830 
3831     function includes(StorageInterface.Config storage self, StorageInterface.UIntSetMapping storage item, bytes32 _key, uint _value) internal view returns (bool) {
3832         return includes(self, item.innerMapping, _key, bytes32(_value));
3833     }
3834 
3835     function includes(StorageInterface.Config storage self, StorageInterface.Bytes32OrderedSetMapping storage item, bytes32 _key, bytes32 _value) internal view returns (bool) {
3836         return includes(self, item.innerMapping, _key, _value);
3837     }
3838 
3839     function includes(StorageInterface.Config storage self, StorageInterface.UIntOrderedSetMapping storage item, bytes32 _key, uint _value) internal view returns (bool) {
3840         return includes(self, item.innerMapping, _key, bytes32(_value));
3841     }
3842 
3843     function includes(StorageInterface.Config storage self, StorageInterface.AddressOrderedSetMapping storage item, bytes32 _key, address _value) internal view returns (bool) {
3844         return includes(self, item.innerMapping, _key, bytes32(_value));
3845     }
3846 
3847     function getIndex(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _value) internal view returns (uint) {
3848         return getIndex(self, item, SET_IDENTIFIER, _value);
3849     }
3850 
3851     function getIndex(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _salt, bytes32 _value) private view returns (uint) {
3852         return uint(get(self, item.indexes, _salt, _value));
3853     }
3854 
3855     function getIndex(StorageInterface.Config storage self, StorageInterface.AddressesSet storage item, address _value) internal view returns (uint) {
3856         return getIndex(self, item.innerSet, bytes32(_value));
3857     }
3858 
3859     function getIndex(StorageInterface.Config storage self, StorageInterface.CounterSet storage item, uint _value) internal view returns (uint) {
3860         return getIndex(self, item.innerSet, bytes32(_value));
3861     }
3862 
3863     function getIndex(StorageInterface.Config storage self, StorageInterface.Bytes32SetMapping storage item, bytes32 _key, bytes32 _value) internal view returns (uint) {
3864         return getIndex(self, item.innerMapping, _key, _value);
3865     }
3866 
3867     function getIndex(StorageInterface.Config storage self, StorageInterface.AddressesSetMapping storage item, bytes32 _key, address _value) internal view returns (uint) {
3868         return getIndex(self, item.innerMapping, _key, bytes32(_value));
3869     }
3870 
3871     function getIndex(StorageInterface.Config storage self, StorageInterface.UIntSetMapping storage item, bytes32 _key, uint _value) internal view returns (uint) {
3872         return getIndex(self, item.innerMapping, _key, bytes32(_value));
3873     }
3874 
3875     /** `count` operation */
3876 
3877     function count(StorageInterface.Config storage self, StorageInterface.Set storage item) internal view returns (uint) {
3878         return count(self, item, SET_IDENTIFIER);
3879     }
3880 
3881     function count(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _salt) internal view returns (uint) {
3882         return get(self, item.count, _salt);
3883     }
3884 
3885     function count(StorageInterface.Config storage self, StorageInterface.AddressesSet storage item) internal view returns (uint) {
3886         return count(self, item.innerSet);
3887     }
3888 
3889     function count(StorageInterface.Config storage self, StorageInterface.CounterSet storage item) internal view returns (uint) {
3890         return count(self, item.innerSet);
3891     }
3892 
3893     function count(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item) internal view returns (uint) {
3894         return count(self, item, ORDERED_SET_IDENTIFIER);
3895     }
3896 
3897     function count(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 _salt) private view returns (uint) {
3898         return get(self, item.count, _salt);
3899     }
3900 
3901     function count(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item) internal view returns (uint) {
3902         return count(self, item.innerSet);
3903     }
3904 
3905     function count(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item) internal view returns (uint) {
3906         return count(self, item.innerSet);
3907     }
3908 
3909     function count(StorageInterface.Config storage self, StorageInterface.Bytes32SetMapping storage item, bytes32 _key) internal view returns (uint) {
3910         return count(self, item.innerMapping, _key);
3911     }
3912 
3913     function count(StorageInterface.Config storage self, StorageInterface.AddressesSetMapping storage item, bytes32 _key) internal view returns (uint) {
3914         return count(self, item.innerMapping, _key);
3915     }
3916 
3917     function count(StorageInterface.Config storage self, StorageInterface.UIntSetMapping storage item, bytes32 _key) internal view returns (uint) {
3918         return count(self, item.innerMapping, _key);
3919     }
3920 
3921     function count(StorageInterface.Config storage self, StorageInterface.Bytes32OrderedSetMapping storage item, bytes32 _key) internal view returns (uint) {
3922         return count(self, item.innerMapping, _key);
3923     }
3924 
3925     function count(StorageInterface.Config storage self, StorageInterface.UIntOrderedSetMapping storage item, bytes32 _key) internal view returns (uint) {
3926         return count(self, item.innerMapping, _key);
3927     }
3928 
3929     function count(StorageInterface.Config storage self, StorageInterface.AddressOrderedSetMapping storage item, bytes32 _key) internal view returns (uint) {
3930         return count(self, item.innerMapping, _key);
3931     }
3932 
3933     function get(StorageInterface.Config storage self, StorageInterface.Set storage item) internal view returns (bytes32[] result) {
3934         result = get(self, item, SET_IDENTIFIER);
3935     }
3936 
3937     function get(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _salt) private view returns (bytes32[] result) {
3938         uint valuesCount = count(self, item, _salt);
3939         result = new bytes32[](valuesCount);
3940         for (uint i = 0; i < valuesCount; i++) {
3941             result[i] = get(self, item, _salt, i);
3942         }
3943     }
3944 
3945     function get(StorageInterface.Config storage self, StorageInterface.AddressesSet storage item) internal view returns (address[]) {
3946         return toAddresses(get(self, item.innerSet));
3947     }
3948 
3949     function get(StorageInterface.Config storage self, StorageInterface.CounterSet storage item) internal view returns (uint[]) {
3950         return toUInt(get(self, item.innerSet));
3951     }
3952 
3953     function get(StorageInterface.Config storage self, StorageInterface.Bytes32SetMapping storage item, bytes32 _key) internal view returns (bytes32[]) {
3954         return get(self, item.innerMapping, _key);
3955     }
3956 
3957     function get(StorageInterface.Config storage self, StorageInterface.AddressesSetMapping storage item, bytes32 _key) internal view returns (address[]) {
3958         return toAddresses(get(self, item.innerMapping, _key));
3959     }
3960 
3961     function get(StorageInterface.Config storage self, StorageInterface.UIntSetMapping storage item, bytes32 _key) internal view returns (uint[]) {
3962         return toUInt(get(self, item.innerMapping, _key));
3963     }
3964 
3965     function get(StorageInterface.Config storage self, StorageInterface.Set storage item, uint _index) internal view returns (bytes32) {
3966         return get(self, item, SET_IDENTIFIER, _index);
3967     }
3968 
3969     function get(StorageInterface.Config storage self, StorageInterface.Set storage item, bytes32 _salt, uint _index) private view returns (bytes32) {
3970         return get(self, item.values, _salt, bytes32(_index+1));
3971     }
3972 
3973     function get(StorageInterface.Config storage self, StorageInterface.AddressesSet storage item, uint _index) internal view returns (address) {
3974         return address(get(self, item.innerSet, _index));
3975     }
3976 
3977     function get(StorageInterface.Config storage self, StorageInterface.CounterSet storage item, uint _index) internal view returns (uint) {
3978         return uint(get(self, item.innerSet, _index));
3979     }
3980 
3981     function get(StorageInterface.Config storage self, StorageInterface.Bytes32SetMapping storage item, bytes32 _key, uint _index) internal view returns (bytes32) {
3982         return get(self, item.innerMapping, _key, _index);
3983     }
3984 
3985     function get(StorageInterface.Config storage self, StorageInterface.AddressesSetMapping storage item, bytes32 _key, uint _index) internal view returns (address) {
3986         return address(get(self, item.innerMapping, _key, _index));
3987     }
3988 
3989     function get(StorageInterface.Config storage self, StorageInterface.UIntSetMapping storage item, bytes32 _key, uint _index) internal view returns (uint) {
3990         return uint(get(self, item.innerMapping, _key, _index));
3991     }
3992 
3993     function getNextValue(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 _value) internal view returns (bytes32) {
3994         return getNextValue(self, item, ORDERED_SET_IDENTIFIER, _value);
3995     }
3996 
3997     function getNextValue(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 _salt, bytes32 _value) private view returns (bytes32) {
3998         return get(self, item.nextValues, _salt, _value);
3999     }
4000 
4001     function getNextValue(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item, uint _value) internal view returns (uint) {
4002         return uint(getNextValue(self, item.innerSet, bytes32(_value)));
4003     }
4004 
4005     function getNextValue(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item, address _value) internal view returns (address) {
4006         return address(getNextValue(self, item.innerSet, bytes32(_value)));
4007     }
4008 
4009     function getPreviousValue(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 _value) internal view returns (bytes32) {
4010         return getPreviousValue(self, item, ORDERED_SET_IDENTIFIER, _value);
4011     }
4012 
4013     function getPreviousValue(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 _salt, bytes32 _value) private view returns (bytes32) {
4014         return get(self, item.previousValues, _salt, _value);
4015     }
4016 
4017     function getPreviousValue(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item, uint _value) internal view returns (uint) {
4018         return uint(getPreviousValue(self, item.innerSet, bytes32(_value)));
4019     }
4020 
4021     function getPreviousValue(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item, address _value) internal view returns (address) {
4022         return address(getPreviousValue(self, item.innerSet, bytes32(_value)));
4023     }
4024 
4025     function toBool(bytes32 self) internal pure returns (bool) {
4026         return self != bytes32(0);
4027     }
4028 
4029     function toBytes32(bool self) internal pure returns (bytes32) {
4030         return bytes32(self ? 1 : 0);
4031     }
4032 
4033     function toAddresses(bytes32[] memory self) internal pure returns (address[]) {
4034         address[] memory result = new address[](self.length);
4035         for (uint i = 0; i < self.length; i++) {
4036             result[i] = address(self[i]);
4037         }
4038         return result;
4039     }
4040 
4041     function toUInt(bytes32[] memory self) internal pure returns (uint[]) {
4042         uint[] memory result = new uint[](self.length);
4043         for (uint i = 0; i < self.length; i++) {
4044             result[i] = uint(self[i]);
4045         }
4046         return result;
4047     }
4048 
4049     function _setOrderedSetLink(StorageInterface.Config storage self, StorageInterface.Mapping storage link, bytes32 _salt, bytes32 from, bytes32 to) private {
4050         if (from != 0x0) {
4051             set(self, link, _salt, from, to);
4052         }
4053     }
4054 
4055     function _deleteOrderedSetLink(StorageInterface.Config storage self, StorageInterface.Mapping storage link, bytes32 _salt, bytes32 from) private {
4056         if (from != 0x0) {
4057             set(self, link, _salt, from, 0x0);
4058         }
4059     }
4060 
4061     /* ITERABLE */
4062 
4063     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 anchorKey, bytes32 startValue, uint limit) internal view returns (StorageInterface.Iterator) {
4064         if (startValue == 0x0) {
4065             return listIterator(self, item, anchorKey, limit);
4066         }
4067 
4068         return createIterator(anchorKey, startValue, limit);
4069     }
4070 
4071     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item, bytes32 anchorKey, uint startValue, uint limit) internal view returns (StorageInterface.Iterator) {
4072         return listIterator(self, item.innerSet, anchorKey, bytes32(startValue), limit);
4073     }
4074 
4075     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item, bytes32 anchorKey, address startValue, uint limit) internal view returns (StorageInterface.Iterator) {
4076         return listIterator(self, item.innerSet, anchorKey, bytes32(startValue), limit);
4077     }
4078 
4079     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, uint limit) internal view returns (StorageInterface.Iterator) {
4080         return listIterator(self, item, ORDERED_SET_IDENTIFIER, limit);
4081     }
4082 
4083     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 anchorKey, uint limit) internal view returns (StorageInterface.Iterator) {
4084         return createIterator(anchorKey, get(self, item.first, anchorKey), limit);
4085     }
4086 
4087     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item, uint limit) internal view returns (StorageInterface.Iterator) {
4088         return listIterator(self, item.innerSet, limit);
4089     }
4090 
4091     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item, bytes32 anchorKey, uint limit) internal view returns (StorageInterface.Iterator) {
4092         return listIterator(self, item.innerSet, anchorKey, limit);
4093     }
4094 
4095     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item, uint limit) internal view returns (StorageInterface.Iterator) {
4096         return listIterator(self, item.innerSet, limit);
4097     }
4098 
4099     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item, uint limit, bytes32 anchorKey) internal view returns (StorageInterface.Iterator) {
4100         return listIterator(self, item.innerSet, anchorKey, limit);
4101     }
4102 
4103     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item) internal view returns (StorageInterface.Iterator) {
4104         return listIterator(self, item, ORDERED_SET_IDENTIFIER);
4105     }
4106 
4107     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, bytes32 anchorKey) internal view returns (StorageInterface.Iterator) {
4108         return listIterator(self, item, anchorKey, get(self, item.count, anchorKey));
4109     }
4110 
4111     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item) internal view returns (StorageInterface.Iterator) {
4112         return listIterator(self, item.innerSet);
4113     }
4114 
4115     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item, bytes32 anchorKey) internal view returns (StorageInterface.Iterator) {
4116         return listIterator(self, item.innerSet, anchorKey);
4117     }
4118 
4119     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item) internal view returns (StorageInterface.Iterator) {
4120         return listIterator(self, item.innerSet);
4121     }
4122 
4123     function listIterator(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item, bytes32 anchorKey) internal view returns (StorageInterface.Iterator) {
4124         return listIterator(self, item.innerSet, anchorKey);
4125     }
4126 
4127     function listIterator(StorageInterface.Config storage self, StorageInterface.Bytes32OrderedSetMapping storage item, bytes32 _key) internal view returns (StorageInterface.Iterator) {
4128         return listIterator(self, item.innerMapping, _key);
4129     }
4130 
4131     function listIterator(StorageInterface.Config storage self, StorageInterface.UIntOrderedSetMapping storage item, bytes32 _key) internal view returns (StorageInterface.Iterator) {
4132         return listIterator(self, item.innerMapping, _key);
4133     }
4134 
4135     function listIterator(StorageInterface.Config storage self, StorageInterface.AddressOrderedSetMapping storage item, bytes32 _key) internal view returns (StorageInterface.Iterator) {
4136         return listIterator(self, item.innerMapping, _key);
4137     }
4138 
4139     function createIterator(bytes32 anchorKey, bytes32 startValue, uint limit) internal pure returns (StorageInterface.Iterator) {
4140         return StorageInterface.Iterator({
4141             currentValue: startValue,
4142             limit: limit,
4143             valuesLeft: limit,
4144             anchorKey: anchorKey
4145         });
4146     }
4147 
4148     function getNextWithIterator(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, StorageInterface.Iterator iterator) internal view returns (bytes32 _nextValue) {
4149         if (!canGetNextWithIterator(self, item, iterator)) { revert(); }
4150 
4151         _nextValue = iterator.currentValue;
4152 
4153         iterator.currentValue = getNextValue(self, item, iterator.anchorKey, iterator.currentValue);
4154         iterator.valuesLeft -= 1;
4155     }
4156 
4157     function getNextWithIterator(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item, StorageInterface.Iterator iterator) internal view returns (uint _nextValue) {
4158         return uint(getNextWithIterator(self, item.innerSet, iterator));
4159     }
4160 
4161     function getNextWithIterator(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item, StorageInterface.Iterator iterator) internal view returns (address _nextValue) {
4162         return address(getNextWithIterator(self, item.innerSet, iterator));
4163     }
4164 
4165     function getNextWithIterator(StorageInterface.Config storage self, StorageInterface.Bytes32OrderedSetMapping storage item, StorageInterface.Iterator iterator) internal view returns (bytes32 _nextValue) {
4166         return getNextWithIterator(self, item.innerMapping, iterator);
4167     }
4168 
4169     function getNextWithIterator(StorageInterface.Config storage self, StorageInterface.UIntOrderedSetMapping storage item, StorageInterface.Iterator iterator) internal view returns (uint _nextValue) {
4170         return uint(getNextWithIterator(self, item.innerMapping, iterator));
4171     }
4172 
4173     function getNextWithIterator(StorageInterface.Config storage self, StorageInterface.AddressOrderedSetMapping storage item, StorageInterface.Iterator iterator) internal view returns (address _nextValue) {
4174         return address(getNextWithIterator(self, item.innerMapping, iterator));
4175     }
4176 
4177     function canGetNextWithIterator(StorageInterface.Config storage self, StorageInterface.OrderedSet storage item, StorageInterface.Iterator iterator) internal view returns (bool) {
4178         if (iterator.valuesLeft == 0 || !includes(self, item, iterator.anchorKey, iterator.currentValue)) {
4179             return false;
4180         }
4181 
4182         return true;
4183     }
4184 
4185     function canGetNextWithIterator(StorageInterface.Config storage self, StorageInterface.OrderedUIntSet storage item, StorageInterface.Iterator iterator) internal view returns (bool) {
4186         return canGetNextWithIterator(self, item.innerSet, iterator);
4187     }
4188 
4189     function canGetNextWithIterator(StorageInterface.Config storage self, StorageInterface.OrderedAddressesSet storage item, StorageInterface.Iterator iterator) internal view returns (bool) {
4190         return canGetNextWithIterator(self, item.innerSet, iterator);
4191     }
4192 
4193     function canGetNextWithIterator(StorageInterface.Config storage self, StorageInterface.Bytes32OrderedSetMapping storage item, StorageInterface.Iterator iterator) internal view returns (bool) {
4194         return canGetNextWithIterator(self, item.innerMapping, iterator);
4195     }
4196 
4197     function canGetNextWithIterator(StorageInterface.Config storage self, StorageInterface.UIntOrderedSetMapping storage item, StorageInterface.Iterator iterator) internal view returns (bool) {
4198         return canGetNextWithIterator(self, item.innerMapping, iterator);
4199     }
4200 
4201     function canGetNextWithIterator(StorageInterface.Config storage self, StorageInterface.AddressOrderedSetMapping storage item, StorageInterface.Iterator iterator) internal view returns (bool) {
4202         return canGetNextWithIterator(self, item.innerMapping, iterator);
4203     }
4204 
4205     function count(StorageInterface.Iterator iterator) internal pure returns (uint) {
4206         return iterator.valuesLeft;
4207     }
4208 }
4209 
4210 // File: @laborx/solidity-shared-lib/contracts/BaseByzantiumRouter.sol
4211 
4212 /**
4213  * Copyright 2017–2018, LaborX PTY
4214  * Licensed under the AGPL Version 3 license.
4215  */
4216 
4217 pragma solidity ^0.4.11;
4218 
4219 
4220 /// @title Routing contract that is able to provide a way for delegating invocations with dynamic destination address.
4221 contract BaseByzantiumRouter {
4222 
4223     function() external payable {
4224         address _implementation = implementation();
4225 
4226         assembly {
4227             let calldataMemoryOffset := mload(0x40)
4228             mstore(0x40, add(calldataMemoryOffset, calldatasize))
4229             calldatacopy(calldataMemoryOffset, 0x0, calldatasize)
4230             let r := delegatecall(sub(gas, 10000), _implementation, calldataMemoryOffset, calldatasize, 0, 0)
4231 
4232             let returndataMemoryOffset := mload(0x40)
4233             mstore(0x40, add(returndataMemoryOffset, returndatasize))
4234             returndatacopy(returndataMemoryOffset, 0x0, returndatasize)
4235 
4236             switch r
4237             case 1 {
4238                 return(returndataMemoryOffset, returndatasize)
4239             }
4240             default {
4241                 revert(0, 0)
4242             }
4243         }
4244     }
4245 
4246     /// @notice Returns destination address for future calls
4247     /// @dev abstract definition. should be implemented in sibling contracts
4248     /// @return destination address
4249     function implementation() internal view returns (address);
4250 }
4251 
4252 // File: @laborx/solidity-storage-lib/contracts/StorageAdapter.sol
4253 
4254 /**
4255  * Copyright 2017–2018, LaborX PTY
4256  * Licensed under the AGPL Version 3 license.
4257  */
4258 
4259 pragma solidity ^0.4.23;
4260 
4261 
4262 
4263 contract StorageAdapter {
4264 
4265     using StorageInterface for *;
4266 
4267     StorageInterface.Config internal store;
4268 
4269     constructor(Storage _store, bytes32 _crate) public {
4270         store.init(_store, _crate);
4271     }
4272 }
4273 
4274 // File: contracts/ChronoBankPlatformBackendProvider.sol
4275 
4276 /**
4277  * Copyright 2017–2018, LaborX PTY
4278  * Licensed under the AGPL Version 3 license.
4279  */
4280 
4281 pragma solidity ^0.4.24;
4282 
4283 
4284 
4285 
4286 contract ChronoBankPlatformBackendProvider is Owned {
4287 
4288     ChronoBankPlatformInterface public platformBackend;
4289 
4290     constructor(ChronoBankPlatformInterface _platformBackend) public {
4291         updatePlatformBackend(_platformBackend);
4292     }
4293 
4294     function updatePlatformBackend(ChronoBankPlatformInterface _updatedPlatformBackend)
4295     public
4296     onlyContractOwner
4297     returns (bool)
4298     {
4299         require(address(_updatedPlatformBackend) != 0x0, "PLATFORM_BACKEND_PROVIDER_INVALID_PLATFORM_ADDRESS");
4300 
4301         platformBackend = _updatedPlatformBackend;
4302         return true;
4303     }
4304 }
4305 
4306 // File: contracts/ChronoBankPlatformRouter.sol
4307 
4308 /**
4309  * Copyright 2017–2018, LaborX PTY
4310  * Licensed under the AGPL Version 3 license.
4311  */
4312 
4313 pragma solidity ^0.4.24;
4314 
4315 
4316 
4317 
4318 
4319 
4320 
4321 contract ChronoBankPlatformRouterCore {
4322     address internal platformBackendProvider;
4323 }
4324 
4325 
4326 contract ChronoBankPlatformCore {
4327 
4328     bytes32 constant CHRONOBANK_PLATFORM_CRATE = "ChronoBankPlatform";
4329 
4330     /// @dev Asset's owner id
4331     StorageInterface.Bytes32UIntMapping internal assetOwnerIdStorage;
4332     /// @dev Asset's total supply
4333     StorageInterface.Bytes32UIntMapping internal assetTotalSupply;
4334     /// @dev Asset's name, for information purposes.
4335     StorageInterface.StringMapping internal assetName;
4336     /// @dev Asset's description, for information purposes.
4337     StorageInterface.StringMapping internal assetDescription;
4338     /// @dev Indicates if asset have dynamic or fixed supply
4339     StorageInterface.Bytes32BoolMapping internal assetIsReissuable;
4340     /// @dev Proposed number of decimals
4341     StorageInterface.Bytes32UInt8Mapping internal assetBaseUnit;
4342     /// @dev Holders wallets partowners
4343     StorageInterface.Bytes32UIntBoolMapping internal assetPartowners;
4344     /// @dev Holders wallets balance
4345     StorageInterface.Bytes32UIntUIntMapping internal assetWalletBalance;
4346     /// @dev Holders wallets allowance
4347     StorageInterface.Bytes32UIntUIntUIntMapping internal assetWalletAllowance;
4348     /// @dev Block number from which asset can be used
4349     StorageInterface.Bytes32UIntMapping internal assetBlockNumber;
4350 
4351     /// @dev Iterable mapping pattern is used for holders.
4352     StorageInterface.UInt internal holdersCountStorage;
4353     /// @dev Current address of the holder.
4354     StorageInterface.UIntAddressMapping internal holdersAddressStorage;
4355     /// @dev Addresses that are trusted with recovery proocedure.
4356     StorageInterface.UIntAddressBoolMapping internal holdersTrustStorage;
4357     /// @dev This is an access address mapping. Many addresses may have access to a single holder.
4358     StorageInterface.AddressUIntMapping internal holderIndexStorage;
4359 
4360     /// @dev List of symbols that exist in a platform
4361     StorageInterface.Set internal symbolsStorage;
4362 
4363     /// @dev Asset symbol to asset proxy mapping.
4364     StorageInterface.Bytes32AddressMapping internal proxiesStorage;
4365 
4366     /// @dev Co-owners of a platform. Has less access rights than a root contract owner
4367     StorageInterface.AddressBoolMapping internal partownersStorage;
4368 }
4369 
4370 
4371 contract ChronoBankPlatformRouter is
4372     BaseByzantiumRouter,
4373     ChronoBankPlatformRouterCore,
4374     ChronoBankPlatformEmitter,
4375     StorageAdapter
4376 {
4377     /// @dev memory layout from Owned contract
4378     address public contractOwner;
4379 
4380     bytes32 constant CHRONOBANK_PLATFORM_CRATE = "ChronoBankPlatform";
4381 
4382     constructor(address _platformBackendProvider)
4383     StorageAdapter(Storage(address(this)), CHRONOBANK_PLATFORM_CRATE)
4384     public
4385     {
4386         require(_platformBackendProvider != 0x0, "PLATFORM_ROUTER_INVALID_BACKEND_ADDRESS");
4387 
4388         contractOwner = msg.sender;
4389         platformBackendProvider = _platformBackendProvider;
4390     }
4391 
4392     function implementation()
4393     internal
4394     view
4395     returns (address)
4396     {
4397         return ChronoBankPlatformBackendProvider(platformBackendProvider).platformBackend();
4398     }
4399 }
4400 
4401 // File: contracts/lib/SafeMath.sol
4402 
4403 /// @title SafeMath
4404 /// @dev Math operations with safety checks that throw on error
4405 library SafeMath {
4406 
4407     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4408         uint256 c = a * b;
4409         require(a == 0 || c / a == b, "SAFE_MATH_INVALID_MUL");
4410         return c;
4411     }
4412 
4413     function div(uint256 a, uint256 b) internal pure returns (uint256) {
4414         // assert(b > 0); // Solidity automatically throws when dividing by 0
4415         uint256 c = a / b;
4416         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
4417         return c;
4418     }
4419 
4420     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
4421         require(b <= a, "SAFE_MATH_INVALID_SUB");
4422         return a - b;
4423     }
4424 
4425     function add(uint256 a, uint256 b) internal pure returns (uint256) {
4426         uint256 c = a + b;
4427         require(c >= a, "SAFE_MATH_INVALID_ADD");
4428         return c;
4429     }
4430 }
4431 
4432 // File: contracts/ChronoBankPlatform.sol
4433 
4434 /**
4435  * Copyright 2017–2018, LaborX PTY
4436  * Licensed under the AGPL Version 3 license.
4437  */
4438 
4439 pragma solidity ^0.4.21;
4440 
4441 
4442 
4443 
4444 
4445 
4446 contract ProxyEventsEmitter {
4447     function emitTransfer(address _from, address _to, uint _value) public;
4448     function emitApprove(address _from, address _spender, uint _value) public;
4449 }
4450 
4451 
4452 ///  @title ChronoBank Platform.
4453 ///
4454 ///  The official ChronoBank assets platform powering TIME and LHT tokens, and possibly
4455 ///  other unknown tokens needed later.
4456 ///  Platform uses MultiEventsHistory contract to keep events, so that in case it needs to be redeployed
4457 ///  at some point, all the events keep appearing at the same place.
4458 ///
4459 ///  Every asset is meant to be used through a proxy contract. Only one proxy contract have access
4460 ///  rights for a particular asset.
4461 ///
4462 ///  Features: transfers, allowances, supply adjustments, lost wallet access recovery.
4463 ///
4464 ///  Note: all the non constant functions return false instead of throwing in case if state change
4465 /// didn't happen yet.
4466 contract ChronoBankPlatform is
4467     ChronoBankPlatformRouterCore,
4468     ChronoBankPlatformEmitter,
4469     StorageInterfaceContract,
4470     ChronoBankPlatformCore
4471 {
4472     uint constant OK = 1;
4473 
4474     using SafeMath for uint;
4475 
4476     uint constant CHRONOBANK_PLATFORM_SCOPE = 15000;
4477     uint constant CHRONOBANK_PLATFORM_PROXY_ALREADY_EXISTS = CHRONOBANK_PLATFORM_SCOPE + 0;
4478     uint constant CHRONOBANK_PLATFORM_CANNOT_APPLY_TO_ONESELF = CHRONOBANK_PLATFORM_SCOPE + 1;
4479     uint constant CHRONOBANK_PLATFORM_INVALID_VALUE = CHRONOBANK_PLATFORM_SCOPE + 2;
4480     uint constant CHRONOBANK_PLATFORM_INSUFFICIENT_BALANCE = CHRONOBANK_PLATFORM_SCOPE + 3;
4481     uint constant CHRONOBANK_PLATFORM_NOT_ENOUGH_ALLOWANCE = CHRONOBANK_PLATFORM_SCOPE + 4;
4482     uint constant CHRONOBANK_PLATFORM_ASSET_ALREADY_ISSUED = CHRONOBANK_PLATFORM_SCOPE + 5;
4483     uint constant CHRONOBANK_PLATFORM_CANNOT_ISSUE_FIXED_ASSET_WITH_INVALID_VALUE = CHRONOBANK_PLATFORM_SCOPE + 6;
4484     uint constant CHRONOBANK_PLATFORM_CANNOT_REISSUE_FIXED_ASSET = CHRONOBANK_PLATFORM_SCOPE + 7;
4485     uint constant CHRONOBANK_PLATFORM_SUPPLY_OVERFLOW = CHRONOBANK_PLATFORM_SCOPE + 8;
4486     uint constant CHRONOBANK_PLATFORM_NOT_ENOUGH_TOKENS = CHRONOBANK_PLATFORM_SCOPE + 9;
4487     uint constant CHRONOBANK_PLATFORM_INVALID_NEW_OWNER = CHRONOBANK_PLATFORM_SCOPE + 10;
4488     uint constant CHRONOBANK_PLATFORM_ALREADY_TRUSTED = CHRONOBANK_PLATFORM_SCOPE + 11;
4489     uint constant CHRONOBANK_PLATFORM_SHOULD_RECOVER_TO_NEW_ADDRESS = CHRONOBANK_PLATFORM_SCOPE + 12;
4490     uint constant CHRONOBANK_PLATFORM_ASSET_IS_NOT_ISSUED = CHRONOBANK_PLATFORM_SCOPE + 13;
4491     uint constant CHRONOBANK_PLATFORM_INVALID_INVOCATION = CHRONOBANK_PLATFORM_SCOPE + 17;
4492 
4493     string public version = "0.2.0";
4494 
4495     struct TransactionContext {
4496         address from;
4497         address to;
4498         address sender;
4499         uint fromHolderId;
4500         uint toHolderId;
4501         uint senderHolderId;
4502         uint balanceFrom;
4503         uint balanceTo;
4504         uint allowanceValue;
4505     }
4506 
4507     /// @dev Emits Error if called not by asset owner.
4508     modifier onlyOwner(bytes32 _symbol) {
4509         if (isOwner(msg.sender, _symbol)) {
4510             _;
4511         }
4512     }
4513 
4514     modifier onlyDesignatedManager(bytes32 _symbol) {
4515         if (isDesignatedAssetManager(msg.sender, _symbol)) {
4516             _;
4517         }
4518     }
4519 
4520     /// @dev UNAUTHORIZED if called not by one of partowners or contract's owner
4521     modifier onlyOneOfContractOwners() {
4522         if (contractOwner == msg.sender || partowners(msg.sender)) {
4523             _;
4524         }
4525     }
4526 
4527     /// @dev Emits Error if called not by asset proxy.
4528     modifier onlyProxy(bytes32 _symbol) {
4529         if (proxies(_symbol) == msg.sender) {
4530             _;
4531         }
4532     }
4533 
4534     /// @dev Emits Error if _from doesn't trust _to.
4535     modifier checkTrust(address _from, address _to) {
4536         if (isTrusted(_from, _to)) {
4537             _;
4538         }
4539     }
4540 
4541     /// @dev Emits Error if asset block number > current block number.
4542     modifier onlyAfterBlock(bytes32 _symbol) {
4543         if (block.number >= blockNumber(_symbol)) {
4544             _;
4545         }
4546     }
4547 
4548     constructor() StorageContractAdapter(this, CHRONOBANK_PLATFORM_CRATE) public {
4549     }
4550 
4551     function initStorage()
4552     public
4553     {
4554         init(partownersStorage, "partowners");
4555         init(proxiesStorage, "proxies");
4556         init(symbolsStorage, "symbols");
4557 
4558         init(holdersCountStorage, "holdersCount");
4559         init(holderIndexStorage, "holderIndex");
4560         init(holdersAddressStorage, "holdersAddress");
4561         init(holdersTrustStorage, "holdersTrust");
4562 
4563         init(assetOwnerIdStorage, "assetOwner");
4564         init(assetTotalSupply, "assetTotalSupply");
4565         init(assetName, "assetName");
4566         init(assetDescription, "assetDescription");
4567         init(assetIsReissuable, "assetIsReissuable");
4568         init(assetBlockNumber, "assetBlockNumber");
4569         init(assetBaseUnit, "assetBaseUnit");
4570         init(assetPartowners, "assetPartowners");
4571         init(assetWalletBalance, "assetWalletBalance");
4572         init(assetWalletAllowance, "assetWalletAllowance");
4573     }
4574 
4575     /// @dev Asset symbol to asset details.
4576     /// @return {
4577     ///     "_description": "will be null, since cannot store and return dynamic-sized types in storage (fixed in v0.4.24),
4578     /// }
4579     function assets(bytes32 _symbol) public view returns (
4580         uint _owner,
4581         uint _totalSupply,
4582         string _name,
4583         string _description,
4584         bool _isReissuable,
4585         uint8 _baseUnit,
4586         uint _blockNumber
4587     ) {
4588         _owner = _assetOwner(_symbol);
4589         _totalSupply = totalSupply(_symbol);
4590         _name = name(_symbol);
4591         _description = description(_symbol);
4592         _isReissuable = isReissuable(_symbol);
4593         _baseUnit = baseUnit(_symbol);
4594         _blockNumber = blockNumber(_symbol);
4595     }
4596 
4597     function holdersCount() public view returns (uint) {
4598         return get(store, holdersCountStorage);
4599     }
4600 
4601     function holders(uint _holderId) public view returns (address) {
4602         return get(store, holdersAddressStorage, _holderId);
4603     }
4604 
4605     function symbols(uint _idx) public view returns (bytes32) {
4606         return get(store, symbolsStorage, _idx);
4607     }
4608 
4609     /// @notice Provides a cheap way to get number of symbols registered in a platform
4610     /// @return number of symbols
4611     function symbolsCount() public view returns (uint) {
4612         return count(store, symbolsStorage);
4613     }
4614 
4615     function proxies(bytes32 _symbol) public view returns (address) {
4616         return get(store, proxiesStorage, _symbol);
4617     }
4618 
4619     function partowners(address _address) public view returns (bool) {
4620         return get(store, partownersStorage, _address);
4621     }
4622 
4623     /// @notice Adds a co-owner of a contract. Might be more than one co-owner
4624     /// @dev Allowed to only contract onwer
4625     /// @param _partowner a co-owner of a contract
4626     /// @return result code of an operation
4627     function addPartOwner(address _partowner)
4628     public
4629     onlyContractOwner
4630     returns (uint)
4631     {
4632         set(store, partownersStorage, _partowner, true);
4633         return OK;
4634     }
4635 
4636     /// @notice Removes a co-owner of a contract
4637     /// @dev Should be performed only by root contract owner
4638     /// @param _partowner a co-owner of a contract
4639     /// @return result code of an operation
4640     function removePartOwner(address _partowner)
4641     public
4642     onlyContractOwner
4643     returns (uint)
4644     {
4645         set(store, partownersStorage, _partowner, false);
4646         return OK;
4647     }
4648 
4649     /// @notice Sets EventsHistory contract address.
4650     /// @dev Can be set only by owner.
4651     /// @param _eventsHistory MultiEventsHistory contract address.
4652     /// @return success.
4653     function setupEventsHistory(address _eventsHistory)
4654     public
4655     onlyContractOwner
4656     returns (uint errorCode)
4657     {
4658         _setEventsHistory(_eventsHistory);
4659         return OK;
4660     }
4661 
4662     /// @notice Check asset existance.
4663     /// @param _symbol asset symbol.
4664     /// @return asset existance.
4665     function isCreated(bytes32 _symbol) public view returns (bool) {
4666         return _assetOwner(_symbol) != 0;
4667     }
4668 
4669     /// @notice Returns asset decimals.
4670     /// @param _symbol asset symbol.
4671     /// @return asset decimals.
4672     function baseUnit(bytes32 _symbol) public view returns (uint8) {
4673         return get(store, assetBaseUnit, _symbol);
4674     }
4675 
4676     /// @notice Returns asset name.
4677     /// @param _symbol asset symbol.
4678     /// @return asset name.
4679     function name(bytes32 _symbol) public view returns (string) {
4680         return get(store, assetName, _symbol);
4681     }
4682 
4683     /// @notice Returns asset description.
4684     /// @param _symbol asset symbol.
4685     /// @return asset description.
4686     function description(bytes32 _symbol) public view returns (string) {
4687         return get(store, assetDescription, _symbol);
4688     }
4689 
4690     /// @notice Returns asset reissuability.
4691     /// @param _symbol asset symbol.
4692     /// @return asset reissuability.
4693     function isReissuable(bytes32 _symbol) public view returns (bool) {
4694         return get(store, assetIsReissuable, _symbol);
4695     }
4696 
4697     /// @notice Returns block number from which asset can be used.
4698     /// @param _symbol asset symbol.
4699     /// @return block number.
4700     function blockNumber(bytes32 _symbol) public view returns (uint) {
4701         return get(store, assetBlockNumber, _symbol);
4702     }
4703 
4704     /// @notice Returns asset owner address.
4705     /// @param _symbol asset symbol.
4706     /// @return asset owner address.
4707     function owner(bytes32 _symbol) public view returns (address) {
4708         return _address(_assetOwner(_symbol));
4709     }
4710 
4711     /// @notice Check if specified address has asset owner rights.
4712     /// @param _owner address to check.
4713     /// @param _symbol asset symbol.
4714     /// @return owner rights availability.
4715     function isOwner(address _owner, bytes32 _symbol) public view returns (bool) {
4716         return isCreated(_symbol) && (_assetOwner(_symbol) == getHolderId(_owner));
4717     }
4718 
4719     /// @notice Checks if a specified address has asset owner or co-owner rights.
4720     /// @param _owner address to check.
4721     /// @param _symbol asset symbol.
4722     /// @return owner rights availability.
4723     function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool) {
4724         uint holderId = getHolderId(_owner);
4725         return isCreated(_symbol) && (_assetOwner(_symbol) == holderId || get(store, assetPartowners, _symbol, holderId));
4726     }
4727 
4728     /// @notice Checks if a provided address `_manager` has designated access to asset `_symbol`.
4729     /// @param _manager address that will become the asset manager
4730     /// @param _symbol asset symbol
4731     /// @return true if address is one of designated asset managers, false otherwise
4732     function isDesignatedAssetManager(address _manager, bytes32 _symbol) public view returns (bool) {
4733         uint managerId = getHolderId(_manager);
4734         return isCreated(_symbol) && get(store, assetPartowners, _symbol, managerId);
4735     }
4736 
4737     /// @notice Returns asset total supply.
4738     /// @param _symbol asset symbol.
4739     /// @return asset total supply.
4740     function totalSupply(bytes32 _symbol) public view returns (uint) {
4741         return get(store, assetTotalSupply, _symbol);
4742     }
4743 
4744     /// @notice Returns asset balance for a particular holder.
4745     /// @param _holder holder address.
4746     /// @param _symbol asset symbol.
4747     /// @return holder balance.
4748     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint) {
4749         return _balanceOf(getHolderId(_holder), _symbol);
4750     }
4751 
4752     /// @notice Returns asset balance for a particular holder id.
4753     /// @param _holderId holder id.
4754     /// @param _symbol asset symbol.
4755     /// @return holder balance.
4756     function _balanceOf(uint _holderId, bytes32 _symbol) public view returns (uint) {
4757         return get(store, assetWalletBalance, _symbol, _holderId);
4758     }
4759 
4760     /// @notice Returns current address for a particular holder id.
4761     /// @param _holderId holder id.
4762     /// @return holder address.
4763     function _address(uint _holderId) public view returns (address) {
4764         return get(store, holdersAddressStorage, _holderId);
4765     }
4766 
4767     /// @notice Adds a asset manager for an asset with provided symbol.
4768     /// @dev Should be performed by a platform owner or its co-owners
4769     /// @param _symbol asset's symbol
4770     /// @param _manager asset manager of the asset
4771     /// @return errorCode result code of an operation
4772     function addDesignatedAssetManager(bytes32 _symbol, address _manager)
4773     public
4774     onlyOneOfContractOwners
4775     returns (uint)
4776     {
4777         uint holderId = _createHolderId(_manager);
4778         set(store, assetPartowners, _symbol, holderId, true);
4779         _emitter().emitOwnershipChange(0x0, _manager, _symbol);
4780         return OK;
4781     }
4782 
4783     /// @notice Removes a asset manager for an asset with provided symbol.
4784     /// @dev Should be performed by a platform owner or its co-owners
4785     /// @param _symbol asset's symbol
4786     /// @param _manager asset manager of the asset
4787     /// @return errorCode result code of an operation
4788     function removeDesignatedAssetManager(bytes32 _symbol, address _manager)
4789     public
4790     onlyOneOfContractOwners
4791     returns (uint)
4792     {
4793         uint holderId = getHolderId(_manager);
4794         set(store, assetPartowners, _symbol, holderId, false);
4795         _emitter().emitOwnershipChange(_manager, 0x0, _symbol);
4796         return OK;
4797     }
4798 
4799     /// @notice Sets Proxy contract address for a particular asset.
4800     /// @dev Can be set only once for each asset and only by contract owner.
4801     /// @param _proxyAddress Proxy contract address.
4802     /// @param _symbol asset symbol.
4803     /// @return success.
4804     function setProxy(address _proxyAddress, bytes32 _symbol)
4805     public
4806     onlyOneOfContractOwners
4807     returns (uint)
4808     {
4809         if (proxies(_symbol) != 0x0) {
4810             return CHRONOBANK_PLATFORM_PROXY_ALREADY_EXISTS;
4811         }
4812 
4813         set(store, proxiesStorage, _symbol, _proxyAddress);
4814         return OK;
4815     }
4816 
4817     /// @notice Performes asset transfer for multiple destinations
4818     /// @param addresses list of addresses to receive some amount
4819     /// @param values list of asset amounts for according addresses
4820     /// @param _symbol asset symbol
4821     /// @return {
4822     ///     "errorCode": "resultCode of an operation",
4823     ///     "count": "an amount of succeeded transfers"
4824     /// }
4825     function massTransfer(address[] addresses, uint[] values, bytes32 _symbol)
4826     external
4827     onlyAfterBlock(_symbol)
4828     returns (uint errorCode, uint count)
4829     {
4830         require(addresses.length == values.length, "Different length of addresses and values for mass transfer");
4831         require(_symbol != 0x0, "Asset's symbol cannot be 0");
4832 
4833         return _massTransferDirect(addresses, values, _symbol);
4834     }
4835 
4836     function _massTransferDirect(address[] addresses, uint[] values, bytes32 _symbol)
4837     private
4838     returns (uint errorCode, uint count)
4839     {
4840         uint success = 0;
4841 
4842         TransactionContext memory txContext;
4843         txContext.from = msg.sender;
4844         txContext.fromHolderId = _createHolderId(txContext.from);
4845 
4846         for (uint idx = 0; idx < addresses.length && gasleft() > 110000; idx++) {
4847             uint value = values[idx];
4848 
4849             if (value == 0) {
4850                 _emitErrorCode(CHRONOBANK_PLATFORM_INVALID_VALUE);
4851                 continue;
4852             }
4853 
4854             txContext.balanceFrom = _balanceOf(txContext.fromHolderId, _symbol);
4855 
4856             if (txContext.balanceFrom < value) {
4857                 _emitErrorCode(CHRONOBANK_PLATFORM_INSUFFICIENT_BALANCE);
4858                 continue;
4859             }
4860 
4861             if (txContext.from == addresses[idx]) {
4862                 _emitErrorCode(CHRONOBANK_PLATFORM_CANNOT_APPLY_TO_ONESELF);
4863                 continue;
4864             }
4865 
4866             txContext.toHolderId = _createHolderId(addresses[idx]);
4867             txContext.balanceTo = _balanceOf(txContext.toHolderId, _symbol);
4868             _transferDirect(value, _symbol, txContext);
4869             _emitter().emitTransfer(txContext.from, addresses[idx], _symbol, value, "");
4870 
4871             success++;
4872         }
4873 
4874         return (OK, success);
4875     }
4876 
4877     /// @dev Transfers asset balance between holders wallets.
4878     /// @param _value amount to transfer.
4879     /// @param _symbol asset symbol.
4880     function _transferDirect(
4881         uint _value,
4882         bytes32 _symbol,
4883         TransactionContext memory _txContext
4884     )
4885     internal
4886     {
4887         set(store, assetWalletBalance, _symbol, _txContext.fromHolderId, _txContext.balanceFrom.sub(_value));
4888         set(store, assetWalletBalance, _symbol, _txContext.toHolderId, _txContext.balanceTo.add(_value));
4889     }
4890 
4891     /// @dev Transfers asset balance between holders wallets.
4892     /// Performs sanity checks and takes care of allowances adjustment.
4893     ///
4894     /// @param _value amount to transfer.
4895     /// @param _symbol asset symbol.
4896     /// @param _reference transfer comment to be included in a Transfer event.
4897     ///
4898     /// @return success.
4899     function _transfer(
4900         uint _value,
4901         bytes32 _symbol,
4902         string _reference,
4903         TransactionContext memory txContext
4904     )
4905     internal
4906     returns (uint)
4907     {
4908         // Should not allow to send to oneself.
4909         if (txContext.fromHolderId == txContext.toHolderId) {
4910             return _emitErrorCode(CHRONOBANK_PLATFORM_CANNOT_APPLY_TO_ONESELF);
4911         }
4912 
4913         // Should have positive value.
4914         if (_value == 0) {
4915             return _emitErrorCode(CHRONOBANK_PLATFORM_INVALID_VALUE);
4916         }
4917 
4918         // Should have enough balance.
4919         txContext.balanceFrom = _balanceOf(txContext.fromHolderId, _symbol);
4920         txContext.balanceTo = _balanceOf(txContext.toHolderId, _symbol);
4921         if (txContext.balanceFrom < _value) {
4922             return _emitErrorCode(CHRONOBANK_PLATFORM_INSUFFICIENT_BALANCE);
4923         }
4924 
4925         // Should have enough allowance.
4926         txContext.allowanceValue = _allowance(txContext.fromHolderId, txContext.senderHolderId, _symbol);
4927         if (txContext.fromHolderId != txContext.senderHolderId &&
4928             txContext.allowanceValue < _value
4929         ) {
4930             return _emitErrorCode(CHRONOBANK_PLATFORM_NOT_ENOUGH_ALLOWANCE);
4931         }
4932 
4933         _transferDirect(_value, _symbol, txContext);
4934         // Adjust allowance.
4935         _decrementWalletAllowance(_value, _symbol, txContext);
4936         // Internal Out Of Gas/Throw: revert this transaction too;
4937         // Call Stack Depth Limit reached: n/a after HF 4;
4938         // Recursive Call: safe, all changes already made.
4939         _emitter().emitTransfer(txContext.from, txContext.to, _symbol, _value, _reference);
4940         _proxyTransferEvent(_value, _symbol, txContext);
4941         return OK;
4942     }
4943 
4944     function _decrementWalletAllowance(
4945         uint _value,
4946         bytes32 _symbol,
4947         TransactionContext memory txContext
4948     )
4949     private
4950     {
4951         if (txContext.fromHolderId != txContext.senderHolderId) {
4952             set(store, assetWalletAllowance, _symbol, txContext.fromHolderId, txContext.senderHolderId, txContext.allowanceValue.sub(_value));
4953         }
4954     }
4955 
4956     /// @dev Transfers asset balance between holders wallets.
4957     /// Can only be called by asset proxy.
4958     ///
4959     /// @param _to holder address to give to.
4960     /// @param _value amount to transfer.
4961     /// @param _symbol asset symbol.
4962     /// @param _reference transfer comment to be included in a Transfer event.
4963     /// @param _sender transfer initiator address.
4964     ///
4965     /// @return success.
4966     function proxyTransferWithReference(
4967         address _to,
4968         uint _value,
4969         bytes32 _symbol,
4970         string _reference,
4971         address _sender
4972     )
4973     public
4974     onlyProxy(_symbol)
4975     onlyAfterBlock(_symbol)
4976     returns (uint)
4977     {
4978         TransactionContext memory txContext;
4979         txContext.sender = _sender;
4980         txContext.to = _to;
4981         txContext.from = _sender;
4982         txContext.senderHolderId = getHolderId(_sender);
4983         txContext.toHolderId = _createHolderId(_to);
4984         txContext.fromHolderId = txContext.senderHolderId;
4985         return _transfer(_value, _symbol, _reference, txContext);
4986     }
4987 
4988     /// @dev Ask asset Proxy contract to emit ERC20 compliant Transfer event.
4989     /// @param _value amount to transfer.
4990     /// @param _symbol asset symbol.
4991     function _proxyTransferEvent(uint _value, bytes32 _symbol, TransactionContext memory txContext) internal {
4992         address _proxy = proxies(_symbol);
4993         if (_proxy != 0x0) {
4994             // Internal Out Of Gas/Throw: revert this transaction too;
4995             // Call Stack Depth Limit reached: n/a after HF 4;
4996             // Recursive Call: safe, all changes already made.
4997             ProxyEventsEmitter(_proxy).emitTransfer(txContext.from, txContext.to, _value);
4998         }
4999     }
5000 
5001     /// @notice Returns holder id for the specified address.
5002     /// @param _holder holder address.
5003     /// @return holder id.
5004     function getHolderId(address _holder) public view returns (uint) {
5005         return get(store, holderIndexStorage, _holder);
5006     }
5007 
5008     /// @dev Returns holder id for the specified address, creates it if needed.
5009     /// @param _holder holder address.
5010     /// @return holder id.
5011     function _createHolderId(address _holder) internal returns (uint) {
5012         uint _holderId = getHolderId(_holder);
5013         if (_holderId == 0) {
5014             _holderId = holdersCount() + 1;
5015             set(store, holderIndexStorage, _holder, _holderId);
5016             set(store, holdersAddressStorage, _holderId, _holder);
5017             set(store, holdersCountStorage, _holderId);
5018         }
5019 
5020         return _holderId;
5021     }
5022 
5023     function _assetOwner(bytes32 _symbol) internal view returns (uint) {
5024         return get(store, assetOwnerIdStorage, _symbol);
5025     }
5026 
5027     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
5028         assembly {
5029             result := mload(add(source, 32))
5030         }
5031     }
5032 
5033     /// @notice Issues new asset token on the platform.
5034     ///
5035     /// Tokens issued with this call go straight to contract owner.
5036     /// Each symbol can be issued only once, and only by contract owner.
5037     ///
5038     /// @param _symbol asset symbol.
5039     /// @param _value amount of tokens to issue immediately.
5040     /// @param _name name of the asset.
5041     /// @param _description description for the asset.
5042     /// @param _baseUnit number of decimals.
5043     /// @param _isReissuable dynamic or fixed supply.
5044     /// @param _blockNumber block number from which asset can be used.
5045     ///
5046     /// @return success.
5047     function issueAsset(
5048         bytes32 _symbol,
5049         uint _value,
5050         string _name,
5051         string _description,
5052         uint8 _baseUnit,
5053         bool _isReissuable,
5054         uint _blockNumber
5055     )
5056     public
5057     returns (uint)
5058     {
5059         return issueAssetWithInitialReceiver(_symbol, _value, _name, _description, _baseUnit, _isReissuable, _blockNumber, msg.sender);
5060     }
5061 
5062     /// @notice Issues new asset token on the platform.
5063     ///
5064     /// Tokens issued with this call go straight to contract owner.
5065     /// Each symbol can be issued only once, and only by contract owner.
5066     ///
5067     /// @param _symbol asset symbol.
5068     /// @param _value amount of tokens to issue immediately.
5069     /// @param _name name of the asset.
5070     /// @param _description description for the asset.
5071     /// @param _baseUnit number of decimals.
5072     /// @param _isReissuable dynamic or fixed supply.
5073     /// @param _blockNumber block number from which asset can be used.
5074     /// @param _account address where issued balance will be held
5075     ///
5076     /// @return success.
5077     function issueAssetWithInitialReceiver(
5078         bytes32 _symbol,
5079         uint _value,
5080         string _name,
5081         string _description,
5082         uint8 _baseUnit,
5083         bool _isReissuable,
5084         uint _blockNumber,
5085         address _account
5086     )
5087     public
5088     onlyOneOfContractOwners
5089     returns (uint)
5090     {
5091         // Should have positive value if supply is going to be fixed.
5092         if (_value == 0 && !_isReissuable) {
5093             return _emitErrorCode(CHRONOBANK_PLATFORM_CANNOT_ISSUE_FIXED_ASSET_WITH_INVALID_VALUE);
5094         }
5095         // Should not be issued yet.
5096         if (isCreated(_symbol)) {
5097             return _emitErrorCode(CHRONOBANK_PLATFORM_ASSET_ALREADY_ISSUED);
5098         }
5099         uint holderId = _createHolderId(_account);
5100         uint creatorId = _account == msg.sender ? holderId : _createHolderId(msg.sender);
5101         add(store, symbolsStorage, _symbol);
5102         set(store, assetOwnerIdStorage, _symbol, creatorId);
5103         set(store, assetTotalSupply, _symbol, _value);
5104         set(store, assetName, _symbol, _name);
5105         set(store, assetDescription, _symbol, _description);
5106         set(store, assetIsReissuable, _symbol, _isReissuable);
5107         set(store, assetBaseUnit, _symbol, _baseUnit);
5108         set(store, assetWalletBalance, _symbol, holderId, _value);
5109         set(store, assetBlockNumber, _symbol, _blockNumber);
5110         // Internal Out Of Gas/Throw: revert this transaction too;
5111         // Call Stack Depth Limit reached: n/a after HF 4;
5112         // Recursive Call: safe, all changes already made.
5113         _emitter().emitIssue(_symbol, _value, _address(holderId));
5114         return OK;
5115     }
5116 
5117     /// @notice Issues additional asset tokens if the asset have dynamic supply.
5118     ///
5119     /// Tokens issued with this call go straight to asset owner.
5120     /// Can only be called by designated asset manager only.
5121     /// Inherits all modifiers from reissueAssetToRecepient' function.
5122     ///
5123     /// @param _symbol asset symbol.
5124     /// @param _value amount of additional tokens to issue.
5125     ///
5126     /// @return success.
5127     function reissueAsset(bytes32 _symbol, uint _value)
5128     public
5129     returns (uint)
5130     {
5131         return reissueAssetToRecepient(_symbol, _value, msg.sender);
5132     }
5133 
5134     /// @notice Issues additional asset tokens `_symbol` if the asset have dynamic supply
5135     ///     and sends them to recepient address `_to`.
5136     ///
5137     /// Can only be called by designated asset manager only.
5138     ///
5139     /// @param _symbol asset symbol.
5140     /// @param _value amount of additional tokens to issue.
5141     /// @param _to recepient address; instead of caller issued amount will be sent to this address
5142     ///
5143     /// @return success.
5144     function reissueAssetToRecepient(bytes32 _symbol, uint _value, address _to)
5145     public
5146     onlyDesignatedManager(_symbol)
5147     onlyAfterBlock(_symbol)
5148     returns (uint)
5149     {
5150         return _reissueAsset(_symbol, _value, _to);
5151     }
5152 
5153     function _reissueAsset(bytes32 _symbol, uint _value, address _to)
5154     private
5155     returns (uint)
5156     {
5157         require(_to != 0x0, "CHRONOBANK_PLATFORM_INVALID_RECEPIENT_ADDRESS");
5158 
5159         TransactionContext memory txContext;
5160         txContext.to = _to;
5161 
5162         // Should have positive value.
5163         if (_value == 0) {
5164             return _emitErrorCode(CHRONOBANK_PLATFORM_INVALID_VALUE);
5165         }
5166 
5167         // Should have dynamic supply.
5168         if (!isReissuable(_symbol)) {
5169             return _emitErrorCode(CHRONOBANK_PLATFORM_CANNOT_REISSUE_FIXED_ASSET);
5170         }
5171 
5172         uint _totalSupply = totalSupply(_symbol);
5173         // Resulting total supply should not overflow.
5174         if (_totalSupply + _value < _totalSupply) {
5175             return _emitErrorCode(CHRONOBANK_PLATFORM_SUPPLY_OVERFLOW);
5176         }
5177 
5178         txContext.toHolderId = _createHolderId(_to);
5179         txContext.balanceTo = _balanceOf(txContext.toHolderId, _symbol);
5180         set(store, assetWalletBalance, _symbol, txContext.toHolderId, txContext.balanceTo.add(_value));
5181         set(store, assetTotalSupply, _symbol, _totalSupply.add(_value));
5182         // Internal Out Of Gas/Throw: revert this transaction too;
5183         // Call Stack Depth Limit reached: n/a after HF 4;
5184         // Recursive Call: safe, all changes already made.
5185         _emitter().emitIssue(_symbol, _value, _to);
5186         _proxyTransferEvent(_value, _symbol, txContext);
5187         return OK;
5188     }
5189 
5190     /// @notice Destroys specified amount of senders asset tokens.
5191     ///
5192     /// @param _symbol asset symbol.
5193     /// @param _value amount of tokens to destroy.
5194     ///
5195     /// @return success.
5196     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint _resultCode) {
5197         TransactionContext memory txContext;
5198         txContext.from = msg.sender;
5199         txContext.fromHolderId = getHolderId(txContext.from);
5200 
5201         _resultCode = _revokeAsset(_symbol, _value, txContext);
5202         if (_resultCode != OK) {
5203             return _emitErrorCode(_resultCode);
5204         }
5205 
5206         // Internal Out Of Gas/Throw: revert this transaction too;
5207         // Call Stack Depth Limit reached: n/a after HF 4;
5208         // Recursive Call: safe, all changes already made.
5209         _emitter().emitRevoke(_symbol, _value, txContext.from);
5210         _proxyTransferEvent(_value, _symbol, txContext);
5211         return OK;
5212     }
5213 
5214     /// @notice Destroys specified amount of senders asset tokens.
5215     ///
5216     /// @param _symbol asset symbol.
5217     /// @param _value amount of tokens to destroy.
5218     ///
5219     /// @return success.
5220     function revokeAssetWithExternalReference(bytes32 _symbol, uint _value, string _externalReference) public returns (uint _resultCode) {
5221         TransactionContext memory txContext;
5222         txContext.from = msg.sender;
5223         txContext.fromHolderId = getHolderId(txContext.from);
5224 
5225         _resultCode = _revokeAsset(_symbol, _value, txContext);
5226         if (_resultCode != OK) {
5227             return _emitErrorCode(_resultCode);
5228         }
5229 
5230         // Internal Out Of Gas/Throw: revert this transaction too;
5231         // Call Stack Depth Limit reached: n/a after HF 4;
5232         // Recursive Call: safe, all changes already made.
5233         _emitter().emitRevokeExternal(_symbol, _value, txContext.from, _externalReference);
5234         _proxyTransferEvent(_value, _symbol, txContext);
5235         return OK;
5236     }
5237 
5238     function _revokeAsset(bytes32 _symbol, uint _value, TransactionContext memory txContext) private returns (uint) {
5239         // Should have positive value.
5240         if (_value == 0) {
5241             return _emitErrorCode(CHRONOBANK_PLATFORM_INVALID_VALUE);
5242         }
5243 
5244         // Should have enough tokens.
5245         txContext.balanceFrom = _balanceOf(txContext.fromHolderId, _symbol);
5246         if (txContext.balanceFrom < _value) {
5247             return _emitErrorCode(CHRONOBANK_PLATFORM_NOT_ENOUGH_TOKENS);
5248         }
5249 
5250         txContext.balanceFrom = txContext.balanceFrom.sub(_value);
5251         set(store, assetWalletBalance, _symbol, txContext.fromHolderId, txContext.balanceFrom);
5252         set(store, assetTotalSupply, _symbol, totalSupply(_symbol).sub(_value));
5253 
5254         return OK;
5255     }
5256 
5257     /// @notice Passes asset ownership to specified address.
5258     ///
5259     /// Only ownership is changed, balances are not touched.
5260     /// Can only be called by asset owner.
5261     ///
5262     /// @param _symbol asset symbol.
5263     /// @param _newOwner address to become a new owner.
5264     ///
5265     /// @return success.
5266     function changeOwnership(bytes32 _symbol, address _newOwner)
5267     public
5268     onlyOwner(_symbol)
5269     returns (uint)
5270     {
5271         if (_newOwner == 0x0) {
5272             return _emitErrorCode(CHRONOBANK_PLATFORM_INVALID_NEW_OWNER);
5273         }
5274 
5275         uint newOwnerId = _createHolderId(_newOwner);
5276         uint assetOwner = _assetOwner(_symbol);
5277         // Should pass ownership to another holder.
5278         if (assetOwner == newOwnerId) {
5279             return _emitErrorCode(CHRONOBANK_PLATFORM_CANNOT_APPLY_TO_ONESELF);
5280         }
5281         address oldOwner = _address(assetOwner);
5282         set(store, assetOwnerIdStorage, _symbol, newOwnerId);
5283         // Internal Out Of Gas/Throw: revert this transaction too;
5284         // Call Stack Depth Limit reached: n/a after HF 4;
5285         // Recursive Call: safe, all changes already made.
5286         _emitter().emitOwnershipChange(oldOwner, _newOwner, _symbol);
5287         return OK;
5288     }
5289 
5290     /// @notice Check if specified holder trusts an address with recovery procedure.
5291     /// @param _from truster.
5292     /// @param _to trustee.
5293     /// @return trust existance.
5294     function isTrusted(address _from, address _to) public view returns (bool) {
5295         return get(store, holdersTrustStorage, getHolderId(_from), _to);
5296     }
5297 
5298     /// @notice Trust an address to perform recovery procedure for the caller.
5299     /// @param _to trustee.
5300     /// @return success.
5301     function trust(address _to) public returns (uint) {
5302         uint fromId = _createHolderId(msg.sender);
5303         // Should trust to another address.
5304         if (fromId == getHolderId(_to)) {
5305             return _emitErrorCode(CHRONOBANK_PLATFORM_CANNOT_APPLY_TO_ONESELF);
5306         }
5307         // Should trust to yet untrusted.
5308         if (isTrusted(msg.sender, _to)) {
5309             return _emitErrorCode(CHRONOBANK_PLATFORM_ALREADY_TRUSTED);
5310         }
5311 
5312         set(store, holdersTrustStorage, fromId, _to, true);
5313         return OK;
5314     }
5315 
5316     /// @notice Revoke trust to perform recovery procedure from an address.
5317     /// @param _to trustee.
5318     /// @return success.
5319     function distrust(address _to)
5320     public
5321     checkTrust(msg.sender, _to)
5322     returns (uint)
5323     {
5324         set(store, holdersTrustStorage, getHolderId(msg.sender), _to, false);
5325         return OK;
5326     }
5327 
5328     /// @notice Perform recovery procedure.
5329     ///
5330     /// This function logic is actually more of an addAccess(uint _holderId, address _to).
5331     /// It grants another address access to recovery subject wallets.
5332     /// Can only be called by trustee of recovery subject.
5333     ///
5334     /// @param _from holder address to recover from.
5335     /// @param _to address to grant access to.
5336     ///
5337     /// @return success.
5338     function recover(address _from, address _to)
5339     public
5340     checkTrust(_from, msg.sender)
5341     returns (uint errorCode)
5342     {
5343         // Should recover to previously unused address.
5344         if (getHolderId(_to) != 0) {
5345             return _emitErrorCode(CHRONOBANK_PLATFORM_SHOULD_RECOVER_TO_NEW_ADDRESS);
5346         }
5347         // We take current holder address because it might not equal _from.
5348         // It is possible to recover from any old holder address, but event should have the current one.
5349         uint _fromHolderId = getHolderId(_from);
5350         address _fromRef = _address(_fromHolderId);
5351         set(store, holdersAddressStorage, _fromHolderId, _to);
5352         set(store, holderIndexStorage, _to, _fromHolderId);
5353         // Internal Out Of Gas/Throw: revert this transaction too;
5354         // Call Stack Depth Limit reached: revert this transaction too;
5355         // Recursive Call: safe, all changes already made.
5356         _emitter().emitRecovery(_fromRef, _to, msg.sender);
5357         return OK;
5358     }
5359 
5360     /// @dev Sets asset spending allowance for a specified spender.
5361     ///
5362     /// Note: to revoke allowance, one needs to set allowance to 0.
5363     ///
5364     /// @param _value amount to allow.
5365     /// @param _symbol asset symbol.
5366     ///
5367     /// @return success.
5368     function _approve(
5369         uint _value,
5370         bytes32 _symbol,
5371         TransactionContext memory txContext
5372     )
5373     internal
5374     returns (uint)
5375     {
5376         // Asset should exist.
5377         if (!isCreated(_symbol)) {
5378             return _emitErrorCode(CHRONOBANK_PLATFORM_ASSET_IS_NOT_ISSUED);
5379         }
5380         // Should allow to another holder.
5381         if (txContext.fromHolderId == txContext.senderHolderId) {
5382             return _emitErrorCode(CHRONOBANK_PLATFORM_CANNOT_APPLY_TO_ONESELF);
5383         }
5384 
5385         // Double Spend Attack checkpoint
5386         txContext.allowanceValue = _allowance(txContext.fromHolderId, txContext.senderHolderId, _symbol);
5387         if (!(txContext.allowanceValue == 0 || _value == 0)) {
5388             return _emitErrorCode(CHRONOBANK_PLATFORM_INVALID_INVOCATION);
5389         }
5390 
5391         set(store, assetWalletAllowance, _symbol, txContext.fromHolderId, txContext.senderHolderId, _value);
5392 
5393         // Internal Out Of Gas/Throw: revert this transaction too;
5394         // Call Stack Depth Limit reached: revert this transaction too;
5395         // Recursive Call: safe, all changes already made.
5396         _emitter().emitApprove(txContext.from, txContext.sender, _symbol, _value);
5397         address _proxy = proxies(_symbol);
5398         if (_proxy != 0x0) {
5399             // Internal Out Of Gas/Throw: revert this transaction too;
5400             // Call Stack Depth Limit reached: n/a after HF 4;
5401             // Recursive Call: safe, all changes already made.
5402             ProxyEventsEmitter(_proxy).emitApprove(txContext.from, txContext.sender, _value);
5403         }
5404         return OK;
5405     }
5406 
5407     /// @dev Sets asset spending allowance for a specified spender.
5408     ///
5409     /// Can only be called by asset proxy.
5410     ///
5411     /// @param _spender holder address to set allowance to.
5412     /// @param _value amount to allow.
5413     /// @param _symbol asset symbol.
5414     /// @param _sender approve initiator address.
5415     ///
5416     /// @return success.
5417     function proxyApprove(
5418         address _spender,
5419         uint _value,
5420         bytes32 _symbol,
5421         address _sender
5422     )
5423     public
5424     onlyProxy(_symbol)
5425     returns (uint)
5426     {
5427         TransactionContext memory txContext;
5428         txContext.sender = _spender;
5429         txContext.senderHolderId = _createHolderId(_spender);
5430         txContext.from = _sender;
5431         txContext.fromHolderId = _createHolderId(_sender);
5432         return _approve(_value, _symbol, txContext);
5433     }
5434 
5435     /// @notice Performs allowance transfer of asset balance between holders wallets.
5436     ///
5437     /// @dev Can only be called by asset proxy.
5438     ///
5439     /// @param _from holder address to take from.
5440     /// @param _to holder address to give to.
5441     /// @param _value amount to transfer.
5442     /// @param _symbol asset symbol.
5443     /// @param _reference transfer comment to be included in a Transfer event.
5444     /// @param _sender allowance transfer initiator address.
5445     ///
5446     /// @return success.
5447     function proxyTransferFromWithReference(
5448         address _from,
5449         address _to,
5450         uint _value,
5451         bytes32 _symbol,
5452         string _reference,
5453         address _sender
5454     )
5455     public
5456     onlyProxy(_symbol)
5457     onlyAfterBlock(_symbol)
5458     returns (uint)
5459     {
5460         TransactionContext memory txContext;
5461         txContext.sender = _sender;
5462         txContext.to = _to;
5463         txContext.from = _from;
5464         txContext.toHolderId = _createHolderId(_to);
5465         txContext.fromHolderId = getHolderId(_from);
5466         txContext.senderHolderId = _to == _sender ? txContext.toHolderId : getHolderId(_sender);
5467         return _transfer(_value, _symbol, _reference, txContext);
5468     }
5469 
5470     /// @dev Returns asset allowance from one holder to another.
5471     /// @param _from holder that allowed spending.
5472     /// @param _spender holder that is allowed to spend.
5473     /// @param _symbol asset symbol.
5474     /// @return holder to spender allowance.
5475     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint) {
5476         return _allowance(getHolderId(_from), getHolderId(_spender), _symbol);
5477     }
5478 
5479     /// @dev Returns asset allowance from one holder to another.
5480     /// @param _fromId holder id that allowed spending.
5481     /// @param _toId holder id that is allowed to spend.
5482     /// @param _symbol asset symbol.
5483     /// @return holder to spender allowance.
5484     function _allowance(uint _fromId, uint _toId, bytes32 _symbol) internal view returns (uint) {
5485         return get(store, assetWalletAllowance, _symbol, _fromId, _toId);
5486     }
5487 
5488     function _emitter() private view returns (ChronoBankPlatformEmitter) {
5489         return ChronoBankPlatformEmitter(getEventsHistory());
5490     }
5491 }
5492 
5493 // File: contracts/EtherTokenExchange.sol
5494 
5495 /**
5496 * Copyright 2017–2018, LaborX PTY
5497 * Licensed under the AGPL Version 3 license.
5498 */
5499 
5500 pragma solidity ^0.4.21;
5501 
5502 
5503 
5504 contract ChronoBankAssetProxyInterface is ChronoBankAssetProxy {}
5505 
5506 
5507 
5508 contract EtherTokenExchange {
5509 
5510     uint constant OK = 1;
5511 
5512     event LogEtherDeposited(address indexed sender, uint amount);
5513     event LogEtherWithdrawn(address indexed sender, uint amount);
5514 
5515     ERC20Interface private token;
5516     uint private reentrancyFallbackGuard = 1;
5517 
5518     constructor(address _token) public {
5519         token = ERC20Interface(_token);
5520     }
5521 
5522     function getToken() public view returns (address) {
5523         return token;
5524     }
5525 
5526     function deposit() external payable {
5527         _deposit(msg.sender, msg.value);
5528     }
5529 
5530     function withdraw(uint _amount) external {
5531         require(token.allowance(msg.sender, address(this)) >= _amount, "ETHER_TOKEN_EXCHANGE_NO_APPROVE_PROVIDED");
5532 
5533         uint _guardState = reentrancyFallbackGuard;
5534 
5535         require(token.transferFrom(msg.sender, address(this), _amount), "ETHER_TOKEN_EXCHANGE_TRANSFER_FROM_FAILED");
5536 
5537         if (reentrancyFallbackGuard == _guardState) {
5538             _withdraw(msg.sender, _amount);
5539         }
5540     }
5541 
5542     function tokenFallback(address _from, uint _value, bytes) external {
5543         _incrementGuard();
5544 
5545         if (msg.sender == address(token)) {
5546             _withdraw(_from, _value);
5547             return;
5548         }
5549 
5550         ChronoBankAssetProxyInterface _proxy = ChronoBankAssetProxyInterface(address(token));
5551         address _versionFor = _proxy.getVersionFor(_from);
5552         if (!(msg.sender == _versionFor ||
5553             ChronoBankAssetUtils.containsAssetInChain(ChronoBankAssetChainableInterface(_versionFor), msg.sender))
5554         ) {
5555             revert("ETHER_TOKEN_EXCHANGE_INVALID_TOKEN");
5556         }
5557         _withdraw(_from, _value);
5558     }
5559 
5560     function () external payable {
5561         revert("ETHER_TOKEN_EXCHANGE_USE_DEPOSIT_INSTEAD");
5562     }
5563 
5564     /* PRIVATE */
5565 
5566     function _deposit(address _to, uint _amount) private {
5567         require(_amount > 0, "ETHER_TOKEN_EXCHANGE_INVALID_AMOUNT");
5568 
5569         ChronoBankAssetProxyInterface _token = ChronoBankAssetProxyInterface(token);
5570         ChronoBankPlatform _platform = ChronoBankPlatform(_token.chronoBankPlatform());
5571         require(OK == _platform.reissueAsset(_token.smbl(), _amount), "ETHER_TOKEN_EXCHANGE_ISSUE_FAILURE");
5572         require(_token.transfer(_to, _amount), "ETHER_TOKEN_EXCHANGE_TRANSFER_FAILURE");
5573 
5574         emit LogEtherDeposited(_to, _amount);
5575     }
5576 
5577     function _withdraw(address _from, uint _amount) private {
5578         require(_amount > 0, "ETHER_TOKEN_EXCHANGE_INVALID_AMOUNT");
5579 
5580         ChronoBankAssetProxyInterface _token = ChronoBankAssetProxyInterface(token);
5581         ChronoBankPlatform _platform = ChronoBankPlatform(_token.chronoBankPlatform());
5582         require(OK == _platform.revokeAsset(_token.smbl(), _amount), "ETHER_TOKEN_EXCHANGE_REVOKE_FAILURE");
5583 
5584         _from.transfer(_amount);
5585 
5586         emit LogEtherWithdrawn(_from, _amount);
5587     }
5588 
5589 
5590     function _incrementGuard() public {
5591         reentrancyFallbackGuard += 1;
5592     }
5593 }