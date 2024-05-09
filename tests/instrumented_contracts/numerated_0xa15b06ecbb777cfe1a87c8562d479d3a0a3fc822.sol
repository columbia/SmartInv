1 pragma solidity ^0.4.21;
2 ////////////////////////////////////////////////////////////////////////////////////////
3 //                                      WORTHLESS
4 //---------------------------------------------------
5 // Just Get WET - http://www.justgetwet.net/
6 // Twitter: https://www.twitter.com/justgetwetnet
7 // Facebook: https://www.facebook.com/justgetwet
8 // reddit: https://www.reddit.com/user/worthlessethereumceo
9 //---------------------------------------------------
10 // TOKEN DISTRIBUTION
11 //-------------------
12 // The token distribution for WET is simple. For every 0.01 ETH sent, the contract will 
13 // return 100.0 WET. That's 10000x as many worthless tokens!
14 //
15 //-------------------
16 // BONUS TOKENS
17 //-------------------
18 // Every transaction to purchase WET has a 1 in 100 chance (1 in 25 for the first 24 
19 // hours of launch) to reward a bonus token multiplier ranging from 2x to 11x.
20 //
21 //-------------------
22 // WORTHLESS JACKPOT
23 //-------------------
24 // Additionally, every transaction of at least 0.002 ETH has a 1 in 10,000 chance to 
25 // reward the worthless jackpot, an amount equal to the total amount of WET that has been 
26 // distributed so far.
27 //
28 //-------------------
29 ////////////////////////////////////////////////////////////////////////////////////////
30 
31 
32 
33 pragma solidity ^0.4.21;
34 
35 pragma solidity ^0.4.21;
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     emit OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 // <ORACLIZE_API>
78 /*
79 Copyright (c) 2015-2016 Oraclize SRL
80 Copyright (c) 2016 Oraclize LTD
81 
82 
83 
84 Permission is hereby granted, free of charge, to any person obtaining a copy
85 of this software and associated documentation files (the "Software"), to deal
86 in the Software without restriction, including without limitation the rights
87 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
88 copies of the Software, and to permit persons to whom the Software is
89 furnished to do so, subject to the following conditions:
90 
91 
92 
93 The above copyright notice and this permission notice shall be included in
94 all copies or substantial portions of the Software.
95 
96 
97 
98 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
99 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
100 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
101 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
102 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
103 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
104 THE SOFTWARE.
105 */
106 
107 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
108 pragma solidity ^0.4.18;
109 
110 contract OraclizeI {
111     address public cbAddress;
112     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
113     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
114     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
115     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
116     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
117     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
118     function getPrice(string _datasource) public returns (uint _dsprice);
119     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
120     function setProofType(byte _proofType) external;
121     function setCustomGasPrice(uint _gasPrice) external;
122     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
123 }
124 contract OraclizeAddrResolverI {
125     function getAddress() public returns (address _addr);
126 }
127 contract usingOraclize {
128     uint constant day = 60*60*24;
129     uint constant week = 60*60*24*7;
130     uint constant month = 60*60*24*30;
131     byte constant proofType_NONE = 0x00;
132     byte constant proofType_TLSNotary = 0x10;
133     byte constant proofType_Android = 0x20;
134     byte constant proofType_Ledger = 0x30;
135     byte constant proofType_Native = 0xF0;
136     byte constant proofStorage_IPFS = 0x01;
137     uint8 constant networkID_auto = 0;
138     uint8 constant networkID_mainnet = 1;
139     uint8 constant networkID_testnet = 2;
140     uint8 constant networkID_morden = 2;
141     uint8 constant networkID_consensys = 161;
142 
143     OraclizeAddrResolverI OAR;
144 
145     OraclizeI oraclize;
146     modifier oraclizeAPI {
147         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
148             oraclize_setNetwork(networkID_auto);
149 
150         if(address(oraclize) != OAR.getAddress())
151             oraclize = OraclizeI(OAR.getAddress());
152 
153         _;
154     }
155     modifier coupon(string code){
156         oraclize = OraclizeI(OAR.getAddress());
157         _;
158     }
159 
160     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
161       return oraclize_setNetwork();
162       networkID; // silence the warning and remain backwards compatible
163     }
164     function oraclize_setNetwork() internal returns(bool){
165         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
166             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
167             oraclize_setNetworkName("eth_mainnet");
168             return true;
169         }
170         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
171             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
172             oraclize_setNetworkName("eth_ropsten3");
173             return true;
174         }
175         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
176             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
177             oraclize_setNetworkName("eth_kovan");
178             return true;
179         }
180         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
181             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
182             oraclize_setNetworkName("eth_rinkeby");
183             return true;
184         }
185         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
186             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
187             return true;
188         }
189         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
190             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
191             return true;
192         }
193         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
194             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
195             return true;
196         }
197         return false;
198     }
199 
200     function __callback(bytes32 myid, string result) public {
201         __callback(myid, result, new bytes(0));
202     }
203     function __callback(bytes32 myid, string result, bytes proof) public {
204       return;
205       myid; result; proof; // Silence compiler warnings
206     }
207 
208     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
209         return oraclize.getPrice(datasource);
210     }
211 
212     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
213         return oraclize.getPrice(datasource, gaslimit);
214     }
215 
216     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
217         uint price = oraclize.getPrice(datasource);
218         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
219         return oraclize.query.value(price)(0, datasource, arg);
220     }
221     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
222         uint price = oraclize.getPrice(datasource);
223         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
224         return oraclize.query.value(price)(timestamp, datasource, arg);
225     }
226     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
227         uint price = oraclize.getPrice(datasource, gaslimit);
228         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
229         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
230     }
231     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
232         uint price = oraclize.getPrice(datasource, gaslimit);
233         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
234         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
235     }
236     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
237         uint price = oraclize.getPrice(datasource);
238         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
239         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
240     }
241     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
242         uint price = oraclize.getPrice(datasource);
243         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
244         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
245     }
246     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
247         uint price = oraclize.getPrice(datasource, gaslimit);
248         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
249         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
250     }
251     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
252         uint price = oraclize.getPrice(datasource, gaslimit);
253         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
254         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
255     }
256     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
257         uint price = oraclize.getPrice(datasource);
258         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
259         bytes memory args = stra2cbor(argN);
260         return oraclize.queryN.value(price)(0, datasource, args);
261     }
262     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
263         uint price = oraclize.getPrice(datasource);
264         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
265         bytes memory args = stra2cbor(argN);
266         return oraclize.queryN.value(price)(timestamp, datasource, args);
267     }
268     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
269         uint price = oraclize.getPrice(datasource, gaslimit);
270         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
271         bytes memory args = stra2cbor(argN);
272         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
273     }
274     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
275         uint price = oraclize.getPrice(datasource, gaslimit);
276         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
277         bytes memory args = stra2cbor(argN);
278         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
279     }
280     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
281         string[] memory dynargs = new string[](1);
282         dynargs[0] = args[0];
283         return oraclize_query(datasource, dynargs);
284     }
285     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
286         string[] memory dynargs = new string[](1);
287         dynargs[0] = args[0];
288         return oraclize_query(timestamp, datasource, dynargs);
289     }
290     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
291         string[] memory dynargs = new string[](1);
292         dynargs[0] = args[0];
293         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
294     }
295     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
296         string[] memory dynargs = new string[](1);
297         dynargs[0] = args[0];
298         return oraclize_query(datasource, dynargs, gaslimit);
299     }
300 
301     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
302         string[] memory dynargs = new string[](2);
303         dynargs[0] = args[0];
304         dynargs[1] = args[1];
305         return oraclize_query(datasource, dynargs);
306     }
307     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
308         string[] memory dynargs = new string[](2);
309         dynargs[0] = args[0];
310         dynargs[1] = args[1];
311         return oraclize_query(timestamp, datasource, dynargs);
312     }
313     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
314         string[] memory dynargs = new string[](2);
315         dynargs[0] = args[0];
316         dynargs[1] = args[1];
317         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
318     }
319     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
320         string[] memory dynargs = new string[](2);
321         dynargs[0] = args[0];
322         dynargs[1] = args[1];
323         return oraclize_query(datasource, dynargs, gaslimit);
324     }
325     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
326         string[] memory dynargs = new string[](3);
327         dynargs[0] = args[0];
328         dynargs[1] = args[1];
329         dynargs[2] = args[2];
330         return oraclize_query(datasource, dynargs);
331     }
332     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
333         string[] memory dynargs = new string[](3);
334         dynargs[0] = args[0];
335         dynargs[1] = args[1];
336         dynargs[2] = args[2];
337         return oraclize_query(timestamp, datasource, dynargs);
338     }
339     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
340         string[] memory dynargs = new string[](3);
341         dynargs[0] = args[0];
342         dynargs[1] = args[1];
343         dynargs[2] = args[2];
344         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
345     }
346     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
347         string[] memory dynargs = new string[](3);
348         dynargs[0] = args[0];
349         dynargs[1] = args[1];
350         dynargs[2] = args[2];
351         return oraclize_query(datasource, dynargs, gaslimit);
352     }
353 
354     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
355         string[] memory dynargs = new string[](4);
356         dynargs[0] = args[0];
357         dynargs[1] = args[1];
358         dynargs[2] = args[2];
359         dynargs[3] = args[3];
360         return oraclize_query(datasource, dynargs);
361     }
362     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
363         string[] memory dynargs = new string[](4);
364         dynargs[0] = args[0];
365         dynargs[1] = args[1];
366         dynargs[2] = args[2];
367         dynargs[3] = args[3];
368         return oraclize_query(timestamp, datasource, dynargs);
369     }
370     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
371         string[] memory dynargs = new string[](4);
372         dynargs[0] = args[0];
373         dynargs[1] = args[1];
374         dynargs[2] = args[2];
375         dynargs[3] = args[3];
376         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
377     }
378     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
379         string[] memory dynargs = new string[](4);
380         dynargs[0] = args[0];
381         dynargs[1] = args[1];
382         dynargs[2] = args[2];
383         dynargs[3] = args[3];
384         return oraclize_query(datasource, dynargs, gaslimit);
385     }
386     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
387         string[] memory dynargs = new string[](5);
388         dynargs[0] = args[0];
389         dynargs[1] = args[1];
390         dynargs[2] = args[2];
391         dynargs[3] = args[3];
392         dynargs[4] = args[4];
393         return oraclize_query(datasource, dynargs);
394     }
395     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
396         string[] memory dynargs = new string[](5);
397         dynargs[0] = args[0];
398         dynargs[1] = args[1];
399         dynargs[2] = args[2];
400         dynargs[3] = args[3];
401         dynargs[4] = args[4];
402         return oraclize_query(timestamp, datasource, dynargs);
403     }
404     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
405         string[] memory dynargs = new string[](5);
406         dynargs[0] = args[0];
407         dynargs[1] = args[1];
408         dynargs[2] = args[2];
409         dynargs[3] = args[3];
410         dynargs[4] = args[4];
411         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
412     }
413     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
414         string[] memory dynargs = new string[](5);
415         dynargs[0] = args[0];
416         dynargs[1] = args[1];
417         dynargs[2] = args[2];
418         dynargs[3] = args[3];
419         dynargs[4] = args[4];
420         return oraclize_query(datasource, dynargs, gaslimit);
421     }
422     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
423         uint price = oraclize.getPrice(datasource);
424         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
425         bytes memory args = ba2cbor(argN);
426         return oraclize.queryN.value(price)(0, datasource, args);
427     }
428     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
429         uint price = oraclize.getPrice(datasource);
430         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
431         bytes memory args = ba2cbor(argN);
432         return oraclize.queryN.value(price)(timestamp, datasource, args);
433     }
434     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
435         uint price = oraclize.getPrice(datasource, gaslimit);
436         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
437         bytes memory args = ba2cbor(argN);
438         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
439     }
440     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
441         uint price = oraclize.getPrice(datasource, gaslimit);
442         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
443         bytes memory args = ba2cbor(argN);
444         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
445     }
446     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
447         bytes[] memory dynargs = new bytes[](1);
448         dynargs[0] = args[0];
449         return oraclize_query(datasource, dynargs);
450     }
451     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
452         bytes[] memory dynargs = new bytes[](1);
453         dynargs[0] = args[0];
454         return oraclize_query(timestamp, datasource, dynargs);
455     }
456     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
457         bytes[] memory dynargs = new bytes[](1);
458         dynargs[0] = args[0];
459         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
460     }
461     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
462         bytes[] memory dynargs = new bytes[](1);
463         dynargs[0] = args[0];
464         return oraclize_query(datasource, dynargs, gaslimit);
465     }
466 
467     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
468         bytes[] memory dynargs = new bytes[](2);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         return oraclize_query(datasource, dynargs);
472     }
473     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
474         bytes[] memory dynargs = new bytes[](2);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         return oraclize_query(timestamp, datasource, dynargs);
478     }
479     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
480         bytes[] memory dynargs = new bytes[](2);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
484     }
485     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
486         bytes[] memory dynargs = new bytes[](2);
487         dynargs[0] = args[0];
488         dynargs[1] = args[1];
489         return oraclize_query(datasource, dynargs, gaslimit);
490     }
491     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
492         bytes[] memory dynargs = new bytes[](3);
493         dynargs[0] = args[0];
494         dynargs[1] = args[1];
495         dynargs[2] = args[2];
496         return oraclize_query(datasource, dynargs);
497     }
498     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
499         bytes[] memory dynargs = new bytes[](3);
500         dynargs[0] = args[0];
501         dynargs[1] = args[1];
502         dynargs[2] = args[2];
503         return oraclize_query(timestamp, datasource, dynargs);
504     }
505     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506         bytes[] memory dynargs = new bytes[](3);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
511     }
512     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
513         bytes[] memory dynargs = new bytes[](3);
514         dynargs[0] = args[0];
515         dynargs[1] = args[1];
516         dynargs[2] = args[2];
517         return oraclize_query(datasource, dynargs, gaslimit);
518     }
519 
520     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
521         bytes[] memory dynargs = new bytes[](4);
522         dynargs[0] = args[0];
523         dynargs[1] = args[1];
524         dynargs[2] = args[2];
525         dynargs[3] = args[3];
526         return oraclize_query(datasource, dynargs);
527     }
528     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
529         bytes[] memory dynargs = new bytes[](4);
530         dynargs[0] = args[0];
531         dynargs[1] = args[1];
532         dynargs[2] = args[2];
533         dynargs[3] = args[3];
534         return oraclize_query(timestamp, datasource, dynargs);
535     }
536     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
537         bytes[] memory dynargs = new bytes[](4);
538         dynargs[0] = args[0];
539         dynargs[1] = args[1];
540         dynargs[2] = args[2];
541         dynargs[3] = args[3];
542         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
543     }
544     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
545         bytes[] memory dynargs = new bytes[](4);
546         dynargs[0] = args[0];
547         dynargs[1] = args[1];
548         dynargs[2] = args[2];
549         dynargs[3] = args[3];
550         return oraclize_query(datasource, dynargs, gaslimit);
551     }
552     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
553         bytes[] memory dynargs = new bytes[](5);
554         dynargs[0] = args[0];
555         dynargs[1] = args[1];
556         dynargs[2] = args[2];
557         dynargs[3] = args[3];
558         dynargs[4] = args[4];
559         return oraclize_query(datasource, dynargs);
560     }
561     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
562         bytes[] memory dynargs = new bytes[](5);
563         dynargs[0] = args[0];
564         dynargs[1] = args[1];
565         dynargs[2] = args[2];
566         dynargs[3] = args[3];
567         dynargs[4] = args[4];
568         return oraclize_query(timestamp, datasource, dynargs);
569     }
570     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
571         bytes[] memory dynargs = new bytes[](5);
572         dynargs[0] = args[0];
573         dynargs[1] = args[1];
574         dynargs[2] = args[2];
575         dynargs[3] = args[3];
576         dynargs[4] = args[4];
577         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
578     }
579     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
580         bytes[] memory dynargs = new bytes[](5);
581         dynargs[0] = args[0];
582         dynargs[1] = args[1];
583         dynargs[2] = args[2];
584         dynargs[3] = args[3];
585         dynargs[4] = args[4];
586         return oraclize_query(datasource, dynargs, gaslimit);
587     }
588 
589     function oraclize_cbAddress() oraclizeAPI internal returns (address){
590         return oraclize.cbAddress();
591     }
592     function oraclize_setProof(byte proofP) oraclizeAPI internal {
593         return oraclize.setProofType(proofP);
594     }
595     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
596         return oraclize.setCustomGasPrice(gasPrice);
597     }
598 
599     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
600         return oraclize.randomDS_getSessionPubKeyHash();
601     }
602 
603     function getCodeSize(address _addr) constant internal returns(uint _size) {
604         assembly {
605             _size := extcodesize(_addr)
606         }
607     }
608 
609     function parseAddr(string _a) internal pure returns (address){
610         bytes memory tmp = bytes(_a);
611         uint160 iaddr = 0;
612         uint160 b1;
613         uint160 b2;
614         for (uint i=2; i<2+2*20; i+=2){
615             iaddr *= 256;
616             b1 = uint160(tmp[i]);
617             b2 = uint160(tmp[i+1]);
618             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
619             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
620             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
621             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
622             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
623             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
624             iaddr += (b1*16+b2);
625         }
626         return address(iaddr);
627     }
628 
629     function strCompare(string _a, string _b) internal pure returns (int) {
630         bytes memory a = bytes(_a);
631         bytes memory b = bytes(_b);
632         uint minLength = a.length;
633         if (b.length < minLength) minLength = b.length;
634         for (uint i = 0; i < minLength; i ++)
635             if (a[i] < b[i])
636                 return -1;
637             else if (a[i] > b[i])
638                 return 1;
639         if (a.length < b.length)
640             return -1;
641         else if (a.length > b.length)
642             return 1;
643         else
644             return 0;
645     }
646 
647     function indexOf(string _haystack, string _needle) internal pure returns (int) {
648         bytes memory h = bytes(_haystack);
649         bytes memory n = bytes(_needle);
650         if(h.length < 1 || n.length < 1 || (n.length > h.length))
651             return -1;
652         else if(h.length > (2**128 -1))
653             return -1;
654         else
655         {
656             uint subindex = 0;
657             for (uint i = 0; i < h.length; i ++)
658             {
659                 if (h[i] == n[0])
660                 {
661                     subindex = 1;
662                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
663                     {
664                         subindex++;
665                     }
666                     if(subindex == n.length)
667                         return int(i);
668                 }
669             }
670             return -1;
671         }
672     }
673 
674     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
675         bytes memory _ba = bytes(_a);
676         bytes memory _bb = bytes(_b);
677         bytes memory _bc = bytes(_c);
678         bytes memory _bd = bytes(_d);
679         bytes memory _be = bytes(_e);
680         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
681         bytes memory babcde = bytes(abcde);
682         uint k = 0;
683         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
684         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
685         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
686         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
687         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
688         return string(babcde);
689     }
690 
691     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
692         return strConcat(_a, _b, _c, _d, "");
693     }
694 
695     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
696         return strConcat(_a, _b, _c, "", "");
697     }
698 
699     function strConcat(string _a, string _b) internal pure returns (string) {
700         return strConcat(_a, _b, "", "", "");
701     }
702 
703     // parseInt
704     function parseInt(string _a) internal pure returns (uint) {
705         return parseInt(_a, 0);
706     }
707 
708     // parseInt(parseFloat*10^_b)
709     function parseInt(string _a, uint _b) internal pure returns (uint) {
710         bytes memory bresult = bytes(_a);
711         uint mint = 0;
712         bool decimals = false;
713         for (uint i=0; i<bresult.length; i++){
714             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
715                 if (decimals){
716                    if (_b == 0) break;
717                     else _b--;
718                 }
719                 mint *= 10;
720                 mint += uint(bresult[i]) - 48;
721             } else if (bresult[i] == 46) decimals = true;
722         }
723         if (_b > 0) mint *= 10**_b;
724         return mint;
725     }
726 
727     function uint2str(uint i) internal pure returns (string){
728         if (i == 0) return "0";
729         uint j = i;
730         uint len;
731         while (j != 0){
732             len++;
733             j /= 10;
734         }
735         bytes memory bstr = new bytes(len);
736         uint k = len - 1;
737         while (i != 0){
738             bstr[k--] = byte(48 + i % 10);
739             i /= 10;
740         }
741         return string(bstr);
742     }
743 
744     function stra2cbor(string[] arr) internal pure returns (bytes) {
745             uint arrlen = arr.length;
746 
747             // get correct cbor output length
748             uint outputlen = 0;
749             bytes[] memory elemArray = new bytes[](arrlen);
750             for (uint i = 0; i < arrlen; i++) {
751                 elemArray[i] = (bytes(arr[i]));
752                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
753             }
754             uint ctr = 0;
755             uint cborlen = arrlen + 0x80;
756             outputlen += byte(cborlen).length;
757             bytes memory res = new bytes(outputlen);
758 
759             while (byte(cborlen).length > ctr) {
760                 res[ctr] = byte(cborlen)[ctr];
761                 ctr++;
762             }
763             for (i = 0; i < arrlen; i++) {
764                 res[ctr] = 0x5F;
765                 ctr++;
766                 for (uint x = 0; x < elemArray[i].length; x++) {
767                     // if there's a bug with larger strings, this may be the culprit
768                     if (x % 23 == 0) {
769                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
770                         elemcborlen += 0x40;
771                         uint lctr = ctr;
772                         while (byte(elemcborlen).length > ctr - lctr) {
773                             res[ctr] = byte(elemcborlen)[ctr - lctr];
774                             ctr++;
775                         }
776                     }
777                     res[ctr] = elemArray[i][x];
778                     ctr++;
779                 }
780                 res[ctr] = 0xFF;
781                 ctr++;
782             }
783             return res;
784         }
785 
786     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
787             uint arrlen = arr.length;
788 
789             // get correct cbor output length
790             uint outputlen = 0;
791             bytes[] memory elemArray = new bytes[](arrlen);
792             for (uint i = 0; i < arrlen; i++) {
793                 elemArray[i] = (bytes(arr[i]));
794                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
795             }
796             uint ctr = 0;
797             uint cborlen = arrlen + 0x80;
798             outputlen += byte(cborlen).length;
799             bytes memory res = new bytes(outputlen);
800 
801             while (byte(cborlen).length > ctr) {
802                 res[ctr] = byte(cborlen)[ctr];
803                 ctr++;
804             }
805             for (i = 0; i < arrlen; i++) {
806                 res[ctr] = 0x5F;
807                 ctr++;
808                 for (uint x = 0; x < elemArray[i].length; x++) {
809                     // if there's a bug with larger strings, this may be the culprit
810                     if (x % 23 == 0) {
811                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
812                         elemcborlen += 0x40;
813                         uint lctr = ctr;
814                         while (byte(elemcborlen).length > ctr - lctr) {
815                             res[ctr] = byte(elemcborlen)[ctr - lctr];
816                             ctr++;
817                         }
818                     }
819                     res[ctr] = elemArray[i][x];
820                     ctr++;
821                 }
822                 res[ctr] = 0xFF;
823                 ctr++;
824             }
825             return res;
826         }
827 
828 
829     string oraclize_network_name;
830     function oraclize_setNetworkName(string _network_name) internal {
831         oraclize_network_name = _network_name;
832     }
833 
834     function oraclize_getNetworkName() internal view returns (string) {
835         return oraclize_network_name;
836     }
837 
838     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
839         require((_nbytes > 0) && (_nbytes <= 32));
840         // Convert from seconds to ledger timer ticks
841         _delay *= 10; 
842         bytes memory nbytes = new bytes(1);
843         nbytes[0] = byte(_nbytes);
844         bytes memory unonce = new bytes(32);
845         bytes memory sessionKeyHash = new bytes(32);
846         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
847         assembly {
848             mstore(unonce, 0x20)
849             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
850             mstore(sessionKeyHash, 0x20)
851             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
852         }
853         bytes memory delay = new bytes(32);
854         assembly { 
855             mstore(add(delay, 0x20), _delay) 
856         }
857         
858         bytes memory delay_bytes8 = new bytes(8);
859         copyBytes(delay, 24, 8, delay_bytes8, 0);
860 
861         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
862         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
863         
864         bytes memory delay_bytes8_left = new bytes(8);
865         
866         assembly {
867             let x := mload(add(delay_bytes8, 0x20))
868             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
869             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
870             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
871             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
872             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
873             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
874             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
875             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
876 
877         }
878         
879         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
880         return queryId;
881     }
882     
883     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
884         oraclize_randomDS_args[queryId] = commitment;
885     }
886 
887     mapping(bytes32=>bytes32) oraclize_randomDS_args;
888     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
889 
890     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
891         bool sigok;
892         address signer;
893 
894         bytes32 sigr;
895         bytes32 sigs;
896 
897         bytes memory sigr_ = new bytes(32);
898         uint offset = 4+(uint(dersig[3]) - 0x20);
899         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
900         bytes memory sigs_ = new bytes(32);
901         offset += 32 + 2;
902         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
903 
904         assembly {
905             sigr := mload(add(sigr_, 32))
906             sigs := mload(add(sigs_, 32))
907         }
908 
909 
910         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
911         if (address(keccak256(pubkey)) == signer) return true;
912         else {
913             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
914             return (address(keccak256(pubkey)) == signer);
915         }
916     }
917 
918     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
919         bool sigok;
920 
921         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
922         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
923         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
924 
925         bytes memory appkey1_pubkey = new bytes(64);
926         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
927 
928         bytes memory tosign2 = new bytes(1+65+32);
929         tosign2[0] = byte(1); //role
930         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
931         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
932         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
933         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
934 
935         if (sigok == false) return false;
936 
937 
938         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
939         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
940 
941         bytes memory tosign3 = new bytes(1+65);
942         tosign3[0] = 0xFE;
943         copyBytes(proof, 3, 65, tosign3, 1);
944 
945         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
946         copyBytes(proof, 3+65, sig3.length, sig3, 0);
947 
948         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
949 
950         return sigok;
951     }
952 
953     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
954         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
955         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
956 
957         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
958         require(proofVerified);
959 
960         _;
961     }
962 
963     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
964         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
965         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
966 
967         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
968         if (proofVerified == false) return 2;
969 
970         return 0;
971     }
972 
973     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
974         bool match_ = true;
975         
976         require(prefix.length == n_random_bytes);
977 
978         for (uint256 i=0; i< n_random_bytes; i++) {
979             if (content[i] != prefix[i]) match_ = false;
980         }
981 
982         return match_;
983     }
984 
985     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
986 
987         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
988         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
989         bytes memory keyhash = new bytes(32);
990         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
991         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
992 
993         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
994         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
995 
996         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
997         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
998 
999         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1000         // This is to verify that the computed args match with the ones specified in the query.
1001         bytes memory commitmentSlice1 = new bytes(8+1+32);
1002         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1003 
1004         bytes memory sessionPubkey = new bytes(64);
1005         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1006         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1007 
1008         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1009         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1010             delete oraclize_randomDS_args[queryId];
1011         } else return false;
1012 
1013 
1014         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1015         bytes memory tosign1 = new bytes(32+8+1+32);
1016         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1017         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1018 
1019         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1020         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1021             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1022         }
1023 
1024         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1025     }
1026 
1027     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1028     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1029         uint minLength = length + toOffset;
1030 
1031         // Buffer too small
1032         require(to.length >= minLength); // Should be a better way?
1033 
1034         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1035         uint i = 32 + fromOffset;
1036         uint j = 32 + toOffset;
1037 
1038         while (i < (32 + fromOffset + length)) {
1039             assembly {
1040                 let tmp := mload(add(from, i))
1041                 mstore(add(to, j), tmp)
1042             }
1043             i += 32;
1044             j += 32;
1045         }
1046 
1047         return to;
1048     }
1049 
1050     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1051     // Duplicate Solidity's ecrecover, but catching the CALL return value
1052     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1053         // We do our own memory management here. Solidity uses memory offset
1054         // 0x40 to store the current end of memory. We write past it (as
1055         // writes are memory extensions), but don't update the offset so
1056         // Solidity will reuse it. The memory used here is only needed for
1057         // this context.
1058 
1059         // FIXME: inline assembly can't access return values
1060         bool ret;
1061         address addr;
1062 
1063         assembly {
1064             let size := mload(0x40)
1065             mstore(size, hash)
1066             mstore(add(size, 32), v)
1067             mstore(add(size, 64), r)
1068             mstore(add(size, 96), s)
1069 
1070             // NOTE: we can reuse the request memory because we deal with
1071             //       the return code
1072             ret := call(3000, 1, 0, size, 128, size, 32)
1073             addr := mload(size)
1074         }
1075 
1076         return (ret, addr);
1077     }
1078 
1079     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1080     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1081         bytes32 r;
1082         bytes32 s;
1083         uint8 v;
1084 
1085         if (sig.length != 65)
1086           return (false, 0);
1087 
1088         // The signature format is a compact form of:
1089         //   {bytes32 r}{bytes32 s}{uint8 v}
1090         // Compact means, uint8 is not padded to 32 bytes.
1091         assembly {
1092             r := mload(add(sig, 32))
1093             s := mload(add(sig, 64))
1094 
1095             // Here we are loading the last 32 bytes. We exploit the fact that
1096             // 'mload' will pad with zeroes if we overread.
1097             // There is no 'mload8' to do this, but that would be nicer.
1098             v := byte(0, mload(add(sig, 96)))
1099 
1100             // Alternative solution:
1101             // 'byte' is not working due to the Solidity parser, so lets
1102             // use the second best option, 'and'
1103             // v := and(mload(add(sig, 65)), 255)
1104         }
1105 
1106         // albeit non-transactional signatures are not specified by the YP, one would expect it
1107         // to match the YP range of [27, 28]
1108         //
1109         // geth uses [0, 1] and some clients have followed. This might change, see:
1110         //  https://github.com/ethereum/go-ethereum/issues/2053
1111         if (v < 27)
1112           v += 27;
1113 
1114         if (v != 27 && v != 28)
1115             return (false, 0);
1116 
1117         return safer_ecrecover(hash, v, r, s);
1118     }
1119 
1120 }
1121 // </ORACLIZE_API>
1122 
1123 contract EIP20Interface {
1124 
1125     uint256 public totalSupply;
1126 
1127     function balanceOf(address _owner) public view returns (uint256 balance);
1128 
1129     function transfer(address _to, uint256 _value) public returns (bool success);
1130 
1131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
1132 
1133     function approve(address _spender, uint256 _value) public returns (bool success);
1134 
1135     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
1136 
1137     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
1138     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
1139 }
1140 
1141 // It may be a mess, but it's my worthless mess
1142 contract WorthlessEthereumTokens is EIP20Interface, usingOraclize, Ownable {
1143 
1144     uint256 constant private MAX_UINT256 = 2**256 - 1;
1145     mapping (address => uint256) public balances;
1146     mapping (address => mapping (address => uint256)) public allowed;
1147     mapping(address => uint) private newUser; // For keeping track of whether an address is new or not
1148 
1149     string public name = "Worthless Ethereum Tokens";
1150     uint8 public decimals = 18;
1151     string public symbol = "WET";
1152     
1153     uint256 private users; // For keeping track of the first 1,000 unique addresses to claim free WET
1154     uint256 public startDate = 1521788400; // Starts 03/23/18 12:00:00 AM PDT
1155     uint256 public endDate = 1522609199; // Ends 04/01/18 11:59:59 PM PDT
1156     uint256 public freeTokenTime = 1521786600; // Free token time starts 03/22/18 11:30:00 PM PDT
1157     uint256 public totalContribution; // Tracks total ETH you've given me
1158     uint256 public totalBonusTokens; // Tracks the total amount of bonus worthless tokens distributed
1159     uint256 public totalFreeTokensDistributed; // Tracks the total amount of free tokens given away to the first 1,000 unique addresses
1160     uint public lastBonusMultiplier; // Tracks the latest multiplier of the latest bonus-winning transaction
1161     uint public lastBonusNumber; // Tracks the latest bonus number picked
1162     uint public lastTokensIssued; // Tracks the latest sum of tokens to be issued
1163     
1164     uint256 private randomNumber; // A random number to spice things up a little
1165     
1166     // This function only runs once upon contract creation, used to set the random number  
1167     function WorthlessEthereumTokens() {
1168         randomNumber = uint256(oraclize_query("WolframAlpha", "random number between 0 and 9223372036854775807")); // Sets the random number to something upon contract creation, this works right?
1169     } 
1170     
1171     // This modifier is attached to the function that gives away free WET and is used to ensure each unique address can only claim free tokens once
1172     modifier newUsers() {
1173         require(now >= freeTokenTime); // Checks to make sure it's free taco time
1174         require(newUser[msg.sender] == 0); // Checks if the address is new
1175         require(users < 1000); // Checks if the total amount of free claims is less than 1,000
1176         _;
1177     }
1178     
1179     // This function is used to claim free WET and only works for the first 1,000 unique addresses to use it
1180     function firstThousandUsers() external newUsers {
1181         newUser[msg.sender] = 1; // Records the address as having claimed free WET
1182         users++; // Adds 1 to the total amount of free claims
1183         randomNumber += (now / 2); // Spices up the random number a little, I think?
1184         uint256 freeTokens = (uint256(keccak256(randomNumber))) % 100 + 1; // Takes the random number and generates a number between 1 - 100
1185         uint256 freeTokensIssued = freeTokens * 1000000000000000000; // Multiplies the result to ^18 to get whole numbers since we have 18 decimals in our token
1186         totalFreeTokensDistributed += freeTokensIssued; // Adds your free tokens to the total free tokens tracker
1187         totalSupply += freeTokensIssued; // Adds your free tokens to the total tokens tracker
1188         balances[msg.sender] += freeTokensIssued; // Increases your balance by the number of free tokens you claimed
1189         Transfer(address(this), msg.sender, freeTokensIssued); // Sends your address the free tokens you claimed
1190     }
1191   
1192     // This modifier is attached to the function used to purchase tokens and is used to ensure that tokens can only be 
1193     // purchased between the start and end dates that were set upon contract creation
1194     modifier purchasingAllowed() {
1195        require(now >= startDate && now <= endDate); // Checks if the current time is greater than the start date and less than the end date
1196        _;
1197     }
1198     
1199     // This function is used to purchase new WET
1200     function() payable purchasingAllowed {
1201         randomNumber += uint256(keccak256(now)) % 99999; // Okay seriously, I hope this makes it somewhat more random? I'm new to this whole thing
1202         totalContribution += msg.value; // Adds the amount of ETH sent to the total contribution
1203         uint256 tokensIssued = (msg.value * 10000); // Multiplies the amount of ETH sent by 10000 (that's a lot of worthless tokens)
1204         uint256 bonusHash = 0; // Resets the bonus number to 0 to make it more fair, because of the way it is
1205         if (now <= (startDate + 1 days)) { // Checks if the current time is within 24 hours of the launch of the token offering
1206             bonusHash = uint256(keccak256(block.coinbase, randomNumber, block.timestamp)) % 25 + 1; // If it's within that timeframe, the bonus number has a 1 in 25 chance of being correct
1207         }
1208         else { // Or else...
1209             bonusHash = uint256(keccak256(block.coinbase, randomNumber, block.timestamp)) % 100 + 1; // If it's past the first 24 hours of launch, the bonus number has a 1 in 100 chance of being correct
1210         }
1211         lastBonusNumber = bonusHash; // Sets the latest bonus number tracker to the number you drew for reference
1212         if (bonusHash == 3) { // WINNER, WINNER, CHICKEN DINNER! If the number you drew was 3, you won. Why 3? Why not.
1213             uint256 bonusMultiplier = uint256(keccak256(randomNumber + now)) % 10 + 2; // Another random number picker-thing that chooses a number between 2-11. Whatever number gets picked becomes your bonus multiplier!
1214             lastBonusMultiplier = bonusMultiplier; // Sets the latest bonus multiplier tracker to the number you drew for reference
1215             uint256 bonusTokensIssued = (msg.value * 10000) * bonusMultiplier - (msg.value * 10000); // Takes the total amount of tokens you purchased and multiplies them by the bonus multiplier you drew
1216             tokensIssued += bonusTokensIssued; // Adds the bonus tokens you won to the initial amount of tokens you purchased
1217             totalBonusTokens += bonusTokensIssued; // Adds the bonus tokens you won to the total bonus tokens tracker
1218         }
1219         if (msg.value >= 0.002 ether) { // JACKPOT!! Here's where you can win a ton of worthless tokens at random. Only works if the amount of ETH sent is greater than or equal to 0.002
1220             uint256 jackpotHash = uint256(keccak256(block.number + randomNumber)) % 10000 + 1; // Picks a random number between 1 - 10000.. really hoping the random number thing works at this part
1221             if (jackpotHash == 5555) { // Is your random jackpot number 5555? YOU WIN! Not 5555? YOU DON'T!
1222                 tokensIssued += totalSupply; // Adds an amount equal to the total amount of WET that has been distributed so far to the amount of tokens you're receiving
1223             }
1224         }
1225         lastTokensIssued = tokensIssued; // Sets the latest tokens issued tracker to the amount of tokens you received
1226         totalSupply += tokensIssued; // Adds the amount of tokens you received to the total token supply
1227         balances[msg.sender] += tokensIssued; // Adds the tokens you received to your balance
1228         Transfer(address(this), msg.sender, tokensIssued); // Sends you all your worthless tokens
1229     }
1230     
1231     // This modifier is attached to the function that allows me to withdraw the ETH you're sending me, essentially I can't pull any ETH out
1232     // until the token offer ends, which means I can't send ETH to the wallet, withdraw it, then send again in a never-ending cycle, generating
1233     // endless amounts of worthless tokens. No, at the end of this whole thing, I won't even have any WET myself, can't afford it. Ain't that something?
1234     modifier offerEnded () {
1235         require (now >= endDate); // Did the token offer end? Yes? Take it and go
1236         _;
1237     }
1238     
1239     // This function lets me take all the ETH you're probably not sending me
1240     function withdraw() external onlyOwner offerEnded {
1241 	    owner.transfer(this.balance); // Take it and go
1242 	}
1243 
1244     // Standard ERC20 transfer function 
1245     function transfer(address _to, uint256 _value) public returns (bool success) {
1246         require(balances[msg.sender] >= _value);
1247         balances[msg.sender] -= _value;
1248         balances[_to] += _value;
1249         Transfer(msg.sender, _to, _value);
1250         return true;
1251     }
1252     
1253     // Standard ERC20 transferFrom function
1254     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1255         uint256 allowance = allowed[_from][msg.sender];
1256         require(balances[_from] >= _value && allowance >= _value);
1257         balances[_to] += _value;
1258         balances[_from] -= _value;
1259         if (allowance < MAX_UINT256) {
1260             allowed[_from][msg.sender] -= _value;
1261         }
1262         Transfer(_from, _to, _value);
1263         return true;
1264     }
1265 
1266     // Standard ERC20 balanceOf function
1267     function balanceOf(address _owner) public view returns (uint256 balance) {
1268         return balances[_owner];
1269     }
1270 
1271     // Standard ERC20 approve function
1272     function approve(address _spender, uint256 _value) public returns (bool success) {
1273         allowed[msg.sender][_spender] = _value;
1274         Approval(msg.sender, _spender, _value);
1275         return true;
1276     }
1277 
1278     // Standard ERC20 allowance function
1279     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
1280         return allowed[_owner][_spender];
1281     }   
1282 }