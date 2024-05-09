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
30 /* solhint-disable */
31 
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
87         return oraclize_setNetwork();
88         networkID; // silence the warning and remain backwards compatible
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
130         return;
131         myid; result; proof; // Silence compiler warnings
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
642                     if (_b == 0) break;
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
671         uint arrlen = arr.length;
672 
673         // get correct cbor output length
674         uint outputlen = 0;
675         bytes[] memory elemArray = new bytes[](arrlen);
676         for (uint i = 0; i < arrlen; i++) {
677             elemArray[i] = (bytes(arr[i]));
678             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
679         }
680         uint ctr = 0;
681         uint cborlen = arrlen + 0x80;
682         outputlen += byte(cborlen).length;
683         bytes memory res = new bytes(outputlen);
684 
685         while (byte(cborlen).length > ctr) {
686             res[ctr] = byte(cborlen)[ctr];
687             ctr++;
688         }
689         for (i = 0; i < arrlen; i++) {
690             res[ctr] = 0x5F;
691             ctr++;
692             for (uint x = 0; x < elemArray[i].length; x++) {
693                 // if there's a bug with larger strings, this may be the culprit
694                 if (x % 23 == 0) {
695                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
696                     elemcborlen += 0x40;
697                     uint lctr = ctr;
698                     while (byte(elemcborlen).length > ctr - lctr) {
699                         res[ctr] = byte(elemcborlen)[ctr - lctr];
700                         ctr++;
701                     }
702                 }
703                 res[ctr] = elemArray[i][x];
704                 ctr++;
705             }
706             res[ctr] = 0xFF;
707             ctr++;
708         }
709         return res;
710     }
711 
712     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
713         uint arrlen = arr.length;
714 
715         // get correct cbor output length
716         uint outputlen = 0;
717         bytes[] memory elemArray = new bytes[](arrlen);
718         for (uint i = 0; i < arrlen; i++) {
719             elemArray[i] = (bytes(arr[i]));
720             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
721         }
722         uint ctr = 0;
723         uint cborlen = arrlen + 0x80;
724         outputlen += byte(cborlen).length;
725         bytes memory res = new bytes(outputlen);
726 
727         while (byte(cborlen).length > ctr) {
728             res[ctr] = byte(cborlen)[ctr];
729             ctr++;
730         }
731         for (i = 0; i < arrlen; i++) {
732             res[ctr] = 0x5F;
733             ctr++;
734             for (uint x = 0; x < elemArray[i].length; x++) {
735                 // if there's a bug with larger strings, this may be the culprit
736                 if (x % 23 == 0) {
737                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
738                     elemcborlen += 0x40;
739                     uint lctr = ctr;
740                     while (byte(elemcborlen).length > ctr - lctr) {
741                         res[ctr] = byte(elemcborlen)[ctr - lctr];
742                         ctr++;
743                     }
744                 }
745                 res[ctr] = elemArray[i][x];
746                 ctr++;
747             }
748             res[ctr] = 0xFF;
749             ctr++;
750         }
751         return res;
752     }
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
766         // Convert from seconds to ledger timer ticks
767         _delay *= 10;
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
779         bytes memory delay = new bytes(32);
780         assembly {
781             mstore(add(delay, 0x20), _delay)
782         }
783 
784         bytes memory delay_bytes8 = new bytes(8);
785         copyBytes(delay, 24, 8, delay_bytes8, 0);
786 
787         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
788         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
789 
790         bytes memory delay_bytes8_left = new bytes(8);
791 
792         assembly {
793             let x := mload(add(delay_bytes8, 0x20))
794             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
795             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
796             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
797             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
798             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
799             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
800             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
801             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
802 
803         }
804 
805         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
806         return queryId;
807     }
808 
809     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
810         oraclize_randomDS_args[queryId] = commitment;
811     }
812 
813     mapping(bytes32=>bytes32) oraclize_randomDS_args;
814     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
815 
816     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
817         bool sigok;
818         address signer;
819 
820         bytes32 sigr;
821         bytes32 sigs;
822 
823         bytes memory sigr_ = new bytes(32);
824         uint offset = 4+(uint(dersig[3]) - 0x20);
825         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
826         bytes memory sigs_ = new bytes(32);
827         offset += 32 + 2;
828         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
829 
830         assembly {
831             sigr := mload(add(sigr_, 32))
832             sigs := mload(add(sigs_, 32))
833         }
834 
835 
836         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
837         if (address(keccak256(pubkey)) == signer) return true;
838         else {
839             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
840             return (address(keccak256(pubkey)) == signer);
841         }
842     }
843 
844     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
845         bool sigok;
846 
847         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
848         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
849         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
850 
851         bytes memory appkey1_pubkey = new bytes(64);
852         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
853 
854         bytes memory tosign2 = new bytes(1+65+32);
855         tosign2[0] = byte(1); //role
856         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
857         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
858         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
859         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
860 
861         if (sigok == false) return false;
862 
863 
864         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
865         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
866 
867         bytes memory tosign3 = new bytes(1+65);
868         tosign3[0] = 0xFE;
869         copyBytes(proof, 3, 65, tosign3, 1);
870 
871         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
872         copyBytes(proof, 3+65, sig3.length, sig3, 0);
873 
874         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
875 
876         return sigok;
877     }
878 
879     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
880         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
881         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
882 
883         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
884         require(proofVerified);
885 
886         _;
887     }
888 
889     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
890         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
891         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
892 
893         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
894         if (proofVerified == false) return 2;
895 
896         return 0;
897     }
898 
899     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
900         bool match_ = true;
901 
902         require(prefix.length == n_random_bytes);
903 
904         for (uint256 i=0; i< n_random_bytes; i++) {
905             if (content[i] != prefix[i]) match_ = false;
906         }
907 
908         return match_;
909     }
910 
911     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
912 
913         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
914         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
915         bytes memory keyhash = new bytes(32);
916         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
917         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
918 
919         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
920         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
921 
922         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
923         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
924 
925         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
926         // This is to verify that the computed args match with the ones specified in the query.
927         bytes memory commitmentSlice1 = new bytes(8+1+32);
928         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
929 
930         bytes memory sessionPubkey = new bytes(64);
931         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
932         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
933 
934         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
935         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
936             delete oraclize_randomDS_args[queryId];
937         } else return false;
938 
939 
940         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
941         bytes memory tosign1 = new bytes(32+8+1+32);
942         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
943         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
944 
945         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
946         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
947             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
948         }
949 
950         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
951     }
952 
953     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
954     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
955         uint minLength = length + toOffset;
956 
957         // Buffer too small
958         require(to.length >= minLength); // Should be a better way?
959 
960         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
961         uint i = 32 + fromOffset;
962         uint j = 32 + toOffset;
963 
964         while (i < (32 + fromOffset + length)) {
965             assembly {
966                 let tmp := mload(add(from, i))
967                 mstore(add(to, j), tmp)
968             }
969             i += 32;
970             j += 32;
971         }
972 
973         return to;
974     }
975 
976     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
977     // Duplicate Solidity's ecrecover, but catching the CALL return value
978     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
979         // We do our own memory management here. Solidity uses memory offset
980         // 0x40 to store the current end of memory. We write past it (as
981         // writes are memory extensions), but don't update the offset so
982         // Solidity will reuse it. The memory used here is only needed for
983         // this context.
984 
985         // FIXME: inline assembly can't access return values
986         bool ret;
987         address addr;
988 
989         assembly {
990             let size := mload(0x40)
991             mstore(size, hash)
992             mstore(add(size, 32), v)
993             mstore(add(size, 64), r)
994             mstore(add(size, 96), s)
995 
996         // NOTE: we can reuse the request memory because we deal with
997         //       the return code
998             ret := call(3000, 1, 0, size, 128, size, 32)
999             addr := mload(size)
1000         }
1001 
1002         return (ret, addr);
1003     }
1004 
1005     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1006     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1007         bytes32 r;
1008         bytes32 s;
1009         uint8 v;
1010 
1011         if (sig.length != 65)
1012             return (false, 0);
1013 
1014         // The signature format is a compact form of:
1015         //   {bytes32 r}{bytes32 s}{uint8 v}
1016         // Compact means, uint8 is not padded to 32 bytes.
1017         assembly {
1018             r := mload(add(sig, 32))
1019             s := mload(add(sig, 64))
1020 
1021         // Here we are loading the last 32 bytes. We exploit the fact that
1022         // 'mload' will pad with zeroes if we overread.
1023         // There is no 'mload8' to do this, but that would be nicer.
1024             v := byte(0, mload(add(sig, 96)))
1025 
1026         // Alternative solution:
1027         // 'byte' is not working due to the Solidity parser, so lets
1028         // use the second best option, 'and'
1029         // v := and(mload(add(sig, 65)), 255)
1030         }
1031 
1032         // albeit non-transactional signatures are not specified by the YP, one would expect it
1033         // to match the YP range of [27, 28]
1034         //
1035         // geth uses [0, 1] and some clients have followed. This might change, see:
1036         //  https://github.com/ethereum/go-ethereum/issues/2053
1037         if (v < 27)
1038             v += 27;
1039 
1040         if (v != 27 && v != 28)
1041             return (false, 0);
1042 
1043         return safer_ecrecover(hash, v, r, s);
1044     }
1045 
1046 }
1047 /* solhint-enable */
1048 // </ORACLIZE_API>
1049 
1050 
1051 /**
1052  * @title Ownable
1053  * @dev The Ownable contract has an owner address, and provides basic authorization control
1054  * functions, this simplifies the implementation of "user permissions".
1055  */
1056 contract Ownable {
1057     //Variables
1058     address public owner;
1059 
1060     address public newOwner;
1061 
1062     //    Modifiers
1063     /**
1064      * @dev Throws if called by any account other than the owner.
1065      */
1066     modifier onlyOwner() {
1067         require(msg.sender == owner);
1068         _;
1069     }
1070 
1071     /**
1072      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1073      * account.
1074      */
1075     function Ownable() public {
1076         owner = msg.sender;
1077     }
1078 
1079     /**
1080      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1081      * @param _newOwner The address to transfer ownership to.
1082      */
1083     function transferOwnership(address _newOwner) public onlyOwner {
1084         require(_newOwner != address(0));
1085         newOwner = _newOwner;
1086 
1087     }
1088 
1089     function acceptOwnership() public {
1090         if (msg.sender == newOwner) {
1091             owner = newOwner;
1092         }
1093     }
1094 }
1095 
1096 library SafeMath {
1097 
1098   /**
1099   * @dev Multiplies two numbers, throws on overflow.
1100   */
1101   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1102     if (a == 0) {
1103       return 0;
1104     }
1105     uint256 c = a * b;
1106     assert(c / a == b);
1107     return c;
1108   }
1109 
1110   /**
1111   * @dev Integer division of two numbers, truncating the quotient.
1112   */
1113   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1114     // assert(b > 0); // Solidity automatically throws when dividing by 0
1115     uint256 c = a / b;
1116     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1117     return c;
1118   }
1119 
1120   /**
1121   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1122   */
1123   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1124     assert(b <= a);
1125     return a - b;
1126   }
1127 
1128   /**
1129   * @dev Adds two numbers, throws on overflow.
1130   */
1131   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1132     uint256 c = a + b;
1133     assert(c >= a);
1134     return c;
1135   }
1136 }
1137 
1138 
1139 
1140 contract Multivest is Ownable, usingOraclize {
1141     using SafeMath for uint256;
1142 
1143     uint256 public etherPriceInUSD; //$753.25  75325000
1144     /* public variables */
1145     mapping (address => bool) public allowedMultivests;
1146 
1147     /* events */
1148     event MultivestSet(address multivest);
1149 
1150     event MultivestUnset(address multivest);
1151 
1152     event Contribution(address holder, uint256 value, uint256 tokens);
1153 
1154     modifier onlyAllowedMultivests() {
1155         require(true == allowedMultivests[msg.sender]);
1156         _;
1157     }
1158 
1159     /* constructor */
1160     function Multivest(address _multivest) public {
1161         allowedMultivests[_multivest] = true;
1162     }
1163 
1164     function setAllowedMultivest(address _address) public onlyOwner {
1165         allowedMultivests[_address] = true;
1166         MultivestSet(_address);
1167     }
1168 
1169     function unsetAllowedMultivest(address _address) public onlyOwner {
1170         allowedMultivests[_address] = false;
1171         MultivestUnset(_address);
1172     }
1173 
1174     function multivestBuy(address _address, string _valueInUSD) public onlyAllowedMultivests {
1175         bool status = buy(_address, parseInt(_valueInUSD, 5).mul(10**18), true);
1176         require(status == true);
1177     }
1178 
1179     function buy(address _address, uint256 value, bool _isUSD) internal returns (bool);
1180 
1181 }
1182 
1183 contract ERC20Basic {
1184   function totalSupply() public view returns (uint256);
1185   function balanceOf(address who) public view returns (uint256);
1186   function transfer(address to, uint256 value) public returns (bool);
1187   event Transfer(address indexed from, address indexed to, uint256 value);
1188 }
1189 
1190 contract ERC20 is ERC20Basic {
1191   function allowance(address owner, address spender) public view returns (uint256);
1192   function transferFrom(address from, address to, uint256 value) public returns (bool);
1193   function approve(address spender, uint256 value) public returns (bool);
1194   event Approval(address indexed owner, address indexed spender, uint256 value);
1195 }
1196 
1197 contract BasicToken is ERC20Basic {
1198   using SafeMath for uint256;
1199 
1200   mapping(address => uint256) balances;
1201 
1202   uint256 totalSupply_;
1203 
1204   /**
1205   * @dev total number of tokens in existence
1206   */
1207   function totalSupply() public view returns (uint256) {
1208     return totalSupply_;
1209   }
1210 
1211   /**
1212   * @dev transfer token for a specified address
1213   * @param _to The address to transfer to.
1214   * @param _value The amount to be transferred.
1215   */
1216   function transfer(address _to, uint256 _value) public returns (bool) {
1217     require(_to != address(0));
1218     require(_value <= balances[msg.sender]);
1219 
1220     // SafeMath.sub will throw if there is not enough balance.
1221     balances[msg.sender] = balances[msg.sender].sub(_value);
1222     balances[_to] = balances[_to].add(_value);
1223     Transfer(msg.sender, _to, _value);
1224     return true;
1225   }
1226 
1227   /**
1228   * @dev Gets the balance of the specified address.
1229   * @param _owner The address to query the the balance of.
1230   * @return An uint256 representing the amount owned by the passed address.
1231   */
1232   function balanceOf(address _owner) public view returns (uint256 balance) {
1233     return balances[_owner];
1234   }
1235 
1236 }
1237 
1238 contract StandardToken is ERC20, BasicToken {
1239 
1240   mapping (address => mapping (address => uint256)) internal allowed;
1241 
1242 
1243   /**
1244    * @dev Transfer tokens from one address to another
1245    * @param _from address The address which you want to send tokens from
1246    * @param _to address The address which you want to transfer to
1247    * @param _value uint256 the amount of tokens to be transferred
1248    */
1249   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1250     require(_to != address(0));
1251     require(_value <= balances[_from]);
1252     require(_value <= allowed[_from][msg.sender]);
1253 
1254     balances[_from] = balances[_from].sub(_value);
1255     balances[_to] = balances[_to].add(_value);
1256     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1257     Transfer(_from, _to, _value);
1258     return true;
1259   }
1260 
1261   /**
1262    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1263    *
1264    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1265    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1266    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1267    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1268    * @param _spender The address which will spend the funds.
1269    * @param _value The amount of tokens to be spent.
1270    */
1271   function approve(address _spender, uint256 _value) public returns (bool) {
1272     allowed[msg.sender][_spender] = _value;
1273     Approval(msg.sender, _spender, _value);
1274     return true;
1275   }
1276 
1277   /**
1278    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1279    * @param _owner address The address which owns the funds.
1280    * @param _spender address The address which will spend the funds.
1281    * @return A uint256 specifying the amount of tokens still available for the spender.
1282    */
1283   function allowance(address _owner, address _spender) public view returns (uint256) {
1284     return allowed[_owner][_spender];
1285   }
1286 
1287   /**
1288    * @dev Increase the amount of tokens that an owner allowed to a spender.
1289    *
1290    * approve should be called when allowed[_spender] == 0. To increment
1291    * allowed value is better to use this function to avoid 2 calls (and wait until
1292    * the first transaction is mined)
1293    * From MonolithDAO Token.sol
1294    * @param _spender The address which will spend the funds.
1295    * @param _addedValue The amount of tokens to increase the allowance by.
1296    */
1297   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1298     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1299     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1300     return true;
1301   }
1302 
1303   /**
1304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1305    *
1306    * approve should be called when allowed[_spender] == 0. To decrement
1307    * allowed value is better to use this function to avoid 2 calls (and wait until
1308    * the first transaction is mined)
1309    * From MonolithDAO Token.sol
1310    * @param _spender The address which will spend the funds.
1311    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1312    */
1313   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1314     uint oldValue = allowed[msg.sender][_spender];
1315     if (_subtractedValue > oldValue) {
1316       allowed[msg.sender][_spender] = 0;
1317     } else {
1318       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1319     }
1320     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1321     return true;
1322   }
1323 
1324 }
1325 
1326 
1327 contract DevelopeoERC20 is StandardToken, Ownable {
1328     /* Public variables of the token */
1329     uint256 public creationBlock;
1330 
1331     uint8 public decimals;
1332 
1333     string public name;
1334 
1335     string public symbol;
1336 
1337     string public standard;
1338 
1339     bool public locked;
1340 
1341     /* Initializes contract with initial supply tokens to the creator of the contract */
1342     function DevelopeoERC20(
1343         uint256 _totalSupply,
1344         string _tokenName,
1345         uint8 _decimalUnits,
1346         string _tokenSymbol,
1347         bool _transferAllSupplyToOwner,
1348         bool _locked
1349     ) public {
1350         standard = "ERC20 0.1";
1351         locked = _locked;
1352         totalSupply_ = _totalSupply;
1353 
1354         if (_transferAllSupplyToOwner) {
1355             balances[msg.sender] = totalSupply_;
1356         } else {
1357             balances[this] = totalSupply_;
1358         }
1359         name = _tokenName;
1360         // Set the name for display purposes
1361         symbol = _tokenSymbol;
1362         // Set the symbol for display purposes
1363         decimals = _decimalUnits;
1364         // Amount of decimals for display purposes
1365         creationBlock = block.number;
1366     }
1367 
1368     /* public methods */
1369     function transfer(address _to, uint256 _value) public returns (bool) {
1370         require(locked == false);
1371         return super.transfer(_to, _value);
1372     }
1373 
1374     function approve(address _spender, uint256 _value) public returns (bool success) {
1375         if (locked) {
1376             return false;
1377         }
1378         return super.approve(_spender, _value);
1379     }
1380 
1381     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
1382         if (locked) {
1383             return false;
1384         }
1385         return super.increaseApproval(_spender, _addedValue);
1386     }
1387 
1388     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
1389         if (locked) {
1390             return false;
1391         }
1392         return super.decreaseApproval(_spender, _subtractedValue);
1393     }
1394 
1395     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
1396         if (locked) {
1397             return false;
1398         }
1399 
1400         return super.transferFrom(_from, _to, _value);
1401     }
1402 }
1403 
1404 contract MintingERC20 is DevelopeoERC20 {
1405 
1406     //Variables
1407     mapping (address => bool) public minters;
1408 
1409     uint256 public maxSupply;
1410 
1411     bool public disableMinting;
1412 
1413     //    Modifiers
1414     modifier onlyMinters () {
1415         require(true == minters[msg.sender]);
1416         _;
1417     }
1418 
1419     function MintingERC20(
1420         uint256 _initialSupply,
1421         uint256 _maxSupply,
1422         string _tokenName,
1423         uint8 _decimals,
1424         string _symbol,
1425         bool _transferAllSupplyToOwner,
1426         bool _locked
1427     )
1428     public
1429     DevelopeoERC20(_initialSupply, _tokenName, _decimals, _symbol, _transferAllSupplyToOwner, _locked)
1430     {
1431         standard = "MintingERC20 0.1";
1432         minters[msg.sender] = true;
1433         maxSupply = _maxSupply;
1434     }
1435 
1436     function addMinter(address _newMinter) public onlyOwner {
1437         minters[_newMinter] = true;
1438     }
1439 
1440     function removeMinter(address _minter) public onlyOwner {
1441         minters[_minter] = false;
1442     }
1443 
1444     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
1445         if (true == disableMinting) {
1446             return uint256(0);
1447         }
1448 
1449         if (_amount == uint256(0)) {
1450             return uint256(0);
1451         }
1452 
1453         if (totalSupply_.add(_amount) > maxSupply) {
1454             return uint256(0);
1455         }
1456 
1457         totalSupply_ = totalSupply_.add(_amount);
1458         balances[_addr] = balances[_addr].add(_amount);
1459         Transfer(address(0), _addr, _amount);
1460 
1461         return _amount;
1462     }
1463 }
1464 
1465 
1466 contract Developeo is MintingERC20 {
1467 
1468     uint256 public maxSupply = 600 * uint(10) ** 6 * uint(10) ** 18; // 600,000,000
1469     mapping(address => uint256) public balancesUSD;
1470 
1471     address public founder;
1472     address public team;
1473     address public reward;
1474     address public treasury;
1475     address public bounty;
1476 
1477     bool public founderAndTeamSent;
1478     bool public rewardSent;
1479     bool public treasurySent;
1480     bool public bountySent;
1481 
1482     SellableToken public ico;
1483     SellableToken public preIco;
1484     SellableToken public privateSale;
1485 
1486     // We block token transfers till ICO end. (has to be unfreezed manually by client request)
1487     bool public transferFrozen = true;
1488 
1489     event ContractUpgrade(address newContract);
1490 
1491     modifier onlySellableTokens() {
1492         require(address(0) != msg.sender);
1493         require(owner == msg.sender || ico == msg.sender || preIco == msg.sender || privateSale == msg.sender);
1494         _;
1495     }
1496 
1497     function Developeo(
1498         uint256 _initialSupply,
1499         string _tokenName,
1500         string _tokenSymbol,
1501         address _founder,
1502         address _team,
1503         address _reward,
1504         address _treasury,
1505         address _bounty,
1506         bool _locked
1507     )
1508     public
1509     MintingERC20(_initialSupply, maxSupply, _tokenName, 18, _tokenSymbol, false, _locked)
1510     {
1511         require(
1512             _founder != address(0)
1513             && _team != address(0)
1514             && _reward != address(0)
1515             && _treasury != address(0)
1516             && _bounty != address(0)
1517         );
1518         standard = "Developeo 0.1";
1519         founder = _founder;
1520         team = _team;
1521         reward = _reward;
1522         treasury = _treasury;
1523         bounty = _bounty;
1524     }
1525 
1526     function setICO(address _ico) public onlyOwner {
1527         require(_ico != address(0));
1528         ico = SellableToken(_ico);
1529         ContractUpgrade(_ico);
1530     }
1531 
1532     function setPreICO(address _preIco) public onlyOwner {
1533         require(_preIco != address(0));
1534         preIco = SellableToken(_preIco);
1535         ContractUpgrade(_preIco);
1536     }
1537 
1538     function setPrivateSale(address _privateSale) public onlyOwner {
1539         require(_privateSale != address(0));
1540         privateSale = SellableToken(_privateSale);
1541         ContractUpgrade(_privateSale);
1542     }
1543 
1544     function moveUnsoldTokens(SellableToken _tokenFrom, SellableToken _tokenTo) public onlyOwner {
1545         uint256 increaseAmount = _tokenFrom.calculateUnsoldTokens();
1546         if (increaseAmount > 0) {
1547             _tokenTo.updateMaxSupply(increaseAmount);
1548             _tokenFrom.burnUnsoldTokens();
1549         }
1550     }
1551 
1552     function setBalancesUSD(address _address, uint256 _value) public onlySellableTokens {
1553         require(_address != address(0));
1554         balancesUSD[_address] = _value;
1555     }
1556 
1557     /*
1558      Manually burn unused tokens.
1559      the date has to be after ICO
1560     */
1561     function burnUnusedTokens() public onlyOwner {
1562         if (address(ico) != address(0) && !ico.isActive()) {
1563             //            prevent run before ICO
1564             if (block.timestamp >= ico.startTime()) {
1565                 disableMinting = true;
1566             }
1567         }
1568     }
1569 
1570     // prevent manual minting tokens when ICO is active;
1571     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
1572         if (msg.sender == owner) {
1573             require(address(ico) != address(0));
1574             if (!ico.isActive()) {
1575                 return super.mint(_addr, _amount);
1576             }
1577             return uint256(0);
1578         }
1579         return super.mint(_addr, _amount);
1580     }
1581 
1582     function setLocked(bool _locked) public onlyOwner {
1583         locked = _locked;
1584     }
1585 
1586     // Allow token transfer.
1587     function freezing(bool _transferFrozen) public onlyOwner {
1588         if (address(ico) != address(0) && !ico.isActive()) {
1589             //            prevent run before ICO
1590             if (block.timestamp >= ico.startTime()) {
1591                 transferFrozen = _transferFrozen;
1592             }
1593         }
1594     }
1595 
1596     function transferAllowed(address _address) public constant returns (bool) {
1597         if (bounty == _address || reward == _address) {
1598             return true;
1599         }
1600         if (true == transferFrozen) {
1601             return false;
1602         }
1603         if (balancesUSD[_address] >= uint(100000).mul(10 ** 5).mul(10 ** 18)) {
1604             return ico.endTime().add(uint(3).mul(2592000)) <= block.timestamp;
1605         }
1606         return true;
1607     }
1608 
1609     // ERC20 functions
1610     // =========================
1611     function transfer(address _to, uint _value) public returns (bool) {
1612         require(transferAllowed(msg.sender));
1613         return super.transfer(_to, _value);
1614     }
1615 
1616     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
1617         require(transferAllowed(_from));
1618         return super.transferFrom(_from, _to, _value);
1619     }
1620 
1621     function burnInvestorTokens(address _address) public returns (uint256) {
1622         if (address(ico) == msg.sender || address(preIco) == msg.sender || address(privateSale) == msg.sender) {
1623           return  balances[_address] = 0;
1624         }
1625         return 0;
1626     }
1627 
1628     function sendFounderAndTeamTokens() public onlyOwner {
1629         if (
1630             address(ico) != address(0)
1631             && !ico.isActive()
1632             && uint256(block.timestamp) >= ico.endTime().add(uint(30 days))
1633             && false == founderAndTeamSent
1634         ) {
1635             uint256 tokenAmount =  20 * uint(10) ** 6 * uint(10) ** 18;
1636             uint256 mintedAmount = super.mint(founder, tokenAmount);
1637             require(mintedAmount == tokenAmount);
1638             tokenAmount = 5 * uint(10) ** 6 * uint(10) ** 18;
1639             mintedAmount = super.mint(team, tokenAmount);
1640             require(mintedAmount == tokenAmount);
1641             founderAndTeamSent = true;
1642         }
1643     }
1644 
1645     function sendRewardTokens() public onlyOwner {
1646         if (address(ico) != address(0) && block.timestamp > ico.startTime() && false == rewardSent) {
1647             uint256 tokenAmount =  60 * uint(10) ** 6 * uint(10) ** 18;
1648             uint256 mintedAmount = super.mint(reward, tokenAmount);
1649             require(mintedAmount == tokenAmount);
1650             rewardSent = true;
1651         }
1652     }
1653 
1654     function sendTreasuryTokens() public onlyOwner {
1655         if (
1656             address(ico) != address(0)
1657             && !ico.isActive()
1658             && block.timestamp >= ico.endTime()
1659             && false == treasurySent
1660         ) {
1661             uint256 tokenAmount =  20 * uint(10) ** 6 * uint(10) ** 18;
1662             uint256 mintedAmount = super.mint(treasury, tokenAmount);
1663             require(mintedAmount == tokenAmount);
1664             treasurySent = true;
1665         }
1666     }
1667 
1668     function sendBountyTokens() public onlyOwner {
1669         if (
1670             address(privateSale) != address(0)
1671             && block.timestamp >= privateSale.startTime()
1672             && false == bountySent
1673         ) {
1674             uint256 tokenAmount =  15 * uint(10) ** 6 * uint(10) ** 18;
1675             uint256 mintedAmount = super.mint(bounty, tokenAmount);
1676             require(mintedAmount == tokenAmount);
1677             bountySent = true;
1678         }
1679     }
1680 }
1681 
1682 
1683 contract SellableToken is Multivest {
1684 
1685     uint256 public constant DEV_DECIMALS = 10 ** 18;
1686     // The token being sold
1687     Developeo public developeo;
1688 
1689     // start and end timestamps where investments are allowed (both inclusive)
1690     uint256 public startTime;
1691     uint256 public endTime;
1692 
1693     uint256 public maxTokenSupply;
1694 
1695     // amount of sold tokens
1696     uint256 public soldTokens;
1697 
1698     // amount of raised money in wei
1699     uint256 public collectedEthers;
1700 
1701     // amount of raised money in USD * 10**18
1702     uint256 public collectedUSD;
1703 
1704     uint256 public priceUpdateAt;
1705 
1706     address public etherHolder;
1707 
1708     Bonus[] public bonuses;
1709 
1710     struct Bonus {
1711         uint256 minAmount;
1712         uint256 maxAmount;
1713         uint256 bonus;
1714     }
1715 
1716     event NewOraclizeQuery(string _description);
1717     event NewDevelopeoPriceTicker(string _price);
1718 
1719     modifier onlyDevelopeo() {
1720         require(msg.sender == address(developeo));
1721         _;
1722     }
1723 
1724     function SellableToken(
1725         address _multivestAddress,
1726         address _developeo,
1727         address _etherHolder,
1728         uint256 _startTime,
1729         uint256 _endTime,
1730         uint256 _etherPriceInUSD,
1731         uint256 _maxTokenSupply
1732     ) public Multivest(_multivestAddress)
1733     {
1734         require(_developeo != address(0));
1735         developeo = Developeo(_developeo);
1736 
1737         require((_startTime < _endTime));
1738             //        replace  it with your own
1739         etherHolder = _etherHolder;
1740         require((_maxTokenSupply == uint256(0)) || (_maxTokenSupply <= developeo.maxSupply()));
1741 
1742         startTime = _startTime;
1743         endTime = _endTime;
1744         etherPriceInUSD = _etherPriceInUSD;
1745         maxTokenSupply = _maxTokenSupply;
1746 
1747         priceUpdateAt = block.timestamp;
1748        oraclize_setNetwork(networkID_auto);
1749        oraclize = OraclizeI(OAR.getAddress());
1750 
1751     }
1752 
1753     // @return true if sale period is active
1754     function isActive() public constant returns (bool) {
1755         if (maxTokenSupply > uint256(0) && soldTokens == maxTokenSupply) {
1756             return false;
1757         }
1758         return withinPeriod();
1759     }
1760 
1761     function setDevelopeo(address _developeo) public onlyOwner {
1762         require(_developeo != address(0));
1763         developeo = Developeo(_developeo);
1764     }
1765 
1766     function calculateUnsoldTokens() public view onlyDevelopeo returns (uint256) {
1767         if (
1768         (maxTokenSupply == 0)
1769         || block.timestamp <= endTime
1770         || (maxTokenSupply > uint256(0) && soldTokens == maxTokenSupply)
1771         ) {
1772             return uint256(0);
1773         }
1774         return maxTokenSupply.sub(soldTokens);
1775     }
1776 
1777     function burnUnsoldTokens() public onlyDevelopeo {
1778         maxTokenSupply = soldTokens;
1779     }
1780 
1781     function updateMaxSupply(uint256 _increaseAmount) public onlyDevelopeo {
1782         maxTokenSupply = maxTokenSupply.add(_increaseAmount);
1783     }
1784 
1785     // set ether price in USD with 5 digits after the decimal point
1786     //ex. 308.75000
1787     //for updating the price through  multivest
1788     function setEtherInUSD(string _price) public onlyAllowedMultivests {
1789         bytes memory bytePrice = bytes(_price);
1790         uint256 dot = bytePrice.length.sub(uint256(6));
1791 
1792         // check if dot is in 6 position  from  the last
1793         require(0x2e == uint(bytePrice[dot]));
1794 
1795         uint256 newPrice = uint256(10 ** 23).div(parseInt(_price, 5));
1796 
1797         require(newPrice > 0);
1798 
1799         etherPriceInUSD = parseInt(_price, 5);
1800 
1801         priceUpdateAt = block.timestamp;
1802 
1803         NewDevelopeoPriceTicker(_price);
1804     }
1805 
1806     function setEtherHolder(address _etherHolder) public onlyOwner {
1807         require(_etherHolder != address(0));
1808         etherHolder = _etherHolder;
1809     }
1810 
1811     function transferEthers() public onlyOwner {
1812         require(etherHolder != address(0));
1813         etherHolder.transfer(this.balance);
1814     }
1815 
1816     function mint(address _address, uint256 _tokenAmount) public onlyOwner returns (uint256) {
1817         return mintInternal(_address, _tokenAmount);
1818     }
1819 
1820     // @return true if the transaction can buy tokens
1821     function withinPeriod() public constant returns (bool) {
1822         return block.timestamp >= startTime && block.timestamp <= endTime;
1823     }
1824 
1825     function __callback(bytes32, string _result, bytes) public {
1826         require(msg.sender == oraclize_cbAddress());
1827         uint256 result = parseInt(_result, 5);
1828         uint256 newPrice = uint256(10 ** 23).div(result);
1829         require(newPrice > 0);
1830 //       not update when increasing/decreasing in 3 times
1831         if (result.div(3) < etherPriceInUSD || result.mul(3) > etherPriceInUSD) {
1832             etherPriceInUSD = result;
1833 
1834             NewDevelopeoPriceTicker(_result);
1835         }
1836 
1837     }
1838 
1839     function update() internal {
1840         if (oraclize_getPrice("URL") > this.balance) {
1841             NewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1842         } else {
1843             NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1844             oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1845         }
1846     }
1847 
1848     function mintInternal(address _address, uint256 _tokenAmount) internal returns (uint256) {
1849         uint256 mintedAmount = developeo.mint(_address, _tokenAmount);
1850         require(mintedAmount == _tokenAmount);
1851         soldTokens = soldTokens.add(_tokenAmount);
1852         if (maxTokenSupply > 0) {
1853             require(maxTokenSupply >= soldTokens);
1854         }
1855 
1856         return _tokenAmount;
1857     }
1858 }
1859 
1860 contract PrivateSale is SellableToken {
1861 
1862     mapping (address => uint256) public etherBalances;
1863     uint256 public softCap = 500 ether;
1864     Tier[] public tiers;
1865 
1866     struct Tier {
1867         uint256 maxAmount;
1868         uint256 price;
1869     }
1870 
1871     event Refund(address _holder, uint256 _ethers, uint256 _tokens);
1872 
1873     function PrivateSale(
1874         address _multivestAddress,
1875         address _developeo,
1876         address _etherHolder,
1877         uint256 _startTime, //1426413600 03/15/2015 @ 10:00am (UTC)
1878         uint256 _endTime, //1524996000  04/29/2018 @ 10:00am (UTC)
1879         uint256 _etherPriceInUSD, // if price 709.38000 the  value has to be 70938000
1880         uint256 _maxTokenSupply //uint256(130000000).mul(10 ** 18) = 130000000000000000000000000
1881     ) public SellableToken(
1882         _multivestAddress,
1883         _developeo,
1884         _etherHolder,
1885         _startTime,
1886         _endTime,
1887         _etherPriceInUSD,
1888         _maxTokenSupply
1889     ) {
1890 
1891         bonuses.push(Bonus(
1892             uint(10000).mul(10**5).mul(10**18),
1893             uint(49999).mul(10**5).mul(10**18),
1894             uint256(10)
1895         ));//10%
1896         bonuses.push(Bonus(
1897             uint(50000).mul(10**5).mul(10**18),
1898             uint(99999).mul(10**5).mul(10**18),
1899             uint256(15)
1900         ));//15%
1901         bonuses.push(Bonus(
1902             uint(100000).mul(10**5).mul(10**18),
1903             uint(199999).mul(10**5).mul(10**18),
1904             uint256(20)
1905         ));//20%
1906         bonuses.push(Bonus(
1907             uint(200000).mul(10**5).mul(10**18),
1908             uint(499999).mul(10**5).mul(10**18),
1909             uint256(25)
1910         ));//25%
1911         bonuses.push(Bonus(
1912             uint(500000).mul(10**5).mul(10**18),
1913             0,
1914             uint256(40)
1915         ));//40%
1916 
1917         tiers.push(Tier(
1918             uint256(1000000).mul(10**5).mul(10 ** 18),
1919             uint256(5) //0.05
1920         ));
1921         tiers.push(Tier(
1922             uint256(2000000).mul(10**5).mul(10 ** 18),
1923             uint256(7) //0.07
1924         ));
1925         tiers.push(Tier(
1926             uint256(3000000).mul(10**5).mul(10 ** 18),
1927             uint256(9) //0.09
1928         ));
1929         tiers.push(Tier(
1930             uint256(0),
1931             uint256(11) //0.11
1932         ));
1933 
1934     }
1935 
1936     /* public methods */
1937     function() public payable {
1938         require(buy(msg.sender, msg.value, false) == true);
1939     }
1940 
1941     function refund() public returns (bool) {
1942         if (!isRefundPossible() || etherBalances[msg.sender] == 0) {
1943             return false;
1944         }
1945 
1946         msg.sender.transfer(etherBalances[msg.sender]);
1947 
1948         uint256 burnedAmount = developeo.burnInvestorTokens(msg.sender);
1949 
1950         if (burnedAmount == 0) {
1951             return false;
1952         }
1953 
1954         Refund(msg.sender, etherBalances[msg.sender], burnedAmount);
1955         etherBalances[msg.sender] = 0;
1956 
1957         return true;
1958     }
1959 
1960     function transferEthers() public onlyOwner {
1961         if (collectedEthers >= softCap) {
1962             super.transferEthers();
1963         }
1964     }
1965 
1966     //  returns  tokens amount and  value of  USD
1967     function calculateTokensAmount (
1968         uint256 _value
1969     ) public constant returns (uint256, uint256) {
1970         if (_value == 0) {
1971             return (0, 0);
1972         }
1973         uint256 amountInUSD = internalCalculateEthersWithBonus(_value).mul(etherPriceInUSD);
1974         if (amountInUSD == 0) {
1975             return (0, 0);
1976         }
1977         uint256 tokenAmount;
1978         uint256 usdAmount;
1979         (tokenAmount, usdAmount) = calculateInternalTokensAmount(amountInUSD, collectedUSD, soldTokens);
1980 
1981         return (tokenAmount, usdAmount);
1982     }
1983 
1984     function isRefundPossible() public view returns (bool) {
1985         if (isActive() || block.timestamp < startTime || collectedEthers >= softCap) {
1986             return false;
1987         }
1988         return true;
1989     }
1990 
1991     function buy(address _address, uint256 _value, bool _isUSD) internal returns (bool) {
1992         if (_value == 0) {
1993             return false;
1994 
1995         }
1996         require(withinPeriod());
1997         require(_address != address(0));
1998 
1999         if (priceUpdateAt.add(60 minutes) < block.timestamp) {
2000             update();
2001             priceUpdateAt = block.timestamp;
2002         }
2003         uint256 tokenAmount;
2004         uint256 usdAmount;
2005         if (false == _isUSD) {
2006             (tokenAmount, usdAmount) = calculateTokensAmount(_value);
2007         } else {
2008             (tokenAmount, usdAmount) = calculateInternalTokensAmount(
2009                 calculateUSDWithBonus(_value),
2010                 collectedUSD,
2011                 soldTokens
2012             );
2013             usdAmount = _value;
2014             _value = usdAmount.mul(10**18).div(etherPriceInUSD);
2015 
2016         }
2017         require(tokenAmount > 0);
2018         uint256 mintedAmount = mintInternal(_address, tokenAmount);
2019         require(mintedAmount == tokenAmount);
2020 
2021         collectedUSD = collectedUSD.add(usdAmount);
2022         developeo.setBalancesUSD(_address, developeo.balancesUSD(_address).add(usdAmount));
2023         collectedEthers = collectedEthers.add(_value);
2024         etherBalances[msg.sender] = etherBalances[msg.sender].add(_value);
2025         Contribution(_address, _value, tokenAmount);
2026 
2027         return true;
2028     }
2029 
2030     function internalCalculateEthersWithBonus(uint256 _amount) internal view returns (uint256) {
2031         uint256 etherAmount = _amount;
2032         uint256 amountInUSD = _amount.mul(etherPriceInUSD);
2033         for (uint8 i = 0; i < bonuses.length; i++) {
2034             Bonus storage bonus = bonuses[i];
2035             if (bonus.minAmount <= amountInUSD && (bonus.maxAmount == 0 || bonus.maxAmount >= amountInUSD)) {
2036                 etherAmount = _amount.add(_amount.mul(bonus.bonus).div(100));
2037                 break;
2038             }
2039 
2040         }
2041 
2042         return etherAmount;
2043     }
2044 
2045     function calculateInternalTokensAmount(
2046         uint256 _amountInUSD,
2047         uint256 _collectedUSD,
2048         uint256 _soldTokens
2049     ) internal view returns (uint256, uint256) {
2050 
2051         uint256 newCollectedUSD = _collectedUSD;
2052         uint256 newSoldTokens = _soldTokens;
2053         for (uint i = 0; i < tiers.length; i++) {
2054             Tier storage tier = tiers[i];
2055             if (tier.maxAmount > newCollectedUSD || tier.maxAmount == 0) {
2056                 if (newCollectedUSD + _amountInUSD > tier.maxAmount && tier.maxAmount != 0) {
2057                     uint256 diffInUSD = tier.maxAmount.sub(newCollectedUSD);
2058                     newCollectedUSD = newCollectedUSD.add(diffInUSD);
2059                     _amountInUSD = _amountInUSD.sub(diffInUSD);
2060                     newSoldTokens = newSoldTokens.add(diffInUSD.div(10 ** 3).div(tier.price));
2061                 } else {
2062                     newSoldTokens = newSoldTokens.add(_amountInUSD.div(10 ** 3).div(tier.price));
2063                     newCollectedUSD = newCollectedUSD.add(_amountInUSD);
2064                     _amountInUSD = 0;
2065                 }
2066             }
2067             if (_amountInUSD == 0) {
2068                 break;
2069             }
2070         }
2071         uint256 tokensAmount = newSoldTokens.sub(_soldTokens);
2072 
2073         if (_soldTokens.add(tokensAmount) <= maxTokenSupply) {
2074             return (tokensAmount, newCollectedUSD.sub(_collectedUSD));
2075         }
2076         return (0, 0);
2077     }
2078 
2079     function calculateUSDWithBonus(uint256 _amount) internal constant returns (uint256) {
2080         uint256 amountInUSD = _amount;
2081         for (uint8 i = 0; i < bonuses.length; i++) {
2082             Bonus storage bonus = bonuses[i];
2083             if (bonus.minAmount <= _amount && (bonus.maxAmount == 0 || bonus.maxAmount >= _amount)) {
2084                 return _amount.add(_amount.mul(bonus.bonus).div(100));
2085             }
2086 
2087         }
2088 
2089         return amountInUSD;
2090     }
2091 }