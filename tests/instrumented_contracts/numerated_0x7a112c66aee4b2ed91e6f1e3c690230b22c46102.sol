1 pragma solidity ^0.4.18;
2 
3 // File: ../ethereum-api/oraclizeAPI_0.5.sol
4 
5 // <ORACLIZE_API>
6 /*
7 Copyright (c) 2015-2016 Oraclize SRL
8 Copyright (c) 2016 Oraclize LTD
9 
10 
11 
12 Permission is hereby granted, free of charge, to any person obtaining a copy
13 of this software and associated documentation files (the "Software"), to deal
14 in the Software without restriction, including without limitation the rights
15 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16 copies of the Software, and to permit persons to whom the Software is
17 furnished to do so, subject to the following conditions:
18 
19 
20 
21 The above copyright notice and this permission notice shall be included in
22 all copies or substantial portions of the Software.
23 
24 
25 
26 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
29 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
32 THE SOFTWARE.
33 */
34 
35 
36 
37 pragma solidity >=0.4.18 <=0.4.20;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
38 
39 contract OraclizeI {
40     address public cbAddress;
41     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
42     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
43     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
44     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
45     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
46     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
47     function getPrice(string _datasource) public returns (uint _dsprice);
48     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
49     function setProofType(byte _proofType) external;
50     function setCustomGasPrice(uint _gasPrice) external;
51     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
52 }
53 
54 contract OraclizeAddrResolverI {
55     function getAddress() public returns (address _addr);
56 }
57 
58 /*
59 Begin solidity-cborutils
60 
61 https://github.com/smartcontractkit/solidity-cborutils
62 
63 MIT License
64 
65 Copyright (c) 2018 SmartContract ChainLink, Ltd.
66 
67 Permission is hereby granted, free of charge, to any person obtaining a copy
68 of this software and associated documentation files (the "Software"), to deal
69 in the Software without restriction, including without limitation the rights
70 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
71 copies of the Software, and to permit persons to whom the Software is
72 furnished to do so, subject to the following conditions:
73 
74 The above copyright notice and this permission notice shall be included in all
75 copies or substantial portions of the Software.
76 
77 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
78 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
79 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
80 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
81 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
82 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
83 SOFTWARE.
84  */
85 
86 library Buffer {
87     struct buffer {
88         bytes buf;
89         uint capacity;
90     }
91 
92     function init(buffer memory buf, uint capacity) internal pure {
93         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
94         // Allocate space for the buffer data
95         buf.capacity = capacity;
96         assembly {
97             let ptr := mload(0x40)
98             mstore(buf, ptr)
99             mstore(0x40, add(ptr, capacity))
100         }
101     }
102 
103     function resize(buffer memory buf, uint capacity) private pure {
104         bytes memory oldbuf = buf.buf;
105         init(buf, capacity);
106         append(buf, oldbuf);
107     }
108 
109     function max(uint a, uint b) private pure returns(uint) {
110         if(a > b) {
111             return a;
112         }
113         return b;
114     }
115 
116     /**
117      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
118      *      would exceed the capacity of the buffer.
119      * @param buf The buffer to append to.
120      * @param data The data to append.
121      * @return The original buffer.
122      */
123     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
124         if(data.length + buf.buf.length > buf.capacity) {
125             resize(buf, max(buf.capacity, data.length) * 2);
126         }
127 
128         uint dest;
129         uint src;
130         uint len = data.length;
131         assembly {
132             // Memory address of the buffer data
133             let bufptr := mload(buf)
134             // Length of existing buffer data
135             let buflen := mload(bufptr)
136             // Start address = buffer address + buffer length + sizeof(buffer length)
137             dest := add(add(bufptr, buflen), 32)
138             // Update buffer length
139             mstore(bufptr, add(buflen, mload(data)))
140             src := add(data, 32)
141         }
142 
143         // Copy word-length chunks while possible
144         for(; len >= 32; len -= 32) {
145             assembly {
146                 mstore(dest, mload(src))
147             }
148             dest += 32;
149             src += 32;
150         }
151 
152         // Copy remaining bytes
153         uint mask = 256 ** (32 - len) - 1;
154         assembly {
155             let srcpart := and(mload(src), not(mask))
156             let destpart := and(mload(dest), mask)
157             mstore(dest, or(destpart, srcpart))
158         }
159 
160         return buf;
161     }
162 
163     /**
164      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
165      * exceed the capacity of the buffer.
166      * @param buf The buffer to append to.
167      * @param data The data to append.
168      * @return The original buffer.
169      */
170     function append(buffer memory buf, uint8 data) internal pure {
171         if(buf.buf.length + 1 > buf.capacity) {
172             resize(buf, buf.capacity * 2);
173         }
174 
175         assembly {
176             // Memory address of the buffer data
177             let bufptr := mload(buf)
178             // Length of existing buffer data
179             let buflen := mload(bufptr)
180             // Address = buffer address + buffer length + sizeof(buffer length)
181             let dest := add(add(bufptr, buflen), 32)
182             mstore8(dest, data)
183             // Update buffer length
184             mstore(bufptr, add(buflen, 1))
185         }
186     }
187 
188     /**
189      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
190      * exceed the capacity of the buffer.
191      * @param buf The buffer to append to.
192      * @param data The data to append.
193      * @return The original buffer.
194      */
195     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
196         if(len + buf.buf.length > buf.capacity) {
197             resize(buf, max(buf.capacity, len) * 2);
198         }
199 
200         uint mask = 256 ** len - 1;
201         assembly {
202             // Memory address of the buffer data
203             let bufptr := mload(buf)
204             // Length of existing buffer data
205             let buflen := mload(bufptr)
206             // Address = buffer address + buffer length + sizeof(buffer length) + len
207             let dest := add(add(bufptr, buflen), len)
208             mstore(dest, or(and(mload(dest), not(mask)), data))
209             // Update buffer length
210             mstore(bufptr, add(buflen, len))
211         }
212         return buf;
213     }
214 }
215 
216 library CBOR {
217     using Buffer for Buffer.buffer;
218 
219     uint8 private constant MAJOR_TYPE_INT = 0;
220     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
221     uint8 private constant MAJOR_TYPE_BYTES = 2;
222     uint8 private constant MAJOR_TYPE_STRING = 3;
223     uint8 private constant MAJOR_TYPE_ARRAY = 4;
224     uint8 private constant MAJOR_TYPE_MAP = 5;
225     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
226 
227     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
228         if(value <= 23) {
229             buf.append(uint8((major << 5) | value));
230         } else if(value <= 0xFF) {
231             buf.append(uint8((major << 5) | 24));
232             buf.appendInt(value, 1);
233         } else if(value <= 0xFFFF) {
234             buf.append(uint8((major << 5) | 25));
235             buf.appendInt(value, 2);
236         } else if(value <= 0xFFFFFFFF) {
237             buf.append(uint8((major << 5) | 26));
238             buf.appendInt(value, 4);
239         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
240             buf.append(uint8((major << 5) | 27));
241             buf.appendInt(value, 8);
242         }
243     }
244 
245     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
246         buf.append(uint8((major << 5) | 31));
247     }
248 
249     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
250         encodeType(buf, MAJOR_TYPE_INT, value);
251     }
252 
253     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
254         if(value >= 0) {
255             encodeType(buf, MAJOR_TYPE_INT, uint(value));
256         } else {
257             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
258         }
259     }
260 
261     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
262         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
263         buf.append(value);
264     }
265 
266     function encodeString(Buffer.buffer memory buf, string value) internal pure {
267         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
268         buf.append(bytes(value));
269     }
270 
271     function startArray(Buffer.buffer memory buf) internal pure {
272         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
273     }
274 
275     function startMap(Buffer.buffer memory buf) internal pure {
276         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
277     }
278 
279     function endSequence(Buffer.buffer memory buf) internal pure {
280         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
281     }
282 }
283 
284 /*
285 End solidity-cborutils
286  */
287 
288 contract usingOraclize {
289     uint constant day = 60*60*24;
290     uint constant week = 60*60*24*7;
291     uint constant month = 60*60*24*30;
292     byte constant proofType_NONE = 0x00;
293     byte constant proofType_TLSNotary = 0x10;
294     byte constant proofType_Android = 0x20;
295     byte constant proofType_Ledger = 0x30;
296     byte constant proofType_Native = 0xF0;
297     byte constant proofStorage_IPFS = 0x01;
298     uint8 constant networkID_auto = 0;
299     uint8 constant networkID_mainnet = 1;
300     uint8 constant networkID_testnet = 2;
301     uint8 constant networkID_morden = 2;
302     uint8 constant networkID_consensys = 161;
303 
304     OraclizeAddrResolverI OAR;
305 
306     OraclizeI oraclize;
307     modifier oraclizeAPI {
308         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
309             oraclize_setNetwork(networkID_auto);
310 
311         if(address(oraclize) != OAR.getAddress())
312             oraclize = OraclizeI(OAR.getAddress());
313 
314         _;
315     }
316     modifier coupon(string code){
317         oraclize = OraclizeI(OAR.getAddress());
318         _;
319     }
320 
321     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
322       return oraclize_setNetwork();
323       networkID; // silence the warning and remain backwards compatible
324     }
325     function oraclize_setNetwork() internal returns(bool){
326         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
327             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
328             oraclize_setNetworkName("eth_mainnet");
329             return true;
330         }
331         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
332             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
333             oraclize_setNetworkName("eth_ropsten3");
334             return true;
335         }
336         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
337             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
338             oraclize_setNetworkName("eth_kovan");
339             return true;
340         }
341         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
342             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
343             oraclize_setNetworkName("eth_rinkeby");
344             return true;
345         }
346         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
347             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
348             return true;
349         }
350         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
351             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
352             return true;
353         }
354         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
355             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
356             return true;
357         }
358         return false;
359     }
360 
361     function __callback(bytes32 myid, string result) public {
362         __callback(myid, result, new bytes(0));
363     }
364     function __callback(bytes32 myid, string result, bytes proof) public {
365       return;
366       myid; result; proof; // Silence compiler warnings
367     }
368 
369     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
370         return oraclize.getPrice(datasource);
371     }
372 
373     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
374         return oraclize.getPrice(datasource, gaslimit);
375     }
376 
377     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
378         uint price = oraclize.getPrice(datasource);
379         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
380         return oraclize.query.value(price)(0, datasource, arg);
381     }
382     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
383         uint price = oraclize.getPrice(datasource);
384         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
385         return oraclize.query.value(price)(timestamp, datasource, arg);
386     }
387     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
388         uint price = oraclize.getPrice(datasource, gaslimit);
389         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
390         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
391     }
392     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
393         uint price = oraclize.getPrice(datasource, gaslimit);
394         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
395         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
396     }
397     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
398         uint price = oraclize.getPrice(datasource);
399         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
400         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
401     }
402     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
403         uint price = oraclize.getPrice(datasource);
404         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
405         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
406     }
407     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
408         uint price = oraclize.getPrice(datasource, gaslimit);
409         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
410         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
411     }
412     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
413         uint price = oraclize.getPrice(datasource, gaslimit);
414         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
415         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
416     }
417     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
418         uint price = oraclize.getPrice(datasource);
419         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
420         bytes memory args = stra2cbor(argN);
421         return oraclize.queryN.value(price)(0, datasource, args);
422     }
423     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
424         uint price = oraclize.getPrice(datasource);
425         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
426         bytes memory args = stra2cbor(argN);
427         return oraclize.queryN.value(price)(timestamp, datasource, args);
428     }
429     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
430         uint price = oraclize.getPrice(datasource, gaslimit);
431         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
432         bytes memory args = stra2cbor(argN);
433         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
434     }
435     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
436         uint price = oraclize.getPrice(datasource, gaslimit);
437         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
438         bytes memory args = stra2cbor(argN);
439         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
440     }
441     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
442         string[] memory dynargs = new string[](1);
443         dynargs[0] = args[0];
444         return oraclize_query(datasource, dynargs);
445     }
446     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
447         string[] memory dynargs = new string[](1);
448         dynargs[0] = args[0];
449         return oraclize_query(timestamp, datasource, dynargs);
450     }
451     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
452         string[] memory dynargs = new string[](1);
453         dynargs[0] = args[0];
454         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
455     }
456     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
457         string[] memory dynargs = new string[](1);
458         dynargs[0] = args[0];
459         return oraclize_query(datasource, dynargs, gaslimit);
460     }
461 
462     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
463         string[] memory dynargs = new string[](2);
464         dynargs[0] = args[0];
465         dynargs[1] = args[1];
466         return oraclize_query(datasource, dynargs);
467     }
468     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
469         string[] memory dynargs = new string[](2);
470         dynargs[0] = args[0];
471         dynargs[1] = args[1];
472         return oraclize_query(timestamp, datasource, dynargs);
473     }
474     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
475         string[] memory dynargs = new string[](2);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
479     }
480     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
481         string[] memory dynargs = new string[](2);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         return oraclize_query(datasource, dynargs, gaslimit);
485     }
486     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
487         string[] memory dynargs = new string[](3);
488         dynargs[0] = args[0];
489         dynargs[1] = args[1];
490         dynargs[2] = args[2];
491         return oraclize_query(datasource, dynargs);
492     }
493     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
494         string[] memory dynargs = new string[](3);
495         dynargs[0] = args[0];
496         dynargs[1] = args[1];
497         dynargs[2] = args[2];
498         return oraclize_query(timestamp, datasource, dynargs);
499     }
500     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
501         string[] memory dynargs = new string[](3);
502         dynargs[0] = args[0];
503         dynargs[1] = args[1];
504         dynargs[2] = args[2];
505         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
506     }
507     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
508         string[] memory dynargs = new string[](3);
509         dynargs[0] = args[0];
510         dynargs[1] = args[1];
511         dynargs[2] = args[2];
512         return oraclize_query(datasource, dynargs, gaslimit);
513     }
514 
515     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
516         string[] memory dynargs = new string[](4);
517         dynargs[0] = args[0];
518         dynargs[1] = args[1];
519         dynargs[2] = args[2];
520         dynargs[3] = args[3];
521         return oraclize_query(datasource, dynargs);
522     }
523     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
524         string[] memory dynargs = new string[](4);
525         dynargs[0] = args[0];
526         dynargs[1] = args[1];
527         dynargs[2] = args[2];
528         dynargs[3] = args[3];
529         return oraclize_query(timestamp, datasource, dynargs);
530     }
531     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
532         string[] memory dynargs = new string[](4);
533         dynargs[0] = args[0];
534         dynargs[1] = args[1];
535         dynargs[2] = args[2];
536         dynargs[3] = args[3];
537         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
538     }
539     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
540         string[] memory dynargs = new string[](4);
541         dynargs[0] = args[0];
542         dynargs[1] = args[1];
543         dynargs[2] = args[2];
544         dynargs[3] = args[3];
545         return oraclize_query(datasource, dynargs, gaslimit);
546     }
547     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
548         string[] memory dynargs = new string[](5);
549         dynargs[0] = args[0];
550         dynargs[1] = args[1];
551         dynargs[2] = args[2];
552         dynargs[3] = args[3];
553         dynargs[4] = args[4];
554         return oraclize_query(datasource, dynargs);
555     }
556     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
557         string[] memory dynargs = new string[](5);
558         dynargs[0] = args[0];
559         dynargs[1] = args[1];
560         dynargs[2] = args[2];
561         dynargs[3] = args[3];
562         dynargs[4] = args[4];
563         return oraclize_query(timestamp, datasource, dynargs);
564     }
565     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
566         string[] memory dynargs = new string[](5);
567         dynargs[0] = args[0];
568         dynargs[1] = args[1];
569         dynargs[2] = args[2];
570         dynargs[3] = args[3];
571         dynargs[4] = args[4];
572         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
573     }
574     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
575         string[] memory dynargs = new string[](5);
576         dynargs[0] = args[0];
577         dynargs[1] = args[1];
578         dynargs[2] = args[2];
579         dynargs[3] = args[3];
580         dynargs[4] = args[4];
581         return oraclize_query(datasource, dynargs, gaslimit);
582     }
583     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
584         uint price = oraclize.getPrice(datasource);
585         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
586         bytes memory args = ba2cbor(argN);
587         return oraclize.queryN.value(price)(0, datasource, args);
588     }
589     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
590         uint price = oraclize.getPrice(datasource);
591         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
592         bytes memory args = ba2cbor(argN);
593         return oraclize.queryN.value(price)(timestamp, datasource, args);
594     }
595     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
596         uint price = oraclize.getPrice(datasource, gaslimit);
597         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
598         bytes memory args = ba2cbor(argN);
599         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
600     }
601     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
602         uint price = oraclize.getPrice(datasource, gaslimit);
603         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
604         bytes memory args = ba2cbor(argN);
605         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
606     }
607     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
608         bytes[] memory dynargs = new bytes[](1);
609         dynargs[0] = args[0];
610         return oraclize_query(datasource, dynargs);
611     }
612     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
613         bytes[] memory dynargs = new bytes[](1);
614         dynargs[0] = args[0];
615         return oraclize_query(timestamp, datasource, dynargs);
616     }
617     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
618         bytes[] memory dynargs = new bytes[](1);
619         dynargs[0] = args[0];
620         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
621     }
622     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
623         bytes[] memory dynargs = new bytes[](1);
624         dynargs[0] = args[0];
625         return oraclize_query(datasource, dynargs, gaslimit);
626     }
627 
628     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
629         bytes[] memory dynargs = new bytes[](2);
630         dynargs[0] = args[0];
631         dynargs[1] = args[1];
632         return oraclize_query(datasource, dynargs);
633     }
634     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
635         bytes[] memory dynargs = new bytes[](2);
636         dynargs[0] = args[0];
637         dynargs[1] = args[1];
638         return oraclize_query(timestamp, datasource, dynargs);
639     }
640     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
641         bytes[] memory dynargs = new bytes[](2);
642         dynargs[0] = args[0];
643         dynargs[1] = args[1];
644         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
645     }
646     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
647         bytes[] memory dynargs = new bytes[](2);
648         dynargs[0] = args[0];
649         dynargs[1] = args[1];
650         return oraclize_query(datasource, dynargs, gaslimit);
651     }
652     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
653         bytes[] memory dynargs = new bytes[](3);
654         dynargs[0] = args[0];
655         dynargs[1] = args[1];
656         dynargs[2] = args[2];
657         return oraclize_query(datasource, dynargs);
658     }
659     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
660         bytes[] memory dynargs = new bytes[](3);
661         dynargs[0] = args[0];
662         dynargs[1] = args[1];
663         dynargs[2] = args[2];
664         return oraclize_query(timestamp, datasource, dynargs);
665     }
666     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
667         bytes[] memory dynargs = new bytes[](3);
668         dynargs[0] = args[0];
669         dynargs[1] = args[1];
670         dynargs[2] = args[2];
671         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
672     }
673     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
674         bytes[] memory dynargs = new bytes[](3);
675         dynargs[0] = args[0];
676         dynargs[1] = args[1];
677         dynargs[2] = args[2];
678         return oraclize_query(datasource, dynargs, gaslimit);
679     }
680 
681     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
682         bytes[] memory dynargs = new bytes[](4);
683         dynargs[0] = args[0];
684         dynargs[1] = args[1];
685         dynargs[2] = args[2];
686         dynargs[3] = args[3];
687         return oraclize_query(datasource, dynargs);
688     }
689     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
690         bytes[] memory dynargs = new bytes[](4);
691         dynargs[0] = args[0];
692         dynargs[1] = args[1];
693         dynargs[2] = args[2];
694         dynargs[3] = args[3];
695         return oraclize_query(timestamp, datasource, dynargs);
696     }
697     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
698         bytes[] memory dynargs = new bytes[](4);
699         dynargs[0] = args[0];
700         dynargs[1] = args[1];
701         dynargs[2] = args[2];
702         dynargs[3] = args[3];
703         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
704     }
705     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
706         bytes[] memory dynargs = new bytes[](4);
707         dynargs[0] = args[0];
708         dynargs[1] = args[1];
709         dynargs[2] = args[2];
710         dynargs[3] = args[3];
711         return oraclize_query(datasource, dynargs, gaslimit);
712     }
713     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
714         bytes[] memory dynargs = new bytes[](5);
715         dynargs[0] = args[0];
716         dynargs[1] = args[1];
717         dynargs[2] = args[2];
718         dynargs[3] = args[3];
719         dynargs[4] = args[4];
720         return oraclize_query(datasource, dynargs);
721     }
722     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
723         bytes[] memory dynargs = new bytes[](5);
724         dynargs[0] = args[0];
725         dynargs[1] = args[1];
726         dynargs[2] = args[2];
727         dynargs[3] = args[3];
728         dynargs[4] = args[4];
729         return oraclize_query(timestamp, datasource, dynargs);
730     }
731     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
732         bytes[] memory dynargs = new bytes[](5);
733         dynargs[0] = args[0];
734         dynargs[1] = args[1];
735         dynargs[2] = args[2];
736         dynargs[3] = args[3];
737         dynargs[4] = args[4];
738         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
739     }
740     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
741         bytes[] memory dynargs = new bytes[](5);
742         dynargs[0] = args[0];
743         dynargs[1] = args[1];
744         dynargs[2] = args[2];
745         dynargs[3] = args[3];
746         dynargs[4] = args[4];
747         return oraclize_query(datasource, dynargs, gaslimit);
748     }
749 
750     function oraclize_cbAddress() oraclizeAPI internal returns (address){
751         return oraclize.cbAddress();
752     }
753     function oraclize_setProof(byte proofP) oraclizeAPI internal {
754         return oraclize.setProofType(proofP);
755     }
756     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
757         return oraclize.setCustomGasPrice(gasPrice);
758     }
759 
760     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
761         return oraclize.randomDS_getSessionPubKeyHash();
762     }
763 
764     function getCodeSize(address _addr) constant internal returns(uint _size) {
765         assembly {
766             _size := extcodesize(_addr)
767         }
768     }
769 
770     function parseAddr(string _a) internal pure returns (address){
771         bytes memory tmp = bytes(_a);
772         uint160 iaddr = 0;
773         uint160 b1;
774         uint160 b2;
775         for (uint i=2; i<2+2*20; i+=2){
776             iaddr *= 256;
777             b1 = uint160(tmp[i]);
778             b2 = uint160(tmp[i+1]);
779             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
780             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
781             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
782             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
783             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
784             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
785             iaddr += (b1*16+b2);
786         }
787         return address(iaddr);
788     }
789 
790     function strCompare(string _a, string _b) internal pure returns (int) {
791         bytes memory a = bytes(_a);
792         bytes memory b = bytes(_b);
793         uint minLength = a.length;
794         if (b.length < minLength) minLength = b.length;
795         for (uint i = 0; i < minLength; i ++)
796             if (a[i] < b[i])
797                 return -1;
798             else if (a[i] > b[i])
799                 return 1;
800         if (a.length < b.length)
801             return -1;
802         else if (a.length > b.length)
803             return 1;
804         else
805             return 0;
806     }
807 
808     function indexOf(string _haystack, string _needle) internal pure returns (int) {
809         bytes memory h = bytes(_haystack);
810         bytes memory n = bytes(_needle);
811         if(h.length < 1 || n.length < 1 || (n.length > h.length))
812             return -1;
813         else if(h.length > (2**128 -1))
814             return -1;
815         else
816         {
817             uint subindex = 0;
818             for (uint i = 0; i < h.length; i ++)
819             {
820                 if (h[i] == n[0])
821                 {
822                     subindex = 1;
823                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
824                     {
825                         subindex++;
826                     }
827                     if(subindex == n.length)
828                         return int(i);
829                 }
830             }
831             return -1;
832         }
833     }
834 
835     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
836         bytes memory _ba = bytes(_a);
837         bytes memory _bb = bytes(_b);
838         bytes memory _bc = bytes(_c);
839         bytes memory _bd = bytes(_d);
840         bytes memory _be = bytes(_e);
841         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
842         bytes memory babcde = bytes(abcde);
843         uint k = 0;
844         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
845         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
846         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
847         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
848         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
849         return string(babcde);
850     }
851 
852     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
853         return strConcat(_a, _b, _c, _d, "");
854     }
855 
856     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
857         return strConcat(_a, _b, _c, "", "");
858     }
859 
860     function strConcat(string _a, string _b) internal pure returns (string) {
861         return strConcat(_a, _b, "", "", "");
862     }
863 
864     // parseInt
865     function parseInt(string _a) internal pure returns (uint) {
866         return parseInt(_a, 0);
867     }
868 
869     // parseInt(parseFloat*10^_b)
870     function parseInt(string _a, uint _b) internal pure returns (uint) {
871         bytes memory bresult = bytes(_a);
872         uint mint = 0;
873         bool decimals = false;
874         for (uint i=0; i<bresult.length; i++){
875             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
876                 if (decimals){
877                    if (_b == 0) break;
878                     else _b--;
879                 }
880                 mint *= 10;
881                 mint += uint(bresult[i]) - 48;
882             } else if (bresult[i] == 46) decimals = true;
883         }
884         if (_b > 0) mint *= 10**_b;
885         return mint;
886     }
887 
888     function uint2str(uint i) internal pure returns (string){
889         if (i == 0) return "0";
890         uint j = i;
891         uint len;
892         while (j != 0){
893             len++;
894             j /= 10;
895         }
896         bytes memory bstr = new bytes(len);
897         uint k = len - 1;
898         while (i != 0){
899             bstr[k--] = byte(48 + i % 10);
900             i /= 10;
901         }
902         return string(bstr);
903     }
904 
905     using CBOR for Buffer.buffer;
906     function stra2cbor(string[] arr) internal pure returns (bytes) {
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
918         Buffer.buffer memory buf;
919         Buffer.init(buf, 1024);
920         buf.startArray();
921         for (uint i = 0; i < arr.length; i++) {
922             buf.encodeBytes(arr[i]);
923         }
924         buf.endSequence();
925         return buf.buf;
926     }
927 
928     string oraclize_network_name;
929     function oraclize_setNetworkName(string _network_name) internal {
930         oraclize_network_name = _network_name;
931     }
932 
933     function oraclize_getNetworkName() internal view returns (string) {
934         return oraclize_network_name;
935     }
936 
937     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
938         require((_nbytes > 0) && (_nbytes <= 32));
939         // Convert from seconds to ledger timer ticks
940         _delay *= 10;
941         bytes memory nbytes = new bytes(1);
942         nbytes[0] = byte(_nbytes);
943         bytes memory unonce = new bytes(32);
944         bytes memory sessionKeyHash = new bytes(32);
945         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
946         assembly {
947             mstore(unonce, 0x20)
948             // the following variables can be relaxed
949             // check relaxed random contract under ethereum-examples repo
950             // for an idea on how to override and replace comit hash vars
951             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
952             mstore(sessionKeyHash, 0x20)
953             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
954         }
955         bytes memory delay = new bytes(32);
956         assembly {
957             mstore(add(delay, 0x20), _delay)
958         }
959 
960         bytes memory delay_bytes8 = new bytes(8);
961         copyBytes(delay, 24, 8, delay_bytes8, 0);
962 
963         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
964         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
965 
966         bytes memory delay_bytes8_left = new bytes(8);
967 
968         assembly {
969             let x := mload(add(delay_bytes8, 0x20))
970             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
971             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
972             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
973             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
974             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
975             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
976             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
977             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
978 
979         }
980 
981         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
982         return queryId;
983     }
984 
985     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
986         oraclize_randomDS_args[queryId] = commitment;
987     }
988 
989     mapping(bytes32=>bytes32) oraclize_randomDS_args;
990     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
991 
992     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
993         bool sigok;
994         address signer;
995 
996         bytes32 sigr;
997         bytes32 sigs;
998 
999         bytes memory sigr_ = new bytes(32);
1000         uint offset = 4+(uint(dersig[3]) - 0x20);
1001         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1002         bytes memory sigs_ = new bytes(32);
1003         offset += 32 + 2;
1004         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1005 
1006         assembly {
1007             sigr := mload(add(sigr_, 32))
1008             sigs := mload(add(sigs_, 32))
1009         }
1010 
1011 
1012         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1013         if (address(keccak256(pubkey)) == signer) return true;
1014         else {
1015             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1016             return (address(keccak256(pubkey)) == signer);
1017         }
1018     }
1019 
1020     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1021         bool sigok;
1022 
1023         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1024         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1025         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1026 
1027         bytes memory appkey1_pubkey = new bytes(64);
1028         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1029 
1030         bytes memory tosign2 = new bytes(1+65+32);
1031         tosign2[0] = byte(1); //role
1032         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1033         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1034         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1035         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1036 
1037         if (sigok == false) return false;
1038 
1039 
1040         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1041         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1042 
1043         bytes memory tosign3 = new bytes(1+65);
1044         tosign3[0] = 0xFE;
1045         copyBytes(proof, 3, 65, tosign3, 1);
1046 
1047         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1048         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1049 
1050         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1051 
1052         return sigok;
1053     }
1054 
1055     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1056         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1057         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1058 
1059         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1060         require(proofVerified);
1061 
1062         _;
1063     }
1064 
1065     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1066         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1067         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1068 
1069         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1070         if (proofVerified == false) return 2;
1071 
1072         return 0;
1073     }
1074 
1075     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1076         bool match_ = true;
1077 
1078         require(prefix.length == n_random_bytes);
1079 
1080         for (uint256 i=0; i< n_random_bytes; i++) {
1081             if (content[i] != prefix[i]) match_ = false;
1082         }
1083 
1084         return match_;
1085     }
1086 
1087     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1088 
1089         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1090         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1091         bytes memory keyhash = new bytes(32);
1092         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1093         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1094 
1095         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1096         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1097 
1098         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1099         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1100 
1101         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1102         // This is to verify that the computed args match with the ones specified in the query.
1103         bytes memory commitmentSlice1 = new bytes(8+1+32);
1104         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1105 
1106         bytes memory sessionPubkey = new bytes(64);
1107         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1108         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1109 
1110         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1111         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1112             delete oraclize_randomDS_args[queryId];
1113         } else return false;
1114 
1115 
1116         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1117         bytes memory tosign1 = new bytes(32+8+1+32);
1118         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1119         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1120 
1121         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1122         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1123             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1124         }
1125 
1126         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1127     }
1128 
1129     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1130     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1131         uint minLength = length + toOffset;
1132 
1133         // Buffer too small
1134         require(to.length >= minLength); // Should be a better way?
1135 
1136         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1137         uint i = 32 + fromOffset;
1138         uint j = 32 + toOffset;
1139 
1140         while (i < (32 + fromOffset + length)) {
1141             assembly {
1142                 let tmp := mload(add(from, i))
1143                 mstore(add(to, j), tmp)
1144             }
1145             i += 32;
1146             j += 32;
1147         }
1148 
1149         return to;
1150     }
1151 
1152     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1153     // Duplicate Solidity's ecrecover, but catching the CALL return value
1154     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1155         // We do our own memory management here. Solidity uses memory offset
1156         // 0x40 to store the current end of memory. We write past it (as
1157         // writes are memory extensions), but don't update the offset so
1158         // Solidity will reuse it. The memory used here is only needed for
1159         // this context.
1160 
1161         // FIXME: inline assembly can't access return values
1162         bool ret;
1163         address addr;
1164 
1165         assembly {
1166             let size := mload(0x40)
1167             mstore(size, hash)
1168             mstore(add(size, 32), v)
1169             mstore(add(size, 64), r)
1170             mstore(add(size, 96), s)
1171 
1172             // NOTE: we can reuse the request memory because we deal with
1173             //       the return code
1174             ret := call(3000, 1, 0, size, 128, size, 32)
1175             addr := mload(size)
1176         }
1177 
1178         return (ret, addr);
1179     }
1180 
1181     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1182     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1183         bytes32 r;
1184         bytes32 s;
1185         uint8 v;
1186 
1187         if (sig.length != 65)
1188           return (false, 0);
1189 
1190         // The signature format is a compact form of:
1191         //   {bytes32 r}{bytes32 s}{uint8 v}
1192         // Compact means, uint8 is not padded to 32 bytes.
1193         assembly {
1194             r := mload(add(sig, 32))
1195             s := mload(add(sig, 64))
1196 
1197             // Here we are loading the last 32 bytes. We exploit the fact that
1198             // 'mload' will pad with zeroes if we overread.
1199             // There is no 'mload8' to do this, but that would be nicer.
1200             v := byte(0, mload(add(sig, 96)))
1201 
1202             // Alternative solution:
1203             // 'byte' is not working due to the Solidity parser, so lets
1204             // use the second best option, 'and'
1205             // v := and(mload(add(sig, 65)), 255)
1206         }
1207 
1208         // albeit non-transactional signatures are not specified by the YP, one would expect it
1209         // to match the YP range of [27, 28]
1210         //
1211         // geth uses [0, 1] and some clients have followed. This might change, see:
1212         //  https://github.com/ethereum/go-ethereum/issues/2053
1213         if (v < 27)
1214           v += 27;
1215 
1216         if (v != 27 && v != 28)
1217             return (false, 0);
1218 
1219         return safer_ecrecover(hash, v, r, s);
1220     }
1221 
1222 }
1223 // </ORACLIZE_API>
1224 
1225 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1226 
1227 /**
1228  * @title Ownable
1229  * @dev The Ownable contract has an owner address, and provides basic authorization control
1230  * functions, this simplifies the implementation of "user permissions".
1231  */
1232 contract Ownable {
1233   address public owner;
1234 
1235 
1236   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1237 
1238 
1239   /**
1240    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1241    * account.
1242    */
1243   function Ownable() public {
1244     owner = msg.sender;
1245   }
1246 
1247   /**
1248    * @dev Throws if called by any account other than the owner.
1249    */
1250   modifier onlyOwner() {
1251     require(msg.sender == owner);
1252     _;
1253   }
1254 
1255   /**
1256    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1257    * @param newOwner The address to transfer ownership to.
1258    */
1259   function transferOwnership(address newOwner) public onlyOwner {
1260     require(newOwner != address(0));
1261     OwnershipTransferred(owner, newOwner);
1262     owner = newOwner;
1263   }
1264 
1265 }
1266 
1267 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
1268 
1269 /**
1270  * @title Contracts that should not own Ether
1271  * @author Remco Bloemen <remco@2π.com>
1272  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
1273  * in the contract, it will allow the owner to reclaim this ether.
1274  * @notice Ether can still be send to this contract by:
1275  * calling functions labeled `payable`
1276  * `selfdestruct(contract_address)`
1277  * mining directly to the contract address
1278 */
1279 contract HasNoEther is Ownable {
1280 
1281   /**
1282   * @dev Constructor that rejects incoming Ether
1283   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
1284   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
1285   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
1286   * we could use assembly to access msg.value.
1287   */
1288   function HasNoEther() public payable {
1289     require(msg.value == 0);
1290   }
1291 
1292   /**
1293    * @dev Disallows direct send by settings a default function without the `payable` flag.
1294    */
1295   function() external {
1296   }
1297 
1298   /**
1299    * @dev Transfer all Ether held by the contract to the owner.
1300    */
1301   function reclaimEther() external onlyOwner {
1302     assert(owner.send(this.balance));
1303   }
1304 }
1305 
1306 // File: contracts/OwnershipClaimer.sol
1307 
1308 interface ManagerInterface {
1309 
1310   function getAppId(
1311     string _appNickname
1312   )
1313   external
1314   constant returns (uint);
1315 
1316 
1317   function setIdentity(
1318     uint _appId,
1319     address _address,
1320     string _uid
1321   )
1322   external;
1323 
1324 }
1325 
1326 
1327 /**
1328  * @title OwnershipClaimer
1329  * @author Francesco Sullo <francesco@sullo.co>
1330  * @dev It allow user to self claim ownership of a supported web app account
1331  */
1332 
1333 
1334 
1335 contract OwnershipClaimer
1336 is usingOraclize, HasNoEther
1337 {
1338 
1339   string public fromVersion = "1.0.0";
1340 
1341   string public apiUrl = "https://api.tweedentity.net/";
1342 
1343   struct TempData {
1344     address sender;
1345     uint appId;
1346   }
1347 
1348   mapping(bytes32 => TempData) internal __tempData;
1349 
1350   ManagerInterface public manager;
1351   address public managerAddress;
1352 
1353 
1354 
1355   //events
1356 
1357 
1358   event ManagerSet(
1359     address indexed manager
1360   );
1361 
1362 
1363   event VerificationStarted(
1364     bytes32 oraclizeId,
1365     address indexed addr,
1366     string appNickname,
1367     string postId
1368   );
1369 
1370 
1371   event VerificatioFailed(
1372     bytes32 indexed oraclizeId
1373   );
1374 
1375 
1376 
1377   // modifiers
1378 
1379 
1380   modifier whenAppSet(
1381     string _appNickname
1382   ) {
1383     require(manager.getAppId(_appNickname) > 0);
1384     _;
1385   }
1386 
1387 
1388 
1389   // config
1390 
1391 
1392   function setManager(
1393     address _address
1394   )
1395   public
1396   onlyOwner
1397   {
1398     require(_address != address(0));
1399     managerAddress = _address;
1400     manager = ManagerInterface(_address);
1401     ManagerSet(_address);
1402   }
1403 
1404 
1405 
1406   // primary methods
1407 
1408 
1409   /**
1410    * @dev Allow a wallet to claim ownership of an account
1411    * @param _appNickname Identifies the web app for the account
1412    * @param _postId Id id of the post contains the signature
1413    * @param _gasPrice The gas price for Oraclize
1414    * @param _gasLimit The gas limit for Oraclize
1415    */
1416   function claimAccountOwnership(
1417     string _appNickname,
1418     string _postId,
1419     uint _gasPrice,
1420     uint _gasLimit
1421   )
1422   public
1423   whenAppSet(_appNickname)
1424   payable
1425   {
1426     require(bytes(_postId).length > 0);
1427     require(msg.value >= _gasPrice * _gasLimit);
1428 
1429     oraclize_setCustomGasPrice(_gasPrice);
1430 
1431     string[6] memory str;
1432     str[0] = apiUrl;
1433     str[1] = _appNickname;
1434     str[2] = "/";
1435     str[3] = _postId;
1436     str[4] = "/0x";
1437     str[5] = __addressToString(msg.sender);
1438 
1439     bytes32 oraclizeID = oraclize_query(
1440       "URL",
1441       __concat(str),
1442       _gasLimit
1443     );
1444     VerificationStarted(oraclizeID, msg.sender, _appNickname, _postId);
1445     __tempData[oraclizeID] = TempData(msg.sender, manager.getAppId(_appNickname));
1446   }
1447 
1448 
1449   /**
1450    * @dev Receive the call from Oraclize
1451    * @param _oraclizeID The oraclize id
1452    * @param _result The text resulting from requesting the url
1453    */
1454   function __callback(
1455     bytes32 _oraclizeID,
1456     string _result
1457   )
1458   public
1459   {
1460     require(msg.sender == oraclize_cbAddress());
1461     if (bytes(_result).length > 0) {
1462       manager.setIdentity(__tempData[_oraclizeID].appId, __tempData[_oraclizeID].sender, _result);
1463     } else {
1464       VerificatioFailed(_oraclizeID);
1465     }
1466   }
1467 
1468 
1469 
1470   // private methods
1471 
1472 
1473   function __addressToString(
1474     address _address
1475   )
1476   internal
1477   pure
1478   returns (string)
1479   {
1480     bytes memory s = new bytes(40);
1481     for (uint i = 0; i < 20; i++) {
1482       byte b = byte(uint8(uint(_address) / (2 ** (8 * (19 - i)))));
1483       byte hi = byte(uint8(b) / 16);
1484       byte lo = byte(uint8(b) - 16 * uint8(hi));
1485       s[2 * i] = __char(hi);
1486       s[2 * i + 1] = __char(lo);
1487     }
1488     return string(s);
1489   }
1490 
1491 
1492   function __char(
1493     byte b
1494   )
1495   internal
1496   pure
1497   returns (byte c)
1498   {
1499     if (b < 10) return byte(uint8(b) + 0x30);
1500     else return byte(uint8(b) + 0x57);
1501   }
1502 
1503 
1504   function __concat(
1505     string[6] _strings
1506   )
1507   internal
1508   pure
1509   returns (string)
1510   {
1511     uint len = 0;
1512     uint i;
1513     for (i = 0; i < _strings.length; i++) {
1514       len = len + bytes(_strings[i]).length;
1515     }
1516     string memory str = new string(len);
1517     bytes memory bstr = bytes(str);
1518     uint k = 0;
1519     uint j;
1520     bytes memory b;
1521     for (i = 0; i < _strings.length; i++) {
1522       b = bytes(_strings[i]);
1523       for (j = 0; j < b.length; j++) bstr[k++] = b[j];
1524     }
1525     return string(bstr);
1526   }
1527 
1528 }