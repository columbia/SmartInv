1 pragma solidity ^0.4.8;
2 
3 
4 
5 // <ORACLIZE_API>
6 /*
7 Copyright (c) 2015-2016 Oraclize SRL
8 Copyright (c) 2016 Oraclize LTD
9 
10 
11 
12 Permission is hereby granted, free of charge, to any person obtaining a copy
13 of this software and associated documentation files (the "Software"), to deal
14 in the Software without restriction, including without limitation the rights
15 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16 copies of the Software, and to permit persons to whom the Software is
17 furnished to do so, subject to the following conditions:
18 
19 
20 
21 The above copyright notice and this permission notice shall be included in
22 all copies or substantial portions of the Software.
23 
24 
25 
26 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
29 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
32 THE SOFTWARE.
33 */
34 
35 
36 
37 contract OraclizeI {
38     address public cbAddress;
39     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
40     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
41     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
42     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
43     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
44     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
45     function getPrice(string _datasource) returns (uint _dsprice);
46     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
47     function useCoupon(string _coupon);
48     function setProofType(byte _proofType);
49     function setConfig(bytes32 _config);
50     function setCustomGasPrice(uint _gasPrice);
51     function randomDS_getSessionPubKeyHash() returns(bytes32);
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
62     byte constant proofType_Android = 0x20;
63     byte constant proofType_Ledger = 0x30;
64     byte constant proofType_Native = 0xF0;
65     byte constant proofStorage_IPFS = 0x01;
66     uint8 constant networkID_auto = 0;
67     uint8 constant networkID_mainnet = 1;
68     uint8 constant networkID_testnet = 2;
69     uint8 constant networkID_morden = 2;
70     uint8 constant networkID_consensys = 161;
71 
72     OraclizeAddrResolverI OAR;
73 
74     OraclizeI oraclize;
75     modifier oraclizeAPI {
76         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
77         oraclize = OraclizeI(OAR.getAddress());
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
767         bytes memory nbytes = new bytes(1);
768         nbytes[0] = byte(_nbytes);
769         bytes memory unonce = new bytes(32);
770         bytes memory sessionKeyHash = new bytes(32);
771         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
772         assembly {
773             mstore(unonce, 0x20)
774             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
775             mstore(sessionKeyHash, 0x20)
776             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
777         }
778         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
779         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
780         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
781         return queryId;
782     }
783     
784     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
785         oraclize_randomDS_args[queryId] = commitment;
786     }
787     
788     mapping(bytes32=>bytes32) oraclize_randomDS_args;
789     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
790 
791     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
792         bool sigok;
793         address signer;
794         
795         bytes32 sigr;
796         bytes32 sigs;
797         
798         bytes memory sigr_ = new bytes(32);
799         uint offset = 4+(uint(dersig[3]) - 0x20);
800         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
801         bytes memory sigs_ = new bytes(32);
802         offset += 32 + 2;
803         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
804 
805         assembly {
806             sigr := mload(add(sigr_, 32))
807             sigs := mload(add(sigs_, 32))
808         }
809         
810         
811         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
812         if (address(sha3(pubkey)) == signer) return true;
813         else {
814             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
815             return (address(sha3(pubkey)) == signer);
816         }
817     }
818 
819     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
820         bool sigok;
821         
822         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
823         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
824         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
825         
826         bytes memory appkey1_pubkey = new bytes(64);
827         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
828         
829         bytes memory tosign2 = new bytes(1+65+32);
830         tosign2[0] = 1; //role
831         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
832         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
833         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
834         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
835         
836         if (sigok == false) return false;
837         
838         
839         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
840         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
841         
842         bytes memory tosign3 = new bytes(1+65);
843         tosign3[0] = 0xFE;
844         copyBytes(proof, 3, 65, tosign3, 1);
845         
846         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
847         copyBytes(proof, 3+65, sig3.length, sig3, 0);
848         
849         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
850         
851         return sigok;
852     }
853     
854     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
855         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
856         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
857         
858         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
859         if (proofVerified == false) throw;
860         
861         _;
862     }
863     
864     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
865         bool match_ = true;
866         
867         for (var i=0; i<prefix.length; i++){
868             if (content[i] != prefix[i]) match_ = false;
869         }
870         
871         return match_;
872     }
873 
874     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
875         bool checkok;
876         
877         
878         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
879         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
880         bytes memory keyhash = new bytes(32);
881         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
882         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
883         if (checkok == false) return false;
884         
885         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
886         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
887         
888         
889         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
890         checkok = matchBytes32Prefix(sha256(sig1), result);
891         if (checkok == false) return false;
892         
893         
894         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
895         // This is to verify that the computed args match with the ones specified in the query.
896         bytes memory commitmentSlice1 = new bytes(8+1+32);
897         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
898         
899         bytes memory sessionPubkey = new bytes(64);
900         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
901         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
902         
903         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
904         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
905             delete oraclize_randomDS_args[queryId];
906         } else return false;
907         
908         
909         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
910         bytes memory tosign1 = new bytes(32+8+1+32);
911         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
912         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
913         if (checkok == false) return false;
914         
915         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
916         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
917             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
918         }
919         
920         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
921     }
922 
923     
924     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
925     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
926         uint minLength = length + toOffset;
927 
928         if (to.length < minLength) {
929             // Buffer too small
930             throw; // Should be a better way?
931         }
932 
933         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
934         uint i = 32 + fromOffset;
935         uint j = 32 + toOffset;
936 
937         while (i < (32 + fromOffset + length)) {
938             assembly {
939                 let tmp := mload(add(from, i))
940                 mstore(add(to, j), tmp)
941             }
942             i += 32;
943             j += 32;
944         }
945 
946         return to;
947     }
948     
949     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
950     // Duplicate Solidity's ecrecover, but catching the CALL return value
951     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
952         // We do our own memory management here. Solidity uses memory offset
953         // 0x40 to store the current end of memory. We write past it (as
954         // writes are memory extensions), but don't update the offset so
955         // Solidity will reuse it. The memory used here is only needed for
956         // this context.
957 
958         // FIXME: inline assembly can't access return values
959         bool ret;
960         address addr;
961 
962         assembly {
963             let size := mload(0x40)
964             mstore(size, hash)
965             mstore(add(size, 32), v)
966             mstore(add(size, 64), r)
967             mstore(add(size, 96), s)
968 
969             // NOTE: we can reuse the request memory because we deal with
970             //       the return code
971             ret := call(3000, 1, 0, size, 128, size, 32)
972             addr := mload(size)
973         }
974   
975         return (ret, addr);
976     }
977 
978     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
979     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
980         bytes32 r;
981         bytes32 s;
982         uint8 v;
983 
984         if (sig.length != 65)
985           return (false, 0);
986 
987         // The signature format is a compact form of:
988         //   {bytes32 r}{bytes32 s}{uint8 v}
989         // Compact means, uint8 is not padded to 32 bytes.
990         assembly {
991             r := mload(add(sig, 32))
992             s := mload(add(sig, 64))
993 
994             // Here we are loading the last 32 bytes. We exploit the fact that
995             // 'mload' will pad with zeroes if we overread.
996             // There is no 'mload8' to do this, but that would be nicer.
997             v := byte(0, mload(add(sig, 96)))
998 
999             // Alternative solution:
1000             // 'byte' is not working due to the Solidity parser, so lets
1001             // use the second best option, 'and'
1002             // v := and(mload(add(sig, 65)), 255)
1003         }
1004 
1005         // albeit non-transactional signatures are not specified by the YP, one would expect it
1006         // to match the YP range of [27, 28]
1007         //
1008         // geth uses [0, 1] and some clients have followed. This might change, see:
1009         //  https://github.com/ethereum/go-ethereum/issues/2053
1010         if (v < 27)
1011           v += 27;
1012 
1013         if (v != 27 && v != 28)
1014             return (false, 0);
1015 
1016         return safer_ecrecover(hash, v, r, s);
1017     }
1018         
1019 }
1020 // </ORACLIZE_API>
1021 
1022 
1023 contract ERC20 {
1024 
1025   uint public totalSupply;
1026 
1027   function balanceOf(address who) constant returns (uint256);
1028 
1029   function allowance(address owner, address spender) constant returns (uint);
1030 
1031   function transferFrom(address from, address to, uint value) returns (bool ok);
1032 
1033   function approve(address spender, uint value) returns (bool ok);
1034 
1035   function transfer(address to, uint value) returns (bool ok);
1036 
1037   function convert(uint _value) returns (bool ok);
1038 
1039   event Transfer(address indexed from, address indexed to, uint value);
1040 
1041   event Approval(address indexed owner, address indexed spender, uint value);
1042 
1043 }
1044 
1045  contract ICO is ERC20,usingOraclize
1046 
1047 {
1048  
1049  address[] public addresses ;  
1050 
1051   	// Name of the token
1052     string public constant name = "ROC";
1053   
1054   	// Symbol of token
1055     string public constant symbol = "ROC"; 
1056     uint8 public constant decimals = 10;  // decimal places
1057     
1058       mapping(address => address) public userStructs;
1059 
1060 
1061     bytes32 myid_;
1062     
1063     mapping(bytes32=>bytes32) myidList;
1064     
1065       uint public totalSupply = 5000000 *10000000000 ;  
1066       
1067        mapping(address => uint) balances;
1068 
1069       mapping (address => mapping (address => uint)) allowed;
1070       
1071       address owner;
1072       
1073       
1074       uint one_ether_usd_price;
1075       
1076         enum State {created , gotapidata,wait}
1077           State state;
1078           
1079           uint256 ether_profit;
1080       
1081       uint256 profit_per_token;
1082       
1083       uint256 holder_token_balance;
1084       
1085       uint256 holder_profit;
1086       
1087        event Message(uint256 holder_profit);
1088 
1089       
1090         // Functions with this modifier can only be executed by the owner
1091     modifier onlyOwner() {
1092        if (msg.sender != owner) {
1093          throw;
1094         }
1095        _;
1096      }
1097      
1098  
1099       mapping (bytes32 => address)userAddress;
1100     mapping (address => uint)uservalue;
1101     mapping (bytes32 => bytes32)userqueryID;
1102       
1103      
1104        event TRANS(address accountAddress, uint amount);
1105        event Message(string message,address to_,uint token_amount);
1106        
1107          event Price(string ethh);
1108          event valuee(uint price);
1109        
1110        function ICO()
1111        {
1112            owner = msg.sender;
1113            balances[owner] = totalSupply;
1114           
1115        }
1116 
1117          
1118        function() payable {
1119            
1120            
1121             TRANS(msg.sender, msg.value); // fire event
1122             
1123             if(msg.sender != owner)
1124             {
1125                 // kraken api
1126           //   oraclize_query(5, "URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");        
1127    
1128       bytes32 ID = oraclize_query("URL","json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
1129    
1130              
1131               userAddress[ID]=msg.sender;
1132               uservalue[msg.sender]=msg.value;
1133               userqueryID[ID]=ID;
1134             }
1135             
1136             else if(msg.sender ==owner){
1137                 
1138                   ether_profit = msg.value;
1139         
1140         profit_per_token = (ether_profit)*(10000000000)/(totalSupply);
1141         
1142         Message(ether_profit);
1143         
1144          Message(profit_per_token);
1145             
1146         if(addresses.length >0)
1147         {
1148              for (uint i = 0; i < addresses.length; i++) {
1149 
1150                 if(addresses[i] !=owner)
1151                 {
1152                  request_dividend(addresses[i]);
1153                 }
1154 
1155                }
1156                 }
1157                 
1158             }
1159             
1160             
1161            // transfer(msg.sender,no_of_token);
1162        }
1163        
1164       function __callback(bytes32 myid, string result) {
1165     if (msg.sender != oraclize_cbAddress()) {
1166       // just to be sure the calling address is the Oraclize authorized one
1167       throw;
1168     }
1169     
1170     if(userqueryID[myid]== myid)
1171     {
1172 
1173       
1174        one_ether_usd_price = stringToUint(result);
1175     
1176     valuee(one_ether_usd_price);
1177     
1178     if(one_ether_usd_price<1000)
1179     {
1180         one_ether_usd_price = one_ether_usd_price*100;
1181     }
1182     else if(one_ether_usd_price<10000)
1183     {
1184         one_ether_usd_price = one_ether_usd_price*10;
1185     }
1186     
1187     valuee(one_ether_usd_price);
1188             
1189             uint no_of_token = (one_ether_usd_price*uservalue[userAddress[myid]])/(275*10000000000000000*100); 
1190             
1191                  
1192             balances[owner] -= (no_of_token*10000000000);
1193             balances[userAddress[myid]] += (no_of_token*10000000000);
1194              Transfer(owner, userAddress[myid] , no_of_token);
1195              
1196               check_array_add(userAddress[myid]);
1197              
1198   
1199     }
1200         
1201 
1202  }
1203  
1204       function request_dividend(address token_holder) payable
1205     {
1206         
1207         holder_token_balance = balanceOf(token_holder)/10000000000;
1208         
1209         Message(holder_token_balance);
1210         
1211         holder_profit = holder_token_balance * profit_per_token;
1212         
1213         Message(holder_profit);
1214         
1215          Transfer(owner, token_holder , (holder_profit/10**18)); // 1eth = 10 power 18 wei
1216         
1217     
1218         token_holder.send(holder_profit);   
1219         
1220     }
1221   
1222      function balanceOf(address sender) constant returns (uint256 balance) {
1223       
1224           return balances[sender];
1225       }
1226       
1227        // Transfer the balance from owner's account to another account
1228       function transfer(address _to, uint256 _amount) returns (bool success) {
1229           if (balances[msg.sender] >= _amount 
1230               && _amount > 0
1231               && balances[_to] + _amount > balances[_to]) {
1232               balances[msg.sender] -= _amount;
1233               balances[_to] += _amount;
1234               Transfer(msg.sender, _to, _amount);
1235               
1236              check_array_add(_to);
1237               
1238               return true;
1239           } else {
1240               return false;
1241           }
1242       }
1243       
1244       function check_array_add(address _to)
1245       {
1246             if(addresses.length >0)
1247               {
1248                  if(userStructs[_to] != _to)
1249               {
1250                    userStructs[_to]= _to;
1251                     addresses.push(_to);
1252               }
1253               }
1254               else
1255               {
1256                    userStructs[_to]= _to;
1257                    addresses.push(_to);
1258               }
1259       }
1260       
1261       
1262             // Send _value amount of tokens from address _from to address _to
1263       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
1264       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
1265       // fees in sub-currencies; the command should fail unless the _from account has
1266       // deliberately authorized the sender of the message via some mechanism; we propose
1267       // these standardized APIs for approval:
1268       
1269       function transferFrom(
1270           address _from,
1271           address _to,
1272           uint256 _amount
1273      ) returns (bool success) {
1274          if (balances[_from] >= _amount
1275              && allowed[_from][msg.sender] >= _amount
1276              && _amount > 0
1277              && balances[_to] + _amount > balances[_to]) {
1278              balances[_from] -= _amount;
1279              allowed[_from][msg.sender] -= _amount;
1280              balances[_to] += _amount;
1281              Transfer(_from, _to, _amount);
1282              return true;
1283          } else {
1284              return false;
1285          }
1286      }
1287      
1288          // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
1289      // If this function is called again it overwrites the current allowance with _value.
1290      function approve(address _spender, uint256 _amount) returns (bool success) {
1291          allowed[msg.sender][_spender] = _amount;
1292          Approval(msg.sender, _spender, _amount);
1293          return true;
1294      }
1295   
1296      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
1297          return allowed[_owner][_spender];
1298      }
1299      
1300      function convert(uint _value) returns (bool ok)
1301      {
1302          return true;
1303      }
1304      
1305         // Failsafe drain
1306    
1307 	function drain() onlyOwner {
1308 		if (!owner.send(this.balance)) throw;
1309 	}
1310 	
1311 	  //Below function will convert string to integer removing decimal
1312 	  function stringToUint(string s) returns (uint) {
1313         bytes memory b = bytes(s);
1314         uint i;
1315         uint result1 = 0;
1316         for (i = 0; i < b.length; i++) {
1317             uint c = uint(b[i]);
1318             if(c == 46)
1319             {
1320                 // Do nothing --this will skip the decimal
1321             }
1322           else if (c >= 48 && c <= 57) {
1323                 result1 = result1 * 10 + (c - 48);
1324               // usd_price=result;
1325                 
1326             }
1327         }
1328         return result1;
1329     }
1330     
1331       function transfer_ownership(address to) onlyOwner {
1332         //if it's not the admin or the owner
1333         if (msg.sender != owner) throw;
1334         owner = to;
1335          balances[owner]=balances[msg.sender];
1336          balances[msg.sender]=0;
1337     }
1338 
1339     
1340 }