1 pragma solidity 0.4.15;
2 
3 contract AssetInterface {
4     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
5     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
6     function _performApprove(address _spender, uint _value, address _sender) returns(bool);    
7     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
8     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
9     function _performGeneric(bytes, address) payable {
10         revert();
11     }
12 }
13 
14 contract AssetProxy {
15     function _forwardApprove(address _spender, uint _value, address _sender) returns(bool);
16     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
17     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
18     function balanceOf(address _owner) constant returns(uint);
19 }
20 
21 contract Bytes32 {
22     function _bytes32(string _input) internal constant returns(bytes32 result) {
23         assembly {
24             result := mload(add(_input, 32))
25         }
26     }
27 }
28 
29 contract ReturnData {
30     function _returnReturnData(bool _success) internal {
31         assembly {
32             let returndatastart := msize()
33             mstore(0x40, add(returndatastart, returndatasize))
34             returndatacopy(returndatastart, 0, returndatasize)
35             switch _success case 0 { revert(returndatastart, returndatasize) } default { return(returndatastart, returndatasize) }
36         }
37     }
38 
39     function _assemblyCall(address _destination, uint _value, bytes _data) internal returns(bool success) {
40         assembly {
41             success := call(div(mul(gas, 63), 64), _destination, _value, add(_data, 32), mload(_data), 0, 0)
42         }
43     }
44 }
45 
46 /**
47  * @title EToken2 Asset implementation contract.
48  *
49  * Basic asset implementation contract, without any additional logic.
50  * Every other asset implementation contracts should derive from this one.
51  * Receives calls from the proxy, and calls back immediatly without arguments modification.
52  *
53  * Note: all the non constant functions return false instead of throwing in case if state change
54  * didn't happen yet.
55  */
56 contract Asset is AssetInterface, Bytes32, ReturnData {
57     // Assigned asset proxy contract, immutable.
58     AssetProxy public proxy;
59 
60     /**
61      * Only assigned proxy is allowed to call.
62      */
63     modifier onlyProxy() {
64         if (proxy == msg.sender) {
65             _;
66         }
67     }
68 
69     /**
70      * Sets asset proxy address.
71      *
72      * Can be set only once.
73      *
74      * @param _proxy asset proxy contract address.
75      *
76      * @return success.
77      * @dev function is final, and must not be overridden.
78      */
79     function init(AssetProxy _proxy) returns(bool) {
80         if (address(proxy) != 0x0) {
81             return false;
82         }
83         proxy = _proxy;
84         return true;
85     }
86 
87     /**
88      * Passes execution into virtual function.
89      *
90      * Can only be called by assigned asset proxy.
91      *
92      * @return success.
93      * @dev function is final, and must not be overridden.
94      */
95     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
96         if (isICAP(_to)) {
97             return _transferToICAPWithReference(bytes32(_to) << 96, _value, _reference, _sender);
98         }
99         return _transferWithReference(_to, _value, _reference, _sender);
100     }
101 
102     /**
103      * Calls back without modifications.
104      *
105      * @return success.
106      * @dev function is virtual, and meant to be overridden.
107      */
108     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {
109         return proxy._forwardTransferFromWithReference(_sender, _to, _value, _reference, _sender);
110     }
111 
112     /**
113      * Passes execution into virtual function.
114      *
115      * Can only be called by assigned asset proxy.
116      *
117      * @return success.
118      * @dev function is final, and must not be overridden.
119      */
120     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
121         return _transferToICAPWithReference(_icap, _value, _reference, _sender);
122     }
123 
124     /**
125      * Calls back without modifications.
126      *
127      * @return success.
128      * @dev function is virtual, and meant to be overridden.
129      */
130     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
131         return proxy._forwardTransferFromToICAPWithReference(_sender, _icap, _value, _reference, _sender);
132     }
133 
134     /**
135      * Passes execution into virtual function.
136      *
137      * Can only be called by assigned asset proxy.
138      *
139      * @return success.
140      * @dev function is final, and must not be overridden.
141      */
142     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
143         if (isICAP(_to)) {
144             return _transferFromToICAPWithReference(_from, bytes32(_to) << 96, _value, _reference, _sender);
145         }
146         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
147     }
148 
149     /**
150      * Calls back without modifications.
151      *
152      * @return success.
153      * @dev function is virtual, and meant to be overridden.
154      */
155     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {
156         return proxy._forwardTransferFromWithReference(_from, _to, _value, _reference, _sender);
157     }
158 
159     /**
160      * Passes execution into virtual function.
161      *
162      * Can only be called by assigned asset proxy.
163      *
164      * @return success.
165      * @dev function is final, and must not be overridden.
166      */
167     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
168         return _transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
169     }
170 
171     /**
172      * Calls back without modifications.
173      *
174      * @return success.
175      * @dev function is virtual, and meant to be overridden.
176      */
177     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
178         return proxy._forwardTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
179     }
180 
181     /**
182      * Passes execution into virtual function.
183      *
184      * Can only be called by assigned asset proxy.
185      *
186      * @return success.
187      * @dev function is final, and must not be overridden.
188      */
189     function _performApprove(address _spender, uint _value, address _sender) onlyProxy() returns(bool) {
190         return _approve(_spender, _value, _sender);
191     }
192 
193     /**
194      * Calls back without modifications.
195      *
196      * @return success.
197      * @dev function is virtual, and meant to be overridden.
198      */
199     function _approve(address _spender, uint _value, address _sender) internal returns(bool) {
200         return proxy._forwardApprove(_spender, _value, _sender);
201     }
202 
203     /**
204      * Passes execution into virtual function.
205      *
206      * Can only be called by assigned asset proxy.
207      *
208      * @return bytes32 result.
209      * @dev function is final, and must not be overridden.
210      */
211     function _performGeneric(bytes _data, address _sender) payable onlyProxy() {
212         _generic(_data, msg.value, _sender);
213     }
214 
215     modifier onlyMe() {
216         if (this == msg.sender) {
217             _;
218         }
219     }
220 
221     // Most probably the following should never be redefined in child contracts.
222     address genericSender;
223     function _generic(bytes _data, uint _value, address _msgSender) internal {
224         // Restrict reentrancy.
225         require(genericSender == 0x0);
226         genericSender = _msgSender;
227         bool success = _assemblyCall(address(this), _value, _data);
228         delete genericSender;
229         _returnReturnData(success);
230     }
231 
232     // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.
233     function _sender() constant internal returns(address) {
234         return this == msg.sender ? genericSender : msg.sender;
235     }
236 
237     // Interface functions to allow specifying ICAP addresses as strings.
238     function transferToICAP(string _icap, uint _value) returns(bool) {
239         return transferToICAPWithReference(_icap, _value, '');
240     }
241 
242     function transferToICAPWithReference(string _icap, uint _value, string _reference) returns(bool) {
243         return _transferToICAPWithReference(_bytes32(_icap), _value, _reference, _sender());
244     }
245 
246     function transferFromToICAP(address _from, string _icap, uint _value) returns(bool) {
247         return transferFromToICAPWithReference(_from, _icap, _value, '');
248     }
249 
250     function transferFromToICAPWithReference(address _from, string _icap, uint _value, string _reference) returns(bool) {
251         return _transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference, _sender());
252     }
253 
254     function isICAP(address _address) constant returns(bool) {
255         bytes32 a = bytes32(_address) << 96;
256         if (a[0] != 'X' || a[1] != 'E') {
257             return false;
258         }
259         if (a[2] < 48 || a[2] > 57 || a[3] < 48 || a[3] > 57) {
260             return false;
261         }
262         for (uint i = 4; i < 20; i++) {
263             uint char = uint(a[i]);
264             if (char < 48 || char > 90 || (char > 57 && char < 65)) {
265                 return false;
266             }
267         }
268         return true;
269     }
270 }
271 
272 contract Ambi2 {
273     function claimFor(address _address, address _owner) returns(bool);
274     function hasRole(address _from, bytes32 _role, address _to) constant returns(bool);
275     function isOwner(address _node, address _owner) constant returns(bool);
276 }
277 
278 contract Ambi2Enabled {
279     Ambi2 ambi2;
280 
281     modifier onlyRole(bytes32 _role) {
282         if (address(ambi2) != 0x0 && ambi2.hasRole(this, _role, msg.sender)) {
283             _;
284         }
285     }
286 
287     // Perform only after claiming the node, or claim in the same tx.
288     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
289         if (address(ambi2) != 0x0) {
290             return false;
291         }
292 
293         ambi2 = _ambi2;
294         return true;
295     }
296 }
297 
298 contract Ambi2EnabledFull is Ambi2Enabled {
299     // Setup and claim atomically.
300     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
301         if (address(ambi2) != 0x0) {
302             return false;
303         }
304         if (!_ambi2.claimFor(this, msg.sender) && !_ambi2.isOwner(this, msg.sender)) {
305             return false;
306         }
307 
308         ambi2 = _ambi2;
309         return true;
310     }
311 }
312 
313 contract AssetWithAmbi is Asset, Ambi2EnabledFull {
314     modifier onlyRole(bytes32 _role) {
315         if (address(ambi2) != 0x0 && (ambi2.hasRole(this, _role, _sender()))) {
316             _;
317         }
318     }
319 }
320 
321 contract StatusesInterface {
322     function checkStatus(address _to, uint _value, string _reference, address _sender) returns(bool);
323     function checkStatusICAP(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
324 }
325 
326 contract DeviceToken is AssetWithAmbi {
327 
328     StatusesInterface public statuses;
329 
330     event Error(bytes32 error);
331 
332     function setStatuses(StatusesInterface _statuses) onlyRole('admin') returns(bool) {
333         statuses = StatusesInterface(_statuses);
334         return true;
335     }
336 
337     function _transferWithReference(address _to, uint _value, string _reference, address _sender)
338         internal
339         returns(bool)
340     {
341         if (!statuses.checkStatus(_to, _value, _reference, _sender)) {
342             Error('Device has status problems');
343             return false;
344         }
345         return super._transferWithReference(_to, _value, _reference, _sender);
346     }
347 
348     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender)
349         internal
350         returns(bool)
351     {
352         if (!statuses.checkStatusICAP(_icap, _value, _reference, _sender)) {
353             Error('Device has status problems');
354             return false;
355         }
356         return super._transferToICAPWithReference(_icap, _value, _reference, _sender);
357     }
358 
359     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender)
360         internal
361         returns(bool)
362     {
363         require(statuses.checkStatus(_to, _value, _reference, _sender));
364         return super._transferFromWithReference(_from, _to, _value, _reference, _sender);
365     }
366 
367     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender)
368         internal
369         returns(bool)
370     {
371         require(statuses.checkStatusICAP(_icap, _value, _reference, _sender));
372         return super._transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
373     }
374 }