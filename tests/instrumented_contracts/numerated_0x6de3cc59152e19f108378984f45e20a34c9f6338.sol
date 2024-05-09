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
31 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
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
874     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
875         bool match_ = true;
876 
877         for (uint256 i=0; i< n_random_bytes; i++) {
878             if (content[i] != prefix[i]) match_ = false;
879         }
880 
881         return match_;
882     }
883 
884     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
885 
886         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
887         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
888         bytes memory keyhash = new bytes(32);
889         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
890         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
891 
892         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
893         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
894 
895         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
896         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
897 
898         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
899         // This is to verify that the computed args match with the ones specified in the query.
900         bytes memory commitmentSlice1 = new bytes(8+1+32);
901         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
902 
903         bytes memory sessionPubkey = new bytes(64);
904         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
905         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
906 
907         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
908         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
909             delete oraclize_randomDS_args[queryId];
910         } else return false;
911 
912 
913         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
914         bytes memory tosign1 = new bytes(32+8+1+32);
915         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
916         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
917 
918         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
919         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
920             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
921         }
922 
923         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
924     }
925 
926 
927     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
928     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
929         uint minLength = length + toOffset;
930 
931         if (to.length < minLength) {
932             // Buffer too small
933             throw; // Should be a better way?
934         }
935 
936         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
937         uint i = 32 + fromOffset;
938         uint j = 32 + toOffset;
939 
940         while (i < (32 + fromOffset + length)) {
941             assembly {
942                 let tmp := mload(add(from, i))
943                 mstore(add(to, j), tmp)
944             }
945             i += 32;
946             j += 32;
947         }
948 
949         return to;
950     }
951 
952     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
953     // Duplicate Solidity's ecrecover, but catching the CALL return value
954     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
955         // We do our own memory management here. Solidity uses memory offset
956         // 0x40 to store the current end of memory. We write past it (as
957         // writes are memory extensions), but don't update the offset so
958         // Solidity will reuse it. The memory used here is only needed for
959         // this context.
960 
961         // FIXME: inline assembly can't access return values
962         bool ret;
963         address addr;
964 
965         assembly {
966             let size := mload(0x40)
967             mstore(size, hash)
968             mstore(add(size, 32), v)
969             mstore(add(size, 64), r)
970             mstore(add(size, 96), s)
971 
972             // NOTE: we can reuse the request memory because we deal with
973             //       the return code
974             ret := call(3000, 1, 0, size, 128, size, 32)
975             addr := mload(size)
976         }
977 
978         return (ret, addr);
979     }
980 
981     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
982     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
983         bytes32 r;
984         bytes32 s;
985         uint8 v;
986 
987         if (sig.length != 65)
988           return (false, 0);
989 
990         // The signature format is a compact form of:
991         //   {bytes32 r}{bytes32 s}{uint8 v}
992         // Compact means, uint8 is not padded to 32 bytes.
993         assembly {
994             r := mload(add(sig, 32))
995             s := mload(add(sig, 64))
996 
997             // Here we are loading the last 32 bytes. We exploit the fact that
998             // 'mload' will pad with zeroes if we overread.
999             // There is no 'mload8' to do this, but that would be nicer.
1000             v := byte(0, mload(add(sig, 96)))
1001 
1002             // Alternative solution:
1003             // 'byte' is not working due to the Solidity parser, so lets
1004             // use the second best option, 'and'
1005             // v := and(mload(add(sig, 65)), 255)
1006         }
1007 
1008         // albeit non-transactional signatures are not specified by the YP, one would expect it
1009         // to match the YP range of [27, 28]
1010         //
1011         // geth uses [0, 1] and some clients have followed. This might change, see:
1012         //  https://github.com/ethereum/go-ethereum/issues/2053
1013         if (v < 27)
1014           v += 27;
1015 
1016         if (v != 27 && v != 28)
1017             return (false, 0);
1018 
1019         return safer_ecrecover(hash, v, r, s);
1020     }
1021 
1022 }
1023 // </ORACLIZE_API>
1024 
1025 
1026 /**
1027  * @title SafeMath
1028  * @dev Math operations with safety checks that throw on error
1029  */
1030 contract SafeMath {
1031 
1032   /**
1033   * @dev Multiplies two numbers, throws on overflow.
1034   */
1035   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1036     if (a == 0) {
1037       return 0;
1038     }
1039     uint256 c = a * b;
1040     assert(c / a == b);
1041     return c;
1042   }
1043 
1044   /**
1045   * @dev Integer division of two numbers, truncating the quotient.
1046   */
1047   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1048     // assert(b > 0); // Solidity automatically throws when dividing by 0
1049     uint256 c = a / b;
1050     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1051     return c;
1052   }
1053 
1054   /**
1055   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1056   */
1057   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1058     assert(b <= a);
1059     return a - b;
1060   }
1061 
1062   /**
1063   * @dev Adds two numbers, throws on overflow.
1064   */
1065   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1066     uint256 c = a + b;
1067     assert(c >= a);
1068     return c;
1069   }
1070 }
1071 
1072 contract EtherSpin is usingOraclize, SafeMath {
1073     address public owner;
1074 
1075     uint public betCount;
1076     uint public minBet;
1077     uint public maxBet;
1078     uint public edgeRange;
1079     uint public payoutMultiplier;
1080     uint public gasLimit;
1081     uint public standardFee;
1082     uint public minimumNumber;
1083     uint public totalPlayerWinnings;
1084     uint public totalHouseWinnings;
1085 
1086     mapping (bytes32 => address) playerAddy;
1087     mapping (bytes32 => uint) playerBetSize;
1088     mapping (bytes32 => bool) playerHiLo;
1089 
1090 
1091     event LogBet(address indexed playerAddy, bool indexed HiLo, uint ActualRNGNumber, uint betSizing, bool WinLossResult);
1092     event LogErr(uint errcode);
1093 
1094     // --- Mods --- //
1095     modifier onlyOwner {
1096          if (msg.sender != owner) throw;
1097          _;
1098     }
1099 
1100     modifier onlyOraclize {
1101         if (msg.sender != oraclize_cbAddress()) throw;
1102         _;
1103     }
1104 
1105     function EtherSpin() {
1106         owner = msg.sender;
1107         oraclize_setProof(proofType_Ledger);
1108         ownerSetLimits(100000000000000000, 2000000000000000000);
1109         ownerSetEdgeRangeAndPayout(2, 2, 2);
1110         ownerSetGasLimit(250000);
1111         ownerSetStandardFee(5000000000000000);
1112     }
1113 
1114     function roll() public payable {
1115         if (msg.value > maxBet || msg.value < minBet) throw;
1116         bytes32 queryId = oraclize_newRandomDSQuery(0, 2, gasLimit);
1117         playerAddy[queryId] = msg.sender;
1118         playerBetSize[queryId] = msg.value;
1119         playerHiLo[queryId] = false; // Default the game to roll low
1120     }
1121 
1122     function () public payable {
1123         // Default betting function
1124         roll();
1125     }
1126 
1127     function rollLo() public payable {
1128         if (msg.value > maxBet || msg.value < minBet) throw;
1129         bytes32 queryId = oraclize_newRandomDSQuery(0, 2, gasLimit);
1130         playerAddy[queryId] = msg.sender;
1131         playerBetSize[queryId] = msg.value;
1132         playerHiLo[queryId] = false;
1133     }
1134 
1135     function __callback(bytes32 _queryId, string _result, bytes _proof) onlyOraclize {
1136         betCount = add(betCount, 1);
1137         uint betAmount = playerBetSize[_queryId];
1138         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0 || _proof.length == 0) {
1139 
1140         }
1141         else {
1142             uint playerNum = uint(sha3(_result)) % 2**(2*8) * 100 / ( 2**(2*8) );
1143             if (playerHiLo[_queryId] == false ) {
1144                 if (playerNum + minimumNumber < ( 100 / 2 ) - edgeRange) {
1145                     // Player Wins
1146                     LogBet(playerAddy[_queryId], playerHiLo[_queryId], playerNum + minimumNumber, betAmount, true);
1147                     playerAddy[_queryId].transfer((betAmount) * payoutMultiplier - standardFee);
1148                     totalPlayerWinnings = add(totalHouseWinnings,(betAmount) * payoutMultiplier);
1149                 }
1150                 else {
1151                     // Player Loses
1152                     LogBet(playerAddy[_queryId], playerHiLo[_queryId], playerNum + minimumNumber, betAmount, false);
1153                     playerAddy[_queryId].transfer(1 wei);
1154                     totalHouseWinnings = add(totalHouseWinnings,(betAmount) * payoutMultiplier);
1155                 }
1156             }
1157         }
1158 
1159         delete playerAddy[_queryId];
1160         delete playerBetSize[_queryId];
1161         delete playerHiLo[_queryId];
1162     }
1163 
1164     function ownerDeposit() public payable {
1165         // Simply allows owner to deposit funds into the house bankroll
1166     }
1167 
1168     function ownerSetGasLimit(uint gasValue) public onlyOwner {
1169         gasLimit = gasValue;
1170     }
1171 
1172     function ownerSetLimits(uint min, uint max) public onlyOwner {
1173         // Set the minimum and maximum bet size
1174         minBet = min * 1 wei;
1175         maxBet = max * 1 wei;
1176     }
1177 
1178     function ownerSetEdgeRangeAndPayout(uint value, uint value2, uint value3) public onlyOwner {
1179         edgeRange = value;
1180         payoutMultiplier = value2;
1181         minimumNumber = value3;
1182     }
1183 
1184     function ownerSetStandardFee(uint fee) public onlyOwner {
1185         standardFee = fee;
1186     }
1187 
1188     function ownerTransferEther(address addy, uint value) public onlyOwner {
1189       if(!addy.send(value)) throw;
1190     }
1191 
1192     function ownerKillContract() public onlyOwner {
1193         suicide(owner);
1194     }
1195 }