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
30 contract AssetProxyInterface is ERC20Interface {
31     function _forwardApprove(address _spender, uint _value, address _sender) public returns(bool);
32     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns(bool);
33     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public returns(bool);
34 }
35 
36 contract Bytes32 {
37     function _bytes32(string _input) internal pure returns(bytes32 result) {
38         assembly {
39             result := mload(add(_input, 32))
40         }
41     }
42 }
43 
44 contract ReturnData {
45     function _returnReturnData(bool _success) internal pure {
46         assembly {
47             let returndatastart := 0
48             returndatacopy(returndatastart, 0, returndatasize)
49             switch _success case 0 { revert(returndatastart, returndatasize) } default { return(returndatastart, returndatasize) }
50         }
51     }
52 
53     function _assemblyCall(address _destination, uint _value, bytes _data) internal returns(bool success) {
54         assembly {
55             success := call(gas, _destination, _value, add(_data, 32), mload(_data), 0, 0)
56         }
57     }
58 }
59 
60 /**
61  * @title EToken2 Asset implementation contract.
62  *
63  * Basic asset implementation contract, without any additional logic.
64  * Every other asset implementation contracts should derive from this one.
65  * Receives calls from the proxy, and calls back immediately without arguments modification.
66  *
67  * Note: all the non constant functions return false instead of throwing in case if state change
68  * didn't happen yet.
69  */
70 contract Asset is AssetInterface, Bytes32, ReturnData {
71     // Assigned asset proxy contract, immutable.
72     AssetProxyInterface public proxy;
73 
74     /**
75      * Only assigned proxy is allowed to call.
76      */
77     modifier onlyProxy() {
78         if (proxy == msg.sender) {
79             _;
80         }
81     }
82 
83     /**
84      * Sets asset proxy address.
85      *
86      * Can be set only once.
87      *
88      * @param _proxy asset proxy contract address.
89      *
90      * @return success.
91      * @dev function is final, and must not be overridden.
92      */
93     function init(AssetProxyInterface _proxy) public returns(bool) {
94         if (address(proxy) != 0x0) {
95             return false;
96         }
97         proxy = _proxy;
98         return true;
99     }
100 
101     /**
102      * Passes execution into virtual function.
103      *
104      * Can only be called by assigned asset proxy.
105      *
106      * @return success.
107      * @dev function is final, and must not be overridden.
108      */
109     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) public onlyProxy() returns(bool) {
110         if (isICAP(_to)) {
111             return _transferToICAPWithReference(bytes32(_to) << 96, _value, _reference, _sender);
112         }
113         return _transferWithReference(_to, _value, _reference, _sender);
114     }
115 
116     /**
117      * Calls back without modifications.
118      *
119      * @return success.
120      * @dev function is virtual, and meant to be overridden.
121      */
122     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {
123         return proxy._forwardTransferFromWithReference(_sender, _to, _value, _reference, _sender);
124     }
125 
126     /**
127      * Passes execution into virtual function.
128      *
129      * Can only be called by assigned asset proxy.
130      *
131      * @return success.
132      * @dev function is final, and must not be overridden.
133      */
134     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) public onlyProxy() returns(bool) {
135         return _transferToICAPWithReference(_icap, _value, _reference, _sender);
136     }
137 
138     /**
139      * Calls back without modifications.
140      *
141      * @return success.
142      * @dev function is virtual, and meant to be overridden.
143      */
144     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
145         return proxy._forwardTransferFromToICAPWithReference(_sender, _icap, _value, _reference, _sender);
146     }
147 
148     /**
149      * Passes execution into virtual function.
150      *
151      * Can only be called by assigned asset proxy.
152      *
153      * @return success.
154      * @dev function is final, and must not be overridden.
155      */
156     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyProxy() returns(bool) {
157         if (isICAP(_to)) {
158             return _transferFromToICAPWithReference(_from, bytes32(_to) << 96, _value, _reference, _sender);
159         }
160         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
161     }
162 
163     /**
164      * Calls back without modifications.
165      *
166      * @return success.
167      * @dev function is virtual, and meant to be overridden.
168      */
169     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {
170         return proxy._forwardTransferFromWithReference(_from, _to, _value, _reference, _sender);
171     }
172 
173     /**
174      * Passes execution into virtual function.
175      *
176      * Can only be called by assigned asset proxy.
177      *
178      * @return success.
179      * @dev function is final, and must not be overridden.
180      */
181     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public onlyProxy() returns(bool) {
182         return _transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
183     }
184 
185     /**
186      * Calls back without modifications.
187      *
188      * @return success.
189      * @dev function is virtual, and meant to be overridden.
190      */
191     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
192         return proxy._forwardTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
193     }
194 
195     /**
196      * Passes execution into virtual function.
197      *
198      * Can only be called by assigned asset proxy.
199      *
200      * @return success.
201      * @dev function is final, and must not be overridden.
202      */
203     function _performApprove(address _spender, uint _value, address _sender) public onlyProxy() returns(bool) {
204         return _approve(_spender, _value, _sender);
205     }
206 
207     /**
208      * Calls back without modifications.
209      *
210      * @return success.
211      * @dev function is virtual, and meant to be overridden.
212      */
213     function _approve(address _spender, uint _value, address _sender) internal returns(bool) {
214         return proxy._forwardApprove(_spender, _value, _sender);
215     }
216 
217     /**
218      * Passes execution into virtual function.
219      *
220      * Can only be called by assigned asset proxy.
221      *
222      * @return bytes32 result.
223      * @dev function is final, and must not be overridden.
224      */
225     function _performGeneric(bytes _data, address _sender) public payable onlyProxy() {
226         _generic(_data, msg.value, _sender);
227     }
228 
229     modifier onlyMe() {
230         if (this == msg.sender) {
231             _;
232         }
233     }
234 
235     // Most probably the following should never be redefined in child contracts.
236     address public genericSender;
237     function _generic(bytes _data, uint _value, address _msgSender) internal {
238         // Restrict reentrancy.
239         require(genericSender == 0x0);
240         genericSender = _msgSender;
241         bool success = _assemblyCall(address(this), _value, _data);
242         delete genericSender;
243         _returnReturnData(success);
244     }
245 
246     // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.
247     function _sender() internal view returns(address) {
248         return this == msg.sender ? genericSender : msg.sender;
249     }
250 
251     // Interface functions to allow specifying ICAP addresses as strings.
252     function transferToICAP(string _icap, uint _value) public returns(bool) {
253         return transferToICAPWithReference(_icap, _value, '');
254     }
255 
256     function transferToICAPWithReference(string _icap, uint _value, string _reference) public returns(bool) {
257         return _transferToICAPWithReference(_bytes32(_icap), _value, _reference, _sender());
258     }
259 
260     function transferFromToICAP(address _from, string _icap, uint _value) public returns(bool) {
261         return transferFromToICAPWithReference(_from, _icap, _value, '');
262     }
263 
264     function transferFromToICAPWithReference(address _from, string _icap, uint _value, string _reference) public returns(bool) {
265         return _transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference, _sender());
266     }
267 
268     function isICAP(address _address) public pure returns(bool) {
269         bytes32 a = bytes32(_address) << 96;
270         if (a[0] != 'X' || a[1] != 'E') {
271             return false;
272         }
273         if (a[2] < 48 || a[2] > 57 || a[3] < 48 || a[3] > 57) {
274             return false;
275         }
276         for (uint i = 4; i < 20; i++) {
277             uint char = uint(a[i]);
278             if (char < 48 || char > 90 || (char > 57 && char < 65)) {
279                 return false;
280             }
281         }
282         return true;
283     }
284 }
285 
286 /**
287  * @title EToken2 Asset implementation contract that reverts on insufficient balance/allowance.
288  */
289 contract AssetWithRevert is Asset {
290     modifier validateBalance(address _from, uint _value) {
291         require(proxy.balanceOf(_from) >= _value, 'Insufficient balance');
292         _;
293     }
294 
295     modifier validateAllowance(address _from, address _spender, uint _value) {
296         require(proxy.allowance(_from, _spender) >= _value, 'Insufficient allowance');
297         _;
298     }
299 
300     function _transferWithReference(address _to, uint _value, string _reference, address _sender)
301         internal
302         validateBalance(_sender, _value)
303         returns(bool)
304     {
305         return super._transferWithReference(_to, _value, _reference, _sender);
306     }
307 
308     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender)
309         internal
310         validateBalance(_sender, _value)
311         returns(bool)
312     {
313         return super._transferToICAPWithReference(_icap, _value, _reference, _sender);
314     }
315 
316     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender)
317         internal
318         validateBalance(_from, _value)
319         validateAllowance(_from, _sender, _value)
320         returns(bool)
321     {
322         return super._transferFromWithReference(_from, _to, _value, _reference, _sender);
323     }
324 
325     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender)
326         internal
327         validateBalance(_from, _value)
328         validateAllowance(_from, _sender, _value)
329         returns(bool)
330     {
331         return super._transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
332     }
333 }