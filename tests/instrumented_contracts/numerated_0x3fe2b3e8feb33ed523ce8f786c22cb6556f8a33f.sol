1 pragma solidity ^0.4.24;
2 
3 /*
4 
5  /$$      /$$                               /$$$$$$$            /$$ /$$     /$$
6 | $$$    /$$$                              | $$__  $$          | $$| $$    |__/
7 | $$$$  /$$$$  /$$$$$$   /$$$$$$   /$$$$$$ | $$  \ $$  /$$$$$$ | $$| $$     /$$  /$$$$$$
8 | $$ $$/$$ $$ /$$__  $$ /$$__  $$ |____  $$| $$$$$$$  |____  $$| $$| $$    | $$ /$$__  $$
9 | $$  $$$| $$| $$$$$$$$| $$  \ $$  /$$$$$$$| $$__  $$  /$$$$$$$| $$| $$    | $$| $$  \ $$
10 | $$\  $ | $$| $$_____/| $$  | $$ /$$__  $$| $$  \ $$ /$$__  $$| $$| $$    | $$| $$  | $$
11 | $$ \/  | $$|  $$$$$$$|  $$$$$$$|  $$$$$$$| $$$$$$$/|  $$$$$$$| $$| $$ /$$| $$|  $$$$$$/
12 |__/     |__/ \_______/ \____  $$ \_______/|_______/  \_______/|__/|__/|__/|__/ \______/
13                         /$$  \ $$
14                        |  $$$$$$/
15                         \______/
16 
17 
18  [x] Probably Fair
19  [x] Open Source
20  [x] best referral system evar
21  [x] 2 games in 1
22  [x] Better than your mom's lottery, grandma's bingo, or poppop's ponies
23  [x] made with <3.add(hate)
24 
25  Play it!
26 
27  Or don't?
28 
29  Nobody cares.
30 
31 */
32 
33 
34 contract OraclizeI {
35     address public cbAddress;
36     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
37     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
38     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
39     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
40     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
41     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
42     function getPrice(string _datasource) public returns (uint _dsprice);
43     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
44     function setProofType(byte _proofType) external;
45     function setCustomGasPrice(uint _gasPrice) external;
46     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
47 }
48 
49 contract OraclizeAddrResolverI {
50     function getAddress() public returns (address _addr);
51 }
52 
53 /*
54 Begin solidity-cborutils
55 https://github.com/smartcontractkit/solidity-cborutils
56 MIT License
57 Copyright (c) 2018 SmartContract ChainLink, Ltd.
58 Permission is hereby granted, free of charge, to any person obtaining a copy
59 of this software and associated documentation files (the "Software"), to deal
60 in the Software without restriction, including without limitation the rights
61 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
62 copies of the Software, and to permit persons to whom the Software is
63 furnished to do so, subject to the following conditions:
64 The above copyright notice and this permission notice shall be included in all
65 copies or substantial portions of the Software.
66 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
67 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
68 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
69 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
70 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
71 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
72 SOFTWARE.
73  */
74 
75 library Buffer {
76     struct buffer {
77         bytes buf;
78         uint capacity;
79     }
80 
81     function init(buffer memory buf, uint _capacity) internal pure {
82         uint capacity = _capacity;
83         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
84         // Allocate space for the buffer data
85         buf.capacity = capacity;
86         assembly {
87             let ptr := mload(0x40)
88             mstore(buf, ptr)
89             mstore(ptr, 0)
90             mstore(0x40, add(ptr, capacity))
91         }
92     }
93 
94     function resize(buffer memory buf, uint capacity) private pure {
95         bytes memory oldbuf = buf.buf;
96         init(buf, capacity);
97         append(buf, oldbuf);
98     }
99 
100     function max(uint a, uint b) private pure returns(uint) {
101         if(a > b) {
102             return a;
103         }
104         return b;
105     }
106 
107     /**
108      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
109      *      would exceed the capacity of the buffer.
110      * @param buf The buffer to append to.
111      * @param data The data to append.
112      * @return The original buffer.
113      */
114     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
115         if(data.length + buf.buf.length > buf.capacity) {
116             resize(buf, max(buf.capacity, data.length) * 2);
117         }
118 
119         uint dest;
120         uint src;
121         uint len = data.length;
122         assembly {
123             // Memory address of the buffer data
124             let bufptr := mload(buf)
125             // Length of existing buffer data
126             let buflen := mload(bufptr)
127             // Start address = buffer address + buffer length + sizeof(buffer length)
128             dest := add(add(bufptr, buflen), 32)
129             // Update buffer length
130             mstore(bufptr, add(buflen, mload(data)))
131             src := add(data, 32)
132         }
133 
134         // Copy word-length chunks while possible
135         for(; len >= 32; len -= 32) {
136             assembly {
137                 mstore(dest, mload(src))
138             }
139             dest += 32;
140             src += 32;
141         }
142 
143         // Copy remaining bytes
144         uint mask = 256 ** (32 - len) - 1;
145         assembly {
146             let srcpart := and(mload(src), not(mask))
147             let destpart := and(mload(dest), mask)
148             mstore(dest, or(destpart, srcpart))
149         }
150 
151         return buf;
152     }
153 
154     /**
155      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
156      * exceed the capacity of the buffer.
157      * @param buf The buffer to append to.
158      * @param data The data to append.
159      * @return The original buffer.
160      */
161     function append(buffer memory buf, uint8 data) internal pure {
162         if(buf.buf.length + 1 > buf.capacity) {
163             resize(buf, buf.capacity * 2);
164         }
165 
166         assembly {
167             // Memory address of the buffer data
168             let bufptr := mload(buf)
169             // Length of existing buffer data
170             let buflen := mload(bufptr)
171             // Address = buffer address + buffer length + sizeof(buffer length)
172             let dest := add(add(bufptr, buflen), 32)
173             mstore8(dest, data)
174             // Update buffer length
175             mstore(bufptr, add(buflen, 1))
176         }
177     }
178 
179     /**
180      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
181      * exceed the capacity of the buffer.
182      * @param buf The buffer to append to.
183      * @param data The data to append.
184      * @return The original buffer.
185      */
186     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
187         if(len + buf.buf.length > buf.capacity) {
188             resize(buf, max(buf.capacity, len) * 2);
189         }
190 
191         uint mask = 256 ** len - 1;
192         assembly {
193             // Memory address of the buffer data
194             let bufptr := mload(buf)
195             // Length of existing buffer data
196             let buflen := mload(bufptr)
197             // Address = buffer address + buffer length + sizeof(buffer length) + len
198             let dest := add(add(bufptr, buflen), len)
199             mstore(dest, or(and(mload(dest), not(mask)), data))
200             // Update buffer length
201             mstore(bufptr, add(buflen, len))
202         }
203         return buf;
204     }
205 }
206 
207 library CBOR {
208     using Buffer for Buffer.buffer;
209 
210     uint8 private constant MAJOR_TYPE_INT = 0;
211     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
212     uint8 private constant MAJOR_TYPE_BYTES = 2;
213     uint8 private constant MAJOR_TYPE_STRING = 3;
214     uint8 private constant MAJOR_TYPE_ARRAY = 4;
215     uint8 private constant MAJOR_TYPE_MAP = 5;
216     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
217 
218     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
219         if(value <= 23) {
220             buf.append(uint8((major << 5) | value));
221         } else if(value <= 0xFF) {
222             buf.append(uint8((major << 5) | 24));
223             buf.appendInt(value, 1);
224         } else if(value <= 0xFFFF) {
225             buf.append(uint8((major << 5) | 25));
226             buf.appendInt(value, 2);
227         } else if(value <= 0xFFFFFFFF) {
228             buf.append(uint8((major << 5) | 26));
229             buf.appendInt(value, 4);
230         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
231             buf.append(uint8((major << 5) | 27));
232             buf.appendInt(value, 8);
233         }
234     }
235 
236     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
237         buf.append(uint8((major << 5) | 31));
238     }
239 
240     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
241         encodeType(buf, MAJOR_TYPE_INT, value);
242     }
243 
244     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
245         if(value >= 0) {
246             encodeType(buf, MAJOR_TYPE_INT, uint(value));
247         } else {
248             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
249         }
250     }
251 
252     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
253         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
254         buf.append(value);
255     }
256 
257     function encodeString(Buffer.buffer memory buf, string value) internal pure {
258         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
259         buf.append(bytes(value));
260     }
261 
262     function startArray(Buffer.buffer memory buf) internal pure {
263         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
264     }
265 
266     function startMap(Buffer.buffer memory buf) internal pure {
267         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
268     }
269 
270     function endSequence(Buffer.buffer memory buf) internal pure {
271         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
272     }
273 }
274 
275 /*
276 End solidity-cborutils
277  */
278 
279 contract usingOraclize {
280     uint constant day = 60*60*24;
281     uint constant week = 60*60*24*7;
282     uint constant month = 60*60*24*30;
283     byte constant proofType_NONE = 0x00;
284     byte constant proofType_TLSNotary = 0x10;
285     byte constant proofType_Ledger = 0x30;
286     byte constant proofType_Android = 0x40;
287     byte constant proofType_Native = 0xF0;
288     byte constant proofStorage_IPFS = 0x01;
289     uint8 constant networkID_auto = 0;
290     uint8 constant networkID_mainnet = 1;
291     uint8 constant networkID_testnet = 2;
292     uint8 constant networkID_morden = 2;
293     uint8 constant networkID_consensys = 161;
294 
295     OraclizeAddrResolverI OAR;
296 
297     OraclizeI oraclize;
298     modifier oraclizeAPI {
299         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
300             oraclize_setNetwork(networkID_auto);
301 
302         if(address(oraclize) != OAR.getAddress())
303             oraclize = OraclizeI(OAR.getAddress());
304 
305         _;
306     }
307     modifier coupon(string code){
308         oraclize = OraclizeI(OAR.getAddress());
309         _;
310     }
311 
312     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
313       return oraclize_setNetwork();
314       networkID; // silence the warning and remain backwards compatible
315     }
316     function oraclize_setNetwork() internal returns(bool){
317         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
318             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
319             oraclize_setNetworkName("eth_mainnet");
320             return true;
321         }
322         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
323             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
324             oraclize_setNetworkName("eth_ropsten3");
325             return true;
326         }
327         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
328             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
329             oraclize_setNetworkName("eth_kovan");
330             return true;
331         }
332         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
333             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
334             oraclize_setNetworkName("eth_rinkeby");
335             return true;
336         }
337         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
338             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
339             return true;
340         }
341         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
342             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
343             return true;
344         }
345         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
346             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
347             return true;
348         }
349         return false;
350     }
351 
352     function __callback(bytes32 myid, string result) public {
353         __callback(myid, result, new bytes(0));
354     }
355     function __callback(bytes32 myid, string result, bytes proof) public {
356       return;
357       // Following should never be reached with a preceding return, however
358       // this is just a placeholder function, ideally meant to be defined in
359       // child contract when proofs are used
360       myid; result; proof; // Silence compiler warnings
361       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view.
362     }
363 
364     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
365         return oraclize.getPrice(datasource);
366     }
367 
368     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
369         return oraclize.getPrice(datasource, gaslimit);
370     }
371 
372     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
373         uint price = oraclize.getPrice(datasource);
374         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
375         return oraclize.query.value(price)(0, datasource, arg);
376     }
377     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
378         uint price = oraclize.getPrice(datasource);
379         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
380         return oraclize.query.value(price)(timestamp, datasource, arg);
381     }
382     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
383         uint price = oraclize.getPrice(datasource, gaslimit);
384         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
385         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
386     }
387     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
388         uint price = oraclize.getPrice(datasource, gaslimit);
389         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
390         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
391     }
392     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
393         uint price = oraclize.getPrice(datasource);
394         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
395         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
396     }
397     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
398         uint price = oraclize.getPrice(datasource);
399         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
400         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
401     }
402     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
403         uint price = oraclize.getPrice(datasource, gaslimit);
404         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
405         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
406     }
407     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
408         uint price = oraclize.getPrice(datasource, gaslimit);
409         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
410         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
411     }
412     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
413         uint price = oraclize.getPrice(datasource);
414         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
415         bytes memory args = stra2cbor(argN);
416         return oraclize.queryN.value(price)(0, datasource, args);
417     }
418     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
419         uint price = oraclize.getPrice(datasource);
420         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
421         bytes memory args = stra2cbor(argN);
422         return oraclize.queryN.value(price)(timestamp, datasource, args);
423     }
424     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
425         uint price = oraclize.getPrice(datasource, gaslimit);
426         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
427         bytes memory args = stra2cbor(argN);
428         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
429     }
430     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
431         uint price = oraclize.getPrice(datasource, gaslimit);
432         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
433         bytes memory args = stra2cbor(argN);
434         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
435     }
436     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
437         string[] memory dynargs = new string[](1);
438         dynargs[0] = args[0];
439         return oraclize_query(datasource, dynargs);
440     }
441     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
442         string[] memory dynargs = new string[](1);
443         dynargs[0] = args[0];
444         return oraclize_query(timestamp, datasource, dynargs);
445     }
446     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
447         string[] memory dynargs = new string[](1);
448         dynargs[0] = args[0];
449         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
450     }
451     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
452         string[] memory dynargs = new string[](1);
453         dynargs[0] = args[0];
454         return oraclize_query(datasource, dynargs, gaslimit);
455     }
456 
457     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
458         string[] memory dynargs = new string[](2);
459         dynargs[0] = args[0];
460         dynargs[1] = args[1];
461         return oraclize_query(datasource, dynargs);
462     }
463     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
464         string[] memory dynargs = new string[](2);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         return oraclize_query(timestamp, datasource, dynargs);
468     }
469     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
470         string[] memory dynargs = new string[](2);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
474     }
475     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
476         string[] memory dynargs = new string[](2);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         return oraclize_query(datasource, dynargs, gaslimit);
480     }
481     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
482         string[] memory dynargs = new string[](3);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         dynargs[2] = args[2];
486         return oraclize_query(datasource, dynargs);
487     }
488     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
489         string[] memory dynargs = new string[](3);
490         dynargs[0] = args[0];
491         dynargs[1] = args[1];
492         dynargs[2] = args[2];
493         return oraclize_query(timestamp, datasource, dynargs);
494     }
495     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
496         string[] memory dynargs = new string[](3);
497         dynargs[0] = args[0];
498         dynargs[1] = args[1];
499         dynargs[2] = args[2];
500         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
501     }
502     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
503         string[] memory dynargs = new string[](3);
504         dynargs[0] = args[0];
505         dynargs[1] = args[1];
506         dynargs[2] = args[2];
507         return oraclize_query(datasource, dynargs, gaslimit);
508     }
509 
510     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
511         string[] memory dynargs = new string[](4);
512         dynargs[0] = args[0];
513         dynargs[1] = args[1];
514         dynargs[2] = args[2];
515         dynargs[3] = args[3];
516         return oraclize_query(datasource, dynargs);
517     }
518     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
519         string[] memory dynargs = new string[](4);
520         dynargs[0] = args[0];
521         dynargs[1] = args[1];
522         dynargs[2] = args[2];
523         dynargs[3] = args[3];
524         return oraclize_query(timestamp, datasource, dynargs);
525     }
526     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
527         string[] memory dynargs = new string[](4);
528         dynargs[0] = args[0];
529         dynargs[1] = args[1];
530         dynargs[2] = args[2];
531         dynargs[3] = args[3];
532         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
533     }
534     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
535         string[] memory dynargs = new string[](4);
536         dynargs[0] = args[0];
537         dynargs[1] = args[1];
538         dynargs[2] = args[2];
539         dynargs[3] = args[3];
540         return oraclize_query(datasource, dynargs, gaslimit);
541     }
542     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
543         string[] memory dynargs = new string[](5);
544         dynargs[0] = args[0];
545         dynargs[1] = args[1];
546         dynargs[2] = args[2];
547         dynargs[3] = args[3];
548         dynargs[4] = args[4];
549         return oraclize_query(datasource, dynargs);
550     }
551     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
552         string[] memory dynargs = new string[](5);
553         dynargs[0] = args[0];
554         dynargs[1] = args[1];
555         dynargs[2] = args[2];
556         dynargs[3] = args[3];
557         dynargs[4] = args[4];
558         return oraclize_query(timestamp, datasource, dynargs);
559     }
560     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
561         string[] memory dynargs = new string[](5);
562         dynargs[0] = args[0];
563         dynargs[1] = args[1];
564         dynargs[2] = args[2];
565         dynargs[3] = args[3];
566         dynargs[4] = args[4];
567         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
568     }
569     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
570         string[] memory dynargs = new string[](5);
571         dynargs[0] = args[0];
572         dynargs[1] = args[1];
573         dynargs[2] = args[2];
574         dynargs[3] = args[3];
575         dynargs[4] = args[4];
576         return oraclize_query(datasource, dynargs, gaslimit);
577     }
578     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
579         uint price = oraclize.getPrice(datasource);
580         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
581         bytes memory args = ba2cbor(argN);
582         return oraclize.queryN.value(price)(0, datasource, args);
583     }
584     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
585         uint price = oraclize.getPrice(datasource);
586         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
587         bytes memory args = ba2cbor(argN);
588         return oraclize.queryN.value(price)(timestamp, datasource, args);
589     }
590     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
591         uint price = oraclize.getPrice(datasource, gaslimit);
592         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
593         bytes memory args = ba2cbor(argN);
594         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
595     }
596     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
597         uint price = oraclize.getPrice(datasource, gaslimit);
598         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
599         bytes memory args = ba2cbor(argN);
600         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
601     }
602     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
603         bytes[] memory dynargs = new bytes[](1);
604         dynargs[0] = args[0];
605         return oraclize_query(datasource, dynargs);
606     }
607     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
608         bytes[] memory dynargs = new bytes[](1);
609         dynargs[0] = args[0];
610         return oraclize_query(timestamp, datasource, dynargs);
611     }
612     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
613         bytes[] memory dynargs = new bytes[](1);
614         dynargs[0] = args[0];
615         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
616     }
617     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
618         bytes[] memory dynargs = new bytes[](1);
619         dynargs[0] = args[0];
620         return oraclize_query(datasource, dynargs, gaslimit);
621     }
622 
623     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
624         bytes[] memory dynargs = new bytes[](2);
625         dynargs[0] = args[0];
626         dynargs[1] = args[1];
627         return oraclize_query(datasource, dynargs);
628     }
629     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
630         bytes[] memory dynargs = new bytes[](2);
631         dynargs[0] = args[0];
632         dynargs[1] = args[1];
633         return oraclize_query(timestamp, datasource, dynargs);
634     }
635     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
636         bytes[] memory dynargs = new bytes[](2);
637         dynargs[0] = args[0];
638         dynargs[1] = args[1];
639         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
640     }
641     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
642         bytes[] memory dynargs = new bytes[](2);
643         dynargs[0] = args[0];
644         dynargs[1] = args[1];
645         return oraclize_query(datasource, dynargs, gaslimit);
646     }
647     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
648         bytes[] memory dynargs = new bytes[](3);
649         dynargs[0] = args[0];
650         dynargs[1] = args[1];
651         dynargs[2] = args[2];
652         return oraclize_query(datasource, dynargs);
653     }
654     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
655         bytes[] memory dynargs = new bytes[](3);
656         dynargs[0] = args[0];
657         dynargs[1] = args[1];
658         dynargs[2] = args[2];
659         return oraclize_query(timestamp, datasource, dynargs);
660     }
661     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
662         bytes[] memory dynargs = new bytes[](3);
663         dynargs[0] = args[0];
664         dynargs[1] = args[1];
665         dynargs[2] = args[2];
666         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
667     }
668     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
669         bytes[] memory dynargs = new bytes[](3);
670         dynargs[0] = args[0];
671         dynargs[1] = args[1];
672         dynargs[2] = args[2];
673         return oraclize_query(datasource, dynargs, gaslimit);
674     }
675 
676     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
677         bytes[] memory dynargs = new bytes[](4);
678         dynargs[0] = args[0];
679         dynargs[1] = args[1];
680         dynargs[2] = args[2];
681         dynargs[3] = args[3];
682         return oraclize_query(datasource, dynargs);
683     }
684     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
685         bytes[] memory dynargs = new bytes[](4);
686         dynargs[0] = args[0];
687         dynargs[1] = args[1];
688         dynargs[2] = args[2];
689         dynargs[3] = args[3];
690         return oraclize_query(timestamp, datasource, dynargs);
691     }
692     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
693         bytes[] memory dynargs = new bytes[](4);
694         dynargs[0] = args[0];
695         dynargs[1] = args[1];
696         dynargs[2] = args[2];
697         dynargs[3] = args[3];
698         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
699     }
700     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
701         bytes[] memory dynargs = new bytes[](4);
702         dynargs[0] = args[0];
703         dynargs[1] = args[1];
704         dynargs[2] = args[2];
705         dynargs[3] = args[3];
706         return oraclize_query(datasource, dynargs, gaslimit);
707     }
708     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
709         bytes[] memory dynargs = new bytes[](5);
710         dynargs[0] = args[0];
711         dynargs[1] = args[1];
712         dynargs[2] = args[2];
713         dynargs[3] = args[3];
714         dynargs[4] = args[4];
715         return oraclize_query(datasource, dynargs);
716     }
717     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
718         bytes[] memory dynargs = new bytes[](5);
719         dynargs[0] = args[0];
720         dynargs[1] = args[1];
721         dynargs[2] = args[2];
722         dynargs[3] = args[3];
723         dynargs[4] = args[4];
724         return oraclize_query(timestamp, datasource, dynargs);
725     }
726     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
727         bytes[] memory dynargs = new bytes[](5);
728         dynargs[0] = args[0];
729         dynargs[1] = args[1];
730         dynargs[2] = args[2];
731         dynargs[3] = args[3];
732         dynargs[4] = args[4];
733         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
734     }
735     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
736         bytes[] memory dynargs = new bytes[](5);
737         dynargs[0] = args[0];
738         dynargs[1] = args[1];
739         dynargs[2] = args[2];
740         dynargs[3] = args[3];
741         dynargs[4] = args[4];
742         return oraclize_query(datasource, dynargs, gaslimit);
743     }
744 
745     function oraclize_cbAddress() oraclizeAPI internal returns (address){
746         return oraclize.cbAddress();
747     }
748     function oraclize_setProof(byte proofP) oraclizeAPI internal {
749         return oraclize.setProofType(proofP);
750     }
751     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
752         return oraclize.setCustomGasPrice(gasPrice);
753     }
754 
755     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
756         return oraclize.randomDS_getSessionPubKeyHash();
757     }
758 
759     function getCodeSize(address _addr) view internal returns(uint _size) {
760         assembly {
761             _size := extcodesize(_addr)
762         }
763     }
764 
765     function parseAddr(string _a) internal pure returns (address){
766         bytes memory tmp = bytes(_a);
767         uint160 iaddr = 0;
768         uint160 b1;
769         uint160 b2;
770         for (uint i=2; i<2+2*20; i+=2){
771             iaddr *= 256;
772             b1 = uint160(tmp[i]);
773             b2 = uint160(tmp[i+1]);
774             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
775             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
776             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
777             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
778             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
779             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
780             iaddr += (b1*16+b2);
781         }
782         return address(iaddr);
783     }
784 
785     function strCompare(string _a, string _b) internal pure returns (int) {
786         bytes memory a = bytes(_a);
787         bytes memory b = bytes(_b);
788         uint minLength = a.length;
789         if (b.length < minLength) minLength = b.length;
790         for (uint i = 0; i < minLength; i ++)
791             if (a[i] < b[i])
792                 return -1;
793             else if (a[i] > b[i])
794                 return 1;
795         if (a.length < b.length)
796             return -1;
797         else if (a.length > b.length)
798             return 1;
799         else
800             return 0;
801     }
802 
803     function indexOf(string _haystack, string _needle) internal pure returns (int) {
804         bytes memory h = bytes(_haystack);
805         bytes memory n = bytes(_needle);
806         if(h.length < 1 || n.length < 1 || (n.length > h.length))
807             return -1;
808         else if(h.length > (2**128 -1))
809             return -1;
810         else
811         {
812             uint subindex = 0;
813             for (uint i = 0; i < h.length; i ++)
814             {
815                 if (h[i] == n[0])
816                 {
817                     subindex = 1;
818                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
819                     {
820                         subindex++;
821                     }
822                     if(subindex == n.length)
823                         return int(i);
824                 }
825             }
826             return -1;
827         }
828     }
829 
830     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
831         bytes memory _ba = bytes(_a);
832         bytes memory _bb = bytes(_b);
833         bytes memory _bc = bytes(_c);
834         bytes memory _bd = bytes(_d);
835         bytes memory _be = bytes(_e);
836         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
837         bytes memory babcde = bytes(abcde);
838         uint k = 0;
839         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
840         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
841         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
842         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
843         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
844         return string(babcde);
845     }
846 
847     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
848         return strConcat(_a, _b, _c, _d, "");
849     }
850 
851     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
852         return strConcat(_a, _b, _c, "", "");
853     }
854 
855     function strConcat(string _a, string _b) internal pure returns (string) {
856         return strConcat(_a, _b, "", "", "");
857     }
858 
859     // parseInt
860     function parseInt(string _a) internal pure returns (uint) {
861         return parseInt(_a, 0);
862     }
863 
864     // parseInt(parseFloat*10^_b)
865     function parseInt(string _a, uint _b) internal pure returns (uint) {
866         bytes memory bresult = bytes(_a);
867         uint mint = 0;
868         bool decimals = false;
869         for (uint i=0; i<bresult.length; i++){
870             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
871                 if (decimals){
872                    if (_b == 0) break;
873                     else _b--;
874                 }
875                 mint *= 10;
876                 mint += uint(bresult[i]) - 48;
877             } else if (bresult[i] == 46) decimals = true;
878         }
879         if (_b > 0) mint *= 10**_b;
880         return mint;
881     }
882 
883     function uint2str(uint i) internal pure returns (string){
884         if (i == 0) return "0";
885         uint j = i;
886         uint len;
887         while (j != 0){
888             len++;
889             j /= 10;
890         }
891         bytes memory bstr = new bytes(len);
892         uint k = len - 1;
893         while (i != 0){
894             bstr[k--] = byte(48 + i % 10);
895             i /= 10;
896         }
897         return string(bstr);
898     }
899 
900     using CBOR for Buffer.buffer;
901     function stra2cbor(string[] arr) internal pure returns (bytes) {
902         safeMemoryCleaner();
903         Buffer.buffer memory buf;
904         Buffer.init(buf, 1024);
905         buf.startArray();
906         for (uint i = 0; i < arr.length; i++) {
907             buf.encodeString(arr[i]);
908         }
909         buf.endSequence();
910         return buf.buf;
911     }
912 
913     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
914         safeMemoryCleaner();
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
945             // the following variables can be relaxed
946             // check relaxed random contract under ethereum-examples repo
947             // for an idea on how to override and replace comit hash vars
948             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
949             mstore(sessionKeyHash, 0x20)
950             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
951         }
952         bytes memory delay = new bytes(32);
953         assembly {
954             mstore(add(delay, 0x20), _delay)
955         }
956 
957         bytes memory delay_bytes8 = new bytes(8);
958         copyBytes(delay, 24, 8, delay_bytes8, 0);
959 
960         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
961         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
962 
963         bytes memory delay_bytes8_left = new bytes(8);
964 
965         assembly {
966             let x := mload(add(delay_bytes8, 0x20))
967             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
968             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
969             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
970             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
971             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
972             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
973             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
974             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
975 
976         }
977 
978         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
979         return queryId;
980     }
981 
982     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
983         oraclize_randomDS_args[queryId] = commitment;
984     }
985 
986     mapping(bytes32=>bytes32) oraclize_randomDS_args;
987     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
988 
989     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
990         bool sigok;
991         address signer;
992 
993         bytes32 sigr;
994         bytes32 sigs;
995 
996         bytes memory sigr_ = new bytes(32);
997         uint offset = 4+(uint(dersig[3]) - 0x20);
998         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
999         bytes memory sigs_ = new bytes(32);
1000         offset += 32 + 2;
1001         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1002 
1003         assembly {
1004             sigr := mload(add(sigr_, 32))
1005             sigs := mload(add(sigs_, 32))
1006         }
1007 
1008 
1009         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1010         if (address(keccak256(pubkey)) == signer) return true;
1011         else {
1012             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1013             return (address(keccak256(pubkey)) == signer);
1014         }
1015     }
1016 
1017     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1018         bool sigok;
1019 
1020         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1021         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1022         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1023 
1024         bytes memory appkey1_pubkey = new bytes(64);
1025         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1026 
1027         bytes memory tosign2 = new bytes(1+65+32);
1028         tosign2[0] = byte(1); //role
1029         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1030         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1031         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1032         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1033 
1034         if (sigok == false) return false;
1035 
1036 
1037         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1038         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1039 
1040         bytes memory tosign3 = new bytes(1+65);
1041         tosign3[0] = 0xFE;
1042         copyBytes(proof, 3, 65, tosign3, 1);
1043 
1044         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1045         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1046 
1047         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1048 
1049         return sigok;
1050     }
1051 
1052     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1053         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1054         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1055 
1056         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1057         require(proofVerified);
1058 
1059         _;
1060     }
1061 
1062     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1063         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1064         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1065 
1066         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1067         if (proofVerified == false) return 2;
1068 
1069         return 0;
1070     }
1071 
1072     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1073         bool match_ = true;
1074 
1075         require(prefix.length == n_random_bytes);
1076 
1077         for (uint256 i=0; i< n_random_bytes; i++) {
1078             if (content[i] != prefix[i]) match_ = false;
1079         }
1080 
1081         return match_;
1082     }
1083 
1084     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1085 
1086         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1087         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1088         bytes memory keyhash = new bytes(32);
1089         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1090         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1091 
1092         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1093         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1094 
1095         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1096         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1097 
1098         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1099         // This is to verify that the computed args match with the ones specified in the query.
1100         bytes memory commitmentSlice1 = new bytes(8+1+32);
1101         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1102 
1103         bytes memory sessionPubkey = new bytes(64);
1104         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1105         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1106 
1107         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1108         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1109             delete oraclize_randomDS_args[queryId];
1110         } else return false;
1111 
1112 
1113         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1114         bytes memory tosign1 = new bytes(32+8+1+32);
1115         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1116         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1117 
1118         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1119         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1120             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1121         }
1122 
1123         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1124     }
1125 
1126     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1127     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1128         uint minLength = length + toOffset;
1129 
1130         // Buffer too small
1131         require(to.length >= minLength); // Should be a better way?
1132 
1133         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1134         uint i = 32 + fromOffset;
1135         uint j = 32 + toOffset;
1136 
1137         while (i < (32 + fromOffset + length)) {
1138             assembly {
1139                 let tmp := mload(add(from, i))
1140                 mstore(add(to, j), tmp)
1141             }
1142             i += 32;
1143             j += 32;
1144         }
1145 
1146         return to;
1147     }
1148 
1149     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1150     // Duplicate Solidity's ecrecover, but catching the CALL return value
1151     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1152         // We do our own memory management here. Solidity uses memory offset
1153         // 0x40 to store the current end of memory. We write past it (as
1154         // writes are memory extensions), but don't update the offset so
1155         // Solidity will reuse it. The memory used here is only needed for
1156         // this context.
1157 
1158         // FIXME: inline assembly can't access return values
1159         bool ret;
1160         address addr;
1161 
1162         assembly {
1163             let size := mload(0x40)
1164             mstore(size, hash)
1165             mstore(add(size, 32), v)
1166             mstore(add(size, 64), r)
1167             mstore(add(size, 96), s)
1168 
1169             // NOTE: we can reuse the request memory because we deal with
1170             //       the return code
1171             ret := call(3000, 1, 0, size, 128, size, 32)
1172             addr := mload(size)
1173         }
1174 
1175         return (ret, addr);
1176     }
1177 
1178     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1179     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1180         bytes32 r;
1181         bytes32 s;
1182         uint8 v;
1183 
1184         if (sig.length != 65)
1185           return (false, 0);
1186 
1187         // The signature format is a compact form of:
1188         //   {bytes32 r}{bytes32 s}{uint8 v}
1189         // Compact means, uint8 is not padded to 32 bytes.
1190         assembly {
1191             r := mload(add(sig, 32))
1192             s := mload(add(sig, 64))
1193 
1194             // Here we are loading the last 32 bytes. We exploit the fact that
1195             // 'mload' will pad with zeroes if we overread.
1196             // There is no 'mload8' to do this, but that would be nicer.
1197             v := byte(0, mload(add(sig, 96)))
1198 
1199             // Alternative solution:
1200             // 'byte' is not working due to the Solidity parser, so lets
1201             // use the second best option, 'and'
1202             // v := and(mload(add(sig, 65)), 255)
1203         }
1204 
1205         // albeit non-transactional signatures are not specified by the YP, one would expect it
1206         // to match the YP range of [27, 28]
1207         //
1208         // geth uses [0, 1] and some clients have followed. This might change, see:
1209         //  https://github.com/ethereum/go-ethereum/issues/2053
1210         if (v < 27)
1211           v += 27;
1212 
1213         if (v != 27 && v != 28)
1214             return (false, 0);
1215 
1216         return safer_ecrecover(hash, v, r, s);
1217     }
1218 
1219     function safeMemoryCleaner() internal pure {
1220         assembly {
1221             let fmem := mload(0x40)
1222             codecopy(fmem, codesize, sub(msize, fmem))
1223         }
1224     }
1225 
1226 }
1227 
1228 /**
1229  * @title SafeMath v0.1.9
1230  * @dev Math operations with safety checks that throw on error
1231  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1232  * - added sqrt
1233  * - added sq
1234  * - added pwr
1235  * - changed asserts to requires with error log outputs
1236  * - removed div, its useless
1237  */
1238 library SafeMath {
1239 
1240 /**
1241 * @dev Multiplies two numbers, throws on overflow.
1242 */
1243     function mul(uint256 a, uint256 b)
1244         internal
1245         pure
1246         returns (uint256 c)
1247     {
1248         if (a == 0) {
1249             return 0;
1250         }
1251         c = a * b;
1252         require(c / a == b);
1253         return c;
1254     }
1255 
1256     /**
1257     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1258     */
1259     function sub(uint256 a, uint256 b)
1260         internal
1261         pure
1262         returns (uint256)
1263     {
1264         require(b <= a);
1265         return a - b;
1266     }
1267 
1268     /**
1269     * @dev Adds two numbers, throws on overflow.
1270     */
1271     function add(uint256 a, uint256 b)
1272         internal
1273         pure
1274         returns (uint256 c)
1275     {
1276         c = a + b;
1277         require(c >= a);
1278         return c;
1279     }
1280 
1281     /**
1282     * @dev Adds two numbers, throws on overflow.
1283     */
1284     function add2(uint8 a, uint8 b)
1285         internal
1286         pure
1287         returns (uint8 c)
1288     {
1289         c = a + b;
1290         require(c >= a);
1291         return c;
1292     }
1293 
1294 
1295     /**
1296     * @dev Integer division of two numbers, truncating the quotient.
1297     */
1298     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1299         require(b > 0);
1300       // assert(b > 0); // Solidity automatically throws when dividing by 0
1301       // uint256 c = a / b;
1302       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1303         return a / b;
1304     }
1305 
1306     /**
1307     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
1308     * reverts when dividing by zero.
1309     */
1310     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1311         require(b != 0);
1312         return a % b;
1313     }
1314     /**
1315      * @dev gives square root of given x.
1316      */
1317     function sqrt(uint256 x)
1318         internal
1319         pure
1320         returns (uint256 y)
1321     {
1322         uint256 z = ((add(x,1)) / 2);
1323         y = x;
1324         while (z < y)
1325         {
1326             y = z;
1327             z = ((add((x / z),z)) / 2);
1328         }
1329     }
1330 
1331     /**
1332      * @dev gives square. multiplies x by x
1333      */
1334     function sq(uint256 x)
1335         internal
1336         pure
1337         returns (uint256)
1338     {
1339         return (mul(x,x));
1340     }
1341 
1342     /**
1343      * @dev x to the power of y
1344      */
1345     function pwr(uint256 x, uint256 y)
1346         internal
1347         pure
1348         returns (uint256)
1349     {
1350         if (x==0)
1351             return (0);
1352         else if (y==0)
1353             return (1);
1354         else
1355         {
1356             uint256 z = x;
1357             for (uint256 i=1; i < y; i++)
1358                 z = mul(z,x);
1359             return (z);
1360         }
1361     }
1362 }
1363 
1364 
1365 /* solhint-disable var-name-mixedcase */
1366 /* solhint-disable const-name-snakecase */
1367 /* solhint-disable code-complexity */
1368 /* solhint-disable max-line-length */
1369 /* solhint-disable func-name-mixedcase */
1370 
1371 
1372 contract MegaBall is usingOraclize {
1373     using SafeMath for uint;
1374     ReferralInterface constant public referralContract = ReferralInterface(address(0x0bfb5147e4b459200edb21e220a3dc4137d01028));
1375     HourglassInterface constant public p3dContract = HourglassInterface(address(0xb3775fb83f7d12a36e0475abdd1fca35c091efbe));
1376     DiviesInterface constant private Divies = DiviesInterface(address(0xC0c001140319C5f114F8467295b1F22F86929Ad0));
1377 
1378     address constant public NULL_ADDRESS = address(0x000000000000000000000000000000000000000);
1379     /* main game events */
1380     event DrawValid(bool indexed status);
1381     event ReadyToFinalize(bool indexed isFinal);
1382     event TicketCreated(address indexed ticketOwner, address indexed ticketReferral, uint indexed stage);
1383     event StageCreated(uint indexed stageNumber);
1384     /* side game events */
1385     event RaffleWinnerPick(address indexed user, uint amount, uint indexed stage);
1386     event RaffleEntry(address indexed user, uint block);
1387     /* user withdraw event */
1388     event OnWithdraw(address indexed customerAddress, uint256 ethereumWithdrawn);
1389 
1390     /* modifiers */
1391     modifier hasBalance() {
1392         require(moneyballVault[msg.sender] > 0);
1393         _;
1394     }
1395 
1396     modifier onlyActiveStages(uint256 _stage) {
1397         require(_stage == SafeMath.sub(numberOfStages, 1));
1398         _;
1399     }
1400 
1401     modifier onlyAvailableStages(uint256 _stage) {
1402         require(_stage <= SafeMath.sub(numberOfStages, 1));
1403         _;
1404     }
1405 
1406     modifier isValidRedemptionPeriod(uint256 _stage) {
1407         require(stages[_stage].redemptionEnd > now);
1408         _;
1409     }
1410 
1411     /*
1412       each stage has isolated predetermined price allocation
1413     */
1414     struct Payouts {
1415         uint256 NO_MONEYBALL_3_MATCHES;
1416         uint256 NO_MONEYBALL_4_MATCHES;
1417         uint256 NO_MONEYBALL_5_MATCHES;
1418         uint256 MONEYBALL_BASE_MATCHES;
1419         uint256 MONEYBALL_2_MATCHES;
1420         uint256 MONEYBALL_3_MATCHES;
1421         uint256 MONEYBALL_4_MATCHES;
1422         uint256 MONEYBALL_5_MATCHES;
1423     }
1424 
1425     /*
1426       each stage has isolated predetermined fund allocation on ticket purchase
1427       lotteryPortion/rafflePortion are same value can ditch for space
1428     */
1429     struct Splits {
1430         uint256 INCOMING_FUNDS_REFERRAL_SHARE;
1431         uint256 INCOMING_FUNDS_P3D_SHARE;
1432         uint256 INCOMING_FUNDS_LOTTERY_SHARE;
1433         uint256 INCOMING_FUNDS_RAFFLE_SHARE;
1434         uint256 INCOMING_FUNDS_DIVI_PORTION;
1435         uint256 INCOMING_DENOMINATION;
1436     }
1437 
1438     /* tickets are an individual entity */
1439     struct Ticket {
1440         uint8 n1;
1441         uint8 n2;
1442         uint8 n3;
1443         uint8 n4;
1444         uint8 n5;
1445         uint8 pb;
1446         uint8 numMatches;
1447         bool pbMatches;
1448         bool isRedeemed;
1449         bool isValidated;
1450         address owner;
1451     }
1452 
1453     /* Drawblocks represent future blocks in each stage */
1454     struct DrawBlocks {
1455         uint256 blocknumber1;
1456         uint256 blocknumber2;
1457         uint256 blocknumber3;
1458         uint256 blocknumber4;
1459         uint256 blocknumber5;
1460         uint256 blocknumberpb;
1461     }
1462 
1463     /* stages manage drawings, tickets, and peg round denominations */
1464     struct Stage {
1465         bool stageCompleted;
1466         Ticket finalTicket;
1467         DrawBlocks drawBlocks;
1468         bool allowTicketPurchases;
1469         bool readyToFinalize;
1470         bool isDrawFinalized;
1471         uint256 startBlock;
1472         uint256 endBlock;
1473         Payouts stagePayouts;
1474         Splits stageSplits;
1475         uint256 drawDate;
1476         uint256 redemptionEnd;
1477         mapping(address => Ticket[]) playerTickets;
1478     }
1479 
1480     mapping (address => uint256) private moneyballVault;
1481 
1482     /*
1483       fund allocation
1484     */
1485     uint256 public lotteryPortion = 0;
1486     uint256 public rafflePortion = 0;
1487     uint256 public buyP3dFunds = 0;
1488     uint256 public dividendFunds = 0;
1489 
1490     /*
1491       stage tracking and allocation
1492     */
1493     mapping(uint256 => Stage) public stages;
1494     uint256 public numberOfStages = 0;
1495     mapping(uint256 => address[]) public raffleDrawings;
1496 
1497     /* tickets for raffle */
1498     mapping(address => uint256) private playerRaffleTickets;
1499 
1500     uint256 public raffleTicketsPerDraw = 10;
1501     uint256 public raffleTicketsRewardPerBuy = 5;
1502 
1503     /* admin address, init in constructor */
1504     address public owner;
1505 
1506     /* eth to usd */
1507     uint256 public ETH_TO_USD = 0;
1508 
1509     /* starting denomination */
1510     uint256 public DENOMINATION = 7000000000000000;
1511 
1512     /* ticket price never goes below the floor */
1513     uint256 constant public denominationFloor = 10000000000000;
1514     /* ticket price never goes above the ceiling */
1515     uint256 constant public denominationCeiling = 10000000000000000000;
1516 
1517     /* 3 days */
1518     uint256 public drawingTimeOffset = 259200;
1519     uint256 public drawActiveTimestamp;
1520 
1521     /*
1522       active denomination can be update once per stage
1523       rewards sidegame draw tickets to msg.sender
1524       this is used for the next round entry cost to keep it flat
1525       vs the cost of USD and avoid spikes in jackpot value
1526     */
1527     uint256 public denominationUpdateTimeOffset = 0;
1528     uint256 public denominationActiveTimestamp;
1529 
1530     /* may want some direct eth/usd access in future for UI?, not tied into any logic */
1531     string public ethUsdUrl = 'json(https://api.coinmarketcap.com/v1/ticker/ethereum/?convert=USD).0.price_usd';
1532 
1533     constructor() public {
1534         owner = msg.sender;
1535     }
1536 
1537     /*
1538       Game is waiting until owner gives the go ahead
1539     */
1540     function initFirstStage()
1541     public
1542     {
1543         require(msg.sender == owner);
1544         require(numberOfStages == 0);
1545 
1546         denominationUpdateTimeOffset = SafeMath.div(drawingTimeOffset, 2);
1547         drawActiveTimestamp = SafeMath.sub(now, 100);
1548         denominationActiveTimestamp = SafeMath.sub(now, 100);
1549 
1550         CreateStage();
1551     }
1552 
1553     /*
1554       all money sent directly to contract from hourglass goes to side game fund
1555       its expected this will be p3d dividends, otherwise apply
1556       to p3dbuy balance
1557     */
1558     function()
1559     public
1560     payable
1561     {
1562         if (msg.sender != address(p3dContract)) {
1563             buyP3dFunds = buyP3dFunds.add(msg.value);
1564         }
1565     }
1566 
1567     function withdraw()
1568     external
1569     hasBalance
1570     {
1571         uint256 amount = moneyballVault[msg.sender];
1572         moneyballVault[msg.sender] = 0;
1573 
1574         emit OnWithdraw(msg.sender, amount);
1575         msg.sender.transfer(amount);
1576     }
1577 
1578     function __callback(bytes32 myid, string result) public {
1579 
1580         if (msg.sender != oraclize_cbAddress()) revert();
1581         /* not used for any logic */
1582         uint256 LOCAL_ETH_TO_USD = parseInt(result, 0);
1583 
1584     }
1585 
1586     function updateDenomination()
1587     external
1588     {
1589         require(denominationActiveTimestamp < now);
1590         require(numberOfStages > 4);
1591         denominationActiveTimestamp = SafeMath.add(now, denominationUpdateTimeOffset);
1592         uint256 USD_DENOM = calcEntryFee();
1593 
1594         if (USD_DENOM > denominationFloor && USD_DENOM < denominationCeiling) {
1595             DENOMINATION = USD_DENOM;
1596             playerRaffleTickets[msg.sender] = playerRaffleTickets[msg.sender].add(5);
1597         }
1598     }
1599 
1600     function updatePrice() public payable {
1601         require(msg.sender == owner);
1602         if (oraclize_getPrice("URL") < msg.value) {
1603             oraclize_query("URL", ethUsdUrl);
1604         }
1605     }
1606 
1607 
1608     function seedJackpot()
1609     public
1610     payable
1611     {
1612         require(msg.value >= 100000000000000000);
1613         uint256 incomingSplit = SafeMath.div(msg.value, 10);
1614         uint256 fiftyPercent = SafeMath.mul(incomingSplit, 5);
1615         uint256 thirtyPercent = SafeMath.mul(incomingSplit, 3);
1616         uint256 twentyPercent = SafeMath.mul(incomingSplit, 2);
1617         buyP3dFunds = buyP3dFunds.add(fiftyPercent);
1618         rafflePortion = rafflePortion.add(thirtyPercent);
1619         lotteryPortion = lotteryPortion.add(twentyPercent);
1620         buyP3d(msg.sender);
1621     }
1622 
1623     function createTicket(uint256 _stage,
1624     uint8 n1,
1625     uint8 n2,
1626     uint8 n3,
1627     uint8 n4,
1628     uint8 n5,
1629     uint8 pb,
1630     address _referredBy)
1631     external
1632     payable
1633     onlyActiveStages(_stage)
1634     {
1635         /* ensure drawing is open */
1636         require(stages[_stage].allowTicketPurchases);
1637 
1638         /* ensure drawing timestamp has not been surpassed */
1639         //require(now < stages[_stage].drawDate, "beyond draw date");
1640 
1641         /* ensure its proper value for given stage */
1642         require(msg.value == stages[_stage].stageSplits.INCOMING_DENOMINATION);
1643 
1644          /* ensure no matches between block of draws TC-0001 */
1645         require(isDrawValid(n1, n2, n3, n4, n5, pb));
1646 
1647         /* cant ref yourself or NULL */
1648         require(_referredBy != NULL_ADDRESS);
1649         require(_referredBy != msg.sender);
1650 
1651         /*
1652           not registered as referral user, assumed to be;
1653           megaball.io users, 3rd party app/ui/mobile creators,
1654           buy/aquire p3d funds to help secure the game
1655         */
1656 
1657         if (referralContract.isAnOwner(_referredBy) == false) {
1658             /* eth to games */
1659             lotteryPortion = lotteryPortion.add(stages[_stage].stageSplits.INCOMING_FUNDS_LOTTERY_SHARE);
1660             rafflePortion = rafflePortion.add(stages[_stage].stageSplits.INCOMING_FUNDS_RAFFLE_SHARE);
1661             /* eth to referral */
1662             moneyballVault[_referredBy] = moneyballVault[_referredBy].add(stages[_stage].stageSplits.INCOMING_FUNDS_REFERRAL_SHARE);
1663             /* eth to p3d */
1664             buyP3dFunds = buyP3dFunds.add(stages[_stage].stageSplits.INCOMING_FUNDS_P3D_SHARE);
1665             dividendFunds = dividendFunds.add(stages[_stage].stageSplits.INCOMING_FUNDS_DIVI_PORTION);
1666         }
1667 
1668         /*
1669           registered as referral user, contract sends all P3D allocation to DiviesInterface
1670           when user is not in referralContract Interface
1671         */
1672         if (referralContract.isAnOwner(_referredBy) == true) {
1673           /* eth to games */
1674           lotteryPortion = lotteryPortion.add(stages[_stage].stageSplits.INCOMING_FUNDS_LOTTERY_SHARE);
1675           rafflePortion = rafflePortion.add(stages[_stage].stageSplits.INCOMING_FUNDS_RAFFLE_SHARE);
1676           /* eth to referral */
1677           moneyballVault[_referredBy] = moneyballVault[_referredBy].add(stages[_stage].stageSplits.INCOMING_FUNDS_REFERRAL_SHARE);
1678           /* eth to p3d divi */
1679           dividendFunds = dividendFunds.add(stages[_stage].stageSplits.INCOMING_FUNDS_P3D_SHARE);
1680           dividendFunds = dividendFunds.add(stages[_stage].stageSplits.INCOMING_FUNDS_DIVI_PORTION);
1681         }
1682 
1683         /*
1684         require(stages[_stage].allowTicketPurchases, "ticket purchases disabled");
1685         require(now < stages[_stage].drawDate, "beyond draw date");
1686         require(msg.value == stages[_stage].stageSplits.INCOMING_DENOMINATION, "price invalid");
1687         require(isDrawValid(n1, n2, n3, n4, n5, pb), "numbers invalid");
1688         require(_referredBy != NULL_ADDRESS, "referral invalid");
1689         require(_referredBy != msg.sender, "referral invalid");
1690         */
1691 
1692         Ticket memory ticket = Ticket(n1, n2, n3, n4, n5, pb, 0, false, false, false, msg.sender);
1693 
1694         /* push ticket into users stage def */
1695         stages[_stage].playerTickets[msg.sender].push(ticket);
1696 
1697         /* allocate a sidegame entry */
1698         playerRaffleTickets[msg.sender] = playerRaffleTickets[msg.sender].add(raffleTicketsRewardPerBuy);
1699         emit TicketCreated(msg.sender, _referredBy, _stage);
1700     }
1701 
1702     function p3dDividends()
1703     public
1704     view
1705     returns (uint)
1706     {
1707         return p3dContract.myDividends(true);
1708     }
1709 
1710     function p3dBalance()
1711     public
1712     view
1713     returns (uint)
1714     {
1715         return p3dContract.balanceOf(this);
1716     }
1717 
1718     function getDrawBlocknumbers(uint256 _stage)
1719     public
1720     view
1721     onlyAvailableStages(_stage)
1722     returns (uint, uint, uint, uint, uint, uint, uint) {
1723         return (stages[_stage].drawBlocks.blocknumber1,
1724         stages[_stage].drawBlocks.blocknumber2,
1725         stages[_stage].drawBlocks.blocknumber3,
1726         stages[_stage].drawBlocks.blocknumber4,
1727         stages[_stage].drawBlocks.blocknumber5,
1728         stages[_stage].drawBlocks.blocknumberpb,
1729         block.number);
1730     }
1731 
1732     /* use this in tests to check finalize status */
1733     function isFinalizeValid(uint256 _stage)
1734     public
1735     view
1736     onlyAvailableStages(_stage)
1737     returns (bool)
1738     {
1739       /* must be ready to finalize, this is set by setdraw blocks user function */
1740         require(stages[_stage].readyToFinalize);
1741 
1742         //require(stages[_stage].drawBlocks.blocknumberpb < block.number, "blocks must be surpassed");
1743         /* get current stage */
1744         Stage storage stageToFinalize = stages[_stage];
1745 
1746         /* make sure we can get hash of oldest draw */
1747         uint256 blockScope = SafeMath.sub(block.number, stages[_stage].drawBlocks.blocknumberpb);
1748 
1749 
1750         /* get the blockhashes of draw numbers */
1751         uint8 n1 = SafeMath.add2(1, (uint8(blockhash(stageToFinalize.drawBlocks.blocknumber1)) % 68));
1752         uint8 n2 = SafeMath.add2(1, (uint8(blockhash(stageToFinalize.drawBlocks.blocknumber2)) % 68));
1753         uint8 n3 = SafeMath.add2(1, (uint8(blockhash(stageToFinalize.drawBlocks.blocknumber3)) % 68));
1754         uint8 n4 = SafeMath.add2(1, (uint8(blockhash(stageToFinalize.drawBlocks.blocknumber4)) % 68));
1755         uint8 n5 = SafeMath.add2(1, (uint8(blockhash(stageToFinalize.drawBlocks.blocknumber5)) % 68));
1756         uint8 pb = SafeMath.add2(1, (uint8(blockhash(stageToFinalize.drawBlocks.blocknumberpb)) % 25));
1757 
1758         if (isDrawValid(n1, n2, n3, n4, n5, pb) && blockScope < 200) {return true;}
1759 
1760         return false;
1761     }
1762 
1763     /* finalize stage */
1764     function finalizeStage(uint256 _stage)
1765     external
1766     onlyActiveStages(_stage)
1767     {
1768         require(stages[_stage].readyToFinalize);
1769         require(!stages[_stage].isDrawFinalized);
1770         require(stages[_stage].drawBlocks.blocknumberpb < block.number);
1771         require(stages[_stage].drawDate < now);
1772         /*
1773         require(stages[_stage].readyToFinalize, "stage must be rdy to finalize");
1774         require(!stages[_stage].isDrawFinalized, "draw cannot be finalize");
1775         require(stages[_stage].drawBlocks.blocknumberpb < block.number, "blocks must be surpassed");
1776         require(stages[_stage].drawDate < now, "block time condition not met");
1777         */
1778 
1779         Stage storage stageToFinalize = stages[_stage];
1780 
1781         /* get the blockhashes of draw numbers */
1782         uint8 n1 = SafeMath.add2(1, (uint8(blockhash(stageToFinalize.drawBlocks.blocknumber1)) % 68));
1783         uint8 n2 = SafeMath.add2(1, (uint8(blockhash(stageToFinalize.drawBlocks.blocknumber2)) % 68));
1784         uint8 n3 = SafeMath.add2(1, (uint8(blockhash(stageToFinalize.drawBlocks.blocknumber3)) % 68));
1785         uint8 n4 = SafeMath.add2(1, (uint8(blockhash(stageToFinalize.drawBlocks.blocknumber4)) % 68));
1786         uint8 n5 = SafeMath.add2(1, (uint8(blockhash(stageToFinalize.drawBlocks.blocknumber5)) % 68));
1787         uint8 pb = SafeMath.add2(1, (uint8(blockhash(stageToFinalize.drawBlocks.blocknumberpb)) % 25));
1788 
1789         /* max number of blocks before draw resets */
1790         uint256 blockScope = SafeMath.sub(block.number, stages[_stage].drawBlocks.blocknumberpb);
1791 
1792         /* isdrawvalid checks boundries of numbers and ensures n1-n5 dont match */
1793         if (isDrawValid(n1, n2, n3, n4, n5, pb) && blockScope < 200) {
1794             Ticket memory ticket = Ticket(n1, n2, n3, n4, n5, pb, 0, false, false, false, NULL_ADDRESS);
1795 
1796             /* set drawing ticket, set draw final, set stage complete, emit */
1797             stages[_stage].finalTicket = ticket;
1798             stages[_stage].isDrawFinalized = true;
1799             stages[_stage].stageCompleted = true;
1800             stages[_stage].endBlock = block.number;
1801             emit DrawValid(true);
1802 
1803             /* allocate sidegame draws to finalizer */
1804             playerRaffleTickets[msg.sender] = playerRaffleTickets[msg.sender].add(raffleTicketsPerDraw);
1805 
1806             /* do raffle */
1807             uint256 playerCount = raffleDrawings[_stage].length;
1808             doRaffle(_stage, playerCount);
1809 
1810             /* we are gtg for a new stage */
1811             CreateStage();
1812 
1813         } else {
1814             /* reward invalid draws if necessary, low player count could repeatedly invalidate draws */
1815             playerRaffleTickets[msg.sender] = playerRaffleTickets[msg.sender].add(5);
1816 
1817             /* draw in valid, redo it */
1818             emit DrawValid(false);
1819             /* push draw blocks out */
1820             resetDrawBlocks(_stage);
1821         }
1822     }
1823 
1824     /*
1825     *   this can only be called once per round/stage for a reward by users
1826     *   blocks will get reset until a finalstate can be found with different function
1827     */
1828     function setDrawBlocks(uint256 _stage)
1829     external
1830     onlyActiveStages(_stage)
1831     {
1832         /* you can only interact with this function once per stage */
1833         require(stages[_stage].allowTicketPurchases);
1834 
1835         /* Must reach next draw period for stage before advancing  */
1836         require(stages[_stage].drawDate < now);
1837 
1838         /* can only be run manually once for reward */
1839         require(!stages[_stage].readyToFinalize);
1840         emit ReadyToFinalize(true);
1841 
1842         /* commit stage finalize structs */
1843         stages[_stage].allowTicketPurchases = false;
1844         stages[_stage].readyToFinalize = true;
1845         stages[_stage].drawBlocks.blocknumber1 = SafeMath.add(block.number, 11);
1846         stages[_stage].drawBlocks.blocknumber2 = SafeMath.add(block.number, 12);
1847         stages[_stage].drawBlocks.blocknumber3 = SafeMath.add(block.number, 13);
1848         stages[_stage].drawBlocks.blocknumber4 = SafeMath.add(block.number, 14);
1849         stages[_stage].drawBlocks.blocknumber5 = SafeMath.add(block.number, 15);
1850         stages[_stage].drawBlocks.blocknumberpb = SafeMath.add(block.number, 16);
1851 
1852         /* set draw block user gets free draw at sidegame */
1853         playerRaffleTickets[msg.sender] = playerRaffleTickets[msg.sender].add(raffleTicketsPerDraw);
1854     }
1855 
1856     /* get no MB match payouts */
1857     function getPayoutsNMB(uint256 _stage)
1858     public
1859     view
1860     onlyAvailableStages(_stage)
1861     returns (uint, uint, uint) {
1862         return (stages[_stage].stagePayouts.NO_MONEYBALL_3_MATCHES,
1863         stages[_stage].stagePayouts.NO_MONEYBALL_4_MATCHES,
1864         stages[_stage].stagePayouts.NO_MONEYBALL_5_MATCHES);
1865     }
1866 
1867     /* gets MB match payouts */
1868     function getPayoutsMB(uint256 _stage)
1869     public
1870     view
1871     onlyAvailableStages(_stage)
1872     returns (uint, uint, uint, uint, uint) {
1873         return (
1874         stages[_stage].stagePayouts.MONEYBALL_BASE_MATCHES,
1875         stages[_stage].stagePayouts.MONEYBALL_2_MATCHES,
1876         stages[_stage].stagePayouts.MONEYBALL_3_MATCHES,
1877         stages[_stage].stagePayouts.MONEYBALL_4_MATCHES,
1878         stages[_stage].stagePayouts.MONEYBALL_5_MATCHES);
1879     }
1880 
1881     /* get number of players in raffle drawing */
1882     function getRafflePlayerCount(uint256 _stage)
1883     public
1884     view
1885     onlyAvailableStages(_stage)
1886     returns (uint)
1887     {
1888         return raffleDrawings[_stage].length;
1889     }
1890 
1891     /* get stage denom */
1892     function getStageDenomination(uint256 _stage)
1893     public
1894     view
1895     onlyAvailableStages(_stage)
1896     returns (uint)
1897     {
1898         return stages[_stage].stageSplits.INCOMING_DENOMINATION;
1899     }
1900 
1901     /* get stage blocks */
1902     function getStageBlocks(uint256 _stage)
1903     public
1904     view
1905     onlyAvailableStages(_stage)
1906     returns (uint, uint)
1907     {
1908         return (stages[_stage].startBlock, stages[_stage].endBlock);
1909     }
1910 
1911     function checkRedemptionPeriod(uint256 _stage)
1912     public
1913     view
1914     onlyAvailableStages(_stage)
1915     returns (uint, uint, uint)
1916     {
1917         return ( stages[_stage].drawDate, stages[_stage].redemptionEnd, now);
1918     }
1919 
1920     function getStageStatus(uint256 _stage)
1921     public
1922     view
1923     onlyAvailableStages(_stage)
1924     returns (bool, bool, bool, bool)
1925     {
1926         return (stages[_stage].stageCompleted, stages[_stage].readyToFinalize, stages[_stage].isDrawFinalized, stages[_stage].allowTicketPurchases);
1927     }
1928 
1929     /* get tickets for msg sender by stage an ticket position */
1930     function getTicketByPosition(uint256 _stage, uint256 _position)
1931     public
1932     view
1933     onlyAvailableStages(_stage)
1934     returns (uint, uint, uint, uint, uint, uint)
1935     {
1936         return (stages[_stage].playerTickets[msg.sender][_position].n1,
1937         stages[_stage].playerTickets[msg.sender][_position].n2,
1938         stages[_stage].playerTickets[msg.sender][_position].n3,
1939         stages[_stage].playerTickets[msg.sender][_position].n4,
1940         stages[_stage].playerTickets[msg.sender][_position].n5,
1941         stages[_stage].playerTickets[msg.sender][_position].pb);
1942     }
1943 
1944     /* allow ticket lookups, external service can index and search more easily */
1945     function getTicket(uint256 _stage, uint256 _position, address _player)
1946     public
1947     view
1948     returns (uint, uint, uint, uint, uint, uint)
1949     {
1950         require(_stage <= SafeMath.sub(numberOfStages, 1));
1951         return (stages[_stage].playerTickets[_player][_position].n1,
1952         stages[_stage].playerTickets[_player][_position].n2,
1953         stages[_stage].playerTickets[_player][_position].n3,
1954         stages[_stage].playerTickets[_player][_position].n4,
1955         stages[_stage].playerTickets[_player][_position].n5,
1956         stages[_stage].playerTickets[_player][_position].pb);
1957     }
1958 
1959 
1960     /* get drawn ticket for a given stage */
1961     function getDrawnTicket(uint256 _stage)
1962     public
1963     view
1964     returns (uint, uint, uint, uint, uint, uint)
1965     {
1966         require(_stage <= SafeMath.sub(numberOfStages, 1));
1967         return (stages[_stage].finalTicket.n1,
1968         stages[_stage].finalTicket.n2,
1969         stages[_stage].finalTicket.n3,
1970         stages[_stage].finalTicket.n4,
1971         stages[_stage].finalTicket.n5,
1972         stages[_stage].finalTicket.pb);
1973     }
1974 
1975     /* get ticket count for stage for msg.sender */
1976     function getTicketCount(uint256 _stage)
1977     public
1978     view
1979     onlyAvailableStages(_stage)
1980     returns (uint256)
1981     {
1982         return stages[_stage].playerTickets[msg.sender].length;
1983     }
1984 
1985     /* check redeem status */
1986     function isTicketRedeemed(uint256 _stage, uint256 _position)
1987     public
1988     view
1989     onlyAvailableStages(_stage)
1990     returns (bool)
1991     {
1992         return stages[_stage].playerTickets[msg.sender][_position].isRedeemed;
1993     }
1994 
1995     function stageMoveDetail(uint256 _stage)
1996     public
1997     view
1998     onlyAvailableStages(_stage)
1999     returns (uint, uint)
2000     {
2001         uint256 blocks = 0;
2002         uint256 time = 0;
2003 
2004         if (stages[_stage].drawBlocks.blocknumberpb > block.number)
2005         {
2006             blocks = stages[_stage].drawBlocks.blocknumberpb - block.number;
2007             blocks++;
2008         }
2009 
2010         if (stages[_stage].drawDate > now)
2011         {
2012             time = stages[_stage].drawDate - now;
2013             time++;
2014         }
2015 
2016         return ( blocks, time );
2017     }
2018 
2019     /*
2020     *   validate and claim ticket can be run on any ticket
2021     *   its only intended to be run by owner on a winning ticket
2022     *   UI determines this for the user
2023     */
2024     function validateAndClaimTicket(uint256 _stage, uint256 position)
2025     external
2026     isValidRedemptionPeriod(_stage)
2027     onlyAvailableStages(_stage)
2028     {
2029         /* draw for stage must have occured */
2030         require(stages[_stage].isDrawFinalized);
2031 
2032         /* only ticket owner can call this function */
2033         require(stages[_stage].playerTickets[msg.sender][position].owner == msg.sender);
2034 
2035         /* tix not validated */
2036         require(stages[_stage].playerTickets[msg.sender][position].isValidated == false);
2037         /* player is msg.sender */
2038         address player = stages[_stage].playerTickets[msg.sender][position].owner;
2039 
2040         /* allocate count var */
2041         uint8 count = 0;
2042 
2043         /* count matches */
2044         if (checkPlayerN1(_stage, position, player)) {count = SafeMath.add2(count, 1);}
2045         if (checkPlayerN2(_stage, position, player)) {count = SafeMath.add2(count, 1);}
2046         if (checkPlayerN3(_stage, position, player)) {count = SafeMath.add2(count, 1);}
2047         if (checkPlayerN4(_stage, position, player)) {count = SafeMath.add2(count, 1);}
2048         if (checkPlayerN5(_stage, position, player)) {count = SafeMath.add2(count, 1);}
2049 
2050 
2051         /* set ticket match count */
2052         stages[_stage].playerTickets[player][position].numMatches = count;
2053 
2054         /* set ticket pb match bool */
2055         stages[_stage].playerTickets[player][position].pbMatches = cmp(stages[_stage].finalTicket.pb, stages[_stage].playerTickets[player][position].pb);
2056         /* ticket has been validated */
2057         stages[_stage].playerTickets[player][position].isValidated = true;
2058         /* pay the ticket */
2059         redeemTicket(_stage, position, player);
2060     }
2061 
2062     /*
2063     *  balance functions
2064     *  players main game balance
2065     */
2066     function getMoneyballBalance() public view returns (uint) {
2067         return moneyballVault[msg.sender];
2068     }
2069 
2070     /* contract balance */
2071     function getContractBalance() public view returns (uint) {
2072         return address(this).balance;
2073     }
2074 
2075 
2076     /* check number validity, also used in truffle numbercheck tests */
2077     function isDrawValid(uint8 _n1, uint8 _n2, uint8 _n3, uint8 _n4, uint8 _n5, uint8 _pb)
2078     public
2079     pure
2080     returns (bool) {
2081         /* n1 */
2082         if (checkNumbers(_n1, _n2)) {return false;}
2083         if (checkNumbers(_n1, _n3)) {return false;}
2084         if (checkNumbers(_n1, _n4)) {return false;}
2085         if (checkNumbers(_n1, _n5)) {return false;}
2086         /* n2 */
2087         if (checkNumbers(_n2, _n3)) {return false;}
2088         if (checkNumbers(_n2, _n4)) {return false;}
2089         if (checkNumbers(_n2, _n5)) {return false;}
2090         /* n3 */
2091         if (checkNumbers(_n3, _n4)) {return false;}
2092         if (checkNumbers(_n3, _n5)) {return false;}
2093         /* n4 */
2094         if (checkNumbers(_n4, _n5)) {return false;}
2095 
2096         return isSubmittedNumberWithinBounds(_n1, _n2, _n3, _n4, _n5, _pb);
2097     }
2098 
2099     function addPlayerToRaffle(address _player) external {
2100       /* you can only interact with active stage */
2101         uint256 stage = numberOfStages.sub(1);
2102         require(playerRaffleTickets[msg.sender] >= raffleTicketsPerDraw);
2103         require(stages[stage].allowTicketPurchases);
2104         require(raffleDrawings[stage].length < 20000000000);
2105         playerRaffleTickets[msg.sender] = playerRaffleTickets[msg.sender].sub(raffleTicketsPerDraw);
2106         raffleDrawings[stage].push(NULL_ADDRESS);
2107         raffleDrawings[stage].push(_player);
2108         raffleDrawings[stage].push(NULL_ADDRESS);
2109         emit RaffleEntry(msg.sender, block.number);
2110     }
2111 
2112     /* ditchable for default  public version */
2113     /* gets number of tickets user has, tickets are used to create reward/side draws */
2114     function getPlayerRaffleTickets() public view returns (uint) {
2115         return playerRaffleTickets[msg.sender];
2116     }
2117 
2118     /* check if numbers same */
2119     function checkNumbers(uint8 _n1, uint8 _n2)
2120     private
2121     pure
2122     returns (bool)
2123     {
2124         if (_n1 == _n2) {return true;}
2125         return false;
2126     }
2127 
2128     /* entry fee is based on oraclize getPrice for URL */
2129     function basePrice() private view returns (uint) {
2130         uint256 price = oraclize_getPrice("URL");
2131         return price;
2132     }
2133 
2134     /* make entry be slightly random, this is protected by denom floor and ceiling */
2135     function calcEntryFee() private view returns (uint) {
2136         uint256 modBase = SafeMath.add(3, (uint8(blockhash(block.number - 1)) % 3));
2137         uint256 price = SafeMath.mul(basePrice(), modBase);
2138         return price;
2139     }
2140 
2141     /*
2142      this function is used for other things name it better
2143     */
2144     function calculatePayoutDenomination(uint256 _denomination, uint256 _multiple)
2145     private
2146     pure
2147     returns (uint256)
2148     {
2149         return SafeMath.mul(_denomination, _multiple);
2150     }
2151 
2152     /* 1% split of denomination */
2153     function calculateOnePercentTicketCostSplit(uint256 _denomination)
2154     private
2155     pure
2156     returns (uint256)
2157     {
2158         return SafeMath.div(_denomination, 100);
2159     }
2160 
2161     /*
2162       Game buys p3d at stage creation, if money available
2163     */
2164     function buyP3d(address player)
2165     private
2166     {
2167         uint256 funds = buyP3dFunds;
2168         if (funds > 0) {
2169             p3dContract.buy.value(funds)(player);
2170             buyP3dFunds = 0;
2171         }
2172 
2173         uint256 lsend = dividendFunds;
2174 
2175         if (lsend > 0) {
2176             dividendFunds = 0;
2177             Divies.deposit.value(lsend)();
2178         }
2179     }
2180 
2181     /*
2182       withdraws dividends and allocates to sidegame, if divs available
2183     */
2184     function withdrawP3dDividends()
2185     private
2186     {
2187         uint256 dividends = p3dContract.myDividends(true);
2188         if (dividends > 0) {
2189             p3dContract.withdraw();
2190             rafflePortion = rafflePortion.add(dividends);
2191         }
2192     }
2193 
2194     /*
2195       create stage generates a new stage w/ new round denominations
2196     */
2197     function CreateStage()
2198     private
2199     {
2200         /* Must reach original draw period before creating new stage */
2201         require(drawActiveTimestamp < now);
2202 
2203         /* reinit the draw offset to prevent new stage spam */
2204         drawActiveTimestamp = SafeMath.add(now, drawingTimeOffset);
2205 
2206         Ticket memory ticket = Ticket(0, 0, 0, 0, 0, 0, 0, false, false, false, NULL_ADDRESS);
2207         Payouts memory stagePayouts = Payouts(
2208         calculatePayoutDenomination(DENOMINATION, 4),
2209         calculatePayoutDenomination(DENOMINATION, 50),
2210         calculatePayoutDenomination(DENOMINATION, 500000),
2211         calculatePayoutDenomination(DENOMINATION, 2),
2212         calculatePayoutDenomination(DENOMINATION, 4),
2213         calculatePayoutDenomination(DENOMINATION, 50),
2214         calculatePayoutDenomination(DENOMINATION, 25000),
2215         calculatePayoutDenomination(DENOMINATION, 1));
2216 
2217         /* get 1% split based on current DENOMINATION */
2218         uint256 ONE_PERCENT = calculateOnePercentTicketCostSplit(DENOMINATION);
2219         uint256 JACKPOT_PORTION = calculatePayoutDenomination(ONE_PERCENT, 45);
2220         uint256 SIDEGAME_PORTION = calculatePayoutDenomination(ONE_PERCENT, 45);
2221         uint256 REFERRAL_PORTION = calculatePayoutDenomination(ONE_PERCENT, 6);
2222         uint256 CREATOR_PORTION = calculatePayoutDenomination(ONE_PERCENT, 2);
2223         uint256 P3D_PORTION = calculatePayoutDenomination(ONE_PERCENT, 2);
2224 
2225         Splits memory stageSplits = Splits(REFERRAL_PORTION,
2226         P3D_PORTION,
2227         JACKPOT_PORTION,
2228         SIDEGAME_PORTION,
2229         CREATOR_PORTION,
2230         DENOMINATION);
2231 
2232         DrawBlocks memory drawBlocks = DrawBlocks(0, 0, 0, 0, 0, 0);
2233 
2234         uint256 blockStart = SafeMath.add(block.number, 10);
2235 
2236         uint256 redemptionGracePeriod = SafeMath.mul(drawingTimeOffset, 5);
2237         redemptionGracePeriod = redemptionGracePeriod.add(drawActiveTimestamp);
2238 
2239         stages[numberOfStages] = Stage(false,
2240         ticket,
2241         drawBlocks,
2242         true,
2243         false,
2244         false,
2245         blockStart,
2246         0,
2247         stagePayouts,
2248         stageSplits,
2249         drawActiveTimestamp,
2250         redemptionGracePeriod);
2251 
2252         if (numberOfStages >= 1) {
2253             buyP3d(owner);
2254             withdrawP3dDividends();
2255             denominationActiveTimestamp = SafeMath.add(now, denominationUpdateTimeOffset);
2256         }
2257 
2258         numberOfStages = numberOfStages.add(1);
2259 
2260         emit StageCreated(numberOfStages);
2261 
2262 
2263         if (numberOfStages >= 4) {
2264             raffleTicketsRewardPerBuy = 1;
2265         }
2266     }
2267 
2268     /* called by finalize stage when invalid draw occurs */
2269     function resetDrawBlocks(uint256 _stage)
2270     private
2271     {
2272         emit ReadyToFinalize(true);
2273         /*
2274         *  on draws we have number collisions reset stage draw timer
2275         *  minimum of 5 minutes, blocknumbers can also block finalizestage
2276         */
2277         drawActiveTimestamp = SafeMath.add(drawActiveTimestamp, 300);
2278         stages[_stage].drawDate = drawActiveTimestamp;
2279 
2280         stages[_stage].drawBlocks.blocknumber1 = SafeMath.add(block.number, 11);
2281         stages[_stage].drawBlocks.blocknumber2 = SafeMath.add(block.number, 12);
2282         stages[_stage].drawBlocks.blocknumber3 = SafeMath.add(block.number, 13);
2283         stages[_stage].drawBlocks.blocknumber4 = SafeMath.add(block.number, 14);
2284         stages[_stage].drawBlocks.blocknumber5 = SafeMath.add(block.number, 15);
2285         stages[_stage].drawBlocks.blocknumberpb = SafeMath.add(block.number, 16);
2286     }
2287 
2288     /*
2289     * do raffle is called in finalizeStage when a valid draw status has
2290     * been found
2291     */
2292     function doRaffle(uint256 _stage, uint256 rafflePlayerCount)
2293     private
2294     {
2295         if (rafflePlayerCount > 6) {
2296             Stage storage stageToFinalize = stages[_stage];
2297             uint256 sideGameFunds = rafflePortion;
2298             uint256 sideGameFundWinSharePercentTwentyFive = SafeMath.div(sideGameFunds, 4);
2299             uint256 sideGameFundWinSharePercentTen = SafeMath.div(sideGameFunds, 10);
2300             uint256 sideGameFundWinSharePercentFive = SafeMath.div(sideGameFunds, 20);
2301             uint256 sideGameFundWinSharePercentOne = SafeMath.div(sideGameFunds, 100);
2302 
2303             /*
2304             fucntion was more readable like this
2305             address raffleOneWinner = raffleDrawings[_stage][(uint256(blockhash(stageToFinalize.drawBlocks.blocknumberpb)) % rafflePlayerCount)];
2306             payRafflePlayer(raffleOneWinner, sideGameFundWinSharePercentTwentyFive);
2307 
2308             changed to get around stack depth issues
2309 
2310             */
2311 
2312             payRafflePlayer(address(raffleDrawings[_stage][(uint256(blockhash(stageToFinalize.drawBlocks.blocknumberpb)) % rafflePlayerCount)]), sideGameFundWinSharePercentTwentyFive, _stage);
2313             payRafflePlayer(address(raffleDrawings[_stage][(uint256(blockhash(stageToFinalize.drawBlocks.blocknumber5)) % rafflePlayerCount)]), sideGameFundWinSharePercentTen, _stage);
2314             payRafflePlayer(address(raffleDrawings[_stage][(uint256(blockhash(stageToFinalize.drawBlocks.blocknumber4)) % rafflePlayerCount)]), sideGameFundWinSharePercentFive, _stage);
2315             payRafflePlayer(address(raffleDrawings[_stage][(uint256(blockhash(stageToFinalize.drawBlocks.blocknumber3)) % rafflePlayerCount)]), sideGameFundWinSharePercentFive, _stage);
2316             payRafflePlayer(address(raffleDrawings[_stage][(uint256(blockhash(stageToFinalize.drawBlocks.blocknumber2)) % rafflePlayerCount)]), sideGameFundWinSharePercentOne, _stage);
2317 
2318             /* give away some of the main pot too */
2319             uint256 jackpotFunds = lotteryPortion;
2320             uint256 jackpotFundsTenPercent = SafeMath.div(jackpotFunds, 10);
2321             payMainRafflePlayer(address(raffleDrawings[_stage][(uint256(blockhash(stageToFinalize.drawBlocks.blocknumber1)) % rafflePlayerCount)]), jackpotFundsTenPercent, _stage);
2322         }
2323     }
2324 
2325     function payRafflePlayer(address _player, uint256 _amount, uint256 _stage)
2326     private
2327     {
2328         require(rafflePortion > _amount);
2329         emit RaffleWinnerPick(_player, _amount, _stage);
2330         /* we only pay real non NULL_ADDRESS address */
2331         if (_player != NULL_ADDRESS) {
2332             rafflePortion = rafflePortion.sub(_amount);
2333             moneyballVault[_player] = moneyballVault[_player].add(_amount);
2334         }
2335     }
2336 
2337     function payMainRafflePlayer(address _player, uint256 _amount, uint256 _stage)
2338     private
2339     {
2340         require(lotteryPortion > _amount);
2341         emit RaffleWinnerPick(_player, _amount, _stage);
2342         /* we only pay real non NULL_ADDRESS address */
2343         if (_player != NULL_ADDRESS) {
2344             lotteryPortion = lotteryPortion.sub(_amount);
2345             moneyballVault[_player] = moneyballVault[_player].add(_amount);
2346         }
2347     }
2348 
2349     function payTicket(uint256 _amount, address _player)
2350     private
2351     {
2352         require(lotteryPortion > _amount);
2353         lotteryPortion = lotteryPortion.sub(_amount);
2354         moneyballVault[_player] = moneyballVault[_player].add(_amount);
2355     }
2356 
2357     function redeemTicket(uint256 _stage, uint256 position, address player)
2358     private
2359     {
2360         /* ticket must be validated */
2361         require(stages[_stage].playerTickets[player][position].isValidated);
2362         /* ticket must never have been redeemed */
2363         require(!stages[_stage].playerTickets[player][position].isRedeemed);
2364 
2365         uint8 numMatches = stages[_stage].playerTickets[player][position].numMatches;
2366         bool pbMatches = stages[_stage].playerTickets[player][position].pbMatches;
2367 
2368         stages[_stage].playerTickets[player][position].isRedeemed = true;
2369 
2370         if (pbMatches) {
2371             playerRaffleTickets[player] = playerRaffleTickets[player].add(5);
2372             if (numMatches <= 1) {
2373                 payTicket(stages[_stage].stagePayouts.MONEYBALL_BASE_MATCHES, player);
2374             }
2375             if (numMatches == 2) {
2376                 payTicket(stages[_stage].stagePayouts.MONEYBALL_2_MATCHES, player);
2377             }
2378             if (numMatches == 3) {
2379                 payTicket(stages[_stage].stagePayouts.MONEYBALL_3_MATCHES, player);
2380             }
2381             if (numMatches == 4) {
2382                 payTicket(stages[_stage].stagePayouts.MONEYBALL_4_MATCHES, player);
2383             }
2384             if (numMatches == 5) {
2385                 uint256 LOCAL_lotteryPortion = lotteryPortion;
2386                 uint256 jackpotValue = SafeMath.div(LOCAL_lotteryPortion, 2);
2387                 payTicket(jackpotValue, player);
2388             }
2389         }
2390 
2391         if (!pbMatches) {
2392             if (numMatches == 3) {
2393                 payTicket(stages[_stage].stagePayouts.NO_MONEYBALL_3_MATCHES, player);
2394                 playerRaffleTickets[player] = playerRaffleTickets[player].add(5);
2395             }
2396             if (numMatches == 4) {
2397                 payTicket(stages[_stage].stagePayouts.NO_MONEYBALL_4_MATCHES, player);
2398                 playerRaffleTickets[player] = playerRaffleTickets[player].add(5);
2399             }
2400             if (numMatches == 5) {
2401                 payTicket(stages[_stage].stagePayouts.NO_MONEYBALL_5_MATCHES, player);
2402                 playerRaffleTickets[player] = playerRaffleTickets[player].add(5);
2403             }
2404         }
2405 
2406     }
2407 
2408     /*
2409     *   check value of a given ticket
2410     */
2411     function checkTicketValue(uint256 _stage, uint256 position)
2412     public
2413     view
2414     onlyAvailableStages(_stage)
2415     returns (uint)
2416     {
2417         address player = msg.sender;
2418         uint8 count = 0;
2419 
2420         /* count matches */
2421         if (checkPlayerN1(_stage, position, player)) {count = SafeMath.add2(count, 1);}
2422         if (checkPlayerN2(_stage, position, player)) {count = SafeMath.add2(count, 1);}
2423         if (checkPlayerN3(_stage, position, player)) {count = SafeMath.add2(count, 1);}
2424         if (checkPlayerN4(_stage, position, player)) {count = SafeMath.add2(count, 1);}
2425         if (checkPlayerN5(_stage, position, player)) {count = SafeMath.add2(count, 1);}
2426 
2427         uint8 numMatches = count;
2428         /* set ticket pb match bool */
2429         bool pbMatches = cmp(stages[_stage].finalTicket.pb, stages[_stage].playerTickets[player][position].pb);
2430 
2431         if (pbMatches) {
2432             if (numMatches <= 1) {
2433                 return stages[_stage].stagePayouts.MONEYBALL_BASE_MATCHES;
2434             }
2435             if (numMatches == 2) {
2436                 return stages[_stage].stagePayouts.MONEYBALL_2_MATCHES;
2437             }
2438             if (numMatches == 3) {
2439                 return stages[_stage].stagePayouts.MONEYBALL_3_MATCHES;
2440             }
2441             if (numMatches == 4) {
2442                 return stages[_stage].stagePayouts.MONEYBALL_4_MATCHES;
2443             }
2444             if (numMatches == 5) {
2445                 uint256 LOCAL_lotteryPortion = lotteryPortion;
2446                 uint256 jackpotValue = SafeMath.div(LOCAL_lotteryPortion, 2);
2447                 return jackpotValue;
2448             }
2449         }
2450 
2451         if (!pbMatches) {
2452             if (numMatches == 3) {
2453                 return stages[_stage].stagePayouts.NO_MONEYBALL_3_MATCHES;
2454             }
2455             if (numMatches == 4) {
2456                 return stages[_stage].stagePayouts.NO_MONEYBALL_4_MATCHES;
2457             }
2458             if (numMatches == 5) {
2459                 return stages[_stage].stagePayouts.NO_MONEYBALL_5_MATCHES;
2460             }
2461         }
2462 
2463         return 0;
2464     }
2465 
2466     /*
2467       ticket checking of final draw ticket vs player ticket positions for stage
2468     */
2469     function checkPlayerN1(uint256 _stage, uint256 position, address player) private view returns (bool) {
2470         if (cmp(stages[_stage].finalTicket.n1, stages[_stage].playerTickets[player][position].n1)) {return true;}
2471         if (cmp(stages[_stage].finalTicket.n2, stages[_stage].playerTickets[player][position].n1)) {return true;}
2472         if (cmp(stages[_stage].finalTicket.n3, stages[_stage].playerTickets[player][position].n1)) {return true;}
2473         if (cmp(stages[_stage].finalTicket.n4, stages[_stage].playerTickets[player][position].n1)) {return true;}
2474         if (cmp(stages[_stage].finalTicket.n5, stages[_stage].playerTickets[player][position].n1)) {return true;}
2475 
2476         return false;
2477     }
2478 
2479     function checkPlayerN2(uint256 _stage, uint256 position, address player) private view returns (bool) {
2480         if (cmp(stages[_stage].finalTicket.n1, stages[_stage].playerTickets[player][position].n2)) {return true;}
2481         if (cmp(stages[_stage].finalTicket.n2, stages[_stage].playerTickets[player][position].n2)) {return true;}
2482         if (cmp(stages[_stage].finalTicket.n3, stages[_stage].playerTickets[player][position].n2)) {return true;}
2483         if (cmp(stages[_stage].finalTicket.n4, stages[_stage].playerTickets[player][position].n2)) {return true;}
2484         if (cmp(stages[_stage].finalTicket.n5, stages[_stage].playerTickets[player][position].n2)) {return true;}
2485 
2486         return false;
2487     }
2488 
2489     function checkPlayerN3(uint256 _stage, uint256 position, address player) private view returns (bool) {
2490         if (cmp(stages[_stage].finalTicket.n1, stages[_stage].playerTickets[player][position].n3)) {return true;}
2491         if (cmp(stages[_stage].finalTicket.n2, stages[_stage].playerTickets[player][position].n3)) {return true;}
2492         if (cmp(stages[_stage].finalTicket.n3, stages[_stage].playerTickets[player][position].n3)) {return true;}
2493         if (cmp(stages[_stage].finalTicket.n4, stages[_stage].playerTickets[player][position].n3)) {return true;}
2494         if (cmp(stages[_stage].finalTicket.n5, stages[_stage].playerTickets[player][position].n3)) {return true;}
2495 
2496         return false;
2497     }
2498 
2499     function checkPlayerN4(uint256 _stage, uint256 position, address player) private view returns (bool) {
2500         if (cmp(stages[_stage].finalTicket.n1, stages[_stage].playerTickets[player][position].n4)) {return true;}
2501         if (cmp(stages[_stage].finalTicket.n2, stages[_stage].playerTickets[player][position].n4)) {return true;}
2502         if (cmp(stages[_stage].finalTicket.n3, stages[_stage].playerTickets[player][position].n4)) {return true;}
2503         if (cmp(stages[_stage].finalTicket.n4, stages[_stage].playerTickets[player][position].n4)) {return true;}
2504         if (cmp(stages[_stage].finalTicket.n5, stages[_stage].playerTickets[player][position].n4)) {return true;}
2505 
2506         return false;
2507     }
2508 
2509     function checkPlayerN5(uint256 _stage, uint256 position, address player) private view returns (bool) {
2510         if (cmp(stages[_stage].finalTicket.n1, stages[_stage].playerTickets[player][position].n5)) {return true;}
2511         if (cmp(stages[_stage].finalTicket.n2, stages[_stage].playerTickets[player][position].n5)) {return true;}
2512         if (cmp(stages[_stage].finalTicket.n3, stages[_stage].playerTickets[player][position].n5)) {return true;}
2513         if (cmp(stages[_stage].finalTicket.n4, stages[_stage].playerTickets[player][position].n5)) {return true;}
2514         if (cmp(stages[_stage].finalTicket.n5, stages[_stage].playerTickets[player][position].n5)) {return true;}
2515 
2516         return false;
2517     }
2518 
2519     /* check match position */
2520     function cmp(uint8 _draw, uint8 _player)
2521     private
2522     pure
2523     returns (bool)
2524     {
2525         if (_draw == _player) {return true;}
2526         return false;
2527     }
2528 
2529     /* check number boundries */
2530     function isSubmittedNumberWithinBounds(uint8 _n1, uint8 _n2, uint8 _n3, uint8 _n4, uint8 _n5, uint8 _pb)
2531     private
2532     pure
2533     returns (bool)
2534     {
2535         if (_n1 > 69 || _n1 == 0) {return false;}
2536         if (_n2 > 69 || _n2 == 0) {return false;}
2537         if (_n3 > 69 || _n3 == 0) {return false;}
2538         if (_n4 > 69 || _n4 == 0) {return false;}
2539         if (_n5 > 69 || _n5 == 0) {return false;}
2540         if (_pb > 26 || _pb == 0) {return false;}
2541         return true;
2542     }
2543 
2544 }
2545 
2546 interface ReferralInterface {
2547     function isAnOwner(address _referralAddress) external view returns(bool);
2548 }
2549 
2550 interface HourglassInterface {
2551     function buy(address _playerAddress) payable external returns(uint256);
2552     function withdraw() external;
2553     function myDividends(bool _includeReferralBonus) external view returns(uint256);
2554     function balanceOf(address _playerAddress) external view returns(uint256);
2555 }
2556 
2557 interface DiviesInterface {
2558     function deposit() external payable;
2559 }