1 pragma solidity ^0.4.11;
2 
3 // File: contracts/CAVPlatformEmitter.sol
4 
5 //import '../event/MultiEventsHistoryAdapter.sol';
6 
7 /// @title CAV Platform Emitter.
8 ///
9 /// Contains all the original event emitting function definitions and events.
10 /// In case of new events needed later, additional emitters can be developed.
11 /// All the functions is meant to be called using delegatecall.
12 contract CAVPlatformEmitter {
13     event Transfer(address indexed from, address indexed to, bytes32 indexed symbol, uint value, string reference);
14     event Issue(bytes32 indexed symbol, uint value, address indexed by);
15     event Revoke(bytes32 indexed symbol, uint value, address indexed by);
16     event OwnershipChange(address indexed from, address indexed to, bytes32 indexed symbol);
17     event Approve(address indexed from, address indexed spender, bytes32 indexed symbol, uint value);
18     event Recovery(address indexed from, address indexed to, address by);
19     event Error(uint errorCode);
20 
21     function emitTransfer(address _from, address _to, bytes32 _symbol, uint _value, string _reference) public {
22         Transfer(_from, _to, _symbol, _value, _reference);
23     }
24 
25     function emitIssue(bytes32 _symbol, uint _value, address _by) public {
26         Issue(_symbol, _value, _by);
27     }
28 
29     function emitRevoke(bytes32 _symbol, uint _value, address _by) public {
30         Revoke(_symbol, _value, _by);
31     }
32 
33     function emitOwnershipChange(address _from, address _to, bytes32 _symbol) public {
34         OwnershipChange(_from, _to, _symbol);
35     }
36 
37     function emitApprove(address _from, address _spender, bytes32 _symbol, uint _value) public {
38         Approve(_from, _spender, _symbol, _value);
39     }
40 
41     function emitRecovery(address _from, address _to, address _by) public {
42         Recovery(_from, _to, _by);
43     }
44 
45     function emitError(uint _errorCode) public {
46         Error(_errorCode);
47     }
48 }
49 
50 // File: contracts/ERC20Interface.sol
51 
52 contract ERC20Interface {
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed from, address indexed spender, uint256 value);
55     string public symbol;
56 
57     function decimals() constant returns (uint8);
58     function totalSupply() constant returns (uint256 supply);
59     function balanceOf(address _owner) constant returns (uint256 balance);
60     function transfer(address _to, uint256 _value) returns (bool success);
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
62     function approve(address _spender, uint256 _value) returns (bool success);
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
64 }
65 
66 // File: contracts/Owned.sol
67 
68 /**
69  * @title Owned contract with safe ownership pass.
70  *
71  * Note: all the non constant functions return false instead of throwing in case if state change
72  * didn't happen yet.
73  */
74 contract Owned {
75     /**
76      * Contract owner address
77      */
78     address public contractOwner;
79 
80     /**
81      * Contract owner address
82      */
83     address public pendingContractOwner;
84 
85     function Owned() {
86         contractOwner = msg.sender;
87     }
88 
89     /**
90     * @dev Owner check modifier
91     */
92     modifier onlyContractOwner() {
93         if (contractOwner == msg.sender) {
94             _;
95         }
96     }
97 
98     /**
99      * @dev Destroy contract and scrub a data
100      * @notice Only owner can call it
101      */
102     function destroy() onlyContractOwner {
103         suicide(msg.sender);
104     }
105 
106     /**
107      * Prepares ownership pass.
108      *
109      * Can only be called by current owner.
110      *
111      * @param _to address of the next owner. 0x0 is not allowed.
112      *
113      * @return success.
114      */
115     function changeContractOwnership(address _to) onlyContractOwner public returns (bool) {
116         if (_to == 0x0) {
117             return false;
118         }
119 
120         pendingContractOwner = _to;
121         return true;
122     }
123 
124     /**
125      * Finalize ownership pass.
126      *
127      * Can only be called by pending owner.
128      *
129      * @return success.
130      */
131     function claimContractOwnership() public returns (bool) {
132         if (pendingContractOwner != msg.sender) {
133             return false;
134         }
135 
136         contractOwner = pendingContractOwner;
137         delete pendingContractOwner;
138 
139         return true;
140     }
141 
142     /**
143     * @dev Direct ownership pass without change/claim pattern. Can be invoked only by current contract owner
144     *
145     * @param _to the next contract owner
146     *
147     * @return `true` if success, `false` otherwise
148     */
149     function transferContractOwnership(address _to) onlyContractOwner public returns (bool) {
150         if (_to == 0x0) {
151             return false;
152         }
153 
154         if (pendingContractOwner != 0x0) {
155             pendingContractOwner = 0x0;
156         }
157 
158         contractOwner = _to;
159         return true;
160     }
161 }
162 
163 // File: contracts/Object.sol
164 
165 /**
166  * @title Generic owned destroyable contract
167  */
168 contract Object is Owned {
169     /**
170     *  Common result code. Means everything is fine.
171     */
172     uint constant OK = 1;
173 
174     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
175         for(uint i=0;i<tokens.length;i++) {
176             address token = tokens[i];
177             uint balance = ERC20Interface(token).balanceOf(this);
178             if(balance != 0)
179                 ERC20Interface(token).transfer(_to,balance);
180         }
181         return OK;
182     }
183 }
184 
185 // File: contracts/SafeMath.sol
186 
187 /**
188  * @title SafeMath
189  * @dev Math operations with safety checks that throw on error
190  */
191 library SafeMath {
192   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
193     uint256 c = a * b;
194     assert(a == 0 || c / a == b);
195     return c;
196   }
197 
198   function div(uint256 a, uint256 b) internal constant returns (uint256) {
199     // assert(b > 0); // Solidity automatically throws when dividing by 0
200     uint256 c = a / b;
201     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202     return c;
203   }
204 
205   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
206     assert(b <= a);
207     return a - b;
208   }
209 
210   function add(uint256 a, uint256 b) internal constant returns (uint256) {
211     uint256 c = a + b;
212     assert(c >= a);
213     return c;
214   }
215 }
216 
217 // File: contracts/CAVPlatform.sol
218 
219 contract ProxyEventsEmitter {
220     function emitTransfer(address _from, address _to, uint _value) public;
221     function emitApprove(address _from, address _spender, uint _value) public;
222 }
223 
224 ///  @title CAV Platform.
225 ///
226 ///  The official CAV assets platform powering TIME and LHT tokens, and possibly
227 ///  other unknown tokens needed later.
228 ///  Platform uses MultiEventsHistory contract to keep events, so that in case it needs to be redeployed
229 ///  at some point, all the events keep appearing at the same place.
230 ///
231 ///  Every asset is meant to be used through a proxy contract. Only one proxy contract have access
232 ///  rights for a particular asset.
233 ///
234 ///  Features: transfers, allowances, supply adjustments, lost wallet access recovery.
235 ///
236 ///  Note: all the non constant functions return false instead of throwing in case if state change
237 /// didn't happen yet.
238 contract CAVPlatform is Object, CAVPlatformEmitter {
239     using SafeMath for uint;
240 
241     uint constant CAV_PLATFORM_SCOPE = 15000;
242     uint constant CAV_PLATFORM_PROXY_ALREADY_EXISTS = CAV_PLATFORM_SCOPE + 0;
243     uint constant CAV_PLATFORM_CANNOT_APPLY_TO_ONESELF = CAV_PLATFORM_SCOPE + 1;
244     uint constant CAV_PLATFORM_INVALID_VALUE = CAV_PLATFORM_SCOPE + 2;
245     uint constant CAV_PLATFORM_INSUFFICIENT_BALANCE = CAV_PLATFORM_SCOPE + 3;
246     uint constant CAV_PLATFORM_NOT_ENOUGH_ALLOWANCE = CAV_PLATFORM_SCOPE + 4;
247     uint constant CAV_PLATFORM_ASSET_ALREADY_ISSUED = CAV_PLATFORM_SCOPE + 5;
248     uint constant CAV_PLATFORM_CANNOT_ISSUE_FIXED_ASSET_WITH_INVALID_VALUE = CAV_PLATFORM_SCOPE + 6;
249     uint constant CAV_PLATFORM_CANNOT_REISSUE_FIXED_ASSET = CAV_PLATFORM_SCOPE + 7;
250     uint constant CAV_PLATFORM_SUPPLY_OVERFLOW = CAV_PLATFORM_SCOPE + 8;
251     uint constant CAV_PLATFORM_NOT_ENOUGH_TOKENS = CAV_PLATFORM_SCOPE + 9;
252     uint constant CAV_PLATFORM_INVALID_NEW_OWNER = CAV_PLATFORM_SCOPE + 10;
253     uint constant CAV_PLATFORM_ALREADY_TRUSTED = CAV_PLATFORM_SCOPE + 11;
254     uint constant CAV_PLATFORM_SHOULD_RECOVER_TO_NEW_ADDRESS = CAV_PLATFORM_SCOPE + 12;
255     uint constant CAV_PLATFORM_ASSET_IS_NOT_ISSUED = CAV_PLATFORM_SCOPE + 13;
256     uint constant CAV_PLATFORM_INVALID_INVOCATION = CAV_PLATFORM_SCOPE + 17;
257 
258     /// Structure of a particular asset.
259     struct Asset {
260         uint owner;                       // Asset's owner id.
261         uint totalSupply;                 // Asset's total supply.
262         string name;                      // Asset's name, for information purposes.
263         string description;               // Asset's description, for information purposes.
264         bool isReissuable;                // Indicates if asset have dynamic or fixed supply.
265         uint8 baseUnit;                   // Proposed number of decimals.
266         mapping(uint => Wallet) wallets;  // Holders wallets.
267         mapping(uint => bool) partowners; // Part-owners of an asset; have less access rights than owner
268     }
269 
270     /// Structure of an asset holder wallet for particular asset.
271     struct Wallet {
272         uint balance;
273         mapping(uint => uint) allowance;
274     }
275 
276     /// Structure of an asset holder.
277     struct Holder {
278         address addr;                    // Current address of the holder.
279         mapping(address => bool) trust;  // Addresses that are trusted with recovery proocedure.
280     }
281 
282     /// Iterable mapping pattern is used for holders.
283     uint public holdersCount;
284     mapping(uint => Holder) public holders;
285 
286     /// This is an access address mapping. Many addresses may have access to a single holder.
287     mapping(address => uint) holderIndex;
288 
289     /// List of symbols that exist in a platform
290     bytes32[] public symbols;
291 
292     /// Asset symbol to asset mapping.
293     mapping(bytes32 => Asset) public assets;
294 
295     /// Asset symbol to asset proxy mapping.
296     mapping(bytes32 => address) public proxies;
297 
298     /// Co-owners of a platform. Has less access rights than a root contract owner
299     mapping(address => bool) public partowners;
300 
301     // Should use interface of the emitter, but address of events history.
302     address public eventsHistory;
303 
304     /// Emits Error event with specified error message.
305     /// Should only be used if no state changes happened.
306     /// @param _errorCode code of an error
307     function _error(uint _errorCode) internal returns (uint) {
308         CAVPlatformEmitter(eventsHistory).emitError(_errorCode);
309         return _errorCode;
310     }
311 
312     /// Emits Error if called not by asset owner.
313     modifier onlyOwner(bytes32 _symbol) {
314         if (isOwner(msg.sender, _symbol)) {
315             _;
316         }
317     }
318 
319     /// @dev UNAUTHORIZED if called not by one of symbol's partowners or owner
320     modifier onlyOneOfOwners(bytes32 _symbol) {
321         if (hasAssetRights(msg.sender, _symbol)) {
322             _;
323         }
324     }
325 
326     /// @dev UNAUTHORIZED if called not by one of partowners or contract's owner
327     modifier onlyOneOfContractOwners() {
328         if (contractOwner == msg.sender || partowners[msg.sender]) {
329             _;
330         }
331     }
332 
333     /// Emits Error if called not by asset proxy.
334     modifier onlyProxy(bytes32 _symbol) {
335         if (proxies[_symbol] == msg.sender) {
336             _;
337         }
338     }
339 
340     /// Emits Error if _from doesn't trust _to.
341     modifier checkTrust(address _from, address _to) {
342         if (isTrusted(_from, _to)) {
343             _;
344         }
345     }
346 
347     /// Adds a co-owner of a contract. Might be more than one co-owner
348     /// @dev Allowed to only contract onwer
349     /// @param _partowner a co-owner of a contract
350     /// @return result code of an operation
351     function addPartOwner(address _partowner) onlyContractOwner public returns (uint) {
352         partowners[_partowner] = true;
353         return OK;
354     }
355 
356     /// Removes a co-owner of a contract
357     /// @dev Should be performed only by root contract owner
358     /// @param _partowner a co-owner of a contract
359     /// @return result code of an operation
360     function removePartOwner(address _partowner) onlyContractOwner public returns (uint) {
361         delete partowners[_partowner];
362         return OK;
363     }
364 
365     /// Sets EventsHstory contract address.
366     ///
367     /// Can be set only by events history admon or owner.
368     ///
369     /// @param _eventsHistory MultiEventsHistory contract address.
370     ///
371     /// @return success.
372     function setupEventsHistory(address _eventsHistory) onlyContractOwner public returns (uint errorCode) {
373         eventsHistory = _eventsHistory;
374         return OK;
375     }
376 
377     /// Provides a cheap way to get number of symbols registered in a platform
378     /// @return number of symbols
379     function symbolsCount() public view returns (uint) {
380         return symbols.length;
381     }
382 
383     /// Check asset existance.
384     ///
385     /// @param _symbol asset symbol.
386     ///
387     /// @return asset existance.
388     function isCreated(bytes32 _symbol) public view returns (bool) {
389         return assets[_symbol].owner != 0;
390     }
391 
392     /// Returns asset decimals.
393     ///
394     /// @param _symbol asset symbol.
395     ///
396     /// @return asset decimals.
397     function baseUnit(bytes32 _symbol) public view returns (uint8) {
398         return assets[_symbol].baseUnit;
399     }
400 
401     /// Returns asset name.
402     ///
403     /// @param _symbol asset symbol.
404     ///
405     /// @return asset name.
406     function name(bytes32 _symbol) public view returns (string) {
407         return assets[_symbol].name;
408     }
409 
410     /// Returns asset description.
411     ///
412     /// @param _symbol asset symbol.
413     ///
414     /// @return asset description.
415     function description(bytes32 _symbol) public view returns (string) {
416         return assets[_symbol].description;
417     }
418 
419     /// Returns asset reissuability.
420     ///
421     /// @param _symbol asset symbol.
422     ///
423     /// @return asset reissuability.
424     function isReissuable(bytes32 _symbol) public view returns (bool) {
425         return assets[_symbol].isReissuable;
426     }
427 
428     /// Returns asset owner address.
429     /// @param _symbol asset symbol.
430     /// @return asset owner address.
431     function owner(bytes32 _symbol) public view returns (address) {
432         return holders[assets[_symbol].owner].addr;
433     }
434 
435     /// Check if specified address has asset owner rights.
436     /// @param _owner address to check.
437     /// @param _symbol asset symbol.
438     /// @return owner rights availability.
439     function isOwner(address _owner, bytes32 _symbol) public view returns (bool) {
440         return isCreated(_symbol) && (assets[_symbol].owner == getHolderId(_owner));
441     }
442 
443     /// Checks if a specified address has asset owner or co-owner rights.
444     /// @param _owner address to check.
445     /// @param _symbol asset symbol.
446     /// @return owner rights availability.
447     function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool) {
448         uint holderId = getHolderId(_owner);
449         return isCreated(_symbol) && (assets[_symbol].owner == holderId || assets[_symbol].partowners[holderId]);
450     }
451 
452     /// Returns asset total supply.
453     ///
454     /// @param _symbol asset symbol.
455     ///
456     /// @return asset total supply.
457     function totalSupply(bytes32 _symbol) public view returns (uint) {
458         return assets[_symbol].totalSupply;
459     }
460 
461     /// Returns asset balance for a particular holder.
462     ///
463     /// @param _holder holder address.
464     /// @param _symbol asset symbol.
465     ///
466     /// @return holder balance.
467     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint) {
468         return _balanceOf(getHolderId(_holder), _symbol);
469     }
470 
471     /// Returns asset balance for a particular holder id.
472     ///
473     /// @param _holderId holder id.
474     /// @param _symbol asset symbol.
475     ///
476     /// @return holder balance.
477     function _balanceOf(uint _holderId, bytes32 _symbol) public view returns (uint) {
478         return assets[_symbol].wallets[_holderId].balance;
479     }
480 
481     /// Returns current address for a particular holder id.
482     ///
483     /// @param _holderId holder id.
484     ///
485     /// @return holder address.
486     function _address(uint _holderId) public view returns (address) {
487         return holders[_holderId].addr;
488     }
489 
490     /// Adds a co-owner for an asset with provided symbol.
491     /// @dev Should be performed by a contract owner or its co-owners
492     ///
493     /// @param _symbol asset's symbol
494     /// @param _partowner a co-owner of an asset
495     ///
496     /// @return errorCode result code of an operation
497     function addAssetPartOwner(bytes32 _symbol, address _partowner) onlyOneOfOwners(_symbol) public returns (uint) {
498         uint holderId = _createHolderId(_partowner);
499         assets[_symbol].partowners[holderId] = true;
500         CAVPlatformEmitter(eventsHistory).emitOwnershipChange(0x0, _partowner, _symbol);
501         return OK;
502     }
503 
504     /// Removes a co-owner for an asset with provided symbol.
505     /// @dev Should be performed by a contract owner or its co-owners
506     ///
507     /// @param _symbol asset's symbol
508     /// @param _partowner a co-owner of an asset
509     ///
510     /// @return errorCode result code of an operation
511     function removeAssetPartOwner(bytes32 _symbol, address _partowner) onlyOneOfOwners(_symbol) public returns (uint) {
512         uint holderId = getHolderId(_partowner);
513         delete assets[_symbol].partowners[holderId];
514         CAVPlatformEmitter(eventsHistory).emitOwnershipChange(_partowner, 0x0, _symbol);
515         return OK;
516     }
517 
518     /// Sets Proxy contract address for a particular asset.
519     ///
520     /// Can be set only once for each asset, and only by contract owner.
521     ///
522     /// @param _proxyAddress Proxy contract address.
523     /// @param _symbol asset symbol.
524     ///
525     /// @return success.
526     function setProxy(address _proxyAddress, bytes32 _symbol) public onlyOneOfContractOwners returns (uint) {
527         if (proxies[_symbol] != 0x0) {
528             return CAV_PLATFORM_PROXY_ALREADY_EXISTS;
529         }
530 
531         proxies[_symbol] = _proxyAddress;
532         return OK;
533     }
534 
535     /// Transfers asset balance between holders wallets.
536     ///
537     /// @param _fromId holder id to take from.
538     /// @param _toId holder id to give to.
539     /// @param _value amount to transfer.
540     /// @param _symbol asset symbol.
541     function _transferDirect(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
542         assets[_symbol].wallets[_fromId].balance = assets[_symbol].wallets[_fromId].balance.sub(_value);
543         assets[_symbol].wallets[_toId].balance = assets[_symbol].wallets[_toId].balance.add(_value);
544     }
545 
546     /// Transfers asset balance between holders wallets.
547     ///
548     /// Performs sanity checks and takes care of allowances adjustment.
549     ///
550     /// @param _fromId holder id to take from.
551     /// @param _toId holder id to give to.
552     /// @param _value amount to transfer.
553     /// @param _symbol asset symbol.
554     /// @param _reference transfer comment to be included in a Transfer event.
555     /// @param _senderId transfer initiator holder id.
556     ///
557     /// @return success.
558     function _transfer(uint _fromId, uint _toId, uint _value, bytes32 _symbol, string _reference, uint _senderId) internal returns (uint) {
559         // Should not allow to send to oneself.
560         if (_fromId == _toId) {
561             return _error(CAV_PLATFORM_CANNOT_APPLY_TO_ONESELF);
562         }
563         // Should have positive value.
564         if (_value == 0) {
565             return _error(CAV_PLATFORM_INVALID_VALUE);
566         }
567         // Should have enough balance.
568         if (_balanceOf(_fromId, _symbol) < _value) {
569             return _error(CAV_PLATFORM_INSUFFICIENT_BALANCE);
570         }
571         // Should have enough allowance.
572         if (_fromId != _senderId && _allowance(_fromId, _senderId, _symbol) < _value) {
573             return _error(CAV_PLATFORM_NOT_ENOUGH_ALLOWANCE);
574         }
575 
576         _transferDirect(_fromId, _toId, _value, _symbol);
577         // Adjust allowance.
578         if (_fromId != _senderId) {
579             assets[_symbol].wallets[_fromId].allowance[_senderId] = assets[_symbol].wallets[_fromId].allowance[_senderId].sub(_value);
580         }
581         // Internal Out Of Gas/Throw: revert this transaction too;
582         // Call Stack Depth Limit reached: n/a after HF 4;
583         // Recursive Call: safe, all changes already made.
584         CAVPlatformEmitter(eventsHistory).emitTransfer(_address(_fromId), _address(_toId), _symbol, _value, _reference);
585         _proxyTransferEvent(_fromId, _toId, _value, _symbol);
586         return OK;
587     }
588 
589     /// Transfers asset balance between holders wallets.
590     ///
591     /// Can only be called by asset proxy.
592     ///
593     /// @param _to holder address to give to.
594     /// @param _value amount to transfer.
595     /// @param _symbol asset symbol.
596     /// @param _reference transfer comment to be included in a Transfer event.
597     /// @param _sender transfer initiator address.
598     ///
599     /// @return success.
600     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public onlyProxy(_symbol) returns (uint) {
601         return _transfer(getHolderId(_sender), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
602     }
603 
604     /// Ask asset Proxy contract to emit ERC20 compliant Transfer event.
605     ///
606     /// @param _fromId holder id to take from.
607     /// @param _toId holder id to give to.
608     /// @param _value amount to transfer.
609     /// @param _symbol asset symbol.
610     function _proxyTransferEvent(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
611         if (proxies[_symbol] != 0x0) {
612             // Internal Out Of Gas/Throw: revert this transaction too;
613             // Call Stack Depth Limit reached: n/a after HF 4;
614             // Recursive Call: safe, all changes already made.
615             ProxyEventsEmitter(proxies[_symbol]).emitTransfer(_address(_fromId), _address(_toId), _value);
616         }
617     }
618 
619     /// Returns holder id for the specified address.
620     ///
621     /// @param _holder holder address.
622     ///
623     /// @return holder id.
624     function getHolderId(address _holder) public view returns (uint) {
625         return holderIndex[_holder];
626     }
627 
628     /// Returns holder id for the specified address, creates it if needed.
629     ///
630     /// @param _holder holder address.
631     ///
632     /// @return holder id.
633     function _createHolderId(address _holder) internal returns (uint) {
634         uint holderId = holderIndex[_holder];
635         if (holderId == 0) {
636             holderId = ++holdersCount;
637             holders[holderId].addr = _holder;
638             holderIndex[_holder] = holderId;
639         }
640         return holderId;
641     }
642 
643     /// Issues new asset token on the platform.
644     ///
645     /// Tokens issued with this call go straight to contract owner.
646     /// Each symbol can be issued only once, and only by contract owner.
647     ///
648     /// @param _symbol asset symbol.
649     /// @param _value amount of tokens to issue immediately.
650     /// @param _name name of the asset.
651     /// @param _description description for the asset.
652     /// @param _baseUnit number of decimals.
653     /// @param _isReissuable dynamic or fixed supply.
654     ///
655     /// @return success.
656     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint) {
657         return issueAsset(_symbol, _value, _name, _description, _baseUnit, _isReissuable, msg.sender);
658     }
659 
660     /// Issues new asset token on the platform.
661     ///
662     /// Tokens issued with this call go straight to contract owner.
663     /// Each symbol can be issued only once, and only by contract owner.
664     ///
665     /// @param _symbol asset symbol.
666     /// @param _value amount of tokens to issue immediately.
667     /// @param _name name of the asset.
668     /// @param _description description for the asset.
669     /// @param _baseUnit number of decimals.
670     /// @param _isReissuable dynamic or fixed supply.
671     /// @param _account address where issued balance will be held
672     ///
673     /// @return success.
674     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, address _account) onlyOneOfContractOwners public returns (uint) {
675         // Should have positive value if supply is going to be fixed.
676         if (_value == 0 && !_isReissuable) {
677             return _error(CAV_PLATFORM_CANNOT_ISSUE_FIXED_ASSET_WITH_INVALID_VALUE);
678         }
679         // Should not be issued yet.
680         if (isCreated(_symbol)) {
681             return _error(CAV_PLATFORM_ASSET_ALREADY_ISSUED);
682         }
683         uint holderId = _createHolderId(_account);
684         uint creatorId = _account == msg.sender ? holderId : _createHolderId(msg.sender);
685 
686         symbols.push(_symbol);
687         assets[_symbol] = Asset(creatorId, _value, _name, _description, _isReissuable, _baseUnit);
688         assets[_symbol].wallets[holderId].balance = _value;
689         // Internal Out Of Gas/Throw: revert this transaction too;
690         // Call Stack Depth Limit reached: n/a after HF 4;
691         // Recursive Call: safe, all changes already made.
692         CAVPlatformEmitter(eventsHistory).emitIssue(_symbol, _value, _address(holderId));
693         return OK;
694     }
695 
696     /// Issues additional asset tokens if the asset have dynamic supply.
697     ///
698     /// Tokens issued with this call go straight to asset owner.
699     /// Can only be called by asset owner.
700     ///
701     /// @param _symbol asset symbol.
702     /// @param _value amount of additional tokens to issue.
703     ///
704     /// @return success.
705     function reissueAsset(bytes32 _symbol, uint _value) onlyOneOfOwners(_symbol) public returns (uint) {
706         // Should have positive value.
707         if (_value == 0) {
708             return _error(CAV_PLATFORM_INVALID_VALUE);
709         }
710         Asset storage asset = assets[_symbol];
711         // Should have dynamic supply.
712         if (!asset.isReissuable) {
713             return _error(CAV_PLATFORM_CANNOT_REISSUE_FIXED_ASSET);
714         }
715         // Resulting total supply should not overflow.
716         if (asset.totalSupply + _value < asset.totalSupply) {
717             return _error(CAV_PLATFORM_SUPPLY_OVERFLOW);
718         }
719         uint holderId = getHolderId(msg.sender);
720         asset.wallets[holderId].balance = asset.wallets[holderId].balance.add(_value);
721         asset.totalSupply = asset.totalSupply.add(_value);
722         // Internal Out Of Gas/Throw: revert this transaction too;
723         // Call Stack Depth Limit reached: n/a after HF 4;
724         // Recursive Call: safe, all changes already made.
725         CAVPlatformEmitter(eventsHistory).emitIssue(_symbol, _value, _address(holderId));
726         _proxyTransferEvent(0, holderId, _value, _symbol);
727         return OK;
728     }
729 
730     /// Destroys specified amount of senders asset tokens.
731     ///
732     /// @param _symbol asset symbol.
733     /// @param _value amount of tokens to destroy.
734     ///
735     /// @return success.
736     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint) {
737         // Should have positive value.
738         if (_value == 0) {
739             return _error(CAV_PLATFORM_INVALID_VALUE);
740         }
741         Asset storage asset = assets[_symbol];
742         uint holderId = getHolderId(msg.sender);
743         // Should have enough tokens.
744         if (asset.wallets[holderId].balance < _value) {
745             return _error(CAV_PLATFORM_NOT_ENOUGH_TOKENS);
746         }
747         asset.wallets[holderId].balance = asset.wallets[holderId].balance.sub(_value);
748         asset.totalSupply = asset.totalSupply.sub(_value);
749         // Internal Out Of Gas/Throw: revert this transaction too;
750         // Call Stack Depth Limit reached: n/a after HF 4;
751         // Recursive Call: safe, all changes already made.
752         CAVPlatformEmitter(eventsHistory).emitRevoke(_symbol, _value, _address(holderId));
753         _proxyTransferEvent(holderId, 0, _value, _symbol);
754         return OK;
755     }
756 
757     /// Passes asset ownership to specified address.
758     ///
759     /// Only ownership is changed, balances are not touched.
760     /// Can only be called by asset owner.
761     ///
762     /// @param _symbol asset symbol.
763     /// @param _newOwner address to become a new owner.
764     ///
765     /// @return success.
766     function changeOwnership(bytes32 _symbol, address _newOwner) public onlyOwner(_symbol) returns (uint) {
767         if (_newOwner == 0x0) {
768             return _error(CAV_PLATFORM_INVALID_NEW_OWNER);
769         }
770 
771         Asset storage asset = assets[_symbol];
772         uint newOwnerId = _createHolderId(_newOwner);
773         // Should pass ownership to another holder.
774         if (asset.owner == newOwnerId) {
775             return _error(CAV_PLATFORM_CANNOT_APPLY_TO_ONESELF);
776         }
777         address oldOwner = _address(asset.owner);
778         asset.owner = newOwnerId;
779         // Internal Out Of Gas/Throw: revert this transaction too;
780         // Call Stack Depth Limit reached: n/a after HF 4;
781         // Recursive Call: safe, all changes already made.
782         CAVPlatformEmitter(eventsHistory).emitOwnershipChange(oldOwner, _newOwner, _symbol);
783         return OK;
784     }
785 
786     /// Check if specified holder trusts an address with recovery procedure.
787     ///
788     /// @param _from truster.
789     /// @param _to trustee.
790     ///
791     /// @return trust existance.
792     function isTrusted(address _from, address _to) public view returns (bool) {
793         return holders[getHolderId(_from)].trust[_to];
794     }
795 
796     /// Trust an address to perform recovery procedure for the caller.
797     ///
798     /// @param _to trustee.
799     ///
800     /// @return success.
801     function trust(address _to) public returns (uint) {
802         uint fromId = _createHolderId(msg.sender);
803         // Should trust to another address.
804         if (fromId == getHolderId(_to)) {
805             return _error(CAV_PLATFORM_CANNOT_APPLY_TO_ONESELF);
806         }
807         // Should trust to yet untrusted.
808         if (isTrusted(msg.sender, _to)) {
809             return _error(CAV_PLATFORM_ALREADY_TRUSTED);
810         }
811 
812         holders[fromId].trust[_to] = true;
813         return OK;
814     }
815 
816     /// Revoke trust to perform recovery procedure from an address.
817     ///
818     /// @param _to trustee.
819     ///
820     /// @return success.
821     function distrust(address _to) checkTrust(msg.sender, _to) public returns (uint) {
822         holders[getHolderId(msg.sender)].trust[_to] = false;
823         return OK;
824     }
825 
826     function massTransfer(address[] addresses, uint[] values, bytes32 _symbol)
827     external
828     onlyOneOfOwners(_symbol)
829     returns (uint errorCode, uint count)
830     {
831         require(addresses.length == values.length);
832         require(_symbol != 0x0);
833 
834         uint senderId = _createHolderId(msg.sender);
835 
836         uint success = 0;
837         for(uint idx = 0; idx < addresses.length && msg.gas > 110000; idx++) {
838             uint value = values[idx];
839 
840             if (value == 0) {
841               _error(CAV_PLATFORM_INVALID_VALUE);
842               continue;
843             }
844 
845             if (_balanceOf(senderId, _symbol) < value) {
846               _error(CAV_PLATFORM_INSUFFICIENT_BALANCE);
847               continue;
848             }
849 
850             if (msg.sender == addresses[idx]) {
851               _error(CAV_PLATFORM_CANNOT_APPLY_TO_ONESELF);
852               continue;
853             }
854 
855             uint holderId = _createHolderId(addresses[idx]);
856 
857             _transferDirect(senderId, holderId, value, _symbol);
858             CAVPlatformEmitter(eventsHistory).emitTransfer(msg.sender, addresses[idx], _symbol, value, "");
859 
860             success++;
861           }
862 
863           return (OK, success);
864     }
865 
866     /// Perform recovery procedure.
867     ///
868     /// This function logic is actually more of an addAccess(uint _holderId, address _to).
869     /// It grants another address access to recovery subject wallets.
870     /// Can only be called by trustee of recovery subject.
871     ///
872     /// @param _from holder address to recover from.
873     /// @param _to address to grant access to.
874     ///
875     /// @return success.
876     function recover(address _from, address _to) checkTrust(_from, msg.sender) public returns (uint errorCode) {
877         // Should recover to previously unused address.
878         if (getHolderId(_to) != 0) {
879             return _error(CAV_PLATFORM_SHOULD_RECOVER_TO_NEW_ADDRESS);
880         }
881         // We take current holder address because it might not equal _from.
882         // It is possible to recover from any old holder address, but event should have the current one.
883         address from = holders[getHolderId(_from)].addr;
884         holders[getHolderId(_from)].addr = _to;
885         holderIndex[_to] = getHolderId(_from);
886         // Internal Out Of Gas/Throw: revert this transaction too;
887         // Call Stack Depth Limit reached: revert this transaction too;
888         // Recursive Call: safe, all changes already made.
889         CAVPlatformEmitter(eventsHistory).emitRecovery(from, _to, msg.sender);
890         return OK;
891     }
892 
893     /// Sets asset spending allowance for a specified spender.
894     ///
895     /// Note: to revoke allowance, one needs to set allowance to 0.
896     ///
897     /// @param _spenderId holder id to set allowance for.
898     /// @param _value amount to allow.
899     /// @param _symbol asset symbol.
900     /// @param _senderId approve initiator holder id.
901     ///
902     /// @return success.
903     function _approve(uint _spenderId, uint _value, bytes32 _symbol, uint _senderId) internal returns (uint) {
904         // Asset should exist.
905         if (!isCreated(_symbol)) {
906             return _error(CAV_PLATFORM_ASSET_IS_NOT_ISSUED);
907         }
908         // Should allow to another holder.
909         if (_senderId == _spenderId) {
910             return _error(CAV_PLATFORM_CANNOT_APPLY_TO_ONESELF);
911         }
912 
913         // Double Spend Attack checkpoint
914         if (assets[_symbol].wallets[_senderId].allowance[_spenderId] != 0 && _value != 0) {
915             return _error(CAV_PLATFORM_INVALID_INVOCATION);
916         }
917 
918         assets[_symbol].wallets[_senderId].allowance[_spenderId] = _value;
919 
920         // Internal Out Of Gas/Throw: revert this transaction too;
921         // Call Stack Depth Limit reached: revert this transaction too;
922         // Recursive Call: safe, all changes already made.
923         CAVPlatformEmitter(eventsHistory).emitApprove(_address(_senderId), _address(_spenderId), _symbol, _value);
924         if (proxies[_symbol] != 0x0) {
925             // Internal Out Of Gas/Throw: revert this transaction too;
926             // Call Stack Depth Limit reached: n/a after HF 4;
927             // Recursive Call: safe, all changes already made.
928             ProxyEventsEmitter(proxies[_symbol]).emitApprove(_address(_senderId), _address(_spenderId), _value);
929         }
930         return OK;
931     }
932 
933     /// Sets asset spending allowance for a specified spender.
934     ///
935     /// Can only be called by asset proxy.
936     ///
937     /// @param _spender holder address to set allowance to.
938     /// @param _value amount to allow.
939     /// @param _symbol asset symbol.
940     /// @param _sender approve initiator address.
941     ///
942     /// @return success.
943     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) onlyProxy(_symbol) public returns (uint) {
944         return _approve(_createHolderId(_spender), _value, _symbol, _createHolderId(_sender));
945     }
946 
947     /// Returns asset allowance from one holder to another.
948     ///
949     /// @param _from holder that allowed spending.
950     /// @param _spender holder that is allowed to spend.
951     /// @param _symbol asset symbol.
952     ///
953     /// @return holder to spender allowance.
954     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint) {
955         return _allowance(getHolderId(_from), getHolderId(_spender), _symbol);
956     }
957 
958     /// Returns asset allowance from one holder to another.
959     ///
960     /// @param _fromId holder id that allowed spending.
961     /// @param _toId holder id that is allowed to spend.
962     /// @param _symbol asset symbol.
963     ///
964     /// @return holder to spender allowance.
965     function _allowance(uint _fromId, uint _toId, bytes32 _symbol) internal view returns (uint) {
966         return assets[_symbol].wallets[_fromId].allowance[_toId];
967     }
968 
969     /// Prforms allowance transfer of asset balance between holders wallets.
970     ///
971     /// Can only be called by asset proxy.
972     ///
973     /// @param _from holder address to take from.
974     /// @param _to holder address to give to.
975     /// @param _value amount to transfer.
976     /// @param _symbol asset symbol.
977     /// @param _reference transfer comment to be included in a Transfer event.
978     /// @param _sender allowance transfer initiator address.
979     ///
980     /// @return success.
981     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) onlyProxy(_symbol) public returns (uint) {
982         return _transfer(getHolderId(_from), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
983     }
984 }