1 pragma solidity ^0.4.17;
2 
3 
4 /********************************* Oraclize API ************************************************/
5 // The Oraclize API has been put into the same file to make Etherscan verification easier.
6 // FOR THE TOKEN CONTRACTS SCROLL DOWN TO ABOUT LINE 1000
7 
8 
9 // <ORACLIZE_API>
10 /*
11 Copyright (c) 2015-2016 Oraclize SRL
12 Copyright (c) 2016 Oraclize LTD
13 
14 
15 
16 Permission is hereby granted, free of charge, to any person obtaining a copy
17 of this software and associated documentation files (the "Software"), to deal
18 in the Software without restriction, including without limitation the rights
19 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 copies of the Software, and to permit persons to whom the Software is
21 furnished to do so, subject to the following conditions:
22 
23 
24 
25 The above copyright notice and this permission notice shall be included in
26 all copies or substantial portions of the Software.
27 
28 
29 
30 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
31 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
32 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
33 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
34 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
35 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
36 THE SOFTWARE.
37 */
38 
39 contract OraclizeI {
40     address public cbAddress;
41     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
42     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
43     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
44     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
45     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
46     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
47     function getPrice(string _datasource) returns (uint _dsprice);
48     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
49     function useCoupon(string _coupon);
50     function setProofType(byte _proofType);
51     function setConfig(bytes32 _config);
52     function setCustomGasPrice(uint _gasPrice);
53     function randomDS_getSessionPubKeyHash() returns(bytes32);
54 }
55 contract OraclizeAddrResolverI {
56     function getAddress() returns (address _addr);
57 }
58 contract usingOraclize {
59     uint constant day = 60*60*24;
60     uint constant week = 60*60*24*7;
61     uint constant month = 60*60*24*30;
62     byte constant proofType_NONE = 0x00;
63     byte constant proofType_TLSNotary = 0x10;
64     byte constant proofType_Android = 0x20;
65     byte constant proofType_Ledger = 0x30;
66     byte constant proofType_Native = 0xF0;
67     byte constant proofStorage_IPFS = 0x01;
68     uint8 constant networkID_auto = 0;
69     uint8 constant networkID_mainnet = 1;
70     uint8 constant networkID_testnet = 2;
71     uint8 constant networkID_morden = 2;
72     uint8 constant networkID_consensys = 161;
73 
74     OraclizeAddrResolverI OAR;
75 
76     OraclizeI oraclize;
77     modifier oraclizeAPI {
78         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
79         oraclize = OraclizeI(OAR.getAddress());
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
866     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
867         bool match_ = true;
868 
869         for (var i=0; i<prefix.length; i++){
870             if (content[i] != prefix[i]) match_ = false;
871         }
872 
873         return match_;
874     }
875 
876     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
877         bool checkok;
878 
879 
880         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
881         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
882         bytes memory keyhash = new bytes(32);
883         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
884         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
885         if (checkok == false) return false;
886 
887         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
888         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
889 
890 
891         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
892         checkok = matchBytes32Prefix(sha256(sig1), result);
893         if (checkok == false) return false;
894 
895 
896         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
897         // This is to verify that the computed args match with the ones specified in the query.
898         bytes memory commitmentSlice1 = new bytes(8+1+32);
899         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
900 
901         bytes memory sessionPubkey = new bytes(64);
902         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
903         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
904 
905         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
906         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
907             delete oraclize_randomDS_args[queryId];
908         } else return false;
909 
910 
911         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
912         bytes memory tosign1 = new bytes(32+8+1+32);
913         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
914         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
915         if (checkok == false) return false;
916 
917         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
918         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
919             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
920         }
921 
922         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
923     }
924 
925 
926     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
927     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
928         uint minLength = length + toOffset;
929 
930         if (to.length < minLength) {
931             // Buffer too small
932             throw; // Should be a better way?
933         }
934 
935         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
936         uint i = 32 + fromOffset;
937         uint j = 32 + toOffset;
938 
939         while (i < (32 + fromOffset + length)) {
940             assembly {
941                 let tmp := mload(add(from, i))
942                 mstore(add(to, j), tmp)
943             }
944             i += 32;
945             j += 32;
946         }
947 
948         return to;
949     }
950 
951     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
952     // Duplicate Solidity's ecrecover, but catching the CALL return value
953     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
954         // We do our own memory management here. Solidity uses memory offset
955         // 0x40 to store the current end of memory. We write past it (as
956         // writes are memory extensions), but don't update the offset so
957         // Solidity will reuse it. The memory used here is only needed for
958         // this context.
959 
960         // FIXME: inline assembly can't access return values
961         bool ret;
962         address addr;
963 
964         assembly {
965             let size := mload(0x40)
966             mstore(size, hash)
967             mstore(add(size, 32), v)
968             mstore(add(size, 64), r)
969             mstore(add(size, 96), s)
970 
971             // NOTE: we can reuse the request memory because we deal with
972             //       the return code
973             ret := call(3000, 1, 0, size, 128, size, 32)
974             addr := mload(size)
975         }
976 
977         return (ret, addr);
978     }
979 
980     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
981     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
982         bytes32 r;
983         bytes32 s;
984         uint8 v;
985 
986         if (sig.length != 65)
987           return (false, 0);
988 
989         // The signature format is a compact form of:
990         //   {bytes32 r}{bytes32 s}{uint8 v}
991         // Compact means, uint8 is not padded to 32 bytes.
992         assembly {
993             r := mload(add(sig, 32))
994             s := mload(add(sig, 64))
995 
996             // Here we are loading the last 32 bytes. We exploit the fact that
997             // 'mload' will pad with zeroes if we overread.
998             // There is no 'mload8' to do this, but that would be nicer.
999             v := byte(0, mload(add(sig, 96)))
1000 
1001             // Alternative solution:
1002             // 'byte' is not working due to the Solidity parser, so lets
1003             // use the second best option, 'and'
1004             // v := and(mload(add(sig, 65)), 255)
1005         }
1006 
1007         // albeit non-transactional signatures are not specified by the YP, one would expect it
1008         // to match the YP range of [27, 28]
1009         //
1010         // geth uses [0, 1] and some clients have followed. This might change, see:
1011         //  https://github.com/ethereum/go-ethereum/issues/2053
1012         if (v < 27)
1013           v += 27;
1014 
1015         if (v != 27 && v != 28)
1016             return (false, 0);
1017 
1018         return safer_ecrecover(hash, v, r, s);
1019     }
1020 
1021 }
1022 // </ORACLIZE_API>
1023 
1024 
1025 
1026 
1027 /*************************************** Trump Token Contracts *********************************/
1028 
1029 /* This is the full TrumpImpeachmentToken contract.
1030 
1031 Copyright 2017 by the holders of this Ethereum address:
1032 0x454dDD95B0Bc3D30224bdA5639F29d7fa16CFa0b
1033 
1034 
1035 This contract is based on substantial amount of inheritance, each new subclass
1036 adding one particular peace of functionality.
1037 
1038 The inheritance graph looks like this:
1039 
1040 
1041             ERC20Interface
1042                  |
1043                  |
1044             ERC20Implementation
1045                  |
1046                  |
1047             LittleSisterToken
1048                /          \
1049               /            \
1050              /          BigSisterToken
1051             /                 |
1052            |                  |
1053    PriceIncreasingLST     PriceIncreasingToken                 usingOraclize
1054             |                                \                      |
1055             |                                \                      |
1056             |                           TimedEvidenceToken  TrumpOralce   StingOps
1057             |                                         \          /       /
1058             |                                         \         /       /
1059     TumpFullTermToken                             TrumpImpeachmentToken
1060 
1061 
1062 
1063  ERC20Token: Sending and receiving Tokens between holders
1064 
1065  Little/BigSisterToken: Buying and Selling tokens from and to contract
1066 
1067  PriceIncreasingToken/PriceIncreasingLST: Increase buyPrice over time
1068                                           to make the token more expensive
1069 
1070 TimedEvidenceToken: Checks for winning conditions and suspends and
1071                     activates buying and selling
1072 
1073 TrumpOracle: Use oraclize to answer who is President of the United States?
1074 
1075 StringOps: String comparison, check if one string ends with another
1076 
1077 TrumpImpeachmentToken: Combines TimedEvidenceToken and Oraclize
1078 
1079 TumpFullTermToken: LittleSister of TrumpImpeachmentToken
1080 
1081 */
1082 
1083 
1084 // Contract with just one string function endswith
1085 contract StringOps {
1086 
1087     // returns true if string _a ends with string _b
1088     function stringEndsWith(string _a, string _b) internal returns (bool) {
1089         // convert to bytes because strings are rather powerless in Solidity as of 0.4.x
1090         bytes memory a = bytes(_a);
1091         bytes memory b = bytes(_b);
1092 
1093         // in case a is shorter than b, a most certainly cannot end with b
1094         if (a.length < b.length){
1095             return false;
1096         }
1097 
1098         // Difference in length between a and b, also offset for a
1099         uint length_diff = a.length - b.length;
1100 
1101         for (uint i = 0; i < b.length; i ++)
1102             // Check letter by letter, with an offset by length_diff
1103             if (a[i + length_diff] != b[i]){
1104                 return false;
1105             }
1106         return true;
1107     }
1108 
1109 }
1110 
1111 
1112 // ERC Token standard #20 Interface
1113 // https://github.com/ethereum/EIPs/issues/20
1114 contract ERC20Interface {
1115 
1116     // Get the total token supply
1117     function totalSupply() public constant returns (uint256 supply);
1118 
1119     // Get the account balance of another account with address _owner
1120     function balanceOf(address _owner) public constant returns (uint256 balance);
1121 
1122     // Send _value amount of tokens to address _to
1123     function transfer(address _to, uint256 _value) public returns (bool success);
1124 
1125     // Send _value amount of tokens from address _from to address _to
1126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
1127 
1128     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
1129     // If this function is called again it overwrites the current allowance with _value.
1130     // this function is required for some DEX functionality
1131     function approve(address _spender, uint256 _value) public returns (bool success);
1132 
1133     // Returns the amount which _spender is still allowed to withdraw from _owner
1134     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
1135 
1136     // Triggered when tokens are transferred.
1137     event Transfer(address indexed _from, address indexed _to, uint256 _value);
1138 
1139     // Triggered whenever approve(address _spender, uint256 _value) is called.
1140     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
1141 }
1142 
1143 
1144 // Implementation of the most intricate parts of the ERC20Interface that
1145 // allows to send tokens around
1146 contract ERC20Token is ERC20Interface{
1147 
1148     // The three letter symbol to define the token, should be overwritten in subclass
1149     string public constant symbol = "TBA";
1150 
1151     // Name of token should be overwritten in child
1152     string public constant name = "TBA";
1153 
1154     // The number of decimals, 6 should be enough (srsly who needs 18??)
1155     uint8 public constant decimals = 6;
1156 
1157     // With 6 decimals, a single unit is 10**6
1158     uint256 public constant unit = 1000000;
1159 
1160     // Balances for each account
1161     mapping(address => uint256) balances;
1162 
1163     // Owner of account approves the transfer of amount to another account
1164     mapping(address => mapping (address => uint256)) allowed;
1165 
1166     // What is the balance of a particular account?
1167     function balanceOf(address _owner) public constant returns (uint256) {
1168         return balances[_owner];
1169     }
1170 
1171     // Transfer the balance from owner's account to another account
1172     function transfer(address _to, uint256 _amount) public returns (bool) {
1173         if (balances[msg.sender] >= _amount && _amount > 0
1174                 && balances[_to] + _amount > balances[_to]) {
1175             balances[msg.sender] -= _amount;
1176             balances[_to] += _amount;
1177             Transfer(msg.sender, _to, _amount);
1178             return true;
1179         } else {
1180             return false;
1181         }
1182     }
1183 
1184     // Send _value amount of tokens from address _from to address _to
1185     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
1186     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
1187     // fees in sub-currencies; the command should fail unless the _from account has
1188     // deliberately authorized the sender of the message via some mechanism; we propose
1189     // these standardized APIs for approval:
1190     function transferFrom(
1191         address _from,
1192         address _to,
1193         uint256 _amount
1194     ) public returns (bool) {
1195         if (balances[_from] >= _amount
1196             && allowed[_from][msg.sender] >= _amount && _amount > 0
1197                 && balances[_to] + _amount > balances[_to]) {
1198             balances[_from] -= _amount;
1199             allowed[_from][msg.sender] -= _amount;
1200             balances[_to] += _amount;
1201             Transfer(_from, _to, _amount);
1202             return true;
1203         } else {
1204             return false;
1205         }
1206     }
1207 
1208     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
1209     // If this function is called again it overwrites the current allowance with _value.
1210     function approve(address _spender, uint256 _amount) public returns (bool) {
1211         allowed[msg.sender][_spender] = _amount;
1212         Approval(msg.sender, _spender, _amount);
1213         return true;
1214     }
1215 
1216     // Function to specify how much _spender is allowed to transfer on _owner's behalf
1217     function allowance(address _owner, address _spender) public constant returns (uint256) {
1218         return allowed[_owner][_spender];
1219     }
1220 
1221 }
1222 
1223 
1224 /*
1225 
1226 The LittleSister allows selling and buying of tokens while paying a vig to the owner.
1227 
1228 However, the LittleSisterToken is feeling insecure alone and needs to be guided by her
1229 BigSistersToken that tells her how much stuff is worth.
1230 
1231 Both contracts are useless unless they know of each other via registerSister of the
1232 BigSisterToken.
1233 
1234 */
1235 contract LittleSisterToken is ERC20Token{
1236 
1237     // The vig sent to the owner for each buying transaction
1238     // e.g. vig = 40 -> amount / 40 -> 2.5% are deducted
1239     uint8 public vig;
1240 
1241     // Maximum Supply of tokens, same as for the BigSisterToken
1242     // Note that totalSupply_BigSister + totalSupply_LittleSister <= maxSupply
1243     uint256 public maxSupply;
1244 
1245     // currently circulating Supply bounded by maxSupply (see above)
1246     uint256 totalSupply_;
1247 
1248     // Maximum date contract lives on its own, afterwards contract can be destroyed
1249     // Should be a picked far, far in the future to allow Token holders enough time to redeem their
1250     // winnings
1251     uint public validityDate;
1252 
1253     // Maximum date unitl buying is still possible
1254     uint public maxBuyingDate;
1255 
1256     // Address of the (big) sister of the contract
1257     address public sister;
1258 
1259     // Owners of this contract, awesome people!
1260     address public owner;
1261 
1262     // Address to send vig to
1263     address public vigAddress;
1264 
1265     // If contract has lost, i.e. if so, the other contract has won (obviously)
1266     bool public lost;
1267 
1268     // Constructor only sets owner and totalSupply, other properties are either
1269     // taken from the big sister or set during registering
1270     function LittleSisterToken() {
1271         owner = msg.sender;
1272         vigAddress = msg.sender;
1273         totalSupply_ = 0;
1274         lost = false;
1275     }
1276 
1277     // fallback function, note only the big sister can send funds to this contract
1278     // without buying, other people just buy the tokens
1279     function () payable {
1280         if (msg.sender != sister){
1281             buy();
1282         }
1283     }
1284 
1285     // Changes the vig address
1286     function setVigAddress(address _newVigAddress) public {
1287         require(msg.sender == owner);
1288         vigAddress = _newVigAddress;
1289     }
1290 
1291     // What is total circulating supply?
1292     function totalSupply() public constant returns (uint256) {
1293         return totalSupply_;
1294     }
1295 
1296     // function to link big and little sister, this one can only be
1297     // called by the big sister and only once
1298     // Once linked contracts CANNOT be unlinked or replaced!
1299     function registerSister(address _sister) public returns (bool) {
1300         BigSisterToken sisterContract;
1301 
1302         // take care that registering can only be called once and the sister
1303         // cannot be changed afterwards
1304         require(sister == address(0));
1305         // can only be called from the big sister, linking can be invoked there by the owner
1306         require(_sister != address(this));
1307 
1308         // Check that the big sister is who she claims to be
1309         sisterContract = BigSisterToken(_sister);
1310         require(sisterContract.owner() == owner);
1311         require(sisterContract.sister() == address(this));
1312 
1313         // she can be trusted and is accepted as the new big sister
1314         sister = _sister;
1315 
1316         // maxSupply, vig and validity and max buying date should be equal to the big sister's
1317         maxSupply = sisterContract.maxSupply();
1318         vig = sisterContract.vig();
1319         validityDate = sisterContract.validityDate();
1320         maxBuyingDate = sisterContract.maxBuyingDate();
1321 
1322         return true;
1323     }
1324 
1325     // The selling price is also determined by the big sister
1326     // returns an uint256 sell price
1327     function sellPrice() public constant returns (uint256){
1328         BigSisterToken sisterContract = BigSisterToken(sister);
1329         return sisterContract.sellPrice();
1330     }
1331 
1332     // Likewise the big sister dictates the buying price
1333     function buyPrice() public constant returns (uint256){
1334         BigSisterToken sisterContract = BigSisterToken(sister);
1335         return sisterContract.buyPrice();
1336     }
1337 
1338     // Sends all the funds to the big sister, can only be invoked by her
1339     function sendFunds() public returns(bool){
1340         require(msg.sender == sister);
1341         require(msg.sender.send(this.balance));
1342         // in this case the sister won and this contract lost
1343         lost = true;
1344         return true;
1345     }
1346 
1347     // Kills the contract and sends funds to owner
1348     // However, only if validityDate has been surpassed (should be chosen far, far in the future)
1349     function releaseContract() public {
1350         require(now > validityDate);
1351         require(msg.sender == sister);
1352         selfdestruct(owner);
1353     }
1354 
1355     // What is the value of this token in case this token wins?
1356     // Value is balance of this plus balance of sister account per token
1357     function winningValue() public constant returns (uint256 value){
1358         LittleSisterToken sisterContract = LittleSisterToken(sister);
1359 
1360         if (totalSupply_ > 0){
1361             value = (this.balance + sisterContract.balance) / totalSupply_;
1362         }
1363 
1364         return value;
1365     }
1366 
1367     // Supply that still can be bought
1368     function availableSupply() public constant returns (uint256 supply){
1369         LittleSisterToken sisterContract;
1370         uint256 sisterSupply;
1371 
1372         if ((buyPrice()) == 0 || (now > maxBuyingDate)){
1373             // there can only be supply in case buying is allowed
1374             return 0;
1375         } else {
1376 
1377             sisterContract = LittleSisterToken(sister);
1378             sisterSupply = sisterContract.totalSupply();
1379             // This is the most important assertion ever ;-)
1380             assert(maxSupply >= totalSupply_ + sisterSupply);
1381             supply = maxSupply - totalSupply_ - sisterSupply;
1382             return supply;
1383         }
1384     }
1385 
1386     // Buy tokens from the contract depending on how much money has been sent
1387     function buy() public payable returns (uint amount){
1388         uint256 house;
1389         uint256 supply;
1390         uint256 price;
1391 
1392         // check that buying is still allowed
1393         require(now <= maxBuyingDate);
1394         // get the price
1395         price = buyPrice();
1396         // Stuff can only be sold if the price is nonzero
1397         // i.e. setting the price to 0 can suspend the Token sale
1398         require(price > 0);
1399         house = msg.value / vig;
1400         // C'mon you gotta pay the house!
1401         require(house > 0);
1402         amount = msg.value / price;
1403         supply = availableSupply();
1404         require(amount <= supply);
1405         // Send the commission to the vigAddress of this contract
1406         vigAddress.transfer(house);
1407         totalSupply_ += amount;
1408         // Increase the sender's balance by the appropriate amount
1409         balances[msg.sender] += amount;
1410         Transfer(this, msg.sender, amount);
1411         return amount;
1412     }
1413 
1414     // Users can redeem their cash and sell their tokens back to the contract
1415     // Note that this usually requires that either the little or the big sister
1416     // has transferred all their funds to the other contract and set sell price nonzero
1417     function sell(uint _amount) public returns (uint256 revenue){
1418         // Tokens can only be sold back to the contract if the price is nonzero
1419         // i.e. the sellPrice can also act as a switch, usually it is off by default
1420         // and only turned on by some event (i.e. one of the two tokens winning)
1421         require(sellPrice() > 0);
1422         require(!lost);
1423         // check if the user has sufficient amount of tokens
1424         require(balances[msg.sender] >= _amount);
1425         revenue = _amount * sellPrice();
1426         require(this.balance >= revenue);
1427         // first deduct tokens from user
1428         balances[msg.sender] -= _amount;
1429         totalSupply_ -= _amount;
1430         // finally transfer the ether, this withdrawal pattern prevents re-entry attacks
1431         msg.sender.transfer(revenue);
1432         Transfer(msg.sender, this, _amount);
1433         return revenue;
1434     }
1435 
1436     // Sells all tokens of a user
1437     function sellAll() public returns (uint256){
1438         uint256 amount = balances[msg.sender];
1439         return sell(amount);
1440     }
1441 
1442 }
1443 
1444 
1445 /*
1446 
1447 This is the big sister of the LittleSisterToken, it governs the little sister.
1448 It knows about the sell and buying prices.
1449 
1450 */
1451 contract BigSisterToken is LittleSisterToken {
1452 
1453     // The buying price, 0 means buying is suspended
1454     uint256 buyPrice_;
1455 
1456     // The sell price, 0 suspends selling
1457     uint256 sellPrice_;
1458 
1459     // Constructor
1460     function BigSisterToken(uint256 _maxSupply, uint256 _buyPrice, uint256 _sellPrice, uint8 _vig,
1461             uint _buyingHorizon, uint _maximumLifetime) {
1462         maxSupply = _maxSupply;
1463         vig = _vig;
1464         buyPrice_ = _buyPrice;
1465         sellPrice_ = _sellPrice;
1466         // Maximum lifetime is not a date, but a time interval
1467         validityDate = now + _maximumLifetime;
1468         // Horizon after which buying is definitely suspended
1469         maxBuyingDate = now + _buyingHorizon;
1470     }
1471 
1472     function buyPrice() public constant returns (uint256){
1473         return buyPrice_;
1474     }
1475 
1476     function sellPrice() public constant returns (uint256){
1477         return sellPrice_;
1478     }
1479 
1480     // Destroys the contract as well as the little sister.
1481     // Important _maximumLifetime should be set generously to give token holders
1482     // plenty fo time to withdraw their money in case they win
1483     // only the owner can invoke this command
1484     function releaseContract() public {
1485         LittleSisterToken sisterContract = LittleSisterToken(sister);
1486 
1487         require(now > validityDate);
1488         require(msg.sender == owner);
1489         // also destroy the little sister
1490         sisterContract.releaseContract();
1491         selfdestruct(owner);
1492     }
1493 
1494     // Links a little and a big sister together, can only be invoked by owner.
1495     // IMPORTANT contracts can only be registered once, linking CANNOT be changed or modified.
1496     function registerSister(address _sister) public returns (bool) {
1497         LittleSisterToken sisterContract;
1498 
1499         // make sure that contract registration works only once
1500         require(sister == address(0));
1501         // can onyl be called by owner
1502         require(msg.sender == owner);
1503         require(_sister != address(this));
1504         sisterContract = LittleSisterToken(_sister);
1505         require(sisterContract.sister() == address(0));
1506         sister = _sister;
1507         // finally also register this big sister with its new little sister
1508         require(sisterContract.registerSister(address(this)));
1509         return true;
1510     }
1511 
1512 }
1513 
1514 
1515 /*
1516 
1517 This token allows for price increases after a certain amount of purchases.
1518 Note that this functionality is actually provided by its big sister called
1519 PriceIncreasingToken.
1520 
1521 */
1522 contract PriceIncreasingLittleSisterToken is LittleSisterToken{
1523 
1524     // fallback function, note only the big sister can send funds to this contract
1525     // without buying, other people just buy the tokens
1526     function () payable {
1527         if (msg.sender != sister){
1528             buy();
1529         }
1530     }
1531 
1532     // Buy tokens from the contract, as in parent class, but
1533     // ask the sister if price needs to be increased for future purchases
1534     function buy() public payable returns (uint amount){
1535         PriceIncreasingToken sisterContract = PriceIncreasingToken(sister);
1536 
1537         // buy tokens
1538         amount = super.buy();
1539         // notify the sister about the sold amount and maybe update prices
1540         sisterContract.sisterCheckPrice(amount);
1541         return amount;
1542     }
1543 
1544 }
1545 
1546 
1547 /*
1548 
1549 This is the big sister for price increases.
1550 Needs to be linked to a PriceIncreasingLittleSisterToken.
1551 Note that price increase always happens after someone bought tokens, never before.
1552 
1553 */
1554 contract PriceIncreasingToken is BigSisterToken{
1555 
1556     // Helper variable to store number of tokens purchases since last price increase
1557     uint256 public currentBatch;
1558 
1559     // Number of tokens that need to be bought to trigger a price increase
1560     uint256 public thresholdAmount;
1561 
1562     // Increase of price if thresholdAmount is met
1563     uint256 public priceIncrease;
1564 
1565     function PriceIncreasingToken(uint256 _maxSupply, uint256 _buyPrice, uint256 sellPrice_, uint8 _vig,
1566         uint256 _thresholdAmount, uint256 _priceIncrease, uint _buyingHorizon, uint _maximumLifetime)
1567             BigSisterToken( _maxSupply, _buyPrice, sellPrice_, _vig, _buyingHorizon, _maximumLifetime){
1568         currentBatch = 0;
1569         thresholdAmount = _thresholdAmount;
1570         priceIncrease = _priceIncrease;
1571     }
1572 
1573     // fallback function, note only the big sister can send funds to this contract
1574     // without buying, other people just buy the tokens
1575     function () payable {
1576         if (msg.sender != sister){
1577             buy();
1578         }
1579     }
1580 
1581     // Buy tokens from the contract and checks price and potentially increases
1582     // the price afterwards
1583     function buy() public payable returns (uint amount){
1584         amount = super.buy();
1585         // check for price increase
1586         _checkPrice(amount);
1587         return amount;
1588     }
1589 
1590     // Function that can only be called by the sister to check and increase prices
1591     // This is needed because the _checkPrice function is internal and cannot
1592     // be called by the sister directly
1593     function sisterCheckPrice(uint256 amount) public{
1594         require(msg.sender == sister);
1595         _checkPrice(amount);
1596     }
1597 
1598     // internal function to check and maybe increase the buying price
1599     // every time the thresholdAmount is met, the price is increased
1600     function _checkPrice(uint256 amount) internal{
1601         currentBatch += amount;
1602         if (currentBatch >= thresholdAmount){
1603             buyPrice_ += priceIncrease;
1604             // it is important to subtract the thresholdAmount
1605             // and not set currentBatch = 0 instead. This ensures that
1606             // a huge order crossing multiple thresholds will trigger price
1607             // increases in quick successions
1608             currentBatch -= thresholdAmount;
1609         }
1610     }
1611 
1612 }
1613 
1614 
1615 /*
1616 
1617 This contract adds the ability to check for evidence to enable the contract's winning.
1618 There are two conditions, either a certain fixed date has passed (dateSisterWins) and,
1619 in this case, the litte sister wins, or some evidence is gathered proving the opposite.
1620 
1621 How this evidence is gathered needs to be implemented in the subclass. Note that
1622 this evidence needs to be acquired a couple of times to be certain. Moreover, in between
1623 different findings of repeating evidence there needs to pass a certain evidenceInterval.
1624 
1625 */
1626 
1627 contract TimedEvidenceToken is PriceIncreasingToken{
1628 
1629     // fixed date that specifies when the little sister will win (unix timestamp)
1630     uint public dateSisterWins;
1631 
1632     // amount of evidence found
1633     uint8 public foundEvidence;
1634 
1635     // amount of evidence required for victory,
1636     // the big sister wins if foundEvidence >= requiredEvidence
1637     uint8 public requiredEvidence;
1638 
1639     // Time interval between two consecutive evidence checks
1640     uint public evidenceInterval;
1641 
1642     // Last time evidence was checked
1643     uint public lastEvidenceCheck;
1644 
1645     // Helper variable to store the last price.
1646     // If the contract needs to suspend buying immediately in case
1647     // of evidence, this can restore buying if evidence cannot be found subsequently
1648     uint256 lastBuyPrice;
1649 
1650     function TimedEvidenceToken(uint256 _maxSupply, uint256 _buyPrice, uint8 _vig,
1651         uint256 _thresholdAmount, uint256 _priceIncrease, uint _evidenceInterval,
1652         uint8 _requiredEvidence, uint _dateSisterWins,
1653         uint _buyingHorizon, uint _maximumLifetime)
1654         PriceIncreasingToken(_maxSupply, _buyPrice, 0,_vig,
1655         _thresholdAmount, _priceIncrease, _buyingHorizon, _maximumLifetime){
1656     evidenceInterval = _evidenceInterval;
1657     lastEvidenceCheck = 0;
1658     foundEvidence = 0;
1659     lastBuyPrice = 0;
1660     dateSisterWins = _dateSisterWins;
1661     requiredEvidence = _requiredEvidence;
1662     }
1663 
1664     // Checks and initiates payout, i.e. users can sell their tokens back to the contract
1665     function checkForPayout() public returns(bool){
1666         LittleSisterToken sisterContract = LittleSisterToken(sister);
1667 
1668         // if we already sell, payout is definitely true
1669         if (sellPrice_ > 0) return true;
1670 
1671         // Check if the fixed date has passed:
1672         if (now > dateSisterWins){
1673             // Sister wins and this token becomes worthless
1674             require(sisterContract.send(this.balance));
1675             // this contract lost
1676             lost = true;
1677             // buying is no more possible
1678             buyPrice_ = 0;
1679             // now set the sell price
1680             sellPrice_ = sisterContract.balance / sisterContract.totalSupply();
1681             return true;
1682         }
1683 
1684         // Check if enough evidence was found
1685         if (foundEvidence >= requiredEvidence){
1686             // Trump is impeached this token is gaining in value!
1687             // Sister lost and needs to send her funds
1688             require(sisterContract.sendFunds());
1689             // buying is no more possible
1690             buyPrice_ = 0;
1691             // now set the sell price
1692             sellPrice_ = this.balance / totalSupply();
1693             return true;
1694 
1695         }
1696 
1697         // If both cases are not true, then unfortunately, we cannot pay you (yet)
1698         return false;
1699     }
1700 
1701     // internal function needs to be called by the evidence gathering implementation
1702     // in subclass
1703     function _accumulateEvidence(bool evidence) internal{
1704         // make sure that enough time has passed since the last evidence check
1705         require(now > lastEvidenceCheck + evidenceInterval);
1706         lastEvidenceCheck = now;
1707 
1708         if (evidence){
1709             if (buyPrice_ > 0){
1710                 // suspend buying as soon as there is evidence
1711                 lastBuyPrice = buyPrice_;
1712                 buyPrice_ = 0;
1713             }
1714             // increase evidence
1715             foundEvidence += 1;
1716         } else {
1717             // resume buying in case foundEvidence is reduced.
1718             // Note that resuming buying needs to find one more evidence against than pro.
1719             // This should stop an attacker to reduce evidence to 0 and subsequently buy
1720             // tokens quickly
1721             if ((lastBuyPrice > 0) && (foundEvidence == 0)){
1722                 buyPrice_ = lastBuyPrice;
1723                 lastBuyPrice = 0;
1724             }
1725 
1726             // if evidence is not found consecutively it is decreased
1727             // buying can only be enabled again if found evidence is 0 for a consecutive interval
1728             if (foundEvidence > 0) foundEvidence -= 1;
1729         }
1730     }
1731 
1732 }
1733 
1734 
1735 // Dummy LittleSisterContract that just specifies the names
1736 // Has a TrumpImpeachmentToken big sister
1737 contract TrumpFullTermToken is PriceIncreasingLittleSisterToken{
1738 
1739     string public constant symbol = "TFT";
1740 
1741     string public constant name = "Trump Full Term Token";
1742 
1743 }
1744 
1745 
1746 //Implements the Oraclize Usage to query for the President of the United States
1747 contract TrumpOracle is usingOraclize{
1748 
1749     // Keeps query ids to make sure the callback is valid
1750     mapping(bytes32=>bool) validIds;
1751 
1752     // logs an oraclize query
1753     event newOraclizeQuery(string description);
1754 
1755     // logs the query result
1756     event newOraclizeResult(bytes32 id, string result);
1757 
1758     // question asked to oracle
1759     string public constant question = "President of the United States";
1760 
1761     // price of (last) Oraclize query
1762     uint public oraclizePrice;
1763 
1764     // callback function used by oraclize to provide the result
1765     function __callback(bytes32 _queryId, string result) public {
1766         // make sure the request comes from oraclize
1767         require(msg.sender == oraclize_cbAddress());
1768         // and matches a previous query
1769         require(validIds[_queryId]);
1770         delete validIds[_queryId];
1771         newOraclizeResult(_queryId, result);
1772     }
1773 
1774     // Can be called by users and token holders to check if Trump is still president
1775     function requestEvidence() public payable {
1776         if (getOraclizePrice() > msg.value) {
1777             // note that oraclize deducts the query costs from the contract, so the
1778             // users should compensate for that!
1779             newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1780             // send money back to user and revert transaction
1781             revert();
1782         } else {
1783             newOraclizeQuery("Oraclize query was sent, standing by for the answer...");
1784             // THE MOST IMPORTANT QUERY!
1785             bytes32 queryId = oraclize_query("WolframAlpha", question);
1786             // Keep track of id for callback check
1787             validIds[queryId] = true;
1788         }
1789     }
1790 
1791     // returns the price of oracle call in wei
1792     function getOraclizePrice() public returns (uint) {
1793         oraclizePrice = oraclize_getPrice("WolframAlpha");
1794         return oraclizePrice;
1795     }
1796 
1797 }
1798 
1799 
1800 // The big sister contract of TrumpFullTermToken
1801 contract TrumpImpeachmentToken is TrumpOracle, TimedEvidenceToken, StringOps{
1802 
1803     // 3 letter symbol
1804     string public constant symbol = "TIT";
1805 
1806     // Name of token
1807     string public constant name = "Trump Impeachment Token";
1808 
1809     // Last String returned by oracle query
1810     string public lastEvidence;
1811 
1812     // expected answer
1813     string public constant answer = "Trump";
1814 
1815     function TrumpImpeachmentToken()
1816              TimedEvidenceToken(2000000 * unit, // amount
1817                                 69 finney / unit, // buy price 0.069 Ether
1818                                 40, // vig => 2.5%
1819                                 6600 * unit, //threshold amount
1820                                 100 szabo / unit, // price increase
1821                                 2 days, //evidence interval
1822                                 3, // required evidence
1823                                 1611014400, // date sister wins,
1824                                             //one day before Trump`s term ends
1825                                 222 days, // buying horizon where buying tokens is allowed
1826                                 7 years //maximum Lifetime from deployment on
1827                                         // after which contract can be destroyed
1828              ){
1829             lastEvidence = "N/A";
1830             // for very fast confirmations set the gas Price to 30GWei
1831             oraclize_setCustomGasPrice(30000000000);
1832         }
1833 
1834     // callback used by oraclize
1835     function __callback(bytes32 _queryId, string result) public{
1836         bool evidence;
1837 
1838         super.__callback(_queryId, result);
1839         require(bytes(result).length > 0);
1840         lastEvidence = result;
1841         evidence = !stringEndsWith(result, answer);
1842         // accumulates evidence over time, also checks for sufficient interval between
1843         // evidence gatherings
1844         _accumulateEvidence(evidence);
1845     }
1846 
1847     // can be called by user to request evidence from oraclize
1848     function requestEvidence() payable{
1849         // check if enough time has past before querying oraclize
1850         require(now > lastEvidenceCheck + evidenceInterval);
1851         super.requestEvidence();
1852     }
1853 
1854     // We as owners can (only) increase or keep the price in case there is a gas price surge
1855     // within the range of 30 to 300 GWei.
1856     // This cannot do any harm (well except making the confirmations a bit expensive)
1857     // but it can be helpful in case of surging prices
1858     function setOraclizeGasPrice(uint gasPrice){
1859         require(msg.sender == owner);
1860         // must be greater or equal to the original gasPrice 30 GWei
1861         require(gasPrice >= 30000000000);
1862         // and lets keep it within reasonable bounds maximum is 300 GWei, i.e. 10 fold
1863         // this should be a reasonable range, for reacting to price surges and
1864         // impeachment token holders not fearing to pay a too high price for confirmations
1865         require(gasPrice <= 300000000000);
1866         oraclize_setCustomGasPrice(gasPrice);
1867     }
1868 
1869 }