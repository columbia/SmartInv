1 pragma solidity ^0.4.17;
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
32 contract OraclizeI {
33     address public cbAddress;
34     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
35     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
36     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
37     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
38     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
39     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
40     function getPrice(string _datasource) returns (uint _dsprice);
41     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
42     function useCoupon(string _coupon);
43     function setProofType(byte _proofType);
44     function setConfig(bytes32 _config);
45     function setCustomGasPrice(uint _gasPrice);
46     function randomDS_getSessionPubKeyHash() returns(bytes32);
47 }
48 contract OraclizeAddrResolverI {
49     function getAddress() returns (address _addr);
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
71         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
72         oraclize = OraclizeI(OAR.getAddress());
73         _;
74     }
75     modifier coupon(string code){
76         oraclize = OraclizeI(OAR.getAddress());
77         oraclize.useCoupon(code);
78         _;
79     }
80 
81     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
82         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
83             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
84             oraclize_setNetworkName("eth_mainnet");
85             return true;
86         }
87         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
88             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
89             oraclize_setNetworkName("eth_ropsten3");
90             return true;
91         }
92         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
93             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
94             oraclize_setNetworkName("eth_kovan");
95             return true;
96         }
97         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
98             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
99             oraclize_setNetworkName("eth_rinkeby");
100             return true;
101         }
102         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
103             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
104             return true;
105         }
106         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
107             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
108             return true;
109         }
110         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
111             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
112             return true;
113         }
114         return false;
115     }
116 
117     function __callback(bytes32 myid, string result) {
118         __callback(myid, result, new bytes(0));
119     }
120     function __callback(bytes32 myid, string result, bytes proof) {
121     }
122     
123     function oraclize_useCoupon(string code) oraclizeAPI internal {
124         oraclize.useCoupon(code);
125     }
126 
127     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
128         return oraclize.getPrice(datasource);
129     }
130 
131     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
132         return oraclize.getPrice(datasource, gaslimit);
133     }
134     
135     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
136         uint price = oraclize.getPrice(datasource);
137         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
138         return oraclize.query.value(price)(0, datasource, arg);
139     }
140     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
141         uint price = oraclize.getPrice(datasource);
142         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
143         return oraclize.query.value(price)(timestamp, datasource, arg);
144     }
145     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
146         uint price = oraclize.getPrice(datasource, gaslimit);
147         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
148         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
149     }
150     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
151         uint price = oraclize.getPrice(datasource, gaslimit);
152         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
153         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
154     }
155     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
156         uint price = oraclize.getPrice(datasource);
157         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
158         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
159     }
160     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
161         uint price = oraclize.getPrice(datasource);
162         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
163         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
164     }
165     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
166         uint price = oraclize.getPrice(datasource, gaslimit);
167         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
168         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
169     }
170     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
171         uint price = oraclize.getPrice(datasource, gaslimit);
172         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
173         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
174     }
175     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
176         uint price = oraclize.getPrice(datasource);
177         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
178         bytes memory args = stra2cbor(argN);
179         return oraclize.queryN.value(price)(0, datasource, args);
180     }
181     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
182         uint price = oraclize.getPrice(datasource);
183         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
184         bytes memory args = stra2cbor(argN);
185         return oraclize.queryN.value(price)(timestamp, datasource, args);
186     }
187     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
188         uint price = oraclize.getPrice(datasource, gaslimit);
189         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
190         bytes memory args = stra2cbor(argN);
191         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
192     }
193     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
194         uint price = oraclize.getPrice(datasource, gaslimit);
195         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
196         bytes memory args = stra2cbor(argN);
197         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
198     }
199     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
200         string[] memory dynargs = new string[](1);
201         dynargs[0] = args[0];
202         return oraclize_query(datasource, dynargs);
203     }
204     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
205         string[] memory dynargs = new string[](1);
206         dynargs[0] = args[0];
207         return oraclize_query(timestamp, datasource, dynargs);
208     }
209     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
210         string[] memory dynargs = new string[](1);
211         dynargs[0] = args[0];
212         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
213     }
214     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
215         string[] memory dynargs = new string[](1);
216         dynargs[0] = args[0];       
217         return oraclize_query(datasource, dynargs, gaslimit);
218     }
219     
220     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
221         string[] memory dynargs = new string[](2);
222         dynargs[0] = args[0];
223         dynargs[1] = args[1];
224         return oraclize_query(datasource, dynargs);
225     }
226     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
227         string[] memory dynargs = new string[](2);
228         dynargs[0] = args[0];
229         dynargs[1] = args[1];
230         return oraclize_query(timestamp, datasource, dynargs);
231     }
232     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
233         string[] memory dynargs = new string[](2);
234         dynargs[0] = args[0];
235         dynargs[1] = args[1];
236         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
237     }
238     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
239         string[] memory dynargs = new string[](2);
240         dynargs[0] = args[0];
241         dynargs[1] = args[1];
242         return oraclize_query(datasource, dynargs, gaslimit);
243     }
244     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
245         string[] memory dynargs = new string[](3);
246         dynargs[0] = args[0];
247         dynargs[1] = args[1];
248         dynargs[2] = args[2];
249         return oraclize_query(datasource, dynargs);
250     }
251     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
252         string[] memory dynargs = new string[](3);
253         dynargs[0] = args[0];
254         dynargs[1] = args[1];
255         dynargs[2] = args[2];
256         return oraclize_query(timestamp, datasource, dynargs);
257     }
258     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
259         string[] memory dynargs = new string[](3);
260         dynargs[0] = args[0];
261         dynargs[1] = args[1];
262         dynargs[2] = args[2];
263         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
264     }
265     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
266         string[] memory dynargs = new string[](3);
267         dynargs[0] = args[0];
268         dynargs[1] = args[1];
269         dynargs[2] = args[2];
270         return oraclize_query(datasource, dynargs, gaslimit);
271     }
272     
273     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
274         string[] memory dynargs = new string[](4);
275         dynargs[0] = args[0];
276         dynargs[1] = args[1];
277         dynargs[2] = args[2];
278         dynargs[3] = args[3];
279         return oraclize_query(datasource, dynargs);
280     }
281     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
282         string[] memory dynargs = new string[](4);
283         dynargs[0] = args[0];
284         dynargs[1] = args[1];
285         dynargs[2] = args[2];
286         dynargs[3] = args[3];
287         return oraclize_query(timestamp, datasource, dynargs);
288     }
289     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
290         string[] memory dynargs = new string[](4);
291         dynargs[0] = args[0];
292         dynargs[1] = args[1];
293         dynargs[2] = args[2];
294         dynargs[3] = args[3];
295         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
296     }
297     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
298         string[] memory dynargs = new string[](4);
299         dynargs[0] = args[0];
300         dynargs[1] = args[1];
301         dynargs[2] = args[2];
302         dynargs[3] = args[3];
303         return oraclize_query(datasource, dynargs, gaslimit);
304     }
305     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
306         string[] memory dynargs = new string[](5);
307         dynargs[0] = args[0];
308         dynargs[1] = args[1];
309         dynargs[2] = args[2];
310         dynargs[3] = args[3];
311         dynargs[4] = args[4];
312         return oraclize_query(datasource, dynargs);
313     }
314     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
315         string[] memory dynargs = new string[](5);
316         dynargs[0] = args[0];
317         dynargs[1] = args[1];
318         dynargs[2] = args[2];
319         dynargs[3] = args[3];
320         dynargs[4] = args[4];
321         return oraclize_query(timestamp, datasource, dynargs);
322     }
323     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
324         string[] memory dynargs = new string[](5);
325         dynargs[0] = args[0];
326         dynargs[1] = args[1];
327         dynargs[2] = args[2];
328         dynargs[3] = args[3];
329         dynargs[4] = args[4];
330         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
331     }
332     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
333         string[] memory dynargs = new string[](5);
334         dynargs[0] = args[0];
335         dynargs[1] = args[1];
336         dynargs[2] = args[2];
337         dynargs[3] = args[3];
338         dynargs[4] = args[4];
339         return oraclize_query(datasource, dynargs, gaslimit);
340     }
341     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
342         uint price = oraclize.getPrice(datasource);
343         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
344         bytes memory args = ba2cbor(argN);
345         return oraclize.queryN.value(price)(0, datasource, args);
346     }
347     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
348         uint price = oraclize.getPrice(datasource);
349         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
350         bytes memory args = ba2cbor(argN);
351         return oraclize.queryN.value(price)(timestamp, datasource, args);
352     }
353     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
354         uint price = oraclize.getPrice(datasource, gaslimit);
355         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
356         bytes memory args = ba2cbor(argN);
357         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
358     }
359     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
360         uint price = oraclize.getPrice(datasource, gaslimit);
361         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
362         bytes memory args = ba2cbor(argN);
363         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
364     }
365     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
366         bytes[] memory dynargs = new bytes[](1);
367         dynargs[0] = args[0];
368         return oraclize_query(datasource, dynargs);
369     }
370     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
371         bytes[] memory dynargs = new bytes[](1);
372         dynargs[0] = args[0];
373         return oraclize_query(timestamp, datasource, dynargs);
374     }
375     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
376         bytes[] memory dynargs = new bytes[](1);
377         dynargs[0] = args[0];
378         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
379     }
380     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
381         bytes[] memory dynargs = new bytes[](1);
382         dynargs[0] = args[0];       
383         return oraclize_query(datasource, dynargs, gaslimit);
384     }
385     
386     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
387         bytes[] memory dynargs = new bytes[](2);
388         dynargs[0] = args[0];
389         dynargs[1] = args[1];
390         return oraclize_query(datasource, dynargs);
391     }
392     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
393         bytes[] memory dynargs = new bytes[](2);
394         dynargs[0] = args[0];
395         dynargs[1] = args[1];
396         return oraclize_query(timestamp, datasource, dynargs);
397     }
398     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
399         bytes[] memory dynargs = new bytes[](2);
400         dynargs[0] = args[0];
401         dynargs[1] = args[1];
402         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
403     }
404     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
405         bytes[] memory dynargs = new bytes[](2);
406         dynargs[0] = args[0];
407         dynargs[1] = args[1];
408         return oraclize_query(datasource, dynargs, gaslimit);
409     }
410     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
411         bytes[] memory dynargs = new bytes[](3);
412         dynargs[0] = args[0];
413         dynargs[1] = args[1];
414         dynargs[2] = args[2];
415         return oraclize_query(datasource, dynargs);
416     }
417     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
418         bytes[] memory dynargs = new bytes[](3);
419         dynargs[0] = args[0];
420         dynargs[1] = args[1];
421         dynargs[2] = args[2];
422         return oraclize_query(timestamp, datasource, dynargs);
423     }
424     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
425         bytes[] memory dynargs = new bytes[](3);
426         dynargs[0] = args[0];
427         dynargs[1] = args[1];
428         dynargs[2] = args[2];
429         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
430     }
431     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
432         bytes[] memory dynargs = new bytes[](3);
433         dynargs[0] = args[0];
434         dynargs[1] = args[1];
435         dynargs[2] = args[2];
436         return oraclize_query(datasource, dynargs, gaslimit);
437     }
438     
439     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
440         bytes[] memory dynargs = new bytes[](4);
441         dynargs[0] = args[0];
442         dynargs[1] = args[1];
443         dynargs[2] = args[2];
444         dynargs[3] = args[3];
445         return oraclize_query(datasource, dynargs);
446     }
447     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
448         bytes[] memory dynargs = new bytes[](4);
449         dynargs[0] = args[0];
450         dynargs[1] = args[1];
451         dynargs[2] = args[2];
452         dynargs[3] = args[3];
453         return oraclize_query(timestamp, datasource, dynargs);
454     }
455     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
456         bytes[] memory dynargs = new bytes[](4);
457         dynargs[0] = args[0];
458         dynargs[1] = args[1];
459         dynargs[2] = args[2];
460         dynargs[3] = args[3];
461         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
462     }
463     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
464         bytes[] memory dynargs = new bytes[](4);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         dynargs[2] = args[2];
468         dynargs[3] = args[3];
469         return oraclize_query(datasource, dynargs, gaslimit);
470     }
471     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
472         bytes[] memory dynargs = new bytes[](5);
473         dynargs[0] = args[0];
474         dynargs[1] = args[1];
475         dynargs[2] = args[2];
476         dynargs[3] = args[3];
477         dynargs[4] = args[4];
478         return oraclize_query(datasource, dynargs);
479     }
480     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
481         bytes[] memory dynargs = new bytes[](5);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         dynargs[2] = args[2];
485         dynargs[3] = args[3];
486         dynargs[4] = args[4];
487         return oraclize_query(timestamp, datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
490         bytes[] memory dynargs = new bytes[](5);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         dynargs[2] = args[2];
494         dynargs[3] = args[3];
495         dynargs[4] = args[4];
496         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
497     }
498     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
499         bytes[] memory dynargs = new bytes[](5);
500         dynargs[0] = args[0];
501         dynargs[1] = args[1];
502         dynargs[2] = args[2];
503         dynargs[3] = args[3];
504         dynargs[4] = args[4];
505         return oraclize_query(datasource, dynargs, gaslimit);
506     }
507 
508     function oraclize_cbAddress() oraclizeAPI internal returns (address){
509         return oraclize.cbAddress();
510     }
511     function oraclize_setProof(byte proofP) oraclizeAPI internal {
512         return oraclize.setProofType(proofP);
513     }
514     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
515         return oraclize.setCustomGasPrice(gasPrice);
516     }
517     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
518         return oraclize.setConfig(config);
519     }
520     
521     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
522         return oraclize.randomDS_getSessionPubKeyHash();
523     }
524 
525     function getCodeSize(address _addr) constant internal returns(uint _size) {
526         assembly {
527             _size := extcodesize(_addr)
528         }
529     }
530 
531     function parseAddr(string _a) internal returns (address){
532         bytes memory tmp = bytes(_a);
533         uint160 iaddr = 0;
534         uint160 b1;
535         uint160 b2;
536         for (uint i=2; i<2+2*20; i+=2){
537             iaddr *= 256;
538             b1 = uint160(tmp[i]);
539             b2 = uint160(tmp[i+1]);
540             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
541             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
542             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
543             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
544             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
545             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
546             iaddr += (b1*16+b2);
547         }
548         return address(iaddr);
549     }
550 
551     function strCompare(string _a, string _b) internal returns (int) {
552         bytes memory a = bytes(_a);
553         bytes memory b = bytes(_b);
554         uint minLength = a.length;
555         if (b.length < minLength) minLength = b.length;
556         for (uint i = 0; i < minLength; i ++)
557             if (a[i] < b[i])
558                 return -1;
559             else if (a[i] > b[i])
560                 return 1;
561         if (a.length < b.length)
562             return -1;
563         else if (a.length > b.length)
564             return 1;
565         else
566             return 0;
567     }
568 
569     function indexOf(string _haystack, string _needle) internal returns (int) {
570         bytes memory h = bytes(_haystack);
571         bytes memory n = bytes(_needle);
572         if(h.length < 1 || n.length < 1 || (n.length > h.length))
573             return -1;
574         else if(h.length > (2**128 -1))
575             return -1;
576         else
577         {
578             uint subindex = 0;
579             for (uint i = 0; i < h.length; i ++)
580             {
581                 if (h[i] == n[0])
582                 {
583                     subindex = 1;
584                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
585                     {
586                         subindex++;
587                     }
588                     if(subindex == n.length)
589                         return int(i);
590                 }
591             }
592             return -1;
593         }
594     }
595 
596     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
597         bytes memory _ba = bytes(_a);
598         bytes memory _bb = bytes(_b);
599         bytes memory _bc = bytes(_c);
600         bytes memory _bd = bytes(_d);
601         bytes memory _be = bytes(_e);
602         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
603         bytes memory babcde = bytes(abcde);
604         uint k = 0;
605         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
606         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
607         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
608         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
609         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
610         return string(babcde);
611     }
612 
613     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
614         return strConcat(_a, _b, _c, _d, "");
615     }
616 
617     function strConcat(string _a, string _b, string _c) internal returns (string) {
618         return strConcat(_a, _b, _c, "", "");
619     }
620 
621     function strConcat(string _a, string _b) internal returns (string) {
622         return strConcat(_a, _b, "", "", "");
623     }
624 
625     // parseInt
626     function parseInt(string _a) internal returns (uint) {
627         return parseInt(_a, 0);
628     }
629 
630     // parseInt(parseFloat*10^_b)
631     function parseInt(string _a, uint _b) internal returns (uint) {
632         bytes memory bresult = bytes(_a);
633         uint mint = 0;
634         bool decimals = false;
635         for (uint i=0; i<bresult.length; i++){
636             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
637                 if (decimals){
638                    if (_b == 0) break;
639                     else _b--;
640                 }
641                 mint *= 10;
642                 mint += uint(bresult[i]) - 48;
643             } else if (bresult[i] == 46) decimals = true;
644         }
645         if (_b > 0) mint *= 10**_b;
646         return mint;
647     }
648 
649     function uint2str(uint i) internal returns (string){
650         if (i == 0) return "0";
651         uint j = i;
652         uint len;
653         while (j != 0){
654             len++;
655             j /= 10;
656         }
657         bytes memory bstr = new bytes(len);
658         uint k = len - 1;
659         while (i != 0){
660             bstr[k--] = byte(48 + i % 10);
661             i /= 10;
662         }
663         return string(bstr);
664     }
665     
666     function stra2cbor(string[] arr) internal returns (bytes) {
667             uint arrlen = arr.length;
668 
669             // get correct cbor output length
670             uint outputlen = 0;
671             bytes[] memory elemArray = new bytes[](arrlen);
672             for (uint i = 0; i < arrlen; i++) {
673                 elemArray[i] = (bytes(arr[i]));
674                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
675             }
676             uint ctr = 0;
677             uint cborlen = arrlen + 0x80;
678             outputlen += byte(cborlen).length;
679             bytes memory res = new bytes(outputlen);
680 
681             while (byte(cborlen).length > ctr) {
682                 res[ctr] = byte(cborlen)[ctr];
683                 ctr++;
684             }
685             for (i = 0; i < arrlen; i++) {
686                 res[ctr] = 0x5F;
687                 ctr++;
688                 for (uint x = 0; x < elemArray[i].length; x++) {
689                     // if there's a bug with larger strings, this may be the culprit
690                     if (x % 23 == 0) {
691                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
692                         elemcborlen += 0x40;
693                         uint lctr = ctr;
694                         while (byte(elemcborlen).length > ctr - lctr) {
695                             res[ctr] = byte(elemcborlen)[ctr - lctr];
696                             ctr++;
697                         }
698                     }
699                     res[ctr] = elemArray[i][x];
700                     ctr++;
701                 }
702                 res[ctr] = 0xFF;
703                 ctr++;
704             }
705             return res;
706         }
707 
708     function ba2cbor(bytes[] arr) internal returns (bytes) {
709             uint arrlen = arr.length;
710 
711             // get correct cbor output length
712             uint outputlen = 0;
713             bytes[] memory elemArray = new bytes[](arrlen);
714             for (uint i = 0; i < arrlen; i++) {
715                 elemArray[i] = (bytes(arr[i]));
716                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
717             }
718             uint ctr = 0;
719             uint cborlen = arrlen + 0x80;
720             outputlen += byte(cborlen).length;
721             bytes memory res = new bytes(outputlen);
722 
723             while (byte(cborlen).length > ctr) {
724                 res[ctr] = byte(cborlen)[ctr];
725                 ctr++;
726             }
727             for (i = 0; i < arrlen; i++) {
728                 res[ctr] = 0x5F;
729                 ctr++;
730                 for (uint x = 0; x < elemArray[i].length; x++) {
731                     // if there's a bug with larger strings, this may be the culprit
732                     if (x % 23 == 0) {
733                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
734                         elemcborlen += 0x40;
735                         uint lctr = ctr;
736                         while (byte(elemcborlen).length > ctr - lctr) {
737                             res[ctr] = byte(elemcborlen)[ctr - lctr];
738                             ctr++;
739                         }
740                     }
741                     res[ctr] = elemArray[i][x];
742                     ctr++;
743                 }
744                 res[ctr] = 0xFF;
745                 ctr++;
746             }
747             return res;
748         }
749         
750         
751     string oraclize_network_name;
752     function oraclize_setNetworkName(string _network_name) internal {
753         oraclize_network_name = _network_name;
754     }
755     
756     function oraclize_getNetworkName() internal returns (string) {
757         return oraclize_network_name;
758     }
759     
760     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
761         if ((_nbytes == 0)||(_nbytes > 32)) throw;
762         bytes memory nbytes = new bytes(1);
763         nbytes[0] = byte(_nbytes);
764         bytes memory unonce = new bytes(32);
765         bytes memory sessionKeyHash = new bytes(32);
766         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
767         assembly {
768             mstore(unonce, 0x20)
769             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
770             mstore(sessionKeyHash, 0x20)
771             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
772         }
773         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
774         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
775         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
776         return queryId;
777     }
778     
779     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
780         oraclize_randomDS_args[queryId] = commitment;
781     }
782     
783     mapping(bytes32=>bytes32) oraclize_randomDS_args;
784     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
785 
786     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
787         bool sigok;
788         address signer;
789         
790         bytes32 sigr;
791         bytes32 sigs;
792         
793         bytes memory sigr_ = new bytes(32);
794         uint offset = 4+(uint(dersig[3]) - 0x20);
795         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
796         bytes memory sigs_ = new bytes(32);
797         offset += 32 + 2;
798         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
799 
800         assembly {
801             sigr := mload(add(sigr_, 32))
802             sigs := mload(add(sigs_, 32))
803         }
804         
805         
806         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
807         if (address(sha3(pubkey)) == signer) return true;
808         else {
809             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
810             return (address(sha3(pubkey)) == signer);
811         }
812     }
813 
814     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
815         bool sigok;
816         
817         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
818         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
819         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
820         
821         bytes memory appkey1_pubkey = new bytes(64);
822         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
823         
824         bytes memory tosign2 = new bytes(1+65+32);
825         tosign2[0] = 1; //role
826         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
827         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
828         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
829         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
830         
831         if (sigok == false) return false;
832         
833         
834         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
835         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
836         
837         bytes memory tosign3 = new bytes(1+65);
838         tosign3[0] = 0xFE;
839         copyBytes(proof, 3, 65, tosign3, 1);
840         
841         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
842         copyBytes(proof, 3+65, sig3.length, sig3, 0);
843         
844         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
845         
846         return sigok;
847     }
848     
849     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
850         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
851         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
852         
853         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
854         if (proofVerified == false) throw;
855         
856         _;
857     }
858     
859     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
860         bool match_ = true;
861         
862         for (var i=0; i<prefix.length; i++){
863             if (content[i] != prefix[i]) match_ = false;
864         }
865         
866         return match_;
867     }
868 
869     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
870         bool checkok;
871         
872         
873         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
874         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
875         bytes memory keyhash = new bytes(32);
876         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
877         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
878         if (checkok == false) return false;
879         
880         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
881         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
882         
883         
884         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
885         checkok = matchBytes32Prefix(sha256(sig1), result);
886         if (checkok == false) return false;
887         
888         
889         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
890         // This is to verify that the computed args match with the ones specified in the query.
891         bytes memory commitmentSlice1 = new bytes(8+1+32);
892         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
893         
894         bytes memory sessionPubkey = new bytes(64);
895         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
896         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
897         
898         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
899         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
900             delete oraclize_randomDS_args[queryId];
901         } else return false;
902         
903         
904         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
905         bytes memory tosign1 = new bytes(32+8+1+32);
906         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
907         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
908         if (checkok == false) return false;
909         
910         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
911         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
912             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
913         }
914         
915         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
916     }
917 
918     
919     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
920     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
921         uint minLength = length + toOffset;
922 
923         if (to.length < minLength) {
924             // Buffer too small
925             throw; // Should be a better way?
926         }
927 
928         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
929         uint i = 32 + fromOffset;
930         uint j = 32 + toOffset;
931 
932         while (i < (32 + fromOffset + length)) {
933             assembly {
934                 let tmp := mload(add(from, i))
935                 mstore(add(to, j), tmp)
936             }
937             i += 32;
938             j += 32;
939         }
940 
941         return to;
942     }
943     
944     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
945     // Duplicate Solidity's ecrecover, but catching the CALL return value
946     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
947         // We do our own memory management here. Solidity uses memory offset
948         // 0x40 to store the current end of memory. We write past it (as
949         // writes are memory extensions), but don't update the offset so
950         // Solidity will reuse it. The memory used here is only needed for
951         // this context.
952 
953         // FIXME: inline assembly can't access return values
954         bool ret;
955         address addr;
956 
957         assembly {
958             let size := mload(0x40)
959             mstore(size, hash)
960             mstore(add(size, 32), v)
961             mstore(add(size, 64), r)
962             mstore(add(size, 96), s)
963 
964             // NOTE: we can reuse the request memory because we deal with
965             //       the return code
966             ret := call(3000, 1, 0, size, 128, size, 32)
967             addr := mload(size)
968         }
969   
970         return (ret, addr);
971     }
972 
973     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
974     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
975         bytes32 r;
976         bytes32 s;
977         uint8 v;
978 
979         if (sig.length != 65)
980           return (false, 0);
981 
982         // The signature format is a compact form of:
983         //   {bytes32 r}{bytes32 s}{uint8 v}
984         // Compact means, uint8 is not padded to 32 bytes.
985         assembly {
986             r := mload(add(sig, 32))
987             s := mload(add(sig, 64))
988 
989             // Here we are loading the last 32 bytes. We exploit the fact that
990             // 'mload' will pad with zeroes if we overread.
991             // There is no 'mload8' to do this, but that would be nicer.
992             v := byte(0, mload(add(sig, 96)))
993 
994             // Alternative solution:
995             // 'byte' is not working due to the Solidity parser, so lets
996             // use the second best option, 'and'
997             // v := and(mload(add(sig, 65)), 255)
998         }
999 
1000         // albeit non-transactional signatures are not specified by the YP, one would expect it
1001         // to match the YP range of [27, 28]
1002         //
1003         // geth uses [0, 1] and some clients have followed. This might change, see:
1004         //  https://github.com/ethereum/go-ethereum/issues/2053
1005         if (v < 27)
1006           v += 27;
1007 
1008         if (v != 27 && v != 28)
1009             return (false, 0);
1010 
1011         return safer_ecrecover(hash, v, r, s);
1012     }
1013         
1014 }
1015 // </ORACLIZE_API>
1016 
1017 
1018 
1019 contract Oracle is usingOraclize{
1020 
1021   /*Variables*/
1022 
1023   //Private queryId for Oraclize callback
1024   bytes32 private queryID;
1025 
1026   //Mapping of documents stored in the oracle
1027   mapping(uint => uint) public oracle_values;
1028   mapping(uint => bool) public queried;
1029 
1030   /*Events*/
1031   event DocumentStored(uint _key, uint _value);
1032   event newOraclizeQuery(string description);
1033 
1034   /*Functions*/
1035   function RetrieveData(uint _date) public constant returns (uint data) {
1036     uint value = oracle_values[_date];
1037     return value;
1038   }
1039 
1040  //CAlls 
1041   function PushData() public {
1042     uint _key = now - (now % 86400);
1043     require(queried[_key] == false);
1044     if (oraclize_getPrice("URL") > this.balance) {
1045             newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1046         } else {
1047             newOraclizeQuery("Oraclize queries sent");
1048             queryID = oraclize_query("URL", "json(https://api.gdax.com/products/BTC-USD/ticker).price");
1049             queried[_key] = true;
1050         }
1051   }
1052 
1053 
1054   function __callback(bytes32 _oraclizeID, string _result) {
1055       require(msg.sender == oraclize_cbAddress() && _oraclizeID == queryID);
1056       uint _value = parseInt(_result,3);
1057       uint _key = now - (now % 86400);
1058       oracle_values[_key] = _value;
1059       DocumentStored(_key, _value);
1060     }
1061 
1062 
1063   function fund() public payable {}
1064 
1065   function getQuery(uint _date) public view returns(bool _isValue){
1066     return queried[_date];
1067   }
1068 
1069 }