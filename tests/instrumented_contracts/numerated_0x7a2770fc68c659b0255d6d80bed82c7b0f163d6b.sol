1 pragma solidity ^0.4.14;
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
72         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
73         oraclize = OraclizeI(OAR.getAddress());
74         _;
75     }
76     modifier coupon(string code){
77         oraclize = OraclizeI(OAR.getAddress());
78         oraclize.useCoupon(code);
79         _;
80     }
81 
82     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
83         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
84             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
85             oraclize_setNetworkName("eth_mainnet");
86             return true;
87         }
88         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
89             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
90             oraclize_setNetworkName("eth_ropsten3");
91             return true;
92         }
93         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
94             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
95             oraclize_setNetworkName("eth_kovan");
96             return true;
97         }
98         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
99             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
100             oraclize_setNetworkName("eth_rinkeby");
101             return true;
102         }
103         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
104             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
105             return true;
106         }
107         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
108             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
109             return true;
110         }
111         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
112             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
113             return true;
114         }
115         return false;
116     }
117     
118     function oraclize_useCoupon(string code) oraclizeAPI internal {
119         oraclize.useCoupon(code);
120     }
121 
122     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
123         return oraclize.getPrice(datasource);
124     }
125 
126     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
127         return oraclize.getPrice(datasource, gaslimit);
128     }
129     
130     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
131         uint price = oraclize.getPrice(datasource);
132         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
133         return oraclize.query.value(price)(0, datasource, arg);
134     }
135     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
136         uint price = oraclize.getPrice(datasource);
137         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
138         return oraclize.query.value(price)(timestamp, datasource, arg);
139     }
140     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
141         uint price = oraclize.getPrice(datasource, gaslimit);
142         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
143         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
144     }
145     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
146         uint price = oraclize.getPrice(datasource, gaslimit);
147         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
148         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
149     }
150     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
151         uint price = oraclize.getPrice(datasource);
152         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
153         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
154     }
155     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
156         uint price = oraclize.getPrice(datasource);
157         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
158         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
159     }
160     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
161         uint price = oraclize.getPrice(datasource, gaslimit);
162         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
163         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
164     }
165     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
166         uint price = oraclize.getPrice(datasource, gaslimit);
167         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
168         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
169     }
170     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
171         uint price = oraclize.getPrice(datasource);
172         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
173         bytes memory args = stra2cbor(argN);
174         return oraclize.queryN.value(price)(0, datasource, args);
175     }
176     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
177         uint price = oraclize.getPrice(datasource);
178         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
179         bytes memory args = stra2cbor(argN);
180         return oraclize.queryN.value(price)(timestamp, datasource, args);
181     }
182     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
183         uint price = oraclize.getPrice(datasource, gaslimit);
184         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
185         bytes memory args = stra2cbor(argN);
186         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
187     }
188     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
189         uint price = oraclize.getPrice(datasource, gaslimit);
190         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
191         bytes memory args = stra2cbor(argN);
192         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
193     }
194     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
195         string[] memory dynargs = new string[](1);
196         dynargs[0] = args[0];
197         return oraclize_query(datasource, dynargs);
198     }
199     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
200         string[] memory dynargs = new string[](1);
201         dynargs[0] = args[0];
202         return oraclize_query(timestamp, datasource, dynargs);
203     }
204     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
205         string[] memory dynargs = new string[](1);
206         dynargs[0] = args[0];
207         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
208     }
209     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
210         string[] memory dynargs = new string[](1);
211         dynargs[0] = args[0];       
212         return oraclize_query(datasource, dynargs, gaslimit);
213     }
214     
215     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
216         string[] memory dynargs = new string[](2);
217         dynargs[0] = args[0];
218         dynargs[1] = args[1];
219         return oraclize_query(datasource, dynargs);
220     }
221     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
222         string[] memory dynargs = new string[](2);
223         dynargs[0] = args[0];
224         dynargs[1] = args[1];
225         return oraclize_query(timestamp, datasource, dynargs);
226     }
227     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
228         string[] memory dynargs = new string[](2);
229         dynargs[0] = args[0];
230         dynargs[1] = args[1];
231         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
232     }
233     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
234         string[] memory dynargs = new string[](2);
235         dynargs[0] = args[0];
236         dynargs[1] = args[1];
237         return oraclize_query(datasource, dynargs, gaslimit);
238     }
239     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
240         string[] memory dynargs = new string[](3);
241         dynargs[0] = args[0];
242         dynargs[1] = args[1];
243         dynargs[2] = args[2];
244         return oraclize_query(datasource, dynargs);
245     }
246     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
247         string[] memory dynargs = new string[](3);
248         dynargs[0] = args[0];
249         dynargs[1] = args[1];
250         dynargs[2] = args[2];
251         return oraclize_query(timestamp, datasource, dynargs);
252     }
253     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
254         string[] memory dynargs = new string[](3);
255         dynargs[0] = args[0];
256         dynargs[1] = args[1];
257         dynargs[2] = args[2];
258         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
259     }
260     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
261         string[] memory dynargs = new string[](3);
262         dynargs[0] = args[0];
263         dynargs[1] = args[1];
264         dynargs[2] = args[2];
265         return oraclize_query(datasource, dynargs, gaslimit);
266     }
267     
268     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
269         string[] memory dynargs = new string[](4);
270         dynargs[0] = args[0];
271         dynargs[1] = args[1];
272         dynargs[2] = args[2];
273         dynargs[3] = args[3];
274         return oraclize_query(datasource, dynargs);
275     }
276     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
277         string[] memory dynargs = new string[](4);
278         dynargs[0] = args[0];
279         dynargs[1] = args[1];
280         dynargs[2] = args[2];
281         dynargs[3] = args[3];
282         return oraclize_query(timestamp, datasource, dynargs);
283     }
284     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
285         string[] memory dynargs = new string[](4);
286         dynargs[0] = args[0];
287         dynargs[1] = args[1];
288         dynargs[2] = args[2];
289         dynargs[3] = args[3];
290         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
291     }
292     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
293         string[] memory dynargs = new string[](4);
294         dynargs[0] = args[0];
295         dynargs[1] = args[1];
296         dynargs[2] = args[2];
297         dynargs[3] = args[3];
298         return oraclize_query(datasource, dynargs, gaslimit);
299     }
300     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
301         string[] memory dynargs = new string[](5);
302         dynargs[0] = args[0];
303         dynargs[1] = args[1];
304         dynargs[2] = args[2];
305         dynargs[3] = args[3];
306         dynargs[4] = args[4];
307         return oraclize_query(datasource, dynargs);
308     }
309     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
310         string[] memory dynargs = new string[](5);
311         dynargs[0] = args[0];
312         dynargs[1] = args[1];
313         dynargs[2] = args[2];
314         dynargs[3] = args[3];
315         dynargs[4] = args[4];
316         return oraclize_query(timestamp, datasource, dynargs);
317     }
318     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
319         string[] memory dynargs = new string[](5);
320         dynargs[0] = args[0];
321         dynargs[1] = args[1];
322         dynargs[2] = args[2];
323         dynargs[3] = args[3];
324         dynargs[4] = args[4];
325         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
326     }
327     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
328         string[] memory dynargs = new string[](5);
329         dynargs[0] = args[0];
330         dynargs[1] = args[1];
331         dynargs[2] = args[2];
332         dynargs[3] = args[3];
333         dynargs[4] = args[4];
334         return oraclize_query(datasource, dynargs, gaslimit);
335     }
336     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
337         uint price = oraclize.getPrice(datasource);
338         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
339         bytes memory args = ba2cbor(argN);
340         return oraclize.queryN.value(price)(0, datasource, args);
341     }
342     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
343         uint price = oraclize.getPrice(datasource);
344         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
345         bytes memory args = ba2cbor(argN);
346         return oraclize.queryN.value(price)(timestamp, datasource, args);
347     }
348     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
349         uint price = oraclize.getPrice(datasource, gaslimit);
350         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
351         bytes memory args = ba2cbor(argN);
352         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
353     }
354     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
355         uint price = oraclize.getPrice(datasource, gaslimit);
356         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
357         bytes memory args = ba2cbor(argN);
358         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
359     }
360     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
361         bytes[] memory dynargs = new bytes[](1);
362         dynargs[0] = args[0];
363         return oraclize_query(datasource, dynargs);
364     }
365     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
366         bytes[] memory dynargs = new bytes[](1);
367         dynargs[0] = args[0];
368         return oraclize_query(timestamp, datasource, dynargs);
369     }
370     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
371         bytes[] memory dynargs = new bytes[](1);
372         dynargs[0] = args[0];
373         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
374     }
375     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
376         bytes[] memory dynargs = new bytes[](1);
377         dynargs[0] = args[0];       
378         return oraclize_query(datasource, dynargs, gaslimit);
379     }
380     
381     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
382         bytes[] memory dynargs = new bytes[](2);
383         dynargs[0] = args[0];
384         dynargs[1] = args[1];
385         return oraclize_query(datasource, dynargs);
386     }
387     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
388         bytes[] memory dynargs = new bytes[](2);
389         dynargs[0] = args[0];
390         dynargs[1] = args[1];
391         return oraclize_query(timestamp, datasource, dynargs);
392     }
393     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
394         bytes[] memory dynargs = new bytes[](2);
395         dynargs[0] = args[0];
396         dynargs[1] = args[1];
397         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
398     }
399     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
400         bytes[] memory dynargs = new bytes[](2);
401         dynargs[0] = args[0];
402         dynargs[1] = args[1];
403         return oraclize_query(datasource, dynargs, gaslimit);
404     }
405     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
406         bytes[] memory dynargs = new bytes[](3);
407         dynargs[0] = args[0];
408         dynargs[1] = args[1];
409         dynargs[2] = args[2];
410         return oraclize_query(datasource, dynargs);
411     }
412     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
413         bytes[] memory dynargs = new bytes[](3);
414         dynargs[0] = args[0];
415         dynargs[1] = args[1];
416         dynargs[2] = args[2];
417         return oraclize_query(timestamp, datasource, dynargs);
418     }
419     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
420         bytes[] memory dynargs = new bytes[](3);
421         dynargs[0] = args[0];
422         dynargs[1] = args[1];
423         dynargs[2] = args[2];
424         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
425     }
426     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
427         bytes[] memory dynargs = new bytes[](3);
428         dynargs[0] = args[0];
429         dynargs[1] = args[1];
430         dynargs[2] = args[2];
431         return oraclize_query(datasource, dynargs, gaslimit);
432     }
433     
434     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
435         bytes[] memory dynargs = new bytes[](4);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         dynargs[2] = args[2];
439         dynargs[3] = args[3];
440         return oraclize_query(datasource, dynargs);
441     }
442     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
443         bytes[] memory dynargs = new bytes[](4);
444         dynargs[0] = args[0];
445         dynargs[1] = args[1];
446         dynargs[2] = args[2];
447         dynargs[3] = args[3];
448         return oraclize_query(timestamp, datasource, dynargs);
449     }
450     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
451         bytes[] memory dynargs = new bytes[](4);
452         dynargs[0] = args[0];
453         dynargs[1] = args[1];
454         dynargs[2] = args[2];
455         dynargs[3] = args[3];
456         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
457     }
458     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
459         bytes[] memory dynargs = new bytes[](4);
460         dynargs[0] = args[0];
461         dynargs[1] = args[1];
462         dynargs[2] = args[2];
463         dynargs[3] = args[3];
464         return oraclize_query(datasource, dynargs, gaslimit);
465     }
466     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
467         bytes[] memory dynargs = new bytes[](5);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         dynargs[2] = args[2];
471         dynargs[3] = args[3];
472         dynargs[4] = args[4];
473         return oraclize_query(datasource, dynargs);
474     }
475     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
476         bytes[] memory dynargs = new bytes[](5);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         dynargs[2] = args[2];
480         dynargs[3] = args[3];
481         dynargs[4] = args[4];
482         return oraclize_query(timestamp, datasource, dynargs);
483     }
484     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
485         bytes[] memory dynargs = new bytes[](5);
486         dynargs[0] = args[0];
487         dynargs[1] = args[1];
488         dynargs[2] = args[2];
489         dynargs[3] = args[3];
490         dynargs[4] = args[4];
491         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
492     }
493     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
494         bytes[] memory dynargs = new bytes[](5);
495         dynargs[0] = args[0];
496         dynargs[1] = args[1];
497         dynargs[2] = args[2];
498         dynargs[3] = args[3];
499         dynargs[4] = args[4];
500         return oraclize_query(datasource, dynargs, gaslimit);
501     }
502 
503     function oraclize_cbAddress() oraclizeAPI internal returns (address){
504         return oraclize.cbAddress();
505     }
506     function oraclize_setProof(byte proofP) oraclizeAPI internal {
507         return oraclize.setProofType(proofP);
508     }
509     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
510         return oraclize.setCustomGasPrice(gasPrice);
511     }
512     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
513         return oraclize.setConfig(config);
514     }
515     
516     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
517         return oraclize.randomDS_getSessionPubKeyHash();
518     }
519 
520     function getCodeSize(address _addr) constant internal returns(uint _size) {
521         assembly {
522             _size := extcodesize(_addr)
523         }
524     }
525 
526     function parseAddr(string _a) internal returns (address){
527         bytes memory tmp = bytes(_a);
528         uint160 iaddr = 0;
529         uint160 b1;
530         uint160 b2;
531         for (uint i=2; i<2+2*20; i+=2){
532             iaddr *= 256;
533             b1 = uint160(tmp[i]);
534             b2 = uint160(tmp[i+1]);
535             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
536             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
537             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
538             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
539             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
540             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
541             iaddr += (b1*16+b2);
542         }
543         return address(iaddr);
544     }
545 
546     function strCompare(string _a, string _b) internal returns (int) {
547         bytes memory a = bytes(_a);
548         bytes memory b = bytes(_b);
549         uint minLength = a.length;
550         if (b.length < minLength) minLength = b.length;
551         for (uint i = 0; i < minLength; i ++)
552             if (a[i] < b[i])
553                 return -1;
554             else if (a[i] > b[i])
555                 return 1;
556         if (a.length < b.length)
557             return -1;
558         else if (a.length > b.length)
559             return 1;
560         else
561             return 0;
562     }
563 
564     function indexOf(string _haystack, string _needle) internal returns (int) {
565         bytes memory h = bytes(_haystack);
566         bytes memory n = bytes(_needle);
567         if(h.length < 1 || n.length < 1 || (n.length > h.length))
568             return -1;
569         else if(h.length > (2**128 -1))
570             return -1;
571         else
572         {
573             uint subindex = 0;
574             for (uint i = 0; i < h.length; i ++)
575             {
576                 if (h[i] == n[0])
577                 {
578                     subindex = 1;
579                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
580                     {
581                         subindex++;
582                     }
583                     if(subindex == n.length)
584                         return int(i);
585                 }
586             }
587             return -1;
588         }
589     }
590 
591     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
592         bytes memory _ba = bytes(_a);
593         bytes memory _bb = bytes(_b);
594         bytes memory _bc = bytes(_c);
595         bytes memory _bd = bytes(_d);
596         bytes memory _be = bytes(_e);
597         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
598         bytes memory babcde = bytes(abcde);
599         uint k = 0;
600         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
601         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
602         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
603         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
604         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
605         return string(babcde);
606     }
607 
608     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
609         return strConcat(_a, _b, _c, _d, "");
610     }
611 
612     function strConcat(string _a, string _b, string _c) internal returns (string) {
613         return strConcat(_a, _b, _c, "", "");
614     }
615 
616     function strConcat(string _a, string _b) internal returns (string) {
617         return strConcat(_a, _b, "", "", "");
618     }
619 
620     // parseInt
621     function parseInt(string _a) internal returns (uint) {
622         return parseInt(_a, 0);
623     }
624 
625     // parseInt(parseFloat*10^_b)
626     function parseInt(string _a, uint _b) internal returns (uint) {
627         bytes memory bresult = bytes(_a);
628         uint mint = 0;
629         bool decimals = false;
630         for (uint i=0; i<bresult.length; i++){
631             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
632                 if (decimals){
633                    if (_b == 0) break;
634                     else _b--;
635                 }
636                 mint *= 10;
637                 mint += uint(bresult[i]) - 48;
638             } else if (bresult[i] == 46) decimals = true;
639         }
640         if (_b > 0) mint *= 10**_b;
641         return mint;
642     }
643 
644     function uint2str(uint i) internal returns (string){
645         if (i == 0) return "0";
646         uint j = i;
647         uint len;
648         while (j != 0){
649             len++;
650             j /= 10;
651         }
652         bytes memory bstr = new bytes(len);
653         uint k = len - 1;
654         while (i != 0){
655             bstr[k--] = byte(48 + i % 10);
656             i /= 10;
657         }
658         return string(bstr);
659     }
660     
661     function stra2cbor(string[] arr) internal returns (bytes) {
662             uint arrlen = arr.length;
663 
664             // get correct cbor output length
665             uint outputlen = 0;
666             bytes[] memory elemArray = new bytes[](arrlen);
667             for (uint i = 0; i < arrlen; i++) {
668                 elemArray[i] = (bytes(arr[i]));
669                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
670             }
671             uint ctr = 0;
672             uint cborlen = arrlen + 0x80;
673             outputlen += byte(cborlen).length;
674             bytes memory res = new bytes(outputlen);
675 
676             while (byte(cborlen).length > ctr) {
677                 res[ctr] = byte(cborlen)[ctr];
678                 ctr++;
679             }
680             for (i = 0; i < arrlen; i++) {
681                 res[ctr] = 0x5F;
682                 ctr++;
683                 for (uint x = 0; x < elemArray[i].length; x++) {
684                     // if there's a bug with larger strings, this may be the culprit
685                     if (x % 23 == 0) {
686                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
687                         elemcborlen += 0x40;
688                         uint lctr = ctr;
689                         while (byte(elemcborlen).length > ctr - lctr) {
690                             res[ctr] = byte(elemcborlen)[ctr - lctr];
691                             ctr++;
692                         }
693                     }
694                     res[ctr] = elemArray[i][x];
695                     ctr++;
696                 }
697                 res[ctr] = 0xFF;
698                 ctr++;
699             }
700             return res;
701         }
702 
703     function ba2cbor(bytes[] arr) internal returns (bytes) {
704             uint arrlen = arr.length;
705 
706             // get correct cbor output length
707             uint outputlen = 0;
708             bytes[] memory elemArray = new bytes[](arrlen);
709             for (uint i = 0; i < arrlen; i++) {
710                 elemArray[i] = (bytes(arr[i]));
711                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
712             }
713             uint ctr = 0;
714             uint cborlen = arrlen + 0x80;
715             outputlen += byte(cborlen).length;
716             bytes memory res = new bytes(outputlen);
717 
718             while (byte(cborlen).length > ctr) {
719                 res[ctr] = byte(cborlen)[ctr];
720                 ctr++;
721             }
722             for (i = 0; i < arrlen; i++) {
723                 res[ctr] = 0x5F;
724                 ctr++;
725                 for (uint x = 0; x < elemArray[i].length; x++) {
726                     // if there's a bug with larger strings, this may be the culprit
727                     if (x % 23 == 0) {
728                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
729                         elemcborlen += 0x40;
730                         uint lctr = ctr;
731                         while (byte(elemcborlen).length > ctr - lctr) {
732                             res[ctr] = byte(elemcborlen)[ctr - lctr];
733                             ctr++;
734                         }
735                     }
736                     res[ctr] = elemArray[i][x];
737                     ctr++;
738                 }
739                 res[ctr] = 0xFF;
740                 ctr++;
741             }
742             return res;
743         }
744         
745         
746     string oraclize_network_name;
747     function oraclize_setNetworkName(string _network_name) internal {
748         oraclize_network_name = _network_name;
749     }
750     
751     function oraclize_getNetworkName() internal returns (string) {
752         return oraclize_network_name;
753     }
754     
755     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
756         if ((_nbytes == 0)||(_nbytes > 32)) throw;
757         bytes memory nbytes = new bytes(1);
758         nbytes[0] = byte(_nbytes);
759         bytes memory unonce = new bytes(32);
760         bytes memory sessionKeyHash = new bytes(32);
761         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
762         assembly {
763             mstore(unonce, 0x20)
764             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
765             mstore(sessionKeyHash, 0x20)
766             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
767         }
768         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
769         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
770         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
771         return queryId;
772     }
773     
774     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
775         oraclize_randomDS_args[queryId] = commitment;
776     }
777     
778     mapping(bytes32=>bytes32) oraclize_randomDS_args;
779     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
780 
781     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
782         bool sigok;
783         address signer;
784         
785         bytes32 sigr;
786         bytes32 sigs;
787         
788         bytes memory sigr_ = new bytes(32);
789         uint offset = 4+(uint(dersig[3]) - 0x20);
790         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
791         bytes memory sigs_ = new bytes(32);
792         offset += 32 + 2;
793         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
794 
795         assembly {
796             sigr := mload(add(sigr_, 32))
797             sigs := mload(add(sigs_, 32))
798         }
799         
800         
801         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
802         if (address(sha3(pubkey)) == signer) return true;
803         else {
804             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
805             return (address(sha3(pubkey)) == signer);
806         }
807     }
808 
809     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
810         bool sigok;
811         
812         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
813         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
814         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
815         
816         bytes memory appkey1_pubkey = new bytes(64);
817         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
818         
819         bytes memory tosign2 = new bytes(1+65+32);
820         tosign2[0] = 1; //role
821         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
822         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
823         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
824         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
825         
826         if (sigok == false) return false;
827         
828         
829         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
830         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
831         
832         bytes memory tosign3 = new bytes(1+65);
833         tosign3[0] = 0xFE;
834         copyBytes(proof, 3, 65, tosign3, 1);
835         
836         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
837         copyBytes(proof, 3+65, sig3.length, sig3, 0);
838         
839         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
840         
841         return sigok;
842     }
843     
844     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
845         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
846         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
847         
848         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
849         if (proofVerified == false) throw;
850         
851         _;
852     }
853     
854     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
855         bool match_ = true;
856         
857         for (var i=0; i<prefix.length; i++){
858             if (content[i] != prefix[i]) match_ = false;
859         }
860         
861         return match_;
862     }
863 
864     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
865         bool checkok;
866         
867         
868         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
869         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
870         bytes memory keyhash = new bytes(32);
871         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
872         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
873         if (checkok == false) return false;
874         
875         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
876         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
877         
878         
879         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
880         checkok = matchBytes32Prefix(sha256(sig1), result);
881         if (checkok == false) return false;
882         
883         
884         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
885         // This is to verify that the computed args match with the ones specified in the query.
886         bytes memory commitmentSlice1 = new bytes(8+1+32);
887         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
888         
889         bytes memory sessionPubkey = new bytes(64);
890         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
891         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
892         
893         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
894         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
895             delete oraclize_randomDS_args[queryId];
896         } else return false;
897         
898         
899         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
900         bytes memory tosign1 = new bytes(32+8+1+32);
901         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
902         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
903         if (checkok == false) return false;
904         
905         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
906         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
907             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
908         }
909         
910         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
911     }
912 
913     
914     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
915     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
916         uint minLength = length + toOffset;
917 
918         if (to.length < minLength) {
919             // Buffer too small
920             throw; // Should be a better way?
921         }
922 
923         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
924         uint i = 32 + fromOffset;
925         uint j = 32 + toOffset;
926 
927         while (i < (32 + fromOffset + length)) {
928             assembly {
929                 let tmp := mload(add(from, i))
930                 mstore(add(to, j), tmp)
931             }
932             i += 32;
933             j += 32;
934         }
935 
936         return to;
937     }
938     
939     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
940     // Duplicate Solidity's ecrecover, but catching the CALL return value
941     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
942         // We do our own memory management here. Solidity uses memory offset
943         // 0x40 to store the current end of memory. We write past it (as
944         // writes are memory extensions), but don't update the offset so
945         // Solidity will reuse it. The memory used here is only needed for
946         // this context.
947 
948         // FIXME: inline assembly can't access return values
949         bool ret;
950         address addr;
951 
952         assembly {
953             let size := mload(0x40)
954             mstore(size, hash)
955             mstore(add(size, 32), v)
956             mstore(add(size, 64), r)
957             mstore(add(size, 96), s)
958 
959             // NOTE: we can reuse the request memory because we deal with
960             //       the return code
961             ret := call(3000, 1, 0, size, 128, size, 32)
962             addr := mload(size)
963         }
964   
965         return (ret, addr);
966     }
967 
968     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
969     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
970         bytes32 r;
971         bytes32 s;
972         uint8 v;
973 
974         if (sig.length != 65)
975           return (false, 0);
976 
977         // The signature format is a compact form of:
978         //   {bytes32 r}{bytes32 s}{uint8 v}
979         // Compact means, uint8 is not padded to 32 bytes.
980         assembly {
981             r := mload(add(sig, 32))
982             s := mload(add(sig, 64))
983 
984             // Here we are loading the last 32 bytes. We exploit the fact that
985             // 'mload' will pad with zeroes if we overread.
986             // There is no 'mload8' to do this, but that would be nicer.
987             v := byte(0, mload(add(sig, 96)))
988 
989             // Alternative solution:
990             // 'byte' is not working due to the Solidity parser, so lets
991             // use the second best option, 'and'
992             // v := and(mload(add(sig, 65)), 255)
993         }
994 
995         // albeit non-transactional signatures are not specified by the YP, one would expect it
996         // to match the YP range of [27, 28]
997         //
998         // geth uses [0, 1] and some clients have followed. This might change, see:
999         //  https://github.com/ethereum/go-ethereum/issues/2053
1000         if (v < 27)
1001           v += 27;
1002 
1003         if (v != 27 && v != 28)
1004             return (false, 0);
1005 
1006         return safer_ecrecover(hash, v, r, s);
1007     }
1008         
1009 }
1010 // </ORACLIZE_API>
1011 
1012 library SafeMath {
1013   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
1014     uint256 c = a * b;
1015     assert(a == 0 || c / a == b);
1016     return c;
1017   }
1018 
1019   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
1020     assert(b <= a);
1021     return a - b;
1022   }
1023 
1024   function add(uint256 a, uint256 b) internal constant returns (uint256) {
1025     uint256 c = a + b;
1026     assert(c >= a);
1027     return c;
1028   }
1029 }
1030 
1031 contract Ownable {
1032   address public owner;
1033 
1034   function Ownable() {
1035     owner = msg.sender;
1036   }
1037 
1038   modifier onlyOwner() {
1039     require(msg.sender == owner);
1040     _;
1041   }
1042 }
1043 
1044 contract PariMutuel is Ownable, usingOraclize {
1045   using SafeMath for uint256;
1046 
1047   enum Outcome { Mayweather, McGregor }
1048   enum State { PreResolution, Resolved, Refunding }
1049 
1050   event BetPlaced(address indexed bettor, uint256 amount, Outcome outcome);
1051   event StateChanged(State _state);
1052   event CheckResultCalled(bytes32 queryId, address caller);
1053   event OraclizeCallback(bytes32 queryId, string result);
1054   event WinningOutcomeDeclared(Outcome outcome);
1055   event Withdrawal(address indexed bettor, uint256 amount);
1056 
1057   uint256 public constant fightStartTime = 1503795600; // August 26th 2017, 9PM EDT
1058   uint256 public constant percentRake = 1;
1059   uint256 public constant minBetAmount = 0.01 ether;
1060 
1061   Outcome public winningOutcome;
1062   State public state;
1063   bool public hasWithdrawnRake;
1064 
1065   mapping(uint8 => mapping(address => uint256)) public balancesForOutcome;
1066   mapping(uint8 => uint256) public totalWageredForOutcome;
1067   mapping(bytes32 => bool) validQueryIds;
1068   mapping(address => bool) refunded;
1069 
1070   function PariMutuel() {
1071     state = State.PreResolution;
1072   }
1073 
1074   modifier requireState(State _state) {
1075     require(state == _state);
1076     _;
1077   }
1078 
1079   function changeState(State _state) internal {
1080     state = _state;
1081     StateChanged(state);
1082   }
1083 
1084   function bet(Outcome outcome) external payable requireState(State.PreResolution) {
1085     require(now < fightStartTime);
1086     require(msg.value >= minBetAmount);
1087     balancesForOutcome[uint8(outcome)][msg.sender] = balancesForOutcome[uint8(outcome)][msg.sender].add(msg.value);
1088     totalWageredForOutcome[uint8(outcome)] = totalWageredForOutcome[uint8(outcome)].add(msg.value);
1089     BetPlaced(msg.sender, msg.value, outcome);
1090   }
1091 
1092   function totalWagered() public constant returns (uint256) {
1093     return totalWageredForOutcome[0].add(totalWageredForOutcome[1]);
1094   }
1095 
1096   function totalRake() public constant returns (uint256) {
1097     return totalWagered().mul(percentRake) / 100;
1098   }
1099 
1100   function totalPrizePool() public constant returns (uint256) {
1101     return totalWagered().sub(totalRake());
1102   }
1103 
1104   function payoutForWagerAndOutcome(uint256 wager, Outcome outcome) public constant returns (uint256) {
1105     return totalPrizePool().mul(wager) / totalWageredForOutcome[uint8(outcome)];
1106   }
1107 
1108   function checkResult() external payable requireState(State.PreResolution) {
1109     require(msg.value >= oraclize_getPrice("URL")); // 0.01 ether should be fine
1110     bytes32 queryId = oraclize_query("URL", "html(http://boxrec.com/en/boxer/352).xpath(//*[@id='2169292']//div[contains(@class, 'boutResult')]/text())");
1111     CheckResultCalled(queryId, msg.sender);
1112     validQueryIds[queryId] = true;
1113   }
1114 
1115   function __callback(bytes32 myid, string result) {
1116     require(msg.sender == oraclize_cbAddress());
1117     require(validQueryIds[myid]);
1118     OraclizeCallback(myid, result);
1119     delete validQueryIds[myid];
1120     if (strEqual(result, 'w')) {
1121       declareWinningOutcome(Outcome.Mayweather);
1122     } else if (strEqual(result, 'l')) {
1123       declareWinningOutcome(Outcome.McGregor);
1124     } else if (!strEqual(result, 's')) {
1125       // Anything but 's' (scheduled).
1126       // That leaves 'd' (draw) and 'n' (no contest)
1127       changeState(State.Refunding);
1128     }
1129   }
1130 
1131   function declareWinningOutcome(Outcome outcome) internal requireState(State.PreResolution) {
1132     changeState(State.Resolved);
1133     winningOutcome = outcome;
1134     WinningOutcomeDeclared(outcome);
1135   }
1136 
1137   function strEqual(string str1, string str2) internal returns (bool) {
1138     return sha3(str1) == sha3(str2);
1139   }
1140 
1141   // owner can call this if there's a bug in the contract
1142   function refundEverybody() external onlyOwner requireState(State.PreResolution) {
1143     changeState(State.Refunding);
1144   }
1145 
1146   function getRefunded() external requireState(State.Refunding) {
1147     require(!refunded[msg.sender]);
1148     refunded[msg.sender] = true;
1149     msg.sender.transfer(balancesForOutcome[0][msg.sender].add(balancesForOutcome[1][msg.sender]));
1150   }
1151 
1152   function withdrawRake() external onlyOwner requireState(State.Resolved) {
1153     require(!hasWithdrawnRake);
1154     hasWithdrawnRake = true;
1155     owner.transfer(totalRake());
1156   }
1157 
1158   function withdrawWinnings() external requireState(State.Resolved) {
1159     uint256 wager = balancesForOutcome[uint8(winningOutcome)][msg.sender];
1160     require(wager > 0);
1161     uint256 winnings = payoutForWagerAndOutcome(wager, winningOutcome);
1162     balancesForOutcome[uint8(winningOutcome)][msg.sender] = 0;
1163     msg.sender.transfer(winnings);
1164     Withdrawal(msg.sender, winnings);
1165   }
1166 }