1 pragma solidity >=0.4.25;
2 
3 contract OraclizeI {
4   address public cbAddress;
5   function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
6   function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
7   function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
8   function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
9   function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
10   function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
11   function getPrice(string _datasource) public returns (uint _dsprice);
12   function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
13   function setProofType(byte _proofType) external;
14   function setCustomGasPrice(uint _gasPrice) external;
15   function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
16 }
17 
18 contract OraclizeAddrResolverI {
19   function getAddress() public returns (address _addr);
20 }
21 
22 
23 
24 library Buffer {
25   struct buffer {
26     bytes buf;
27     uint capacity;
28   }
29 
30   function init(buffer memory buf, uint _capacity) internal pure {
31     uint capacity = _capacity;
32     if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
33     // Allocate space for the buffer data
34     buf.capacity = capacity;
35     assembly {
36       let ptr := mload(0x40)
37       mstore(buf, ptr)
38       mstore(ptr, 0)
39       mstore(0x40, add(ptr, capacity))
40     }
41   }
42 
43   function resize(buffer memory buf, uint capacity) private pure {
44     bytes memory oldbuf = buf.buf;
45     init(buf, capacity);
46     append(buf, oldbuf);
47   }
48 
49   function max(uint a, uint b) private pure returns(uint) {
50     if(a > b) {
51       return a;
52     }
53     return b;
54   }
55 
56   /**
57   * @dev Appends a byte array to the end of the buffer. Resizes if doing so
58   *      would exceed the capacity of the buffer.
59     * @param buf The buffer to append to.
60       * @param data The data to append.
61       * @return The original buffer.
62       */
63   function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
64     if(data.length + buf.buf.length > buf.capacity) {
65       resize(buf, max(buf.capacity, data.length) * 2);
66     }
67 
68     uint dest;
69     uint src;
70     uint len = data.length;
71     assembly {
72       // Memory address of the buffer data
73       let bufptr := mload(buf)
74       // Length of existing buffer data
75       let buflen := mload(bufptr)
76       // Start address = buffer address + buffer length + sizeof(buffer length)
77       dest := add(add(bufptr, buflen), 32)
78       // Update buffer length
79       mstore(bufptr, add(buflen, mload(data)))
80       src := add(data, 32)
81     }
82 
83     // Copy word-length chunks while possible
84     for(; len >= 32; len -= 32) {
85       assembly {
86         mstore(dest, mload(src))
87       }
88       dest += 32;
89       src += 32;
90     }
91 
92     // Copy remaining bytes
93     uint mask = 256 ** (32 - len) - 1;
94     assembly {
95       let srcpart := and(mload(src), not(mask))
96       let destpart := and(mload(dest), mask)
97       mstore(dest, or(destpart, srcpart))
98     }
99 
100     return buf;
101   }
102 
103   /**
104   * @dev Appends a byte to the end of the buffer. Resizes if doing so would
105   * exceed the capacity of the buffer.
106     * @param buf The buffer to append to.
107       * @param data The data to append.
108       * @return The original buffer.
109       */
110   function append(buffer memory buf, uint8 data) internal pure {
111     if(buf.buf.length + 1 > buf.capacity) {
112       resize(buf, buf.capacity * 2);
113     }
114 
115     assembly {
116       // Memory address of the buffer data
117       let bufptr := mload(buf)
118       // Length of existing buffer data
119       let buflen := mload(bufptr)
120       // Address = buffer address + buffer length + sizeof(buffer length)
121       let dest := add(add(bufptr, buflen), 32)
122       mstore8(dest, data)
123       // Update buffer length
124       mstore(bufptr, add(buflen, 1))
125     }
126   }
127 
128   /**
129   * @dev Appends a byte to the end of the buffer. Resizes if doing so would
130   * exceed the capacity of the buffer.
131     * @param buf The buffer to append to.
132       * @param data The data to append.
133       * @return The original buffer.
134       */
135   function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
136     if(len + buf.buf.length > buf.capacity) {
137       resize(buf, max(buf.capacity, len) * 2);
138     }
139 
140     uint mask = 256 ** len - 1;
141     assembly {
142       // Memory address of the buffer data
143       let bufptr := mload(buf)
144       // Length of existing buffer data
145       let buflen := mload(bufptr)
146       // Address = buffer address + buffer length + sizeof(buffer length) + len
147       let dest := add(add(bufptr, buflen), len)
148       mstore(dest, or(and(mload(dest), not(mask)), data))
149       // Update buffer length
150       mstore(bufptr, add(buflen, len))
151     }
152     return buf;
153   }
154 }
155 
156 library CBOR {
157   using Buffer for Buffer.buffer;
158 
159   uint8 private constant MAJOR_TYPE_INT = 0;
160   uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
161   uint8 private constant MAJOR_TYPE_BYTES = 2;
162   uint8 private constant MAJOR_TYPE_STRING = 3;
163   uint8 private constant MAJOR_TYPE_ARRAY = 4;
164   uint8 private constant MAJOR_TYPE_MAP = 5;
165   uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
166 
167   function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
168     if(value <= 23) {
169       buf.append(uint8((major << 5) | value));
170     } else if(value <= 0xFF) {
171       buf.append(uint8((major << 5) | 24));
172       buf.appendInt(value, 1);
173     } else if(value <= 0xFFFF) {
174       buf.append(uint8((major << 5) | 25));
175       buf.appendInt(value, 2);
176     } else if(value <= 0xFFFFFFFF) {
177       buf.append(uint8((major << 5) | 26));
178       buf.appendInt(value, 4);
179     } else if(value <= 0xFFFFFFFFFFFFFFFF) {
180       buf.append(uint8((major << 5) | 27));
181       buf.appendInt(value, 8);
182     }
183   }
184 
185   function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
186     buf.append(uint8((major << 5) | 31));
187   }
188 
189   function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
190     encodeType(buf, MAJOR_TYPE_INT, value);
191   }
192 
193   function encodeInt(Buffer.buffer memory buf, int value) internal pure {
194     if(value >= 0) {
195       encodeType(buf, MAJOR_TYPE_INT, uint(value));
196     } else {
197       encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
198     }
199   }
200 
201   function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
202     encodeType(buf, MAJOR_TYPE_BYTES, value.length);
203     buf.append(value);
204   }
205 
206   function encodeString(Buffer.buffer memory buf, string value) internal pure {
207     encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
208     buf.append(bytes(value));
209   }
210 
211   function startArray(Buffer.buffer memory buf) internal pure {
212     encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
213   }
214 
215   function startMap(Buffer.buffer memory buf) internal pure {
216     encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
217   }
218 
219   function endSequence(Buffer.buffer memory buf) internal pure {
220     encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
221   }
222 }
223 
224 /*
225    End solidity-cborutils
226    */
227 
228 contract usingOraclize {
229   uint constant day = 60*60*24;
230   uint constant week = 60*60*24*7;
231   uint constant month = 60*60*24*30;
232   byte constant proofType_NONE = 0x00;
233   byte constant proofType_TLSNotary = 0x10;
234   byte constant proofType_Ledger = 0x30;
235   byte constant proofType_Android = 0x40;
236   byte constant proofType_Native = 0xF0;
237   byte constant proofStorage_IPFS = 0x01;
238   uint8 constant networkID_auto = 0;
239   uint8 constant networkID_mainnet = 1;
240   uint8 constant networkID_testnet = 2;
241   uint8 constant networkID_morden = 2;
242   uint8 constant networkID_consensys = 161;
243 
244   OraclizeAddrResolverI OAR;
245 
246   OraclizeI oraclize;
247   modifier oraclizeAPI {
248     if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
249       oraclize_setNetwork(networkID_auto);
250 
251     if(address(oraclize) != OAR.getAddress())
252       oraclize = OraclizeI(OAR.getAddress());
253 
254     _;
255   }
256   modifier coupon(string code){
257     oraclize = OraclizeI(OAR.getAddress());
258     _;
259   }
260 
261   function oraclize_setNetwork(uint8 networkID) internal returns(bool){
262     return oraclize_setNetwork();
263     networkID; // silence the warning and remain backwards compatible
264   }
265   function oraclize_setNetwork() internal returns(bool){
266     if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
267       OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
268       oraclize_setNetworkName("eth_mainnet");
269       return true;
270     }
271     if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
272       OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
273       oraclize_setNetworkName("eth_ropsten3");
274       return true;
275     }
276     if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
277       OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
278       oraclize_setNetworkName("eth_kovan");
279       return true;
280     }
281     if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
282       OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
283       oraclize_setNetworkName("eth_rinkeby");
284       return true;
285     }
286     if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
287       OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
288       return true;
289     }
290     if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
291       OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
292       return true;
293     }
294     if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
295       OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
296       return true;
297     }
298     return false;
299   }
300 
301   function __callback(bytes32 myid, string result) public {
302     __callback(myid, result, new bytes(0));
303   }
304   function __callback(bytes32 myid, string result, bytes proof) public {
305     return;
306     myid; result; proof; // Silence compiler warnings
307   }
308 
309   function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
310     return oraclize.getPrice(datasource);
311   }
312 
313   function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
314     return oraclize.getPrice(datasource, gaslimit);
315   }
316 
317   function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
318     uint price = oraclize.getPrice(datasource);
319     if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
320     return oraclize.query.value(price)(0, datasource, arg);
321   }
322   function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
323     uint price = oraclize.getPrice(datasource);
324     if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
325     return oraclize.query.value(price)(timestamp, datasource, arg);
326   }
327   function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
328     uint price = oraclize.getPrice(datasource, gaslimit);
329     if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
330     return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
331   }
332   function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
333     uint price = oraclize.getPrice(datasource, gaslimit);
334     if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
335     return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
336   }
337   function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
338     uint price = oraclize.getPrice(datasource);
339     if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
340     return oraclize.query2.value(price)(0, datasource, arg1, arg2);
341   }
342   function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
343     uint price = oraclize.getPrice(datasource);
344     if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
345     return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
346   }
347   function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
348     uint price = oraclize.getPrice(datasource, gaslimit);
349     if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
350     return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
351   }
352   function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
353     uint price = oraclize.getPrice(datasource, gaslimit);
354     if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
355     return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
356   }
357   function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
358     uint price = oraclize.getPrice(datasource);
359     if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
360     bytes memory args = stra2cbor(argN);
361     return oraclize.queryN.value(price)(0, datasource, args);
362   }
363   function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
364     uint price = oraclize.getPrice(datasource);
365     if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
366     bytes memory args = stra2cbor(argN);
367     return oraclize.queryN.value(price)(timestamp, datasource, args);
368   }
369   function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
370     uint price = oraclize.getPrice(datasource, gaslimit);
371     if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
372     bytes memory args = stra2cbor(argN);
373     return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
374   }
375   function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
376     uint price = oraclize.getPrice(datasource, gaslimit);
377     if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
378     bytes memory args = stra2cbor(argN);
379     return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
380   }
381   function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
382     string[] memory dynargs = new string[](1);
383     dynargs[0] = args[0];
384     return oraclize_query(datasource, dynargs);
385   }
386   function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
387     string[] memory dynargs = new string[](1);
388     dynargs[0] = args[0];
389     return oraclize_query(timestamp, datasource, dynargs);
390   }
391   function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
392     string[] memory dynargs = new string[](1);
393     dynargs[0] = args[0];
394     return oraclize_query(timestamp, datasource, dynargs, gaslimit);
395   }
396   function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
397     string[] memory dynargs = new string[](1);
398     dynargs[0] = args[0];
399     return oraclize_query(datasource, dynargs, gaslimit);
400   }
401 
402   function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
403     string[] memory dynargs = new string[](2);
404     dynargs[0] = args[0];
405     dynargs[1] = args[1];
406     return oraclize_query(datasource, dynargs);
407   }
408   function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
409     string[] memory dynargs = new string[](2);
410     dynargs[0] = args[0];
411     dynargs[1] = args[1];
412     return oraclize_query(timestamp, datasource, dynargs);
413   }
414   function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
415     string[] memory dynargs = new string[](2);
416     dynargs[0] = args[0];
417     dynargs[1] = args[1];
418     return oraclize_query(timestamp, datasource, dynargs, gaslimit);
419   }
420   function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
421     string[] memory dynargs = new string[](2);
422     dynargs[0] = args[0];
423     dynargs[1] = args[1];
424     return oraclize_query(datasource, dynargs, gaslimit);
425   }
426   function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
427     string[] memory dynargs = new string[](3);
428     dynargs[0] = args[0];
429     dynargs[1] = args[1];
430     dynargs[2] = args[2];
431     return oraclize_query(datasource, dynargs);
432   }
433   function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
434     string[] memory dynargs = new string[](3);
435     dynargs[0] = args[0];
436     dynargs[1] = args[1];
437     dynargs[2] = args[2];
438     return oraclize_query(timestamp, datasource, dynargs);
439   }
440   function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441     string[] memory dynargs = new string[](3);
442     dynargs[0] = args[0];
443     dynargs[1] = args[1];
444     dynargs[2] = args[2];
445     return oraclize_query(timestamp, datasource, dynargs, gaslimit);
446   }
447   function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
448     string[] memory dynargs = new string[](3);
449     dynargs[0] = args[0];
450     dynargs[1] = args[1];
451     dynargs[2] = args[2];
452     return oraclize_query(datasource, dynargs, gaslimit);
453   }
454 
455   function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
456     string[] memory dynargs = new string[](4);
457     dynargs[0] = args[0];
458     dynargs[1] = args[1];
459     dynargs[2] = args[2];
460     dynargs[3] = args[3];
461     return oraclize_query(datasource, dynargs);
462   }
463   function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
464     string[] memory dynargs = new string[](4);
465     dynargs[0] = args[0];
466     dynargs[1] = args[1];
467     dynargs[2] = args[2];
468     dynargs[3] = args[3];
469     return oraclize_query(timestamp, datasource, dynargs);
470   }
471   function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
472     string[] memory dynargs = new string[](4);
473     dynargs[0] = args[0];
474     dynargs[1] = args[1];
475     dynargs[2] = args[2];
476     dynargs[3] = args[3];
477     return oraclize_query(timestamp, datasource, dynargs, gaslimit);
478   }
479   function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
480     string[] memory dynargs = new string[](4);
481     dynargs[0] = args[0];
482     dynargs[1] = args[1];
483     dynargs[2] = args[2];
484     dynargs[3] = args[3];
485     return oraclize_query(datasource, dynargs, gaslimit);
486   }
487   function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
488     string[] memory dynargs = new string[](5);
489     dynargs[0] = args[0];
490     dynargs[1] = args[1];
491     dynargs[2] = args[2];
492     dynargs[3] = args[3];
493     dynargs[4] = args[4];
494     return oraclize_query(datasource, dynargs);
495   }
496   function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
497     string[] memory dynargs = new string[](5);
498     dynargs[0] = args[0];
499     dynargs[1] = args[1];
500     dynargs[2] = args[2];
501     dynargs[3] = args[3];
502     dynargs[4] = args[4];
503     return oraclize_query(timestamp, datasource, dynargs);
504   }
505   function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506     string[] memory dynargs = new string[](5);
507     dynargs[0] = args[0];
508     dynargs[1] = args[1];
509     dynargs[2] = args[2];
510     dynargs[3] = args[3];
511     dynargs[4] = args[4];
512     return oraclize_query(timestamp, datasource, dynargs, gaslimit);
513   }
514   function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
515     string[] memory dynargs = new string[](5);
516     dynargs[0] = args[0];
517     dynargs[1] = args[1];
518     dynargs[2] = args[2];
519     dynargs[3] = args[3];
520     dynargs[4] = args[4];
521     return oraclize_query(datasource, dynargs, gaslimit);
522   }
523   function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
524     uint price = oraclize.getPrice(datasource);
525     if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
526     bytes memory args = ba2cbor(argN);
527     return oraclize.queryN.value(price)(0, datasource, args);
528   }
529   function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
530     uint price = oraclize.getPrice(datasource);
531     if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
532     bytes memory args = ba2cbor(argN);
533     return oraclize.queryN.value(price)(timestamp, datasource, args);
534   }
535   function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
536     uint price = oraclize.getPrice(datasource, gaslimit);
537     if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
538     bytes memory args = ba2cbor(argN);
539     return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
540   }
541   function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
542     uint price = oraclize.getPrice(datasource, gaslimit);
543     if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
544     bytes memory args = ba2cbor(argN);
545     return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
546   }
547   function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
548     bytes[] memory dynargs = new bytes[](1);
549     dynargs[0] = args[0];
550     return oraclize_query(datasource, dynargs);
551   }
552   function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
553     bytes[] memory dynargs = new bytes[](1);
554     dynargs[0] = args[0];
555     return oraclize_query(timestamp, datasource, dynargs);
556   }
557   function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
558     bytes[] memory dynargs = new bytes[](1);
559     dynargs[0] = args[0];
560     return oraclize_query(timestamp, datasource, dynargs, gaslimit);
561   }
562   function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
563     bytes[] memory dynargs = new bytes[](1);
564     dynargs[0] = args[0];
565     return oraclize_query(datasource, dynargs, gaslimit);
566   }
567 
568   function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
569     bytes[] memory dynargs = new bytes[](2);
570     dynargs[0] = args[0];
571     dynargs[1] = args[1];
572     return oraclize_query(datasource, dynargs);
573   }
574   function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
575     bytes[] memory dynargs = new bytes[](2);
576     dynargs[0] = args[0];
577     dynargs[1] = args[1];
578     return oraclize_query(timestamp, datasource, dynargs);
579   }
580   function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
581     bytes[] memory dynargs = new bytes[](2);
582     dynargs[0] = args[0];
583     dynargs[1] = args[1];
584     return oraclize_query(timestamp, datasource, dynargs, gaslimit);
585   }
586   function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
587     bytes[] memory dynargs = new bytes[](2);
588     dynargs[0] = args[0];
589     dynargs[1] = args[1];
590     return oraclize_query(datasource, dynargs, gaslimit);
591   }
592   function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
593     bytes[] memory dynargs = new bytes[](3);
594     dynargs[0] = args[0];
595     dynargs[1] = args[1];
596     dynargs[2] = args[2];
597     return oraclize_query(datasource, dynargs);
598   }
599   function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
600     bytes[] memory dynargs = new bytes[](3);
601     dynargs[0] = args[0];
602     dynargs[1] = args[1];
603     dynargs[2] = args[2];
604     return oraclize_query(timestamp, datasource, dynargs);
605   }
606   function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
607     bytes[] memory dynargs = new bytes[](3);
608     dynargs[0] = args[0];
609     dynargs[1] = args[1];
610     dynargs[2] = args[2];
611     return oraclize_query(timestamp, datasource, dynargs, gaslimit);
612   }
613   function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
614     bytes[] memory dynargs = new bytes[](3);
615     dynargs[0] = args[0];
616     dynargs[1] = args[1];
617     dynargs[2] = args[2];
618     return oraclize_query(datasource, dynargs, gaslimit);
619   }
620 
621   function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
622     bytes[] memory dynargs = new bytes[](4);
623     dynargs[0] = args[0];
624     dynargs[1] = args[1];
625     dynargs[2] = args[2];
626     dynargs[3] = args[3];
627     return oraclize_query(datasource, dynargs);
628   }
629   function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
630     bytes[] memory dynargs = new bytes[](4);
631     dynargs[0] = args[0];
632     dynargs[1] = args[1];
633     dynargs[2] = args[2];
634     dynargs[3] = args[3];
635     return oraclize_query(timestamp, datasource, dynargs);
636   }
637   function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
638     bytes[] memory dynargs = new bytes[](4);
639     dynargs[0] = args[0];
640     dynargs[1] = args[1];
641     dynargs[2] = args[2];
642     dynargs[3] = args[3];
643     return oraclize_query(timestamp, datasource, dynargs, gaslimit);
644   }
645   function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
646     bytes[] memory dynargs = new bytes[](4);
647     dynargs[0] = args[0];
648     dynargs[1] = args[1];
649     dynargs[2] = args[2];
650     dynargs[3] = args[3];
651     return oraclize_query(datasource, dynargs, gaslimit);
652   }
653   function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
654     bytes[] memory dynargs = new bytes[](5);
655     dynargs[0] = args[0];
656     dynargs[1] = args[1];
657     dynargs[2] = args[2];
658     dynargs[3] = args[3];
659     dynargs[4] = args[4];
660     return oraclize_query(datasource, dynargs);
661   }
662   function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
663     bytes[] memory dynargs = new bytes[](5);
664     dynargs[0] = args[0];
665     dynargs[1] = args[1];
666     dynargs[2] = args[2];
667     dynargs[3] = args[3];
668     dynargs[4] = args[4];
669     return oraclize_query(timestamp, datasource, dynargs);
670   }
671   function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
672     bytes[] memory dynargs = new bytes[](5);
673     dynargs[0] = args[0];
674     dynargs[1] = args[1];
675     dynargs[2] = args[2];
676     dynargs[3] = args[3];
677     dynargs[4] = args[4];
678     return oraclize_query(timestamp, datasource, dynargs, gaslimit);
679   }
680   function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
681     bytes[] memory dynargs = new bytes[](5);
682     dynargs[0] = args[0];
683     dynargs[1] = args[1];
684     dynargs[2] = args[2];
685     dynargs[3] = args[3];
686     dynargs[4] = args[4];
687     return oraclize_query(datasource, dynargs, gaslimit);
688   }
689 
690   function oraclize_cbAddress() oraclizeAPI internal returns (address){
691     return oraclize.cbAddress();
692   }
693   function oraclize_setProof(byte proofP) oraclizeAPI internal {
694     return oraclize.setProofType(proofP);
695   }
696   function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
697     return oraclize.setCustomGasPrice(gasPrice);
698   }
699 
700   function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
701     return oraclize.randomDS_getSessionPubKeyHash();
702   }
703 
704   function getCodeSize(address _addr) constant internal returns(uint _size) {
705     assembly {
706       _size := extcodesize(_addr)
707     }
708   }
709 
710   function parseAddr(string _a) internal pure returns (address){
711     bytes memory tmp = bytes(_a);
712     uint160 iaddr = 0;
713     uint160 b1;
714     uint160 b2;
715     for (uint i=2; i<2+2*20; i+=2){
716       iaddr *= 256;
717       b1 = uint160(tmp[i]);
718       b2 = uint160(tmp[i+1]);
719       if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
720       else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
721       else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
722       if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
723       else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
724       else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
725       iaddr += (b1*16+b2);
726     }
727     return address(iaddr);
728   }
729 
730   function strCompare(string _a, string _b) internal pure returns (int) {
731     bytes memory a = bytes(_a);
732     bytes memory b = bytes(_b);
733     uint minLength = a.length;
734     if (b.length < minLength) minLength = b.length;
735     for (uint i = 0; i < minLength; i ++)
736     if (a[i] < b[i])
737       return -1;
738     else if (a[i] > b[i])
739       return 1;
740     if (a.length < b.length)
741       return -1;
742     else if (a.length > b.length)
743       return 1;
744     else
745       return 0;
746   }
747 
748   function indexOf(string _haystack, string _needle) internal pure returns (int) {
749     bytes memory h = bytes(_haystack);
750     bytes memory n = bytes(_needle);
751     if(h.length < 1 || n.length < 1 || (n.length > h.length))
752       return -1;
753     else if(h.length > (2**128 -1))
754       return -1;
755     else
756       {
757         uint subindex = 0;
758         for (uint i = 0; i < h.length; i ++)
759         {
760           if (h[i] == n[0])
761             {
762               subindex = 1;
763               while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
764                 {
765                   subindex++;
766                 }
767                 if(subindex == n.length)
768                   return int(i);
769             }
770         }
771         return -1;
772       }
773   }
774 
775   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
776     bytes memory _ba = bytes(_a);
777     bytes memory _bb = bytes(_b);
778     bytes memory _bc = bytes(_c);
779     bytes memory _bd = bytes(_d);
780     bytes memory _be = bytes(_e);
781     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
782     bytes memory babcde = bytes(abcde);
783     uint k = 0;
784     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
785     for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
786     for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
787     for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
788     for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
789     return string(babcde);
790   }
791 
792   function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
793     return strConcat(_a, _b, _c, _d, "");
794   }
795 
796   function strConcat(string _a, string _b, string _c) internal pure returns (string) {
797     return strConcat(_a, _b, _c, "", "");
798   }
799 
800   function strConcat(string _a, string _b) internal pure returns (string) {
801     return strConcat(_a, _b, "", "", "");
802   }
803 
804   // parseInt
805   function parseInt(string _a) internal pure returns (uint) {
806     return parseInt(_a, 0);
807   }
808 
809   // parseInt(parseFloat*10^_b)
810   function parseInt(string _a, uint _b) internal pure returns (uint) {
811     bytes memory bresult = bytes(_a);
812     uint mint = 0;
813     bool decimals = false;
814     for (uint i=0; i<bresult.length; i++){
815       if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
816         if (decimals){
817           if (_b == 0) break;
818           else _b--;
819         }
820         mint *= 10;
821         mint += uint(bresult[i]) - 48;
822       } else if (bresult[i] == 46) decimals = true;
823     }
824     if (_b > 0) mint *= 10**_b;
825     return mint;
826   }
827 
828   function uint2str(uint i) internal pure returns (string){
829     if (i == 0) return "0";
830     uint j = i;
831     uint len;
832     while (j != 0){
833       len++;
834       j /= 10;
835     }
836     bytes memory bstr = new bytes(len);
837     uint k = len - 1;
838     while (i != 0){
839       bstr[k--] = byte(48 + i % 10);
840       i /= 10;
841     }
842     return string(bstr);
843   }
844 
845   using CBOR for Buffer.buffer;
846   function stra2cbor(string[] arr) internal pure returns (bytes) {
847     safeMemoryCleaner();
848     Buffer.buffer memory buf;
849     Buffer.init(buf, 1024);
850     buf.startArray();
851     for (uint i = 0; i < arr.length; i++) {
852       buf.encodeString(arr[i]);
853     }
854     buf.endSequence();
855     return buf.buf;
856   }
857 
858   function ba2cbor(bytes[] arr) internal pure returns (bytes) {
859     safeMemoryCleaner();
860     Buffer.buffer memory buf;
861     Buffer.init(buf, 1024);
862     buf.startArray();
863     for (uint i = 0; i < arr.length; i++) {
864       buf.encodeBytes(arr[i]);
865     }
866     buf.endSequence();
867     return buf.buf;
868   }
869 
870   string oraclize_network_name;
871   function oraclize_setNetworkName(string _network_name) internal {
872     oraclize_network_name = _network_name;
873   }
874 
875   function oraclize_getNetworkName() internal view returns (string) {
876     return oraclize_network_name;
877   }
878 
879   function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
880     require((_nbytes > 0) && (_nbytes <= 32));
881     // Convert from seconds to ledger timer ticks
882     _delay *= 10;
883     bytes memory nbytes = new bytes(1);
884     nbytes[0] = byte(_nbytes);
885     bytes memory unonce = new bytes(32);
886     bytes memory sessionKeyHash = new bytes(32);
887     bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
888     assembly {
889       mstore(unonce, 0x20)
890       // the following variables can be relaxed
891       // check relaxed random contract under ethereum-examples repo
892       // for an idea on how to override and replace comit hash vars
893       mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
894       mstore(sessionKeyHash, 0x20)
895       mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
896     }
897     bytes memory delay = new bytes(32);
898     assembly {
899       mstore(add(delay, 0x20), _delay)
900     }
901 
902     bytes memory delay_bytes8 = new bytes(8);
903     copyBytes(delay, 24, 8, delay_bytes8, 0);
904 
905     bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
906     bytes32 queryId = oraclize_query("random", args, _customGasLimit);
907 
908     bytes memory delay_bytes8_left = new bytes(8);
909 
910     assembly {
911       let x := mload(add(delay_bytes8, 0x20))
912       mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
913       mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
914       mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
915       mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
916       mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
917       mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
918       mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
919       mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
920 
921     }
922 
923     oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
924     return queryId;
925   }
926 
927   function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
928     oraclize_randomDS_args[queryId] = commitment;
929   }
930 
931   mapping(bytes32=>bytes32) oraclize_randomDS_args;
932   mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
933 
934   function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
935     bool sigok;
936     address signer;
937 
938     bytes32 sigr;
939     bytes32 sigs;
940 
941     bytes memory sigr_ = new bytes(32);
942     uint offset = 4+(uint(dersig[3]) - 0x20);
943     sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
944     bytes memory sigs_ = new bytes(32);
945     offset += 32 + 2;
946     sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
947 
948     assembly {
949       sigr := mload(add(sigr_, 32))
950       sigs := mload(add(sigs_, 32))
951     }
952 
953 
954     (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
955     if (address(keccak256(pubkey)) == signer) return true;
956     else {
957       (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
958       return (address(keccak256(pubkey)) == signer);
959     }
960   }
961 
962   function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
963     bool sigok;
964 
965     // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
966     bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
967     copyBytes(proof, sig2offset, sig2.length, sig2, 0);
968 
969     bytes memory appkey1_pubkey = new bytes(64);
970     copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
971 
972     bytes memory tosign2 = new bytes(1+65+32);
973     tosign2[0] = byte(1); //role
974     copyBytes(proof, sig2offset-65, 65, tosign2, 1);
975     bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
976     copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
977     sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
978 
979     if (sigok == false) return false;
980 
981 
982     // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
983     bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
984 
985     bytes memory tosign3 = new bytes(1+65);
986     tosign3[0] = 0xFE;
987     copyBytes(proof, 3, 65, tosign3, 1);
988 
989     bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
990     copyBytes(proof, 3+65, sig3.length, sig3, 0);
991 
992     sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
993 
994     return sigok;
995   }
996 
997   modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
998     // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
999     require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1000 
1001     bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1002     require(proofVerified);
1003 
1004     _;
1005   }
1006 
1007   function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1008     // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1009     if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1010 
1011     bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1012     if (proofVerified == false) return 2;
1013 
1014     return 0;
1015   }
1016 
1017   function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1018     bool match_ = true;
1019 
1020     require(prefix.length == n_random_bytes);
1021 
1022     for (uint256 i=0; i< n_random_bytes; i++) {
1023       if (content[i] != prefix[i]) match_ = false;
1024     }
1025 
1026     return match_;
1027   }
1028 
1029   function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1030 
1031     // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1032     uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1033     bytes memory keyhash = new bytes(32);
1034     copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1035     if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1036 
1037     bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1038     copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1039 
1040     // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1041     if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1042 
1043     // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1044     // This is to verify that the computed args match with the ones specified in the query.
1045     bytes memory commitmentSlice1 = new bytes(8+1+32);
1046     copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1047 
1048     bytes memory sessionPubkey = new bytes(64);
1049     uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1050     copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1051 
1052     bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1053     if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1054       delete oraclize_randomDS_args[queryId];
1055     } else return false;
1056 
1057 
1058     // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1059     bytes memory tosign1 = new bytes(32+8+1+32);
1060     copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1061     if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1062 
1063     // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1064     if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1065       oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1066     }
1067 
1068     return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1069   }
1070 
1071   // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1072   function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1073     uint minLength = length + toOffset;
1074 
1075     // Buffer too small
1076     require(to.length >= minLength); // Should be a better way?
1077 
1078     // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1079     uint i = 32 + fromOffset;
1080     uint j = 32 + toOffset;
1081 
1082     while (i < (32 + fromOffset + length)) {
1083       assembly {
1084         let tmp := mload(add(from, i))
1085         mstore(add(to, j), tmp)
1086       }
1087       i += 32;
1088       j += 32;
1089     }
1090 
1091     return to;
1092   }
1093 
1094   // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1095   // Duplicate Solidity's ecrecover, but catching the CALL return value
1096   function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1097     // We do our own memory management here. Solidity uses memory offset
1098     // 0x40 to store the current end of memory. We write past it (as
1099     // writes are memory extensions), but don't update the offset so
1100     // Solidity will reuse it. The memory used here is only needed for
1101     // this context.
1102 
1103     // FIXME: inline assembly can't access return values
1104     bool ret;
1105     address addr;
1106 
1107     assembly {
1108       let size := mload(0x40)
1109       mstore(size, hash)
1110       mstore(add(size, 32), v)
1111       mstore(add(size, 64), r)
1112       mstore(add(size, 96), s)
1113 
1114       // NOTE: we can reuse the request memory because we deal with
1115       //       the return code
1116       ret := call(3000, 1, 0, size, 128, size, 32)
1117       addr := mload(size)
1118     }
1119 
1120     return (ret, addr);
1121   }
1122 
1123   // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1124   function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1125     bytes32 r;
1126     bytes32 s;
1127     uint8 v;
1128 
1129     if (sig.length != 65)
1130       return (false, 0);
1131 
1132     // The signature format is a compact form of:
1133     //   {bytes32 r}{bytes32 s}{uint8 v}
1134     // Compact means, uint8 is not padded to 32 bytes.
1135     assembly {
1136       r := mload(add(sig, 32))
1137       s := mload(add(sig, 64))
1138 
1139       // Here we are loading the last 32 bytes. We exploit the fact that
1140       // 'mload' will pad with zeroes if we overread.
1141       // There is no 'mload8' to do this, but that would be nicer.
1142       v := byte(0, mload(add(sig, 96)))
1143 
1144       // Alternative solution:
1145       // 'byte' is not working due to the Solidity parser, so lets
1146       // use the second best option, 'and'
1147       // v := and(mload(add(sig, 65)), 255)
1148     }
1149 
1150     // albeit non-transactional signatures are not specified by the YP, one would expect it
1151     // to match the YP range of [27, 28]
1152     //
1153     // geth uses [0, 1] and some clients have followed. This might change, see:
1154     //  https://github.com/ethereum/go-ethereum/issues/2053
1155     if (v < 27)
1156       v += 27;
1157 
1158     if (v != 27 && v != 28)
1159       return (false, 0);
1160 
1161     return safer_ecrecover(hash, v, r, s);
1162   }
1163 
1164   function safeMemoryCleaner() internal pure {
1165     assembly {
1166       let fmem := mload(0x40)
1167       codecopy(fmem, codesize, sub(msize, fmem))
1168     }
1169   }
1170 
1171 }
1172 
1173 contract Fog is usingOraclize {
1174   address public owner;
1175 
1176   address private playerAddress;
1177   uint private playerValue;
1178 
1179   event OwnershipTransferred(
1180     address indexed owner,
1181     address indexed newOwner
1182   );
1183 
1184   event Winner(address indexed to, uint indexed value);
1185   event CupCake(address indexed to, uint indexed value);
1186   event Looser(address indexed from, uint indexed value);
1187 
1188   constructor() payable public {
1189     owner = msg.sender;
1190     oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof in the constructor
1191   }
1192 
1193   function move() payable public {
1194     require(msg.value >= 10000000000000000); // min 0.01 Ether
1195 
1196     playerAddress = msg.sender;
1197     playerValue = msg.value;
1198 
1199     uint N = 1; // number of random bytes we want the datasource to return
1200     uint delay = 0; // number of seconds to wait before the execution takes place
1201     uint callbackGas = 200000; // amount of gas we want Oraclize to set for the callback function
1202 
1203     oraclize_newRandomDSQuery(delay, N, callbackGas); // this function internally generates the correct oraclize_query and returns its queryId
1204   }
1205 
1206   // the callback function is called by Oraclize when the result is ready
1207   // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
1208   // the proof validity is fully verified on-chain
1209   function __callback(bytes32 _queryId, string _result, bytes _proof) public
1210   {
1211     if (msg.sender != oraclize_cbAddress()) revert();
1212 
1213     if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
1214       // the proof verification has failed
1215     } else {
1216       uint dice = uint(keccak256(abi.encodePacked(_result))) % 3;
1217 
1218       // Winner
1219       if (dice == 0) {
1220         uint doubleValue = mul(playerValue, 2);
1221 
1222         playerAddress.transfer(doubleValue);
1223         emit Winner(playerAddress, doubleValue);
1224 
1225         // Looser
1226       } else if (dice == 1) {
1227         emit Looser(playerAddress, playerValue);
1228 
1229         // Woa! Refund 80%
1230       } else if (dice == 2) {
1231         uint eightyPercent = div(mul(playerValue, 80), 100);
1232 
1233         playerAddress.transfer(eightyPercent);
1234         emit CupCake(playerAddress, eightyPercent);
1235       }
1236     }
1237   }
1238 
1239   function drain(uint value) public onlyOwner {
1240     require(value >= 0 && value < address(this).balance);
1241     owner.transfer(value);
1242   }
1243 
1244   function transferOwnership(address newOwner) public onlyOwner {
1245     require(newOwner != address(0));
1246     emit OwnershipTransferred(owner, newOwner);
1247     owner = newOwner;
1248   }
1249 
1250   modifier onlyOwner() {
1251     require(msg.sender == owner);
1252     _;
1253   }
1254 
1255   function() public payable { }
1256 
1257   /**
1258   * @dev Multiplies two numbers, reverts on overflow.
1259   */
1260   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
1261     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1262     // benefit is lost if 'b' is also tested.
1263     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1264     if (_a == 0) {
1265       return 0;
1266     }
1267 
1268     uint256 c = _a * _b;
1269     require(c / _a == _b);
1270 
1271     return c;
1272   }
1273 
1274   /**
1275   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1276   */
1277   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1278     require(b > 0); // Solidity only automatically asserts when dividing by 0
1279     uint256 c = a / b;
1280     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1281 
1282     return c;
1283   }
1284 }