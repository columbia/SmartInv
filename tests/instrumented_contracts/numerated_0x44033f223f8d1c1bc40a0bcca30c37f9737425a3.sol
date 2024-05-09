1 pragma solidity ^ 0.4.8;
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
33 
34 contract OraclizeI {
35     address public cbAddress;
36     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
37     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
38     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
39     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
40     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
41     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
42     function getPrice(string _datasource) returns (uint _dsprice);
43     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
44     function useCoupon(string _coupon);
45     function setProofType(byte _proofType);
46     function setConfig(bytes32 _config);
47     function setCustomGasPrice(uint _gasPrice);
48     function randomDS_getSessionPubKeyHash() returns(bytes32);
49 }
50 contract OraclizeAddrResolverI {
51     function getAddress() returns (address _addr);
52 }
53 contract usingOraclize {
54     uint constant day = 60*60*24;
55     uint constant week = 60*60*24*7;
56     uint constant month = 60*60*24*30;
57     byte constant proofType_NONE = 0x00;
58     byte constant proofType_TLSNotary = 0x10;
59     byte constant proofType_Android = 0x20;
60     byte constant proofType_Ledger = 0x30;
61     byte constant proofType_Native = 0xF0;
62     byte constant proofStorage_IPFS = 0x01;
63     uint8 constant networkID_auto = 0;
64     uint8 constant networkID_mainnet = 1;
65     uint8 constant networkID_testnet = 2;
66     uint8 constant networkID_morden = 2;
67     uint8 constant networkID_consensys = 161;
68 
69     OraclizeAddrResolverI OAR;
70 
71     OraclizeI oraclize;
72     modifier oraclizeAPI {
73         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
74         oraclize = OraclizeI(OAR.getAddress());
75         _;
76     }
77     modifier coupon(string code){
78         oraclize = OraclizeI(OAR.getAddress());
79         oraclize.useCoupon(code);
80         _;
81     }
82 
83     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
84         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
85             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
86             oraclize_setNetworkName("eth_mainnet");
87             return true;
88         }
89         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
90             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
91             oraclize_setNetworkName("eth_ropsten3");
92             return true;
93         }
94         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
95             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
96             oraclize_setNetworkName("eth_kovan");
97             return true;
98         }
99         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
100             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
101             oraclize_setNetworkName("eth_rinkeby");
102             return true;
103         }
104         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
105             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
106             return true;
107         }
108         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
109             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
110             return true;
111         }
112         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
113             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
114             return true;
115         }
116         return false;
117     }
118 
119     function __callback(bytes32 myid, string result) {
120         __callback(myid, result, new bytes(0));
121     }
122     function __callback(bytes32 myid, string result, bytes proof) {
123     }
124     
125     function oraclize_useCoupon(string code) oraclizeAPI internal {
126         oraclize.useCoupon(code);
127     }
128 
129     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
130         return oraclize.getPrice(datasource);
131     }
132 
133     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
134         return oraclize.getPrice(datasource, gaslimit);
135     }
136     
137     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
138         uint price = oraclize.getPrice(datasource);
139         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
140         return oraclize.query.value(price)(0, datasource, arg);
141     }
142     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
143         uint price = oraclize.getPrice(datasource);
144         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
145         return oraclize.query.value(price)(timestamp, datasource, arg);
146     }
147     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
148         uint price = oraclize.getPrice(datasource, gaslimit);
149         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
150         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
151     }
152     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
153         uint price = oraclize.getPrice(datasource, gaslimit);
154         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
155         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
156     }
157     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
158         uint price = oraclize.getPrice(datasource);
159         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
160         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
161     }
162     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
163         uint price = oraclize.getPrice(datasource);
164         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
165         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
166     }
167     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
168         uint price = oraclize.getPrice(datasource, gaslimit);
169         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
170         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
171     }
172     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
173         uint price = oraclize.getPrice(datasource, gaslimit);
174         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
175         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
176     }
177     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
178         uint price = oraclize.getPrice(datasource);
179         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
180         bytes memory args = stra2cbor(argN);
181         return oraclize.queryN.value(price)(0, datasource, args);
182     }
183     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
184         uint price = oraclize.getPrice(datasource);
185         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
186         bytes memory args = stra2cbor(argN);
187         return oraclize.queryN.value(price)(timestamp, datasource, args);
188     }
189     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
190         uint price = oraclize.getPrice(datasource, gaslimit);
191         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
192         bytes memory args = stra2cbor(argN);
193         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
194     }
195     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
196         uint price = oraclize.getPrice(datasource, gaslimit);
197         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
198         bytes memory args = stra2cbor(argN);
199         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
200     }
201     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
202         string[] memory dynargs = new string[](1);
203         dynargs[0] = args[0];
204         return oraclize_query(datasource, dynargs);
205     }
206     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
207         string[] memory dynargs = new string[](1);
208         dynargs[0] = args[0];
209         return oraclize_query(timestamp, datasource, dynargs);
210     }
211     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
212         string[] memory dynargs = new string[](1);
213         dynargs[0] = args[0];
214         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
215     }
216     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
217         string[] memory dynargs = new string[](1);
218         dynargs[0] = args[0];       
219         return oraclize_query(datasource, dynargs, gaslimit);
220     }
221     
222     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
223         string[] memory dynargs = new string[](2);
224         dynargs[0] = args[0];
225         dynargs[1] = args[1];
226         return oraclize_query(datasource, dynargs);
227     }
228     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
229         string[] memory dynargs = new string[](2);
230         dynargs[0] = args[0];
231         dynargs[1] = args[1];
232         return oraclize_query(timestamp, datasource, dynargs);
233     }
234     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
235         string[] memory dynargs = new string[](2);
236         dynargs[0] = args[0];
237         dynargs[1] = args[1];
238         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
239     }
240     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
241         string[] memory dynargs = new string[](2);
242         dynargs[0] = args[0];
243         dynargs[1] = args[1];
244         return oraclize_query(datasource, dynargs, gaslimit);
245     }
246     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
247         string[] memory dynargs = new string[](3);
248         dynargs[0] = args[0];
249         dynargs[1] = args[1];
250         dynargs[2] = args[2];
251         return oraclize_query(datasource, dynargs);
252     }
253     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
254         string[] memory dynargs = new string[](3);
255         dynargs[0] = args[0];
256         dynargs[1] = args[1];
257         dynargs[2] = args[2];
258         return oraclize_query(timestamp, datasource, dynargs);
259     }
260     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
261         string[] memory dynargs = new string[](3);
262         dynargs[0] = args[0];
263         dynargs[1] = args[1];
264         dynargs[2] = args[2];
265         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
266     }
267     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
268         string[] memory dynargs = new string[](3);
269         dynargs[0] = args[0];
270         dynargs[1] = args[1];
271         dynargs[2] = args[2];
272         return oraclize_query(datasource, dynargs, gaslimit);
273     }
274     
275     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
276         string[] memory dynargs = new string[](4);
277         dynargs[0] = args[0];
278         dynargs[1] = args[1];
279         dynargs[2] = args[2];
280         dynargs[3] = args[3];
281         return oraclize_query(datasource, dynargs);
282     }
283     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
284         string[] memory dynargs = new string[](4);
285         dynargs[0] = args[0];
286         dynargs[1] = args[1];
287         dynargs[2] = args[2];
288         dynargs[3] = args[3];
289         return oraclize_query(timestamp, datasource, dynargs);
290     }
291     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
292         string[] memory dynargs = new string[](4);
293         dynargs[0] = args[0];
294         dynargs[1] = args[1];
295         dynargs[2] = args[2];
296         dynargs[3] = args[3];
297         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
298     }
299     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
300         string[] memory dynargs = new string[](4);
301         dynargs[0] = args[0];
302         dynargs[1] = args[1];
303         dynargs[2] = args[2];
304         dynargs[3] = args[3];
305         return oraclize_query(datasource, dynargs, gaslimit);
306     }
307     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
308         string[] memory dynargs = new string[](5);
309         dynargs[0] = args[0];
310         dynargs[1] = args[1];
311         dynargs[2] = args[2];
312         dynargs[3] = args[3];
313         dynargs[4] = args[4];
314         return oraclize_query(datasource, dynargs);
315     }
316     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
317         string[] memory dynargs = new string[](5);
318         dynargs[0] = args[0];
319         dynargs[1] = args[1];
320         dynargs[2] = args[2];
321         dynargs[3] = args[3];
322         dynargs[4] = args[4];
323         return oraclize_query(timestamp, datasource, dynargs);
324     }
325     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
326         string[] memory dynargs = new string[](5);
327         dynargs[0] = args[0];
328         dynargs[1] = args[1];
329         dynargs[2] = args[2];
330         dynargs[3] = args[3];
331         dynargs[4] = args[4];
332         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
333     }
334     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
335         string[] memory dynargs = new string[](5);
336         dynargs[0] = args[0];
337         dynargs[1] = args[1];
338         dynargs[2] = args[2];
339         dynargs[3] = args[3];
340         dynargs[4] = args[4];
341         return oraclize_query(datasource, dynargs, gaslimit);
342     }
343     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
344         uint price = oraclize.getPrice(datasource);
345         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
346         bytes memory args = ba2cbor(argN);
347         return oraclize.queryN.value(price)(0, datasource, args);
348     }
349     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
350         uint price = oraclize.getPrice(datasource);
351         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
352         bytes memory args = ba2cbor(argN);
353         return oraclize.queryN.value(price)(timestamp, datasource, args);
354     }
355     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
356         uint price = oraclize.getPrice(datasource, gaslimit);
357         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
358         bytes memory args = ba2cbor(argN);
359         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
360     }
361     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
362         uint price = oraclize.getPrice(datasource, gaslimit);
363         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
364         bytes memory args = ba2cbor(argN);
365         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
366     }
367     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
368         bytes[] memory dynargs = new bytes[](1);
369         dynargs[0] = args[0];
370         return oraclize_query(datasource, dynargs);
371     }
372     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
373         bytes[] memory dynargs = new bytes[](1);
374         dynargs[0] = args[0];
375         return oraclize_query(timestamp, datasource, dynargs);
376     }
377     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
378         bytes[] memory dynargs = new bytes[](1);
379         dynargs[0] = args[0];
380         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
381     }
382     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
383         bytes[] memory dynargs = new bytes[](1);
384         dynargs[0] = args[0];       
385         return oraclize_query(datasource, dynargs, gaslimit);
386     }
387     
388     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
389         bytes[] memory dynargs = new bytes[](2);
390         dynargs[0] = args[0];
391         dynargs[1] = args[1];
392         return oraclize_query(datasource, dynargs);
393     }
394     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
395         bytes[] memory dynargs = new bytes[](2);
396         dynargs[0] = args[0];
397         dynargs[1] = args[1];
398         return oraclize_query(timestamp, datasource, dynargs);
399     }
400     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
401         bytes[] memory dynargs = new bytes[](2);
402         dynargs[0] = args[0];
403         dynargs[1] = args[1];
404         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
405     }
406     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
407         bytes[] memory dynargs = new bytes[](2);
408         dynargs[0] = args[0];
409         dynargs[1] = args[1];
410         return oraclize_query(datasource, dynargs, gaslimit);
411     }
412     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
413         bytes[] memory dynargs = new bytes[](3);
414         dynargs[0] = args[0];
415         dynargs[1] = args[1];
416         dynargs[2] = args[2];
417         return oraclize_query(datasource, dynargs);
418     }
419     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
420         bytes[] memory dynargs = new bytes[](3);
421         dynargs[0] = args[0];
422         dynargs[1] = args[1];
423         dynargs[2] = args[2];
424         return oraclize_query(timestamp, datasource, dynargs);
425     }
426     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
427         bytes[] memory dynargs = new bytes[](3);
428         dynargs[0] = args[0];
429         dynargs[1] = args[1];
430         dynargs[2] = args[2];
431         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
432     }
433     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
434         bytes[] memory dynargs = new bytes[](3);
435         dynargs[0] = args[0];
436         dynargs[1] = args[1];
437         dynargs[2] = args[2];
438         return oraclize_query(datasource, dynargs, gaslimit);
439     }
440     
441     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
442         bytes[] memory dynargs = new bytes[](4);
443         dynargs[0] = args[0];
444         dynargs[1] = args[1];
445         dynargs[2] = args[2];
446         dynargs[3] = args[3];
447         return oraclize_query(datasource, dynargs);
448     }
449     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
450         bytes[] memory dynargs = new bytes[](4);
451         dynargs[0] = args[0];
452         dynargs[1] = args[1];
453         dynargs[2] = args[2];
454         dynargs[3] = args[3];
455         return oraclize_query(timestamp, datasource, dynargs);
456     }
457     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
458         bytes[] memory dynargs = new bytes[](4);
459         dynargs[0] = args[0];
460         dynargs[1] = args[1];
461         dynargs[2] = args[2];
462         dynargs[3] = args[3];
463         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
464     }
465     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
466         bytes[] memory dynargs = new bytes[](4);
467         dynargs[0] = args[0];
468         dynargs[1] = args[1];
469         dynargs[2] = args[2];
470         dynargs[3] = args[3];
471         return oraclize_query(datasource, dynargs, gaslimit);
472     }
473     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
474         bytes[] memory dynargs = new bytes[](5);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         dynargs[2] = args[2];
478         dynargs[3] = args[3];
479         dynargs[4] = args[4];
480         return oraclize_query(datasource, dynargs);
481     }
482     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
483         bytes[] memory dynargs = new bytes[](5);
484         dynargs[0] = args[0];
485         dynargs[1] = args[1];
486         dynargs[2] = args[2];
487         dynargs[3] = args[3];
488         dynargs[4] = args[4];
489         return oraclize_query(timestamp, datasource, dynargs);
490     }
491     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
492         bytes[] memory dynargs = new bytes[](5);
493         dynargs[0] = args[0];
494         dynargs[1] = args[1];
495         dynargs[2] = args[2];
496         dynargs[3] = args[3];
497         dynargs[4] = args[4];
498         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
499     }
500     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
501         bytes[] memory dynargs = new bytes[](5);
502         dynargs[0] = args[0];
503         dynargs[1] = args[1];
504         dynargs[2] = args[2];
505         dynargs[3] = args[3];
506         dynargs[4] = args[4];
507         return oraclize_query(datasource, dynargs, gaslimit);
508     }
509 
510     function oraclize_cbAddress() oraclizeAPI internal returns (address){
511         return oraclize.cbAddress();
512     }
513     function oraclize_setProof(byte proofP) oraclizeAPI internal {
514         return oraclize.setProofType(proofP);
515     }
516     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
517         return oraclize.setCustomGasPrice(gasPrice);
518     }
519     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
520         return oraclize.setConfig(config);
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
533     function parseAddr(string _a) internal returns (address){
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
553     function strCompare(string _a, string _b) internal returns (int) {
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
571     function indexOf(string _haystack, string _needle) internal returns (int) {
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
598     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
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
615     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
616         return strConcat(_a, _b, _c, _d, "");
617     }
618 
619     function strConcat(string _a, string _b, string _c) internal returns (string) {
620         return strConcat(_a, _b, _c, "", "");
621     }
622 
623     function strConcat(string _a, string _b) internal returns (string) {
624         return strConcat(_a, _b, "", "", "");
625     }
626 
627     // parseInt
628     function parseInt(string _a) internal returns (uint) {
629         return parseInt(_a, 0);
630     }
631 
632     // parseInt(parseFloat*10^_b)
633     function parseInt(string _a, uint _b) internal returns (uint) {
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
651     function uint2str(uint i) internal returns (string){
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
668     function stra2cbor(string[] arr) internal returns (bytes) {
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
710     function ba2cbor(bytes[] arr) internal returns (bytes) {
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
758     function oraclize_getNetworkName() internal returns (string) {
759         return oraclize_network_name;
760     }
761     
762     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
763         if ((_nbytes == 0)||(_nbytes > 32)) throw;
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
777         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
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
809         if (address(sha3(pubkey)) == signer) return true;
810         else {
811             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
812             return (address(sha3(pubkey)) == signer);
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
827         tosign2[0] = 1; //role
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
853         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
854         
855         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
856         if (proofVerified == false) throw;
857         
858         _;
859     }
860     
861     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
862         bool match_ = true;
863         
864         for (var i=0; i<prefix.length; i++){
865             if (content[i] != prefix[i]) match_ = false;
866         }
867         
868         return match_;
869     }
870 
871     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
872         bool checkok;
873         
874         
875         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
876         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
877         bytes memory keyhash = new bytes(32);
878         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
879         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
880         if (checkok == false) return false;
881         
882         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
883         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
884         
885         
886         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
887         checkok = matchBytes32Prefix(sha256(sig1), result);
888         if (checkok == false) return false;
889         
890         
891         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
892         // This is to verify that the computed args match with the ones specified in the query.
893         bytes memory commitmentSlice1 = new bytes(8+1+32);
894         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
895         
896         bytes memory sessionPubkey = new bytes(64);
897         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
898         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
899         
900         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
901         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
902             delete oraclize_randomDS_args[queryId];
903         } else return false;
904         
905         
906         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
907         bytes memory tosign1 = new bytes(32+8+1+32);
908         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
909         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
910         if (checkok == false) return false;
911         
912         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
913         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
914             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
915         }
916         
917         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
918     }
919 
920     
921     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
922     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
923         uint minLength = length + toOffset;
924 
925         if (to.length < minLength) {
926             // Buffer too small
927             throw; // Should be a better way?
928         }
929 
930         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
931         uint i = 32 + fromOffset;
932         uint j = 32 + toOffset;
933 
934         while (i < (32 + fromOffset + length)) {
935             assembly {
936                 let tmp := mload(add(from, i))
937                 mstore(add(to, j), tmp)
938             }
939             i += 32;
940             j += 32;
941         }
942 
943         return to;
944     }
945     
946     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
947     // Duplicate Solidity's ecrecover, but catching the CALL return value
948     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
949         // We do our own memory management here. Solidity uses memory offset
950         // 0x40 to store the current end of memory. We write past it (as
951         // writes are memory extensions), but don't update the offset so
952         // Solidity will reuse it. The memory used here is only needed for
953         // this context.
954 
955         // FIXME: inline assembly can't access return values
956         bool ret;
957         address addr;
958 
959         assembly {
960             let size := mload(0x40)
961             mstore(size, hash)
962             mstore(add(size, 32), v)
963             mstore(add(size, 64), r)
964             mstore(add(size, 96), s)
965 
966             // NOTE: we can reuse the request memory because we deal with
967             //       the return code
968             ret := call(3000, 1, 0, size, 128, size, 32)
969             addr := mload(size)
970         }
971   
972         return (ret, addr);
973     }
974 
975     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
976     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
977         bytes32 r;
978         bytes32 s;
979         uint8 v;
980 
981         if (sig.length != 65)
982           return (false, 0);
983 
984         // The signature format is a compact form of:
985         //   {bytes32 r}{bytes32 s}{uint8 v}
986         // Compact means, uint8 is not padded to 32 bytes.
987         assembly {
988             r := mload(add(sig, 32))
989             s := mload(add(sig, 64))
990 
991             // Here we are loading the last 32 bytes. We exploit the fact that
992             // 'mload' will pad with zeroes if we overread.
993             // There is no 'mload8' to do this, but that would be nicer.
994             v := byte(0, mload(add(sig, 96)))
995 
996             // Alternative solution:
997             // 'byte' is not working due to the Solidity parser, so lets
998             // use the second best option, 'and'
999             // v := and(mload(add(sig, 65)), 255)
1000         }
1001 
1002         // albeit non-transactional signatures are not specified by the YP, one would expect it
1003         // to match the YP range of [27, 28]
1004         //
1005         // geth uses [0, 1] and some clients have followed. This might change, see:
1006         //  https://github.com/ethereum/go-ethereum/issues/2053
1007         if (v < 27)
1008           v += 27;
1009 
1010         if (v != 27 && v != 28)
1011             return (false, 0);
1012 
1013         return safer_ecrecover(hash, v, r, s);
1014     }
1015         
1016 }
1017 // </ORACLIZE_API>
1018 
1019 contract ERC20 {
1020 
1021     uint public totalSupply;
1022 
1023     function balanceOf(address who) constant returns(uint256);
1024 
1025     function allowance(address owner, address spender) constant returns(uint);
1026 
1027     function transferFrom(address from, address to, uint value) returns(bool ok);
1028 
1029     function approve(address spender, uint value) returns(bool ok);
1030 
1031     function transfer(address to, uint value) returns(bool ok);
1032 
1033     event Transfer(address indexed from, address indexed to, uint value);
1034 
1035     event Approval(address indexed owner, address indexed spender, uint value);
1036 
1037 }
1038 
1039 contract METAXCrowdSale is ERC20, usingOraclize
1040 
1041 {
1042 
1043     address[] public addresses;
1044 
1045     // Name of the token
1046     string public constant name = "METAX";
1047 
1048     // Symbol of token
1049     string public constant symbol = "METAX";
1050     uint8 public constant decimals = 4; // decimal places
1051 
1052     mapping(address => address) public userStructs;
1053 
1054     uint public totalSupply = 15000000 * 10000; // 15 million total supply includes decimals
1055 
1056     mapping(address => uint) balances;
1057 
1058     mapping(address => mapping(address => uint)) allowed;
1059     
1060       mapping (address => bool) reward;         // mapping to store user reward status
1061 
1062 
1063     address owner;
1064 
1065     mapping(bytes32 => address) userAddress; // mapping to store user address
1066     mapping(address => uint) uservalue; // mapping to store user value
1067     mapping(bytes32 => bytes32) userqueryID; // mapping to store user oracalize query id
1068 
1069       
1070     uint256 one_token_price = 1; // 1 usd price
1071      uint256 one_ether_usd_price;
1072   
1073  
1074     uint currentdate;
1075     uint ico_end_date;
1076 
1077 
1078     // Functions with this modifier can only be executed by the owner
1079     modifier onlyOwner() {
1080         if (msg.sender != owner) {
1081             revert();
1082         }
1083         _;
1084     }
1085 
1086     event TRANS(address accountAddress, uint amount);
1087     event Message(string message, address to_, uint token_amount);
1088 
1089     event Tokens(string ethh, uint tokens);
1090     bool crowd_sale_status = true;
1091    
1092 
1093 
1094     function METAXCrowdSale() {
1095         owner = msg.sender;
1096         balances[owner] = 6000000 * 10000; // 6 million for core team as owner , includes 4 zeros extra for decimals
1097         
1098         balances[address(this)] = 9000000 * 10000; // 9 million to contract address for crowdsale
1099 
1100         currentdate = now;
1101         ico_end_date = currentdate + 30 days; // 1month crowdsale
1102 
1103     }
1104 
1105     // called when someone sends ether to this smart contract address
1106     function() payable {
1107     if(crowd_sale_status)
1108     {
1109 
1110         if (msg.sender != owner && now <= ico_end_date) {
1111 
1112           bytes32 ID = oraclize_query("URL", "json(https://poloniex.com/public?command=returnTicker).USDT_ETH.last",500000);
1113            
1114             userAddress[ID] = msg.sender;
1115             uservalue[msg.sender] = msg.value;
1116             userqueryID[ID] = ID;
1117             
1118         } else if (msg.sender != owner && now > ico_end_date) {
1119             revert();
1120         }
1121     }
1122     else
1123     revert();
1124 
1125     }
1126     
1127           // callback function of oracalize which is called when oracalize query return result
1128     function __callback(bytes32 myid, string result) {
1129         if (msg.sender != oraclize_cbAddress()) {
1130             // just to be sure the calling address is the Oraclize authorized one
1131             revert();
1132         }
1133         
1134         Tokens(result,1);
1135         
1136          if (userqueryID[myid] == myid) {
1137         
1138            one_ether_usd_price = stringToUint(result);
1139            
1140      
1141         uint no_of_tokens = ((one_ether_usd_price * uservalue[userAddress[myid]]) )  / (one_token_price * 10**22); 
1142          if (balanceOf(address(this)) > no_of_tokens) {
1143 
1144         
1145         balances[address(this)] -= no_of_tokens;
1146         balances[userAddress[myid]] += no_of_tokens;
1147         check_array_add(userAddress[myid]);
1148         Message("transferred to",userAddress[myid],no_of_tokens);
1149          }
1150          else
1151          revert();
1152     }
1153     }
1154 
1155     // end crowdsale sholud be called by owner after ico end date
1156     function end_crowdsale() onlyOwner {
1157         burn(address(this), balances[address(this)]);
1158      }
1159 
1160      function burn(address _from, uint256 _amount ) internal
1161        {
1162            if(_amount >0)
1163            {
1164             balances[_from] = balances[_from] - _amount;
1165             totalSupply = totalSupply - _amount;
1166            }
1167           crowd_sale_status =false;
1168        }
1169 
1170 
1171     function balanceOf(address sender) constant returns(uint256 balance) {
1172 
1173         return balances[sender];
1174     }
1175 
1176     // Transfer the balance from owner's account to another account
1177     function transfer(address _to, uint256 _amount) returns(bool success) {
1178         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
1179         if (balances[msg.sender] < _amount) throw; // Check if the sender has enough
1180 
1181         if (balances[_to] + _amount < balances[_to]) throw; // Check for overflows
1182        
1183         balances[msg.sender] -= _amount; // Subtract from the sender
1184         balances[_to] += _amount; // Add the same to the recipient
1185         Transfer(msg.sender, _to, _amount); // Notify anyone listening that this transfer took place
1186         return true;
1187     }
1188 
1189     function transfer_token(address sender, address to, uint amount) internal {
1190         balances[sender] -= amount;
1191         balances[to] += amount;
1192         Transfer(sender, to, amount);
1193 
1194         check_array_add(to);
1195     }
1196 
1197     function gettotal_Supply() constant returns(uint) {
1198     
1199         return totalSupply;
1200     }
1201 
1202     // function used in Reward contract to know address of token holder
1203     function getAddress(uint i) constant returns(address) {
1204         return addresses[i];
1205     }
1206     // function used in Reward contract to get to know the address array length
1207     function getarray_length() returns(uint) {
1208 
1209         return addresses.length;
1210 
1211     }
1212     // used in reward contract
1213      function rewarded_refresh()
1214     {
1215         for(uint i = 0; i < addresses.length; i++) {
1216           
1217             reward[addresses[i]] = true;
1218           
1219         }
1220          
1221     }
1222 
1223     function check_array_add(address _to) internal {
1224         if (addresses.length > 0) {
1225             if (userStructs[_to] != _to) {
1226                 userStructs[_to] = _to;
1227                 addresses.push(_to);
1228             }
1229         } else {
1230             userStructs[_to] = _to;
1231             addresses.push(_to);
1232         }
1233     }
1234 
1235 
1236     // Send _value amount of tokens from address _from to address _to
1237     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
1238     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
1239     // fees in sub-currencies; the command should fail unless the _from account has
1240     // deliberately authorized the sender of the message via some mechanism; we propose
1241     // these standardized APIs for approval:
1242 
1243     function transferFrom(
1244         address _from,
1245         address _to,
1246         uint256 _amount
1247     ) returns(bool success) {
1248         if (balances[_from] >= _amount &&
1249             allowed[_from][msg.sender] >= _amount &&
1250             _amount > 0 &&
1251             balances[_to] + _amount > balances[_to]) {
1252             balances[_from] -= _amount;
1253             allowed[_from][msg.sender] -= _amount;
1254             balances[_to] += _amount;
1255             Transfer(_from, _to, _amount);
1256             return true;
1257         } else {
1258             return false;
1259         }
1260     }
1261 
1262     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
1263     // If this function is called again it overwrites the current allowance with _value.
1264     function approve(address _spender, uint256 _amount) returns(bool success) {
1265         allowed[msg.sender][_spender] = _amount;
1266         Approval(msg.sender, _spender, _amount);
1267         return true;
1268     }
1269 
1270     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
1271         return allowed[_owner][_spender];
1272     }
1273 
1274   
1275     // Failsafe drain
1276 
1277     function drain() onlyOwner {
1278         if (!owner.send(this.balance)) revert();
1279     }
1280 
1281     //Below function will convert string to integer removing decimal
1282     function stringToUint(string s) returns(uint) {
1283         bytes memory b = bytes(s);
1284         uint i;
1285         uint result1 = 0;
1286         for (i = 0; i < b.length; i++) {
1287             uint c = uint(b[i]);
1288             if (c == 46) {
1289                 // Do nothing --this will skip the decimal
1290             } else if (c >= 48 && c <= 57) {
1291                 result1 = result1 * 10 + (c - 48);
1292                 // usd_price=result;
1293 
1294             }
1295         }
1296         return result1;
1297     }
1298 
1299   
1300     // used in reward contract
1301       function getRewardStatus(address addr) returns (bool isReward) {
1302         return reward[addr];
1303     }
1304     // used in reward contract
1305     function setRewardStatus(address addr, bool status) {
1306         reward[addr] = status;
1307     }
1308 
1309 
1310 }