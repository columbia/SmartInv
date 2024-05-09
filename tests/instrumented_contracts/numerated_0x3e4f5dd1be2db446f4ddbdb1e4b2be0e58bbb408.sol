1 pragma solidity ^0.4.19;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 // <ORACLIZE_API>
39 /*
40 Copyright (c) 2015-2016 Oraclize SRL
41 Copyright (c) 2016 Oraclize LTD
42 
43 
44 
45 Permission is hereby granted, free of charge, to any person obtaining a copy
46 of this software and associated documentation files (the "Software"), to deal
47 in the Software without restriction, including without limitation the rights
48 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
49 copies of the Software, and to permit persons to whom the Software is
50 furnished to do so, subject to the following conditions:
51 
52 
53 
54 The above copyright notice and this permission notice shall be included in
55 all copies or substantial portions of the Software.
56 
57 
58 
59 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
60 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
61 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
62 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
63 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
64 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
65 THE SOFTWARE.
66 */
67 
68 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
69 
70 
71 contract OraclizeI {
72     address public cbAddress;
73     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
74     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
75     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
76     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
77     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
78     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
79     function getPrice(string _datasource) public returns (uint _dsprice);
80     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
81     function setProofType(byte _proofType) external;
82     function setCustomGasPrice(uint _gasPrice) external;
83     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
84 }
85 contract OraclizeAddrResolverI {
86     function getAddress() public returns (address _addr);
87 }
88 contract usingOraclize {
89     uint constant day = 60*60*24;
90     uint constant week = 60*60*24*7;
91     uint constant month = 60*60*24*30;
92     byte constant proofType_NONE = 0x00;
93     byte constant proofType_TLSNotary = 0x10;
94     byte constant proofType_Android = 0x20;
95     byte constant proofType_Ledger = 0x30;
96     byte constant proofType_Native = 0xF0;
97     byte constant proofStorage_IPFS = 0x01;
98     uint8 constant networkID_auto = 0;
99     uint8 constant networkID_mainnet = 1;
100     uint8 constant networkID_testnet = 2;
101     uint8 constant networkID_morden = 2;
102     uint8 constant networkID_consensys = 161;
103 
104     OraclizeAddrResolverI OAR;
105 
106     OraclizeI oraclize;
107     modifier oraclizeAPI {
108         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
109             oraclize_setNetwork(networkID_auto);
110 
111         if(address(oraclize) != OAR.getAddress())
112             oraclize = OraclizeI(OAR.getAddress());
113 
114         _;
115     }
116     modifier coupon(string code){
117         oraclize = OraclizeI(OAR.getAddress());
118         _;
119     }
120 
121     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
122       return oraclize_setNetwork();
123       networkID; // silence the warning and remain backwards compatible
124     }
125     function oraclize_setNetwork() internal returns(bool){
126         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
127             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
128             oraclize_setNetworkName("eth_mainnet");
129             return true;
130         }
131         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
132             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
133             oraclize_setNetworkName("eth_ropsten3");
134             return true;
135         }
136         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
137             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
138             oraclize_setNetworkName("eth_kovan");
139             return true;
140         }
141         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
142             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
143             oraclize_setNetworkName("eth_rinkeby");
144             return true;
145         }
146         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
147             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
148             return true;
149         }
150         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
151             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
152             return true;
153         }
154         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
155             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
156             return true;
157         }
158         return false;
159     }
160 
161     function __callback(bytes32 myid, string result) public {
162         __callback(myid, result, new bytes(0));
163     }
164     function __callback(bytes32 myid, string result, bytes proof) public {
165       return;
166       myid; result; proof; // Silence compiler warnings
167     }
168 
169     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
170         return oraclize.getPrice(datasource);
171     }
172 
173     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
174         return oraclize.getPrice(datasource, gaslimit);
175     }
176 
177     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
178         uint price = oraclize.getPrice(datasource);
179         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
180         return oraclize.query.value(price)(0, datasource, arg);
181     }
182     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
183         uint price = oraclize.getPrice(datasource);
184         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
185         return oraclize.query.value(price)(timestamp, datasource, arg);
186     }
187     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
188         uint price = oraclize.getPrice(datasource, gaslimit);
189         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
190         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
191     }
192     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
193         uint price = oraclize.getPrice(datasource, gaslimit);
194         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
195         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
196     }
197     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
198         uint price = oraclize.getPrice(datasource);
199         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
200         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
201     }
202     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
203         uint price = oraclize.getPrice(datasource);
204         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
205         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
206     }
207     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
208         uint price = oraclize.getPrice(datasource, gaslimit);
209         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
210         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
211     }
212     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
213         uint price = oraclize.getPrice(datasource, gaslimit);
214         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
215         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
216     }
217     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
218         uint price = oraclize.getPrice(datasource);
219         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
220         bytes memory args = stra2cbor(argN);
221         return oraclize.queryN.value(price)(0, datasource, args);
222     }
223     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
224         uint price = oraclize.getPrice(datasource);
225         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
226         bytes memory args = stra2cbor(argN);
227         return oraclize.queryN.value(price)(timestamp, datasource, args);
228     }
229     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
230         uint price = oraclize.getPrice(datasource, gaslimit);
231         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
232         bytes memory args = stra2cbor(argN);
233         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
234     }
235     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
236         uint price = oraclize.getPrice(datasource, gaslimit);
237         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
238         bytes memory args = stra2cbor(argN);
239         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
240     }
241     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
242         string[] memory dynargs = new string[](1);
243         dynargs[0] = args[0];
244         return oraclize_query(datasource, dynargs);
245     }
246     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
247         string[] memory dynargs = new string[](1);
248         dynargs[0] = args[0];
249         return oraclize_query(timestamp, datasource, dynargs);
250     }
251     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
252         string[] memory dynargs = new string[](1);
253         dynargs[0] = args[0];
254         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
255     }
256     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
257         string[] memory dynargs = new string[](1);
258         dynargs[0] = args[0];
259         return oraclize_query(datasource, dynargs, gaslimit);
260     }
261 
262     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
263         string[] memory dynargs = new string[](2);
264         dynargs[0] = args[0];
265         dynargs[1] = args[1];
266         return oraclize_query(datasource, dynargs);
267     }
268     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
269         string[] memory dynargs = new string[](2);
270         dynargs[0] = args[0];
271         dynargs[1] = args[1];
272         return oraclize_query(timestamp, datasource, dynargs);
273     }
274     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
275         string[] memory dynargs = new string[](2);
276         dynargs[0] = args[0];
277         dynargs[1] = args[1];
278         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
279     }
280     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
281         string[] memory dynargs = new string[](2);
282         dynargs[0] = args[0];
283         dynargs[1] = args[1];
284         return oraclize_query(datasource, dynargs, gaslimit);
285     }
286     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
287         string[] memory dynargs = new string[](3);
288         dynargs[0] = args[0];
289         dynargs[1] = args[1];
290         dynargs[2] = args[2];
291         return oraclize_query(datasource, dynargs);
292     }
293     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
294         string[] memory dynargs = new string[](3);
295         dynargs[0] = args[0];
296         dynargs[1] = args[1];
297         dynargs[2] = args[2];
298         return oraclize_query(timestamp, datasource, dynargs);
299     }
300     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
301         string[] memory dynargs = new string[](3);
302         dynargs[0] = args[0];
303         dynargs[1] = args[1];
304         dynargs[2] = args[2];
305         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
306     }
307     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
308         string[] memory dynargs = new string[](3);
309         dynargs[0] = args[0];
310         dynargs[1] = args[1];
311         dynargs[2] = args[2];
312         return oraclize_query(datasource, dynargs, gaslimit);
313     }
314 
315     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
316         string[] memory dynargs = new string[](4);
317         dynargs[0] = args[0];
318         dynargs[1] = args[1];
319         dynargs[2] = args[2];
320         dynargs[3] = args[3];
321         return oraclize_query(datasource, dynargs);
322     }
323     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
324         string[] memory dynargs = new string[](4);
325         dynargs[0] = args[0];
326         dynargs[1] = args[1];
327         dynargs[2] = args[2];
328         dynargs[3] = args[3];
329         return oraclize_query(timestamp, datasource, dynargs);
330     }
331     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
332         string[] memory dynargs = new string[](4);
333         dynargs[0] = args[0];
334         dynargs[1] = args[1];
335         dynargs[2] = args[2];
336         dynargs[3] = args[3];
337         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
338     }
339     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
340         string[] memory dynargs = new string[](4);
341         dynargs[0] = args[0];
342         dynargs[1] = args[1];
343         dynargs[2] = args[2];
344         dynargs[3] = args[3];
345         return oraclize_query(datasource, dynargs, gaslimit);
346     }
347     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
348         string[] memory dynargs = new string[](5);
349         dynargs[0] = args[0];
350         dynargs[1] = args[1];
351         dynargs[2] = args[2];
352         dynargs[3] = args[3];
353         dynargs[4] = args[4];
354         return oraclize_query(datasource, dynargs);
355     }
356     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
357         string[] memory dynargs = new string[](5);
358         dynargs[0] = args[0];
359         dynargs[1] = args[1];
360         dynargs[2] = args[2];
361         dynargs[3] = args[3];
362         dynargs[4] = args[4];
363         return oraclize_query(timestamp, datasource, dynargs);
364     }
365     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
366         string[] memory dynargs = new string[](5);
367         dynargs[0] = args[0];
368         dynargs[1] = args[1];
369         dynargs[2] = args[2];
370         dynargs[3] = args[3];
371         dynargs[4] = args[4];
372         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
373     }
374     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
375         string[] memory dynargs = new string[](5);
376         dynargs[0] = args[0];
377         dynargs[1] = args[1];
378         dynargs[2] = args[2];
379         dynargs[3] = args[3];
380         dynargs[4] = args[4];
381         return oraclize_query(datasource, dynargs, gaslimit);
382     }
383     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
384         uint price = oraclize.getPrice(datasource);
385         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
386         bytes memory args = ba2cbor(argN);
387         return oraclize.queryN.value(price)(0, datasource, args);
388     }
389     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
390         uint price = oraclize.getPrice(datasource);
391         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
392         bytes memory args = ba2cbor(argN);
393         return oraclize.queryN.value(price)(timestamp, datasource, args);
394     }
395     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
396         uint price = oraclize.getPrice(datasource, gaslimit);
397         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
398         bytes memory args = ba2cbor(argN);
399         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
400     }
401     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource, gaslimit);
403         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
404         bytes memory args = ba2cbor(argN);
405         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
406     }
407     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
408         bytes[] memory dynargs = new bytes[](1);
409         dynargs[0] = args[0];
410         return oraclize_query(datasource, dynargs);
411     }
412     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
413         bytes[] memory dynargs = new bytes[](1);
414         dynargs[0] = args[0];
415         return oraclize_query(timestamp, datasource, dynargs);
416     }
417     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
418         bytes[] memory dynargs = new bytes[](1);
419         dynargs[0] = args[0];
420         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
421     }
422     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
423         bytes[] memory dynargs = new bytes[](1);
424         dynargs[0] = args[0];
425         return oraclize_query(datasource, dynargs, gaslimit);
426     }
427 
428     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
429         bytes[] memory dynargs = new bytes[](2);
430         dynargs[0] = args[0];
431         dynargs[1] = args[1];
432         return oraclize_query(datasource, dynargs);
433     }
434     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
435         bytes[] memory dynargs = new bytes[](2);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         return oraclize_query(timestamp, datasource, dynargs);
439     }
440     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441         bytes[] memory dynargs = new bytes[](2);
442         dynargs[0] = args[0];
443         dynargs[1] = args[1];
444         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
445     }
446     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
447         bytes[] memory dynargs = new bytes[](2);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         return oraclize_query(datasource, dynargs, gaslimit);
451     }
452     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
453         bytes[] memory dynargs = new bytes[](3);
454         dynargs[0] = args[0];
455         dynargs[1] = args[1];
456         dynargs[2] = args[2];
457         return oraclize_query(datasource, dynargs);
458     }
459     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
460         bytes[] memory dynargs = new bytes[](3);
461         dynargs[0] = args[0];
462         dynargs[1] = args[1];
463         dynargs[2] = args[2];
464         return oraclize_query(timestamp, datasource, dynargs);
465     }
466     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
467         bytes[] memory dynargs = new bytes[](3);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         dynargs[2] = args[2];
471         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
472     }
473     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         bytes[] memory dynargs = new bytes[](3);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         dynargs[2] = args[2];
478         return oraclize_query(datasource, dynargs, gaslimit);
479     }
480 
481     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
482         bytes[] memory dynargs = new bytes[](4);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         dynargs[2] = args[2];
486         dynargs[3] = args[3];
487         return oraclize_query(datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
490         bytes[] memory dynargs = new bytes[](4);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         dynargs[2] = args[2];
494         dynargs[3] = args[3];
495         return oraclize_query(timestamp, datasource, dynargs);
496     }
497     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         bytes[] memory dynargs = new bytes[](4);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         dynargs[3] = args[3];
503         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
504     }
505     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506         bytes[] memory dynargs = new bytes[](4);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         dynargs[3] = args[3];
511         return oraclize_query(datasource, dynargs, gaslimit);
512     }
513     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
514         bytes[] memory dynargs = new bytes[](5);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         dynargs[3] = args[3];
519         dynargs[4] = args[4];
520         return oraclize_query(datasource, dynargs);
521     }
522     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
523         bytes[] memory dynargs = new bytes[](5);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         dynargs[3] = args[3];
528         dynargs[4] = args[4];
529         return oraclize_query(timestamp, datasource, dynargs);
530     }
531     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
532         bytes[] memory dynargs = new bytes[](5);
533         dynargs[0] = args[0];
534         dynargs[1] = args[1];
535         dynargs[2] = args[2];
536         dynargs[3] = args[3];
537         dynargs[4] = args[4];
538         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
539     }
540     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
541         bytes[] memory dynargs = new bytes[](5);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         dynargs[4] = args[4];
547         return oraclize_query(datasource, dynargs, gaslimit);
548     }
549 
550     function oraclize_cbAddress() oraclizeAPI internal returns (address){
551         return oraclize.cbAddress();
552     }
553     function oraclize_setProof(byte proofP) oraclizeAPI internal {
554         return oraclize.setProofType(proofP);
555     }
556     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
557         return oraclize.setCustomGasPrice(gasPrice);
558     }
559 
560     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
561         return oraclize.randomDS_getSessionPubKeyHash();
562     }
563 
564     function getCodeSize(address _addr) constant internal returns(uint _size) {
565         assembly {
566             _size := extcodesize(_addr)
567         }
568     }
569 
570     function parseAddr(string _a) internal pure returns (address){
571         bytes memory tmp = bytes(_a);
572         uint160 iaddr = 0;
573         uint160 b1;
574         uint160 b2;
575         for (uint i=2; i<2+2*20; i+=2){
576             iaddr *= 256;
577             b1 = uint160(tmp[i]);
578             b2 = uint160(tmp[i+1]);
579             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
580             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
581             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
582             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
583             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
584             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
585             iaddr += (b1*16+b2);
586         }
587         return address(iaddr);
588     }
589 
590     function strCompare(string _a, string _b) internal pure returns (int) {
591         bytes memory a = bytes(_a);
592         bytes memory b = bytes(_b);
593         uint minLength = a.length;
594         if (b.length < minLength) minLength = b.length;
595         for (uint i = 0; i < minLength; i ++)
596             if (a[i] < b[i])
597                 return -1;
598             else if (a[i] > b[i])
599                 return 1;
600         if (a.length < b.length)
601             return -1;
602         else if (a.length > b.length)
603             return 1;
604         else
605             return 0;
606     }
607 
608     function indexOf(string _haystack, string _needle) internal pure returns (int) {
609         bytes memory h = bytes(_haystack);
610         bytes memory n = bytes(_needle);
611         if(h.length < 1 || n.length < 1 || (n.length > h.length))
612             return -1;
613         else if(h.length > (2**128 -1))
614             return -1;
615         else
616         {
617             uint subindex = 0;
618             for (uint i = 0; i < h.length; i ++)
619             {
620                 if (h[i] == n[0])
621                 {
622                     subindex = 1;
623                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
624                     {
625                         subindex++;
626                     }
627                     if(subindex == n.length)
628                         return int(i);
629                 }
630             }
631             return -1;
632         }
633     }
634 
635     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
636         bytes memory _ba = bytes(_a);
637         bytes memory _bb = bytes(_b);
638         bytes memory _bc = bytes(_c);
639         bytes memory _bd = bytes(_d);
640         bytes memory _be = bytes(_e);
641         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
642         bytes memory babcde = bytes(abcde);
643         uint k = 0;
644         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
645         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
646         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
647         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
648         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
649         return string(babcde);
650     }
651 
652     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
653         return strConcat(_a, _b, _c, _d, "");
654     }
655 
656     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
657         return strConcat(_a, _b, _c, "", "");
658     }
659 
660     function strConcat(string _a, string _b) internal pure returns (string) {
661         return strConcat(_a, _b, "", "", "");
662     }
663 
664     // parseInt
665     function parseInt(string _a) internal pure returns (uint) {
666         return parseInt(_a, 0);
667     }
668 
669     // parseInt(parseFloat*10^_b)
670     function parseInt(string _a, uint _b) internal pure returns (uint) {
671         bytes memory bresult = bytes(_a);
672         uint mint = 0;
673         bool decimals = false;
674         for (uint i=0; i<bresult.length; i++){
675             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
676                 if (decimals){
677                    if (_b == 0) break;
678                     else _b--;
679                 }
680                 mint *= 10;
681                 mint += uint(bresult[i]) - 48;
682             } else if (bresult[i] == 46) decimals = true;
683         }
684         if (_b > 0) mint *= 10**_b;
685         return mint;
686     }
687 
688     function uint2str(uint i) internal pure returns (string){
689         if (i == 0) return "0";
690         uint j = i;
691         uint len;
692         while (j != 0){
693             len++;
694             j /= 10;
695         }
696         bytes memory bstr = new bytes(len);
697         uint k = len - 1;
698         while (i != 0){
699             bstr[k--] = byte(48 + i % 10);
700             i /= 10;
701         }
702         return string(bstr);
703     }
704 
705     function stra2cbor(string[] arr) internal pure returns (bytes) {
706             uint arrlen = arr.length;
707 
708             // get correct cbor output length
709             uint outputlen = 0;
710             bytes[] memory elemArray = new bytes[](arrlen);
711             for (uint i = 0; i < arrlen; i++) {
712                 elemArray[i] = (bytes(arr[i]));
713                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
714             }
715             uint ctr = 0;
716             uint cborlen = arrlen + 0x80;
717             outputlen += byte(cborlen).length;
718             bytes memory res = new bytes(outputlen);
719 
720             while (byte(cborlen).length > ctr) {
721                 res[ctr] = byte(cborlen)[ctr];
722                 ctr++;
723             }
724             for (i = 0; i < arrlen; i++) {
725                 res[ctr] = 0x5F;
726                 ctr++;
727                 for (uint x = 0; x < elemArray[i].length; x++) {
728                     // if there's a bug with larger strings, this may be the culprit
729                     if (x % 23 == 0) {
730                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
731                         elemcborlen += 0x40;
732                         uint lctr = ctr;
733                         while (byte(elemcborlen).length > ctr - lctr) {
734                             res[ctr] = byte(elemcborlen)[ctr - lctr];
735                             ctr++;
736                         }
737                     }
738                     res[ctr] = elemArray[i][x];
739                     ctr++;
740                 }
741                 res[ctr] = 0xFF;
742                 ctr++;
743             }
744             return res;
745         }
746 
747     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
748             uint arrlen = arr.length;
749 
750             // get correct cbor output length
751             uint outputlen = 0;
752             bytes[] memory elemArray = new bytes[](arrlen);
753             for (uint i = 0; i < arrlen; i++) {
754                 elemArray[i] = (bytes(arr[i]));
755                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
756             }
757             uint ctr = 0;
758             uint cborlen = arrlen + 0x80;
759             outputlen += byte(cborlen).length;
760             bytes memory res = new bytes(outputlen);
761 
762             while (byte(cborlen).length > ctr) {
763                 res[ctr] = byte(cborlen)[ctr];
764                 ctr++;
765             }
766             for (i = 0; i < arrlen; i++) {
767                 res[ctr] = 0x5F;
768                 ctr++;
769                 for (uint x = 0; x < elemArray[i].length; x++) {
770                     // if there's a bug with larger strings, this may be the culprit
771                     if (x % 23 == 0) {
772                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
773                         elemcborlen += 0x40;
774                         uint lctr = ctr;
775                         while (byte(elemcborlen).length > ctr - lctr) {
776                             res[ctr] = byte(elemcborlen)[ctr - lctr];
777                             ctr++;
778                         }
779                     }
780                     res[ctr] = elemArray[i][x];
781                     ctr++;
782                 }
783                 res[ctr] = 0xFF;
784                 ctr++;
785             }
786             return res;
787         }
788 
789 
790     string oraclize_network_name;
791     function oraclize_setNetworkName(string _network_name) internal {
792         oraclize_network_name = _network_name;
793     }
794 
795     function oraclize_getNetworkName() internal view returns (string) {
796         return oraclize_network_name;
797     }
798 
799     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
800         require((_nbytes > 0) && (_nbytes <= 32));
801         bytes memory nbytes = new bytes(1);
802         nbytes[0] = byte(_nbytes);
803         bytes memory unonce = new bytes(32);
804         bytes memory sessionKeyHash = new bytes(32);
805         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
806         assembly {
807             mstore(unonce, 0x20)
808             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
809             mstore(sessionKeyHash, 0x20)
810             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
811         }
812         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
813         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
814         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
815         return queryId;
816     }
817 
818     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
819         oraclize_randomDS_args[queryId] = commitment;
820     }
821 
822     mapping(bytes32=>bytes32) oraclize_randomDS_args;
823     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
824 
825     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
826         bool sigok;
827         address signer;
828 
829         bytes32 sigr;
830         bytes32 sigs;
831 
832         bytes memory sigr_ = new bytes(32);
833         uint offset = 4+(uint(dersig[3]) - 0x20);
834         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
835         bytes memory sigs_ = new bytes(32);
836         offset += 32 + 2;
837         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
838 
839         assembly {
840             sigr := mload(add(sigr_, 32))
841             sigs := mload(add(sigs_, 32))
842         }
843 
844 
845         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
846         if (address(keccak256(pubkey)) == signer) return true;
847         else {
848             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
849             return (address(keccak256(pubkey)) == signer);
850         }
851     }
852 
853     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
854         bool sigok;
855 
856         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
857         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
858         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
859 
860         bytes memory appkey1_pubkey = new bytes(64);
861         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
862 
863         bytes memory tosign2 = new bytes(1+65+32);
864         tosign2[0] = byte(1); //role
865         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
866         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
867         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
868         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
869 
870         if (sigok == false) return false;
871 
872 
873         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
874         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
875 
876         bytes memory tosign3 = new bytes(1+65);
877         tosign3[0] = 0xFE;
878         copyBytes(proof, 3, 65, tosign3, 1);
879 
880         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
881         copyBytes(proof, 3+65, sig3.length, sig3, 0);
882 
883         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
884 
885         return sigok;
886     }
887 
888     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
889         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
890         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
891 
892         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
893         require(proofVerified);
894 
895         _;
896     }
897 
898     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
899         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
900         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
901 
902         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
903         if (proofVerified == false) return 2;
904 
905         return 0;
906     }
907 
908     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
909         bool match_ = true;
910         
911 
912         for (uint256 i=0; i< n_random_bytes; i++) {
913             if (content[i] != prefix[i]) match_ = false;
914         }
915 
916         return match_;
917     }
918 
919     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
920 
921         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
922         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
923         bytes memory keyhash = new bytes(32);
924         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
925         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
926 
927         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
928         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
929 
930         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
931         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
932 
933         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
934         // This is to verify that the computed args match with the ones specified in the query.
935         bytes memory commitmentSlice1 = new bytes(8+1+32);
936         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
937 
938         bytes memory sessionPubkey = new bytes(64);
939         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
940         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
941 
942         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
943         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
944             delete oraclize_randomDS_args[queryId];
945         } else return false;
946 
947 
948         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
949         bytes memory tosign1 = new bytes(32+8+1+32);
950         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
951         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
952 
953         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
954         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
955             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
956         }
957 
958         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
959     }
960 
961     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
962     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
963         uint minLength = length + toOffset;
964 
965         // Buffer too small
966         require(to.length >= minLength); // Should be a better way?
967 
968         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
969         uint i = 32 + fromOffset;
970         uint j = 32 + toOffset;
971 
972         while (i < (32 + fromOffset + length)) {
973             assembly {
974                 let tmp := mload(add(from, i))
975                 mstore(add(to, j), tmp)
976             }
977             i += 32;
978             j += 32;
979         }
980 
981         return to;
982     }
983 
984     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
985     // Duplicate Solidity's ecrecover, but catching the CALL return value
986     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
987         // We do our own memory management here. Solidity uses memory offset
988         // 0x40 to store the current end of memory. We write past it (as
989         // writes are memory extensions), but don't update the offset so
990         // Solidity will reuse it. The memory used here is only needed for
991         // this context.
992 
993         // FIXME: inline assembly can't access return values
994         bool ret;
995         address addr;
996 
997         assembly {
998             let size := mload(0x40)
999             mstore(size, hash)
1000             mstore(add(size, 32), v)
1001             mstore(add(size, 64), r)
1002             mstore(add(size, 96), s)
1003 
1004             // NOTE: we can reuse the request memory because we deal with
1005             //       the return code
1006             ret := call(3000, 1, 0, size, 128, size, 32)
1007             addr := mload(size)
1008         }
1009 
1010         return (ret, addr);
1011     }
1012 
1013     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1014     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1015         bytes32 r;
1016         bytes32 s;
1017         uint8 v;
1018 
1019         if (sig.length != 65)
1020           return (false, 0);
1021 
1022         // The signature format is a compact form of:
1023         //   {bytes32 r}{bytes32 s}{uint8 v}
1024         // Compact means, uint8 is not padded to 32 bytes.
1025         assembly {
1026             r := mload(add(sig, 32))
1027             s := mload(add(sig, 64))
1028 
1029             // Here we are loading the last 32 bytes. We exploit the fact that
1030             // 'mload' will pad with zeroes if we overread.
1031             // There is no 'mload8' to do this, but that would be nicer.
1032             v := byte(0, mload(add(sig, 96)))
1033 
1034             // Alternative solution:
1035             // 'byte' is not working due to the Solidity parser, so lets
1036             // use the second best option, 'and'
1037             // v := and(mload(add(sig, 65)), 255)
1038         }
1039 
1040         // albeit non-transactional signatures are not specified by the YP, one would expect it
1041         // to match the YP range of [27, 28]
1042         //
1043         // geth uses [0, 1] and some clients have followed. This might change, see:
1044         //  https://github.com/ethereum/go-ethereum/issues/2053
1045         if (v < 27)
1046           v += 27;
1047 
1048         if (v != 27 && v != 28)
1049             return (false, 0);
1050 
1051         return safer_ecrecover(hash, v, r, s);
1052     }
1053 
1054 }
1055 // </ORACLIZE_API>
1056 /*
1057  * @title String & slice utility library for Solidity contracts.
1058  * @author Nick Johnson <arachnid@notdot.net>
1059  *
1060  * @dev Functionality in this library is largely implemented using an
1061  *      abstraction called a 'slice'. A slice represents a part of a string -
1062  *      anything from the entire string to a single character, or even no
1063  *      characters at all (a 0-length slice). Since a slice only has to specify
1064  *      an offset and a length, copying and manipulating slices is a lot less
1065  *      expensive than copying and manipulating the strings they reference.
1066  *
1067  *      To further reduce gas costs, most functions on slice that need to return
1068  *      a slice modify the original one instead of allocating a new one; for
1069  *      instance, `s.split(".")` will return the text up to the first '.',
1070  *      modifying s to only contain the remainder of the string after the '.'.
1071  *      In situations where you do not want to modify the original slice, you
1072  *      can make a copy first with `.copy()`, for example:
1073  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1074  *      Solidity has no memory management, it will result in allocating many
1075  *      short-lived slices that are later discarded.
1076  *
1077  *      Functions that return two slices come in two versions: a non-allocating
1078  *      version that takes the second slice as an argument, modifying it in
1079  *      place, and an allocating version that allocates and returns the second
1080  *      slice; see `nextRune` for example.
1081  *
1082  *      Functions that have to copy string data will return strings rather than
1083  *      slices; these can be cast back to slices for further processing if
1084  *      required.
1085  *
1086  *      For convenience, some functions are provided with non-modifying
1087  *      variants that create a new slice and return both; for instance,
1088  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1089  *      corresponding to the left and right parts of the string.
1090  */
1091  
1092 
1093 
1094 library strings {
1095     struct slice {
1096         uint _len;
1097         uint _ptr;
1098     }
1099 
1100     function memcpy(uint dest, uint src, uint len) private {
1101         // Copy word-length chunks while possible
1102         for(; len >= 32; len -= 32) {
1103             assembly {
1104                 mstore(dest, mload(src))
1105             }
1106             dest += 32;
1107             src += 32;
1108         }
1109 
1110         // Copy remaining bytes
1111         uint mask = 256 ** (32 - len) - 1;
1112         assembly {
1113             let srcpart := and(mload(src), not(mask))
1114             let destpart := and(mload(dest), mask)
1115             mstore(dest, or(destpart, srcpart))
1116         }
1117     }
1118 
1119     /*
1120      * @dev Returns a slice containing the entire string.
1121      * @param self The string to make a slice from.
1122      * @return A newly allocated slice containing the entire string.
1123      */
1124     function toSlice(string self) internal returns (slice) {
1125         uint ptr;
1126         assembly {
1127             ptr := add(self, 0x20)
1128         }
1129         return slice(bytes(self).length, ptr);
1130     }
1131 
1132     /*
1133      * @dev Returns the length of a null-terminated bytes32 string.
1134      * @param self The value to find the length of.
1135      * @return The length of the string, from 0 to 32.
1136      */
1137     function len(bytes32 self) internal returns (uint) {
1138         uint ret;
1139         if (self == 0)
1140             return 0;
1141         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1142             ret += 16;
1143             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1144         }
1145         if (self & 0xffffffffffffffff == 0) {
1146             ret += 8;
1147             self = bytes32(uint(self) / 0x10000000000000000);
1148         }
1149         if (self & 0xffffffff == 0) {
1150             ret += 4;
1151             self = bytes32(uint(self) / 0x100000000);
1152         }
1153         if (self & 0xffff == 0) {
1154             ret += 2;
1155             self = bytes32(uint(self) / 0x10000);
1156         }
1157         if (self & 0xff == 0) {
1158             ret += 1;
1159         }
1160         return 32 - ret;
1161     }
1162 
1163  
1164 
1165 
1166     /*
1167      * @dev Copies a slice to a new string.
1168      * @param self The slice to copy.
1169      * @return A newly allocated string containing the slice's text.
1170      */
1171     function toString(slice self) internal returns (string) {
1172         var ret = new string(self._len);
1173         uint retptr;
1174         assembly { retptr := add(ret, 32) }
1175 
1176         memcpy(retptr, self._ptr, self._len);
1177         return ret;
1178     }
1179 
1180     /*
1181      * @dev Returns the length in runes of the slice. Note that this operation
1182      *      takes time proportional to the length of the slice; avoid using it
1183      *      in loops, and call `slice.empty()` if you only need to know whether
1184      *      the slice is empty or not.
1185      * @param self The slice to operate on.
1186      * @return The length of the slice in runes.
1187      */
1188     function len(slice self) internal returns (uint l) {
1189         // Starting at ptr-31 means the LSB will be the byte we care about
1190         var ptr = self._ptr - 31;
1191         var end = ptr + self._len;
1192         for (l = 0; ptr < end; l++) {
1193             uint8 b;
1194             assembly { b := and(mload(ptr), 0xFF) }
1195             if (b < 0x80) {
1196                 ptr += 1;
1197             } else if(b < 0xE0) {
1198                 ptr += 2;
1199             } else if(b < 0xF0) {
1200                 ptr += 3;
1201             } else if(b < 0xF8) {
1202                 ptr += 4;
1203             } else if(b < 0xFC) {
1204                 ptr += 5;
1205             } else {
1206                 ptr += 6;
1207             }
1208         }
1209     }
1210 
1211       /*
1212      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1213      * @param self The slice to search.
1214      * @param needle The text to search for in `self`.
1215      * @return The number of occurrences of `needle` found in `self`.
1216      */
1217     function count(slice self, slice needle) internal returns (uint cnt) {
1218         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1219         while (ptr <= self._ptr + self._len) {
1220             cnt++;
1221             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1222         }
1223     }
1224      /*
1225      * @dev Returns a positive number if `other` comes lexicographically after
1226      *      `self`, a negative number if it comes before, or zero if the
1227      *      contents of the two slices are equal. Comparison is done per-rune,
1228      *      on unicode codepoints.
1229      * @param self The first slice to compare.
1230      * @param other The second slice to compare.
1231      * @return The result of the comparison.
1232      */
1233     function compare(slice self, slice other) internal returns (int) {
1234         uint shortest = self._len;
1235         if (other._len < self._len)
1236             shortest = other._len;
1237 
1238         var selfptr = self._ptr;
1239         var otherptr = other._ptr;
1240         for (uint idx = 0; idx < shortest; idx += 32) {
1241             uint a;
1242             uint b;
1243             assembly {
1244                 a := mload(selfptr)
1245                 b := mload(otherptr)
1246             }
1247             if (a != b) {
1248                 // Mask out irrelevant bytes and check again
1249                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1250                 var diff = (a & mask) - (b & mask);
1251                 if (diff != 0)
1252                     return int(diff);
1253             }
1254             selfptr += 32;
1255             otherptr += 32;
1256         }
1257         return int(self._len) - int(other._len);
1258     }
1259 
1260 
1261     /*
1262      * @dev Returns true if the two slices contain the same text.
1263      * @param self The first slice to compare.
1264      * @param self The second slice to compare.
1265      * @return True if the slices are equal, false otherwise.
1266      */
1267     function equals(slice self, slice other) internal returns (bool) {
1268         return compare(self, other) == 0;
1269     }
1270 
1271 
1272     /*
1273      * @dev If `self` starts with `needle`, `needle` is removed from the
1274      *      beginning of `self`. Otherwise, `self` is unmodified.
1275      * @param self The slice to operate on.
1276      * @param needle The slice to search for.
1277      * @return `self`
1278      */
1279     function beyond(slice self, slice needle) internal returns (slice) {
1280         if (self._len < needle._len) {
1281             return self;
1282         }
1283 
1284         bool equal = true;
1285         if (self._ptr != needle._ptr) {
1286             assembly {
1287                 let length := mload(needle)
1288                 let selfptr := mload(add(self, 0x20))
1289                 let needleptr := mload(add(needle, 0x20))
1290                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
1291             }
1292         }
1293 
1294         if (equal) {
1295             self._len -= needle._len;
1296             self._ptr += needle._len;
1297         }
1298 
1299         return self;
1300     }
1301 
1302 
1303 
1304     /*
1305      * @dev If `self` ends with `needle`, `needle` is removed from the
1306      *      end of `self`. Otherwise, `self` is unmodified.
1307      * @param self The slice to operate on.
1308      * @param needle The slice to search for.
1309      * @return `self`
1310      */
1311     function until(slice self, slice needle) internal returns (slice) {
1312         if (self._len < needle._len) {
1313             return self;
1314         }
1315 
1316         var selfptr = self._ptr + self._len - needle._len;
1317         bool equal = true;
1318         if (selfptr != needle._ptr) {
1319             assembly {
1320                 let length := mload(needle)
1321                 let needleptr := mload(add(needle, 0x20))
1322                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1323             }
1324         }
1325 
1326         if (equal) {
1327             self._len -= needle._len;
1328         }
1329 
1330         return self;
1331     }
1332 
1333     // Returns the memory address of the first byte of the first occurrence of
1334     // `needle` in `self`, or the first byte after `self` if not found.
1335     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1336         uint ptr;
1337         uint idx;
1338 
1339         if (needlelen <= selflen) {
1340             if (needlelen <= 32) {
1341                 // Optimized assembly for 68 gas per byte on short strings
1342                 assembly {
1343                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1344                     let needledata := and(mload(needleptr), mask)
1345                     let end := add(selfptr, sub(selflen, needlelen))
1346                     ptr := selfptr
1347                     loop:
1348                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1349                     ptr := add(ptr, 1)
1350                     jumpi(loop, lt(sub(ptr, 1), end))
1351                     ptr := add(selfptr, selflen)
1352                     exit:
1353                 }
1354                 return ptr;
1355             } else {
1356                 // For long needles, use hashing
1357                 bytes32 hash;
1358                 assembly { hash := sha3(needleptr, needlelen) }
1359                 ptr = selfptr;
1360                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1361                     bytes32 testHash;
1362                     assembly { testHash := sha3(ptr, needlelen) }
1363                     if (hash == testHash)
1364                         return ptr;
1365                     ptr += 1;
1366                 }
1367             }
1368         }
1369         return selfptr + selflen;
1370     }
1371 
1372     // Returns the memory address of the first byte after the last occurrence of
1373     // `needle` in `self`, or the address of `self` if not found.
1374     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1375         uint ptr;
1376 
1377         if (needlelen <= selflen) {
1378             if (needlelen <= 32) {
1379                 // Optimized assembly for 69 gas per byte on short strings
1380                 assembly {
1381                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1382                     let needledata := and(mload(needleptr), mask)
1383                     ptr := add(selfptr, sub(selflen, needlelen))
1384                     loop:
1385                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1386                     ptr := sub(ptr, 1)
1387                     jumpi(loop, gt(add(ptr, 1), selfptr))
1388                     ptr := selfptr
1389                     jump(exit)
1390                     ret:
1391                     ptr := add(ptr, needlelen)
1392                     exit:
1393                 }
1394                 return ptr;
1395             } else {
1396                 // For long needles, use hashing
1397                 bytes32 hash;
1398                 assembly { hash := sha3(needleptr, needlelen) }
1399                 ptr = selfptr + (selflen - needlelen);
1400                 while (ptr >= selfptr) {
1401                     bytes32 testHash;
1402                     assembly { testHash := sha3(ptr, needlelen) }
1403                     if (hash == testHash)
1404                         return ptr + needlelen;
1405                     ptr -= 1;
1406                 }
1407             }
1408         }
1409         return selfptr;
1410     }
1411 
1412 
1413 
1414 
1415     /*
1416      * @dev Splits the slice, setting `self` to everything after the first
1417      *      occurrence of `needle`, and `token` to everything before it. If
1418      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1419      *      and `token` is set to the entirety of `self`.
1420      * @param self The slice to split.
1421      * @param needle The text to search for in `self`.
1422      * @param token An output parameter to which the first token is written.
1423      * @return `token`.
1424      */
1425     function split(slice self, slice needle, slice token) internal returns (slice) {
1426         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1427         token._ptr = self._ptr;
1428         token._len = ptr - self._ptr;
1429         if (ptr == self._ptr + self._len) {
1430             // Not found
1431             self._len = 0;
1432         } else {
1433             self._len -= token._len + needle._len;
1434             self._ptr = ptr + needle._len;
1435         }
1436         return token;
1437     }
1438 
1439     /*
1440      * @dev Splits the slice, setting `self` to everything after the first
1441      *      occurrence of `needle`, and returning everything before it. If
1442      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1443      *      and the entirety of `self` is returned.
1444      * @param self The slice to split.
1445      * @param needle The text to search for in `self`.
1446      * @return The part of `self` up to the first occurrence of `delim`.
1447      */
1448     function split(slice self, slice needle) internal returns (slice token) {
1449         split(self, needle, token);
1450     }
1451 
1452 
1453 
1454 
1455     /*
1456      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1457      *      newly allocated string.
1458      * @param self The delimiter to use.
1459      * @param parts A list of slices to join.
1460      * @return A newly allocated string containing all the slices in `parts`,
1461      *         joined with `self`.
1462      */
1463     function join(slice self, slice[] parts) internal returns (string) {
1464         if (parts.length == 0)
1465             return "";
1466 
1467         uint length = self._len * (parts.length - 1);
1468         for(uint i = 0; i < parts.length; i++)
1469             length += parts[i]._len;
1470 
1471         var ret = new string(length);
1472         uint retptr;
1473         assembly { retptr := add(ret, 32) }
1474 
1475         for(i = 0; i < parts.length; i++) {
1476             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1477             retptr += parts[i]._len;
1478             if (i < parts.length - 1) {
1479                 memcpy(retptr, self._ptr, self._len);
1480                 retptr += self._len;
1481             }
1482         }
1483 
1484         return ret;
1485     }
1486 }
1487 
1488 // start of satoshi futures contract
1489 
1490 contract SatoshiFutures is usingOraclize {
1491     using strings for *;
1492     using SafeMath for *;
1493 
1494     
1495     address public owner = 0x047f606fd5b2baa5f5c6c4ab8958e45cb6b054b7;
1496     uint public allOpenTradesAmounts = 0;
1497     uint safeGas = 2300;
1498     uint constant ORACLIZE_GAS_LIMIT = 300000;
1499     bool public  isStopped = false;
1500     uint public ownerFee = 3;
1501     uint public currentProfitPct = 70;
1502     uint public minTrade = 10 finney;
1503     bool public emergencyWithdrawalActivated = false;
1504     uint public tradesCount = 0;
1505    
1506     
1507 
1508     struct Trade {
1509         address investor;
1510         uint amountInvested;
1511         uint initialPrice;
1512         uint finalPrice;
1513         string coinSymbol;
1514         string putOrCall;
1515     }
1516 
1517     struct TradeStats {
1518         uint initialTime;
1519         uint finalTime;
1520         bool resolved;
1521         uint tradePeriod;
1522         bool wonOrLost;
1523         string query;
1524     }
1525 
1526     struct Investor {
1527         address investorAddress;
1528         uint balanceToPayout;
1529         bool withdrew;
1530     }
1531     
1532     mapping(address => uint) public investorIDs;
1533     mapping(uint => Investor) public investors;
1534     uint public numInvestors = 0;
1535 
1536 
1537     mapping(bytes32 => Trade) public trades;
1538     mapping(bytes32 => TradeStats) public tradesStats;
1539     mapping(uint => bytes32) public tradesIds; 
1540     
1541     event LOG_MaxTradeAmountChanged(uint maxTradeAmount);
1542     event LOG_NewTradeCreated(bytes32 tradeId, address investor);
1543     event LOG_ContractStopped(string status);
1544     event LOG_OwnerAddressChanged(address oldAddr, address newOwnerAddress);
1545     event LOG_TradeWon (address investorAddress, uint amountInvested, bytes32 tradeId, uint _startTrade, uint _endTrade, uint _startPrice, uint _endPrice, string _coinSymbol, uint _pctToGain, string _queryUrl);
1546     event LOG_TradeLost(address investorAddress, uint amountInvested, bytes32 tradeId, uint _startTrade, uint _endTrade, uint _startPrice, uint _endPrice, string _coinSymbol, uint _pctToGain, string _queryUrl);
1547     event LOG_TradeDraw(address investorAddress, uint amountInvested, bytes32 tradeId, uint _startTrade, uint _endTrade, uint _startPrice, uint _endPrice, string _coinSymbol, uint _pctToGain, string _queryUrl);
1548     event LOG_GasLimitChanged(uint oldGasLimit, uint newGasLimit);
1549 
1550 
1551     //CONSTRUCTOR FUNCTION
1552     
1553 
1554     //SECTION I: MODIFIERS AND HELPER FUNCTIONS
1555     
1556     modifier onlyOwner {
1557             require(msg.sender == owner);
1558             _;
1559     }
1560     
1561     modifier onlyOraclize {
1562         require(msg.sender == oraclize_cbAddress());
1563         _;
1564     }
1565     
1566     modifier onlyIfValidGas(uint newGasLimit) {
1567         require(ORACLIZE_GAS_LIMIT + newGasLimit > ORACLIZE_GAS_LIMIT);
1568         require(newGasLimit > 2500);
1569         _;
1570     }
1571     
1572     modifier onlyIfNotStopped {
1573       require(!isStopped);
1574         _;
1575     }
1576 
1577     modifier onlyIfStopped {
1578       require(isStopped);
1579         _;
1580     }
1581     
1582     modifier onlyIfTradeExists(bytes32 myid) {
1583         require(trades[myid].investor != address(0x0));
1584         _;
1585     }
1586 
1587     modifier onlyIfTradeUnresolved(bytes32 myid) {
1588         require(tradesStats[myid].resolved != true);
1589         _;
1590     }
1591 
1592     modifier onlyIfEnoughBalanceToPayOut(uint _amountInvested) {
1593         require( _amountInvested < getMaxTradeAmount());
1594         _;
1595     }
1596 
1597     modifier onlyInvestors {
1598         require(investorIDs[msg.sender] != 0);
1599         _;
1600     }
1601     
1602     modifier onlyNotInvestors {
1603         require(investorIDs[msg.sender] == 0);
1604         _;
1605     }
1606 
1607     function addInvestorAtID(uint id)
1608     onlyNotInvestors
1609         private {
1610         investorIDs[msg.sender] = id;
1611         investors[id].investorAddress = msg.sender;
1612     }
1613     
1614     modifier onlyIfValidTradePeriod(uint tradePeriod) {
1615         require(tradePeriod <= 30);
1616         _;
1617     }
1618 
1619     modifier onlyIfTradeTimeEnded(uint _endTime) {
1620         require(block.timestamp > _endTime);
1621         _;
1622     }
1623     
1624     modifier onlyMoreThanMinTrade() {
1625         require(msg.value >= minTrade);
1626         _;
1627     }
1628     function getMaxTradeAmount() constant returns(uint) {
1629         LOG_MaxTradeAmountChanged((this.balance - allOpenTradesAmounts) * 100/currentProfitPct);
1630         require(this.balance >= allOpenTradesAmounts);
1631         return ((this.balance - allOpenTradesAmounts) * 100/currentProfitPct);
1632     }
1633 
1634     
1635     // SECTION II: TRADES & TRADE PROCESSING
1636      
1637      /*
1638      * @dev Add money to the contract in case balance goes to 0.
1639      */
1640     
1641 
1642     function addMoneyToContract() payable returns(uint) {
1643         //to add balance to the contract so trades are posible
1644         return msg.value;
1645         getMaxTradeAmount();
1646     }
1647 
1648 
1649      /*
1650      * @dev Initiate a trade by providing all the right params.
1651      */
1652 
1653     function startTrade(string _coinSymbol, uint _tradePeriod, bool _putOrCall) 
1654         payable 
1655         onlyIfNotStopped
1656         // onlyIfRightCoinChoosen(_coinSymbol)
1657         onlyMoreThanMinTrade 
1658         onlyIfValidTradePeriod(_tradePeriod)
1659         onlyIfEnoughBalanceToPayOut(msg.value) {
1660         string memory serializePutOrCall; 
1661         if(_putOrCall == true) {
1662             serializePutOrCall = "put";
1663         } else  {
1664             serializePutOrCall = "call";
1665         }
1666         var finalTime = block.timestamp + ((_tradePeriod + 1) * 60);
1667         string memory queryUrl = generateUrl(_coinSymbol, block.timestamp,  _tradePeriod );
1668         bytes32 queryId = oraclize_query(block.timestamp + ((_tradePeriod + 5) * 60), "URL", queryUrl,ORACLIZE_GAS_LIMIT + safeGas);
1669         var thisTrade = trades[queryId];
1670         var thisTradeStats = tradesStats[queryId];
1671         thisTrade.investor = msg.sender;
1672         thisTrade.amountInvested = msg.value - (msg.value * ownerFee / 100 ); 
1673         thisTrade.initialPrice = 0; 
1674         thisTrade.finalPrice = 0; 
1675         thisTrade.coinSymbol = _coinSymbol; 
1676         thisTradeStats.tradePeriod = _tradePeriod; 
1677         thisTrade.putOrCall = serializePutOrCall; 
1678         thisTradeStats.wonOrLost = false; 
1679         thisTradeStats.initialTime = block.timestamp; 
1680         thisTradeStats.finalTime = finalTime - 60; 
1681         thisTradeStats.resolved = false; 
1682         thisTradeStats.query = queryUrl; 
1683         allOpenTradesAmounts += thisTrade.amountInvested + ((thisTrade.amountInvested * currentProfitPct) / 100);
1684         tradesIds[tradesCount++] = queryId;
1685         owner.transfer(msg.value  * ownerFee / 100); 
1686         getMaxTradeAmount();
1687         if (investorIDs[msg.sender] == 0) {
1688            numInvestors++;
1689            addInvestorAtID(numInvestors); 
1690         } 
1691         
1692         LOG_NewTradeCreated(queryId, thisTrade.investor);
1693 
1694     }
1695 
1696     // function __callback(bytes32 myid, string result, bytes proof) public {
1697     //     __callback(myid, result);
1698     // }
1699     
1700 
1701      /*
1702      * @dev Callback function from oraclize after the trade period is over.
1703      * updates trade initial and final price and than calls the resolve trade function.
1704      */
1705     function __callback(bytes32 myid, string result, bytes proof)
1706         onlyOraclize 
1707         onlyIfTradeExists(myid)
1708         onlyIfTradeUnresolved(myid) {
1709         var s = result.toSlice();
1710         var d = s.beyond("[".toSlice()).until("]".toSlice());
1711         var delim = ",".toSlice();
1712         var parts = new string[](d.count(delim) + 1 );
1713         for(uint i = 0; i < parts.length; i++) {
1714           parts[i] = d.split(delim).toString();
1715         }
1716         
1717         trades[myid].initialPrice = parseInt(parts[0],4);
1718         trades[myid].finalPrice = parseInt(parts[tradesStats[myid].tradePeriod],4);
1719         resolveTrade(myid);         
1720     }
1721     
1722 
1723      /*
1724      * @dev Resolves the trade based on the initial and final amount,
1725      * depending if put or call were chosen, if its a draw the money goes back
1726      * to investor.
1727      */
1728     function resolveTrade(bytes32 _myId) internal
1729     onlyIfTradeExists(_myId)
1730     onlyIfTradeUnresolved(_myId)
1731     onlyIfTradeTimeEnded(tradesStats[_myId].finalTime)
1732         {
1733     tradesStats[_myId].resolved = true;    
1734     if(trades[_myId].initialPrice == trades[_myId].finalPrice) {
1735         trades[_myId].investor.transfer(trades[_myId].amountInvested);
1736         LOG_TradeDraw(trades[_myId].investor, trades[_myId].amountInvested,_myId, tradesStats[_myId].initialTime, tradesStats[_myId].finalTime, trades[_myId].initialPrice, trades[_myId].finalPrice, trades[_myId].coinSymbol, currentProfitPct, tradesStats[_myId].query);
1737         }
1738      if(trades[_myId].putOrCall.toSlice().equals("put".toSlice())) { 
1739          if(trades[_myId].initialPrice > trades[_myId].finalPrice) {
1740             tradesStats[_myId].wonOrLost = true;
1741             trades[_myId].investor.transfer(trades[_myId].amountInvested + ((trades[_myId].amountInvested * currentProfitPct) / 100)); 
1742             LOG_TradeWon(trades[_myId].investor, trades[_myId].amountInvested,_myId, tradesStats[_myId].initialTime, tradesStats[_myId].finalTime, trades[_myId].initialPrice, trades[_myId].finalPrice, trades[_myId].coinSymbol, currentProfitPct, tradesStats[_myId].query);
1743         }
1744         if(trades[_myId].initialPrice < trades[_myId].finalPrice) {
1745             tradesStats[_myId].wonOrLost = false;
1746             trades[_myId].investor.transfer(1); 
1747             LOG_TradeLost(trades[_myId].investor, trades[_myId].amountInvested,_myId, tradesStats[_myId].initialTime, tradesStats[_myId].finalTime, trades[_myId].initialPrice, trades[_myId].finalPrice, trades[_myId].coinSymbol, currentProfitPct, tradesStats[_myId].query);
1748         }    
1749      }
1750 
1751      if(trades[_myId].putOrCall.toSlice().equals("call".toSlice())) { 
1752          if(trades[_myId].initialPrice < trades[_myId].finalPrice) {
1753             tradesStats[_myId].wonOrLost = true;
1754             trades[_myId].investor.transfer(trades[_myId].amountInvested + ((trades[_myId].amountInvested * currentProfitPct) / 100)); 
1755             LOG_TradeWon(trades[_myId].investor, trades[_myId].amountInvested,_myId, tradesStats[_myId].initialTime, tradesStats[_myId].finalTime, trades[_myId].initialPrice, trades[_myId].finalPrice, trades[_myId].coinSymbol, currentProfitPct, tradesStats[_myId].query);
1756         }
1757         if(trades[_myId].initialPrice > trades[_myId].finalPrice) {
1758             tradesStats[_myId].wonOrLost = false;
1759             trades[_myId].investor.transfer(1); 
1760             LOG_TradeLost(trades[_myId].investor, trades[_myId].amountInvested,_myId, tradesStats[_myId].initialTime, tradesStats[_myId].finalTime, trades[_myId].initialPrice, trades[_myId].finalPrice, trades[_myId].coinSymbol, currentProfitPct, tradesStats[_myId].query);
1761         }
1762      }
1763     allOpenTradesAmounts -= trades[_myId].amountInvested + ((trades[_myId].amountInvested * currentProfitPct) / 100);
1764     getMaxTradeAmount();
1765 
1766     }
1767   
1768    
1769 
1770     /*
1771      * @dev Generate the url for the api call for oraclize.
1772      */
1773    function generateUrl(string _coinChosen, uint _timesStartTrade ,uint _tradePeriod) internal returns (string) {
1774         strings.slice[] memory parts = new strings.slice[](11);
1775         parts[0] = "json(https://api.cryptowat.ch/markets/bitfinex/".toSlice();
1776         parts[1] = _coinChosen.toSlice();
1777         parts[2] = "/ohlc?periods=60&after=".toSlice();
1778         parts[3] = uint2str(_timesStartTrade).toSlice();
1779         // parts[4] = "&before=".toSlice();
1780         // parts[5] = uint2str((_timesStartTrade + ( (_tradePeriod + 1 ) * 60))).toSlice();
1781         parts[4] = ").result.".toSlice();
1782         parts[5] = strConcat('"',uint2str(60),'"').toSlice();
1783         parts[6] = ".[0:".toSlice();
1784         parts[7] = uint2str(_tradePeriod + 1).toSlice();
1785         parts[8] = "].1".toSlice();
1786         return ''.toSlice().join(parts);
1787     }
1788  
1789    
1790     
1791     
1792     //SECTION IV: CONTRACT MANAGEMENT
1793 
1794     
1795     
1796     function stopContract()
1797     onlyOwner {
1798     isStopped = true;
1799     LOG_ContractStopped("the contract is stopped");
1800     }
1801 
1802     function resumeContract()
1803     onlyOwner {
1804     isStopped = false;
1805     LOG_ContractStopped("the contract is resumed");
1806     }
1807     
1808     function changeOwnerAddress(address newOwner)
1809     onlyOwner {
1810     require(newOwner != address(0x0)); //changed based on audit feedback
1811     owner = newOwner;
1812     LOG_OwnerAddressChanged(owner, newOwner);
1813     }
1814 
1815     function changeOwnerFee(uint _newFee) 
1816     onlyOwner {
1817         ownerFee = _newFee;
1818     }
1819 
1820     function setProfitPcnt(uint _newPct) onlyOwner {
1821         currentProfitPct = _newPct;
1822     }
1823     
1824     function initialOraclizeSettings() public onlyOwner {
1825         oraclize_setCustomGasPrice(40000000000 wei);
1826         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1827     }
1828  
1829     function changeOraclizeProofType(byte _proofType)
1830         onlyOwner {
1831         require(_proofType != 0x00);
1832         oraclize_setProof( _proofType |  proofStorage_IPFS );
1833     }
1834 
1835     function changeMinTrade(uint _newMinTrade) onlyOwner {
1836         minTrade = _newMinTrade;
1837     }
1838     
1839     function changeGasLimitOfSafeSend(uint newGasLimit)
1840         onlyOwner
1841         onlyIfValidGas(newGasLimit) {
1842         safeGas = newGasLimit;
1843         LOG_GasLimitChanged(safeGas, newGasLimit);
1844 
1845     }
1846 
1847      function changeOraclizeGasPrize(uint _newGasPrice) onlyOwner{
1848         oraclize_setCustomGasPrice(_newGasPrice);
1849     }
1850 
1851     function stopEmergencyWithdrawal() onlyOwner {
1852         emergencyWithdrawalActivated = false;
1853     }
1854 
1855     modifier onlyIfEmergencyWithdrawalActivated() {
1856         require(emergencyWithdrawalActivated);
1857         _;
1858     }
1859 
1860     modifier onlyIfnotWithdrew() {
1861         require(!investors[investorIDs[msg.sender]].withdrew);
1862         _;
1863     }
1864 
1865 
1866 
1867     /*
1868      * @dev In the case of emergency stop trades and
1869         divide balance equally to all investors and allow
1870         them to withdraw it.
1871      */ 
1872     function distributeBalanceToInvestors() 
1873     onlyOwner
1874      {  
1875         isStopped = true;
1876         emergencyWithdrawalActivated = true;
1877         uint dividendsForInvestors = SafeMath.div(this.balance, numInvestors);
1878         for(uint i = 1; i <=  numInvestors; i++) {
1879             investors[i].balanceToPayout = dividendsForInvestors;
1880         }
1881     }
1882 
1883     /*
1884      * @dev Withdraw your part from the total balance in case 
1885         of emergency.
1886      */ 
1887     function withdrawDividends() 
1888     onlyIfEmergencyWithdrawalActivated 
1889     onlyInvestors
1890     onlyIfnotWithdrew
1891     {   
1892        //send right balance to investor. 
1893        investors[investorIDs[msg.sender]].withdrew = true; 
1894        investors[investorIDs[msg.sender]].investorAddress.transfer(investors[investorIDs[msg.sender]].balanceToPayout); 
1895         investors[investorIDs[msg.sender]].balanceToPayout = 0;
1896 
1897     }
1898 
1899  
1900 }