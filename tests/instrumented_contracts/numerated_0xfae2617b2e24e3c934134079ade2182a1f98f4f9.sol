1 pragma solidity ^0.4.17;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17   /**
18    * @dev Throws if called by any account other than the owner.
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24   /**
25    * @dev Allows the current owner to transfer control of the contract to a newOwner.
26    * @param newOwner The address to transfer ownership to.
27    */
28   function transferOwnership(address newOwner) onlyOwner public {
29     require(newOwner != address(0));
30     OwnershipTransferred(owner, newOwner);
31     owner = newOwner;
32   }
33 }
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     if (a == 0) {
41       return 0;
42     }
43     uint256 c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return c;
52   }
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 // <ORACLIZE_API>
64 /*
65 Copyright (c) 2015-2016 Oraclize SRL
66 Copyright (c) 2016 Oraclize LTD
67 Permission is hereby granted, free of charge, to any person obtaining a copy
68 of this software and associated documentation files (the "Software"), to deal
69 in the Software without restriction, including without limitation the rights
70 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
71 copies of the Software, and to permit persons to whom the Software is
72 furnished to do so, subject to the following conditions:
73 The above copyright notice and this permission notice shall be included in
74 all copies or substantial portions of the Software.
75 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
76 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
77 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
78 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
79 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
80 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
81 THE SOFTWARE.
82 */
83   //please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
84 contract OraclizeI {
85     address public cbAddress;
86     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
87     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
88     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
89     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
90     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
91     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
92     function getPrice(string _datasource) returns (uint _dsprice);
93     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
94     function useCoupon(string _coupon);
95     function setProofType(byte _proofType);
96     function setConfig(bytes32 _config);
97     function setCustomGasPrice(uint _gasPrice);
98     function randomDS_getSessionPubKeyHash() returns(bytes32);
99 }
100 contract OraclizeAddrResolverI {
101     function getAddress() returns (address _addr);
102 }
103 contract usingOraclize {
104     uint constant day = 60*60*24;
105     uint constant week = 60*60*24*7;
106     uint constant month = 60*60*24*30;
107     byte constant proofType_NONE = 0x00;
108     byte constant proofType_TLSNotary = 0x10;
109     byte constant proofType_Android = 0x20;
110     byte constant proofType_Ledger = 0x30;
111     byte constant proofType_Native = 0xF0;
112     byte constant proofStorage_IPFS = 0x01;
113     uint8 constant networkID_auto = 0;
114     uint8 constant networkID_mainnet = 1;
115     uint8 constant networkID_testnet = 2;
116     uint8 constant networkID_morden = 2;
117     uint8 constant networkID_consensys = 161;
118     OraclizeAddrResolverI OAR;
119     OraclizeI oraclize;
120     modifier oraclizeAPI {
121         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
122             oraclize_setNetwork(networkID_auto);
123         if(address(oraclize) != OAR.getAddress())
124             oraclize = OraclizeI(OAR.getAddress());
125         _;
126     }
127     modifier coupon(string code){
128         oraclize = OraclizeI(OAR.getAddress());
129         oraclize.useCoupon(code);
130         _;
131     }
132     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
133         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
134             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
135             oraclize_setNetworkName("eth_mainnet");
136             return true;
137         }
138         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
139             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
140             oraclize_setNetworkName("eth_ropsten3");
141             return true;
142         }
143         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
144             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
145             oraclize_setNetworkName("eth_kovan");
146             return true;
147         }
148         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
149             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
150             oraclize_setNetworkName("eth_rinkeby");
151             return true;
152         }
153         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
154             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
155             return true;
156         }
157         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
158             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
159             return true;
160         }
161         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
162             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
163             return true;
164         }
165         return false;
166     }
167     function __callback(bytes32 myid, string result) {
168         __callback(myid, result, new bytes(0));
169     }
170     function __callback(bytes32 myid, string result, bytes proof) {
171     }
172     
173     function oraclize_useCoupon(string code) oraclizeAPI internal {
174         oraclize.useCoupon(code);
175     }
176     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
177         return oraclize.getPrice(datasource);
178     }
179     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
180         return oraclize.getPrice(datasource, gaslimit);
181     }
182     
183     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
184         uint price = oraclize.getPrice(datasource);
185         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
186         return oraclize.query.value(price)(0, datasource, arg);
187     }
188     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
189         uint price = oraclize.getPrice(datasource);
190         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
191         return oraclize.query.value(price)(timestamp, datasource, arg);
192     }
193     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
194         uint price = oraclize.getPrice(datasource, gaslimit);
195         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
196         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
197     }
198     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
199         uint price = oraclize.getPrice(datasource, gaslimit);
200         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
201         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
202     }
203     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
204         uint price = oraclize.getPrice(datasource);
205         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
206         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
207     }
208     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
209         uint price = oraclize.getPrice(datasource);
210         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
211         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
212     }
213     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
214         uint price = oraclize.getPrice(datasource, gaslimit);
215         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
216         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
217     }
218     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
219         uint price = oraclize.getPrice(datasource, gaslimit);
220         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
221         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
222     }
223     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
224         uint price = oraclize.getPrice(datasource);
225         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
226         bytes memory args = stra2cbor(argN);
227         return oraclize.queryN.value(price)(0, datasource, args);
228     }
229     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
230         uint price = oraclize.getPrice(datasource);
231         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
232         bytes memory args = stra2cbor(argN);
233         return oraclize.queryN.value(price)(timestamp, datasource, args);
234     }
235     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
236         uint price = oraclize.getPrice(datasource, gaslimit);
237         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
238         bytes memory args = stra2cbor(argN);
239         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
240     }
241     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
242         uint price = oraclize.getPrice(datasource, gaslimit);
243         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
244         bytes memory args = stra2cbor(argN);
245         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
246     }
247     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
248         string[] memory dynargs = new string[](1);
249         dynargs[0] = args[0];
250         return oraclize_query(datasource, dynargs);
251     }
252     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
253         string[] memory dynargs = new string[](1);
254         dynargs[0] = args[0];
255         return oraclize_query(timestamp, datasource, dynargs);
256     }
257     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
258         string[] memory dynargs = new string[](1);
259         dynargs[0] = args[0];
260         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
261     }
262     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
263         string[] memory dynargs = new string[](1);
264         dynargs[0] = args[0];       
265         return oraclize_query(datasource, dynargs, gaslimit);
266     }
267     
268     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
269         string[] memory dynargs = new string[](2);
270         dynargs[0] = args[0];
271         dynargs[1] = args[1];
272         return oraclize_query(datasource, dynargs);
273     }
274     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
275         string[] memory dynargs = new string[](2);
276         dynargs[0] = args[0];
277         dynargs[1] = args[1];
278         return oraclize_query(timestamp, datasource, dynargs);
279     }
280     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
281         string[] memory dynargs = new string[](2);
282         dynargs[0] = args[0];
283         dynargs[1] = args[1];
284         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
285     }
286     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
287         string[] memory dynargs = new string[](2);
288         dynargs[0] = args[0];
289         dynargs[1] = args[1];
290         return oraclize_query(datasource, dynargs, gaslimit);
291     }
292     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
293         string[] memory dynargs = new string[](3);
294         dynargs[0] = args[0];
295         dynargs[1] = args[1];
296         dynargs[2] = args[2];
297         return oraclize_query(datasource, dynargs);
298     }
299     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
300         string[] memory dynargs = new string[](3);
301         dynargs[0] = args[0];
302         dynargs[1] = args[1];
303         dynargs[2] = args[2];
304         return oraclize_query(timestamp, datasource, dynargs);
305     }
306     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
307         string[] memory dynargs = new string[](3);
308         dynargs[0] = args[0];
309         dynargs[1] = args[1];
310         dynargs[2] = args[2];
311         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
312     }
313     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
314         string[] memory dynargs = new string[](3);
315         dynargs[0] = args[0];
316         dynargs[1] = args[1];
317         dynargs[2] = args[2];
318         return oraclize_query(datasource, dynargs, gaslimit);
319     }
320     
321     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
322         string[] memory dynargs = new string[](4);
323         dynargs[0] = args[0];
324         dynargs[1] = args[1];
325         dynargs[2] = args[2];
326         dynargs[3] = args[3];
327         return oraclize_query(datasource, dynargs);
328     }
329     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
330         string[] memory dynargs = new string[](4);
331         dynargs[0] = args[0];
332         dynargs[1] = args[1];
333         dynargs[2] = args[2];
334         dynargs[3] = args[3];
335         return oraclize_query(timestamp, datasource, dynargs);
336     }
337     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
338         string[] memory dynargs = new string[](4);
339         dynargs[0] = args[0];
340         dynargs[1] = args[1];
341         dynargs[2] = args[2];
342         dynargs[3] = args[3];
343         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
344     }
345     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
346         string[] memory dynargs = new string[](4);
347         dynargs[0] = args[0];
348         dynargs[1] = args[1];
349         dynargs[2] = args[2];
350         dynargs[3] = args[3];
351         return oraclize_query(datasource, dynargs, gaslimit);
352     }
353     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
354         string[] memory dynargs = new string[](5);
355         dynargs[0] = args[0];
356         dynargs[1] = args[1];
357         dynargs[2] = args[2];
358         dynargs[3] = args[3];
359         dynargs[4] = args[4];
360         return oraclize_query(datasource, dynargs);
361     }
362     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
363         string[] memory dynargs = new string[](5);
364         dynargs[0] = args[0];
365         dynargs[1] = args[1];
366         dynargs[2] = args[2];
367         dynargs[3] = args[3];
368         dynargs[4] = args[4];
369         return oraclize_query(timestamp, datasource, dynargs);
370     }
371     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
372         string[] memory dynargs = new string[](5);
373         dynargs[0] = args[0];
374         dynargs[1] = args[1];
375         dynargs[2] = args[2];
376         dynargs[3] = args[3];
377         dynargs[4] = args[4];
378         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
379     }
380     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
381         string[] memory dynargs = new string[](5);
382         dynargs[0] = args[0];
383         dynargs[1] = args[1];
384         dynargs[2] = args[2];
385         dynargs[3] = args[3];
386         dynargs[4] = args[4];
387         return oraclize_query(datasource, dynargs, gaslimit);
388     }
389     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
390         uint price = oraclize.getPrice(datasource);
391         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
392         bytes memory args = ba2cbor(argN);
393         return oraclize.queryN.value(price)(0, datasource, args);
394     }
395     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
396         uint price = oraclize.getPrice(datasource);
397         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
398         bytes memory args = ba2cbor(argN);
399         return oraclize.queryN.value(price)(timestamp, datasource, args);
400     }
401     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource, gaslimit);
403         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
404         bytes memory args = ba2cbor(argN);
405         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
406     }
407     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
408         uint price = oraclize.getPrice(datasource, gaslimit);
409         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
410         bytes memory args = ba2cbor(argN);
411         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
412     }
413     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
414         bytes[] memory dynargs = new bytes[](1);
415         dynargs[0] = args[0];
416         return oraclize_query(datasource, dynargs);
417     }
418     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
419         bytes[] memory dynargs = new bytes[](1);
420         dynargs[0] = args[0];
421         return oraclize_query(timestamp, datasource, dynargs);
422     }
423     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
424         bytes[] memory dynargs = new bytes[](1);
425         dynargs[0] = args[0];
426         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
427     }
428     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
429         bytes[] memory dynargs = new bytes[](1);
430         dynargs[0] = args[0];       
431         return oraclize_query(datasource, dynargs, gaslimit);
432     }
433     
434     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
435         bytes[] memory dynargs = new bytes[](2);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         return oraclize_query(datasource, dynargs);
439     }
440     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
441         bytes[] memory dynargs = new bytes[](2);
442         dynargs[0] = args[0];
443         dynargs[1] = args[1];
444         return oraclize_query(timestamp, datasource, dynargs);
445     }
446     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
447         bytes[] memory dynargs = new bytes[](2);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
451     }
452     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
453         bytes[] memory dynargs = new bytes[](2);
454         dynargs[0] = args[0];
455         dynargs[1] = args[1];
456         return oraclize_query(datasource, dynargs, gaslimit);
457     }
458     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
459         bytes[] memory dynargs = new bytes[](3);
460         dynargs[0] = args[0];
461         dynargs[1] = args[1];
462         dynargs[2] = args[2];
463         return oraclize_query(datasource, dynargs);
464     }
465     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
466         bytes[] memory dynargs = new bytes[](3);
467         dynargs[0] = args[0];
468         dynargs[1] = args[1];
469         dynargs[2] = args[2];
470         return oraclize_query(timestamp, datasource, dynargs);
471     }
472     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
473         bytes[] memory dynargs = new bytes[](3);
474         dynargs[0] = args[0];
475         dynargs[1] = args[1];
476         dynargs[2] = args[2];
477         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
478     }
479     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
480         bytes[] memory dynargs = new bytes[](3);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         dynargs[2] = args[2];
484         return oraclize_query(datasource, dynargs, gaslimit);
485     }
486     
487     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
488         bytes[] memory dynargs = new bytes[](4);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         dynargs[2] = args[2];
492         dynargs[3] = args[3];
493         return oraclize_query(datasource, dynargs);
494     }
495     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
496         bytes[] memory dynargs = new bytes[](4);
497         dynargs[0] = args[0];
498         dynargs[1] = args[1];
499         dynargs[2] = args[2];
500         dynargs[3] = args[3];
501         return oraclize_query(timestamp, datasource, dynargs);
502     }
503     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
504         bytes[] memory dynargs = new bytes[](4);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         dynargs[3] = args[3];
509         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
510     }
511     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
512         bytes[] memory dynargs = new bytes[](4);
513         dynargs[0] = args[0];
514         dynargs[1] = args[1];
515         dynargs[2] = args[2];
516         dynargs[3] = args[3];
517         return oraclize_query(datasource, dynargs, gaslimit);
518     }
519     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
520         bytes[] memory dynargs = new bytes[](5);
521         dynargs[0] = args[0];
522         dynargs[1] = args[1];
523         dynargs[2] = args[2];
524         dynargs[3] = args[3];
525         dynargs[4] = args[4];
526         return oraclize_query(datasource, dynargs);
527     }
528     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
529         bytes[] memory dynargs = new bytes[](5);
530         dynargs[0] = args[0];
531         dynargs[1] = args[1];
532         dynargs[2] = args[2];
533         dynargs[3] = args[3];
534         dynargs[4] = args[4];
535         return oraclize_query(timestamp, datasource, dynargs);
536     }
537     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
538         bytes[] memory dynargs = new bytes[](5);
539         dynargs[0] = args[0];
540         dynargs[1] = args[1];
541         dynargs[2] = args[2];
542         dynargs[3] = args[3];
543         dynargs[4] = args[4];
544         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
545     }
546     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
547         bytes[] memory dynargs = new bytes[](5);
548         dynargs[0] = args[0];
549         dynargs[1] = args[1];
550         dynargs[2] = args[2];
551         dynargs[3] = args[3];
552         dynargs[4] = args[4];
553         return oraclize_query(datasource, dynargs, gaslimit);
554     }
555     function oraclize_cbAddress() oraclizeAPI internal returns (address){
556         return oraclize.cbAddress();
557     }
558     function oraclize_setProof(byte proofP) oraclizeAPI internal {
559         return oraclize.setProofType(proofP);
560     }
561     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
562         return oraclize.setCustomGasPrice(gasPrice);
563     }
564     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
565         return oraclize.setConfig(config);
566     }
567     
568     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
569         return oraclize.randomDS_getSessionPubKeyHash();
570     }
571     function getCodeSize(address _addr) constant internal returns(uint _size) {
572         assembly {
573             _size := extcodesize(_addr)
574         }
575     }
576     function parseAddr(string _a) internal returns (address){
577         bytes memory tmp = bytes(_a);
578         uint160 iaddr = 0;
579         uint160 b1;
580         uint160 b2;
581         for (uint i=2; i<2+2*20; i+=2){
582             iaddr *= 256;
583             b1 = uint160(tmp[i]);
584             b2 = uint160(tmp[i+1]);
585             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
586             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
587             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
588             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
589             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
590             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
591             iaddr += (b1*16+b2);
592         }
593         return address(iaddr);
594     }
595     function strCompare(string _a, string _b) internal returns (int) {
596         bytes memory a = bytes(_a);
597         bytes memory b = bytes(_b);
598         uint minLength = a.length;
599         if (b.length < minLength) minLength = b.length;
600         for (uint i = 0; i < minLength; i ++)
601             if (a[i] < b[i])
602                 return -1;
603             else if (a[i] > b[i])
604                 return 1;
605         if (a.length < b.length)
606             return -1;
607         else if (a.length > b.length)
608             return 1;
609         else
610             return 0;
611     }
612     function indexOf(string _haystack, string _needle) internal returns (int) {
613         bytes memory h = bytes(_haystack);
614         bytes memory n = bytes(_needle);
615         if(h.length < 1 || n.length < 1 || (n.length > h.length))
616             return -1;
617         else if(h.length > (2**128 -1))
618             return -1;
619         else
620         {
621             uint subindex = 0;
622             for (uint i = 0; i < h.length; i ++)
623             {
624                 if (h[i] == n[0])
625                 {
626                     subindex = 1;
627                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
628                     {
629                         subindex++;
630                     }
631                     if(subindex == n.length)
632                         return int(i);
633                 }
634             }
635             return -1;
636         }
637     }
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
654     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
655         return strConcat(_a, _b, _c, _d, "");
656     }
657     function strConcat(string _a, string _b, string _c) internal returns (string) {
658         return strConcat(_a, _b, _c, "", "");
659     }
660     function strConcat(string _a, string _b) internal returns (string) {
661         return strConcat(_a, _b, "", "", "");
662     }
663     // parseInt
664     function parseInt(string _a) internal returns (uint) {
665         return parseInt(_a, 0);
666     }
667     // parseInt(parseFloat*10^_b)
668     function parseInt(string _a, uint _b) internal returns (uint) {
669         bytes memory bresult = bytes(_a);
670         uint mint = 0;
671         bool decimals = false;
672         for (uint i=0; i<bresult.length; i++){
673             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
674                 if (decimals){
675                    if (_b == 0) break;
676                     else _b--;
677                 }
678                 mint *= 10;
679                 mint += uint(bresult[i]) - 48;
680             } else if (bresult[i] == 46) decimals = true;
681         }
682         if (_b > 0) mint *= 10**_b;
683         return mint;
684     }
685     function uint2str(uint i) internal returns (string){
686         if (i == 0) return "0";
687         uint j = i;
688         uint len;
689         while (j != 0){
690             len++;
691             j /= 10;
692         }
693         bytes memory bstr = new bytes(len);
694         uint k = len - 1;
695         while (i != 0){
696             bstr[k--] = byte(48 + i % 10);
697             i /= 10;
698         }
699         return string(bstr);
700     }
701     
702     function stra2cbor(string[] arr) internal returns (bytes) {
703             uint arrlen = arr.length;
704             // get correct cbor output length
705             uint outputlen = 0;
706             bytes[] memory elemArray = new bytes[](arrlen);
707             for (uint i = 0; i < arrlen; i++) {
708                 elemArray[i] = (bytes(arr[i]));
709                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
710             }
711             uint ctr = 0;
712             uint cborlen = arrlen + 0x80;
713             outputlen += byte(cborlen).length;
714             bytes memory res = new bytes(outputlen);
715             while (byte(cborlen).length > ctr) {
716                 res[ctr] = byte(cborlen)[ctr];
717                 ctr++;
718             }
719             for (i = 0; i < arrlen; i++) {
720                 res[ctr] = 0x5F;
721                 ctr++;
722                 for (uint x = 0; x < elemArray[i].length; x++) {
723                     // if there's a bug with larger strings, this may be the culprit
724                     if (x % 23 == 0) {
725                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
726                         elemcborlen += 0x40;
727                         uint lctr = ctr;
728                         while (byte(elemcborlen).length > ctr - lctr) {
729                             res[ctr] = byte(elemcborlen)[ctr - lctr];
730                             ctr++;
731                         }
732                     }
733                     res[ctr] = elemArray[i][x];
734                     ctr++;
735                 }
736                 res[ctr] = 0xFF;
737                 ctr++;
738             }
739             return res;
740         }
741     function ba2cbor(bytes[] arr) internal returns (bytes) {
742             uint arrlen = arr.length;
743             // get correct cbor output length
744             uint outputlen = 0;
745             bytes[] memory elemArray = new bytes[](arrlen);
746             for (uint i = 0; i < arrlen; i++) {
747                 elemArray[i] = (bytes(arr[i]));
748                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
749             }
750             uint ctr = 0;
751             uint cborlen = arrlen + 0x80;
752             outputlen += byte(cborlen).length;
753             bytes memory res = new bytes(outputlen);
754             while (byte(cborlen).length > ctr) {
755                 res[ctr] = byte(cborlen)[ctr];
756                 ctr++;
757             }
758             for (i = 0; i < arrlen; i++) {
759                 res[ctr] = 0x5F;
760                 ctr++;
761                 for (uint x = 0; x < elemArray[i].length; x++) {
762                     // if there's a bug with larger strings, this may be the culprit
763                     if (x % 23 == 0) {
764                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
765                         elemcborlen += 0x40;
766                         uint lctr = ctr;
767                         while (byte(elemcborlen).length > ctr - lctr) {
768                             res[ctr] = byte(elemcborlen)[ctr - lctr];
769                             ctr++;
770                         }
771                     }
772                     res[ctr] = elemArray[i][x];
773                     ctr++;
774                 }
775                 res[ctr] = 0xFF;
776                 ctr++;
777             }
778             return res;
779         }
780         
781         
782     string oraclize_network_name;
783     function oraclize_setNetworkName(string _network_name) internal {
784         oraclize_network_name = _network_name;
785     }
786     
787     function oraclize_getNetworkName() internal returns (string) {
788         return oraclize_network_name;
789     }
790     
791     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
792         if ((_nbytes == 0)||(_nbytes > 32)) throw;
793         bytes memory nbytes = new bytes(1);
794         nbytes[0] = byte(_nbytes);
795         bytes memory unonce = new bytes(32);
796         bytes memory sessionKeyHash = new bytes(32);
797         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
798         assembly {
799             mstore(unonce, 0x20)
800             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
801             mstore(sessionKeyHash, 0x20)
802             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
803         }
804         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
805         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
806         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
807         return queryId;
808     }
809     
810     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
811         oraclize_randomDS_args[queryId] = commitment;
812     }
813     
814     mapping(bytes32=>bytes32) oraclize_randomDS_args;
815     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
816     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
817         bool sigok;
818         address signer;
819         
820         bytes32 sigr;
821         bytes32 sigs;
822         
823         bytes memory sigr_ = new bytes(32);
824         uint offset = 4+(uint(dersig[3]) - 0x20);
825         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
826         bytes memory sigs_ = new bytes(32);
827         offset += 32 + 2;
828         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
829         assembly {
830             sigr := mload(add(sigr_, 32))
831             sigs := mload(add(sigs_, 32))
832         }
833         
834         
835         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
836         if (address(sha3(pubkey)) == signer) return true;
837         else {
838             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
839             return (address(sha3(pubkey)) == signer);
840         }
841     }
842     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
843         bool sigok;
844         
845         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
846         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
847         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
848         
849         bytes memory appkey1_pubkey = new bytes(64);
850         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
851         
852         bytes memory tosign2 = new bytes(1+65+32);
853         tosign2[0] = 1; //role
854         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
855         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
856         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
857         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
858         
859         if (sigok == false) return false;
860         
861         
862         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
863         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
864         
865         bytes memory tosign3 = new bytes(1+65);
866         tosign3[0] = 0xFE;
867         copyBytes(proof, 3, 65, tosign3, 1);
868         
869         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
870         copyBytes(proof, 3+65, sig3.length, sig3, 0);
871         
872         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
873         
874         return sigok;
875     }
876     
877     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
878         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
879         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
880         
881         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
882         if (proofVerified == false) throw;
883         
884         _;
885     }
886     
887     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
888         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
889         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
890         
891         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
892         if (proofVerified == false) return 2;
893         
894         return 0;
895     }
896     
897     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
898         bool match_ = true;
899         
900         for (var i=0; i<prefix.length; i++){
901             if (content[i] != prefix[i]) match_ = false;
902         }
903         
904         return match_;
905     }
906     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
907         bool checkok;
908         
909         
910         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
911         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
912         bytes memory keyhash = new bytes(32);
913         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
914         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
915         if (checkok == false) return false;
916         
917         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
918         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
919         
920         
921         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
922         checkok = matchBytes32Prefix(sha256(sig1), result);
923         if (checkok == false) return false;
924         
925         
926         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
927         // This is to verify that the computed args match with the ones specified in the query.
928         bytes memory commitmentSlice1 = new bytes(8+1+32);
929         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
930         
931         bytes memory sessionPubkey = new bytes(64);
932         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
933         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
934         
935         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
936         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
937             delete oraclize_randomDS_args[queryId];
938         } else return false;
939         
940         
941         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
942         bytes memory tosign1 = new bytes(32+8+1+32);
943         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
944         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
945         if (checkok == false) return false;
946         
947         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
948         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
949             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
950         }
951         
952         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
953     }
954     
955     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
956     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
957         uint minLength = length + toOffset;
958         if (to.length < minLength) {
959             // Buffer too small
960             throw; // Should be a better way?
961         }
962         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
963         uint i = 32 + fromOffset;
964         uint j = 32 + toOffset;
965         while (i < (32 + fromOffset + length)) {
966             assembly {
967                 let tmp := mload(add(from, i))
968                 mstore(add(to, j), tmp)
969             }
970             i += 32;
971             j += 32;
972         }
973         return to;
974     }
975     
976     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
977     // Duplicate Solidity's ecrecover, but catching the CALL return value
978     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
979         // We do our own memory management here. Solidity uses memory offset
980         // 0x40 to store the current end of memory. We write past it (as
981         // writes are memory extensions), but don't update the offset so
982         // Solidity will reuse it. The memory used here is only needed for
983         // this context.
984         // FIXME: inline assembly can't access return values
985         bool ret;
986         address addr;
987         assembly {
988             let size := mload(0x40)
989             mstore(size, hash)
990             mstore(add(size, 32), v)
991             mstore(add(size, 64), r)
992             mstore(add(size, 96), s)
993             // NOTE: we can reuse the request memory because we deal with
994             //       the return code
995             ret := call(3000, 1, 0, size, 128, size, 32)
996             addr := mload(size)
997         }
998   
999         return (ret, addr);
1000     }
1001     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1002     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1003         bytes32 r;
1004         bytes32 s;
1005         uint8 v;
1006         if (sig.length != 65)
1007           return (false, 0);
1008         // The signature format is a compact form of:
1009         //   {bytes32 r}{bytes32 s}{uint8 v}
1010         // Compact means, uint8 is not padded to 32 bytes.
1011         assembly {
1012             r := mload(add(sig, 32))
1013             s := mload(add(sig, 64))
1014             // Here we are loading the last 32 bytes. We exploit the fact that
1015             // 'mload' will pad with zeroes if we overread.
1016             // There is no 'mload8' to do this, but that would be nicer.
1017             v := byte(0, mload(add(sig, 96)))
1018             // Alternative solution:
1019             // 'byte' is not working due to the Solidity parser, so lets
1020             // use the second best option, 'and'
1021             // v := and(mload(add(sig, 65)), 255)
1022         }
1023         // albeit non-transactional signatures are not specified by the YP, one would expect it
1024         // to match the YP range of [27, 28]
1025         //
1026         // geth uses [0, 1] and some clients have followed. This might change, see:
1027         //  https://github.com/ethereum/go-ethereum/issues/2053
1028         if (v < 27)
1029           v += 27;
1030         if (v != 27 && v != 28)
1031             return (false, 0);
1032         return safer_ecrecover(hash, v, r, s);
1033     }
1034         
1035 }
1036 // </ORACLIZE_API>
1037 contract Bitlagio is Ownable, usingOraclize {
1038   using SafeMath for uint;
1039   uint constant SAFE_GAS = 2300;
1040   uint constant ORACLIZE_GAS_LIMIT = 175000;
1041   uint constant N = 4;
1042   uint constant MODULO = 100;
1043   uint constant HOUSE_EDGE = 10;
1044   uint constant MIN_BET = 0.1 ether;
1045   struct Bet {
1046     address playerAddress;
1047     uint amountBet;
1048     uint numberRolled;
1049   }
1050   mapping(bytes32 => Bet) public bets;
1051   bytes32[] public betsKeys;
1052   // only allows player to wager Math.min(1/10 * pot balance, 10eth)
1053   uint maxBetAllowed;
1054   event LOG_NewBet(address playerAddress, uint amount);
1055   event LOG_BetWon(address playerAddress, uint numberRolled, uint amountWon);
1056   event LOG_BetLost(address playerAddress, uint numberRolled, uint amountLost);
1057   event LOG_OwnerDeposit(uint amount);
1058   event LOG_OwnerWithdraw(address destination, uint amount);
1059   modifier onlyIfBetSizeAllowed(uint betSize) {
1060     if (betSize > maxBetAllowed || betSize < MIN_BET) throw;
1061     _;
1062   }
1063   modifier onlyIfBetExist(bytes32 betId) {
1064     if(bets[betId].playerAddress == address(0x0)) throw;
1065     _;
1066   }
1067   modifier onlyIfNotProcessed(bytes32 betId) {
1068     if (bets[betId].numberRolled > 0) throw;
1069     _;
1070   }
1071   modifier onlyOraclize {
1072     if (msg.sender != oraclize_cbAddress()) throw;
1073     _;
1074   }
1075   function Bitlagio() public {
1076     oraclize_setNetwork(networkID_auto);
1077     /* use TLSNotary for oraclize call */
1078     oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1079   }
1080   function adjustMaxBetAllowed() internal {
1081     maxBetAllowed = this.balance.div(10);
1082     if (maxBetAllowed > 10 ether) {
1083       maxBetAllowed = 10 ether;
1084     }
1085   }
1086   function () payable external {
1087     adjustMaxBetAllowed();
1088     if (msg.sender != owner) {
1089       makeBet(msg.value);
1090     } else {
1091       LOG_OwnerDeposit(msg.value);
1092     }
1093   }
1094   function makeBet(uint betSize) onlyIfBetSizeAllowed(betSize) {
1095     LOG_NewBet(msg.sender, betSize);
1096     uint delay = 0; // number of seconds to wait before the execution takes place
1097     uint callbackGas = 200000; // amount of gas we want Oraclize to set for the callback function
1098     bytes32 betId =
1099       oraclize_query(
1100         "nested",
1101         "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random.data.0', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BH/dtQ8XAz4lyFCzf4aAhI2mGO1GOCdtOLR2T2mBD/4mdQI+d6KT11xpL/m+vPDmTLp9LIX0NTlwsVkYf5p17BIPAruzez/uIctZLwuV/rT48i1sHw4UOW40R8Rsc+F3Wsv6dbKA8b7Qj1uPmgumSmG9gu4U},\"n\":1,\"min\":1,\"max\":100${[identity] \"}\"},\"id\":1${[identity] \"}\"}']",
1102         ORACLIZE_GAS_LIMIT + SAFE_GAS
1103       );
1104     bets[betId] = Bet(msg.sender, msg.value, 0);
1105     betsKeys.push(betId);
1106   }
1107   function __callback(bytes32 betId, string result, bytes proof) public
1108     onlyOraclize
1109     onlyIfBetExist(betId)
1110     onlyIfNotProcessed(betId)
1111   {
1112     bets[betId].numberRolled = parseInt(result);
1113     Bet thisBet = bets[betId];
1114     require(thisBet.numberRolled >= 1 && thisBet.numberRolled <= 100);
1115     if (betWon(thisBet)) {
1116       LOG_BetWon(thisBet.playerAddress, thisBet.numberRolled, thisBet.amountBet);
1117       thisBet.playerAddress.send(thisBet.amountBet.mul(2));
1118     } else {
1119       LOG_BetLost(thisBet.playerAddress, thisBet.numberRolled, thisBet.amountBet);
1120       thisBet.playerAddress.send(1);  // sending 1 wei just to let player know he didn't win
1121     }
1122   }
1123   function betWon(Bet bet) internal returns(bool) {
1124     if (bet.numberRolled > (MODULO.div(2).add(HOUSE_EDGE))) {
1125       return true;
1126     }
1127     return false;
1128   }
1129   function withdrawFromPot(uint amount) onlyOwner {
1130     LOG_OwnerWithdraw(owner, amount);
1131     owner.send(amount);
1132   }
1133 }