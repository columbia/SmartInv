1 // This software is a subject to Ambisafe License Agreement.
2 // No use or distribution is allowed without written permission from Ambisafe.
3 // https://ambisafe.com/terms.pdf
4 
5 contract Ambi {
6     function getNodeAddress(bytes32 _nodeName) constant returns(address);
7     function hasRelation(bytes32 _nodeName, bytes32 _relation, address _to) constant returns(bool);
8     function addNode(bytes32 _nodeName, address _nodeAddress) constant returns(bool);
9 }
10 
11 contract AmbiEnabled {
12     Ambi public ambiC;
13     bool public isImmortal;
14     bytes32 public name;
15 
16     modifier checkAccess(bytes32 _role) {
17         if(address(ambiC) != 0x0 && ambiC.hasRelation(name, _role, msg.sender)){
18             _
19         }
20     }
21     
22     function getAddress(bytes32 _name) constant returns (address) {
23         return ambiC.getNodeAddress(_name);
24     }
25 
26     function setAmbiAddress(address _ambi, bytes32 _name) returns (bool){
27         if(address(ambiC) != 0x0){
28             return false;
29         }
30         Ambi ambiContract = Ambi(_ambi);
31         if(ambiContract.getNodeAddress(_name)!=address(this)) {
32             if (!ambiContract.addNode(_name, address(this))){
33                 return false;
34             }
35         }
36         name = _name;
37         ambiC = ambiContract;
38         return true;
39     }
40 
41     function immortality() checkAccess("owner") returns(bool) {
42         isImmortal = true;
43         return true;
44     }
45 
46     function remove() checkAccess("owner") returns(bool) {
47         if (isImmortal) {
48             return false;
49         }
50         selfdestruct(msg.sender);
51         return true;
52     }
53 }
54 
55 library StackDepthLib {
56     // This will probably work with a value of 390 but no need to cut it
57     // that close in the case that the optimizer changes slightly or
58     // something causing that number to rise slightly.
59     uint constant GAS_PER_DEPTH = 400;
60 
61     function checkDepth(address self, uint n) constant returns(bool) {
62         if (n == 0) return true;
63         return self.call.gas(GAS_PER_DEPTH * n)(0x21835af6, n - 1);
64     }
65 
66     function __dig(uint n) constant {
67         if (n == 0) return;
68         if (!address(this).delegatecall(0x21835af6, n - 1)) throw;
69     }
70 }
71 
72 contract Safe {
73     // Should always be placed as first modifier!
74     modifier noValue {
75         if (msg.value > 0) {
76             // Internal Out Of Gas/Throw: revert this transaction too;
77             // Call Stack Depth Limit reached: revert this transaction too;
78             // Recursive Call: safe, no any changes applied yet, we are inside of modifier.
79             _safeSend(msg.sender, msg.value);
80         }
81         _
82     }
83 
84     modifier onlyHuman {
85         if (_isHuman()) {
86             _
87         }
88     }
89 
90     modifier noCallback {
91         if (!isCall) {
92             _
93         }
94     }
95 
96     modifier immutable(address _address) {
97         if (_address == 0) {
98             _
99         }
100     }
101 
102     address stackDepthLib;
103     function setupStackDepthLib(address _stackDepthLib) immutable(address(stackDepthLib)) returns(bool) {
104         stackDepthLib = _stackDepthLib;
105         return true;
106     }
107 
108     modifier requireStackDepth(uint16 _depth) {
109         if (stackDepthLib == 0x0) {
110             throw;
111         }
112         if (_depth > 1023) {
113             throw;
114         }
115         if (!stackDepthLib.delegatecall(0x32921690, stackDepthLib, _depth)) {
116             throw;
117         }
118         _
119     }
120 
121     // Must not be used inside the functions that have noValue() modifier!
122     function _safeFalse() internal noValue() returns(bool) {
123         return false;
124     }
125 
126     function _safeSend(address _to, uint _value) internal {
127         if (!_unsafeSend(_to, _value)) {
128             throw;
129         }
130     }
131 
132     function _unsafeSend(address _to, uint _value) internal returns(bool) {
133         return _to.call.value(_value)();
134     }
135 
136     function _isContract() constant internal returns(bool) {
137         return msg.sender != tx.origin;
138     }
139 
140     function _isHuman() constant internal returns(bool) {
141         return !_isContract();
142     }
143 
144     bool private isCall = false;
145     function _setupNoCallback() internal {
146         isCall = true;
147     }
148 
149     function _finishNoCallback() internal {
150         isCall = false;
151     }
152 }
153 
154 /**
155  * @title Events History universal contract.
156  *
157  * Contract serves as an Events storage and version history for a particular contract type.
158  * Events appear on this contract address but their definitions provided by other contracts/libraries.
159  * Version info is provided for historical and informational purposes.
160  *
161  * Note: all the non constant functions return false instead of throwing in case if state change
162  * didn't happen yet.
163  */
164 contract EventsHistory is AmbiEnabled, Safe {
165     // Event emitter signature to address with Event definiton mapping.
166     mapping(bytes4 => address) public emitters;
167 
168     // Calling contract address to version mapping.
169     mapping(address => uint) public versions;
170 
171     // Version to info mapping.
172     mapping(uint => VersionInfo) public versionInfo;
173 
174     // Latest verion number.
175     uint public latestVersion;
176 
177     struct VersionInfo {
178         uint block;        // Block number in which version has been introduced.
179         address by;        // Contract owner address who added version.
180         address caller;    // Address of this version calling contract.
181         string name;       // Version name, informative.
182         string changelog;  // Version changelog, informative.
183     }
184 
185     /**
186      * Assign emitter address to a specified emit function signature.
187      *
188      * Can be set only once for each signature, and only by contract owner.
189      * Caller contract should be sure that emitter for a particular signature will never change.
190      *
191      * @param _eventSignature signature of the event emitting function.
192      * @param _emitter address with Event definition.
193      *
194      * @return success.
195      */
196     function addEmitter(bytes4 _eventSignature, address _emitter) noValue() checkAccess("admin") returns(bool) {
197         if (emitters[_eventSignature] != 0x0) {
198             return false;
199         }
200         emitters[_eventSignature] = _emitter;
201         return true;
202     }
203 
204     /**
205      * Introduce new caller contract version specifing version information.
206      *
207      * Can be set only once for each caller, and only by contract owner.
208      * Name and changelog should not be empty.
209      *
210      * @param _caller address of the new caller.
211      * @param _name version name.
212      * @param _changelog version changelog.
213      *
214      * @return success.
215      */
216     function addVersion(address _caller, string _name, string _changelog) noValue() checkAccess("admin") returns(bool) {
217         if (versions[_caller] != 0) {
218             return false;
219         }
220         if (bytes(_name).length == 0) {
221             return false;
222         }
223         if (bytes(_changelog).length == 0) {
224             return false;
225         }
226         uint version = ++latestVersion;
227         versions[_caller] = version;
228         versionInfo[version] = VersionInfo(block.number, msg.sender, _caller, _name, _changelog);
229         return true;
230     }
231 
232     /**
233      * Event emitting fallback.
234      *
235      * Can be and only called caller with assigned version.
236      * Resolves msg.sig to an emitter address, and calls it to emit an event.
237      *
238      * Throws if emit function signature is not registered, or call failed.
239      */
240     function () noValue() {
241         if (versions[msg.sender] == 0) {
242             return;
243         }
244         // Internal Out Of Gas/Throw: revert this transaction too;
245         // Call Stack Depth Limit reached: revert this transaction too;
246         // Recursive Call: safe, all changes already made.
247         if (!emitters[msg.sig].delegatecall(msg.data)) {
248             throw;
249         }
250     }
251 }