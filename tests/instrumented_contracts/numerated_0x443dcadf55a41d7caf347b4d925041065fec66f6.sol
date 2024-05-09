1 contract mortal {
2     /* Define variable owner of the type address*/
3     address owner;
4 
5     /* this function is executed at initialization and sets the owner of the contract */
6     function mortal() { owner = msg.sender; }
7 
8     /* Function to recover the funds on the contract */
9     function kill() { if (msg.sender == owner) selfdestruct(owner); }
10 }
11 
12 // <ORACLIZE_API>
13 /*
14 Copyright (c) 2015-2016 Oraclize SRL
15 Copyright (c) 2016 Oraclize LTD
16 
17 
18 
19 Permission is hereby granted, free of charge, to any person obtaining a copy
20 of this software and associated documentation files (the "Software"), to deal
21 in the Software without restriction, including without limitation the rights
22 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
23 copies of the Software, and to permit persons to whom the Software is
24 furnished to do so, subject to the following conditions:
25 
26 
27 
28 The above copyright notice and this permission notice shall be included in
29 all copies or substantial portions of the Software.
30 
31 
32 
33 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
34 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
35 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
36 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
37 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
38 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
39 THE SOFTWARE.
40 */
41 
42 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
43 
44 contract OraclizeI {
45     address public cbAddress;
46     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
47     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
48     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
49     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
50     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
51     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
52     function getPrice(string _datasource) returns (uint _dsprice);
53     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
54     function useCoupon(string _coupon);
55     function setProofType(byte _proofType);
56     function setConfig(bytes32 _config);
57     function setCustomGasPrice(uint _gasPrice);
58 }
59 contract OraclizeAddrResolverI {
60     function getAddress() returns (address _addr);
61 }
62 contract usingOraclize {
63     uint constant day = 60*60*24;
64     uint constant week = 60*60*24*7;
65     uint constant month = 60*60*24*30;
66     byte constant proofType_NONE = 0x00;
67     byte constant proofType_TLSNotary = 0x10;
68     byte constant proofStorage_IPFS = 0x01;
69     uint8 constant networkID_auto = 0;
70     uint8 constant networkID_mainnet = 1;
71     uint8 constant networkID_testnet = 2;
72     uint8 constant networkID_morden = 2;
73     uint8 constant networkID_consensys = 161;
74 
75     OraclizeAddrResolverI OAR;
76 
77     OraclizeI oraclize;
78     modifier oraclizeAPI {
79         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
80         oraclize = OraclizeI(OAR.getAddress());
81         _;
82     }
83     modifier coupon(string code){
84         oraclize = OraclizeI(OAR.getAddress());
85         oraclize.useCoupon(code);
86         _;
87     }
88 
89     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
90         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
91             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
92             return true;
93         }
94         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
95             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
96             return true;
97         }
98         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
99             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
100             return true;
101         }
102         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
103             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
104             return true;
105         }
106         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
107             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
108             return true;
109         }
110         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
111             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
112             return true;
113         }
114         return false;
115     }
116 
117     function __callback(bytes32 myid, string result) {
118         __callback(myid, result, new bytes(0));
119     }
120     function __callback(bytes32 myid, string result, bytes proof) {
121     }
122 
123     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
124         return oraclize.getPrice(datasource);
125     }
126 
127     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
128         return oraclize.getPrice(datasource, gaslimit);
129     }
130     
131     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
132         uint price = oraclize.getPrice(datasource);
133         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
134         return oraclize.query.value(price)(0, datasource, arg);
135     }
136     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
137         uint price = oraclize.getPrice(datasource);
138         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
139         return oraclize.query.value(price)(timestamp, datasource, arg);
140     }
141     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
142         uint price = oraclize.getPrice(datasource, gaslimit);
143         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
144         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
145     }
146     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
147         uint price = oraclize.getPrice(datasource, gaslimit);
148         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
149         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
150     }
151     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
152         uint price = oraclize.getPrice(datasource);
153         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
154         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
155     }
156     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
157         uint price = oraclize.getPrice(datasource);
158         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
159         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
160     }
161     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
162         uint price = oraclize.getPrice(datasource, gaslimit);
163         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
164         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
165     }
166     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
167         uint price = oraclize.getPrice(datasource, gaslimit);
168         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
169         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
170     }
171     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
172         uint price = oraclize.getPrice(datasource);
173         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
174         bytes memory args = stra2cbor(argN);
175         return oraclize.queryN.value(price)(0, datasource, args);
176     }
177     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
178         uint price = oraclize.getPrice(datasource);
179         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
180         bytes memory args = stra2cbor(argN);
181         return oraclize.queryN.value(price)(timestamp, datasource, args);
182     }
183     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
184         uint price = oraclize.getPrice(datasource, gaslimit);
185         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
186         bytes memory args = stra2cbor(argN);
187         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
188     }
189     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
190         uint price = oraclize.getPrice(datasource, gaslimit);
191         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
192         bytes memory args = stra2cbor(argN);
193         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
194     }
195     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
196         string[] memory dynargs = new string[](1);
197         dynargs[0] = args[0];
198         return oraclize_query(datasource, dynargs);
199     }
200     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
201         string[] memory dynargs = new string[](1);
202         dynargs[0] = args[0];
203         return oraclize_query(timestamp, datasource, dynargs);
204     }
205     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
206         string[] memory dynargs = new string[](1);
207         dynargs[0] = args[0];
208         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
209     }
210     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
211         string[] memory dynargs = new string[](1);
212         dynargs[0] = args[0];       
213         return oraclize_query(datasource, dynargs, gaslimit);
214     }
215     
216     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
217         string[] memory dynargs = new string[](2);
218         dynargs[0] = args[0];
219         dynargs[1] = args[1];
220         return oraclize_query(datasource, dynargs);
221     }
222     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
223         string[] memory dynargs = new string[](2);
224         dynargs[0] = args[0];
225         dynargs[1] = args[1];
226         return oraclize_query(timestamp, datasource, dynargs);
227     }
228     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
229         string[] memory dynargs = new string[](2);
230         dynargs[0] = args[0];
231         dynargs[1] = args[1];
232         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
233     }
234     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
235         string[] memory dynargs = new string[](2);
236         dynargs[0] = args[0];
237         dynargs[1] = args[1];
238         return oraclize_query(datasource, dynargs, gaslimit);
239     }
240     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
241         string[] memory dynargs = new string[](3);
242         dynargs[0] = args[0];
243         dynargs[1] = args[1];
244         dynargs[2] = args[2];
245         return oraclize_query(datasource, dynargs);
246     }
247     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
248         string[] memory dynargs = new string[](3);
249         dynargs[0] = args[0];
250         dynargs[1] = args[1];
251         dynargs[2] = args[2];
252         return oraclize_query(timestamp, datasource, dynargs);
253     }
254     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
255         string[] memory dynargs = new string[](3);
256         dynargs[0] = args[0];
257         dynargs[1] = args[1];
258         dynargs[2] = args[2];
259         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
260     }
261     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
262         string[] memory dynargs = new string[](3);
263         dynargs[0] = args[0];
264         dynargs[1] = args[1];
265         dynargs[2] = args[2];
266         return oraclize_query(datasource, dynargs, gaslimit);
267     }
268     
269     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
270         string[] memory dynargs = new string[](4);
271         dynargs[0] = args[0];
272         dynargs[1] = args[1];
273         dynargs[2] = args[2];
274         dynargs[3] = args[3];
275         return oraclize_query(datasource, dynargs);
276     }
277     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
278         string[] memory dynargs = new string[](4);
279         dynargs[0] = args[0];
280         dynargs[1] = args[1];
281         dynargs[2] = args[2];
282         dynargs[3] = args[3];
283         return oraclize_query(timestamp, datasource, dynargs);
284     }
285     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
286         string[] memory dynargs = new string[](4);
287         dynargs[0] = args[0];
288         dynargs[1] = args[1];
289         dynargs[2] = args[2];
290         dynargs[3] = args[3];
291         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
292     }
293     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
294         string[] memory dynargs = new string[](4);
295         dynargs[0] = args[0];
296         dynargs[1] = args[1];
297         dynargs[2] = args[2];
298         dynargs[3] = args[3];
299         return oraclize_query(datasource, dynargs, gaslimit);
300     }
301     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
302         string[] memory dynargs = new string[](5);
303         dynargs[0] = args[0];
304         dynargs[1] = args[1];
305         dynargs[2] = args[2];
306         dynargs[3] = args[3];
307         dynargs[4] = args[4];
308         return oraclize_query(datasource, dynargs);
309     }
310     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
311         string[] memory dynargs = new string[](5);
312         dynargs[0] = args[0];
313         dynargs[1] = args[1];
314         dynargs[2] = args[2];
315         dynargs[3] = args[3];
316         dynargs[4] = args[4];
317         return oraclize_query(timestamp, datasource, dynargs);
318     }
319     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
320         string[] memory dynargs = new string[](5);
321         dynargs[0] = args[0];
322         dynargs[1] = args[1];
323         dynargs[2] = args[2];
324         dynargs[3] = args[3];
325         dynargs[4] = args[4];
326         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
327     }
328     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
329         string[] memory dynargs = new string[](5);
330         dynargs[0] = args[0];
331         dynargs[1] = args[1];
332         dynargs[2] = args[2];
333         dynargs[3] = args[3];
334         dynargs[4] = args[4];
335         return oraclize_query(datasource, dynargs, gaslimit);
336     }
337 
338     function oraclize_cbAddress() oraclizeAPI internal returns (address){
339         return oraclize.cbAddress();
340     }
341     function oraclize_setProof(byte proofP) oraclizeAPI internal {
342         return oraclize.setProofType(proofP);
343     }
344     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
345         return oraclize.setCustomGasPrice(gasPrice);
346     }
347     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
348         return oraclize.setConfig(config);
349     }
350 
351     function getCodeSize(address _addr) constant internal returns(uint _size) {
352         assembly {
353             _size := extcodesize(_addr)
354         }
355     }
356 
357     function parseAddr(string _a) internal returns (address){
358         bytes memory tmp = bytes(_a);
359         uint160 iaddr = 0;
360         uint160 b1;
361         uint160 b2;
362         for (uint i=2; i<2+2*20; i+=2){
363             iaddr *= 256;
364             b1 = uint160(tmp[i]);
365             b2 = uint160(tmp[i+1]);
366             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
367             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
368             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
369             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
370             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
371             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
372             iaddr += (b1*16+b2);
373         }
374         return address(iaddr);
375     }
376 
377     function strCompare(string _a, string _b) internal returns (int) {
378         bytes memory a = bytes(_a);
379         bytes memory b = bytes(_b);
380         uint minLength = a.length;
381         if (b.length < minLength) minLength = b.length;
382         for (uint i = 0; i < minLength; i ++)
383             if (a[i] < b[i])
384                 return -1;
385             else if (a[i] > b[i])
386                 return 1;
387         if (a.length < b.length)
388             return -1;
389         else if (a.length > b.length)
390             return 1;
391         else
392             return 0;
393     }
394 
395     function indexOf(string _haystack, string _needle) internal returns (int) {
396         bytes memory h = bytes(_haystack);
397         bytes memory n = bytes(_needle);
398         if(h.length < 1 || n.length < 1 || (n.length > h.length))
399             return -1;
400         else if(h.length > (2**128 -1))
401             return -1;
402         else
403         {
404             uint subindex = 0;
405             for (uint i = 0; i < h.length; i ++)
406             {
407                 if (h[i] == n[0])
408                 {
409                     subindex = 1;
410                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
411                     {
412                         subindex++;
413                     }
414                     if(subindex == n.length)
415                         return int(i);
416                 }
417             }
418             return -1;
419         }
420     }
421 
422     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
423         bytes memory _ba = bytes(_a);
424         bytes memory _bb = bytes(_b);
425         bytes memory _bc = bytes(_c);
426         bytes memory _bd = bytes(_d);
427         bytes memory _be = bytes(_e);
428         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
429         bytes memory babcde = bytes(abcde);
430         uint k = 0;
431         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
432         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
433         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
434         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
435         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
436         return string(babcde);
437     }
438 
439     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
440         return strConcat(_a, _b, _c, _d, "");
441     }
442 
443     function strConcat(string _a, string _b, string _c) internal returns (string) {
444         return strConcat(_a, _b, _c, "", "");
445     }
446 
447     function strConcat(string _a, string _b) internal returns (string) {
448         return strConcat(_a, _b, "", "", "");
449     }
450 
451     // parseInt
452     function parseInt(string _a) internal returns (uint) {
453         return parseInt(_a, 0);
454     }
455 
456     // parseInt(parseFloat*10^_b)
457     function parseInt(string _a, uint _b) internal returns (uint) {
458         bytes memory bresult = bytes(_a);
459         uint mint = 0;
460         bool decimals = false;
461         for (uint i=0; i<bresult.length; i++){
462             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
463                 if (decimals){
464                    if (_b == 0) break;
465                     else _b--;
466                 }
467                 mint *= 10;
468                 mint += uint(bresult[i]) - 48;
469             } else if (bresult[i] == 46) decimals = true;
470         }
471         if (_b > 0) mint *= 10**_b;
472         return mint;
473     }
474 
475     function uint2str(uint i) internal returns (string){
476         if (i == 0) return "0";
477         uint j = i;
478         uint len;
479         while (j != 0){
480             len++;
481             j /= 10;
482         }
483         bytes memory bstr = new bytes(len);
484         uint k = len - 1;
485         while (i != 0){
486             bstr[k--] = byte(48 + i % 10);
487             i /= 10;
488         }
489         return string(bstr);
490     }
491 
492     function stra2cbor(string[] arr) internal returns (bytes) {
493             uint arrlen = arr.length;
494 
495             // get correct cbor output length
496             uint outputlen = 0;
497             bytes[] memory elemArray = new bytes[](arrlen);
498             for (uint i = 0; i < arrlen; i++) {
499                 elemArray[i] = (bytes(arr[i]));
500                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
501             }
502             uint ctr = 0;
503             uint cborlen = arrlen + 0x80;
504             outputlen += byte(cborlen).length;
505             bytes memory res = new bytes(outputlen);
506 
507             while (byte(cborlen).length > ctr) {
508                 res[ctr] = byte(cborlen)[ctr];
509                 ctr++;
510             }
511             for (i = 0; i < arrlen; i++) {
512                 res[ctr] = 0x5F;
513                 ctr++;
514                 for (uint x = 0; x < elemArray[i].length; x++) {
515                     // if there's a bug with larger strings, this may be the culprit
516                     if (x % 23 == 0) {
517                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
518                         elemcborlen += 0x40;
519                         uint lctr = ctr;
520                         while (byte(elemcborlen).length > ctr - lctr) {
521                             res[ctr] = byte(elemcborlen)[ctr - lctr];
522                             ctr++;
523                         }
524                     }
525                     res[ctr] = elemArray[i][x];
526                     ctr++;
527                 }
528                 res[ctr] = 0xFF;
529                 ctr++;
530             }
531             return res;
532         }
533 }
534 // </ORACLIZE_API> 
535 
536 contract GitHubBounty is usingOraclize, mortal {
537     
538     enum QueryType { IssueState, IssueAssignee, UserAddress }
539     
540     struct Bounty {
541         string issueUrl;
542         uint prize;
543         uint balance;
544         uint queriesDelay;
545         string closedAt;
546         string assigneeLogin;
547         address assigneeAddress;
548     }
549  
550     mapping (bytes32 => bytes32) queriesKey;
551     mapping (bytes32 => QueryType) queriesType;
552     mapping (bytes32 => Bounty) public bounties;
553     bytes32[] public bountiesKey;
554     mapping (address => bool) public sponsors;
555     
556     uint contractBalance;
557     
558     event SponsorAdded(address sponsorAddr);
559     event BountyAdded(bytes32 bountyKey, string issueUrl);
560     event IssueStateLoaded(bytes32 bountyKey, string closedAt);
561     event IssueAssigneeLoaded(bytes32 bountyKey, string login);
562     event UserAddressLoaded(bytes32 bountyKey, string assigneeAddress);
563     event SendingBounty(bytes32 bountyKey, uint prize, address assigneeAddress);
564     event BountySent(bytes32 bountyKey);
565     
566     uint oraclizeGasLimit = 1000000;
567 
568     function GitHubBounty() {
569     }
570     
571     function addSponsor(address sponsorAddr)
572     {
573         require(msg.sender == owner);
574         sponsors[sponsorAddr] = true;
575         SponsorAdded(sponsorAddr);
576     }
577     
578     // issueUrl: full API url of github issue, e.g. https://api.github.com/repos/polybioz/hello-world/issues/6
579     // queriesDelay: oraclize queries delay in minutes, e.g. 60*24 for one day, min 1 minute
580     function addIssueBounty(string issueUrl, uint queriesDelay) payable {
581         require(sponsors[msg.sender]);
582         require(bytes(issueUrl).length > 0);
583         require(msg.value > 0);
584         require(queriesDelay > 0);
585         
586         queriesDelay = queriesDelay * 60; // convert minutes to seconds
587         
588         bytes32 bountyKey = sha3(issueUrl);
589         
590         bounties[bountyKey].issueUrl = issueUrl;
591         bounties[bountyKey].prize = msg.value;
592         bounties[bountyKey].balance = msg.value;
593         bounties[bountyKey].queriesDelay = queriesDelay;
594         
595         bountiesKey.push(bountyKey);
596         
597         BountyAdded(bountyKey, issueUrl);
598  
599         getIssueState(queriesDelay, bountyKey);
600     }
601      
602     function getIssueState(uint delay, bytes32 bountyKey) internal {
603         contractBalance = this.balance;
604         
605         string issueUrl = bounties[bountyKey].issueUrl;
606         bytes32 myid = oraclize_query(delay, "URL", strConcat("json(",issueUrl,").closed_at"), oraclizeGasLimit);
607         queriesKey[myid] = bountyKey;
608         queriesType[myid] = QueryType.IssueState;
609         
610         bounties[bountyKey].balance -= contractBalance - this.balance;
611     }
612     
613     function getIssueAssignee(uint delay, bytes32 bountyKey) internal {
614         contractBalance = this.balance;
615         
616         string issueUrl = bounties[bountyKey].issueUrl;
617         bytes32 myid = oraclize_query(delay, "URL", strConcat("json(",issueUrl,").assignee.login"), oraclizeGasLimit);
618         queriesKey[myid] = bountyKey;
619         queriesType[myid] = QueryType.IssueAssignee;
620         
621         bounties[bountyKey].balance -= contractBalance - this.balance;
622     }
623     
624     function getUserAddress(uint delay, bytes32 bountyKey) internal {
625         contractBalance = this.balance;
626         
627         string login = bounties[bountyKey].assigneeLogin;
628         string memory url = strConcat("https://api.github.com/users/", login);
629         bytes32 myid = oraclize_query(delay, "URL", strConcat("json(",url,").location"), oraclizeGasLimit);
630         queriesKey[myid] = bountyKey;
631         queriesType[myid] = QueryType.UserAddress;
632         
633         bounties[bountyKey].balance -= contractBalance - this.balance;
634     }
635     
636     function sendBounty(bytes32 bountyKey) internal {
637         string issueUrl = bounties[bountyKey].issueUrl;
638         
639         SendingBounty(bountyKey, bounties[bountyKey].balance, bounties[bountyKey].assigneeAddress);
640 
641         uint transValue = bounties[bountyKey].balance;
642         if(transValue > 0) {
643             bounties[bountyKey].balance = 0;
644             if (!(bounties[bountyKey].assigneeAddress.send(transValue))) {
645                 throw;                
646             }
647             BountySent(bountyKey);
648         }
649     }
650 
651     function __callback(bytes32 myid, string result) {
652         if (msg.sender != oraclize_cbAddress()) throw;
653  
654         bytes32 bountyKey = queriesKey[myid];
655         QueryType queryType = queriesType[myid];
656         uint queriesDelay = bounties[bountyKey].queriesDelay;
657         
658         if(queryType == QueryType.IssueState) {
659             IssueStateLoaded(bountyKey, result);
660             if(bytes(result).length <= 4) { // oraclize returns "null"
661                 getIssueState(queriesDelay, bountyKey);
662             }
663             else{
664                 bounties[bountyKey].closedAt = result;
665                 getIssueAssignee(0, bountyKey);
666             }
667         } 
668         else if(queryType == QueryType.IssueAssignee) {
669             IssueAssigneeLoaded(bountyKey, result);
670             if(bytes(result).length <= 4) { // oraclize returns "null"
671                 getIssueAssignee(queriesDelay, bountyKey);
672             }
673             else {
674                 bounties[bountyKey].assigneeLogin = result;
675                 getUserAddress(0, bountyKey);
676             }
677         } 
678         else if(queryType == QueryType.UserAddress) {
679             UserAddressLoaded(bountyKey, result);
680             if(bytes(result).length <= 4) { // oraclize returns "null"
681                 getUserAddress(queriesDelay, bountyKey);
682             }
683             else {
684                 bounties[bountyKey].assigneeAddress = parseAddr(result);
685                 sendBounty(bountyKey);
686             }
687         } 
688         
689         delete queriesType[myid];
690         delete queriesKey[myid];
691     }
692 }