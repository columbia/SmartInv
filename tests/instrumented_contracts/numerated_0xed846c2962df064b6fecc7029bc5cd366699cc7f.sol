1 pragma solidity ^0.4.18;
2 
3 
4 // <ORACLIZE_API>
5 /*
6 Copyright (c) 2015-2016 Oraclize SRL
7 Copyright (c) 2016 Oraclize LTD
8 Permission is hereby granted, free of charge, to any person obtaining a copy
9 of this software and associated documentation files (the "Software"), to deal
10 in the Software without restriction, including without limitation the rights
11 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 copies of the Software, and to permit persons to whom the Software is
13 furnished to do so, subject to the following conditions:
14 The above copyright notice and this permission notice shall be included in
15 all copies or substantial portions of the Software.
16 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
17 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
18 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
19 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
20 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
21 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
22 THE SOFTWARE.
23 */
24 
25 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
26 
27 
28 contract OraclizeI {
29     address public cbAddress;
30     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
31     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
32     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
33     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
34     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
35     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
36     function getPrice(string _datasource) public returns (uint _dsprice);
37     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
38     function setProofType(byte _proofType) external;
39     function setCustomGasPrice(uint _gasPrice) external;
40     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
41 }
42 
43 contract OraclizeAddrResolverI {
44     function getAddress() public returns (address _addr);
45 }
46 
47 /*
48 Begin solidity-cborutils
49 https://github.com/smartcontractkit/solidity-cborutils
50 MIT License
51 Copyright (c) 2018 SmartContract ChainLink, Ltd.
52 Permission is hereby granted, free of charge, to any person obtaining a copy
53 of this software and associated documentation files (the "Software"), to deal
54 in the Software without restriction, including without limitation the rights
55 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
56 copies of the Software, and to permit persons to whom the Software is
57 furnished to do so, subject to the following conditions:
58 The above copyright notice and this permission notice shall be included in all
59 copies or substantial portions of the Software.
60 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
61 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
62 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
63 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
64 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
65 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
66 SOFTWARE.
67  */
68 
69 library Buffer {
70     struct buffer {
71         bytes buf;
72         uint capacity;
73     }
74 
75     function init(buffer memory buf, uint capacity) internal pure {
76         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
77         // Allocate space for the buffer data
78         buf.capacity = capacity;
79         assembly {
80             let ptr := mload(0x40)
81             mstore(buf, ptr)
82             mstore(0x40, add(ptr, capacity))
83         }
84     }
85 
86     function resize(buffer memory buf, uint capacity) private pure {
87         bytes memory oldbuf = buf.buf;
88         init(buf, capacity);
89         append(buf, oldbuf);
90     }
91 
92     function max(uint a, uint b) private pure returns(uint) {
93         if(a > b) {
94             return a;
95         }
96         return b;
97     }
98 
99     /**
100      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
101      *      would exceed the capacity of the buffer.
102      * @param buf The buffer to append to.
103      * @param data The data to append.
104      * @return The original buffer.
105      */
106     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
107         if(data.length + buf.buf.length > buf.capacity) {
108             resize(buf, max(buf.capacity, data.length) * 2);
109         }
110 
111         uint dest;
112         uint src;
113         uint len = data.length;
114         assembly {
115             // Memory address of the buffer data
116             let bufptr := mload(buf)
117             // Length of existing buffer data
118             let buflen := mload(bufptr)
119             // Start address = buffer address + buffer length + sizeof(buffer length)
120             dest := add(add(bufptr, buflen), 32)
121             // Update buffer length
122             mstore(bufptr, add(buflen, mload(data)))
123             src := add(data, 32)
124         }
125 
126         // Copy word-length chunks while possible
127         for(; len >= 32; len -= 32) {
128             assembly {
129                 mstore(dest, mload(src))
130             }
131             dest += 32;
132             src += 32;
133         }
134 
135         // Copy remaining bytes
136         uint mask = 256 ** (32 - len) - 1;
137         assembly {
138             let srcpart := and(mload(src), not(mask))
139             let destpart := and(mload(dest), mask)
140             mstore(dest, or(destpart, srcpart))
141         }
142 
143         return buf;
144     }
145 
146     /**
147      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
148      * exceed the capacity of the buffer.
149      * @param buf The buffer to append to.
150      * @param data The data to append.
151      * @return The original buffer.
152      */
153     function append(buffer memory buf, uint8 data) internal pure {
154         if(buf.buf.length + 1 > buf.capacity) {
155             resize(buf, buf.capacity * 2);
156         }
157 
158         assembly {
159             // Memory address of the buffer data
160             let bufptr := mload(buf)
161             // Length of existing buffer data
162             let buflen := mload(bufptr)
163             // Address = buffer address + buffer length + sizeof(buffer length)
164             let dest := add(add(bufptr, buflen), 32)
165             mstore8(dest, data)
166             // Update buffer length
167             mstore(bufptr, add(buflen, 1))
168         }
169     }
170 
171     /**
172      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
173      * exceed the capacity of the buffer.
174      * @param buf The buffer to append to.
175      * @param data The data to append.
176      * @return The original buffer.
177      */
178     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
179         if(len + buf.buf.length > buf.capacity) {
180             resize(buf, max(buf.capacity, len) * 2);
181         }
182 
183         uint mask = 256 ** len - 1;
184         assembly {
185             // Memory address of the buffer data
186             let bufptr := mload(buf)
187             // Length of existing buffer data
188             let buflen := mload(bufptr)
189             // Address = buffer address + buffer length + sizeof(buffer length) + len
190             let dest := add(add(bufptr, buflen), len)
191             mstore(dest, or(and(mload(dest), not(mask)), data))
192             // Update buffer length
193             mstore(bufptr, add(buflen, len))
194         }
195         return buf;
196     }
197 }
198 
199 library CBOR {
200     using Buffer for Buffer.buffer;
201 
202     uint8 private constant MAJOR_TYPE_INT = 0;
203     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
204     uint8 private constant MAJOR_TYPE_BYTES = 2;
205     uint8 private constant MAJOR_TYPE_STRING = 3;
206     uint8 private constant MAJOR_TYPE_ARRAY = 4;
207     uint8 private constant MAJOR_TYPE_MAP = 5;
208     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
209 
210     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
211         if(value <= 23) {
212             buf.append(uint8((major << 5) | value));
213         } else if(value <= 0xFF) {
214             buf.append(uint8((major << 5) | 24));
215             buf.appendInt(value, 1);
216         } else if(value <= 0xFFFF) {
217             buf.append(uint8((major << 5) | 25));
218             buf.appendInt(value, 2);
219         } else if(value <= 0xFFFFFFFF) {
220             buf.append(uint8((major << 5) | 26));
221             buf.appendInt(value, 4);
222         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
223             buf.append(uint8((major << 5) | 27));
224             buf.appendInt(value, 8);
225         }
226     }
227 
228     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
229         buf.append(uint8((major << 5) | 31));
230     }
231 
232     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
233         encodeType(buf, MAJOR_TYPE_INT, value);
234     }
235 
236     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
237         if(value >= 0) {
238             encodeType(buf, MAJOR_TYPE_INT, uint(value));
239         } else {
240             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
241         }
242     }
243 
244     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
245         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
246         buf.append(value);
247     }
248 
249     function encodeString(Buffer.buffer memory buf, string value) internal pure {
250         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
251         buf.append(bytes(value));
252     }
253 
254     function startArray(Buffer.buffer memory buf) internal pure {
255         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
256     }
257 
258     function startMap(Buffer.buffer memory buf) internal pure {
259         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
260     }
261 
262     function endSequence(Buffer.buffer memory buf) internal pure {
263         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
264     }
265 }
266 
267 /*
268 End solidity-cborutils
269  */
270 
271 contract usingOraclize {
272     uint constant day = 60*60*24;
273     uint constant week = 60*60*24*7;
274     uint constant month = 60*60*24*30;
275     byte constant proofType_NONE = 0x00;
276     byte constant proofType_TLSNotary = 0x10;
277     byte constant proofType_Android = 0x20;
278     byte constant proofType_Ledger = 0x30;
279     byte constant proofType_Native = 0xF0;
280     byte constant proofStorage_IPFS = 0x01;
281     uint8 constant networkID_auto = 0;
282     uint8 constant networkID_mainnet = 1;
283     uint8 constant networkID_testnet = 2;
284     uint8 constant networkID_morden = 2;
285     uint8 constant networkID_consensys = 161;
286 
287     OraclizeAddrResolverI OAR;
288 
289     OraclizeI oraclize;
290     modifier oraclizeAPI {
291         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
292             oraclize_setNetwork(networkID_auto);
293 
294         if(address(oraclize) != OAR.getAddress())
295             oraclize = OraclizeI(OAR.getAddress());
296 
297         _;
298     }
299     modifier coupon(string code){
300         oraclize = OraclizeI(OAR.getAddress());
301         _;
302     }
303 
304     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
305       return oraclize_setNetwork();
306       networkID; // silence the warning and remain backwards compatible
307     }
308     function oraclize_setNetwork() internal returns(bool){
309         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
310             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
311             oraclize_setNetworkName("eth_mainnet");
312             return true;
313         }
314         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
315             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
316             oraclize_setNetworkName("eth_ropsten3");
317             return true;
318         }
319         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
320             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
321             oraclize_setNetworkName("eth_kovan");
322             return true;
323         }
324         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
325             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
326             oraclize_setNetworkName("eth_rinkeby");
327             return true;
328         }
329         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
330             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
331             return true;
332         }
333         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
334             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
335             return true;
336         }
337         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
338             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
339             return true;
340         }
341         return false;
342     }
343 
344     function __callback(bytes32 myid, string result) public {
345         __callback(myid, result, new bytes(0));
346     }
347     function __callback(bytes32 myid, string result, bytes proof) public {
348       return;
349       myid; result; proof; // Silence compiler warnings
350     }
351 
352     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
353         return oraclize.getPrice(datasource);
354     }
355 
356     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
357         return oraclize.getPrice(datasource, gaslimit);
358     }
359 
360     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
361         uint price = oraclize.getPrice(datasource);
362         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
363         return oraclize.query.value(price)(0, datasource, arg);
364     }
365     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
366         uint price = oraclize.getPrice(datasource);
367         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
368         return oraclize.query.value(price)(timestamp, datasource, arg);
369     }
370     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
371         uint price = oraclize.getPrice(datasource, gaslimit);
372         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
373         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
374     }
375     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
376         uint price = oraclize.getPrice(datasource, gaslimit);
377         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
378         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
379     }
380     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
381         uint price = oraclize.getPrice(datasource);
382         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
383         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
384     }
385     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
386         uint price = oraclize.getPrice(datasource);
387         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
388         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
389     }
390     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
391         uint price = oraclize.getPrice(datasource, gaslimit);
392         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
393         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
394     }
395     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
396         uint price = oraclize.getPrice(datasource, gaslimit);
397         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
398         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
399     }
400     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
401         uint price = oraclize.getPrice(datasource);
402         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
403         bytes memory args = stra2cbor(argN);
404         return oraclize.queryN.value(price)(0, datasource, args);
405     }
406     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
407         uint price = oraclize.getPrice(datasource);
408         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
409         bytes memory args = stra2cbor(argN);
410         return oraclize.queryN.value(price)(timestamp, datasource, args);
411     }
412     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
413         uint price = oraclize.getPrice(datasource, gaslimit);
414         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
415         bytes memory args = stra2cbor(argN);
416         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
417     }
418     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
419         uint price = oraclize.getPrice(datasource, gaslimit);
420         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
421         bytes memory args = stra2cbor(argN);
422         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
423     }
424     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
425         string[] memory dynargs = new string[](1);
426         dynargs[0] = args[0];
427         return oraclize_query(datasource, dynargs);
428     }
429     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
430         string[] memory dynargs = new string[](1);
431         dynargs[0] = args[0];
432         return oraclize_query(timestamp, datasource, dynargs);
433     }
434     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
435         string[] memory dynargs = new string[](1);
436         dynargs[0] = args[0];
437         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
438     }
439     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
440         string[] memory dynargs = new string[](1);
441         dynargs[0] = args[0];
442         return oraclize_query(datasource, dynargs, gaslimit);
443     }
444 
445     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
446         string[] memory dynargs = new string[](2);
447         dynargs[0] = args[0];
448         dynargs[1] = args[1];
449         return oraclize_query(datasource, dynargs);
450     }
451     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
452         string[] memory dynargs = new string[](2);
453         dynargs[0] = args[0];
454         dynargs[1] = args[1];
455         return oraclize_query(timestamp, datasource, dynargs);
456     }
457     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
458         string[] memory dynargs = new string[](2);
459         dynargs[0] = args[0];
460         dynargs[1] = args[1];
461         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
462     }
463     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
464         string[] memory dynargs = new string[](2);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         return oraclize_query(datasource, dynargs, gaslimit);
468     }
469     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
470         string[] memory dynargs = new string[](3);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         dynargs[2] = args[2];
474         return oraclize_query(datasource, dynargs);
475     }
476     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
477         string[] memory dynargs = new string[](3);
478         dynargs[0] = args[0];
479         dynargs[1] = args[1];
480         dynargs[2] = args[2];
481         return oraclize_query(timestamp, datasource, dynargs);
482     }
483     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
484         string[] memory dynargs = new string[](3);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         dynargs[2] = args[2];
488         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
489     }
490     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
491         string[] memory dynargs = new string[](3);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         dynargs[2] = args[2];
495         return oraclize_query(datasource, dynargs, gaslimit);
496     }
497 
498     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
499         string[] memory dynargs = new string[](4);
500         dynargs[0] = args[0];
501         dynargs[1] = args[1];
502         dynargs[2] = args[2];
503         dynargs[3] = args[3];
504         return oraclize_query(datasource, dynargs);
505     }
506     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
507         string[] memory dynargs = new string[](4);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         dynargs[3] = args[3];
512         return oraclize_query(timestamp, datasource, dynargs);
513     }
514     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
515         string[] memory dynargs = new string[](4);
516         dynargs[0] = args[0];
517         dynargs[1] = args[1];
518         dynargs[2] = args[2];
519         dynargs[3] = args[3];
520         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
521     }
522     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
523         string[] memory dynargs = new string[](4);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         dynargs[3] = args[3];
528         return oraclize_query(datasource, dynargs, gaslimit);
529     }
530     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
531         string[] memory dynargs = new string[](5);
532         dynargs[0] = args[0];
533         dynargs[1] = args[1];
534         dynargs[2] = args[2];
535         dynargs[3] = args[3];
536         dynargs[4] = args[4];
537         return oraclize_query(datasource, dynargs);
538     }
539     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
540         string[] memory dynargs = new string[](5);
541         dynargs[0] = args[0];
542         dynargs[1] = args[1];
543         dynargs[2] = args[2];
544         dynargs[3] = args[3];
545         dynargs[4] = args[4];
546         return oraclize_query(timestamp, datasource, dynargs);
547     }
548     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
549         string[] memory dynargs = new string[](5);
550         dynargs[0] = args[0];
551         dynargs[1] = args[1];
552         dynargs[2] = args[2];
553         dynargs[3] = args[3];
554         dynargs[4] = args[4];
555         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
556     }
557     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
558         string[] memory dynargs = new string[](5);
559         dynargs[0] = args[0];
560         dynargs[1] = args[1];
561         dynargs[2] = args[2];
562         dynargs[3] = args[3];
563         dynargs[4] = args[4];
564         return oraclize_query(datasource, dynargs, gaslimit);
565     }
566     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
567         uint price = oraclize.getPrice(datasource);
568         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
569         bytes memory args = ba2cbor(argN);
570         return oraclize.queryN.value(price)(0, datasource, args);
571     }
572     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
573         uint price = oraclize.getPrice(datasource);
574         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
575         bytes memory args = ba2cbor(argN);
576         return oraclize.queryN.value(price)(timestamp, datasource, args);
577     }
578     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
579         uint price = oraclize.getPrice(datasource, gaslimit);
580         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
581         bytes memory args = ba2cbor(argN);
582         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
583     }
584     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
585         uint price = oraclize.getPrice(datasource, gaslimit);
586         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
587         bytes memory args = ba2cbor(argN);
588         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
589     }
590     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
591         bytes[] memory dynargs = new bytes[](1);
592         dynargs[0] = args[0];
593         return oraclize_query(datasource, dynargs);
594     }
595     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
596         bytes[] memory dynargs = new bytes[](1);
597         dynargs[0] = args[0];
598         return oraclize_query(timestamp, datasource, dynargs);
599     }
600     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
601         bytes[] memory dynargs = new bytes[](1);
602         dynargs[0] = args[0];
603         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
604     }
605     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
606         bytes[] memory dynargs = new bytes[](1);
607         dynargs[0] = args[0];
608         return oraclize_query(datasource, dynargs, gaslimit);
609     }
610 
611     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
612         bytes[] memory dynargs = new bytes[](2);
613         dynargs[0] = args[0];
614         dynargs[1] = args[1];
615         return oraclize_query(datasource, dynargs);
616     }
617     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
618         bytes[] memory dynargs = new bytes[](2);
619         dynargs[0] = args[0];
620         dynargs[1] = args[1];
621         return oraclize_query(timestamp, datasource, dynargs);
622     }
623     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
624         bytes[] memory dynargs = new bytes[](2);
625         dynargs[0] = args[0];
626         dynargs[1] = args[1];
627         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
628     }
629     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
630         bytes[] memory dynargs = new bytes[](2);
631         dynargs[0] = args[0];
632         dynargs[1] = args[1];
633         return oraclize_query(datasource, dynargs, gaslimit);
634     }
635     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
636         bytes[] memory dynargs = new bytes[](3);
637         dynargs[0] = args[0];
638         dynargs[1] = args[1];
639         dynargs[2] = args[2];
640         return oraclize_query(datasource, dynargs);
641     }
642     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
643         bytes[] memory dynargs = new bytes[](3);
644         dynargs[0] = args[0];
645         dynargs[1] = args[1];
646         dynargs[2] = args[2];
647         return oraclize_query(timestamp, datasource, dynargs);
648     }
649     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
650         bytes[] memory dynargs = new bytes[](3);
651         dynargs[0] = args[0];
652         dynargs[1] = args[1];
653         dynargs[2] = args[2];
654         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
655     }
656     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
657         bytes[] memory dynargs = new bytes[](3);
658         dynargs[0] = args[0];
659         dynargs[1] = args[1];
660         dynargs[2] = args[2];
661         return oraclize_query(datasource, dynargs, gaslimit);
662     }
663 
664     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
665         bytes[] memory dynargs = new bytes[](4);
666         dynargs[0] = args[0];
667         dynargs[1] = args[1];
668         dynargs[2] = args[2];
669         dynargs[3] = args[3];
670         return oraclize_query(datasource, dynargs);
671     }
672     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
673         bytes[] memory dynargs = new bytes[](4);
674         dynargs[0] = args[0];
675         dynargs[1] = args[1];
676         dynargs[2] = args[2];
677         dynargs[3] = args[3];
678         return oraclize_query(timestamp, datasource, dynargs);
679     }
680     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
681         bytes[] memory dynargs = new bytes[](4);
682         dynargs[0] = args[0];
683         dynargs[1] = args[1];
684         dynargs[2] = args[2];
685         dynargs[3] = args[3];
686         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
687     }
688     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
689         bytes[] memory dynargs = new bytes[](4);
690         dynargs[0] = args[0];
691         dynargs[1] = args[1];
692         dynargs[2] = args[2];
693         dynargs[3] = args[3];
694         return oraclize_query(datasource, dynargs, gaslimit);
695     }
696     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
697         bytes[] memory dynargs = new bytes[](5);
698         dynargs[0] = args[0];
699         dynargs[1] = args[1];
700         dynargs[2] = args[2];
701         dynargs[3] = args[3];
702         dynargs[4] = args[4];
703         return oraclize_query(datasource, dynargs);
704     }
705     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
706         bytes[] memory dynargs = new bytes[](5);
707         dynargs[0] = args[0];
708         dynargs[1] = args[1];
709         dynargs[2] = args[2];
710         dynargs[3] = args[3];
711         dynargs[4] = args[4];
712         return oraclize_query(timestamp, datasource, dynargs);
713     }
714     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
715         bytes[] memory dynargs = new bytes[](5);
716         dynargs[0] = args[0];
717         dynargs[1] = args[1];
718         dynargs[2] = args[2];
719         dynargs[3] = args[3];
720         dynargs[4] = args[4];
721         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
722     }
723     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
724         bytes[] memory dynargs = new bytes[](5);
725         dynargs[0] = args[0];
726         dynargs[1] = args[1];
727         dynargs[2] = args[2];
728         dynargs[3] = args[3];
729         dynargs[4] = args[4];
730         return oraclize_query(datasource, dynargs, gaslimit);
731     }
732 
733     function oraclize_cbAddress() oraclizeAPI internal returns (address){
734         return oraclize.cbAddress();
735     }
736     function oraclize_setProof(byte proofP) oraclizeAPI internal {
737         return oraclize.setProofType(proofP);
738     }
739     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
740         return oraclize.setCustomGasPrice(gasPrice);
741     }
742 
743     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
744         return oraclize.randomDS_getSessionPubKeyHash();
745     }
746 
747     function getCodeSize(address _addr) constant internal returns(uint _size) {
748         assembly {
749             _size := extcodesize(_addr)
750         }
751     }
752 
753     function parseAddr(string _a) internal pure returns (address){
754         bytes memory tmp = bytes(_a);
755         uint160 iaddr = 0;
756         uint160 b1;
757         uint160 b2;
758         for (uint i=2; i<2+2*20; i+=2){
759             iaddr *= 256;
760             b1 = uint160(tmp[i]);
761             b2 = uint160(tmp[i+1]);
762             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
763             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
764             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
765             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
766             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
767             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
768             iaddr += (b1*16+b2);
769         }
770         return address(iaddr);
771     }
772 
773     function strCompare(string _a, string _b) internal pure returns (int) {
774         bytes memory a = bytes(_a);
775         bytes memory b = bytes(_b);
776         uint minLength = a.length;
777         if (b.length < minLength) minLength = b.length;
778         for (uint i = 0; i < minLength; i ++)
779             if (a[i] < b[i])
780                 return -1;
781             else if (a[i] > b[i])
782                 return 1;
783         if (a.length < b.length)
784             return -1;
785         else if (a.length > b.length)
786             return 1;
787         else
788             return 0;
789     }
790 
791     function indexOf(string _haystack, string _needle) internal pure returns (int) {
792         bytes memory h = bytes(_haystack);
793         bytes memory n = bytes(_needle);
794         if(h.length < 1 || n.length < 1 || (n.length > h.length))
795             return -1;
796         else if(h.length > (2**128 -1))
797             return -1;
798         else
799         {
800             uint subindex = 0;
801             for (uint i = 0; i < h.length; i ++)
802             {
803                 if (h[i] == n[0])
804                 {
805                     subindex = 1;
806                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
807                     {
808                         subindex++;
809                     }
810                     if(subindex == n.length)
811                         return int(i);
812                 }
813             }
814             return -1;
815         }
816     }
817 
818     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
819         bytes memory _ba = bytes(_a);
820         bytes memory _bb = bytes(_b);
821         bytes memory _bc = bytes(_c);
822         bytes memory _bd = bytes(_d);
823         bytes memory _be = bytes(_e);
824         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
825         bytes memory babcde = bytes(abcde);
826         uint k = 0;
827         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
828         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
829         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
830         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
831         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
832         return string(babcde);
833     }
834 
835     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
836         return strConcat(_a, _b, _c, _d, "");
837     }
838 
839     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
840         return strConcat(_a, _b, _c, "", "");
841     }
842 
843     function strConcat(string _a, string _b) internal pure returns (string) {
844         return strConcat(_a, _b, "", "", "");
845     }
846 
847     // parseInt
848     function parseInt(string _a) internal pure returns (uint) {
849         return parseInt(_a, 0);
850     }
851 
852     // parseInt(parseFloat*10^_b)
853     function parseInt(string _a, uint _b) internal pure returns (uint) {
854         bytes memory bresult = bytes(_a);
855         uint mint = 0;
856         bool decimals = false;
857         for (uint i=0; i<bresult.length; i++){
858             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
859                 if (decimals){
860                    if (_b == 0) break;
861                     else _b--;
862                 }
863                 mint *= 10;
864                 mint += uint(bresult[i]) - 48;
865             } else if (bresult[i] == 46) decimals = true;
866         }
867         if (_b > 0) mint *= 10**_b;
868         return mint;
869     }
870 
871     function uint2str(uint i) internal pure returns (string){
872         if (i == 0) return "0";
873         uint j = i;
874         uint len;
875         while (j != 0){
876             len++;
877             j /= 10;
878         }
879         bytes memory bstr = new bytes(len);
880         uint k = len - 1;
881         while (i != 0){
882             bstr[k--] = byte(48 + i % 10);
883             i /= 10;
884         }
885         return string(bstr);
886     }
887 
888     using CBOR for Buffer.buffer;
889     function stra2cbor(string[] arr) internal pure returns (bytes) {
890         Buffer.buffer memory buf;
891         Buffer.init(buf, 1024);
892         buf.startArray();
893         for (uint i = 0; i < arr.length; i++) {
894             buf.encodeString(arr[i]);
895         }
896         buf.endSequence();
897         return buf.buf;
898     }
899 
900     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
901         Buffer.buffer memory buf;
902         Buffer.init(buf, 1024);
903         buf.startArray();
904         for (uint i = 0; i < arr.length; i++) {
905             buf.encodeBytes(arr[i]);
906         }
907         buf.endSequence();
908         return buf.buf;
909     }
910 
911     string oraclize_network_name;
912     function oraclize_setNetworkName(string _network_name) internal {
913         oraclize_network_name = _network_name;
914     }
915 
916     function oraclize_getNetworkName() internal view returns (string) {
917         return oraclize_network_name;
918     }
919 
920     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
921         require((_nbytes > 0) && (_nbytes <= 32));
922         // Convert from seconds to ledger timer ticks
923         _delay *= 10;
924         bytes memory nbytes = new bytes(1);
925         nbytes[0] = byte(_nbytes);
926         bytes memory unonce = new bytes(32);
927         bytes memory sessionKeyHash = new bytes(32);
928         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
929         assembly {
930             mstore(unonce, 0x20)
931             // the following variables can be relaxed
932             // check relaxed random contract under ethereum-examples repo
933             // for an idea on how to override and replace comit hash vars
934             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
935             mstore(sessionKeyHash, 0x20)
936             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
937         }
938         bytes memory delay = new bytes(32);
939         assembly {
940             mstore(add(delay, 0x20), _delay)
941         }
942 
943         bytes memory delay_bytes8 = new bytes(8);
944         copyBytes(delay, 24, 8, delay_bytes8, 0);
945 
946         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
947         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
948 
949         bytes memory delay_bytes8_left = new bytes(8);
950 
951         assembly {
952             let x := mload(add(delay_bytes8, 0x20))
953             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
954             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
955             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
956             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
957             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
958             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
959             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
960             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
961 
962         }
963 
964         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
965         return queryId;
966     }
967 
968     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
969         oraclize_randomDS_args[queryId] = commitment;
970     }
971 
972     mapping(bytes32=>bytes32) oraclize_randomDS_args;
973     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
974 
975     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
976         bool sigok;
977         address signer;
978 
979         bytes32 sigr;
980         bytes32 sigs;
981 
982         bytes memory sigr_ = new bytes(32);
983         uint offset = 4+(uint(dersig[3]) - 0x20);
984         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
985         bytes memory sigs_ = new bytes(32);
986         offset += 32 + 2;
987         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
988 
989         assembly {
990             sigr := mload(add(sigr_, 32))
991             sigs := mload(add(sigs_, 32))
992         }
993 
994 
995         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
996         if (address(keccak256(pubkey)) == signer) return true;
997         else {
998             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
999             return (address(keccak256(pubkey)) == signer);
1000         }
1001     }
1002 
1003     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1004         bool sigok;
1005 
1006         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1007         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1008         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1009 
1010         bytes memory appkey1_pubkey = new bytes(64);
1011         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1012 
1013         bytes memory tosign2 = new bytes(1+65+32);
1014         tosign2[0] = byte(1); //role
1015         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1016         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1017         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1018         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1019 
1020         if (sigok == false) return false;
1021 
1022 
1023         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1024         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1025 
1026         bytes memory tosign3 = new bytes(1+65);
1027         tosign3[0] = 0xFE;
1028         copyBytes(proof, 3, 65, tosign3, 1);
1029 
1030         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1031         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1032 
1033         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1034 
1035         return sigok;
1036     }
1037 
1038     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1039         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1040         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1041 
1042         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1043         require(proofVerified);
1044 
1045         _;
1046     }
1047 
1048     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1049         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1050         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1051 
1052         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1053         if (proofVerified == false) return 2;
1054 
1055         return 0;
1056     }
1057 
1058     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1059         bool match_ = true;
1060 
1061         require(prefix.length == n_random_bytes);
1062 
1063         for (uint256 i=0; i< n_random_bytes; i++) {
1064             if (content[i] != prefix[i]) match_ = false;
1065         }
1066 
1067         return match_;
1068     }
1069 
1070     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1071 
1072         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1073         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1074         bytes memory keyhash = new bytes(32);
1075         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1076         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1077 
1078         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1079         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1080 
1081         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1082         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1083 
1084         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1085         // This is to verify that the computed args match with the ones specified in the query.
1086         bytes memory commitmentSlice1 = new bytes(8+1+32);
1087         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1088 
1089         bytes memory sessionPubkey = new bytes(64);
1090         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1091         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1092 
1093         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1094         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1095             delete oraclize_randomDS_args[queryId];
1096         } else return false;
1097 
1098 
1099         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1100         bytes memory tosign1 = new bytes(32+8+1+32);
1101         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1102         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1103 
1104         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1105         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1106             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1107         }
1108 
1109         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1110     }
1111 
1112     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1113     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1114         uint minLength = length + toOffset;
1115 
1116         // Buffer too small
1117         require(to.length >= minLength); // Should be a better way?
1118 
1119         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1120         uint i = 32 + fromOffset;
1121         uint j = 32 + toOffset;
1122 
1123         while (i < (32 + fromOffset + length)) {
1124             assembly {
1125                 let tmp := mload(add(from, i))
1126                 mstore(add(to, j), tmp)
1127             }
1128             i += 32;
1129             j += 32;
1130         }
1131 
1132         return to;
1133     }
1134 
1135     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1136     // Duplicate Solidity's ecrecover, but catching the CALL return value
1137     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1138         // We do our own memory management here. Solidity uses memory offset
1139         // 0x40 to store the current end of memory. We write past it (as
1140         // writes are memory extensions), but don't update the offset so
1141         // Solidity will reuse it. The memory used here is only needed for
1142         // this context.
1143 
1144         // FIXME: inline assembly can't access return values
1145         bool ret;
1146         address addr;
1147 
1148         assembly {
1149             let size := mload(0x40)
1150             mstore(size, hash)
1151             mstore(add(size, 32), v)
1152             mstore(add(size, 64), r)
1153             mstore(add(size, 96), s)
1154 
1155             // NOTE: we can reuse the request memory because we deal with
1156             //       the return code
1157             ret := call(3000, 1, 0, size, 128, size, 32)
1158             addr := mload(size)
1159         }
1160 
1161         return (ret, addr);
1162     }
1163 
1164     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1165     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1166         bytes32 r;
1167         bytes32 s;
1168         uint8 v;
1169 
1170         if (sig.length != 65)
1171           return (false, 0);
1172 
1173         // The signature format is a compact form of:
1174         //   {bytes32 r}{bytes32 s}{uint8 v}
1175         // Compact means, uint8 is not padded to 32 bytes.
1176         assembly {
1177             r := mload(add(sig, 32))
1178             s := mload(add(sig, 64))
1179 
1180             // Here we are loading the last 32 bytes. We exploit the fact that
1181             // 'mload' will pad with zeroes if we overread.
1182             // There is no 'mload8' to do this, but that would be nicer.
1183             v := byte(0, mload(add(sig, 96)))
1184 
1185             // Alternative solution:
1186             // 'byte' is not working due to the Solidity parser, so lets
1187             // use the second best option, 'and'
1188             // v := and(mload(add(sig, 65)), 255)
1189         }
1190 
1191         // albeit non-transactional signatures are not specified by the YP, one would expect it
1192         // to match the YP range of [27, 28]
1193         //
1194         // geth uses [0, 1] and some clients have followed. This might change, see:
1195         //  https://github.com/ethereum/go-ethereum/issues/2053
1196         if (v < 27)
1197           v += 27;
1198 
1199         if (v != 27 && v != 28)
1200             return (false, 0);
1201 
1202         return safer_ecrecover(hash, v, r, s);
1203     }
1204 
1205 }
1206 // </ORACLIZE_API>
1207 
1208 contract SafeMath {
1209     function safeToAdd(uint a, uint b) pure internal returns (bool) {
1210         return (a + b >= a);
1211     }
1212     function safeAdd(uint a, uint b) pure internal returns (uint) {
1213         require(safeToAdd(a, b));
1214         return a + b;
1215     }
1216 
1217     function safeToSubtract(uint a, uint b) pure internal returns (bool) {
1218         return (b <= a);
1219     }
1220 
1221     function safeSub(uint a, uint b) pure internal returns (uint) {
1222         require(safeToSubtract(a, b));
1223         return a - b;
1224     }
1225 }
1226 
1227 contract DiceRoll is SafeMath,usingOraclize {
1228 
1229     address public owner;
1230     uint8 constant public maxNumber = 99;
1231     uint8 constant public minNumber = 1;
1232 
1233     bool public gamePaused = false;
1234     bool public jackpotPaused = false;
1235     bool public refundPaused = false;
1236 
1237     uint256 public contractBalance;
1238     uint16 public houseEdge;
1239     uint256 public maxProfit;
1240     uint16 public maxProfitAsPercentOfHouse;
1241     uint256 public minBet;
1242     uint256 public maxBet;
1243     uint16 public jackpotOfHouseEdge;
1244     uint256 public minJackpotBet;
1245     
1246     uint256 public jackpotBlance;
1247     address[] public jackpotPlayer;
1248     uint256 public JackpotPeriods = 1;
1249     uint64 public nextJackpotTime;
1250     uint16 public jackpotPersent = 100;
1251     
1252     uint256 public totalWeiWon;
1253     uint256 public totalWeiWagered;
1254 
1255     mapping (bytes32 => address) playerAddress;
1256     mapping (bytes32 => uint256) playerBetAmount;
1257     mapping (bytes32 => uint8) playerNumberStart;
1258     mapping (bytes32 => uint8) playerNumberEnd;
1259 
1260     uint256 public oraclizeGasLimit;
1261     uint public oraclizeFee;
1262     uint seed;
1263 
1264     modifier betIsValid(uint256 _betSize, uint8 _start, uint8 _end) {
1265         require(_betSize >= minBet && _betSize <= maxBet && _start >= minNumber && _end <= maxNumber && _start < _end);
1266         _;
1267     }
1268     
1269     modifier oddEvenBetIsValid(uint256 _betSize, uint8 _oddeven) {
1270         require(_betSize >= minBet && _betSize <= maxBet && (_oddeven == 1 || _oddeven == 0));
1271         _;
1272     }
1273 
1274     modifier gameIsActive {
1275         require(!gamePaused);
1276         _;
1277     }
1278     
1279 
1280     modifier jackpotAreActive {
1281         require(!jackpotPaused);
1282         _;
1283     }
1284 
1285     modifier onlyOwner {
1286         require(msg.sender == owner);
1287         _;
1288     }
1289 
1290     modifier onlyOraclize {
1291         require(msg.sender == oraclize_cbAddress());
1292         _;
1293     }
1294 
1295     event LogResult(bytes32 indexed QueryId, address indexed Address, uint8 DiceResult, uint256 Value, uint8 Status, uint8 Start, uint8 End, uint8 OddEven, uint256 BetValue);
1296     event LogRefund(bytes32 indexed QueryId, uint256 Amount);
1297     event LogJackpot(bytes32 indexed QueryId, address indexed Address, uint256 jackpotValue);
1298     event LogOwnerTransfer(address SentToAddress, uint256 AmountTransferred);
1299     event SendJackpotSuccesss(address indexed winner, uint256 amount, uint256 JackpotPeriods);
1300     
1301 
1302     function() public payable{
1303         contractBalance = safeAdd(contractBalance, msg.value);
1304         setMaxProfit();
1305     }
1306 
1307     function DiceRoll() public {
1308         owner = msg.sender;
1309         houseEdge = 20; //2%
1310         maxProfitAsPercentOfHouse = 100; //10%
1311         minBet = 0.1 ether;
1312         maxBet = 1 ether;
1313         jackpotOfHouseEdge = 500; //50%
1314         minJackpotBet = 0.1 ether;
1315         jackpotPersent = 100; //10%
1316         oraclizeGasLimit = 300000;
1317         oraclizeFee = 1200000000000000;// 0.0012 ether
1318         oraclize_setCustomGasPrice(4000000000);
1319         nextJackpotTime = uint64(block.timestamp);
1320         oraclize_setProof(proofType_Ledger);
1321         
1322     }
1323 
1324     function playerRoll(uint8 start, uint8 end) public payable gameIsActive betIsValid(msg.value, start, end) {
1325         totalWeiWagered += msg.value;
1326         bytes32 queryId = oraclize_newRandomDSQuery(0, 30, oraclizeGasLimit);
1327         playerAddress[queryId] = msg.sender;
1328         playerBetAmount[queryId] = msg.value;
1329         playerNumberStart[queryId] = start;
1330         playerNumberEnd[queryId] = end;
1331         contractBalance = safeSub(contractBalance,oraclizeFee);
1332     }
1333 
1334     function oddEven(uint8 oddeven) public payable gameIsActive oddEvenBetIsValid(msg.value, oddeven) {
1335         totalWeiWagered += msg.value;
1336         bytes32 queryId = oraclize_newRandomDSQuery(0, 30, oraclizeGasLimit);
1337         playerAddress[queryId] = msg.sender;
1338         playerBetAmount[queryId] = msg.value;
1339         playerNumberStart[queryId] = oddeven;
1340         playerNumberEnd[queryId] = 0;
1341         contractBalance = safeSub(contractBalance,oraclizeFee);
1342     }
1343 
1344 
1345     function __callback(bytes32 queryId, string result, bytes proof) public onlyOraclize {
1346         if (oraclize_randomDS_proofVerify__returnCode(queryId, result, proof) != 0) {
1347             // the proof verification has failed
1348             if(!refundPaused){
1349                 playerAddress[queryId].transfer(playerBetAmount[queryId]);
1350                 LogRefund(queryId, playerBetAmount[queryId]);
1351             }else{
1352                 contractBalance = safeAdd(contractBalance,playerBetAmount[queryId]);
1353             }
1354         }else{
1355             uint8 tempStart = playerNumberStart[queryId];
1356             uint8 tempEnd = playerNumberEnd[queryId];
1357             address tempAddress = playerAddress[queryId];
1358             uint256 tempAmount = playerBetAmount[queryId];
1359             uint8 probability;
1360             uint256 houseEdgeFee;
1361             uint256 playerProfit;
1362             uint8 random = uint8(uint256(keccak256(result)) % 100) + 1;
1363 
1364             delete playerAddress[queryId];
1365             delete playerBetAmount[queryId];
1366             delete playerNumberStart[queryId];
1367             delete playerNumberEnd[queryId];
1368 
1369             if(tempEnd == 0){
1370                 //odd even
1371                 if(random % 2 == tempStart){
1372                     probability = 50;
1373                     playerProfit = getProfit(probability,tempAmount);
1374                     totalWeiWon = safeAdd(totalWeiWon, playerProfit);
1375                     contractBalance = safeSub(contractBalance, playerProfit);
1376                     setMaxProfit();
1377                     LogResult(queryId, tempAddress, random, playerProfit, 1, 0, 0, tempStart, tempAmount);
1378                     
1379                     houseEdgeFee = getHouseEdgeFee(probability, tempAmount);
1380                     increaseJackpot(houseEdgeFee * jackpotOfHouseEdge / 1000, queryId, tempAddress, tempAmount);
1381                     tempAddress.transfer(safeAdd(playerProfit, tempAmount));  
1382                 }else{
1383                     LogResult(queryId, tempAddress, random, 0, 0, 0, 0, tempEnd, tempAmount); 
1384                     contractBalance = safeAdd(contractBalance, (tempAmount - 1));
1385                     setMaxProfit();
1386                     tempAddress.transfer(1);
1387                 }
1388             }else if(tempEnd != 0 && tempStart != 0){
1389                 //range
1390                 if(tempStart <= random && random <= tempEnd){
1391                     probability = tempEnd - tempStart + 1;
1392                     playerProfit = getProfit(probability,tempAmount);
1393                     totalWeiWon = safeAdd(totalWeiWon, playerProfit);
1394                     contractBalance = safeSub(contractBalance, playerProfit);
1395                     setMaxProfit();
1396                     LogResult(queryId, tempAddress, random, playerProfit, 1, tempStart, tempEnd, 2, tempAmount);
1397                     
1398                     houseEdgeFee = getHouseEdgeFee(probability, tempAmount);
1399                     increaseJackpot(houseEdgeFee * jackpotOfHouseEdge / 1000, queryId, tempAddress, tempAmount);
1400                     tempAddress.transfer(safeAdd(playerProfit, tempAmount));   
1401                 }else{
1402                     LogResult(queryId, tempAddress, random, 0, 0, tempStart, tempEnd, 2, tempAmount); 
1403                     contractBalance = safeAdd(contractBalance, (tempAmount - 1));
1404                     setMaxProfit();
1405                     tempAddress.transfer(1);
1406                 }
1407             }
1408 
1409         }
1410     }
1411     
1412 
1413     function increaseJackpot(uint256 increaseAmount, bytes32 _queryId, address _address, uint256 _amount) internal {
1414         require(increaseAmount < maxProfit);
1415         LogJackpot(_queryId, _address, increaseAmount);
1416         contractBalance = safeSub(contractBalance, increaseAmount);
1417         jackpotBlance = safeAdd(jackpotBlance, increaseAmount);
1418         if(_amount >= minJackpotBet){
1419             jackpotPlayer.push(_address);
1420         }
1421     }
1422     
1423     function createWinner() public onlyOwner jackpotAreActive {
1424         uint64 tmNow = uint64(block.timestamp);
1425         require(tmNow >= nextJackpotTime);
1426         require(jackpotPlayer.length > 0);
1427         uint random = rand() % jackpotPlayer.length;
1428         address winner = jackpotPlayer[random - 1];
1429         sendJackpot(winner);
1430     }
1431     
1432     function sendJackpot(address winner) internal jackpotAreActive {
1433         uint256 amount = jackpotBlance * jackpotPersent / 1000;
1434         require(jackpotBlance > amount);
1435         jackpotBlance = safeSub(jackpotBlance, amount);
1436         jackpotPlayer.length = 0;
1437         nextJackpotTime = uint64(block.timestamp) + 72000;
1438         winner.transfer(amount);
1439         SendJackpotSuccesss(winner, amount, JackpotPeriods);
1440         JackpotPeriods += 1;
1441     }
1442     
1443     function sendValueToJackpot() payable public jackpotAreActive {
1444         jackpotBlance = safeAdd(jackpotBlance, msg.value);
1445     }
1446     
1447     function getHouseEdgeFee(uint8 _probability, uint256 _betValue) view internal returns (uint256){
1448         return (_betValue * (100 - _probability) / _probability + _betValue) * houseEdge / 1000;
1449     }
1450 
1451     function getProfit(uint8 _probability, uint256 _betValue) view internal returns (uint256){
1452         uint256 tempProfit = ((_betValue * (100 - _probability) / _probability + _betValue) * (1000 - houseEdge) / 1000) - _betValue;
1453         // tempProfit = tempProfit - oraclizeFee;
1454         if(tempProfit > maxProfit) tempProfit = maxProfit;
1455         return tempProfit;
1456     }
1457 
1458 
1459     function rand() internal returns (uint256) {
1460         seed = uint256(keccak256(seed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
1461         return seed;
1462     }
1463 
1464     function setMaxProfit() internal {
1465         maxProfit = contractBalance * maxProfitAsPercentOfHouse / 1000;  
1466     }
1467     
1468     function ownerSetOraclizeGas(uint newPrice, uint newGasLimit) public onlyOwner{
1469         require(newGasLimit > 50000 && newGasLimit <300000);
1470         require(newPrice > 1000000000 && newPrice <15000000000);// <15Gwei >1Gwei
1471         oraclize_setCustomGasPrice(newPrice);
1472         oraclizeGasLimit = newGasLimit;
1473         oraclizeFee = newGasLimit * newPrice;// 0.0012 ether
1474     }
1475 
1476     function ownerSetHouseEdge(uint16 newHouseEdge) public onlyOwner{
1477         require(newHouseEdge <= 1000);
1478         houseEdge = newHouseEdge;
1479     }
1480 
1481     function ownerSetMinJackpoBet(uint256 newVal) public onlyOwner{
1482         require(newVal <= 1 ether);
1483         minJackpotBet = newVal;
1484     }
1485 
1486     function ownerSetMaxProfitAsPercentOfHouse(uint8 newMaxProfitAsPercent) public onlyOwner{
1487         require(newMaxProfitAsPercent <= 1000);
1488         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
1489         setMaxProfit();
1490     }
1491 
1492     function ownerSetMinBet(uint256 newMinimumBet) public onlyOwner{
1493         minBet = newMinimumBet;
1494     }
1495 
1496     function ownerSetMaxBet(uint256 newMaxBet) public onlyOwner{
1497         maxBet = newMaxBet;
1498     }
1499 
1500     function ownerSetJackpotOfHouseEdge(uint16 newProportion) public onlyOwner{
1501         require(newProportion < 1000);
1502         jackpotOfHouseEdge = newProportion;
1503     }
1504 
1505 
1506     function ownerPauseGame(bool newStatus) public onlyOwner{
1507         gamePaused = newStatus;
1508     }
1509 
1510     function ownerPauseJackpot(bool newStatus) public onlyOwner{
1511         jackpotPaused = newStatus;
1512     }
1513 
1514     function ownerTransferEther(address sendTo, uint256 amount) public onlyOwner{	
1515         contractBalance = safeSub(contractBalance, amount);
1516         sendTo.transfer(amount);
1517         setMaxProfit();
1518         LogOwnerTransfer(sendTo, amount);
1519     }
1520 
1521     function ownerChangeOwner(address newOwner) public onlyOwner{
1522         owner = newOwner;
1523     }
1524 
1525     function ownerkill() public onlyOwner{
1526         selfdestruct(owner);
1527     }
1528 }