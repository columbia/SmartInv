1 pragma solidity 0.4.19;
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
33 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
34 pragma solidity ^0.4.18;
35 
36 contract OraclizeI {
37     address public cbAddress;
38     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
39     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
40     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
41     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
42     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
43     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
44     function getPrice(string _datasource) public returns (uint _dsprice);
45     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
46     function setProofType(byte _proofType) external;
47     function setCustomGasPrice(uint _gasPrice) external;
48     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
49 }
50 contract OraclizeAddrResolverI {
51     function getAddress() public returns (address _addr);
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
83         _;
84     }
85 
86     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
87       return oraclize_setNetwork();
88       networkID; // silence the warning and remain backwards compatible
89     }
90     function oraclize_setNetwork() internal returns(bool){
91         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
92             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
93             oraclize_setNetworkName("eth_mainnet");
94             return true;
95         }
96         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
97             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
98             oraclize_setNetworkName("eth_ropsten3");
99             return true;
100         }
101         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
102             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
103             oraclize_setNetworkName("eth_kovan");
104             return true;
105         }
106         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
107             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
108             oraclize_setNetworkName("eth_rinkeby");
109             return true;
110         }
111         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
112             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
113             return true;
114         }
115         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
116             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
117             return true;
118         }
119         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
120             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
121             return true;
122         }
123         return false;
124     }
125 
126     function __callback(bytes32 myid, string result) public {
127         __callback(myid, result, new bytes(0));
128     }
129     function __callback(bytes32 myid, string result, bytes proof) public {
130       return;
131       myid; result; proof; // Silence compiler warnings
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
524 
525     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
526         return oraclize.randomDS_getSessionPubKeyHash();
527     }
528 
529     function getCodeSize(address _addr) constant internal returns(uint _size) {
530         assembly {
531             _size := extcodesize(_addr)
532         }
533     }
534 
535     function parseAddr(string _a) internal pure returns (address){
536         bytes memory tmp = bytes(_a);
537         uint160 iaddr = 0;
538         uint160 b1;
539         uint160 b2;
540         for (uint i=2; i<2+2*20; i+=2){
541             iaddr *= 256;
542             b1 = uint160(tmp[i]);
543             b2 = uint160(tmp[i+1]);
544             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
545             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
546             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
547             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
548             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
549             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
550             iaddr += (b1*16+b2);
551         }
552         return address(iaddr);
553     }
554 
555     function strCompare(string _a, string _b) internal pure returns (int) {
556         bytes memory a = bytes(_a);
557         bytes memory b = bytes(_b);
558         uint minLength = a.length;
559         if (b.length < minLength) minLength = b.length;
560         for (uint i = 0; i < minLength; i ++)
561             if (a[i] < b[i])
562                 return -1;
563             else if (a[i] > b[i])
564                 return 1;
565         if (a.length < b.length)
566             return -1;
567         else if (a.length > b.length)
568             return 1;
569         else
570             return 0;
571     }
572 
573     function indexOf(string _haystack, string _needle) internal pure returns (int) {
574         bytes memory h = bytes(_haystack);
575         bytes memory n = bytes(_needle);
576         if(h.length < 1 || n.length < 1 || (n.length > h.length))
577             return -1;
578         else if(h.length > (2**128 -1))
579             return -1;
580         else
581         {
582             uint subindex = 0;
583             for (uint i = 0; i < h.length; i ++)
584             {
585                 if (h[i] == n[0])
586                 {
587                     subindex = 1;
588                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
589                     {
590                         subindex++;
591                     }
592                     if(subindex == n.length)
593                         return int(i);
594                 }
595             }
596             return -1;
597         }
598     }
599 
600     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
601         bytes memory _ba = bytes(_a);
602         bytes memory _bb = bytes(_b);
603         bytes memory _bc = bytes(_c);
604         bytes memory _bd = bytes(_d);
605         bytes memory _be = bytes(_e);
606         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
607         bytes memory babcde = bytes(abcde);
608         uint k = 0;
609         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
610         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
611         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
612         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
613         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
614         return string(babcde);
615     }
616 
617     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
618         return strConcat(_a, _b, _c, _d, "");
619     }
620 
621     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
622         return strConcat(_a, _b, _c, "", "");
623     }
624 
625     function strConcat(string _a, string _b) internal pure returns (string) {
626         return strConcat(_a, _b, "", "", "");
627     }
628 
629     // parseInt
630     function parseInt(string _a) internal pure returns (uint) {
631         return parseInt(_a, 0);
632     }
633 
634     // parseInt(parseFloat*10^_b)
635     function parseInt(string _a, uint _b) internal pure returns (uint) {
636         bytes memory bresult = bytes(_a);
637         uint mint = 0;
638         bool decimals = false;
639         for (uint i=0; i<bresult.length; i++){
640             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
641                 if (decimals){
642                    if (_b == 0) break;
643                     else _b--;
644                 }
645                 mint *= 10;
646                 mint += uint(bresult[i]) - 48;
647             } else if (bresult[i] == 46) decimals = true;
648         }
649         if (_b > 0) mint *= 10**_b;
650         return mint;
651     }
652 
653     function uint2str(uint i) internal pure returns (string){
654         if (i == 0) return "0";
655         uint j = i;
656         uint len;
657         while (j != 0){
658             len++;
659             j /= 10;
660         }
661         bytes memory bstr = new bytes(len);
662         uint k = len - 1;
663         while (i != 0){
664             bstr[k--] = byte(48 + i % 10);
665             i /= 10;
666         }
667         return string(bstr);
668     }
669 
670     function stra2cbor(string[] arr) internal pure returns (bytes) {
671             uint arrlen = arr.length;
672 
673             // get correct cbor output length
674             uint outputlen = 0;
675             bytes[] memory elemArray = new bytes[](arrlen);
676             for (uint i = 0; i < arrlen; i++) {
677                 elemArray[i] = (bytes(arr[i]));
678                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
679             }
680             uint ctr = 0;
681             uint cborlen = arrlen + 0x80;
682             outputlen += byte(cborlen).length;
683             bytes memory res = new bytes(outputlen);
684 
685             while (byte(cborlen).length > ctr) {
686                 res[ctr] = byte(cborlen)[ctr];
687                 ctr++;
688             }
689             for (i = 0; i < arrlen; i++) {
690                 res[ctr] = 0x5F;
691                 ctr++;
692                 for (uint x = 0; x < elemArray[i].length; x++) {
693                     // if there's a bug with larger strings, this may be the culprit
694                     if (x % 23 == 0) {
695                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
696                         elemcborlen += 0x40;
697                         uint lctr = ctr;
698                         while (byte(elemcborlen).length > ctr - lctr) {
699                             res[ctr] = byte(elemcborlen)[ctr - lctr];
700                             ctr++;
701                         }
702                     }
703                     res[ctr] = elemArray[i][x];
704                     ctr++;
705                 }
706                 res[ctr] = 0xFF;
707                 ctr++;
708             }
709             return res;
710         }
711 
712     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
713             uint arrlen = arr.length;
714 
715             // get correct cbor output length
716             uint outputlen = 0;
717             bytes[] memory elemArray = new bytes[](arrlen);
718             for (uint i = 0; i < arrlen; i++) {
719                 elemArray[i] = (bytes(arr[i]));
720                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
721             }
722             uint ctr = 0;
723             uint cborlen = arrlen + 0x80;
724             outputlen += byte(cborlen).length;
725             bytes memory res = new bytes(outputlen);
726 
727             while (byte(cborlen).length > ctr) {
728                 res[ctr] = byte(cborlen)[ctr];
729                 ctr++;
730             }
731             for (i = 0; i < arrlen; i++) {
732                 res[ctr] = 0x5F;
733                 ctr++;
734                 for (uint x = 0; x < elemArray[i].length; x++) {
735                     // if there's a bug with larger strings, this may be the culprit
736                     if (x % 23 == 0) {
737                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
738                         elemcborlen += 0x40;
739                         uint lctr = ctr;
740                         while (byte(elemcborlen).length > ctr - lctr) {
741                             res[ctr] = byte(elemcborlen)[ctr - lctr];
742                             ctr++;
743                         }
744                     }
745                     res[ctr] = elemArray[i][x];
746                     ctr++;
747                 }
748                 res[ctr] = 0xFF;
749                 ctr++;
750             }
751             return res;
752         }
753 
754 
755     string oraclize_network_name;
756     function oraclize_setNetworkName(string _network_name) internal {
757         oraclize_network_name = _network_name;
758     }
759 
760     function oraclize_getNetworkName() internal view returns (string) {
761         return oraclize_network_name;
762     }
763 
764     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
765         require((_nbytes > 0) && (_nbytes <= 32));
766         bytes memory nbytes = new bytes(1);
767         nbytes[0] = byte(_nbytes);
768         bytes memory unonce = new bytes(32);
769         bytes memory sessionKeyHash = new bytes(32);
770         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
771         assembly {
772             mstore(unonce, 0x20)
773             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
774             mstore(sessionKeyHash, 0x20)
775             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
776         }
777         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
778         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
779         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
780         return queryId;
781     }
782 
783     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
784         oraclize_randomDS_args[queryId] = commitment;
785     }
786 
787     mapping(bytes32=>bytes32) oraclize_randomDS_args;
788     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
789 
790     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
791         bool sigok;
792         address signer;
793 
794         bytes32 sigr;
795         bytes32 sigs;
796 
797         bytes memory sigr_ = new bytes(32);
798         uint offset = 4+(uint(dersig[3]) - 0x20);
799         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
800         bytes memory sigs_ = new bytes(32);
801         offset += 32 + 2;
802         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
803 
804         assembly {
805             sigr := mload(add(sigr_, 32))
806             sigs := mload(add(sigs_, 32))
807         }
808 
809 
810         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
811         if (address(keccak256(pubkey)) == signer) return true;
812         else {
813             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
814             return (address(keccak256(pubkey)) == signer);
815         }
816     }
817 
818     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
819         bool sigok;
820 
821         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
822         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
823         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
824 
825         bytes memory appkey1_pubkey = new bytes(64);
826         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
827 
828         bytes memory tosign2 = new bytes(1+65+32);
829         tosign2[0] = byte(1); //role
830         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
831         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
832         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
833         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
834 
835         if (sigok == false) return false;
836 
837 
838         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
839         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
840 
841         bytes memory tosign3 = new bytes(1+65);
842         tosign3[0] = 0xFE;
843         copyBytes(proof, 3, 65, tosign3, 1);
844 
845         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
846         copyBytes(proof, 3+65, sig3.length, sig3, 0);
847 
848         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
849 
850         return sigok;
851     }
852 
853     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
854         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
855         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
856 
857         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
858         require(proofVerified);
859 
860         _;
861     }
862 
863     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
864         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
865         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
866 
867         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
868         if (proofVerified == false) return 2;
869 
870         return 0;
871     }
872 
873     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
874         bool match_ = true;
875         
876 
877         for (uint256 i=0; i< n_random_bytes; i++) {
878             if (content[i] != prefix[i]) match_ = false;
879         }
880 
881         return match_;
882     }
883 
884     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
885 
886         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
887         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
888         bytes memory keyhash = new bytes(32);
889         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
890         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
891 
892         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
893         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
894 
895         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
896         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
897 
898         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
899         // This is to verify that the computed args match with the ones specified in the query.
900         bytes memory commitmentSlice1 = new bytes(8+1+32);
901         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
902 
903         bytes memory sessionPubkey = new bytes(64);
904         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
905         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
906 
907         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
908         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
909             delete oraclize_randomDS_args[queryId];
910         } else return false;
911 
912 
913         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
914         bytes memory tosign1 = new bytes(32+8+1+32);
915         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
916         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
917 
918         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
919         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
920             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
921         }
922 
923         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
924     }
925 
926     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
927     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
928         uint minLength = length + toOffset;
929 
930         // Buffer too small
931         require(to.length >= minLength); // Should be a better way?
932 
933         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
934         uint i = 32 + fromOffset;
935         uint j = 32 + toOffset;
936 
937         while (i < (32 + fromOffset + length)) {
938             assembly {
939                 let tmp := mload(add(from, i))
940                 mstore(add(to, j), tmp)
941             }
942             i += 32;
943             j += 32;
944         }
945 
946         return to;
947     }
948 
949     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
950     // Duplicate Solidity's ecrecover, but catching the CALL return value
951     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
952         // We do our own memory management here. Solidity uses memory offset
953         // 0x40 to store the current end of memory. We write past it (as
954         // writes are memory extensions), but don't update the offset so
955         // Solidity will reuse it. The memory used here is only needed for
956         // this context.
957 
958         // FIXME: inline assembly can't access return values
959         bool ret;
960         address addr;
961 
962         assembly {
963             let size := mload(0x40)
964             mstore(size, hash)
965             mstore(add(size, 32), v)
966             mstore(add(size, 64), r)
967             mstore(add(size, 96), s)
968 
969             // NOTE: we can reuse the request memory because we deal with
970             //       the return code
971             ret := call(3000, 1, 0, size, 128, size, 32)
972             addr := mload(size)
973         }
974 
975         return (ret, addr);
976     }
977 
978     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
979     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
980         bytes32 r;
981         bytes32 s;
982         uint8 v;
983 
984         if (sig.length != 65)
985           return (false, 0);
986 
987         // The signature format is a compact form of:
988         //   {bytes32 r}{bytes32 s}{uint8 v}
989         // Compact means, uint8 is not padded to 32 bytes.
990         assembly {
991             r := mload(add(sig, 32))
992             s := mload(add(sig, 64))
993 
994             // Here we are loading the last 32 bytes. We exploit the fact that
995             // 'mload' will pad with zeroes if we overread.
996             // There is no 'mload8' to do this, but that would be nicer.
997             v := byte(0, mload(add(sig, 96)))
998 
999             // Alternative solution:
1000             // 'byte' is not working due to the Solidity parser, so lets
1001             // use the second best option, 'and'
1002             // v := and(mload(add(sig, 65)), 255)
1003         }
1004 
1005         // albeit non-transactional signatures are not specified by the YP, one would expect it
1006         // to match the YP range of [27, 28]
1007         //
1008         // geth uses [0, 1] and some clients have followed. This might change, see:
1009         //  https://github.com/ethereum/go-ethereum/issues/2053
1010         if (v < 27)
1011           v += 27;
1012 
1013         if (v != 27 && v != 28)
1014             return (false, 0);
1015 
1016         return safer_ecrecover(hash, v, r, s);
1017     }
1018 
1019 }
1020 // </ORACLIZE_API>
1021 
1022 
1023 /* 
1024 HonestSweepStakes contract allows participant to choose one coupon worth:
1025  - 0.01 ETH: level 1
1026  - 0.1 ETH: level 2
1027  - 1 ETH: level 3
1028  - 10 ETH: level 4
1029 Following that there are variables that use this division in their names like:
1030 participantsETH01 - it's an array holding addresses of all participants that have payed 0.1 ETH 
1031 for their coupon.
1032 
1033 Contract is set to work continuosly with the cycle of 100 participants, so after each cycle someone (usually initiator) has to run function generating the random number (X) in cycle's range (for example 0 - 99 or 300 - 399). 
1034 Participants can still join a new round without waiting for the previous to be fully finished with the winners, etc.
1035 This random number is used to select a group of participants that will get:
1036  - participantsETH1[X]: 25% of the groups pool
1037  - participantsETH1[X + 1] - participantsETH1[X + 4]: 10% each
1038  - participantsETH1[X + 5] - participantsETH1[X + 8]: 5% each
1039  - participantsETH1[X + 9] - participantsETH1[X + 12]: 2.5% each
1040 Alltogether 95%. 
1041  
1042 The fate of the remaining 5% will be determined by X:
1043  - if it's even then it goes to the contract initiator: 4%
1044  - if it's odd then it goes to next two participants 
1045    (participantsETH1[X + 13] and participantsETH1[X + 14]): 2% each
1046    
1047 The last 1% is stored in contract for any costs related to contract running. 
1048 However highest levels (0.1, 1 and 10 ether) leave only part of this 1% for costs.
1049 
1050 Generally the contract is written the most honest way possible:
1051  - prevents initiator from withdrawing the contract balance unless some rigoristic requirements are met
1052  - allows participants to withdraw their funds in case oraclize query fails
1053  - allows participants to withdraw their funds/prizes in case the sweepstake is stopped
1054  - allows initiator to win ether, not just get it in each round
1055  - initiator can only get his ether if the winners of each round were chosen
1056  - initiator can withdraw the remaining contract balance if the rest of participants have withdrawn their funds/prizes and there are no unfininished rounds or oraclize queries
1057  
1058  This sweepstake is meant for people not other contracts, so if you are playing using some contract you have to be aware that there may occur situation where you won't receive your funds (check forceWithdraw function).
1059 */
1060 contract HonestSweepStakes is usingOraclize {
1061     // this will be defaulted to 100
1062     uint16 maxParticipants;
1063     
1064     // store the number of the next paricipant for 0.001, 0.1, 1 and 10 ether stakes
1065     uint16 nextParticipantNumberETH001;
1066     uint16 nextParticipantNumberETH01;
1067     uint16 nextParticipantNumberETH1;
1068     uint16 nextParticipantNumberETH10;
1069     
1070     // address of the initiator of these sweepstake
1071     address initializedBy;
1072 
1073     // control flag allowing initiator some additional stuff (explained further)
1074     bool sweepStakeStopped = false;
1075     // control flag blocking withdrawing of the unused ether
1076     bool restOfBalanceLocked = true;
1077 
1078     // tables storing participants addresses for 0.001, 0.1, 1 and 10 ether stakes
1079     mapping (uint16 => address) participantsETH001;
1080     mapping (uint16 => address) participantsETH01;
1081     mapping (uint16 => address) participantsETH1;
1082     mapping (uint16 => address) participantsETH10;
1083     
1084     // integers storing the cycle's number for 0.001, 0.1, 1 and 10 ether stakes
1085     uint32 cycleETH001;
1086     uint32 cycleETH01;
1087     uint32 cycleETH1;
1088     uint32 cycleETH10;
1089     
1090     // struct containing addresses of each round participants and level
1091     struct QueryData {
1092         address[] participants;
1093         uint8 level;
1094     }
1095     
1096     // strut containing info of each round that requires generating random "lucky" number
1097     struct RoundData {
1098         uint16 lastParticipant;
1099         uint8 level;
1100     }
1101     
1102     // these are some control flags
1103     uint256 totalPrizesWaiting;
1104     uint32 queriesCallback;
1105     uint16 roundsIndex;
1106     uint16 queriesToDeleteIndex;
1107     
1108     // tables used for various purposes
1109     mapping (uint16 => RoundData) rounds;
1110     mapping (bytes32 => QueryData) queries;
1111     mapping (address => uint256) prizes;
1112     mapping (uint16 => bytes32) queriesToDelete;
1113 
1114     // logs
1115     event ParticipantJoined(uint8 level, uint16 participantNumber, uint32 round, address participantAddress);
1116     event RandomNumberGenerated(uint256 randomNumber, uint8 level); 
1117 
1118     function HonestSweepStakes() public payable {
1119         initializedBy = msg.sender;
1120     
1121         maxParticipants = 100;
1122     
1123         nextParticipantNumberETH001 = 0;
1124         nextParticipantNumberETH01 = 0;
1125         nextParticipantNumberETH1 = 0;
1126         nextParticipantNumberETH10 = 0;
1127         
1128         cycleETH001 = 1;
1129         cycleETH01 = 1;
1130         cycleETH1 = 1;
1131         cycleETH10 = 1;
1132         
1133         totalPrizesWaiting = 0;
1134         queriesCallback = 0;
1135         roundsIndex = 0;
1136         queriesToDeleteIndex = 0;
1137         
1138         // oraclize calback gas price is set to 4 gwei, should be quite ok
1139         oraclize_setCustomGasPrice(4000000000);
1140     }
1141 
1142     // fallback function allowing only initiator to send some ether to the
1143     // contract preventing accidental transfers
1144     function () public payable {
1145         require(msg.sender == initializedBy);
1146     }
1147 
1148     // Main function which is used to join the sweepstake. Can be called multiple times icreasing the chance for winning
1149     function join() external payable {
1150         // Participant can join only if sweepstake is enabled
1151         require(!sweepStakeStopped);
1152         // Participant can only send 0.01, 0.1, 1 or 10 ether
1153         require(msg.value == 10 finney || msg.value == 100 finney || msg.value == 1 ether || msg.value == 10 ether);
1154     
1155         uint16 participantNumber = 0;
1156         uint32 round = 0;
1157         uint8 level = 0;
1158         uint16 max = maxParticipants;
1159     
1160         // each level has it's own logic
1161         if(msg.value == 10 finney) {
1162             participantNumber = nextParticipantNumberETH001;
1163             round = (uint32(participantNumber)/maxParticipants) + 1 + ((cycleETH001 - 1) * 655);
1164             level = 1;
1165             // it resets the participant counter if the uint16 top cap is almost reached
1166             if(nextParticipantNumberETH001 < 65499){
1167                 nextParticipantNumberETH001++;
1168             } else {
1169                 nextParticipantNumberETH001 = 0;
1170                 cycleETH001++;
1171             }
1172             participantsETH001[participantNumber] = msg.sender;
1173         } else if(msg.value == 100 finney) { 
1174             participantNumber = nextParticipantNumberETH01;
1175             round = (uint32(participantNumber)/maxParticipants) + 1 + ((cycleETH01 - 1) * 655);
1176             level = 2;
1177             if(nextParticipantNumberETH01 < 65499){
1178                 nextParticipantNumberETH01++;
1179             } else {
1180                 nextParticipantNumberETH01 = 0;
1181                 cycleETH01++;
1182             }
1183             participantsETH01[participantNumber] = msg.sender;
1184         } else if(msg.value == 1 ether) { 
1185             participantNumber = nextParticipantNumberETH1;
1186             round = (uint32(participantNumber)/maxParticipants) + 1 + ((cycleETH1 - 1) * 655);
1187             level = 3;
1188             if(nextParticipantNumberETH1 < 65499){
1189                 nextParticipantNumberETH1++;
1190             } else {
1191                 nextParticipantNumberETH1 = 0;
1192                 cycleETH1++;
1193             }
1194             participantsETH1[participantNumber] = msg.sender;
1195         } else if(msg.value == 10 ether) { 
1196             participantNumber = nextParticipantNumberETH10;
1197             round = (uint32(participantNumber)/maxParticipants) + 1 + ((cycleETH10 - 1) * 655);
1198             level = 4;
1199             if(nextParticipantNumberETH10 < 65499){
1200                 nextParticipantNumberETH10++;
1201             } else {
1202                 nextParticipantNumberETH10 = 0;
1203                 cycleETH10++;
1204             }
1205             participantsETH10[participantNumber] = msg.sender;
1206         } 
1207         
1208         uint16 participantNumberInRound = (participantNumber + 1) % max;
1209         if(participantNumberInRound == 0){
1210             participantNumberInRound = max;
1211         }
1212         ParticipantJoined(level, participantNumberInRound, round, msg.sender);
1213         
1214         // when the last participant in the round has joined the round is ready to random number generated
1215         if(participantNumberInRound == max){
1216             queriesCallback++;
1217             restOfBalanceLocked = false;
1218             rounds[roundsIndex++] = RoundData(participantNumber, level);
1219         } else {
1220             restOfBalanceLocked = true;
1221         }
1222     }
1223   
1224   
1225     // This function prepares the round participants for the random number generation
1226     // It can be called by anybody in case initiator would be unavailable
1227     function runSweepStake() external payable {
1228         require(roundsIndex > 0);
1229         RoundData memory rd = rounds[--roundsIndex];
1230         uint16 _participantNumber = rd.lastParticipant;
1231         uint8 _level = rd.level;
1232         
1233         uint16 _minRange = _participantNumber - (maxParticipants - 1);
1234         uint16 _maxRange = _participantNumber;
1235         
1236         address[] memory queryParticipants = new address[](100);
1237         uint8 k = 0;
1238         uint16 i = 0;
1239         
1240         if(_level == 1){
1241             for(i = _minRange; i <= _maxRange; i++){
1242                 queryParticipants[k] = participantsETH001[i];
1243                 k++;
1244             }
1245         } else if(_level == 2){
1246             for(i = _minRange; i <= _maxRange; i++){
1247                 queryParticipants[k] = participantsETH01[i];
1248                 k++;
1249             }
1250         } else if(_level == 3){
1251             for(i = _minRange; i <= _maxRange; i++){
1252                 queryParticipants[k] = participantsETH1[i];
1253                 k++;
1254             }
1255         } else if(_level == 4){
1256             for(i = _minRange; i <= _maxRange; i++){
1257                 queryParticipants[k] = participantsETH10[i];
1258                 k++;
1259             }
1260         }
1261         
1262         delete rounds[roundsIndex];
1263         
1264         oraclize_setProof(proofType_Ledger); 
1265         uint N = 4;
1266         uint delay = 0;
1267         uint callbackGas = 750000;
1268         // Query to oraclize requesting random number
1269         bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callbackGas); 
1270         
1271         // Query is saved with round's participants
1272         queries[queryId] = QueryData(queryParticipants, _level);
1273         
1274         // These is deleting the last processed query. Allows to minimaze the cost of the whole function thanks to gas refund
1275         if(queriesToDeleteIndex > 0){
1276             delete queries[queriesToDelete[--queriesToDeleteIndex]];
1277             delete queriesToDelete[queriesToDeleteIndex];
1278         }
1279     }
1280 
1281     function __callback(bytes32 _queryId, string _result, bytes _proof) public {
1282         require(msg.sender == oraclize_cbAddress() || msg.sender == initializedBy);
1283         
1284         // if the proof verification fails or the initiator will force the callback execution (in case of oraclize not calling back)
1285         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0 || msg.sender == initializedBy) {
1286             failedQuery(_queryId);
1287         } else {
1288             uint8 maxRange = 99;
1289             uint randomNumber = uint(keccak256(_result)) % maxRange; 
1290     
1291             chooseWinners(uint8(randomNumber), _queryId);
1292         }
1293     }
1294     
1295     // This function is choosing the winners based on the random number sent by oraclize
1296     function chooseWinners(uint8 _randomNumber, bytes32 _queryId) private {
1297         QueryData memory qd = queries[_queryId];
1298         uint prize;
1299         uint totalPrizes = 0;
1300         uint16 max = maxParticipants - 1;
1301         
1302         RandomNumberGenerated(_randomNumber, qd.level);
1303         
1304         uint16 levelMultiplier;
1305         uint reserve;
1306         if(qd.level == 1){
1307             levelMultiplier = 1;
1308             reserve = 0;
1309         } else if(qd.level == 2){
1310             levelMultiplier = 10;
1311             reserve = 20 finney;
1312         } else if(qd.level == 3){
1313             levelMultiplier = 100;
1314             reserve = 900 finney;
1315         } else if(qd.level == 4){
1316             levelMultiplier = 1000;
1317             reserve = 9900 finney;
1318         } 
1319         
1320         uint8 k = 14;
1321         // initiator gets ether only if the random number is even
1322         if(_randomNumber % 2 == 0){
1323             k = 12;
1324             prize = levelMultiplier * (40 finney);
1325             prizes[initializedBy] += prize + reserve; 
1326             totalPrizes += prize;
1327         }
1328     
1329         // the main winner
1330         prize = levelMultiplier * (250 finney);
1331         prizes[qd.participants[_randomNumber]] += prize;
1332         totalPrizes += prize;
1333         
1334         uint8 l = _randomNumber + 1;
1335         // and the rest of the winners
1336         // there is 12/14 of them and if counter reach number 99 then next one is 0
1337         for(uint8 i = 1; i <= k; i++){
1338             if(l == max){
1339                 l = 0;
1340             }
1341             if(i <= 4){
1342                 prize = levelMultiplier * (100 finney);
1343                 prizes[qd.participants[l]] += prize;
1344             } else if(i > 4 && i <= 8){
1345                 prize = levelMultiplier * (50 finney);
1346                 prizes[qd.participants[l]] += prize;
1347             } else if(i > 8 && i <= 12){
1348                 prize = levelMultiplier * (25 finney);
1349                 prizes[qd.participants[l]] += prize;
1350             } else if(i > 12 && i <= 14){
1351                 prize = levelMultiplier * (20 finney);
1352                 prizes[qd.participants[l]] += prize + (reserve/2);
1353             }
1354             totalPrizes += prize;
1355             l++;
1356         }
1357         
1358         totalPrizesWaiting += totalPrizes;
1359         // query was processed
1360         queriesCallback--;
1361         // and is prepared to delete
1362         queriesToDelete[queriesToDeleteIndex++] = _queryId;
1363     }
1364     
1365     // This function is called when the query has failed or contract initiator had to do manual callback
1366     // instead of oraclize
1367     function failedQuery(bytes32 _queryId) private {
1368         QueryData memory qd = queries[_queryId];
1369         
1370         uint16 max = maxParticipants;
1371         uint amount;
1372         uint totalPrizes = 0;
1373         
1374         if(qd.level == 1){
1375             amount = (10 finney);
1376         } else if(qd.level == 2){
1377             amount = (100 finney);
1378         } else if(qd.level == 3){
1379             amount = (1 ether);
1380         } else if(qd.level == 4){
1381             amount = (10 ether);
1382         } 
1383         
1384         // each of the round participants is rewarded with the same amount he/she has payed
1385         for(uint8 i = 0; i < max; i++){
1386             prizes[qd.participants[i]] += amount;
1387             totalPrizes += amount;
1388         }
1389         
1390         totalPrizesWaiting += totalPrizes;
1391         queriesCallback--;
1392         queriesToDelete[queriesToDeleteIndex++] = _queryId;
1393     }
1394     
1395     // Winners or participants from failed queries can withdraw their prize by calling this function
1396     function prizeWithdrawal() external {
1397         uint amount = prizes[msg.sender];
1398         prizes[msg.sender] = 0;
1399         if (amount > 0) {
1400             if (msg.sender.send(amount)) {
1401                 totalPrizesWaiting -= amount;
1402             } else {
1403                 prizes[msg.sender] = amount;
1404             }
1405         }
1406     }
1407     
1408     // Everybody can check if there is some prize waiting for them
1409     function checkPrize() external view returns (uint256 prize){
1410         prize = prizes[msg.sender];
1411         return prize;
1412     }
1413     
1414     // it's for maintenance purposes allowing initiator to check if there are some not processed queries
1415     function checkOutstandingQueries() external view returns (uint256 numOfQueries){
1416         require(msg.sender == initializedBy);
1417         
1418         numOfQueries = queriesCallback;
1419         return numOfQueries;
1420     }
1421     
1422     // it's for maintenance purposes allowing initiator to check if all the prizes have been withdrawned. 
1423     function checkTotalPrizesWaiting() external view returns (uint256 total){
1424         require(msg.sender == initializedBy);
1425         
1426         total = totalPrizesWaiting;
1427         return total;
1428     }
1429     
1430     // initiator can withdraw the remaining balance only if:
1431     function withdrawRestOfBalance() external {
1432         require(msg.sender == initializedBy);
1433         // 1. sweepstake is stoppped
1434         require(sweepStakeStopped);
1435         uint amount = this.balance;
1436         // 2. everybody have to withdraw their prizes
1437         // 3. there are no outstanding queries to oraclize
1438         // 4. contract balance is unlocked
1439         if(totalPrizesWaiting == 0 && queriesCallback == 0 && !restOfBalanceLocked){
1440             initializedBy.transfer(amount);
1441         }
1442     }    
1443     
1444     // Initiator can stop the sweepstake and this will rollback all not fullfilled rounds. Participants can then withdraw their funds
1445     function stopSweepStake() external {
1446         require(msg.sender == initializedBy);
1447         sweepStakeStopped = true;
1448         
1449         uint16 lastParticipantNumberInRound;
1450         uint16 firstParticipantNumberInRound;
1451         uint amount;
1452         address participantAddress;
1453         uint16 i;
1454         uint16 min;
1455         uint16 max;
1456         uint totalPrizes = 0;
1457         
1458         lastParticipantNumberInRound = nextParticipantNumberETH001 % maxParticipants;
1459         if(lastParticipantNumberInRound > 0){
1460             amount = 10 finney;
1461             firstParticipantNumberInRound = lastParticipantNumberInRound - (lastParticipantNumberInRound - 1);
1462             max = lastParticipantNumberInRound - 1;
1463             min = firstParticipantNumberInRound - 1;
1464             for(i = max; i >= min; i--){
1465                 participantAddress = participantsETH001[i];
1466                 prizes[participantAddress] += amount;
1467                 totalPrizes += amount;
1468                 if(i == 0){ break;}
1469             }
1470             nextParticipantNumberETH001 = min;
1471         }
1472         
1473         lastParticipantNumberInRound = nextParticipantNumberETH01 % maxParticipants;
1474         if(lastParticipantNumberInRound > 0){
1475             amount = 100 finney;
1476             firstParticipantNumberInRound = lastParticipantNumberInRound - (lastParticipantNumberInRound - 1);
1477             max = lastParticipantNumberInRound - 1;
1478             min = firstParticipantNumberInRound - 1;
1479             for(i = max; i >= min; i--){
1480                 participantAddress = participantsETH01[i];
1481                 prizes[participantAddress] += amount;
1482                 totalPrizes += amount;
1483                 if(i == 0){ break;}
1484             }
1485             nextParticipantNumberETH01 = min;
1486         }
1487         
1488         lastParticipantNumberInRound = nextParticipantNumberETH1 % maxParticipants;
1489         if(lastParticipantNumberInRound > 0){
1490             amount = 1 ether;
1491             firstParticipantNumberInRound = lastParticipantNumberInRound - (lastParticipantNumberInRound - 1);
1492             max = lastParticipantNumberInRound - 1;
1493             min = firstParticipantNumberInRound - 1;
1494             for(i = max; i >= min; i--){
1495                 participantAddress = participantsETH1[i];
1496                 prizes[participantAddress] += amount;
1497                 totalPrizes += amount;
1498                 if(i == 0){ break;}
1499             }
1500             nextParticipantNumberETH1 = min;
1501         }
1502         
1503         lastParticipantNumberInRound = nextParticipantNumberETH10 % maxParticipants;
1504         if(lastParticipantNumberInRound > 0){
1505             amount = 10 ether;
1506             firstParticipantNumberInRound = lastParticipantNumberInRound - (lastParticipantNumberInRound - 1);
1507             max = lastParticipantNumberInRound - 1;
1508             min = firstParticipantNumberInRound - 1;
1509             for(i = max; i >= min; i--){
1510                 participantAddress = participantsETH10[i];
1511                 prizes[participantAddress] += amount;
1512                 totalPrizes += amount;
1513                 if(i == 0){ break;}
1514             }
1515             nextParticipantNumberETH10 = min;
1516         }
1517         
1518         totalPrizesWaiting += totalPrizes;
1519         restOfBalanceLocked = false;
1520     }
1521     
1522     // Allows initiator to send funds to the winners which did not do these by themselves
1523     // It would be used only in the case when some prize is waiting a long time preventing initiator from withdrawing the remaining balance.
1524     function forceWithdraw(address _receiver) external {
1525         // initiator must send 100 000 gas, which will be enough to send the funds to all normal addresses
1526         require(msg.sender == initializedBy && msg.gas >= 100000);
1527         require(sweepStakeStopped);
1528         
1529         uint amount = prizes[_receiver];
1530         prizes[_receiver] = 0;
1531         if(amount > 0) {
1532             totalPrizesWaiting -= amount;
1533             if(_receiver.send(amount)) {
1534             }
1535             // there is no else because if the send fail the it would be some contract fallback function and it can be dangerous. 
1536             // in case of send failure ether goes to the contract
1537         }
1538     }
1539     
1540     // Initiator can start the sweepstake again
1541     function startSweepStake() external {
1542         require(msg.sender == initializedBy);
1543         // settings the control flags to prevent the initiator from withdrawing the funds
1544         sweepStakeStopped = false;
1545         restOfBalanceLocked = true;
1546     }
1547     
1548     // shows how many times runSweepStake function needs to be run
1549     function checkRoundsNumberToRun() external view returns (uint16 rntr){
1550         rntr = roundsIndex;
1551         return rntr;
1552     }
1553 }