1 pragma solidity 0.4.11;
2 
3 contract AssetInterface {
4     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
5     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
6     function _performApprove(address _spender, uint _value, address _sender) returns(bool);    
7     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
8     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
9     function _performGeneric(bytes _data, address _sender) payable returns(bytes32) {
10         throw;
11     }
12 }
13 
14 /**
15  * @title EToken2 Asset implementation contract.
16  *
17  * Basic asset implementation contract, without any additional logic.
18  * Every other asset implementation contracts should derive from this one.
19  * Receives calls from the proxy, and calls back immediatly without arguments modification.
20  *
21  * Note: all the non constant functions return false instead of throwing in case if state change
22  * didn't happen yet.
23  */
24 contract Asset is AssetInterface {
25     // Assigned asset proxy contract, immutable.
26     AssetProxy public proxy;
27 
28     /**
29      * Only assigned proxy is allowed to call.
30      */
31     modifier onlyProxy() {
32         if (proxy == msg.sender) {
33             _;
34         }
35     }
36 
37     /**
38      * Sets asset proxy address.
39      *
40      * Can be set only once.
41      *
42      * @param _proxy asset proxy contract address.
43      *
44      * @return success.
45      * @dev function is final, and must not be overridden.
46      */
47     function init(AssetProxy _proxy) returns(bool) {
48         if (address(proxy) != 0x0) {
49             return false;
50         }
51         proxy = _proxy;
52         return true;
53     }
54 
55     /**
56      * Passes execution into virtual function.
57      *
58      * Can only be called by assigned asset proxy.
59      *
60      * @return success.
61      * @dev function is final, and must not be overridden.
62      */
63     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
64         return _transferWithReference(_to, _value, _reference, _sender);
65     }
66 
67     /**
68      * Calls back without modifications.
69      *
70      * @return success.
71      * @dev function is virtual, and meant to be overridden.
72      */
73     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {
74         return proxy._forwardTransferFromWithReference(_sender, _to, _value, _reference, _sender);
75     }
76 
77     /**
78      * Passes execution into virtual function.
79      *
80      * Can only be called by assigned asset proxy.
81      *
82      * @return success.
83      * @dev function is final, and must not be overridden.
84      */
85     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
86         return _transferToICAPWithReference(_icap, _value, _reference, _sender);
87     }
88 
89     /**
90      * Calls back without modifications.
91      *
92      * @return success.
93      * @dev function is virtual, and meant to be overridden.
94      */
95     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
96         return proxy._forwardTransferFromToICAPWithReference(_sender, _icap, _value, _reference, _sender);
97     }
98 
99     /**
100      * Passes execution into virtual function.
101      *
102      * Can only be called by assigned asset proxy.
103      *
104      * @return success.
105      * @dev function is final, and must not be overridden.
106      */
107     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
108         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
109     }
110 
111     /**
112      * Calls back without modifications.
113      *
114      * @return success.
115      * @dev function is virtual, and meant to be overridden.
116      */
117     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {
118         return proxy._forwardTransferFromWithReference(_from, _to, _value, _reference, _sender);
119     }
120 
121     /**
122      * Passes execution into virtual function.
123      *
124      * Can only be called by assigned asset proxy.
125      *
126      * @return success.
127      * @dev function is final, and must not be overridden.
128      */
129     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
130         return _transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
131     }
132 
133     /**
134      * Calls back without modifications.
135      *
136      * @return success.
137      * @dev function is virtual, and meant to be overridden.
138      */
139     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
140         return proxy._forwardTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
141     }
142 
143     /**
144      * Passes execution into virtual function.
145      *
146      * Can only be called by assigned asset proxy.
147      *
148      * @return success.
149      * @dev function is final, and must not be overridden.
150      */
151     function _performApprove(address _spender, uint _value, address _sender) onlyProxy() returns(bool) {
152         return _approve(_spender, _value, _sender);
153     }
154 
155     /**
156      * Calls back without modifications.
157      *
158      * @return success.
159      * @dev function is virtual, and meant to be overridden.
160      */
161     function _approve(address _spender, uint _value, address _sender) internal returns(bool) {
162         return proxy._forwardApprove(_spender, _value, _sender);
163     }
164 
165     /**
166      * Passes execution into virtual function.
167      *
168      * Can only be called by assigned asset proxy.
169      *
170      * @return bytes32 result.
171      * @dev function is final, and must not be overridden.
172      */
173     function _performGeneric(bytes _data, address _sender) payable onlyProxy() returns(bytes32) {
174         return _generic(_data, _sender);
175     }
176 
177     modifier onlyMe() {
178         if (this == msg.sender) {
179             _;
180         }
181     }
182 
183     // Most probably the following should never be redefined in child contracts.
184     address genericSender;
185     function _generic(bytes _data, address _sender) internal returns(bytes32) {
186         // Restrict reentrancy.
187         if (genericSender != 0x0) {
188             throw;
189         }
190         genericSender = _sender;
191         bytes32 result = _callReturn(this, _data, msg.value);
192         delete genericSender;
193         return result;
194     }
195 
196     function _callReturn(address _target, bytes _data, uint _value) internal returns(bytes32 result) {
197         bool success;
198         assembly {
199             success := call(div(mul(gas, 63), 64), _target, _value, add(_data, 32), mload(_data), 0, 32)
200             result := mload(0)
201         }
202         if (!success) {
203             throw;
204         }
205     }
206 
207     // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.
208     function _sender() constant internal returns(address) {
209         return this == msg.sender ? genericSender : msg.sender;
210     }
211 }
212 
213 contract Ambi2 {
214     function claimFor(address _address, address _owner) returns(bool);
215     function hasRole(address _from, bytes32 _role, address _to) constant returns(bool);
216     function isOwner(address _node, address _owner) constant returns(bool);
217 }
218 
219 contract Ambi2Enabled {
220     Ambi2 ambi2;
221 
222     modifier onlyRole(bytes32 _role) {
223         if (address(ambi2) != 0x0 && ambi2.hasRole(this, _role, msg.sender)) {
224             _;
225         }
226     }
227 
228     // Perform only after claiming the node, or claim in the same tx.
229     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
230         if (address(ambi2) != 0x0) {
231             return false;
232         }
233 
234         ambi2 = _ambi2;
235         return true;
236     }
237 }
238 
239 contract Ambi2EnabledFull is Ambi2Enabled {
240     // Setup and claim atomically.
241     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
242         if (address(ambi2) != 0x0) {
243             return false;
244         }
245         if (!_ambi2.claimFor(this, msg.sender) && !_ambi2.isOwner(this, msg.sender)) {
246             return false;
247         }
248 
249         ambi2 = _ambi2;
250         return true;
251     }
252 }
253 
254 contract AssetWithAmbi is Asset, Ambi2EnabledFull {
255     modifier onlyRole(bytes32 _role) {
256         if (address(ambi2) != 0x0 && (ambi2.hasRole(this, _role, _sender()))) {
257             _;
258         }
259     }
260 }
261 
262 contract AssetProxy {
263     function _forwardApprove(address _spender, uint _value, address _sender) returns(bool);
264     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
265     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
266     function balanceOf(address _owner) constant returns(uint);
267 }
268 
269 /**
270  * @title EToken2 Asset with whitelist implementation contract.
271  */
272 contract AssetWithWhitelist is AssetWithAmbi {
273     mapping(address => bool) public whitelist;
274     uint public restrictionExpiraton;
275     bool public restrictionRemoved;
276 
277     event Error(bytes32 _errorText);
278 
279     function allowTransferFrom(address _from) onlyRole('admin') returns(bool) {
280         whitelist[_from] = true;
281         return true;
282     }
283 
284     function blockTransferFrom(address _from) onlyRole('admin') returns(bool) {
285         whitelist[_from] = false;
286         return true;
287     }
288 
289     function transferIsAllowed(address _from) constant returns(bool) {
290         return restrictionRemoved || whitelist[_from] || (now >= restrictionExpiraton);
291     }
292 
293     function removeRestriction() onlyRole('admin') returns(bool) {
294         restrictionRemoved = true;
295         return true;
296     }
297 
298     modifier transferAllowed(address _sender) {
299         if (!transferIsAllowed(_sender)) {
300             Error('Transfer not allowed');
301             return;
302         }
303         _;
304     }
305 
306     function setExpiration(uint _time) onlyRole('admin') returns(bool) {
307         if (restrictionExpiraton != 0) {
308             Error('Expiration time already set');
309             return false;
310         }
311         if (_time < now) {
312             Error('Expiration time invalid');
313             return false;
314         }
315         restrictionExpiraton = _time;
316         return true;
317     }
318 
319     // Transfers
320     function _transferWithReference(address _to, uint _value, string _reference, address _sender)
321         transferAllowed(_sender)
322         internal
323         returns(bool)
324     {
325         return super._transferWithReference(_to, _value, _reference, _sender);
326     }
327 
328     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender)
329         transferAllowed(_sender)
330         internal
331         returns(bool)
332     {
333         return super._transferToICAPWithReference(_icap, _value, _reference, _sender);
334     }
335 
336     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender)
337         transferAllowed(_from)
338         internal
339         returns(bool)
340     {
341         return super._transferFromWithReference(_from, _to, _value, _reference, _sender);
342     }
343 
344     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender)
345         transferAllowed(_from)
346         internal
347         returns(bool)
348     {
349         return super._transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
350     }
351 }