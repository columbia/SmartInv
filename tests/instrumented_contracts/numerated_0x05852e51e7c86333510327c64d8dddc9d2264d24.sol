1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize SRL
4 Copyright (c) 2016 Oraclize LTD
5 
6 
7 
8 Permission is hereby granted, free of charge, to any person obtaining a copy
9 of this software and associated documentation files (the "Software"), to deal
10 in the Software without restriction, including without limitation the rights
11 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 copies of the Software, and to permit persons to whom the Software is
13 furnished to do so, subject to the following conditions:
14 
15 
16 
17 The above copyright notice and this permission notice shall be included in
18 all copies or substantial portions of the Software.
19 
20 
21 
22 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
25 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
28 THE SOFTWARE.
29 */
30 
31 pragma solidity ^0.4.16;
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
630     function strConcat(string _a, string _b, string _c, string _d, string _e, string _f, string _g) internal returns (string){
631         return strConcat(strConcat(_a, _b), strConcat(_c, _d, _e, _f, _g));
632     }
633 
634     // parseInt
635     function parseInt(string _a) internal returns (uint) {
636         return parseInt(_a, 0);
637     }
638 
639     // parseInt(parseFloat*10^_b)
640     function parseInt(string _a, uint _b) internal returns (uint) {
641         bytes memory bresult = bytes(_a);
642         uint mint = 0;
643         bool decimals = false;
644         for (uint i=0; i<bresult.length; i++){
645             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
646                 if (decimals){
647                    if (_b == 0) break;
648                     else _b--;
649                 }
650                 mint *= 10;
651                 mint += uint(bresult[i]) - 48;
652             } else if (bresult[i] == 46) decimals = true;
653         }
654         if (_b > 0) mint *= 10**_b;
655         return mint;
656     }
657 
658     function uint2str(uint i) internal returns (string){
659         if (i == 0) return "0";
660         uint j = i;
661         uint len;
662         while (j != 0){
663             len++;
664             j /= 10;
665         }
666         bytes memory bstr = new bytes(len);
667         uint k = len - 1;
668         while (i != 0){
669             bstr[k--] = byte(48 + i % 10);
670             i /= 10;
671         }
672         return string(bstr);
673     }
674 
675     function stra2cbor(string[] arr) internal returns (bytes) {
676             uint arrlen = arr.length;
677 
678             // get correct cbor output length
679             uint outputlen = 0;
680             bytes[] memory elemArray = new bytes[](arrlen);
681             for (uint i = 0; i < arrlen; i++) {
682                 elemArray[i] = (bytes(arr[i]));
683                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
684             }
685             uint ctr = 0;
686             uint cborlen = arrlen + 0x80;
687             outputlen += byte(cborlen).length;
688             bytes memory res = new bytes(outputlen);
689 
690             while (byte(cborlen).length > ctr) {
691                 res[ctr] = byte(cborlen)[ctr];
692                 ctr++;
693             }
694             for (i = 0; i < arrlen; i++) {
695                 res[ctr] = 0x5F;
696                 ctr++;
697                 for (uint x = 0; x < elemArray[i].length; x++) {
698                     // if there's a bug with larger strings, this may be the culprit
699                     if (x % 23 == 0) {
700                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
701                         elemcborlen += 0x40;
702                         uint lctr = ctr;
703                         while (byte(elemcborlen).length > ctr - lctr) {
704                             res[ctr] = byte(elemcborlen)[ctr - lctr];
705                             ctr++;
706                         }
707                     }
708                     res[ctr] = elemArray[i][x];
709                     ctr++;
710                 }
711                 res[ctr] = 0xFF;
712                 ctr++;
713             }
714             return res;
715         }
716 
717     function ba2cbor(bytes[] arr) internal returns (bytes) {
718             uint arrlen = arr.length;
719 
720             // get correct cbor output length
721             uint outputlen = 0;
722             bytes[] memory elemArray = new bytes[](arrlen);
723             for (uint i = 0; i < arrlen; i++) {
724                 elemArray[i] = (bytes(arr[i]));
725                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
726             }
727             uint ctr = 0;
728             uint cborlen = arrlen + 0x80;
729             outputlen += byte(cborlen).length;
730             bytes memory res = new bytes(outputlen);
731 
732             while (byte(cborlen).length > ctr) {
733                 res[ctr] = byte(cborlen)[ctr];
734                 ctr++;
735             }
736             for (i = 0; i < arrlen; i++) {
737                 res[ctr] = 0x5F;
738                 ctr++;
739                 for (uint x = 0; x < elemArray[i].length; x++) {
740                     // if there's a bug with larger strings, this may be the culprit
741                     if (x % 23 == 0) {
742                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
743                         elemcborlen += 0x40;
744                         uint lctr = ctr;
745                         while (byte(elemcborlen).length > ctr - lctr) {
746                             res[ctr] = byte(elemcborlen)[ctr - lctr];
747                             ctr++;
748                         }
749                     }
750                     res[ctr] = elemArray[i][x];
751                     ctr++;
752                 }
753                 res[ctr] = 0xFF;
754                 ctr++;
755             }
756             return res;
757         }
758 
759 
760     string oraclize_network_name;
761     function oraclize_setNetworkName(string _network_name) internal {
762         oraclize_network_name = _network_name;
763     }
764 
765     function oraclize_getNetworkName() internal returns (string) {
766         return oraclize_network_name;
767     }
768 
769     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
770         if ((_nbytes == 0)||(_nbytes > 32)) throw;
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
782         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
783         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
784         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
785         return queryId;
786     }
787 
788     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
789         oraclize_randomDS_args[queryId] = commitment;
790     }
791 
792     mapping(bytes32=>bytes32) oraclize_randomDS_args;
793     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
794 
795     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
796         bool sigok;
797         address signer;
798 
799         bytes32 sigr;
800         bytes32 sigs;
801 
802         bytes memory sigr_ = new bytes(32);
803         uint offset = 4+(uint(dersig[3]) - 0x20);
804         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
805         bytes memory sigs_ = new bytes(32);
806         offset += 32 + 2;
807         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
808 
809         assembly {
810             sigr := mload(add(sigr_, 32))
811             sigs := mload(add(sigs_, 32))
812         }
813 
814 
815         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
816         if (address(sha3(pubkey)) == signer) return true;
817         else {
818             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
819             return (address(sha3(pubkey)) == signer);
820         }
821     }
822 
823     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
824         bool sigok;
825 
826         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
827         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
828         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
829 
830         bytes memory appkey1_pubkey = new bytes(64);
831         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
832 
833         bytes memory tosign2 = new bytes(1+65+32);
834         tosign2[0] = 1; //role
835         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
836         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
837         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
838         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
839 
840         if (sigok == false) return false;
841 
842 
843         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
844         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
845 
846         bytes memory tosign3 = new bytes(1+65);
847         tosign3[0] = 0xFE;
848         copyBytes(proof, 3, 65, tosign3, 1);
849 
850         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
851         copyBytes(proof, 3+65, sig3.length, sig3, 0);
852 
853         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
854 
855         return sigok;
856     }
857 
858     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
859         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
860         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
861 
862         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
863         if (proofVerified == false) throw;
864 
865         _;
866     }
867 
868     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
869         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
870         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
871 
872         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
873         if (proofVerified == false) return 2;
874 
875         return 0;
876     }
877 
878     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
879         bool match_ = true;
880 
881         for (var i=0; i<prefix.length; i++){
882             if (content[i] != prefix[i]) match_ = false;
883         }
884 
885         return match_;
886     }
887 
888     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
889         bool checkok;
890 
891 
892         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
893         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
894         bytes memory keyhash = new bytes(32);
895         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
896         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
897         if (checkok == false) return false;
898 
899         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
900         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
901 
902 
903         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
904         checkok = matchBytes32Prefix(sha256(sig1), result);
905         if (checkok == false) return false;
906 
907 
908         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
909         // This is to verify that the computed args match with the ones specified in the query.
910         bytes memory commitmentSlice1 = new bytes(8+1+32);
911         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
912 
913         bytes memory sessionPubkey = new bytes(64);
914         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
915         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
916 
917         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
918         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
919             delete oraclize_randomDS_args[queryId];
920         } else return false;
921 
922 
923         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
924         bytes memory tosign1 = new bytes(32+8+1+32);
925         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
926         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
927         if (checkok == false) return false;
928 
929         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
930         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
931             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
932         }
933 
934         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
935     }
936 
937 
938     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
939     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
940         uint minLength = length + toOffset;
941 
942         if (to.length < minLength) {
943             // Buffer too small
944             throw; // Should be a better way?
945         }
946 
947         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
948         uint i = 32 + fromOffset;
949         uint j = 32 + toOffset;
950 
951         while (i < (32 + fromOffset + length)) {
952             assembly {
953                 let tmp := mload(add(from, i))
954                 mstore(add(to, j), tmp)
955             }
956             i += 32;
957             j += 32;
958         }
959 
960         return to;
961     }
962 
963     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
964     // Duplicate Solidity's ecrecover, but catching the CALL return value
965     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
966         // We do our own memory management here. Solidity uses memory offset
967         // 0x40 to store the current end of memory. We write past it (as
968         // writes are memory extensions), but don't update the offset so
969         // Solidity will reuse it. The memory used here is only needed for
970         // this context.
971 
972         // FIXME: inline assembly can't access return values
973         bool ret;
974         address addr;
975 
976         assembly {
977             let size := mload(0x40)
978             mstore(size, hash)
979             mstore(add(size, 32), v)
980             mstore(add(size, 64), r)
981             mstore(add(size, 96), s)
982 
983             // NOTE: we can reuse the request memory because we deal with
984             //       the return code
985             ret := call(3000, 1, 0, size, 128, size, 32)
986             addr := mload(size)
987         }
988 
989         return (ret, addr);
990     }
991 
992     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
993     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
994         bytes32 r;
995         bytes32 s;
996         uint8 v;
997 
998         if (sig.length != 65)
999           return (false, 0);
1000 
1001         // The signature format is a compact form of:
1002         //   {bytes32 r}{bytes32 s}{uint8 v}
1003         // Compact means, uint8 is not padded to 32 bytes.
1004         assembly {
1005             r := mload(add(sig, 32))
1006             s := mload(add(sig, 64))
1007 
1008             // Here we are loading the last 32 bytes. We exploit the fact that
1009             // 'mload' will pad with zeroes if we overread.
1010             // There is no 'mload8' to do this, but that would be nicer.
1011             v := byte(0, mload(add(sig, 96)))
1012 
1013             // Alternative solution:
1014             // 'byte' is not working due to the Solidity parser, so lets
1015             // use the second best option, 'and'
1016             // v := and(mload(add(sig, 65)), 255)
1017         }
1018 
1019         // albeit non-transactional signatures are not specified by the YP, one would expect it
1020         // to match the YP range of [27, 28]
1021         //
1022         // geth uses [0, 1] and some clients have followed. This might change, see:
1023         //  https://github.com/ethereum/go-ethereum/issues/2053
1024         if (v < 27)
1025           v += 27;
1026 
1027         if (v != 27 && v != 28)
1028             return (false, 0);
1029 
1030         return safer_ecrecover(hash, v, r, s);
1031     }
1032 
1033 }
1034 // </ORACLIZE_API>
1035 
1036 // copyright contact@bytether.com
1037 
1038 contract BasicUtility {
1039 
1040     function stringToUint(string s) constant internal returns (uint result) {
1041         bytes memory b = bytes(s);
1042         uint i;
1043         result = 0;
1044         for (i = 0; i < b.length; i++) {
1045             uint c = uint(b[i]);
1046             if (c >= 48 && c <= 57) {
1047                 result = result * 10 + (c - 48);
1048             }
1049         }
1050     }
1051 
1052     function checkValidBitcoinAddress(string bitcoinAddress) constant internal returns (bool) {
1053         bytes memory bitcoinAddressBytes = bytes(bitcoinAddress);
1054         if (bitcoinAddressBytes.length < 20)
1055             return false;
1056         for(uint i = 0; i < bitcoinAddressBytes.length; i++) {
1057             if (bitcoinAddressBytes[i] < 48 
1058             || (bitcoinAddressBytes[i] > 57 && bitcoinAddressBytes[i] < 65)
1059             || (bitcoinAddressBytes[i] > 90 && bitcoinAddressBytes[i] < 97)  
1060             || bitcoinAddressBytes[i] > 122) 
1061                 return false;            
1062         }
1063         return true;
1064     }
1065 
1066     function checkValidBase64(string sig) constant internal returns (bool) {
1067         bytes memory sigBytes = bytes(sig);
1068         for(uint i = 0; i < sigBytes.length; i++) {
1069             if (sigBytes[i] == 43)
1070                 continue;
1071             if (sigBytes[i] == 47)
1072                 continue;
1073             if (sigBytes[i] == 61)
1074                 continue;
1075             if (sigBytes[i] >= 48 && sigBytes[i] <= 57)
1076                 continue;
1077             if (sigBytes[i] >= 65 && sigBytes[i] <= 90)
1078                 continue;
1079             if (sigBytes[i] >= 97 && sigBytes[i] <= 122)
1080                 continue;
1081             return false;
1082         }
1083         return true;
1084     }
1085 
1086     function addressToString(address x) constant internal returns (string) {
1087         bytes memory s = new bytes(40);
1088         for (uint i = 0; i < 20; i++) {
1089             byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
1090             byte hi = byte(uint8(b) / 16);
1091             byte lo = byte(uint8(b) - 16 * uint8(hi));
1092             s[2*i] = getChar(hi);
1093             s[2*i+1] = getChar(lo);            
1094         }
1095         return string(s);
1096     }
1097     
1098     function getChar(byte b) constant internal returns (byte c) {
1099         if (b < 10) return byte(uint8(b) + 0x30);
1100         else return byte(uint8(b) + 0x57);
1101     }
1102 }
1103 
1104 contract BasicAccessControl {
1105     address public owner;
1106     address[] public moderators;
1107 
1108     function BasicAccessControl() public {
1109         owner = msg.sender;
1110     }
1111 
1112     modifier onlyOwner {
1113         require(msg.sender == owner);
1114         _;
1115     }
1116 
1117     modifier onlyModerators() {
1118         if (msg.sender != owner) {
1119             bool found = false;
1120             for (uint index = 0; index < moderators.length; index++) {
1121                 if (moderators[index] == msg.sender) {
1122                     found = true;
1123                     break;
1124                 }
1125             }
1126             require(found);
1127         }
1128         _;
1129     }
1130 
1131     function ChangeOwner(address _newOwner) onlyOwner public {
1132         if (_newOwner != address(0)) {
1133             owner = _newOwner;
1134         }
1135     }
1136 
1137     function Kill() onlyOwner public {
1138         selfdestruct(owner);
1139     }
1140 
1141     function AddModerator(address _newModerator) onlyOwner public {
1142         if (_newModerator != address(0)) {
1143             for (uint index = 0; index < moderators.length; index++) {
1144                 if (moderators[index] == _newModerator) {
1145                     return;
1146                 }
1147             }
1148             moderators.push(_newModerator);
1149         }
1150     }
1151     
1152     function RemoveModerator(address _oldModerator) onlyOwner public {
1153         uint foundIndex = 0;
1154         for (; foundIndex < moderators.length; foundIndex++) {
1155             if (moderators[foundIndex] == _oldModerator) {
1156                 break;
1157             }
1158         }
1159         if (foundIndex < moderators.length) {
1160             moderators[foundIndex] = moderators[moderators.length-1];
1161             delete moderators[moderators.length-1];
1162             moderators.length--;
1163         }
1164     }
1165 }
1166 
1167 interface CrossForkDistribution {
1168     function getDistributedAmount(uint64 _requestId, string _btcAddress, address _receiver) public;
1169 }
1170 
1171 interface CrossForkCallback {
1172     function callbackCrossFork(uint64 _requestId, uint256 _amount, bytes32 _referCodeHash) public;
1173 }
1174 
1175 interface BytetherOVI {
1176     function GetOwnership(string _btcAddress) constant public returns(address, bytes32);
1177 }
1178 
1179 contract BTHCrossFork is usingOraclize, BasicUtility, BasicAccessControl, CrossForkDistribution {
1180 
1181     enum QueryResultCode {
1182         SUCCESS,
1183         NOT_ENOUGH_BALANCE,
1184         INVALID_QUERY,
1185         INVALID_OV_VERIFY,
1186         INVALID_BITCOIN_ADDRESS
1187     }
1188 
1189     struct QueryInfo {
1190         uint64 requestId;
1191         address sender;
1192     }
1193     mapping(bytes32=>QueryInfo) queries;
1194     string public verifyUrl = "";
1195     uint64 public crossForkBlockNumber = 478558;
1196     uint public gasLimit = 200000;
1197     uint public gasPrice = 20000000000 wei;
1198 
1199     event LogReceiveQuery(bytes32 indexed queryId, uint64 requestId, uint256 amount, QueryResultCode resultCode);
1200     event LogTriggerQuery(bytes32 indexed btcAddressHash, uint64 requestId, address receiver, QueryResultCode resultCode);
1201     
1202     function BTHCrossFork(string _verifyUrl, uint64 _crossForkBlockNumber) public {
1203         verifyUrl = _verifyUrl;
1204         crossForkBlockNumber = _crossForkBlockNumber;
1205         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1206     }
1207 
1208     function () payable public {}
1209 
1210     function setOraclizeGasPrice(uint _gasPrice) onlyModerators public {
1211         gasPrice = _gasPrice;
1212         oraclize_setCustomGasPrice(gasPrice);
1213     }
1214 
1215     function setOraclizeGasLimit(uint _gasLimit) onlyModerators public {
1216         gasLimit = _gasLimit;
1217     }
1218     
1219     // moderator function
1220     
1221     function setVerifyUrl(string _verifyUrl) onlyModerators public {
1222         verifyUrl = _verifyUrl;
1223     }
1224 
1225     function setCrossForkBlockNumber(uint64 _blockNumber) onlyModerators public {
1226         crossForkBlockNumber = _blockNumber;
1227     }
1228     
1229     // public
1230     
1231     function extractBTHAmount(string result) constant public returns(uint256, bytes32) {
1232         // result format v=xxxx&r=0x
1233         uint256 value = 0;
1234         bytes memory b = bytes(result);
1235         uint referCodeHash = 0;
1236         // verify correct format
1237         if (b[0] != 118 || b[1] != 61)
1238             return (value, bytes32(referCodeHash));
1239         uint i = 2;
1240         for (i = 2; i < b.length; i++) { 
1241             if (b[i] < 48 || b[i] > 57)
1242                 break;
1243             value = value * 10 + (uint256(b[i]) - 48); 
1244         }
1245         if (i+5>b.length || b[i] != 38 || b[i+1] != 114 || b[i+2] != 61 || b[i+3]!=48 || b[i+4]!=120)
1246             return (value, bytes32(referCodeHash));
1247         for (i=i+5; i < b.length; i++) {
1248             uint c = uint(b[i]);
1249             if (c >= 48 && c <= 57) {
1250                 referCodeHash = referCodeHash * 16 + (c - 48);
1251             }
1252             if(c >= 65 && c<= 90) {
1253                 referCodeHash = referCodeHash * 16 + (c - 55);
1254             }
1255             if(c >= 97 && c<= 122) {
1256                 referCodeHash = referCodeHash * 16 + (c - 87);
1257             }
1258         }
1259         return (value, bytes32(referCodeHash));
1260     }
1261 
1262     function __callback(bytes32 _queryId, string _result, bytes proof) public {
1263         if (msg.sender != oraclize_cbAddress()) {
1264             LogReceiveQuery(_queryId, 0, 0, QueryResultCode.INVALID_QUERY);
1265             return;
1266         }
1267 
1268         QueryInfo storage info = queries[_queryId];
1269         if (info.sender == 0x0) {
1270             LogReceiveQuery(_queryId, info.requestId, 0, QueryResultCode.INVALID_QUERY);
1271             return;
1272         }
1273 
1274         uint256 amount = 0;
1275         bytes32 referCodeHash = 0;
1276         (amount, referCodeHash) = extractBTHAmount(_result);
1277         CrossForkCallback crossfork = CrossForkCallback(info.sender);
1278         crossfork.callbackCrossFork(info.requestId, amount, referCodeHash);
1279         LogReceiveQuery(_queryId, info.requestId, amount, QueryResultCode.SUCCESS);
1280     }
1281 
1282     function getDistributedAmount(uint64 _requestId, string _btcAddress, address _receiver) public {
1283         // get refercode & basic verify
1284         bytes32 btcAddressHash = keccak256(_btcAddress);
1285         if (!checkValidBitcoinAddress(_btcAddress)) {
1286             LogTriggerQuery(btcAddressHash, _requestId, _receiver, QueryResultCode.INVALID_BITCOIN_ADDRESS);
1287             return;            
1288         }
1289 
1290         // query external api to check bitcoin txn & balance by btcAddress & verifyCode
1291         if (oraclize_getPrice("URL") > this.balance) {
1292             LogTriggerQuery(btcAddressHash, _requestId, _receiver, QueryResultCode.NOT_ENOUGH_BALANCE);
1293             return;
1294         }
1295         bytes32 queryId = oraclize_query(
1296             "URL",
1297             verifyUrl,
1298             strConcat(
1299                 '{"btc_address":"', 
1300                 _btcAddress, 
1301                 '","eth_address":"', 
1302                 addressToString(_receiver), 
1303                 '","block_number":"', 
1304                 uint2str(crossForkBlockNumber), 
1305                 '"}'),
1306             gasLimit
1307         );
1308         QueryInfo storage info = queries[queryId];
1309         info.requestId = _requestId;
1310         info.sender = msg.sender;
1311         LogTriggerQuery(btcAddressHash, _requestId, _receiver, QueryResultCode.SUCCESS);
1312     }
1313 }