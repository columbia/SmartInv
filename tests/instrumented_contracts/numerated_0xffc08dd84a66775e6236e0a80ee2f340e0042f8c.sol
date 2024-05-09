1 /*
2    Oraclize random-datasource example
3 
4    This contract uses the random-datasource to securely generate off-chain N random bytes
5 */
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
37 pragma solidity ^0.4.11; //please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
38 
39 contract OraclizeI {
40     address public cbAddress;
41     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
42     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
43     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
44     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
45     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
46     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
47     function getPrice(string _datasource) returns (uint _dsprice);
48     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
49     function useCoupon(string _coupon);
50     function setProofType(byte _proofType);
51     function setConfig(bytes32 _config);
52     function setCustomGasPrice(uint _gasPrice);
53     function randomDS_getSessionPubKeyHash() returns(bytes32);
54 }
55 contract OraclizeAddrResolverI {
56     function getAddress() returns (address _addr);
57 }
58 contract usingOraclize {
59     uint constant day = 60*60*24;
60     uint constant week = 60*60*24*7;
61     uint constant month = 60*60*24*30;
62     byte constant proofType_NONE = 0x00;
63     byte constant proofType_TLSNotary = 0x10;
64     byte constant proofType_Android = 0x20;
65     byte constant proofType_Ledger = 0x30;
66     byte constant proofType_Native = 0xF0;
67     byte constant proofStorage_IPFS = 0x01;
68     uint8 constant networkID_auto = 0;
69     uint8 constant networkID_mainnet = 1;
70     uint8 constant networkID_testnet = 2;
71     uint8 constant networkID_morden = 2;
72     uint8 constant networkID_consensys = 161;
73 
74     OraclizeAddrResolverI OAR;
75 
76     OraclizeI oraclize;
77     modifier oraclizeAPI {
78         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
79         oraclize = OraclizeI(OAR.getAddress());
80         _;
81     }
82     modifier coupon(string code){
83         oraclize = OraclizeI(OAR.getAddress());
84         oraclize.useCoupon(code);
85         _;
86     }
87 
88     function oraclize_setNetwork(uint8 networkID) internal returns(bool) {
89         networkID;
90         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
91             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
92             oraclize_setNetworkName("eth_mainnet");
93             return true;
94         }
95         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
96             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
97             oraclize_setNetworkName("eth_ropsten3");
98             return true;
99         }
100         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
101             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
102             oraclize_setNetworkName("eth_kovan");
103             return true;
104         }
105         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
106             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
107             oraclize_setNetworkName("eth_rinkeby");
108             return true;
109         }
110         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
111             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
112             return true;
113         }
114         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
115             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
116             return true;
117         }
118         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
119             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
120             return true;
121         }
122         return false;
123     }
124 
125     function __callback(bytes32 myid, string result) {
126         __callback(myid, result, new bytes(0));
127     }
128     function __callback(bytes32 myid, string result, bytes proof) {
129         myid;
130         result;
131         proof;
132     }
133     
134     function oraclize_useCoupon(string code) oraclizeAPI internal {
135         oraclize.useCoupon(code);
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
528     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
529         return oraclize.setConfig(config);
530     }
531     
532     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
533         return oraclize.randomDS_getSessionPubKeyHash();
534     }
535 
536     function getCodeSize(address _addr) constant internal returns(uint _size) {
537         _addr;
538         _size;
539         assembly {
540             _size := extcodesize(_addr)
541         }
542     }
543 
544     function parseAddr(string _a) internal returns (address){
545         bytes memory tmp = bytes(_a);
546         uint160 iaddr = 0;
547         uint160 b1;
548         uint160 b2;
549         for (uint i=2; i<2+2*20; i+=2){
550             iaddr *= 256;
551             b1 = uint160(tmp[i]);
552             b2 = uint160(tmp[i+1]);
553             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
554             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
555             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
556             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
557             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
558             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
559             iaddr += (b1*16+b2);
560         }
561         return address(iaddr);
562     }
563 
564     function strCompare(string _a, string _b) internal returns (int) {
565         bytes memory a = bytes(_a);
566         bytes memory b = bytes(_b);
567         uint minLength = a.length;
568         if (b.length < minLength) minLength = b.length;
569         for (uint i = 0; i < minLength; i ++)
570             if (a[i] < b[i])
571                 return -1;
572             else if (a[i] > b[i])
573                 return 1;
574         if (a.length < b.length)
575             return -1;
576         else if (a.length > b.length)
577             return 1;
578         else
579             return 0;
580     }
581 
582     function indexOf(string _haystack, string _needle) internal returns (int) {
583         bytes memory h = bytes(_haystack);
584         bytes memory n = bytes(_needle);
585         if(h.length < 1 || n.length < 1 || (n.length > h.length))
586             return -1;
587         else if(h.length > (2**128 -1))
588             return -1;
589         else
590         {
591             uint subindex = 0;
592             for (uint i = 0; i < h.length; i ++)
593             {
594                 if (h[i] == n[0])
595                 {
596                     subindex = 1;
597                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
598                     {
599                         subindex++;
600                     }
601                     if(subindex == n.length)
602                         return int(i);
603                 }
604             }
605             return -1;
606         }
607     }
608 
609     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
610         bytes memory _ba = bytes(_a);
611         bytes memory _bb = bytes(_b);
612         bytes memory _bc = bytes(_c);
613         bytes memory _bd = bytes(_d);
614         bytes memory _be = bytes(_e);
615         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
616         bytes memory babcde = bytes(abcde);
617         uint k = 0;
618         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
619         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
620         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
621         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
622         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
623         return string(babcde);
624     }
625 
626     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
627         return strConcat(_a, _b, _c, _d, "");
628     }
629 
630     function strConcat(string _a, string _b, string _c) internal returns (string) {
631         return strConcat(_a, _b, _c, "", "");
632     }
633 
634     function strConcat(string _a, string _b) internal returns (string) {
635         return strConcat(_a, _b, "", "", "");
636     }
637 
638     // parseInt
639     function parseInt(string _a) internal returns (uint) {
640         return parseInt(_a, 0);
641     }
642 
643     // parseInt(parseFloat*10^_b)
644     function parseInt(string _a, uint _b) internal returns (uint) {
645         bytes memory bresult = bytes(_a);
646         uint mint = 0;
647         bool decimals = false;
648         for (uint i=0; i<bresult.length; i++){
649             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
650                 if (decimals){
651                    if (_b == 0) break;
652                     else _b--;
653                 }
654                 mint *= 10;
655                 mint += uint(bresult[i]) - 48;
656             } else if (bresult[i] == 46) decimals = true;
657         }
658         if (_b > 0) mint *= 10**_b;
659         return mint;
660     }
661 
662     function uint2str(uint i) internal returns (string){
663         if (i == 0) return "0";
664         uint j = i;
665         uint len;
666         while (j != 0){
667             len++;
668             j /= 10;
669         }
670         bytes memory bstr = new bytes(len);
671         uint k = len - 1;
672         while (i != 0){
673             bstr[k--] = byte(48 + i % 10);
674             i /= 10;
675         }
676         return string(bstr);
677     }
678     
679     function stra2cbor(string[] arr) internal returns (bytes) {
680             uint arrlen = arr.length;
681 
682             // get correct cbor output length
683             uint outputlen = 0;
684             bytes[] memory elemArray = new bytes[](arrlen);
685             for (uint i = 0; i < arrlen; i++) {
686                 elemArray[i] = (bytes(arr[i]));
687                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
688             }
689             uint ctr = 0;
690             uint cborlen = arrlen + 0x80;
691             outputlen += byte(cborlen).length;
692             bytes memory res = new bytes(outputlen);
693 
694             while (byte(cborlen).length > ctr) {
695                 res[ctr] = byte(cborlen)[ctr];
696                 ctr++;
697             }
698             for (i = 0; i < arrlen; i++) {
699                 res[ctr] = 0x5F;
700                 ctr++;
701                 for (uint x = 0; x < elemArray[i].length; x++) {
702                     // if there's a bug with larger strings, this may be the culprit
703                     if (x % 23 == 0) {
704                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
705                         elemcborlen += 0x40;
706                         uint lctr = ctr;
707                         while (byte(elemcborlen).length > ctr - lctr) {
708                             res[ctr] = byte(elemcborlen)[ctr - lctr];
709                             ctr++;
710                         }
711                     }
712                     res[ctr] = elemArray[i][x];
713                     ctr++;
714                 }
715                 res[ctr] = 0xFF;
716                 ctr++;
717             }
718             return res;
719         }
720 
721     function ba2cbor(bytes[] arr) internal returns (bytes) {
722             uint arrlen = arr.length;
723 
724             // get correct cbor output length
725             uint outputlen = 0;
726             bytes[] memory elemArray = new bytes[](arrlen);
727             for (uint i = 0; i < arrlen; i++) {
728                 elemArray[i] = (bytes(arr[i]));
729                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
730             }
731             uint ctr = 0;
732             uint cborlen = arrlen + 0x80;
733             outputlen += byte(cborlen).length;
734             bytes memory res = new bytes(outputlen);
735 
736             while (byte(cborlen).length > ctr) {
737                 res[ctr] = byte(cborlen)[ctr];
738                 ctr++;
739             }
740             for (i = 0; i < arrlen; i++) {
741                 res[ctr] = 0x5F;
742                 ctr++;
743                 for (uint x = 0; x < elemArray[i].length; x++) {
744                     // if there's a bug with larger strings, this may be the culprit
745                     if (x % 23 == 0) {
746                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
747                         elemcborlen += 0x40;
748                         uint lctr = ctr;
749                         while (byte(elemcborlen).length > ctr - lctr) {
750                             res[ctr] = byte(elemcborlen)[ctr - lctr];
751                             ctr++;
752                         }
753                     }
754                     res[ctr] = elemArray[i][x];
755                     ctr++;
756                 }
757                 res[ctr] = 0xFF;
758                 ctr++;
759             }
760             return res;
761         }
762         
763         
764     string oraclize_network_name;
765     function oraclize_setNetworkName(string _network_name) internal {
766         oraclize_network_name = _network_name;
767     }
768     
769     function oraclize_getNetworkName() internal returns (string) {
770         return oraclize_network_name;
771     }
772     
773     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
774         if ((_nbytes == 0)||(_nbytes > 32)) throw;
775         bytes memory nbytes = new bytes(1);
776         nbytes[0] = byte(_nbytes);
777         bytes memory unonce = new bytes(32);
778         bytes memory sessionKeyHash = new bytes(32);
779         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
780         sessionKeyHash_bytes32;
781         assembly {
782             mstore(unonce, 0x20)
783             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
784             mstore(sessionKeyHash, 0x20)
785             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
786         }
787         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
788         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
789         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
790         return queryId;
791     }
792     
793     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
794         oraclize_randomDS_args[queryId] = commitment;
795     }
796     
797     mapping(bytes32=>bytes32) oraclize_randomDS_args;
798     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
799 
800     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
801         bool sigok;
802         address signer;
803         
804         bytes32 sigr;
805         bytes32 sigs;
806         
807         bytes memory sigr_ = new bytes(32);
808         uint offset = 4+(uint(dersig[3]) - 0x20);
809         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
810         bytes memory sigs_ = new bytes(32);
811         offset += 32 + 2;
812         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
813 
814         assembly {
815             sigr := mload(add(sigr_, 32))
816             sigs := mload(add(sigs_, 32))
817         }
818         
819         
820         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
821         if (address(sha3(pubkey)) == signer) return true;
822         else {
823             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
824             return (address(sha3(pubkey)) == signer);
825         }
826     }
827 
828     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
829         bool sigok;
830         
831         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
832         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
833         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
834         
835         bytes memory appkey1_pubkey = new bytes(64);
836         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
837         
838         bytes memory tosign2 = new bytes(1+65+32);
839         tosign2[0] = 1; //role
840         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
841         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
842         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
843         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
844         
845         if (sigok == false) return false;
846         
847         
848         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
849         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
850         
851         bytes memory tosign3 = new bytes(1+65);
852         tosign3[0] = 0xFE;
853         copyBytes(proof, 3, 65, tosign3, 1);
854         
855         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
856         copyBytes(proof, 3+65, sig3.length, sig3, 0);
857         
858         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
859         
860         return sigok;
861     }
862     
863     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
864         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
865         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
866         
867         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
868         if (proofVerified == false) throw;
869         
870         _;
871     }
872     
873     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
874         bool match_ = true;
875         
876         for (var i=0; i<prefix.length; i++){
877             if (content[i] != prefix[i]) match_ = false;
878         }
879         
880         return match_;
881     }
882 
883     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
884         bool checkok;
885         
886         
887         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
888         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
889         bytes memory keyhash = new bytes(32);
890         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
891         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
892         if (checkok == false) return false;
893         
894         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
895         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
896         
897         
898         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
899         checkok = matchBytes32Prefix(sha256(sig1), result);
900         if (checkok == false) return false;
901         
902         
903         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
904         // This is to verify that the computed args match with the ones specified in the query.
905         bytes memory commitmentSlice1 = new bytes(8+1+32);
906         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
907         
908         bytes memory sessionPubkey = new bytes(64);
909         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
910         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
911         
912         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
913         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
914             delete oraclize_randomDS_args[queryId];
915         } else return false;
916         
917         
918         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
919         bytes memory tosign1 = new bytes(32+8+1+32);
920         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
921         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
922         if (checkok == false) return false;
923         
924         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
925         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
926             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
927         }
928         
929         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
930     }
931 
932     
933     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
934     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
935         from;
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
967         hash;
968         v;
969         r;
970         s;
971         // FIXME: inline assembly can't access return values
972         bool ret;
973         address addr;
974 
975         assembly {
976             let size := mload(0x40)
977             mstore(size, hash)
978             mstore(add(size, 32), v)
979             mstore(add(size, 64), r)
980             mstore(add(size, 96), s)
981 
982             // NOTE: we can reuse the request memory because we deal with
983             //       the return code
984             ret := call(3000, 1, 0, size, 128, size, 32)
985             addr := mload(size)
986         }
987   
988         return (ret, addr);
989     }
990 
991     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
992     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
993         bytes32 r;
994         bytes32 s;
995         uint8 v;
996 
997         if (sig.length != 65)
998           return (false, 0);
999 
1000         // The signature format is a compact form of:
1001         //   {bytes32 r}{bytes32 s}{uint8 v}
1002         // Compact means, uint8 is not padded to 32 bytes.
1003         assembly {
1004             r := mload(add(sig, 32))
1005             s := mload(add(sig, 64))
1006 
1007             // Here we are loading the last 32 bytes. We exploit the fact that
1008             // 'mload' will pad with zeroes if we overread.
1009             // There is no 'mload8' to do this, but that would be nicer.
1010             v := byte(0, mload(add(sig, 96)))
1011 
1012             // Alternative solution:
1013             // 'byte' is not working due to the Solidity parser, so lets
1014             // use the second best option, 'and'
1015             // v := and(mload(add(sig, 65)), 255)
1016         }
1017 
1018         // albeit non-transactional signatures are not specified by the YP, one would expect it
1019         // to match the YP range of [27, 28]
1020         //
1021         // geth uses [0, 1] and some clients have followed. This might change, see:
1022         //  https://github.com/ethereum/go-ethereum/issues/2053
1023         if (v < 27)
1024           v += 27;
1025 
1026         if (v != 27 && v != 28)
1027             return (false, 0);
1028 
1029         return safer_ecrecover(hash, v, r, s);
1030     }
1031         
1032 }
1033 // </ORACLIZE_API>
1034 
1035 // EtherFlip
1036 
1037 contract token { function transfer(address receiver, uint amount){ receiver; amount; } }
1038 
1039 contract EtherFlip is usingOraclize {
1040     
1041     modifier ownerAction {
1042          if (msg.sender != owner) throw;
1043          _;
1044     }
1045     
1046     modifier oraclizeAction {
1047         if (msg.sender != oraclize_cbAddress()) throw;
1048         _;
1049     }
1050     
1051     //~ Events
1052     event newRandomByte(bytes);
1053     
1054     //~ Public Properties
1055     token public flipTokenReward;
1056     token public millionDollarTokenReward;
1057     int public generatedByte;
1058     
1059     //~ Base setup
1060     address public owner;
1061     
1062     //~ EtherFlip Properties
1063     uint public maxBet = (100000000000000000 * 1 wei);
1064     uint public minBet = (10000000000000000 * 1 wei);
1065     uint public singleTransGasCost = 4000000000000000; //API cost of Oraclize
1066     int public baseComparable = 133;
1067     uint public flipRewardAmount = 100;
1068     uint public mdtRewardAmount = 1;
1069     
1070     //~ Address & Amount hashes to accurately send transactions/winnings
1071     mapping (bytes32 => address) playerAddress;
1072     mapping (bytes32 => uint) playerAmount;
1073 
1074     function EtherFlip(token addressOfFlipToken, token addressOfMillionDollarToken) {
1075         owner = msg.sender;
1076         flipTokenReward = token(addressOfFlipToken);
1077         millionDollarTokenReward = token(addressOfMillionDollarToken);
1078         oraclize_setProof(proofType_Ledger);
1079     }
1080     
1081     function () payable {
1082         if (msg.sender != owner) {
1083             if (msg.value > maxBet) throw;
1084             if (msg.value < minBet) throw; 
1085         }
1086         oraclize_setProof(proofType_Ledger);
1087         uint numberOfBytes = 1;
1088         uint delay = 0;
1089         uint callbackGas = 200000;
1090         bytes32 queryId = oraclize_newRandomDSQuery(delay, numberOfBytes, callbackGas); 
1091         playerAddress[queryId] = msg.sender;
1092         playerAmount[queryId] = msg.value;
1093     }
1094     
1095     function __callback(bytes32 _queryId, string _result, bytes _proof) oraclize_randomDS_proofVerify(_queryId, _result, _proof) oraclizeAction { 
1096         if (msg.sender != oraclize_cbAddress()) throw;
1097         
1098         //Random byte result
1099         newRandomByte(bytes(_result));
1100         generatedByte = int(bytes(_result)[0]);
1101         uint amount = playerAmount[_queryId];
1102 
1103         if (generatedByte > baseComparable) {
1104             playerAddress[_queryId].transfer(amount + amount - singleTransGasCost - singleTransGasCost);
1105         } 
1106         if (generatedByte <= baseComparable) {
1107             if (flipRewardAmount > 0) {
1108                 flipTokenReward.transfer(playerAddress[_queryId], flipRewardAmount);
1109             }
1110         } 
1111         if (generatedByte == baseComparable) {
1112             if (mdtRewardAmount > 0) {
1113                 millionDollarTokenReward.transfer(playerAddress[_queryId], mdtRewardAmount); 
1114             }
1115         }
1116         delete playerAddress[_queryId];
1117         delete playerAmount[_queryId];
1118     }
1119     
1120     function updateMaxBet(uint updatedMaxBet) public ownerAction {
1121         maxBet = updatedMaxBet * 1 wei;
1122     }  
1123     
1124     function updateMinBet(uint updatedMinBet) public ownerAction {
1125         minBet = updatedMinBet * 1 wei;
1126     }
1127     
1128     function updateTotalGasCost(uint updatedGasCost) public ownerAction {
1129         singleTransGasCost = updatedGasCost;
1130     } 
1131     
1132     function updateBaseComparable(int updatedBaseComparable) public ownerAction {
1133         baseComparable = updatedBaseComparable;
1134     }
1135     
1136     function updateOwner(address updatedOwner) public ownerAction {
1137         owner = updatedOwner;
1138     }
1139     
1140     function updateFlipTokenRewardAmount(uint updatedRewardAmount) public ownerAction {
1141         flipRewardAmount = updatedRewardAmount;
1142     }
1143     
1144     function updateMDTRewardAmount(uint updatedRewardAmount) public ownerAction {
1145         mdtRewardAmount = updatedRewardAmount;
1146     }
1147     
1148     function ownerTransferEther(address outboundAddress, uint amount) public ownerAction {        
1149         if(!outboundAddress.send(amount)) throw;
1150     }
1151     
1152     function refundTransfer(address outboundAddress, uint amount) public ownerAction {        
1153         outboundAddress.transfer(amount);
1154     }
1155     
1156     function changeBonusTokenAddress(token updatedBonusToken) public ownerAction {
1157         millionDollarTokenReward = updatedBonusToken;
1158     }
1159     
1160 }