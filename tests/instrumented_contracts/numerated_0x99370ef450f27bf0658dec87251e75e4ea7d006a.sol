1 // File: contracts/core/platform/ChronoBankAssetInterface.sol
2 
3 /**
4  * Copyright 2017–2018, LaborX PTY
5  * Licensed under the AGPL Version 3 license.
6  */
7 
8 pragma solidity ^0.4.21;
9 
10 
11 contract ChronoBankAssetInterface {
12     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
13     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
14     function __approve(address _spender, uint _value, address _sender) public returns(bool);
15     function __process(bytes /*_data*/, address /*_sender*/) public payable {
16         revert();
17     }
18 }
19 
20 // File: contracts/core/platform/ChronoBankAssetProxyInterface.sol
21 
22 /**
23  * Copyright 2017–2018, LaborX PTY
24  * Licensed under the AGPL Version 3 license.
25  */
26 
27 pragma solidity ^0.4.11;
28 
29 contract ChronoBankAssetProxyInterface {
30     address public chronoBankPlatform;
31     bytes32 public smbl;
32     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
33     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
34     function __approve(address _spender, uint _value, address _sender) public returns (bool);
35     function getLatestVersion() public view returns (address);
36     function init(address _chronoBankPlatform, string _symbol, string _name) public;
37     function proposeUpgrade(address _newVersion) external returns (bool);
38 }
39 
40 // File: contracts/core/platform/ChronoBankPlatformInterface.sol
41 
42 /**
43  * Copyright 2017–2018, LaborX PTY
44  * Licensed under the AGPL Version 3 license.
45  */
46 
47 pragma solidity ^0.4.11;
48 
49 
50 contract ChronoBankPlatformInterface {
51     mapping(bytes32 => address) public proxies;
52 
53     function symbols(uint _idx) public view returns (bytes32);
54     function symbolsCount() public view returns (uint);
55     function isCreated(bytes32 _symbol) public view returns(bool);
56     function isOwner(address _owner, bytes32 _symbol) public view returns(bool);
57     function owner(bytes32 _symbol) public view returns(address);
58 
59     function setProxy(address _address, bytes32 _symbol) public returns(uint errorCode);
60 
61     function name(bytes32 _symbol) public view returns(string);
62 
63     function totalSupply(bytes32 _symbol) public view returns(uint);
64     function balanceOf(address _holder, bytes32 _symbol) public view returns(uint);
65     function allowance(address _from, address _spender, bytes32 _symbol) public view returns(uint);
66     function baseUnit(bytes32 _symbol) public view returns(uint8);
67     function description(bytes32 _symbol) public view returns(string);
68     function isReissuable(bytes32 _symbol) public view returns(bool);
69 
70     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns(uint errorCode);
71     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns(uint errorCode);
72 
73     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns(uint errorCode);
74 
75     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns(uint errorCode);
76     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, address _account) public returns(uint errorCode);
77     function reissueAsset(bytes32 _symbol, uint _value) public returns(uint errorCode);
78     function revokeAsset(bytes32 _symbol, uint _value) public returns(uint errorCode);
79 
80     function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool);
81     function changeOwnership(bytes32 _symbol, address _newOwner) public returns(uint errorCode);
82     
83     function eventsHistory() public view returns (address);
84 }
85 
86 // File: contracts/core/platform/ChronoBankAsset.sol
87 
88 /**
89  * Copyright 2017–2018, LaborX PTY
90  * Licensed under the AGPL Version 3 license.
91  */
92 
93 pragma solidity ^0.4.21;
94 
95 
96 contract ChronoBankAssetProxy is ChronoBankAssetProxyInterface {}
97 
98 contract ChronoBankPlatform is ChronoBankPlatformInterface {}
99 
100 
101 /// @title ChronoBank Asset implementation contract.
102 ///
103 /// Basic asset implementation contract, without any additional logic.
104 /// Every other asset implementation contracts should derive from this one.
105 /// Receives calls from the proxy, and calls back immediatly without arguments modification.
106 ///
107 /// Note: all the non constant functions return false instead of throwing in case if state change
108 /// didn't happen yet.
109 contract ChronoBankAsset is ChronoBankAssetInterface {
110 
111     // @dev Assigned asset proxy contract, immutable.
112     ChronoBankAssetProxy public proxy;
113 
114     // @dev banned addresses
115     mapping (address => bool) public blacklist;
116 
117     // @dev stops asset transfers
118     bool public paused = false;
119 
120     // @dev restriction/Unrestriction events
121     event Restricted(bytes32 indexed symbol, address restricted);
122     event Unrestricted(bytes32 indexed symbol, address unrestricted);
123 
124     // @dev Paused/Unpaused events
125     event Paused(bytes32 indexed symbol);
126     event Unpaused(bytes32 indexed symbol);
127 
128     /// @dev Only assigned proxy is allowed to call.
129     modifier onlyProxy {
130         if (proxy == msg.sender) {
131             _;
132         }
133     }
134 
135     /// @dev Only not paused tokens could go further.
136     modifier onlyNotPaused(address _sender) {
137         if (!paused || isAuthorized(_sender)) {
138             _;
139         }
140     }
141 
142     /// @dev Only acceptable (not in blacklist) addresses are allowed to call.
143     modifier onlyAcceptable(address _address) {
144         if (!blacklist[_address]) {
145             _;
146         }
147     }
148 
149     /// @dev Only assets's admins are allowed to execute
150     modifier onlyAuthorized {
151         if (isAuthorized(msg.sender)) {
152             _;
153         }
154     }
155 
156     /// @notice Sets asset proxy address.
157     /// Can be set only once.
158     /// @dev function is final, and must not be overridden.
159     /// @param _proxy asset proxy contract address.
160     /// @return success.
161     function init(ChronoBankAssetProxy _proxy) public returns(bool) {
162         if (address(proxy) != 0x0) {
163             return false;
164         }
165         proxy = _proxy;
166         return true;
167     }
168 
169     /// @notice Gets eventsHistory contract used for events' triggering
170     function eventsHistory() public view returns (address) {
171         ChronoBankPlatform platform = ChronoBankPlatform(proxy.chronoBankPlatform());
172         return platform.eventsHistory() != address(platform) ? platform.eventsHistory() : this;
173     }
174 
175     /// @notice Lifts the ban on transfers for given addresses
176     function restrict(address [] _restricted) onlyAuthorized external returns (bool) {
177         for (uint i = 0; i < _restricted.length; i++) {
178             address restricted = _restricted[i];
179             blacklist[restricted] = true;
180             _emitRestricted(restricted);
181         }
182         return true;
183     }
184 
185     /// @notice Revokes the ban on transfers for given addresses
186     function unrestrict(address [] _unrestricted) onlyAuthorized external returns (bool) {
187         for (uint i = 0; i < _unrestricted.length; i++) {
188             address unrestricted = _unrestricted[i];
189             delete blacklist[unrestricted];
190             _emitUnrestricted(unrestricted);
191         }
192         return true;
193     }
194 
195     /// @notice called by the owner to pause, triggers stopped state
196     /// Only admin is allowed to execute this method.
197     function pause() onlyAuthorized external returns (bool) {
198         paused = true;
199         _emitPaused();
200         return true;
201     }
202 
203     /// @notice called by the owner to unpause, returns to normal state
204     /// Only admin is allowed to execute this method.
205     function unpause() onlyAuthorized external returns (bool) {
206         paused = false;
207         _emitUnpaused();
208         return true;
209     }
210 
211     /// @notice Passes execution into virtual function.
212     /// Can only be called by assigned asset proxy.
213     /// @dev function is final, and must not be overridden.
214     /// @return success.
215     function __transferWithReference(
216         address _to, 
217         uint _value, 
218         string _reference, 
219         address _sender
220     ) 
221     onlyProxy 
222     public 
223     returns (bool) 
224     {
225         return _transferWithReference(_to, _value, _reference, _sender);
226     }
227 
228     /// @notice Calls back without modifications if an asset is not stopped.
229     /// Checks whether _from/_sender are not in blacklist.
230     /// @dev function is virtual, and meant to be overridden.
231     /// @return success.
232     function _transferWithReference(
233         address _to, 
234         uint _value, 
235         string _reference, 
236         address _sender
237     )
238     onlyNotPaused(_sender)
239     onlyAcceptable(_to)
240     onlyAcceptable(_sender)
241     internal
242     returns (bool)
243     {
244         return proxy.__transferWithReference(_to, _value, _reference, _sender);
245     }
246 
247     /// @notice Passes execution into virtual function.
248     /// Can only be called by assigned asset proxy.
249     /// @dev function is final, and must not be overridden.
250     /// @return success.
251     function __transferFromWithReference(
252         address _from, 
253         address _to, 
254         uint _value, 
255         string _reference, 
256         address _sender
257     ) 
258     onlyProxy 
259     public 
260     returns (bool) 
261     {
262         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
263     }
264 
265     /// @notice Calls back without modifications if an asset is not stopped.
266     /// Checks whether _from/_sender are not in blacklist.
267     /// @dev function is virtual, and meant to be overridden.
268     /// @return success.
269     function _transferFromWithReference(
270         address _from, 
271         address _to, 
272         uint _value, 
273         string _reference, 
274         address _sender
275     )
276     onlyNotPaused(_sender)
277     onlyAcceptable(_from)
278     onlyAcceptable(_to)
279     onlyAcceptable(_sender)
280     internal
281     returns (bool)
282     {
283         return proxy.__transferFromWithReference(_from, _to, _value, _reference, _sender);
284     }
285 
286     /// @notice Passes execution into virtual function.
287     /// Can only be called by assigned asset proxy.
288     /// @dev function is final, and must not be overridden.
289     /// @return success.
290     function __approve(address _spender, uint _value, address _sender) onlyProxy public returns (bool) {
291         return _approve(_spender, _value, _sender);
292     }
293 
294     /// @notice Calls back without modifications.
295     /// @dev function is virtual, and meant to be overridden.
296     /// @return success.
297     function _approve(address _spender, uint _value, address _sender)
298     onlyAcceptable(_spender)
299     onlyAcceptable(_sender)
300     internal
301     returns (bool)
302     {
303         return proxy.__approve(_spender, _value, _sender);
304     }
305 
306     function isAuthorized(address _owner)
307     public
308     view
309     returns (bool) {
310         ChronoBankPlatform platform = ChronoBankPlatform(proxy.chronoBankPlatform());
311         return platform.hasAssetRights(_owner, proxy.smbl());
312     }
313 
314     function _emitRestricted(address _restricted) private {
315         ChronoBankAsset(eventsHistory()).emitRestricted(proxy.smbl(), _restricted);
316     }
317 
318     function _emitUnrestricted(address _unrestricted) private {
319         ChronoBankAsset(eventsHistory()).emitUnrestricted(proxy.smbl(), _unrestricted);
320     }
321 
322     function _emitPaused() private {
323         ChronoBankAsset(eventsHistory()).emitPaused(proxy.smbl());
324     }
325 
326     function _emitUnpaused() private {
327         ChronoBankAsset(eventsHistory()).emitUnpaused(proxy.smbl());
328     }
329 
330     function emitRestricted(bytes32 _symbol, address _restricted) public {
331         emit Restricted(_symbol, _restricted);
332     }
333 
334     function emitUnrestricted(bytes32 _symbol, address _unrestricted) public {
335         emit Unrestricted(_symbol, _unrestricted);
336     }
337 
338     function emitPaused(bytes32 _symbol) public {
339         emit Paused(_symbol);
340     }
341 
342     function emitUnpaused(bytes32 _symbol) public {
343         emit Unpaused(_symbol);
344     }
345 }