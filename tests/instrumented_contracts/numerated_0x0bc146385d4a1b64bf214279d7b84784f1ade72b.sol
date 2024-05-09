1 /* MZT1 is a game that players can buy blocks (1000*1000 blocks), paint on blocks and bet which color has the maximum blocks on the map.
2  * The game is part of Mizhen family, so the game sends profit to MZBoss which is the share of Mizhen.
3  * The fee of buying, paiting and betting will go to MZBoss and community.
4  * Players can buy and own a block, and other players can pay higher price to buy the same block.
5  * Every time a block changes its owner, the price is 30% higher.
6  * The first buyer of a block will pay ETH to the pot.
7  * From the second buyer the taxed payment goes to the previous buyer and the pot.
8  * Plays can also pay to the owner to paint on a block.
9  * Plays can also bet which color has maximum blocks on the map. 
10  * Every 24 hours the pot will open and distribute profit to players who win the bet.
11  * The profit of pot will also go to the last player of the 24 hours who paint on any block.
12  * If no one did anything in the previous 24 hours, the distribution will be 75% of the pot.
13  * Otherwise, 10% of the pot will be distributed.
14  * After fee to MZBoss and community, 50% will go to the last painter, the other 50% will go to the winners of color betting.
15  * The bet on color will never disappear, there is no concept of round. It is going on forever.
16  *
17  * Smart Contract Security Audit by:
18  * 1 Callisto Network, 2 Jan, 3 Mason
19  * 
20  * Mizhen Team
21  */
22  
23 // <ORACLIZE_API>
24 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
25 /*
26 Copyright (c) 2015-2016 Oraclize SRL
27 Copyright (c) 2016 Oraclize LTD
28 Permission is hereby granted, free of charge, to any person obtaining a copy
29 of this software and associated documentation files (the "Software"), to deal
30 in the Software without restriction, including without limitation the rights
31 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
32 copies of the Software, and to permit persons to whom the Software is
33 furnished to do so, subject to the following conditions:
34 The above copyright notice and this permission notice shall be included in
35 all copies or substantial portions of the Software.
36 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
37 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
38 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
39 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
40 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
41 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
42 THE SOFTWARE.
43 */
44 
45 // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
46 
47 pragma solidity >=0.4.22;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
48 
49 contract OraclizeI {
50     address public cbAddress;
51     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
52     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
53     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
54     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
55     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
56     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
57     function getPrice(string _datasource) public returns (uint _dsprice);
58     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
59     function setProofType(byte _proofType) external;
60     function setCustomGasPrice(uint _gasPrice) external;
61     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
62 }
63 
64 contract OraclizeAddrResolverI {
65     function getAddress() public returns (address _addr);
66 }
67 
68 /*
69 Begin solidity-cborutils
70 https://github.com/smartcontractkit/solidity-cborutils
71 MIT License
72 Copyright (c) 2018 SmartContract ChainLink, Ltd.
73 Permission is hereby granted, free of charge, to any person obtaining a copy
74 of this software and associated documentation files (the "Software"), to deal
75 in the Software without restriction, including without limitation the rights
76 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
77 copies of the Software, and to permit persons to whom the Software is
78 furnished to do so, subject to the following conditions:
79 The above copyright notice and this permission notice shall be included in all
80 copies or substantial portions of the Software.
81 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
82 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
83 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
84 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
85 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
86 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
87 SOFTWARE.
88  */
89 
90 library Buffer {
91     struct buffer {
92         bytes buf;
93         uint capacity;
94     }
95 
96     function init(buffer memory buf, uint _capacity) internal pure {
97         uint capacity = _capacity;
98         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
99         // Allocate space for the buffer data
100         buf.capacity = capacity;
101         assembly {
102             let ptr := mload(0x40)
103             mstore(buf, ptr)
104             mstore(ptr, 0)
105             mstore(0x40, add(ptr, capacity))
106         }
107     }
108 
109     function resize(buffer memory buf, uint capacity) private pure {
110         bytes memory oldbuf = buf.buf;
111         init(buf, capacity);
112         append(buf, oldbuf);
113     }
114 
115     function max(uint a, uint b) private pure returns(uint) {
116         if(a > b) {
117             return a;
118         }
119         return b;
120     }
121 
122     /**
123      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
124      *      would exceed the capacity of the buffer.
125      * @param buf The buffer to append to.
126      * @param data The data to append.
127      * @return The original buffer.
128      */
129     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
130         if(data.length + buf.buf.length > buf.capacity) {
131             resize(buf, max(buf.capacity, data.length) * 2);
132         }
133 
134         uint dest;
135         uint src;
136         uint len = data.length;
137         assembly {
138             // Memory address of the buffer data
139             let bufptr := mload(buf)
140             // Length of existing buffer data
141             let buflen := mload(bufptr)
142             // Start address = buffer address + buffer length + sizeof(buffer length)
143             dest := add(add(bufptr, buflen), 32)
144             // Update buffer length
145             mstore(bufptr, add(buflen, mload(data)))
146             src := add(data, 32)
147         }
148 
149         // Copy word-length chunks while possible
150         for(; len >= 32; len -= 32) {
151             assembly {
152                 mstore(dest, mload(src))
153             }
154             dest += 32;
155             src += 32;
156         }
157 
158         // Copy remaining bytes
159         uint mask = 256 ** (32 - len) - 1;
160         assembly {
161             let srcpart := and(mload(src), not(mask))
162             let destpart := and(mload(dest), mask)
163             mstore(dest, or(destpart, srcpart))
164         }
165 
166         return buf;
167     }
168 
169     /**
170      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
171      * exceed the capacity of the buffer.
172      * @param buf The buffer to append to.
173      * @param data The data to append.
174      * @return The original buffer.
175      */
176     function append(buffer memory buf, uint8 data) internal pure {
177         if(buf.buf.length + 1 > buf.capacity) {
178             resize(buf, buf.capacity * 2);
179         }
180 
181         assembly {
182             // Memory address of the buffer data
183             let bufptr := mload(buf)
184             // Length of existing buffer data
185             let buflen := mload(bufptr)
186             // Address = buffer address + buffer length + sizeof(buffer length)
187             let dest := add(add(bufptr, buflen), 32)
188             mstore8(dest, data)
189             // Update buffer length
190             mstore(bufptr, add(buflen, 1))
191         }
192     }
193 
194     /**
195      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
196      * exceed the capacity of the buffer.
197      * @param buf The buffer to append to.
198      * @param data The data to append.
199      * @return The original buffer.
200      */
201     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
202         if(len + buf.buf.length > buf.capacity) {
203             resize(buf, max(buf.capacity, len) * 2);
204         }
205 
206         uint mask = 256 ** len - 1;
207         assembly {
208             // Memory address of the buffer data
209             let bufptr := mload(buf)
210             // Length of existing buffer data
211             let buflen := mload(bufptr)
212             // Address = buffer address + buffer length + sizeof(buffer length) + len
213             let dest := add(add(bufptr, buflen), len)
214             mstore(dest, or(and(mload(dest), not(mask)), data))
215             // Update buffer length
216             mstore(bufptr, add(buflen, len))
217         }
218         return buf;
219     }
220 }
221 
222 library CBOR {
223     using Buffer for Buffer.buffer;
224 
225     uint8 private constant MAJOR_TYPE_INT = 0;
226     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
227     uint8 private constant MAJOR_TYPE_BYTES = 2;
228     uint8 private constant MAJOR_TYPE_STRING = 3;
229     uint8 private constant MAJOR_TYPE_ARRAY = 4;
230     uint8 private constant MAJOR_TYPE_MAP = 5;
231     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
232 
233     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
234         if(value <= 23) {
235             buf.append(uint8((major << 5) | value));
236         } else if(value <= 0xFF) {
237             buf.append(uint8((major << 5) | 24));
238             buf.appendInt(value, 1);
239         } else if(value <= 0xFFFF) {
240             buf.append(uint8((major << 5) | 25));
241             buf.appendInt(value, 2);
242         } else if(value <= 0xFFFFFFFF) {
243             buf.append(uint8((major << 5) | 26));
244             buf.appendInt(value, 4);
245         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
246             buf.append(uint8((major << 5) | 27));
247             buf.appendInt(value, 8);
248         }
249     }
250 
251     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
252         buf.append(uint8((major << 5) | 31));
253     }
254 
255     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
256         encodeType(buf, MAJOR_TYPE_INT, value);
257     }
258 
259     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
260         if(value >= 0) {
261             encodeType(buf, MAJOR_TYPE_INT, uint(value));
262         } else {
263             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
264         }
265     }
266 
267     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
268         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
269         buf.append(value);
270     }
271 
272     function encodeString(Buffer.buffer memory buf, string value) internal pure {
273         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
274         buf.append(bytes(value));
275     }
276 
277     function startArray(Buffer.buffer memory buf) internal pure {
278         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
279     }
280 
281     function startMap(Buffer.buffer memory buf) internal pure {
282         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
283     }
284 
285     function endSequence(Buffer.buffer memory buf) internal pure {
286         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
287     }
288 }
289 
290 /*
291 End solidity-cborutils
292  */
293 
294 contract usingOraclize {
295     uint constant day = 60*60*24;
296     uint constant week = 60*60*24*7;
297     uint constant month = 60*60*24*30;
298     byte constant proofType_NONE = 0x00;
299     byte constant proofType_TLSNotary = 0x10;
300     byte constant proofType_Ledger = 0x30;
301     byte constant proofType_Android = 0x40;
302     byte constant proofType_Native = 0xF0;
303     byte constant proofStorage_IPFS = 0x01;
304     uint8 constant networkID_auto = 0;
305     uint8 constant networkID_mainnet = 1;
306     uint8 constant networkID_testnet = 2;
307     uint8 constant networkID_morden = 2;
308     uint8 constant networkID_consensys = 161;
309 
310     OraclizeAddrResolverI OAR;
311 
312     OraclizeI oraclize;
313     modifier oraclizeAPI {
314         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
315             oraclize_setNetwork(networkID_auto);
316 
317         if(address(oraclize) != OAR.getAddress())
318             oraclize = OraclizeI(OAR.getAddress());
319 
320         _;
321     }
322     modifier coupon(string code){
323         oraclize = OraclizeI(OAR.getAddress());
324         _;
325     }
326 
327     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
328       return oraclize_setNetwork();
329       networkID; // silence the warning and remain backwards compatible
330     }
331     function oraclize_setNetwork() internal returns(bool){
332         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
333             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
334             oraclize_setNetworkName("eth_mainnet");
335             return true;
336         }
337         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
338             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
339             oraclize_setNetworkName("eth_ropsten3");
340             return true;
341         }
342         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
343             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
344             oraclize_setNetworkName("eth_kovan");
345             return true;
346         }
347         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
348             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
349             oraclize_setNetworkName("eth_rinkeby");
350             return true;
351         }
352         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
353             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
354             return true;
355         }
356         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
357             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
358             return true;
359         }
360         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
361             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
362             return true;
363         }
364         return false;
365     }
366 
367     function __callback(bytes32 myid, string result) public {
368         __callback(myid, result, new bytes(0));
369     }
370     function __callback(bytes32 myid, string result, bytes proof) public {
371       return;
372       // Following should never be reached with a preceding return, however
373       // this is just a placeholder function, ideally meant to be defined in
374       // child contract when proofs are used
375       myid; result; proof; // Silence compiler warnings
376       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view. 
377     }
378 
379     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
380         return oraclize.getPrice(datasource);
381     }
382 
383     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
384         return oraclize.getPrice(datasource, gaslimit);
385     }
386 
387     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
388         uint price = oraclize.getPrice(datasource);
389         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
390         return oraclize.query.value(price)(0, datasource, arg);
391     }
392     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
393         uint price = oraclize.getPrice(datasource);
394         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
395         return oraclize.query.value(price)(timestamp, datasource, arg);
396     }
397     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
398         uint price = oraclize.getPrice(datasource, gaslimit);
399         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
400         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
401     }
402     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
403         uint price = oraclize.getPrice(datasource, gaslimit);
404         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
405         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
406     }
407     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
408         uint price = oraclize.getPrice(datasource);
409         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
410         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
411     }
412     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
413         uint price = oraclize.getPrice(datasource);
414         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
415         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
416     }
417     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
418         uint price = oraclize.getPrice(datasource, gaslimit);
419         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
420         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
421     }
422     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
423         uint price = oraclize.getPrice(datasource, gaslimit);
424         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
425         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
426     }
427     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
428         uint price = oraclize.getPrice(datasource);
429         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
430         bytes memory args = stra2cbor(argN);
431         return oraclize.queryN.value(price)(0, datasource, args);
432     }
433     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
434         uint price = oraclize.getPrice(datasource);
435         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
436         bytes memory args = stra2cbor(argN);
437         return oraclize.queryN.value(price)(timestamp, datasource, args);
438     }
439     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
440         uint price = oraclize.getPrice(datasource, gaslimit);
441         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
442         bytes memory args = stra2cbor(argN);
443         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
444     }
445     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
446         uint price = oraclize.getPrice(datasource, gaslimit);
447         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
448         bytes memory args = stra2cbor(argN);
449         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
450     }
451     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
452         string[] memory dynargs = new string[](1);
453         dynargs[0] = args[0];
454         return oraclize_query(datasource, dynargs);
455     }
456     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
457         string[] memory dynargs = new string[](1);
458         dynargs[0] = args[0];
459         return oraclize_query(timestamp, datasource, dynargs);
460     }
461     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
462         string[] memory dynargs = new string[](1);
463         dynargs[0] = args[0];
464         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
465     }
466     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
467         string[] memory dynargs = new string[](1);
468         dynargs[0] = args[0];
469         return oraclize_query(datasource, dynargs, gaslimit);
470     }
471 
472     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
473         string[] memory dynargs = new string[](2);
474         dynargs[0] = args[0];
475         dynargs[1] = args[1];
476         return oraclize_query(datasource, dynargs);
477     }
478     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
479         string[] memory dynargs = new string[](2);
480         dynargs[0] = args[0];
481         dynargs[1] = args[1];
482         return oraclize_query(timestamp, datasource, dynargs);
483     }
484     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
485         string[] memory dynargs = new string[](2);
486         dynargs[0] = args[0];
487         dynargs[1] = args[1];
488         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
489     }
490     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
491         string[] memory dynargs = new string[](2);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         return oraclize_query(datasource, dynargs, gaslimit);
495     }
496     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
497         string[] memory dynargs = new string[](3);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         dynargs[2] = args[2];
501         return oraclize_query(datasource, dynargs);
502     }
503     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
504         string[] memory dynargs = new string[](3);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         return oraclize_query(timestamp, datasource, dynargs);
509     }
510     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
511         string[] memory dynargs = new string[](3);
512         dynargs[0] = args[0];
513         dynargs[1] = args[1];
514         dynargs[2] = args[2];
515         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
516     }
517     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
518         string[] memory dynargs = new string[](3);
519         dynargs[0] = args[0];
520         dynargs[1] = args[1];
521         dynargs[2] = args[2];
522         return oraclize_query(datasource, dynargs, gaslimit);
523     }
524 
525     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
526         string[] memory dynargs = new string[](4);
527         dynargs[0] = args[0];
528         dynargs[1] = args[1];
529         dynargs[2] = args[2];
530         dynargs[3] = args[3];
531         return oraclize_query(datasource, dynargs);
532     }
533     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
534         string[] memory dynargs = new string[](4);
535         dynargs[0] = args[0];
536         dynargs[1] = args[1];
537         dynargs[2] = args[2];
538         dynargs[3] = args[3];
539         return oraclize_query(timestamp, datasource, dynargs);
540     }
541     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
542         string[] memory dynargs = new string[](4);
543         dynargs[0] = args[0];
544         dynargs[1] = args[1];
545         dynargs[2] = args[2];
546         dynargs[3] = args[3];
547         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
548     }
549     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
550         string[] memory dynargs = new string[](4);
551         dynargs[0] = args[0];
552         dynargs[1] = args[1];
553         dynargs[2] = args[2];
554         dynargs[3] = args[3];
555         return oraclize_query(datasource, dynargs, gaslimit);
556     }
557     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
558         string[] memory dynargs = new string[](5);
559         dynargs[0] = args[0];
560         dynargs[1] = args[1];
561         dynargs[2] = args[2];
562         dynargs[3] = args[3];
563         dynargs[4] = args[4];
564         return oraclize_query(datasource, dynargs);
565     }
566     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
567         string[] memory dynargs = new string[](5);
568         dynargs[0] = args[0];
569         dynargs[1] = args[1];
570         dynargs[2] = args[2];
571         dynargs[3] = args[3];
572         dynargs[4] = args[4];
573         return oraclize_query(timestamp, datasource, dynargs);
574     }
575     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
576         string[] memory dynargs = new string[](5);
577         dynargs[0] = args[0];
578         dynargs[1] = args[1];
579         dynargs[2] = args[2];
580         dynargs[3] = args[3];
581         dynargs[4] = args[4];
582         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
583     }
584     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
585         string[] memory dynargs = new string[](5);
586         dynargs[0] = args[0];
587         dynargs[1] = args[1];
588         dynargs[2] = args[2];
589         dynargs[3] = args[3];
590         dynargs[4] = args[4];
591         return oraclize_query(datasource, dynargs, gaslimit);
592     }
593     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
594         uint price = oraclize.getPrice(datasource);
595         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
596         bytes memory args = ba2cbor(argN);
597         return oraclize.queryN.value(price)(0, datasource, args);
598     }
599     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
600         uint price = oraclize.getPrice(datasource);
601         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
602         bytes memory args = ba2cbor(argN);
603         return oraclize.queryN.value(price)(timestamp, datasource, args);
604     }
605     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
606         uint price = oraclize.getPrice(datasource, gaslimit);
607         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
608         bytes memory args = ba2cbor(argN);
609         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
610     }
611     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
612         uint price = oraclize.getPrice(datasource, gaslimit);
613         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
614         bytes memory args = ba2cbor(argN);
615         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
616     }
617     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
618         bytes[] memory dynargs = new bytes[](1);
619         dynargs[0] = args[0];
620         return oraclize_query(datasource, dynargs);
621     }
622     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
623         bytes[] memory dynargs = new bytes[](1);
624         dynargs[0] = args[0];
625         return oraclize_query(timestamp, datasource, dynargs);
626     }
627     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
628         bytes[] memory dynargs = new bytes[](1);
629         dynargs[0] = args[0];
630         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
631     }
632     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
633         bytes[] memory dynargs = new bytes[](1);
634         dynargs[0] = args[0];
635         return oraclize_query(datasource, dynargs, gaslimit);
636     }
637 
638     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
639         bytes[] memory dynargs = new bytes[](2);
640         dynargs[0] = args[0];
641         dynargs[1] = args[1];
642         return oraclize_query(datasource, dynargs);
643     }
644     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
645         bytes[] memory dynargs = new bytes[](2);
646         dynargs[0] = args[0];
647         dynargs[1] = args[1];
648         return oraclize_query(timestamp, datasource, dynargs);
649     }
650     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
651         bytes[] memory dynargs = new bytes[](2);
652         dynargs[0] = args[0];
653         dynargs[1] = args[1];
654         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
655     }
656     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
657         bytes[] memory dynargs = new bytes[](2);
658         dynargs[0] = args[0];
659         dynargs[1] = args[1];
660         return oraclize_query(datasource, dynargs, gaslimit);
661     }
662     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
663         bytes[] memory dynargs = new bytes[](3);
664         dynargs[0] = args[0];
665         dynargs[1] = args[1];
666         dynargs[2] = args[2];
667         return oraclize_query(datasource, dynargs);
668     }
669     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
670         bytes[] memory dynargs = new bytes[](3);
671         dynargs[0] = args[0];
672         dynargs[1] = args[1];
673         dynargs[2] = args[2];
674         return oraclize_query(timestamp, datasource, dynargs);
675     }
676     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
677         bytes[] memory dynargs = new bytes[](3);
678         dynargs[0] = args[0];
679         dynargs[1] = args[1];
680         dynargs[2] = args[2];
681         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
682     }
683     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
684         bytes[] memory dynargs = new bytes[](3);
685         dynargs[0] = args[0];
686         dynargs[1] = args[1];
687         dynargs[2] = args[2];
688         return oraclize_query(datasource, dynargs, gaslimit);
689     }
690 
691     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
692         bytes[] memory dynargs = new bytes[](4);
693         dynargs[0] = args[0];
694         dynargs[1] = args[1];
695         dynargs[2] = args[2];
696         dynargs[3] = args[3];
697         return oraclize_query(datasource, dynargs);
698     }
699     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
700         bytes[] memory dynargs = new bytes[](4);
701         dynargs[0] = args[0];
702         dynargs[1] = args[1];
703         dynargs[2] = args[2];
704         dynargs[3] = args[3];
705         return oraclize_query(timestamp, datasource, dynargs);
706     }
707     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
708         bytes[] memory dynargs = new bytes[](4);
709         dynargs[0] = args[0];
710         dynargs[1] = args[1];
711         dynargs[2] = args[2];
712         dynargs[3] = args[3];
713         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
714     }
715     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
716         bytes[] memory dynargs = new bytes[](4);
717         dynargs[0] = args[0];
718         dynargs[1] = args[1];
719         dynargs[2] = args[2];
720         dynargs[3] = args[3];
721         return oraclize_query(datasource, dynargs, gaslimit);
722     }
723     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
724         bytes[] memory dynargs = new bytes[](5);
725         dynargs[0] = args[0];
726         dynargs[1] = args[1];
727         dynargs[2] = args[2];
728         dynargs[3] = args[3];
729         dynargs[4] = args[4];
730         return oraclize_query(datasource, dynargs);
731     }
732     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
733         bytes[] memory dynargs = new bytes[](5);
734         dynargs[0] = args[0];
735         dynargs[1] = args[1];
736         dynargs[2] = args[2];
737         dynargs[3] = args[3];
738         dynargs[4] = args[4];
739         return oraclize_query(timestamp, datasource, dynargs);
740     }
741     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
742         bytes[] memory dynargs = new bytes[](5);
743         dynargs[0] = args[0];
744         dynargs[1] = args[1];
745         dynargs[2] = args[2];
746         dynargs[3] = args[3];
747         dynargs[4] = args[4];
748         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
749     }
750     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
751         bytes[] memory dynargs = new bytes[](5);
752         dynargs[0] = args[0];
753         dynargs[1] = args[1];
754         dynargs[2] = args[2];
755         dynargs[3] = args[3];
756         dynargs[4] = args[4];
757         return oraclize_query(datasource, dynargs, gaslimit);
758     }
759 
760     function oraclize_cbAddress() oraclizeAPI internal returns (address){
761         return oraclize.cbAddress();
762     }
763     function oraclize_setProof(byte proofP) oraclizeAPI internal {
764         return oraclize.setProofType(proofP);
765     }
766     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
767         return oraclize.setCustomGasPrice(gasPrice);
768     }
769 
770     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
771         return oraclize.randomDS_getSessionPubKeyHash();
772     }
773 
774     function getCodeSize(address _addr) view internal returns(uint _size) {
775         assembly {
776             _size := extcodesize(_addr)
777         }
778     }
779 
780     function parseAddr(string _a) internal pure returns (address){
781         bytes memory tmp = bytes(_a);
782         uint160 iaddr = 0;
783         uint160 b1;
784         uint160 b2;
785         for (uint i=2; i<2+2*20; i+=2){
786             iaddr *= 256;
787             b1 = uint160(tmp[i]);
788             b2 = uint160(tmp[i+1]);
789             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
790             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
791             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
792             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
793             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
794             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
795             iaddr += (b1*16+b2);
796         }
797         return address(iaddr);
798     }
799 
800     function strCompare(string _a, string _b) internal pure returns (int) {
801         bytes memory a = bytes(_a);
802         bytes memory b = bytes(_b);
803         uint minLength = a.length;
804         if (b.length < minLength) minLength = b.length;
805         for (uint i = 0; i < minLength; i ++)
806             if (a[i] < b[i])
807                 return -1;
808             else if (a[i] > b[i])
809                 return 1;
810         if (a.length < b.length)
811             return -1;
812         else if (a.length > b.length)
813             return 1;
814         else
815             return 0;
816     }
817 
818     function indexOf(string _haystack, string _needle) internal pure returns (int) {
819         bytes memory h = bytes(_haystack);
820         bytes memory n = bytes(_needle);
821         if(h.length < 1 || n.length < 1 || (n.length > h.length))
822             return -1;
823         else if(h.length > (2**128 -1))
824             return -1;
825         else
826         {
827             uint subindex = 0;
828             for (uint i = 0; i < h.length; i ++)
829             {
830                 if (h[i] == n[0])
831                 {
832                     subindex = 1;
833                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
834                     {
835                         subindex++;
836                     }
837                     if(subindex == n.length)
838                         return int(i);
839                 }
840             }
841             return -1;
842         }
843     }
844 
845     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
846         bytes memory _ba = bytes(_a);
847         bytes memory _bb = bytes(_b);
848         bytes memory _bc = bytes(_c);
849         bytes memory _bd = bytes(_d);
850         bytes memory _be = bytes(_e);
851         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
852         bytes memory babcde = bytes(abcde);
853         uint k = 0;
854         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
855         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
856         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
857         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
858         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
859         return string(babcde);
860     }
861 
862     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
863         return strConcat(_a, _b, _c, _d, "");
864     }
865 
866     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
867         return strConcat(_a, _b, _c, "", "");
868     }
869 
870     function strConcat(string _a, string _b) internal pure returns (string) {
871         return strConcat(_a, _b, "", "", "");
872     }
873 
874     // parseInt
875     function parseInt(string _a) internal pure returns (uint) {
876         return parseInt(_a, 0);
877     }
878 
879     // parseInt(parseFloat*10^_b)
880     function parseInt(string _a, uint _b) internal pure returns (uint) {
881         bytes memory bresult = bytes(_a);
882         uint mint = 0;
883         bool decimals = false;
884         for (uint i=0; i<bresult.length; i++){
885             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
886                 if (decimals){
887                    if (_b == 0) break;
888                     else _b--;
889                 }
890                 mint *= 10;
891                 mint += uint(bresult[i]) - 48;
892             } else if (bresult[i] == 46) decimals = true;
893         }
894         if (_b > 0) mint *= 10**_b;
895         return mint;
896     }
897 
898     function uint2str(uint i) internal pure returns (string){
899         if (i == 0) return "0";
900         uint j = i;
901         uint len;
902         while (j != 0){
903             len++;
904             j /= 10;
905         }
906         bytes memory bstr = new bytes(len);
907         uint k = len - 1;
908         while (i != 0){
909             bstr[k--] = byte(48 + i % 10);
910             i /= 10;
911         }
912         return string(bstr);
913     }
914 
915     using CBOR for Buffer.buffer;
916     function stra2cbor(string[] arr) internal pure returns (bytes) {
917         safeMemoryCleaner();
918         Buffer.buffer memory buf;
919         Buffer.init(buf, 1024);
920         buf.startArray();
921         for (uint i = 0; i < arr.length; i++) {
922             buf.encodeString(arr[i]);
923         }
924         buf.endSequence();
925         return buf.buf;
926     }
927 
928     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
929         safeMemoryCleaner();
930         Buffer.buffer memory buf;
931         Buffer.init(buf, 1024);
932         buf.startArray();
933         for (uint i = 0; i < arr.length; i++) {
934             buf.encodeBytes(arr[i]);
935         }
936         buf.endSequence();
937         return buf.buf;
938     }
939 
940     string oraclize_network_name;
941     function oraclize_setNetworkName(string _network_name) internal {
942         oraclize_network_name = _network_name;
943     }
944 
945     function oraclize_getNetworkName() internal view returns (string) {
946         return oraclize_network_name;
947     }
948 
949     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
950         require((_nbytes > 0) && (_nbytes <= 32));
951         // Convert from seconds to ledger timer ticks
952         _delay *= 10;
953         bytes memory nbytes = new bytes(1);
954         nbytes[0] = byte(_nbytes);
955         bytes memory unonce = new bytes(32);
956         bytes memory sessionKeyHash = new bytes(32);
957         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
958         assembly {
959             mstore(unonce, 0x20)
960             // the following variables can be relaxed
961             // check relaxed random contract under ethereum-examples repo
962             // for an idea on how to override and replace comit hash vars
963             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
964             mstore(sessionKeyHash, 0x20)
965             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
966         }
967         bytes memory delay = new bytes(32);
968         assembly {
969             mstore(add(delay, 0x20), _delay)
970         }
971 
972         bytes memory delay_bytes8 = new bytes(8);
973         copyBytes(delay, 24, 8, delay_bytes8, 0);
974 
975         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
976         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
977 
978         bytes memory delay_bytes8_left = new bytes(8);
979 
980         assembly {
981             let x := mload(add(delay_bytes8, 0x20))
982             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
983             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
984             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
985             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
986             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
987             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
988             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
989             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
990 
991         }
992 
993         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
994         return queryId;
995     }
996 
997     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
998         oraclize_randomDS_args[queryId] = commitment;
999     }
1000 
1001     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1002     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1003 
1004     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1005         bool sigok;
1006         address signer;
1007 
1008         bytes32 sigr;
1009         bytes32 sigs;
1010 
1011         bytes memory sigr_ = new bytes(32);
1012         uint offset = 4+(uint(dersig[3]) - 0x20);
1013         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1014         bytes memory sigs_ = new bytes(32);
1015         offset += 32 + 2;
1016         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1017 
1018         assembly {
1019             sigr := mload(add(sigr_, 32))
1020             sigs := mload(add(sigs_, 32))
1021         }
1022 
1023 
1024         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1025         if (address(keccak256(pubkey)) == signer) return true;
1026         else {
1027             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1028             return (address(keccak256(pubkey)) == signer);
1029         }
1030     }
1031 
1032     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1033         bool sigok;
1034 
1035         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1036         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1037         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1038 
1039         bytes memory appkey1_pubkey = new bytes(64);
1040         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1041 
1042         bytes memory tosign2 = new bytes(1+65+32);
1043         tosign2[0] = byte(1); //role
1044         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1045         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1046         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1047         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1048 
1049         if (sigok == false) return false;
1050 
1051 
1052         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1053         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1054 
1055         bytes memory tosign3 = new bytes(1+65);
1056         tosign3[0] = 0xFE;
1057         copyBytes(proof, 3, 65, tosign3, 1);
1058 
1059         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1060         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1061 
1062         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1063 
1064         return sigok;
1065     }
1066 
1067     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1068         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1069         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1070 
1071         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1072         require(proofVerified);
1073 
1074         _;
1075     }
1076 
1077     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1078         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1079         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1080 
1081         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1082         if (proofVerified == false) return 2;
1083 
1084         return 0;
1085     }
1086 
1087     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1088         bool match_ = true;
1089 
1090         require(prefix.length == n_random_bytes);
1091 
1092         for (uint256 i=0; i< n_random_bytes; i++) {
1093             if (content[i] != prefix[i]) match_ = false;
1094         }
1095 
1096         return match_;
1097     }
1098 
1099     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1100 
1101         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1102         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1103         bytes memory keyhash = new bytes(32);
1104         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1105         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1106 
1107         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1108         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1109 
1110         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1111         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1112 
1113         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1114         // This is to verify that the computed args match with the ones specified in the query.
1115         bytes memory commitmentSlice1 = new bytes(8+1+32);
1116         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1117 
1118         bytes memory sessionPubkey = new bytes(64);
1119         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1120         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1121 
1122         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1123         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1124             delete oraclize_randomDS_args[queryId];
1125         } else return false;
1126 
1127 
1128         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1129         bytes memory tosign1 = new bytes(32+8+1+32);
1130         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1131         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1132 
1133         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1134         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1135             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1136         }
1137 
1138         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1139     }
1140 
1141     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1142     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1143         uint minLength = length + toOffset;
1144 
1145         // Buffer too small
1146         require(to.length >= minLength); // Should be a better way?
1147 
1148         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1149         uint i = 32 + fromOffset;
1150         uint j = 32 + toOffset;
1151 
1152         while (i < (32 + fromOffset + length)) {
1153             assembly {
1154                 let tmp := mload(add(from, i))
1155                 mstore(add(to, j), tmp)
1156             }
1157             i += 32;
1158             j += 32;
1159         }
1160 
1161         return to;
1162     }
1163 
1164     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1165     // Duplicate Solidity's ecrecover, but catching the CALL return value
1166     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1167         // We do our own memory management here. Solidity uses memory offset
1168         // 0x40 to store the current end of memory. We write past it (as
1169         // writes are memory extensions), but don't update the offset so
1170         // Solidity will reuse it. The memory used here is only needed for
1171         // this context.
1172 
1173         // FIXME: inline assembly can't access return values
1174         bool ret;
1175         address addr;
1176 
1177         assembly {
1178             let size := mload(0x40)
1179             mstore(size, hash)
1180             mstore(add(size, 32), v)
1181             mstore(add(size, 64), r)
1182             mstore(add(size, 96), s)
1183 
1184             // NOTE: we can reuse the request memory because we deal with
1185             //       the return code
1186             ret := call(3000, 1, 0, size, 128, size, 32)
1187             addr := mload(size)
1188         }
1189 
1190         return (ret, addr);
1191     }
1192 
1193     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1194     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1195         bytes32 r;
1196         bytes32 s;
1197         uint8 v;
1198 
1199         if (sig.length != 65)
1200           return (false, 0);
1201 
1202         // The signature format is a compact form of:
1203         //   {bytes32 r}{bytes32 s}{uint8 v}
1204         // Compact means, uint8 is not padded to 32 bytes.
1205         assembly {
1206             r := mload(add(sig, 32))
1207             s := mload(add(sig, 64))
1208 
1209             // Here we are loading the last 32 bytes. We exploit the fact that
1210             // 'mload' will pad with zeroes if we overread.
1211             // There is no 'mload8' to do this, but that would be nicer.
1212             v := byte(0, mload(add(sig, 96)))
1213 
1214             // Alternative solution:
1215             // 'byte' is not working due to the Solidity parser, so lets
1216             // use the second best option, 'and'
1217             // v := and(mload(add(sig, 65)), 255)
1218         }
1219 
1220         // albeit non-transactional signatures are not specified by the YP, one would expect it
1221         // to match the YP range of [27, 28]
1222         //
1223         // geth uses [0, 1] and some clients have followed. This might change, see:
1224         //  https://github.com/ethereum/go-ethereum/issues/2053
1225         if (v < 27)
1226           v += 27;
1227 
1228         if (v != 27 && v != 28)
1229             return (false, 0);
1230 
1231         return safer_ecrecover(hash, v, r, s);
1232     }
1233 
1234     function safeMemoryCleaner() internal pure {
1235         assembly {
1236             let fmem := mload(0x40)
1237             codecopy(fmem, codesize, sub(msize, fmem))
1238         }
1239     }
1240 
1241 }
1242 // </ORACLIZE_API>
1243 contract MZBoss {
1244     uint256 constant internal magnitude = 1e18; // related to payoutsTo_, profitPershare_, profitPerSharePot_, profitPerShareNew_
1245     mapping(address => int256) internal payoutsTo_;
1246     uint256 public tokenSupply_ = 0; // total sold tokens 
1247     uint256 public profitPerShare_ = 0 ;
1248     uint256 public _totalProfitPot = 0;
1249     address constant internal _communityAddress = 0x43e8587aCcE957629C9FD2185dD700dcDdE1dD1E;
1250     /**
1251      * profit distribution from game pot
1252      */
1253     function potDistribution()
1254         public
1255         payable
1256     {
1257         require(msg.value > 0);
1258         uint256 _incomingEthereum = msg.value;
1259         if(tokenSupply_ > 0){
1260             
1261             // profit per share 
1262             uint256 profitPerSharePot_ = SafeMath.mul(_incomingEthereum, magnitude) / (tokenSupply_);
1263             
1264             // update profitPerShare_, adding profit from game pot
1265             profitPerShare_ = SafeMath.add(profitPerShare_, profitPerSharePot_);
1266             
1267         } else {
1268             // send to community
1269             payoutsTo_[_communityAddress] -=  (int256) (_incomingEthereum);
1270             
1271         }
1272         
1273         //update _totalProfitPot
1274         _totalProfitPot = SafeMath.add(_incomingEthereum, _totalProfitPot); 
1275     }
1276 }
1277 
1278 contract MZT1 is usingOraclize {
1279     /*=================================
1280     =            MODIFIERS            =
1281     =================================*/
1282     // only people with profits
1283     modifier onlyStronghands() {
1284         address _customerAddress = msg.sender;
1285         require(dividendsOf(_customerAddress) > 0);
1286         _;
1287     }
1288     
1289     // administrators can:
1290     // -> change the name of the contract
1291     // -> add address for extended function
1292     // they CANNOT:
1293     // -> take funds
1294     // -> disable withdrawals
1295     // -> kill the contract
1296     modifier onlyAdministrator(){
1297         address _customerAddress = msg.sender;
1298         require(administrators[_customerAddress] == true);
1299         _;
1300     }
1301     
1302     // There will be extended functions for the game
1303     // address of the extended contract only.
1304     modifier onlyExtendFunction(){ 
1305         address _customerAddress = msg.sender;
1306         require(extendFunctionAddress_[_customerAddress] == true);
1307         _;
1308     }
1309 
1310     // Check if the player has enough ETH to paint on a block, _input is block information (ID;color)
1311     modifier enoughToSetCheck(uint256[] _setBlockIDArray_, uint8[] _setColorArray_) { 
1312         uint256 _ethereum = msg.value;
1313         uint256 totalSetExpense_ = SafeMath.mul(_setBlockIDArray_.length, Cons.setCheckPriceInitial_);
1314 
1315         require((_setBlockIDArray_.length == _setColorArray_.length)&&(_ethereum >= totalSetExpense_)&&(totalSetExpense_ >= Cons.setCheckPriceInitial_));
1316         _;
1317     }
1318     
1319     // Check if the play has enough ETH to buy a block, _input is block ID
1320     modifier enoughToBuyCheck(uint256[] _buyBlockIDArray_){  
1321         uint256 _ethereum = msg.value;
1322         
1323         require((_ethereum >= buyPriceArray(_buyBlockIDArray_)) && (buyPriceArray(_buyBlockIDArray_) >= Cons.buyPriceInitial_));
1324         _;
1325     }
1326     
1327     // Check if the play has enough ETH to guess color
1328     modifier enoughToGuess(uint256 colorGuess_){  
1329         address _customerAddress = msg.sender;
1330         uint256 _incomingEthereum = SafeMath.add(msg.value, dividendsOf(_customerAddress));
1331         
1332         require((_incomingEthereum >= Cons.setCheckPriceInitial_)&&(colorGuess_ > 0) && (colorGuess_ < 6));
1333         _;
1334     }
1335     
1336 
1337     /*==============================
1338     =            EVENTS            =
1339     ==============================*/
1340     
1341     // fired whenever a player set color
1342     event onSetColor
1343     (
1344         address indexed playerAddress,
1345         uint256[] ColorSetID,
1346         uint8[] ColorSetColor,
1347         uint256 timeStamp
1348     );
1349     
1350     // fired whenever a player buy a block
1351     event onBuyBlock
1352     (
1353         address indexed playerAddress,
1354         uint256[] buyBlockID,
1355         uint256[] buyBlockPrice,
1356         uint256 timeStamp
1357     );
1358     
1359     // fired whenever a player guess color
1360     event onGuessColor
1361     (
1362         address indexed playerAddress,
1363         uint256 investETH,
1364         uint256 totalBet,
1365         uint8 color_,
1366         uint256 timeStamp
1367     );
1368     
1369     // fired whenever a player withdraw
1370     event onWithdraw
1371     (
1372         address indexed playerAddress,
1373         uint256 withdrawETH,
1374         uint256 timeStamp
1375     );
1376     
1377     // fired whenever the pot open
1378     event onPotOpen
1379     (
1380         uint256 totalDistribution,
1381         uint256 toLastAddress,
1382         address lastPlayerAddress
1383         
1384     );
1385     
1386     // fired the winner color
1387     event onWinnerColor
1388     (
1389         uint256 totalRed,
1390         uint256 totalYellow,
1391         uint256 totalBlue,
1392         uint256 totalBlack,
1393         uint256 totalGreen,
1394         uint256 winningPerShareRed,
1395         uint256 winningPerShareYellow,
1396         uint256 winningPerShareBlue,
1397         uint256 winningPerShareBlack,
1398         uint256 winningPerShareGreen
1399         
1400     );
1401     
1402     // fired whenever a player buy a block
1403     event onExtendFunction
1404     (
1405         address indexed playerAddress,
1406         uint256[] BlockID,
1407         uint8[] BlockColor,
1408         uint256[] buyBlockPrice,
1409         address[] BlockOwner
1410     );
1411     
1412     
1413     
1414     // Events used to track contract actions
1415     event LogOraclizeQuery(string description);
1416     event LogResultReceived(uint number, bytes Proof);
1417     event newRandomNumber_bytes(bytes);
1418     event newRandomNumber_uint(uint);
1419 
1420 
1421     
1422     /*=====================================
1423     =            CONFIGURABLES            =
1424     =====================================*/
1425     string public name = "Mizhen Game One";
1426     string public symbol = "MZONE";
1427     
1428     struct ConstantSETS{
1429         
1430     uint8 decimals;
1431     uint8 dividendFee_; // percentage of fee sent to MZBoss token holders 
1432     uint8 toCommunity_ ; // percentage of fee sent to community. 
1433     uint256 magnitude; // 
1434     uint256 winningLast_; // winning percentage of last painter
1435     uint256 ratioToPrevious_; // percentage of buying payment to the previous owner
1436     uint256 ratioToOwner_ ; // percentage of painting payment to the owner of the block
1437     uint256 oneDay_ ; // 86400 seconds
1438     uint256 setCheckPriceInitial_; // initial price of paiting color on a block
1439     uint256 buyPriceInitial_ ; // initial price of buying a block
1440     uint256 buyPriceAdd_; // price ratio of buying a block every time, 30% increase every time
1441     }
1442     
1443     ConstantSETS internal Cons = ConstantSETS(18,5,5,1e18,50,90,50,86400,1e14,5e15,130);
1444     
1445     uint256 public constant totalBlock_ = 1000000;
1446     uint256 public totalNumberColor_ = 14;
1447     
1448     uint256 public timeUpdate_; // time update every 24 hours, this will not be precise 24 hours. it will be updated when the first player come after 24 hours.
1449     uint256 public timeNearest_; // time of nearest paiting, to check if there is any paiting in last 24 hours
1450     uint256 public timeCutoff_;
1451     uint256 public totalVolumn_ = 0; // record total received ETH
1452     uint256 public setColorLastDay_; // number of people who set color in the last one day
1453 
1454     // Define variables
1455     uint public randomNumber; // number obtained from random.org
1456     mapping(bytes32 => bool) validIds; // used for validating Query IDs
1457     uint constant gasLimitForOraclize = 200000; // gas limit for Oraclize callback
1458     bool public sendRandomRequest = true;
1459     uint internal constant winningNumber = 2;
1460     uint256 public gasPriceCallBack = 5000000000 wei;
1461     uint256 public callbackGas = 800000;
1462     uint256 public timeRequest_;
1463     bytes32 internal queryIdRequest;
1464    /*================================
1465     =            DATASETS            =
1466     ================================*/
1467 
1468     mapping (address => mapping (uint256 => uint256)) public ethereumBalanceLedgerColor_; // betting ledger of different address on differet color
1469 
1470     // information of a block, paiting price, buying price, owner and color. ID is from 0 to 999999 
1471     mapping (uint256 => uint256) public blockSetPrice_; // price of paiting on a block
1472     mapping (uint256 => uint256) public blockBuyPrice_; // price of buying a block
1473     mapping (uint256 => address) public blockAddress_; // owner of block
1474     mapping (uint256 => uint8) public blockColor_; // color of block
1475     uint256[] public changedBlockID_; // ID of blocks that have been painted.
1476     
1477     // help to record player's dividends
1478     mapping (address => int256) public payoutsTo_;
1479 
1480     // information about color betting
1481     mapping (uint256 => uint256) public totalGuess; // total ETH  that bet a color, 1 red, 2 yellow, 3 blue, 4 black, 5 green
1482     mapping (uint256 => uint256) public winningPerShare_; // accumulated winning per share of ETH of different color, 1 red, 2 yellow, 3 blue, 4 black, 5 green
1483     mapping (uint256 => uint256) public winningPerShareNew_; // winning per share of each 24 hours
1484     mapping (uint256  => uint256) public totalColor_; // total count of a color, 1 red, 2 yellow, 3 blue, 4 black, 5 green
1485 
1486     uint256 public _totalProfitPot = 0; // total ETH in the pot
1487     address constant internal _communityAddress = 0x43e8587aCcE957629C9FD2185dD700dcDdE1dD1E;
1488     address constant internal _MZBossAddress = 0x16d29707a5F507f9252Ae5b7fc5E86399725C663;
1489     address public _lastAddress = 0x43e8587aCcE957629C9FD2185dD700dcDdE1dD1E; // address of last painter 
1490     
1491     bool public timeStart = true; // time start 
1492     
1493     // administrator list (see above on what they can do)
1494     mapping(address => bool) public administrators;
1495     // extend function address list
1496     mapping(address => bool) public extendFunctionAddress_; 
1497     mapping (uint256 => uint256) public priceAssume_;
1498     mapping(address => uint256) public ownBlockNumber_; // total number of block a play owns
1499 
1500     /*=======================================
1501     =            PUBLIC FUNCTIONS            =
1502     =======================================*/
1503     /*
1504     * -- APPLICATION ENTRY POINTS --  
1505     */
1506     constructor ()
1507         public
1508     
1509     {
1510         // add administrators here
1511         administrators[0x6dAd1d9D24674bC9199237F93beb6E25b55Ec763] = true;
1512         extendFunctionAddress_[0x3e9439D4AeC0756Cc6f10FFda053523e8A518DD3] = true; //
1513         
1514         // set Oraclize proof type
1515         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1516         oraclize_setProof(proofType_Ledger);
1517       
1518         // set gas price for Oraclize callback
1519         
1520         oraclize_setCustomGasPrice(gasPriceCallBack); // 5 Gwei
1521 
1522     }
1523     
1524     /**
1525      * 
1526      * random number
1527      */
1528     
1529     // Callback function for Oraclize once it retreives the data 
1530     function __callback(bytes32 queryId, string result, bytes proof) 
1531         public 
1532     {
1533         // only allow Oraclize to call this function
1534         require(msg.sender == oraclize_cbAddress());
1535       
1536         // validate the ID 
1537         require(validIds[queryId]);
1538         
1539         // log the new number that was obtained
1540         emit LogResultReceived(randomNumber, proof); 
1541       
1542         // reset mapping of this ID to false
1543         // this ensures the callback for a given queryID never called twice
1544         validIds[queryId] = false;
1545         
1546         if (oraclize_randomDS_proofVerify__returnCode(queryId, result, proof) != 0) {
1547 
1548         } else {
1549             // the proof verification has passed
1550             // for simplicity of use, let's also convert the random bytes to uint if we need
1551             uint maxRange = 3;
1552             randomNumber = uint(keccak256(bytes(result))) % maxRange; // this is an efficient way to get the uint out in the [0, maxRange] range
1553 
1554             emit newRandomNumber_uint(randomNumber); // this is the resulting random number (uint)
1555             
1556             sendRandomRequest = true;
1557             
1558             if (randomNumber == winningNumber){
1559                 
1560                 setColorLastDay_ = 0;
1561                 winnerCheck(now); 
1562             }
1563         }
1564     }
1565     
1566     /**
1567      * 
1568      * paint color on a block, _input formate (ID:color,ID:color,ID:color)
1569      * (blockID_: 0-999999) (setColor_: 1 red, 2 yellow, 3 blue, 4 black, 5 green, 6-14 see website, more comming)
1570      */ 
1571     function setColor(uint256[] _setBlockIDArray_, uint8[] _setColorArray_)   
1572         enoughToSetCheck(_setBlockIDArray_, _setColorArray_)
1573         public
1574         payable
1575     {
1576         
1577         uint256 _incomingEthereum = msg.value;
1578         
1579         // sent to MZBoss and community address
1580         uint256 _toMZBoss = SafeMath.mul(_incomingEthereum, Cons.dividendFee_) / 100; 
1581         uint256 _communityDistribution = SafeMath.mul(_incomingEthereum, Cons.toCommunity_) / 100;
1582         
1583         payoutsTo_[_MZBossAddress] = payoutsTo_[_MZBossAddress] + (int256)(_toMZBoss);
1584         payoutsTo_[_communityAddress] = payoutsTo_[_communityAddress] + (int256)(_communityDistribution);
1585         
1586         // record total ETH into the game
1587         totalVolumn_ = SafeMath.add(totalVolumn_, _incomingEthereum);
1588         
1589         
1590         // Check if it is time to open the pot, if it is, go to check winner and distribute pot
1591         if (SafeMath.sub(now, timeUpdate_) > Cons.oneDay_){
1592             if(timeCutoff_ == 0) timeCutoff_ = now;
1593             
1594             if((now - timeRequest_) > Cons.oneDay_){
1595                 sendRandomRequest = true;
1596                 validIds[queryIdRequest] = false;
1597                 randomNumberRequest(now);
1598             }else{
1599                 randomNumberRequest(now);
1600             }
1601         }else{
1602             // track the time of the latest action, used for potopen
1603             timeNearest_ = now;
1604         } 
1605 
1606         // update information based on the input
1607         blockSetUpdate(_setBlockIDArray_, _setColorArray_);
1608         
1609         _lastAddress = msg.sender;
1610         
1611         // keep track number of pepple paint in the day, so people know the percentage that will be distributed when pot opens
1612         setColorLastDay_ = SafeMath.add(setColorLastDay_, 1);
1613   
1614     }
1615     
1616     /**
1617      * 
1618      * function of buying a block, _input formate (ID,ID,ID)
1619      */ 
1620     function buyBlock(uint[] _buyBlockIDArray_) 
1621         enoughToBuyCheck(_buyBlockIDArray_)
1622         public
1623         payable
1624     {
1625         uint256 _incomingEthereum = msg.value;
1626         
1627         // record total ETH into the game
1628         totalVolumn_ = SafeMath.add(totalVolumn_, _incomingEthereum);
1629         
1630         // sent to MZBoss and community address
1631         uint256 _toMZBoss = SafeMath.mul(_incomingEthereum, Cons.dividendFee_) / 100; 
1632         uint256 _communityDistribution = SafeMath.mul(_incomingEthereum, Cons.toCommunity_) / 100;
1633         
1634         payoutsTo_[_MZBossAddress] = payoutsTo_[_MZBossAddress] + (int256)(_toMZBoss);
1635         payoutsTo_[_communityAddress] = payoutsTo_[_communityAddress] + (int256)(_communityDistribution);
1636         
1637         // Check if it is time to open the pot, if it is, go to check winner and distribute pot
1638         if (SafeMath.sub(now, timeUpdate_) > Cons.oneDay_){
1639             if(timeCutoff_ == 0) timeCutoff_ = now;
1640             
1641             if((now - timeRequest_) > Cons.oneDay_){
1642                 sendRandomRequest = true;
1643                 validIds[queryIdRequest] = false;
1644                 randomNumberRequest(now);
1645             }else{
1646                 randomNumberRequest(now);
1647             }
1648         }else{
1649             // track the time of the latest action, used for potopen
1650             timeNearest_ = now;
1651         } 
1652         
1653         // update block information based on purchase input
1654         blockBuyUpdate(_buyBlockIDArray_);
1655         
1656     }
1657     
1658     /**
1659      * player can bet on color
1660      */
1661     function guessColor(uint8 colorGuess_) 
1662         enoughToGuess(colorGuess_)
1663         public
1664         payable
1665     {
1666         // setup data
1667         address _customerAddress = msg.sender;
1668         uint256 _incomingEthereum = SafeMath.add(msg.value, dividendsOf(_customerAddress));
1669         
1670         // record total ETH into the game
1671         totalVolumn_ = SafeMath.add(totalVolumn_, msg.value);
1672         
1673         // go to guess color core function
1674         guessColorCore(_incomingEthereum, colorGuess_); 
1675         
1676         // Check if it is time to open the pot, if it is, go to check winner and distribute pot
1677         if (SafeMath.sub(now, timeUpdate_) > Cons.oneDay_){
1678             if(timeCutoff_ == 0) timeCutoff_ = now;
1679             
1680             if((now - timeRequest_) > Cons.oneDay_){
1681                 sendRandomRequest = true;
1682                 validIds[queryIdRequest] = false;
1683                 randomNumberRequest(now);
1684             }else{
1685                 randomNumberRequest(now);
1686             }
1687         }else{
1688             // track the time of the latest action, used for potopen
1689             timeNearest_ = now;
1690         } 
1691            
1692         // payoutsTo_ is int256, so convert _incomingEthereum to int256
1693         payoutsTo_[_customerAddress] = payoutsTo_[_customerAddress] + (int256) (dividendsOf(_customerAddress)); 
1694         
1695         emit onGuessColor(_customerAddress, msg.value, _incomingEthereum, colorGuess_, now);
1696     }
1697     
1698     
1699     /**
1700      * Withdraws all of the callers earnings.
1701      */
1702     function withdraw()
1703         onlyStronghands()
1704         public
1705     {
1706         // setup data
1707         address _customerAddress = msg.sender;
1708         
1709         // get the dividends of the player 
1710         uint256 _dividends = dividendsOf(_customerAddress);
1711  
1712         // update dividend tracker, in order to calculate with payoutsTo which is int256, _dividends need to be casted to int256 first
1713         payoutsTo_[_customerAddress] = payoutsTo_[_customerAddress] + (int256)(_dividends);
1714         
1715         // send eth
1716         _customerAddress.transfer(_dividends);
1717         
1718         emit onWithdraw(_customerAddress, _dividends, now);
1719         
1720     }
1721 
1722 
1723     
1724     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
1725     /**
1726      * In case we need to replace ourselves.
1727      */
1728     function setAdministrator(address _identifier, bool _status)
1729         onlyAdministrator()
1730         public
1731     {
1732         administrators[_identifier] = _status;
1733     }
1734     
1735     
1736     /**
1737      * We are going to extend functions of the game with more smart contract
1738      */
1739     function setExtendFunctionAddress(address _identifier, bool _status)
1740         onlyAdministrator()
1741         public
1742     {
1743         extendFunctionAddress_[_identifier] = _status;
1744     }
1745     
1746     /**
1747      * If we want to rebrand, we can.
1748      */
1749     function setName(string _name)
1750         onlyAdministrator()
1751         public
1752     {
1753         name = _name;
1754     }
1755     
1756     /**
1757      * If we want to change symbol, we can.
1758      */
1759     function setSymbol(string _symbol)
1760         onlyAdministrator()
1761         public
1762     {
1763         symbol = _symbol;
1764     }
1765     
1766     /**
1767      * After the game is online, the administrator can set the start time only once.
1768      */
1769     function setTime()
1770         onlyAdministrator()
1771         public
1772     {
1773         if (timeStart){
1774             timeUpdate_ = now; 
1775             timeStart = false;
1776         }else{
1777             timeStart = false;
1778         }
1779     }
1780     
1781     /**
1782      * If we want to change totalNumberColor and totalBlock, we can.
1783      */
1784     function setColorBlock(uint256 _Color)
1785         onlyAdministrator()
1786         public
1787     {
1788         totalNumberColor_ = _Color;
1789 
1790     }
1791     
1792     /**
1793      * set gas price for random number
1794      */
1795     function setGasFee(uint256 callbackGas_, uint256 gasPriceCallBack_)
1796         onlyAdministrator()
1797         public
1798     {
1799         callbackGas = callbackGas_;
1800         gasPriceCallBack = gasPriceCallBack_;
1801 
1802     }
1803     
1804     /*----------  HELPERS AND CALCULATORS  ----------*/
1805     
1806     /**
1807      * Method to view the current price for painting
1808      * 
1809      */
1810     function blockSetPrice(uint256 blockID_) 
1811         public
1812         view
1813         returns(uint256)
1814     {
1815         uint256 blockPrice_ = blockSetPrice_[blockID_];
1816         
1817         if (blockPrice_ == 0){
1818             blockPrice_ = Cons.setCheckPriceInitial_;
1819         }
1820         
1821         return blockPrice_;
1822     }
1823     
1824     /**
1825      * Method to view the current price for buying
1826      * 
1827      */
1828     function blockBuyPrice(uint256 blockID_) 
1829         public
1830         view
1831         returns(uint256)
1832     {
1833         uint256 blockPrice_ = blockBuyPrice_[blockID_];
1834         
1835         if (blockPrice_ == 0){
1836             blockPrice_ = Cons.buyPriceInitial_;
1837         }
1838         return blockPrice_;
1839     }
1840     
1841     /**
1842      * Method to view the current price for buying
1843      * 
1844      */
1845     function blockColor(uint256 blockID_) 
1846         public
1847         view
1848         returns(uint256)
1849     {
1850         return blockColor_[blockID_];
1851     }
1852     
1853     /**
1854      * Retrieve the dividend balance of any single address.
1855      */
1856     function dividendsOf(address _customerAddress)
1857         public 
1858         view
1859         returns(uint256)
1860     {
1861         // update profit of each color
1862         uint256 profitRed_ = SafeMath.mul(ethereumBalanceLedgerColor_[_customerAddress][1], winningPerShare_[1]) / Cons.magnitude;
1863         uint256 profitYellow_ = SafeMath.mul(ethereumBalanceLedgerColor_[_customerAddress][2], winningPerShare_[2]) / Cons.magnitude;
1864         uint256 profitBlue_ = SafeMath.mul(ethereumBalanceLedgerColor_[_customerAddress][3], winningPerShare_[3]) / Cons.magnitude;
1865         uint256 profitBlack_ = SafeMath.mul(ethereumBalanceLedgerColor_[_customerAddress][4], winningPerShare_[4]) / Cons.magnitude;
1866         uint256 profitGreen_ = SafeMath.mul(ethereumBalanceLedgerColor_[_customerAddress][5], winningPerShare_[5]) / Cons.magnitude;
1867         uint256 totalProfit_ = SafeMath.add(SafeMath.add(SafeMath.add(SafeMath.add(profitRed_, profitYellow_), profitBlue_), profitBlack_), profitGreen_);
1868 
1869         if ((int256(totalProfit_) - payoutsTo_[_customerAddress]) > 0 )
1870         
1871            return uint256(int256(totalProfit_) - payoutsTo_[_customerAddress]);     
1872         else 
1873         
1874            return 0;
1875     }
1876     
1877     /**
1878      * Retrieve the payoutsTo_ of any single address.
1879      */
1880     function payoutsTo(address _customerAddress)
1881         public
1882         view
1883         returns(int256)
1884     {
1885         return payoutsTo_[_customerAddress];
1886     }
1887     
1888     /**
1889      * total amount of ETH on different color bet
1890      */
1891     function colorTotalGuess(uint256 colorGuess_)
1892         public
1893         view
1894         returns(uint256)
1895     {
1896         return totalGuess[colorGuess_];
1897     }
1898     
1899     /**
1900      * player's amount of ETH on different color bet
1901      */
1902     function playerColorGuess(address _customerAddress, uint256 colorGuess_)
1903         public
1904         view
1905         returns(uint256)
1906     {
1907         return ethereumBalanceLedgerColor_[_customerAddress][colorGuess_];
1908     }
1909     
1910     /**
1911      * total number of blocks for each color
1912      */
1913     function totalColorNumber(uint256 colorID_)
1914         public
1915         view
1916         returns(uint256)
1917     {
1918         return totalColor_[colorID_];
1919     }
1920     
1921     /**
1922      * total blocks owned by a player
1923      */
1924     function ownBlockNumber(address _customerAddress)
1925         public
1926         view
1927         returns(uint256)
1928     {
1929         return ownBlockNumber_[_customerAddress];
1930     }
1931     
1932     /**
1933      * display winningPerShareNew_
1934      */
1935     function winningPerShareNew()
1936         public
1937         view
1938         returns(uint256)
1939     {
1940         uint256 value_ = 0;
1941         for (uint256 i = 1; i < 6; i++) {
1942             if(winningPerShareNew_[i] > 0)
1943             value_ = winningPerShareNew_[i];
1944             
1945         }
1946             
1947         return value_;
1948     }
1949     
1950     /**
1951      * painted block
1952      */
1953         
1954     function setColorUpdate(uint256 loop_)
1955         public
1956         view
1957         returns(uint256[], uint8[])
1958     {
1959             uint256 n =  (changedBlockID_.length)/100000;
1960             uint256 j = loop_ - 1;
1961         
1962             uint256 start_ = j * 100000;
1963             uint256 k = start_ + 100000;
1964             
1965             uint256 length_ = changedBlockID_.length - (n * 100000);
1966             if ((n > 0)&&(j < n)){
1967                 length_ = 100000;
1968             }
1969             uint8[] memory blockColorArray_ = new uint8[](length_);
1970             uint256[] memory changedBlockIDArray_ = new uint256[](length_);
1971             for(uint256 i = start_; (i < changedBlockID_.length) && (i < k); i++) { 
1972                 
1973                 changedBlockIDArray_[i-start_] = changedBlockID_[i];
1974                 blockColorArray_[i-start_] = blockColor_[changedBlockID_[i]];
1975             }
1976             return (changedBlockIDArray_, blockColorArray_);
1977         
1978     }
1979     /**
1980      * number of painted blocks 
1981      */
1982     function paintedBlockNumber()
1983         public
1984         view
1985         returns(uint256)
1986     {
1987         return changedBlockID_.length;
1988     }
1989     
1990     
1991     /*==========================================
1992     =            INTERNAL FUNCTIONS            =
1993     ==========================================*/
1994 
1995     /**
1996      * Core function of bet on a color
1997      */
1998      function guessColorCore(uint256 _incomingEthereum, uint256 colorGuess_)
1999         private
2000     {
2001 
2002         address _customerAddress = msg.sender;
2003         
2004         // sent to MZBoss and community address
2005         uint256 _toMZBoss = SafeMath.mul(_incomingEthereum, Cons.dividendFee_) / 100; 
2006         uint256 _communityDistribution = SafeMath.mul(_incomingEthereum, Cons.toCommunity_) / 100;
2007         
2008         payoutsTo_[_MZBossAddress] = payoutsTo_[_MZBossAddress] + (int256)(_toMZBoss);
2009         payoutsTo_[_communityAddress] = payoutsTo_[_communityAddress] + (int256)(_communityDistribution);
2010  
2011         // after tax
2012         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, SafeMath.add(_communityDistribution, _toMZBoss));
2013 
2014         // add the payment to the total ETH that bet on the color
2015         totalGuess[colorGuess_] = SafeMath.add(totalGuess[colorGuess_], _taxedEthereum);
2016         
2017         // update the player's ledger
2018         ethereumBalanceLedgerColor_[_customerAddress][colorGuess_] = SafeMath.add(ethereumBalanceLedgerColor_[_customerAddress][colorGuess_], _taxedEthereum);
2019  
2020         // update total pot
2021         _totalProfitPot = SafeMath.add(_totalProfitPot, _taxedEthereum);
2022         
2023         // calculate the current total winningPerShare_ of the color and pre deducte them from player's account
2024         uint256 profitExtra_ = SafeMath.mul(ethereumBalanceLedgerColor_[_customerAddress][colorGuess_], winningPerShare_[colorGuess_]) / Cons.magnitude;
2025         
2026         // update player's payoutsTo_
2027         payoutsTo_[_customerAddress] = payoutsTo_[_customerAddress] + (int256)(profitExtra_);
2028     }
2029     
2030     /**
2031      * random number check
2032      */
2033     function randomNumberRequest(uint256 timeNew_)
2034         internal
2035     {
2036         
2037         // send query // require ETH to cover callback gas costs
2038         uint N = 1; // number of random bytes we want the datasource to return
2039         uint delay = 0; // number of seconds to wait before the execution takes place
2040 
2041         if((sendRandomRequest == true) && (_totalProfitPot > SafeMath.mul(callbackGas, gasPriceCallBack))){ 
2042 
2043             queryIdRequest = oraclize_newRandomDSQuery(delay, N, callbackGas); // this function internally generates the correct oraclize_query and returns its queryId
2044         
2045             // log that query was sent
2046             emit LogOraclizeQuery("Oraclize query was sent, standing by for the answer..");
2047           
2048             // add query ID to mapping
2049             validIds[queryIdRequest] = true;
2050             sendRandomRequest = false;
2051             timeRequest_ = timeNew_;
2052             _totalProfitPot = SafeMath.sub(_totalProfitPot, SafeMath.mul(callbackGas, gasPriceCallBack));
2053         }
2054            
2055     }
2056     
2057     /**
2058      * check the winner color and distribute pot
2059      */
2060     function winnerCheck(uint256 timeNew_)
2061         private
2062     {
2063 
2064         timeUpdate_ = timeNew_;
2065         
2066         // check there is any action in last 24 hours, which will activate the distribution of 75% of the pot
2067         if (SafeMath.sub(timeCutoff_, timeNearest_) > Cons.oneDay_){
2068             
2069             uint256 _profitToDistributeTotal = SafeMath.mul(_totalProfitPot, 75)/100;
2070 
2071         }else{
2072             // otherwise just distribution 10%
2073             _profitToDistributeTotal = SafeMath.mul(_totalProfitPot, 10)/100;
2074         }
2075         
2076         // udpate pot
2077         _totalProfitPot = SafeMath.sub(_totalProfitPot, _profitToDistributeTotal);
2078         timeCutoff_ = 0;
2079         timeNearest_ = timeNew_; 
2080         // open the pot
2081         potOpen(_profitToDistributeTotal);
2082     }
2083     
2084     
2085     /**
2086      * open pot and check color every 24 hours, distribute profit
2087      */
2088     function potOpen(uint256 _profitToDistribute) 
2089         private
2090     {
2091    
2092         // sent to MZBoss and community address
2093         uint256 _toMZBoss = SafeMath.mul(_profitToDistribute, Cons.dividendFee_) / 100; 
2094         uint256 _communityDistribution = SafeMath.mul(_profitToDistribute, Cons.toCommunity_) / 100;
2095         
2096         payoutsTo_[_MZBossAddress] = payoutsTo_[_MZBossAddress] + (int256)(_toMZBoss);
2097         payoutsTo_[_communityAddress] = payoutsTo_[_communityAddress] + (int256)(_communityDistribution);
2098         
2099         sendPotProfit((uint256)(payoutsTo_[_MZBossAddress]));
2100         _communityAddress.transfer((uint256)(payoutsTo_[_communityAddress]));
2101         
2102         payoutsTo_[_MZBossAddress] = 0;
2103         payoutsTo_[_communityAddress] = 0;
2104         
2105         // after tax
2106         uint256 _taxedEthereum = SafeMath.sub(_profitToDistribute, SafeMath.add(_communityDistribution, _toMZBoss));
2107         
2108         // profit go to the last painter    
2109         uint256 _distributionToLast = SafeMath.mul(_taxedEthereum, Cons.winningLast_)/100;
2110         
2111         // update the payoutsTo_ of the last painter    
2112         payoutsTo_[_lastAddress] = payoutsTo_[_lastAddress] - (int256)(_distributionToLast);
2113         
2114         // the rest goes to the color winner    
2115         uint256 _profitToColorBet = SafeMath.sub(_taxedEthereum, _distributionToLast);
2116 
2117         // activate result and distribution of color betting
2118         winnerColor(_profitToColorBet);
2119         
2120         emit onPotOpen(_profitToDistribute, _distributionToLast, _lastAddress);
2121     }
2122     
2123     /**
2124      * update block painting information
2125      */
2126     function blockSetUpdate(uint256[] _blockIDArray_, uint8[] _setColorArray_)  
2127         private
2128     {
2129         
2130         address _customerAddress = msg.sender;
2131         uint256 timeNew_ = now;
2132         
2133         for (uint i = 0; i < _blockIDArray_.length; i++) { 
2134             
2135             uint256 blockID_ = _blockIDArray_[i];
2136             uint8 setColor_ = _setColorArray_[i]; 
2137             
2138             if ((blockID_ >= 0) && (blockID_ < totalBlock_)&&(setColor_ > 0) && (setColor_ < totalNumberColor_+1)){
2139                 
2140             // update block price
2141             if (blockSetPrice_[blockID_] == 0){
2142     
2143                 blockSetPrice_[blockID_] = Cons.setCheckPriceInitial_;
2144                 changedBlockID_.push(blockID_);
2145                 
2146             }else{
2147                 uint8 _originalColor = blockColor_[blockID_];
2148                 // update color count of the replaced color
2149                 totalColor_[_originalColor] = totalColor_[_originalColor] - 1;
2150             }
2151         
2152             // update color count of the new color
2153             totalColor_[setColor_] = totalColor_[setColor_] + 1;
2154         
2155             // calculate incomming after tax
2156             uint256 blockExpense = SafeMath.mul(blockSetPrice_[blockID_], (100 - Cons.dividendFee_ - Cons.toCommunity_))/100; 
2157         
2158             // update block color and price
2159             blockColor_[blockID_] = setColor_;
2160 
2161             // get the owner address of the block
2162             address owner_ = blockAddress_[blockID_];
2163 
2164             // if there is no owner, the money goes to the pot
2165             if (owner_ == 0x0) {
2166             
2167                 _totalProfitPot = SafeMath.add(_totalProfitPot, blockExpense);
2168             
2169             }else{
2170 
2171                 // otherwise 50% goes to the owner
2172                 uint256 toOwner_ = SafeMath.mul(blockExpense, Cons.ratioToOwner_)/100;
2173            
2174                 // update owner's payoutsTo_ 
2175                 payoutsTo_[owner_] = payoutsTo_[owner_] - (int256)(toOwner_); 
2176            
2177                 // half of the rest goes to the pot (25%)
2178                 uint256 _toPot = SafeMath.sub(blockExpense, toOwner_)/2;
2179                 _totalProfitPot = SafeMath.add(_totalProfitPot, _toPot);
2180                 
2181                 // the other half of the rest sent to MZBoss and community address
2182                 uint256 _toMZBoss = SafeMath.mul(_toPot, 13) / 25; 
2183                 uint256 _communityDistribution = SafeMath.mul(_toPot, 12) / 25;
2184                 
2185                 payoutsTo_[_communityAddress] = payoutsTo_[_communityAddress] + (int256)(_communityDistribution);
2186                 payoutsTo_[_MZBossAddress] = payoutsTo_[_MZBossAddress] + (int256)(_toMZBoss);
2187             }  
2188             
2189             }
2190 
2191         }   
2192 
2193         emit onSetColor(_customerAddress, _blockIDArray_, _setColorArray_, timeNew_);
2194     }
2195     
2196     /**
2197      * update block purchase information
2198      */
2199     function blockBuyUpdate(uint256[] _blockIDArray_)  
2200         private
2201     {
2202         address _customerAddress = msg.sender;
2203         uint256[] memory buyBlockPrice_ = new uint256[](_blockIDArray_.length);
2204         
2205         for (uint i = 0; i < _blockIDArray_.length; i++) { 
2206             
2207             uint256 blockID_ = _blockIDArray_[i]; 
2208         
2209             if ((blockID_ >= 0) && (blockID_ < totalBlock_)){
2210                 
2211                 uint256 priceNow_ = blockBuyPrice_[blockID_];
2212             
2213                 // update block price
2214                 if (blockAddress_[blockID_] == 0x0){
2215                 
2216                     priceNow_ = Cons.buyPriceInitial_;
2217                     
2218                     uint256 afterTax_ = SafeMath.mul(priceNow_, (100 - Cons.dividendFee_ - Cons.toCommunity_))/100;
2219                 
2220                     _totalProfitPot = SafeMath.add(_totalProfitPot, afterTax_);
2221                 
2222                 }else{
2223             
2224                     // get address of previous owner
2225                     address previous_ = blockAddress_[blockID_];
2226                     afterTax_ = SafeMath.mul(priceNow_, (100 - Cons.dividendFee_ - Cons.toCommunity_))/100;
2227             
2228                     // 90% to previous owner
2229                     uint256 toPrevious_ = SafeMath.mul(afterTax_, Cons.ratioToPrevious_)/100;
2230                     
2231                     // update payoutsTo_of previous owner
2232                     payoutsTo_[previous_] = payoutsTo_[previous_] - (int256)(toPrevious_); 
2233                     
2234                     // the rest goes to pot
2235                     _totalProfitPot = SafeMath.add(_totalProfitPot, SafeMath.sub(afterTax_, toPrevious_));
2236                     
2237                     // update number of blocks owned by previous owner
2238                     ownBlockNumber_[previous_] = SafeMath.sub(ownBlockNumber_[previous_], 1);
2239                 }
2240                 
2241                 // update block purchase price
2242                 blockBuyPrice_[blockID_] = SafeMath.mul(priceNow_, Cons.buyPriceAdd_)/100;
2243                 
2244                 buyBlockPrice_[i] = blockBuyPrice_[blockID_];
2245                 
2246                 //owner of the block
2247                 blockAddress_[blockID_] = _customerAddress;
2248                 
2249                 // number of blocks owned by the new owner
2250                 ownBlockNumber_[_customerAddress] = SafeMath.add(ownBlockNumber_[_customerAddress], 1);
2251             
2252             }
2253         
2254         } 
2255 
2256         // track the time 
2257         uint256 timeNew_ = now;
2258         
2259         emit onBuyBlock(_customerAddress, _blockIDArray_, buyBlockPrice_, timeNew_);
2260  
2261     }
2262     
2263     /** send eth to MZBoss
2264 	 *
2265 	 */
2266 	function sendPotProfit(uint256 valueToSend)
2267 	    private
2268 	{
2269 		
2270 		MZBoss m = MZBoss(_MZBossAddress);
2271 		m.potDistribution.value(valueToSend)();
2272 	}
2273 	
2274     /**
2275      * convert buy color input array and check purchase expense is enough or not
2276      */
2277     
2278     function buyPriceArray(uint256[] _buyBlockIDArray_) 
2279         private
2280         returns (uint256)
2281     {
2282         
2283         uint256 totalBuyExpense_ = 0;
2284         
2285         for (uint i = 0; i < _buyBlockIDArray_.length; i++) {
2286 
2287             uint256 ID_ = _buyBlockIDArray_[i];
2288             
2289             if ((ID_ >= 0) && (ID_ < totalBlock_)){
2290                 
2291                 priceAssume_[ID_] = blockBuyPrice(ID_);
2292             
2293             }
2294         }
2295         for (i = 0; i < _buyBlockIDArray_.length; i++) {
2296 
2297             ID_ = _buyBlockIDArray_[i];
2298             
2299             if ((ID_ >= 0) && (ID_ < totalBlock_)){
2300                 
2301                totalBuyExpense_ = SafeMath.add(totalBuyExpense_, priceAssume_[ID_]);
2302 
2303                priceAssume_[ID_] = SafeMath.mul(priceAssume_[ID_], Cons.buyPriceAdd_)/100;
2304 
2305             }
2306         }
2307         return totalBuyExpense_;
2308         
2309     }
2310     
2311     
2312     /**
2313      * reserve extended function 
2314      */ 
2315     function extendFunctionUpdate(uint256[] _blockIDArray_, address[] _blockAddressArray_, uint256[] _blockBuyPriceArray_, uint8[] _blockColorArray_) 
2316         onlyExtendFunction()
2317         public
2318     {
2319         address _customerAddress = msg.sender;
2320         
2321         // update information with incomming array
2322         for (uint i = 0; i < _blockIDArray_.length; i++) {
2323             uint256 blockIDUpdate_ = _blockIDArray_[i];
2324             uint8 blockColorUpdate_ = _blockColorArray_[i];
2325             
2326             if ((blockIDUpdate_ >= 0) && (blockIDUpdate_ < totalBlock_) && (blockColorUpdate_ > 0) && (blockColorUpdate_ < totalNumberColor_+1)) {
2327                 
2328                 if (blockSetPrice_[blockIDUpdate_] == 0){
2329                     
2330                     changedBlockID_.push(blockIDUpdate_);
2331                     blockSetPrice_[blockIDUpdate_] = Cons.setCheckPriceInitial_;
2332                 
2333                 }
2334                 
2335                 blockBuyPrice_[blockIDUpdate_] = _blockBuyPriceArray_[i];
2336                 
2337                 // update color count of the replaced color
2338                 if(blockColor_[blockIDUpdate_] > 0){
2339                            
2340                     totalColor_[blockColor_[blockIDUpdate_]] = totalColor_[blockColor_[blockIDUpdate_]] - 1;
2341                 }      
2342                 
2343                     blockColor_[blockIDUpdate_] = _blockColorArray_[i];
2344                 
2345                     // update color count of the new color
2346                     totalColor_[_blockColorArray_[i]] = totalColor_[_blockColorArray_[i]] + 1;
2347                 
2348                 if(blockAddress_[blockIDUpdate_] != 0x0){
2349                     
2350                     ownBlockNumber_[blockAddress_[blockIDUpdate_]] = ownBlockNumber_[blockAddress_[blockIDUpdate_]] - 1;
2351                 }
2352                 
2353                 blockAddress_[blockIDUpdate_] = _blockAddressArray_[i];
2354                 
2355                 if(blockAddress_[blockIDUpdate_] != 0x0){
2356                     
2357                     ownBlockNumber_[blockAddress_[blockIDUpdate_]] = ownBlockNumber_[blockAddress_[blockIDUpdate_]] + 1;
2358                 }
2359                 
2360 
2361             }
2362             
2363         }
2364 
2365         emit onExtendFunction(
2366             _customerAddress,
2367             _blockIDArray_,
2368             _blockColorArray_,
2369             _blockBuyPriceArray_,
2370             _blockAddressArray_
2371         );
2372     
2373     }
2374     
2375 
2376     
2377     /**
2378      * check maximum color and calculate winning profit 
2379      */
2380     function winnerColor(uint256 _distributionAmount) // 1 red, 2 yellow, 3 blue, 4 black, 5 green
2381         private
2382 
2383     {
2384         uint256 Maximum = totalColor_[1];
2385         
2386         // find the number of blocks of the maximum color
2387         for (uint i = 2; i < 6; i++) {
2388             
2389             if (Maximum < totalColor_[i]) {
2390                 
2391                 Maximum = totalColor_[i];
2392                 
2393             }
2394             
2395         }
2396         
2397         if (Maximum != 0){
2398 
2399             uint256 totalMaxColor_ = 0;
2400             uint256[6] memory MaximumSign;
2401             // find how many colors are the winner
2402             for ( i = 1; i < 6; i++) {
2403               
2404                 if (Maximum == totalColor_[i]) {
2405                     
2406                     MaximumSign[i] = 1;
2407                 }else{
2408                   
2409                     MaximumSign[i] = 0;  
2410                 }
2411                 // calculate total color winners
2412                 totalMaxColor_ += MaximumSign[i];
2413                 
2414             } 
2415         
2416             
2417             // evenly distribute the profit for color winner to each winning color        
2418             if (totalMaxColor_ > 0){
2419                 uint256 _distributionAmountEach = _distributionAmount/totalMaxColor_;
2420             }
2421         
2422             // calculate winning ETH per share of players in each color        
2423             for (i = 1; i < 6; i++) {
2424               
2425                 if (totalGuess[i] > 0){
2426                 
2427                     uint256 winningProfitPerShare_ = SafeMath.mul(_distributionAmountEach, Cons.magnitude) / totalGuess[i];
2428                     winningPerShareNew_[i] = SafeMath.mul(winningProfitPerShare_, MaximumSign[i]);
2429                     winningPerShare_[i] = SafeMath.add(winningPerShare_[i], winningPerShareNew_[i]);
2430               
2431                 }
2432             }
2433         }
2434         
2435         emit onWinnerColor(
2436             
2437             totalColor_[1],
2438             totalColor_[2],
2439             totalColor_[3],
2440             totalColor_[4],
2441             totalColor_[5],
2442             winningPerShareNew_[1],
2443             winningPerShareNew_[2],
2444             winningPerShareNew_[3],
2445             winningPerShareNew_[4],
2446             winningPerShareNew_[5]
2447             
2448             );
2449         
2450     }   
2451     
2452 }
2453 
2454 /**
2455  * @title SafeMath
2456  * @dev Math operations with safety checks that throw on error
2457  */
2458 library SafeMath {
2459 
2460     /**
2461     * @dev Multiplies two numbers, throws on overflow.
2462     */
2463     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2464         if (a == 0) {
2465             return 0;
2466         }
2467         uint256 c = a * b;
2468         assert(c / a == b);
2469         return c;
2470     }
2471 
2472     /**
2473     * @dev Integer division of two numbers, truncating the quotient.
2474     */
2475     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2476         // assert(b > 0); // Solidity automatically throws when dividing by 0
2477         uint256 c = a / b;
2478         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
2479         return c;
2480     }
2481 
2482     /**
2483     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2484     */
2485     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2486         assert(b <= a);
2487         return a - b;
2488     }
2489 
2490     /**
2491     * @dev Adds two numbers, throws on overflow.
2492     */
2493     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2494         uint256 c = a + b;
2495         assert(c >= a);
2496         return c;
2497     }
2498 }