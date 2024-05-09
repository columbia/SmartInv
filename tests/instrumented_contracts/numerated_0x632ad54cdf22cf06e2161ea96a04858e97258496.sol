1 /**
2  * The USD oracle for BlockLease
3  *
4  * See https://github.com/BlockLease
5  **/
6 
7 // <ORACLIZE_API>
8 /*
9 Copyright (c) 2015-2016 Oraclize SRL
10 Copyright (c) 2016 Oraclize LTD
11 
12 
13 
14 Permission is hereby granted, free of charge, to any person obtaining a copy
15 of this software and associated documentation files (the "Software"), to deal
16 in the Software without restriction, including without limitation the rights
17 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
18 copies of the Software, and to permit persons to whom the Software is
19 furnished to do so, subject to the following conditions:
20 
21 
22 
23 The above copyright notice and this permission notice shall be included in
24 all copies or substantial portions of the Software.
25 
26 
27 
28 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
31 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
34 THE SOFTWARE.
35 */
36 
37 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
38 pragma solidity ^0.4.18;
39 
40 contract OraclizeI {
41     address public cbAddress;
42     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
43     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
44     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
45     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
46     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
47     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
48     function getPrice(string _datasource) public returns (uint _dsprice);
49     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
50     function setProofType(byte _proofType) external;
51     function setCustomGasPrice(uint _gasPrice) external;
52     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
53 }
54 contract OraclizeAddrResolverI {
55     function getAddress() public returns (address _addr);
56 }
57 contract usingOraclize {
58     uint constant day = 60*60*24;
59     uint constant week = 60*60*24*7;
60     uint constant month = 60*60*24*30;
61     byte constant proofType_NONE = 0x00;
62     byte constant proofType_TLSNotary = 0x10;
63     byte constant proofType_Android = 0x20;
64     byte constant proofType_Ledger = 0x30;
65     byte constant proofType_Native = 0xF0;
66     byte constant proofStorage_IPFS = 0x01;
67     uint8 constant networkID_auto = 0;
68     uint8 constant networkID_mainnet = 1;
69     uint8 constant networkID_testnet = 2;
70     uint8 constant networkID_morden = 2;
71     uint8 constant networkID_consensys = 161;
72 
73     OraclizeAddrResolverI OAR;
74 
75     OraclizeI oraclize;
76     modifier oraclizeAPI {
77         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
78             oraclize_setNetwork(networkID_auto);
79 
80         if(address(oraclize) != OAR.getAddress())
81             oraclize = OraclizeI(OAR.getAddress());
82 
83         _;
84     }
85     modifier coupon(string code){
86         oraclize = OraclizeI(OAR.getAddress());
87         _;
88     }
89 
90     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
91       return oraclize_setNetwork();
92       networkID; // silence the warning and remain backwards compatible
93     }
94     function oraclize_setNetwork() internal returns(bool){
95         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
96             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
97             oraclize_setNetworkName("eth_mainnet");
98             return true;
99         }
100         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
101             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
102             oraclize_setNetworkName("eth_ropsten3");
103             return true;
104         }
105         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
106             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
107             oraclize_setNetworkName("eth_kovan");
108             return true;
109         }
110         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
111             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
112             oraclize_setNetworkName("eth_rinkeby");
113             return true;
114         }
115         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
116             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
117             return true;
118         }
119         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
120             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
121             return true;
122         }
123         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
124             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
125             return true;
126         }
127         return false;
128     }
129 
130     function __callback(bytes32 myid, string result) public {
131         __callback(myid, result, new bytes(0));
132     }
133     function __callback(bytes32 myid, string result, bytes proof) public {
134       return;
135       myid; result; proof; // Silence compiler warnings
136     }
137 
138     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
139         return oraclize.getPrice(datasource);
140     }
141 
142     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
143         return oraclize.getPrice(datasource, gaslimit);
144     }
145 
146     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
147         uint price = oraclize.getPrice(datasource);
148         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
149         return oraclize.query.value(price)(0, datasource, arg);
150     }
151     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
152         uint price = oraclize.getPrice(datasource);
153         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
154         return oraclize.query.value(price)(timestamp, datasource, arg);
155     }
156     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
157         uint price = oraclize.getPrice(datasource, gaslimit);
158         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
159         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
160     }
161     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
162         uint price = oraclize.getPrice(datasource, gaslimit);
163         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
164         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
165     }
166     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
167         uint price = oraclize.getPrice(datasource);
168         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
169         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
170     }
171     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
172         uint price = oraclize.getPrice(datasource);
173         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
174         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
175     }
176     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
177         uint price = oraclize.getPrice(datasource, gaslimit);
178         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
179         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
180     }
181     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
182         uint price = oraclize.getPrice(datasource, gaslimit);
183         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
184         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
185     }
186     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
187         uint price = oraclize.getPrice(datasource);
188         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
189         bytes memory args = stra2cbor(argN);
190         return oraclize.queryN.value(price)(0, datasource, args);
191     }
192     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
193         uint price = oraclize.getPrice(datasource);
194         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
195         bytes memory args = stra2cbor(argN);
196         return oraclize.queryN.value(price)(timestamp, datasource, args);
197     }
198     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
199         uint price = oraclize.getPrice(datasource, gaslimit);
200         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
201         bytes memory args = stra2cbor(argN);
202         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
203     }
204     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
205         uint price = oraclize.getPrice(datasource, gaslimit);
206         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
207         bytes memory args = stra2cbor(argN);
208         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
209     }
210     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
211         string[] memory dynargs = new string[](1);
212         dynargs[0] = args[0];
213         return oraclize_query(datasource, dynargs);
214     }
215     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
216         string[] memory dynargs = new string[](1);
217         dynargs[0] = args[0];
218         return oraclize_query(timestamp, datasource, dynargs);
219     }
220     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
221         string[] memory dynargs = new string[](1);
222         dynargs[0] = args[0];
223         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
224     }
225     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
226         string[] memory dynargs = new string[](1);
227         dynargs[0] = args[0];
228         return oraclize_query(datasource, dynargs, gaslimit);
229     }
230 
231     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
232         string[] memory dynargs = new string[](2);
233         dynargs[0] = args[0];
234         dynargs[1] = args[1];
235         return oraclize_query(datasource, dynargs);
236     }
237     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
238         string[] memory dynargs = new string[](2);
239         dynargs[0] = args[0];
240         dynargs[1] = args[1];
241         return oraclize_query(timestamp, datasource, dynargs);
242     }
243     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
244         string[] memory dynargs = new string[](2);
245         dynargs[0] = args[0];
246         dynargs[1] = args[1];
247         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
248     }
249     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
250         string[] memory dynargs = new string[](2);
251         dynargs[0] = args[0];
252         dynargs[1] = args[1];
253         return oraclize_query(datasource, dynargs, gaslimit);
254     }
255     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
256         string[] memory dynargs = new string[](3);
257         dynargs[0] = args[0];
258         dynargs[1] = args[1];
259         dynargs[2] = args[2];
260         return oraclize_query(datasource, dynargs);
261     }
262     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
263         string[] memory dynargs = new string[](3);
264         dynargs[0] = args[0];
265         dynargs[1] = args[1];
266         dynargs[2] = args[2];
267         return oraclize_query(timestamp, datasource, dynargs);
268     }
269     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
270         string[] memory dynargs = new string[](3);
271         dynargs[0] = args[0];
272         dynargs[1] = args[1];
273         dynargs[2] = args[2];
274         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
275     }
276     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
277         string[] memory dynargs = new string[](3);
278         dynargs[0] = args[0];
279         dynargs[1] = args[1];
280         dynargs[2] = args[2];
281         return oraclize_query(datasource, dynargs, gaslimit);
282     }
283 
284     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
285         string[] memory dynargs = new string[](4);
286         dynargs[0] = args[0];
287         dynargs[1] = args[1];
288         dynargs[2] = args[2];
289         dynargs[3] = args[3];
290         return oraclize_query(datasource, dynargs);
291     }
292     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
293         string[] memory dynargs = new string[](4);
294         dynargs[0] = args[0];
295         dynargs[1] = args[1];
296         dynargs[2] = args[2];
297         dynargs[3] = args[3];
298         return oraclize_query(timestamp, datasource, dynargs);
299     }
300     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
301         string[] memory dynargs = new string[](4);
302         dynargs[0] = args[0];
303         dynargs[1] = args[1];
304         dynargs[2] = args[2];
305         dynargs[3] = args[3];
306         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
307     }
308     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
309         string[] memory dynargs = new string[](4);
310         dynargs[0] = args[0];
311         dynargs[1] = args[1];
312         dynargs[2] = args[2];
313         dynargs[3] = args[3];
314         return oraclize_query(datasource, dynargs, gaslimit);
315     }
316     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
317         string[] memory dynargs = new string[](5);
318         dynargs[0] = args[0];
319         dynargs[1] = args[1];
320         dynargs[2] = args[2];
321         dynargs[3] = args[3];
322         dynargs[4] = args[4];
323         return oraclize_query(datasource, dynargs);
324     }
325     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
326         string[] memory dynargs = new string[](5);
327         dynargs[0] = args[0];
328         dynargs[1] = args[1];
329         dynargs[2] = args[2];
330         dynargs[3] = args[3];
331         dynargs[4] = args[4];
332         return oraclize_query(timestamp, datasource, dynargs);
333     }
334     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
335         string[] memory dynargs = new string[](5);
336         dynargs[0] = args[0];
337         dynargs[1] = args[1];
338         dynargs[2] = args[2];
339         dynargs[3] = args[3];
340         dynargs[4] = args[4];
341         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
342     }
343     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
344         string[] memory dynargs = new string[](5);
345         dynargs[0] = args[0];
346         dynargs[1] = args[1];
347         dynargs[2] = args[2];
348         dynargs[3] = args[3];
349         dynargs[4] = args[4];
350         return oraclize_query(datasource, dynargs, gaslimit);
351     }
352     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
353         uint price = oraclize.getPrice(datasource);
354         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
355         bytes memory args = ba2cbor(argN);
356         return oraclize.queryN.value(price)(0, datasource, args);
357     }
358     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
359         uint price = oraclize.getPrice(datasource);
360         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
361         bytes memory args = ba2cbor(argN);
362         return oraclize.queryN.value(price)(timestamp, datasource, args);
363     }
364     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
365         uint price = oraclize.getPrice(datasource, gaslimit);
366         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
367         bytes memory args = ba2cbor(argN);
368         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
369     }
370     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
371         uint price = oraclize.getPrice(datasource, gaslimit);
372         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
373         bytes memory args = ba2cbor(argN);
374         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
375     }
376     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
377         bytes[] memory dynargs = new bytes[](1);
378         dynargs[0] = args[0];
379         return oraclize_query(datasource, dynargs);
380     }
381     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
382         bytes[] memory dynargs = new bytes[](1);
383         dynargs[0] = args[0];
384         return oraclize_query(timestamp, datasource, dynargs);
385     }
386     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
387         bytes[] memory dynargs = new bytes[](1);
388         dynargs[0] = args[0];
389         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
390     }
391     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
392         bytes[] memory dynargs = new bytes[](1);
393         dynargs[0] = args[0];
394         return oraclize_query(datasource, dynargs, gaslimit);
395     }
396 
397     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
398         bytes[] memory dynargs = new bytes[](2);
399         dynargs[0] = args[0];
400         dynargs[1] = args[1];
401         return oraclize_query(datasource, dynargs);
402     }
403     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
404         bytes[] memory dynargs = new bytes[](2);
405         dynargs[0] = args[0];
406         dynargs[1] = args[1];
407         return oraclize_query(timestamp, datasource, dynargs);
408     }
409     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
410         bytes[] memory dynargs = new bytes[](2);
411         dynargs[0] = args[0];
412         dynargs[1] = args[1];
413         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
414     }
415     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
416         bytes[] memory dynargs = new bytes[](2);
417         dynargs[0] = args[0];
418         dynargs[1] = args[1];
419         return oraclize_query(datasource, dynargs, gaslimit);
420     }
421     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
422         bytes[] memory dynargs = new bytes[](3);
423         dynargs[0] = args[0];
424         dynargs[1] = args[1];
425         dynargs[2] = args[2];
426         return oraclize_query(datasource, dynargs);
427     }
428     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
429         bytes[] memory dynargs = new bytes[](3);
430         dynargs[0] = args[0];
431         dynargs[1] = args[1];
432         dynargs[2] = args[2];
433         return oraclize_query(timestamp, datasource, dynargs);
434     }
435     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
436         bytes[] memory dynargs = new bytes[](3);
437         dynargs[0] = args[0];
438         dynargs[1] = args[1];
439         dynargs[2] = args[2];
440         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
441     }
442     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
443         bytes[] memory dynargs = new bytes[](3);
444         dynargs[0] = args[0];
445         dynargs[1] = args[1];
446         dynargs[2] = args[2];
447         return oraclize_query(datasource, dynargs, gaslimit);
448     }
449 
450     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
451         bytes[] memory dynargs = new bytes[](4);
452         dynargs[0] = args[0];
453         dynargs[1] = args[1];
454         dynargs[2] = args[2];
455         dynargs[3] = args[3];
456         return oraclize_query(datasource, dynargs);
457     }
458     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
459         bytes[] memory dynargs = new bytes[](4);
460         dynargs[0] = args[0];
461         dynargs[1] = args[1];
462         dynargs[2] = args[2];
463         dynargs[3] = args[3];
464         return oraclize_query(timestamp, datasource, dynargs);
465     }
466     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
467         bytes[] memory dynargs = new bytes[](4);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         dynargs[2] = args[2];
471         dynargs[3] = args[3];
472         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
473     }
474     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
475         bytes[] memory dynargs = new bytes[](4);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         dynargs[2] = args[2];
479         dynargs[3] = args[3];
480         return oraclize_query(datasource, dynargs, gaslimit);
481     }
482     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
483         bytes[] memory dynargs = new bytes[](5);
484         dynargs[0] = args[0];
485         dynargs[1] = args[1];
486         dynargs[2] = args[2];
487         dynargs[3] = args[3];
488         dynargs[4] = args[4];
489         return oraclize_query(datasource, dynargs);
490     }
491     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
492         bytes[] memory dynargs = new bytes[](5);
493         dynargs[0] = args[0];
494         dynargs[1] = args[1];
495         dynargs[2] = args[2];
496         dynargs[3] = args[3];
497         dynargs[4] = args[4];
498         return oraclize_query(timestamp, datasource, dynargs);
499     }
500     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
501         bytes[] memory dynargs = new bytes[](5);
502         dynargs[0] = args[0];
503         dynargs[1] = args[1];
504         dynargs[2] = args[2];
505         dynargs[3] = args[3];
506         dynargs[4] = args[4];
507         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
508     }
509     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
510         bytes[] memory dynargs = new bytes[](5);
511         dynargs[0] = args[0];
512         dynargs[1] = args[1];
513         dynargs[2] = args[2];
514         dynargs[3] = args[3];
515         dynargs[4] = args[4];
516         return oraclize_query(datasource, dynargs, gaslimit);
517     }
518 
519     function oraclize_cbAddress() oraclizeAPI internal returns (address){
520         return oraclize.cbAddress();
521     }
522     function oraclize_setProof(byte proofP) oraclizeAPI internal {
523         return oraclize.setProofType(proofP);
524     }
525     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
526         return oraclize.setCustomGasPrice(gasPrice);
527     }
528 
529     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
530         return oraclize.randomDS_getSessionPubKeyHash();
531     }
532 
533     function getCodeSize(address _addr) constant internal returns(uint _size) {
534         assembly {
535             _size := extcodesize(_addr)
536         }
537     }
538 
539     function parseAddr(string _a) internal pure returns (address){
540         bytes memory tmp = bytes(_a);
541         uint160 iaddr = 0;
542         uint160 b1;
543         uint160 b2;
544         for (uint i=2; i<2+2*20; i+=2){
545             iaddr *= 256;
546             b1 = uint160(tmp[i]);
547             b2 = uint160(tmp[i+1]);
548             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
549             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
550             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
551             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
552             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
553             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
554             iaddr += (b1*16+b2);
555         }
556         return address(iaddr);
557     }
558 
559     function strCompare(string _a, string _b) internal pure returns (int) {
560         bytes memory a = bytes(_a);
561         bytes memory b = bytes(_b);
562         uint minLength = a.length;
563         if (b.length < minLength) minLength = b.length;
564         for (uint i = 0; i < minLength; i ++)
565             if (a[i] < b[i])
566                 return -1;
567             else if (a[i] > b[i])
568                 return 1;
569         if (a.length < b.length)
570             return -1;
571         else if (a.length > b.length)
572             return 1;
573         else
574             return 0;
575     }
576 
577     function indexOf(string _haystack, string _needle) internal pure returns (int) {
578         bytes memory h = bytes(_haystack);
579         bytes memory n = bytes(_needle);
580         if(h.length < 1 || n.length < 1 || (n.length > h.length))
581             return -1;
582         else if(h.length > (2**128 -1))
583             return -1;
584         else
585         {
586             uint subindex = 0;
587             for (uint i = 0; i < h.length; i ++)
588             {
589                 if (h[i] == n[0])
590                 {
591                     subindex = 1;
592                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
593                     {
594                         subindex++;
595                     }
596                     if(subindex == n.length)
597                         return int(i);
598                 }
599             }
600             return -1;
601         }
602     }
603 
604     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
605         bytes memory _ba = bytes(_a);
606         bytes memory _bb = bytes(_b);
607         bytes memory _bc = bytes(_c);
608         bytes memory _bd = bytes(_d);
609         bytes memory _be = bytes(_e);
610         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
611         bytes memory babcde = bytes(abcde);
612         uint k = 0;
613         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
614         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
615         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
616         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
617         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
618         return string(babcde);
619     }
620 
621     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
622         return strConcat(_a, _b, _c, _d, "");
623     }
624 
625     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
626         return strConcat(_a, _b, _c, "", "");
627     }
628 
629     function strConcat(string _a, string _b) internal pure returns (string) {
630         return strConcat(_a, _b, "", "", "");
631     }
632 
633     // parseInt
634     function parseInt(string _a) internal pure returns (uint) {
635         return parseInt(_a, 0);
636     }
637 
638     // parseInt(parseFloat*10^_b)
639     function parseInt(string _a, uint _b) internal pure returns (uint) {
640         bytes memory bresult = bytes(_a);
641         uint mint = 0;
642         bool decimals = false;
643         for (uint i=0; i<bresult.length; i++){
644             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
645                 if (decimals){
646                    if (_b == 0) break;
647                     else _b--;
648                 }
649                 mint *= 10;
650                 mint += uint(bresult[i]) - 48;
651             } else if (bresult[i] == 46) decimals = true;
652         }
653         if (_b > 0) mint *= 10**_b;
654         return mint;
655     }
656 
657     function uint2str(uint i) internal pure returns (string){
658         if (i == 0) return "0";
659         uint j = i;
660         uint len;
661         while (j != 0){
662             len++;
663             j /= 10;
664         }
665         bytes memory bstr = new bytes(len);
666         uint k = len - 1;
667         while (i != 0){
668             bstr[k--] = byte(48 + i % 10);
669             i /= 10;
670         }
671         return string(bstr);
672     }
673 
674     function stra2cbor(string[] arr) internal pure returns (bytes) {
675             uint arrlen = arr.length;
676 
677             // get correct cbor output length
678             uint outputlen = 0;
679             bytes[] memory elemArray = new bytes[](arrlen);
680             for (uint i = 0; i < arrlen; i++) {
681                 elemArray[i] = (bytes(arr[i]));
682                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
683             }
684             uint ctr = 0;
685             uint cborlen = arrlen + 0x80;
686             outputlen += byte(cborlen).length;
687             bytes memory res = new bytes(outputlen);
688 
689             while (byte(cborlen).length > ctr) {
690                 res[ctr] = byte(cborlen)[ctr];
691                 ctr++;
692             }
693             for (i = 0; i < arrlen; i++) {
694                 res[ctr] = 0x5F;
695                 ctr++;
696                 for (uint x = 0; x < elemArray[i].length; x++) {
697                     // if there's a bug with larger strings, this may be the culprit
698                     if (x % 23 == 0) {
699                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
700                         elemcborlen += 0x40;
701                         uint lctr = ctr;
702                         while (byte(elemcborlen).length > ctr - lctr) {
703                             res[ctr] = byte(elemcborlen)[ctr - lctr];
704                             ctr++;
705                         }
706                     }
707                     res[ctr] = elemArray[i][x];
708                     ctr++;
709                 }
710                 res[ctr] = 0xFF;
711                 ctr++;
712             }
713             return res;
714         }
715 
716     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
717             uint arrlen = arr.length;
718 
719             // get correct cbor output length
720             uint outputlen = 0;
721             bytes[] memory elemArray = new bytes[](arrlen);
722             for (uint i = 0; i < arrlen; i++) {
723                 elemArray[i] = (bytes(arr[i]));
724                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
725             }
726             uint ctr = 0;
727             uint cborlen = arrlen + 0x80;
728             outputlen += byte(cborlen).length;
729             bytes memory res = new bytes(outputlen);
730 
731             while (byte(cborlen).length > ctr) {
732                 res[ctr] = byte(cborlen)[ctr];
733                 ctr++;
734             }
735             for (i = 0; i < arrlen; i++) {
736                 res[ctr] = 0x5F;
737                 ctr++;
738                 for (uint x = 0; x < elemArray[i].length; x++) {
739                     // if there's a bug with larger strings, this may be the culprit
740                     if (x % 23 == 0) {
741                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
742                         elemcborlen += 0x40;
743                         uint lctr = ctr;
744                         while (byte(elemcborlen).length > ctr - lctr) {
745                             res[ctr] = byte(elemcborlen)[ctr - lctr];
746                             ctr++;
747                         }
748                     }
749                     res[ctr] = elemArray[i][x];
750                     ctr++;
751                 }
752                 res[ctr] = 0xFF;
753                 ctr++;
754             }
755             return res;
756         }
757 
758 
759     string oraclize_network_name;
760     function oraclize_setNetworkName(string _network_name) internal {
761         oraclize_network_name = _network_name;
762     }
763 
764     function oraclize_getNetworkName() internal view returns (string) {
765         return oraclize_network_name;
766     }
767 
768     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
769         require((_nbytes > 0) && (_nbytes <= 32));
770         // Convert from seconds to ledger timer ticks
771         _delay *= 10;
772         bytes memory nbytes = new bytes(1);
773         nbytes[0] = byte(_nbytes);
774         bytes memory unonce = new bytes(32);
775         bytes memory sessionKeyHash = new bytes(32);
776         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
777         assembly {
778             mstore(unonce, 0x20)
779             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
780             mstore(sessionKeyHash, 0x20)
781             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
782         }
783         bytes memory delay = new bytes(32);
784         assembly {
785             mstore(add(delay, 0x20), _delay)
786         }
787 
788         bytes memory delay_bytes8 = new bytes(8);
789         copyBytes(delay, 24, 8, delay_bytes8, 0);
790 
791         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
792         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
793 
794         bytes memory delay_bytes8_left = new bytes(8);
795 
796         assembly {
797             let x := mload(add(delay_bytes8, 0x20))
798             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
799             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
800             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
801             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
802             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
803             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
804             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
805             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
806 
807         }
808 
809         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
810         return queryId;
811     }
812 
813     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
814         oraclize_randomDS_args[queryId] = commitment;
815     }
816 
817     mapping(bytes32=>bytes32) oraclize_randomDS_args;
818     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
819 
820     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
821         bool sigok;
822         address signer;
823 
824         bytes32 sigr;
825         bytes32 sigs;
826 
827         bytes memory sigr_ = new bytes(32);
828         uint offset = 4+(uint(dersig[3]) - 0x20);
829         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
830         bytes memory sigs_ = new bytes(32);
831         offset += 32 + 2;
832         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
833 
834         assembly {
835             sigr := mload(add(sigr_, 32))
836             sigs := mload(add(sigs_, 32))
837         }
838 
839 
840         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
841         if (address(keccak256(pubkey)) == signer) return true;
842         else {
843             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
844             return (address(keccak256(pubkey)) == signer);
845         }
846     }
847 
848     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
849         bool sigok;
850 
851         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
852         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
853         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
854 
855         bytes memory appkey1_pubkey = new bytes(64);
856         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
857 
858         bytes memory tosign2 = new bytes(1+65+32);
859         tosign2[0] = byte(1); //role
860         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
861         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
862         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
863         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
864 
865         if (sigok == false) return false;
866 
867 
868         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
869         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
870 
871         bytes memory tosign3 = new bytes(1+65);
872         tosign3[0] = 0xFE;
873         copyBytes(proof, 3, 65, tosign3, 1);
874 
875         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
876         copyBytes(proof, 3+65, sig3.length, sig3, 0);
877 
878         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
879 
880         return sigok;
881     }
882 
883     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
884         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
885         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
886 
887         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
888         require(proofVerified);
889 
890         _;
891     }
892 
893     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
894         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
895         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
896 
897         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
898         if (proofVerified == false) return 2;
899 
900         return 0;
901     }
902 
903     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
904         bool match_ = true;
905 
906         require(prefix.length == n_random_bytes);
907 
908         for (uint256 i=0; i< n_random_bytes; i++) {
909             if (content[i] != prefix[i]) match_ = false;
910         }
911 
912         return match_;
913     }
914 
915     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
916 
917         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
918         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
919         bytes memory keyhash = new bytes(32);
920         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
921         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
922 
923         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
924         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
925 
926         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
927         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
928 
929         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
930         // This is to verify that the computed args match with the ones specified in the query.
931         bytes memory commitmentSlice1 = new bytes(8+1+32);
932         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
933 
934         bytes memory sessionPubkey = new bytes(64);
935         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
936         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
937 
938         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
939         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
940             delete oraclize_randomDS_args[queryId];
941         } else return false;
942 
943 
944         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
945         bytes memory tosign1 = new bytes(32+8+1+32);
946         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
947         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
948 
949         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
950         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
951             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
952         }
953 
954         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
955     }
956 
957     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
958     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
959         uint minLength = length + toOffset;
960 
961         // Buffer too small
962         require(to.length >= minLength); // Should be a better way?
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
1053 interface ERC20Contract {
1054   function transfer(address _to, uint256 _value) returns (bool success);
1055 }
1056 
1057 contract USDOracle is usingOraclize {
1058 
1059   // Price in cents as returned by the gdax api
1060   // GDAX is an fdic insured US based exchange
1061   // https://www.gdax.com/trade/ETH-USD
1062   uint256 public price;
1063   uint public lastUpdated = 0;
1064   // Price is valid for 1 hour
1065   uint public priceExpirationInterval = 21600;
1066   address owner;
1067 
1068   function USDOracle() public {
1069     owner = msg.sender;
1070     oraclize_query("URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price");
1071   }
1072 
1073   function () payable public { }
1074 
1075   function update() payable public {
1076     require(msg.value >= updateCost());
1077     oraclize_query("URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price");
1078   }
1079 
1080   function getPrice() public constant returns (uint256) {
1081     return price;
1082   }
1083 
1084   function priceNeedsUpdate() public constant returns (bool) {
1085     return block.timestamp > (lastUpdated + priceExpirationInterval);
1086   }
1087 
1088   function updateCost() public constant returns (uint256) {
1089     return usdToWei(1);
1090   }
1091 
1092   function usdToWei(uint _usd) public constant returns (uint256) {
1093     return 10**18 / getPrice() * _usd * 100;
1094   }
1095 
1096   function __callback(bytes32 _myid, string _result) public {
1097     require(msg.sender == oraclize_cbAddress());
1098     price = parseInt(_result, 2);
1099     lastUpdated = block.timestamp;
1100   }
1101 
1102   function withdraw(address _to) public {
1103     require(msg.sender == owner);
1104     _to.transfer(this.balance);
1105   }
1106 
1107   /**
1108    * For withdrawing any tokens sent to this address
1109    *
1110    **/
1111   function transferERC20(address _tokenAddress, address _to, uint256 _value) {
1112     require(msg.sender == owner);
1113     ERC20Contract(_tokenAddress).transfer(_to, _value);
1114   }
1115 
1116 }