1 contract CAVAsset {
2     function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
3     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
4     function __approve(address _spender, uint _value, address _sender) returns(bool);
5     function __process(bytes _data, address _sender) payable {
6         revert();
7     }
8 }
9 
10 contract ERC20 {
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed from, address indexed spender, uint256 value);
13     string public symbol;
14 
15     function decimals() constant returns (uint8);
16     function totalSupply() constant returns (uint256 supply);
17     function balanceOf(address _owner) constant returns (uint256 balance);
18     function transfer(address _to, uint256 _value) returns (bool success);
19     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
20     function approve(address _spender, uint256 _value) returns (bool success);
21     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
22 }
23 
24 contract CAVPlatform {
25     mapping(bytes32 => address) public proxies;
26     function symbols(uint _idx) public constant returns (bytes32);
27     function symbolsCount() public constant returns (uint);
28 
29     function name(bytes32 _symbol) returns(string);
30     function setProxy(address _address, bytes32 _symbol) returns(uint errorCode);
31     function isCreated(bytes32 _symbol) constant returns(bool);
32     function isOwner(address _owner, bytes32 _symbol) returns(bool);
33     function owner(bytes32 _symbol) constant returns(address);
34     function totalSupply(bytes32 _symbol) returns(uint);
35     function balanceOf(address _holder, bytes32 _symbol) returns(uint);
36     function allowance(address _from, address _spender, bytes32 _symbol) returns(uint);
37     function baseUnit(bytes32 _symbol) returns(uint8);
38     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);
39     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);
40     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(uint errorCode);
41     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) returns(uint errorCode);
42     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, address _account) returns(uint errorCode);
43     function reissueAsset(bytes32 _symbol, uint _value) returns(uint errorCode);
44     function revokeAsset(bytes32 _symbol, uint _value) returns(uint errorCode);
45     function isReissuable(bytes32 _symbol) returns(bool);
46     function changeOwnership(bytes32 _symbol, address _newOwner) returns(uint errorCode);
47     function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool);
48 }
49 
50 contract CAVAssetProxy is ERC20 {
51 
52     // Supports CAVPlatform ability to return error codes from methods
53     uint constant OK = 1;
54 
55     // Assigned platform, immutable.
56     CAVPlatform public platform;
57 
58     // Assigned symbol, immutable.
59     bytes32 public smbl;
60 
61     // Assigned name, immutable.
62     string public name;
63 
64     string public symbol;
65 
66     /**
67      * Sets platform address, assigns symbol and name.
68      *
69      * Can be set only once.
70      *
71      * @param _platform platform contract address.
72      * @param _symbol assigned symbol.
73      * @param _name assigned name.
74      *
75      * @return success.
76      */
77     function init(CAVPlatform _platform, string _symbol, string _name) returns(bool) {
78         if (address(platform) != 0x0) {
79             return false;
80         }
81         platform = _platform;
82         symbol = _symbol;
83         smbl = stringToBytes32(_symbol);
84         name = _name;
85         return true;
86     }
87 
88     function stringToBytes32(string memory source) returns (bytes32 result) {
89         assembly {
90            result := mload(add(source, 32))
91         }
92     }
93 
94     /**
95      * Only platform is allowed to call.
96      */
97     modifier onlyPlatform() {
98         if (msg.sender == address(platform)) {
99             _;
100         }
101     }
102 
103     /**
104      * Only current asset owner is allowed to call.
105      */
106     modifier onlyAssetOwner() {
107         if (platform.isOwner(msg.sender, smbl)) {
108             _;
109         }
110     }
111 
112     /**
113      * Returns asset implementation contract for current caller.
114      *
115      * @return asset implementation contract.
116      */
117     function _getAsset() internal returns(CAVAsset) {
118         return CAVAsset(getVersionFor(msg.sender));
119     }
120 
121     /**
122      * Returns asset total supply.
123      *
124      * @return asset total supply.
125      */
126     function totalSupply() constant returns(uint) {
127         return platform.totalSupply(smbl);
128     }
129 
130     /**
131      * Returns asset balance for a particular holder.
132      *
133      * @param _owner holder address.
134      *
135      * @return holder balance.
136      */
137     function balanceOf(address _owner) constant returns(uint) {
138         return platform.balanceOf(_owner, smbl);
139     }
140 
141     /**
142      * Returns asset allowance from one holder to another.
143      *
144      * @param _from holder that allowed spending.
145      * @param _spender holder that is allowed to spend.
146      *
147      * @return holder to spender allowance.
148      */
149     function allowance(address _from, address _spender) constant returns(uint) {
150         return platform.allowance(_from, _spender, smbl);
151     }
152 
153     /**
154      * Returns asset decimals.
155      *
156      * @return asset decimals.
157      */
158     function decimals() constant returns(uint8) {
159         return platform.baseUnit(smbl);
160     }
161 
162     /**
163      * Transfers asset balance from the caller to specified receiver.
164      *
165      * @param _to holder address to give to.
166      * @param _value amount to transfer.
167      *
168      * @return success.
169      */
170     function transfer(address _to, uint _value) returns(bool) {
171         if (_to != 0x0) {
172           return _transferWithReference(_to, _value, "");
173         }
174         else {
175             return false;
176         }
177     }
178 
179     /**
180      * Transfers asset balance from the caller to specified receiver adding specified comment.
181      *
182      * @param _to holder address to give to.
183      * @param _value amount to transfer.
184      * @param _reference transfer comment to be included in a platform's Transfer event.
185      *
186      * @return success.
187      */
188     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
189         if (_to != 0x0) {
190             return _transferWithReference(_to, _value, _reference);
191         }
192         else {
193             return false;
194         }
195     }
196 
197     /**
198      * Resolves asset implementation contract for the caller and forwards there arguments along with
199      * the caller address.
200      *
201      * @return success.
202      */
203     function _transferWithReference(address _to, uint _value, string _reference) internal returns(bool) {
204         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
205     }
206 
207     /**
208      * Performs transfer call on the platform by the name of specified sender.
209      *
210      * Can only be called by asset implementation contract assigned to sender.
211      *
212      * @param _to holder address to give to.
213      * @param _value amount to transfer.
214      * @param _reference transfer comment to be included in a platform's Transfer event.
215      * @param _sender initial caller.
216      *
217      * @return success.
218      */
219     function __transferWithReference(address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {
220         return platform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
221     }
222 
223     /**
224      * Prforms allowance transfer of asset balance between holders.
225      *
226      * @param _from holder address to take from.
227      * @param _to holder address to give to.
228      * @param _value amount to transfer.
229      *
230      * @return success.
231      */
232     function transferFrom(address _from, address _to, uint _value) returns(bool) {
233         if (_to != 0x0) {
234             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
235          }
236          else {
237              return false;
238          }
239     }
240 
241     /**
242      * Performs allowance transfer call on the platform by the name of specified sender.
243      *
244      * Can only be called by asset implementation contract assigned to sender.
245      *
246      * @param _from holder address to take from.
247      * @param _to holder address to give to.
248      * @param _value amount to transfer.
249      * @param _reference transfer comment to be included in a platform's Transfer event.
250      * @param _sender initial caller.
251      *
252      * @return success.
253      */
254     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {
255         return platform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
256     }
257 
258     /**
259      * Sets asset spending allowance for a specified spender.
260      *
261      * @param _spender holder address to set allowance to.
262      * @param _value amount to allow.
263      *
264      * @return success.
265      */
266     function approve(address _spender, uint _value) returns(bool) {
267         if (_spender != 0x0) {
268              return _getAsset().__approve(_spender, _value, msg.sender);
269         }
270         else {
271             return false;
272         }
273     }
274 
275     /**
276      * Performs allowance setting call on the platform by the name of specified sender.
277      *
278      * Can only be called by asset implementation contract assigned to sender.
279      *
280      * @param _spender holder address to set allowance to.
281      * @param _value amount to allow.
282      * @param _sender initial caller.
283      *
284      * @return success.
285      */
286     function __approve(address _spender, uint _value, address _sender) onlyAccess(_sender) returns(bool) {
287         return platform.proxyApprove(_spender, _value, smbl, _sender) == OK;
288     }
289 
290     /**
291      * Emits ERC20 Transfer event on this contract.
292      *
293      * Can only be, and, called by assigned platform when asset transfer happens.
294      */
295     function emitTransfer(address _from, address _to, uint _value) onlyPlatform() {
296         Transfer(_from, _to, _value);
297     }
298 
299     /**
300      * Emits ERC20 Approval event on this contract.
301      *
302      * Can only be, and, called by assigned platform when asset allowance set happens.
303      */
304     function emitApprove(address _from, address _spender, uint _value) onlyPlatform() {
305         Approval(_from, _spender, _value);
306     }
307 
308     /**
309      * Resolves asset implementation contract for the caller and forwards there transaction data,
310      * along with the value. This allows for proxy interface growth.
311      */
312     function () payable {
313         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
314     }
315 
316     /**
317      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
318      */
319     event UpgradeProposal(address newVersion);
320 
321     // Current asset implementation contract address.
322     address latestVersion;
323 
324     // Proposed next asset implementation contract address.
325     address pendingVersion;
326 
327     // Upgrade freeze-time start.
328     uint pendingVersionTimestamp;
329 
330     // Timespan for users to review the new implementation and make decision.
331     uint constant UPGRADE_FREEZE_TIME = 3 days;
332 
333     // Asset implementation contract address that user decided to stick with.
334     // 0x0 means that user uses latest version.
335     mapping(address => address) userOptOutVersion;
336 
337     /**
338      * Only asset implementation contract assigned to sender is allowed to call.
339      */
340     modifier onlyAccess(address _sender) {
341         if (getVersionFor(_sender) == msg.sender) {
342             _;
343         }
344     }
345 
346     /**
347      * Returns asset implementation contract address assigned to sender.
348      *
349      * @param _sender sender address.
350      *
351      * @return asset implementation contract address.
352      */
353     function getVersionFor(address _sender) constant returns(address) {
354         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
355     }
356 
357     /**
358      * Returns current asset implementation contract address.
359      *
360      * @return asset implementation contract address.
361      */
362     function getLatestVersion() constant returns(address) {
363         return latestVersion;
364     }
365 
366     /**
367      * Returns proposed next asset implementation contract address.
368      *
369      * @return asset implementation contract address.
370      */
371     function getPendingVersion() constant returns(address) {
372         return pendingVersion;
373     }
374 
375     /**
376      * Returns upgrade freeze-time start.
377      *
378      * @return freeze-time start.
379      */
380     function getPendingVersionTimestamp() constant returns(uint) {
381         return pendingVersionTimestamp;
382     }
383 
384     /**
385      * Propose next asset implementation contract address.
386      *
387      * Can only be called by current asset owner.
388      *
389      * Note: freeze-time should not be applied for the initial setup.
390      *
391      * @param _newVersion asset implementation contract address.
392      *
393      * @return success.
394      */
395     function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {
396         // Should not already be in the upgrading process.
397         if (pendingVersion != 0x0) {
398             return false;
399         }
400         // New version address should be other than 0x0.
401         if (_newVersion == 0x0) {
402             return false;
403         }
404         // Don't apply freeze-time for the initial setup.
405         if (latestVersion == 0x0) {
406             latestVersion = _newVersion;
407             return true;
408         }
409         pendingVersion = _newVersion;
410         pendingVersionTimestamp = now;
411         UpgradeProposal(_newVersion);
412         return true;
413     }
414 
415     /**
416      * Cancel the pending upgrade process.
417      *
418      * Can only be called by current asset owner.
419      *
420      * @return success.
421      */
422     function purgeUpgrade() onlyAssetOwner() returns(bool) {
423         if (pendingVersion == 0x0) {
424             return false;
425         }
426         delete pendingVersion;
427         delete pendingVersionTimestamp;
428         return true;
429     }
430 
431     /**
432      * Finalize an upgrade process setting new asset implementation contract address.
433      *
434      * Can only be called after an upgrade freeze-time.
435      *
436      * @return success.
437      */
438     function commitUpgrade() returns(bool) {
439         if (pendingVersion == 0x0) {
440             return false;
441         }
442         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
443             return false;
444         }
445         latestVersion = pendingVersion;
446         delete pendingVersion;
447         delete pendingVersionTimestamp;
448         return true;
449     }
450 
451     /**
452      * Disagree with proposed upgrade, and stick with current asset implementation
453      * until further explicit agreement to upgrade.
454      *
455      * @return success.
456      */
457     function optOut() returns(bool) {
458         if (userOptOutVersion[msg.sender] != 0x0) {
459             return false;
460         }
461         userOptOutVersion[msg.sender] = latestVersion;
462         return true;
463     }
464 
465     /**
466      * Implicitly agree to upgrade to current and future asset implementation upgrades,
467      * until further explicit disagreement.
468      *
469      * @return success.
470      */
471     function optIn() returns(bool) {
472         delete userOptOutVersion[msg.sender];
473         return true;
474     }
475 }