1 pragma solidity ^0.4.16;
2 //import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
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
33 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
34 
35 contract OraclizeI {
36     address public cbAddress;
37     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
39     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
40     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
41     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
42     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
43     function getPrice(string _datasource) returns (uint _dsprice);
44     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
45     function useCoupon(string _coupon);
46     function setProofType(byte _proofType);
47     function setConfig(bytes32 _config);
48     function setCustomGasPrice(uint _gasPrice);
49     function randomDS_getSessionPubKeyHash() returns(bytes32);
50 }
51 contract OraclizeAddrResolverI {
52     function getAddress() returns (address _addr);
53 }
54 contract usingOraclize {
55     uint constant day = 60*60*24;
56     uint constant week = 60*60*24*7;
57     uint constant month = 60*60*24*30;
58     byte constant proofType_NONE = 0x00;
59     byte constant proofType_TLSNotary = 0x10;
60     byte constant proofType_Android = 0x20;
61     byte constant proofType_Ledger = 0x30;
62     byte constant proofType_Native = 0xF0;
63     byte constant proofStorage_IPFS = 0x01;
64     uint8 constant networkID_auto = 0;
65     uint8 constant networkID_mainnet = 1;
66     uint8 constant networkID_testnet = 2;
67     uint8 constant networkID_morden = 2;
68     uint8 constant networkID_consensys = 161;
69 
70     OraclizeAddrResolverI OAR;
71 
72     OraclizeI oraclize;
73     modifier oraclizeAPI {
74         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
75             oraclize_setNetwork(networkID_auto);
76 
77         if(address(oraclize) != OAR.getAddress())
78             oraclize = OraclizeI(OAR.getAddress());
79 
80         _;
81     }
82     modifier coupon(string code){
83         oraclize = OraclizeI(OAR.getAddress());
84         oraclize.useCoupon(code);
85         _;
86     }
87 
88     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
89         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
90             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
91             oraclize_setNetworkName("eth_mainnet");
92             return true;
93         }
94         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
95             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
96             oraclize_setNetworkName("eth_ropsten3");
97             return true;
98         }
99         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
100             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
101             oraclize_setNetworkName("eth_kovan");
102             return true;
103         }
104         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
105             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
106             oraclize_setNetworkName("eth_rinkeby");
107             return true;
108         }
109         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
110             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
111             return true;
112         }
113         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
114             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
115             return true;
116         }
117         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
118             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
119             return true;
120         }
121         return false;
122     }
123 
124     function __callback(bytes32 myid, string result) {
125         __callback(myid, result, new bytes(0));
126     }
127     function __callback(bytes32 myid, string result, bytes proof) {
128     }
129 
130     function oraclize_useCoupon(string code) oraclizeAPI internal {
131         oraclize.useCoupon(code);
132     }
133 
134     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
135         return oraclize.getPrice(datasource);
136     }
137 
138     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
139         return oraclize.getPrice(datasource, gaslimit);
140     }
141 
142     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
143         uint price = oraclize.getPrice(datasource);
144         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
145         return oraclize.query.value(price)(0, datasource, arg);
146     }
147     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
148         uint price = oraclize.getPrice(datasource);
149         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
150         return oraclize.query.value(price)(timestamp, datasource, arg);
151     }
152     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
153         uint price = oraclize.getPrice(datasource, gaslimit);
154         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
155         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
156     }
157     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
158         uint price = oraclize.getPrice(datasource, gaslimit);
159         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
160         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
161     }
162     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
163         uint price = oraclize.getPrice(datasource);
164         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
165         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
166     }
167     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
168         uint price = oraclize.getPrice(datasource);
169         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
170         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
171     }
172     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
173         uint price = oraclize.getPrice(datasource, gaslimit);
174         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
175         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
176     }
177     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
178         uint price = oraclize.getPrice(datasource, gaslimit);
179         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
180         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
181     }
182     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
183         uint price = oraclize.getPrice(datasource);
184         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
185         bytes memory args = stra2cbor(argN);
186         return oraclize.queryN.value(price)(0, datasource, args);
187     }
188     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
189         uint price = oraclize.getPrice(datasource);
190         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
191         bytes memory args = stra2cbor(argN);
192         return oraclize.queryN.value(price)(timestamp, datasource, args);
193     }
194     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
195         uint price = oraclize.getPrice(datasource, gaslimit);
196         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
197         bytes memory args = stra2cbor(argN);
198         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
199     }
200     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
201         uint price = oraclize.getPrice(datasource, gaslimit);
202         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
203         bytes memory args = stra2cbor(argN);
204         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
205     }
206     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
207         string[] memory dynargs = new string[](1);
208         dynargs[0] = args[0];
209         return oraclize_query(datasource, dynargs);
210     }
211     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
212         string[] memory dynargs = new string[](1);
213         dynargs[0] = args[0];
214         return oraclize_query(timestamp, datasource, dynargs);
215     }
216     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
217         string[] memory dynargs = new string[](1);
218         dynargs[0] = args[0];
219         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
220     }
221     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
222         string[] memory dynargs = new string[](1);
223         dynargs[0] = args[0];
224         return oraclize_query(datasource, dynargs, gaslimit);
225     }
226 
227     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
228         string[] memory dynargs = new string[](2);
229         dynargs[0] = args[0];
230         dynargs[1] = args[1];
231         return oraclize_query(datasource, dynargs);
232     }
233     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
234         string[] memory dynargs = new string[](2);
235         dynargs[0] = args[0];
236         dynargs[1] = args[1];
237         return oraclize_query(timestamp, datasource, dynargs);
238     }
239     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
240         string[] memory dynargs = new string[](2);
241         dynargs[0] = args[0];
242         dynargs[1] = args[1];
243         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
244     }
245     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
246         string[] memory dynargs = new string[](2);
247         dynargs[0] = args[0];
248         dynargs[1] = args[1];
249         return oraclize_query(datasource, dynargs, gaslimit);
250     }
251     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
252         string[] memory dynargs = new string[](3);
253         dynargs[0] = args[0];
254         dynargs[1] = args[1];
255         dynargs[2] = args[2];
256         return oraclize_query(datasource, dynargs);
257     }
258     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
259         string[] memory dynargs = new string[](3);
260         dynargs[0] = args[0];
261         dynargs[1] = args[1];
262         dynargs[2] = args[2];
263         return oraclize_query(timestamp, datasource, dynargs);
264     }
265     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
266         string[] memory dynargs = new string[](3);
267         dynargs[0] = args[0];
268         dynargs[1] = args[1];
269         dynargs[2] = args[2];
270         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
271     }
272     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
273         string[] memory dynargs = new string[](3);
274         dynargs[0] = args[0];
275         dynargs[1] = args[1];
276         dynargs[2] = args[2];
277         return oraclize_query(datasource, dynargs, gaslimit);
278     }
279 
280     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
281         string[] memory dynargs = new string[](4);
282         dynargs[0] = args[0];
283         dynargs[1] = args[1];
284         dynargs[2] = args[2];
285         dynargs[3] = args[3];
286         return oraclize_query(datasource, dynargs);
287     }
288     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
289         string[] memory dynargs = new string[](4);
290         dynargs[0] = args[0];
291         dynargs[1] = args[1];
292         dynargs[2] = args[2];
293         dynargs[3] = args[3];
294         return oraclize_query(timestamp, datasource, dynargs);
295     }
296     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
297         string[] memory dynargs = new string[](4);
298         dynargs[0] = args[0];
299         dynargs[1] = args[1];
300         dynargs[2] = args[2];
301         dynargs[3] = args[3];
302         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
303     }
304     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
305         string[] memory dynargs = new string[](4);
306         dynargs[0] = args[0];
307         dynargs[1] = args[1];
308         dynargs[2] = args[2];
309         dynargs[3] = args[3];
310         return oraclize_query(datasource, dynargs, gaslimit);
311     }
312     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
313         string[] memory dynargs = new string[](5);
314         dynargs[0] = args[0];
315         dynargs[1] = args[1];
316         dynargs[2] = args[2];
317         dynargs[3] = args[3];
318         dynargs[4] = args[4];
319         return oraclize_query(datasource, dynargs);
320     }
321     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
322         string[] memory dynargs = new string[](5);
323         dynargs[0] = args[0];
324         dynargs[1] = args[1];
325         dynargs[2] = args[2];
326         dynargs[3] = args[3];
327         dynargs[4] = args[4];
328         return oraclize_query(timestamp, datasource, dynargs);
329     }
330     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
331         string[] memory dynargs = new string[](5);
332         dynargs[0] = args[0];
333         dynargs[1] = args[1];
334         dynargs[2] = args[2];
335         dynargs[3] = args[3];
336         dynargs[4] = args[4];
337         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
338     }
339     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
340         string[] memory dynargs = new string[](5);
341         dynargs[0] = args[0];
342         dynargs[1] = args[1];
343         dynargs[2] = args[2];
344         dynargs[3] = args[3];
345         dynargs[4] = args[4];
346         return oraclize_query(datasource, dynargs, gaslimit);
347     }
348     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
349         uint price = oraclize.getPrice(datasource);
350         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
351         bytes memory args = ba2cbor(argN);
352         return oraclize.queryN.value(price)(0, datasource, args);
353     }
354     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
355         uint price = oraclize.getPrice(datasource);
356         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
357         bytes memory args = ba2cbor(argN);
358         return oraclize.queryN.value(price)(timestamp, datasource, args);
359     }
360     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
361         uint price = oraclize.getPrice(datasource, gaslimit);
362         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
363         bytes memory args = ba2cbor(argN);
364         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
365     }
366     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
367         uint price = oraclize.getPrice(datasource, gaslimit);
368         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
369         bytes memory args = ba2cbor(argN);
370         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
371     }
372     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
373         bytes[] memory dynargs = new bytes[](1);
374         dynargs[0] = args[0];
375         return oraclize_query(datasource, dynargs);
376     }
377     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
378         bytes[] memory dynargs = new bytes[](1);
379         dynargs[0] = args[0];
380         return oraclize_query(timestamp, datasource, dynargs);
381     }
382     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
383         bytes[] memory dynargs = new bytes[](1);
384         dynargs[0] = args[0];
385         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
386     }
387     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
388         bytes[] memory dynargs = new bytes[](1);
389         dynargs[0] = args[0];
390         return oraclize_query(datasource, dynargs, gaslimit);
391     }
392 
393     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
394         bytes[] memory dynargs = new bytes[](2);
395         dynargs[0] = args[0];
396         dynargs[1] = args[1];
397         return oraclize_query(datasource, dynargs);
398     }
399     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
400         bytes[] memory dynargs = new bytes[](2);
401         dynargs[0] = args[0];
402         dynargs[1] = args[1];
403         return oraclize_query(timestamp, datasource, dynargs);
404     }
405     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
406         bytes[] memory dynargs = new bytes[](2);
407         dynargs[0] = args[0];
408         dynargs[1] = args[1];
409         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
410     }
411     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
412         bytes[] memory dynargs = new bytes[](2);
413         dynargs[0] = args[0];
414         dynargs[1] = args[1];
415         return oraclize_query(datasource, dynargs, gaslimit);
416     }
417     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
418         bytes[] memory dynargs = new bytes[](3);
419         dynargs[0] = args[0];
420         dynargs[1] = args[1];
421         dynargs[2] = args[2];
422         return oraclize_query(datasource, dynargs);
423     }
424     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
425         bytes[] memory dynargs = new bytes[](3);
426         dynargs[0] = args[0];
427         dynargs[1] = args[1];
428         dynargs[2] = args[2];
429         return oraclize_query(timestamp, datasource, dynargs);
430     }
431     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
432         bytes[] memory dynargs = new bytes[](3);
433         dynargs[0] = args[0];
434         dynargs[1] = args[1];
435         dynargs[2] = args[2];
436         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
437     }
438     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
439         bytes[] memory dynargs = new bytes[](3);
440         dynargs[0] = args[0];
441         dynargs[1] = args[1];
442         dynargs[2] = args[2];
443         return oraclize_query(datasource, dynargs, gaslimit);
444     }
445 
446     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
447         bytes[] memory dynargs = new bytes[](4);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         dynargs[2] = args[2];
451         dynargs[3] = args[3];
452         return oraclize_query(datasource, dynargs);
453     }
454     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
455         bytes[] memory dynargs = new bytes[](4);
456         dynargs[0] = args[0];
457         dynargs[1] = args[1];
458         dynargs[2] = args[2];
459         dynargs[3] = args[3];
460         return oraclize_query(timestamp, datasource, dynargs);
461     }
462     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
463         bytes[] memory dynargs = new bytes[](4);
464         dynargs[0] = args[0];
465         dynargs[1] = args[1];
466         dynargs[2] = args[2];
467         dynargs[3] = args[3];
468         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
469     }
470     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
471         bytes[] memory dynargs = new bytes[](4);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         dynargs[2] = args[2];
475         dynargs[3] = args[3];
476         return oraclize_query(datasource, dynargs, gaslimit);
477     }
478     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
479         bytes[] memory dynargs = new bytes[](5);
480         dynargs[0] = args[0];
481         dynargs[1] = args[1];
482         dynargs[2] = args[2];
483         dynargs[3] = args[3];
484         dynargs[4] = args[4];
485         return oraclize_query(datasource, dynargs);
486     }
487     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
488         bytes[] memory dynargs = new bytes[](5);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         dynargs[2] = args[2];
492         dynargs[3] = args[3];
493         dynargs[4] = args[4];
494         return oraclize_query(timestamp, datasource, dynargs);
495     }
496     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
497         bytes[] memory dynargs = new bytes[](5);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         dynargs[2] = args[2];
501         dynargs[3] = args[3];
502         dynargs[4] = args[4];
503         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
504     }
505     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506         bytes[] memory dynargs = new bytes[](5);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         dynargs[3] = args[3];
511         dynargs[4] = args[4];
512         return oraclize_query(datasource, dynargs, gaslimit);
513     }
514 
515     function oraclize_cbAddress() oraclizeAPI internal returns (address){
516         return oraclize.cbAddress();
517     }
518     function oraclize_setProof(byte proofP) oraclizeAPI internal {
519         return oraclize.setProofType(proofP);
520     }
521     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
522         return oraclize.setCustomGasPrice(gasPrice);
523     }
524     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
525         return oraclize.setConfig(config);
526     }
527 
528     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
529         return oraclize.randomDS_getSessionPubKeyHash();
530     }
531 
532     function getCodeSize(address _addr) constant internal returns(uint _size) {
533         assembly {
534             _size := extcodesize(_addr)
535         }
536     }
537 
538     function parseAddr(string _a) internal returns (address){
539         bytes memory tmp = bytes(_a);
540         uint160 iaddr = 0;
541         uint160 b1;
542         uint160 b2;
543         for (uint i=2; i<2+2*20; i+=2){
544             iaddr *= 256;
545             b1 = uint160(tmp[i]);
546             b2 = uint160(tmp[i+1]);
547             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
548             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
549             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
550             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
551             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
552             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
553             iaddr += (b1*16+b2);
554         }
555         return address(iaddr);
556     }
557 
558     function strCompare(string _a, string _b) internal returns (int) {
559         bytes memory a = bytes(_a);
560         bytes memory b = bytes(_b);
561         uint minLength = a.length;
562         if (b.length < minLength) minLength = b.length;
563         for (uint i = 0; i < minLength; i ++)
564             if (a[i] < b[i])
565                 return -1;
566             else if (a[i] > b[i])
567                 return 1;
568         if (a.length < b.length)
569             return -1;
570         else if (a.length > b.length)
571             return 1;
572         else
573             return 0;
574     }
575 
576     function indexOf(string _haystack, string _needle) internal returns (int) {
577         bytes memory h = bytes(_haystack);
578         bytes memory n = bytes(_needle);
579         if(h.length < 1 || n.length < 1 || (n.length > h.length))
580             return -1;
581         else if(h.length > (2**128 -1))
582             return -1;
583         else
584         {
585             uint subindex = 0;
586             for (uint i = 0; i < h.length; i ++)
587             {
588                 if (h[i] == n[0])
589                 {
590                     subindex = 1;
591                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
592                     {
593                         subindex++;
594                     }
595                     if(subindex == n.length)
596                         return int(i);
597                 }
598             }
599             return -1;
600         }
601     }
602 
603     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
604         bytes memory _ba = bytes(_a);
605         bytes memory _bb = bytes(_b);
606         bytes memory _bc = bytes(_c);
607         bytes memory _bd = bytes(_d);
608         bytes memory _be = bytes(_e);
609         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
610         bytes memory babcde = bytes(abcde);
611         uint k = 0;
612         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
613         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
614         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
615         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
616         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
617         return string(babcde);
618     }
619 
620     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
621         return strConcat(_a, _b, _c, _d, "");
622     }
623 
624     function strConcat(string _a, string _b, string _c) internal returns (string) {
625         return strConcat(_a, _b, _c, "", "");
626     }
627 
628     function strConcat(string _a, string _b) internal returns (string) {
629         return strConcat(_a, _b, "", "", "");
630     }
631 
632     // parseInt
633     function parseInt(string _a) internal returns (uint) {
634         return parseInt(_a, 0);
635     }
636 
637     // parseInt(parseFloat*10^_b)
638     function parseInt(string _a, uint _b) internal returns (uint) {
639         bytes memory bresult = bytes(_a);
640         uint mint = 0;
641         bool decimals = false;
642         for (uint i=0; i<bresult.length; i++){
643             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
644                 if (decimals){
645                    if (_b == 0) break;
646                     else _b--;
647                 }
648                 mint *= 10;
649                 mint += uint(bresult[i]) - 48;
650             } else if (bresult[i] == 46) decimals = true;
651         }
652         if (_b > 0) mint *= 10**_b;
653         return mint;
654     }
655 
656     function uint2str(uint i) internal returns (string){
657         if (i == 0) return "0";
658         uint j = i;
659         uint len;
660         while (j != 0){
661             len++;
662             j /= 10;
663         }
664         bytes memory bstr = new bytes(len);
665         uint k = len - 1;
666         while (i != 0){
667             bstr[k--] = byte(48 + i % 10);
668             i /= 10;
669         }
670         return string(bstr);
671     }
672 
673     function stra2cbor(string[] arr) internal returns (bytes) {
674             uint arrlen = arr.length;
675 
676             // get correct cbor output length
677             uint outputlen = 0;
678             bytes[] memory elemArray = new bytes[](arrlen);
679             for (uint i = 0; i < arrlen; i++) {
680                 elemArray[i] = (bytes(arr[i]));
681                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
682             }
683             uint ctr = 0;
684             uint cborlen = arrlen + 0x80;
685             outputlen += byte(cborlen).length;
686             bytes memory res = new bytes(outputlen);
687 
688             while (byte(cborlen).length > ctr) {
689                 res[ctr] = byte(cborlen)[ctr];
690                 ctr++;
691             }
692             for (i = 0; i < arrlen; i++) {
693                 res[ctr] = 0x5F;
694                 ctr++;
695                 for (uint x = 0; x < elemArray[i].length; x++) {
696                     // if there's a bug with larger strings, this may be the culprit
697                     if (x % 23 == 0) {
698                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
699                         elemcborlen += 0x40;
700                         uint lctr = ctr;
701                         while (byte(elemcborlen).length > ctr - lctr) {
702                             res[ctr] = byte(elemcborlen)[ctr - lctr];
703                             ctr++;
704                         }
705                     }
706                     res[ctr] = elemArray[i][x];
707                     ctr++;
708                 }
709                 res[ctr] = 0xFF;
710                 ctr++;
711             }
712             return res;
713         }
714 
715     function ba2cbor(bytes[] arr) internal returns (bytes) {
716             uint arrlen = arr.length;
717 
718             // get correct cbor output length
719             uint outputlen = 0;
720             bytes[] memory elemArray = new bytes[](arrlen);
721             for (uint i = 0; i < arrlen; i++) {
722                 elemArray[i] = (bytes(arr[i]));
723                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
724             }
725             uint ctr = 0;
726             uint cborlen = arrlen + 0x80;
727             outputlen += byte(cborlen).length;
728             bytes memory res = new bytes(outputlen);
729 
730             while (byte(cborlen).length > ctr) {
731                 res[ctr] = byte(cborlen)[ctr];
732                 ctr++;
733             }
734             for (i = 0; i < arrlen; i++) {
735                 res[ctr] = 0x5F;
736                 ctr++;
737                 for (uint x = 0; x < elemArray[i].length; x++) {
738                     // if there's a bug with larger strings, this may be the culprit
739                     if (x % 23 == 0) {
740                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
741                         elemcborlen += 0x40;
742                         uint lctr = ctr;
743                         while (byte(elemcborlen).length > ctr - lctr) {
744                             res[ctr] = byte(elemcborlen)[ctr - lctr];
745                             ctr++;
746                         }
747                     }
748                     res[ctr] = elemArray[i][x];
749                     ctr++;
750                 }
751                 res[ctr] = 0xFF;
752                 ctr++;
753             }
754             return res;
755         }
756 
757 
758     string oraclize_network_name;
759     function oraclize_setNetworkName(string _network_name) internal {
760         oraclize_network_name = _network_name;
761     }
762 
763     function oraclize_getNetworkName() internal returns (string) {
764         return oraclize_network_name;
765     }
766 
767     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
768         if ((_nbytes == 0)||(_nbytes > 32)) throw;
769         bytes memory nbytes = new bytes(1);
770         nbytes[0] = byte(_nbytes);
771         bytes memory unonce = new bytes(32);
772         bytes memory sessionKeyHash = new bytes(32);
773         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
774         assembly {
775             mstore(unonce, 0x20)
776             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
777             mstore(sessionKeyHash, 0x20)
778             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
779         }
780         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
781         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
782         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
783         return queryId;
784     }
785 
786     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
787         oraclize_randomDS_args[queryId] = commitment;
788     }
789 
790     mapping(bytes32=>bytes32) oraclize_randomDS_args;
791     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
792 
793     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
794         bool sigok;
795         address signer;
796 
797         bytes32 sigr;
798         bytes32 sigs;
799 
800         bytes memory sigr_ = new bytes(32);
801         uint offset = 4+(uint(dersig[3]) - 0x20);
802         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
803         bytes memory sigs_ = new bytes(32);
804         offset += 32 + 2;
805         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
806 
807         assembly {
808             sigr := mload(add(sigr_, 32))
809             sigs := mload(add(sigs_, 32))
810         }
811 
812 
813         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
814         if (address(sha3(pubkey)) == signer) return true;
815         else {
816             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
817             return (address(sha3(pubkey)) == signer);
818         }
819     }
820 
821     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
822         bool sigok;
823 
824         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
825         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
826         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
827 
828         bytes memory appkey1_pubkey = new bytes(64);
829         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
830 
831         bytes memory tosign2 = new bytes(1+65+32);
832         tosign2[0] = 1; //role
833         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
834         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
835         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
836         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
837 
838         if (sigok == false) return false;
839 
840 
841         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
842         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
843 
844         bytes memory tosign3 = new bytes(1+65);
845         tosign3[0] = 0xFE;
846         copyBytes(proof, 3, 65, tosign3, 1);
847 
848         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
849         copyBytes(proof, 3+65, sig3.length, sig3, 0);
850 
851         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
852 
853         return sigok;
854     }
855 
856     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
857         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
858         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
859 
860         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
861         if (proofVerified == false) throw;
862 
863         _;
864     }
865 
866     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
867         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
868         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
869 
870         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
871         if (proofVerified == false) return 2;
872 
873         return 0;
874     }
875 
876     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
877         bool match_ = true;
878         
879         for (uint256 i=0; i< n_random_bytes; i++) {
880             if (content[i] != prefix[i]) match_ = false;
881         }
882 
883         return match_;
884     }
885 
886     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
887 
888         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
889         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
890         bytes memory keyhash = new bytes(32);
891         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
892         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
893 
894         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
895         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
896 
897         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
898         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
899 
900         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
901         // This is to verify that the computed args match with the ones specified in the query.
902         bytes memory commitmentSlice1 = new bytes(8+1+32);
903         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
904 
905         bytes memory sessionPubkey = new bytes(64);
906         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
907         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
908 
909         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
910         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
911             delete oraclize_randomDS_args[queryId];
912         } else return false;
913 
914 
915         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
916         bytes memory tosign1 = new bytes(32+8+1+32);
917         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
918         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
919 
920         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
921         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
922             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
923         }
924 
925         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
926     }
927 
928 
929     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
930     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
931         uint minLength = length + toOffset;
932 
933         if (to.length < minLength) {
934             // Buffer too small
935             throw; // Should be a better way?
936         }
937 
938         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
939         uint i = 32 + fromOffset;
940         uint j = 32 + toOffset;
941 
942         while (i < (32 + fromOffset + length)) {
943             assembly {
944                 let tmp := mload(add(from, i))
945                 mstore(add(to, j), tmp)
946             }
947             i += 32;
948             j += 32;
949         }
950 
951         return to;
952     }
953 
954     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
955     // Duplicate Solidity's ecrecover, but catching the CALL return value
956     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
957         // We do our own memory management here. Solidity uses memory offset
958         // 0x40 to store the current end of memory. We write past it (as
959         // writes are memory extensions), but don't update the offset so
960         // Solidity will reuse it. The memory used here is only needed for
961         // this context.
962 
963         // FIXME: inline assembly can't access return values
964         bool ret;
965         address addr;
966 
967         assembly {
968             let size := mload(0x40)
969             mstore(size, hash)
970             mstore(add(size, 32), v)
971             mstore(add(size, 64), r)
972             mstore(add(size, 96), s)
973 
974             // NOTE: we can reuse the request memory because we deal with
975             //       the return code
976             ret := call(3000, 1, 0, size, 128, size, 32)
977             addr := mload(size)
978         }
979 
980         return (ret, addr);
981     }
982 
983     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
984     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
985         bytes32 r;
986         bytes32 s;
987         uint8 v;
988 
989         if (sig.length != 65)
990           return (false, 0);
991 
992         // The signature format is a compact form of:
993         //   {bytes32 r}{bytes32 s}{uint8 v}
994         // Compact means, uint8 is not padded to 32 bytes.
995         assembly {
996             r := mload(add(sig, 32))
997             s := mload(add(sig, 64))
998 
999             // Here we are loading the last 32 bytes. We exploit the fact that
1000             // 'mload' will pad with zeroes if we overread.
1001             // There is no 'mload8' to do this, but that would be nicer.
1002             v := byte(0, mload(add(sig, 96)))
1003 
1004             // Alternative solution:
1005             // 'byte' is not working due to the Solidity parser, so lets
1006             // use the second best option, 'and'
1007             // v := and(mload(add(sig, 65)), 255)
1008         }
1009 
1010         // albeit non-transactional signatures are not specified by the YP, one would expect it
1011         // to match the YP range of [27, 28]
1012         //
1013         // geth uses [0, 1] and some clients have followed. This might change, see:
1014         //  https://github.com/ethereum/go-ethereum/issues/2053
1015         if (v < 27)
1016           v += 27;
1017 
1018         if (v != 27 && v != 28)
1019             return (false, 0);
1020 
1021         return safer_ecrecover(hash, v, r, s);
1022     }
1023 
1024 }
1025 // </ORACLIZE_API>
1026 
1027 //CWC with verifiedUsersOnlyMode and verifiedUsers[] for KYC regulations
1028 //Feb 4, 2018 --Developed by Byunggu Yu
1029 
1030 
1031 contract CWC_SaleInterface {
1032     function balanceOf(address who) constant returns (uint);
1033     function minterGivesCWC(address _to, uint _value);
1034     
1035     event Transfer(address from, address to, uint value, bytes data);
1036     event MinterGaveCWC(address from, address to, uint value);
1037 }
1038 contract CWC_ReceiverInterface {
1039 /* 
1040  * @param _from  Token sender address.
1041  * @param _value Amount of tokens.
1042  * @param _data  Transaction metadata.
1043  */
1044     function CWCfallback(address _from, uint _value, bytes _data);
1045     event Transfer(address from, address to, uint value, bytes data);
1046 }
1047 library SafeMath {
1048   function mul(uint a, uint b) internal returns (uint) {
1049     uint c = a * b;
1050     assert(a == 0 || c / a == b);
1051     return c;
1052   }
1053 
1054   function div(uint a, uint b) internal returns (uint) {
1055     // assert(b > 0); // Solidity automatically throws when dividing by 0
1056     uint c = a / b;
1057     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1058     return c;
1059   }
1060 
1061   function sub(uint a, uint b) internal returns (uint) {
1062     assert(b <= a);
1063     return a - b;
1064   }
1065 
1066   function add(uint a, uint b) internal returns (uint) {
1067     uint c = a + b;
1068     assert(c >= a);
1069     return c;
1070   }
1071 /*
1072   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
1073     return a >= b ? a : b;
1074   }
1075 
1076   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
1077     return a < b ? a : b;
1078   }
1079 
1080   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
1081     return a >= b ? a : b;
1082   }
1083 
1084   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
1085     return a < b ? a : b;
1086   }
1087 
1088   function assert(bool assertion) internal {
1089     if (!assertion) {
1090       revert();
1091     }
1092   }
1093 */
1094     
1095 }
1096 
1097 /* CWC_Sale.sol */
1098 /* CWC_Sale, ERC223 based, Credit Washington, Jan 8, 2018 */
1099 /* Developed by Byunggu Yu */
1100 /* Deployment Manual
1101     After deployed, 
1102         (1) Set hedgeAddress (default: owner);
1103         (2) Set all Query and Query Data;
1104         (3) Add U/D trading product addresses using addMinter.
1105         
1106 	Notes:   
1107 	0. tickerQuery is an HTTP POST. (Note: tickerQueryPurpose: (1) Sale; (2) CWCreturn (our buyback of CWC)
1108 		By default: POST goes to our HTTP server (tickerQuery) with opcode, CWC, client_address, and amount.
1109                 You cannot change tickerQueryData (auto generated as follows)
1110 		===> "opcode (0 for sale; 1 for return), CWC, client_address, amount”
1111 		    Note: amount is Wei for 3 (sale) and CWC for 4 (return)
1112 
1113 	2.  result of every POST is the "result" parameter of __callback() in a string.
1114 		Error return definition:
1115 			===> hedgeQuery: return=="err";
1116 			===> CWCreturnQuery: return=="err";
1117 			 
1118 */
1119 
1120 contract owned is usingOraclize{
1121     address public owner;
1122 
1123     function owned() public {
1124         owner = msg.sender;
1125     }
1126 
1127     modifier onlyOwner {
1128         require(msg.sender == owner);
1129         _;
1130     }
1131 
1132     function transferOwnership(address newOwner) onlyOwner public {
1133         owner = newOwner;
1134     }
1135     //====================== Utility Functions =========================//
1136     /// @dev Compares two strings and returns true iff they are equal.
1137     function stringEqual(string _a, string _b) internal returns (bool) {
1138         return strCompare(_a, _b) == 0;
1139     }
1140     function addressToAsciiString(address x) internal returns (string) {
1141         bytes memory s = new bytes(40);
1142         for (uint i = 0; i < 20; i++) {
1143             byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
1144             byte hi = byte(uint8(b) / 16);
1145             byte lo = byte(uint8(b) - 16 * uint8(hi));
1146             s[2*i] = char(hi);
1147             s[2*i+1] = char(lo);
1148         }
1149         return string(s);
1150     }
1151 
1152     function char(byte b) internal returns (byte c) {
1153         if (b < 10) return byte(uint8(b) + 0x30);
1154         else return byte(uint8(b) + 0x57);
1155     }
1156     //==================================================================//
1157 }
1158 
1159 //===========================================================================
1160 //===========================================================================
1161 //===========================================================================
1162 
1163 
1164 contract CWC_Sale is owned, CWC_SaleInterface {
1165     using SafeMath for uint;
1166 
1167     /* Constructor Variables */
1168     string public name;
1169     string public symbol;
1170 
1171     /* Ether Hedge Wallet Address */
1172     address public hedgeAddress; //ether payments go to this
1173     
1174     /* Settable Fee Structure per Sale and CWCreturn transaction */
1175     uint public fixedFeeInWei=1000000000000000; //default: 0.001 ether, fee per CWC Sale invariant to the sale transaction volume
1176     uint public percentFeeTimes100=20; //default: 0.15% (=15), (e.g., 100=1%, 1=0.01%) %fee * 100 integerper CWC Sale transaction volume
1177     // Note: value/10000*percentFeeTimes100 is the percentFee of value
1178     //      e.g., 100/10000*100 = 1% of 100
1179     //      Make sure that you apply this to wei. percentFee=(wei/10000)*percentFeeTimes100
1180     
1181     /* Settable variables */
1182     bool public verifiedUsersOnlyMode=false;
1183     mapping(address => bool) verifiedUsers;
1184     
1185     uint public totalSupply=1000000000000; // 1 Trillion CWCs
1186     //totalInCirculation (uint type) is in CWC_SaleInterface.sol; 
1187     bool public pauseCWC=false;
1188     uint public minFinneyPerSaleMoreThan=99; //default: 0.1 ether. Changable
1189     uint public maxFinneyPerSaleLessThan=1000000001; //default: 1,000,000 ether. Changable
1190     uint public minCWCsPerReturnMoreThan=9; // greater than this minimum CWCreturn volume in CWCs
1191     uint public maxCWCsPerReturnLessThan=1000000001; //default: 1billion. less than this max.
1192     uint public minFinneyToKeep=500; //min finney to keep in this contract
1193     uint public minFinneyPerHedgeTransfer=200;
1194     mapping(address => uint) balances; // How many CWCs each address has.
1195     //Add only our intrument addresses, e.g., UltraETH, in isMinter array
1196     mapping(address => bool) isMinter; //Minter is allowed to transfer CWCs without holding any CWC.
1197     //The following is to block BAD addresses: All In and Out of CWCs Stop
1198     
1199     /* saleTransaction(), CWCreturnTransaction(), and __callback variables */
1200     //string public tickerQuery="json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.a.0";
1201     //string public tickerQuery="json(http://api.hitbtc.com/api/2/public/ticker/ETHUSD).ask"; //cheaper usd
1202     string public tickerQuery="http://52.73.180.197:30123";
1203     string public tickerQueryData="";
1204     mapping(bytes32 => bool) tickerQueryIds;
1205     mapping(bytes32 => uint8) tickerQueryPurpose; //(1) [CWC]Sale; (2) CWCreturn
1206     string public lastCWCETH;
1207     uint public lastWeiPricePerCWC;
1208     // CWC sale
1209     mapping(bytes32 => address) waitingBuyer;
1210     mapping(bytes32 => uint) weiPaid;
1211     // CWC return
1212     mapping(bytes32 => address) waitingSeller;
1213     mapping(bytes32 => uint) cwcPaid;
1214     
1215     /* CWCreturnTransaction() and __callback variables */
1216     string public CWCreturnQuery="http://52.73.180.197:30123";
1217     string public CWCreturnQueryData="";
1218     mapping(bytes32 => bool) CWCreturnQueryIds;
1219 
1220     /* Public Events */
1221     //production events
1222     //event Transfer is in the interface
1223     event receivedWei(address from, uint amount);
1224     event soldCWC(address to, uint amount, bytes32 myid);
1225     event receivedCWCreturn(address from, uint amount);
1226     event returnedWei(address back_to, uint amount);
1227 
1228     event newOraclizeSetProof(string description);
1229     event needsEther(string description);
1230     event newTickerQuery(string description, bytes32 myid);
1231     event newTickerQueryResult(string last_uetcwc, bytes32 myid);
1232     event errorTickerQueryError(string result, bytes32 myid);
1233     
1234     /* Debug Events */
1235     event debug_string(string description);
1236     event debug_bool(bool description);
1237     event debug_uint(uint description);
1238     
1239     /* Constructor function */
1240     function CWC_Sale(string tokenName, string tokenSymbol) public {
1241         name = tokenName;           // Set the name for display purposes
1242         symbol = tokenSymbol;       // Set the symbol for display purposes
1243         hedgeAddress = msg.sender;  // Initialized to the owner. Changable.
1244         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1245         newOraclizeSetProof("called the function");
1246     }    
1247 
1248     /* balance checkup */
1249     function balanceOf(address an_address) constant returns (uint balance) {
1250         return balances[an_address];
1251     }
1252     
1253     /* verified users checkup */
1254     function isVerifiedUser(address an_address) constant returns (bool verified) {
1255         return verifiedUsers[an_address];
1256     }
1257     
1258     /* Setters */
1259     function set_verifiedUsersOnlyMode(bool _verifiedOnly) onlyOwner public {
1260         verifiedUsersOnlyMode=_verifiedOnly;
1261     }
1262     function addVerifiedUser(address user_address) onlyOwner public {
1263         verifiedUsers[user_address] = true;
1264     }
1265     function removeVerifiedUser(address user_address) onlyOwner public {
1266         delete verifiedUsers[user_address];
1267     }
1268     
1269     function retryOraclizeSetProof(uint Type_1_if_sure) onlyOwner public {
1270         if(Type_1_if_sure==1) {
1271             oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1272             newOraclizeSetProof("manual performed");
1273         }
1274     }
1275     function set_fees(uint _fixedFeeInWei, uint _percentFeeTimes100) onlyOwner public {
1276         fixedFeeInWei = _fixedFeeInWei;
1277         percentFeeTimes100 = _percentFeeTimes100;
1278     }
1279     function set_totalSupply(uint value) onlyOwner public {
1280         totalSupply=value;
1281     }
1282     function set_pauseCWC(bool _pauseCWC) onlyOwner public {
1283         pauseCWC=_pauseCWC;
1284     }
1285     function set_min_max_FinneyPerSale(uint _minInFinneyMinus1, uint _maxInFinneyPlus1) onlyOwner public {
1286         minFinneyPerSaleMoreThan=_minInFinneyMinus1;
1287         maxFinneyPerSaleLessThan=_maxInFinneyPlus1;
1288     }
1289     function set_min_max_CWCsPerReturn(uint _minInFinneyMinus1, uint _maxInFinneyPlus1) onlyOwner public {
1290         minCWCsPerReturnMoreThan=_minInFinneyMinus1;
1291         maxCWCsPerReturnLessThan=_maxInFinneyPlus1;
1292     }
1293     function set_minFinneyToKeep(uint value) onlyOwner public {
1294         minFinneyToKeep=value;
1295     }
1296     function set_minFinneyPerHedgeTransfer(uint value) onlyOwner public {
1297         minFinneyPerHedgeTransfer=value;
1298     }
1299     function set_tickerQuery(string query) onlyOwner public {
1300         tickerQuery=query;
1301     }
1302     function set_hedgeAddress(address to) onlyOwner public {
1303         hedgeAddress=to;
1304     }
1305     function addMinter(address new_minter) onlyOwner public {
1306         isMinter[new_minter] = true;
1307     }
1308     function removeMinter(address old_minter) onlyOwner public {
1309         delete isMinter[old_minter];
1310     }
1311     function addSomeCWCsTo(address target_address, uint how_many) onlyOwner public {
1312         balances[target_address] = balances[target_address].add(how_many);
1313     }
1314     function removeSomeCWCsFrom(address target_address, uint how_many) onlyOwner public {
1315         balances[target_address] = balances[target_address].sub(how_many);
1316     }
1317 
1318     //================================ CWC Transfer Transaction ==================================//
1319     
1320     /* For The Minter to give CWC to a client */
1321     function minterGivesCWC(address _to, uint _value) public {
1322         require(isMinter[msg.sender]); //minters are the sales items: UET, DET, ...
1323         require(!isMinter[_to] && _to != owner); //to a client
1324         balances[_to] = balances[_to].add(_value);
1325         MinterGaveCWC(msg.sender, _to, _value);
1326     }
1327 
1328     /* ERC223 transfer CWCs with data */
1329     function transfer(address _to, uint _value, bytes _data) public {
1330         uint codeLength;
1331 
1332         assembly {
1333             codeLength := extcodesize(_to)
1334         }
1335 
1336         balances[msg.sender] = balances[msg.sender].sub(_value);
1337         
1338         if(!isMinter[_to] && _to != owner) { //They will never get anything to send
1339             balances[_to] = balances[_to].add(_value);
1340         }
1341 
1342         if(codeLength>0) {
1343             CWC_ReceiverInterface receiver = CWC_ReceiverInterface(_to);
1344             receiver.CWCfallback(msg.sender, _value, _data);
1345         }
1346 	    // Generate an event for the client
1347         Transfer(msg.sender, _to, _value, _data);
1348         // Returning CWCs
1349         if(_to == owner) {
1350             CWCreturnTransaction(msg.sender, _value); // <====== Entry to CWC Return
1351         }
1352     }
1353     
1354     /* ERC223 transfer CWCs w/o data for ERC20 compatibility */
1355     function transfer(address _to, uint _value) public {
1356         uint codeLength;
1357         bytes memory empty;
1358 
1359         assembly {
1360             codeLength := extcodesize(_to)
1361         }
1362 
1363         balances[msg.sender] = balances[msg.sender].sub(_value);
1364 
1365         if(!isMinter[_to] && _to != owner) { //They will never get anything to send
1366             balances[_to] = balances[_to].add(_value);
1367         }
1368         
1369         if(codeLength>0) {
1370             CWC_ReceiverInterface receiver = CWC_ReceiverInterface(_to);
1371             receiver.CWCfallback(msg.sender, _value, empty);
1372         }
1373 	    // Generate an event for the client
1374         Transfer(msg.sender, _to, _value, empty);
1375         // Returning CWCs
1376         if(_to == owner) {
1377             CWCreturnTransaction(msg.sender, _value); // <====== Entry to CWC Return
1378         }
1379     }
1380 
1381     //================================ CWC Sale Transaction ==================================//
1382 
1383     /* ===> Get Ether and Transfer CWCs */
1384     /* CWC_Return has the ERC223 tokenFallBack as in the transfer of CWC_Sale to receive CWC */
1385     /* ===> Get CWCs and Transfer Ether */
1386     /* Client can buy by sending ether to this contract */
1387     /* The function without name is the default function that is called whenever anyone sends ether */
1388     function () public payable { // <=========== Entry to CWC Sale
1389         require(msg.value>0); //reject all incoming custom coins.
1390 	    if(msg.value > 1*10**16) { // less than or equal to 0.01 ether is taken as kick-start fuel
1391 	        saleTransaction();
1392 	    }
1393     }
1394     
1395     function saleTransaction() private {
1396         require(verifiedUsersOnlyMode==false || verifiedUsers[msg.sender]==true);
1397         require(!pauseCWC);
1398 	    require(msg.value>minFinneyPerSaleMoreThan*10**15 && msg.value<maxFinneyPerSaleLessThan*10**15);
1399 
1400         if (oraclize_getPrice("URL") > this.balance) {
1401             needsEther("Oraclize query for CWC sale was NOT sent, please add some ETH to cover for the query fee");
1402             pauseCWC=true;
1403             revert();
1404         } 
1405         else {
1406             //Expectation: CWC_Sale for Ask (a) and CWC_Return for Bid (b)
1407             tickerQueryData = strConcat("0,", "CWC,", "0x", addressToAsciiString(msg.sender), ",");
1408             tickerQueryData = strConcat(tickerQueryData, uint2str(msg.value));
1409             bytes32 queryId = oraclize_query("URL", tickerQuery, tickerQueryData);
1410             //bytes32 queryId = oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHXBT).result.XETHXXBT.c.0");
1411             tickerQueryIds[queryId] = true;
1412             tickerQueryPurpose[queryId] = 1; //1 for CWC sale; 2 for CWC return
1413             waitingBuyer[queryId] = msg.sender;
1414             weiPaid[queryId] = msg.value;
1415             receivedWei(waitingBuyer[queryId], weiPaid[queryId]);
1416             newTickerQuery("Called Oraclize for CWC sale. Waiting…", queryId);
1417         }
1418     }
1419 
1420     //================================ CWC Return Transaction ==================================//
1421 
1422     function CWCreturnTransaction(address from, uint amount) private {
1423         require(verifiedUsersOnlyMode==false || verifiedUsers[from]==true);
1424         require(!pauseCWC);
1425         require(amount>minCWCsPerReturnMoreThan && amount<maxCWCsPerReturnLessThan);
1426         
1427         if (oraclize_getPrice("URL") > this.balance) {
1428             needsEther("Oraclize query for CWC return was NOT sent, please add some ETH to cover for the query fee");
1429             pauseCWC=true;
1430             revert();
1431         } 
1432         else {
1433             //Expectation: CWC_Sale for Ask (a) and CWC_Return for Bid (b)
1434             tickerQueryData = strConcat("1,", "CWC,", "0x", addressToAsciiString(from), ",");
1435             tickerQueryData = strConcat(tickerQueryData, uint2str(amount));
1436             bytes32 queryId = oraclize_query("URL", tickerQuery, tickerQueryData);
1437             tickerQueryIds[queryId] = true;
1438             tickerQueryPurpose[queryId] = 2; //1 for CWC sale; 2 for CWC return
1439             waitingSeller[queryId] = from;
1440             cwcPaid[queryId] = amount;
1441             receivedCWCreturn(waitingSeller[queryId], cwcPaid[queryId]);
1442             newTickerQuery("Called Oraclize for CWC return. Waiting…", queryId);
1443         }
1444     }
1445 
1446     //========================= Orclize __callback() and hedgeTransaction() ==========================//
1447 
1448     function __callback(bytes32 myid, string result, bytes proof) {
1449         // check the validity of the oraclize result
1450         require(msg.sender == oraclize_cbAddress());
1451         
1452         /******* Result to Sale tickerQuery *******/
1453 
1454         if(tickerQueryIds[myid]==true && tickerQueryPurpose[myid]==1) { //tickerQueryPurpose==1 is CWC Sale
1455             // update the public exchange rate
1456             lastCWCETH = result;
1457             if(!stringEqual(lastCWCETH, "err") && !stringEqual(lastCWCETH, "")) {
1458                 lastWeiPricePerCWC = parseInt(lastCWCETH,18);
1459                 // Give CWCs to the buyer
1460                 newTickerQueryResult(result, myid);
1461                 // send the corresponding CWCs to the buyer 
1462                 uint weiAfterFees = (weiPaid[myid]-fixedFeeInWei)-((weiPaid[myid]/10000)*percentFeeTimes100);
1463                 uint numOfCWCs = (weiAfterFees/lastWeiPricePerCWC);
1464                 balances[waitingBuyer[myid]] = balances[waitingBuyer[myid]].add(numOfCWCs);
1465                 soldCWC(waitingBuyer[myid], numOfCWCs, myid);
1466             }
1467             else {
1468                 errorTickerQueryError(result, myid);
1469                 pauseCWC=true;
1470                 waitingBuyer[myid].transfer(weiPaid[myid]); // <====== return all wei
1471                 returnedWei(waitingBuyer[myid], weiPaid[myid]);
1472             }
1473             /******* Clean up *******/
1474             delete tickerQueryIds[myid];
1475             delete tickerQueryPurpose[myid];
1476             delete waitingBuyer[myid];
1477             delete weiPaid[myid];
1478         }
1479 
1480         /******* Result to CWCreturn tickerQuery *******/
1481 
1482         else if(tickerQueryIds[myid]==true && tickerQueryPurpose[myid]==2) { //tickerQueryPurpose==2 is CWC Sale
1483             // update the public exchange rate
1484             lastCWCETH = result;
1485             if(!stringEqual(lastCWCETH, "err") && !stringEqual(lastCWCETH, "")) {
1486                 lastWeiPricePerCWC = parseInt(lastCWCETH,18);
1487                 newTickerQueryResult(result, myid); //The HTTP serve pays ether to the client
1488             }
1489             else {
1490                 errorTickerQueryError(result, myid);
1491                 pauseCWC=true;
1492                 balances[waitingSeller[myid]] = balances[waitingSeller[myid]].add(cwcPaid[myid]); // <===== return all CWCs
1493             }
1494             /******* Clean up *******/
1495             delete tickerQueryIds[myid];
1496             delete tickerQueryPurpose[myid];
1497             delete waitingSeller[myid];
1498             delete cwcPaid[myid]; 
1499         }
1500         
1501         /******* Transfer of ether to the ETH Hedge Wallet *******/
1502         if(this.balance > (minFinneyToKeep*10**15)+(minFinneyPerHedgeTransfer*10**15)) {
1503             uint hedgeTransferAmountInWei = this.balance - (minFinneyToKeep*10**15);
1504             hedgeAddress.transfer(hedgeTransferAmountInWei); //Transfer to the hedge address
1505         }
1506         
1507     }
1508 
1509     //Contemplate removing in the production version
1510     function perform_selfdestruct(uint Type_1_if_sure) onlyOwner public {
1511         if(Type_1_if_sure==1) {
1512             selfdestruct(owner);
1513         }
1514     }
1515 }