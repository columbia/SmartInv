1 pragma solidity ^0.4.19;
2 
3 // <ORACLIZE_API>
4 /*
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 
8 
9 
10 Permission is hereby granted, free of charge, to any person obtaining a copy
11 of this software and associated documentation files (the "Software"), to deal
12 in the Software without restriction, including without limitation the rights
13 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14 copies of the Software, and to permit persons to whom the Software is
15 furnished to do so, subject to the following conditions:
16 
17 
18 
19 The above copyright notice and this permission notice shall be included in
20 all copies or substantial portions of the Software.
21 
22 
23 
24 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
25 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
26 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
27 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
28 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
29 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
30 THE SOFTWARE.
31 */
32 
33 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
34 
35 contract OraclizeI {
36     address public cbAddress;
37     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
39     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
40     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
41     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
42     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
43     function getPrice(string _datasource) returns (uint _dsprice);
44     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
45     function useCoupon(string _coupon);
46     function setProofType(byte _proofType);
47     function setConfig(bytes32 _config);
48     function setCustomGasPrice(uint _gasPrice);
49     function randomDS_getSessionPubKeyHash() returns(bytes32);
50 }
51 contract OraclizeAddrResolverI {
52     function getAddress() returns (address _addr);
53 }
54 contract usingOraclize {
55     uint constant day = 60*60*24;
56     uint constant week = 60*60*24*7;
57     uint constant month = 60*60*24*30;
58     byte constant proofType_NONE = 0x00;
59     byte constant proofType_TLSNotary = 0x10;
60     byte constant proofType_Android = 0x20;
61     byte constant proofType_Ledger = 0x30;
62     byte constant proofType_Native = 0xF0;
63     byte constant proofStorage_IPFS = 0x01;
64     uint8 constant networkID_auto = 0;
65     uint8 constant networkID_mainnet = 1;
66     uint8 constant networkID_testnet = 2;
67     uint8 constant networkID_morden = 2;
68     uint8 constant networkID_consensys = 161;
69 
70     OraclizeAddrResolverI OAR;
71 
72     OraclizeI oraclize;
73     modifier oraclizeAPI {
74         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
75             oraclize_setNetwork(networkID_auto);
76 
77         if(address(oraclize) != OAR.getAddress())
78             oraclize = OraclizeI(OAR.getAddress());
79 
80         _;
81     }
82     modifier coupon(string code){
83         oraclize = OraclizeI(OAR.getAddress());
84         oraclize.useCoupon(code);
85         _;
86     }
87 
88     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
89         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
90             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
91             oraclize_setNetworkName("eth_mainnet");
92             return true;
93         }
94         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
95             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
96             oraclize_setNetworkName("eth_ropsten3");
97             return true;
98         }
99         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
100             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
101             oraclize_setNetworkName("eth_kovan");
102             return true;
103         }
104         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
105             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
106             oraclize_setNetworkName("eth_rinkeby");
107             return true;
108         }
109         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
110             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
111             return true;
112         }
113         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
114             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
115             return true;
116         }
117         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
118             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
119             return true;
120         }
121         return false;
122     }
123 
124     function __callback(bytes32 myid, string result) {
125         __callback(myid, result, new bytes(0));
126     }
127     function __callback(bytes32 myid, string result, bytes proof) {
128     }
129 
130     function oraclize_useCoupon(string code) oraclizeAPI internal {
131         oraclize.useCoupon(code);
132     }
133 
134     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
135         return oraclize.getPrice(datasource);
136     }
137 
138     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
139         return oraclize.getPrice(datasource, gaslimit);
140     }
141 
142     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
143         uint price = oraclize.getPrice(datasource);
144         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
145         return oraclize.query.value(price)(0, datasource, arg);
146     }
147     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
148         uint price = oraclize.getPrice(datasource);
149         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
150         return oraclize.query.value(price)(timestamp, datasource, arg);
151     }
152     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
153         uint price = oraclize.getPrice(datasource, gaslimit);
154         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
155         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
156     }
157     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
158         uint price = oraclize.getPrice(datasource, gaslimit);
159         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
160         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
161     }
162     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
163         uint price = oraclize.getPrice(datasource);
164         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
165         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
166     }
167     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
168         uint price = oraclize.getPrice(datasource);
169         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
170         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
171     }
172     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
173         uint price = oraclize.getPrice(datasource, gaslimit);
174         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
175         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
176     }
177     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
178         uint price = oraclize.getPrice(datasource, gaslimit);
179         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
180         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
181     }
182     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
183         uint price = oraclize.getPrice(datasource);
184         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
185         bytes memory args = stra2cbor(argN);
186         return oraclize.queryN.value(price)(0, datasource, args);
187     }
188     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
189         uint price = oraclize.getPrice(datasource);
190         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
191         bytes memory args = stra2cbor(argN);
192         return oraclize.queryN.value(price)(timestamp, datasource, args);
193     }
194     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
195         uint price = oraclize.getPrice(datasource, gaslimit);
196         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
197         bytes memory args = stra2cbor(argN);
198         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
199     }
200     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
201         uint price = oraclize.getPrice(datasource, gaslimit);
202         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
203         bytes memory args = stra2cbor(argN);
204         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
205     }
206     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
207         string[] memory dynargs = new string[](1);
208         dynargs[0] = args[0];
209         return oraclize_query(datasource, dynargs);
210     }
211     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
212         string[] memory dynargs = new string[](1);
213         dynargs[0] = args[0];
214         return oraclize_query(timestamp, datasource, dynargs);
215     }
216     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
217         string[] memory dynargs = new string[](1);
218         dynargs[0] = args[0];
219         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
220     }
221     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
222         string[] memory dynargs = new string[](1);
223         dynargs[0] = args[0];
224         return oraclize_query(datasource, dynargs, gaslimit);
225     }
226 
227     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
228         string[] memory dynargs = new string[](2);
229         dynargs[0] = args[0];
230         dynargs[1] = args[1];
231         return oraclize_query(datasource, dynargs);
232     }
233     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
234         string[] memory dynargs = new string[](2);
235         dynargs[0] = args[0];
236         dynargs[1] = args[1];
237         return oraclize_query(timestamp, datasource, dynargs);
238     }
239     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
240         string[] memory dynargs = new string[](2);
241         dynargs[0] = args[0];
242         dynargs[1] = args[1];
243         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
244     }
245     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
246         string[] memory dynargs = new string[](2);
247         dynargs[0] = args[0];
248         dynargs[1] = args[1];
249         return oraclize_query(datasource, dynargs, gaslimit);
250     }
251     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
252         string[] memory dynargs = new string[](3);
253         dynargs[0] = args[0];
254         dynargs[1] = args[1];
255         dynargs[2] = args[2];
256         return oraclize_query(datasource, dynargs);
257     }
258     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
259         string[] memory dynargs = new string[](3);
260         dynargs[0] = args[0];
261         dynargs[1] = args[1];
262         dynargs[2] = args[2];
263         return oraclize_query(timestamp, datasource, dynargs);
264     }
265     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
266         string[] memory dynargs = new string[](3);
267         dynargs[0] = args[0];
268         dynargs[1] = args[1];
269         dynargs[2] = args[2];
270         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
271     }
272     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
273         string[] memory dynargs = new string[](3);
274         dynargs[0] = args[0];
275         dynargs[1] = args[1];
276         dynargs[2] = args[2];
277         return oraclize_query(datasource, dynargs, gaslimit);
278     }
279 
280     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
281         string[] memory dynargs = new string[](4);
282         dynargs[0] = args[0];
283         dynargs[1] = args[1];
284         dynargs[2] = args[2];
285         dynargs[3] = args[3];
286         return oraclize_query(datasource, dynargs);
287     }
288     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
289         string[] memory dynargs = new string[](4);
290         dynargs[0] = args[0];
291         dynargs[1] = args[1];
292         dynargs[2] = args[2];
293         dynargs[3] = args[3];
294         return oraclize_query(timestamp, datasource, dynargs);
295     }
296     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
297         string[] memory dynargs = new string[](4);
298         dynargs[0] = args[0];
299         dynargs[1] = args[1];
300         dynargs[2] = args[2];
301         dynargs[3] = args[3];
302         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
303     }
304     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
305         string[] memory dynargs = new string[](4);
306         dynargs[0] = args[0];
307         dynargs[1] = args[1];
308         dynargs[2] = args[2];
309         dynargs[3] = args[3];
310         return oraclize_query(datasource, dynargs, gaslimit);
311     }
312     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
313         string[] memory dynargs = new string[](5);
314         dynargs[0] = args[0];
315         dynargs[1] = args[1];
316         dynargs[2] = args[2];
317         dynargs[3] = args[3];
318         dynargs[4] = args[4];
319         return oraclize_query(datasource, dynargs);
320     }
321     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
322         string[] memory dynargs = new string[](5);
323         dynargs[0] = args[0];
324         dynargs[1] = args[1];
325         dynargs[2] = args[2];
326         dynargs[3] = args[3];
327         dynargs[4] = args[4];
328         return oraclize_query(timestamp, datasource, dynargs);
329     }
330     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
331         string[] memory dynargs = new string[](5);
332         dynargs[0] = args[0];
333         dynargs[1] = args[1];
334         dynargs[2] = args[2];
335         dynargs[3] = args[3];
336         dynargs[4] = args[4];
337         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
338     }
339     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
340         string[] memory dynargs = new string[](5);
341         dynargs[0] = args[0];
342         dynargs[1] = args[1];
343         dynargs[2] = args[2];
344         dynargs[3] = args[3];
345         dynargs[4] = args[4];
346         return oraclize_query(datasource, dynargs, gaslimit);
347     }
348     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
349         uint price = oraclize.getPrice(datasource);
350         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
351         bytes memory args = ba2cbor(argN);
352         return oraclize.queryN.value(price)(0, datasource, args);
353     }
354     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
355         uint price = oraclize.getPrice(datasource);
356         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
357         bytes memory args = ba2cbor(argN);
358         return oraclize.queryN.value(price)(timestamp, datasource, args);
359     }
360     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
361         uint price = oraclize.getPrice(datasource, gaslimit);
362         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
363         bytes memory args = ba2cbor(argN);
364         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
365     }
366     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
367         uint price = oraclize.getPrice(datasource, gaslimit);
368         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
369         bytes memory args = ba2cbor(argN);
370         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
371     }
372     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
373         bytes[] memory dynargs = new bytes[](1);
374         dynargs[0] = args[0];
375         return oraclize_query(datasource, dynargs);
376     }
377     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
378         bytes[] memory dynargs = new bytes[](1);
379         dynargs[0] = args[0];
380         return oraclize_query(timestamp, datasource, dynargs);
381     }
382     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
383         bytes[] memory dynargs = new bytes[](1);
384         dynargs[0] = args[0];
385         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
386     }
387     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
388         bytes[] memory dynargs = new bytes[](1);
389         dynargs[0] = args[0];
390         return oraclize_query(datasource, dynargs, gaslimit);
391     }
392 
393     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
394         bytes[] memory dynargs = new bytes[](2);
395         dynargs[0] = args[0];
396         dynargs[1] = args[1];
397         return oraclize_query(datasource, dynargs);
398     }
399     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
400         bytes[] memory dynargs = new bytes[](2);
401         dynargs[0] = args[0];
402         dynargs[1] = args[1];
403         return oraclize_query(timestamp, datasource, dynargs);
404     }
405     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
406         bytes[] memory dynargs = new bytes[](2);
407         dynargs[0] = args[0];
408         dynargs[1] = args[1];
409         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
410     }
411     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
412         bytes[] memory dynargs = new bytes[](2);
413         dynargs[0] = args[0];
414         dynargs[1] = args[1];
415         return oraclize_query(datasource, dynargs, gaslimit);
416     }
417     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
418         bytes[] memory dynargs = new bytes[](3);
419         dynargs[0] = args[0];
420         dynargs[1] = args[1];
421         dynargs[2] = args[2];
422         return oraclize_query(datasource, dynargs);
423     }
424     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
425         bytes[] memory dynargs = new bytes[](3);
426         dynargs[0] = args[0];
427         dynargs[1] = args[1];
428         dynargs[2] = args[2];
429         return oraclize_query(timestamp, datasource, dynargs);
430     }
431     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
432         bytes[] memory dynargs = new bytes[](3);
433         dynargs[0] = args[0];
434         dynargs[1] = args[1];
435         dynargs[2] = args[2];
436         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
437     }
438     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
439         bytes[] memory dynargs = new bytes[](3);
440         dynargs[0] = args[0];
441         dynargs[1] = args[1];
442         dynargs[2] = args[2];
443         return oraclize_query(datasource, dynargs, gaslimit);
444     }
445 
446     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
447         bytes[] memory dynargs = new bytes[](4);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         dynargs[2] = args[2];
451         dynargs[3] = args[3];
452         return oraclize_query(datasource, dynargs);
453     }
454     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
455         bytes[] memory dynargs = new bytes[](4);
456         dynargs[0] = args[0];
457         dynargs[1] = args[1];
458         dynargs[2] = args[2];
459         dynargs[3] = args[3];
460         return oraclize_query(timestamp, datasource, dynargs);
461     }
462     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
463         bytes[] memory dynargs = new bytes[](4);
464         dynargs[0] = args[0];
465         dynargs[1] = args[1];
466         dynargs[2] = args[2];
467         dynargs[3] = args[3];
468         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
469     }
470     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
471         bytes[] memory dynargs = new bytes[](4);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         dynargs[2] = args[2];
475         dynargs[3] = args[3];
476         return oraclize_query(datasource, dynargs, gaslimit);
477     }
478     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
479         bytes[] memory dynargs = new bytes[](5);
480         dynargs[0] = args[0];
481         dynargs[1] = args[1];
482         dynargs[2] = args[2];
483         dynargs[3] = args[3];
484         dynargs[4] = args[4];
485         return oraclize_query(datasource, dynargs);
486     }
487     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
488         bytes[] memory dynargs = new bytes[](5);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         dynargs[2] = args[2];
492         dynargs[3] = args[3];
493         dynargs[4] = args[4];
494         return oraclize_query(timestamp, datasource, dynargs);
495     }
496     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
497         bytes[] memory dynargs = new bytes[](5);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         dynargs[2] = args[2];
501         dynargs[3] = args[3];
502         dynargs[4] = args[4];
503         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
504     }
505     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506         bytes[] memory dynargs = new bytes[](5);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         dynargs[3] = args[3];
511         dynargs[4] = args[4];
512         return oraclize_query(datasource, dynargs, gaslimit);
513     }
514 
515     function oraclize_cbAddress() oraclizeAPI internal returns (address){
516         return oraclize.cbAddress();
517     }
518     function oraclize_setProof(byte proofP) oraclizeAPI internal {
519         return oraclize.setProofType(proofP);
520     }
521     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
522         return oraclize.setCustomGasPrice(gasPrice);
523     }
524     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
525         return oraclize.setConfig(config);
526     }
527 
528     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
529         return oraclize.randomDS_getSessionPubKeyHash();
530     }
531 
532     function getCodeSize(address _addr) constant internal returns(uint _size) {
533         assembly {
534             _size := extcodesize(_addr)
535         }
536     }
537 
538     function parseAddr(string _a) internal returns (address){
539         bytes memory tmp = bytes(_a);
540         uint160 iaddr = 0;
541         uint160 b1;
542         uint160 b2;
543         for (uint i=2; i<2+2*20; i+=2){
544             iaddr *= 256;
545             b1 = uint160(tmp[i]);
546             b2 = uint160(tmp[i+1]);
547             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
548             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
549             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
550             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
551             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
552             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
553             iaddr += (b1*16+b2);
554         }
555         return address(iaddr);
556     }
557 
558     function strCompare(string _a, string _b) internal returns (int) {
559         bytes memory a = bytes(_a);
560         bytes memory b = bytes(_b);
561         uint minLength = a.length;
562         if (b.length < minLength) minLength = b.length;
563         for (uint i = 0; i < minLength; i ++)
564             if (a[i] < b[i])
565                 return -1;
566             else if (a[i] > b[i])
567                 return 1;
568         if (a.length < b.length)
569             return -1;
570         else if (a.length > b.length)
571             return 1;
572         else
573             return 0;
574     }
575 
576     function indexOf(string _haystack, string _needle) internal returns (int) {
577         bytes memory h = bytes(_haystack);
578         bytes memory n = bytes(_needle);
579         if(h.length < 1 || n.length < 1 || (n.length > h.length))
580             return -1;
581         else if(h.length > (2**128 -1))
582             return -1;
583         else
584         {
585             uint subindex = 0;
586             for (uint i = 0; i < h.length; i ++)
587             {
588                 if (h[i] == n[0])
589                 {
590                     subindex = 1;
591                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
592                     {
593                         subindex++;
594                     }
595                     if(subindex == n.length)
596                         return int(i);
597                 }
598             }
599             return -1;
600         }
601     }
602 
603     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
604         bytes memory _ba = bytes(_a);
605         bytes memory _bb = bytes(_b);
606         bytes memory _bc = bytes(_c);
607         bytes memory _bd = bytes(_d);
608         bytes memory _be = bytes(_e);
609         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
610         bytes memory babcde = bytes(abcde);
611         uint k = 0;
612         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
613         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
614         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
615         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
616         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
617         return string(babcde);
618     }
619 
620     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
621         return strConcat(_a, _b, _c, _d, "");
622     }
623 
624     function strConcat(string _a, string _b, string _c) internal returns (string) {
625         return strConcat(_a, _b, _c, "", "");
626     }
627 
628     function strConcat(string _a, string _b) internal returns (string) {
629         return strConcat(_a, _b, "", "", "");
630     }
631 
632     // parseInt
633     function parseInt(string _a) internal returns (uint) {
634         return parseInt(_a, 0);
635     }
636 
637     // parseInt(parseFloat*10^_b)
638     function parseInt(string _a, uint _b) internal returns (uint) {
639         bytes memory bresult = bytes(_a);
640         uint mint = 0;
641         bool decimals = false;
642         for (uint i=0; i<bresult.length; i++){
643             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
644                 if (decimals){
645                    if (_b == 0) break;
646                     else _b--;
647                 }
648                 mint *= 10;
649                 mint += uint(bresult[i]) - 48;
650             } else if (bresult[i] == 46) decimals = true;
651         }
652         if (_b > 0) mint *= 10**_b;
653         return mint;
654     }
655 
656     function uint2str(uint i) internal returns (string){
657         if (i == 0) return "0";
658         uint j = i;
659         uint len;
660         while (j != 0){
661             len++;
662             j /= 10;
663         }
664         bytes memory bstr = new bytes(len);
665         uint k = len - 1;
666         while (i != 0){
667             bstr[k--] = byte(48 + i % 10);
668             i /= 10;
669         }
670         return string(bstr);
671     }
672 
673     function stra2cbor(string[] arr) internal returns (bytes) {
674             uint arrlen = arr.length;
675 
676             // get correct cbor output length
677             uint outputlen = 0;
678             bytes[] memory elemArray = new bytes[](arrlen);
679             for (uint i = 0; i < arrlen; i++) {
680                 elemArray[i] = (bytes(arr[i]));
681                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
682             }
683             uint ctr = 0;
684             uint cborlen = arrlen + 0x80;
685             outputlen += byte(cborlen).length;
686             bytes memory res = new bytes(outputlen);
687 
688             while (byte(cborlen).length > ctr) {
689                 res[ctr] = byte(cborlen)[ctr];
690                 ctr++;
691             }
692             for (i = 0; i < arrlen; i++) {
693                 res[ctr] = 0x5F;
694                 ctr++;
695                 for (uint x = 0; x < elemArray[i].length; x++) {
696                     // if there's a bug with larger strings, this may be the culprit
697                     if (x % 23 == 0) {
698                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
699                         elemcborlen += 0x40;
700                         uint lctr = ctr;
701                         while (byte(elemcborlen).length > ctr - lctr) {
702                             res[ctr] = byte(elemcborlen)[ctr - lctr];
703                             ctr++;
704                         }
705                     }
706                     res[ctr] = elemArray[i][x];
707                     ctr++;
708                 }
709                 res[ctr] = 0xFF;
710                 ctr++;
711             }
712             return res;
713         }
714 
715     function ba2cbor(bytes[] arr) internal returns (bytes) {
716             uint arrlen = arr.length;
717 
718             // get correct cbor output length
719             uint outputlen = 0;
720             bytes[] memory elemArray = new bytes[](arrlen);
721             for (uint i = 0; i < arrlen; i++) {
722                 elemArray[i] = (bytes(arr[i]));
723                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
724             }
725             uint ctr = 0;
726             uint cborlen = arrlen + 0x80;
727             outputlen += byte(cborlen).length;
728             bytes memory res = new bytes(outputlen);
729 
730             while (byte(cborlen).length > ctr) {
731                 res[ctr] = byte(cborlen)[ctr];
732                 ctr++;
733             }
734             for (i = 0; i < arrlen; i++) {
735                 res[ctr] = 0x5F;
736                 ctr++;
737                 for (uint x = 0; x < elemArray[i].length; x++) {
738                     // if there's a bug with larger strings, this may be the culprit
739                     if (x % 23 == 0) {
740                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
741                         elemcborlen += 0x40;
742                         uint lctr = ctr;
743                         while (byte(elemcborlen).length > ctr - lctr) {
744                             res[ctr] = byte(elemcborlen)[ctr - lctr];
745                             ctr++;
746                         }
747                     }
748                     res[ctr] = elemArray[i][x];
749                     ctr++;
750                 }
751                 res[ctr] = 0xFF;
752                 ctr++;
753             }
754             return res;
755         }
756 
757 
758     string oraclize_network_name;
759     function oraclize_setNetworkName(string _network_name) internal {
760         oraclize_network_name = _network_name;
761     }
762 
763     function oraclize_getNetworkName() internal returns (string) {
764         return oraclize_network_name;
765     }
766 
767     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
768         if ((_nbytes == 0)||(_nbytes > 32)) throw;
769 	// Convert from seconds to ledger timer ticks
770         _delay *= 10; 
771         bytes memory nbytes = new bytes(1);
772         nbytes[0] = byte(_nbytes);
773         bytes memory unonce = new bytes(32);
774         bytes memory sessionKeyHash = new bytes(32);
775         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
776         assembly {
777             mstore(unonce, 0x20)
778             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
779             mstore(sessionKeyHash, 0x20)
780             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
781         }
782         bytes memory delay = new bytes(32);
783         assembly { 
784             mstore(add(delay, 0x20), _delay) 
785         }
786         
787         bytes memory delay_bytes8 = new bytes(8);
788         copyBytes(delay, 24, 8, delay_bytes8, 0);
789 
790         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
791         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
792         
793         bytes memory delay_bytes8_left = new bytes(8);
794         
795         assembly {
796             let x := mload(add(delay_bytes8, 0x20))
797             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
798             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
799             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
800             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
801             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
802             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
803             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
804             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
805 
806         }
807         
808         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
809         return queryId;
810     }
811     
812     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
813         oraclize_randomDS_args[queryId] = commitment;
814     }
815 
816     mapping(bytes32=>bytes32) oraclize_randomDS_args;
817     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
818 
819     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
820         bool sigok;
821         address signer;
822 
823         bytes32 sigr;
824         bytes32 sigs;
825 
826         bytes memory sigr_ = new bytes(32);
827         uint offset = 4+(uint(dersig[3]) - 0x20);
828         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
829         bytes memory sigs_ = new bytes(32);
830         offset += 32 + 2;
831         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
832 
833         assembly {
834             sigr := mload(add(sigr_, 32))
835             sigs := mload(add(sigs_, 32))
836         }
837 
838 
839         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
840         if (address(sha3(pubkey)) == signer) return true;
841         else {
842             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
843             return (address(sha3(pubkey)) == signer);
844         }
845     }
846 
847     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
848         bool sigok;
849 
850         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
851         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
852         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
853 
854         bytes memory appkey1_pubkey = new bytes(64);
855         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
856 
857         bytes memory tosign2 = new bytes(1+65+32);
858         tosign2[0] = 1; //role
859         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
860         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
861         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
862         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
863 
864         if (sigok == false) return false;
865 
866 
867         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
868         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
869 
870         bytes memory tosign3 = new bytes(1+65);
871         tosign3[0] = 0xFE;
872         copyBytes(proof, 3, 65, tosign3, 1);
873 
874         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
875         copyBytes(proof, 3+65, sig3.length, sig3, 0);
876 
877         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
878 
879         return sigok;
880     }
881 
882     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
883         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
884         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
885 
886         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
887         if (proofVerified == false) throw;
888 
889         _;
890     }
891 
892     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
893         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
894         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
895 
896         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
897         if (proofVerified == false) return 2;
898 
899         return 0;
900     }
901 
902     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
903         bool match_ = true;
904 	
905 	if (prefix.length != n_random_bytes) throw;
906 	        
907         for (uint256 i=0; i< n_random_bytes; i++) {
908             if (content[i] != prefix[i]) match_ = false;
909         }
910 
911         return match_;
912     }
913 
914     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
915 
916         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
917         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
918         bytes memory keyhash = new bytes(32);
919         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
920         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
921 
922         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
923         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
924 
925         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
926         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
927 
928         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
929         // This is to verify that the computed args match with the ones specified in the query.
930         bytes memory commitmentSlice1 = new bytes(8+1+32);
931         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
932 
933         bytes memory sessionPubkey = new bytes(64);
934         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
935         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
936 
937         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
938         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
939             delete oraclize_randomDS_args[queryId];
940         } else return false;
941 
942 
943         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
944         bytes memory tosign1 = new bytes(32+8+1+32);
945         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
946         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
947 
948         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
949         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
950             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
951         }
952 
953         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
954     }
955 
956 
957     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
958     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
959         uint minLength = length + toOffset;
960 
961         if (to.length < minLength) {
962             // Buffer too small
963             throw; // Should be a better way?
964         }
965 
966         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
967         uint i = 32 + fromOffset;
968         uint j = 32 + toOffset;
969 
970         while (i < (32 + fromOffset + length)) {
971             assembly {
972                 let tmp := mload(add(from, i))
973                 mstore(add(to, j), tmp)
974             }
975             i += 32;
976             j += 32;
977         }
978 
979         return to;
980     }
981 
982     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
983     // Duplicate Solidity's ecrecover, but catching the CALL return value
984     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
985         // We do our own memory management here. Solidity uses memory offset
986         // 0x40 to store the current end of memory. We write past it (as
987         // writes are memory extensions), but don't update the offset so
988         // Solidity will reuse it. The memory used here is only needed for
989         // this context.
990 
991         // FIXME: inline assembly can't access return values
992         bool ret;
993         address addr;
994 
995         assembly {
996             let size := mload(0x40)
997             mstore(size, hash)
998             mstore(add(size, 32), v)
999             mstore(add(size, 64), r)
1000             mstore(add(size, 96), s)
1001 
1002             // NOTE: we can reuse the request memory because we deal with
1003             //       the return code
1004             ret := call(3000, 1, 0, size, 128, size, 32)
1005             addr := mload(size)
1006         }
1007 
1008         return (ret, addr);
1009     }
1010 
1011     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1012     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1013         bytes32 r;
1014         bytes32 s;
1015         uint8 v;
1016 
1017         if (sig.length != 65)
1018           return (false, 0);
1019 
1020         // The signature format is a compact form of:
1021         //   {bytes32 r}{bytes32 s}{uint8 v}
1022         // Compact means, uint8 is not padded to 32 bytes.
1023         assembly {
1024             r := mload(add(sig, 32))
1025             s := mload(add(sig, 64))
1026 
1027             // Here we are loading the last 32 bytes. We exploit the fact that
1028             // 'mload' will pad with zeroes if we overread.
1029             // There is no 'mload8' to do this, but that would be nicer.
1030             v := byte(0, mload(add(sig, 96)))
1031 
1032             // Alternative solution:
1033             // 'byte' is not working due to the Solidity parser, so lets
1034             // use the second best option, 'and'
1035             // v := and(mload(add(sig, 65)), 255)
1036         }
1037 
1038         // albeit non-transactional signatures are not specified by the YP, one would expect it
1039         // to match the YP range of [27, 28]
1040         //
1041         // geth uses [0, 1] and some clients have followed. This might change, see:
1042         //  https://github.com/ethereum/go-ethereum/issues/2053
1043         if (v < 27)
1044           v += 27;
1045 
1046         if (v != 27 && v != 28)
1047             return (false, 0);
1048 
1049         return safer_ecrecover(hash, v, r, s);
1050     }
1051 
1052 }
1053 // </ORACLIZE_API>
1054 
1055 // Minimal required STAKE token interface
1056 contract StakeToken
1057 {
1058     function transfer(address _to, uint256 _value) public returns (bool success);
1059     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
1060     function balanceOf(address _owner) public view returns (uint256 balance);
1061 }
1062 
1063 contract StakeDiceGame
1064 {
1065     // Prevent people from losing Ether by accidentally sending it to this contract.
1066     function () payable external
1067     {
1068         revert();
1069     }
1070     
1071     ///////////////////////////////
1072     /////// GAME PARAMETERS
1073     
1074     StakeDice public stakeDice;
1075     
1076     // Number between 0 and 10 000. Examples:
1077     // 700 indicates 7% chance.
1078     // 5000 indicates 50% chance.
1079     // 8000 indicates 80% chance.
1080     uint256 public winningChance;
1081     
1082     // Examples of multiplierOnWin() return values:
1083     // 10 000 indicates 1x returned.
1084     // 13 000 indicated 1.3x returned
1085     // 200 000 indicates 20x returned
1086     function multiplierOnWin() public view returns (uint256)
1087     {
1088         uint256 beforeHouseEdge = 10000;
1089         uint256 afterHouseEdge = beforeHouseEdge - stakeDice.houseEdge();
1090         return afterHouseEdge * 10000 / winningChance;
1091     }
1092     
1093     function maximumBet() public view returns (uint256)
1094     {
1095         uint256 availableTokens = stakeDice.stakeTokenContract().balanceOf(address(stakeDice));
1096         return availableTokens * 10000 / multiplierOnWin() / 5;
1097     }
1098     
1099     ///////////////////////////////
1100     /////// GAME FUNCTIONALITY
1101     
1102     // If we receive approval to transfer a gambler's tokens
1103     function receiveApproval(address _gambler, uint256 _amount, address _tokenContract, bytes) external returns (bool)
1104     {
1105         // Make sure that we are receiving STAKE tokens, and not some other token
1106         require(_tokenContract == address(stakeDice.stakeTokenContract()));
1107         require(msg.sender == _tokenContract);
1108         
1109         // Make sure the bet is within the current limits
1110         require(_amount >= stakeDice.minimumBet());
1111         require(_amount <= maximumBet());
1112         
1113         // Tranfer the STAKE tokens from the user's account to the StakeDice contract
1114         stakeDice.stakeTokenContract().transferFrom(_gambler, stakeDice, _amount);
1115         
1116         // Notify the StakeDice contract that a bet has been placed
1117         stakeDice.betPlaced(_gambler, _amount, winningChance);
1118     }
1119     
1120     ///////////////////////////////
1121     /////// OWNER FUNCTIONS
1122     
1123     // Constructor function
1124     // Provide a number between 0 and 10 000 to indicate the winning chance and house edge.
1125     function StakeDiceGame(StakeDice _stakeDice, uint256 _winningChance) public
1126     {
1127         // Ensure the parameters are sane
1128         require(_winningChance > 0);
1129         require(_winningChance < 10000);
1130         require(_stakeDice != address(0x0));
1131         require(msg.sender == address(_stakeDice));
1132         
1133         stakeDice = _stakeDice;
1134         winningChance = _winningChance;
1135     }
1136     
1137     // Allow the owner to change the winning chance
1138     function setWinningChance(uint256 _newWinningChance) external
1139     {
1140         require(msg.sender == stakeDice.owner());
1141         require(_newWinningChance > 0);
1142         require(_newWinningChance < 10000);
1143         winningChance = _newWinningChance;
1144     }
1145     
1146     // Allow the owner to withdraw STAKE tokens that
1147     // may have been accidentally sent here.
1148     function withdrawStakeTokens(uint256 _amount, address _to) external
1149     {
1150         require(msg.sender == stakeDice.owner());
1151         require(_to != address(0x0));
1152         stakeDice.stakeTokenContract().transfer(_to, _amount);
1153     }
1154 }
1155 
1156 
1157 contract StakeDice is usingOraclize
1158 {
1159     ///////////////////////////////
1160     /////// GAME PARAMETERS
1161     
1162     StakeToken public stakeTokenContract;
1163     mapping(address => bool) public addressIsStakeDiceGameContract;
1164     StakeDiceGame[] public allGames;
1165     uint256 public houseEdge;
1166     uint256 public minimumBet;
1167     
1168     //////////////////////////////
1169     /////// PLAYER STATISTICS
1170     
1171     address[] public allPlayers;
1172     mapping(address => uint256) public playersToTotalBets;
1173     mapping(address => uint256[]) public playersToBetIndices;
1174     function playerAmountOfBets(address _player) external view returns (uint256)
1175     {
1176         return playersToBetIndices[_player].length;
1177     }
1178     
1179     function totalUniquePlayers() external view returns (uint256)
1180     {
1181         return allPlayers.length;
1182     }
1183     
1184     //////////////////////////////
1185     /////// GAME FUNCTIONALITY
1186     
1187     // Events
1188     event BetPlaced(address indexed gambler, uint256 betIndex);
1189     event BetWon(address indexed gambler, uint256 betIndex);
1190     event BetLost(address indexed gambler, uint256 betIndex);
1191     event BetCanceled(address indexed gambler, uint256 betIndex);
1192     
1193     enum BetStatus
1194     {
1195         NON_EXISTANT,
1196         IN_PROGRESS,
1197         WON,
1198         LOST,
1199         CANCELED
1200     }
1201     
1202     struct Bet
1203     {
1204         address gambler;
1205         uint256 winningChance;
1206         uint256 betAmount;
1207         uint256 potentialRevenue;
1208         uint256 roll;
1209         BetStatus status;
1210     }
1211     
1212     Bet[] public bets;
1213     mapping(bytes32 => uint256) public oraclizeQueryIdsToBetIndices;
1214     
1215     function betPlaced(address _gambler, uint256 _amount, uint256 _winningChance) external
1216     {
1217         // Only StakeDiceGame contracts are allowed to call this function
1218         require(addressIsStakeDiceGameContract[msg.sender] == true);
1219         
1220         // Request a random number from oraclize
1221         uint N = 4; // number of random bytes we want the datasource to return
1222         uint delay = 0; // number of seconds to wait before the execution takes place
1223         uint callbackGas = 85000; // amount of gas we want Oraclize to set for the callback function
1224         bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callbackGas); // this function internally generates the correct oraclize_query and returns its queryId
1225         
1226         // Calculate how much the gambler might win
1227         uint256 potentialRevenue = StakeDiceGame(msg.sender).multiplierOnWin() * _amount / 10000;
1228         
1229         // Store the bet
1230         BetPlaced(_gambler, bets.length);
1231         oraclizeQueryIdsToBetIndices[queryId] = bets.length;
1232         playersToBetIndices[_gambler].push(bets.length);
1233         bets.push(Bet({gambler: _gambler, winningChance: _winningChance, betAmount: _amount, potentialRevenue: potentialRevenue, roll: 0, status: BetStatus.IN_PROGRESS}));
1234         
1235         // Update statistics
1236         if (playersToTotalBets[_gambler] == 0)
1237         {
1238             allPlayers.push(_gambler);
1239         }
1240         playersToTotalBets[_gambler] += _amount;
1241     }
1242     
1243     // This callback function is called by Oraclize when the result is ready
1244     function __callback(bytes32 _queryId, string _result, bytes) public
1245     { 
1246         // Make sure only oraclize can call this function
1247         require(msg.sender == oraclize_cbAddress());
1248         
1249         // Make sure the queryId is valid and refers to a non-finalized bet
1250         uint256 betIndex = oraclizeQueryIdsToBetIndices[_queryId];
1251         require(betIndex > 0);
1252         Bet storage bet = bets[betIndex];
1253         require(bet.status == BetStatus.IN_PROGRESS);
1254 
1255         // Now that we have generated a random number, let's use it..
1256         uint randomNumber = uint(keccak256(_result)) % 10000; // Get a random number from 0 to 9999
1257         
1258         // Store the roll in the blockchain permanently
1259         bet.roll = randomNumber;
1260         
1261         // If the random number is smaller than the winningChance, the gambler won!
1262         if (randomNumber < bet.winningChance)
1263         {
1264             // If we somehow don't have enough tokens to payout their winnings,
1265             // cancel the bet and refund the gambler automatically
1266             if (stakeTokenContract.balanceOf(this) < bet.potentialRevenue)
1267             {
1268                 _cancelBet(betIndex);
1269             }
1270             
1271             // Otherwise, (if we do have enough tokens)
1272             else
1273             {
1274                 // The gambler won!
1275                 bet.status = BetStatus.WON;
1276             
1277                 // Send them their winnings
1278                 stakeTokenContract.transfer(bet.gambler, bet.potentialRevenue);
1279                 
1280                 // Trigger BetWon event
1281                 BetWon(bet.gambler, betIndex);
1282             }
1283         }
1284         else
1285         {
1286             // The gambler lost!
1287             bet.status = BetStatus.LOST;
1288             
1289             // Send them the smallest possible token unit as consolation prize
1290             // and as notification that their bet has lost.
1291             stakeTokenContract.transfer(bet.gambler, 1); // Send 0.00000001 STAKE
1292             
1293             // Trigger BetLost event
1294             BetLost(bet.gambler, betIndex);
1295         }
1296     }
1297     
1298     function _cancelBet(uint256 _betIndex) private
1299     {
1300         // Only bets that are in progress can be canceled
1301         require(bets[_betIndex].status == BetStatus.IN_PROGRESS);
1302         
1303         // Store the fact that the bet has been canceled
1304         bets[_betIndex].status = BetStatus.CANCELED;
1305         
1306         // Refund the bet amount to the gambler
1307         stakeTokenContract.transfer(bets[_betIndex].gambler, bets[_betIndex].betAmount);
1308         
1309         // Trigger BetCanceled event
1310         BetCanceled(bets[_betIndex].gambler, _betIndex);
1311         
1312         // Subtract the bet from their total
1313         playersToTotalBets[bets[_betIndex].gambler] -= bets[_betIndex].betAmount;
1314     }
1315     
1316     function amountOfGames() external view returns (uint256)
1317     {
1318         return allGames.length;
1319     }
1320     
1321     function amountOfBets() external view returns (uint256)
1322     {
1323         return bets.length-1;
1324     }
1325     
1326     ///////////////////////////////
1327     /////// OWNER FUNCTIONS
1328     
1329     address public owner;
1330     
1331     // Constructor function
1332     function StakeDice(StakeToken _stakeTokenContract, uint256 _houseEdge, uint256 _minimumBet) public
1333     {
1334         // Bet indices start at 1 because the values of the
1335         // oraclizeQueryIdsToBetIndices mapping are by default 0.
1336         bets.length = 1;
1337         
1338         // Whoever deployed the contract is made owner
1339         owner = msg.sender;
1340         
1341         // Ensure that the arguments are sane
1342         require(_houseEdge < 10000);
1343         require(_stakeTokenContract != address(0x0));
1344         
1345         // Store the initializing arguments
1346         stakeTokenContract = _stakeTokenContract;
1347         houseEdge = _houseEdge;
1348         minimumBet = _minimumBet;
1349     }
1350     
1351     // Allow the owner to easily create the default dice games
1352     function createDefaultGames() public
1353     {
1354         require(allGames.length == 0);
1355         
1356         addNewStakeDiceGame(500); // 5% chance
1357         addNewStakeDiceGame(1000); // 10% chance
1358         addNewStakeDiceGame(2500); // 25% chance
1359         addNewStakeDiceGame(4000); // 40% chance
1360         addNewStakeDiceGame(5000); // 50% chance
1361         addNewStakeDiceGame(7500); // 75% chance
1362         addNewStakeDiceGame(9000); // 90% chance
1363     }
1364     
1365     // Allow the owner to cancel a bet when it's in progress.
1366     // This will probably never be needed, but it might some day be needed
1367     // to refund people if oraclize is not responding.
1368     function cancelBet(uint256 _betIndex) public
1369     {
1370         require(msg.sender == owner);
1371         
1372         _cancelBet(_betIndex);
1373     }
1374     
1375     // Allow the owner to add new games with different winning chances
1376     function addNewStakeDiceGame(uint256 _winningChance) public
1377     {
1378         require(msg.sender == owner);
1379         
1380         // Deploy a new StakeDiceGame contract
1381         StakeDiceGame newGame = new StakeDiceGame(this, _winningChance);
1382         
1383         // Store the fact that this new address is a StakeDiceGame contract
1384         addressIsStakeDiceGameContract[newGame] = true;
1385         allGames.push(newGame);
1386     }
1387     
1388     // Allow the owner to change the house edge
1389     function setHouseEdge(uint256 _newHouseEdge) external
1390     {
1391         require(msg.sender == owner);
1392         require(_newHouseEdge < 10000);
1393         houseEdge = _newHouseEdge;
1394     }
1395     
1396     // Allow the owner to change the minimum bet
1397     // This also allows the owner to temporarily disable the game by setting the
1398     // minimum bet to an impossibly high number.
1399     function setMinimumBet(uint256 _newMinimumBet) external
1400     {
1401         require(msg.sender == owner);
1402         minimumBet = _newMinimumBet;
1403     }
1404     
1405     // Allow the owner to deposit and withdraw ether
1406     // (this contract needs to pay oraclize fees)
1407     function depositEther() payable external
1408     {
1409         require(msg.sender == owner);
1410     }
1411     function withdrawEther(uint256 _amount) payable external
1412     {
1413         require(msg.sender == owner);
1414         owner.transfer(_amount);
1415     }
1416     
1417     // Allow the owner to make another address the owner
1418     function transferOwnership(address _newOwner) external
1419     {
1420         require(msg.sender == owner);
1421         require(_newOwner != 0x0);
1422         owner = _newOwner;
1423     }
1424     
1425     // Allow the owner to withdraw STAKE tokens
1426     function withdrawStakeTokens(uint256 _amount) external
1427     {
1428         require(msg.sender == owner);
1429         stakeTokenContract.transfer(owner, _amount);
1430     }
1431     
1432     // Prevent people from losing Ether by accidentally sending it to this contract.
1433     function () payable external
1434     {
1435         revert();
1436     }
1437 }