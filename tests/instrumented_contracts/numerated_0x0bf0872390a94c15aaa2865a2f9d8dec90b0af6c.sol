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
33 contract OraclizeI {
34     address public cbAddress;
35     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
36     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
37     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
38     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
39     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
40     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
41     function getPrice(string _datasource) returns (uint _dsprice);
42     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
43     function useCoupon(string _coupon);
44     function setProofType(byte _proofType);
45     function setConfig(bytes32 _config);
46     function setCustomGasPrice(uint _gasPrice);
47     function randomDS_getSessionPubKeyHash() returns(bytes32);
48 }
49 contract OraclizeAddrResolverI {
50     function getAddress() returns (address _addr);
51 }
52 contract usingOraclize {
53     uint constant day = 60*60*24;
54     uint constant week = 60*60*24*7;
55     uint constant month = 60*60*24*30;
56     byte constant proofType_NONE = 0x00;
57     byte constant proofType_TLSNotary = 0x10;
58     byte constant proofType_Android = 0x20;
59     byte constant proofType_Ledger = 0x30;
60     byte constant proofType_Native = 0xF0;
61     byte constant proofStorage_IPFS = 0x01;
62     uint8 constant networkID_auto = 0;
63     uint8 constant networkID_mainnet = 1;
64     uint8 constant networkID_testnet = 2;
65     uint8 constant networkID_morden = 2;
66     uint8 constant networkID_consensys = 161;
67 
68     OraclizeAddrResolverI OAR;
69 
70     OraclizeI oraclize;
71     modifier oraclizeAPI {
72         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
73             oraclize_setNetwork(networkID_auto);
74 
75         if(address(oraclize) != OAR.getAddress())
76             oraclize = OraclizeI(OAR.getAddress());
77 
78         _;
79     }
80     modifier coupon(string code){
81         oraclize = OraclizeI(OAR.getAddress());
82         oraclize.useCoupon(code);
83         _;
84     }
85 
86     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
87         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
88             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
89             oraclize_setNetworkName("eth_mainnet");
90             return true;
91         }
92         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
93             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
94             oraclize_setNetworkName("eth_ropsten3");
95             return true;
96         }
97         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
98             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
99             oraclize_setNetworkName("eth_kovan");
100             return true;
101         }
102         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
103             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
104             oraclize_setNetworkName("eth_rinkeby");
105             return true;
106         }
107         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
108             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
109             return true;
110         }
111         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
112             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
113             return true;
114         }
115         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
116             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
117             return true;
118         }
119         return false;
120     }
121 
122     function __callback(bytes32 myid, string result) {
123         __callback(myid, result, new bytes(0));
124     }
125     function __callback(bytes32 myid, string result, bytes proof) {
126     }
127 
128     function oraclize_useCoupon(string code) oraclizeAPI internal {
129         oraclize.useCoupon(code);
130     }
131 
132     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
133         return oraclize.getPrice(datasource);
134     }
135 
136     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
137         return oraclize.getPrice(datasource, gaslimit);
138     }
139 
140     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
141         uint price = oraclize.getPrice(datasource);
142         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
143         return oraclize.query.value(price)(0, datasource, arg);
144     }
145     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
146         uint price = oraclize.getPrice(datasource);
147         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
148         return oraclize.query.value(price)(timestamp, datasource, arg);
149     }
150     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
151         uint price = oraclize.getPrice(datasource, gaslimit);
152         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
153         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
154     }
155     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
156         uint price = oraclize.getPrice(datasource, gaslimit);
157         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
158         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
159     }
160     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
161         uint price = oraclize.getPrice(datasource);
162         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
163         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
164     }
165     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
166         uint price = oraclize.getPrice(datasource);
167         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
168         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
169     }
170     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
171         uint price = oraclize.getPrice(datasource, gaslimit);
172         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
173         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
174     }
175     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
176         uint price = oraclize.getPrice(datasource, gaslimit);
177         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
178         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
179     }
180     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
181         uint price = oraclize.getPrice(datasource);
182         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
183         bytes memory args = stra2cbor(argN);
184         return oraclize.queryN.value(price)(0, datasource, args);
185     }
186     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
187         uint price = oraclize.getPrice(datasource);
188         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
189         bytes memory args = stra2cbor(argN);
190         return oraclize.queryN.value(price)(timestamp, datasource, args);
191     }
192     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
193         uint price = oraclize.getPrice(datasource, gaslimit);
194         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
195         bytes memory args = stra2cbor(argN);
196         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
197     }
198     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
199         uint price = oraclize.getPrice(datasource, gaslimit);
200         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
201         bytes memory args = stra2cbor(argN);
202         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
203     }
204     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
205         string[] memory dynargs = new string[](1);
206         dynargs[0] = args[0];
207         return oraclize_query(datasource, dynargs);
208     }
209     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
210         string[] memory dynargs = new string[](1);
211         dynargs[0] = args[0];
212         return oraclize_query(timestamp, datasource, dynargs);
213     }
214     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
215         string[] memory dynargs = new string[](1);
216         dynargs[0] = args[0];
217         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
218     }
219     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
220         string[] memory dynargs = new string[](1);
221         dynargs[0] = args[0];
222         return oraclize_query(datasource, dynargs, gaslimit);
223     }
224 
225     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
226         string[] memory dynargs = new string[](2);
227         dynargs[0] = args[0];
228         dynargs[1] = args[1];
229         return oraclize_query(datasource, dynargs);
230     }
231     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
232         string[] memory dynargs = new string[](2);
233         dynargs[0] = args[0];
234         dynargs[1] = args[1];
235         return oraclize_query(timestamp, datasource, dynargs);
236     }
237     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
238         string[] memory dynargs = new string[](2);
239         dynargs[0] = args[0];
240         dynargs[1] = args[1];
241         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
242     }
243     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
244         string[] memory dynargs = new string[](2);
245         dynargs[0] = args[0];
246         dynargs[1] = args[1];
247         return oraclize_query(datasource, dynargs, gaslimit);
248     }
249     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
250         string[] memory dynargs = new string[](3);
251         dynargs[0] = args[0];
252         dynargs[1] = args[1];
253         dynargs[2] = args[2];
254         return oraclize_query(datasource, dynargs);
255     }
256     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
257         string[] memory dynargs = new string[](3);
258         dynargs[0] = args[0];
259         dynargs[1] = args[1];
260         dynargs[2] = args[2];
261         return oraclize_query(timestamp, datasource, dynargs);
262     }
263     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
264         string[] memory dynargs = new string[](3);
265         dynargs[0] = args[0];
266         dynargs[1] = args[1];
267         dynargs[2] = args[2];
268         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
269     }
270     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
271         string[] memory dynargs = new string[](3);
272         dynargs[0] = args[0];
273         dynargs[1] = args[1];
274         dynargs[2] = args[2];
275         return oraclize_query(datasource, dynargs, gaslimit);
276     }
277 
278     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
279         string[] memory dynargs = new string[](4);
280         dynargs[0] = args[0];
281         dynargs[1] = args[1];
282         dynargs[2] = args[2];
283         dynargs[3] = args[3];
284         return oraclize_query(datasource, dynargs);
285     }
286     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
287         string[] memory dynargs = new string[](4);
288         dynargs[0] = args[0];
289         dynargs[1] = args[1];
290         dynargs[2] = args[2];
291         dynargs[3] = args[3];
292         return oraclize_query(timestamp, datasource, dynargs);
293     }
294     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
295         string[] memory dynargs = new string[](4);
296         dynargs[0] = args[0];
297         dynargs[1] = args[1];
298         dynargs[2] = args[2];
299         dynargs[3] = args[3];
300         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
301     }
302     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
303         string[] memory dynargs = new string[](4);
304         dynargs[0] = args[0];
305         dynargs[1] = args[1];
306         dynargs[2] = args[2];
307         dynargs[3] = args[3];
308         return oraclize_query(datasource, dynargs, gaslimit);
309     }
310     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
311         string[] memory dynargs = new string[](5);
312         dynargs[0] = args[0];
313         dynargs[1] = args[1];
314         dynargs[2] = args[2];
315         dynargs[3] = args[3];
316         dynargs[4] = args[4];
317         return oraclize_query(datasource, dynargs);
318     }
319     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
320         string[] memory dynargs = new string[](5);
321         dynargs[0] = args[0];
322         dynargs[1] = args[1];
323         dynargs[2] = args[2];
324         dynargs[3] = args[3];
325         dynargs[4] = args[4];
326         return oraclize_query(timestamp, datasource, dynargs);
327     }
328     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
329         string[] memory dynargs = new string[](5);
330         dynargs[0] = args[0];
331         dynargs[1] = args[1];
332         dynargs[2] = args[2];
333         dynargs[3] = args[3];
334         dynargs[4] = args[4];
335         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
336     }
337     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
338         string[] memory dynargs = new string[](5);
339         dynargs[0] = args[0];
340         dynargs[1] = args[1];
341         dynargs[2] = args[2];
342         dynargs[3] = args[3];
343         dynargs[4] = args[4];
344         return oraclize_query(datasource, dynargs, gaslimit);
345     }
346     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
347         uint price = oraclize.getPrice(datasource);
348         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
349         bytes memory args = ba2cbor(argN);
350         return oraclize.queryN.value(price)(0, datasource, args);
351     }
352     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
353         uint price = oraclize.getPrice(datasource);
354         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
355         bytes memory args = ba2cbor(argN);
356         return oraclize.queryN.value(price)(timestamp, datasource, args);
357     }
358     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
359         uint price = oraclize.getPrice(datasource, gaslimit);
360         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
361         bytes memory args = ba2cbor(argN);
362         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
363     }
364     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
365         uint price = oraclize.getPrice(datasource, gaslimit);
366         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
367         bytes memory args = ba2cbor(argN);
368         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
369     }
370     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
371         bytes[] memory dynargs = new bytes[](1);
372         dynargs[0] = args[0];
373         return oraclize_query(datasource, dynargs);
374     }
375     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
376         bytes[] memory dynargs = new bytes[](1);
377         dynargs[0] = args[0];
378         return oraclize_query(timestamp, datasource, dynargs);
379     }
380     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
381         bytes[] memory dynargs = new bytes[](1);
382         dynargs[0] = args[0];
383         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
384     }
385     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
386         bytes[] memory dynargs = new bytes[](1);
387         dynargs[0] = args[0];
388         return oraclize_query(datasource, dynargs, gaslimit);
389     }
390 
391     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
392         bytes[] memory dynargs = new bytes[](2);
393         dynargs[0] = args[0];
394         dynargs[1] = args[1];
395         return oraclize_query(datasource, dynargs);
396     }
397     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
398         bytes[] memory dynargs = new bytes[](2);
399         dynargs[0] = args[0];
400         dynargs[1] = args[1];
401         return oraclize_query(timestamp, datasource, dynargs);
402     }
403     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
404         bytes[] memory dynargs = new bytes[](2);
405         dynargs[0] = args[0];
406         dynargs[1] = args[1];
407         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
408     }
409     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
410         bytes[] memory dynargs = new bytes[](2);
411         dynargs[0] = args[0];
412         dynargs[1] = args[1];
413         return oraclize_query(datasource, dynargs, gaslimit);
414     }
415     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
416         bytes[] memory dynargs = new bytes[](3);
417         dynargs[0] = args[0];
418         dynargs[1] = args[1];
419         dynargs[2] = args[2];
420         return oraclize_query(datasource, dynargs);
421     }
422     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
423         bytes[] memory dynargs = new bytes[](3);
424         dynargs[0] = args[0];
425         dynargs[1] = args[1];
426         dynargs[2] = args[2];
427         return oraclize_query(timestamp, datasource, dynargs);
428     }
429     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
430         bytes[] memory dynargs = new bytes[](3);
431         dynargs[0] = args[0];
432         dynargs[1] = args[1];
433         dynargs[2] = args[2];
434         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
435     }
436     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
437         bytes[] memory dynargs = new bytes[](3);
438         dynargs[0] = args[0];
439         dynargs[1] = args[1];
440         dynargs[2] = args[2];
441         return oraclize_query(datasource, dynargs, gaslimit);
442     }
443 
444     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
445         bytes[] memory dynargs = new bytes[](4);
446         dynargs[0] = args[0];
447         dynargs[1] = args[1];
448         dynargs[2] = args[2];
449         dynargs[3] = args[3];
450         return oraclize_query(datasource, dynargs);
451     }
452     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
453         bytes[] memory dynargs = new bytes[](4);
454         dynargs[0] = args[0];
455         dynargs[1] = args[1];
456         dynargs[2] = args[2];
457         dynargs[3] = args[3];
458         return oraclize_query(timestamp, datasource, dynargs);
459     }
460     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
461         bytes[] memory dynargs = new bytes[](4);
462         dynargs[0] = args[0];
463         dynargs[1] = args[1];
464         dynargs[2] = args[2];
465         dynargs[3] = args[3];
466         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
467     }
468     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
469         bytes[] memory dynargs = new bytes[](4);
470         dynargs[0] = args[0];
471         dynargs[1] = args[1];
472         dynargs[2] = args[2];
473         dynargs[3] = args[3];
474         return oraclize_query(datasource, dynargs, gaslimit);
475     }
476     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
477         bytes[] memory dynargs = new bytes[](5);
478         dynargs[0] = args[0];
479         dynargs[1] = args[1];
480         dynargs[2] = args[2];
481         dynargs[3] = args[3];
482         dynargs[4] = args[4];
483         return oraclize_query(datasource, dynargs);
484     }
485     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
486         bytes[] memory dynargs = new bytes[](5);
487         dynargs[0] = args[0];
488         dynargs[1] = args[1];
489         dynargs[2] = args[2];
490         dynargs[3] = args[3];
491         dynargs[4] = args[4];
492         return oraclize_query(timestamp, datasource, dynargs);
493     }
494     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
495         bytes[] memory dynargs = new bytes[](5);
496         dynargs[0] = args[0];
497         dynargs[1] = args[1];
498         dynargs[2] = args[2];
499         dynargs[3] = args[3];
500         dynargs[4] = args[4];
501         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
502     }
503     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
504         bytes[] memory dynargs = new bytes[](5);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         dynargs[3] = args[3];
509         dynargs[4] = args[4];
510         return oraclize_query(datasource, dynargs, gaslimit);
511     }
512 
513     function oraclize_cbAddress() oraclizeAPI internal returns (address){
514         return oraclize.cbAddress();
515     }
516     function oraclize_setProof(byte proofP) oraclizeAPI internal {
517         return oraclize.setProofType(proofP);
518     }
519     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
520         return oraclize.setCustomGasPrice(gasPrice);
521     }
522     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
523         return oraclize.setConfig(config);
524     }
525 
526     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
527         return oraclize.randomDS_getSessionPubKeyHash();
528     }
529 
530     function getCodeSize(address _addr) constant internal returns(uint _size) {
531         assembly {
532             _size := extcodesize(_addr)
533         }
534     }
535 
536     function parseAddr(string _a) internal returns (address){
537         bytes memory tmp = bytes(_a);
538         uint160 iaddr = 0;
539         uint160 b1;
540         uint160 b2;
541         for (uint i=2; i<2+2*20; i+=2){
542             iaddr *= 256;
543             b1 = uint160(tmp[i]);
544             b2 = uint160(tmp[i+1]);
545             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
546             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
547             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
548             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
549             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
550             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
551             iaddr += (b1*16+b2);
552         }
553         return address(iaddr);
554     }
555 
556     function strCompare(string _a, string _b) internal returns (int) {
557         bytes memory a = bytes(_a);
558         bytes memory b = bytes(_b);
559         uint minLength = a.length;
560         if (b.length < minLength) minLength = b.length;
561         for (uint i = 0; i < minLength; i ++)
562             if (a[i] < b[i])
563                 return -1;
564             else if (a[i] > b[i])
565                 return 1;
566         if (a.length < b.length)
567             return -1;
568         else if (a.length > b.length)
569             return 1;
570         else
571             return 0;
572     }
573 
574     function indexOf(string _haystack, string _needle) internal returns (int) {
575         bytes memory h = bytes(_haystack);
576         bytes memory n = bytes(_needle);
577         if(h.length < 1 || n.length < 1 || (n.length > h.length))
578             return -1;
579         else if(h.length > (2**128 -1))
580             return -1;
581         else
582         {
583             uint subindex = 0;
584             for (uint i = 0; i < h.length; i ++)
585             {
586                 if (h[i] == n[0])
587                 {
588                     subindex = 1;
589                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
590                     {
591                         subindex++;
592                     }
593                     if(subindex == n.length)
594                         return int(i);
595                 }
596             }
597             return -1;
598         }
599     }
600 
601     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
602         bytes memory _ba = bytes(_a);
603         bytes memory _bb = bytes(_b);
604         bytes memory _bc = bytes(_c);
605         bytes memory _bd = bytes(_d);
606         bytes memory _be = bytes(_e);
607         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
608         bytes memory babcde = bytes(abcde);
609         uint k = 0;
610         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
611         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
612         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
613         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
614         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
615         return string(babcde);
616     }
617 
618     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
619         return strConcat(_a, _b, _c, _d, "");
620     }
621 
622     function strConcat(string _a, string _b, string _c) internal returns (string) {
623         return strConcat(_a, _b, _c, "", "");
624     }
625 
626     function strConcat(string _a, string _b) internal returns (string) {
627         return strConcat(_a, _b, "", "", "");
628     }
629 
630     // parseInt
631     function parseInt(string _a) internal returns (uint) {
632         return parseInt(_a, 0);
633     }
634 
635     // parseInt(parseFloat*10^_b)
636     function parseInt(string _a, uint _b) internal returns (uint) {
637         bytes memory bresult = bytes(_a);
638         uint mint = 0;
639         bool decimals = false;
640         for (uint i=0; i<bresult.length; i++){
641             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
642                 if (decimals){
643                    if (_b == 0) break;
644                     else _b--;
645                 }
646                 mint *= 10;
647                 mint += uint(bresult[i]) - 48;
648             } else if (bresult[i] == 46) decimals = true;
649         }
650         if (_b > 0) mint *= 10**_b;
651         return mint;
652     }
653 
654     function uint2str(uint i) internal returns (string){
655         if (i == 0) return "0";
656         uint j = i;
657         uint len;
658         while (j != 0){
659             len++;
660             j /= 10;
661         }
662         bytes memory bstr = new bytes(len);
663         uint k = len - 1;
664         while (i != 0){
665             bstr[k--] = byte(48 + i % 10);
666             i /= 10;
667         }
668         return string(bstr);
669     }
670 
671     function stra2cbor(string[] arr) internal returns (bytes) {
672             uint arrlen = arr.length;
673 
674             // get correct cbor output length
675             uint outputlen = 0;
676             bytes[] memory elemArray = new bytes[](arrlen);
677             for (uint i = 0; i < arrlen; i++) {
678                 elemArray[i] = (bytes(arr[i]));
679                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
680             }
681             uint ctr = 0;
682             uint cborlen = arrlen + 0x80;
683             outputlen += byte(cborlen).length;
684             bytes memory res = new bytes(outputlen);
685 
686             while (byte(cborlen).length > ctr) {
687                 res[ctr] = byte(cborlen)[ctr];
688                 ctr++;
689             }
690             for (i = 0; i < arrlen; i++) {
691                 res[ctr] = 0x5F;
692                 ctr++;
693                 for (uint x = 0; x < elemArray[i].length; x++) {
694                     // if there's a bug with larger strings, this may be the culprit
695                     if (x % 23 == 0) {
696                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
697                         elemcborlen += 0x40;
698                         uint lctr = ctr;
699                         while (byte(elemcborlen).length > ctr - lctr) {
700                             res[ctr] = byte(elemcborlen)[ctr - lctr];
701                             ctr++;
702                         }
703                     }
704                     res[ctr] = elemArray[i][x];
705                     ctr++;
706                 }
707                 res[ctr] = 0xFF;
708                 ctr++;
709             }
710             return res;
711         }
712 
713     function ba2cbor(bytes[] arr) internal returns (bytes) {
714             uint arrlen = arr.length;
715 
716             // get correct cbor output length
717             uint outputlen = 0;
718             bytes[] memory elemArray = new bytes[](arrlen);
719             for (uint i = 0; i < arrlen; i++) {
720                 elemArray[i] = (bytes(arr[i]));
721                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
722             }
723             uint ctr = 0;
724             uint cborlen = arrlen + 0x80;
725             outputlen += byte(cborlen).length;
726             bytes memory res = new bytes(outputlen);
727 
728             while (byte(cborlen).length > ctr) {
729                 res[ctr] = byte(cborlen)[ctr];
730                 ctr++;
731             }
732             for (i = 0; i < arrlen; i++) {
733                 res[ctr] = 0x5F;
734                 ctr++;
735                 for (uint x = 0; x < elemArray[i].length; x++) {
736                     // if there's a bug with larger strings, this may be the culprit
737                     if (x % 23 == 0) {
738                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
739                         elemcborlen += 0x40;
740                         uint lctr = ctr;
741                         while (byte(elemcborlen).length > ctr - lctr) {
742                             res[ctr] = byte(elemcborlen)[ctr - lctr];
743                             ctr++;
744                         }
745                     }
746                     res[ctr] = elemArray[i][x];
747                     ctr++;
748                 }
749                 res[ctr] = 0xFF;
750                 ctr++;
751             }
752             return res;
753         }
754 
755 
756     string oraclize_network_name;
757     function oraclize_setNetworkName(string _network_name) internal {
758         oraclize_network_name = _network_name;
759     }
760 
761     function oraclize_getNetworkName() internal returns (string) {
762         return oraclize_network_name;
763     }
764 
765     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
766         if ((_nbytes == 0)||(_nbytes > 32)) throw;
767   // Convert from seconds to ledger timer ticks
768         _delay *= 10; 
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
780         bytes memory delay = new bytes(32);
781         assembly { 
782             mstore(add(delay, 0x20), _delay) 
783         }
784         
785         bytes memory delay_bytes8 = new bytes(8);
786         copyBytes(delay, 24, 8, delay_bytes8, 0);
787 
788         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
789         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
790         
791         bytes memory delay_bytes8_left = new bytes(8);
792         
793         assembly {
794             let x := mload(add(delay_bytes8, 0x20))
795             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
796             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
797             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
798             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
799             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
800             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
801             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
802             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
803 
804         }
805         
806         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
807         return queryId;
808     }
809     
810     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
811         oraclize_randomDS_args[queryId] = commitment;
812     }
813 
814     mapping(bytes32=>bytes32) oraclize_randomDS_args;
815     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
816 
817     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
818         bool sigok;
819         address signer;
820 
821         bytes32 sigr;
822         bytes32 sigs;
823 
824         bytes memory sigr_ = new bytes(32);
825         uint offset = 4+(uint(dersig[3]) - 0x20);
826         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
827         bytes memory sigs_ = new bytes(32);
828         offset += 32 + 2;
829         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
830 
831         assembly {
832             sigr := mload(add(sigr_, 32))
833             sigs := mload(add(sigs_, 32))
834         }
835 
836 
837         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
838         if (address(sha3(pubkey)) == signer) return true;
839         else {
840             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
841             return (address(sha3(pubkey)) == signer);
842         }
843     }
844 
845     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
846         bool sigok;
847 
848         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
849         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
850         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
851 
852         bytes memory appkey1_pubkey = new bytes(64);
853         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
854 
855         bytes memory tosign2 = new bytes(1+65+32);
856         tosign2[0] = 1; //role
857         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
858         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
859         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
860         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
861 
862         if (sigok == false) return false;
863 
864 
865         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
866         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
867 
868         bytes memory tosign3 = new bytes(1+65);
869         tosign3[0] = 0xFE;
870         copyBytes(proof, 3, 65, tosign3, 1);
871 
872         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
873         copyBytes(proof, 3+65, sig3.length, sig3, 0);
874 
875         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
876 
877         return sigok;
878     }
879 
880     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
881         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
882         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
883 
884         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
885         if (proofVerified == false) throw;
886 
887         _;
888     }
889 
890     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
891         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
892         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
893 
894         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
895         if (proofVerified == false) return 2;
896 
897         return 0;
898     }
899 
900     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
901         bool match_ = true;
902   
903   if (prefix.length != n_random_bytes) throw;
904           
905         for (uint256 i=0; i< n_random_bytes; i++) {
906             if (content[i] != prefix[i]) match_ = false;
907         }
908 
909         return match_;
910     }
911 
912     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
913 
914         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
915         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
916         bytes memory keyhash = new bytes(32);
917         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
918         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
919 
920         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
921         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
922 
923         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
924         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
925 
926         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
927         // This is to verify that the computed args match with the ones specified in the query.
928         bytes memory commitmentSlice1 = new bytes(8+1+32);
929         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
930 
931         bytes memory sessionPubkey = new bytes(64);
932         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
933         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
934 
935         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
936         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
937             delete oraclize_randomDS_args[queryId];
938         } else return false;
939 
940 
941         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
942         bytes memory tosign1 = new bytes(32+8+1+32);
943         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
944         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
945 
946         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
947         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
948             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
949         }
950 
951         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
952     }
953 
954 
955     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
956     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
957         uint minLength = length + toOffset;
958 
959         if (to.length < minLength) {
960             // Buffer too small
961             throw; // Should be a better way?
962         }
963 
964         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
965         uint i = 32 + fromOffset;
966         uint j = 32 + toOffset;
967 
968         while (i < (32 + fromOffset + length)) {
969             assembly {
970                 let tmp := mload(add(from, i))
971                 mstore(add(to, j), tmp)
972             }
973             i += 32;
974             j += 32;
975         }
976 
977         return to;
978     }
979 
980     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
981     // Duplicate Solidity's ecrecover, but catching the CALL return value
982     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
983         // We do our own memory management here. Solidity uses memory offset
984         // 0x40 to store the current end of memory. We write past it (as
985         // writes are memory extensions), but don't update the offset so
986         // Solidity will reuse it. The memory used here is only needed for
987         // this context.
988 
989         // FIXME: inline assembly can't access return values
990         bool ret;
991         address addr;
992 
993         assembly {
994             let size := mload(0x40)
995             mstore(size, hash)
996             mstore(add(size, 32), v)
997             mstore(add(size, 64), r)
998             mstore(add(size, 96), s)
999 
1000             // NOTE: we can reuse the request memory because we deal with
1001             //       the return code
1002             ret := call(3000, 1, 0, size, 128, size, 32)
1003             addr := mload(size)
1004         }
1005 
1006         return (ret, addr);
1007     }
1008 
1009     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1010     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1011         bytes32 r;
1012         bytes32 s;
1013         uint8 v;
1014 
1015         if (sig.length != 65)
1016           return (false, 0);
1017 
1018         // The signature format is a compact form of:
1019         //   {bytes32 r}{bytes32 s}{uint8 v}
1020         // Compact means, uint8 is not padded to 32 bytes.
1021         assembly {
1022             r := mload(add(sig, 32))
1023             s := mload(add(sig, 64))
1024 
1025             // Here we are loading the last 32 bytes. We exploit the fact that
1026             // 'mload' will pad with zeroes if we overread.
1027             // There is no 'mload8' to do this, but that would be nicer.
1028             v := byte(0, mload(add(sig, 96)))
1029 
1030             // Alternative solution:
1031             // 'byte' is not working due to the Solidity parser, so lets
1032             // use the second best option, 'and'
1033             // v := and(mload(add(sig, 65)), 255)
1034         }
1035 
1036         // albeit non-transactional signatures are not specified by the YP, one would expect it
1037         // to match the YP range of [27, 28]
1038         //
1039         // geth uses [0, 1] and some clients have followed. This might change, see:
1040         //  https://github.com/ethereum/go-ethereum/issues/2053
1041         if (v < 27)
1042           v += 27;
1043 
1044         if (v != 27 && v != 28)
1045             return (false, 0);
1046 
1047         return safer_ecrecover(hash, v, r, s);
1048     }
1049 
1050 }
1051 // </ORACLIZE_API>
1052 
1053 
1054 /**
1055  * @title SafeMath
1056  * @dev Math operations with safety checks that throw on error
1057  */
1058 library SafeMath {
1059 
1060   /**
1061   * @dev Multiplies two numbers, throws on overflow.
1062   */
1063   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1064     if (a == 0) {
1065       return 0;
1066     }
1067     uint256 c = a * b;
1068     assert(c / a == b);
1069     return c;
1070   }
1071 
1072   /**
1073   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1074   */
1075   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1076     assert(b <= a);
1077     return a - b;
1078   }
1079 
1080   /**
1081   * @dev Adds two numbers, throws on overflow.
1082   */
1083   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1084     uint256 c = a + b;
1085     assert(c >= a);
1086     return c;
1087   }
1088 }
1089 
1090 /*
1091  * Copyright (c) 2018, DEurovision.eu
1092  */
1093 
1094 contract Eurovision is usingOraclize {
1095 
1096   // Use SafeMath library to avoid overflows/underflows
1097   using SafeMath for uint256;
1098 
1099   // List of participating countries. NONE is used for an initial state.
1100   enum Countries { 
1101     NONE, 
1102     Albania,
1103     Armenia, 
1104     Australia, 
1105     Austria,
1106     Azerbaijan,
1107     Belarus,
1108     Belgium,
1109     Bulgaria,
1110     Croatia,
1111     Cyprus,
1112     Czech_Republic,
1113     Denmark,
1114     Estonia,
1115     Macedonia,
1116     Finland,
1117     France,
1118     Georgia,
1119     Germany,
1120     Greece,
1121     Hungary,
1122     Iceland,
1123     Ireland,
1124     Israel,
1125     Italy,
1126     Latvia,
1127     Lithuania,
1128     Malta,
1129     Moldova,
1130     Montenegro,
1131     Norway,
1132     Poland,
1133     Portugal,
1134     Romania,
1135     Russia,
1136     San_Marino,
1137     Serbia,
1138     Slovenia,
1139     Spain,
1140     Sweden,
1141     Switzerland,
1142     The_Netherlands,
1143     Ukraine,
1144     United_Kingdom 
1145   }
1146 
1147   // Number of participating countries.
1148   uint256 public constant NUMBER_OF_COUNTRIES = uint256(Countries.United_Kingdom);
1149 
1150   // Country that won the contest.
1151   uint256 public countryWinnerID;
1152 
1153   // Staker address -> country ID -> amount.
1154   mapping (address => mapping (uint256 => uint256)) public stakes;
1155   // Staker address -> total amount of wei received from that address.
1156   mapping (address => uint256) public weiReceived;
1157   // Reward/Refund claimed?
1158   mapping (address => bool) public claimed;
1159 
1160   // Statistics of each country (stakes amount + number of stakers).
1161   Statistics[44] public countryStats;
1162 
1163   // Country statistics (how many stakers and how much is placed on a specific country).
1164   struct Statistics {
1165     uint256 amount;
1166     uint256 numberOfStakers;
1167   }
1168 
1169   // Deadline to stake is the start of the 1st semi-final: May 8th, 7 pm GMT.
1170   uint256 public constant STAKE_DEADLINE = 1525806000;
1171   // Winner should be announced until: May 18th, 7 pm GMT.
1172   uint256 public constant ANNOUNCE_WINNER_DEADLINE = 1526670000;
1173   // Rewards/Refunds should be claimed until: June 8th, 7 pm GMT.
1174   uint256 public constant CLAIM_DEADLINE = 1528484400;
1175 
1176   // If the winner was queried at least 3 times < 24 hours before the deadline but 
1177   // no result received from the callback, allow announcing it manually.
1178   uint256 private attemptsToQueryInLast24Hours = 0;
1179   uint256 private MIN_NUMBER_OF_ATTEMPTS_TO_WAIT = 3;
1180   // Time when the last query was sent to Oraclize.
1181   uint256 private lastQueryTime;
1182   // Wait the callback for at least 30 mins.
1183   uint256 private constant MIN_CALLBACK_WAIT_TIME = 30 minutes;
1184 
1185   // Only 0.002 Ether or more is allowed.
1186   uint256 public constant MIN_STAKE = 0.002 ether;
1187 
1188   // The sum of all amounts of stakes.
1189   uint256 public totalPot = 0;
1190 
1191   // If the winner is confirmed, participants can start claiming their winnings.
1192   bool public winnerConfirmed = false;
1193 
1194   // Participants can retrieve their Ether back once refunds are enabled.
1195   bool public refundsEnabled = false;
1196 
1197   // Owner of the contract.
1198   address public owner;
1199 
1200   // 4% fee for the development.
1201   uint256 public constant DEVELOPER_FEE_PERCENTAGE = 4;
1202   // Total number of collected fees.
1203   uint256 public collectedFees = 0;
1204   // Constant representing 100%.
1205   uint256 private constant PERCENTAGE_100 = 100;
1206 
1207   // Events to notify frontend.
1208   event Stake(address indexed staker, uint256 indexed countryID, uint256 amount);
1209   event WinnerAnnounced(uint256 winnerID);
1210   event WinnerConfirmed(uint256 winnerID);
1211   event Claim(address indexed staker, uint256 stakeAmount, uint256 claimAmount);
1212   event RefundsEnabled();
1213   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1214 
1215   // Initialize fields in the constructor.
1216   function Eurovision() public {
1217     owner = msg.sender;
1218     countryWinnerID = uint256(Countries.NONE);
1219   }
1220 
1221   // Stake on a specific country.
1222   function stake(uint256 countryID) external validCountry(countryID) payable {
1223     require(now <= STAKE_DEADLINE);
1224     require(!refundsEnabled);
1225     require(msg.value >= MIN_STAKE);
1226 
1227     address staker = msg.sender;
1228     uint256 weiAmount = msg.value;
1229     uint256 fee = weiAmount.mul(DEVELOPER_FEE_PERCENTAGE) / PERCENTAGE_100;
1230     uint256 actualStake = weiAmount.sub(fee);
1231 
1232     weiReceived[staker] = weiReceived[staker].add(actualStake);
1233     stakes[staker][countryID] = stakes[staker][countryID].add(actualStake);
1234     countryStats[countryID].amount = countryStats[countryID].amount.add(actualStake);
1235     if (stakes[staker][countryID] == actualStake) {
1236       countryStats[countryID].numberOfStakers++;
1237     }
1238 
1239     collectedFees = collectedFees.add(fee);
1240     totalPot = totalPot.add(actualStake);
1241 
1242     Stake(staker, countryID, actualStake);
1243   }
1244 
1245   // Get back all your Ether (fees are also refunded).
1246   function refund() external {
1247     require(canRefund());
1248     require(!claimed[msg.sender]);
1249 
1250     address refunder = msg.sender;
1251     uint256 refundAmount = weiReceived[refunder].mul(PERCENTAGE_100) / (PERCENTAGE_100.sub(DEVELOPER_FEE_PERCENTAGE)) ;
1252     claimed[refunder] = true;
1253 
1254     if (collectedFees > 0) {
1255       collectedFees = 0;
1256     }
1257 
1258     refunder.transfer(refundAmount);
1259     Claim(refunder, refundAmount, refundAmount);
1260   }
1261 
1262   // Claim your reward if you guessed the winner correctly.
1263   function claimWinnings() external {
1264     require(winnerConfirmed);
1265     require(now <= CLAIM_DEADLINE);
1266     require(!refundsEnabled);
1267     require(!claimed[msg.sender]);
1268 
1269     address claimer = msg.sender;
1270     
1271     uint256 myStakesOnWinner = myStakesOnCountry(countryWinnerID);
1272     uint256 totalStakesOnWinner = countryStats[countryWinnerID].amount;
1273     uint256 reward = myStakesOnWinner.mul(totalPot) / totalStakesOnWinner;
1274 
1275     claimed[claimer] = true;
1276 
1277     claimer.transfer(reward);
1278     Claim(claimer, myStakesOnWinner, reward);
1279   }
1280 
1281   // Send the query to Oraclize to retrieve the winner ID.
1282   function queryWinner(string apiKey) external possibleToAnnounceWinner onlyOwner {
1283     require(now > STAKE_DEADLINE);
1284 
1285     if (now.add(24 hours) >= ANNOUNCE_WINNER_DEADLINE && countryWinnerID == uint256(Countries.NONE)) {
1286       attemptsToQueryInLast24Hours.add(1);
1287       lastQueryTime = now;
1288     }
1289     
1290     oraclize_query("computation", ["QmQ9PvNoKSRpbGduSbvyBHwVZQ97Pw7JYEnbTiLfcKHapE", apiKey]);
1291   }
1292 
1293   // Oraclize callback. Returns result from the computation datasource.
1294   function __callback(bytes32 myid, string result) {
1295     require(msg.sender == oraclize_cbAddress());
1296 
1297     uint256 winnerID = parseInt(result);
1298 
1299     require(winnerID > 0);
1300     require(winnerID <= NUMBER_OF_COUNTRIES);
1301     
1302     countryWinnerID = winnerID;
1303     WinnerAnnounced(countryWinnerID);
1304   }
1305 
1306   // If the Oraclize didn't return the result in 30 mins during the last 24 hours, owner can announce the winner manually.
1307   function announceWinnerManually(uint256 winnerID) external validCountry(winnerID) possibleToAnnounceWinner onlyOwner {
1308     require(attemptsToQueryInLast24Hours >= MIN_NUMBER_OF_ATTEMPTS_TO_WAIT);
1309     require(now >= lastQueryTime.add(MIN_CALLBACK_WAIT_TIME));
1310 
1311     countryWinnerID = winnerID;
1312     WinnerAnnounced(countryWinnerID);
1313   }
1314 
1315   // 2-step verification that the right winner was announced (minimize the probability of error).
1316   function confirmWinner() external possibleToAnnounceWinner onlyOwner {
1317     require(countryWinnerID != uint256(Countries.NONE));
1318 
1319     winnerConfirmed = true;
1320     WinnerConfirmed(countryWinnerID);
1321   }
1322 
1323   // Fallback function. Owner can send some Ether to the contract. Ether is needed to call the Oraclize.
1324   function () external payable onlyOwner {
1325     
1326   }
1327   
1328   // Get total stakes amount and number of stakers for specific country.
1329   function getCountryStats(uint256 countryID) external view validCountry(countryID) returns(uint256 amount, uint256 numberOfStakers) {
1330     return (countryStats[countryID].amount, countryStats[countryID].numberOfStakers);
1331   }
1332 
1333   // Get my amount of stakes for a specific country.
1334   function myStakesOnCountry(uint256 countryID) public view validCountry(countryID) returns(uint256 myStake) {
1335     return stakes[msg.sender][countryID];
1336   } 
1337 
1338   // Get my total amount of Ether staked on all countries.
1339   function myTotalStakeAmount() public view returns(uint256 myStake) {
1340     return weiReceived[msg.sender];
1341   } 
1342 
1343   // Indicated if an address has already claimed the winnings/refunds.
1344   function alreadyClaimed() public view returns(bool hasClaimed) {
1345     return claimed[msg.sender];
1346   } 
1347   
1348   // Check if refunds are possible.
1349   function canRefund() public view returns(bool) {
1350     bool winnerNotAnnouncedInTime = (now > ANNOUNCE_WINNER_DEADLINE) && !winnerConfirmed;
1351     bool notExpired = (now <= CLAIM_DEADLINE);
1352     return (refundsEnabled || winnerNotAnnouncedInTime) && notExpired;
1353   } 
1354 
1355   // In case of an emergency situation or other unexpected event an owner of the contract can explicitly enable refunds.
1356   function enableRefunds() external onlyOwner { 
1357     require(!refundsEnabled);
1358     require(!winnerConfirmed);
1359     
1360     refundsEnabled = true;
1361     RefundsEnabled();
1362   }
1363 
1364   // Only when all the winnings are supposed to be claimed, owner can receive the fees.
1365   function claimFees() external onlyOwner {
1366     require(now > CLAIM_DEADLINE);
1367     require(collectedFees > 0);
1368 
1369     uint256 amount = collectedFees; 
1370     collectedFees = 0;  
1371     
1372     owner.transfer(amount);
1373   }
1374 
1375   // Transfer ownership of the contract to the new address.
1376   function transferOwnership(address newOwner) external onlyOwner {
1377     require(newOwner != address(0));
1378 
1379     owner = newOwner;
1380     OwnershipTransferred(owner, newOwner);
1381   }
1382 
1383   // Free the memory when the contest ends and all the winnings/refunds are supposed to be claimed.
1384   function kill() external onlyOwner {
1385     require(now > CLAIM_DEADLINE);
1386     selfdestruct(owner);
1387   }
1388 
1389   // ID belongs to the list.
1390   modifier validCountry(uint256 countryID) { 
1391     require(countryID > 0);
1392     require(countryID <= NUMBER_OF_COUNTRIES);
1393     _; 
1394   }
1395 
1396   // Valid state to announce/confirm the winner.
1397   modifier possibleToAnnounceWinner() { 
1398     require(now <= ANNOUNCE_WINNER_DEADLINE);
1399     require(!refundsEnabled);
1400     require(!winnerConfirmed);
1401     _; 
1402   }
1403 
1404   // Only executable by an owner of the contract.
1405   modifier onlyOwner() {
1406     require(msg.sender == owner);
1407     _;
1408   }
1409 
1410 }