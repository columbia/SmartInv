1 pragma solidity 0.4.23;
2 
3 contract AssetInterface {
4     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) public returns(bool);
5     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) public returns(bool);
6     function _performApprove(address _spender, uint _value, address _sender) public returns(bool);
7     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns(bool);
8     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public returns(bool);
9     function _performGeneric(bytes, address) public payable {
10         revert();
11     }
12 }
13 
14 contract ERC20Interface {
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed from, address indexed spender, uint256 value);
17 
18     function totalSupply() public view returns(uint256 supply);
19     function balanceOf(address _owner) public view returns(uint256 balance);
20     function transfer(address _to, uint256 _value) public returns(bool success);
21     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
22     function approve(address _spender, uint256 _value) public returns(bool success);
23     function allowance(address _owner, address _spender) public view returns(uint256 remaining);
24 
25     // function symbol() constant returns(string);
26     function decimals() public view returns(uint8);
27     // function name() constant returns(string);
28 }
29 
30 contract AssetProxy is ERC20Interface {
31     function _forwardApprove(address _spender, uint _value, address _sender) public returns(bool);
32     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns(bool);
33     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public returns(bool);
34     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value) public returns(bool);
35     function etoken2() public pure returns(address) {} // To be replaced by the implicit getter;
36     function etoken2Symbol() public pure returns(bytes32) {} // To be replaced by the implicit getter;
37 }
38 
39 contract Bytes32 {
40     function _bytes32(string _input) internal pure returns(bytes32 result) {
41         assembly {
42             result := mload(add(_input, 32))
43         }
44     }
45 }
46 
47 contract ReturnData {
48     function _returnReturnData(bool _success) internal pure {
49         assembly {
50             let returndatastart := 0
51             returndatacopy(returndatastart, 0, returndatasize)
52             switch _success case 0 { revert(returndatastart, returndatasize) } default { return(returndatastart, returndatasize) }
53         }
54     }
55 
56     function _assemblyCall(address _destination, uint _value, bytes _data) internal returns(bool success) {
57         assembly {
58             success := call(gas, _destination, _value, add(_data, 32), mload(_data), 0, 0)
59         }
60     }
61 }
62 
63 /**
64  * @title EToken2 Asset implementation contract.
65  *
66  * Basic asset implementation contract, without any additional logic.
67  * Every other asset implementation contracts should derive from this one.
68  * Receives calls from the proxy, and calls back immediately without arguments modification.
69  *
70  * Note: all the non constant functions return false instead of throwing in case if state change
71  * didn't happen yet.
72  */
73 contract Asset is AssetInterface, Bytes32, ReturnData {
74     // Assigned asset proxy contract, immutable.
75     AssetProxy public proxy;
76 
77     /**
78      * Only assigned proxy is allowed to call.
79      */
80     modifier onlyProxy() {
81         if (proxy == msg.sender) {
82             _;
83         }
84     }
85 
86     /**
87      * Sets asset proxy address.
88      *
89      * Can be set only once.
90      *
91      * @param _proxy asset proxy contract address.
92      *
93      * @return success.
94      * @dev function is final, and must not be overridden.
95      */
96     function init(AssetProxy _proxy) public returns(bool) {
97         if (address(proxy) != 0x0) {
98             return false;
99         }
100         proxy = _proxy;
101         return true;
102     }
103 
104     /**
105      * Passes execution into virtual function.
106      *
107      * Can only be called by assigned asset proxy.
108      *
109      * @return success.
110      * @dev function is final, and must not be overridden.
111      */
112     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) public onlyProxy() returns(bool) {
113         if (isICAP(_to)) {
114             return _transferToICAPWithReference(bytes32(_to) << 96, _value, _reference, _sender);
115         }
116         return _transferWithReference(_to, _value, _reference, _sender);
117     }
118 
119     /**
120      * Calls back without modifications.
121      *
122      * @return success.
123      * @dev function is virtual, and meant to be overridden.
124      */
125     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {
126         return proxy._forwardTransferFromWithReference(_sender, _to, _value, _reference, _sender);
127     }
128 
129     /**
130      * Passes execution into virtual function.
131      *
132      * Can only be called by assigned asset proxy.
133      *
134      * @return success.
135      * @dev function is final, and must not be overridden.
136      */
137     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) public onlyProxy() returns(bool) {
138         return _transferToICAPWithReference(_icap, _value, _reference, _sender);
139     }
140 
141     /**
142      * Calls back without modifications.
143      *
144      * @return success.
145      * @dev function is virtual, and meant to be overridden.
146      */
147     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
148         return proxy._forwardTransferFromToICAPWithReference(_sender, _icap, _value, _reference, _sender);
149     }
150 
151     /**
152      * Passes execution into virtual function.
153      *
154      * Can only be called by assigned asset proxy.
155      *
156      * @return success.
157      * @dev function is final, and must not be overridden.
158      */
159     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyProxy() returns(bool) {
160         if (isICAP(_to)) {
161             return _transferFromToICAPWithReference(_from, bytes32(_to) << 96, _value, _reference, _sender);
162         }
163         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
164     }
165 
166     /**
167      * Calls back without modifications.
168      *
169      * @return success.
170      * @dev function is virtual, and meant to be overridden.
171      */
172     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {
173         return proxy._forwardTransferFromWithReference(_from, _to, _value, _reference, _sender);
174     }
175 
176     /**
177      * Passes execution into virtual function.
178      *
179      * Can only be called by assigned asset proxy.
180      *
181      * @return success.
182      * @dev function is final, and must not be overridden.
183      */
184     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public onlyProxy() returns(bool) {
185         return _transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
186     }
187 
188     /**
189      * Calls back without modifications.
190      *
191      * @return success.
192      * @dev function is virtual, and meant to be overridden.
193      */
194     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
195         return proxy._forwardTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
196     }
197 
198     /**
199      * Passes execution into virtual function.
200      *
201      * Can only be called by assigned asset proxy.
202      *
203      * @return success.
204      * @dev function is final, and must not be overridden.
205      */
206     function _performApprove(address _spender, uint _value, address _sender) public onlyProxy() returns(bool) {
207         return _approve(_spender, _value, _sender);
208     }
209 
210     /**
211      * Calls back without modifications.
212      *
213      * @return success.
214      * @dev function is virtual, and meant to be overridden.
215      */
216     function _approve(address _spender, uint _value, address _sender) internal returns(bool) {
217         return proxy._forwardApprove(_spender, _value, _sender);
218     }
219 
220     /**
221      * Passes execution into virtual function.
222      *
223      * Can only be called by assigned asset proxy.
224      *
225      * @return bytes32 result.
226      * @dev function is final, and must not be overridden.
227      */
228     function _performGeneric(bytes _data, address _sender) public payable onlyProxy() {
229         _generic(_data, msg.value, _sender);
230     }
231 
232     modifier onlyMe() {
233         if (this == msg.sender) {
234             _;
235         }
236     }
237 
238     // Most probably the following should never be redefined in child contracts.
239     address public genericSender;
240     function _generic(bytes _data, uint _value, address _msgSender) internal {
241         // Restrict reentrancy.
242         require(genericSender == 0x0);
243         genericSender = _msgSender;
244         bool success = _assemblyCall(address(this), _value, _data);
245         delete genericSender;
246         _returnReturnData(success);
247     }
248 
249     // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.
250     function _sender() internal view returns(address) {
251         return this == msg.sender ? genericSender : msg.sender;
252     }
253 
254     // Interface functions to allow specifying ICAP addresses as strings.
255     function transferToICAP(string _icap, uint _value) public returns(bool) {
256         return transferToICAPWithReference(_icap, _value, '');
257     }
258 
259     function transferToICAPWithReference(string _icap, uint _value, string _reference) public returns(bool) {
260         return _transferToICAPWithReference(_bytes32(_icap), _value, _reference, _sender());
261     }
262 
263     function transferFromToICAP(address _from, string _icap, uint _value) public returns(bool) {
264         return transferFromToICAPWithReference(_from, _icap, _value, '');
265     }
266 
267     function transferFromToICAPWithReference(address _from, string _icap, uint _value, string _reference) public returns(bool) {
268         return _transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference, _sender());
269     }
270 
271     function isICAP(address _address) public pure returns(bool) {
272         bytes32 a = bytes32(_address) << 96;
273         if (a[0] != 'X' || a[1] != 'E') {
274             return false;
275         }
276         if (a[2] < 48 || a[2] > 57 || a[3] < 48 || a[3] > 57) {
277             return false;
278         }
279         for (uint i = 4; i < 20; i++) {
280             uint char = uint(a[i]);
281             if (char < 48 || char > 90 || (char > 57 && char < 65)) {
282                 return false;
283             }
284         }
285         return true;
286     }
287 }
288 
289 contract Ambi2 {
290     function claimFor(address _address, address _owner) public returns(bool);
291     function hasRole(address _from, bytes32 _role, address _to) public view returns(bool);
292     function isOwner(address _node, address _owner) public view returns(bool);
293 }
294 
295 contract Ambi2Enabled {
296     Ambi2 public ambi2;
297 
298     modifier onlyRole(bytes32 _role) {
299         if (address(ambi2) != 0x0 && ambi2.hasRole(this, _role, msg.sender)) {
300             _;
301         }
302     }
303 
304     // Perform only after claiming the node, or claim in the same tx.
305     function setupAmbi2(Ambi2 _ambi2) public returns(bool) {
306         if (address(ambi2) != 0x0) {
307             return false;
308         }
309 
310         ambi2 = _ambi2;
311         return true;
312     }
313 }
314 
315 contract Ambi2EnabledFull is Ambi2Enabled {
316     // Setup and claim atomically.
317     function setupAmbi2(Ambi2 _ambi2) public returns(bool) {
318         if (address(ambi2) != 0x0) {
319             return false;
320         }
321         if (!_ambi2.claimFor(this, msg.sender) && !_ambi2.isOwner(this, msg.sender)) {
322             return false;
323         }
324 
325         ambi2 = _ambi2;
326         return true;
327     }
328 }
329 
330 contract AssetWithAmbi is Asset, Ambi2EnabledFull {
331     modifier onlyRole(bytes32 _role) {
332         if (address(ambi2) != 0x0 && (ambi2.hasRole(this, _role, _sender()))) {
333             _;
334         }
335     }
336 }
337 
338 contract ComplianceConfiguration {
339     function isTransferAllowed(address _from, address _to, uint _value) public view returns(bool);
340     function isTransferToICAPAllowed(address _from, bytes32 _icap, uint _value) public view returns(bool);
341     function processTransferResult(address _from, address _to, uint _value, bool _success) public;
342     function processTransferToICAPResult(address _from, bytes32 _icap, uint _value, bool _success) public;
343 }
344 
345 /**
346  * @title EToken2 Asset with compliance configuration.
347  * Note: all the non constant functions return false instead of throwing in case if state change
348  * didn't happen yet.
349  */
350 
351 contract AssetWithCompliance is AssetWithAmbi {
352     ComplianceConfiguration complianceConfiguration;
353 
354     event Error(bytes32 error);
355     event ComplianceConfigurationSet(address contractAddress);
356 
357     /**
358      * Emits Error if verifications in complianceConfiguration contract is not valid
359      */
360     modifier isTransferAllowed(address _from, address _to, uint _value) {
361         if (address(complianceConfiguration) != 0x0 && !complianceConfiguration.isTransferAllowed(_from, _to, _value)) {
362             emit Error('Transfer is not allowed');
363             return;
364         }
365         _;
366     }
367 
368     /**
369      * Emits Error if verifications in complianceConfiguration contract is not valid
370      */
371     modifier isTransferToICAPAllowed(address _from, bytes32 _icap, uint _value) {
372         if (address(complianceConfiguration) != 0x0 && !complianceConfiguration.isTransferToICAPAllowed(_from, _icap, _value)) {
373             emit Error('Transfer is not allowed');
374             return;
375         }
376         _;
377     }
378 
379     /**
380      * Sets instance of ComplianceConfiguration object
381      *
382      * Can only be called by caller with admin role.
383      *
384      * @param _complianceConfiguration instance of ComplianceConfiguration object that will be used for whitelisting verifications.
385      *
386      * @return success.
387      */
388     function setupComplianceConfiguration(ComplianceConfiguration _complianceConfiguration) public onlyRole('admin') returns(bool) {
389         complianceConfiguration = _complianceConfiguration;
390         emit ComplianceConfigurationSet(_complianceConfiguration);
391         return true;
392     }
393 
394     function processTransferResult(address _from, address _to, uint _value, bool _success) internal returns(bool) {
395         if (address(complianceConfiguration) == 0x0) {
396             return _success;
397         }
398         complianceConfiguration.processTransferResult(_from, _to, _value, _success);
399         return _success;
400     }
401 
402     function processTransferToICAPResult(address _from, bytes32 _icap, uint _value, bool _success) internal returns(bool) {
403         if (address(complianceConfiguration) == 0x0) {
404             return _success;
405         }
406         complianceConfiguration.processTransferToICAPResult(_from, _icap, _value, _success);
407         return _success;
408     }
409 
410     // Forward calls from AssetProxy to ComplianceConfiguration mostly to be able to read data from it.
411     // Attention: make sure there is no priveleged (for this contract) functions that can be accessed through this call.
412     function () public {
413         _returnReturnData(_assemblyCall(address(complianceConfiguration), 0, msg.data));
414     }
415 
416     /**
417      * Transfers asset balance with compliance verification with adding specified comment.
418      *
419      * @param _to holder address to give to.
420      * @param _value amount to transfer.
421      * @param _reference transfer comment to be included in a EToken2's Transfer event.
422      *
423      * @return success.
424      */
425      function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal isTransferAllowed(_sender, _to, _value) returns(bool) {
426          return processTransferResult(_sender, _to, _value, super._transferWithReference(_to, _value, _reference, _sender));
427      }
428 
429     /**
430      * Transfers asset balance wwith compliance verification adding specified comment.
431      *
432      * @param _icap recipient ICAP to give to.
433      * @param _value amount to transfer.
434      * @param _reference transfer comment to be included in a EToken2's Transfer event.
435      *
436      * @return success.
437      */
438     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) internal isTransferToICAPAllowed(_sender, _icap, _value)  returns(bool) {
439         return processTransferToICAPResult(_sender, _icap, _value, super._transferToICAPWithReference(_icap, _value, _reference, _sender));
440     }
441 
442     /**
443      * Performs allowance transfer of asset balance with compliance verification between holders adding specified comment.
444      *
445      * @param _from holder address to take from.
446      * @param _to holder address to give to.
447      * @param _value amount to transfer.
448      * @param _reference transfer comment to be included in a EToken2's Transfer event.
449      *
450      * @return success.
451      */
452     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal isTransferAllowed(_from, _to, _value) returns(bool) {
453         return processTransferResult(_from, _to, _value, super._transferFromWithReference(_from, _to, _value, _reference, _sender));
454     }
455 
456     /**
457      * Performs allowance transfer of asset balance with compliance verification between holders adding specified comment.
458      * Resolves asset implementation contract for the caller and forwards there arguments along with
459      * the caller address.
460      *
461      * @param _from holder address to take from.
462      * @param _icap recipient ICAP address to give to.
463      * @param _value amount to transfer.
464      * @param _reference transfer comment to be included in a EToken2's Transfer event.
465      *
466      * @return success.
467      */
468     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) internal isTransferToICAPAllowed(_from, _icap, _value) returns(bool) {
469         return processTransferToICAPResult(_from, _icap, _value, super._transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender));
470     }
471 }