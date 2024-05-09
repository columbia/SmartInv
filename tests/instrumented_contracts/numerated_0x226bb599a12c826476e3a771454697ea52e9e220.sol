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
17     function isLocked(bytes32 _symbol) constant returns(bool);
18     function proxyTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
19     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(bool);
20     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint);
21     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(bool);
22 }
23 
24 contract Asset {
25     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
26     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
27     function _performApprove(address _spender, uint _value, address _sender) returns(bool);    
28     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
29     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
30     function _performGeneric(bytes _data, address _sender) payable returns(bytes32) {
31         throw;
32     }
33 }
34 
35 contract ERC20 {
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed from, address indexed spender, uint256 value);
38 
39     function totalSupply() constant returns(uint256 supply);
40     function balanceOf(address _owner) constant returns(uint256 balance);
41     function transfer(address _to, uint256 _value) returns(bool success);
42     function transferFrom(address _from, address _to, uint256 _value) returns(bool success);
43     function approve(address _spender, uint256 _value) returns(bool success);
44     function allowance(address _owner, address _spender) constant returns(uint256 remaining);
45     function decimals() constant returns(uint8);
46 }
47 
48 contract AssetProxyInterface {
49     function _forwardApprove(address _spender, uint _value, address _sender) returns(bool);    
50     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
51     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
52 }
53 
54 contract Bytes32 {
55     function _bytes32(string _input) internal constant returns(bytes32 result) {
56         assembly {
57             result := mload(add(_input, 32))
58         }
59     }
60 }
61 
62 /**
63  * @title EToken2 Asset Proxy.
64  *
65  * Proxy implements ERC20 interface and acts as a gateway to a single EToken2 asset.
66  * Proxy adds etoken2Symbol and caller(sender) when forwarding requests to EToken2.
67  * Every request that is made by caller first sent to the specific asset implementation
68  * contract, which then calls back to be forwarded onto EToken2.
69  *
70  * Calls flow: Caller ->
71  *             Proxy.func(...) ->
72  *             Asset._performFunc(..., Caller.address) ->
73  *             Proxy._forwardFunc(..., Caller.address) ->
74  *             Platform.proxyFunc(..., symbol, Caller.address)
75  *
76  * Generic call flow: Caller ->
77  *             Proxy.unknownFunc(...) ->
78  *             Asset._performGeneric(..., Caller.address) ->
79  *             Asset.unknownFunc(...)
80  *
81  * Asset implementation contract is mutable, but each user have an option to stick with
82  * old implementation, through explicit decision made in timely manner, if he doesn't agree
83  * with new rules.
84  * Each user have a possibility to upgrade to latest asset contract implementation, without the
85  * possibility to rollback.
86  *
87  * Note: all the non constant functions return false instead of throwing in case if state change
88  * didn't happen yet.
89  */
90 contract AssetProxy is ERC20, AssetProxyInterface, Bytes32 {
91     // Assigned EToken2, immutable.
92     EToken2 public etoken2;
93 
94     // Assigned symbol, immutable.
95     bytes32 public etoken2Symbol;
96 
97     // Assigned name, immutable. For UI.
98     string public name;
99     string public symbol;
100 
101     /**
102      * Sets EToken2 address, assigns symbol and name.
103      *
104      * Can be set only once.
105      *
106      * @param _etoken2 EToken2 contract address.
107      * @param _symbol assigned symbol.
108      * @param _name assigned name.
109      *
110      * @return success.
111      */
112     function init(EToken2 _etoken2, string _symbol, string _name) returns(bool) {
113         if (address(etoken2) != 0x0) {
114             return false;
115         }
116         etoken2 = _etoken2;
117         etoken2Symbol = _bytes32(_symbol);
118         name = _name;
119         symbol = _symbol;
120         return true;
121     }
122 
123     /**
124      * Only EToken2 is allowed to call.
125      */
126     modifier onlyEToken2() {
127         if (msg.sender == address(etoken2)) {
128             _;
129         }
130     }
131 
132     /**
133      * Only current asset owner is allowed to call.
134      */
135     modifier onlyAssetOwner() {
136         if (etoken2.isOwner(msg.sender, etoken2Symbol)) {
137             _;
138         }
139     }
140 
141     /**
142      * Returns asset implementation contract for current caller.
143      *
144      * @return asset implementation contract.
145      */
146     function _getAsset() internal returns(Asset) {
147         return Asset(getVersionFor(msg.sender));
148     }
149 
150     function recoverTokens(uint _value) onlyAssetOwner() returns(bool) {
151         return this.transferWithReference(msg.sender, _value, 'Tokens recovery');
152     }
153 
154     /**
155      * Returns asset total supply.
156      *
157      * @return asset total supply.
158      */
159     function totalSupply() constant returns(uint) {
160         return etoken2.totalSupply(etoken2Symbol);
161     }
162 
163     /**
164      * Returns asset balance for a particular holder.
165      *
166      * @param _owner holder address.
167      *
168      * @return holder balance.
169      */
170     function balanceOf(address _owner) constant returns(uint) {
171         return etoken2.balanceOf(_owner, etoken2Symbol);
172     }
173 
174     /**
175      * Returns asset allowance from one holder to another.
176      *
177      * @param _from holder that allowed spending.
178      * @param _spender holder that is allowed to spend.
179      *
180      * @return holder to spender allowance.
181      */
182     function allowance(address _from, address _spender) constant returns(uint) {
183         return etoken2.allowance(_from, _spender, etoken2Symbol);
184     }
185 
186     /**
187      * Returns asset decimals.
188      *
189      * @return asset decimals.
190      */
191     function decimals() constant returns(uint8) {
192         return etoken2.baseUnit(etoken2Symbol);
193     }
194 
195     /**
196      * Transfers asset balance from the caller to specified receiver.
197      *
198      * @param _to holder address to give to.
199      * @param _value amount to transfer.
200      *
201      * @return success.
202      */
203     function transfer(address _to, uint _value) returns(bool) {
204         return transferWithReference(_to, _value, '');
205     }
206 
207     /**
208      * Transfers asset balance from the caller to specified receiver adding specified comment.
209      * Resolves asset implementation contract for the caller and forwards there arguments along with
210      * the caller address.
211      *
212      * @param _to holder address to give to.
213      * @param _value amount to transfer.
214      * @param _reference transfer comment to be included in a EToken2's Transfer event.
215      *
216      * @return success.
217      */
218     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
219         return _getAsset()._performTransferWithReference(_to, _value, _reference, msg.sender);
220     }
221 
222     /**
223      * Transfers asset balance from the caller to specified ICAP.
224      *
225      * @param _icap recipient ICAP to give to.
226      * @param _value amount to transfer.
227      *
228      * @return success.
229      */
230     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
231         return transferToICAPWithReference(_icap, _value, '');
232     }
233 
234     /**
235      * Transfers asset balance from the caller to specified ICAP adding specified comment.
236      * Resolves asset implementation contract for the caller and forwards there arguments along with
237      * the caller address.
238      *
239      * @param _icap recipient ICAP to give to.
240      * @param _value amount to transfer.
241      * @param _reference transfer comment to be included in a EToken2's Transfer event.
242      *
243      * @return success.
244      */
245     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
246         return _getAsset()._performTransferToICAPWithReference(_icap, _value, _reference, msg.sender);
247     }
248 
249     /**
250      * Prforms allowance transfer of asset balance between holders.
251      *
252      * @param _from holder address to take from.
253      * @param _to holder address to give to.
254      * @param _value amount to transfer.
255      *
256      * @return success.
257      */
258     function transferFrom(address _from, address _to, uint _value) returns(bool) {
259         return transferFromWithReference(_from, _to, _value, '');
260     }
261 
262     /**
263      * Prforms allowance transfer of asset balance between holders adding specified comment.
264      * Resolves asset implementation contract for the caller and forwards there arguments along with
265      * the caller address.
266      *
267      * @param _from holder address to take from.
268      * @param _to holder address to give to.
269      * @param _value amount to transfer.
270      * @param _reference transfer comment to be included in a EToken2's Transfer event.
271      *
272      * @return success.
273      */
274     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
275         return _getAsset()._performTransferFromWithReference(_from, _to, _value, _reference, msg.sender);
276     }
277 
278     /**
279      * Performs transfer call on the EToken2 by the name of specified sender.
280      *
281      * Can only be called by asset implementation contract assigned to sender.
282      *
283      * @param _from holder address to take from.
284      * @param _to holder address to give to.
285      * @param _value amount to transfer.
286      * @param _reference transfer comment to be included in a EToken2's Transfer event.
287      * @param _sender initial caller.
288      *
289      * @return success.
290      */
291     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyImplementationFor(_sender) returns(bool) {
292         return etoken2.proxyTransferFromWithReference(_from, _to, _value, etoken2Symbol, _reference, _sender);
293     }
294 
295     /**
296      * Prforms allowance transfer of asset balance between holders.
297      *
298      * @param _from holder address to take from.
299      * @param _icap recipient ICAP address to give to.
300      * @param _value amount to transfer.
301      *
302      * @return success.
303      */
304     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
305         return transferFromToICAPWithReference(_from, _icap, _value, '');
306     }
307 
308     /**
309      * Prforms allowance transfer of asset balance between holders adding specified comment.
310      * Resolves asset implementation contract for the caller and forwards there arguments along with
311      * the caller address.
312      *
313      * @param _from holder address to take from.
314      * @param _icap recipient ICAP address to give to.
315      * @param _value amount to transfer.
316      * @param _reference transfer comment to be included in a EToken2's Transfer event.
317      *
318      * @return success.
319      */
320     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
321         return _getAsset()._performTransferFromToICAPWithReference(_from, _icap, _value, _reference, msg.sender);
322     }
323 
324     /**
325      * Performs allowance transfer to ICAP call on the EToken2 by the name of specified sender.
326      *
327      * Can only be called by asset implementation contract assigned to sender.
328      *
329      * @param _from holder address to take from.
330      * @param _icap recipient ICAP address to give to.
331      * @param _value amount to transfer.
332      * @param _reference transfer comment to be included in a EToken2's Transfer event.
333      * @param _sender initial caller.
334      *
335      * @return success.
336      */
337     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyImplementationFor(_sender) returns(bool) {
338         return etoken2.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
339     }
340 
341     /**
342      * Sets asset spending allowance for a specified spender.
343      * Resolves asset implementation contract for the caller and forwards there arguments along with
344      * the caller address.
345      *
346      * @param _spender holder address to set allowance to.
347      * @param _value amount to allow.
348      *
349      * @return success.
350      */
351     function approve(address _spender, uint _value) returns(bool) {
352         return _getAsset()._performApprove(_spender, _value, msg.sender);
353     }
354 
355     /**
356      * Performs allowance setting call on the EToken2 by the name of specified sender.
357      *
358      * Can only be called by asset implementation contract assigned to sender.
359      *
360      * @param _spender holder address to set allowance to.
361      * @param _value amount to allow.
362      * @param _sender initial caller.
363      *
364      * @return success.
365      */
366     function _forwardApprove(address _spender, uint _value, address _sender) onlyImplementationFor(_sender) returns(bool) {
367         return etoken2.proxyApprove(_spender, _value, etoken2Symbol, _sender);
368     }
369 
370     /**
371      * Emits ERC20 Transfer event on this contract.
372      *
373      * Can only be, and, called by assigned EToken2 when asset transfer happens.
374      */
375     function emitTransfer(address _from, address _to, uint _value) onlyEToken2() {
376         Transfer(_from, _to, _value);
377     }
378 
379     /**
380      * Emits ERC20 Approval event on this contract.
381      *
382      * Can only be, and, called by assigned EToken2 when asset allowance set happens.
383      */
384     function emitApprove(address _from, address _spender, uint _value) onlyEToken2() {
385         Approval(_from, _spender, _value);
386     }
387 
388     /**
389      * Resolves asset implementation contract for the caller and forwards there transaction data,
390      * along with the value. This allows for proxy interface growth.
391      */
392     function () payable {
393         bytes32 result = _getAsset()._performGeneric.value(msg.value)(msg.data, msg.sender);
394         assembly {
395             mstore(0, result)
396             return(0, 32)
397         }
398     }
399 
400     /**
401      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
402      */
403     event UpgradeProposal(address newVersion);
404 
405     // Current asset implementation contract address.
406     address latestVersion;
407 
408     // Proposed next asset implementation contract address.
409     address pendingVersion;
410 
411     // Upgrade freeze-time start.
412     uint pendingVersionTimestamp;
413 
414     // Timespan for users to review the new implementation and make decision.
415     uint constant UPGRADE_FREEZE_TIME = 3 days;
416 
417     // Asset implementation contract address that user decided to stick with.
418     // 0x0 means that user uses latest version.
419     mapping(address => address) userOptOutVersion;
420 
421     /**
422      * Only asset implementation contract assigned to sender is allowed to call.
423      */
424     modifier onlyImplementationFor(address _sender) {
425         if (getVersionFor(_sender) == msg.sender) {
426             _;
427         }
428     }
429 
430     /**
431      * Returns asset implementation contract address assigned to sender.
432      *
433      * @param _sender sender address.
434      *
435      * @return asset implementation contract address.
436      */
437     function getVersionFor(address _sender) constant returns(address) {
438         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
439     }
440 
441     /**
442      * Returns current asset implementation contract address.
443      *
444      * @return asset implementation contract address.
445      */
446     function getLatestVersion() constant returns(address) {
447         return latestVersion;
448     }
449 
450     /**
451      * Returns proposed next asset implementation contract address.
452      *
453      * @return asset implementation contract address.
454      */
455     function getPendingVersion() constant returns(address) {
456         return pendingVersion;
457     }
458 
459     /**
460      * Returns upgrade freeze-time start.
461      *
462      * @return freeze-time start.
463      */
464     function getPendingVersionTimestamp() constant returns(uint) {
465         return pendingVersionTimestamp;
466     }
467 
468     /**
469      * Propose next asset implementation contract address.
470      *
471      * Can only be called by current asset owner.
472      *
473      * Note: freeze-time should not be applied for the initial setup.
474      *
475      * @param _newVersion asset implementation contract address.
476      *
477      * @return success.
478      */
479     function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {
480         // Should not already be in the upgrading process.
481         if (pendingVersion != 0x0) {
482             return false;
483         }
484         // New version address should be other than 0x0.
485         if (_newVersion == 0x0) {
486             return false;
487         }
488         // Don't apply freeze-time for the initial setup.
489         if (latestVersion == 0x0) {
490             latestVersion = _newVersion;
491             return true;
492         }
493         pendingVersion = _newVersion;
494         pendingVersionTimestamp = now;
495         UpgradeProposal(_newVersion);
496         return true;
497     }
498 
499     /**
500      * Cancel the pending upgrade process.
501      *
502      * Can only be called by current asset owner.
503      *
504      * @return success.
505      */
506     function purgeUpgrade() onlyAssetOwner() returns(bool) {
507         if (pendingVersion == 0x0) {
508             return false;
509         }
510         delete pendingVersion;
511         delete pendingVersionTimestamp;
512         return true;
513     }
514 
515     /**
516      * Finalize an upgrade process setting new asset implementation contract address.
517      *
518      * Can only be called after an upgrade freeze-time.
519      *
520      * @return success.
521      */
522     function commitUpgrade() returns(bool) {
523         if (pendingVersion == 0x0) {
524             return false;
525         }
526         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
527             return false;
528         }
529         latestVersion = pendingVersion;
530         delete pendingVersion;
531         delete pendingVersionTimestamp;
532         return true;
533     }
534 
535     /**
536      * Disagree with proposed upgrade, and stick with current asset implementation
537      * until further explicit agreement to upgrade.
538      *
539      * @return success.
540      */
541     function optOut() returns(bool) {
542         if (userOptOutVersion[msg.sender] != 0x0) {
543             return false;
544         }
545         userOptOutVersion[msg.sender] = latestVersion;
546         return true;
547     }
548 
549     /**
550      * Implicitly agree to upgrade to current and future asset implementation upgrades,
551      * until further explicit disagreement.
552      *
553      * @return success.
554      */
555     function optIn() returns(bool) {
556         delete userOptOutVersion[msg.sender];
557         return true;
558     }
559 
560     // Backwards compatibility.
561     function multiAsset() constant returns(EToken2) {
562         return etoken2;
563     }
564 }
565 
566 contract PropyToken is AssetProxy {
567     function change(string _symbol, string _name) onlyAssetOwner() returns(bool) {
568         if (etoken2.isLocked(etoken2Symbol)) {
569             return false;
570         }
571         name = _name;
572         symbol = _symbol;
573         return true;
574     }
575 }