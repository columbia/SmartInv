1 //etherate v.2.0
2 //EtheRate – is the first in the world, an honest pool of crypto-rates, based on absolute randomness!
3 //Official WEB-client: etherate.org
4 //Talk to us on Discord.gg/nEnApvF
5 /*
6 ╔═══╗╔════╗╔╗─╔╗╔═══╗╔═══╗╔═══╗╔════╗╔═══╗
7 ║╔══╝║╔╗╔╗║║║─║║║╔══╝║╔═╗║║╔═╗║║╔╗╔╗║║╔══╝
8 ║╚══╗╚╝║║╚╝║╚═╝║║╚══╗║╚═╝║║║─║║╚╝║║╚╝║╚══╗
9 ║╔══╝──║║──║╔═╗║║╔══╝║╔╗╔╝║╚═╝║──║║──║╔══╝
10 ║╚══╗──║║──║║─║║║╚══╗║║║╚╗║╔═╗║──║║──║╚══╗
11 ╚═══╝──╚╝──╚╝─╚╝╚═══╝╚╝╚═╝╚╝─╚╝──╚╝──╚═══╝
12 */
13 //69 84 72 69 82 65 84 69
14 
15 pragma solidity ^0.4.25;
16 
17 // <ORACLIZE_API>
18 /*
19 Copyright (c) 2015-2016 Oraclize SRL
20 Copyright (c) 2016 Oraclize LTD
21 Permission is hereby granted, free of charge, to any person obtaining a copy
22 of this software and associated documentation files (the "Software"), to deal
23 in the Software without restriction, including without limitation the rights
24 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
25 copies of the Software, and to permit persons to whom the Software is
26 furnished to do so, subject to the following conditions:
27 The above copyright notice and this permission notice shall be included in
28 all copies or substantial portions of the Software.
29 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
30 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
31 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
32 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
33 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
34 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
35 THE SOFTWARE.
36 */
37 
38 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
39 
40 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
41 
42 contract OraclizeI {
43     address public cbAddress;
44     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
45     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
46     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
47     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
48     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
49     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
50     function getPrice(string _datasource) public returns (uint _dsprice);
51     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
52     function setProofType(byte _proofType) external;
53     function setCustomGasPrice(uint _gasPrice) external;
54     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
55 }
56 
57 contract OraclizeAddrResolverI {
58     function getAddress() public returns (address _addr);
59 }
60 
61 /*
62 Begin solidity-cborutils
63 https://github.com/smartcontractkit/solidity-cborutils
64 MIT License
65 Copyright (c) 2018 SmartContract ChainLink, Ltd.
66 Permission is hereby granted, free of charge, to any person obtaining a copy
67 of this software and associated documentation files (the "Software"), to deal
68 in the Software without restriction, including without limitation the rights
69 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
70 copies of the Software, and to permit persons to whom the Software is
71 furnished to do so, subject to the following conditions:
72 The above copyright notice and this permission notice shall be included in all
73 copies or substantial portions of the Software.
74 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
75 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
76 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
77 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
78 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
79 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
80 SOFTWARE.
81  */
82 
83 library Buffer {
84     struct buffer {
85         bytes buf;
86         uint capacity;
87     }
88 
89     function init(buffer memory buf, uint _capacity) internal pure {
90         uint capacity = _capacity;
91         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
92         // Allocate space for the buffer data
93         buf.capacity = capacity;
94         assembly {
95             let ptr := mload(0x40)
96             mstore(buf, ptr)
97             mstore(ptr, 0)
98             mstore(0x40, add(ptr, capacity))
99         }
100     }
101 
102     function resize(buffer memory buf, uint capacity) private pure {
103         bytes memory oldbuf = buf.buf;
104         init(buf, capacity);
105         append(buf, oldbuf);
106     }
107 
108     function max(uint a, uint b) private pure returns(uint) {
109         if(a > b) {
110             return a;
111         }
112         return b;
113     }
114 
115     /**
116      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
117      *      would exceed the capacity of the buffer.
118      * @param buf The buffer to append to.
119      * @param data The data to append.
120      * @return The original buffer.
121      */
122     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
123         if(data.length + buf.buf.length > buf.capacity) {
124             resize(buf, max(buf.capacity, data.length) * 2);
125         }
126 
127         uint dest;
128         uint src;
129         uint len = data.length;
130         assembly {
131             // Memory address of the buffer data
132             let bufptr := mload(buf)
133             // Length of existing buffer data
134             let buflen := mload(bufptr)
135             // Start address = buffer address + buffer length + sizeof(buffer length)
136             dest := add(add(bufptr, buflen), 32)
137             // Update buffer length
138             mstore(bufptr, add(buflen, mload(data)))
139             src := add(data, 32)
140         }
141 
142         // Copy word-length chunks while possible
143         for(; len >= 32; len -= 32) {
144             assembly {
145                 mstore(dest, mload(src))
146             }
147             dest += 32;
148             src += 32;
149         }
150 
151         // Copy remaining bytes
152         uint mask = 256 ** (32 - len) - 1;
153         assembly {
154             let srcpart := and(mload(src), not(mask))
155             let destpart := and(mload(dest), mask)
156             mstore(dest, or(destpart, srcpart))
157         }
158 
159         return buf;
160     }
161 
162     /**
163      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
164      * exceed the capacity of the buffer.
165      * @param buf The buffer to append to.
166      * @param data The data to append.
167      * @return The original buffer.
168      */
169     function append(buffer memory buf, uint8 data) internal pure {
170         if(buf.buf.length + 1 > buf.capacity) {
171             resize(buf, buf.capacity * 2);
172         }
173 
174         assembly {
175             // Memory address of the buffer data
176             let bufptr := mload(buf)
177             // Length of existing buffer data
178             let buflen := mload(bufptr)
179             // Address = buffer address + buffer length + sizeof(buffer length)
180             let dest := add(add(bufptr, buflen), 32)
181             mstore8(dest, data)
182             // Update buffer length
183             mstore(bufptr, add(buflen, 1))
184         }
185     }
186 
187     /**
188      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
189      * exceed the capacity of the buffer.
190      * @param buf The buffer to append to.
191      * @param data The data to append.
192      * @return The original buffer.
193      */
194     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
195         if(len + buf.buf.length > buf.capacity) {
196             resize(buf, max(buf.capacity, len) * 2);
197         }
198 
199         uint mask = 256 ** len - 1;
200         assembly {
201             // Memory address of the buffer data
202             let bufptr := mload(buf)
203             // Length of existing buffer data
204             let buflen := mload(bufptr)
205             // Address = buffer address + buffer length + sizeof(buffer length) + len
206             let dest := add(add(bufptr, buflen), len)
207             mstore(dest, or(and(mload(dest), not(mask)), data))
208             // Update buffer length
209             mstore(bufptr, add(buflen, len))
210         }
211         return buf;
212     }
213 }
214 
215 library CBOR {
216     using Buffer for Buffer.buffer;
217 
218     uint8 private constant MAJOR_TYPE_INT = 0;
219     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
220     uint8 private constant MAJOR_TYPE_BYTES = 2;
221     uint8 private constant MAJOR_TYPE_STRING = 3;
222     uint8 private constant MAJOR_TYPE_ARRAY = 4;
223     uint8 private constant MAJOR_TYPE_MAP = 5;
224     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
225 
226     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
227         if(value <= 23) {
228             buf.append(uint8((major << 5) | value));
229         } else if(value <= 0xFF) {
230             buf.append(uint8((major << 5) | 24));
231             buf.appendInt(value, 1);
232         } else if(value <= 0xFFFF) {
233             buf.append(uint8((major << 5) | 25));
234             buf.appendInt(value, 2);
235         } else if(value <= 0xFFFFFFFF) {
236             buf.append(uint8((major << 5) | 26));
237             buf.appendInt(value, 4);
238         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
239             buf.append(uint8((major << 5) | 27));
240             buf.appendInt(value, 8);
241         }
242     }
243 
244     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
245         buf.append(uint8((major << 5) | 31));
246     }
247 
248     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
249         encodeType(buf, MAJOR_TYPE_INT, value);
250     }
251 
252     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
253         if(value >= 0) {
254             encodeType(buf, MAJOR_TYPE_INT, uint(value));
255         } else {
256             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
257         }
258     }
259 
260     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
261         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
262         buf.append(value);
263     }
264 
265     function encodeString(Buffer.buffer memory buf, string value) internal pure {
266         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
267         buf.append(bytes(value));
268     }
269 
270     function startArray(Buffer.buffer memory buf) internal pure {
271         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
272     }
273 
274     function startMap(Buffer.buffer memory buf) internal pure {
275         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
276     }
277 
278     function endSequence(Buffer.buffer memory buf) internal pure {
279         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
280     }
281 }
282 
283 /*
284 End solidity-cborutils
285  */
286 
287 contract usingOraclize {
288     uint constant day = 60*60*24;
289     uint constant week = 60*60*24*7;
290     uint constant month = 60*60*24*30;
291     byte constant proofType_NONE = 0x00;
292     byte constant proofType_TLSNotary = 0x10;
293     byte constant proofType_Ledger = 0x30;
294     byte constant proofType_Android = 0x40;
295     byte constant proofType_Native = 0xF0;
296     byte constant proofStorage_IPFS = 0x01;
297     uint8 constant networkID_auto = 0;
298     uint8 constant networkID_mainnet = 1;
299     uint8 constant networkID_testnet = 2;
300     uint8 constant networkID_morden = 2;
301     uint8 constant networkID_consensys = 161;
302 
303     OraclizeAddrResolverI OAR;
304 
305     OraclizeI oraclize;
306     modifier oraclizeAPI {
307         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
308             oraclize_setNetwork(networkID_auto);
309 
310         if(address(oraclize) != OAR.getAddress())
311             oraclize = OraclizeI(OAR.getAddress());
312 
313         _;
314     }
315     modifier coupon(string code){
316         oraclize = OraclizeI(OAR.getAddress());
317         _;
318     }
319 
320     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
321       return oraclize_setNetwork();
322       networkID; // silence the warning and remain backwards compatible
323     }
324     function oraclize_setNetwork() internal returns(bool){
325         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
326             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
327             oraclize_setNetworkName("eth_mainnet");
328             return true;
329         }
330         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
331             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
332             oraclize_setNetworkName("eth_ropsten3");
333             return true;
334         }
335         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
336             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
337             oraclize_setNetworkName("eth_kovan");
338             return true;
339         }
340         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
341             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
342             oraclize_setNetworkName("eth_rinkeby");
343             return true;
344         }
345         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
346             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
347             return true;
348         }
349         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
350             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
351             return true;
352         }
353         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
354             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
355             return true;
356         }
357         return false;
358     }
359 
360     function __callback(bytes32 myid, string result) public {
361         __callback(myid, result, new bytes(0));
362     }
363     function __callback(bytes32 myid, string result, bytes proof) public {
364       return;
365       myid; result; proof; // Silence compiler warnings
366     }
367 
368     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
369         return oraclize.getPrice(datasource);
370     }
371 
372     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
373         return oraclize.getPrice(datasource, gaslimit);
374     }
375 
376     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
377         uint price = oraclize.getPrice(datasource);
378         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
379         return oraclize.query.value(price)(0, datasource, arg);
380     }
381     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
382         uint price = oraclize.getPrice(datasource);
383         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
384         return oraclize.query.value(price)(timestamp, datasource, arg);
385     }
386     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
387         uint price = oraclize.getPrice(datasource, gaslimit);
388         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
389         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
390     }
391     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
392         uint price = oraclize.getPrice(datasource, gaslimit);
393         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
394         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
395     }
396     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
397         uint price = oraclize.getPrice(datasource);
398         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
399         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
400     }
401     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource);
403         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
404         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
405     }
406     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
407         uint price = oraclize.getPrice(datasource, gaslimit);
408         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
409         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
410     }
411     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
412         uint price = oraclize.getPrice(datasource, gaslimit);
413         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
414         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
415     }
416     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
417         uint price = oraclize.getPrice(datasource);
418         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
419         bytes memory args = stra2cbor(argN);
420         return oraclize.queryN.value(price)(0, datasource, args);
421     }
422     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
423         uint price = oraclize.getPrice(datasource);
424         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
425         bytes memory args = stra2cbor(argN);
426         return oraclize.queryN.value(price)(timestamp, datasource, args);
427     }
428     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
429         uint price = oraclize.getPrice(datasource, gaslimit);
430         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
431         bytes memory args = stra2cbor(argN);
432         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
433     }
434     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
435         uint price = oraclize.getPrice(datasource, gaslimit);
436         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
437         bytes memory args = stra2cbor(argN);
438         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
439     }
440     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
441         string[] memory dynargs = new string[](1);
442         dynargs[0] = args[0];
443         return oraclize_query(datasource, dynargs);
444     }
445     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
446         string[] memory dynargs = new string[](1);
447         dynargs[0] = args[0];
448         return oraclize_query(timestamp, datasource, dynargs);
449     }
450     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
451         string[] memory dynargs = new string[](1);
452         dynargs[0] = args[0];
453         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
454     }
455     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
456         string[] memory dynargs = new string[](1);
457         dynargs[0] = args[0];
458         return oraclize_query(datasource, dynargs, gaslimit);
459     }
460 
461     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
462         string[] memory dynargs = new string[](2);
463         dynargs[0] = args[0];
464         dynargs[1] = args[1];
465         return oraclize_query(datasource, dynargs);
466     }
467     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
468         string[] memory dynargs = new string[](2);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         return oraclize_query(timestamp, datasource, dynargs);
472     }
473     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         string[] memory dynargs = new string[](2);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
478     }
479     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
480         string[] memory dynargs = new string[](2);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         return oraclize_query(datasource, dynargs, gaslimit);
484     }
485     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
486         string[] memory dynargs = new string[](3);
487         dynargs[0] = args[0];
488         dynargs[1] = args[1];
489         dynargs[2] = args[2];
490         return oraclize_query(datasource, dynargs);
491     }
492     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
493         string[] memory dynargs = new string[](3);
494         dynargs[0] = args[0];
495         dynargs[1] = args[1];
496         dynargs[2] = args[2];
497         return oraclize_query(timestamp, datasource, dynargs);
498     }
499     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
500         string[] memory dynargs = new string[](3);
501         dynargs[0] = args[0];
502         dynargs[1] = args[1];
503         dynargs[2] = args[2];
504         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
505     }
506     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
507         string[] memory dynargs = new string[](3);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         return oraclize_query(datasource, dynargs, gaslimit);
512     }
513 
514     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
515         string[] memory dynargs = new string[](4);
516         dynargs[0] = args[0];
517         dynargs[1] = args[1];
518         dynargs[2] = args[2];
519         dynargs[3] = args[3];
520         return oraclize_query(datasource, dynargs);
521     }
522     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
523         string[] memory dynargs = new string[](4);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         dynargs[3] = args[3];
528         return oraclize_query(timestamp, datasource, dynargs);
529     }
530     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
531         string[] memory dynargs = new string[](4);
532         dynargs[0] = args[0];
533         dynargs[1] = args[1];
534         dynargs[2] = args[2];
535         dynargs[3] = args[3];
536         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
537     }
538     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
539         string[] memory dynargs = new string[](4);
540         dynargs[0] = args[0];
541         dynargs[1] = args[1];
542         dynargs[2] = args[2];
543         dynargs[3] = args[3];
544         return oraclize_query(datasource, dynargs, gaslimit);
545     }
546     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
547         string[] memory dynargs = new string[](5);
548         dynargs[0] = args[0];
549         dynargs[1] = args[1];
550         dynargs[2] = args[2];
551         dynargs[3] = args[3];
552         dynargs[4] = args[4];
553         return oraclize_query(datasource, dynargs);
554     }
555     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
556         string[] memory dynargs = new string[](5);
557         dynargs[0] = args[0];
558         dynargs[1] = args[1];
559         dynargs[2] = args[2];
560         dynargs[3] = args[3];
561         dynargs[4] = args[4];
562         return oraclize_query(timestamp, datasource, dynargs);
563     }
564     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
565         string[] memory dynargs = new string[](5);
566         dynargs[0] = args[0];
567         dynargs[1] = args[1];
568         dynargs[2] = args[2];
569         dynargs[3] = args[3];
570         dynargs[4] = args[4];
571         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
572     }
573     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
574         string[] memory dynargs = new string[](5);
575         dynargs[0] = args[0];
576         dynargs[1] = args[1];
577         dynargs[2] = args[2];
578         dynargs[3] = args[3];
579         dynargs[4] = args[4];
580         return oraclize_query(datasource, dynargs, gaslimit);
581     }
582     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
583         uint price = oraclize.getPrice(datasource);
584         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
585         bytes memory args = ba2cbor(argN);
586         return oraclize.queryN.value(price)(0, datasource, args);
587     }
588     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
589         uint price = oraclize.getPrice(datasource);
590         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
591         bytes memory args = ba2cbor(argN);
592         return oraclize.queryN.value(price)(timestamp, datasource, args);
593     }
594     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
595         uint price = oraclize.getPrice(datasource, gaslimit);
596         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
597         bytes memory args = ba2cbor(argN);
598         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
599     }
600     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
601         uint price = oraclize.getPrice(datasource, gaslimit);
602         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
603         bytes memory args = ba2cbor(argN);
604         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
605     }
606     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
607         bytes[] memory dynargs = new bytes[](1);
608         dynargs[0] = args[0];
609         return oraclize_query(datasource, dynargs);
610     }
611     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
612         bytes[] memory dynargs = new bytes[](1);
613         dynargs[0] = args[0];
614         return oraclize_query(timestamp, datasource, dynargs);
615     }
616     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
617         bytes[] memory dynargs = new bytes[](1);
618         dynargs[0] = args[0];
619         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
620     }
621     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
622         bytes[] memory dynargs = new bytes[](1);
623         dynargs[0] = args[0];
624         return oraclize_query(datasource, dynargs, gaslimit);
625     }
626 
627     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
628         bytes[] memory dynargs = new bytes[](2);
629         dynargs[0] = args[0];
630         dynargs[1] = args[1];
631         return oraclize_query(datasource, dynargs);
632     }
633     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
634         bytes[] memory dynargs = new bytes[](2);
635         dynargs[0] = args[0];
636         dynargs[1] = args[1];
637         return oraclize_query(timestamp, datasource, dynargs);
638     }
639     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
640         bytes[] memory dynargs = new bytes[](2);
641         dynargs[0] = args[0];
642         dynargs[1] = args[1];
643         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
644     }
645     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
646         bytes[] memory dynargs = new bytes[](2);
647         dynargs[0] = args[0];
648         dynargs[1] = args[1];
649         return oraclize_query(datasource, dynargs, gaslimit);
650     }
651     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
652         bytes[] memory dynargs = new bytes[](3);
653         dynargs[0] = args[0];
654         dynargs[1] = args[1];
655         dynargs[2] = args[2];
656         return oraclize_query(datasource, dynargs);
657     }
658     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
659         bytes[] memory dynargs = new bytes[](3);
660         dynargs[0] = args[0];
661         dynargs[1] = args[1];
662         dynargs[2] = args[2];
663         return oraclize_query(timestamp, datasource, dynargs);
664     }
665     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
666         bytes[] memory dynargs = new bytes[](3);
667         dynargs[0] = args[0];
668         dynargs[1] = args[1];
669         dynargs[2] = args[2];
670         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
671     }
672     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
673         bytes[] memory dynargs = new bytes[](3);
674         dynargs[0] = args[0];
675         dynargs[1] = args[1];
676         dynargs[2] = args[2];
677         return oraclize_query(datasource, dynargs, gaslimit);
678     }
679 
680     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
681         bytes[] memory dynargs = new bytes[](4);
682         dynargs[0] = args[0];
683         dynargs[1] = args[1];
684         dynargs[2] = args[2];
685         dynargs[3] = args[3];
686         return oraclize_query(datasource, dynargs);
687     }
688     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
689         bytes[] memory dynargs = new bytes[](4);
690         dynargs[0] = args[0];
691         dynargs[1] = args[1];
692         dynargs[2] = args[2];
693         dynargs[3] = args[3];
694         return oraclize_query(timestamp, datasource, dynargs);
695     }
696     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
697         bytes[] memory dynargs = new bytes[](4);
698         dynargs[0] = args[0];
699         dynargs[1] = args[1];
700         dynargs[2] = args[2];
701         dynargs[3] = args[3];
702         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
703     }
704     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
705         bytes[] memory dynargs = new bytes[](4);
706         dynargs[0] = args[0];
707         dynargs[1] = args[1];
708         dynargs[2] = args[2];
709         dynargs[3] = args[3];
710         return oraclize_query(datasource, dynargs, gaslimit);
711     }
712     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
713         bytes[] memory dynargs = new bytes[](5);
714         dynargs[0] = args[0];
715         dynargs[1] = args[1];
716         dynargs[2] = args[2];
717         dynargs[3] = args[3];
718         dynargs[4] = args[4];
719         return oraclize_query(datasource, dynargs);
720     }
721     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
722         bytes[] memory dynargs = new bytes[](5);
723         dynargs[0] = args[0];
724         dynargs[1] = args[1];
725         dynargs[2] = args[2];
726         dynargs[3] = args[3];
727         dynargs[4] = args[4];
728         return oraclize_query(timestamp, datasource, dynargs);
729     }
730     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
731         bytes[] memory dynargs = new bytes[](5);
732         dynargs[0] = args[0];
733         dynargs[1] = args[1];
734         dynargs[2] = args[2];
735         dynargs[3] = args[3];
736         dynargs[4] = args[4];
737         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
738     }
739     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
740         bytes[] memory dynargs = new bytes[](5);
741         dynargs[0] = args[0];
742         dynargs[1] = args[1];
743         dynargs[2] = args[2];
744         dynargs[3] = args[3];
745         dynargs[4] = args[4];
746         return oraclize_query(datasource, dynargs, gaslimit);
747     }
748 
749     function oraclize_cbAddress() oraclizeAPI internal returns (address){
750         return oraclize.cbAddress();
751     }
752     function oraclize_setProof(byte proofP) oraclizeAPI internal {
753         return oraclize.setProofType(proofP);
754     }
755     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
756         return oraclize.setCustomGasPrice(gasPrice);
757     }
758 
759     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
760         return oraclize.randomDS_getSessionPubKeyHash();
761     }
762 
763     function getCodeSize(address _addr) constant internal returns(uint _size) {
764         assembly {
765             _size := extcodesize(_addr)
766         }
767     }
768 
769     function parseAddr(string _a) internal pure returns (address){
770         bytes memory tmp = bytes(_a);
771         uint160 iaddr = 0;
772         uint160 b1;
773         uint160 b2;
774         for (uint i=2; i<2+2*20; i+=2){
775             iaddr *= 256;
776             b1 = uint160(tmp[i]);
777             b2 = uint160(tmp[i+1]);
778             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
779             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
780             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
781             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
782             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
783             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
784             iaddr += (b1*16+b2);
785         }
786         return address(iaddr);
787     }
788 
789     function strCompare(string _a, string _b) internal pure returns (int) {
790         bytes memory a = bytes(_a);
791         bytes memory b = bytes(_b);
792         uint minLength = a.length;
793         if (b.length < minLength) minLength = b.length;
794         for (uint i = 0; i < minLength; i ++)
795             if (a[i] < b[i])
796                 return -1;
797             else if (a[i] > b[i])
798                 return 1;
799         if (a.length < b.length)
800             return -1;
801         else if (a.length > b.length)
802             return 1;
803         else
804             return 0;
805     }
806 
807     function indexOf(string _haystack, string _needle) internal pure returns (int) {
808         bytes memory h = bytes(_haystack);
809         bytes memory n = bytes(_needle);
810         if(h.length < 1 || n.length < 1 || (n.length > h.length))
811             return -1;
812         else if(h.length > (2**128 -1))
813             return -1;
814         else
815         {
816             uint subindex = 0;
817             for (uint i = 0; i < h.length; i ++)
818             {
819                 if (h[i] == n[0])
820                 {
821                     subindex = 1;
822                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
823                     {
824                         subindex++;
825                     }
826                     if(subindex == n.length)
827                         return int(i);
828                 }
829             }
830             return -1;
831         }
832     }
833 
834     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
835         bytes memory _ba = bytes(_a);
836         bytes memory _bb = bytes(_b);
837         bytes memory _bc = bytes(_c);
838         bytes memory _bd = bytes(_d);
839         bytes memory _be = bytes(_e);
840         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
841         bytes memory babcde = bytes(abcde);
842         uint k = 0;
843         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
844         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
845         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
846         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
847         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
848         return string(babcde);
849     }
850 
851     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
852         return strConcat(_a, _b, _c, _d, "");
853     }
854 
855     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
856         return strConcat(_a, _b, _c, "", "");
857     }
858 
859     function strConcat(string _a, string _b) internal pure returns (string) {
860         return strConcat(_a, _b, "", "", "");
861     }
862 
863     // parseInt
864     function parseInt(string _a) internal pure returns (uint) {
865         return parseInt(_a, 0);
866     }
867 
868     // parseInt(parseFloat*10^_b)
869     function parseInt(string _a, uint _b) internal pure returns (uint) {
870         bytes memory bresult = bytes(_a);
871         uint mint = 0;
872         bool decimals = false;
873         for (uint i=0; i<bresult.length; i++){
874             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
875                 if (decimals){
876                    if (_b == 0) break;
877                     else _b--;
878                 }
879                 mint *= 10;
880                 mint += uint(bresult[i]) - 48;
881             } else if (bresult[i] == 46) decimals = true;
882         }
883         if (_b > 0) mint *= 10**_b;
884         return mint;
885     }
886 
887     function uint2str(uint i) internal pure returns (string){
888         if (i == 0) return "0";
889         uint j = i;
890         uint len;
891         while (j != 0){
892             len++;
893             j /= 10;
894         }
895         bytes memory bstr = new bytes(len);
896         uint k = len - 1;
897         while (i != 0){
898             bstr[k--] = byte(48 + i % 10);
899             i /= 10;
900         }
901         return string(bstr);
902     }
903 
904     using CBOR for Buffer.buffer;
905     function stra2cbor(string[] arr) internal pure returns (bytes) {
906         safeMemoryCleaner();
907         Buffer.buffer memory buf;
908         Buffer.init(buf, 1024);
909         buf.startArray();
910         for (uint i = 0; i < arr.length; i++) {
911             buf.encodeString(arr[i]);
912         }
913         buf.endSequence();
914         return buf.buf;
915     }
916 
917     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
918         safeMemoryCleaner();
919         Buffer.buffer memory buf;
920         Buffer.init(buf, 1024);
921         buf.startArray();
922         for (uint i = 0; i < arr.length; i++) {
923             buf.encodeBytes(arr[i]);
924         }
925         buf.endSequence();
926         return buf.buf;
927     }
928 
929     string oraclize_network_name;
930     function oraclize_setNetworkName(string _network_name) internal {
931         oraclize_network_name = _network_name;
932     }
933 
934     function oraclize_getNetworkName() internal view returns (string) {
935         return oraclize_network_name;
936     }
937 
938     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
939         require((_nbytes > 0) && (_nbytes <= 32));
940         // Convert from seconds to ledger timer ticks
941         _delay *= 10;
942         bytes memory nbytes = new bytes(1);
943         nbytes[0] = byte(_nbytes);
944         bytes memory unonce = new bytes(32);
945         bytes memory sessionKeyHash = new bytes(32);
946         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
947         assembly {
948             mstore(unonce, 0x20)
949             // the following variables can be relaxed
950             // check relaxed random contract under ethereum-examples repo
951             // for an idea on how to override and replace comit hash vars
952             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
953             mstore(sessionKeyHash, 0x20)
954             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
955         }
956         bytes memory delay = new bytes(32);
957         assembly {
958             mstore(add(delay, 0x20), _delay)
959         }
960 
961         bytes memory delay_bytes8 = new bytes(8);
962         copyBytes(delay, 24, 8, delay_bytes8, 0);
963 
964         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
965         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
966 
967         bytes memory delay_bytes8_left = new bytes(8);
968 
969         assembly {
970             let x := mload(add(delay_bytes8, 0x20))
971             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
972             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
973             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
974             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
975             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
976             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
977             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
978             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
979 
980         }
981 
982         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
983         return queryId;
984     }
985 
986     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
987         oraclize_randomDS_args[queryId] = commitment;
988     }
989 
990     mapping(bytes32=>bytes32) oraclize_randomDS_args;
991     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
992 
993     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
994         bool sigok;
995         address signer;
996 
997         bytes32 sigr;
998         bytes32 sigs;
999 
1000         bytes memory sigr_ = new bytes(32);
1001         uint offset = 4+(uint(dersig[3]) - 0x20);
1002         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1003         bytes memory sigs_ = new bytes(32);
1004         offset += 32 + 2;
1005         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1006 
1007         assembly {
1008             sigr := mload(add(sigr_, 32))
1009             sigs := mload(add(sigs_, 32))
1010         }
1011 
1012 
1013         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1014         if (address(keccak256(pubkey)) == signer) return true;
1015         else {
1016             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1017             return (address(keccak256(pubkey)) == signer);
1018         }
1019     }
1020 
1021     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1022         bool sigok;
1023 
1024         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1025         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1026         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1027 
1028         bytes memory appkey1_pubkey = new bytes(64);
1029         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1030 
1031         bytes memory tosign2 = new bytes(1+65+32);
1032         tosign2[0] = byte(1); //role
1033         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1034         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1035         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1036         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1037 
1038         if (sigok == false) return false;
1039 
1040 
1041         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1042         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1043 
1044         bytes memory tosign3 = new bytes(1+65);
1045         tosign3[0] = 0xFE;
1046         copyBytes(proof, 3, 65, tosign3, 1);
1047 
1048         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1049         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1050 
1051         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1052 
1053         return sigok;
1054     }
1055 
1056     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1057         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1058         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1059 
1060         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1061         require(proofVerified);
1062 
1063         _;
1064     }
1065 
1066     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1067         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1068         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1069 
1070         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1071         if (proofVerified == false) return 2;
1072 
1073         return 0;
1074     }
1075 
1076     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1077         bool match_ = true;
1078 
1079         require(prefix.length == n_random_bytes);
1080 
1081         for (uint256 i=0; i< n_random_bytes; i++) {
1082             if (content[i] != prefix[i]) match_ = false;
1083         }
1084 
1085         return match_;
1086     }
1087 
1088     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1089 
1090         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1091         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1092         bytes memory keyhash = new bytes(32);
1093         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1094         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1095 
1096         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1097         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1098 
1099         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1100         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1101 
1102         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1103         // This is to verify that the computed args match with the ones specified in the query.
1104         bytes memory commitmentSlice1 = new bytes(8+1+32);
1105         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1106 
1107         bytes memory sessionPubkey = new bytes(64);
1108         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1109         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1110 
1111         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1112         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1113             delete oraclize_randomDS_args[queryId];
1114         } else return false;
1115 
1116 
1117         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1118         bytes memory tosign1 = new bytes(32+8+1+32);
1119         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1120         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1121 
1122         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1123         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1124             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1125         }
1126 
1127         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1128     }
1129 
1130     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1131     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1132         uint minLength = length + toOffset;
1133 
1134         // Buffer too small
1135         require(to.length >= minLength); // Should be a better way?
1136 
1137         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1138         uint i = 32 + fromOffset;
1139         uint j = 32 + toOffset;
1140 
1141         while (i < (32 + fromOffset + length)) {
1142             assembly {
1143                 let tmp := mload(add(from, i))
1144                 mstore(add(to, j), tmp)
1145             }
1146             i += 32;
1147             j += 32;
1148         }
1149 
1150         return to;
1151     }
1152 
1153     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1154     // Duplicate Solidity's ecrecover, but catching the CALL return value
1155     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1156         // We do our own memory management here. Solidity uses memory offset
1157         // 0x40 to store the current end of memory. We write past it (as
1158         // writes are memory extensions), but don't update the offset so
1159         // Solidity will reuse it. The memory used here is only needed for
1160         // this context.
1161 
1162         // FIXME: inline assembly can't access return values
1163         bool ret;
1164         address addr;
1165 
1166         assembly {
1167             let size := mload(0x40)
1168             mstore(size, hash)
1169             mstore(add(size, 32), v)
1170             mstore(add(size, 64), r)
1171             mstore(add(size, 96), s)
1172 
1173             // NOTE: we can reuse the request memory because we deal with
1174             //       the return code
1175             ret := call(3000, 1, 0, size, 128, size, 32)
1176             addr := mload(size)
1177         }
1178 
1179         return (ret, addr);
1180     }
1181 
1182     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1183     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1184         bytes32 r;
1185         bytes32 s;
1186         uint8 v;
1187 
1188         if (sig.length != 65)
1189           return (false, 0);
1190 
1191         // The signature format is a compact form of:
1192         //   {bytes32 r}{bytes32 s}{uint8 v}
1193         // Compact means, uint8 is not padded to 32 bytes.
1194         assembly {
1195             r := mload(add(sig, 32))
1196             s := mload(add(sig, 64))
1197 
1198             // Here we are loading the last 32 bytes. We exploit the fact that
1199             // 'mload' will pad with zeroes if we overread.
1200             // There is no 'mload8' to do this, but that would be nicer.
1201             v := byte(0, mload(add(sig, 96)))
1202 
1203             // Alternative solution:
1204             // 'byte' is not working due to the Solidity parser, so lets
1205             // use the second best option, 'and'
1206             // v := and(mload(add(sig, 65)), 255)
1207         }
1208 
1209         // albeit non-transactional signatures are not specified by the YP, one would expect it
1210         // to match the YP range of [27, 28]
1211         //
1212         // geth uses [0, 1] and some clients have followed. This might change, see:
1213         //  https://github.com/ethereum/go-ethereum/issues/2053
1214         if (v < 27)
1215           v += 27;
1216 
1217         if (v != 27 && v != 28)
1218             return (false, 0);
1219 
1220         return safer_ecrecover(hash, v, r, s);
1221     }
1222 
1223     function safeMemoryCleaner() internal pure {
1224         assembly {
1225             let fmem := mload(0x40)
1226             codecopy(fmem, codesize, sub(msize, fmem))
1227         }
1228     }
1229 
1230 }
1231 // </ORACLIZE_API>
1232 
1233 contract Permissions
1234 {
1235     //LOGS
1236     event LOG_ChangePermissions(address indexed _called, address indexed _agent, uint8 _value);
1237     event LOG_ChangeRegulator(address indexed _called, bool _value);
1238     //LOGS*
1239     //PARAMETRS
1240         //ARRAYS
1241     mapping(address => uint8) public agents;
1242         //ARRAYS
1243     bool public communityRegulator;
1244     //PARAMETRS*
1245     //MODIFIERS
1246     modifier onlyADM()
1247     {
1248         require(agents[msg.sender] == 1);
1249         _;
1250     }
1251     //MODIFIERS*
1252     //FUNCTIONS
1253         //CHANGE FUNCTIONS
1254     function changePermissions(address _agent, uint8 _value) public onlyADM()
1255     {
1256         require(msg.sender != _agent);
1257         require(_value <= 1);
1258         agents[_agent] = _value;
1259         LOG_ChangePermissions(msg.sender, _agent, _value);
1260     }
1261     function changeRegulator(bool _value) public onlyADM()
1262     {
1263         communityRegulator = _value;
1264         LOG_ChangeRegulator(msg.sender, _value);
1265     }
1266         //CHANGE FUNCTIONS*
1267     //FUNCTIONS*
1268     //CONSTRUSTOR
1269     function Permissions()
1270     {
1271         agents[msg.sender] = 1;
1272     }
1273     //CONSTRUCTOR*
1274 }
1275 
1276 contract Accounting is Permissions
1277 {
1278     //LOGS
1279     event LOG_AcceptWei(address indexed _from, uint256 _wei, uint8 indexed _type);
1280     event LOG_WithdrawWei(address indexed _called, address indexed _to, uint256 _wei, uint8 indexed _type);
1281     event LOG_ChangeOraclizeAccountingSettings(address indexed _called, uint256 _OAS_idOraclizeAccountingSettings,
1282     uint256 _OAS_oraclizeRandomGas, uint256 _OAS_oraclizeRandomGwei);
1283     //LOGS*
1284     //PARAMETRS
1285         //ACCOUNTING CONSTANTS (ACns)
1286         uint256 constant public ACns_WeiInFinney = 1000000000000000;
1287         uint256 constant public ACns_WeiInGwei = 1000000000;
1288         //ACCOUNTING CONSTANTS (ACns)*
1289         //ACCOUNTING PARAMETRS (AP)
1290     uint256 public AP_totalBalanceCommissionWei;
1291     uint256 public AP_totalBalanceDonateWei;
1292     uint256 public AP_nowRoundBankBalanceWei;
1293         //ACCOUNTING PARAMETRS (AP)*
1294         //ORACLIZE ACCOUNTING SETTINGS (OAS)
1295     uint256 public OAS_idOraclizeAccountingSettings;
1296     uint256 public OAS_oraclizeRandomGas;
1297     uint256 public OAS_oraclizeRandomGwei;
1298         //ORACLIZE ACCOUNTING SETTINGS (OAS)*
1299     //PARAMETRS*
1300     //MODIFIERS
1301     //MODIFIERS*
1302     //FUNCTIONS
1303 		//PAYABLE FUNCTIONS
1304     function () payable //Thank you very much ;-)
1305     {
1306         AP_totalBalanceDonateWei = AP_totalBalanceDonateWei + msg.value;
1307         LOG_AcceptWei(msg.sender, msg.value, 1);
1308     }
1309 		//PAYABLE FUNCTIONS*
1310         //ACTION FUNCTIONS
1311     function withdrawTotalBalanceDonateWei(address _to) public onlyADM()
1312     {
1313         _to.transfer(AP_totalBalanceDonateWei);
1314         LOG_WithdrawWei(msg.sender, _to, AP_totalBalanceDonateWei, 1);
1315         AP_totalBalanceDonateWei = 0;
1316     }
1317     function withdrawTotalBalanceCommissionWei(address _to) public onlyADM()
1318     {
1319         _to.transfer(AP_totalBalanceCommissionWei);
1320         LOG_WithdrawWei(msg.sender, _to, AP_totalBalanceCommissionWei, 2);
1321         AP_totalBalanceCommissionWei = 0;
1322     }
1323         //ACTION FUNCTIONS*
1324         //CHANGE FUNCTIONS
1325     function changeOraclizeAccountingSettings(uint256 _OAS_oraclizeRandomGas) public onlyADM()
1326     {
1327         OAS_idOraclizeAccountingSettings++;
1328         OAS_oraclizeRandomGas = _OAS_oraclizeRandomGas;
1329         OAS_oraclizeRandomGwei = _OAS_oraclizeRandomGas * 20;
1330         LOG_ChangeOraclizeAccountingSettings(msg.sender, OAS_idOraclizeAccountingSettings, OAS_oraclizeRandomGas, OAS_oraclizeRandomGwei);
1331     }
1332          //CHANGE FUNCTIONS*
1333     //FUNCTIONS*
1334     //CONSTRUSTOR
1335     //CONSTRUCTOR*
1336 }
1337 
1338 contract GameBase is Accounting, usingOraclize
1339 {
1340     //LOGS
1341     event LOG_ChangeGameSettings
1342     (address indexed _called, uint256 _GP_roundNum, uint256 _GS_idGameSettings,
1343     uint256 _GS_betSizeFinney, uint256 _GS_maxAmountBets, uint256 _GS_minStartAgentAmountBets, uint256 _GS_maxAgentAmountBets, uint256 _GS_maxAmountBetsInOneTransaction,
1344     uint8 _GS_commissionPct, bool _GS_commissionType, uint256 _GS_betTimeoutSec);
1345     
1346     event LOG_ChangeStatusGame(address indexed _called,  uint256 _GP_roundNum, uint8 _status);
1347     //LOGS*
1348     //PARAMETRS
1349         //GAME SETTINGS (GS)
1350     uint256 public GS_idGameSettings;
1351     uint256 public GS_betSizeFinney;
1352     uint256 public GS_maxAmountBets;
1353     uint256 public GS_minStartAgentAmountBets;
1354     uint256 public GS_maxAgentAmountBets;
1355     uint256 public GS_maxAmountBetsInOneTransaction;
1356     uint8 public GS_commissionPct;
1357     bool public GS_commissionType;
1358     uint256 public GS_betTimeoutSec;
1359         //GAME SETTINGS (GS)*
1360         //GAME PARAMETRS (GP)
1361     uint256 public GP_roundNum;
1362     uint256 public GP_amountBets;
1363     uint256 public GP_lastBetTimeSec;
1364     uint8 public GP_statusGame;
1365             //GAME PARAMETRS ARRAYS (GPA)
1366     mapping(address => uint256) internal GPA_agentAddressId;
1367     address[] internal GPA_agentIdAddress;
1368     uint256[] internal GPA_agentIdBetsSum;
1369     uint256[] internal GPA_betNumAgentId;
1370             //GAME PARAMETRS ARRAYS (GPA)*
1371         //GAME PARAMETRS (GP)*
1372     //PARAMETRS*
1373     //MODIFIERS
1374     modifier onlyNoBets()
1375     {
1376         require(GP_amountBets == 0);
1377         _;
1378     }
1379     modifier stop()
1380     {
1381         require(GP_statusGame == 0);
1382         _;
1383     }
1384     //MODIFIERS*
1385     //FUNCTIONS
1386         //ACTION FUNCTIONS
1387     function withdrawAllWei(address _to) public onlyADM() onlyNoBets()
1388     {
1389         LOG_WithdrawWei(msg.sender, _to, this.balance, 3);
1390         _to.transfer(this.balance);
1391         AP_totalBalanceDonateWei = 0;
1392         AP_totalBalanceCommissionWei = 0;
1393     }
1394         //ACTION FUNCTIONS*
1395         //CHANGE FUNCTIONS
1396     function changeGameSettings
1397     (uint256 _GS_betSizeFinney, uint256 _GS_maxAmountBets, uint256 _GS_minStartAgentAmountBets, uint256 _GS_maxAgentAmountBets, uint256 _GS_maxAmountBetsInOneTransaction,
1398     uint8 _GS_commissionPct, bool _GS_commissionType, uint256 _GS_betTimeoutSec) public onlyADM()  onlyNoBets()
1399     {
1400         require(OAS_oraclizeRandomGwei > 0);
1401         require(_GS_betSizeFinney <= 10000);
1402         require(_GS_maxAmountBets <= 1000000 && _GS_maxAmountBets >= 3);
1403         require(_GS_maxAmountBetsInOneTransaction <= 150);
1404         require(_GS_minStartAgentAmountBets <= _GS_maxAmountBetsInOneTransaction);
1405         require(_GS_minStartAgentAmountBets <= _GS_maxAgentAmountBets);
1406         require(_GS_maxAgentAmountBets < _GS_maxAmountBets);
1407         require(_GS_commissionPct <= 99);
1408         
1409         GS_idGameSettings++;
1410         GS_betSizeFinney = _GS_betSizeFinney;
1411         GS_maxAmountBets = _GS_maxAmountBets;
1412         GS_minStartAgentAmountBets = _GS_minStartAgentAmountBets;
1413         GS_maxAgentAmountBets = _GS_maxAgentAmountBets;
1414         GS_maxAmountBetsInOneTransaction = _GS_maxAmountBetsInOneTransaction;
1415         GS_commissionPct = _GS_commissionPct;
1416         GS_commissionType = _GS_commissionType;
1417         GS_betTimeoutSec = _GS_betTimeoutSec;
1418         
1419         LOG_ChangeGameSettings
1420         (msg.sender, GP_roundNum, GS_idGameSettings,
1421         _GS_betSizeFinney, _GS_maxAmountBets, _GS_minStartAgentAmountBets, _GS_maxAgentAmountBets, _GS_maxAmountBetsInOneTransaction,
1422         _GS_commissionPct, _GS_commissionType, _GS_betTimeoutSec);
1423     }
1424     function changeStatusGame(uint8 _value) public onlyADM() onlyNoBets()
1425     {
1426         require(_value <= 1);
1427         GP_statusGame = _value;
1428         LOG_ChangeStatusGame(msg.sender, GP_roundNum, _value);
1429     }
1430         //CHANGE FUNCTIONS*
1431         //GET FUNCTIONS
1432     function getAgentIdByAddress(address _agentAddress) public constant returns(uint256)
1433     {
1434         uint256 value;
1435         uint256 id = GPA_agentAddressId[_agentAddress];
1436         if (id != 0 && id <= GPA_agentIdAddress.length)
1437         {
1438             if (GPA_agentIdAddress[id - 1] == _agentAddress)
1439             {
1440                 value = GPA_agentAddressId[_agentAddress];
1441             }
1442         }
1443         return value;
1444     }
1445     function getAgentAdressById(uint256 _agentId) public constant returns(address)
1446     {
1447         address value;
1448         if (_agentId > 0 && _agentId <= GPA_agentIdAddress.length)
1449         {
1450             value = GPA_agentIdAddress[_agentId - 1];
1451         }
1452         return value;
1453     }
1454     function getBetsSumByAgentId(uint256 _agentId) public constant returns(uint256)
1455     {
1456         uint256 value;
1457         if (_agentId > 0 && _agentId <= GPA_agentIdBetsSum.length)
1458         {
1459             value = GPA_agentIdBetsSum[_agentId - 1];
1460         }
1461         return value;
1462     }
1463     function getAgentIdByPositionBet(uint256 _positionBet) public constant returns(uint256)
1464     {
1465         uint256 value;
1466         if (_positionBet > 0 && _positionBet <= GPA_betNumAgentId.length)
1467         {
1468             value = GPA_betNumAgentId[_positionBet - 1];
1469         }
1470         return value;
1471     }
1472     function getAgentsAmount() public constant returns(uint256)
1473     {
1474         return GPA_agentIdAddress.length;
1475     }
1476         //GET FUNCTIONS*
1477     //FUNCTIONS*
1478     //CONSTRUSTOR
1479     function GameBase()
1480     {
1481         GP_roundNum = 1;
1482     }
1483     //CONSTRUCTOR*
1484 }
1485 
1486 contract Game is GameBase
1487 {
1488     //LOGS
1489     event LOG_Request_CallbackOraclize(address indexed _called, uint256 _GP_roundNum, uint256 _OAS_idOraclizeAccountingSettings, bytes32 _queryId, uint8 _type);
1490     
1491     event LOG_ForciblyRequest_CallbackOraclize(address _called, uint256 _GP_roundNum, uint8 _confirmType);
1492     
1493     event LOG_CallbackOraclize(uint256 _GP_roundNum, bytes32 _queryId, bytes _proof);
1494     
1495     event LOG_Bet(address indexed _agent, uint256 _agentId, uint256 _GP_roundNum, uint256 _GS_idGameSettings,
1496     uint256 _amountBets, uint256 _spentFinney);
1497     
1498     event LOG_Win(address indexed _agent, uint256 _agentId, uint256 _GP_roundNum, uint256 _GS_idGameSettings,
1499     uint256 _GP_amountBets, uint256 _betsSum, uint256 _spentFinney,
1500     uint256 _winWei, uint256 _luckyNumber);
1501     
1502     event LOG_Commision(uint256 _GP_roundNum, uint256 _GS_idGameSettings, uint256 _AP_nowRoundBankBalanceWei, uint256 _GS_commissionPct, uint256 _commisionWei);
1503     //LOGS*
1504     //PARAMETRS
1505     //PARAMETRS*
1506     //FUNCTIONS
1507         //ACTION FUNCTIONS
1508     function bet() payable public
1509     {
1510         require(GP_statusGame == 1);
1511         
1512         uint256 amountBets;
1513         amountBets = (msg.value / ACns_WeiInFinney) / GS_betSizeFinney;
1514         require(amountBets > 0);
1515         
1516         uint256 agentId;
1517         agentId = getAgentIdByAddress(msg.sender);
1518         require(amountBets >= GS_minStartAgentAmountBets || agentId != 0);
1519         
1520         if ((amountBets + GP_amountBets) > GS_maxAmountBets)
1521         {
1522             amountBets = GS_maxAmountBets - GP_amountBets;    
1523         }
1524         if ((amountBets + getBetsSumByAgentId(agentId)) > GS_maxAgentAmountBets)
1525         {
1526             amountBets = GS_maxAgentAmountBets - getBetsSumByAgentId(agentId);   
1527         }
1528         if (amountBets > GS_maxAmountBetsInOneTransaction)
1529         {
1530             amountBets = GS_maxAmountBetsInOneTransaction;
1531         }
1532     
1533         require(amountBets > 0);
1534         
1535         if (agentId == 0)
1536         {
1537             GPA_agentIdAddress.push(msg.sender);
1538             agentId = GPA_agentIdAddress.length;
1539             GPA_agentAddressId[msg.sender] = agentId;
1540             GPA_agentIdBetsSum.push(0);
1541         }
1542         
1543         GPA_agentIdBetsSum[agentId - 1] = getBetsSumByAgentId(agentId) + amountBets;
1544         
1545         while (GPA_betNumAgentId.length < GP_amountBets + amountBets)
1546         {
1547             GPA_betNumAgentId.push(agentId);
1548         }
1549         
1550         uint256 amountBetsSizeWei = amountBets * GS_betSizeFinney * ACns_WeiInFinney;
1551        
1552         LOG_AcceptWei(msg.sender, msg.value, 2);
1553         LOG_WithdrawWei(msg.sender, msg.sender, msg.value - amountBetsSizeWei, 4);
1554         msg.sender.transfer(msg.value - amountBetsSizeWei);
1555         
1556         LOG_Bet(msg.sender, agentId, GP_roundNum, GS_idGameSettings, amountBets, amountBets * GS_betSizeFinney);
1557         
1558         AP_nowRoundBankBalanceWei = AP_nowRoundBankBalanceWei + amountBetsSizeWei;
1559         
1560         GP_amountBets = GP_amountBets + amountBets;
1561         
1562         GP_lastBetTimeSec = block.timestamp;
1563         
1564         if (GP_amountBets > GS_maxAmountBets - GS_minStartAgentAmountBets)
1565         {
1566             uint256 oraclizeRandomWei = OAS_oraclizeRandomGwei * ACns_WeiInGwei;
1567             
1568             if (AP_nowRoundBankBalanceWei > oraclizeRandomWei)
1569             {
1570                 GP_statusGame = 2;
1571                 LOG_ChangeStatusGame(msg.sender, GP_roundNum, GP_statusGame);
1572                 
1573                 AP_nowRoundBankBalanceWei = AP_nowRoundBankBalanceWei - oraclizeRandomWei;
1574             
1575                 request_callback(1);
1576             }
1577             else
1578             {
1579                 GP_statusGame = 3;
1580                 LOG_ChangeStatusGame(msg.sender, GP_roundNum, GP_statusGame);
1581             }
1582         }
1583     }
1584     function play(uint256 _luckyNumber) private
1585     {
1586         uint256 winnerId = getAgentIdByPositionBet(_luckyNumber);
1587         address winnerAddress = getAgentAdressById(winnerId);
1588         uint256 commissionSizeWei;
1589         
1590         if (GS_commissionType)
1591         {
1592             commissionSizeWei = AP_nowRoundBankBalanceWei / 100 * GS_commissionPct;
1593         }
1594         else
1595         {
1596             commissionSizeWei = (GP_amountBets - getBetsSumByAgentId(winnerId)) * (GS_betSizeFinney * ACns_WeiInFinney) / 100 * GS_commissionPct;
1597         }
1598         
1599         AP_totalBalanceCommissionWei = AP_totalBalanceCommissionWei + commissionSizeWei;
1600         AP_nowRoundBankBalanceWei = AP_nowRoundBankBalanceWei - commissionSizeWei;
1601         
1602         LOG_Commision(GP_roundNum, GS_idGameSettings, AP_nowRoundBankBalanceWei, GS_commissionPct, commissionSizeWei);
1603         
1604         winnerAddress.transfer(AP_nowRoundBankBalanceWei);
1605         
1606         LOG_WithdrawWei(msg.sender, winnerAddress, AP_nowRoundBankBalanceWei, 5);
1607         
1608         LOG_Win(winnerAddress, winnerId, GP_roundNum, GS_idGameSettings,
1609         GP_amountBets, getBetsSumByAgentId(winnerId), getBetsSumByAgentId(winnerId) * GS_betSizeFinney, AP_nowRoundBankBalanceWei, _luckyNumber);
1610         
1611         GP_statusGame = 1;
1612         GP_amountBets = 0;
1613         GP_roundNum++;
1614         AP_nowRoundBankBalanceWei = 0;
1615         delete GPA_agentIdAddress;
1616         delete GPA_agentIdBetsSum;
1617         delete GPA_betNumAgentId;
1618     }
1619     function thisIsTheEnd(address _to) public onlyADM() onlyNoBets()
1620     {
1621         selfdestruct(_to);
1622     }
1623         //ACTION FUNCTIONS*
1624         //ORACLIZE QUERIES
1625     function request_callback(uint8 _type) private
1626     {
1627         bytes32 queryId = oraclize_newRandomDSQuery(0, 7, OAS_oraclizeRandomGas);
1628         LOG_Request_CallbackOraclize(msg.sender, GP_roundNum, OAS_idOraclizeAccountingSettings, queryId, _type);
1629     }
1630     function forciblyRequest_callback() payable public
1631     {
1632         uint8 confirm;
1633         if (GP_statusGame == 3 && (agents[msg.sender] == 1 || communityRegulator))
1634         {
1635             confirm = 1;
1636         }
1637         if (GP_statusGame == 2 && (agents[msg.sender] == 1 || communityRegulator))
1638         {
1639             confirm = 2;
1640         }
1641         if (GP_statusGame == 1 && (block.timestamp > GP_lastBetTimeSec + GS_betTimeoutSec) && (agents[msg.sender] == 1 || communityRegulator))
1642         {
1643             confirm = 3;
1644         }
1645         
1646         if (confirm > 0)
1647         {
1648             uint256 oraclizeRandomWei = OAS_oraclizeRandomGwei * ACns_WeiInGwei;
1649             require(msg.value >= oraclizeRandomWei);
1650             msg.sender.transfer(msg.value - oraclizeRandomWei);
1651             if (confirm != 2)
1652             {
1653                 GP_statusGame = 2;
1654                 LOG_ChangeStatusGame(msg.sender, GP_roundNum, GP_statusGame); 
1655             }
1656             LOG_ForciblyRequest_CallbackOraclize(msg.sender, GP_roundNum, confirm);
1657             request_callback(2);
1658         }
1659     }
1660     function __callback(bytes32 _queryId, string _result, bytes _proof) public
1661     {
1662         require(msg.sender == oraclize_cbAddress());
1663         require (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0);
1664         require(GP_statusGame == 2);
1665         LOG_CallbackOraclize(GP_roundNum, _queryId, _proof);
1666         play(uint(sha3(_result)) % GP_amountBets + 1);
1667     }
1668     function startRequest_callback() payable public onlyADM() onlyNoBets() stop()
1669     {
1670         bytes32 queryId = oraclize_newRandomDSQuery(0, 7, 100000);
1671         LOG_Request_CallbackOraclize(msg.sender, 0, 100000, queryId, 0);
1672     }
1673         //ORACLIZE QUERIES*
1674     //CONSTRUSTOR
1675     function Game()
1676     {
1677         oraclize_setProof(proofType_Ledger);
1678     }
1679     //CONSTRUSTOR*
1680 }
1681 
1682 //Official Blog: medium.com/etherate
1683 //© EtheRate Core Team