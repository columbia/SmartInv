1 // This software is a subject to Ambisafe License Agreement.
2 // No use or distribution is allowed without written permission from Ambisafe.
3 // https://ambisafe.com/terms.pdf
4 
5 pragma solidity 0.4.8;
6 
7 contract Ambi2 {
8     function claimFor(address _address, address _owner) returns(bool);
9     function hasRole(address _from, bytes32 _role, address _to) constant returns(bool);
10     function isOwner(address _node, address _owner) constant returns(bool);
11 }
12 
13 contract Ambi2Enabled {
14     Ambi2 ambi2;
15 
16     modifier onlyRole(bytes32 _role) {
17         if (address(ambi2) != 0x0 && ambi2.hasRole(this, _role, msg.sender)) {
18             _;
19         }
20     }
21 
22     // Perform only after claiming the node, or claim in the same tx.
23     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
24         if (address(ambi2) != 0x0) {
25             return false;
26         }
27 
28         ambi2 = _ambi2;
29         return true;
30     }
31 }
32 
33 contract Ambi2EnabledFull is Ambi2Enabled {
34     // Setup and claim atomically.
35     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
36         if (address(ambi2) != 0x0) {
37             return false;
38         }
39         if (!_ambi2.claimFor(this, msg.sender) && !_ambi2.isOwner(this, msg.sender)) {
40             return false;
41         }
42 
43         ambi2 = _ambi2;
44         return true;
45     }
46 }
47 
48 contract RegistryICAPInterface {
49     function parse(bytes32 _icap) constant returns(address, bytes32, bool);
50     function institutions(bytes32 _institution) constant returns(address);
51 }
52 
53 contract Cosigner {
54     function consumeOperation(bytes32 _opHash, uint _required) returns(bool);
55 }
56 
57 contract Emitter {
58     function emitTransfer(address _from, address _to, bytes32 _symbol, uint _value, string _reference);
59     function emitTransferToICAP(address _from, address _to, bytes32 _icap, uint _value, string _reference);
60     function emitIssue(bytes32 _symbol, uint _value, address _by);
61     function emitRevoke(bytes32 _symbol, uint _value, address _by);
62     function emitOwnershipChange(address _from, address _to, bytes32 _symbol);
63     function emitApprove(address _from, address _spender, bytes32 _symbol, uint _value);
64     function emitRecovery(address _from, address _to, address _by);
65     function emitError(bytes32 _message);
66     function emitChange(bytes32 _symbol);
67 }
68 
69 contract Proxy {
70     function emitTransfer(address _from, address _to, uint _value);
71     function emitApprove(address _from, address _spender, uint _value);
72 }
73 
74 /**
75  * @title EToken2.
76  *
77  * The official Ambisafe assets platform powering all kinds of tokens.
78  * EToken2 uses EventsHistory contract to keep events, so that in case it needs to be redeployed
79  * at some point, all the events keep appearing at the same place.
80  *
81  * Every asset is meant to be used through a proxy contract. Only one proxy contract have access
82  * rights for a particular asset.
83  *
84  * Features: assets issuance, transfers, allowances, supply adjustments, lost wallet access recovery.
85  *           cosignature check, ICAP.
86  *
87  * Note: all the non constant functions return false instead of throwing in case if state change
88  * didn't happen yet.
89  */
90 contract EToken2 is Ambi2EnabledFull {
91     mapping(bytes32 => bool) switches;
92 
93     function isEnabled(bytes32 _switch) constant returns(bool) {
94         return switches[_switch];
95     }
96 
97     function enableSwitch(bytes32 _switch) onlyRole('issuance') returns(bool) {
98         switches[_switch] = true;
99         return true;
100     }
101 
102     modifier checkEnabledSwitch(bytes32 _switch) {
103         if (!isEnabled(_switch)) {
104             _error('Feature is disabled');
105         } else {
106             _;
107         }
108     }
109 
110     enum Features { Issue, TransferWithReference, Revoke, ChangeOwnership, Allowances, ICAP }
111 
112     // Structure of a particular asset.
113     struct Asset {
114         uint owner;                       // Asset's owner id.
115         uint totalSupply;                 // Asset's total supply.
116         string name;                      // Asset's name, for information purposes.
117         string description;               // Asset's description, for information purposes.
118         bool isReissuable;                // Indicates if asset have dynamic of fixed supply.
119         uint8 baseUnit;                   // Proposed number of decimals.
120         bool isLocked;                    // Are changes still allowed.
121         mapping(uint => Wallet) wallets;  // Holders wallets.
122     }
123 
124     // Structure of an asset holder wallet for particular asset.
125     struct Wallet {
126         uint balance;
127         mapping(uint => uint) allowance;
128     }
129 
130     // Structure of an asset holder.
131     struct Holder {
132         address addr;                    // Current address of the holder.
133         Cosigner cosigner;               // Cosigner contract for 2FA and recovery.
134         mapping(address => bool) trust;  // Addresses that are trusted with recovery proocedure.
135     }
136 
137     // Iterable mapping pattern is used for holders.
138     uint public holdersCount;
139     mapping(uint => Holder) public holders;
140 
141     // This is an access address mapping. Many addresses may have access to a single holder.
142     mapping(address => uint) holderIndex;
143 
144     // Asset symbol to asset mapping.
145     mapping(bytes32 => Asset) public assets;
146 
147     // Asset symbol to asset proxy mapping.
148     mapping(bytes32 => address) public proxies;
149 
150     // ICAP registry contract.
151     RegistryICAPInterface public registryICAP;
152 
153     // Should use interface of the emitter, but address of events history.
154     Emitter public eventsHistory;
155 
156     /**
157      * Emits Error event with specified error message.
158      *
159      * Should only be used if no state changes happened.
160      *
161      * @param _message error message.
162      */
163     function _error(bytes32 _message) internal {
164         eventsHistory.emitError(_message);
165     }
166 
167     /**
168      * Sets EventsHstory contract address.
169      *
170      * Can be set only once, and only by contract owner.
171      *
172      * @param _eventsHistory EventsHistory contract address.
173      *
174      * @return success.
175      */
176     function setupEventsHistory(Emitter _eventsHistory) onlyRole('setup') returns(bool) {
177         if (address(eventsHistory) != 0) {
178             return false;
179         }
180         eventsHistory = _eventsHistory;
181         return true;
182     }
183 
184     /**
185      * Sets RegistryICAP contract address.
186      *
187      * Can be set only once, and only by contract owner.
188      *
189      * @param _registryICAP RegistryICAP contract address.
190      *
191      * @return success.
192      */
193     function setupRegistryICAP(RegistryICAPInterface _registryICAP) onlyRole('setup') returns(bool) {
194         if (address(registryICAP) != 0) {
195             return false;
196         }
197         registryICAP = _registryICAP;
198         return true;
199     }
200 
201     /**
202      * Emits Error if called not by asset owner.
203      */
204     modifier onlyOwner(bytes32 _symbol) {
205         if (_isSignedOwner(_symbol)) {
206             _;
207         } else {
208             _error('Only owner: access denied');
209         }
210     }
211 
212     /**
213      * Emits Error if called not by asset proxy.
214      */
215     modifier onlyProxy(bytes32 _symbol) {
216         if (_isProxy(_symbol)) {
217             _;
218         } else {
219             _error('Only proxy: access denied');
220         }
221     }
222 
223     /**
224      * Emits Error if _from doesn't trust _to.
225      */
226     modifier checkTrust(address _from, address _to) {
227         if (isTrusted(_from, _to)) {
228             _;
229         } else {
230             _error('Only trusted: access denied');
231         }
232     }
233 
234     function _isSignedOwner(bytes32 _symbol) internal checkSigned(getHolderId(msg.sender), 1) returns(bool) {
235         return isOwner(msg.sender, _symbol);
236     }
237 
238     /**
239      * Check asset existance.
240      *
241      * @param _symbol asset symbol.
242      *
243      * @return asset existance.
244      */
245     function isCreated(bytes32 _symbol) constant returns(bool) {
246         return assets[_symbol].owner != 0;
247     }
248 
249     function isLocked(bytes32 _symbol) constant returns(bool) {
250         return assets[_symbol].isLocked;
251     }
252 
253     /**
254      * Returns asset decimals.
255      *
256      * @param _symbol asset symbol.
257      *
258      * @return asset decimals.
259      */
260     function baseUnit(bytes32 _symbol) constant returns(uint8) {
261         return assets[_symbol].baseUnit;
262     }
263 
264     /**
265      * Returns asset name.
266      *
267      * @param _symbol asset symbol.
268      *
269      * @return asset name.
270      */
271     function name(bytes32 _symbol) constant returns(string) {
272         return assets[_symbol].name;
273     }
274 
275     /**
276      * Returns asset description.
277      *
278      * @param _symbol asset symbol.
279      *
280      * @return asset description.
281      */
282     function description(bytes32 _symbol) constant returns(string) {
283         return assets[_symbol].description;
284     }
285 
286     /**
287      * Returns asset reissuability.
288      *
289      * @param _symbol asset symbol.
290      *
291      * @return asset reissuability.
292      */
293     function isReissuable(bytes32 _symbol) constant returns(bool) {
294         return assets[_symbol].isReissuable;
295     }
296 
297     /**
298      * Returns asset owner address.
299      *
300      * @param _symbol asset symbol.
301      *
302      * @return asset owner address.
303      */
304     function owner(bytes32 _symbol) constant returns(address) {
305         return holders[assets[_symbol].owner].addr;
306     }
307 
308     /**
309      * Check if specified address has asset owner rights.
310      *
311      * @param _owner address to check.
312      * @param _symbol asset symbol.
313      *
314      * @return owner rights availability.
315      */
316     function isOwner(address _owner, bytes32 _symbol) constant returns(bool) {
317         return isCreated(_symbol) && (assets[_symbol].owner == getHolderId(_owner));
318     }
319 
320     /**
321      * Returns asset total supply.
322      *
323      * @param _symbol asset symbol.
324      *
325      * @return asset total supply.
326      */
327     function totalSupply(bytes32 _symbol) constant returns(uint) {
328         return assets[_symbol].totalSupply;
329     }
330 
331     /**
332      * Returns asset balance for current address of a particular holder.
333      *
334      * @param _holder holder address.
335      * @param _symbol asset symbol.
336      *
337      * @return holder balance.
338      */
339     function balanceOf(address _holder, bytes32 _symbol) constant returns(uint) {
340         uint holderId = getHolderId(_holder);
341         return holders[holderId].addr == _holder ? _balanceOf(holderId, _symbol) : 0;
342     }
343 
344     /**
345      * Returns asset balance for a particular holder id.
346      *
347      * @param _holderId holder id.
348      * @param _symbol asset symbol.
349      *
350      * @return holder balance.
351      */
352     function _balanceOf(uint _holderId, bytes32 _symbol) constant internal returns(uint) {
353         return assets[_symbol].wallets[_holderId].balance;
354     }
355 
356     /**
357      * Returns current address for a particular holder id.
358      *
359      * @param _holderId holder id.
360      *
361      * @return holder address.
362      */
363     function _address(uint _holderId) constant internal returns(address) {
364         return holders[_holderId].addr;
365     }
366 
367     function _isProxy(bytes32 _symbol) constant internal returns(bool) {
368         return proxies[_symbol] == msg.sender;
369     }
370 
371     /**
372      * Sets Proxy contract address for a particular asset.
373      *
374      * Can be set only once for each asset, and only by contract owner.
375      *
376      * @param _address Proxy contract address.
377      * @param _symbol asset symbol.
378      *
379      * @return success.
380      */
381     function setProxy(address _address, bytes32 _symbol) onlyOwner(_symbol) returns(bool) {
382         if (proxies[_symbol] != 0x0 && assets[_symbol].isLocked) {
383             return false;
384         }
385         proxies[_symbol] = _address;
386         return true;
387     }
388 
389     /**
390      * Transfers asset balance between holders wallets.
391      *
392      * @param _fromId holder id to take from.
393      * @param _toId holder id to give to.
394      * @param _value amount to transfer.
395      * @param _symbol asset symbol.
396      */
397     function _transferDirect(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
398         assets[_symbol].wallets[_fromId].balance -= _value;
399         assets[_symbol].wallets[_toId].balance += _value;
400     }
401 
402     /**
403      * Transfers asset balance between holders wallets.
404      *
405      * Performs sanity checks and takes care of allowances adjustment.
406      *
407      * @param _fromId holder id to take from.
408      * @param _toId holder id to give to.
409      * @param _value amount to transfer.
410      * @param _symbol asset symbol.
411      * @param _reference transfer comment to be included in a Transfer event.
412      * @param _senderId transfer initiator holder id.
413      *
414      * @return success.
415      */
416     function _transfer(uint _fromId, uint _toId, uint _value, bytes32 _symbol, string _reference, uint _senderId) internal checkSigned(_senderId, 1) returns(bool) {
417         // Should not allow to send to oneself.
418         if (_fromId == _toId) {
419             _error('Cannot send to oneself');
420             return false;
421         }
422         // Should have positive value.
423         if (_value == 0) {
424             _error('Cannot send 0 value');
425             return false;
426         }
427         // Should have enough balance.
428         if (_balanceOf(_fromId, _symbol) < _value) {
429             _error('Insufficient balance');
430             return false;
431         }
432         // Should allow references.
433         if (bytes(_reference).length > 0 && !isEnabled(sha3(_symbol, Features.TransferWithReference))) {
434             _error('References feature is disabled');
435             return false;
436         }
437         // Should have enough allowance.
438         if (_fromId != _senderId && _allowance(_fromId, _senderId, _symbol) < _value) {
439             _error('Not enough allowance');
440             return false;
441         }
442         // Adjust allowance.
443         if (_fromId != _senderId) {
444             assets[_symbol].wallets[_fromId].allowance[_senderId] -= _value;
445         }
446         _transferDirect(_fromId, _toId, _value, _symbol);
447         // Internal Out Of Gas/Throw: revert this transaction too;
448         // Recursive Call: safe, all changes already made.
449         eventsHistory.emitTransfer(_address(_fromId), _address(_toId), _symbol, _value, _reference);
450         _proxyTransferEvent(_fromId, _toId, _value, _symbol);
451         return true;
452     }
453 
454     // Feature and proxy checks done internally due to unknown symbol when the function is called.
455     function _transferToICAP(uint _fromId, bytes32 _icap, uint _value, string _reference, uint _senderId) internal returns(bool) {
456         var (to, symbol, success) = registryICAP.parse(_icap);
457         if (!success) {
458             _error('ICAP is not registered');
459             return false;
460         }
461         if (!isEnabled(sha3(symbol, Features.ICAP))) {
462             _error('ICAP feature is disabled');
463             return false;
464         }
465         if (!_isProxy(symbol)) {
466             _error('Only proxy: access denied');
467             return false;
468         }
469         uint toId = _createHolderId(to);
470         if (!_transfer(_fromId, toId, _value, symbol, _reference, _senderId)) {
471             return false;
472         }
473         // Internal Out Of Gas/Throw: revert this transaction too;
474         // Recursive Call: safe, all changes already made.
475         eventsHistory.emitTransferToICAP(_address(_fromId), _address(toId), _icap, _value, _reference);
476         return true;
477     }
478 
479     function proxyTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool) {
480         return _transferToICAP(getHolderId(_from), _icap, _value, _reference, getHolderId(_sender));
481     }
482 
483     /**
484      * Ask asset Proxy contract to emit ERC20 compliant Transfer event.
485      *
486      * @param _fromId holder id to take from.
487      * @param _toId holder id to give to.
488      * @param _value amount to transfer.
489      * @param _symbol asset symbol.
490      */
491     function _proxyTransferEvent(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {
492         if (proxies[_symbol] != 0x0) {
493             // Internal Out Of Gas/Throw: revert this transaction too;
494             // Recursive Call: safe, all changes already made.
495             Proxy(proxies[_symbol]).emitTransfer(_address(_fromId), _address(_toId), _value);
496         }
497     }
498 
499     /**
500      * Returns holder id for the specified address.
501      *
502      * @param _holder holder address.
503      *
504      * @return holder id.
505      */
506     function getHolderId(address _holder) constant returns(uint) {
507         return holderIndex[_holder];
508     }
509 
510     /**
511      * Returns holder id for the specified address, creates it if needed.
512      *
513      * @param _holder holder address.
514      *
515      * @return holder id.
516      */
517     function _createHolderId(address _holder) internal returns(uint) {
518         uint holderId = holderIndex[_holder];
519         if (holderId == 0) {
520             holderId = ++holdersCount;
521             holders[holderId].addr = _holder;
522             holderIndex[_holder] = holderId;
523         }
524         return holderId;
525     }
526 
527     /**
528      * Issues new asset token on the platform.
529      *
530      * Tokens issued with this call go straight to contract owner.
531      * Each symbol can be issued only once, and only by contract owner.
532      *
533      * _isReissuable is included in checkEnabledSwitch because it should be
534      * explicitly allowed before issuing new asset.
535      *
536      * @param _symbol asset symbol.
537      * @param _value amount of tokens to issue immediately.
538      * @param _name name of the asset.
539      * @param _description description for the asset.
540      * @param _baseUnit number of decimals.
541      * @param _isReissuable dynamic or fixed supply.
542      *
543      * @return success.
544      */
545     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) checkEnabledSwitch(sha3(_symbol, _isReissuable, Features.Issue)) returns(bool) {
546         // Should have positive value if supply is going to be fixed.
547         if (_value == 0 && !_isReissuable) {
548             _error('Cannot issue 0 value fixed asset');
549             return false;
550         }
551         // Should not be issued yet.
552         if (isCreated(_symbol)) {
553             _error('Asset already issued');
554             return false;
555         }
556         uint holderId = _createHolderId(msg.sender);
557 
558         assets[_symbol] = Asset(holderId, _value, _name, _description, _isReissuable, _baseUnit, false);
559         assets[_symbol].wallets[holderId].balance = _value;
560         // Internal Out Of Gas/Throw: revert this transaction too;
561         // Recursive Call: safe, all changes already made.
562         eventsHistory.emitIssue(_symbol, _value, _address(holderId));
563         return true;
564     }
565 
566     function changeAsset(bytes32 _symbol, string _name, string _description, uint8 _baseUnit) onlyOwner(_symbol) returns(bool) {
567         if (isLocked(_symbol)) {
568             _error('Asset is locked');
569             return false;
570         }
571         assets[_symbol].name = _name;
572         assets[_symbol].description = _description;
573         assets[_symbol].baseUnit = _baseUnit;
574         eventsHistory.emitChange(_symbol);
575         return true;
576     }
577 
578     function lockAsset(bytes32 _symbol) onlyOwner(_symbol) returns(bool) {
579         if (isLocked(_symbol)) {
580             _error('Asset is locked');
581             return false;
582         }
583         assets[_symbol].isLocked = true;
584         return true;
585     }
586 
587     /**
588      * Issues additional asset tokens if the asset have dynamic supply.
589      *
590      * Tokens issued with this call go straight to asset owner.
591      * Can only be called by asset owner.
592      *
593      * @param _symbol asset symbol.
594      * @param _value amount of additional tokens to issue.
595      *
596      * @return success.
597      */
598     function reissueAsset(bytes32 _symbol, uint _value) onlyOwner(_symbol) returns(bool) {
599         // Should have positive value.
600         if (_value == 0) {
601             _error('Cannot reissue 0 value');
602             return false;
603         }
604         Asset asset = assets[_symbol];
605         // Should have dynamic supply.
606         if (!asset.isReissuable) {
607             _error('Cannot reissue fixed asset');
608             return false;
609         }
610         // Resulting total supply should not overflow.
611         if (asset.totalSupply + _value < asset.totalSupply) {
612             _error('Total supply overflow');
613             return false;
614         }
615         uint holderId = getHolderId(msg.sender);
616         asset.wallets[holderId].balance += _value;
617         asset.totalSupply += _value;
618         // Internal Out Of Gas/Throw: revert this transaction too;
619         // Recursive Call: safe, all changes already made.
620         eventsHistory.emitIssue(_symbol, _value, _address(holderId));
621         _proxyTransferEvent(0, holderId, _value, _symbol);
622         return true;
623     }
624 
625     /**
626      * Destroys specified amount of senders asset tokens.
627      *
628      * @param _symbol asset symbol.
629      * @param _value amount of tokens to destroy.
630      *
631      * @return success.
632      */
633     function revokeAsset(bytes32 _symbol, uint _value) checkEnabledSwitch(sha3(_symbol, Features.Revoke)) checkSigned(getHolderId(msg.sender), 1) returns(bool) {
634         // Should have positive value.
635         if (_value == 0) {
636             _error('Cannot revoke 0 value');
637             return false;
638         }
639         Asset asset = assets[_symbol];
640         uint holderId = getHolderId(msg.sender);
641         // Should have enough tokens.
642         if (asset.wallets[holderId].balance < _value) {
643             _error('Not enough tokens to revoke');
644             return false;
645         }
646         asset.wallets[holderId].balance -= _value;
647         asset.totalSupply -= _value;
648         // Internal Out Of Gas/Throw: revert this transaction too;
649         // Recursive Call: safe, all changes already made.
650         eventsHistory.emitRevoke(_symbol, _value, _address(holderId));
651         _proxyTransferEvent(holderId, 0, _value, _symbol);
652         return true;
653     }
654 
655     /**
656      * Passes asset ownership to specified address.
657      *
658      * Only ownership is changed, balances are not touched.
659      * Can only be called by asset owner.
660      *
661      * @param _symbol asset symbol.
662      * @param _newOwner address to become a new owner.
663      *
664      * @return success.
665      */
666     function changeOwnership(bytes32 _symbol, address _newOwner) checkEnabledSwitch(sha3(_symbol, Features.ChangeOwnership)) onlyOwner(_symbol) returns(bool) {
667         Asset asset = assets[_symbol];
668         uint newOwnerId = _createHolderId(_newOwner);
669         // Should pass ownership to another holder.
670         if (asset.owner == newOwnerId) {
671             _error('Cannot pass ownership to oneself');
672             return false;
673         }
674         address oldOwner = _address(asset.owner);
675         asset.owner = newOwnerId;
676         // Internal Out Of Gas/Throw: revert this transaction too;
677         // Recursive Call: safe, all changes already made.
678         eventsHistory.emitOwnershipChange(oldOwner, _address(newOwnerId), _symbol);
679         return true;
680     }
681 
682     function setCosignerAddress(Cosigner _cosigner) checkSigned(_createHolderId(msg.sender), 1) returns(bool) {
683         if (!_checkSigned(_cosigner, getHolderId(msg.sender), 1)) {
684             _error('Invalid cosigner');
685             return false;
686         }
687         holders[_createHolderId(msg.sender)].cosigner = _cosigner;
688         return true;
689     }
690 
691     function isCosignerSet(uint _holderId) constant returns(bool) {
692         return address(holders[_holderId].cosigner) != 0x0;
693     }
694 
695     function _checkSigned(Cosigner _cosigner, uint _holderId, uint _required) internal returns(bool) {
696         return _cosigner.consumeOperation(sha3(msg.data, _holderId), _required);
697     }
698 
699     modifier checkSigned(uint _holderId, uint _required) {
700         if (!isCosignerSet(_holderId) || _checkSigned(holders[_holderId].cosigner, _holderId, _required)) {
701             _;
702         } else {
703             _error('Cosigner: access denied');
704         }
705     }
706 
707     /**
708      * Check if specified holder trusts an address with recovery procedure.
709      *
710      * @param _from truster.
711      * @param _to trustee.
712      *
713      * @return trust existance.
714      */
715     function isTrusted(address _from, address _to) constant returns(bool) {
716         return holders[getHolderId(_from)].trust[_to];
717     }
718 
719     /**
720      * Trust an address to perform recovery procedure for the caller.
721      *
722      * @param _to trustee.
723      *
724      * @return success.
725      */
726     function trust(address _to) returns(bool) {
727         uint fromId = _createHolderId(msg.sender);
728         // Should trust to another address.
729         if (fromId == getHolderId(_to)) {
730             _error('Cannot trust to oneself');
731             return false;
732         }
733         // Should trust to yet untrusted.
734         if (isTrusted(msg.sender, _to)) {
735             _error('Already trusted');
736             return false;
737         }
738         holders[fromId].trust[_to] = true;
739         return true;
740     }
741 
742     /**
743      * Revoke trust to perform recovery procedure from an address.
744      *
745      * @param _to trustee.
746      *
747      * @return success.
748      */
749     function distrust(address _to) checkTrust(msg.sender, _to) returns(bool) {
750         holders[getHolderId(msg.sender)].trust[_to] = false;
751         return true;
752     }
753 
754     /**
755      * Perform recovery procedure.
756      *
757      * This function logic is actually more of an grantAccess(uint _holderId, address _to).
758      * It grants another address access to recovery subject wallets.
759      * Can only be called by trustee of recovery subject.
760      * If cosigning is enabled, should have atleast 2 confirmations.
761      *
762      * @dev Deprecated. Backward compatibility.
763      *
764      * @param _from holder address to recover from.
765      * @param _to address to grant access to.
766      *
767      * @return success.
768      */
769     function recover(address _from, address _to) checkTrust(_from, msg.sender) returns(bool) {
770         return _grantAccess(getHolderId(_from), _to);
771     }
772 
773     /**
774      * Perform recovery procedure.
775      *
776      * This function logic is actually more of an grantAccess(uint _holderId, address _to).
777      * It grants another address access to subject holder wallets.
778      * Can only be called if pre-confirmed by atleast 2 cosign oracles.
779      *
780      * @param _from holder address to recover from.
781      * @param _to address to grant access to.
782      *
783      * @return success.
784      */
785     function grantAccess(address _from, address _to) returns(bool) {
786         if (!isCosignerSet(getHolderId(_from))) {
787             _error('Cosigner not set');
788             return false;
789         }
790         return _grantAccess(getHolderId(_from), _to);
791     }
792 
793     function _grantAccess(uint _fromId, address _to) internal checkSigned(_fromId, 2) returns(bool) {
794         // Should recover to previously unused address.
795         if (getHolderId(_to) != 0) {
796             _error('Should recover to new address');
797             return false;
798         }
799         // We take current holder address because it might not equal _from.
800         // It is possible to recover from any old holder address, but event should have the current one.
801         address from = holders[_fromId].addr;
802         holders[_fromId].addr = _to;
803         holderIndex[_to] = _fromId;
804         // Internal Out Of Gas/Throw: revert this transaction too;
805         // Recursive Call: safe, all changes already made.
806         eventsHistory.emitRecovery(from, _to, msg.sender);
807         return true;
808     }
809 
810     /**
811      * Sets asset spending allowance for a specified spender.
812      *
813      * Note: to revoke allowance, one needs to set allowance to 0.
814      *
815      * @param _spenderId holder id to set allowance for.
816      * @param _value amount to allow.
817      * @param _symbol asset symbol.
818      * @param _senderId approve initiator holder id.
819      *
820      * @return success.
821      */
822     function _approve(uint _spenderId, uint _value, bytes32 _symbol, uint _senderId) internal checkEnabledSwitch(sha3(_symbol, Features.Allowances)) checkSigned(_senderId, 1) returns(bool) {
823         // Asset should exist.
824         if (!isCreated(_symbol)) {
825             _error('Asset is not issued');
826             return false;
827         }
828         // Should allow to another holder.
829         if (_senderId == _spenderId) {
830             _error('Cannot approve to oneself');
831             return false;
832         }
833         assets[_symbol].wallets[_senderId].allowance[_spenderId] = _value;
834         // Internal Out Of Gas/Throw: revert this transaction too;
835         // Recursive Call: safe, all changes already made.
836         eventsHistory.emitApprove(_address(_senderId), _address(_spenderId), _symbol, _value);
837         if (proxies[_symbol] != 0x0) {
838             // Internal Out Of Gas/Throw: revert this transaction too;
839             // Recursive Call: safe, all changes already made.
840             Proxy(proxies[_symbol]).emitApprove(_address(_senderId), _address(_spenderId), _value);
841         }
842         return true;
843     }
844 
845     /**
846      * Sets asset spending allowance for a specified spender.
847      *
848      * Can only be called by asset proxy.
849      *
850      * @param _spender holder address to set allowance to.
851      * @param _value amount to allow.
852      * @param _symbol asset symbol.
853      * @param _sender approve initiator address.
854      *
855      * @return success.
856      */
857     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) onlyProxy(_symbol) returns(bool) {
858         return _approve(_createHolderId(_spender), _value, _symbol, _createHolderId(_sender));
859     }
860 
861     /**
862      * Returns asset allowance from one holder to another.
863      *
864      * @param _from holder that allowed spending.
865      * @param _spender holder that is allowed to spend.
866      * @param _symbol asset symbol.
867      *
868      * @return holder to spender allowance.
869      */
870     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint) {
871         return _allowance(getHolderId(_from), getHolderId(_spender), _symbol);
872     }
873 
874     /**
875      * Returns asset allowance from one holder to another.
876      *
877      * @param _fromId holder id that allowed spending.
878      * @param _toId holder id that is allowed to spend.
879      * @param _symbol asset symbol.
880      *
881      * @return holder to spender allowance.
882      */
883     function _allowance(uint _fromId, uint _toId, bytes32 _symbol) constant internal returns(uint) {
884         return assets[_symbol].wallets[_fromId].allowance[_toId];
885     }
886 
887     /**
888      * Prforms allowance transfer of asset balance between holders wallets.
889      *
890      * Can only be called by asset proxy.
891      *
892      * @param _from holder address to take from.
893      * @param _to holder address to give to.
894      * @param _value amount to transfer.
895      * @param _symbol asset symbol.
896      * @param _reference transfer comment to be included in a Transfer event.
897      * @param _sender allowance transfer initiator address.
898      *
899      * @return success.
900      */
901     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) onlyProxy(_symbol) returns(bool) {
902         return _transfer(getHolderId(_from), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));
903     }
904 }