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
1032 library strings {
1033     struct slice {
1034         uint _len;
1035         uint _ptr;
1036     }
1037 
1038     function memcpy(uint dest, uint src, uint len) private {
1039         // Copy word-length chunks while possible
1040         for(; len >= 32; len -= 32) {
1041             assembly {
1042                 mstore(dest, mload(src))
1043             }
1044             dest += 32;
1045             src += 32;
1046         }
1047 
1048         // Copy remaining bytes
1049         uint mask = 256 ** (32 - len) - 1;
1050         assembly {
1051             let srcpart := and(mload(src), not(mask))
1052             let destpart := and(mload(dest), mask)
1053             mstore(dest, or(destpart, srcpart))
1054         }
1055     }
1056 
1057     /*
1058      * @dev Returns a slice containing the entire string.
1059      * @param self The string to make a slice from.
1060      * @return A newly allocated slice containing the entire string.
1061      */
1062     function toSlice(string self) internal returns (slice) {
1063         uint ptr;
1064         assembly {
1065             ptr := add(self, 0x20)
1066         }
1067         return slice(bytes(self).length, ptr);
1068     }
1069 
1070     /*
1071      * @dev Returns the length of a null-terminated bytes32 string.
1072      * @param self The value to find the length of.
1073      * @return The length of the string, from 0 to 32.
1074      */
1075     function len(bytes32 self) internal returns (uint) {
1076         uint ret;
1077         if (self == 0)
1078             return 0;
1079         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1080             ret += 16;
1081             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1082         }
1083         if (self & 0xffffffffffffffff == 0) {
1084             ret += 8;
1085             self = bytes32(uint(self) / 0x10000000000000000);
1086         }
1087         if (self & 0xffffffff == 0) {
1088             ret += 4;
1089             self = bytes32(uint(self) / 0x100000000);
1090         }
1091         if (self & 0xffff == 0) {
1092             ret += 2;
1093             self = bytes32(uint(self) / 0x10000);
1094         }
1095         if (self & 0xff == 0) {
1096             ret += 1;
1097         }
1098         return 32 - ret;
1099     }
1100 
1101     /*
1102      * @dev Returns a slice containing the entire bytes32, interpreted as a
1103      *      null-termintaed utf-8 string.
1104      * @param self The bytes32 value to convert to a slice.
1105      * @return A new slice containing the value of the input argument up to the
1106      *         first null.
1107      */
1108     function toSliceB32(bytes32 self) internal returns (slice ret) {
1109         // Allocate space for `self` in memory, copy it there, and point ret at it
1110         assembly {
1111             let ptr := mload(0x40)
1112             mstore(0x40, add(ptr, 0x20))
1113             mstore(ptr, self)
1114             mstore(add(ret, 0x20), ptr)
1115         }
1116         ret._len = len(self);
1117     }
1118 
1119     /*
1120      * @dev Returns a new slice containing the same data as the current slice.
1121      * @param self The slice to copy.
1122      * @return A new slice containing the same data as `self`.
1123      */
1124     function copy(slice self) internal returns (slice) {
1125         return slice(self._len, self._ptr);
1126     }
1127 
1128     /*
1129      * @dev Copies a slice to a new string.
1130      * @param self The slice to copy.
1131      * @return A newly allocated string containing the slice's text.
1132      */
1133     function toString(slice self) internal returns (string) {
1134         var ret = new string(self._len);
1135         uint retptr;
1136         assembly { retptr := add(ret, 32) }
1137 
1138         memcpy(retptr, self._ptr, self._len);
1139         return ret;
1140     }
1141 
1142     /*
1143      * @dev Returns the length in runes of the slice. Note that this operation
1144      *      takes time proportional to the length of the slice; avoid using it
1145      *      in loops, and call `slice.empty()` if you only need to know whether
1146      *      the slice is empty or not.
1147      * @param self The slice to operate on.
1148      * @return The length of the slice in runes.
1149      */
1150     function len(slice self) internal returns (uint) {
1151         // Starting at ptr-31 means the LSB will be the byte we care about
1152         var ptr = self._ptr - 31;
1153         var end = ptr + self._len;
1154         for (uint len = 0; ptr < end; len++) {
1155             uint8 b;
1156             assembly { b := and(mload(ptr), 0xFF) }
1157             if (b < 0x80) {
1158                 ptr += 1;
1159             } else if(b < 0xE0) {
1160                 ptr += 2;
1161             } else if(b < 0xF0) {
1162                 ptr += 3;
1163             } else if(b < 0xF8) {
1164                 ptr += 4;
1165             } else if(b < 0xFC) {
1166                 ptr += 5;
1167             } else {
1168                 ptr += 6;
1169             }
1170         }
1171         return len;
1172     }
1173 
1174     /*
1175      * @dev Returns true if the slice is empty (has a length of 0).
1176      * @param self The slice to operate on.
1177      * @return True if the slice is empty, False otherwise.
1178      */
1179     function empty(slice self) internal returns (bool) {
1180         return self._len == 0;
1181     }
1182 
1183     /*
1184      * @dev Returns a positive number if `other` comes lexicographically after
1185      *      `self`, a negative number if it comes before, or zero if the
1186      *      contents of the two slices are equal. Comparison is done per-rune,
1187      *      on unicode codepoints.
1188      * @param self The first slice to compare.
1189      * @param other The second slice to compare.
1190      * @return The result of the comparison.
1191      */
1192     function compare(slice self, slice other) internal returns (int) {
1193         uint shortest = self._len;
1194         if (other._len < self._len)
1195             shortest = other._len;
1196 
1197         var selfptr = self._ptr;
1198         var otherptr = other._ptr;
1199         for (uint idx = 0; idx < shortest; idx += 32) {
1200             uint a;
1201             uint b;
1202             assembly {
1203                 a := mload(selfptr)
1204                 b := mload(otherptr)
1205             }
1206             if (a != b) {
1207                 // Mask out irrelevant bytes and check again
1208                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1209                 var diff = (a & mask) - (b & mask);
1210                 if (diff != 0)
1211                     return int(diff);
1212             }
1213             selfptr += 32;
1214             otherptr += 32;
1215         }
1216         return int(self._len) - int(other._len);
1217     }
1218 
1219     /*
1220      * @dev Returns true if the two slices contain the same text.
1221      * @param self The first slice to compare.
1222      * @param self The second slice to compare.
1223      * @return True if the slices are equal, false otherwise.
1224      */
1225     function equals(slice self, slice other) internal returns (bool) {
1226         return compare(self, other) == 0;
1227     }
1228 
1229     /*
1230      * @dev Extracts the first rune in the slice into `rune`, advancing the
1231      *      slice to point to the next rune and returning `self`.
1232      * @param self The slice to operate on.
1233      * @param rune The slice that will contain the first rune.
1234      * @return `rune`.
1235      */
1236     function nextRune(slice self, slice rune) internal returns (slice) {
1237         rune._ptr = self._ptr;
1238 
1239         if (self._len == 0) {
1240             rune._len = 0;
1241             return rune;
1242         }
1243 
1244         uint len;
1245         uint b;
1246         // Load the first byte of the rune into the LSBs of b
1247         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1248         if (b < 0x80) {
1249             len = 1;
1250         } else if(b < 0xE0) {
1251             len = 2;
1252         } else if(b < 0xF0) {
1253             len = 3;
1254         } else {
1255             len = 4;
1256         }
1257 
1258         // Check for truncated codepoints
1259         if (len > self._len) {
1260             rune._len = self._len;
1261             self._ptr += self._len;
1262             self._len = 0;
1263             return rune;
1264         }
1265 
1266         self._ptr += len;
1267         self._len -= len;
1268         rune._len = len;
1269         return rune;
1270     }
1271 
1272     /*
1273      * @dev Returns the first rune in the slice, advancing the slice to point
1274      *      to the next rune.
1275      * @param self The slice to operate on.
1276      * @return A slice containing only the first rune from `self`.
1277      */
1278     function nextRune(slice self) internal returns (slice ret) {
1279         nextRune(self, ret);
1280     }
1281 
1282     /*
1283      * @dev Returns the number of the first codepoint in the slice.
1284      * @param self The slice to operate on.
1285      * @return The number of the first codepoint in the slice.
1286      */
1287     function ord(slice self) internal returns (uint ret) {
1288         if (self._len == 0) {
1289             return 0;
1290         }
1291 
1292         uint word;
1293         uint len;
1294         uint div = 2 ** 248;
1295 
1296         // Load the rune into the MSBs of b
1297         assembly { word:= mload(mload(add(self, 32))) }
1298         var b = word / div;
1299         if (b < 0x80) {
1300             ret = b;
1301             len = 1;
1302         } else if(b < 0xE0) {
1303             ret = b & 0x1F;
1304             len = 2;
1305         } else if(b < 0xF0) {
1306             ret = b & 0x0F;
1307             len = 3;
1308         } else {
1309             ret = b & 0x07;
1310             len = 4;
1311         }
1312 
1313         // Check for truncated codepoints
1314         if (len > self._len) {
1315             return 0;
1316         }
1317 
1318         for (uint i = 1; i < len; i++) {
1319             div = div / 256;
1320             b = (word / div) & 0xFF;
1321             if (b & 0xC0 != 0x80) {
1322                 // Invalid UTF-8 sequence
1323                 return 0;
1324             }
1325             ret = (ret * 64) | (b & 0x3F);
1326         }
1327 
1328         return ret;
1329     }
1330 
1331     /*
1332      * @dev Returns the keccak-256 hash of the slice.
1333      * @param self The slice to hash.
1334      * @return The hash of the slice.
1335      */
1336     function keccak(slice self) internal returns (bytes32 ret) {
1337         assembly {
1338             ret := sha3(mload(add(self, 32)), mload(self))
1339         }
1340     }
1341 
1342     /*
1343      * @dev Returns true if `self` starts with `needle`.
1344      * @param self The slice to operate on.
1345      * @param needle The slice to search for.
1346      * @return True if the slice starts with the provided text, false otherwise.
1347      */
1348     function startsWith(slice self, slice needle) internal returns (bool) {
1349         if (self._len < needle._len) {
1350             return false;
1351         }
1352 
1353         if (self._ptr == needle._ptr) {
1354             return true;
1355         }
1356 
1357         bool equal;
1358         assembly {
1359             let len := mload(needle)
1360             let selfptr := mload(add(self, 0x20))
1361             let needleptr := mload(add(needle, 0x20))
1362             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1363         }
1364         return equal;
1365     }
1366 
1367     /*
1368      * @dev If `self` starts with `needle`, `needle` is removed from the
1369      *      beginning of `self`. Otherwise, `self` is unmodified.
1370      * @param self The slice to operate on.
1371      * @param needle The slice to search for.
1372      * @return `self`
1373      */
1374     function beyond(slice self, slice needle) internal returns (slice) {
1375         if (self._len < needle._len) {
1376             return self;
1377         }
1378 
1379         bool equal = true;
1380         if (self._ptr != needle._ptr) {
1381             assembly {
1382                 let len := mload(needle)
1383                 let selfptr := mload(add(self, 0x20))
1384                 let needleptr := mload(add(needle, 0x20))
1385                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1386             }
1387         }
1388 
1389         if (equal) {
1390             self._len -= needle._len;
1391             self._ptr += needle._len;
1392         }
1393 
1394         return self;
1395     }
1396 
1397     /*
1398      * @dev Returns true if the slice ends with `needle`.
1399      * @param self The slice to operate on.
1400      * @param needle The slice to search for.
1401      * @return True if the slice starts with the provided text, false otherwise.
1402      */
1403     function endsWith(slice self, slice needle) internal returns (bool) {
1404         if (self._len < needle._len) {
1405             return false;
1406         }
1407 
1408         var selfptr = self._ptr + self._len - needle._len;
1409 
1410         if (selfptr == needle._ptr) {
1411             return true;
1412         }
1413 
1414         bool equal;
1415         assembly {
1416             let len := mload(needle)
1417             let needleptr := mload(add(needle, 0x20))
1418             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1419         }
1420 
1421         return equal;
1422     }
1423 
1424     /*
1425      * @dev If `self` ends with `needle`, `needle` is removed from the
1426      *      end of `self`. Otherwise, `self` is unmodified.
1427      * @param self The slice to operate on.
1428      * @param needle The slice to search for.
1429      * @return `self`
1430      */
1431     function until(slice self, slice needle) internal returns (slice) {
1432         if (self._len < needle._len) {
1433             return self;
1434         }
1435 
1436         var selfptr = self._ptr + self._len - needle._len;
1437         bool equal = true;
1438         if (selfptr != needle._ptr) {
1439             assembly {
1440                 let len := mload(needle)
1441                 let needleptr := mload(add(needle, 0x20))
1442                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1443             }
1444         }
1445 
1446         if (equal) {
1447             self._len -= needle._len;
1448         }
1449 
1450         return self;
1451     }
1452 
1453     // Returns the memory address of the first byte of the first occurrence of
1454     // `needle` in `self`, or the first byte after `self` if not found.
1455     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1456         uint ptr;
1457         uint idx;
1458 
1459         if (needlelen <= selflen) {
1460             if (needlelen <= 32) {
1461                 // Optimized assembly for 68 gas per byte on short strings
1462                 assembly {
1463                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1464                     let needledata := and(mload(needleptr), mask)
1465                     let end := add(selfptr, sub(selflen, needlelen))
1466                     ptr := selfptr
1467                     loop:
1468                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1469                     ptr := add(ptr, 1)
1470                     jumpi(loop, lt(sub(ptr, 1), end))
1471                     ptr := add(selfptr, selflen)
1472                     exit:
1473                 }
1474                 return ptr;
1475             } else {
1476                 // For long needles, use hashing
1477                 bytes32 hash;
1478                 assembly { hash := sha3(needleptr, needlelen) }
1479                 ptr = selfptr;
1480                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1481                     bytes32 testHash;
1482                     assembly { testHash := sha3(ptr, needlelen) }
1483                     if (hash == testHash)
1484                         return ptr;
1485                     ptr += 1;
1486                 }
1487             }
1488         }
1489         return selfptr + selflen;
1490     }
1491 
1492     // Returns the memory address of the first byte after the last occurrence of
1493     // `needle` in `self`, or the address of `self` if not found.
1494     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1495         uint ptr;
1496 
1497         if (needlelen <= selflen) {
1498             if (needlelen <= 32) {
1499                 // Optimized assembly for 69 gas per byte on short strings
1500                 assembly {
1501                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1502                     let needledata := and(mload(needleptr), mask)
1503                     ptr := add(selfptr, sub(selflen, needlelen))
1504                     loop:
1505                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1506                     ptr := sub(ptr, 1)
1507                     jumpi(loop, gt(add(ptr, 1), selfptr))
1508                     ptr := selfptr
1509                     jump(exit)
1510                     ret:
1511                     ptr := add(ptr, needlelen)
1512                     exit:
1513                 }
1514                 return ptr;
1515             } else {
1516                 // For long needles, use hashing
1517                 bytes32 hash;
1518                 assembly { hash := sha3(needleptr, needlelen) }
1519                 ptr = selfptr + (selflen - needlelen);
1520                 while (ptr >= selfptr) {
1521                     bytes32 testHash;
1522                     assembly { testHash := sha3(ptr, needlelen) }
1523                     if (hash == testHash)
1524                         return ptr + needlelen;
1525                     ptr -= 1;
1526                 }
1527             }
1528         }
1529         return selfptr;
1530     }
1531 
1532     /*
1533      * @dev Modifies `self` to contain everything from the first occurrence of
1534      *      `needle` to the end of the slice. `self` is set to the empty slice
1535      *      if `needle` is not found.
1536      * @param self The slice to search and modify.
1537      * @param needle The text to search for.
1538      * @return `self`.
1539      */
1540     function find(slice self, slice needle) internal returns (slice) {
1541         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1542         self._len -= ptr - self._ptr;
1543         self._ptr = ptr;
1544         return self;
1545     }
1546 
1547     /*
1548      * @dev Modifies `self` to contain the part of the string from the start of
1549      *      `self` to the end of the first occurrence of `needle`. If `needle`
1550      *      is not found, `self` is set to the empty slice.
1551      * @param self The slice to search and modify.
1552      * @param needle The text to search for.
1553      * @return `self`.
1554      */
1555     function rfind(slice self, slice needle) internal returns (slice) {
1556         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1557         self._len = ptr - self._ptr;
1558         return self;
1559     }
1560 
1561     /*
1562      * @dev Splits the slice, setting `self` to everything after the first
1563      *      occurrence of `needle`, and `token` to everything before it. If
1564      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1565      *      and `token` is set to the entirety of `self`.
1566      * @param self The slice to split.
1567      * @param needle The text to search for in `self`.
1568      * @param token An output parameter to which the first token is written.
1569      * @return `token`.
1570      */
1571     function split(slice self, slice needle, slice token) internal returns (slice) {
1572         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1573         token._ptr = self._ptr;
1574         token._len = ptr - self._ptr;
1575         if (ptr == self._ptr + self._len) {
1576             // Not found
1577             self._len = 0;
1578         } else {
1579             self._len -= token._len + needle._len;
1580             self._ptr = ptr + needle._len;
1581         }
1582         return token;
1583     }
1584 
1585     /*
1586      * @dev Splits the slice, setting `self` to everything after the first
1587      *      occurrence of `needle`, and returning everything before it. If
1588      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1589      *      and the entirety of `self` is returned.
1590      * @param self The slice to split.
1591      * @param needle The text to search for in `self`.
1592      * @return The part of `self` up to the first occurrence of `delim`.
1593      */
1594     function split(slice self, slice needle) internal returns (slice token) {
1595         split(self, needle, token);
1596     }
1597 
1598     /*
1599      * @dev Splits the slice, setting `self` to everything before the last
1600      *      occurrence of `needle`, and `token` to everything after it. If
1601      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1602      *      and `token` is set to the entirety of `self`.
1603      * @param self The slice to split.
1604      * @param needle The text to search for in `self`.
1605      * @param token An output parameter to which the first token is written.
1606      * @return `token`.
1607      */
1608     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1609         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1610         token._ptr = ptr;
1611         token._len = self._len - (ptr - self._ptr);
1612         if (ptr == self._ptr) {
1613             // Not found
1614             self._len = 0;
1615         } else {
1616             self._len -= token._len + needle._len;
1617         }
1618         return token;
1619     }
1620 
1621     /*
1622      * @dev Splits the slice, setting `self` to everything before the last
1623      *      occurrence of `needle`, and returning everything after it. If
1624      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1625      *      and the entirety of `self` is returned.
1626      * @param self The slice to split.
1627      * @param needle The text to search for in `self`.
1628      * @return The part of `self` after the last occurrence of `delim`.
1629      */
1630     function rsplit(slice self, slice needle) internal returns (slice token) {
1631         rsplit(self, needle, token);
1632     }
1633 
1634     /*
1635      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1636      * @param self The slice to search.
1637      * @param needle The text to search for in `self`.
1638      * @return The number of occurrences of `needle` found in `self`.
1639      */
1640     function count(slice self, slice needle) internal returns (uint count) {
1641         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1642         while (ptr <= self._ptr + self._len) {
1643             count++;
1644             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1645         }
1646     }
1647 
1648     /*
1649      * @dev Returns True if `self` contains `needle`.
1650      * @param self The slice to search.
1651      * @param needle The text to search for in `self`.
1652      * @return True if `needle` is found in `self`, false otherwise.
1653      */
1654     function contains(slice self, slice needle) internal returns (bool) {
1655         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1656     }
1657 
1658     /*
1659      * @dev Returns a newly allocated string containing the concatenation of
1660      *      `self` and `other`.
1661      * @param self The first slice to concatenate.
1662      * @param other The second slice to concatenate.
1663      * @return The concatenation of the two strings.
1664      */
1665     function concat(slice self, slice other) internal returns (string) {
1666         var ret = new string(self._len + other._len);
1667         uint retptr;
1668         assembly { retptr := add(ret, 32) }
1669         memcpy(retptr, self._ptr, self._len);
1670         memcpy(retptr + self._len, other._ptr, other._len);
1671         return ret;
1672     }
1673 
1674     /*
1675      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1676      *      newly allocated string.
1677      * @param self The delimiter to use.
1678      * @param parts A list of slices to join.
1679      * @return A newly allocated string containing all the slices in `parts`,
1680      *         joined with `self`.
1681      */
1682     function join(slice self, slice[] parts) internal returns (string) {
1683         if (parts.length == 0)
1684             return "";
1685 
1686         uint len = self._len * (parts.length - 1);
1687         for(uint i = 0; i < parts.length; i++)
1688             len += parts[i]._len;
1689 
1690         var ret = new string(len);
1691         uint retptr;
1692         assembly { retptr := add(ret, 32) }
1693 
1694         for(i = 0; i < parts.length; i++) {
1695             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1696             retptr += parts[i]._len;
1697             if (i < parts.length - 1) {
1698                 memcpy(retptr, self._ptr, self._len);
1699                 retptr += self._len;
1700             }
1701         }
1702 
1703         return ret;
1704     }
1705 }
1706 
1707 contract ERC20 {
1708 
1709     uint public totalSupply;
1710     
1711     function totalSupply() public constant returns(uint totalSupply);
1712 
1713     function balanceOf(address who) public constant returns(uint256);
1714 
1715     function allowance(address owner, address spender) public constant returns(uint);
1716 
1717     function transferFrom(address from, address to, uint value) public returns(bool ok);
1718 
1719     function approve(address spender, uint value) public returns(bool ok);
1720 
1721     function transfer(address to, uint value) returns(bool ok);
1722 
1723     event Transfer(address indexed from, address indexed to, uint value);
1724 
1725     event Approval(address indexed owner, address indexed spender, uint value);
1726 
1727 }
1728 
1729 contract BAF is ERC20,usingOraclize
1730 {
1731     using strings
1732     for * ;
1733     
1734     address[] public addresses; // memory array to store all the address data who hold token
1735 
1736     // Name of the token
1737     string public constant name = "BAF";
1738 
1739     // Symbol of token
1740     string public constant symbol = "BAF";
1741 
1742     uint public decimals = 4;
1743     uint public totalSupply = 5000000000 *10**decimals ; // total supply 5 billion
1744 
1745     uint public token_price = 20; // 1 token = 20 cents
1746    
1747     mapping(address => uint) balances;
1748     
1749 
1750     bool pre_Sale = true;
1751 
1752     //ico startdate enddate;
1753     uint256 startdate;
1754     uint256 enddate;
1755 
1756     bool halted = false;
1757     
1758     bool ico_ended = false;
1759 
1760     mapping(address => mapping(address => uint)) allowed;
1761 
1762     address owner;
1763     
1764     uint256 one_ether_usd_price;
1765     
1766     mapping(address => address) public userStructs;
1767     
1768     event Price(string,uint);
1769     
1770     event Message(string);
1771     
1772     uint no_of_token;
1773   
1774     mapping (address => bool) reward;         // mapping to store user reward status
1775   
1776     mapping(bytes32 => address) userAddress; // mapping to store user address
1777     mapping(address => uint) uservalue;      // mapping to store user value
1778     mapping(bytes32 => bytes32) userqueryID; // mapping to store user oracalize query id
1779 
1780     
1781        // Functions with this modifier can only be executed by the owner
1782     modifier onlyOwner() {
1783         if (msg.sender != owner) {
1784             throw;
1785         }
1786         _;
1787     }
1788     
1789       // called by the owner on emergency, triggers stopped state
1790   function halt() external onlyOwner {
1791     halted = true;
1792   }
1793 
1794   // called by the owner on end of emergency, returns to normal state
1795   function unhalt() external onlyOwner {
1796     halted = false;
1797   }
1798     
1799     function BAF() public
1800     {
1801         owner = msg.sender;
1802         balances[address(this)] = totalSupply;
1803     }
1804     //
1805     //owner can call this function anytime , ico will run for 6 months
1806     function start_ico() external onlyOwner
1807     {
1808         pre_Sale = false;
1809         
1810         token_price = 40; // 1 token = 40 cents
1811         
1812         startdate = now;
1813         
1814         enddate = now + 180 days; // 6 month
1815        
1816     }
1817     // function to be called by owner to burn the remaing token and end the ico to be pressed only once for ending ICO
1818     function end_ICO() external onlyOwner
1819     {
1820         ico_ended = true;
1821         burnTokens();
1822         
1823     }
1824     
1825     function burnTokens() private 
1826     {
1827         uint soldToken = totalSupply - balances[address(this)];
1828         balances[owner] = (45 * soldToken) / 100;
1829         totalSupply = soldToken + balances[owner];
1830         balances[address(this)] = 0;
1831         Transfer(address(this),owner,balances[owner]);
1832     }
1833     
1834     function totalSupply() public constant returns(uint) {
1835        return totalSupply;
1836     }
1837    
1838      // unnamed function whenever any one sends ether to this smart contract address it wil fall in this
1839     //function which is payable
1840     function() public payable {
1841         if (!halted && !ico_ended) {
1842             if (pre_Sale && msg.sender != owner) {
1843                 bytes32 ID2 = oraclize_query("URL", "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
1844                 userAddress[ID2] = msg.sender;
1845                 uservalue[msg.sender] = msg.value;
1846 
1847                 userqueryID[ID2] = ID2;
1848             } else if (!pre_Sale) {
1849                 if (msg.sender != owner && now >= startdate && now <= enddate) {
1850                     bytes32 ID = oraclize_query("URL", "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
1851                     userAddress[ID] = msg.sender;
1852                     uservalue[msg.sender] = msg.value;
1853                     userqueryID[ID] = ID;
1854                 } else if (msg.sender != owner && now > enddate) {
1855                     revert();
1856                 }
1857 
1858             }
1859 
1860         } else {
1861             revert();
1862         }
1863 
1864     }
1865     
1866      // callback function of oracalize which is called when oracalize query return result
1867     function __callback(bytes32 myid, string result) {
1868         if (msg.sender != oraclize_cbAddress()) {
1869             // just to be sure the calling address is the Oraclize authorized one
1870             throw;
1871         }
1872         if (userqueryID[myid] == myid) {
1873 
1874             var s = result.toSlice();
1875 
1876             strings.slice memory part;
1877             uint finanl_price_ = stringToUint(s.split(".".toSlice()).toString());
1878             uint no_of_token = ((finanl_price_ * uservalue[userAddress[myid]]) * 10 ** decimals) / (token_price *
1879                 10 ** 16);
1880             if(balances[address(this)] >= no_of_token)
1881             {
1882                 balances[address(this)] -= no_of_token;
1883                 balances[userAddress[myid]] += no_of_token;
1884                 Transfer(address(this),userAddress[myid], no_of_token);
1885                 check_array_add(userAddress[myid]);
1886             }
1887             else
1888             revert();
1889         }
1890 
1891     }
1892 
1893     //Below function will convert string to integer removing decimal
1894     function stringToUint(string s) pure private returns(uint result) {
1895         bytes memory b = bytes(s);
1896         uint i;
1897         result = 0;
1898         for (i = 0; i < b.length; i++) {
1899             uint c = uint(b[i]);
1900 
1901             if (c >= 48 && c <= 57) {
1902                 result = result * 10 + (c - 48);
1903                 // usd_price=res2ult;
1904             }
1905         }
1906     }
1907 
1908     
1909       // erc20 function to return balance of give address
1910     function balanceOf(address sender) public constant returns(uint256 balance) {
1911         return balances[sender];
1912     }
1913 
1914     // Transfer the balance from one account to another account
1915     function transfer(address _to, uint256 _amount) public returns(bool success) {
1916         
1917         if (balances[msg.sender] >= _amount &&
1918             _amount > 0 &&
1919             balances[_to] + _amount > balances[_to]) {
1920             balances[msg.sender] -= _amount;
1921             balances[_to] += _amount;
1922             Transfer(msg.sender, _to, _amount);
1923             check_array_add(_to);
1924             return true;
1925         } else {
1926             return false;
1927         }
1928     }
1929 
1930     // Send _value amount of tokens from address _from to address _to
1931     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
1932     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
1933     // fees in sub-currencies; the command should fail unless the _from account has
1934     // deliberately authorized the sender of the message via some mechanism; we propose
1935     // these standardized APIs for approval:
1936 
1937     function transferFrom(
1938         address _from,
1939         address _to,
1940         uint256 _amount
1941     )  public returns(bool success) {
1942         if (balances[_from] >= _amount &&
1943             allowed[_from][msg.sender] >= _amount &&
1944             _amount > 0 &&
1945             balances[_to] + _amount > balances[_to]) {
1946             balances[_from] -= _amount;
1947             allowed[_from][msg.sender] -= _amount;
1948             balances[_to] += _amount;
1949             Transfer(_from, _to, _amount);
1950             return true;
1951         } else {
1952             return false;
1953         }
1954     }
1955     
1956     function transferby(
1957         address _from,
1958         address _to,
1959         uint256 _amount
1960     ) public onlyOwner returns(bool success) {
1961         if (balances[_from] >= _amount &&
1962             _amount > 0 &&
1963             balances[_to] + _amount > balances[_to]) {
1964                  
1965             balances[_from] -= _amount;
1966             balances[_to] += _amount;
1967             Transfer(_from, _to, _amount);
1968             return true;
1969         } else {
1970             return false;
1971         }
1972     }
1973 
1974     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
1975     // If this function is called again it overwrites the current allowance with _value.
1976     function approve(address _spender, uint256 _amount) public returns(bool success) {
1977         allowed[msg.sender][_spender] = _amount;
1978         Approval(msg.sender, _spender, _amount);
1979         return true;
1980     }
1981 
1982     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
1983         return allowed[_owner][_spender];
1984     }
1985 
1986     // Failsafe drain only owner can call this function
1987     function drain() public onlyOwner {
1988         owner.transfer(this.balance);
1989     }
1990 
1991     // function to transfer ownership to new address
1992     function transfer_ownership(address to) public onlyOwner {
1993         owner = to;
1994         balances[owner] = balances[msg.sender];
1995         balances[msg.sender] = 0;
1996     }
1997     
1998    
1999       // function used in Reward contract to know address of token holder
2000     function getAddress(uint i) public constant returns(address) {
2001         return addresses[i];
2002     }
2003     // function used in Reward contract to get to know the address array length
2004     function getarray_length() public constant returns(uint) {
2005 
2006         return addresses.length;
2007 
2008     }
2009    
2010 
2011     function check_array_add(address _to) private {
2012         if (addresses.length > 0) {
2013             if (userStructs[_to] != _to) {
2014                 userStructs[_to] = _to;
2015                 addresses.push(_to);
2016             }
2017         } else {
2018             userStructs[_to] = _to;
2019             addresses.push(_to);
2020         }
2021     }
2022     
2023 }
2024 
2025 contract BafREWARD {
2026     
2027     BAF baf; // contract instance
2028     address[] users;
2029     event Log(string, uint);
2030     address owner;
2031     mapping (address => bool) reward;         // mapping to store user reward status
2032     mapping (address => uint) snapshot_bal;
2033     address[] public addresses;
2034     uint public totalSupply;
2035 
2036     uint256 ether_profit;
2037 
2038     uint256 profit_per_token;
2039 
2040     mapping(address => address) public userStructs;
2041 
2042     uint256 holder_token_balance;
2043     uint256 holder_profit;
2044 
2045     event Message(uint256 holder_profit);
2046     event Transfer(address indexed_from, address indexed_to, uint value);
2047 
2048     // modifier for owner
2049     modifier onlyOwner() {
2050         if (msg.sender != owner) {
2051             throw;
2052         }
2053         _;
2054     }
2055     // constructor which takes address of smart contract
2056     function BafREWARD(address baf_contract_address) public {
2057         owner = msg.sender;
2058         baf = BAF(baf_contract_address);
2059         totalSupply = baf.totalSupply() ;
2060        
2061     }
2062     // unnamed function which takes ether
2063     function() public payable {
2064 
2065         if (msg.sender == owner) {
2066   
2067             ether_profit = msg.value;
2068             profit_per_token = ether_profit / totalSupply;
2069 
2070             Message(profit_per_token);
2071             snapshot_all_address();
2072 
2073         }
2074         else
2075         revert();
2076 
2077     }
2078 
2079     
2080     function snapshot_all_address() private
2081     {
2082         uint array_length = baf.getarray_length();
2083         for(uint i = 0;i<array_length;i++)
2084         {
2085             addresses.push(baf.getAddress(i));
2086             reward[addresses[i]] = true;
2087             snapshot_bal[addresses[i]] = baf.balanceOf(addresses[i]);
2088           
2089         }
2090         
2091     }
2092    
2093      // function to get dividendend on requesting
2094     function Request_Dividends() public payable
2095     {
2096          if(!getRewardStatus(msg.sender)) revert();
2097  
2098         holder_token_balance = snapshot_bal[msg.sender];
2099         holder_profit = holder_token_balance * profit_per_token;
2100         msg.sender.transfer(holder_profit);
2101         Transfer(owner, msg.sender, holder_profit); // Notify anyone listening that this transfer took place
2102         setRewardStatus(msg.sender, false);
2103     }
2104     
2105     //if the contract has any ether this method is called by the owner and all the ether will be transferred to owners account
2106     function drain() public onlyOwner {
2107         owner.transfer(this.balance) ;
2108     }
2109     
2110      // used in reward contract
2111       function getRewardStatus(address addr) view private returns (bool isReward) {
2112         return reward[addr];
2113     }
2114     // used in reward contract
2115     function setRewardStatus(address addr, bool status) private  {
2116         reward[addr] = status;
2117     }
2118 
2119 }