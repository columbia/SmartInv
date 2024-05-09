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
50 
51 /**
52  * @title EToken2 Asset implementation contract.
53  *
54  * Basic asset implementation contract, without any additional logic.
55  * Every other asset implementation contracts should derive from this one.
56  * Receives calls from the proxy, and calls back immediatly without arguments modification.
57  *
58  * Note: all the non constant functions return false instead of throwing in case if state change
59  * didn't happen yet.
60  */
61 contract Asset is AssetInterface, Bytes32, ReturnData {
62     // Assigned asset proxy contract, immutable.
63     AssetProxy public proxy;
64 
65     /**
66      * Only assigned proxy is allowed to call.
67      */
68     modifier onlyProxy() {
69         if (proxy == msg.sender) {
70             _;
71         }
72     }
73 
74     /**
75      * Sets asset proxy address.
76      *
77      * Can be set only once.
78      *
79      * @param _proxy asset proxy contract address.
80      *
81      * @return success.
82      * @dev function is final, and must not be overridden.
83      */
84     function init(AssetProxy _proxy) returns(bool) {
85         if (address(proxy) != 0x0) {
86             return false;
87         }
88         proxy = _proxy;
89         return true;
90     }
91 
92     /**
93      * Passes execution into virtual function.
94      *
95      * Can only be called by assigned asset proxy.
96      *
97      * @return success.
98      * @dev function is final, and must not be overridden.
99      */
100     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
101         return _transferWithReference(_to, _value, _reference, _sender);
102     }
103 
104     /**
105      * Calls back without modifications.
106      *
107      * @return success.
108      * @dev function is virtual, and meant to be overridden.
109      */
110     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {
111         return proxy._forwardTransferFromWithReference(_sender, _to, _value, _reference, _sender);
112     }
113 
114     /**
115      * Passes execution into virtual function.
116      *
117      * Can only be called by assigned asset proxy.
118      *
119      * @return success.
120      * @dev function is final, and must not be overridden.
121      */
122     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
123         return _transferToICAPWithReference(_icap, _value, _reference, _sender);
124     }
125 
126     /**
127      * Calls back without modifications.
128      *
129      * @return success.
130      * @dev function is virtual, and meant to be overridden.
131      */
132     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
133         return proxy._forwardTransferFromToICAPWithReference(_sender, _icap, _value, _reference, _sender);
134     }
135 
136     /**
137      * Passes execution into virtual function.
138      *
139      * Can only be called by assigned asset proxy.
140      *
141      * @return success.
142      * @dev function is final, and must not be overridden.
143      */
144     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
145         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
146     }
147 
148     /**
149      * Calls back without modifications.
150      *
151      * @return success.
152      * @dev function is virtual, and meant to be overridden.
153      */
154     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {
155         return proxy._forwardTransferFromWithReference(_from, _to, _value, _reference, _sender);
156     }
157 
158     /**
159      * Passes execution into virtual function.
160      *
161      * Can only be called by assigned asset proxy.
162      *
163      * @return success.
164      * @dev function is final, and must not be overridden.
165      */
166     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
167         return _transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
168     }
169 
170     /**
171      * Calls back without modifications.
172      *
173      * @return success.
174      * @dev function is virtual, and meant to be overridden.
175      */
176     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
177         return proxy._forwardTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
178     }
179 
180     /**
181      * Passes execution into virtual function.
182      *
183      * Can only be called by assigned asset proxy.
184      *
185      * @return success.
186      * @dev function is final, and must not be overridden.
187      */
188     function _performApprove(address _spender, uint _value, address _sender) onlyProxy() returns(bool) {
189         return _approve(_spender, _value, _sender);
190     }
191 
192     /**
193      * Calls back without modifications.
194      *
195      * @return success.
196      * @dev function is virtual, and meant to be overridden.
197      */
198     function _approve(address _spender, uint _value, address _sender) internal returns(bool) {
199         return proxy._forwardApprove(_spender, _value, _sender);
200     }
201 
202     /**
203      * Passes execution into virtual function.
204      *
205      * Can only be called by assigned asset proxy.
206      *
207      * @return bytes32 result.
208      * @dev function is final, and must not be overridden.
209      */
210     function _performGeneric(bytes _data, address _sender) payable onlyProxy() {
211         _generic(_data, msg.value, _sender);
212     }
213 
214     modifier onlyMe() {
215         if (this == msg.sender) {
216             _;
217         }
218     }
219 
220     // Most probably the following should never be redefined in child contracts.
221     address genericSender;
222     function _generic(bytes _data, uint _value, address _msgSender) internal {
223         // Restrict reentrancy.
224         require(genericSender == 0x0);
225         genericSender = _msgSender;
226         bool success = _assemblyCall(address(this), _value, _data);
227         delete genericSender;
228         _returnReturnData(success);
229     }
230 
231     // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.
232     function _sender() constant internal returns(address) {
233         return this == msg.sender ? genericSender : msg.sender;
234     }
235 
236     // Interface functions to allow specifying ICAP addresses as strings.
237     function transferToICAP(string _icap, uint _value) returns(bool) {
238         return transferToICAPWithReference(_icap, _value, '');
239     }
240 
241     function transferToICAPWithReference(string _icap, uint _value, string _reference) returns(bool) {
242         return _transferToICAPWithReference(_bytes32(_icap), _value, _reference, _sender());
243     }
244 
245     function transferFromToICAP(address _from, string _icap, uint _value) returns(bool) {
246         return transferFromToICAPWithReference(_from, _icap, _value, '');
247     }
248 
249     function transferFromToICAPWithReference(address _from, string _icap, uint _value, string _reference) returns(bool) {
250         return _transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference, _sender());
251     }
252 }