1 /**
2  * This software is a subject to Ambisafe License Agreement.
3  * No use or distribution is allowed without written permission from Ambisafe.
4  * https://www.ambisafe.co/terms-of-use/
5  */
6 
7 pragma solidity 0.4.8;
8 
9 contract EToken2 {
10     function baseUnit(bytes32 _symbol) constant returns(uint8);
11     function name(bytes32 _symbol) constant returns(string);
12     function description(bytes32 _symbol) constant returns(string);
13     function owner(bytes32 _symbol) constant returns(address);
14     function isOwner(address _owner, bytes32 _symbol) constant returns(bool);
15     function totalSupply(bytes32 _symbol) constant returns(uint);
16     function balanceOf(address _holder, bytes32 _symbol) constant returns(uint);
17     function proxyTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
18     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(bool);
19     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint);
20     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(bool);
21 }
22 
23 contract Asset {
24     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
25     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
26     function _performApprove(address _spender, uint _value, address _sender) returns(bool);    
27     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
28     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
29     function _performGeneric(bytes _data, address _sender) payable returns(bytes32) {
30         throw;
31     }
32 }
33 
34 contract ERC20 {
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed from, address indexed spender, uint256 value);
37 
38     function totalSupply() constant returns(uint256 supply);
39     function balanceOf(address _owner) constant returns(uint256 balance);
40     function transfer(address _to, uint256 _value) returns(bool success);
41     function transferFrom(address _from, address _to, uint256 _value) returns(bool success);
42     function approve(address _spender, uint256 _value) returns(bool success);
43     function allowance(address _owner, address _spender) constant returns(uint256 remaining);
44     function decimals() constant returns(uint8);
45 }
46 
47 contract AssetProxyInterface {
48     function _forwardApprove(address _spender, uint _value, address _sender) returns(bool);    
49     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
50     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
51 }
52 
53 contract Bytes32 {
54     function _bytes32(string _input) internal constant returns(bytes32 result) {
55         assembly {
56             result := mload(add(_input, 32))
57         }
58     }
59 }
60 
61 /**
62  * @title EToken2 Asset Proxy.
63  *
64  * Proxy implements ERC20 interface and acts as a gateway to a single EToken2 asset.
65  * Proxy adds etoken2Symbol and caller(sender) when forwarding requests to EToken2.
66  * Every request that is made by caller first sent to the specific asset implementation
67  * contract, which then calls back to be forwarded onto EToken2.
68  *
69  * Calls flow: Caller ->
70  *             Proxy.func(...) ->
71  *             Asset._performFunc(..., Caller.address) ->
72  *             Proxy._forwardFunc(..., Caller.address) ->
73  *             Platform.proxyFunc(..., symbol, Caller.address)
74  *
75  * Generic call flow: Caller ->
76  *             Proxy.unknownFunc(...) ->
77  *             Asset._performGeneric(..., Caller.address) ->
78  *             Asset.unknownFunc(...)
79  *
80  * Asset implementation contract is mutable, but each user have an option to stick with
81  * old implementation, through explicit decision made in timely manner, if he doesn't agree
82  * with new rules.
83  * Each user have a possibility to upgrade to latest asset contract implementation, without the
84  * possibility to rollback.
85  *
86  * Note: all the non constant functions return false instead of throwing in case if state change
87  * didn't happen yet.
88  */
89 contract TestingFake is ERC20, AssetProxyInterface, Bytes32 {
90     // Assigned EToken2, immutable.
91     EToken2 public etoken2;
92 
93     // Assigned symbol, immutable.
94     bytes32 public etoken2Symbol;
95 
96     // Assigned name, immutable. For UI.
97     string public name;
98     string public symbol;
99 
100     /**
101      * Sets EToken2 address, assigns symbol and name.
102      *
103      * Can be set only once.
104      *
105      * @param _etoken2 EToken2 contract address.
106      * @param _symbol assigned symbol.
107      * @param _name assigned name.
108      *
109      * @return success.
110      */
111     function init(EToken2 _etoken2, string _symbol, string _name) returns(bool) {
112         if (address(etoken2) != 0x0) {
113             return false;
114         }
115         etoken2 = _etoken2;
116         etoken2Symbol = _bytes32(_symbol);
117         name = _name;
118         symbol = _symbol;
119         return true;
120     }
121 
122     /**
123      * Only EToken2 is allowed to call.
124      */
125     modifier onlyEToken2() {
126         if (msg.sender == address(etoken2)) {
127             _;
128         }
129     }
130 
131     /**
132      * Only current asset owner is allowed to call.
133      */
134     modifier onlyAssetOwner() {
135         if (etoken2.isOwner(msg.sender, etoken2Symbol)) {
136             _;
137         }
138     }
139 
140     /**
141      * Returns asset implementation contract for current caller.
142      *
143      * @return asset implementation contract.
144      */
145     function _getAsset() internal returns(Asset) {
146         return Asset(getVersionFor(msg.sender));
147     }
148 
149     function recoverTokens(uint _value) onlyAssetOwner() returns(bool) {
150         return this.transferWithReference(msg.sender, _value, 'Tokens recovery');
151     }
152 
153     /**
154      * Returns asset total supply.
155      *
156      * @return asset total supply.
157      */
158     function totalSupply() constant returns(uint) {
159         return etoken2.totalSupply(etoken2Symbol);
160     }
161 
162     /**
163      * Returns asset balance for a particular holder.
164      *
165      * @param _owner holder address.
166      *
167      * @return holder balance.
168      */
169     function balanceOf(address _owner) constant returns(uint) {
170         return etoken2.balanceOf(_owner, etoken2Symbol);
171     }
172 
173     /**
174      * Returns asset allowance from one holder to another.
175      *
176      * @param _from holder that allowed spending.
177      * @param _spender holder that is allowed to spend.
178      *
179      * @return holder to spender allowance.
180      */
181     function allowance(address _from, address _spender) constant returns(uint) {
182         return etoken2.allowance(_from, _spender, etoken2Symbol);
183     }
184 
185     /**
186      * Returns asset decimals.
187      *
188      * @return asset decimals.
189      */
190     function decimals() constant returns(uint8) {
191         return etoken2.baseUnit(etoken2Symbol);
192     }
193 
194     /**
195      * Transfers asset balance from the caller to specified receiver.
196      *
197      * @param _to holder address to give to.
198      * @param _value amount to transfer.
199      *
200      * @return success.
201      */
202     function transfer(address _to, uint _value) returns(bool) {
203         return transferWithReference(_to, _value, '');
204     }
205 
206     /**
207      * Transfers asset balance from the caller to specified receiver adding specified comment.
208      * Resolves asset implementation contract for the caller and forwards there arguments along with
209      * the caller address.
210      *
211      * @param _to holder address to give to.
212      * @param _value amount to transfer.
213      * @param _reference transfer comment to be included in a EToken2's Transfer event.
214      *
215      * @return success.
216      */
217     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
218         return _getAsset()._performTransferWithReference(_to, _value, _reference, msg.sender);
219     }
220 
221     /**
222      * Transfers asset balance from the caller to specified ICAP.
223      *
224      * @param _icap recipient ICAP to give to.
225      * @param _value amount to transfer.
226      *
227      * @return success.
228      */
229     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
230         return transferToICAPWithReference(_icap, _value, '');
231     }
232 
233     /**
234      * Transfers asset balance from the caller to specified ICAP adding specified comment.
235      * Resolves asset implementation contract for the caller and forwards there arguments along with
236      * the caller address.
237      *
238      * @param _icap recipient ICAP to give to.
239      * @param _value amount to transfer.
240      * @param _reference transfer comment to be included in a EToken2's Transfer event.
241      *
242      * @return success.
243      */
244     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
245         return _getAsset()._performTransferToICAPWithReference(_icap, _value, _reference, msg.sender);
246     }
247 
248     /**
249      * Prforms allowance transfer of asset balance between holders.
250      *
251      * @param _from holder address to take from.
252      * @param _to holder address to give to.
253      * @param _value amount to transfer.
254      *
255      * @return success.
256      */
257     function transferFrom(address _from, address _to, uint _value) returns(bool) {
258         return transferFromWithReference(_from, _to, _value, '');
259     }
260 
261     /**
262      * Prforms allowance transfer of asset balance between holders adding specified comment.
263      * Resolves asset implementation contract for the caller and forwards there arguments along with
264      * the caller address.
265      *
266      * @param _from holder address to take from.
267      * @param _to holder address to give to.
268      * @param _value amount to transfer.
269      * @param _reference transfer comment to be included in a EToken2's Transfer event.
270      *
271      * @return success.
272      */
273     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
274         return _getAsset()._performTransferFromWithReference(_from, _to, _value, _reference, msg.sender);
275     }
276 
277     /**
278      * Performs transfer call on the EToken2 by the name of specified sender.
279      *
280      * Can only be called by asset implementation contract assigned to sender.
281      *
282      * @param _from holder address to take from.
283      * @param _to holder address to give to.
284      * @param _value amount to transfer.
285      * @param _reference transfer comment to be included in a EToken2's Transfer event.
286      * @param _sender initial caller.
287      *
288      * @return success.
289      */
290     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyImplementationFor(_sender) returns(bool) {
291         return etoken2.proxyTransferFromWithReference(_from, _to, _value, etoken2Symbol, _reference, _sender);
292     }
293 
294     /**
295      * Prforms allowance transfer of asset balance between holders.
296      *
297      * @param _from holder address to take from.
298      * @param _icap recipient ICAP address to give to.
299      * @param _value amount to transfer.
300      *
301      * @return success.
302      */
303     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
304         return transferFromToICAPWithReference(_from, _icap, _value, '');
305     }
306 
307     /**
308      * Prforms allowance transfer of asset balance between holders adding specified comment.
309      * Resolves asset implementation contract for the caller and forwards there arguments along with
310      * the caller address.
311      *
312      * @param _from holder address to take from.
313      * @param _icap recipient ICAP address to give to.
314      * @param _value amount to transfer.
315      * @param _reference transfer comment to be included in a EToken2's Transfer event.
316      *
317      * @return success.
318      */
319     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
320         return _getAsset()._performTransferFromToICAPWithReference(_from, _icap, _value, _reference, msg.sender);
321     }
322 
323     /**
324      * Performs allowance transfer to ICAP call on the EToken2 by the name of specified sender.
325      *
326      * Can only be called by asset implementation contract assigned to sender.
327      *
328      * @param _from holder address to take from.
329      * @param _icap recipient ICAP address to give to.
330      * @param _value amount to transfer.
331      * @param _reference transfer comment to be included in a EToken2's Transfer event.
332      * @param _sender initial caller.
333      *
334      * @return success.
335      */
336     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyImplementationFor(_sender) returns(bool) {
337         return etoken2.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
338     }
339 
340     /**
341      * Sets asset spending allowance for a specified spender.
342      * Resolves asset implementation contract for the caller and forwards there arguments along with
343      * the caller address.
344      *
345      * @param _spender holder address to set allowance to.
346      * @param _value amount to allow.
347      *
348      * @return success.
349      */
350     function approve(address _spender, uint _value) returns(bool) {
351         return _getAsset()._performApprove(_spender, _value, msg.sender);
352     }
353 
354     /**
355      * Performs allowance setting call on the EToken2 by the name of specified sender.
356      *
357      * Can only be called by asset implementation contract assigned to sender.
358      *
359      * @param _spender holder address to set allowance to.
360      * @param _value amount to allow.
361      * @param _sender initial caller.
362      *
363      * @return success.
364      */
365     function _forwardApprove(address _spender, uint _value, address _sender) onlyImplementationFor(_sender) returns(bool) {
366         return etoken2.proxyApprove(_spender, _value, etoken2Symbol, _sender);
367     }
368 
369     /**
370      * Emits ERC20 Transfer event on this contract.
371      *
372      * Can only be, and, called by assigned EToken2 when asset transfer happens.
373      */
374     function emitTransfer(address _from, address _to, uint _value) onlyEToken2() {
375         Transfer(_from, _to, _value);
376     }
377 
378     /**
379      * Emits ERC20 Approval event on this contract.
380      *
381      * Can only be, and, called by assigned EToken2 when asset allowance set happens.
382      */
383     function emitApprove(address _from, address _spender, uint _value) onlyEToken2() {
384         Approval(_from, _spender, _value);
385     }
386 
387     /**
388      * Resolves asset implementation contract for the caller and forwards there transaction data,
389      * along with the value. This allows for proxy interface growth.
390      */
391     function () payable {
392         bytes32 result = _getAsset()._performGeneric.value(msg.value)(msg.data, msg.sender);
393         assembly {
394             mstore(0, result)
395             return(0, 32)
396         }
397     }
398 
399     /**
400      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
401      */
402     event UpgradeProposal(address newVersion);
403 
404     // Current asset implementation contract address.
405     address latestVersion;
406 
407     // Proposed next asset implementation contract address.
408     address pendingVersion;
409 
410     // Upgrade freeze-time start.
411     uint pendingVersionTimestamp;
412 
413     // Timespan for users to review the new implementation and make decision.
414     uint constant UPGRADE_FREEZE_TIME = 3 days;
415 
416     // Asset implementation contract address that user decided to stick with.
417     // 0x0 means that user uses latest version.
418     mapping(address => address) userOptOutVersion;
419 
420     /**
421      * Only asset implementation contract assigned to sender is allowed to call.
422      */
423     modifier onlyImplementationFor(address _sender) {
424         if (getVersionFor(_sender) == msg.sender) {
425             _;
426         }
427     }
428 
429     /**
430      * Returns asset implementation contract address assigned to sender.
431      *
432      * @param _sender sender address.
433      *
434      * @return asset implementation contract address.
435      */
436     function getVersionFor(address _sender) constant returns(address) {
437         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
438     }
439 
440     /**
441      * Returns current asset implementation contract address.
442      *
443      * @return asset implementation contract address.
444      */
445     function getLatestVersion() constant returns(address) {
446         return latestVersion;
447     }
448 
449     /**
450      * Returns proposed next asset implementation contract address.
451      *
452      * @return asset implementation contract address.
453      */
454     function getPendingVersion() constant returns(address) {
455         return pendingVersion;
456     }
457 
458     /**
459      * Returns upgrade freeze-time start.
460      *
461      * @return freeze-time start.
462      */
463     function getPendingVersionTimestamp() constant returns(uint) {
464         return pendingVersionTimestamp;
465     }
466 
467     /**
468      * Propose next asset implementation contract address.
469      *
470      * Can only be called by current asset owner.
471      *
472      * Note: freeze-time should not be applied for the initial setup.
473      *
474      * @param _newVersion asset implementation contract address.
475      *
476      * @return success.
477      */
478     function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {
479         // Should not already be in the upgrading process.
480         if (pendingVersion != 0x0) {
481             return false;
482         }
483         // New version address should be other than 0x0.
484         if (_newVersion == 0x0) {
485             return false;
486         }
487         // Don't apply freeze-time for the initial setup.
488         if (latestVersion == 0x0) {
489             latestVersion = _newVersion;
490             return true;
491         }
492         pendingVersion = _newVersion;
493         pendingVersionTimestamp = now;
494         UpgradeProposal(_newVersion);
495         return true;
496     }
497 
498     /**
499      * Cancel the pending upgrade process.
500      *
501      * Can only be called by current asset owner.
502      *
503      * @return success.
504      */
505     function purgeUpgrade() onlyAssetOwner() returns(bool) {
506         if (pendingVersion == 0x0) {
507             return false;
508         }
509         delete pendingVersion;
510         delete pendingVersionTimestamp;
511         return true;
512     }
513 
514     /**
515      * Finalize an upgrade process setting new asset implementation contract address.
516      *
517      * Can only be called after an upgrade freeze-time.
518      *
519      * @return success.
520      */
521     function commitUpgrade() returns(bool) {
522         if (pendingVersion == 0x0) {
523             return false;
524         }
525         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
526             return false;
527         }
528         latestVersion = pendingVersion;
529         delete pendingVersion;
530         delete pendingVersionTimestamp;
531         return true;
532     }
533 
534     /**
535      * Disagree with proposed upgrade, and stick with current asset implementation
536      * until further explicit agreement to upgrade.
537      *
538      * @return success.
539      */
540     function optOut() returns(bool) {
541         if (userOptOutVersion[msg.sender] != 0x0) {
542             return false;
543         }
544         userOptOutVersion[msg.sender] = latestVersion;
545         return true;
546     }
547 
548     /**
549      * Implicitly agree to upgrade to current and future asset implementation upgrades,
550      * until further explicit disagreement.
551      *
552      * @return success.
553      */
554     function optIn() returns(bool) {
555         delete userOptOutVersion[msg.sender];
556         return true;
557     }
558 
559     // Backwards compatibility.
560     function multiAsset() constant returns(EToken2) {
561         return etoken2;
562     }
563 }