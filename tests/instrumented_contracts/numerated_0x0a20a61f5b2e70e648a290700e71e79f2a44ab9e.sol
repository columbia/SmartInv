1 // This software is a subject to Ambisafe License Agreement.
2 // No use or distribution is allowed without written permission from Ambisafe.
3 // https://www.ambisafe.co/terms-of-use/
4 
5 pragma solidity 0.4.15;
6 
7 contract Ambi2 {
8     function claimFor(address _address, address _owner) returns(bool);
9     function hasRole(address _from, bytes32 _role, address _to) constant returns(bool);
10     function isOwner(address _node, address _owner) constant returns(bool);
11 }
12 
13 contract Ambi2Enabled {
14     Ambi2 ambi2;
15 
16     modifier onlyRole(bytes32 _role) {
17         if (address(ambi2) != 0x0 && ambi2.hasRole(this, _role, msg.sender)) {
18             _;
19         }
20     }
21 
22     // Perform only after claiming the node, or claim in the same tx.
23     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
24         if (address(ambi2) != 0x0) {
25             return false;
26         }
27 
28         ambi2 = _ambi2;
29         return true;
30     }
31 }
32 
33 contract Ambi2EnabledFull is Ambi2Enabled {
34     // Setup and claim atomically.
35     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
36         if (address(ambi2) != 0x0) {
37             return false;
38         }
39         if (!_ambi2.claimFor(this, msg.sender) && !_ambi2.isOwner(this, msg.sender)) {
40             return false;
41         }
42 
43         ambi2 = _ambi2;
44         return true;
45     }
46 }
47 
48 contract ReturnData {
49     function _returnReturnData(bool _success) internal {
50         assembly {
51             let returndatastart := msize()
52             mstore(0x40, add(returndatastart, returndatasize))
53             returndatacopy(returndatastart, 0, returndatasize)
54             switch _success case 0 { revert(returndatastart, returndatasize) } default { return(returndatastart, returndatasize) }
55         }
56     }
57 
58     function _assemblyCall(address _destination, uint _value, bytes _data) internal returns(bool success) {
59         assembly {
60             success := call(div(mul(gas, 63), 64), _destination, _value, add(_data, 32), mload(_data), 0, 0)
61         }
62     }
63 }
64 
65 contract Bytes32 {
66     function _bytes32(string _input) internal constant returns(bytes32 result) {
67         assembly {
68             result := mload(add(_input, 32))
69         }
70     }
71 }
72 
73 contract AssetInterface {
74     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
75     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
76     function _performApprove(address _spender, uint _value, address _sender) returns(bool);    
77     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
78     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
79     function _performGeneric(bytes, address) payable {
80         revert();
81     }
82 }
83 
84 /**
85  * @title EToken2 Asset implementation contract.
86  *
87  * Basic asset implementation contract, without any additional logic.
88  * Every other asset implementation contracts should derive from this one.
89  * Receives calls from the proxy, and calls back immediatly without arguments modification.
90  *
91  * Note: all the non constant functions return false instead of throwing in case if state change
92  * didn't happen yet.
93  */
94 contract Asset is AssetInterface, Bytes32, ReturnData {
95     // Assigned asset proxy contract, immutable.
96     AssetProxy public proxy;
97 
98     /**
99      * Only assigned proxy is allowed to call.
100      */
101     modifier onlyProxy() {
102         if (proxy == msg.sender) {
103             _;
104         }
105     }
106 
107     /**
108      * Sets asset proxy address.
109      *
110      * Can be set only once.
111      *
112      * @param _proxy asset proxy contract address.
113      *
114      * @return success.
115      * @dev function is final, and must not be overridden.
116      */
117     function init(AssetProxy _proxy) returns(bool) {
118         if (address(proxy) != 0x0) {
119             return false;
120         }
121         proxy = _proxy;
122         return true;
123     }
124 
125     /**
126      * Passes execution into virtual function.
127      *
128      * Can only be called by assigned asset proxy.
129      *
130      * @return success.
131      * @dev function is final, and must not be overridden.
132      */
133     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
134         if (isICAP(_to)) {
135             return _transferToICAPWithReference(bytes32(_to) << 96, _value, _reference, _sender);
136         }
137         return _transferWithReference(_to, _value, _reference, _sender);
138     }
139 
140     /**
141      * Calls back without modifications.
142      *
143      * @return success.
144      * @dev function is virtual, and meant to be overridden.
145      */
146     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {
147         return proxy._forwardTransferFromWithReference(_sender, _to, _value, _reference, _sender);
148     }
149 
150     /**
151      * Passes execution into virtual function.
152      *
153      * Can only be called by assigned asset proxy.
154      *
155      * @return success.
156      * @dev function is final, and must not be overridden.
157      */
158     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
159         return _transferToICAPWithReference(_icap, _value, _reference, _sender);
160     }
161 
162     /**
163      * Calls back without modifications.
164      *
165      * @return success.
166      * @dev function is virtual, and meant to be overridden.
167      */
168     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
169         return proxy._forwardTransferFromToICAPWithReference(_sender, _icap, _value, _reference, _sender);
170     }
171 
172     /**
173      * Passes execution into virtual function.
174      *
175      * Can only be called by assigned asset proxy.
176      *
177      * @return success.
178      * @dev function is final, and must not be overridden.
179      */
180     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
181         if (isICAP(_to)) {
182             return _transferFromToICAPWithReference(_from, bytes32(_to) << 96, _value, _reference, _sender);
183         }
184         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
185     }
186 
187     /**
188      * Calls back without modifications.
189      *
190      * @return success.
191      * @dev function is virtual, and meant to be overridden.
192      */
193     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {
194         return proxy._forwardTransferFromWithReference(_from, _to, _value, _reference, _sender);
195     }
196 
197     /**
198      * Passes execution into virtual function.
199      *
200      * Can only be called by assigned asset proxy.
201      *
202      * @return success.
203      * @dev function is final, and must not be overridden.
204      */
205     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
206         return _transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
207     }
208 
209     /**
210      * Calls back without modifications.
211      *
212      * @return success.
213      * @dev function is virtual, and meant to be overridden.
214      */
215     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
216         return proxy._forwardTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
217     }
218 
219     /**
220      * Passes execution into virtual function.
221      *
222      * Can only be called by assigned asset proxy.
223      *
224      * @return success.
225      * @dev function is final, and must not be overridden.
226      */
227     function _performApprove(address _spender, uint _value, address _sender) onlyProxy() returns(bool) {
228         return _approve(_spender, _value, _sender);
229     }
230 
231     /**
232      * Calls back without modifications.
233      *
234      * @return success.
235      * @dev function is virtual, and meant to be overridden.
236      */
237     function _approve(address _spender, uint _value, address _sender) internal returns(bool) {
238         return proxy._forwardApprove(_spender, _value, _sender);
239     }
240 
241     /**
242      * Passes execution into virtual function.
243      *
244      * Can only be called by assigned asset proxy.
245      *
246      * @return bytes32 result.
247      * @dev function is final, and must not be overridden.
248      */
249     function _performGeneric(bytes _data, address _sender) payable onlyProxy() {
250         _generic(_data, msg.value, _sender);
251     }
252 
253     modifier onlyMe() {
254         if (this == msg.sender) {
255             _;
256         }
257     }
258 
259     // Most probably the following should never be redefined in child contracts.
260     address genericSender;
261     function _generic(bytes _data, uint _value, address _msgSender) internal {
262         // Restrict reentrancy.
263         require(genericSender == 0x0);
264         genericSender = _msgSender;
265         bool success = _assemblyCall(address(this), _value, _data);
266         delete genericSender;
267         _returnReturnData(success);
268     }
269 
270     // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.
271     function _sender() constant internal returns(address) {
272         return this == msg.sender ? genericSender : msg.sender;
273     }
274 
275     // Interface functions to allow specifying ICAP addresses as strings.
276     function transferToICAP(string _icap, uint _value) returns(bool) {
277         return transferToICAPWithReference(_icap, _value, '');
278     }
279 
280     function transferToICAPWithReference(string _icap, uint _value, string _reference) returns(bool) {
281         return _transferToICAPWithReference(_bytes32(_icap), _value, _reference, _sender());
282     }
283 
284     function transferFromToICAP(address _from, string _icap, uint _value) returns(bool) {
285         return transferFromToICAPWithReference(_from, _icap, _value, '');
286     }
287 
288     function transferFromToICAPWithReference(address _from, string _icap, uint _value, string _reference) returns(bool) {
289         return _transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference, _sender());
290     }
291 
292     function isICAP(address _address) constant returns(bool) {
293         bytes32 a = bytes32(_address) << 96;
294         if (a[0] != 'X' || a[1] != 'E') {
295             return false;
296         }
297         if (a[2] < 48 || a[2] > 57 || a[3] < 48 || a[3] > 57) {
298             return false;
299         }
300         for (uint i = 4; i < 20; i++) {
301             uint char = uint(a[i]);
302             if (char < 48 || char > 90 || (char > 57 && char < 65)) {
303                 return false;
304             }
305         }
306         return true;
307     }
308 }
309 
310 contract AssetWithAmbi is Asset, Ambi2EnabledFull {
311     modifier onlyRole(bytes32 _role) {
312         if (address(ambi2) != 0x0 && (ambi2.hasRole(this, _role, _sender()))) {
313             _;
314         }
315     }
316 }
317 
318 contract AssetProxy {
319     function _forwardApprove(address _spender, uint _value, address _sender) returns(bool);
320     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
321     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
322     function balanceOf(address _owner) constant returns(uint);
323 }
324 
325 /**
326  * @title EToken2 Asset with whitelist implementation contract.
327  */
328 contract AssetWithWhitelist is AssetWithAmbi {
329     mapping(address => bool) public whitelist;
330     uint public restrictionExpiraton;
331     bool public restrictionRemoved;
332 
333     event Error(bytes32 _errorText);
334 
335     function allowTransferFrom(address _from) onlyRole('admin') returns(bool) {
336         whitelist[_from] = true;
337         return true;
338     }
339 
340     function blockTransferFrom(address _from) onlyRole('admin') returns(bool) {
341         whitelist[_from] = false;
342         return true;
343     }
344 
345     function transferIsAllowed(address _from) constant returns(bool) {
346         return restrictionRemoved || whitelist[_from] || (now >= restrictionExpiraton);
347     }
348 
349     function removeRestriction() onlyRole('admin') returns(bool) {
350         restrictionRemoved = true;
351         return true;
352     }
353 
354     modifier transferAllowed(address _sender) {
355         if (!transferIsAllowed(_sender)) {
356             Error('Transfer not allowed');
357             return;
358         }
359         _;
360     }
361 
362     function setExpiration(uint _time) onlyRole('admin') returns(bool) {
363         if (restrictionExpiraton != 0) {
364             Error('Expiration time already set');
365             return false;
366         }
367         if (_time < now) {
368             Error('Expiration time invalid');
369             return false;
370         }
371         restrictionExpiraton = _time;
372         return true;
373     }
374 
375     // Transfers
376     function _transferWithReference(address _to, uint _value, string _reference, address _sender)
377         transferAllowed(_sender)
378         internal
379         returns(bool)
380     {
381         return super._transferWithReference(_to, _value, _reference, _sender);
382     }
383 
384     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender)
385         transferAllowed(_sender)
386         internal
387         returns(bool)
388     {
389         return super._transferToICAPWithReference(_icap, _value, _reference, _sender);
390     }
391 
392     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender)
393         transferAllowed(_from)
394         internal
395         returns(bool)
396     {
397         return super._transferFromWithReference(_from, _to, _value, _reference, _sender);
398     }
399 
400     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender)
401         transferAllowed(_from)
402         internal
403         returns(bool)
404     {
405         return super._transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
406     }
407 }