1 pragma solidity ^0.4.11;
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
768         bytes memory nbytes = new bytes(1);
769         nbytes[0] = byte(_nbytes);
770         bytes memory unonce = new bytes(32);
771         bytes memory sessionKeyHash = new bytes(32);
772         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
773         assembly {
774             mstore(unonce, 0x20)
775             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
776             mstore(sessionKeyHash, 0x20)
777             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
778         }
779         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
780         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
781         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
782         return queryId;
783     }
784     
785     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
786         oraclize_randomDS_args[queryId] = commitment;
787     }
788     
789     mapping(bytes32=>bytes32) oraclize_randomDS_args;
790     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
791 
792     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
793         bool sigok;
794         address signer;
795         
796         bytes32 sigr;
797         bytes32 sigs;
798         
799         bytes memory sigr_ = new bytes(32);
800         uint offset = 4+(uint(dersig[3]) - 0x20);
801         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
802         bytes memory sigs_ = new bytes(32);
803         offset += 32 + 2;
804         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
805 
806         assembly {
807             sigr := mload(add(sigr_, 32))
808             sigs := mload(add(sigs_, 32))
809         }
810         
811         
812         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
813         if (address(sha3(pubkey)) == signer) return true;
814         else {
815             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
816             return (address(sha3(pubkey)) == signer);
817         }
818     }
819 
820     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
821         bool sigok;
822         
823         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
824         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
825         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
826         
827         bytes memory appkey1_pubkey = new bytes(64);
828         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
829         
830         bytes memory tosign2 = new bytes(1+65+32);
831         tosign2[0] = 1; //role
832         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
833         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
834         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
835         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
836         
837         if (sigok == false) return false;
838         
839         
840         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
841         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
842         
843         bytes memory tosign3 = new bytes(1+65);
844         tosign3[0] = 0xFE;
845         copyBytes(proof, 3, 65, tosign3, 1);
846         
847         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
848         copyBytes(proof, 3+65, sig3.length, sig3, 0);
849         
850         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
851         
852         return sigok;
853     }
854     
855     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
856         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
857         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
858         
859         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
860         if (proofVerified == false) throw;
861         
862         _;
863     }
864     
865     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
866         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
867         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
868         
869         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
870         if (proofVerified == false) return 2;
871         
872         return 0;
873     }
874     
875     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
876         bool match_ = true;
877         
878         for (var i=0; i<prefix.length; i++){
879             if (content[i] != prefix[i]) match_ = false;
880         }
881         
882         return match_;
883     }
884 
885     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
886         bool checkok;
887         
888         
889         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
890         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
891         bytes memory keyhash = new bytes(32);
892         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
893         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
894         if (checkok == false) return false;
895         
896         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
897         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
898         
899         
900         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
901         checkok = matchBytes32Prefix(sha256(sig1), result);
902         if (checkok == false) return false;
903         
904         
905         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
906         // This is to verify that the computed args match with the ones specified in the query.
907         bytes memory commitmentSlice1 = new bytes(8+1+32);
908         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
909         
910         bytes memory sessionPubkey = new bytes(64);
911         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
912         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
913         
914         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
915         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
916             delete oraclize_randomDS_args[queryId];
917         } else return false;
918         
919         
920         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
921         bytes memory tosign1 = new bytes(32+8+1+32);
922         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
923         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
924         if (checkok == false) return false;
925         
926         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
927         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
928             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
929         }
930         
931         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
932     }
933 
934     
935     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
936     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
937         uint minLength = length + toOffset;
938 
939         if (to.length < minLength) {
940             // Buffer too small
941             throw; // Should be a better way?
942         }
943 
944         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
945         uint i = 32 + fromOffset;
946         uint j = 32 + toOffset;
947 
948         while (i < (32 + fromOffset + length)) {
949             assembly {
950                 let tmp := mload(add(from, i))
951                 mstore(add(to, j), tmp)
952             }
953             i += 32;
954             j += 32;
955         }
956 
957         return to;
958     }
959     
960     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
961     // Duplicate Solidity's ecrecover, but catching the CALL return value
962     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
963         // We do our own memory management here. Solidity uses memory offset
964         // 0x40 to store the current end of memory. We write past it (as
965         // writes are memory extensions), but don't update the offset so
966         // Solidity will reuse it. The memory used here is only needed for
967         // this context.
968 
969         // FIXME: inline assembly can't access return values
970         bool ret;
971         address addr;
972 
973         assembly {
974             let size := mload(0x40)
975             mstore(size, hash)
976             mstore(add(size, 32), v)
977             mstore(add(size, 64), r)
978             mstore(add(size, 96), s)
979 
980             // NOTE: we can reuse the request memory because we deal with
981             //       the return code
982             ret := call(3000, 1, 0, size, 128, size, 32)
983             addr := mload(size)
984         }
985   
986         return (ret, addr);
987     }
988 
989     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
990     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
991         bytes32 r;
992         bytes32 s;
993         uint8 v;
994 
995         if (sig.length != 65)
996           return (false, 0);
997 
998         // The signature format is a compact form of:
999         //   {bytes32 r}{bytes32 s}{uint8 v}
1000         // Compact means, uint8 is not padded to 32 bytes.
1001         assembly {
1002             r := mload(add(sig, 32))
1003             s := mload(add(sig, 64))
1004 
1005             // Here we are loading the last 32 bytes. We exploit the fact that
1006             // 'mload' will pad with zeroes if we overread.
1007             // There is no 'mload8' to do this, but that would be nicer.
1008             v := byte(0, mload(add(sig, 96)))
1009 
1010             // Alternative solution:
1011             // 'byte' is not working due to the Solidity parser, so lets
1012             // use the second best option, 'and'
1013             // v := and(mload(add(sig, 65)), 255)
1014         }
1015 
1016         // albeit non-transactional signatures are not specified by the YP, one would expect it
1017         // to match the YP range of [27, 28]
1018         //
1019         // geth uses [0, 1] and some clients have followed. This might change, see:
1020         //  https://github.com/ethereum/go-ethereum/issues/2053
1021         if (v < 27)
1022           v += 27;
1023 
1024         if (v != 27 && v != 28)
1025             return (false, 0);
1026 
1027         return safer_ecrecover(hash, v, r, s);
1028     }
1029         
1030 }
1031 // </ORACLIZE_API>
1032 
1033 contract ERC20Basic {
1034     uint256 public totalSupply;
1035     function balanceOf(address who) public constant returns (uint256);
1036     function transfer(address to, uint256 value) public returns (bool);
1037     event Transfer(address indexed from, address indexed to, uint256 value);
1038 }
1039 
1040 contract ERC20 is ERC20Basic {
1041     function allowance(address owner, address spender) public constant returns (uint256);
1042     function transferFrom(address from, address to, uint256 value) public returns (bool);
1043     function approve(address spender, uint256 value) public returns (bool);
1044     event Approval(address indexed owner, address indexed spender, uint256 value);
1045 }
1046 
1047 library SafeMath {
1048     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
1049         uint256 c = a * b;
1050         assert(a == 0 || c / a == b);
1051         return c;
1052     }
1053 
1054     function div(uint256 a, uint256 b) internal constant returns (uint256) {
1055         // assert(b > 0); // Solidity automatically throws when dividing by 0
1056         uint256 c = a / b;
1057         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1058         return c;
1059     }
1060 
1061     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
1062         assert(b <= a);
1063         return a - b;
1064     }
1065 
1066     function add(uint256 a, uint256 b) internal constant returns (uint256) {
1067         uint256 c = a + b;
1068         assert(c >= a);
1069         return c;
1070     }
1071 }
1072 
1073 contract BasicToken is ERC20Basic {
1074     using SafeMath for uint256;
1075 
1076     mapping(address => uint256) balances;
1077 
1078     function transfer(address _to, uint256 _value) public returns (bool) {
1079         require(_to != address(0));
1080         require(_value <= balances[msg.sender]);
1081 
1082         // SafeMath.sub will throw if there is not enough balance.
1083         balances[msg.sender] = balances[msg.sender].sub(_value);
1084         balances[_to] = balances[_to].add(_value);
1085         Transfer(msg.sender, _to, _value);
1086         return true;
1087     }
1088 
1089     function balanceOf(address _owner) public constant returns (uint256 balance) {
1090         return balances[_owner];
1091     }
1092 
1093 }
1094 
1095 contract StandardToken is ERC20, BasicToken {
1096 
1097     mapping (address => mapping (address => uint256)) internal allowed;
1098 
1099 
1100     /**
1101      * @dev Transfer tokens from one address to another
1102      * @param _from address The address which you want to send tokens from
1103      * @param _to address The address which you want to transfer to
1104      * @param _value uint256 the amount of tokens to be transferred
1105      */
1106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1107         require(_to != address(0));
1108         require(_value <= balances[_from]);
1109         require(_value <= allowed[_from][msg.sender]);
1110 
1111         balances[_from] = balances[_from].sub(_value);
1112         balances[_to] = balances[_to].add(_value);
1113         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1114         Transfer(_from, _to, _value);
1115         return true;
1116     }
1117 
1118     /**
1119      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1120      *
1121      * Beware that changing an allowance with this method brings the risk that someone may use both the old
1122      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1123      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1124      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1125      * @param _spender The address which will spend the funds.
1126      * @param _value The amount of tokens to be spent.
1127      */
1128     function approve(address _spender, uint256 _value) public returns (bool) {
1129         allowed[msg.sender][_spender] = _value;
1130         Approval(msg.sender, _spender, _value);
1131         return true;
1132     }
1133 
1134     /**
1135      * @dev Function to check the amount of tokens that an owner allowed to a spender.
1136      * @param _owner address The address which owns the funds.
1137      * @param _spender address The address which will spend the funds.
1138      * @return A uint256 specifying the amount of tokens still available for the spender.
1139      */
1140     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
1141         return allowed[_owner][_spender];
1142     }
1143 
1144     /**
1145      * approve should be called when allowed[_spender] == 0. To increment
1146      * allowed value is better to use this function to avoid 2 calls (and wait until
1147      * the first transaction is mined)
1148      * From MonolithDAO Token.sol
1149      */
1150     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
1151         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1152         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1153         return true;
1154     }
1155 
1156     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
1157         uint oldValue = allowed[msg.sender][_spender];
1158         if (_subtractedValue > oldValue) {
1159             allowed[msg.sender][_spender] = 0;
1160         } else {
1161             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1162         }
1163         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1164         return true;
1165     }
1166 
1167 }
1168 
1169 contract Ownable {
1170     address public owner;
1171     address preIco;
1172     address ico;
1173 
1174 
1175     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1176 
1177 
1178     /**
1179      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1180      * account.
1181      */
1182     function Ownable() {
1183         owner = msg.sender;
1184     }
1185 
1186 
1187     /**
1188      * @dev Throws if called by any account other than the owner.
1189      */
1190     modifier onlyOwner() {
1191         require(msg.sender == owner || msg.sender == preIco || msg.sender == ico);
1192         _;
1193     }
1194 
1195 
1196     /**
1197      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1198      * @param newOwner The address to transfer ownership to.
1199      */
1200     function transferOwnership(address newOwner) onlyOwner public {
1201         require(newOwner != address(0));
1202         OwnershipTransferred(owner, newOwner);
1203         owner = newOwner;
1204     }
1205 
1206     function setPreIco(address _preIco) onlyOwner public {
1207         require(_preIco != address(0));
1208         preIco = _preIco;
1209     }
1210 
1211     function setICO(address _ico) onlyOwner public {
1212         require(_ico != address(0));
1213         ico = _ico;
1214     }
1215 
1216 }
1217 
1218 
1219 // TODO: СЌС‚Рѕ РјРѕРЅРµС‚Р°
1220 contract MintableToken is StandardToken, Ownable {
1221 
1222     uint256 limit;
1223     uint256 limitPreico;
1224 
1225     string public constant name = "Satoshi Brewery Limited";
1226     string public constant symbol = "SBL";
1227     uint8 public constant decimals = 1;
1228 
1229     event Mint(address indexed to, uint256 amount);
1230     event MintFinished();
1231 
1232     bool public mintingFinished = false;
1233 
1234 
1235     modifier canMint() {
1236         require(!mintingFinished);
1237         _;
1238     }
1239 
1240     function MintableToken() {
1241         limit = 100000000;
1242         limitPreico = 2700000;
1243     }
1244 
1245     function mintPreico(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
1246         require(totalSupply.add(_amount) <= limitPreico);
1247 
1248         totalSupply = totalSupply.add(_amount);
1249         balances[_to] = balances[_to].add(_amount);
1250         Mint(_to, _amount);
1251         Transfer(0x0, _to, _amount);
1252         return true;
1253     }
1254 
1255     /**
1256      * @dev Function to mint tokens
1257      * @param _to The address that will receive the minted tokens.
1258      * @param _amount The amount of tokens to mint.
1259      * @return A boolean that indicates if the operation was successful.
1260      */
1261     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
1262         require(totalSupply.add(_amount) <= limit);
1263 
1264         totalSupply = totalSupply.add(_amount);
1265         balances[_to] = balances[_to].add(_amount);
1266         Mint(_to, _amount);
1267         Transfer(0x0, _to, _amount);
1268         return true;
1269     }
1270 
1271     /**
1272      * @dev Function to stop minting new tokens.
1273      * @return True if the operation was successful.
1274      */
1275     function finishMinting() onlyOwner public returns (bool) {
1276         mintingFinished = true;
1277         MintFinished();
1278         return true;
1279     }
1280 }
1281 
1282 // TODO: Р­РўРћ PREICO
1283 contract PreIco is Ownable, usingOraclize {
1284     using SafeMath for uint256;
1285 
1286     uint256 public dollarCost;
1287     MintableToken public token;
1288 
1289     uint256 public startTime;
1290     uint256 public endTime;
1291     uint256 public dollarMultiplier = 1000000 * 1000 szabo;
1292 
1293     uint256 decimals = 1;
1294 
1295     // how many token units a buyer gets per wei
1296     uint256 public rate;
1297     uint256 public minimumCost = 12 finney;
1298 
1299     // amount of raised money in wei
1300     uint256 public weiRaised;
1301 
1302     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1303     event updatedEtherPrice(string price);
1304     event updatingViaOracle(string description);
1305 
1306     function PreIco(MintableToken _token) {
1307         token = _token;
1308         //        TODO: PRODUCTION
1309         startTime = 1508500800;
1310         endTime = 1511308799;
1311     }
1312 
1313     function setDollar(uint256 _dollarCost) onlyOwner {
1314         require(_dollarCost > 0);
1315         dollarCost = _dollarCost;
1316     }
1317 
1318     function __callback(bytes32 myid, string result) {
1319         if (msg.sender != oraclize_cbAddress()) throw;
1320         updatedEtherPrice(result);
1321         dollarCost = dollarMultiplier.div(parseInt(result, 3));
1322     }
1323 
1324     function updatePrice() payable {
1325         if (oraclize_getPrice("URL") > this.balance) {
1326             updatingViaOracle("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1327         } else {
1328             updatingViaOracle("Oraclize query was sent, standing by for the answer..");
1329             oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.[0]");
1330         }
1331     }
1332 
1333     function getRate() internal constant returns (uint256) {
1334         return dollarCost.mul(67).div(100);
1335     }
1336 
1337     // fallback function can be used to buy tokens
1338     function () payable {
1339         require(!hasEnded());
1340         require(msg.value >= minimumCost);
1341         require(validPurchase(msg.value));
1342 
1343         uint256 weiAmount = msg.value;
1344         rate = getRate();
1345 
1346         // calculate token amount to be created
1347         uint256 tokens = weiAmount.div(rate);
1348 
1349         // update state
1350         weiRaised = weiRaised.add(weiAmount);
1351 
1352         token.mintPreico(msg.sender, tokens.mul(10 ** decimals));
1353         TokenPurchase(msg.sender, msg.sender, weiAmount, tokens);
1354 
1355         forwardFunds(msg.value);
1356     }
1357 
1358     // send ether to the fund collection wallet
1359     // override to create custom fund forwarding mechanisms
1360     function forwardFunds(uint256 value) internal {
1361         owner.transfer(value);
1362     }
1363 
1364     function hasEnded() public constant returns (bool) {
1365         return now > endTime;
1366     }
1367 
1368     function validPurchase(uint256 value) internal constant returns (bool) {
1369         bool nonZeroPurchase = value != 0;
1370         return nonZeroPurchase;
1371     }
1372 }
1373 
1374 // TODO: Р­РўРћ ICO
1375 contract ICO is Ownable, usingOraclize {
1376     using SafeMath for uint256;
1377 
1378     address[] investorsArray;
1379     uint256 public dollarCost;
1380 
1381     PreIco public preICO;
1382     MintableToken public token;
1383 
1384     struct Investor {
1385     uint256 amount;
1386     bool isBack;
1387     }
1388 
1389     mapping (address => Investor) public investors;
1390 
1391     uint256 public startTime;
1392     uint256 public endTime;
1393 
1394     // TODO: time variables
1395     uint256 public secondTime;
1396     uint256 public thirdTime;
1397     uint256 public fourthTime;
1398     uint256 public fifthTime;
1399     uint256 public sixthTime;
1400     uint256 public seventhTime;
1401     uint256 public eighthTime;
1402     uint256 public ninthTime;
1403     uint256 public tenthTime;
1404     uint256 public eleventhTime;
1405 
1406     uint256 decimals = 1;
1407     uint256 public dollarMultiplier = 1000000 * 1000 szabo;
1408 
1409     // how many token units a buyer gets per wei
1410     uint256 public rate;
1411     uint256 public goal;
1412     uint256 public minimumCost = 100 finney;
1413 
1414     // amount of raised money in wei
1415     uint256 public weiRaised;
1416 
1417     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1418     event updatedEtherPrice(string price);
1419     event updatingViaOracle(string description);
1420 
1421     function ICO(MintableToken _token, PreIco _preIco) {
1422         require(_preIco != address(0));
1423         require(_token != address(0));
1424 
1425         token = _token;
1426         preICO = _preIco;
1427         goal = 7200000;
1428         //        TODO: PRODUCTION
1429         startTime = 1508500800;
1430         secondTime = 1511222399;
1431         thirdTime = 1511740800;
1432         fourthTime = 1512086399;
1433         fifthTime = 1512086400;
1434         sixthTime = 1512518399;
1435         seventhTime = 1512518400;
1436         eighthTime = 1512950399;
1437         ninthTime = 1512950400;
1438         tenthTime = 1513382399;
1439         eleventhTime = 1513382400;
1440         endTime = 1514419199;
1441     }
1442 
1443     function setDollar(uint256 _dollarCost) onlyOwner {
1444         require(_dollarCost > 0);
1445         dollarCost = _dollarCost;
1446     }
1447 
1448     function __callback(bytes32 myid, string result) {
1449         if (msg.sender != oraclize_cbAddress()) throw;
1450         updatedEtherPrice(result);
1451         dollarCost = dollarMultiplier.div(parseInt(result, 3));
1452     }
1453 
1454     function updatePrice() payable {
1455         if (oraclize_getPrice("URL") > this.balance) {
1456             updatingViaOracle("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1457         } else {
1458             updatingViaOracle("Oraclize query was sent, standing by for the answer..");
1459             oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.[0]");
1460         }
1461     }
1462 
1463     function getRate() internal constant returns (uint256) {
1464         if (startTime < now && now <= secondTime) {
1465             return dollarCost.mul(67).div(100);
1466         }
1467         if (thirdTime < now && now <= fourthTime) {
1468             return dollarCost.mul(98).div(100);
1469         }
1470         if (fifthTime < now && now <= sixthTime) {
1471             return dollarCost.mul(102).div(100);
1472         }
1473         if (seventhTime < now && now <= eighthTime) {
1474             return dollarCost.mul(105).div(100);
1475         }
1476         if (ninthTime < now && now <= tenthTime) {
1477             return dollarCost.mul(109).div(100);
1478         }
1479         if (eleventhTime < now && now <= endTime) {
1480             return dollarCost.mul(120).div(100);
1481         }
1482     }
1483 
1484     function getMoneyBack() public onlyOwner  {
1485         require(!goalReached());
1486         require(!hasFunded());
1487 
1488         for (uint256 i = 0; i < investorsArray.length; i++) {
1489             if (!investors[investorsArray[i]].isBack && investors[investorsArray[i]].amount > 0) {
1490                 investorsArray[i].transfer(investors[investorsArray[i]].amount);
1491                 investors[investorsArray[i]].amount = 0;
1492                 investors[investorsArray[i]].isBack = true;
1493             }
1494         }
1495     }
1496 
1497     function oneGetMoneyBack() {
1498         require(!goalReached());
1499         require(!hasFunded());
1500         require(investors[msg.sender].amount > 0);
1501         require(!investors[msg.sender].isBack);
1502 
1503         msg.sender.transfer(investors[msg.sender].amount);
1504         investors[msg.sender].amount = 0;
1505         investors[msg.sender].isBack = true;
1506     }
1507 
1508     function () payable {
1509         require(!hasEnded());
1510         require(!hasFunded());
1511         require(now > thirdTime);
1512         require(msg.value >= minimumCost);
1513         require(validPurchase(msg.value));
1514 
1515         uint256 weiAmount = msg.value;
1516         rate = getRate();
1517 
1518         // calculate token amount to be created
1519         uint256 tokens = weiAmount.div(rate);
1520 
1521         // update state
1522         weiRaised = weiRaised.add(weiAmount);
1523 
1524         token.mint(msg.sender, tokens.mul(10 ** decimals));
1525 
1526         investors[msg.sender].amount += msg.value;
1527         investorsArray.push(msg.sender);
1528 
1529         TokenPurchase(msg.sender, msg.sender, weiAmount, tokens);
1530     }
1531 
1532     // send ether to the fund collection wallet
1533     // override to create custom fund forwarding mechanisms
1534     function forwardFunds(uint256 amount) onlyOwner {
1535         require(amount > 0);
1536         require(hasEnded());
1537         require(hasFunded());
1538         require(this.balance - amount >= 0);
1539 
1540         owner.transfer(amount);
1541     }
1542 
1543     function hasEnded() public constant returns (bool) {
1544         return now > endTime;
1545     }
1546 
1547     function hasFunded() public constant returns (bool) {
1548         return weiRaised >= dollarCost.mul(goal).sub(preICO.weiRaised());
1549     }
1550 
1551     function validPurchase(uint256 value) internal constant returns (bool) {
1552         bool nonZeroPurchase = value != 0;
1553         return nonZeroPurchase;
1554     }
1555 
1556     function goalReached() public constant returns (bool) {
1557         return weiRaised >= dollarCost.mul(goal).mul(75).div(100);
1558     }
1559 }