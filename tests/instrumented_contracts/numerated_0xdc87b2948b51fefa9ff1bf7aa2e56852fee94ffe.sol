1 pragma solidity ^0.4.11;
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
1027 /// math.sol -- mixin for inline numerical wizardry
1028 
1029 // This program is free software: you can redistribute it and/or modify
1030 // it under the terms of the GNU General Public License as published by
1031 // the Free Software Foundation, either version 3 of the License, or
1032 // (at your option) any later version.
1033 
1034 // This program is distributed in the hope that it will be useful,
1035 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1036 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1037 // GNU General Public License for more details.
1038 
1039 // You should have received a copy of the GNU General Public License
1040 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1041 
1042 pragma solidity ^0.4.13;
1043 
1044 contract DSMath {
1045     function add(uint x, uint y) internal pure returns (uint z) {
1046         require((z = x + y) >= x);
1047     }
1048     function sub(uint x, uint y) internal pure returns (uint z) {
1049         require((z = x - y) <= x);
1050     }
1051     function mul(uint x, uint y) internal pure returns (uint z) {
1052         require(y == 0 || (z = x * y) / y == x);
1053     }
1054 
1055     function min(uint x, uint y) internal pure returns (uint z) {
1056         return x <= y ? x : y;
1057     }
1058     function max(uint x, uint y) internal pure returns (uint z) {
1059         return x >= y ? x : y;
1060     }
1061     function imin(int x, int y) internal pure returns (int z) {
1062         return x <= y ? x : y;
1063     }
1064     function imax(int x, int y) internal pure returns (int z) {
1065         return x >= y ? x : y;
1066     }
1067 
1068     uint constant WAD = 10 ** 18;
1069     uint constant RAY = 10 ** 27;
1070 
1071     function wmul(uint x, uint y) internal pure returns (uint z) {
1072         z = add(mul(x, y), WAD / 2) / WAD;
1073     }
1074     function rmul(uint x, uint y) internal pure returns (uint z) {
1075         z = add(mul(x, y), RAY / 2) / RAY;
1076     }
1077     function wdiv(uint x, uint y) internal pure returns (uint z) {
1078         z = add(mul(x, WAD), y / 2) / y;
1079     }
1080     function rdiv(uint x, uint y) internal pure returns (uint z) {
1081         z = add(mul(x, RAY), y / 2) / y;
1082     }
1083 
1084     // This famous algorithm is called "exponentiation by squaring"
1085     // and calculates x^n with x as fixed-point and n as regular unsigned.
1086     //
1087     // It's O(log n), instead of O(n) for naive repeated multiplication.
1088     //
1089     // These facts are why it works:
1090     //
1091     //  If n is even, then x^n = (x^2)^(n/2).
1092     //  If n is odd,  then x^n = x * x^(n-1),
1093     //   and applying the equation for even x gives
1094     //    x^n = x * (x^2)^((n-1) / 2).
1095     //
1096     //  Also, EVM division is flooring and
1097     //    floor[(n-1) / 2] = floor[n / 2].
1098     //
1099     function rpow(uint x, uint n) internal pure returns (uint z) {
1100         z = n % 2 != 0 ? x : RAY;
1101 
1102         for (n /= 2; n != 0; n /= 2) {
1103             x = rmul(x, x);
1104 
1105             if (n % 2 != 0) {
1106                 z = rmul(z, x);
1107             }
1108         }
1109     }
1110 }
1111 
1112 contract LedgerProofVerifyI {
1113     function external_oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) public;
1114     function external_oraclize_randomDS_proofVerify(bytes proof, bytes32 queryId, bytes result, string context_name)  public returns (bool);
1115 }
1116 
1117 contract Owned {
1118     address public owner;
1119 
1120     modifier onlyOwner {
1121         assert(msg.sender == owner);
1122         _;
1123     }
1124     
1125     function Owned() {
1126         owner = msg.sender;
1127     }
1128 
1129 }
1130 
1131 contract oraclizeSettings is Owned {
1132     uint constant ORACLIZE_PER_SPIN_GAS_LIMIT = 6100;
1133     uint constant ORACLIZE_BASE_GAS_LIMIT = 220000;
1134     uint safeGas = 9000;
1135     
1136     event LOG_newGasLimit(uint _gasLimit);
1137 
1138     function setSafeGas(uint _gas) 
1139             onlyOwner 
1140     {
1141         assert(ORACLIZE_BASE_GAS_LIMIT + _gas >= ORACLIZE_BASE_GAS_LIMIT);
1142         assert(_gas <= 25000);
1143         assert(_gas >= 9000); 
1144 
1145         safeGas = _gas;
1146         LOG_newGasLimit(_gas);
1147     }       
1148 }
1149 
1150 contract HouseManaged is Owned {
1151     
1152     address public houseAddress;
1153     address newOwner;
1154     bool public isStopped;
1155 
1156     event LOG_ContractStopped();
1157     event LOG_ContractResumed();
1158     event LOG_OwnerAddressChanged(address oldAddr, address newOwnerAddress);
1159     event LOG_HouseAddressChanged(address oldAddr, address newHouseAddress);
1160     
1161     modifier onlyIfNotStopped {
1162         assert(!isStopped);
1163         _;
1164     }
1165 
1166     modifier onlyIfStopped {
1167         assert(isStopped);
1168         _;
1169     }
1170     
1171     function HouseManaged() {
1172         houseAddress = msg.sender;
1173     }
1174 
1175     function stop_or_resume_Contract(bool _isStopped)
1176         onlyOwner {
1177 
1178         isStopped = _isStopped;
1179     }
1180 
1181     function changeHouse(address _newHouse)
1182         onlyOwner {
1183 
1184         assert(_newHouse != address(0x0)); 
1185         
1186         houseAddress = _newHouse;
1187         LOG_HouseAddressChanged(houseAddress, _newHouse);
1188     }
1189         
1190     function changeOwner(address _newOwner) onlyOwner {
1191         newOwner = _newOwner; 
1192     }     
1193 
1194     function acceptOwnership() {
1195         if (msg.sender == newOwner) {
1196             owner = newOwner;       
1197             LOG_OwnerAddressChanged(owner, newOwner);
1198             delete newOwner;
1199         }
1200     }
1201 }
1202 
1203 contract usingInvestorsModule is HouseManaged, oraclizeSettings {
1204     
1205     uint constant MAX_INVESTORS = 5; //maximum number of investors
1206     uint constant divestFee = 50; //divest fee percentage (10000 = 100%)
1207 
1208      struct Investor {
1209         address investorAddress;
1210         uint amountInvested;
1211         bool votedForEmergencyWithdrawal;
1212     }
1213     
1214     //Starting at 1
1215     mapping(address => uint) public investorIDs;
1216     mapping(uint => Investor) public investors;
1217     uint public numInvestors = 0;
1218 
1219     uint public invested = 0;
1220     
1221     uint public investorsProfit = 0;
1222     uint public investorsLosses = 0;
1223     bool profitDistributed;
1224     
1225     event LOG_InvestorEntrance(address indexed investor, uint amount);
1226     event LOG_InvestorCapitalUpdate(address indexed investor, int amount);
1227     event LOG_InvestorExit(address indexed investor, uint amount);
1228     event LOG_EmergencyAutoStop();
1229     
1230     event LOG_ZeroSend();
1231     event LOG_ValueIsTooBig();
1232     event LOG_FailedSend(address addr, uint value);
1233     event LOG_SuccessfulSend(address addr, uint value);
1234     
1235 
1236 
1237     modifier onlyMoreThanMinInvestment {
1238         assert(msg.value > getMinInvestment());
1239         _;
1240     }
1241 
1242     modifier onlyMoreThanZero {
1243         assert(msg.value != 0);
1244         _;
1245     }
1246 
1247     
1248     modifier onlyInvestors {
1249         assert(investorIDs[msg.sender] != 0);
1250         _;
1251     }
1252 
1253     modifier onlyNotInvestors {
1254         assert(investorIDs[msg.sender] == 0);
1255         _;
1256     }
1257     
1258     modifier investorsInvariant {
1259         _;
1260         assert(numInvestors <= MAX_INVESTORS);
1261     }
1262      
1263     function getBankroll()
1264         constant
1265         returns(uint) {
1266 
1267         if ((invested < investorsProfit) ||
1268             (invested + investorsProfit < invested) ||
1269             (invested + investorsProfit < investorsLosses)) {
1270             return 0;
1271         }
1272         else {
1273             return invested + investorsProfit - investorsLosses;
1274         }
1275     }
1276 
1277     function getMinInvestment()
1278         constant
1279         returns(uint) {
1280 
1281         if (numInvestors == MAX_INVESTORS) {
1282             uint investorID = searchSmallestInvestor();
1283             return getBalance(investors[investorID].investorAddress);
1284         }
1285         else {
1286             return 0;
1287         }
1288     }
1289 
1290     function getLossesShare(address currentInvestor)
1291         constant
1292         returns (uint) {
1293 
1294         return (investors[investorIDs[currentInvestor]].amountInvested * investorsLosses) / invested;
1295     }
1296 
1297     function getProfitShare(address currentInvestor)
1298         constant
1299         returns (uint) {
1300 
1301         return (investors[investorIDs[currentInvestor]].amountInvested * investorsProfit) / invested;
1302     }
1303 
1304     function getBalance(address currentInvestor)
1305         constant
1306         returns (uint) {
1307 
1308         uint invested = investors[investorIDs[currentInvestor]].amountInvested;
1309         uint profit = getProfitShare(currentInvestor);
1310         uint losses = getLossesShare(currentInvestor);
1311 
1312         if ((invested + profit < profit) ||
1313             (invested + profit < invested) ||
1314             (invested + profit < losses))
1315             return 0;
1316         else
1317             return invested + profit - losses;
1318     }
1319 
1320     function searchSmallestInvestor()
1321         constant
1322         returns(uint) {
1323 
1324         uint investorID = 1;
1325         for (uint i = 1; i <= numInvestors; i++) {
1326             if (getBalance(investors[i].investorAddress) < getBalance(investors[investorID].investorAddress)) {
1327                 investorID = i;
1328             }
1329         }
1330 
1331         return investorID;
1332     }
1333 
1334     
1335     function addInvestorAtID(uint id)
1336         private {
1337 
1338         investorIDs[msg.sender] = id;
1339         investors[id].investorAddress = msg.sender;
1340         investors[id].amountInvested = msg.value;
1341         invested += msg.value;
1342 
1343         LOG_InvestorEntrance(msg.sender, msg.value);
1344     }
1345 
1346     function profitDistribution()
1347         private {
1348 
1349         if (profitDistributed) return;
1350                 
1351         uint copyInvested;
1352 
1353         for (uint i = 1; i <= numInvestors; i++) {
1354             address currentInvestor = investors[i].investorAddress;
1355             uint profitOfInvestor = getProfitShare(currentInvestor);
1356             uint lossesOfInvestor = getLossesShare(currentInvestor);
1357             
1358             //Check for overflow and underflow
1359             if ((investors[i].amountInvested + profitOfInvestor >= investors[i].amountInvested) &&
1360                 (investors[i].amountInvested + profitOfInvestor >= lossesOfInvestor))  {
1361                 investors[i].amountInvested += profitOfInvestor - lossesOfInvestor;
1362                 LOG_InvestorCapitalUpdate(currentInvestor, (int) (profitOfInvestor - lossesOfInvestor));
1363             }
1364             else {
1365                 isStopped = true;
1366                 LOG_EmergencyAutoStop();
1367             }
1368 
1369             copyInvested += investors[i].amountInvested; 
1370 
1371         }
1372 
1373         delete investorsProfit;
1374         delete investorsLosses;
1375         invested = copyInvested;
1376 
1377         profitDistributed = true;
1378     }
1379     
1380     function increaseInvestment()
1381         payable
1382         onlyIfNotStopped
1383         onlyMoreThanZero
1384         onlyInvestors  {
1385 
1386         profitDistribution();
1387         investors[investorIDs[msg.sender]].amountInvested += msg.value;
1388         invested += msg.value;
1389     }
1390 
1391     function newInvestor()
1392         payable
1393         onlyIfNotStopped
1394         onlyMoreThanZero
1395         onlyNotInvestors
1396         onlyMoreThanMinInvestment
1397         investorsInvariant {
1398 
1399         profitDistribution();
1400 
1401         if (numInvestors == MAX_INVESTORS) {
1402             uint smallestInvestorID = searchSmallestInvestor();
1403             divest(investors[smallestInvestorID].investorAddress);
1404         }
1405 
1406         numInvestors++;
1407         addInvestorAtID(numInvestors);
1408     }
1409 
1410     function divest()
1411         onlyInvestors {
1412 
1413         divest(msg.sender);
1414     }
1415 
1416 
1417     function divest(address currentInvestor)
1418         internal
1419         investorsInvariant {
1420 
1421         profitDistribution();
1422         uint currentID = investorIDs[currentInvestor];
1423         uint amountToReturn = getBalance(currentInvestor);
1424 
1425         if (invested >= investors[currentID].amountInvested) {
1426             invested -= investors[currentID].amountInvested;
1427             uint divestFeeAmount =  (amountToReturn*divestFee)/10000;
1428             amountToReturn -= divestFeeAmount;
1429 
1430             delete investors[currentID];
1431             delete investorIDs[currentInvestor];
1432 
1433             //Reorder investors
1434             if (currentID != numInvestors) {
1435                 // Get last investor
1436                 Investor lastInvestor = investors[numInvestors];
1437                 //Set last investor ID to investorID of divesting account
1438                 investorIDs[lastInvestor.investorAddress] = currentID;
1439                 //Copy investor at the new position in the mapping
1440                 investors[currentID] = lastInvestor;
1441                 //Delete old position in the mappping
1442                 delete investors[numInvestors];
1443             }
1444 
1445             numInvestors--;
1446             safeSend(currentInvestor, amountToReturn);
1447             safeSend(houseAddress, divestFeeAmount);
1448             LOG_InvestorExit(currentInvestor, amountToReturn);
1449         } else {
1450             isStopped = true;
1451             LOG_EmergencyAutoStop();
1452         }
1453     }
1454     
1455     function forceDivestOfAllInvestors()
1456         onlyOwner {
1457             
1458         uint copyNumInvestors = numInvestors;
1459         for (uint i = 1; i <= copyNumInvestors; i++) {
1460             divest(investors[1].investorAddress);
1461         }
1462     }
1463     
1464     function safeSend(address addr, uint value)
1465         internal {
1466 
1467         if (value == 0) {
1468             LOG_ZeroSend();
1469             return;
1470         }
1471 
1472         if (this.balance < value) {
1473             LOG_ValueIsTooBig();
1474             return;
1475         }
1476 
1477         if (!(addr.call.gas(safeGas).value(value)())) {
1478             LOG_FailedSend(addr, value);
1479             if (addr != houseAddress) {
1480                 //Forward to house address all change
1481                 if (!(houseAddress.call.gas(safeGas).value(value)())) LOG_FailedSend(houseAddress, value);
1482             }
1483         }
1484 
1485         LOG_SuccessfulSend(addr,value);
1486     }
1487 }
1488 
1489 contract EmergencyWithdrawalModule is usingInvestorsModule {
1490     uint constant EMERGENCY_WITHDRAWAL_RATIO = 80; //ratio percentage (100 = 100%)
1491     uint constant EMERGENCY_TIMEOUT = 3 days;
1492     
1493     struct WithdrawalProposal {
1494         address toAddress;
1495         uint atTime;
1496     }
1497     
1498     WithdrawalProposal public proposedWithdrawal;
1499     
1500     event LOG_EmergencyWithdrawalProposed();
1501     event LOG_EmergencyWithdrawalFailed(address indexed withdrawalAddress);
1502     event LOG_EmergencyWithdrawalSucceeded(address indexed withdrawalAddress, uint amountWithdrawn);
1503     event LOG_EmergencyWithdrawalVote(address indexed investor, bool vote);
1504     
1505     modifier onlyAfterProposed {
1506         assert(proposedWithdrawal.toAddress != 0);
1507         _;
1508     }
1509     
1510     modifier onlyIfEmergencyTimeOutHasPassed {
1511         assert(proposedWithdrawal.atTime + EMERGENCY_TIMEOUT <= now);
1512         _;
1513     }
1514     
1515     function voteEmergencyWithdrawal(bool vote)
1516         onlyInvestors
1517         onlyAfterProposed
1518         onlyIfStopped {
1519 
1520         investors[investorIDs[msg.sender]].votedForEmergencyWithdrawal = vote;
1521         LOG_EmergencyWithdrawalVote(msg.sender, vote);
1522     }
1523 
1524     function proposeEmergencyWithdrawal(address withdrawalAddress)
1525         onlyIfStopped
1526         onlyOwner {
1527 
1528         //Resets previous votes
1529         for (uint i = 1; i <= numInvestors; i++) {
1530             delete investors[i].votedForEmergencyWithdrawal;
1531         }
1532 
1533         proposedWithdrawal = WithdrawalProposal(withdrawalAddress, now);
1534         LOG_EmergencyWithdrawalProposed();
1535     }
1536 
1537     function executeEmergencyWithdrawal()
1538         onlyOwner
1539         onlyAfterProposed
1540         onlyIfStopped
1541         onlyIfEmergencyTimeOutHasPassed {
1542 
1543         uint numOfVotesInFavour;
1544         uint amountToWithdraw = this.balance;
1545 
1546         for (uint i = 1; i <= numInvestors; i++) {
1547             if (investors[i].votedForEmergencyWithdrawal == true) {
1548                 numOfVotesInFavour++;
1549                 delete investors[i].votedForEmergencyWithdrawal;
1550             }
1551         }
1552 
1553         if (numOfVotesInFavour >= EMERGENCY_WITHDRAWAL_RATIO * numInvestors / 100) {
1554             if (!proposedWithdrawal.toAddress.send(amountToWithdraw)) {
1555                 LOG_EmergencyWithdrawalFailed(proposedWithdrawal.toAddress);
1556             }
1557             else {
1558                 LOG_EmergencyWithdrawalSucceeded(proposedWithdrawal.toAddress, amountToWithdraw);
1559             }
1560         }
1561         else {
1562             revert();
1563         }
1564     }
1565     
1566         /*
1567     The owner can use this function to force the exit of an investor from the
1568     contract during an emergency withdrawal in the following situations:
1569         - Unresponsive investor
1570         - Investor demanding to be paid in other to vote, the facto-blackmailing
1571         other investors
1572     */
1573     function forceDivestOfOneInvestor(address currentInvestor)
1574         onlyOwner
1575         onlyIfStopped {
1576 
1577         divest(currentInvestor);
1578         //Resets emergency withdrawal proposal. Investors must vote again
1579         delete proposedWithdrawal;
1580     }
1581 }
1582 
1583 contract Slot is usingOraclize, EmergencyWithdrawalModule, DSMath {
1584     
1585     uint constant INVESTORS_EDGE = 200; 
1586     uint constant HOUSE_EDGE = 50;
1587     uint constant CAPITAL_RISK = 250;
1588     uint constant MAX_SPINS = 16;
1589     
1590     uint minBet = 1 wei;
1591  
1592     struct SpinsContainer {
1593         address playerAddress;
1594         uint nSpins;
1595         uint amountWagered;
1596     }
1597     
1598     mapping (bytes32 => SpinsContainer) spins;
1599     
1600     /* Both arrays are ordered:
1601      - probabilities are ordered from smallest to highest
1602      - multipliers are ordered from highest to lowest
1603      The probabilities are expressed as integer numbers over a scale of 10000: i.e
1604      100 is equivalent to 1%, 5000 to 50% and so on.
1605     */
1606     uint[] public probabilities;
1607     uint[] public multipliers;
1608     
1609     uint public totalAmountWagered; 
1610     
1611     event LOG_newSpinsContainer(bytes32 myid, address playerAddress, uint amountWagered, uint nSpins);
1612     event LOG_SpinExecuted(bytes32 myid, address playerAddress, uint spinIndex, uint numberDrawn, uint grossPayoutForSpin);
1613     event LOG_SpinsContainerInfo(bytes32 myid, address playerAddress, uint netPayout);
1614     event LOG_ProofFailure(bytes32 myid, address playerAddress);
1615 
1616     LedgerProofVerifyI externalContract;
1617     
1618     function Slot(address _verifierAddr) {
1619         externalContract = LedgerProofVerifyI(_verifierAddr);
1620     }
1621     
1622     //SECTION I: MODIFIERS AND HELPER FUNCTIONS
1623     
1624     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1625         externalContract.external_oraclize_randomDS_setCommitment(queryId, commitment);
1626     }
1627     
1628     modifier onlyOraclize {
1629         assert(msg.sender == oraclize_cbAddress());
1630         _;
1631     }
1632 
1633     modifier onlyIfSpinsExist(bytes32 myid) {
1634         require(spins[myid].playerAddress != address(0x0));
1635         _;
1636     }
1637     
1638     function isValidSize(uint _amountWagered) 
1639         internal 
1640         returns(bool) {
1641             
1642         uint netPotentialPayout = (_amountWagered * (10000 - INVESTORS_EDGE) * multipliers[0])/ 10000; 
1643         uint maxAllowedPayout = (CAPITAL_RISK * getBankroll())/10000;
1644         
1645         return ((netPotentialPayout <= maxAllowedPayout) && (_amountWagered >= minBet));
1646     }
1647 
1648     modifier onlyIfEnoughFunds(bytes32 myid) {
1649         if (isValidSize(spins[myid].amountWagered)) {
1650              _;
1651         }
1652         else {
1653             address playerAddress = spins[myid].playerAddress;
1654             uint amountWagered = spins[myid].amountWagered;   
1655             delete spins[myid];
1656             safeSend(playerAddress, amountWagered);
1657             return;
1658         }
1659     }
1660     
1661 
1662     modifier onlyValidNumberOfSpins (uint _nSpins) {
1663         assert(_nSpins <= MAX_SPINS);
1664               assert(_nSpins > 0);
1665         _;
1666     }
1667     
1668     /*
1669         For the game to be fair, the total gross payout over a large number of 
1670         individual slot spins should be the total amount wagered by the player. 
1671         
1672         The game owner, called house, and the investors will gain by applying 
1673         a small fee, called edge, to the amount won by the player in the case of
1674         a successful spin. 
1675         
1676         The total gross expected payout is equal to the sum of all payout. Each 
1677         i-th payout is calculated:
1678                     amountWagered * multipliers[i] * probabilities[i] 
1679         The fairness condition can be expressed as the equation:
1680                     sum of aW * m[i] * p[i] = aW
1681         After having simplified the equation:
1682                         sum of m[i] * p[i] = 1
1683         Since our probabilities are defined over 10000, the sum should be 10000.
1684         
1685         The contract owner can modify the multipliers and probabilities array, 
1686         but the  modifier enforces that the number choosen always result in a 
1687         fare game.
1688     */
1689     modifier onlyIfFair(uint[] _prob, uint[] _payouts) {
1690         if (_prob.length != _payouts.length) revert();
1691         uint sum = 0;
1692         for (uint i = 0; i <_prob.length; i++) {
1693             sum += _prob[i] * _payouts[i];     
1694         }
1695         assert(sum == 10000);
1696         _;
1697     }
1698 
1699     function()
1700         payable {
1701         buySpins(1);
1702     }
1703 
1704     function buySpins(uint _nSpins) 
1705         payable 
1706         onlyValidNumberOfSpins(_nSpins) 
1707                     onlyIfNotStopped {
1708             
1709         uint gas = _nSpins*ORACLIZE_PER_SPIN_GAS_LIMIT + ORACLIZE_BASE_GAS_LIMIT + safeGas;
1710         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("random", gas);
1711         
1712         // Disallow bets that even when maximally winning are a loss for player 
1713         // due to oraclizeFee
1714         assert(oraclizeFee/multipliers[0] + oraclizeFee < msg.value);
1715         uint amountWagered = msg.value - oraclizeFee;
1716         assert(isValidSize(amountWagered));
1717         
1718         bytes32 queryId = oraclize_newRandomDSQuery(0, 2*_nSpins, gas);
1719         spins[queryId] = 
1720             SpinsContainer(msg.sender,
1721                    _nSpins,
1722                    amountWagered
1723                   );
1724         LOG_newSpinsContainer(queryId, msg.sender, amountWagered, _nSpins);
1725         totalAmountWagered += amountWagered;
1726     }
1727     
1728     function executeSpins(bytes32 myid, bytes randomBytes) 
1729         private 
1730         returns(uint)
1731     {
1732         uint amountWonTotal = 0;
1733         uint amountWonSpin = 0;
1734         uint numberDrawn = 0;
1735         uint rangeUpperEnd = 0;
1736         uint nSpins = spins[myid].nSpins;
1737         
1738         for (uint i = 0; i < 2*nSpins; i += 2) {
1739             // A number between 0 and 2**16, normalized over 0 - 10000
1740             numberDrawn = ((uint(randomBytes[i])*256 + uint(randomBytes[i+1]))*10000)/2**16;
1741             rangeUpperEnd = 0;
1742             amountWonSpin = 0;
1743             for (uint j = 0; j < probabilities.length; j++) {
1744                 rangeUpperEnd += probabilities[j];
1745                 if (numberDrawn < rangeUpperEnd) {
1746                     amountWonSpin = (spins[myid].amountWagered * multipliers[j]) / nSpins;
1747                     amountWonTotal += amountWonSpin;
1748                     break;
1749                 }
1750             }
1751             LOG_SpinExecuted(myid, spins[myid].playerAddress, i/2, numberDrawn, amountWonSpin);
1752         }
1753         return amountWonTotal;
1754     }
1755     
1756     function sendPayout(bytes32 myid, uint payout) private {
1757 
1758         uint investorsFee = payout*INVESTORS_EDGE/10000; 
1759         uint houseFee = payout*HOUSE_EDGE/10000;
1760       
1761         uint netPlayerPayout = sub(sub(payout,investorsFee), houseFee);
1762         uint netCostForInvestors = add(netPlayerPayout, houseFee);
1763 
1764         if (netCostForInvestors >= spins[myid].amountWagered) {
1765             investorsLosses += sub(netCostForInvestors, spins[myid].amountWagered);
1766         }
1767         else {
1768             investorsProfit += sub(spins[myid].amountWagered, netCostForInvestors);
1769         }
1770         
1771         LOG_SpinsContainerInfo(myid, spins[myid].playerAddress, netPlayerPayout);
1772         safeSend(spins[myid].playerAddress, netPlayerPayout);
1773         safeSend(houseAddress, houseFee);
1774     }
1775     
1776     function __callback(bytes32 myid, string result, bytes _proof) 
1777         onlyOraclize
1778         onlyIfSpinsExist(myid)
1779         onlyIfEnoughFunds(myid)
1780     {
1781         // If the proof fails, return amount wagered to the player
1782         if(!externalContract.external_oraclize_randomDS_proofVerify(_proof, myid, bytes(result), oraclize_getNetworkName())) {
1783             refundPlayer(myid);
1784         }
1785         else {
1786             uint payout = executeSpins(myid, bytes(result));
1787         
1788             sendPayout(myid, payout);
1789         
1790             delete profitDistributed;
1791         }
1792 
1793         delete spins[myid];
1794     }
1795 
1796     function refundPlayer(bytes32 myid) private {
1797         LOG_ProofFailure(myid, spins[myid].playerAddress);
1798         safeSend(spins[myid].playerAddress, spins[myid].amountWagered);
1799     }
1800     
1801     // SETTERS - SETTINGS ACCESSIBLE BY OWNER
1802     
1803     // Check ordering as well, since ordering assumptions are made in _callback 
1804     // and elsewhere
1805     function setConfiguration(uint[] _probabilities, uint[] _multipliers) 
1806         onlyOwner 
1807         onlyIfFair(_probabilities, _multipliers) {
1808                 
1809         oraclize_setProof(proofType_Ledger); //This is here to reduce gas cost as this function has to be called anyway for initialization
1810         
1811         delete probabilities;
1812         delete multipliers;
1813         
1814         uint lastProbability = 0;
1815         uint lastMultiplier = 2**256 - 1;
1816         
1817         for (uint i = 0; i < _probabilities.length; i++) {
1818             probabilities.push(_probabilities[i]);
1819             if (lastProbability >= _probabilities[i]) revert();
1820             lastProbability = _probabilities[i];
1821         }
1822         
1823         for (i = 0; i < _multipliers.length; i++) {
1824             multipliers.push(_multipliers[i]);
1825             if (lastMultiplier <= _multipliers[i]) revert();
1826             lastMultiplier = _multipliers[i];
1827         }
1828     }
1829     
1830     function setMinBet(uint _minBet) onlyOwner {
1831         minBet = _minBet;
1832     }
1833     
1834     // GETTERS - CONSTANT METHODS
1835     
1836     function getSpinsContainer(bytes32 myid)
1837         constant
1838         returns(address, uint) {
1839         return (spins[myid].playerAddress, spins[myid].amountWagered); 
1840     }
1841 
1842     // Returns minimal amount to wager to return a profit in case of max win
1843     function getMinAmountToWager(uint _nSpins)
1844         onlyValidNumberOfSpins(_nSpins)
1845         constant
1846                 returns(uint) {
1847         uint gas = _nSpins*ORACLIZE_PER_SPIN_GAS_LIMIT + ORACLIZE_BASE_GAS_LIMIT + safeGas;
1848         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("random", gas);
1849         return minBet + oraclizeFee/multipliers[0] + oraclizeFee;
1850     }
1851    
1852     function getMaxAmountToWager(uint _nSpins)
1853         onlyValidNumberOfSpins(_nSpins)
1854         constant
1855         returns(uint) {
1856 
1857         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("random", _nSpins*ORACLIZE_PER_SPIN_GAS_LIMIT + ORACLIZE_BASE_GAS_LIMIT + safeGas);
1858         uint maxWage =  (CAPITAL_RISK * getBankroll())*10000/((10000 - INVESTORS_EDGE)*10000*multipliers[0]);
1859         return maxWage + oraclizeFee;
1860     }
1861     
1862 }