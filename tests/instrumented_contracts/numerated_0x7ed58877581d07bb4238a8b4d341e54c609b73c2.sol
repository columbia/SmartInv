1 pragma solidity ^0.4.10;
2 // <ORACLIZE_API>
3 /*
4 Copyright (c) 2015-2016 Oraclize SRL
5 Copyright (c) 2016 Oraclize LTD
6 
7 
8 
9 Permission is hereby granted, free of charge, to any person obtaining a copy
10 of this software and associated documentation files (the "Software"), to deal
11 in the Software without restriction, including without limitation the rights
12 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
13 copies of the Software, and to permit persons to whom the Software is
14 furnished to do so, subject to the following conditions:
15 
16 
17 
18 The above copyright notice and this permission notice shall be included in
19 all copies or substantial portions of the Software.
20 
21 
22 
23 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
24 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
25 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
26 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
27 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
28 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
29 THE SOFTWARE.
30 */
31 
32 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
33 
34 contract OraclizeI {
35     address public cbAddress;
36     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
37     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
38     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
39     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
40     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
41     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
42     function getPrice(string _datasource) returns (uint _dsprice);
43     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
44     function useCoupon(string _coupon);
45     function setProofType(byte _proofType);
46     function setConfig(bytes32 _config);
47     function setCustomGasPrice(uint _gasPrice);
48 }
49 contract OraclizeAddrResolverI {
50     function getAddress() returns (address _addr);
51 }
52 contract usingOraclize {
53     uint constant day = 60*60*24;
54     uint constant week = 60*60*24*7;
55     uint constant month = 60*60*24*30;
56     byte constant proofType_NONE = 0x00;
57     byte constant proofType_TLSNotary = 0x10;
58     byte constant proofStorage_IPFS = 0x01;
59     uint8 constant networkID_auto = 0;
60     uint8 constant networkID_mainnet = 1;
61     uint8 constant networkID_testnet = 2;
62     uint8 constant networkID_morden = 2;
63     uint8 constant networkID_consensys = 161;
64 
65     OraclizeAddrResolverI OAR;
66 
67     OraclizeI oraclize;
68     modifier oraclizeAPI {
69         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
70         oraclize = OraclizeI(OAR.getAddress());
71         _;
72     }
73     modifier coupon(string code){
74         oraclize = OraclizeI(OAR.getAddress());
75         oraclize.useCoupon(code);
76         _;
77     }
78 
79     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
80         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
81             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
82             return true;
83         }
84         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
85             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
86             return true;
87         }
88         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
89             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
90             return true;
91         }
92         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
93             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
94             return true;
95         }
96         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
97             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
98             return true;
99         }
100         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
101             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
102             return true;
103         }
104         return false;
105     }
106 
107     function __callback(bytes32 myid, string result) {
108         __callback(myid, result, new bytes(0));
109     }
110     function __callback(bytes32 myid, string result, bytes proof) {
111     }
112 
113     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
114         return oraclize.getPrice(datasource);
115     }
116 
117     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
118         return oraclize.getPrice(datasource, gaslimit);
119     }
120     
121     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
122         uint price = oraclize.getPrice(datasource);
123         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
124         return oraclize.query.value(price)(0, datasource, arg);
125     }
126     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
127         uint price = oraclize.getPrice(datasource);
128         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
129         return oraclize.query.value(price)(timestamp, datasource, arg);
130     }
131     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
132         uint price = oraclize.getPrice(datasource, gaslimit);
133         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
134         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
135     }
136     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
137         uint price = oraclize.getPrice(datasource, gaslimit);
138         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
139         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
140     }
141     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
142         uint price = oraclize.getPrice(datasource);
143         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
144         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
145     }
146     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
147         uint price = oraclize.getPrice(datasource);
148         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
149         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
150     }
151     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
152         uint price = oraclize.getPrice(datasource, gaslimit);
153         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
154         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
155     }
156     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
157         uint price = oraclize.getPrice(datasource, gaslimit);
158         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
159         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
160     }
161     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
162         uint price = oraclize.getPrice(datasource);
163         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
164         bytes memory args = stra2cbor(argN);
165         return oraclize.queryN.value(price)(0, datasource, args);
166     }
167     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
168         uint price = oraclize.getPrice(datasource);
169         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
170         bytes memory args = stra2cbor(argN);
171         return oraclize.queryN.value(price)(timestamp, datasource, args);
172     }
173     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
174         uint price = oraclize.getPrice(datasource, gaslimit);
175         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
176         bytes memory args = stra2cbor(argN);
177         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
178     }
179     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
180         uint price = oraclize.getPrice(datasource, gaslimit);
181         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
182         bytes memory args = stra2cbor(argN);
183         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
184     }
185     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
186         string[] memory dynargs = new string[](1);
187         dynargs[0] = args[0];
188         return oraclize_query(datasource, dynargs);
189     }
190     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
191         string[] memory dynargs = new string[](1);
192         dynargs[0] = args[0];
193         return oraclize_query(timestamp, datasource, dynargs);
194     }
195     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
196         string[] memory dynargs = new string[](1);
197         dynargs[0] = args[0];
198         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
199     }
200     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
201         string[] memory dynargs = new string[](1);
202         dynargs[0] = args[0];       
203         return oraclize_query(datasource, dynargs, gaslimit);
204     }
205     
206     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
207         string[] memory dynargs = new string[](2);
208         dynargs[0] = args[0];
209         dynargs[1] = args[1];
210         return oraclize_query(datasource, dynargs);
211     }
212     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
213         string[] memory dynargs = new string[](2);
214         dynargs[0] = args[0];
215         dynargs[1] = args[1];
216         return oraclize_query(timestamp, datasource, dynargs);
217     }
218     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
219         string[] memory dynargs = new string[](2);
220         dynargs[0] = args[0];
221         dynargs[1] = args[1];
222         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
223     }
224     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
225         string[] memory dynargs = new string[](2);
226         dynargs[0] = args[0];
227         dynargs[1] = args[1];
228         return oraclize_query(datasource, dynargs, gaslimit);
229     }
230     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
231         string[] memory dynargs = new string[](3);
232         dynargs[0] = args[0];
233         dynargs[1] = args[1];
234         dynargs[2] = args[2];
235         return oraclize_query(datasource, dynargs);
236     }
237     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
238         string[] memory dynargs = new string[](3);
239         dynargs[0] = args[0];
240         dynargs[1] = args[1];
241         dynargs[2] = args[2];
242         return oraclize_query(timestamp, datasource, dynargs);
243     }
244     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
245         string[] memory dynargs = new string[](3);
246         dynargs[0] = args[0];
247         dynargs[1] = args[1];
248         dynargs[2] = args[2];
249         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
250     }
251     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
252         string[] memory dynargs = new string[](3);
253         dynargs[0] = args[0];
254         dynargs[1] = args[1];
255         dynargs[2] = args[2];
256         return oraclize_query(datasource, dynargs, gaslimit);
257     }
258     
259     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
260         string[] memory dynargs = new string[](4);
261         dynargs[0] = args[0];
262         dynargs[1] = args[1];
263         dynargs[2] = args[2];
264         dynargs[3] = args[3];
265         return oraclize_query(datasource, dynargs);
266     }
267     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
268         string[] memory dynargs = new string[](4);
269         dynargs[0] = args[0];
270         dynargs[1] = args[1];
271         dynargs[2] = args[2];
272         dynargs[3] = args[3];
273         return oraclize_query(timestamp, datasource, dynargs);
274     }
275     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
276         string[] memory dynargs = new string[](4);
277         dynargs[0] = args[0];
278         dynargs[1] = args[1];
279         dynargs[2] = args[2];
280         dynargs[3] = args[3];
281         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
282     }
283     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
284         string[] memory dynargs = new string[](4);
285         dynargs[0] = args[0];
286         dynargs[1] = args[1];
287         dynargs[2] = args[2];
288         dynargs[3] = args[3];
289         return oraclize_query(datasource, dynargs, gaslimit);
290     }
291     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
292         string[] memory dynargs = new string[](5);
293         dynargs[0] = args[0];
294         dynargs[1] = args[1];
295         dynargs[2] = args[2];
296         dynargs[3] = args[3];
297         dynargs[4] = args[4];
298         return oraclize_query(datasource, dynargs);
299     }
300     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
301         string[] memory dynargs = new string[](5);
302         dynargs[0] = args[0];
303         dynargs[1] = args[1];
304         dynargs[2] = args[2];
305         dynargs[3] = args[3];
306         dynargs[4] = args[4];
307         return oraclize_query(timestamp, datasource, dynargs);
308     }
309     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
310         string[] memory dynargs = new string[](5);
311         dynargs[0] = args[0];
312         dynargs[1] = args[1];
313         dynargs[2] = args[2];
314         dynargs[3] = args[3];
315         dynargs[4] = args[4];
316         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
317     }
318     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
319         string[] memory dynargs = new string[](5);
320         dynargs[0] = args[0];
321         dynargs[1] = args[1];
322         dynargs[2] = args[2];
323         dynargs[3] = args[3];
324         dynargs[4] = args[4];
325         return oraclize_query(datasource, dynargs, gaslimit);
326     }
327 
328     function oraclize_cbAddress() oraclizeAPI internal returns (address){
329         return oraclize.cbAddress();
330     }
331     function oraclize_setProof(byte proofP) oraclizeAPI internal {
332         return oraclize.setProofType(proofP);
333     }
334     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
335         return oraclize.setCustomGasPrice(gasPrice);
336     }
337     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
338         return oraclize.setConfig(config);
339     }
340 
341     function getCodeSize(address _addr) constant internal returns(uint _size) {
342         assembly {
343             _size := extcodesize(_addr)
344         }
345     }
346 
347     function parseAddr(string _a) internal returns (address){
348         bytes memory tmp = bytes(_a);
349         uint160 iaddr = 0;
350         uint160 b1;
351         uint160 b2;
352         for (uint i=2; i<2+2*20; i+=2){
353             iaddr *= 256;
354             b1 = uint160(tmp[i]);
355             b2 = uint160(tmp[i+1]);
356             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
357             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
358             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
359             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
360             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
361             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
362             iaddr += (b1*16+b2);
363         }
364         return address(iaddr);
365     }
366 
367     function strCompare(string _a, string _b) internal returns (int) {
368         bytes memory a = bytes(_a);
369         bytes memory b = bytes(_b);
370         uint minLength = a.length;
371         if (b.length < minLength) minLength = b.length;
372         for (uint i = 0; i < minLength; i ++)
373             if (a[i] < b[i])
374                 return -1;
375             else if (a[i] > b[i])
376                 return 1;
377         if (a.length < b.length)
378             return -1;
379         else if (a.length > b.length)
380             return 1;
381         else
382             return 0;
383     }
384 
385     function indexOf(string _haystack, string _needle) internal returns (int) {
386         bytes memory h = bytes(_haystack);
387         bytes memory n = bytes(_needle);
388         if(h.length < 1 || n.length < 1 || (n.length > h.length))
389             return -1;
390         else if(h.length > (2**128 -1))
391             return -1;
392         else
393         {
394             uint subindex = 0;
395             for (uint i = 0; i < h.length; i ++)
396             {
397                 if (h[i] == n[0])
398                 {
399                     subindex = 1;
400                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
401                     {
402                         subindex++;
403                     }
404                     if(subindex == n.length)
405                         return int(i);
406                 }
407             }
408             return -1;
409         }
410     }
411 
412     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
413         bytes memory _ba = bytes(_a);
414         bytes memory _bb = bytes(_b);
415         bytes memory _bc = bytes(_c);
416         bytes memory _bd = bytes(_d);
417         bytes memory _be = bytes(_e);
418         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
419         bytes memory babcde = bytes(abcde);
420         uint k = 0;
421         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
422         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
423         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
424         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
425         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
426         return string(babcde);
427     }
428 
429     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
430         return strConcat(_a, _b, _c, _d, "");
431     }
432 
433     function strConcat(string _a, string _b, string _c) internal returns (string) {
434         return strConcat(_a, _b, _c, "", "");
435     }
436 
437     function strConcat(string _a, string _b) internal returns (string) {
438         return strConcat(_a, _b, "", "", "");
439     }
440 
441     // parseInt
442     function parseInt(string _a) internal returns (uint) {
443         return parseInt(_a, 0);
444     }
445 
446     // parseInt(parseFloat*10^_b)
447     function parseInt(string _a, uint _b) internal returns (uint) {
448         bytes memory bresult = bytes(_a);
449         uint mint = 0;
450         bool decimals = false;
451         for (uint i=0; i<bresult.length; i++){
452             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
453                 if (decimals){
454                    if (_b == 0) break;
455                     else _b--;
456                 }
457                 mint *= 10;
458                 mint += uint(bresult[i]) - 48;
459             } else if (bresult[i] == 46) decimals = true;
460         }
461         if (_b > 0) mint *= 10**_b;
462         return mint;
463     }
464 
465     function uint2str(uint i) internal returns (string){
466         if (i == 0) return "0";
467         uint j = i;
468         uint len;
469         while (j != 0){
470             len++;
471             j /= 10;
472         }
473         bytes memory bstr = new bytes(len);
474         uint k = len - 1;
475         while (i != 0){
476             bstr[k--] = byte(48 + i % 10);
477             i /= 10;
478         }
479         return string(bstr);
480     }
481 
482     function stra2cbor(string[] arr) internal returns (bytes) {
483             uint arrlen = arr.length;
484 
485             // get correct cbor output length
486             uint outputlen = 0;
487             bytes[] memory elemArray = new bytes[](arrlen);
488             for (uint i = 0; i < arrlen; i++) {
489                 elemArray[i] = (bytes(arr[i]));
490                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
491             }
492             uint ctr = 0;
493             uint cborlen = arrlen + 0x80;
494             outputlen += byte(cborlen).length;
495             bytes memory res = new bytes(outputlen);
496 
497             while (byte(cborlen).length > ctr) {
498                 res[ctr] = byte(cborlen)[ctr];
499                 ctr++;
500             }
501             for (i = 0; i < arrlen; i++) {
502                 res[ctr] = 0x5F;
503                 ctr++;
504                 for (uint x = 0; x < elemArray[i].length; x++) {
505                     // if there's a bug with larger strings, this may be the culprit
506                     if (x % 23 == 0) {
507                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
508                         elemcborlen += 0x40;
509                         uint lctr = ctr;
510                         while (byte(elemcborlen).length > ctr - lctr) {
511                             res[ctr] = byte(elemcborlen)[ctr - lctr];
512                             ctr++;
513                         }
514                     }
515                     res[ctr] = elemArray[i][x];
516                     ctr++;
517                 }
518                 res[ctr] = 0xFF;
519                 ctr++;
520             }
521             return res;
522         }
523 }
524 // </ORACLIZE_API>
525 
526 // TokenBase - ERC20 token standart
527 contract TokenBase
528 {
529     string public name;
530     string public symbol;
531     uint8 public decimals;
532     
533 	uint256 internal currentSupply;
534 
535 	mapping(address => uint) public balanceOf;
536 	event Transfer(address indexed from, address indexed to, uint256 value);
537 	
538 	function totalSupply() constant returns (uint256)
539 	{
540 	    return currentSupply;
541 	}
542 	
543 	function transfer(address to, uint amount) returns (bool)
544 	{
545 		if (balanceOf[msg.sender] < amount) throw;           
546 		if (balanceOf[to] + amount < balanceOf[to]) throw;
547 		
548 		balanceOf[msg.sender] -= amount;
549 		balanceOf[to] += amount;
550 		Transfer(msg.sender, to, amount);
551 		return true;
552 	}
553 }
554 
555 // Face Token (FACE) - contract code for proof of Facebook token
556 contract FaceToken is TokenBase, usingOraclize
557 {
558 	mapping (address => Member) public members; // people who send proof request to the contract
559 	mapping (bytes32 => Member) private approved_members; // people received proof face from the dacebook
560 	mapping (bytes32 => address) private awaiting_oraclize; // requests sended to facebook using oraclize query
561 
562     uint public constant maxSupply = 10000000 ether; // max supply of FACE tokens
563     uint public constant startSpreadingBlock = 3510000; // block from which contract accepts proof requests
564 
565 	uint[] private rewards = [100 ether, 50 ether, 25 ether, 12.5 ether, 6.25 ether, 3.125 ether]; // FACE rewards structure
566     bool private spreading = true; // variable will be set to false when the number of tokens is reached max supply
567 
568     // structure with information about user who requested proof of facebook, his referrer and referrals
569 	struct Member
570 	{
571 		address addr;
572 		address referrer;
573 		bool approved;
574 		bytes32 id;
575 		mapping(uint => uint) referrals_count;
576 	}
577 	
578     // contract constructor. sets token name to FACE, and first contract member
579 	function FaceToken()
580 	{
581         oraclize_setProof(proofType_NONE);
582 		name = 'FACE';
583 		symbol = 'FACE';
584 		decimals = 18;
585 		currentSupply = 0;
586 		members[msg.sender] = Member(msg.sender, 0, true, 0x0);
587 	}
588 	
589     // throw if spreading not starts or finished
590     modifier in_spreading_state()
591     {
592         if (!spreading || block.number < startSpreadingBlock)
593             throw;
594         _;
595     }
596     
597     // throw if member already requested facebook proof
598     modifier new_member()
599     {
600         if (members[msg.sender].addr != 0)
601             throw;
602         _;
603     }
604     
605     // throw if members referrer not registered or not approved
606     modifier referrer_valid(address referrer)
607     {
608         if (members[referrer].addr == 0 || !members[referrer].approved)
609             throw;
610         _;
611     }
612     
613     // throw if member send low amount of ether with proof request. ETH needed to cover oraclize feee, and gas in oraclize callback function
614     modifier fee_valid()
615     {
616         if (msg.value < getTransactionPrice())
617             throw;
618         _;
619     }
620 	
621     // main function to request proof of face and get FACE tokens
622 	function request_face_proof(string facebook_user_access_token, address referrer) in_spreading_state new_member referrer_valid(referrer) fee_valid payable
623 	{
624         // if (!spreading || block.number < startSpreadingBlock || members[msg.sender].addr != 0 || members[referrer].addr == 0 || members[referrer].approved == false || msg.value < getTransactionPrice(gas_limit)) throw;
625         members[msg.sender] = Member(msg.sender, referrer, false, 0x0);
626         awaiting_oraclize[oraclize_query(0, "URL", strConcat("json(https://graph.facebook.com/me?fields=id&access_token=", facebook_user_access_token, ").id"), 500000)] = msg.sender;
627 	}
628 	
629 
630     // feature that allows the not approved user to send a proof request again in case of force majeure
631     function cancel_face_proof_request()
632     {
633         if (members[msg.sender].addr == 0 || members[msg.sender].approved == true) 
634             throw;
635         delete members[msg.sender];
636     }
637 
638     // oraclize callback function, returns users Facebook id, and add tokens to user and it referrers if face approved
639     function __callback(bytes32 myid, string result) {
640         if (msg.sender != oraclize_cbAddress()) throw;
641         bytes32 facebook_id = convert(result);
642         address member_address = awaiting_oraclize[myid];
643         delete awaiting_oraclize[myid];
644 
645         if (strCompare(result, '') == 0 || approved_members[facebook_id].addr != 0)
646         {
647             delete members[member_address];
648         }
649         else if (members[member_address].addr != 0)
650         {
651             members[member_address].approved = true;
652             members[member_address].id = facebook_id;
653             approved_members[facebook_id] = members[member_address];
654             register_recurcively(approved_members[facebook_id], 0);
655         }
656     }
657 	
658     // private function, called by contract when users face approved
659 	function register_recurcively(Member storage member, uint level) private
660 	{
661 	    uint amount = rewards[level]; // get tokens amount accordingly to rewards
662 
663 	    if (currentSupply + amount >= maxSupply) // correct amount of tokens and close spreading if total supply of tokens equal max supply
664 	    {
665 	        amount = maxSupply - currentSupply;
666             spreading = false;
667   	    }
668         
669 	    create_token(member, amount); // correct amount of tokens and close spreading if total supply of tokens equal max supply
670 	    if (level != 0) 
671 	        member.referrals_count[level] += 1;
672 	        
673 		level += 1;
674 
675 		if (level < rewards.length && member.referrer != 0 && spreading == true) // add tokens to member referrer
676 		{
677 			register_recurcively(members[member.referrer], level);
678 		}
679 	}
680 
681     // function which charges users balance
682 	function create_token(Member member, uint amount) private
683 	{
684 		balanceOf[member.addr] += amount;
685 		currentSupply += amount;
686 		Transfer(0, member.addr, amount);
687 	}
688 	
689     // technical function to convert string to bytes32
690     function convert(string key) private returns (bytes32 ret) {
691         if (bytes(key).length > 32) {
692           throw;
693         }
694     
695         assembly {
696           ret := mload(add(key, 32))
697         }
698     }
699     
700     // returns amount of ether required by oraclize for proof request transaction
701     function getTransactionPrice() constant returns (uint256)
702     {
703         return oraclize.getPrice("URL", 500000);
704     }
705     
706     // returns spreading state
707     function isOpened() constant returns (bool)
708     {
709         return spreading;
710     }
711     
712     // returns referrals count by line and user address
713     function level_referrals_count_by_address(address addr, uint level) constant returns(uint)
714     {
715         return members[addr].referrals_count[level];
716     }
717     
718     // returns all referrals count by user address
719     function all_referrals_count_by_address(address addr) constant returns(uint count)
720     {
721         for (var i=0; i<rewards.length-1; i++)
722             count += members[addr].referrals_count[i+1];
723     }
724 }