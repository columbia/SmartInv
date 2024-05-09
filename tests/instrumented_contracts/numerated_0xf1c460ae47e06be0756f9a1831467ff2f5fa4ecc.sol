1 pragma solidity 0.4.23;
2 
3 contract EToken2Interface {
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
17 contract AssetInterface {
18     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) public returns(bool);
19     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) public returns(bool);
20     function _performApprove(address _spender, uint _value, address _sender) public returns(bool);
21     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns(bool);
22     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public returns(bool);
23     function _performGeneric(bytes, address) public payable {
24         revert();
25     }
26 }
27 
28 contract ERC20Interface {
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed from, address indexed spender, uint256 value);
31 
32     function totalSupply() public view returns(uint256 supply);
33     function balanceOf(address _owner) public view returns(uint256 balance);
34     function transfer(address _to, uint256 _value) public returns(bool success);
35     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
36     function approve(address _spender, uint256 _value) public returns(bool success);
37     function allowance(address _owner, address _spender) public view returns(uint256 remaining);
38 
39     // function symbol() constant returns(string);
40     function decimals() public view returns(uint8);
41     // function name() constant returns(string);
42 }
43 
44 contract AssetProxyInterface is ERC20Interface {
45     function _forwardApprove(address _spender, uint _value, address _sender) public returns(bool);
46     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns(bool);
47     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public returns(bool);
48     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value) public returns(bool);
49     function etoken2() public pure returns(address) {} // To be replaced by the implicit getter;
50     function etoken2Symbol() public pure returns(bytes32) {} // To be replaced by the implicit getter;
51 }
52 
53 contract Bytes32 {
54     function _bytes32(string _input) internal pure returns(bytes32 result) {
55         assembly {
56             result := mload(add(_input, 32))
57         }
58     }
59 }
60 
61 contract ReturnData {
62     function _returnReturnData(bool _success) internal pure {
63         assembly {
64             let returndatastart := 0
65             returndatacopy(returndatastart, 0, returndatasize)
66             switch _success case 0 { revert(returndatastart, returndatasize) } default { return(returndatastart, returndatasize) }
67         }
68     }
69 
70     function _assemblyCall(address _destination, uint _value, bytes _data) internal returns(bool success) {
71         assembly {
72             success := call(gas, _destination, _value, add(_data, 32), mload(_data), 0, 0)
73         }
74     }
75 }
76 
77 /**
78  * @title EToken2 Asset Proxy.
79  *
80  * Proxy implements ERC20 interface and acts as a gateway to a single EToken2 asset.
81  * Proxy adds etoken2Symbol and caller(sender) when forwarding requests to EToken2.
82  * Every request that is made by caller first sent to the specific asset implementation
83  * contract, which then calls back to be forwarded onto EToken2.
84  *
85  * Calls flow: Caller ->
86  *             Proxy.func(...) ->
87  *             Asset._performFunc(..., Caller.address) ->
88  *             Proxy._forwardFunc(..., Caller.address) ->
89  *             Platform.proxyFunc(..., symbol, Caller.address)
90  *
91  * Generic call flow: Caller ->
92  *             Proxy.unknownFunc(...) ->
93  *             Asset._performGeneric(..., Caller.address) ->
94  *             Asset.unknownFunc(...)
95  *
96  * Asset implementation contract is mutable, but each user have an option to stick with
97  * old implementation, through explicit decision made in timely manner, if he doesn't agree
98  * with new rules.
99  * Each user have a possibility to upgrade to latest asset contract implementation, without the
100  * possibility to rollback.
101  *
102  * Note: all the non constant functions return false instead of throwing in case if state change
103  * didn't happen yet.
104  */
105 contract VOLUM is ERC20Interface, AssetProxyInterface, Bytes32, ReturnData {
106     // Assigned EToken2, immutable.
107     EToken2Interface public etoken2;
108 
109     // Assigned symbol, immutable.
110     bytes32 public etoken2Symbol;
111 
112     // Assigned name, immutable. For UI.
113     string public name;
114     string public symbol;
115 
116     /**
117      * Sets EToken2 address, assigns symbol and name.
118      *
119      * Can be set only once.
120      *
121      * @param _etoken2 EToken2 contract address.
122      * @param _symbol assigned symbol.
123      * @param _name assigned name.
124      *
125      * @return success.
126      */
127     function init(EToken2Interface _etoken2, string _symbol, string _name) public returns(bool) {
128         if (address(etoken2) != 0x0) {
129             return false;
130         }
131         etoken2 = _etoken2;
132         etoken2Symbol = _bytes32(_symbol);
133         name = _name;
134         symbol = _symbol;
135         return true;
136     }
137 
138     /**
139      * Only EToken2 is allowed to call.
140      */
141     modifier onlyEToken2() {
142         if (msg.sender == address(etoken2)) {
143             _;
144         }
145     }
146 
147     /**
148      * Only current asset owner is allowed to call.
149      */
150     modifier onlyAssetOwner() {
151         if (etoken2.isOwner(msg.sender, etoken2Symbol)) {
152             _;
153         }
154     }
155 
156     /**
157      * Returns asset implementation contract for current caller.
158      *
159      * @return asset implementation contract.
160      */
161     function _getAsset() internal view returns(AssetInterface) {
162         return AssetInterface(getVersionFor(msg.sender));
163     }
164 
165     /**
166      * Recovers tokens on proxy contract
167      *
168      * @param _asset type of tokens to recover.
169      * @param _value tokens that will be recovered.
170      * @param _receiver address where to send recovered tokens.
171      *
172      * @return success.
173      */
174     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value) public onlyAssetOwner() returns(bool) {
175         return _asset.transfer(_receiver, _value);
176     }
177 
178     /**
179      * Returns asset total supply.
180      *
181      * @return asset total supply.
182      */
183     function totalSupply() public view returns(uint) {
184         return etoken2.totalSupply(etoken2Symbol);
185     }
186 
187     /**
188      * Returns asset balance for a particular holder.
189      *
190      * @param _owner holder address.
191      *
192      * @return holder balance.
193      */
194     function balanceOf(address _owner) public view returns(uint) {
195         return etoken2.balanceOf(_owner, etoken2Symbol);
196     }
197 
198     /**
199      * Returns asset allowance from one holder to another.
200      *
201      * @param _from holder that allowed spending.
202      * @param _spender holder that is allowed to spend.
203      *
204      * @return holder to spender allowance.
205      */
206     function allowance(address _from, address _spender) public view returns(uint) {
207         return etoken2.allowance(_from, _spender, etoken2Symbol);
208     }
209 
210     /**
211      * Returns asset decimals.
212      *
213      * @return asset decimals.
214      */
215     function decimals() public view returns(uint8) {
216         return etoken2.baseUnit(etoken2Symbol);
217     }
218 
219     /**
220      * Transfers asset balance from the caller to specified receiver.
221      *
222      * @param _to holder address to give to.
223      * @param _value amount to transfer.
224      *
225      * @return success.
226      */
227     function transfer(address _to, uint _value) public returns(bool) {
228         return transferWithReference(_to, _value, '');
229     }
230 
231     /**
232      * Transfers asset balance from the caller to specified receiver adding specified comment.
233      * Resolves asset implementation contract for the caller and forwards there arguments along with
234      * the caller address.
235      *
236      * @param _to holder address to give to.
237      * @param _value amount to transfer.
238      * @param _reference transfer comment to be included in a EToken2's Transfer event.
239      *
240      * @return success.
241      */
242     function transferWithReference(address _to, uint _value, string _reference) public returns(bool) {
243         return _getAsset()._performTransferWithReference(_to, _value, _reference, msg.sender);
244     }
245 
246     /**
247      * Transfers asset balance from the caller to specified ICAP.
248      *
249      * @param _icap recipient ICAP to give to.
250      * @param _value amount to transfer.
251      *
252      * @return success.
253      */
254     function transferToICAP(bytes32 _icap, uint _value) public returns(bool) {
255         return transferToICAPWithReference(_icap, _value, '');
256     }
257 
258     /**
259      * Transfers asset balance from the caller to specified ICAP adding specified comment.
260      * Resolves asset implementation contract for the caller and forwards there arguments along with
261      * the caller address.
262      *
263      * @param _icap recipient ICAP to give to.
264      * @param _value amount to transfer.
265      * @param _reference transfer comment to be included in a EToken2's Transfer event.
266      *
267      * @return success.
268      */
269     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) public returns(bool) {
270         return _getAsset()._performTransferToICAPWithReference(_icap, _value, _reference, msg.sender);
271     }
272 
273     /**
274      * Prforms allowance transfer of asset balance between holders.
275      *
276      * @param _from holder address to take from.
277      * @param _to holder address to give to.
278      * @param _value amount to transfer.
279      *
280      * @return success.
281      */
282     function transferFrom(address _from, address _to, uint _value) public returns(bool) {
283         return transferFromWithReference(_from, _to, _value, '');
284     }
285 
286     /**
287      * Prforms allowance transfer of asset balance between holders adding specified comment.
288      * Resolves asset implementation contract for the caller and forwards there arguments along with
289      * the caller address.
290      *
291      * @param _from holder address to take from.
292      * @param _to holder address to give to.
293      * @param _value amount to transfer.
294      * @param _reference transfer comment to be included in a EToken2's Transfer event.
295      *
296      * @return success.
297      */
298     function transferFromWithReference(address _from, address _to, uint _value, string _reference) public returns(bool) {
299         return _getAsset()._performTransferFromWithReference(_from, _to, _value, _reference, msg.sender);
300     }
301 
302     /**
303      * Performs transfer call on the EToken2 by the name of specified sender.
304      *
305      * Can only be called by asset implementation contract assigned to sender.
306      *
307      * @param _from holder address to take from.
308      * @param _to holder address to give to.
309      * @param _value amount to transfer.
310      * @param _reference transfer comment to be included in a EToken2's Transfer event.
311      * @param _sender initial caller.
312      *
313      * @return success.
314      */
315     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyImplementationFor(_sender) returns(bool) {
316         return etoken2.proxyTransferFromWithReference(_from, _to, _value, etoken2Symbol, _reference, _sender);
317     }
318 
319     /**
320      * Prforms allowance transfer of asset balance between holders.
321      *
322      * @param _from holder address to take from.
323      * @param _icap recipient ICAP address to give to.
324      * @param _value amount to transfer.
325      *
326      * @return success.
327      */
328     function transferFromToICAP(address _from, bytes32 _icap, uint _value) public returns(bool) {
329         return transferFromToICAPWithReference(_from, _icap, _value, '');
330     }
331 
332     /**
333      * Prforms allowance transfer of asset balance between holders adding specified comment.
334      * Resolves asset implementation contract for the caller and forwards there arguments along with
335      * the caller address.
336      *
337      * @param _from holder address to take from.
338      * @param _icap recipient ICAP address to give to.
339      * @param _value amount to transfer.
340      * @param _reference transfer comment to be included in a EToken2's Transfer event.
341      *
342      * @return success.
343      */
344     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) public returns(bool) {
345         return _getAsset()._performTransferFromToICAPWithReference(_from, _icap, _value, _reference, msg.sender);
346     }
347 
348     /**
349      * Performs allowance transfer to ICAP call on the EToken2 by the name of specified sender.
350      *
351      * Can only be called by asset implementation contract assigned to sender.
352      *
353      * @param _from holder address to take from.
354      * @param _icap recipient ICAP address to give to.
355      * @param _value amount to transfer.
356      * @param _reference transfer comment to be included in a EToken2's Transfer event.
357      * @param _sender initial caller.
358      *
359      * @return success.
360      */
361     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public onlyImplementationFor(_sender) returns(bool) {
362         return etoken2.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
363     }
364 
365     /**
366      * Sets asset spending allowance for a specified spender.
367      * Resolves asset implementation contract for the caller and forwards there arguments along with
368      * the caller address.
369      *
370      * @param _spender holder address to set allowance to.
371      * @param _value amount to allow.
372      *
373      * @return success.
374      */
375     function approve(address _spender, uint _value) public returns(bool) {
376         return _getAsset()._performApprove(_spender, _value, msg.sender);
377     }
378 
379     /**
380      * Performs allowance setting call on the EToken2 by the name of specified sender.
381      *
382      * Can only be called by asset implementation contract assigned to sender.
383      *
384      * @param _spender holder address to set allowance to.
385      * @param _value amount to allow.
386      * @param _sender initial caller.
387      *
388      * @return success.
389      */
390     function _forwardApprove(address _spender, uint _value, address _sender) public onlyImplementationFor(_sender) returns(bool) {
391         return etoken2.proxyApprove(_spender, _value, etoken2Symbol, _sender);
392     }
393 
394     /**
395      * Emits ERC20 Transfer event on this contract.
396      *
397      * Can only be, and, called by assigned EToken2 when asset transfer happens.
398      */
399     function emitTransfer(address _from, address _to, uint _value) public onlyEToken2() {
400         emit Transfer(_from, _to, _value);
401     }
402 
403     /**
404      * Emits ERC20 Approval event on this contract.
405      *
406      * Can only be, and, called by assigned EToken2 when asset allowance set happens.
407      */
408     function emitApprove(address _from, address _spender, uint _value) public onlyEToken2() {
409         emit Approval(_from, _spender, _value);
410     }
411 
412     /**
413      * Resolves asset implementation contract for the caller and forwards there transaction data,
414      * along with the value. This allows for proxy interface growth.
415      */
416     function () public payable {
417         _getAsset()._performGeneric.value(msg.value)(msg.data, msg.sender);
418         _returnReturnData(true);
419     }
420 
421     // Interface functions to allow specifying ICAP addresses as strings.
422     function transferToICAP(string _icap, uint _value) public returns(bool) {
423         return transferToICAPWithReference(_icap, _value, '');
424     }
425 
426     function transferToICAPWithReference(string _icap, uint _value, string _reference) public returns(bool) {
427         return transferToICAPWithReference(_bytes32(_icap), _value, _reference);
428     }
429 
430     function transferFromToICAP(address _from, string _icap, uint _value) public returns(bool) {
431         return transferFromToICAPWithReference(_from, _icap, _value, '');
432     }
433 
434     function transferFromToICAPWithReference(address _from, string _icap, uint _value, string _reference) public returns(bool) {
435         return transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference);
436     }
437 
438     /**
439      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
440      */
441     event UpgradeProposed(address newVersion);
442     event UpgradePurged(address newVersion);
443     event UpgradeCommited(address newVersion);
444     event OptedOut(address sender, address version);
445     event OptedIn(address sender, address version);
446 
447     // Current asset implementation contract address.
448     address internal latestVersion;
449 
450     // Proposed next asset implementation contract address.
451     address internal pendingVersion;
452 
453     // Upgrade freeze-time start.
454     uint internal pendingVersionTimestamp;
455 
456     // Timespan for users to review the new implementation and make decision.
457     uint constant UPGRADE_FREEZE_TIME = 3 days;
458 
459     // Asset implementation contract address that user decided to stick with.
460     // 0x0 means that user uses latest version.
461     mapping(address => address) internal userOptOutVersion;
462 
463     /**
464      * Only asset implementation contract assigned to sender is allowed to call.
465      */
466     modifier onlyImplementationFor(address _sender) {
467         if (getVersionFor(_sender) == msg.sender) {
468             _;
469         }
470     }
471 
472     /**
473      * Returns asset implementation contract address assigned to sender.
474      *
475      * @param _sender sender address.
476      *
477      * @return asset implementation contract address.
478      */
479     function getVersionFor(address _sender) public view returns(address) {
480         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
481     }
482 
483     /**
484      * Returns current asset implementation contract address.
485      *
486      * @return asset implementation contract address.
487      */
488     function getLatestVersion() public view returns(address) {
489         return latestVersion;
490     }
491 
492     /**
493      * Returns proposed next asset implementation contract address.
494      *
495      * @return asset implementation contract address.
496      */
497     function getPendingVersion() public view returns(address) {
498         return pendingVersion;
499     }
500 
501     /**
502      * Returns upgrade freeze-time start.
503      *
504      * @return freeze-time start.
505      */
506     function getPendingVersionTimestamp() public view returns(uint) {
507         return pendingVersionTimestamp;
508     }
509 
510     /**
511      * Propose next asset implementation contract address.
512      *
513      * Can only be called by current asset owner.
514      *
515      * Note: freeze-time should not be applied for the initial setup.
516      *
517      * @param _newVersion asset implementation contract address.
518      *
519      * @return success.
520      */
521     function proposeUpgrade(address _newVersion) public onlyAssetOwner() returns(bool) {
522         // Should not already be in the upgrading process.
523         if (pendingVersion != 0x0) {
524             return false;
525         }
526         // New version address should be other than 0x0.
527         if (_newVersion == 0x0) {
528             return false;
529         }
530         // Don't apply freeze-time for the initial setup.
531         if (latestVersion == 0x0) {
532             latestVersion = _newVersion;
533             return true;
534         }
535         pendingVersion = _newVersion;
536         pendingVersionTimestamp = now;
537         emit UpgradeProposed(_newVersion);
538         return true;
539     }
540 
541     /**
542      * Cancel the pending upgrade process.
543      *
544      * Can only be called by current asset owner.
545      *
546      * @return success.
547      */
548     function purgeUpgrade() public onlyAssetOwner() returns(bool) {
549         if (pendingVersion == 0x0) {
550             return false;
551         }
552         emit UpgradePurged(pendingVersion);
553         delete pendingVersion;
554         delete pendingVersionTimestamp;
555         return true;
556     }
557 
558     /**
559      * Finalize an upgrade process setting new asset implementation contract address.
560      *
561      * Can only be called after an upgrade freeze-time.
562      *
563      * @return success.
564      */
565     function commitUpgrade() public returns(bool) {
566         if (pendingVersion == 0x0) {
567             return false;
568         }
569         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
570             return false;
571         }
572         latestVersion = pendingVersion;
573         delete pendingVersion;
574         delete pendingVersionTimestamp;
575         emit UpgradeCommited(latestVersion);
576         return true;
577     }
578 
579     /**
580      * Disagree with proposed upgrade, and stick with current asset implementation
581      * until further explicit agreement to upgrade.
582      *
583      * @return success.
584      */
585     function optOut() public returns(bool) {
586         if (userOptOutVersion[msg.sender] != 0x0) {
587             return false;
588         }
589         userOptOutVersion[msg.sender] = latestVersion;
590         emit OptedOut(msg.sender, latestVersion);
591         return true;
592     }
593 
594     /**
595      * Implicitly agree to upgrade to current and future asset implementation upgrades,
596      * until further explicit disagreement.
597      *
598      * @return success.
599      */
600     function optIn() public returns(bool) {
601         delete userOptOutVersion[msg.sender];
602         emit OptedIn(msg.sender, latestVersion);
603         return true;
604     }
605 
606     // Backwards compatibility.
607     function multiAsset() public view returns(EToken2Interface) {
608         return etoken2;
609     }
610 }