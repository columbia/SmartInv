1 pragma solidity ^0.4.24;
2 
3 // File: contracts/external/oraclizeAPI.sol
4 
5 // <ORACLIZE_API>
6 /*
7 Copyright (c) 2015-2016 Oraclize SRL
8 Copyright (c) 2016 Oraclize LTD
9 Permission is hereby granted, free of charge, to any person obtaining a copy
10 of this software and associated documentation files (the "Software"), to deal
11 in the Software without restriction, including without limitation the rights
12 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
13 copies of the Software, and to permit persons to whom the Software is
14 furnished to do so, subject to the following conditions:
15 The above copyright notice and this permission notice shall be included in
16 all copies or substantial portions of the Software.
17 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
18 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
19 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
20 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
21 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
22 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
23 THE SOFTWARE.
24 */
25 
26 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
27 
28 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
29 
30 contract OraclizeI {
31     address public cbAddress;
32     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
33     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
34     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
35     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
36     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
37     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
38     function getPrice(string _datasource) public returns (uint _dsprice);
39     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
40     function setProofType(byte _proofType) external;
41     function setCustomGasPrice(uint _gasPrice) external;
42     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
43 }
44 
45 contract OraclizeAddrResolverI {
46     function getAddress() public returns (address _addr);
47 }
48 
49 /*
50 Begin solidity-cborutils
51 https://github.com/smartcontractkit/solidity-cborutils
52 MIT License
53 Copyright (c) 2018 SmartContract ChainLink, Ltd.
54 Permission is hereby granted, free of charge, to any person obtaining a copy
55 of this software and associated documentation files (the "Software"), to deal
56 in the Software without restriction, including without limitation the rights
57 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
58 copies of the Software, and to permit persons to whom the Software is
59 furnished to do so, subject to the following conditions:
60 The above copyright notice and this permission notice shall be included in all
61 copies or substantial portions of the Software.
62 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
63 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
64 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
65 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
66 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
67 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
68 SOFTWARE.
69  */
70 
71 library Buffer {
72     struct buffer {
73         bytes buf;
74         uint capacity;
75     }
76 
77     function init(buffer memory buf, uint _capacity) internal pure {
78         uint capacity = _capacity;
79         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
80         // Allocate space for the buffer data
81         buf.capacity = capacity;
82         assembly {
83             let ptr := mload(0x40)
84             mstore(buf, ptr)
85             mstore(ptr, 0)
86             mstore(0x40, add(ptr, capacity))
87         }
88     }
89 
90     function resize(buffer memory buf, uint capacity) private pure {
91         bytes memory oldbuf = buf.buf;
92         init(buf, capacity);
93         append(buf, oldbuf);
94     }
95 
96     function max(uint a, uint b) private pure returns(uint) {
97         if(a > b) {
98             return a;
99         }
100         return b;
101     }
102 
103     /**
104      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
105      *      would exceed the capacity of the buffer.
106      * @param buf The buffer to append to.
107      * @param data The data to append.
108      * @return The original buffer.
109      */
110     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
111         if(data.length + buf.buf.length > buf.capacity) {
112             resize(buf, max(buf.capacity, data.length) * 2);
113         }
114 
115         uint dest;
116         uint src;
117         uint len = data.length;
118         assembly {
119             // Memory address of the buffer data
120             let bufptr := mload(buf)
121             // Length of existing buffer data
122             let buflen := mload(bufptr)
123             // Start address = buffer address + buffer length + sizeof(buffer length)
124             dest := add(add(bufptr, buflen), 32)
125             // Update buffer length
126             mstore(bufptr, add(buflen, mload(data)))
127             src := add(data, 32)
128         }
129 
130         // Copy word-length chunks while possible
131         for(; len >= 32; len -= 32) {
132             assembly {
133                 mstore(dest, mload(src))
134             }
135             dest += 32;
136             src += 32;
137         }
138 
139         // Copy remaining bytes
140         uint mask = 256 ** (32 - len) - 1;
141         assembly {
142             let srcpart := and(mload(src), not(mask))
143             let destpart := and(mload(dest), mask)
144             mstore(dest, or(destpart, srcpart))
145         }
146 
147         return buf;
148     }
149 
150     /**
151      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
152      * exceed the capacity of the buffer.
153      * @param buf The buffer to append to.
154      * @param data The data to append.
155      * @return The original buffer.
156      */
157     function append(buffer memory buf, uint8 data) internal pure {
158         if(buf.buf.length + 1 > buf.capacity) {
159             resize(buf, buf.capacity * 2);
160         }
161 
162         assembly {
163             // Memory address of the buffer data
164             let bufptr := mload(buf)
165             // Length of existing buffer data
166             let buflen := mload(bufptr)
167             // Address = buffer address + buffer length + sizeof(buffer length)
168             let dest := add(add(bufptr, buflen), 32)
169             mstore8(dest, data)
170             // Update buffer length
171             mstore(bufptr, add(buflen, 1))
172         }
173     }
174 
175     /**
176      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
177      * exceed the capacity of the buffer.
178      * @param buf The buffer to append to.
179      * @param data The data to append.
180      * @return The original buffer.
181      */
182     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
183         if(len + buf.buf.length > buf.capacity) {
184             resize(buf, max(buf.capacity, len) * 2);
185         }
186 
187         uint mask = 256 ** len - 1;
188         assembly {
189             // Memory address of the buffer data
190             let bufptr := mload(buf)
191             // Length of existing buffer data
192             let buflen := mload(bufptr)
193             // Address = buffer address + buffer length + sizeof(buffer length) + len
194             let dest := add(add(bufptr, buflen), len)
195             mstore(dest, or(and(mload(dest), not(mask)), data))
196             // Update buffer length
197             mstore(bufptr, add(buflen, len))
198         }
199         return buf;
200     }
201 }
202 
203 library CBOR {
204     using Buffer for Buffer.buffer;
205 
206     uint8 private constant MAJOR_TYPE_INT = 0;
207     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
208     uint8 private constant MAJOR_TYPE_BYTES = 2;
209     uint8 private constant MAJOR_TYPE_STRING = 3;
210     uint8 private constant MAJOR_TYPE_ARRAY = 4;
211     uint8 private constant MAJOR_TYPE_MAP = 5;
212     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
213 
214     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
215         if(value <= 23) {
216             buf.append(uint8((major << 5) | value));
217         } else if(value <= 0xFF) {
218             buf.append(uint8((major << 5) | 24));
219             buf.appendInt(value, 1);
220         } else if(value <= 0xFFFF) {
221             buf.append(uint8((major << 5) | 25));
222             buf.appendInt(value, 2);
223         } else if(value <= 0xFFFFFFFF) {
224             buf.append(uint8((major << 5) | 26));
225             buf.appendInt(value, 4);
226         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
227             buf.append(uint8((major << 5) | 27));
228             buf.appendInt(value, 8);
229         }
230     }
231 
232     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
233         buf.append(uint8((major << 5) | 31));
234     }
235 
236     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
237         encodeType(buf, MAJOR_TYPE_INT, value);
238     }
239 
240     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
241         if(value >= 0) {
242             encodeType(buf, MAJOR_TYPE_INT, uint(value));
243         } else {
244             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
245         }
246     }
247 
248     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
249         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
250         buf.append(value);
251     }
252 
253     function encodeString(Buffer.buffer memory buf, string value) internal pure {
254         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
255         buf.append(bytes(value));
256     }
257 
258     function startArray(Buffer.buffer memory buf) internal pure {
259         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
260     }
261 
262     function startMap(Buffer.buffer memory buf) internal pure {
263         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
264     }
265 
266     function endSequence(Buffer.buffer memory buf) internal pure {
267         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
268     }
269 }
270 
271 /*
272 End solidity-cborutils
273  */
274 
275 contract usingOraclize {
276     uint constant day = 60*60*24;
277     uint constant week = 60*60*24*7;
278     uint constant month = 60*60*24*30;
279     byte constant proofType_NONE = 0x00;
280     byte constant proofType_TLSNotary = 0x10;
281     byte constant proofType_Ledger = 0x30;
282     byte constant proofType_Android = 0x40;
283     byte constant proofType_Native = 0xF0;
284     byte constant proofStorage_IPFS = 0x01;
285     uint8 constant networkID_auto = 0;
286     uint8 constant networkID_mainnet = 1;
287     uint8 constant networkID_testnet = 2;
288     uint8 constant networkID_morden = 2;
289     uint8 constant networkID_consensys = 161;
290 
291     OraclizeAddrResolverI OAR;
292 
293     OraclizeI oraclize;
294     modifier oraclizeAPI {
295         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
296             oraclize_setNetwork(networkID_auto);
297 
298         if(address(oraclize) != OAR.getAddress())
299             oraclize = OraclizeI(OAR.getAddress());
300 
301         _;
302     }
303     modifier coupon(string code){
304         oraclize = OraclizeI(OAR.getAddress());
305         _;
306     }
307 
308     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
309       return oraclize_setNetwork();
310       networkID; // silence the warning and remain backwards compatible
311     }
312     function oraclize_setNetwork() internal returns(bool){
313         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
314             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
315             oraclize_setNetworkName("eth_mainnet");
316             return true;
317         }
318         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
319             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
320             oraclize_setNetworkName("eth_ropsten3");
321             return true;
322         }
323         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
324             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
325             oraclize_setNetworkName("eth_kovan");
326             return true;
327         }
328         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
329             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
330             oraclize_setNetworkName("eth_rinkeby");
331             return true;
332         }
333         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
334             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
335             return true;
336         }
337         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
338             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
339             return true;
340         }
341         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
342             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
343             return true;
344         }
345         return false;
346     }
347 
348     function __callback(bytes32 myid, string result) public {
349         __callback(myid, result, new bytes(0));
350     }
351     function __callback(bytes32 myid, string result, bytes proof) public {
352       return;
353       myid; result; proof; // Silence compiler warnings
354     }
355 
356     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
357         return oraclize.getPrice(datasource);
358     }
359 
360     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
361         return oraclize.getPrice(datasource, gaslimit);
362     }
363 
364     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
365         uint price = oraclize.getPrice(datasource);
366         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
367         return oraclize.query.value(price)(0, datasource, arg);
368     }
369     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
370         uint price = oraclize.getPrice(datasource);
371         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
372         return oraclize.query.value(price)(timestamp, datasource, arg);
373     }
374     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
375         uint price = oraclize.getPrice(datasource, gaslimit);
376         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
377         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
378     }
379     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
380         uint price = oraclize.getPrice(datasource, gaslimit);
381         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
382         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
383     }
384     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
385         uint price = oraclize.getPrice(datasource);
386         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
387         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
388     }
389     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
390         uint price = oraclize.getPrice(datasource);
391         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
392         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
393     }
394     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
395         uint price = oraclize.getPrice(datasource, gaslimit);
396         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
397         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
398     }
399     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
400         uint price = oraclize.getPrice(datasource, gaslimit);
401         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
402         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
403     }
404     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
405         uint price = oraclize.getPrice(datasource);
406         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
407         bytes memory args = stra2cbor(argN);
408         return oraclize.queryN.value(price)(0, datasource, args);
409     }
410     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
411         uint price = oraclize.getPrice(datasource);
412         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
413         bytes memory args = stra2cbor(argN);
414         return oraclize.queryN.value(price)(timestamp, datasource, args);
415     }
416     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
417         uint price = oraclize.getPrice(datasource, gaslimit);
418         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
419         bytes memory args = stra2cbor(argN);
420         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
421     }
422     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
423         uint price = oraclize.getPrice(datasource, gaslimit);
424         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
425         bytes memory args = stra2cbor(argN);
426         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
427     }
428     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
429         string[] memory dynargs = new string[](1);
430         dynargs[0] = args[0];
431         return oraclize_query(datasource, dynargs);
432     }
433     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
434         string[] memory dynargs = new string[](1);
435         dynargs[0] = args[0];
436         return oraclize_query(timestamp, datasource, dynargs);
437     }
438     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
439         string[] memory dynargs = new string[](1);
440         dynargs[0] = args[0];
441         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
442     }
443     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
444         string[] memory dynargs = new string[](1);
445         dynargs[0] = args[0];
446         return oraclize_query(datasource, dynargs, gaslimit);
447     }
448 
449     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
450         string[] memory dynargs = new string[](2);
451         dynargs[0] = args[0];
452         dynargs[1] = args[1];
453         return oraclize_query(datasource, dynargs);
454     }
455     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
456         string[] memory dynargs = new string[](2);
457         dynargs[0] = args[0];
458         dynargs[1] = args[1];
459         return oraclize_query(timestamp, datasource, dynargs);
460     }
461     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
462         string[] memory dynargs = new string[](2);
463         dynargs[0] = args[0];
464         dynargs[1] = args[1];
465         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
466     }
467     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
468         string[] memory dynargs = new string[](2);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         return oraclize_query(datasource, dynargs, gaslimit);
472     }
473     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
474         string[] memory dynargs = new string[](3);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         dynargs[2] = args[2];
478         return oraclize_query(datasource, dynargs);
479     }
480     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
481         string[] memory dynargs = new string[](3);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         dynargs[2] = args[2];
485         return oraclize_query(timestamp, datasource, dynargs);
486     }
487     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
488         string[] memory dynargs = new string[](3);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         dynargs[2] = args[2];
492         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
493     }
494     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
495         string[] memory dynargs = new string[](3);
496         dynargs[0] = args[0];
497         dynargs[1] = args[1];
498         dynargs[2] = args[2];
499         return oraclize_query(datasource, dynargs, gaslimit);
500     }
501 
502     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
503         string[] memory dynargs = new string[](4);
504         dynargs[0] = args[0];
505         dynargs[1] = args[1];
506         dynargs[2] = args[2];
507         dynargs[3] = args[3];
508         return oraclize_query(datasource, dynargs);
509     }
510     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
511         string[] memory dynargs = new string[](4);
512         dynargs[0] = args[0];
513         dynargs[1] = args[1];
514         dynargs[2] = args[2];
515         dynargs[3] = args[3];
516         return oraclize_query(timestamp, datasource, dynargs);
517     }
518     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
519         string[] memory dynargs = new string[](4);
520         dynargs[0] = args[0];
521         dynargs[1] = args[1];
522         dynargs[2] = args[2];
523         dynargs[3] = args[3];
524         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
525     }
526     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
527         string[] memory dynargs = new string[](4);
528         dynargs[0] = args[0];
529         dynargs[1] = args[1];
530         dynargs[2] = args[2];
531         dynargs[3] = args[3];
532         return oraclize_query(datasource, dynargs, gaslimit);
533     }
534     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
535         string[] memory dynargs = new string[](5);
536         dynargs[0] = args[0];
537         dynargs[1] = args[1];
538         dynargs[2] = args[2];
539         dynargs[3] = args[3];
540         dynargs[4] = args[4];
541         return oraclize_query(datasource, dynargs);
542     }
543     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
544         string[] memory dynargs = new string[](5);
545         dynargs[0] = args[0];
546         dynargs[1] = args[1];
547         dynargs[2] = args[2];
548         dynargs[3] = args[3];
549         dynargs[4] = args[4];
550         return oraclize_query(timestamp, datasource, dynargs);
551     }
552     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
553         string[] memory dynargs = new string[](5);
554         dynargs[0] = args[0];
555         dynargs[1] = args[1];
556         dynargs[2] = args[2];
557         dynargs[3] = args[3];
558         dynargs[4] = args[4];
559         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
560     }
561     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
562         string[] memory dynargs = new string[](5);
563         dynargs[0] = args[0];
564         dynargs[1] = args[1];
565         dynargs[2] = args[2];
566         dynargs[3] = args[3];
567         dynargs[4] = args[4];
568         return oraclize_query(datasource, dynargs, gaslimit);
569     }
570     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
571         uint price = oraclize.getPrice(datasource);
572         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
573         bytes memory args = ba2cbor(argN);
574         return oraclize.queryN.value(price)(0, datasource, args);
575     }
576     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
577         uint price = oraclize.getPrice(datasource);
578         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
579         bytes memory args = ba2cbor(argN);
580         return oraclize.queryN.value(price)(timestamp, datasource, args);
581     }
582     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
583         uint price = oraclize.getPrice(datasource, gaslimit);
584         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
585         bytes memory args = ba2cbor(argN);
586         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
587     }
588     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
589         uint price = oraclize.getPrice(datasource, gaslimit);
590         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
591         bytes memory args = ba2cbor(argN);
592         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
593     }
594     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
595         bytes[] memory dynargs = new bytes[](1);
596         dynargs[0] = args[0];
597         return oraclize_query(datasource, dynargs);
598     }
599     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
600         bytes[] memory dynargs = new bytes[](1);
601         dynargs[0] = args[0];
602         return oraclize_query(timestamp, datasource, dynargs);
603     }
604     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
605         bytes[] memory dynargs = new bytes[](1);
606         dynargs[0] = args[0];
607         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
608     }
609     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
610         bytes[] memory dynargs = new bytes[](1);
611         dynargs[0] = args[0];
612         return oraclize_query(datasource, dynargs, gaslimit);
613     }
614 
615     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
616         bytes[] memory dynargs = new bytes[](2);
617         dynargs[0] = args[0];
618         dynargs[1] = args[1];
619         return oraclize_query(datasource, dynargs);
620     }
621     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
622         bytes[] memory dynargs = new bytes[](2);
623         dynargs[0] = args[0];
624         dynargs[1] = args[1];
625         return oraclize_query(timestamp, datasource, dynargs);
626     }
627     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
628         bytes[] memory dynargs = new bytes[](2);
629         dynargs[0] = args[0];
630         dynargs[1] = args[1];
631         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
632     }
633     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
634         bytes[] memory dynargs = new bytes[](2);
635         dynargs[0] = args[0];
636         dynargs[1] = args[1];
637         return oraclize_query(datasource, dynargs, gaslimit);
638     }
639     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
640         bytes[] memory dynargs = new bytes[](3);
641         dynargs[0] = args[0];
642         dynargs[1] = args[1];
643         dynargs[2] = args[2];
644         return oraclize_query(datasource, dynargs);
645     }
646     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
647         bytes[] memory dynargs = new bytes[](3);
648         dynargs[0] = args[0];
649         dynargs[1] = args[1];
650         dynargs[2] = args[2];
651         return oraclize_query(timestamp, datasource, dynargs);
652     }
653     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
654         bytes[] memory dynargs = new bytes[](3);
655         dynargs[0] = args[0];
656         dynargs[1] = args[1];
657         dynargs[2] = args[2];
658         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
659     }
660     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
661         bytes[] memory dynargs = new bytes[](3);
662         dynargs[0] = args[0];
663         dynargs[1] = args[1];
664         dynargs[2] = args[2];
665         return oraclize_query(datasource, dynargs, gaslimit);
666     }
667 
668     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
669         bytes[] memory dynargs = new bytes[](4);
670         dynargs[0] = args[0];
671         dynargs[1] = args[1];
672         dynargs[2] = args[2];
673         dynargs[3] = args[3];
674         return oraclize_query(datasource, dynargs);
675     }
676     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
677         bytes[] memory dynargs = new bytes[](4);
678         dynargs[0] = args[0];
679         dynargs[1] = args[1];
680         dynargs[2] = args[2];
681         dynargs[3] = args[3];
682         return oraclize_query(timestamp, datasource, dynargs);
683     }
684     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
685         bytes[] memory dynargs = new bytes[](4);
686         dynargs[0] = args[0];
687         dynargs[1] = args[1];
688         dynargs[2] = args[2];
689         dynargs[3] = args[3];
690         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
691     }
692     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
693         bytes[] memory dynargs = new bytes[](4);
694         dynargs[0] = args[0];
695         dynargs[1] = args[1];
696         dynargs[2] = args[2];
697         dynargs[3] = args[3];
698         return oraclize_query(datasource, dynargs, gaslimit);
699     }
700     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
701         bytes[] memory dynargs = new bytes[](5);
702         dynargs[0] = args[0];
703         dynargs[1] = args[1];
704         dynargs[2] = args[2];
705         dynargs[3] = args[3];
706         dynargs[4] = args[4];
707         return oraclize_query(datasource, dynargs);
708     }
709     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
710         bytes[] memory dynargs = new bytes[](5);
711         dynargs[0] = args[0];
712         dynargs[1] = args[1];
713         dynargs[2] = args[2];
714         dynargs[3] = args[3];
715         dynargs[4] = args[4];
716         return oraclize_query(timestamp, datasource, dynargs);
717     }
718     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
719         bytes[] memory dynargs = new bytes[](5);
720         dynargs[0] = args[0];
721         dynargs[1] = args[1];
722         dynargs[2] = args[2];
723         dynargs[3] = args[3];
724         dynargs[4] = args[4];
725         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
726     }
727     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
728         bytes[] memory dynargs = new bytes[](5);
729         dynargs[0] = args[0];
730         dynargs[1] = args[1];
731         dynargs[2] = args[2];
732         dynargs[3] = args[3];
733         dynargs[4] = args[4];
734         return oraclize_query(datasource, dynargs, gaslimit);
735     }
736 
737     function oraclize_cbAddress() oraclizeAPI internal returns (address){
738         return oraclize.cbAddress();
739     }
740     function oraclize_setProof(byte proofP) oraclizeAPI internal {
741         return oraclize.setProofType(proofP);
742     }
743     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
744         return oraclize.setCustomGasPrice(gasPrice);
745     }
746 
747     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
748         return oraclize.randomDS_getSessionPubKeyHash();
749     }
750 
751     function getCodeSize(address _addr) constant internal returns(uint _size) {
752         assembly {
753             _size := extcodesize(_addr)
754         }
755     }
756 
757     function parseAddr(string _a) internal pure returns (address){
758         bytes memory tmp = bytes(_a);
759         uint160 iaddr = 0;
760         uint160 b1;
761         uint160 b2;
762         for (uint i=2; i<2+2*20; i+=2){
763             iaddr *= 256;
764             b1 = uint160(tmp[i]);
765             b2 = uint160(tmp[i+1]);
766             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
767             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
768             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
769             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
770             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
771             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
772             iaddr += (b1*16+b2);
773         }
774         return address(iaddr);
775     }
776 
777     function strCompare(string _a, string _b) internal pure returns (int) {
778         bytes memory a = bytes(_a);
779         bytes memory b = bytes(_b);
780         uint minLength = a.length;
781         if (b.length < minLength) minLength = b.length;
782         for (uint i = 0; i < minLength; i ++)
783             if (a[i] < b[i])
784                 return -1;
785             else if (a[i] > b[i])
786                 return 1;
787         if (a.length < b.length)
788             return -1;
789         else if (a.length > b.length)
790             return 1;
791         else
792             return 0;
793     }
794 
795     function indexOf(string _haystack, string _needle) internal pure returns (int) {
796         bytes memory h = bytes(_haystack);
797         bytes memory n = bytes(_needle);
798         if(h.length < 1 || n.length < 1 || (n.length > h.length))
799             return -1;
800         else if(h.length > (2**128 -1))
801             return -1;
802         else
803         {
804             uint subindex = 0;
805             for (uint i = 0; i < h.length; i ++)
806             {
807                 if (h[i] == n[0])
808                 {
809                     subindex = 1;
810                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
811                     {
812                         subindex++;
813                     }
814                     if(subindex == n.length)
815                         return int(i);
816                 }
817             }
818             return -1;
819         }
820     }
821 
822     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
823         bytes memory _ba = bytes(_a);
824         bytes memory _bb = bytes(_b);
825         bytes memory _bc = bytes(_c);
826         bytes memory _bd = bytes(_d);
827         bytes memory _be = bytes(_e);
828         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
829         bytes memory babcde = bytes(abcde);
830         uint k = 0;
831         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
832         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
833         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
834         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
835         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
836         return string(babcde);
837     }
838 
839     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
840         return strConcat(_a, _b, _c, _d, "");
841     }
842 
843     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
844         return strConcat(_a, _b, _c, "", "");
845     }
846 
847     function strConcat(string _a, string _b) internal pure returns (string) {
848         return strConcat(_a, _b, "", "", "");
849     }
850 
851     // parseInt
852     function parseInt(string _a) internal pure returns (uint) {
853         return parseInt(_a, 0);
854     }
855 
856     // parseInt(parseFloat*10^_b)
857     function parseInt(string _a, uint _b) internal pure returns (uint) {
858         bytes memory bresult = bytes(_a);
859         uint mint = 0;
860         bool decimals = false;
861         for (uint i=0; i<bresult.length; i++){
862             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
863                 if (decimals){
864                    if (_b == 0) break;
865                     else _b--;
866                 }
867                 mint *= 10;
868                 mint += uint(bresult[i]) - 48;
869             } else if (bresult[i] == 46) decimals = true;
870         }
871         if (_b > 0) mint *= 10**_b;
872         return mint;
873     }
874 
875     function uint2str(uint i) internal pure returns (string){
876         if (i == 0) return "0";
877         uint j = i;
878         uint len;
879         while (j != 0){
880             len++;
881             j /= 10;
882         }
883         bytes memory bstr = new bytes(len);
884         uint k = len - 1;
885         while (i != 0){
886             bstr[k--] = byte(48 + i % 10);
887             i /= 10;
888         }
889         return string(bstr);
890     }
891 
892     using CBOR for Buffer.buffer;
893     function stra2cbor(string[] arr) internal pure returns (bytes) {
894         safeMemoryCleaner();
895         Buffer.buffer memory buf;
896         Buffer.init(buf, 1024);
897         buf.startArray();
898         for (uint i = 0; i < arr.length; i++) {
899             buf.encodeString(arr[i]);
900         }
901         buf.endSequence();
902         return buf.buf;
903     }
904 
905     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
906         safeMemoryCleaner();
907         Buffer.buffer memory buf;
908         Buffer.init(buf, 1024);
909         buf.startArray();
910         for (uint i = 0; i < arr.length; i++) {
911             buf.encodeBytes(arr[i]);
912         }
913         buf.endSequence();
914         return buf.buf;
915     }
916 
917     string oraclize_network_name;
918     function oraclize_setNetworkName(string _network_name) internal {
919         oraclize_network_name = _network_name;
920     }
921 
922     function oraclize_getNetworkName() internal view returns (string) {
923         return oraclize_network_name;
924     }
925 
926     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
927         require((_nbytes > 0) && (_nbytes <= 32));
928         // Convert from seconds to ledger timer ticks
929         _delay *= 10;
930         bytes memory nbytes = new bytes(1);
931         nbytes[0] = byte(_nbytes);
932         bytes memory unonce = new bytes(32);
933         bytes memory sessionKeyHash = new bytes(32);
934         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
935         assembly {
936             mstore(unonce, 0x20)
937             // the following variables can be relaxed
938             // check relaxed random contract under ethereum-examples repo
939             // for an idea on how to override and replace comit hash vars
940             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
941             mstore(sessionKeyHash, 0x20)
942             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
943         }
944         bytes memory delay = new bytes(32);
945         assembly {
946             mstore(add(delay, 0x20), _delay)
947         }
948 
949         bytes memory delay_bytes8 = new bytes(8);
950         copyBytes(delay, 24, 8, delay_bytes8, 0);
951 
952         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
953         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
954 
955         bytes memory delay_bytes8_left = new bytes(8);
956 
957         assembly {
958             let x := mload(add(delay_bytes8, 0x20))
959             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
960             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
961             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
962             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
963             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
964             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
965             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
966             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
967 
968         }
969 
970         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
971         return queryId;
972     }
973 
974     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
975         oraclize_randomDS_args[queryId] = commitment;
976     }
977 
978     mapping(bytes32=>bytes32) oraclize_randomDS_args;
979     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
980 
981     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
982         bool sigok;
983         address signer;
984 
985         bytes32 sigr;
986         bytes32 sigs;
987 
988         bytes memory sigr_ = new bytes(32);
989         uint offset = 4+(uint(dersig[3]) - 0x20);
990         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
991         bytes memory sigs_ = new bytes(32);
992         offset += 32 + 2;
993         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
994 
995         assembly {
996             sigr := mload(add(sigr_, 32))
997             sigs := mload(add(sigs_, 32))
998         }
999 
1000 
1001         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1002         if (address(keccak256(pubkey)) == signer) return true;
1003         else {
1004             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1005             return (address(keccak256(pubkey)) == signer);
1006         }
1007     }
1008 
1009     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1010         bool sigok;
1011 
1012         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1013         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1014         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1015 
1016         bytes memory appkey1_pubkey = new bytes(64);
1017         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1018 
1019         bytes memory tosign2 = new bytes(1+65+32);
1020         tosign2[0] = byte(1); //role
1021         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1022         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1023         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1024         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1025 
1026         if (sigok == false) return false;
1027 
1028 
1029         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1030         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1031 
1032         bytes memory tosign3 = new bytes(1+65);
1033         tosign3[0] = 0xFE;
1034         copyBytes(proof, 3, 65, tosign3, 1);
1035 
1036         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1037         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1038 
1039         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1040 
1041         return sigok;
1042     }
1043 
1044     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1045         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1046         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1047 
1048         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1049         require(proofVerified);
1050 
1051         _;
1052     }
1053 
1054     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1055         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1056         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1057 
1058         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1059         if (proofVerified == false) return 2;
1060 
1061         return 0;
1062     }
1063 
1064     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1065         bool match_ = true;
1066 
1067         require(prefix.length == n_random_bytes);
1068 
1069         for (uint256 i=0; i< n_random_bytes; i++) {
1070             if (content[i] != prefix[i]) match_ = false;
1071         }
1072 
1073         return match_;
1074     }
1075 
1076     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1077 
1078         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1079         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1080         bytes memory keyhash = new bytes(32);
1081         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1082         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1083 
1084         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1085         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1086 
1087         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1088         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1089 
1090         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1091         // This is to verify that the computed args match with the ones specified in the query.
1092         bytes memory commitmentSlice1 = new bytes(8+1+32);
1093         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1094 
1095         bytes memory sessionPubkey = new bytes(64);
1096         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1097         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1098 
1099         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1100         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1101             delete oraclize_randomDS_args[queryId];
1102         } else return false;
1103 
1104 
1105         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1106         bytes memory tosign1 = new bytes(32+8+1+32);
1107         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1108         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1109 
1110         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1111         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1112             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1113         }
1114 
1115         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1116     }
1117 
1118     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1119     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1120         uint minLength = length + toOffset;
1121 
1122         // Buffer too small
1123         require(to.length >= minLength); // Should be a better way?
1124 
1125         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1126         uint i = 32 + fromOffset;
1127         uint j = 32 + toOffset;
1128 
1129         while (i < (32 + fromOffset + length)) {
1130             assembly {
1131                 let tmp := mload(add(from, i))
1132                 mstore(add(to, j), tmp)
1133             }
1134             i += 32;
1135             j += 32;
1136         }
1137 
1138         return to;
1139     }
1140 
1141     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1142     // Duplicate Solidity's ecrecover, but catching the CALL return value
1143     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1144         // We do our own memory management here. Solidity uses memory offset
1145         // 0x40 to store the current end of memory. We write past it (as
1146         // writes are memory extensions), but don't update the offset so
1147         // Solidity will reuse it. The memory used here is only needed for
1148         // this context.
1149 
1150         // FIXME: inline assembly can't access return values
1151         bool ret;
1152         address addr;
1153 
1154         assembly {
1155             let size := mload(0x40)
1156             mstore(size, hash)
1157             mstore(add(size, 32), v)
1158             mstore(add(size, 64), r)
1159             mstore(add(size, 96), s)
1160 
1161             // NOTE: we can reuse the request memory because we deal with
1162             //       the return code
1163             ret := call(3000, 1, 0, size, 128, size, 32)
1164             addr := mload(size)
1165         }
1166 
1167         return (ret, addr);
1168     }
1169 
1170     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1171     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1172         bytes32 r;
1173         bytes32 s;
1174         uint8 v;
1175 
1176         if (sig.length != 65)
1177           return (false, 0);
1178 
1179         // The signature format is a compact form of:
1180         //   {bytes32 r}{bytes32 s}{uint8 v}
1181         // Compact means, uint8 is not padded to 32 bytes.
1182         assembly {
1183             r := mload(add(sig, 32))
1184             s := mload(add(sig, 64))
1185 
1186             // Here we are loading the last 32 bytes. We exploit the fact that
1187             // 'mload' will pad with zeroes if we overread.
1188             // There is no 'mload8' to do this, but that would be nicer.
1189             v := byte(0, mload(add(sig, 96)))
1190 
1191             // Alternative solution:
1192             // 'byte' is not working due to the Solidity parser, so lets
1193             // use the second best option, 'and'
1194             // v := and(mload(add(sig, 65)), 255)
1195         }
1196 
1197         // albeit non-transactional signatures are not specified by the YP, one would expect it
1198         // to match the YP range of [27, 28]
1199         //
1200         // geth uses [0, 1] and some clients have followed. This might change, see:
1201         //  https://github.com/ethereum/go-ethereum/issues/2053
1202         if (v < 27)
1203           v += 27;
1204 
1205         if (v != 27 && v != 28)
1206             return (false, 0);
1207 
1208         return safer_ecrecover(hash, v, r, s);
1209     }
1210 
1211     function safeMemoryCleaner() internal pure {
1212         assembly {
1213             let fmem := mload(0x40)
1214             codecopy(fmem, codesize, sub(msize, fmem))
1215         }
1216     }
1217 
1218 }
1219 
1220 // File: contracts/interfaces/IOracle.sol
1221 
1222 interface IOracle {
1223 
1224     /**
1225     * @notice Returns address of oracle currency (0x0 for ETH)
1226     */
1227     function getCurrencyAddress() external view returns(address);
1228 
1229     /**
1230     * @notice Returns symbol of oracle currency (0x0 for ETH)
1231     */
1232     function getCurrencySymbol() external view returns(bytes32);
1233 
1234     /**
1235     * @notice Returns denomination of price
1236     */
1237     function getCurrencyDenominated() external view returns(bytes32);
1238 
1239     /**
1240     * @notice Returns price - should throw if not valid
1241     */
1242     function getPrice() external view returns(uint256);
1243 
1244 }
1245 
1246 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
1247 
1248 /**
1249  * @title SafeMath
1250  * @dev Math operations with safety checks that throw on error
1251  */
1252 library SafeMath {
1253 
1254   /**
1255   * @dev Multiplies two numbers, throws on overflow.
1256   */
1257   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1258     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1259     // benefit is lost if 'b' is also tested.
1260     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1261     if (a == 0) {
1262       return 0;
1263     }
1264 
1265     c = a * b;
1266     assert(c / a == b);
1267     return c;
1268   }
1269 
1270   /**
1271   * @dev Integer division of two numbers, truncating the quotient.
1272   */
1273   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1274     // assert(b > 0); // Solidity automatically throws when dividing by 0
1275     // uint256 c = a / b;
1276     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1277     return a / b;
1278   }
1279 
1280   /**
1281   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1282   */
1283   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1284     assert(b <= a);
1285     return a - b;
1286   }
1287 
1288   /**
1289   * @dev Adds two numbers, throws on overflow.
1290   */
1291   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1292     c = a + b;
1293     assert(c >= a);
1294     return c;
1295   }
1296 }
1297 
1298 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1299 
1300 /**
1301  * @title Ownable
1302  * @dev The Ownable contract has an owner address, and provides basic authorization control
1303  * functions, this simplifies the implementation of "user permissions".
1304  */
1305 contract Ownable {
1306   address public owner;
1307 
1308 
1309   event OwnershipRenounced(address indexed previousOwner);
1310   event OwnershipTransferred(
1311     address indexed previousOwner,
1312     address indexed newOwner
1313   );
1314 
1315 
1316   /**
1317    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1318    * account.
1319    */
1320   constructor() public {
1321     owner = msg.sender;
1322   }
1323 
1324   /**
1325    * @dev Throws if called by any account other than the owner.
1326    */
1327   modifier onlyOwner() {
1328     require(msg.sender == owner);
1329     _;
1330   }
1331 
1332   /**
1333    * @dev Allows the current owner to relinquish control of the contract.
1334    */
1335   function renounceOwnership() public onlyOwner {
1336     emit OwnershipRenounced(owner);
1337     owner = address(0);
1338   }
1339 
1340   /**
1341    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1342    * @param _newOwner The address to transfer ownership to.
1343    */
1344   function transferOwnership(address _newOwner) public onlyOwner {
1345     _transferOwnership(_newOwner);
1346   }
1347 
1348   /**
1349    * @dev Transfers control of the contract to a newOwner.
1350    * @param _newOwner The address to transfer ownership to.
1351    */
1352   function _transferOwnership(address _newOwner) internal {
1353     require(_newOwner != address(0));
1354     emit OwnershipTransferred(owner, _newOwner);
1355     owner = _newOwner;
1356   }
1357 }
1358 
1359 // File: contracts/oracles/PolyOracle.sol
1360 
1361 contract PolyOracle is usingOraclize, IOracle, Ownable {
1362     using SafeMath for uint256;
1363 
1364     string public oracleURL = '[URL] json(https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?id=2496&convert=USD&CMC_PRO_API_KEY=${[decrypt] BCA0Bqxmn3jkSENepaHxQv09Z/vGdEO9apO+B9RplHyV3qOL/dw5Indlei3hoXrGk9G14My8MFpHJycB7UoVnl+4mlzEsjTlS2UBAYVrl0fAepfiSyM30/GMZAoJmDagY+0YyNZvpkgXn86Q/59Bi48PWEet}).data."2496".quote.USD.price';
1365     string public oracleQueryType = "nested";
1366     uint256 public sanityBounds = 20*10**16;
1367     uint256 public gasLimit = 100000;
1368     uint256 public oraclizeTimeTolerance = 5 minutes;
1369     uint256 public staleTime = 6 hours;
1370 
1371     uint256 private POLYUSD;
1372     uint256 public latestUpdate;
1373     uint256 public latestScheduledUpdate;
1374 
1375     mapping (bytes32 => uint256) public requestIds;
1376     mapping (bytes32 => bool) public ignoreRequestIds;
1377 
1378     mapping (address => bool) public admin;
1379 
1380     bool public freezeOracle;
1381 
1382     event LogPriceUpdated(uint256 _price, uint256 _oldPrice, bytes32 _queryId, uint256 _time);
1383     event LogNewOraclizeQuery(uint256 _time, bytes32 _queryId, string _query);
1384     event LogAdminSet(address _admin, bool _valid, uint256 _time);
1385     event LogStalePriceUpdate(bytes32 _queryId, uint256 _time, string _result);
1386 
1387     modifier isAdminOrOwner {
1388         require(admin[msg.sender] || msg.sender == owner, "Address is not admin or owner");
1389         _;
1390     }
1391 
1392     /**
1393     * @notice Constructor - accepts ETH to initialise a balance for subsequent Oraclize queries
1394     */
1395     constructor() payable public {
1396         // Use 50 gwei for now
1397         oraclize_setCustomGasPrice(50*10**9);
1398     }
1399 
1400     /**
1401     * @notice Oraclize callback (triggered by Oraclize)
1402     * @param _requestId requestId corresponding to Oraclize query
1403     * @param _result data returned by Oraclize URL query
1404     */
1405     function __callback(bytes32 _requestId, string _result) public {
1406         require(msg.sender == oraclize_cbAddress(), "Only Oraclize can access this method");
1407         require(!freezeOracle, "Oracle is frozen");
1408         require(!ignoreRequestIds[_requestId], "Ignoring requestId");
1409         if (requestIds[_requestId] < latestUpdate) {
1410             // Result is stale, probably because it was received out of order
1411             emit LogStalePriceUpdate(_requestId, requestIds[_requestId], _result);
1412             return;
1413         }
1414         require(requestIds[_requestId] >= latestUpdate, "Result is stale");
1415         require(requestIds[_requestId] <= now + oraclizeTimeTolerance, "Result is early");
1416         uint256 newPOLYUSD = parseInt(_result, 18);
1417         uint256 bound = POLYUSD.mul(sanityBounds).div(10**18);
1418         if (latestUpdate != 0) {
1419           require(newPOLYUSD <= POLYUSD.add(bound), "Result is too large");
1420           require(newPOLYUSD >= POLYUSD.sub(bound), "Result is too small");
1421         }
1422         latestUpdate = requestIds[_requestId];
1423         emit LogPriceUpdated(newPOLYUSD, POLYUSD, _requestId, latestUpdate);
1424         POLYUSD = newPOLYUSD;
1425     }
1426 
1427     /**
1428     * @notice Allows owner to schedule future Oraclize calls
1429     * @param _times UNIX timestamps to schedule Oraclize calls as of. Empty list means trigger an immediate query.
1430     */
1431     function schedulePriceUpdatesFixed(uint256[] _times) payable isAdminOrOwner public {
1432         bytes32 requestId;
1433         uint256 maximumScheduledUpdated;
1434         if (_times.length == 0) {
1435             require(oraclize_getPrice(oracleQueryType, gasLimit) <= address(this).balance, "Insufficient Funds");
1436             requestId = oraclize_query(oracleQueryType, oracleURL, gasLimit);
1437             requestIds[requestId] = now;
1438             maximumScheduledUpdated = now;
1439             emit LogNewOraclizeQuery(now, requestId, oracleURL);
1440         } else {
1441             require(oraclize_getPrice(oracleQueryType, gasLimit) * _times.length <= address(this).balance, "Insufficient Funds");
1442             for (uint256 i = 0; i < _times.length; i++) {
1443                 require(_times[i] >= now, "Past scheduling is not allowed and scheduled time should be absolute timestamp");
1444                 requestId = oraclize_query(_times[i], oracleQueryType, oracleURL, gasLimit);
1445                 requestIds[requestId] = _times[i];
1446                 if (maximumScheduledUpdated < requestIds[requestId]) {
1447                     maximumScheduledUpdated = requestIds[requestId];
1448                 }
1449                 emit LogNewOraclizeQuery(_times[i], requestId, oracleURL);
1450             }
1451         }
1452         if (latestScheduledUpdate < maximumScheduledUpdated) {
1453             latestScheduledUpdate = maximumScheduledUpdated;
1454         }
1455     }
1456 
1457     /**
1458     * @notice Allows owner to schedule future Oraclize calls on a rolling schedule
1459     * @param _startTime UNIX timestamp for the first scheduled Oraclize query
1460     * @param _interval how long (in seconds) between each subsequent Oraclize query
1461     * @param _iters the number of Oraclize queries to schedule.
1462     */
1463     function schedulePriceUpdatesRolling(uint256 _startTime, uint256 _interval, uint256 _iters) payable isAdminOrOwner public {
1464         bytes32 requestId;
1465         require(_interval > 0, "Interval between scheduled time should be greater than zero");
1466         require(_iters > 0, "No iterations specified");
1467         require(_startTime >= now, "Past scheduling is not allowed and scheduled time should be absolute timestamp");
1468         require(oraclize_getPrice(oracleQueryType, gasLimit) * _iters <= address(this).balance, "Insufficient Funds");
1469         for (uint256 i = 0; i < _iters; i++) {
1470             uint256 scheduledTime = _startTime + (i * _interval);
1471             requestId = oraclize_query(scheduledTime, oracleQueryType, oracleURL, gasLimit);
1472             requestIds[requestId] = scheduledTime;
1473             emit LogNewOraclizeQuery(scheduledTime, requestId, oracleURL);
1474         }
1475         if (latestScheduledUpdate < requestIds[requestId]) {
1476             latestScheduledUpdate = requestIds[requestId];
1477         }
1478     }
1479 
1480     /**
1481     * @notice Allows owner to manually set POLYUSD price
1482     * @param _price POLYUSD price
1483     */
1484     function setPOLYUSD(uint256 _price) onlyOwner public {
1485         emit LogPriceUpdated(_price, POLYUSD, 0, now);
1486         POLYUSD = _price;
1487         latestUpdate = now;
1488     }
1489 
1490     /**
1491     * @notice Allows owner to set oracle to ignore all Oraclize pricce updates
1492     * @param _frozen true to freeze updates, false to reenable updates
1493     */
1494     function setFreezeOracle(bool _frozen) onlyOwner public {
1495         freezeOracle = _frozen;
1496     }
1497 
1498     /**
1499     * @notice Allows owner to set URL used in Oraclize queries
1500     * @param _oracleURL URL to use
1501     */
1502     function setOracleURL(string _oracleURL) onlyOwner public {
1503         oracleURL = _oracleURL;
1504     }
1505 
1506     /**
1507     * @notice Allows owner to set type used in Oraclize queries
1508     * @param _oracleQueryType to use
1509     */
1510     function setOracleQueryType(string _oracleQueryType) onlyOwner public {
1511         oracleQueryType = _oracleQueryType;
1512     }
1513 
1514     /**
1515     * @notice Allows owner to set new sanity bounds for price updates
1516     * @param _sanityBounds sanity bounds as a percentage * 10**16
1517     */
1518     function setSanityBounds(uint256 _sanityBounds) onlyOwner public {
1519         sanityBounds = _sanityBounds;
1520     }
1521 
1522     /**
1523     * @notice Allows owner to set new gas price for future Oraclize queries
1524     * @notice NB - this will only impact newly scheduled Oraclize queries, not future queries which have already been scheduled
1525     * @param _gasPrice gas price to use for Oraclize callbacks
1526     */
1527     function setGasPrice(uint256 _gasPrice) onlyOwner public {
1528         oraclize_setCustomGasPrice(_gasPrice);
1529     }
1530 
1531     /**
1532     * @notice Returns price and corresponding update time
1533     * @return latest POLYUSD price
1534     * @return timestamp of latest price update
1535     */
1536     function getPriceAndTime() view public returns(uint256, uint256) {
1537         return (POLYUSD, latestUpdate);
1538     }
1539 
1540     /**
1541     * @notice Allows owner to set new gas limit on Oraclize queries
1542     * @notice NB - this will only impact newly scheduled Oraclize queries, not future queries which have already been scheduled
1543     * @param _gasLimit gas limit to use for Oraclize callbacks
1544     */
1545     function setGasLimit(uint256 _gasLimit) isAdminOrOwner public {
1546         gasLimit = _gasLimit;
1547     }
1548 
1549     /**
1550     * @notice Allows owner to set time after which price is considered stale
1551     * @param _staleTime elapsed time after which price is considered stale
1552     */
1553     function setStaleTime(uint256 _staleTime) onlyOwner public {
1554         staleTime = _staleTime;
1555     }
1556 
1557     /**
1558     * @notice Allows owner to ignore specific requestId results from Oraclize
1559     * @param _requestIds Oraclize queryIds (as logged out when Oraclize query is scheduled)
1560     * @param _ignore whether or not they should be ignored
1561     */
1562     function setIgnoreRequestIds(bytes32[] _requestIds, bool[] _ignore) onlyOwner public {
1563         require(_requestIds.length == _ignore.length, "Incorrect parameter lengths");
1564         for (uint256 i = 0; i < _requestIds.length; i++) {
1565             ignoreRequestIds[_requestIds[i]] = _ignore[i];
1566         }
1567     }
1568 
1569     /**
1570     * @notice Allows owner to set up admin addresses that can schedule updates
1571     * @param _admin Admin address
1572     * @param _valid Whether address should be added or removed from admin list
1573     */
1574     function setAdmin(address _admin, bool _valid) onlyOwner public {
1575         admin[_admin] = _valid;
1576         emit LogAdminSet(_admin, _valid, now);
1577     }
1578 
1579     /**
1580     * @notice Allows owner to set new time tolerance on Oraclize queries
1581     * @param _oraclizeTimeTolerance amount of time in seconds that an Oraclize query can be early
1582     */
1583     function setOraclizeTimeTolerance(uint256 _oraclizeTimeTolerance) onlyOwner public {
1584         oraclizeTimeTolerance = _oraclizeTimeTolerance;
1585     }
1586 
1587     /**
1588     * @notice Returns address of oracle currency (0x0 for ETH)
1589     */
1590     function getCurrencyAddress() external view returns(address) {
1591         return 0x9992eC3cF6A55b00978cdDF2b27BC6882d88D1eC;
1592     }
1593 
1594     /**
1595     * @notice Returns symbol of oracle currency (0x0 for ETH)
1596     */
1597     function getCurrencySymbol() external view returns(bytes32) {
1598         return bytes32("POLY");
1599     }
1600 
1601     /**
1602     * @notice Returns denomination of price
1603     */
1604     function getCurrencyDenominated() external view returns(bytes32) {
1605         return bytes32("USD");
1606     }
1607 
1608     /**
1609     * @notice Returns price - should throw if not valid
1610     */
1611     function getPrice() external view returns(uint256) {
1612         require(latestUpdate >= now - staleTime);
1613         return POLYUSD;
1614     }
1615 
1616     /**
1617     * @notice Returns balance to owner
1618     */
1619     function drainContract() external onlyOwner {
1620         msg.sender.transfer(address(this).balance);
1621     }
1622 
1623 }