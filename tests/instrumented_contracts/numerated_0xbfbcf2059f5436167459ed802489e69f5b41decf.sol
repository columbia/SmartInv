1 pragma solidity ^0.4.19;
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
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 // <ORACLIZE_API>
90 /*
91 Copyright (c) 2015-2016 Oraclize SRL
92 Copyright (c) 2016 Oraclize LTD
93 
94 
95 
96 Permission is hereby granted, free of charge, to any person obtaining a copy
97 of this software and associated documentation files (the "Software"), to deal
98 in the Software without restriction, including without limitation the rights
99 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
100 copies of the Software, and to permit persons to whom the Software is
101 furnished to do so, subject to the following conditions:
102 
103 
104 
105 The above copyright notice and this permission notice shall be included in
106 all copies or substantial portions of the Software.
107 
108 
109 
110 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
111 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
112 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
113 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
114 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
115 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
116 THE SOFTWARE.
117 */
118 
119 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
120 pragma solidity ^0.4.18;
121 
122 contract OraclizeI {
123     address public cbAddress;
124     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
125     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
126     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
127     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
128     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
129     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
130     function getPrice(string _datasource) public returns (uint _dsprice);
131     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
132     function setProofType(byte _proofType) external;
133     function setCustomGasPrice(uint _gasPrice) external;
134     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
135 }
136 contract OraclizeAddrResolverI {
137     function getAddress() public returns (address _addr);
138 }
139 contract usingOraclize {
140     uint constant day = 60*60*24;
141     uint constant week = 60*60*24*7;
142     uint constant month = 60*60*24*30;
143     byte constant proofType_NONE = 0x00;
144     byte constant proofType_TLSNotary = 0x10;
145     byte constant proofType_Android = 0x20;
146     byte constant proofType_Ledger = 0x30;
147     byte constant proofType_Native = 0xF0;
148     byte constant proofStorage_IPFS = 0x01;
149     uint8 constant networkID_auto = 0;
150     uint8 constant networkID_mainnet = 1;
151     uint8 constant networkID_testnet = 2;
152     uint8 constant networkID_morden = 2;
153     uint8 constant networkID_consensys = 161;
154 
155     OraclizeAddrResolverI OAR;
156 
157     OraclizeI oraclize;
158     modifier oraclizeAPI {
159         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
160             oraclize_setNetwork(networkID_auto);
161 
162         if(address(oraclize) != OAR.getAddress())
163             oraclize = OraclizeI(OAR.getAddress());
164 
165         _;
166     }
167     modifier coupon(string code){
168         oraclize = OraclizeI(OAR.getAddress());
169         _;
170     }
171 
172     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
173       return oraclize_setNetwork();
174       networkID; // silence the warning and remain backwards compatible
175     }
176     function oraclize_setNetwork() internal returns(bool){
177         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
178             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
179             oraclize_setNetworkName("eth_mainnet");
180             return true;
181         }
182         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
183             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
184             oraclize_setNetworkName("eth_ropsten3");
185             return true;
186         }
187         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
188             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
189             oraclize_setNetworkName("eth_kovan");
190             return true;
191         }
192         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
193             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
194             oraclize_setNetworkName("eth_rinkeby");
195             return true;
196         }
197         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
198             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
199             return true;
200         }
201         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
202             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
203             return true;
204         }
205         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
206             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
207             return true;
208         }
209         return false;
210     }
211 
212     function __callback(bytes32 myid, string result) public {
213         __callback(myid, result, new bytes(0));
214     }
215     function __callback(bytes32 myid, string result, bytes proof) public {
216       return;
217       myid; result; proof; // Silence compiler warnings
218     }
219 
220     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
221         return oraclize.getPrice(datasource);
222     }
223 
224     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
225         return oraclize.getPrice(datasource, gaslimit);
226     }
227 
228     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
229         uint price = oraclize.getPrice(datasource);
230         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
231         return oraclize.query.value(price)(0, datasource, arg);
232     }
233     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
234         uint price = oraclize.getPrice(datasource);
235         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
236         return oraclize.query.value(price)(timestamp, datasource, arg);
237     }
238     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
239         uint price = oraclize.getPrice(datasource, gaslimit);
240         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
241         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
242     }
243     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
244         uint price = oraclize.getPrice(datasource, gaslimit);
245         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
246         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
247     }
248     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
249         uint price = oraclize.getPrice(datasource);
250         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
251         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
252     }
253     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
254         uint price = oraclize.getPrice(datasource);
255         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
256         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
257     }
258     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
259         uint price = oraclize.getPrice(datasource, gaslimit);
260         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
261         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
262     }
263     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
264         uint price = oraclize.getPrice(datasource, gaslimit);
265         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
266         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
267     }
268     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
269         uint price = oraclize.getPrice(datasource);
270         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
271         bytes memory args = stra2cbor(argN);
272         return oraclize.queryN.value(price)(0, datasource, args);
273     }
274     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
275         uint price = oraclize.getPrice(datasource);
276         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
277         bytes memory args = stra2cbor(argN);
278         return oraclize.queryN.value(price)(timestamp, datasource, args);
279     }
280     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
281         uint price = oraclize.getPrice(datasource, gaslimit);
282         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
283         bytes memory args = stra2cbor(argN);
284         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
285     }
286     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
287         uint price = oraclize.getPrice(datasource, gaslimit);
288         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
289         bytes memory args = stra2cbor(argN);
290         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
291     }
292     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
293         string[] memory dynargs = new string[](1);
294         dynargs[0] = args[0];
295         return oraclize_query(datasource, dynargs);
296     }
297     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
298         string[] memory dynargs = new string[](1);
299         dynargs[0] = args[0];
300         return oraclize_query(timestamp, datasource, dynargs);
301     }
302     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
303         string[] memory dynargs = new string[](1);
304         dynargs[0] = args[0];
305         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
306     }
307     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
308         string[] memory dynargs = new string[](1);
309         dynargs[0] = args[0];
310         return oraclize_query(datasource, dynargs, gaslimit);
311     }
312 
313     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
314         string[] memory dynargs = new string[](2);
315         dynargs[0] = args[0];
316         dynargs[1] = args[1];
317         return oraclize_query(datasource, dynargs);
318     }
319     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
320         string[] memory dynargs = new string[](2);
321         dynargs[0] = args[0];
322         dynargs[1] = args[1];
323         return oraclize_query(timestamp, datasource, dynargs);
324     }
325     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
326         string[] memory dynargs = new string[](2);
327         dynargs[0] = args[0];
328         dynargs[1] = args[1];
329         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
330     }
331     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
332         string[] memory dynargs = new string[](2);
333         dynargs[0] = args[0];
334         dynargs[1] = args[1];
335         return oraclize_query(datasource, dynargs, gaslimit);
336     }
337     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
338         string[] memory dynargs = new string[](3);
339         dynargs[0] = args[0];
340         dynargs[1] = args[1];
341         dynargs[2] = args[2];
342         return oraclize_query(datasource, dynargs);
343     }
344     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
345         string[] memory dynargs = new string[](3);
346         dynargs[0] = args[0];
347         dynargs[1] = args[1];
348         dynargs[2] = args[2];
349         return oraclize_query(timestamp, datasource, dynargs);
350     }
351     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
352         string[] memory dynargs = new string[](3);
353         dynargs[0] = args[0];
354         dynargs[1] = args[1];
355         dynargs[2] = args[2];
356         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
357     }
358     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
359         string[] memory dynargs = new string[](3);
360         dynargs[0] = args[0];
361         dynargs[1] = args[1];
362         dynargs[2] = args[2];
363         return oraclize_query(datasource, dynargs, gaslimit);
364     }
365 
366     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
367         string[] memory dynargs = new string[](4);
368         dynargs[0] = args[0];
369         dynargs[1] = args[1];
370         dynargs[2] = args[2];
371         dynargs[3] = args[3];
372         return oraclize_query(datasource, dynargs);
373     }
374     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
375         string[] memory dynargs = new string[](4);
376         dynargs[0] = args[0];
377         dynargs[1] = args[1];
378         dynargs[2] = args[2];
379         dynargs[3] = args[3];
380         return oraclize_query(timestamp, datasource, dynargs);
381     }
382     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
383         string[] memory dynargs = new string[](4);
384         dynargs[0] = args[0];
385         dynargs[1] = args[1];
386         dynargs[2] = args[2];
387         dynargs[3] = args[3];
388         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
389     }
390     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
391         string[] memory dynargs = new string[](4);
392         dynargs[0] = args[0];
393         dynargs[1] = args[1];
394         dynargs[2] = args[2];
395         dynargs[3] = args[3];
396         return oraclize_query(datasource, dynargs, gaslimit);
397     }
398     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
399         string[] memory dynargs = new string[](5);
400         dynargs[0] = args[0];
401         dynargs[1] = args[1];
402         dynargs[2] = args[2];
403         dynargs[3] = args[3];
404         dynargs[4] = args[4];
405         return oraclize_query(datasource, dynargs);
406     }
407     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
408         string[] memory dynargs = new string[](5);
409         dynargs[0] = args[0];
410         dynargs[1] = args[1];
411         dynargs[2] = args[2];
412         dynargs[3] = args[3];
413         dynargs[4] = args[4];
414         return oraclize_query(timestamp, datasource, dynargs);
415     }
416     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
417         string[] memory dynargs = new string[](5);
418         dynargs[0] = args[0];
419         dynargs[1] = args[1];
420         dynargs[2] = args[2];
421         dynargs[3] = args[3];
422         dynargs[4] = args[4];
423         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
424     }
425     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
426         string[] memory dynargs = new string[](5);
427         dynargs[0] = args[0];
428         dynargs[1] = args[1];
429         dynargs[2] = args[2];
430         dynargs[3] = args[3];
431         dynargs[4] = args[4];
432         return oraclize_query(datasource, dynargs, gaslimit);
433     }
434     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
435         uint price = oraclize.getPrice(datasource);
436         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
437         bytes memory args = ba2cbor(argN);
438         return oraclize.queryN.value(price)(0, datasource, args);
439     }
440     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
441         uint price = oraclize.getPrice(datasource);
442         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
443         bytes memory args = ba2cbor(argN);
444         return oraclize.queryN.value(price)(timestamp, datasource, args);
445     }
446     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
447         uint price = oraclize.getPrice(datasource, gaslimit);
448         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
449         bytes memory args = ba2cbor(argN);
450         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
451     }
452     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
453         uint price = oraclize.getPrice(datasource, gaslimit);
454         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
455         bytes memory args = ba2cbor(argN);
456         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
457     }
458     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
459         bytes[] memory dynargs = new bytes[](1);
460         dynargs[0] = args[0];
461         return oraclize_query(datasource, dynargs);
462     }
463     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
464         bytes[] memory dynargs = new bytes[](1);
465         dynargs[0] = args[0];
466         return oraclize_query(timestamp, datasource, dynargs);
467     }
468     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
469         bytes[] memory dynargs = new bytes[](1);
470         dynargs[0] = args[0];
471         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
472     }
473     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         bytes[] memory dynargs = new bytes[](1);
475         dynargs[0] = args[0];
476         return oraclize_query(datasource, dynargs, gaslimit);
477     }
478 
479     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
480         bytes[] memory dynargs = new bytes[](2);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         return oraclize_query(datasource, dynargs);
484     }
485     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
486         bytes[] memory dynargs = new bytes[](2);
487         dynargs[0] = args[0];
488         dynargs[1] = args[1];
489         return oraclize_query(timestamp, datasource, dynargs);
490     }
491     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
492         bytes[] memory dynargs = new bytes[](2);
493         dynargs[0] = args[0];
494         dynargs[1] = args[1];
495         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
496     }
497     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         bytes[] memory dynargs = new bytes[](2);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         return oraclize_query(datasource, dynargs, gaslimit);
502     }
503     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
504         bytes[] memory dynargs = new bytes[](3);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         return oraclize_query(datasource, dynargs);
509     }
510     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
511         bytes[] memory dynargs = new bytes[](3);
512         dynargs[0] = args[0];
513         dynargs[1] = args[1];
514         dynargs[2] = args[2];
515         return oraclize_query(timestamp, datasource, dynargs);
516     }
517     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
518         bytes[] memory dynargs = new bytes[](3);
519         dynargs[0] = args[0];
520         dynargs[1] = args[1];
521         dynargs[2] = args[2];
522         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
523     }
524     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
525         bytes[] memory dynargs = new bytes[](3);
526         dynargs[0] = args[0];
527         dynargs[1] = args[1];
528         dynargs[2] = args[2];
529         return oraclize_query(datasource, dynargs, gaslimit);
530     }
531 
532     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
533         bytes[] memory dynargs = new bytes[](4);
534         dynargs[0] = args[0];
535         dynargs[1] = args[1];
536         dynargs[2] = args[2];
537         dynargs[3] = args[3];
538         return oraclize_query(datasource, dynargs);
539     }
540     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
541         bytes[] memory dynargs = new bytes[](4);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         return oraclize_query(timestamp, datasource, dynargs);
547     }
548     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
549         bytes[] memory dynargs = new bytes[](4);
550         dynargs[0] = args[0];
551         dynargs[1] = args[1];
552         dynargs[2] = args[2];
553         dynargs[3] = args[3];
554         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
555     }
556     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
557         bytes[] memory dynargs = new bytes[](4);
558         dynargs[0] = args[0];
559         dynargs[1] = args[1];
560         dynargs[2] = args[2];
561         dynargs[3] = args[3];
562         return oraclize_query(datasource, dynargs, gaslimit);
563     }
564     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
565         bytes[] memory dynargs = new bytes[](5);
566         dynargs[0] = args[0];
567         dynargs[1] = args[1];
568         dynargs[2] = args[2];
569         dynargs[3] = args[3];
570         dynargs[4] = args[4];
571         return oraclize_query(datasource, dynargs);
572     }
573     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
574         bytes[] memory dynargs = new bytes[](5);
575         dynargs[0] = args[0];
576         dynargs[1] = args[1];
577         dynargs[2] = args[2];
578         dynargs[3] = args[3];
579         dynargs[4] = args[4];
580         return oraclize_query(timestamp, datasource, dynargs);
581     }
582     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
583         bytes[] memory dynargs = new bytes[](5);
584         dynargs[0] = args[0];
585         dynargs[1] = args[1];
586         dynargs[2] = args[2];
587         dynargs[3] = args[3];
588         dynargs[4] = args[4];
589         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
590     }
591     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
592         bytes[] memory dynargs = new bytes[](5);
593         dynargs[0] = args[0];
594         dynargs[1] = args[1];
595         dynargs[2] = args[2];
596         dynargs[3] = args[3];
597         dynargs[4] = args[4];
598         return oraclize_query(datasource, dynargs, gaslimit);
599     }
600 
601     function oraclize_cbAddress() oraclizeAPI internal returns (address){
602         return oraclize.cbAddress();
603     }
604     function oraclize_setProof(byte proofP) oraclizeAPI internal {
605         return oraclize.setProofType(proofP);
606     }
607     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
608         return oraclize.setCustomGasPrice(gasPrice);
609     }
610 
611     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
612         return oraclize.randomDS_getSessionPubKeyHash();
613     }
614 
615     function getCodeSize(address _addr) constant internal returns(uint _size) {
616         assembly {
617             _size := extcodesize(_addr)
618         }
619     }
620 
621     function parseAddr(string _a) internal pure returns (address){
622         bytes memory tmp = bytes(_a);
623         uint160 iaddr = 0;
624         uint160 b1;
625         uint160 b2;
626         for (uint i=2; i<2+2*20; i+=2){
627             iaddr *= 256;
628             b1 = uint160(tmp[i]);
629             b2 = uint160(tmp[i+1]);
630             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
631             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
632             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
633             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
634             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
635             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
636             iaddr += (b1*16+b2);
637         }
638         return address(iaddr);
639     }
640 
641     function strCompare(string _a, string _b) internal pure returns (int) {
642         bytes memory a = bytes(_a);
643         bytes memory b = bytes(_b);
644         uint minLength = a.length;
645         if (b.length < minLength) minLength = b.length;
646         for (uint i = 0; i < minLength; i ++)
647             if (a[i] < b[i])
648                 return -1;
649             else if (a[i] > b[i])
650                 return 1;
651         if (a.length < b.length)
652             return -1;
653         else if (a.length > b.length)
654             return 1;
655         else
656             return 0;
657     }
658 
659     function indexOf(string _haystack, string _needle) internal pure returns (int) {
660         bytes memory h = bytes(_haystack);
661         bytes memory n = bytes(_needle);
662         if(h.length < 1 || n.length < 1 || (n.length > h.length))
663             return -1;
664         else if(h.length > (2**128 -1))
665             return -1;
666         else
667         {
668             uint subindex = 0;
669             for (uint i = 0; i < h.length; i ++)
670             {
671                 if (h[i] == n[0])
672                 {
673                     subindex = 1;
674                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
675                     {
676                         subindex++;
677                     }
678                     if(subindex == n.length)
679                         return int(i);
680                 }
681             }
682             return -1;
683         }
684     }
685 
686     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
687         bytes memory _ba = bytes(_a);
688         bytes memory _bb = bytes(_b);
689         bytes memory _bc = bytes(_c);
690         bytes memory _bd = bytes(_d);
691         bytes memory _be = bytes(_e);
692         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
693         bytes memory babcde = bytes(abcde);
694         uint k = 0;
695         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
696         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
697         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
698         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
699         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
700         return string(babcde);
701     }
702 
703     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
704         return strConcat(_a, _b, _c, _d, "");
705     }
706 
707     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
708         return strConcat(_a, _b, _c, "", "");
709     }
710 
711     function strConcat(string _a, string _b) internal pure returns (string) {
712         return strConcat(_a, _b, "", "", "");
713     }
714 
715     // parseInt
716     function parseInt(string _a) internal pure returns (uint) {
717         return parseInt(_a, 0);
718     }
719 
720     // parseInt(parseFloat*10^_b)
721     function parseInt(string _a, uint _b) internal pure returns (uint) {
722         bytes memory bresult = bytes(_a);
723         uint mint = 0;
724         bool decimals = false;
725         for (uint i=0; i<bresult.length; i++){
726             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
727                 if (decimals){
728                    if (_b == 0) break;
729                     else _b--;
730                 }
731                 mint *= 10;
732                 mint += uint(bresult[i]) - 48;
733             } else if (bresult[i] == 46) decimals = true;
734         }
735         if (_b > 0) mint *= 10**_b;
736         return mint;
737     }
738 
739     function uint2str(uint i) internal pure returns (string){
740         if (i == 0) return "0";
741         uint j = i;
742         uint len;
743         while (j != 0){
744             len++;
745             j /= 10;
746         }
747         bytes memory bstr = new bytes(len);
748         uint k = len - 1;
749         while (i != 0){
750             bstr[k--] = byte(48 + i % 10);
751             i /= 10;
752         }
753         return string(bstr);
754     }
755 
756     function stra2cbor(string[] arr) internal pure returns (bytes) {
757             uint arrlen = arr.length;
758 
759             // get correct cbor output length
760             uint outputlen = 0;
761             bytes[] memory elemArray = new bytes[](arrlen);
762             for (uint i = 0; i < arrlen; i++) {
763                 elemArray[i] = (bytes(arr[i]));
764                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
765             }
766             uint ctr = 0;
767             uint cborlen = arrlen + 0x80;
768             outputlen += byte(cborlen).length;
769             bytes memory res = new bytes(outputlen);
770 
771             while (byte(cborlen).length > ctr) {
772                 res[ctr] = byte(cborlen)[ctr];
773                 ctr++;
774             }
775             for (i = 0; i < arrlen; i++) {
776                 res[ctr] = 0x5F;
777                 ctr++;
778                 for (uint x = 0; x < elemArray[i].length; x++) {
779                     // if there's a bug with larger strings, this may be the culprit
780                     if (x % 23 == 0) {
781                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
782                         elemcborlen += 0x40;
783                         uint lctr = ctr;
784                         while (byte(elemcborlen).length > ctr - lctr) {
785                             res[ctr] = byte(elemcborlen)[ctr - lctr];
786                             ctr++;
787                         }
788                     }
789                     res[ctr] = elemArray[i][x];
790                     ctr++;
791                 }
792                 res[ctr] = 0xFF;
793                 ctr++;
794             }
795             return res;
796         }
797 
798     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
799             uint arrlen = arr.length;
800 
801             // get correct cbor output length
802             uint outputlen = 0;
803             bytes[] memory elemArray = new bytes[](arrlen);
804             for (uint i = 0; i < arrlen; i++) {
805                 elemArray[i] = (bytes(arr[i]));
806                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
807             }
808             uint ctr = 0;
809             uint cborlen = arrlen + 0x80;
810             outputlen += byte(cborlen).length;
811             bytes memory res = new bytes(outputlen);
812 
813             while (byte(cborlen).length > ctr) {
814                 res[ctr] = byte(cborlen)[ctr];
815                 ctr++;
816             }
817             for (i = 0; i < arrlen; i++) {
818                 res[ctr] = 0x5F;
819                 ctr++;
820                 for (uint x = 0; x < elemArray[i].length; x++) {
821                     // if there's a bug with larger strings, this may be the culprit
822                     if (x % 23 == 0) {
823                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
824                         elemcborlen += 0x40;
825                         uint lctr = ctr;
826                         while (byte(elemcborlen).length > ctr - lctr) {
827                             res[ctr] = byte(elemcborlen)[ctr - lctr];
828                             ctr++;
829                         }
830                     }
831                     res[ctr] = elemArray[i][x];
832                     ctr++;
833                 }
834                 res[ctr] = 0xFF;
835                 ctr++;
836             }
837             return res;
838         }
839 
840 
841     string oraclize_network_name;
842     function oraclize_setNetworkName(string _network_name) internal {
843         oraclize_network_name = _network_name;
844     }
845 
846     function oraclize_getNetworkName() internal view returns (string) {
847         return oraclize_network_name;
848     }
849 
850     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
851         require((_nbytes > 0) && (_nbytes <= 32));
852         bytes memory nbytes = new bytes(1);
853         nbytes[0] = byte(_nbytes);
854         bytes memory unonce = new bytes(32);
855         bytes memory sessionKeyHash = new bytes(32);
856         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
857         assembly {
858             mstore(unonce, 0x20)
859             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
860             mstore(sessionKeyHash, 0x20)
861             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
862         }
863         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
864         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
865         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
866         return queryId;
867     }
868 
869     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
870         oraclize_randomDS_args[queryId] = commitment;
871     }
872 
873     mapping(bytes32=>bytes32) oraclize_randomDS_args;
874     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
875 
876     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
877         bool sigok;
878         address signer;
879 
880         bytes32 sigr;
881         bytes32 sigs;
882 
883         bytes memory sigr_ = new bytes(32);
884         uint offset = 4+(uint(dersig[3]) - 0x20);
885         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
886         bytes memory sigs_ = new bytes(32);
887         offset += 32 + 2;
888         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
889 
890         assembly {
891             sigr := mload(add(sigr_, 32))
892             sigs := mload(add(sigs_, 32))
893         }
894 
895 
896         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
897         if (address(keccak256(pubkey)) == signer) return true;
898         else {
899             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
900             return (address(keccak256(pubkey)) == signer);
901         }
902     }
903 
904     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
905         bool sigok;
906 
907         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
908         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
909         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
910 
911         bytes memory appkey1_pubkey = new bytes(64);
912         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
913 
914         bytes memory tosign2 = new bytes(1+65+32);
915         tosign2[0] = byte(1); //role
916         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
917         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
918         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
919         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
920 
921         if (sigok == false) return false;
922 
923 
924         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
925         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
926 
927         bytes memory tosign3 = new bytes(1+65);
928         tosign3[0] = 0xFE;
929         copyBytes(proof, 3, 65, tosign3, 1);
930 
931         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
932         copyBytes(proof, 3+65, sig3.length, sig3, 0);
933 
934         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
935 
936         return sigok;
937     }
938 
939     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
940         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
941         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
942 
943         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
944         require(proofVerified);
945 
946         _;
947     }
948 
949     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
950         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
951         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
952 
953         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
954         if (proofVerified == false) return 2;
955 
956         return 0;
957     }
958 
959     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
960         bool match_ = true;
961 
962 
963         for (uint256 i=0; i< n_random_bytes; i++) {
964             if (content[i] != prefix[i]) match_ = false;
965         }
966 
967         return match_;
968     }
969 
970     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
971 
972         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
973         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
974         bytes memory keyhash = new bytes(32);
975         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
976         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
977 
978         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
979         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
980 
981         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
982         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
983 
984         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
985         // This is to verify that the computed args match with the ones specified in the query.
986         bytes memory commitmentSlice1 = new bytes(8+1+32);
987         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
988 
989         bytes memory sessionPubkey = new bytes(64);
990         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
991         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
992 
993         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
994         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
995             delete oraclize_randomDS_args[queryId];
996         } else return false;
997 
998 
999         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1000         bytes memory tosign1 = new bytes(32+8+1+32);
1001         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1002         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1003 
1004         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1005         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1006             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1007         }
1008 
1009         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1010     }
1011 
1012     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1013     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1014         uint minLength = length + toOffset;
1015 
1016         // Buffer too small
1017         require(to.length >= minLength); // Should be a better way?
1018 
1019         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1020         uint i = 32 + fromOffset;
1021         uint j = 32 + toOffset;
1022 
1023         while (i < (32 + fromOffset + length)) {
1024             assembly {
1025                 let tmp := mload(add(from, i))
1026                 mstore(add(to, j), tmp)
1027             }
1028             i += 32;
1029             j += 32;
1030         }
1031 
1032         return to;
1033     }
1034 
1035     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1036     // Duplicate Solidity's ecrecover, but catching the CALL return value
1037     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1038         // We do our own memory management here. Solidity uses memory offset
1039         // 0x40 to store the current end of memory. We write past it (as
1040         // writes are memory extensions), but don't update the offset so
1041         // Solidity will reuse it. The memory used here is only needed for
1042         // this context.
1043 
1044         // FIXME: inline assembly can't access return values
1045         bool ret;
1046         address addr;
1047 
1048         assembly {
1049             let size := mload(0x40)
1050             mstore(size, hash)
1051             mstore(add(size, 32), v)
1052             mstore(add(size, 64), r)
1053             mstore(add(size, 96), s)
1054 
1055             // NOTE: we can reuse the request memory because we deal with
1056             //       the return code
1057             ret := call(3000, 1, 0, size, 128, size, 32)
1058             addr := mload(size)
1059         }
1060 
1061         return (ret, addr);
1062     }
1063 
1064     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1065     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1066         bytes32 r;
1067         bytes32 s;
1068         uint8 v;
1069 
1070         if (sig.length != 65)
1071           return (false, 0);
1072 
1073         // The signature format is a compact form of:
1074         //   {bytes32 r}{bytes32 s}{uint8 v}
1075         // Compact means, uint8 is not padded to 32 bytes.
1076         assembly {
1077             r := mload(add(sig, 32))
1078             s := mload(add(sig, 64))
1079 
1080             // Here we are loading the last 32 bytes. We exploit the fact that
1081             // 'mload' will pad with zeroes if we overread.
1082             // There is no 'mload8' to do this, but that would be nicer.
1083             v := byte(0, mload(add(sig, 96)))
1084 
1085             // Alternative solution:
1086             // 'byte' is not working due to the Solidity parser, so lets
1087             // use the second best option, 'and'
1088             // v := and(mload(add(sig, 65)), 255)
1089         }
1090 
1091         // albeit non-transactional signatures are not specified by the YP, one would expect it
1092         // to match the YP range of [27, 28]
1093         //
1094         // geth uses [0, 1] and some clients have followed. This might change, see:
1095         //  https://github.com/ethereum/go-ethereum/issues/2053
1096         if (v < 27)
1097           v += 27;
1098 
1099         if (v != 27 && v != 28)
1100             return (false, 0);
1101 
1102         return safer_ecrecover(hash, v, r, s);
1103     }
1104 
1105 }
1106 // </ORACLIZE_API>
1107 
1108 /**
1109  * @title Pausable
1110  * @dev Base contract which allows children to implement an emergency stop mechanism.
1111  */
1112 contract Pausable is Ownable {
1113   event Pause();
1114   event Unpause();
1115 
1116   bool public paused = false;
1117 
1118 
1119   /**
1120    * @dev Modifier to make a function callable only when the contract is not paused.
1121    */
1122   modifier whenNotPaused() {
1123     require(!paused);
1124     _;
1125   }
1126 
1127   /**
1128    * @dev Modifier to make a function callable only when the contract is paused.
1129    */
1130   modifier whenPaused() {
1131     require(paused);
1132     _;
1133   }
1134 
1135   /**
1136    * @dev called by the owner to pause, triggers stopped state
1137    */
1138   function pause() onlyOwner whenNotPaused public {
1139     paused = true;
1140     Pause();
1141   }
1142 
1143   /**
1144    * @dev called by the owner to unpause, returns to normal state
1145    */
1146   function unpause() onlyOwner whenPaused public {
1147     paused = false;
1148     Unpause();
1149   }
1150 }
1151 
1152 /**
1153  * @title Finalizable
1154  * @dev Base contract which allows children to implement a finalization mechanism.
1155  * inspired by FinalizableCrowdsale from zeppelin
1156  */
1157 contract Finalizable is Ownable {
1158   event Finalized();
1159 
1160   bool public isFinalized = false;
1161 
1162   /**
1163    * @dev Modifier to make a function callable only when the contract is not finalized.
1164    */
1165   modifier whenNotFinalized() {
1166     require(!isFinalized);
1167     _;
1168   }
1169 
1170   /**
1171    * @dev called by the owner to finalize
1172    */
1173   function finalize() onlyOwner whenNotFinalized public {
1174     finalization();
1175     Finalized();
1176 
1177     isFinalized = true;
1178   }
1179 
1180   /**
1181    * @dev Can be overridden to add finalization logic. The overriding function
1182    * should call super.finalization() to ensure the chain of finalization is
1183    * executed entirely.
1184    */
1185   function finalization() internal {
1186   }
1187 }
1188 
1189 /**
1190  * @title Destructible
1191  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
1192  */
1193 contract Destructible is Ownable {
1194 
1195   function Destructible() public payable { }
1196 
1197   /**
1198    * @dev Transfers the current balance to the owner and terminates the contract.
1199    */
1200   function destroy() onlyOwner public {
1201     selfdestruct(owner);
1202   }
1203 
1204   function destroyAndSend(address _recipient) onlyOwner public {
1205     selfdestruct(_recipient);
1206   }
1207 }
1208 
1209 /**
1210  * @title ERC20Basic
1211  * @dev Simpler version of ERC20 interface
1212  * @dev see https://github.com/ethereum/EIPs/issues/179
1213  */
1214 contract ERC20Basic {
1215   function totalSupply() public view returns (uint256);
1216   function balanceOf(address who) public view returns (uint256);
1217   function transfer(address to, uint256 value) public returns (bool);
1218   event Transfer(address indexed from, address indexed to, uint256 value);
1219 }
1220 
1221 /**
1222  * @title ERC20 interface
1223  * @dev see https://github.com/ethereum/EIPs/issues/20
1224  */
1225 contract ERC20 is ERC20Basic {
1226   function allowance(address owner, address spender) public view returns (uint256);
1227   function transferFrom(address from, address to, uint256 value) public returns (bool);
1228   function approve(address spender, uint256 value) public returns (bool);
1229   event Approval(address indexed owner, address indexed spender, uint256 value);
1230 }
1231 
1232 /**
1233  * @title SafeERC20
1234  * @dev Wrappers around ERC20 operations that throw on failure.
1235  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1236  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1237  */
1238 library SafeERC20 {
1239   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
1240     assert(token.transfer(to, value));
1241   }
1242 
1243   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
1244     assert(token.transferFrom(from, to, value));
1245   }
1246 
1247   function safeApprove(ERC20 token, address spender, uint256 value) internal {
1248     assert(token.approve(spender, value));
1249   }
1250 }
1251 
1252 /**
1253  * @title Contracts that should be able to recover tokens
1254  * @author SylTi
1255  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
1256  * This will prevent any accidental loss of tokens.
1257  */
1258 contract CanReclaimToken is Ownable {
1259   using SafeERC20 for ERC20Basic;
1260 
1261   /**
1262    * @dev Reclaim all ERC20Basic compatible tokens
1263    * @param token ERC20Basic The address of the token contract
1264    */
1265   function reclaimToken(ERC20Basic token) external onlyOwner {
1266     uint256 balance = token.balanceOf(this);
1267     token.safeTransfer(owner, balance);
1268   }
1269 
1270 }
1271 
1272 /**
1273  * @title Contracts that should not own Tokens
1274  * @author Remco Bloemen <remco@2π.com>
1275  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
1276  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
1277  * owner to reclaim the tokens.
1278  */
1279 contract HasNoTokens is CanReclaimToken {
1280 
1281  /**
1282   * @dev Reject all ERC223 compatible tokens
1283   * @param from_ address The address that is transferring the tokens
1284   * @param value_ uint256 the amount of the specified token
1285   * @param data_ Bytes The data passed from the caller.
1286   */
1287   function tokenFallback(address from_, uint256 value_, bytes data_) external {
1288     from_;
1289     value_;
1290     data_;
1291     revert();
1292   }
1293 
1294 }
1295 
1296 /**
1297  * @title Contracts that should not own Contracts
1298  * @author Remco Bloemen <remco@2π.com>
1299  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
1300  * of this contract to reclaim ownership of the contracts.
1301  */
1302 contract HasNoContracts is Ownable {
1303 
1304   /**
1305    * @dev Reclaim ownership of Ownable contracts
1306    * @param contractAddr The address of the Ownable to be reclaimed.
1307    */
1308   function reclaimContract(address contractAddr) external onlyOwner {
1309     Ownable contractInst = Ownable(contractAddr);
1310     contractInst.transferOwnership(owner);
1311   }
1312 }
1313 
1314 /**
1315  * @title EtherSportCrowdsale
1316  */
1317 contract EtherSportCrowdsale is usingOraclize, Pausable, Finalizable, Destructible, HasNoTokens, HasNoContracts {    
1318     using SafeMath for uint256;
1319     using SafeERC20 for ERC20;
1320     
1321     // EtherSport token
1322     ERC20 public token;
1323 
1324     // wallet with token allowance
1325     address public tokenFrom;
1326 
1327     // start timestamp
1328     uint256 public startTime;
1329 
1330     // end timestamp
1331     uint256 public endTime;
1332 
1333     // tokens sold
1334     uint256 public sold;
1335 
1336     // wei raised
1337     uint256 public raised;
1338 
1339     // address where funds are collected
1340     address public wallet;
1341 
1342     // funders
1343     mapping (address => bool) public funders;
1344 
1345     // oraclize funding order
1346     struct Order {
1347         address beneficiary;
1348         uint256 funds;
1349         uint256 bonus;
1350         uint256 rate;
1351         uint256 specialPrice;
1352         address referer;  
1353     }
1354 
1355     // oraclize funding orders
1356     mapping (bytes32 => Order) public orders;
1357 
1358     // offer with special price
1359     struct Offer {
1360         uint256 condition;
1361         uint256 specialPrice;
1362     }
1363 
1364     // special offers
1365     mapping (address => Offer) public offers;
1366 
1367     // oraclize gas limit
1368     uint256 public oraclizeGasLimit = 200000;
1369 
1370     // bonused purchases counter
1371     uint256 public bonusedPurchases;
1372 
1373     // minimum funding amount
1374     uint256 public constant MIN_FUNDING_AMOUNT = 0.04 ether;
1375 
1376     // oraclize commission
1377     uint256 public constant ORACLIZE_COMMISSION = 0.0025 ether;
1378 
1379     // bonused purchases limit (+ 2 for test)
1380     uint256 public constant BONUSED_PURCHASES_LIMIT = 202;
1381 
1382     // minimum funding amount for 30% volume bonus
1383     uint256 public constant VOLUME_BONUS_CONDITION = 7 ether;
1384 
1385     // 30% volume bonus
1386     uint256 public constant VOLUME_BONUS = 30;
1387 
1388     // 15% first purchases bonus
1389     uint256 public constant PURCHASES_BONUS = 15;
1390 
1391     // token price (usd), using PRICE_EXPONENT
1392     uint256 public constant TOKEN_PRICE = 100;
1393 
1394     // exponent for the token price
1395     uint256 public constant PRICE_EXPONENT = 2;
1396 
1397     // exponent for the eth/usd rate
1398     uint256 public constant RATE_EXPONENT = 4;
1399 
1400     // token decimals
1401     uint256 public constant TOKEN_DECIMALS = 18;
1402 
1403     // hard cap of tokens proposed to purchase
1404     uint256 public constant TOKENS_HARD_CAP = 55000000 * (10 ** TOKEN_DECIMALS);
1405 
1406     // eth/usd rate url
1407     string public ethRateURL = "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd";
1408     
1409     /**
1410      * event for token purchase logging
1411      * @param beneficiary Who got the tokens
1412      * @param orderId Oraclize orderId
1413      * @param value Weis paid for purchase
1414      * @param amount Amount of tokens purchased
1415      */
1416     event TokenPurchaseEvent(address indexed beneficiary, bytes32 indexed orderId, uint256 value, uint256 amount);
1417 
1418     /**
1419      * event for token accrual to referer logging
1420      * @param beneficiary Who has made the token purchase
1421      * @param referer Beneficiary's referer
1422      * @param orderId Oraclize orderId
1423      * @param bonusAmount Amount of bonus tokens transfered to referer
1424      */
1425     event RefererBonusEvent(address indexed beneficiary, address indexed referer, bytes32 indexed orderId, uint256 bonusAmount);
1426 
1427     /**
1428      * event for funding order logging
1429      * @param beneficiary Who has done the order
1430      * @param orderId Oraclize orderId
1431      */
1432     event OrderEvent(address indexed beneficiary, bytes32 indexed orderId);
1433 
1434     /**
1435      * event for funding logging
1436      * @param funder Who has done the payment
1437      * @param referer Beneficiary's referer
1438      * @param orderId Oraclize orderId
1439      * @param beneficiary Who will get the tokens
1440      * @param funds Funds sent by funder
1441      */
1442     event FundingEvent(address indexed funder, address indexed referer, bytes32 indexed orderId, address beneficiary, uint256 funds);
1443 
1444 
1445     /**
1446      * CONSTRUCTOR
1447      *
1448      * @dev Initialize the EtherSportCrowdsale
1449      * @param _startTime Start time timestamp
1450      * @param _endTime End time timestamp
1451      * @param _token EtherSport ERC20 token
1452      * @param _from Wallet address with token allowance
1453      * @param _wallet Wallet address to transfer direct funding to
1454      */ 
1455     function EtherSportCrowdsale(
1456         uint256 _startTime, 
1457         uint256 _endTime, 
1458         address _token, 
1459         address _from, 
1460         address _wallet
1461     )
1462         public 
1463     {
1464         require(_startTime < _endTime);
1465         require(_token != address(0));
1466         require(_from != address(0));
1467         require(_wallet != address(0));
1468 
1469         startTime = _startTime;
1470         endTime = _endTime;
1471         token = ERC20(_token);
1472         tokenFrom = _from;
1473         wallet = _wallet;
1474     }
1475 
1476     // fallback function can be used to buy tokens
1477     function () public payable {
1478         if (msg.sender != owner)
1479             buyTokensFor(msg.sender, address(0));
1480     }
1481 
1482     /**
1483      * @dev Makes order for tokens purchase.
1484      * @param _referer Funder's referer (optional)
1485      */
1486     function buyTokens(address _referer) public payable {
1487         buyTokensFor(msg.sender, _referer);
1488     }
1489 
1490     /**
1491      * @dev Makes order for tokens purchase.
1492      * @param _beneficiary Who will get the tokens
1493      * @param _referer Beneficiary's referer (optional)
1494      */
1495     function buyTokensFor(
1496         address _beneficiary, 
1497         address _referer
1498     ) 
1499         public 
1500         payable 
1501     {
1502         require(_beneficiary != address(0));
1503         require(_beneficiary != _referer);
1504 
1505         require(msg.value >= MIN_FUNDING_AMOUNT);
1506 
1507         require(liveEtherSportCampaign());
1508         require(oraclize_getPrice("URL") <= this.balance);
1509 
1510         uint256 _funds = msg.value;
1511         address _funder = msg.sender;
1512         bytes32 _orderId = oraclize_query("URL", ethRateURL, oraclizeGasLimit);
1513 
1514         OrderEvent(_beneficiary, _orderId);
1515 
1516         orders[_orderId].beneficiary = _beneficiary;
1517         orders[_orderId].funds = _funds;
1518         orders[_orderId].referer = _referer;
1519         
1520         uint256 _offerCondition = offers[_funder].condition;
1521 
1522         uint256 _bonus;
1523 
1524         // in case of special offer
1525         if (_offerCondition > 0 && _offerCondition <= _funds) {
1526             uint256 _offerPrice = offers[_funder].specialPrice;
1527 
1528             offers[_funder].condition = 0;
1529             offers[_funder].specialPrice = 0;
1530 
1531             orders[_orderId].specialPrice = _offerPrice;
1532         } else if (_funds >= VOLUME_BONUS_CONDITION) { 
1533             _bonus = VOLUME_BONUS;
1534         } else if (bonusedPurchases < BONUSED_PURCHASES_LIMIT) {
1535             bonusedPurchases = bonusedPurchases.add(1);
1536             _bonus = PURCHASES_BONUS;
1537         }
1538         orders[_orderId].bonus = _bonus;
1539 
1540         uint256 _transferFunds = _funds.sub(ORACLIZE_COMMISSION);
1541         wallet.transfer(_transferFunds);
1542 
1543         raised = raised.add(_funds);
1544         funders[_funder] = true;
1545 
1546         FundingEvent(_funder, _referer, _orderId, _beneficiary, _funds); // solium-disable-line arg-overflow
1547     }
1548 
1549     /**
1550      * @dev Get current rate from oraclize and transfer tokens.
1551      * @param _orderId Oraclize order id
1552      * @param _result Current rate
1553      */
1554     function __callback(bytes32 _orderId, string _result) public { // solium-disable-line mixedcase
1555         require(msg.sender == oraclize_cbAddress());
1556 
1557         uint256 _rate = parseInt(_result, RATE_EXPONENT);
1558 
1559         address _beneficiary = orders[_orderId].beneficiary;
1560         uint256 _funds = orders[_orderId].funds;
1561         uint256 _bonus = orders[_orderId].bonus;
1562         address _referer = orders[_orderId].referer;
1563         uint256 _specialPrice = orders[_orderId].specialPrice;
1564 
1565         orders[_orderId].rate = _rate;
1566         
1567         uint256 _tokens = _funds.mul(_rate);
1568 
1569         if (_specialPrice > 0) {
1570             _tokens = _tokens.div(_specialPrice);
1571         } else {
1572             _tokens = _tokens.div(TOKEN_PRICE);
1573         }
1574         _tokens = _tokens.mul(10 ** PRICE_EXPONENT).div(10 ** RATE_EXPONENT);
1575 
1576         uint256 _bonusTokens = _tokens.mul(_bonus).div(100);
1577         _tokens = _tokens.add(_bonusTokens);
1578         
1579         //change of funds will be returned to funder
1580         if (sold.add(_tokens) > TOKENS_HARD_CAP) {
1581             _tokens = TOKENS_HARD_CAP.sub(sold);
1582         }
1583         token.safeTransferFrom(tokenFrom, _beneficiary, _tokens);
1584         sold = sold.add(_tokens);
1585 
1586         if (funders[_referer]) {
1587             uint256 _refererBonus = _tokens.mul(5).div(100);
1588             if (sold.add(_refererBonus) > TOKENS_HARD_CAP) {
1589                 _refererBonus = TOKENS_HARD_CAP.sub(sold);
1590             }
1591             if (_refererBonus > 0) {
1592                 token.safeTransferFrom(tokenFrom, _referer, _refererBonus);
1593                 sold = sold.add(_refererBonus);
1594                 RefererBonusEvent(_beneficiary, _referer, _orderId, _refererBonus);
1595             }
1596         }
1597         TokenPurchaseEvent(_beneficiary, _orderId, _funds, _tokens);
1598     }
1599 
1600     /**
1601      * @dev Set offer with special price.
1602      * @param _beneficiary Who got the offer
1603      * @param _condition Minimum wei amount for offer purchase 
1604      * @param _specialPrice Price value for the offer (usd), using PRICE_EXPONENT
1605      */
1606     function setOffer(address _beneficiary, uint256 _condition, uint256 _specialPrice) onlyOwner public {
1607         require(_beneficiary != address(0));
1608         require(_condition >= MIN_FUNDING_AMOUNT);
1609         require(_specialPrice > 0);
1610         offers[_beneficiary].condition = _condition;
1611         offers[_beneficiary].specialPrice = _specialPrice;
1612     }
1613 
1614     /**
1615      * @dev Withdraw ether from contract
1616      * @param _amount Amount to withdraw
1617      */
1618     function withdrawEther(uint256 _amount) onlyOwner public {
1619         require(this.balance >= _amount);
1620         owner.transfer(_amount);
1621     }
1622 
1623     /**
1624      * @dev Set oraclize gas limit
1625      * @param _gasLimit New oraclize gas limit
1626      */
1627     function setOraclizeGasLimit(uint256 _gasLimit) onlyOwner public {
1628         require(_gasLimit > 0);
1629         oraclizeGasLimit = _gasLimit;
1630     }
1631 
1632     /**
1633      * @dev Set oraclize gas price
1634      * @param _gasPrice New oraclize gas price
1635      */
1636     function setOraclizeGasPrice(uint256 _gasPrice) onlyOwner public {
1637         require(_gasPrice > 0);
1638         oraclize_setCustomGasPrice(_gasPrice);
1639     }
1640 
1641     /**
1642      * @return true if the EtherSport campaign is alive
1643      */
1644     function liveEtherSportCampaign() internal view returns (bool) {
1645         return now >= startTime && now <= endTime && !paused && !isFinalized && sold < TOKENS_HARD_CAP; // solium-disable-line security/no-block-members
1646     }
1647 }