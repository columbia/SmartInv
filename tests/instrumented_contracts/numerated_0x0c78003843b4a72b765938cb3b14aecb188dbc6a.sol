1 pragma solidity 0.4.25;
2 
3  // <ORACLIZE_API>
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
1234 /**
1235  * @title SafeMath
1236  * @dev Math operations with safety checks that throw on error
1237  */
1238 library SafeMath {
1239 
1240     /**
1241     * @dev Multiplies two numbers, throws on overflow.
1242     */
1243     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1244         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1245         // benefit is lost if 'b' is also tested.
1246         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1247         if (a == 0) {
1248             return 0;
1249         }
1250 
1251         c = a * b;
1252         assert(c / a == b);
1253         return c;
1254     }
1255 
1256     /**
1257     * @dev Integer division of two numbers, truncating the quotient.
1258     */
1259     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1260         // assert(b > 0); // Solidity automatically throws when dividing by 0
1261         // uint256 c = a / b;
1262         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1263         return a / b;
1264     }
1265 
1266     /**
1267     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1268     */
1269     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1270         assert(b <= a);
1271         return a - b;
1272     }
1273 
1274     /**
1275     * @dev Adds two numbers, throws on overflow.
1276     */
1277     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1278         c = a + b;
1279         assert(c >= a);
1280         return c;
1281     }
1282 }
1283 
1284 contract Ownable {
1285     mapping(address => bool) owners;
1286 
1287     event OwnerAdded(address indexed newOwner);
1288     event OwnerDeleted(address indexed owner);
1289 
1290     /**
1291      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1292      * account.
1293      */
1294     constructor() public {
1295         owners[msg.sender] = true;
1296     }
1297 
1298     /**
1299      * @dev Throws if called by any account other than the owner.
1300      */
1301     modifier onlyOwner() {
1302         require(isOwner(msg.sender));
1303         _;
1304     }
1305 
1306     function addOwner(address _newOwner) external onlyOwner {
1307         require(_newOwner != address(0));
1308         owners[_newOwner] = true;
1309         emit OwnerAdded(_newOwner);
1310     }
1311 
1312     function delOwner(address _owner) external onlyOwner {
1313         require(owners[_owner]);
1314         owners[_owner] = false;
1315         emit OwnerDeleted(_owner);
1316     }
1317 
1318     function isOwner(address _owner) public view returns (bool) {
1319         return owners[_owner];
1320     }
1321 
1322 }
1323 
1324 
1325 contract ERC20 {
1326     function allowance(address owner, address spender) public view returns (uint256);
1327     function transferFrom(address from, address to, uint256 value) public returns (bool);
1328     function totalSupply() public view returns (uint256);
1329     function balanceOf(address who) public view returns (uint256);
1330     function transfer(address to, uint256 value) public returns (bool);
1331     function ownerTransfer(address to, uint256 value) public returns (bool);
1332     event Transfer(address indexed from, address indexed to, uint256 value);
1333 
1334     function approve(address spender, uint256 value) public returns (bool);
1335     event Approval(address indexed owner, address indexed spender, uint256 value);
1336 
1337     function unpause() public returns (bool);
1338 }
1339 
1340 
1341 library SafeERC20 {
1342     function safeTransfer(ERC20 token, address to, uint256 value) internal {
1343         require(token.transfer(to, value));
1344     }
1345 
1346     function safeOwnerTransfer(ERC20 token, address to, uint256 value) internal {
1347         require(token.ownerTransfer(to, value));
1348     }
1349 
1350     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
1351         require(token.transferFrom(from, to, value));
1352     }
1353 
1354     function safeApprove(ERC20 token, address spender, uint256 value) internal {
1355         require(token.approve(spender, value));
1356     }
1357 }
1358 
1359 
1360 
1361 /**
1362  * @title Crowdsale
1363  * @dev Crowdsale is a base contract for managing a token crowdsale,
1364  * allowing investors to purchase tokens with ether. This contract implements
1365  * such functionality in its most fundamental form and can be extended to provide additional
1366  * functionality and/or custom behavior.
1367  * The external interface represents the basic interface for purchasing tokens, and conform
1368  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
1369  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
1370  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
1371  * behavior.
1372  */
1373 contract Crowdsale is Ownable, usingOraclize{
1374     using SafeMath for uint256;
1375     using SafeERC20 for ERC20;
1376 
1377     // The token being sold
1378     ERC20 public token;
1379     address public wallet;
1380     address public reserveFund;
1381 
1382     uint256 public openingTime;
1383     uint256 public closingTime;
1384 
1385     uint256 public cap;
1386     uint256 public tokensSold;
1387     uint256 public tokenPriceInWei;
1388 
1389     bool public isFinalized = false;
1390 
1391     // Amount of wei raised
1392     uint256 public weiRaised;
1393 
1394     string public oraclize_url = "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0";
1395 
1396 
1397     struct Stage {
1398         uint stopDay;
1399         uint bonus1;
1400         uint bonus2;
1401         uint bonus3;
1402     }
1403 
1404     mapping (uint => Stage) public stages;
1405     uint public stageCount;
1406     uint public currentStage;
1407 
1408     mapping (bytes32 => bool) public pendingQueries;
1409     mapping (address => bool) public KYC;
1410 
1411     uint public oraclizeBalance;
1412 
1413     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 tokens, uint256 bonus);
1414     event Finalized();
1415     event NewOraclizeQuery(string description);
1416     event NewKrakenPriceTicker(string price);
1417 
1418     /**
1419      * @dev Reverts if not in crowdsale time range.
1420      */
1421     modifier onlyWhileOpen {
1422         // solium-disable-next-line security/no-block-members
1423         require(block.timestamp >= openingTime && block.timestamp <= closingTime);
1424         _;
1425     }
1426 
1427 
1428     constructor(address _wallet, ERC20 _token, uint256 _cap, uint256 _openingTime, uint256 _closingTime,
1429         address _reserveFund, uint256 _tokenPriceInWei) public {
1430 
1431         require(_wallet != address(0));
1432         require(_token != address(0));
1433         require(_reserveFund != address(0));
1434         require(_openingTime >= now);
1435         require(_closingTime >= _openingTime);
1436         require(_cap > 0);
1437         require(_tokenPriceInWei > 0);
1438 
1439         wallet = _wallet;
1440         token = _token;
1441         reserveFund = _reserveFund;
1442 
1443         cap = _cap;
1444         openingTime = _openingTime;
1445         closingTime = _closingTime;
1446         tokenPriceInWei = _tokenPriceInWei;
1447 
1448         currentStage = 1;
1449 
1450         addStage(openingTime + 1  days, 2000, 2250, 2500);
1451         addStage(openingTime + 7  days, 1500, 1750, 2000);
1452         addStage(openingTime + 14  days, 500, 750, 1000);
1453         addStage(openingTime + 21  days, 100, 100, 100);
1454         addStage(openingTime + 28  days, 0, 0, 0);
1455 
1456         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1457 
1458     }
1459 
1460     // -----------------------------------------
1461     // Crowdsale external interface
1462     // -----------------------------------------
1463 
1464     /**
1465      * @dev fallback function ***DO NOT OVERRIDE***
1466      */
1467     function () external payable {
1468         buyTokens(msg.sender);
1469     }
1470 
1471 
1472     function __callback(bytes32 myid, string result, bytes proof) public {
1473         if (msg.sender != oraclize_cbAddress()) revert();
1474         require (pendingQueries[myid] == true);
1475         proof;
1476         emit NewKrakenPriceTicker(result);
1477         uint USD = parseInt(result);
1478         tokenPriceInWei = 1 ether / USD;
1479         updatePrice();
1480         delete pendingQueries[myid];
1481     }
1482 
1483 
1484     function setTokenPrice(uint _price) onlyOwner public {
1485         tokenPriceInWei = _price;
1486     }
1487 
1488 
1489     function updatePrice() public payable {
1490         oraclizeBalance = oraclizeBalance.add(msg.value);
1491         uint queryPrice = oraclize_getPrice("URL");
1492         if (queryPrice > address(this).balance) {
1493             emit NewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1494         } else {
1495             emit NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1496 
1497             bytes32 queryId = oraclize_query(14400, "URL", oraclize_url);
1498             pendingQueries[queryId] = true;
1499             oraclizeBalance = oraclizeBalance.sub(queryPrice);
1500         }
1501     }
1502 
1503 
1504     function addStage(uint _stopDay, uint _bonus1, uint _bonus2, uint _bonus3) onlyOwner public {
1505         require(_stopDay > stages[stageCount].stopDay);
1506         stageCount++;
1507         stages[stageCount].stopDay = _stopDay;
1508         stages[stageCount].bonus1 = _bonus1;
1509         stages[stageCount].bonus2 = _bonus2;
1510         stages[stageCount].bonus3 = _bonus3;
1511         if (closingTime < _stopDay) {
1512             closingTime = _stopDay;
1513         }
1514     }
1515 
1516     /**
1517      * @dev low level token purchase ***DO NOT OVERRIDE***
1518      * @param _beneficiary Address performing the token purchase
1519      */
1520     function buyTokens(address _beneficiary) public payable {
1521 
1522         uint256 weiAmount = msg.value;
1523         _preValidatePurchase(_beneficiary, weiAmount);
1524 
1525         uint tokens = 0;
1526         uint bonusTokens = 0;
1527         uint totalTokens = 0;
1528 
1529         (tokens, bonusTokens, totalTokens) = _getTokenAmount(weiAmount);
1530 
1531         _validatePurchase(tokens);
1532 
1533         uint256 price = tokens.div(1 ether).mul(tokenPriceInWei);
1534 
1535         uint256 _diff =  weiAmount.sub(price);
1536 
1537         if (_diff > 0) {
1538             weiAmount = weiAmount.sub(_diff);
1539             msg.sender.transfer(_diff);
1540         }
1541 
1542         _processPurchase(_beneficiary, totalTokens);
1543         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens, bonusTokens);
1544 
1545         _updateState(weiAmount, totalTokens);
1546 
1547         _forwardFunds(weiAmount);
1548     }
1549 
1550 
1551     function manualSale(address _beneficiary, uint256 _tokens) onlyOwner external {
1552         require(_beneficiary != address(0));
1553         require(tokensSold.add(_tokens) <= cap);
1554         uint256 weiAmount = _tokens.mul(tokenPriceInWei);
1555 
1556         _processPurchase(_beneficiary, _tokens);
1557         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, _tokens, 0);
1558         _updateState(weiAmount, _tokens);
1559     }
1560 
1561     // -----------------------------------------
1562     // Internal interface (extensible)
1563     // -----------------------------------------
1564 
1565     /**
1566      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
1567      * @param _beneficiary Address performing the token purchase
1568      * @param _weiAmount Value in wei involved in the purchase
1569      */
1570     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) onlyWhileOpen internal view{
1571         require(_beneficiary != address(0));
1572         //require(KYC[_beneficiary]);
1573         require(_weiAmount != 0);
1574         require(tokensSold < cap);
1575     }
1576 
1577 
1578     function _validatePurchase(uint256 _tokens) internal view {
1579         require(_tokens >= 50 ether && _tokens <= 100000 ether);
1580         require(tokensSold.add(_tokens) <= cap);
1581     }
1582 
1583 
1584     /**
1585      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
1586      * @param _beneficiary Address performing the token purchase
1587      * @param _tokenAmount Number of tokens to be emitted
1588      */
1589     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
1590         token.safeOwnerTransfer(_beneficiary, _tokenAmount);
1591     }
1592 
1593     /**
1594      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
1595      * @param _beneficiary Address receiving the tokens
1596      * @param _tokenAmount Number of tokens to be purchased
1597      */
1598     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
1599         _deliverTokens(_beneficiary, _tokenAmount);
1600     }
1601 
1602 
1603     /**
1604      * @dev Override to extend the way in which ether is converted to tokens.
1605      * @param _weiAmount Value in wei to be converted into tokens
1606      * @return Number of tokens that can be purchased with the specified _weiAmount
1607      */
1608 
1609     function _getTokenAmount(uint256 _weiAmount) internal returns (uint,uint,uint) {
1610         uint tokens = _weiAmount.div(tokenPriceInWei).mul(1 ether);
1611 
1612         if (stages[currentStage].stopDay <= now) {
1613             _updateCurrentStage();
1614         }
1615 
1616         uint bonus = 0;
1617 
1618         if (_weiAmount < 10 ether) {
1619             bonus = stages[currentStage].bonus1;
1620         }
1621 
1622         if (_weiAmount >= 10 ether && _weiAmount < 100 ether) {
1623             bonus = stages[currentStage].bonus2;
1624         }
1625 
1626         if (_weiAmount >= 100 ether) {
1627             bonus = stages[currentStage].bonus3;
1628         }
1629 
1630         bonus = tokens.mul(bonus).div(10000);
1631 
1632         uint total = tokens.add(bonus);
1633 
1634         if (tokensSold.add(total) > cap) {
1635             total = cap.sub(tokensSold);
1636             bonus = total.mul(bonus).div(10000 + bonus);
1637             tokens = total.sub(bonus);
1638         }
1639 
1640         return (tokens, bonus, total);
1641     }
1642 
1643 
1644     function _updateCurrentStage() internal {
1645         for (uint i = currentStage; i <= stageCount; i++) {
1646             if (stages[i].stopDay > now) {
1647                 currentStage = i;
1648                 break;
1649             }
1650         }
1651     }
1652 
1653 
1654     function _updateState(uint256 _weiAmount, uint256 _tokens) internal {
1655         weiRaised = weiRaised.add(_weiAmount);
1656         tokensSold = tokensSold.add(_tokens);
1657     }
1658 
1659     /**
1660      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
1661      */
1662     function _forwardFunds(uint _weiAmount) internal {
1663         wallet.transfer(_weiAmount);
1664     }
1665 
1666     /**
1667      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1668      * @return Whether crowdsale period has elapsed
1669      */
1670     function hasClosed() public view returns (bool) {
1671         // solium-disable-next-line security/no-block-members
1672         return block.timestamp > closingTime;
1673     }
1674 
1675 
1676     /**
1677     * @dev Checks whether the cap has been reached.
1678     * @return Whether the cap was reached
1679     */
1680     function capReached() public view returns (bool) {
1681         return weiRaised >= cap;
1682     }
1683 
1684 
1685     /**
1686      * @dev Must be called after crowdsale ends, to do some extra finalization
1687      * work. Calls the contract's finalization function.
1688      */
1689     function finalize() onlyOwner public {
1690         require(!isFinalized);
1691         require(hasClosed() || capReached());
1692 
1693         finalization();
1694         emit Finalized();
1695 
1696         isFinalized = true;
1697     }
1698 
1699     /**
1700      * @dev Can be overridden to add finalization logic. The overriding function
1701      * should call super.finalization() to ensure the chain of finalization is
1702      * executed entirely.
1703      */
1704     function finalization() internal {
1705         if (token.balanceOf(this) > 0) {
1706             token.safeOwnerTransfer(reserveFund, token.balanceOf(this));
1707         }
1708         require(token.unpause());
1709     }
1710 
1711 
1712     //1% - 100, 10% - 1000 50% - 5000
1713     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
1714         uint _amount = _value.mul(_percent).div(10000);
1715         return (_amount);
1716     }
1717 
1718     function addKYC(address _user) onlyOwner public {
1719         KYC[_user] = true;
1720     }
1721 
1722     function delKYC(address _user) onlyOwner public {
1723         KYC[_user] = false;
1724     }
1725 
1726 
1727     function addBalanceForOraclize() payable external {
1728         oraclizeBalance = oraclizeBalance.add(msg.value);
1729     }
1730 
1731 
1732     function withdrawBalance(address _to) onlyOwner external {
1733         require(_to != address(0));
1734         require(address(this).balance > 0);
1735         oraclizeBalance = 0;
1736         _to.transfer(address(this).balance);
1737     }
1738 
1739 
1740     function setGasPrice(uint _newPrice) onlyOwner public {
1741         oraclize_setCustomGasPrice(_newPrice * 1 wei);
1742     }
1743 
1744 
1745     function setOraclizeUrl(string _url) onlyOwner public {
1746         oraclize_url = _url;
1747     }
1748 
1749 }