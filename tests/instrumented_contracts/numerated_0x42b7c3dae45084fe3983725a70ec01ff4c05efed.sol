1 pragma solidity ^0.4.19;
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
996             // NOTE: we can reuse the request memory because we deal with
997             //       the return code
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
1012           return (false, 0);
1013 
1014         // The signature format is a compact form of:
1015         //   {bytes32 r}{bytes32 s}{uint8 v}
1016         // Compact means, uint8 is not padded to 32 bytes.
1017         assembly {
1018             r := mload(add(sig, 32))
1019             s := mload(add(sig, 64))
1020 
1021             // Here we are loading the last 32 bytes. We exploit the fact that
1022             // 'mload' will pad with zeroes if we overread.
1023             // There is no 'mload8' to do this, but that would be nicer.
1024             v := byte(0, mload(add(sig, 96)))
1025 
1026             // Alternative solution:
1027             // 'byte' is not working due to the Solidity parser, so lets
1028             // use the second best option, 'and'
1029             // v := and(mload(add(sig, 65)), 255)
1030         }
1031 
1032         // albeit non-transactional signatures are not specified by the YP, one would expect it
1033         // to match the YP range of [27, 28]
1034         //
1035         // geth uses [0, 1] and some clients have followed. This might change, see:
1036         //  https://github.com/ethereum/go-ethereum/issues/2053
1037         if (v < 27)
1038           v += 27;
1039 
1040         if (v != 27 && v != 28)
1041             return (false, 0);
1042 
1043         return safer_ecrecover(hash, v, r, s);
1044     }
1045 
1046 }
1047 // </ORACLIZE_API>
1048 contract Raffle is usingOraclize
1049 {
1050 	struct Player
1051 	{
1052 		address playerAddress;
1053 		uint entry;
1054 		uint startTotal;
1055 	}
1056 	
1057 	// TODO - solidity doesn't support returning of structs (yet)
1058 	/*
1059 	struct Winner
1060 	{
1061 		address playerAddress;
1062 		uint entry;
1063 		uint prize;
1064 		uint64 timestamp;
1065 	}
1066 	*/
1067 	
1068 	uint8 constant public VERSION = 5;
1069 	uint8 constant public ROUND_DATA_COUNT = 2; // keeping data for 2 rounds should be enough
1070 	uint8 constant public RANDOMIZER_RETRY_COUNT = 3; // just in case oraclize callback fails
1071 	uint8 constant public RANDOM_BYTES_COUNT = 32; // a 256-bit int
1072 	uint8 constant public MAX_FEE_PERCENTAGE = 10; // safeguard so fee can't ever be more than 10%
1073 	uint8 constant public MAX_RANDOM_DELAY = 120; // 120 is max according to this: https://github.com/oraclize/ethereum-api/issues/22#issuecomment-365029344
1074 
1075 	// systematic variables
1076 	address owner;
1077 	uint funds = 0;
1078 	bool running = false;
1079 	bool oraclizeQueued = false;
1080 	bool currentRoundFinishing = false;
1081 	// functional variables
1082 	Player[][ROUND_DATA_COUNT] roundPlayers;
1083 	mapping(address => uint)[ROUND_DATA_COUNT] roundEntries;
1084 	uint[ROUND_DATA_COUNT] roundTotals;
1085 	uint8 currentRoundIndex = 0;
1086 	uint8 currentRandomizerAttempt = 0;
1087 	// configuration
1088 	uint64 roundStartTime = 0;
1089 	uint32 roundLength = 0;
1090 	// dynamic configuration
1091 	uint minimumBet = 1 finney;
1092 	uint nextMinimumBet = 0;
1093 	bool queuedMinimumBet = false;
1094 	uint32 maximumPlayers = 0;
1095 	uint32 nextMaximumPlayers = 0;
1096 	bool queuedMaximumPlayers = false;
1097 	uint8 feePercentage = 1;
1098 	uint8 nextFeePercentage = 0;
1099 	bool queuedFeePercentage = false;
1100 	// oraclize configuration
1101 	uint oraclizeRoundGasFee = 200000;
1102 	uint oraclizeWinnerGasFee = 500000;
1103 	uint oraclizeGasPrice = 0;
1104 	uint8 oraclizeWinnerTimeOffset = 30;
1105 	// public variables
1106 	// TODO - solidity doesn't support returning of structs (yet)
1107 	address[] pastWinnerAddresses;
1108 	uint[] pastWinnerEntries;
1109 	uint[] pastWinnerPrizes;
1110 	uint64[] pastWinnerTimestamps;
1111 	
1112 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1113 	// Construct / Destruct
1114 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1115 	
1116 	// note: gas price is in gwei!
1117 	function Raffle(uint64 _roundStartTime, uint32 _roundLength, uint _oraclizeGasPrice) public payable
1118 	{
1119 		require(_oraclizeGasPrice > 0);
1120 		owner = msg.sender;
1121 		roundStartTime = _roundStartTime;
1122 		roundLength = _roundLength;
1123 		funds += msg.value;
1124 		oraclizeGasPrice = _oraclizeGasPrice * 1000000000;
1125 		oraclize_setCustomGasPrice(oraclizeGasPrice);
1126 		oraclize_setProof(proofType_Ledger);
1127 	}
1128 	
1129 	function destroyContract() public
1130 	{
1131 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1132 		require(msg.sender == owner);
1133 		_abortAllRounds();
1134 		selfdestruct(owner);
1135 	}
1136 	
1137 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1138 	// Owner Properties
1139 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1140 	
1141 	function isRunning() public view returns (bool)
1142 	{
1143 		return running;
1144 	}
1145 	
1146 	function isOraclizeQueued() public view returns (bool)
1147 	{
1148 		return oraclizeQueued;
1149 	}
1150 	
1151 	function getFunds() public view returns (uint)
1152 	{
1153 		return funds;
1154 	}
1155 	
1156 	function getRoundLength() public view returns (uint32)
1157 	{
1158 		return roundLength;
1159 	}
1160 	
1161 	function setRoundLength(uint32 value) public
1162 	{
1163 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1164 		require(msg.sender == owner);
1165 		require(value >= 300); // not allowed under 5 minutes
1166 		roundLength = value;
1167 	}
1168 
1169 	function getMinimumBet() public view returns (uint)
1170 	{
1171 		return minimumBet;
1172 	}
1173 	
1174 	function getNextMinimumBet() public view returns (uint)
1175 	{
1176 		return nextMinimumBet;
1177 	}
1178 	
1179 	function getMaximumPlayers() public view returns (uint32)
1180 	{
1181 		return maximumPlayers;
1182 	}
1183 	
1184 	function getNextMaximumPlayers() public view returns (uint32)
1185 	{
1186 		return nextMaximumPlayers;
1187 	}
1188 	
1189 	function getFeePercentage() public view returns (uint8)
1190 	{
1191 		return feePercentage;
1192 	}
1193 	
1194 	function getNextFeePercentage() public view returns (uint8)
1195 	{
1196 		return nextFeePercentage;
1197 	}
1198 	
1199 	function getOraclizeGasPrice() public view returns (uint)
1200 	{
1201 		return oraclizeGasPrice;
1202 	}
1203 	
1204 	function setOraclizeGasPrice(uint value) public
1205 	{
1206 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1207 		require(msg.sender == owner);
1208 		require(value > 0);
1209 		oraclizeGasPrice = value;
1210 		oraclize_setCustomGasPrice(value);
1211 	}
1212 	
1213 	function getOraclizeRoundGasFee() public view returns (uint)
1214 	{
1215 		return oraclizeRoundGasFee;
1216 	}
1217 	
1218 	function setOraclizeRoundGasFee(uint value) public
1219 	{
1220 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1221 		require(msg.sender == owner);
1222 		require(value > 0);
1223 		oraclizeRoundGasFee = value;
1224 	}
1225 	
1226 	function getOraclizeWinnerGasFee() public view returns (uint)
1227 	{
1228 		return oraclizeWinnerGasFee;
1229 	}
1230 	
1231 	function setOraclizeWinnerGasFee(uint value) public
1232 	{
1233 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1234 		require(msg.sender == owner);
1235 		require(value > 0);
1236 		oraclizeWinnerGasFee = value;
1237 	}
1238 	
1239 	function getOraclizeWinnerTimeOffset() public view returns (uint8)
1240 	{
1241 		return oraclizeWinnerTimeOffset;
1242 	}
1243 	
1244 	function setOraclizeWinnerTimeOffset(uint8 value) public
1245 	{
1246 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1247 		require(msg.sender == owner);
1248 		require(value <= MAX_RANDOM_DELAY);
1249 		oraclizeWinnerTimeOffset = value;
1250 	}
1251 	
1252 	function getRoundFunds() public view returns (uint)
1253 	{
1254 		return (funds / ((oraclizeRoundGasFee + oraclizeWinnerGasFee) * oraclizeGasPrice));
1255 	}
1256 	
1257 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1258 	// General Properties
1259 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1260 	
1261 	function isCurrentRoundFinishing() public view returns (bool)
1262 	{
1263 		return currentRoundFinishing;
1264 	}
1265 	
1266 	function getCurrentRoundEntry() public view returns (uint)
1267 	{
1268 		return roundEntries[currentRoundIndex][msg.sender];
1269 	}
1270 	
1271 	function getCurrentRoundTotal() public view returns (uint)
1272 	{
1273 		return roundTotals[currentRoundIndex];
1274 	}
1275 	
1276 	// TODO - solidity doesn't support returning of structs
1277 	function getPastWinnerAddresses() public view returns (address[])
1278 	{
1279 		return pastWinnerAddresses;
1280 	}
1281 	
1282 	function getPastWinnerEntries() public view returns (uint[])
1283 	{
1284 		return pastWinnerEntries;
1285 	}
1286 	
1287 	function getPastWinnerPrizes() public view returns (uint[])
1288 	{
1289 		return pastWinnerPrizes;
1290 	}
1291 	
1292 	function getPastWinnerTimestamps() public view returns (uint64[])
1293 	{
1294 		return pastWinnerTimestamps;
1295 	}
1296 	
1297 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1298 	// Private Methods
1299 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1300 
1301 	function _abortCurrentRound() internal
1302 	{
1303 		currentRoundFinishing = false;
1304 		Player[] storage players = roundPlayers[currentRoundIndex];
1305 		for (uint32 i = 0; i < players.length; ++i)
1306 		{
1307 			address playerAddress = players[i].playerAddress;
1308 			uint amount = roundEntries[currentRoundIndex][playerAddress];
1309 			if (amount > 0)
1310 			{
1311 				roundEntries[currentRoundIndex][playerAddress] = 0;
1312 				playerAddress.transfer(amount);
1313 			}
1314 		}
1315 		players.length = 0;
1316 		roundTotals[currentRoundIndex] = 0;
1317 		_startNextRound();
1318 	}
1319 	
1320 	function _abortAllRounds() internal
1321 	{
1322 		currentRoundFinishing = false;
1323 		for (uint8 j = 0; j < ROUND_DATA_COUNT; ++j)
1324 		{
1325 			Player[] storage players = roundPlayers[j];
1326 			for (uint32 i = 0; i < players.length; ++i)
1327 			{
1328 				address playerAddress = players[i].playerAddress;
1329 				uint amount = roundEntries[j][playerAddress];
1330 				if (amount > 0)
1331 				{
1332 					roundEntries[j][playerAddress] = 0;
1333 					playerAddress.transfer(amount);
1334 				}
1335 			}
1336 			players.length = 0;
1337 			roundTotals[j] = 0;
1338 		}
1339 	}
1340 	
1341 	function _startNextRound() internal
1342 	{
1343 		currentRoundIndex = (currentRoundIndex + 1) % ROUND_DATA_COUNT;
1344 		if (queuedMinimumBet)
1345 		{
1346 			queuedMinimumBet = false;
1347 			minimumBet = nextMinimumBet;
1348 		}
1349 		if (queuedMaximumPlayers)
1350 		{
1351 			queuedMaximumPlayers = false;
1352 			maximumPlayers = nextMaximumPlayers;
1353 		}
1354 		if (queuedFeePercentage)
1355 		{
1356 			queuedFeePercentage = false;
1357 			feePercentage = nextFeePercentage;
1358 		}
1359 	}
1360 	
1361 	function _calcRemainingRoundTime() internal view returns (uint)
1362 	{
1363 		return (roundStartTime + ((block.timestamp - roundStartTime + roundLength) / roundLength) * roundLength - block.timestamp);
1364 	}
1365 	
1366 	function _canPayOraclize(uint gasFee) internal view returns (bool)
1367 	{
1368 		return (gasFee > 0 && funds >= oraclizeGasPrice * gasFee);
1369 	}
1370 	
1371 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1372 	// Public Methods
1373 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1374 	
1375 	function() public payable
1376 	{
1377 		require(false); // disable sending transactions directly
1378 	}
1379 	
1380 	function changeMinimumBet(uint value) public
1381 	{
1382 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1383 		require(msg.sender == owner);
1384 		nextMinimumBet = value;
1385 		queuedMinimumBet = true;
1386 	}
1387 	
1388 	function changeMaximumPlayers(uint32 value) public
1389 	{
1390 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1391 		require(msg.sender == owner);
1392 		nextMaximumPlayers = value;
1393 		queuedMaximumPlayers = true;
1394 	}
1395 	
1396 	function changeFeePercentage(uint8 value) public
1397 	{
1398 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1399 		require(msg.sender == owner);
1400 		require(value <= MAX_FEE_PERCENTAGE);
1401 		nextFeePercentage = value;
1402 		queuedFeePercentage = true;
1403 	}
1404 	
1405 	function addFunds() public payable
1406 	{
1407 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1408 		require(msg.sender == owner);
1409 		funds += msg.value;
1410 	}
1411 	
1412 	function withdrawFunds(uint value) public
1413 	{
1414 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1415 		require(msg.sender == owner);
1416 		require(funds >= value);
1417 		funds -= value;
1418 		owner.transfer(value);
1419 	}
1420 	
1421 	function startRound(bool ignoreOraclize) public
1422 	{
1423 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1424 		require(msg.sender == owner);
1425 		require(oraclizeGasPrice > 0);
1426 		require(!running);
1427 		running = true;
1428 		if (!oraclizeQueued || ignoreOraclize)
1429 		{
1430 			if (currentRoundFinishing)
1431 			{
1432 				_oraclizeQueueWinner(false);
1433 			}
1434 			else
1435 			{
1436 				_oraclizeQueueRound();
1437 			}
1438 		}
1439 	}
1440 	
1441 	function stopRound(bool abortRound) public
1442 	{
1443 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1444 		require(msg.sender == owner);
1445 		require(running);
1446 		running = false;
1447 		if (abortRound)
1448 		{
1449 			_abortCurrentRound();
1450 		}
1451 	}
1452 	
1453 	function restartRound(bool ignoreOraclize, bool forceAbortRound) public
1454 	{
1455 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1456 		require(msg.sender == owner);
1457 		require(oraclizeGasPrice > 0);
1458 		require(running);
1459 		if (forceAbortRound)
1460 		{
1461 			_abortCurrentRound();
1462 		}
1463 		if (!oraclizeQueued || ignoreOraclize)
1464 		{
1465 			if (currentRoundFinishing)
1466 			{
1467 				_oraclizeQueueWinner(false);
1468 			}
1469 			else
1470 			{
1471 				_oraclizeQueueRound();
1472 			}
1473 		}
1474 	}
1475 	
1476 	function manualFinalizeRound() public
1477 	{
1478 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1479 		require(msg.sender == owner);
1480 		require(running);
1481 		require(!currentRoundFinishing);
1482 		_finalizeRound();
1483 	}
1484 	
1485 	function enterCurrentRound() public payable
1486 	{
1487 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1488 		require(msg.value >= minimumBet);
1489 		require(running);
1490 		uint index = currentRoundIndex;
1491 		if (currentRoundFinishing)
1492 		{
1493 			index = (index + 1) % ROUND_DATA_COUNT;
1494 		}
1495 		require(maximumPlayers == 0 || roundPlayers[index].length < maximumPlayers);
1496 		roundPlayers[index].push(Player(msg.sender, msg.value, roundTotals[index]));
1497 		roundEntries[index][msg.sender] += msg.value;
1498 		roundTotals[index] += msg.value;
1499 	}
1500 
1501 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1502 	// Oraclize Callbacks
1503 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1504 	
1505 	function __callback(bytes32 _queryId, string _result, bytes _proof) public
1506 	{
1507 		require(owner != 0x0); // makes sure a destroyed contract doesn't accept transactions
1508 		require(msg.sender == oraclize_cbAddress());
1509 		oraclizeQueued = false;
1510 		if (running)
1511 		{
1512 			if (!currentRoundFinishing)
1513 			{
1514 				_finalizeRound();
1515 			}
1516 			else if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0)
1517 			{
1518 				_selectWinner(uint(keccak256(_result)));
1519 			}
1520 			else if (currentRandomizerAttempt < RANDOMIZER_RETRY_COUNT) // verification failed, attempt to restart
1521 			{
1522 				_oraclizeQueueWinner(true);
1523 			}
1524 			else
1525 			{
1526 				running = false;
1527 			}
1528 		}
1529 	}
1530 
1531 	function _oraclizeQueueRound() internal
1532 	{
1533 		if (_canPayOraclize(oraclizeRoundGasFee))
1534 		{
1535 			oraclizeQueued = true;
1536 			// just need a callback, don't care about the result
1537 			funds -= oraclizeRoundGasFee * oraclizeGasPrice;
1538 			oraclize_query(_calcRemainingRoundTime(), "URL", "", oraclizeRoundGasFee);
1539 		}
1540 		else
1541 		{
1542 			running = false;
1543 		}
1544 	}
1545 	
1546 	function _oraclizeQueueWinner(bool immediate) internal
1547 	{
1548 		if (_canPayOraclize(oraclizeWinnerGasFee))
1549 		{
1550 			oraclizeQueued = true;
1551 			if (!immediate)
1552 			{
1553 				currentRandomizerAttempt = 0;
1554 				funds -= oraclizeWinnerGasFee * oraclizeGasPrice;
1555 				oraclize_newRandomDSQuery(oraclizeWinnerTimeOffset, RANDOM_BYTES_COUNT, oraclizeWinnerGasFee);
1556 			}
1557 			else
1558 			{
1559 				++currentRandomizerAttempt;
1560 				funds -= oraclizeWinnerGasFee * oraclizeGasPrice;
1561 				oraclize_newRandomDSQuery(0, RANDOM_BYTES_COUNT, oraclizeWinnerGasFee);
1562 			}
1563 		}
1564 		else
1565 		{
1566 			currentRandomizerAttempt = 0;
1567 			running = false;
1568 		}
1569 	}
1570 	
1571 	function _finalizeRound() internal
1572 	{
1573 		if (roundPlayers[currentRoundIndex].length > 0)
1574 		{
1575 			currentRoundFinishing = true;
1576 			_oraclizeQueueWinner(false);
1577 		}
1578 		else
1579 		{
1580 			_oraclizeQueueRound();
1581 		}
1582 	}
1583 	
1584 	function _selectWinner(uint seed) internal
1585 	{
1586 		currentRoundFinishing = false;
1587 		Player[] storage players = roundPlayers[currentRoundIndex];
1588 		if (players.length > 0)
1589 		{
1590 			Player storage winner = players[0];
1591 			address winnerAddress = 0x0;
1592 			uint total = roundTotals[currentRoundIndex];
1593 			uint value = seed % total;
1594 			// binary search to find winner
1595 			uint32 min = 0;
1596 			uint32 max = uint32(players.length) - 1;
1597 			uint32 current = min + (max - min) / 2;
1598 			while (true)
1599 			{
1600 				uint rangeStart = players[current].startTotal;
1601 				uint rangeEnd = rangeStart + players[current].entry;
1602 				if (value >= rangeStart && value < rangeEnd)
1603 				{
1604 					winner = players[current];
1605 					winnerAddress = winner.playerAddress;
1606 					break;
1607 				}
1608 				if (value < rangeStart)
1609 				{
1610 					max = current - 1;
1611 					current = min + (max - min) / 2;
1612 				}
1613 				else if (value >= rangeEnd)
1614 				{
1615 					min = current + 1;
1616 					current = min + (max - min) / 2;
1617 				}
1618 			}
1619 			if (winnerAddress != 0x0)
1620 			{
1621 			    uint winnerEntry = winner.entry; // need to save this before clearing data below!
1622 				for (uint i = 0; i < players.length; ++i)
1623 				{
1624 					roundEntries[currentRoundIndex][players[i].playerAddress] = 0;
1625 				}
1626 				players.length = 0;
1627 				roundTotals[currentRoundIndex] = 0;
1628 				uint prize = total * (100 - feePercentage) / 100;
1629 				funds += total - prize; // fee
1630 				// TODO - solidity doesn't support returning of structs (yet)
1631 				//pastWinners.push(Winner(winner.playerAddress, winner.entry, prize, uint64(block.timestamp)));
1632 				pastWinnerAddresses.push(winnerAddress);
1633 				pastWinnerEntries.push(winnerEntry);
1634 				pastWinnerPrizes.push(prize);
1635 				pastWinnerTimestamps.push(uint64(block.timestamp));
1636 				winnerAddress.transfer(prize);
1637 			}
1638 		}
1639 		_startNextRound();
1640 		_oraclizeQueueRound();
1641 	}
1642 
1643 }