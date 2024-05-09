1 pragma solidity ^0.4.24; contract OraclizeI {
2     address public cbAddress;
3     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
4     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
5     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
6     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
7     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
8     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
9     function getPrice(string _datasource) public returns (uint _dsprice);
10     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
11     function setProofType(byte _proofType) external;
12     function setCustomGasPrice(uint _gasPrice) external;
13     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
14 }
15 
16 contract OraclizeAddrResolverI {
17     function getAddress() public returns (address _addr);
18 }
19 
20 /*
21 Begin solidity-cborutils
22 
23 https://github.com/smartcontractkit/solidity-cborutils
24 
25 MIT License
26 
27 Copyright (c) 2018 SmartContract ChainLink, Ltd.
28 
29 Permission is hereby granted, free of charge, to any person obtaining a copy
30 of this software and associated documentation files (the "Software"), to deal
31 in the Software without restriction, including without limitation the rights
32 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
33 copies of the Software, and to permit persons to whom the Software is
34 furnished to do so, subject to the following conditions:
35 
36 The above copyright notice and this permission notice shall be included in all
37 copies or substantial portions of the Software.
38 
39 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
40 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
41 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
42 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
43 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
44 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
45 SOFTWARE.
46  */
47 
48 library Buffer {
49     struct buffer {
50         bytes buf;
51         uint capacity;
52     }
53 
54     function init(buffer memory buf, uint _capacity) internal pure {
55         uint capacity = _capacity;
56         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
57         // Allocate space for the buffer data
58         buf.capacity = capacity;
59         assembly {
60             let ptr := mload(0x40)
61             mstore(buf, ptr)
62             mstore(ptr, 0)
63             mstore(0x40, add(ptr, capacity))
64         }
65     }
66 
67     function resize(buffer memory buf, uint capacity) private pure {
68         bytes memory oldbuf = buf.buf;
69         init(buf, capacity);
70         append(buf, oldbuf);
71     }
72 
73     function max(uint a, uint b) private pure returns(uint) {
74         if(a > b) {
75             return a;
76         }
77         return b;
78     }
79 
80     /**
81      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
82      *      would exceed the capacity of the buffer.
83      * @param buf The buffer to append to.
84      * @param data The data to append.
85      * @return The original buffer.
86      */
87     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
88         if(data.length + buf.buf.length > buf.capacity) {
89             resize(buf, max(buf.capacity, data.length) * 2);
90         }
91 
92         uint dest;
93         uint src;
94         uint len = data.length;
95         assembly {
96             // Memory address of the buffer data
97             let bufptr := mload(buf)
98             // Length of existing buffer data
99             let buflen := mload(bufptr)
100             // Start address = buffer address + buffer length + sizeof(buffer length)
101             dest := add(add(bufptr, buflen), 32)
102             // Update buffer length
103             mstore(bufptr, add(buflen, mload(data)))
104             src := add(data, 32)
105         }
106 
107         // Copy word-length chunks while possible
108         for(; len >= 32; len -= 32) {
109             assembly {
110                 mstore(dest, mload(src))
111             }
112             dest += 32;
113             src += 32;
114         }
115 
116         // Copy remaining bytes
117         uint mask = 256 ** (32 - len) - 1;
118         assembly {
119             let srcpart := and(mload(src), not(mask))
120             let destpart := and(mload(dest), mask)
121             mstore(dest, or(destpart, srcpart))
122         }
123 
124         return buf;
125     }
126 
127     /**
128      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
129      * exceed the capacity of the buffer.
130      * @param buf The buffer to append to.
131      * @param data The data to append.
132      * @return The original buffer.
133      */
134     function append(buffer memory buf, uint8 data) internal pure {
135         if(buf.buf.length + 1 > buf.capacity) {
136             resize(buf, buf.capacity * 2);
137         }
138 
139         assembly {
140             // Memory address of the buffer data
141             let bufptr := mload(buf)
142             // Length of existing buffer data
143             let buflen := mload(bufptr)
144             // Address = buffer address + buffer length + sizeof(buffer length)
145             let dest := add(add(bufptr, buflen), 32)
146             mstore8(dest, data)
147             // Update buffer length
148             mstore(bufptr, add(buflen, 1))
149         }
150     }
151 
152     /**
153      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
154      * exceed the capacity of the buffer.
155      * @param buf The buffer to append to.
156      * @param data The data to append.
157      * @return The original buffer.
158      */
159     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
160         if(len + buf.buf.length > buf.capacity) {
161             resize(buf, max(buf.capacity, len) * 2);
162         }
163 
164         uint mask = 256 ** len - 1;
165         assembly {
166             // Memory address of the buffer data
167             let bufptr := mload(buf)
168             // Length of existing buffer data
169             let buflen := mload(bufptr)
170             // Address = buffer address + buffer length + sizeof(buffer length) + len
171             let dest := add(add(bufptr, buflen), len)
172             mstore(dest, or(and(mload(dest), not(mask)), data))
173             // Update buffer length
174             mstore(bufptr, add(buflen, len))
175         }
176         return buf;
177     }
178 }
179 
180 library CBOR {
181     using Buffer for Buffer.buffer;
182 
183     uint8 private constant MAJOR_TYPE_INT = 0;
184     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
185     uint8 private constant MAJOR_TYPE_BYTES = 2;
186     uint8 private constant MAJOR_TYPE_STRING = 3;
187     uint8 private constant MAJOR_TYPE_ARRAY = 4;
188     uint8 private constant MAJOR_TYPE_MAP = 5;
189     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
190 
191     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
192         if(value <= 23) {
193             buf.append(uint8((major << 5) | value));
194         } else if(value <= 0xFF) {
195             buf.append(uint8((major << 5) | 24));
196             buf.appendInt(value, 1);
197         } else if(value <= 0xFFFF) {
198             buf.append(uint8((major << 5) | 25));
199             buf.appendInt(value, 2);
200         } else if(value <= 0xFFFFFFFF) {
201             buf.append(uint8((major << 5) | 26));
202             buf.appendInt(value, 4);
203         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
204             buf.append(uint8((major << 5) | 27));
205             buf.appendInt(value, 8);
206         }
207     }
208 
209     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
210         buf.append(uint8((major << 5) | 31));
211     }
212 
213     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
214         encodeType(buf, MAJOR_TYPE_INT, value);
215     }
216 
217     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
218         if(value >= 0) {
219             encodeType(buf, MAJOR_TYPE_INT, uint(value));
220         } else {
221             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
222         }
223     }
224 
225     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
226         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
227         buf.append(value);
228     }
229 
230     function encodeString(Buffer.buffer memory buf, string value) internal pure {
231         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
232         buf.append(bytes(value));
233     }
234 
235     function startArray(Buffer.buffer memory buf) internal pure {
236         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
237     }
238 
239     function startMap(Buffer.buffer memory buf) internal pure {
240         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
241     }
242 
243     function endSequence(Buffer.buffer memory buf) internal pure {
244         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
245     }
246 }
247 
248 /*
249 End solidity-cborutils
250  */
251 
252 contract usingOraclize {
253     uint constant day = 60*60*24;
254     uint constant week = 60*60*24*7;
255     uint constant month = 60*60*24*30;
256     byte constant proofType_NONE = 0x00;
257     byte constant proofType_TLSNotary = 0x10;
258     byte constant proofType_Ledger = 0x30;
259     byte constant proofType_Android = 0x40;
260     byte constant proofType_Native = 0xF0;
261     byte constant proofStorage_IPFS = 0x01;
262     uint8 constant networkID_auto = 0;
263     uint8 constant networkID_mainnet = 1;
264     uint8 constant networkID_testnet = 2;
265     uint8 constant networkID_morden = 2;
266     uint8 constant networkID_consensys = 161;
267 
268     OraclizeAddrResolverI OAR;
269 
270     OraclizeI oraclize;
271     modifier oraclizeAPI {
272         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
273             oraclize_setNetwork(networkID_auto);
274 
275         if(address(oraclize) != OAR.getAddress())
276             oraclize = OraclizeI(OAR.getAddress());
277 
278         _;
279     }
280     modifier coupon(string code){
281         oraclize = OraclizeI(OAR.getAddress());
282         _;
283     }
284 
285     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
286       return oraclize_setNetwork();
287       networkID; // silence the warning and remain backwards compatible
288     }
289     function oraclize_setNetwork() internal returns(bool){
290         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
291             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
292             oraclize_setNetworkName("eth_mainnet");
293             return true;
294         }
295         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
296             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
297             oraclize_setNetworkName("eth_ropsten3");
298             return true;
299         }
300         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
301             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
302             oraclize_setNetworkName("eth_kovan");
303             return true;
304         }
305         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
306             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
307             oraclize_setNetworkName("eth_rinkeby");
308             return true;
309         }
310         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
311             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
312             return true;
313         }
314         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
315             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
316             return true;
317         }
318         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
319             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
320             return true;
321         }
322         return false;
323     }
324 
325     function __callback(bytes32 myid, string result) public {
326         __callback(myid, result, new bytes(0));
327     }
328     function __callback(bytes32 myid, string result, bytes proof) public {
329       return;
330       myid; result; proof; // Silence compiler warnings
331     }
332 
333     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
334         return oraclize.getPrice(datasource);
335     }
336 
337     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
338         return oraclize.getPrice(datasource, gaslimit);
339     }
340 
341     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
342         uint price = oraclize.getPrice(datasource);
343         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
344         return oraclize.query.value(price)(0, datasource, arg);
345     }
346     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
347         uint price = oraclize.getPrice(datasource);
348         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
349         return oraclize.query.value(price)(timestamp, datasource, arg);
350     }
351     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
352         uint price = oraclize.getPrice(datasource, gaslimit);
353         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
354         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
355     }
356     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
357         uint price = oraclize.getPrice(datasource, gaslimit);
358         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
359         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
360     }
361     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
362         uint price = oraclize.getPrice(datasource);
363         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
364         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
365     }
366     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
367         uint price = oraclize.getPrice(datasource);
368         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
369         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
370     }
371     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
372         uint price = oraclize.getPrice(datasource, gaslimit);
373         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
374         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
375     }
376     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
377         uint price = oraclize.getPrice(datasource, gaslimit);
378         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
379         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
380     }
381     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
382         uint price = oraclize.getPrice(datasource);
383         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
384         bytes memory args = stra2cbor(argN);
385         return oraclize.queryN.value(price)(0, datasource, args);
386     }
387     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
388         uint price = oraclize.getPrice(datasource);
389         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
390         bytes memory args = stra2cbor(argN);
391         return oraclize.queryN.value(price)(timestamp, datasource, args);
392     }
393     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
394         uint price = oraclize.getPrice(datasource, gaslimit);
395         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
396         bytes memory args = stra2cbor(argN);
397         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
398     }
399     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
400         uint price = oraclize.getPrice(datasource, gaslimit);
401         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
402         bytes memory args = stra2cbor(argN);
403         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
404     }
405     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
406         string[] memory dynargs = new string[](1);
407         dynargs[0] = args[0];
408         return oraclize_query(datasource, dynargs);
409     }
410     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
411         string[] memory dynargs = new string[](1);
412         dynargs[0] = args[0];
413         return oraclize_query(timestamp, datasource, dynargs);
414     }
415     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
416         string[] memory dynargs = new string[](1);
417         dynargs[0] = args[0];
418         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
419     }
420     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
421         string[] memory dynargs = new string[](1);
422         dynargs[0] = args[0];
423         return oraclize_query(datasource, dynargs, gaslimit);
424     }
425 
426     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
427         string[] memory dynargs = new string[](2);
428         dynargs[0] = args[0];
429         dynargs[1] = args[1];
430         return oraclize_query(datasource, dynargs);
431     }
432     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
433         string[] memory dynargs = new string[](2);
434         dynargs[0] = args[0];
435         dynargs[1] = args[1];
436         return oraclize_query(timestamp, datasource, dynargs);
437     }
438     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
439         string[] memory dynargs = new string[](2);
440         dynargs[0] = args[0];
441         dynargs[1] = args[1];
442         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
443     }
444     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
445         string[] memory dynargs = new string[](2);
446         dynargs[0] = args[0];
447         dynargs[1] = args[1];
448         return oraclize_query(datasource, dynargs, gaslimit);
449     }
450     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
451         string[] memory dynargs = new string[](3);
452         dynargs[0] = args[0];
453         dynargs[1] = args[1];
454         dynargs[2] = args[2];
455         return oraclize_query(datasource, dynargs);
456     }
457     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
458         string[] memory dynargs = new string[](3);
459         dynargs[0] = args[0];
460         dynargs[1] = args[1];
461         dynargs[2] = args[2];
462         return oraclize_query(timestamp, datasource, dynargs);
463     }
464     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
465         string[] memory dynargs = new string[](3);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         dynargs[2] = args[2];
469         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
470     }
471     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
472         string[] memory dynargs = new string[](3);
473         dynargs[0] = args[0];
474         dynargs[1] = args[1];
475         dynargs[2] = args[2];
476         return oraclize_query(datasource, dynargs, gaslimit);
477     }
478 
479     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
480         string[] memory dynargs = new string[](4);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         dynargs[2] = args[2];
484         dynargs[3] = args[3];
485         return oraclize_query(datasource, dynargs);
486     }
487     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
488         string[] memory dynargs = new string[](4);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         dynargs[2] = args[2];
492         dynargs[3] = args[3];
493         return oraclize_query(timestamp, datasource, dynargs);
494     }
495     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
496         string[] memory dynargs = new string[](4);
497         dynargs[0] = args[0];
498         dynargs[1] = args[1];
499         dynargs[2] = args[2];
500         dynargs[3] = args[3];
501         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
502     }
503     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
504         string[] memory dynargs = new string[](4);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         dynargs[3] = args[3];
509         return oraclize_query(datasource, dynargs, gaslimit);
510     }
511     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
512         string[] memory dynargs = new string[](5);
513         dynargs[0] = args[0];
514         dynargs[1] = args[1];
515         dynargs[2] = args[2];
516         dynargs[3] = args[3];
517         dynargs[4] = args[4];
518         return oraclize_query(datasource, dynargs);
519     }
520     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
521         string[] memory dynargs = new string[](5);
522         dynargs[0] = args[0];
523         dynargs[1] = args[1];
524         dynargs[2] = args[2];
525         dynargs[3] = args[3];
526         dynargs[4] = args[4];
527         return oraclize_query(timestamp, datasource, dynargs);
528     }
529     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
530         string[] memory dynargs = new string[](5);
531         dynargs[0] = args[0];
532         dynargs[1] = args[1];
533         dynargs[2] = args[2];
534         dynargs[3] = args[3];
535         dynargs[4] = args[4];
536         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
537     }
538     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
539         string[] memory dynargs = new string[](5);
540         dynargs[0] = args[0];
541         dynargs[1] = args[1];
542         dynargs[2] = args[2];
543         dynargs[3] = args[3];
544         dynargs[4] = args[4];
545         return oraclize_query(datasource, dynargs, gaslimit);
546     }
547     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
548         uint price = oraclize.getPrice(datasource);
549         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
550         bytes memory args = ba2cbor(argN);
551         return oraclize.queryN.value(price)(0, datasource, args);
552     }
553     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
554         uint price = oraclize.getPrice(datasource);
555         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
556         bytes memory args = ba2cbor(argN);
557         return oraclize.queryN.value(price)(timestamp, datasource, args);
558     }
559     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
560         uint price = oraclize.getPrice(datasource, gaslimit);
561         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
562         bytes memory args = ba2cbor(argN);
563         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
564     }
565     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
566         uint price = oraclize.getPrice(datasource, gaslimit);
567         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
568         bytes memory args = ba2cbor(argN);
569         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
570     }
571     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
572         bytes[] memory dynargs = new bytes[](1);
573         dynargs[0] = args[0];
574         return oraclize_query(datasource, dynargs);
575     }
576     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
577         bytes[] memory dynargs = new bytes[](1);
578         dynargs[0] = args[0];
579         return oraclize_query(timestamp, datasource, dynargs);
580     }
581     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
582         bytes[] memory dynargs = new bytes[](1);
583         dynargs[0] = args[0];
584         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
585     }
586     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
587         bytes[] memory dynargs = new bytes[](1);
588         dynargs[0] = args[0];
589         return oraclize_query(datasource, dynargs, gaslimit);
590     }
591 
592     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
593         bytes[] memory dynargs = new bytes[](2);
594         dynargs[0] = args[0];
595         dynargs[1] = args[1];
596         return oraclize_query(datasource, dynargs);
597     }
598     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
599         bytes[] memory dynargs = new bytes[](2);
600         dynargs[0] = args[0];
601         dynargs[1] = args[1];
602         return oraclize_query(timestamp, datasource, dynargs);
603     }
604     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
605         bytes[] memory dynargs = new bytes[](2);
606         dynargs[0] = args[0];
607         dynargs[1] = args[1];
608         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
609     }
610     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
611         bytes[] memory dynargs = new bytes[](2);
612         dynargs[0] = args[0];
613         dynargs[1] = args[1];
614         return oraclize_query(datasource, dynargs, gaslimit);
615     }
616     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
617         bytes[] memory dynargs = new bytes[](3);
618         dynargs[0] = args[0];
619         dynargs[1] = args[1];
620         dynargs[2] = args[2];
621         return oraclize_query(datasource, dynargs);
622     }
623     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
624         bytes[] memory dynargs = new bytes[](3);
625         dynargs[0] = args[0];
626         dynargs[1] = args[1];
627         dynargs[2] = args[2];
628         return oraclize_query(timestamp, datasource, dynargs);
629     }
630     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
631         bytes[] memory dynargs = new bytes[](3);
632         dynargs[0] = args[0];
633         dynargs[1] = args[1];
634         dynargs[2] = args[2];
635         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
636     }
637     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
638         bytes[] memory dynargs = new bytes[](3);
639         dynargs[0] = args[0];
640         dynargs[1] = args[1];
641         dynargs[2] = args[2];
642         return oraclize_query(datasource, dynargs, gaslimit);
643     }
644 
645     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
646         bytes[] memory dynargs = new bytes[](4);
647         dynargs[0] = args[0];
648         dynargs[1] = args[1];
649         dynargs[2] = args[2];
650         dynargs[3] = args[3];
651         return oraclize_query(datasource, dynargs);
652     }
653     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
654         bytes[] memory dynargs = new bytes[](4);
655         dynargs[0] = args[0];
656         dynargs[1] = args[1];
657         dynargs[2] = args[2];
658         dynargs[3] = args[3];
659         return oraclize_query(timestamp, datasource, dynargs);
660     }
661     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
662         bytes[] memory dynargs = new bytes[](4);
663         dynargs[0] = args[0];
664         dynargs[1] = args[1];
665         dynargs[2] = args[2];
666         dynargs[3] = args[3];
667         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
668     }
669     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
670         bytes[] memory dynargs = new bytes[](4);
671         dynargs[0] = args[0];
672         dynargs[1] = args[1];
673         dynargs[2] = args[2];
674         dynargs[3] = args[3];
675         return oraclize_query(datasource, dynargs, gaslimit);
676     }
677     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
678         bytes[] memory dynargs = new bytes[](5);
679         dynargs[0] = args[0];
680         dynargs[1] = args[1];
681         dynargs[2] = args[2];
682         dynargs[3] = args[3];
683         dynargs[4] = args[4];
684         return oraclize_query(datasource, dynargs);
685     }
686     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
687         bytes[] memory dynargs = new bytes[](5);
688         dynargs[0] = args[0];
689         dynargs[1] = args[1];
690         dynargs[2] = args[2];
691         dynargs[3] = args[3];
692         dynargs[4] = args[4];
693         return oraclize_query(timestamp, datasource, dynargs);
694     }
695     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
696         bytes[] memory dynargs = new bytes[](5);
697         dynargs[0] = args[0];
698         dynargs[1] = args[1];
699         dynargs[2] = args[2];
700         dynargs[3] = args[3];
701         dynargs[4] = args[4];
702         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
703     }
704     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
705         bytes[] memory dynargs = new bytes[](5);
706         dynargs[0] = args[0];
707         dynargs[1] = args[1];
708         dynargs[2] = args[2];
709         dynargs[3] = args[3];
710         dynargs[4] = args[4];
711         return oraclize_query(datasource, dynargs, gaslimit);
712     }
713 
714     function oraclize_cbAddress() oraclizeAPI internal returns (address){
715         return oraclize.cbAddress();
716     }
717     function oraclize_setProof(byte proofP) oraclizeAPI internal {
718         return oraclize.setProofType(proofP);
719     }
720     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
721         return oraclize.setCustomGasPrice(gasPrice);
722     }
723 
724     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
725         return oraclize.randomDS_getSessionPubKeyHash();
726     }
727 
728     function getCodeSize(address _addr) constant internal returns(uint _size) {
729         assembly {
730             _size := extcodesize(_addr)
731         }
732     }
733 
734     function parseAddr(string _a) internal pure returns (address){
735         bytes memory tmp = bytes(_a);
736         uint160 iaddr = 0;
737         uint160 b1;
738         uint160 b2;
739         for (uint i=2; i<2+2*20; i+=2){
740             iaddr *= 256;
741             b1 = uint160(tmp[i]);
742             b2 = uint160(tmp[i+1]);
743             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
744             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
745             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
746             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
747             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
748             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
749             iaddr += (b1*16+b2);
750         }
751         return address(iaddr);
752     }
753 
754     function strCompare(string _a, string _b) internal pure returns (int) {
755         bytes memory a = bytes(_a);
756         bytes memory b = bytes(_b);
757         uint minLength = a.length;
758         if (b.length < minLength) minLength = b.length;
759         for (uint i = 0; i < minLength; i ++)
760             if (a[i] < b[i])
761                 return -1;
762             else if (a[i] > b[i])
763                 return 1;
764         if (a.length < b.length)
765             return -1;
766         else if (a.length > b.length)
767             return 1;
768         else
769             return 0;
770     }
771 
772     function indexOf(string _haystack, string _needle) internal pure returns (int) {
773         bytes memory h = bytes(_haystack);
774         bytes memory n = bytes(_needle);
775         if(h.length < 1 || n.length < 1 || (n.length > h.length))
776             return -1;
777         else if(h.length > (2**128 -1))
778             return -1;
779         else
780         {
781             uint subindex = 0;
782             for (uint i = 0; i < h.length; i ++)
783             {
784                 if (h[i] == n[0])
785                 {
786                     subindex = 1;
787                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
788                     {
789                         subindex++;
790                     }
791                     if(subindex == n.length)
792                         return int(i);
793                 }
794             }
795             return -1;
796         }
797     }
798 
799     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
800         bytes memory _ba = bytes(_a);
801         bytes memory _bb = bytes(_b);
802         bytes memory _bc = bytes(_c);
803         bytes memory _bd = bytes(_d);
804         bytes memory _be = bytes(_e);
805         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
806         bytes memory babcde = bytes(abcde);
807         uint k = 0;
808         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
809         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
810         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
811         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
812         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
813         return string(babcde);
814     }
815 
816     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
817         return strConcat(_a, _b, _c, _d, "");
818     }
819 
820     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
821         return strConcat(_a, _b, _c, "", "");
822     }
823 
824     function strConcat(string _a, string _b) internal pure returns (string) {
825         return strConcat(_a, _b, "", "", "");
826     }
827 
828     // parseInt
829     function parseInt(string _a) internal pure returns (uint) {
830         return parseInt(_a, 0);
831     }
832 
833     // parseInt(parseFloat*10^_b)
834     function parseInt(string _a, uint _b) internal pure returns (uint) {
835         bytes memory bresult = bytes(_a);
836         uint mint = 0;
837         bool decimals = false;
838         for (uint i=0; i<bresult.length; i++){
839             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
840                 if (decimals){
841                    if (_b == 0) break;
842                     else _b--;
843                 }
844                 mint *= 10;
845                 mint += uint(bresult[i]) - 48;
846             } else if (bresult[i] == 46) decimals = true;
847         }
848         if (_b > 0) mint *= 10**_b;
849         return mint;
850     }
851 
852     function uint2str(uint i) internal pure returns (string){
853         if (i == 0) return "0";
854         uint j = i;
855         uint len;
856         while (j != 0){
857             len++;
858             j /= 10;
859         }
860         bytes memory bstr = new bytes(len);
861         uint k = len - 1;
862         while (i != 0){
863             bstr[k--] = byte(48 + i % 10);
864             i /= 10;
865         }
866         return string(bstr);
867     }
868 
869     using CBOR for Buffer.buffer;
870     function stra2cbor(string[] arr) internal pure returns (bytes) {
871         safeMemoryCleaner();
872         Buffer.buffer memory buf;
873         Buffer.init(buf, 1024);
874         buf.startArray();
875         for (uint i = 0; i < arr.length; i++) {
876             buf.encodeString(arr[i]);
877         }
878         buf.endSequence();
879         return buf.buf;
880     }
881 
882     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
883         safeMemoryCleaner();
884         Buffer.buffer memory buf;
885         Buffer.init(buf, 1024);
886         buf.startArray();
887         for (uint i = 0; i < arr.length; i++) {
888             buf.encodeBytes(arr[i]);
889         }
890         buf.endSequence();
891         return buf.buf;
892     }
893 
894     string oraclize_network_name;
895     function oraclize_setNetworkName(string _network_name) internal {
896         oraclize_network_name = _network_name;
897     }
898 
899     function oraclize_getNetworkName() internal view returns (string) {
900         return oraclize_network_name;
901     }
902 
903     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
904         require((_nbytes > 0) && (_nbytes <= 32));
905         // Convert from seconds to ledger timer ticks
906         _delay *= 10;
907         bytes memory nbytes = new bytes(1);
908         nbytes[0] = byte(_nbytes);
909         bytes memory unonce = new bytes(32);
910         bytes memory sessionKeyHash = new bytes(32);
911         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
912         assembly {
913             mstore(unonce, 0x20)
914             // the following variables can be relaxed
915             // check relaxed random contract under ethereum-examples repo
916             // for an idea on how to override and replace comit hash vars
917             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
918             mstore(sessionKeyHash, 0x20)
919             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
920         }
921         bytes memory delay = new bytes(32);
922         assembly {
923             mstore(add(delay, 0x20), _delay)
924         }
925 
926         bytes memory delay_bytes8 = new bytes(8);
927         copyBytes(delay, 24, 8, delay_bytes8, 0);
928 
929         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
930         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
931 
932         bytes memory delay_bytes8_left = new bytes(8);
933 
934         assembly {
935             let x := mload(add(delay_bytes8, 0x20))
936             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
937             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
938             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
939             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
940             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
941             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
942             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
943             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
944 
945         }
946 
947         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
948         return queryId;
949     }
950 
951     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
952         oraclize_randomDS_args[queryId] = commitment;
953     }
954 
955     mapping(bytes32=>bytes32) oraclize_randomDS_args;
956     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
957 
958     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
959         bool sigok;
960         address signer;
961 
962         bytes32 sigr;
963         bytes32 sigs;
964 
965         bytes memory sigr_ = new bytes(32);
966         uint offset = 4+(uint(dersig[3]) - 0x20);
967         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
968         bytes memory sigs_ = new bytes(32);
969         offset += 32 + 2;
970         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
971 
972         assembly {
973             sigr := mload(add(sigr_, 32))
974             sigs := mload(add(sigs_, 32))
975         }
976 
977 
978         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
979         if (address(keccak256(pubkey)) == signer) return true;
980         else {
981             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
982             return (address(keccak256(pubkey)) == signer);
983         }
984     }
985 
986     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
987         bool sigok;
988 
989         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
990         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
991         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
992 
993         bytes memory appkey1_pubkey = new bytes(64);
994         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
995 
996         bytes memory tosign2 = new bytes(1+65+32);
997         tosign2[0] = byte(1); //role
998         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
999         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1000         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1001         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1002 
1003         if (sigok == false) return false;
1004 
1005 
1006         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1007         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1008 
1009         bytes memory tosign3 = new bytes(1+65);
1010         tosign3[0] = 0xFE;
1011         copyBytes(proof, 3, 65, tosign3, 1);
1012 
1013         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1014         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1015 
1016         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1017 
1018         return sigok;
1019     }
1020 
1021     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1022         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1023         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1024 
1025         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1026         require(proofVerified);
1027 
1028         _;
1029     }
1030 
1031     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1032         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1033         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1034 
1035         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1036         if (proofVerified == false) return 2;
1037 
1038         return 0;
1039     }
1040 
1041     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1042         bool match_ = true;
1043 
1044         require(prefix.length == n_random_bytes);
1045 
1046         for (uint256 i=0; i< n_random_bytes; i++) {
1047             if (content[i] != prefix[i]) match_ = false;
1048         }
1049 
1050         return match_;
1051     }
1052 
1053     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1054 
1055         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1056         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1057         bytes memory keyhash = new bytes(32);
1058         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1059         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1060 
1061         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1062         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1063 
1064         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1065         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1066 
1067         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1068         // This is to verify that the computed args match with the ones specified in the query.
1069         bytes memory commitmentSlice1 = new bytes(8+1+32);
1070         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1071 
1072         bytes memory sessionPubkey = new bytes(64);
1073         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1074         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1075 
1076         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1077         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1078             delete oraclize_randomDS_args[queryId];
1079         } else return false;
1080 
1081 
1082         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1083         bytes memory tosign1 = new bytes(32+8+1+32);
1084         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1085         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1086 
1087         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1088         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1089             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1090         }
1091 
1092         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1093     }
1094 
1095     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1096     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1097         uint minLength = length + toOffset;
1098 
1099         // Buffer too small
1100         require(to.length >= minLength); // Should be a better way?
1101 
1102         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1103         uint i = 32 + fromOffset;
1104         uint j = 32 + toOffset;
1105 
1106         while (i < (32 + fromOffset + length)) {
1107             assembly {
1108                 let tmp := mload(add(from, i))
1109                 mstore(add(to, j), tmp)
1110             }
1111             i += 32;
1112             j += 32;
1113         }
1114 
1115         return to;
1116     }
1117 
1118     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1119     // Duplicate Solidity's ecrecover, but catching the CALL return value
1120     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1121         // We do our own memory management here. Solidity uses memory offset
1122         // 0x40 to store the current end of memory. We write past it (as
1123         // writes are memory extensions), but don't update the offset so
1124         // Solidity will reuse it. The memory used here is only needed for
1125         // this context.
1126 
1127         // FIXME: inline assembly can't access return values
1128         bool ret;
1129         address addr;
1130 
1131         assembly {
1132             let size := mload(0x40)
1133             mstore(size, hash)
1134             mstore(add(size, 32), v)
1135             mstore(add(size, 64), r)
1136             mstore(add(size, 96), s)
1137 
1138             // NOTE: we can reuse the request memory because we deal with
1139             //       the return code
1140             ret := call(3000, 1, 0, size, 128, size, 32)
1141             addr := mload(size)
1142         }
1143 
1144         return (ret, addr);
1145     }
1146 
1147     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1148     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1149         bytes32 r;
1150         bytes32 s;
1151         uint8 v;
1152 
1153         if (sig.length != 65)
1154           return (false, 0);
1155 
1156         // The signature format is a compact form of:
1157         //   {bytes32 r}{bytes32 s}{uint8 v}
1158         // Compact means, uint8 is not padded to 32 bytes.
1159         assembly {
1160             r := mload(add(sig, 32))
1161             s := mload(add(sig, 64))
1162 
1163             // Here we are loading the last 32 bytes. We exploit the fact that
1164             // 'mload' will pad with zeroes if we overread.
1165             // There is no 'mload8' to do this, but that would be nicer.
1166             v := byte(0, mload(add(sig, 96)))
1167 
1168             // Alternative solution:
1169             // 'byte' is not working due to the Solidity parser, so lets
1170             // use the second best option, 'and'
1171             // v := and(mload(add(sig, 65)), 255)
1172         }
1173 
1174         // albeit non-transactional signatures are not specified by the YP, one would expect it
1175         // to match the YP range of [27, 28]
1176         //
1177         // geth uses [0, 1] and some clients have followed. This might change, see:
1178         //  https://github.com/ethereum/go-ethereum/issues/2053
1179         if (v < 27)
1180           v += 27;
1181 
1182         if (v != 27 && v != 28)
1183             return (false, 0);
1184 
1185         return safer_ecrecover(hash, v, r, s);
1186     }
1187 
1188     function safeMemoryCleaner() internal pure {
1189         assembly {
1190             let fmem := mload(0x40)
1191             codecopy(fmem, codesize, sub(msize, fmem))
1192         }
1193     }
1194 
1195 }
1196 // </ORACLIZE_API>
1197 contract ERC20Interface {
1198 
1199     function totalSupply() public pure returns (uint256);
1200 
1201     function balanceOf(address _owner) public view returns (uint256 balance);
1202 
1203     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
1204 
1205     function transfer(address _to, uint256 _value) public returns (bool success);
1206 
1207     function approve(address _spender, uint256 _value) public returns (bool success);
1208 
1209     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
1210 
1211 
1212     event Transfer(address indexed _from, address indexed _to, uint256 _value);
1213 
1214     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
1215 
1216 }
1217 
1218 
1219 contract StandardToken is ERC20Interface {
1220 
1221     uint256 constant private MAX_UINT256 = 2**256 - 1;
1222     mapping (address => uint256) public balances;
1223     mapping (address => mapping (address => uint256)) public allowed;
1224     
1225     string public name = "MeiCoin (Round 1)";
1226     uint8 public decimals = 18;
1227     string public symbol = "MEIX";
1228     
1229     bool fundsLocked = true;
1230 
1231     function StandardToken() public {
1232     }
1233 
1234     function transfer(address _to, uint256 _value) public returns (bool success) {
1235         require(fundsLocked == false);
1236         return _transfer(msg.sender, _to, _value);
1237     }
1238 
1239     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1240         require(fundsLocked == false);
1241         require(_value <= allowed[_from][msg.sender]);     // Check allowance
1242         allowed[_from][msg.sender] -= _value;
1243         return _transfer(_from, _to, _value);
1244     }
1245     
1246     function _transfer(address _from, address _to, uint256 _value) internal returns(bool success) {
1247         // Prevent transfer to 0x0 address. Use burn() instead
1248         require(_to != 0x0);
1249         // Check if the sender has enough
1250         require(balances[_from] >= _value);
1251         // Check for overflows
1252         require(balances[_to] + _value >= balances[_to]);
1253         // Save this for an assertion in the future
1254         uint previousBalances = balances[_from] + balances[_to];
1255         // Subtract from the sender
1256         balances[_from] -= _value;
1257         // Add the same to the recipient
1258         balances[_to] += _value;
1259         emit Transfer(_from, _to, _value);
1260         // Asserts are used to use static analysis to find bugs in your code. They should never fail
1261         assert(balances[_from] + balances[_to] == previousBalances);
1262         return true;
1263     }
1264 
1265     function approve(address _spender, uint256 _value) public returns (bool success) {
1266         allowed[msg.sender][_spender] = _value;
1267         emit Approval(msg.sender, _spender, _value);
1268         return true;
1269     }
1270     
1271     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
1272         return allowed[_owner][_spender];
1273     }
1274     function balanceOf(address tokenOwner) public constant returns (uint balance) {
1275         return balances[tokenOwner];
1276     }
1277 }
1278 
1279 contract Staged is StandardToken {
1280     struct Fund {
1281         uint256 amount;
1282         uint256 raisedAt;
1283     }
1284 
1285     struct Contributor {
1286         Fund[] funds;
1287         bool authorized;
1288         bool finalized;
1289     }
1290     enum StageState{
1291         Closed, Open, Done
1292     }
1293 
1294     struct Stage {
1295         bool authOnly;
1296         uint lowerBound;
1297         uint upperBound;
1298         StageState state;
1299         uint256 raised;
1300         uint256 tokensRaised;
1301         mapping(address => Contributor) contributors;
1302     }
1303 
1304     uint256 curStage;
1305     Stage[] public stages;
1306     address ETHFund;
1307     
1308     function Staged() public {
1309         ETHFund = msg.sender;
1310     }
1311 
1312     function () payable external {
1313         require(msg.sender != ETHFund);
1314         require(stages[stages.length-1].state != StageState.Done);
1315         require(msg.value > 0);
1316         require(stages[curStage].authOnly <= stages[curStage].contributors[msg.sender].authorized);
1317         
1318         uint256 refundAmount;
1319         uint256 funds;
1320         (funds,refundAmount) = ExchangeRate(msg.value);
1321         assert(refundAmount < msg.value);
1322         msg.sender.transfer(refundAmount);
1323         ETHFund.transfer(msg.value-refundAmount);
1324         addFunds(funds,msg.sender);
1325     }
1326     
1327     function withdrawal(uint256 funds) public {
1328         require(msg.sender == ETHFund);
1329         require(address(this).balance > 0);
1330         if(funds > address(this).balance){
1331             funds = address(this).balance;
1332         }
1333         msg.sender.transfer(funds);
1334     }
1335 
1336     function addFunds(uint256 funds, address contributor) internal {
1337         assert(stages[curStage].state == StageState.Open);
1338         require(stages[curStage].contributors[contributor].funds.length < 4);
1339         
1340         stages[curStage].contributors[contributor].funds.push(Fund(funds,stages[curStage].raised));
1341         stages[curStage].raised += funds;
1342         
1343         require(_transfer(ETHFund,msg.sender,((funds*10**18 / stages[curStage].upperBound))));
1344     }
1345 
1346     function authorize(address authorizedAddress, uint256 stage) external {
1347         require(stage < stages.length && stage >= curStage);
1348         require(stages[stage].authOnly);
1349         require(msg.sender == ETHFund);
1350         
1351         stages[stage].contributors[authorizedAddress].authorized = true; 
1352     }
1353     
1354     function FinalizeStage() internal{
1355         stages[curStage].tokensRaised = 2*(stages[curStage].raised*10**18+stages[curStage].upperBound - stages[curStage].lowerBound)/(stages[curStage].upperBound + stages[curStage].lowerBound)+1;
1356         stages[curStage].state = StageState.Done;
1357         if(stages.length-1 != curStage){
1358             curStage += 1;
1359         }
1360     }
1361 
1362     function EndStage() external {
1363         require(msg.sender == ETHFund);
1364         FinalizeStage();
1365     }
1366     
1367     function GetContributorData(address contributor,uint256 stage) internal view returns (uint256[] contributedAmount, uint256[] contributedRaised){
1368         require(stage < stages.length);
1369         uint256[] memory amounts = new uint256[](stages[stage].contributors[contributor].funds.length);
1370         uint256[] memory raised = new uint256[](stages[stage].contributors[contributor].funds.length);
1371         for(uint i = 0; i < stages[stage].contributors[contributor].funds.length; i++){
1372             amounts[i] = stages[stage].contributors[contributor].funds[i].amount;
1373             raised[i] = stages[stage].contributors[contributor].funds[i].raisedAt;
1374         }
1375         return (amounts,raised);
1376     }
1377     
1378     function ExchangeRate(uint256 weiValue) public view returns (uint256 exchanged, uint256 remainder);
1379 }
1380 
1381 contract Ticker is usingOraclize {
1382     uint256 refresh = 0;
1383     
1384     uint public ETHUSD = 0;
1385     
1386     event newOraclizeQuery(string description);
1387     event newPriceTicker(string price);
1388 
1389     function Ticker() public {
1390         // FIXME: enable oraclize_setProof is production
1391         // oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1392     }
1393     
1394     function __callback(bytes32 myid, string result, bytes proof) public {
1395         require(msg.sender != oraclize_cbAddress());
1396         newPriceTicker(result);
1397         ETHUSD = parseInt(result, 4);
1398         // do something with ETHUSD
1399         if(refresh > 0){
1400             update(refresh);
1401         }
1402     }
1403     function __callback(bytes32 myid, string result) public {
1404         require(msg.sender == oraclize_cbAddress());
1405         newPriceTicker(result);
1406         ETHUSD = parseInt(result, 4);
1407         // do something with ETHUSD
1408         if(refresh > 0){
1409             update(refresh);
1410         }
1411     }
1412     
1413     function update(uint delay) payable {
1414         if (oraclize_getPrice("URL") > this.balance) {
1415             newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1416         } else {
1417             newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1418 
1419             oraclize_query(delay, "URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1420         }
1421     }
1422 }
1423 
1424 contract Stage1MEI is Staged, Ticker {
1425     
1426     bool stagesInitialized;
1427     
1428     function Stage1MEI() public {
1429       ETHFund = address(0x0Da5F4a56c0B57f1D7c918C63022C40c903430aC);
1430       balances[ETHFund] = totalSupply();
1431       stages.push(Stage(true, 100, 272, StageState.Closed,0,0));
1432       stagesInitialized = false;
1433       ETHUSD = 4750700;
1434     }
1435     
1436     function initStages() external {
1437         require(stagesInitialized == false);
1438         stages[0].state = StageState.Open;
1439         update(0);
1440         stagesInitialized = true;
1441     }
1442     
1443     function totalSupply() public pure returns (uint256){
1444         return 100 * (10**7) * 10**18;
1445     }
1446     
1447     function claimTokens() external {
1448         require(stages[0].state == StageState.Done);
1449         require(stages[0].contributors[msg.sender].finalized == false);
1450         uint256 tokens;
1451         for(uint i = 0; i < stages.length; i++){
1452             for(uint j = 0; j < stages[i].contributors[msg.sender].funds.length; j++){
1453                 Fund f = stages[i].contributors[msg.sender].funds[j];
1454                 tokens += uint256(calcTokens(i,f.amount,f.raisedAt));
1455             }
1456         }
1457         uint256 claimableTokens = tokens - balances[msg.sender];
1458         require(_transfer(ETHFund,msg.sender,claimableTokens));
1459         stages[0].contributors[msg.sender].finalized = true;
1460     }
1461     
1462     function calcTokens(uint256 stage, uint256 amountContributed, uint256 raisedAt) internal returns (int256){
1463         int256 T = int256(stages[stage].tokensRaised);
1464         int256 L = int256(stages[stage].lowerBound);
1465         int256 U = int256(stages[stage].upperBound);
1466         
1467     	int256 a=((U-L)/2);
1468     	int256 b = 0;
1469     	if(raisedAt > 0){
1470     	    b=(L*T+(calcTokens(stage,raisedAt,0)*(U-L))-a);
1471     	}else{
1472     	    b=(L*T+(0*(U-L))-a);
1473     	}
1474     	assert(b != 0);
1475     	int256 c=-(int256(amountContributed)*10**18)*T;
1476     	return ((-b+sqrt(b*b-4*a*c))/(2*a))+1;
1477     }
1478     
1479     function funder(address funder) public returns(uint256 raisedAt, uint256 fundamt){
1480         return (stages[0].contributors[funder].funds[0].raisedAt,stages[0].contributors[funder].funds[0].amount);
1481     }
1482     
1483     function sqrt(int256 x) internal returns (int256 y) {
1484         if (x == 0) return 0;
1485         else if (x <= 3) return 1;
1486         int z = (x + 1) / 2;
1487         y = x;
1488         while (z < y)
1489         {
1490             y = z;
1491             z = (x / z + z) / 2;
1492         }
1493     }
1494     
1495     function ExchangeRate(uint256 weiValue) public view returns(uint256 exchanged, uint256 remainder){
1496         uint256 ExchRate = 1000000000000000000/ETHUSD;
1497         uint256 returnVal = weiValue / ExchRate;
1498         weiValue = weiValue % ExchRate;
1499         return (returnVal,weiValue);
1500     }
1501 }