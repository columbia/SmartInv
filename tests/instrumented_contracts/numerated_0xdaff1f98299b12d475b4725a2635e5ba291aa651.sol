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
118     function __callback(bytes32 myid, string result) {
119         __callback(myid, result, new bytes(0));
120     }
121     function __callback(bytes32 myid, string result, bytes proof) {
122     }
123     
124     function oraclize_useCoupon(string code) oraclizeAPI internal {
125         oraclize.useCoupon(code);
126     }
127 
128     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
129         return oraclize.getPrice(datasource);
130     }
131 
132     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
133         return oraclize.getPrice(datasource, gaslimit);
134     }
135     
136     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
137         uint price = oraclize.getPrice(datasource);
138         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
139         return oraclize.query.value(price)(0, datasource, arg);
140     }
141     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
142         uint price = oraclize.getPrice(datasource);
143         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
144         return oraclize.query.value(price)(timestamp, datasource, arg);
145     }
146     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
147         uint price = oraclize.getPrice(datasource, gaslimit);
148         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
149         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
150     }
151     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
152         uint price = oraclize.getPrice(datasource, gaslimit);
153         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
154         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
155     }
156     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
157         uint price = oraclize.getPrice(datasource);
158         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
159         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
160     }
161     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
162         uint price = oraclize.getPrice(datasource);
163         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
164         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
165     }
166     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
167         uint price = oraclize.getPrice(datasource, gaslimit);
168         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
169         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
170     }
171     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
172         uint price = oraclize.getPrice(datasource, gaslimit);
173         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
174         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
175     }
176     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
177         uint price = oraclize.getPrice(datasource);
178         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
179         bytes memory args = stra2cbor(argN);
180         return oraclize.queryN.value(price)(0, datasource, args);
181     }
182     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
183         uint price = oraclize.getPrice(datasource);
184         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
185         bytes memory args = stra2cbor(argN);
186         return oraclize.queryN.value(price)(timestamp, datasource, args);
187     }
188     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
189         uint price = oraclize.getPrice(datasource, gaslimit);
190         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
191         bytes memory args = stra2cbor(argN);
192         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
193     }
194     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
195         uint price = oraclize.getPrice(datasource, gaslimit);
196         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
197         bytes memory args = stra2cbor(argN);
198         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
199     }
200     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
201         string[] memory dynargs = new string[](1);
202         dynargs[0] = args[0];
203         return oraclize_query(datasource, dynargs);
204     }
205     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
206         string[] memory dynargs = new string[](1);
207         dynargs[0] = args[0];
208         return oraclize_query(timestamp, datasource, dynargs);
209     }
210     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
211         string[] memory dynargs = new string[](1);
212         dynargs[0] = args[0];
213         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
214     }
215     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
216         string[] memory dynargs = new string[](1);
217         dynargs[0] = args[0];       
218         return oraclize_query(datasource, dynargs, gaslimit);
219     }
220     
221     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
222         string[] memory dynargs = new string[](2);
223         dynargs[0] = args[0];
224         dynargs[1] = args[1];
225         return oraclize_query(datasource, dynargs);
226     }
227     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
228         string[] memory dynargs = new string[](2);
229         dynargs[0] = args[0];
230         dynargs[1] = args[1];
231         return oraclize_query(timestamp, datasource, dynargs);
232     }
233     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
234         string[] memory dynargs = new string[](2);
235         dynargs[0] = args[0];
236         dynargs[1] = args[1];
237         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
238     }
239     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
240         string[] memory dynargs = new string[](2);
241         dynargs[0] = args[0];
242         dynargs[1] = args[1];
243         return oraclize_query(datasource, dynargs, gaslimit);
244     }
245     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
246         string[] memory dynargs = new string[](3);
247         dynargs[0] = args[0];
248         dynargs[1] = args[1];
249         dynargs[2] = args[2];
250         return oraclize_query(datasource, dynargs);
251     }
252     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
253         string[] memory dynargs = new string[](3);
254         dynargs[0] = args[0];
255         dynargs[1] = args[1];
256         dynargs[2] = args[2];
257         return oraclize_query(timestamp, datasource, dynargs);
258     }
259     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
260         string[] memory dynargs = new string[](3);
261         dynargs[0] = args[0];
262         dynargs[1] = args[1];
263         dynargs[2] = args[2];
264         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
265     }
266     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
267         string[] memory dynargs = new string[](3);
268         dynargs[0] = args[0];
269         dynargs[1] = args[1];
270         dynargs[2] = args[2];
271         return oraclize_query(datasource, dynargs, gaslimit);
272     }
273     
274     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
275         string[] memory dynargs = new string[](4);
276         dynargs[0] = args[0];
277         dynargs[1] = args[1];
278         dynargs[2] = args[2];
279         dynargs[3] = args[3];
280         return oraclize_query(datasource, dynargs);
281     }
282     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
283         string[] memory dynargs = new string[](4);
284         dynargs[0] = args[0];
285         dynargs[1] = args[1];
286         dynargs[2] = args[2];
287         dynargs[3] = args[3];
288         return oraclize_query(timestamp, datasource, dynargs);
289     }
290     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
291         string[] memory dynargs = new string[](4);
292         dynargs[0] = args[0];
293         dynargs[1] = args[1];
294         dynargs[2] = args[2];
295         dynargs[3] = args[3];
296         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
297     }
298     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
299         string[] memory dynargs = new string[](4);
300         dynargs[0] = args[0];
301         dynargs[1] = args[1];
302         dynargs[2] = args[2];
303         dynargs[3] = args[3];
304         return oraclize_query(datasource, dynargs, gaslimit);
305     }
306     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
307         string[] memory dynargs = new string[](5);
308         dynargs[0] = args[0];
309         dynargs[1] = args[1];
310         dynargs[2] = args[2];
311         dynargs[3] = args[3];
312         dynargs[4] = args[4];
313         return oraclize_query(datasource, dynargs);
314     }
315     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
316         string[] memory dynargs = new string[](5);
317         dynargs[0] = args[0];
318         dynargs[1] = args[1];
319         dynargs[2] = args[2];
320         dynargs[3] = args[3];
321         dynargs[4] = args[4];
322         return oraclize_query(timestamp, datasource, dynargs);
323     }
324     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
325         string[] memory dynargs = new string[](5);
326         dynargs[0] = args[0];
327         dynargs[1] = args[1];
328         dynargs[2] = args[2];
329         dynargs[3] = args[3];
330         dynargs[4] = args[4];
331         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
332     }
333     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
334         string[] memory dynargs = new string[](5);
335         dynargs[0] = args[0];
336         dynargs[1] = args[1];
337         dynargs[2] = args[2];
338         dynargs[3] = args[3];
339         dynargs[4] = args[4];
340         return oraclize_query(datasource, dynargs, gaslimit);
341     }
342     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
343         uint price = oraclize.getPrice(datasource);
344         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
345         bytes memory args = ba2cbor(argN);
346         return oraclize.queryN.value(price)(0, datasource, args);
347     }
348     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
349         uint price = oraclize.getPrice(datasource);
350         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
351         bytes memory args = ba2cbor(argN);
352         return oraclize.queryN.value(price)(timestamp, datasource, args);
353     }
354     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
355         uint price = oraclize.getPrice(datasource, gaslimit);
356         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
357         bytes memory args = ba2cbor(argN);
358         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
359     }
360     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
361         uint price = oraclize.getPrice(datasource, gaslimit);
362         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
363         bytes memory args = ba2cbor(argN);
364         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
365     }
366     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
367         bytes[] memory dynargs = new bytes[](1);
368         dynargs[0] = args[0];
369         return oraclize_query(datasource, dynargs);
370     }
371     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
372         bytes[] memory dynargs = new bytes[](1);
373         dynargs[0] = args[0];
374         return oraclize_query(timestamp, datasource, dynargs);
375     }
376     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
377         bytes[] memory dynargs = new bytes[](1);
378         dynargs[0] = args[0];
379         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
380     }
381     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
382         bytes[] memory dynargs = new bytes[](1);
383         dynargs[0] = args[0];       
384         return oraclize_query(datasource, dynargs, gaslimit);
385     }
386     
387     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
388         bytes[] memory dynargs = new bytes[](2);
389         dynargs[0] = args[0];
390         dynargs[1] = args[1];
391         return oraclize_query(datasource, dynargs);
392     }
393     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
394         bytes[] memory dynargs = new bytes[](2);
395         dynargs[0] = args[0];
396         dynargs[1] = args[1];
397         return oraclize_query(timestamp, datasource, dynargs);
398     }
399     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
400         bytes[] memory dynargs = new bytes[](2);
401         dynargs[0] = args[0];
402         dynargs[1] = args[1];
403         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
404     }
405     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
406         bytes[] memory dynargs = new bytes[](2);
407         dynargs[0] = args[0];
408         dynargs[1] = args[1];
409         return oraclize_query(datasource, dynargs, gaslimit);
410     }
411     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
412         bytes[] memory dynargs = new bytes[](3);
413         dynargs[0] = args[0];
414         dynargs[1] = args[1];
415         dynargs[2] = args[2];
416         return oraclize_query(datasource, dynargs);
417     }
418     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
419         bytes[] memory dynargs = new bytes[](3);
420         dynargs[0] = args[0];
421         dynargs[1] = args[1];
422         dynargs[2] = args[2];
423         return oraclize_query(timestamp, datasource, dynargs);
424     }
425     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
426         bytes[] memory dynargs = new bytes[](3);
427         dynargs[0] = args[0];
428         dynargs[1] = args[1];
429         dynargs[2] = args[2];
430         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
431     }
432     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
433         bytes[] memory dynargs = new bytes[](3);
434         dynargs[0] = args[0];
435         dynargs[1] = args[1];
436         dynargs[2] = args[2];
437         return oraclize_query(datasource, dynargs, gaslimit);
438     }
439     
440     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
441         bytes[] memory dynargs = new bytes[](4);
442         dynargs[0] = args[0];
443         dynargs[1] = args[1];
444         dynargs[2] = args[2];
445         dynargs[3] = args[3];
446         return oraclize_query(datasource, dynargs);
447     }
448     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
449         bytes[] memory dynargs = new bytes[](4);
450         dynargs[0] = args[0];
451         dynargs[1] = args[1];
452         dynargs[2] = args[2];
453         dynargs[3] = args[3];
454         return oraclize_query(timestamp, datasource, dynargs);
455     }
456     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
457         bytes[] memory dynargs = new bytes[](4);
458         dynargs[0] = args[0];
459         dynargs[1] = args[1];
460         dynargs[2] = args[2];
461         dynargs[3] = args[3];
462         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
463     }
464     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
465         bytes[] memory dynargs = new bytes[](4);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         dynargs[2] = args[2];
469         dynargs[3] = args[3];
470         return oraclize_query(datasource, dynargs, gaslimit);
471     }
472     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
473         bytes[] memory dynargs = new bytes[](5);
474         dynargs[0] = args[0];
475         dynargs[1] = args[1];
476         dynargs[2] = args[2];
477         dynargs[3] = args[3];
478         dynargs[4] = args[4];
479         return oraclize_query(datasource, dynargs);
480     }
481     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
482         bytes[] memory dynargs = new bytes[](5);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         dynargs[2] = args[2];
486         dynargs[3] = args[3];
487         dynargs[4] = args[4];
488         return oraclize_query(timestamp, datasource, dynargs);
489     }
490     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
491         bytes[] memory dynargs = new bytes[](5);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         dynargs[2] = args[2];
495         dynargs[3] = args[3];
496         dynargs[4] = args[4];
497         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
498     }
499     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
500         bytes[] memory dynargs = new bytes[](5);
501         dynargs[0] = args[0];
502         dynargs[1] = args[1];
503         dynargs[2] = args[2];
504         dynargs[3] = args[3];
505         dynargs[4] = args[4];
506         return oraclize_query(datasource, dynargs, gaslimit);
507     }
508 
509     function oraclize_cbAddress() oraclizeAPI internal returns (address){
510         return oraclize.cbAddress();
511     }
512     function oraclize_setProof(byte proofP) oraclizeAPI internal {
513         return oraclize.setProofType(proofP);
514     }
515     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
516         return oraclize.setCustomGasPrice(gasPrice);
517     }
518     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
519         return oraclize.setConfig(config);
520     }
521     
522     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
523         return oraclize.randomDS_getSessionPubKeyHash();
524     }
525 
526     function getCodeSize(address _addr) constant internal returns(uint _size) {
527         assembly {
528             _size := extcodesize(_addr)
529         }
530     }
531 
532     function parseAddr(string _a) internal returns (address){
533         bytes memory tmp = bytes(_a);
534         uint160 iaddr = 0;
535         uint160 b1;
536         uint160 b2;
537         for (uint i=2; i<2+2*20; i+=2){
538             iaddr *= 256;
539             b1 = uint160(tmp[i]);
540             b2 = uint160(tmp[i+1]);
541             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
542             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
543             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
544             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
545             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
546             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
547             iaddr += (b1*16+b2);
548         }
549         return address(iaddr);
550     }
551 
552     function strCompare(string _a, string _b) internal returns (int) {
553         bytes memory a = bytes(_a);
554         bytes memory b = bytes(_b);
555         uint minLength = a.length;
556         if (b.length < minLength) minLength = b.length;
557         for (uint i = 0; i < minLength; i ++)
558             if (a[i] < b[i])
559                 return -1;
560             else if (a[i] > b[i])
561                 return 1;
562         if (a.length < b.length)
563             return -1;
564         else if (a.length > b.length)
565             return 1;
566         else
567             return 0;
568     }
569 
570     function indexOf(string _haystack, string _needle) internal returns (int) {
571         bytes memory h = bytes(_haystack);
572         bytes memory n = bytes(_needle);
573         if(h.length < 1 || n.length < 1 || (n.length > h.length))
574             return -1;
575         else if(h.length > (2**128 -1))
576             return -1;
577         else
578         {
579             uint subindex = 0;
580             for (uint i = 0; i < h.length; i ++)
581             {
582                 if (h[i] == n[0])
583                 {
584                     subindex = 1;
585                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
586                     {
587                         subindex++;
588                     }
589                     if(subindex == n.length)
590                         return int(i);
591                 }
592             }
593             return -1;
594         }
595     }
596 
597     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
598         bytes memory _ba = bytes(_a);
599         bytes memory _bb = bytes(_b);
600         bytes memory _bc = bytes(_c);
601         bytes memory _bd = bytes(_d);
602         bytes memory _be = bytes(_e);
603         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
604         bytes memory babcde = bytes(abcde);
605         uint k = 0;
606         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
607         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
608         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
609         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
610         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
611         return string(babcde);
612     }
613 
614     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
615         return strConcat(_a, _b, _c, _d, "");
616     }
617 
618     function strConcat(string _a, string _b, string _c) internal returns (string) {
619         return strConcat(_a, _b, _c, "", "");
620     }
621 
622     function strConcat(string _a, string _b) internal returns (string) {
623         return strConcat(_a, _b, "", "", "");
624     }
625 
626     // parseInt
627     function parseInt(string _a) internal returns (uint) {
628         return parseInt(_a, 0);
629     }
630 
631     // parseInt(parseFloat*10^_b)
632     function parseInt(string _a, uint _b) internal returns (uint) {
633         bytes memory bresult = bytes(_a);
634         uint mint = 0;
635         bool decimals = false;
636         for (uint i=0; i<bresult.length; i++){
637             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
638                 if (decimals){
639                    if (_b == 0) break;
640                     else _b--;
641                 }
642                 mint *= 10;
643                 mint += uint(bresult[i]) - 48;
644             } else if (bresult[i] == 46) decimals = true;
645         }
646         if (_b > 0) mint *= 10**_b;
647         return mint;
648     }
649 
650     function uint2str(uint i) internal returns (string){
651         if (i == 0) return "0";
652         uint j = i;
653         uint len;
654         while (j != 0){
655             len++;
656             j /= 10;
657         }
658         bytes memory bstr = new bytes(len);
659         uint k = len - 1;
660         while (i != 0){
661             bstr[k--] = byte(48 + i % 10);
662             i /= 10;
663         }
664         return string(bstr);
665     }
666     
667     function stra2cbor(string[] arr) internal returns (bytes) {
668             uint arrlen = arr.length;
669 
670             // get correct cbor output length
671             uint outputlen = 0;
672             bytes[] memory elemArray = new bytes[](arrlen);
673             for (uint i = 0; i < arrlen; i++) {
674                 elemArray[i] = (bytes(arr[i]));
675                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
676             }
677             uint ctr = 0;
678             uint cborlen = arrlen + 0x80;
679             outputlen += byte(cborlen).length;
680             bytes memory res = new bytes(outputlen);
681 
682             while (byte(cborlen).length > ctr) {
683                 res[ctr] = byte(cborlen)[ctr];
684                 ctr++;
685             }
686             for (i = 0; i < arrlen; i++) {
687                 res[ctr] = 0x5F;
688                 ctr++;
689                 for (uint x = 0; x < elemArray[i].length; x++) {
690                     // if there's a bug with larger strings, this may be the culprit
691                     if (x % 23 == 0) {
692                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
693                         elemcborlen += 0x40;
694                         uint lctr = ctr;
695                         while (byte(elemcborlen).length > ctr - lctr) {
696                             res[ctr] = byte(elemcborlen)[ctr - lctr];
697                             ctr++;
698                         }
699                     }
700                     res[ctr] = elemArray[i][x];
701                     ctr++;
702                 }
703                 res[ctr] = 0xFF;
704                 ctr++;
705             }
706             return res;
707         }
708 
709     function ba2cbor(bytes[] arr) internal returns (bytes) {
710             uint arrlen = arr.length;
711 
712             // get correct cbor output length
713             uint outputlen = 0;
714             bytes[] memory elemArray = new bytes[](arrlen);
715             for (uint i = 0; i < arrlen; i++) {
716                 elemArray[i] = (bytes(arr[i]));
717                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
718             }
719             uint ctr = 0;
720             uint cborlen = arrlen + 0x80;
721             outputlen += byte(cborlen).length;
722             bytes memory res = new bytes(outputlen);
723 
724             while (byte(cborlen).length > ctr) {
725                 res[ctr] = byte(cborlen)[ctr];
726                 ctr++;
727             }
728             for (i = 0; i < arrlen; i++) {
729                 res[ctr] = 0x5F;
730                 ctr++;
731                 for (uint x = 0; x < elemArray[i].length; x++) {
732                     // if there's a bug with larger strings, this may be the culprit
733                     if (x % 23 == 0) {
734                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
735                         elemcborlen += 0x40;
736                         uint lctr = ctr;
737                         while (byte(elemcborlen).length > ctr - lctr) {
738                             res[ctr] = byte(elemcborlen)[ctr - lctr];
739                             ctr++;
740                         }
741                     }
742                     res[ctr] = elemArray[i][x];
743                     ctr++;
744                 }
745                 res[ctr] = 0xFF;
746                 ctr++;
747             }
748             return res;
749         }
750         
751         
752     string oraclize_network_name;
753     function oraclize_setNetworkName(string _network_name) internal {
754         oraclize_network_name = _network_name;
755     }
756     
757     function oraclize_getNetworkName() internal returns (string) {
758         return oraclize_network_name;
759     }
760     
761     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
762         if ((_nbytes == 0)||(_nbytes > 32)) throw;
763         bytes memory nbytes = new bytes(1);
764         nbytes[0] = byte(_nbytes);
765         bytes memory unonce = new bytes(32);
766         bytes memory sessionKeyHash = new bytes(32);
767         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
768         assembly {
769             mstore(unonce, 0x20)
770             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
771             mstore(sessionKeyHash, 0x20)
772             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
773         }
774         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
775         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
776         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
777         return queryId;
778     }
779     
780     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
781         oraclize_randomDS_args[queryId] = commitment;
782     }
783     
784     mapping(bytes32=>bytes32) oraclize_randomDS_args;
785     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
786 
787     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
788         bool sigok;
789         address signer;
790         
791         bytes32 sigr;
792         bytes32 sigs;
793         
794         bytes memory sigr_ = new bytes(32);
795         uint offset = 4+(uint(dersig[3]) - 0x20);
796         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
797         bytes memory sigs_ = new bytes(32);
798         offset += 32 + 2;
799         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
800 
801         assembly {
802             sigr := mload(add(sigr_, 32))
803             sigs := mload(add(sigs_, 32))
804         }
805         
806         
807         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
808         if (address(sha3(pubkey)) == signer) return true;
809         else {
810             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
811             return (address(sha3(pubkey)) == signer);
812         }
813     }
814 
815     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
816         bool sigok;
817         
818         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
819         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
820         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
821         
822         bytes memory appkey1_pubkey = new bytes(64);
823         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
824         
825         bytes memory tosign2 = new bytes(1+65+32);
826         tosign2[0] = 1; //role
827         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
828         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
829         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
830         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
831         
832         if (sigok == false) return false;
833         
834         
835         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
836         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
837         
838         bytes memory tosign3 = new bytes(1+65);
839         tosign3[0] = 0xFE;
840         copyBytes(proof, 3, 65, tosign3, 1);
841         
842         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
843         copyBytes(proof, 3+65, sig3.length, sig3, 0);
844         
845         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
846         
847         return sigok;
848     }
849     
850     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
851         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
852         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
853         
854         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
855         if (proofVerified == false) throw;
856         
857         _;
858     }
859     
860     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
861         bool match_ = true;
862         
863         for (var i=0; i<prefix.length; i++){
864             if (content[i] != prefix[i]) match_ = false;
865         }
866         
867         return match_;
868     }
869 
870     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
871         bool checkok;
872         
873         
874         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
875         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
876         bytes memory keyhash = new bytes(32);
877         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
878         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
879         if (checkok == false) return false;
880         
881         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
882         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
883         
884         
885         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
886         checkok = matchBytes32Prefix(sha256(sig1), result);
887         if (checkok == false) return false;
888         
889         
890         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
891         // This is to verify that the computed args match with the ones specified in the query.
892         bytes memory commitmentSlice1 = new bytes(8+1+32);
893         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
894         
895         bytes memory sessionPubkey = new bytes(64);
896         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
897         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
898         
899         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
900         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
901             delete oraclize_randomDS_args[queryId];
902         } else return false;
903         
904         
905         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
906         bytes memory tosign1 = new bytes(32+8+1+32);
907         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
908         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
909         if (checkok == false) return false;
910         
911         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
912         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
913             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
914         }
915         
916         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
917     }
918 
919     
920     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
921     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
922         uint minLength = length + toOffset;
923 
924         if (to.length < minLength) {
925             // Buffer too small
926             throw; // Should be a better way?
927         }
928 
929         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
930         uint i = 32 + fromOffset;
931         uint j = 32 + toOffset;
932 
933         while (i < (32 + fromOffset + length)) {
934             assembly {
935                 let tmp := mload(add(from, i))
936                 mstore(add(to, j), tmp)
937             }
938             i += 32;
939             j += 32;
940         }
941 
942         return to;
943     }
944     
945     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
946     // Duplicate Solidity's ecrecover, but catching the CALL return value
947     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
948         // We do our own memory management here. Solidity uses memory offset
949         // 0x40 to store the current end of memory. We write past it (as
950         // writes are memory extensions), but don't update the offset so
951         // Solidity will reuse it. The memory used here is only needed for
952         // this context.
953 
954         // FIXME: inline assembly can't access return values
955         bool ret;
956         address addr;
957 
958         assembly {
959             let size := mload(0x40)
960             mstore(size, hash)
961             mstore(add(size, 32), v)
962             mstore(add(size, 64), r)
963             mstore(add(size, 96), s)
964 
965             // NOTE: we can reuse the request memory because we deal with
966             //       the return code
967             ret := call(3000, 1, 0, size, 128, size, 32)
968             addr := mload(size)
969         }
970   
971         return (ret, addr);
972     }
973 
974     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
975     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
976         bytes32 r;
977         bytes32 s;
978         uint8 v;
979 
980         if (sig.length != 65)
981           return (false, 0);
982 
983         // The signature format is a compact form of:
984         //   {bytes32 r}{bytes32 s}{uint8 v}
985         // Compact means, uint8 is not padded to 32 bytes.
986         assembly {
987             r := mload(add(sig, 32))
988             s := mload(add(sig, 64))
989 
990             // Here we are loading the last 32 bytes. We exploit the fact that
991             // 'mload' will pad with zeroes if we overread.
992             // There is no 'mload8' to do this, but that would be nicer.
993             v := byte(0, mload(add(sig, 96)))
994 
995             // Alternative solution:
996             // 'byte' is not working due to the Solidity parser, so lets
997             // use the second best option, 'and'
998             // v := and(mload(add(sig, 65)), 255)
999         }
1000 
1001         // albeit non-transactional signatures are not specified by the YP, one would expect it
1002         // to match the YP range of [27, 28]
1003         //
1004         // geth uses [0, 1] and some clients have followed. This might change, see:
1005         //  https://github.com/ethereum/go-ethereum/issues/2053
1006         if (v < 27)
1007           v += 27;
1008 
1009         if (v != 27 && v != 28)
1010             return (false, 0);
1011 
1012         return safer_ecrecover(hash, v, r, s);
1013     }
1014         
1015 }
1016 // </ORACLIZE_API>
1017 
1018 /*
1019  * Copyright 2017 Cillionaire /u/cillionaire (0x3baadba0da3f22e5b86581d686a2bde9a54aa0b4)
1020  * Copyright of oraclizeAPI.sol is held by Oraclize Ltd. - We use the API and code from the example here: 
1021  *   https://github.com/oraclize/ethereum-examples/tree/master/solidity/random-datasource
1022  */
1023  
1024 pragma solidity 0.4.16;
1025 
1026 contract owned {
1027     
1028     address public owner;
1029     
1030     event ContractOwnershipTransferred(address newOwner);
1031     
1032     function owned() { owner = msg.sender; }
1033     
1034     modifier onlyOwner { 
1035         require(msg.sender == owner); 
1036         _; 
1037     }
1038     
1039     function setContractOwner(address newOwner) external onlyOwner  {
1040         owner = newOwner;
1041         ContractOwnershipTransferred(newOwner);
1042     }
1043 }
1044  
1045 contract Cillionaire is owned, usingOraclize {
1046 
1047     enum State { ENDED, DONATE }
1048     uint public constant maxFeePercentage = 10;
1049     uint public constant retainBalance = 0.01 ether;
1050     
1051     // state vars for current round
1052     address public beneficiary;
1053     address[] public donors;
1054     State public state;
1055     uint public startTimestamp;
1056     uint public endTimestamp;
1057     uint public maxDonors;
1058     uint public duration;
1059     uint public donation;
1060     uint public fee;
1061     uint public donationSum;
1062     
1063     // parameter vars that can be set by owner
1064     uint public nextRoundMaxDonors;
1065     uint public nextRoundDuration;
1066     uint public nextRoundDonation;
1067     uint public nextRoundFee;
1068     uint public oraclizeCallbackGas;
1069 
1070     event NewRoundStarted(address _beneficiary, uint _startTimestamp, uint _endTimestamp, uint _maxDonors, uint _duration, uint _donation, uint _fee);
1071     event NewDonor(address _donor, uint _donationAfterFee, uint _fee);
1072     event RoundEnded(address _beneficiary, uint _donationSum);
1073     event RandomNumber(uint _randomNumber);
1074 
1075     modifier onlyState(State _state) { 
1076         require(state == _state); 
1077         _; 
1078     }
1079     
1080     modifier onlyOraclize() {
1081         require(msg.sender == oraclize_cbAddress());
1082         _;
1083     }
1084 
1085     function Cillionaire() {
1086         oraclize_setProof(proofType_Ledger);
1087         state = State.ENDED;
1088         oraclizeCallbackGas = 400000;
1089         nextRoundMaxDonors = 1000;
1090     	nextRoundDuration = 1800; // seconds
1091     	nextRoundDonation = 0.01 ether;
1092     	nextRoundFee = 0.001 ether;
1093     	startRound(owner);
1094     }
1095 
1096     function startRound(address _beneficiary) internal onlyState(State.ENDED) {
1097     	delete donors;
1098     	donationSum = 0;
1099     	beneficiary = _beneficiary;
1100     	maxDonors = nextRoundMaxDonors;
1101     	duration = nextRoundDuration;
1102     	donation = nextRoundDonation;
1103     	fee = nextRoundFee;
1104     	startTimestamp = block.timestamp;
1105     	endTimestamp = startTimestamp + duration;
1106     	state = State.DONATE;
1107     	NewRoundStarted(beneficiary, startTimestamp, endTimestamp, maxDonors, duration, donation, fee);
1108     }
1109 
1110     function donate() external payable onlyState(State.DONATE) {
1111     	require(msg.value == donation);
1112     	uint amountAfterFee = msg.value - fee;
1113     	donationSum += amountAfterFee;
1114     	donors.push(msg.sender);
1115     	NewDonor(msg.sender, amountAfterFee, fee);
1116     	if ((block.timestamp >= endTimestamp) || (donors.length >= maxDonors)) {
1117     	    state = State.ENDED;
1118     	    RoundEnded(beneficiary, donationSum);
1119             bytes32 queryId = oraclize_newRandomDSQuery(0, 7, oraclizeCallbackGas);
1120     	}
1121     	beneficiary.transfer(amountAfterFee);
1122     }
1123     
1124     function __callback(bytes32 _queryId, string _result, bytes _proof) onlyOraclize onlyState(State.ENDED) oraclize_randomDS_proofVerify(_queryId, _result, _proof) {
1125         uint randomNumber = uint(sha3(_result)); // https://gitter.im/oraclize/ethereum-api?at=595b98d7329651f46e5105b7
1126         RandomNumber(randomNumber);
1127         address nextBeneficiary = donors[randomNumber % donors.length];
1128         startRound(nextBeneficiary);
1129     }
1130     
1131     // Owner functions and setters for parameter vars
1132     
1133     // Fail-safe in case callback doesn't work the first time. In this case the owner can trigger random number generation again, thereby starting the next round.
1134     function startNextRound() external payable onlyOwner onlyState(State.ENDED) {
1135         bytes32 queryId = oraclize_newRandomDSQuery(0, 7, oraclizeCallbackGas);
1136     }
1137     
1138     function deposit() external payable onlyOwner {
1139         // allow to deposit ehter in case we run out of money for the Oraclize calls.
1140     }
1141     
1142     function withdraw() external onlyOwner {
1143         require(this.balance > retainBalance);
1144         uint amount = this.balance - retainBalance; // leave enough ether for Oraclize
1145         owner.transfer(amount);
1146     }
1147     
1148     function setNextRoundMaxDonors(uint _nextRoundMaxDonors) external onlyOwner {
1149         nextRoundMaxDonors = _nextRoundMaxDonors;
1150     }
1151 
1152     function setNextRoundDuration(uint _nextRoundDuration) external onlyOwner {
1153     	nextRoundDuration = _nextRoundDuration;
1154     }
1155 
1156     function setNextRoundDonation(uint _nextRoundDonation) external onlyOwner {
1157         nextRoundDonation = _nextRoundDonation;
1158         if (nextRoundFee > nextRoundDonation / maxFeePercentage) {
1159             nextRoundFee = nextRoundDonation / maxFeePercentage;
1160         }
1161     }
1162 
1163     function setNextRoundFee(uint _nextRoundFee) external onlyOwner {
1164         require(_nextRoundFee <= nextRoundDonation / maxFeePercentage);
1165         nextRoundFee = _nextRoundFee;
1166     }
1167 
1168     function setOraclizeCallbackGas(uint _oraclizeCallbackGas) external onlyOwner {
1169         require(_oraclizeCallbackGas > 200000); // prevent owner from starving Oraclize
1170         oraclizeCallbackGas = _oraclizeCallbackGas;
1171     }
1172 
1173 }