1 pragma solidity ^0.4.11;
2 
3 contract BMCPlatform {
4     mapping(bytes32 => address) public proxies;
5     function name(bytes32 _symbol) returns(string);
6     function setProxy(address _address, bytes32 _symbol) returns(uint errorCode);
7     function isOwner(address _owner, bytes32 _symbol) returns(bool);
8     function totalSupply(bytes32 _symbol) returns(uint);
9     function balanceOf(address _holder, bytes32 _symbol) returns(uint);
10     function allowance(address _from, address _spender, bytes32 _symbol) returns(uint);
11     function baseUnit(bytes32 _symbol) returns(uint8);
12     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);
13     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);
14     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(uint errorCode);
15     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) returns(uint errorCode);
16     function reissueAsset(bytes32 _symbol, uint _value) returns(uint errorCode);
17     function revokeAsset(bytes32 _symbol, uint _value) returns(uint errorCode);
18     function isReissuable(bytes32 _symbol) returns(bool);
19     function changeOwnership(bytes32 _symbol, address _newOwner) returns(uint errorCode);
20 }
21 
22 contract BMCAsset {
23     function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
24     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
25     function __approve(address _spender, uint _value, address _sender) returns(bool);
26     function __process(bytes _data, address _sender) payable {
27         throw;
28     }
29 }
30 
31 contract ERC20 {
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed from, address indexed spender, uint256 value);
34     string public symbol;
35 
36     function totalSupply() constant returns (uint256 supply);
37     function balanceOf(address _owner) constant returns (uint256 balance);
38     function transfer(address _to, uint256 _value) returns (bool success);
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
40     function approve(address _spender, uint256 _value) returns (bool success);
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
42 }
43 
44 /**
45  * @title BMC Asset Proxy.
46  *
47  * Proxy implements ERC20 interface and acts as a gateway to a single platform asset.
48  * Proxy adds symbol and caller(sender) when forwarding requests to platform.
49  * Every request that is made by caller first sent to the specific asset implementation
50  * contract, which then calls back to be forwarded onto platform.
51  *
52  * Calls flow: Caller ->
53  *             Proxy.func(...) ->
54  *             Asset.__func(..., Caller.address) ->
55  *             Proxy.__func(..., Caller.address) ->
56  *             Platform.proxyFunc(..., symbol, Caller.address)
57  *
58  * Asset implementation contract is mutable, but each user have an option to stick with
59  * old implementation, through explicit decision made in timely manner, if he doesn't agree
60  * with new rules.
61  * Each user have a possibility to upgrade to latest asset contract implementation, without the
62  * possibility to rollback.
63  *
64  * Note: all the non constant functions return false instead of throwing in case if state change
65  * didn't happen yet.
66  */
67 contract BMCAssetProxy is ERC20 {
68 
69     // Supports BMCPlatform ability to return error codes from methods
70     uint constant OK = 1;
71 
72     // Assigned platform, immutable.
73     BMCPlatform public bmcPlatform;
74 
75     // Assigned symbol, immutable.
76     bytes32 public smbl;
77 
78     // Assigned name, immutable.
79     string public name;
80 
81     string public symbol;
82 
83     /**
84      * Sets platform address, assigns symbol and name.
85      *
86      * Can be set only once.
87      *
88      * @param _bmcPlatform platform contract address.
89      * @param _symbol assigned symbol.
90      * @param _name assigned name.
91      *
92      * @return success.
93      */
94     function init(BMCPlatform _bmcPlatform, string _symbol, string _name) returns(bool) {
95         if (address(bmcPlatform) != 0x0) {
96             return false;
97         }
98         bmcPlatform = _bmcPlatform;
99         symbol = _symbol;
100         smbl = stringToBytes32(_symbol);
101         name = _name;
102         return true;
103     }
104 
105     function stringToBytes32(string memory source) returns (bytes32 result) {
106         assembly {
107            result := mload(add(source, 32))
108         }
109     }
110 
111     /**
112      * Only platform is allowed to call.
113      */
114     modifier onlyBMCPlatform() {
115         if (msg.sender == address(bmcPlatform)) {
116             _;
117         }
118     }
119 
120     /**
121      * Only current asset owner is allowed to call.
122      */
123     modifier onlyAssetOwner() {
124         if (bmcPlatform.isOwner(msg.sender, smbl)) {
125             _;
126         }
127     }
128 
129     /**
130      * Returns asset implementation contract for current caller.
131      *
132      * @return asset implementation contract.
133      */
134     function _getAsset() internal returns(BMCAsset) {
135         return BMCAsset(getVersionFor(msg.sender));
136     }
137 
138     /**
139      * Returns asset total supply.
140      *
141      * @return asset total supply.
142      */
143     function totalSupply() constant returns(uint) {
144         return bmcPlatform.totalSupply(smbl);
145     }
146 
147     /**
148      * Returns asset balance for a particular holder.
149      *
150      * @param _owner holder address.
151      *
152      * @return holder balance.
153      */
154     function balanceOf(address _owner) constant returns(uint) {
155         return bmcPlatform.balanceOf(_owner, smbl);
156     }
157 
158     /**
159      * Returns asset allowance from one holder to another.
160      *
161      * @param _from holder that allowed spending.
162      * @param _spender holder that is allowed to spend.
163      *
164      * @return holder to spender allowance.
165      */
166     function allowance(address _from, address _spender) constant returns(uint) {
167         return bmcPlatform.allowance(_from, _spender, smbl);
168     }
169 
170     /**
171      * Returns asset decimals.
172      *
173      * @return asset decimals.
174      */
175     function decimals() constant returns(uint8) {
176         return bmcPlatform.baseUnit(smbl);
177     }
178 
179     /**
180      * Transfers asset balance from the caller to specified receiver.
181      *
182      * @param _to holder address to give to.
183      * @param _value amount to transfer.
184      *
185      * @return success.
186      */
187     function transfer(address _to, uint _value) returns(bool) {
188         if (_to != 0x0) {
189           return _transferWithReference(_to, _value, "");
190         }
191         else {
192             return false;
193         }
194     }
195 
196     /**
197      * Transfers asset balance from the caller to specified receiver adding specified comment.
198      *
199      * @param _to holder address to give to.
200      * @param _value amount to transfer.
201      * @param _reference transfer comment to be included in a platform's Transfer event.
202      *
203      * @return success.
204      */
205     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
206         if (_to != 0x0) {
207             return _transferWithReference(_to, _value, _reference);
208         }
209         else {
210             return false;
211         }
212     }
213 
214     /**
215      * Resolves asset implementation contract for the caller and forwards there arguments along with
216      * the caller address.
217      *
218      * @return success.
219      */
220     function _transferWithReference(address _to, uint _value, string _reference) internal returns(bool) {
221         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
222     }
223 
224     /**
225      * Performs transfer call on the platform by the name of specified sender.
226      *
227      * Can only be called by asset implementation contract assigned to sender.
228      *
229      * @param _to holder address to give to.
230      * @param _value amount to transfer.
231      * @param _reference transfer comment to be included in a platform's Transfer event.
232      * @param _sender initial caller.
233      *
234      * @return success.
235      */
236     function __transferWithReference(address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {
237         return bmcPlatform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
238     }
239 
240     /**
241      * Prforms allowance transfer of asset balance between holders.
242      *
243      * @param _from holder address to take from.
244      * @param _to holder address to give to.
245      * @param _value amount to transfer.
246      *
247      * @return success.
248      */
249     function transferFrom(address _from, address _to, uint _value) returns(bool) {
250         if (_to != 0x0) {
251             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
252          }
253          else {
254              return false;
255          }
256     }
257 
258     /**
259      * Performs allowance transfer call on the platform by the name of specified sender.
260      *
261      * Can only be called by asset implementation contract assigned to sender.
262      *
263      * @param _from holder address to take from.
264      * @param _to holder address to give to.
265      * @param _value amount to transfer.
266      * @param _reference transfer comment to be included in a platform's Transfer event.
267      * @param _sender initial caller.
268      *
269      * @return success.
270      */
271     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {
272         return bmcPlatform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
273     }
274 
275     /**
276      * Sets asset spending allowance for a specified spender.
277      *
278      * @param _spender holder address to set allowance to.
279      * @param _value amount to allow.
280      *
281      * @return success.
282      */
283     function approve(address _spender, uint _value) returns(bool) {
284         if (_spender != 0x0) {
285              return _getAsset().__approve(_spender, _value, msg.sender);
286         }
287         else {
288             return false;
289         }
290     }
291 
292     /**
293      * Performs allowance setting call on the platform by the name of specified sender.
294      *
295      * Can only be called by asset implementation contract assigned to sender.
296      *
297      * @param _spender holder address to set allowance to.
298      * @param _value amount to allow.
299      * @param _sender initial caller.
300      *
301      * @return success.
302      */
303     function __approve(address _spender, uint _value, address _sender) onlyAccess(_sender) returns(bool) {
304         return bmcPlatform.proxyApprove(_spender, _value, smbl, _sender) == OK;
305     }
306 
307     /**
308      * Emits ERC20 Transfer event on this contract.
309      *
310      * Can only be, and, called by assigned platform when asset transfer happens.
311      */
312     function emitTransfer(address _from, address _to, uint _value) onlyBMCPlatform() {
313         Transfer(_from, _to, _value);
314     }
315 
316     /**
317      * Emits ERC20 Approval event on this contract.
318      *
319      * Can only be, and, called by assigned platform when asset allowance set happens.
320      */
321     function emitApprove(address _from, address _spender, uint _value) onlyBMCPlatform() {
322         Approval(_from, _spender, _value);
323     }
324 
325     /**
326      * Resolves asset implementation contract for the caller and forwards there transaction data,
327      * along with the value. This allows for proxy interface growth.
328      */
329     function () payable {
330         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
331     }
332 
333     /**
334      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
335      */
336     event UpgradeProposal(address newVersion);
337 
338     // Current asset implementation contract address.
339     address latestVersion;
340 
341     // Proposed next asset implementation contract address.
342     address pendingVersion;
343 
344     // Upgrade freeze-time start.
345     uint pendingVersionTimestamp;
346 
347     // Timespan for users to review the new implementation and make decision.
348     uint constant UPGRADE_FREEZE_TIME = 3 days;
349 
350     // Asset implementation contract address that user decided to stick with.
351     // 0x0 means that user uses latest version.
352     mapping(address => address) userOptOutVersion;
353 
354     /**
355      * Only asset implementation contract assigned to sender is allowed to call.
356      */
357     modifier onlyAccess(address _sender) {
358         if (getVersionFor(_sender) == msg.sender) {
359             _;
360         }
361     }
362 
363     /**
364      * Returns asset implementation contract address assigned to sender.
365      *
366      * @param _sender sender address.
367      *
368      * @return asset implementation contract address.
369      */
370     function getVersionFor(address _sender) constant returns(address) {
371         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
372     }
373 
374     /**
375      * Returns current asset implementation contract address.
376      *
377      * @return asset implementation contract address.
378      */
379     function getLatestVersion() constant returns(address) {
380         return latestVersion;
381     }
382 
383     /**
384      * Returns proposed next asset implementation contract address.
385      *
386      * @return asset implementation contract address.
387      */
388     function getPendingVersion() constant returns(address) {
389         return pendingVersion;
390     }
391 
392     /**
393      * Returns upgrade freeze-time start.
394      *
395      * @return freeze-time start.
396      */
397     function getPendingVersionTimestamp() constant returns(uint) {
398         return pendingVersionTimestamp;
399     }
400 
401     /**
402      * Propose next asset implementation contract address.
403      *
404      * Can only be called by current asset owner.
405      *
406      * Note: freeze-time should not be applied for the initial setup.
407      *
408      * @param _newVersion asset implementation contract address.
409      *
410      * @return success.
411      */
412     function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {
413         // Should not already be in the upgrading process.
414         if (pendingVersion != 0x0) {
415             return false;
416         }
417         // New version address should be other than 0x0.
418         if (_newVersion == 0x0) {
419             return false;
420         }
421         // Don't apply freeze-time for the initial setup.
422         if (latestVersion == 0x0) {
423             latestVersion = _newVersion;
424             return true;
425         }
426         pendingVersion = _newVersion;
427         pendingVersionTimestamp = now;
428         UpgradeProposal(_newVersion);
429         return true;
430     }
431 
432     /**
433      * Cancel the pending upgrade process.
434      *
435      * Can only be called by current asset owner.
436      *
437      * @return success.
438      */
439     function purgeUpgrade() onlyAssetOwner() returns(bool) {
440         if (pendingVersion == 0x0) {
441             return false;
442         }
443         delete pendingVersion;
444         delete pendingVersionTimestamp;
445         return true;
446     }
447 
448     /**
449      * Finalize an upgrade process setting new asset implementation contract address.
450      *
451      * Can only be called after an upgrade freeze-time.
452      *
453      * @return success.
454      */
455     function commitUpgrade() returns(bool) {
456         if (pendingVersion == 0x0) {
457             return false;
458         }
459         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
460             return false;
461         }
462         latestVersion = pendingVersion;
463         delete pendingVersion;
464         delete pendingVersionTimestamp;
465         return true;
466     }
467 
468     /**
469      * Disagree with proposed upgrade, and stick with current asset implementation
470      * until further explicit agreement to upgrade.
471      *
472      * @return success.
473      */
474     function optOut() returns(bool) {
475         if (userOptOutVersion[msg.sender] != 0x0) {
476             return false;
477         }
478         userOptOutVersion[msg.sender] = latestVersion;
479         return true;
480     }
481 
482     /**
483      * Implicitly agree to upgrade to current and future asset implementation upgrades,
484      * until further explicit disagreement.
485      *
486      * @return success.
487      */
488     function optIn() returns(bool) {
489         delete userOptOutVersion[msg.sender];
490         return true;
491     }
492 }