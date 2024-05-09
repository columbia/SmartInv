1 pragma solidity ^0.4.11;
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
78 
79 contract ERC20Interface {
80     event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(address indexed from, address indexed spender, uint256 value);
82     string public symbol;
83 
84     function totalSupply() constant returns (uint256 supply);
85     function balanceOf(address _owner) constant returns (uint256 balance);
86     function transfer(address _to, uint256 _value) returns (bool success);
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
88     function approve(address _spender, uint256 _value) returns (bool success);
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
90 }
91 
92 /**
93  * @title Generic owned destroyable contract
94  */
95 contract Object is Owned {
96     /**
97     *  Common result code. Means everything is fine.
98     */
99     uint constant OK = 1;
100     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
101 
102     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
103         for(uint i=0;i<tokens.length;i++) {
104             address token = tokens[i];
105             uint balance = ERC20Interface(token).balanceOf(this);
106             if(balance != 0)
107                 ERC20Interface(token).transfer(_to,balance);
108         }
109         return OK;
110     }
111 
112     function checkOnlyContractOwner() internal constant returns(uint) {
113         if (contractOwner == msg.sender) {
114             return OK;
115         }
116 
117         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
118     }
119 }
120 
121 
122 /**
123  * @title General MultiEventsHistory user.
124  *
125  */
126 contract MultiEventsHistoryAdapter {
127 
128     /**
129     *   @dev It is address of MultiEventsHistory caller assuming we are inside of delegate call.
130     */
131     function _self() constant internal returns (address) {
132         return msg.sender;
133     }
134 }
135 
136 /**
137  * @title BMC Platform Emitter.
138  *
139  * Contains all the original event emitting function definitions and events.
140  * In case of new events needed later, additional emitters can be developed.
141  * All the functions is meant to be called using delegatecall.
142  */
143 
144 contract BMCPlatformEmitter is MultiEventsHistoryAdapter {
145     event Transfer(address indexed from, address indexed to, bytes32 indexed symbol, uint value, string reference);
146     event Issue(bytes32 indexed symbol, uint value, address by);
147     event Revoke(bytes32 indexed symbol, uint value, address by);
148     event OwnershipChange(address indexed from, address indexed to, bytes32 indexed symbol);
149     event Approve(address indexed from, address indexed spender, bytes32 indexed symbol, uint value);
150     event Recovery(address indexed from, address indexed to, address by);
151     event Error(bytes32 message);
152 
153     function emitTransfer(address _from, address _to, bytes32 _symbol, uint _value, string _reference) {
154         Transfer(_from, _to, _symbol, _value, _reference);
155     }
156 
157     function emitIssue(bytes32 _symbol, uint _value, address _by) {
158         Issue(_symbol, _value, _by);
159     }
160 
161     function emitRevoke(bytes32 _symbol, uint _value, address _by) {
162         Revoke(_symbol, _value, _by);
163     }
164 
165     function emitOwnershipChange(address _from, address _to, bytes32 _symbol) {
166         OwnershipChange(_from, _to, _symbol);
167     }
168 
169     function emitApprove(address _from, address _spender, bytes32 _symbol, uint _value) {
170         Approve(_from, _spender, _symbol, _value);
171     }
172 
173     function emitRecovery(address _from, address _to, address _by) {
174         Recovery(_from, _to, _by);
175     }
176 
177     function emitError(bytes32 _message) {
178         Error(_message);
179     }
180 }
181 
182 
183 /**
184  * @title SafeMath
185  * @dev Math operations with safety checks that throw on error
186  */
187 library SafeMath {
188   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
189     uint256 c = a * b;
190     assert(a == 0 || c / a == b);
191     return c;
192   }
193 
194   function div(uint256 a, uint256 b) internal constant returns (uint256) {
195     // assert(b > 0); // Solidity automatically throws when dividing by 0
196     uint256 c = a / b;
197     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198     return c;
199   }
200 
201   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
202     assert(b <= a);
203     return a - b;
204   }
205 
206   function add(uint256 a, uint256 b) internal constant returns (uint256) {
207     uint256 c = a + b;
208     assert(c >= a);
209     return c;
210   }
211 }
212 
213 contract Proxy {
214     function emitTransfer(address _from, address _to, uint _value);
215     function emitApprove(address _from, address _spender, uint _value);
216 }
217 
218 /**
219  * @title BMC Platform.
220  *
221  * The official BMC assets platform powering BMC token, and possibly
222  * other unknown tokens needed later.
223  * Platform uses MultiEventsHistory contract to keep events, so that in case it needs to be redeployed
224  * at some point, all the events keep appearing at the same place.
225  *
226  * Every asset is meant to be used through a proxy contract. Only one proxy contract have access
227  * rights for a particular asset.
228  *
229  * Features: transfers, allowances, supply adjustments, lost wallet access recovery.
230  *
231  * Note: all the non constant functions return false instead of throwing in case if state change
232  * didn't happen yet.
233  */
234 contract BMCPlatform is Object, BMCPlatformEmitter {
235 
236     using SafeMath for uint;
237 
238     uint constant BMC_PLATFORM_SCOPE = 15000;
239     uint constant BMC_PLATFORM_PROXY_ALREADY_EXISTS = BMC_PLATFORM_SCOPE + 0;
240     uint constant BMC_PLATFORM_CANNOT_APPLY_TO_ONESELF = BMC_PLATFORM_SCOPE + 1;
241     uint constant BMC_PLATFORM_INVALID_VALUE = BMC_PLATFORM_SCOPE + 2;
242     uint constant BMC_PLATFORM_INSUFFICIENT_BALANCE = BMC_PLATFORM_SCOPE + 3;
243     uint constant BMC_PLATFORM_NOT_ENOUGH_ALLOWANCE = BMC_PLATFORM_SCOPE + 4;
244     uint constant BMC_PLATFORM_ASSET_ALREADY_ISSUED = BMC_PLATFORM_SCOPE + 5;
245     uint constant BMC_PLATFORM_CANNOT_ISSUE_FIXED_ASSET_WITH_INVALID_VALUE = BMC_PLATFORM_SCOPE + 6;
246     uint constant BMC_PLATFORM_CANNOT_REISSUE_FIXED_ASSET = BMC_PLATFORM_SCOPE + 7;
247     uint constant BMC_PLATFORM_SUPPLY_OVERFLOW = BMC_PLATFORM_SCOPE + 8;
248     uint constant BMC_PLATFORM_NOT_ENOUGH_TOKENS = BMC_PLATFORM_SCOPE + 9;
249     uint constant BMC_PLATFORM_INVALID_NEW_OWNER = BMC_PLATFORM_SCOPE + 10;
250     uint constant BMC_PLATFORM_ALREADY_TRUSTED = BMC_PLATFORM_SCOPE + 11;
251     uint constant BMC_PLATFORM_SHOULD_RECOVER_TO_NEW_ADDRESS = BMC_PLATFORM_SCOPE + 12;
252     uint constant BMC_PLATFORM_ASSET_IS_NOT_ISSUED = BMC_PLATFORM_SCOPE + 13;
253     uint constant BMC_PLATFORM_ACCESS_DENIED_ONLY_OWNER = BMC_PLATFORM_SCOPE + 14;
254     uint constant BMC_PLATFORM_ACCESS_DENIED_ONLY_PROXY = BMC_PLATFORM_SCOPE + 15;
255     uint constant BMC_PLATFORM_ACCESS_DENIED_ONLY_TRUSTED = BMC_PLATFORM_SCOPE + 16;
256     uint constant BMC_PLATFORM_INVALID_INVOCATION = BMC_PLATFORM_SCOPE + 17;
257     uint constant BMC_PLATFORM_HOLDER_EXISTS = BMC_PLATFORM_SCOPE + 18;
258 
259     // Structure of a particular asset.
260     struct Asset {
261         uint owner;                       // Asset's owner id.
262         uint totalSupply;                 // Asset's total supply.
263         string name;                      // Asset's name, for information purposes.
264         string description;               // Asset's description, for information purposes.
265         bool isReissuable;                // Indicates if asset have dynamic or fixed supply.
266         uint8 baseUnit;                   // Proposed number of decimals.
267         mapping(uint => Wallet) wallets;  // Holders wallets.
268     }
269 
270     // Structure of an asset holder wallet for particular asset.
271     struct Wallet {
272         uint balance;
273         mapping(uint => uint) allowance;
274     }
275 
276     // Structure of an asset holder.
277     struct Holder {
278         address addr;                    // Current address of the holder.
279         mapping(address => bool) trust;  // Addresses that are trusted with recovery proocedure.
280     }
281 
282     // Iterable mapping pattern is used for holders.
283     uint public holdersCount;
284     mapping(uint => Holder) public holders;
285 
286     // This is an access address mapping. Many addresses may have access to a single holder.
287     mapping(address => uint) holderIndex;
288 
289     // Asset symbol to asset mapping.
290     mapping(bytes32 => Asset) public assets;
291 
292     // Asset symbol to asset proxy mapping.
293     mapping(bytes32 => address) public proxies;
294 
295     // Should use interface of the emitter, but address of events history.
296     address public eventsHistory;
297 
298     /**
299      * Emits Error event with specified error message.
300      *
301      * Should only be used if no state changes happened.
302      *
303      * @param _errorCode code of an error
304      * @param _message error message.
305      */
306     function _error(uint _errorCode, bytes32 _message) internal returns(uint) {
307         BMCPlatformEmitter(eventsHistory).emitError(_message);
308         return _errorCode;
309     }
310 
311     /**
312      * Sets EventsHstory contract address.
313      *
314      * Can be set only once, and only by contract owner.
315      *
316      * @param _eventsHistory MultiEventsHistory contract address.
317      *
318      * @return success.
319      */
320     function setupEventsHistory(address _eventsHistory) returns(uint errorCode) {
321         errorCode = checkOnlyContractOwner();
322         if (errorCode != OK) {
323             return errorCode;
324         }
325         if (eventsHistory != 0x0 && eventsHistory != _eventsHistory) {
326             return BMC_PLATFORM_INVALID_INVOCATION;
327         }
328         eventsHistory = _eventsHistory;
329         return OK;
330     }
331 
332     /**
333      * Emits Error if called not by asset owner.
334      */
335     modifier onlyOwner(bytes32 _symbol) {
336         if (checkIsOnlyOwner(_symbol) == OK) {
337             _;
338         }
339     }
340 
341     /**
342      * Emits Error if called not by asset proxy.
343      */
344     modifier onlyProxy(bytes32 _symbol) {
345         if (checkIsOnlyProxy(_symbol) == OK) {
346             _;
347         }
348     }
349 
350     /**
351      * Emits Error if _from doesn't trust _to.
352      */
353     modifier checkTrust(address _from, address _to) {
354         if (shouldBeTrusted(_from, _to) == OK) {
355             _;
356         }
357     }
358 
359     function checkIsOnlyOwner(bytes32 _symbol) internal constant returns(uint errorCode) {
360         if (isOwner(msg.sender, _symbol)) {
361             return OK;
362         }
363         return _error(BMC_PLATFORM_ACCESS_DENIED_ONLY_OWNER, "Only owner: access denied");
364     }
365 
366     function checkIsOnlyProxy(bytes32 _symbol) internal constant returns(uint errorCode) {
367         if (proxies[_symbol] == msg.sender) {
368             return OK;
369         }
370         return _error(BMC_PLATFORM_ACCESS_DENIED_ONLY_PROXY, "Only proxy: access denied");
371     }
372 
373     function shouldBeTrusted(address _from, address _to) internal constant returns(uint errorCode) {
374         if (isTrusted(_from, _to)) {
375             return OK;
376         }
377         return _error(BMC_PLATFORM_ACCESS_DENIED_ONLY_TRUSTED, "Only trusted: access denied");
378     }
379 
380     /**
381      * Check asset existance.
382      *
383      * @param _symbol asset symbol.
384      *
385      * @return asset existance.
386      */
387     function isCreated(bytes32 _symbol) constant returns(bool) {
388         return assets[_symbol].owner != 0;
389     }
390 
391     /**
392      * Returns asset decimals.
393      *
394      * @param _symbol asset symbol.
395      *
396      * @return asset decimals.
397      */
398     function baseUnit(bytes32 _symbol) constant returns(uint8) {
399         return assets[_symbol].baseUnit;
400     }
401 
402     /**
403      * Returns asset name.
404      *
405      * @param _symbol asset symbol.
406      *
407      * @return asset name.
408      */
409     function name(bytes32 _symbol) constant returns(string) {
410         return assets[_symbol].name;
411     }
412 
413     /**
414      * Returns asset description.
415      *
416      * @param _symbol asset symbol.
417      *
418      * @return asset description.
419      */
420     function description(bytes32 _symbol) constant returns(string) {
421         return assets[_symbol].description;
422     }
423 
424     /**
425      * Returns asset reissuability.
426      *
427      * @param _symbol asset symbol.
428      *
429      * @return asset reissuability.
430      */
431     function isReissuable(bytes32 _symbol) constant returns(bool) {
432         return assets[_symbol].isReissuable;
433     }
434 
435     /**
436      * Returns asset owner address.
437      *
438      * @param _symbol asset symbol.
439      *
440      * @return asset owner address.
441      */
442     function owner(bytes32 _symbol) constant returns(address) {
443         return holders[assets[_symbol].owner].addr;
444     }
445 
446     /**
447      * Check if specified address has asset owner rights.
448      *
449      * @param _owner address to check.
450      * @param _symbol asset symbol.
451      *
452      * @return owner rights availability.
453      */
454     function isOwner(address _owner, bytes32 _symbol) constant returns(bool) {
455         return isCreated(_symbol) && (assets[_symbol].owner == getHolderId(_owner));
456     }
457 
458     /**
459      * Returns asset total supply.
460      *
461      * @param _symbol asset symbol.
462      *
463      * @return asset total supply.
464      */
465     function totalSupply(bytes32 _symbol) constant returns(uint) {
466         return assets[_symbol].totalSupply;
467     }
468 
469     /**
470      * Returns asset balance for a particular holder.
471      *
472      * @param _holder holder address.
473      * @param _symbol asset symbol.
474      *
475      * @return holder balance.
476      */
477     function balanceOf(address _holder, bytes32 _symbol) constant returns(uint) {
478         return _balanceOf(getHolderId(_holder), _symbol);
479     }
480 
481     /**
482      * Returns asset balance for a particular holder id.
483      *
484      * @param _holderId holder id.
485      * @param _symbol asset symbol.
486      *
487      * @return holder balance.
488      */
489     function _balanceOf(uint _holderId, bytes32 _symbol) constant returns(uint) {
490         return assets[_symbol].wallets[_holderId].balance;
491     }
492 
493     /**
494      * Returns current address for a particular holder id.
495      *
496      * @param _holderId holder id.
497      *
498      * @return holder address.
499      */
500     function _address(uint _holderId) constant returns(address) {
501         return holders[_holderId].addr;
502     }
503 
504     /**
505      * Sets Proxy contract address for a particular asset.
506      *
507      * Can be set only once for each asset, and only by contract owner.
508      *
509      * @param _address Proxy contract address.
510      * @param _symbol asset symbol.
511      *
512      * @return success.
513      */
514     function setProxy(address _address, bytes32 _symbol) returns(uint errorCode) {
515         errorCode = checkOnlyContractOwner();
516         if (errorCode != OK) {
517             return errorCode;
518         }
519 
520         if (proxies[_symbol] != 0x0) {
521             return BMC_PLATFORM_PROXY_ALREADY_EXISTS;
522         }
523         proxies[_symbol] = _address;
524         return OK;
525     }
526 
527     function massTransfer(address[] addresses, uint[] values, bytes32 _symbol) external
528     returns (uint errorCode, uint count)
529     {
530         require(checkIsOnlyOwner(_symbol) == OK);
531         require(addresses.length == values.length);
532         require(_symbol != 0x0);
533 
534         // TODO: ahiatsevich checkIsOnlyProxy
535 
536         uint senderId = _createHolderId(msg.sender);
537 
538         uint success = 0;
539         for(uint idx = 0; idx < addresses.length && msg.gas > 110000; idx++) {
540             uint value = values[idx];
541 
542             if (value == 0) {
543                 _error(BMC_PLATFORM_INVALID_VALUE, "Cannot send 0 value");
544                 continue;
545             }
546 
547             if (getHolderId(addresses[idx]) > 0) {
548                 _error(BMC_PLATFORM_HOLDER_EXISTS, "Already transfered");
549                 continue;
550             }
551 
552             if (_balanceOf(senderId, _symbol) < value) {
553                 _error(BMC_PLATFORM_INSUFFICIENT_BALANCE, "Insufficient balance");
554                 continue;
555             }
556 
557             if (msg.sender == addresses[idx]) {
558                 _error(BMC_PLATFORM_CANNOT_APPLY_TO_ONESELF, "Cannot send to oneself");
559                 continue;
560             }
561 
562             uint holderId = _createHolderId(addresses[idx]);
563 
564             _transferDirect(senderId, holderId, value, _symbol);
565             BMCPlatformEmitter(eventsHistory).emitTransfer(msg.sender, addresses[idx], _symbol, value, "");
566             
567             success++;
568         }
569 
570         return (OK, success);
571     }
572 
573     /**
574      * Transfers asset balance between holders wallets.
575      *
576      * @param _fromId holder id to take from.
577      * @param _toId holder id to give to.
578      * @param _value amount to transfer.
579      * @param _symbol asset symbol.
580      */
581     function _transferDirect(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
582         assets[_symbol].wallets[_fromId].balance = assets[_symbol].wallets[_fromId].balance.sub(_value);
583         assets[_symbol].wallets[_toId].balance = assets[_symbol].wallets[_toId].balance.add(_value);
584     }
585 
586     /**
587      * Transfers asset balance between holders wallets.
588      *
589      * Performs sanity checks and takes care of allowances adjustment.
590      *
591      * @param _fromId holder id to take from.
592      * @param _toId holder id to give to.
593      * @param _value amount to transfer.
594      * @param _symbol asset symbol.
595      * @param _reference transfer comment to be included in a Transfer event.
596      * @param _senderId transfer initiator holder id.
597      *
598      * @return success.
599      */
600     function _transfer(uint _fromId, uint _toId, uint _value, bytes32 _symbol, string _reference, uint _senderId) internal returns(uint) {
601         // Should not allow to send to oneself.
602         if (_fromId == _toId) {
603             return _error(BMC_PLATFORM_CANNOT_APPLY_TO_ONESELF, "Cannot send to oneself");
604         }
605         // Should have positive value.
606         if (_value == 0) {
607             return _error(BMC_PLATFORM_INVALID_VALUE, "Cannot send 0 value");
608         }
609         // Should have enough balance.
610         if (_balanceOf(_fromId, _symbol) < _value) {
611             return _error(BMC_PLATFORM_INSUFFICIENT_BALANCE, "Insufficient balance");
612         }
613         // Should have enough allowance.
614         if (_fromId != _senderId && _allowance(_fromId, _senderId, _symbol) < _value) {
615             return _error(BMC_PLATFORM_NOT_ENOUGH_ALLOWANCE, "Not enough allowance");
616         }
617 
618         _transferDirect(_fromId, _toId, _value, _symbol);
619         // Adjust allowance.
620         if (_fromId != _senderId) {
621             uint senderAllowance = assets[_symbol].wallets[_fromId].allowance[_senderId];
622             assets[_symbol].wallets[_fromId].allowance[_senderId] = senderAllowance.sub(_value);
623         }
624         // Internal Out Of Gas/Throw: revert this transaction too;
625         // Call Stack Depth Limit reached: n/a after HF 4;
626         // Recursive Call: safe, all changes already made.
627         BMCPlatformEmitter(eventsHistory).emitTransfer(_address(_fromId), _address(_toId), _symbol, _value, _reference);
628         _proxyTransferEvent(_fromId, _toId, _value, _symbol);
629         return OK;
630     }
631 
632     /**
633      * Transfers asset balance between holders wallets.
634      *
635      * Can only be called by asset proxy.
636      *
637      * @param _to holder address to give to.
638      * @param _value amount to transfer.
639      * @param _symbol asset symbol.
640      * @param _reference transfer comment to be included in a Transfer event.
641      * @param _sender transfer initiator address.
642      *
643      * @return success.
644      */
645     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode) {
646         errorCode = checkIsOnlyProxy(_symbol);
647         if (errorCode != OK) {
648             return errorCode;
649         }
650 
651         return _transfer(getHolderId(_sender), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
652     }
653 
654     /**
655      * Ask asset Proxy contract to emit ERC20 compliant Transfer event.
656      *
657      * @param _fromId holder id to take from.
658      * @param _toId holder id to give to.
659      * @param _value amount to transfer.
660      * @param _symbol asset symbol.
661      */
662     function _proxyTransferEvent(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
663         if (proxies[_symbol] != 0x0) {
664             // Internal Out Of Gas/Throw: revert this transaction too;
665             // Call Stack Depth Limit reached: n/a after HF 4;
666             // Recursive Call: safe, all changes already made.
667             Proxy(proxies[_symbol]).emitTransfer(_address(_fromId), _address(_toId), _value);
668         }
669     }
670 
671     /**
672      * Returns holder id for the specified address.
673      *
674      * @param _holder holder address.
675      *
676      * @return holder id.
677      */
678     function getHolderId(address _holder) constant returns(uint) {
679         return holderIndex[_holder];
680     }
681 
682     /**
683      * Returns holder id for the specified address, creates it if needed.
684      *
685      * @param _holder holder address.
686      *
687      * @return holder id.
688      */
689     function _createHolderId(address _holder) internal returns(uint) {
690         uint holderId = holderIndex[_holder];
691         if (holderId == 0) {
692             holderId = ++holdersCount;
693             holders[holderId].addr = _holder;
694             holderIndex[_holder] = holderId;
695         }
696         return holderId;
697     }
698 
699     /**
700      * Issues new asset token on the platform.
701      *
702      * Tokens issued with this call go straight to contract owner.
703      * Each symbol can be issued only once, and only by contract owner.
704      *
705      * @param _symbol asset symbol.
706      * @param _value amount of tokens to issue immediately.
707      * @param _name name of the asset.
708      * @param _description description for the asset.
709      * @param _baseUnit number of decimals.
710      * @param _isReissuable dynamic or fixed supply.
711      *
712      * @return success.
713      */
714     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) returns(uint errorCode) {
715         errorCode = checkOnlyContractOwner();
716         if (errorCode != OK) {
717             return errorCode;
718         }
719         // Should have positive value if supply is going to be fixed.
720         if (_value == 0 && !_isReissuable) {
721             return _error(BMC_PLATFORM_CANNOT_ISSUE_FIXED_ASSET_WITH_INVALID_VALUE, "Cannot issue 0 value fixed asset");
722         }
723         // Should not be issued yet.
724         if (isCreated(_symbol)) {
725             return _error(BMC_PLATFORM_ASSET_ALREADY_ISSUED, "Asset already issued");
726         }
727         uint holderId = _createHolderId(msg.sender);
728 
729         assets[_symbol] = Asset(holderId, _value, _name, _description, _isReissuable, _baseUnit);
730         assets[_symbol].wallets[holderId].balance = _value;
731         // Internal Out Of Gas/Throw: revert this transaction too;
732         // Call Stack Depth Limit reached: n/a after HF 4;
733         // Recursive Call: safe, all changes already made.
734         BMCPlatformEmitter(eventsHistory).emitIssue(_symbol, _value, _address(holderId));
735         return OK;
736     }
737 
738     /**
739      * Issues additional asset tokens if the asset have dynamic supply.
740      *
741      * Tokens issued with this call go straight to asset owner.
742      * Can only be called by asset owner.
743      *
744      * @param _symbol asset symbol.
745      * @param _value amount of additional tokens to issue.
746      *
747      * @return success.
748      */
749     function reissueAsset(bytes32 _symbol, uint _value) returns(uint errorCode) {
750         errorCode = checkIsOnlyOwner(_symbol);
751         if (errorCode != OK) {
752             return errorCode;
753         }
754         // Should have positive value.
755         if (_value == 0) {
756             return _error(BMC_PLATFORM_INVALID_VALUE, "Cannot reissue 0 value");
757         }
758         Asset asset = assets[_symbol];
759         // Should have dynamic supply.
760         if (!asset.isReissuable) {
761             return _error(BMC_PLATFORM_CANNOT_REISSUE_FIXED_ASSET, "Cannot reissue fixed asset");
762         }
763         // Resulting total supply should not overflow.
764         if (asset.totalSupply + _value < asset.totalSupply) {
765             return _error(BMC_PLATFORM_SUPPLY_OVERFLOW, "Total supply overflow");
766         }
767         uint holderId = getHolderId(msg.sender);
768         asset.wallets[holderId].balance = asset.wallets[holderId].balance.add(_value);
769         asset.totalSupply = asset.totalSupply.add(_value);
770         // Internal Out Of Gas/Throw: revert this transaction too;
771         // Call Stack Depth Limit reached: n/a after HF 4;
772         // Recursive Call: safe, all changes already made.
773         BMCPlatformEmitter(eventsHistory).emitIssue(_symbol, _value, _address(holderId));
774         _proxyTransferEvent(0, holderId, _value, _symbol);
775         return OK;
776     }
777 
778     /**
779      * Destroys specified amount of senders asset tokens.
780      *
781      * @param _symbol asset symbol.
782      * @param _value amount of tokens to destroy.
783      *
784      * @return success.
785      */
786     function revokeAsset(bytes32 _symbol, uint _value) returns(uint) {
787         // Should have positive value.
788         if (_value == 0) {
789             return _error(BMC_PLATFORM_INVALID_VALUE, "Cannot revoke 0 value");
790         }
791         Asset asset = assets[_symbol];
792         uint holderId = getHolderId(msg.sender);
793         // Should have enough tokens.
794         if (asset.wallets[holderId].balance < _value) {
795             return _error(BMC_PLATFORM_NOT_ENOUGH_TOKENS, "Not enough tokens to revoke");
796         }
797         asset.wallets[holderId].balance = asset.wallets[holderId].balance.sub(_value);
798         asset.totalSupply = asset.totalSupply.sub(_value);
799         // Internal Out Of Gas/Throw: revert this transaction too;
800         // Call Stack Depth Limit reached: n/a after HF 4;
801         // Recursive Call: safe, all changes already made.
802         BMCPlatformEmitter(eventsHistory).emitRevoke(_symbol, _value, _address(holderId));
803         _proxyTransferEvent(holderId, 0, _value, _symbol);
804         return OK;
805     }
806 
807     /**
808      * Passes asset ownership to specified address.
809      *
810      * Only ownership is changed, balances are not touched.
811      * Can only be called by asset owner.
812      *
813      * @param _symbol asset symbol.
814      * @param _newOwner address to become a new owner.
815      *
816      * @return success.
817      */
818     function changeOwnership(bytes32 _symbol, address _newOwner) returns(uint errorCode) {
819         errorCode = checkIsOnlyOwner(_symbol);
820         if (errorCode != OK) {
821             return errorCode;
822         }
823 
824         if (_newOwner == 0x0) {
825             return _error(BMC_PLATFORM_INVALID_NEW_OWNER, "Can't change ownership to 0x0");
826         }
827 
828         Asset asset = assets[_symbol];
829         uint newOwnerId = _createHolderId(_newOwner);
830         // Should pass ownership to another holder.
831         if (asset.owner == newOwnerId) {
832             return _error(BMC_PLATFORM_CANNOT_APPLY_TO_ONESELF, "Cannot pass ownership to oneself");
833         }
834         address oldOwner = _address(asset.owner);
835         asset.owner = newOwnerId;
836         // Internal Out Of Gas/Throw: revert this transaction too;
837         // Call Stack Depth Limit reached: n/a after HF 4;
838         // Recursive Call: safe, all changes already made.
839         BMCPlatformEmitter(eventsHistory).emitOwnershipChange(oldOwner, _address(newOwnerId), _symbol);
840         return OK;
841     }
842 
843     /**
844      * Check if specified holder trusts an address with recovery procedure.
845      *
846      * @param _from truster.
847      * @param _to trustee.
848      *
849      * @return trust existance.
850      */
851     function isTrusted(address _from, address _to) constant returns(bool) {
852         return holders[getHolderId(_from)].trust[_to];
853     }
854 
855     /**
856      * Trust an address to perform recovery procedure for the caller.
857      *
858      * @param _to trustee.
859      *
860      * @return success.
861      */
862     function trust(address _to) returns(uint) {
863         uint fromId = _createHolderId(msg.sender);
864         // Should trust to another address.
865         if (fromId == getHolderId(_to)) {
866             return _error(BMC_PLATFORM_CANNOT_APPLY_TO_ONESELF, "Cannot trust to oneself");
867         }
868         // Should trust to yet untrusted.
869         if (isTrusted(msg.sender, _to)) {
870             return _error(BMC_PLATFORM_ALREADY_TRUSTED, "Already trusted");
871         }
872 
873         holders[fromId].trust[_to] = true;
874         return OK;
875     }
876 
877     /**
878      * Revoke trust to perform recovery procedure from an address.
879      *
880      * @param _to trustee.
881      *
882      * @return success.
883      */
884     function distrust(address _to) returns(uint errorCode) {
885         errorCode = shouldBeTrusted(msg.sender, _to);
886         if (errorCode != OK) {
887             return errorCode;
888         }
889         holders[getHolderId(msg.sender)].trust[_to] = false;
890         return OK;
891     }
892 
893     /**
894      * Perform recovery procedure.
895      *
896      * This function logic is actually more of an addAccess(uint _holderId, address _to).
897      * It grants another address access to recovery subject wallets.
898      * Can only be called by trustee of recovery subject.
899      *
900      * @param _from holder address to recover from.
901      * @param _to address to grant access to.
902      *
903      * @return success.
904      */
905     function recover(address _from, address _to) returns(uint errorCode) {
906         errorCode = shouldBeTrusted(_from, msg.sender);
907         if (errorCode != OK) {
908             return errorCode;
909         }
910         // Should recover to previously unused address.
911         if (getHolderId(_to) != 0) {
912             return _error(BMC_PLATFORM_SHOULD_RECOVER_TO_NEW_ADDRESS, "Should recover to new address");
913         }
914         // We take current holder address because it might not equal _from.
915         // It is possible to recover from any old holder address, but event should have the current one.
916         address from = holders[getHolderId(_from)].addr;
917         holders[getHolderId(_from)].addr = _to;
918         holderIndex[_to] = getHolderId(_from);
919         // Internal Out Of Gas/Throw: revert this transaction too;
920         // Call Stack Depth Limit reached: revert this transaction too;
921         // Recursive Call: safe, all changes already made.
922         BMCPlatformEmitter(eventsHistory).emitRecovery(from, _to, msg.sender);
923         return OK;
924     }
925 
926     /**
927      * Sets asset spending allowance for a specified spender.
928      *
929      * Note: to revoke allowance, one needs to set allowance to 0.
930      *
931      * @param _spenderId holder id to set allowance for.
932      * @param _value amount to allow.
933      * @param _symbol asset symbol.
934      * @param _senderId approve initiator holder id.
935      *
936      * @return success.
937      */
938     function _approve(uint _spenderId, uint _value, bytes32 _symbol, uint _senderId) internal returns(uint) {
939         // Asset should exist.
940         if (!isCreated(_symbol)) {
941             return _error(BMC_PLATFORM_ASSET_IS_NOT_ISSUED, "Asset is not issued");
942         }
943         // Should allow to another holder.
944         if (_senderId == _spenderId) {
945             return _error(BMC_PLATFORM_CANNOT_APPLY_TO_ONESELF, "Cannot approve to oneself");
946         }
947         assets[_symbol].wallets[_senderId].allowance[_spenderId] = _value;
948         // Internal Out Of Gas/Throw: revert this transaction too;
949         // Call Stack Depth Limit reached: revert this transaction too;
950         // Recursive Call: safe, all changes already made.
951         BMCPlatformEmitter(eventsHistory).emitApprove(_address(_senderId), _address(_spenderId), _symbol, _value);
952         if (proxies[_symbol] != 0x0) {
953             // Internal Out Of Gas/Throw: revert this transaction too;
954             // Call Stack Depth Limit reached: n/a after HF 4;
955             // Recursive Call: safe, all changes already made.
956             Proxy(proxies[_symbol]).emitApprove(_address(_senderId), _address(_spenderId), _value);
957         }
958         return OK;
959     }
960 
961     /**
962      * Sets asset spending allowance for a specified spender.
963      *
964      * Can only be called by asset proxy.
965      *
966      * @param _spender holder address to set allowance to.
967      * @param _value amount to allow.
968      * @param _symbol asset symbol.
969      * @param _sender approve initiator address.
970      *
971      * @return success.
972      */
973     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(uint errorCode) {
974         errorCode = checkIsOnlyProxy(_symbol);
975         if (errorCode != OK) {
976             return errorCode;
977         }
978         return _approve(_createHolderId(_spender), _value, _symbol, _createHolderId(_sender));
979     }
980 
981     /**
982      * Returns asset allowance from one holder to another.
983      *
984      * @param _from holder that allowed spending.
985      * @param _spender holder that is allowed to spend.
986      * @param _symbol asset symbol.
987      *
988      * @return holder to spender allowance.
989      */
990     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint) {
991         return _allowance(getHolderId(_from), getHolderId(_spender), _symbol);
992     }
993 
994     /**
995      * Returns asset allowance from one holder to another.
996      *
997      * @param _fromId holder id that allowed spending.
998      * @param _toId holder id that is allowed to spend.
999      * @param _symbol asset symbol.
1000      *
1001      * @return holder to spender allowance.
1002      */
1003     function _allowance(uint _fromId, uint _toId, bytes32 _symbol) constant internal returns(uint) {
1004         return assets[_symbol].wallets[_fromId].allowance[_toId];
1005     }
1006 
1007     /**
1008      * Prforms allowance transfer of asset balance between holders wallets.
1009      *
1010      * Can only be called by asset proxy.
1011      *
1012      * @param _from holder address to take from.
1013      * @param _to holder address to give to.
1014      * @param _value amount to transfer.
1015      * @param _symbol asset symbol.
1016      * @param _reference transfer comment to be included in a Transfer event.
1017      * @param _sender allowance transfer initiator address.
1018      *
1019      * @return success.
1020      */
1021     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode) {
1022         errorCode = checkIsOnlyProxy(_symbol);
1023         if (errorCode != OK) {
1024             return errorCode;
1025         }
1026         return _transfer(getHolderId(_from), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
1027     }
1028 }