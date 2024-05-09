1 pragma solidity ^0.4.25;
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
22 library Buffer {
23     struct buffer {
24         bytes buf;
25         uint capacity;
26     }
27 
28     function init(buffer memory buf, uint _capacity) internal pure {
29         uint capacity = _capacity;
30         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
31         // Allocate space for the buffer data
32         buf.capacity = capacity;
33         assembly {
34             let ptr := mload(0x40)
35             mstore(buf, ptr)
36             mstore(ptr, 0)
37             mstore(0x40, add(ptr, capacity))
38         }
39     }
40 
41     function resize(buffer memory buf, uint capacity) private pure {
42         bytes memory oldbuf = buf.buf;
43         init(buf, capacity);
44         append(buf, oldbuf);
45     }
46 
47     function max(uint a, uint b) private pure returns(uint) {
48         if(a > b) {
49             return a;
50         }
51         return b;
52     }
53 
54     /**
55      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
56      *      would exceed the capacity of the buffer.
57      * @param buf The buffer to append to.
58      * @param data The data to append.
59      * @return The original buffer.
60      */
61     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
62         if(data.length + buf.buf.length > buf.capacity) {
63             resize(buf, max(buf.capacity, data.length) * 2);
64         }
65 
66         uint dest;
67         uint src;
68         uint len = data.length;
69         assembly {
70             // Memory address of the buffer data
71             let bufptr := mload(buf)
72             // Length of existing buffer data
73             let buflen := mload(bufptr)
74             // Start address = buffer address + buffer length + sizeof(buffer length)
75             dest := add(add(bufptr, buflen), 32)
76             // Update buffer length
77             mstore(bufptr, add(buflen, mload(data)))
78             src := add(data, 32)
79         }
80 
81         // Copy word-length chunks while possible
82         for(; len >= 32; len -= 32) {
83             assembly {
84                 mstore(dest, mload(src))
85             }
86             dest += 32;
87             src += 32;
88         }
89 
90         // Copy remaining bytes
91         uint mask = 256 ** (32 - len) - 1;
92         assembly {
93             let srcpart := and(mload(src), not(mask))
94             let destpart := and(mload(dest), mask)
95             mstore(dest, or(destpart, srcpart))
96         }
97 
98         return buf;
99     }
100 
101     /**
102      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
103      * exceed the capacity of the buffer.
104      * @param buf The buffer to append to.
105      * @param data The data to append.
106      * @return The original buffer.
107      */
108     function append(buffer memory buf, uint8 data) internal pure {
109         if(buf.buf.length + 1 > buf.capacity) {
110             resize(buf, buf.capacity * 2);
111         }
112 
113         assembly {
114             // Memory address of the buffer data
115             let bufptr := mload(buf)
116             // Length of existing buffer data
117             let buflen := mload(bufptr)
118             // Address = buffer address + buffer length + sizeof(buffer length)
119             let dest := add(add(bufptr, buflen), 32)
120             mstore8(dest, data)
121             // Update buffer length
122             mstore(bufptr, add(buflen, 1))
123         }
124     }
125 
126     /**
127      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
128      * exceed the capacity of the buffer.
129      * @param buf The buffer to append to.
130      * @param data The data to append.
131      * @return The original buffer.
132      */
133     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
134         if(len + buf.buf.length > buf.capacity) {
135             resize(buf, max(buf.capacity, len) * 2);
136         }
137 
138         uint mask = 256 ** len - 1;
139         assembly {
140             // Memory address of the buffer data
141             let bufptr := mload(buf)
142             // Length of existing buffer data
143             let buflen := mload(bufptr)
144             // Address = buffer address + buffer length + sizeof(buffer length) + len
145             let dest := add(add(bufptr, buflen), len)
146             mstore(dest, or(and(mload(dest), not(mask)), data))
147             // Update buffer length
148             mstore(bufptr, add(buflen, len))
149         }
150         return buf;
151     }
152 }
153 
154 library CBOR {
155     using Buffer for Buffer.buffer;
156 
157     uint8 private constant MAJOR_TYPE_INT = 0;
158     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
159     uint8 private constant MAJOR_TYPE_BYTES = 2;
160     uint8 private constant MAJOR_TYPE_STRING = 3;
161     uint8 private constant MAJOR_TYPE_ARRAY = 4;
162     uint8 private constant MAJOR_TYPE_MAP = 5;
163     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
164 
165     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
166         if(value <= 23) {
167             buf.append(uint8((major << 5) | value));
168         } else if(value <= 0xFF) {
169             buf.append(uint8((major << 5) | 24));
170             buf.appendInt(value, 1);
171         } else if(value <= 0xFFFF) {
172             buf.append(uint8((major << 5) | 25));
173             buf.appendInt(value, 2);
174         } else if(value <= 0xFFFFFFFF) {
175             buf.append(uint8((major << 5) | 26));
176             buf.appendInt(value, 4);
177         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
178             buf.append(uint8((major << 5) | 27));
179             buf.appendInt(value, 8);
180         }
181     }
182 
183     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
184         buf.append(uint8((major << 5) | 31));
185     }
186 
187     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
188         encodeType(buf, MAJOR_TYPE_INT, value);
189     }
190 
191     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
192         if(value >= 0) {
193             encodeType(buf, MAJOR_TYPE_INT, uint(value));
194         } else {
195             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
196         }
197     }
198 
199     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
200         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
201         buf.append(value);
202     }
203 
204     function encodeString(Buffer.buffer memory buf, string value) internal pure {
205         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
206         buf.append(bytes(value));
207     }
208 
209     function startArray(Buffer.buffer memory buf) internal pure {
210         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
211     }
212 
213     function startMap(Buffer.buffer memory buf) internal pure {
214         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
215     }
216 
217     function endSequence(Buffer.buffer memory buf) internal pure {
218         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
219     }
220 }
221 contract usingOraclize {
222     uint constant day = 60*60*24;
223     uint constant week = 60*60*24*7;
224     uint constant month = 60*60*24*30;
225     byte constant proofType_NONE = 0x00;
226     byte constant proofType_TLSNotary = 0x10;
227     byte constant proofType_Ledger = 0x30;
228     byte constant proofType_Android = 0x40;
229     byte constant proofType_Native = 0xF0;
230     byte constant proofStorage_IPFS = 0x01;
231     uint8 constant networkID_auto = 0;
232     uint8 constant networkID_mainnet = 1;
233     uint8 constant networkID_testnet = 2;
234     uint8 constant networkID_morden = 2;
235     uint8 constant networkID_consensys = 161;
236 
237     OraclizeAddrResolverI OAR;
238 
239     OraclizeI oraclize;
240     modifier oraclizeAPI {
241         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
242             oraclize_setNetwork(networkID_auto);
243 
244         if(address(oraclize) != OAR.getAddress())
245             oraclize = OraclizeI(OAR.getAddress());
246 
247         _;
248     }
249     modifier coupon(string code){
250         oraclize = OraclizeI(OAR.getAddress());
251         _;
252     }
253 
254     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
255       return oraclize_setNetwork();
256       networkID; // silence the warning and remain backwards compatible
257     }
258     function oraclize_setNetwork() internal returns(bool){
259         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
260             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
261             oraclize_setNetworkName("eth_mainnet");
262             return true;
263         }
264         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
265             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
266             oraclize_setNetworkName("eth_ropsten3");
267             return true;
268         }
269         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
270             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
271             oraclize_setNetworkName("eth_kovan");
272             return true;
273         }
274         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
275             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
276             oraclize_setNetworkName("eth_rinkeby");
277             return true;
278         }
279         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
280             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
281             return true;
282         }
283         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
284             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
285             return true;
286         }
287         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
288             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
289             return true;
290         }
291         return false;
292     }
293 
294     function __callback(bytes32 myid, string result) public {
295         __callback(myid, result, new bytes(0));
296     }
297     function __callback(bytes32 myid, string result, bytes proof) public {
298       return;
299       myid; result; proof; // Silence compiler warnings
300     }
301 
302     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
303         return oraclize.getPrice(datasource);
304     }
305 
306     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
307         return oraclize.getPrice(datasource, gaslimit);
308     }
309 
310     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
311         uint price = oraclize.getPrice(datasource);
312         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
313         return oraclize.query.value(price)(0, datasource, arg);
314     }
315     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
316         uint price = oraclize.getPrice(datasource);
317         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
318         return oraclize.query.value(price)(timestamp, datasource, arg);
319     }
320     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
321         uint price = oraclize.getPrice(datasource, gaslimit);
322         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
323         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
324     }
325     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
326         uint price = oraclize.getPrice(datasource, gaslimit);
327         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
328         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
329     }
330     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
331         uint price = oraclize.getPrice(datasource);
332         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
333         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
334     }
335     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
336         uint price = oraclize.getPrice(datasource);
337         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
338         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
339     }
340     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
341         uint price = oraclize.getPrice(datasource, gaslimit);
342         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
343         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
344     }
345     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
346         uint price = oraclize.getPrice(datasource, gaslimit);
347         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
348         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
349     }
350     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
351         uint price = oraclize.getPrice(datasource);
352         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
353         bytes memory args = stra2cbor(argN);
354         return oraclize.queryN.value(price)(0, datasource, args);
355     }
356     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
357         uint price = oraclize.getPrice(datasource);
358         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
359         bytes memory args = stra2cbor(argN);
360         return oraclize.queryN.value(price)(timestamp, datasource, args);
361     }
362     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
363         uint price = oraclize.getPrice(datasource, gaslimit);
364         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
365         bytes memory args = stra2cbor(argN);
366         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
367     }
368     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
369         uint price = oraclize.getPrice(datasource, gaslimit);
370         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
371         bytes memory args = stra2cbor(argN);
372         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
373     }
374     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
375         string[] memory dynargs = new string[](1);
376         dynargs[0] = args[0];
377         return oraclize_query(datasource, dynargs);
378     }
379     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
380         string[] memory dynargs = new string[](1);
381         dynargs[0] = args[0];
382         return oraclize_query(timestamp, datasource, dynargs);
383     }
384     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
385         string[] memory dynargs = new string[](1);
386         dynargs[0] = args[0];
387         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
388     }
389     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
390         string[] memory dynargs = new string[](1);
391         dynargs[0] = args[0];
392         return oraclize_query(datasource, dynargs, gaslimit);
393     }
394 
395     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
396         string[] memory dynargs = new string[](2);
397         dynargs[0] = args[0];
398         dynargs[1] = args[1];
399         return oraclize_query(datasource, dynargs);
400     }
401     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
402         string[] memory dynargs = new string[](2);
403         dynargs[0] = args[0];
404         dynargs[1] = args[1];
405         return oraclize_query(timestamp, datasource, dynargs);
406     }
407     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
408         string[] memory dynargs = new string[](2);
409         dynargs[0] = args[0];
410         dynargs[1] = args[1];
411         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
412     }
413     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
414         string[] memory dynargs = new string[](2);
415         dynargs[0] = args[0];
416         dynargs[1] = args[1];
417         return oraclize_query(datasource, dynargs, gaslimit);
418     }
419     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
420         string[] memory dynargs = new string[](3);
421         dynargs[0] = args[0];
422         dynargs[1] = args[1];
423         dynargs[2] = args[2];
424         return oraclize_query(datasource, dynargs);
425     }
426     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
427         string[] memory dynargs = new string[](3);
428         dynargs[0] = args[0];
429         dynargs[1] = args[1];
430         dynargs[2] = args[2];
431         return oraclize_query(timestamp, datasource, dynargs);
432     }
433     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
434         string[] memory dynargs = new string[](3);
435         dynargs[0] = args[0];
436         dynargs[1] = args[1];
437         dynargs[2] = args[2];
438         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
439     }
440     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441         string[] memory dynargs = new string[](3);
442         dynargs[0] = args[0];
443         dynargs[1] = args[1];
444         dynargs[2] = args[2];
445         return oraclize_query(datasource, dynargs, gaslimit);
446     }
447 
448     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
449         string[] memory dynargs = new string[](4);
450         dynargs[0] = args[0];
451         dynargs[1] = args[1];
452         dynargs[2] = args[2];
453         dynargs[3] = args[3];
454         return oraclize_query(datasource, dynargs);
455     }
456     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
457         string[] memory dynargs = new string[](4);
458         dynargs[0] = args[0];
459         dynargs[1] = args[1];
460         dynargs[2] = args[2];
461         dynargs[3] = args[3];
462         return oraclize_query(timestamp, datasource, dynargs);
463     }
464     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
465         string[] memory dynargs = new string[](4);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         dynargs[2] = args[2];
469         dynargs[3] = args[3];
470         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
471     }
472     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
473         string[] memory dynargs = new string[](4);
474         dynargs[0] = args[0];
475         dynargs[1] = args[1];
476         dynargs[2] = args[2];
477         dynargs[3] = args[3];
478         return oraclize_query(datasource, dynargs, gaslimit);
479     }
480     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
481         string[] memory dynargs = new string[](5);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         dynargs[2] = args[2];
485         dynargs[3] = args[3];
486         dynargs[4] = args[4];
487         return oraclize_query(datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
490         string[] memory dynargs = new string[](5);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         dynargs[2] = args[2];
494         dynargs[3] = args[3];
495         dynargs[4] = args[4];
496         return oraclize_query(timestamp, datasource, dynargs);
497     }
498     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
499         string[] memory dynargs = new string[](5);
500         dynargs[0] = args[0];
501         dynargs[1] = args[1];
502         dynargs[2] = args[2];
503         dynargs[3] = args[3];
504         dynargs[4] = args[4];
505         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
506     }
507     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
508         string[] memory dynargs = new string[](5);
509         dynargs[0] = args[0];
510         dynargs[1] = args[1];
511         dynargs[2] = args[2];
512         dynargs[3] = args[3];
513         dynargs[4] = args[4];
514         return oraclize_query(datasource, dynargs, gaslimit);
515     }
516     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
517         uint price = oraclize.getPrice(datasource);
518         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
519         bytes memory args = ba2cbor(argN);
520         return oraclize.queryN.value(price)(0, datasource, args);
521     }
522     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
523         uint price = oraclize.getPrice(datasource);
524         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
525         bytes memory args = ba2cbor(argN);
526         return oraclize.queryN.value(price)(timestamp, datasource, args);
527     }
528     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
529         uint price = oraclize.getPrice(datasource, gaslimit);
530         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
531         bytes memory args = ba2cbor(argN);
532         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
533     }
534     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
535         uint price = oraclize.getPrice(datasource, gaslimit);
536         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
537         bytes memory args = ba2cbor(argN);
538         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
539     }
540     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
541         bytes[] memory dynargs = new bytes[](1);
542         dynargs[0] = args[0];
543         return oraclize_query(datasource, dynargs);
544     }
545     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
546         bytes[] memory dynargs = new bytes[](1);
547         dynargs[0] = args[0];
548         return oraclize_query(timestamp, datasource, dynargs);
549     }
550     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
551         bytes[] memory dynargs = new bytes[](1);
552         dynargs[0] = args[0];
553         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
554     }
555     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
556         bytes[] memory dynargs = new bytes[](1);
557         dynargs[0] = args[0];
558         return oraclize_query(datasource, dynargs, gaslimit);
559     }
560 
561     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
562         bytes[] memory dynargs = new bytes[](2);
563         dynargs[0] = args[0];
564         dynargs[1] = args[1];
565         return oraclize_query(datasource, dynargs);
566     }
567     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
568         bytes[] memory dynargs = new bytes[](2);
569         dynargs[0] = args[0];
570         dynargs[1] = args[1];
571         return oraclize_query(timestamp, datasource, dynargs);
572     }
573     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
574         bytes[] memory dynargs = new bytes[](2);
575         dynargs[0] = args[0];
576         dynargs[1] = args[1];
577         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
578     }
579     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
580         bytes[] memory dynargs = new bytes[](2);
581         dynargs[0] = args[0];
582         dynargs[1] = args[1];
583         return oraclize_query(datasource, dynargs, gaslimit);
584     }
585     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
586         bytes[] memory dynargs = new bytes[](3);
587         dynargs[0] = args[0];
588         dynargs[1] = args[1];
589         dynargs[2] = args[2];
590         return oraclize_query(datasource, dynargs);
591     }
592     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
593         bytes[] memory dynargs = new bytes[](3);
594         dynargs[0] = args[0];
595         dynargs[1] = args[1];
596         dynargs[2] = args[2];
597         return oraclize_query(timestamp, datasource, dynargs);
598     }
599     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
600         bytes[] memory dynargs = new bytes[](3);
601         dynargs[0] = args[0];
602         dynargs[1] = args[1];
603         dynargs[2] = args[2];
604         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
605     }
606     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
607         bytes[] memory dynargs = new bytes[](3);
608         dynargs[0] = args[0];
609         dynargs[1] = args[1];
610         dynargs[2] = args[2];
611         return oraclize_query(datasource, dynargs, gaslimit);
612     }
613 
614     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
615         bytes[] memory dynargs = new bytes[](4);
616         dynargs[0] = args[0];
617         dynargs[1] = args[1];
618         dynargs[2] = args[2];
619         dynargs[3] = args[3];
620         return oraclize_query(datasource, dynargs);
621     }
622     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
623         bytes[] memory dynargs = new bytes[](4);
624         dynargs[0] = args[0];
625         dynargs[1] = args[1];
626         dynargs[2] = args[2];
627         dynargs[3] = args[3];
628         return oraclize_query(timestamp, datasource, dynargs);
629     }
630     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
631         bytes[] memory dynargs = new bytes[](4);
632         dynargs[0] = args[0];
633         dynargs[1] = args[1];
634         dynargs[2] = args[2];
635         dynargs[3] = args[3];
636         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
637     }
638     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
639         bytes[] memory dynargs = new bytes[](4);
640         dynargs[0] = args[0];
641         dynargs[1] = args[1];
642         dynargs[2] = args[2];
643         dynargs[3] = args[3];
644         return oraclize_query(datasource, dynargs, gaslimit);
645     }
646     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
647         bytes[] memory dynargs = new bytes[](5);
648         dynargs[0] = args[0];
649         dynargs[1] = args[1];
650         dynargs[2] = args[2];
651         dynargs[3] = args[3];
652         dynargs[4] = args[4];
653         return oraclize_query(datasource, dynargs);
654     }
655     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
656         bytes[] memory dynargs = new bytes[](5);
657         dynargs[0] = args[0];
658         dynargs[1] = args[1];
659         dynargs[2] = args[2];
660         dynargs[3] = args[3];
661         dynargs[4] = args[4];
662         return oraclize_query(timestamp, datasource, dynargs);
663     }
664     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
665         bytes[] memory dynargs = new bytes[](5);
666         dynargs[0] = args[0];
667         dynargs[1] = args[1];
668         dynargs[2] = args[2];
669         dynargs[3] = args[3];
670         dynargs[4] = args[4];
671         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
672     }
673     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
674         bytes[] memory dynargs = new bytes[](5);
675         dynargs[0] = args[0];
676         dynargs[1] = args[1];
677         dynargs[2] = args[2];
678         dynargs[3] = args[3];
679         dynargs[4] = args[4];
680         return oraclize_query(datasource, dynargs, gaslimit);
681     }
682 
683     function oraclize_cbAddress() oraclizeAPI internal returns (address){
684         return oraclize.cbAddress();
685     }
686     function oraclize_setProof(byte proofP) oraclizeAPI internal {
687         return oraclize.setProofType(proofP);
688     }
689     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
690         return oraclize.setCustomGasPrice(gasPrice);
691     }
692 
693     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
694         return oraclize.randomDS_getSessionPubKeyHash();
695     }
696 
697     function getCodeSize(address _addr) constant internal returns(uint _size) {
698         assembly {
699             _size := extcodesize(_addr)
700         }
701     }
702 
703     function parseAddr(string _a) internal pure returns (address){
704         bytes memory tmp = bytes(_a);
705         uint160 iaddr = 0;
706         uint160 b1;
707         uint160 b2;
708         for (uint i=2; i<2+2*20; i+=2){
709             iaddr *= 256;
710             b1 = uint160(tmp[i]);
711             b2 = uint160(tmp[i+1]);
712             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
713             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
714             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
715             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
716             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
717             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
718             iaddr += (b1*16+b2);
719         }
720         return address(iaddr);
721     }
722 
723     function strCompare(string _a, string _b) internal pure returns (int) {
724         bytes memory a = bytes(_a);
725         bytes memory b = bytes(_b);
726         uint minLength = a.length;
727         if (b.length < minLength) minLength = b.length;
728         for (uint i = 0; i < minLength; i ++)
729             if (a[i] < b[i])
730                 return -1;
731             else if (a[i] > b[i])
732                 return 1;
733         if (a.length < b.length)
734             return -1;
735         else if (a.length > b.length)
736             return 1;
737         else
738             return 0;
739     }
740 
741     function indexOf(string _haystack, string _needle) internal pure returns (int) {
742         bytes memory h = bytes(_haystack);
743         bytes memory n = bytes(_needle);
744         if(h.length < 1 || n.length < 1 || (n.length > h.length))
745             return -1;
746         else if(h.length > (2**128 -1))
747             return -1;
748         else
749         {
750             uint subindex = 0;
751             for (uint i = 0; i < h.length; i ++)
752             {
753                 if (h[i] == n[0])
754                 {
755                     subindex = 1;
756                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
757                     {
758                         subindex++;
759                     }
760                     if(subindex == n.length)
761                         return int(i);
762                 }
763             }
764             return -1;
765         }
766     }
767 
768     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
769         bytes memory _ba = bytes(_a);
770         bytes memory _bb = bytes(_b);
771         bytes memory _bc = bytes(_c);
772         bytes memory _bd = bytes(_d);
773         bytes memory _be = bytes(_e);
774         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
775         bytes memory babcde = bytes(abcde);
776         uint k = 0;
777         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
778         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
779         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
780         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
781         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
782         return string(babcde);
783     }
784 
785     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
786         return strConcat(_a, _b, _c, _d, "");
787     }
788 
789     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
790         return strConcat(_a, _b, _c, "", "");
791     }
792 
793     function strConcat(string _a, string _b) internal pure returns (string) {
794         return strConcat(_a, _b, "", "", "");
795     }
796 
797     // parseInt
798     function parseInt(string _a) internal pure returns (uint) {
799         return parseInt(_a, 0);
800     }
801 
802     // parseInt(parseFloat*10^_b)
803     function parseInt(string _a, uint _b) internal pure returns (uint) {
804         bytes memory bresult = bytes(_a);
805         uint mint = 0;
806         bool decimals = false;
807         for (uint i=0; i<bresult.length; i++){
808             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
809                 if (decimals){
810                    if (_b == 0) break;
811                     else _b--;
812                 }
813                 mint *= 10;
814                 mint += uint(bresult[i]) - 48;
815             } else if (bresult[i] == 46) decimals = true;
816         }
817         if (_b > 0) mint *= 10**_b;
818         return mint;
819     }
820 
821     function uint2str(uint i) internal pure returns (string){
822         if (i == 0) return "0";
823         uint j = i;
824         uint len;
825         while (j != 0){
826             len++;
827             j /= 10;
828         }
829         bytes memory bstr = new bytes(len);
830         uint k = len - 1;
831         while (i != 0){
832             bstr[k--] = byte(48 + i % 10);
833             i /= 10;
834         }
835         return string(bstr);
836     }
837 
838     using CBOR for Buffer.buffer;
839     function stra2cbor(string[] arr) internal pure returns (bytes) {
840         safeMemoryCleaner();
841         Buffer.buffer memory buf;
842         Buffer.init(buf, 1024);
843         buf.startArray();
844         for (uint i = 0; i < arr.length; i++) {
845             buf.encodeString(arr[i]);
846         }
847         buf.endSequence();
848         return buf.buf;
849     }
850 
851     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
852         safeMemoryCleaner();
853         Buffer.buffer memory buf;
854         Buffer.init(buf, 1024);
855         buf.startArray();
856         for (uint i = 0; i < arr.length; i++) {
857             buf.encodeBytes(arr[i]);
858         }
859         buf.endSequence();
860         return buf.buf;
861     }
862 
863     string oraclize_network_name;
864     function oraclize_setNetworkName(string _network_name) internal {
865         oraclize_network_name = _network_name;
866     }
867 
868     function oraclize_getNetworkName() internal view returns (string) {
869         return oraclize_network_name;
870     }
871 
872     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
873         require((_nbytes > 0) && (_nbytes <= 32));
874         // Convert from seconds to ledger timer ticks
875         _delay *= 10;
876         bytes memory nbytes = new bytes(1);
877         nbytes[0] = byte(_nbytes);
878         bytes memory unonce = new bytes(32);
879         bytes memory sessionKeyHash = new bytes(32);
880         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
881         assembly {
882             mstore(unonce, 0x20)
883             // the following variables can be relaxed
884             // check relaxed random contract under ethereum-examples repo
885             // for an idea on how to override and replace comit hash vars
886             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
887             mstore(sessionKeyHash, 0x20)
888             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
889         }
890         bytes memory delay = new bytes(32);
891         assembly {
892             mstore(add(delay, 0x20), _delay)
893         }
894 
895         bytes memory delay_bytes8 = new bytes(8);
896         copyBytes(delay, 24, 8, delay_bytes8, 0);
897 
898         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
899         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
900 
901         bytes memory delay_bytes8_left = new bytes(8);
902 
903         assembly {
904             let x := mload(add(delay_bytes8, 0x20))
905             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
906             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
907             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
908             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
909             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
910             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
911             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
912             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
913 
914         }
915 
916         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
917         return queryId;
918     }
919 
920     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
921         oraclize_randomDS_args[queryId] = commitment;
922     }
923 
924     mapping(bytes32=>bytes32) oraclize_randomDS_args;
925     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
926 
927     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
928         bool sigok;
929         address signer;
930 
931         bytes32 sigr;
932         bytes32 sigs;
933 
934         bytes memory sigr_ = new bytes(32);
935         uint offset = 4+(uint(dersig[3]) - 0x20);
936         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
937         bytes memory sigs_ = new bytes(32);
938         offset += 32 + 2;
939         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
940 
941         assembly {
942             sigr := mload(add(sigr_, 32))
943             sigs := mload(add(sigs_, 32))
944         }
945 
946 
947         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
948         if (address(keccak256(pubkey)) == signer) return true;
949         else {
950             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
951             return (address(keccak256(pubkey)) == signer);
952         }
953     }
954 
955     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
956         bool sigok;
957 
958         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
959         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
960         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
961 
962         bytes memory appkey1_pubkey = new bytes(64);
963         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
964 
965         bytes memory tosign2 = new bytes(1+65+32);
966         tosign2[0] = byte(1); //role
967         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
968         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
969         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
970         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
971 
972         if (sigok == false) return false;
973 
974 
975         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
976         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
977 
978         bytes memory tosign3 = new bytes(1+65);
979         tosign3[0] = 0xFE;
980         copyBytes(proof, 3, 65, tosign3, 1);
981 
982         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
983         copyBytes(proof, 3+65, sig3.length, sig3, 0);
984 
985         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
986 
987         return sigok;
988     }
989 
990     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
991         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
992         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
993 
994         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
995         require(proofVerified);
996 
997         _;
998     }
999 
1000     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1001         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1002         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1003 
1004         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1005         if (proofVerified == false) return 2;
1006 
1007         return 0;
1008     }
1009 
1010     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1011         bool match_ = true;
1012 
1013         require(prefix.length == n_random_bytes);
1014 
1015         for (uint256 i=0; i< n_random_bytes; i++) {
1016             if (content[i] != prefix[i]) match_ = false;
1017         }
1018 
1019         return match_;
1020     }
1021 
1022     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1023 
1024         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1025         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1026         bytes memory keyhash = new bytes(32);
1027         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1028         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1029 
1030         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1031         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1032 
1033         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1034         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1035 
1036         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1037         // This is to verify that the computed args match with the ones specified in the query.
1038         bytes memory commitmentSlice1 = new bytes(8+1+32);
1039         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1040 
1041         bytes memory sessionPubkey = new bytes(64);
1042         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1043         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1044 
1045         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1046         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1047             delete oraclize_randomDS_args[queryId];
1048         } else return false;
1049 
1050 
1051         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1052         bytes memory tosign1 = new bytes(32+8+1+32);
1053         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1054         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1055 
1056         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1057         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1058             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1059         }
1060 
1061         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1062     }
1063 
1064     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1065     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1066         uint minLength = length + toOffset;
1067 
1068         // Buffer too small
1069         require(to.length >= minLength); // Should be a better way?
1070 
1071         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1072         uint i = 32 + fromOffset;
1073         uint j = 32 + toOffset;
1074 
1075         while (i < (32 + fromOffset + length)) {
1076             assembly {
1077                 let tmp := mload(add(from, i))
1078                 mstore(add(to, j), tmp)
1079             }
1080             i += 32;
1081             j += 32;
1082         }
1083 
1084         return to;
1085     }
1086 
1087     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1088     // Duplicate Solidity's ecrecover, but catching the CALL return value
1089     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1090         // We do our own memory management here. Solidity uses memory offset
1091         // 0x40 to store the current end of memory. We write past it (as
1092         // writes are memory extensions), but don't update the offset so
1093         // Solidity will reuse it. The memory used here is only needed for
1094         // this context.
1095 
1096         // FIXME: inline assembly can't access return values
1097         bool ret;
1098         address addr;
1099 
1100         assembly {
1101             let size := mload(0x40)
1102             mstore(size, hash)
1103             mstore(add(size, 32), v)
1104             mstore(add(size, 64), r)
1105             mstore(add(size, 96), s)
1106 
1107             // NOTE: we can reuse the request memory because we deal with
1108             //       the return code
1109             ret := call(3000, 1, 0, size, 128, size, 32)
1110             addr := mload(size)
1111         }
1112 
1113         return (ret, addr);
1114     }
1115 
1116     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1117     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1118         bytes32 r;
1119         bytes32 s;
1120         uint8 v;
1121 
1122         if (sig.length != 65)
1123           return (false, 0);
1124 
1125         // The signature format is a compact form of:
1126         //   {bytes32 r}{bytes32 s}{uint8 v}
1127         // Compact means, uint8 is not padded to 32 bytes.
1128         assembly {
1129             r := mload(add(sig, 32))
1130             s := mload(add(sig, 64))
1131 
1132             // Here we are loading the last 32 bytes. We exploit the fact that
1133             // 'mload' will pad with zeroes if we overread.
1134             // There is no 'mload8' to do this, but that would be nicer.
1135             v := byte(0, mload(add(sig, 96)))
1136 
1137             // Alternative solution:
1138             // 'byte' is not working due to the Solidity parser, so lets
1139             // use the second best option, 'and'
1140             // v := and(mload(add(sig, 65)), 255)
1141         }
1142 
1143         // albeit non-transactional signatures are not specified by the YP, one would expect it
1144         // to match the YP range of [27, 28]
1145         //
1146         // geth uses [0, 1] and some clients have followed. This might change, see:
1147         //  https://github.com/ethereum/go-ethereum/issues/2053
1148         if (v < 27)
1149           v += 27;
1150 
1151         if (v != 27 && v != 28)
1152             return (false, 0);
1153 
1154         return safer_ecrecover(hash, v, r, s);
1155     }
1156 
1157     function safeMemoryCleaner() internal pure {
1158         assembly {
1159             let fmem := mload(0x40)
1160             codecopy(fmem, codesize, sub(msize, fmem))
1161         }
1162     }
1163 
1164 }
1165 
1166 
1167 contract owned {
1168     address public owner;
1169 
1170     constructor() public {
1171         owner = msg.sender;
1172     }
1173 
1174     modifier onlyOwner {
1175         require(msg.sender == owner);
1176         _;
1177     }
1178 
1179     function transferOwnership(address newOwner) onlyOwner public {
1180         owner = newOwner;
1181     }
1182 }
1183 
1184 contract BitrueRaffleNumber is usingOraclize,owned {
1185     
1186     event newRandomNumber_uint(uint random);
1187     
1188     uint public maxRange;
1189     uint numElements = 0;
1190     uint[] public randomArr;
1191     uint index = 1;
1192     RandomStruct[] public randomStructs;
1193     uint8 public pointer = 0;
1194     
1195     struct RandomStruct {
1196         uint year;
1197         uint month;
1198         uint day;
1199         uint n1;
1200         uint n2;
1201     }
1202     
1203     struct DateTime {
1204             uint16 year;
1205             uint8 month;
1206             uint8 day;
1207             uint8 hour;
1208             uint8 minute;
1209             uint8 second;
1210             uint8 weekday;
1211     }
1212 
1213     uint constant DAY_IN_SECONDS = 86400;
1214     uint constant YEAR_IN_SECONDS = 31536000;
1215     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
1216     uint constant HOUR_IN_SECONDS = 3600;
1217     uint constant MINUTE_IN_SECONDS = 60;
1218     uint16 constant ORIGIN_YEAR = 1970;
1219 
1220     constructor() {
1221         oraclize_setProof(proofType_Ledger); 
1222     }
1223     
1224 
1225     function __callback(bytes32 _queryId, string _result, bytes _proof)
1226     { 
1227         require(msg.sender == oraclize_cbAddress());
1228         
1229         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
1230             
1231         } else {
1232             if(index == 1){
1233                 maxRange = 10000;
1234             }else{
1235                 maxRange = 20;
1236             }
1237             
1238             uint randomNumber = uint(sha3(_result)) % maxRange;     
1239             emit newRandomNumber_uint(randomNumber);   
1240             insert(randomNumber);
1241             if(index == 2){
1242                 DateTime memory d = parseTimestamp(now);
1243                 uint y = d.year;
1244                 uint m = d.month;
1245                 uint da = d.day;
1246                 randomStructs.push(RandomStruct({year:y,month:m,day:da, n1:randomArr[0], n2:randomNumber}));
1247                 pointer++;
1248             }
1249             if(index == 1){
1250                 uint N = 4; 
1251                 uint delay = 0;
1252                 uint callbackGas = 400000;
1253                 oraclize_newRandomDSQuery(delay, N, callbackGas);
1254             }
1255             index++;
1256         }
1257     }
1258     
1259     function generateN() onlyOwner public payable{
1260         //check datemapping key is exist
1261         require(!checkDateExsit(now));
1262         clear();
1263         uint N = 4; 
1264         uint delay = 0;
1265         uint callbackGas = 400000;
1266         oraclize_newRandomDSQuery(delay, N, callbackGas);
1267     }
1268     
1269     function checkDateExsit(uint time) private returns(bool isExist){
1270         isExist = false;
1271         DateTime memory d = parseTimestamp(time);
1272         if(randomStructs.length > 0 && pointer >= 1){
1273             if( d.year == randomStructs[pointer-1].year &&
1274                 d.month == randomStructs[pointer-1].month &&
1275                 d.day == randomStructs[pointer-1].day){
1276                     isExist = true;
1277                 }else{
1278                     isExist = false;
1279                 }
1280         }
1281     }
1282     
1283     function insert(uint value) private{
1284         if(numElements == randomArr.length) {
1285             randomArr.length += 1;
1286         }
1287         randomArr[numElements++] = value;
1288     }
1289     
1290     function clear() private{
1291         maxRange = 10000;
1292         numElements = 0;
1293         index = 1;
1294     }
1295     
1296     function isLeapYear(uint16 year) private constant returns (bool) {
1297             if (year % 4 != 0) {
1298                     return false;
1299             }
1300             if (year % 100 != 0) {
1301                     return true;
1302             }
1303             if (year % 400 != 0) {
1304                     return false;
1305             }
1306             return true;
1307     }
1308 
1309     function parseTimestamp(uint timestamp) internal returns (DateTime dt) {
1310             uint secondsAccountedFor = 0;
1311             uint buf;
1312             uint8 i;
1313 
1314             dt.year = ORIGIN_YEAR;
1315 
1316             // Year
1317             while (true) {
1318                     if (isLeapYear(dt.year)) {
1319                             buf = LEAP_YEAR_IN_SECONDS;
1320                     }
1321                     else {
1322                             buf = YEAR_IN_SECONDS;
1323                     }
1324 
1325                     if (secondsAccountedFor + buf > timestamp) {
1326                             break;
1327                     }
1328                     dt.year += 1;
1329                     secondsAccountedFor += buf;
1330             }
1331 
1332             // Month
1333             uint8[12] monthDayCounts;
1334             monthDayCounts[0] = 31;
1335             if (isLeapYear(dt.year)) {
1336                     monthDayCounts[1] = 29;
1337             }
1338             else {
1339                     monthDayCounts[1] = 28;
1340             }
1341             monthDayCounts[2] = 31;
1342             monthDayCounts[3] = 30;
1343             monthDayCounts[4] = 31;
1344             monthDayCounts[5] = 30;
1345             monthDayCounts[6] = 31;
1346             monthDayCounts[7] = 31;
1347             monthDayCounts[8] = 30;
1348             monthDayCounts[9] = 31;
1349             monthDayCounts[10] = 30;
1350             monthDayCounts[11] = 31;
1351 
1352             uint secondsInMonth;
1353             for (i = 0; i < monthDayCounts.length; i++) {
1354                     secondsInMonth = DAY_IN_SECONDS * monthDayCounts[i];
1355                     if (secondsInMonth + secondsAccountedFor > timestamp) {
1356                             dt.month = i + 1;
1357                             break;
1358                     }
1359                     secondsAccountedFor += secondsInMonth;
1360             }
1361 
1362             // Day
1363             for (i = 0; i < monthDayCounts[dt.month - 1]; i++) {
1364                     if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
1365                             dt.day = i + 1;
1366                             break;
1367                     }
1368                     secondsAccountedFor += DAY_IN_SECONDS;
1369             }
1370 
1371             // Hour
1372             for (i = 0; i < 24; i++) {
1373                     if (HOUR_IN_SECONDS + secondsAccountedFor > timestamp) {
1374                             dt.hour = i;
1375                             break;
1376                     }
1377                     secondsAccountedFor += HOUR_IN_SECONDS;
1378             }
1379 
1380             // Minute
1381             for (i = 0; i < 60; i++) {
1382                     if (MINUTE_IN_SECONDS + secondsAccountedFor > timestamp) {
1383                             dt.minute = i;
1384                             break;
1385                     }
1386                     secondsAccountedFor += MINUTE_IN_SECONDS;
1387             }
1388 
1389             if (timestamp - secondsAccountedFor > 60) {
1390                     __throw();
1391             }
1392 
1393             // Second
1394             dt.second = uint8(timestamp - secondsAccountedFor);
1395 
1396             // Day of week.
1397             buf = timestamp / DAY_IN_SECONDS;
1398             dt.weekday = uint8((buf + 3) % 7);
1399     }
1400 
1401     function __throw() private view{
1402             uint[] arst;
1403             arst[1];
1404     }
1405     
1406     function() external payable {
1407     }
1408 }