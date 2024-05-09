1 pragma solidity 0.4.15;
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
34     function _performGeneric(bytes, address) payable {
35         revert();
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
70 contract ReturnData {
71     function _returnReturnData(bool _success) internal {
72         assembly {
73             let returndatastart := msize()
74             mstore(0x40, add(returndatastart, returndatasize))
75             returndatacopy(returndatastart, 0, returndatasize)
76             switch _success case 0 { revert(returndatastart, returndatasize) } default { return(returndatastart, returndatasize) }
77         }
78     }
79 
80     function _assemblyCall(address _destination, uint _value, bytes _data) internal returns(bool success) {
81         assembly {
82             success := call(div(mul(gas, 63), 64), _destination, _value, add(_data, 32), mload(_data), 0, 0)
83         }
84     }
85 }
86 
87 /**
88  * @title EToken2 Asset Proxy.
89  *
90  * Proxy implements ERC20 interface and acts as a gateway to a single EToken2 asset.
91  * Proxy adds etoken2Symbol and caller(sender) when forwarding requests to EToken2.
92  * Every request that is made by caller first sent to the specific asset implementation
93  * contract, which then calls back to be forwarded onto EToken2.
94  *
95  * Calls flow: Caller ->
96  *             Proxy.func(...) ->
97  *             Asset._performFunc(..., Caller.address) ->
98  *             Proxy._forwardFunc(..., Caller.address) ->
99  *             Platform.proxyFunc(..., symbol, Caller.address)
100  *
101  * Generic call flow: Caller ->
102  *             Proxy.unknownFunc(...) ->
103  *             Asset._performGeneric(..., Caller.address) ->
104  *             Asset.unknownFunc(...)
105  *
106  * Asset implementation contract is mutable, but each user have an option to stick with
107  * old implementation, through explicit decision made in timely manner, if he doesn't agree
108  * with new rules.
109  * Each user have a possibility to upgrade to latest asset contract implementation, without the
110  * possibility to rollback.
111  *
112  * Note: all the non constant functions return false instead of throwing in case if state change
113  * didn't happen yet.
114  */
115 contract REMME is ERC20Interface, AssetProxyInterface, Bytes32, ReturnData {
116     // Assigned EToken2, immutable.
117     EToken2Interface public etoken2;
118 
119     // Assigned symbol, immutable.
120     bytes32 public etoken2Symbol;
121 
122     // Assigned name, immutable. For UI.
123     string public name;
124     string public symbol;
125 
126     /**
127      * Sets EToken2 address, assigns symbol and name.
128      *
129      * Can be set only once.
130      *
131      * @param _etoken2 EToken2 contract address.
132      * @param _symbol assigned symbol.
133      * @param _name assigned name.
134      *
135      * @return success.
136      */
137     function init(EToken2Interface _etoken2, string _symbol, string _name) returns(bool) {
138         if (address(etoken2) != 0x0) {
139             return false;
140         }
141         etoken2 = _etoken2;
142         etoken2Symbol = _bytes32(_symbol);
143         name = _name;
144         symbol = _symbol;
145         return true;
146     }
147 
148     /**
149      * Only EToken2 is allowed to call.
150      */
151     modifier onlyEToken2() {
152         if (msg.sender == address(etoken2)) {
153             _;
154         }
155     }
156 
157     /**
158      * Only current asset owner is allowed to call.
159      */
160     modifier onlyAssetOwner() {
161         if (etoken2.isOwner(msg.sender, etoken2Symbol)) {
162             _;
163         }
164     }
165 
166     /**
167      * Returns asset implementation contract for current caller.
168      *
169      * @return asset implementation contract.
170      */
171     function _getAsset() internal returns(AssetInterface) {
172         return AssetInterface(getVersionFor(msg.sender));
173     }
174 
175     function recoverTokens(uint _value) onlyAssetOwner() returns(bool) {
176         return this.transferWithReference(msg.sender, _value, 'Tokens recovery');
177     }
178 
179     /**
180      * Returns asset total supply.
181      *
182      * @return asset total supply.
183      */
184     function totalSupply() constant returns(uint) {
185         return etoken2.totalSupply(etoken2Symbol);
186     }
187 
188     /**
189      * Returns asset balance for a particular holder.
190      *
191      * @param _owner holder address.
192      *
193      * @return holder balance.
194      */
195     function balanceOf(address _owner) constant returns(uint) {
196         return etoken2.balanceOf(_owner, etoken2Symbol);
197     }
198 
199     /**
200      * Returns asset allowance from one holder to another.
201      *
202      * @param _from holder that allowed spending.
203      * @param _spender holder that is allowed to spend.
204      *
205      * @return holder to spender allowance.
206      */
207     function allowance(address _from, address _spender) constant returns(uint) {
208         return etoken2.allowance(_from, _spender, etoken2Symbol);
209     }
210 
211     /**
212      * Returns asset decimals.
213      *
214      * @return asset decimals.
215      */
216     function decimals() constant returns(uint8) {
217         return etoken2.baseUnit(etoken2Symbol);
218     }
219 
220     /**
221      * Transfers asset balance from the caller to specified receiver.
222      *
223      * @param _to holder address to give to.
224      * @param _value amount to transfer.
225      *
226      * @return success.
227      */
228     function transfer(address _to, uint _value) returns(bool) {
229         return transferWithReference(_to, _value, '');
230     }
231 
232     /**
233      * Transfers asset balance from the caller to specified receiver adding specified comment.
234      * Resolves asset implementation contract for the caller and forwards there arguments along with
235      * the caller address.
236      *
237      * @param _to holder address to give to.
238      * @param _value amount to transfer.
239      * @param _reference transfer comment to be included in a EToken2's Transfer event.
240      *
241      * @return success.
242      */
243     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
244         return _getAsset()._performTransferWithReference(_to, _value, _reference, msg.sender);
245     }
246 
247     /**
248      * Transfers asset balance from the caller to specified ICAP.
249      *
250      * @param _icap recipient ICAP to give to.
251      * @param _value amount to transfer.
252      *
253      * @return success.
254      */
255     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
256         return transferToICAPWithReference(_icap, _value, '');
257     }
258 
259     /**
260      * Transfers asset balance from the caller to specified ICAP adding specified comment.
261      * Resolves asset implementation contract for the caller and forwards there arguments along with
262      * the caller address.
263      *
264      * @param _icap recipient ICAP to give to.
265      * @param _value amount to transfer.
266      * @param _reference transfer comment to be included in a EToken2's Transfer event.
267      *
268      * @return success.
269      */
270     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
271         return _getAsset()._performTransferToICAPWithReference(_icap, _value, _reference, msg.sender);
272     }
273 
274     /**
275      * Prforms allowance transfer of asset balance between holders.
276      *
277      * @param _from holder address to take from.
278      * @param _to holder address to give to.
279      * @param _value amount to transfer.
280      *
281      * @return success.
282      */
283     function transferFrom(address _from, address _to, uint _value) returns(bool) {
284         return transferFromWithReference(_from, _to, _value, '');
285     }
286 
287     /**
288      * Prforms allowance transfer of asset balance between holders adding specified comment.
289      * Resolves asset implementation contract for the caller and forwards there arguments along with
290      * the caller address.
291      *
292      * @param _from holder address to take from.
293      * @param _to holder address to give to.
294      * @param _value amount to transfer.
295      * @param _reference transfer comment to be included in a EToken2's Transfer event.
296      *
297      * @return success.
298      */
299     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
300         return _getAsset()._performTransferFromWithReference(_from, _to, _value, _reference, msg.sender);
301     }
302 
303     /**
304      * Performs transfer call on the EToken2 by the name of specified sender.
305      *
306      * Can only be called by asset implementation contract assigned to sender.
307      *
308      * @param _from holder address to take from.
309      * @param _to holder address to give to.
310      * @param _value amount to transfer.
311      * @param _reference transfer comment to be included in a EToken2's Transfer event.
312      * @param _sender initial caller.
313      *
314      * @return success.
315      */
316     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyImplementationFor(_sender) returns(bool) {
317         return etoken2.proxyTransferFromWithReference(_from, _to, _value, etoken2Symbol, _reference, _sender);
318     }
319 
320     /**
321      * Prforms allowance transfer of asset balance between holders.
322      *
323      * @param _from holder address to take from.
324      * @param _icap recipient ICAP address to give to.
325      * @param _value amount to transfer.
326      *
327      * @return success.
328      */
329     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
330         return transferFromToICAPWithReference(_from, _icap, _value, '');
331     }
332 
333     /**
334      * Prforms allowance transfer of asset balance between holders adding specified comment.
335      * Resolves asset implementation contract for the caller and forwards there arguments along with
336      * the caller address.
337      *
338      * @param _from holder address to take from.
339      * @param _icap recipient ICAP address to give to.
340      * @param _value amount to transfer.
341      * @param _reference transfer comment to be included in a EToken2's Transfer event.
342      *
343      * @return success.
344      */
345     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
346         return _getAsset()._performTransferFromToICAPWithReference(_from, _icap, _value, _reference, msg.sender);
347     }
348 
349     /**
350      * Performs allowance transfer to ICAP call on the EToken2 by the name of specified sender.
351      *
352      * Can only be called by asset implementation contract assigned to sender.
353      *
354      * @param _from holder address to take from.
355      * @param _icap recipient ICAP address to give to.
356      * @param _value amount to transfer.
357      * @param _reference transfer comment to be included in a EToken2's Transfer event.
358      * @param _sender initial caller.
359      *
360      * @return success.
361      */
362     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyImplementationFor(_sender) returns(bool) {
363         return etoken2.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
364     }
365 
366     /**
367      * Sets asset spending allowance for a specified spender.
368      * Resolves asset implementation contract for the caller and forwards there arguments along with
369      * the caller address.
370      *
371      * @param _spender holder address to set allowance to.
372      * @param _value amount to allow.
373      *
374      * @return success.
375      */
376     function approve(address _spender, uint _value) returns(bool) {
377         return _getAsset()._performApprove(_spender, _value, msg.sender);
378     }
379 
380     /**
381      * Performs allowance setting call on the EToken2 by the name of specified sender.
382      *
383      * Can only be called by asset implementation contract assigned to sender.
384      *
385      * @param _spender holder address to set allowance to.
386      * @param _value amount to allow.
387      * @param _sender initial caller.
388      *
389      * @return success.
390      */
391     function _forwardApprove(address _spender, uint _value, address _sender) onlyImplementationFor(_sender) returns(bool) {
392         return etoken2.proxyApprove(_spender, _value, etoken2Symbol, _sender);
393     }
394 
395     /**
396      * Emits ERC20 Transfer event on this contract.
397      *
398      * Can only be, and, called by assigned EToken2 when asset transfer happens.
399      */
400     function emitTransfer(address _from, address _to, uint _value) onlyEToken2() {
401         Transfer(_from, _to, _value);
402     }
403 
404     /**
405      * Emits ERC20 Approval event on this contract.
406      *
407      * Can only be, and, called by assigned EToken2 when asset allowance set happens.
408      */
409     function emitApprove(address _from, address _spender, uint _value) onlyEToken2() {
410         Approval(_from, _spender, _value);
411     }
412 
413     /**
414      * Resolves asset implementation contract for the caller and forwards there transaction data,
415      * along with the value. This allows for proxy interface growth.
416      */
417     function () payable {
418         _getAsset()._performGeneric.value(msg.value)(msg.data, msg.sender);
419         _returnReturnData(true);
420     }
421 
422     // Interface functions to allow specifying ICAP addresses as strings.
423     function transferToICAP(string _icap, uint _value) returns(bool) {
424         return transferToICAPWithReference(_icap, _value, '');
425     }
426 
427     function transferToICAPWithReference(string _icap, uint _value, string _reference) returns(bool) {
428         return transferToICAPWithReference(_bytes32(_icap), _value, _reference);
429     }
430 
431     function transferFromToICAP(address _from, string _icap, uint _value) returns(bool) {
432         return transferFromToICAPWithReference(_from, _icap, _value, '');
433     }
434 
435     function transferFromToICAPWithReference(address _from, string _icap, uint _value, string _reference) returns(bool) {
436         return transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference);
437     }
438 
439     /**
440      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
441      */
442     event UpgradeProposal(address newVersion);
443 
444     // Current asset implementation contract address.
445     address latestVersion;
446 
447     // Proposed next asset implementation contract address.
448     address pendingVersion;
449 
450     // Upgrade freeze-time start.
451     uint pendingVersionTimestamp;
452 
453     // Timespan for users to review the new implementation and make decision.
454     uint constant UPGRADE_FREEZE_TIME = 3 days;
455 
456     // Asset implementation contract address that user decided to stick with.
457     // 0x0 means that user uses latest version.
458     mapping(address => address) userOptOutVersion;
459 
460     /**
461      * Only asset implementation contract assigned to sender is allowed to call.
462      */
463     modifier onlyImplementationFor(address _sender) {
464         if (getVersionFor(_sender) == msg.sender) {
465             _;
466         }
467     }
468 
469     /**
470      * Returns asset implementation contract address assigned to sender.
471      *
472      * @param _sender sender address.
473      *
474      * @return asset implementation contract address.
475      */
476     function getVersionFor(address _sender) constant returns(address) {
477         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
478     }
479 
480     /**
481      * Returns current asset implementation contract address.
482      *
483      * @return asset implementation contract address.
484      */
485     function getLatestVersion() constant returns(address) {
486         return latestVersion;
487     }
488 
489     /**
490      * Returns proposed next asset implementation contract address.
491      *
492      * @return asset implementation contract address.
493      */
494     function getPendingVersion() constant returns(address) {
495         return pendingVersion;
496     }
497 
498     /**
499      * Returns upgrade freeze-time start.
500      *
501      * @return freeze-time start.
502      */
503     function getPendingVersionTimestamp() constant returns(uint) {
504         return pendingVersionTimestamp;
505     }
506 
507     /**
508      * Propose next asset implementation contract address.
509      *
510      * Can only be called by current asset owner.
511      *
512      * Note: freeze-time should not be applied for the initial setup.
513      *
514      * @param _newVersion asset implementation contract address.
515      *
516      * @return success.
517      */
518     function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {
519         // Should not already be in the upgrading process.
520         if (pendingVersion != 0x0) {
521             return false;
522         }
523         // New version address should be other than 0x0.
524         if (_newVersion == 0x0) {
525             return false;
526         }
527         // Don't apply freeze-time for the initial setup.
528         if (latestVersion == 0x0) {
529             latestVersion = _newVersion;
530             return true;
531         }
532         pendingVersion = _newVersion;
533         pendingVersionTimestamp = now;
534         UpgradeProposal(_newVersion);
535         return true;
536     }
537 
538     /**
539      * Cancel the pending upgrade process.
540      *
541      * Can only be called by current asset owner.
542      *
543      * @return success.
544      */
545     function purgeUpgrade() onlyAssetOwner() returns(bool) {
546         if (pendingVersion == 0x0) {
547             return false;
548         }
549         delete pendingVersion;
550         delete pendingVersionTimestamp;
551         return true;
552     }
553 
554     /**
555      * Finalize an upgrade process setting new asset implementation contract address.
556      *
557      * Can only be called after an upgrade freeze-time.
558      *
559      * @return success.
560      */
561     function commitUpgrade() returns(bool) {
562         if (pendingVersion == 0x0) {
563             return false;
564         }
565         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
566             return false;
567         }
568         latestVersion = pendingVersion;
569         delete pendingVersion;
570         delete pendingVersionTimestamp;
571         return true;
572     }
573 
574     /**
575      * Disagree with proposed upgrade, and stick with current asset implementation
576      * until further explicit agreement to upgrade.
577      *
578      * @return success.
579      */
580     function optOut() returns(bool) {
581         if (userOptOutVersion[msg.sender] != 0x0) {
582             return false;
583         }
584         userOptOutVersion[msg.sender] = latestVersion;
585         return true;
586     }
587 
588     /**
589      * Implicitly agree to upgrade to current and future asset implementation upgrades,
590      * until further explicit disagreement.
591      *
592      * @return success.
593      */
594     function optIn() returns(bool) {
595         delete userOptOutVersion[msg.sender];
596         return true;
597     }
598 
599     // Backwards compatibility.
600     function multiAsset() constant returns(EToken2Interface) {
601         return etoken2;
602     }
603 }