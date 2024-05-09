1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 pragma solidity ^0.4.18;
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     address public owner;
59 
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64     /**
65      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66      * account.
67      */
68     function Ownable() public {
69         owner = msg.sender;
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     /**
81      * @dev Allows the current owner to transfer control of the contract to a newOwner.
82      * @param newOwner The address to transfer ownership to.
83      */
84     function transferOwnership(address newOwner) public onlyOwner {
85         require(newOwner != address(0));
86         OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88     }
89 
90 }
91 // <ORACLIZE_API>
92 /*
93 Copyright (c) 2015-2016 Oraclize SRL
94 Copyright (c) 2016 Oraclize LTD
95 
96 
97 
98 Permission is hereby granted, free of charge, to any person obtaining a copy
99 of this software and associated documentation files (the "Software"), to deal
100 in the Software without restriction, including without limitation the rights
101 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
102 copies of the Software, and to permit persons to whom the Software is
103 furnished to do so, subject to the following conditions:
104 
105 
106 
107 The above copyright notice and this permission notice shall be included in
108 all copies or substantial portions of the Software.
109 
110 
111 
112 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
113 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
114 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
115 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
116 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
117 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
118 THE SOFTWARE.
119 */
120 
121 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
122 pragma solidity ^0.4.18;
123 
124 contract OraclizeI {
125     address public cbAddress;
126     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
127     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
128     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
129     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
130     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
131     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
132     function getPrice(string _datasource) public returns (uint _dsprice);
133     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
134     function setProofType(byte _proofType) external;
135     function setCustomGasPrice(uint _gasPrice) external;
136     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
137 }
138 contract OraclizeAddrResolverI {
139     function getAddress() public returns (address _addr);
140 }
141 contract usingOraclize {
142     uint constant day = 60*60*24;
143     uint constant week = 60*60*24*7;
144     uint constant month = 60*60*24*30;
145     byte constant proofType_NONE = 0x00;
146     byte constant proofType_TLSNotary = 0x10;
147     byte constant proofType_Android = 0x20;
148     byte constant proofType_Ledger = 0x30;
149     byte constant proofType_Native = 0xF0;
150     byte constant proofStorage_IPFS = 0x01;
151     uint8 constant networkID_auto = 0;
152     uint8 constant networkID_mainnet = 1;
153     uint8 constant networkID_testnet = 2;
154     uint8 constant networkID_morden = 2;
155     uint8 constant networkID_consensys = 161;
156 
157     OraclizeAddrResolverI OAR;
158 
159     OraclizeI oraclize;
160     modifier oraclizeAPI {
161         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
162             oraclize_setNetwork(networkID_auto);
163 
164         if(address(oraclize) != OAR.getAddress())
165             oraclize = OraclizeI(OAR.getAddress());
166 
167         _;
168     }
169     modifier coupon(string code){
170         oraclize = OraclizeI(OAR.getAddress());
171         _;
172     }
173 
174     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
175         return oraclize_setNetwork();
176         networkID; // silence the warning and remain backwards compatible
177     }
178     function oraclize_setNetwork() internal returns(bool){
179         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
180             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
181             oraclize_setNetworkName("eth_mainnet");
182             return true;
183         }
184         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
185             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
186             oraclize_setNetworkName("eth_ropsten3");
187             return true;
188         }
189         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
190             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
191             oraclize_setNetworkName("eth_kovan");
192             return true;
193         }
194         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
195             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
196             oraclize_setNetworkName("eth_rinkeby");
197             return true;
198         }
199         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
200             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
201             return true;
202         }
203         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
204             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
205             return true;
206         }
207         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
208             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
209             return true;
210         }
211         return false;
212     }
213 
214     function __callback(bytes32 myid, string result) public {
215         __callback(myid, result, new bytes(0));
216     }
217     function __callback(bytes32 myid, string result, bytes proof) public {
218         return;
219         myid; result; proof; // Silence compiler warnings
220     }
221 
222     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
223         return oraclize.getPrice(datasource);
224     }
225 
226     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
227         return oraclize.getPrice(datasource, gaslimit);
228     }
229 
230     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
231         uint price = oraclize.getPrice(datasource);
232         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
233         return oraclize.query.value(price)(0, datasource, arg);
234     }
235     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
236         uint price = oraclize.getPrice(datasource);
237         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
238         return oraclize.query.value(price)(timestamp, datasource, arg);
239     }
240     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
241         uint price = oraclize.getPrice(datasource, gaslimit);
242         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
243         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
244     }
245     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
246         uint price = oraclize.getPrice(datasource, gaslimit);
247         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
248         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
249     }
250     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
251         uint price = oraclize.getPrice(datasource);
252         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
253         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
254     }
255     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
256         uint price = oraclize.getPrice(datasource);
257         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
258         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
259     }
260     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
261         uint price = oraclize.getPrice(datasource, gaslimit);
262         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
263         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
264     }
265     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
266         uint price = oraclize.getPrice(datasource, gaslimit);
267         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
268         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
269     }
270     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
271         uint price = oraclize.getPrice(datasource);
272         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
273         bytes memory args = stra2cbor(argN);
274         return oraclize.queryN.value(price)(0, datasource, args);
275     }
276     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
277         uint price = oraclize.getPrice(datasource);
278         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
279         bytes memory args = stra2cbor(argN);
280         return oraclize.queryN.value(price)(timestamp, datasource, args);
281     }
282     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
283         uint price = oraclize.getPrice(datasource, gaslimit);
284         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
285         bytes memory args = stra2cbor(argN);
286         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
287     }
288     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
289         uint price = oraclize.getPrice(datasource, gaslimit);
290         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
291         bytes memory args = stra2cbor(argN);
292         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
293     }
294     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
295         string[] memory dynargs = new string[](1);
296         dynargs[0] = args[0];
297         return oraclize_query(datasource, dynargs);
298     }
299     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
300         string[] memory dynargs = new string[](1);
301         dynargs[0] = args[0];
302         return oraclize_query(timestamp, datasource, dynargs);
303     }
304     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
305         string[] memory dynargs = new string[](1);
306         dynargs[0] = args[0];
307         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
308     }
309     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
310         string[] memory dynargs = new string[](1);
311         dynargs[0] = args[0];
312         return oraclize_query(datasource, dynargs, gaslimit);
313     }
314 
315     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
316         string[] memory dynargs = new string[](2);
317         dynargs[0] = args[0];
318         dynargs[1] = args[1];
319         return oraclize_query(datasource, dynargs);
320     }
321     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
322         string[] memory dynargs = new string[](2);
323         dynargs[0] = args[0];
324         dynargs[1] = args[1];
325         return oraclize_query(timestamp, datasource, dynargs);
326     }
327     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
328         string[] memory dynargs = new string[](2);
329         dynargs[0] = args[0];
330         dynargs[1] = args[1];
331         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
332     }
333     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
334         string[] memory dynargs = new string[](2);
335         dynargs[0] = args[0];
336         dynargs[1] = args[1];
337         return oraclize_query(datasource, dynargs, gaslimit);
338     }
339     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
340         string[] memory dynargs = new string[](3);
341         dynargs[0] = args[0];
342         dynargs[1] = args[1];
343         dynargs[2] = args[2];
344         return oraclize_query(datasource, dynargs);
345     }
346     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
347         string[] memory dynargs = new string[](3);
348         dynargs[0] = args[0];
349         dynargs[1] = args[1];
350         dynargs[2] = args[2];
351         return oraclize_query(timestamp, datasource, dynargs);
352     }
353     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
354         string[] memory dynargs = new string[](3);
355         dynargs[0] = args[0];
356         dynargs[1] = args[1];
357         dynargs[2] = args[2];
358         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
359     }
360     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
361         string[] memory dynargs = new string[](3);
362         dynargs[0] = args[0];
363         dynargs[1] = args[1];
364         dynargs[2] = args[2];
365         return oraclize_query(datasource, dynargs, gaslimit);
366     }
367 
368     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
369         string[] memory dynargs = new string[](4);
370         dynargs[0] = args[0];
371         dynargs[1] = args[1];
372         dynargs[2] = args[2];
373         dynargs[3] = args[3];
374         return oraclize_query(datasource, dynargs);
375     }
376     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
377         string[] memory dynargs = new string[](4);
378         dynargs[0] = args[0];
379         dynargs[1] = args[1];
380         dynargs[2] = args[2];
381         dynargs[3] = args[3];
382         return oraclize_query(timestamp, datasource, dynargs);
383     }
384     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
385         string[] memory dynargs = new string[](4);
386         dynargs[0] = args[0];
387         dynargs[1] = args[1];
388         dynargs[2] = args[2];
389         dynargs[3] = args[3];
390         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
391     }
392     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
393         string[] memory dynargs = new string[](4);
394         dynargs[0] = args[0];
395         dynargs[1] = args[1];
396         dynargs[2] = args[2];
397         dynargs[3] = args[3];
398         return oraclize_query(datasource, dynargs, gaslimit);
399     }
400     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
401         string[] memory dynargs = new string[](5);
402         dynargs[0] = args[0];
403         dynargs[1] = args[1];
404         dynargs[2] = args[2];
405         dynargs[3] = args[3];
406         dynargs[4] = args[4];
407         return oraclize_query(datasource, dynargs);
408     }
409     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
410         string[] memory dynargs = new string[](5);
411         dynargs[0] = args[0];
412         dynargs[1] = args[1];
413         dynargs[2] = args[2];
414         dynargs[3] = args[3];
415         dynargs[4] = args[4];
416         return oraclize_query(timestamp, datasource, dynargs);
417     }
418     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
419         string[] memory dynargs = new string[](5);
420         dynargs[0] = args[0];
421         dynargs[1] = args[1];
422         dynargs[2] = args[2];
423         dynargs[3] = args[3];
424         dynargs[4] = args[4];
425         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
426     }
427     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
428         string[] memory dynargs = new string[](5);
429         dynargs[0] = args[0];
430         dynargs[1] = args[1];
431         dynargs[2] = args[2];
432         dynargs[3] = args[3];
433         dynargs[4] = args[4];
434         return oraclize_query(datasource, dynargs, gaslimit);
435     }
436     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
437         uint price = oraclize.getPrice(datasource);
438         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
439         bytes memory args = ba2cbor(argN);
440         return oraclize.queryN.value(price)(0, datasource, args);
441     }
442     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
443         uint price = oraclize.getPrice(datasource);
444         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
445         bytes memory args = ba2cbor(argN);
446         return oraclize.queryN.value(price)(timestamp, datasource, args);
447     }
448     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
449         uint price = oraclize.getPrice(datasource, gaslimit);
450         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
451         bytes memory args = ba2cbor(argN);
452         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
453     }
454     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
455         uint price = oraclize.getPrice(datasource, gaslimit);
456         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
457         bytes memory args = ba2cbor(argN);
458         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
459     }
460     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
461         bytes[] memory dynargs = new bytes[](1);
462         dynargs[0] = args[0];
463         return oraclize_query(datasource, dynargs);
464     }
465     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
466         bytes[] memory dynargs = new bytes[](1);
467         dynargs[0] = args[0];
468         return oraclize_query(timestamp, datasource, dynargs);
469     }
470     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
471         bytes[] memory dynargs = new bytes[](1);
472         dynargs[0] = args[0];
473         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
474     }
475     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
476         bytes[] memory dynargs = new bytes[](1);
477         dynargs[0] = args[0];
478         return oraclize_query(datasource, dynargs, gaslimit);
479     }
480 
481     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
482         bytes[] memory dynargs = new bytes[](2);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         return oraclize_query(datasource, dynargs);
486     }
487     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
488         bytes[] memory dynargs = new bytes[](2);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         return oraclize_query(timestamp, datasource, dynargs);
492     }
493     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
494         bytes[] memory dynargs = new bytes[](2);
495         dynargs[0] = args[0];
496         dynargs[1] = args[1];
497         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
498     }
499     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
500         bytes[] memory dynargs = new bytes[](2);
501         dynargs[0] = args[0];
502         dynargs[1] = args[1];
503         return oraclize_query(datasource, dynargs, gaslimit);
504     }
505     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
506         bytes[] memory dynargs = new bytes[](3);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         return oraclize_query(datasource, dynargs);
511     }
512     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
513         bytes[] memory dynargs = new bytes[](3);
514         dynargs[0] = args[0];
515         dynargs[1] = args[1];
516         dynargs[2] = args[2];
517         return oraclize_query(timestamp, datasource, dynargs);
518     }
519     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
520         bytes[] memory dynargs = new bytes[](3);
521         dynargs[0] = args[0];
522         dynargs[1] = args[1];
523         dynargs[2] = args[2];
524         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
525     }
526     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
527         bytes[] memory dynargs = new bytes[](3);
528         dynargs[0] = args[0];
529         dynargs[1] = args[1];
530         dynargs[2] = args[2];
531         return oraclize_query(datasource, dynargs, gaslimit);
532     }
533 
534     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
535         bytes[] memory dynargs = new bytes[](4);
536         dynargs[0] = args[0];
537         dynargs[1] = args[1];
538         dynargs[2] = args[2];
539         dynargs[3] = args[3];
540         return oraclize_query(datasource, dynargs);
541     }
542     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
543         bytes[] memory dynargs = new bytes[](4);
544         dynargs[0] = args[0];
545         dynargs[1] = args[1];
546         dynargs[2] = args[2];
547         dynargs[3] = args[3];
548         return oraclize_query(timestamp, datasource, dynargs);
549     }
550     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
551         bytes[] memory dynargs = new bytes[](4);
552         dynargs[0] = args[0];
553         dynargs[1] = args[1];
554         dynargs[2] = args[2];
555         dynargs[3] = args[3];
556         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
557     }
558     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
559         bytes[] memory dynargs = new bytes[](4);
560         dynargs[0] = args[0];
561         dynargs[1] = args[1];
562         dynargs[2] = args[2];
563         dynargs[3] = args[3];
564         return oraclize_query(datasource, dynargs, gaslimit);
565     }
566     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
567         bytes[] memory dynargs = new bytes[](5);
568         dynargs[0] = args[0];
569         dynargs[1] = args[1];
570         dynargs[2] = args[2];
571         dynargs[3] = args[3];
572         dynargs[4] = args[4];
573         return oraclize_query(datasource, dynargs);
574     }
575     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
576         bytes[] memory dynargs = new bytes[](5);
577         dynargs[0] = args[0];
578         dynargs[1] = args[1];
579         dynargs[2] = args[2];
580         dynargs[3] = args[3];
581         dynargs[4] = args[4];
582         return oraclize_query(timestamp, datasource, dynargs);
583     }
584     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
585         bytes[] memory dynargs = new bytes[](5);
586         dynargs[0] = args[0];
587         dynargs[1] = args[1];
588         dynargs[2] = args[2];
589         dynargs[3] = args[3];
590         dynargs[4] = args[4];
591         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
592     }
593     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
594         bytes[] memory dynargs = new bytes[](5);
595         dynargs[0] = args[0];
596         dynargs[1] = args[1];
597         dynargs[2] = args[2];
598         dynargs[3] = args[3];
599         dynargs[4] = args[4];
600         return oraclize_query(datasource, dynargs, gaslimit);
601     }
602 
603     function oraclize_cbAddress() oraclizeAPI internal returns (address){
604         return oraclize.cbAddress();
605     }
606     function oraclize_setProof(byte proofP) oraclizeAPI internal {
607         return oraclize.setProofType(proofP);
608     }
609     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
610         return oraclize.setCustomGasPrice(gasPrice);
611     }
612 
613     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
614         return oraclize.randomDS_getSessionPubKeyHash();
615     }
616 
617     function getCodeSize(address _addr) constant internal returns(uint _size) {
618         assembly {
619             _size := extcodesize(_addr)
620         }
621     }
622 
623     function parseAddr(string _a) internal pure returns (address){
624         bytes memory tmp = bytes(_a);
625         uint160 iaddr = 0;
626         uint160 b1;
627         uint160 b2;
628         for (uint i=2; i<2+2*20; i+=2){
629             iaddr *= 256;
630             b1 = uint160(tmp[i]);
631             b2 = uint160(tmp[i+1]);
632             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
633             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
634             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
635             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
636             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
637             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
638             iaddr += (b1*16+b2);
639         }
640         return address(iaddr);
641     }
642 
643     function strCompare(string _a, string _b) internal pure returns (int) {
644         bytes memory a = bytes(_a);
645         bytes memory b = bytes(_b);
646         uint minLength = a.length;
647         if (b.length < minLength) minLength = b.length;
648         for (uint i = 0; i < minLength; i ++)
649             if (a[i] < b[i])
650                 return -1;
651             else if (a[i] > b[i])
652                 return 1;
653         if (a.length < b.length)
654             return -1;
655         else if (a.length > b.length)
656             return 1;
657         else
658             return 0;
659     }
660 
661     function indexOf(string _haystack, string _needle) internal pure returns (int) {
662         bytes memory h = bytes(_haystack);
663         bytes memory n = bytes(_needle);
664         if(h.length < 1 || n.length < 1 || (n.length > h.length))
665             return -1;
666         else if(h.length > (2**128 -1))
667             return -1;
668         else
669         {
670             uint subindex = 0;
671             for (uint i = 0; i < h.length; i ++)
672             {
673                 if (h[i] == n[0])
674                 {
675                     subindex = 1;
676                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
677                     {
678                         subindex++;
679                     }
680                     if(subindex == n.length)
681                         return int(i);
682                 }
683             }
684             return -1;
685         }
686     }
687 
688     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
689         bytes memory _ba = bytes(_a);
690         bytes memory _bb = bytes(_b);
691         bytes memory _bc = bytes(_c);
692         bytes memory _bd = bytes(_d);
693         bytes memory _be = bytes(_e);
694         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
695         bytes memory babcde = bytes(abcde);
696         uint k = 0;
697         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
698         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
699         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
700         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
701         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
702         return string(babcde);
703     }
704 
705     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
706         return strConcat(_a, _b, _c, _d, "");
707     }
708 
709     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
710         return strConcat(_a, _b, _c, "", "");
711     }
712 
713     function strConcat(string _a, string _b) internal pure returns (string) {
714         return strConcat(_a, _b, "", "", "");
715     }
716 
717     // parseInt
718     function parseInt(string _a) internal pure returns (uint) {
719         return parseInt(_a, 0);
720     }
721 
722     // parseInt(parseFloat*10^_b)
723     function parseInt(string _a, uint _b) internal pure returns (uint) {
724         bytes memory bresult = bytes(_a);
725         uint mint = 0;
726         bool decimals = false;
727         for (uint i=0; i<bresult.length; i++){
728             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
729                 if (decimals){
730                     if (_b == 0) break;
731                     else _b--;
732                 }
733                 mint *= 10;
734                 mint += uint(bresult[i]) - 48;
735             } else if (bresult[i] == 46) decimals = true;
736         }
737         if (_b > 0) mint *= 10**_b;
738         return mint;
739     }
740 
741     function uint2str(uint i) internal pure returns (string){
742         if (i == 0) return "0";
743         uint j = i;
744         uint len;
745         while (j != 0){
746             len++;
747             j /= 10;
748         }
749         bytes memory bstr = new bytes(len);
750         uint k = len - 1;
751         while (i != 0){
752             bstr[k--] = byte(48 + i % 10);
753             i /= 10;
754         }
755         return string(bstr);
756     }
757 
758     function stra2cbor(string[] arr) internal pure returns (bytes) {
759         uint arrlen = arr.length;
760 
761         // get correct cbor output length
762         uint outputlen = 0;
763         bytes[] memory elemArray = new bytes[](arrlen);
764         for (uint i = 0; i < arrlen; i++) {
765             elemArray[i] = (bytes(arr[i]));
766             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
767         }
768         uint ctr = 0;
769         uint cborlen = arrlen + 0x80;
770         outputlen += byte(cborlen).length;
771         bytes memory res = new bytes(outputlen);
772 
773         while (byte(cborlen).length > ctr) {
774             res[ctr] = byte(cborlen)[ctr];
775             ctr++;
776         }
777         for (i = 0; i < arrlen; i++) {
778             res[ctr] = 0x5F;
779             ctr++;
780             for (uint x = 0; x < elemArray[i].length; x++) {
781                 // if there's a bug with larger strings, this may be the culprit
782                 if (x % 23 == 0) {
783                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
784                     elemcborlen += 0x40;
785                     uint lctr = ctr;
786                     while (byte(elemcborlen).length > ctr - lctr) {
787                         res[ctr] = byte(elemcborlen)[ctr - lctr];
788                         ctr++;
789                     }
790                 }
791                 res[ctr] = elemArray[i][x];
792                 ctr++;
793             }
794             res[ctr] = 0xFF;
795             ctr++;
796         }
797         return res;
798     }
799 
800     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
801         uint arrlen = arr.length;
802 
803         // get correct cbor output length
804         uint outputlen = 0;
805         bytes[] memory elemArray = new bytes[](arrlen);
806         for (uint i = 0; i < arrlen; i++) {
807             elemArray[i] = (bytes(arr[i]));
808             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
809         }
810         uint ctr = 0;
811         uint cborlen = arrlen + 0x80;
812         outputlen += byte(cborlen).length;
813         bytes memory res = new bytes(outputlen);
814 
815         while (byte(cborlen).length > ctr) {
816             res[ctr] = byte(cborlen)[ctr];
817             ctr++;
818         }
819         for (i = 0; i < arrlen; i++) {
820             res[ctr] = 0x5F;
821             ctr++;
822             for (uint x = 0; x < elemArray[i].length; x++) {
823                 // if there's a bug with larger strings, this may be the culprit
824                 if (x % 23 == 0) {
825                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
826                     elemcborlen += 0x40;
827                     uint lctr = ctr;
828                     while (byte(elemcborlen).length > ctr - lctr) {
829                         res[ctr] = byte(elemcborlen)[ctr - lctr];
830                         ctr++;
831                     }
832                 }
833                 res[ctr] = elemArray[i][x];
834                 ctr++;
835             }
836             res[ctr] = 0xFF;
837             ctr++;
838         }
839         return res;
840     }
841 
842 
843     string oraclize_network_name;
844     function oraclize_setNetworkName(string _network_name) internal {
845         oraclize_network_name = _network_name;
846     }
847 
848     function oraclize_getNetworkName() internal view returns (string) {
849         return oraclize_network_name;
850     }
851 
852     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
853         require((_nbytes > 0) && (_nbytes <= 32));
854         // Convert from seconds to ledger timer ticks
855         _delay *= 10;
856         bytes memory nbytes = new bytes(1);
857         nbytes[0] = byte(_nbytes);
858         bytes memory unonce = new bytes(32);
859         bytes memory sessionKeyHash = new bytes(32);
860         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
861         assembly {
862             mstore(unonce, 0x20)
863             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
864             mstore(sessionKeyHash, 0x20)
865             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
866         }
867         bytes memory delay = new bytes(32);
868         assembly {
869             mstore(add(delay, 0x20), _delay)
870         }
871 
872         bytes memory delay_bytes8 = new bytes(8);
873         copyBytes(delay, 24, 8, delay_bytes8, 0);
874 
875         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
876         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
877 
878         bytes memory delay_bytes8_left = new bytes(8);
879 
880         assembly {
881             let x := mload(add(delay_bytes8, 0x20))
882             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
883             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
884             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
885             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
886             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
887             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
888             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
889             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
890 
891         }
892 
893         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
894         return queryId;
895     }
896 
897     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
898         oraclize_randomDS_args[queryId] = commitment;
899     }
900 
901     mapping(bytes32=>bytes32) oraclize_randomDS_args;
902     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
903 
904     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
905         bool sigok;
906         address signer;
907 
908         bytes32 sigr;
909         bytes32 sigs;
910 
911         bytes memory sigr_ = new bytes(32);
912         uint offset = 4+(uint(dersig[3]) - 0x20);
913         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
914         bytes memory sigs_ = new bytes(32);
915         offset += 32 + 2;
916         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
917 
918         assembly {
919             sigr := mload(add(sigr_, 32))
920             sigs := mload(add(sigs_, 32))
921         }
922 
923 
924         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
925         if (address(keccak256(pubkey)) == signer) return true;
926         else {
927             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
928             return (address(keccak256(pubkey)) == signer);
929         }
930     }
931 
932     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
933         bool sigok;
934 
935         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
936         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
937         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
938 
939         bytes memory appkey1_pubkey = new bytes(64);
940         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
941 
942         bytes memory tosign2 = new bytes(1+65+32);
943         tosign2[0] = byte(1); //role
944         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
945         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
946         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
947         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
948 
949         if (sigok == false) return false;
950 
951 
952         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
953         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
954 
955         bytes memory tosign3 = new bytes(1+65);
956         tosign3[0] = 0xFE;
957         copyBytes(proof, 3, 65, tosign3, 1);
958 
959         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
960         copyBytes(proof, 3+65, sig3.length, sig3, 0);
961 
962         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
963 
964         return sigok;
965     }
966 
967     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
968         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
969         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
970 
971         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
972         require(proofVerified);
973 
974         _;
975     }
976 
977     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
978         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
979         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
980 
981         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
982         if (proofVerified == false) return 2;
983 
984         return 0;
985     }
986 
987     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
988         bool match_ = true;
989 
990         require(prefix.length == n_random_bytes);
991 
992         for (uint256 i=0; i< n_random_bytes; i++) {
993             if (content[i] != prefix[i]) match_ = false;
994         }
995 
996         return match_;
997     }
998 
999     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1000 
1001         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1002         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1003         bytes memory keyhash = new bytes(32);
1004         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1005         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1006 
1007         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1008         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1009 
1010         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1011         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1012 
1013         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1014         // This is to verify that the computed args match with the ones specified in the query.
1015         bytes memory commitmentSlice1 = new bytes(8+1+32);
1016         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1017 
1018         bytes memory sessionPubkey = new bytes(64);
1019         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1020         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1021 
1022         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1023         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1024             delete oraclize_randomDS_args[queryId];
1025         } else return false;
1026 
1027 
1028         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1029         bytes memory tosign1 = new bytes(32+8+1+32);
1030         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1031         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1032 
1033         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1034         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1035             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1036         }
1037 
1038         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1039     }
1040 
1041     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1042     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1043         uint minLength = length + toOffset;
1044 
1045         // Buffer too small
1046         require(to.length >= minLength); // Should be a better way?
1047 
1048         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1049         uint i = 32 + fromOffset;
1050         uint j = 32 + toOffset;
1051 
1052         while (i < (32 + fromOffset + length)) {
1053             assembly {
1054                 let tmp := mload(add(from, i))
1055                 mstore(add(to, j), tmp)
1056             }
1057             i += 32;
1058             j += 32;
1059         }
1060 
1061         return to;
1062     }
1063 
1064     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1065     // Duplicate Solidity's ecrecover, but catching the CALL return value
1066     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1067         // We do our own memory management here. Solidity uses memory offset
1068         // 0x40 to store the current end of memory. We write past it (as
1069         // writes are memory extensions), but don't update the offset so
1070         // Solidity will reuse it. The memory used here is only needed for
1071         // this context.
1072 
1073         // FIXME: inline assembly can't access return values
1074         bool ret;
1075         address addr;
1076 
1077         assembly {
1078             let size := mload(0x40)
1079             mstore(size, hash)
1080             mstore(add(size, 32), v)
1081             mstore(add(size, 64), r)
1082             mstore(add(size, 96), s)
1083 
1084         // NOTE: we can reuse the request memory because we deal with
1085         //       the return code
1086             ret := call(3000, 1, 0, size, 128, size, 32)
1087             addr := mload(size)
1088         }
1089 
1090         return (ret, addr);
1091     }
1092 
1093     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1094     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1095         bytes32 r;
1096         bytes32 s;
1097         uint8 v;
1098 
1099         if (sig.length != 65)
1100             return (false, 0);
1101 
1102         // The signature format is a compact form of:
1103         //   {bytes32 r}{bytes32 s}{uint8 v}
1104         // Compact means, uint8 is not padded to 32 bytes.
1105         assembly {
1106             r := mload(add(sig, 32))
1107             s := mload(add(sig, 64))
1108 
1109         // Here we are loading the last 32 bytes. We exploit the fact that
1110         // 'mload' will pad with zeroes if we overread.
1111         // There is no 'mload8' to do this, but that would be nicer.
1112             v := byte(0, mload(add(sig, 96)))
1113 
1114         // Alternative solution:
1115         // 'byte' is not working due to the Solidity parser, so lets
1116         // use the second best option, 'and'
1117         // v := and(mload(add(sig, 65)), 255)
1118         }
1119 
1120         // albeit non-transactional signatures are not specified by the YP, one would expect it
1121         // to match the YP range of [27, 28]
1122         //
1123         // geth uses [0, 1] and some clients have followed. This might change, see:
1124         //  https://github.com/ethereum/go-ethereum/issues/2053
1125         if (v < 27)
1126             v += 27;
1127 
1128         if (v != 27 && v != 28)
1129             return (false, 0);
1130 
1131         return safer_ecrecover(hash, v, r, s);
1132     }
1133 
1134 }
1135 // </ORACLIZE_API>
1136 
1137 pragma solidity ^0.4.19;
1138 
1139 /// @title EtherHiLo
1140 /// @dev the contract than handles the EtherHiLo app
1141 contract EtherHiLo is usingOraclize, Ownable {
1142 
1143     uint8 constant NUM_DICE_SIDES = 13;
1144 
1145     // settings
1146     uint public rngCallbackGas;
1147     uint public minBet;
1148     uint public maxBetThresholdPct;
1149     bool public gameRunning;
1150 
1151     // state
1152     uint public balanceInPlay;
1153     uint public totalGamesPlayed;
1154     uint public totalBetsMade;
1155     uint public totalWinnings;
1156 
1157     mapping(address => Game) private gamesInProgress;
1158     mapping(uint => address) private rollIdToGameAddress;
1159 
1160     event GameStarted(address indexed player, uint indexed playerGameNumber, uint bet);
1161     event FirstRoll(address indexed player, uint indexed playerGameNumber, uint bet, uint roll);
1162     event DirectionChosen(address indexed player, uint indexed playerGameNumber, uint bet, uint firstRoll, BetDirection direction);
1163     event GameFinished(address indexed player, uint indexed playerGameNumber, uint bet, uint firstRoll, uint finalRoll, uint winnings, uint payout);
1164 
1165     enum BetDirection {
1166         None,
1167         Low,
1168         High
1169     }
1170 
1171     // the game object
1172     struct Game {
1173         uint id;
1174         address player;
1175         uint bet;
1176         uint firstRoll;
1177         uint finalRoll;
1178         BetDirection direction;
1179         uint winnings;
1180         uint when;
1181     }
1182 
1183     // modifier that requires the game is running
1184     modifier gameIsRunning() {
1185         require(gameRunning);
1186         _;
1187     }
1188 
1189     // modifier that requires there is a game in progress
1190     // for the player
1191     modifier gameInProgress(address player) {
1192         require(player != address(0));
1193         require(gamesInProgress[player].player != address(0));
1194         _;
1195     }
1196 
1197     // modifier that requires there is not a game in progress
1198     // for the player
1199     modifier gameNotInProgress(address player) {
1200         require(player != address(0));
1201         require(gamesInProgress[player].player == address(0));
1202         _;
1203     }
1204 
1205     // modifier that requires the caller come from oraclize
1206     modifier onlyOraclize {
1207         require(msg.sender == oraclize_cbAddress());
1208         _;
1209     }
1210 
1211     // the constructor
1212     function EtherHiLo() public {
1213         oraclize_setProof(proofType_Ledger);
1214         setRNGCallbackGas(1000000);
1215         setRNGCallbackGasPrice(4000000000 wei);
1216         setMinBet(1 finney);
1217         setGameRunning(true);
1218         setMaxBetThresholdPct(50);
1219 
1220         totalGamesPlayed = 0;
1221         totalBetsMade = 0;
1222         totalWinnings = 0;
1223     }
1224 
1225     /// Default function
1226     function() external payable {
1227 
1228     }
1229 
1230 
1231     /// =======================
1232     /// EXTERNAL GAME RELATED FUNCTIONS
1233 
1234     // begins a game
1235     function beginGame() public payable
1236             gameIsRunning
1237             gameNotInProgress(msg.sender) {
1238 
1239         address player = msg.sender;
1240         uint bet = msg.value;
1241 
1242         require(bet >= minBet && bet <= getMaxBet());
1243 
1244         Game memory game = Game({
1245             id:         uint(keccak256(block.number, block.timestamp, player, bet)),
1246             player:     player,
1247             bet:        bet,
1248             firstRoll:  0,
1249             finalRoll:  0,
1250             direction:  BetDirection.None,
1251             winnings:   0,
1252             when:       block.timestamp
1253             });
1254 
1255         balanceInPlay = balanceInPlay + game.bet;
1256         totalGamesPlayed = totalGamesPlayed + 1;
1257         totalBetsMade = totalBetsMade + game.bet;
1258         gamesInProgress[player] = game;
1259         rollDie(player);
1260         GameStarted(player, game.id, bet);
1261     }
1262 
1263     // finishes a game that is in progress
1264     function finishGame(BetDirection direction) public gameInProgress(msg.sender) {
1265         address player = msg.sender;
1266         require(player != address(0));
1267         require(direction != BetDirection.None);
1268 
1269         Game storage game = gamesInProgress[player];
1270         require(game.player != address(0));
1271 
1272         game.direction = direction;
1273         gamesInProgress[player] = game;
1274 
1275         rollDie(player);
1276         DirectionChosen(player, game.id, game.bet, game.firstRoll, direction);
1277     }
1278 
1279     // determins whether or not the caller is in a game
1280     function getGameState(address player) public view returns
1281             (bool, uint, uint, uint, BetDirection, uint, uint, uint) {
1282         require(player != address(0));
1283         return (
1284             gamesInProgress[player].player != address(0),
1285             gamesInProgress[player].bet,
1286             gamesInProgress[player].firstRoll,
1287             gamesInProgress[player].finalRoll,
1288             gamesInProgress[player].direction,
1289             gamesInProgress[player].id,
1290             getMinBet(),
1291             getMaxBet()
1292         );
1293     }
1294 
1295     // Returns the minimum bet
1296     function getMinBet() public view returns (uint) {
1297         return minBet;
1298     }
1299 
1300     // Returns the maximum bet
1301     function getMaxBet() public view returns (uint) {
1302         return SafeMath.div(SafeMath.div(SafeMath.mul(this.balance - balanceInPlay, maxBetThresholdPct), 100), 12);
1303     }
1304 
1305     // calculates winnings for the given bet and percent
1306     function calculateWinnings(uint bet, uint percent) public pure returns (uint) {
1307         return SafeMath.div(SafeMath.mul(bet, percent), 100);
1308     }
1309 
1310     // Returns the win percent when going low on the given number
1311     function getLowWinPercent(uint number) public pure returns (uint) {
1312         require(number >= 2 && number <= NUM_DICE_SIDES);
1313         if (number == 2) {
1314             return 1200;
1315         } else if (number == 3) {
1316             return 500;
1317         } else if (number == 4) {
1318             return 300;
1319         } else if (number == 5) {
1320             return 300;
1321         } else if (number == 6) {
1322             return 200;
1323         } else if (number == 7) {
1324             return 180;
1325         } else if (number == 8) {
1326             return 150;
1327         } else if (number == 9) {
1328             return 140;
1329         } else if (number == 10) {
1330             return 130;
1331         } else if (number == 11) {
1332             return 120;
1333         } else if (number == 12) {
1334             return 110;
1335         } else if (number == 13) {
1336             return 100;
1337         }
1338     }
1339 
1340     // Returns the win percent when going high on the given number
1341     function getHighWinPercent(uint number) public pure returns (uint) {
1342         require(number >= 1 && number < NUM_DICE_SIDES);
1343         if (number == 1) {
1344             return 100;
1345         } else if (number == 2) {
1346             return 110;
1347         } else if (number == 3) {
1348             return 120;
1349         } else if (number == 4) {
1350             return 130;
1351         } else if (number == 5) {
1352             return 140;
1353         } else if (number == 6) {
1354             return 150;
1355         } else if (number == 7) {
1356             return 180;
1357         } else if (number == 8) {
1358             return 200;
1359         } else if (number == 9) {
1360             return 300;
1361         } else if (number == 10) {
1362             return 300;
1363         } else if (number == 11) {
1364             return 500;
1365         } else if (number == 12) {
1366             return 1200;
1367         }
1368     }
1369 
1370 
1371     /// =======================
1372     /// INTERNAL GAME RELATED FUNCTIONS
1373 
1374     // process a successful roll
1375     function processDiceRoll(address player, uint roll) private {
1376 
1377         Game storage game = gamesInProgress[player];
1378         require(game.player != address(0));
1379 
1380         if (game.firstRoll == 0) {
1381 
1382             game.firstRoll = roll;
1383             gamesInProgress[player] = game;
1384 
1385             FirstRoll(player, game.id, game.bet, game.firstRoll);
1386 
1387         } else if (game.finalRoll == 0) {
1388 
1389             game.finalRoll = roll;
1390 
1391             uint winnings = 0;
1392             if (game.direction == BetDirection.High && game.finalRoll > game.firstRoll) {
1393                 winnings = calculateWinnings(game.bet, getHighWinPercent(game.firstRoll));
1394             } else if (game.direction == BetDirection.Low && game.finalRoll < game.firstRoll) {
1395                 winnings = calculateWinnings(game.bet, getLowWinPercent(game.firstRoll));
1396             }
1397             game.winnings = winnings;
1398 
1399             // this should never happen according to the odds,
1400             // and the fact that we don't allow people to bet
1401             // so large that they can take the whole pot in one
1402             // fell swoop - however, a number of people could
1403             // theoretically all win simultaneously and cause
1404             // this scenario.  This will try to at a minimum
1405             // send them back what they bet and then since it
1406             // is recorded on the blockchain we can verify that
1407             // the winnings sent don't match what they should be
1408             // and we can manually send the rest to the player.
1409             uint transferAmount = winnings;
1410             if (transferAmount > this.balance) {
1411                 if (game.bet < this.balance) {
1412                     transferAmount = game.bet;
1413                 } else {
1414                     transferAmount = SafeMath.div(SafeMath.mul(this.balance, 90), 100);
1415                 }
1416             }
1417 
1418             balanceInPlay = balanceInPlay - game.bet;
1419 
1420             if (transferAmount > 0) {
1421                 game.player.transfer(transferAmount);
1422             }
1423 
1424             totalWinnings = totalWinnings + winnings;
1425 
1426             GameFinished(player, game.id, game.bet, game.firstRoll, game.finalRoll, game.winnings, transferAmount);
1427 
1428             delete gamesInProgress[player];
1429         }
1430 
1431     }
1432 
1433     // roll the dice for a player
1434     function rollDie(address player) private {
1435         uint N = 7;
1436         uint delay = 0;
1437         bytes32 _queryId = oraclize_newRandomDSQuery(delay, N, rngCallbackGas);
1438         uint rollId = uint(keccak256(_queryId));
1439         rollIdToGameAddress[rollId] = player;
1440     }
1441 
1442 
1443     /// =======================
1444     /// ORACLIZE RELATED FUNCTIONS
1445 
1446     // the callback function is called by Oraclize when the result is ready
1447     // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
1448     // the proof validity is fully verified on-chain
1449     function __callback(bytes32 _queryId, string _result, bytes _proof) public onlyOraclize {
1450         uint rollId = uint(keccak256(_queryId));
1451         address player = rollIdToGameAddress[rollId];
1452         require(player != address(0));
1453 
1454         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
1455 
1456             Game storage game = gamesInProgress[player];
1457             require(game.player != address(0));
1458 
1459             game.player.transfer(game.bet);
1460             delete gamesInProgress[player];
1461 
1462         } else {
1463 
1464             uint randomNumber = (uint(keccak256(_result)) % NUM_DICE_SIDES) + 1;
1465             processDiceRoll(player, randomNumber);
1466         }
1467 
1468         delete rollIdToGameAddress[rollId];
1469     }
1470 
1471 
1472     /// OWNER / MANAGEMENT RELATED FUNCTIONS
1473 
1474     // fail safe for balance transfer
1475     function transferBalance(address to, uint amount) public onlyOwner {
1476         to.transfer(amount);
1477     }
1478 
1479     // cleans up a player abandoned game, but only if it's
1480     // greater than 24 hours old.
1481     function cleanupAbandonedGame(address player) public onlyOwner {
1482         require(player != address(0));
1483 
1484         Game storage game = gamesInProgress[player];
1485         require(game.player != address(0));
1486 
1487         uint elapsed = block.timestamp - game.when;
1488         require(elapsed >= 86400);
1489 
1490         game.player.transfer(game.bet);
1491         delete gamesInProgress[game.player];
1492     }
1493 
1494     // set RNG callback gas
1495     function setRNGCallbackGas(uint gas) public onlyOwner {
1496         rngCallbackGas = gas;
1497     }
1498 
1499     // set RNG callback gas
1500     function setRNGCallbackGasPrice(uint price) public onlyOwner {
1501         oraclize_setCustomGasPrice(price);
1502     }
1503 
1504     // set the minimum bet
1505     function setMinBet(uint bet) public onlyOwner {
1506         minBet = bet;
1507     }
1508 
1509     // set whether or not the game is running
1510     function setGameRunning(bool v) public onlyOwner {
1511         gameRunning = v;
1512     }
1513 
1514     // set the max bet threshold percent
1515     function setMaxBetThresholdPct(uint v) public onlyOwner {
1516         maxBetThresholdPct = v;
1517     }
1518 
1519     // Transfers the current balance to the owner and terminates the contract.
1520     function destroy() public onlyOwner {
1521         selfdestruct(owner);
1522     }
1523 
1524     // Transfers the current balance to the recepient and terminates the contract.
1525     function destroyAndSend(address _recipient) public onlyOwner {
1526         selfdestruct(_recipient);
1527     }
1528 
1529 }