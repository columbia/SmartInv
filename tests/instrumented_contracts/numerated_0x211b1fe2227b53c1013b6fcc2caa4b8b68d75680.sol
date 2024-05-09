1 // File: contracts/core/platform/ChronoBankPlatformInterface.sol
2 
3 /**
4  * Copyright 2017–2018, LaborX PTY
5  * Licensed under the AGPL Version 3 license.
6  */
7 
8 pragma solidity ^0.4.11;
9 
10 
11 contract ChronoBankPlatformInterface {
12     mapping(bytes32 => address) public proxies;
13 
14     function symbols(uint _idx) public view returns (bytes32);
15     function symbolsCount() public view returns (uint);
16     function isCreated(bytes32 _symbol) public view returns(bool);
17     function isOwner(address _owner, bytes32 _symbol) public view returns(bool);
18     function owner(bytes32 _symbol) public view returns(address);
19 
20     function setProxy(address _address, bytes32 _symbol) public returns(uint errorCode);
21 
22     function name(bytes32 _symbol) public view returns(string);
23 
24     function totalSupply(bytes32 _symbol) public view returns(uint);
25     function balanceOf(address _holder, bytes32 _symbol) public view returns(uint);
26     function allowance(address _from, address _spender, bytes32 _symbol) public view returns(uint);
27     function baseUnit(bytes32 _symbol) public view returns(uint8);
28     function description(bytes32 _symbol) public view returns(string);
29     function isReissuable(bytes32 _symbol) public view returns(bool);
30 
31     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns(uint errorCode);
32     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns(uint errorCode);
33 
34     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns(uint errorCode);
35 
36     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns(uint errorCode);
37     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, address _account) public returns(uint errorCode);
38     function reissueAsset(bytes32 _symbol, uint _value) public returns(uint errorCode);
39     function revokeAsset(bytes32 _symbol, uint _value) public returns(uint errorCode);
40 
41     function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool);
42     function changeOwnership(bytes32 _symbol, address _newOwner) public returns(uint errorCode);
43     
44     function eventsHistory() public view returns (address);
45 }
46 
47 // File: contracts/core/platform/ChronoBankAssetInterface.sol
48 
49 /**
50  * Copyright 2017–2018, LaborX PTY
51  * Licensed under the AGPL Version 3 license.
52  */
53 
54 pragma solidity ^0.4.21;
55 
56 
57 contract ChronoBankAssetInterface {
58     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
59     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
60     function __approve(address _spender, uint _value, address _sender) public returns(bool);
61     function __process(bytes /*_data*/, address /*_sender*/) public payable {
62         revert();
63     }
64 }
65 
66 // File: contracts/core/erc20/ERC20Interface.sol
67 
68 /**
69  * Copyright 2017–2018, LaborX PTY
70  * Licensed under the AGPL Version 3 license.
71  */
72 
73 pragma solidity ^0.4.11;
74 
75 contract ERC20Interface {
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed from, address indexed spender, uint256 value);
78     string public symbol;
79 
80     function decimals() constant returns (uint8);
81     function totalSupply() constant returns (uint256 supply);
82     function balanceOf(address _owner) constant returns (uint256 balance);
83     function transfer(address _to, uint256 _value) returns (bool success);
84     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
85     function approve(address _spender, uint256 _value) returns (bool success);
86     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
87 }
88 
89 // File: contracts/core/platform/ChronoBankAssetProxy.sol
90 
91 /**
92  * Copyright 2017–2018, LaborX PTY
93  * Licensed under the AGPL Version 3 license.
94  */
95 
96 pragma solidity ^0.4.21;
97 
98 contract ERC20 is ERC20Interface {}
99 
100 contract ChronoBankPlatform is ChronoBankPlatformInterface {}
101 
102 contract ChronoBankAsset is ChronoBankAssetInterface {}
103 
104 /// @title ChronoBank Asset Proxy.
105 ///
106 /// Proxy implements ERC20 interface and acts as a gateway to a single platform asset.
107 /// Proxy adds symbol and caller(sender) when forwarding requests to platform.
108 /// Every request that is made by caller first sent to the specific asset implementation
109 /// contract, which then calls back to be forwarded onto platform.
110 ///
111 /// Calls flow: Caller ->
112 ///             Proxy.func(...) ->
113 ///             Asset.__func(..., Caller.address) ->
114 ///             Proxy.__func(..., Caller.address) ->
115 ///             Platform.proxyFunc(..., symbol, Caller.address)
116 ///
117 /// Asset implementation contract is mutable, but each user have an option to stick with
118 /// old implementation, through explicit decision made in timely manner, if he doesn't agree
119 /// with new rules.
120 /// Each user have a possibility to upgrade to latest asset contract implementation, without the
121 /// possibility to rollback.
122 ///
123 /// Note: all the non constant functions return false instead of throwing in case if state change
124 /// didn't happen yet.
125 contract ChronoBankAssetProxy is ERC20 {
126 
127     /// @dev Supports ChronoBankPlatform ability to return error codes from methods
128     uint constant OK = 1;
129 
130     /// @dev Assigned platform, immutable.
131     ChronoBankPlatform public chronoBankPlatform;
132 
133     /// @dev Assigned symbol, immutable.
134     bytes32 public smbl;
135 
136     /// @dev Assigned name, immutable.
137     string public name;
138 
139     /// @dev Assigned symbol (from ERC20 standard), immutable
140     string public symbol;
141 
142     /// @notice Sets platform address, assigns symbol and name.
143     /// Can be set only once.
144     /// @param _chronoBankPlatform platform contract address.
145     /// @param _symbol assigned symbol.
146     /// @param _name assigned name.
147     /// @return success.
148     function init(ChronoBankPlatform _chronoBankPlatform, string _symbol, string _name) public returns (bool) {
149         if (address(chronoBankPlatform) != 0x0) {
150             return false;
151         }
152 
153         chronoBankPlatform = _chronoBankPlatform;
154         symbol = _symbol;
155         smbl = stringToBytes32(_symbol);
156         name = _name;
157         return true;
158     }
159 
160     function stringToBytes32(string memory source) public pure returns (bytes32 result) {
161         assembly {
162            result := mload(add(source, 32))
163         }
164     }
165 
166     /// @dev Only platform is allowed to call.
167     modifier onlyChronoBankPlatform {
168         if (msg.sender == address(chronoBankPlatform)) {
169             _;
170         }
171     }
172 
173     /// @dev Only current asset owner is allowed to call.
174     modifier onlyAssetOwner {
175         if (chronoBankPlatform.isOwner(msg.sender, smbl)) {
176             _;
177         }
178     }
179 
180     /// @dev Returns asset implementation contract for current caller.
181     /// @return asset implementation contract.
182     function _getAsset() internal view returns (ChronoBankAsset) {
183         return ChronoBankAsset(getVersionFor(msg.sender));
184     }
185 
186     /// @notice Returns asset total supply.
187     /// @return asset total supply.
188     function totalSupply() public view returns (uint) {
189         return chronoBankPlatform.totalSupply(smbl);
190     }
191 
192     /// @notice Returns asset balance for a particular holder.
193     /// @param _owner holder address.
194     /// @return holder balance.
195     function balanceOf(address _owner) public view returns (uint) {
196         return chronoBankPlatform.balanceOf(_owner, smbl);
197     }
198 
199     /// @notice Returns asset allowance from one holder to another.
200     /// @param _from holder that allowed spending.
201     /// @param _spender holder that is allowed to spend.
202     /// @return holder to spender allowance.
203     function allowance(address _from, address _spender) public view returns (uint) {
204         return chronoBankPlatform.allowance(_from, _spender, smbl);
205     }
206 
207     /// @notice Returns asset decimals.
208     /// @return asset decimals.
209     function decimals() public view returns (uint8) {
210         return chronoBankPlatform.baseUnit(smbl);
211     }
212 
213     /// @notice Transfers asset balance from the caller to specified receiver.
214     /// @param _to holder address to give to.
215     /// @param _value amount to transfer.
216     /// @return success.
217     function transfer(address _to, uint _value) public returns (bool) {
218         if (_to != 0x0) {
219             return _transferWithReference(_to, _value, "");
220         }
221     }
222 
223     /// @notice Transfers asset balance from the caller to specified receiver adding specified comment.
224     /// @param _to holder address to give to.
225     /// @param _value amount to transfer.
226     /// @param _reference transfer comment to be included in a platform's Transfer event.
227     /// @return success.
228     function transferWithReference(address _to, uint _value, string _reference) public returns (bool) {
229         if (_to != 0x0) {
230             return _transferWithReference(_to, _value, _reference);
231         }
232     }
233 
234     /// @notice Resolves asset implementation contract for the caller and forwards there arguments along with
235     /// the caller address.
236     /// @return success.
237     function _transferWithReference(address _to, uint _value, string _reference) internal returns (bool) {
238         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
239     }
240 
241     /// @notice Performs transfer call on the platform by the name of specified sender.
242     ///
243     /// Can only be called by asset implementation contract assigned to sender.
244     ///
245     /// @param _to holder address to give to.
246     /// @param _value amount to transfer.
247     /// @param _reference transfer comment to be included in a platform's Transfer event.
248     /// @param _sender initial caller.
249     ///
250     /// @return success.
251     function __transferWithReference(
252         address _to, 
253         uint _value, 
254         string _reference, 
255         address _sender
256     ) 
257     onlyAccess(_sender) 
258     public 
259     returns (bool) 
260     {
261         return chronoBankPlatform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
262     }
263 
264     /// @notice Performs allowance transfer of asset balance between holders.
265     /// @param _from holder address to take from.
266     /// @param _to holder address to give to.
267     /// @param _value amount to transfer.
268     /// @return success.
269     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
270         if (_to != 0x0) {
271             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
272         }
273     }
274 
275     /// @notice Performs allowance transfer call on the platform by the name of specified sender.
276     ///
277     /// Can only be called by asset implementation contract assigned to sender.
278     ///
279     /// @param _from holder address to take from.
280     /// @param _to holder address to give to.
281     /// @param _value amount to transfer.
282     /// @param _reference transfer comment to be included in a platform's Transfer event.
283     /// @param _sender initial caller.
284     ///
285     /// @return success.
286     function __transferFromWithReference(
287         address _from, 
288         address _to, 
289         uint _value, 
290         string _reference, 
291         address _sender
292     ) 
293     onlyAccess(_sender) 
294     public 
295     returns (bool) 
296     {
297         return chronoBankPlatform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
298     }
299 
300     /// @notice Sets asset spending allowance for a specified spender.
301     /// @param _spender holder address to set allowance to.
302     /// @param _value amount to allow.
303     /// @return success.
304     function approve(address _spender, uint _value) public returns (bool) {
305         if (_spender != 0x0) {
306             return _getAsset().__approve(_spender, _value, msg.sender);
307         }
308     }
309 
310     /// @notice Performs allowance setting call on the platform by the name of specified sender.
311     /// Can only be called by asset implementation contract assigned to sender.
312     /// @param _spender holder address to set allowance to.
313     /// @param _value amount to allow.
314     /// @param _sender initial caller.
315     /// @return success.
316     function __approve(address _spender, uint _value, address _sender) onlyAccess(_sender) public returns (bool) {
317         return chronoBankPlatform.proxyApprove(_spender, _value, smbl, _sender) == OK;
318     }
319 
320     /// @notice Emits ERC20 Transfer event on this contract.
321     /// Can only be, and, called by assigned platform when asset transfer happens.
322     function emitTransfer(address _from, address _to, uint _value) onlyChronoBankPlatform public {
323         emit Transfer(_from, _to, _value);
324     }
325 
326     /// @notice Emits ERC20 Approval event on this contract.
327     /// Can only be, and, called by assigned platform when asset allowance set happens.
328     function emitApprove(address _from, address _spender, uint _value) onlyChronoBankPlatform public {
329         emit Approval(_from, _spender, _value);
330     }
331 
332     /// @notice Resolves asset implementation contract for the caller and forwards there transaction data,
333     /// along with the value. This allows for proxy interface growth.
334     function () public payable {
335         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
336     }
337 
338     /// @dev Indicates an upgrade freeze-time start, and the next asset implementation contract.
339     event UpgradeProposal(address newVersion);
340 
341     /// @dev Current asset implementation contract address.
342     address latestVersion;
343 
344     /// @dev Proposed next asset implementation contract address.
345     address pendingVersion;
346 
347     /// @dev Upgrade freeze-time start.
348     uint pendingVersionTimestamp;
349 
350     /// @dev Timespan for users to review the new implementation and make decision.
351     uint constant UPGRADE_FREEZE_TIME = 3 days;
352 
353     /// @dev Asset implementation contract address that user decided to stick with.
354     /// 0x0 means that user uses latest version.
355     mapping(address => address) userOptOutVersion;
356 
357     /// @dev Only asset implementation contract assigned to sender is allowed to call.
358     modifier onlyAccess(address _sender) {
359         if (getVersionFor(_sender) == msg.sender) {
360             _;
361         }
362     }
363 
364     /// @notice Returns asset implementation contract address assigned to sender.
365     /// @param _sender sender address.
366     /// @return asset implementation contract address.
367     function getVersionFor(address _sender) public view returns (address) {
368         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
369     }
370 
371     /// @notice Returns current asset implementation contract address.
372     /// @return asset implementation contract address.
373     function getLatestVersion() public view returns (address) {
374         return latestVersion;
375     }
376 
377     /// @notice Returns proposed next asset implementation contract address.
378     /// @return asset implementation contract address.
379     function getPendingVersion() public view returns (address) {
380         return pendingVersion;
381     }
382 
383     /// @notice Returns upgrade freeze-time start.
384     /// @return freeze-time start.
385     function getPendingVersionTimestamp() public view returns (uint) {
386         return pendingVersionTimestamp;
387     }
388 
389     /// @notice Propose next asset implementation contract address.
390     /// Can only be called by current asset owner.
391     /// Note: freeze-time should not be applied for the initial setup.
392     /// @param _newVersion asset implementation contract address.
393     /// @return success.
394     function proposeUpgrade(address _newVersion) onlyAssetOwner public returns (bool) {
395         // Should not already be in the upgrading process.
396         if (pendingVersion != 0x0) {
397             return false;
398         }
399 
400         // New version address should be other than 0x0.
401         if (_newVersion == 0x0) {
402             return false;
403         }
404 
405         // Don't apply freeze-time for the initial setup.
406         if (latestVersion == 0x0) {
407             latestVersion = _newVersion;
408             return true;
409         }
410 
411         pendingVersion = _newVersion;
412         pendingVersionTimestamp = now;
413 
414         emit UpgradeProposal(_newVersion);
415         return true;
416     }
417 
418     /// @notice Cancel the pending upgrade process.
419     /// Can only be called by current asset owner.
420     /// @return success.
421     function purgeUpgrade() public onlyAssetOwner returns (bool) {
422         if (pendingVersion == 0x0) {
423             return false;
424         }
425 
426         delete pendingVersion;
427         delete pendingVersionTimestamp;
428         return true;
429     }
430 
431     /// @notice Finalize an upgrade process setting new asset implementation contract address.
432     /// Can only be called after an upgrade freeze-time.
433     /// @return success.
434     function commitUpgrade() public returns (bool) {
435         if (pendingVersion == 0x0) {
436             return false;
437         }
438 
439         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
440             return false;
441         }
442 
443         latestVersion = pendingVersion;
444         delete pendingVersion;
445         delete pendingVersionTimestamp;
446         return true;
447     }
448 
449     /// @notice Disagree with proposed upgrade, and stick with current asset implementation
450     /// until further explicit agreement to upgrade.
451     /// @return success.
452     function optOut() public returns (bool) {
453         if (userOptOutVersion[msg.sender] != 0x0) {
454             return false;
455         }
456         userOptOutVersion[msg.sender] = latestVersion;
457         return true;
458     }
459 
460     /// @notice Implicitly agree to upgrade to current and future asset implementation upgrades,
461     /// until further explicit disagreement.
462     /// @return success.
463     function optIn() public returns (bool) {
464         delete userOptOutVersion[msg.sender];
465         return true;
466     }
467 }