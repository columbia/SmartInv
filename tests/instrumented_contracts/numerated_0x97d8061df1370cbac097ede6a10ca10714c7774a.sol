1 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
2 
3 contract OraclizeI {
4     address public cbAddress;
5     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
6     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
7     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
8     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
9     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
10     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
11     function getPrice(string _datasource) public returns (uint _dsprice);
12     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
13     function setProofType(byte _proofType) external;
14     function setCustomGasPrice(uint _gasPrice) external;
15     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
16 }
17 
18 contract OraclizeAddrResolverI {
19     function getAddress() public returns (address _addr);
20 }
21 
22 /*
23 Begin solidity-cborutils
24 https://github.com/smartcontractkit/solidity-cborutils
25 MIT License
26 Copyright (c) 2018 SmartContract ChainLink, Ltd.
27 Permission is hereby granted, free of charge, to any person obtaining a copy
28 of this software and associated documentation files (the "Software"), to deal
29 in the Software without restriction, including without limitation the rights
30 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
31 copies of the Software, and to permit persons to whom the Software is
32 furnished to do so, subject to the following conditions:
33 The above copyright notice and this permission notice shall be included in all
34 copies or substantial portions of the Software.
35 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
36 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
37 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
38 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
39 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
40 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
41 SOFTWARE.
42  */
43 
44 library Buffer {
45     struct buffer {
46         bytes buf;
47         uint capacity;
48     }
49 
50     function init(buffer memory buf, uint _capacity) internal pure {
51         uint capacity = _capacity;
52         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
53         // Allocate space for the buffer data
54         buf.capacity = capacity;
55         assembly {
56             let ptr := mload(0x40)
57             mstore(buf, ptr)
58             mstore(ptr, 0)
59             mstore(0x40, add(ptr, capacity))
60         }
61     }
62 
63     function resize(buffer memory buf, uint capacity) private pure {
64         bytes memory oldbuf = buf.buf;
65         init(buf, capacity);
66         append(buf, oldbuf);
67     }
68 
69     function max(uint a, uint b) private pure returns(uint) {
70         if(a > b) {
71             return a;
72         }
73         return b;
74     }
75 
76     /**
77      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
78      *      would exceed the capacity of the buffer.
79      * @param buf The buffer to append to.
80      * @param data The data to append.
81      * @return The original buffer.
82      */
83     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
84         if(data.length + buf.buf.length > buf.capacity) {
85             resize(buf, max(buf.capacity, data.length) * 2);
86         }
87 
88         uint dest;
89         uint src;
90         uint len = data.length;
91         assembly {
92             // Memory address of the buffer data
93             let bufptr := mload(buf)
94             // Length of existing buffer data
95             let buflen := mload(bufptr)
96             // Start address = buffer address + buffer length + sizeof(buffer length)
97             dest := add(add(bufptr, buflen), 32)
98             // Update buffer length
99             mstore(bufptr, add(buflen, mload(data)))
100             src := add(data, 32)
101         }
102 
103         // Copy word-length chunks while possible
104         for(; len >= 32; len -= 32) {
105             assembly {
106                 mstore(dest, mload(src))
107             }
108             dest += 32;
109             src += 32;
110         }
111 
112         // Copy remaining bytes
113         uint mask = 256 ** (32 - len) - 1;
114         assembly {
115             let srcpart := and(mload(src), not(mask))
116             let destpart := and(mload(dest), mask)
117             mstore(dest, or(destpart, srcpart))
118         }
119 
120         return buf;
121     }
122 
123     /**
124      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
125      * exceed the capacity of the buffer.
126      * @param buf The buffer to append to.
127      * @param data The data to append.
128      * @return The original buffer.
129      */
130     function append(buffer memory buf, uint8 data) internal pure {
131         if(buf.buf.length + 1 > buf.capacity) {
132             resize(buf, buf.capacity * 2);
133         }
134 
135         assembly {
136             // Memory address of the buffer data
137             let bufptr := mload(buf)
138             // Length of existing buffer data
139             let buflen := mload(bufptr)
140             // Address = buffer address + buffer length + sizeof(buffer length)
141             let dest := add(add(bufptr, buflen), 32)
142             mstore8(dest, data)
143             // Update buffer length
144             mstore(bufptr, add(buflen, 1))
145         }
146     }
147 
148     /**
149      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
150      * exceed the capacity of the buffer.
151      * @param buf The buffer to append to.
152      * @param data The data to append.
153      * @return The original buffer.
154      */
155     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
156         if(len + buf.buf.length > buf.capacity) {
157             resize(buf, max(buf.capacity, len) * 2);
158         }
159 
160         uint mask = 256 ** len - 1;
161         assembly {
162             // Memory address of the buffer data
163             let bufptr := mload(buf)
164             // Length of existing buffer data
165             let buflen := mload(bufptr)
166             // Address = buffer address + buffer length + sizeof(buffer length) + len
167             let dest := add(add(bufptr, buflen), len)
168             mstore(dest, or(and(mload(dest), not(mask)), data))
169             // Update buffer length
170             mstore(bufptr, add(buflen, len))
171         }
172         return buf;
173     }
174 }
175 
176 library CBOR {
177     using Buffer for Buffer.buffer;
178 
179     uint8 private constant MAJOR_TYPE_INT = 0;
180     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
181     uint8 private constant MAJOR_TYPE_BYTES = 2;
182     uint8 private constant MAJOR_TYPE_STRING = 3;
183     uint8 private constant MAJOR_TYPE_ARRAY = 4;
184     uint8 private constant MAJOR_TYPE_MAP = 5;
185     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
186 
187     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
188         if(value <= 23) {
189             buf.append(uint8((major << 5) | value));
190         } else if(value <= 0xFF) {
191             buf.append(uint8((major << 5) | 24));
192             buf.appendInt(value, 1);
193         } else if(value <= 0xFFFF) {
194             buf.append(uint8((major << 5) | 25));
195             buf.appendInt(value, 2);
196         } else if(value <= 0xFFFFFFFF) {
197             buf.append(uint8((major << 5) | 26));
198             buf.appendInt(value, 4);
199         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
200             buf.append(uint8((major << 5) | 27));
201             buf.appendInt(value, 8);
202         }
203     }
204 
205     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
206         buf.append(uint8((major << 5) | 31));
207     }
208 
209     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
210         encodeType(buf, MAJOR_TYPE_INT, value);
211     }
212 
213     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
214         if(value >= 0) {
215             encodeType(buf, MAJOR_TYPE_INT, uint(value));
216         } else {
217             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
218         }
219     }
220 
221     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
222         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
223         buf.append(value);
224     }
225 
226     function encodeString(Buffer.buffer memory buf, string value) internal pure {
227         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
228         buf.append(bytes(value));
229     }
230 
231     function startArray(Buffer.buffer memory buf) internal pure {
232         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
233     }
234 
235     function startMap(Buffer.buffer memory buf) internal pure {
236         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
237     }
238 
239     function endSequence(Buffer.buffer memory buf) internal pure {
240         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
241     }
242 }
243 
244 /*
245 End solidity-cborutils
246  */
247 
248 contract usingOraclize {
249     uint constant day = 60*60*24;
250     uint constant week = 60*60*24*7;
251     uint constant month = 60*60*24*30;
252     byte constant proofType_NONE = 0x00;
253     byte constant proofType_TLSNotary = 0x10;
254     byte constant proofType_Ledger = 0x30;
255     byte constant proofType_Android = 0x40;
256     byte constant proofType_Native = 0xF0;
257     byte constant proofStorage_IPFS = 0x01;
258     uint8 constant networkID_auto = 0;
259     uint8 constant networkID_mainnet = 1;
260     uint8 constant networkID_testnet = 2;
261     uint8 constant networkID_morden = 2;
262     uint8 constant networkID_consensys = 161;
263 
264     OraclizeAddrResolverI OAR;
265 
266     OraclizeI oraclize;
267     modifier oraclizeAPI {
268         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
269             oraclize_setNetwork(networkID_auto);
270 
271         if(address(oraclize) != OAR.getAddress())
272             oraclize = OraclizeI(OAR.getAddress());
273 
274         _;
275     }
276     modifier coupon(string code){
277         oraclize = OraclizeI(OAR.getAddress());
278         _;
279     }
280 
281     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
282       return oraclize_setNetwork();
283       networkID; // silence the warning and remain backwards compatible
284     }
285     function oraclize_setNetwork() internal returns(bool){
286         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
287             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
288             oraclize_setNetworkName("eth_mainnet");
289             return true;
290         }
291         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
292             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
293             oraclize_setNetworkName("eth_ropsten3");
294             return true;
295         }
296         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
297             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
298             oraclize_setNetworkName("eth_kovan");
299             return true;
300         }
301         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
302             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
303             oraclize_setNetworkName("eth_rinkeby");
304             return true;
305         }
306         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
307             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
308             return true;
309         }
310         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
311             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
312             return true;
313         }
314         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
315             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
316             return true;
317         }
318         return false;
319     }
320 
321     function __callback(bytes32 myid, string result) public {
322         __callback(myid, result, new bytes(0));
323     }
324     function __callback(bytes32 myid, string result, bytes proof) public {
325       return;
326       myid; result; proof; // Silence compiler warnings
327     }
328 
329     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
330         return oraclize.getPrice(datasource);
331     }
332 
333     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
334         return oraclize.getPrice(datasource, gaslimit);
335     }
336 
337     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
338         uint price = oraclize.getPrice(datasource);
339         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
340         return oraclize.query.value(price)(0, datasource, arg);
341     }
342     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
343         uint price = oraclize.getPrice(datasource);
344         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
345         return oraclize.query.value(price)(timestamp, datasource, arg);
346     }
347     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
348         uint price = oraclize.getPrice(datasource, gaslimit);
349         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
350         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
351     }
352     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
353         uint price = oraclize.getPrice(datasource, gaslimit);
354         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
355         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
356     }
357     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
358         uint price = oraclize.getPrice(datasource);
359         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
360         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
361     }
362     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
363         uint price = oraclize.getPrice(datasource);
364         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
365         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
366     }
367     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
368         uint price = oraclize.getPrice(datasource, gaslimit);
369         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
370         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
371     }
372     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
373         uint price = oraclize.getPrice(datasource, gaslimit);
374         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
375         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
376     }
377     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
378         uint price = oraclize.getPrice(datasource);
379         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
380         bytes memory args = stra2cbor(argN);
381         return oraclize.queryN.value(price)(0, datasource, args);
382     }
383     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
384         uint price = oraclize.getPrice(datasource);
385         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
386         bytes memory args = stra2cbor(argN);
387         return oraclize.queryN.value(price)(timestamp, datasource, args);
388     }
389     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
390         uint price = oraclize.getPrice(datasource, gaslimit);
391         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
392         bytes memory args = stra2cbor(argN);
393         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
394     }
395     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
396         uint price = oraclize.getPrice(datasource, gaslimit);
397         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
398         bytes memory args = stra2cbor(argN);
399         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
400     }
401     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
402         string[] memory dynargs = new string[](1);
403         dynargs[0] = args[0];
404         return oraclize_query(datasource, dynargs);
405     }
406     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
407         string[] memory dynargs = new string[](1);
408         dynargs[0] = args[0];
409         return oraclize_query(timestamp, datasource, dynargs);
410     }
411     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
412         string[] memory dynargs = new string[](1);
413         dynargs[0] = args[0];
414         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
415     }
416     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
417         string[] memory dynargs = new string[](1);
418         dynargs[0] = args[0];
419         return oraclize_query(datasource, dynargs, gaslimit);
420     }
421 
422     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
423         string[] memory dynargs = new string[](2);
424         dynargs[0] = args[0];
425         dynargs[1] = args[1];
426         return oraclize_query(datasource, dynargs);
427     }
428     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
429         string[] memory dynargs = new string[](2);
430         dynargs[0] = args[0];
431         dynargs[1] = args[1];
432         return oraclize_query(timestamp, datasource, dynargs);
433     }
434     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
435         string[] memory dynargs = new string[](2);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
439     }
440     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441         string[] memory dynargs = new string[](2);
442         dynargs[0] = args[0];
443         dynargs[1] = args[1];
444         return oraclize_query(datasource, dynargs, gaslimit);
445     }
446     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
447         string[] memory dynargs = new string[](3);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         dynargs[2] = args[2];
451         return oraclize_query(datasource, dynargs);
452     }
453     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
454         string[] memory dynargs = new string[](3);
455         dynargs[0] = args[0];
456         dynargs[1] = args[1];
457         dynargs[2] = args[2];
458         return oraclize_query(timestamp, datasource, dynargs);
459     }
460     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
461         string[] memory dynargs = new string[](3);
462         dynargs[0] = args[0];
463         dynargs[1] = args[1];
464         dynargs[2] = args[2];
465         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
466     }
467     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
468         string[] memory dynargs = new string[](3);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         dynargs[2] = args[2];
472         return oraclize_query(datasource, dynargs, gaslimit);
473     }
474 
475     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
476         string[] memory dynargs = new string[](4);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         dynargs[2] = args[2];
480         dynargs[3] = args[3];
481         return oraclize_query(datasource, dynargs);
482     }
483     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
484         string[] memory dynargs = new string[](4);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         dynargs[2] = args[2];
488         dynargs[3] = args[3];
489         return oraclize_query(timestamp, datasource, dynargs);
490     }
491     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
492         string[] memory dynargs = new string[](4);
493         dynargs[0] = args[0];
494         dynargs[1] = args[1];
495         dynargs[2] = args[2];
496         dynargs[3] = args[3];
497         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
498     }
499     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
500         string[] memory dynargs = new string[](4);
501         dynargs[0] = args[0];
502         dynargs[1] = args[1];
503         dynargs[2] = args[2];
504         dynargs[3] = args[3];
505         return oraclize_query(datasource, dynargs, gaslimit);
506     }
507     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
508         string[] memory dynargs = new string[](5);
509         dynargs[0] = args[0];
510         dynargs[1] = args[1];
511         dynargs[2] = args[2];
512         dynargs[3] = args[3];
513         dynargs[4] = args[4];
514         return oraclize_query(datasource, dynargs);
515     }
516     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
517         string[] memory dynargs = new string[](5);
518         dynargs[0] = args[0];
519         dynargs[1] = args[1];
520         dynargs[2] = args[2];
521         dynargs[3] = args[3];
522         dynargs[4] = args[4];
523         return oraclize_query(timestamp, datasource, dynargs);
524     }
525     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
526         string[] memory dynargs = new string[](5);
527         dynargs[0] = args[0];
528         dynargs[1] = args[1];
529         dynargs[2] = args[2];
530         dynargs[3] = args[3];
531         dynargs[4] = args[4];
532         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
533     }
534     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
535         string[] memory dynargs = new string[](5);
536         dynargs[0] = args[0];
537         dynargs[1] = args[1];
538         dynargs[2] = args[2];
539         dynargs[3] = args[3];
540         dynargs[4] = args[4];
541         return oraclize_query(datasource, dynargs, gaslimit);
542     }
543     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
544         uint price = oraclize.getPrice(datasource);
545         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
546         bytes memory args = ba2cbor(argN);
547         return oraclize.queryN.value(price)(0, datasource, args);
548     }
549     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
550         uint price = oraclize.getPrice(datasource);
551         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
552         bytes memory args = ba2cbor(argN);
553         return oraclize.queryN.value(price)(timestamp, datasource, args);
554     }
555     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
556         uint price = oraclize.getPrice(datasource, gaslimit);
557         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
558         bytes memory args = ba2cbor(argN);
559         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
560     }
561     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
562         uint price = oraclize.getPrice(datasource, gaslimit);
563         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
564         bytes memory args = ba2cbor(argN);
565         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
566     }
567     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
568         bytes[] memory dynargs = new bytes[](1);
569         dynargs[0] = args[0];
570         return oraclize_query(datasource, dynargs);
571     }
572     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
573         bytes[] memory dynargs = new bytes[](1);
574         dynargs[0] = args[0];
575         return oraclize_query(timestamp, datasource, dynargs);
576     }
577     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
578         bytes[] memory dynargs = new bytes[](1);
579         dynargs[0] = args[0];
580         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
581     }
582     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
583         bytes[] memory dynargs = new bytes[](1);
584         dynargs[0] = args[0];
585         return oraclize_query(datasource, dynargs, gaslimit);
586     }
587 
588     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
589         bytes[] memory dynargs = new bytes[](2);
590         dynargs[0] = args[0];
591         dynargs[1] = args[1];
592         return oraclize_query(datasource, dynargs);
593     }
594     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
595         bytes[] memory dynargs = new bytes[](2);
596         dynargs[0] = args[0];
597         dynargs[1] = args[1];
598         return oraclize_query(timestamp, datasource, dynargs);
599     }
600     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
601         bytes[] memory dynargs = new bytes[](2);
602         dynargs[0] = args[0];
603         dynargs[1] = args[1];
604         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
605     }
606     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
607         bytes[] memory dynargs = new bytes[](2);
608         dynargs[0] = args[0];
609         dynargs[1] = args[1];
610         return oraclize_query(datasource, dynargs, gaslimit);
611     }
612     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
613         bytes[] memory dynargs = new bytes[](3);
614         dynargs[0] = args[0];
615         dynargs[1] = args[1];
616         dynargs[2] = args[2];
617         return oraclize_query(datasource, dynargs);
618     }
619     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
620         bytes[] memory dynargs = new bytes[](3);
621         dynargs[0] = args[0];
622         dynargs[1] = args[1];
623         dynargs[2] = args[2];
624         return oraclize_query(timestamp, datasource, dynargs);
625     }
626     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
627         bytes[] memory dynargs = new bytes[](3);
628         dynargs[0] = args[0];
629         dynargs[1] = args[1];
630         dynargs[2] = args[2];
631         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
632     }
633     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
634         bytes[] memory dynargs = new bytes[](3);
635         dynargs[0] = args[0];
636         dynargs[1] = args[1];
637         dynargs[2] = args[2];
638         return oraclize_query(datasource, dynargs, gaslimit);
639     }
640 
641     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
642         bytes[] memory dynargs = new bytes[](4);
643         dynargs[0] = args[0];
644         dynargs[1] = args[1];
645         dynargs[2] = args[2];
646         dynargs[3] = args[3];
647         return oraclize_query(datasource, dynargs);
648     }
649     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
650         bytes[] memory dynargs = new bytes[](4);
651         dynargs[0] = args[0];
652         dynargs[1] = args[1];
653         dynargs[2] = args[2];
654         dynargs[3] = args[3];
655         return oraclize_query(timestamp, datasource, dynargs);
656     }
657     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
658         bytes[] memory dynargs = new bytes[](4);
659         dynargs[0] = args[0];
660         dynargs[1] = args[1];
661         dynargs[2] = args[2];
662         dynargs[3] = args[3];
663         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
664     }
665     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
666         bytes[] memory dynargs = new bytes[](4);
667         dynargs[0] = args[0];
668         dynargs[1] = args[1];
669         dynargs[2] = args[2];
670         dynargs[3] = args[3];
671         return oraclize_query(datasource, dynargs, gaslimit);
672     }
673     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
674         bytes[] memory dynargs = new bytes[](5);
675         dynargs[0] = args[0];
676         dynargs[1] = args[1];
677         dynargs[2] = args[2];
678         dynargs[3] = args[3];
679         dynargs[4] = args[4];
680         return oraclize_query(datasource, dynargs);
681     }
682     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
683         bytes[] memory dynargs = new bytes[](5);
684         dynargs[0] = args[0];
685         dynargs[1] = args[1];
686         dynargs[2] = args[2];
687         dynargs[3] = args[3];
688         dynargs[4] = args[4];
689         return oraclize_query(timestamp, datasource, dynargs);
690     }
691     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
692         bytes[] memory dynargs = new bytes[](5);
693         dynargs[0] = args[0];
694         dynargs[1] = args[1];
695         dynargs[2] = args[2];
696         dynargs[3] = args[3];
697         dynargs[4] = args[4];
698         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
699     }
700     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
701         bytes[] memory dynargs = new bytes[](5);
702         dynargs[0] = args[0];
703         dynargs[1] = args[1];
704         dynargs[2] = args[2];
705         dynargs[3] = args[3];
706         dynargs[4] = args[4];
707         return oraclize_query(datasource, dynargs, gaslimit);
708     }
709 
710     function oraclize_cbAddress() oraclizeAPI internal returns (address){
711         return oraclize.cbAddress();
712     }
713     function oraclize_setProof(byte proofP) oraclizeAPI internal {
714         return oraclize.setProofType(proofP);
715     }
716     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
717         return oraclize.setCustomGasPrice(gasPrice);
718     }
719 
720     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
721         return oraclize.randomDS_getSessionPubKeyHash();
722     }
723 
724     function getCodeSize(address _addr) constant internal returns(uint _size) {
725         assembly {
726             _size := extcodesize(_addr)
727         }
728     }
729 
730     function parseAddr(string _a) internal pure returns (address){
731         bytes memory tmp = bytes(_a);
732         uint160 iaddr = 0;
733         uint160 b1;
734         uint160 b2;
735         for (uint i=2; i<2+2*20; i+=2){
736             iaddr *= 256;
737             b1 = uint160(tmp[i]);
738             b2 = uint160(tmp[i+1]);
739             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
740             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
741             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
742             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
743             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
744             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
745             iaddr += (b1*16+b2);
746         }
747         return address(iaddr);
748     }
749 
750     function strCompare(string _a, string _b) internal pure returns (int) {
751         bytes memory a = bytes(_a);
752         bytes memory b = bytes(_b);
753         uint minLength = a.length;
754         if (b.length < minLength) minLength = b.length;
755         for (uint i = 0; i < minLength; i ++)
756             if (a[i] < b[i])
757                 return -1;
758             else if (a[i] > b[i])
759                 return 1;
760         if (a.length < b.length)
761             return -1;
762         else if (a.length > b.length)
763             return 1;
764         else
765             return 0;
766     }
767 
768     function indexOf(string _haystack, string _needle) internal pure returns (int) {
769         bytes memory h = bytes(_haystack);
770         bytes memory n = bytes(_needle);
771         if(h.length < 1 || n.length < 1 || (n.length > h.length))
772             return -1;
773         else if(h.length > (2**128 -1))
774             return -1;
775         else
776         {
777             uint subindex = 0;
778             for (uint i = 0; i < h.length; i ++)
779             {
780                 if (h[i] == n[0])
781                 {
782                     subindex = 1;
783                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
784                     {
785                         subindex++;
786                     }
787                     if(subindex == n.length)
788                         return int(i);
789                 }
790             }
791             return -1;
792         }
793     }
794 
795     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
796         bytes memory _ba = bytes(_a);
797         bytes memory _bb = bytes(_b);
798         bytes memory _bc = bytes(_c);
799         bytes memory _bd = bytes(_d);
800         bytes memory _be = bytes(_e);
801         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
802         bytes memory babcde = bytes(abcde);
803         uint k = 0;
804         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
805         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
806         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
807         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
808         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
809         return string(babcde);
810     }
811 
812     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
813         return strConcat(_a, _b, _c, _d, "");
814     }
815 
816     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
817         return strConcat(_a, _b, _c, "", "");
818     }
819 
820     function strConcat(string _a, string _b) internal pure returns (string) {
821         return strConcat(_a, _b, "", "", "");
822     }
823 
824     // parseInt
825     function parseInt(string _a) internal pure returns (uint) {
826         return parseInt(_a, 0);
827     }
828 
829     // parseInt(parseFloat*10^_b)
830     function parseInt(string _a, uint _b) internal pure returns (uint) {
831         bytes memory bresult = bytes(_a);
832         uint mint = 0;
833         bool decimals = false;
834         for (uint i=0; i<bresult.length; i++){
835             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
836                 if (decimals){
837                    if (_b == 0) break;
838                     else _b--;
839                 }
840                 mint *= 10;
841                 mint += uint(bresult[i]) - 48;
842             } else if (bresult[i] == 46) decimals = true;
843         }
844         if (_b > 0) mint *= 10**_b;
845         return mint;
846     }
847 
848     function uint2str(uint i) internal pure returns (string){
849         if (i == 0) return "0";
850         uint j = i;
851         uint len;
852         while (j != 0){
853             len++;
854             j /= 10;
855         }
856         bytes memory bstr = new bytes(len);
857         uint k = len - 1;
858         while (i != 0){
859             bstr[k--] = byte(48 + i % 10);
860             i /= 10;
861         }
862         return string(bstr);
863     }
864 
865     using CBOR for Buffer.buffer;
866     function stra2cbor(string[] arr) internal pure returns (bytes) {
867         safeMemoryCleaner();
868         Buffer.buffer memory buf;
869         Buffer.init(buf, 1024);
870         buf.startArray();
871         for (uint i = 0; i < arr.length; i++) {
872             buf.encodeString(arr[i]);
873         }
874         buf.endSequence();
875         return buf.buf;
876     }
877 
878     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
879         safeMemoryCleaner();
880         Buffer.buffer memory buf;
881         Buffer.init(buf, 1024);
882         buf.startArray();
883         for (uint i = 0; i < arr.length; i++) {
884             buf.encodeBytes(arr[i]);
885         }
886         buf.endSequence();
887         return buf.buf;
888     }
889 
890     string oraclize_network_name;
891     function oraclize_setNetworkName(string _network_name) internal {
892         oraclize_network_name = _network_name;
893     }
894 
895     function oraclize_getNetworkName() internal view returns (string) {
896         return oraclize_network_name;
897     }
898 
899     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
900         require((_nbytes > 0) && (_nbytes <= 32));
901         // Convert from seconds to ledger timer ticks
902         _delay *= 10;
903         bytes memory nbytes = new bytes(1);
904         nbytes[0] = byte(_nbytes);
905         bytes memory unonce = new bytes(32);
906         bytes memory sessionKeyHash = new bytes(32);
907         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
908         assembly {
909             mstore(unonce, 0x20)
910             // the following variables can be relaxed
911             // check relaxed random contract under ethereum-examples repo
912             // for an idea on how to override and replace comit hash vars
913             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
914             mstore(sessionKeyHash, 0x20)
915             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
916         }
917         bytes memory delay = new bytes(32);
918         assembly {
919             mstore(add(delay, 0x20), _delay)
920         }
921 
922         bytes memory delay_bytes8 = new bytes(8);
923         copyBytes(delay, 24, 8, delay_bytes8, 0);
924 
925         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
926         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
927 
928         bytes memory delay_bytes8_left = new bytes(8);
929 
930         assembly {
931             let x := mload(add(delay_bytes8, 0x20))
932             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
933             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
934             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
935             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
936             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
937             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
938             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
939             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
940 
941         }
942 
943         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
944         return queryId;
945     }
946 
947     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
948         oraclize_randomDS_args[queryId] = commitment;
949     }
950 
951     mapping(bytes32=>bytes32) oraclize_randomDS_args;
952     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
953 
954     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
955         bool sigok;
956         address signer;
957 
958         bytes32 sigr;
959         bytes32 sigs;
960 
961         bytes memory sigr_ = new bytes(32);
962         uint offset = 4+(uint(dersig[3]) - 0x20);
963         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
964         bytes memory sigs_ = new bytes(32);
965         offset += 32 + 2;
966         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
967 
968         assembly {
969             sigr := mload(add(sigr_, 32))
970             sigs := mload(add(sigs_, 32))
971         }
972 
973 
974         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
975         if (address(keccak256(pubkey)) == signer) return true;
976         else {
977             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
978             return (address(keccak256(pubkey)) == signer);
979         }
980     }
981 
982     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
983         bool sigok;
984 
985         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
986         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
987         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
988 
989         bytes memory appkey1_pubkey = new bytes(64);
990         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
991 
992         bytes memory tosign2 = new bytes(1+65+32);
993         tosign2[0] = byte(1); //role
994         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
995         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
996         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
997         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
998 
999         if (sigok == false) return false;
1000 
1001 
1002         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1003         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1004 
1005         bytes memory tosign3 = new bytes(1+65);
1006         tosign3[0] = 0xFE;
1007         copyBytes(proof, 3, 65, tosign3, 1);
1008 
1009         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1010         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1011 
1012         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1013 
1014         return sigok;
1015     }
1016 
1017     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1018         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1019         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1020 
1021         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1022         require(proofVerified);
1023 
1024         _;
1025     }
1026 
1027     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1028         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1029         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1030 
1031         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1032         if (proofVerified == false) return 2;
1033 
1034         return 0;
1035     }
1036 
1037     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1038         bool match_ = true;
1039 
1040         require(prefix.length == n_random_bytes);
1041 
1042         for (uint256 i=0; i< n_random_bytes; i++) {
1043             if (content[i] != prefix[i]) match_ = false;
1044         }
1045 
1046         return match_;
1047     }
1048 
1049     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1050 
1051         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1052         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1053         bytes memory keyhash = new bytes(32);
1054         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1055         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1056 
1057         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1058         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1059 
1060         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1061         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1062 
1063         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1064         // This is to verify that the computed args match with the ones specified in the query.
1065         bytes memory commitmentSlice1 = new bytes(8+1+32);
1066         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1067 
1068         bytes memory sessionPubkey = new bytes(64);
1069         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1070         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1071 
1072         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1073         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1074             delete oraclize_randomDS_args[queryId];
1075         } else return false;
1076 
1077 
1078         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1079         bytes memory tosign1 = new bytes(32+8+1+32);
1080         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1081         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1082 
1083         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1084         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1085             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1086         }
1087 
1088         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1089     }
1090 
1091     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1092     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1093         uint minLength = length + toOffset;
1094 
1095         // Buffer too small
1096         require(to.length >= minLength); // Should be a better way?
1097 
1098         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1099         uint i = 32 + fromOffset;
1100         uint j = 32 + toOffset;
1101 
1102         while (i < (32 + fromOffset + length)) {
1103             assembly {
1104                 let tmp := mload(add(from, i))
1105                 mstore(add(to, j), tmp)
1106             }
1107             i += 32;
1108             j += 32;
1109         }
1110 
1111         return to;
1112     }
1113 
1114     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1115     // Duplicate Solidity's ecrecover, but catching the CALL return value
1116     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1117         // We do our own memory management here. Solidity uses memory offset
1118         // 0x40 to store the current end of memory. We write past it (as
1119         // writes are memory extensions), but don't update the offset so
1120         // Solidity will reuse it. The memory used here is only needed for
1121         // this context.
1122 
1123         // FIXME: inline assembly can't access return values
1124         bool ret;
1125         address addr;
1126 
1127         assembly {
1128             let size := mload(0x40)
1129             mstore(size, hash)
1130             mstore(add(size, 32), v)
1131             mstore(add(size, 64), r)
1132             mstore(add(size, 96), s)
1133 
1134             // NOTE: we can reuse the request memory because we deal with
1135             //       the return code
1136             ret := call(3000, 1, 0, size, 128, size, 32)
1137             addr := mload(size)
1138         }
1139 
1140         return (ret, addr);
1141     }
1142 
1143     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1144     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1145         bytes32 r;
1146         bytes32 s;
1147         uint8 v;
1148 
1149         if (sig.length != 65)
1150           return (false, 0);
1151 
1152         // The signature format is a compact form of:
1153         //   {bytes32 r}{bytes32 s}{uint8 v}
1154         // Compact means, uint8 is not padded to 32 bytes.
1155         assembly {
1156             r := mload(add(sig, 32))
1157             s := mload(add(sig, 64))
1158 
1159             // Here we are loading the last 32 bytes. We exploit the fact that
1160             // 'mload' will pad with zeroes if we overread.
1161             // There is no 'mload8' to do this, but that would be nicer.
1162             v := byte(0, mload(add(sig, 96)))
1163 
1164             // Alternative solution:
1165             // 'byte' is not working due to the Solidity parser, so lets
1166             // use the second best option, 'and'
1167             // v := and(mload(add(sig, 65)), 255)
1168         }
1169 
1170         // albeit non-transactional signatures are not specified by the YP, one would expect it
1171         // to match the YP range of [27, 28]
1172         //
1173         // geth uses [0, 1] and some clients have followed. This might change, see:
1174         //  https://github.com/ethereum/go-ethereum/issues/2053
1175         if (v < 27)
1176           v += 27;
1177 
1178         if (v != 27 && v != 28)
1179             return (false, 0);
1180 
1181         return safer_ecrecover(hash, v, r, s);
1182     }
1183 
1184     function safeMemoryCleaner() internal pure {
1185         assembly {
1186             let fmem := mload(0x40)
1187             codecopy(fmem, codesize, sub(msize, fmem))
1188         }
1189     }
1190 
1191 }
1192 
1193 /**
1194  * @title EthPriceOraclize
1195  * @dev Using oraclize for getting ETH price from coinmarketcap
1196  */
1197 contract EthPriceOraclize is usingOraclize {
1198     uint256 public delay = 43200; // 12 hours
1199     uint256 public ETHUSD;
1200 
1201     event OraclizeCreated(address _oraclize);
1202     event LogInfo(string description);
1203     event LogPriceUpdate(uint256 price);
1204 
1205     function() external payable {
1206         update(1);
1207     }
1208 
1209     function EthPriceOraclize() public {
1210         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1211 
1212         OraclizeCreated(this);
1213         update(1);
1214     }
1215 
1216     function __callback(bytes32 id, string result, bytes proof) public {
1217         require(msg.sender == oraclize_cbAddress());
1218 
1219         ETHUSD = parseInt(result,2);
1220         LogPriceUpdate(ETHUSD);
1221 
1222         update(delay);
1223     }
1224 
1225     function update(uint256 _delay) payable public {
1226         if (oraclize_getPrice("URL") > address(this).balance) {
1227             LogInfo("Oraclize query was NOT sent, please add some ETH to cover for the query fee!");
1228         } else {
1229             LogInfo("Oraclize query was sent, standing by for the answer ...");
1230             oraclize_query(_delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd");
1231         }
1232     }
1233 
1234     function getEthPrice() external view returns(uint256) {
1235         return ETHUSD;
1236     }
1237 }