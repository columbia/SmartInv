1 pragma solidity ^0.4.24;
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
1234 
1235 
1236 
1237 
1238 /**
1239  * @title ERC20 interface
1240  * @dev see https://github.com/ethereum/EIPs/issues/20
1241  */
1242 interface IERC20 {
1243   function totalSupply() external view returns (uint256);
1244 
1245   function balanceOf(address who) external view returns (uint256);
1246 
1247   function allowance(address owner, address spender)
1248     external view returns (uint256);
1249 
1250   function transfer(address to, uint256 value) external returns (bool);
1251 
1252   function approve(address spender, uint256 value)
1253     external returns (bool);
1254 
1255   function transferFrom(address from, address to, uint256 value)
1256     external returns (bool);
1257 
1258   event Transfer(
1259     address indexed from,
1260     address indexed to,
1261     uint256 value
1262   );
1263 
1264   event Approval(
1265     address indexed owner,
1266     address indexed spender,
1267     uint256 value
1268   );
1269 }
1270 
1271 
1272 /**
1273  * @title SafeMath
1274  * @dev Math operations with safety checks that revert on error
1275  */
1276 library SafeMath {
1277 
1278   /**
1279   * @dev Multiplies two numbers, reverts on overflow.
1280   */
1281   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1282     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1283     // benefit is lost if 'b' is also tested.
1284     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1285     if (a == 0) {
1286       return 0;
1287     }
1288 
1289     uint256 c = a * b;
1290     require(c / a == b);
1291 
1292     return c;
1293   }
1294 
1295   /**
1296   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1297   */
1298   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1299     require(b > 0); // Solidity only automatically asserts when dividing by 0
1300     uint256 c = a / b;
1301     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1302 
1303     return c;
1304   }
1305 
1306   /**
1307   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1308   */
1309   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1310     require(b <= a);
1311     uint256 c = a - b;
1312 
1313     return c;
1314   }
1315 
1316   /**
1317   * @dev Adds two numbers, reverts on overflow.
1318   */
1319   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1320     uint256 c = a + b;
1321     require(c >= a);
1322 
1323     return c;
1324   }
1325 
1326   /**
1327   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1328   * reverts when dividing by zero.
1329   */
1330   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1331     require(b != 0);
1332     return a % b;
1333   }
1334 }
1335 
1336 /**
1337  * @title Standard ERC20 token
1338  *
1339  * @dev Implementation of the basic standard token.
1340  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
1341  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1342  */
1343 contract ERC20 is IERC20 {
1344   using SafeMath for uint256;
1345 
1346   mapping (address => uint256) private _balances;
1347 
1348   mapping (address => mapping (address => uint256)) private _allowed;
1349 
1350   uint256 private _totalSupply;
1351 
1352   /**
1353   * @dev Total number of tokens in existence
1354   */
1355   function totalSupply() public view returns (uint256) {
1356     return _totalSupply;
1357   }
1358 
1359   /**
1360   * @dev Gets the balance of the specified address.
1361   * @param owner The address to query the balance of.
1362   * @return An uint256 representing the amount owned by the passed address.
1363   */
1364   function balanceOf(address owner) public view returns (uint256) {
1365     return _balances[owner];
1366   }
1367 
1368   /**
1369    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1370    * @param owner address The address which owns the funds.
1371    * @param spender address The address which will spend the funds.
1372    * @return A uint256 specifying the amount of tokens still available for the spender.
1373    */
1374   function allowance(
1375     address owner,
1376     address spender
1377    )
1378     public
1379     view
1380     returns (uint256)
1381   {
1382     return _allowed[owner][spender];
1383   }
1384 
1385   /**
1386   * @dev Transfer token for a specified address
1387   * @param to The address to transfer to.
1388   * @param value The amount to be transferred.
1389   */
1390   function transfer(address to, uint256 value) public returns (bool) {
1391     _transfer(msg.sender, to, value);
1392     return true;
1393   }
1394 
1395   /**
1396    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1397    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1398    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1399    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1400    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1401    * @param spender The address which will spend the funds.
1402    * @param value The amount of tokens to be spent.
1403    */
1404   function approve(address spender, uint256 value) public returns (bool) {
1405     require(spender != address(0));
1406 
1407     _allowed[msg.sender][spender] = value;
1408     emit Approval(msg.sender, spender, value);
1409     return true;
1410   }
1411 
1412   /**
1413    * @dev Transfer tokens from one address to another
1414    * @param from address The address which you want to send tokens from
1415    * @param to address The address which you want to transfer to
1416    * @param value uint256 the amount of tokens to be transferred
1417    */
1418   function transferFrom(
1419     address from,
1420     address to,
1421     uint256 value
1422   )
1423     public
1424     returns (bool)
1425   {
1426     require(value <= _allowed[from][msg.sender]);
1427 
1428     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
1429     _transfer(from, to, value);
1430     return true;
1431   }
1432 
1433   /**
1434    * @dev Increase the amount of tokens that an owner allowed to a spender.
1435    * approve should be called when allowed_[_spender] == 0. To increment
1436    * allowed value is better to use this function to avoid 2 calls (and wait until
1437    * the first transaction is mined)
1438    * From MonolithDAO Token.sol
1439    * @param spender The address which will spend the funds.
1440    * @param addedValue The amount of tokens to increase the allowance by.
1441    */
1442   function increaseAllowance(
1443     address spender,
1444     uint256 addedValue
1445   )
1446     public
1447     returns (bool)
1448   {
1449     require(spender != address(0));
1450 
1451     _allowed[msg.sender][spender] = (
1452       _allowed[msg.sender][spender].add(addedValue));
1453     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1454     return true;
1455   }
1456 
1457   /**
1458    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1459    * approve should be called when allowed_[_spender] == 0. To decrement
1460    * allowed value is better to use this function to avoid 2 calls (and wait until
1461    * the first transaction is mined)
1462    * From MonolithDAO Token.sol
1463    * @param spender The address which will spend the funds.
1464    * @param subtractedValue The amount of tokens to decrease the allowance by.
1465    */
1466   function decreaseAllowance(
1467     address spender,
1468     uint256 subtractedValue
1469   )
1470     public
1471     returns (bool)
1472   {
1473     require(spender != address(0));
1474 
1475     _allowed[msg.sender][spender] = (
1476       _allowed[msg.sender][spender].sub(subtractedValue));
1477     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1478     return true;
1479   }
1480 
1481   /**
1482   * @dev Transfer token for a specified addresses
1483   * @param from The address to transfer from.
1484   * @param to The address to transfer to.
1485   * @param value The amount to be transferred.
1486   */
1487   function _transfer(address from, address to, uint256 value) internal {
1488     require(value <= _balances[from]);
1489     require(to != address(0));
1490 
1491     _balances[from] = _balances[from].sub(value);
1492     _balances[to] = _balances[to].add(value);
1493     emit Transfer(from, to, value);
1494   }
1495 
1496   /**
1497    * @dev Internal function that mints an amount of the token and assigns it to
1498    * an account. This encapsulates the modification of balances such that the
1499    * proper events are emitted.
1500    * @param account The account that will receive the created tokens.
1501    * @param value The amount that will be created.
1502    */
1503   function _mint(address account, uint256 value) internal {
1504     require(account != 0);
1505     _totalSupply = _totalSupply.add(value);
1506     _balances[account] = _balances[account].add(value);
1507     emit Transfer(address(0), account, value);
1508   }
1509 
1510   /**
1511    * @dev Internal function that burns an amount of the token of a given
1512    * account.
1513    * @param account The account whose tokens will be burnt.
1514    * @param value The amount that will be burnt.
1515    */
1516   function _burn(address account, uint256 value) internal {
1517     require(account != 0);
1518     require(value <= _balances[account]);
1519 
1520     _totalSupply = _totalSupply.sub(value);
1521     _balances[account] = _balances[account].sub(value);
1522     emit Transfer(account, address(0), value);
1523   }
1524 
1525   /**
1526    * @dev Internal function that burns an amount of the token of a given
1527    * account, deducting from the sender's allowance for said account. Uses the
1528    * internal burn function.
1529    * @param account The account whose tokens will be burnt.
1530    * @param value The amount that will be burnt.
1531    */
1532   function _burnFrom(address account, uint256 value) internal {
1533     require(value <= _allowed[account][msg.sender]);
1534 
1535     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
1536     // this function needs to emit an event with the updated approval.
1537     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
1538       value);
1539     _burn(account, value);
1540   }
1541 }
1542 
1543 /**
1544  * @title Roles
1545  * @dev Library for managing addresses assigned to a Role.
1546  */
1547 library Roles {
1548   struct Role {
1549     mapping (address => bool) bearer;
1550   }
1551 
1552   /**
1553    * @dev give an account access to this role
1554    */
1555   function add(Role storage role, address account) internal {
1556     require(account != address(0));
1557     role.bearer[account] = true;
1558   }
1559 
1560   /**
1561    * @dev remove an account's access to this role
1562    */
1563   function remove(Role storage role, address account) internal {
1564     require(account != address(0));
1565     role.bearer[account] = false;
1566   }
1567 
1568   /**
1569    * @dev check if an account has this role
1570    * @return bool
1571    */
1572   function has(Role storage role, address account)
1573     internal
1574     view
1575     returns (bool)
1576   {
1577     require(account != address(0));
1578     return role.bearer[account];
1579   }
1580 }
1581 
1582 contract MinterRole {
1583   using Roles for Roles.Role;
1584 
1585   event MinterAdded(address indexed account);
1586   event MinterRemoved(address indexed account);
1587 
1588   Roles.Role private minters;
1589 
1590   constructor() public {
1591     _addMinter(msg.sender);
1592   }
1593 
1594   modifier onlyMinter() {
1595     require(isMinter(msg.sender));
1596     _;
1597   }
1598 
1599   function isMinter(address account) public view returns (bool) {
1600     return minters.has(account);
1601   }
1602 
1603   function addMinter(address account) public onlyMinter {
1604     _addMinter(account);
1605   }
1606 
1607   function renounceMinter() public {
1608     _removeMinter(msg.sender);
1609   }
1610 
1611   function _addMinter(address account) internal {
1612     minters.add(account);
1613     emit MinterAdded(account);
1614   }
1615 
1616   function _removeMinter(address account) internal {
1617     minters.remove(account);
1618     emit MinterRemoved(account);
1619   }
1620 }
1621 
1622 
1623 /**
1624  * @title ERC20Mintable
1625  * @dev ERC20 minting logic
1626  */
1627 contract ERC20Mintable is ERC20, MinterRole {
1628   /**
1629    * @dev Function to mint tokens
1630    * @param to The address that will receive the minted tokens.
1631    * @param value The amount of tokens to mint.
1632    * @return A boolean that indicates if the operation was successful.
1633    */
1634   function mint(
1635     address to,
1636     uint256 value
1637   )
1638     public
1639     onlyMinter
1640     returns (bool)
1641   {
1642     _mint(to, value);
1643     return true;
1644   }
1645 }
1646 
1647 
1648 /**
1649  * @title Ownable
1650  * @dev The Ownable contract has an owner address, and provides basic authorization control
1651  * functions, this simplifies the implementation of "user permissions".
1652  */
1653 contract Ownable {
1654   address private _owner;
1655 
1656   event OwnershipRenounced(address indexed previousOwner);
1657   event OwnershipTransferred(
1658     address indexed previousOwner,
1659     address indexed newOwner
1660   );
1661 
1662   /**
1663    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1664    * account.
1665    */
1666   constructor() public {
1667     _owner = msg.sender;
1668   }
1669 
1670   /**
1671    * @return the address of the owner.
1672    */
1673   function owner() public view returns(address) {
1674     return _owner;
1675   }
1676 
1677   /**
1678    * @dev Throws if called by any account other than the owner.
1679    */
1680   modifier onlyOwner() {
1681     require(isOwner());
1682     _;
1683   }
1684 
1685   /**
1686    * @return true if `msg.sender` is the owner of the contract.
1687    */
1688   function isOwner() public view returns(bool) {
1689     return msg.sender == _owner;
1690   }
1691 
1692   /**
1693    * @dev Allows the current owner to relinquish control of the contract.
1694    * @notice Renouncing to ownership will leave the contract without an owner.
1695    * It will not be possible to call the functions with the `onlyOwner`
1696    * modifier anymore.
1697    */
1698   function renounceOwnership() public onlyOwner {
1699     emit OwnershipRenounced(_owner);
1700     _owner = address(0);
1701   }
1702 
1703   /**
1704    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1705    * @param newOwner The address to transfer ownership to.
1706    */
1707   function transferOwnership(address newOwner) public onlyOwner {
1708     _transferOwnership(newOwner);
1709   }
1710 
1711   /**
1712    * @dev Transfers control of the contract to a newOwner.
1713    * @param newOwner The address to transfer ownership to.
1714    */
1715   function _transferOwnership(address newOwner) internal {
1716     require(newOwner != address(0));
1717     emit OwnershipTransferred(_owner, newOwner);
1718     _owner = newOwner;
1719   }
1720 }
1721 
1722 contract MITToken is ERC20Mintable, Ownable {
1723   string public name = "MIT Token";        
1724   string public symbol = "MIT";
1725   uint256 public decimals = 0;
1726   
1727   event MintFinished();
1728 
1729   bool public mintingFinished = false;
1730   
1731   /**
1732    * @dev Function to stop minting new tokens.
1733    * @return True if the operation was successful.
1734    */
1735   function finishMinting() public onlyOwner returns (bool) {
1736     mintingFinished = true;
1737     emit MintFinished();
1738     return true;
1739   }
1740 }
1741 
1742 contract Crowdsale is Ownable, usingOraclize {
1743   using SafeMath for uint256;
1744 
1745   // The token being sold
1746   MITToken public token;
1747 
1748   // address where funds are collected
1749   address public wallet = 0x009853E2660158638CE92e89f06DedaFF6627066;
1750   address public TokensWallet = 0xA40E21E432C68C0c8975C7e470Ec8202b3293Df2;
1751   
1752   //owner tokens percent
1753   uint256 OwnerTokensPercent = 15;
1754 
1755   // how many token units a buyer gets per wei
1756   uint256 public price = 4347826086956521; // 1$ ;
1757 
1758   // amount of raised money in wei
1759   uint256 public weiRaised = 0;
1760   
1761     uint256 public startPreICO = 1537819200; //25 Sep 2018 00:00:00 GMT 
1762     uint256 public FinishPreICO = 1543089600; //25 nov 2018 00:00:00 GMT
1763     uint256 public startICO = 1543089600; //25 nov 2018 00:00:00 GMT
1764     uint256 public FinishICO = 1545681600; //25 dec 2019 00:00:00 GMT
1765     
1766     uint256 public tokenDec = 1000000000000000000; //18
1767     
1768     uint256 public ICOHardcap = 20000000;
1769     uint256 public tokensSold = 0;
1770 
1771   constructor() public {
1772     token = createTokenContract();
1773   }
1774 
1775   // creates the token to be sold.
1776   // override this method to have crowdsale of a specific mintable token.
1777   function createTokenContract() internal returns (MITToken) {
1778     return new MITToken();
1779   }
1780 
1781   // fallback function can be used to buy tokens
1782   function () public payable {
1783     buyTokens(msg.sender);
1784   }
1785 
1786   // low level token purchase function
1787   function buyTokens(address beneficiary) public payable {
1788     require(beneficiary != 0x0);
1789     require(validPurchase());
1790     require(!hasEnded());
1791     
1792     updatePrice();
1793 
1794     uint256 weiAmount = msg.value;
1795     uint256 updatedWeiRaised = weiRaised.add(weiAmount);
1796     
1797     uint256 tokens = 0;
1798     
1799     // calculate token amount to be created
1800     if(now >= startPreICO && now < FinishPreICO){
1801         tokens = weiAmount.mul(tokenDec).div(price).div(tokenDec);
1802     }
1803     
1804     if(now >= startICO && now < FinishICO){
1805         tokens = weiAmount.mul(tokenDec).div(price.mul(2)).div(tokenDec);
1806     }
1807     
1808     uint256 updatedTokensSold = tokensSold.add(tokens);
1809     
1810     if(updatedTokensSold > ICOHardcap){
1811         tokens = ICOHardcap.sub(tokensSold);
1812         updatedTokensSold = ICOHardcap;
1813     }
1814     
1815     // update amount tokens
1816     tokensSold = updatedTokensSold;
1817         
1818     token.mint(beneficiary, tokens);
1819     
1820     // update state
1821     weiRaised = updatedWeiRaised;
1822     
1823     forwardFunds();
1824   }
1825   
1826     function __callback (bytes32 myid, string result) public {
1827         if (msg.sender != oraclize_cbAddress()) revert();
1828         price = tokenDec.div(parseInt(result));
1829         updatePrice();
1830     }
1831     
1832     function updatePrice() public payable {
1833         if (oraclize_getPrice("URL") < this.balance) {
1834             oraclize_query(86400, "URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price");
1835         }
1836     }
1837 
1838   // send ether to the fund collection wallet
1839   // override to create custom fund forwarding mechanisms
1840   function forwardFunds() internal {
1841     uint contractBalance = this.balance;
1842     if(contractBalance > tokenDec.div(10)){
1843         uint sendingValue = contractBalance.sub(tokenDec.div(10));
1844         wallet.transfer(sendingValue);
1845     }
1846   }
1847   
1848   // @return true if the transaction can buy tokens
1849   function validPurchase() internal constant returns (bool) {
1850     bool withinPeriod = (now >= startPreICO && now < FinishPreICO) || (now >= startICO && now < FinishICO);
1851     bool canSoldTokens = ICOHardcap > tokensSold;
1852     bool nonZeroPurchase = false;
1853     if(now >= startPreICO && now < FinishPreICO){
1854         nonZeroPurchase = msg.value >= price;
1855     }
1856     if(now >= startICO && now < FinishICO){
1857         nonZeroPurchase = msg.value >= price.mul(2);
1858     }
1859     
1860     return withinPeriod && nonZeroPurchase && canSoldTokens;
1861   }
1862   
1863   // @return true if crowdsale event has ended
1864   function hasEnded() public constant returns (bool) {
1865     return ((now > FinishICO) || (tokensSold >= ICOHardcap));
1866   }
1867   
1868   function setHardcap(uint newHardcap) public onlyOwner {
1869     ICOHardcap = newHardcap;
1870   }
1871   
1872   function setWallet(address newWallet) public onlyOwner {
1873     wallet = newWallet;
1874   }
1875   
1876   function setTokensWallet(address newTokensWallet) public onlyOwner { 
1877     TokensWallet = newTokensWallet;
1878   }
1879   
1880   function setStartPreICO(uint newStartPreICO) public onlyOwner {
1881     startPreICO = newStartPreICO;
1882   }
1883   
1884   function setFinishPreICO(uint newFinishPreICO) public onlyOwner {
1885     FinishPreICO = newFinishPreICO;
1886   }
1887   
1888   function setStartICO(uint newStartICO) public onlyOwner {
1889     startICO = newStartICO;
1890   }
1891   
1892   function setFinishICO(uint newFinishICO) public onlyOwner {
1893     FinishICO = newFinishICO;
1894   }
1895   
1896   function tokenOperationsFinished() public onlyOwner {
1897     require(hasEnded());
1898     token.finishMinting();
1899     uint OwnerTokens = tokensSold.mul(OwnerTokensPercent).div(100);
1900     token.mint(TokensWallet, OwnerTokens);
1901   }
1902 }