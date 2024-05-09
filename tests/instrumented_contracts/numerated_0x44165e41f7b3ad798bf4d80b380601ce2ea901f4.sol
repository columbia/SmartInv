1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Owned contract with safe ownership pass.
5  *
6  * Note: all the non constant functions return false instead of throwing in case if state change
7  * didn't happen yet.
8  */
9 contract Owned {
10     /**
11      * Contract owner address
12      */
13     address public contractOwner;
14 
15     /**
16      * Contract owner address
17      */
18     address public pendingContractOwner;
19 
20     function Owned() {
21         contractOwner = msg.sender;
22     }
23 
24     /**
25     * @dev Owner check modifier
26     */
27     modifier onlyContractOwner() {
28         if (contractOwner == msg.sender) {
29             _;
30         }
31     }
32 
33     /**
34      * @dev Destroy contract and scrub a data
35      * @notice Only owner can call it
36      */
37     function destroy() onlyContractOwner {
38         suicide(msg.sender);
39     }
40 
41     /**
42      * Prepares ownership pass.
43      *
44      * Can only be called by current owner.
45      *
46      * @param _to address of the next owner. 0x0 is not allowed.
47      *
48      * @return success.
49      */
50     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
51         if (_to  == 0x0) {
52             return false;
53         }
54 
55         pendingContractOwner = _to;
56         return true;
57     }
58 
59     /**
60      * Finalize ownership pass.
61      *
62      * Can only be called by pending owner.
63      *
64      * @return success.
65      */
66     function claimContractOwnership() returns(bool) {
67         if (pendingContractOwner != msg.sender) {
68             return false;
69         }
70 
71         contractOwner = pendingContractOwner;
72         delete pendingContractOwner;
73 
74         return true;
75     }
76 }
77 
78 contract ERC20Interface {
79     event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed from, address indexed spender, uint256 value);
81     string public symbol;
82 
83     function totalSupply() constant returns (uint256 supply);
84     function balanceOf(address _owner) constant returns (uint256 balance);
85     function transfer(address _to, uint256 _value) returns (bool success);
86     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
87     function approve(address _spender, uint256 _value) returns (bool success);
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
89 }
90 
91 /**
92  * @title Generic owned destroyable contract
93  */
94 contract Object is Owned {
95     /**
96     *  Common result code. Means everything is fine.
97     */
98     uint constant OK = 1;
99     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
100 
101     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
102         for(uint i=0;i<tokens.length;i++) {
103             address token = tokens[i];
104             uint balance = ERC20Interface(token).balanceOf(this);
105             if(balance != 0)
106                 ERC20Interface(token).transfer(_to,balance);
107         }
108         return OK;
109     }
110 
111     function checkOnlyContractOwner() internal constant returns(uint) {
112         if (contractOwner == msg.sender) {
113             return OK;
114         }
115 
116         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
117     }
118 }
119 
120 /**
121 * @title SafeMath
122 * @dev Math operations with safety checks that throw on error
123 */
124 library SafeMath {
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a * b;
127         assert(a == 0 || c / a == b);
128         return c;
129     }
130 
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         // assert(b > 0); // Solidity automatically throws when dividing by 0
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135         return c;
136     }
137 
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         assert(b <= a);
140         return a - b;
141     }
142 
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         assert(c >= a);
146         return c;
147     }
148 }
149 
150 /**
151  * @title General MultiEventsHistory user.
152  *
153  */
154 contract MultiEventsHistoryAdapter {
155 
156     /**
157     *   @dev It is address of MultiEventsHistory caller assuming we are inside of delegate call.
158     */
159     function _self() constant internal returns (address) {
160         return msg.sender;
161     }
162 }
163 
164 /// @title Fund Tokens Platform Emitter.
165 ///
166 /// Contains all the original event emitting function definitions and events.
167 /// In case of new events needed later, additional emitters can be developed.
168 /// All the functions is meant to be called using delegatecall.
169 contract Emitter is MultiEventsHistoryAdapter {
170 
171     event Transfer(address indexed from, address indexed to, bytes32 indexed symbol, uint value, string reference);
172     event Issue(bytes32 indexed symbol, uint value, address indexed by);
173     event Revoke(bytes32 indexed symbol, uint value, address indexed by);
174     event OwnershipChange(address indexed from, address indexed to, bytes32 indexed symbol);
175     event Approve(address indexed from, address indexed spender, bytes32 indexed symbol, uint value);
176     event Recovery(address indexed from, address indexed to, address by);
177     event Error(uint errorCode);
178 
179     function emitTransfer(address _from, address _to, bytes32 _symbol, uint _value, string _reference) public {
180         Transfer(_from, _to, _symbol, _value, _reference);
181     }
182 
183     function emitIssue(bytes32 _symbol, uint _value, address _by) public {
184         Issue(_symbol, _value, _by);
185     }
186 
187     function emitRevoke(bytes32 _symbol, uint _value, address _by) public {
188         Revoke(_symbol, _value, _by);
189     }
190 
191     function emitOwnershipChange(address _from, address _to, bytes32 _symbol) public {
192         OwnershipChange(_from, _to, _symbol);
193     }
194 
195     function emitApprove(address _from, address _spender, bytes32 _symbol, uint _value) public {
196         Approve(_from, _spender, _symbol, _value);
197     }
198 
199     function emitRecovery(address _from, address _to, address _by) public {
200         Recovery(_from, _to, _by);
201     }
202 
203     function emitError(uint _errorCode) public {
204         Error(_errorCode);
205     }
206 }
207 
208 
209 contract ProxyEventsEmitter {
210     function emitTransfer(address _from, address _to, uint _value) public;
211     function emitApprove(address _from, address _spender, uint _value) public;
212 }
213 
214 
215 /// @title Fund Tokens Platform.
216 ///
217 /// Platform uses MultiEventsHistory contract to keep events, so that in case it needs to be redeployed
218 /// at some point, all the events keep appearing at the same place.
219 ///
220 /// Every asset is meant to be used through a proxy contract. Only one proxy contract have access
221 /// rights for a particular asset.
222 ///
223 /// Features: transfers, allowances, supply adjustments, lost wallet access recovery.
224 ///
225 /// Note: all the non constant functions return false instead of throwing in case if state change
226 /// didn't happen yet.
227 /// BMCPlatformInterface compatibility
228 contract ATxPlatform is Object, Emitter {
229 
230     uint constant ATX_PLATFORM_SCOPE = 80000;
231     uint constant ATX_PLATFORM_PROXY_ALREADY_EXISTS = ATX_PLATFORM_SCOPE + 1;
232     uint constant ATX_PLATFORM_CANNOT_APPLY_TO_ONESELF = ATX_PLATFORM_SCOPE + 2;
233     uint constant ATX_PLATFORM_INVALID_VALUE = ATX_PLATFORM_SCOPE + 3;
234     uint constant ATX_PLATFORM_INSUFFICIENT_BALANCE = ATX_PLATFORM_SCOPE + 4;
235     uint constant ATX_PLATFORM_NOT_ENOUGH_ALLOWANCE = ATX_PLATFORM_SCOPE + 5;
236     uint constant ATX_PLATFORM_ASSET_ALREADY_ISSUED = ATX_PLATFORM_SCOPE + 6;
237     uint constant ATX_PLATFORM_CANNOT_ISSUE_FIXED_ASSET_WITH_INVALID_VALUE = ATX_PLATFORM_SCOPE + 7;
238     uint constant ATX_PLATFORM_CANNOT_REISSUE_FIXED_ASSET = ATX_PLATFORM_SCOPE + 8;
239     uint constant ATX_PLATFORM_SUPPLY_OVERFLOW = ATX_PLATFORM_SCOPE + 9;
240     uint constant ATX_PLATFORM_NOT_ENOUGH_TOKENS = ATX_PLATFORM_SCOPE + 10;
241     uint constant ATX_PLATFORM_INVALID_NEW_OWNER = ATX_PLATFORM_SCOPE + 11;
242     uint constant ATX_PLATFORM_ALREADY_TRUSTED = ATX_PLATFORM_SCOPE + 12;
243     uint constant ATX_PLATFORM_SHOULD_RECOVER_TO_NEW_ADDRESS = ATX_PLATFORM_SCOPE + 13;
244     uint constant ATX_PLATFORM_ASSET_IS_NOT_ISSUED = ATX_PLATFORM_SCOPE + 14;
245     uint constant ATX_PLATFORM_INVALID_INVOCATION = ATX_PLATFORM_SCOPE + 15;
246 
247     using SafeMath for uint;
248 
249     /// @title Structure of a particular asset.
250     struct Asset {
251         uint owner;                       // Asset's owner id.
252         uint totalSupply;                 // Asset's total supply.
253         string name;                      // Asset's name, for information purposes.
254         string description;               // Asset's description, for information purposes.
255         bool isReissuable;                // Indicates if asset have dynamic or fixed supply.
256         uint8 baseUnit;                   // Proposed number of decimals.
257         mapping(uint => Wallet) wallets;  // Holders wallets.
258         mapping(uint => bool) partowners; // Part-owners of an asset; have less access rights than owner
259     }
260 
261     /// @title Structure of an asset holder wallet for particular asset.
262     struct Wallet {
263         uint balance;
264         mapping(uint => uint) allowance;
265     }
266 
267     /// @title Structure of an asset holder.
268     struct Holder {
269         address addr;                    // Current address of the holder.
270         mapping(address => bool) trust;  // Addresses that are trusted with recovery proocedure.
271     }
272 
273     /// @dev Iterable mapping pattern is used for holders.
274     /// @dev This is an access address mapping. Many addresses may have access to a single holder.
275     uint public holdersCount;
276     mapping(uint => Holder) public holders;
277     mapping(address => uint) holderIndex;
278 
279     /// @dev List of symbols that exist in a platform
280     bytes32[] public symbols;
281 
282     /// @dev Asset symbol to asset mapping.
283     mapping(bytes32 => Asset) public assets;
284 
285     /// @dev Asset symbol to asset proxy mapping.
286     mapping(bytes32 => address) public proxies;
287 
288     /// @dev Co-owners of a platform. Has less access rights than a root contract owner
289     mapping(address => bool) public partowners;
290 
291     /// @dev Should use interface of the emitter, but address of events history.
292     address public eventsHistory;
293 
294     /// @dev Emits Error if called not by asset owner.
295     modifier onlyOwner(bytes32 _symbol) {
296         if (isOwner(msg.sender, _symbol)) {
297             _;
298         }
299     }
300 
301     /// @dev UNAUTHORIZED if called not by one of symbol's partowners or owner
302     modifier onlyOneOfOwners(bytes32 _symbol) {
303         if (hasAssetRights(msg.sender, _symbol)) {
304             _;
305         }
306     }
307 
308     /// @dev UNAUTHORIZED if called not by one of partowners or contract's owner
309     modifier onlyOneOfContractOwners() {
310         if (contractOwner == msg.sender || partowners[msg.sender]) {
311             _;
312         }
313     }
314 
315     /// @dev Emits Error if called not by asset proxy.
316     modifier onlyProxy(bytes32 _symbol) {
317         if (proxies[_symbol] == msg.sender) {
318             _;
319         }
320     }
321 
322     /// @dev Emits Error if _from doesn't trust _to.
323     modifier checkTrust(address _from, address _to) {
324         if (isTrusted(_from, _to)) {
325             _;
326         }
327     }
328 
329     function() payable public {
330         revert();
331     }
332 
333     /// @notice Trust an address to perform recovery procedure for the caller.
334     ///
335     /// @return success.
336     function trust() external returns (uint) {
337         uint fromId = _createHolderId(msg.sender);
338         // Should trust to another address.
339         if (msg.sender == contractOwner) {
340             return _error(ATX_PLATFORM_CANNOT_APPLY_TO_ONESELF);
341         }
342         // Should trust to yet untrusted.
343         if (isTrusted(msg.sender, contractOwner)) {
344             return _error(ATX_PLATFORM_ALREADY_TRUSTED);
345         }
346 
347         holders[fromId].trust[contractOwner] = true;
348         return OK;
349     }
350 
351     /// @notice Revoke trust to perform recovery procedure from an address.
352     ///
353     /// @return success.
354     function distrust() external checkTrust(msg.sender, contractOwner) returns (uint) {
355         holders[getHolderId(msg.sender)].trust[contractOwner] = false;
356         return OK;
357     }
358 
359     /// @notice Adds a co-owner of a contract. Might be more than one co-owner
360     ///
361     /// @dev Allowed to only contract onwer
362     ///
363     /// @param _partowner a co-owner of a contract
364     ///
365     /// @return result code of an operation
366     function addPartOwner(address _partowner) external onlyContractOwner returns (uint) {
367         partowners[_partowner] = true;
368         return OK;
369     }
370 
371     /// @notice emoves a co-owner of a contract
372     ///
373     /// @dev Should be performed only by root contract owner
374     ///
375     /// @param _partowner a co-owner of a contract
376     ///
377     /// @return result code of an operation
378     function removePartOwner(address _partowner) external onlyContractOwner returns (uint) {
379         delete partowners[_partowner];
380         return OK;
381     }
382 
383     /// @notice Sets EventsHstory contract address.
384     ///
385     /// @dev Can be set only by owner.
386     ///
387     /// @param _eventsHistory MultiEventsHistory contract address.
388     ///
389     /// @return success.
390     function setupEventsHistory(address _eventsHistory) external onlyContractOwner returns (uint errorCode) {
391         eventsHistory = _eventsHistory;
392         return OK;
393     }
394 
395     /// @notice Adds a co-owner for an asset with provided symbol.
396     /// @dev Should be performed by a contract owner or its co-owners
397     ///
398     /// @param _symbol asset's symbol
399     /// @param _partowner a co-owner of an asset
400     ///
401     /// @return errorCode result code of an operation
402     function addAssetPartOwner(bytes32 _symbol, address _partowner) external onlyOneOfOwners(_symbol) returns (uint) {
403         uint holderId = _createHolderId(_partowner);
404         assets[_symbol].partowners[holderId] = true;
405         Emitter(eventsHistory).emitOwnershipChange(0x0, _partowner, _symbol);
406         return OK;
407     }
408 
409     /// @notice Removes a co-owner for an asset with provided symbol.
410     /// @dev Should be performed by a contract owner or its co-owners
411     ///
412     /// @param _symbol asset's symbol
413     /// @param _partowner a co-owner of an asset
414     ///
415     /// @return errorCode result code of an operation
416     function removeAssetPartOwner(bytes32 _symbol, address _partowner) external onlyOneOfOwners(_symbol) returns (uint) {
417         uint holderId = getHolderId(_partowner);
418         delete assets[_symbol].partowners[holderId];
419         Emitter(eventsHistory).emitOwnershipChange(_partowner, 0x0, _symbol);
420         return OK;
421     }
422 
423     function massTransfer(address[] addresses, uint[] values, bytes32 _symbol) external onlyOneOfOwners(_symbol) returns (uint errorCode, uint count) {
424         require(addresses.length == values.length);
425         require(_symbol != 0x0);
426 
427         uint senderId = _createHolderId(msg.sender);
428 
429         uint success = 0;
430         for (uint idx = 0; idx < addresses.length && msg.gas > 110000; ++idx) {
431             uint value = values[idx];
432 
433             if (value == 0) {
434                 _error(ATX_PLATFORM_INVALID_VALUE);
435                 continue;
436             }
437 
438             if (_balanceOf(senderId, _symbol) < value) {
439                 _error(ATX_PLATFORM_INSUFFICIENT_BALANCE);
440                 continue;
441             }
442 
443             if (msg.sender == addresses[idx]) {
444                 _error(ATX_PLATFORM_CANNOT_APPLY_TO_ONESELF);
445                 continue;
446             }
447 
448             uint holderId = _createHolderId(addresses[idx]);
449 
450             _transferDirect(senderId, holderId, value, _symbol);
451             Emitter(eventsHistory).emitTransfer(msg.sender, addresses[idx], _symbol, value, "");
452 
453             ++success;
454         }
455 
456         return (OK, success);
457     }
458 
459     /// @notice Provides a cheap way to get number of symbols registered in a platform
460     ///
461     /// @return number of symbols
462     function symbolsCount() public view returns (uint) {
463         return symbols.length;
464     }
465 
466     /// @notice Check asset existance.
467     ///
468     /// @param _symbol asset symbol.
469     ///
470     /// @return asset existance.
471     function isCreated(bytes32 _symbol) public view returns (bool) {
472         return assets[_symbol].owner != 0;
473     }
474 
475     /// @notice Returns asset decimals.
476     ///
477     /// @param _symbol asset symbol.
478     ///
479     /// @return asset decimals.
480     function baseUnit(bytes32 _symbol) public view returns (uint8) {
481         return assets[_symbol].baseUnit;
482     }
483 
484     /// @notice Returns asset name.
485     ///
486     /// @param _symbol asset symbol.
487     ///
488     /// @return asset name.
489     function name(bytes32 _symbol) public view returns (string) {
490         return assets[_symbol].name;
491     }
492 
493     /// @notice Returns asset description.
494     ///
495     /// @param _symbol asset symbol.
496     ///
497     /// @return asset description.
498     function description(bytes32 _symbol) public view returns (string) {
499         return assets[_symbol].description;
500     }
501 
502     /// @notice Returns asset reissuability.
503     ///
504     /// @param _symbol asset symbol.
505     ///
506     /// @return asset reissuability.
507     function isReissuable(bytes32 _symbol) public view returns (bool) {
508         return assets[_symbol].isReissuable;
509     }
510 
511     /// @notice Returns asset owner address.
512     ///
513     /// @param _symbol asset symbol.
514     ///
515     /// @return asset owner address.
516     function owner(bytes32 _symbol) public view returns (address) {
517         return holders[assets[_symbol].owner].addr;
518     }
519 
520     /// @notice Check if specified address has asset owner rights.
521     ///
522     /// @param _owner address to check.
523     /// @param _symbol asset symbol.
524     ///
525     /// @return owner rights availability.
526     function isOwner(address _owner, bytes32 _symbol) public view returns (bool) {
527         return isCreated(_symbol) && (assets[_symbol].owner == getHolderId(_owner));
528     }
529 
530     /// @notice Checks if a specified address has asset owner or co-owner rights.
531     ///
532     /// @param _owner address to check.
533     /// @param _symbol asset symbol.
534     ///
535     /// @return owner rights availability.
536     function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool) {
537         uint holderId = getHolderId(_owner);
538         return isCreated(_symbol) && (assets[_symbol].owner == holderId || assets[_symbol].partowners[holderId]);
539     }
540 
541     /// @notice Returns asset total supply.
542     ///
543     /// @param _symbol asset symbol.
544     ///
545     /// @return asset total supply.
546     function totalSupply(bytes32 _symbol) public view returns (uint) {
547         return assets[_symbol].totalSupply;
548     }
549 
550     /// @notice Returns asset balance for a particular holder.
551     ///
552     /// @param _holder holder address.
553     /// @param _symbol asset symbol.
554     ///
555     /// @return holder balance.
556     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint) {
557         return _balanceOf(getHolderId(_holder), _symbol);
558     }
559 
560     /// @notice Returns asset balance for a particular holder id.
561     ///
562     /// @param _holderId holder id.
563     /// @param _symbol asset symbol.
564     ///
565     /// @return holder balance.
566     function _balanceOf(uint _holderId, bytes32 _symbol) public view returns (uint) {
567         return assets[_symbol].wallets[_holderId].balance;
568     }
569 
570     /// @notice Returns current address for a particular holder id.
571     ///
572     /// @param _holderId holder id.
573     ///
574     /// @return holder address.
575     function _address(uint _holderId) public view returns (address) {
576         return holders[_holderId].addr;
577     }
578 
579     function checkIsAssetPartOwner(bytes32 _symbol, address _partowner) public view returns (bool) {
580         require(_partowner != 0x0);
581         uint holderId = getHolderId(_partowner);
582         return assets[_symbol].partowners[holderId];
583     }
584 
585     /// @notice Sets Proxy contract address for a particular asset.
586     ///
587     /// Can be set only once for each asset, and only by contract owner.
588     ///
589     /// @param _proxyAddress Proxy contract address.
590     /// @param _symbol asset symbol.
591     ///
592     /// @return success.
593     function setProxy(address _proxyAddress, bytes32 _symbol) public onlyOneOfContractOwners returns (uint) {
594         if (proxies[_symbol] != 0x0) {
595             return ATX_PLATFORM_PROXY_ALREADY_EXISTS;
596         }
597         proxies[_symbol] = _proxyAddress;
598         return OK;
599     }
600 
601     /// @notice Returns holder id for the specified address.
602     ///
603     /// @param _holder holder address.
604     ///
605     /// @return holder id.
606     function getHolderId(address _holder) public view returns (uint) {
607         return holderIndex[_holder];
608     }
609 
610     /// @notice Transfers asset balance between holders wallets.
611     ///
612     /// @dev Can only be called by asset proxy.
613     ///
614     /// @param _to holder address to give to.
615     /// @param _value amount to transfer.
616     /// @param _symbol asset symbol.
617     /// @param _reference transfer comment to be included in a Transfer event.
618     /// @param _sender transfer initiator address.
619     ///
620     /// @return success.
621     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) onlyProxy(_symbol) public returns (uint) {
622         return _transfer(getHolderId(_sender), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
623     }
624 
625     /// @notice Issues new asset token on the platform.
626     ///
627     /// Tokens issued with this call go straight to contract owner.
628     /// Each symbol can be issued only once, and only by contract owner.
629     ///
630     /// @param _symbol asset symbol.
631     /// @param _value amount of tokens to issue immediately.
632     /// @param _name name of the asset.
633     /// @param _description description for the asset.
634     /// @param _baseUnit number of decimals.
635     /// @param _isReissuable dynamic or fixed supply.
636     ///
637     /// @return success.
638     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint) {
639         return issueAssetToAddress(_symbol, _value, _name, _description, _baseUnit, _isReissuable, msg.sender);
640     }
641 
642     /// @notice Issues new asset token on the platform.
643     ///
644     /// Tokens issued with this call go straight to contract owner.
645     /// Each symbol can be issued only once, and only by contract owner.
646     ///
647     /// @param _symbol asset symbol.
648     /// @param _value amount of tokens to issue immediately.
649     /// @param _name name of the asset.
650     /// @param _description description for the asset.
651     /// @param _baseUnit number of decimals.
652     /// @param _isReissuable dynamic or fixed supply.
653     /// @param _account address where issued balance will be held
654     ///
655     /// @return success.
656     function issueAssetToAddress(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, address _account) public onlyOneOfContractOwners returns (uint) {
657         // Should have positive value if supply is going to be fixed.
658         if (_value == 0 && !_isReissuable) {
659             return _error(ATX_PLATFORM_CANNOT_ISSUE_FIXED_ASSET_WITH_INVALID_VALUE);
660         }
661         // Should not be issued yet.
662         if (isCreated(_symbol)) {
663             return _error(ATX_PLATFORM_ASSET_ALREADY_ISSUED);
664         }
665         uint holderId = _createHolderId(_account);
666         uint creatorId = _account == msg.sender ? holderId : _createHolderId(msg.sender);
667 
668         symbols.push(_symbol);
669         assets[_symbol] = Asset(creatorId, _value, _name, _description, _isReissuable, _baseUnit);
670         assets[_symbol].wallets[holderId].balance = _value;
671         // Internal Out Of Gas/Throw: revert this transaction too;
672         // Call Stack Depth Limit reached: n/a after HF 4;
673         // Recursive Call: safe, all changes already made.
674         Emitter(eventsHistory).emitIssue(_symbol, _value, _address(holderId));
675         return OK;
676     }
677 
678     /// @notice Issues additional asset tokens if the asset have dynamic supply.
679     ///
680     /// Tokens issued with this call go straight to asset owner.
681     /// Can only be called by asset owner.
682     ///
683     /// @param _symbol asset symbol.
684     /// @param _value amount of additional tokens to issue.
685     ///
686     /// @return success.
687     function reissueAsset(bytes32 _symbol, uint _value) public onlyOneOfOwners(_symbol) returns (uint) {
688         // Should have positive value.
689         if (_value == 0) {
690             return _error(ATX_PLATFORM_INVALID_VALUE);
691         }
692         Asset storage asset = assets[_symbol];
693         // Should have dynamic supply.
694         if (!asset.isReissuable) {
695             return _error(ATX_PLATFORM_CANNOT_REISSUE_FIXED_ASSET);
696         }
697         // Resulting total supply should not overflow.
698         if (asset.totalSupply + _value < asset.totalSupply) {
699             return _error(ATX_PLATFORM_SUPPLY_OVERFLOW);
700         }
701         uint holderId = getHolderId(msg.sender);
702         asset.wallets[holderId].balance = asset.wallets[holderId].balance.add(_value);
703         asset.totalSupply = asset.totalSupply.add(_value);
704         // Internal Out Of Gas/Throw: revert this transaction too;
705         // Call Stack Depth Limit reached: n/a after HF 4;
706         // Recursive Call: safe, all changes already made.
707         Emitter(eventsHistory).emitIssue(_symbol, _value, _address(holderId));
708 
709         _proxyTransferEvent(0, holderId, _value, _symbol);
710 
711         return OK;
712     }
713 
714     /// @notice Destroys specified amount of senders asset tokens.
715     ///
716     /// @param _symbol asset symbol.
717     /// @param _value amount of tokens to destroy.
718     ///
719     /// @return success.
720     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint) {
721         // Should have positive value.
722         if (_value == 0) {
723             return _error(ATX_PLATFORM_INVALID_VALUE);
724         }
725         Asset storage asset = assets[_symbol];
726         uint holderId = getHolderId(msg.sender);
727         // Should have enough tokens.
728         if (asset.wallets[holderId].balance < _value) {
729             return _error(ATX_PLATFORM_NOT_ENOUGH_TOKENS);
730         }
731         asset.wallets[holderId].balance = asset.wallets[holderId].balance.sub(_value);
732         asset.totalSupply = asset.totalSupply.sub(_value);
733         // Internal Out Of Gas/Throw: revert this transaction too;
734         // Call Stack Depth Limit reached: n/a after HF 4;
735         // Recursive Call: safe, all changes already made.
736         Emitter(eventsHistory).emitRevoke(_symbol, _value, _address(holderId));
737         _proxyTransferEvent(holderId, 0, _value, _symbol);
738         return OK;
739     }
740 
741     /// @notice Passes asset ownership to specified address.
742     ///
743     /// Only ownership is changed, balances are not touched.
744     /// Can only be called by asset owner.
745     ///
746     /// @param _symbol asset symbol.
747     /// @param _newOwner address to become a new owner.
748     ///
749     /// @return success.
750     function changeOwnership(bytes32 _symbol, address _newOwner) public onlyOwner(_symbol) returns (uint) {
751         if (_newOwner == 0x0) {
752             return _error(ATX_PLATFORM_INVALID_NEW_OWNER);
753         }
754 
755         Asset storage asset = assets[_symbol];
756         uint newOwnerId = _createHolderId(_newOwner);
757         // Should pass ownership to another holder.
758         if (asset.owner == newOwnerId) {
759             return _error(ATX_PLATFORM_CANNOT_APPLY_TO_ONESELF);
760         }
761         address oldOwner = _address(asset.owner);
762         asset.owner = newOwnerId;
763         // Internal Out Of Gas/Throw: revert this transaction too;
764         // Call Stack Depth Limit reached: n/a after HF 4;
765         // Recursive Call: safe, all changes already made.
766         Emitter(eventsHistory).emitOwnershipChange(oldOwner, _newOwner, _symbol);
767         return OK;
768     }
769 
770     /// @notice Check if specified holder trusts an address with recovery procedure.
771     ///
772     /// @param _from truster.
773     /// @param _to trustee.
774     ///
775     /// @return trust existance.
776     function isTrusted(address _from, address _to) public view returns (bool) {
777         return holders[getHolderId(_from)].trust[_to];
778     }
779 
780     /// @notice Perform recovery procedure.
781     ///
782     /// Can be invoked by contract owner if he is trusted by sender only.
783     ///
784     /// This function logic is actually more of an addAccess(uint _holderId, address _to).
785     /// It grants another address access to recovery subject wallets.
786     /// Can only be called by trustee of recovery subject.
787     ///
788     /// @param _from holder address to recover from.
789     /// @param _to address to grant access to.
790     ///
791     /// @return success.
792     function recover(address _from, address _to) checkTrust(_from, msg.sender) public onlyContractOwner returns (uint errorCode) {
793         // We take current holder address because it might not equal _from.
794         // It is possible to recover from any old holder address, but event should have the current one.
795         address from = holders[getHolderId(_from)].addr;
796         holders[getHolderId(_from)].addr = _to;
797         holderIndex[_to] = getHolderId(_from);
798         // Internal Out Of Gas/Throw: revert this transaction too;
799         // Call Stack Depth Limit reached: revert this transaction too;
800         // Recursive Call: safe, all changes already made.
801         Emitter(eventsHistory).emitRecovery(from, _to, msg.sender);
802         return OK;
803     }
804 
805     /// @notice Sets asset spending allowance for a specified spender.
806     ///
807     /// @dev Can only be called by asset proxy.
808     ///
809     /// @param _spender holder address to set allowance to.
810     /// @param _value amount to allow.
811     /// @param _symbol asset symbol.
812     /// @param _sender approve initiator address.
813     ///
814     /// @return success.
815     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public onlyProxy(_symbol) returns (uint) {
816         return _approve(_createHolderId(_spender), _value, _symbol, _createHolderId(_sender));
817     }
818 
819     /// @notice Returns asset allowance from one holder to another.
820     ///
821     /// @param _from holder that allowed spending.
822     /// @param _spender holder that is allowed to spend.
823     /// @param _symbol asset symbol.
824     ///
825     /// @return holder to spender allowance.
826     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint) {
827         return _allowance(getHolderId(_from), getHolderId(_spender), _symbol);
828     }
829 
830     /// @notice Prforms allowance transfer of asset balance between holders wallets.
831     ///
832     /// @dev Can only be called by asset proxy.
833     ///
834     /// @param _from holder address to take from.
835     /// @param _to holder address to give to.
836     /// @param _value amount to transfer.
837     /// @param _symbol asset symbol.
838     /// @param _reference transfer comment to be included in a Transfer event.
839     /// @param _sender allowance transfer initiator address.
840     ///
841     /// @return success.
842     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public onlyProxy(_symbol) returns (uint) {
843         return _transfer(getHolderId(_from), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
844     }
845 
846     /// @notice Transfers asset balance between holders wallets.
847     ///
848     /// @param _fromId holder id to take from.
849     /// @param _toId holder id to give to.
850     /// @param _value amount to transfer.
851     /// @param _symbol asset symbol.
852     function _transferDirect(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
853         assets[_symbol].wallets[_fromId].balance = assets[_symbol].wallets[_fromId].balance.sub(_value);
854         assets[_symbol].wallets[_toId].balance = assets[_symbol].wallets[_toId].balance.add(_value);
855     }
856 
857     /// @notice Transfers asset balance between holders wallets.
858     ///
859     /// @dev Performs sanity checks and takes care of allowances adjustment.
860     ///
861     /// @param _fromId holder id to take from.
862     /// @param _toId holder id to give to.
863     /// @param _value amount to transfer.
864     /// @param _symbol asset symbol.
865     /// @param _reference transfer comment to be included in a Transfer event.
866     /// @param _senderId transfer initiator holder id.
867     ///
868     /// @return success.
869     function _transfer(uint _fromId, uint _toId, uint _value, bytes32 _symbol, string _reference, uint _senderId) internal returns (uint) {
870         // Should not allow to send to oneself.
871         if (_fromId == _toId) {
872             return _error(ATX_PLATFORM_CANNOT_APPLY_TO_ONESELF);
873         }
874         // Should have positive value.
875         if (_value == 0) {
876             return _error(ATX_PLATFORM_INVALID_VALUE);
877         }
878         // Should have enough balance.
879         if (_balanceOf(_fromId, _symbol) < _value) {
880             return _error(ATX_PLATFORM_INSUFFICIENT_BALANCE);
881         }
882         // Should have enough allowance.
883         if (_fromId != _senderId && _allowance(_fromId, _senderId, _symbol) < _value) {
884             return _error(ATX_PLATFORM_NOT_ENOUGH_ALLOWANCE);
885         }
886 
887         _transferDirect(_fromId, _toId, _value, _symbol);
888         // Adjust allowance.
889         if (_fromId != _senderId) {
890             assets[_symbol].wallets[_fromId].allowance[_senderId] = assets[_symbol].wallets[_fromId].allowance[_senderId].sub(_value);
891         }
892         // Internal Out Of Gas/Throw: revert this transaction too;
893         // Call Stack Depth Limit reached: n/a after HF 4;
894         // Recursive Call: safe, all changes already made.
895         Emitter(eventsHistory).emitTransfer(_address(_fromId), _address(_toId), _symbol, _value, _reference);
896         _proxyTransferEvent(_fromId, _toId, _value, _symbol);
897         return OK;
898     }
899 
900     /// @notice Ask asset Proxy contract to emit ERC20 compliant Transfer event.
901     ///
902     /// @param _fromId holder id to take from.
903     /// @param _toId holder id to give to.
904     /// @param _value amount to transfer.
905     /// @param _symbol asset symbol.
906     function _proxyTransferEvent(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
907         if (proxies[_symbol] != 0x0) {
908             // Internal Out Of Gas/Throw: revert this transaction too;
909             // Call Stack Depth Limit reached: n/a after HF 4;
910             // Recursive Call: safe, all changes already made.
911             ProxyEventsEmitter(proxies[_symbol]).emitTransfer(_address(_fromId), _address(_toId), _value);
912         }
913     }
914 
915     /// @notice Returns holder id for the specified address, creates it if needed.
916     ///
917     /// @param _holder holder address.
918     ///
919     /// @return holder id.
920     function _createHolderId(address _holder) internal returns (uint) {
921         uint holderId = holderIndex[_holder];
922         if (holderId == 0) {
923             holderId = ++holdersCount;
924             holders[holderId].addr = _holder;
925             holderIndex[_holder] = holderId;
926         }
927         return holderId;
928     }
929 
930     /// @notice Sets asset spending allowance for a specified spender.
931     ///
932     /// Note: to revoke allowance, one needs to set allowance to 0.
933     ///
934     /// @param _spenderId holder id to set allowance for.
935     /// @param _value amount to allow.
936     /// @param _symbol asset symbol.
937     /// @param _senderId approve initiator holder id.
938     ///
939     /// @return success.
940     function _approve(uint _spenderId, uint _value, bytes32 _symbol, uint _senderId) internal returns (uint) {
941         // Asset should exist.
942         if (!isCreated(_symbol)) {
943             return _error(ATX_PLATFORM_ASSET_IS_NOT_ISSUED);
944         }
945         // Should allow to another holder.
946         if (_senderId == _spenderId) {
947             return _error(ATX_PLATFORM_CANNOT_APPLY_TO_ONESELF);
948         }
949 
950         // Double Spend Attack checkpoint
951         if (assets[_symbol].wallets[_senderId].allowance[_spenderId] != 0 && _value != 0) {
952             return _error(ATX_PLATFORM_INVALID_INVOCATION);
953         }
954 
955         assets[_symbol].wallets[_senderId].allowance[_spenderId] = _value;
956 
957         // Internal Out Of Gas/Throw: revert this transaction too;
958         // Call Stack Depth Limit reached: revert this transaction too;
959         // Recursive Call: safe, all changes already made.
960         Emitter(eventsHistory).emitApprove(_address(_senderId), _address(_spenderId), _symbol, _value);
961         if (proxies[_symbol] != 0x0) {
962             // Internal Out Of Gas/Throw: revert this transaction too;
963             // Call Stack Depth Limit reached: n/a after HF 4;
964             // Recursive Call: safe, all changes already made.
965             ProxyEventsEmitter(proxies[_symbol]).emitApprove(_address(_senderId), _address(_spenderId), _value);
966         }
967         return OK;
968     }
969 
970     /// @notice Returns asset allowance from one holder to another.
971     ///
972     /// @param _fromId holder id that allowed spending.
973     /// @param _toId holder id that is allowed to spend.
974     /// @param _symbol asset symbol.
975     ///
976     /// @return holder to spender allowance.
977     function _allowance(uint _fromId, uint _toId, bytes32 _symbol) internal view returns (uint) {
978         return assets[_symbol].wallets[_fromId].allowance[_toId];
979     }
980 
981     /// @dev Emits Error event with specified error message.
982     /// Should only be used if no state changes happened.
983     /// @param _errorCode code of an error
984     function _error(uint _errorCode) internal returns (uint) {
985         Emitter(eventsHistory).emitError(_errorCode);
986         return _errorCode;
987     }
988 }