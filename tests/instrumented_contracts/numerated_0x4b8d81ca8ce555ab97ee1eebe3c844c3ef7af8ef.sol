1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 // <ORACLIZE_API>
30 /*
31 Copyright (c) 2015-2016 Oraclize SRL
32 Copyright (c) 2016 Oraclize LTD
33 
34 
35 
36 Permission is hereby granted, free of charge, to any person obtaining a copy
37 of this software and associated documentation files (the "Software"), to deal
38 in the Software without restriction, including without limitation the rights
39 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
40 copies of the Software, and to permit persons to whom the Software is
41 furnished to do so, subject to the following conditions:
42 
43 
44 
45 The above copyright notice and this permission notice shall be included in
46 all copies or substantial portions of the Software.
47 
48 
49 
50 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
51 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
52 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
53 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
54 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
55 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
56 THE SOFTWARE.
57 */
58 
59 pragma solidity ^0.4.11;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
60 
61 contract OraclizeI {
62     address public cbAddress;
63     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
64     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
65     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
66     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
67     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
68     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
69     function getPrice(string _datasource) returns (uint _dsprice);
70     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
71     function useCoupon(string _coupon);
72     function setProofType(byte _proofType);
73     function setConfig(bytes32 _config);
74     function setCustomGasPrice(uint _gasPrice);
75     function randomDS_getSessionPubKeyHash() returns(bytes32);
76 }
77 contract OraclizeAddrResolverI {
78     function getAddress() returns (address _addr);
79 }
80 contract usingOraclize {
81     uint constant day = 60*60*24;
82     uint constant week = 60*60*24*7;
83     uint constant month = 60*60*24*30;
84     byte constant proofType_NONE = 0x00;
85     byte constant proofType_TLSNotary = 0x10;
86     byte constant proofType_Android = 0x20;
87     byte constant proofType_Ledger = 0x30;
88     byte constant proofType_Native = 0xF0;
89     byte constant proofStorage_IPFS = 0x01;
90     uint8 constant networkID_auto = 0;
91     uint8 constant networkID_mainnet = 1;
92     uint8 constant networkID_testnet = 2;
93     uint8 constant networkID_morden = 2;
94     uint8 constant networkID_consensys = 161;
95 
96     OraclizeAddrResolverI OAR;
97 
98     OraclizeI oraclize;
99     modifier oraclizeAPI {
100         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
101         oraclize = OraclizeI(OAR.getAddress());
102         _;
103     }
104     modifier coupon(string code){
105         oraclize = OraclizeI(OAR.getAddress());
106         oraclize.useCoupon(code);
107         _;
108     }
109 
110     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
111         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
112             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
113             oraclize_setNetworkName("eth_mainnet");
114             return true;
115         }
116         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
117             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
118             oraclize_setNetworkName("eth_ropsten3");
119             return true;
120         }
121         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
122             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
123             oraclize_setNetworkName("eth_kovan");
124             return true;
125         }
126         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
127             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
128             oraclize_setNetworkName("eth_rinkeby");
129             return true;
130         }
131         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
132             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
133             return true;
134         }
135         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
136             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
137             return true;
138         }
139         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
140             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
141             return true;
142         }
143         return false;
144     }
145 
146     function __callback(bytes32 myid, string result) {
147         __callback(myid, result, new bytes(0));
148     }
149     function __callback(bytes32 myid, string result, bytes proof) {
150     }
151     
152     function oraclize_useCoupon(string code) oraclizeAPI internal {
153         oraclize.useCoupon(code);
154     }
155 
156     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
157         return oraclize.getPrice(datasource);
158     }
159 
160     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
161         return oraclize.getPrice(datasource, gaslimit);
162     }
163     
164     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
165         uint price = oraclize.getPrice(datasource);
166         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
167         return oraclize.query.value(price)(0, datasource, arg);
168     }
169     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
170         uint price = oraclize.getPrice(datasource);
171         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
172         return oraclize.query.value(price)(timestamp, datasource, arg);
173     }
174     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
175         uint price = oraclize.getPrice(datasource, gaslimit);
176         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
177         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
178     }
179     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
180         uint price = oraclize.getPrice(datasource, gaslimit);
181         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
182         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
183     }
184     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
185         uint price = oraclize.getPrice(datasource);
186         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
187         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
188     }
189     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
190         uint price = oraclize.getPrice(datasource);
191         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
192         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
193     }
194     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
195         uint price = oraclize.getPrice(datasource, gaslimit);
196         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
197         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
198     }
199     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
200         uint price = oraclize.getPrice(datasource, gaslimit);
201         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
202         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
203     }
204     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
205         uint price = oraclize.getPrice(datasource);
206         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
207         bytes memory args = stra2cbor(argN);
208         return oraclize.queryN.value(price)(0, datasource, args);
209     }
210     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
211         uint price = oraclize.getPrice(datasource);
212         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
213         bytes memory args = stra2cbor(argN);
214         return oraclize.queryN.value(price)(timestamp, datasource, args);
215     }
216     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
217         uint price = oraclize.getPrice(datasource, gaslimit);
218         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
219         bytes memory args = stra2cbor(argN);
220         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
221     }
222     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
223         uint price = oraclize.getPrice(datasource, gaslimit);
224         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
225         bytes memory args = stra2cbor(argN);
226         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
227     }
228     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
229         string[] memory dynargs = new string[](1);
230         dynargs[0] = args[0];
231         return oraclize_query(datasource, dynargs);
232     }
233     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
234         string[] memory dynargs = new string[](1);
235         dynargs[0] = args[0];
236         return oraclize_query(timestamp, datasource, dynargs);
237     }
238     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
239         string[] memory dynargs = new string[](1);
240         dynargs[0] = args[0];
241         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
242     }
243     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
244         string[] memory dynargs = new string[](1);
245         dynargs[0] = args[0];       
246         return oraclize_query(datasource, dynargs, gaslimit);
247     }
248     
249     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
250         string[] memory dynargs = new string[](2);
251         dynargs[0] = args[0];
252         dynargs[1] = args[1];
253         return oraclize_query(datasource, dynargs);
254     }
255     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
256         string[] memory dynargs = new string[](2);
257         dynargs[0] = args[0];
258         dynargs[1] = args[1];
259         return oraclize_query(timestamp, datasource, dynargs);
260     }
261     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
262         string[] memory dynargs = new string[](2);
263         dynargs[0] = args[0];
264         dynargs[1] = args[1];
265         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
266     }
267     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
268         string[] memory dynargs = new string[](2);
269         dynargs[0] = args[0];
270         dynargs[1] = args[1];
271         return oraclize_query(datasource, dynargs, gaslimit);
272     }
273     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
274         string[] memory dynargs = new string[](3);
275         dynargs[0] = args[0];
276         dynargs[1] = args[1];
277         dynargs[2] = args[2];
278         return oraclize_query(datasource, dynargs);
279     }
280     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
281         string[] memory dynargs = new string[](3);
282         dynargs[0] = args[0];
283         dynargs[1] = args[1];
284         dynargs[2] = args[2];
285         return oraclize_query(timestamp, datasource, dynargs);
286     }
287     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
288         string[] memory dynargs = new string[](3);
289         dynargs[0] = args[0];
290         dynargs[1] = args[1];
291         dynargs[2] = args[2];
292         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
293     }
294     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
295         string[] memory dynargs = new string[](3);
296         dynargs[0] = args[0];
297         dynargs[1] = args[1];
298         dynargs[2] = args[2];
299         return oraclize_query(datasource, dynargs, gaslimit);
300     }
301     
302     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
303         string[] memory dynargs = new string[](4);
304         dynargs[0] = args[0];
305         dynargs[1] = args[1];
306         dynargs[2] = args[2];
307         dynargs[3] = args[3];
308         return oraclize_query(datasource, dynargs);
309     }
310     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
311         string[] memory dynargs = new string[](4);
312         dynargs[0] = args[0];
313         dynargs[1] = args[1];
314         dynargs[2] = args[2];
315         dynargs[3] = args[3];
316         return oraclize_query(timestamp, datasource, dynargs);
317     }
318     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
319         string[] memory dynargs = new string[](4);
320         dynargs[0] = args[0];
321         dynargs[1] = args[1];
322         dynargs[2] = args[2];
323         dynargs[3] = args[3];
324         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
325     }
326     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
327         string[] memory dynargs = new string[](4);
328         dynargs[0] = args[0];
329         dynargs[1] = args[1];
330         dynargs[2] = args[2];
331         dynargs[3] = args[3];
332         return oraclize_query(datasource, dynargs, gaslimit);
333     }
334     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
335         string[] memory dynargs = new string[](5);
336         dynargs[0] = args[0];
337         dynargs[1] = args[1];
338         dynargs[2] = args[2];
339         dynargs[3] = args[3];
340         dynargs[4] = args[4];
341         return oraclize_query(datasource, dynargs);
342     }
343     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
344         string[] memory dynargs = new string[](5);
345         dynargs[0] = args[0];
346         dynargs[1] = args[1];
347         dynargs[2] = args[2];
348         dynargs[3] = args[3];
349         dynargs[4] = args[4];
350         return oraclize_query(timestamp, datasource, dynargs);
351     }
352     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
353         string[] memory dynargs = new string[](5);
354         dynargs[0] = args[0];
355         dynargs[1] = args[1];
356         dynargs[2] = args[2];
357         dynargs[3] = args[3];
358         dynargs[4] = args[4];
359         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
360     }
361     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
362         string[] memory dynargs = new string[](5);
363         dynargs[0] = args[0];
364         dynargs[1] = args[1];
365         dynargs[2] = args[2];
366         dynargs[3] = args[3];
367         dynargs[4] = args[4];
368         return oraclize_query(datasource, dynargs, gaslimit);
369     }
370     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
371         uint price = oraclize.getPrice(datasource);
372         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
373         bytes memory args = ba2cbor(argN);
374         return oraclize.queryN.value(price)(0, datasource, args);
375     }
376     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
377         uint price = oraclize.getPrice(datasource);
378         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
379         bytes memory args = ba2cbor(argN);
380         return oraclize.queryN.value(price)(timestamp, datasource, args);
381     }
382     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
383         uint price = oraclize.getPrice(datasource, gaslimit);
384         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
385         bytes memory args = ba2cbor(argN);
386         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
387     }
388     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
389         uint price = oraclize.getPrice(datasource, gaslimit);
390         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
391         bytes memory args = ba2cbor(argN);
392         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
393     }
394     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
395         bytes[] memory dynargs = new bytes[](1);
396         dynargs[0] = args[0];
397         return oraclize_query(datasource, dynargs);
398     }
399     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
400         bytes[] memory dynargs = new bytes[](1);
401         dynargs[0] = args[0];
402         return oraclize_query(timestamp, datasource, dynargs);
403     }
404     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
405         bytes[] memory dynargs = new bytes[](1);
406         dynargs[0] = args[0];
407         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
408     }
409     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
410         bytes[] memory dynargs = new bytes[](1);
411         dynargs[0] = args[0];       
412         return oraclize_query(datasource, dynargs, gaslimit);
413     }
414     
415     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
416         bytes[] memory dynargs = new bytes[](2);
417         dynargs[0] = args[0];
418         dynargs[1] = args[1];
419         return oraclize_query(datasource, dynargs);
420     }
421     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
422         bytes[] memory dynargs = new bytes[](2);
423         dynargs[0] = args[0];
424         dynargs[1] = args[1];
425         return oraclize_query(timestamp, datasource, dynargs);
426     }
427     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
428         bytes[] memory dynargs = new bytes[](2);
429         dynargs[0] = args[0];
430         dynargs[1] = args[1];
431         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
432     }
433     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
434         bytes[] memory dynargs = new bytes[](2);
435         dynargs[0] = args[0];
436         dynargs[1] = args[1];
437         return oraclize_query(datasource, dynargs, gaslimit);
438     }
439     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
440         bytes[] memory dynargs = new bytes[](3);
441         dynargs[0] = args[0];
442         dynargs[1] = args[1];
443         dynargs[2] = args[2];
444         return oraclize_query(datasource, dynargs);
445     }
446     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
447         bytes[] memory dynargs = new bytes[](3);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         dynargs[2] = args[2];
451         return oraclize_query(timestamp, datasource, dynargs);
452     }
453     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
454         bytes[] memory dynargs = new bytes[](3);
455         dynargs[0] = args[0];
456         dynargs[1] = args[1];
457         dynargs[2] = args[2];
458         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
459     }
460     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
461         bytes[] memory dynargs = new bytes[](3);
462         dynargs[0] = args[0];
463         dynargs[1] = args[1];
464         dynargs[2] = args[2];
465         return oraclize_query(datasource, dynargs, gaslimit);
466     }
467     
468     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
469         bytes[] memory dynargs = new bytes[](4);
470         dynargs[0] = args[0];
471         dynargs[1] = args[1];
472         dynargs[2] = args[2];
473         dynargs[3] = args[3];
474         return oraclize_query(datasource, dynargs);
475     }
476     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
477         bytes[] memory dynargs = new bytes[](4);
478         dynargs[0] = args[0];
479         dynargs[1] = args[1];
480         dynargs[2] = args[2];
481         dynargs[3] = args[3];
482         return oraclize_query(timestamp, datasource, dynargs);
483     }
484     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
485         bytes[] memory dynargs = new bytes[](4);
486         dynargs[0] = args[0];
487         dynargs[1] = args[1];
488         dynargs[2] = args[2];
489         dynargs[3] = args[3];
490         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
491     }
492     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
493         bytes[] memory dynargs = new bytes[](4);
494         dynargs[0] = args[0];
495         dynargs[1] = args[1];
496         dynargs[2] = args[2];
497         dynargs[3] = args[3];
498         return oraclize_query(datasource, dynargs, gaslimit);
499     }
500     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
501         bytes[] memory dynargs = new bytes[](5);
502         dynargs[0] = args[0];
503         dynargs[1] = args[1];
504         dynargs[2] = args[2];
505         dynargs[3] = args[3];
506         dynargs[4] = args[4];
507         return oraclize_query(datasource, dynargs);
508     }
509     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
510         bytes[] memory dynargs = new bytes[](5);
511         dynargs[0] = args[0];
512         dynargs[1] = args[1];
513         dynargs[2] = args[2];
514         dynargs[3] = args[3];
515         dynargs[4] = args[4];
516         return oraclize_query(timestamp, datasource, dynargs);
517     }
518     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
519         bytes[] memory dynargs = new bytes[](5);
520         dynargs[0] = args[0];
521         dynargs[1] = args[1];
522         dynargs[2] = args[2];
523         dynargs[3] = args[3];
524         dynargs[4] = args[4];
525         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
526     }
527     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
528         bytes[] memory dynargs = new bytes[](5);
529         dynargs[0] = args[0];
530         dynargs[1] = args[1];
531         dynargs[2] = args[2];
532         dynargs[3] = args[3];
533         dynargs[4] = args[4];
534         return oraclize_query(datasource, dynargs, gaslimit);
535     }
536 
537     function oraclize_cbAddress() oraclizeAPI internal returns (address){
538         return oraclize.cbAddress();
539     }
540     function oraclize_setProof(byte proofP) oraclizeAPI internal {
541         return oraclize.setProofType(proofP);
542     }
543     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
544         return oraclize.setCustomGasPrice(gasPrice);
545     }
546     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
547         return oraclize.setConfig(config);
548     }
549     
550     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
551         return oraclize.randomDS_getSessionPubKeyHash();
552     }
553 
554     function getCodeSize(address _addr) constant internal returns(uint _size) {
555         assembly {
556             _size := extcodesize(_addr)
557         }
558     }
559 
560     function parseAddr(string _a) internal returns (address){
561         bytes memory tmp = bytes(_a);
562         uint160 iaddr = 0;
563         uint160 b1;
564         uint160 b2;
565         for (uint i=2; i<2+2*20; i+=2){
566             iaddr *= 256;
567             b1 = uint160(tmp[i]);
568             b2 = uint160(tmp[i+1]);
569             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
570             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
571             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
572             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
573             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
574             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
575             iaddr += (b1*16+b2);
576         }
577         return address(iaddr);
578     }
579 
580     function strCompare(string _a, string _b) internal returns (int) {
581         bytes memory a = bytes(_a);
582         bytes memory b = bytes(_b);
583         uint minLength = a.length;
584         if (b.length < minLength) minLength = b.length;
585         for (uint i = 0; i < minLength; i ++)
586             if (a[i] < b[i])
587                 return -1;
588             else if (a[i] > b[i])
589                 return 1;
590         if (a.length < b.length)
591             return -1;
592         else if (a.length > b.length)
593             return 1;
594         else
595             return 0;
596     }
597 
598     function indexOf(string _haystack, string _needle) internal returns (int) {
599         bytes memory h = bytes(_haystack);
600         bytes memory n = bytes(_needle);
601         if(h.length < 1 || n.length < 1 || (n.length > h.length))
602             return -1;
603         else if(h.length > (2**128 -1))
604             return -1;
605         else
606         {
607             uint subindex = 0;
608             for (uint i = 0; i < h.length; i ++)
609             {
610                 if (h[i] == n[0])
611                 {
612                     subindex = 1;
613                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
614                     {
615                         subindex++;
616                     }
617                     if(subindex == n.length)
618                         return int(i);
619                 }
620             }
621             return -1;
622         }
623     }
624 
625     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
626         bytes memory _ba = bytes(_a);
627         bytes memory _bb = bytes(_b);
628         bytes memory _bc = bytes(_c);
629         bytes memory _bd = bytes(_d);
630         bytes memory _be = bytes(_e);
631         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
632         bytes memory babcde = bytes(abcde);
633         uint k = 0;
634         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
635         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
636         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
637         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
638         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
639         return string(babcde);
640     }
641 
642     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
643         return strConcat(_a, _b, _c, _d, "");
644     }
645 
646     function strConcat(string _a, string _b, string _c) internal returns (string) {
647         return strConcat(_a, _b, _c, "", "");
648     }
649 
650     function strConcat(string _a, string _b) internal returns (string) {
651         return strConcat(_a, _b, "", "", "");
652     }
653 
654     // parseInt
655     function parseInt(string _a) internal returns (uint) {
656         return parseInt(_a, 0);
657     }
658 
659     // parseInt(parseFloat*10^_b)
660     function parseInt(string _a, uint _b) internal returns (uint) {
661         bytes memory bresult = bytes(_a);
662         uint mint = 0;
663         bool decimals = false;
664         for (uint i=0; i<bresult.length; i++){
665             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
666                 if (decimals){
667                    if (_b == 0) break;
668                     else _b--;
669                 }
670                 mint *= 10;
671                 mint += uint(bresult[i]) - 48;
672             } else if (bresult[i] == 46) decimals = true;
673         }
674         if (_b > 0) mint *= 10**_b;
675         return mint;
676     }
677 
678     function uint2str(uint i) internal returns (string){
679         if (i == 0) return "0";
680         uint j = i;
681         uint len;
682         while (j != 0){
683             len++;
684             j /= 10;
685         }
686         bytes memory bstr = new bytes(len);
687         uint k = len - 1;
688         while (i != 0){
689             bstr[k--] = byte(48 + i % 10);
690             i /= 10;
691         }
692         return string(bstr);
693     }
694     
695     function stra2cbor(string[] arr) internal returns (bytes) {
696             uint arrlen = arr.length;
697 
698             // get correct cbor output length
699             uint outputlen = 0;
700             bytes[] memory elemArray = new bytes[](arrlen);
701             for (uint i = 0; i < arrlen; i++) {
702                 elemArray[i] = (bytes(arr[i]));
703                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
704             }
705             uint ctr = 0;
706             uint cborlen = arrlen + 0x80;
707             outputlen += byte(cborlen).length;
708             bytes memory res = new bytes(outputlen);
709 
710             while (byte(cborlen).length > ctr) {
711                 res[ctr] = byte(cborlen)[ctr];
712                 ctr++;
713             }
714             for (i = 0; i < arrlen; i++) {
715                 res[ctr] = 0x5F;
716                 ctr++;
717                 for (uint x = 0; x < elemArray[i].length; x++) {
718                     // if there's a bug with larger strings, this may be the culprit
719                     if (x % 23 == 0) {
720                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
721                         elemcborlen += 0x40;
722                         uint lctr = ctr;
723                         while (byte(elemcborlen).length > ctr - lctr) {
724                             res[ctr] = byte(elemcborlen)[ctr - lctr];
725                             ctr++;
726                         }
727                     }
728                     res[ctr] = elemArray[i][x];
729                     ctr++;
730                 }
731                 res[ctr] = 0xFF;
732                 ctr++;
733             }
734             return res;
735         }
736 
737     function ba2cbor(bytes[] arr) internal returns (bytes) {
738             uint arrlen = arr.length;
739 
740             // get correct cbor output length
741             uint outputlen = 0;
742             bytes[] memory elemArray = new bytes[](arrlen);
743             for (uint i = 0; i < arrlen; i++) {
744                 elemArray[i] = (bytes(arr[i]));
745                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
746             }
747             uint ctr = 0;
748             uint cborlen = arrlen + 0x80;
749             outputlen += byte(cborlen).length;
750             bytes memory res = new bytes(outputlen);
751 
752             while (byte(cborlen).length > ctr) {
753                 res[ctr] = byte(cborlen)[ctr];
754                 ctr++;
755             }
756             for (i = 0; i < arrlen; i++) {
757                 res[ctr] = 0x5F;
758                 ctr++;
759                 for (uint x = 0; x < elemArray[i].length; x++) {
760                     // if there's a bug with larger strings, this may be the culprit
761                     if (x % 23 == 0) {
762                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
763                         elemcborlen += 0x40;
764                         uint lctr = ctr;
765                         while (byte(elemcborlen).length > ctr - lctr) {
766                             res[ctr] = byte(elemcborlen)[ctr - lctr];
767                             ctr++;
768                         }
769                     }
770                     res[ctr] = elemArray[i][x];
771                     ctr++;
772                 }
773                 res[ctr] = 0xFF;
774                 ctr++;
775             }
776             return res;
777         }
778         
779         
780     string oraclize_network_name;
781     function oraclize_setNetworkName(string _network_name) internal {
782         oraclize_network_name = _network_name;
783     }
784     
785     function oraclize_getNetworkName() internal returns (string) {
786         return oraclize_network_name;
787     }
788     
789     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
790         if ((_nbytes == 0)||(_nbytes > 32)) throw;
791         bytes memory nbytes = new bytes(1);
792         nbytes[0] = byte(_nbytes);
793         bytes memory unonce = new bytes(32);
794         bytes memory sessionKeyHash = new bytes(32);
795         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
796         assembly {
797             mstore(unonce, 0x20)
798             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
799             mstore(sessionKeyHash, 0x20)
800             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
801         }
802         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
803         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
804         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
805         return queryId;
806     }
807     
808     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
809         oraclize_randomDS_args[queryId] = commitment;
810     }
811     
812     mapping(bytes32=>bytes32) oraclize_randomDS_args;
813     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
814 
815     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
816         bool sigok;
817         address signer;
818         
819         bytes32 sigr;
820         bytes32 sigs;
821         
822         bytes memory sigr_ = new bytes(32);
823         uint offset = 4+(uint(dersig[3]) - 0x20);
824         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
825         bytes memory sigs_ = new bytes(32);
826         offset += 32 + 2;
827         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
828 
829         assembly {
830             sigr := mload(add(sigr_, 32))
831             sigs := mload(add(sigs_, 32))
832         }
833         
834         
835         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
836         if (address(sha3(pubkey)) == signer) return true;
837         else {
838             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
839             return (address(sha3(pubkey)) == signer);
840         }
841     }
842 
843     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
844         bool sigok;
845         
846         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
847         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
848         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
849         
850         bytes memory appkey1_pubkey = new bytes(64);
851         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
852         
853         bytes memory tosign2 = new bytes(1+65+32);
854         tosign2[0] = 1; //role
855         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
856         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
857         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
858         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
859         
860         if (sigok == false) return false;
861         
862         
863         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
864         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
865         
866         bytes memory tosign3 = new bytes(1+65);
867         tosign3[0] = 0xFE;
868         copyBytes(proof, 3, 65, tosign3, 1);
869         
870         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
871         copyBytes(proof, 3+65, sig3.length, sig3, 0);
872         
873         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
874         
875         return sigok;
876     }
877     
878     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
879         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
880         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
881         
882         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
883         if (proofVerified == false) throw;
884         
885         _;
886     }
887     
888     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
889         bool match_ = true;
890         
891         for (var i=0; i<prefix.length; i++){
892             if (content[i] != prefix[i]) match_ = false;
893         }
894         
895         return match_;
896     }
897 
898     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
899         bool checkok;
900         
901         
902         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
903         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
904         bytes memory keyhash = new bytes(32);
905         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
906         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
907         if (checkok == false) return false;
908         
909         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
910         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
911         
912         
913         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
914         checkok = matchBytes32Prefix(sha256(sig1), result);
915         if (checkok == false) return false;
916         
917         
918         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
919         // This is to verify that the computed args match with the ones specified in the query.
920         bytes memory commitmentSlice1 = new bytes(8+1+32);
921         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
922         
923         bytes memory sessionPubkey = new bytes(64);
924         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
925         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
926         
927         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
928         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
929             delete oraclize_randomDS_args[queryId];
930         } else return false;
931         
932         
933         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
934         bytes memory tosign1 = new bytes(32+8+1+32);
935         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
936         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
937         if (checkok == false) return false;
938         
939         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
940         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
941             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
942         }
943         
944         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
945     }
946 
947     
948     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
949     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
950         uint minLength = length + toOffset;
951 
952         if (to.length < minLength) {
953             // Buffer too small
954             throw; // Should be a better way?
955         }
956 
957         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
958         uint i = 32 + fromOffset;
959         uint j = 32 + toOffset;
960 
961         while (i < (32 + fromOffset + length)) {
962             assembly {
963                 let tmp := mload(add(from, i))
964                 mstore(add(to, j), tmp)
965             }
966             i += 32;
967             j += 32;
968         }
969 
970         return to;
971     }
972     
973     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
974     // Duplicate Solidity's ecrecover, but catching the CALL return value
975     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
976         // We do our own memory management here. Solidity uses memory offset
977         // 0x40 to store the current end of memory. We write past it (as
978         // writes are memory extensions), but don't update the offset so
979         // Solidity will reuse it. The memory used here is only needed for
980         // this context.
981 
982         // FIXME: inline assembly can't access return values
983         bool ret;
984         address addr;
985 
986         assembly {
987             let size := mload(0x40)
988             mstore(size, hash)
989             mstore(add(size, 32), v)
990             mstore(add(size, 64), r)
991             mstore(add(size, 96), s)
992 
993             // NOTE: we can reuse the request memory because we deal with
994             //       the return code
995             ret := call(3000, 1, 0, size, 128, size, 32)
996             addr := mload(size)
997         }
998   
999         return (ret, addr);
1000     }
1001 
1002     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1003     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1004         bytes32 r;
1005         bytes32 s;
1006         uint8 v;
1007 
1008         if (sig.length != 65)
1009           return (false, 0);
1010 
1011         // The signature format is a compact form of:
1012         //   {bytes32 r}{bytes32 s}{uint8 v}
1013         // Compact means, uint8 is not padded to 32 bytes.
1014         assembly {
1015             r := mload(add(sig, 32))
1016             s := mload(add(sig, 64))
1017 
1018             // Here we are loading the last 32 bytes. We exploit the fact that
1019             // 'mload' will pad with zeroes if we overread.
1020             // There is no 'mload8' to do this, but that would be nicer.
1021             v := byte(0, mload(add(sig, 96)))
1022 
1023             // Alternative solution:
1024             // 'byte' is not working due to the Solidity parser, so lets
1025             // use the second best option, 'and'
1026             // v := and(mload(add(sig, 65)), 255)
1027         }
1028 
1029         // albeit non-transactional signatures are not specified by the YP, one would expect it
1030         // to match the YP range of [27, 28]
1031         //
1032         // geth uses [0, 1] and some clients have followed. This might change, see:
1033         //  https://github.com/ethereum/go-ethereum/issues/2053
1034         if (v < 27)
1035           v += 27;
1036 
1037         if (v != 27 && v != 28)
1038             return (false, 0);
1039 
1040         return safer_ecrecover(hash, v, r, s);
1041     }
1042         
1043 }
1044 // </ORACLIZE_API>
1045 
1046 contract BettingControllerInterface {
1047     function remoteBettingClose() external;
1048     function depositHouseTakeout() external payable;
1049 }
1050 
1051 contract Betting is usingOraclize {
1052     using SafeMath for uint256; //using safemath
1053 
1054     uint countdown=3; // variable to check if all prices are received
1055     address public owner; //owner address
1056     
1057     uint public winnerPoolTotal;
1058     string public constant version = "0.2.2";
1059     
1060     BettingControllerInterface internal bettingControllerInstance;
1061     
1062     struct chronus_info {
1063         bool  betting_open; // boolean: check if betting is open
1064         bool  race_start; //boolean: check if race has started
1065         bool  race_end; //boolean: check if race has ended
1066         bool  voided_bet; //boolean: check if race has been voided
1067         uint32  starting_time; // timestamp of when the race starts
1068         uint32  betting_duration;
1069         uint32  race_duration; // duration of the race
1070         uint32 voided_timestamp;
1071     }
1072     
1073     struct horses_info{
1074         int32  BTC_delta; //horses.BTC delta value
1075         int32  ETH_delta; //horses.ETH delta value
1076         int32  LTC_delta; //horses.LTC delta value
1077         bytes32 BTC; //32-bytes equivalent of horses.BTC
1078         bytes32 ETH; //32-bytes equivalent of horses.ETH
1079         bytes32 LTC;  //32-bytes equivalent of horses.LTC
1080         uint customGasLimit;
1081     }
1082 
1083     struct bet_info{
1084         bytes32 horse; // coin on which amount is bet on
1085         uint amount; // amount bet by Bettor
1086     }
1087     struct coin_info{
1088         uint256 pre; // locking price
1089         uint256 post; // ending price
1090         uint160 total; // total coin pool
1091         uint32 count; // number of bets
1092         bool price_check;
1093         bytes32 preOraclizeId;
1094         bytes32 postOraclizeId;
1095     }
1096     struct voter_info {
1097         uint160 total_bet; //total amount of bet placed
1098         bool rewarded; // boolean: check for double spending
1099         mapping(bytes32=>uint) bets; //array of bets
1100     }
1101     
1102 
1103     mapping (bytes32 => bytes32) oraclizeIndex; // mapping oraclize IDs with coins
1104     mapping (bytes32 => coin_info) coinIndex; // mapping coins with pool information
1105     mapping (address => voter_info) voterIndex; // mapping voter address with Bettor information
1106 
1107     uint public total_reward; // total reward to be awarded
1108     uint32 total_bettors;
1109     mapping (bytes32 => bool) public winner_horse;
1110 
1111 
1112     // tracking events
1113     event newOraclizeQuery(string description);
1114     event newPriceTicker(uint price);
1115     event Deposit(address _from, uint256 _value, bytes32 _horse, uint256 _date);
1116     event Withdraw(address _to, uint256 _value);
1117 
1118     // constructor
1119     function Betting() public payable {
1120         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1121         owner = msg.sender;
1122         // oraclize_setCustomGasPrice(10000000000 wei);
1123         horses.BTC = bytes32("BTC");
1124         horses.ETH = bytes32("ETH");
1125         horses.LTC = bytes32("LTC");
1126         horses.customGasLimit = 300000;
1127         bettingControllerInstance = BettingControllerInterface(owner);
1128     }
1129 
1130     // data access structures
1131     horses_info public horses;
1132     chronus_info public chronus;
1133     
1134     // modifiers for restricting access to methods
1135     modifier onlyOwner {
1136         require(owner == msg.sender);
1137         _;
1138     }
1139 
1140     modifier duringBetting {
1141         require(chronus.betting_open);
1142         _;
1143     }
1144     
1145     modifier beforeBetting {
1146         require(!chronus.betting_open && !chronus.race_start);
1147         _;
1148     }
1149 
1150     modifier afterRace {
1151         require(chronus.race_end);
1152         _;
1153     }
1154     
1155     //function to change owner
1156     function changeOwnership(address _newOwner) onlyOwner external {
1157         owner = _newOwner;
1158     }
1159 
1160     //oraclize callback method
1161     function __callback(bytes32 myid, string result, bytes proof) public {
1162         require (msg.sender == oraclize_cbAddress());
1163         require (!chronus.race_end);
1164         bytes32 coin_pointer; // variable to differentiate different callbacks
1165         chronus.race_start = true;
1166         chronus.betting_open = false;
1167         bettingControllerInstance.remoteBettingClose();
1168         coin_pointer = oraclizeIndex[myid];
1169 
1170         if (myid == coinIndex[coin_pointer].preOraclizeId) {
1171             if (now >= chronus.starting_time+chronus.betting_duration+ 5 minutes) {
1172                 forceVoidRace();
1173             } else {
1174                 coinIndex[coin_pointer].pre = stringToUintNormalize(result);
1175                 emit newPriceTicker(coinIndex[coin_pointer].pre);
1176             }
1177         } else if (myid == coinIndex[coin_pointer].postOraclizeId){
1178             if (coinIndex[coin_pointer].pre > 0 ){
1179                 if (now >= chronus.starting_time+chronus.race_duration+ 5 minutes) {
1180                     forceVoidRace();
1181                 } else {
1182                     coinIndex[coin_pointer].post = stringToUintNormalize(result);
1183                     coinIndex[coin_pointer].price_check = true;
1184                     emit newPriceTicker(coinIndex[coin_pointer].post);
1185                     
1186                     if (coinIndex[horses.ETH].price_check && coinIndex[horses.BTC].price_check && coinIndex[horses.LTC].price_check) {
1187                         reward();
1188                     }
1189                 }
1190             } else {
1191                 forceVoidRace();
1192             }
1193         }
1194     }
1195 
1196     // place a bet on a coin(horse) lockBetting
1197     function placeBet(bytes32 horse) external duringBetting payable  {
1198         require(msg.value >= 0.01 ether);
1199         if (voterIndex[msg.sender].total_bet==0) {
1200             total_bettors+=1;
1201         }
1202         uint _newAmount = voterIndex[msg.sender].bets[horse] + msg.value;
1203         voterIndex[msg.sender].bets[horse] = _newAmount;
1204         voterIndex[msg.sender].total_bet += uint160(msg.value);
1205         uint160 _newTotal = coinIndex[horse].total + uint160(msg.value); 
1206         uint32 _newCount = coinIndex[horse].count + 1;
1207         coinIndex[horse].total = _newTotal;
1208         coinIndex[horse].count = _newCount;
1209         emit Deposit(msg.sender, msg.value, horse, now);
1210     }
1211 
1212     // fallback method for accepting payments
1213     function () private payable {}
1214 
1215     // method to place the oraclize queries
1216     function setupRace(uint delay, uint  locking_duration) onlyOwner beforeBetting public payable returns(bool) {
1217         // if (oraclize_getPrice("URL") > (this.balance)/6) {
1218         if (oraclize_getPrice("URL")*3 + oraclize_getPrice("URL", horses.customGasLimit)*3  > address(this).balance) {
1219             emit newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1220             return false;
1221         } else {
1222             chronus.starting_time = uint32(block.timestamp);
1223             chronus.betting_open = true;
1224             bytes32 temp_ID; // temp variable to store oraclize IDs
1225             emit newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1226             // bets open price query
1227             chronus.betting_duration = uint32(delay);
1228             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd");
1229             oraclizeIndex[temp_ID] = horses.ETH;
1230             coinIndex[horses.ETH].preOraclizeId = temp_ID;
1231 
1232             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/litecoin/).0.price_usd");
1233             oraclizeIndex[temp_ID] = horses.LTC;
1234             coinIndex[horses.LTC].preOraclizeId = temp_ID;
1235 
1236             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/bitcoin/).0.price_usd");
1237             oraclizeIndex[temp_ID] = horses.BTC;
1238             coinIndex[horses.BTC].preOraclizeId = temp_ID;
1239 
1240             //bets closing price query
1241             delay = delay.add(locking_duration);
1242 
1243             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd",horses.customGasLimit);
1244             oraclizeIndex[temp_ID] = horses.ETH;
1245             coinIndex[horses.ETH].postOraclizeId = temp_ID;
1246 
1247             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/litecoin/).0.price_usd",horses.customGasLimit);
1248             oraclizeIndex[temp_ID] = horses.LTC;
1249             coinIndex[horses.LTC].postOraclizeId = temp_ID;
1250 
1251             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/bitcoin/).0.price_usd",horses.customGasLimit);
1252             oraclizeIndex[temp_ID] = horses.BTC;
1253             coinIndex[horses.BTC].postOraclizeId = temp_ID;
1254 
1255             chronus.race_duration = uint32(delay);
1256             return true;
1257         }
1258     }
1259 
1260     // method to calculate reward (called internally by callback)
1261     function reward() internal {
1262         /*
1263         calculating the difference in price with a precision of 5 digits
1264         not using safemath since signed integers are handled
1265         */
1266         horses.BTC_delta = int32(coinIndex[horses.BTC].post - coinIndex[horses.BTC].pre)*100000/int32(coinIndex[horses.BTC].pre);
1267         horses.ETH_delta = int32(coinIndex[horses.ETH].post - coinIndex[horses.ETH].pre)*100000/int32(coinIndex[horses.ETH].pre);
1268         horses.LTC_delta = int32(coinIndex[horses.LTC].post - coinIndex[horses.LTC].pre)*100000/int32(coinIndex[horses.LTC].pre);
1269         
1270         total_reward = (coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total);
1271         if (total_bettors <= 1) {
1272             forceVoidRace();
1273         } else {
1274             uint house_fee = total_reward.mul(5).div(100);
1275             require(house_fee < address(this).balance);
1276             total_reward = total_reward.sub(house_fee); 
1277             bettingControllerInstance.depositHouseTakeout.value(house_fee)();
1278         }
1279         
1280         if (horses.BTC_delta > horses.ETH_delta) {
1281             if (horses.BTC_delta > horses.LTC_delta) {
1282                 winner_horse[horses.BTC] = true;
1283                 winnerPoolTotal = coinIndex[horses.BTC].total;
1284             }
1285             else if(horses.LTC_delta > horses.BTC_delta) {
1286                 winner_horse[horses.LTC] = true;
1287                 winnerPoolTotal = coinIndex[horses.LTC].total;
1288             } else {
1289                 winner_horse[horses.BTC] = true;
1290                 winner_horse[horses.LTC] = true;
1291                 winnerPoolTotal = coinIndex[horses.BTC].total + (coinIndex[horses.LTC].total);
1292             }
1293         } else if(horses.ETH_delta > horses.BTC_delta) {
1294             if (horses.ETH_delta > horses.LTC_delta) {
1295                 winner_horse[horses.ETH] = true;
1296                 winnerPoolTotal = coinIndex[horses.ETH].total;
1297             }
1298             else if (horses.LTC_delta > horses.ETH_delta) {
1299                 winner_horse[horses.LTC] = true;
1300                 winnerPoolTotal = coinIndex[horses.LTC].total;
1301             } else {
1302                 winner_horse[horses.ETH] = true;
1303                 winner_horse[horses.LTC] = true;
1304                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.LTC].total);
1305             }
1306         } else {
1307             if (horses.LTC_delta > horses.ETH_delta) {
1308                 winner_horse[horses.LTC] = true;
1309                 winnerPoolTotal = coinIndex[horses.LTC].total;
1310             } else if(horses.LTC_delta < horses.ETH_delta){
1311                 winner_horse[horses.ETH] = true;
1312                 winner_horse[horses.BTC] = true;
1313                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total);
1314             } else {
1315                 winner_horse[horses.LTC] = true;
1316                 winner_horse[horses.ETH] = true;
1317                 winner_horse[horses.BTC] = true;
1318                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total) + (coinIndex[horses.LTC].total);
1319             }
1320         }
1321         chronus.race_end = true;
1322     }
1323 
1324     // method to calculate an invidual's reward
1325     function calculateReward(address candidate) internal afterRace constant returns(uint winner_reward) {
1326         voter_info storage bettor = voterIndex[candidate];
1327         if(chronus.voided_bet) {
1328             winner_reward = bettor.total_bet;
1329         } else {
1330             uint winning_bet_total;
1331             if(winner_horse[horses.BTC]) {
1332                 winning_bet_total += bettor.bets[horses.BTC];
1333             } if(winner_horse[horses.ETH]) {
1334                 winning_bet_total += bettor.bets[horses.ETH];
1335             } if(winner_horse[horses.LTC]) {
1336                 winning_bet_total += bettor.bets[horses.LTC];
1337             }
1338             winner_reward += (((total_reward.mul(10000000)).div(winnerPoolTotal)).mul(winning_bet_total)).div(10000000);
1339         } 
1340     }
1341 
1342     // method to just check the reward amount
1343     function checkReward() afterRace external constant returns (uint) {
1344         require(!voterIndex[msg.sender].rewarded);
1345         return calculateReward(msg.sender);
1346     }
1347 
1348     // method to claim the reward amount
1349     function claim_reward() afterRace external {
1350         require(!voterIndex[msg.sender].rewarded);
1351         uint transfer_amount = calculateReward(msg.sender);
1352         require(address(this).balance >= transfer_amount);
1353         voterIndex[msg.sender].rewarded = true;
1354         msg.sender.transfer(transfer_amount);
1355         emit Withdraw(msg.sender, transfer_amount);
1356     }
1357     
1358     function forceVoidRace() internal {
1359         chronus.voided_bet=true;
1360         chronus.race_end = true;
1361         chronus.voided_timestamp=uint32(now);
1362     }
1363 
1364     // utility function to convert string to integer with precision consideration
1365     function stringToUintNormalize(string s) internal pure returns (uint result) {
1366         uint p =2;
1367         bool precision=false;
1368         bytes memory b = bytes(s);
1369         uint i;
1370         result = 0;
1371         for (i = 0; i < b.length; i++) {
1372             if (precision) {p = p-1;}
1373             if (uint(b[i]) == 46){precision = true;}
1374             uint c = uint(b[i]);
1375             if (c >= 48 && c <= 57) {result = result * 10 + (c - 48);}
1376             if (precision && p == 0){return result;}
1377         }
1378         while (p!=0) {
1379             result = result*10;
1380             p=p-1;
1381         }
1382     }
1383 
1384 
1385     // exposing the coin pool details for DApp
1386     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {
1387         return (coinIndex[index].total, coinIndex[index].pre, coinIndex[index].post, coinIndex[index].price_check, voterIndex[candidate].bets[index]);
1388     }
1389 
1390     // exposing the total reward amount for DApp
1391     function reward_total() external constant returns (uint) {
1392         return ((coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total));
1393     }
1394     
1395     // in case of any errors in race, enable full refund for the Bettors to claim
1396     function refund() external onlyOwner {
1397         require(now > chronus.starting_time + chronus.race_duration);
1398         require((chronus.betting_open && !chronus.race_start)
1399             || (chronus.race_start && !chronus.race_end));
1400         chronus.voided_bet = true;
1401         chronus.race_end = true;
1402         chronus.voided_timestamp=uint32(now);
1403         bettingControllerInstance.remoteBettingClose();
1404     }
1405 
1406     // method to claim unclaimed winnings after 30 day notice period
1407     function recovery() external onlyOwner{
1408         require((chronus.race_end && now > chronus.starting_time + chronus.race_duration + (30 days))
1409             || (chronus.voided_bet && now > chronus.voided_timestamp + (30 days)));
1410         bettingControllerInstance.depositHouseTakeout.value(address(this).balance)();
1411     }
1412 }