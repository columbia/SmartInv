1 // This software is a subject to Ambisafe License Agreement.
2 // No use or distribution is allowed without written permission from Ambisafe.
3 // https://www.ambisafe.co/terms-of-use/
4 
5 pragma solidity 0.4.15;
6 
7 contract AssetInterface {
8     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
9     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
10     function _performApprove(address _spender, uint _value, address _sender) returns(bool);    
11     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
12     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
13     function _performGeneric(bytes, address) payable {
14         revert();
15     }
16 }
17 
18 contract AssetProxy {
19     function _forwardApprove(address _spender, uint _value, address _sender) returns(bool);
20     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
21     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
22     function balanceOf(address _owner) constant returns(uint);
23 }
24 
25 contract Bytes32 {
26     function _bytes32(string _input) internal constant returns(bytes32 result) {
27         assembly {
28             result := mload(add(_input, 32))
29         }
30     }
31 }
32 
33 contract ReturnData {
34     function _returnReturnData(bool _success) internal {
35         assembly {
36             let returndatastart := msize()
37             mstore(0x40, add(returndatastart, returndatasize))
38             returndatacopy(returndatastart, 0, returndatasize)
39             switch _success case 0 { revert(returndatastart, returndatasize) } default { return(returndatastart, returndatasize) }
40         }
41     }
42 
43     function _assemblyCall(address _destination, uint _value, bytes _data) internal returns(bool success) {
44         assembly {
45             success := call(div(mul(gas, 63), 64), _destination, _value, add(_data, 32), mload(_data), 0, 0)
46         }
47     }
48 }
49 
50 /**
51  * @title EToken2 Asset implementation contract.
52  *
53  * Basic asset implementation contract, without any additional logic.
54  * Every other asset implementation contracts should derive from this one.
55  * Receives calls from the proxy, and calls back immediatly without arguments modification.
56  *
57  * Note: all the non constant functions return false instead of throwing in case if state change
58  * didn't happen yet.
59  */
60 contract Asset is AssetInterface, Bytes32, ReturnData {
61     // Assigned asset proxy contract, immutable.
62     AssetProxy public proxy;
63 
64     /**
65      * Only assigned proxy is allowed to call.
66      */
67     modifier onlyProxy() {
68         if (proxy == msg.sender) {
69             _;
70         }
71     }
72 
73     /**
74      * Sets asset proxy address.
75      *
76      * Can be set only once.
77      *
78      * @param _proxy asset proxy contract address.
79      *
80      * @return success.
81      * @dev function is final, and must not be overridden.
82      */
83     function init(AssetProxy _proxy) returns(bool) {
84         if (address(proxy) != 0x0) {
85             return false;
86         }
87         proxy = _proxy;
88         return true;
89     }
90 
91     /**
92      * Passes execution into virtual function.
93      *
94      * Can only be called by assigned asset proxy.
95      *
96      * @return success.
97      * @dev function is final, and must not be overridden.
98      */
99     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
100         if (isICAP(_to)) {
101             return _transferToICAPWithReference(bytes32(_to) << 96, _value, _reference, _sender);
102         }
103         return _transferWithReference(_to, _value, _reference, _sender);
104     }
105 
106     /**
107      * Calls back without modifications.
108      *
109      * @return success.
110      * @dev function is virtual, and meant to be overridden.
111      */
112     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {
113         return proxy._forwardTransferFromWithReference(_sender, _to, _value, _reference, _sender);
114     }
115 
116     /**
117      * Passes execution into virtual function.
118      *
119      * Can only be called by assigned asset proxy.
120      *
121      * @return success.
122      * @dev function is final, and must not be overridden.
123      */
124     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
125         return _transferToICAPWithReference(_icap, _value, _reference, _sender);
126     }
127 
128     /**
129      * Calls back without modifications.
130      *
131      * @return success.
132      * @dev function is virtual, and meant to be overridden.
133      */
134     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
135         return proxy._forwardTransferFromToICAPWithReference(_sender, _icap, _value, _reference, _sender);
136     }
137 
138     /**
139      * Passes execution into virtual function.
140      *
141      * Can only be called by assigned asset proxy.
142      *
143      * @return success.
144      * @dev function is final, and must not be overridden.
145      */
146     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
147         if (isICAP(_to)) {
148             return _transferFromToICAPWithReference(_from, bytes32(_to) << 96, _value, _reference, _sender);
149         }
150         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
151     }
152 
153     /**
154      * Calls back without modifications.
155      *
156      * @return success.
157      * @dev function is virtual, and meant to be overridden.
158      */
159     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {
160         return proxy._forwardTransferFromWithReference(_from, _to, _value, _reference, _sender);
161     }
162 
163     /**
164      * Passes execution into virtual function.
165      *
166      * Can only be called by assigned asset proxy.
167      *
168      * @return success.
169      * @dev function is final, and must not be overridden.
170      */
171     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
172         return _transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
173     }
174 
175     /**
176      * Calls back without modifications.
177      *
178      * @return success.
179      * @dev function is virtual, and meant to be overridden.
180      */
181     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
182         return proxy._forwardTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
183     }
184 
185     /**
186      * Passes execution into virtual function.
187      *
188      * Can only be called by assigned asset proxy.
189      *
190      * @return success.
191      * @dev function is final, and must not be overridden.
192      */
193     function _performApprove(address _spender, uint _value, address _sender) onlyProxy() returns(bool) {
194         return _approve(_spender, _value, _sender);
195     }
196 
197     /**
198      * Calls back without modifications.
199      *
200      * @return success.
201      * @dev function is virtual, and meant to be overridden.
202      */
203     function _approve(address _spender, uint _value, address _sender) internal returns(bool) {
204         return proxy._forwardApprove(_spender, _value, _sender);
205     }
206 
207     /**
208      * Passes execution into virtual function.
209      *
210      * Can only be called by assigned asset proxy.
211      *
212      * @return bytes32 result.
213      * @dev function is final, and must not be overridden.
214      */
215     function _performGeneric(bytes _data, address _sender) payable onlyProxy() {
216         _generic(_data, msg.value, _sender);
217     }
218 
219     modifier onlyMe() {
220         if (this == msg.sender) {
221             _;
222         }
223     }
224 
225     // Most probably the following should never be redefined in child contracts.
226     address genericSender;
227     function _generic(bytes _data, uint _value, address _msgSender) internal {
228         // Restrict reentrancy.
229         require(genericSender == 0x0);
230         genericSender = _msgSender;
231         bool success = _assemblyCall(address(this), _value, _data);
232         delete genericSender;
233         _returnReturnData(success);
234     }
235 
236     // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.
237     function _sender() constant internal returns(address) {
238         return this == msg.sender ? genericSender : msg.sender;
239     }
240 
241     // Interface functions to allow specifying ICAP addresses as strings.
242     function transferToICAP(string _icap, uint _value) returns(bool) {
243         return transferToICAPWithReference(_icap, _value, '');
244     }
245 
246     function transferToICAPWithReference(string _icap, uint _value, string _reference) returns(bool) {
247         return _transferToICAPWithReference(_bytes32(_icap), _value, _reference, _sender());
248     }
249 
250     function transferFromToICAP(address _from, string _icap, uint _value) returns(bool) {
251         return transferFromToICAPWithReference(_from, _icap, _value, '');
252     }
253 
254     function transferFromToICAPWithReference(address _from, string _icap, uint _value, string _reference) returns(bool) {
255         return _transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference, _sender());
256     }
257 
258     function isICAP(address _address) constant returns(bool) {
259         bytes32 a = bytes32(_address) << 96;
260         if (a[0] != 'X' || a[1] != 'E') {
261             return false;
262         }
263         if (a[2] < 48 || a[2] > 57 || a[3] < 48 || a[3] > 57) {
264             return false;
265         }
266         for (uint i = 4; i < 20; i++) {
267             uint char = uint(a[i]);
268             if (char < 48 || char > 90 || (char > 57 && char < 65)) {
269                 return false;
270             }
271         }
272         return true;
273     }
274 }