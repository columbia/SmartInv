1 // <ORACLIZE_API>
2 
3 
4 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
5 
6 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
7 
8 contract OraclizeI {
9     address public cbAddress;
10     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
11     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
12     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
13     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
14     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
15     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
16     function getPrice(string _datasource) public returns (uint _dsprice);
17     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
18     function setProofType(byte _proofType) external;
19     function setCustomGasPrice(uint _gasPrice) external;
20     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
21 }
22 
23 contract OraclizeAddrResolverI {
24     function getAddress() public returns (address _addr);
25 }
26 
27 
28 library Buffer {
29     struct buffer {
30         bytes buf;
31         uint capacity;
32     }
33 
34     function init(buffer memory buf, uint _capacity) internal pure {
35         uint capacity = _capacity;
36         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
37         // Allocate space for the buffer data
38         buf.capacity = capacity;
39         assembly {
40             let ptr := mload(0x40)
41             mstore(buf, ptr)
42             mstore(ptr, 0)
43             mstore(0x40, add(ptr, capacity))
44         }
45     }
46 
47     function resize(buffer memory buf, uint capacity) private pure {
48         bytes memory oldbuf = buf.buf;
49         init(buf, capacity);
50         append(buf, oldbuf);
51     }
52 
53     function max(uint a, uint b) private pure returns(uint) {
54         if(a > b) {
55             return a;
56         }
57         return b;
58     }
59 
60     /**
61      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
62      *      would exceed the capacity of the buffer.
63      * @param buf The buffer to append to.
64      * @param data The data to append.
65      * @return The original buffer.
66      */
67     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
68         if(data.length + buf.buf.length > buf.capacity) {
69             resize(buf, max(buf.capacity, data.length) * 2);
70         }
71 
72         uint dest;
73         uint src;
74         uint len = data.length;
75         assembly {
76             // Memory address of the buffer data
77             let bufptr := mload(buf)
78             // Length of existing buffer data
79             let buflen := mload(bufptr)
80             // Start address = buffer address + buffer length + sizeof(buffer length)
81             dest := add(add(bufptr, buflen), 32)
82             // Update buffer length
83             mstore(bufptr, add(buflen, mload(data)))
84             src := add(data, 32)
85         }
86 
87         // Copy word-length chunks while possible
88         for(; len >= 32; len -= 32) {
89             assembly {
90                 mstore(dest, mload(src))
91             }
92             dest += 32;
93             src += 32;
94         }
95 
96         // Copy remaining bytes
97         uint mask = 256 ** (32 - len) - 1;
98         assembly {
99             let srcpart := and(mload(src), not(mask))
100             let destpart := and(mload(dest), mask)
101             mstore(dest, or(destpart, srcpart))
102         }
103 
104         return buf;
105     }
106 
107     /**
108      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
109      * exceed the capacity of the buffer.
110      * @param buf The buffer to append to.
111      * @param data The data to append.
112      * @return The original buffer.
113      */
114     function append(buffer memory buf, uint8 data) internal pure {
115         if(buf.buf.length + 1 > buf.capacity) {
116             resize(buf, buf.capacity * 2);
117         }
118 
119         assembly {
120             // Memory address of the buffer data
121             let bufptr := mload(buf)
122             // Length of existing buffer data
123             let buflen := mload(bufptr)
124             // Address = buffer address + buffer length + sizeof(buffer length)
125             let dest := add(add(bufptr, buflen), 32)
126             mstore8(dest, data)
127             // Update buffer length
128             mstore(bufptr, add(buflen, 1))
129         }
130     }
131 
132     /**
133      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
134      * exceed the capacity of the buffer.
135      * @param buf The buffer to append to.
136      * @param data The data to append.
137      * @return The original buffer.
138      */
139     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
140         if(len + buf.buf.length > buf.capacity) {
141             resize(buf, max(buf.capacity, len) * 2);
142         }
143 
144         uint mask = 256 ** len - 1;
145         assembly {
146             // Memory address of the buffer data
147             let bufptr := mload(buf)
148             // Length of existing buffer data
149             let buflen := mload(bufptr)
150             // Address = buffer address + buffer length + sizeof(buffer length) + len
151             let dest := add(add(bufptr, buflen), len)
152             mstore(dest, or(and(mload(dest), not(mask)), data))
153             // Update buffer length
154             mstore(bufptr, add(buflen, len))
155         }
156         return buf;
157     }
158 }
159 
160 library CBOR {
161     using Buffer for Buffer.buffer;
162 
163     uint8 private constant MAJOR_TYPE_INT = 0;
164     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
165     uint8 private constant MAJOR_TYPE_BYTES = 2;
166     uint8 private constant MAJOR_TYPE_STRING = 3;
167     uint8 private constant MAJOR_TYPE_ARRAY = 4;
168     uint8 private constant MAJOR_TYPE_MAP = 5;
169     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
170 
171     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
172         if(value <= 23) {
173             buf.append(uint8((major << 5) | value));
174         } else if(value <= 0xFF) {
175             buf.append(uint8((major << 5) | 24));
176             buf.appendInt(value, 1);
177         } else if(value <= 0xFFFF) {
178             buf.append(uint8((major << 5) | 25));
179             buf.appendInt(value, 2);
180         } else if(value <= 0xFFFFFFFF) {
181             buf.append(uint8((major << 5) | 26));
182             buf.appendInt(value, 4);
183         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
184             buf.append(uint8((major << 5) | 27));
185             buf.appendInt(value, 8);
186         }
187     }
188 
189     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
190         buf.append(uint8((major << 5) | 31));
191     }
192 
193     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
194         encodeType(buf, MAJOR_TYPE_INT, value);
195     }
196 
197     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
198         if(value >= 0) {
199             encodeType(buf, MAJOR_TYPE_INT, uint(value));
200         } else {
201             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
202         }
203     }
204 
205     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
206         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
207         buf.append(value);
208     }
209 
210     function encodeString(Buffer.buffer memory buf, string value) internal pure {
211         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
212         buf.append(bytes(value));
213     }
214 
215     function startArray(Buffer.buffer memory buf) internal pure {
216         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
217     }
218 
219     function startMap(Buffer.buffer memory buf) internal pure {
220         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
221     }
222 
223     function endSequence(Buffer.buffer memory buf) internal pure {
224         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
225     }
226 }
227 
228 /*
229 End solidity-cborutils
230  */
231 
232 contract usingOraclize {
233     uint constant day = 60*60*24;
234     uint constant week = 60*60*24*7;
235     uint constant month = 60*60*24*30;
236     byte constant proofType_NONE = 0x00;
237     byte constant proofType_TLSNotary = 0x10;
238     byte constant proofType_Ledger = 0x30;
239     byte constant proofType_Android = 0x40;
240     byte constant proofType_Native = 0xF0;
241     byte constant proofStorage_IPFS = 0x01;
242     uint8 constant networkID_auto = 0;
243     uint8 constant networkID_mainnet = 1;
244     uint8 constant networkID_testnet = 2;
245     uint8 constant networkID_morden = 2;
246     uint8 constant networkID_consensys = 161;
247 
248     OraclizeAddrResolverI OAR;
249 
250     OraclizeI oraclize;
251     modifier oraclizeAPI {
252         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
253             oraclize_setNetwork(networkID_auto);
254 
255         if(address(oraclize) != OAR.getAddress())
256             oraclize = OraclizeI(OAR.getAddress());
257 
258         _;
259     }
260     modifier coupon(string code){
261         oraclize = OraclizeI(OAR.getAddress());
262         _;
263     }
264 
265     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
266       return oraclize_setNetwork();
267       networkID; // silence the warning and remain backwards compatible
268     }
269     function oraclize_setNetwork() internal returns(bool){
270         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
271             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
272             oraclize_setNetworkName("eth_mainnet");
273             return true;
274         }
275         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
276             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
277             oraclize_setNetworkName("eth_ropsten3");
278             return true;
279         }
280         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
281             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
282             oraclize_setNetworkName("eth_kovan");
283             return true;
284         }
285         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
286             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
287             oraclize_setNetworkName("eth_rinkeby");
288             return true;
289         }
290         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
291             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
292             return true;
293         }
294         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
295             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
296             return true;
297         }
298         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
299             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
300             return true;
301         }
302         return false;
303     }
304 
305     function __callback(bytes32 myid, string result) public {
306         __callback(myid, result, new bytes(0));
307     }
308     function __callback(bytes32 myid, string result, bytes proof) public {
309       return;
310       myid; result; proof; // Silence compiler warnings
311     }
312 
313     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
314         return oraclize.getPrice(datasource);
315     }
316 
317     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
318         return oraclize.getPrice(datasource, gaslimit);
319     }
320 
321     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
322         uint price = oraclize.getPrice(datasource);
323         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
324         return oraclize.query.value(price)(0, datasource, arg);
325     }
326     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
327         uint price = oraclize.getPrice(datasource);
328         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
329         return oraclize.query.value(price)(timestamp, datasource, arg);
330     }
331     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
332         uint price = oraclize.getPrice(datasource, gaslimit);
333         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
334         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
335     }
336     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
337         uint price = oraclize.getPrice(datasource, gaslimit);
338         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
339         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
340     }
341     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
342         uint price = oraclize.getPrice(datasource);
343         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
344         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
345     }
346     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
347         uint price = oraclize.getPrice(datasource);
348         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
349         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
350     }
351     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
352         uint price = oraclize.getPrice(datasource, gaslimit);
353         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
354         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
355     }
356     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
357         uint price = oraclize.getPrice(datasource, gaslimit);
358         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
359         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
360     }
361     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
362         uint price = oraclize.getPrice(datasource);
363         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
364         bytes memory args = stra2cbor(argN);
365         return oraclize.queryN.value(price)(0, datasource, args);
366     }
367     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
368         uint price = oraclize.getPrice(datasource);
369         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
370         bytes memory args = stra2cbor(argN);
371         return oraclize.queryN.value(price)(timestamp, datasource, args);
372     }
373     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
374         uint price = oraclize.getPrice(datasource, gaslimit);
375         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
376         bytes memory args = stra2cbor(argN);
377         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
378     }
379     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
380         uint price = oraclize.getPrice(datasource, gaslimit);
381         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
382         bytes memory args = stra2cbor(argN);
383         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
384     }
385     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
386         string[] memory dynargs = new string[](1);
387         dynargs[0] = args[0];
388         return oraclize_query(datasource, dynargs);
389     }
390     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
391         string[] memory dynargs = new string[](1);
392         dynargs[0] = args[0];
393         return oraclize_query(timestamp, datasource, dynargs);
394     }
395     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
396         string[] memory dynargs = new string[](1);
397         dynargs[0] = args[0];
398         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
399     }
400     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
401         string[] memory dynargs = new string[](1);
402         dynargs[0] = args[0];
403         return oraclize_query(datasource, dynargs, gaslimit);
404     }
405 
406     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
407         string[] memory dynargs = new string[](2);
408         dynargs[0] = args[0];
409         dynargs[1] = args[1];
410         return oraclize_query(datasource, dynargs);
411     }
412     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
413         string[] memory dynargs = new string[](2);
414         dynargs[0] = args[0];
415         dynargs[1] = args[1];
416         return oraclize_query(timestamp, datasource, dynargs);
417     }
418     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
419         string[] memory dynargs = new string[](2);
420         dynargs[0] = args[0];
421         dynargs[1] = args[1];
422         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
423     }
424     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
425         string[] memory dynargs = new string[](2);
426         dynargs[0] = args[0];
427         dynargs[1] = args[1];
428         return oraclize_query(datasource, dynargs, gaslimit);
429     }
430     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
431         string[] memory dynargs = new string[](3);
432         dynargs[0] = args[0];
433         dynargs[1] = args[1];
434         dynargs[2] = args[2];
435         return oraclize_query(datasource, dynargs);
436     }
437     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
438         string[] memory dynargs = new string[](3);
439         dynargs[0] = args[0];
440         dynargs[1] = args[1];
441         dynargs[2] = args[2];
442         return oraclize_query(timestamp, datasource, dynargs);
443     }
444     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
445         string[] memory dynargs = new string[](3);
446         dynargs[0] = args[0];
447         dynargs[1] = args[1];
448         dynargs[2] = args[2];
449         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
450     }
451     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
452         string[] memory dynargs = new string[](3);
453         dynargs[0] = args[0];
454         dynargs[1] = args[1];
455         dynargs[2] = args[2];
456         return oraclize_query(datasource, dynargs, gaslimit);
457     }
458 
459     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
460         string[] memory dynargs = new string[](4);
461         dynargs[0] = args[0];
462         dynargs[1] = args[1];
463         dynargs[2] = args[2];
464         dynargs[3] = args[3];
465         return oraclize_query(datasource, dynargs);
466     }
467     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
468         string[] memory dynargs = new string[](4);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         dynargs[2] = args[2];
472         dynargs[3] = args[3];
473         return oraclize_query(timestamp, datasource, dynargs);
474     }
475     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
476         string[] memory dynargs = new string[](4);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         dynargs[2] = args[2];
480         dynargs[3] = args[3];
481         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
482     }
483     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
484         string[] memory dynargs = new string[](4);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         dynargs[2] = args[2];
488         dynargs[3] = args[3];
489         return oraclize_query(datasource, dynargs, gaslimit);
490     }
491     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
492         string[] memory dynargs = new string[](5);
493         dynargs[0] = args[0];
494         dynargs[1] = args[1];
495         dynargs[2] = args[2];
496         dynargs[3] = args[3];
497         dynargs[4] = args[4];
498         return oraclize_query(datasource, dynargs);
499     }
500     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
501         string[] memory dynargs = new string[](5);
502         dynargs[0] = args[0];
503         dynargs[1] = args[1];
504         dynargs[2] = args[2];
505         dynargs[3] = args[3];
506         dynargs[4] = args[4];
507         return oraclize_query(timestamp, datasource, dynargs);
508     }
509     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
510         string[] memory dynargs = new string[](5);
511         dynargs[0] = args[0];
512         dynargs[1] = args[1];
513         dynargs[2] = args[2];
514         dynargs[3] = args[3];
515         dynargs[4] = args[4];
516         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
517     }
518     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
519         string[] memory dynargs = new string[](5);
520         dynargs[0] = args[0];
521         dynargs[1] = args[1];
522         dynargs[2] = args[2];
523         dynargs[3] = args[3];
524         dynargs[4] = args[4];
525         return oraclize_query(datasource, dynargs, gaslimit);
526     }
527     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
528         uint price = oraclize.getPrice(datasource);
529         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
530         bytes memory args = ba2cbor(argN);
531         return oraclize.queryN.value(price)(0, datasource, args);
532     }
533     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
534         uint price = oraclize.getPrice(datasource);
535         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
536         bytes memory args = ba2cbor(argN);
537         return oraclize.queryN.value(price)(timestamp, datasource, args);
538     }
539     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
540         uint price = oraclize.getPrice(datasource, gaslimit);
541         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
542         bytes memory args = ba2cbor(argN);
543         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
544     }
545     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
546         uint price = oraclize.getPrice(datasource, gaslimit);
547         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
548         bytes memory args = ba2cbor(argN);
549         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
550     }
551     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
552         bytes[] memory dynargs = new bytes[](1);
553         dynargs[0] = args[0];
554         return oraclize_query(datasource, dynargs);
555     }
556     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
557         bytes[] memory dynargs = new bytes[](1);
558         dynargs[0] = args[0];
559         return oraclize_query(timestamp, datasource, dynargs);
560     }
561     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
562         bytes[] memory dynargs = new bytes[](1);
563         dynargs[0] = args[0];
564         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
565     }
566     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
567         bytes[] memory dynargs = new bytes[](1);
568         dynargs[0] = args[0];
569         return oraclize_query(datasource, dynargs, gaslimit);
570     }
571 
572     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
573         bytes[] memory dynargs = new bytes[](2);
574         dynargs[0] = args[0];
575         dynargs[1] = args[1];
576         return oraclize_query(datasource, dynargs);
577     }
578     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
579         bytes[] memory dynargs = new bytes[](2);
580         dynargs[0] = args[0];
581         dynargs[1] = args[1];
582         return oraclize_query(timestamp, datasource, dynargs);
583     }
584     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
585         bytes[] memory dynargs = new bytes[](2);
586         dynargs[0] = args[0];
587         dynargs[1] = args[1];
588         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
589     }
590     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
591         bytes[] memory dynargs = new bytes[](2);
592         dynargs[0] = args[0];
593         dynargs[1] = args[1];
594         return oraclize_query(datasource, dynargs, gaslimit);
595     }
596     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
597         bytes[] memory dynargs = new bytes[](3);
598         dynargs[0] = args[0];
599         dynargs[1] = args[1];
600         dynargs[2] = args[2];
601         return oraclize_query(datasource, dynargs);
602     }
603     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
604         bytes[] memory dynargs = new bytes[](3);
605         dynargs[0] = args[0];
606         dynargs[1] = args[1];
607         dynargs[2] = args[2];
608         return oraclize_query(timestamp, datasource, dynargs);
609     }
610     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
611         bytes[] memory dynargs = new bytes[](3);
612         dynargs[0] = args[0];
613         dynargs[1] = args[1];
614         dynargs[2] = args[2];
615         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
616     }
617     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
618         bytes[] memory dynargs = new bytes[](3);
619         dynargs[0] = args[0];
620         dynargs[1] = args[1];
621         dynargs[2] = args[2];
622         return oraclize_query(datasource, dynargs, gaslimit);
623     }
624 
625     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
626         bytes[] memory dynargs = new bytes[](4);
627         dynargs[0] = args[0];
628         dynargs[1] = args[1];
629         dynargs[2] = args[2];
630         dynargs[3] = args[3];
631         return oraclize_query(datasource, dynargs);
632     }
633     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
634         bytes[] memory dynargs = new bytes[](4);
635         dynargs[0] = args[0];
636         dynargs[1] = args[1];
637         dynargs[2] = args[2];
638         dynargs[3] = args[3];
639         return oraclize_query(timestamp, datasource, dynargs);
640     }
641     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
642         bytes[] memory dynargs = new bytes[](4);
643         dynargs[0] = args[0];
644         dynargs[1] = args[1];
645         dynargs[2] = args[2];
646         dynargs[3] = args[3];
647         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
648     }
649     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
650         bytes[] memory dynargs = new bytes[](4);
651         dynargs[0] = args[0];
652         dynargs[1] = args[1];
653         dynargs[2] = args[2];
654         dynargs[3] = args[3];
655         return oraclize_query(datasource, dynargs, gaslimit);
656     }
657     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
658         bytes[] memory dynargs = new bytes[](5);
659         dynargs[0] = args[0];
660         dynargs[1] = args[1];
661         dynargs[2] = args[2];
662         dynargs[3] = args[3];
663         dynargs[4] = args[4];
664         return oraclize_query(datasource, dynargs);
665     }
666     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
667         bytes[] memory dynargs = new bytes[](5);
668         dynargs[0] = args[0];
669         dynargs[1] = args[1];
670         dynargs[2] = args[2];
671         dynargs[3] = args[3];
672         dynargs[4] = args[4];
673         return oraclize_query(timestamp, datasource, dynargs);
674     }
675     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
676         bytes[] memory dynargs = new bytes[](5);
677         dynargs[0] = args[0];
678         dynargs[1] = args[1];
679         dynargs[2] = args[2];
680         dynargs[3] = args[3];
681         dynargs[4] = args[4];
682         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
683     }
684     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
685         bytes[] memory dynargs = new bytes[](5);
686         dynargs[0] = args[0];
687         dynargs[1] = args[1];
688         dynargs[2] = args[2];
689         dynargs[3] = args[3];
690         dynargs[4] = args[4];
691         return oraclize_query(datasource, dynargs, gaslimit);
692     }
693 
694     function oraclize_cbAddress() oraclizeAPI internal returns (address){
695         return oraclize.cbAddress();
696     }
697     function oraclize_setProof(byte proofP) oraclizeAPI internal {
698         return oraclize.setProofType(proofP);
699     }
700     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
701         return oraclize.setCustomGasPrice(gasPrice);
702     }
703 
704     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
705         return oraclize.randomDS_getSessionPubKeyHash();
706     }
707 
708     function getCodeSize(address _addr) constant internal returns(uint _size) {
709         assembly {
710             _size := extcodesize(_addr)
711         }
712     }
713 
714     function parseAddr(string _a) internal pure returns (address){
715         bytes memory tmp = bytes(_a);
716         uint160 iaddr = 0;
717         uint160 b1;
718         uint160 b2;
719         for (uint i=2; i<2+2*20; i+=2){
720             iaddr *= 256;
721             b1 = uint160(tmp[i]);
722             b2 = uint160(tmp[i+1]);
723             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
724             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
725             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
726             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
727             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
728             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
729             iaddr += (b1*16+b2);
730         }
731         return address(iaddr);
732     }
733 
734     function strCompare(string _a, string _b) internal pure returns (int) {
735         bytes memory a = bytes(_a);
736         bytes memory b = bytes(_b);
737         uint minLength = a.length;
738         if (b.length < minLength) minLength = b.length;
739         for (uint i = 0; i < minLength; i ++)
740             if (a[i] < b[i])
741                 return -1;
742             else if (a[i] > b[i])
743                 return 1;
744         if (a.length < b.length)
745             return -1;
746         else if (a.length > b.length)
747             return 1;
748         else
749             return 0;
750     }
751 
752     function indexOf(string _haystack, string _needle) internal pure returns (int) {
753         bytes memory h = bytes(_haystack);
754         bytes memory n = bytes(_needle);
755         if(h.length < 1 || n.length < 1 || (n.length > h.length))
756             return -1;
757         else if(h.length > (2**128 -1))
758             return -1;
759         else
760         {
761             uint subindex = 0;
762             for (uint i = 0; i < h.length; i ++)
763             {
764                 if (h[i] == n[0])
765                 {
766                     subindex = 1;
767                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
768                     {
769                         subindex++;
770                     }
771                     if(subindex == n.length)
772                         return int(i);
773                 }
774             }
775             return -1;
776         }
777     }
778 
779     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
780         bytes memory _ba = bytes(_a);
781         bytes memory _bb = bytes(_b);
782         bytes memory _bc = bytes(_c);
783         bytes memory _bd = bytes(_d);
784         bytes memory _be = bytes(_e);
785         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
786         bytes memory babcde = bytes(abcde);
787         uint k = 0;
788         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
789         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
790         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
791         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
792         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
793         return string(babcde);
794     }
795 
796     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
797         return strConcat(_a, _b, _c, _d, "");
798     }
799 
800     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
801         return strConcat(_a, _b, _c, "", "");
802     }
803 
804     function strConcat(string _a, string _b) internal pure returns (string) {
805         return strConcat(_a, _b, "", "", "");
806     }
807 
808     // parseInt
809     function parseInt(string _a) internal pure returns (uint) {
810         return parseInt(_a, 0);
811     }
812 
813     // parseInt(parseFloat*10^_b)
814     function parseInt(string _a, uint _b) internal pure returns (uint) {
815         bytes memory bresult = bytes(_a);
816         uint mint = 0;
817         bool decimals = false;
818         for (uint i=0; i<bresult.length; i++){
819             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
820                 if (decimals){
821                    if (_b == 0) break;
822                     else _b--;
823                 }
824                 mint *= 10;
825                 mint += uint(bresult[i]) - 48;
826             } else if (bresult[i] == 46) decimals = true;
827         }
828         if (_b > 0) mint *= 10**_b;
829         return mint;
830     }
831 
832     function uint2str(uint i) internal pure returns (string){
833         if (i == 0) return "0";
834         uint j = i;
835         uint len;
836         while (j != 0){
837             len++;
838             j /= 10;
839         }
840         bytes memory bstr = new bytes(len);
841         uint k = len - 1;
842         while (i != 0){
843             bstr[k--] = byte(48 + i % 10);
844             i /= 10;
845         }
846         return string(bstr);
847     }
848 
849     using CBOR for Buffer.buffer;
850     function stra2cbor(string[] arr) internal pure returns (bytes) {
851         safeMemoryCleaner();
852         Buffer.buffer memory buf;
853         Buffer.init(buf, 1024);
854         buf.startArray();
855         for (uint i = 0; i < arr.length; i++) {
856             buf.encodeString(arr[i]);
857         }
858         buf.endSequence();
859         return buf.buf;
860     }
861 
862     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
863         safeMemoryCleaner();
864         Buffer.buffer memory buf;
865         Buffer.init(buf, 1024);
866         buf.startArray();
867         for (uint i = 0; i < arr.length; i++) {
868             buf.encodeBytes(arr[i]);
869         }
870         buf.endSequence();
871         return buf.buf;
872     }
873 
874     string oraclize_network_name;
875     function oraclize_setNetworkName(string _network_name) internal {
876         oraclize_network_name = _network_name;
877     }
878 
879     function oraclize_getNetworkName() internal view returns (string) {
880         return oraclize_network_name;
881     }
882 
883     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
884         require((_nbytes > 0) && (_nbytes <= 32));
885         // Convert from seconds to ledger timer ticks
886         _delay *= 10;
887         bytes memory nbytes = new bytes(1);
888         nbytes[0] = byte(_nbytes);
889         bytes memory unonce = new bytes(32);
890         bytes memory sessionKeyHash = new bytes(32);
891         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
892         assembly {
893             mstore(unonce, 0x20)
894             // the following variables can be relaxed
895             // check relaxed random contract under ethereum-examples repo
896             // for an idea on how to override and replace comit hash vars
897             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
898             mstore(sessionKeyHash, 0x20)
899             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
900         }
901         bytes memory delay = new bytes(32);
902         assembly {
903             mstore(add(delay, 0x20), _delay)
904         }
905 
906         bytes memory delay_bytes8 = new bytes(8);
907         copyBytes(delay, 24, 8, delay_bytes8, 0);
908 
909         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
910         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
911 
912         bytes memory delay_bytes8_left = new bytes(8);
913 
914         assembly {
915             let x := mload(add(delay_bytes8, 0x20))
916             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
917             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
918             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
919             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
920             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
921             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
922             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
923             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
924 
925         }
926 
927         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
928         return queryId;
929     }
930 
931     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
932         oraclize_randomDS_args[queryId] = commitment;
933     }
934 
935     mapping(bytes32=>bytes32) oraclize_randomDS_args;
936     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
937 
938     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
939         bool sigok;
940         address signer;
941 
942         bytes32 sigr;
943         bytes32 sigs;
944 
945         bytes memory sigr_ = new bytes(32);
946         uint offset = 4+(uint(dersig[3]) - 0x20);
947         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
948         bytes memory sigs_ = new bytes(32);
949         offset += 32 + 2;
950         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
951 
952         assembly {
953             sigr := mload(add(sigr_, 32))
954             sigs := mload(add(sigs_, 32))
955         }
956 
957 
958         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
959         if (address(keccak256(pubkey)) == signer) return true;
960         else {
961             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
962             return (address(keccak256(pubkey)) == signer);
963         }
964     }
965 
966     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
967         bool sigok;
968 
969         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
970         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
971         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
972 
973         bytes memory appkey1_pubkey = new bytes(64);
974         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
975 
976         bytes memory tosign2 = new bytes(1+65+32);
977         tosign2[0] = byte(1); //role
978         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
979         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
980         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
981         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
982 
983         if (sigok == false) return false;
984 
985 
986         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
987         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
988 
989         bytes memory tosign3 = new bytes(1+65);
990         tosign3[0] = 0xFE;
991         copyBytes(proof, 3, 65, tosign3, 1);
992 
993         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
994         copyBytes(proof, 3+65, sig3.length, sig3, 0);
995 
996         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
997 
998         return sigok;
999     }
1000 
1001     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1002         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1003         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1004 
1005         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1006         require(proofVerified);
1007 
1008         _;
1009     }
1010 
1011     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1012         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1013         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1014 
1015         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1016         if (proofVerified == false) return 2;
1017 
1018         return 0;
1019     }
1020 
1021     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1022         bool match_ = true;
1023 
1024         require(prefix.length == n_random_bytes);
1025 
1026         for (uint256 i=0; i< n_random_bytes; i++) {
1027             if (content[i] != prefix[i]) match_ = false;
1028         }
1029 
1030         return match_;
1031     }
1032 
1033     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1034 
1035         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1036         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1037         bytes memory keyhash = new bytes(32);
1038         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1039         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1040 
1041         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1042         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1043 
1044         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1045         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1046 
1047         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1048         // This is to verify that the computed args match with the ones specified in the query.
1049         bytes memory commitmentSlice1 = new bytes(8+1+32);
1050         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1051 
1052         bytes memory sessionPubkey = new bytes(64);
1053         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1054         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1055 
1056         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1057         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1058             delete oraclize_randomDS_args[queryId];
1059         } else return false;
1060 
1061 
1062         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1063         bytes memory tosign1 = new bytes(32+8+1+32);
1064         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1065         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1066 
1067         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1068         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1069             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1070         }
1071 
1072         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1073     }
1074 
1075     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1076     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1077         uint minLength = length + toOffset;
1078 
1079         // Buffer too small
1080         require(to.length >= minLength); // Should be a better way?
1081 
1082         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1083         uint i = 32 + fromOffset;
1084         uint j = 32 + toOffset;
1085 
1086         while (i < (32 + fromOffset + length)) {
1087             assembly {
1088                 let tmp := mload(add(from, i))
1089                 mstore(add(to, j), tmp)
1090             }
1091             i += 32;
1092             j += 32;
1093         }
1094 
1095         return to;
1096     }
1097 
1098     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1099     // Duplicate Solidity's ecrecover, but catching the CALL return value
1100     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1101         // We do our own memory management here. Solidity uses memory offset
1102         // 0x40 to store the current end of memory. We write past it (as
1103         // writes are memory extensions), but don't update the offset so
1104         // Solidity will reuse it. The memory used here is only needed for
1105         // this context.
1106 
1107         // FIXME: inline assembly can't access return values
1108         bool ret;
1109         address addr;
1110 
1111         assembly {
1112             let size := mload(0x40)
1113             mstore(size, hash)
1114             mstore(add(size, 32), v)
1115             mstore(add(size, 64), r)
1116             mstore(add(size, 96), s)
1117 
1118             // NOTE: we can reuse the request memory because we deal with
1119             //       the return code
1120             ret := call(3000, 1, 0, size, 128, size, 32)
1121             addr := mload(size)
1122         }
1123 
1124         return (ret, addr);
1125     }
1126 
1127     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1128     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1129         bytes32 r;
1130         bytes32 s;
1131         uint8 v;
1132 
1133         if (sig.length != 65)
1134           return (false, 0);
1135 
1136         // The signature format is a compact form of:
1137         //   {bytes32 r}{bytes32 s}{uint8 v}
1138         // Compact means, uint8 is not padded to 32 bytes.
1139         assembly {
1140             r := mload(add(sig, 32))
1141             s := mload(add(sig, 64))
1142 
1143             // Here we are loading the last 32 bytes. We exploit the fact that
1144             // 'mload' will pad with zeroes if we overread.
1145             // There is no 'mload8' to do this, but that would be nicer.
1146             v := byte(0, mload(add(sig, 96)))
1147 
1148             // Alternative solution:
1149             // 'byte' is not working due to the Solidity parser, so lets
1150             // use the second best option, 'and'
1151             // v := and(mload(add(sig, 65)), 255)
1152         }
1153 
1154         // albeit non-transactional signatures are not specified by the YP, one would expect it
1155         // to match the YP range of [27, 28]
1156         //
1157         // geth uses [0, 1] and some clients have followed. This might change, see:
1158         //  https://github.com/ethereum/go-ethereum/issues/2053
1159         if (v < 27)
1160           v += 27;
1161 
1162         if (v != 27 && v != 28)
1163             return (false, 0);
1164 
1165         return safer_ecrecover(hash, v, r, s);
1166     }
1167 
1168     function safeMemoryCleaner() internal pure {
1169         assembly {
1170             let fmem := mload(0x40)
1171             codecopy(fmem, codesize, sub(msize, fmem))
1172         }
1173     }
1174 
1175 }
1176 // </ORACLIZE_API>
1177 
1178 contract LDice is usingOraclize {
1179 
1180     uint constant pwin = 5000; //probability of winning (10000 = 100%)
1181     uint constant edge = 190; //edge percentage (10000 = 100%)
1182     uint constant maxWin = 100; //max win (before edge is taken) as percentage of bankroll (10000 = 100%)
1183     uint constant minBet = 10 finney;
1184     uint constant maxInvestors = 10; //maximum number of investors
1185     uint constant houseEdge = 500; //edge percentage (10000 = 100%)
1186     uint constant divestFee = 100; //divest fee percentage (10000 = 100%)
1187     uint constant emergencyWithdrawalRatio = 10; //ratio percentage (100 = 100%)
1188 
1189     uint safeGas = 2300;
1190     uint constant ORACLIZE_GAS_LIMIT = 175000;
1191     uint constant INVALID_BET_MARKER = 99999;
1192     uint constant EMERGENCY_TIMEOUT = 12 hours;
1193 
1194     struct Investor {
1195         address investorAddress;
1196         uint amountInvested;
1197         bool votedForEmergencyWithdrawal;
1198     }
1199 
1200     struct Bet {
1201         address playerAddress;
1202         uint amountBet;
1203         uint numberRolled;
1204     }
1205 
1206     struct WithdrawalProposal {
1207         address toAddress;
1208         uint atTime;
1209     }
1210 
1211     //Starting at 1
1212     mapping(address => uint) public investorIDs;
1213     mapping(uint => Investor) public investors;
1214     uint public numInvestors = 0;
1215 
1216     uint public invested = 0;
1217 
1218     address public owner;
1219     address public houseAddress;
1220     bool public isStopped;
1221     string public randomOrgAPIKey = "e1de2fda-77b3-4fa5-bdec-cd09c82bcff7";
1222 
1223     WithdrawalProposal public proposedWithdrawal;
1224 
1225     mapping (bytes32 => Bet) public bets;
1226     bytes32[] public betsKeys;
1227 
1228     uint public investorsProfit = 0;
1229     uint public investorsLosses = 0;
1230     bool profitDistributed;
1231 
1232     uint public totalWin = 0;
1233 
1234     event LOG_NewBet(address playerAddress, uint amount);
1235     event LOG_BetWon(address playerAddress, uint numberRolled, uint amountWon);
1236     event LOG_BetLost(address playerAddress, uint numberRolled);
1237     event LOG_EmergencyWithdrawalProposed();
1238     event LOG_EmergencyWithdrawalFailed(address withdrawalAddress);
1239     event LOG_EmergencyWithdrawalSucceeded(address withdrawalAddress, uint amountWithdrawn);
1240     event LOG_FailedSend(address receiver, uint amount);
1241     event LOG_ZeroSend();
1242     event LOG_InvestorEntrance(address investor, uint amount);
1243     event LOG_InvestorCapitalUpdate(address investor, int amount);
1244     event LOG_InvestorExit(address investor, uint amount);
1245     event LOG_ContractStopped();
1246     event LOG_ContractResumed();
1247     event LOG_OwnerAddressChanged(address oldAddr, address newOwnerAddress);
1248     event LOG_HouseAddressChanged(address oldAddr, address newHouseAddress);
1249     event LOG_RandomOrgAPIKeyChanged(string oldKey, string newKey);
1250     event LOG_GasLimitChanged(uint oldGasLimit, uint newGasLimit);
1251     event LOG_EmergencyAutoStop();
1252     event LOG_EmergencyWithdrawalVote(address investor, bool vote);
1253     event LOG_ValueIsTooBig();
1254     event LOG_SuccessfulSend(address addr, uint amount);
1255 
1256     constructor() public {
1257         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1258         owner = msg.sender;
1259         houseAddress = msg.sender;
1260     }
1261 
1262     //SECTION I: MODIFIERS AND HELPER FUNCTIONS
1263 
1264     //MODIFIERS
1265 
1266     modifier onlyIfNotStopped {
1267         if (isStopped) throw;
1268         _;
1269     }
1270 
1271     modifier onlyIfStopped {
1272         if (!isStopped) throw;
1273         _;
1274     }
1275 
1276     modifier onlyInvestors {
1277         if (investorIDs[msg.sender] == 0) throw;
1278         _;
1279     }
1280 
1281     modifier onlyNotInvestors {
1282         if (investorIDs[msg.sender] != 0) throw;
1283         _;
1284     }
1285 
1286     modifier onlyOwner {
1287         if (owner != msg.sender) throw;
1288         _;
1289     }
1290 
1291     modifier onlyOraclize {
1292         if (msg.sender != oraclize_cbAddress()) throw;
1293         _;
1294     }
1295 
1296     modifier onlyMoreThanMinInvestment {
1297         if (msg.value <= getMinInvestment()) throw;
1298         _;
1299     }
1300 
1301     modifier onlyMoreThanZero {
1302         if (msg.value == 0) throw;
1303         _;
1304     }
1305 
1306     modifier onlyIfBetExist(bytes32 myid) {
1307         if(bets[myid].playerAddress == address(0x0)) throw;
1308         _;
1309     }
1310 
1311     modifier onlyIfBetSizeIsStillCorrect(bytes32 myid) {
1312         if ((((bets[myid].amountBet * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000)  && (bets[myid].amountBet >= minBet)) {
1313              _;
1314         }
1315         else {
1316             bets[myid].numberRolled = INVALID_BET_MARKER;
1317             safeSend(bets[myid].playerAddress, bets[myid].amountBet);
1318             return;
1319         }
1320     }
1321 
1322     modifier onlyIfValidRoll(bytes32 myid, string result) {
1323         uint numberRolled = parseInt(result);
1324         if ((numberRolled < 1 || numberRolled > 10000) && bets[myid].numberRolled == 0) {
1325             bets[myid].numberRolled = INVALID_BET_MARKER;
1326             safeSend(bets[myid].playerAddress, bets[myid].amountBet);
1327             return;
1328         }
1329         _;
1330     }
1331 
1332     modifier onlyWinningBets(uint numberRolled) {
1333         if (numberRolled - 1 < pwin) {
1334             _;
1335         }
1336     }
1337 
1338     modifier onlyLosingBets(uint numberRolled) {
1339         if (numberRolled - 1 >= pwin) {
1340             _;
1341         }
1342     }
1343 
1344     modifier onlyAfterProposed {
1345         if (proposedWithdrawal.toAddress == 0) throw;
1346         _;
1347     }
1348 
1349     modifier onlyIfProfitNotDistributed {
1350         if (!profitDistributed) {
1351             _;
1352         }
1353     }
1354 
1355     modifier onlyIfValidGas(uint newGasLimit) {
1356         if (ORACLIZE_GAS_LIMIT + newGasLimit < ORACLIZE_GAS_LIMIT) throw;
1357         if (newGasLimit < 25000) throw;
1358         _;
1359     }
1360 
1361     modifier onlyIfNotProcessed(bytes32 myid) {
1362         if (bets[myid].numberRolled > 0) throw;
1363         _;
1364     }
1365 
1366     modifier onlyIfEmergencyTimeOutHasPassed {
1367         if (proposedWithdrawal.atTime + EMERGENCY_TIMEOUT > now) throw;
1368         _;
1369     }
1370 
1371     modifier investorsInvariant {
1372         _;
1373         if (numInvestors > maxInvestors) throw;
1374     }
1375 
1376     //CONSTANT HELPER FUNCTIONS
1377 
1378     function getBankroll()
1379         constant
1380         returns(uint) {
1381 
1382         if ((invested < investorsProfit) ||
1383             (invested + investorsProfit < invested) ||
1384             (invested + investorsProfit < investorsLosses)) {
1385             return 0;
1386         }
1387         else {
1388             return invested + investorsProfit - investorsLosses;
1389         }
1390     }
1391 
1392     function getMinInvestment()
1393         constant
1394         returns(uint) {
1395 
1396         if (numInvestors == maxInvestors) {
1397             uint investorID = searchSmallestInvestor();
1398             return getBalance(investors[investorID].investorAddress);
1399         }
1400         else {
1401             return 0;
1402         }
1403     }
1404 
1405     function getStatus()
1406         constant
1407         returns(uint, uint, uint, uint, uint, uint, uint, uint, uint) {
1408 
1409         uint bankroll = getBankroll();
1410         uint minInvestment = getMinInvestment();
1411         return (bankroll, pwin, edge, maxWin, minBet, (investorsProfit - investorsLosses), minInvestment, betsKeys.length, totalWin);
1412     }
1413 
1414     function getBet(uint id)
1415         constant
1416         returns(address, uint, uint) {
1417 
1418         if (id < betsKeys.length) {
1419             bytes32 betKey = betsKeys[id];
1420             return (bets[betKey].playerAddress, bets[betKey].amountBet, bets[betKey].numberRolled);
1421         }
1422     }
1423 
1424     function numBets()
1425         constant
1426         returns(uint) {
1427 
1428         return betsKeys.length;
1429     }
1430 
1431     function getMinBetAmount()
1432         constant
1433         returns(uint) {
1434 
1435         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
1436         return oraclizeFee + minBet;
1437     }
1438 
1439     function getMaxBetAmount()
1440         constant
1441         returns(uint) {
1442 
1443         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
1444         uint betValue =  (maxWin * getBankroll()) * pwin / (10000 * (10000 - edge - pwin));
1445         return betValue + oraclizeFee;
1446     }
1447 
1448     function getLossesShare(address currentInvestor)
1449         constant
1450         returns (uint) {
1451 
1452         return investors[investorIDs[currentInvestor]].amountInvested * (investorsLosses) / invested;
1453     }
1454 
1455     function getProfitShare(address currentInvestor)
1456         constant
1457         returns (uint) {
1458 
1459         return investors[investorIDs[currentInvestor]].amountInvested * (investorsProfit) / invested;
1460     }
1461 
1462     function getBalance(address currentInvestor)
1463         constant
1464         returns (uint) {
1465 
1466         uint invested = investors[investorIDs[currentInvestor]].amountInvested;
1467         uint profit = getProfitShare(currentInvestor);
1468         uint losses = getLossesShare(currentInvestor);
1469 
1470         if ((invested + profit < profit) ||
1471             (invested + profit < invested) ||
1472             (invested + profit < losses))
1473             return 0;
1474         else
1475             return invested + profit - losses;
1476     }
1477 
1478     function searchSmallestInvestor()
1479         constant
1480         returns(uint) {
1481 
1482         uint investorID = 1;
1483         for (uint i = 1; i <= numInvestors; i++) {
1484             if (getBalance(investors[i].investorAddress) < getBalance(investors[investorID].investorAddress)) {
1485                 investorID = i;
1486             }
1487         }
1488 
1489         return investorID;
1490     }
1491 
1492     function changeOraclizeProofType(byte _proofType)
1493         onlyOwner {
1494 
1495         if (_proofType == 0x00) throw;
1496         oraclize_setProof( _proofType |  proofStorage_IPFS );
1497     }
1498 
1499 
1500     // PRIVATE HELPERS FUNCTION
1501 
1502     function safeSend(address addr, uint value)
1503         private {
1504 
1505         if (value == 0) {
1506             LOG_ZeroSend();
1507             return;
1508         }
1509 
1510         if (this.balance < value) {
1511             LOG_ValueIsTooBig();
1512             return;
1513         }
1514 
1515         if (!(addr.call.gas(safeGas).value(value)())) {
1516             LOG_FailedSend(addr, value);
1517             if (addr != houseAddress) {
1518                 //Forward to house address all change
1519                 if (!(houseAddress.call.gas(safeGas).value(value)())) LOG_FailedSend(houseAddress, value);
1520             }
1521         }
1522 
1523         LOG_SuccessfulSend(addr,value);
1524     }
1525 
1526     function addInvestorAtID(uint id)
1527         private {
1528 
1529         investorIDs[msg.sender] = id;
1530         investors[id].investorAddress = msg.sender;
1531         investors[id].amountInvested = msg.value;
1532         invested += msg.value;
1533 
1534         LOG_InvestorEntrance(msg.sender, msg.value);
1535     }
1536 
1537     function profitDistribution()
1538         private
1539         onlyIfProfitNotDistributed {
1540 
1541         uint copyInvested;
1542 
1543         for (uint i = 1; i <= numInvestors; i++) {
1544             address currentInvestor = investors[i].investorAddress;
1545             uint profitOfInvestor = getProfitShare(currentInvestor);
1546             uint lossesOfInvestor = getLossesShare(currentInvestor);
1547             //Check for overflow and underflow
1548             if ((investors[i].amountInvested + profitOfInvestor >= investors[i].amountInvested) &&
1549                 (investors[i].amountInvested + profitOfInvestor >= lossesOfInvestor))  {
1550                 investors[i].amountInvested += profitOfInvestor - lossesOfInvestor;
1551                 LOG_InvestorCapitalUpdate(currentInvestor, (int) (profitOfInvestor - lossesOfInvestor));
1552             }
1553             else {
1554                 isStopped = true;
1555                 LOG_EmergencyAutoStop();
1556             }
1557 
1558             if (copyInvested + investors[i].amountInvested >= copyInvested)
1559                 copyInvested += investors[i].amountInvested;
1560         }
1561 
1562         delete investorsProfit;
1563         delete investorsLosses;
1564         invested = copyInvested;
1565 
1566         profitDistributed = true;
1567     }
1568 
1569     // SECTION II: BET & BET PROCESSING
1570 
1571     function()
1572         payable {
1573 
1574         bet();
1575     }
1576 
1577     function bet()
1578         payable
1579         onlyIfNotStopped {
1580 
1581         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
1582         if (oraclizeFee >= msg.value) throw;
1583         uint betValue = msg.value - oraclizeFee;
1584         if ((((betValue * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000) && (betValue >= minBet)) {
1585             LOG_NewBet(msg.sender, betValue);
1586 
1587             string memory str1 = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random.data.0', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":\"";
1588             string memory str2 = randomOrgAPIKey;
1589             string memory str3 = "\",\"n\":1,\"min\":1,\"max\":10000${[identity] \"}\"},\"id\":1${[identity] \"}\"}']";
1590             string memory query = strConcat(str1, str2, str3);
1591 
1592             bytes32 myid =
1593                 oraclize_query(
1594                     "nested",
1595                     query,
1596                     ORACLIZE_GAS_LIMIT + safeGas
1597                 );
1598             bets[myid] = Bet(msg.sender, betValue, 0);
1599             betsKeys.push(myid);
1600         }
1601         else {
1602             throw;
1603         }
1604     }
1605 
1606     function __callback(bytes32 myid, string result, bytes proof)
1607         onlyOraclize
1608         onlyIfBetExist(myid)
1609         onlyIfNotProcessed(myid)
1610         onlyIfValidRoll(myid, result)
1611         onlyIfBetSizeIsStillCorrect(myid)  {
1612 
1613         uint numberRolled = parseInt(result);
1614         bets[myid].numberRolled = numberRolled;
1615         isWinningBet(bets[myid], numberRolled);
1616         isLosingBet(bets[myid], numberRolled);
1617         delete profitDistributed;
1618     }
1619 
1620     function isWinningBet(Bet thisBet, uint numberRolled)
1621         private
1622         onlyWinningBets(numberRolled) {
1623 
1624         uint winAmount = (thisBet.amountBet * (10000 - edge)) / pwin;
1625         LOG_BetWon(thisBet.playerAddress, numberRolled, winAmount);
1626         safeSend(thisBet.playerAddress, winAmount);
1627 
1628         totalWin += winAmount - thisBet.amountBet;
1629         //Check for overflow and underflow
1630         if ((investorsLosses + winAmount < investorsLosses) ||
1631             (investorsLosses + winAmount < thisBet.amountBet)) {
1632                 throw;
1633             }
1634 
1635         investorsLosses += winAmount - thisBet.amountBet;
1636     }
1637 
1638     function isLosingBet(Bet thisBet, uint numberRolled)
1639         private
1640         onlyLosingBets(numberRolled) {
1641 
1642         LOG_BetLost(thisBet.playerAddress, numberRolled);
1643         safeSend(thisBet.playerAddress, 1);
1644 
1645         //Check for overflow and underflow
1646         if ((investorsProfit + thisBet.amountBet < investorsProfit) ||
1647             (investorsProfit + thisBet.amountBet < thisBet.amountBet) ||
1648             (thisBet.amountBet == 1)) {
1649                 throw;
1650             }
1651 
1652         uint totalProfit = investorsProfit + (thisBet.amountBet - 1); //added based on audit feedback
1653         investorsProfit += (thisBet.amountBet - 1)*(10000 - houseEdge)/10000;
1654         uint houseProfit = totalProfit - investorsProfit; //changed based on audit feedback
1655         safeSend(houseAddress, houseProfit);
1656     }
1657 
1658     //SECTION III: INVEST & DIVEST
1659 
1660     function increaseInvestment()
1661         payable
1662         onlyIfNotStopped
1663         onlyMoreThanZero
1664         onlyInvestors  {
1665 
1666         profitDistribution();
1667         investors[investorIDs[msg.sender]].amountInvested += msg.value;
1668         invested += msg.value;
1669     }
1670 
1671     function newInvestor()
1672         payable
1673         onlyIfNotStopped
1674         onlyMoreThanZero
1675         onlyNotInvestors
1676         onlyMoreThanMinInvestment
1677         investorsInvariant {
1678 
1679         profitDistribution();
1680 
1681         if (numInvestors == maxInvestors) {
1682             uint smallestInvestorID = searchSmallestInvestor();
1683             divest(investors[smallestInvestorID].investorAddress);
1684         }
1685 
1686         numInvestors++;
1687         addInvestorAtID(numInvestors);
1688     }
1689 
1690     function divest()
1691         onlyInvestors {
1692 
1693         divest(msg.sender);
1694     }
1695 
1696 
1697     function divest(address currentInvestor)
1698         private
1699         investorsInvariant {
1700 
1701         profitDistribution();
1702         uint currentID = investorIDs[currentInvestor];
1703         uint amountToReturn = getBalance(currentInvestor);
1704 
1705         if ((invested >= investors[currentID].amountInvested)) {
1706             invested -= investors[currentID].amountInvested;
1707             uint divestFeeAmount =  (amountToReturn*divestFee)/10000;
1708             amountToReturn -= divestFeeAmount;
1709 
1710             delete investors[currentID];
1711             delete investorIDs[currentInvestor];
1712 
1713             //Reorder investors
1714             if (currentID != numInvestors) {
1715                 // Get last investor
1716                 Investor lastInvestor = investors[numInvestors];
1717                 //Set last investor ID to investorID of divesting account
1718                 investorIDs[lastInvestor.investorAddress] = currentID;
1719                 //Copy investor at the new position in the mapping
1720                 investors[currentID] = lastInvestor;
1721                 //Delete old position in the mappping
1722                 delete investors[numInvestors];
1723             }
1724 
1725             numInvestors--;
1726             safeSend(currentInvestor, amountToReturn);
1727             safeSend(houseAddress, divestFeeAmount);
1728             LOG_InvestorExit(currentInvestor, amountToReturn);
1729         } else {
1730             isStopped = true;
1731             LOG_EmergencyAutoStop();
1732         }
1733     }
1734 
1735     function forceDivestOfAllInvestors()
1736         onlyOwner {
1737 
1738         uint copyNumInvestors = numInvestors;
1739         for (uint i = 1; i <= copyNumInvestors; i++) {
1740             divest(investors[1].investorAddress);
1741         }
1742     }
1743 
1744     /*
1745     The owner can use this function to force the exit of an investor from the
1746     contract during an emergency withdrawal in the following situations:
1747         - Unresponsive investor
1748         - Investor demanding to be paid in other to vote, the facto-blackmailing
1749         other investors
1750     */
1751     function forceDivestOfOneInvestor(address currentInvestor)
1752         onlyOwner
1753         onlyIfStopped {
1754 
1755         divest(currentInvestor);
1756         //Resets emergency withdrawal proposal. Investors must vote again
1757         delete proposedWithdrawal;
1758     }
1759 
1760     //SECTION IV: CONTRACT MANAGEMENT
1761 
1762     function stopContract()
1763         onlyOwner {
1764 
1765         isStopped = true;
1766         LOG_ContractStopped();
1767     }
1768 
1769     function resumeContract()
1770         onlyOwner {
1771 
1772         isStopped = false;
1773         LOG_ContractResumed();
1774     }
1775 
1776     function changeHouseAddress(address newHouse)
1777         onlyOwner {
1778 
1779         if (newHouse == address(0x0)) throw; //changed based on audit feedback
1780         houseAddress = newHouse;
1781         LOG_HouseAddressChanged(houseAddress, newHouse);
1782     }
1783 
1784     function changeRandomOrgAPIKey(string newKey) 
1785         onlyOwner {
1786 
1787         string oldKey = randomOrgAPIKey;
1788         randomOrgAPIKey = newKey;
1789         LOG_RandomOrgAPIKeyChanged(oldKey, newKey);
1790     }
1791     function changeOwnerAddress(address newOwner)
1792         onlyOwner {
1793 
1794         if (newOwner == address(0x0)) throw;
1795         owner = newOwner;
1796         LOG_OwnerAddressChanged(owner, newOwner);
1797     }
1798 
1799     function changeGasLimitOfSafeSend(uint newGasLimit)
1800         onlyOwner
1801         onlyIfValidGas(newGasLimit) {
1802 
1803         safeGas = newGasLimit;
1804         LOG_GasLimitChanged(safeGas, newGasLimit);
1805     }
1806 
1807     //SECTION V: EMERGENCY WITHDRAWAL
1808 
1809     function voteEmergencyWithdrawal(bool vote)
1810         onlyInvestors
1811         onlyAfterProposed
1812         onlyIfStopped {
1813 
1814         investors[investorIDs[msg.sender]].votedForEmergencyWithdrawal = vote;
1815         LOG_EmergencyWithdrawalVote(msg.sender, vote);
1816     }
1817 
1818     function proposeEmergencyWithdrawal(address withdrawalAddress)
1819         onlyIfStopped
1820         onlyOwner {
1821 
1822         //Resets previous votes
1823         for (uint i = 1; i <= numInvestors; i++) {
1824             delete investors[i].votedForEmergencyWithdrawal;
1825         }
1826 
1827         proposedWithdrawal = WithdrawalProposal(withdrawalAddress, now);
1828         LOG_EmergencyWithdrawalProposed();
1829     }
1830 
1831     function executeEmergencyWithdrawal()
1832         onlyOwner
1833         onlyAfterProposed
1834         onlyIfStopped
1835         onlyIfEmergencyTimeOutHasPassed {
1836 
1837         uint numOfVotesInFavour;
1838         uint amountToWithdraw = this.balance;
1839 
1840         for (uint i = 1; i <= numInvestors; i++) {
1841             if (investors[i].votedForEmergencyWithdrawal == true) {
1842                 numOfVotesInFavour++;
1843                 delete investors[i].votedForEmergencyWithdrawal;
1844             }
1845         }
1846 
1847         if (numOfVotesInFavour >= emergencyWithdrawalRatio * numInvestors / 100) {
1848             if (!proposedWithdrawal.toAddress.send(amountToWithdraw)) {
1849                 LOG_EmergencyWithdrawalFailed(proposedWithdrawal.toAddress);
1850             }
1851             else {
1852                 LOG_EmergencyWithdrawalSucceeded(proposedWithdrawal.toAddress, amountToWithdraw);
1853             }
1854         }
1855         else {
1856             throw;
1857         }
1858     }
1859 
1860 }