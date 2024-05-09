1 pragma solidity ^0.4.24;
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
864     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
865         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
866         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
867         
868         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
869         if (proofVerified == false) return 2;
870         
871         return 0;
872     }
873     
874     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
875         bool match_ = true;
876         
877         for (var i=0; i<prefix.length; i++){
878             if (content[i] != prefix[i]) match_ = false;
879         }
880         
881         return match_;
882     }
883 
884     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
885         bool checkok;
886         
887         
888         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
889         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
890         bytes memory keyhash = new bytes(32);
891         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
892         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
893         if (checkok == false) return false;
894         
895         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
896         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
897         
898         
899         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
900         checkok = matchBytes32Prefix(sha256(sig1), result);
901         if (checkok == false) return false;
902         
903         
904         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
905         // This is to verify that the computed args match with the ones specified in the query.
906         bytes memory commitmentSlice1 = new bytes(8+1+32);
907         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
908         
909         bytes memory sessionPubkey = new bytes(64);
910         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
911         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
912         
913         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
914         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
915             delete oraclize_randomDS_args[queryId];
916         } else return false;
917         
918         
919         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
920         bytes memory tosign1 = new bytes(32+8+1+32);
921         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
922         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
923         if (checkok == false) return false;
924         
925         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
926         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
927             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
928         }
929         
930         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
931     }
932 
933     
934     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
935     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
936         uint minLength = length + toOffset;
937 
938         if (to.length < minLength) {
939             // Buffer too small
940             throw; // Should be a better way?
941         }
942 
943         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
944         uint i = 32 + fromOffset;
945         uint j = 32 + toOffset;
946 
947         while (i < (32 + fromOffset + length)) {
948             assembly {
949                 let tmp := mload(add(from, i))
950                 mstore(add(to, j), tmp)
951             }
952             i += 32;
953             j += 32;
954         }
955 
956         return to;
957     }
958     
959     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
960     // Duplicate Solidity's ecrecover, but catching the CALL return value
961     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
962         // We do our own memory management here. Solidity uses memory offset
963         // 0x40 to store the current end of memory. We write past it (as
964         // writes are memory extensions), but don't update the offset so
965         // Solidity will reuse it. The memory used here is only needed for
966         // this context.
967 
968         // FIXME: inline assembly can't access return values
969         bool ret;
970         address addr;
971 
972         assembly {
973             let size := mload(0x40)
974             mstore(size, hash)
975             mstore(add(size, 32), v)
976             mstore(add(size, 64), r)
977             mstore(add(size, 96), s)
978 
979             // NOTE: we can reuse the request memory because we deal with
980             //       the return code
981             ret := call(3000, 1, 0, size, 128, size, 32)
982             addr := mload(size)
983         }
984   
985         return (ret, addr);
986     }
987 
988     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
989     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
990         bytes32 r;
991         bytes32 s;
992         uint8 v;
993 
994         if (sig.length != 65)
995           return (false, 0);
996 
997         // The signature format is a compact form of:
998         //   {bytes32 r}{bytes32 s}{uint8 v}
999         // Compact means, uint8 is not padded to 32 bytes.
1000         assembly {
1001             r := mload(add(sig, 32))
1002             s := mload(add(sig, 64))
1003 
1004             // Here we are loading the last 32 bytes. We exploit the fact that
1005             // 'mload' will pad with zeroes if we overread.
1006             // There is no 'mload8' to do this, but that would be nicer.
1007             v := byte(0, mload(add(sig, 96)))
1008 
1009             // Alternative solution:
1010             // 'byte' is not working due to the Solidity parser, so lets
1011             // use the second best option, 'and'
1012             // v := and(mload(add(sig, 65)), 255)
1013         }
1014 
1015         // albeit non-transactional signatures are not specified by the YP, one would expect it
1016         // to match the YP range of [27, 28]
1017         //
1018         // geth uses [0, 1] and some clients have followed. This might change, see:
1019         //  https://github.com/ethereum/go-ethereum/issues/2053
1020         if (v < 27)
1021           v += 27;
1022 
1023         if (v != 27 && v != 28)
1024             return (false, 0);
1025 
1026         return safer_ecrecover(hash, v, r, s);
1027     }
1028         
1029 }
1030 // </ORACLIZE_API>
1031 
1032 /*
1033  * @title String & slice utility library for Solidity contracts.
1034  * @author Nick Johnson <arachnid@notdot.net>
1035  *
1036  * @dev Functionality in this library is largely implemented using an
1037  *      abstraction called a 'slice'. A slice represents a part of a string -
1038  *      anything from the entire string to a single character, or even no
1039  *      characters at all (a 0-length slice). Since a slice only has to specify
1040  *      an offset and a length, copying and manipulating slices is a lot less
1041  *      expensive than copying and manipulating the strings they reference.
1042  *
1043  *      To further reduce gas costs, most functions on slice that need to return
1044  *      a slice modify the original one instead of allocating a new one; for
1045  *      instance, `s.split(".")` will return the text up to the first '.',
1046  *      modifying s to only contain the remainder of the string after the '.'.
1047  *      In situations where you do not want to modify the original slice, you
1048  *      can make a copy first with `.copy()`, for example:
1049  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1050  *      Solidity has no memory management, it will result in allocating many
1051  *      short-lived slices that are later discarded.
1052  *
1053  *      Functions that return two slices come in two versions: a non-allocating
1054  *      version that takes the second slice as an argument, modifying it in
1055  *      place, and an allocating version that allocates and returns the second
1056  *      slice; see `nextRune` for example.
1057  *
1058  *      Functions that have to copy string data will return strings rather than
1059  *      slices; these can be cast back to slices for further processing if
1060  *      required.
1061  *
1062  *      For convenience, some functions are provided with non-modifying
1063  *      variants that create a new slice and return both; for instance,
1064  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1065  *      corresponding to the left and right parts of the string.
1066  */
1067 library strings {
1068     struct slice {
1069         uint _len;
1070         uint _ptr;
1071     }
1072 
1073     function memcpy(uint dest, uint src, uint len) private {
1074         // Copy word-length chunks while possible
1075         for(; len >= 32; len -= 32) {
1076             assembly {
1077                 mstore(dest, mload(src))
1078             }
1079             dest += 32;
1080             src += 32;
1081         }
1082 
1083         // Copy remaining bytes
1084         uint mask = 256 ** (32 - len) - 1;
1085         assembly {
1086             let srcpart := and(mload(src), not(mask))
1087             let destpart := and(mload(dest), mask)
1088             mstore(dest, or(destpart, srcpart))
1089         }
1090     }
1091 
1092     /*
1093      * @dev Returns a slice containing the entire string.
1094      * @param self The string to make a slice from.
1095      * @return A newly allocated slice containing the entire string.
1096      */
1097     function toSlice(string self) internal returns (slice) {
1098         uint ptr;
1099         assembly {
1100             ptr := add(self, 0x20)
1101         }
1102         return slice(bytes(self).length, ptr);
1103     }
1104 
1105     /*
1106      * @dev Returns the length of a null-terminated bytes32 string.
1107      * @param self The value to find the length of.
1108      * @return The length of the string, from 0 to 32.
1109      */
1110     function len(bytes32 self) internal returns (uint) {
1111         uint ret;
1112         if (self == 0)
1113             return 0;
1114         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1115             ret += 16;
1116             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1117         }
1118         if (self & 0xffffffffffffffff == 0) {
1119             ret += 8;
1120             self = bytes32(uint(self) / 0x10000000000000000);
1121         }
1122         if (self & 0xffffffff == 0) {
1123             ret += 4;
1124             self = bytes32(uint(self) / 0x100000000);
1125         }
1126         if (self & 0xffff == 0) {
1127             ret += 2;
1128             self = bytes32(uint(self) / 0x10000);
1129         }
1130         if (self & 0xff == 0) {
1131             ret += 1;
1132         }
1133         return 32 - ret;
1134     }
1135 
1136     /*
1137      * @dev Returns a slice containing the entire bytes32, interpreted as a
1138      *      null-termintaed utf-8 string.
1139      * @param self The bytes32 value to convert to a slice.
1140      * @return A new slice containing the value of the input argument up to the
1141      *         first null.
1142      */
1143     function toSliceB32(bytes32 self) internal returns (slice ret) {
1144         // Allocate space for `self` in memory, copy it there, and point ret at it
1145         assembly {
1146             let ptr := mload(0x40)
1147             mstore(0x40, add(ptr, 0x20))
1148             mstore(ptr, self)
1149             mstore(add(ret, 0x20), ptr)
1150         }
1151         ret._len = len(self);
1152     }
1153 
1154     /*
1155      * @dev Returns a new slice containing the same data as the current slice.
1156      * @param self The slice to copy.
1157      * @return A new slice containing the same data as `self`.
1158      */
1159     function copy(slice self) internal returns (slice) {
1160         return slice(self._len, self._ptr);
1161     }
1162 
1163     /*
1164      * @dev Copies a slice to a new string.
1165      * @param self The slice to copy.
1166      * @return A newly allocated string containing the slice's text.
1167      */
1168     function toString(slice self) internal returns (string) {
1169         var ret = new string(self._len);
1170         uint retptr;
1171         assembly { retptr := add(ret, 32) }
1172 
1173         memcpy(retptr, self._ptr, self._len);
1174         return ret;
1175     }
1176 
1177     /*
1178      * @dev Returns the length in runes of the slice. Note that this operation
1179      *      takes time proportional to the length of the slice; avoid using it
1180      *      in loops, and call `slice.empty()` if you only need to know whether
1181      *      the slice is empty or not.
1182      * @param self The slice to operate on.
1183      * @return The length of the slice in runes.
1184      */
1185     function len(slice self) internal returns (uint) {
1186         // Starting at ptr-31 means the LSB will be the byte we care about
1187         var ptr = self._ptr - 31;
1188         var end = ptr + self._len;
1189         for (uint len = 0; ptr < end; len++) {
1190             uint8 b;
1191             assembly { b := and(mload(ptr), 0xFF) }
1192             if (b < 0x80) {
1193                 ptr += 1;
1194             } else if(b < 0xE0) {
1195                 ptr += 2;
1196             } else if(b < 0xF0) {
1197                 ptr += 3;
1198             } else if(b < 0xF8) {
1199                 ptr += 4;
1200             } else if(b < 0xFC) {
1201                 ptr += 5;
1202             } else {
1203                 ptr += 6;
1204             }
1205         }
1206         return len;
1207     }
1208 
1209     /*
1210      * @dev Returns true if the slice is empty (has a length of 0).
1211      * @param self The slice to operate on.
1212      * @return True if the slice is empty, False otherwise.
1213      */
1214     function empty(slice self) internal returns (bool) {
1215         return self._len == 0;
1216     }
1217 
1218     /*
1219      * @dev Returns a positive number if `other` comes lexicographically after
1220      *      `self`, a negative number if it comes before, or zero if the
1221      *      contents of the two slices are equal. Comparison is done per-rune,
1222      *      on unicode codepoints.
1223      * @param self The first slice to compare.
1224      * @param other The second slice to compare.
1225      * @return The result of the comparison.
1226      */
1227     function compare(slice self, slice other) internal returns (int) {
1228         uint shortest = self._len;
1229         if (other._len < self._len)
1230             shortest = other._len;
1231 
1232         var selfptr = self._ptr;
1233         var otherptr = other._ptr;
1234         for (uint idx = 0; idx < shortest; idx += 32) {
1235             uint a;
1236             uint b;
1237             assembly {
1238                 a := mload(selfptr)
1239                 b := mload(otherptr)
1240             }
1241             if (a != b) {
1242                 // Mask out irrelevant bytes and check again
1243                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1244                 var diff = (a & mask) - (b & mask);
1245                 if (diff != 0)
1246                     return int(diff);
1247             }
1248             selfptr += 32;
1249             otherptr += 32;
1250         }
1251         return int(self._len) - int(other._len);
1252     }
1253 
1254     /*
1255      * @dev Returns true if the two slices contain the same text.
1256      * @param self The first slice to compare.
1257      * @param self The second slice to compare.
1258      * @return True if the slices are equal, false otherwise.
1259      */
1260     function equals(slice self, slice other) internal returns (bool) {
1261         return compare(self, other) == 0;
1262     }
1263 
1264     /*
1265      * @dev Extracts the first rune in the slice into `rune`, advancing the
1266      *      slice to point to the next rune and returning `self`.
1267      * @param self The slice to operate on.
1268      * @param rune The slice that will contain the first rune.
1269      * @return `rune`.
1270      */
1271     function nextRune(slice self, slice rune) internal returns (slice) {
1272         rune._ptr = self._ptr;
1273 
1274         if (self._len == 0) {
1275             rune._len = 0;
1276             return rune;
1277         }
1278 
1279         uint len;
1280         uint b;
1281         // Load the first byte of the rune into the LSBs of b
1282         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1283         if (b < 0x80) {
1284             len = 1;
1285         } else if(b < 0xE0) {
1286             len = 2;
1287         } else if(b < 0xF0) {
1288             len = 3;
1289         } else {
1290             len = 4;
1291         }
1292 
1293         // Check for truncated codepoints
1294         if (len > self._len) {
1295             rune._len = self._len;
1296             self._ptr += self._len;
1297             self._len = 0;
1298             return rune;
1299         }
1300 
1301         self._ptr += len;
1302         self._len -= len;
1303         rune._len = len;
1304         return rune;
1305     }
1306 
1307     /*
1308      * @dev Returns the first rune in the slice, advancing the slice to point
1309      *      to the next rune.
1310      * @param self The slice to operate on.
1311      * @return A slice containing only the first rune from `self`.
1312      */
1313     function nextRune(slice self) internal returns (slice ret) {
1314         nextRune(self, ret);
1315     }
1316 
1317     /*
1318      * @dev Returns the number of the first codepoint in the slice.
1319      * @param self The slice to operate on.
1320      * @return The number of the first codepoint in the slice.
1321      */
1322     function ord(slice self) internal returns (uint ret) {
1323         if (self._len == 0) {
1324             return 0;
1325         }
1326 
1327         uint word;
1328         uint len;
1329         uint div = 2 ** 248;
1330 
1331         // Load the rune into the MSBs of b
1332         assembly { word:= mload(mload(add(self, 32))) }
1333         var b = word / div;
1334         if (b < 0x80) {
1335             ret = b;
1336             len = 1;
1337         } else if(b < 0xE0) {
1338             ret = b & 0x1F;
1339             len = 2;
1340         } else if(b < 0xF0) {
1341             ret = b & 0x0F;
1342             len = 3;
1343         } else {
1344             ret = b & 0x07;
1345             len = 4;
1346         }
1347 
1348         // Check for truncated codepoints
1349         if (len > self._len) {
1350             return 0;
1351         }
1352 
1353         for (uint i = 1; i < len; i++) {
1354             div = div / 256;
1355             b = (word / div) & 0xFF;
1356             if (b & 0xC0 != 0x80) {
1357                 // Invalid UTF-8 sequence
1358                 return 0;
1359             }
1360             ret = (ret * 64) | (b & 0x3F);
1361         }
1362 
1363         return ret;
1364     }
1365 
1366     /*
1367      * @dev Returns the keccak-256 hash of the slice.
1368      * @param self The slice to hash.
1369      * @return The hash of the slice.
1370      */
1371     function keccak(slice self) internal returns (bytes32 ret) {
1372         assembly {
1373             ret := sha3(mload(add(self, 32)), mload(self))
1374         }
1375     }
1376 
1377     /*
1378      * @dev Returns true if `self` starts with `needle`.
1379      * @param self The slice to operate on.
1380      * @param needle The slice to search for.
1381      * @return True if the slice starts with the provided text, false otherwise.
1382      */
1383     function startsWith(slice self, slice needle) internal returns (bool) {
1384         if (self._len < needle._len) {
1385             return false;
1386         }
1387 
1388         if (self._ptr == needle._ptr) {
1389             return true;
1390         }
1391 
1392         bool equal;
1393         assembly {
1394             let len := mload(needle)
1395             let selfptr := mload(add(self, 0x20))
1396             let needleptr := mload(add(needle, 0x20))
1397             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1398         }
1399         return equal;
1400     }
1401 
1402     /*
1403      * @dev If `self` starts with `needle`, `needle` is removed from the
1404      *      beginning of `self`. Otherwise, `self` is unmodified.
1405      * @param self The slice to operate on.
1406      * @param needle The slice to search for.
1407      * @return `self`
1408      */
1409     function beyond(slice self, slice needle) internal returns (slice) {
1410         if (self._len < needle._len) {
1411             return self;
1412         }
1413 
1414         bool equal = true;
1415         if (self._ptr != needle._ptr) {
1416             assembly {
1417                 let len := mload(needle)
1418                 let selfptr := mload(add(self, 0x20))
1419                 let needleptr := mload(add(needle, 0x20))
1420                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1421             }
1422         }
1423 
1424         if (equal) {
1425             self._len -= needle._len;
1426             self._ptr += needle._len;
1427         }
1428 
1429         return self;
1430     }
1431 
1432     /*
1433      * @dev Returns true if the slice ends with `needle`.
1434      * @param self The slice to operate on.
1435      * @param needle The slice to search for.
1436      * @return True if the slice starts with the provided text, false otherwise.
1437      */
1438     function endsWith(slice self, slice needle) internal returns (bool) {
1439         if (self._len < needle._len) {
1440             return false;
1441         }
1442 
1443         var selfptr = self._ptr + self._len - needle._len;
1444 
1445         if (selfptr == needle._ptr) {
1446             return true;
1447         }
1448 
1449         bool equal;
1450         assembly {
1451             let len := mload(needle)
1452             let needleptr := mload(add(needle, 0x20))
1453             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1454         }
1455 
1456         return equal;
1457     }
1458 
1459     /*
1460      * @dev If `self` ends with `needle`, `needle` is removed from the
1461      *      end of `self`. Otherwise, `self` is unmodified.
1462      * @param self The slice to operate on.
1463      * @param needle The slice to search for.
1464      * @return `self`
1465      */
1466     function until(slice self, slice needle) internal returns (slice) {
1467         if (self._len < needle._len) {
1468             return self;
1469         }
1470 
1471         var selfptr = self._ptr + self._len - needle._len;
1472         bool equal = true;
1473         if (selfptr != needle._ptr) {
1474             assembly {
1475                 let len := mload(needle)
1476                 let needleptr := mload(add(needle, 0x20))
1477                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1478             }
1479         }
1480 
1481         if (equal) {
1482             self._len -= needle._len;
1483         }
1484 
1485         return self;
1486     }
1487 
1488     // Returns the memory address of the first byte of the first occurrence of
1489     // `needle` in `self`, or the first byte after `self` if not found.
1490     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1491         uint ptr;
1492         uint idx;
1493 
1494         if (needlelen <= selflen) {
1495             if (needlelen <= 32) {
1496                 // Optimized assembly for 68 gas per byte on short strings
1497                 assembly {
1498                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1499                     let needledata := and(mload(needleptr), mask)
1500                     let end := add(selfptr, sub(selflen, needlelen))
1501                     ptr := selfptr
1502                     loop:
1503                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1504                     ptr := add(ptr, 1)
1505                     jumpi(loop, lt(sub(ptr, 1), end))
1506                     ptr := add(selfptr, selflen)
1507                     exit:
1508                 }
1509                 return ptr;
1510             } else {
1511                 // For long needles, use hashing
1512                 bytes32 hash;
1513                 assembly { hash := sha3(needleptr, needlelen) }
1514                 ptr = selfptr;
1515                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1516                     bytes32 testHash;
1517                     assembly { testHash := sha3(ptr, needlelen) }
1518                     if (hash == testHash)
1519                         return ptr;
1520                     ptr += 1;
1521                 }
1522             }
1523         }
1524         return selfptr + selflen;
1525     }
1526 
1527     // Returns the memory address of the first byte after the last occurrence of
1528     // `needle` in `self`, or the address of `self` if not found.
1529     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1530         uint ptr;
1531 
1532         if (needlelen <= selflen) {
1533             if (needlelen <= 32) {
1534                 // Optimized assembly for 69 gas per byte on short strings
1535                 assembly {
1536                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1537                     let needledata := and(mload(needleptr), mask)
1538                     ptr := add(selfptr, sub(selflen, needlelen))
1539                     loop:
1540                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1541                     ptr := sub(ptr, 1)
1542                     jumpi(loop, gt(add(ptr, 1), selfptr))
1543                     ptr := selfptr
1544                     jump(exit)
1545                     ret:
1546                     ptr := add(ptr, needlelen)
1547                     exit:
1548                 }
1549                 return ptr;
1550             } else {
1551                 // For long needles, use hashing
1552                 bytes32 hash;
1553                 assembly { hash := sha3(needleptr, needlelen) }
1554                 ptr = selfptr + (selflen - needlelen);
1555                 while (ptr >= selfptr) {
1556                     bytes32 testHash;
1557                     assembly { testHash := sha3(ptr, needlelen) }
1558                     if (hash == testHash)
1559                         return ptr + needlelen;
1560                     ptr -= 1;
1561                 }
1562             }
1563         }
1564         return selfptr;
1565     }
1566 
1567     /*
1568      * @dev Modifies `self` to contain everything from the first occurrence of
1569      *      `needle` to the end of the slice. `self` is set to the empty slice
1570      *      if `needle` is not found.
1571      * @param self The slice to search and modify.
1572      * @param needle The text to search for.
1573      * @return `self`.
1574      */
1575     function find(slice self, slice needle) internal returns (slice) {
1576         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1577         self._len -= ptr - self._ptr;
1578         self._ptr = ptr;
1579         return self;
1580     }
1581 
1582     /*
1583      * @dev Modifies `self` to contain the part of the string from the start of
1584      *      `self` to the end of the first occurrence of `needle`. If `needle`
1585      *      is not found, `self` is set to the empty slice.
1586      * @param self The slice to search and modify.
1587      * @param needle The text to search for.
1588      * @return `self`.
1589      */
1590     function rfind(slice self, slice needle) internal returns (slice) {
1591         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1592         self._len = ptr - self._ptr;
1593         return self;
1594     }
1595 
1596     /*
1597      * @dev Splits the slice, setting `self` to everything after the first
1598      *      occurrence of `needle`, and `token` to everything before it. If
1599      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1600      *      and `token` is set to the entirety of `self`.
1601      * @param self The slice to split.
1602      * @param needle The text to search for in `self`.
1603      * @param token An output parameter to which the first token is written.
1604      * @return `token`.
1605      */
1606     function split(slice self, slice needle, slice token) internal returns (slice) {
1607         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1608         token._ptr = self._ptr;
1609         token._len = ptr - self._ptr;
1610         if (ptr == self._ptr + self._len) {
1611             // Not found
1612             self._len = 0;
1613         } else {
1614             self._len -= token._len + needle._len;
1615             self._ptr = ptr + needle._len;
1616         }
1617         return token;
1618     }
1619 
1620     /*
1621      * @dev Splits the slice, setting `self` to everything after the first
1622      *      occurrence of `needle`, and returning everything before it. If
1623      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1624      *      and the entirety of `self` is returned.
1625      * @param self The slice to split.
1626      * @param needle The text to search for in `self`.
1627      * @return The part of `self` up to the first occurrence of `delim`.
1628      */
1629     function split(slice self, slice needle) internal returns (slice token) {
1630         split(self, needle, token);
1631     }
1632 
1633     /*
1634      * @dev Splits the slice, setting `self` to everything before the last
1635      *      occurrence of `needle`, and `token` to everything after it. If
1636      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1637      *      and `token` is set to the entirety of `self`.
1638      * @param self The slice to split.
1639      * @param needle The text to search for in `self`.
1640      * @param token An output parameter to which the first token is written.
1641      * @return `token`.
1642      */
1643     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1644         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1645         token._ptr = ptr;
1646         token._len = self._len - (ptr - self._ptr);
1647         if (ptr == self._ptr) {
1648             // Not found
1649             self._len = 0;
1650         } else {
1651             self._len -= token._len + needle._len;
1652         }
1653         return token;
1654     }
1655 
1656     /*
1657      * @dev Splits the slice, setting `self` to everything before the last
1658      *      occurrence of `needle`, and returning everything after it. If
1659      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1660      *      and the entirety of `self` is returned.
1661      * @param self The slice to split.
1662      * @param needle The text to search for in `self`.
1663      * @return The part of `self` after the last occurrence of `delim`.
1664      */
1665     function rsplit(slice self, slice needle) internal returns (slice token) {
1666         rsplit(self, needle, token);
1667     }
1668 
1669     /*
1670      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1671      * @param self The slice to search.
1672      * @param needle The text to search for in `self`.
1673      * @return The number of occurrences of `needle` found in `self`.
1674      */
1675     function count(slice self, slice needle) internal returns (uint count) {
1676         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1677         while (ptr <= self._ptr + self._len) {
1678             count++;
1679             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1680         }
1681     }
1682 
1683     /*
1684      * @dev Returns True if `self` contains `needle`.
1685      * @param self The slice to search.
1686      * @param needle The text to search for in `self`.
1687      * @return True if `needle` is found in `self`, false otherwise.
1688      */
1689     function contains(slice self, slice needle) internal returns (bool) {
1690         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1691     }
1692 
1693     /*
1694      * @dev Returns a newly allocated string containing the concatenation of
1695      *      `self` and `other`.
1696      * @param self The first slice to concatenate.
1697      * @param other The second slice to concatenate.
1698      * @return The concatenation of the two strings.
1699      */
1700     function concat(slice self, slice other) internal returns (string) {
1701         var ret = new string(self._len + other._len);
1702         uint retptr;
1703         assembly { retptr := add(ret, 32) }
1704         memcpy(retptr, self._ptr, self._len);
1705         memcpy(retptr + self._len, other._ptr, other._len);
1706         return ret;
1707     }
1708 
1709     /*
1710      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1711      *      newly allocated string.
1712      * @param self The delimiter to use.
1713      * @param parts A list of slices to join.
1714      * @return A newly allocated string containing all the slices in `parts`,
1715      *         joined with `self`.
1716      */
1717     function join(slice self, slice[] parts) internal returns (string) {
1718         if (parts.length == 0)
1719             return "";
1720 
1721         uint len = self._len * (parts.length - 1);
1722         for(uint i = 0; i < parts.length; i++)
1723             len += parts[i]._len;
1724 
1725         var ret = new string(len);
1726         uint retptr;
1727         assembly { retptr := add(ret, 32) }
1728 
1729         for(i = 0; i < parts.length; i++) {
1730             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1731             retptr += parts[i]._len;
1732             if (i < parts.length - 1) {
1733                 memcpy(retptr, self._ptr, self._len);
1734                 retptr += self._len;
1735             }
1736         }
1737 
1738         return ret;
1739     }
1740 }
1741 
1742 
1743 contract DSSafeAddSub {
1744     function safeToAdd(uint a, uint b) internal returns (bool) {
1745         return (a + b >= a);
1746     }
1747     function safeAdd(uint a, uint b) internal returns (uint) {
1748         if (!safeToAdd(a, b)) throw;
1749         return a + b;
1750     }
1751 
1752     function safeToSubtract(uint a, uint b) internal returns (bool) {
1753         return (b <= a);
1754     }
1755 
1756     function safeSub(uint a, uint b) internal returns (uint) {
1757         if (!safeToSubtract(a, b)) throw;
1758         return a - b;
1759     } 
1760 }
1761 
1762 
1763 
1764 contract Etheroll is usingOraclize, DSSafeAddSub {
1765     
1766      using strings for *;
1767 
1768     /*
1769      * checks player profit, bet size and player number is within range
1770     */
1771     modifier betIsValid(uint _betSize, uint _playerNumber) {      
1772         if(((((_betSize * (100-(safeSub(_playerNumber,1)))) / (safeSub(_playerNumber,1))+_betSize))*houseEdge/houseEdgeDivisor)-_betSize > maxProfit || _betSize < minBet || _playerNumber < minNumber || _playerNumber > maxNumber) throw;        
1773 		_;
1774     }
1775 
1776     /*
1777      * checks game is currently active
1778     */
1779     modifier gameIsActive {
1780         if(gamePaused == true) throw;
1781 		_;
1782     }    
1783 
1784     /*
1785      * checks payouts are currently active
1786     */
1787     modifier payoutsAreActive {
1788         if(payoutsPaused == true) throw;
1789 		_;
1790     }    
1791 
1792     /*
1793      * checks only Oraclize address is calling
1794     */
1795     modifier onlyOraclize {
1796         if (msg.sender != oraclize_cbAddress()) throw;
1797         _;
1798     }
1799 
1800     /*
1801      * checks only owner address is calling
1802     */
1803     modifier onlyOwner {
1804          if (msg.sender != owner) throw;
1805          _;
1806     }
1807 
1808     /*
1809      * checks only treasury address is calling
1810     */
1811     modifier onlyTreasury {
1812          if (msg.sender != treasury) throw;
1813          _;
1814     }    
1815 
1816     /*
1817      * game vars
1818     */ 
1819     uint constant public maxProfitDivisor = 1000000;
1820     uint constant public houseEdgeDivisor = 1000;    
1821     uint constant public maxNumber = 99; 
1822     uint constant public minNumber = 2;
1823 	bool public gamePaused;
1824     uint32 public gasForOraclize;
1825     address public owner;
1826     bool public payoutsPaused; 
1827     address public treasury;
1828     uint public contractBalance;
1829     uint public houseEdge;     
1830     uint public maxProfit;   
1831     uint public maxProfitAsPercentOfHouse;                    
1832     uint public minBet; 
1833     //init discontinued contract data   
1834     uint public totalBets = 362934;
1835     uint public maxPendingPayouts;
1836     //init discontinued contract data 
1837     uint public totalWeiWon = 149384935590234707322323;
1838     //init discontinued contract data    
1839     uint public totalWeiWagered = 404219360930425835446289; 
1840     //init discontinued contract data        
1841     uint public randomQueryID = 2;
1842     
1843 
1844     /*
1845      * player vars
1846     */
1847     mapping (bytes32 => address) playerAddress;
1848     mapping (bytes32 => address) playerTempAddress;
1849     mapping (bytes32 => bytes32) playerBetId;
1850     mapping (bytes32 => uint) playerBetValue;
1851     mapping (bytes32 => uint) playerTempBetValue;               
1852     mapping (bytes32 => uint) playerDieResult;
1853     mapping (bytes32 => uint) playerNumber;
1854     mapping (address => uint) playerPendingWithdrawals;      
1855     mapping (bytes32 => uint) playerProfit;
1856     mapping (bytes32 => uint) playerTempReward;           
1857 
1858     /*
1859      * events
1860     */
1861     /* log bets + output to web3 for precise 'payout on win' field in UI */
1862     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RewardValue, uint ProfitValue, uint BetValue, uint PlayerNumber, uint RandomQueryID);      
1863     /* output to web3 UI on bet result*/
1864     /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
1865 	event LogResult(uint indexed ResultSerialNumber, bytes32 indexed BetID, address indexed PlayerAddress, uint PlayerNumber, uint DiceResult, uint Value, int Status, bytes Proof);   
1866     /* log manual refunds */
1867     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
1868     /* log owner transfers */
1869     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);               
1870 
1871 
1872     /*
1873      * init
1874     */
1875     function Etheroll() {
1876 
1877         owner = msg.sender;
1878         treasury = msg.sender;
1879         oraclize_setNetwork(networkID_auto);        
1880         /* use TLSNotary for oraclize call */
1881         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1882         /* init 990 = 99% (1% houseEdge)*/
1883         ownerSetHouseEdge(990);
1884         /* init 10,000 = 1%  */
1885         ownerSetMaxProfitAsPercentOfHouse(10000);
1886         /* init min bet (0.1 ether) */
1887         ownerSetMinBet(100000000000000000);        
1888         /* init gas for oraclize */        
1889         gasForOraclize = 235000;  
1890         /* init gas price for callback (default 20 gwei)*/
1891         oraclize_setCustomGasPrice(20000000000 wei);              
1892 
1893     }
1894 
1895     /*
1896      * public function
1897      * player submit bet
1898      * only if game is active & bet is valid can query oraclize and set player vars     
1899     */
1900     function playerRollDice(uint rollUnder) public 
1901         payable
1902         gameIsActive
1903         betIsValid(msg.value, rollUnder)
1904 	{       
1905 
1906         /*
1907         * assign partially encrypted query to oraclize
1908         * only the apiKey is encrypted 
1909         * integer query is in plain text
1910         */       
1911         randomQueryID += 1;
1912         string memory queryString1 = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BBMyVwxtiTy5oKVkRGwW2Yc094lpQyT74AdenJ1jywmN4rNyxXqidtDsDBPlASVWPJ0t8SwjSYjJvHAGS83Si8sYCxNH0y2kl/Vw5CizdcgUax1NtTdFs1MXXdvLYgkFq3h8b2qV2oEvxVFqL7v28lcGzOuy5Ms=},\"n\":1,\"min\":1,\"max\":100,\"replacement\":true,\"base\":10${[identity] \"}\"},\"id\":";
1913         string memory queryString2 = uint2str(randomQueryID);
1914         string memory queryString3 = "${[identity] \"}\"}']";
1915 
1916         string memory queryString1_2 = queryString1.toSlice().concat(queryString2.toSlice());
1917 
1918         string memory queryString1_2_3 = queryString1_2.toSlice().concat(queryString3.toSlice());
1919 
1920         bytes32 rngId = oraclize_query("nested", queryString1_2_3, gasForOraclize);   
1921                  
1922         /* map bet id to this oraclize query */
1923 		playerBetId[rngId] = rngId;
1924         /* map player lucky number to this oraclize query */
1925 		playerNumber[rngId] = rollUnder;
1926         /* map value of wager to this oraclize query */
1927         playerBetValue[rngId] = msg.value;
1928         /* map player address to this oraclize query */
1929         playerAddress[rngId] = msg.sender;
1930         /* safely map player profit to this oraclize query */                     
1931         playerProfit[rngId] = ((((msg.value * (100-(safeSub(rollUnder,1)))) / (safeSub(rollUnder,1))+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;        
1932         /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
1933         maxPendingPayouts = safeAdd(maxPendingPayouts, playerProfit[rngId]);
1934         /* check contract can payout on win */
1935         if(maxPendingPayouts >= contractBalance) throw;
1936         /* provides accurate numbers for web3 and allows for manual refunds in case of no oraclize __callback */
1937         LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId], randomQueryID);          
1938 
1939     }   
1940              
1941 
1942     /*
1943     * semi-public function - only oraclize can call
1944     */
1945     /*TLSNotary for oraclize call */
1946 	function __callback(bytes32 myid, string result, bytes proof) public   
1947 		onlyOraclize
1948 		payoutsAreActive
1949 	{  
1950 
1951         /* player address mapped to query id does not exist */
1952         if (playerAddress[myid]==0x0) throw;
1953         
1954         /* keep oraclize honest by retrieving the serialNumber from random.org result */
1955         var sl_result = result.toSlice();        
1956         uint serialNumberOfResult = parseInt(sl_result.split(', '.toSlice()).toString());          
1957 
1958 	    /* map random result to player */
1959         playerDieResult[myid] = parseInt(sl_result.beyond("[".toSlice()).until("]".toSlice()).toString());        
1960         
1961         /* get the playerAddress for this query id */
1962         playerTempAddress[myid] = playerAddress[myid];
1963         /* delete playerAddress for this query id */
1964         delete playerAddress[myid];
1965 
1966         /* map the playerProfit for this query id */
1967         playerTempReward[myid] = playerProfit[myid];
1968         /* set  playerProfit for this query id to 0 */
1969         playerProfit[myid] = 0; 
1970 
1971         /* safely reduce maxPendingPayouts liability */
1972         maxPendingPayouts = safeSub(maxPendingPayouts, playerTempReward[myid]);         
1973 
1974         /* map the playerBetValue for this query id */
1975         playerTempBetValue[myid] = playerBetValue[myid];
1976         /* set  playerBetValue for this query id to 0 */
1977         playerBetValue[myid] = 0; 
1978 
1979         /* total number of bets */
1980         totalBets += 1;
1981 
1982         /* total wagered */
1983         totalWeiWagered += playerTempBetValue[myid];                                                           
1984 
1985         /*
1986         * refund
1987         * if result is 0 result is empty or no proof refund original bet value
1988         * if refund fails save refund value to playerPendingWithdrawals
1989         */
1990         if(playerDieResult[myid] == 0 || bytes(result).length == 0 || bytes(proof).length == 0){                                                     
1991 
1992              LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 3, proof);            
1993 
1994             /*
1995             * send refund - external call to an untrusted contract
1996             * if send fails map refund value to playerPendingWithdrawals[address]
1997             * for withdrawal later via playerWithdrawPendingTransactions
1998             */
1999             if(!playerTempAddress[myid].send(playerTempBetValue[myid])){
2000                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 4, proof);              
2001                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
2002                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempBetValue[myid]);                        
2003             }
2004 
2005             return;
2006         }
2007 
2008         /*
2009         * pay winner
2010         * update contract balance to calculate new max bet
2011         * send reward
2012         * if send of reward fails save value to playerPendingWithdrawals        
2013         */
2014         if(playerDieResult[myid] < playerNumber[myid]){ 
2015 
2016             /* safely reduce contract balance by player profit */
2017             contractBalance = safeSub(contractBalance, playerTempReward[myid]); 
2018 
2019             /* update total wei won */
2020             totalWeiWon = safeAdd(totalWeiWon, playerTempReward[myid]);              
2021 
2022             /* safely calculate payout via profit plus original wager */
2023             playerTempReward[myid] = safeAdd(playerTempReward[myid], playerTempBetValue[myid]); 
2024 
2025             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 1, proof);                            
2026 
2027             /* update maximum profit */
2028             setMaxProfit();
2029             
2030             /*
2031             * send win - external call to an untrusted contract
2032             * if send fails map reward value to playerPendingWithdrawals[address]
2033             * for withdrawal later via playerWithdrawPendingTransactions
2034             */
2035             if(!playerTempAddress[myid].send(playerTempReward[myid])){
2036                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 2, proof);                   
2037                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
2038                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempReward[myid]);                               
2039             }
2040 
2041             return;
2042 
2043         }
2044 
2045         /*
2046         * no win
2047         * send 1 wei to a losing bet
2048         * update contract balance to calculate new max bet
2049         */
2050         if(playerDieResult[myid] >= playerNumber[myid]){
2051 
2052             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 0, proof);                                
2053 
2054             /*  
2055             *  safe adjust contractBalance
2056             *  setMaxProfit
2057             *  send 1 wei to losing bet
2058             */
2059             contractBalance = safeAdd(contractBalance, (playerTempBetValue[myid]-1));                                                                         
2060 
2061             /* update maximum profit */
2062             setMaxProfit(); 
2063 
2064             /*
2065             * send 1 wei - external call to an untrusted contract                  
2066             */
2067             if(!playerTempAddress[myid].send(1)){
2068                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */                
2069                playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], 1);                                
2070             }                                   
2071 
2072             return;
2073 
2074         }
2075 
2076     }
2077     
2078     /*
2079     * public function
2080     * in case of a failed refund or win send
2081     */
2082     function playerWithdrawPendingTransactions() public 
2083         payoutsAreActive
2084         returns (bool)
2085      {
2086         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
2087         playerPendingWithdrawals[msg.sender] = 0;
2088         /* external call to untrusted contract */
2089         if (msg.sender.call.value(withdrawAmount)()) {
2090             return true;
2091         } else {
2092             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
2093             /* player can try to withdraw again later */
2094             playerPendingWithdrawals[msg.sender] = withdrawAmount;
2095             return false;
2096         }
2097     }
2098 
2099     /* check for pending withdrawals  */
2100     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
2101         return playerPendingWithdrawals[addressToCheck];
2102     }
2103 
2104     /*
2105     * internal function
2106     * sets max profit
2107     */
2108     function setMaxProfit() internal {
2109         maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxProfitDivisor;  
2110     }      
2111 
2112     /*
2113     * owner/treasury address only functions
2114     */
2115     function ()
2116         payable
2117         onlyTreasury
2118     {
2119         /* safely update contract balance */
2120         contractBalance = safeAdd(contractBalance, msg.value);        
2121         /* update the maximum profit */
2122         setMaxProfit();
2123     } 
2124 
2125     /* set gas price for oraclize callback */
2126     function ownerSetCallbackGasPrice(uint newCallbackGasPrice) public 
2127 		onlyOwner
2128 	{
2129         oraclize_setCustomGasPrice(newCallbackGasPrice);
2130     }     
2131 
2132     /* set gas limit for oraclize query */
2133     function ownerSetOraclizeSafeGas(uint32 newSafeGasToOraclize) public 
2134 		onlyOwner
2135 	{
2136     	gasForOraclize = newSafeGasToOraclize;
2137     }
2138 
2139     /* only owner adjust contract balance variable (only used for max profit calc) */
2140     function ownerUpdateContractBalance(uint newContractBalanceInWei) public 
2141 		onlyOwner
2142     {        
2143        contractBalance = newContractBalanceInWei;
2144     }    
2145 
2146     /* only owner address can set houseEdge */
2147     function ownerSetHouseEdge(uint newHouseEdge) public 
2148 		onlyOwner
2149     {
2150         houseEdge = newHouseEdge;
2151     }
2152 
2153     /* only owner address can set maxProfitAsPercentOfHouse */
2154     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public 
2155 		onlyOwner
2156     {
2157         /* restrict each bet to a maximum profit of 1% contractBalance */
2158         if(newMaxProfitAsPercent > 10000) throw;
2159         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
2160         setMaxProfit();
2161     }
2162 
2163     /* only owner address can set minBet */
2164     function ownerSetMinBet(uint newMinimumBet) public 
2165 		onlyOwner
2166     {
2167         minBet = newMinimumBet;
2168     }       
2169 
2170     /* only owner address can transfer ether */
2171     function ownerTransferEther(address sendTo, uint amount) public 
2172 		onlyOwner
2173     {        
2174         /* safely update contract balance when sending out funds*/
2175         contractBalance = safeSub(contractBalance, amount);		
2176         /* update max profit */
2177         setMaxProfit();
2178         if(!sendTo.send(amount)) throw;
2179         LogOwnerTransfer(sendTo, amount); 
2180     }
2181 
2182     /* only owner address can do manual refund
2183     * used only if bet placed + oraclize failed to __callback
2184     * filter LogBet by address and/or playerBetId:
2185     * LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
2186     * check the following logs do not exist for playerBetId and/or playerAddress[rngId] before refunding:
2187     * LogResult or LogRefund
2188     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions 
2189     */
2190     function ownerRefundPlayer(bytes32 originalPlayerBetId, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public 
2191 		onlyOwner
2192     {        
2193         /* safely reduce pendingPayouts by playerProfit[rngId] */
2194         maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
2195         /* send refund */
2196         if(!sendTo.send(originalPlayerBetValue)) throw;
2197         /* log refunds */
2198         LogRefund(originalPlayerBetId, sendTo, originalPlayerBetValue);        
2199     }    
2200 
2201     /* only owner address can set emergency pause #1 */
2202     function ownerPauseGame(bool newStatus) public 
2203 		onlyOwner
2204     {
2205 		gamePaused = newStatus;
2206     }
2207 
2208     /* only owner address can set emergency pause #2 */
2209     function ownerPausePayouts(bool newPayoutStatus) public 
2210 		onlyOwner
2211     {
2212 		payoutsPaused = newPayoutStatus;
2213     } 
2214 
2215     /* only owner address can set treasury address */
2216     function ownerSetTreasury(address newTreasury) public 
2217 		onlyOwner
2218 	{
2219         treasury = newTreasury;
2220     }         
2221 
2222     /* only owner address can set owner address */
2223     function ownerChangeOwner(address newOwner) public 
2224 		onlyOwner
2225 	{
2226         owner = newOwner;
2227     }
2228 
2229     /* only owner address can suicide - emergency */
2230     function ownerkill() public 
2231 		onlyOwner
2232 	{
2233 		suicide(owner);
2234 	}    
2235 
2236 
2237 }