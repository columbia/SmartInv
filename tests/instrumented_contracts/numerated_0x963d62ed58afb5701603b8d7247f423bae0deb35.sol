1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title General MultiEventsHistory user.
5  *
6  */
7 contract MultiEventsHistoryAdapter {
8 
9     /**
10     *   @dev It is address of MultiEventsHistory caller assuming we are inside of delegate call.
11     */
12     function _self() constant internal returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 /// @title Fund Tokens Platform Emitter.
18 ///
19 /// Contains all the original event emitting function definitions and events.
20 /// In case of new events needed later, additional emitters can be developed.
21 /// All the functions is meant to be called using delegatecall.
22 contract Emitter is MultiEventsHistoryAdapter {
23 
24     event Transfer(address indexed from, address indexed to, bytes32 indexed symbol, uint value, string reference);
25     event Issue(bytes32 indexed symbol, uint value, address indexed by);
26     event Revoke(bytes32 indexed symbol, uint value, address indexed by);
27     event OwnershipChange(address indexed from, address indexed to, bytes32 indexed symbol);
28     event Approve(address indexed from, address indexed spender, bytes32 indexed symbol, uint value);
29     event Recovery(address indexed from, address indexed to, address by);
30     event Error(uint errorCode);
31 
32     function emitTransfer(address _from, address _to, bytes32 _symbol, uint _value, string _reference) public {
33         Transfer(_from, _to, _symbol, _value, _reference);
34     }
35 
36     function emitIssue(bytes32 _symbol, uint _value, address _by) public {
37         Issue(_symbol, _value, _by);
38     }
39 
40     function emitRevoke(bytes32 _symbol, uint _value, address _by) public {
41         Revoke(_symbol, _value, _by);
42     }
43 
44     function emitOwnershipChange(address _from, address _to, bytes32 _symbol) public {
45         OwnershipChange(_from, _to, _symbol);
46     }
47 
48     function emitApprove(address _from, address _spender, bytes32 _symbol, uint _value) public {
49         Approve(_from, _spender, _symbol, _value);
50     }
51 
52     function emitRecovery(address _from, address _to, address _by) public {
53         Recovery(_from, _to, _by);
54     }
55 
56     function emitError(uint _errorCode) public {
57         Error(_errorCode);
58     }
59 }
60 
61 /**
62  * @title Owned contract with safe ownership pass.
63  *
64  * Note: all the non constant functions return false instead of throwing in case if state change
65  * didn't happen yet.
66  */
67 contract Owned {
68     /**
69      * Contract owner address
70      */
71     address public contractOwner;
72 
73     /**
74      * Contract owner address
75      */
76     address public pendingContractOwner;
77 
78     function Owned() {
79         contractOwner = msg.sender;
80     }
81 
82     /**
83     * @dev Owner check modifier
84     */
85     modifier onlyContractOwner() {
86         if (contractOwner == msg.sender) {
87             _;
88         }
89     }
90 
91     /**
92      * @dev Destroy contract and scrub a data
93      * @notice Only owner can call it
94      */
95     function destroy() onlyContractOwner {
96         suicide(msg.sender);
97     }
98 
99     /**
100      * Prepares ownership pass.
101      *
102      * Can only be called by current owner.
103      *
104      * @param _to address of the next owner. 0x0 is not allowed.
105      *
106      * @return success.
107      */
108     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
109         if (_to  == 0x0) {
110             return false;
111         }
112 
113         pendingContractOwner = _to;
114         return true;
115     }
116 
117     /**
118      * Finalize ownership pass.
119      *
120      * Can only be called by pending owner.
121      *
122      * @return success.
123      */
124     function claimContractOwnership() returns(bool) {
125         if (pendingContractOwner != msg.sender) {
126             return false;
127         }
128 
129         contractOwner = pendingContractOwner;
130         delete pendingContractOwner;
131 
132         return true;
133     }
134 }
135 
136 contract ERC20Interface {
137     event Transfer(address indexed from, address indexed to, uint256 value);
138     event Approval(address indexed from, address indexed spender, uint256 value);
139     string public symbol;
140 
141     function totalSupply() constant returns (uint256 supply);
142     function balanceOf(address _owner) constant returns (uint256 balance);
143     function transfer(address _to, uint256 _value) returns (bool success);
144     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
145     function approve(address _spender, uint256 _value) returns (bool success);
146     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
147 }
148 
149 
150 /**
151  * @title Generic owned destroyable contract
152  */
153 contract Object is Owned {
154     /**
155     *  Common result code. Means everything is fine.
156     */
157     uint constant OK = 1;
158     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
159 
160     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
161         for(uint i=0;i<tokens.length;i++) {
162             address token = tokens[i];
163             uint balance = ERC20Interface(token).balanceOf(this);
164             if(balance != 0)
165                 ERC20Interface(token).transfer(_to,balance);
166         }
167         return OK;
168     }
169 
170     function checkOnlyContractOwner() internal constant returns(uint) {
171         if (contractOwner == msg.sender) {
172             return OK;
173         }
174 
175         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
176     }
177 }
178 
179 /**
180 * @title SafeMath
181 * @dev Math operations with safety checks that throw on error
182 */
183 library SafeMath {
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         uint256 c = a * b;
186         assert(a == 0 || c / a == b);
187         return c;
188     }
189 
190     function div(uint256 a, uint256 b) internal pure returns (uint256) {
191         // assert(b > 0); // Solidity automatically throws when dividing by 0
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194         return c;
195     }
196 
197     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
198         assert(b <= a);
199         return a - b;
200     }
201 
202     function add(uint256 a, uint256 b) internal pure returns (uint256) {
203         uint256 c = a + b;
204         assert(c >= a);
205         return c;
206     }
207 }
208 
209 
210 contract ProxyEventsEmitter {
211     function emitTransfer(address _from, address _to, uint _value) public;
212     function emitApprove(address _from, address _spender, uint _value) public;
213 }
214 
215 
216 /// @title Fund Tokens Platform.
217 ///
218 /// Platform uses MultiEventsHistory contract to keep events, so that in case it needs to be redeployed
219 /// at some point, all the events keep appearing at the same place.
220 ///
221 /// Every asset is meant to be used through a proxy contract. Only one proxy contract have access
222 /// rights for a particular asset.
223 ///
224 /// Features: transfers, allowances, supply adjustments, lost wallet access recovery.
225 ///
226 /// Note: all the non constant functions return false instead of throwing in case if state change
227 /// didn't happen yet.
228 /// BMCPlatformInterface compatibility
229 contract ATxPlatform is Object, Emitter {
230 
231     uint constant ATX_PLATFORM_SCOPE = 80000;
232     uint constant ATX_PLATFORM_PROXY_ALREADY_EXISTS = ATX_PLATFORM_SCOPE + 1;
233     uint constant ATX_PLATFORM_CANNOT_APPLY_TO_ONESELF = ATX_PLATFORM_SCOPE + 2;
234     uint constant ATX_PLATFORM_INVALID_VALUE = ATX_PLATFORM_SCOPE + 3;
235     uint constant ATX_PLATFORM_INSUFFICIENT_BALANCE = ATX_PLATFORM_SCOPE + 4;
236     uint constant ATX_PLATFORM_NOT_ENOUGH_ALLOWANCE = ATX_PLATFORM_SCOPE + 5;
237     uint constant ATX_PLATFORM_ASSET_ALREADY_ISSUED = ATX_PLATFORM_SCOPE + 6;
238     uint constant ATX_PLATFORM_CANNOT_ISSUE_FIXED_ASSET_WITH_INVALID_VALUE = ATX_PLATFORM_SCOPE + 7;
239     uint constant ATX_PLATFORM_CANNOT_REISSUE_FIXED_ASSET = ATX_PLATFORM_SCOPE + 8;
240     uint constant ATX_PLATFORM_SUPPLY_OVERFLOW = ATX_PLATFORM_SCOPE + 9;
241     uint constant ATX_PLATFORM_NOT_ENOUGH_TOKENS = ATX_PLATFORM_SCOPE + 10;
242     uint constant ATX_PLATFORM_INVALID_NEW_OWNER = ATX_PLATFORM_SCOPE + 11;
243     uint constant ATX_PLATFORM_ALREADY_TRUSTED = ATX_PLATFORM_SCOPE + 12;
244     uint constant ATX_PLATFORM_SHOULD_RECOVER_TO_NEW_ADDRESS = ATX_PLATFORM_SCOPE + 13;
245     uint constant ATX_PLATFORM_ASSET_IS_NOT_ISSUED = ATX_PLATFORM_SCOPE + 14;
246     uint constant ATX_PLATFORM_INVALID_INVOCATION = ATX_PLATFORM_SCOPE + 15;
247 
248     using SafeMath for uint;
249 
250     /// @title Structure of a particular asset.
251     struct Asset {
252         uint owner;                       // Asset's owner id.
253         uint totalSupply;                 // Asset's total supply.
254         string name;                      // Asset's name, for information purposes.
255         string description;               // Asset's description, for information purposes.
256         bool isReissuable;                // Indicates if asset have dynamic or fixed supply.
257         uint8 baseUnit;                   // Proposed number of decimals.
258         mapping(uint => Wallet) wallets;  // Holders wallets.
259         mapping(uint => bool) partowners; // Part-owners of an asset; have less access rights than owner
260     }
261 
262     /// @title Structure of an asset holder wallet for particular asset.
263     struct Wallet {
264         uint balance;
265         mapping(uint => uint) allowance;
266     }
267 
268     /// @title Structure of an asset holder.
269     struct Holder {
270         address addr;                    // Current address of the holder.
271         mapping(address => bool) trust;  // Addresses that are trusted with recovery proocedure.
272     }
273 
274     /// @dev Iterable mapping pattern is used for holders.
275     /// @dev This is an access address mapping. Many addresses may have access to a single holder.
276     uint public holdersCount;
277     mapping(uint => Holder) public holders;
278     mapping(address => uint) holderIndex;
279 
280     /// @dev List of symbols that exist in a platform
281     bytes32[] public symbols;
282 
283     /// @dev Asset symbol to asset mapping.
284     mapping(bytes32 => Asset) public assets;
285 
286     /// @dev Asset symbol to asset proxy mapping.
287     mapping(bytes32 => address) public proxies;
288 
289     /// @dev Co-owners of a platform. Has less access rights than a root contract owner
290     mapping(address => bool) public partowners;
291 
292     /// @dev Should use interface of the emitter, but address of events history.
293     address public eventsHistory;
294 
295     /// @dev Emits Error if called not by asset owner.
296     modifier onlyOwner(bytes32 _symbol) {
297         if (isOwner(msg.sender, _symbol)) {
298             _;
299         }
300     }
301 
302     /// @dev UNAUTHORIZED if called not by one of symbol's partowners or owner
303     modifier onlyOneOfOwners(bytes32 _symbol) {
304         if (hasAssetRights(msg.sender, _symbol)) {
305             _;
306         }
307     }
308 
309     /// @dev UNAUTHORIZED if called not by one of partowners or contract's owner
310     modifier onlyOneOfContractOwners() {
311         if (contractOwner == msg.sender || partowners[msg.sender]) {
312             _;
313         }
314     }
315 
316     /// @dev Emits Error if called not by asset proxy.
317     modifier onlyProxy(bytes32 _symbol) {
318         if (proxies[_symbol] == msg.sender) {
319             _;
320         }
321     }
322 
323     /// @dev Emits Error if _from doesn't trust _to.
324     modifier checkTrust(address _from, address _to) {
325         if (isTrusted(_from, _to)) {
326             _;
327         }
328     }
329 
330     function() payable public {
331         revert();
332     }
333 
334     /// @notice Trust an address to perform recovery procedure for the caller.
335     ///
336     /// @return success.
337     function trust() external returns (uint) {
338         uint fromId = _createHolderId(msg.sender);
339         // Should trust to another address.
340         if (msg.sender == contractOwner) {
341             return _error(ATX_PLATFORM_CANNOT_APPLY_TO_ONESELF);
342         }
343         // Should trust to yet untrusted.
344         if (isTrusted(msg.sender, contractOwner)) {
345             return _error(ATX_PLATFORM_ALREADY_TRUSTED);
346         }
347 
348         holders[fromId].trust[contractOwner] = true;
349         return OK;
350     }
351 
352     /// @notice Revoke trust to perform recovery procedure from an address.
353     ///
354     /// @return success.
355     function distrust() external checkTrust(msg.sender, contractOwner) returns (uint) {
356         holders[getHolderId(msg.sender)].trust[contractOwner] = false;
357         return OK;
358     }
359 
360     /// @notice Adds a co-owner of a contract. Might be more than one co-owner
361     ///
362     /// @dev Allowed to only contract onwer
363     ///
364     /// @param _partowner a co-owner of a contract
365     ///
366     /// @return result code of an operation
367     function addPartOwner(address _partowner) external onlyContractOwner returns (uint) {
368         partowners[_partowner] = true;
369         return OK;
370     }
371 
372     /// @notice emoves a co-owner of a contract
373     ///
374     /// @dev Should be performed only by root contract owner
375     ///
376     /// @param _partowner a co-owner of a contract
377     ///
378     /// @return result code of an operation
379     function removePartOwner(address _partowner) external onlyContractOwner returns (uint) {
380         delete partowners[_partowner];
381         return OK;
382     }
383 
384     /// @notice Sets EventsHstory contract address.
385     ///
386     /// @dev Can be set only by owner.
387     ///
388     /// @param _eventsHistory MultiEventsHistory contract address.
389     ///
390     /// @return success.
391     function setupEventsHistory(address _eventsHistory) external onlyContractOwner returns (uint errorCode) {
392         eventsHistory = _eventsHistory;
393         return OK;
394     }
395 
396     /// @notice Adds a co-owner for an asset with provided symbol.
397     /// @dev Should be performed by a contract owner or its co-owners
398     ///
399     /// @param _symbol asset's symbol
400     /// @param _partowner a co-owner of an asset
401     ///
402     /// @return errorCode result code of an operation
403     function addAssetPartOwner(bytes32 _symbol, address _partowner) external onlyOneOfOwners(_symbol) returns (uint) {
404         uint holderId = _createHolderId(_partowner);
405         assets[_symbol].partowners[holderId] = true;
406         Emitter(eventsHistory).emitOwnershipChange(0x0, _partowner, _symbol);
407         return OK;
408     }
409 
410     /// @notice Removes a co-owner for an asset with provided symbol.
411     /// @dev Should be performed by a contract owner or its co-owners
412     ///
413     /// @param _symbol asset's symbol
414     /// @param _partowner a co-owner of an asset
415     ///
416     /// @return errorCode result code of an operation
417     function removeAssetPartOwner(bytes32 _symbol, address _partowner) external onlyOneOfOwners(_symbol) returns (uint) {
418         uint holderId = getHolderId(_partowner);
419         delete assets[_symbol].partowners[holderId];
420         Emitter(eventsHistory).emitOwnershipChange(_partowner, 0x0, _symbol);
421         return OK;
422     }
423 
424     function massTransfer(address[] addresses, uint[] values, bytes32 _symbol) external onlyOneOfOwners(_symbol) returns (uint errorCode, uint count) {
425         require(addresses.length == values.length);
426         require(_symbol != 0x0);
427 
428         uint senderId = _createHolderId(msg.sender);
429 
430         uint success = 0;
431         for (uint idx = 0; idx < addresses.length && msg.gas > 110000; ++idx) {
432             uint value = values[idx];
433 
434             if (value == 0) {
435                 _error(ATX_PLATFORM_INVALID_VALUE);
436                 continue;
437             }
438 
439             if (_balanceOf(senderId, _symbol) < value) {
440                 _error(ATX_PLATFORM_INSUFFICIENT_BALANCE);
441                 continue;
442             }
443 
444             if (msg.sender == addresses[idx]) {
445                 _error(ATX_PLATFORM_CANNOT_APPLY_TO_ONESELF);
446                 continue;
447             }
448 
449             uint holderId = _createHolderId(addresses[idx]);
450 
451             _transferDirect(senderId, holderId, value, _symbol);
452             Emitter(eventsHistory).emitTransfer(msg.sender, addresses[idx], _symbol, value, "");
453 
454             ++success;
455         }
456 
457         return (OK, success);
458     }
459 
460     /// @notice Provides a cheap way to get number of symbols registered in a platform
461     ///
462     /// @return number of symbols
463     function symbolsCount() public view returns (uint) {
464         return symbols.length;
465     }
466 
467     /// @notice Check asset existance.
468     ///
469     /// @param _symbol asset symbol.
470     ///
471     /// @return asset existance.
472     function isCreated(bytes32 _symbol) public view returns (bool) {
473         return assets[_symbol].owner != 0;
474     }
475 
476     /// @notice Returns asset decimals.
477     ///
478     /// @param _symbol asset symbol.
479     ///
480     /// @return asset decimals.
481     function baseUnit(bytes32 _symbol) public view returns (uint8) {
482         return assets[_symbol].baseUnit;
483     }
484 
485     /// @notice Returns asset name.
486     ///
487     /// @param _symbol asset symbol.
488     ///
489     /// @return asset name.
490     function name(bytes32 _symbol) public view returns (string) {
491         return assets[_symbol].name;
492     }
493 
494     /// @notice Returns asset description.
495     ///
496     /// @param _symbol asset symbol.
497     ///
498     /// @return asset description.
499     function description(bytes32 _symbol) public view returns (string) {
500         return assets[_symbol].description;
501     }
502 
503     /// @notice Returns asset reissuability.
504     ///
505     /// @param _symbol asset symbol.
506     ///
507     /// @return asset reissuability.
508     function isReissuable(bytes32 _symbol) public view returns (bool) {
509         return assets[_symbol].isReissuable;
510     }
511 
512     /// @notice Returns asset owner address.
513     ///
514     /// @param _symbol asset symbol.
515     ///
516     /// @return asset owner address.
517     function owner(bytes32 _symbol) public view returns (address) {
518         return holders[assets[_symbol].owner].addr;
519     }
520 
521     /// @notice Check if specified address has asset owner rights.
522     ///
523     /// @param _owner address to check.
524     /// @param _symbol asset symbol.
525     ///
526     /// @return owner rights availability.
527     function isOwner(address _owner, bytes32 _symbol) public view returns (bool) {
528         return isCreated(_symbol) && (assets[_symbol].owner == getHolderId(_owner));
529     }
530 
531     /// @notice Checks if a specified address has asset owner or co-owner rights.
532     ///
533     /// @param _owner address to check.
534     /// @param _symbol asset symbol.
535     ///
536     /// @return owner rights availability.
537     function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool) {
538         uint holderId = getHolderId(_owner);
539         return isCreated(_symbol) && (assets[_symbol].owner == holderId || assets[_symbol].partowners[holderId]);
540     }
541 
542     /// @notice Returns asset total supply.
543     ///
544     /// @param _symbol asset symbol.
545     ///
546     /// @return asset total supply.
547     function totalSupply(bytes32 _symbol) public view returns (uint) {
548         return assets[_symbol].totalSupply;
549     }
550 
551     /// @notice Returns asset balance for a particular holder.
552     ///
553     /// @param _holder holder address.
554     /// @param _symbol asset symbol.
555     ///
556     /// @return holder balance.
557     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint) {
558         return _balanceOf(getHolderId(_holder), _symbol);
559     }
560 
561     /// @notice Returns asset balance for a particular holder id.
562     ///
563     /// @param _holderId holder id.
564     /// @param _symbol asset symbol.
565     ///
566     /// @return holder balance.
567     function _balanceOf(uint _holderId, bytes32 _symbol) public view returns (uint) {
568         return assets[_symbol].wallets[_holderId].balance;
569     }
570 
571     /// @notice Returns current address for a particular holder id.
572     ///
573     /// @param _holderId holder id.
574     ///
575     /// @return holder address.
576     function _address(uint _holderId) public view returns (address) {
577         return holders[_holderId].addr;
578     }
579 
580     function checkIsAssetPartOwner(bytes32 _symbol, address _partowner) public view returns (bool) {
581         require(_partowner != 0x0);
582         uint holderId = getHolderId(_partowner);
583         return assets[_symbol].partowners[holderId];
584     }
585 
586     /// @notice Sets Proxy contract address for a particular asset.
587     ///
588     /// Can be set only once for each asset, and only by contract owner.
589     ///
590     /// @param _proxyAddress Proxy contract address.
591     /// @param _symbol asset symbol.
592     ///
593     /// @return success.
594     function setProxy(address _proxyAddress, bytes32 _symbol) public onlyOneOfContractOwners returns (uint) {
595         if (proxies[_symbol] != 0x0) {
596             return ATX_PLATFORM_PROXY_ALREADY_EXISTS;
597         }
598         proxies[_symbol] = _proxyAddress;
599         return OK;
600     }
601 
602     /// @notice Returns holder id for the specified address.
603     ///
604     /// @param _holder holder address.
605     ///
606     /// @return holder id.
607     function getHolderId(address _holder) public view returns (uint) {
608         return holderIndex[_holder];
609     }
610 
611     /// @notice Transfers asset balance between holders wallets.
612     ///
613     /// @dev Can only be called by asset proxy.
614     ///
615     /// @param _to holder address to give to.
616     /// @param _value amount to transfer.
617     /// @param _symbol asset symbol.
618     /// @param _reference transfer comment to be included in a Transfer event.
619     /// @param _sender transfer initiator address.
620     ///
621     /// @return success.
622     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) onlyProxy(_symbol) public returns (uint) {
623         return _transfer(getHolderId(_sender), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
624     }
625 
626     /// @notice Issues new asset token on the platform.
627     ///
628     /// Tokens issued with this call go straight to contract owner.
629     /// Each symbol can be issued only once, and only by contract owner.
630     ///
631     /// @param _symbol asset symbol.
632     /// @param _value amount of tokens to issue immediately.
633     /// @param _name name of the asset.
634     /// @param _description description for the asset.
635     /// @param _baseUnit number of decimals.
636     /// @param _isReissuable dynamic or fixed supply.
637     ///
638     /// @return success.
639     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint) {
640         return issueAssetToAddress(_symbol, _value, _name, _description, _baseUnit, _isReissuable, msg.sender);
641     }
642 
643     /// @notice Issues new asset token on the platform.
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
654     /// @param _account address where issued balance will be held
655     ///
656     /// @return success.
657     function issueAssetToAddress(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, address _account) public onlyOneOfContractOwners returns (uint) {
658         // Should have positive value if supply is going to be fixed.
659         if (_value == 0 && !_isReissuable) {
660             return _error(ATX_PLATFORM_CANNOT_ISSUE_FIXED_ASSET_WITH_INVALID_VALUE);
661         }
662         // Should not be issued yet.
663         if (isCreated(_symbol)) {
664             return _error(ATX_PLATFORM_ASSET_ALREADY_ISSUED);
665         }
666         uint holderId = _createHolderId(_account);
667         uint creatorId = _account == msg.sender ? holderId : _createHolderId(msg.sender);
668 
669         symbols.push(_symbol);
670         assets[_symbol] = Asset(creatorId, _value, _name, _description, _isReissuable, _baseUnit);
671         assets[_symbol].wallets[holderId].balance = _value;
672         // Internal Out Of Gas/Throw: revert this transaction too;
673         // Call Stack Depth Limit reached: n/a after HF 4;
674         // Recursive Call: safe, all changes already made.
675         Emitter(eventsHistory).emitIssue(_symbol, _value, _address(holderId));
676         return OK;
677     }
678 
679     /// @notice Issues additional asset tokens if the asset have dynamic supply.
680     ///
681     /// Tokens issued with this call go straight to asset owner.
682     /// Can only be called by asset owner.
683     ///
684     /// @param _symbol asset symbol.
685     /// @param _value amount of additional tokens to issue.
686     ///
687     /// @return success.
688     function reissueAsset(bytes32 _symbol, uint _value) public onlyOneOfOwners(_symbol) returns (uint) {
689         // Should have positive value.
690         if (_value == 0) {
691             return _error(ATX_PLATFORM_INVALID_VALUE);
692         }
693         Asset storage asset = assets[_symbol];
694         // Should have dynamic supply.
695         if (!asset.isReissuable) {
696             return _error(ATX_PLATFORM_CANNOT_REISSUE_FIXED_ASSET);
697         }
698         // Resulting total supply should not overflow.
699         if (asset.totalSupply + _value < asset.totalSupply) {
700             return _error(ATX_PLATFORM_SUPPLY_OVERFLOW);
701         }
702         uint holderId = getHolderId(msg.sender);
703         asset.wallets[holderId].balance = asset.wallets[holderId].balance.add(_value);
704         asset.totalSupply = asset.totalSupply.add(_value);
705         // Internal Out Of Gas/Throw: revert this transaction too;
706         // Call Stack Depth Limit reached: n/a after HF 4;
707         // Recursive Call: safe, all changes already made.
708         Emitter(eventsHistory).emitIssue(_symbol, _value, _address(holderId));
709 
710         _proxyTransferEvent(0, holderId, _value, _symbol);
711 
712         return OK;
713     }
714 
715     /// @notice Destroys specified amount of senders asset tokens.
716     ///
717     /// @param _symbol asset symbol.
718     /// @param _value amount of tokens to destroy.
719     ///
720     /// @return success.
721     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint) {
722         // Should have positive value.
723         if (_value == 0) {
724             return _error(ATX_PLATFORM_INVALID_VALUE);
725         }
726         Asset storage asset = assets[_symbol];
727         uint holderId = getHolderId(msg.sender);
728         // Should have enough tokens.
729         if (asset.wallets[holderId].balance < _value) {
730             return _error(ATX_PLATFORM_NOT_ENOUGH_TOKENS);
731         }
732         asset.wallets[holderId].balance = asset.wallets[holderId].balance.sub(_value);
733         asset.totalSupply = asset.totalSupply.sub(_value);
734         // Internal Out Of Gas/Throw: revert this transaction too;
735         // Call Stack Depth Limit reached: n/a after HF 4;
736         // Recursive Call: safe, all changes already made.
737         Emitter(eventsHistory).emitRevoke(_symbol, _value, _address(holderId));
738         _proxyTransferEvent(holderId, 0, _value, _symbol);
739         return OK;
740     }
741 
742     /// @notice Passes asset ownership to specified address.
743     ///
744     /// Only ownership is changed, balances are not touched.
745     /// Can only be called by asset owner.
746     ///
747     /// @param _symbol asset symbol.
748     /// @param _newOwner address to become a new owner.
749     ///
750     /// @return success.
751     function changeOwnership(bytes32 _symbol, address _newOwner) public onlyOwner(_symbol) returns (uint) {
752         if (_newOwner == 0x0) {
753             return _error(ATX_PLATFORM_INVALID_NEW_OWNER);
754         }
755 
756         Asset storage asset = assets[_symbol];
757         uint newOwnerId = _createHolderId(_newOwner);
758         // Should pass ownership to another holder.
759         if (asset.owner == newOwnerId) {
760             return _error(ATX_PLATFORM_CANNOT_APPLY_TO_ONESELF);
761         }
762         address oldOwner = _address(asset.owner);
763         asset.owner = newOwnerId;
764         // Internal Out Of Gas/Throw: revert this transaction too;
765         // Call Stack Depth Limit reached: n/a after HF 4;
766         // Recursive Call: safe, all changes already made.
767         Emitter(eventsHistory).emitOwnershipChange(oldOwner, _newOwner, _symbol);
768         return OK;
769     }
770 
771     /// @notice Check if specified holder trusts an address with recovery procedure.
772     ///
773     /// @param _from truster.
774     /// @param _to trustee.
775     ///
776     /// @return trust existance.
777     function isTrusted(address _from, address _to) public view returns (bool) {
778         return holders[getHolderId(_from)].trust[_to];
779     }
780 
781     /// @notice Perform recovery procedure.
782     ///
783     /// Can be invoked by contract owner if he is trusted by sender only.
784     ///
785     /// This function logic is actually more of an addAccess(uint _holderId, address _to).
786     /// It grants another address access to recovery subject wallets.
787     /// Can only be called by trustee of recovery subject.
788     ///
789     /// @param _from holder address to recover from.
790     /// @param _to address to grant access to.
791     ///
792     /// @return success.
793     function recover(address _from, address _to) checkTrust(_from, msg.sender) public onlyContractOwner returns (uint errorCode) {
794         // We take current holder address because it might not equal _from.
795         // It is possible to recover from any old holder address, but event should have the current one.
796         address from = holders[getHolderId(_from)].addr;
797         holders[getHolderId(_from)].addr = _to;
798         holderIndex[_to] = getHolderId(_from);
799         // Internal Out Of Gas/Throw: revert this transaction too;
800         // Call Stack Depth Limit reached: revert this transaction too;
801         // Recursive Call: safe, all changes already made.
802         Emitter(eventsHistory).emitRecovery(from, _to, msg.sender);
803         return OK;
804     }
805 
806     /// @notice Sets asset spending allowance for a specified spender.
807     ///
808     /// @dev Can only be called by asset proxy.
809     ///
810     /// @param _spender holder address to set allowance to.
811     /// @param _value amount to allow.
812     /// @param _symbol asset symbol.
813     /// @param _sender approve initiator address.
814     ///
815     /// @return success.
816     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public onlyProxy(_symbol) returns (uint) {
817         return _approve(_createHolderId(_spender), _value, _symbol, _createHolderId(_sender));
818     }
819 
820     /// @notice Returns asset allowance from one holder to another.
821     ///
822     /// @param _from holder that allowed spending.
823     /// @param _spender holder that is allowed to spend.
824     /// @param _symbol asset symbol.
825     ///
826     /// @return holder to spender allowance.
827     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint) {
828         return _allowance(getHolderId(_from), getHolderId(_spender), _symbol);
829     }
830 
831     /// @notice Prforms allowance transfer of asset balance between holders wallets.
832     ///
833     /// @dev Can only be called by asset proxy.
834     ///
835     /// @param _from holder address to take from.
836     /// @param _to holder address to give to.
837     /// @param _value amount to transfer.
838     /// @param _symbol asset symbol.
839     /// @param _reference transfer comment to be included in a Transfer event.
840     /// @param _sender allowance transfer initiator address.
841     ///
842     /// @return success.
843     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public onlyProxy(_symbol) returns (uint) {
844         return _transfer(getHolderId(_from), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
845     }
846 
847     /// @notice Transfers asset balance between holders wallets.
848     ///
849     /// @param _fromId holder id to take from.
850     /// @param _toId holder id to give to.
851     /// @param _value amount to transfer.
852     /// @param _symbol asset symbol.
853     function _transferDirect(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
854         assets[_symbol].wallets[_fromId].balance = assets[_symbol].wallets[_fromId].balance.sub(_value);
855         assets[_symbol].wallets[_toId].balance = assets[_symbol].wallets[_toId].balance.add(_value);
856     }
857 
858     /// @notice Transfers asset balance between holders wallets.
859     ///
860     /// @dev Performs sanity checks and takes care of allowances adjustment.
861     ///
862     /// @param _fromId holder id to take from.
863     /// @param _toId holder id to give to.
864     /// @param _value amount to transfer.
865     /// @param _symbol asset symbol.
866     /// @param _reference transfer comment to be included in a Transfer event.
867     /// @param _senderId transfer initiator holder id.
868     ///
869     /// @return success.
870     function _transfer(uint _fromId, uint _toId, uint _value, bytes32 _symbol, string _reference, uint _senderId) internal returns (uint) {
871         // Should not allow to send to oneself.
872         if (_fromId == _toId) {
873             return _error(ATX_PLATFORM_CANNOT_APPLY_TO_ONESELF);
874         }
875         // Should have positive value.
876         if (_value == 0) {
877             return _error(ATX_PLATFORM_INVALID_VALUE);
878         }
879         // Should have enough balance.
880         if (_balanceOf(_fromId, _symbol) < _value) {
881             return _error(ATX_PLATFORM_INSUFFICIENT_BALANCE);
882         }
883         // Should have enough allowance.
884         if (_fromId != _senderId && _allowance(_fromId, _senderId, _symbol) < _value) {
885             return _error(ATX_PLATFORM_NOT_ENOUGH_ALLOWANCE);
886         }
887 
888         _transferDirect(_fromId, _toId, _value, _symbol);
889         // Adjust allowance.
890         if (_fromId != _senderId) {
891             assets[_symbol].wallets[_fromId].allowance[_senderId] = assets[_symbol].wallets[_fromId].allowance[_senderId].sub(_value);
892         }
893         // Internal Out Of Gas/Throw: revert this transaction too;
894         // Call Stack Depth Limit reached: n/a after HF 4;
895         // Recursive Call: safe, all changes already made.
896         Emitter(eventsHistory).emitTransfer(_address(_fromId), _address(_toId), _symbol, _value, _reference);
897         _proxyTransferEvent(_fromId, _toId, _value, _symbol);
898         return OK;
899     }
900 
901     /// @notice Ask asset Proxy contract to emit ERC20 compliant Transfer event.
902     ///
903     /// @param _fromId holder id to take from.
904     /// @param _toId holder id to give to.
905     /// @param _value amount to transfer.
906     /// @param _symbol asset symbol.
907     function _proxyTransferEvent(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
908         if (proxies[_symbol] != 0x0) {
909             // Internal Out Of Gas/Throw: revert this transaction too;
910             // Call Stack Depth Limit reached: n/a after HF 4;
911             // Recursive Call: safe, all changes already made.
912             ProxyEventsEmitter(proxies[_symbol]).emitTransfer(_address(_fromId), _address(_toId), _value);
913         }
914     }
915 
916     /// @notice Returns holder id for the specified address, creates it if needed.
917     ///
918     /// @param _holder holder address.
919     ///
920     /// @return holder id.
921     function _createHolderId(address _holder) internal returns (uint) {
922         uint holderId = holderIndex[_holder];
923         if (holderId == 0) {
924             holderId = ++holdersCount;
925             holders[holderId].addr = _holder;
926             holderIndex[_holder] = holderId;
927         }
928         return holderId;
929     }
930 
931     /// @notice Sets asset spending allowance for a specified spender.
932     ///
933     /// Note: to revoke allowance, one needs to set allowance to 0.
934     ///
935     /// @param _spenderId holder id to set allowance for.
936     /// @param _value amount to allow.
937     /// @param _symbol asset symbol.
938     /// @param _senderId approve initiator holder id.
939     ///
940     /// @return success.
941     function _approve(uint _spenderId, uint _value, bytes32 _symbol, uint _senderId) internal returns (uint) {
942         // Asset should exist.
943         if (!isCreated(_symbol)) {
944             return _error(ATX_PLATFORM_ASSET_IS_NOT_ISSUED);
945         }
946         // Should allow to another holder.
947         if (_senderId == _spenderId) {
948             return _error(ATX_PLATFORM_CANNOT_APPLY_TO_ONESELF);
949         }
950 
951         // Double Spend Attack checkpoint
952         if (assets[_symbol].wallets[_senderId].allowance[_spenderId] != 0 && _value != 0) {
953             return _error(ATX_PLATFORM_INVALID_INVOCATION);
954         }
955 
956         assets[_symbol].wallets[_senderId].allowance[_spenderId] = _value;
957 
958         // Internal Out Of Gas/Throw: revert this transaction too;
959         // Call Stack Depth Limit reached: revert this transaction too;
960         // Recursive Call: safe, all changes already made.
961         Emitter(eventsHistory).emitApprove(_address(_senderId), _address(_spenderId), _symbol, _value);
962         if (proxies[_symbol] != 0x0) {
963             // Internal Out Of Gas/Throw: revert this transaction too;
964             // Call Stack Depth Limit reached: n/a after HF 4;
965             // Recursive Call: safe, all changes already made.
966             ProxyEventsEmitter(proxies[_symbol]).emitApprove(_address(_senderId), _address(_spenderId), _value);
967         }
968         return OK;
969     }
970 
971     /// @notice Returns asset allowance from one holder to another.
972     ///
973     /// @param _fromId holder id that allowed spending.
974     /// @param _toId holder id that is allowed to spend.
975     /// @param _symbol asset symbol.
976     ///
977     /// @return holder to spender allowance.
978     function _allowance(uint _fromId, uint _toId, bytes32 _symbol) internal view returns (uint) {
979         return assets[_symbol].wallets[_fromId].allowance[_toId];
980     }
981 
982     /// @dev Emits Error event with specified error message.
983     /// Should only be used if no state changes happened.
984     /// @param _errorCode code of an error
985     function _error(uint _errorCode) internal returns (uint) {
986         Emitter(eventsHistory).emitError(_errorCode);
987         return _errorCode;
988     }
989 }