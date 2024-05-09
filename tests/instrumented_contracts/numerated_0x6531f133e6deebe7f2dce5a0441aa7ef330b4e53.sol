1 pragma solidity ^0.4.4;
2 
3 contract Owned {
4     address public contractOwner;
5     address public pendingContractOwner;
6 
7     function Owned() {
8         contractOwner = msg.sender;
9     }
10 
11     modifier onlyContractOwner() {
12         if (contractOwner == msg.sender) {
13             _;
14         }
15     }
16 
17     /**
18      * Prepares ownership pass.
19      *
20      * Can only be called by current owner.
21      *
22      * @param _to address of the next owner.
23      *
24      * @return success.
25      */
26     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
27         pendingContractOwner = _to;
28         return true;
29     }
30 
31     /**
32      * Finalize ownership pass.
33      *
34      * Can only be called by pending owner.
35      *
36      * @return success.
37      */
38     function claimContractOwnership() returns(bool) {
39         if (pendingContractOwner != msg.sender) {
40             return false;
41         }
42         contractOwner = pendingContractOwner;
43         delete pendingContractOwner;
44         return true;
45     }
46 }
47 
48 
49 contract Emitter {
50     function emitTransfer(address _from, address _to, bytes32 _symbol, uint _value, string _reference);
51     function emitIssue(bytes32 _symbol, uint _value, address _by);
52     function emitRevoke(bytes32 _symbol, uint _value, address _by);
53     function emitOwnershipChange(address _from, address _to, bytes32 _symbol);
54     function emitApprove(address _from, address _spender, bytes32 _symbol, uint _value);
55     function emitRecovery(address _from, address _to, address _by);
56     function emitError(bytes32 _message);
57 }
58 
59 contract Proxy {
60     function emitTransfer(address _from, address _to, uint _value);
61     function emitApprove(address _from, address _spender, uint _value);
62 }
63 
64 /**
65  * @title ChronoBank Platform.
66  *
67  * The official ChronoBank assets platform powering TIME and LHT tokens, and possibly
68  * other unknown tokens needed later.
69  * Platform uses EventsHistory contract to keep events, so that in case it needs to be redeployed
70  * at some point, all the events keep appearing at the same place.
71  *
72  * Every asset is meant to be used through a proxy contract. Only one proxy contract have access
73  * rights for a particular asset.
74  *
75  * Features: transfers, allowances, supply adjustments, lost wallet access recovery.
76  *
77  * Note: all the non constant functions return false instead of throwing in case if state change
78  * didn't happen yet.
79  */
80 contract ChronoBankPlatform is Owned {
81     // Structure of a particular asset.
82     struct Asset {
83         uint owner;                       // Asset's owner id.
84         uint totalSupply;                 // Asset's total supply.
85         string name;                      // Asset's name, for information purposes.
86         string description;               // Asset's description, for information purposes.
87         bool isReissuable;                // Indicates if asset have dynamic of fixed supply.
88         uint8 baseUnit;                   // Proposed number of decimals.
89         mapping(uint => Wallet) wallets;  // Holders wallets.
90     }
91 
92     // Structure of an asset holder wallet for particular asset.
93     struct Wallet {
94         uint balance;
95         mapping(uint => uint) allowance;
96     }
97 
98     // Structure of an asset holder.
99     struct Holder {
100         address addr;                    // Current address of the holder.
101         mapping(address => bool) trust;  // Addresses that are trusted with recovery proocedure.
102     }
103 
104     // Iterable mapping pattern is used for holders.
105     uint public holdersCount;
106     mapping(uint => Holder) public holders;
107 
108     // This is an access address mapping. Many addresses may have access to a single holder.
109     mapping(address => uint) holderIndex;
110 
111     // Asset symbol to asset mapping.
112     mapping(bytes32 => Asset) public assets;
113 
114     // Asset symbol to asset proxy mapping.
115     mapping(bytes32 => address) public proxies;
116 
117     // Should use interface of the emitter, but address of events history.
118     Emitter public eventsHistory;
119 
120     /**
121      * Emits Error event with specified error message.
122      *
123      * Should only be used if no state changes happened.
124      *
125      * @param _message error message.
126      */
127     function _error(bytes32 _message) internal {
128         eventsHistory.emitError(_message);
129     }
130 
131     /**
132      * Sets EventsHstory contract address.
133      *
134      * Can be set only once, and only by contract owner.
135      *
136      * @param _eventsHistory EventsHistory contract address.
137      *
138      * @return success.
139      */
140     function setupEventsHistory(address _eventsHistory) onlyContractOwner() returns(bool) {
141         if (address(eventsHistory) != 0) {
142             return false;
143         }
144         eventsHistory = Emitter(_eventsHistory);
145         return true;
146     }
147 
148     /**
149      * Emits Error if called not by asset owner.
150      */
151     modifier onlyOwner(bytes32 _symbol) {
152         if (isOwner(msg.sender, _symbol)) {
153             _;
154         } else {
155             _error("Only owner: access denied");
156         }
157     }
158 
159     /**
160      * Emits Error if called not by asset proxy.
161      */
162     modifier onlyProxy(bytes32 _symbol) {
163         if (proxies[_symbol] == msg.sender) {
164             _;
165         } else {
166             _error("Only proxy: access denied");
167         }
168     }
169 
170     /**
171      * Emits Error if _from doesn't trust _to.
172      */
173     modifier checkTrust(address _from, address _to) {
174         if (isTrusted(_from, _to)) {
175             _;
176         } else {
177             _error("Only trusted: access denied");
178         }
179     }
180 
181     /**
182      * Check asset existance.
183      *
184      * @param _symbol asset symbol.
185      *
186      * @return asset existance.
187      */
188     function isCreated(bytes32 _symbol) constant returns(bool) {
189         return assets[_symbol].owner != 0;
190     }
191 
192     /**
193      * Returns asset decimals.
194      *
195      * @param _symbol asset symbol.
196      *
197      * @return asset decimals.
198      */
199     function baseUnit(bytes32 _symbol) constant returns(uint8) {
200         return assets[_symbol].baseUnit;
201     }
202 
203     /**
204      * Returns asset name.
205      *
206      * @param _symbol asset symbol.
207      *
208      * @return asset name.
209      */
210     function name(bytes32 _symbol) constant returns(string) {
211         return assets[_symbol].name;
212     }
213 
214     /**
215      * Returns asset description.
216      *
217      * @param _symbol asset symbol.
218      *
219      * @return asset description.
220      */
221     function description(bytes32 _symbol) constant returns(string) {
222         return assets[_symbol].description;
223     }
224 
225     /**
226      * Returns asset reissuability.
227      *
228      * @param _symbol asset symbol.
229      *
230      * @return asset reissuability.
231      */
232     function isReissuable(bytes32 _symbol) constant returns(bool) {
233         return assets[_symbol].isReissuable;
234     }
235 
236     /**
237      * Returns asset owner address.
238      *
239      * @param _symbol asset symbol.
240      *
241      * @return asset owner address.
242      */
243     function owner(bytes32 _symbol) constant returns(address) {
244         return holders[assets[_symbol].owner].addr;
245     }
246 
247     /**
248      * Check if specified address has asset owner rights.
249      *
250      * @param _owner address to check.
251      * @param _symbol asset symbol.
252      *
253      * @return owner rights availability.
254      */
255     function isOwner(address _owner, bytes32 _symbol) constant returns(bool) {
256         return isCreated(_symbol) && (assets[_symbol].owner == getHolderId(_owner));
257     }
258 
259     /**
260      * Returns asset total supply.
261      *
262      * @param _symbol asset symbol.
263      *
264      * @return asset total supply.
265      */
266     function totalSupply(bytes32 _symbol) constant returns(uint) {
267         return assets[_symbol].totalSupply;
268     }
269 
270     /**
271      * Returns asset balance for a particular holder.
272      *
273      * @param _holder holder address.
274      * @param _symbol asset symbol.
275      *
276      * @return holder balance.
277      */
278     function balanceOf(address _holder, bytes32 _symbol) constant returns(uint) {
279         return _balanceOf(getHolderId(_holder), _symbol);
280     }
281 
282     /**
283      * Returns asset balance for a particular holder id.
284      *
285      * @param _holderId holder id.
286      * @param _symbol asset symbol.
287      *
288      * @return holder balance.
289      */
290     function _balanceOf(uint _holderId, bytes32 _symbol) constant returns(uint) {
291         return assets[_symbol].wallets[_holderId].balance;
292     }
293 
294     /**
295      * Returns current address for a particular holder id.
296      *
297      * @param _holderId holder id.
298      *
299      * @return holder address.
300      */
301     function _address(uint _holderId) constant returns(address) {
302         return holders[_holderId].addr;
303     }
304 
305     /**
306      * Sets Proxy contract address for a particular asset.
307      *
308      * Can be set only once for each asset, and only by contract owner.
309      *
310      * @param _address Proxy contract address.
311      * @param _symbol asset symbol.
312      *
313      * @return success.
314      */
315     function setProxy(address _address, bytes32 _symbol) onlyContractOwner() returns(bool) {
316         if (proxies[_symbol] != 0x0) {
317             return false;
318         }
319         proxies[_symbol] = _address;
320         return true;
321     }
322 
323     /**
324      * Transfers asset balance between holders wallets.
325      *
326      * @param _fromId holder id to take from.
327      * @param _toId holder id to give to.
328      * @param _value amount to transfer.
329      * @param _symbol asset symbol.
330      */
331     function _transferDirect(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
332         assets[_symbol].wallets[_fromId].balance -= _value;
333         assets[_symbol].wallets[_toId].balance += _value;
334     }
335 
336     /**
337      * Transfers asset balance between holders wallets.
338      *
339      * Performs sanity checks and takes care of allowances adjustment.
340      *
341      * @param _fromId holder id to take from.
342      * @param _toId holder id to give to.
343      * @param _value amount to transfer.
344      * @param _symbol asset symbol.
345      * @param _reference transfer comment to be included in a Transfer event.
346      * @param _senderId transfer initiator holder id.
347      *
348      * @return success.
349      */
350     function _transfer(uint _fromId, uint _toId, uint _value, bytes32 _symbol, string _reference, uint _senderId) internal returns(bool) {
351         // Should not allow to send to oneself.
352         if (_fromId == _toId) {
353             _error("Cannot send to oneself");
354             return false;
355         }
356         // Should have positive value.
357         if (_value == 0) {
358             _error("Cannot send 0 value");
359             return false;
360         }
361         // Should have enough balance.
362         if (_balanceOf(_fromId, _symbol) < _value) {
363             _error("Insufficient balance");
364             return false;
365         }
366         // Should have enough allowance.
367         if (_fromId != _senderId && _allowance(_fromId, _senderId, _symbol) < _value) {
368             _error("Not enough allowance");
369             return false;
370         }
371         _transferDirect(_fromId, _toId, _value, _symbol);
372         // Adjust allowance.
373         if (_fromId != _senderId) {
374             assets[_symbol].wallets[_fromId].allowance[_senderId] -= _value;
375         }
376         // Internal Out Of Gas/Throw: revert this transaction too;
377         // Call Stack Depth Limit reached: n/a after HF 4;
378         // Recursive Call: safe, all changes already made.
379         eventsHistory.emitTransfer(_address(_fromId), _address(_toId), _symbol, _value, _reference);
380         _proxyTransferEvent(_fromId, _toId, _value, _symbol);
381         return true;
382     }
383 
384     /**
385      * Transfers asset balance between holders wallets.
386      *
387      * Can only be called by asset proxy.
388      *
389      * @param _to holder address to give to.
390      * @param _value amount to transfer.
391      * @param _symbol asset symbol.
392      * @param _reference transfer comment to be included in a Transfer event.
393      * @param _sender transfer initiator address.
394      *
395      * @return success.
396      */
397     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) onlyProxy(_symbol) returns(bool) {
398         return _transfer(getHolderId(_sender), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
399     }
400 
401     /**
402      * Ask asset Proxy contract to emit ERC20 compliant Transfer event.
403      *
404      * @param _fromId holder id to take from.
405      * @param _toId holder id to give to.
406      * @param _value amount to transfer.
407      * @param _symbol asset symbol.
408      */
409     function _proxyTransferEvent(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
410         if (proxies[_symbol] != 0x0) {
411             // Internal Out Of Gas/Throw: revert this transaction too;
412             // Call Stack Depth Limit reached: n/a after HF 4;
413             // Recursive Call: safe, all changes already made.
414             Proxy(proxies[_symbol]).emitTransfer(_address(_fromId), _address(_toId), _value);
415         }
416     }
417 
418     /**
419      * Returns holder id for the specified address.
420      *
421      * @param _holder holder address.
422      *
423      * @return holder id.
424      */
425     function getHolderId(address _holder) constant returns(uint) {
426         return holderIndex[_holder];
427     }
428 
429     /**
430      * Returns holder id for the specified address, creates it if needed.
431      *
432      * @param _holder holder address.
433      *
434      * @return holder id.
435      */
436     function _createHolderId(address _holder) internal returns(uint) {
437         uint holderId = holderIndex[_holder];
438         if (holderId == 0) {
439             holderId = ++holdersCount;
440             holders[holderId].addr = _holder;
441             holderIndex[_holder] = holderId;
442         }
443         return holderId;
444     }
445 
446     /**
447      * Issues new asset token on the platform.
448      *
449      * Tokens issued with this call go straight to contract owner.
450      * Each symbol can be issued only once, and only by contract owner.
451      *
452      * @param _symbol asset symbol.
453      * @param _value amount of tokens to issue immediately.
454      * @param _name name of the asset.
455      * @param _description description for the asset.
456      * @param _baseUnit number of decimals.
457      * @param _isReissuable dynamic or fixed supply.
458      *
459      * @return success.
460      */
461     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) onlyContractOwner() returns(bool) {
462         // Should have positive value if supply is going to be fixed.
463         if (_value == 0 && !_isReissuable) {
464             _error("Cannot issue 0 value fixed asset");
465             return false;
466         }
467         // Should not be issued yet.
468         if (isCreated(_symbol)) {
469             _error("Asset already issued");
470             return false;
471         }
472         uint holderId = _createHolderId(msg.sender);
473 
474         assets[_symbol] = Asset(holderId, _value, _name, _description, _isReissuable, _baseUnit);
475         assets[_symbol].wallets[holderId].balance = _value;
476         // Internal Out Of Gas/Throw: revert this transaction too;
477         // Call Stack Depth Limit reached: n/a after HF 4;
478         // Recursive Call: safe, all changes already made.
479         eventsHistory.emitIssue(_symbol, _value, _address(holderId));
480         return true;
481     }
482 
483     /**
484      * Issues additional asset tokens if the asset have dynamic supply.
485      *
486      * Tokens issued with this call go straight to asset owner.
487      * Can only be called by asset owner.
488      *
489      * @param _symbol asset symbol.
490      * @param _value amount of additional tokens to issue.
491      *
492      * @return success.
493      */
494     function reissueAsset(bytes32 _symbol, uint _value) onlyOwner(_symbol) returns(bool) {
495         // Should have positive value.
496         if (_value == 0) {
497             _error("Cannot reissue 0 value");
498             return false;
499         }
500         Asset asset = assets[_symbol];
501         // Should have dynamic supply.
502         if (!asset.isReissuable) {
503             _error("Cannot reissue fixed asset");
504             return false;
505         }
506         // Resulting total supply should not overflow.
507         if (asset.totalSupply + _value < asset.totalSupply) {
508             _error("Total supply overflow");
509             return false;
510         }
511         uint holderId = getHolderId(msg.sender);
512         asset.wallets[holderId].balance += _value;
513         asset.totalSupply += _value;
514         // Internal Out Of Gas/Throw: revert this transaction too;
515         // Call Stack Depth Limit reached: n/a after HF 4;
516         // Recursive Call: safe, all changes already made.
517         eventsHistory.emitIssue(_symbol, _value, _address(holderId));
518         _proxyTransferEvent(0, holderId, _value, _symbol);
519         return true;
520     }
521 
522     /**
523      * Destroys specified amount of senders asset tokens.
524      *
525      * @param _symbol asset symbol.
526      * @param _value amount of tokens to destroy.
527      *
528      * @return success.
529      */
530     function revokeAsset(bytes32 _symbol, uint _value) returns(bool) {
531         // Should have positive value.
532         if (_value == 0) {
533             _error("Cannot revoke 0 value");
534             return false;
535         }
536         Asset asset = assets[_symbol];
537         uint holderId = getHolderId(msg.sender);
538         // Should have enough tokens.
539         if (asset.wallets[holderId].balance < _value) {
540             _error("Not enough tokens to revoke");
541             return false;
542         }
543         asset.wallets[holderId].balance -= _value;
544         asset.totalSupply -= _value;
545         // Internal Out Of Gas/Throw: revert this transaction too;
546         // Call Stack Depth Limit reached: n/a after HF 4;
547         // Recursive Call: safe, all changes already made.
548         eventsHistory.emitRevoke(_symbol, _value, _address(holderId));
549         _proxyTransferEvent(holderId, 0, _value, _symbol);
550         return true;
551     }
552 
553     /**
554      * Passes asset ownership to specified address.
555      *
556      * Only ownership is changed, balances are not touched.
557      * Can only be called by asset owner.
558      *
559      * @param _symbol asset symbol.
560      * @param _newOwner address to become a new owner.
561      *
562      * @return success.
563      */
564     function changeOwnership(bytes32 _symbol, address _newOwner) onlyOwner(_symbol) returns(bool) {
565         Asset asset = assets[_symbol];
566         uint newOwnerId = _createHolderId(_newOwner);
567         // Should pass ownership to another holder.
568         if (asset.owner == newOwnerId) {
569             _error("Cannot pass ownership to oneself");
570             return false;
571         }
572         address oldOwner = _address(asset.owner);
573         asset.owner = newOwnerId;
574         // Internal Out Of Gas/Throw: revert this transaction too;
575         // Call Stack Depth Limit reached: n/a after HF 4;
576         // Recursive Call: safe, all changes already made.
577         eventsHistory.emitOwnershipChange(oldOwner, _address(newOwnerId), _symbol);
578         return true;
579     }
580 
581     /**
582      * Check if specified holder trusts an address with recovery procedure.
583      *
584      * @param _from truster.
585      * @param _to trustee.
586      *
587      * @return trust existance.
588      */
589     function isTrusted(address _from, address _to) constant returns(bool) {
590         return holders[getHolderId(_from)].trust[_to];
591     }
592 
593     /**
594      * Trust an address to perform recovery procedure for the caller.
595      *
596      * @param _to trustee.
597      *
598      * @return success.
599      */
600     function trust(address _to) returns(bool) {
601         uint fromId = _createHolderId(msg.sender);
602         // Should trust to another address.
603         if (fromId == getHolderId(_to)) {
604             _error("Cannot trust to oneself");
605             return false;
606         }
607         // Should trust to yet untrusted.
608         if (isTrusted(msg.sender, _to)) {
609             _error("Already trusted");
610             return false;
611         }
612         holders[fromId].trust[_to] = true;
613         return true;
614     }
615 
616     /**
617      * Revoke trust to perform recovery procedure from an address.
618      *
619      * @param _to trustee.
620      *
621      * @return success.
622      */
623     function distrust(address _to) checkTrust(msg.sender, _to) returns(bool) {
624         holders[getHolderId(msg.sender)].trust[_to] = false;
625         return true;
626     }
627 
628     /**
629      * Perform recovery procedure.
630      *
631      * This function logic is actually more of an addAccess(uint _holderId, address _to).
632      * It grants another address access to recovery subject wallets.
633      * Can only be called by trustee of recovery subject.
634      *
635      * @param _from holder address to recover from.
636      * @param _to address to grant access to.
637      *
638      * @return success.
639      */
640     function recover(address _from, address _to) checkTrust(_from, msg.sender) returns(bool) {
641         // Should recover to previously unused address.
642         if (getHolderId(_to) != 0) {
643             _error("Should recover to new address");
644             return false;
645         }
646         // We take current holder address because it might not equal _from.
647         // It is possible to recover from any old holder address, but event should have the current one.
648         address from = holders[getHolderId(_from)].addr;
649         holders[getHolderId(_from)].addr = _to;
650         holderIndex[_to] = getHolderId(_from);
651         // Internal Out Of Gas/Throw: revert this transaction too;
652         // Call Stack Depth Limit reached: revert this transaction too;
653         // Recursive Call: safe, all changes already made.
654         eventsHistory.emitRecovery(from, _to, msg.sender);
655         return true;
656     }
657 
658     /**
659      * Sets asset spending allowance for a specified spender.
660      *
661      * Note: to revoke allowance, one needs to set allowance to 0.
662      *
663      * @param _spenderId holder id to set allowance for.
664      * @param _value amount to allow.
665      * @param _symbol asset symbol.
666      * @param _senderId approve initiator holder id.
667      *
668      * @return success.
669      */
670     function _approve(uint _spenderId, uint _value, bytes32 _symbol, uint _senderId) internal returns(bool) {
671         // Asset should exist.
672         if (!isCreated(_symbol)) {
673             _error("Asset is not issued");
674             return false;
675         }
676         // Should allow to another holder.
677         if (_senderId == _spenderId) {
678             _error("Cannot approve to oneself");
679             return false;
680         }
681         assets[_symbol].wallets[_senderId].allowance[_spenderId] = _value;
682         // Internal Out Of Gas/Throw: revert this transaction too;
683         // Call Stack Depth Limit reached: revert this transaction too;
684         // Recursive Call: safe, all changes already made.
685         eventsHistory.emitApprove(_address(_senderId), _address(_spenderId), _symbol, _value);
686         if (proxies[_symbol] != 0x0) {
687             // Internal Out Of Gas/Throw: revert this transaction too;
688             // Call Stack Depth Limit reached: n/a after HF 4;
689             // Recursive Call: safe, all changes already made.
690             Proxy(proxies[_symbol]).emitApprove(_address(_senderId), _address(_spenderId), _value);
691         }
692         return true;
693     }
694 
695     /**
696      * Sets asset spending allowance for a specified spender.
697      *
698      * Can only be called by asset proxy.
699      *
700      * @param _spender holder address to set allowance to.
701      * @param _value amount to allow.
702      * @param _symbol asset symbol.
703      * @param _sender approve initiator address.
704      *
705      * @return success.
706      */
707     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) onlyProxy(_symbol) returns(bool) {
708         return _approve(_createHolderId(_spender), _value, _symbol, _createHolderId(_sender));
709     }
710 
711     /**
712      * Returns asset allowance from one holder to another.
713      *
714      * @param _from holder that allowed spending.
715      * @param _spender holder that is allowed to spend.
716      * @param _symbol asset symbol.
717      *
718      * @return holder to spender allowance.
719      */
720     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint) {
721         return _allowance(getHolderId(_from), getHolderId(_spender), _symbol);
722     }
723 
724     /**
725      * Returns asset allowance from one holder to another.
726      *
727      * @param _fromId holder id that allowed spending.
728      * @param _toId holder id that is allowed to spend.
729      * @param _symbol asset symbol.
730      *
731      * @return holder to spender allowance.
732      */
733     function _allowance(uint _fromId, uint _toId, bytes32 _symbol) constant internal returns(uint) {
734         return assets[_symbol].wallets[_fromId].allowance[_toId];
735     }
736 
737     /**
738      * Prforms allowance transfer of asset balance between holders wallets.
739      *
740      * Can only be called by asset proxy.
741      *
742      * @param _from holder address to take from.
743      * @param _to holder address to give to.
744      * @param _value amount to transfer.
745      * @param _symbol asset symbol.
746      * @param _reference transfer comment to be included in a Transfer event.
747      * @param _sender allowance transfer initiator address.
748      *
749      * @return success.
750      */
751     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) onlyProxy(_symbol) returns(bool) {
752         return _transfer(getHolderId(_from), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
753     }
754 }
755 
756 contract ChronoBankAsset {
757     function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
758     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
759     function __approve(address _spender, uint _value, address _sender) returns(bool);
760     function __process(bytes _data, address _sender) payable {
761         throw;
762     }
763 }
764 
765 contract ERC20 {
766     event Transfer(address indexed from, address indexed to, uint256 value);
767     event Approval(address indexed from, address indexed spender, uint256 value);
768 
769     function totalSupply() constant returns (uint256 supply);
770     function balanceOf(address _owner) constant returns (uint256 balance);
771     function transfer(address _to, uint256 _value) returns (bool success);
772     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
773     function approve(address _spender, uint256 _value) returns (bool success);
774     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
775 }
776 
777 contract ChronoBankAssetProxy is ERC20 {
778     // Assigned platform, immutable.
779     ChronoBankPlatform public chronoBankPlatform;
780 
781     // Assigned symbol, immutable.
782     bytes32 smbl;
783 
784     // Assigned name, immutable.
785     string public name;
786 
787     string public symbol;
788 
789     /**
790      * Sets platform address, assigns symbol and name.
791      *
792      * Can be set only once.
793      *
794      * @param _chronoBankPlatform platform contract address.
795      * @param _symbol assigned symbol.
796      * @param _name assigned name.
797      *
798      * @return success.
799      */
800     function init(ChronoBankPlatform _chronoBankPlatform, string _symbol, string _name) returns(bool) {
801         if (address(chronoBankPlatform) != 0x0) {
802             return false;
803         }
804         chronoBankPlatform = _chronoBankPlatform;
805         symbol = _symbol;
806         smbl = stringToBytes32(_symbol);
807         name = _name;
808         return true;
809     }
810 
811 function stringToBytes32(string memory source) returns (bytes32 result) {
812     assembly {
813         result := mload(add(source, 32))
814     }
815 }
816 
817     /**
818      * Only platform is allowed to call.
819      */
820     modifier onlyChronoBankPlatform() {
821         if (msg.sender == address(chronoBankPlatform)) {
822             _;
823         }
824     }
825 
826     /**
827      * Only current asset owner is allowed to call.
828      */
829     modifier onlyAssetOwner() {
830         if (chronoBankPlatform.isOwner(msg.sender, smbl)) {
831             _;
832         }
833     }
834 
835     /**
836      * Returns asset implementation contract for current caller.
837      *
838      * @return asset implementation contract.
839      */
840     function _getAsset() internal returns(ChronoBankAsset) {
841         return ChronoBankAsset(getVersionFor(msg.sender));
842     }
843 
844     /**
845      * Returns asset total supply.
846      *
847      * @return asset total supply.
848      */
849     function totalSupply() constant returns(uint) {
850         return chronoBankPlatform.totalSupply(smbl);
851     }
852 
853     /**
854      * Returns asset balance for a particular holder.
855      *
856      * @param _owner holder address.
857      *
858      * @return holder balance.
859      */
860     function balanceOf(address _owner) constant returns(uint) {
861         return chronoBankPlatform.balanceOf(_owner, smbl);
862     }
863 
864     /**
865      * Returns asset allowance from one holder to another.
866      *
867      * @param _from holder that allowed spending.
868      * @param _spender holder that is allowed to spend.
869      *
870      * @return holder to spender allowance.
871      */
872     function allowance(address _from, address _spender) constant returns(uint) {
873         return chronoBankPlatform.allowance(_from, _spender, smbl);
874     }
875 
876     /**
877      * Returns asset decimals.
878      *
879      * @return asset decimals.
880      */
881     function decimals() constant returns(uint8) {
882         return chronoBankPlatform.baseUnit(smbl);
883     }
884 
885     /**
886      * Transfers asset balance from the caller to specified receiver.
887      *
888      * @param _to holder address to give to.
889      * @param _value amount to transfer.
890      *
891      * @return success.
892      */
893     function transfer(address _to, uint _value) returns(bool) {
894         return _transferWithReference(_to, _value, "");
895     }
896 
897     /**
898      * Transfers asset balance from the caller to specified receiver adding specified comment.
899      *
900      * @param _to holder address to give to.
901      * @param _value amount to transfer.
902      * @param _reference transfer comment to be included in a platform's Transfer event.
903      *
904      * @return success.
905      */
906     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
907         return _transferWithReference(_to, _value, _reference);
908     }
909 
910     /**
911      * Resolves asset implementation contract for the caller and forwards there arguments along with
912      * the caller address.
913      *
914      * @return success.
915      */
916     function _transferWithReference(address _to, uint _value, string _reference) internal returns(bool) {
917         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
918     }
919 
920     /**
921      * Performs transfer call on the platform by the name of specified sender.
922      *
923      * Can only be called by asset implementation contract assigned to sender.
924      *
925      * @param _to holder address to give to.
926      * @param _value amount to transfer.
927      * @param _reference transfer comment to be included in a platform's Transfer event.
928      * @param _sender initial caller.
929      *
930      * @return success.
931      */
932     function __transferWithReference(address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {
933         return chronoBankPlatform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender);
934     }
935 
936     /**
937      * Prforms allowance transfer of asset balance between holders.
938      *
939      * @param _from holder address to take from.
940      * @param _to holder address to give to.
941      * @param _value amount to transfer.
942      *
943      * @return success.
944      */
945     function transferFrom(address _from, address _to, uint _value) returns(bool) {
946         return _transferFromWithReference(_from, _to, _value, "");
947     }
948 
949     /**
950      * Prforms allowance transfer of asset balance between holders adding specified comment.
951      *
952      * @param _from holder address to take from.
953      * @param _to holder address to give to.
954      * @param _value amount to transfer.
955      * @param _reference transfer comment to be included in a platform's Transfer event.
956      *
957      * @return success.
958      */
959     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
960         return _transferFromWithReference(_from, _to, _value, _reference);
961     }
962 
963     /**
964      * Resolves asset implementation contract for the caller and forwards there arguments along with
965      * the caller address.
966      *
967      * @return success.
968      */
969     function _transferFromWithReference(address _from, address _to, uint _value, string _reference) internal returns(bool) {
970         return _getAsset().__transferFromWithReference(_from, _to, _value, _reference, msg.sender);
971     }
972 
973     /**
974      * Performs allowance transfer call on the platform by the name of specified sender.
975      *
976      * Can only be called by asset implementation contract assigned to sender.
977      *
978      * @param _from holder address to take from.
979      * @param _to holder address to give to.
980      * @param _value amount to transfer.
981      * @param _reference transfer comment to be included in a platform's Transfer event.
982      * @param _sender initial caller.
983      *
984      * @return success.
985      */
986     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {
987         return chronoBankPlatform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender);
988     }
989 
990     /**
991      * Sets asset spending allowance for a specified spender.
992      *
993      * @param _spender holder address to set allowance to.
994      * @param _value amount to allow.
995      *
996      * @return success.
997      */
998     function approve(address _spender, uint _value) returns(bool) {
999         return _approve(_spender, _value);
1000     }
1001 
1002     /**
1003      * Resolves asset implementation contract for the caller and forwards there arguments along with
1004      * the caller address.
1005      *
1006      * @return success.
1007      */
1008     function _approve(address _spender, uint _value) internal returns(bool) {
1009         return _getAsset().__approve(_spender, _value, msg.sender);
1010     }
1011 
1012     /**
1013      * Performs allowance setting call on the platform by the name of specified sender.
1014      *
1015      * Can only be called by asset implementation contract assigned to sender.
1016      *
1017      * @param _spender holder address to set allowance to.
1018      * @param _value amount to allow.
1019      * @param _sender initial caller.
1020      *
1021      * @return success.
1022      */
1023     function __approve(address _spender, uint _value, address _sender) onlyAccess(_sender) returns(bool) {
1024         return chronoBankPlatform.proxyApprove(_spender, _value, smbl, _sender);
1025     }
1026 
1027     /**
1028      * Emits ERC20 Transfer event on this contract.
1029      *
1030      * Can only be, and, called by assigned platform when asset transfer happens.
1031      */
1032     function emitTransfer(address _from, address _to, uint _value) onlyChronoBankPlatform() {
1033         Transfer(_from, _to, _value);
1034     }
1035 
1036     /**
1037      * Emits ERC20 Approval event on this contract.
1038      *
1039      * Can only be, and, called by assigned platform when asset allowance set happens.
1040      */
1041     function emitApprove(address _from, address _spender, uint _value) onlyChronoBankPlatform() {
1042         Approval(_from, _spender, _value);
1043     }
1044 
1045     /**
1046      * Resolves asset implementation contract for the caller and forwards there transaction data,
1047      * along with the value. This allows for proxy interface growth.
1048      */
1049     function () payable {
1050         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
1051     }
1052 
1053     /**
1054      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
1055      */
1056     event UpgradeProposal(address newVersion);
1057 
1058     // Current asset implementation contract address.
1059     address latestVersion;
1060 
1061     // Proposed next asset implementation contract address.
1062     address pendingVersion;
1063 
1064     // Upgrade freeze-time start.
1065     uint pendingVersionTimestamp;
1066 
1067     // Timespan for users to review the new implementation and make decision.
1068     uint constant UPGRADE_FREEZE_TIME = 3 days;
1069 
1070     // Asset implementation contract address that user decided to stick with.
1071     // 0x0 means that user uses latest version.
1072     mapping(address => address) userOptOutVersion;
1073 
1074     /**
1075      * Only asset implementation contract assigned to sender is allowed to call.
1076      */
1077     modifier onlyAccess(address _sender) {
1078         if (getVersionFor(_sender) == msg.sender) {
1079             _;
1080         }
1081     }
1082 
1083     /**
1084      * Returns asset implementation contract address assigned to sender.
1085      *
1086      * @param _sender sender address.
1087      *
1088      * @return asset implementation contract address.
1089      */
1090     function getVersionFor(address _sender) constant returns(address) {
1091         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
1092     }
1093 
1094     /**
1095      * Returns current asset implementation contract address.
1096      *
1097      * @return asset implementation contract address.
1098      */
1099     function getLatestVersion() constant returns(address) {
1100         return latestVersion;
1101     }
1102 
1103     /**
1104      * Returns proposed next asset implementation contract address.
1105      *
1106      * @return asset implementation contract address.
1107      */
1108     function getPendingVersion() constant returns(address) {
1109         return pendingVersion;
1110     }
1111 
1112     /**
1113      * Returns upgrade freeze-time start.
1114      *
1115      * @return freeze-time start.
1116      */
1117     function getPendingVersionTimestamp() constant returns(uint) {
1118         return pendingVersionTimestamp;
1119     }
1120 
1121     /**
1122      * Propose next asset implementation contract address.
1123      *
1124      * Can only be called by current asset owner.
1125      *
1126      * Note: freeze-time should not be applied for the initial setup.
1127      *
1128      * @param _newVersion asset implementation contract address.
1129      *
1130      * @return success.
1131      */
1132     function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {
1133         // Should not already be in the upgrading process.
1134         if (pendingVersion != 0x0) {
1135             return false;
1136         }
1137         // New version address should be other than 0x0.
1138         if (_newVersion == 0x0) {
1139             return false;
1140         }
1141         // Don't apply freeze-time for the initial setup.
1142         if (latestVersion == 0x0) {
1143             latestVersion = _newVersion;
1144             return true;
1145         }
1146         pendingVersion = _newVersion;
1147         pendingVersionTimestamp = now;
1148         UpgradeProposal(_newVersion);
1149         return true;
1150     }
1151 
1152     /**
1153      * Cancel the pending upgrade process.
1154      *
1155      * Can only be called by current asset owner.
1156      *
1157      * @return success.
1158      */
1159     function purgeUpgrade() onlyAssetOwner() returns(bool) {
1160         if (pendingVersion == 0x0) {
1161             return false;
1162         }
1163         delete pendingVersion;
1164         delete pendingVersionTimestamp;
1165         return true;
1166     }
1167 
1168     /**
1169      * Finalize an upgrade process setting new asset implementation contract address.
1170      *
1171      * Can only be called after an upgrade freeze-time.
1172      *
1173      * @return success.
1174      */
1175     function commitUpgrade() returns(bool) {
1176         if (pendingVersion == 0x0) {
1177             return false;
1178         }
1179         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
1180             return false;
1181         }
1182         latestVersion = pendingVersion;
1183         delete pendingVersion;
1184         delete pendingVersionTimestamp;
1185         return true;
1186     }
1187 
1188     /**
1189      * Disagree with proposed upgrade, and stick with current asset implementation
1190      * until further explicit agreement to upgrade.
1191      *
1192      * @return success.
1193      */
1194     function optOut() returns(bool) {
1195         if (userOptOutVersion[msg.sender] != 0x0) {
1196             return false;
1197         }
1198         userOptOutVersion[msg.sender] = latestVersion;
1199         return true;
1200     }
1201 
1202     /**
1203      * Implicitly agree to upgrade to current and future asset implementation upgrades,
1204      * until further explicit disagreement.
1205      *
1206      * @return success.
1207      */
1208     function optIn() returns(bool) {
1209         delete userOptOutVersion[msg.sender];
1210         return true;
1211     }
1212 }