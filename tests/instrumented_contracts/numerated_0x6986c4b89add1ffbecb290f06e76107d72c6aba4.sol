1 pragma solidity 0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 // ----------------------------------------------------------------------------
26 // Owned contract
27 // ----------------------------------------------------------------------------
28 contract Owned {
29   address public owner;
30 
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34 
35   /**
36    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37    * account.
38    */
39   function Ownable() public {
40     owner = msg.sender;
41   }
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) public onlyOwner {
56     require(newOwner != address(0));
57     emit OwnershipTransferred(owner, newOwner);
58     owner = newOwner;
59   }
60 
61 }
62 
63 contract OraclizeI {
64     address public cbAddress;
65     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
66     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
67     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
68     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
69     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
70     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
71     function getPrice(string _datasource) returns (uint _dsprice);
72     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
73     function useCoupon(string _coupon);
74     function setProofType(byte _proofType);
75     function setConfig(bytes32 _config);
76     function setCustomGasPrice(uint _gasPrice);
77 }
78 contract OraclizeAddrResolverI {
79     function getAddress() returns (address _addr);
80 }
81 
82 // ----------------------------------------------------------------------------
83 // Oracalize contract
84 // ----------------------------------------------------------------------------
85 contract usingOraclize {
86     uint constant day = 60*60*24;
87     uint constant week = 60*60*24*7;
88     uint constant month = 60*60*24*30;
89     byte constant proofType_NONE = 0x00;
90     byte constant proofType_TLSNotary = 0x10;
91     byte constant proofStorage_IPFS = 0x01;
92     uint8 constant networkID_auto = 0;
93     uint8 constant networkID_mainnet = 1;
94     uint8 constant networkID_testnet = 2;
95     uint8 constant networkID_morden = 2;
96     uint8 constant networkID_consensys = 161;
97 
98     OraclizeAddrResolverI OAR;
99 
100     OraclizeI oraclize;
101     modifier oraclizeAPI {
102         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
103         oraclize = OraclizeI(OAR.getAddress());
104         _;
105     }
106     modifier coupon(string code){
107         oraclize = OraclizeI(OAR.getAddress());
108         oraclize.useCoupon(code);
109         _;
110     }
111 
112     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
113         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
114             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
115             return true;
116         }
117         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
118             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
119             return true;
120         }
121         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
122             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
123             return true;
124         }
125         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
126             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
127             return true;
128         }
129         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
130             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
131             return true;
132         }
133         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
134             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
135             return true;
136         }
137         return false;
138     }
139 
140     function __callback(bytes32 myid, string result) {
141         __callback(myid, result, new bytes(0));
142     }
143     function __callback(bytes32 myid, string result, bytes proof) {
144     }
145 
146     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
147         return oraclize.getPrice(datasource);
148     }
149 
150     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
151         return oraclize.getPrice(datasource, gaslimit);
152     }
153 
154     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
155         uint price = oraclize.getPrice(datasource);
156         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
157         return oraclize.query.value(price)(0, datasource, arg);
158     }
159     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
160         uint price = oraclize.getPrice(datasource);
161         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
162         return oraclize.query.value(price)(timestamp, datasource, arg);
163     }
164     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
165         uint price = oraclize.getPrice(datasource, gaslimit);
166         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
167         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
168     }
169     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
170         uint price = oraclize.getPrice(datasource, gaslimit);
171         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
172         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
173     }
174     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
175         uint price = oraclize.getPrice(datasource);
176         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
177         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
178     }
179     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
180         uint price = oraclize.getPrice(datasource);
181         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
182         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
183     }
184     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
185         uint price = oraclize.getPrice(datasource, gaslimit);
186         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
187         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
188     }
189     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
190         uint price = oraclize.getPrice(datasource, gaslimit);
191         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
192         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
193     }
194     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
195         uint price = oraclize.getPrice(datasource);
196         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
197         bytes memory args = stra2cbor(argN);
198         return oraclize.queryN.value(price)(0, datasource, args);
199     }
200     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
201         uint price = oraclize.getPrice(datasource);
202         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
203         bytes memory args = stra2cbor(argN);
204         return oraclize.queryN.value(price)(timestamp, datasource, args);
205     }
206     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
207         uint price = oraclize.getPrice(datasource, gaslimit);
208         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
209         bytes memory args = stra2cbor(argN);
210         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
211     }
212     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
213         uint price = oraclize.getPrice(datasource, gaslimit);
214         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
215         bytes memory args = stra2cbor(argN);
216         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
217     }
218     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
219         string[] memory dynargs = new string[](1);
220         dynargs[0] = args[0];
221         return oraclize_query(datasource, dynargs);
222     }
223     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
224         string[] memory dynargs = new string[](1);
225         dynargs[0] = args[0];
226         return oraclize_query(timestamp, datasource, dynargs);
227     }
228     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
229         string[] memory dynargs = new string[](1);
230         dynargs[0] = args[0];
231         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
232     }
233     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
234         string[] memory dynargs = new string[](1);
235         dynargs[0] = args[0];
236         return oraclize_query(datasource, dynargs, gaslimit);
237     }
238 
239     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
240         string[] memory dynargs = new string[](2);
241         dynargs[0] = args[0];
242         dynargs[1] = args[1];
243         return oraclize_query(datasource, dynargs);
244     }
245     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
246         string[] memory dynargs = new string[](2);
247         dynargs[0] = args[0];
248         dynargs[1] = args[1];
249         return oraclize_query(timestamp, datasource, dynargs);
250     }
251     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
252         string[] memory dynargs = new string[](2);
253         dynargs[0] = args[0];
254         dynargs[1] = args[1];
255         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
256     }
257     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
258         string[] memory dynargs = new string[](2);
259         dynargs[0] = args[0];
260         dynargs[1] = args[1];
261         return oraclize_query(datasource, dynargs, gaslimit);
262     }
263     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
264         string[] memory dynargs = new string[](3);
265         dynargs[0] = args[0];
266         dynargs[1] = args[1];
267         dynargs[2] = args[2];
268         return oraclize_query(datasource, dynargs);
269     }
270     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
271         string[] memory dynargs = new string[](3);
272         dynargs[0] = args[0];
273         dynargs[1] = args[1];
274         dynargs[2] = args[2];
275         return oraclize_query(timestamp, datasource, dynargs);
276     }
277     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
278         string[] memory dynargs = new string[](3);
279         dynargs[0] = args[0];
280         dynargs[1] = args[1];
281         dynargs[2] = args[2];
282         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
283     }
284     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
285         string[] memory dynargs = new string[](3);
286         dynargs[0] = args[0];
287         dynargs[1] = args[1];
288         dynargs[2] = args[2];
289         return oraclize_query(datasource, dynargs, gaslimit);
290     }
291 
292     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
293         string[] memory dynargs = new string[](4);
294         dynargs[0] = args[0];
295         dynargs[1] = args[1];
296         dynargs[2] = args[2];
297         dynargs[3] = args[3];
298         return oraclize_query(datasource, dynargs);
299     }
300     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
301         string[] memory dynargs = new string[](4);
302         dynargs[0] = args[0];
303         dynargs[1] = args[1];
304         dynargs[2] = args[2];
305         dynargs[3] = args[3];
306         return oraclize_query(timestamp, datasource, dynargs);
307     }
308     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
309         string[] memory dynargs = new string[](4);
310         dynargs[0] = args[0];
311         dynargs[1] = args[1];
312         dynargs[2] = args[2];
313         dynargs[3] = args[3];
314         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
315     }
316     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
317         string[] memory dynargs = new string[](4);
318         dynargs[0] = args[0];
319         dynargs[1] = args[1];
320         dynargs[2] = args[2];
321         dynargs[3] = args[3];
322         return oraclize_query(datasource, dynargs, gaslimit);
323     }
324     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
325         string[] memory dynargs = new string[](5);
326         dynargs[0] = args[0];
327         dynargs[1] = args[1];
328         dynargs[2] = args[2];
329         dynargs[3] = args[3];
330         dynargs[4] = args[4];
331         return oraclize_query(datasource, dynargs);
332     }
333     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
334         string[] memory dynargs = new string[](5);
335         dynargs[0] = args[0];
336         dynargs[1] = args[1];
337         dynargs[2] = args[2];
338         dynargs[3] = args[3];
339         dynargs[4] = args[4];
340         return oraclize_query(timestamp, datasource, dynargs);
341     }
342     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
343         string[] memory dynargs = new string[](5);
344         dynargs[0] = args[0];
345         dynargs[1] = args[1];
346         dynargs[2] = args[2];
347         dynargs[3] = args[3];
348         dynargs[4] = args[4];
349         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
350     }
351     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
352         string[] memory dynargs = new string[](5);
353         dynargs[0] = args[0];
354         dynargs[1] = args[1];
355         dynargs[2] = args[2];
356         dynargs[3] = args[3];
357         dynargs[4] = args[4];
358         return oraclize_query(datasource, dynargs, gaslimit);
359     }
360 
361     function oraclize_cbAddress() oraclizeAPI internal returns (address){
362         return oraclize.cbAddress();
363     }
364     function oraclize_setProof(byte proofP) oraclizeAPI internal {
365         return oraclize.setProofType(proofP);
366     }
367     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
368         return oraclize.setCustomGasPrice(gasPrice);
369     }
370     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
371         return oraclize.setConfig(config);
372     }
373 
374     function getCodeSize(address _addr) constant internal returns(uint _size) {
375         assembly {
376             _size := extcodesize(_addr)
377         }
378     }
379 
380     function parseAddr(string _a) internal returns (address){
381         bytes memory tmp = bytes(_a);
382         uint160 iaddr = 0;
383         uint160 b1;
384         uint160 b2;
385         for (uint i=2; i<2+2*20; i+=2){
386             iaddr *= 256;
387             b1 = uint160(tmp[i]);
388             b2 = uint160(tmp[i+1]);
389             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
390             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
391             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
392             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
393             iaddr += (b1*16+b2);
394         }
395         return address(iaddr);
396     }
397 
398     function strCompare(string _a, string _b) internal returns (int) {
399         bytes memory a = bytes(_a);
400         bytes memory b = bytes(_b);
401         uint minLength = a.length;
402         if (b.length < minLength) minLength = b.length;
403         for (uint i = 0; i < minLength; i ++)
404             if (a[i] < b[i])
405                 return -1;
406             else if (a[i] > b[i])
407                 return 1;
408         if (a.length < b.length)
409             return -1;
410         else if (a.length > b.length)
411             return 1;
412         else
413             return 0;
414     }
415 
416     function indexOf(string _haystack, string _needle) internal returns (int) {
417         bytes memory h = bytes(_haystack);
418         bytes memory n = bytes(_needle);
419         if(h.length < 1 || n.length < 1 || (n.length > h.length))
420             return -1;
421         else if(h.length > (2**128 -1))
422             return -1;
423         else
424         {
425             uint subindex = 0;
426             for (uint i = 0; i < h.length; i ++)
427             {
428                 if (h[i] == n[0])
429                 {
430                     subindex = 1;
431                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
432                     {
433                         subindex++;
434                     }
435                     if(subindex == n.length)
436                         return int(i);
437                 }
438             }
439             return -1;
440         }
441     }
442 
443     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
444         bytes memory _ba = bytes(_a);
445         bytes memory _bb = bytes(_b);
446         bytes memory _bc = bytes(_c);
447         bytes memory _bd = bytes(_d);
448         bytes memory _be = bytes(_e);
449         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
450         bytes memory babcde = bytes(abcde);
451         uint k = 0;
452         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
453         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
454         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
455         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
456         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
457         return string(babcde);
458     }
459 
460     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
461         return strConcat(_a, _b, _c, _d, "");
462     }
463 
464     function strConcat(string _a, string _b, string _c) internal returns (string) {
465         return strConcat(_a, _b, _c, "", "");
466     }
467 
468     function strConcat(string _a, string _b) internal returns (string) {
469         return strConcat(_a, _b, "", "", "");
470     }
471 
472     // parseInt
473     function parseInt(string _a) internal returns (uint) {
474         return parseInt(_a, 0);
475     }
476 
477     // parseInt(parseFloat*10^_b)
478     function parseInt(string _a, uint _b) internal returns (uint) {
479         bytes memory bresult = bytes(_a);
480         uint mint = 0;
481         bool decimals = false;
482         for (uint i=0; i<bresult.length; i++){
483             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
484                 if (decimals){
485                    if (_b == 0) break;
486                     else _b--;
487                 }
488                 mint *= 10;
489                 mint += uint(bresult[i]) - 48;
490             } else if (bresult[i] == 46) decimals = true;
491         }
492         if (_b > 0) mint *= 10**_b;
493         return mint;
494     }
495 
496     function uint2str(uint i) internal returns (string){
497         if (i == 0) return "0";
498         uint j = i;
499         uint len;
500         while (j != 0){
501             len++;
502             j /= 10;
503         }
504         bytes memory bstr = new bytes(len);
505         uint k = len - 1;
506         while (i != 0){
507             bstr[k--] = byte(48 + i % 10);
508             i /= 10;
509         }
510         return string(bstr);
511     }
512 
513     function stra2cbor(string[] arr) internal returns (bytes) {
514             uint arrlen = arr.length;
515 
516             // get correct cbor output length
517             uint outputlen = 0;
518             bytes[] memory elemArray = new bytes[](arrlen);
519             for (uint i = 0; i < arrlen; i++) {
520                 elemArray[i] = (bytes(arr[i]));
521                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
522             }
523             uint ctr = 0;
524             uint cborlen = arrlen + 0x80;
525             outputlen += byte(cborlen).length;
526             bytes memory res = new bytes(outputlen);
527 
528             while (byte(cborlen).length > ctr) {
529                 res[ctr] = byte(cborlen)[ctr];
530                 ctr++;
531             }
532             for (i = 0; i < arrlen; i++) {
533                 res[ctr] = 0x5F;
534                 ctr++;
535                 for (uint x = 0; x < elemArray[i].length; x++) {
536                     // if there's a bug with larger strings, this may be the culprit
537                     if (x % 23 == 0) {
538                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
539                         elemcborlen += 0x40;
540                         uint lctr = ctr;
541                         while (byte(elemcborlen).length > ctr - lctr) {
542                             res[ctr] = byte(elemcborlen)[ctr - lctr];
543                             ctr++;
544                         }
545                     }
546                     res[ctr] = elemArray[i][x];
547                     ctr++;
548                 }
549                 res[ctr] = 0xFF;
550                 ctr++;
551             }
552             return res;
553         }
554 }
555 // ----------------------------------------------------------------------------
556 // ERC Token Standard #20 Interface
557 // ----------------------------------------------------------------------------
558 contract ERC20Interface {
559     function totalSupply() public constant returns (uint);
560     function balanceOf(address tokenOwner) public constant returns (uint balance);
561     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
562     function transfer(address to, uint tokens) public returns (bool success);
563     function approve(address spender, uint tokens) public returns (bool success);
564     function transferFrom(address from, address to, uint tokens) public returns (bool success);
565 
566     event Transfer(address indexed from, address indexed to, uint tokens);
567     event TransferWithMsg(address indexed from, address indexed to, uint tokens, string message);
568     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
569 }
570 
571 /**
572  * @title OUT2ICO
573  * @dev   OUT2ICO accepting contributions only within a time frame.
574  */
575 contract OUT2ICO is ERC20Interface, Owned, usingOraclize {
576   using SafeMath for uint256;
577   string  public symbol; 
578   string  public name;
579   uint8   public decimals;
580   uint256 public fundsRaised;
581   address public wallet;
582   uint256 internal lot1;
583   uint256 internal lot2;
584   uint256 internal lot3;
585   uint256 internal remaining;
586   bool    internal Open;
587   address internal tempSender;
588   uint256 internal tempValue;
589   string public EthUsdRate;
590   uint internal ethusdrate;
591   
592   mapping(address => uint) balances;
593   mapping(address => mapping(address => uint)) allowed;
594   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
595   event LogPriceUpdated(string price);
596   event LogNewOraclizeQuery(string description);
597 
598     modifier onlyWhileOpen {
599         require(Open && balances[this] > 1e27); // should be open and the balance of contract should be greater than reserves
600         _;
601     }
602   
603     // ------------------------------------------------------------------------
604     // Constructor
605     // ------------------------------------------------------------------------
606     constructor (address _owner, address _wallet) public {
607         symbol = "OUT2";
608         name = "Outcloud";
609         decimals = 18;
610         owner = _owner;
611         wallet = _wallet;
612         balances[this] = totalSupply();
613         lot1 = 2e27; // 2 billion
614         lot2 = 3e27; // 3 billion
615         lot3 = 4e27; // 4 billion
616         remaining = totalSupply();
617         Open = true;
618         emit Transfer(address(0), this, totalSupply());
619     }
620     
621     function () external payable {
622         buyTokens(msg.sender);
623     }
624 
625     function buyTokens(address _beneficiary) public payable onlyWhileOpen {
626         tempSender = msg.sender;
627         tempValue = msg.value;
628         _preValidatePurchase(_beneficiary, tempValue);
629         _updateEthereumPrice();    
630     }
631     
632     function _updateEthereumPrice() internal {
633         if (oraclize_getPrice("json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0") > address(this).balance) {
634             emit LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
635             revert();
636             
637         }
638         else {
639         emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
640         oraclize_query("URL","json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
641         }
642     }
643     
644     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure{
645         require(_beneficiary != address(0));
646         require(_weiAmount != 0);
647     }
648     
649     function __callback (bytes32 myid, string result) {
650         if (msg.sender != oraclize_cbAddress()) revert();
651             EthUsdRate = result;
652             ethusdrate = parseInt(result,0);
653             emit LogPriceUpdated(result);
654             if(ethusdrate > 0){
655                 _continueTokenPurchase(tempSender, tempValue);
656             }
657     }
658     
659     function _continueTokenPurchase(address _beneficiary, uint256 _weiAmount) internal{
660         uint256 _tokens = _getTokenAmount(_weiAmount);
661         
662         fundsRaised = fundsRaised.add(_weiAmount);
663 
664         _processPurchase(_beneficiary, _tokens);
665         emit TokenPurchase(this, _beneficiary, _weiAmount, _tokens);
666     }
667     
668     function _getTokenAmount(uint256 _weiAmount) internal constant returns (uint256) {
669         uint256 rate = _getRate();
670         return _weiAmount.mul(rate);
671     }
672     
673     function _getRate() internal constant returns (uint256){
674         uint256 rate;
675         if (lot1 > 0){ // ICO lot1
676             // set rate 0.003
677             rate = _setPriceFactor(3);
678         } else if(lot2 > 0) { // ICO lot2
679             // do something 0.005
680             rate = _setPriceFactor(5);
681         } else if (lot3 > 0){ // ICO lot3
682             // third phase ICO 0.007
683             rate = _setPriceFactor(7);
684         }
685         return rate;
686     }
687     
688     function _setPriceFactor(uint cents) internal constant returns (uint256){
689       uint256 ETHUSD2CENTS = ethusdrate.mul(100); // convert USD price per ethers to cents
690       uint256 tokenRatePerWei = ((ETHUSD2CENTS.mul(1000)).div(cents)); // calculates the rate of the tokens to be given per wei, checking the rate in cents  
691       return tokenRatePerWei;
692     }
693     
694     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
695         _deliverTokens(_beneficiary, _tokenAmount);
696     }
697     
698     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
699         _transfer(_beneficiary, _tokenAmount);
700         _updateLots(_tokenAmount);
701     }
702     
703     function _updateLots(uint256 _tokenAmount) internal {
704         if(lot1 != 0){
705             if(_tokenAmount > lot1){
706                 lot2 = lot2.add(lot1); // add lot1 to lot2
707                 lot1 = lot1.sub(lot1); // make lot1 empty
708                 lot2 = lot2.sub(_tokenAmount); // subtract the distributed tokens from lot2
709             }
710             else {
711                 lot1 = lot1.sub(_tokenAmount); // subtract the distributed tokens from lot1
712             }
713         }
714         else if(lot2 != 0){
715             if(_tokenAmount > lot2){
716                 lot3 = lot3.add(lot2);  // add lot2 to lot3
717                 lot2 = lot2.sub(lot2); // make lot2 empty
718                 lot3 = lot3.sub(_tokenAmount); //subtract the distributed tokens from lot3
719             }
720             else {
721                 lot2 = lot2.sub(_tokenAmount); // subtract the distributed tokens from lot2
722             }
723         }
724         else if(lot3 != 0){
725             lot3 = lot3.sub(_tokenAmount); //subtract the distributed tokens from lot3
726         }
727     }
728     
729     function _forwardFunds() internal {
730         wallet.transfer(address(this).balance);
731     }
732     
733     function _transfer(address to, uint tokens) internal returns (bool success) {
734         // prevent transfer to 0x0, use burn instead
735         require(to != 0x0);
736         require(balances[this] >= tokens );
737         require(balances[to] + tokens >= balances[to]);
738         balances[this] = balances[this].sub(tokens);
739         balances[to] = balances[to].add(tokens);
740         emit Transfer(this,to,tokens);
741         return true;
742     }
743     
744     function freeTokens(address receiver, uint tokenAmount) external onlyOwner {
745         require(balances[this] != 0);
746         _transfer(receiver,tokenAmount*10**uint(decimals));
747     }
748     
749     function drainFunds() external onlyOwner {
750         _forwardFunds();
751     }
752     
753     function changeWallet(address _newWallet) external onlyOwner {
754         wallet = _newWallet;
755     }
756     
757     function stopICO() external onlyOwner {
758         Open = false;
759     }
760     
761     /* ERC20Interface function's implementation */
762     function totalSupply() public constant returns (uint){
763        return 12e27; // 12 billion 
764     }
765     
766     // ------------------------------------------------------------------------
767     // Get the token balance for account `tokenOwner`
768     // ------------------------------------------------------------------------
769     function balanceOf(address tokenOwner) public constant returns (uint balance) {
770         return balances[tokenOwner];
771     }
772 
773     // ------------------------------------------------------------------------
774     // Transfer the balance from token owner's account to `to` account
775     // - Owner's account must have sufficient balance to transfer
776     // - 0 value transfers are allowed
777     // ------------------------------------------------------------------------
778     function transfer(address to, uint tokens) public returns (bool success) {
779         // prevent transfer to 0x0, use burn instead
780         require(to != 0x0);
781         require(balances[msg.sender] >= tokens );
782         require(balances[to] + tokens >= balances[to]);
783         balances[msg.sender] = balances[msg.sender].sub(tokens);
784         balances[to] = balances[to].add(tokens);
785         emit Transfer(msg.sender,to,tokens);
786         return true;
787     }
788     
789     function transferWithMsg(address to, uint tokens, string message) public returns (bool success){
790         // prevent transfer to 0x0, use burn instead
791         require(to != 0x0);
792         require(balances[msg.sender] >= tokens );
793         require(balances[to] + tokens >= balances[to]);
794         balances[msg.sender] = balances[msg.sender].sub(tokens);
795         balances[to] = balances[to].add(tokens);
796         emit Transfer(msg.sender,to,tokens);
797         emit TransferWithMsg(msg.sender, to, tokens, message);
798         return true;
799     }
800     
801     // ------------------------------------------------------------------------
802     // Token owner can approve for `spender` to transferFrom(...) `tokens`
803     // from the token owner's account
804     // ------------------------------------------------------------------------
805     function approve(address spender, uint tokens) public returns (bool success){
806         allowed[msg.sender][spender] = tokens;
807         emit Approval(msg.sender,spender,tokens);
808         return true;
809     }
810 
811     // ------------------------------------------------------------------------
812     // Transfer `tokens` from the `from` account to the `to` account
813     // 
814     // The calling account must already have sufficient tokens approve(...)-d
815     // for spending from the `from` account and
816     // - From account must have sufficient balance to transfer
817     // - Spender must have sufficient allowance to transfer
818     // - 0 value transfers are allowed
819     // ------------------------------------------------------------------------
820     function transferFrom(address from, address to, uint tokens) public returns (bool success){
821         require(tokens <= allowed[from][msg.sender]); //check allowance
822         require(balances[from] >= tokens);
823         balances[from] = balances[from].sub(tokens);
824         balances[to] = balances[to].add(tokens);
825         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
826         emit Transfer(from,to,tokens);
827         return true;
828     }
829     // ------------------------------------------------------------------------
830     // Returns the amount of tokens approved by the owner that can be
831     // transferred to the spender's account
832     // ------------------------------------------------------------------------
833     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
834         return allowed[tokenOwner][spender];
835     }
836 
837 }