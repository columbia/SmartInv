1 pragma solidity ^0.4.6;
2 
3 contract OraclizeI {
4     address public cbAddress;
5     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
6     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
7     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
8     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
9     function getPrice(string _datasource) returns (uint _dsprice);
10     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
11     function useCoupon(string _coupon);
12     function setProofType(byte _proofType);
13     function setCustomGasPrice(uint _gasPrice);
14 }
15 contract OraclizeAddrResolverI {
16     function getAddress() returns (address _addr);
17 }
18 contract usingOraclize {
19     uint constant day = 60*60*24;
20     uint constant week = 60*60*24*7;
21     uint constant month = 60*60*24*30;
22     byte constant proofType_NONE = 0x00;
23     byte constant proofType_TLSNotary = 0x10;
24     byte constant proofStorage_IPFS = 0x01;
25     uint8 constant networkID_auto = 0;
26     uint8 constant networkID_mainnet = 1;
27     uint8 constant networkID_testnet = 2;
28     uint8 constant networkID_morden = 2;
29     uint8 constant networkID_consensys = 161;
30 
31     OraclizeAddrResolverI OAR;
32 
33     OraclizeI oraclize;
34     modifier oraclizeAPI {
35         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
36         oraclize = OraclizeI(OAR.getAddress());
37         _;
38     }
39     modifier coupon(string code){
40         oraclize = OraclizeI(OAR.getAddress());
41         oraclize.useCoupon(code);
42         _;
43     }
44 
45     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
46         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){ //mainnet
47             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
48             return true;
49         }
50         if (getCodeSize(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1)>0){ //ropsten testnet
51             OAR = OraclizeAddrResolverI(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1);
52             return true;
53         }
54         if (getCodeSize(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa)>0){ //browser-solidity
55             OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
56             return true;
57         }
58         return false;
59     }
60 
61     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
62         uint price = oraclize.getPrice(datasource);
63         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
64         return oraclize.query.value(price)(0, datasource, arg);
65     }
66     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
67         uint price = oraclize.getPrice(datasource);
68         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
69         return oraclize.query.value(price)(timestamp, datasource, arg);
70     }
71     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
72         uint price = oraclize.getPrice(datasource, gaslimit);
73         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
74         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
75     }
76     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
77         uint price = oraclize.getPrice(datasource, gaslimit);
78         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
79         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
80     }
81     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
82         uint price = oraclize.getPrice(datasource);
83         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
84         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
85     }
86     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
87         uint price = oraclize.getPrice(datasource);
88         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
89         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
90     }
91     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
92         uint price = oraclize.getPrice(datasource, gaslimit);
93         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
94         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
95     }
96     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
97         uint price = oraclize.getPrice(datasource, gaslimit);
98         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
99         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
100     }
101     function oraclize_cbAddress() oraclizeAPI internal returns (address){
102         return oraclize.cbAddress();
103     }
104     function oraclize_setProof(byte proofP) oraclizeAPI internal {
105         return oraclize.setProofType(proofP);
106     }
107     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
108         return oraclize.setCustomGasPrice(gasPrice);
109     }
110     function oraclize_setConfig(bytes config) oraclizeAPI internal {
111         //return oraclize.setConfig(config);
112     }
113 
114     function getCodeSize(address _addr) constant internal returns(uint _size) {
115         assembly {
116             _size := extcodesize(_addr)
117         }
118     }
119 
120 
121     function parseAddr(string _a) internal returns (address){
122         bytes memory tmp = bytes(_a);
123         uint160 iaddr = 0;
124         uint160 b1;
125         uint160 b2;
126         for (uint i=2; i<2+2*20; i+=2){
127             iaddr *= 256;
128             b1 = uint160(tmp[i]);
129             b2 = uint160(tmp[i+1]);
130             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
131             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
132             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
133             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
134             iaddr += (b1*16+b2);
135         }
136         return address(iaddr);
137     }
138 
139 
140     function strCompare(string _a, string _b) internal returns (int) {
141         bytes memory a = bytes(_a);
142         bytes memory b = bytes(_b);
143         uint minLength = a.length;
144         if (b.length < minLength) minLength = b.length;
145         for (uint i = 0; i < minLength; i ++)
146             if (a[i] < b[i])
147                 return -1;
148             else if (a[i] > b[i])
149                 return 1;
150         if (a.length < b.length)
151             return -1;
152         else if (a.length > b.length)
153             return 1;
154         else
155             return 0;
156    }
157 
158     function indexOf(string _haystack, string _needle) internal returns (int)
159     {
160         bytes memory h = bytes(_haystack);
161         bytes memory n = bytes(_needle);
162         if(h.length < 1 || n.length < 1 || (n.length > h.length))
163             return -1;
164         else if(h.length > (2**128 -1))
165             return -1;
166         else
167         {
168             uint subindex = 0;
169             for (uint i = 0; i < h.length; i ++)
170             {
171                 if (h[i] == n[0])
172                 {
173                     subindex = 1;
174                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
175                     {
176                         subindex++;
177                     }
178                     if(subindex == n.length)
179                         return int(i);
180                 }
181             }
182             return -1;
183         }
184     }
185 
186     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
187         bytes memory _ba = bytes(_a);
188         bytes memory _bb = bytes(_b);
189         bytes memory _bc = bytes(_c);
190         bytes memory _bd = bytes(_d);
191         bytes memory _be = bytes(_e);
192         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
193         bytes memory babcde = bytes(abcde);
194         uint k = 0;
195         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
196         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
197         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
198         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
199         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
200         return string(babcde);
201     }
202 
203     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
204         return strConcat(_a, _b, _c, _d, "");
205     }
206 
207     function strConcat(string _a, string _b, string _c) internal returns (string) {
208         return strConcat(_a, _b, _c, "", "");
209     }
210 
211     function strConcat(string _a, string _b) internal returns (string) {
212         return strConcat(_a, _b, "", "", "");
213     }
214 
215     // parseInt
216     function parseInt(string _a) internal returns (uint) {
217         return parseInt(_a, 0);
218     }
219 
220     // parseInt(parseFloat*10^_b)
221     function parseInt(string _a, uint _b) internal returns (uint) {
222         bytes memory bresult = bytes(_a);
223         uint mint = 0;
224         bool decimals = false;
225         for (uint i=0; i<bresult.length; i++){
226             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
227                 if (decimals){
228                    if (_b == 0) break;
229                     else _b--;
230                 }
231                 mint *= 10;
232                 mint += uint(bresult[i]) - 48;
233             } else if (bresult[i] == 46) decimals = true;
234         }
235         if (_b > 0) mint *= 10**_b;
236         return mint;
237     }
238 
239     function uint2str(uint i) internal returns (string){
240         if (i == 0) return "0";
241         uint j = i;
242         uint len;
243         while (j != 0){
244             len++;
245             j /= 10;
246         }
247         bytes memory bstr = new bytes(len);
248         uint k = len - 1;
249         while (i != 0){
250             bstr[k--] = byte(48 + i % 10);
251             i /= 10;
252         }
253         return string(bstr);
254     }
255 
256 
257 
258 }
259 // </ORACLIZE_API>
260 
261 
262 contract KeybaseRegistry is usingOraclize {
263 
264   mapping (address => string) private usernames;
265   mapping (string => address) private addresses;
266 
267   struct RegisterRequest {
268       string username;
269       address requester;
270       bool registered;
271   }
272 
273   mapping (bytes32 => RegisterRequest) internal oracleRequests;
274 
275   function getUsername(address a) public constant returns (string) {
276     return usernames[a];
277   }
278 
279   function getAddress(string u) public constant returns (address) {
280     return addresses[u];
281   }
282 
283   function myUsername() public constant returns (string) {
284     return getUsername(msg.sender);
285   }
286 
287   function claim(string username) public payable {
288     bytes32 requestId = oraclize_query("URL", keybasePubURL(username));
289     oracleRequests[requestId] = RegisterRequest({username: username, requester: msg.sender, registered: false});
290   }
291 
292   function processRequest(RegisterRequest request) private {
293     var oldUsername = usernames[addresses[request.username]];
294     usernames[addresses[request.username]] = '';
295     addresses[oldUsername] = 0x0;
296     usernames[request.requester] = request.username;
297     addresses[request.username] = request.requester;
298   }
299 
300   function __callback(bytes32 myid, string result) {
301     if (msg.sender != oraclize_cbAddress()) throw; // callback called by oraclize
302 
303     RegisterRequest request = oracleRequests[myid];
304     if (request.registered) throw; // request already processed
305     if (request.requester == 0x0) throw; // request not exists
306 
307     if (parseAddr(lowercaseString(result)) != request.requester) // result not equals requester address
308         throw;
309 
310     processRequest(request);
311     oracleRequests[myid].registered = true;
312   }
313 
314   function keybasePubURL(string memory username) constant returns (string) {
315     string memory protocol = "https://";
316     string memory url = '.keybase.pub/eth';
317 
318     // produces url like: https://username.keybase.pub/eth
319     return strConcat(protocol, username, url);
320   }
321 
322   function lowercaseString(string self) internal constant returns (string) {
323     bytes memory a = bytes(self);
324     for (uint i = 0; i < a.length; i++) {
325       if (uint8(a[i]) >= 0x41 && uint8(a[i]) <= 0x5A) {
326        a[i] = byte(uint8(a[i]) + 0x20);
327       }
328     }
329     return string(a);
330   }
331 
332   function () { throw; }
333 }