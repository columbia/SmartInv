1 pragma solidity ^0.4.0;
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
769         bytes memory nbytes = new bytes(1);
770         nbytes[0] = byte(_nbytes);
771         bytes memory unonce = new bytes(32);
772         bytes memory sessionKeyHash = new bytes(32);
773         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
774         assembly {
775             mstore(unonce, 0x20)
776             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
777             mstore(sessionKeyHash, 0x20)
778             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
779         }
780         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
781         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
782         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
783         return queryId;
784     }
785 
786     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
787         oraclize_randomDS_args[queryId] = commitment;
788     }
789 
790     mapping(bytes32=>bytes32) oraclize_randomDS_args;
791     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
792 
793     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
794         bool sigok;
795         address signer;
796 
797         bytes32 sigr;
798         bytes32 sigs;
799 
800         bytes memory sigr_ = new bytes(32);
801         uint offset = 4+(uint(dersig[3]) - 0x20);
802         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
803         bytes memory sigs_ = new bytes(32);
804         offset += 32 + 2;
805         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
806 
807         assembly {
808             sigr := mload(add(sigr_, 32))
809             sigs := mload(add(sigs_, 32))
810         }
811 
812 
813         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
814         if (address(sha3(pubkey)) == signer) return true;
815         else {
816             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
817             return (address(sha3(pubkey)) == signer);
818         }
819     }
820 
821     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
822         bool sigok;
823 
824         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
825         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
826         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
827 
828         bytes memory appkey1_pubkey = new bytes(64);
829         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
830 
831         bytes memory tosign2 = new bytes(1+65+32);
832         tosign2[0] = 1; //role
833         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
834         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
835         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
836         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
837 
838         if (sigok == false) return false;
839 
840 
841         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
842         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
843 
844         bytes memory tosign3 = new bytes(1+65);
845         tosign3[0] = 0xFE;
846         copyBytes(proof, 3, 65, tosign3, 1);
847 
848         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
849         copyBytes(proof, 3+65, sig3.length, sig3, 0);
850 
851         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
852 
853         return sigok;
854     }
855 
856     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
857         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
858         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
859 
860         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
861         if (proofVerified == false) throw;
862 
863         _;
864     }
865 
866     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
867         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
868         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
869 
870         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
871         if (proofVerified == false) return 2;
872 
873         return 0;
874     }
875 
876     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
877         bool match_ = true;
878         
879         for (uint256 i=0; i< n_random_bytes; i++) {
880             if (content[i] != prefix[i]) match_ = false;
881         }
882 
883         return match_;
884     }
885 
886     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
887 
888         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
889         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
890         bytes memory keyhash = new bytes(32);
891         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
892         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
893 
894         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
895         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
896 
897         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
898         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
899 
900         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
901         // This is to verify that the computed args match with the ones specified in the query.
902         bytes memory commitmentSlice1 = new bytes(8+1+32);
903         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
904 
905         bytes memory sessionPubkey = new bytes(64);
906         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
907         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
908 
909         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
910         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
911             delete oraclize_randomDS_args[queryId];
912         } else return false;
913 
914 
915         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
916         bytes memory tosign1 = new bytes(32+8+1+32);
917         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
918         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
919 
920         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
921         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
922             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
923         }
924 
925         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
926     }
927 
928 
929     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
930     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
931         uint minLength = length + toOffset;
932 
933         if (to.length < minLength) {
934             // Buffer too small
935             throw; // Should be a better way?
936         }
937 
938         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
939         uint i = 32 + fromOffset;
940         uint j = 32 + toOffset;
941 
942         while (i < (32 + fromOffset + length)) {
943             assembly {
944                 let tmp := mload(add(from, i))
945                 mstore(add(to, j), tmp)
946             }
947             i += 32;
948             j += 32;
949         }
950 
951         return to;
952     }
953 
954     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
955     // Duplicate Solidity's ecrecover, but catching the CALL return value
956     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
957         // We do our own memory management here. Solidity uses memory offset
958         // 0x40 to store the current end of memory. We write past it (as
959         // writes are memory extensions), but don't update the offset so
960         // Solidity will reuse it. The memory used here is only needed for
961         // this context.
962 
963         // FIXME: inline assembly can't access return values
964         bool ret;
965         address addr;
966 
967         assembly {
968             let size := mload(0x40)
969             mstore(size, hash)
970             mstore(add(size, 32), v)
971             mstore(add(size, 64), r)
972             mstore(add(size, 96), s)
973 
974             // NOTE: we can reuse the request memory because we deal with
975             //       the return code
976             ret := call(3000, 1, 0, size, 128, size, 32)
977             addr := mload(size)
978         }
979 
980         return (ret, addr);
981     }
982 
983     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
984     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
985         bytes32 r;
986         bytes32 s;
987         uint8 v;
988 
989         if (sig.length != 65)
990           return (false, 0);
991 
992         // The signature format is a compact form of:
993         //   {bytes32 r}{bytes32 s}{uint8 v}
994         // Compact means, uint8 is not padded to 32 bytes.
995         assembly {
996             r := mload(add(sig, 32))
997             s := mload(add(sig, 64))
998 
999             // Here we are loading the last 32 bytes. We exploit the fact that
1000             // 'mload' will pad with zeroes if we overread.
1001             // There is no 'mload8' to do this, but that would be nicer.
1002             v := byte(0, mload(add(sig, 96)))
1003 
1004             // Alternative solution:
1005             // 'byte' is not working due to the Solidity parser, so lets
1006             // use the second best option, 'and'
1007             // v := and(mload(add(sig, 65)), 255)
1008         }
1009 
1010         // albeit non-transactional signatures are not specified by the YP, one would expect it
1011         // to match the YP range of [27, 28]
1012         //
1013         // geth uses [0, 1] and some clients have followed. This might change, see:
1014         //  https://github.com/ethereum/go-ethereum/issues/2053
1015         if (v < 27)
1016           v += 27;
1017 
1018         if (v != 27 && v != 28)
1019             return (false, 0);
1020 
1021         return safer_ecrecover(hash, v, r, s);
1022     }
1023 
1024 }
1025 // </ORACLIZE_API>
1026 
1027 contract Dice is usingOraclize {
1028 
1029     uint constant pwin = 500; //probability of winning (10000 = 100%)
1030     uint constant edge = 190; //edge percentage (10000 = 100%)
1031     uint constant maxWin = 100; //max win (before edge is taken) as percentage of bankroll (10000 = 100%)
1032     uint constant minBet = 2000 finney;
1033     uint constant maxInvestors = 10; //maximum number of investors
1034     uint constant houseEdge = 90; //edge percentage (10000 = 100%)
1035     uint constant divestFee = 50; //divest fee percentage (10000 = 100%)
1036     uint constant emergencyWithdrawalRatio = 10; //ratio percentage (100 = 100%)
1037 
1038     uint safeGas = 2300;
1039     uint constant ORACLIZE_GAS_LIMIT = 175000;
1040     uint constant INVALID_BET_MARKER = 99999;
1041     uint constant EMERGENCY_TIMEOUT = 3 days;
1042 
1043     struct Investor {
1044         address investorAddress;
1045         uint amountInvested;
1046         bool votedForEmergencyWithdrawal;
1047     }
1048 
1049     struct Bet {
1050         address playerAddress;
1051         uint amountBet;
1052         uint numberRolled;
1053     }
1054 
1055     struct WithdrawalProposal {
1056         address toAddress;
1057         uint atTime;
1058     }
1059 
1060     //Starting at 1
1061     mapping(address => uint) public investorIDs;
1062     mapping(uint => Investor) public investors;
1063     uint public numInvestors = 0;
1064 
1065     uint public invested = 0;
1066 
1067     address public owner;
1068     address public houseAddress;
1069     bool public isStopped;
1070 
1071     WithdrawalProposal public proposedWithdrawal;
1072 
1073     mapping (bytes32 => Bet) public bets;
1074     bytes32[] public betsKeys;
1075 
1076     uint public investorsProfit = 0;
1077     uint public investorsLosses = 0;
1078     bool profitDistributed;
1079 
1080     event LOG_NewBet(address playerAddress, uint amount);
1081     event LOG_BetWon(address playerAddress, uint numberRolled, uint amountWon);
1082     event LOG_BetLost(address playerAddress, uint numberRolled);
1083     event LOG_EmergencyWithdrawalProposed();
1084     event LOG_EmergencyWithdrawalFailed(address withdrawalAddress);
1085     event LOG_EmergencyWithdrawalSucceeded(address withdrawalAddress, uint amountWithdrawn);
1086     event LOG_FailedSend(address receiver, uint amount);
1087     event LOG_ZeroSend();
1088     event LOG_InvestorEntrance(address investor, uint amount);
1089     event LOG_InvestorCapitalUpdate(address investor, int amount);
1090     event LOG_InvestorExit(address investor, uint amount);
1091     event LOG_ContractStopped();
1092     event LOG_ContractResumed();
1093     event LOG_OwnerAddressChanged(address oldAddr, address newOwnerAddress);
1094     event LOG_HouseAddressChanged(address oldAddr, address newHouseAddress);
1095     event LOG_GasLimitChanged(uint oldGasLimit, uint newGasLimit);
1096     event LOG_EmergencyAutoStop();
1097     event LOG_EmergencyWithdrawalVote(address investor, bool vote);
1098     event LOG_ValueIsTooBig();
1099     event LOG_SuccessfulSend(address addr, uint amount);
1100 
1101     function Dice() {
1102         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1103         owner = msg.sender;
1104         houseAddress = msg.sender;
1105     }
1106 
1107     //SECTION I: MODIFIERS AND HELPER FUNCTIONS
1108 
1109     //MODIFIERS
1110 
1111     modifier onlyIfNotStopped {
1112         if (isStopped) throw;
1113         _;
1114     }
1115 
1116     modifier onlyIfStopped {
1117         if (!isStopped) throw;
1118         _;
1119     }
1120 
1121     modifier onlyInvestors {
1122         if (investorIDs[msg.sender] == 0) throw;
1123         _;
1124     }
1125 
1126     modifier onlyNotInvestors {
1127         if (investorIDs[msg.sender] != 0) throw;
1128         _;
1129     }
1130 
1131     modifier onlyOwner {
1132         if (owner != msg.sender) throw;
1133         _;
1134     }
1135 
1136     modifier onlyOraclize {
1137         if (msg.sender != oraclize_cbAddress()) throw;
1138         _;
1139     }
1140 
1141     modifier onlyMoreThanMinInvestment {
1142         if (msg.value <= getMinInvestment()) throw;
1143         _;
1144     }
1145 
1146     modifier onlyMoreThanZero {
1147         if (msg.value == 0) throw;
1148         _;
1149     }
1150 
1151     modifier onlyIfBetExist(bytes32 myid) {
1152         if(bets[myid].playerAddress == address(0x0)) throw;
1153         _;
1154     }
1155 
1156     modifier onlyIfBetSizeIsStillCorrect(bytes32 myid) {
1157         if ((((bets[myid].amountBet * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000)  && (bets[myid].amountBet >= minBet)) {
1158              _;
1159         }
1160         else {
1161             bets[myid].numberRolled = INVALID_BET_MARKER;
1162             safeSend(bets[myid].playerAddress, bets[myid].amountBet);
1163             return;
1164         }
1165     }
1166 
1167     modifier onlyIfValidRoll(bytes32 myid, string result) {
1168         uint numberRolled = parseInt(result);
1169         if ((numberRolled < 1 || numberRolled > 10000) && bets[myid].numberRolled == 0) {
1170             bets[myid].numberRolled = INVALID_BET_MARKER;
1171             safeSend(bets[myid].playerAddress, bets[myid].amountBet);
1172             return;
1173         }
1174         _;
1175     }
1176 
1177     modifier onlyWinningBets(uint numberRolled) {
1178         if (numberRolled - 1 < pwin) {
1179             _;
1180         }
1181     }
1182 
1183     modifier onlyLosingBets(uint numberRolled) {
1184         if (numberRolled - 1 >= pwin) {
1185             _;
1186         }
1187     }
1188 
1189     modifier onlyAfterProposed {
1190         if (proposedWithdrawal.toAddress == 0) throw;
1191         _;
1192     }
1193 
1194     modifier onlyIfProfitNotDistributed {
1195         if (!profitDistributed) {
1196             _;
1197         }
1198     }
1199 
1200     modifier onlyIfValidGas(uint newGasLimit) {
1201         if (ORACLIZE_GAS_LIMIT + newGasLimit < ORACLIZE_GAS_LIMIT) throw;
1202         if (newGasLimit < 25000) throw;
1203         _;
1204     }
1205 
1206     modifier onlyIfNotProcessed(bytes32 myid) {
1207         if (bets[myid].numberRolled > 0) throw;
1208         _;
1209     }
1210 
1211     modifier onlyIfEmergencyTimeOutHasPassed {
1212         if (proposedWithdrawal.atTime + EMERGENCY_TIMEOUT > now) throw;
1213         _;
1214     }
1215 
1216     modifier investorsInvariant {
1217         _;
1218         if (numInvestors > maxInvestors) throw;
1219     }
1220 
1221     //CONSTANT HELPER FUNCTIONS
1222 
1223     function getBankroll()
1224         constant
1225         returns(uint) {
1226 
1227         if ((invested < investorsProfit) ||
1228             (invested + investorsProfit < invested) ||
1229             (invested + investorsProfit < investorsLosses)) {
1230             return 0;
1231         }
1232         else {
1233             return invested + investorsProfit - investorsLosses;
1234         }
1235     }
1236 
1237     function getMinInvestment()
1238         constant
1239         returns(uint) {
1240 
1241         if (numInvestors == maxInvestors) {
1242             uint investorID = searchSmallestInvestor();
1243             return getBalance(investors[investorID].investorAddress);
1244         }
1245         else {
1246             return 0;
1247         }
1248     }
1249 
1250     function getStatus()
1251         constant
1252         returns(uint, uint, uint, uint, uint, uint, uint, uint) {
1253 
1254         uint bankroll = getBankroll();
1255         uint minInvestment = getMinInvestment();
1256         return (bankroll, pwin, edge, maxWin, minBet, (investorsProfit - investorsLosses), minInvestment, betsKeys.length);
1257     }
1258 
1259     function getBet(uint id)
1260         constant
1261         returns(address, uint, uint) {
1262 
1263         if (id < betsKeys.length) {
1264             bytes32 betKey = betsKeys[id];
1265             return (bets[betKey].playerAddress, bets[betKey].amountBet, bets[betKey].numberRolled);
1266         }
1267     }
1268 
1269     function numBets()
1270         constant
1271         returns(uint) {
1272 
1273         return betsKeys.length;
1274     }
1275 
1276     function getMinBetAmount()
1277         constant
1278         returns(uint) {
1279 
1280         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
1281         return oraclizeFee + minBet;
1282     }
1283 
1284     function getMaxBetAmount()
1285         constant
1286         returns(uint) {
1287 
1288         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
1289         uint betValue =  (maxWin * getBankroll()) * pwin / (10000 * (10000 - edge - pwin));
1290         return betValue + oraclizeFee;
1291     }
1292 
1293     function getLossesShare(address currentInvestor)
1294         constant
1295         returns (uint) {
1296 
1297         return investors[investorIDs[currentInvestor]].amountInvested * (investorsLosses) / invested;
1298     }
1299 
1300     function getProfitShare(address currentInvestor)
1301         constant
1302         returns (uint) {
1303 
1304         return investors[investorIDs[currentInvestor]].amountInvested * (investorsProfit) / invested;
1305     }
1306 
1307     function getBalance(address currentInvestor)
1308         constant
1309         returns (uint) {
1310 
1311         uint invested = investors[investorIDs[currentInvestor]].amountInvested;
1312         uint profit = getProfitShare(currentInvestor);
1313         uint losses = getLossesShare(currentInvestor);
1314 
1315         if ((invested + profit < profit) ||
1316             (invested + profit < invested) ||
1317             (invested + profit < losses))
1318             return 0;
1319         else
1320             return invested + profit - losses;
1321     }
1322 
1323     function searchSmallestInvestor()
1324         constant
1325         returns(uint) {
1326 
1327         uint investorID = 1;
1328         for (uint i = 1; i <= numInvestors; i++) {
1329             if (getBalance(investors[i].investorAddress) < getBalance(investors[investorID].investorAddress)) {
1330                 investorID = i;
1331             }
1332         }
1333 
1334         return investorID;
1335     }
1336 
1337     function changeOraclizeProofType(byte _proofType)
1338         onlyOwner {
1339 
1340         if (_proofType == 0x00) throw;
1341         oraclize_setProof( _proofType |  proofStorage_IPFS );
1342     }
1343 
1344     function changeOraclizeConfig(bytes32 _config)
1345         onlyOwner {
1346 
1347         oraclize_setConfig(_config);
1348     }
1349 
1350     // PRIVATE HELPERS FUNCTION
1351 
1352     function safeSend(address addr, uint value)
1353         private {
1354 
1355         if (value == 0) {
1356             LOG_ZeroSend();
1357             return;
1358         }
1359 
1360         if (this.balance < value) {
1361             LOG_ValueIsTooBig();
1362             return;
1363         }
1364 
1365         if (!(addr.call.gas(safeGas).value(value)())) {
1366             LOG_FailedSend(addr, value);
1367             if (addr != houseAddress) {
1368                 //Forward to house address all change
1369                 if (!(houseAddress.call.gas(safeGas).value(value)())) LOG_FailedSend(houseAddress, value);
1370             }
1371         }
1372 
1373         LOG_SuccessfulSend(addr,value);
1374     }
1375 
1376     function addInvestorAtID(uint id)
1377         private {
1378 
1379         investorIDs[msg.sender] = id;
1380         investors[id].investorAddress = msg.sender;
1381         investors[id].amountInvested = msg.value;
1382         invested += msg.value;
1383 
1384         LOG_InvestorEntrance(msg.sender, msg.value);
1385     }
1386 
1387     function profitDistribution()
1388         private
1389         onlyIfProfitNotDistributed {
1390 
1391         uint copyInvested;
1392 
1393         for (uint i = 1; i <= numInvestors; i++) {
1394             address currentInvestor = investors[i].investorAddress;
1395             uint profitOfInvestor = getProfitShare(currentInvestor);
1396             uint lossesOfInvestor = getLossesShare(currentInvestor);
1397             //Check for overflow and underflow
1398             if ((investors[i].amountInvested + profitOfInvestor >= investors[i].amountInvested) &&
1399                 (investors[i].amountInvested + profitOfInvestor >= lossesOfInvestor))  {
1400                 investors[i].amountInvested += profitOfInvestor - lossesOfInvestor;
1401                 LOG_InvestorCapitalUpdate(currentInvestor, (int) (profitOfInvestor - lossesOfInvestor));
1402             }
1403             else {
1404                 isStopped = true;
1405                 LOG_EmergencyAutoStop();
1406             }
1407 
1408             if (copyInvested + investors[i].amountInvested >= copyInvested)
1409                 copyInvested += investors[i].amountInvested;
1410         }
1411 
1412         delete investorsProfit;
1413         delete investorsLosses;
1414         invested = copyInvested;
1415 
1416         profitDistributed = true;
1417     }
1418 
1419     // SECTION II: BET & BET PROCESSING
1420 
1421     function()
1422         payable {
1423 
1424         bet();
1425     }
1426 
1427     function bet()
1428         payable
1429         onlyIfNotStopped {
1430 
1431         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
1432         if (oraclizeFee >= msg.value) throw;
1433         uint betValue = msg.value - oraclizeFee;
1434         if ((((betValue * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000) && (betValue >= minBet)) {
1435             LOG_NewBet(msg.sender, betValue);
1436             bytes32 myid =
1437                 oraclize_query(
1438                     "nested",
1439                     "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random.data.0', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BOGcQBpt8M+lBJCH5xajskDUK0SktDA35wzzlqqXIS949yplYA7JXZMwVtjykF+ADrtsXRShU3hJe7n0FwlQxAaiX/eWKzwWoyHnCewyL3Y3nx2Ooif1GJ4kmoD8tMDrmiJMIiNrdW6eHbIAYQRUWv0NrVBDSiE=},\"n\":1,\"min\":1,\"max\":10000${[identity] \"}\"},\"id\":1${[identity] \"}\"}']",
1440                     ORACLIZE_GAS_LIMIT + safeGas
1441                 );
1442             bets[myid] = Bet(msg.sender, betValue, 0);
1443             betsKeys.push(myid);
1444         }
1445         else {
1446             throw;
1447         }
1448     }
1449 
1450     function __callback(bytes32 myid, string result, bytes proof)
1451         onlyOraclize
1452         onlyIfBetExist(myid)
1453         onlyIfNotProcessed(myid)
1454         onlyIfValidRoll(myid, result)
1455         onlyIfBetSizeIsStillCorrect(myid)  {
1456 
1457         uint numberRolled = parseInt(result);
1458         bets[myid].numberRolled = numberRolled;
1459         isWinningBet(bets[myid], numberRolled);
1460         isLosingBet(bets[myid], numberRolled);
1461         delete profitDistributed;
1462     }
1463 
1464     function isWinningBet(Bet thisBet, uint numberRolled)
1465         private
1466         onlyWinningBets(numberRolled) {
1467 
1468         uint winAmount = (thisBet.amountBet * (10000 - edge)) / pwin;
1469         LOG_BetWon(thisBet.playerAddress, numberRolled, winAmount);
1470         safeSend(thisBet.playerAddress, winAmount);
1471 
1472         //Check for overflow and underflow
1473         if ((investorsLosses + winAmount < investorsLosses) ||
1474             (investorsLosses + winAmount < thisBet.amountBet)) {
1475                 throw;
1476             }
1477 
1478         investorsLosses += winAmount - thisBet.amountBet;
1479     }
1480 
1481     function isLosingBet(Bet thisBet, uint numberRolled)
1482         private
1483         onlyLosingBets(numberRolled) {
1484 
1485         LOG_BetLost(thisBet.playerAddress, numberRolled);
1486         safeSend(thisBet.playerAddress, 1);
1487 
1488         //Check for overflow and underflow
1489         if ((investorsProfit + thisBet.amountBet < investorsProfit) ||
1490             (investorsProfit + thisBet.amountBet < thisBet.amountBet) ||
1491             (thisBet.amountBet == 1)) {
1492                 throw;
1493             }
1494 
1495         uint totalProfit = investorsProfit + (thisBet.amountBet - 1); //added based on audit feedback
1496         investorsProfit += (thisBet.amountBet - 1)*(10000 - houseEdge)/10000;
1497         uint houseProfit = totalProfit - investorsProfit; //changed based on audit feedback
1498         safeSend(houseAddress, houseProfit);
1499     }
1500 
1501     //SECTION III: INVEST & DIVEST
1502 
1503     function increaseInvestment()
1504         payable
1505         onlyIfNotStopped
1506         onlyMoreThanZero
1507         onlyInvestors  {
1508 
1509         profitDistribution();
1510         investors[investorIDs[msg.sender]].amountInvested += msg.value;
1511         invested += msg.value;
1512     }
1513 
1514     function newInvestor()
1515         payable
1516         onlyIfNotStopped
1517         onlyMoreThanZero
1518         onlyNotInvestors
1519         onlyMoreThanMinInvestment
1520         investorsInvariant {
1521 
1522         profitDistribution();
1523 
1524         if (numInvestors == maxInvestors) {
1525             uint smallestInvestorID = searchSmallestInvestor();
1526             divest(investors[smallestInvestorID].investorAddress);
1527         }
1528 
1529         numInvestors++;
1530         addInvestorAtID(numInvestors);
1531     }
1532 
1533     function divest()
1534         onlyInvestors {
1535 
1536         divest(msg.sender);
1537     }
1538 
1539 
1540     function divest(address currentInvestor)
1541         private
1542         investorsInvariant {
1543 
1544         profitDistribution();
1545         uint currentID = investorIDs[currentInvestor];
1546         uint amountToReturn = getBalance(currentInvestor);
1547 
1548         if ((invested >= investors[currentID].amountInvested)) {
1549             invested -= investors[currentID].amountInvested;
1550             uint divestFeeAmount =  (amountToReturn*divestFee)/10000;
1551             amountToReturn -= divestFeeAmount;
1552 
1553             delete investors[currentID];
1554             delete investorIDs[currentInvestor];
1555 
1556             //Reorder investors
1557             if (currentID != numInvestors) {
1558                 // Get last investor
1559                 Investor lastInvestor = investors[numInvestors];
1560                 //Set last investor ID to investorID of divesting account
1561                 investorIDs[lastInvestor.investorAddress] = currentID;
1562                 //Copy investor at the new position in the mapping
1563                 investors[currentID] = lastInvestor;
1564                 //Delete old position in the mappping
1565                 delete investors[numInvestors];
1566             }
1567 
1568             numInvestors--;
1569             safeSend(currentInvestor, amountToReturn);
1570             safeSend(houseAddress, divestFeeAmount);
1571             LOG_InvestorExit(currentInvestor, amountToReturn);
1572         } else {
1573             isStopped = true;
1574             LOG_EmergencyAutoStop();
1575         }
1576     }
1577 
1578     function forceDivestOfAllInvestors()
1579         onlyOwner {
1580 
1581         uint copyNumInvestors = numInvestors;
1582         for (uint i = 1; i <= copyNumInvestors; i++) {
1583             divest(investors[1].investorAddress);
1584         }
1585     }
1586 
1587     /*
1588     The owner can use this function to force the exit of an investor from the
1589     contract during an emergency withdrawal in the following situations:
1590         - Unresponsive investor
1591         - Investor demanding to be paid in other to vote, the facto-blackmailing
1592         other investors
1593     */
1594     function forceDivestOfOneInvestor(address currentInvestor)
1595         onlyOwner
1596         onlyIfStopped {
1597 
1598         divest(currentInvestor);
1599         //Resets emergency withdrawal proposal. Investors must vote again
1600         delete proposedWithdrawal;
1601     }
1602 
1603     //SECTION IV: CONTRACT MANAGEMENT
1604 
1605     function stopContract()
1606         onlyOwner {
1607 
1608         isStopped = true;
1609         LOG_ContractStopped();
1610     }
1611 
1612     function resumeContract()
1613         onlyOwner {
1614 
1615         isStopped = false;
1616         LOG_ContractResumed();
1617     }
1618 
1619     function changeHouseAddress(address newHouse)
1620         onlyOwner {
1621 
1622         if (newHouse == address(0x0)) throw; //changed based on audit feedback
1623         houseAddress = newHouse;
1624         LOG_HouseAddressChanged(houseAddress, newHouse);
1625     }
1626 
1627     function changeOwnerAddress(address newOwner)
1628         onlyOwner {
1629 
1630         if (newOwner == address(0x0)) throw;
1631         owner = newOwner;
1632         LOG_OwnerAddressChanged(owner, newOwner);
1633     }
1634 
1635     function changeGasLimitOfSafeSend(uint newGasLimit)
1636         onlyOwner
1637         onlyIfValidGas(newGasLimit) {
1638 
1639         safeGas = newGasLimit;
1640         LOG_GasLimitChanged(safeGas, newGasLimit);
1641     }
1642 
1643     //SECTION V: EMERGENCY WITHDRAWAL
1644 
1645     function voteEmergencyWithdrawal(bool vote)
1646         onlyInvestors
1647         onlyAfterProposed
1648         onlyIfStopped {
1649 
1650         investors[investorIDs[msg.sender]].votedForEmergencyWithdrawal = vote;
1651         LOG_EmergencyWithdrawalVote(msg.sender, vote);
1652     }
1653 
1654     function proposeEmergencyWithdrawal(address withdrawalAddress)
1655         onlyIfStopped
1656         onlyOwner {
1657 
1658         //Resets previous votes
1659         for (uint i = 1; i <= numInvestors; i++) {
1660             delete investors[i].votedForEmergencyWithdrawal;
1661         }
1662 
1663         proposedWithdrawal = WithdrawalProposal(withdrawalAddress, now);
1664         LOG_EmergencyWithdrawalProposed();
1665     }
1666 
1667     function executeEmergencyWithdrawal()
1668         onlyOwner
1669         onlyAfterProposed
1670         onlyIfStopped
1671         onlyIfEmergencyTimeOutHasPassed {
1672 
1673         uint numOfVotesInFavour;
1674         uint amountToWithdraw = this.balance;
1675 
1676         for (uint i = 1; i <= numInvestors; i++) {
1677             if (investors[i].votedForEmergencyWithdrawal == true) {
1678                 numOfVotesInFavour++;
1679                 delete investors[i].votedForEmergencyWithdrawal;
1680             }
1681         }
1682 
1683         if (numOfVotesInFavour >= emergencyWithdrawalRatio * numInvestors / 100) {
1684             if (!proposedWithdrawal.toAddress.send(amountToWithdraw)) {
1685                 LOG_EmergencyWithdrawalFailed(proposedWithdrawal.toAddress);
1686             }
1687             else {
1688                 LOG_EmergencyWithdrawalSucceeded(proposedWithdrawal.toAddress, amountToWithdraw);
1689             }
1690         }
1691         else {
1692             throw;
1693         }
1694     }
1695 
1696 }