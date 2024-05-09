1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /// @title Base Token contract - Functions to be implemented by token contracts.
50 contract Token {
51     /*
52      * Implements ERC 20 standard.
53      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
54      * https://github.com/ethereum/EIPs/issues/20
55      *
56      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
57      *  https://github.com/ethereum/EIPs/issues/223
58      */
59 
60     /*
61      * ERC 20
62      */
63     function balanceOf(address _owner) public constant returns (uint256 balance);
64     function transfer(address _to, uint256 _value) public returns (bool success);
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
66     function approve(address _spender, uint256 _value) public returns (bool success);
67     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
68     function burn(uint num) public;
69 
70     /*
71      * ERC 223
72      */
73     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
74 
75     /*
76      * Events
77      */
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80     event Burn(address indexed _burner, uint _value);
81 
82     // There is no ERC223 compatible Transfer event, with `_data` included.
83 }
84 
85 // <ORACLIZE_API>
86 /*
87 Copyright (c) 2015-2016 Oraclize SRL
88 Copyright (c) 2016 Oraclize LTD
89 
90 
91 
92 Permission is hereby granted, free of charge, to any person obtaining a copy
93 of this software and associated documentation files (the "Software"), to deal
94 in the Software without restriction, including without limitation the rights
95 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
96 copies of the Software, and to permit persons to whom the Software is
97 furnished to do so, subject to the following conditions:
98 
99 
100 
101 The above copyright notice and this permission notice shall be included in
102 all copies or substantial portions of the Software.
103 
104 
105 
106 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
107 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
108 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
109 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
110 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
111 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
112 THE SOFTWARE.
113 */
114 
115 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
116 pragma solidity ^0.4.18;
117 
118 contract OraclizeI {
119     address public cbAddress;
120     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
121     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
122     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
123     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
124     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
125     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
126     function getPrice(string _datasource) public returns (uint _dsprice);
127     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
128     function setProofType(byte _proofType) external;
129     function setCustomGasPrice(uint _gasPrice) external;
130     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
131 }
132 contract OraclizeAddrResolverI {
133     function getAddress() public returns (address _addr);
134 }
135 contract usingOraclize {
136     uint constant day = 60*60*24;
137     uint constant week = 60*60*24*7;
138     uint constant month = 60*60*24*30;
139     byte constant proofType_NONE = 0x00;
140     byte constant proofType_TLSNotary = 0x10;
141     byte constant proofType_Android = 0x20;
142     byte constant proofType_Ledger = 0x30;
143     byte constant proofType_Native = 0xF0;
144     byte constant proofStorage_IPFS = 0x01;
145     uint8 constant networkID_auto = 0;
146     uint8 constant networkID_mainnet = 1;
147     uint8 constant networkID_testnet = 2;
148     uint8 constant networkID_morden = 2;
149     uint8 constant networkID_consensys = 161;
150 
151     OraclizeAddrResolverI OAR;
152 
153     OraclizeI oraclize;
154     modifier oraclizeAPI {
155         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
156             oraclize_setNetwork(networkID_auto);
157 
158         if(address(oraclize) != OAR.getAddress())
159             oraclize = OraclizeI(OAR.getAddress());
160 
161         _;
162     }
163     modifier coupon(string code){
164         oraclize = OraclizeI(OAR.getAddress());
165         _;
166     }
167 
168     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
169       return oraclize_setNetwork();
170       networkID; // silence the warning and remain backwards compatible
171     }
172     function oraclize_setNetwork() internal returns(bool){
173         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
174             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
175             oraclize_setNetworkName("eth_mainnet");
176             return true;
177         }
178         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
179             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
180             oraclize_setNetworkName("eth_ropsten3");
181             return true;
182         }
183         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
184             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
185             oraclize_setNetworkName("eth_kovan");
186             return true;
187         }
188         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
189             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
190             oraclize_setNetworkName("eth_rinkeby");
191             return true;
192         }
193         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
194             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
195             return true;
196         }
197         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
198             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
199             return true;
200         }
201         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
202             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
203             return true;
204         }
205         return false;
206     }
207 
208     function __callback(bytes32 myid, string result) public {
209         __callback(myid, result, new bytes(0));
210     }
211     function __callback(bytes32 myid, string result, bytes proof) public {
212       return;
213       myid; result; proof; // Silence compiler warnings
214     }
215 
216     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
217         return oraclize.getPrice(datasource);
218     }
219 
220     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
221         return oraclize.getPrice(datasource, gaslimit);
222     }
223 
224     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
225         uint price = oraclize.getPrice(datasource);
226         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
227         return oraclize.query.value(price)(0, datasource, arg);
228     }
229     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
230         uint price = oraclize.getPrice(datasource);
231         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
232         return oraclize.query.value(price)(timestamp, datasource, arg);
233     }
234     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
235         uint price = oraclize.getPrice(datasource, gaslimit);
236         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
237         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
238     }
239     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
240         uint price = oraclize.getPrice(datasource, gaslimit);
241         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
242         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
243     }
244     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
245         uint price = oraclize.getPrice(datasource);
246         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
247         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
248     }
249     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
250         uint price = oraclize.getPrice(datasource);
251         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
252         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
253     }
254     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
255         uint price = oraclize.getPrice(datasource, gaslimit);
256         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
257         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
258     }
259     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
260         uint price = oraclize.getPrice(datasource, gaslimit);
261         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
262         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
263     }
264     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
265         uint price = oraclize.getPrice(datasource);
266         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
267         bytes memory args = stra2cbor(argN);
268         return oraclize.queryN.value(price)(0, datasource, args);
269     }
270     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
271         uint price = oraclize.getPrice(datasource);
272         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
273         bytes memory args = stra2cbor(argN);
274         return oraclize.queryN.value(price)(timestamp, datasource, args);
275     }
276     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
277         uint price = oraclize.getPrice(datasource, gaslimit);
278         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
279         bytes memory args = stra2cbor(argN);
280         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
281     }
282     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
283         uint price = oraclize.getPrice(datasource, gaslimit);
284         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
285         bytes memory args = stra2cbor(argN);
286         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
287     }
288     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
289         string[] memory dynargs = new string[](1);
290         dynargs[0] = args[0];
291         return oraclize_query(datasource, dynargs);
292     }
293     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
294         string[] memory dynargs = new string[](1);
295         dynargs[0] = args[0];
296         return oraclize_query(timestamp, datasource, dynargs);
297     }
298     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
299         string[] memory dynargs = new string[](1);
300         dynargs[0] = args[0];
301         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
302     }
303     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
304         string[] memory dynargs = new string[](1);
305         dynargs[0] = args[0];
306         return oraclize_query(datasource, dynargs, gaslimit);
307     }
308 
309     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
310         string[] memory dynargs = new string[](2);
311         dynargs[0] = args[0];
312         dynargs[1] = args[1];
313         return oraclize_query(datasource, dynargs);
314     }
315     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
316         string[] memory dynargs = new string[](2);
317         dynargs[0] = args[0];
318         dynargs[1] = args[1];
319         return oraclize_query(timestamp, datasource, dynargs);
320     }
321     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
322         string[] memory dynargs = new string[](2);
323         dynargs[0] = args[0];
324         dynargs[1] = args[1];
325         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
326     }
327     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
328         string[] memory dynargs = new string[](2);
329         dynargs[0] = args[0];
330         dynargs[1] = args[1];
331         return oraclize_query(datasource, dynargs, gaslimit);
332     }
333     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
334         string[] memory dynargs = new string[](3);
335         dynargs[0] = args[0];
336         dynargs[1] = args[1];
337         dynargs[2] = args[2];
338         return oraclize_query(datasource, dynargs);
339     }
340     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
341         string[] memory dynargs = new string[](3);
342         dynargs[0] = args[0];
343         dynargs[1] = args[1];
344         dynargs[2] = args[2];
345         return oraclize_query(timestamp, datasource, dynargs);
346     }
347     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
348         string[] memory dynargs = new string[](3);
349         dynargs[0] = args[0];
350         dynargs[1] = args[1];
351         dynargs[2] = args[2];
352         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
353     }
354     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
355         string[] memory dynargs = new string[](3);
356         dynargs[0] = args[0];
357         dynargs[1] = args[1];
358         dynargs[2] = args[2];
359         return oraclize_query(datasource, dynargs, gaslimit);
360     }
361 
362     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
363         string[] memory dynargs = new string[](4);
364         dynargs[0] = args[0];
365         dynargs[1] = args[1];
366         dynargs[2] = args[2];
367         dynargs[3] = args[3];
368         return oraclize_query(datasource, dynargs);
369     }
370     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
371         string[] memory dynargs = new string[](4);
372         dynargs[0] = args[0];
373         dynargs[1] = args[1];
374         dynargs[2] = args[2];
375         dynargs[3] = args[3];
376         return oraclize_query(timestamp, datasource, dynargs);
377     }
378     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
379         string[] memory dynargs = new string[](4);
380         dynargs[0] = args[0];
381         dynargs[1] = args[1];
382         dynargs[2] = args[2];
383         dynargs[3] = args[3];
384         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
385     }
386     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
387         string[] memory dynargs = new string[](4);
388         dynargs[0] = args[0];
389         dynargs[1] = args[1];
390         dynargs[2] = args[2];
391         dynargs[3] = args[3];
392         return oraclize_query(datasource, dynargs, gaslimit);
393     }
394     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
395         string[] memory dynargs = new string[](5);
396         dynargs[0] = args[0];
397         dynargs[1] = args[1];
398         dynargs[2] = args[2];
399         dynargs[3] = args[3];
400         dynargs[4] = args[4];
401         return oraclize_query(datasource, dynargs);
402     }
403     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
404         string[] memory dynargs = new string[](5);
405         dynargs[0] = args[0];
406         dynargs[1] = args[1];
407         dynargs[2] = args[2];
408         dynargs[3] = args[3];
409         dynargs[4] = args[4];
410         return oraclize_query(timestamp, datasource, dynargs);
411     }
412     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
413         string[] memory dynargs = new string[](5);
414         dynargs[0] = args[0];
415         dynargs[1] = args[1];
416         dynargs[2] = args[2];
417         dynargs[3] = args[3];
418         dynargs[4] = args[4];
419         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
420     }
421     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
422         string[] memory dynargs = new string[](5);
423         dynargs[0] = args[0];
424         dynargs[1] = args[1];
425         dynargs[2] = args[2];
426         dynargs[3] = args[3];
427         dynargs[4] = args[4];
428         return oraclize_query(datasource, dynargs, gaslimit);
429     }
430     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
431         uint price = oraclize.getPrice(datasource);
432         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
433         bytes memory args = ba2cbor(argN);
434         return oraclize.queryN.value(price)(0, datasource, args);
435     }
436     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
437         uint price = oraclize.getPrice(datasource);
438         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
439         bytes memory args = ba2cbor(argN);
440         return oraclize.queryN.value(price)(timestamp, datasource, args);
441     }
442     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
443         uint price = oraclize.getPrice(datasource, gaslimit);
444         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
445         bytes memory args = ba2cbor(argN);
446         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
447     }
448     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
449         uint price = oraclize.getPrice(datasource, gaslimit);
450         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
451         bytes memory args = ba2cbor(argN);
452         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
453     }
454     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
455         bytes[] memory dynargs = new bytes[](1);
456         dynargs[0] = args[0];
457         return oraclize_query(datasource, dynargs);
458     }
459     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
460         bytes[] memory dynargs = new bytes[](1);
461         dynargs[0] = args[0];
462         return oraclize_query(timestamp, datasource, dynargs);
463     }
464     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
465         bytes[] memory dynargs = new bytes[](1);
466         dynargs[0] = args[0];
467         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
468     }
469     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
470         bytes[] memory dynargs = new bytes[](1);
471         dynargs[0] = args[0];
472         return oraclize_query(datasource, dynargs, gaslimit);
473     }
474 
475     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
476         bytes[] memory dynargs = new bytes[](2);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         return oraclize_query(datasource, dynargs);
480     }
481     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
482         bytes[] memory dynargs = new bytes[](2);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         return oraclize_query(timestamp, datasource, dynargs);
486     }
487     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
488         bytes[] memory dynargs = new bytes[](2);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
492     }
493     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
494         bytes[] memory dynargs = new bytes[](2);
495         dynargs[0] = args[0];
496         dynargs[1] = args[1];
497         return oraclize_query(datasource, dynargs, gaslimit);
498     }
499     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
500         bytes[] memory dynargs = new bytes[](3);
501         dynargs[0] = args[0];
502         dynargs[1] = args[1];
503         dynargs[2] = args[2];
504         return oraclize_query(datasource, dynargs);
505     }
506     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
507         bytes[] memory dynargs = new bytes[](3);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         return oraclize_query(timestamp, datasource, dynargs);
512     }
513     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
514         bytes[] memory dynargs = new bytes[](3);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
519     }
520     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
521         bytes[] memory dynargs = new bytes[](3);
522         dynargs[0] = args[0];
523         dynargs[1] = args[1];
524         dynargs[2] = args[2];
525         return oraclize_query(datasource, dynargs, gaslimit);
526     }
527 
528     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
529         bytes[] memory dynargs = new bytes[](4);
530         dynargs[0] = args[0];
531         dynargs[1] = args[1];
532         dynargs[2] = args[2];
533         dynargs[3] = args[3];
534         return oraclize_query(datasource, dynargs);
535     }
536     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
537         bytes[] memory dynargs = new bytes[](4);
538         dynargs[0] = args[0];
539         dynargs[1] = args[1];
540         dynargs[2] = args[2];
541         dynargs[3] = args[3];
542         return oraclize_query(timestamp, datasource, dynargs);
543     }
544     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
545         bytes[] memory dynargs = new bytes[](4);
546         dynargs[0] = args[0];
547         dynargs[1] = args[1];
548         dynargs[2] = args[2];
549         dynargs[3] = args[3];
550         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
551     }
552     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
553         bytes[] memory dynargs = new bytes[](4);
554         dynargs[0] = args[0];
555         dynargs[1] = args[1];
556         dynargs[2] = args[2];
557         dynargs[3] = args[3];
558         return oraclize_query(datasource, dynargs, gaslimit);
559     }
560     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
561         bytes[] memory dynargs = new bytes[](5);
562         dynargs[0] = args[0];
563         dynargs[1] = args[1];
564         dynargs[2] = args[2];
565         dynargs[3] = args[3];
566         dynargs[4] = args[4];
567         return oraclize_query(datasource, dynargs);
568     }
569     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
570         bytes[] memory dynargs = new bytes[](5);
571         dynargs[0] = args[0];
572         dynargs[1] = args[1];
573         dynargs[2] = args[2];
574         dynargs[3] = args[3];
575         dynargs[4] = args[4];
576         return oraclize_query(timestamp, datasource, dynargs);
577     }
578     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
579         bytes[] memory dynargs = new bytes[](5);
580         dynargs[0] = args[0];
581         dynargs[1] = args[1];
582         dynargs[2] = args[2];
583         dynargs[3] = args[3];
584         dynargs[4] = args[4];
585         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
586     }
587     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
588         bytes[] memory dynargs = new bytes[](5);
589         dynargs[0] = args[0];
590         dynargs[1] = args[1];
591         dynargs[2] = args[2];
592         dynargs[3] = args[3];
593         dynargs[4] = args[4];
594         return oraclize_query(datasource, dynargs, gaslimit);
595     }
596 
597     function oraclize_cbAddress() oraclizeAPI internal returns (address){
598         return oraclize.cbAddress();
599     }
600     function oraclize_setProof(byte proofP) oraclizeAPI internal {
601         return oraclize.setProofType(proofP);
602     }
603     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
604         return oraclize.setCustomGasPrice(gasPrice);
605     }
606 
607     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
608         return oraclize.randomDS_getSessionPubKeyHash();
609     }
610 
611     function getCodeSize(address _addr) constant internal returns(uint _size) {
612         assembly {
613             _size := extcodesize(_addr)
614         }
615     }
616 
617     function parseAddr(string _a) internal pure returns (address){
618         bytes memory tmp = bytes(_a);
619         uint160 iaddr = 0;
620         uint160 b1;
621         uint160 b2;
622         for (uint i=2; i<2+2*20; i+=2){
623             iaddr *= 256;
624             b1 = uint160(tmp[i]);
625             b2 = uint160(tmp[i+1]);
626             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
627             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
628             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
629             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
630             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
631             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
632             iaddr += (b1*16+b2);
633         }
634         return address(iaddr);
635     }
636 
637     function strCompare(string _a, string _b) internal pure returns (int) {
638         bytes memory a = bytes(_a);
639         bytes memory b = bytes(_b);
640         uint minLength = a.length;
641         if (b.length < minLength) minLength = b.length;
642         for (uint i = 0; i < minLength; i ++)
643             if (a[i] < b[i])
644                 return -1;
645             else if (a[i] > b[i])
646                 return 1;
647         if (a.length < b.length)
648             return -1;
649         else if (a.length > b.length)
650             return 1;
651         else
652             return 0;
653     }
654 
655     function indexOf(string _haystack, string _needle) internal pure returns (int) {
656         bytes memory h = bytes(_haystack);
657         bytes memory n = bytes(_needle);
658         if(h.length < 1 || n.length < 1 || (n.length > h.length))
659             return -1;
660         else if(h.length > (2**128 -1))
661             return -1;
662         else
663         {
664             uint subindex = 0;
665             for (uint i = 0; i < h.length; i ++)
666             {
667                 if (h[i] == n[0])
668                 {
669                     subindex = 1;
670                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
671                     {
672                         subindex++;
673                     }
674                     if(subindex == n.length)
675                         return int(i);
676                 }
677             }
678             return -1;
679         }
680     }
681 
682     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
683         bytes memory _ba = bytes(_a);
684         bytes memory _bb = bytes(_b);
685         bytes memory _bc = bytes(_c);
686         bytes memory _bd = bytes(_d);
687         bytes memory _be = bytes(_e);
688         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
689         bytes memory babcde = bytes(abcde);
690         uint k = 0;
691         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
692         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
693         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
694         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
695         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
696         return string(babcde);
697     }
698 
699     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
700         return strConcat(_a, _b, _c, _d, "");
701     }
702 
703     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
704         return strConcat(_a, _b, _c, "", "");
705     }
706 
707     function strConcat(string _a, string _b) internal pure returns (string) {
708         return strConcat(_a, _b, "", "", "");
709     }
710 
711     // parseInt
712     function parseInt(string _a) internal pure returns (uint) {
713         return parseInt(_a, 0);
714     }
715 
716     // parseInt(parseFloat*10^_b)
717     function parseInt(string _a, uint _b) internal pure returns (uint) {
718         bytes memory bresult = bytes(_a);
719         uint mint = 0;
720         bool decimals = false;
721         for (uint i=0; i<bresult.length; i++){
722             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
723                 if (decimals){
724                    if (_b == 0) break;
725                     else _b--;
726                 }
727                 mint *= 10;
728                 mint += uint(bresult[i]) - 48;
729             } else if (bresult[i] == 46) decimals = true;
730         }
731         if (_b > 0) mint *= 10**_b;
732         return mint;
733     }
734 
735     function uint2str(uint i) internal pure returns (string){
736         if (i == 0) return "0";
737         uint j = i;
738         uint len;
739         while (j != 0){
740             len++;
741             j /= 10;
742         }
743         bytes memory bstr = new bytes(len);
744         uint k = len - 1;
745         while (i != 0){
746             bstr[k--] = byte(48 + i % 10);
747             i /= 10;
748         }
749         return string(bstr);
750     }
751 
752     function stra2cbor(string[] arr) internal pure returns (bytes) {
753             uint arrlen = arr.length;
754 
755             // get correct cbor output length
756             uint outputlen = 0;
757             bytes[] memory elemArray = new bytes[](arrlen);
758             for (uint i = 0; i < arrlen; i++) {
759                 elemArray[i] = (bytes(arr[i]));
760                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
761             }
762             uint ctr = 0;
763             uint cborlen = arrlen + 0x80;
764             outputlen += byte(cborlen).length;
765             bytes memory res = new bytes(outputlen);
766 
767             while (byte(cborlen).length > ctr) {
768                 res[ctr] = byte(cborlen)[ctr];
769                 ctr++;
770             }
771             for (i = 0; i < arrlen; i++) {
772                 res[ctr] = 0x5F;
773                 ctr++;
774                 for (uint x = 0; x < elemArray[i].length; x++) {
775                     // if there's a bug with larger strings, this may be the culprit
776                     if (x % 23 == 0) {
777                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
778                         elemcborlen += 0x40;
779                         uint lctr = ctr;
780                         while (byte(elemcborlen).length > ctr - lctr) {
781                             res[ctr] = byte(elemcborlen)[ctr - lctr];
782                             ctr++;
783                         }
784                     }
785                     res[ctr] = elemArray[i][x];
786                     ctr++;
787                 }
788                 res[ctr] = 0xFF;
789                 ctr++;
790             }
791             return res;
792         }
793 
794     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
795             uint arrlen = arr.length;
796 
797             // get correct cbor output length
798             uint outputlen = 0;
799             bytes[] memory elemArray = new bytes[](arrlen);
800             for (uint i = 0; i < arrlen; i++) {
801                 elemArray[i] = (bytes(arr[i]));
802                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
803             }
804             uint ctr = 0;
805             uint cborlen = arrlen + 0x80;
806             outputlen += byte(cborlen).length;
807             bytes memory res = new bytes(outputlen);
808 
809             while (byte(cborlen).length > ctr) {
810                 res[ctr] = byte(cborlen)[ctr];
811                 ctr++;
812             }
813             for (i = 0; i < arrlen; i++) {
814                 res[ctr] = 0x5F;
815                 ctr++;
816                 for (uint x = 0; x < elemArray[i].length; x++) {
817                     // if there's a bug with larger strings, this may be the culprit
818                     if (x % 23 == 0) {
819                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
820                         elemcborlen += 0x40;
821                         uint lctr = ctr;
822                         while (byte(elemcborlen).length > ctr - lctr) {
823                             res[ctr] = byte(elemcborlen)[ctr - lctr];
824                             ctr++;
825                         }
826                     }
827                     res[ctr] = elemArray[i][x];
828                     ctr++;
829                 }
830                 res[ctr] = 0xFF;
831                 ctr++;
832             }
833             return res;
834         }
835 
836 
837     string oraclize_network_name;
838     function oraclize_setNetworkName(string _network_name) internal {
839         oraclize_network_name = _network_name;
840     }
841 
842     function oraclize_getNetworkName() internal view returns (string) {
843         return oraclize_network_name;
844     }
845 
846     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
847         require((_nbytes > 0) && (_nbytes <= 32));
848         bytes memory nbytes = new bytes(1);
849         nbytes[0] = byte(_nbytes);
850         bytes memory unonce = new bytes(32);
851         bytes memory sessionKeyHash = new bytes(32);
852         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
853         assembly {
854             mstore(unonce, 0x20)
855             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
856             mstore(sessionKeyHash, 0x20)
857             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
858         }
859         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
860         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
861         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
862         return queryId;
863     }
864 
865     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
866         oraclize_randomDS_args[queryId] = commitment;
867     }
868 
869     mapping(bytes32=>bytes32) oraclize_randomDS_args;
870     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
871 
872     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
873         bool sigok;
874         address signer;
875 
876         bytes32 sigr;
877         bytes32 sigs;
878 
879         bytes memory sigr_ = new bytes(32);
880         uint offset = 4+(uint(dersig[3]) - 0x20);
881         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
882         bytes memory sigs_ = new bytes(32);
883         offset += 32 + 2;
884         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
885 
886         assembly {
887             sigr := mload(add(sigr_, 32))
888             sigs := mload(add(sigs_, 32))
889         }
890 
891 
892         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
893         if (address(keccak256(pubkey)) == signer) return true;
894         else {
895             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
896             return (address(keccak256(pubkey)) == signer);
897         }
898     }
899 
900     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
901         bool sigok;
902 
903         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
904         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
905         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
906 
907         bytes memory appkey1_pubkey = new bytes(64);
908         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
909 
910         bytes memory tosign2 = new bytes(1+65+32);
911         tosign2[0] = byte(1); //role
912         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
913         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
914         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
915         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
916 
917         if (sigok == false) return false;
918 
919 
920         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
921         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
922 
923         bytes memory tosign3 = new bytes(1+65);
924         tosign3[0] = 0xFE;
925         copyBytes(proof, 3, 65, tosign3, 1);
926 
927         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
928         copyBytes(proof, 3+65, sig3.length, sig3, 0);
929 
930         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
931 
932         return sigok;
933     }
934 
935     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
936         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
937         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
938 
939         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
940         require(proofVerified);
941 
942         _;
943     }
944 
945     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
946         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
947         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
948 
949         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
950         if (proofVerified == false) return 2;
951 
952         return 0;
953     }
954 
955     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
956         bool match_ = true;
957         
958 
959         for (uint256 i=0; i< n_random_bytes; i++) {
960             if (content[i] != prefix[i]) match_ = false;
961         }
962 
963         return match_;
964     }
965 
966     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
967 
968         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
969         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
970         bytes memory keyhash = new bytes(32);
971         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
972         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
973 
974         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
975         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
976 
977         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
978         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
979 
980         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
981         // This is to verify that the computed args match with the ones specified in the query.
982         bytes memory commitmentSlice1 = new bytes(8+1+32);
983         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
984 
985         bytes memory sessionPubkey = new bytes(64);
986         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
987         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
988 
989         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
990         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
991             delete oraclize_randomDS_args[queryId];
992         } else return false;
993 
994 
995         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
996         bytes memory tosign1 = new bytes(32+8+1+32);
997         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
998         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
999 
1000         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1001         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1002             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1003         }
1004 
1005         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1006     }
1007 
1008     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1009     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1010         uint minLength = length + toOffset;
1011 
1012         // Buffer too small
1013         require(to.length >= minLength); // Should be a better way?
1014 
1015         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1016         uint i = 32 + fromOffset;
1017         uint j = 32 + toOffset;
1018 
1019         while (i < (32 + fromOffset + length)) {
1020             assembly {
1021                 let tmp := mload(add(from, i))
1022                 mstore(add(to, j), tmp)
1023             }
1024             i += 32;
1025             j += 32;
1026         }
1027 
1028         return to;
1029     }
1030 
1031     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1032     // Duplicate Solidity's ecrecover, but catching the CALL return value
1033     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1034         // We do our own memory management here. Solidity uses memory offset
1035         // 0x40 to store the current end of memory. We write past it (as
1036         // writes are memory extensions), but don't update the offset so
1037         // Solidity will reuse it. The memory used here is only needed for
1038         // this context.
1039 
1040         // FIXME: inline assembly can't access return values
1041         bool ret;
1042         address addr;
1043 
1044         assembly {
1045             let size := mload(0x40)
1046             mstore(size, hash)
1047             mstore(add(size, 32), v)
1048             mstore(add(size, 64), r)
1049             mstore(add(size, 96), s)
1050 
1051             // NOTE: we can reuse the request memory because we deal with
1052             //       the return code
1053             ret := call(3000, 1, 0, size, 128, size, 32)
1054             addr := mload(size)
1055         }
1056 
1057         return (ret, addr);
1058     }
1059 
1060     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1061     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1062         bytes32 r;
1063         bytes32 s;
1064         uint8 v;
1065 
1066         if (sig.length != 65)
1067           return (false, 0);
1068 
1069         // The signature format is a compact form of:
1070         //   {bytes32 r}{bytes32 s}{uint8 v}
1071         // Compact means, uint8 is not padded to 32 bytes.
1072         assembly {
1073             r := mload(add(sig, 32))
1074             s := mload(add(sig, 64))
1075 
1076             // Here we are loading the last 32 bytes. We exploit the fact that
1077             // 'mload' will pad with zeroes if we overread.
1078             // There is no 'mload8' to do this, but that would be nicer.
1079             v := byte(0, mload(add(sig, 96)))
1080 
1081             // Alternative solution:
1082             // 'byte' is not working due to the Solidity parser, so lets
1083             // use the second best option, 'and'
1084             // v := and(mload(add(sig, 65)), 255)
1085         }
1086 
1087         // albeit non-transactional signatures are not specified by the YP, one would expect it
1088         // to match the YP range of [27, 28]
1089         //
1090         // geth uses [0, 1] and some clients have followed. This might change, see:
1091         //  https://github.com/ethereum/go-ethereum/issues/2053
1092         if (v < 27)
1093           v += 27;
1094 
1095         if (v != 27 && v != 28)
1096             return (false, 0);
1097 
1098         return safer_ecrecover(hash, v, r, s);
1099     }
1100 
1101 }
1102 // </ORACLIZE_API>
1103 
1104 /**
1105  * @title pre-ico
1106  * @dev pre-ico is a base contract for managing a token crowdsale.
1107  * Crowdsales
1108  */
1109 contract PreIco is usingOraclize {
1110   using SafeMath for uint256;
1111 
1112   /**
1113    * Section 1
1114    * - Variables
1115    */
1116   /* Section 1.1 crowdsale key variables */
1117   // The token being sold
1118   Token public token;
1119 
1120   // start and end timestamps where investments are allowed (both inclusive)
1121   uint256 public startTime;
1122   uint256 public endTime;
1123 
1124   // address where ETH funds are sent
1125   address public wallet;
1126 
1127   // owner of this contract
1128   address public owner;
1129   // How many PHI tokens to sell (in sphi)
1130   uint256 public MAX_TOKENS = 3524578 * 10**18;
1131   // Keep track of sold tokens
1132   uint256 public tokensSold = 0;
1133   // Keep track of tokens sent to whitelisted addresses
1134   uint256 public tokensFinalized = 0;
1135   // Keep track of enabled addresses
1136   mapping(address => bool) public reservationContracts;
1137 
1138   /* Section 1.2 rate/price variables */
1139   // ETH/USD rate
1140   uint256 public ethUsd;
1141   /**
1142     * Phi rate in USD multiplied by 10**18
1143     * because of Solidity float limitations,
1144     * see http://solidity.readthedocs.io/en/v0.4.19/types.html?highlight=Fixed%20Point%20Numbers#fixed-point-numbers
1145     */
1146   uint256 public phiRate = 1278246852100000000; // pre-ico fixed price (1,61803399 * 21%) * 10**18
1147 
1148   /* Section 1.3 oracle related variables */
1149   // keep track of the last ETH/USD update
1150   uint256 public lastOracleUpdate;
1151   // set default ETH/USD update interval (in seconds)
1152   uint256 public intervalUpdate;
1153   // custom oraclize_query gas cost (wei), expected gas usage is ~110k
1154   uint256 public ORACLIZE_GAS_LIMIT = 145000;
1155 
1156   /* Section 1.4 variables to keep KYC and balance state */
1157   // amount of raised money in wei
1158   uint256 public weiRaised;
1159   // keep track of addresses that are allowed to keep tokens
1160   mapping(address => bool) public isWhitelisted;
1161   // keep track of investors (token balance)
1162   mapping(address => uint256) public balancesToken;
1163   // keep track of invested amount (wei balance)
1164   mapping(address => uint256) public balancesWei;
1165 
1166   /**
1167    * Section 2
1168    * - Enums
1169    */
1170   // Describes current crowdsale stage
1171   enum Stage
1172   {
1173     ToInitialize, // [0] pre-ico has not been initialized
1174     Waiting,      // [1] pre-ico is waiting start time
1175     Running,      // [2] pre-ico is running (between start time and end time)
1176     Paused,       // [3] pre-ico has been paused
1177     Finished,     // [4] pre-ico has been finished (but not finalized)
1178     Finalized     // [5] pre-ico has been finalized
1179   }
1180   Stage public currentStage = Stage.ToInitialize;
1181 
1182   /**
1183    * Section 3
1184    * - Events
1185    */
1186   /**
1187    * event for token purchase logging
1188    * @param purchaser who paid for the tokens
1189    * @param beneficiary who got the tokens
1190    * @param value weis paid for purchase
1191    * @param amount amount of tokens purchased
1192    */
1193   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1194 
1195   /**
1196    * event to emit when a new rate is received from Oraclize
1197    * @param newRate Rate received in WEI
1198    * @param timeRecv When the rate was received
1199    */
1200   event LogRateUpdate(uint newRate, uint timeRecv);
1201 
1202   /**
1203    * event to emit in case the contract needs balance (for Oraclize queries)
1204    */
1205   event LogBalanceRequired();
1206 
1207   /**
1208    * event to notify initialize
1209    */
1210    event LogCrowdsaleInit();
1211 
1212   /**
1213    * Section 4
1214    * - Modifiers
1215    */
1216   /*
1217     Check if a purchase can be made, check startTime, endTime
1218     and update Stage if so
1219   */
1220   modifier validPurchase {
1221     bool withinPeriod = now >= startTime && now <= endTime;
1222     require(msg.value > 0 && withinPeriod && startTime != 0);
1223     /*
1224       Update current stage only if the previous stage is `Waiting`
1225       and we are within the crowdsale period, used to automatically
1226       update the stage by an investor
1227     */
1228     if (withinPeriod == true && currentStage == Stage.Waiting) {
1229       currentStage = Stage.Running;
1230     }
1231     _;
1232   }
1233   // Allow only the owner of this contract
1234   modifier onlyOwner {
1235     require(msg.sender == owner);
1236     _;
1237   }
1238 
1239   // Allow only if is close to start time or if is it running
1240   modifier closeOrDuringCrowdsale {
1241     require(now >= startTime - intervalUpdate);
1242     require(currentStage == Stage.Running || currentStage == Stage.Waiting);
1243     _;
1244   }
1245 
1246   // Check if the provided stage is the current one
1247   modifier mustBeAtStage (Stage stageNeeded) {
1248     require(stageNeeded == currentStage);
1249     _;
1250   }
1251 
1252   // Allow only to proxy from reservation contract
1253   modifier onlyFromRc () {
1254     require(reservationContracts[msg.sender] == true);
1255     _;
1256   }
1257 
1258   /**
1259    * @dev Constructor
1260    * @param _wallet Where to send ETH collected from the pre-ico
1261    */
1262   function PreIco(address _wallet) public {
1263     require(phiRate > 0 && startTime == 0);
1264     require(_wallet != address(0));
1265 
1266     // update global variable
1267     wallet = _wallet;
1268     owner = msg.sender;
1269 
1270     currentStage = Stage.ToInitialize;
1271 
1272     // set Oraclize gas price (for __callback)
1273     oraclize_setCustomGasPrice(2500000000); // 2.5 gwei instead of 20 gwei
1274   }
1275 
1276   /**
1277    * @dev Used to init crowdsale, set start-end time, start usd rate update
1278    * @notice You must send some ETH to cover the oraclize_query fees
1279    * @param _startTime Start of the crowdsale (UNIX timestamp)
1280    * @param _endTime End of the crowdsale (UNIX timestamp)
1281    * @param _token Address of the PHI ERC223 Token
1282    */
1283   function initializeCrowdsale(
1284     uint256 _startTime,
1285     uint256 _endTime,
1286     address _token,
1287     uint256 _intervalUpdate
1288   )
1289     public
1290     payable
1291     onlyOwner
1292     mustBeAtStage(Stage.ToInitialize)
1293   {
1294     require(_startTime >= now);
1295     require(_endTime >= _startTime);
1296     require(_token != address(0));
1297     require(msg.value > 0);
1298     require(isContract(_token) == true);
1299 
1300     // interval update must be above or equal to 5 seconds
1301     require(_intervalUpdate >= 5);
1302 
1303     // update global variables
1304     startTime = _startTime;
1305     endTime = _endTime;
1306     token = Token(_token);
1307     intervalUpdate = _intervalUpdate;
1308 
1309     // update stage
1310     currentStage = Stage.Waiting;
1311 
1312     /*
1313       start to fetch ETH/USD price `intervalUpdate` before the `startTime`,
1314       30 seconds is added because Oraclize takes time to call the __callback
1315     */
1316     updateEthRateWithDelay(startTime - (intervalUpdate + 30));
1317 
1318     LogCrowdsaleInit();
1319 
1320     // check amount of tokens held by this contract matches MAX_TOKENS
1321     assert(token.balanceOf(address(this)) == MAX_TOKENS);
1322   }
1323 
1324   /**
1325    * @dev Allow a new reservation contract to invest in the pre-ico
1326    * @notice Call this before the startTime to avoid delays
1327    * @param newRcAddr Address of the reservation contract
1328    * you want to enable (must be a contract)
1329    */
1330    function addNewReservContract (address newRcAddr) public onlyOwner {
1331     require(isContract(newRcAddr) == true);
1332     require(newRcAddr != 0x0 && newRcAddr != address(this) && newRcAddr != address(token));
1333     require(reservationContracts[newRcAddr] == false);
1334     reservationContracts[newRcAddr] = true;
1335    }
1336 
1337   /**
1338    * @dev Remove a reservation contract
1339    * @param toRemove Address of the reservation contract
1340    * you want to remove
1341    */
1342    function removeReservContract (address toRemove) public onlyOwner {
1343     require(reservationContracts[toRemove] == true);
1344     reservationContracts[toRemove] = false;
1345    }
1346 
1347   /* Oraclize related functions */
1348   /**
1349    * @dev Callback function used by Oraclize to update the price.
1350    * @notice ETH/USD rate is receivd and converted to wei, this
1351    * functions is used also to automatically update the stage status
1352    * @param myid Unique identifier for Oraclize queries
1353    * @param result Result of the requested query
1354    */
1355   function __callback(
1356     bytes32 myid,
1357     string result
1358   ) 
1359     public
1360     closeOrDuringCrowdsale
1361   {
1362     if (msg.sender != oraclize_cbAddress()) revert();
1363     // parse to int and multiply by 10**18 to allow math operations
1364     uint256 usdRate = parseInt(result, 18);
1365     // do not allow 0
1366     require(usdRate > 0);
1367 
1368     ethUsd = usdRate;
1369 
1370     LogRateUpdate(ethUsd, now);
1371 
1372     // check if time is over
1373     if (hasEnded() == true) {
1374       currentStage = Stage.Finished;
1375     } else {
1376       updateEthRate();
1377       lastOracleUpdate = now;
1378     }
1379   }
1380 
1381   /**
1382    * @dev Update ETH/USD rate manually in case Oraclize is not
1383    * calling by our contract
1384    * @notice An integer is required (e.g. 870, 910), this function
1385    * will also multiplicate by 10**18
1386    * @param _newEthUsd New ETH/USD rate integer
1387    */
1388   function updateEthUsdManually (uint _newEthUsd) public onlyOwner {
1389     require(_newEthUsd > 0);
1390     uint256 newRate = _newEthUsd.mul(10**18);
1391     require(newRate > 0);
1392     ethUsd = newRate;
1393   } 
1394 
1395   /**
1396    * @dev Used to recursively call the oraclize query 
1397    * @notice This function will not throw in case the
1398    * interval update is exceeded, in this way the latest
1399    * update made to the ETH/USD rate is kept 
1400    */
1401   function updateEthRate () internal {
1402     // prevent multiple updates
1403     if(intervalUpdate > (now - lastOracleUpdate)) {}
1404     else {
1405       updateEthRateWithDelay(intervalUpdate);
1406     }
1407   }
1408 
1409   /**
1410    * @dev Change interval update
1411    * @param newInterval New interval rate (in seconds)
1412    */
1413   function changeIntervalUpdate (uint newInterval) public onlyOwner {
1414     require(newInterval >= 5);
1415     intervalUpdate = newInterval;
1416   }
1417 
1418   /**
1419    * @dev Helper function around oraclize_query
1420    * @notice Call oraclize_query with a delay in seconds
1421    * @param delay Delay in seconds 
1422    */
1423   function updateEthRateWithDelay (uint delay) internal {
1424     // delay cannot be below 5 seconds (too fast)
1425     require(delay >= 5);
1426     if (oraclize_getPrice("URL", ORACLIZE_GAS_LIMIT) > this.balance) {
1427       // Notify that we need a top up 
1428       LogBalanceRequired();
1429     } else {
1430         // Get ETH/USD rate from kraken API
1431         oraclize_query(
1432           delay,
1433           "URL",
1434           "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0",
1435           ORACLIZE_GAS_LIMIT
1436         );
1437     }
1438   }
1439 
1440   /**
1441    * @dev Allow owner to force rate update
1442    * @param delay Delay in seconds of oraclize_query, can be set to 5 (minimum)
1443    */
1444   function forceOraclizeUpdate (uint256 delay) public onlyOwner {
1445     updateEthRateWithDelay(delay);
1446   }
1447 
1448   /**
1449    * @dev Change Oraclize gas limit (used in oraclize_query)
1450    * @notice To be used in case the default gas cost is too low
1451    * @param newGas New gas to use (in wei)
1452    */
1453   function changeOraclizeGas(uint newGas) public onlyOwner {
1454     require(newGas > 0 && newGas <= 4000000);
1455     ORACLIZE_GAS_LIMIT = newGas;
1456   }
1457 
1458   /**
1459    * @dev Change Oraclize gas price
1460    * @notice To be used in case the default gas price is too low
1461    * @param _gasPrice Gas price in wei
1462    */
1463   function changeOraclizeGasPrice(uint _gasPrice) public onlyOwner {
1464     require(_gasPrice >= 1000000000); // minimum 1 gwei
1465     oraclize_setCustomGasPrice(_gasPrice);
1466   }
1467 
1468   /**
1469    * @dev Top up balance
1470    * @notice This function must be used **only if 
1471    * this contract balance is too low for oraclize_query
1472    * to be executed**
1473    * @param verifyCode Used only to allow people that read
1474    * the notice (not accidental)
1475    */
1476   function topUpBalance (uint verifyCode) public payable mustBeAtStage(Stage.Running) {
1477     // value is required
1478     require(msg.value > 0);
1479     // make sure only the people that read
1480     // this can use the function
1481     require(verifyCode == 28391728448);
1482   }
1483 
1484   /**
1485    * @dev Withdraw balance of this contract to the `wallet` address
1486    * @notice Used only if there are some leftover
1487    * funds (because of topUpBalance)
1488   */
1489   function withdrawBalance() public mustBeAtStage(Stage.Finalized) {
1490     wallet.transfer(this.balance);
1491   }
1492 
1493   /* Invest related functions */
1494   /**
1495    * @dev Low level function to purchase function on behalf of a beneficiary
1496    * @notice If you call directly this function your are buying for someone else
1497    * @param beneficiary Where tokens should be sent
1498    */
1499   function buyTokens(address beneficiary) public onlyFromRc validPurchase mustBeAtStage(Stage.Running) payable {
1500     require(beneficiary != address(0));
1501     require(beneficiary != address(this));
1502     require(msg.value >= 1 ether);
1503 
1504     uint256 weiAmount = msg.value;
1505 
1506     // calculate token amount to be transfered
1507     uint256 tokens = getTokenAmount(weiAmount);
1508 
1509     require(tokens > 0);
1510     // check if we are below MAX_TOKENS
1511     require(tokensSold.add(tokens) <= MAX_TOKENS);
1512 
1513     // update tokens sold
1514     tokensSold = tokensSold.add(tokens);
1515 
1516     // update total wei counter
1517     weiRaised = weiRaised.add(weiAmount);
1518 
1519     // update balance of the beneficiary
1520     balancesToken[beneficiary] = balancesToken[beneficiary].add(tokens);
1521     balancesWei[beneficiary] = balancesWei[beneficiary].add(weiAmount);
1522 
1523     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1524 
1525     // forward ETH
1526     forwardFunds();
1527   }
1528 
1529   /**
1530    * @dev send ether to the fund collection wallet
1531    */
1532   function forwardFunds() internal {
1533     wallet.transfer(msg.value);
1534   }
1535 
1536   /* Finalize/whitelist functions */
1537 
1538   /**
1539    * @dev Add multiple whitelisted addresses
1540    * @notice Must be called after the crowdsale has finished
1541    * @param investors Array or investors to enable
1542    */ 
1543   function addWhitelistAddrByList (address[] investors) public onlyOwner mustBeAtStage(Stage.Finished) {
1544     for(uint256 i = 0; i < investors.length; i++) {
1545       addWhitelistAddress(investors[i]);
1546     }
1547   }
1548 
1549   /**
1550    * @dev Whitelist a specific address
1551    * @notice This is mainly an helper function but can be useful in
1552    * case the `addWhitelistAddrs` loop has issues
1553    * @param investor Investor to whitelist
1554    */ 
1555   function addWhitelistAddress (address investor) public onlyOwner mustBeAtStage(Stage.Finished) {
1556     require(investor != address(0) && investor != address(this));
1557     require(isWhitelisted[investor] == false);
1558     require(balancesToken[investor] > 0);
1559     isWhitelisted[investor] = true;
1560   }
1561 
1562   /**
1563    * @dev Remove an address from whitelist
1564    */
1565   function removeWhitelistedAddress (address toRemove) public onlyOwner mustBeAtStage(Stage.Finished) {
1566     require(isWhitelisted[toRemove] == true);
1567     isWhitelisted[toRemove] = false;
1568   }
1569 
1570   /**
1571    * @dev Finalize crowdsale with investors array
1572    * @notice Transfers tokens to whitelisted addresses
1573    */
1574   function finalizeInvestorsByList(address[] investors) public onlyOwner mustBeAtStage(Stage.Finished) {
1575     for(uint256 i = 0; i < investors.length; i++) {
1576       finalizeSingleInvestor(investors[i]);
1577     }
1578   }
1579 
1580   /**
1581    * @dev Finalize a specific investor
1582    * @notice This is mainly an helper function to `finalize` but
1583    * can be used if `finalize` has issues with the loop
1584    * @param investorAddr Address to finalize
1585    */
1586   function finalizeSingleInvestor(address investorAddr) public onlyOwner mustBeAtStage(Stage.Finished) {
1587     require(investorAddr != address(0) && investorAddr != address(this));
1588     require(balancesToken[investorAddr] > 0);
1589     require(isWhitelisted[investorAddr] == true);
1590     // save data into variables
1591     uint256 balanceToTransfer = balancesToken[investorAddr];
1592     // reset current state
1593     balancesToken[investorAddr] = 0;
1594     isWhitelisted[investorAddr] = false;
1595     // transfer token to the investor address and the balance
1596     // that we have recorded before
1597     require(token.transfer(investorAddr, balanceToTransfer));
1598     // update tokens sent
1599     tokensFinalized = tokensFinalized.add(balanceToTransfer);
1600     assert(tokensFinalized <= MAX_TOKENS);
1601   }
1602 
1603   /**
1604    * @dev Burn unsold tokens
1605    * @notice Call this function after finalizing
1606    */
1607   function burnRemainingTokens() public onlyOwner mustBeAtStage(Stage.Finalized) {
1608     // should always be true
1609     require(MAX_TOKENS >= tokensFinalized);
1610     uint unsold = MAX_TOKENS.sub(tokensFinalized);
1611     if (unsold > 0) {
1612       token.burn(unsold);
1613     }
1614   }
1615 
1616   /**
1617    * @dev Burn all remaining tokens held by this contract
1618    * @notice Get the token balance of this contract and burns all tokens
1619    */
1620   function burnAllTokens() public onlyOwner mustBeAtStage(Stage.Finalized) {
1621     uint thisTokenBalance = token.balanceOf(address(this));
1622     if (thisTokenBalance > 0) {
1623       token.burn(thisTokenBalance);
1624     }
1625   }
1626 
1627   /**
1628    * @dev Allow to change the current stage
1629    * @param newStage New stage
1630    */
1631   function changeStage (Stage newStage) public onlyOwner {
1632     currentStage = newStage;
1633   }
1634 
1635   /**
1636    * @dev pre-ico status (based only on time)
1637    * @return true if crowdsale event has ended
1638    */
1639   function hasEnded() public constant returns (bool) {
1640     return now > endTime && startTime != 0;
1641   }
1642 
1643   /* Price functions */
1644   /**
1645    * @dev Get current ETH/PHI rate (1 ETH = getEthPhiRate() PHI)
1646    * @notice It divides (ETH/USD rate) / (PHI/USD rate), use the
1647    * custom function `getEthPhiRate(false)` if you want a more
1648    * accurate rate
1649    * @return ETH/PHI rate
1650    */
1651   function getEthPhiRate () public constant returns (uint) {
1652     // 1/(ETH/PHI rate) * (ETH/USD rate) should return PHI rate
1653     // multiply by 1000 to keep decimals from the division
1654     return ethUsd.div(phiRate);
1655   }
1656 
1657   /**
1658    * @dev Get current kETH/PHI rate (1000 ETH = getkEthPhiRate() PHI)
1659    * used to get a more accurate rate (by not truncating decimals)
1660    * @notice It divides (ETH/USD rate) / (PHI/USD rate)
1661    * @return kETH/PHI rate
1662    */
1663   function getkEthPhiRate () public constant returns (uint) {
1664     // 1/(kETH/PHI rate) * (ETH/USD rate) should return PHI rate
1665     // multiply by 1000 to keep decimals from the division, and return kEth/PHI rate
1666     return ethUsd.mul(1000).div(phiRate);
1667   }
1668 
1669   /**
1670    * @dev Calculate amount of token based on wei amount
1671    * @param weiAmount Amount of wei
1672    * @return Amount of PHI tokens
1673    */
1674   function getTokenAmount(uint256 weiAmount) public constant returns(uint256) {
1675     // get kEth rate to keep decimals
1676     uint currentKethRate = getkEthPhiRate();
1677     // divide by 1000 to revert back the multiply
1678     return currentKethRate.mul(weiAmount).div(1000);
1679   }
1680 
1681   /* Helper functions for token balance */
1682   /**
1683    * @dev Returns how many tokens an investor has
1684    * @param investor Investor to look for
1685    * @return Balance of the investor
1686    */
1687   function getInvestorBalance(address investor) external constant returns (uint) {
1688     return balancesToken[investor];
1689   }
1690 
1691   /**
1692    * @dev Returns how many wei an investor has invested
1693    * @param investor Investor to look for
1694    * @return Balance of the investor
1695    */
1696   function getInvestorWeiBalance(address investor) external constant returns (uint) {
1697     return balancesWei[investor];
1698   }
1699 
1700   /**
1701    * @dev Check if an address is a contract
1702    * @param addr Address to check
1703    * @return True if is a contract
1704    */
1705   function isContract(address addr) public constant returns (bool) {
1706     uint size;
1707     assembly { size := extcodesize(addr) }
1708     return size > 0;
1709   }
1710 
1711   /* Ico engine compatible functions */
1712   /**
1713    * @dev Return `started` state
1714    * false if the crowdsale is not started,
1715    * true if the crowdsale is started and running,
1716    * true if the crowdsale is completed
1717    * @return crowdsale state
1718    */
1719   function started() public view returns(bool) {
1720     if ((uint8(currentStage) >= 2 || now >= startTime && now <= endTime) && uint8(currentStage) != 3) return true;
1721     return false;
1722   }
1723 
1724   /**
1725    * @dev Return if crowdsale ended
1726    * false if the crowdsale is not started,
1727    * false if the crowdsale is started and running,
1728    * true if the crowdsale is completed
1729    * @return ended state
1730    */
1731   function ended() public view returns(bool) {
1732     if (tokensSold == MAX_TOKENS) return true;
1733     if (uint8(currentStage) >= 4) return true;
1734     return hasEnded();
1735   }
1736 
1737   /**
1738    * @dev returns the total number of the tokens available for the sale,
1739    * must not change when the crowdsale is started
1740    * @return total tokens in sphi
1741    */
1742   function totalTokens() public view returns(uint) {
1743     return MAX_TOKENS;
1744   }
1745   
1746   /**
1747    * @dev returns the number of the tokens available for the crowdsale.
1748    * At the moment that the crowdsale starts it must be equal to totalTokens(),
1749    * then it will decrease. It is used to calculate the
1750    * percentage of sold tokens as remainingTokens() / totalTokens()
1751    * @return Remaining tokens in sphi
1752    */
1753   function remainingTokens() public view returns(uint) {
1754     return MAX_TOKENS.sub(tokensSold);
1755   }
1756 
1757   /**
1758    * @dev return the price as number of tokens released for each ether
1759    * @return amount in sphi for 1 ether
1760    */
1761   function price() public view returns(uint) {
1762     return getTokenAmount(1 ether);
1763   }
1764 }