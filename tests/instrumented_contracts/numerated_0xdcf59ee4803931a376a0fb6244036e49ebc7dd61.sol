1 pragma solidity ^0.4.8;
2 
3 //в этом тестовом контракте мы реализуем простейший вариант казино
4 //здесь будет одна игра
5 //фронтенд будет полностью написан на js,html,css
6 //ide http://dapps.oraclize.it/browser-solidity/
7 
8 // <ORACLIZE_API>
9 /*
10 Copyright (c) 2015-2016 Oraclize SRL
11 Copyright (c) 2016 Oraclize LTD
12 
13 
14 
15 Permission is hereby granted, free of charge, to any person obtaining a copy
16 of this software and associated documentation files (the "Software"), to deal
17 in the Software without restriction, including without limitation the rights
18 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
19 copies of the Software, and to permit persons to whom the Software is
20 furnished to do so, subject to the following conditions:
21 
22 
23 
24 The above copyright notice and this permission notice shall be included in
25 all copies or substantial portions of the Software.
26 
27 
28 
29 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
30 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
31 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
32 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
33 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
34 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
35 THE SOFTWARE.
36 */
37 
38 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
39 
40 contract OraclizeI {
41     address public cbAddress;
42     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
43     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
44     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
45     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
46     function getPrice(string _datasource) returns (uint _dsprice);
47     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
48     function useCoupon(string _coupon);
49     function setProofType(byte _proofType);
50     function setConfig(bytes32 _config);
51     function setCustomGasPrice(uint _gasPrice);
52 }
53 contract OraclizeAddrResolverI {
54     function getAddress() returns (address _addr);
55 }
56 contract usingOraclize {
57     uint constant day = 60*60*24;
58     uint constant week = 60*60*24*7;
59     uint constant month = 60*60*24*30;
60     byte constant proofType_NONE = 0x00;
61     byte constant proofType_TLSNotary = 0x10;
62     byte constant proofStorage_IPFS = 0x01;
63     uint8 constant networkID_auto = 0;
64     uint8 constant networkID_mainnet = 1;
65     uint8 constant networkID_testnet = 2;
66     uint8 constant networkID_morden = 2;
67     uint8 constant networkID_consensys = 161;
68 
69     OraclizeAddrResolverI OAR;
70     
71     OraclizeI oraclize;
72     modifier oraclizeAPI {
73         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
74         oraclize = OraclizeI(OAR.getAddress());
75         _;
76     }
77     modifier coupon(string code){
78         oraclize = OraclizeI(OAR.getAddress());
79         oraclize.useCoupon(code);
80         _;
81     }
82 
83     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
84         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){ //mainnet
85             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
86             return true;
87         }
88         if (getCodeSize(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1)>0){ //ropsten testnet
89             OAR = OraclizeAddrResolverI(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1);
90             return true;
91         }
92         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){ //ether.camp ide
93             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
94             return true;
95         }
96         if (getCodeSize(0x93bbbe5ce77034e3095f0479919962a903f898ad)>0){ //norsborg testnet
97             OAR = OraclizeAddrResolverI(0x93bbbe5ce77034e3095f0479919962a903f898ad);
98             return true;
99         }
100         if (getCodeSize(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa)>0){ //browser-solidity
101             OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
102             return true;
103         }
104         return false;
105     }
106     
107     function __callback(bytes32 myid, string result) {
108         __callback(myid, result, new bytes(0));
109     }
110     function __callback(bytes32 myid, string result, bytes proof) {
111     }
112     
113     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
114         return oraclize.getPrice(datasource);
115     }
116     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
117         return oraclize.getPrice(datasource, gaslimit);
118     }
119     
120     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
121         uint price = oraclize.getPrice(datasource);
122         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
123         return oraclize.query.value(price)(0, datasource, arg);
124     }
125     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
126         uint price = oraclize.getPrice(datasource);
127         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
128         return oraclize.query.value(price)(timestamp, datasource, arg);
129     }
130     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
131         uint price = oraclize.getPrice(datasource, gaslimit);
132         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
133         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
134     }
135     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
136         uint price = oraclize.getPrice(datasource, gaslimit);
137         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
138         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
139     }
140     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
141         uint price = oraclize.getPrice(datasource);
142         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
143         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
144     }
145     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
146         uint price = oraclize.getPrice(datasource);
147         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
148         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
149     }
150     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
151         uint price = oraclize.getPrice(datasource, gaslimit);
152         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
153         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
154     }
155     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
156         uint price = oraclize.getPrice(datasource, gaslimit);
157         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
158         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
159     }
160     function oraclize_cbAddress() oraclizeAPI internal returns (address){
161         return oraclize.cbAddress();
162     }
163     function oraclize_setProof(byte proofP) oraclizeAPI internal {
164         return oraclize.setProofType(proofP);
165     }
166     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
167         return oraclize.setCustomGasPrice(gasPrice);
168     }    
169     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
170         return oraclize.setConfig(config);
171     }
172 
173     function getCodeSize(address _addr) constant internal returns(uint _size) {
174         assembly {
175             _size := extcodesize(_addr)
176         }
177     }
178 
179 
180     function parseAddr(string _a) internal returns (address){
181         bytes memory tmp = bytes(_a);
182         uint160 iaddr = 0;
183         uint160 b1;
184         uint160 b2;
185         for (uint i=2; i<2+2*20; i+=2){
186             iaddr *= 256;
187             b1 = uint160(tmp[i]);
188             b2 = uint160(tmp[i+1]);
189             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
190             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
191             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
192             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
193             iaddr += (b1*16+b2);
194         }
195         return address(iaddr);
196     }
197 
198 
199     function strCompare(string _a, string _b) internal returns (int) {
200         bytes memory a = bytes(_a);
201         bytes memory b = bytes(_b);
202         uint minLength = a.length;
203         if (b.length < minLength) minLength = b.length;
204         for (uint i = 0; i < minLength; i ++)
205             if (a[i] < b[i])
206                 return -1;
207             else if (a[i] > b[i])
208                 return 1;
209         if (a.length < b.length)
210             return -1;
211         else if (a.length > b.length)
212             return 1;
213         else
214             return 0;
215    } 
216 
217     function indexOf(string _haystack, string _needle) internal returns (int)
218     {
219         bytes memory h = bytes(_haystack);
220         bytes memory n = bytes(_needle);
221         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
222             return -1;
223         else if(h.length > (2**128 -1))
224             return -1;                                  
225         else
226         {
227             uint subindex = 0;
228             for (uint i = 0; i < h.length; i ++)
229             {
230                 if (h[i] == n[0])
231                 {
232                     subindex = 1;
233                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
234                     {
235                         subindex++;
236                     }   
237                     if(subindex == n.length)
238                         return int(i);
239                 }
240             }
241             return -1;
242         }   
243     }
244 
245     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
246         bytes memory _ba = bytes(_a);
247         bytes memory _bb = bytes(_b);
248         bytes memory _bc = bytes(_c);
249         bytes memory _bd = bytes(_d);
250         bytes memory _be = bytes(_e);
251         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
252         bytes memory babcde = bytes(abcde);
253         uint k = 0;
254         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
255         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
256         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
257         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
258         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
259         return string(babcde);
260     }
261     
262     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
263         return strConcat(_a, _b, _c, _d, "");
264     }
265 
266     function strConcat(string _a, string _b, string _c) internal returns (string) {
267         return strConcat(_a, _b, _c, "", "");
268     }
269 
270     function strConcat(string _a, string _b) internal returns (string) {
271         return strConcat(_a, _b, "", "", "");
272     }
273 
274     // parseInt
275     function parseInt(string _a) internal returns (uint) {
276         return parseInt(_a, 0);
277     }
278 
279     // parseInt(parseFloat*10^_b)
280     function parseInt(string _a, uint _b) internal returns (uint) {
281         bytes memory bresult = bytes(_a);
282         uint mint = 0;
283         bool decimals = false;
284         for (uint i=0; i<bresult.length; i++){
285             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
286                 if (decimals){
287                    if (_b == 0) break;
288                     else _b--;
289                 }
290                 mint *= 10;
291                 mint += uint(bresult[i]) - 48;
292             } else if (bresult[i] == 46) decimals = true;
293         }
294         if (_b > 0) mint *= 10**_b;
295         return mint;
296     }
297     
298     function uint2str(uint i) internal returns (string){
299         if (i == 0) return "0";
300         uint j = i;
301         uint len;
302         while (j != 0){
303             len++;
304             j /= 10;
305         }
306         bytes memory bstr = new bytes(len);
307         uint k = len - 1;
308         while (i != 0){
309             bstr[k--] = byte(48 + i % 10);
310             i /= 10;
311         }
312         return string(bstr);
313     }
314     
315     
316 
317 }
318 // </ORACLIZE_API>
319 
320 contract HackDao is usingOraclize {
321  
322   mapping (bytes32 => address) bets;
323   mapping (bytes32 => bool) public results; 
324   mapping (bytes32 => uint) betsvalue;
325   
326   event Transfer(address indexed from, address indexed to, uint256 value);
327 
328   
329   function Contract() {
330     oraclize_setNetwork(networkID_consensys);
331   }
332   
333   event LogB(bytes32 h);
334 	event LogS(string s);
335 	event LogI(uint s);
336 	  
337 	  function game () payable returns (bytes32) {
338 	   if (msg.value <= 0) throw;
339   	   bytes32 myid = oraclize_query("WolframAlpha", "random integer number between 0 and 1");
340   	   //LogI(price);
341   	   bets[myid] = msg.sender;
342   	   betsvalue[myid] = msg.value-10000000000000000; //ставка за вычитом расходов на оракула ~0.01 eth
343   	   LogB(myid);
344   	   return myid;
345 	  }
346 	 
347 	  
348 	  function __callback(bytes32 myid, string result) {
349         LogS('callback');
350         if (msg.sender != oraclize_cbAddress()) throw;
351        
352         //log0(result);
353         
354         if (parseInt(result) == 1) {
355             if (!bets[myid].send(betsvalue[myid]*2)) {LogS("bug! bet to winner was not sent!");} else {
356                 LogS("sent");
357                 LogI(betsvalue[myid]*2);
358               }
359             results[myid] = true;
360         } else {
361             results[myid] = false;
362         }
363         
364       }
365     
366 }