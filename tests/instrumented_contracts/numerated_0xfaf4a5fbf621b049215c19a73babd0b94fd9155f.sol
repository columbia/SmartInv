1 pragma solidity ^0.4.2;
2 
3 // <ORACLIZE_API>
4 /*
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 
8 
9 
10 Permission is hereby granted, free of charge, to any person obtaining a copy
11 of this software and associated documentation files (the "Software"), to deal
12 in the Software without restriction, including without limitation the rights
13 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14 copies of the Software, and to permit persons to whom the Software is
15 furnished to do so, subject to the following conditions:
16 
17 
18 
19 The above copyright notice and this permission notice shall be included in
20 all copies or substantial portions of the Software.
21 
22 
23 
24 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
25 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
26 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
27 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
28 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
29 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
30 THE SOFTWARE.
31 */
32 
33 contract OraclizeI {
34     address public cbAddress;
35     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
36     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
37     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
38     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
39     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
40     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
41     function getPrice(string _datasource) returns (uint _dsprice);
42     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
43     function useCoupon(string _coupon);
44     function setProofType(byte _proofType);
45     function setConfig(bytes32 _config);
46     function setCustomGasPrice(uint _gasPrice);
47 }
48 contract OraclizeAddrResolverI {
49     function getAddress() returns (address _addr);
50 }
51 contract usingOraclize {
52     uint constant day = 60*60*24;
53     uint constant week = 60*60*24*7;
54     uint constant month = 60*60*24*30;
55     byte constant proofType_NONE = 0x00;
56     byte constant proofType_TLSNotary = 0x10;
57     byte constant proofStorage_IPFS = 0x01;
58     uint8 constant networkID_auto = 0;
59     uint8 constant networkID_mainnet = 1;
60     uint8 constant networkID_testnet = 2;
61     uint8 constant networkID_morden = 2;
62     uint8 constant networkID_consensys = 161;
63 
64     OraclizeAddrResolverI OAR;
65 
66     OraclizeI oraclize;
67     modifier oraclizeAPI {
68         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
69         oraclize = OraclizeI(OAR.getAddress());
70         _;
71     }
72     modifier coupon(string code){
73         oraclize = OraclizeI(OAR.getAddress());
74         oraclize.useCoupon(code);
75         _;
76     }
77 
78     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
79         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
80             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
81             return true;
82         }
83         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
84             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
85             return true;
86         }
87         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
88             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
89             return true;
90         }
91         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
92             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
93             return true;
94         }
95         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
96             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
97             return true;
98         }
99         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
100             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
101             return true;
102         }
103         return false;
104     }
105 
106     function __callback(bytes32 myid, string result) {
107         __callback(myid, result, new bytes(0));
108     }
109     function __callback(bytes32 myid, string result, bytes proof) {
110     }
111 
112     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
113         return oraclize.getPrice(datasource);
114     }
115 
116     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
117         return oraclize.getPrice(datasource, gaslimit);
118     }
119     
120     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
121         uint price = oraclize.getPrice(datasource);
122         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
123         return oraclize.query.value(price)(0, datasource, arg);
124     }
125     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
126         uint price = oraclize.getPrice(datasource);
127         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
128         return oraclize.query.value(price)(timestamp, datasource, arg);
129     }
130     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
131         uint price = oraclize.getPrice(datasource, gaslimit);
132         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
133         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
134     }
135     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
136         uint price = oraclize.getPrice(datasource, gaslimit);
137         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
138         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
139     }
140     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
141         uint price = oraclize.getPrice(datasource);
142         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
143         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
144     }
145     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
146         uint price = oraclize.getPrice(datasource);
147         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
148         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
149     }
150     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
151         uint price = oraclize.getPrice(datasource, gaslimit);
152         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
153         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
154     }
155     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
156         uint price = oraclize.getPrice(datasource, gaslimit);
157         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
158         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
159     }
160     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
161         uint price = oraclize.getPrice(datasource);
162         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
163         bytes memory args = stra2cbor(argN);
164         return oraclize.queryN.value(price)(0, datasource, args);
165     }
166     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
167         uint price = oraclize.getPrice(datasource);
168         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
169         bytes memory args = stra2cbor(argN);
170         return oraclize.queryN.value(price)(timestamp, datasource, args);
171     }
172     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
173         uint price = oraclize.getPrice(datasource, gaslimit);
174         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
175         bytes memory args = stra2cbor(argN);
176         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
177     }
178     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
179         uint price = oraclize.getPrice(datasource, gaslimit);
180         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
181         bytes memory args = stra2cbor(argN);
182         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
183     }
184     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
185         string[] memory dynargs = new string[](1);
186         dynargs[0] = args[0];
187         return oraclize_query(datasource, dynargs);
188     }
189     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
190         string[] memory dynargs = new string[](1);
191         dynargs[0] = args[0];
192         return oraclize_query(timestamp, datasource, dynargs);
193     }
194     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
195         string[] memory dynargs = new string[](1);
196         dynargs[0] = args[0];
197         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
198     }
199     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
200         string[] memory dynargs = new string[](1);
201         dynargs[0] = args[0];       
202         return oraclize_query(datasource, dynargs, gaslimit);
203     }
204     
205     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
206         string[] memory dynargs = new string[](2);
207         dynargs[0] = args[0];
208         dynargs[1] = args[1];
209         return oraclize_query(datasource, dynargs);
210     }
211     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
212         string[] memory dynargs = new string[](2);
213         dynargs[0] = args[0];
214         dynargs[1] = args[1];
215         return oraclize_query(timestamp, datasource, dynargs);
216     }
217     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
218         string[] memory dynargs = new string[](2);
219         dynargs[0] = args[0];
220         dynargs[1] = args[1];
221         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
222     }
223     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
224         string[] memory dynargs = new string[](2);
225         dynargs[0] = args[0];
226         dynargs[1] = args[1];
227         return oraclize_query(datasource, dynargs, gaslimit);
228     }
229     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
230         string[] memory dynargs = new string[](3);
231         dynargs[0] = args[0];
232         dynargs[1] = args[1];
233         dynargs[2] = args[2];
234         return oraclize_query(datasource, dynargs);
235     }
236     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
237         string[] memory dynargs = new string[](3);
238         dynargs[0] = args[0];
239         dynargs[1] = args[1];
240         dynargs[2] = args[2];
241         return oraclize_query(timestamp, datasource, dynargs);
242     }
243     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
244         string[] memory dynargs = new string[](3);
245         dynargs[0] = args[0];
246         dynargs[1] = args[1];
247         dynargs[2] = args[2];
248         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
249     }
250     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
251         string[] memory dynargs = new string[](3);
252         dynargs[0] = args[0];
253         dynargs[1] = args[1];
254         dynargs[2] = args[2];
255         return oraclize_query(datasource, dynargs, gaslimit);
256     }
257     
258     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
259         string[] memory dynargs = new string[](4);
260         dynargs[0] = args[0];
261         dynargs[1] = args[1];
262         dynargs[2] = args[2];
263         dynargs[3] = args[3];
264         return oraclize_query(datasource, dynargs);
265     }
266     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
267         string[] memory dynargs = new string[](4);
268         dynargs[0] = args[0];
269         dynargs[1] = args[1];
270         dynargs[2] = args[2];
271         dynargs[3] = args[3];
272         return oraclize_query(timestamp, datasource, dynargs);
273     }
274     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
275         string[] memory dynargs = new string[](4);
276         dynargs[0] = args[0];
277         dynargs[1] = args[1];
278         dynargs[2] = args[2];
279         dynargs[3] = args[3];
280         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
281     }
282     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
283         string[] memory dynargs = new string[](4);
284         dynargs[0] = args[0];
285         dynargs[1] = args[1];
286         dynargs[2] = args[2];
287         dynargs[3] = args[3];
288         return oraclize_query(datasource, dynargs, gaslimit);
289     }
290     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
291         string[] memory dynargs = new string[](5);
292         dynargs[0] = args[0];
293         dynargs[1] = args[1];
294         dynargs[2] = args[2];
295         dynargs[3] = args[3];
296         dynargs[4] = args[4];
297         return oraclize_query(datasource, dynargs);
298     }
299     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
300         string[] memory dynargs = new string[](5);
301         dynargs[0] = args[0];
302         dynargs[1] = args[1];
303         dynargs[2] = args[2];
304         dynargs[3] = args[3];
305         dynargs[4] = args[4];
306         return oraclize_query(timestamp, datasource, dynargs);
307     }
308     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
309         string[] memory dynargs = new string[](5);
310         dynargs[0] = args[0];
311         dynargs[1] = args[1];
312         dynargs[2] = args[2];
313         dynargs[3] = args[3];
314         dynargs[4] = args[4];
315         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
316     }
317     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
318         string[] memory dynargs = new string[](5);
319         dynargs[0] = args[0];
320         dynargs[1] = args[1];
321         dynargs[2] = args[2];
322         dynargs[3] = args[3];
323         dynargs[4] = args[4];
324         return oraclize_query(datasource, dynargs, gaslimit);
325     }
326 
327     function oraclize_cbAddress() oraclizeAPI internal returns (address){
328         return oraclize.cbAddress();
329     }
330     function oraclize_setProof(byte proofP) oraclizeAPI internal {
331         return oraclize.setProofType(proofP);
332     }
333     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
334         return oraclize.setCustomGasPrice(gasPrice);
335     }
336     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
337         return oraclize.setConfig(config);
338     }
339 
340     function getCodeSize(address _addr) constant internal returns(uint _size) {
341         assembly {
342             _size := extcodesize(_addr)
343         }
344     }
345 
346     function parseAddr(string _a) internal returns (address){
347         bytes memory tmp = bytes(_a);
348         uint160 iaddr = 0;
349         uint160 b1;
350         uint160 b2;
351         for (uint i=2; i<2+2*20; i+=2){
352             iaddr *= 256;
353             b1 = uint160(tmp[i]);
354             b2 = uint160(tmp[i+1]);
355             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
356             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
357             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
358             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
359             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
360             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
361             iaddr += (b1*16+b2);
362         }
363         return address(iaddr);
364     }
365 
366     function strCompare(string _a, string _b) internal returns (int) {
367         bytes memory a = bytes(_a);
368         bytes memory b = bytes(_b);
369         uint minLength = a.length;
370         if (b.length < minLength) minLength = b.length;
371         for (uint i = 0; i < minLength; i ++)
372             if (a[i] < b[i])
373                 return -1;
374             else if (a[i] > b[i])
375                 return 1;
376         if (a.length < b.length)
377             return -1;
378         else if (a.length > b.length)
379             return 1;
380         else
381             return 0;
382     }
383 
384     function indexOf(string _haystack, string _needle) internal returns (int) {
385         bytes memory h = bytes(_haystack);
386         bytes memory n = bytes(_needle);
387         if(h.length < 1 || n.length < 1 || (n.length > h.length))
388             return -1;
389         else if(h.length > (2**128 -1))
390             return -1;
391         else
392         {
393             uint subindex = 0;
394             for (uint i = 0; i < h.length; i ++)
395             {
396                 if (h[i] == n[0])
397                 {
398                     subindex = 1;
399                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
400                     {
401                         subindex++;
402                     }
403                     if(subindex == n.length)
404                         return int(i);
405                 }
406             }
407             return -1;
408         }
409     }
410 
411     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
412         bytes memory _ba = bytes(_a);
413         bytes memory _bb = bytes(_b);
414         bytes memory _bc = bytes(_c);
415         bytes memory _bd = bytes(_d);
416         bytes memory _be = bytes(_e);
417         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
418         bytes memory babcde = bytes(abcde);
419         uint k = 0;
420         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
421         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
422         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
423         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
424         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
425         return string(babcde);
426     }
427 
428     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
429         return strConcat(_a, _b, _c, _d, "");
430     }
431 
432     function strConcat(string _a, string _b, string _c) internal returns (string) {
433         return strConcat(_a, _b, _c, "", "");
434     }
435 
436     function strConcat(string _a, string _b) internal returns (string) {
437         return strConcat(_a, _b, "", "", "");
438     }
439 
440     // parseInt
441     function parseInt(string _a) internal returns (uint) {
442         return parseInt(_a, 0);
443     }
444 
445     // parseInt(parseFloat*10^_b)
446     function parseInt(string _a, uint _b) internal returns (uint) {
447         bytes memory bresult = bytes(_a);
448         uint mint = 0;
449         bool decimals = false;
450         for (uint i=0; i<bresult.length; i++){
451             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
452                 if (decimals){
453                    if (_b == 0) break;
454                     else _b--;
455                 }
456                 mint *= 10;
457                 mint += uint(bresult[i]) - 48;
458             } else if (bresult[i] == 46) decimals = true;
459         }
460         if (_b > 0) mint *= 10**_b;
461         return mint;
462     }
463 
464     function uint2str(uint i) internal returns (string){
465         if (i == 0) return "0";
466         uint j = i;
467         uint len;
468         while (j != 0){
469             len++;
470             j /= 10;
471         }
472         bytes memory bstr = new bytes(len);
473         uint k = len - 1;
474         while (i != 0){
475             bstr[k--] = byte(48 + i % 10);
476             i /= 10;
477         }
478         return string(bstr);
479     }
480 
481     function stra2cbor(string[] arr) internal returns (bytes) {
482             uint arrlen = arr.length;
483 
484             // get correct cbor output length
485             uint outputlen = 0;
486             bytes[] memory elemArray = new bytes[](arrlen);
487             for (uint i = 0; i < arrlen; i++) {
488                 elemArray[i] = (bytes(arr[i]));
489                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
490             }
491             uint ctr = 0;
492             uint cborlen = arrlen + 0x80;
493             outputlen += byte(cborlen).length;
494             bytes memory res = new bytes(outputlen);
495 
496             while (byte(cborlen).length > ctr) {
497                 res[ctr] = byte(cborlen)[ctr];
498                 ctr++;
499             }
500             for (i = 0; i < arrlen; i++) {
501                 res[ctr] = 0x5F;
502                 ctr++;
503                 for (uint x = 0; x < elemArray[i].length; x++) {
504                     // if there's a bug with larger strings, this may be the culprit
505                     if (x % 23 == 0) {
506                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
507                         elemcborlen += 0x40;
508                         uint lctr = ctr;
509                         while (byte(elemcborlen).length > ctr - lctr) {
510                             res[ctr] = byte(elemcborlen)[ctr - lctr];
511                             ctr++;
512                         }
513                     }
514                     res[ctr] = elemArray[i][x];
515                     ctr++;
516                 }
517                 res[ctr] = 0xFF;
518                 ctr++;
519             }
520             return res;
521         }
522 }
523 // </ORACLIZE_API>
524 
525 /*
526  * @title String & slice utility library for Solidity contracts.
527  * @author Nick Johnson <arachnid@notdot.net>
528  *
529  * @dev Functionality in this library is largely implemented using an
530  *      abstraction called a 'slice'. A slice represents a part of a string -
531  *      anything from the entire string to a single character, or even no
532  *      characters at all (a 0-length slice). Since a slice only has to specify
533  *      an offset and a length, copying and manipulating slices is a lot less
534  *      expensive than copying and manipulating the strings they reference.
535  *
536  *      To further reduce gas costs, most functions on slice that need to return
537  *      a slice modify the original one instead of allocating a new one; for
538  *      instance, `s.split(".")` will return the text up to the first '.',
539  *      modifying s to only contain the remainder of the string after the '.'.
540  *      In situations where you do not want to modify the original slice, you
541  *      can make a copy first with `.copy()`, for example:
542  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
543  *      Solidity has no memory management, it will result in allocating many
544  *      short-lived slices that are later discarded.
545  *
546  *      Functions that return two slices come in two versions: a non-allocating
547  *      version that takes the second slice as an argument, modifying it in
548  *      place, and an allocating version that allocates and returns the second
549  *      slice; see `nextRune` for example.
550  *
551  *      Functions that have to copy string data will return strings rather than
552  *      slices; these can be cast back to slices for further processing if
553  *      required.
554  *
555  *      For convenience, some functions are provided with non-modifying
556  *      variants that create a new slice and return both; for instance,
557  *      `s.splitNew('.')` leaves s unmodified, and returns two values
558  *      corresponding to the left and right parts of the string.
559  */
560 library strings {
561     struct slice {
562         uint _len;
563         uint _ptr;
564     }
565 
566     function memcpy(uint dest, uint src, uint len) private {
567         // Copy word-length chunks while possible
568         for(; len >= 32; len -= 32) {
569             assembly {
570                 mstore(dest, mload(src))
571             }
572             dest += 32;
573             src += 32;
574         }
575 
576         // Copy remaining bytes
577         uint mask = 256 ** (32 - len) - 1;
578         assembly {
579             let srcpart := and(mload(src), not(mask))
580             let destpart := and(mload(dest), mask)
581             mstore(dest, or(destpart, srcpart))
582         }
583     }
584 
585     /*
586      * @dev Returns a slice containing the entire string.
587      * @param self The string to make a slice from.
588      * @return A newly allocated slice containing the entire string.
589      */
590     function toSlice(string self) internal returns (slice) {
591         uint ptr;
592         assembly {
593             ptr := add(self, 0x20)
594         }
595         return slice(bytes(self).length, ptr);
596     }
597 
598     /*
599      * @dev Returns the length of a null-terminated bytes32 string.
600      * @param self The value to find the length of.
601      * @return The length of the string, from 0 to 32.
602      */
603     function len(bytes32 self) internal returns (uint) {
604         uint ret;
605         if (self == 0)
606             return 0;
607         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
608             ret += 16;
609             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
610         }
611         if (self & 0xffffffffffffffff == 0) {
612             ret += 8;
613             self = bytes32(uint(self) / 0x10000000000000000);
614         }
615         if (self & 0xffffffff == 0) {
616             ret += 4;
617             self = bytes32(uint(self) / 0x100000000);
618         }
619         if (self & 0xffff == 0) {
620             ret += 2;
621             self = bytes32(uint(self) / 0x10000);
622         }
623         if (self & 0xff == 0) {
624             ret += 1;
625         }
626         return 32 - ret;
627     }
628 
629     /*
630      * @dev Returns a slice containing the entire bytes32, interpreted as a
631      *      null-termintaed utf-8 string.
632      * @param self The bytes32 value to convert to a slice.
633      * @return A new slice containing the value of the input argument up to the
634      *         first null.
635      */
636     function toSliceB32(bytes32 self) internal returns (slice ret) {
637         // Allocate space for `self` in memory, copy it there, and point ret at it
638         assembly {
639             let ptr := mload(0x40)
640             mstore(0x40, add(ptr, 0x20))
641             mstore(ptr, self)
642             mstore(add(ret, 0x20), ptr)
643         }
644         ret._len = len(self);
645     }
646 
647     /*
648      * @dev Returns a new slice containing the same data as the current slice.
649      * @param self The slice to copy.
650      * @return A new slice containing the same data as `self`.
651      */
652     function copy(slice self) internal returns (slice) {
653         return slice(self._len, self._ptr);
654     }
655 
656     /*
657      * @dev Copies a slice to a new string.
658      * @param self The slice to copy.
659      * @return A newly allocated string containing the slice's text.
660      */
661     function toString(slice self) internal returns (string) {
662         var ret = new string(self._len);
663         uint retptr;
664         assembly { retptr := add(ret, 32) }
665 
666         memcpy(retptr, self._ptr, self._len);
667         return ret;
668     }
669 
670     /*
671      * @dev Returns the length in runes of the slice. Note that this operation
672      *      takes time proportional to the length of the slice; avoid using it
673      *      in loops, and call `slice.empty()` if you only need to know whether
674      *      the slice is empty or not.
675      * @param self The slice to operate on.
676      * @return The length of the slice in runes.
677      */
678     function len(slice self) internal returns (uint) {
679         // Starting at ptr-31 means the LSB will be the byte we care about
680         var ptr = self._ptr - 31;
681         var end = ptr + self._len;
682         for (uint len = 0; ptr < end; len++) {
683             uint8 b;
684             assembly { b := and(mload(ptr), 0xFF) }
685             if (b < 0x80) {
686                 ptr += 1;
687             } else if(b < 0xE0) {
688                 ptr += 2;
689             } else if(b < 0xF0) {
690                 ptr += 3;
691             } else if(b < 0xF8) {
692                 ptr += 4;
693             } else if(b < 0xFC) {
694                 ptr += 5;
695             } else {
696                 ptr += 6;
697             }
698         }
699         return len;
700     }
701 
702     /*
703      * @dev Returns true if the slice is empty (has a length of 0).
704      * @param self The slice to operate on.
705      * @return True if the slice is empty, False otherwise.
706      */
707     function empty(slice self) internal returns (bool) {
708         return self._len == 0;
709     }
710 
711     /*
712      * @dev Returns a positive number if `other` comes lexicographically after
713      *      `self`, a negative number if it comes before, or zero if the
714      *      contents of the two slices are equal. Comparison is done per-rune,
715      *      on unicode codepoints.
716      * @param self The first slice to compare.
717      * @param other The second slice to compare.
718      * @return The result of the comparison.
719      */
720     function compare(slice self, slice other) internal returns (int) {
721         uint shortest = self._len;
722         if (other._len < self._len)
723             shortest = other._len;
724 
725         var selfptr = self._ptr;
726         var otherptr = other._ptr;
727         for (uint idx = 0; idx < shortest; idx += 32) {
728             uint a;
729             uint b;
730             assembly {
731                 a := mload(selfptr)
732                 b := mload(otherptr)
733             }
734             if (a != b) {
735                 // Mask out irrelevant bytes and check again
736                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
737                 var diff = (a & mask) - (b & mask);
738                 if (diff != 0)
739                     return int(diff);
740             }
741             selfptr += 32;
742             otherptr += 32;
743         }
744         return int(self._len) - int(other._len);
745     }
746 
747     /*
748      * @dev Returns true if the two slices contain the same text.
749      * @param self The first slice to compare.
750      * @param self The second slice to compare.
751      * @return True if the slices are equal, false otherwise.
752      */
753     function equals(slice self, slice other) internal returns (bool) {
754         return compare(self, other) == 0;
755     }
756 
757     /*
758      * @dev Extracts the first rune in the slice into `rune`, advancing the
759      *      slice to point to the next rune and returning `self`.
760      * @param self The slice to operate on.
761      * @param rune The slice that will contain the first rune.
762      * @return `rune`.
763      */
764     function nextRune(slice self, slice rune) internal returns (slice) {
765         rune._ptr = self._ptr;
766 
767         if (self._len == 0) {
768             rune._len = 0;
769             return rune;
770         }
771 
772         uint len;
773         uint b;
774         // Load the first byte of the rune into the LSBs of b
775         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
776         if (b < 0x80) {
777             len = 1;
778         } else if(b < 0xE0) {
779             len = 2;
780         } else if(b < 0xF0) {
781             len = 3;
782         } else {
783             len = 4;
784         }
785 
786         // Check for truncated codepoints
787         if (len > self._len) {
788             rune._len = self._len;
789             self._ptr += self._len;
790             self._len = 0;
791             return rune;
792         }
793 
794         self._ptr += len;
795         self._len -= len;
796         rune._len = len;
797         return rune;
798     }
799 
800     /*
801      * @dev Returns the first rune in the slice, advancing the slice to point
802      *      to the next rune.
803      * @param self The slice to operate on.
804      * @return A slice containing only the first rune from `self`.
805      */
806     function nextRune(slice self) internal returns (slice ret) {
807         nextRune(self, ret);
808     }
809 
810     /*
811      * @dev Returns the number of the first codepoint in the slice.
812      * @param self The slice to operate on.
813      * @return The number of the first codepoint in the slice.
814      */
815     function ord(slice self) internal returns (uint ret) {
816         if (self._len == 0) {
817             return 0;
818         }
819 
820         uint word;
821         uint len;
822         uint div = 2 ** 248;
823 
824         // Load the rune into the MSBs of b
825         assembly { word:= mload(mload(add(self, 32))) }
826         var b = word / div;
827         if (b < 0x80) {
828             ret = b;
829             len = 1;
830         } else if(b < 0xE0) {
831             ret = b & 0x1F;
832             len = 2;
833         } else if(b < 0xF0) {
834             ret = b & 0x0F;
835             len = 3;
836         } else {
837             ret = b & 0x07;
838             len = 4;
839         }
840 
841         // Check for truncated codepoints
842         if (len > self._len) {
843             return 0;
844         }
845 
846         for (uint i = 1; i < len; i++) {
847             div = div / 256;
848             b = (word / div) & 0xFF;
849             if (b & 0xC0 != 0x80) {
850                 // Invalid UTF-8 sequence
851                 return 0;
852             }
853             ret = (ret * 64) | (b & 0x3F);
854         }
855 
856         return ret;
857     }
858 
859     /*
860      * @dev Returns the keccak-256 hash of the slice.
861      * @param self The slice to hash.
862      * @return The hash of the slice.
863      */
864     function keccak(slice self) internal returns (bytes32 ret) {
865         assembly {
866             ret := sha3(mload(add(self, 32)), mload(self))
867         }
868     }
869 
870     /*
871      * @dev Returns true if `self` starts with `needle`.
872      * @param self The slice to operate on.
873      * @param needle The slice to search for.
874      * @return True if the slice starts with the provided text, false otherwise.
875      */
876     function startsWith(slice self, slice needle) internal returns (bool) {
877         if (self._len < needle._len) {
878             return false;
879         }
880 
881         if (self._ptr == needle._ptr) {
882             return true;
883         }
884 
885         bool equal;
886         assembly {
887             let len := mload(needle)
888             let selfptr := mload(add(self, 0x20))
889             let needleptr := mload(add(needle, 0x20))
890             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
891         }
892         return equal;
893     }
894 
895     /*
896      * @dev If `self` starts with `needle`, `needle` is removed from the
897      *      beginning of `self`. Otherwise, `self` is unmodified.
898      * @param self The slice to operate on.
899      * @param needle The slice to search for.
900      * @return `self`
901      */
902     function beyond(slice self, slice needle) internal returns (slice) {
903         if (self._len < needle._len) {
904             return self;
905         }
906 
907         bool equal = true;
908         if (self._ptr != needle._ptr) {
909             assembly {
910                 let len := mload(needle)
911                 let selfptr := mload(add(self, 0x20))
912                 let needleptr := mload(add(needle, 0x20))
913                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
914             }
915         }
916 
917         if (equal) {
918             self._len -= needle._len;
919             self._ptr += needle._len;
920         }
921 
922         return self;
923     }
924 
925     /*
926      * @dev Returns true if the slice ends with `needle`.
927      * @param self The slice to operate on.
928      * @param needle The slice to search for.
929      * @return True if the slice starts with the provided text, false otherwise.
930      */
931     function endsWith(slice self, slice needle) internal returns (bool) {
932         if (self._len < needle._len) {
933             return false;
934         }
935 
936         var selfptr = self._ptr + self._len - needle._len;
937 
938         if (selfptr == needle._ptr) {
939             return true;
940         }
941 
942         bool equal;
943         assembly {
944             let len := mload(needle)
945             let needleptr := mload(add(needle, 0x20))
946             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
947         }
948 
949         return equal;
950     }
951 
952     /*
953      * @dev If `self` ends with `needle`, `needle` is removed from the
954      *      end of `self`. Otherwise, `self` is unmodified.
955      * @param self The slice to operate on.
956      * @param needle The slice to search for.
957      * @return `self`
958      */
959     function until(slice self, slice needle) internal returns (slice) {
960         if (self._len < needle._len) {
961             return self;
962         }
963 
964         var selfptr = self._ptr + self._len - needle._len;
965         bool equal = true;
966         if (selfptr != needle._ptr) {
967             assembly {
968                 let len := mload(needle)
969                 let needleptr := mload(add(needle, 0x20))
970                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
971             }
972         }
973 
974         if (equal) {
975             self._len -= needle._len;
976         }
977 
978         return self;
979     }
980 
981     // Returns the memory address of the first byte of the first occurrence of
982     // `needle` in `self`, or the first byte after `self` if not found.
983     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
984         uint ptr;
985         uint idx;
986 
987         if (needlelen <= selflen) {
988             if (needlelen <= 32) {
989                 // Optimized assembly for 68 gas per byte on short strings
990                 assembly {
991                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
992                     let needledata := and(mload(needleptr), mask)
993                     let end := add(selfptr, sub(selflen, needlelen))
994                     ptr := selfptr
995                     loop:
996                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
997                     ptr := add(ptr, 1)
998                     jumpi(loop, lt(sub(ptr, 1), end))
999                     ptr := add(selfptr, selflen)
1000                     exit:
1001                 }
1002                 return ptr;
1003             } else {
1004                 // For long needles, use hashing
1005                 bytes32 hash;
1006                 assembly { hash := sha3(needleptr, needlelen) }
1007                 ptr = selfptr;
1008                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1009                     bytes32 testHash;
1010                     assembly { testHash := sha3(ptr, needlelen) }
1011                     if (hash == testHash)
1012                         return ptr;
1013                     ptr += 1;
1014                 }
1015             }
1016         }
1017         return selfptr + selflen;
1018     }
1019 
1020     // Returns the memory address of the first byte after the last occurrence of
1021     // `needle` in `self`, or the address of `self` if not found.
1022     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1023         uint ptr;
1024 
1025         if (needlelen <= selflen) {
1026             if (needlelen <= 32) {
1027                 // Optimized assembly for 69 gas per byte on short strings
1028                 assembly {
1029                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1030                     let needledata := and(mload(needleptr), mask)
1031                     ptr := add(selfptr, sub(selflen, needlelen))
1032                     loop:
1033                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1034                     ptr := sub(ptr, 1)
1035                     jumpi(loop, gt(add(ptr, 1), selfptr))
1036                     ptr := selfptr
1037                     jump(exit)
1038                     ret:
1039                     ptr := add(ptr, needlelen)
1040                     exit:
1041                 }
1042                 return ptr;
1043             } else {
1044                 // For long needles, use hashing
1045                 bytes32 hash;
1046                 assembly { hash := sha3(needleptr, needlelen) }
1047                 ptr = selfptr + (selflen - needlelen);
1048                 while (ptr >= selfptr) {
1049                     bytes32 testHash;
1050                     assembly { testHash := sha3(ptr, needlelen) }
1051                     if (hash == testHash)
1052                         return ptr + needlelen;
1053                     ptr -= 1;
1054                 }
1055             }
1056         }
1057         return selfptr;
1058     }
1059 
1060     /*
1061      * @dev Modifies `self` to contain everything from the first occurrence of
1062      *      `needle` to the end of the slice. `self` is set to the empty slice
1063      *      if `needle` is not found.
1064      * @param self The slice to search and modify.
1065      * @param needle The text to search for.
1066      * @return `self`.
1067      */
1068     function find(slice self, slice needle) internal returns (slice) {
1069         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1070         self._len -= ptr - self._ptr;
1071         self._ptr = ptr;
1072         return self;
1073     }
1074 
1075     /*
1076      * @dev Modifies `self` to contain the part of the string from the start of
1077      *      `self` to the end of the first occurrence of `needle`. If `needle`
1078      *      is not found, `self` is set to the empty slice.
1079      * @param self The slice to search and modify.
1080      * @param needle The text to search for.
1081      * @return `self`.
1082      */
1083     function rfind(slice self, slice needle) internal returns (slice) {
1084         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1085         self._len = ptr - self._ptr;
1086         return self;
1087     }
1088 
1089     /*
1090      * @dev Splits the slice, setting `self` to everything after the first
1091      *      occurrence of `needle`, and `token` to everything before it. If
1092      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1093      *      and `token` is set to the entirety of `self`.
1094      * @param self The slice to split.
1095      * @param needle The text to search for in `self`.
1096      * @param token An output parameter to which the first token is written.
1097      * @return `token`.
1098      */
1099     function split(slice self, slice needle, slice token) internal returns (slice) {
1100         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1101         token._ptr = self._ptr;
1102         token._len = ptr - self._ptr;
1103         if (ptr == self._ptr + self._len) {
1104             // Not found
1105             self._len = 0;
1106         } else {
1107             self._len -= token._len + needle._len;
1108             self._ptr = ptr + needle._len;
1109         }
1110         return token;
1111     }
1112 
1113     /*
1114      * @dev Splits the slice, setting `self` to everything after the first
1115      *      occurrence of `needle`, and returning everything before it. If
1116      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1117      *      and the entirety of `self` is returned.
1118      * @param self The slice to split.
1119      * @param needle The text to search for in `self`.
1120      * @return The part of `self` up to the first occurrence of `delim`.
1121      */
1122     function split(slice self, slice needle) internal returns (slice token) {
1123         split(self, needle, token);
1124     }
1125 
1126     /*
1127      * @dev Splits the slice, setting `self` to everything before the last
1128      *      occurrence of `needle`, and `token` to everything after it. If
1129      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1130      *      and `token` is set to the entirety of `self`.
1131      * @param self The slice to split.
1132      * @param needle The text to search for in `self`.
1133      * @param token An output parameter to which the first token is written.
1134      * @return `token`.
1135      */
1136     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1137         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1138         token._ptr = ptr;
1139         token._len = self._len - (ptr - self._ptr);
1140         if (ptr == self._ptr) {
1141             // Not found
1142             self._len = 0;
1143         } else {
1144             self._len -= token._len + needle._len;
1145         }
1146         return token;
1147     }
1148 
1149     /*
1150      * @dev Splits the slice, setting `self` to everything before the last
1151      *      occurrence of `needle`, and returning everything after it. If
1152      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1153      *      and the entirety of `self` is returned.
1154      * @param self The slice to split.
1155      * @param needle The text to search for in `self`.
1156      * @return The part of `self` after the last occurrence of `delim`.
1157      */
1158     function rsplit(slice self, slice needle) internal returns (slice token) {
1159         rsplit(self, needle, token);
1160     }
1161 
1162     /*
1163      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1164      * @param self The slice to search.
1165      * @param needle The text to search for in `self`.
1166      * @return The number of occurrences of `needle` found in `self`.
1167      */
1168     function count(slice self, slice needle) internal returns (uint count) {
1169         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1170         while (ptr <= self._ptr + self._len) {
1171             count++;
1172             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1173         }
1174     }
1175 
1176     /*
1177      * @dev Returns True if `self` contains `needle`.
1178      * @param self The slice to search.
1179      * @param needle The text to search for in `self`.
1180      * @return True if `needle` is found in `self`, false otherwise.
1181      */
1182     function contains(slice self, slice needle) internal returns (bool) {
1183         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1184     }
1185 
1186     /*
1187      * @dev Returns a newly allocated string containing the concatenation of
1188      *      `self` and `other`.
1189      * @param self The first slice to concatenate.
1190      * @param other The second slice to concatenate.
1191      * @return The concatenation of the two strings.
1192      */
1193     function concat(slice self, slice other) internal returns (string) {
1194         var ret = new string(self._len + other._len);
1195         uint retptr;
1196         assembly { retptr := add(ret, 32) }
1197         memcpy(retptr, self._ptr, self._len);
1198         memcpy(retptr + self._len, other._ptr, other._len);
1199         return ret;
1200     }
1201 
1202     /*
1203      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1204      *      newly allocated string.
1205      * @param self The delimiter to use.
1206      * @param parts A list of slices to join.
1207      * @return A newly allocated string containing all the slices in `parts`,
1208      *         joined with `self`.
1209      */
1210     function join(slice self, slice[] parts) internal returns (string) {
1211         if (parts.length == 0)
1212             return "";
1213 
1214         uint len = self._len * (parts.length - 1);
1215         for(uint i = 0; i < parts.length; i++)
1216             len += parts[i]._len;
1217 
1218         var ret = new string(len);
1219         uint retptr;
1220         assembly { retptr := add(ret, 32) }
1221 
1222         for(i = 0; i < parts.length; i++) {
1223             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1224             retptr += parts[i]._len;
1225             if (i < parts.length - 1) {
1226                 memcpy(retptr, self._ptr, self._len);
1227                 retptr += self._len;
1228             }
1229         }
1230 
1231         return ret;
1232     }
1233 }
1234 
1235 
1236 contract DSSafeAddSub {
1237     function safeToAdd(uint a, uint b) internal returns (bool) {
1238         return (a + b >= a);
1239     }
1240     function safeAdd(uint a, uint b) internal returns (uint) {
1241         if (!safeToAdd(a, b)) throw;
1242         return a + b;
1243     }
1244 
1245     function safeToSubtract(uint a, uint b) internal returns (bool) {
1246         return (b <= a);
1247     }
1248 
1249     function safeSub(uint a, uint b) internal returns (uint) {
1250         if (!safeToSubtract(a, b)) throw;
1251         return a - b;
1252     } 
1253 }
1254 
1255 
1256 
1257 contract Etheroll is usingOraclize, DSSafeAddSub {
1258     
1259      using strings for *;
1260 
1261     /*
1262      * checks player profit, bet size and player number is within range
1263     */
1264     modifier betIsValid(uint _betSize, uint _playerNumber) {      
1265         if(((((_betSize * (100-(safeSub(_playerNumber,1)))) / (safeSub(_playerNumber,1))+_betSize))*houseEdge/houseEdgeDivisor)-_betSize > maxProfit || _betSize < minBet || _playerNumber < minNumber || _playerNumber > maxNumber) throw;        
1266 		_;
1267     }
1268 
1269     /*
1270      * checks game is currently active
1271     */
1272     modifier gameIsActive {
1273         if(gamePaused == true) throw;
1274 		_;
1275     }    
1276 
1277     /*
1278      * checks payouts are currently active
1279     */
1280     modifier payoutsAreActive {
1281         if(payoutsPaused == true) throw;
1282 		_;
1283     }    
1284 
1285     /*
1286      * checks only Oraclize address is calling
1287     */
1288     modifier onlyOraclize {
1289         if (msg.sender != oraclize_cbAddress()) throw;
1290         _;
1291     }
1292 
1293     /*
1294      * checks only owner address is calling
1295     */
1296     modifier onlyOwner {
1297          if (msg.sender != owner) throw;
1298          _;
1299     }
1300 
1301     /*
1302      * checks only treasury address is calling
1303     */
1304     modifier onlyTreasury {
1305          if (msg.sender != treasury) throw;
1306          _;
1307     }    
1308 
1309     /*
1310      * game vars
1311     */ 
1312     uint constant public maxProfitDivisor = 1000000;
1313     uint constant public houseEdgeDivisor = 1000;    
1314     uint constant public maxNumber = 99; 
1315     uint constant public minNumber = 2;
1316 	bool public gamePaused;
1317     uint32 public gasForOraclize;
1318     address public owner;
1319     bool public payoutsPaused; 
1320     address public treasury;
1321     uint public contractBalance;
1322     uint public houseEdge;     
1323     uint public maxProfit;   
1324     uint public maxProfitAsPercentOfHouse;                    
1325     uint public minBet;       
1326     int public totalBets;
1327     uint public maxPendingPayouts;
1328     uint public costToCallOraclizeInWei;
1329     uint public totalWeiWon;
1330 
1331     /*
1332      * player vars
1333     */
1334     mapping (bytes32 => address) playerAddress;
1335     mapping (bytes32 => address) playerTempAddress;
1336     mapping (bytes32 => bytes32) playerBetId;
1337     mapping (bytes32 => uint) playerBetValue;
1338     mapping (bytes32 => uint) playerTempBetValue;  
1339     mapping (bytes32 => uint) playerRandomResult;     
1340     mapping (bytes32 => uint) playerDieResult;
1341     mapping (bytes32 => uint) playerNumber;
1342     mapping (address => uint) playerPendingWithdrawals;      
1343     mapping (bytes32 => uint) playerProfit;
1344     mapping (bytes32 => uint) playerTempReward;    
1345         
1346 
1347     /*
1348      * events
1349     */
1350     /* log bets + output to web3 for precise 'payout on win' field in UI */
1351     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RewardValue, uint ProfitValue, uint BetValue, uint PlayerNumber);      
1352     /* output to web3 UI on bet result*/
1353     /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
1354 	event LogResult(uint indexed ResultSerialNumber, bytes32 indexed BetID, address indexed PlayerAddress, uint PlayerNumber, uint DiceResult, uint Value, int Status, bytes Proof);   
1355     /* log manual refunds */
1356     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
1357     /* log owner transfers */
1358     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);               
1359 
1360 
1361     /*
1362      * init
1363     */
1364     function Etheroll() {
1365 
1366         owner = msg.sender;
1367         treasury = msg.sender;
1368         
1369         oraclize_setNetwork(networkID_auto);        
1370         /* use TLSNotary for oraclize call */
1371 		oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1372         /* init 990 = 99% (1% houseEdge)*/
1373         ownerSetHouseEdge(990);
1374         /* init 10,000 = 1%  */
1375         ownerSetMaxProfitAsPercentOfHouse(10000);
1376         /* init min bet (0.1 ether) */
1377         ownerSetMinBet(100000000000000000);        
1378         /* init gas for oraclize */        
1379         gasForOraclize = 250000;        
1380 
1381     }
1382 
1383     /*
1384      * public function
1385      * player submit bet
1386      * only if game is active & bet is valid can query oraclize and set player vars     
1387     */
1388     function playerRollDice(uint rollUnder) public 
1389         payable
1390         gameIsActive
1391         betIsValid(msg.value, rollUnder)
1392 	{        
1393         
1394         /*
1395         * assign partially encrypted query to oraclize
1396         * only the apiKey is encrypted 
1397         * integer query is in plain text
1398         */
1399         bytes32 rngId = oraclize_query("nested", "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BGTHWM0eEfofomIQf6Yh0YwRS47jhBH19wfMIQEnth4KbVg+wC8V220JO04JisgluUoDyDdI/sv4mAlRNcTyZg6lP6l+ociWxEsN9R9K3iygXAna2Q6yYqnhYvPoxxg5cqzR8MCkpAJ/AQm0M0VldM77Hzz31Cw=},\"n\":1,\"min\":1,\"max\":100,\"replacement\":true,\"base\":10${[identity] \"}\"},\"id\":1${[identity] \"}\"}']", gasForOraclize);
1400         
1401         /* safely update contract balance to account for cost to call oraclize*/
1402         contractBalance = safeSub(contractBalance, costToCallOraclizeInWei);	        
1403         /* total number of bets */
1404         totalBets += 1;
1405         /* map bet id to this oraclize query */
1406 		playerBetId[rngId] = rngId;
1407         /* map player lucky number to this oraclize query */
1408 		playerNumber[rngId] = rollUnder;
1409         /* map value of wager to this oraclize query */
1410         playerBetValue[rngId] = msg.value;
1411         /* map player address to this oraclize query */
1412         playerAddress[rngId] = msg.sender;
1413         /* safely map player profit to this oraclize query */                     
1414         playerProfit[rngId] = ((((msg.value * (100-(safeSub(rollUnder,1)))) / (safeSub(rollUnder,1))+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;        
1415         /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
1416         maxPendingPayouts = safeAdd(maxPendingPayouts, playerProfit[rngId]);
1417         /* check contract can payout on win */
1418         if(maxPendingPayouts >= contractBalance) throw;
1419         /* provides accurate numbers for web3 and allows for manual refunds in case of no oraclize __callback */
1420         LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);          
1421 
1422     }   
1423              
1424 
1425     /*
1426     * semi-public function - only oraclize can call
1427     */
1428     /*TLSNotary for oraclize call */
1429 	function __callback(bytes32 myid, string result, bytes proof) public   
1430 		onlyOraclize
1431 		payoutsAreActive
1432 	{  
1433 
1434         /* player address mapped to query id does not exist */
1435         if (playerAddress[myid]==0x0) throw;
1436         
1437         /* keep oraclize honest by retrieving the serialNumber from random.org result */
1438         var sl_result = result.toSlice();
1439         sl_result.beyond("[".toSlice()).until("]".toSlice());
1440         uint serialNumberOfResult = parseInt(sl_result.split(', '.toSlice()).toString());          
1441 
1442 	    /* map result to player */
1443         playerRandomResult[myid] = parseInt(sl_result.beyond("[".toSlice()).until("]".toSlice()).toString());
1444         
1445         /* produce integer bounded to 1-100 inclusive
1446         *  via sha3 result from random.org and proof (IPFS address of TLSNotary proof)
1447         */
1448         playerDieResult[myid] = uint(sha3(playerRandomResult[myid], proof)) % 100 + 1;
1449         
1450         /* get the playerAddress for this query id */
1451         playerTempAddress[myid] = playerAddress[myid];
1452         /* delete playerAddress for this query id */
1453         delete playerAddress[myid];
1454 
1455         /* map the playerProfit for this query id */
1456         playerTempReward[myid] = playerProfit[myid];
1457         /* set  playerProfit for this query id to 0 */
1458         playerProfit[myid] = 0; 
1459 
1460         /* safely reduce maxPendingPayouts liability */
1461         maxPendingPayouts = safeSub(maxPendingPayouts, playerTempReward[myid]);         
1462 
1463         /* map the playerBetValue for this query id */
1464         playerTempBetValue[myid] = playerBetValue[myid];
1465         /* set  playerBetValue for this query id to 0 */
1466         playerBetValue[myid] = 0;                                             
1467 
1468         /*
1469         * refund
1470         * if result from oraclize is 0 refund only the original bet value
1471         * if refund fails save refund value to playerPendingWithdrawals
1472         */
1473         if(playerDieResult[myid]==0){                                
1474 
1475              LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 3, proof);            
1476 
1477             /*
1478             * send refund - external call to an untrusted contract
1479             * if send fails map refund value to playerPendingWithdrawals[address]
1480             * for withdrawal later via playerWithdrawPendingTransactions
1481             */
1482             if(!playerTempAddress[myid].send(playerTempBetValue[myid])){
1483                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 4, proof);              
1484                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
1485                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempBetValue[myid]);                        
1486             }
1487 
1488             return;
1489         }
1490 
1491         /*
1492         * pay winner
1493         * update contract balance to calculate new max bet
1494         * send reward
1495         * if send of reward fails save value to playerPendingWithdrawals        
1496         */
1497         if(playerDieResult[myid] < playerNumber[myid]){ 
1498 
1499             /* safely reduce contract balance by player profit */
1500             contractBalance = safeSub(contractBalance, playerTempReward[myid]); 
1501 
1502             /* update total wei won */
1503             totalWeiWon = safeAdd(totalWeiWon, playerTempReward[myid]);              
1504 
1505             /* safely calculate payout via profit plus original wager */
1506             playerTempReward[myid] = safeAdd(playerTempReward[myid], playerTempBetValue[myid]); 
1507 
1508             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 1, proof);                            
1509 
1510             /* update maximum profit */
1511             setMaxProfit();
1512             
1513             /*
1514             * send win - external call to an untrusted contract
1515             * if send fails map reward value to playerPendingWithdrawals[address]
1516             * for withdrawal later via playerWithdrawPendingTransactions
1517             */
1518             if(!playerTempAddress[myid].send(playerTempReward[myid])){
1519                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 2, proof);                   
1520                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
1521                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempReward[myid]);                               
1522             }
1523 
1524             return;
1525 
1526         }
1527 
1528         /*
1529         * no win
1530         * send 1 wei to a losing bet
1531         * update contract balance to calculate new max bet
1532         */
1533         if(playerDieResult[myid] >= playerNumber[myid]){
1534 
1535             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 0, proof);                                
1536 
1537             /*  
1538             *  safe adjust contractBalance
1539             *  setMaxProfit
1540             *  send 1 wei to losing bet
1541             */
1542             contractBalance = safeAdd(contractBalance, (playerTempBetValue[myid]-1));                                                                         
1543 
1544             /* update maximum profit */
1545             setMaxProfit(); 
1546 
1547             /*
1548             * send 1 wei - external call to an untrusted contract                  
1549             */
1550             if(!playerTempAddress[myid].send(1)){
1551                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */                
1552                playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], 1);                                
1553             }                                   
1554 
1555             return;
1556 
1557         }
1558 
1559     }
1560     
1561     /*
1562     * public function
1563     * in case of a failed refund or win send
1564     */
1565     function playerWithdrawPendingTransactions() public 
1566         payoutsAreActive
1567         returns (bool)
1568      {
1569         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
1570         playerPendingWithdrawals[msg.sender] = 0;
1571         /* external call to untrusted contract */
1572         if (msg.sender.call.value(withdrawAmount)()) {
1573             return true;
1574         } else {
1575             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
1576             /* player can try to withdraw again later */
1577             playerPendingWithdrawals[msg.sender] = withdrawAmount;
1578             return false;
1579         }
1580     }
1581 
1582     /* check for pending withdrawals  */
1583     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
1584         return playerPendingWithdrawals[addressToCheck];
1585     }
1586 
1587     /*
1588     * internal function
1589     * sets max profit
1590     */
1591     function setMaxProfit() internal {
1592         maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxProfitDivisor;  
1593     }   
1594 
1595     /*
1596     * owner/treasury address only functions
1597     */
1598     function ()
1599         payable
1600         onlyTreasury
1601     {
1602         /* safely update contract balance */
1603         contractBalance = safeAdd(contractBalance, msg.value);        
1604         /* update the maximum profit */
1605         setMaxProfit();
1606     } 
1607 
1608     /* set gas for oraclize query */
1609     function ownerSetOraclizeSafeGas(uint32 newSafeGasToOraclize) public 
1610 		onlyOwner
1611 	{
1612     	gasForOraclize = newSafeGasToOraclize;
1613     }
1614 
1615     /* set house cost to call oraclize query */
1616     function ownerUpdateCostToCallOraclize(uint newCostToCallOraclizeInWei) public 
1617 		onlyOwner
1618     {        
1619        costToCallOraclizeInWei = newCostToCallOraclizeInWei;
1620     }     
1621 
1622     /* only owner address can set houseEdge */
1623     function ownerSetHouseEdge(uint newHouseEdge) public 
1624 		onlyOwner
1625     {
1626         houseEdge = newHouseEdge;
1627     }
1628 
1629     /* only owner address can set maxProfitAsPercentOfHouse */
1630     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public 
1631 		onlyOwner
1632     {
1633         /* restrict each bet to a maximum profit of 1% contractBalance */
1634         if(newMaxProfitAsPercent > 10000) throw;
1635         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
1636         setMaxProfit();
1637     }
1638 
1639     /* only owner address can set minBet */
1640     function ownerSetMinBet(uint newMinimumBet) public 
1641 		onlyOwner
1642     {
1643         minBet = newMinimumBet;
1644     }       
1645 
1646     /* only owner address can transfer ether */
1647     function ownerTransferEther(address sendTo, uint amount) public 
1648 		onlyOwner
1649     {        
1650         /* safely update contract balance when sending out funds*/
1651         contractBalance = safeSub(contractBalance, amount);		
1652         /* update max profit */
1653         setMaxProfit();
1654         if(!sendTo.send(amount)) throw;
1655         LogOwnerTransfer(sendTo, amount); 
1656     }
1657 
1658     /* only owner address can do manual refund
1659     * used only if bet placed + oraclize failed to __callback
1660     * filter LogBet by address and/or playerBetId:
1661     * LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
1662     * check the following logs do not exist for playerBetId and/or playerAddress[rngId] before refunding:
1663     * LogResult or LogRefund
1664     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions 
1665     */
1666     function ownerRefundPlayer(bytes32 originalPlayerBetId, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public 
1667 		onlyOwner
1668     {        
1669         /* safely reduce pendingPayouts by playerProfit[rngId] */
1670         maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
1671         /* send refund */
1672         if(!sendTo.send(originalPlayerBetValue)) throw;
1673         /* log refunds */
1674         LogRefund(originalPlayerBetId, sendTo, originalPlayerBetValue);        
1675     }    
1676 
1677     /* only owner address can set emergency pause #1 */
1678     function ownerPauseGame(bool newStatus) public 
1679 		onlyOwner
1680     {
1681 		gamePaused = newStatus;
1682     }
1683 
1684     /* only owner address can set emergency pause #2 */
1685     function ownerPausePayouts(bool newPayoutStatus) public 
1686 		onlyOwner
1687     {
1688 		payoutsPaused = newPayoutStatus;
1689     } 
1690 
1691     /* only owner address can set treasury address */
1692     function ownerSetTreasury(address newTreasury) public 
1693 		onlyOwner
1694 	{
1695         treasury = newTreasury;
1696     }         
1697 
1698     /* only owner address can set owner address */
1699     function ownerChangeOwner(address newOwner) public 
1700 		onlyOwner
1701 	{
1702         owner = newOwner;
1703     }
1704 
1705     /* only owner address can suicide - emergency */
1706     function ownerkill() public 
1707 		onlyOwner
1708 	{
1709 		suicide(owner);
1710 	}    
1711 
1712 
1713 }