1 pragma solidity ^0.4.11;
2 
3 // File: contracts/CAVAssetInterface.sol
4 
5 contract CAVAsset {
6     function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
7     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
8     function __approve(address _spender, uint _value, address _sender) returns(bool);
9     function __process(bytes _data, address _sender) payable {
10         revert();
11     }
12 }
13 
14 // File: contracts/CAVPlatformInterface.sol
15 
16 contract CAVPlatform {
17     mapping(bytes32 => address) public proxies;
18     function symbols(uint _idx) public constant returns (bytes32);
19     function symbolsCount() public constant returns (uint);
20 
21     function name(bytes32 _symbol) returns(string);
22     function setProxy(address _address, bytes32 _symbol) returns(uint errorCode);
23     function isCreated(bytes32 _symbol) constant returns(bool);
24     function isOwner(address _owner, bytes32 _symbol) returns(bool);
25     function owner(bytes32 _symbol) constant returns(address);
26     function totalSupply(bytes32 _symbol) returns(uint);
27     function balanceOf(address _holder, bytes32 _symbol) returns(uint);
28     function allowance(address _from, address _spender, bytes32 _symbol) returns(uint);
29     function baseUnit(bytes32 _symbol) returns(uint8);
30     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);
31     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);
32     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(uint errorCode);
33     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) returns(uint errorCode);
34     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, address _account) returns(uint errorCode);
35     function reissueAsset(bytes32 _symbol, uint _value) returns(uint errorCode);
36     function revokeAsset(bytes32 _symbol, uint _value) returns(uint errorCode);
37     function isReissuable(bytes32 _symbol) returns(bool);
38     function changeOwnership(bytes32 _symbol, address _newOwner) returns(uint errorCode);
39     function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool);
40 }
41 
42 // File: contracts/ERC20Interface.sol
43 
44 contract ERC20Interface {
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed from, address indexed spender, uint256 value);
47     string public symbol;
48 
49     function decimals() constant returns (uint8);
50     function totalSupply() constant returns (uint256 supply);
51     function balanceOf(address _owner) constant returns (uint256 balance);
52     function transfer(address _to, uint256 _value) returns (bool success);
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
54     function approve(address _spender, uint256 _value) returns (bool success);
55     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
56 }
57 
58 // File: contracts/CAVAssetProxy.sol
59 
60 /**
61  * @title CAV Asset Proxy.
62  *
63  * Proxy implements ERC20 interface and acts as a gateway to a single platform asset.
64  * Proxy adds symbol and caller(sender) when forwarding requests to platform.
65  * Every request that is made by caller first sent to the specific asset implementation
66  * contract, which then calls back to be forwarded onto platform.
67  *
68  * Calls flow: Caller ->
69  *             Proxy.func(...) ->
70  *             Asset.__func(..., Caller.address) ->
71  *             Proxy.__func(..., Caller.address) ->
72  *             Platform.proxyFunc(..., symbol, Caller.address)
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
83 contract CAVAssetProxy is ERC20Interface {
84 
85     // Supports CAVPlatform ability to return error codes from methods
86     uint constant OK = 1;
87 
88     // Assigned platform, immutable.
89     CAVPlatform public platform;
90 
91     // Assigned symbol, immutable.
92     bytes32 public smbl;
93 
94     // Assigned name, immutable.
95     string public name;
96 
97     string public symbol;
98 
99     /**
100      * Sets platform address, assigns symbol and name.
101      *
102      * Can be set only once.
103      *
104      * @param _platform platform contract address.
105      * @param _symbol assigned symbol.
106      * @param _name assigned name.
107      *
108      * @return success.
109      */
110     function init(CAVPlatform _platform, string _symbol, string _name) returns(bool) {
111         if (address(platform) != 0x0) {
112             return false;
113         }
114         platform = _platform;
115         symbol = _symbol;
116         smbl = stringToBytes32(_symbol);
117         name = _name;
118         return true;
119     }
120 
121     function stringToBytes32(string memory source) returns (bytes32 result) {
122         assembly {
123            result := mload(add(source, 32))
124         }
125     }
126 
127     /**
128      * Only platform is allowed to call.
129      */
130     modifier onlyPlatform() {
131         if (msg.sender == address(platform)) {
132             _;
133         }
134     }
135 
136     /**
137      * Only current asset owner is allowed to call.
138      */
139     modifier onlyAssetOwner() {
140         if (platform.isOwner(msg.sender, smbl)) {
141             _;
142         }
143     }
144 
145     /**
146      * Returns asset implementation contract for current caller.
147      *
148      * @return asset implementation contract.
149      */
150     function _getAsset() internal returns(CAVAsset) {
151         return CAVAsset(getVersionFor(msg.sender));
152     }
153 
154     /**
155      * Returns asset total supply.
156      *
157      * @return asset total supply.
158      */
159     function totalSupply() constant returns(uint) {
160         return platform.totalSupply(smbl);
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
171         return platform.balanceOf(_owner, smbl);
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
183         return platform.allowance(_from, _spender, smbl);
184     }
185 
186     /**
187      * Returns asset decimals.
188      *
189      * @return asset decimals.
190      */
191     function decimals() constant returns(uint8) {
192         return platform.baseUnit(smbl);
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
204         if (_to != 0x0) {
205           return _transferWithReference(_to, _value, "");
206         }
207         else {
208             return false;
209         }
210     }
211 
212     /**
213      * Transfers asset balance from the caller to specified receiver adding specified comment.
214      *
215      * @param _to holder address to give to.
216      * @param _value amount to transfer.
217      * @param _reference transfer comment to be included in a platform's Transfer event.
218      *
219      * @return success.
220      */
221     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
222         if (_to != 0x0) {
223             return _transferWithReference(_to, _value, _reference);
224         }
225         else {
226             return false;
227         }
228     }
229 
230     /**
231      * Resolves asset implementation contract for the caller and forwards there arguments along with
232      * the caller address.
233      *
234      * @return success.
235      */
236     function _transferWithReference(address _to, uint _value, string _reference) internal returns(bool) {
237         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
238     }
239 
240     /**
241      * Performs transfer call on the platform by the name of specified sender.
242      *
243      * Can only be called by asset implementation contract assigned to sender.
244      *
245      * @param _to holder address to give to.
246      * @param _value amount to transfer.
247      * @param _reference transfer comment to be included in a platform's Transfer event.
248      * @param _sender initial caller.
249      *
250      * @return success.
251      */
252     function __transferWithReference(address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {
253         return platform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
254     }
255 
256     /**
257      * Prforms allowance transfer of asset balance between holders.
258      *
259      * @param _from holder address to take from.
260      * @param _to holder address to give to.
261      * @param _value amount to transfer.
262      *
263      * @return success.
264      */
265     function transferFrom(address _from, address _to, uint _value) returns(bool) {
266         if (_to != 0x0) {
267             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
268          }
269          else {
270              return false;
271          }
272     }
273 
274     /**
275      * Performs allowance transfer call on the platform by the name of specified sender.
276      *
277      * Can only be called by asset implementation contract assigned to sender.
278      *
279      * @param _from holder address to take from.
280      * @param _to holder address to give to.
281      * @param _value amount to transfer.
282      * @param _reference transfer comment to be included in a platform's Transfer event.
283      * @param _sender initial caller.
284      *
285      * @return success.
286      */
287     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {
288         return platform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
289     }
290 
291     /**
292      * Sets asset spending allowance for a specified spender.
293      *
294      * @param _spender holder address to set allowance to.
295      * @param _value amount to allow.
296      *
297      * @return success.
298      */
299     function approve(address _spender, uint _value) returns(bool) {
300         if (_spender != 0x0) {
301              return _getAsset().__approve(_spender, _value, msg.sender);
302         }
303         else {
304             return false;
305         }
306     }
307 
308     /**
309      * Performs allowance setting call on the platform by the name of specified sender.
310      *
311      * Can only be called by asset implementation contract assigned to sender.
312      *
313      * @param _spender holder address to set allowance to.
314      * @param _value amount to allow.
315      * @param _sender initial caller.
316      *
317      * @return success.
318      */
319     function __approve(address _spender, uint _value, address _sender) onlyAccess(_sender) returns(bool) {
320         return platform.proxyApprove(_spender, _value, smbl, _sender) == OK;
321     }
322 
323     /**
324      * Emits ERC20 Transfer event on this contract.
325      *
326      * Can only be, and, called by assigned platform when asset transfer happens.
327      */
328     function emitTransfer(address _from, address _to, uint _value) onlyPlatform() {
329         Transfer(_from, _to, _value);
330     }
331 
332     /**
333      * Emits ERC20 Approval event on this contract.
334      *
335      * Can only be, and, called by assigned platform when asset allowance set happens.
336      */
337     function emitApprove(address _from, address _spender, uint _value) onlyPlatform() {
338         Approval(_from, _spender, _value);
339     }
340 
341     /**
342      * Resolves asset implementation contract for the caller and forwards there transaction data,
343      * along with the value. This allows for proxy interface growth.
344      */
345     function () payable {
346         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
347     }
348 
349     /**
350      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
351      */
352     event UpgradeProposal(address newVersion);
353 
354     // Current asset implementation contract address.
355     address latestVersion;
356 
357     // Proposed next asset implementation contract address.
358     address pendingVersion;
359 
360     // Upgrade freeze-time start.
361     uint pendingVersionTimestamp;
362 
363     // Timespan for users to review the new implementation and make decision.
364     uint constant UPGRADE_FREEZE_TIME = 3 days;
365 
366     // Asset implementation contract address that user decided to stick with.
367     // 0x0 means that user uses latest version.
368     mapping(address => address) userOptOutVersion;
369 
370     /**
371      * Only asset implementation contract assigned to sender is allowed to call.
372      */
373     modifier onlyAccess(address _sender) {
374         if (getVersionFor(_sender) == msg.sender) {
375             _;
376         }
377     }
378 
379     /**
380      * Returns asset implementation contract address assigned to sender.
381      *
382      * @param _sender sender address.
383      *
384      * @return asset implementation contract address.
385      */
386     function getVersionFor(address _sender) constant returns(address) {
387         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
388     }
389 
390     /**
391      * Returns current asset implementation contract address.
392      *
393      * @return asset implementation contract address.
394      */
395     function getLatestVersion() constant returns(address) {
396         return latestVersion;
397     }
398 
399     /**
400      * Returns proposed next asset implementation contract address.
401      *
402      * @return asset implementation contract address.
403      */
404     function getPendingVersion() constant returns(address) {
405         return pendingVersion;
406     }
407 
408     /**
409      * Returns upgrade freeze-time start.
410      *
411      * @return freeze-time start.
412      */
413     function getPendingVersionTimestamp() constant returns(uint) {
414         return pendingVersionTimestamp;
415     }
416 
417     /**
418      * Propose next asset implementation contract address.
419      *
420      * Can only be called by current asset owner.
421      *
422      * Note: freeze-time should not be applied for the initial setup.
423      *
424      * @param _newVersion asset implementation contract address.
425      *
426      * @return success.
427      */
428     function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {
429         // Should not already be in the upgrading process.
430         if (pendingVersion != 0x0) {
431             return false;
432         }
433         // New version address should be other than 0x0.
434         if (_newVersion == 0x0) {
435             return false;
436         }
437         // Don't apply freeze-time for the initial setup.
438         if (latestVersion == 0x0) {
439             latestVersion = _newVersion;
440             return true;
441         }
442         pendingVersion = _newVersion;
443         pendingVersionTimestamp = now;
444         UpgradeProposal(_newVersion);
445         return true;
446     }
447 
448     /**
449      * Cancel the pending upgrade process.
450      *
451      * Can only be called by current asset owner.
452      *
453      * @return success.
454      */
455     function purgeUpgrade() onlyAssetOwner() returns(bool) {
456         if (pendingVersion == 0x0) {
457             return false;
458         }
459         delete pendingVersion;
460         delete pendingVersionTimestamp;
461         return true;
462     }
463 
464     /**
465      * Finalize an upgrade process setting new asset implementation contract address.
466      *
467      * Can only be called after an upgrade freeze-time.
468      *
469      * @return success.
470      */
471     function commitUpgrade() returns(bool) {
472         if (pendingVersion == 0x0) {
473             return false;
474         }
475         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
476             return false;
477         }
478         latestVersion = pendingVersion;
479         delete pendingVersion;
480         delete pendingVersionTimestamp;
481         return true;
482     }
483 
484     /**
485      * Disagree with proposed upgrade, and stick with current asset implementation
486      * until further explicit agreement to upgrade.
487      *
488      * @return success.
489      */
490     function optOut() returns(bool) {
491         if (userOptOutVersion[msg.sender] != 0x0) {
492             return false;
493         }
494         userOptOutVersion[msg.sender] = latestVersion;
495         return true;
496     }
497 
498     /**
499      * Implicitly agree to upgrade to current and future asset implementation upgrades,
500      * until further explicit disagreement.
501      *
502      * @return success.
503      */
504     function optIn() returns(bool) {
505         delete userOptOutVersion[msg.sender];
506         return true;
507     }
508 }