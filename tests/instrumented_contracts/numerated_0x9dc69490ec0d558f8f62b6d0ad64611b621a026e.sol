1 //just updated the encrypted api key
2 //updated contractBalance -= 57245901639344;
3 //removed safesub from all contractBalance and replaced with operators
4 
5 pragma solidity ^0.4.2;
6 
7 // <ORACLIZE_API>
8 /*
9 Copyright (c) 2015-2016 Oraclize SRL
10 Copyright (c) 2016 Oraclize LTD
11 
12 
13 
14 Permission is hereby granted, free of charge, to any person obtaining a copy
15 of this software and associated documentation files (the "Software"), to deal
16 in the Software without restriction, including without limitation the rights
17 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
18 copies of the Software, and to permit persons to whom the Software is
19 furnished to do so, subject to the following conditions:
20 
21 
22 
23 The above copyright notice and this permission notice shall be included in
24 all copies or substantial portions of the Software.
25 
26 
27 
28 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
31 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
34 THE SOFTWARE.
35 */
36 
37 contract OraclizeI {
38     address public cbAddress;
39     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
40     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
41     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
42     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
43     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
44     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
45     function getPrice(string _datasource) returns (uint _dsprice);
46     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
47     function useCoupon(string _coupon);
48     function setProofType(byte _proofType);
49     function setConfig(bytes32 _config);
50     function setCustomGasPrice(uint _gasPrice);
51 }
52 contract OraclizeAddrResolverI {
53     function getAddress() returns (address _addr);
54 }
55 contract usingOraclize {
56     uint constant day = 60*60*24;
57     uint constant week = 60*60*24*7;
58     uint constant month = 60*60*24*30;
59     byte constant proofType_NONE = 0x00;
60     byte constant proofType_TLSNotary = 0x10;
61     byte constant proofStorage_IPFS = 0x01;
62     uint8 constant networkID_auto = 0;
63     uint8 constant networkID_mainnet = 1;
64     uint8 constant networkID_testnet = 2;
65     uint8 constant networkID_morden = 2;
66     uint8 constant networkID_consensys = 161;
67 
68     OraclizeAddrResolverI OAR;
69 
70     OraclizeI oraclize;
71     modifier oraclizeAPI {
72         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
73         oraclize = OraclizeI(OAR.getAddress());
74         _;
75     }
76     modifier coupon(string code){
77         oraclize = OraclizeI(OAR.getAddress());
78         oraclize.useCoupon(code);
79         _;
80     }
81 
82     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
83         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
84             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
85             return true;
86         }
87         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
88             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
89             return true;
90         }
91         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
92             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
93             return true;
94         }
95         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
96             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
97             return true;
98         }
99         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
100             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
101             return true;
102         }
103         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
104             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
105             return true;
106         }
107         return false;
108     }
109 
110     function __callback(bytes32 myid, string result) {
111         __callback(myid, result, new bytes(0));
112     }
113     function __callback(bytes32 myid, string result, bytes proof) {
114     }
115 
116     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
117         return oraclize.getPrice(datasource);
118     }
119 
120     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
121         return oraclize.getPrice(datasource, gaslimit);
122     }
123     
124     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
125         uint price = oraclize.getPrice(datasource);
126         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
127         return oraclize.query.value(price)(0, datasource, arg);
128     }
129     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
130         uint price = oraclize.getPrice(datasource);
131         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
132         return oraclize.query.value(price)(timestamp, datasource, arg);
133     }
134     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
135         uint price = oraclize.getPrice(datasource, gaslimit);
136         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
137         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
138     }
139     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
140         uint price = oraclize.getPrice(datasource, gaslimit);
141         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
142         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
143     }
144     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
145         uint price = oraclize.getPrice(datasource);
146         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
147         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
148     }
149     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
150         uint price = oraclize.getPrice(datasource);
151         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
152         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
153     }
154     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
155         uint price = oraclize.getPrice(datasource, gaslimit);
156         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
157         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
158     }
159     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
160         uint price = oraclize.getPrice(datasource, gaslimit);
161         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
162         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
163     }
164     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
165         uint price = oraclize.getPrice(datasource);
166         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
167         bytes memory args = stra2cbor(argN);
168         return oraclize.queryN.value(price)(0, datasource, args);
169     }
170     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
171         uint price = oraclize.getPrice(datasource);
172         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
173         bytes memory args = stra2cbor(argN);
174         return oraclize.queryN.value(price)(timestamp, datasource, args);
175     }
176     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
177         uint price = oraclize.getPrice(datasource, gaslimit);
178         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
179         bytes memory args = stra2cbor(argN);
180         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
181     }
182     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
183         uint price = oraclize.getPrice(datasource, gaslimit);
184         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
185         bytes memory args = stra2cbor(argN);
186         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
187     }
188     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
189         string[] memory dynargs = new string[](1);
190         dynargs[0] = args[0];
191         return oraclize_query(datasource, dynargs);
192     }
193     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
194         string[] memory dynargs = new string[](1);
195         dynargs[0] = args[0];
196         return oraclize_query(timestamp, datasource, dynargs);
197     }
198     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
199         string[] memory dynargs = new string[](1);
200         dynargs[0] = args[0];
201         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
202     }
203     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
204         string[] memory dynargs = new string[](1);
205         dynargs[0] = args[0];       
206         return oraclize_query(datasource, dynargs, gaslimit);
207     }
208     
209     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
210         string[] memory dynargs = new string[](2);
211         dynargs[0] = args[0];
212         dynargs[1] = args[1];
213         return oraclize_query(datasource, dynargs);
214     }
215     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
216         string[] memory dynargs = new string[](2);
217         dynargs[0] = args[0];
218         dynargs[1] = args[1];
219         return oraclize_query(timestamp, datasource, dynargs);
220     }
221     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
222         string[] memory dynargs = new string[](2);
223         dynargs[0] = args[0];
224         dynargs[1] = args[1];
225         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
226     }
227     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
228         string[] memory dynargs = new string[](2);
229         dynargs[0] = args[0];
230         dynargs[1] = args[1];
231         return oraclize_query(datasource, dynargs, gaslimit);
232     }
233     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
234         string[] memory dynargs = new string[](3);
235         dynargs[0] = args[0];
236         dynargs[1] = args[1];
237         dynargs[2] = args[2];
238         return oraclize_query(datasource, dynargs);
239     }
240     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
241         string[] memory dynargs = new string[](3);
242         dynargs[0] = args[0];
243         dynargs[1] = args[1];
244         dynargs[2] = args[2];
245         return oraclize_query(timestamp, datasource, dynargs);
246     }
247     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
248         string[] memory dynargs = new string[](3);
249         dynargs[0] = args[0];
250         dynargs[1] = args[1];
251         dynargs[2] = args[2];
252         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
253     }
254     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
255         string[] memory dynargs = new string[](3);
256         dynargs[0] = args[0];
257         dynargs[1] = args[1];
258         dynargs[2] = args[2];
259         return oraclize_query(datasource, dynargs, gaslimit);
260     }
261     
262     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
263         string[] memory dynargs = new string[](4);
264         dynargs[0] = args[0];
265         dynargs[1] = args[1];
266         dynargs[2] = args[2];
267         dynargs[3] = args[3];
268         return oraclize_query(datasource, dynargs);
269     }
270     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
271         string[] memory dynargs = new string[](4);
272         dynargs[0] = args[0];
273         dynargs[1] = args[1];
274         dynargs[2] = args[2];
275         dynargs[3] = args[3];
276         return oraclize_query(timestamp, datasource, dynargs);
277     }
278     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
279         string[] memory dynargs = new string[](4);
280         dynargs[0] = args[0];
281         dynargs[1] = args[1];
282         dynargs[2] = args[2];
283         dynargs[3] = args[3];
284         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
285     }
286     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
287         string[] memory dynargs = new string[](4);
288         dynargs[0] = args[0];
289         dynargs[1] = args[1];
290         dynargs[2] = args[2];
291         dynargs[3] = args[3];
292         return oraclize_query(datasource, dynargs, gaslimit);
293     }
294     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
295         string[] memory dynargs = new string[](5);
296         dynargs[0] = args[0];
297         dynargs[1] = args[1];
298         dynargs[2] = args[2];
299         dynargs[3] = args[3];
300         dynargs[4] = args[4];
301         return oraclize_query(datasource, dynargs);
302     }
303     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
304         string[] memory dynargs = new string[](5);
305         dynargs[0] = args[0];
306         dynargs[1] = args[1];
307         dynargs[2] = args[2];
308         dynargs[3] = args[3];
309         dynargs[4] = args[4];
310         return oraclize_query(timestamp, datasource, dynargs);
311     }
312     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
313         string[] memory dynargs = new string[](5);
314         dynargs[0] = args[0];
315         dynargs[1] = args[1];
316         dynargs[2] = args[2];
317         dynargs[3] = args[3];
318         dynargs[4] = args[4];
319         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
320     }
321     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
322         string[] memory dynargs = new string[](5);
323         dynargs[0] = args[0];
324         dynargs[1] = args[1];
325         dynargs[2] = args[2];
326         dynargs[3] = args[3];
327         dynargs[4] = args[4];
328         return oraclize_query(datasource, dynargs, gaslimit);
329     }
330 
331     function oraclize_cbAddress() oraclizeAPI internal returns (address){
332         return oraclize.cbAddress();
333     }
334     function oraclize_setProof(byte proofP) oraclizeAPI internal {
335         return oraclize.setProofType(proofP);
336     }
337     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
338         return oraclize.setCustomGasPrice(gasPrice);
339     }
340     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
341         return oraclize.setConfig(config);
342     }
343 
344     function getCodeSize(address _addr) constant internal returns(uint _size) {
345         assembly {
346             _size := extcodesize(_addr)
347         }
348     }
349 
350     function parseAddr(string _a) internal returns (address){
351         bytes memory tmp = bytes(_a);
352         uint160 iaddr = 0;
353         uint160 b1;
354         uint160 b2;
355         for (uint i=2; i<2+2*20; i+=2){
356             iaddr *= 256;
357             b1 = uint160(tmp[i]);
358             b2 = uint160(tmp[i+1]);
359             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
360             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
361             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
362             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
363             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
364             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
365             iaddr += (b1*16+b2);
366         }
367         return address(iaddr);
368     }
369 
370     function strCompare(string _a, string _b) internal returns (int) {
371         bytes memory a = bytes(_a);
372         bytes memory b = bytes(_b);
373         uint minLength = a.length;
374         if (b.length < minLength) minLength = b.length;
375         for (uint i = 0; i < minLength; i ++)
376             if (a[i] < b[i])
377                 return -1;
378             else if (a[i] > b[i])
379                 return 1;
380         if (a.length < b.length)
381             return -1;
382         else if (a.length > b.length)
383             return 1;
384         else
385             return 0;
386     }
387 
388     function indexOf(string _haystack, string _needle) internal returns (int) {
389         bytes memory h = bytes(_haystack);
390         bytes memory n = bytes(_needle);
391         if(h.length < 1 || n.length < 1 || (n.length > h.length))
392             return -1;
393         else if(h.length > (2**128 -1))
394             return -1;
395         else
396         {
397             uint subindex = 0;
398             for (uint i = 0; i < h.length; i ++)
399             {
400                 if (h[i] == n[0])
401                 {
402                     subindex = 1;
403                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
404                     {
405                         subindex++;
406                     }
407                     if(subindex == n.length)
408                         return int(i);
409                 }
410             }
411             return -1;
412         }
413     }
414 
415     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
416         bytes memory _ba = bytes(_a);
417         bytes memory _bb = bytes(_b);
418         bytes memory _bc = bytes(_c);
419         bytes memory _bd = bytes(_d);
420         bytes memory _be = bytes(_e);
421         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
422         bytes memory babcde = bytes(abcde);
423         uint k = 0;
424         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
425         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
426         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
427         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
428         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
429         return string(babcde);
430     }
431 
432     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
433         return strConcat(_a, _b, _c, _d, "");
434     }
435 
436     function strConcat(string _a, string _b, string _c) internal returns (string) {
437         return strConcat(_a, _b, _c, "", "");
438     }
439 
440     function strConcat(string _a, string _b) internal returns (string) {
441         return strConcat(_a, _b, "", "", "");
442     }
443 
444     // parseInt
445     function parseInt(string _a) internal returns (uint) {
446         return parseInt(_a, 0);
447     }
448 
449     // parseInt(parseFloat*10^_b)
450     function parseInt(string _a, uint _b) internal returns (uint) {
451         bytes memory bresult = bytes(_a);
452         uint mint = 0;
453         bool decimals = false;
454         for (uint i=0; i<bresult.length; i++){
455             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
456                 if (decimals){
457                    if (_b == 0) break;
458                     else _b--;
459                 }
460                 mint *= 10;
461                 mint += uint(bresult[i]) - 48;
462             } else if (bresult[i] == 46) decimals = true;
463         }
464         if (_b > 0) mint *= 10**_b;
465         return mint;
466     }
467 
468     function uint2str(uint i) internal returns (string){
469         if (i == 0) return "0";
470         uint j = i;
471         uint len;
472         while (j != 0){
473             len++;
474             j /= 10;
475         }
476         bytes memory bstr = new bytes(len);
477         uint k = len - 1;
478         while (i != 0){
479             bstr[k--] = byte(48 + i % 10);
480             i /= 10;
481         }
482         return string(bstr);
483     }
484 
485     function stra2cbor(string[] arr) internal returns (bytes) {
486             uint arrlen = arr.length;
487 
488             // get correct cbor output length
489             uint outputlen = 0;
490             bytes[] memory elemArray = new bytes[](arrlen);
491             for (uint i = 0; i < arrlen; i++) {
492                 elemArray[i] = (bytes(arr[i]));
493                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
494             }
495             uint ctr = 0;
496             uint cborlen = arrlen + 0x80;
497             outputlen += byte(cborlen).length;
498             bytes memory res = new bytes(outputlen);
499 
500             while (byte(cborlen).length > ctr) {
501                 res[ctr] = byte(cborlen)[ctr];
502                 ctr++;
503             }
504             for (i = 0; i < arrlen; i++) {
505                 res[ctr] = 0x5F;
506                 ctr++;
507                 for (uint x = 0; x < elemArray[i].length; x++) {
508                     // if there's a bug with larger strings, this may be the culprit
509                     if (x % 23 == 0) {
510                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
511                         elemcborlen += 0x40;
512                         uint lctr = ctr;
513                         while (byte(elemcborlen).length > ctr - lctr) {
514                             res[ctr] = byte(elemcborlen)[ctr - lctr];
515                             ctr++;
516                         }
517                     }
518                     res[ctr] = elemArray[i][x];
519                     ctr++;
520                 }
521                 res[ctr] = 0xFF;
522                 ctr++;
523             }
524             return res;
525         }
526 }
527 // </ORACLIZE_API>
528 
529 /*
530  * @title String & slice utility library for Solidity contracts.
531  * @author Nick Johnson <arachnid@notdot.net>
532  *
533  * @dev Functionality in this library is largely implemented using an
534  *      abstraction called a 'slice'. A slice represents a part of a string -
535  *      anything from the entire string to a single character, or even no
536  *      characters at all (a 0-length slice). Since a slice only has to specify
537  *      an offset and a length, copying and manipulating slices is a lot less
538  *      expensive than copying and manipulating the strings they reference.
539  *
540  *      To further reduce gas costs, most functions on slice that need to return
541  *      a slice modify the original one instead of allocating a new one; for
542  *      instance, `s.split(".")` will return the text up to the first '.',
543  *      modifying s to only contain the remainder of the string after the '.'.
544  *      In situations where you do not want to modify the original slice, you
545  *      can make a copy first with `.copy()`, for example:
546  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
547  *      Solidity has no memory management, it will result in allocating many
548  *      short-lived slices that are later discarded.
549  *
550  *      Functions that return two slices come in two versions: a non-allocating
551  *      version that takes the second slice as an argument, modifying it in
552  *      place, and an allocating version that allocates and returns the second
553  *      slice; see `nextRune` for example.
554  *
555  *      Functions that have to copy string data will return strings rather than
556  *      slices; these can be cast back to slices for further processing if
557  *      required.
558  *
559  *      For convenience, some functions are provided with non-modifying
560  *      variants that create a new slice and return both; for instance,
561  *      `s.splitNew('.')` leaves s unmodified, and returns two values
562  *      corresponding to the left and right parts of the string.
563  */
564 library strings {
565     struct slice {
566         uint _len;
567         uint _ptr;
568     }
569 
570     function memcpy(uint dest, uint src, uint len) private {
571         // Copy word-length chunks while possible
572         for(; len >= 32; len -= 32) {
573             assembly {
574                 mstore(dest, mload(src))
575             }
576             dest += 32;
577             src += 32;
578         }
579 
580         // Copy remaining bytes
581         uint mask = 256 ** (32 - len) - 1;
582         assembly {
583             let srcpart := and(mload(src), not(mask))
584             let destpart := and(mload(dest), mask)
585             mstore(dest, or(destpart, srcpart))
586         }
587     }
588 
589     /*
590      * @dev Returns a slice containing the entire string.
591      * @param self The string to make a slice from.
592      * @return A newly allocated slice containing the entire string.
593      */
594     function toSlice(string self) internal returns (slice) {
595         uint ptr;
596         assembly {
597             ptr := add(self, 0x20)
598         }
599         return slice(bytes(self).length, ptr);
600     }
601 
602     /*
603      * @dev Returns the length of a null-terminated bytes32 string.
604      * @param self The value to find the length of.
605      * @return The length of the string, from 0 to 32.
606      */
607     function len(bytes32 self) internal returns (uint) {
608         uint ret;
609         if (self == 0)
610             return 0;
611         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
612             ret += 16;
613             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
614         }
615         if (self & 0xffffffffffffffff == 0) {
616             ret += 8;
617             self = bytes32(uint(self) / 0x10000000000000000);
618         }
619         if (self & 0xffffffff == 0) {
620             ret += 4;
621             self = bytes32(uint(self) / 0x100000000);
622         }
623         if (self & 0xffff == 0) {
624             ret += 2;
625             self = bytes32(uint(self) / 0x10000);
626         }
627         if (self & 0xff == 0) {
628             ret += 1;
629         }
630         return 32 - ret;
631     }
632 
633     /*
634      * @dev Returns a slice containing the entire bytes32, interpreted as a
635      *      null-termintaed utf-8 string.
636      * @param self The bytes32 value to convert to a slice.
637      * @return A new slice containing the value of the input argument up to the
638      *         first null.
639      */
640     function toSliceB32(bytes32 self) internal returns (slice ret) {
641         // Allocate space for `self` in memory, copy it there, and point ret at it
642         assembly {
643             let ptr := mload(0x40)
644             mstore(0x40, add(ptr, 0x20))
645             mstore(ptr, self)
646             mstore(add(ret, 0x20), ptr)
647         }
648         ret._len = len(self);
649     }
650 
651     /*
652      * @dev Returns a new slice containing the same data as the current slice.
653      * @param self The slice to copy.
654      * @return A new slice containing the same data as `self`.
655      */
656     function copy(slice self) internal returns (slice) {
657         return slice(self._len, self._ptr);
658     }
659 
660     /*
661      * @dev Copies a slice to a new string.
662      * @param self The slice to copy.
663      * @return A newly allocated string containing the slice's text.
664      */
665     function toString(slice self) internal returns (string) {
666         var ret = new string(self._len);
667         uint retptr;
668         assembly { retptr := add(ret, 32) }
669 
670         memcpy(retptr, self._ptr, self._len);
671         return ret;
672     }
673 
674     /*
675      * @dev Returns the length in runes of the slice. Note that this operation
676      *      takes time proportional to the length of the slice; avoid using it
677      *      in loops, and call `slice.empty()` if you only need to know whether
678      *      the slice is empty or not.
679      * @param self The slice to operate on.
680      * @return The length of the slice in runes.
681      */
682     function len(slice self) internal returns (uint) {
683         // Starting at ptr-31 means the LSB will be the byte we care about
684         var ptr = self._ptr - 31;
685         var end = ptr + self._len;
686         for (uint len = 0; ptr < end; len++) {
687             uint8 b;
688             assembly { b := and(mload(ptr), 0xFF) }
689             if (b < 0x80) {
690                 ptr += 1;
691             } else if(b < 0xE0) {
692                 ptr += 2;
693             } else if(b < 0xF0) {
694                 ptr += 3;
695             } else if(b < 0xF8) {
696                 ptr += 4;
697             } else if(b < 0xFC) {
698                 ptr += 5;
699             } else {
700                 ptr += 6;
701             }
702         }
703         return len;
704     }
705 
706     /*
707      * @dev Returns true if the slice is empty (has a length of 0).
708      * @param self The slice to operate on.
709      * @return True if the slice is empty, False otherwise.
710      */
711     function empty(slice self) internal returns (bool) {
712         return self._len == 0;
713     }
714 
715     /*
716      * @dev Returns a positive number if `other` comes lexicographically after
717      *      `self`, a negative number if it comes before, or zero if the
718      *      contents of the two slices are equal. Comparison is done per-rune,
719      *      on unicode codepoints.
720      * @param self The first slice to compare.
721      * @param other The second slice to compare.
722      * @return The result of the comparison.
723      */
724     function compare(slice self, slice other) internal returns (int) {
725         uint shortest = self._len;
726         if (other._len < self._len)
727             shortest = other._len;
728 
729         var selfptr = self._ptr;
730         var otherptr = other._ptr;
731         for (uint idx = 0; idx < shortest; idx += 32) {
732             uint a;
733             uint b;
734             assembly {
735                 a := mload(selfptr)
736                 b := mload(otherptr)
737             }
738             if (a != b) {
739                 // Mask out irrelevant bytes and check again
740                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
741                 var diff = (a & mask) - (b & mask);
742                 if (diff != 0)
743                     return int(diff);
744             }
745             selfptr += 32;
746             otherptr += 32;
747         }
748         return int(self._len) - int(other._len);
749     }
750 
751     /*
752      * @dev Returns true if the two slices contain the same text.
753      * @param self The first slice to compare.
754      * @param self The second slice to compare.
755      * @return True if the slices are equal, false otherwise.
756      */
757     function equals(slice self, slice other) internal returns (bool) {
758         return compare(self, other) == 0;
759     }
760 
761     /*
762      * @dev Extracts the first rune in the slice into `rune`, advancing the
763      *      slice to point to the next rune and returning `self`.
764      * @param self The slice to operate on.
765      * @param rune The slice that will contain the first rune.
766      * @return `rune`.
767      */
768     function nextRune(slice self, slice rune) internal returns (slice) {
769         rune._ptr = self._ptr;
770 
771         if (self._len == 0) {
772             rune._len = 0;
773             return rune;
774         }
775 
776         uint len;
777         uint b;
778         // Load the first byte of the rune into the LSBs of b
779         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
780         if (b < 0x80) {
781             len = 1;
782         } else if(b < 0xE0) {
783             len = 2;
784         } else if(b < 0xF0) {
785             len = 3;
786         } else {
787             len = 4;
788         }
789 
790         // Check for truncated codepoints
791         if (len > self._len) {
792             rune._len = self._len;
793             self._ptr += self._len;
794             self._len = 0;
795             return rune;
796         }
797 
798         self._ptr += len;
799         self._len -= len;
800         rune._len = len;
801         return rune;
802     }
803 
804     /*
805      * @dev Returns the first rune in the slice, advancing the slice to point
806      *      to the next rune.
807      * @param self The slice to operate on.
808      * @return A slice containing only the first rune from `self`.
809      */
810     function nextRune(slice self) internal returns (slice ret) {
811         nextRune(self, ret);
812     }
813 
814     /*
815      * @dev Returns the number of the first codepoint in the slice.
816      * @param self The slice to operate on.
817      * @return The number of the first codepoint in the slice.
818      */
819     function ord(slice self) internal returns (uint ret) {
820         if (self._len == 0) {
821             return 0;
822         }
823 
824         uint word;
825         uint len;
826         uint div = 2 ** 248;
827 
828         // Load the rune into the MSBs of b
829         assembly { word:= mload(mload(add(self, 32))) }
830         var b = word / div;
831         if (b < 0x80) {
832             ret = b;
833             len = 1;
834         } else if(b < 0xE0) {
835             ret = b & 0x1F;
836             len = 2;
837         } else if(b < 0xF0) {
838             ret = b & 0x0F;
839             len = 3;
840         } else {
841             ret = b & 0x07;
842             len = 4;
843         }
844 
845         // Check for truncated codepoints
846         if (len > self._len) {
847             return 0;
848         }
849 
850         for (uint i = 1; i < len; i++) {
851             div = div / 256;
852             b = (word / div) & 0xFF;
853             if (b & 0xC0 != 0x80) {
854                 // Invalid UTF-8 sequence
855                 return 0;
856             }
857             ret = (ret * 64) | (b & 0x3F);
858         }
859 
860         return ret;
861     }
862 
863     /*
864      * @dev Returns the keccak-256 hash of the slice.
865      * @param self The slice to hash.
866      * @return The hash of the slice.
867      */
868     function keccak(slice self) internal returns (bytes32 ret) {
869         assembly {
870             ret := sha3(mload(add(self, 32)), mload(self))
871         }
872     }
873 
874     /*
875      * @dev Returns true if `self` starts with `needle`.
876      * @param self The slice to operate on.
877      * @param needle The slice to search for.
878      * @return True if the slice starts with the provided text, false otherwise.
879      */
880     function startsWith(slice self, slice needle) internal returns (bool) {
881         if (self._len < needle._len) {
882             return false;
883         }
884 
885         if (self._ptr == needle._ptr) {
886             return true;
887         }
888 
889         bool equal;
890         assembly {
891             let len := mload(needle)
892             let selfptr := mload(add(self, 0x20))
893             let needleptr := mload(add(needle, 0x20))
894             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
895         }
896         return equal;
897     }
898 
899     /*
900      * @dev If `self` starts with `needle`, `needle` is removed from the
901      *      beginning of `self`. Otherwise, `self` is unmodified.
902      * @param self The slice to operate on.
903      * @param needle The slice to search for.
904      * @return `self`
905      */
906     function beyond(slice self, slice needle) internal returns (slice) {
907         if (self._len < needle._len) {
908             return self;
909         }
910 
911         bool equal = true;
912         if (self._ptr != needle._ptr) {
913             assembly {
914                 let len := mload(needle)
915                 let selfptr := mload(add(self, 0x20))
916                 let needleptr := mload(add(needle, 0x20))
917                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
918             }
919         }
920 
921         if (equal) {
922             self._len -= needle._len;
923             self._ptr += needle._len;
924         }
925 
926         return self;
927     }
928 
929     /*
930      * @dev Returns true if the slice ends with `needle`.
931      * @param self The slice to operate on.
932      * @param needle The slice to search for.
933      * @return True if the slice starts with the provided text, false otherwise.
934      */
935     function endsWith(slice self, slice needle) internal returns (bool) {
936         if (self._len < needle._len) {
937             return false;
938         }
939 
940         var selfptr = self._ptr + self._len - needle._len;
941 
942         if (selfptr == needle._ptr) {
943             return true;
944         }
945 
946         bool equal;
947         assembly {
948             let len := mload(needle)
949             let needleptr := mload(add(needle, 0x20))
950             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
951         }
952 
953         return equal;
954     }
955 
956     /*
957      * @dev If `self` ends with `needle`, `needle` is removed from the
958      *      end of `self`. Otherwise, `self` is unmodified.
959      * @param self The slice to operate on.
960      * @param needle The slice to search for.
961      * @return `self`
962      */
963     function until(slice self, slice needle) internal returns (slice) {
964         if (self._len < needle._len) {
965             return self;
966         }
967 
968         var selfptr = self._ptr + self._len - needle._len;
969         bool equal = true;
970         if (selfptr != needle._ptr) {
971             assembly {
972                 let len := mload(needle)
973                 let needleptr := mload(add(needle, 0x20))
974                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
975             }
976         }
977 
978         if (equal) {
979             self._len -= needle._len;
980         }
981 
982         return self;
983     }
984 
985     // Returns the memory address of the first byte of the first occurrence of
986     // `needle` in `self`, or the first byte after `self` if not found.
987     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
988         uint ptr;
989         uint idx;
990 
991         if (needlelen <= selflen) {
992             if (needlelen <= 32) {
993                 // Optimized assembly for 68 gas per byte on short strings
994                 assembly {
995                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
996                     let needledata := and(mload(needleptr), mask)
997                     let end := add(selfptr, sub(selflen, needlelen))
998                     ptr := selfptr
999                     loop:
1000                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1001                     ptr := add(ptr, 1)
1002                     jumpi(loop, lt(sub(ptr, 1), end))
1003                     ptr := add(selfptr, selflen)
1004                     exit:
1005                 }
1006                 return ptr;
1007             } else {
1008                 // For long needles, use hashing
1009                 bytes32 hash;
1010                 assembly { hash := sha3(needleptr, needlelen) }
1011                 ptr = selfptr;
1012                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1013                     bytes32 testHash;
1014                     assembly { testHash := sha3(ptr, needlelen) }
1015                     if (hash == testHash)
1016                         return ptr;
1017                     ptr += 1;
1018                 }
1019             }
1020         }
1021         return selfptr + selflen;
1022     }
1023 
1024     // Returns the memory address of the first byte after the last occurrence of
1025     // `needle` in `self`, or the address of `self` if not found.
1026     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1027         uint ptr;
1028 
1029         if (needlelen <= selflen) {
1030             if (needlelen <= 32) {
1031                 // Optimized assembly for 69 gas per byte on short strings
1032                 assembly {
1033                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1034                     let needledata := and(mload(needleptr), mask)
1035                     ptr := add(selfptr, sub(selflen, needlelen))
1036                     loop:
1037                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1038                     ptr := sub(ptr, 1)
1039                     jumpi(loop, gt(add(ptr, 1), selfptr))
1040                     ptr := selfptr
1041                     jump(exit)
1042                     ret:
1043                     ptr := add(ptr, needlelen)
1044                     exit:
1045                 }
1046                 return ptr;
1047             } else {
1048                 // For long needles, use hashing
1049                 bytes32 hash;
1050                 assembly { hash := sha3(needleptr, needlelen) }
1051                 ptr = selfptr + (selflen - needlelen);
1052                 while (ptr >= selfptr) {
1053                     bytes32 testHash;
1054                     assembly { testHash := sha3(ptr, needlelen) }
1055                     if (hash == testHash)
1056                         return ptr + needlelen;
1057                     ptr -= 1;
1058                 }
1059             }
1060         }
1061         return selfptr;
1062     }
1063 
1064     /*
1065      * @dev Modifies `self` to contain everything from the first occurrence of
1066      *      `needle` to the end of the slice. `self` is set to the empty slice
1067      *      if `needle` is not found.
1068      * @param self The slice to search and modify.
1069      * @param needle The text to search for.
1070      * @return `self`.
1071      */
1072     function find(slice self, slice needle) internal returns (slice) {
1073         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1074         self._len -= ptr - self._ptr;
1075         self._ptr = ptr;
1076         return self;
1077     }
1078 
1079     /*
1080      * @dev Modifies `self` to contain the part of the string from the start of
1081      *      `self` to the end of the first occurrence of `needle`. If `needle`
1082      *      is not found, `self` is set to the empty slice.
1083      * @param self The slice to search and modify.
1084      * @param needle The text to search for.
1085      * @return `self`.
1086      */
1087     function rfind(slice self, slice needle) internal returns (slice) {
1088         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1089         self._len = ptr - self._ptr;
1090         return self;
1091     }
1092 
1093     /*
1094      * @dev Splits the slice, setting `self` to everything after the first
1095      *      occurrence of `needle`, and `token` to everything before it. If
1096      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1097      *      and `token` is set to the entirety of `self`.
1098      * @param self The slice to split.
1099      * @param needle The text to search for in `self`.
1100      * @param token An output parameter to which the first token is written.
1101      * @return `token`.
1102      */
1103     function split(slice self, slice needle, slice token) internal returns (slice) {
1104         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1105         token._ptr = self._ptr;
1106         token._len = ptr - self._ptr;
1107         if (ptr == self._ptr + self._len) {
1108             // Not found
1109             self._len = 0;
1110         } else {
1111             self._len -= token._len + needle._len;
1112             self._ptr = ptr + needle._len;
1113         }
1114         return token;
1115     }
1116 
1117     /*
1118      * @dev Splits the slice, setting `self` to everything after the first
1119      *      occurrence of `needle`, and returning everything before it. If
1120      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1121      *      and the entirety of `self` is returned.
1122      * @param self The slice to split.
1123      * @param needle The text to search for in `self`.
1124      * @return The part of `self` up to the first occurrence of `delim`.
1125      */
1126     function split(slice self, slice needle) internal returns (slice token) {
1127         split(self, needle, token);
1128     }
1129 
1130     /*
1131      * @dev Splits the slice, setting `self` to everything before the last
1132      *      occurrence of `needle`, and `token` to everything after it. If
1133      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1134      *      and `token` is set to the entirety of `self`.
1135      * @param self The slice to split.
1136      * @param needle The text to search for in `self`.
1137      * @param token An output parameter to which the first token is written.
1138      * @return `token`.
1139      */
1140     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1141         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1142         token._ptr = ptr;
1143         token._len = self._len - (ptr - self._ptr);
1144         if (ptr == self._ptr) {
1145             // Not found
1146             self._len = 0;
1147         } else {
1148             self._len -= token._len + needle._len;
1149         }
1150         return token;
1151     }
1152 
1153     /*
1154      * @dev Splits the slice, setting `self` to everything before the last
1155      *      occurrence of `needle`, and returning everything after it. If
1156      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1157      *      and the entirety of `self` is returned.
1158      * @param self The slice to split.
1159      * @param needle The text to search for in `self`.
1160      * @return The part of `self` after the last occurrence of `delim`.
1161      */
1162     function rsplit(slice self, slice needle) internal returns (slice token) {
1163         rsplit(self, needle, token);
1164     }
1165 
1166     /*
1167      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1168      * @param self The slice to search.
1169      * @param needle The text to search for in `self`.
1170      * @return The number of occurrences of `needle` found in `self`.
1171      */
1172     function count(slice self, slice needle) internal returns (uint count) {
1173         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1174         while (ptr <= self._ptr + self._len) {
1175             count++;
1176             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1177         }
1178     }
1179 
1180     /*
1181      * @dev Returns True if `self` contains `needle`.
1182      * @param self The slice to search.
1183      * @param needle The text to search for in `self`.
1184      * @return True if `needle` is found in `self`, false otherwise.
1185      */
1186     function contains(slice self, slice needle) internal returns (bool) {
1187         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1188     }
1189 
1190     /*
1191      * @dev Returns a newly allocated string containing the concatenation of
1192      *      `self` and `other`.
1193      * @param self The first slice to concatenate.
1194      * @param other The second slice to concatenate.
1195      * @return The concatenation of the two strings.
1196      */
1197     function concat(slice self, slice other) internal returns (string) {
1198         var ret = new string(self._len + other._len);
1199         uint retptr;
1200         assembly { retptr := add(ret, 32) }
1201         memcpy(retptr, self._ptr, self._len);
1202         memcpy(retptr + self._len, other._ptr, other._len);
1203         return ret;
1204     }
1205 
1206     /*
1207      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1208      *      newly allocated string.
1209      * @param self The delimiter to use.
1210      * @param parts A list of slices to join.
1211      * @return A newly allocated string containing all the slices in `parts`,
1212      *         joined with `self`.
1213      */
1214     function join(slice self, slice[] parts) internal returns (string) {
1215         if (parts.length == 0)
1216             return "";
1217 
1218         uint len = self._len * (parts.length - 1);
1219         for(uint i = 0; i < parts.length; i++)
1220             len += parts[i]._len;
1221 
1222         var ret = new string(len);
1223         uint retptr;
1224         assembly { retptr := add(ret, 32) }
1225 
1226         for(i = 0; i < parts.length; i++) {
1227             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1228             retptr += parts[i]._len;
1229             if (i < parts.length - 1) {
1230                 memcpy(retptr, self._ptr, self._len);
1231                 retptr += self._len;
1232             }
1233         }
1234 
1235         return ret;
1236     }
1237 }
1238 
1239 
1240 contract DSSafeAddSub {
1241     function safeToAdd(uint a, uint b) internal returns (bool) {
1242         return (a + b >= a);
1243     }
1244     function safeAdd(uint a, uint b) internal returns (uint) {
1245         if (!safeToAdd(a, b)) throw;
1246         return a + b;
1247     }
1248 
1249     function safeToSubtract(uint a, uint b) internal returns (bool) {
1250         return (b <= a);
1251     }
1252 
1253     function safeSub(uint a, uint b) internal returns (uint) {
1254         if (!safeToSubtract(a, b)) throw;
1255         return a - b;
1256     } 
1257 }
1258 
1259 
1260 
1261 contract Etheroll is usingOraclize, DSSafeAddSub {
1262     
1263      using strings for *;
1264 
1265     /*
1266      * checks player profit, bet size and player number is within range
1267     */
1268     modifier betIsValid(uint _betSize, uint _playerNumber) {      
1269         if(((((_betSize * (100-(safeSub(_playerNumber,1)))) / (safeSub(_playerNumber,1))+_betSize))*houseEdge/houseEdgeDivisor)-_betSize > maxProfit || _betSize < minBet || _playerNumber < minNumber || _playerNumber > maxNumber) throw;        
1270 		_;
1271     }
1272 
1273     /*
1274      * checks game is currently active
1275     */
1276     modifier gameIsActive {
1277         if(gamePaused == true) throw;
1278 		_;
1279     }    
1280 
1281     /*
1282      * checks payouts are currently active
1283     */
1284     modifier payoutsAreActive {
1285         if(payoutsPaused == true) throw;
1286 		_;
1287     }    
1288 
1289     /*
1290      * checks only Oraclize address is calling
1291     */
1292     modifier onlyOraclize {
1293         if (msg.sender != oraclize_cbAddress()) throw;
1294         _;
1295     }
1296 
1297     /*
1298      * checks only owner address is calling
1299     */
1300     modifier onlyOwner {
1301          if (msg.sender != owner) throw;
1302          _;
1303     }
1304 
1305     /*
1306      * checks only treasury address is calling
1307     */
1308     modifier onlyTreasury {
1309          if (msg.sender != treasury) throw;
1310          _;
1311     }    
1312 
1313     /*
1314      * game vars
1315     */ 
1316     uint constant public maxProfitDivisor = 1000000;
1317     uint constant public houseEdgeDivisor = 1000;    
1318     uint constant public maxNumber = 99; 
1319     uint constant public minNumber = 2;
1320 	bool public gamePaused;
1321     uint32 public gasForOraclize;
1322     address public owner;
1323     bool public payoutsPaused; 
1324     address public treasury;
1325     uint public contractBalance;
1326     uint public houseEdge;     
1327     uint public maxProfit;   
1328     uint public maxProfitAsPercentOfHouse;                    
1329     uint public minBet;       
1330     int public totalBets;
1331     uint public maxPendingPayouts;
1332     uint public costToCallOraclizeInWei;
1333     uint public totalWeiWon;
1334 
1335     /*
1336      * player vars
1337     */
1338     mapping (bytes32 => address) playerAddress;
1339     mapping (bytes32 => address) playerTempAddress;
1340     mapping (bytes32 => bytes32) playerBetId;
1341     mapping (bytes32 => uint) playerBetValue;
1342     mapping (bytes32 => uint) playerTempBetValue;  
1343     mapping (bytes32 => uint) playerRandomResult;     
1344     mapping (bytes32 => uint) playerDieResult;
1345     mapping (bytes32 => uint) playerNumber;
1346     mapping (address => uint) playerPendingWithdrawals;      
1347     mapping (bytes32 => uint) playerProfit;
1348     mapping (bytes32 => uint) playerTempReward;    
1349         
1350 
1351     /*
1352      * events
1353     */
1354     /* log bets + output to web3 for precise 'payout on win' field in UI */
1355     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RewardValue, uint ProfitValue, uint BetValue, uint PlayerNumber);      
1356     /* output to web3 UI on bet result*/
1357     /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
1358 	event LogResult(uint indexed ResultSerialNumber, bytes32 indexed BetID, address indexed PlayerAddress, uint PlayerNumber, uint DiceResult, uint Value, int Status, bytes Proof);   
1359     /* log manual refunds */
1360     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
1361     /* log owner transfers */
1362     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);               
1363 
1364 
1365     /*
1366      * init
1367     */
1368     function Etheroll() {
1369 
1370         owner = msg.sender;
1371         treasury = msg.sender;
1372         
1373         oraclize_setNetwork(networkID_auto);        
1374         /* use TLSNotary for oraclize call */
1375 		oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1376         /* init 990 = 99% (1% houseEdge)*/
1377         ownerSetHouseEdge(990);
1378         /* init 10,000 = 1%  */
1379         ownerSetMaxProfitAsPercentOfHouse(10000);
1380         /* init min bet (0.1 ether) */
1381         ownerSetMinBet(100000000000000000);        
1382         /* init gas for oraclize */        
1383         gasForOraclize = 250000;        
1384 
1385     }
1386 
1387     /*
1388      * public function
1389      * player submit bet
1390      * only if game is active & bet is valid can query oraclize and set player vars     
1391     */
1392     function playerRollDice(uint rollUnder) public 
1393         payable
1394         gameIsActive
1395         betIsValid(msg.value, rollUnder)
1396 	{        
1397         
1398         /*
1399         * assign partially encrypted query to oraclize
1400         * only the apiKey is encrypted 
1401         * integer query is in plain text
1402         */
1403         bytes32 rngId = oraclize_query("nested", "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BKjhlm6SfYJ79hWWmywPWdwaFHZCU9yBavQcnDLajf8Cbxo9W6z8KNnzmS+/0hmoNTnBRZxSgACLlIghH+Zm65EAhJCsE6q/W5YlR55o+HbGWyMEi0o5ngKy1MtUi49eg4HhelENzDMMEynC3eY6SeJeQNe4NsE=},\"n\":1,\"min\":1,\"max\":100,\"replacement\":true,\"base\":10${[identity] \"}\"},\"id\":1${[identity] \"}\"}']", gasForOraclize);
1404         
1405         /* safely update contract balance to account for cost to call oraclize*/
1406         contractBalance -= 57245901639344;	        
1407         /* total number of bets */
1408         totalBets += 1;
1409         /* map bet id to this oraclize query */
1410 		playerBetId[rngId] = rngId;
1411         /* map player lucky number to this oraclize query */
1412 		playerNumber[rngId] = rollUnder;
1413         /* map value of wager to this oraclize query */
1414         playerBetValue[rngId] = msg.value;
1415         /* map player address to this oraclize query */
1416         playerAddress[rngId] = msg.sender;
1417         /* safely map player profit to this oraclize query */                     
1418         playerProfit[rngId] = ((((msg.value * (100-(safeSub(rollUnder,1)))) / (safeSub(rollUnder,1))+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;        
1419         /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
1420         maxPendingPayouts = safeAdd(maxPendingPayouts, playerProfit[rngId]);
1421         /* check contract can payout on win */
1422         if(maxPendingPayouts >= contractBalance) throw;
1423         /* provides accurate numbers for web3 and allows for manual refunds in case of no oraclize __callback */
1424         LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);          
1425 
1426     }   
1427              
1428 
1429     /*
1430     * semi-public function - only oraclize can call
1431     */
1432     /*TLSNotary for oraclize call */
1433 	function __callback(bytes32 myid, string result, bytes proof) public   
1434 		onlyOraclize
1435 		payoutsAreActive
1436 	{  
1437 
1438         /* player address mapped to query id does not exist */
1439         if (playerAddress[myid]==0x0) throw;
1440         
1441         /* keep oraclize honest by retrieving the serialNumber from random.org result */
1442         var sl_result = result.toSlice();
1443         sl_result.beyond("[".toSlice()).until("]".toSlice());
1444         uint serialNumberOfResult = parseInt(sl_result.split(', '.toSlice()).toString());          
1445 
1446 	    /* map result to player */
1447         playerRandomResult[myid] = parseInt(sl_result.beyond("[".toSlice()).until("]".toSlice()).toString());
1448         
1449         /* produce integer bounded to 1-100 inclusive
1450         *  via sha3 result from random.org and proof (IPFS address of TLSNotary proof)
1451         */
1452         playerDieResult[myid] = uint(sha3(playerRandomResult[myid], proof)) % 100 + 1;
1453         
1454         /* get the playerAddress for this query id */
1455         playerTempAddress[myid] = playerAddress[myid];
1456         /* delete playerAddress for this query id */
1457         delete playerAddress[myid];
1458 
1459         /* map the playerProfit for this query id */
1460         playerTempReward[myid] = playerProfit[myid];
1461         /* set  playerProfit for this query id to 0 */
1462         playerProfit[myid] = 0; 
1463 
1464         /* safely reduce maxPendingPayouts liability */
1465         maxPendingPayouts = safeSub(maxPendingPayouts, playerTempReward[myid]);         
1466 
1467         /* map the playerBetValue for this query id */
1468         playerTempBetValue[myid] = playerBetValue[myid];
1469         /* set  playerBetValue for this query id to 0 */
1470         playerBetValue[myid] = 0;                                             
1471 
1472         /*
1473         * refund
1474         * if result from oraclize is 0 refund only the original bet value
1475         * if refund fails save refund value to playerPendingWithdrawals
1476         */
1477         if(playerDieResult[myid]==0){                                
1478 
1479              LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 3, proof);            
1480 
1481             /*
1482             * send refund - external call to an untrusted contract
1483             * if send fails map refund value to playerPendingWithdrawals[address]
1484             * for withdrawal later via playerWithdrawPendingTransactions
1485             */
1486             if(!playerTempAddress[myid].send(playerTempBetValue[myid])){
1487                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 4, proof);              
1488                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
1489                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempBetValue[myid]);                        
1490             }
1491 
1492             return;
1493         }
1494 
1495         /*
1496         * pay winner
1497         * update contract balance to calculate new max bet
1498         * send reward
1499         * if send of reward fails save value to playerPendingWithdrawals        
1500         */
1501         if(playerDieResult[myid] < playerNumber[myid]){ 
1502 
1503             /* safely reduce contract balance by player profit */
1504             contractBalance -= playerTempReward[myid]; 
1505 
1506             /* update total wei won */
1507             totalWeiWon = safeAdd(totalWeiWon, playerTempReward[myid]);              
1508 
1509             /* safely calculate payout via profit plus original wager */
1510             playerTempReward[myid] = safeAdd(playerTempReward[myid], playerTempBetValue[myid]); 
1511 
1512             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 1, proof);                            
1513 
1514             /* update maximum profit */
1515             setMaxProfit();
1516             
1517             /*
1518             * send win - external call to an untrusted contract
1519             * if send fails map reward value to playerPendingWithdrawals[address]
1520             * for withdrawal later via playerWithdrawPendingTransactions
1521             */
1522             if(!playerTempAddress[myid].send(playerTempReward[myid])){
1523                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 2, proof);                   
1524                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
1525                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempReward[myid]);                               
1526             }
1527 
1528             return;
1529 
1530         }
1531 
1532         /*
1533         * no win
1534         * send 1 wei to a losing bet
1535         * update contract balance to calculate new max bet
1536         */
1537         if(playerDieResult[myid] >= playerNumber[myid]){
1538 
1539             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 0, proof);                                
1540 
1541             /*  
1542             *  safe adjust contractBalance
1543             *  setMaxProfit
1544             *  send 1 wei to losing bet
1545             */
1546             contractBalance += playerTempBetValue[myid]-1;                                                                         
1547 
1548             /* update maximum profit */
1549             setMaxProfit(); 
1550 
1551             /*
1552             * send 1 wei - external call to an untrusted contract                  
1553             */
1554             if(!playerTempAddress[myid].send(1)){
1555                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */                
1556                playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], 1);                                
1557             }                                   
1558 
1559             return;
1560 
1561         }
1562 
1563     }
1564     
1565     /*
1566     * public function
1567     * in case of a failed refund or win send
1568     */
1569     function playerWithdrawPendingTransactions() public 
1570         payoutsAreActive
1571         returns (bool)
1572      {
1573         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
1574         playerPendingWithdrawals[msg.sender] = 0;
1575         /* external call to untrusted contract */
1576         if (msg.sender.call.value(withdrawAmount)()) {
1577             return true;
1578         } else {
1579             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
1580             /* player can try to withdraw again later */
1581             playerPendingWithdrawals[msg.sender] = withdrawAmount;
1582             return false;
1583         }
1584     }
1585 
1586     /* check for pending withdrawals  */
1587     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
1588         return playerPendingWithdrawals[addressToCheck];
1589     }
1590 
1591     /*
1592     * internal function
1593     * sets max profit
1594     */
1595     function setMaxProfit() internal {
1596         maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxProfitDivisor;  
1597     }   
1598 
1599     /*
1600     * owner/treasury address only functions
1601     */
1602     function ()
1603         payable
1604         onlyTreasury
1605     {
1606         /* safely update contract balance */
1607         contractBalance += msg.value;        
1608         /* update the maximum profit */
1609         setMaxProfit();
1610     } 
1611 
1612     /* set gas for oraclize query */
1613     function ownerSetOraclizeSafeGas(uint32 newSafeGasToOraclize) public 
1614 		onlyOwner
1615 	{
1616     	gasForOraclize = newSafeGasToOraclize;
1617     }
1618 
1619     /* set house cost to call oraclize query */
1620     function ownerUpdateCostToCallOraclize(uint newCostToCallOraclizeInWei) public 
1621 		onlyOwner
1622     {        
1623        costToCallOraclizeInWei = newCostToCallOraclizeInWei;
1624     }     
1625 
1626     /* only owner address can set houseEdge */
1627     function ownerSetHouseEdge(uint newHouseEdge) public 
1628 		onlyOwner
1629     {
1630         houseEdge = newHouseEdge;
1631     }
1632 
1633     /* only owner address can set maxProfitAsPercentOfHouse */
1634     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public 
1635 		onlyOwner
1636     {
1637         /* restrict each bet to a maximum profit of 1% contractBalance */
1638         if(newMaxProfitAsPercent > 10000) throw;
1639         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
1640         setMaxProfit();
1641     }
1642 
1643     /* only owner address can set minBet */
1644     function ownerSetMinBet(uint newMinimumBet) public 
1645 		onlyOwner
1646     {
1647         minBet = newMinimumBet;
1648     }       
1649 
1650     /* only owner address can transfer ether */
1651     function ownerTransferEther(address sendTo, uint amount) public 
1652 		onlyOwner
1653     {        
1654         /* safely update contract balance when sending out funds*/
1655         contractBalance -= amount;		
1656         /* update max profit */
1657         setMaxProfit();
1658         if(!sendTo.send(amount)) throw;
1659         LogOwnerTransfer(sendTo, amount); 
1660     }
1661 
1662     /* only owner address can do manual refund
1663     * used only if bet placed + oraclize failed to __callback
1664     * filter LogBet by address and/or playerBetId:
1665     * LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
1666     * check the following logs do not exist for playerBetId and/or playerAddress[rngId] before refunding:
1667     * LogResult or LogRefund
1668     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions 
1669     */
1670     function ownerRefundPlayer(bytes32 originalPlayerBetId, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public 
1671 		onlyOwner
1672     {        
1673         /* safely reduce pendingPayouts by playerProfit[rngId] */
1674         maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
1675         /* send refund */
1676         if(!sendTo.send(originalPlayerBetValue)) throw;
1677         /* log refunds */
1678         LogRefund(originalPlayerBetId, sendTo, originalPlayerBetValue);        
1679     }    
1680 
1681     /* only owner address can set emergency pause #1 */
1682     function ownerPauseGame(bool newStatus) public 
1683 		onlyOwner
1684     {
1685 		gamePaused = newStatus;
1686     }
1687 
1688     /* only owner address can set emergency pause #2 */
1689     function ownerPausePayouts(bool newPayoutStatus) public 
1690 		onlyOwner
1691     {
1692 		payoutsPaused = newPayoutStatus;
1693     } 
1694 
1695     /* only owner address can set treasury address */
1696     function ownerSetTreasury(address newTreasury) public 
1697 		onlyOwner
1698 	{
1699         treasury = newTreasury;
1700     }         
1701 
1702     /* only owner address can set owner address */
1703     function ownerChangeOwner(address newOwner) public 
1704 		onlyOwner
1705 	{
1706         owner = newOwner;
1707     }
1708 
1709     /* only owner address can suicide - emergency */
1710     function ownerkill() public 
1711 		onlyOwner
1712 	{
1713 		suicide(owner);
1714 	}    
1715 
1716 
1717 }