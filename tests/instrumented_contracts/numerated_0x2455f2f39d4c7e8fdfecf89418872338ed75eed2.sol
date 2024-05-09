1 // File: contracts/AssetInterface.sol
2 
3 pragma solidity 0.4.23;
4 
5 
6 contract AssetInterface {
7     function _performTransferWithReference(
8         address _to,
9         uint _value,
10         string _reference,
11         address _sender)
12     public returns(bool);
13 
14     function _performTransferToICAPWithReference(
15         bytes32 _icap,
16         uint _value,
17         string _reference,
18         address _sender)
19     public returns(bool);
20 
21     function _performApprove(address _spender, uint _value, address _sender)
22     public returns(bool);
23 
24     function _performTransferFromWithReference(
25         address _from,
26         address _to,
27         uint _value,
28         string _reference,
29         address _sender)
30     public returns(bool);
31 
32     function _performTransferFromToICAPWithReference(
33         address _from,
34         bytes32 _icap,
35         uint _value,
36         string _reference,
37         address _sender)
38     public returns(bool);
39 
40     function _performGeneric(bytes, address) public payable {
41         revert();
42     }
43 }
44 
45 // File: contracts/ERC20Interface.sol
46 
47 pragma solidity 0.4.23;
48 
49 
50 contract ERC20Interface {
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed from, address indexed spender, uint256 value);
53 
54     function totalSupply() public view returns(uint256 supply);
55     function balanceOf(address _owner) public view returns(uint256 balance);
56     // solhint-disable-next-line no-simple-event-func-name
57     function transfer(address _to, uint256 _value) public returns(bool success);
58     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
59     function approve(address _spender, uint256 _value) public returns(bool success);
60     function allowance(address _owner, address _spender) public view returns(uint256 remaining);
61 
62     // function symbol() constant returns(string);
63     function decimals() public view returns(uint8);
64     // function name() constant returns(string);
65 }
66 
67 // File: contracts/AssetProxyInterface.sol
68 
69 pragma solidity 0.4.23;
70 
71 
72 
73 contract AssetProxyInterface is ERC20Interface {
74     function _forwardApprove(address _spender, uint _value, address _sender)
75     public returns(bool);
76 
77     function _forwardTransferFromWithReference(
78         address _from,
79         address _to,
80         uint _value,
81         string _reference,
82         address _sender)
83     public returns(bool);
84 
85     function _forwardTransferFromToICAPWithReference(
86         address _from,
87         bytes32 _icap,
88         uint _value,
89         string _reference,
90         address _sender)
91     public returns(bool);
92 
93     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value)
94     public returns(bool);
95 
96     // solhint-disable-next-line no-empty-blocks
97     function etoken2() public pure returns(address) {} // To be replaced by the implicit getter;
98 
99     // To be replaced by the implicit getter;
100     // solhint-disable-next-line no-empty-blocks
101     function etoken2Symbol() public pure returns(bytes32) {}
102 }
103 
104 // File: contracts/helpers/Bytes32.sol
105 
106 pragma solidity 0.4.23;
107 
108 
109 contract Bytes32 {
110     function _bytes32(string _input) internal pure returns(bytes32 result) {
111         assembly {
112             result := mload(add(_input, 32))
113         }
114     }
115 }
116 
117 // File: contracts/helpers/ReturnData.sol
118 
119 pragma solidity 0.4.23;
120 
121 
122 contract ReturnData {
123     function _returnReturnData(bool _success) internal pure {
124         assembly {
125             let returndatastart := 0
126             returndatacopy(returndatastart, 0, returndatasize)
127             switch _success case 0 { revert(returndatastart, returndatasize) }
128                 default { return(returndatastart, returndatasize) }
129         }
130     }
131 
132     function _assemblyCall(address _destination, uint _value, bytes _data)
133     internal returns(bool success) {
134         assembly {
135             success := call(gas, _destination, _value, add(_data, 32), mload(_data), 0, 0)
136         }
137     }
138 }
139 
140 // File: contracts/Asset.sol
141 
142 pragma solidity 0.4.23;
143 
144 
145 
146 
147 
148 
149 /**
150  * @title EToken2 Asset implementation contract.
151  *
152  * Basic asset implementation contract, without any additional logic.
153  * Every other asset implementation contracts should derive from this one.
154  * Receives calls from the proxy, and calls back immediately without arguments modification.
155  *
156  * Note: all the non constant functions return false instead of throwing in case if state change
157  * didn't happen yet.
158  */
159 contract Asset is AssetInterface, Bytes32, ReturnData {
160     // Assigned asset proxy contract, immutable.
161     AssetProxyInterface public proxy;
162 
163     /**
164      * Only assigned proxy is allowed to call.
165      */
166     modifier onlyProxy() {
167         if (proxy == msg.sender) {
168             _;
169         }
170     }
171 
172     /**
173      * Sets asset proxy address.
174      *
175      * Can be set only once.
176      *
177      * @param _proxy asset proxy contract address.
178      *
179      * @return success.
180      * @dev function is final, and must not be overridden.
181      */
182     function init(AssetProxyInterface _proxy) public returns(bool) {
183         if (address(proxy) != 0x0) {
184             return false;
185         }
186         proxy = _proxy;
187         return true;
188     }
189 
190     /**
191      * Passes execution into virtual function.
192      *
193      * Can only be called by assigned asset proxy.
194      *
195      * @return success.
196      * @dev function is final, and must not be overridden.
197      */
198     function _performTransferWithReference(
199         address _to,
200         uint _value,
201         string _reference,
202         address _sender)
203     public onlyProxy() returns(bool) {
204         if (isICAP(_to)) {
205             return _transferToICAPWithReference(
206                 bytes32(_to) << 96, _value, _reference, _sender);
207         }
208         return _transferWithReference(_to, _value, _reference, _sender);
209     }
210 
211     /**
212      * Calls back without modifications.
213      *
214      * @return success.
215      * @dev function is virtual, and meant to be overridden.
216      */
217     function _transferWithReference(
218         address _to,
219         uint _value,
220         string _reference,
221         address _sender)
222     internal returns(bool) {
223         return proxy._forwardTransferFromWithReference(
224             _sender, _to, _value, _reference, _sender);
225     }
226 
227     /**
228      * Passes execution into virtual function.
229      *
230      * Can only be called by assigned asset proxy.
231      *
232      * @return success.
233      * @dev function is final, and must not be overridden.
234      */
235     function _performTransferToICAPWithReference(
236         bytes32 _icap,
237         uint _value,
238         string _reference,
239         address _sender)
240     public onlyProxy() returns(bool) {
241         return _transferToICAPWithReference(_icap, _value, _reference, _sender);
242     }
243 
244     /**
245      * Calls back without modifications.
246      *
247      * @return success.
248      * @dev function is virtual, and meant to be overridden.
249      */
250     function _transferToICAPWithReference(
251         bytes32 _icap,
252         uint _value,
253         string _reference,
254         address _sender)
255     internal returns(bool) {
256         return proxy._forwardTransferFromToICAPWithReference(
257             _sender, _icap, _value, _reference, _sender);
258     }
259 
260     /**
261      * Passes execution into virtual function.
262      *
263      * Can only be called by assigned asset proxy.
264      *
265      * @return success.
266      * @dev function is final, and must not be overridden.
267      */
268     function _performTransferFromWithReference(
269         address _from,
270         address _to,
271         uint _value,
272         string _reference,
273         address _sender)
274     public onlyProxy() returns(bool) {
275         if (isICAP(_to)) {
276             return _transferFromToICAPWithReference(
277                 _from, bytes32(_to) << 96, _value, _reference, _sender);
278         }
279         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
280     }
281 
282     /**
283      * Calls back without modifications.
284      *
285      * @return success.
286      * @dev function is virtual, and meant to be overridden.
287      */
288     function _transferFromWithReference(
289         address _from,
290         address _to,
291         uint _value,
292         string _reference,
293         address _sender)
294     internal returns(bool) {
295         return proxy._forwardTransferFromWithReference(
296             _from, _to, _value, _reference, _sender);
297     }
298 
299     /**
300      * Passes execution into virtual function.
301      *
302      * Can only be called by assigned asset proxy.
303      *
304      * @return success.
305      * @dev function is final, and must not be overridden.
306      */
307     function _performTransferFromToICAPWithReference(
308         address _from,
309         bytes32 _icap,
310         uint _value,
311         string _reference,
312         address _sender)
313     public onlyProxy() returns(bool) {
314         return _transferFromToICAPWithReference(
315             _from, _icap, _value, _reference, _sender);
316     }
317 
318     /**
319      * Calls back without modifications.
320      *
321      * @return success.
322      * @dev function is virtual, and meant to be overridden.
323      */
324     function _transferFromToICAPWithReference(
325         address _from,
326         bytes32 _icap,
327         uint _value,
328         string _reference,
329         address _sender)
330     internal returns(bool) {
331         return proxy._forwardTransferFromToICAPWithReference(
332             _from, _icap, _value, _reference, _sender);
333     }
334 
335     /**
336      * Passes execution into virtual function.
337      *
338      * Can only be called by assigned asset proxy.
339      *
340      * @return success.
341      * @dev function is final, and must not be overridden.
342      */
343     function _performApprove(address _spender, uint _value, address _sender)
344     public onlyProxy() returns(bool) {
345         return _approve(_spender, _value, _sender);
346     }
347 
348     /**
349      * Calls back without modifications.
350      *
351      * @return success.
352      * @dev function is virtual, and meant to be overridden.
353      */
354     function _approve(address _spender, uint _value, address _sender) 
355     internal returns(bool) {
356         return proxy._forwardApprove(_spender, _value, _sender);
357     }
358 
359     /**
360      * Passes execution into virtual function.
361      *
362      * Can only be called by assigned asset proxy.
363      *
364      * @return bytes32 result.
365      * @dev function is final, and must not be overridden.
366      */
367     function _performGeneric(bytes _data, address _sender)
368     public payable onlyProxy() {
369         _generic(_data, msg.value, _sender);
370     }
371 
372     modifier onlyMe() {
373         if (this == msg.sender) {
374             _;
375         }
376     }
377 
378     // Most probably the following should never be redefined in child contracts.
379     address public genericSender;
380 
381     function _generic(bytes _data, uint _value, address _msgSender) internal {
382         // Restrict reentrancy.
383         require(genericSender == 0x0);
384         genericSender = _msgSender;
385         bool success = _assemblyCall(address(this), _value, _data);
386         delete genericSender;
387         _returnReturnData(success);
388     }
389 
390     // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.
391     function _sender() internal view returns(address) {
392         return this == msg.sender ? genericSender : msg.sender;
393     }
394 
395     // Interface functions to allow specifying ICAP addresses as strings.
396     function transferToICAP(string _icap, uint _value) public returns(bool) {
397         return transferToICAPWithReference(_icap, _value, '');
398     }
399 
400     function transferToICAPWithReference(string _icap, uint _value, string _reference)
401     public returns(bool) {
402         return _transferToICAPWithReference(
403             _bytes32(_icap), _value, _reference, _sender());
404     }
405 
406     function transferFromToICAP(address _from, string _icap, uint _value)
407     public returns(bool) {
408         return transferFromToICAPWithReference(_from, _icap, _value, '');
409     }
410 
411     function transferFromToICAPWithReference(
412         address _from,
413         string _icap,
414         uint _value,
415         string _reference)
416     public returns(bool) {
417         return _transferFromToICAPWithReference(
418             _from, _bytes32(_icap), _value, _reference, _sender());
419     }
420 
421     function isICAP(address _address) public pure returns(bool) {
422         bytes32 a = bytes32(_address) << 96;
423         if (a[0] != 'X' || a[1] != 'E') {
424             return false;
425         }
426         if (a[2] < 48 || a[2] > 57 || a[3] < 48 || a[3] > 57) {
427             return false;
428         }
429         for (uint i = 4; i < 20; i++) {
430             uint char = uint(a[i]);
431             if (char < 48 || char > 90 || (char > 57 && char < 65)) {
432                 return false;
433             }
434         }
435         return true;
436     }
437 }