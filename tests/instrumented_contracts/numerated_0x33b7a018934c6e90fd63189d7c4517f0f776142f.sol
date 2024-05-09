1 pragma solidity ^0.4.11;
2 
3 
4 contract ChronoBankPlatform {
5     mapping(bytes32 => address) public proxies;
6 
7     function symbols(uint _idx) public constant returns (bytes32);
8     function symbolsCount() public constant returns (uint);
9 
10     function name(bytes32 _symbol) returns(string);
11     function setProxy(address _address, bytes32 _symbol) returns(uint errorCode);
12     function isCreated(bytes32 _symbol) constant returns(bool);
13     function isOwner(address _owner, bytes32 _symbol) returns(bool);
14     function owner(bytes32 _symbol) constant returns(address);
15     function totalSupply(bytes32 _symbol) returns(uint);
16     function balanceOf(address _holder, bytes32 _symbol) returns(uint);
17     function allowance(address _from, address _spender, bytes32 _symbol) returns(uint);
18     function baseUnit(bytes32 _symbol) returns(uint8);
19     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);
20     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);
21     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(uint errorCode);
22     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) returns(uint errorCode);
23     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, address _account) returns(uint errorCode);
24     function reissueAsset(bytes32 _symbol, uint _value) returns(uint errorCode);
25     function revokeAsset(bytes32 _symbol, uint _value) returns(uint errorCode);
26     function isReissuable(bytes32 _symbol) returns(bool);
27     function changeOwnership(bytes32 _symbol, address _newOwner) returns(uint errorCode);
28 }
29 
30 contract ChronoBankAsset {
31     function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
32     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
33     function __approve(address _spender, uint _value, address _sender) returns(bool);
34     function __process(bytes _data, address _sender) payable {
35         revert();
36     }
37 }
38 
39 contract ERC20 {
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(address indexed from, address indexed spender, uint256 value);
42     string public symbol;
43 
44     function totalSupply() constant returns (uint256 supply);
45     function balanceOf(address _owner) constant returns (uint256 balance);
46     function transfer(address _to, uint256 _value) returns (bool success);
47     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
48     function approve(address _spender, uint256 _value) returns (bool success);
49     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
50 }
51 
52 /**
53  * @title ChronoBank Asset Proxy.
54  *
55  * Proxy implements ERC20 interface and acts as a gateway to a single platform asset.
56  * Proxy adds symbol and caller(sender) when forwarding requests to platform.
57  * Every request that is made by caller first sent to the specific asset implementation
58  * contract, which then calls back to be forwarded onto platform.
59  *
60  * Calls flow: Caller ->
61  *             Proxy.func(...) ->
62  *             Asset.__func(..., Caller.address) ->
63  *             Proxy.__func(..., Caller.address) ->
64  *             Platform.proxyFunc(..., symbol, Caller.address)
65  *
66  * Asset implementation contract is mutable, but each user have an option to stick with
67  * old implementation, through explicit decision made in timely manner, if he doesn't agree
68  * with new rules.
69  * Each user have a possibility to upgrade to latest asset contract implementation, without the
70  * possibility to rollback.
71  *
72  * Note: all the non constant functions return false instead of throwing in case if state change
73  * didn't happen yet.
74  */
75  contract ChronoBankAssetProxy is ERC20 {
76 
77      // Supports ChronoBankPlatform ability to return error codes from methods
78      uint constant OK = 1;
79 
80      // Assigned platform, immutable.
81      ChronoBankPlatform public chronoBankPlatform;
82 
83      // Assigned symbol, immutable.
84      bytes32 public smbl;
85 
86      // Assigned name, immutable.
87      string public name;
88 
89      string public symbol;
90 
91      /**
92       * Sets platform address, assigns symbol and name.
93       *
94       * Can be set only once.
95       *
96       * @param _chronoBankPlatform platform contract address.
97       * @param _symbol assigned symbol.
98       * @param _name assigned name.
99       *
100       * @return success.
101       */
102      function init(ChronoBankPlatform _chronoBankPlatform, string _symbol, string _name) returns(bool) {
103          if (address(chronoBankPlatform) != 0x0) {
104              return false;
105          }
106          chronoBankPlatform = _chronoBankPlatform;
107          symbol = _symbol;
108          smbl = stringToBytes32(_symbol);
109          name = _name;
110          return true;
111      }
112 
113      function stringToBytes32(string memory source) returns (bytes32 result) {
114          assembly {
115             result := mload(add(source, 32))
116          }
117      }
118 
119      /**
120       * Only platform is allowed to call.
121       */
122      modifier onlyChronoBankPlatform() {
123          if (msg.sender == address(chronoBankPlatform)) {
124              _;
125          }
126      }
127 
128      /**
129       * Only current asset owner is allowed to call.
130       */
131      modifier onlyAssetOwner() {
132          if (chronoBankPlatform.isOwner(msg.sender, smbl)) {
133              _;
134          }
135      }
136 
137      /**
138       * Returns asset implementation contract for current caller.
139       *
140       * @return asset implementation contract.
141       */
142      function _getAsset() internal returns(ChronoBankAsset) {
143          return ChronoBankAsset(getVersionFor(msg.sender));
144      }
145 
146      /**
147       * Returns asset total supply.
148       *
149       * @return asset total supply.
150       */
151      function totalSupply() constant returns(uint) {
152          return chronoBankPlatform.totalSupply(smbl);
153      }
154 
155      /**
156       * Returns asset balance for a particular holder.
157       *
158       * @param _owner holder address.
159       *
160       * @return holder balance.
161       */
162      function balanceOf(address _owner) constant returns(uint) {
163          return chronoBankPlatform.balanceOf(_owner, smbl);
164      }
165 
166      /**
167       * Returns asset allowance from one holder to another.
168       *
169       * @param _from holder that allowed spending.
170       * @param _spender holder that is allowed to spend.
171       *
172       * @return holder to spender allowance.
173       */
174      function allowance(address _from, address _spender) constant returns(uint) {
175          return chronoBankPlatform.allowance(_from, _spender, smbl);
176      }
177 
178      /**
179       * Returns asset decimals.
180       *
181       * @return asset decimals.
182       */
183      function decimals() constant returns(uint8) {
184          return chronoBankPlatform.baseUnit(smbl);
185      }
186 
187      /**
188       * Transfers asset balance from the caller to specified receiver.
189       *
190       * @param _to holder address to give to.
191       * @param _value amount to transfer.
192       *
193       * @return success.
194       */
195      function transfer(address _to, uint _value) returns(bool) {
196          if (_to != 0x0) {
197            return _transferWithReference(_to, _value, "");
198          }
199          else {
200              return false;
201          }
202      }
203 
204      /**
205       * Transfers asset balance from the caller to specified receiver adding specified comment.
206       *
207       * @param _to holder address to give to.
208       * @param _value amount to transfer.
209       * @param _reference transfer comment to be included in a platform's Transfer event.
210       *
211       * @return success.
212       */
213      function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
214          if (_to != 0x0) {
215              return _transferWithReference(_to, _value, _reference);
216          }
217          else {
218              return false;
219          }
220      }
221 
222      /**
223       * Resolves asset implementation contract for the caller and forwards there arguments along with
224       * the caller address.
225       *
226       * @return success.
227       */
228      function _transferWithReference(address _to, uint _value, string _reference) internal returns(bool) {
229          return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
230      }
231 
232      /**
233       * Performs transfer call on the platform by the name of specified sender.
234       *
235       * Can only be called by asset implementation contract assigned to sender.
236       *
237       * @param _to holder address to give to.
238       * @param _value amount to transfer.
239       * @param _reference transfer comment to be included in a platform's Transfer event.
240       * @param _sender initial caller.
241       *
242       * @return success.
243       */
244      function __transferWithReference(address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {
245          return chronoBankPlatform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
246      }
247 
248      /**
249       * Prforms allowance transfer of asset balance between holders.
250       *
251       * @param _from holder address to take from.
252       * @param _to holder address to give to.
253       * @param _value amount to transfer.
254       *
255       * @return success.
256       */
257      function transferFrom(address _from, address _to, uint _value) returns(bool) {
258          if (_to != 0x0) {
259              return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
260           }
261           else {
262               return false;
263           }
264      }
265 
266      /**
267       * Performs allowance transfer call on the platform by the name of specified sender.
268       *
269       * Can only be called by asset implementation contract assigned to sender.
270       *
271       * @param _from holder address to take from.
272       * @param _to holder address to give to.
273       * @param _value amount to transfer.
274       * @param _reference transfer comment to be included in a platform's Transfer event.
275       * @param _sender initial caller.
276       *
277       * @return success.
278       */
279      function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {
280          return chronoBankPlatform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
281      }
282 
283      /**
284       * Sets asset spending allowance for a specified spender.
285       *
286       * @param _spender holder address to set allowance to.
287       * @param _value amount to allow.
288       *
289       * @return success.
290       */
291      function approve(address _spender, uint _value) returns(bool) {
292          if (_spender != 0x0) {
293               return _getAsset().__approve(_spender, _value, msg.sender);
294          }
295          else {
296              return false;
297          }
298      }
299 
300      /**
301       * Performs allowance setting call on the platform by the name of specified sender.
302       *
303       * Can only be called by asset implementation contract assigned to sender.
304       *
305       * @param _spender holder address to set allowance to.
306       * @param _value amount to allow.
307       * @param _sender initial caller.
308       *
309       * @return success.
310       */
311      function __approve(address _spender, uint _value, address _sender) onlyAccess(_sender) returns(bool) {
312          return chronoBankPlatform.proxyApprove(_spender, _value, smbl, _sender) == OK;
313      }
314 
315      /**
316       * Emits ERC20 Transfer event on this contract.
317       *
318       * Can only be, and, called by assigned platform when asset transfer happens.
319       */
320      function emitTransfer(address _from, address _to, uint _value) onlyChronoBankPlatform() {
321          Transfer(_from, _to, _value);
322      }
323 
324      /**
325       * Emits ERC20 Approval event on this contract.
326       *
327       * Can only be, and, called by assigned platform when asset allowance set happens.
328       */
329      function emitApprove(address _from, address _spender, uint _value) onlyChronoBankPlatform() {
330          Approval(_from, _spender, _value);
331      }
332 
333      /**
334       * Resolves asset implementation contract for the caller and forwards there transaction data,
335       * along with the value. This allows for proxy interface growth.
336       */
337      function () payable {
338          _getAsset().__process.value(msg.value)(msg.data, msg.sender);
339      }
340 
341      /**
342       * Indicates an upgrade freeze-time start, and the next asset implementation contract.
343       */
344      event UpgradeProposal(address newVersion);
345 
346      // Current asset implementation contract address.
347      address latestVersion;
348 
349      // Proposed next asset implementation contract address.
350      address pendingVersion;
351 
352      // Upgrade freeze-time start.
353      uint pendingVersionTimestamp;
354 
355      // Timespan for users to review the new implementation and make decision.
356      uint constant UPGRADE_FREEZE_TIME = 3 days;
357 
358      // Asset implementation contract address that user decided to stick with.
359      // 0x0 means that user uses latest version.
360      mapping(address => address) userOptOutVersion;
361 
362      /**
363       * Only asset implementation contract assigned to sender is allowed to call.
364       */
365      modifier onlyAccess(address _sender) {
366          if (getVersionFor(_sender) == msg.sender) {
367              _;
368          }
369      }
370 
371      /**
372       * Returns asset implementation contract address assigned to sender.
373       *
374       * @param _sender sender address.
375       *
376       * @return asset implementation contract address.
377       */
378      function getVersionFor(address _sender) constant returns(address) {
379          return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
380      }
381 
382      /**
383       * Returns current asset implementation contract address.
384       *
385       * @return asset implementation contract address.
386       */
387      function getLatestVersion() constant returns(address) {
388          return latestVersion;
389      }
390 
391      /**
392       * Returns proposed next asset implementation contract address.
393       *
394       * @return asset implementation contract address.
395       */
396      function getPendingVersion() constant returns(address) {
397          return pendingVersion;
398      }
399 
400      /**
401       * Returns upgrade freeze-time start.
402       *
403       * @return freeze-time start.
404       */
405      function getPendingVersionTimestamp() constant returns(uint) {
406          return pendingVersionTimestamp;
407      }
408 
409      /**
410       * Propose next asset implementation contract address.
411       *
412       * Can only be called by current asset owner.
413       *
414       * Note: freeze-time should not be applied for the initial setup.
415       *
416       * @param _newVersion asset implementation contract address.
417       *
418       * @return success.
419       */
420      function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {
421          // Should not already be in the upgrading process.
422          if (pendingVersion != 0x0) {
423              return false;
424          }
425          // New version address should be other than 0x0.
426          if (_newVersion == 0x0) {
427              return false;
428          }
429          // Don't apply freeze-time for the initial setup.
430          if (latestVersion == 0x0) {
431              latestVersion = _newVersion;
432              return true;
433          }
434          pendingVersion = _newVersion;
435          pendingVersionTimestamp = now;
436          UpgradeProposal(_newVersion);
437          return true;
438      }
439 
440      /**
441       * Cancel the pending upgrade process.
442       *
443       * Can only be called by current asset owner.
444       *
445       * @return success.
446       */
447      function purgeUpgrade() onlyAssetOwner() returns(bool) {
448          if (pendingVersion == 0x0) {
449              return false;
450          }
451          delete pendingVersion;
452          delete pendingVersionTimestamp;
453          return true;
454      }
455 
456      /**
457       * Finalize an upgrade process setting new asset implementation contract address.
458       *
459       * Can only be called after an upgrade freeze-time.
460       *
461       * @return success.
462       */
463      function commitUpgrade() returns(bool) {
464          if (pendingVersion == 0x0) {
465              return false;
466          }
467          if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
468              return false;
469          }
470          latestVersion = pendingVersion;
471          delete pendingVersion;
472          delete pendingVersionTimestamp;
473          return true;
474      }
475 
476      /**
477       * Disagree with proposed upgrade, and stick with current asset implementation
478       * until further explicit agreement to upgrade.
479       *
480       * @return success.
481       */
482      function optOut() returns(bool) {
483          if (userOptOutVersion[msg.sender] != 0x0) {
484              return false;
485          }
486          userOptOutVersion[msg.sender] = latestVersion;
487          return true;
488      }
489 
490      /**
491       * Implicitly agree to upgrade to current and future asset implementation upgrades,
492       * until further explicit disagreement.
493       *
494       * @return success.
495       */
496      function optIn() returns(bool) {
497          delete userOptOutVersion[msg.sender];
498          return true;
499      }
500  }