1 pragma solidity ^0.4.18;
2 // <ORACLIZE_API>
3 /*
4 Copyright (c) 2015-2016 Oraclize SRL
5 Copyright (c) 2016 Oraclize LTD
6 
7 
8 
9 Permission is hereby granted, free of charge, to any person obtaining a copy
10 of this software and associated documentation files (the "Software"), to deal
11 in the Software without restriction, including without limitation the rights
12 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
13 copies of the Software, and to permit persons to whom the Software is
14 furnished to do so, subject to the following conditions:
15 
16 
17 
18 The above copyright notice and this permission notice shall be included in
19 all copies or substantial portions of the Software.
20 
21 
22 
23 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
24 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
25 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
26 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
27 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
28 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
29 THE SOFTWARE.
30 */
31 
32 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
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
73         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
74             oraclize_setNetwork(networkID_auto);
75 
76         if(address(oraclize) != OAR.getAddress())
77             oraclize = OraclizeI(OAR.getAddress());
78 
79         _;
80     }
81     modifier coupon(string code){
82         oraclize = OraclizeI(OAR.getAddress());
83         oraclize.useCoupon(code);
84         _;
85     }
86 
87     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
88         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
89             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
90             oraclize_setNetworkName("eth_mainnet");
91             return true;
92         }
93         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
94             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
95             oraclize_setNetworkName("eth_ropsten3");
96             return true;
97         }
98         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
99             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
100             oraclize_setNetworkName("eth_kovan");
101             return true;
102         }
103         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
104             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
105             oraclize_setNetworkName("eth_rinkeby");
106             return true;
107         }
108         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
109             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
110             return true;
111         }
112         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
113             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
114             return true;
115         }
116         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
117             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
118             return true;
119         }
120         return false;
121     }
122 
123     function __callback(bytes32 myid, string result) {
124         __callback(myid, result, new bytes(0));
125     }
126     function __callback(bytes32 myid, string result, bytes proof) {
127     }
128 
129     function oraclize_useCoupon(string code) oraclizeAPI internal {
130         oraclize.useCoupon(code);
131     }
132 
133     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
134         return oraclize.getPrice(datasource);
135     }
136 
137     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
138         return oraclize.getPrice(datasource, gaslimit);
139     }
140 
141     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
142         uint price = oraclize.getPrice(datasource);
143         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
144         return oraclize.query.value(price)(0, datasource, arg);
145     }
146     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
147         uint price = oraclize.getPrice(datasource);
148         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
149         return oraclize.query.value(price)(timestamp, datasource, arg);
150     }
151     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
152         uint price = oraclize.getPrice(datasource, gaslimit);
153         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
154         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
155     }
156     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
157         uint price = oraclize.getPrice(datasource, gaslimit);
158         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
159         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
160     }
161     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
162         uint price = oraclize.getPrice(datasource);
163         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
164         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
165     }
166     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
167         uint price = oraclize.getPrice(datasource);
168         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
169         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
170     }
171     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
172         uint price = oraclize.getPrice(datasource, gaslimit);
173         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
174         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
175     }
176     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
177         uint price = oraclize.getPrice(datasource, gaslimit);
178         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
179         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
180     }
181     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
182         uint price = oraclize.getPrice(datasource);
183         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
184         bytes memory args = stra2cbor(argN);
185         return oraclize.queryN.value(price)(0, datasource, args);
186     }
187     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
188         uint price = oraclize.getPrice(datasource);
189         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
190         bytes memory args = stra2cbor(argN);
191         return oraclize.queryN.value(price)(timestamp, datasource, args);
192     }
193     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
194         uint price = oraclize.getPrice(datasource, gaslimit);
195         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
196         bytes memory args = stra2cbor(argN);
197         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
198     }
199     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
200         uint price = oraclize.getPrice(datasource, gaslimit);
201         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
202         bytes memory args = stra2cbor(argN);
203         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
204     }
205     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
206         string[] memory dynargs = new string[](1);
207         dynargs[0] = args[0];
208         return oraclize_query(datasource, dynargs);
209     }
210     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
211         string[] memory dynargs = new string[](1);
212         dynargs[0] = args[0];
213         return oraclize_query(timestamp, datasource, dynargs);
214     }
215     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
216         string[] memory dynargs = new string[](1);
217         dynargs[0] = args[0];
218         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
219     }
220     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
221         string[] memory dynargs = new string[](1);
222         dynargs[0] = args[0];
223         return oraclize_query(datasource, dynargs, gaslimit);
224     }
225 
226     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
227         string[] memory dynargs = new string[](2);
228         dynargs[0] = args[0];
229         dynargs[1] = args[1];
230         return oraclize_query(datasource, dynargs);
231     }
232     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
233         string[] memory dynargs = new string[](2);
234         dynargs[0] = args[0];
235         dynargs[1] = args[1];
236         return oraclize_query(timestamp, datasource, dynargs);
237     }
238     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
239         string[] memory dynargs = new string[](2);
240         dynargs[0] = args[0];
241         dynargs[1] = args[1];
242         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
243     }
244     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
245         string[] memory dynargs = new string[](2);
246         dynargs[0] = args[0];
247         dynargs[1] = args[1];
248         return oraclize_query(datasource, dynargs, gaslimit);
249     }
250     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
251         string[] memory dynargs = new string[](3);
252         dynargs[0] = args[0];
253         dynargs[1] = args[1];
254         dynargs[2] = args[2];
255         return oraclize_query(datasource, dynargs);
256     }
257     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
258         string[] memory dynargs = new string[](3);
259         dynargs[0] = args[0];
260         dynargs[1] = args[1];
261         dynargs[2] = args[2];
262         return oraclize_query(timestamp, datasource, dynargs);
263     }
264     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
265         string[] memory dynargs = new string[](3);
266         dynargs[0] = args[0];
267         dynargs[1] = args[1];
268         dynargs[2] = args[2];
269         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
270     }
271     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
272         string[] memory dynargs = new string[](3);
273         dynargs[0] = args[0];
274         dynargs[1] = args[1];
275         dynargs[2] = args[2];
276         return oraclize_query(datasource, dynargs, gaslimit);
277     }
278 
279     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
280         string[] memory dynargs = new string[](4);
281         dynargs[0] = args[0];
282         dynargs[1] = args[1];
283         dynargs[2] = args[2];
284         dynargs[3] = args[3];
285         return oraclize_query(datasource, dynargs);
286     }
287     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
288         string[] memory dynargs = new string[](4);
289         dynargs[0] = args[0];
290         dynargs[1] = args[1];
291         dynargs[2] = args[2];
292         dynargs[3] = args[3];
293         return oraclize_query(timestamp, datasource, dynargs);
294     }
295     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
296         string[] memory dynargs = new string[](4);
297         dynargs[0] = args[0];
298         dynargs[1] = args[1];
299         dynargs[2] = args[2];
300         dynargs[3] = args[3];
301         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
302     }
303     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
304         string[] memory dynargs = new string[](4);
305         dynargs[0] = args[0];
306         dynargs[1] = args[1];
307         dynargs[2] = args[2];
308         dynargs[3] = args[3];
309         return oraclize_query(datasource, dynargs, gaslimit);
310     }
311     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
312         string[] memory dynargs = new string[](5);
313         dynargs[0] = args[0];
314         dynargs[1] = args[1];
315         dynargs[2] = args[2];
316         dynargs[3] = args[3];
317         dynargs[4] = args[4];
318         return oraclize_query(datasource, dynargs);
319     }
320     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
321         string[] memory dynargs = new string[](5);
322         dynargs[0] = args[0];
323         dynargs[1] = args[1];
324         dynargs[2] = args[2];
325         dynargs[3] = args[3];
326         dynargs[4] = args[4];
327         return oraclize_query(timestamp, datasource, dynargs);
328     }
329     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
330         string[] memory dynargs = new string[](5);
331         dynargs[0] = args[0];
332         dynargs[1] = args[1];
333         dynargs[2] = args[2];
334         dynargs[3] = args[3];
335         dynargs[4] = args[4];
336         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
337     }
338     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
339         string[] memory dynargs = new string[](5);
340         dynargs[0] = args[0];
341         dynargs[1] = args[1];
342         dynargs[2] = args[2];
343         dynargs[3] = args[3];
344         dynargs[4] = args[4];
345         return oraclize_query(datasource, dynargs, gaslimit);
346     }
347     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
348         uint price = oraclize.getPrice(datasource);
349         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
350         bytes memory args = ba2cbor(argN);
351         return oraclize.queryN.value(price)(0, datasource, args);
352     }
353     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
354         uint price = oraclize.getPrice(datasource);
355         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
356         bytes memory args = ba2cbor(argN);
357         return oraclize.queryN.value(price)(timestamp, datasource, args);
358     }
359     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
360         uint price = oraclize.getPrice(datasource, gaslimit);
361         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
362         bytes memory args = ba2cbor(argN);
363         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
364     }
365     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
366         uint price = oraclize.getPrice(datasource, gaslimit);
367         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
368         bytes memory args = ba2cbor(argN);
369         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
370     }
371     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
372         bytes[] memory dynargs = new bytes[](1);
373         dynargs[0] = args[0];
374         return oraclize_query(datasource, dynargs);
375     }
376     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
377         bytes[] memory dynargs = new bytes[](1);
378         dynargs[0] = args[0];
379         return oraclize_query(timestamp, datasource, dynargs);
380     }
381     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
382         bytes[] memory dynargs = new bytes[](1);
383         dynargs[0] = args[0];
384         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
385     }
386     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
387         bytes[] memory dynargs = new bytes[](1);
388         dynargs[0] = args[0];
389         return oraclize_query(datasource, dynargs, gaslimit);
390     }
391 
392     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
393         bytes[] memory dynargs = new bytes[](2);
394         dynargs[0] = args[0];
395         dynargs[1] = args[1];
396         return oraclize_query(datasource, dynargs);
397     }
398     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
399         bytes[] memory dynargs = new bytes[](2);
400         dynargs[0] = args[0];
401         dynargs[1] = args[1];
402         return oraclize_query(timestamp, datasource, dynargs);
403     }
404     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
405         bytes[] memory dynargs = new bytes[](2);
406         dynargs[0] = args[0];
407         dynargs[1] = args[1];
408         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
409     }
410     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
411         bytes[] memory dynargs = new bytes[](2);
412         dynargs[0] = args[0];
413         dynargs[1] = args[1];
414         return oraclize_query(datasource, dynargs, gaslimit);
415     }
416     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
417         bytes[] memory dynargs = new bytes[](3);
418         dynargs[0] = args[0];
419         dynargs[1] = args[1];
420         dynargs[2] = args[2];
421         return oraclize_query(datasource, dynargs);
422     }
423     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
424         bytes[] memory dynargs = new bytes[](3);
425         dynargs[0] = args[0];
426         dynargs[1] = args[1];
427         dynargs[2] = args[2];
428         return oraclize_query(timestamp, datasource, dynargs);
429     }
430     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
431         bytes[] memory dynargs = new bytes[](3);
432         dynargs[0] = args[0];
433         dynargs[1] = args[1];
434         dynargs[2] = args[2];
435         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
436     }
437     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
438         bytes[] memory dynargs = new bytes[](3);
439         dynargs[0] = args[0];
440         dynargs[1] = args[1];
441         dynargs[2] = args[2];
442         return oraclize_query(datasource, dynargs, gaslimit);
443     }
444 
445     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
446         bytes[] memory dynargs = new bytes[](4);
447         dynargs[0] = args[0];
448         dynargs[1] = args[1];
449         dynargs[2] = args[2];
450         dynargs[3] = args[3];
451         return oraclize_query(datasource, dynargs);
452     }
453     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
454         bytes[] memory dynargs = new bytes[](4);
455         dynargs[0] = args[0];
456         dynargs[1] = args[1];
457         dynargs[2] = args[2];
458         dynargs[3] = args[3];
459         return oraclize_query(timestamp, datasource, dynargs);
460     }
461     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
462         bytes[] memory dynargs = new bytes[](4);
463         dynargs[0] = args[0];
464         dynargs[1] = args[1];
465         dynargs[2] = args[2];
466         dynargs[3] = args[3];
467         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
468     }
469     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
470         bytes[] memory dynargs = new bytes[](4);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         dynargs[2] = args[2];
474         dynargs[3] = args[3];
475         return oraclize_query(datasource, dynargs, gaslimit);
476     }
477     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
478         bytes[] memory dynargs = new bytes[](5);
479         dynargs[0] = args[0];
480         dynargs[1] = args[1];
481         dynargs[2] = args[2];
482         dynargs[3] = args[3];
483         dynargs[4] = args[4];
484         return oraclize_query(datasource, dynargs);
485     }
486     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
487         bytes[] memory dynargs = new bytes[](5);
488         dynargs[0] = args[0];
489         dynargs[1] = args[1];
490         dynargs[2] = args[2];
491         dynargs[3] = args[3];
492         dynargs[4] = args[4];
493         return oraclize_query(timestamp, datasource, dynargs);
494     }
495     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
496         bytes[] memory dynargs = new bytes[](5);
497         dynargs[0] = args[0];
498         dynargs[1] = args[1];
499         dynargs[2] = args[2];
500         dynargs[3] = args[3];
501         dynargs[4] = args[4];
502         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
503     }
504     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
505         bytes[] memory dynargs = new bytes[](5);
506         dynargs[0] = args[0];
507         dynargs[1] = args[1];
508         dynargs[2] = args[2];
509         dynargs[3] = args[3];
510         dynargs[4] = args[4];
511         return oraclize_query(datasource, dynargs, gaslimit);
512     }
513 
514     function oraclize_cbAddress() oraclizeAPI internal returns (address){
515         return oraclize.cbAddress();
516     }
517     function oraclize_setProof(byte proofP) oraclizeAPI internal {
518         return oraclize.setProofType(proofP);
519     }
520     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
521         return oraclize.setCustomGasPrice(gasPrice);
522     }
523     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
524         return oraclize.setConfig(config);
525     }
526 
527     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
528         return oraclize.randomDS_getSessionPubKeyHash();
529     }
530 
531     function getCodeSize(address _addr) constant internal returns(uint _size) {
532         assembly {
533             _size := extcodesize(_addr)
534         }
535     }
536 
537     function parseAddr(string _a) internal returns (address){
538         bytes memory tmp = bytes(_a);
539         uint160 iaddr = 0;
540         uint160 b1;
541         uint160 b2;
542         for (uint i=2; i<2+2*20; i+=2){
543             iaddr *= 256;
544             b1 = uint160(tmp[i]);
545             b2 = uint160(tmp[i+1]);
546             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
547             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
548             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
549             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
550             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
551             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
552             iaddr += (b1*16+b2);
553         }
554         return address(iaddr);
555     }
556 
557     function strCompare(string _a, string _b) internal returns (int) {
558         bytes memory a = bytes(_a);
559         bytes memory b = bytes(_b);
560         uint minLength = a.length;
561         if (b.length < minLength) minLength = b.length;
562         for (uint i = 0; i < minLength; i ++)
563             if (a[i] < b[i])
564                 return -1;
565             else if (a[i] > b[i])
566                 return 1;
567         if (a.length < b.length)
568             return -1;
569         else if (a.length > b.length)
570             return 1;
571         else
572             return 0;
573     }
574 
575     function indexOf(string _haystack, string _needle) internal returns (int) {
576         bytes memory h = bytes(_haystack);
577         bytes memory n = bytes(_needle);
578         if(h.length < 1 || n.length < 1 || (n.length > h.length))
579             return -1;
580         else if(h.length > (2**128 -1))
581             return -1;
582         else
583         {
584             uint subindex = 0;
585             for (uint i = 0; i < h.length; i ++)
586             {
587                 if (h[i] == n[0])
588                 {
589                     subindex = 1;
590                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
591                     {
592                         subindex++;
593                     }
594                     if(subindex == n.length)
595                         return int(i);
596                 }
597             }
598             return -1;
599         }
600     }
601 
602     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
603         bytes memory _ba = bytes(_a);
604         bytes memory _bb = bytes(_b);
605         bytes memory _bc = bytes(_c);
606         bytes memory _bd = bytes(_d);
607         bytes memory _be = bytes(_e);
608         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
609         bytes memory babcde = bytes(abcde);
610         uint k = 0;
611         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
612         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
613         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
614         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
615         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
616         return string(babcde);
617     }
618 
619     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
620         return strConcat(_a, _b, _c, _d, "");
621     }
622 
623     function strConcat(string _a, string _b, string _c) internal returns (string) {
624         return strConcat(_a, _b, _c, "", "");
625     }
626 
627     function strConcat(string _a, string _b) internal returns (string) {
628         return strConcat(_a, _b, "", "", "");
629     }
630 
631     // parseInt
632     function parseInt(string _a) internal returns (uint) {
633         return parseInt(_a, 0);
634     }
635 
636     // parseInt(parseFloat*10^_b)
637     function parseInt(string _a, uint _b) internal returns (uint) {
638         bytes memory bresult = bytes(_a);
639         uint mint = 0;
640         bool decimals = false;
641         for (uint i=0; i<bresult.length; i++){
642             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
643                 if (decimals){
644                    if (_b == 0) break;
645                     else _b--;
646                 }
647                 mint *= 10;
648                 mint += uint(bresult[i]) - 48;
649             } else if (bresult[i] == 46) decimals = true;
650         }
651         if (_b > 0) mint *= 10**_b;
652         return mint;
653     }
654 
655     function uint2str(uint i) internal returns (string){
656         if (i == 0) return "0";
657         uint j = i;
658         uint len;
659         while (j != 0){
660             len++;
661             j /= 10;
662         }
663         bytes memory bstr = new bytes(len);
664         uint k = len - 1;
665         while (i != 0){
666             bstr[k--] = byte(48 + i % 10);
667             i /= 10;
668         }
669         return string(bstr);
670     }
671 
672     function stra2cbor(string[] arr) internal returns (bytes) {
673             uint arrlen = arr.length;
674 
675             // get correct cbor output length
676             uint outputlen = 0;
677             bytes[] memory elemArray = new bytes[](arrlen);
678             for (uint i = 0; i < arrlen; i++) {
679                 elemArray[i] = (bytes(arr[i]));
680                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
681             }
682             uint ctr = 0;
683             uint cborlen = arrlen + 0x80;
684             outputlen += byte(cborlen).length;
685             bytes memory res = new bytes(outputlen);
686 
687             while (byte(cborlen).length > ctr) {
688                 res[ctr] = byte(cborlen)[ctr];
689                 ctr++;
690             }
691             for (i = 0; i < arrlen; i++) {
692                 res[ctr] = 0x5F;
693                 ctr++;
694                 for (uint x = 0; x < elemArray[i].length; x++) {
695                     // if there's a bug with larger strings, this may be the culprit
696                     if (x % 23 == 0) {
697                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
698                         elemcborlen += 0x40;
699                         uint lctr = ctr;
700                         while (byte(elemcborlen).length > ctr - lctr) {
701                             res[ctr] = byte(elemcborlen)[ctr - lctr];
702                             ctr++;
703                         }
704                     }
705                     res[ctr] = elemArray[i][x];
706                     ctr++;
707                 }
708                 res[ctr] = 0xFF;
709                 ctr++;
710             }
711             return res;
712         }
713 
714     function ba2cbor(bytes[] arr) internal returns (bytes) {
715             uint arrlen = arr.length;
716 
717             // get correct cbor output length
718             uint outputlen = 0;
719             bytes[] memory elemArray = new bytes[](arrlen);
720             for (uint i = 0; i < arrlen; i++) {
721                 elemArray[i] = (bytes(arr[i]));
722                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
723             }
724             uint ctr = 0;
725             uint cborlen = arrlen + 0x80;
726             outputlen += byte(cborlen).length;
727             bytes memory res = new bytes(outputlen);
728 
729             while (byte(cborlen).length > ctr) {
730                 res[ctr] = byte(cborlen)[ctr];
731                 ctr++;
732             }
733             for (i = 0; i < arrlen; i++) {
734                 res[ctr] = 0x5F;
735                 ctr++;
736                 for (uint x = 0; x < elemArray[i].length; x++) {
737                     // if there's a bug with larger strings, this may be the culprit
738                     if (x % 23 == 0) {
739                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
740                         elemcborlen += 0x40;
741                         uint lctr = ctr;
742                         while (byte(elemcborlen).length > ctr - lctr) {
743                             res[ctr] = byte(elemcborlen)[ctr - lctr];
744                             ctr++;
745                         }
746                     }
747                     res[ctr] = elemArray[i][x];
748                     ctr++;
749                 }
750                 res[ctr] = 0xFF;
751                 ctr++;
752             }
753             return res;
754         }
755 
756 
757     string oraclize_network_name;
758     function oraclize_setNetworkName(string _network_name) internal {
759         oraclize_network_name = _network_name;
760     }
761 
762     function oraclize_getNetworkName() internal returns (string) {
763         return oraclize_network_name;
764     }
765 
766     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
767         if ((_nbytes == 0)||(_nbytes > 32)) throw;
768 	// Convert from seconds to ledger timer ticks
769         _delay *= 10; 
770         bytes memory nbytes = new bytes(1);
771         nbytes[0] = byte(_nbytes);
772         bytes memory unonce = new bytes(32);
773         bytes memory sessionKeyHash = new bytes(32);
774         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
775         assembly {
776             mstore(unonce, 0x20)
777             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
778             mstore(sessionKeyHash, 0x20)
779             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
780         }
781         bytes memory delay = new bytes(32);
782         assembly { 
783             mstore(add(delay, 0x20), _delay) 
784         }
785         
786         bytes memory delay_bytes8 = new bytes(8);
787         copyBytes(delay, 24, 8, delay_bytes8, 0);
788 
789         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
790         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
791         
792         bytes memory delay_bytes8_left = new bytes(8);
793         
794         assembly {
795             let x := mload(add(delay_bytes8, 0x20))
796             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
797             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
798             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
799             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
800             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
801             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
802             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
803             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
804 
805         }
806         
807         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
808         return queryId;
809     }
810     
811     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
812         oraclize_randomDS_args[queryId] = commitment;
813     }
814 
815     mapping(bytes32=>bytes32) oraclize_randomDS_args;
816     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
817 
818     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
819         bool sigok;
820         address signer;
821 
822         bytes32 sigr;
823         bytes32 sigs;
824 
825         bytes memory sigr_ = new bytes(32);
826         uint offset = 4+(uint(dersig[3]) - 0x20);
827         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
828         bytes memory sigs_ = new bytes(32);
829         offset += 32 + 2;
830         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
831 
832         assembly {
833             sigr := mload(add(sigr_, 32))
834             sigs := mload(add(sigs_, 32))
835         }
836 
837 
838         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
839         if (address(sha3(pubkey)) == signer) return true;
840         else {
841             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
842             return (address(sha3(pubkey)) == signer);
843         }
844     }
845 
846     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
847         bool sigok;
848 
849         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
850         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
851         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
852 
853         bytes memory appkey1_pubkey = new bytes(64);
854         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
855 
856         bytes memory tosign2 = new bytes(1+65+32);
857         tosign2[0] = 1; //role
858         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
859         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
860         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
861         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
862 
863         if (sigok == false) return false;
864 
865 
866         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
867         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
868 
869         bytes memory tosign3 = new bytes(1+65);
870         tosign3[0] = 0xFE;
871         copyBytes(proof, 3, 65, tosign3, 1);
872 
873         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
874         copyBytes(proof, 3+65, sig3.length, sig3, 0);
875 
876         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
877 
878         return sigok;
879     }
880 
881     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
882         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
883         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
884 
885         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
886         if (proofVerified == false) throw;
887 
888         _;
889     }
890 
891     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
892         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
893         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
894 
895         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
896         if (proofVerified == false) return 2;
897 
898         return 0;
899     }
900 
901     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
902         bool match_ = true;
903 	
904 	if (prefix.length != n_random_bytes) throw;
905 	        
906         for (uint256 i=0; i< n_random_bytes; i++) {
907             if (content[i] != prefix[i]) match_ = false;
908         }
909 
910         return match_;
911     }
912 
913     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
914 
915         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
916         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
917         bytes memory keyhash = new bytes(32);
918         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
919         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
920 
921         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
922         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
923 
924         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
925         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
926 
927         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
928         // This is to verify that the computed args match with the ones specified in the query.
929         bytes memory commitmentSlice1 = new bytes(8+1+32);
930         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
931 
932         bytes memory sessionPubkey = new bytes(64);
933         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
934         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
935 
936         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
937         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
938             delete oraclize_randomDS_args[queryId];
939         } else return false;
940 
941 
942         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
943         bytes memory tosign1 = new bytes(32+8+1+32);
944         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
945         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
946 
947         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
948         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
949             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
950         }
951 
952         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
953     }
954 
955 
956     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
957     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
958         uint minLength = length + toOffset;
959 
960         if (to.length < minLength) {
961             // Buffer too small
962             throw; // Should be a better way?
963         }
964 
965         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
966         uint i = 32 + fromOffset;
967         uint j = 32 + toOffset;
968 
969         while (i < (32 + fromOffset + length)) {
970             assembly {
971                 let tmp := mload(add(from, i))
972                 mstore(add(to, j), tmp)
973             }
974             i += 32;
975             j += 32;
976         }
977 
978         return to;
979     }
980 
981     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
982     // Duplicate Solidity's ecrecover, but catching the CALL return value
983     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
984         // We do our own memory management here. Solidity uses memory offset
985         // 0x40 to store the current end of memory. We write past it (as
986         // writes are memory extensions), but don't update the offset so
987         // Solidity will reuse it. The memory used here is only needed for
988         // this context.
989 
990         // FIXME: inline assembly can't access return values
991         bool ret;
992         address addr;
993 
994         assembly {
995             let size := mload(0x40)
996             mstore(size, hash)
997             mstore(add(size, 32), v)
998             mstore(add(size, 64), r)
999             mstore(add(size, 96), s)
1000 
1001             // NOTE: we can reuse the request memory because we deal with
1002             //       the return code
1003             ret := call(3000, 1, 0, size, 128, size, 32)
1004             addr := mload(size)
1005         }
1006 
1007         return (ret, addr);
1008     }
1009 
1010     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1011     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1012         bytes32 r;
1013         bytes32 s;
1014         uint8 v;
1015 
1016         if (sig.length != 65)
1017           return (false, 0);
1018 
1019         // The signature format is a compact form of:
1020         //   {bytes32 r}{bytes32 s}{uint8 v}
1021         // Compact means, uint8 is not padded to 32 bytes.
1022         assembly {
1023             r := mload(add(sig, 32))
1024             s := mload(add(sig, 64))
1025 
1026             // Here we are loading the last 32 bytes. We exploit the fact that
1027             // 'mload' will pad with zeroes if we overread.
1028             // There is no 'mload8' to do this, but that would be nicer.
1029             v := byte(0, mload(add(sig, 96)))
1030 
1031             // Alternative solution:
1032             // 'byte' is not working due to the Solidity parser, so lets
1033             // use the second best option, 'and'
1034             // v := and(mload(add(sig, 65)), 255)
1035         }
1036 
1037         // albeit non-transactional signatures are not specified by the YP, one would expect it
1038         // to match the YP range of [27, 28]
1039         //
1040         // geth uses [0, 1] and some clients have followed. This might change, see:
1041         //  https://github.com/ethereum/go-ethereum/issues/2053
1042         if (v < 27)
1043           v += 27;
1044 
1045         if (v != 27 && v != 28)
1046             return (false, 0);
1047 
1048         return safer_ecrecover(hash, v, r, s);
1049     }
1050 
1051 }
1052 // </ORACLIZE_API>
1053 
1054 /*
1055  * @title String & slice utility library for Solidity contracts.
1056  * @author Nick Johnson <arachnid@notdot.net>
1057  *
1058  * @dev Functionality in this library is largely implemented using an
1059  *      abstraction called a 'slice'. A slice represents a part of a string -
1060  *      anything from the entire string to a single character, or even no
1061  *      characters at all (a 0-length slice). Since a slice only has to specify
1062  *      an offset and a length, copying and manipulating slices is a lot less
1063  *      expensive than copying and manipulating the strings they reference.
1064  *
1065  *      To further reduce gas costs, most functions on slice that need to return
1066  *      a slice modify the original one instead of allocating a new one; for
1067  *      instance, `s.split(".")` will return the text up to the first '.',
1068  *      modifying s to only contain the remainder of the string after the '.'.
1069  *      In situations where you do not want to modify the original slice, you
1070  *      can make a copy first with `.copy()`, for example:
1071  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1072  *      Solidity has no memory management, it will result in allocating many
1073  *      short-lived slices that are later discarded.
1074  *
1075  *      Functions that return two slices come in two versions: a non-allocating
1076  *      version that takes the second slice as an argument, modifying it in
1077  *      place, and an allocating version that allocates and returns the second
1078  *      slice; see `nextRune` for example.
1079  *
1080  *      Functions that have to copy string data will return strings rather than
1081  *      slices; these can be cast back to slices for further processing if
1082  *      required.
1083  *
1084  *      For convenience, some functions are provided with non-modifying
1085  *      variants that create a new slice and return both; for instance,
1086  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1087  *      corresponding to the left and right parts of the string.
1088  */
1089  
1090 pragma solidity ^0.4.14;
1091 
1092 library strings {
1093     struct slice {
1094         uint _len;
1095         uint _ptr;
1096     }
1097 
1098     function memcpy(uint dest, uint src, uint len) private {
1099         // Copy word-length chunks while possible
1100         for(; len >= 32; len -= 32) {
1101             assembly {
1102                 mstore(dest, mload(src))
1103             }
1104             dest += 32;
1105             src += 32;
1106         }
1107 
1108         // Copy remaining bytes
1109         uint mask = 256 ** (32 - len) - 1;
1110         assembly {
1111             let srcpart := and(mload(src), not(mask))
1112             let destpart := and(mload(dest), mask)
1113             mstore(dest, or(destpart, srcpart))
1114         }
1115     }
1116 
1117     /*
1118      * @dev Returns a slice containing the entire string.
1119      * @param self The string to make a slice from.
1120      * @return A newly allocated slice containing the entire string.
1121      */
1122     function toSlice(string self) internal returns (slice) {
1123         uint ptr;
1124         assembly {
1125             ptr := add(self, 0x20)
1126         }
1127         return slice(bytes(self).length, ptr);
1128     }
1129 
1130     /*
1131      * @dev Returns the length of a null-terminated bytes32 string.
1132      * @param self The value to find the length of.
1133      * @return The length of the string, from 0 to 32.
1134      */
1135     function len(bytes32 self) internal returns (uint) {
1136         uint ret;
1137         if (self == 0)
1138             return 0;
1139         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1140             ret += 16;
1141             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1142         }
1143         if (self & 0xffffffffffffffff == 0) {
1144             ret += 8;
1145             self = bytes32(uint(self) / 0x10000000000000000);
1146         }
1147         if (self & 0xffffffff == 0) {
1148             ret += 4;
1149             self = bytes32(uint(self) / 0x100000000);
1150         }
1151         if (self & 0xffff == 0) {
1152             ret += 2;
1153             self = bytes32(uint(self) / 0x10000);
1154         }
1155         if (self & 0xff == 0) {
1156             ret += 1;
1157         }
1158         return 32 - ret;
1159     }
1160 
1161     /*
1162      * @dev Returns a slice containing the entire bytes32, interpreted as a
1163      *      null-termintaed utf-8 string.
1164      * @param self The bytes32 value to convert to a slice.
1165      * @return A new slice containing the value of the input argument up to the
1166      *         first null.
1167      */
1168     function toSliceB32(bytes32 self) internal returns (slice ret) {
1169         // Allocate space for `self` in memory, copy it there, and point ret at it
1170         assembly {
1171             let ptr := mload(0x40)
1172             mstore(0x40, add(ptr, 0x20))
1173             mstore(ptr, self)
1174             mstore(add(ret, 0x20), ptr)
1175         }
1176         ret._len = len(self);
1177     }
1178 
1179     /*
1180      * @dev Returns a new slice containing the same data as the current slice.
1181      * @param self The slice to copy.
1182      * @return A new slice containing the same data as `self`.
1183      */
1184     function copy(slice self) internal returns (slice) {
1185         return slice(self._len, self._ptr);
1186     }
1187 
1188     /*
1189      * @dev Copies a slice to a new string.
1190      * @param self The slice to copy.
1191      * @return A newly allocated string containing the slice's text.
1192      */
1193     function toString(slice self) internal returns (string) {
1194         var ret = new string(self._len);
1195         uint retptr;
1196         assembly { retptr := add(ret, 32) }
1197 
1198         memcpy(retptr, self._ptr, self._len);
1199         return ret;
1200     }
1201 
1202     /*
1203      * @dev Returns the length in runes of the slice. Note that this operation
1204      *      takes time proportional to the length of the slice; avoid using it
1205      *      in loops, and call `slice.empty()` if you only need to know whether
1206      *      the slice is empty or not.
1207      * @param self The slice to operate on.
1208      * @return The length of the slice in runes.
1209      */
1210     function len(slice self) internal returns (uint l) {
1211         // Starting at ptr-31 means the LSB will be the byte we care about
1212         var ptr = self._ptr - 31;
1213         var end = ptr + self._len;
1214         for (l = 0; ptr < end; l++) {
1215             uint8 b;
1216             assembly { b := and(mload(ptr), 0xFF) }
1217             if (b < 0x80) {
1218                 ptr += 1;
1219             } else if(b < 0xE0) {
1220                 ptr += 2;
1221             } else if(b < 0xF0) {
1222                 ptr += 3;
1223             } else if(b < 0xF8) {
1224                 ptr += 4;
1225             } else if(b < 0xFC) {
1226                 ptr += 5;
1227             } else {
1228                 ptr += 6;
1229             }
1230         }
1231     }
1232 
1233     /*
1234      * @dev Returns true if the slice is empty (has a length of 0).
1235      * @param self The slice to operate on.
1236      * @return True if the slice is empty, False otherwise.
1237      */
1238     function empty(slice self) internal returns (bool) {
1239         return self._len == 0;
1240     }
1241 
1242     /*
1243      * @dev Returns a positive number if `other` comes lexicographically after
1244      *      `self`, a negative number if it comes before, or zero if the
1245      *      contents of the two slices are equal. Comparison is done per-rune,
1246      *      on unicode codepoints.
1247      * @param self The first slice to compare.
1248      * @param other The second slice to compare.
1249      * @return The result of the comparison.
1250      */
1251     function compare(slice self, slice other) internal returns (int) {
1252         uint shortest = self._len;
1253         if (other._len < self._len)
1254             shortest = other._len;
1255 
1256         var selfptr = self._ptr;
1257         var otherptr = other._ptr;
1258         for (uint idx = 0; idx < shortest; idx += 32) {
1259             uint a;
1260             uint b;
1261             assembly {
1262                 a := mload(selfptr)
1263                 b := mload(otherptr)
1264             }
1265             if (a != b) {
1266                 // Mask out irrelevant bytes and check again
1267                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1268                 var diff = (a & mask) - (b & mask);
1269                 if (diff != 0)
1270                     return int(diff);
1271             }
1272             selfptr += 32;
1273             otherptr += 32;
1274         }
1275         return int(self._len) - int(other._len);
1276     }
1277 
1278     /*
1279      * @dev Returns true if the two slices contain the same text.
1280      * @param self The first slice to compare.
1281      * @param self The second slice to compare.
1282      * @return True if the slices are equal, false otherwise.
1283      */
1284     function equals(slice self, slice other) internal returns (bool) {
1285         return compare(self, other) == 0;
1286     }
1287 
1288     /*
1289      * @dev Extracts the first rune in the slice into `rune`, advancing the
1290      *      slice to point to the next rune and returning `self`.
1291      * @param self The slice to operate on.
1292      * @param rune The slice that will contain the first rune.
1293      * @return `rune`.
1294      */
1295     function nextRune(slice self, slice rune) internal returns (slice) {
1296         rune._ptr = self._ptr;
1297 
1298         if (self._len == 0) {
1299             rune._len = 0;
1300             return rune;
1301         }
1302 
1303         uint len;
1304         uint b;
1305         // Load the first byte of the rune into the LSBs of b
1306         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1307         if (b < 0x80) {
1308             len = 1;
1309         } else if(b < 0xE0) {
1310             len = 2;
1311         } else if(b < 0xF0) {
1312             len = 3;
1313         } else {
1314             len = 4;
1315         }
1316 
1317         // Check for truncated codepoints
1318         if (len > self._len) {
1319             rune._len = self._len;
1320             self._ptr += self._len;
1321             self._len = 0;
1322             return rune;
1323         }
1324 
1325         self._ptr += len;
1326         self._len -= len;
1327         rune._len = len;
1328         return rune;
1329     }
1330 
1331     /*
1332      * @dev Returns the first rune in the slice, advancing the slice to point
1333      *      to the next rune.
1334      * @param self The slice to operate on.
1335      * @return A slice containing only the first rune from `self`.
1336      */
1337     function nextRune(slice self) internal returns (slice ret) {
1338         nextRune(self, ret);
1339     }
1340 
1341     /*
1342      * @dev Returns the number of the first codepoint in the slice.
1343      * @param self The slice to operate on.
1344      * @return The number of the first codepoint in the slice.
1345      */
1346     function ord(slice self) internal returns (uint ret) {
1347         if (self._len == 0) {
1348             return 0;
1349         }
1350 
1351         uint word;
1352         uint length;
1353         uint divisor = 2 ** 248;
1354 
1355         // Load the rune into the MSBs of b
1356         assembly { word:= mload(mload(add(self, 32))) }
1357         var b = word / divisor;
1358         if (b < 0x80) {
1359             ret = b;
1360             length = 1;
1361         } else if(b < 0xE0) {
1362             ret = b & 0x1F;
1363             length = 2;
1364         } else if(b < 0xF0) {
1365             ret = b & 0x0F;
1366             length = 3;
1367         } else {
1368             ret = b & 0x07;
1369             length = 4;
1370         }
1371 
1372         // Check for truncated codepoints
1373         if (length > self._len) {
1374             return 0;
1375         }
1376 
1377         for (uint i = 1; i < length; i++) {
1378             divisor = divisor / 256;
1379             b = (word / divisor) & 0xFF;
1380             if (b & 0xC0 != 0x80) {
1381                 // Invalid UTF-8 sequence
1382                 return 0;
1383             }
1384             ret = (ret * 64) | (b & 0x3F);
1385         }
1386 
1387         return ret;
1388     }
1389 
1390     /*
1391      * @dev Returns the keccak-256 hash of the slice.
1392      * @param self The slice to hash.
1393      * @return The hash of the slice.
1394      */
1395     function keccak(slice self) internal returns (bytes32 ret) {
1396         assembly {
1397             ret := keccak256(mload(add(self, 32)), mload(self))
1398         }
1399     }
1400 
1401     /*
1402      * @dev Returns true if `self` starts with `needle`.
1403      * @param self The slice to operate on.
1404      * @param needle The slice to search for.
1405      * @return True if the slice starts with the provided text, false otherwise.
1406      */
1407     function startsWith(slice self, slice needle) internal returns (bool) {
1408         if (self._len < needle._len) {
1409             return false;
1410         }
1411 
1412         if (self._ptr == needle._ptr) {
1413             return true;
1414         }
1415 
1416         bool equal;
1417         assembly {
1418             let length := mload(needle)
1419             let selfptr := mload(add(self, 0x20))
1420             let needleptr := mload(add(needle, 0x20))
1421             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1422         }
1423         return equal;
1424     }
1425 
1426     /*
1427      * @dev If `self` starts with `needle`, `needle` is removed from the
1428      *      beginning of `self`. Otherwise, `self` is unmodified.
1429      * @param self The slice to operate on.
1430      * @param needle The slice to search for.
1431      * @return `self`
1432      */
1433     function beyond(slice self, slice needle) internal returns (slice) {
1434         if (self._len < needle._len) {
1435             return self;
1436         }
1437 
1438         bool equal = true;
1439         if (self._ptr != needle._ptr) {
1440             assembly {
1441                 let length := mload(needle)
1442                 let selfptr := mload(add(self, 0x20))
1443                 let needleptr := mload(add(needle, 0x20))
1444                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
1445             }
1446         }
1447 
1448         if (equal) {
1449             self._len -= needle._len;
1450             self._ptr += needle._len;
1451         }
1452 
1453         return self;
1454     }
1455 
1456     /*
1457      * @dev Returns true if the slice ends with `needle`.
1458      * @param self The slice to operate on.
1459      * @param needle The slice to search for.
1460      * @return True if the slice starts with the provided text, false otherwise.
1461      */
1462     function endsWith(slice self, slice needle) internal returns (bool) {
1463         if (self._len < needle._len) {
1464             return false;
1465         }
1466 
1467         var selfptr = self._ptr + self._len - needle._len;
1468 
1469         if (selfptr == needle._ptr) {
1470             return true;
1471         }
1472 
1473         bool equal;
1474         assembly {
1475             let length := mload(needle)
1476             let needleptr := mload(add(needle, 0x20))
1477             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1478         }
1479 
1480         return equal;
1481     }
1482 
1483     /*
1484      * @dev If `self` ends with `needle`, `needle` is removed from the
1485      *      end of `self`. Otherwise, `self` is unmodified.
1486      * @param self The slice to operate on.
1487      * @param needle The slice to search for.
1488      * @return `self`
1489      */
1490     function until(slice self, slice needle) internal returns (slice) {
1491         if (self._len < needle._len) {
1492             return self;
1493         }
1494 
1495         var selfptr = self._ptr + self._len - needle._len;
1496         bool equal = true;
1497         if (selfptr != needle._ptr) {
1498             assembly {
1499                 let length := mload(needle)
1500                 let needleptr := mload(add(needle, 0x20))
1501                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1502             }
1503         }
1504 
1505         if (equal) {
1506             self._len -= needle._len;
1507         }
1508 
1509         return self;
1510     }
1511 
1512     // Returns the memory address of the first byte of the first occurrence of
1513     // `needle` in `self`, or the first byte after `self` if not found.
1514     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1515         uint ptr;
1516         uint idx;
1517 
1518         if (needlelen <= selflen) {
1519             if (needlelen <= 32) {
1520                 // Optimized assembly for 68 gas per byte on short strings
1521                 assembly {
1522                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1523                     let needledata := and(mload(needleptr), mask)
1524                     let end := add(selfptr, sub(selflen, needlelen))
1525                     ptr := selfptr
1526                     loop:
1527                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1528                     ptr := add(ptr, 1)
1529                     jumpi(loop, lt(sub(ptr, 1), end))
1530                     ptr := add(selfptr, selflen)
1531                     exit:
1532                 }
1533                 return ptr;
1534             } else {
1535                 // For long needles, use hashing
1536                 bytes32 hash;
1537                 assembly { hash := sha3(needleptr, needlelen) }
1538                 ptr = selfptr;
1539                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1540                     bytes32 testHash;
1541                     assembly { testHash := sha3(ptr, needlelen) }
1542                     if (hash == testHash)
1543                         return ptr;
1544                     ptr += 1;
1545                 }
1546             }
1547         }
1548         return selfptr + selflen;
1549     }
1550 
1551     // Returns the memory address of the first byte after the last occurrence of
1552     // `needle` in `self`, or the address of `self` if not found.
1553     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1554         uint ptr;
1555 
1556         if (needlelen <= selflen) {
1557             if (needlelen <= 32) {
1558                 // Optimized assembly for 69 gas per byte on short strings
1559                 assembly {
1560                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1561                     let needledata := and(mload(needleptr), mask)
1562                     ptr := add(selfptr, sub(selflen, needlelen))
1563                     loop:
1564                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1565                     ptr := sub(ptr, 1)
1566                     jumpi(loop, gt(add(ptr, 1), selfptr))
1567                     ptr := selfptr
1568                     jump(exit)
1569                     ret:
1570                     ptr := add(ptr, needlelen)
1571                     exit:
1572                 }
1573                 return ptr;
1574             } else {
1575                 // For long needles, use hashing
1576                 bytes32 hash;
1577                 assembly { hash := sha3(needleptr, needlelen) }
1578                 ptr = selfptr + (selflen - needlelen);
1579                 while (ptr >= selfptr) {
1580                     bytes32 testHash;
1581                     assembly { testHash := sha3(ptr, needlelen) }
1582                     if (hash == testHash)
1583                         return ptr + needlelen;
1584                     ptr -= 1;
1585                 }
1586             }
1587         }
1588         return selfptr;
1589     }
1590 
1591     /*
1592      * @dev Modifies `self` to contain everything from the first occurrence of
1593      *      `needle` to the end of the slice. `self` is set to the empty slice
1594      *      if `needle` is not found.
1595      * @param self The slice to search and modify.
1596      * @param needle The text to search for.
1597      * @return `self`.
1598      */
1599     function find(slice self, slice needle) internal returns (slice) {
1600         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1601         self._len -= ptr - self._ptr;
1602         self._ptr = ptr;
1603         return self;
1604     }
1605 
1606     /*
1607      * @dev Modifies `self` to contain the part of the string from the start of
1608      *      `self` to the end of the first occurrence of `needle`. If `needle`
1609      *      is not found, `self` is set to the empty slice.
1610      * @param self The slice to search and modify.
1611      * @param needle The text to search for.
1612      * @return `self`.
1613      */
1614     function rfind(slice self, slice needle) internal returns (slice) {
1615         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1616         self._len = ptr - self._ptr;
1617         return self;
1618     }
1619 
1620     /*
1621      * @dev Splits the slice, setting `self` to everything after the first
1622      *      occurrence of `needle`, and `token` to everything before it. If
1623      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1624      *      and `token` is set to the entirety of `self`.
1625      * @param self The slice to split.
1626      * @param needle The text to search for in `self`.
1627      * @param token An output parameter to which the first token is written.
1628      * @return `token`.
1629      */
1630     function split(slice self, slice needle, slice token) internal returns (slice) {
1631         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1632         token._ptr = self._ptr;
1633         token._len = ptr - self._ptr;
1634         if (ptr == self._ptr + self._len) {
1635             // Not found
1636             self._len = 0;
1637         } else {
1638             self._len -= token._len + needle._len;
1639             self._ptr = ptr + needle._len;
1640         }
1641         return token;
1642     }
1643 
1644     /*
1645      * @dev Splits the slice, setting `self` to everything after the first
1646      *      occurrence of `needle`, and returning everything before it. If
1647      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1648      *      and the entirety of `self` is returned.
1649      * @param self The slice to split.
1650      * @param needle The text to search for in `self`.
1651      * @return The part of `self` up to the first occurrence of `delim`.
1652      */
1653     function split(slice self, slice needle) internal returns (slice token) {
1654         split(self, needle, token);
1655     }
1656 
1657     /*
1658      * @dev Splits the slice, setting `self` to everything before the last
1659      *      occurrence of `needle`, and `token` to everything after it. If
1660      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1661      *      and `token` is set to the entirety of `self`.
1662      * @param self The slice to split.
1663      * @param needle The text to search for in `self`.
1664      * @param token An output parameter to which the first token is written.
1665      * @return `token`.
1666      */
1667     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1668         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1669         token._ptr = ptr;
1670         token._len = self._len - (ptr - self._ptr);
1671         if (ptr == self._ptr) {
1672             // Not found
1673             self._len = 0;
1674         } else {
1675             self._len -= token._len + needle._len;
1676         }
1677         return token;
1678     }
1679 
1680     /*
1681      * @dev Splits the slice, setting `self` to everything before the last
1682      *      occurrence of `needle`, and returning everything after it. If
1683      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1684      *      and the entirety of `self` is returned.
1685      * @param self The slice to split.
1686      * @param needle The text to search for in `self`.
1687      * @return The part of `self` after the last occurrence of `delim`.
1688      */
1689     function rsplit(slice self, slice needle) internal returns (slice token) {
1690         rsplit(self, needle, token);
1691     }
1692 
1693     /*
1694      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1695      * @param self The slice to search.
1696      * @param needle The text to search for in `self`.
1697      * @return The number of occurrences of `needle` found in `self`.
1698      */
1699     function count(slice self, slice needle) internal returns (uint cnt) {
1700         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1701         while (ptr <= self._ptr + self._len) {
1702             cnt++;
1703             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1704         }
1705     }
1706 
1707     /*
1708      * @dev Returns True if `self` contains `needle`.
1709      * @param self The slice to search.
1710      * @param needle The text to search for in `self`.
1711      * @return True if `needle` is found in `self`, false otherwise.
1712      */
1713     function contains(slice self, slice needle) internal returns (bool) {
1714         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1715     }
1716 
1717     /*
1718      * @dev Returns a newly allocated string containing the concatenation of
1719      *      `self` and `other`.
1720      * @param self The first slice to concatenate.
1721      * @param other The second slice to concatenate.
1722      * @return The concatenation of the two strings.
1723      */
1724     function concat(slice self, slice other) internal returns (string) {
1725         var ret = new string(self._len + other._len);
1726         uint retptr;
1727         assembly { retptr := add(ret, 32) }
1728         memcpy(retptr, self._ptr, self._len);
1729         memcpy(retptr + self._len, other._ptr, other._len);
1730         return ret;
1731     }
1732 
1733     /*
1734      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1735      *      newly allocated string.
1736      * @param self The delimiter to use.
1737      * @param parts A list of slices to join.
1738      * @return A newly allocated string containing all the slices in `parts`,
1739      *         joined with `self`.
1740      */
1741     function join(slice self, slice[] parts) internal returns (string) {
1742         if (parts.length == 0)
1743             return "";
1744 
1745         uint length = self._len * (parts.length - 1);
1746         for(uint i = 0; i < parts.length; i++)
1747             length += parts[i]._len;
1748 
1749         var ret = new string(length);
1750         uint retptr;
1751         assembly { retptr := add(ret, 32) }
1752 
1753         for(i = 0; i < parts.length; i++) {
1754             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1755             retptr += parts[i]._len;
1756             if (i < parts.length - 1) {
1757                 memcpy(retptr, self._ptr, self._len);
1758                 retptr += self._len;
1759             }
1760         }
1761 
1762         return ret;
1763     }
1764 }
1765 
1766 
1767 contract DSSafeAddSub {
1768     function safeToAdd(uint a, uint b) internal returns (bool) {
1769         return (a + b >= a);
1770     }
1771     function safeAdd(uint a, uint b) internal returns (uint) {
1772         if (!safeToAdd(a, b)) throw;
1773         return a + b;
1774     }
1775 
1776     function safeToSubtract(uint a, uint b) internal returns (bool) {
1777         return (b <= a);
1778     }
1779 
1780     function safeSub(uint a, uint b) internal returns (uint) {
1781         if (!safeToSubtract(a, b)) throw;
1782         return a - b;
1783     } 
1784 }
1785 
1786 contract Xflip is usingOraclize, DSSafeAddSub {
1787     
1788   using strings for *;
1789 
1790   /*
1791    * checks player profit, bet size and player number is within range
1792    */
1793   modifier betIsValid(uint _betSize, uint _playerNumber) {      
1794     if(((((_betSize * (100-(safeSub(_playerNumber,1)))) / (safeSub(_playerNumber,1))+_betSize))*houseEdge/houseEdgeDivisor)-_betSize > maxProfit || _betSize < minBet || _playerNumber < minNumber || _playerNumber > maxNumber) throw;        
1795     _;
1796   }
1797 
1798   /*
1799    * checks game is currently active
1800   */
1801   modifier gameIsActive {
1802     if(gamePaused == true) throw;
1803     _;
1804   }
1805 
1806   /*
1807    * checks payouts are currently active
1808   */
1809   modifier payoutsAreActive {
1810     if(payoutsPaused == true) throw;
1811     _;
1812   }    
1813 
1814   /*
1815    * checks only Oraclize address is calling
1816   */
1817   modifier onlyOraclize {
1818     if (msg.sender != oraclize_cbAddress()) throw;
1819     _;
1820   }
1821 
1822   /*
1823    * checks only owner address is calling
1824    */
1825   modifier onlyOwner {
1826     if (msg.sender != owner) throw;
1827     _;
1828   }
1829 
1830   /*
1831    * checks only treasury address is calling
1832    */
1833   modifier onlyTreasury {
1834     if (msg.sender != treasury) throw;
1835     _;
1836   }    
1837 
1838   /*
1839    * game vars
1840    */ 
1841   uint constant public maxProfitDivisor = 1000000;
1842   uint constant public houseEdgeDivisor = 1000;    
1843   uint constant public maxNumber = 99; 
1844   uint constant public minNumber = 2;
1845   bool public gamePaused;
1846   uint32 public gasForOraclize;
1847   address public owner;
1848   bool public payoutsPaused; 
1849   address public treasury;
1850   uint public contractBalance;
1851   uint public houseEdge;     
1852   uint public maxProfit;   
1853   uint public maxProfitAsPercentOfHouse;                    
1854   uint public minBet; 
1855   //init discontinued contract data        
1856   int public totalBets = 0;
1857   uint public maxPendingPayouts;
1858   //init discontinued contract data
1859   uint public totalWeiWon = 0;
1860   //init discontinued contract data
1861   uint public totalWeiWagered = 0;    
1862 
1863   /*
1864    * player vars
1865    */
1866   mapping (bytes32 => address) playerAddress;
1867   mapping (bytes32 => address) playerTempAddress;
1868   mapping (bytes32 => bytes32) playerBetId;
1869   mapping (bytes32 => uint) playerBetValue;
1870   mapping (bytes32 => uint) playerTempBetValue;
1871   mapping (bytes32 => uint) playerRandomResult;            
1872   mapping (bytes32 => uint) playerDieResult;
1873   mapping (bytes32 => uint) playerNumber;
1874   mapping (address => uint) playerPendingWithdrawals;      
1875   mapping (bytes32 => uint) playerProfit;
1876   mapping (bytes32 => uint) playerTempReward;           
1877 
1878   /*
1879    * events
1880    */
1881   /* log bets + output to web3 for precise 'payout on win' field in UI */
1882   event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RewardValue, uint ProfitValue, uint BetValue, uint PlayerNumber);      
1883   /* output to web3 UI on bet result */
1884   /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send */
1885   event LogResult(uint indexed ResultSerialNumber, bytes32 indexed BetID, address indexed PlayerAddress, uint PlayerNumber, uint DiceResult, uint Value, int Status, bytes Proof, uint RandomSeed);   
1886   /* log manual refunds */
1887   event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
1888   /* log owner transfers */
1889   event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);               
1890 
1891   /*
1892    * init
1893    */
1894   function Xflip() {
1895     owner = msg.sender;
1896     treasury = msg.sender;
1897     oraclize_setNetwork(networkID_auto);        
1898     /* use TLSNotary for oraclize call */
1899     oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1900     /* init 990 = 99% (1% houseEdge) */
1901     ownerSetHouseEdge(990);
1902     /* init 10,000 = 1% */
1903     ownerSetMaxProfitAsPercentOfHouse(10000);
1904     /* init min bet (0.1 ether) */
1905     ownerSetMinBet(100000000000000000);        
1906     /* init gas for oraclize */        
1907     gasForOraclize = 235000;  
1908     /* init gas price for callback (default 20 gwei) */
1909     oraclize_setCustomGasPrice(20000000000 wei);
1910   }
1911 
1912   /*
1913    * public function
1914    * player submit bet
1915    * only if game is active & bet is valid can query oraclize and set player vars     
1916    */
1917   function playerRollDice(uint rollUnder) public 
1918     payable
1919     gameIsActive
1920     betIsValid(msg.value, rollUnder)
1921   {
1922     /*
1923      * assign partially encrypted query to oraclize
1924      * only the apiKey is encrypted 
1925      * integer query is in plain text
1926      */                            
1927     bytes32 rngId = oraclize_query("nested", "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":\"a7527e4d-e83e-419a-a56e-1133b30acac1\",\"n\":1,\"min\":1,\"max\":100,\"replacement\":true,\"base\":10${[identity] \"}\"},\"id\":1${[identity] \"}\"}']", gasForOraclize);
1928           
1929     /* map bet id to this oraclize query */
1930     playerBetId[rngId] = rngId;
1931     /* map player lucky number to this oraclize query */
1932     playerNumber[rngId] = rollUnder;
1933     /* map value of wager to this oraclize query */
1934     playerBetValue[rngId] = msg.value;
1935     /* map player address to this oraclize query */
1936     playerAddress[rngId] = msg.sender;
1937     /* safely map player profit to this oraclize query */                     
1938     playerProfit[rngId] = ((((msg.value * (100-(safeSub(rollUnder,1)))) / (safeSub(rollUnder,1))+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;        
1939     /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
1940     maxPendingPayouts = safeAdd(maxPendingPayouts, playerProfit[rngId]);
1941     /* check contract can payout on win */
1942     if(maxPendingPayouts >= contractBalance) throw;
1943     /* provides accurate numbers for web3 and allows for manual refunds in case of no oraclize __callback */
1944     LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);          
1945   }   
1946 
1947   /*
1948    * semi-public function - only oraclize can call
1949    */
1950   /*TLSNotary for oraclize call */
1951 function __callback(bytes32 myid, string result, bytes proof) public   
1952   onlyOraclize
1953   payoutsAreActive
1954 {
1955     /* player address mapped to query id does not exist */
1956     if (playerAddress[myid]==0x0) throw;
1957 
1958     /* keep oraclize honest by retrieving the serialNumber from random.org result */
1959     var sl_result = result.toSlice();
1960     sl_result.beyond("[".toSlice()).until("]".toSlice());
1961     uint serialNumberOfResult = parseInt(sl_result.split(', '.toSlice()).toString());          
1962 
1963     /* map random result to player */
1964     playerRandomResult[myid] = parseInt(sl_result.beyond("[".toSlice()).until("]".toSlice()).toString());
1965 
1966     /* 
1967      * produce integer bounded to 1-100 inclusive
1968      * via sha3 result from random.org and proof (IPFS address of TLSNotary proof)
1969      */
1970     playerDieResult[myid] = uint(sha3(playerRandomResult[myid], proof)) % 100 + 1;        
1971     
1972     /* get the playerAddress for this query id */
1973     playerTempAddress[myid] = playerAddress[myid];
1974     /* delete playerAddress for this query id */
1975     delete playerAddress[myid];
1976 
1977     /* map the playerProfit for this query id */
1978     playerTempReward[myid] = playerProfit[myid];
1979     /* set playerProfit for this query id to 0 */
1980     playerProfit[myid] = 0; 
1981 
1982     /* safely reduce maxPendingPayouts liability */
1983     maxPendingPayouts = safeSub(maxPendingPayouts, playerTempReward[myid]);         
1984 
1985     /* map the playerBetValue for this query id */
1986     playerTempBetValue[myid] = playerBetValue[myid];
1987     /* set playerBetValue for this query id to 0 */
1988     playerBetValue[myid] = 0; 
1989 
1990     /* total number of bets */
1991     totalBets += 1;
1992 
1993     /* total wagered */
1994     totalWeiWagered += playerTempBetValue[myid];                                                         
1995 
1996     /*
1997      * refund
1998      * if result is 0 result is empty or no proof refund original bet value
1999      * if refund fails save refund value to playerPendingWithdrawals
2000      */
2001     if(playerDieResult[myid] == 0 || bytes(result).length == 0 || bytes(proof).length == 0 || playerRandomResult[myid] == 0) {
2002       LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 3, proof, playerRandomResult[myid]);            
2003 
2004       /*
2005       * send refund - external call to an untrusted contract
2006       * if send fails map refund value to playerPendingWithdrawals[address]
2007       * for withdrawal later via playerWithdrawPendingTransactions
2008       */
2009       if(!playerTempAddress[myid].send(playerTempBetValue[myid])) {
2010           LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 4, proof, playerRandomResult[myid]);              
2011           /* if send failed let player withdraw via playerWithdrawPendingTransactions */
2012           playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempBetValue[myid]);                        
2013       }
2014       return;
2015     }
2016 
2017     /*
2018      * pay winner
2019      * update contract balance to calculate new max bet
2020      * send reward
2021      * if send of reward fails save value to playerPendingWithdrawals        
2022      */
2023     if(playerDieResult[myid] < playerNumber[myid]) {
2024 
2025       /* safely reduce contract balance by player profit */
2026       contractBalance = safeSub(contractBalance, playerTempReward[myid]); 
2027 
2028       /* update total wei won */
2029       totalWeiWon = safeAdd(totalWeiWon, playerTempReward[myid]);              
2030 
2031       /* safely calculate payout via profit plus original wager */
2032       playerTempReward[myid] = safeAdd(playerTempReward[myid], playerTempBetValue[myid]); 
2033 
2034       LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 1, proof, playerRandomResult[myid]);                            
2035 
2036       /* update maximum profit */
2037       setMaxProfit();
2038       
2039       /*
2040       * send win - external call to an untrusted contract
2041       * if send fails map reward value to playerPendingWithdrawals[address]
2042       * for withdrawal later via playerWithdrawPendingTransactions
2043       */
2044       if(!playerTempAddress[myid].send(playerTempReward[myid])) {
2045         LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 2, proof, playerRandomResult[myid]);                   
2046         /* if send failed let player withdraw via playerWithdrawPendingTransactions */
2047         playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempReward[myid]);                               
2048       }
2049 
2050       return;
2051     }
2052 
2053     /*
2054     * no win
2055     * send 1 wei to a losing bet
2056     * update contract balance to calculate new max bet
2057     */
2058     if(playerDieResult[myid] >= playerNumber[myid]) {
2059       LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 0, proof, playerRandomResult[myid]);                                
2060 
2061       /*  
2062       *  safe adjust contractBalance
2063       *  setMaxProfit
2064       *  send 1 wei to losing bet
2065       */
2066       contractBalance = safeAdd(contractBalance, (playerTempBetValue[myid]-1));                                                                         
2067 
2068       /* update maximum profit */
2069       setMaxProfit(); 
2070 
2071       /*
2072       * send 1 wei - external call to an untrusted contract                  
2073       */
2074       if(!playerTempAddress[myid].send(1)){
2075           /* if send failed let player withdraw via playerWithdrawPendingTransactions */                
2076          playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], 1);                                
2077       }                                   
2078 
2079       return;
2080     }
2081 
2082   }
2083   
2084   /*
2085    * public function
2086    * in case of a failed refund or win send
2087    */
2088   function playerWithdrawPendingTransactions() public 
2089     payoutsAreActive
2090     returns (bool)
2091   {
2092       uint withdrawAmount = playerPendingWithdrawals[msg.sender];
2093       playerPendingWithdrawals[msg.sender] = 0;
2094       /* external call to untrusted contract */
2095       if (msg.sender.call.value(withdrawAmount)()) {
2096         return true;
2097       } else {
2098         /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
2099         /* player can try to withdraw again later */
2100         playerPendingWithdrawals[msg.sender] = withdrawAmount;
2101         return false;
2102       }
2103   }
2104 
2105   /* check for pending withdrawals  */
2106   function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
2107     return playerPendingWithdrawals[addressToCheck];
2108   }
2109 
2110   /*
2111    * internal function
2112    * sets max profit
2113    */
2114   function setMaxProfit() internal {
2115     maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxProfitDivisor;  
2116   } 
2117 
2118   /*
2119    * player check provably fair
2120    */
2121   function playerCheckProvablyFair(uint randomResult, bytes proof) public constant returns (uint) {
2122     return uint(sha3(randomResult, proof)) % 100 + 1;
2123   }     
2124 
2125   /*
2126    * owner/treasury address only functions
2127    */
2128   function ()
2129     payable
2130     onlyTreasury
2131   {
2132     /* safely update contract balance */
2133     contractBalance = safeAdd(contractBalance, msg.value);        
2134     /* update the maximum profit */
2135     setMaxProfit();
2136   }
2137 
2138   /* set gas price for oraclize callback */
2139   function ownerSetCallbackGasPrice(uint newCallbackGasPrice) public 
2140   onlyOwner
2141   {
2142     oraclize_setCustomGasPrice(newCallbackGasPrice);
2143   }
2144 
2145   /* set gas limit for oraclize query */
2146   function ownerSetOraclizeSafeGas(uint32 newSafeGasToOraclize) public 
2147   onlyOwner
2148   {
2149     gasForOraclize = newSafeGasToOraclize;
2150   }
2151 
2152   /* only owner adjust contract balance variable (only used for max profit calc) */
2153   function ownerUpdateContractBalance(uint newContractBalanceInWei) public 
2154   onlyOwner
2155   {        
2156     contractBalance = newContractBalanceInWei;
2157   }
2158 
2159   /* only owner address can set houseEdge */
2160   function ownerSetHouseEdge(uint newHouseEdge) public
2161   onlyOwner
2162   {
2163     houseEdge = newHouseEdge;
2164   }
2165 
2166   /* only owner address can set maxProfitAsPercentOfHouse */
2167   function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public 
2168   onlyOwner
2169   {
2170     /* restrict each bet to a maximum profit of 1% contractBalance */
2171     if(newMaxProfitAsPercent > 10000) throw;
2172     maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
2173     setMaxProfit();
2174   }
2175 
2176   /* only owner address can set minBet */
2177   function ownerSetMinBet(uint newMinimumBet) public 
2178   onlyOwner
2179   {
2180     minBet = newMinimumBet;
2181   }       
2182 
2183   /* only owner address can transfer ether */
2184   function ownerTransferEther(address sendTo, uint amount) public 
2185   onlyOwner
2186   {        
2187     /* safely update contract balance when sending out funds*/
2188     contractBalance = safeSub(contractBalance, amount);   
2189     /* update max profit */
2190     setMaxProfit();
2191     if(!sendTo.send(amount)) throw;
2192     LogOwnerTransfer(sendTo, amount);
2193   }
2194 
2195   /* only owner address can do manual refund
2196    * used only if bet placed + oraclize failed to __callback
2197    * filter LogBet by address and/or playerBetId:
2198    * LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
2199    * check the following logs do not exist for playerBetId and/or playerAddress[rngId] before refunding:
2200    * LogResult or LogRefund
2201    * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions 
2202    */
2203   function ownerRefundPlayer(bytes32 originalPlayerBetId, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public 
2204   onlyOwner
2205   {        
2206     /* safely reduce pendingPayouts by playerProfit[rngId] */
2207     maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
2208     /* send refund */
2209     if(!sendTo.send(originalPlayerBetValue)) throw;
2210     /* log refunds */
2211     LogRefund(originalPlayerBetId, sendTo, originalPlayerBetValue);
2212   }    
2213 
2214   /* only owner address can set emergency pause #1 */
2215   function ownerPauseGame(bool newStatus) public 
2216   onlyOwner
2217   {
2218     gamePaused = newStatus;
2219   }
2220 
2221   /* only owner address can set emergency pause #2 */
2222   function ownerPausePayouts(bool newPayoutStatus) public 
2223   onlyOwner
2224   {
2225     payoutsPaused = newPayoutStatus;
2226   } 
2227 
2228   /* only owner address can set treasury address */
2229   function ownerSetTreasury(address newTreasury) public 
2230   onlyOwner
2231   {
2232     treasury = newTreasury;
2233   }
2234 
2235   /* only owner address can set owner address */
2236   function ownerChangeOwner(address newOwner) public 
2237   onlyOwner
2238   {
2239     owner = newOwner;
2240   }
2241 
2242   /* only owner address can suicide - emergency */
2243   function ownerkill() public
2244   onlyOwner
2245   {
2246     suicide(owner);
2247   }
2248 }