1 pragma solidity 0.4.8;
2 
3 contract EToken2 {
4     function baseUnit(bytes32 _symbol) constant returns(uint8);
5     function name(bytes32 _symbol) constant returns(string);
6     function description(bytes32 _symbol) constant returns(string);
7     function owner(bytes32 _symbol) constant returns(address);
8     function isOwner(address _owner, bytes32 _symbol) constant returns(bool);
9     function totalSupply(bytes32 _symbol) constant returns(uint);
10     function balanceOf(address _holder, bytes32 _symbol) constant returns(uint);
11     function proxyTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
12     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(bool);
13     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint);
14     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(bool);
15 }
16 
17 contract Asset {
18     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
19     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
20     function _performApprove(address _spender, uint _value, address _sender) returns(bool);    
21     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
22     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
23     function _performGeneric(bytes _data, address _sender) payable returns(bytes32) {
24         throw;
25     }
26 }
27 
28 contract ERC20 {
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed from, address indexed spender, uint256 value);
31 
32     function totalSupply() constant returns(uint256 supply);
33     function balanceOf(address _owner) constant returns(uint256 balance);
34     function transfer(address _to, uint256 _value) returns(bool success);
35     function transferFrom(address _from, address _to, uint256 _value) returns(bool success);
36     function approve(address _spender, uint256 _value) returns(bool success);
37     function allowance(address _owner, address _spender) constant returns(uint256 remaining);
38     function decimals() constant returns(uint8);
39 }
40 
41 contract AssetProxyInterface {
42     function _forwardApprove(address _spender, uint _value, address _sender) returns(bool);    
43     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
44     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
45 }
46 
47 contract Bytes32 {
48     function _bytes32(string _input) internal constant returns(bytes32 result) {
49         assembly {
50             result := mload(add(_input, 32))
51         }
52     }
53 }
54 
55 /**
56  * @title EToken2 Asset Proxy.
57  *
58  * Proxy implements ERC20 interface and acts as a gateway to a single EToken2 asset.
59  * Proxy adds etoken2Symbol and caller(sender) when forwarding requests to EToken2.
60  * Every request that is made by caller first sent to the specific asset implementation
61  * contract, which then calls back to be forwarded onto EToken2.
62  *
63  * Calls flow: Caller ->
64  *             Proxy.func(...) ->
65  *             Asset._performFunc(..., Caller.address) ->
66  *             Proxy._forwardFunc(..., Caller.address) ->
67  *             Platform.proxyFunc(..., symbol, Caller.address)
68  *
69  * Generic call flow: Caller ->
70  *             Proxy.unknownFunc(...) ->
71  *             Asset._performGeneric(..., Caller.address) ->
72  *             Asset.unknownFunc(...)
73  *
74  * Asset implementation contract is mutable, but each user have an option to stick with
75  * old implementation, through explicit decision made in timely manner, if he doesn't agree
76  * with new rules.
77  * Each user have a possibility to upgrade to latest asset contract implementation, without the
78  * possibility to rollback.
79  *
80  * Note: all the non constant functions return false instead of throwing in case if state change
81  * didn't happen yet.
82  */
83 contract TAAS is ERC20, AssetProxyInterface, Bytes32 {
84     // Assigned EToken2, immutable.
85     EToken2 public etoken2;
86 
87     // Assigned symbol, immutable.
88     bytes32 public etoken2Symbol;
89 
90     // Assigned name, immutable. For UI.
91     string public name;
92     string public symbol;
93 
94     /**
95      * Sets EToken2 address, assigns symbol and name.
96      *
97      * Can be set only once.
98      *
99      * @param _etoken2 EToken2 contract address.
100      * @param _symbol assigned symbol.
101      * @param _name assigned name.
102      *
103      * @return success.
104      */
105     function init(EToken2 _etoken2, string _symbol, string _name) returns(bool) {
106         if (address(etoken2) != 0x0) {
107             return false;
108         }
109         etoken2 = _etoken2;
110         etoken2Symbol = _bytes32(_symbol);
111         name = _name;
112         symbol = _symbol;
113         return true;
114     }
115 
116     /**
117      * Only EToken2 is allowed to call.
118      */
119     modifier onlyEToken2() {
120         if (msg.sender == address(etoken2)) {
121             _;
122         }
123     }
124 
125     /**
126      * Only current asset owner is allowed to call.
127      */
128     modifier onlyAssetOwner() {
129         if (etoken2.isOwner(msg.sender, etoken2Symbol)) {
130             _;
131         }
132     }
133 
134     /**
135      * Returns asset implementation contract for current caller.
136      *
137      * @return asset implementation contract.
138      */
139     function _getAsset() internal returns(Asset) {
140         return Asset(getVersionFor(msg.sender));
141     }
142 
143     function recoverTokens(uint _value) onlyAssetOwner() returns(bool) {
144         return this.transferWithReference(msg.sender, _value, 'Tokens recovery');
145     }
146 
147     /**
148      * Returns asset total supply.
149      *
150      * @return asset total supply.
151      */
152     function totalSupply() constant returns(uint) {
153         return etoken2.totalSupply(etoken2Symbol);
154     }
155 
156     /**
157      * Returns asset balance for a particular holder.
158      *
159      * @param _owner holder address.
160      *
161      * @return holder balance.
162      */
163     function balanceOf(address _owner) constant returns(uint) {
164         return etoken2.balanceOf(_owner, etoken2Symbol);
165     }
166 
167     /**
168      * Returns asset allowance from one holder to another.
169      *
170      * @param _from holder that allowed spending.
171      * @param _spender holder that is allowed to spend.
172      *
173      * @return holder to spender allowance.
174      */
175     function allowance(address _from, address _spender) constant returns(uint) {
176         return etoken2.allowance(_from, _spender, etoken2Symbol);
177     }
178 
179     /**
180      * Returns asset decimals.
181      *
182      * @return asset decimals.
183      */
184     function decimals() constant returns(uint8) {
185         return etoken2.baseUnit(etoken2Symbol);
186     }
187 
188     /**
189      * Transfers asset balance from the caller to specified receiver.
190      *
191      * @param _to holder address to give to.
192      * @param _value amount to transfer.
193      *
194      * @return success.
195      */
196     function transfer(address _to, uint _value) returns(bool) {
197         return transferWithReference(_to, _value, '');
198     }
199 
200     /**
201      * Transfers asset balance from the caller to specified receiver adding specified comment.
202      * Resolves asset implementation contract for the caller and forwards there arguments along with
203      * the caller address.
204      *
205      * @param _to holder address to give to.
206      * @param _value amount to transfer.
207      * @param _reference transfer comment to be included in a EToken2's Transfer event.
208      *
209      * @return success.
210      */
211     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
212         return _getAsset()._performTransferWithReference(_to, _value, _reference, msg.sender);
213     }
214 
215     /**
216      * Transfers asset balance from the caller to specified ICAP.
217      *
218      * @param _icap recipient ICAP to give to.
219      * @param _value amount to transfer.
220      *
221      * @return success.
222      */
223     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
224         return transferToICAPWithReference(_icap, _value, '');
225     }
226 
227     /**
228      * Transfers asset balance from the caller to specified ICAP adding specified comment.
229      * Resolves asset implementation contract for the caller and forwards there arguments along with
230      * the caller address.
231      *
232      * @param _icap recipient ICAP to give to.
233      * @param _value amount to transfer.
234      * @param _reference transfer comment to be included in a EToken2's Transfer event.
235      *
236      * @return success.
237      */
238     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
239         return _getAsset()._performTransferToICAPWithReference(_icap, _value, _reference, msg.sender);
240     }
241 
242     /**
243      * Prforms allowance transfer of asset balance between holders.
244      *
245      * @param _from holder address to take from.
246      * @param _to holder address to give to.
247      * @param _value amount to transfer.
248      *
249      * @return success.
250      */
251     function transferFrom(address _from, address _to, uint _value) returns(bool) {
252         return transferFromWithReference(_from, _to, _value, '');
253     }
254 
255     /**
256      * Prforms allowance transfer of asset balance between holders adding specified comment.
257      * Resolves asset implementation contract for the caller and forwards there arguments along with
258      * the caller address.
259      *
260      * @param _from holder address to take from.
261      * @param _to holder address to give to.
262      * @param _value amount to transfer.
263      * @param _reference transfer comment to be included in a EToken2's Transfer event.
264      *
265      * @return success.
266      */
267     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
268         return _getAsset()._performTransferFromWithReference(_from, _to, _value, _reference, msg.sender);
269     }
270 
271     /**
272      * Performs transfer call on the EToken2 by the name of specified sender.
273      *
274      * Can only be called by asset implementation contract assigned to sender.
275      *
276      * @param _from holder address to take from.
277      * @param _to holder address to give to.
278      * @param _value amount to transfer.
279      * @param _reference transfer comment to be included in a EToken2's Transfer event.
280      * @param _sender initial caller.
281      *
282      * @return success.
283      */
284     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyImplementationFor(_sender) returns(bool) {
285         return etoken2.proxyTransferFromWithReference(_from, _to, _value, etoken2Symbol, _reference, _sender);
286     }
287 
288     /**
289      * Prforms allowance transfer of asset balance between holders.
290      *
291      * @param _from holder address to take from.
292      * @param _icap recipient ICAP address to give to.
293      * @param _value amount to transfer.
294      *
295      * @return success.
296      */
297     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
298         return transferFromToICAPWithReference(_from, _icap, _value, '');
299     }
300 
301     /**
302      * Prforms allowance transfer of asset balance between holders adding specified comment.
303      * Resolves asset implementation contract for the caller and forwards there arguments along with
304      * the caller address.
305      *
306      * @param _from holder address to take from.
307      * @param _icap recipient ICAP address to give to.
308      * @param _value amount to transfer.
309      * @param _reference transfer comment to be included in a EToken2's Transfer event.
310      *
311      * @return success.
312      */
313     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
314         return _getAsset()._performTransferFromToICAPWithReference(_from, _icap, _value, _reference, msg.sender);
315     }
316 
317     /**
318      * Performs allowance transfer to ICAP call on the EToken2 by the name of specified sender.
319      *
320      * Can only be called by asset implementation contract assigned to sender.
321      *
322      * @param _from holder address to take from.
323      * @param _icap recipient ICAP address to give to.
324      * @param _value amount to transfer.
325      * @param _reference transfer comment to be included in a EToken2's Transfer event.
326      * @param _sender initial caller.
327      *
328      * @return success.
329      */
330     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyImplementationFor(_sender) returns(bool) {
331         return etoken2.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
332     }
333 
334     /**
335      * Sets asset spending allowance for a specified spender.
336      * Resolves asset implementation contract for the caller and forwards there arguments along with
337      * the caller address.
338      *
339      * @param _spender holder address to set allowance to.
340      * @param _value amount to allow.
341      *
342      * @return success.
343      */
344     function approve(address _spender, uint _value) returns(bool) {
345         return _getAsset()._performApprove(_spender, _value, msg.sender);
346     }
347 
348     /**
349      * Performs allowance setting call on the EToken2 by the name of specified sender.
350      *
351      * Can only be called by asset implementation contract assigned to sender.
352      *
353      * @param _spender holder address to set allowance to.
354      * @param _value amount to allow.
355      * @param _sender initial caller.
356      *
357      * @return success.
358      */
359     function _forwardApprove(address _spender, uint _value, address _sender) onlyImplementationFor(_sender) returns(bool) {
360         return etoken2.proxyApprove(_spender, _value, etoken2Symbol, _sender);
361     }
362 
363     /**
364      * Emits ERC20 Transfer event on this contract.
365      *
366      * Can only be, and, called by assigned EToken2 when asset transfer happens.
367      */
368     function emitTransfer(address _from, address _to, uint _value) onlyEToken2() {
369         Transfer(_from, _to, _value);
370     }
371 
372     /**
373      * Emits ERC20 Approval event on this contract.
374      *
375      * Can only be, and, called by assigned EToken2 when asset allowance set happens.
376      */
377     function emitApprove(address _from, address _spender, uint _value) onlyEToken2() {
378         Approval(_from, _spender, _value);
379     }
380 
381     /**
382      * Resolves asset implementation contract for the caller and forwards there transaction data,
383      * along with the value. This allows for proxy interface growth.
384      */
385     function () payable {
386         bytes32 result = _getAsset()._performGeneric.value(msg.value)(msg.data, msg.sender);
387         assembly {
388             mstore(0, result)
389             return(0, 32)
390         }
391     }
392 
393     /**
394      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
395      */
396     event UpgradeProposal(address newVersion);
397 
398     // Current asset implementation contract address.
399     address latestVersion;
400 
401     // Proposed next asset implementation contract address.
402     address pendingVersion;
403 
404     // Upgrade freeze-time start.
405     uint pendingVersionTimestamp;
406 
407     // Timespan for users to review the new implementation and make decision.
408     uint constant UPGRADE_FREEZE_TIME = 3 days;
409 
410     // Asset implementation contract address that user decided to stick with.
411     // 0x0 means that user uses latest version.
412     mapping(address => address) userOptOutVersion;
413 
414     /**
415      * Only asset implementation contract assigned to sender is allowed to call.
416      */
417     modifier onlyImplementationFor(address _sender) {
418         if (getVersionFor(_sender) == msg.sender) {
419             _;
420         }
421     }
422 
423     /**
424      * Returns asset implementation contract address assigned to sender.
425      *
426      * @param _sender sender address.
427      *
428      * @return asset implementation contract address.
429      */
430     function getVersionFor(address _sender) constant returns(address) {
431         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
432     }
433 
434     /**
435      * Returns current asset implementation contract address.
436      *
437      * @return asset implementation contract address.
438      */
439     function getLatestVersion() constant returns(address) {
440         return latestVersion;
441     }
442 
443     /**
444      * Returns proposed next asset implementation contract address.
445      *
446      * @return asset implementation contract address.
447      */
448     function getPendingVersion() constant returns(address) {
449         return pendingVersion;
450     }
451 
452     /**
453      * Returns upgrade freeze-time start.
454      *
455      * @return freeze-time start.
456      */
457     function getPendingVersionTimestamp() constant returns(uint) {
458         return pendingVersionTimestamp;
459     }
460 
461     /**
462      * Propose next asset implementation contract address.
463      *
464      * Can only be called by current asset owner.
465      *
466      * Note: freeze-time should not be applied for the initial setup.
467      *
468      * @param _newVersion asset implementation contract address.
469      *
470      * @return success.
471      */
472     function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {
473         // Should not already be in the upgrading process.
474         if (pendingVersion != 0x0) {
475             return false;
476         }
477         // New version address should be other than 0x0.
478         if (_newVersion == 0x0) {
479             return false;
480         }
481         // Don't apply freeze-time for the initial setup.
482         if (latestVersion == 0x0) {
483             latestVersion = _newVersion;
484             return true;
485         }
486         pendingVersion = _newVersion;
487         pendingVersionTimestamp = now;
488         UpgradeProposal(_newVersion);
489         return true;
490     }
491 
492     /**
493      * Cancel the pending upgrade process.
494      *
495      * Can only be called by current asset owner.
496      *
497      * @return success.
498      */
499     function purgeUpgrade() onlyAssetOwner() returns(bool) {
500         if (pendingVersion == 0x0) {
501             return false;
502         }
503         delete pendingVersion;
504         delete pendingVersionTimestamp;
505         return true;
506     }
507 
508     /**
509      * Finalize an upgrade process setting new asset implementation contract address.
510      *
511      * Can only be called after an upgrade freeze-time.
512      *
513      * @return success.
514      */
515     function commitUpgrade() returns(bool) {
516         if (pendingVersion == 0x0) {
517             return false;
518         }
519         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
520             return false;
521         }
522         latestVersion = pendingVersion;
523         delete pendingVersion;
524         delete pendingVersionTimestamp;
525         return true;
526     }
527 
528     /**
529      * Disagree with proposed upgrade, and stick with current asset implementation
530      * until further explicit agreement to upgrade.
531      *
532      * @return success.
533      */
534     function optOut() returns(bool) {
535         if (userOptOutVersion[msg.sender] != 0x0) {
536             return false;
537         }
538         userOptOutVersion[msg.sender] = latestVersion;
539         return true;
540     }
541 
542     /**
543      * Implicitly agree to upgrade to current and future asset implementation upgrades,
544      * until further explicit disagreement.
545      *
546      * @return success.
547      */
548     function optIn() returns(bool) {
549         delete userOptOutVersion[msg.sender];
550         return true;
551     }
552 
553     // Backwards compatibility.
554     function multiAsset() constant returns(EToken2) {
555         return etoken2;
556     }
557 }