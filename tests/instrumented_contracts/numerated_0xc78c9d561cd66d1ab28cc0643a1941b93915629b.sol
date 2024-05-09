1 pragma solidity ^0.4.18;
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
34 
35 // Incompatible compiler version... please select one stated within 
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
50 
51 contract OraclizeAddrResolverI {
52     function getAddress() public returns (address _addr);
53 }
54 
55 /*
56 Begin solidity-cborutils
57 
58 https://github.com/smartcontractkit/solidity-cborutils
59 
60 MIT License
61 
62 Copyright (c) 2018 SmartContract ChainLink, Ltd.
63 
64 Permission is hereby granted, free of charge, to any person obtaining a copy
65 of this software and associated documentation files (the "Software"), to deal
66 in the Software without restriction, including without limitation the rights
67 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
68 copies of the Software, and to permit persons to whom the Software is
69 furnished to do so, subject to the following conditions:
70 
71 The above copyright notice and this permission notice shall be included in all
72 copies or substantial portions of the Software.
73 
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
89     function init(buffer memory buf, uint capacity) internal pure {
90         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
91         // Allocate space for the buffer data
92         buf.capacity = capacity;
93         assembly {
94             let ptr := mload(0x40)
95             mstore(buf, ptr)
96             mstore(0x40, add(ptr, capacity))
97         }
98     }
99 
100     function resize(buffer memory buf, uint capacity) private pure {
101         bytes memory oldbuf = buf.buf;
102         init(buf, capacity);
103         append(buf, oldbuf);
104     }
105 
106     function max(uint a, uint b) private pure returns(uint) {
107         if(a > b) {
108             return a;
109         }
110         return b;
111     }
112 
113     /**
114      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
115      *      would exceed the capacity of the buffer.
116      * @param buf The buffer to append to.
117      * @param data The data to append.
118      * @return The original buffer.
119      */
120     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
121         if(data.length + buf.buf.length > buf.capacity) {
122             resize(buf, max(buf.capacity, data.length) * 2);
123         }
124 
125         uint dest;
126         uint src;
127         uint len = data.length;
128         assembly {
129             // Memory address of the buffer data
130             let bufptr := mload(buf)
131             // Length of existing buffer data
132             let buflen := mload(bufptr)
133             // Start address = buffer address + buffer length + sizeof(buffer length)
134             dest := add(add(bufptr, buflen), 32)
135             // Update buffer length
136             mstore(bufptr, add(buflen, mload(data)))
137             src := add(data, 32)
138         }
139 
140         // Copy word-length chunks while possible
141         for(; len >= 32; len -= 32) {
142             assembly {
143                 mstore(dest, mload(src))
144             }
145             dest += 32;
146             src += 32;
147         }
148 
149         // Copy remaining bytes
150         uint mask = 256 ** (32 - len) - 1;
151         assembly {
152             let srcpart := and(mload(src), not(mask))
153             let destpart := and(mload(dest), mask)
154             mstore(dest, or(destpart, srcpart))
155         }
156 
157         return buf;
158     }
159 
160     /**
161      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
162      * exceed the capacity of the buffer.
163      * @param buf The buffer to append to.
164      * @param data The data to append.
165      * @return The original buffer.
166      */
167     function append(buffer memory buf, uint8 data) internal pure {
168         if(buf.buf.length + 1 > buf.capacity) {
169             resize(buf, buf.capacity * 2);
170         }
171 
172         assembly {
173             // Memory address of the buffer data
174             let bufptr := mload(buf)
175             // Length of existing buffer data
176             let buflen := mload(bufptr)
177             // Address = buffer address + buffer length + sizeof(buffer length)
178             let dest := add(add(bufptr, buflen), 32)
179             mstore8(dest, data)
180             // Update buffer length
181             mstore(bufptr, add(buflen, 1))
182         }
183     }
184 
185     /**
186      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
187      * exceed the capacity of the buffer.
188      * @param buf The buffer to append to.
189      * @param data The data to append.
190      * @return The original buffer.
191      */
192     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
193         if(len + buf.buf.length > buf.capacity) {
194             resize(buf, max(buf.capacity, len) * 2);
195         }
196 
197         uint mask = 256 ** len - 1;
198         assembly {
199             // Memory address of the buffer data
200             let bufptr := mload(buf)
201             // Length of existing buffer data
202             let buflen := mload(bufptr)
203             // Address = buffer address + buffer length + sizeof(buffer length) + len
204             let dest := add(add(bufptr, buflen), len)
205             mstore(dest, or(and(mload(dest), not(mask)), data))
206             // Update buffer length
207             mstore(bufptr, add(buflen, len))
208         }
209         return buf;
210     }
211 }
212 
213 library CBOR {
214     using Buffer for Buffer.buffer;
215 
216     uint8 private constant MAJOR_TYPE_INT = 0;
217     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
218     uint8 private constant MAJOR_TYPE_BYTES = 2;
219     uint8 private constant MAJOR_TYPE_STRING = 3;
220     uint8 private constant MAJOR_TYPE_ARRAY = 4;
221     uint8 private constant MAJOR_TYPE_MAP = 5;
222     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
223 
224     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
225         if(value <= 23) {
226             buf.append(uint8((major << 5) | value));
227         } else if(value <= 0xFF) {
228             buf.append(uint8((major << 5) | 24));
229             buf.appendInt(value, 1);
230         } else if(value <= 0xFFFF) {
231             buf.append(uint8((major << 5) | 25));
232             buf.appendInt(value, 2);
233         } else if(value <= 0xFFFFFFFF) {
234             buf.append(uint8((major << 5) | 26));
235             buf.appendInt(value, 4);
236         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
237             buf.append(uint8((major << 5) | 27));
238             buf.appendInt(value, 8);
239         }
240     }
241 
242     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
243         buf.append(uint8((major << 5) | 31));
244     }
245 
246     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
247         encodeType(buf, MAJOR_TYPE_INT, value);
248     }
249 
250     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
251         if(value >= 0) {
252             encodeType(buf, MAJOR_TYPE_INT, uint(value));
253         } else {
254             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
255         }
256     }
257 
258     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
259         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
260         buf.append(value);
261     }
262 
263     function encodeString(Buffer.buffer memory buf, string value) internal pure {
264         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
265         buf.append(bytes(value));
266     }
267 
268     function startArray(Buffer.buffer memory buf) internal pure {
269         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
270     }
271 
272     function startMap(Buffer.buffer memory buf) internal pure {
273         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
274     }
275 
276     function endSequence(Buffer.buffer memory buf) internal pure {
277         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
278     }
279 }
280 
281 /*
282 End solidity-cborutils
283  */
284 
285 contract usingOraclize {
286     uint constant day = 60*60*24;
287     uint constant week = 60*60*24*7;
288     uint constant month = 60*60*24*30;
289     byte constant proofType_NONE = 0x00;
290     byte constant proofType_TLSNotary = 0x10;
291     byte constant proofType_Android = 0x20;
292     byte constant proofType_Ledger = 0x30;
293     byte constant proofType_Native = 0xF0;
294     byte constant proofStorage_IPFS = 0x01;
295     uint8 constant networkID_auto = 0;
296     uint8 constant networkID_mainnet = 1;
297     uint8 constant networkID_testnet = 2;
298     uint8 constant networkID_morden = 2;
299     uint8 constant networkID_consensys = 161;
300 
301     OraclizeAddrResolverI OAR;
302 
303     OraclizeI oraclize;
304     modifier oraclizeAPI {
305         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
306             oraclize_setNetwork(networkID_auto);
307 
308         if(address(oraclize) != OAR.getAddress())
309             oraclize = OraclizeI(OAR.getAddress());
310 
311         _;
312     }
313     modifier coupon(string code){
314         oraclize = OraclizeI(OAR.getAddress());
315         _;
316     }
317 
318     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
319       return oraclize_setNetwork();
320       networkID; // silence the warning and remain backwards compatible
321     }
322     function oraclize_setNetwork() internal returns(bool){
323         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
324             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
325             oraclize_setNetworkName("eth_mainnet");
326             return true;
327         }
328         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
329             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
330             oraclize_setNetworkName("eth_ropsten3");
331             return true;
332         }
333         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
334             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
335             oraclize_setNetworkName("eth_kovan");
336             return true;
337         }
338         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
339             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
340             oraclize_setNetworkName("eth_rinkeby");
341             return true;
342         }
343         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
344             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
345             return true;
346         }
347         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
348             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
349             return true;
350         }
351         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
352             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
353             return true;
354         }
355         return false;
356     }
357 
358     function __callback(bytes32 myid, string result) public {
359         __callback(myid, result, new bytes(0));
360     }
361     function __callback(bytes32 myid, string result, bytes proof) public {
362       return;
363       myid; result; proof; // Silence compiler warnings
364     }
365 
366     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
367         return oraclize.getPrice(datasource);
368     }
369 
370     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
371         return oraclize.getPrice(datasource, gaslimit);
372     }
373 
374     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
375         uint price = oraclize.getPrice(datasource);
376         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
377         return oraclize.query.value(price)(0, datasource, arg);
378     }
379     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
380         uint price = oraclize.getPrice(datasource);
381         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
382         return oraclize.query.value(price)(timestamp, datasource, arg);
383     }
384     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
385         uint price = oraclize.getPrice(datasource, gaslimit);
386         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
387         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
388     }
389     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
390         uint price = oraclize.getPrice(datasource, gaslimit);
391         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
392         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
393     }
394     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
395         uint price = oraclize.getPrice(datasource);
396         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
397         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
398     }
399     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
400         uint price = oraclize.getPrice(datasource);
401         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
402         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
403     }
404     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
405         uint price = oraclize.getPrice(datasource, gaslimit);
406         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
407         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
408     }
409     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
410         uint price = oraclize.getPrice(datasource, gaslimit);
411         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
412         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
413     }
414     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
415         uint price = oraclize.getPrice(datasource);
416         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
417         bytes memory args = stra2cbor(argN);
418         return oraclize.queryN.value(price)(0, datasource, args);
419     }
420     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
421         uint price = oraclize.getPrice(datasource);
422         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
423         bytes memory args = stra2cbor(argN);
424         return oraclize.queryN.value(price)(timestamp, datasource, args);
425     }
426     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
427         uint price = oraclize.getPrice(datasource, gaslimit);
428         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
429         bytes memory args = stra2cbor(argN);
430         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
431     }
432     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
433         uint price = oraclize.getPrice(datasource, gaslimit);
434         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
435         bytes memory args = stra2cbor(argN);
436         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
437     }
438     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
439         string[] memory dynargs = new string[](1);
440         dynargs[0] = args[0];
441         return oraclize_query(datasource, dynargs);
442     }
443     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
444         string[] memory dynargs = new string[](1);
445         dynargs[0] = args[0];
446         return oraclize_query(timestamp, datasource, dynargs);
447     }
448     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
449         string[] memory dynargs = new string[](1);
450         dynargs[0] = args[0];
451         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
452     }
453     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
454         string[] memory dynargs = new string[](1);
455         dynargs[0] = args[0];
456         return oraclize_query(datasource, dynargs, gaslimit);
457     }
458 
459     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
460         string[] memory dynargs = new string[](2);
461         dynargs[0] = args[0];
462         dynargs[1] = args[1];
463         return oraclize_query(datasource, dynargs);
464     }
465     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
466         string[] memory dynargs = new string[](2);
467         dynargs[0] = args[0];
468         dynargs[1] = args[1];
469         return oraclize_query(timestamp, datasource, dynargs);
470     }
471     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
472         string[] memory dynargs = new string[](2);
473         dynargs[0] = args[0];
474         dynargs[1] = args[1];
475         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
476     }
477     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
478         string[] memory dynargs = new string[](2);
479         dynargs[0] = args[0];
480         dynargs[1] = args[1];
481         return oraclize_query(datasource, dynargs, gaslimit);
482     }
483     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
484         string[] memory dynargs = new string[](3);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         dynargs[2] = args[2];
488         return oraclize_query(datasource, dynargs);
489     }
490     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
491         string[] memory dynargs = new string[](3);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         dynargs[2] = args[2];
495         return oraclize_query(timestamp, datasource, dynargs);
496     }
497     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         string[] memory dynargs = new string[](3);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
503     }
504     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
505         string[] memory dynargs = new string[](3);
506         dynargs[0] = args[0];
507         dynargs[1] = args[1];
508         dynargs[2] = args[2];
509         return oraclize_query(datasource, dynargs, gaslimit);
510     }
511 
512     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
513         string[] memory dynargs = new string[](4);
514         dynargs[0] = args[0];
515         dynargs[1] = args[1];
516         dynargs[2] = args[2];
517         dynargs[3] = args[3];
518         return oraclize_query(datasource, dynargs);
519     }
520     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
521         string[] memory dynargs = new string[](4);
522         dynargs[0] = args[0];
523         dynargs[1] = args[1];
524         dynargs[2] = args[2];
525         dynargs[3] = args[3];
526         return oraclize_query(timestamp, datasource, dynargs);
527     }
528     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
529         string[] memory dynargs = new string[](4);
530         dynargs[0] = args[0];
531         dynargs[1] = args[1];
532         dynargs[2] = args[2];
533         dynargs[3] = args[3];
534         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
535     }
536     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
537         string[] memory dynargs = new string[](4);
538         dynargs[0] = args[0];
539         dynargs[1] = args[1];
540         dynargs[2] = args[2];
541         dynargs[3] = args[3];
542         return oraclize_query(datasource, dynargs, gaslimit);
543     }
544     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
545         string[] memory dynargs = new string[](5);
546         dynargs[0] = args[0];
547         dynargs[1] = args[1];
548         dynargs[2] = args[2];
549         dynargs[3] = args[3];
550         dynargs[4] = args[4];
551         return oraclize_query(datasource, dynargs);
552     }
553     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
554         string[] memory dynargs = new string[](5);
555         dynargs[0] = args[0];
556         dynargs[1] = args[1];
557         dynargs[2] = args[2];
558         dynargs[3] = args[3];
559         dynargs[4] = args[4];
560         return oraclize_query(timestamp, datasource, dynargs);
561     }
562     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
563         string[] memory dynargs = new string[](5);
564         dynargs[0] = args[0];
565         dynargs[1] = args[1];
566         dynargs[2] = args[2];
567         dynargs[3] = args[3];
568         dynargs[4] = args[4];
569         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
570     }
571     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
572         string[] memory dynargs = new string[](5);
573         dynargs[0] = args[0];
574         dynargs[1] = args[1];
575         dynargs[2] = args[2];
576         dynargs[3] = args[3];
577         dynargs[4] = args[4];
578         return oraclize_query(datasource, dynargs, gaslimit);
579     }
580     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
581         uint price = oraclize.getPrice(datasource);
582         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
583         bytes memory args = ba2cbor(argN);
584         return oraclize.queryN.value(price)(0, datasource, args);
585     }
586     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
587         uint price = oraclize.getPrice(datasource);
588         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
589         bytes memory args = ba2cbor(argN);
590         return oraclize.queryN.value(price)(timestamp, datasource, args);
591     }
592     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
593         uint price = oraclize.getPrice(datasource, gaslimit);
594         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
595         bytes memory args = ba2cbor(argN);
596         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
597     }
598     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
599         uint price = oraclize.getPrice(datasource, gaslimit);
600         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
601         bytes memory args = ba2cbor(argN);
602         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
603     }
604     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
605         bytes[] memory dynargs = new bytes[](1);
606         dynargs[0] = args[0];
607         return oraclize_query(datasource, dynargs);
608     }
609     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
610         bytes[] memory dynargs = new bytes[](1);
611         dynargs[0] = args[0];
612         return oraclize_query(timestamp, datasource, dynargs);
613     }
614     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
615         bytes[] memory dynargs = new bytes[](1);
616         dynargs[0] = args[0];
617         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
618     }
619     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
620         bytes[] memory dynargs = new bytes[](1);
621         dynargs[0] = args[0];
622         return oraclize_query(datasource, dynargs, gaslimit);
623     }
624 
625     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
626         bytes[] memory dynargs = new bytes[](2);
627         dynargs[0] = args[0];
628         dynargs[1] = args[1];
629         return oraclize_query(datasource, dynargs);
630     }
631     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
632         bytes[] memory dynargs = new bytes[](2);
633         dynargs[0] = args[0];
634         dynargs[1] = args[1];
635         return oraclize_query(timestamp, datasource, dynargs);
636     }
637     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
638         bytes[] memory dynargs = new bytes[](2);
639         dynargs[0] = args[0];
640         dynargs[1] = args[1];
641         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
642     }
643     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
644         bytes[] memory dynargs = new bytes[](2);
645         dynargs[0] = args[0];
646         dynargs[1] = args[1];
647         return oraclize_query(datasource, dynargs, gaslimit);
648     }
649     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
650         bytes[] memory dynargs = new bytes[](3);
651         dynargs[0] = args[0];
652         dynargs[1] = args[1];
653         dynargs[2] = args[2];
654         return oraclize_query(datasource, dynargs);
655     }
656     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
657         bytes[] memory dynargs = new bytes[](3);
658         dynargs[0] = args[0];
659         dynargs[1] = args[1];
660         dynargs[2] = args[2];
661         return oraclize_query(timestamp, datasource, dynargs);
662     }
663     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
664         bytes[] memory dynargs = new bytes[](3);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         dynargs[2] = args[2];
668         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
669     }
670     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
671         bytes[] memory dynargs = new bytes[](3);
672         dynargs[0] = args[0];
673         dynargs[1] = args[1];
674         dynargs[2] = args[2];
675         return oraclize_query(datasource, dynargs, gaslimit);
676     }
677 
678     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
679         bytes[] memory dynargs = new bytes[](4);
680         dynargs[0] = args[0];
681         dynargs[1] = args[1];
682         dynargs[2] = args[2];
683         dynargs[3] = args[3];
684         return oraclize_query(datasource, dynargs);
685     }
686     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
687         bytes[] memory dynargs = new bytes[](4);
688         dynargs[0] = args[0];
689         dynargs[1] = args[1];
690         dynargs[2] = args[2];
691         dynargs[3] = args[3];
692         return oraclize_query(timestamp, datasource, dynargs);
693     }
694     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
695         bytes[] memory dynargs = new bytes[](4);
696         dynargs[0] = args[0];
697         dynargs[1] = args[1];
698         dynargs[2] = args[2];
699         dynargs[3] = args[3];
700         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
701     }
702     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
703         bytes[] memory dynargs = new bytes[](4);
704         dynargs[0] = args[0];
705         dynargs[1] = args[1];
706         dynargs[2] = args[2];
707         dynargs[3] = args[3];
708         return oraclize_query(datasource, dynargs, gaslimit);
709     }
710     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
711         bytes[] memory dynargs = new bytes[](5);
712         dynargs[0] = args[0];
713         dynargs[1] = args[1];
714         dynargs[2] = args[2];
715         dynargs[3] = args[3];
716         dynargs[4] = args[4];
717         return oraclize_query(datasource, dynargs);
718     }
719     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
720         bytes[] memory dynargs = new bytes[](5);
721         dynargs[0] = args[0];
722         dynargs[1] = args[1];
723         dynargs[2] = args[2];
724         dynargs[3] = args[3];
725         dynargs[4] = args[4];
726         return oraclize_query(timestamp, datasource, dynargs);
727     }
728     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
729         bytes[] memory dynargs = new bytes[](5);
730         dynargs[0] = args[0];
731         dynargs[1] = args[1];
732         dynargs[2] = args[2];
733         dynargs[3] = args[3];
734         dynargs[4] = args[4];
735         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
736     }
737     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
738         bytes[] memory dynargs = new bytes[](5);
739         dynargs[0] = args[0];
740         dynargs[1] = args[1];
741         dynargs[2] = args[2];
742         dynargs[3] = args[3];
743         dynargs[4] = args[4];
744         return oraclize_query(datasource, dynargs, gaslimit);
745     }
746 
747     function oraclize_cbAddress() oraclizeAPI internal returns (address){
748         return oraclize.cbAddress();
749     }
750     function oraclize_setProof(byte proofP) oraclizeAPI internal {
751         return oraclize.setProofType(proofP);
752     }
753     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
754         return oraclize.setCustomGasPrice(gasPrice);
755     }
756 
757     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
758         return oraclize.randomDS_getSessionPubKeyHash();
759     }
760 
761     function getCodeSize(address _addr) constant internal returns(uint _size) {
762         assembly {
763             _size := extcodesize(_addr)
764         }
765     }
766 
767     function parseAddr(string _a) internal pure returns (address){
768         bytes memory tmp = bytes(_a);
769         uint160 iaddr = 0;
770         uint160 b1;
771         uint160 b2;
772         for (uint i=2; i<2+2*20; i+=2){
773             iaddr *= 256;
774             b1 = uint160(tmp[i]);
775             b2 = uint160(tmp[i+1]);
776             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
777             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
778             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
779             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
780             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
781             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
782             iaddr += (b1*16+b2);
783         }
784         return address(iaddr);
785     }
786 
787     function strCompare(string _a, string _b) internal pure returns (int) {
788         bytes memory a = bytes(_a);
789         bytes memory b = bytes(_b);
790         uint minLength = a.length;
791         if (b.length < minLength) minLength = b.length;
792         for (uint i = 0; i < minLength; i ++)
793             if (a[i] < b[i])
794                 return -1;
795             else if (a[i] > b[i])
796                 return 1;
797         if (a.length < b.length)
798             return -1;
799         else if (a.length > b.length)
800             return 1;
801         else
802             return 0;
803     }
804 
805     function indexOf(string _haystack, string _needle) internal pure returns (int) {
806         bytes memory h = bytes(_haystack);
807         bytes memory n = bytes(_needle);
808         if(h.length < 1 || n.length < 1 || (n.length > h.length))
809             return -1;
810         else if(h.length > (2**128 -1))
811             return -1;
812         else
813         {
814             uint subindex = 0;
815             for (uint i = 0; i < h.length; i ++)
816             {
817                 if (h[i] == n[0])
818                 {
819                     subindex = 1;
820                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
821                     {
822                         subindex++;
823                     }
824                     if(subindex == n.length)
825                         return int(i);
826                 }
827             }
828             return -1;
829         }
830     }
831 
832     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
833         bytes memory _ba = bytes(_a);
834         bytes memory _bb = bytes(_b);
835         bytes memory _bc = bytes(_c);
836         bytes memory _bd = bytes(_d);
837         bytes memory _be = bytes(_e);
838         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
839         bytes memory babcde = bytes(abcde);
840         uint k = 0;
841         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
842         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
843         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
844         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
845         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
846         return string(babcde);
847     }
848 
849     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
850         return strConcat(_a, _b, _c, _d, "");
851     }
852 
853     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
854         return strConcat(_a, _b, _c, "", "");
855     }
856 
857     function strConcat(string _a, string _b) internal pure returns (string) {
858         return strConcat(_a, _b, "", "", "");
859     }
860 
861     // parseInt
862     function parseInt(string _a) internal pure returns (uint) {
863         return parseInt(_a, 0);
864     }
865 
866     // parseInt(parseFloat*10^_b)
867     function parseInt(string _a, uint _b) internal pure returns (uint) {
868         bytes memory bresult = bytes(_a);
869         uint mint = 0;
870         bool decimals = false;
871         for (uint i=0; i<bresult.length; i++){
872             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
873                 if (decimals){
874                    if (_b == 0) break;
875                     else _b--;
876                 }
877                 mint *= 10;
878                 mint += uint(bresult[i]) - 48;
879             } else if (bresult[i] == 46) decimals = true;
880         }
881         if (_b > 0) mint *= 10**_b;
882         return mint;
883     }
884 
885     function uint2str(uint i) internal pure returns (string){
886         if (i == 0) return "0";
887         uint j = i;
888         uint len;
889         while (j != 0){
890             len++;
891             j /= 10;
892         }
893         bytes memory bstr = new bytes(len);
894         uint k = len - 1;
895         while (i != 0){
896             bstr[k--] = byte(48 + i % 10);
897             i /= 10;
898         }
899         return string(bstr);
900     }
901 
902     using CBOR for Buffer.buffer;
903     function stra2cbor(string[] arr) internal pure returns (bytes) {
904         Buffer.buffer memory buf;
905         Buffer.init(buf, 1024);
906         buf.startArray();
907         for (uint i = 0; i < arr.length; i++) {
908             buf.encodeString(arr[i]);
909         }
910         buf.endSequence();
911         return buf.buf;
912     }
913 
914     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
915         Buffer.buffer memory buf;
916         Buffer.init(buf, 1024);
917         buf.startArray();
918         for (uint i = 0; i < arr.length; i++) {
919             buf.encodeBytes(arr[i]);
920         }
921         buf.endSequence();
922         return buf.buf;
923     }
924 
925     string oraclize_network_name;
926     function oraclize_setNetworkName(string _network_name) internal {
927         oraclize_network_name = _network_name;
928     }
929 
930     function oraclize_getNetworkName() internal view returns (string) {
931         return oraclize_network_name;
932     }
933 
934     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
935         require((_nbytes > 0) && (_nbytes <= 32));
936         // Convert from seconds to ledger timer ticks
937         _delay *= 10;
938         bytes memory nbytes = new bytes(1);
939         nbytes[0] = byte(_nbytes);
940         bytes memory unonce = new bytes(32);
941         bytes memory sessionKeyHash = new bytes(32);
942         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
943         assembly {
944             mstore(unonce, 0x20)
945             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
946             mstore(sessionKeyHash, 0x20)
947             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
948         }
949         bytes memory delay = new bytes(32);
950         assembly {
951             mstore(add(delay, 0x20), _delay)
952         }
953 
954         bytes memory delay_bytes8 = new bytes(8);
955         copyBytes(delay, 24, 8, delay_bytes8, 0);
956 
957         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
958         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
959 
960         bytes memory delay_bytes8_left = new bytes(8);
961 
962         assembly {
963             let x := mload(add(delay_bytes8, 0x20))
964             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
965             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
966             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
967             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
968             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
969             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
970             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
971             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
972 
973         }
974 
975         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
976         return queryId;
977     }
978 
979     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
980         oraclize_randomDS_args[queryId] = commitment;
981     }
982 
983     mapping(bytes32=>bytes32) oraclize_randomDS_args;
984     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
985 
986     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
987         bool sigok;
988         address signer;
989 
990         bytes32 sigr;
991         bytes32 sigs;
992 
993         bytes memory sigr_ = new bytes(32);
994         uint offset = 4+(uint(dersig[3]) - 0x20);
995         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
996         bytes memory sigs_ = new bytes(32);
997         offset += 32 + 2;
998         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
999 
1000         assembly {
1001             sigr := mload(add(sigr_, 32))
1002             sigs := mload(add(sigs_, 32))
1003         }
1004 
1005 
1006         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1007         if (address(keccak256(pubkey)) == signer) return true;
1008         else {
1009             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1010             return (address(keccak256(pubkey)) == signer);
1011         }
1012     }
1013 
1014     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1015         bool sigok;
1016 
1017         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1018         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1019         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1020 
1021         bytes memory appkey1_pubkey = new bytes(64);
1022         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1023 
1024         bytes memory tosign2 = new bytes(1+65+32);
1025         tosign2[0] = byte(1); //role
1026         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1027         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1028         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1029         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1030 
1031         if (sigok == false) return false;
1032 
1033 
1034         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1035         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1036 
1037         bytes memory tosign3 = new bytes(1+65);
1038         tosign3[0] = 0xFE;
1039         copyBytes(proof, 3, 65, tosign3, 1);
1040 
1041         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1042         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1043 
1044         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1045 
1046         return sigok;
1047     }
1048 
1049     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1050         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1051         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1052 
1053         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1054         require(proofVerified);
1055 
1056         _;
1057     }
1058 
1059     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1060         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1061         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1062 
1063         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1064         if (proofVerified == false) return 2;
1065 
1066         return 0;
1067     }
1068 
1069     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1070         bool match_ = true;
1071 
1072         require(prefix.length == n_random_bytes);
1073 
1074         for (uint256 i=0; i< n_random_bytes; i++) {
1075             if (content[i] != prefix[i]) match_ = false;
1076         }
1077 
1078         return match_;
1079     }
1080 
1081     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1082 
1083         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1084         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1085         bytes memory keyhash = new bytes(32);
1086         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1087         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1088 
1089         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1090         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1091 
1092         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1093         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1094 
1095         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1096         // This is to verify that the computed args match with the ones specified in the query.
1097         bytes memory commitmentSlice1 = new bytes(8+1+32);
1098         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1099 
1100         bytes memory sessionPubkey = new bytes(64);
1101         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1102         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1103 
1104         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1105         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1106             delete oraclize_randomDS_args[queryId];
1107         } else return false;
1108 
1109 
1110         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1111         bytes memory tosign1 = new bytes(32+8+1+32);
1112         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1113         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1114 
1115         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1116         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1117             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1118         }
1119 
1120         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1121     }
1122 
1123     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1124     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1125         uint minLength = length + toOffset;
1126 
1127         // Buffer too small
1128         require(to.length >= minLength); // Should be a better way?
1129 
1130         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1131         uint i = 32 + fromOffset;
1132         uint j = 32 + toOffset;
1133 
1134         while (i < (32 + fromOffset + length)) {
1135             assembly {
1136                 let tmp := mload(add(from, i))
1137                 mstore(add(to, j), tmp)
1138             }
1139             i += 32;
1140             j += 32;
1141         }
1142 
1143         return to;
1144     }
1145 
1146     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1147     // Duplicate Solidity's ecrecover, but catching the CALL return value
1148     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1149         // We do our own memory management here. Solidity uses memory offset
1150         // 0x40 to store the current end of memory. We write past it (as
1151         // writes are memory extensions), but don't update the offset so
1152         // Solidity will reuse it. The memory used here is only needed for
1153         // this context.
1154 
1155         // FIXME: inline assembly can't access return values
1156         bool ret;
1157         address addr;
1158 
1159         assembly {
1160             let size := mload(0x40)
1161             mstore(size, hash)
1162             mstore(add(size, 32), v)
1163             mstore(add(size, 64), r)
1164             mstore(add(size, 96), s)
1165 
1166             // NOTE: we can reuse the request memory because we deal with
1167             //       the return code
1168             ret := call(3000, 1, 0, size, 128, size, 32)
1169             addr := mload(size)
1170         }
1171 
1172         return (ret, addr);
1173     }
1174 
1175     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1176     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1177         bytes32 r;
1178         bytes32 s;
1179         uint8 v;
1180 
1181         if (sig.length != 65)
1182           return (false, 0);
1183 
1184         // The signature format is a compact form of:
1185         //   {bytes32 r}{bytes32 s}{uint8 v}
1186         // Compact means, uint8 is not padded to 32 bytes.
1187         assembly {
1188             r := mload(add(sig, 32))
1189             s := mload(add(sig, 64))
1190 
1191             // Here we are loading the last 32 bytes. We exploit the fact that
1192             // 'mload' will pad with zeroes if we overread.
1193             // There is no 'mload8' to do this, but that would be nicer.
1194             v := byte(0, mload(add(sig, 96)))
1195 
1196             // Alternative solution:
1197             // 'byte' is not working due to the Solidity parser, so lets
1198             // use the second best option, 'and'
1199             // v := and(mload(add(sig, 65)), 255)
1200         }
1201 
1202         // albeit non-transactional signatures are not specified by the YP, one would expect it
1203         // to match the YP range of [27, 28]
1204         //
1205         // geth uses [0, 1] and some clients have followed. This might change, see:
1206         //  https://github.com/ethereum/go-ethereum/issues/2053
1207         if (v < 27)
1208           v += 27;
1209 
1210         if (v != 27 && v != 28)
1211             return (false, 0);
1212 
1213         return safer_ecrecover(hash, v, r, s);
1214     }
1215 
1216 }
1217 // </ORACLIZE_API>
1218 
1219 library SafeMath {
1220     function add(uint a, uint b) internal pure returns (uint c) {
1221         c = a + b;
1222         require(c >= a);
1223     }
1224     function sub(uint a, uint b) internal pure returns (uint c) {
1225         require(b <= a);
1226         c = a - b;
1227     }
1228     function mul(uint a, uint b) internal pure returns (uint c) {
1229         c = a * b;
1230         require(a == 0 || c / a == b);
1231     }
1232     function div(uint a, uint b) internal pure returns (uint c) {
1233         require(b > 0);
1234         c = a / b;
1235     }
1236 }
1237 
1238 contract Owned {
1239     address public owner;
1240     address public newOwner;
1241 
1242     event OwnershipTransferred(address indexed _from, address indexed _to);
1243 
1244     function Owned() public {
1245         owner = msg.sender;
1246     }
1247 
1248     modifier onlyOwner {
1249         require(msg.sender == owner);
1250         _;
1251     }
1252 
1253     function transferOwnership(address _newOwner) public onlyOwner {
1254         newOwner = _newOwner;
1255     }
1256     
1257     function acceptOwnership() public {
1258         require(msg.sender == newOwner);
1259         OwnershipTransferred(owner, newOwner);
1260         owner = newOwner;
1261         newOwner = address(0);
1262     }
1263 }
1264 
1265 contract JungleScratch is usingOraclize, Owned {
1266     using SafeMath for uint;
1267     
1268 
1269     struct Ticket{
1270         address Buyer;
1271         bool isPlay;
1272         bool isPay;
1273         uint times;
1274         uint game_result;
1275     }
1276     
1277     mapping (address => uint) public Referrer;
1278     mapping (bytes32 => Ticket) public TicketPool;
1279     
1280     uint public callBackGasAmount = 120000;
1281     uint public LimitEther;
1282 
1283     event Buy(bytes32 indexed queryId, address Buyer, uint times, bool paid);
1284     event Referrer(address indexed Referrer, address Buyer);
1285     event Scratch(bytes32 indexed queryId, address indexed Buyer, uint[] RandomResult, uint game_result, uint times);
1286     event OwePay(bytes32 indexed queryId, address indexed Buyer, uint game_result);
1287     event Owe(bytes32 indexed queryId, address indexed Buyer, uint game_result);
1288     event Manage(uint withDrawEther, uint LimitEther_,uint CallBackGaswei_,uint CallBackGasamount_);
1289 
1290     function JungleScratch() public {
1291         oraclize_setCustomGasPrice(10000000000 wei);
1292         oraclize_setProof(proofType_Ledger);
1293         LimitEther = 0.02 ether;
1294     }
1295     
1296     function OwnerManage(uint withdrawEther_, uint LimitEther_, uint CallBackGaswei_, uint CallBackGasamount_) public onlyOwner {
1297         
1298         if((address(this).balance - withdrawEther_) >= 100 ether){
1299             msg.sender.transfer(withdrawEther_);
1300         }
1301         
1302         LimitEther = LimitEther_;
1303         oraclize_setCustomGasPrice(CallBackGaswei_);
1304         callBackGasAmount = CallBackGasamount_;
1305         Manage(withdrawEther_, LimitEther_, CallBackGaswei_, CallBackGasamount_);
1306     }
1307     
1308     function chargeOwe(bytes32 _queryId) public {
1309         require(!TicketPool[_queryId].isPay);
1310         require(TicketPool[_queryId].isPlay);
1311         require(TicketPool[_queryId].game_result != 0);
1312         
1313         if(address(this).balance >= TicketPool[_queryId].game_result){
1314             if (TicketPool[_queryId].Buyer.send(TicketPool[_queryId].game_result)) {
1315                 TicketPool[_queryId].isPay = true;
1316                 OwePay(_queryId, TicketPool[_queryId].Buyer, TicketPool[_queryId].game_result);
1317             }
1318         } 
1319     }
1320     
1321     // ------------------------------------------------------------------------
1322     // Only Accepted callback from the oraclize
1323     // ------------------------------------------------------------------------
1324     function __callback(bytes32 _queryId, string _result, bytes _proof) public
1325     { 
1326         require(msg.sender == oraclize_cbAddress());
1327         
1328         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0) {
1329            
1330             require(!TicketPool[_queryId].isPlay);
1331             
1332             uint game_result = 0;
1333             
1334             uint[] memory RandomResult = new uint[](9);
1335             
1336             RandomResult[0] = uint(keccak256("Pig World", block.blockhash(block.number), _result, block.blockhash(block.number-1), block.timestamp, block.coinbase)) % 1000 + 1;
1337             RandomResult[1] = uint(keccak256(block.blockhash(block.number-2), block.blockhash(block.number), _result, block.coinbase, "ico start at 6/28", block.timestamp)) % 1000 + 1;
1338             RandomResult[2] = uint(keccak256(block.coinbase, _result, block.blockhash(block.number), block.blockhash(block.number-3), block.timestamp, "PICO has a fixed price: 0.033 USD")) % 1000 + 1;
1339             RandomResult[3] = uint(keccak256(block.blockhash(block.number-4), "PG Channels is magic", block.coinbase, block.timestamp, _result, block.blockhash(block.number))) % 1000 + 1;
1340             RandomResult[4] = uint(keccak256(block.timestamp, block.blockhash(block.number-5), block.blockhash(block.number), block.coinbase, _result, "Ethereum Casino")) % 1000 + 1;
1341             RandomResult[5] = uint(keccak256(_result, block.blockhash(block.number), block.blockhash(block.number-6), "<script>alert('Pig World is Awesome');</script>", block.coinbase, block.timestamp)) % 1000 + 1;
1342             RandomResult[6] = uint(keccak256(block.blockhash(block.number), block.timestamp, "No.1 Decentralized Application", block.blockhash(block.number-7), block.coinbase, _result)) % 1000 + 1;
1343             RandomResult[7] = uint(keccak256(block.blockhash(block.number-8), block.blockhash(block.number), "Cheating is impossible", block.coinbase, _result, block.timestamp)) % 1000 + 1;
1344             RandomResult[8] = uint(keccak256(block.coinbase, block.blockhash(block.number-9), block.blockhash(block.number), _result, block.timestamp, "Winner Winner Pork Dinner")) % 1000 + 1;
1345            
1346             for (uint n = 0; n < 9; n++) {
1347                 if(RandomResult[n]< 10){
1348                     RandomResult[n] = 0;
1349                 } else if(RandomResult[n]< 29){
1350                     RandomResult[n] = 1;
1351                 } else if(RandomResult[n]< 61){
1352                     RandomResult[n] = 2;
1353                 } else if(RandomResult[n]< 106){
1354                     RandomResult[n] = 3;
1355                 } else if(RandomResult[n]< 227){
1356                     RandomResult[n] = 4;
1357                 } else if(RandomResult[n]< 427){
1358                     RandomResult[n] = 5;
1359                 } else if(RandomResult[n]< 1001){
1360                     RandomResult[n] = 6;
1361                 }
1362             }
1363             
1364             for(uint nn = 0; nn < 6; nn++){
1365                 uint count = 0;
1366                 for(uint p = 0; p < 9; p++){
1367                     if(RandomResult[p] == nn)
1368                         count ++;
1369                 }
1370                 
1371                 if(count >= 3 && nn == 0)
1372                     game_result = game_result.add(TicketPool[_queryId].times.mul(100 ether));
1373                     
1374                 if(count >= 3 && nn == 1)
1375                     game_result = game_result.add(TicketPool[_queryId].times.mul(1 ether));
1376                     
1377                 if(count >= 3 && nn == 2)
1378                     game_result = game_result.add(TicketPool[_queryId].times.mul(0.5 ether));
1379                     
1380                 if(count >= 3 && nn == 3)
1381                     game_result = game_result.add(TicketPool[_queryId].times.mul(0.1 ether));
1382                     
1383                 if(count >= 3 && nn == 4)
1384                     game_result = game_result.add(TicketPool[_queryId].times.mul(0.05 ether)); 
1385                     
1386                 if(count >= 3 && nn == 5)
1387                     game_result = game_result.add(TicketPool[_queryId].times.mul(0.01 ether)); 
1388             }
1389             
1390             if(game_result != 0){
1391                 if (address(this).balance >= game_result && TicketPool[_queryId].Buyer.send(game_result)) {
1392                     TicketPool[_queryId].isPay = true;
1393                 } else {
1394                     Owe(_queryId, TicketPool[_queryId].Buyer, TicketPool[_queryId].game_result);
1395                     TicketPool[_queryId].isPay = false;
1396                 } 
1397              } else {
1398                 TicketPool[_queryId].isPay = false;
1399             }
1400             
1401             TicketPool[_queryId].isPlay = true;
1402             TicketPool[_queryId].game_result = game_result;
1403             
1404             Scratch(_queryId, TicketPool[_queryId].Buyer, RandomResult, game_result, TicketPool[_queryId].times);
1405         }
1406     }
1407     
1408     function buy_tickey(address referraler) public payable {
1409         require(msg.value == 0.02 ether || msg.value == 0.04 ether || msg.value == 0.06 ether);
1410         require(msg.value <= LimitEther);
1411         require(referraler != msg.sender);
1412         uint N = 16; // number of random bytes we want the datasource to return
1413         uint delay = 0; // number of seconds to wait before the execution takes place
1414         bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callBackGasAmount);
1415         
1416         uint times = msg.value.div(0.02 ether);
1417 
1418         require(times == 1 || times == 2 || times == 3);
1419         
1420         TicketPool[queryId] = Ticket(msg.sender,false,false,times,0);
1421         
1422         Referrer[referraler] = Referrer[referraler].add(1);
1423         
1424         Referrer(referraler, msg.sender);
1425         Buy(queryId,msg.sender,times,true);
1426     }
1427     
1428     function buy_tickey_free() public {
1429         require(Referrer[msg.sender] >= 10);
1430         uint N = 16; // number of random bytes we want the datasource to return
1431         uint delay = 0; // number of seconds to wait before the execution takes place
1432         bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callBackGasAmount); 
1433         
1434         TicketPool[queryId] = Ticket(msg.sender,false,false,1,0);
1435         
1436         Referrer[msg.sender] = Referrer[msg.sender].sub(10);
1437         Buy(queryId,msg.sender,1,false);
1438     }
1439     
1440     function() public payable {
1441         
1442     }
1443 }