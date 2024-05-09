1 pragma solidity ^0.4.20;
2 
3 //standart library for uint
4 library SafeMath { 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0 || b == 0){
7         return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function add(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 
25   function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
26     if (b == 0){
27       return 1;
28     }
29     uint256 c = a**b;
30     assert (c >= a);
31     return c;
32   }
33 }
34 
35 // <ORACLIZE_API>
36 /*
37 Copyright (c) 2015-2016 Oraclize SRL
38 Copyright (c) 2016 Oraclize LTD
39 
40 
41 
42 Permission is hereby granted, free of charge, to any person obtaining a copy
43 of this software and associated documentation files (the "Software"), to deal
44 in the Software without restriction, including without limitation the rights
45 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
46 copies of the Software, and to permit persons to whom the Software is
47 furnished to do so, subject to the following conditions:
48 
49 
50 
51 The above copyright notice and this permission notice shall be included in
52 all copies or substantial portions of the Software.
53 
54 
55 
56 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
57 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
58 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
59 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
60 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
61 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
62 THE SOFTWARE.
63 */
64 
65 contract OraclizeI {
66     address public cbAddress;
67     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
68     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
69     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
70     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
71     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
72     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
73     function getPrice(string _datasource) returns (uint _dsprice);
74     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
75     function useCoupon(string _coupon);
76     function setProofType(byte _proofType);
77     function setConfig(bytes32 _config);
78     function setCustomGasPrice(uint _gasPrice);
79     function randomDS_getSessionPubKeyHash() returns(bytes32);
80 }
81 contract OraclizeAddrResolverI {
82     function getAddress() returns (address _addr);
83 }
84 contract usingOraclize {
85     uint constant day = 60*60*24;
86     uint constant week = 60*60*24*7;
87     uint constant month = 60*60*24*30;
88     byte constant proofType_NONE = 0x00;
89     byte constant proofType_TLSNotary = 0x10;
90     byte constant proofType_Android = 0x20;
91     byte constant proofType_Ledger = 0x30;
92     byte constant proofType_Native = 0xF0;
93     byte constant proofStorage_IPFS = 0x01;
94     uint8 constant networkID_auto = 0;
95     uint8 constant networkID_mainnet = 1;
96     uint8 constant networkID_testnet = 2;
97     uint8 constant networkID_morden = 2;
98     uint8 constant networkID_consensys = 161;
99 
100     OraclizeAddrResolverI OAR;
101 
102     OraclizeI oraclize;
103     modifier oraclizeAPI {
104         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
105         oraclize = OraclizeI(OAR.getAddress());
106         _;
107     }
108     modifier coupon(string code){
109         oraclize = OraclizeI(OAR.getAddress());
110         oraclize.useCoupon(code);
111         _;
112     }
113 
114     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
115         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
116             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
117             oraclize_setNetworkName("eth_mainnet");
118             return true;
119         }
120         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
121             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
122             oraclize_setNetworkName("eth_ropsten3");
123             return true;
124         }
125         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
126             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
127             oraclize_setNetworkName("eth_kovan");
128             return true;
129         }
130         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
131             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
132             oraclize_setNetworkName("eth_rinkeby");
133             return true;
134         }
135         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
136             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
137             return true;
138         }
139         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
140             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
141             return true;
142         }
143         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
144             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
145             return true;
146         }
147         return false;
148     }
149 
150     function __callback(bytes32 myid, string result) {
151         __callback(myid, result, new bytes(0));
152     }
153     function __callback(bytes32 myid, string result, bytes proof) {
154     }
155     
156     function oraclize_useCoupon(string code) oraclizeAPI internal {
157         oraclize.useCoupon(code);
158     }
159 
160     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
161         return oraclize.getPrice(datasource);
162     }
163 
164     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
165         return oraclize.getPrice(datasource, gaslimit);
166     }
167     
168     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
169         uint price = oraclize.getPrice(datasource);
170         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
171         return oraclize.query.value(price)(0, datasource, arg);
172     }
173     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
174         uint price = oraclize.getPrice(datasource);
175         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
176         return oraclize.query.value(price)(timestamp, datasource, arg);
177     }
178     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
179         uint price = oraclize.getPrice(datasource, gaslimit);
180         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
181         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
182     }
183     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
184         uint price = oraclize.getPrice(datasource, gaslimit);
185         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
186         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
187     }
188     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
189         uint price = oraclize.getPrice(datasource);
190         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
191         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
192     }
193     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
194         uint price = oraclize.getPrice(datasource);
195         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
196         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
197     }
198     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
199         uint price = oraclize.getPrice(datasource, gaslimit);
200         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
201         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
202     }
203     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
204         uint price = oraclize.getPrice(datasource, gaslimit);
205         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
206         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
207     }
208     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
209         uint price = oraclize.getPrice(datasource);
210         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
211         bytes memory args = stra2cbor(argN);
212         return oraclize.queryN.value(price)(0, datasource, args);
213     }
214     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
215         uint price = oraclize.getPrice(datasource);
216         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
217         bytes memory args = stra2cbor(argN);
218         return oraclize.queryN.value(price)(timestamp, datasource, args);
219     }
220     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
221         uint price = oraclize.getPrice(datasource, gaslimit);
222         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
223         bytes memory args = stra2cbor(argN);
224         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
225     }
226     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
227         uint price = oraclize.getPrice(datasource, gaslimit);
228         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
229         bytes memory args = stra2cbor(argN);
230         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
231     }
232     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
233         string[] memory dynargs = new string[](1);
234         dynargs[0] = args[0];
235         return oraclize_query(datasource, dynargs);
236     }
237     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
238         string[] memory dynargs = new string[](1);
239         dynargs[0] = args[0];
240         return oraclize_query(timestamp, datasource, dynargs);
241     }
242     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
243         string[] memory dynargs = new string[](1);
244         dynargs[0] = args[0];
245         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
246     }
247     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
248         string[] memory dynargs = new string[](1);
249         dynargs[0] = args[0];       
250         return oraclize_query(datasource, dynargs, gaslimit);
251     }
252     
253     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
254         string[] memory dynargs = new string[](2);
255         dynargs[0] = args[0];
256         dynargs[1] = args[1];
257         return oraclize_query(datasource, dynargs);
258     }
259     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
260         string[] memory dynargs = new string[](2);
261         dynargs[0] = args[0];
262         dynargs[1] = args[1];
263         return oraclize_query(timestamp, datasource, dynargs);
264     }
265     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
266         string[] memory dynargs = new string[](2);
267         dynargs[0] = args[0];
268         dynargs[1] = args[1];
269         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
270     }
271     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
272         string[] memory dynargs = new string[](2);
273         dynargs[0] = args[0];
274         dynargs[1] = args[1];
275         return oraclize_query(datasource, dynargs, gaslimit);
276     }
277     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
278         string[] memory dynargs = new string[](3);
279         dynargs[0] = args[0];
280         dynargs[1] = args[1];
281         dynargs[2] = args[2];
282         return oraclize_query(datasource, dynargs);
283     }
284     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
285         string[] memory dynargs = new string[](3);
286         dynargs[0] = args[0];
287         dynargs[1] = args[1];
288         dynargs[2] = args[2];
289         return oraclize_query(timestamp, datasource, dynargs);
290     }
291     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
292         string[] memory dynargs = new string[](3);
293         dynargs[0] = args[0];
294         dynargs[1] = args[1];
295         dynargs[2] = args[2];
296         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
297     }
298     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
299         string[] memory dynargs = new string[](3);
300         dynargs[0] = args[0];
301         dynargs[1] = args[1];
302         dynargs[2] = args[2];
303         return oraclize_query(datasource, dynargs, gaslimit);
304     }
305     
306     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
307         string[] memory dynargs = new string[](4);
308         dynargs[0] = args[0];
309         dynargs[1] = args[1];
310         dynargs[2] = args[2];
311         dynargs[3] = args[3];
312         return oraclize_query(datasource, dynargs);
313     }
314     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
315         string[] memory dynargs = new string[](4);
316         dynargs[0] = args[0];
317         dynargs[1] = args[1];
318         dynargs[2] = args[2];
319         dynargs[3] = args[3];
320         return oraclize_query(timestamp, datasource, dynargs);
321     }
322     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
323         string[] memory dynargs = new string[](4);
324         dynargs[0] = args[0];
325         dynargs[1] = args[1];
326         dynargs[2] = args[2];
327         dynargs[3] = args[3];
328         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
329     }
330     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
331         string[] memory dynargs = new string[](4);
332         dynargs[0] = args[0];
333         dynargs[1] = args[1];
334         dynargs[2] = args[2];
335         dynargs[3] = args[3];
336         return oraclize_query(datasource, dynargs, gaslimit);
337     }
338     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
339         string[] memory dynargs = new string[](5);
340         dynargs[0] = args[0];
341         dynargs[1] = args[1];
342         dynargs[2] = args[2];
343         dynargs[3] = args[3];
344         dynargs[4] = args[4];
345         return oraclize_query(datasource, dynargs);
346     }
347     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
348         string[] memory dynargs = new string[](5);
349         dynargs[0] = args[0];
350         dynargs[1] = args[1];
351         dynargs[2] = args[2];
352         dynargs[3] = args[3];
353         dynargs[4] = args[4];
354         return oraclize_query(timestamp, datasource, dynargs);
355     }
356     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
357         string[] memory dynargs = new string[](5);
358         dynargs[0] = args[0];
359         dynargs[1] = args[1];
360         dynargs[2] = args[2];
361         dynargs[3] = args[3];
362         dynargs[4] = args[4];
363         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
364     }
365     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
366         string[] memory dynargs = new string[](5);
367         dynargs[0] = args[0];
368         dynargs[1] = args[1];
369         dynargs[2] = args[2];
370         dynargs[3] = args[3];
371         dynargs[4] = args[4];
372         return oraclize_query(datasource, dynargs, gaslimit);
373     }
374     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
375         uint price = oraclize.getPrice(datasource);
376         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
377         bytes memory args = ba2cbor(argN);
378         return oraclize.queryN.value(price)(0, datasource, args);
379     }
380     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
381         uint price = oraclize.getPrice(datasource);
382         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
383         bytes memory args = ba2cbor(argN);
384         return oraclize.queryN.value(price)(timestamp, datasource, args);
385     }
386     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
387         uint price = oraclize.getPrice(datasource, gaslimit);
388         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
389         bytes memory args = ba2cbor(argN);
390         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
391     }
392     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
393         uint price = oraclize.getPrice(datasource, gaslimit);
394         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
395         bytes memory args = ba2cbor(argN);
396         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
397     }
398     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
399         bytes[] memory dynargs = new bytes[](1);
400         dynargs[0] = args[0];
401         return oraclize_query(datasource, dynargs);
402     }
403     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
404         bytes[] memory dynargs = new bytes[](1);
405         dynargs[0] = args[0];
406         return oraclize_query(timestamp, datasource, dynargs);
407     }
408     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
409         bytes[] memory dynargs = new bytes[](1);
410         dynargs[0] = args[0];
411         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
412     }
413     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
414         bytes[] memory dynargs = new bytes[](1);
415         dynargs[0] = args[0];       
416         return oraclize_query(datasource, dynargs, gaslimit);
417     }
418     
419     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
420         bytes[] memory dynargs = new bytes[](2);
421         dynargs[0] = args[0];
422         dynargs[1] = args[1];
423         return oraclize_query(datasource, dynargs);
424     }
425     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
426         bytes[] memory dynargs = new bytes[](2);
427         dynargs[0] = args[0];
428         dynargs[1] = args[1];
429         return oraclize_query(timestamp, datasource, dynargs);
430     }
431     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
432         bytes[] memory dynargs = new bytes[](2);
433         dynargs[0] = args[0];
434         dynargs[1] = args[1];
435         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
436     }
437     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
438         bytes[] memory dynargs = new bytes[](2);
439         dynargs[0] = args[0];
440         dynargs[1] = args[1];
441         return oraclize_query(datasource, dynargs, gaslimit);
442     }
443     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
444         bytes[] memory dynargs = new bytes[](3);
445         dynargs[0] = args[0];
446         dynargs[1] = args[1];
447         dynargs[2] = args[2];
448         return oraclize_query(datasource, dynargs);
449     }
450     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
451         bytes[] memory dynargs = new bytes[](3);
452         dynargs[0] = args[0];
453         dynargs[1] = args[1];
454         dynargs[2] = args[2];
455         return oraclize_query(timestamp, datasource, dynargs);
456     }
457     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
458         bytes[] memory dynargs = new bytes[](3);
459         dynargs[0] = args[0];
460         dynargs[1] = args[1];
461         dynargs[2] = args[2];
462         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
463     }
464     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
465         bytes[] memory dynargs = new bytes[](3);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         dynargs[2] = args[2];
469         return oraclize_query(datasource, dynargs, gaslimit);
470     }
471     
472     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
473         bytes[] memory dynargs = new bytes[](4);
474         dynargs[0] = args[0];
475         dynargs[1] = args[1];
476         dynargs[2] = args[2];
477         dynargs[3] = args[3];
478         return oraclize_query(datasource, dynargs);
479     }
480     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
481         bytes[] memory dynargs = new bytes[](4);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         dynargs[2] = args[2];
485         dynargs[3] = args[3];
486         return oraclize_query(timestamp, datasource, dynargs);
487     }
488     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
489         bytes[] memory dynargs = new bytes[](4);
490         dynargs[0] = args[0];
491         dynargs[1] = args[1];
492         dynargs[2] = args[2];
493         dynargs[3] = args[3];
494         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
495     }
496     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
497         bytes[] memory dynargs = new bytes[](4);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         dynargs[2] = args[2];
501         dynargs[3] = args[3];
502         return oraclize_query(datasource, dynargs, gaslimit);
503     }
504     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
505         bytes[] memory dynargs = new bytes[](5);
506         dynargs[0] = args[0];
507         dynargs[1] = args[1];
508         dynargs[2] = args[2];
509         dynargs[3] = args[3];
510         dynargs[4] = args[4];
511         return oraclize_query(datasource, dynargs);
512     }
513     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
514         bytes[] memory dynargs = new bytes[](5);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         dynargs[3] = args[3];
519         dynargs[4] = args[4];
520         return oraclize_query(timestamp, datasource, dynargs);
521     }
522     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
523         bytes[] memory dynargs = new bytes[](5);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         dynargs[3] = args[3];
528         dynargs[4] = args[4];
529         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
530     }
531     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
532         bytes[] memory dynargs = new bytes[](5);
533         dynargs[0] = args[0];
534         dynargs[1] = args[1];
535         dynargs[2] = args[2];
536         dynargs[3] = args[3];
537         dynargs[4] = args[4];
538         return oraclize_query(datasource, dynargs, gaslimit);
539     }
540 
541     function oraclize_cbAddress() oraclizeAPI internal returns (address){
542         return oraclize.cbAddress();
543     }
544     function oraclize_setProof(byte proofP) oraclizeAPI internal {
545         return oraclize.setProofType(proofP);
546     }
547     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
548         return oraclize.setCustomGasPrice(gasPrice);
549     }
550     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
551         return oraclize.setConfig(config);
552     }
553     
554     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
555         return oraclize.randomDS_getSessionPubKeyHash();
556     }
557 
558     function getCodeSize(address _addr) constant internal returns(uint _size) {
559         assembly {
560             _size := extcodesize(_addr)
561         }
562     }
563 
564     function parseAddr(string _a) internal returns (address){
565         bytes memory tmp = bytes(_a);
566         uint160 iaddr = 0;
567         uint160 b1;
568         uint160 b2;
569         for (uint i=2; i<2+2*20; i+=2){
570             iaddr *= 256;
571             b1 = uint160(tmp[i]);
572             b2 = uint160(tmp[i+1]);
573             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
574             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
575             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
576             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
577             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
578             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
579             iaddr += (b1*16+b2);
580         }
581         return address(iaddr);
582     }
583 
584     function strCompare(string _a, string _b) internal returns (int) {
585         bytes memory a = bytes(_a);
586         bytes memory b = bytes(_b);
587         uint minLength = a.length;
588         if (b.length < minLength) minLength = b.length;
589         for (uint i = 0; i < minLength; i ++)
590             if (a[i] < b[i])
591                 return -1;
592             else if (a[i] > b[i])
593                 return 1;
594         if (a.length < b.length)
595             return -1;
596         else if (a.length > b.length)
597             return 1;
598         else
599             return 0;
600     }
601 
602     function indexOf(string _haystack, string _needle) internal returns (int) {
603         bytes memory h = bytes(_haystack);
604         bytes memory n = bytes(_needle);
605         if(h.length < 1 || n.length < 1 || (n.length > h.length))
606             return -1;
607         else if(h.length > (2**128 -1))
608             return -1;
609         else
610         {
611             uint subindex = 0;
612             for (uint i = 0; i < h.length; i ++)
613             {
614                 if (h[i] == n[0])
615                 {
616                     subindex = 1;
617                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
618                     {
619                         subindex++;
620                     }
621                     if(subindex == n.length)
622                         return int(i);
623                 }
624             }
625             return -1;
626         }
627     }
628 
629     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
630         bytes memory _ba = bytes(_a);
631         bytes memory _bb = bytes(_b);
632         bytes memory _bc = bytes(_c);
633         bytes memory _bd = bytes(_d);
634         bytes memory _be = bytes(_e);
635         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
636         bytes memory babcde = bytes(abcde);
637         uint k = 0;
638         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
639         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
640         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
641         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
642         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
643         return string(babcde);
644     }
645 
646     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
647         return strConcat(_a, _b, _c, _d, "");
648     }
649 
650     function strConcat(string _a, string _b, string _c) internal returns (string) {
651         return strConcat(_a, _b, _c, "", "");
652     }
653 
654     function strConcat(string _a, string _b) internal returns (string) {
655         return strConcat(_a, _b, "", "", "");
656     }
657 
658     // parseInt
659     function parseInt(string _a) internal returns (uint) {
660         return parseInt(_a, 0);
661     }
662 
663     // parseInt(parseFloat*10^_b)
664     function parseInt(string _a, uint _b) internal returns (uint) {
665         bytes memory bresult = bytes(_a);
666         uint mint = 0;
667         bool decimals = false;
668         for (uint i=0; i<bresult.length; i++){
669             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
670                 if (decimals){
671                    if (_b == 0) break;
672                     else _b--;
673                 }
674                 mint *= 10;
675                 mint += uint(bresult[i]) - 48;
676             } else if (bresult[i] == 46) decimals = true;
677         }
678         if (_b > 0) mint *= 10**_b;
679         return mint;
680     }
681 
682     function uint2str(uint i) internal returns (string){
683         if (i == 0) return "0";
684         uint j = i;
685         uint len;
686         while (j != 0){
687             len++;
688             j /= 10;
689         }
690         bytes memory bstr = new bytes(len);
691         uint k = len - 1;
692         while (i != 0){
693             bstr[k--] = byte(48 + i % 10);
694             i /= 10;
695         }
696         return string(bstr);
697     }
698     
699     function stra2cbor(string[] arr) internal returns (bytes) {
700             uint arrlen = arr.length;
701 
702             // get correct cbor output length
703             uint outputlen = 0;
704             bytes[] memory elemArray = new bytes[](arrlen);
705             for (uint i = 0; i < arrlen; i++) {
706                 elemArray[i] = (bytes(arr[i]));
707                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
708             }
709             uint ctr = 0;
710             uint cborlen = arrlen + 0x80;
711             outputlen += byte(cborlen).length;
712             bytes memory res = new bytes(outputlen);
713 
714             while (byte(cborlen).length > ctr) {
715                 res[ctr] = byte(cborlen)[ctr];
716                 ctr++;
717             }
718             for (i = 0; i < arrlen; i++) {
719                 res[ctr] = 0x5F;
720                 ctr++;
721                 for (uint x = 0; x < elemArray[i].length; x++) {
722                     // if there's a bug with larger strings, this may be the culprit
723                     if (x % 23 == 0) {
724                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
725                         elemcborlen += 0x40;
726                         uint lctr = ctr;
727                         while (byte(elemcborlen).length > ctr - lctr) {
728                             res[ctr] = byte(elemcborlen)[ctr - lctr];
729                             ctr++;
730                         }
731                     }
732                     res[ctr] = elemArray[i][x];
733                     ctr++;
734                 }
735                 res[ctr] = 0xFF;
736                 ctr++;
737             }
738             return res;
739         }
740 
741     function ba2cbor(bytes[] arr) internal returns (bytes) {
742             uint arrlen = arr.length;
743 
744             // get correct cbor output length
745             uint outputlen = 0;
746             bytes[] memory elemArray = new bytes[](arrlen);
747             for (uint i = 0; i < arrlen; i++) {
748                 elemArray[i] = (bytes(arr[i]));
749                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
750             }
751             uint ctr = 0;
752             uint cborlen = arrlen + 0x80;
753             outputlen += byte(cborlen).length;
754             bytes memory res = new bytes(outputlen);
755 
756             while (byte(cborlen).length > ctr) {
757                 res[ctr] = byte(cborlen)[ctr];
758                 ctr++;
759             }
760             for (i = 0; i < arrlen; i++) {
761                 res[ctr] = 0x5F;
762                 ctr++;
763                 for (uint x = 0; x < elemArray[i].length; x++) {
764                     // if there's a bug with larger strings, this may be the culprit
765                     if (x % 23 == 0) {
766                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
767                         elemcborlen += 0x40;
768                         uint lctr = ctr;
769                         while (byte(elemcborlen).length > ctr - lctr) {
770                             res[ctr] = byte(elemcborlen)[ctr - lctr];
771                             ctr++;
772                         }
773                     }
774                     res[ctr] = elemArray[i][x];
775                     ctr++;
776                 }
777                 res[ctr] = 0xFF;
778                 ctr++;
779             }
780             return res;
781         }
782         
783         
784     string oraclize_network_name;
785     function oraclize_setNetworkName(string _network_name) internal {
786         oraclize_network_name = _network_name;
787     }
788     
789     function oraclize_getNetworkName() internal returns (string) {
790         return oraclize_network_name;
791     }
792     
793     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
794         if ((_nbytes == 0)||(_nbytes > 32)) throw;
795         bytes memory nbytes = new bytes(1);
796         nbytes[0] = byte(_nbytes);
797         bytes memory unonce = new bytes(32);
798         bytes memory sessionKeyHash = new bytes(32);
799         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
800         assembly {
801             mstore(unonce, 0x20)
802             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
803             mstore(sessionKeyHash, 0x20)
804             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
805         }
806         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
807         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
808         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
809         return queryId;
810     }
811     
812     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
813         oraclize_randomDS_args[queryId] = commitment;
814     }
815     
816     mapping(bytes32=>bytes32) oraclize_randomDS_args;
817     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
818 
819     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
820         bool sigok;
821         address signer;
822         
823         bytes32 sigr;
824         bytes32 sigs;
825         
826         bytes memory sigr_ = new bytes(32);
827         uint offset = 4+(uint(dersig[3]) - 0x20);
828         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
829         bytes memory sigs_ = new bytes(32);
830         offset += 32 + 2;
831         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
832 
833         assembly {
834             sigr := mload(add(sigr_, 32))
835             sigs := mload(add(sigs_, 32))
836         }
837         
838         
839         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
840         if (address(sha3(pubkey)) == signer) return true;
841         else {
842             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
843             return (address(sha3(pubkey)) == signer);
844         }
845     }
846 
847     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
848         bool sigok;
849         
850         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
851         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
852         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
853         
854         bytes memory appkey1_pubkey = new bytes(64);
855         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
856         
857         bytes memory tosign2 = new bytes(1+65+32);
858         tosign2[0] = 1; //role
859         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
860         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
861         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
862         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
863         
864         if (sigok == false) return false;
865         
866         
867         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
868         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
869         
870         bytes memory tosign3 = new bytes(1+65);
871         tosign3[0] = 0xFE;
872         copyBytes(proof, 3, 65, tosign3, 1);
873         
874         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
875         copyBytes(proof, 3+65, sig3.length, sig3, 0);
876         
877         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
878         
879         return sigok;
880     }
881     
882     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
883         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
884         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
885         
886         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
887         if (proofVerified == false) throw;
888         
889         _;
890     }
891     
892     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
893         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
894         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
895         
896         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
897         if (proofVerified == false) return 2;
898         
899         return 0;
900     }
901     
902     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
903         bool match_ = true;
904         
905         for (var i=0; i<prefix.length; i++){
906             if (content[i] != prefix[i]) match_ = false;
907         }
908         
909         return match_;
910     }
911 
912     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
913         bool checkok;
914         
915         
916         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
917         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
918         bytes memory keyhash = new bytes(32);
919         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
920         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
921         if (checkok == false) return false;
922         
923         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
924         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
925         
926         
927         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
928         checkok = matchBytes32Prefix(sha256(sig1), result);
929         if (checkok == false) return false;
930         
931         
932         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
933         // This is to verify that the computed args match with the ones specified in the query.
934         bytes memory commitmentSlice1 = new bytes(8+1+32);
935         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
936         
937         bytes memory sessionPubkey = new bytes(64);
938         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
939         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
940         
941         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
942         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
943             delete oraclize_randomDS_args[queryId];
944         } else return false;
945         
946         
947         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
948         bytes memory tosign1 = new bytes(32+8+1+32);
949         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
950         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
951         if (checkok == false) return false;
952         
953         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
954         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
955             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
956         }
957         
958         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
959     }
960 
961     
962     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
963     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
964         uint minLength = length + toOffset;
965 
966         if (to.length < minLength) {
967             // Buffer too small
968             throw; // Should be a better way?
969         }
970 
971         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
972         uint i = 32 + fromOffset;
973         uint j = 32 + toOffset;
974 
975         while (i < (32 + fromOffset + length)) {
976             assembly {
977                 let tmp := mload(add(from, i))
978                 mstore(add(to, j), tmp)
979             }
980             i += 32;
981             j += 32;
982         }
983 
984         return to;
985     }
986     
987     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
988     // Duplicate Solidity's ecrecover, but catching the CALL return value
989     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
990         // We do our own memory management here. Solidity uses memory offset
991         // 0x40 to store the current end of memory. We write past it (as
992         // writes are memory extensions), but don't update the offset so
993         // Solidity will reuse it. The memory used here is only needed for
994         // this context.
995 
996         // FIXME: inline assembly can't access return values
997         bool ret;
998         address addr;
999 
1000         assembly {
1001             let size := mload(0x40)
1002             mstore(size, hash)
1003             mstore(add(size, 32), v)
1004             mstore(add(size, 64), r)
1005             mstore(add(size, 96), s)
1006 
1007             // NOTE: we can reuse the request memory because we deal with
1008             //       the return code
1009             ret := call(3000, 1, 0, size, 128, size, 32)
1010             addr := mload(size)
1011         }
1012   
1013         return (ret, addr);
1014     }
1015 
1016     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1017     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1018         bytes32 r;
1019         bytes32 s;
1020         uint8 v;
1021 
1022         if (sig.length != 65)
1023           return (false, 0);
1024 
1025         // The signature format is a compact form of:
1026         //   {bytes32 r}{bytes32 s}{uint8 v}
1027         // Compact means, uint8 is not padded to 32 bytes.
1028         assembly {
1029             r := mload(add(sig, 32))
1030             s := mload(add(sig, 64))
1031 
1032             // Here we are loading the last 32 bytes. We exploit the fact that
1033             // 'mload' will pad with zeroes if we overread.
1034             // There is no 'mload8' to do this, but that would be nicer.
1035             v := byte(0, mload(add(sig, 96)))
1036 
1037             // Alternative solution:
1038             // 'byte' is not working due to the Solidity parser, so lets
1039             // use the second best option, 'and'
1040             // v := and(mload(add(sig, 65)), 255)
1041         }
1042 
1043         // albeit non-transactional signatures are not specified by the YP, one would expect it
1044         // to match the YP range of [27, 28]
1045         //
1046         // geth uses [0, 1] and some clients have followed. This might change, see:
1047         //  https://github.com/ethereum/go-ethereum/issues/2053
1048         if (v < 27)
1049           v += 27;
1050 
1051         if (v != 27 && v != 28)
1052             return (false, 0);
1053 
1054         return safer_ecrecover(hash, v, r, s);
1055     }
1056         
1057 }
1058 // </ORACLIZE_API>
1059 
1060 //standart contract to identify owner
1061 contract Ownable {
1062 
1063   address public owner;
1064 
1065   address public newOwner;
1066 
1067   modifier onlyOwner() {
1068     require(msg.sender == owner);
1069     _;
1070   }
1071 
1072   function Ownable() public {
1073     owner = msg.sender;
1074   }
1075 
1076   function transferOwnership(address _newOwner) public onlyOwner {
1077     require(_newOwner != address(0));
1078     newOwner = _newOwner;
1079   }
1080 
1081   function acceptOwnership() public {
1082     if (msg.sender == newOwner) {
1083       owner = newOwner;
1084     }
1085   }
1086 }
1087 
1088 //Abstract Token contract
1089 contract CAIDToken{
1090   function setCrowdsaleContract (address) public;
1091   function sendCrowdsaleTokens(address, uint256)  public;
1092   function endICO () public;
1093 
1094 }
1095 
1096 //Crowdsale contract
1097 contract CAIDCrowdsale is Ownable, usingOraclize{
1098 
1099   using SafeMath for uint;
1100 
1101   uint decimals = 8;
1102 
1103   // Token contract address
1104   CAIDToken public token;
1105 
1106   uint public startingExchangePrice = 1165134514779731;
1107   uint public currentExchangePrice;
1108 
1109   address public distributionAddress;
1110 
1111   // Constructor
1112   function CAIDCrowdsale(address _tokenAddress, address _distribution) public payable{
1113     require (msg.value > 0);
1114     
1115     token = CAIDToken(_tokenAddress);
1116     owner = msg.sender;
1117 
1118     distributionAddress = _distribution;
1119 
1120     token.setCrowdsaleContract(this);
1121     
1122     oraclize_setNetwork(networkID_auto);
1123     oraclize = OraclizeI(OAR.getAddress());
1124     
1125     // privateStagePrice = startingExchangePrice*8/100;
1126     // preIcoPrice = startingExchangePrice*15/100;
1127     // icoPrice = startingExchangePrice*24/100;
1128 
1129     oraclizeBalance = msg.value;
1130         
1131     updateFlag = true;
1132     oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1133   }
1134 
1135   uint public constant MIN_DEPOSIT = 1 ether;
1136 
1137   //PRIVATE PHASE CONSTANTS
1138 
1139   uint public constant PRIVATE_STAGE_START = 1523804400; //April 15 2018 17:00 GMT+2
1140   uint public constant PRIVATE_STAGE_FINISH = 1523804400 + 10 days;
1141 
1142   // uint public privateStagePrice;
1143 
1144   uint public privateStageTokensSold;
1145 
1146   uint public constant PRIVATE_STAGE_MAX_CAP = uint(5000000).mul((uint)(10).pow(decimals)); //5 000 000 CAID
1147 
1148 
1149   //END PRIVATE PHASE CONSTANTS
1150 
1151   //PRE ICO CONSTANTS
1152 
1153   
1154   uint public constant PRE_ICO_START = 1530975600; //July 7 2018 17:00 GMT+2
1155   uint public constant PRE_ICO_FINISH = 1530975600 + 10 days;
1156 
1157   // uint public preIcoPrice;
1158 
1159   uint public preIcoTokensSold;
1160 
1161   uint public constant PRE_ICO_MAX_CAP = uint(15000000).mul((uint)(10).pow(decimals)); //15 000 000 CAID
1162 
1163 
1164   //END PRE ICO CONSTANTS
1165 
1166   //ICO CONSTANTS
1167 
1168   uint public ICO_START = 1531818000; // July 17 2018 10:00:00 UTC+1
1169   uint public ICO_FINISH = 1532901600; //July 29 2018 23:00:00 UTC+1
1170 
1171   // uint public icoPrice;
1172 
1173   uint public icoTokensSold;
1174 
1175   uint public ICO_MIN_CAP = startingExchangePrice.mul((uint)(1770000)); // 1 770 000 USD
1176   uint public ICO_MAX_CAP = startingExchangePrice.mul((uint)(8850000)); // 8 850 000 USD
1177   // uint public constant ICO_MAX_CAP = 2000000 ether;
1178 
1179 
1180   //END ICO CONSTANTS
1181   uint public tokensSold;
1182   uint public ethCollected = 0;
1183 
1184   
1185   function getPhase(uint _time) public view returns(uint8) {
1186     if(_time == 0){
1187       _time = now;
1188     }
1189     if (PRIVATE_STAGE_START <= _time && _time < PRIVATE_STAGE_FINISH){
1190       return 1;
1191     }
1192     if (PRE_ICO_START <= _time && _time < PRE_ICO_FINISH){
1193       return 2;
1194     }
1195     if (ICO_START <= _time && _time < ICO_FINISH){
1196       return 3;
1197     }
1198     return 0;
1199   }
1200 
1201   mapping (address => uint) public contributorEthCollected;
1202   
1203   mapping (address => bool) public whiteList;
1204 
1205   event addToWhiteListEvent(address _address);
1206   event removeFromWhiteListEvent(address _address);
1207   
1208   
1209   function addToWhiteList(address[] _addresses) public onlyOwner {
1210     for (uint i = 0; i < _addresses.length; i++){
1211       whiteList[_addresses[i]] = true;
1212       emit addToWhiteListEvent(_addresses[i]);
1213     }
1214   }
1215 
1216   function removeFromWhiteList (address[] _addresses) public onlyOwner {
1217     for (uint i = 0; i < _addresses.length; i++){
1218       whiteList[_addresses[i]] = false;
1219       emit removeFromWhiteListEvent(_addresses[i]);
1220     }
1221   }
1222 
1223   function () public payable {
1224     require (whiteList[msg.sender]);
1225 
1226     require (msg.value >= MIN_DEPOSIT);
1227     
1228     require (buy(msg.sender, msg.value, now, 0, false));
1229   }
1230 
1231   function buy (address _address, uint _value, uint _time, uint _bonus, bool _manually) internal returns(bool) {
1232     uint8 currentPhase = getPhase(_time);
1233     require (currentPhase != 0);
1234 
1235     uint tokensToSend;
1236 
1237     ethCollected = ethCollected.add(_value);
1238 
1239     if (currentPhase == 1){
1240       tokensToSend = _value.mul((uint)(10).pow(decimals))/(currentExchangePrice*8/100);
1241       tokensToSend = tokensToSend.add(tokensToSend.mul(_bonus)/100);
1242 
1243       if(tokensToSend.add(privateStageTokensSold) <= PRIVATE_STAGE_MAX_CAP){
1244         privateStageTokensSold = privateStageTokensSold.add(tokensToSend);
1245         tokensSold = tokensSold.add(tokensToSend);
1246 
1247         distributionAddress.transfer(address(this).balance);
1248       }else{
1249         return false;
1250       }
1251 
1252     }else if(currentPhase == 2){
1253       tokensToSend = _value.mul((uint)(10).pow(decimals))/(currentExchangePrice*15/100);
1254       tokensToSend = tokensToSend.add(tokensToSend.mul(_bonus)/100);
1255 
1256       if(tokensToSend.add(preIcoTokensSold) <= PRE_ICO_MAX_CAP){
1257         preIcoTokensSold = preIcoTokensSold.add(tokensToSend);
1258         tokensSold = tokensSold.add(tokensToSend);
1259 
1260         distributionAddress.transfer(address(this).balance);
1261       }else{
1262         return false;
1263       }
1264 
1265     }else if(currentPhase == 3){
1266       uint icoDiscount = getIcoDiscount();
1267 
1268       tokensToSend = _value.mul((uint)(10).pow(decimals))/((currentExchangePrice*24/100).sub((currentExchangePrice*24/100).mul(icoDiscount)/100));
1269       tokensToSend = tokensToSend.add(tokensToSend.mul(_bonus)/100);
1270 
1271       if(ethCollected/currentExchangePrice <= ICO_MAX_CAP){
1272         icoTokensSold = icoTokensSold.add(tokensToSend);
1273         tokensSold = tokensSold.add(tokensToSend);
1274 
1275         if(_manually){
1276           contributorEthCollected[_address] = contributorEthCollected[_address].add(_value);
1277         }
1278         if (ethCollected/currentExchangePrice >= ICO_MIN_CAP){
1279           distributionAddress.transfer(address(this).balance);
1280         }
1281       }else{
1282         return false;
1283       }
1284     }
1285     
1286 
1287     token.sendCrowdsaleTokens(_address, tokensToSend);
1288     return true;
1289   }
1290 
1291   function sendEtherManually (address _address, uint _value, uint _bonus) public onlyOwner {
1292     require (buy(_address, _value, now, _bonus, true));
1293   }
1294 
1295   function sendTokensManually (address _address, uint _value) public onlyOwner {
1296     tokensSold = tokensSold.add(_value);
1297     token.sendCrowdsaleTokens(_address,_value);
1298   }
1299 
1300   function getIcoDiscount () public view returns(uint) {
1301     if(icoTokensSold < uint(10000000).mul(uint(10).pow(decimals))){
1302       return 15;
1303     }
1304     if(icoTokensSold < uint(20000000).mul(uint(10).pow(decimals))){
1305       return 10;
1306     }
1307     if(icoTokensSold < uint(30000000).mul(uint(10).pow(decimals))){
1308       return 5;
1309     }
1310     return 0;
1311   }
1312   
1313   bool public isIcoFinished = false;
1314 
1315   function endICO () public onlyOwner {
1316     require (now > ICO_FINISH && !isIcoFinished);
1317     isIcoFinished = true;
1318     token.endICO;
1319   }
1320 
1321   function refund () public {
1322     require ((now > ICO_FINISH) && (ethCollected/currentExchangePrice >= ICO_MIN_CAP));
1323     require(contributorEthCollected[msg.sender] > 0);
1324 
1325     msg.sender.transfer(contributorEthCollected[msg.sender]);
1326 
1327     contributorEthCollected[msg.sender] = 0;
1328   }
1329   
1330    // ORACLIZE functions
1331 
1332   uint public oraclizeBalance = 0;
1333   bool public updateFlag = false;
1334   uint public priceUpdateAt;
1335 
1336   function update() internal {
1337     oraclize_query(86400,"URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1338     //86400 - 1 day
1339   
1340     oraclizeBalance = oraclizeBalance.sub(oraclize_getPrice("URL")); //request to oraclize
1341   }
1342 
1343   function startOraclize (uint _time) public onlyOwner {
1344     require (_time != 0);
1345     require (!updateFlag);
1346     
1347     updateFlag = true;
1348     oraclize_query(_time,"URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1349     oraclizeBalance = oraclizeBalance.sub(oraclize_getPrice("URL"));
1350   }
1351 
1352   function addEtherForOraclize () public payable {
1353     oraclizeBalance = oraclizeBalance.add(msg.value);
1354   }
1355 
1356   function requestOraclizeBalance () public onlyOwner {
1357     updateFlag = false;
1358     if (address(this).balance >= oraclizeBalance){
1359       owner.transfer(oraclizeBalance);
1360     }else{
1361       owner.transfer(address(this).balance);
1362     }
1363     oraclizeBalance = 0;
1364   }
1365   
1366   function stopOraclize () public onlyOwner {
1367     updateFlag = false;
1368   }
1369     
1370   function __callback(bytes32, string result, bytes) public {
1371     require(msg.sender == oraclize_cbAddress());
1372 
1373     uint256 price = 10 ** 23 / parseInt(result, 5);
1374 
1375     require(price > 0);
1376     currentExchangePrice = price;
1377 
1378     // privateStagePrice = price*8/100;
1379     // preIcoPrice = price*15/100;
1380     // icoPrice = price*24/100;
1381 
1382     priceUpdateAt = block.timestamp;
1383             
1384     if(updateFlag){
1385       update();
1386     }
1387   }
1388   
1389   //end ORACLIZE functions
1390 }