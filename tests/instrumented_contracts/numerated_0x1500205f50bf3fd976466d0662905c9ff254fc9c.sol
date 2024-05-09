1 pragma solidity 0.4.11;
2 
3 contract RegistryICAPInterface {
4     function parse(bytes32 _icap) constant returns(address, bytes32, bool);
5     function institutions(bytes32 _institution) constant returns(address);
6 }
7 
8 contract EToken2Interface {
9     function registryICAP() constant returns(RegistryICAPInterface);
10     function baseUnit(bytes32 _symbol) constant returns(uint8);
11     function description(bytes32 _symbol) constant returns(string);
12     function owner(bytes32 _symbol) constant returns(address);
13     function isOwner(address _owner, bytes32 _symbol) constant returns(bool);
14     function totalSupply(bytes32 _symbol) constant returns(uint);
15     function balanceOf(address _holder, bytes32 _symbol) constant returns(uint);
16     function isLocked(bytes32 _symbol) constant returns(bool);
17     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) returns(bool);
18     function reissueAsset(bytes32 _symbol, uint _value) returns(bool);
19     function revokeAsset(bytes32 _symbol, uint _value) returns(bool);
20     function setProxy(address _address, bytes32 _symbol) returns(bool);
21     function lockAsset(bytes32 _symbol) returns(bool);
22     function proxyTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
23     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(bool);
24     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint);
25     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(bool);
26 }
27 
28 contract AssetInterface {
29     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
30     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
31     function _performApprove(address _spender, uint _value, address _sender) returns(bool);
32     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
33     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
34     function _performGeneric(bytes _data, address _sender) payable returns(bytes32) {
35         throw;
36     }
37 }
38 
39 contract ERC20Interface {
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(address indexed from, address indexed spender, uint256 value);
42 
43     function totalSupply() constant returns(uint256 supply);
44     function balanceOf(address _owner) constant returns(uint256 balance);
45     function transfer(address _to, uint256 _value) returns(bool success);
46     function transferFrom(address _from, address _to, uint256 _value) returns(bool success);
47     function approve(address _spender, uint256 _value) returns(bool success);
48     function allowance(address _owner, address _spender) constant returns(uint256 remaining);
49 
50     // function symbol() constant returns(string);
51     function decimals() constant returns(uint8);
52     // function name() constant returns(string);
53 }
54 
55 contract AssetProxyInterface {
56     function _forwardApprove(address _spender, uint _value, address _sender) returns(bool);
57     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
58     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
59     function balanceOf(address _owner) constant returns(uint);
60 }
61 
62 contract Bytes32 {
63     function _bytes32(string _input) internal constant returns(bytes32 result) {
64         assembly {
65             result := mload(add(_input, 32))
66         }
67     }
68 }
69 
70 /**
71  * @title EToken2 Asset Proxy.
72  *
73  * Proxy implements ERC20 interface and acts as a gateway to a single EToken2 asset.
74  * Proxy adds etoken2Symbol and caller(sender) when forwarding requests to EToken2.
75  * Every request that is made by caller first sent to the specific asset implementation
76  * contract, which then calls back to be forwarded onto EToken2.
77  *
78  * Calls flow: Caller ->
79  *             Proxy.func(...) ->
80  *             Asset._performFunc(..., Caller.address) ->
81  *             Proxy._forwardFunc(..., Caller.address) ->
82  *             Platform.proxyFunc(..., symbol, Caller.address)
83  *
84  * Generic call flow: Caller ->
85  *             Proxy.unknownFunc(...) ->
86  *             Asset._performGeneric(..., Caller.address) ->
87  *             Asset.unknownFunc(...)
88  *
89  * Asset implementation contract is mutable, but each user have an option to stick with
90  * old implementation, through explicit decision made in timely manner, if he doesn't agree
91  * with new rules.
92  * Each user have a possibility to upgrade to latest asset contract implementation, without the
93  * possibility to rollback.
94  *
95  * Note: all the non constant functions return false instead of throwing in case if state change
96  * didn't happen yet.
97  */
98 contract BitBoostTokens is ERC20Interface, AssetProxyInterface, Bytes32 {
99     // Assigned EToken2, immutable.
100     EToken2Interface public etoken2;
101 
102     // Assigned symbol, immutable.
103     bytes32 public etoken2Symbol;
104 
105     // Assigned name, immutable. For UI.
106     string public name;
107     string public symbol;
108 
109     /**
110      * Sets EToken2 address, assigns symbol and name.
111      *
112      * Can be set only once.
113      *
114      * @param _etoken2 EToken2 contract address.
115      * @param _symbol assigned symbol.
116      * @param _name assigned name.
117      *
118      * @return success.
119      */
120     function init(EToken2Interface _etoken2, string _symbol, string _name) returns(bool) {
121         if (address(etoken2) != 0x0) {
122             return false;
123         }
124         etoken2 = _etoken2;
125         etoken2Symbol = _bytes32(_symbol);
126         name = _name;
127         symbol = _symbol;
128         return true;
129     }
130 
131     /**
132      * Only EToken2 is allowed to call.
133      */
134     modifier onlyEToken2() {
135         if (msg.sender == address(etoken2)) {
136             _;
137         }
138     }
139 
140     /**
141      * Only current asset owner is allowed to call.
142      */
143     modifier onlyAssetOwner() {
144         if (etoken2.isOwner(msg.sender, etoken2Symbol)) {
145             _;
146         }
147     }
148 
149     /**
150      * Returns asset implementation contract for current caller.
151      *
152      * @return asset implementation contract.
153      */
154     function _getAsset() internal returns(AssetInterface) {
155         return AssetInterface(getVersionFor(msg.sender));
156     }
157 
158     function recoverTokens(uint _value) onlyAssetOwner() returns(bool) {
159         return this.transferWithReference(msg.sender, _value, 'Tokens recovery');
160     }
161 
162     /**
163      * Returns asset total supply.
164      *
165      * @return asset total supply.
166      */
167     function totalSupply() constant returns(uint) {
168         return etoken2.totalSupply(etoken2Symbol);
169     }
170 
171     /**
172      * Returns asset balance for a particular holder.
173      *
174      * @param _owner holder address.
175      *
176      * @return holder balance.
177      */
178     function balanceOf(address _owner) constant returns(uint) {
179         return etoken2.balanceOf(_owner, etoken2Symbol);
180     }
181 
182     /**
183      * Returns asset allowance from one holder to another.
184      *
185      * @param _from holder that allowed spending.
186      * @param _spender holder that is allowed to spend.
187      *
188      * @return holder to spender allowance.
189      */
190     function allowance(address _from, address _spender) constant returns(uint) {
191         return etoken2.allowance(_from, _spender, etoken2Symbol);
192     }
193 
194     /**
195      * Returns asset decimals.
196      *
197      * @return asset decimals.
198      */
199     function decimals() constant returns(uint8) {
200         return etoken2.baseUnit(etoken2Symbol);
201     }
202 
203     /**
204      * Transfers asset balance from the caller to specified receiver.
205      *
206      * @param _to holder address to give to.
207      * @param _value amount to transfer.
208      *
209      * @return success.
210      */
211     function transfer(address _to, uint _value) returns(bool) {
212         return transferWithReference(_to, _value, '');
213     }
214 
215     /**
216      * Transfers asset balance from the caller to specified receiver adding specified comment.
217      * Resolves asset implementation contract for the caller and forwards there arguments along with
218      * the caller address.
219      *
220      * @param _to holder address to give to.
221      * @param _value amount to transfer.
222      * @param _reference transfer comment to be included in a EToken2's Transfer event.
223      *
224      * @return success.
225      */
226     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
227         return _getAsset()._performTransferWithReference(_to, _value, _reference, msg.sender);
228     }
229 
230     /**
231      * Transfers asset balance from the caller to specified ICAP.
232      *
233      * @param _icap recipient ICAP to give to.
234      * @param _value amount to transfer.
235      *
236      * @return success.
237      */
238     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
239         return transferToICAPWithReference(_icap, _value, '');
240     }
241 
242     /**
243      * Transfers asset balance from the caller to specified ICAP adding specified comment.
244      * Resolves asset implementation contract for the caller and forwards there arguments along with
245      * the caller address.
246      *
247      * @param _icap recipient ICAP to give to.
248      * @param _value amount to transfer.
249      * @param _reference transfer comment to be included in a EToken2's Transfer event.
250      *
251      * @return success.
252      */
253     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
254         return _getAsset()._performTransferToICAPWithReference(_icap, _value, _reference, msg.sender);
255     }
256 
257     /**
258      * Prforms allowance transfer of asset balance between holders.
259      *
260      * @param _from holder address to take from.
261      * @param _to holder address to give to.
262      * @param _value amount to transfer.
263      *
264      * @return success.
265      */
266     function transferFrom(address _from, address _to, uint _value) returns(bool) {
267         return transferFromWithReference(_from, _to, _value, '');
268     }
269 
270     /**
271      * Prforms allowance transfer of asset balance between holders adding specified comment.
272      * Resolves asset implementation contract for the caller and forwards there arguments along with
273      * the caller address.
274      *
275      * @param _from holder address to take from.
276      * @param _to holder address to give to.
277      * @param _value amount to transfer.
278      * @param _reference transfer comment to be included in a EToken2's Transfer event.
279      *
280      * @return success.
281      */
282     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
283         return _getAsset()._performTransferFromWithReference(_from, _to, _value, _reference, msg.sender);
284     }
285 
286     /**
287      * Performs transfer call on the EToken2 by the name of specified sender.
288      *
289      * Can only be called by asset implementation contract assigned to sender.
290      *
291      * @param _from holder address to take from.
292      * @param _to holder address to give to.
293      * @param _value amount to transfer.
294      * @param _reference transfer comment to be included in a EToken2's Transfer event.
295      * @param _sender initial caller.
296      *
297      * @return success.
298      */
299     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyImplementationFor(_sender) returns(bool) {
300         return etoken2.proxyTransferFromWithReference(_from, _to, _value, etoken2Symbol, _reference, _sender);
301     }
302 
303     /**
304      * Prforms allowance transfer of asset balance between holders.
305      *
306      * @param _from holder address to take from.
307      * @param _icap recipient ICAP address to give to.
308      * @param _value amount to transfer.
309      *
310      * @return success.
311      */
312     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
313         return transferFromToICAPWithReference(_from, _icap, _value, '');
314     }
315 
316     /**
317      * Prforms allowance transfer of asset balance between holders adding specified comment.
318      * Resolves asset implementation contract for the caller and forwards there arguments along with
319      * the caller address.
320      *
321      * @param _from holder address to take from.
322      * @param _icap recipient ICAP address to give to.
323      * @param _value amount to transfer.
324      * @param _reference transfer comment to be included in a EToken2's Transfer event.
325      *
326      * @return success.
327      */
328     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
329         return _getAsset()._performTransferFromToICAPWithReference(_from, _icap, _value, _reference, msg.sender);
330     }
331 
332     /**
333      * Performs allowance transfer to ICAP call on the EToken2 by the name of specified sender.
334      *
335      * Can only be called by asset implementation contract assigned to sender.
336      *
337      * @param _from holder address to take from.
338      * @param _icap recipient ICAP address to give to.
339      * @param _value amount to transfer.
340      * @param _reference transfer comment to be included in a EToken2's Transfer event.
341      * @param _sender initial caller.
342      *
343      * @return success.
344      */
345     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyImplementationFor(_sender) returns(bool) {
346         return etoken2.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
347     }
348 
349     /**
350      * Sets asset spending allowance for a specified spender.
351      * Resolves asset implementation contract for the caller and forwards there arguments along with
352      * the caller address.
353      *
354      * @param _spender holder address to set allowance to.
355      * @param _value amount to allow.
356      *
357      * @return success.
358      */
359     function approve(address _spender, uint _value) returns(bool) {
360         return _getAsset()._performApprove(_spender, _value, msg.sender);
361     }
362 
363     /**
364      * Performs allowance setting call on the EToken2 by the name of specified sender.
365      *
366      * Can only be called by asset implementation contract assigned to sender.
367      *
368      * @param _spender holder address to set allowance to.
369      * @param _value amount to allow.
370      * @param _sender initial caller.
371      *
372      * @return success.
373      */
374     function _forwardApprove(address _spender, uint _value, address _sender) onlyImplementationFor(_sender) returns(bool) {
375         return etoken2.proxyApprove(_spender, _value, etoken2Symbol, _sender);
376     }
377 
378     /**
379      * Emits ERC20 Transfer event on this contract.
380      *
381      * Can only be, and, called by assigned EToken2 when asset transfer happens.
382      */
383     function emitTransfer(address _from, address _to, uint _value) onlyEToken2() {
384         Transfer(_from, _to, _value);
385     }
386 
387     /**
388      * Emits ERC20 Approval event on this contract.
389      *
390      * Can only be, and, called by assigned EToken2 when asset allowance set happens.
391      */
392     function emitApprove(address _from, address _spender, uint _value) onlyEToken2() {
393         Approval(_from, _spender, _value);
394     }
395 
396     /**
397      * Resolves asset implementation contract for the caller and forwards there transaction data,
398      * along with the value. This allows for proxy interface growth.
399      */
400     function () payable {
401         bytes32 result = _getAsset()._performGeneric.value(msg.value)(msg.data, msg.sender);
402         assembly {
403             mstore(0, result)
404             return(0, 32)
405         }
406     }
407 
408     /**
409      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
410      */
411     event UpgradeProposal(address newVersion);
412 
413     // Current asset implementation contract address.
414     address latestVersion;
415 
416     // Proposed next asset implementation contract address.
417     address pendingVersion;
418 
419     // Upgrade freeze-time start.
420     uint pendingVersionTimestamp;
421 
422     // Timespan for users to review the new implementation and make decision.
423     uint constant UPGRADE_FREEZE_TIME = 3 days;
424 
425     // Asset implementation contract address that user decided to stick with.
426     // 0x0 means that user uses latest version.
427     mapping(address => address) userOptOutVersion;
428 
429     /**
430      * Only asset implementation contract assigned to sender is allowed to call.
431      */
432     modifier onlyImplementationFor(address _sender) {
433         if (getVersionFor(_sender) == msg.sender) {
434             _;
435         }
436     }
437 
438     /**
439      * Returns asset implementation contract address assigned to sender.
440      *
441      * @param _sender sender address.
442      *
443      * @return asset implementation contract address.
444      */
445     function getVersionFor(address _sender) constant returns(address) {
446         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
447     }
448 
449     /**
450      * Returns current asset implementation contract address.
451      *
452      * @return asset implementation contract address.
453      */
454     function getLatestVersion() constant returns(address) {
455         return latestVersion;
456     }
457 
458     /**
459      * Returns proposed next asset implementation contract address.
460      *
461      * @return asset implementation contract address.
462      */
463     function getPendingVersion() constant returns(address) {
464         return pendingVersion;
465     }
466 
467     /**
468      * Returns upgrade freeze-time start.
469      *
470      * @return freeze-time start.
471      */
472     function getPendingVersionTimestamp() constant returns(uint) {
473         return pendingVersionTimestamp;
474     }
475 
476     /**
477      * Propose next asset implementation contract address.
478      *
479      * Can only be called by current asset owner.
480      *
481      * Note: freeze-time should not be applied for the initial setup.
482      *
483      * @param _newVersion asset implementation contract address.
484      *
485      * @return success.
486      */
487     function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {
488         // Should not already be in the upgrading process.
489         if (pendingVersion != 0x0) {
490             return false;
491         }
492         // New version address should be other than 0x0.
493         if (_newVersion == 0x0) {
494             return false;
495         }
496         // Don't apply freeze-time for the initial setup.
497         if (latestVersion == 0x0) {
498             latestVersion = _newVersion;
499             return true;
500         }
501         pendingVersion = _newVersion;
502         pendingVersionTimestamp = now;
503         UpgradeProposal(_newVersion);
504         return true;
505     }
506 
507     /**
508      * Cancel the pending upgrade process.
509      *
510      * Can only be called by current asset owner.
511      *
512      * @return success.
513      */
514     function purgeUpgrade() onlyAssetOwner() returns(bool) {
515         if (pendingVersion == 0x0) {
516             return false;
517         }
518         delete pendingVersion;
519         delete pendingVersionTimestamp;
520         return true;
521     }
522 
523     /**
524      * Finalize an upgrade process setting new asset implementation contract address.
525      *
526      * Can only be called after an upgrade freeze-time.
527      *
528      * @return success.
529      */
530     function commitUpgrade() returns(bool) {
531         if (pendingVersion == 0x0) {
532             return false;
533         }
534         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
535             return false;
536         }
537         latestVersion = pendingVersion;
538         delete pendingVersion;
539         delete pendingVersionTimestamp;
540         return true;
541     }
542 
543     /**
544      * Disagree with proposed upgrade, and stick with current asset implementation
545      * until further explicit agreement to upgrade.
546      *
547      * @return success.
548      */
549     function optOut() returns(bool) {
550         if (userOptOutVersion[msg.sender] != 0x0) {
551             return false;
552         }
553         userOptOutVersion[msg.sender] = latestVersion;
554         return true;
555     }
556 
557     /**
558      * Implicitly agree to upgrade to current and future asset implementation upgrades,
559      * until further explicit disagreement.
560      *
561      * @return success.
562      */
563     function optIn() returns(bool) {
564         delete userOptOutVersion[msg.sender];
565         return true;
566     }
567 
568     // Backwards compatibility.
569     function multiAsset() constant returns(EToken2Interface) {
570         return etoken2;
571     }
572 }