1 pragma solidity >=0.4.1 <=0.4.20;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
2 contract OraclizeI {
3     address public cbAddress;
4     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
5     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
6     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
7     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
8     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
9     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
10     function getPrice(string _datasource) returns (uint _dsprice);
11     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
12     function useCoupon(string _coupon);
13     function setProofType(byte _proofType);
14     function setConfig(bytes32 _config);
15     function setCustomGasPrice(uint _gasPrice);
16 }
17 contract OraclizeAddrResolverI {
18     function getAddress() returns (address _addr);
19 }
20 contract usingOraclize {
21     uint constant day = 60*60*24;
22     uint constant week = 60*60*24*7;
23     uint constant month = 60*60*24*30;
24     byte constant proofType_NONE = 0x00;
25     byte constant proofType_TLSNotary = 0x10;
26     byte constant proofStorage_IPFS = 0x01;
27     uint8 constant networkID_auto = 0;
28     uint8 constant networkID_mainnet = 1;
29     uint8 constant networkID_testnet = 2;
30     uint8 constant networkID_morden = 2;
31     uint8 constant networkID_consensys = 161;
32 
33     OraclizeAddrResolverI OAR;
34 
35     OraclizeI oraclize;
36     modifier oraclizeAPI {
37         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
38         oraclize = OraclizeI(OAR.getAddress());
39         _;
40     }
41     modifier coupon(string code){
42         oraclize = OraclizeI(OAR.getAddress());
43         oraclize.useCoupon(code);
44         _;
45     }
46 
47     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
48         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
49             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
50             return true;
51         }
52         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
53             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
54             return true;
55         }
56         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
57             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
58             return true;
59         }
60         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
61             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
62             return true;
63         }
64         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
65             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
66             return true;
67         }
68         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
69             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
70             return true;
71         }
72         return false;
73     }
74 
75     function __callback(bytes32 myid, string result) {
76         __callback(myid, result, new bytes(0));
77     }
78     function __callback(bytes32 myid, string result, bytes proof) {
79     }
80 
81     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
82         return oraclize.getPrice(datasource);
83     }
84 
85     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
86         return oraclize.getPrice(datasource, gaslimit);
87     }
88 
89     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
90         uint price = oraclize.getPrice(datasource);
91         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
92         return oraclize.query.value(price)(0, datasource, arg);
93     }
94     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
95         uint price = oraclize.getPrice(datasource);
96         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
97         return oraclize.query.value(price)(timestamp, datasource, arg);
98     }
99     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
100         uint price = oraclize.getPrice(datasource, gaslimit);
101         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
102         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
103     }
104     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
105         uint price = oraclize.getPrice(datasource, gaslimit);
106         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
107         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
108     }
109     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
110         uint price = oraclize.getPrice(datasource);
111         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
112         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
113     }
114     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
115         uint price = oraclize.getPrice(datasource);
116         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
117         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
118     }
119     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
120         uint price = oraclize.getPrice(datasource, gaslimit);
121         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
122         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
123     }
124     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
125         uint price = oraclize.getPrice(datasource, gaslimit);
126         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
127         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
128     }
129     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
130         uint price = oraclize.getPrice(datasource);
131         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
132         bytes memory args = stra2cbor(argN);
133         return oraclize.queryN.value(price)(0, datasource, args);
134     }
135     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
136         uint price = oraclize.getPrice(datasource);
137         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
138         bytes memory args = stra2cbor(argN);
139         return oraclize.queryN.value(price)(timestamp, datasource, args);
140     }
141     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
142         uint price = oraclize.getPrice(datasource, gaslimit);
143         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
144         bytes memory args = stra2cbor(argN);
145         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
146     }
147     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
148         uint price = oraclize.getPrice(datasource, gaslimit);
149         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
150         bytes memory args = stra2cbor(argN);
151         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
152     }
153     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
154         string[] memory dynargs = new string[](1);
155         dynargs[0] = args[0];
156         return oraclize_query(datasource, dynargs);
157     }
158     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
159         string[] memory dynargs = new string[](1);
160         dynargs[0] = args[0];
161         return oraclize_query(timestamp, datasource, dynargs);
162     }
163     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
164         string[] memory dynargs = new string[](1);
165         dynargs[0] = args[0];
166         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
167     }
168     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
169         string[] memory dynargs = new string[](1);
170         dynargs[0] = args[0];
171         return oraclize_query(datasource, dynargs, gaslimit);
172     }
173 
174     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
175         string[] memory dynargs = new string[](2);
176         dynargs[0] = args[0];
177         dynargs[1] = args[1];
178         return oraclize_query(datasource, dynargs);
179     }
180     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
181         string[] memory dynargs = new string[](2);
182         dynargs[0] = args[0];
183         dynargs[1] = args[1];
184         return oraclize_query(timestamp, datasource, dynargs);
185     }
186     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
187         string[] memory dynargs = new string[](2);
188         dynargs[0] = args[0];
189         dynargs[1] = args[1];
190         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
191     }
192     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
193         string[] memory dynargs = new string[](2);
194         dynargs[0] = args[0];
195         dynargs[1] = args[1];
196         return oraclize_query(datasource, dynargs, gaslimit);
197     }
198     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
199         string[] memory dynargs = new string[](3);
200         dynargs[0] = args[0];
201         dynargs[1] = args[1];
202         dynargs[2] = args[2];
203         return oraclize_query(datasource, dynargs);
204     }
205     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
206         string[] memory dynargs = new string[](3);
207         dynargs[0] = args[0];
208         dynargs[1] = args[1];
209         dynargs[2] = args[2];
210         return oraclize_query(timestamp, datasource, dynargs);
211     }
212     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
213         string[] memory dynargs = new string[](3);
214         dynargs[0] = args[0];
215         dynargs[1] = args[1];
216         dynargs[2] = args[2];
217         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
218     }
219     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
220         string[] memory dynargs = new string[](3);
221         dynargs[0] = args[0];
222         dynargs[1] = args[1];
223         dynargs[2] = args[2];
224         return oraclize_query(datasource, dynargs, gaslimit);
225     }
226 
227     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
228         string[] memory dynargs = new string[](4);
229         dynargs[0] = args[0];
230         dynargs[1] = args[1];
231         dynargs[2] = args[2];
232         dynargs[3] = args[3];
233         return oraclize_query(datasource, dynargs);
234     }
235     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
236         string[] memory dynargs = new string[](4);
237         dynargs[0] = args[0];
238         dynargs[1] = args[1];
239         dynargs[2] = args[2];
240         dynargs[3] = args[3];
241         return oraclize_query(timestamp, datasource, dynargs);
242     }
243     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
244         string[] memory dynargs = new string[](4);
245         dynargs[0] = args[0];
246         dynargs[1] = args[1];
247         dynargs[2] = args[2];
248         dynargs[3] = args[3];
249         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
250     }
251     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
252         string[] memory dynargs = new string[](4);
253         dynargs[0] = args[0];
254         dynargs[1] = args[1];
255         dynargs[2] = args[2];
256         dynargs[3] = args[3];
257         return oraclize_query(datasource, dynargs, gaslimit);
258     }
259     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
260         string[] memory dynargs = new string[](5);
261         dynargs[0] = args[0];
262         dynargs[1] = args[1];
263         dynargs[2] = args[2];
264         dynargs[3] = args[3];
265         dynargs[4] = args[4];
266         return oraclize_query(datasource, dynargs);
267     }
268     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
269         string[] memory dynargs = new string[](5);
270         dynargs[0] = args[0];
271         dynargs[1] = args[1];
272         dynargs[2] = args[2];
273         dynargs[3] = args[3];
274         dynargs[4] = args[4];
275         return oraclize_query(timestamp, datasource, dynargs);
276     }
277     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
278         string[] memory dynargs = new string[](5);
279         dynargs[0] = args[0];
280         dynargs[1] = args[1];
281         dynargs[2] = args[2];
282         dynargs[3] = args[3];
283         dynargs[4] = args[4];
284         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
285     }
286     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
287         string[] memory dynargs = new string[](5);
288         dynargs[0] = args[0];
289         dynargs[1] = args[1];
290         dynargs[2] = args[2];
291         dynargs[3] = args[3];
292         dynargs[4] = args[4];
293         return oraclize_query(datasource, dynargs, gaslimit);
294     }
295 
296     function oraclize_cbAddress() oraclizeAPI internal returns (address){
297         return oraclize.cbAddress();
298     }
299     function oraclize_setProof(byte proofP) oraclizeAPI internal {
300         return oraclize.setProofType(proofP);
301     }
302     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
303         return oraclize.setCustomGasPrice(gasPrice);
304     }
305     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
306         return oraclize.setConfig(config);
307     }
308 
309     function getCodeSize(address _addr) constant internal returns(uint _size) {
310         assembly {
311             _size := extcodesize(_addr)
312         }
313     }
314 
315     function parseAddr(string _a) internal returns (address){
316         bytes memory tmp = bytes(_a);
317         uint160 iaddr = 0;
318         uint160 b1;
319         uint160 b2;
320         for (uint i=2; i<2+2*20; i+=2){
321             iaddr *= 256;
322             b1 = uint160(tmp[i]);
323             b2 = uint160(tmp[i+1]);
324             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
325             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
326             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
327             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
328             iaddr += (b1*16+b2);
329         }
330         return address(iaddr);
331     }
332 
333     function strCompare(string _a, string _b) internal returns (int) {
334         bytes memory a = bytes(_a);
335         bytes memory b = bytes(_b);
336         uint minLength = a.length;
337         if (b.length < minLength) minLength = b.length;
338         for (uint i = 0; i < minLength; i ++)
339             if (a[i] < b[i])
340                 return -1;
341             else if (a[i] > b[i])
342                 return 1;
343         if (a.length < b.length)
344             return -1;
345         else if (a.length > b.length)
346             return 1;
347         else
348             return 0;
349     }
350 
351     function indexOf(string _haystack, string _needle) internal returns (int) {
352         bytes memory h = bytes(_haystack);
353         bytes memory n = bytes(_needle);
354         if(h.length < 1 || n.length < 1 || (n.length > h.length))
355             return -1;
356         else if(h.length > (2**128 -1))
357             return -1;
358         else
359         {
360             uint subindex = 0;
361             for (uint i = 0; i < h.length; i ++)
362             {
363                 if (h[i] == n[0])
364                 {
365                     subindex = 1;
366                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
367                     {
368                         subindex++;
369                     }
370                     if(subindex == n.length)
371                         return int(i);
372                 }
373             }
374             return -1;
375         }
376     }
377 
378     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
379         bytes memory _ba = bytes(_a);
380         bytes memory _bb = bytes(_b);
381         bytes memory _bc = bytes(_c);
382         bytes memory _bd = bytes(_d);
383         bytes memory _be = bytes(_e);
384         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
385         bytes memory babcde = bytes(abcde);
386         uint k = 0;
387         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
388         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
389         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
390         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
391         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
392         return string(babcde);
393     }
394 
395     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
396         return strConcat(_a, _b, _c, _d, "");
397     }
398 
399     function strConcat(string _a, string _b, string _c) internal returns (string) {
400         return strConcat(_a, _b, _c, "", "");
401     }
402 
403     function strConcat(string _a, string _b) internal returns (string) {
404         return strConcat(_a, _b, "", "", "");
405     }
406 
407     // parseInt
408     function parseInt(string _a) internal returns (uint) {
409         return parseInt(_a, 0);
410     }
411 
412     // parseInt(parseFloat*10^_b)
413     function parseInt(string _a, uint _b) internal returns (uint) {
414         bytes memory bresult = bytes(_a);
415         uint mint = 0;
416         bool decimals = false;
417         for (uint i=0; i<bresult.length; i++){
418             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
419                 if (decimals){
420                    if (_b == 0) break;
421                     else _b--;
422                 }
423                 mint *= 10;
424                 mint += uint(bresult[i]) - 48;
425             } else if (bresult[i] == 46) decimals = true;
426         }
427         if (_b > 0) mint *= 10**_b;
428         return mint;
429     }
430 
431     function uint2str(uint i) internal returns (string){
432         if (i == 0) return "0";
433         uint j = i;
434         uint len;
435         while (j != 0){
436             len++;
437             j /= 10;
438         }
439         bytes memory bstr = new bytes(len);
440         uint k = len - 1;
441         while (i != 0){
442             bstr[k--] = byte(48 + i % 10);
443             i /= 10;
444         }
445         return string(bstr);
446     }
447 
448     function stra2cbor(string[] arr) internal returns (bytes) {
449             uint arrlen = arr.length;
450 
451             // get correct cbor output length
452             uint outputlen = 0;
453             bytes[] memory elemArray = new bytes[](arrlen);
454             for (uint i = 0; i < arrlen; i++) {
455                 elemArray[i] = (bytes(arr[i]));
456                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
457             }
458             uint ctr = 0;
459             uint cborlen = arrlen + 0x80;
460             outputlen += byte(cborlen).length;
461             bytes memory res = new bytes(outputlen);
462 
463             while (byte(cborlen).length > ctr) {
464                 res[ctr] = byte(cborlen)[ctr];
465                 ctr++;
466             }
467             for (i = 0; i < arrlen; i++) {
468                 res[ctr] = 0x5F;
469                 ctr++;
470                 for (uint x = 0; x < elemArray[i].length; x++) {
471                     // if there's a bug with larger strings, this may be the culprit
472                     if (x % 23 == 0) {
473                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
474                         elemcborlen += 0x40;
475                         uint lctr = ctr;
476                         while (byte(elemcborlen).length > ctr - lctr) {
477                             res[ctr] = byte(elemcborlen)[ctr - lctr];
478                             ctr++;
479                         }
480                     }
481                     res[ctr] = elemArray[i][x];
482                     ctr++;
483                 }
484                 res[ctr] = 0xFF;
485                 ctr++;
486             }
487             return res;
488         }
489 }
490 /* =========================================================================================================*/
491 /**
492  * @title SafeMath
493  * @dev Math operations with safety checks that throw on error
494  */
495 library SafeMath {
496     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
497         if (a == 0) {
498             return 0;
499         }
500         uint256 c = a * b;
501         assert(c / a == b);
502         return c;
503     }
504 
505     function div(uint256 a, uint256 b) internal pure returns(uint256) {
506         // assert(b > 0); // Solidity automatically throws when dividing by 0
507         uint256 c = a / b;
508         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
509         return c;
510     }
511 
512     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
513         assert(b <= a);
514         return a - b;
515     }
516 
517     function add(uint256 a, uint256 b) internal pure returns(uint256) {
518         uint256 c = a + b;
519         assert(c >= a);
520         return c;
521     }
522 }
523 
524 contract ERC20 {
525     function totalSupply()public view returns(uint total_Supply);
526     function balanceOf(address who)public view returns(uint256);
527     function allowance(address owner, address spender)public view returns(uint);
528     function transferFrom(address from, address to, uint value)public returns(bool ok);
529     function approve(address spender, uint value)public returns(bool ok);
530     function transfer(address to, uint value)public returns(bool ok);
531     event Transfer(address indexed from, address indexed to, uint value);
532     event Approval(address indexed owner, address indexed spender, uint value);
533 }
534 
535 /*
536 ** OutCloud Contract begins here 
537 **/
538 contract OutCloud is ERC20, usingOraclize {
539     using SafeMath for uint256;
540     uint ETHUSD;
541     uint _totalsupply = 1200000000 * 10 ** 18; // 1.2 Billion OUT Coins
542     uint currentTokenPriceFactor;
543     uint256 no_of_tokens;
544     uint256 total_token;
545     uint256 public ico_startdate;
546     uint256 public preico_startdate;
547     uint256 public preico_enddate;
548     uint256 constant public ETH_DECIMALS = 10 ** 18;
549     uint256 ethreceived;
550     uint256 TotalICOSupply;
551     uint256 TotalPREICOSupply;
552     uint256 ReservedSupplies;
553     uint256 minContribution = 1; // 1 USD  (1 USD = 100 cents) 
554     uint256 rate;
555     uint256 weiAmount;
556     bool stopped = false;
557     bool public lockstatus;
558     string public constant name = "OutCloud";
559     string public constant symbol = "OUT";
560     string public ethereum2USDprice;
561     address sen;
562     address public owner;
563     address public wallet; // address to receive ether from smart contract
564     mapping(address => uint) balances;
565     mapping(address => mapping(address => uint)) allowed;
566     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
567     event LogPriceUpdated(string price);
568     event LogNewOraclizeQuery(string description);
569     enum Stages {
570         NOTSTARTED,
571         PREICO,
572         ICO,
573         ENDED
574     }
575     Stages public stage;
576     
577     modifier atStage(Stages _stage) {
578         require (stage == _stage);
579         _;
580     }
581 
582     modifier onlyOwner(){
583         require (msg.sender == owner);
584      _;
585     }
586   
587     function OutCloud(address _owner, address _wallet) public {
588         owner = _owner;
589 		wallet = _wallet;
590         TotalICOSupply = 400000000 * 10 ** 18;
591         TotalPREICOSupply = 300000000 * 10 ** 18;
592         ReservedSupplies = 500000000 * 10 ** 18;
593         balances[this] = _totalsupply;  // 500 Million given to owner
594         stage = Stages.NOTSTARTED;
595         lockstatus = true;
596         Transfer(0, this, _totalsupply);
597     }
598  
599     function () public payable {
600         buyTokens();
601     }
602     function __callback(bytes32 myid, string result) {
603     if (msg.sender != oraclize_cbAddress()) revert();
604         ethereum2USDprice = result;
605         ETHUSD = parseInt(result,0);
606         LogPriceUpdated(result);
607         if(ETHUSD > 0){
608             _pro(sen, weiAmount);
609         }
610     }
611 
612     function updatePrice() public payable {
613         if (oraclize_getPrice("json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0") > this.balance) {
614             LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
615         revert();
616             
617         }
618         else {
619         LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
620         oraclize_query("URL","json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
621         }
622     }
623 
624     function buyTokens() public payable {
625         sen = msg.sender;
626         weiAmount = msg.value;
627         _preValidatePurchase(sen, weiAmount);
628         updatePrice();
629     }
630     
631     function _pro (address _beneficiary, uint256 weiAmount) internal {
632         // calculate token amount to sell
633         uint256 tokens = _getTokenAmount(weiAmount);
634         // update state
635         ethreceived = ethreceived.add(weiAmount);
636 
637         _processPurchase(_beneficiary, tokens);
638         TokenPurchase(this, _beneficiary, weiAmount, tokens);
639 
640     //    _forwardFunds();
641         
642     }
643     
644     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
645       //  require(_weiAmount >= _calculateMinimumprice());
646         require(stage != Stages.ENDED);
647         require(!stopped);
648         require(_beneficiary != address(0x0));
649         require(_weiAmount != 0);
650         require(_weiAmount >= (minContribution.mul(ETH_DECIMALS)).div(300));
651     }
652     /* calculates the minimum requirements of weis (10USD) according to current rate of ETH TO USD*/
653    /* function _calculateMinimumprice() internal view returns (uint256){
654         uint256 minimumWeisRequired;
655         if(ETHUSD > 0){minimumWeisRequired = (minContribution.mul(ETH_DECIMALS)).div(ETHUSD);}
656         else{minimumWeisRequired = (minContribution.mul(ETH_DECIMALS)).div(300);}
657         return minimumWeisRequired;
658     } */
659     
660     function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {
661         _setRate();
662         return _weiAmount.mul(rate);
663     }
664     
665     function _setRate() internal{
666         uint256 ETHUSD = parseInt(ethereum2USDprice,0);
667         // check which stage is open (pre-ico or ico)
668         if (stage == Stages.PREICO && now <= preico_enddate){
669             require(balances[this] != _totalsupply.sub(TotalPREICOSupply));
670             // pre-ico is open
671             currentTokenPriceFactor = (block.timestamp.sub(preico_startdate)).div(604800); // 1 week time period in seconds
672             if (currentTokenPriceFactor== 0)       // week 1 
673                 _setPriceFactor(10, ETHUSD);                     
674             else if (currentTokenPriceFactor == 1) // week 2
675                  _setPriceFactor(11, ETHUSD);                    
676             else if (currentTokenPriceFactor ==2 ) // week 3
677                  _setPriceFactor(12, ETHUSD);                      
678             else if (currentTokenPriceFactor == 3) // week 4
679                  _setPriceFactor(13, ETHUSD);                      
680         }
681         else  if (stage == Stages.ICO ){
682             require(balances[this] != _totalsupply.sub(TotalICOSupply.add(TotalPREICOSupply)));
683             _setPriceFactor(15, ETHUSD); // ICO started
684         } 
685         else {
686             revert();
687         }
688     }
689   
690     function _setPriceFactor(uint cents, uint256 ETHUSD) internal {
691       uint256 ETHUSD2CENTS = ETHUSD.mul(100); // convert USD price per ethers to cents
692       uint256 tokenRatePerWei = ETHUSD2CENTS.div(cents); // calculates the rate of the tokens to be given per wei, checking the rate in cents  
693       rate = tokenRatePerWei;
694   }
695   
696     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
697         _deliverTokens(_beneficiary, _tokenAmount);
698     }
699   
700     function _forwardFunds() internal {
701         wallet.transfer(address(this).balance);
702     }
703     
704     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
705         _transfer(_beneficiary,_tokenAmount);
706     }
707     // called by the owner, pause ICO
708     function StopICO() external onlyOwner  {
709         stopped = true;
710 
711     }
712 
713     // called by the owner , resumes ICO
714     function releaseICO() external onlyOwner{
715         stopped = false;
716     }
717     
718     function setEthmainAddress(address newEthfundaddress) external onlyOwner{
719         wallet = newEthfundaddress;
720     }
721  
722     function start_PREICO() external onlyOwner atStage(Stages.NOTSTARTED){
723         stage = Stages.PREICO;
724         stopped = false;
725         preico_startdate = now;
726         preico_enddate = now + 28 days; //time period for preICO = 4 weeks
727     }
728     
729     function start_ICO() external onlyOwner atStage(Stages.PREICO){
730         stage = Stages.ICO;
731         stopped = false;
732         ico_startdate = now;
733     }
734 
735     function end_ICO() external onlyOwner atStage(Stages.ICO){
736         stage = Stages.ENDED;
737         lockstatus = false;
738         
739     }
740     
741    // This function can be used by owner in emergency to update running status parameter
742     function removeLocking(bool RunningStatusLock) external onlyOwner{
743         lockstatus = RunningStatusLock;
744     }
745 
746     // what is the total supply of the ech tokens
747     function totalSupply() public view returns(uint256 total_Supply) {
748         total_Supply = _totalsupply;
749     }
750 
751     // What is the balance of a particular account?
752     function balanceOf(address _owner)public view returns(uint256 balance) {
753         return balances[_owner];
754     }
755 
756     // Send _value amount of tokens from address _from to address _to
757     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
758     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
759     // fees in sub-currencies; the command should fail unless the _from account has
760     // deliberately authorized the sender of the message via some mechanism; we propose
761     // these standardized APIs for approval:
762     function transferFrom(address _from, address _to, uint256 _amount)public returns(bool success) {
763         require(_to != 0x0);
764         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
765         balances[_from] = (balances[_from]).sub(_amount);
766         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
767         balances[_to] = (balances[_to]).add(_amount);
768         Transfer(_from, _to, _amount);
769         return true;
770     }
771 
772     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
773     // If this function is called again it overwrites the current allowance with _value.
774     function approve(address _spender, uint256 _amount)public returns(bool success) {
775         require(_spender != 0x0);
776         require( !lockstatus);
777         allowed[msg.sender][_spender] = _amount;
778         Approval(msg.sender, _spender, _amount);
779         return true;
780     }
781 
782     function allowance(address _owner, address _spender)public view returns(uint256 remaining) {
783         require(_owner != 0x0 && _spender != 0x0);
784         return allowed[_owner][_spender];
785     }
786     
787     // Transfer the balance from owner's account to another account
788     function transfer(address _to, uint256 _amount) public returns(bool success) {
789        
790        if ( lockstatus && msg.sender == owner) {
791             require(balances[msg.sender] >= _amount && _amount >= 0);
792             balances[msg.sender] = balances[msg.sender].sub(_amount);
793             balances[_to] += _amount;
794             Transfer(msg.sender, _to, _amount);
795             return true;
796         }
797       
798           else if(!lockstatus)
799          {
800            require(balances[msg.sender] >= _amount && _amount >= 0);
801            balances[msg.sender] = (balances[msg.sender]).sub(_amount);
802            balances[_to] = (balances[_to]).add(_amount);
803            Transfer(msg.sender, _to, _amount);
804            return true;
805           }
806 
807         else{
808             revert();
809         }
810     }
811 
812     //In case the ownership needs to be transferred
813 	function transferOwnership(address newOwner)public onlyOwner{
814 	    require( newOwner != 0x0);
815 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
816 	    balances[owner] = 0;
817 	    owner = newOwner;
818 	    Transfer(msg.sender, newOwner, balances[newOwner]);
819 	}
820     
821     function _transfer(address _to, uint _tokens) internal returns (bool success){
822         // prevent transfer to 0x0, use burn instead
823         require(_to != 0x0);
824         require(balances[this] >= _tokens);
825         require(balances[_to] + _tokens >= balances[_to]);
826         balances[this] = balances[this].sub(_tokens);
827         balances[_to] = balances[_to].add(_tokens);
828         Transfer(this,_to,_tokens);
829         return true;
830     }
831     
832     function freeTokens(address receiver, uint tokenAmount) external onlyOwner {
833         require(balances[this] != 0);
834         _transfer(receiver,tokenAmount.mul(ETH_DECIMALS));
835     }
836     
837     function drainFunds() external onlyOwner {
838         _forwardFunds();
839     }
840 }