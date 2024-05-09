1 pragma solidity 0.4.11;
2 
3 contract AssetInterface {
4     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
5     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
6     function _performApprove(address _spender, uint _value, address _sender) returns(bool);    
7     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
8     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);
9     function _performGeneric(bytes, address) payable returns(bytes32){
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
21 /**
22  * @title EToken2 Asset implementation contract.
23  *
24  * Basic asset implementation contract, without any additional logic.
25  * Every other asset implementation contracts should derive from this one.
26  * Receives calls from the proxy, and calls back immediatly without arguments modification.
27  *
28  * Note: all the non constant functions return false instead of throwing in case if state change
29  * didn't happen yet.
30  */
31 contract Asset is AssetInterface {
32     // Assigned asset proxy contract, immutable.
33     AssetProxy public proxy;
34 
35     /**
36      * Only assigned proxy is allowed to call.
37      */
38     modifier onlyProxy() {
39         if (proxy == msg.sender) {
40             _;
41         }
42     }
43 
44     /**
45      * Sets asset proxy address.
46      *
47      * Can be set only once.
48      *
49      * @param _proxy asset proxy contract address.
50      *
51      * @return success.
52      * @dev function is final, and must not be overridden.
53      */
54     function init(AssetProxy _proxy) returns(bool) {
55         if (address(proxy) != 0x0) {
56             return false;
57         }
58         proxy = _proxy;
59         return true;
60     }
61 
62     /**
63      * Passes execution into virtual function.
64      *
65      * Can only be called by assigned asset proxy.
66      *
67      * @return success.
68      * @dev function is final, and must not be overridden.
69      */
70     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
71         return _transferWithReference(_to, _value, _reference, _sender);
72     }
73 
74     /**
75      * Calls back without modifications.
76      *
77      * @return success.
78      * @dev function is virtual, and meant to be overridden.
79      */
80     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {
81         return proxy._forwardTransferFromWithReference(_sender, _to, _value, _reference, _sender);
82     }
83 
84     /**
85      * Passes execution into virtual function.
86      *
87      * Can only be called by assigned asset proxy.
88      *
89      * @return success.
90      * @dev function is final, and must not be overridden.
91      */
92     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
93         return _transferToICAPWithReference(_icap, _value, _reference, _sender);
94     }
95 
96     /**
97      * Calls back without modifications.
98      *
99      * @return success.
100      * @dev function is virtual, and meant to be overridden.
101      */
102     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
103         return proxy._forwardTransferFromToICAPWithReference(_sender, _icap, _value, _reference, _sender);
104     }
105 
106     /**
107      * Passes execution into virtual function.
108      *
109      * Can only be called by assigned asset proxy.
110      *
111      * @return success.
112      * @dev function is final, and must not be overridden.
113      */
114     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
115         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
116     }
117 
118     /**
119      * Calls back without modifications.
120      *
121      * @return success.
122      * @dev function is virtual, and meant to be overridden.
123      */
124     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {
125         return proxy._forwardTransferFromWithReference(_from, _to, _value, _reference, _sender);
126     }
127 
128     /**
129      * Passes execution into virtual function.
130      *
131      * Can only be called by assigned asset proxy.
132      *
133      * @return success.
134      * @dev function is final, and must not be overridden.
135      */
136     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
137         return _transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
138     }
139 
140     /**
141      * Calls back without modifications.
142      *
143      * @return success.
144      * @dev function is virtual, and meant to be overridden.
145      */
146     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
147         return proxy._forwardTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
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
158     function _performApprove(address _spender, uint _value, address _sender) onlyProxy() returns(bool) {
159         return _approve(_spender, _value, _sender);
160     }
161 
162     /**
163      * Calls back without modifications.
164      *
165      * @return success.
166      * @dev function is virtual, and meant to be overridden.
167      */
168     function _approve(address _spender, uint _value, address _sender) internal returns(bool) {
169         return proxy._forwardApprove(_spender, _value, _sender);
170     }
171 
172     /**
173      * Passes execution into virtual function.
174      *
175      * Can only be called by assigned asset proxy.
176      *
177      * @return bytes32 result.
178      * @dev function is final, and must not be overridden.
179      */
180     function _performGeneric(bytes _data, address _sender) payable onlyProxy() returns(bytes32) {
181         return _generic(_data, _sender);
182     }
183 
184     modifier onlyMe() {
185         if (this == msg.sender) {
186             _;
187         }
188     }
189 
190     // Most probably the following should never be redefined in child contracts.
191     address genericSender;
192     function _generic(bytes _data, address _sender) internal returns(bytes32) {
193         // Restrict reentrancy.
194         if (genericSender != 0x0) {
195             throw;
196         }
197         genericSender = _sender;
198         bytes32 result = _callReturn(this, _data, msg.value);
199         delete genericSender;
200         return result;
201     }
202 
203     function _callReturn(address _target, bytes _data, uint _value) internal returns(bytes32 result) {
204         bool success;
205         assembly {
206             success := call(div(mul(gas, 63), 64), _target, _value, add(_data, 32), mload(_data), 0, 32)
207             result := mload(0)
208         }
209         if (!success) {
210             throw;
211         }
212     }
213 
214     // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.
215     function _sender() constant internal returns(address) {
216         return this == msg.sender ? genericSender : msg.sender;
217     }
218 }