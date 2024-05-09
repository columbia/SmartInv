1 pragma solidity ^0.4.21;
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
35 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
36 
37 contract OraclizeI {
38     address public cbAddress;
39     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
40     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
41     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
42     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
43     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
44     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
45     function getPrice(string _datasource) public returns (uint _dsprice);
46     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
47     function setProofType(byte _proofType) external;
48     function setCustomGasPrice(uint _gasPrice) external;
49     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
50 }
51 
52 contract OraclizeAddrResolverI {
53     function getAddress() public returns (address _addr);
54 }
55 
56 /*
57 Begin solidity-cborutils
58 
59 https://github.com/smartcontractkit/solidity-cborutils
60 
61 MIT License
62 
63 Copyright (c) 2018 SmartContract ChainLink, Ltd.
64 
65 Permission is hereby granted, free of charge, to any person obtaining a copy
66 of this software and associated documentation files (the "Software"), to deal
67 in the Software without restriction, including without limitation the rights
68 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
69 copies of the Software, and to permit persons to whom the Software is
70 furnished to do so, subject to the following conditions:
71 
72 The above copyright notice and this permission notice shall be included in all
73 copies or substantial portions of the Software.
74 
75 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
76 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
77 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
78 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
79 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
80 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
81 SOFTWARE.
82  */
83 
84 library Buffer {
85     struct buffer {
86         bytes buf;
87         uint capacity;
88     }
89 
90     function init(buffer memory buf, uint _capacity) internal pure {
91         uint capacity = _capacity;
92         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
93         // Allocate space for the buffer data
94         buf.capacity = capacity;
95         assembly {
96             let ptr := mload(0x40)
97             mstore(buf, ptr)
98             mstore(ptr, 0)
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
117      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
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
164      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
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
189      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
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
294     byte constant proofType_Ledger = 0x30;
295     byte constant proofType_Android = 0x40;
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
907         safeMemoryCleaner();
908         Buffer.buffer memory buf;
909         Buffer.init(buf, 1024);
910         buf.startArray();
911         for (uint i = 0; i < arr.length; i++) {
912             buf.encodeString(arr[i]);
913         }
914         buf.endSequence();
915         return buf.buf;
916     }
917 
918     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
919         safeMemoryCleaner();
920         Buffer.buffer memory buf;
921         Buffer.init(buf, 1024);
922         buf.startArray();
923         for (uint i = 0; i < arr.length; i++) {
924             buf.encodeBytes(arr[i]);
925         }
926         buf.endSequence();
927         return buf.buf;
928     }
929 
930     string oraclize_network_name;
931     function oraclize_setNetworkName(string _network_name) internal {
932         oraclize_network_name = _network_name;
933     }
934 
935     function oraclize_getNetworkName() internal view returns (string) {
936         return oraclize_network_name;
937     }
938 
939     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
940         require((_nbytes > 0) && (_nbytes <= 32));
941         // Convert from seconds to ledger timer ticks
942         _delay *= 10;
943         bytes memory nbytes = new bytes(1);
944         nbytes[0] = byte(_nbytes);
945         bytes memory unonce = new bytes(32);
946         bytes memory sessionKeyHash = new bytes(32);
947         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
948         assembly {
949             mstore(unonce, 0x20)
950             // the following variables can be relaxed
951             // check relaxed random contract under ethereum-examples repo
952             // for an idea on how to override and replace comit hash vars
953             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
954             mstore(sessionKeyHash, 0x20)
955             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
956         }
957         bytes memory delay = new bytes(32);
958         assembly {
959             mstore(add(delay, 0x20), _delay)
960         }
961 
962         bytes memory delay_bytes8 = new bytes(8);
963         copyBytes(delay, 24, 8, delay_bytes8, 0);
964 
965         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
966         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
967 
968         bytes memory delay_bytes8_left = new bytes(8);
969 
970         assembly {
971             let x := mload(add(delay_bytes8, 0x20))
972             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
973             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
974             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
975             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
976             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
977             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
978             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
979             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
980 
981         }
982 
983         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
984         return queryId;
985     }
986 
987     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
988         oraclize_randomDS_args[queryId] = commitment;
989     }
990 
991     mapping(bytes32=>bytes32) oraclize_randomDS_args;
992     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
993 
994     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
995         bool sigok;
996         address signer;
997 
998         bytes32 sigr;
999         bytes32 sigs;
1000 
1001         bytes memory sigr_ = new bytes(32);
1002         uint offset = 4+(uint(dersig[3]) - 0x20);
1003         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1004         bytes memory sigs_ = new bytes(32);
1005         offset += 32 + 2;
1006         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1007 
1008         assembly {
1009             sigr := mload(add(sigr_, 32))
1010             sigs := mload(add(sigs_, 32))
1011         }
1012 
1013 
1014         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1015         if (address(keccak256(pubkey)) == signer) return true;
1016         else {
1017             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1018             return (address(keccak256(pubkey)) == signer);
1019         }
1020     }
1021 
1022     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1023         bool sigok;
1024 
1025         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1026         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1027         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1028 
1029         bytes memory appkey1_pubkey = new bytes(64);
1030         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1031 
1032         bytes memory tosign2 = new bytes(1+65+32);
1033         tosign2[0] = byte(1); //role
1034         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1035         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1036         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1037         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1038 
1039         if (sigok == false) return false;
1040 
1041 
1042         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1043         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1044 
1045         bytes memory tosign3 = new bytes(1+65);
1046         tosign3[0] = 0xFE;
1047         copyBytes(proof, 3, 65, tosign3, 1);
1048 
1049         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1050         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1051 
1052         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1053 
1054         return sigok;
1055     }
1056 
1057     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1058         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1059         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1060 
1061         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1062         require(proofVerified);
1063 
1064         _;
1065     }
1066 
1067     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1068         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1069         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1070 
1071         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1072         if (proofVerified == false) return 2;
1073 
1074         return 0;
1075     }
1076 
1077     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1078         bool match_ = true;
1079 
1080         require(prefix.length == n_random_bytes);
1081 
1082         for (uint256 i=0; i< n_random_bytes; i++) {
1083             if (content[i] != prefix[i]) match_ = false;
1084         }
1085 
1086         return match_;
1087     }
1088 
1089     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1090 
1091         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1092         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1093         bytes memory keyhash = new bytes(32);
1094         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1095         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1096 
1097         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1098         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1099 
1100         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1101         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1102 
1103         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1104         // This is to verify that the computed args match with the ones specified in the query.
1105         bytes memory commitmentSlice1 = new bytes(8+1+32);
1106         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1107 
1108         bytes memory sessionPubkey = new bytes(64);
1109         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1110         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1111 
1112         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1113         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1114             delete oraclize_randomDS_args[queryId];
1115         } else return false;
1116 
1117 
1118         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1119         bytes memory tosign1 = new bytes(32+8+1+32);
1120         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1121         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1122 
1123         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1124         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1125             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1126         }
1127 
1128         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1129     }
1130 
1131     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1132     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1133         uint minLength = length + toOffset;
1134 
1135         // Buffer too small
1136         require(to.length >= minLength); // Should be a better way?
1137 
1138         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1139         uint i = 32 + fromOffset;
1140         uint j = 32 + toOffset;
1141 
1142         while (i < (32 + fromOffset + length)) {
1143             assembly {
1144                 let tmp := mload(add(from, i))
1145                 mstore(add(to, j), tmp)
1146             }
1147             i += 32;
1148             j += 32;
1149         }
1150 
1151         return to;
1152     }
1153 
1154     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1155     // Duplicate Solidity's ecrecover, but catching the CALL return value
1156     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1157         // We do our own memory management here. Solidity uses memory offset
1158         // 0x40 to store the current end of memory. We write past it (as
1159         // writes are memory extensions), but don't update the offset so
1160         // Solidity will reuse it. The memory used here is only needed for
1161         // this context.
1162 
1163         // FIXME: inline assembly can't access return values
1164         bool ret;
1165         address addr;
1166 
1167         assembly {
1168             let size := mload(0x40)
1169             mstore(size, hash)
1170             mstore(add(size, 32), v)
1171             mstore(add(size, 64), r)
1172             mstore(add(size, 96), s)
1173 
1174             // NOTE: we can reuse the request memory because we deal with
1175             //       the return code
1176             ret := call(3000, 1, 0, size, 128, size, 32)
1177             addr := mload(size)
1178         }
1179 
1180         return (ret, addr);
1181     }
1182 
1183     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1184     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1185         bytes32 r;
1186         bytes32 s;
1187         uint8 v;
1188 
1189         if (sig.length != 65)
1190           return (false, 0);
1191 
1192         // The signature format is a compact form of:
1193         //   {bytes32 r}{bytes32 s}{uint8 v}
1194         // Compact means, uint8 is not padded to 32 bytes.
1195         assembly {
1196             r := mload(add(sig, 32))
1197             s := mload(add(sig, 64))
1198 
1199             // Here we are loading the last 32 bytes. We exploit the fact that
1200             // 'mload' will pad with zeroes if we overread.
1201             // There is no 'mload8' to do this, but that would be nicer.
1202             v := byte(0, mload(add(sig, 96)))
1203 
1204             // Alternative solution:
1205             // 'byte' is not working due to the Solidity parser, so lets
1206             // use the second best option, 'and'
1207             // v := and(mload(add(sig, 65)), 255)
1208         }
1209 
1210         // albeit non-transactional signatures are not specified by the YP, one would expect it
1211         // to match the YP range of [27, 28]
1212         //
1213         // geth uses [0, 1] and some clients have followed. This might change, see:
1214         //  https://github.com/ethereum/go-ethereum/issues/2053
1215         if (v < 27)
1216           v += 27;
1217 
1218         if (v != 27 && v != 28)
1219             return (false, 0);
1220 
1221         return safer_ecrecover(hash, v, r, s);
1222     }
1223 
1224     function safeMemoryCleaner() internal pure {
1225         assembly {
1226             let fmem := mload(0x40)
1227             codecopy(fmem, codesize, sub(msize, fmem))
1228         }
1229     }
1230 
1231 }
1232 // </ORACLIZE_API>
1233 
1234 library SafeMath {
1235   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1236     uint256 c = a * b;
1237     assert(a == 0 || c / a == b);
1238     return c;
1239   }
1240 
1241   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1242     // assert(b > 0); // Solidity automatically throws when dividing by 0
1243     uint256 c = a / b;
1244     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1245     return c;
1246   }
1247 
1248   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1249     assert(b <= a);
1250     return a - b;
1251   }
1252 
1253   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1254     uint256 c = a + b;
1255     assert(c >= a);
1256     return c;
1257   }
1258 }
1259 
1260 contract Race{
1261     using SafeMath for uint256; //using safemath
1262 
1263     address public owner; //owner address
1264     address house_takeout = 0xf783A81F046448c38f3c863885D9e99D10209779;
1265 
1266     uint public winnerPoolTotal;
1267     string public constant version = "0.2.3";
1268 
1269     struct chronus_info {
1270         bool  betting_open; // boolean: check if betting is open
1271         bool  race_start; //boolean: check if race has started
1272         bool  race_end; //boolean: check if race has ended
1273         bool  voided_bet; //boolean: check if race has been voided
1274         uint32  starting_time; // timestamp of when the race starts
1275         uint32  betting_duration;
1276         uint32  race_duration; // duration of the race
1277         uint32 voided_timestamp;
1278     }
1279 
1280     struct horses_info{
1281         int64  BTC_delta; //horses.BTC delta value
1282         int64  ETH_delta; //horses.ETH delta value
1283         int64  LTC_delta; //horses.LTC delta value
1284         bytes32 BTC; //32-bytes equivalent of horses.BTC
1285         bytes32 ETH; //32-bytes equivalent of horses.ETH
1286         bytes32 LTC;  //32-bytes equivalent of horses.LTC
1287     }
1288 
1289     struct bet_info{
1290         bytes32 horse; // coin on which amount is bet on
1291         uint amount; // amount bet by Bettor
1292     }
1293     struct coin_info{
1294         uint256 pre; // locking price
1295         uint256 post; // ending price
1296         uint160 total; // total coin pool
1297         uint32 count; // number of bets
1298         bool price_check;
1299     }
1300     struct voter_info {
1301         uint160 total_bet; //total amount of bet placed
1302         bool rewarded; // boolean: check for double spending
1303         mapping(bytes32=>uint) bets; //array of bets
1304     }
1305 
1306     mapping (bytes32 => coin_info) public coinIndex; // mapping coins with pool information
1307     mapping (address => voter_info) voterIndex; // mapping voter address with Bettor information
1308 
1309     uint public total_reward; // total reward to be awarded
1310     uint32 total_bettors;
1311     mapping (bytes32 => bool) public winner_horse;
1312 
1313 
1314     // tracking events
1315     event Deposit(address _from, uint256 _value, bytes32 _horse, uint256 _date);
1316     event Withdraw(address _to, uint256 _value);
1317     event PriceCallback(bytes32 coin_pointer, uint256 result, bool isPrePrice);
1318     event RefundEnabled(string reason);
1319 
1320     // constructor
1321     constructor() public payable {
1322         
1323         owner = msg.sender;
1324         
1325         horses.BTC = bytes32("BTC");
1326         horses.ETH = bytes32("ETH");
1327         horses.LTC = bytes32("LTC");
1328         
1329     }
1330 
1331     // data access structures
1332     horses_info public horses;
1333     chronus_info public chronus;
1334 
1335     // modifiers for restricting access to methods
1336     modifier onlyOwner {
1337         require(owner == msg.sender);
1338         _;
1339     }
1340 
1341     modifier duringBetting {
1342         require(chronus.betting_open);
1343         require(now < chronus.starting_time + chronus.betting_duration);
1344         _;
1345     }
1346 
1347     modifier beforeBetting {
1348         require(!chronus.betting_open && !chronus.race_start);
1349         _;
1350     }
1351 
1352     modifier afterRace {
1353         require(chronus.race_end);
1354         _;
1355     }
1356 
1357     //function to change owner
1358     function changeOwnership(address _newOwner) onlyOwner external {
1359         owner = _newOwner;
1360     }
1361 
1362     function priceCallback (bytes32 coin_pointer, uint256 result, bool isPrePrice ) external onlyOwner {
1363         require (!chronus.race_end);
1364         emit PriceCallback(coin_pointer, result, isPrePrice);
1365         chronus.race_start = true;
1366         chronus.betting_open = false;
1367         if (isPrePrice) {
1368             if (now >= chronus.starting_time+chronus.betting_duration+ 60 minutes) {
1369                 emit RefundEnabled("Late start price");
1370                 forceVoidRace();
1371             } else {
1372                 coinIndex[coin_pointer].pre = result;
1373             }
1374         } else if (!isPrePrice){
1375             if (coinIndex[coin_pointer].pre > 0 ){
1376                 if (now >= chronus.starting_time+chronus.race_duration+ 60 minutes) {
1377                     emit RefundEnabled("Late end price");
1378                     forceVoidRace();
1379                 } else {
1380                     coinIndex[coin_pointer].post = result;
1381                     coinIndex[coin_pointer].price_check = true;
1382 
1383                     if (coinIndex[horses.ETH].price_check && coinIndex[horses.BTC].price_check && coinIndex[horses.LTC].price_check) {
1384                         reward();
1385                     }
1386                 }
1387             } else {
1388                 emit RefundEnabled("End price came before start price");
1389                 forceVoidRace();
1390             }
1391         }
1392     }
1393 
1394     // place a bet on a coin(horse) lockBetting
1395     function placeBet(bytes32 horse) external duringBetting payable  {
1396         require(msg.value >= 0.01 ether);
1397         if (voterIndex[msg.sender].total_bet==0) {
1398             total_bettors+=1;
1399         }
1400         uint _newAmount = voterIndex[msg.sender].bets[horse] + msg.value;
1401         voterIndex[msg.sender].bets[horse] = _newAmount;
1402         voterIndex[msg.sender].total_bet += uint160(msg.value);
1403         uint160 _newTotal = coinIndex[horse].total + uint160(msg.value);
1404         uint32 _newCount = coinIndex[horse].count + 1;
1405         coinIndex[horse].total = _newTotal;
1406         coinIndex[horse].count = _newCount;
1407         emit Deposit(msg.sender, msg.value, horse, now);
1408     }
1409 
1410     // fallback method for accepting payments
1411     function () private payable {}
1412 
1413     // method to place the oraclize queries
1414     function setupRace(uint32 _bettingDuration, uint32 _raceDuration) onlyOwner beforeBetting external payable {
1415             chronus.starting_time = uint32(block.timestamp);
1416             chronus.betting_open = true;
1417             chronus.betting_duration = _bettingDuration;
1418             chronus.race_duration = _raceDuration;
1419     }
1420 
1421     // method to calculate reward (called internally by callback)
1422     function reward() internal {
1423         /*
1424         calculating the difference in price with a precision of 5 digits
1425         not using safemath since signed integers are handled
1426         */
1427         horses.BTC_delta = int64(coinIndex[horses.BTC].post - coinIndex[horses.BTC].pre)*100000/int64(coinIndex[horses.BTC].pre);
1428         horses.ETH_delta = int64(coinIndex[horses.ETH].post - coinIndex[horses.ETH].pre)*100000/int64(coinIndex[horses.ETH].pre);
1429         horses.LTC_delta = int64(coinIndex[horses.LTC].post - coinIndex[horses.LTC].pre)*100000/int64(coinIndex[horses.LTC].pre);
1430 
1431         total_reward = (coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total);
1432         if (total_bettors <= 1) {
1433             emit RefundEnabled("Not enough participants");
1434             forceVoidRace();
1435         } else {
1436             uint house_fee = total_reward.mul(5).div(100);
1437             require(house_fee < address(this).balance);
1438             total_reward = total_reward.sub(house_fee);
1439             house_takeout.transfer(house_fee);
1440         }
1441 
1442         if (horses.BTC_delta > horses.ETH_delta) {
1443             if (horses.BTC_delta > horses.LTC_delta) {
1444                 winner_horse[horses.BTC] = true;
1445                 winnerPoolTotal = coinIndex[horses.BTC].total;
1446             }
1447             else if(horses.LTC_delta > horses.BTC_delta) {
1448                 winner_horse[horses.LTC] = true;
1449                 winnerPoolTotal = coinIndex[horses.LTC].total;
1450             } else {
1451                 winner_horse[horses.BTC] = true;
1452                 winner_horse[horses.LTC] = true;
1453                 winnerPoolTotal = coinIndex[horses.BTC].total + (coinIndex[horses.LTC].total);
1454             }
1455         } else if(horses.ETH_delta > horses.BTC_delta) {
1456             if (horses.ETH_delta > horses.LTC_delta) {
1457                 winner_horse[horses.ETH] = true;
1458                 winnerPoolTotal = coinIndex[horses.ETH].total;
1459             }
1460             else if (horses.LTC_delta > horses.ETH_delta) {
1461                 winner_horse[horses.LTC] = true;
1462                 winnerPoolTotal = coinIndex[horses.LTC].total;
1463             } else {
1464                 winner_horse[horses.ETH] = true;
1465                 winner_horse[horses.LTC] = true;
1466                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.LTC].total);
1467             }
1468         } else {
1469             if (horses.LTC_delta > horses.ETH_delta) {
1470                 winner_horse[horses.LTC] = true;
1471                 winnerPoolTotal = coinIndex[horses.LTC].total;
1472             } else if(horses.LTC_delta < horses.ETH_delta){
1473                 winner_horse[horses.ETH] = true;
1474                 winner_horse[horses.BTC] = true;
1475                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total);
1476             } else {
1477                 winner_horse[horses.LTC] = true;
1478                 winner_horse[horses.ETH] = true;
1479                 winner_horse[horses.BTC] = true;
1480                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total) + (coinIndex[horses.LTC].total);
1481             }
1482         }
1483         chronus.race_end = true;
1484     }
1485 
1486     // method to calculate an invidual's reward
1487     function calculateReward(address candidate) internal afterRace constant returns(uint winner_reward) {
1488         voter_info storage bettor = voterIndex[candidate];
1489         if(chronus.voided_bet) {
1490             winner_reward = bettor.total_bet;
1491         } else {
1492             uint winning_bet_total;
1493             if(winner_horse[horses.BTC]) {
1494                 winning_bet_total += bettor.bets[horses.BTC];
1495             } if(winner_horse[horses.ETH]) {
1496                 winning_bet_total += bettor.bets[horses.ETH];
1497             } if(winner_horse[horses.LTC]) {
1498                 winning_bet_total += bettor.bets[horses.LTC];
1499             }
1500             winner_reward += (((total_reward.mul(10000000)).div(winnerPoolTotal)).mul(winning_bet_total)).div(10000000);
1501         }
1502     }
1503 
1504     // method to just check the reward amount
1505     function checkReward() afterRace external constant returns (uint) {
1506         require(!voterIndex[msg.sender].rewarded);
1507         return calculateReward(msg.sender);
1508     }
1509 
1510     // method to claim the reward amount
1511     function claim_reward() afterRace external {
1512         require(!voterIndex[msg.sender].rewarded);
1513         uint transfer_amount = calculateReward(msg.sender);
1514         require(address(this).balance >= transfer_amount);
1515         voterIndex[msg.sender].rewarded = true;
1516         msg.sender.transfer(transfer_amount);
1517         emit Withdraw(msg.sender, transfer_amount);
1518     }
1519 
1520     function forceVoidRace() internal {
1521         chronus.voided_bet=true;
1522         chronus.race_end = true;
1523         chronus.voided_timestamp=uint32(now);
1524     }
1525 
1526     // exposing the coin pool details for DApp
1527     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {
1528         uint256 coinPrePrice;
1529         uint256 coinPostPrice;
1530         if (coinIndex[horses.ETH].pre > 0 && coinIndex[horses.BTC].pre > 0 && coinIndex[horses.LTC].pre > 0) {
1531             coinPrePrice = coinIndex[index].pre;
1532         } 
1533         if (coinIndex[horses.ETH].post > 0 && coinIndex[horses.BTC].post > 0 && coinIndex[horses.LTC].post > 0) {
1534             coinPostPrice = coinIndex[index].post;
1535         }
1536         return (coinIndex[index].total, coinPrePrice, coinPostPrice, coinIndex[index].price_check, voterIndex[candidate].bets[index]);
1537     }
1538 
1539     // exposing the total reward amount for DApp
1540     function reward_total() external constant returns (uint) {
1541         return ((coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total));
1542     }
1543 
1544     // in case of any errors in race, enable full refund for the Bettors to claim
1545     function refund() external onlyOwner {
1546         require(now > chronus.starting_time + chronus.race_duration);
1547         require((chronus.betting_open && !chronus.race_start)
1548             || (chronus.race_start && !chronus.race_end));
1549         chronus.voided_bet = true;
1550         chronus.race_end = true;
1551         chronus.voided_timestamp=uint32(now);
1552     }
1553 
1554     // method to claim unclaimed winnings after 30 day notice period
1555     function recovery() external onlyOwner{
1556         require((chronus.race_end && now > chronus.starting_time + chronus.race_duration + (30 days))
1557             || (chronus.voided_bet && now > chronus.voided_timestamp + (30 days)));
1558         house_takeout.transfer(address(this).balance);
1559     }
1560 }
1561 
1562 
1563 contract oraclizeController is usingOraclize {
1564     address owner;
1565     
1566     event newOraclizeQuery();
1567     event RemoteBettingCloseInfo(address _race);
1568     
1569     struct horsesInfo {
1570         bytes32 BTC;
1571         bytes32 ETH;
1572         bytes32 LTC;
1573         uint256 customPreGasLimit;
1574         uint256 customPostGasLimit;
1575     }
1576     
1577     struct coinInfo {
1578         uint256 pre;
1579         uint256 post;
1580         bytes32 preOraclizeId;
1581         bytes32 postOraclizeId;
1582     }
1583     
1584     mapping (address => mapping (bytes32 => coinInfo)) public coinIndex; 
1585     mapping (address => mapping (bytes32 => bytes32)) oraclizeIndex; // mapping oraclize IDs with coins
1586     mapping (bytes32 => address) oraclizeInverseIndex; // mapping oraclize IDs with coins
1587     
1588     horsesInfo horses;
1589     constructor() public {
1590         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1591         // oraclize_setCustomGasPrice(10000000000 wei);
1592         oraclize_setCustomGasPrice(30000000000 wei);
1593         horses.BTC = bytes32("BTC");
1594         horses.ETH = bytes32("ETH");
1595         horses.LTC = bytes32("LTC");
1596         owner = msg.sender;
1597         horses.customPreGasLimit = 100000;
1598         horses.customPostGasLimit = 200000;
1599     }
1600     
1601     modifier onlyOwner {
1602         require(owner == msg.sender);
1603         _;
1604     }
1605     
1606     // safemath addition
1607     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1608         uint256 c = a + b;
1609         assert(c >= a);
1610         return c;
1611     }
1612     
1613     // utility function to convert string to integer with precision consideration
1614     function stringToUintNormalize(string s) internal pure returns (uint result) {
1615         uint p =2;
1616         bool precision=false;
1617         bytes memory b = bytes(s);
1618         uint i;
1619         result = 0;
1620         for (i = 0; i < b.length; i++) {
1621             if (precision) {p = p-1;}
1622             if (uint(b[i]) == 46){precision = true;}
1623             uint c = uint(b[i]);
1624             if (c >= 48 && c <= 57) {result = result * 10 + (c - 48);}
1625             if (precision && p == 0){return result;}
1626         }
1627         while (p!=0) {
1628             result = result*10;
1629             p=p-1;
1630         }
1631     }
1632     
1633     function changeOraclizeGasPrice(uint _newGasPrice) external onlyOwner {
1634         oraclize_setCustomGasPrice(_newGasPrice);
1635     }
1636     
1637     // method to place the oraclize queries
1638     function setupRace(uint delay, uint locking_duration, address raceAddress) public payable onlyOwner {
1639         if (oraclize_getPrice("URL" , horses.customPreGasLimit)*3 + oraclize_getPrice("URL", horses.customPostGasLimit)*3  > address(this).balance) {
1640         } else {
1641             bytes32 temp_ID; // temp variable to store oraclize IDs
1642             emit newOraclizeQuery();
1643             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1027/).data.quotes.USD.price",horses.customPreGasLimit);
1644             oraclizeIndex[raceAddress][temp_ID] = horses.ETH;
1645             oraclizeInverseIndex[temp_ID] = raceAddress;
1646             coinIndex[raceAddress][horses.ETH].preOraclizeId = temp_ID;
1647 
1648             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/2/).data.quotes.USD.price",horses.customPreGasLimit);
1649             oraclizeIndex[raceAddress][temp_ID] = horses.LTC;
1650             oraclizeInverseIndex[temp_ID] = raceAddress;
1651             coinIndex[raceAddress][horses.LTC].preOraclizeId = temp_ID;
1652 
1653             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1/).data.quotes.USD.price",horses.customPreGasLimit);
1654             oraclizeIndex[raceAddress][temp_ID] = horses.BTC;
1655             oraclizeInverseIndex[temp_ID] = raceAddress;
1656             coinIndex[raceAddress][horses.BTC].preOraclizeId = temp_ID;
1657 
1658             //bets closing price query
1659             delay = add(delay,locking_duration);
1660 
1661             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1027/).data.quotes.USD.price",horses.customPostGasLimit);
1662             oraclizeIndex[raceAddress][temp_ID] = horses.ETH;
1663             oraclizeInverseIndex[temp_ID] = raceAddress;
1664             coinIndex[raceAddress][horses.ETH].postOraclizeId = temp_ID;
1665 
1666             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/2/).data.quotes.USD.price",horses.customPostGasLimit);
1667             oraclizeIndex[raceAddress][temp_ID] = horses.LTC;
1668             oraclizeInverseIndex[temp_ID] = raceAddress;
1669             coinIndex[raceAddress][horses.LTC].postOraclizeId = temp_ID;
1670 
1671             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1/).data.quotes.USD.price",horses.customPostGasLimit);
1672             oraclizeIndex[raceAddress][temp_ID] = horses.BTC;
1673             oraclizeInverseIndex[temp_ID] = raceAddress;
1674             coinIndex[raceAddress][horses.BTC].postOraclizeId = temp_ID;
1675         }
1676     }
1677     
1678     //oraclize callback method
1679     function __callback(bytes32 myid, string result, bytes proof) public {
1680         require (msg.sender == oraclize_cbAddress());
1681         require (stringToUintNormalize(result) > 0);
1682         bytes32 coin_pointer; // variable to differentiate different callbacks
1683         address raceAddress = oraclizeInverseIndex[myid];
1684         Race race = Race(raceAddress);
1685         coin_pointer = oraclizeIndex[raceAddress][myid];
1686         emit RemoteBettingCloseInfo(raceAddress);
1687         
1688         if (myid == coinIndex[raceAddress][coin_pointer].preOraclizeId) {
1689             if (coinIndex[raceAddress][coin_pointer].pre > 0) {
1690             } else {
1691                 coinIndex[raceAddress][coin_pointer].pre = stringToUintNormalize(result);
1692                 race.priceCallback(coin_pointer,coinIndex[raceAddress][coin_pointer].pre,true);
1693             }
1694         } else if (myid == coinIndex[raceAddress][coin_pointer].postOraclizeId){
1695             if (coinIndex[raceAddress][coin_pointer].post > 0) {
1696             } else {
1697                 coinIndex[raceAddress][coin_pointer].post = stringToUintNormalize(result);
1698                 race.priceCallback(coin_pointer,coinIndex[raceAddress][coin_pointer].post,false);
1699             }
1700         }
1701     }
1702     
1703     function ethorseOracle(address raceAddress, bytes32 coin_pointer, string result, bool isPrePrice) external onlyOwner {
1704         emit RemoteBettingCloseInfo(raceAddress);
1705         Race race = Race(raceAddress);
1706         if (isPrePrice) {
1707             coinIndex[raceAddress][coin_pointer].pre = stringToUintNormalize(result);
1708         } else {
1709             coinIndex[raceAddress][coin_pointer].post = stringToUintNormalize(result);
1710         }
1711         race.priceCallback(coin_pointer, stringToUintNormalize(result), isPrePrice);
1712     }
1713 }
1714 
1715 contract BettingController is oraclizeController {
1716     address owner;
1717     Race race;
1718 
1719     mapping (address => bool) public isOraclizeEnabled;
1720     event RaceDeployed(address _address, address _owner, uint256 _bettingDuration, uint256 _raceDuration, uint256 _time);
1721     event AddFund(uint256 _value);
1722 
1723     modifier onlyOwner {
1724         require(msg.sender == owner);
1725         _;
1726     }
1727 
1728     constructor() public payable {
1729         owner = msg.sender;
1730     }
1731 
1732     function addFunds() external onlyOwner payable {
1733         emit AddFund(msg.value);
1734     }
1735 
1736     function spawnRaceManual(uint256 _bettingDuration, uint256 _raceDuration, bool _isOraclizeUsed) external onlyOwner {
1737         race = (new Race)();
1738         emit RaceDeployed(address(race), race.owner(), _bettingDuration, _raceDuration, now);
1739         if (_isOraclizeUsed) {
1740             isOraclizeEnabled[address(race)] = true;
1741             setupRace(_bettingDuration, _raceDuration, address(race));
1742         }
1743         uint32 bettingDuration = uint32(_bettingDuration);
1744         uint32 raceDuration = uint32(_raceDuration);
1745         raceDuration = uint32(add(bettingDuration,raceDuration));
1746         bettingDuration = uint32(bettingDuration);
1747         race.setupRace(bettingDuration,raceDuration);
1748     }
1749 
1750     function enableRefund(address _race) external onlyOwner {
1751         Race raceInstance = Race(_race);
1752         emit RemoteBettingCloseInfo(_race);
1753         raceInstance.refund();
1754     }
1755 
1756     function manualRecovery(address _race) external onlyOwner {
1757         Race raceInstance = Race(_race);
1758         raceInstance.recovery();
1759     }
1760 
1761     function changeRaceOwnership(address _race, address _newOwner) external onlyOwner {
1762         Race raceInstance = Race(_race);
1763         raceInstance.changeOwnership(_newOwner);
1764     }
1765 
1766     function extractFund(uint256 _amount) external onlyOwner {
1767         if (_amount == 0) {
1768             owner.transfer(address(this).balance);
1769         } else {
1770             require(_amount <= address(this).balance);
1771             owner.transfer(_amount);
1772         }
1773     }
1774 }