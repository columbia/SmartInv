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
1021 EthFlip
1022 
1023 Copyright (c) 2018 Maxwell Black
1024 
1025 Permission is hereby granted, free of charge, to any person obtaining a copy
1026 of this software and associated documentation files (the "Software"), to deal
1027 in the Software without restriction, including without limitation the rights
1028 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1029 copies of the Software, and to permit persons to whom the Software is
1030 furnished to do so, subject to the following conditions:
1031 
1032 The above copyright notice and this permission notice shall be included in
1033 all copies or substantial portions of the Software.
1034 
1035 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1036 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1037 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
1038 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1039 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1040 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
1041 THE SOFTWARE.
1042 */
1043 
1044 contract EthFlip is usingOraclize {
1045     
1046   // Bet archival
1047   struct Bet {
1048     bool win;
1049     uint betValue;
1050     uint timestamp;
1051     address playerAddress;
1052   }
1053   
1054   // Player archival
1055 //   struct Player {
1056 //     uint[] orderedPastBetValues;
1057 //     uint[] orderedPastBetNumbers;
1058 //     bool[] orderedPastBetWins;
1059 //     uint totalBet;
1060 //     uint totalWon;
1061 //   }
1062     
1063   // Oraclize query callback data preservation
1064   struct QueryMap {
1065     uint betValue;
1066     address playerAddress;
1067   }
1068   
1069   // Game parameters
1070   bool private gamePaused;
1071   uint private minBet;
1072   uint private maxBet;
1073   uint private houseFee;
1074   uint private oraclizeGas;
1075   uint private oraclizeGasPrice;
1076   address private owner;
1077   
1078   // Static game information
1079   uint private currentQueryId;
1080   uint private currentBetNumber;
1081   uint private totalPayouts;
1082   uint private totalWins;
1083   uint private totalLosses;
1084 
1085   // Epoch variables
1086   bool private win;
1087   uint private randomNumber;
1088 //   mapping (address => Player) private playerBetData;
1089   mapping (uint => Bet) private pastBets;
1090   mapping (uint => QueryMap) private queryIdMap;
1091   
1092   // Events
1093   event BetComplete(bool _win, uint _betNumber, uint _betValue, uint _timestamp, address _playerAddress);
1094   event GameStatusUpdate(bool _paused);
1095   event MinBetUpdate(uint _newMin);
1096   event MaxBetUpdate(uint _newMax);
1097   event HouseFeeUpdate(uint _newFee);
1098   event OwnerUpdate(address _newOwner);
1099 //   event QueryIdRetrieved(bytes32 _queryId);
1100 //   event QueryIdConverted(uint _queryId);
1101 //   event QueryIdBetValueAdded(uint _queryId, uint _betValue);
1102 //   event QueryIdBetPlayerAddressAdded(uint _queryId, address _playerAddress);
1103 //   event CallbackInitiatedWithParameters(bytes32 _queryId, string _result, bytes _proof);
1104 //   event ProofVerifySuccess(bool _success);
1105 //   event CurrentQueryIdSet(uint _queryId);
1106 //   event RandomNumberGenerated(uint _randomNumber);
1107 //   event AmountToPayoutSet(uint _amount);
1108 //   event PlayerLost(bool _lost);
1109 //   event SecondaryPayoutVariableSet(uint _payout);
1110 //   event PlayerAddressPriorToPayoutIs(address _address);
1111 //   event CurrentBetIncremented(uint _currentBetNumber);
1112   
1113   // Modifiers
1114   modifier gameIsActive {
1115     require(!gamePaused);
1116     _;
1117   }
1118   
1119   modifier gameIsNotActive {
1120     require(gamePaused);
1121     _;
1122   }
1123   
1124   modifier senderIsOwner {
1125     require(msg.sender == owner);
1126     _;
1127   }
1128   
1129   modifier senderIsOraclize {
1130     require(msg.sender == oraclize_cbAddress());
1131     _;
1132   }
1133   
1134   modifier sentEnoughForBet {
1135     require(msg.value >= minBet);
1136     _;
1137   }
1138   
1139   modifier didNotSendOverMaxBet {
1140     require(msg.value <= maxBet);
1141     _;
1142   }
1143 
1144   // Constructor
1145   function EthFlip() public {
1146     minBet = 100000000000000000;
1147     maxBet = 500000000000000000;
1148     houseFee = 29; // 2.9%
1149     oraclizeGas = 500001;
1150     oraclizeGasPrice = 3010000000;
1151     oraclize_setCustomGasPrice(oraclizeGasPrice);
1152     oraclize_setProof(proofType_Ledger);
1153     owner = msg.sender;
1154   }
1155   
1156   // Fallback
1157   function() public payable {}
1158 
1159   // Placing a bet
1160   function placeBet() public payable gameIsActive sentEnoughForBet didNotSendOverMaxBet {
1161     secureGenerateNumber(msg.sender, msg.value);
1162   }
1163   
1164   // Securely generate number randomly
1165   function secureGenerateNumber(address _playerAddress, uint _betValue) private {
1166     bytes32 queryId = oraclize_newRandomDSQuery(0, 2, oraclizeGas);
1167     // QueryIdRetrieved(queryId);
1168     uint convertedId = uint(keccak256(queryId));
1169     // QueryIdConverted(convertedId);
1170     queryIdMap[convertedId].betValue = _betValue;
1171     // QueryIdBetValueAdded(convertedId, queryIdMap[convertedId].betValue);
1172     queryIdMap[convertedId].playerAddress = _playerAddress;
1173     // QueryIdBetPlayerAddressAdded(convertedId, queryIdMap[convertedId].playerAddress);
1174   }
1175   
1176   // Check if the player won
1177   function checkIfWon() private {
1178     if (randomNumber <= 50) {
1179       win = true;
1180       sendPayout(subtractHouseFee(queryIdMap[currentQueryId].betValue*2));
1181     } else {
1182       win = false;
1183     //   PlayerLost(true);
1184     }
1185     logBet();
1186   }
1187   
1188   // Winner payout
1189   function sendPayout(uint _amountToPayout) private {
1190     uint payout = _amountToPayout;
1191     // SecondaryPayoutVariableSet(payout);
1192     _amountToPayout = 0;
1193     // PlayerAddressPriorToPayoutIs(queryIdMap[currentQueryId].playerAddress);
1194     queryIdMap[currentQueryId].playerAddress.transfer(payout);
1195   }
1196   
1197   // Helpers
1198   function subtractHouseFee(uint _amount) private returns (uint _result) {
1199     return (_amount*(1000-houseFee))/1000;
1200   }
1201   
1202   function logBet() private {
1203     // Disable logging to save gas on initial release
1204     
1205     // // Static updates
1206     currentBetNumber++;
1207     // CurrentBetIncremented(currentBetNumber);
1208     if (win) {
1209       totalWins++;
1210       totalPayouts += queryIdMap[currentQueryId].betValue;
1211     } else {
1212       totalLosses++;
1213     }
1214     // 
1215     // // Player updates
1216     // playerBetData[queryIdMap[currentQueryId].playerAddress].orderedPastBetValues.push(queryIdMap[currentQueryId].betValue);
1217     // playerBetData[queryIdMap[currentQueryId].playerAddress].orderedPastBetNumbers.push(currentBetNumber);
1218     // playerBetData[queryIdMap[currentQueryId].playerAddress].orderedPastBetWins.push(win);
1219     // playerBetData[queryIdMap[currentQueryId].playerAddress].totalBet += queryIdMap[currentQueryId].betValue;
1220     // if (win) playerBetData[queryIdMap[currentQueryId].playerAddress].totalWon += queryIdMap[currentQueryId].betValue;
1221     
1222     // Bets updates
1223     pastBets[currentBetNumber] = Bet({win:win, betValue:queryIdMap[currentQueryId].betValue, timestamp:block.timestamp, playerAddress:queryIdMap[currentQueryId].playerAddress});
1224   
1225     // Emit complete event
1226     BetComplete(win, currentBetNumber, queryIdMap[currentQueryId].betValue, block.timestamp, queryIdMap[currentQueryId].playerAddress);
1227   }
1228   
1229   // Static information getters
1230   function getLastBetNumber() constant public returns (uint) {
1231     return currentBetNumber;
1232   }
1233   
1234   function getTotalPayouts() constant public returns (uint) {
1235     return totalPayouts;
1236   }
1237   
1238   function getTotalWins() constant public returns (uint) {
1239     return totalWins;
1240   }
1241   
1242   function getTotalLosses() constant public returns (uint) {
1243     return totalLosses;
1244   }
1245   
1246   // Game information getters
1247   function getBalance() constant public returns (uint) {
1248     return this.balance;
1249   }
1250   
1251   function getGamePaused() constant public returns (bool) {
1252       return gamePaused;
1253   }
1254   
1255   function getMinBet() constant public returns (uint) {
1256       return minBet;
1257   }
1258   
1259   function getMaxBet() constant public returns (uint) {
1260       return maxBet;
1261   }
1262   
1263   function getHouseFee() constant public returns (uint) {
1264       return houseFee;
1265   }
1266   
1267   function getOraclizeGas() constant public returns (uint) {
1268       return oraclizeGas;
1269   }
1270   
1271   function getOraclizeGasPrice() constant public returns (uint) {
1272       return oraclizeGasPrice;
1273   }
1274   
1275   function getOwnerAddress() constant public returns (address) {
1276       return owner;
1277   }
1278   
1279 //   function getPlayerBetData(address _playerAddress) constant public returns (uint[] _orderedPastBetValues, uint[] _orderedPastBetNumbers, bool[] _orderedPastBetWins, uint _totalBet, uint _totalWon) {
1280 //     Player memory player = playerBetData[_playerAddress];
1281 //     return (player.orderedPastBetValues, player.orderedPastBetNumbers, player.orderedPastBetWins, player.totalBet, player.totalWon);
1282 //   }
1283 //   
1284   function getPastBet(uint _betNumber) constant public returns (bool _win, uint _betValue, uint _timestamp, address _playerAddress) {
1285     require(currentBetNumber >= _betNumber);
1286     return (pastBets[_betNumber].win, pastBets[_betNumber].betValue, pastBets[_betNumber].timestamp, pastBets[_betNumber].playerAddress);
1287   }
1288   
1289   // Owner only setters
1290   // Changes made here only apply while the game is PAUSED (with notification on the website), so all participants
1291   // may audit the contract on unpause prior to placing bets in the proceeding rounds; in addition, all changes will
1292   // be updated on the website simultaneously to ensure everyone is informed prior to placing bets
1293   function pauseGame() public senderIsOwner gameIsActive {
1294     gamePaused = true;
1295     GameStatusUpdate(true);
1296   }
1297   
1298   function resumeGame() public senderIsOwner gameIsNotActive {
1299     gamePaused = false;
1300     GameStatusUpdate(false);
1301   }
1302   
1303   function setMaxBet(uint _newMax) public senderIsOwner gameIsNotActive {
1304     require(_newMax >= 100000000000000000);
1305     maxBet = _newMax;
1306     MaxBetUpdate(_newMax);
1307   }
1308   
1309   function setMinBet(uint _newMin) public senderIsOwner gameIsNotActive {
1310     require(_newMin >= 100000000000000000);
1311     minBet = _newMin;
1312     MinBetUpdate(_newMin);
1313   }
1314   
1315   function setHouseFee(uint _newFee) public senderIsOwner gameIsNotActive {
1316     require(_newFee <= 100);
1317     houseFee = _newFee;
1318     HouseFeeUpdate(_newFee);
1319   }
1320   
1321   function setOraclizeGas(uint _newGas) public senderIsOwner gameIsNotActive {
1322     oraclizeGas = _newGas;
1323   }
1324   
1325   function setOraclizeGasPrice(uint _newPrice) public senderIsOwner gameIsNotActive {
1326     oraclizeGasPrice = _newPrice + 10000000;
1327     oraclize_setCustomGasPrice(oraclizeGasPrice);
1328   }
1329   
1330   function setOwner(address _newOwner) public senderIsOwner gameIsNotActive {
1331     owner = _newOwner;
1332     OwnerUpdate(_newOwner);
1333   }
1334   
1335   function selfDestruct() public senderIsOwner gameIsNotActive {
1336     selfdestruct(owner);
1337   }
1338   
1339   // Oraclize random number function
1340   // the callback function is called by Oraclize when the result is ready
1341   // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
1342   // the proof validity is fully verified on-chain
1343   function __callback(bytes32 _queryId, string _result, bytes _proof) public senderIsOraclize {
1344     // CallbackInitiatedWithParameters(_queryId, _result, _proof);
1345      currentQueryId = uint(keccak256(_queryId));
1346     //  CurrentQueryIdSet(currentQueryId);
1347     if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0) {
1348     //   ProofVerifySuccess(true);
1349       randomNumber = (uint(keccak256(_result)) % 100) + 1;
1350     //   RandomNumberGenerated(randomNumber);
1351       checkIfWon();
1352     } else {
1353     //   ProofVerifySuccess(false);
1354       uint refundValue = queryIdMap[currentQueryId].betValue;
1355       queryIdMap[currentQueryId].betValue = 0;
1356       queryIdMap[currentQueryId].playerAddress.transfer(refundValue);
1357     }
1358   }
1359 }