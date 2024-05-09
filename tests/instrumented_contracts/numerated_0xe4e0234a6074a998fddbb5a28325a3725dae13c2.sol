1 pragma solidity ^0.4.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 // <ORACLIZE_API>
43 /*
44 Copyright (c) 2015-2016 Oraclize SRL
45 Copyright (c) 2016 Oraclize LTD
46 
47 
48 
49 Permission is hereby granted, free of charge, to any person obtaining a copy
50 of this software and associated documentation files (the "Software"), to deal
51 in the Software without restriction, including without limitation the rights
52 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
53 copies of the Software, and to permit persons to whom the Software is
54 furnished to do so, subject to the following conditions:
55 
56 
57 
58 The above copyright notice and this permission notice shall be included in
59 all copies or substantial portions of the Software.
60 
61 
62 
63 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
64 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
65 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
66 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
67 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
68 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
69 THE SOFTWARE.
70 */
71 
72 //please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
73 
74 contract OraclizeI {
75     address public cbAddress;
76     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
77     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
78     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
79     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
80     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
81     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
82     function getPrice(string _datasource) returns (uint _dsprice);
83     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
84     function useCoupon(string _coupon);
85     function setProofType(byte _proofType);
86     function setConfig(bytes32 _config);
87     function setCustomGasPrice(uint _gasPrice);
88     function randomDS_getSessionPubKeyHash() returns(bytes32);
89 }
90 contract OraclizeAddrResolverI {
91     function getAddress() returns (address _addr);
92 }
93 contract usingOraclize {
94     uint constant day = 60*60*24;
95     uint constant week = 60*60*24*7;
96     uint constant month = 60*60*24*30;
97     byte constant proofType_NONE = 0x00;
98     byte constant proofType_TLSNotary = 0x10;
99     byte constant proofType_Android = 0x20;
100     byte constant proofType_Ledger = 0x30;
101     byte constant proofType_Native = 0xF0;
102     byte constant proofStorage_IPFS = 0x01;
103     uint8 constant networkID_auto = 0;
104     uint8 constant networkID_mainnet = 1;
105     uint8 constant networkID_testnet = 2;
106     uint8 constant networkID_morden = 2;
107     uint8 constant networkID_consensys = 161;
108 
109     OraclizeAddrResolverI OAR;
110 
111     OraclizeI oraclize;
112     modifier oraclizeAPI {
113         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
114         oraclize = OraclizeI(OAR.getAddress());
115         _;
116     }
117     modifier coupon(string code){
118         oraclize = OraclizeI(OAR.getAddress());
119         oraclize.useCoupon(code);
120         _;
121     }
122 
123     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
124         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
125             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
126             oraclize_setNetworkName("eth_mainnet");
127             return true;
128         }
129         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
130             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
131             oraclize_setNetworkName("eth_ropsten3");
132             return true;
133         }
134         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
135             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
136             oraclize_setNetworkName("eth_kovan");
137             return true;
138         }
139         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
140             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
141             oraclize_setNetworkName("eth_rinkeby");
142             return true;
143         }
144         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
145             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
146             return true;
147         }
148         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
149             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
150             return true;
151         }
152         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
153             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
154             return true;
155         }
156         return false;
157     }
158 
159     function __callback(bytes32 myid, string result) {
160         __callback(myid, result, new bytes(0));
161     }
162     function __callback(bytes32 myid, string result, bytes proof) {
163     }
164     
165     function oraclize_useCoupon(string code) oraclizeAPI internal {
166         oraclize.useCoupon(code);
167     }
168 
169     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
170         return oraclize.getPrice(datasource);
171     }
172 
173     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
174         return oraclize.getPrice(datasource, gaslimit);
175     }
176     
177     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
178         uint price = oraclize.getPrice(datasource);
179         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
180         return oraclize.query.value(price)(0, datasource, arg);
181     }
182     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
183         uint price = oraclize.getPrice(datasource);
184         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
185         return oraclize.query.value(price)(timestamp, datasource, arg);
186     }
187     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
188         uint price = oraclize.getPrice(datasource, gaslimit);
189         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
190         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
191     }
192     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
193         uint price = oraclize.getPrice(datasource, gaslimit);
194         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
195         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
196     }
197     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
198         uint price = oraclize.getPrice(datasource);
199         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
200         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
201     }
202     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
203         uint price = oraclize.getPrice(datasource);
204         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
205         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
206     }
207     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
208         uint price = oraclize.getPrice(datasource, gaslimit);
209         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
210         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
211     }
212     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
213         uint price = oraclize.getPrice(datasource, gaslimit);
214         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
215         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
216     }
217     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
218         uint price = oraclize.getPrice(datasource);
219         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
220         bytes memory args = stra2cbor(argN);
221         return oraclize.queryN.value(price)(0, datasource, args);
222     }
223     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
224         uint price = oraclize.getPrice(datasource);
225         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
226         bytes memory args = stra2cbor(argN);
227         return oraclize.queryN.value(price)(timestamp, datasource, args);
228     }
229     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
230         uint price = oraclize.getPrice(datasource, gaslimit);
231         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
232         bytes memory args = stra2cbor(argN);
233         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
234     }
235     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
236         uint price = oraclize.getPrice(datasource, gaslimit);
237         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
238         bytes memory args = stra2cbor(argN);
239         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
240     }
241     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
242         string[] memory dynargs = new string[](1);
243         dynargs[0] = args[0];
244         return oraclize_query(datasource, dynargs);
245     }
246     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
247         string[] memory dynargs = new string[](1);
248         dynargs[0] = args[0];
249         return oraclize_query(timestamp, datasource, dynargs);
250     }
251     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
252         string[] memory dynargs = new string[](1);
253         dynargs[0] = args[0];
254         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
255     }
256     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
257         string[] memory dynargs = new string[](1);
258         dynargs[0] = args[0];       
259         return oraclize_query(datasource, dynargs, gaslimit);
260     }
261     
262     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
263         string[] memory dynargs = new string[](2);
264         dynargs[0] = args[0];
265         dynargs[1] = args[1];
266         return oraclize_query(datasource, dynargs);
267     }
268     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
269         string[] memory dynargs = new string[](2);
270         dynargs[0] = args[0];
271         dynargs[1] = args[1];
272         return oraclize_query(timestamp, datasource, dynargs);
273     }
274     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
275         string[] memory dynargs = new string[](2);
276         dynargs[0] = args[0];
277         dynargs[1] = args[1];
278         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
279     }
280     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
281         string[] memory dynargs = new string[](2);
282         dynargs[0] = args[0];
283         dynargs[1] = args[1];
284         return oraclize_query(datasource, dynargs, gaslimit);
285     }
286     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
287         string[] memory dynargs = new string[](3);
288         dynargs[0] = args[0];
289         dynargs[1] = args[1];
290         dynargs[2] = args[2];
291         return oraclize_query(datasource, dynargs);
292     }
293     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
294         string[] memory dynargs = new string[](3);
295         dynargs[0] = args[0];
296         dynargs[1] = args[1];
297         dynargs[2] = args[2];
298         return oraclize_query(timestamp, datasource, dynargs);
299     }
300     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
301         string[] memory dynargs = new string[](3);
302         dynargs[0] = args[0];
303         dynargs[1] = args[1];
304         dynargs[2] = args[2];
305         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
306     }
307     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
308         string[] memory dynargs = new string[](3);
309         dynargs[0] = args[0];
310         dynargs[1] = args[1];
311         dynargs[2] = args[2];
312         return oraclize_query(datasource, dynargs, gaslimit);
313     }
314     
315     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
316         string[] memory dynargs = new string[](4);
317         dynargs[0] = args[0];
318         dynargs[1] = args[1];
319         dynargs[2] = args[2];
320         dynargs[3] = args[3];
321         return oraclize_query(datasource, dynargs);
322     }
323     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
324         string[] memory dynargs = new string[](4);
325         dynargs[0] = args[0];
326         dynargs[1] = args[1];
327         dynargs[2] = args[2];
328         dynargs[3] = args[3];
329         return oraclize_query(timestamp, datasource, dynargs);
330     }
331     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
332         string[] memory dynargs = new string[](4);
333         dynargs[0] = args[0];
334         dynargs[1] = args[1];
335         dynargs[2] = args[2];
336         dynargs[3] = args[3];
337         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
338     }
339     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
340         string[] memory dynargs = new string[](4);
341         dynargs[0] = args[0];
342         dynargs[1] = args[1];
343         dynargs[2] = args[2];
344         dynargs[3] = args[3];
345         return oraclize_query(datasource, dynargs, gaslimit);
346     }
347     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
348         string[] memory dynargs = new string[](5);
349         dynargs[0] = args[0];
350         dynargs[1] = args[1];
351         dynargs[2] = args[2];
352         dynargs[3] = args[3];
353         dynargs[4] = args[4];
354         return oraclize_query(datasource, dynargs);
355     }
356     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
357         string[] memory dynargs = new string[](5);
358         dynargs[0] = args[0];
359         dynargs[1] = args[1];
360         dynargs[2] = args[2];
361         dynargs[3] = args[3];
362         dynargs[4] = args[4];
363         return oraclize_query(timestamp, datasource, dynargs);
364     }
365     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
366         string[] memory dynargs = new string[](5);
367         dynargs[0] = args[0];
368         dynargs[1] = args[1];
369         dynargs[2] = args[2];
370         dynargs[3] = args[3];
371         dynargs[4] = args[4];
372         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
373     }
374     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
375         string[] memory dynargs = new string[](5);
376         dynargs[0] = args[0];
377         dynargs[1] = args[1];
378         dynargs[2] = args[2];
379         dynargs[3] = args[3];
380         dynargs[4] = args[4];
381         return oraclize_query(datasource, dynargs, gaslimit);
382     }
383     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
384         uint price = oraclize.getPrice(datasource);
385         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
386         bytes memory args = ba2cbor(argN);
387         return oraclize.queryN.value(price)(0, datasource, args);
388     }
389     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
390         uint price = oraclize.getPrice(datasource);
391         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
392         bytes memory args = ba2cbor(argN);
393         return oraclize.queryN.value(price)(timestamp, datasource, args);
394     }
395     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
396         uint price = oraclize.getPrice(datasource, gaslimit);
397         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
398         bytes memory args = ba2cbor(argN);
399         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
400     }
401     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource, gaslimit);
403         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
404         bytes memory args = ba2cbor(argN);
405         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
406     }
407     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
408         bytes[] memory dynargs = new bytes[](1);
409         dynargs[0] = args[0];
410         return oraclize_query(datasource, dynargs);
411     }
412     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
413         bytes[] memory dynargs = new bytes[](1);
414         dynargs[0] = args[0];
415         return oraclize_query(timestamp, datasource, dynargs);
416     }
417     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
418         bytes[] memory dynargs = new bytes[](1);
419         dynargs[0] = args[0];
420         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
421     }
422     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
423         bytes[] memory dynargs = new bytes[](1);
424         dynargs[0] = args[0];       
425         return oraclize_query(datasource, dynargs, gaslimit);
426     }
427     
428     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
429         bytes[] memory dynargs = new bytes[](2);
430         dynargs[0] = args[0];
431         dynargs[1] = args[1];
432         return oraclize_query(datasource, dynargs);
433     }
434     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
435         bytes[] memory dynargs = new bytes[](2);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         return oraclize_query(timestamp, datasource, dynargs);
439     }
440     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441         bytes[] memory dynargs = new bytes[](2);
442         dynargs[0] = args[0];
443         dynargs[1] = args[1];
444         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
445     }
446     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
447         bytes[] memory dynargs = new bytes[](2);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         return oraclize_query(datasource, dynargs, gaslimit);
451     }
452     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
453         bytes[] memory dynargs = new bytes[](3);
454         dynargs[0] = args[0];
455         dynargs[1] = args[1];
456         dynargs[2] = args[2];
457         return oraclize_query(datasource, dynargs);
458     }
459     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
460         bytes[] memory dynargs = new bytes[](3);
461         dynargs[0] = args[0];
462         dynargs[1] = args[1];
463         dynargs[2] = args[2];
464         return oraclize_query(timestamp, datasource, dynargs);
465     }
466     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
467         bytes[] memory dynargs = new bytes[](3);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         dynargs[2] = args[2];
471         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
472     }
473     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         bytes[] memory dynargs = new bytes[](3);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         dynargs[2] = args[2];
478         return oraclize_query(datasource, dynargs, gaslimit);
479     }
480     
481     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
482         bytes[] memory dynargs = new bytes[](4);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         dynargs[2] = args[2];
486         dynargs[3] = args[3];
487         return oraclize_query(datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
490         bytes[] memory dynargs = new bytes[](4);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         dynargs[2] = args[2];
494         dynargs[3] = args[3];
495         return oraclize_query(timestamp, datasource, dynargs);
496     }
497     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         bytes[] memory dynargs = new bytes[](4);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         dynargs[3] = args[3];
503         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
504     }
505     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506         bytes[] memory dynargs = new bytes[](4);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         dynargs[3] = args[3];
511         return oraclize_query(datasource, dynargs, gaslimit);
512     }
513     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
514         bytes[] memory dynargs = new bytes[](5);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         dynargs[3] = args[3];
519         dynargs[4] = args[4];
520         return oraclize_query(datasource, dynargs);
521     }
522     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
523         bytes[] memory dynargs = new bytes[](5);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         dynargs[3] = args[3];
528         dynargs[4] = args[4];
529         return oraclize_query(timestamp, datasource, dynargs);
530     }
531     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
532         bytes[] memory dynargs = new bytes[](5);
533         dynargs[0] = args[0];
534         dynargs[1] = args[1];
535         dynargs[2] = args[2];
536         dynargs[3] = args[3];
537         dynargs[4] = args[4];
538         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
539     }
540     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
541         bytes[] memory dynargs = new bytes[](5);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         dynargs[4] = args[4];
547         return oraclize_query(datasource, dynargs, gaslimit);
548     }
549 
550     function oraclize_cbAddress() oraclizeAPI internal returns (address){
551         return oraclize.cbAddress();
552     }
553     function oraclize_setProof(byte proofP) oraclizeAPI internal {
554         return oraclize.setProofType(proofP);
555     }
556     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
557         return oraclize.setCustomGasPrice(gasPrice);
558     }
559     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
560         return oraclize.setConfig(config);
561     }
562     
563     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
564         return oraclize.randomDS_getSessionPubKeyHash();
565     }
566 
567     function getCodeSize(address _addr) constant internal returns(uint _size) {
568         assembly {
569             _size := extcodesize(_addr)
570         }
571     }
572 
573     function parseAddr(string _a) internal returns (address){
574         bytes memory tmp = bytes(_a);
575         uint160 iaddr = 0;
576         uint160 b1;
577         uint160 b2;
578         for (uint i=2; i<2+2*20; i+=2){
579             iaddr *= 256;
580             b1 = uint160(tmp[i]);
581             b2 = uint160(tmp[i+1]);
582             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
583             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
584             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
585             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
586             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
587             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
588             iaddr += (b1*16+b2);
589         }
590         return address(iaddr);
591     }
592 
593     function strCompare(string _a, string _b) internal returns (int) {
594         bytes memory a = bytes(_a);
595         bytes memory b = bytes(_b);
596         uint minLength = a.length;
597         if (b.length < minLength) minLength = b.length;
598         for (uint i = 0; i < minLength; i ++)
599             if (a[i] < b[i])
600                 return -1;
601             else if (a[i] > b[i])
602                 return 1;
603         if (a.length < b.length)
604             return -1;
605         else if (a.length > b.length)
606             return 1;
607         else
608             return 0;
609     }
610 
611     function indexOf(string _haystack, string _needle) internal returns (int) {
612         bytes memory h = bytes(_haystack);
613         bytes memory n = bytes(_needle);
614         if(h.length < 1 || n.length < 1 || (n.length > h.length))
615             return -1;
616         else if(h.length > (2**128 -1))
617             return -1;
618         else
619         {
620             uint subindex = 0;
621             for (uint i = 0; i < h.length; i ++)
622             {
623                 if (h[i] == n[0])
624                 {
625                     subindex = 1;
626                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
627                     {
628                         subindex++;
629                     }
630                     if(subindex == n.length)
631                         return int(i);
632                 }
633             }
634             return -1;
635         }
636     }
637 
638     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
639         bytes memory _ba = bytes(_a);
640         bytes memory _bb = bytes(_b);
641         bytes memory _bc = bytes(_c);
642         bytes memory _bd = bytes(_d);
643         bytes memory _be = bytes(_e);
644         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
645         bytes memory babcde = bytes(abcde);
646         uint k = 0;
647         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
648         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
649         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
650         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
651         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
652         return string(babcde);
653     }
654 
655     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
656         return strConcat(_a, _b, _c, _d, "");
657     }
658 
659     function strConcat(string _a, string _b, string _c) internal returns (string) {
660         return strConcat(_a, _b, _c, "", "");
661     }
662 
663     function strConcat(string _a, string _b) internal returns (string) {
664         return strConcat(_a, _b, "", "", "");
665     }
666 
667     // parseInt
668     function parseInt(string _a) internal returns (uint) {
669         return parseInt(_a, 0);
670     }
671 
672     // parseInt(parseFloat*10^_b)
673     function parseInt(string _a, uint _b) internal returns (uint) {
674         bytes memory bresult = bytes(_a);
675         uint mint = 0;
676         bool decimals = false;
677         for (uint i=0; i<bresult.length; i++){
678             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
679                 if (decimals){
680                    if (_b == 0) break;
681                     else _b--;
682                 }
683                 mint *= 10;
684                 mint += uint(bresult[i]) - 48;
685             } else if (bresult[i] == 46) decimals = true;
686         }
687         if (_b > 0) mint *= 10**_b;
688         return mint;
689     }
690 
691     function uint2str(uint i) internal returns (string){
692         if (i == 0) return "0";
693         uint j = i;
694         uint len;
695         while (j != 0){
696             len++;
697             j /= 10;
698         }
699         bytes memory bstr = new bytes(len);
700         uint k = len - 1;
701         while (i != 0){
702             bstr[k--] = byte(48 + i % 10);
703             i /= 10;
704         }
705         return string(bstr);
706     }
707     
708     function stra2cbor(string[] arr) internal returns (bytes) {
709             uint arrlen = arr.length;
710 
711             // get correct cbor output length
712             uint outputlen = 0;
713             bytes[] memory elemArray = new bytes[](arrlen);
714             for (uint i = 0; i < arrlen; i++) {
715                 elemArray[i] = (bytes(arr[i]));
716                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
717             }
718             uint ctr = 0;
719             uint cborlen = arrlen + 0x80;
720             outputlen += byte(cborlen).length;
721             bytes memory res = new bytes(outputlen);
722 
723             while (byte(cborlen).length > ctr) {
724                 res[ctr] = byte(cborlen)[ctr];
725                 ctr++;
726             }
727             for (i = 0; i < arrlen; i++) {
728                 res[ctr] = 0x5F;
729                 ctr++;
730                 for (uint x = 0; x < elemArray[i].length; x++) {
731                     // if there's a bug with larger strings, this may be the culprit
732                     if (x % 23 == 0) {
733                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
734                         elemcborlen += 0x40;
735                         uint lctr = ctr;
736                         while (byte(elemcborlen).length > ctr - lctr) {
737                             res[ctr] = byte(elemcborlen)[ctr - lctr];
738                             ctr++;
739                         }
740                     }
741                     res[ctr] = elemArray[i][x];
742                     ctr++;
743                 }
744                 res[ctr] = 0xFF;
745                 ctr++;
746             }
747             return res;
748         }
749 
750     function ba2cbor(bytes[] arr) internal returns (bytes) {
751             uint arrlen = arr.length;
752 
753             // get correct cbor output length
754             uint outputlen = 0;
755             bytes[] memory elemArray = new bytes[](arrlen);
756             for (uint i = 0; i < arrlen; i++) {
757                 elemArray[i] = (bytes(arr[i]));
758                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
759             }
760             uint ctr = 0;
761             uint cborlen = arrlen + 0x80;
762             outputlen += byte(cborlen).length;
763             bytes memory res = new bytes(outputlen);
764 
765             while (byte(cborlen).length > ctr) {
766                 res[ctr] = byte(cborlen)[ctr];
767                 ctr++;
768             }
769             for (i = 0; i < arrlen; i++) {
770                 res[ctr] = 0x5F;
771                 ctr++;
772                 for (uint x = 0; x < elemArray[i].length; x++) {
773                     // if there's a bug with larger strings, this may be the culprit
774                     if (x % 23 == 0) {
775                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
776                         elemcborlen += 0x40;
777                         uint lctr = ctr;
778                         while (byte(elemcborlen).length > ctr - lctr) {
779                             res[ctr] = byte(elemcborlen)[ctr - lctr];
780                             ctr++;
781                         }
782                     }
783                     res[ctr] = elemArray[i][x];
784                     ctr++;
785                 }
786                 res[ctr] = 0xFF;
787                 ctr++;
788             }
789             return res;
790         }
791         
792         
793     string oraclize_network_name;
794     function oraclize_setNetworkName(string _network_name) internal {
795         oraclize_network_name = _network_name;
796     }
797     
798     function oraclize_getNetworkName() internal returns (string) {
799         return oraclize_network_name;
800     }
801     
802     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
803         if ((_nbytes == 0)||(_nbytes > 32)) throw;
804         bytes memory nbytes = new bytes(1);
805         nbytes[0] = byte(_nbytes);
806         bytes memory unonce = new bytes(32);
807         bytes memory sessionKeyHash = new bytes(32);
808         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
809         assembly {
810             mstore(unonce, 0x20)
811             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
812             mstore(sessionKeyHash, 0x20)
813             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
814         }
815         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
816         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
817         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
818         return queryId;
819     }
820     
821     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
822         oraclize_randomDS_args[queryId] = commitment;
823     }
824     
825     mapping(bytes32=>bytes32) oraclize_randomDS_args;
826     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
827 
828     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
829         bool sigok;
830         address signer;
831         
832         bytes32 sigr;
833         bytes32 sigs;
834         
835         bytes memory sigr_ = new bytes(32);
836         uint offset = 4+(uint(dersig[3]) - 0x20);
837         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
838         bytes memory sigs_ = new bytes(32);
839         offset += 32 + 2;
840         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
841 
842         assembly {
843             sigr := mload(add(sigr_, 32))
844             sigs := mload(add(sigs_, 32))
845         }
846         
847         
848         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
849         if (address(sha3(pubkey)) == signer) return true;
850         else {
851             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
852             return (address(sha3(pubkey)) == signer);
853         }
854     }
855 
856     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
857         bool sigok;
858         
859         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
860         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
861         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
862         
863         bytes memory appkey1_pubkey = new bytes(64);
864         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
865         
866         bytes memory tosign2 = new bytes(1+65+32);
867         tosign2[0] = 1; //role
868         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
869         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
870         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
871         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
872         
873         if (sigok == false) return false;
874         
875         
876         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
877         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
878         
879         bytes memory tosign3 = new bytes(1+65);
880         tosign3[0] = 0xFE;
881         copyBytes(proof, 3, 65, tosign3, 1);
882         
883         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
884         copyBytes(proof, 3+65, sig3.length, sig3, 0);
885         
886         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
887         
888         return sigok;
889     }
890     
891     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
892         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
893         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
894         
895         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
896         if (proofVerified == false) throw;
897         
898         _;
899     }
900     
901     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
902         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
903         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
904         
905         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
906         if (proofVerified == false) return 2;
907         
908         return 0;
909     }
910     
911     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
912         bool match_ = true;
913         
914         for (var i=0; i<prefix.length; i++){
915             if (content[i] != prefix[i]) match_ = false;
916         }
917         
918         return match_;
919     }
920 
921     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
922         bool checkok;
923         
924         
925         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
926         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
927         bytes memory keyhash = new bytes(32);
928         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
929         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
930         if (checkok == false) return false;
931         
932         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
933         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
934         
935         
936         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
937         checkok = matchBytes32Prefix(sha256(sig1), result);
938         if (checkok == false) return false;
939         
940         
941         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
942         // This is to verify that the computed args match with the ones specified in the query.
943         bytes memory commitmentSlice1 = new bytes(8+1+32);
944         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
945         
946         bytes memory sessionPubkey = new bytes(64);
947         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
948         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
949         
950         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
951         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
952             delete oraclize_randomDS_args[queryId];
953         } else return false;
954         
955         
956         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
957         bytes memory tosign1 = new bytes(32+8+1+32);
958         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
959         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
960         if (checkok == false) return false;
961         
962         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
963         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
964             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
965         }
966         
967         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
968     }
969 
970     
971     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
972     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
973         uint minLength = length + toOffset;
974 
975         if (to.length < minLength) {
976             // Buffer too small
977             throw; // Should be a better way?
978         }
979 
980         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
981         uint i = 32 + fromOffset;
982         uint j = 32 + toOffset;
983 
984         while (i < (32 + fromOffset + length)) {
985             assembly {
986                 let tmp := mload(add(from, i))
987                 mstore(add(to, j), tmp)
988             }
989             i += 32;
990             j += 32;
991         }
992 
993         return to;
994     }
995     
996     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
997     // Duplicate Solidity's ecrecover, but catching the CALL return value
998     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
999         // We do our own memory management here. Solidity uses memory offset
1000         // 0x40 to store the current end of memory. We write past it (as
1001         // writes are memory extensions), but don't update the offset so
1002         // Solidity will reuse it. The memory used here is only needed for
1003         // this context.
1004 
1005         // FIXME: inline assembly can't access return values
1006         bool ret;
1007         address addr;
1008 
1009         assembly {
1010             let size := mload(0x40)
1011             mstore(size, hash)
1012             mstore(add(size, 32), v)
1013             mstore(add(size, 64), r)
1014             mstore(add(size, 96), s)
1015 
1016             // NOTE: we can reuse the request memory because we deal with
1017             //       the return code
1018             ret := call(3000, 1, 0, size, 128, size, 32)
1019             addr := mload(size)
1020         }
1021   
1022         return (ret, addr);
1023     }
1024 
1025     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1026     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1027         bytes32 r;
1028         bytes32 s;
1029         uint8 v;
1030 
1031         if (sig.length != 65)
1032           return (false, 0);
1033 
1034         // The signature format is a compact form of:
1035         //   {bytes32 r}{bytes32 s}{uint8 v}
1036         // Compact means, uint8 is not padded to 32 bytes.
1037         assembly {
1038             r := mload(add(sig, 32))
1039             s := mload(add(sig, 64))
1040 
1041             // Here we are loading the last 32 bytes. We exploit the fact that
1042             // 'mload' will pad with zeroes if we overread.
1043             // There is no 'mload8' to do this, but that would be nicer.
1044             v := byte(0, mload(add(sig, 96)))
1045 
1046             // Alternative solution:
1047             // 'byte' is not working due to the Solidity parser, so lets
1048             // use the second best option, 'and'
1049             // v := and(mload(add(sig, 65)), 255)
1050         }
1051 
1052         // albeit non-transactional signatures are not specified by the YP, one would expect it
1053         // to match the YP range of [27, 28]
1054         //
1055         // geth uses [0, 1] and some clients have followed. This might change, see:
1056         //  https://github.com/ethereum/go-ethereum/issues/2053
1057         if (v < 27)
1058           v += 27;
1059 
1060         if (v != 27 && v != 28)
1061             return (false, 0);
1062 
1063         return safer_ecrecover(hash, v, r, s);
1064     }
1065         
1066 }
1067 // </ORACLIZE_API>
1068 
1069 contract PriceReceiver {
1070   address public ethPriceProvider;
1071 
1072   address public btcPriceProvider;
1073 
1074   modifier onlyEthPriceProvider() {
1075     require(msg.sender == ethPriceProvider);
1076     _;
1077   }
1078 
1079   modifier onlyBtcPriceProvider() {
1080     require(msg.sender == btcPriceProvider);
1081     _;
1082   }
1083 
1084   function receiveEthPrice(uint ethUsdPrice) external;
1085 
1086   function receiveBtcPrice(uint btcUsdPrice) external;
1087 
1088   function setEthPriceProvider(address provider) external;
1089 
1090   function setBtcPriceProvider(address provider) external;
1091 }
1092 
1093 /**
1094  * @title SafeMath
1095  * @dev Math operations with safety checks that throw on error
1096  */
1097 library SafeMath {
1098   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
1099     uint256 c = a * b;
1100     assert(a == 0 || c / a == b);
1101     return c;
1102   }
1103 
1104   function div(uint256 a, uint256 b) internal constant returns (uint256) {
1105     // assert(b > 0); // Solidity automatically throws when dividing by 0
1106     uint256 c = a / b;
1107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1108     return c;
1109   }
1110 
1111   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
1112     assert(b <= a);
1113     return a - b;
1114   }
1115 
1116   function add(uint256 a, uint256 b) internal constant returns (uint256) {
1117     uint256 c = a + b;
1118     assert(c >= a);
1119     return c;
1120   }
1121 }
1122 
1123 contract PriceProvider is Ownable, usingOraclize {
1124   using SafeMath for uint;
1125 
1126   enum State { Stopped, Active }
1127 
1128   uint public updateInterval = 7200; //2 hours by default
1129 
1130   uint public currentPrice;
1131 
1132   string public url;
1133 
1134   mapping (bytes32 => bool) validIds;
1135 
1136   PriceReceiver public watcher;
1137 
1138   State public state = State.Stopped;
1139 
1140   uint constant MIN_ALLOWED_PRICE_DIFF = 85;
1141 
1142   uint constant MAX_ALLOWED_PRICE_DIFF = 115;
1143 
1144   event TooBigPriceDiff(uint oldValue, uint newValue);
1145 
1146   event InsufficientFunds();
1147 
1148   function notifyWatcher() internal;
1149 
1150   modifier inActiveState() {
1151     require(state == State.Active);
1152     _;
1153   }
1154 
1155   modifier inStoppedState() {
1156     require(state == State.Stopped);
1157     _;
1158   }
1159 
1160   function PriceProvider(string _url) {
1161     url = _url;
1162 
1163     //update immediately first time to be sure everything is working - first oraclize request is free.
1164     update(0);
1165   }
1166 
1167   //send some funds along with the call to cover oraclize fees
1168   function startUpdate(uint startingPrice) payable onlyOwner inStoppedState {
1169     state = State.Active;
1170 
1171     //we can set starting price manually, contract will notify watcher only in case of allowed diff
1172     //so owner can't set too small or to big price anyway
1173     currentPrice = startingPrice;
1174     update(updateInterval);
1175   }
1176 
1177   function stopUpdate() external onlyOwner inActiveState {
1178     state = State.Stopped;
1179   }
1180 
1181   function setWatcher(address newWatcher) external onlyOwner {
1182     require(newWatcher != 0x0);
1183     watcher = PriceReceiver(newWatcher);
1184   }
1185 
1186   function setUpdateInterval(uint newInterval) external onlyOwner {
1187     require(newInterval > 0);
1188     updateInterval = newInterval;
1189   }
1190 
1191   function setUrl(string newUrl) external onlyOwner {
1192     require(bytes(newUrl).length > 0);
1193     url = newUrl;
1194   }
1195 
1196   function __callback(bytes32 myid, string result, bytes proof) {
1197     require(msg.sender == oraclize_cbAddress() && validIds[myid]);
1198     delete validIds[myid];
1199 
1200     uint newPrice = parseInt(result, 2);
1201     require(newPrice > 0);
1202     uint changeInPercents = newPrice.mul(100).div(currentPrice);
1203 
1204     if (changeInPercents >= MIN_ALLOWED_PRICE_DIFF && changeInPercents <= MAX_ALLOWED_PRICE_DIFF) {
1205       currentPrice = newPrice;
1206 
1207       if (state == State.Active) {
1208         notifyWatcher();
1209         update(updateInterval);
1210       }
1211     } else {
1212       state = State.Stopped;
1213       TooBigPriceDiff(currentPrice, newPrice);
1214     }
1215   }
1216 
1217   function update(uint delay) private {
1218     if (oraclize_getPrice("URL") > this.balance) {
1219       //stop if we don't have enough funds anymore
1220       state = State.Stopped;
1221       InsufficientFunds();
1222     } else {
1223       bytes32 queryId = oraclize_query(delay, "URL", url);
1224       validIds[queryId] = true;
1225     }
1226   }
1227 
1228   //we need to get back our funds if we don't need this oracle anymore
1229   function withdraw(address receiver) external onlyOwner inStoppedState {
1230     require(receiver != 0x0);
1231     receiver.transfer(this.balance);
1232   }
1233 }
1234 
1235 contract EthPriceProvider is PriceProvider {
1236   function EthPriceProvider() PriceProvider("json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0") {
1237     currentPrice = 36270;
1238   }
1239 
1240   function notifyWatcher() internal {
1241     watcher.receiveEthPrice(currentPrice);
1242   }
1243 }