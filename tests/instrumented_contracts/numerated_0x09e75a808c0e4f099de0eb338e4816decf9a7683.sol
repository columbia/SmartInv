1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4     /**
5      * Contract owner address
6      */
7     address public contractOwner;
8 
9     /**
10      * Contract owner address
11      */
12     address public pendingContractOwner;
13 
14     function Owned() {
15         contractOwner = msg.sender;
16     }
17 
18     /**
19     * @dev Owner check modifier
20     */
21     modifier onlyContractOwner() {
22         if (contractOwner == msg.sender) {
23             _;
24         }
25     }
26 
27     /**
28      * @dev Destroy contract and scrub a data
29      * @notice Only owner can call it
30      */
31     function destroy() onlyContractOwner {
32         suicide(msg.sender);
33     }
34 
35     /**
36      * Prepares ownership pass.
37      *
38      * Can only be called by current owner.
39      *
40      * @param _to address of the next owner. 0x0 is not allowed.
41      *
42      * @return success.
43      */
44     function changeContractOwnership(address _to) onlyContractOwner public returns (bool) {
45         if (_to == 0x0) {
46             return false;
47         }
48 
49         pendingContractOwner = _to;
50         return true;
51     }
52 
53     /**
54      * Finalize ownership pass.
55      *
56      * Can only be called by pending owner.
57      *
58      * @return success.
59      */
60     function claimContractOwnership() public returns (bool) {
61         if (pendingContractOwner != msg.sender) {
62             return false;
63         }
64 
65         contractOwner = pendingContractOwner;
66         delete pendingContractOwner;
67 
68         return true;
69     }
70 
71     /**
72     * @dev Direct ownership pass without change/claim pattern. Can be invoked only by current contract owner
73     *
74     * @param _to the next contract owner
75     *
76     * @return `true` if success, `false` otherwise
77     */
78     function transferContractOwnership(address _to) onlyContractOwner public returns (bool) {
79         if (_to == 0x0) {
80             return false;
81         }
82 
83         if (pendingContractOwner != 0x0) {
84             pendingContractOwner = 0x0;
85         }
86 
87         contractOwner = _to;
88         return true;
89     }
90 }
91 
92 
93 contract ERC20Interface {
94     event Transfer(address indexed from, address indexed to, uint256 value);
95     event Approval(address indexed from, address indexed spender, uint256 value);
96     string public symbol;
97 
98     function totalSupply() constant returns (uint256 supply);
99     function balanceOf(address _owner) constant returns (uint256 balance);
100     function transfer(address _to, uint256 _value) returns (bool success);
101     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
102     function approve(address _spender, uint256 _value) returns (bool success);
103     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
104 }
105 
106 contract Object is Owned {
107     /**
108     *  Common result code. Means everything is fine.
109     */
110     uint constant OK = 1;
111 
112     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
113         for(uint i=0;i<tokens.length;i++) {
114             address token = tokens[i];
115             uint balance = ERC20Interface(token).balanceOf(this);
116             if(balance != 0)
117                 ERC20Interface(token).transfer(_to,balance);
118         }
119         return OK;
120     }
121 }
122 
123 contract MultiEventsHistoryAdapter {
124 
125     /**
126     *   @dev It is address of MultiEventsHistory caller assuming we are inside of delegate call.
127     */
128     function _self() constant internal returns (address) {
129         return msg.sender;
130     }
131 }
132 
133 contract ChronoBankPlatformEmitter is MultiEventsHistoryAdapter {
134     event Transfer(address indexed from, address indexed to, bytes32 indexed symbol, uint value, string reference);
135     event Issue(bytes32 indexed symbol, uint value, address indexed by);
136     event Revoke(bytes32 indexed symbol, uint value, address indexed by);
137     event OwnershipChange(address indexed from, address indexed to, bytes32 indexed symbol);
138     event Approve(address indexed from, address indexed spender, bytes32 indexed symbol, uint value);
139     event Recovery(address indexed from, address indexed to, address by);
140     event Error(uint errorCode);
141 
142     function emitTransfer(address _from, address _to, bytes32 _symbol, uint _value, string _reference) {
143         Transfer(_from, _to, _symbol, _value, _reference);
144     }
145 
146     function emitIssue(bytes32 _symbol, uint _value, address _by) {
147         Issue(_symbol, _value, _by);
148     }
149 
150     function emitRevoke(bytes32 _symbol, uint _value, address _by) {
151         Revoke(_symbol, _value, _by);
152     }
153 
154     function emitOwnershipChange(address _from, address _to, bytes32 _symbol) {
155         OwnershipChange(_from, _to, _symbol);
156     }
157 
158     function emitApprove(address _from, address _spender, bytes32 _symbol, uint _value) {
159         Approve(_from, _spender, _symbol, _value);
160     }
161 
162     function emitRecovery(address _from, address _to, address _by) {
163         Recovery(_from, _to, _by);
164     }
165 
166     function emitError(uint _errorCode) {
167         Error(_errorCode);
168     }
169 }
170 
171 
172 library SafeMath {
173   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
174     uint256 c = a * b;
175     assert(a == 0 || c / a == b);
176     return c;
177   }
178 
179   function div(uint256 a, uint256 b) internal constant returns (uint256) {
180     // assert(b > 0); // Solidity automatically throws when dividing by 0
181     uint256 c = a / b;
182     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
183     return c;
184   }
185 
186   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
187     assert(b <= a);
188     return a - b;
189   }
190 
191   function add(uint256 a, uint256 b) internal constant returns (uint256) {
192     uint256 c = a + b;
193     assert(c >= a);
194     return c;
195   }
196 }
197 
198 contract ProxyEventsEmitter {
199     function emitTransfer(address _from, address _to, uint _value);
200     function emitApprove(address _from, address _spender, uint _value);
201 }
202 
203 
204 contract AssetOwningListener {
205     function assetOwnerAdded(bytes32 _symbol, address _platform, address _owner);
206     function assetOwnerRemoved(bytes32 _symbol, address _platform, address _owner);
207 }
208 
209 /**
210  * @title ChronoBank Platform.
211  *
212  * The official ChronoBank assets platform powering TIME and LHT tokens, and possibly
213  * other unknown tokens needed later.
214  * Platform uses MultiEventsHistory contract to keep events, so that in case it needs to be redeployed
215  * at some point, all the events keep appearing at the same place.
216  *
217  * Every asset is meant to be used through a proxy contract. Only one proxy contract have access
218  * rights for a particular asset.
219  *
220  * Features: transfers, allowances, supply adjustments, lost wallet access recovery.
221  *
222  * Note: all the non constant functions return false instead of throwing in case if state change
223  * didn't happen yet.
224  */
225 contract ChronoBankPlatform is Object, ChronoBankPlatformEmitter {
226     using SafeMath for uint;
227 
228     uint constant CHRONOBANK_PLATFORM_SCOPE = 15000;
229     uint constant CHRONOBANK_PLATFORM_PROXY_ALREADY_EXISTS = CHRONOBANK_PLATFORM_SCOPE + 0;
230     uint constant CHRONOBANK_PLATFORM_CANNOT_APPLY_TO_ONESELF = CHRONOBANK_PLATFORM_SCOPE + 1;
231     uint constant CHRONOBANK_PLATFORM_INVALID_VALUE = CHRONOBANK_PLATFORM_SCOPE + 2;
232     uint constant CHRONOBANK_PLATFORM_INSUFFICIENT_BALANCE = CHRONOBANK_PLATFORM_SCOPE + 3;
233     uint constant CHRONOBANK_PLATFORM_NOT_ENOUGH_ALLOWANCE = CHRONOBANK_PLATFORM_SCOPE + 4;
234     uint constant CHRONOBANK_PLATFORM_ASSET_ALREADY_ISSUED = CHRONOBANK_PLATFORM_SCOPE + 5;
235     uint constant CHRONOBANK_PLATFORM_CANNOT_ISSUE_FIXED_ASSET_WITH_INVALID_VALUE = CHRONOBANK_PLATFORM_SCOPE + 6;
236     uint constant CHRONOBANK_PLATFORM_CANNOT_REISSUE_FIXED_ASSET = CHRONOBANK_PLATFORM_SCOPE + 7;
237     uint constant CHRONOBANK_PLATFORM_SUPPLY_OVERFLOW = CHRONOBANK_PLATFORM_SCOPE + 8;
238     uint constant CHRONOBANK_PLATFORM_NOT_ENOUGH_TOKENS = CHRONOBANK_PLATFORM_SCOPE + 9;
239     uint constant CHRONOBANK_PLATFORM_INVALID_NEW_OWNER = CHRONOBANK_PLATFORM_SCOPE + 10;
240     uint constant CHRONOBANK_PLATFORM_ALREADY_TRUSTED = CHRONOBANK_PLATFORM_SCOPE + 11;
241     uint constant CHRONOBANK_PLATFORM_SHOULD_RECOVER_TO_NEW_ADDRESS = CHRONOBANK_PLATFORM_SCOPE + 12;
242     uint constant CHRONOBANK_PLATFORM_ASSET_IS_NOT_ISSUED = CHRONOBANK_PLATFORM_SCOPE + 13;
243     uint constant CHRONOBANK_PLATFORM_INVALID_INVOCATION = CHRONOBANK_PLATFORM_SCOPE + 17;
244 
245     // Structure of a particular asset.
246     struct Asset {
247         uint owner;                       // Asset's owner id.
248         uint totalSupply;                 // Asset's total supply.
249         string name;                      // Asset's name, for information purposes.
250         string description;               // Asset's description, for information purposes.
251         bool isReissuable;                // Indicates if asset have dynamic or fixed supply.
252         uint8 baseUnit;                   // Proposed number of decimals.
253         mapping(uint => Wallet) wallets;  // Holders wallets.
254         mapping(uint => bool) partowners; // Part-owners of an asset; have less access rights than owner
255     }
256 
257     // Structure of an asset holder wallet for particular asset.
258     struct Wallet {
259         uint balance;
260         mapping(uint => uint) allowance;
261     }
262 
263     // Structure of an asset holder.
264     struct Holder {
265         address addr;                    // Current address of the holder.
266         mapping(address => bool) trust;  // Addresses that are trusted with recovery proocedure.
267     }
268 
269     // Iterable mapping pattern is used for holders.
270     uint public holdersCount;
271     mapping(uint => Holder) public holders;
272 
273     // This is an access address mapping. Many addresses may have access to a single holder.
274     mapping(address => uint) holderIndex;
275 
276     // List of symbols that exist in a platform
277     bytes32[] public symbols;
278 
279     // Asset symbol to asset mapping.
280     mapping(bytes32 => Asset) public assets;
281 
282     // Asset symbol to asset proxy mapping.
283     mapping(bytes32 => address) public proxies;
284 
285     /** Co-owners of a platform. Has less access rights than a root contract owner */
286     mapping(address => bool) public partowners;
287 
288     // Should use interface of the emitter, but address of events history.
289     address public eventsHistory;
290     address public eventsAdmin;
291 
292     address owningListener;
293 
294     /**
295      * Emits Error event with specified error message.
296      *
297      * Should only be used if no state changes happened.
298      *
299      * @param _errorCode code of an error
300      */
301     function _error(uint _errorCode) internal returns(uint) {
302         ChronoBankPlatformEmitter(eventsHistory).emitError(_errorCode);
303         return _errorCode;
304     }
305 
306     /**
307      * Emits Error if called not by asset owner.
308      */
309     modifier onlyOwner(bytes32 _symbol) {
310         if (isOwner(msg.sender, _symbol)) {
311             _;
312         }
313     }
314 
315     /**
316      * Emits Error if called not by asset owner.
317      */
318     modifier onlyEventsAdmin() {
319         if (eventsAdmin == msg.sender || contractOwner == msg.sender) {
320             _;
321         }
322     }
323 
324     /**
325     * @dev UNAUTHORIZED if called not by one of symbol's partowners or owner
326     */
327     modifier onlyOneOfOwners(bytes32 _symbol) {
328         if (hasAssetRights(msg.sender, _symbol)) {
329             _;
330         }
331     }
332 
333     /**
334     * @dev UNAUTHORIZED if called not by one of partowners or contract's owner
335     */
336     modifier onlyOneOfContractOwners() {
337         if (contractOwner == msg.sender || partowners[msg.sender]) {
338             _;
339         }
340     }
341 
342     /**
343      * Emits Error if called not by asset proxy.
344      */
345     modifier onlyProxy(bytes32 _symbol) {
346         if (proxies[_symbol] == msg.sender) {
347             _;
348         }
349     }
350 
351     /**
352      * Emits Error if _from doesn't trust _to.
353      */
354     modifier checkTrust(address _from, address _to) {
355         if (isTrusted(_from, _to)) {
356             _;
357         }
358     }
359 
360     /**
361     * Adds a co-owner of a contract. Might be more than one co-owner
362     * @dev Allowed to only contract onwer
363     *
364     * @param _partowner a co-owner of a contract
365     *
366     * @return result code of an operation
367     */
368     function addPartOwner(address _partowner) onlyContractOwner returns (uint) {
369         partowners[_partowner] = true;
370         return OK;
371     }
372 
373     /**
374     * Removes a co-owner of a contract
375     * @dev Should be performed only by root contract owner
376     *
377     * @param _partowner a co-owner of a contract
378     *
379     * @return result code of an operation
380     */
381     function removePartOwner(address _partowner) onlyContractOwner returns (uint) {
382         delete partowners[_partowner];
383         return OK;
384     }
385 
386     /**
387      * Sets EventsHstory contract address.
388      *
389      * Can be set only by events history admon or owner.
390      *
391      * @param _eventsHistory MultiEventsHistory contract address.
392      *
393      * @return success.
394      */
395     function setupEventsHistory(address _eventsHistory) onlyEventsAdmin returns (uint errorCode) {
396         eventsHistory = _eventsHistory;
397         return OK;
398     }
399 
400     /**
401      * Sets EventsHstory contract admin address.
402      *
403      * Can be set only by contract owner.
404      *
405      * @param _eventsAdmin admin contract address.
406      *
407      * @return success.
408      */
409     function setupEventsAdmin(address _eventsAdmin) onlyContractOwner returns (uint errorCode) {
410         eventsAdmin = _eventsAdmin;
411         return OK;
412     }
413 
414     /**
415     * @dev TODO
416     */
417     function setupAssetOwningListener(address _listener) onlyEventsAdmin public returns (uint) {
418         owningListener = _listener;
419         return OK;
420     }
421 
422     /**
423     * Provides a cheap way to get number of symbols registered in a platform
424     *
425     * @return number of symbols
426     */
427     function symbolsCount() public constant returns (uint) {
428         return symbols.length;
429     }
430 
431     /**
432      * Check asset existance.
433      *
434      * @param _symbol asset symbol.
435      *
436      * @return asset existance.
437      */
438     function isCreated(bytes32 _symbol) constant returns(bool) {
439         return assets[_symbol].owner != 0;
440     }
441 
442     /**
443      * Returns asset decimals.
444      *
445      * @param _symbol asset symbol.
446      *
447      * @return asset decimals.
448      */
449     function baseUnit(bytes32 _symbol) constant returns(uint8) {
450         return assets[_symbol].baseUnit;
451     }
452 
453     /**
454      * Returns asset name.
455      *
456      * @param _symbol asset symbol.
457      *
458      * @return asset name.
459      */
460     function name(bytes32 _symbol) constant returns(string) {
461         return assets[_symbol].name;
462     }
463 
464     /**
465      * Returns asset description.
466      *
467      * @param _symbol asset symbol.
468      *
469      * @return asset description.
470      */
471     function description(bytes32 _symbol) constant returns(string) {
472         return assets[_symbol].description;
473     }
474 
475     /**
476      * Returns asset reissuability.
477      *
478      * @param _symbol asset symbol.
479      *
480      * @return asset reissuability.
481      */
482     function isReissuable(bytes32 _symbol) constant returns(bool) {
483         return assets[_symbol].isReissuable;
484     }
485 
486     /**
487      * Returns asset owner address.
488      *
489      * @param _symbol asset symbol.
490      *
491      * @return asset owner address.
492      */
493     function owner(bytes32 _symbol) constant returns(address) {
494         return holders[assets[_symbol].owner].addr;
495     }
496 
497     /**
498      * Check if specified address has asset owner rights.
499      *
500      * @param _owner address to check.
501      * @param _symbol asset symbol.
502      *
503      * @return owner rights availability.
504      */
505     function isOwner(address _owner, bytes32 _symbol) constant returns(bool) {
506         return isCreated(_symbol) && (assets[_symbol].owner == getHolderId(_owner));
507     }
508 
509     /**
510     * Checks if a specified address has asset owner or co-owner rights.
511     *
512     * @param _owner address to check.
513     * @param _symbol asset symbol.
514     *
515     * @return owner rights availability.
516     */
517     function hasAssetRights(address _owner, bytes32 _symbol) constant returns (bool) {
518         uint holderId = getHolderId(_owner);
519         return isCreated(_symbol) && (assets[_symbol].owner == holderId || assets[_symbol].partowners[holderId]);
520     }
521 
522     /**
523      * Returns asset total supply.
524      *
525      * @param _symbol asset symbol.
526      *
527      * @return asset total supply.
528      */
529     function totalSupply(bytes32 _symbol) constant returns(uint) {
530         return assets[_symbol].totalSupply;
531     }
532 
533     /**
534      * Returns asset balance for a particular holder.
535      *
536      * @param _holder holder address.
537      * @param _symbol asset symbol.
538      *
539      * @return holder balance.
540      */
541     function balanceOf(address _holder, bytes32 _symbol) constant returns(uint) {
542         return _balanceOf(getHolderId(_holder), _symbol);
543     }
544 
545     /**
546      * Returns asset balance for a particular holder id.
547      *
548      * @param _holderId holder id.
549      * @param _symbol asset symbol.
550      *
551      * @return holder balance.
552      */
553     function _balanceOf(uint _holderId, bytes32 _symbol) constant returns(uint) {
554         return assets[_symbol].wallets[_holderId].balance;
555     }
556 
557     /**
558      * Returns current address for a particular holder id.
559      *
560      * @param _holderId holder id.
561      *
562      * @return holder address.
563      */
564     function _address(uint _holderId) constant returns(address) {
565         return holders[_holderId].addr;
566     }
567 
568     /**
569     * Adds a co-owner for an asset with provided symbol.
570     * @dev Should be performed by a contract owner or its co-owners
571     *
572     * @param _symbol asset's symbol
573     * @param _partowner a co-owner of an asset
574     *
575     * @return errorCode result code of an operation
576     */
577     function addAssetPartOwner(bytes32 _symbol, address _partowner) onlyOneOfOwners(_symbol) public returns (uint) {
578         uint holderId = _createHolderId(_partowner);
579         assets[_symbol].partowners[holderId] = true;
580         _delegateAssetOwnerAdded(_symbol, _partowner);
581         ChronoBankPlatformEmitter(eventsHistory).emitOwnershipChange(0x0, _partowner, _symbol);
582         return OK;
583     }
584 
585     /**
586     * Removes a co-owner for an asset with provided symbol.
587     * @dev Should be performed by a contract owner or its co-owners
588     *
589     * @param _symbol asset's symbol
590     * @param _partowner a co-owner of an asset
591     *
592     * @return errorCode result code of an operation
593     */
594     function removeAssetPartOwner(bytes32 _symbol, address _partowner) onlyOneOfOwners(_symbol) public returns (uint) {
595         uint holderId = getHolderId(_partowner);
596         delete assets[_symbol].partowners[holderId];
597         _delegateAssetOwnerRemoved(_symbol, _partowner);
598         ChronoBankPlatformEmitter(eventsHistory).emitOwnershipChange(_partowner, 0x0, _symbol);
599         return OK;
600     }
601 
602     /**
603      * Sets Proxy contract address for a particular asset.
604      *
605      * Can be set only once for each asset, and only by contract owner.
606      *
607      * @param _proxyAddress Proxy contract address.
608      * @param _symbol asset symbol.
609      *
610      * @return success.
611      */
612     function setProxy(address _proxyAddress, bytes32 _symbol) onlyOneOfContractOwners returns(uint) {
613         if (proxies[_symbol] != 0x0) {
614             return CHRONOBANK_PLATFORM_PROXY_ALREADY_EXISTS;
615         }
616 
617         proxies[_symbol] = _proxyAddress;
618         return OK;
619     }
620 
621     /**
622      * Transfers asset balance between holders wallets.
623      *
624      * @param _fromId holder id to take from.
625      * @param _toId holder id to give to.
626      * @param _value amount to transfer.
627      * @param _symbol asset symbol.
628      */
629     function _transferDirect(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
630         assets[_symbol].wallets[_fromId].balance = assets[_symbol].wallets[_fromId].balance.sub(_value);
631         assets[_symbol].wallets[_toId].balance = assets[_symbol].wallets[_toId].balance.add(_value);
632     }
633 
634     /**
635      * Transfers asset balance between holders wallets.
636      *
637      * Performs sanity checks and takes care of allowances adjustment.
638      *
639      * @param _fromId holder id to take from.
640      * @param _toId holder id to give to.
641      * @param _value amount to transfer.
642      * @param _symbol asset symbol.
643      * @param _reference transfer comment to be included in a Transfer event.
644      * @param _senderId transfer initiator holder id.
645      *
646      * @return success.
647      */
648     function _transfer(uint _fromId, uint _toId, uint _value, bytes32 _symbol, string _reference, uint _senderId) internal returns(uint) {
649         // Should not allow to send to oneself.
650         if (_fromId == _toId) {
651             return _error(CHRONOBANK_PLATFORM_CANNOT_APPLY_TO_ONESELF);
652         }
653         // Should have positive value.
654         if (_value == 0) {
655             return _error(CHRONOBANK_PLATFORM_INVALID_VALUE);
656         }
657         // Should have enough balance.
658         if (_balanceOf(_fromId, _symbol) < _value) {
659             return _error(CHRONOBANK_PLATFORM_INSUFFICIENT_BALANCE);
660         }
661         // Should have enough allowance.
662         if (_fromId != _senderId && _allowance(_fromId, _senderId, _symbol) < _value) {
663             return _error(CHRONOBANK_PLATFORM_NOT_ENOUGH_ALLOWANCE);
664         }
665 
666         _transferDirect(_fromId, _toId, _value, _symbol);
667         // Adjust allowance.
668         if (_fromId != _senderId) {
669             assets[_symbol].wallets[_fromId].allowance[_senderId] = assets[_symbol].wallets[_fromId].allowance[_senderId].sub(_value);
670         }
671         // Internal Out Of Gas/Throw: revert this transaction too;
672         // Call Stack Depth Limit reached: n/a after HF 4;
673         // Recursive Call: safe, all changes already made.
674         ChronoBankPlatformEmitter(eventsHistory).emitTransfer(_address(_fromId), _address(_toId), _symbol, _value, _reference);
675         _proxyTransferEvent(_fromId, _toId, _value, _symbol);
676         return OK;
677     }
678 
679     /**
680      * Transfers asset balance between holders wallets.
681      *
682      * Can only be called by asset proxy.
683      *
684      * @param _to holder address to give to.
685      * @param _value amount to transfer.
686      * @param _symbol asset symbol.
687      * @param _reference transfer comment to be included in a Transfer event.
688      * @param _sender transfer initiator address.
689      *
690      * @return success.
691      */
692     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) onlyProxy(_symbol) returns(uint) {
693         return _transfer(getHolderId(_sender), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
694     }
695 
696     /**
697      * Ask asset Proxy contract to emit ERC20 compliant Transfer event.
698      *
699      * @param _fromId holder id to take from.
700      * @param _toId holder id to give to.
701      * @param _value amount to transfer.
702      * @param _symbol asset symbol.
703      */
704     function _proxyTransferEvent(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
705         if (proxies[_symbol] != 0x0) {
706             // Internal Out Of Gas/Throw: revert this transaction too;
707             // Call Stack Depth Limit reached: n/a after HF 4;
708             // Recursive Call: safe, all changes already made.
709             ProxyEventsEmitter(proxies[_symbol]).emitTransfer(_address(_fromId), _address(_toId), _value);
710         }
711     }
712 
713     /**
714      * Returns holder id for the specified address.
715      *
716      * @param _holder holder address.
717      *
718      * @return holder id.
719      */
720     function getHolderId(address _holder) constant returns(uint) {
721         return holderIndex[_holder];
722     }
723 
724     /**
725      * Returns holder id for the specified address, creates it if needed.
726      *
727      * @param _holder holder address.
728      *
729      * @return holder id.
730      */
731     function _createHolderId(address _holder) internal returns(uint) {
732         uint holderId = holderIndex[_holder];
733         if (holderId == 0) {
734             holderId = ++holdersCount;
735             holders[holderId].addr = _holder;
736             holderIndex[_holder] = holderId;
737         }
738         return holderId;
739     }
740 
741     /**
742      * Issues new asset token on the platform.
743      *
744      * Tokens issued with this call go straight to contract owner.
745      * Each symbol can be issued only once, and only by contract owner.
746      *
747      * @param _symbol asset symbol.
748      * @param _value amount of tokens to issue immediately.
749      * @param _name name of the asset.
750      * @param _description description for the asset.
751      * @param _baseUnit number of decimals.
752      * @param _isReissuable dynamic or fixed supply.
753      *
754      * @return success.
755      */
756     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns(uint) {
757         return issueAsset(_symbol, _value, _name, _description, _baseUnit, _isReissuable, msg.sender);
758     }
759 
760     /**
761      * Issues new asset token on the platform.
762      *
763      * Tokens issued with this call go straight to contract owner.
764      * Each symbol can be issued only once, and only by contract owner.
765      *
766      * @param _symbol asset symbol.
767      * @param _value amount of tokens to issue immediately.
768      * @param _name name of the asset.
769      * @param _description description for the asset.
770      * @param _baseUnit number of decimals.
771      * @param _isReissuable dynamic or fixed supply.
772      * @param _account address where issued balance will be held
773      *
774      * @return success.
775      */
776     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, address _account) onlyOneOfContractOwners public returns(uint) {
777         // Should have positive value if supply is going to be fixed.
778         if (_value == 0 && !_isReissuable) {
779             return _error(CHRONOBANK_PLATFORM_CANNOT_ISSUE_FIXED_ASSET_WITH_INVALID_VALUE);
780         }
781         // Should not be issued yet.
782         if (isCreated(_symbol)) {
783             return _error(CHRONOBANK_PLATFORM_ASSET_ALREADY_ISSUED);
784         }
785         uint holderId = _createHolderId(_account);
786         uint creatorId = _account == msg.sender ? holderId : _createHolderId(msg.sender);
787 
788         symbols.push(_symbol);
789         assets[_symbol] = Asset(creatorId, _value, _name, _description, _isReissuable, _baseUnit);
790         assets[_symbol].wallets[holderId].balance = _value;
791         // Internal Out Of Gas/Throw: revert this transaction too;
792         // Call Stack Depth Limit reached: n/a after HF 4;
793         // Recursive Call: safe, all changes already made.
794         _delegateAssetOwnerAdded(_symbol, _address(creatorId));
795         ChronoBankPlatformEmitter(eventsHistory).emitIssue(_symbol, _value, _address(holderId));
796         return OK;
797     }
798 
799     /**
800      * Issues additional asset tokens if the asset have dynamic supply.
801      *
802      * Tokens issued with this call go straight to asset owner.
803      * Can only be called by asset owner.
804      *
805      * @param _symbol asset symbol.
806      * @param _value amount of additional tokens to issue.
807      *
808      * @return success.
809      */
810     function reissueAsset(bytes32 _symbol, uint _value) onlyOneOfOwners(_symbol) public returns(uint) {
811         // Should have positive value.
812         if (_value == 0) {
813             return _error(CHRONOBANK_PLATFORM_INVALID_VALUE);
814         }
815         Asset storage asset = assets[_symbol];
816         // Should have dynamic supply.
817         if (!asset.isReissuable) {
818             return _error(CHRONOBANK_PLATFORM_CANNOT_REISSUE_FIXED_ASSET);
819         }
820         // Resulting total supply should not overflow.
821         if (asset.totalSupply + _value < asset.totalSupply) {
822             return _error(CHRONOBANK_PLATFORM_SUPPLY_OVERFLOW);
823         }
824         uint holderId = getHolderId(msg.sender);
825         asset.wallets[holderId].balance = asset.wallets[holderId].balance.add(_value);
826         asset.totalSupply = asset.totalSupply.add(_value);
827         // Internal Out Of Gas/Throw: revert this transaction too;
828         // Call Stack Depth Limit reached: n/a after HF 4;
829         // Recursive Call: safe, all changes already made.
830         ChronoBankPlatformEmitter(eventsHistory).emitIssue(_symbol, _value, _address(holderId));
831         _proxyTransferEvent(0, holderId, _value, _symbol);
832         return OK;
833     }
834 
835     /**
836      * Destroys specified amount of senders asset tokens.
837      *
838      * @param _symbol asset symbol.
839      * @param _value amount of tokens to destroy.
840      *
841      * @return success.
842      */
843     function revokeAsset(bytes32 _symbol, uint _value) public returns(uint) {
844         // Should have positive value.
845         if (_value == 0) {
846             return _error(CHRONOBANK_PLATFORM_INVALID_VALUE);
847         }
848         Asset storage asset = assets[_symbol];
849         uint holderId = getHolderId(msg.sender);
850         // Should have enough tokens.
851         if (asset.wallets[holderId].balance < _value) {
852             return _error(CHRONOBANK_PLATFORM_NOT_ENOUGH_TOKENS);
853         }
854         asset.wallets[holderId].balance = asset.wallets[holderId].balance.sub(_value);
855         asset.totalSupply = asset.totalSupply.sub(_value);
856         // Internal Out Of Gas/Throw: revert this transaction too;
857         // Call Stack Depth Limit reached: n/a after HF 4;
858         // Recursive Call: safe, all changes already made.
859         ChronoBankPlatformEmitter(eventsHistory).emitRevoke(_symbol, _value, _address(holderId));
860         _proxyTransferEvent(holderId, 0, _value, _symbol);
861         return OK;
862     }
863 
864     /**
865      * Passes asset ownership to specified address.
866      *
867      * Only ownership is changed, balances are not touched.
868      * Can only be called by asset owner.
869      *
870      * @param _symbol asset symbol.
871      * @param _newOwner address to become a new owner.
872      *
873      * @return success.
874      */
875     function changeOwnership(bytes32 _symbol, address _newOwner) onlyOwner(_symbol) public returns(uint) {
876         if (_newOwner == 0x0) {
877             return _error(CHRONOBANK_PLATFORM_INVALID_NEW_OWNER);
878         }
879 
880         Asset storage asset = assets[_symbol];
881         uint newOwnerId = _createHolderId(_newOwner);
882         // Should pass ownership to another holder.
883         if (asset.owner == newOwnerId) {
884             return _error(CHRONOBANK_PLATFORM_CANNOT_APPLY_TO_ONESELF);
885         }
886         address oldOwner = _address(asset.owner);
887         asset.owner = newOwnerId;
888         // Internal Out Of Gas/Throw: revert this transaction too;
889         // Call Stack Depth Limit reached: n/a after HF 4;
890         // Recursive Call: safe, all changes already made.
891         _delegateAssetOwnerRemoved(_symbol, oldOwner);
892         _delegateAssetOwnerAdded(_symbol, _newOwner);
893         ChronoBankPlatformEmitter(eventsHistory).emitOwnershipChange(oldOwner, _newOwner, _symbol);
894         return OK;
895     }
896 
897     /**
898      * Check if specified holder trusts an address with recovery procedure.
899      *
900      * @param _from truster.
901      * @param _to trustee.
902      *
903      * @return trust existance.
904      */
905     function isTrusted(address _from, address _to) constant returns(bool) {
906         return holders[getHolderId(_from)].trust[_to];
907     }
908 
909     /**
910      * Trust an address to perform recovery procedure for the caller.
911      *
912      * @param _to trustee.
913      *
914      * @return success.
915      */
916     function trust(address _to) returns(uint) {
917         uint fromId = _createHolderId(msg.sender);
918         // Should trust to another address.
919         if (fromId == getHolderId(_to)) {
920             return _error(CHRONOBANK_PLATFORM_CANNOT_APPLY_TO_ONESELF);
921         }
922         // Should trust to yet untrusted.
923         if (isTrusted(msg.sender, _to)) {
924             return _error(CHRONOBANK_PLATFORM_ALREADY_TRUSTED);
925         }
926 
927         holders[fromId].trust[_to] = true;
928         return OK;
929     }
930 
931     /**
932      * Revoke trust to perform recovery procedure from an address.
933      *
934      * @param _to trustee.
935      *
936      * @return success.
937      */
938     function distrust(address _to) checkTrust(msg.sender, _to) public returns (uint) {
939         holders[getHolderId(msg.sender)].trust[_to] = false;
940         return OK;
941     }
942 
943     /**
944      * Perform recovery procedure.
945      *
946      * This function logic is actually more of an addAccess(uint _holderId, address _to).
947      * It grants another address access to recovery subject wallets.
948      * Can only be called by trustee of recovery subject.
949      *
950      * @param _from holder address to recover from.
951      * @param _to address to grant access to.
952      *
953      * @return success.
954      */
955     function recover(address _from, address _to) checkTrust(_from, msg.sender) public returns (uint errorCode) {
956         // Should recover to previously unused address.
957         if (getHolderId(_to) != 0) {
958             return _error(CHRONOBANK_PLATFORM_SHOULD_RECOVER_TO_NEW_ADDRESS);
959         }
960         // We take current holder address because it might not equal _from.
961         // It is possible to recover from any old holder address, but event should have the current one.
962         address from = holders[getHolderId(_from)].addr;
963         holders[getHolderId(_from)].addr = _to;
964         holderIndex[_to] = getHolderId(_from);
965         // Internal Out Of Gas/Throw: revert this transaction too;
966         // Call Stack Depth Limit reached: revert this transaction too;
967         // Recursive Call: safe, all changes already made.
968         ChronoBankPlatformEmitter(eventsHistory).emitRecovery(from, _to, msg.sender);
969         return OK;
970     }
971 
972     /**
973      * Sets asset spending allowance for a specified spender.
974      *
975      * Note: to revoke allowance, one needs to set allowance to 0.
976      *
977      * @param _spenderId holder id to set allowance for.
978      * @param _value amount to allow.
979      * @param _symbol asset symbol.
980      * @param _senderId approve initiator holder id.
981      *
982      * @return success.
983      */
984     function _approve(uint _spenderId, uint _value, bytes32 _symbol, uint _senderId) internal returns(uint) {
985         // Asset should exist.
986         if (!isCreated(_symbol)) {
987             return _error(CHRONOBANK_PLATFORM_ASSET_IS_NOT_ISSUED);
988         }
989         // Should allow to another holder.
990         if (_senderId == _spenderId) {
991             return _error(CHRONOBANK_PLATFORM_CANNOT_APPLY_TO_ONESELF);
992         }
993 
994         // Double Spend Attack checkpoint
995         if (assets[_symbol].wallets[_senderId].allowance[_spenderId] != 0 && _value != 0) {
996             return _error(CHRONOBANK_PLATFORM_INVALID_INVOCATION);
997         }
998 
999         assets[_symbol].wallets[_senderId].allowance[_spenderId] = _value;
1000 
1001         // Internal Out Of Gas/Throw: revert this transaction too;
1002         // Call Stack Depth Limit reached: revert this transaction too;
1003         // Recursive Call: safe, all changes already made.
1004         ChronoBankPlatformEmitter(eventsHistory).emitApprove(_address(_senderId), _address(_spenderId), _symbol, _value);
1005         if (proxies[_symbol] != 0x0) {
1006             // Internal Out Of Gas/Throw: revert this transaction too;
1007             // Call Stack Depth Limit reached: n/a after HF 4;
1008             // Recursive Call: safe, all changes already made.
1009             ProxyEventsEmitter(proxies[_symbol]).emitApprove(_address(_senderId), _address(_spenderId), _value);
1010         }
1011         return OK;
1012     }
1013 
1014     /**
1015      * Sets asset spending allowance for a specified spender.
1016      *
1017      * Can only be called by asset proxy.
1018      *
1019      * @param _spender holder address to set allowance to.
1020      * @param _value amount to allow.
1021      * @param _symbol asset symbol.
1022      * @param _sender approve initiator address.
1023      *
1024      * @return success.
1025      */
1026     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) onlyProxy(_symbol) public returns (uint) {
1027         return _approve(_createHolderId(_spender), _value, _symbol, _createHolderId(_sender));
1028     }
1029 
1030     /**
1031      * Returns asset allowance from one holder to another.
1032      *
1033      * @param _from holder that allowed spending.
1034      * @param _spender holder that is allowed to spend.
1035      * @param _symbol asset symbol.
1036      *
1037      * @return holder to spender allowance.
1038      */
1039     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint) {
1040         return _allowance(getHolderId(_from), getHolderId(_spender), _symbol);
1041     }
1042 
1043     /**
1044      * Returns asset allowance from one holder to another.
1045      *
1046      * @param _fromId holder id that allowed spending.
1047      * @param _toId holder id that is allowed to spend.
1048      * @param _symbol asset symbol.
1049      *
1050      * @return holder to spender allowance.
1051      */
1052     function _allowance(uint _fromId, uint _toId, bytes32 _symbol) constant internal returns(uint) {
1053         return assets[_symbol].wallets[_fromId].allowance[_toId];
1054     }
1055 
1056     /**
1057      * Prforms allowance transfer of asset balance between holders wallets.
1058      *
1059      * Can only be called by asset proxy.
1060      *
1061      * @param _from holder address to take from.
1062      * @param _to holder address to give to.
1063      * @param _value amount to transfer.
1064      * @param _symbol asset symbol.
1065      * @param _reference transfer comment to be included in a Transfer event.
1066      * @param _sender allowance transfer initiator address.
1067      *
1068      * @return success.
1069      */
1070     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) onlyProxy(_symbol) public returns (uint) {
1071         return _transfer(getHolderId(_from), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
1072     }
1073 
1074     /**
1075     * @dev TODO
1076     */
1077     function _delegateAssetOwnerAdded(bytes32 _symbol, address _owner) private {
1078         if (owningListener != 0x0) {
1079             AssetOwningListener(owningListener).assetOwnerAdded(_symbol, this, _owner);
1080         }
1081     }
1082 
1083     /**
1084     * @dev TODO
1085     */
1086     function _delegateAssetOwnerRemoved(bytes32 _symbol, address _owner) private {
1087         if (owningListener != 0x0) {
1088             AssetOwningListener(owningListener).assetOwnerRemoved(_symbol, this, _owner);
1089         }
1090     }
1091 }