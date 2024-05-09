1 pragma solidity ^0.4.8;
2 
3 contract OraclizeI {
4     address public cbAddress;
5     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
6     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
7     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
8     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
9     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
10     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
11     function getPrice(string _datasource) returns (uint _dsprice);
12     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
13     function useCoupon(string _coupon);
14     function setProofType(byte _proofType);
15     function setConfig(bytes32 _config);
16     function setCustomGasPrice(uint _gasPrice);
17 }
18 contract OraclizeAddrResolverI {
19     function getAddress() returns (address _addr);
20 }
21 contract usingOraclize {
22     uint constant day = 60*60*24;
23     uint constant week = 60*60*24*7;
24     uint constant month = 60*60*24*30;
25     byte constant proofType_NONE = 0x00;
26     byte constant proofType_TLSNotary = 0x10;
27     byte constant proofStorage_IPFS = 0x01;
28     uint8 constant networkID_auto = 0;
29     uint8 constant networkID_mainnet = 1;
30     uint8 constant networkID_testnet = 2;
31     uint8 constant networkID_morden = 2;
32     uint8 constant networkID_consensys = 161;
33 
34     OraclizeAddrResolverI OAR;
35 
36     OraclizeI oraclize;
37     modifier oraclizeAPI {
38         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
39         oraclize = OraclizeI(OAR.getAddress());
40         _;
41     }
42     modifier coupon(string code){
43         oraclize = OraclizeI(OAR.getAddress());
44         oraclize.useCoupon(code);
45         _;
46     }
47 
48     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
49         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
50             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
51             return true;
52         }
53         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
54             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
55             return true;
56         }
57         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
58             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
59             return true;
60         }
61         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
62             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
63             return true;
64         }
65         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
66             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
67             return true;
68         }
69         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
70             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
71             return true;
72         }
73         return false;
74     }
75 
76     function __callback(bytes32 myid, string result) {
77         __callback(myid, result, new bytes(0));
78     }
79     function __callback(bytes32 myid, string result, bytes proof) {
80     }
81 
82     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
83         return oraclize.getPrice(datasource);
84     }
85 
86     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
87         return oraclize.getPrice(datasource, gaslimit);
88     }
89     
90     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
91         uint price = oraclize.getPrice(datasource);
92         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
93         return oraclize.query.value(price)(0, datasource, arg);
94     }
95     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
96         uint price = oraclize.getPrice(datasource);
97         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
98         return oraclize.query.value(price)(timestamp, datasource, arg);
99     }
100     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
101         uint price = oraclize.getPrice(datasource, gaslimit);
102         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
103         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
104     }
105     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
106         uint price = oraclize.getPrice(datasource, gaslimit);
107         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
108         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
109     }
110     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
111         uint price = oraclize.getPrice(datasource);
112         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
113         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
114     }
115     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
116         uint price = oraclize.getPrice(datasource);
117         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
118         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
119     }
120     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
121         uint price = oraclize.getPrice(datasource, gaslimit);
122         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
123         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
124     }
125     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
126         uint price = oraclize.getPrice(datasource, gaslimit);
127         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
128         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
129     }
130     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
131         uint price = oraclize.getPrice(datasource);
132         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
133         bytes memory args = stra2cbor(argN);
134         return oraclize.queryN.value(price)(0, datasource, args);
135     }
136     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
137         uint price = oraclize.getPrice(datasource);
138         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
139         bytes memory args = stra2cbor(argN);
140         return oraclize.queryN.value(price)(timestamp, datasource, args);
141     }
142     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
143         uint price = oraclize.getPrice(datasource, gaslimit);
144         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
145         bytes memory args = stra2cbor(argN);
146         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
147     }
148     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource, gaslimit);
150         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
151         bytes memory args = stra2cbor(argN);
152         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
153     }
154     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
155         string[] memory dynargs = new string[](1);
156         dynargs[0] = args[0];
157         return oraclize_query(datasource, dynargs);
158     }
159     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
160         string[] memory dynargs = new string[](1);
161         dynargs[0] = args[0];
162         return oraclize_query(timestamp, datasource, dynargs);
163     }
164     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
165         string[] memory dynargs = new string[](1);
166         dynargs[0] = args[0];
167         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
168     }
169     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
170         string[] memory dynargs = new string[](1);
171         dynargs[0] = args[0];       
172         return oraclize_query(datasource, dynargs, gaslimit);
173     }
174     
175     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
176         string[] memory dynargs = new string[](2);
177         dynargs[0] = args[0];
178         dynargs[1] = args[1];
179         return oraclize_query(datasource, dynargs);
180     }
181     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
182         string[] memory dynargs = new string[](2);
183         dynargs[0] = args[0];
184         dynargs[1] = args[1];
185         return oraclize_query(timestamp, datasource, dynargs);
186     }
187     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
188         string[] memory dynargs = new string[](2);
189         dynargs[0] = args[0];
190         dynargs[1] = args[1];
191         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
192     }
193     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
194         string[] memory dynargs = new string[](2);
195         dynargs[0] = args[0];
196         dynargs[1] = args[1];
197         return oraclize_query(datasource, dynargs, gaslimit);
198     }
199     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
200         string[] memory dynargs = new string[](3);
201         dynargs[0] = args[0];
202         dynargs[1] = args[1];
203         dynargs[2] = args[2];
204         return oraclize_query(datasource, dynargs);
205     }
206     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
207         string[] memory dynargs = new string[](3);
208         dynargs[0] = args[0];
209         dynargs[1] = args[1];
210         dynargs[2] = args[2];
211         return oraclize_query(timestamp, datasource, dynargs);
212     }
213     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
214         string[] memory dynargs = new string[](3);
215         dynargs[0] = args[0];
216         dynargs[1] = args[1];
217         dynargs[2] = args[2];
218         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
219     }
220     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
221         string[] memory dynargs = new string[](3);
222         dynargs[0] = args[0];
223         dynargs[1] = args[1];
224         dynargs[2] = args[2];
225         return oraclize_query(datasource, dynargs, gaslimit);
226     }
227     
228     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
229         string[] memory dynargs = new string[](4);
230         dynargs[0] = args[0];
231         dynargs[1] = args[1];
232         dynargs[2] = args[2];
233         dynargs[3] = args[3];
234         return oraclize_query(datasource, dynargs);
235     }
236     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
237         string[] memory dynargs = new string[](4);
238         dynargs[0] = args[0];
239         dynargs[1] = args[1];
240         dynargs[2] = args[2];
241         dynargs[3] = args[3];
242         return oraclize_query(timestamp, datasource, dynargs);
243     }
244     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
245         string[] memory dynargs = new string[](4);
246         dynargs[0] = args[0];
247         dynargs[1] = args[1];
248         dynargs[2] = args[2];
249         dynargs[3] = args[3];
250         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
251     }
252     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
253         string[] memory dynargs = new string[](4);
254         dynargs[0] = args[0];
255         dynargs[1] = args[1];
256         dynargs[2] = args[2];
257         dynargs[3] = args[3];
258         return oraclize_query(datasource, dynargs, gaslimit);
259     }
260     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
261         string[] memory dynargs = new string[](5);
262         dynargs[0] = args[0];
263         dynargs[1] = args[1];
264         dynargs[2] = args[2];
265         dynargs[3] = args[3];
266         dynargs[4] = args[4];
267         return oraclize_query(datasource, dynargs);
268     }
269     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
270         string[] memory dynargs = new string[](5);
271         dynargs[0] = args[0];
272         dynargs[1] = args[1];
273         dynargs[2] = args[2];
274         dynargs[3] = args[3];
275         dynargs[4] = args[4];
276         return oraclize_query(timestamp, datasource, dynargs);
277     }
278     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
279         string[] memory dynargs = new string[](5);
280         dynargs[0] = args[0];
281         dynargs[1] = args[1];
282         dynargs[2] = args[2];
283         dynargs[3] = args[3];
284         dynargs[4] = args[4];
285         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
286     }
287     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
288         string[] memory dynargs = new string[](5);
289         dynargs[0] = args[0];
290         dynargs[1] = args[1];
291         dynargs[2] = args[2];
292         dynargs[3] = args[3];
293         dynargs[4] = args[4];
294         return oraclize_query(datasource, dynargs, gaslimit);
295     }
296 
297     function oraclize_cbAddress() oraclizeAPI internal returns (address){
298         return oraclize.cbAddress();
299     }
300     function oraclize_setProof(byte proofP) oraclizeAPI internal {
301         return oraclize.setProofType(proofP);
302     }
303     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
304         return oraclize.setCustomGasPrice(gasPrice);
305     }
306     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
307         return oraclize.setConfig(config);
308     }
309 
310     function getCodeSize(address _addr) constant internal returns(uint _size) {
311         assembly {
312             _size := extcodesize(_addr)
313         }
314     }
315 
316     function parseAddr(string _a) internal returns (address){
317         bytes memory tmp = bytes(_a);
318         uint160 iaddr = 0;
319         uint160 b1;
320         uint160 b2;
321         for (uint i=2; i<2+2*20; i+=2){
322             iaddr *= 256;
323             b1 = uint160(tmp[i]);
324             b2 = uint160(tmp[i+1]);
325             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
326             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
327             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
328             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
329             iaddr += (b1*16+b2);
330         }
331         return address(iaddr);
332     }
333 
334     function strCompare(string _a, string _b) internal returns (int) {
335         bytes memory a = bytes(_a);
336         bytes memory b = bytes(_b);
337         uint minLength = a.length;
338         if (b.length < minLength) minLength = b.length;
339         for (uint i = 0; i < minLength; i ++)
340             if (a[i] < b[i])
341                 return -1;
342             else if (a[i] > b[i])
343                 return 1;
344         if (a.length < b.length)
345             return -1;
346         else if (a.length > b.length)
347             return 1;
348         else
349             return 0;
350     }
351 
352     function indexOf(string _haystack, string _needle) internal returns (int) {
353         bytes memory h = bytes(_haystack);
354         bytes memory n = bytes(_needle);
355         if(h.length < 1 || n.length < 1 || (n.length > h.length))
356             return -1;
357         else if(h.length > (2**128 -1))
358             return -1;
359         else
360         {
361             uint subindex = 0;
362             for (uint i = 0; i < h.length; i ++)
363             {
364                 if (h[i] == n[0])
365                 {
366                     subindex = 1;
367                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
368                     {
369                         subindex++;
370                     }
371                     if(subindex == n.length)
372                         return int(i);
373                 }
374             }
375             return -1;
376         }
377     }
378 
379     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
380         bytes memory _ba = bytes(_a);
381         bytes memory _bb = bytes(_b);
382         bytes memory _bc = bytes(_c);
383         bytes memory _bd = bytes(_d);
384         bytes memory _be = bytes(_e);
385         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
386         bytes memory babcde = bytes(abcde);
387         uint k = 0;
388         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
389         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
390         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
391         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
392         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
393         return string(babcde);
394     }
395 
396     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
397         return strConcat(_a, _b, _c, _d, "");
398     }
399 
400     function strConcat(string _a, string _b, string _c) internal returns (string) {
401         return strConcat(_a, _b, _c, "", "");
402     }
403 
404     function strConcat(string _a, string _b) internal returns (string) {
405         return strConcat(_a, _b, "", "", "");
406     }
407 
408     // parseInt
409     function parseInt(string _a) internal returns (uint) {
410         return parseInt(_a, 0);
411     }
412 
413     // parseInt(parseFloat*10^_b)
414     function parseInt(string _a, uint _b) internal returns (uint) {
415         bytes memory bresult = bytes(_a);
416         uint mint = 0;
417         bool decimals = false;
418         for (uint i=0; i<bresult.length; i++){
419             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
420                 if (decimals){
421                    if (_b == 0) break;
422                     else _b--;
423                 }
424                 mint *= 10;
425                 mint += uint(bresult[i]) - 48;
426             } else if (bresult[i] == 46) decimals = true;
427         }
428         if (_b > 0) mint *= 10**_b;
429         return mint;
430     }
431 
432     function uint2str(uint i) internal returns (string){
433         if (i == 0) return "0";
434         uint j = i;
435         uint len;
436         while (j != 0){
437             len++;
438             j /= 10;
439         }
440         bytes memory bstr = new bytes(len);
441         uint k = len - 1;
442         while (i != 0){
443             bstr[k--] = byte(48 + i % 10);
444             i /= 10;
445         }
446         return string(bstr);
447     }
448 
449     function stra2cbor(string[] arr) internal returns (bytes) {
450             uint arrlen = arr.length;
451 
452             // get correct cbor output length
453             uint outputlen = 0;
454             bytes[] memory elemArray = new bytes[](arrlen);
455             for (uint i = 0; i < arrlen; i++) {
456                 elemArray[i] = (bytes(arr[i]));
457                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
458             }
459             uint ctr = 0;
460             uint cborlen = arrlen + 0x80;
461             outputlen += byte(cborlen).length;
462             bytes memory res = new bytes(outputlen);
463 
464             while (byte(cborlen).length > ctr) {
465                 res[ctr] = byte(cborlen)[ctr];
466                 ctr++;
467             }
468             for (i = 0; i < arrlen; i++) {
469                 res[ctr] = 0x5F;
470                 ctr++;
471                 for (uint x = 0; x < elemArray[i].length; x++) {
472                     // if there's a bug with larger strings, this may be the culprit
473                     if (x % 23 == 0) {
474                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
475                         elemcborlen += 0x40;
476                         uint lctr = ctr;
477                         while (byte(elemcborlen).length > ctr - lctr) {
478                             res[ctr] = byte(elemcborlen)[ctr - lctr];
479                             ctr++;
480                         }
481                     }
482                     res[ctr] = elemArray[i][x];
483                     ctr++;
484                 }
485                 res[ctr] = 0xFF;
486                 ctr++;
487             }
488             return res;
489         }
490 }
491 // </ORACLIZE_API>
492 
493 contract Gamble is usingOraclize {
494     uint Cashpot;
495     uint Service_Fee;
496     uint Gross;
497     uint Ticket;
498     address Owner;
499     string Power_Ball;
500     bool Power_Ball_Set;
501     event Prize(string text,uint amount,string ticket);
502     event Notify_Number(string text,uint amount);
503     event Notify_String(string text,string ticket);
504     event Loser(string text,string ticket);
505     event Balance(string text,uint balance,address user);
506     event newOraclizeQuery(string text);
507     event Tickets_Sold(string text,uint sold);
508     mapping(address => string) Tickets;
509     mapping(uint => address) Ticket_Number;
510     function Gamble()
511         {
512             Prize("Prize ",Cashpot,Power_Ball);
513             Power_Ball_Set = false;
514         }
515      function __callback(bytes32 myid, string result) {
516         if (msg.sender != oraclize_cbAddress()) throw;
517         if(!Power_Ball_Set)
518             {	
519 				Power_Ball = result;
520 				Power_Ball_Set = true;
521 				Prize("Winning numbers set",Cashpot,result);
522             }
523         else
524             {
525 				Tickets[Ticket_Number[Ticket]] = result;
526 				Notify_String("Ticket",Tickets[Ticket_Number[Ticket]]);
527 				bytes32 hash =  sha3(Power_Ball);
528 				bytes32 ticket_hash = sha3(Tickets[Ticket_Number[Ticket]]);
529 				if(hash != ticket_hash)
530 					{
531 						Loser("Lost",Tickets[Ticket_Number[Ticket]]);
532 						if(ticket_hash == sha3("1\n1\n1\n")){small_payout(1);}
533 						if(ticket_hash == sha3("2\n2\n2\n")){small_payout(2);}
534 						if(ticket_hash == sha3("3\n3\n4\n")){small_payout(3);}
535 						if(ticket_hash == sha3("4\n4\n4\n")){small_payout(3);}
536 						if(ticket_hash == sha3("5\n5\n5\n")){small_payout(4);}
537 						if(ticket_hash == sha3("6\n6\n6\n")){small_payout(4);}
538 						if(ticket_hash == sha3("7\n7\n7\n")){small_payout(5);}
539 						if(ticket_hash == sha3("8\n8\n8\n")){small_payout(4);}
540 						if(ticket_hash == sha3("9\n9\n9\n")){small_payout(3);}
541 					}
542 				else
543 					{
544 						Service_Fee = Cashpot / 20;
545 						Gross = (Cashpot - Service_Fee) * 9/10;
546 						if(!Owner.send(Service_Fee))
547 						{
548 						    Notify_Number("Problem sending service fee:",Service_Fee);
549 						    throw;
550 						}
551 						Balance("Your Old Balance Is:",Ticket_Number[Ticket].balance,Ticket_Number[Ticket]);
552 						Cashpot = Cashpot - Service_Fee;
553 						if(!Ticket_Number[Ticket].send(Gross))
554 						{
555 						    Notify_Number("Problem sending ether pot:",Gross);
556 						    throw;
557 						}
558 						Balance("Your New Balance Is:",Ticket_Number[Ticket].balance,Ticket_Number[Ticket]);
559 						Notify_Number("Winner:",Gross);  
560 						Cashpot = Cashpot - Gross;   
561 						Power_Ball_Set = false;
562 						Service_Fee = 0;
563 						Gross = 0;
564                         newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
565 			            oraclize_query("URL", "https://www.random.org/integers/?num=3&min=1&max=9&col=1&base=10&format=plain&rnd=new");					}    
566             }
567     }    
568 	function draw() payable
569 		{
570 		     if(msg.value * 50 < 1 ether){throw;}
571 		     if(Owner == 0 ){Owner = msg.sender;}
572 			 Cashpot += msg.value;
573 			 Ticket += 1;
574 			 Ticket_Number[Ticket] = msg.sender;
575              newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
576 			 oraclize_query("URL", "https://www.random.org/integers/?num=3&min=1&max=9&col=1&base=10&format=plain&rnd=new");
577 			 Tickets_Sold("Tickets Sold:",Ticket);
578 		}
579 	function small_payout (uint bonus)
580 		{
581 		    if (msg.sender != oraclize_cbAddress()) throw;
582 		    Notify_String("Bonus Payout",Tickets[Ticket_Number[Ticket]]);
583 			Service_Fee = Cashpot / 20;
584 			Gross = (Cashpot - Service_Fee) * bonus/10;
585 			if(!Owner.send(Service_Fee))
586 			{
587 			    Notify_Number("Problem sending service fee:",Service_Fee);
588 			    throw;
589 			}
590 			Balance("Your Old Balance Is:",Ticket_Number[Ticket].balance,Ticket_Number[Ticket]);
591 			Cashpot = Cashpot - Service_Fee;
592 			if(!Ticket_Number[Ticket].send(Gross))
593 			{
594 			    Notify_Number("Problem sending ether pot:",Gross);
595 			    throw;
596 			}
597 			Balance("Your New Balance Is:",Ticket_Number[Ticket].balance,Ticket_Number[Ticket]);
598 			Notify_Number("Winner:",Gross);  
599 			Cashpot = Cashpot - Gross;   
600 			Service_Fee = 0;
601 			Gross = 0;
602 		}
603 	function check_prize() returns (uint)
604 	   {
605 	       return this.balance;
606 	   } 
607 	function winning_ticket() returns (string)
608 		{
609 			return Power_Ball;
610 		}
611 }