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
154 contract RegistryICAP is AmbiEnabled, Safe {
155     function decodeIndirect(bytes _bban) constant returns(string, string, string) {
156         bytes memory asset = new bytes(3);
157         bytes memory institution = new bytes(4);
158         bytes memory client = new bytes(9);
159 
160         uint8 k = 0;
161 
162         for (uint8 i = 0; i < asset.length; i++) {
163             asset[i] = _bban[k++];
164         }
165         for (i = 0; i < institution.length; i++) {
166             institution[i] = _bban[k++];
167         }
168         for (i = 0; i < client.length; i++) {
169             client[i] = _bban[k++];
170         }
171         return (string(asset), string(institution), string(client));
172     }
173 
174     function parse(bytes32 _icap) constant returns(address, bytes32, bool) {
175         // Should start with XE.
176         if (_icap[0] != 88 || _icap[1] != 69) {
177             return (0, 0, false);
178         }
179         // Should have 12 zero bytes at the end.
180         for (uint8 j = 20; j < 32; j++) {
181             if (_icap[j] != 0) {
182                 return (0, 0, false);
183             }
184         }
185         bytes memory bban = new bytes(18);
186         for (uint8 i = 0; i < 16; i++) {
187              bban[i] = _icap[i + 4];
188         }
189         var (asset, institution, _) = decodeIndirect(bban);
190 
191         bytes32 assetInstitutionHash = sha3(asset, institution);
192 
193         uint8 parseChecksum = (uint8(_icap[2]) - 48) * 10 + (uint8(_icap[3]) - 48);
194         uint8 calcChecksum = 98 - mod9710(prepare(bban));
195         if (parseChecksum != calcChecksum) {
196             return (institutions[assetInstitutionHash], assets[sha3(asset)], false);
197         }
198         return (institutions[assetInstitutionHash], assets[sha3(asset)], registered[assetInstitutionHash]);
199     }
200 
201     function prepare(bytes _bban) constant returns(bytes) {
202         for (uint8 i = 0; i < 16; i++) {
203             uint8 charCode = uint8(_bban[i]);
204             if (charCode >= 65 && charCode <= 90) {
205                 _bban[i] = byte(charCode - 65 + 10);
206             }
207         }
208         _bban[16] = 33; // X
209         _bban[17] = 14; // E
210         //_bban[18] = 48; // 0
211         //_bban[19] = 48; // 0
212         return _bban;
213     }
214 
215     function mod9710(bytes _prepared) constant returns(uint8) {
216         uint m = 0;
217         for (uint8 i = 0; i < 18; i++) {
218             uint8 charCode = uint8(_prepared[i]);
219             if (charCode >= 48) {
220                 m *= 10;
221                 m += charCode - 48; // number
222                 m %= 97;
223             } else {
224                 m *= 10;
225                 m += charCode / 10; // part1
226                 m %= 97;
227                 m *= 10;
228                 m += charCode % 10; // part2
229                 m %= 97;
230             }
231         }
232         m *= 10;
233         //m += uint8(_prepared[18]) - 48;
234         m %= 97;
235         m *= 10;
236         //m += uint8(_prepared[19]) - 48;
237         m %= 97;
238         return uint8(m);
239     }
240 
241     mapping(bytes32 => bool) public registered;
242     mapping(bytes32 => address) public institutions;
243     mapping(bytes32 => address) public institutionOwners;
244     mapping(bytes32 => bytes32) public assets;
245 
246     modifier onlyInstitutionOwner(string _institution) {
247         if (msg.sender == institutionOwners[sha3(_institution)]) {
248             _
249         }
250     }
251 
252     function changeInstitutionOwner(string _institution, address _address) noValue() onlyInstitutionOwner(_institution) returns(bool) {
253         institutionOwners[sha3(_institution)] = _address;
254         return true;
255     }
256 
257     // web3js sendIBANTransaction interface
258     function addr(bytes32 _institution) constant returns(address) {
259         return institutions[sha3("ETH", _institution[0], _institution[1], _institution[2], _institution[3])];
260     }
261 
262     function registerInstitution(string _institution, address _address) noValue() checkAccess("admin") returns(bool) {
263         if (bytes(_institution).length != 4) {
264             return false;
265         }
266         if (institutionOwners[sha3(_institution)] != 0) {
267             return false;
268         }
269         institutionOwners[sha3(_institution)] = _address;
270         return true;
271     }
272 
273     function registerInstitutionAsset(string _asset, string _institution, address _address) noValue() onlyInstitutionOwner(_institution) returns(bool) {
274         if (!registered[sha3(_asset)]) {
275             return false;
276         }
277         bytes32 assetInstitutionHash = sha3(_asset, _institution);
278         if (registered[assetInstitutionHash]) {
279             return false;
280         }
281         registered[assetInstitutionHash] = true;
282         institutions[assetInstitutionHash] = _address;
283         return true;
284     }
285 
286     function updateInstitutionAsset(string _asset, string _institution, address _address) noValue() onlyInstitutionOwner(_institution) returns(bool) {
287         bytes32 assetInstitutionHash = sha3(_asset, _institution);
288         if (!registered[assetInstitutionHash]) {
289             return false;
290         }
291         institutions[assetInstitutionHash] = _address;
292         return true;
293     }
294 
295     function removeInstitutionAsset(string _asset, string _institution) noValue() onlyInstitutionOwner(_institution) returns(bool) {
296         bytes32 assetInstitutionHash = sha3(_asset, _institution);
297         if (!registered[assetInstitutionHash]) {
298             return false;
299         }
300         delete registered[assetInstitutionHash];
301         delete institutions[assetInstitutionHash];
302         return true;
303     }
304 
305     function registerAsset(string _asset, bytes32 _symbol) noValue() checkAccess("admin") returns(bool) {
306         if (bytes(_asset).length != 3) {
307             return false;
308         }
309         bytes32 asset = sha3(_asset);
310         if (registered[asset]) {
311             return false;
312         }
313         registered[asset] = true;
314         assets[asset] = _symbol;
315         return true;
316     }
317 }