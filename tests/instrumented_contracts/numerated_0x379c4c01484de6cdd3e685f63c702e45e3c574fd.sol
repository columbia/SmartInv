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
32 pragma solidity ^0.4.18;
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
764         bytes memory nbytes = new bytes(1);
765         nbytes[0] = byte(_nbytes);
766         bytes memory unonce = new bytes(32);
767         bytes memory sessionKeyHash = new bytes(32);
768         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
769         assembly {
770             mstore(unonce, 0x20)
771             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
772             mstore(sessionKeyHash, 0x20)
773             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
774         }
775         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
776         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
777         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
778         return queryId;
779     }
780 
781     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
782         oraclize_randomDS_args[queryId] = commitment;
783     }
784 
785     mapping(bytes32=>bytes32) oraclize_randomDS_args;
786     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
787 
788     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
789         bool sigok;
790         address signer;
791 
792         bytes32 sigr;
793         bytes32 sigs;
794 
795         bytes memory sigr_ = new bytes(32);
796         uint offset = 4+(uint(dersig[3]) - 0x20);
797         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
798         bytes memory sigs_ = new bytes(32);
799         offset += 32 + 2;
800         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
801 
802         assembly {
803             sigr := mload(add(sigr_, 32))
804             sigs := mload(add(sigs_, 32))
805         }
806 
807 
808         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
809         if (address(keccak256(pubkey)) == signer) return true;
810         else {
811             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
812             return (address(keccak256(pubkey)) == signer);
813         }
814     }
815 
816     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
817         bool sigok;
818 
819         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
820         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
821         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
822 
823         bytes memory appkey1_pubkey = new bytes(64);
824         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
825 
826         bytes memory tosign2 = new bytes(1+65+32);
827         tosign2[0] = byte(1); //role
828         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
829         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
830         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
831         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
832 
833         if (sigok == false) return false;
834 
835 
836         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
837         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
838 
839         bytes memory tosign3 = new bytes(1+65);
840         tosign3[0] = 0xFE;
841         copyBytes(proof, 3, 65, tosign3, 1);
842 
843         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
844         copyBytes(proof, 3+65, sig3.length, sig3, 0);
845 
846         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
847 
848         return sigok;
849     }
850 
851     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
852         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
853         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
854 
855         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
856         require(proofVerified);
857 
858         _;
859     }
860 
861     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
862         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
863         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
864 
865         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
866         if (proofVerified == false) return 2;
867 
868         return 0;
869     }
870 
871     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
872         bool match_ = true;
873 
874 
875         for (uint256 i=0; i< n_random_bytes; i++) {
876             if (content[i] != prefix[i]) match_ = false;
877         }
878 
879         return match_;
880     }
881 
882     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
883 
884         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
885         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
886         bytes memory keyhash = new bytes(32);
887         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
888         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
889 
890         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
891         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
892 
893         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
894         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
895 
896         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
897         // This is to verify that the computed args match with the ones specified in the query.
898         bytes memory commitmentSlice1 = new bytes(8+1+32);
899         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
900 
901         bytes memory sessionPubkey = new bytes(64);
902         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
903         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
904 
905         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
906         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
907             delete oraclize_randomDS_args[queryId];
908         } else return false;
909 
910 
911         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
912         bytes memory tosign1 = new bytes(32+8+1+32);
913         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
914         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
915 
916         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
917         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
918             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
919         }
920 
921         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
922     }
923 
924     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
925     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
926         uint minLength = length + toOffset;
927 
928         // Buffer too small
929         require(to.length >= minLength); // Should be a better way?
930 
931         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
932         uint i = 32 + fromOffset;
933         uint j = 32 + toOffset;
934 
935         while (i < (32 + fromOffset + length)) {
936             assembly {
937                 let tmp := mload(add(from, i))
938                 mstore(add(to, j), tmp)
939             }
940             i += 32;
941             j += 32;
942         }
943 
944         return to;
945     }
946 
947     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
948     // Duplicate Solidity's ecrecover, but catching the CALL return value
949     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
950         // We do our own memory management here. Solidity uses memory offset
951         // 0x40 to store the current end of memory. We write past it (as
952         // writes are memory extensions), but don't update the offset so
953         // Solidity will reuse it. The memory used here is only needed for
954         // this context.
955 
956         // FIXME: inline assembly can't access return values
957         bool ret;
958         address addr;
959 
960         assembly {
961             let size := mload(0x40)
962             mstore(size, hash)
963             mstore(add(size, 32), v)
964             mstore(add(size, 64), r)
965             mstore(add(size, 96), s)
966 
967             // NOTE: we can reuse the request memory because we deal with
968             //       the return code
969             ret := call(3000, 1, 0, size, 128, size, 32)
970             addr := mload(size)
971         }
972 
973         return (ret, addr);
974     }
975 
976     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
977     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
978         bytes32 r;
979         bytes32 s;
980         uint8 v;
981 
982         if (sig.length != 65)
983           return (false, 0);
984 
985         // The signature format is a compact form of:
986         //   {bytes32 r}{bytes32 s}{uint8 v}
987         // Compact means, uint8 is not padded to 32 bytes.
988         assembly {
989             r := mload(add(sig, 32))
990             s := mload(add(sig, 64))
991 
992             // Here we are loading the last 32 bytes. We exploit the fact that
993             // 'mload' will pad with zeroes if we overread.
994             // There is no 'mload8' to do this, but that would be nicer.
995             v := byte(0, mload(add(sig, 96)))
996 
997             // Alternative solution:
998             // 'byte' is not working due to the Solidity parser, so lets
999             // use the second best option, 'and'
1000             // v := and(mload(add(sig, 65)), 255)
1001         }
1002 
1003         // albeit non-transactional signatures are not specified by the YP, one would expect it
1004         // to match the YP range of [27, 28]
1005         //
1006         // geth uses [0, 1] and some clients have followed. This might change, see:
1007         //  https://github.com/ethereum/go-ethereum/issues/2053
1008         if (v < 27)
1009           v += 27;
1010 
1011         if (v != 27 && v != 28)
1012             return (false, 0);
1013 
1014         return safer_ecrecover(hash, v, r, s);
1015     }
1016 
1017 }
1018 // </ORACLIZE_API>
1019 
1020 /*
1021  * @title String & slice utility library for Solidity contracts.
1022  * @author Nick Johnson <arachnid@notdot.net>
1023  *
1024  * @dev Functionality in this library is largely implemented using an
1025  *      abstraction called a 'slice'. A slice represents a part of a string -
1026  *      anything from the entire string to a single character, or even no
1027  *      characters at all (a 0-length slice). Since a slice only has to specify
1028  *      an offset and a length, copying and manipulating slices is a lot less
1029  *      expensive than copying and manipulating the strings they reference.
1030  *
1031  *      To further reduce gas costs, most functions on slice that need to return
1032  *      a slice modify the original one instead of allocating a new one; for
1033  *      instance, `s.split(".")` will return the text up to the first '.',
1034  *      modifying s to only contain the remainder of the string after the '.'.
1035  *      In situations where you do not want to modify the original slice, you
1036  *      can make a copy first with `.copy()`, for example:
1037  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1038  *      Solidity has no memory management, it will result in allocating many
1039  *      short-lived slices that are later discarded.
1040  *
1041  *      Functions that return two slices come in two versions: a non-allocating
1042  *      version that takes the second slice as an argument, modifying it in
1043  *      place, and an allocating version that allocates and returns the second
1044  *      slice; see `nextRune` for example.
1045  *
1046  *      Functions that have to copy string data will return strings rather than
1047  *      slices; these can be cast back to slices for further processing if
1048  *      required.
1049  *
1050  *      For convenience, some functions are provided with non-modifying
1051  *      variants that create a new slice and return both; for instance,
1052  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1053  *      corresponding to the left and right parts of the string.
1054  */
1055 
1056 library strings {
1057     struct slice {
1058         uint _len;
1059         uint _ptr;
1060     }
1061 
1062     function memcpy(uint dest, uint src, uint len) private {
1063         // Copy word-length chunks while possible
1064         for(; len >= 32; len -= 32) {
1065             assembly {
1066                 mstore(dest, mload(src))
1067             }
1068             dest += 32;
1069             src += 32;
1070         }
1071 
1072         // Copy remaining bytes
1073         uint mask = 256 ** (32 - len) - 1;
1074         assembly {
1075             let srcpart := and(mload(src), not(mask))
1076             let destpart := and(mload(dest), mask)
1077             mstore(dest, or(destpart, srcpart))
1078         }
1079     }
1080 
1081     /*
1082      * @dev Returns a slice containing the entire string.
1083      * @param self The string to make a slice from.
1084      * @return A newly allocated slice containing the entire string.
1085      */
1086     function toSlice(string self) internal returns (slice) {
1087         uint ptr;
1088         assembly {
1089             ptr := add(self, 0x20)
1090         }
1091         return slice(bytes(self).length, ptr);
1092     }
1093 
1094     /*
1095      * @dev Returns the length of a null-terminated bytes32 string.
1096      * @param self The value to find the length of.
1097      * @return The length of the string, from 0 to 32.
1098      */
1099     function len(bytes32 self) internal returns (uint) {
1100         uint ret;
1101         if (self == 0)
1102             return 0;
1103         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1104             ret += 16;
1105             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1106         }
1107         if (self & 0xffffffffffffffff == 0) {
1108             ret += 8;
1109             self = bytes32(uint(self) / 0x10000000000000000);
1110         }
1111         if (self & 0xffffffff == 0) {
1112             ret += 4;
1113             self = bytes32(uint(self) / 0x100000000);
1114         }
1115         if (self & 0xffff == 0) {
1116             ret += 2;
1117             self = bytes32(uint(self) / 0x10000);
1118         }
1119         if (self & 0xff == 0) {
1120             ret += 1;
1121         }
1122         return 32 - ret;
1123     }
1124 
1125     /*
1126      * @dev Returns a slice containing the entire bytes32, interpreted as a
1127      *      null-termintaed utf-8 string.
1128      * @param self The bytes32 value to convert to a slice.
1129      * @return A new slice containing the value of the input argument up to the
1130      *         first null.
1131      */
1132     function toSliceB32(bytes32 self) internal returns (slice ret) {
1133         // Allocate space for `self` in memory, copy it there, and point ret at it
1134         assembly {
1135             let ptr := mload(0x40)
1136             mstore(0x40, add(ptr, 0x20))
1137             mstore(ptr, self)
1138             mstore(add(ret, 0x20), ptr)
1139         }
1140         ret._len = len(self);
1141     }
1142 
1143     /*
1144      * @dev Returns a new slice containing the same data as the current slice.
1145      * @param self The slice to copy.
1146      * @return A new slice containing the same data as `self`.
1147      */
1148     function copy(slice self) internal returns (slice) {
1149         return slice(self._len, self._ptr);
1150     }
1151 
1152     /*
1153      * @dev Copies a slice to a new string.
1154      * @param self The slice to copy.
1155      * @return A newly allocated string containing the slice's text.
1156      */
1157     function toString(slice self) internal returns (string) {
1158         var ret = new string(self._len);
1159         uint retptr;
1160         assembly { retptr := add(ret, 32) }
1161 
1162         memcpy(retptr, self._ptr, self._len);
1163         return ret;
1164     }
1165 
1166     /*
1167      * @dev Returns the length in runes of the slice. Note that this operation
1168      *      takes time proportional to the length of the slice; avoid using it
1169      *      in loops, and call `slice.empty()` if you only need to know whether
1170      *      the slice is empty or not.
1171      * @param self The slice to operate on.
1172      * @return The length of the slice in runes.
1173      */
1174     function len(slice self) internal returns (uint l) {
1175         // Starting at ptr-31 means the LSB will be the byte we care about
1176         var ptr = self._ptr - 31;
1177         var end = ptr + self._len;
1178         for (l = 0; ptr < end; l++) {
1179             uint8 b;
1180             assembly { b := and(mload(ptr), 0xFF) }
1181             if (b < 0x80) {
1182                 ptr += 1;
1183             } else if(b < 0xE0) {
1184                 ptr += 2;
1185             } else if(b < 0xF0) {
1186                 ptr += 3;
1187             } else if(b < 0xF8) {
1188                 ptr += 4;
1189             } else if(b < 0xFC) {
1190                 ptr += 5;
1191             } else {
1192                 ptr += 6;
1193             }
1194         }
1195     }
1196 
1197     /*
1198      * @dev Returns true if the slice is empty (has a length of 0).
1199      * @param self The slice to operate on.
1200      * @return True if the slice is empty, False otherwise.
1201      */
1202     function empty(slice self) internal returns (bool) {
1203         return self._len == 0;
1204     }
1205 
1206     /*
1207      * @dev Returns a positive number if `other` comes lexicographically after
1208      *      `self`, a negative number if it comes before, or zero if the
1209      *      contents of the two slices are equal. Comparison is done per-rune,
1210      *      on unicode codepoints.
1211      * @param self The first slice to compare.
1212      * @param other The second slice to compare.
1213      * @return The result of the comparison.
1214      */
1215     function compare(slice self, slice other) internal returns (int) {
1216         uint shortest = self._len;
1217         if (other._len < self._len)
1218             shortest = other._len;
1219 
1220         var selfptr = self._ptr;
1221         var otherptr = other._ptr;
1222         for (uint idx = 0; idx < shortest; idx += 32) {
1223             uint a;
1224             uint b;
1225             assembly {
1226                 a := mload(selfptr)
1227                 b := mload(otherptr)
1228             }
1229             if (a != b) {
1230                 // Mask out irrelevant bytes and check again
1231                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1232                 var diff = (a & mask) - (b & mask);
1233                 if (diff != 0)
1234                     return int(diff);
1235             }
1236             selfptr += 32;
1237             otherptr += 32;
1238         }
1239         return int(self._len) - int(other._len);
1240     }
1241 
1242     /*
1243      * @dev Returns true if the two slices contain the same text.
1244      * @param self The first slice to compare.
1245      * @param self The second slice to compare.
1246      * @return True if the slices are equal, false otherwise.
1247      */
1248     function equals(slice self, slice other) internal returns (bool) {
1249         return compare(self, other) == 0;
1250     }
1251 
1252     /*
1253      * @dev Extracts the first rune in the slice into `rune`, advancing the
1254      *      slice to point to the next rune and returning `self`.
1255      * @param self The slice to operate on.
1256      * @param rune The slice that will contain the first rune.
1257      * @return `rune`.
1258      */
1259     function nextRune(slice self, slice rune) internal returns (slice) {
1260         rune._ptr = self._ptr;
1261 
1262         if (self._len == 0) {
1263             rune._len = 0;
1264             return rune;
1265         }
1266 
1267         uint len;
1268         uint b;
1269         // Load the first byte of the rune into the LSBs of b
1270         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1271         if (b < 0x80) {
1272             len = 1;
1273         } else if(b < 0xE0) {
1274             len = 2;
1275         } else if(b < 0xF0) {
1276             len = 3;
1277         } else {
1278             len = 4;
1279         }
1280 
1281         // Check for truncated codepoints
1282         if (len > self._len) {
1283             rune._len = self._len;
1284             self._ptr += self._len;
1285             self._len = 0;
1286             return rune;
1287         }
1288 
1289         self._ptr += len;
1290         self._len -= len;
1291         rune._len = len;
1292         return rune;
1293     }
1294 
1295     /*
1296      * @dev Returns the first rune in the slice, advancing the slice to point
1297      *      to the next rune.
1298      * @param self The slice to operate on.
1299      * @return A slice containing only the first rune from `self`.
1300      */
1301     function nextRune(slice self) internal returns (slice ret) {
1302         nextRune(self, ret);
1303     }
1304 
1305     /*
1306      * @dev Returns the number of the first codepoint in the slice.
1307      * @param self The slice to operate on.
1308      * @return The number of the first codepoint in the slice.
1309      */
1310     function ord(slice self) internal returns (uint ret) {
1311         if (self._len == 0) {
1312             return 0;
1313         }
1314 
1315         uint word;
1316         uint length;
1317         uint divisor = 2 ** 248;
1318 
1319         // Load the rune into the MSBs of b
1320         assembly { word:= mload(mload(add(self, 32))) }
1321         var b = word / divisor;
1322         if (b < 0x80) {
1323             ret = b;
1324             length = 1;
1325         } else if(b < 0xE0) {
1326             ret = b & 0x1F;
1327             length = 2;
1328         } else if(b < 0xF0) {
1329             ret = b & 0x0F;
1330             length = 3;
1331         } else {
1332             ret = b & 0x07;
1333             length = 4;
1334         }
1335 
1336         // Check for truncated codepoints
1337         if (length > self._len) {
1338             return 0;
1339         }
1340 
1341         for (uint i = 1; i < length; i++) {
1342             divisor = divisor / 256;
1343             b = (word / divisor) & 0xFF;
1344             if (b & 0xC0 != 0x80) {
1345                 // Invalid UTF-8 sequence
1346                 return 0;
1347             }
1348             ret = (ret * 64) | (b & 0x3F);
1349         }
1350 
1351         return ret;
1352     }
1353 
1354     /*
1355      * @dev Returns the keccak-256 hash of the slice.
1356      * @param self The slice to hash.
1357      * @return The hash of the slice.
1358      */
1359     function keccak(slice self) internal returns (bytes32 ret) {
1360         assembly {
1361             ret := keccak256(mload(add(self, 32)), mload(self))
1362         }
1363     }
1364 
1365     /*
1366      * @dev Returns true if `self` starts with `needle`.
1367      * @param self The slice to operate on.
1368      * @param needle The slice to search for.
1369      * @return True if the slice starts with the provided text, false otherwise.
1370      */
1371     function startsWith(slice self, slice needle) internal returns (bool) {
1372         if (self._len < needle._len) {
1373             return false;
1374         }
1375 
1376         if (self._ptr == needle._ptr) {
1377             return true;
1378         }
1379 
1380         bool equal;
1381         assembly {
1382             let length := mload(needle)
1383             let selfptr := mload(add(self, 0x20))
1384             let needleptr := mload(add(needle, 0x20))
1385             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1386         }
1387         return equal;
1388     }
1389 
1390     /*
1391      * @dev If `self` starts with `needle`, `needle` is removed from the
1392      *      beginning of `self`. Otherwise, `self` is unmodified.
1393      * @param self The slice to operate on.
1394      * @param needle The slice to search for.
1395      * @return `self`
1396      */
1397     function beyond(slice self, slice needle) internal returns (slice) {
1398         if (self._len < needle._len) {
1399             return self;
1400         }
1401 
1402         bool equal = true;
1403         if (self._ptr != needle._ptr) {
1404             assembly {
1405                 let length := mload(needle)
1406                 let selfptr := mload(add(self, 0x20))
1407                 let needleptr := mload(add(needle, 0x20))
1408                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
1409             }
1410         }
1411 
1412         if (equal) {
1413             self._len -= needle._len;
1414             self._ptr += needle._len;
1415         }
1416 
1417         return self;
1418     }
1419 
1420     /*
1421      * @dev Returns true if the slice ends with `needle`.
1422      * @param self The slice to operate on.
1423      * @param needle The slice to search for.
1424      * @return True if the slice starts with the provided text, false otherwise.
1425      */
1426     function endsWith(slice self, slice needle) internal returns (bool) {
1427         if (self._len < needle._len) {
1428             return false;
1429         }
1430 
1431         var selfptr = self._ptr + self._len - needle._len;
1432 
1433         if (selfptr == needle._ptr) {
1434             return true;
1435         }
1436 
1437         bool equal;
1438         assembly {
1439             let length := mload(needle)
1440             let needleptr := mload(add(needle, 0x20))
1441             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1442         }
1443 
1444         return equal;
1445     }
1446 
1447     /*
1448      * @dev If `self` ends with `needle`, `needle` is removed from the
1449      *      end of `self`. Otherwise, `self` is unmodified.
1450      * @param self The slice to operate on.
1451      * @param needle The slice to search for.
1452      * @return `self`
1453      */
1454     function until(slice self, slice needle) internal returns (slice) {
1455         if (self._len < needle._len) {
1456             return self;
1457         }
1458 
1459         var selfptr = self._ptr + self._len - needle._len;
1460         bool equal = true;
1461         if (selfptr != needle._ptr) {
1462             assembly {
1463                 let length := mload(needle)
1464                 let needleptr := mload(add(needle, 0x20))
1465                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1466             }
1467         }
1468 
1469         if (equal) {
1470             self._len -= needle._len;
1471         }
1472 
1473         return self;
1474     }
1475 
1476     // Returns the memory address of the first byte of the first occurrence of
1477     // `needle` in `self`, or the first byte after `self` if not found.
1478     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1479         uint ptr;
1480         uint idx;
1481 
1482         if (needlelen <= selflen) {
1483             if (needlelen <= 32) {
1484                 // Optimized assembly for 68 gas per byte on short strings
1485                 assembly {
1486                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1487                     let needledata := and(mload(needleptr), mask)
1488                     let end := add(selfptr, sub(selflen, needlelen))
1489                     ptr := selfptr
1490                     loop:
1491                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1492                     ptr := add(ptr, 1)
1493                     jumpi(loop, lt(sub(ptr, 1), end))
1494                     ptr := add(selfptr, selflen)
1495                     exit:
1496                 }
1497                 return ptr;
1498             } else {
1499                 // For long needles, use hashing
1500                 bytes32 hash;
1501                 assembly { hash := sha3(needleptr, needlelen) }
1502                 ptr = selfptr;
1503                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1504                     bytes32 testHash;
1505                     assembly { testHash := sha3(ptr, needlelen) }
1506                     if (hash == testHash)
1507                         return ptr;
1508                     ptr += 1;
1509                 }
1510             }
1511         }
1512         return selfptr + selflen;
1513     }
1514 
1515     // Returns the memory address of the first byte after the last occurrence of
1516     // `needle` in `self`, or the address of `self` if not found.
1517     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1518         uint ptr;
1519 
1520         if (needlelen <= selflen) {
1521             if (needlelen <= 32) {
1522                 // Optimized assembly for 69 gas per byte on short strings
1523                 assembly {
1524                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1525                     let needledata := and(mload(needleptr), mask)
1526                     ptr := add(selfptr, sub(selflen, needlelen))
1527                     loop:
1528                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1529                     ptr := sub(ptr, 1)
1530                     jumpi(loop, gt(add(ptr, 1), selfptr))
1531                     ptr := selfptr
1532                     jump(exit)
1533                     ret:
1534                     ptr := add(ptr, needlelen)
1535                     exit:
1536                 }
1537                 return ptr;
1538             } else {
1539                 // For long needles, use hashing
1540                 bytes32 hash;
1541                 assembly { hash := sha3(needleptr, needlelen) }
1542                 ptr = selfptr + (selflen - needlelen);
1543                 while (ptr >= selfptr) {
1544                     bytes32 testHash;
1545                     assembly { testHash := sha3(ptr, needlelen) }
1546                     if (hash == testHash)
1547                         return ptr + needlelen;
1548                     ptr -= 1;
1549                 }
1550             }
1551         }
1552         return selfptr;
1553     }
1554 
1555     /*
1556      * @dev Modifies `self` to contain everything from the first occurrence of
1557      *      `needle` to the end of the slice. `self` is set to the empty slice
1558      *      if `needle` is not found.
1559      * @param self The slice to search and modify.
1560      * @param needle The text to search for.
1561      * @return `self`.
1562      */
1563     function find(slice self, slice needle) internal returns (slice) {
1564         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1565         self._len -= ptr - self._ptr;
1566         self._ptr = ptr;
1567         return self;
1568     }
1569 
1570     /*
1571      * @dev Modifies `self` to contain the part of the string from the start of
1572      *      `self` to the end of the first occurrence of `needle`. If `needle`
1573      *      is not found, `self` is set to the empty slice.
1574      * @param self The slice to search and modify.
1575      * @param needle The text to search for.
1576      * @return `self`.
1577      */
1578     function rfind(slice self, slice needle) internal returns (slice) {
1579         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1580         self._len = ptr - self._ptr;
1581         return self;
1582     }
1583 
1584     /*
1585      * @dev Splits the slice, setting `self` to everything after the first
1586      *      occurrence of `needle`, and `token` to everything before it. If
1587      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1588      *      and `token` is set to the entirety of `self`.
1589      * @param self The slice to split.
1590      * @param needle The text to search for in `self`.
1591      * @param token An output parameter to which the first token is written.
1592      * @return `token`.
1593      */
1594     function split(slice self, slice needle, slice token) internal returns (slice) {
1595         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1596         token._ptr = self._ptr;
1597         token._len = ptr - self._ptr;
1598         if (ptr == self._ptr + self._len) {
1599             // Not found
1600             self._len = 0;
1601         } else {
1602             self._len -= token._len + needle._len;
1603             self._ptr = ptr + needle._len;
1604         }
1605         return token;
1606     }
1607 
1608     /*
1609      * @dev Splits the slice, setting `self` to everything after the first
1610      *      occurrence of `needle`, and returning everything before it. If
1611      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1612      *      and the entirety of `self` is returned.
1613      * @param self The slice to split.
1614      * @param needle The text to search for in `self`.
1615      * @return The part of `self` up to the first occurrence of `delim`.
1616      */
1617     function split(slice self, slice needle) internal returns (slice token) {
1618         split(self, needle, token);
1619     }
1620 
1621     /*
1622      * @dev Splits the slice, setting `self` to everything before the last
1623      *      occurrence of `needle`, and `token` to everything after it. If
1624      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1625      *      and `token` is set to the entirety of `self`.
1626      * @param self The slice to split.
1627      * @param needle The text to search for in `self`.
1628      * @param token An output parameter to which the first token is written.
1629      * @return `token`.
1630      */
1631     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1632         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1633         token._ptr = ptr;
1634         token._len = self._len - (ptr - self._ptr);
1635         if (ptr == self._ptr) {
1636             // Not found
1637             self._len = 0;
1638         } else {
1639             self._len -= token._len + needle._len;
1640         }
1641         return token;
1642     }
1643 
1644     /*
1645      * @dev Splits the slice, setting `self` to everything before the last
1646      *      occurrence of `needle`, and returning everything after it. If
1647      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1648      *      and the entirety of `self` is returned.
1649      * @param self The slice to split.
1650      * @param needle The text to search for in `self`.
1651      * @return The part of `self` after the last occurrence of `delim`.
1652      */
1653     function rsplit(slice self, slice needle) internal returns (slice token) {
1654         rsplit(self, needle, token);
1655     }
1656 
1657     /*
1658      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1659      * @param self The slice to search.
1660      * @param needle The text to search for in `self`.
1661      * @return The number of occurrences of `needle` found in `self`.
1662      */
1663     function count(slice self, slice needle) internal returns (uint cnt) {
1664         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1665         while (ptr <= self._ptr + self._len) {
1666             cnt++;
1667             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1668         }
1669     }
1670 
1671     /*
1672      * @dev Returns True if `self` contains `needle`.
1673      * @param self The slice to search.
1674      * @param needle The text to search for in `self`.
1675      * @return True if `needle` is found in `self`, false otherwise.
1676      */
1677     function contains(slice self, slice needle) internal returns (bool) {
1678         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1679     }
1680 
1681     /*
1682      * @dev Returns a newly allocated string containing the concatenation of
1683      *      `self` and `other`.
1684      * @param self The first slice to concatenate.
1685      * @param other The second slice to concatenate.
1686      * @return The concatenation of the two strings.
1687      */
1688     function concat(slice self, slice other) internal returns (string) {
1689         var ret = new string(self._len + other._len);
1690         uint retptr;
1691         assembly { retptr := add(ret, 32) }
1692         memcpy(retptr, self._ptr, self._len);
1693         memcpy(retptr + self._len, other._ptr, other._len);
1694         return ret;
1695     }
1696 
1697     /*
1698      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1699      *      newly allocated string.
1700      * @param self The delimiter to use.
1701      * @param parts A list of slices to join.
1702      * @return A newly allocated string containing all the slices in `parts`,
1703      *         joined with `self`.
1704      */
1705     function join(slice self, slice[] parts) internal returns (string) {
1706         if (parts.length == 0)
1707             return "";
1708 
1709         uint length = self._len * (parts.length - 1);
1710         for(uint i = 0; i < parts.length; i++)
1711             length += parts[i]._len;
1712 
1713         var ret = new string(length);
1714         uint retptr;
1715         assembly { retptr := add(ret, 32) }
1716 
1717         for(i = 0; i < parts.length; i++) {
1718             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1719             retptr += parts[i]._len;
1720             if (i < parts.length - 1) {
1721                 memcpy(retptr, self._ptr, self._len);
1722                 retptr += self._len;
1723             }
1724         }
1725 
1726         return ret;
1727     }
1728 }
1729 
1730 contract Etherlympics is usingOraclize {
1731 	using strings for *;
1732 
1733   // Address info
1734   address owner;
1735   address public BOOKIE = 0x1e0dcc50C15581c4aD9CaC663A8283DACcA53271;
1736 
1737   // Commission stuff
1738   uint public constant BOOKIE_POOL_COMMISSION = 10; 	// The bookies take 10%
1739   uint public constant MINIMUM_BET = 0.01 ether; 		// 0.01 ETH is min bet
1740 
1741   // Date stuff
1742   uint public constant BETTING_OPENS 	        = 1518127200; 		// 2/08/2018 05:00pm EST
1743   uint public constant BETTING_CLOSES           = 1518325140; 		// 2/10/2018 11:59pm EST
1744   uint public constant PAYOUT_ATTEMPT_INTERVAL  = 86400;            // 24 hours
1745   uint public constant PAYOUT_DATE              = 1519671600;       // 2/26/2018 02:00pm EST
1746   uint public constant BET_RELEASE_DATE         = 1520226000;  	    // 3/05/2018 02:00pm EST
1747 
1748     // Country options
1749 	uint public constant NUM_COUNTRIES = 8;
1750 	string[NUM_COUNTRIES] public COUNTRY_NAMES = ["Russia", "United", "Norway", "Canada", "Netherlands", "Germany", "Austria", "France"];
1751 	enum Countries { Russia, USA, Norway, Canada, Netherlands, Germany, Austria, France, None }
1752 	Countries public winningCountry = Countries.None;
1753 	string public winning_country_string;
1754 
1755 	// String things
1756 	string constant NO_RESULTS_YET = "Olympic games in the winter of 2018 have not taken place";
1757 	string constant RESULTS_ARE_IN = "country | gold | silver | bronze | total";
1758 
1759 	// Keep track of payout completion and scheduling
1760   bool public scheduledPayout;
1761   bool public payoutCompleted;
1762 
1763 
1764 
1765   struct Better {
1766     uint[NUM_COUNTRIES] amountsBet;
1767 		uint hasBet;
1768   }
1769 
1770 	// Create info store of betters
1771   mapping(address => Better) betterInfo;
1772   address[] betters;
1773 
1774 	// Store bet info
1775   uint[NUM_COUNTRIES] public totalAmountsBet;
1776   uint public numberOfBets;
1777   uint public totalBetAmount;
1778 
1779 
1780   /* Events */
1781 
1782   event BetMade();
1783 
1784   /* Modifiers */
1785 
1786   // Modifier to only allow the execution of
1787   // payout related functions when olympic medals are determined
1788   modifier canPerformPayout() {
1789     if (winningCountry != Countries.None && !payoutCompleted && now > BETTING_CLOSES) _;
1790   }
1791 
1792   // Modifier to only allow the execution of
1793   // certain functions when betting is closed
1794   modifier bettingIsClosed() {
1795     if (now > BETTING_CLOSES) _;
1796   }
1797 
1798   // Modifier to only allow the execution of
1799   // certain functions restricted to the bookies
1800   modifier onlyBookieLevel() {
1801     require( BOOKIE == msg.sender);
1802     _;
1803   }
1804 
1805   /* Functions */
1806 
1807   // Constructor
1808   function Etherlympics() public {
1809     owner = msg.sender;
1810     //pingOracle(PAYOUT_DATE - now); // Schedule payout at first manual scheduled time
1811     oraclize_query(PAYOUT_DATE - now, "WolframAlpha", "2018 olympic results");
1812   }
1813 
1814   function pingOracle(uint pingDelay) private {
1815     // Schedule the determination of winning country
1816     // at the delay passed. This can be triggered
1817     // multiple times, but as soon as the payout occurs
1818     // the function does not do anything
1819     oraclize_query(pingDelay, "WolframAlpha", "2018 olympic results");
1820   }
1821 
1822 	// Substring utility function
1823 	function substring(string str, uint startIndex, uint endIndex) private constant returns (string) {
1824     bytes memory strBytes = bytes(str);
1825     bytes memory result = new bytes(endIndex-startIndex);
1826     for(uint i = startIndex; i < endIndex; i++) {
1827         result[i-startIndex] = strBytes[i];
1828     }
1829     return string(result);
1830 	}
1831 
1832   // Callback from Oraclize
1833   function __callback(bytes32 queryId, string result, bytes proof) public {
1834     require(payoutCompleted == false);
1835     require(msg.sender == oraclize_cbAddress());
1836 
1837     // Check for the "no results yet" string in the result:
1838 		if (keccak256(NO_RESULTS_YET) == keccak256(result)) {
1839 			winningCountry = Countries.None;
1840 		} else {
1841 			// Get first word on the second line - this is the winning country
1842 			var resultSlice = result.toSlice();
1843 			resultSlice.split("\n".toSlice());
1844 
1845 			// resultSlice now containts everything BUT the first line of the result
1846 			// next, we split on the first space.
1847 			var winning_country_slice = resultSlice.split(" ".toSlice());
1848 			winning_country_string = winning_country_slice.toString();
1849 
1850 			if (strCompare(COUNTRY_NAMES[0], winning_country_string) == 0) {
1851 				winningCountry = Countries(0);
1852 			} else if (strCompare(COUNTRY_NAMES[1], winning_country_string) == 0) {
1853 				winningCountry = Countries(1);
1854 			} else if (strCompare(COUNTRY_NAMES[2], winning_country_string) == 0) {
1855 				winningCountry = Countries(2);
1856 			} else if (strCompare(COUNTRY_NAMES[3], winning_country_string) == 0) {
1857 				winningCountry = Countries(3);
1858 			} else if (strCompare(COUNTRY_NAMES[4], winning_country_string) == 0) {
1859 				winningCountry = Countries(4);
1860 			} else if (strCompare(COUNTRY_NAMES[5], winning_country_string) == 0) {
1861 				winningCountry = Countries(5);
1862 			} else if (strCompare(COUNTRY_NAMES[6], winning_country_string) == 0) {
1863 				winningCountry = Countries(6);
1864 			} else if (strCompare(COUNTRY_NAMES[7], winning_country_string) == 0) {
1865 				winningCountry = Countries(7);
1866 			}
1867 		}
1868 
1869     // If there's an error (failed authenticity proof, result
1870     // didn't match any country), then we reschedule the
1871     // query for later.
1872     if (winningCountry == Countries.None) {
1873       // Except for if we are past the point of releasing bets.
1874       if (now >= BET_RELEASE_DATE)
1875         return releaseBets();
1876       return pingOracle(PAYOUT_ATTEMPT_INTERVAL);
1877     }
1878 
1879     performPayout();
1880   }
1881 
1882   // Returns the total amounts betted for
1883   // the sender
1884   function getUserBets() public constant returns(uint[NUM_COUNTRIES]) {
1885     return betterInfo[msg.sender].amountsBet;
1886   }
1887 
1888   // Release all the bets back to the betters
1889   // if, for any reason, payouts cannot be
1890   // completed
1891   function releaseBets() private {
1892     uint storedBalance = this.balance;
1893     for (uint k = 0; k < betters.length; k++) {
1894       uint totalBet = betterInfo[betters[k]].amountsBet[0] + betterInfo[betters[k]].amountsBet[1];
1895       betters[k].transfer(totalBet * storedBalance / totalBetAmount);
1896     }
1897   }
1898 
1899   // Returns true if we can bet (in betting window)
1900   function canBet() public constant returns(bool) {
1901     return (now >= BETTING_OPENS && now < BETTING_CLOSES);
1902   }
1903 
1904   // We (bookies) can trigger a payout
1905   // immediately, before the scheduled payout,
1906   // if the data source has already been updated.
1907   // This is so people can get their $$$ ASAP.
1908   function triggerPayout() public onlyBookieLevel {
1909     pingOracle(0);
1910   }
1911 
1912   // Function for user to bet on team idx
1913   function bet(uint countryIdx) public payable {
1914     require(canBet() == true);
1915     require(countryIdx >= 0 && countryIdx < 8);
1916     require(msg.value >= MINIMUM_BET);
1917 
1918     // Add better to better list if they
1919     // aren't already in it
1920     if (betterInfo[msg.sender].hasBet != 1) {
1921       betters.push(msg.sender);
1922 			betterInfo[msg.sender].hasBet = 1;
1923 		}
1924 
1925     // Perform bet
1926     betterInfo[msg.sender].amountsBet[countryIdx] += msg.value;
1927     numberOfBets++;
1928     totalBetAmount += msg.value;
1929     totalAmountsBet[countryIdx] += msg.value;
1930     BetMade(); // Trigger event
1931   }
1932 
1933   // Performs payout based on winning team
1934   function performPayout() private canPerformPayout {
1935     // Calculate total pool of ETH
1936     // betted for all different teams,
1937     // and for the winning pool.
1938 
1939     uint losingChunk = this.balance - totalAmountsBet[uint(winningCountry)];
1940     uint bookiePayout = losingChunk / BOOKIE_POOL_COMMISSION; // Payout to the bookies; commission of losing pot
1941 
1942     // Equal weight payout to the bookies
1943     BOOKIE.transfer(bookiePayout);
1944 
1945     // Weighted payout to betters based on
1946     // their contribution to the winning pool
1947     for (uint k = 0; k < betters.length; k++) {
1948       uint betOnWinner = betterInfo[betters[k]].amountsBet[uint(winningCountry)];
1949       uint payout = betOnWinner + ((betOnWinner * (losingChunk - bookiePayout)) / totalAmountsBet[uint(winningCountry)]);
1950 
1951       if (payout > 0)
1952         betters[k].transfer(payout);
1953     }
1954 
1955     payoutCompleted = true;
1956   }
1957 }