1 /*
2    Kraken-based ETH/XBT price ticker
3 
4    This contract keeps in storage an updated ETH/XBT price,
5    which is updated every ~60 seconds.
6 */
7 
8 // <ORACLIZE_API>
9 /*
10 Copyright (c) 2015-2016 Oraclize SRL
11 Copyright (c) 2016 Oraclize LTD
12 
13 
14 
15 Permission is hereby granted, free of charge, to any person obtaining a copy
16 of this software and associated documentation files (the "Software"), to deal
17 in the Software without restriction, including without limitation the rights
18 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
19 copies of the Software, and to permit persons to whom the Software is
20 furnished to do so, subject to the following conditions:
21 
22 
23 
24 The above copyright notice and this permission notice shall be included in
25 all copies or substantial portions of the Software.
26 
27 
28 
29 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
30 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
31 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
32 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
33 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
34 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
35 THE SOFTWARE.
36 */
37 
38 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
39 
40 contract OraclizeI {
41     address public cbAddress;
42     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
43     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
44     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
45     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
46     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
47     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
48     function getPrice(string _datasource) returns (uint _dsprice);
49     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
50     function useCoupon(string _coupon);
51     function setProofType(byte _proofType);
52     function setConfig(bytes32 _config);
53     function setCustomGasPrice(uint _gasPrice);
54     function randomDS_getSessionPubKeyHash() returns(bytes32);
55 }
56 contract OraclizeAddrResolverI {
57     function getAddress() returns (address _addr);
58 }
59 contract usingOraclize {
60     uint constant day = 60*60*24;
61     uint constant week = 60*60*24*7;
62     uint constant month = 60*60*24*30;
63     byte constant proofType_NONE = 0x00;
64     byte constant proofType_TLSNotary = 0x10;
65     byte constant proofType_Android = 0x20;
66     byte constant proofType_Ledger = 0x30;
67     byte constant proofType_Native = 0xF0;
68     byte constant proofStorage_IPFS = 0x01;
69     uint8 constant networkID_auto = 0;
70     uint8 constant networkID_mainnet = 1;
71     uint8 constant networkID_testnet = 2;
72     uint8 constant networkID_morden = 2;
73     uint8 constant networkID_consensys = 161;
74 
75     OraclizeAddrResolverI OAR;
76 
77     OraclizeI oraclize;
78     modifier oraclizeAPI {
79         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
80         oraclize = OraclizeI(OAR.getAddress());
81         _;
82     }
83     modifier coupon(string code){
84         oraclize = OraclizeI(OAR.getAddress());
85         oraclize.useCoupon(code);
86         _;
87     }
88 
89     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
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
129     }
130     
131     function oraclize_useCoupon(string code) oraclizeAPI internal {
132         oraclize.useCoupon(code);
133     }
134 
135     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
136         return oraclize.getPrice(datasource);
137     }
138 
139     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
140         return oraclize.getPrice(datasource, gaslimit);
141     }
142     
143     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
144         uint price = oraclize.getPrice(datasource);
145         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
146         return oraclize.query.value(price)(0, datasource, arg);
147     }
148     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource);
150         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
151         return oraclize.query.value(price)(timestamp, datasource, arg);
152     }
153     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
154         uint price = oraclize.getPrice(datasource, gaslimit);
155         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
156         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
157     }
158     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
159         uint price = oraclize.getPrice(datasource, gaslimit);
160         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
161         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
162     }
163     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
164         uint price = oraclize.getPrice(datasource);
165         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
166         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
167     }
168     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
169         uint price = oraclize.getPrice(datasource);
170         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
171         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
172     }
173     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
174         uint price = oraclize.getPrice(datasource, gaslimit);
175         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
176         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
177     }
178     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
179         uint price = oraclize.getPrice(datasource, gaslimit);
180         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
181         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
182     }
183     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
184         uint price = oraclize.getPrice(datasource);
185         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
186         bytes memory args = stra2cbor(argN);
187         return oraclize.queryN.value(price)(0, datasource, args);
188     }
189     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
190         uint price = oraclize.getPrice(datasource);
191         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
192         bytes memory args = stra2cbor(argN);
193         return oraclize.queryN.value(price)(timestamp, datasource, args);
194     }
195     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
196         uint price = oraclize.getPrice(datasource, gaslimit);
197         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
198         bytes memory args = stra2cbor(argN);
199         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
200     }
201     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
202         uint price = oraclize.getPrice(datasource, gaslimit);
203         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
204         bytes memory args = stra2cbor(argN);
205         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
206     }
207     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
208         string[] memory dynargs = new string[](1);
209         dynargs[0] = args[0];
210         return oraclize_query(datasource, dynargs);
211     }
212     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
213         string[] memory dynargs = new string[](1);
214         dynargs[0] = args[0];
215         return oraclize_query(timestamp, datasource, dynargs);
216     }
217     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
218         string[] memory dynargs = new string[](1);
219         dynargs[0] = args[0];
220         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
221     }
222     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
223         string[] memory dynargs = new string[](1);
224         dynargs[0] = args[0];       
225         return oraclize_query(datasource, dynargs, gaslimit);
226     }
227     
228     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
229         string[] memory dynargs = new string[](2);
230         dynargs[0] = args[0];
231         dynargs[1] = args[1];
232         return oraclize_query(datasource, dynargs);
233     }
234     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
235         string[] memory dynargs = new string[](2);
236         dynargs[0] = args[0];
237         dynargs[1] = args[1];
238         return oraclize_query(timestamp, datasource, dynargs);
239     }
240     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
241         string[] memory dynargs = new string[](2);
242         dynargs[0] = args[0];
243         dynargs[1] = args[1];
244         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
245     }
246     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
247         string[] memory dynargs = new string[](2);
248         dynargs[0] = args[0];
249         dynargs[1] = args[1];
250         return oraclize_query(datasource, dynargs, gaslimit);
251     }
252     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
253         string[] memory dynargs = new string[](3);
254         dynargs[0] = args[0];
255         dynargs[1] = args[1];
256         dynargs[2] = args[2];
257         return oraclize_query(datasource, dynargs);
258     }
259     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
260         string[] memory dynargs = new string[](3);
261         dynargs[0] = args[0];
262         dynargs[1] = args[1];
263         dynargs[2] = args[2];
264         return oraclize_query(timestamp, datasource, dynargs);
265     }
266     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
267         string[] memory dynargs = new string[](3);
268         dynargs[0] = args[0];
269         dynargs[1] = args[1];
270         dynargs[2] = args[2];
271         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
272     }
273     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
274         string[] memory dynargs = new string[](3);
275         dynargs[0] = args[0];
276         dynargs[1] = args[1];
277         dynargs[2] = args[2];
278         return oraclize_query(datasource, dynargs, gaslimit);
279     }
280     
281     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
282         string[] memory dynargs = new string[](4);
283         dynargs[0] = args[0];
284         dynargs[1] = args[1];
285         dynargs[2] = args[2];
286         dynargs[3] = args[3];
287         return oraclize_query(datasource, dynargs);
288     }
289     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
290         string[] memory dynargs = new string[](4);
291         dynargs[0] = args[0];
292         dynargs[1] = args[1];
293         dynargs[2] = args[2];
294         dynargs[3] = args[3];
295         return oraclize_query(timestamp, datasource, dynargs);
296     }
297     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
298         string[] memory dynargs = new string[](4);
299         dynargs[0] = args[0];
300         dynargs[1] = args[1];
301         dynargs[2] = args[2];
302         dynargs[3] = args[3];
303         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
304     }
305     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
306         string[] memory dynargs = new string[](4);
307         dynargs[0] = args[0];
308         dynargs[1] = args[1];
309         dynargs[2] = args[2];
310         dynargs[3] = args[3];
311         return oraclize_query(datasource, dynargs, gaslimit);
312     }
313     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
314         string[] memory dynargs = new string[](5);
315         dynargs[0] = args[0];
316         dynargs[1] = args[1];
317         dynargs[2] = args[2];
318         dynargs[3] = args[3];
319         dynargs[4] = args[4];
320         return oraclize_query(datasource, dynargs);
321     }
322     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
323         string[] memory dynargs = new string[](5);
324         dynargs[0] = args[0];
325         dynargs[1] = args[1];
326         dynargs[2] = args[2];
327         dynargs[3] = args[3];
328         dynargs[4] = args[4];
329         return oraclize_query(timestamp, datasource, dynargs);
330     }
331     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
332         string[] memory dynargs = new string[](5);
333         dynargs[0] = args[0];
334         dynargs[1] = args[1];
335         dynargs[2] = args[2];
336         dynargs[3] = args[3];
337         dynargs[4] = args[4];
338         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
339     }
340     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
341         string[] memory dynargs = new string[](5);
342         dynargs[0] = args[0];
343         dynargs[1] = args[1];
344         dynargs[2] = args[2];
345         dynargs[3] = args[3];
346         dynargs[4] = args[4];
347         return oraclize_query(datasource, dynargs, gaslimit);
348     }
349     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
350         uint price = oraclize.getPrice(datasource);
351         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
352         bytes memory args = ba2cbor(argN);
353         return oraclize.queryN.value(price)(0, datasource, args);
354     }
355     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
356         uint price = oraclize.getPrice(datasource);
357         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
358         bytes memory args = ba2cbor(argN);
359         return oraclize.queryN.value(price)(timestamp, datasource, args);
360     }
361     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
362         uint price = oraclize.getPrice(datasource, gaslimit);
363         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
364         bytes memory args = ba2cbor(argN);
365         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
366     }
367     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
368         uint price = oraclize.getPrice(datasource, gaslimit);
369         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
370         bytes memory args = ba2cbor(argN);
371         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
372     }
373     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
374         bytes[] memory dynargs = new bytes[](1);
375         dynargs[0] = args[0];
376         return oraclize_query(datasource, dynargs);
377     }
378     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
379         bytes[] memory dynargs = new bytes[](1);
380         dynargs[0] = args[0];
381         return oraclize_query(timestamp, datasource, dynargs);
382     }
383     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
384         bytes[] memory dynargs = new bytes[](1);
385         dynargs[0] = args[0];
386         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
387     }
388     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
389         bytes[] memory dynargs = new bytes[](1);
390         dynargs[0] = args[0];       
391         return oraclize_query(datasource, dynargs, gaslimit);
392     }
393     
394     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
395         bytes[] memory dynargs = new bytes[](2);
396         dynargs[0] = args[0];
397         dynargs[1] = args[1];
398         return oraclize_query(datasource, dynargs);
399     }
400     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
401         bytes[] memory dynargs = new bytes[](2);
402         dynargs[0] = args[0];
403         dynargs[1] = args[1];
404         return oraclize_query(timestamp, datasource, dynargs);
405     }
406     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
407         bytes[] memory dynargs = new bytes[](2);
408         dynargs[0] = args[0];
409         dynargs[1] = args[1];
410         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
411     }
412     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
413         bytes[] memory dynargs = new bytes[](2);
414         dynargs[0] = args[0];
415         dynargs[1] = args[1];
416         return oraclize_query(datasource, dynargs, gaslimit);
417     }
418     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
419         bytes[] memory dynargs = new bytes[](3);
420         dynargs[0] = args[0];
421         dynargs[1] = args[1];
422         dynargs[2] = args[2];
423         return oraclize_query(datasource, dynargs);
424     }
425     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
426         bytes[] memory dynargs = new bytes[](3);
427         dynargs[0] = args[0];
428         dynargs[1] = args[1];
429         dynargs[2] = args[2];
430         return oraclize_query(timestamp, datasource, dynargs);
431     }
432     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
433         bytes[] memory dynargs = new bytes[](3);
434         dynargs[0] = args[0];
435         dynargs[1] = args[1];
436         dynargs[2] = args[2];
437         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
438     }
439     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
440         bytes[] memory dynargs = new bytes[](3);
441         dynargs[0] = args[0];
442         dynargs[1] = args[1];
443         dynargs[2] = args[2];
444         return oraclize_query(datasource, dynargs, gaslimit);
445     }
446     
447     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
448         bytes[] memory dynargs = new bytes[](4);
449         dynargs[0] = args[0];
450         dynargs[1] = args[1];
451         dynargs[2] = args[2];
452         dynargs[3] = args[3];
453         return oraclize_query(datasource, dynargs);
454     }
455     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
456         bytes[] memory dynargs = new bytes[](4);
457         dynargs[0] = args[0];
458         dynargs[1] = args[1];
459         dynargs[2] = args[2];
460         dynargs[3] = args[3];
461         return oraclize_query(timestamp, datasource, dynargs);
462     }
463     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
464         bytes[] memory dynargs = new bytes[](4);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         dynargs[2] = args[2];
468         dynargs[3] = args[3];
469         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
470     }
471     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
472         bytes[] memory dynargs = new bytes[](4);
473         dynargs[0] = args[0];
474         dynargs[1] = args[1];
475         dynargs[2] = args[2];
476         dynargs[3] = args[3];
477         return oraclize_query(datasource, dynargs, gaslimit);
478     }
479     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
480         bytes[] memory dynargs = new bytes[](5);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         dynargs[2] = args[2];
484         dynargs[3] = args[3];
485         dynargs[4] = args[4];
486         return oraclize_query(datasource, dynargs);
487     }
488     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
489         bytes[] memory dynargs = new bytes[](5);
490         dynargs[0] = args[0];
491         dynargs[1] = args[1];
492         dynargs[2] = args[2];
493         dynargs[3] = args[3];
494         dynargs[4] = args[4];
495         return oraclize_query(timestamp, datasource, dynargs);
496     }
497     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         bytes[] memory dynargs = new bytes[](5);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         dynargs[3] = args[3];
503         dynargs[4] = args[4];
504         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
505     }
506     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
507         bytes[] memory dynargs = new bytes[](5);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         dynargs[3] = args[3];
512         dynargs[4] = args[4];
513         return oraclize_query(datasource, dynargs, gaslimit);
514     }
515 
516     function oraclize_cbAddress() oraclizeAPI internal returns (address){
517         return oraclize.cbAddress();
518     }
519     function oraclize_setProof(byte proofP) oraclizeAPI internal {
520         return oraclize.setProofType(proofP);
521     }
522     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
523         return oraclize.setCustomGasPrice(gasPrice);
524     }
525     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
526         return oraclize.setConfig(config);
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
539     function parseAddr(string _a) internal returns (address){
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
559     function strCompare(string _a, string _b) internal returns (int) {
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
577     function indexOf(string _haystack, string _needle) internal returns (int) {
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
604     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
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
621     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
622         return strConcat(_a, _b, _c, _d, "");
623     }
624 
625     function strConcat(string _a, string _b, string _c) internal returns (string) {
626         return strConcat(_a, _b, _c, "", "");
627     }
628 
629     function strConcat(string _a, string _b) internal returns (string) {
630         return strConcat(_a, _b, "", "", "");
631     }
632 
633     // parseInt
634     function parseInt(string _a) internal returns (uint) {
635         return parseInt(_a, 0);
636     }
637 
638     // parseInt(parseFloat*10^_b)
639     function parseInt(string _a, uint _b) internal returns (uint) {
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
657     function uint2str(uint i) internal returns (string){
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
674     function stra2cbor(string[] arr) internal returns (bytes) {
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
716     function ba2cbor(bytes[] arr) internal returns (bytes) {
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
764     function oraclize_getNetworkName() internal returns (string) {
765         return oraclize_network_name;
766     }
767     
768     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
769         if ((_nbytes == 0)||(_nbytes > 32)) throw;
770         bytes memory nbytes = new bytes(1);
771         nbytes[0] = byte(_nbytes);
772         bytes memory unonce;
773         bytes memory sessionKeyHash;
774         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
775         assembly {
776             mstore(unonce, 0x20)
777             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
778             mstore(sessionKeyHash, 0x20)
779             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
780         }
781         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
782         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
783         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
784         return queryId;
785     }
786     
787     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
788         oraclize_randomDS_args[queryId] = commitment;
789     }
790     
791     mapping(bytes32=>bytes32) oraclize_randomDS_args;
792     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
793 
794     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
795         bool sigok;
796         address signer;
797         
798         bytes32 sigr;
799         bytes32 sigs;
800         
801         bytes memory sigr_ = new bytes(32);
802         uint offset = 4+(uint(dersig[3]) - 0x20);
803         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
804         bytes memory sigs_ = new bytes(32);
805         offset += 32 + 2;
806         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
807 
808         assembly {
809             sigr := mload(add(sigr_, 32))
810             sigs := mload(add(sigs_, 32))
811         }
812         
813         
814         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
815         if (address(sha3(pubkey)) == signer) return true;
816         else {
817             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
818             return (address(sha3(pubkey)) == signer);
819         }
820     }
821 
822     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
823         bool sigok;
824         
825         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
826         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
827         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
828         
829         bytes memory appkey1_pubkey = new bytes(64);
830         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
831         
832         bytes memory tosign2 = new bytes(1+65+32);
833         tosign2[0] = 1; //role
834         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
835         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
836         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
837         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
838         
839         if (sigok == false) return false;
840         
841         
842         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
843         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
844         
845         bytes memory tosign3 = new bytes(1+65);
846         tosign3[0] = 0xFE;
847         copyBytes(proof, 3, 65, tosign3, 1);
848         
849         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
850         copyBytes(proof, 3+65, sig3.length, sig3, 0);
851         
852         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
853         
854         return sigok;
855     }
856     
857     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
858         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
859         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
860         
861         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
862         if (proofVerified == false) throw;
863         
864         _;
865     }
866     
867     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
868         bool match_ = true;
869         
870         for (var i=0; i<prefix.length; i++){
871             if (content[i] != prefix[i]) match_ = false;
872         }
873         
874         return match_;
875     }
876 
877     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
878         bool checkok;
879         
880         
881         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
882         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
883         bytes memory keyhash = new bytes(32);
884         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
885         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
886         if (checkok == false) return false;
887         
888         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
889         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
890         
891         
892         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
893         checkok = matchBytes32Prefix(sha256(sig1), result);
894         if (checkok == false) return false;
895         
896         
897         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
898         // This is to verify that the computed args match with the ones specified in the query.
899         bytes memory commitmentSlice1 = new bytes(8+1+32);
900         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
901         
902         bytes memory sessionPubkey = new bytes(64);
903         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
904         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
905         
906         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
907         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
908             delete oraclize_randomDS_args[queryId];
909         } else return false;
910         
911         
912         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
913         bytes memory tosign1 = new bytes(32+8+1+32);
914         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
915         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
916         if (checkok == false) return false;
917         
918         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
919         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
920             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
921         }
922         
923         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
924     }
925 
926     
927     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
928     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
929         uint minLength = length + toOffset;
930 
931         if (to.length < minLength) {
932             // Buffer too small
933             throw; // Should be a better way?
934         }
935 
936         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
937         uint i = 32 + fromOffset;
938         uint j = 32 + toOffset;
939 
940         while (i < (32 + fromOffset + length)) {
941             assembly {
942                 let tmp := mload(add(from, i))
943                 mstore(add(to, j), tmp)
944             }
945             i += 32;
946             j += 32;
947         }
948 
949         return to;
950     }
951     
952     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
953     // Duplicate Solidity's ecrecover, but catching the CALL return value
954     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
955         // We do our own memory management here. Solidity uses memory offset
956         // 0x40 to store the current end of memory. We write past it (as
957         // writes are memory extensions), but don't update the offset so
958         // Solidity will reuse it. The memory used here is only needed for
959         // this context.
960 
961         // FIXME: inline assembly can't access return values
962         bool ret;
963         address addr;
964 
965         assembly {
966             let size := mload(0x40)
967             mstore(size, hash)
968             mstore(add(size, 32), v)
969             mstore(add(size, 64), r)
970             mstore(add(size, 96), s)
971 
972             // NOTE: we can reuse the request memory because we deal with
973             //       the return code
974             ret := call(3000, 1, 0, size, 128, size, 32)
975             addr := mload(size)
976         }
977   
978         return (ret, addr);
979     }
980 
981     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
982     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
983         bytes32 r;
984         bytes32 s;
985         uint8 v;
986 
987         if (sig.length != 65)
988           return (false, 0);
989 
990         // The signature format is a compact form of:
991         //   {bytes32 r}{bytes32 s}{uint8 v}
992         // Compact means, uint8 is not padded to 32 bytes.
993         assembly {
994             r := mload(add(sig, 32))
995             s := mload(add(sig, 64))
996 
997             // Here we are loading the last 32 bytes. We exploit the fact that
998             // 'mload' will pad with zeroes if we overread.
999             // There is no 'mload8' to do this, but that would be nicer.
1000             v := byte(0, mload(add(sig, 96)))
1001 
1002             // Alternative solution:
1003             // 'byte' is not working due to the Solidity parser, so lets
1004             // use the second best option, 'and'
1005             // v := and(mload(add(sig, 65)), 255)
1006         }
1007 
1008         // albeit non-transactional signatures are not specified by the YP, one would expect it
1009         // to match the YP range of [27, 28]
1010         //
1011         // geth uses [0, 1] and some clients have followed. This might change, see:
1012         //  https://github.com/ethereum/go-ethereum/issues/2053
1013         if (v < 27)
1014           v += 27;
1015 
1016         if (v != 27 && v != 28)
1017             return (false, 0);
1018 
1019         return safer_ecrecover(hash, v, r, s);
1020     }
1021         
1022 }
1023 // </ORACLIZE_API>
1024 
1025 pragma solidity ^0.4.0;
1026 
1027 contract KrakenPriceTicker is usingOraclize {
1028     
1029     string public ETHXBT;
1030     
1031     event newOraclizeQuery(string description);
1032     event newKrakenPriceTicker(string price);
1033     
1034     modifier oraclizeAPI {
1035         oraclize = OraclizeI(0x6f28b146804dba2d6f944c03528a8fdbc673df2c);
1036         _;
1037     }
1038 
1039     function KrakenPriceTicker() {
1040         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1041         update();
1042     }
1043 
1044     function __callback(bytes32 myid, string result, bytes proof) {
1045         if (msg.sender != oraclize_cbAddress()) throw;
1046         ETHXBT = result;
1047         newKrakenPriceTicker(ETHXBT);
1048         update();
1049     }
1050     
1051     function update() payable {
1052         if (oraclize.getPrice("URL") > this.balance) {
1053             newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1054         } else {
1055             newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1056             oraclize_query(60, "URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHXBT).result.XETHXXBT.c.0");
1057         }
1058     }
1059     
1060 }