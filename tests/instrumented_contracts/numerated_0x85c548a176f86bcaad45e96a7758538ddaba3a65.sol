1 pragma solidity ^0.4.0;
2 // <ORACLIZE_API>
3 /*
4 Copyright (c) 2015-2016 Oraclize SRL
5 Copyright (c) 2016 Oraclize LTD
6 
7 
8 
9 Permission is hereby granted, free of charge, to any person obtaining a copy
10 of this software and associated documentation files (the "Software"), to deal
11 in the Software without restriction, including without limitation the rights
12 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
13 copies of the Software, and to permit persons to whom the Software is
14 furnished to do so, subject to the following conditions:
15 
16 
17 
18 The above copyright notice and this permission notice shall be included in
19 all copies or substantial portions of the Software.
20 
21 
22 
23 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
24 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
25 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
26 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
27 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
28 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
29 THE SOFTWARE.
30 */
31 
32 pragma solidity ^0.4.0;
33 
34 contract OraclizeI {
35     address public cbAddress;
36     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
37     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
38     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
39     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
40     function getPrice(string _datasource) returns (uint _dsprice);
41     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
42     function useCoupon(string _coupon);
43     function setProofType(byte _proofType);
44     function setCustomGasPrice(uint _gasPrice);
45 }
46 contract OraclizeAddrResolverI {
47     function getAddress() returns (address _addr);
48 }
49 contract usingOraclize {
50     uint constant day = 60*60*24;
51     uint constant week = 60*60*24*7;
52     uint constant month = 60*60*24*30;
53     byte constant proofType_NONE = 0x00;
54     byte constant proofType_TLSNotary = 0x10;
55     byte constant proofStorage_IPFS = 0x01;
56     uint8 constant networkID_auto = 0;
57     uint8 constant networkID_mainnet = 1;
58     uint8 constant networkID_testnet = 2;
59     uint8 constant networkID_morden = 2;
60     uint8 constant networkID_consensys = 161;
61 
62     OraclizeAddrResolverI OAR;
63     
64     OraclizeI oraclize;
65     modifier oraclizeAPI {
66         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
67         oraclize = OraclizeI(OAR.getAddress());
68         _;
69     }
70     modifier coupon(string code){
71         oraclize = OraclizeI(OAR.getAddress());
72         oraclize.useCoupon(code);
73         _;
74     }
75 
76     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
77         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){
78             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
79             return true;
80         }
81         if (getCodeSize(0x9efbea6358bed926b293d2ce63a730d6d98d43dd)>0){
82             OAR = OraclizeAddrResolverI(0x9efbea6358bed926b293d2ce63a730d6d98d43dd);
83             return true;
84         }
85         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){
86             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
87             return true;
88         }
89         if (getCodeSize(0x9a1d6e5c6c8d081ac45c6af98b74a42442afba60)>0){
90             OAR = OraclizeAddrResolverI(0x9a1d6e5c6c8d081ac45c6af98b74a42442afba60);
91             return true;
92         }
93         return false;
94     }
95     
96     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
97         uint price = oraclize.getPrice(datasource);
98         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
99         return oraclize.query.value(price)(0, datasource, arg);
100     }
101     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
102         uint price = oraclize.getPrice(datasource);
103         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
104         return oraclize.query.value(price)(timestamp, datasource, arg);
105     }
106     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
107         uint price = oraclize.getPrice(datasource, gaslimit);
108         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
109         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
110     }
111     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
112         uint price = oraclize.getPrice(datasource, gaslimit);
113         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
114         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
115     }
116     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
117         uint price = oraclize.getPrice(datasource);
118         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
119         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
120     }
121     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
122         uint price = oraclize.getPrice(datasource);
123         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
124         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
125     }
126     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
127         uint price = oraclize.getPrice(datasource, gaslimit);
128         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
129         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
130     }
131     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
132         uint price = oraclize.getPrice(datasource, gaslimit);
133         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
134         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
135     }
136     function oraclize_cbAddress() oraclizeAPI internal returns (address){
137         return oraclize.cbAddress();
138     }
139     function oraclize_setProof(byte proofP) oraclizeAPI internal {
140         return oraclize.setProofType(proofP);
141     }
142     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
143         return oraclize.setCustomGasPrice(gasPrice);
144     }    
145     function oraclize_setConfig(bytes config) oraclizeAPI internal {
146         //return oraclize.setConfig(config);
147     }
148 
149     function getCodeSize(address _addr) constant internal returns(uint _size) {
150         assembly {
151             _size := extcodesize(_addr)
152         }
153     }
154 
155 
156     function parseAddr(string _a) internal returns (address){
157         bytes memory tmp = bytes(_a);
158         uint160 iaddr = 0;
159         uint160 b1;
160         uint160 b2;
161         for (uint i=2; i<2+2*20; i+=2){
162             iaddr *= 256;
163             b1 = uint160(tmp[i]);
164             b2 = uint160(tmp[i+1]);
165             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
166             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
167             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
168             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
169             iaddr += (b1*16+b2);
170         }
171         return address(iaddr);
172     }
173 
174 
175     function strCompare(string _a, string _b) internal returns (int) {
176         bytes memory a = bytes(_a);
177         bytes memory b = bytes(_b);
178         uint minLength = a.length;
179         if (b.length < minLength) minLength = b.length;
180         for (uint i = 0; i < minLength; i ++)
181             if (a[i] < b[i])
182                 return -1;
183             else if (a[i] > b[i])
184                 return 1;
185         if (a.length < b.length)
186             return -1;
187         else if (a.length > b.length)
188             return 1;
189         else
190             return 0;
191    } 
192 
193     function indexOf(string _haystack, string _needle) internal returns (int)
194     {
195         bytes memory h = bytes(_haystack);
196         bytes memory n = bytes(_needle);
197         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
198             return -1;
199         else if(h.length > (2**128 -1))
200             return -1;                                  
201         else
202         {
203             uint subindex = 0;
204             for (uint i = 0; i < h.length; i ++)
205             {
206                 if (h[i] == n[0])
207                 {
208                     subindex = 1;
209                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
210                     {
211                         subindex++;
212                     }   
213                     if(subindex == n.length)
214                         return int(i);
215                 }
216             }
217             return -1;
218         }   
219     }
220 
221     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
222         bytes memory _ba = bytes(_a);
223         bytes memory _bb = bytes(_b);
224         bytes memory _bc = bytes(_c);
225         bytes memory _bd = bytes(_d);
226         bytes memory _be = bytes(_e);
227         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
228         bytes memory babcde = bytes(abcde);
229         uint k = 0;
230         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
231         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
232         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
233         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
234         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
235         return string(babcde);
236     }
237     
238     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
239         return strConcat(_a, _b, _c, _d, "");
240     }
241 
242     function strConcat(string _a, string _b, string _c) internal returns (string) {
243         return strConcat(_a, _b, _c, "", "");
244     }
245 
246     function strConcat(string _a, string _b) internal returns (string) {
247         return strConcat(_a, _b, "", "", "");
248     }
249 
250     // parseInt
251     function parseInt(string _a) internal returns (uint) {
252         return parseInt(_a, 0);
253     }
254 
255     // parseInt(parseFloat*10^_b)
256     function parseInt(string _a, uint _b) internal returns (uint) {
257         bytes memory bresult = bytes(_a);
258         uint mint = 0;
259         bool decimals = false;
260         for (uint i=0; i<bresult.length; i++){
261             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
262                 if (decimals){
263                    if (_b == 0) break;
264                     else _b--;
265                 }
266                 mint *= 10;
267                 mint += uint(bresult[i]) - 48;
268             } else if (bresult[i] == 46) decimals = true;
269         }
270         if (_b > 0) mint *= 10**_b;
271         return mint;
272     }
273     
274 
275 }
276 // </ORACLIZE_API>
277 contract FirstContract is usingOraclize {
278 
279 
280     address owner;
281     uint constant ORACLIZE_GAS_LIMIT = 125000;
282     uint public counter  = 0;
283     uint public errCounter = 0;
284     uint safeGas = 25000;
285 
286     /// Create a new ballot with $(_numProposals) different proposals.
287     function FirstContract() {
288         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
289         owner = msg.sender;
290     }
291 
292     function() {
293         errCounter++;
294     }
295     
296     modifier onlyOraclize {
297         if (msg.sender != oraclize_cbAddress()) throw;
298         _;
299     }
300 
301     modifier onlyOwner {
302         if (owner != msg.sender) throw;
303         _;
304     }
305     
306     function changeGasLimitOfSafeSend(uint newGasLimit) onlyOwner {
307         safeGas = newGasLimit;
308     }
309 
310     
311     function count() payable onlyOwner {
312         oraclize_query("URL", "json(http://typbr.com/counter).counter", "BG4iQv7699EEt7L6Wm4YnrC0gQv+tRWSNuqy7OUDudjRWPL+ZgKuGWPQMwxEgC1ksb2KXGxq9P6f+ObzYY0WG5g5GzmnNWj5zDNj+HoEQgzdYedoHW+176OOtDqRh3yN7ypqg6yjJsNuLVNyZD8Rs+nF2EY70BPDwOt3mQFdG1QXmXIzhQ28KEzyBedR9g==", ORACLIZE_GAS_LIMIT + safeGas);
313     }
314    
315    function invest() payable {
316    }
317    
318    function __callback (bytes32 myid, string result, bytes proof) payable onlyOraclize {
319          counter = parseInt(result);
320     }
321   
322     function safeSend(address addr, uint value) private {
323         if (this.balance < value) {
324             throw;
325         }
326 
327         if (!(addr.call.gas(safeGas).value(value)())) {
328             throw;
329         }
330     }   
331     
332    function divest(uint amount) payable onlyOwner {
333        safeSend(owner, amount);
334    }
335    
336    function destruct() payable onlyOwner {
337        selfdestruct(owner);
338    }
339 }