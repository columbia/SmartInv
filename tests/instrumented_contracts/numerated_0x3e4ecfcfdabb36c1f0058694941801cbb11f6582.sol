1 // WELCOME TO THE EOSBET.IO BUG BOUNTY CONTRACTS!
2 // GOOD LUCK... YOU'LL NEED IT!
3 
4 pragma solidity ^0.4.21;
5 
6 // <ORACLIZE_API>
7 /*
8 Copyright (c) 2015-2016 Oraclize SRL
9 Copyright (c) 2016 Oraclize LTD
10 
11 
12 
13 Permission is hereby granted, free of charge, to any person obtaining a copy
14 of this software and associated documentation files (the "Software"), to deal
15 in the Software without restriction, including without limitation the rights
16 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
17 copies of the Software, and to permit persons to whom the Software is
18 furnished to do so, subject to the following conditions:
19 
20 
21 
22 The above copyright notice and this permission notice shall be included in
23 all copies or substantial portions of the Software.
24 
25 
26 
27 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
30 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
33 THE SOFTWARE.
34 */
35 
36 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
37 pragma solidity ^0.4.18;
38 
39 contract OraclizeI {
40     address public cbAddress;
41     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
42     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
43     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
44     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
45     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
46     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
47     function getPrice(string _datasource) public returns (uint _dsprice);
48     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
49     function setProofType(byte _proofType) external;
50     function setCustomGasPrice(uint _gasPrice) external;
51     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
52 }
53 contract OraclizeAddrResolverI {
54     function getAddress() public returns (address _addr);
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
76         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
77             oraclize_setNetwork(networkID_auto);
78 
79         if(address(oraclize) != OAR.getAddress())
80             oraclize = OraclizeI(OAR.getAddress());
81 
82         _;
83     }
84     modifier coupon(string code){
85         oraclize = OraclizeI(OAR.getAddress());
86         _;
87     }
88 
89     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
90       return oraclize_setNetwork();
91       networkID; // silence the warning and remain backwards compatible
92     }
93     function oraclize_setNetwork() internal returns(bool){
94         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
95             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
96             oraclize_setNetworkName("eth_mainnet");
97             return true;
98         }
99         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
100             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
101             oraclize_setNetworkName("eth_ropsten3");
102             return true;
103         }
104         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
105             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
106             oraclize_setNetworkName("eth_kovan");
107             return true;
108         }
109         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
110             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
111             oraclize_setNetworkName("eth_rinkeby");
112             return true;
113         }
114         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
115             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
116             return true;
117         }
118         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
119             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
120             return true;
121         }
122         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
123             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
124             return true;
125         }
126         return false;
127     }
128 
129     function __callback(bytes32 myid, string result) public {
130         __callback(myid, result, new bytes(0));
131     }
132     function __callback(bytes32 myid, string result, bytes proof) public {
133       return;
134       myid; result; proof; // Silence compiler warnings
135     }
136 
137     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
138         return oraclize.getPrice(datasource);
139     }
140 
141     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
142         return oraclize.getPrice(datasource, gaslimit);
143     }
144 
145     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
146         uint price = oraclize.getPrice(datasource);
147         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
148         return oraclize.query.value(price)(0, datasource, arg);
149     }
150     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
151         uint price = oraclize.getPrice(datasource);
152         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
153         return oraclize.query.value(price)(timestamp, datasource, arg);
154     }
155     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
156         uint price = oraclize.getPrice(datasource, gaslimit);
157         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
158         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
159     }
160     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
161         uint price = oraclize.getPrice(datasource, gaslimit);
162         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
163         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
164     }
165     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
166         uint price = oraclize.getPrice(datasource);
167         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
168         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
169     }
170     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
171         uint price = oraclize.getPrice(datasource);
172         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
173         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
174     }
175     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
176         uint price = oraclize.getPrice(datasource, gaslimit);
177         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
178         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
179     }
180     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
181         uint price = oraclize.getPrice(datasource, gaslimit);
182         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
183         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
184     }
185     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
186         uint price = oraclize.getPrice(datasource);
187         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
188         bytes memory args = stra2cbor(argN);
189         return oraclize.queryN.value(price)(0, datasource, args);
190     }
191     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
192         uint price = oraclize.getPrice(datasource);
193         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
194         bytes memory args = stra2cbor(argN);
195         return oraclize.queryN.value(price)(timestamp, datasource, args);
196     }
197     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
198         uint price = oraclize.getPrice(datasource, gaslimit);
199         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
200         bytes memory args = stra2cbor(argN);
201         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
202     }
203     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
204         uint price = oraclize.getPrice(datasource, gaslimit);
205         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
206         bytes memory args = stra2cbor(argN);
207         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
208     }
209     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
210         string[] memory dynargs = new string[](1);
211         dynargs[0] = args[0];
212         return oraclize_query(datasource, dynargs);
213     }
214     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
215         string[] memory dynargs = new string[](1);
216         dynargs[0] = args[0];
217         return oraclize_query(timestamp, datasource, dynargs);
218     }
219     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
220         string[] memory dynargs = new string[](1);
221         dynargs[0] = args[0];
222         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
223     }
224     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
225         string[] memory dynargs = new string[](1);
226         dynargs[0] = args[0];
227         return oraclize_query(datasource, dynargs, gaslimit);
228     }
229 
230     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
231         string[] memory dynargs = new string[](2);
232         dynargs[0] = args[0];
233         dynargs[1] = args[1];
234         return oraclize_query(datasource, dynargs);
235     }
236     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
237         string[] memory dynargs = new string[](2);
238         dynargs[0] = args[0];
239         dynargs[1] = args[1];
240         return oraclize_query(timestamp, datasource, dynargs);
241     }
242     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
243         string[] memory dynargs = new string[](2);
244         dynargs[0] = args[0];
245         dynargs[1] = args[1];
246         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
247     }
248     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
249         string[] memory dynargs = new string[](2);
250         dynargs[0] = args[0];
251         dynargs[1] = args[1];
252         return oraclize_query(datasource, dynargs, gaslimit);
253     }
254     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
255         string[] memory dynargs = new string[](3);
256         dynargs[0] = args[0];
257         dynargs[1] = args[1];
258         dynargs[2] = args[2];
259         return oraclize_query(datasource, dynargs);
260     }
261     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
262         string[] memory dynargs = new string[](3);
263         dynargs[0] = args[0];
264         dynargs[1] = args[1];
265         dynargs[2] = args[2];
266         return oraclize_query(timestamp, datasource, dynargs);
267     }
268     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
269         string[] memory dynargs = new string[](3);
270         dynargs[0] = args[0];
271         dynargs[1] = args[1];
272         dynargs[2] = args[2];
273         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
274     }
275     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
276         string[] memory dynargs = new string[](3);
277         dynargs[0] = args[0];
278         dynargs[1] = args[1];
279         dynargs[2] = args[2];
280         return oraclize_query(datasource, dynargs, gaslimit);
281     }
282 
283     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
284         string[] memory dynargs = new string[](4);
285         dynargs[0] = args[0];
286         dynargs[1] = args[1];
287         dynargs[2] = args[2];
288         dynargs[3] = args[3];
289         return oraclize_query(datasource, dynargs);
290     }
291     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
292         string[] memory dynargs = new string[](4);
293         dynargs[0] = args[0];
294         dynargs[1] = args[1];
295         dynargs[2] = args[2];
296         dynargs[3] = args[3];
297         return oraclize_query(timestamp, datasource, dynargs);
298     }
299     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
300         string[] memory dynargs = new string[](4);
301         dynargs[0] = args[0];
302         dynargs[1] = args[1];
303         dynargs[2] = args[2];
304         dynargs[3] = args[3];
305         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
306     }
307     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
308         string[] memory dynargs = new string[](4);
309         dynargs[0] = args[0];
310         dynargs[1] = args[1];
311         dynargs[2] = args[2];
312         dynargs[3] = args[3];
313         return oraclize_query(datasource, dynargs, gaslimit);
314     }
315     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
316         string[] memory dynargs = new string[](5);
317         dynargs[0] = args[0];
318         dynargs[1] = args[1];
319         dynargs[2] = args[2];
320         dynargs[3] = args[3];
321         dynargs[4] = args[4];
322         return oraclize_query(datasource, dynargs);
323     }
324     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
325         string[] memory dynargs = new string[](5);
326         dynargs[0] = args[0];
327         dynargs[1] = args[1];
328         dynargs[2] = args[2];
329         dynargs[3] = args[3];
330         dynargs[4] = args[4];
331         return oraclize_query(timestamp, datasource, dynargs);
332     }
333     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
334         string[] memory dynargs = new string[](5);
335         dynargs[0] = args[0];
336         dynargs[1] = args[1];
337         dynargs[2] = args[2];
338         dynargs[3] = args[3];
339         dynargs[4] = args[4];
340         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
341     }
342     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
343         string[] memory dynargs = new string[](5);
344         dynargs[0] = args[0];
345         dynargs[1] = args[1];
346         dynargs[2] = args[2];
347         dynargs[3] = args[3];
348         dynargs[4] = args[4];
349         return oraclize_query(datasource, dynargs, gaslimit);
350     }
351     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
352         uint price = oraclize.getPrice(datasource);
353         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
354         bytes memory args = ba2cbor(argN);
355         return oraclize.queryN.value(price)(0, datasource, args);
356     }
357     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
358         uint price = oraclize.getPrice(datasource);
359         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
360         bytes memory args = ba2cbor(argN);
361         return oraclize.queryN.value(price)(timestamp, datasource, args);
362     }
363     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
364         uint price = oraclize.getPrice(datasource, gaslimit);
365         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
366         bytes memory args = ba2cbor(argN);
367         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
368     }
369     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
370         uint price = oraclize.getPrice(datasource, gaslimit);
371         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
372         bytes memory args = ba2cbor(argN);
373         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
374     }
375     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
376         bytes[] memory dynargs = new bytes[](1);
377         dynargs[0] = args[0];
378         return oraclize_query(datasource, dynargs);
379     }
380     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
381         bytes[] memory dynargs = new bytes[](1);
382         dynargs[0] = args[0];
383         return oraclize_query(timestamp, datasource, dynargs);
384     }
385     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
386         bytes[] memory dynargs = new bytes[](1);
387         dynargs[0] = args[0];
388         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
389     }
390     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
391         bytes[] memory dynargs = new bytes[](1);
392         dynargs[0] = args[0];
393         return oraclize_query(datasource, dynargs, gaslimit);
394     }
395 
396     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
397         bytes[] memory dynargs = new bytes[](2);
398         dynargs[0] = args[0];
399         dynargs[1] = args[1];
400         return oraclize_query(datasource, dynargs);
401     }
402     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
403         bytes[] memory dynargs = new bytes[](2);
404         dynargs[0] = args[0];
405         dynargs[1] = args[1];
406         return oraclize_query(timestamp, datasource, dynargs);
407     }
408     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
409         bytes[] memory dynargs = new bytes[](2);
410         dynargs[0] = args[0];
411         dynargs[1] = args[1];
412         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
413     }
414     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
415         bytes[] memory dynargs = new bytes[](2);
416         dynargs[0] = args[0];
417         dynargs[1] = args[1];
418         return oraclize_query(datasource, dynargs, gaslimit);
419     }
420     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
421         bytes[] memory dynargs = new bytes[](3);
422         dynargs[0] = args[0];
423         dynargs[1] = args[1];
424         dynargs[2] = args[2];
425         return oraclize_query(datasource, dynargs);
426     }
427     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
428         bytes[] memory dynargs = new bytes[](3);
429         dynargs[0] = args[0];
430         dynargs[1] = args[1];
431         dynargs[2] = args[2];
432         return oraclize_query(timestamp, datasource, dynargs);
433     }
434     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
435         bytes[] memory dynargs = new bytes[](3);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         dynargs[2] = args[2];
439         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
440     }
441     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
442         bytes[] memory dynargs = new bytes[](3);
443         dynargs[0] = args[0];
444         dynargs[1] = args[1];
445         dynargs[2] = args[2];
446         return oraclize_query(datasource, dynargs, gaslimit);
447     }
448 
449     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
450         bytes[] memory dynargs = new bytes[](4);
451         dynargs[0] = args[0];
452         dynargs[1] = args[1];
453         dynargs[2] = args[2];
454         dynargs[3] = args[3];
455         return oraclize_query(datasource, dynargs);
456     }
457     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
458         bytes[] memory dynargs = new bytes[](4);
459         dynargs[0] = args[0];
460         dynargs[1] = args[1];
461         dynargs[2] = args[2];
462         dynargs[3] = args[3];
463         return oraclize_query(timestamp, datasource, dynargs);
464     }
465     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
466         bytes[] memory dynargs = new bytes[](4);
467         dynargs[0] = args[0];
468         dynargs[1] = args[1];
469         dynargs[2] = args[2];
470         dynargs[3] = args[3];
471         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
472     }
473     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         bytes[] memory dynargs = new bytes[](4);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         dynargs[2] = args[2];
478         dynargs[3] = args[3];
479         return oraclize_query(datasource, dynargs, gaslimit);
480     }
481     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
482         bytes[] memory dynargs = new bytes[](5);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         dynargs[2] = args[2];
486         dynargs[3] = args[3];
487         dynargs[4] = args[4];
488         return oraclize_query(datasource, dynargs);
489     }
490     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
491         bytes[] memory dynargs = new bytes[](5);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         dynargs[2] = args[2];
495         dynargs[3] = args[3];
496         dynargs[4] = args[4];
497         return oraclize_query(timestamp, datasource, dynargs);
498     }
499     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
500         bytes[] memory dynargs = new bytes[](5);
501         dynargs[0] = args[0];
502         dynargs[1] = args[1];
503         dynargs[2] = args[2];
504         dynargs[3] = args[3];
505         dynargs[4] = args[4];
506         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
507     }
508     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
509         bytes[] memory dynargs = new bytes[](5);
510         dynargs[0] = args[0];
511         dynargs[1] = args[1];
512         dynargs[2] = args[2];
513         dynargs[3] = args[3];
514         dynargs[4] = args[4];
515         return oraclize_query(datasource, dynargs, gaslimit);
516     }
517 
518     function oraclize_cbAddress() oraclizeAPI internal returns (address){
519         return oraclize.cbAddress();
520     }
521     function oraclize_setProof(byte proofP) oraclizeAPI internal {
522         return oraclize.setProofType(proofP);
523     }
524     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
525         return oraclize.setCustomGasPrice(gasPrice);
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
538     function parseAddr(string _a) internal pure returns (address){
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
558     function strCompare(string _a, string _b) internal pure returns (int) {
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
576     function indexOf(string _haystack, string _needle) internal pure returns (int) {
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
603     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
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
620     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
621         return strConcat(_a, _b, _c, _d, "");
622     }
623 
624     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
625         return strConcat(_a, _b, _c, "", "");
626     }
627 
628     function strConcat(string _a, string _b) internal pure returns (string) {
629         return strConcat(_a, _b, "", "", "");
630     }
631 
632     // parseInt
633     function parseInt(string _a) internal pure returns (uint) {
634         return parseInt(_a, 0);
635     }
636 
637     // parseInt(parseFloat*10^_b)
638     function parseInt(string _a, uint _b) internal pure returns (uint) {
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
656     function uint2str(uint i) internal pure returns (string){
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
673     function stra2cbor(string[] arr) internal pure returns (bytes) {
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
715     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
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
763     function oraclize_getNetworkName() internal view returns (string) {
764         return oraclize_network_name;
765     }
766 
767     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
768         require((_nbytes > 0) && (_nbytes <= 32));
769         // Convert from seconds to ledger timer ticks
770         _delay *= 10; 
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
782         bytes memory delay = new bytes(32);
783         assembly { 
784             mstore(add(delay, 0x20), _delay) 
785         }
786         
787         bytes memory delay_bytes8 = new bytes(8);
788         copyBytes(delay, 24, 8, delay_bytes8, 0);
789 
790         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
791         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
792         
793         bytes memory delay_bytes8_left = new bytes(8);
794         
795         assembly {
796             let x := mload(add(delay_bytes8, 0x20))
797             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
798             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
799             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
800             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
801             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
802             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
803             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
804             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
805 
806         }
807         
808         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
809         return queryId;
810     }
811     
812     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
813         oraclize_randomDS_args[queryId] = commitment;
814     }
815 
816     mapping(bytes32=>bytes32) oraclize_randomDS_args;
817     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
818 
819     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
820         bool sigok;
821         address signer;
822 
823         bytes32 sigr;
824         bytes32 sigs;
825 
826         bytes memory sigr_ = new bytes(32);
827         uint offset = 4+(uint(dersig[3]) - 0x20);
828         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
829         bytes memory sigs_ = new bytes(32);
830         offset += 32 + 2;
831         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
832 
833         assembly {
834             sigr := mload(add(sigr_, 32))
835             sigs := mload(add(sigs_, 32))
836         }
837 
838 
839         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
840         if (address(keccak256(pubkey)) == signer) return true;
841         else {
842             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
843             return (address(keccak256(pubkey)) == signer);
844         }
845     }
846 
847     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
848         bool sigok;
849 
850         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
851         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
852         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
853 
854         bytes memory appkey1_pubkey = new bytes(64);
855         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
856 
857         bytes memory tosign2 = new bytes(1+65+32);
858         tosign2[0] = byte(1); //role
859         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
860         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
861         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
862         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
863 
864         if (sigok == false) return false;
865 
866 
867         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
868         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
869 
870         bytes memory tosign3 = new bytes(1+65);
871         tosign3[0] = 0xFE;
872         copyBytes(proof, 3, 65, tosign3, 1);
873 
874         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
875         copyBytes(proof, 3+65, sig3.length, sig3, 0);
876 
877         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
878 
879         return sigok;
880     }
881 
882     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
883         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
884         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
885 
886         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
887         require(proofVerified);
888 
889         _;
890     }
891 
892     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
893         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
894         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
895 
896         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
897         if (proofVerified == false) return 2;
898 
899         return 0;
900     }
901 
902     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
903         bool match_ = true;
904         
905         require(prefix.length == n_random_bytes);
906 
907         for (uint256 i=0; i< n_random_bytes; i++) {
908             if (content[i] != prefix[i]) match_ = false;
909         }
910 
911         return match_;
912     }
913 
914     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
915 
916         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
917         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
918         bytes memory keyhash = new bytes(32);
919         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
920         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
921 
922         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
923         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
924 
925         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
926         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
927 
928         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
929         // This is to verify that the computed args match with the ones specified in the query.
930         bytes memory commitmentSlice1 = new bytes(8+1+32);
931         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
932 
933         bytes memory sessionPubkey = new bytes(64);
934         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
935         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
936 
937         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
938         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
939             delete oraclize_randomDS_args[queryId];
940         } else return false;
941 
942 
943         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
944         bytes memory tosign1 = new bytes(32+8+1+32);
945         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
946         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
947 
948         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
949         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
950             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
951         }
952 
953         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
954     }
955 
956     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
957     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
958         uint minLength = length + toOffset;
959 
960         // Buffer too small
961         require(to.length >= minLength); // Should be a better way?
962 
963         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
964         uint i = 32 + fromOffset;
965         uint j = 32 + toOffset;
966 
967         while (i < (32 + fromOffset + length)) {
968             assembly {
969                 let tmp := mload(add(from, i))
970                 mstore(add(to, j), tmp)
971             }
972             i += 32;
973             j += 32;
974         }
975 
976         return to;
977     }
978 
979     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
980     // Duplicate Solidity's ecrecover, but catching the CALL return value
981     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
982         // We do our own memory management here. Solidity uses memory offset
983         // 0x40 to store the current end of memory. We write past it (as
984         // writes are memory extensions), but don't update the offset so
985         // Solidity will reuse it. The memory used here is only needed for
986         // this context.
987 
988         // FIXME: inline assembly can't access return values
989         bool ret;
990         address addr;
991 
992         assembly {
993             let size := mload(0x40)
994             mstore(size, hash)
995             mstore(add(size, 32), v)
996             mstore(add(size, 64), r)
997             mstore(add(size, 96), s)
998 
999             // NOTE: we can reuse the request memory because we deal with
1000             //       the return code
1001             ret := call(3000, 1, 0, size, 128, size, 32)
1002             addr := mload(size)
1003         }
1004 
1005         return (ret, addr);
1006     }
1007 
1008     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1009     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1010         bytes32 r;
1011         bytes32 s;
1012         uint8 v;
1013 
1014         if (sig.length != 65)
1015           return (false, 0);
1016 
1017         // The signature format is a compact form of:
1018         //   {bytes32 r}{bytes32 s}{uint8 v}
1019         // Compact means, uint8 is not padded to 32 bytes.
1020         assembly {
1021             r := mload(add(sig, 32))
1022             s := mload(add(sig, 64))
1023 
1024             // Here we are loading the last 32 bytes. We exploit the fact that
1025             // 'mload' will pad with zeroes if we overread.
1026             // There is no 'mload8' to do this, but that would be nicer.
1027             v := byte(0, mload(add(sig, 96)))
1028 
1029             // Alternative solution:
1030             // 'byte' is not working due to the Solidity parser, so lets
1031             // use the second best option, 'and'
1032             // v := and(mload(add(sig, 65)), 255)
1033         }
1034 
1035         // albeit non-transactional signatures are not specified by the YP, one would expect it
1036         // to match the YP range of [27, 28]
1037         //
1038         // geth uses [0, 1] and some clients have followed. This might change, see:
1039         //  https://github.com/ethereum/go-ethereum/issues/2053
1040         if (v < 27)
1041           v += 27;
1042 
1043         if (v != 27 && v != 28)
1044             return (false, 0);
1045 
1046         return safer_ecrecover(hash, v, r, s);
1047     }
1048 
1049 }
1050 // </ORACLIZE_API>
1051 
1052 contract EOSBetGameInterface {
1053 	uint256 public DEVELOPERSFUND;
1054 	uint256 public LIABILITIES;
1055 	function payDevelopersFund(address developer) public;
1056 	function receivePaymentForOraclize() payable public;
1057 	function getMaxWin() public view returns(uint256);
1058 }
1059 
1060 contract EOSBetBankrollInterface {
1061 	function payEtherToWinner(uint256 amtEther, address winner) public;
1062 	function receiveEtherFromGameAddress() payable public;
1063 	function payOraclize(uint256 amountToPay) public;
1064 	function getBankroll() public view returns(uint256);
1065 }
1066 
1067 contract ERC20 {
1068 	function totalSupply() constant public returns (uint supply);
1069 	function balanceOf(address _owner) constant public returns (uint balance);
1070 	function transfer(address _to, uint _value) public returns (bool success);
1071 	function transferFrom(address _from, address _to, uint _value) public returns (bool success);
1072 	function approve(address _spender, uint _value) public returns (bool success);
1073 	function allowance(address _owner, address _spender) constant public returns (uint remaining);
1074 	event Transfer(address indexed _from, address indexed _to, uint _value);
1075 	event Approval(address indexed _owner, address indexed _spender, uint _value);
1076 }
1077 
1078 contract EOSBetBankroll is ERC20, EOSBetBankrollInterface {
1079 
1080 	using SafeMath for *;
1081 
1082 	// constants for EOSBet Bankroll
1083 
1084 	address public OWNER;
1085 	uint256 public MAXIMUMINVESTMENTSALLOWED;
1086 	uint256 public WAITTIMEUNTILWITHDRAWORTRANSFER;
1087 	uint256 public DEVELOPERSFUND;
1088 
1089 	// this will be initialized as the trusted game addresses which will forward their ether
1090 	// to the bankroll contract, and when players win, they will request the bankroll contract 
1091 	// to send these players their winnings.
1092 	// Feel free to audit these contracts on etherscan...
1093 	mapping(address => bool) public TRUSTEDADDRESSES;
1094 
1095 	address public DICE;
1096 	address public SLOTS;
1097 
1098 	// mapping to log the last time a user contributed to the bankroll 
1099 	mapping(address => uint256) contributionTime;
1100 
1101 	// constants for ERC20 standard
1102 	string public constant name = "EOSBet Stake Tokens";
1103 	string public constant symbol = "EOSBETST";
1104 	uint8 public constant decimals = 18;
1105 	// variable total supply
1106 	uint256 public totalSupply;
1107 
1108 	// mapping to store tokens
1109 	mapping(address => uint256) public balances;
1110 	mapping(address => mapping(address => uint256)) public allowed;
1111 
1112 	// events
1113 	event FundBankroll(address contributor, uint256 etherContributed, uint256 tokensReceived);
1114 	event CashOut(address contributor, uint256 etherWithdrawn, uint256 tokensCashedIn);
1115 	event FailedSend(address sendTo, uint256 amt);
1116 
1117 	// checks that an address is a "trusted address of a legitimate EOSBet game"
1118 	modifier addressInTrustedAddresses(address thisAddress){
1119 
1120 		require(TRUSTEDADDRESSES[thisAddress]);
1121 		_;
1122 	}
1123 
1124 	// initialization function 
1125 	function EOSBetBankroll(address dice, address slots) public payable {
1126 		// function is payable, owner of contract MUST "seed" contract with some ether, 
1127 		// so that the ratios are correct when tokens are being minted
1128 		require (msg.value > 0);
1129 
1130 		OWNER = msg.sender;
1131 
1132 		// 100 tokens/ether is the inital seed amount, so:
1133 		uint256 initialTokens = msg.value * 100;
1134 		balances[msg.sender] = initialTokens;
1135 		totalSupply = initialTokens;
1136 
1137 		// log a mint tokens event
1138 		emit Transfer(0x0, msg.sender, initialTokens);
1139 
1140 		// insert given game addresses into the TRUSTEDADDRESSES mapping, and save the addresses as global variables
1141 		TRUSTEDADDRESSES[dice] = true;
1142 		TRUSTEDADDRESSES[slots] = true;
1143 
1144 		DICE = dice;
1145 		SLOTS = slots;
1146 
1147 		////////////////////////////////////////////////
1148 		// CHANGE TO 6 HOURS ON LIVE DEPLOYMENT
1149 		////////////////////////////////////////////////
1150 		WAITTIMEUNTILWITHDRAWORTRANSFER = 0 seconds;
1151 		MAXIMUMINVESTMENTSALLOWED = 500 ether;
1152 	}
1153 
1154 	///////////////////////////////////////////////
1155 	// VIEW FUNCTIONS
1156 	/////////////////////////////////////////////// 
1157 
1158 	function checkWhenContributorCanTransferOrWithdraw(address bankrollerAddress) view public returns(uint256){
1159 		return contributionTime[bankrollerAddress];
1160 	}
1161 
1162 	function getBankroll() view public returns(uint256){
1163 		// returns the total balance minus the developers fund, as the amount of active bankroll
1164 		return SafeMath.sub(address(this).balance, DEVELOPERSFUND);
1165 	}
1166 
1167 	///////////////////////////////////////////////
1168 	// BANKROLL CONTRACT <-> GAME CONTRACTS functions
1169 	/////////////////////////////////////////////// 
1170 
1171 	function payEtherToWinner(uint256 amtEther, address winner) public addressInTrustedAddresses(msg.sender){
1172 		// this function will get called by a game contract when someone wins a game
1173 		// try to send, if it fails, then send the amount to the owner
1174 		// note, this will only happen if someone is calling the betting functions with
1175 		// a contract. They are clearly up to no good, so they can contact us to retreive 
1176 		// their ether
1177 		// if the ether cannot be sent to us, the OWNER, that means we are up to no good, 
1178 		// and the ether will just be given to the bankrollers as if the player/owner lost 
1179 
1180 		if (! winner.send(amtEther)){
1181 
1182 			emit FailedSend(winner, amtEther);
1183 
1184 			if (! OWNER.send(amtEther)){
1185 
1186 				emit FailedSend(OWNER, amtEther);
1187 			}
1188 		}
1189 	}
1190 
1191 	function receiveEtherFromGameAddress() payable public addressInTrustedAddresses(msg.sender){
1192 		// this function will get called from the game contracts when someone starts a game.
1193 	}
1194 
1195 	function payOraclize(uint256 amountToPay) public addressInTrustedAddresses(msg.sender){
1196 		// this function will get called when a game contract must pay payOraclize
1197 		EOSBetGameInterface(msg.sender).receivePaymentForOraclize.value(amountToPay)();
1198 	}
1199 
1200 	///////////////////////////////////////////////
1201 	// BANKROLL CONTRACT MAIN FUNCTIONS
1202 	///////////////////////////////////////////////
1203 
1204 
1205 	// this function ADDS to the bankroll of EOSBet, and credits the bankroller a proportional
1206 	// amount of tokens so they may withdraw their tokens later
1207 	// also if there is only a limited amount of space left in the bankroll, a user can just send as much 
1208 	// ether as they want, because they will be able to contribute up to the maximum, and then get refunded the rest.
1209 	function () public payable {
1210 
1211 		// save in memory for cheap access.
1212 		// this represents the total bankroll balance before the function was called.
1213 		uint256 currentTotalBankroll = SafeMath.sub(getBankroll(), msg.value);
1214 		uint256 maxInvestmentsAllowed = MAXIMUMINVESTMENTSALLOWED;
1215 
1216 		require(currentTotalBankroll < maxInvestmentsAllowed && msg.value != 0);
1217 
1218 		uint256 currentSupplyOfTokens = totalSupply;
1219 		uint256 contributedEther;
1220 
1221 		bool contributionTakesBankrollOverLimit;
1222 		uint256 ifContributionTakesBankrollOverLimit_Refund;
1223 
1224 		uint256 creditedTokens;
1225 
1226 		if (SafeMath.add(currentTotalBankroll, msg.value) > maxInvestmentsAllowed){
1227 			// allow the bankroller to contribute up to the allowed amount of ether, and refund the rest.
1228 			contributionTakesBankrollOverLimit = true;
1229 			// set contributed ether as (MAXIMUMINVESTMENTSALLOWED - BANKROLL)
1230 			contributedEther = SafeMath.sub(maxInvestmentsAllowed, currentTotalBankroll);
1231 			// refund the rest of the ether, which is (original amount sent - (maximum amount allowed - bankroll))
1232 			ifContributionTakesBankrollOverLimit_Refund = SafeMath.sub(msg.value, contributedEther);
1233 		}
1234 		else {
1235 			contributedEther = msg.value;
1236 		}
1237         
1238 		if (currentSupplyOfTokens != 0){
1239 			// determine the ratio of contribution versus total BANKROLL.
1240 			creditedTokens = SafeMath.mul(contributedEther, currentSupplyOfTokens) / currentTotalBankroll;
1241 		}
1242 		else {
1243 			// edge case where ALL money was cashed out from bankroll
1244 			// so currentSupplyOfTokens == 0
1245 			// currentTotalBankroll can == 0 or not, if someone mines/selfdestruct's to the contract
1246 			// but either way, give all the bankroll to person who deposits ether
1247 			creditedTokens = SafeMath.mul(contributedEther, 100);
1248 		}
1249 		
1250 		// now update the total supply of tokens and bankroll amount
1251 		totalSupply = SafeMath.add(currentSupplyOfTokens, creditedTokens);
1252 
1253 		// now credit the user with his amount of contributed tokens 
1254 		balances[msg.sender] = SafeMath.add(balances[msg.sender], creditedTokens);
1255 
1256 		// update his contribution time for stake time locking
1257 		contributionTime[msg.sender] = block.timestamp;
1258 
1259 		// now look if the attempted contribution would have taken the BANKROLL over the limit, 
1260 		// and if true, refund the excess ether.
1261 		if (contributionTakesBankrollOverLimit){
1262 			msg.sender.transfer(ifContributionTakesBankrollOverLimit_Refund);
1263 		}
1264 
1265 		// log an event about funding bankroll
1266 		emit FundBankroll(msg.sender, contributedEther, creditedTokens);
1267 
1268 		// log a mint tokens event
1269 		emit Transfer(0x0, msg.sender, creditedTokens);
1270 	}
1271 
1272 	function cashoutEOSBetStakeTokens(uint256 _amountTokens) public {
1273 		// In effect, this function is the OPPOSITE of the un-named payable function above^^^
1274 		// this allows bankrollers to "cash out" at any time, and receive the ether that they contributed, PLUS
1275 		// a proportion of any ether that was earned by the smart contact when their ether was "staking", However
1276 		// this works in reverse as well. Any net losses of the smart contract will be absorbed by the player in like manner.
1277 		// Of course, due to the constant house edge, a bankroller that leaves their ether in the contract long enough
1278 		// is effectively guaranteed to withdraw more ether than they originally "staked"
1279 
1280 		// save in memory for cheap access.
1281 		uint256 tokenBalance = balances[msg.sender];
1282 		// verify that the contributor has enough tokens to cash out this many, and has waited the required time.
1283 		require(_amountTokens <= tokenBalance 
1284 			&& contributionTime[msg.sender] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp
1285 			&& _amountTokens > 0);
1286 
1287 		// save in memory for cheap access.
1288 		// again, represents the total balance of the contract before the function was called.
1289 		uint256 currentTotalBankroll = getBankroll();
1290 		uint256 currentSupplyOfTokens = totalSupply;
1291 
1292 		// calculate the token withdraw ratio based on current supply 
1293 		uint256 withdrawEther = SafeMath.mul(_amountTokens, currentTotalBankroll) / currentSupplyOfTokens;
1294 
1295 		// developers take 1% of withdrawls 
1296 		uint256 developersCut = withdrawEther / 100;
1297 		uint256 contributorAmount = SafeMath.sub(withdrawEther, developersCut);
1298 
1299 		// now update the total supply of tokens by subtracting the tokens that are being "cashed in"
1300 		totalSupply = SafeMath.sub(currentSupplyOfTokens, _amountTokens);
1301 
1302 		// and update the users supply of tokens 
1303 		balances[msg.sender] = SafeMath.sub(tokenBalance, _amountTokens);
1304 
1305 		// update the developers fund based on this calculated amount 
1306 		DEVELOPERSFUND = SafeMath.add(DEVELOPERSFUND, developersCut);
1307 
1308 		// lastly, transfer the ether back to the bankroller. Thanks for your contribution!
1309 		msg.sender.transfer(contributorAmount);
1310 
1311 		// log an event about cashout
1312 		emit CashOut(msg.sender, contributorAmount, _amountTokens);
1313 
1314 		// log a destroy tokens event
1315 		emit Transfer(msg.sender, 0x0, _amountTokens);
1316 	}
1317 
1318 	// TO CALL THIS FUNCTION EASILY, SEND A 0 ETHER TRANSACTION TO THIS CONTRACT WITH EXTRA DATA: 0x7a09588b
1319 	function cashoutEOSBetStakeTokens_ALL() public {
1320 
1321 		// just forward to cashoutEOSBetStakeTokens with input as the senders entire balance
1322 		cashoutEOSBetStakeTokens(balances[msg.sender]);
1323 	}
1324 
1325 	////////////////////
1326 	// OWNER FUNCTIONS:
1327 	////////////////////
1328 	// Please, be aware that the owner ONLY can change:
1329 		// 1. The owner can increase or decrease the target amount for a game. They can then call the updater function to give/receive the ether from the game.
1330 		// 1. The wait time until a user can withdraw or transfer their tokens after purchase through the default function above ^^^
1331 		// 2. The owner can change the maximum amount of investments allowed. This allows for early contributors to guarantee
1332 		// 		a certain percentage of the bankroll so that their stake cannot be diluted immediately. However, be aware that the 
1333 		//		maximum amount of investments allowed will be raised over time. This will allow for higher bets by gamblers, resulting
1334 		// 		in higher dividends for the bankrollers
1335 		// 3. The owner can freeze payouts to bettors. This will be used in case of an emergency, and the contract will reject all
1336 		//		new bets as well. This does not mean that bettors will lose their money without recompense. They will be allowed to call the 
1337 		// 		"refund" function in the respective game smart contract once payouts are un-frozen.
1338 		// 4. Finally, the owner can modify and withdraw the developers reward, which will fund future development, including new games, a sexier frontend,
1339 		// 		and TRUE DAO governance so that onlyOwner functions don't have to exist anymore ;) and in order to effectively react to changes 
1340 		// 		in the market (lower the percentage because of increased competition in the blockchain casino space, etc.)
1341 
1342 	function transferOwnership(address newOwner) public {
1343 		require(msg.sender == OWNER);
1344 
1345 		OWNER = newOwner;
1346 	}
1347 
1348 	function changeWaitTimeUntilWithdrawOrTransfer(uint256 waitTime) public {
1349 		// waitTime MUST be less than or equal to 10 weeks
1350 		require (msg.sender == OWNER && waitTime <= 6048000);
1351 
1352 		WAITTIMEUNTILWITHDRAWORTRANSFER = waitTime;
1353 	}
1354 
1355 	function changeMaximumInvestmentsAllowed(uint256 maxAmount) public {
1356 		require(msg.sender == OWNER);
1357 
1358 		MAXIMUMINVESTMENTSALLOWED = maxAmount;
1359 	}
1360 
1361 
1362 	function withdrawDevelopersFund(address receiver) public {
1363 		require(msg.sender == OWNER);
1364 
1365 		// first get developers fund from each game 
1366         EOSBetGameInterface(DICE).payDevelopersFund(receiver);
1367 		EOSBetGameInterface(SLOTS).payDevelopersFund(receiver);
1368 
1369 		// now send the developers fund from the main contract.
1370 		uint256 developersFund = DEVELOPERSFUND;
1371 
1372 		// set developers fund to zero
1373 		DEVELOPERSFUND = 0;
1374 
1375 		// transfer this amount to the owner!
1376 		receiver.transfer(developersFund);
1377 	}
1378 
1379 	// Can be removed after some testing...
1380 	function emergencySelfDestruct() public {
1381 		require(msg.sender == OWNER);
1382 
1383 		selfdestruct(msg.sender);
1384 	}
1385 
1386 	///////////////////////////////
1387 	// BASIC ERC20 TOKEN OPERATIONS
1388 	///////////////////////////////
1389 
1390 	function totalSupply() constant public returns(uint){
1391 		return totalSupply;
1392 	}
1393 
1394 	function balanceOf(address _owner) constant public returns(uint){
1395 		return balances[_owner];
1396 	}
1397 
1398 	// don't allow transfers before the required wait-time
1399 	// and don't allow transfers to this contract addr, it'll just kill tokens
1400 	function transfer(address _to, uint256 _value) public returns (bool success){
1401 		if (balances[msg.sender] >= _value 
1402 			&& _value > 0 
1403 			&& contributionTime[msg.sender] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp
1404 			&& _to != address(this)){
1405 
1406 			// safely subtract
1407 			balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
1408 			balances[_to] = SafeMath.add(balances[_to], _value);
1409 
1410 			// log event 
1411 			emit Transfer(msg.sender, _to, _value);
1412 			return true;
1413 		}
1414 		else {
1415 			return false;
1416 		}
1417 	}
1418 
1419 	// don't allow transfers before the required wait-time
1420 	// and don't allow transfers to the contract addr, it'll just kill tokens
1421 	function transferFrom(address _from, address _to, uint _value) public returns(bool){
1422 		if (allowed[_from][msg.sender] >= _value 
1423 			&& balances[_from] >= _value 
1424 			&& _value > 0 
1425 			&& contributionTime[_from] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp
1426 			&& _to != address(this)){
1427 
1428 			// safely add to _to and subtract from _from, and subtract from allowed balances.
1429 			balances[_to] = SafeMath.add(balances[_to], _value);
1430 	   		balances[_from] = SafeMath.sub(balances[_from], _value);
1431 	  		allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
1432 
1433 	  		// log event
1434     		emit Transfer(_from, _to, _value);
1435     		return true;
1436    		} 
1437     	else { 
1438     		return false;
1439     	}
1440 	}
1441 	
1442 	function approve(address _spender, uint _value) public returns(bool){
1443 		if(_value > 0){
1444 
1445 			allowed[msg.sender][_spender] = _value;
1446 			emit Approval(msg.sender, _spender, _value);
1447 			// log event
1448 			return true;
1449 		}
1450 		else {
1451 			return false;
1452 		}
1453 	}
1454 	
1455 	function allowance(address _owner, address _spender) constant public returns(uint){
1456 		return allowed[_owner][_spender];
1457 	}
1458 }
1459 
1460 /**
1461  * @title SafeMath
1462  * @dev Math operations with safety checks that throw on error
1463  */
1464 library SafeMath {
1465 
1466   /**
1467   * @dev Multiplies two numbers, throws on overflow.
1468   */
1469   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1470     if (a == 0) {
1471       return 0;
1472     }
1473     uint256 c = a * b;
1474     assert(c / a == b);
1475     return c;
1476   }
1477 
1478   /**
1479   * @dev Integer division of two numbers, truncating the quotient.
1480   */
1481   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1482     // assert(b > 0); // Solidity automatically throws when dividing by 0
1483     uint256 c = a / b;
1484     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1485     return c;
1486   }
1487 
1488   /**
1489   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1490   */
1491   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1492     assert(b <= a);
1493     return a - b;
1494   }
1495 
1496   /**
1497   * @dev Adds two numbers, throws on overflow.
1498   */
1499   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1500     uint256 c = a + b;
1501     assert(c >= a);
1502     return c;
1503   }
1504 }
1505 
1506 contract EOSBetSlots is usingOraclize, EOSBetGameInterface {
1507 
1508 	using SafeMath for *;
1509 
1510 	// events
1511 	event BuyCredits(bytes32 indexed oraclizeQueryId);
1512 	event LedgerProofFailed(bytes32 indexed oraclizeQueryId);
1513 	event Refund(bytes32 indexed oraclizeQueryId, uint256 amount);
1514 	event SlotsLargeBet(bytes32 indexed oraclizeQueryId, uint256 data1, uint256 data2, uint256 data3, uint256 data4, uint256 data5, uint256 data6, uint256 data7, uint256 data8);
1515 	event SlotsSmallBet(uint256 data1, uint256 data2, uint256 data3, uint256 data4, uint256 data5, uint256 data6, uint256 data7, uint256 data8);
1516 
1517 	// slots game structure
1518 	struct SlotsGameData {
1519 		address player;
1520 		bool paidOut;
1521 		uint256 start;
1522 		uint256 etherReceived;
1523 		uint8 credits;
1524 	}
1525 
1526 	mapping (bytes32 => SlotsGameData) public slotsData;
1527 
1528 	// ether in this contract can be in one of two locations:
1529 	uint256 public LIABILITIES;
1530 	uint256 public DEVELOPERSFUND;
1531 
1532 	// counters for frontend statistics
1533 	uint256 public AMOUNTWAGERED;
1534 	uint256 public DIALSSPUN;
1535 	
1536 	// togglable values
1537 	uint256 public ORACLIZEQUERYMAXTIME;
1538 	uint256 public MINBET_forORACLIZE;
1539 	uint256 public MINBET;
1540 	uint256 public ORACLIZEGASPRICE;
1541 	uint256 public INITIALGASFORORACLIZE;
1542 	uint16 public MAXWIN_inTHOUSANDTHPERCENTS;
1543 
1544 	// togglable functionality of contract
1545 	bool public GAMEPAUSED;
1546 	bool public REFUNDSACTIVE;
1547 
1548 	// owner of contract
1549 	address public OWNER;
1550 
1551 	// bankroller address
1552 	address public BANKROLLER;
1553 
1554 	// constructor
1555 	function EOSBetSlots() public {
1556 		// ledger proof is ALWAYS verified on-chain
1557 		oraclize_setProof(proofType_Ledger);
1558 
1559 		// gas prices for oraclize call back, can be changed
1560 		oraclize_setCustomGasPrice(10000000000);
1561 		ORACLIZEGASPRICE = 10000000000;
1562 		INITIALGASFORORACLIZE = 225000;
1563 
1564 		AMOUNTWAGERED = 0;
1565 		DIALSSPUN = 0;
1566 
1567 		GAMEPAUSED = false;
1568 		REFUNDSACTIVE = true;
1569 
1570 		ORACLIZEQUERYMAXTIME = 6 hours;
1571 		MINBET_forORACLIZE = 350 finney; // 0.35 ether is the max bet to avoid miner cheating. see python sim. on our github
1572 		MINBET = 1 finney; // currently, this is ~40-50c a spin, which is pretty average slots. This is changeable by OWNER 
1573         MAXWIN_inTHOUSANDTHPERCENTS = 300; // 300/1000 so a jackpot can take 30% of bankroll (extremely rare)
1574         OWNER = msg.sender;
1575 	}
1576 
1577 	////////////////////////////////////
1578 	// INTERFACE CONTACT FUNCTIONS
1579 	////////////////////////////////////
1580 
1581 	function payDevelopersFund(address developer) public {
1582 		require(msg.sender == BANKROLLER);
1583 
1584 		uint256 devFund = DEVELOPERSFUND;
1585 
1586 		DEVELOPERSFUND = 0;
1587 
1588 		developer.transfer(devFund);
1589 	}
1590 
1591 	// just a function to receive eth, only allow the bankroll to use this
1592 	function receivePaymentForOraclize() payable public {
1593 		require(msg.sender == BANKROLLER);
1594 	}
1595 
1596 	////////////////////////////////////
1597 	// VIEW FUNCTIONS
1598 	////////////////////////////////////
1599 
1600 	function getMaxWin() public view returns(uint256){
1601 		return (SafeMath.mul(EOSBetBankrollInterface(BANKROLLER).getBankroll(), MAXWIN_inTHOUSANDTHPERCENTS) / 1000);
1602 	}
1603 
1604 	////////////////////////////////////
1605 	// OWNER ONLY FUNCTIONS
1606 	////////////////////////////////////
1607 
1608 	// WARNING!!!!! Can only set this function once!
1609 	function setBankrollerContractOnce(address bankrollAddress) public {
1610 		// require that BANKROLLER address == 0x0 (address not set yet), and coming from owner.
1611 		require(msg.sender == OWNER && BANKROLLER == address(0));
1612 
1613 		// check here to make sure that the bankroll contract is legitimate
1614 		// just make sure that calling the bankroll contract getBankroll() returns non-zero
1615 
1616 		require(EOSBetBankrollInterface(bankrollAddress).getBankroll() != 0);
1617 
1618 		BANKROLLER = bankrollAddress;
1619 	}
1620 
1621 	function transferOwnership(address newOwner) public {
1622 		require(msg.sender == OWNER);
1623 
1624 		OWNER = newOwner;
1625 	}
1626 
1627 	function setOraclizeQueryMaxTime(uint256 newTime) public {
1628 		require(msg.sender == OWNER);
1629 
1630 		ORACLIZEQUERYMAXTIME = newTime;
1631 	}
1632 
1633 	// store the gas price as a storage variable for easy reference,
1634 	// and thne change the gas price using the proper oraclize function
1635 	function setOraclizeQueryGasPrice(uint256 gasPrice) public {
1636 		require(msg.sender == OWNER);
1637 
1638 		ORACLIZEGASPRICE = gasPrice;
1639 		oraclize_setCustomGasPrice(gasPrice);
1640 	}
1641 
1642 	// should be ~160,000 to save eth
1643 	function setInitialGasForOraclize(uint256 gasAmt) public {
1644 		require(msg.sender == OWNER);
1645 
1646 		INITIALGASFORORACLIZE = gasAmt;
1647 	}
1648 
1649 	function setGamePaused(bool paused) public {
1650 		require(msg.sender == OWNER);
1651 
1652 		GAMEPAUSED = paused;
1653 	}
1654 
1655 	function setRefundsActive(bool active) public {
1656 		require(msg.sender == OWNER);
1657 
1658 		REFUNDSACTIVE = active;
1659 	}
1660 
1661 	// setting this to 0 would just force all bets through oraclize, and setting to MAX_UINT_256 would never use oraclize 
1662 	function setMinBetForOraclize(uint256 minBet) public {
1663 		require(msg.sender == OWNER);
1664 
1665 		MINBET_forORACLIZE = minBet;
1666 	}
1667 
1668 	function setMinBet(uint256 minBet) public {
1669 		require(msg.sender == OWNER && minBet > 1000);
1670 
1671 		MINBET = minBet;
1672 	}
1673 
1674 	function setMaxwin(uint16 newMaxWinInThousandthPercents) public {
1675 		require(msg.sender == OWNER && newMaxWinInThousandthPercents <= 333); // cannot set max win greater than 1/3 of the bankroll (a jackpot is very rare)
1676 
1677 		MAXWIN_inTHOUSANDTHPERCENTS = newMaxWinInThousandthPercents;
1678 	}
1679 
1680 	// this can be deleted after some testing.
1681 	function emergencySelfDestruct() public {
1682 		require(msg.sender == OWNER);
1683 
1684 		selfdestruct(msg.sender);
1685 	}
1686 
1687 	function refund(bytes32 oraclizeQueryId) public {
1688 		// save into memory for cheap access
1689 		SlotsGameData memory data = slotsData[oraclizeQueryId];
1690 
1691 		//require that the query time is too slow, bet has not been paid out, and either contract owner or player is calling this function.
1692 		require(SafeMath.sub(block.timestamp, data.start) >= ORACLIZEQUERYMAXTIME
1693 			&& (msg.sender == OWNER || msg.sender == data.player)
1694 			&& (!data.paidOut)
1695 			&& data.etherReceived <= LIABILITIES
1696 			&& data.etherReceived > 0
1697 			&& REFUNDSACTIVE);
1698 
1699 		// set contract data
1700 		slotsData[oraclizeQueryId].paidOut = true;
1701 
1702 		// subtract etherReceived from these two values because the bet is being refunded
1703 		LIABILITIES = SafeMath.sub(LIABILITIES, data.etherReceived);
1704 
1705 		// then transfer the original bet to the player.
1706 		data.player.transfer(data.etherReceived);
1707 
1708 		// finally, log an event saying that the refund has processed.
1709 		emit Refund(oraclizeQueryId, data.etherReceived);
1710 	}
1711 
1712 	function play(uint8 credits) public payable {
1713 		// save for future use / gas efficiency
1714 		uint256 betPerCredit = msg.value / credits;
1715 
1716 		// require that the game is unpaused, and that the credits being purchased are greater than 0 and less than the allowed amount, default: 100 spins 
1717 		// verify that the bet is less than or equal to the bet limit, so we don't go bankrupt, and that the etherreceived is greater than the minbet.
1718 		require(!GAMEPAUSED
1719 			&& msg.value > 0
1720 			&& betPerCredit >= MINBET
1721 			&& credits > 0 
1722 			&& credits <= 224
1723 			&& SafeMath.mul(betPerCredit, 5000) <= getMaxWin()); // 5000 is the jackpot payout (max win on a roll)
1724 
1725 		// if each bet is relatively small, resolve the bet in-house
1726 		if (betPerCredit < MINBET_forORACLIZE){
1727 
1728 			// randomness will be determined by keccak256(blockhash, nonce)
1729 			// store these into memory for cheap access
1730 			bytes32 blockHash = block.blockhash(block.number);
1731 
1732 			// use dialsSpun as a nonce for the oraclize return random bytes.
1733 			uint256 dialsSpun;
1734 
1735 			// dial1, dial2, dial3 are the items that the wheel lands on, represented by uints 0-6
1736 			// these are then echoed to the front end by data1, data2, data3
1737 			uint8 dial1;
1738 			uint8 dial2;
1739 			uint8 dial3;
1740 
1741 			// these are used ONLY for log data for the frontend
1742 			// each dial of the machine can be between 0 and 6 (see below table for distribution)
1743 			// therefore, each dial takes 3 BITS of space -> uint(bits('111')) == 7, uint(bits('000')) == 0
1744 			// so dataX can hold 256 bits/(3 bits * 3 dials) = 28.444 -> 28 spins worth of data 
1745 			uint256[] memory logsData = new uint256[](8);
1746 
1747 			// this is incremented every time a player hits a spot of the wheel that pays out
1748 			// at the end this is multiplied by the betPerCredit amount to determine how much the game should payout.
1749 			uint256 payout;
1750 
1751 			// Now, loop over each credit.
1752 			// Please note that this loop is almost identical to the loop in the __callback from oraclize
1753 			// Modular-izing the loops into a single function is impossible because solidity can only store 16 variables into memory
1754 			// also, it would cost increased gas for each spin.
1755 			for (uint8 i = 0; i < credits; i++){
1756 
1757 				// spin the first dial
1758 				dialsSpun += 1;
1759 				dial1 = uint8(uint(keccak256(blockHash, dialsSpun)) % 64);
1760 				// spin the second dial
1761 				dialsSpun += 1;
1762 				dial2 = uint8(uint(keccak256(blockHash, dialsSpun)) % 64);
1763 				// spin the third dial
1764 				dialsSpun += 1;
1765 				dial3 = uint8(uint(keccak256(blockHash, dialsSpun)) % 64);
1766 
1767 				// dial 1, based on above table
1768 				dial1 = getDial1Type(dial1);
1769 
1770 				// dial 2, based on above table
1771 				dial2 = getDial2Type(dial2);
1772 
1773 				// dial 3, based on above table
1774 				dial3 = getDial3Type(dial3);
1775 
1776 				// determine the payouts (all in uint8)
1777 
1778 				payout += determinePayout(dial1, dial2, dial3);
1779 
1780 				// Here we assemble uint256's of log data so that the frontend can "replay" the spins
1781 				// each "dial" is a uint8 but can only be between 0-6, so would only need 3 bits to store this. uint(bits('111')) = 7
1782 				// 2 ** 3 is the bitshift operator for three bits 
1783 				if (i <= 27){
1784 					// in logsData0
1785 					logsData[0] += uint256(dial1) * uint256(2) ** (3 * ((3 * (27 - i)) + 2));
1786 					logsData[0] += uint256(dial2) * uint256(2) ** (3 * ((3 * (27 - i)) + 1));
1787 					logsData[0] += uint256(dial3) * uint256(2) ** (3 * ((3 * (27 - i))));
1788 				}
1789 				else if (i <= 55){
1790 					// in logsData1
1791 					logsData[1] += uint256(dial1) * uint256(2) ** (3 * ((3 * (55 - i)) + 2));
1792 					logsData[1] += uint256(dial2) * uint256(2) ** (3 * ((3 * (55 - i)) + 1));
1793 					logsData[1] += uint256(dial3) * uint256(2) ** (3 * ((3 * (55 - i))));
1794 				}
1795 				else if (i <= 83) {
1796 					// in logsData2
1797 					logsData[2] += uint256(dial1) * uint256(2) ** (3 * ((3 * (83 - i)) + 2));
1798 					logsData[2] += uint256(dial2) * uint256(2) ** (3 * ((3 * (83 - i)) + 1));
1799 					logsData[2] += uint256(dial3) * uint256(2) ** (3 * ((3 * (83 - i))));
1800 				}
1801 				else if (i <= 111) {
1802 					// in logsData3
1803 					logsData[3] += uint256(dial1) * uint256(2) ** (3 * ((3 * (111 - i)) + 2));
1804 					logsData[3] += uint256(dial2) * uint256(2) ** (3 * ((3 * (111 - i)) + 1));
1805 					logsData[3] += uint256(dial3) * uint256(2) ** (3 * ((3 * (111 - i))));
1806 				}
1807 				else if (i <= 139){
1808 					// in logsData4
1809 					logsData[4] += uint256(dial1) * uint256(2) ** (3 * ((3 * (139 - i)) + 2));
1810 					logsData[4] += uint256(dial2) * uint256(2) ** (3 * ((3 * (139 - i)) + 1));
1811 					logsData[4] += uint256(dial3) * uint256(2) ** (3 * ((3 * (139 - i))));
1812 				}
1813 				else if (i <= 167){
1814 					// in logsData5
1815 					logsData[5] += uint256(dial1) * uint256(2) ** (3 * ((3 * (167 - i)) + 2));
1816 					logsData[5] += uint256(dial2) * uint256(2) ** (3 * ((3 * (167 - i)) + 1));
1817 					logsData[5] += uint256(dial3) * uint256(2) ** (3 * ((3 * (167 - i))));
1818 				}
1819 				else if (i <= 195){
1820 					// in logsData6
1821 					logsData[6] += uint256(dial1) * uint256(2) ** (3 * ((3 * (195 - i)) + 2));
1822 					logsData[6] += uint256(dial2) * uint256(2) ** (3 * ((3 * (195 - i)) + 1));
1823 					logsData[6] += uint256(dial3) * uint256(2) ** (3 * ((3 * (195 - i))));
1824 				}
1825 				else {
1826 					// in logsData7
1827 					logsData[7] += uint256(dial1) * uint256(2) ** (3 * ((3 * (223 - i)) + 2));
1828 					logsData[7] += uint256(dial2) * uint256(2) ** (3 * ((3 * (223 - i)) + 1));
1829 					logsData[7] += uint256(dial3) * uint256(2) ** (3 * ((3 * (223 - i))));
1830 				}
1831 			}
1832 
1833 			// add these new dials to the storage variable DIALSSPUN
1834 			DIALSSPUN += dialsSpun;
1835 
1836 			// and add the amount wagered
1837 			AMOUNTWAGERED = SafeMath.add(AMOUNTWAGERED, msg.value);
1838 
1839 			// calculate amount for the developers fund.
1840 			// this is: value of ether * (5% house edge) * (20% cut)
1841 			uint256 developersCut = msg.value / 100;
1842 
1843 			// add this to the developers fund.
1844 			DEVELOPERSFUND = SafeMath.add(DEVELOPERSFUND, developersCut);
1845 
1846 			// transfer the (msg.value - developersCut) to the bankroll
1847 			EOSBetBankrollInterface(BANKROLLER).receiveEtherFromGameAddress.value(SafeMath.sub(msg.value, developersCut))();
1848 
1849 			// now payout ether
1850 			uint256 etherPaidout = SafeMath.mul(betPerCredit, payout);
1851 
1852 			// make the bankroll transfer the paidout amount to the player
1853 			EOSBetBankrollInterface(BANKROLLER).payEtherToWinner(etherPaidout, msg.sender);
1854 
1855 			// and lastly, log an event
1856 			// log the data logs that were created above, we will not use event watchers here, but will use the txReceipt to get logs instead.
1857 			emit SlotsSmallBet(logsData[0], logsData[1], logsData[2], logsData[3], logsData[4], logsData[5], logsData[6], logsData[7]);
1858 
1859 		}
1860 		// if the bet amount is OVER the oraclize query limit, we must get the randomness from oraclize.
1861 		// This is because miners are inventivized to interfere with the block.blockhash, in an attempt
1862 		// to get more favorable rolls/slot spins/etc.
1863 		else {
1864 			// oraclize_newRandomDSQuery(delay in seconds, bytes of random data, gas for callback function)
1865 			bytes32 oraclizeQueryId;
1866 
1867 			// equation for gas to oraclize is:
1868 			// gas = (some fixed gas amt) + 3270 * credits
1869 			
1870 			uint256 gasToSend = INITIALGASFORORACLIZE + (uint256(3270) * credits);
1871 
1872 			EOSBetBankrollInterface(BANKROLLER).payOraclize(oraclize_getPrice('random', gasToSend));
1873 
1874 			oraclizeQueryId = oraclize_newRandomDSQuery(0, 30, gasToSend);
1875 
1876 			// add the new slots data to a mapping so that the oraclize __callback can use it later
1877 			slotsData[oraclizeQueryId] = SlotsGameData({
1878 				player : msg.sender,
1879 				paidOut : false,
1880 				start : block.timestamp,
1881 				etherReceived : msg.value,
1882 				credits : credits
1883 			});
1884 
1885 			// add the sent value into liabilities. this should NOT go into the bankroll yet
1886 			// and must be quarantined here to prevent timing attacks
1887 			LIABILITIES = SafeMath.add(LIABILITIES, msg.value);
1888 
1889 			emit BuyCredits(oraclizeQueryId);
1890 		}
1891 	}
1892 
1893 	function __callback(bytes32 _queryId, string _result, bytes _proof) public {
1894 		// get the game data and put into memory
1895 		SlotsGameData memory data = slotsData[_queryId];
1896 
1897 		require(msg.sender == oraclize_cbAddress() 
1898 			&& !data.paidOut 
1899 			&& data.player != address(0) 
1900 			&& LIABILITIES >= data.etherReceived);
1901 
1902 		// if the proof has failed, immediately refund the player the original bet.
1903 		if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0){
1904 
1905 			if (REFUNDSACTIVE){
1906 				// set contract data
1907 				slotsData[_queryId].paidOut = true;
1908 
1909 				// subtract from liabilities and amount wagered, because this bet is being refunded.
1910 				LIABILITIES = SafeMath.sub(LIABILITIES, data.etherReceived);
1911 
1912 				// transfer the original bet back
1913 				data.player.transfer(data.etherReceived);
1914 
1915 				// log the refund
1916 				emit Refund(_queryId, data.etherReceived);
1917 			}
1918 			// log the ledger proof fail 
1919 			emit LedgerProofFailed(_queryId);
1920 			
1921 		}
1922 		else {
1923 			// again, this block is almost identical to the previous block in the play(...) function 
1924 			// instead of duplicating documentation, we will just point out the changes from the other block 
1925 			uint256 dialsSpun;
1926 			
1927 			uint8 dial1;
1928 			uint8 dial2;
1929 			uint8 dial3;
1930 			
1931 			uint256[] memory logsData = new uint256[](8);
1932 			
1933 			uint256 payout;
1934 			
1935 			// must use data.credits instead of credits.
1936 			for (uint8 i = 0; i < data.credits; i++){
1937 
1938 				// all dials now use _result, instead of blockhash, this is the main change, and allows Slots to 
1939 				// accomodate bets of any size, free of possible miner interference 
1940 				dialsSpun += 1;
1941 				dial1 = uint8(uint(keccak256(_result, dialsSpun)) % 64);
1942 				
1943 				dialsSpun += 1;
1944 				dial2 = uint8(uint(keccak256(_result, dialsSpun)) % 64);
1945 				
1946 				dialsSpun += 1;
1947 				dial3 = uint8(uint(keccak256(_result, dialsSpun)) % 64);
1948 
1949 				// dial 1
1950 				dial1 = getDial1Type(dial1);
1951 
1952 				// dial 2
1953 				dial2 = getDial2Type(dial2);
1954 
1955 				// dial 3
1956 				dial3 = getDial3Type(dial3);
1957 
1958 				// determine the payout
1959 				payout += determinePayout(dial1, dial2, dial3);
1960 				
1961 				// assembling log data
1962 				if (i <= 27){
1963 					// in logsData0
1964 					logsData[0] += uint256(dial1) * uint256(2) ** (3 * ((3 * (27 - i)) + 2));
1965 					logsData[0] += uint256(dial2) * uint256(2) ** (3 * ((3 * (27 - i)) + 1));
1966 					logsData[0] += uint256(dial3) * uint256(2) ** (3 * ((3 * (27 - i))));
1967 				}
1968 				else if (i <= 55){
1969 					// in logsData1
1970 					logsData[1] += uint256(dial1) * uint256(2) ** (3 * ((3 * (55 - i)) + 2));
1971 					logsData[1] += uint256(dial2) * uint256(2) ** (3 * ((3 * (55 - i)) + 1));
1972 					logsData[1] += uint256(dial3) * uint256(2) ** (3 * ((3 * (55 - i))));
1973 				}
1974 				else if (i <= 83) {
1975 					// in logsData2
1976 					logsData[2] += uint256(dial1) * uint256(2) ** (3 * ((3 * (83 - i)) + 2));
1977 					logsData[2] += uint256(dial2) * uint256(2) ** (3 * ((3 * (83 - i)) + 1));
1978 					logsData[2] += uint256(dial3) * uint256(2) ** (3 * ((3 * (83 - i))));
1979 				}
1980 				else if (i <= 111) {
1981 					// in logsData3
1982 					logsData[3] += uint256(dial1) * uint256(2) ** (3 * ((3 * (111 - i)) + 2));
1983 					logsData[3] += uint256(dial2) * uint256(2) ** (3 * ((3 * (111 - i)) + 1));
1984 					logsData[3] += uint256(dial3) * uint256(2) ** (3 * ((3 * (111 - i))));
1985 				}
1986 				else if (i <= 139){
1987 					// in logsData4
1988 					logsData[4] += uint256(dial1) * uint256(2) ** (3 * ((3 * (139 - i)) + 2));
1989 					logsData[4] += uint256(dial2) * uint256(2) ** (3 * ((3 * (139 - i)) + 1));
1990 					logsData[4] += uint256(dial3) * uint256(2) ** (3 * ((3 * (139 - i))));
1991 				}
1992 				else if (i <= 167){
1993 					// in logsData5
1994 					logsData[5] += uint256(dial1) * uint256(2) ** (3 * ((3 * (167 - i)) + 2));
1995 					logsData[5] += uint256(dial2) * uint256(2) ** (3 * ((3 * (167 - i)) + 1));
1996 					logsData[5] += uint256(dial3) * uint256(2) ** (3 * ((3 * (167 - i))));
1997 				}
1998 				else if (i <= 195){
1999 					// in logsData6
2000 					logsData[6] += uint256(dial1) * uint256(2) ** (3 * ((3 * (195 - i)) + 2));
2001 					logsData[6] += uint256(dial2) * uint256(2) ** (3 * ((3 * (195 - i)) + 1));
2002 					logsData[6] += uint256(dial3) * uint256(2) ** (3 * ((3 * (195 - i))));
2003 				}
2004 				else if (i <= 223){
2005 					// in logsData7
2006 					logsData[7] += uint256(dial1) * uint256(2) ** (3 * ((3 * (223 - i)) + 2));
2007 					logsData[7] += uint256(dial2) * uint256(2) ** (3 * ((3 * (223 - i)) + 1));
2008 					logsData[7] += uint256(dial3) * uint256(2) ** (3 * ((3 * (223 - i))));
2009 				}
2010 			}
2011 
2012 			// track that these spins were made
2013 			DIALSSPUN += dialsSpun;
2014 
2015 			// and add the amount wagered
2016 			AMOUNTWAGERED = SafeMath.add(AMOUNTWAGERED, data.etherReceived);
2017 
2018 			// IMPORTANT: we must change the "paidOut" to TRUE here to prevent reentrancy/other nasty effects.
2019 			// this was not needed with the previous loop/code block, and is used because variables must be written into storage
2020 			slotsData[_queryId].paidOut = true;
2021 
2022 			// decrease LIABILITIES when the spins are made
2023 			LIABILITIES = SafeMath.sub(LIABILITIES, data.etherReceived);
2024 
2025 			// get the developers cut, and send the rest of the ether received to the bankroller contract
2026 			uint256 developersCut = data.etherReceived / 100;
2027 
2028 			DEVELOPERSFUND = SafeMath.add(DEVELOPERSFUND, developersCut);
2029 
2030 			EOSBetBankrollInterface(BANKROLLER).receiveEtherFromGameAddress.value(SafeMath.sub(data.etherReceived, developersCut))();
2031 
2032 			// get the ether to be paid out, and force the bankroller contract to pay out the player
2033 			uint256 etherPaidout = SafeMath.mul((data.etherReceived / data.credits), payout);
2034 
2035 			EOSBetBankrollInterface(BANKROLLER).payEtherToWinner(etherPaidout, data.player);
2036 
2037 			// log en event with indexed query id
2038 			emit SlotsLargeBet(_queryId, logsData[0], logsData[1], logsData[2], logsData[3], logsData[4], logsData[5], logsData[6], logsData[7]);
2039 		}
2040 	}
2041 	
2042 	// HELPER FUNCTIONS TO:
2043 	// calculate the result of the dials based on the hardcoded slot data: 
2044 
2045 	// STOPS			REEL#1	REEL#2	REEL#3
2046 	///////////////////////////////////////////
2047 	// gold ether 	0 //  1  //  3   //   1  //	
2048 	// silver ether 1 //  7  //  1   //   6  //
2049 	// bronze ether 2 //  1  //  7   //   6  //
2050 	// gold planet  3 //  5  //  7   //   6  //
2051 	// silverplanet 4 //  9  //  6   //   7  //
2052 	// bronzeplanet 5 //  9  //  8   //   6  //
2053 	// ---blank---  6 //  32 //  32  //   32 //
2054 	///////////////////////////////////////////
2055 
2056 	// note that dial1 / 2 / 3 will go from mod 64 to mod 7 in this manner
2057 	
2058 	function getDial1Type(uint8 dial1Location) internal pure returns(uint8) {
2059 	    if (dial1Location == 0) 							        { return 0; }
2060 		else if (dial1Location >= 1 && dial1Location <= 7) 			{ return 1; }
2061 		else if (dial1Location == 8) 						        { return 2; }
2062 		else if (dial1Location >= 9 && dial1Location <= 13) 		{ return 3; }
2063 		else if (dial1Location >= 14 && dial1Location <= 22) 		{ return 4; }
2064 		else if (dial1Location >= 23 && dial1Location <= 31) 		{ return 5; }
2065 		else 										                { return 6; }
2066 	}
2067 	
2068 	function getDial2Type(uint8 dial2Location) internal pure returns(uint8) {
2069 	    if (dial2Location >= 0 && dial2Location <= 2) 				{ return 0; }
2070 		else if (dial2Location == 3) 						        { return 1; }
2071 		else if (dial2Location >= 4 && dial2Location <= 10)			{ return 2; }
2072 		else if (dial2Location >= 11 && dial2Location <= 17) 		{ return 3; }
2073 		else if (dial2Location >= 18 && dial2Location <= 23) 		{ return 4; }
2074 		else if (dial2Location >= 24 && dial2Location <= 31) 		{ return 5; }
2075 		else 										                { return 6; }
2076 	}
2077 	
2078 	function getDial3Type(uint8 dial3Location) internal pure returns(uint8) {
2079 	    if (dial3Location == 0) 							        { return 0; }
2080 		else if (dial3Location >= 1 && dial3Location <= 6)			{ return 1; }
2081 		else if (dial3Location >= 7 && dial3Location <= 12) 		{ return 2; }
2082 		else if (dial3Location >= 13 && dial3Location <= 18)		{ return 3; }
2083 		else if (dial3Location >= 19 && dial3Location <= 25) 		{ return 4; }
2084 		else if (dial3Location >= 26 && dial3Location <= 31) 		{ return 5; }
2085 		else 										                { return 6; }
2086 	}
2087 	
2088 	// HELPER FUNCTION TO:
2089 	// determine the payout given dial locations based on this table
2090 	
2091 	// hardcoded payouts data:
2092 	// 			LANDS ON 				//	PAYS  //
2093 	////////////////////////////////////////////////
2094 	// Bronze E -> Silver E -> Gold E	//	5000  //
2095 	// 3x Gold Ether					//	1777  //
2096 	// 3x Silver Ether					//	250   //
2097 	// 3x Bronze Ether					//	250   //
2098 	//  3x any Ether 					//	95    //
2099 	// Bronze P -> Silver P -> Gold P	//	90    //
2100 	// 3x Gold Planet 					//	50    //
2101 	// 3x Silver Planet					//	25    //
2102 	// Any Gold P & Silver P & Bronze P //	20    //
2103 	// 3x Bronze Planet					//	10    //
2104 	// Any 3 planet type				//	3     //
2105 	// Any 3 gold						//	3     //
2106 	// Any 3 silver						//	2     //
2107 	// Any 3 bronze						//	2     //
2108 	// Blank, blank, blank				//	1     //
2109 	// else								//  0     //
2110 	////////////////////////////////////////////////
2111 	
2112 	function determinePayout(uint8 dial1, uint8 dial2, uint8 dial3) internal pure returns(uint256) {
2113 		if (dial1 == 6 || dial2 == 6 || dial3 == 6){
2114 			// all blank
2115 			if (dial1 == 6 && dial2 == 6 && dial3 == 6)
2116 				return 1;
2117 		}
2118 		else if (dial1 == 5){
2119 			// bronze planet -> silver planet -> gold planet
2120 			if (dial2 == 4 && dial3 == 3) 
2121 				return 90;
2122 
2123 			// one gold planet, one silver planet, one bronze planet, any order!
2124 			// note: other order covered above, return 90
2125 			else if (dial2 == 3 && dial3 == 4)
2126 				return 20;
2127 
2128 			// all bronze planet 
2129 			else if (dial2 == 5 && dial3 == 5) 
2130 				return 10;
2131 
2132 			// any three planet type 
2133 			else if (dial2 >= 3 && dial2 <= 5 && dial3 >= 3 && dial3 <= 5)
2134 				return 3;
2135 
2136 			// any three bronze 
2137 			else if ((dial2 == 2 || dial2 == 5) && (dial3 == 2 || dial3 == 5))
2138 				return 2;
2139 		}
2140 		else if (dial1 == 4){
2141 			// all silver planet
2142 			if (dial2 == 4 && dial3 == 4)
2143 				return 25;
2144 
2145 			// one gold planet, one silver planet, one bronze planet, any order!
2146 			else if ((dial2 == 3 && dial3 == 5) || (dial2 == 5 && dial3 == 3))
2147 				return 20;
2148 
2149 			// any three planet type 
2150 			else if (dial2 >= 3 && dial2 <= 5 && dial3 >= 3 && dial3 <= 5)
2151 				return 3;
2152 
2153 			// any three silver
2154 			else if ((dial2 == 1 || dial2 == 4) && (dial3 == 1 || dial3 == 4))
2155 				return 2;
2156 		}
2157 		else if (dial1 == 3){
2158 			// all gold planet
2159 			if (dial2 == 3 && dial3 == 3)
2160 				return 50;
2161 
2162 			// one gold planet, one silver planet, one bronze planet, any order!
2163 			else if ((dial2 == 4 && dial3 == 5) || (dial2 == 5 && dial3 == 4))
2164 				return 20;
2165 
2166 			// any three planet type 
2167 			else if (dial2 >= 3 && dial2 <= 5 && dial3 >= 3 && dial3 <= 5)
2168 				return 3;
2169 
2170 			// any three gold
2171 			else if ((dial2 == 0 || dial2 == 3) && (dial3 == 0 || dial3 == 3))
2172 				return 3;
2173 		}
2174 		else if (dial1 == 2){
2175 			if (dial2 == 1 && dial3 == 0)
2176 				return 5000; // jackpot!!!!
2177 
2178 			// all bronze ether
2179 			else if (dial2 == 2 && dial3 == 2)
2180 				return 250;
2181 
2182 			// all some type of ether
2183 			else if (dial2 >= 0 && dial2 <= 2 && dial3 >= 0 && dial3 <= 2)
2184 				return 95;
2185 
2186 			// any three bronze
2187 			else if ((dial2 == 2 || dial2 == 5) && (dial3 == 2 || dial3 == 5))
2188 				return 2;
2189 		}
2190 		else if (dial1 == 1){
2191 			// all silver ether 
2192 			if (dial2 == 1 && dial3 == 1)
2193 				return 250;
2194 
2195 			// all some type of ether
2196 			else if (dial2 >= 0 && dial2 <= 2 && dial3 >= 0 && dial3 <= 2)
2197 				return 95;
2198 
2199 			// any three silver
2200 			else if ((dial2 == 1 || dial2 == 4) && (dial3 == 1 || dial3 == 4))
2201 				return 3;
2202 		}
2203 		else if (dial1 == 0){
2204 			// all gold ether
2205 			if (dial2 == 0 && dial3 == 0)
2206 				return 1777;
2207 
2208 			// all some type of ether
2209 			else if (dial2 >= 0 && dial2 <= 2 && dial3 >= 0 && dial3 <= 2)
2210 				return 95;
2211 
2212 			// any three gold
2213 			else if ((dial2 == 0 || dial2 == 3) && (dial3 == 0 || dial3 == 3))
2214 				return 3;
2215 		}
2216 		return 0;
2217 	}
2218 
2219 }