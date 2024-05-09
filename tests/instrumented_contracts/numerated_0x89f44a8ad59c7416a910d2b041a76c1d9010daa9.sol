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
31 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
32 pragma solidity ^0.4.19;
33 
34 contract OraclizeI {
35     address public cbAddress;
36     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
37     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
38     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
39     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
40     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
41     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
42     function getPrice(string _datasource) public returns (uint _dsprice);
43     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
44     function setProofType(byte _proofType) external;
45     function setCustomGasPrice(uint _gasPrice) external;
46     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
47 }
48 contract OraclizeAddrResolverI {
49     function getAddress() public returns (address _addr);
50 }
51 contract usingOraclize {
52     uint constant day = 60*60*24;
53     uint constant week = 60*60*24*7;
54     uint constant month = 60*60*24*30;
55     byte constant proofType_NONE = 0x00;
56     byte constant proofType_TLSNotary = 0x10;
57     byte constant proofType_Android = 0x20;
58     byte constant proofType_Ledger = 0x30;
59     byte constant proofType_Native = 0xF0;
60     byte constant proofStorage_IPFS = 0x01;
61     uint8 constant networkID_auto = 0;
62     uint8 constant networkID_mainnet = 1;
63     uint8 constant networkID_testnet = 2;
64     uint8 constant networkID_morden = 2;
65     uint8 constant networkID_consensys = 161;
66 
67     OraclizeAddrResolverI OAR;
68 
69     OraclizeI oraclize;
70     modifier oraclizeAPI {
71         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
72             oraclize_setNetwork(networkID_auto);
73 
74         if(address(oraclize) != OAR.getAddress())
75             oraclize = OraclizeI(OAR.getAddress());
76 
77         _;
78     }
79     modifier coupon(string code){
80         oraclize = OraclizeI(OAR.getAddress());
81         _;
82     }
83 
84     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
85       return oraclize_setNetwork();
86       networkID; // silence the warning and remain backwards compatible
87     }
88     function oraclize_setNetwork() internal returns(bool){
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
124     function __callback(bytes32 myid, string result) public {
125         __callback(myid, result, new bytes(0));
126     }
127     function __callback(bytes32 myid, string result, bytes proof) public {
128       return;
129       myid; result; proof; // Silence compiler warnings
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
522 
523     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
524         return oraclize.randomDS_getSessionPubKeyHash();
525     }
526 
527     function getCodeSize(address _addr) constant internal returns(uint _size) {
528         assembly {
529             _size := extcodesize(_addr)
530         }
531     }
532 
533     function parseAddr(string _a) internal pure returns (address){
534         bytes memory tmp = bytes(_a);
535         uint160 iaddr = 0;
536         uint160 b1;
537         uint160 b2;
538         for (uint i=2; i<2+2*20; i+=2){
539             iaddr *= 256;
540             b1 = uint160(tmp[i]);
541             b2 = uint160(tmp[i+1]);
542             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
543             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
544             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
545             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
546             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
547             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
548             iaddr += (b1*16+b2);
549         }
550         return address(iaddr);
551     }
552 
553     function strCompare(string _a, string _b) internal pure returns (int) {
554         bytes memory a = bytes(_a);
555         bytes memory b = bytes(_b);
556         uint minLength = a.length;
557         if (b.length < minLength) minLength = b.length;
558         for (uint i = 0; i < minLength; i ++)
559             if (a[i] < b[i])
560                 return -1;
561             else if (a[i] > b[i])
562                 return 1;
563         if (a.length < b.length)
564             return -1;
565         else if (a.length > b.length)
566             return 1;
567         else
568             return 0;
569     }
570 
571     function indexOf(string _haystack, string _needle) internal pure returns (int) {
572         bytes memory h = bytes(_haystack);
573         bytes memory n = bytes(_needle);
574         if(h.length < 1 || n.length < 1 || (n.length > h.length))
575             return -1;
576         else if(h.length > (2**128 -1))
577             return -1;
578         else
579         {
580             uint subindex = 0;
581             for (uint i = 0; i < h.length; i ++)
582             {
583                 if (h[i] == n[0])
584                 {
585                     subindex = 1;
586                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
587                     {
588                         subindex++;
589                     }
590                     if(subindex == n.length)
591                         return int(i);
592                 }
593             }
594             return -1;
595         }
596     }
597 
598     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
599         bytes memory _ba = bytes(_a);
600         bytes memory _bb = bytes(_b);
601         bytes memory _bc = bytes(_c);
602         bytes memory _bd = bytes(_d);
603         bytes memory _be = bytes(_e);
604         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
605         bytes memory babcde = bytes(abcde);
606         uint k = 0;
607         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
608         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
609         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
610         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
611         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
612         return string(babcde);
613     }
614 
615     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
616         return strConcat(_a, _b, _c, _d, "");
617     }
618 
619     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
620         return strConcat(_a, _b, _c, "", "");
621     }
622 
623     function strConcat(string _a, string _b) internal pure returns (string) {
624         return strConcat(_a, _b, "", "", "");
625     }
626 
627     // parseInt
628     function parseInt(string _a) internal pure returns (uint) {
629         return parseInt(_a, 0);
630     }
631 
632     // parseInt(parseFloat*10^_b)
633     function parseInt(string _a, uint _b) internal pure returns (uint) {
634         bytes memory bresult = bytes(_a);
635         uint mint = 0;
636         bool decimals = false;
637         for (uint i=0; i<bresult.length; i++){
638             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
639                 if (decimals){
640                    if (_b == 0) break;
641                     else _b--;
642                 }
643                 mint *= 10;
644                 mint += uint(bresult[i]) - 48;
645             } else if (bresult[i] == 46) decimals = true;
646         }
647         if (_b > 0) mint *= 10**_b;
648         return mint;
649     }
650 
651     function uint2str(uint i) internal pure returns (string){
652         if (i == 0) return "0";
653         uint j = i;
654         uint len;
655         while (j != 0){
656             len++;
657             j /= 10;
658         }
659         bytes memory bstr = new bytes(len);
660         uint k = len - 1;
661         while (i != 0){
662             bstr[k--] = byte(48 + i % 10);
663             i /= 10;
664         }
665         return string(bstr);
666     }
667 
668     function stra2cbor(string[] arr) internal pure returns (bytes) {
669             uint arrlen = arr.length;
670 
671             // get correct cbor output length
672             uint outputlen = 0;
673             bytes[] memory elemArray = new bytes[](arrlen);
674             for (uint i = 0; i < arrlen; i++) {
675                 elemArray[i] = (bytes(arr[i]));
676                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
677             }
678             uint ctr = 0;
679             uint cborlen = arrlen + 0x80;
680             outputlen += byte(cborlen).length;
681             bytes memory res = new bytes(outputlen);
682 
683             while (byte(cborlen).length > ctr) {
684                 res[ctr] = byte(cborlen)[ctr];
685                 ctr++;
686             }
687             for (i = 0; i < arrlen; i++) {
688                 res[ctr] = 0x5F;
689                 ctr++;
690                 for (uint x = 0; x < elemArray[i].length; x++) {
691                     // if there's a bug with larger strings, this may be the culprit
692                     if (x % 23 == 0) {
693                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
694                         elemcborlen += 0x40;
695                         uint lctr = ctr;
696                         while (byte(elemcborlen).length > ctr - lctr) {
697                             res[ctr] = byte(elemcborlen)[ctr - lctr];
698                             ctr++;
699                         }
700                     }
701                     res[ctr] = elemArray[i][x];
702                     ctr++;
703                 }
704                 res[ctr] = 0xFF;
705                 ctr++;
706             }
707             return res;
708         }
709 
710     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
711             uint arrlen = arr.length;
712 
713             // get correct cbor output length
714             uint outputlen = 0;
715             bytes[] memory elemArray = new bytes[](arrlen);
716             for (uint i = 0; i < arrlen; i++) {
717                 elemArray[i] = (bytes(arr[i]));
718                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
719             }
720             uint ctr = 0;
721             uint cborlen = arrlen + 0x80;
722             outputlen += byte(cborlen).length;
723             bytes memory res = new bytes(outputlen);
724 
725             while (byte(cborlen).length > ctr) {
726                 res[ctr] = byte(cborlen)[ctr];
727                 ctr++;
728             }
729             for (i = 0; i < arrlen; i++) {
730                 res[ctr] = 0x5F;
731                 ctr++;
732                 for (uint x = 0; x < elemArray[i].length; x++) {
733                     // if there's a bug with larger strings, this may be the culprit
734                     if (x % 23 == 0) {
735                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
736                         elemcborlen += 0x40;
737                         uint lctr = ctr;
738                         while (byte(elemcborlen).length > ctr - lctr) {
739                             res[ctr] = byte(elemcborlen)[ctr - lctr];
740                             ctr++;
741                         }
742                     }
743                     res[ctr] = elemArray[i][x];
744                     ctr++;
745                 }
746                 res[ctr] = 0xFF;
747                 ctr++;
748             }
749             return res;
750         }
751 
752 
753     string oraclize_network_name;
754     function oraclize_setNetworkName(string _network_name) internal {
755         oraclize_network_name = _network_name;
756     }
757 
758     function oraclize_getNetworkName() internal view returns (string) {
759         return oraclize_network_name;
760     }
761 
762     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
763         require((_nbytes > 0) && (_nbytes <= 32));
764         // Convert from seconds to ledger timer ticks
765         _delay *= 10; 
766         bytes memory nbytes = new bytes(1);
767         nbytes[0] = byte(_nbytes);
768         bytes memory unonce = new bytes(32);
769         bytes memory sessionKeyHash = new bytes(32);
770         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
771         assembly {
772             mstore(unonce, 0x20)
773             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
774             mstore(sessionKeyHash, 0x20)
775             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
776         }
777         bytes memory delay = new bytes(32);
778         assembly { 
779             mstore(add(delay, 0x20), _delay) 
780         }
781         
782         bytes memory delay_bytes8 = new bytes(8);
783         copyBytes(delay, 24, 8, delay_bytes8, 0);
784 
785         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
786         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
787         
788         bytes memory delay_bytes8_left = new bytes(8);
789         
790         assembly {
791             let x := mload(add(delay_bytes8, 0x20))
792             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
793             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
794             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
795             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
796             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
797             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
798             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
799             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
800 
801         }
802         
803         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
804         return queryId;
805     }
806     
807     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
808         oraclize_randomDS_args[queryId] = commitment;
809     }
810 
811     mapping(bytes32=>bytes32) oraclize_randomDS_args;
812     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
813 
814     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
815         bool sigok;
816         address signer;
817 
818         bytes32 sigr;
819         bytes32 sigs;
820 
821         bytes memory sigr_ = new bytes(32);
822         uint offset = 4+(uint(dersig[3]) - 0x20);
823         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
824         bytes memory sigs_ = new bytes(32);
825         offset += 32 + 2;
826         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
827 
828         assembly {
829             sigr := mload(add(sigr_, 32))
830             sigs := mload(add(sigs_, 32))
831         }
832 
833 
834         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
835         if (address(keccak256(pubkey)) == signer) return true;
836         else {
837             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
838             return (address(keccak256(pubkey)) == signer);
839         }
840     }
841 
842     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
843         bool sigok;
844 
845         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
846         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
847         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
848 
849         bytes memory appkey1_pubkey = new bytes(64);
850         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
851 
852         bytes memory tosign2 = new bytes(1+65+32);
853         tosign2[0] = byte(1); //role
854         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
855         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
856         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
857         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
858 
859         if (sigok == false) return false;
860 
861 
862         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
863         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
864 
865         bytes memory tosign3 = new bytes(1+65);
866         tosign3[0] = 0xFE;
867         copyBytes(proof, 3, 65, tosign3, 1);
868 
869         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
870         copyBytes(proof, 3+65, sig3.length, sig3, 0);
871 
872         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
873 
874         return sigok;
875     }
876 
877     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
878         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
879         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
880 
881         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
882         require(proofVerified);
883 
884         _;
885     }
886 
887     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
888         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
889         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
890 
891         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
892         if (proofVerified == false) return 2;
893 
894         return 0;
895     }
896 
897     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
898         bool match_ = true;
899         
900         require(prefix.length == n_random_bytes);
901 
902         for (uint256 i=0; i< n_random_bytes; i++) {
903             if (content[i] != prefix[i]) match_ = false;
904         }
905 
906         return match_;
907     }
908 
909     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
910 
911         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
912         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
913         bytes memory keyhash = new bytes(32);
914         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
915         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
916 
917         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
918         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
919 
920         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
921         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
922 
923         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
924         // This is to verify that the computed args match with the ones specified in the query.
925         bytes memory commitmentSlice1 = new bytes(8+1+32);
926         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
927 
928         bytes memory sessionPubkey = new bytes(64);
929         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
930         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
931 
932         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
933         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
934             delete oraclize_randomDS_args[queryId];
935         } else return false;
936 
937 
938         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
939         bytes memory tosign1 = new bytes(32+8+1+32);
940         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
941         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
942 
943         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
944         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
945             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
946         }
947 
948         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
949     }
950 
951     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
952     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
953         uint minLength = length + toOffset;
954 
955         // Buffer too small
956         require(to.length >= minLength); // Should be a better way?
957 
958         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
959         uint i = 32 + fromOffset;
960         uint j = 32 + toOffset;
961 
962         while (i < (32 + fromOffset + length)) {
963             assembly {
964                 let tmp := mload(add(from, i))
965                 mstore(add(to, j), tmp)
966             }
967             i += 32;
968             j += 32;
969         }
970 
971         return to;
972     }
973 
974     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
975     // Duplicate Solidity's ecrecover, but catching the CALL return value
976     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
977         // We do our own memory management here. Solidity uses memory offset
978         // 0x40 to store the current end of memory. We write past it (as
979         // writes are memory extensions), but don't update the offset so
980         // Solidity will reuse it. The memory used here is only needed for
981         // this context.
982 
983         // FIXME: inline assembly can't access return values
984         bool ret;
985         address addr;
986 
987         assembly {
988             let size := mload(0x40)
989             mstore(size, hash)
990             mstore(add(size, 32), v)
991             mstore(add(size, 64), r)
992             mstore(add(size, 96), s)
993 
994             // NOTE: we can reuse the request memory because we deal with
995             //       the return code
996             ret := call(3000, 1, 0, size, 128, size, 32)
997             addr := mload(size)
998         }
999 
1000         return (ret, addr);
1001     }
1002 
1003     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1004     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1005         bytes32 r;
1006         bytes32 s;
1007         uint8 v;
1008 
1009         if (sig.length != 65)
1010           return (false, 0);
1011 
1012         // The signature format is a compact form of:
1013         //   {bytes32 r}{bytes32 s}{uint8 v}
1014         // Compact means, uint8 is not padded to 32 bytes.
1015         assembly {
1016             r := mload(add(sig, 32))
1017             s := mload(add(sig, 64))
1018 
1019             // Here we are loading the last 32 bytes. We exploit the fact that
1020             // 'mload' will pad with zeroes if we overread.
1021             // There is no 'mload8' to do this, but that would be nicer.
1022             v := byte(0, mload(add(sig, 96)))
1023 
1024             // Alternative solution:
1025             // 'byte' is not working due to the Solidity parser, so lets
1026             // use the second best option, 'and'
1027             // v := and(mload(add(sig, 65)), 255)
1028         }
1029 
1030         // albeit non-transactional signatures are not specified by the YP, one would expect it
1031         // to match the YP range of [27, 28]
1032         //
1033         // geth uses [0, 1] and some clients have followed. This might change, see:
1034         //  https://github.com/ethereum/go-ethereum/issues/2053
1035         if (v < 27)
1036           v += 27;
1037 
1038         if (v != 27 && v != 28)
1039             return (false, 0);
1040 
1041         return safer_ecrecover(hash, v, r, s);
1042     }
1043 
1044 }
1045 // </ORACLIZE_API>
1046 /**
1047  * @title SafeMath
1048  * @dev Math operations with safety checks that throw on error
1049  */
1050 
1051 library SafeMath {
1052   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
1053     if (a == 0) {
1054       return 0;
1055     }
1056     uint256 c = a * b;
1057     assert(c / a == b);
1058     return c;
1059   }
1060 
1061   function div(uint256 a, uint256 b) internal constant returns (uint256) {
1062     // assert(b > 0); // Solidity automatically throws when dividing by 0
1063     uint256 c = a / b;
1064     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1065     return c;
1066   }
1067 
1068   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
1069     assert(b <= a);
1070     return a - b;
1071   }
1072 
1073   function add(uint256 a, uint256 b) internal constant returns (uint256) {
1074     uint256 c = a + b;
1075     assert(c >= a);
1076     return c;
1077   }
1078 }
1079 
1080 contract Migrations {
1081   address public owner;
1082   uint public last_completed_migration;
1083 
1084   modifier restricted() {
1085     if (msg.sender == owner) _;
1086   }
1087 
1088   function Migrations() public {
1089     owner = msg.sender;
1090   }
1091 
1092   function setCompleted(uint completed) public restricted {
1093     last_completed_migration = completed;
1094   }
1095 
1096   function upgrade(address new_address) public restricted {
1097     Migrations upgraded = Migrations(new_address);
1098     upgraded.setCompleted(last_completed_migration);
1099   }
1100 }
1101 
1102 contract owned {
1103     address public owner;
1104 
1105     function owned() public {
1106         owner = msg.sender;
1107     }
1108 
1109     modifier onlyOwner {
1110         require(msg.sender == owner);
1111         _;
1112     }
1113 
1114     function transferOwnership(address newOwner) onlyOwner public {
1115         owner = newOwner;
1116     }
1117 }
1118 
1119 library SafeERC20 {
1120   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
1121     assert(token.transfer(to, value));
1122   }
1123 
1124   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
1125     assert(token.transferFrom(from, to, value));
1126   }
1127 
1128   function safeApprove(ERC20 token, address spender, uint256 value) internal {
1129     assert(token.approve(spender, value));
1130   }
1131 }
1132 
1133 contract ERC20Basic {
1134   function totalSupply() public view returns (uint256);
1135   function balanceOf(address who) public view returns (uint256);
1136   function transfer(address to, uint256 value) public returns (bool);
1137   event Transfer(address indexed from, address indexed to, uint256 value);
1138 }
1139 
1140 contract ERC20 is ERC20Basic {
1141   function allowance(address owner, address spender) public view returns (uint256);
1142   function transferFrom(address from, address to, uint256 value) public returns (bool);
1143   function approve(address spender, uint256 value) public returns (bool);
1144   event Approval(address indexed owner, address indexed spender, uint256 value);
1145 }
1146 
1147 contract TokenVesting is owned {
1148   using SafeMath for uint256;
1149   using SafeERC20 for ERC20Basic;
1150 
1151   event Released(uint256 amount);
1152   event Revoked();
1153 
1154   // beneficiary of tokens after they are released
1155   address public beneficiary;
1156 
1157   uint256 public cliff;
1158   uint256 public start;
1159   uint256 public duration;
1160 
1161   bool public revocable;
1162 
1163   mapping (address => uint256) public released;
1164   mapping (address => bool) public revoked;
1165 
1166   /**
1167    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
1168    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
1169    * of the balance will have vested.
1170    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
1171    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
1172    * @param _duration duration in seconds of the period in which the tokens will vest
1173    * @param _revocable whether the vesting is revocable or not
1174    */
1175   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
1176     require(_beneficiary != address(0));
1177     require(_cliff <= _duration);
1178 
1179     beneficiary = _beneficiary;
1180     revocable = _revocable;
1181     duration = _duration;
1182     cliff = _start.add(_cliff);
1183     start = _start;
1184   }
1185 
1186   /**
1187    * @notice Transfers vested tokens to beneficiary.
1188    * @param token ERC20 token which is being vested
1189    */
1190   function release(ERC20Basic token) public {
1191     uint256 unreleased = releasableAmount(token);
1192 
1193     require(unreleased > 0);
1194 
1195     released[token] = released[token].add(unreleased);
1196 
1197     token.safeTransfer(beneficiary, unreleased);
1198 
1199     Released(unreleased);
1200   }
1201 
1202   /**
1203    * @notice Allows the owner to revoke the vesting. Tokens already vested
1204    * remain in the contract, the rest are returned to the owner.
1205    * @param token ERC20 token which is being vested
1206    */
1207   function revoke(ERC20Basic token) public onlyOwner {
1208     require(revocable);
1209     require(!revoked[token]);
1210 
1211     uint256 balance = token.balanceOf(this);
1212 
1213     uint256 unreleased = releasableAmount(token);
1214     uint256 refund = balance.sub(unreleased);
1215 
1216     revoked[token] = true;
1217 
1218     token.safeTransfer(owner, refund);
1219 
1220     Revoked();
1221   }
1222 
1223   /**
1224    * @dev Calculates the amount that has already vested but hasn't been released yet.
1225    * @param token ERC20 token which is being vested
1226    */
1227   function releasableAmount(ERC20Basic token) public view returns (uint256) {
1228     return vestedAmount(token).sub(released[token]);
1229   }
1230 
1231   /**
1232    * @dev Calculates the amount that has already vested.
1233    * @param token ERC20 token which is being vested
1234    */
1235   function vestedAmount(ERC20Basic token) public view returns (uint256) {
1236     uint256 currentBalance = token.balanceOf(this);
1237     uint256 totalBalance = currentBalance.add(released[token]);
1238 
1239     if (now < cliff) {
1240       return 0;
1241     } else if (now >= start.add(duration) || revoked[token]) {
1242       return totalBalance;
1243     } else {
1244       return totalBalance.mul(now.sub(start)).div(duration);
1245     }
1246   }
1247 }
1248 
1249 contract BasicToken is ERC20Basic {
1250   using SafeMath for uint256;
1251 
1252   mapping(address => uint256) balances;
1253 
1254   uint256 totalSupply_;
1255 
1256   /**
1257   * @dev total number of tokens in existence
1258   */
1259   function totalSupply() public view returns (uint256) {
1260     return totalSupply_;
1261   }
1262 
1263   /**
1264   * @dev transfer token for a specified address
1265   * @param _to The address to transfer to.
1266   * @param _value The amount to be transferred.
1267   */
1268   function transfer(address _to, uint256 _value) public returns (bool) {
1269     require(_to != address(0));
1270     require(_value <= balances[msg.sender]);
1271 
1272     // SafeMath.sub will throw if there is not enough balance.
1273     balances[msg.sender] = balances[msg.sender].sub(_value);
1274     balances[_to] = balances[_to].add(_value);
1275     Transfer(msg.sender, _to, _value);
1276     return true;
1277   }
1278 
1279   /**
1280   * @dev Gets the balance of the specified address.
1281   * @param _owner The address to query the the balance of.
1282   * @return An uint256 representing the amount owned by the passed address.
1283   */
1284   function balanceOf(address _owner) public view returns (uint256 balance) {
1285     return balances[_owner];
1286   }
1287 
1288 }
1289 
1290 contract StandardToken is ERC20, BasicToken {
1291 
1292   mapping (address => mapping (address => uint256)) internal allowed;
1293 
1294 
1295   /**
1296    * @dev Transfer tokens from one address to another
1297    * @param _from address The address which you want to send tokens from
1298    * @param _to address The address which you want to transfer to
1299    * @param _value uint256 the amount of tokens to be transferred
1300    */
1301   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1302     require(_to != address(0));
1303     require(_value <= balances[_from]);
1304     require(_value <= allowed[_from][msg.sender]);
1305 
1306     balances[_from] = balances[_from].sub(_value);
1307     balances[_to] = balances[_to].add(_value);
1308     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1309     Transfer(_from, _to, _value);
1310     return true;
1311   }
1312 
1313   /**
1314    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1315    *
1316    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1317    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1318    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1319    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1320    * @param _spender The address which will spend the funds.
1321    * @param _value The amount of tokens to be spent.
1322    */
1323   function approve(address _spender, uint256 _value) public returns (bool) {
1324     allowed[msg.sender][_spender] = _value;
1325     Approval(msg.sender, _spender, _value);
1326     return true;
1327   }
1328 
1329   /**
1330    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1331    * @param _owner address The address which owns the funds.
1332    * @param _spender address The address which will spend the funds.
1333    * @return A uint256 specifying the amount of tokens still available for the spender.
1334    */
1335   function allowance(address _owner, address _spender) public view returns (uint256) {
1336     return allowed[_owner][_spender];
1337   }
1338 
1339   /**
1340    * @dev Increase the amount of tokens that an owner allowed to a spender.
1341    *
1342    * approve should be called when allowed[_spender] == 0. To increment
1343    * allowed value is better to use this function to avoid 2 calls (and wait until
1344    * the first transaction is mined)
1345    * From MonolithDAO Token.sol
1346    * @param _spender The address which will spend the funds.
1347    * @param _addedValue The amount of tokens to increase the allowance by.
1348    */
1349   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1350     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1351     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1352     return true;
1353   }
1354 
1355   /**
1356    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1357    *
1358    * approve should be called when allowed[_spender] == 0. To decrement
1359    * allowed value is better to use this function to avoid 2 calls (and wait until
1360    * the first transaction is mined)
1361    * From MonolithDAO Token.sol
1362    * @param _spender The address which will spend the funds.
1363    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1364    */
1365   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1366     uint oldValue = allowed[msg.sender][_spender];
1367     if (_subtractedValue > oldValue) {
1368       allowed[msg.sender][_spender] = 0;
1369     } else {
1370       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1371     }
1372     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1373     return true;
1374   }
1375 
1376 }
1377 
1378 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
1379 
1380 contract BurnableToken is BasicToken {
1381 
1382   event Burn(address indexed burner, uint256 value);
1383 
1384   /**
1385    * @dev Burns a specific amount of tokens.
1386    * @param _value The amount of token to be burned.
1387    */
1388   function burn(uint256 _value) public {
1389     require(_value <= balances[msg.sender]);
1390     // no need to require value <= totalSupply, since that would imply the
1391     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1392 
1393     address burner = msg.sender;
1394     balances[burner] = balances[burner].sub(_value);
1395     totalSupply_ = totalSupply_.sub(_value);
1396     Burn(burner, _value);
1397     Transfer(burner, address(0), _value);
1398   }
1399 }
1400 
1401 contract GCTToken is owned, BurnableToken, usingOraclize {
1402 
1403     string public name = "GCoin";
1404     string public symbol = "GCT";
1405     uint8 public decimals = 18;
1406     
1407     
1408     uint256 public buyPrice = 30;
1409     uint256 public ethusd = 0;
1410     uint public updatePriceFreq = 30 hours;
1411     
1412     uint256 public RATE;
1413     uint256 public initialSupply = 50000000e18;
1414     uint256 public totalSupply = 250000000e18;
1415     
1416     
1417     mapping (address => bool) public frozenAccount;
1418 
1419     /* This generates a public event on the blockchain that will notify clients */
1420     event FrozenFunds(address target, bool frozen);
1421 
1422     /* Initializes contract with initial supply tokens to the creator of the contract */
1423     function GCTToken () public {
1424         
1425         // 1. Main wallet 50 million
1426         balances[msg.sender] = 50000000e18;
1427     
1428         // 2. crowdsale wallet 50 million
1429         balances[0x8Da77013C2355d460B51011a3a6110Df0DBd8E84] = 50000000e18;
1430     
1431         // 3. CEO wallet 25 million
1432         balances[0x2a845509E176a733Aca84a10c04BC1cFF98e18Db] = 25000000e18;
1433     
1434         // 4. CTO wallet 25 million
1435         balances[0x127A4DeD02a117BB2cF9F2706Cad4ef0730108c2] = 25000000e18;
1436     
1437         // 5. liquidity wallet 37.5 million
1438         balances[0x3C77ff4CD35622055cA81985fd4639Ade9277fA6] = 37500000e18;
1439     
1440         // 6. emergency wallet 37.5 million
1441         balances[0x2436A744Fa73d5F12722b395A85Bdf31e6981849] = 37500000e18;
1442     
1443         // 7. ongoing project fund wallet, 20 million
1444         balances[0x6f7F39e842dacBF0ce039af0AfbC2201151Fa046] = 20000000e18;
1445     
1446         // 8. donation wallet 5 million
1447         balances[0x6a82D5F7Bb63E5C3E9Aeb157D3286cF734695664] = 5000000e18;
1448     }
1449     function () payable {
1450         buy();
1451     }
1452     function __callback(bytes32 myid, string result) {
1453         require(msg.sender == oraclize_cbAddress());
1454         ethusd = parseInt(result, 2);
1455         updatePrice();
1456     }
1457 
1458     function updatePrice() public payable {
1459         oraclize_query(updatePriceFreq, "URL", "json(https://api.etherscan.io/api?module=stats&action=ethprice&apikey=YourApiKeyToken).result.ethusd");
1460     }
1461     /* Internal transfer, only can be called by this contract */
1462     function _transfer(address _from, address _to, uint _value) internal {
1463         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
1464         require (balances[_from] > _value);                // Check if the sender has enough
1465         require (balances[_to].add(_value) > balances[_to]); // Check for overflow
1466         balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender
1467         balances[_to] = balances[_to].add(_value);                           // Add the same to the recipient
1468         Transfer(_from, _to, _value);
1469     }
1470 
1471     /// @notice Create `mintedAmount` tokens and send it to `target`
1472     /// @param target Address to receive the tokens
1473     /// @param mintedAmount the amount of tokens it will receive
1474     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
1475         balances[target] = balances[target].add(mintedAmount);
1476         totalSupply = totalSupply.add(mintedAmount);
1477         Transfer(0, this, mintedAmount);
1478         Transfer(this, target, mintedAmount);
1479     }
1480 
1481     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
1482     /// @param target Address to be frozen
1483     /// @param freeze either to freeze it or not
1484     function freezeAccount(address target, bool freeze) onlyOwner public {
1485         frozenAccount[target] = freeze;
1486         FrozenFunds(target, freeze);
1487     }
1488 
1489     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
1490     /// @param newBuyPrice Price users can buy from the contract
1491     function setPrices( uint256 newBuyPrice) onlyOwner public {
1492         buyPrice = newBuyPrice;
1493         buyPrice = buyPrice.mul(100);
1494     }
1495 
1496     /// @notice Buy tokens from contract by sending ether
1497     function buy() payable public {
1498         require(msg.value > 0);
1499         
1500         if(ethusd == 0)
1501             ethusd = 1000;
1502         RATE = ethusd / buyPrice;
1503         uint amount = msg.value.mul(RATE);
1504         require(initialSupply > amount);
1505         initialSupply = initialSupply.sub(amount);
1506         
1507         address crowdsale_wallet = 0x8Da77013C2355d460B51011a3a6110Df0DBd8E84;
1508         _transfer(crowdsale_wallet, msg.sender, amount);              // makes the transfers
1509         
1510         address company_wallet = 0xde2b42142834eb16189936f36f67ac4526250860;
1511         company_wallet.transfer(msg.value);
1512     }
1513 }