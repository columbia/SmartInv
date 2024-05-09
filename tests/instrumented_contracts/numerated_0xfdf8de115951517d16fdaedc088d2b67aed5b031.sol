1 pragma solidity 0.4.25;
2 
3 // <ORACLIZE_API>
4     // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
5     /*
6     Copyright (c) 2015-2016 Oraclize SRL
7     Copyright (c) 2016 Oraclize LTD
8 
9 
10 
11     Permission is hereby granted, free of charge, to any person obtaining a copy
12     of this software and associated documentation files (the "Software"), to deal
13     in the Software without restriction, including without limitation the rights
14     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
15     copies of the Software, and to permit persons to whom the Software is
16     furnished to do so, subject to the following conditions:
17 
18 
19 
20     The above copyright notice and this permission notice shall be included in
21     all copies or substantial portions of the Software.
22 
23 
24 
25     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
26     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
27     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
28     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
29     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
30     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
31     THE SOFTWARE.
32     */
33 
34     // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
35 
36     contract OraclizeI {
37         address public cbAddress;
38         function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
39         function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
40         function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
41         function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
42         function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
43         function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
44         function getPrice(string _datasource) public returns (uint _dsprice);
45         function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
46         function setProofType(byte _proofType) external;
47         function setCustomGasPrice(uint _gasPrice) external;
48         function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
49     }
50 
51     contract OraclizeAddrResolverI {
52         function getAddress() public returns (address _addr);
53     }
54 
55     /*
56     Begin solidity-cborutils
57 
58     https://github.com/smartcontractkit/solidity-cborutils
59 
60     MIT License
61 
62     Copyright (c) 2018 SmartContract ChainLink, Ltd.
63 
64     Permission is hereby granted, free of charge, to any person obtaining a copy
65     of this software and associated documentation files (the "Software"), to deal
66     in the Software without restriction, including without limitation the rights
67     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
68     copies of the Software, and to permit persons to whom the Software is
69     furnished to do so, subject to the following conditions:
70 
71     The above copyright notice and this permission notice shall be included in all
72     copies or substantial portions of the Software.
73 
74     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
75     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
76     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
77     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
78     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
79     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
80     SOFTWARE.
81     */
82 
83     library Buffer {
84         struct buffer {
85             bytes buf;
86             uint capacity;
87         }
88 
89         function init(buffer memory buf, uint _capacity) internal pure {
90             uint capacity = _capacity;
91             if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
92             // Allocate space for the buffer data
93             buf.capacity = capacity;
94             assembly {
95                 let ptr := mload(0x40)
96                 mstore(buf, ptr)
97                 mstore(ptr, 0)
98                 mstore(0x40, add(ptr, capacity))
99             }
100         }
101 
102         function resize(buffer memory buf, uint capacity) private pure {
103             bytes memory oldbuf = buf.buf;
104             init(buf, capacity);
105             append(buf, oldbuf);
106         }
107 
108         function max(uint a, uint b) private pure returns(uint) {
109             if(a > b) {
110                 return a;
111             }
112             return b;
113         }
114 
115         /**
116         * @dev Appends a byte array to the end of the buffer. Resizes if doing so
117         *      would exceed the capacity of the buffer.
118         * @param buf The buffer to append to.
119         * @param data The data to append.
120         * @return The original buffer.
121         */
122         function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
123             if(data.length + buf.buf.length > buf.capacity) {
124                 resize(buf, max(buf.capacity, data.length) * 2);
125             }
126 
127             uint dest;
128             uint src;
129             uint len = data.length;
130             assembly {
131                 // Memory address of the buffer data
132                 let bufptr := mload(buf)
133                 // Length of existing buffer data
134                 let buflen := mload(bufptr)
135                 // Start address = buffer address + buffer length + sizeof(buffer length)
136                 dest := add(add(bufptr, buflen), 32)
137                 // Update buffer length
138                 mstore(bufptr, add(buflen, mload(data)))
139                 src := add(data, 32)
140             }
141 
142             // Copy word-length chunks while possible
143             for(; len >= 32; len -= 32) {
144                 assembly {
145                     mstore(dest, mload(src))
146                 }
147                 dest += 32;
148                 src += 32;
149             }
150 
151             // Copy remaining bytes
152             uint mask = 256 ** (32 - len) - 1;
153             assembly {
154                 let srcpart := and(mload(src), not(mask))
155                 let destpart := and(mload(dest), mask)
156                 mstore(dest, or(destpart, srcpart))
157             }
158 
159             return buf;
160         }
161 
162         /**
163         * @dev Appends a byte to the end of the buffer. Resizes if doing so would
164         * exceed the capacity of the buffer.
165         * @param buf The buffer to append to.
166         * @param data The data to append.
167         * @return The original buffer.
168         */
169         function append(buffer memory buf, uint8 data) internal pure {
170             if(buf.buf.length + 1 > buf.capacity) {
171                 resize(buf, buf.capacity * 2);
172             }
173 
174             assembly {
175                 // Memory address of the buffer data
176                 let bufptr := mload(buf)
177                 // Length of existing buffer data
178                 let buflen := mload(bufptr)
179                 // Address = buffer address + buffer length + sizeof(buffer length)
180                 let dest := add(add(bufptr, buflen), 32)
181                 mstore8(dest, data)
182                 // Update buffer length
183                 mstore(bufptr, add(buflen, 1))
184             }
185         }
186 
187         /**
188         * @dev Appends a byte to the end of the buffer. Resizes if doing so would
189         * exceed the capacity of the buffer.
190         * @param buf The buffer to append to.
191         * @param data The data to append.
192         * @return The original buffer.
193         */
194         function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
195             if(len + buf.buf.length > buf.capacity) {
196                 resize(buf, max(buf.capacity, len) * 2);
197             }
198 
199             uint mask = 256 ** len - 1;
200             assembly {
201                 // Memory address of the buffer data
202                 let bufptr := mload(buf)
203                 // Length of existing buffer data
204                 let buflen := mload(bufptr)
205                 // Address = buffer address + buffer length + sizeof(buffer length) + len
206                 let dest := add(add(bufptr, buflen), len)
207                 mstore(dest, or(and(mload(dest), not(mask)), data))
208                 // Update buffer length
209                 mstore(bufptr, add(buflen, len))
210             }
211             return buf;
212         }
213     }
214 
215     library CBOR {
216         using Buffer for Buffer.buffer;
217 
218         uint8 private constant MAJOR_TYPE_INT = 0;
219         uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
220         uint8 private constant MAJOR_TYPE_BYTES = 2;
221         uint8 private constant MAJOR_TYPE_STRING = 3;
222         uint8 private constant MAJOR_TYPE_ARRAY = 4;
223         uint8 private constant MAJOR_TYPE_MAP = 5;
224         uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
225 
226         function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
227             if(value <= 23) {
228                 buf.append(uint8((major << 5) | value));
229             } else if(value <= 0xFF) {
230                 buf.append(uint8((major << 5) | 24));
231                 buf.appendInt(value, 1);
232             } else if(value <= 0xFFFF) {
233                 buf.append(uint8((major << 5) | 25));
234                 buf.appendInt(value, 2);
235             } else if(value <= 0xFFFFFFFF) {
236                 buf.append(uint8((major << 5) | 26));
237                 buf.appendInt(value, 4);
238             } else if(value <= 0xFFFFFFFFFFFFFFFF) {
239                 buf.append(uint8((major << 5) | 27));
240                 buf.appendInt(value, 8);
241             }
242         }
243 
244         function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
245             buf.append(uint8((major << 5) | 31));
246         }
247 
248         function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
249             encodeType(buf, MAJOR_TYPE_INT, value);
250         }
251 
252         function encodeInt(Buffer.buffer memory buf, int value) internal pure {
253             if(value >= 0) {
254                 encodeType(buf, MAJOR_TYPE_INT, uint(value));
255             } else {
256                 encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
257             }
258         }
259 
260         function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
261             encodeType(buf, MAJOR_TYPE_BYTES, value.length);
262             buf.append(value);
263         }
264 
265         function encodeString(Buffer.buffer memory buf, string value) internal pure {
266             encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
267             buf.append(bytes(value));
268         }
269 
270         function startArray(Buffer.buffer memory buf) internal pure {
271             encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
272         }
273 
274         function startMap(Buffer.buffer memory buf) internal pure {
275             encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
276         }
277 
278         function endSequence(Buffer.buffer memory buf) internal pure {
279             encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
280         }
281     }
282 
283     /*
284     End solidity-cborutils
285     */
286 
287     contract usingOraclize {
288         uint constant day = 60*60*24;
289         uint constant week = 60*60*24*7;
290         uint constant month = 60*60*24*30;
291         byte constant proofType_NONE = 0x00;
292         byte constant proofType_TLSNotary = 0x10;
293         byte constant proofType_Ledger = 0x30;
294         byte constant proofType_Android = 0x40;
295         byte constant proofType_Native = 0xF0;
296         byte constant proofStorage_IPFS = 0x01;
297         uint8 constant networkID_auto = 0;
298         uint8 constant networkID_mainnet = 1;
299         uint8 constant networkID_testnet = 2;
300         uint8 constant networkID_morden = 2;
301         uint8 constant networkID_consensys = 161;
302 
303         OraclizeAddrResolverI OAR;
304 
305         OraclizeI oraclize;
306         modifier oraclizeAPI {
307             if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
308                 oraclize_setNetwork(networkID_auto);
309 
310             if(address(oraclize) != OAR.getAddress())
311                 oraclize = OraclizeI(OAR.getAddress());
312 
313             _;
314         }
315         modifier coupon(string code){
316             oraclize = OraclizeI(OAR.getAddress());
317             _;
318         }
319 
320         function oraclize_setNetwork(uint8 networkID) internal returns(bool){
321         return oraclize_setNetwork();
322         networkID; // silence the warning and remain backwards compatible
323         }
324         function oraclize_setNetwork() internal returns(bool){
325             if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
326                 OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
327                 oraclize_setNetworkName("eth_mainnet");
328                 return true;
329             }
330             if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
331                 OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
332                 oraclize_setNetworkName("eth_ropsten3");
333                 return true;
334             }
335             if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
336                 OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
337                 oraclize_setNetworkName("eth_kovan");
338                 return true;
339             }
340             if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
341                 OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
342                 oraclize_setNetworkName("eth_rinkeby");
343                 return true;
344             }
345             if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
346                 OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
347                 return true;
348             }
349             if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
350                 OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
351                 return true;
352             }
353             if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
354                 OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
355                 return true;
356             }
357             return false;
358         }
359 
360         function __callback(bytes32 myid, string result) public {
361             __callback(myid, result, new bytes(0));
362         }
363         function __callback(bytes32 myid, string result, bytes proof) public {
364         return;
365         // Following should never be reached with a preceding return, however
366         // this is just a placeholder function, ideally meant to be defined in
367         // child contract when proofs are used
368         myid; result; proof; // Silence compiler warnings
369         oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view. 
370         }
371 
372         function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
373             return oraclize.getPrice(datasource);
374         }
375 
376         function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
377             return oraclize.getPrice(datasource, gaslimit);
378         }
379 
380         function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
381             uint price = oraclize.getPrice(datasource);
382             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
383             return oraclize.query.value(price)(0, datasource, arg);
384         }
385         function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
386             uint price = oraclize.getPrice(datasource);
387             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
388             return oraclize.query.value(price)(timestamp, datasource, arg);
389         }
390         function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
391             uint price = oraclize.getPrice(datasource, gaslimit);
392             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
393             return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
394         }
395         function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
396             uint price = oraclize.getPrice(datasource, gaslimit);
397             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
398             return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
399         }
400         function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
401             uint price = oraclize.getPrice(datasource);
402             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
403             return oraclize.query2.value(price)(0, datasource, arg1, arg2);
404         }
405         function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
406             uint price = oraclize.getPrice(datasource);
407             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
408             return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
409         }
410         function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
411             uint price = oraclize.getPrice(datasource, gaslimit);
412             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
413             return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
414         }
415         function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
416             uint price = oraclize.getPrice(datasource, gaslimit);
417             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
418             return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
419         }
420         function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
421             uint price = oraclize.getPrice(datasource);
422             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
423             bytes memory args = stra2cbor(argN);
424             return oraclize.queryN.value(price)(0, datasource, args);
425         }
426         function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
427             uint price = oraclize.getPrice(datasource);
428             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
429             bytes memory args = stra2cbor(argN);
430             return oraclize.queryN.value(price)(timestamp, datasource, args);
431         }
432         function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
433             uint price = oraclize.getPrice(datasource, gaslimit);
434             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
435             bytes memory args = stra2cbor(argN);
436             return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
437         }
438         function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
439             uint price = oraclize.getPrice(datasource, gaslimit);
440             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
441             bytes memory args = stra2cbor(argN);
442             return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
443         }
444         function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
445             string[] memory dynargs = new string[](1);
446             dynargs[0] = args[0];
447             return oraclize_query(datasource, dynargs);
448         }
449         function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
450             string[] memory dynargs = new string[](1);
451             dynargs[0] = args[0];
452             return oraclize_query(timestamp, datasource, dynargs);
453         }
454         function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
455             string[] memory dynargs = new string[](1);
456             dynargs[0] = args[0];
457             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
458         }
459         function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
460             string[] memory dynargs = new string[](1);
461             dynargs[0] = args[0];
462             return oraclize_query(datasource, dynargs, gaslimit);
463         }
464 
465         function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
466             string[] memory dynargs = new string[](2);
467             dynargs[0] = args[0];
468             dynargs[1] = args[1];
469             return oraclize_query(datasource, dynargs);
470         }
471         function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
472             string[] memory dynargs = new string[](2);
473             dynargs[0] = args[0];
474             dynargs[1] = args[1];
475             return oraclize_query(timestamp, datasource, dynargs);
476         }
477         function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
478             string[] memory dynargs = new string[](2);
479             dynargs[0] = args[0];
480             dynargs[1] = args[1];
481             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
482         }
483         function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
484             string[] memory dynargs = new string[](2);
485             dynargs[0] = args[0];
486             dynargs[1] = args[1];
487             return oraclize_query(datasource, dynargs, gaslimit);
488         }
489         function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
490             string[] memory dynargs = new string[](3);
491             dynargs[0] = args[0];
492             dynargs[1] = args[1];
493             dynargs[2] = args[2];
494             return oraclize_query(datasource, dynargs);
495         }
496         function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
497             string[] memory dynargs = new string[](3);
498             dynargs[0] = args[0];
499             dynargs[1] = args[1];
500             dynargs[2] = args[2];
501             return oraclize_query(timestamp, datasource, dynargs);
502         }
503         function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
504             string[] memory dynargs = new string[](3);
505             dynargs[0] = args[0];
506             dynargs[1] = args[1];
507             dynargs[2] = args[2];
508             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
509         }
510         function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
511             string[] memory dynargs = new string[](3);
512             dynargs[0] = args[0];
513             dynargs[1] = args[1];
514             dynargs[2] = args[2];
515             return oraclize_query(datasource, dynargs, gaslimit);
516         }
517 
518         function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
519             string[] memory dynargs = new string[](4);
520             dynargs[0] = args[0];
521             dynargs[1] = args[1];
522             dynargs[2] = args[2];
523             dynargs[3] = args[3];
524             return oraclize_query(datasource, dynargs);
525         }
526         function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
527             string[] memory dynargs = new string[](4);
528             dynargs[0] = args[0];
529             dynargs[1] = args[1];
530             dynargs[2] = args[2];
531             dynargs[3] = args[3];
532             return oraclize_query(timestamp, datasource, dynargs);
533         }
534         function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
535             string[] memory dynargs = new string[](4);
536             dynargs[0] = args[0];
537             dynargs[1] = args[1];
538             dynargs[2] = args[2];
539             dynargs[3] = args[3];
540             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
541         }
542         function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
543             string[] memory dynargs = new string[](4);
544             dynargs[0] = args[0];
545             dynargs[1] = args[1];
546             dynargs[2] = args[2];
547             dynargs[3] = args[3];
548             return oraclize_query(datasource, dynargs, gaslimit);
549         }
550         function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
551             string[] memory dynargs = new string[](5);
552             dynargs[0] = args[0];
553             dynargs[1] = args[1];
554             dynargs[2] = args[2];
555             dynargs[3] = args[3];
556             dynargs[4] = args[4];
557             return oraclize_query(datasource, dynargs);
558         }
559         function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
560             string[] memory dynargs = new string[](5);
561             dynargs[0] = args[0];
562             dynargs[1] = args[1];
563             dynargs[2] = args[2];
564             dynargs[3] = args[3];
565             dynargs[4] = args[4];
566             return oraclize_query(timestamp, datasource, dynargs);
567         }
568         function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
569             string[] memory dynargs = new string[](5);
570             dynargs[0] = args[0];
571             dynargs[1] = args[1];
572             dynargs[2] = args[2];
573             dynargs[3] = args[3];
574             dynargs[4] = args[4];
575             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
576         }
577         function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
578             string[] memory dynargs = new string[](5);
579             dynargs[0] = args[0];
580             dynargs[1] = args[1];
581             dynargs[2] = args[2];
582             dynargs[3] = args[3];
583             dynargs[4] = args[4];
584             return oraclize_query(datasource, dynargs, gaslimit);
585         }
586         function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
587             uint price = oraclize.getPrice(datasource);
588             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
589             bytes memory args = ba2cbor(argN);
590             return oraclize.queryN.value(price)(0, datasource, args);
591         }
592         function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
593             uint price = oraclize.getPrice(datasource);
594             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
595             bytes memory args = ba2cbor(argN);
596             return oraclize.queryN.value(price)(timestamp, datasource, args);
597         }
598         function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
599             uint price = oraclize.getPrice(datasource, gaslimit);
600             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
601             bytes memory args = ba2cbor(argN);
602             return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
603         }
604         function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
605             uint price = oraclize.getPrice(datasource, gaslimit);
606             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
607             bytes memory args = ba2cbor(argN);
608             return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
609         }
610         function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
611             bytes[] memory dynargs = new bytes[](1);
612             dynargs[0] = args[0];
613             return oraclize_query(datasource, dynargs);
614         }
615         function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
616             bytes[] memory dynargs = new bytes[](1);
617             dynargs[0] = args[0];
618             return oraclize_query(timestamp, datasource, dynargs);
619         }
620         function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
621             bytes[] memory dynargs = new bytes[](1);
622             dynargs[0] = args[0];
623             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
624         }
625         function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
626             bytes[] memory dynargs = new bytes[](1);
627             dynargs[0] = args[0];
628             return oraclize_query(datasource, dynargs, gaslimit);
629         }
630 
631         function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
632             bytes[] memory dynargs = new bytes[](2);
633             dynargs[0] = args[0];
634             dynargs[1] = args[1];
635             return oraclize_query(datasource, dynargs);
636         }
637         function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
638             bytes[] memory dynargs = new bytes[](2);
639             dynargs[0] = args[0];
640             dynargs[1] = args[1];
641             return oraclize_query(timestamp, datasource, dynargs);
642         }
643         function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
644             bytes[] memory dynargs = new bytes[](2);
645             dynargs[0] = args[0];
646             dynargs[1] = args[1];
647             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
648         }
649         function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
650             bytes[] memory dynargs = new bytes[](2);
651             dynargs[0] = args[0];
652             dynargs[1] = args[1];
653             return oraclize_query(datasource, dynargs, gaslimit);
654         }
655         function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
656             bytes[] memory dynargs = new bytes[](3);
657             dynargs[0] = args[0];
658             dynargs[1] = args[1];
659             dynargs[2] = args[2];
660             return oraclize_query(datasource, dynargs);
661         }
662         function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
663             bytes[] memory dynargs = new bytes[](3);
664             dynargs[0] = args[0];
665             dynargs[1] = args[1];
666             dynargs[2] = args[2];
667             return oraclize_query(timestamp, datasource, dynargs);
668         }
669         function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
670             bytes[] memory dynargs = new bytes[](3);
671             dynargs[0] = args[0];
672             dynargs[1] = args[1];
673             dynargs[2] = args[2];
674             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
675         }
676         function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
677             bytes[] memory dynargs = new bytes[](3);
678             dynargs[0] = args[0];
679             dynargs[1] = args[1];
680             dynargs[2] = args[2];
681             return oraclize_query(datasource, dynargs, gaslimit);
682         }
683 
684         function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
685             bytes[] memory dynargs = new bytes[](4);
686             dynargs[0] = args[0];
687             dynargs[1] = args[1];
688             dynargs[2] = args[2];
689             dynargs[3] = args[3];
690             return oraclize_query(datasource, dynargs);
691         }
692         function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
693             bytes[] memory dynargs = new bytes[](4);
694             dynargs[0] = args[0];
695             dynargs[1] = args[1];
696             dynargs[2] = args[2];
697             dynargs[3] = args[3];
698             return oraclize_query(timestamp, datasource, dynargs);
699         }
700         function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
701             bytes[] memory dynargs = new bytes[](4);
702             dynargs[0] = args[0];
703             dynargs[1] = args[1];
704             dynargs[2] = args[2];
705             dynargs[3] = args[3];
706             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
707         }
708         function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
709             bytes[] memory dynargs = new bytes[](4);
710             dynargs[0] = args[0];
711             dynargs[1] = args[1];
712             dynargs[2] = args[2];
713             dynargs[3] = args[3];
714             return oraclize_query(datasource, dynargs, gaslimit);
715         }
716         function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
717             bytes[] memory dynargs = new bytes[](5);
718             dynargs[0] = args[0];
719             dynargs[1] = args[1];
720             dynargs[2] = args[2];
721             dynargs[3] = args[3];
722             dynargs[4] = args[4];
723             return oraclize_query(datasource, dynargs);
724         }
725         function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
726             bytes[] memory dynargs = new bytes[](5);
727             dynargs[0] = args[0];
728             dynargs[1] = args[1];
729             dynargs[2] = args[2];
730             dynargs[3] = args[3];
731             dynargs[4] = args[4];
732             return oraclize_query(timestamp, datasource, dynargs);
733         }
734         function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
735             bytes[] memory dynargs = new bytes[](5);
736             dynargs[0] = args[0];
737             dynargs[1] = args[1];
738             dynargs[2] = args[2];
739             dynargs[3] = args[3];
740             dynargs[4] = args[4];
741             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
742         }
743         function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
744             bytes[] memory dynargs = new bytes[](5);
745             dynargs[0] = args[0];
746             dynargs[1] = args[1];
747             dynargs[2] = args[2];
748             dynargs[3] = args[3];
749             dynargs[4] = args[4];
750             return oraclize_query(datasource, dynargs, gaslimit);
751         }
752 
753         function oraclize_cbAddress() oraclizeAPI internal returns (address){
754             return oraclize.cbAddress();
755         }
756         function oraclize_setProof(byte proofP) oraclizeAPI internal {
757             return oraclize.setProofType(proofP);
758         }
759         function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
760             return oraclize.setCustomGasPrice(gasPrice);
761         }
762 
763         function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
764             return oraclize.randomDS_getSessionPubKeyHash();
765         }
766 
767         function getCodeSize(address _addr) view internal returns(uint _size) {
768             assembly {
769                 _size := extcodesize(_addr)
770             }
771         }
772 
773         function parseAddr(string _a) internal pure returns (address){
774             bytes memory tmp = bytes(_a);
775             uint160 iaddr = 0;
776             uint160 b1;
777             uint160 b2;
778             for (uint i=2; i<2+2*20; i+=2){
779                 iaddr *= 256;
780                 b1 = uint160(tmp[i]);
781                 b2 = uint160(tmp[i+1]);
782                 if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
783                 else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
784                 else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
785                 if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
786                 else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
787                 else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
788                 iaddr += (b1*16+b2);
789             }
790             return address(iaddr);
791         }
792 
793         function strCompare(string _a, string _b) internal pure returns (int) {
794             bytes memory a = bytes(_a);
795             bytes memory b = bytes(_b);
796             uint minLength = a.length;
797             if (b.length < minLength) minLength = b.length;
798             for (uint i = 0; i < minLength; i ++)
799                 if (a[i] < b[i])
800                     return -1;
801                 else if (a[i] > b[i])
802                     return 1;
803             if (a.length < b.length)
804                 return -1;
805             else if (a.length > b.length)
806                 return 1;
807             else
808                 return 0;
809         }
810 
811         function indexOf(string _haystack, string _needle) internal pure returns (int) {
812             bytes memory h = bytes(_haystack);
813             bytes memory n = bytes(_needle);
814             if(h.length < 1 || n.length < 1 || (n.length > h.length))
815                 return -1;
816             else if(h.length > (2**128 -1))
817                 return -1;
818             else
819             {
820                 uint subindex = 0;
821                 for (uint i = 0; i < h.length; i ++)
822                 {
823                     if (h[i] == n[0])
824                     {
825                         subindex = 1;
826                         while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
827                         {
828                             subindex++;
829                         }
830                         if(subindex == n.length)
831                             return int(i);
832                     }
833                 }
834                 return -1;
835             }
836         }
837 
838         function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
839             bytes memory _ba = bytes(_a);
840             bytes memory _bb = bytes(_b);
841             bytes memory _bc = bytes(_c);
842             bytes memory _bd = bytes(_d);
843             bytes memory _be = bytes(_e);
844             string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
845             bytes memory babcde = bytes(abcde);
846             uint k = 0;
847             for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
848             for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
849             for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
850             for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
851             for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
852             return string(babcde);
853         }
854 
855         function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
856             return strConcat(_a, _b, _c, _d, "");
857         }
858 
859         function strConcat(string _a, string _b, string _c) internal pure returns (string) {
860             return strConcat(_a, _b, _c, "", "");
861         }
862 
863         function strConcat(string _a, string _b) internal pure returns (string) {
864             return strConcat(_a, _b, "", "", "");
865         }
866 
867         // parseInt
868         function parseInt(string _a) internal pure returns (uint) {
869             return parseInt(_a, 0);
870         }
871 
872         // parseInt(parseFloat*10^_b)
873         function parseInt(string _a, uint _b) internal pure returns (uint) {
874             bytes memory bresult = bytes(_a);
875             uint mint = 0;
876             bool decimals = false;
877             for (uint i=0; i<bresult.length; i++){
878                 if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
879                     if (decimals){
880                     if (_b == 0) break;
881                         else _b--;
882                     }
883                     mint *= 10;
884                     mint += uint(bresult[i]) - 48;
885                 } else if (bresult[i] == 46) decimals = true;
886             }
887             if (_b > 0) mint *= 10**_b;
888             return mint;
889         }
890 
891         function uint2str(uint i) internal pure returns (string){
892             if (i == 0) return "0";
893             uint j = i;
894             uint len;
895             while (j != 0){
896                 len++;
897                 j /= 10;
898             }
899             bytes memory bstr = new bytes(len);
900             uint k = len - 1;
901             while (i != 0){
902                 bstr[k--] = byte(48 + i % 10);
903                 i /= 10;
904             }
905             return string(bstr);
906         }
907 
908         using CBOR for Buffer.buffer;
909         function stra2cbor(string[] arr) internal pure returns (bytes) {
910             safeMemoryCleaner();
911             Buffer.buffer memory buf;
912             Buffer.init(buf, 1024);
913             buf.startArray();
914             for (uint i = 0; i < arr.length; i++) {
915                 buf.encodeString(arr[i]);
916             }
917             buf.endSequence();
918             return buf.buf;
919         }
920 
921         function ba2cbor(bytes[] arr) internal pure returns (bytes) {
922             safeMemoryCleaner();
923             Buffer.buffer memory buf;
924             Buffer.init(buf, 1024);
925             buf.startArray();
926             for (uint i = 0; i < arr.length; i++) {
927                 buf.encodeBytes(arr[i]);
928             }
929             buf.endSequence();
930             return buf.buf;
931         }
932 
933         string oraclize_network_name;
934         function oraclize_setNetworkName(string _network_name) internal {
935             oraclize_network_name = _network_name;
936         }
937 
938         function oraclize_getNetworkName() internal view returns (string) {
939             return oraclize_network_name;
940         }
941 
942         function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
943             require((_nbytes > 0) && (_nbytes <= 32));
944             // Convert from seconds to ledger timer ticks
945             _delay *= 10;
946             bytes memory nbytes = new bytes(1);
947             nbytes[0] = byte(_nbytes);
948             bytes memory unonce = new bytes(32);
949             bytes memory sessionKeyHash = new bytes(32);
950             bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
951             assembly {
952                 mstore(unonce, 0x20)
953                 // the following variables can be relaxed
954                 // check relaxed random contract under ethereum-examples repo
955                 // for an idea on how to override and replace comit hash vars
956                 mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
957                 mstore(sessionKeyHash, 0x20)
958                 mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
959             }
960             bytes memory delay = new bytes(32);
961             assembly {
962                 mstore(add(delay, 0x20), _delay)
963             }
964 
965             bytes memory delay_bytes8 = new bytes(8);
966             copyBytes(delay, 24, 8, delay_bytes8, 0);
967 
968             bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
969             bytes32 queryId = oraclize_query("random", args, _customGasLimit);
970 
971             bytes memory delay_bytes8_left = new bytes(8);
972 
973             assembly {
974                 let x := mload(add(delay_bytes8, 0x20))
975                 mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
976                 mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
977                 mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
978                 mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
979                 mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
980                 mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
981                 mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
982                 mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
983 
984             }
985 
986             oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
987             return queryId;
988         }
989 
990         function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
991             oraclize_randomDS_args[queryId] = commitment;
992         }
993 
994         mapping(bytes32=>bytes32) oraclize_randomDS_args;
995         mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
996 
997         function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
998             bool sigok;
999             address signer;
1000 
1001             bytes32 sigr;
1002             bytes32 sigs;
1003 
1004             bytes memory sigr_ = new bytes(32);
1005             uint offset = 4+(uint(dersig[3]) - 0x20);
1006             sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1007             bytes memory sigs_ = new bytes(32);
1008             offset += 32 + 2;
1009             sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1010 
1011             assembly {
1012                 sigr := mload(add(sigr_, 32))
1013                 sigs := mload(add(sigs_, 32))
1014             }
1015 
1016 
1017             (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1018             if (address(keccak256(pubkey)) == signer) return true;
1019             else {
1020                 (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1021                 return (address(keccak256(pubkey)) == signer);
1022             }
1023         }
1024 
1025         function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1026             bool sigok;
1027 
1028             // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1029             bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1030             copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1031 
1032             bytes memory appkey1_pubkey = new bytes(64);
1033             copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1034 
1035             bytes memory tosign2 = new bytes(1+65+32);
1036             tosign2[0] = byte(1); //role
1037             copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1038             bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1039             copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1040             sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1041 
1042             if (sigok == false) return false;
1043 
1044 
1045             // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1046             bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1047 
1048             bytes memory tosign3 = new bytes(1+65);
1049             tosign3[0] = 0xFE;
1050             copyBytes(proof, 3, 65, tosign3, 1);
1051 
1052             bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1053             copyBytes(proof, 3+65, sig3.length, sig3, 0);
1054 
1055             sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1056 
1057             return sigok;
1058         }
1059 
1060         modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1061             // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1062             require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1063 
1064             bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1065             require(proofVerified);
1066 
1067             _;
1068         }
1069 
1070         function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1071             // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1072             if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1073 
1074             bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1075             if (proofVerified == false) return 2;
1076 
1077             return 0;
1078         }
1079 
1080         function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1081             bool match_ = true;
1082 
1083             require(prefix.length == n_random_bytes);
1084 
1085             for (uint256 i=0; i< n_random_bytes; i++) {
1086                 if (content[i] != prefix[i]) match_ = false;
1087             }
1088 
1089             return match_;
1090         }
1091 
1092         function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1093 
1094             // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1095             uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1096             bytes memory keyhash = new bytes(32);
1097             copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1098             if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1099 
1100             bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1101             copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1102 
1103             // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1104             if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1105 
1106             // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1107             // This is to verify that the computed args match with the ones specified in the query.
1108             bytes memory commitmentSlice1 = new bytes(8+1+32);
1109             copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1110 
1111             bytes memory sessionPubkey = new bytes(64);
1112             uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1113             copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1114 
1115             bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1116             if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1117                 delete oraclize_randomDS_args[queryId];
1118             } else return false;
1119 
1120 
1121             // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1122             bytes memory tosign1 = new bytes(32+8+1+32);
1123             copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1124             if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1125 
1126             // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1127             if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1128                 oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1129             }
1130 
1131             return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1132         }
1133 
1134         // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1135         function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1136             uint minLength = length + toOffset;
1137 
1138             // Buffer too small
1139             require(to.length >= minLength); // Should be a better way?
1140 
1141             // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1142             uint i = 32 + fromOffset;
1143             uint j = 32 + toOffset;
1144 
1145             while (i < (32 + fromOffset + length)) {
1146                 assembly {
1147                     let tmp := mload(add(from, i))
1148                     mstore(add(to, j), tmp)
1149                 }
1150                 i += 32;
1151                 j += 32;
1152             }
1153 
1154             return to;
1155         }
1156 
1157         // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1158         // Duplicate Solidity's ecrecover, but catching the CALL return value
1159         function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1160             // We do our own memory management here. Solidity uses memory offset
1161             // 0x40 to store the current end of memory. We write past it (as
1162             // writes are memory extensions), but don't update the offset so
1163             // Solidity will reuse it. The memory used here is only needed for
1164             // this context.
1165 
1166             // FIXME: inline assembly can't access return values
1167             bool ret;
1168             address addr;
1169 
1170             assembly {
1171                 let size := mload(0x40)
1172                 mstore(size, hash)
1173                 mstore(add(size, 32), v)
1174                 mstore(add(size, 64), r)
1175                 mstore(add(size, 96), s)
1176 
1177                 // NOTE: we can reuse the request memory because we deal with
1178                 //       the return code
1179                 ret := call(3000, 1, 0, size, 128, size, 32)
1180                 addr := mload(size)
1181             }
1182 
1183             return (ret, addr);
1184         }
1185 
1186         // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1187         function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1188             bytes32 r;
1189             bytes32 s;
1190             uint8 v;
1191 
1192             if (sig.length != 65)
1193             return (false, 0);
1194 
1195             // The signature format is a compact form of:
1196             //   {bytes32 r}{bytes32 s}{uint8 v}
1197             // Compact means, uint8 is not padded to 32 bytes.
1198             assembly {
1199                 r := mload(add(sig, 32))
1200                 s := mload(add(sig, 64))
1201 
1202                 // Here we are loading the last 32 bytes. We exploit the fact that
1203                 // 'mload' will pad with zeroes if we overread.
1204                 // There is no 'mload8' to do this, but that would be nicer.
1205                 v := byte(0, mload(add(sig, 96)))
1206 
1207                 // Alternative solution:
1208                 // 'byte' is not working due to the Solidity parser, so lets
1209                 // use the second best option, 'and'
1210                 // v := and(mload(add(sig, 65)), 255)
1211             }
1212 
1213             // albeit non-transactional signatures are not specified by the YP, one would expect it
1214             // to match the YP range of [27, 28]
1215             //
1216             // geth uses [0, 1] and some clients have followed. This might change, see:
1217             //  https://github.com/ethereum/go-ethereum/issues/2053
1218             if (v < 27)
1219             v += 27;
1220 
1221             if (v != 27 && v != 28)
1222                 return (false, 0);
1223 
1224             return safer_ecrecover(hash, v, r, s);
1225         }
1226 
1227         function safeMemoryCleaner() internal pure {
1228             assembly {
1229                 let fmem := mload(0x40)
1230                 codecopy(fmem, codesize, sub(msize, fmem))
1231             }
1232         }
1233 
1234     }
1235 // </ORACLIZE_API>
1236 
1237 contract Ownable {
1238     address private _owner;
1239 
1240     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1241 
1242     constructor() internal {
1243         _owner = msg.sender;
1244 
1245         emit OwnershipTransferred(address(0), _owner);
1246     }
1247 
1248     function owner() public view returns(address) {
1249         return _owner;
1250     }
1251 
1252     modifier onlyOwner() {
1253         require(isOwner(), "Access denied");
1254         _;
1255     }
1256 
1257     function isOwner() public view returns(bool) {
1258         return msg.sender == _owner;
1259     }
1260 
1261     function renounceOwnership() public onlyOwner {
1262         emit OwnershipTransferred(_owner, address(0));
1263 
1264         _owner = address(0);
1265     }
1266 
1267     function transferOwnership(address newOwner) public onlyOwner {
1268         _transferOwnership(newOwner);
1269     }
1270 
1271     function _transferOwnership(address newOwner) internal {
1272         require(newOwner != address(0), "Zero address");
1273 
1274         emit OwnershipTransferred(_owner, newOwner);
1275 
1276         _owner = newOwner;
1277     }
1278 }
1279 
1280 contract TossCoin is Ownable, usingOraclize {
1281     struct Game {
1282         address addr;
1283         uint bet;
1284         bool option;
1285     }
1286 
1287     uint public min_bet = 0.05 ether;
1288     uint public max_bet = 2 ether;
1289     uint public rate = 195;
1290     address public ethergames;
1291 
1292     mapping(bytes32 => Game) public games;
1293     mapping(address => address) public refferals;
1294 
1295     event NewGame(bytes32 indexed id);
1296     event FinishGame(bytes32 indexed id, address indexed addr, uint bet, bool option, bool result, uint win);
1297     event Withdraw(address indexed to, uint value);
1298     
1299     constructor() payable public {}
1300 
1301     function() payable external {}
1302     
1303     function __callback(bytes32 id, string res) public {
1304         require(msg.sender == oraclize_cbAddress(), "Permission denied");
1305         require(games[id].bet > 0, "Game not found");
1306 
1307         bool result = parseInt(res) == 1;
1308         uint win = games[id].option == result ? winSize(games[id].bet) : 0;
1309 
1310         emit FinishGame(id, games[id].addr, games[id].bet, games[id].option, result, win);
1311 
1312         if(win > 0) {
1313             games[id].addr.transfer(win);
1314 
1315             if(refferals[games[id].addr] != address(0)) {
1316                 refferals[games[id].addr].transfer(win / 100);
1317             }
1318         }
1319 
1320         if(ethergames != address(0)) {
1321             ethergames.call.value(games[id].bet / 100).gas(45000)();
1322         }
1323 
1324         delete games[id];
1325     }
1326 
1327     function winSize(uint bet) view public returns(uint) {
1328         return bet * rate / 100;
1329     }
1330     
1331     function play(bool option, address refferal) payable external {
1332         require(msg.value >= min_bet && msg.value <= max_bet, "Bet does not match the interval");
1333         require(oraclize_getPrice("URL") + winSize(msg.value) <= address(this).balance, "Insufficient funds");
1334         
1335         bytes32 id = oraclize_query("WolframAlpha", "RandomInteger[{0, 1}]");
1336 
1337         games[id] = Game({
1338             addr: msg.sender,
1339             bet: msg.value,
1340             option: option
1341         });
1342 
1343         if(refferal != address(0) && refferals[msg.sender] == address(0)) {
1344             refferals[msg.sender] = refferal;
1345         }
1346 
1347         emit NewGame(id);
1348     }
1349     
1350     function play(bool option) payable external {
1351         this.play(option, address(0));
1352     }
1353 
1354     function withdraw(address to, uint value) onlyOwner external {
1355         require(to != address(0), "Zero address");
1356         require(address(this).balance >= value, "Insufficient funds");
1357 
1358         to.transfer(value);
1359 
1360         emit Withdraw(to, value);
1361     }
1362 
1363     function setRate(uint value) onlyOwner external {
1364         rate = value;
1365     }
1366 
1367     function setMinBet(uint value) onlyOwner external {
1368         min_bet = value;
1369     }
1370 
1371     function setMaxBet(uint value) onlyOwner external {
1372         max_bet = value;
1373     }
1374 
1375     function setEtherGames(address value) onlyOwner external {
1376         if(ethergames == address(0)) {
1377             ethergames = value;
1378         }
1379     }
1380 }