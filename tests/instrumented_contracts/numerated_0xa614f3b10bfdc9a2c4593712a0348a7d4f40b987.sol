1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10 
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // <ORACLIZE_API>
46 /*
47 Copyright (c) 2015-2016 Oraclize SRL
48 Copyright (c) 2016 Oraclize LTD
49 
50 
51 
52 Permission is hereby granted, free of charge, to any person obtaining a copy
53 of this software and associated documentation files (the "Software"), to deal
54 in the Software without restriction, including without limitation the rights
55 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
56 copies of the Software, and to permit persons to whom the Software is
57 furnished to do so, subject to the following conditions:
58 
59 
60 
61 The above copyright notice and this permission notice shall be included in
62 all copies or substantial portions of the Software.
63 
64 
65 
66 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
67 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
68 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
69 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
70 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
71 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
72 THE SOFTWARE.
73 */
74 
75 contract OraclizeI {
76     address public cbAddress;
77     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
78     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
79     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
80     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
81     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
82     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
83     function getPrice(string _datasource) public returns (uint _dsprice);
84     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
85     function setProofType(byte _proofType) external;
86     function setCustomGasPrice(uint _gasPrice) external;
87     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
88 }
89 
90 
91 contract OraclizeAddrResolverI {
92     function getAddress() public returns (address _addr);
93 }
94 
95 contract usingOraclize {
96     uint constant day = 60*60*24;
97     uint constant week = 60*60*24*7;
98     uint constant month = 60*60*24*30;
99     byte constant proofType_NONE = 0x00;
100     byte constant proofType_TLSNotary = 0x10;
101     byte constant proofType_Android = 0x20;
102     byte constant proofType_Ledger = 0x30;
103     byte constant proofType_Native = 0xF0;
104     byte constant proofStorage_IPFS = 0x01;
105     uint8 constant networkID_auto = 0;
106     uint8 constant networkID_mainnet = 1;
107     uint8 constant networkID_testnet = 2;
108     uint8 constant networkID_morden = 2;
109     uint8 constant networkID_consensys = 161;
110 
111     OraclizeAddrResolverI OAR;
112 
113     OraclizeI oraclize;
114     modifier oraclizeAPI {
115         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
116             oraclize_setNetwork(networkID_auto);
117 
118         if(address(oraclize) != OAR.getAddress())
119             oraclize = OraclizeI(OAR.getAddress());
120 
121         _;
122     }
123     modifier coupon(string code){
124         oraclize = OraclizeI(OAR.getAddress());
125         _;
126     }
127 
128     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
129       return oraclize_setNetwork();
130       networkID; // silence the warning and remain backwards compatible
131     }
132     function oraclize_setNetwork() internal returns(bool){
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
167 
168     function __callback(bytes32 myid, string result) public {
169         __callback(myid, result, new bytes(0));
170     }
171     function __callback(bytes32 myid, string result, bytes proof) public {
172       return;
173       myid; result; proof; // Silence compiler warnings
174     }
175 
176     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
177         return oraclize.getPrice(datasource);
178     }
179 
180     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
181         return oraclize.getPrice(datasource, gaslimit);
182     }
183 
184     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
185         uint price = oraclize.getPrice(datasource);
186         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
187         return oraclize.query.value(price)(0, datasource, arg);
188     }
189     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
190         uint price = oraclize.getPrice(datasource);
191         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
192         return oraclize.query.value(price)(timestamp, datasource, arg);
193     }
194     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
195         uint price = oraclize.getPrice(datasource, gaslimit);
196         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
197         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
198     }
199     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
200         uint price = oraclize.getPrice(datasource, gaslimit);
201         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
202         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
203     }
204     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
205         uint price = oraclize.getPrice(datasource);
206         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
207         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
208     }
209     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
210         uint price = oraclize.getPrice(datasource);
211         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
212         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
213     }
214     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
215         uint price = oraclize.getPrice(datasource, gaslimit);
216         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
217         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
218     }
219     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
220         uint price = oraclize.getPrice(datasource, gaslimit);
221         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
222         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
223     }
224     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
225         uint price = oraclize.getPrice(datasource);
226         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
227         bytes memory args = stra2cbor(argN);
228         return oraclize.queryN.value(price)(0, datasource, args);
229     }
230     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
231         uint price = oraclize.getPrice(datasource);
232         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
233         bytes memory args = stra2cbor(argN);
234         return oraclize.queryN.value(price)(timestamp, datasource, args);
235     }
236     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
237         uint price = oraclize.getPrice(datasource, gaslimit);
238         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
239         bytes memory args = stra2cbor(argN);
240         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
241     }
242     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
243         uint price = oraclize.getPrice(datasource, gaslimit);
244         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
245         bytes memory args = stra2cbor(argN);
246         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
247     }
248     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
249         string[] memory dynargs = new string[](1);
250         dynargs[0] = args[0];
251         return oraclize_query(datasource, dynargs);
252     }
253     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
254         string[] memory dynargs = new string[](1);
255         dynargs[0] = args[0];
256         return oraclize_query(timestamp, datasource, dynargs);
257     }
258     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
259         string[] memory dynargs = new string[](1);
260         dynargs[0] = args[0];
261         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
262     }
263     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
264         string[] memory dynargs = new string[](1);
265         dynargs[0] = args[0];
266         return oraclize_query(datasource, dynargs, gaslimit);
267     }
268 
269     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
270         string[] memory dynargs = new string[](2);
271         dynargs[0] = args[0];
272         dynargs[1] = args[1];
273         return oraclize_query(datasource, dynargs);
274     }
275     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
276         string[] memory dynargs = new string[](2);
277         dynargs[0] = args[0];
278         dynargs[1] = args[1];
279         return oraclize_query(timestamp, datasource, dynargs);
280     }
281     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
282         string[] memory dynargs = new string[](2);
283         dynargs[0] = args[0];
284         dynargs[1] = args[1];
285         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
286     }
287     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
288         string[] memory dynargs = new string[](2);
289         dynargs[0] = args[0];
290         dynargs[1] = args[1];
291         return oraclize_query(datasource, dynargs, gaslimit);
292     }
293     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
294         string[] memory dynargs = new string[](3);
295         dynargs[0] = args[0];
296         dynargs[1] = args[1];
297         dynargs[2] = args[2];
298         return oraclize_query(datasource, dynargs);
299     }
300     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
301         string[] memory dynargs = new string[](3);
302         dynargs[0] = args[0];
303         dynargs[1] = args[1];
304         dynargs[2] = args[2];
305         return oraclize_query(timestamp, datasource, dynargs);
306     }
307     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
308         string[] memory dynargs = new string[](3);
309         dynargs[0] = args[0];
310         dynargs[1] = args[1];
311         dynargs[2] = args[2];
312         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
313     }
314     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
315         string[] memory dynargs = new string[](3);
316         dynargs[0] = args[0];
317         dynargs[1] = args[1];
318         dynargs[2] = args[2];
319         return oraclize_query(datasource, dynargs, gaslimit);
320     }
321 
322     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
323         string[] memory dynargs = new string[](4);
324         dynargs[0] = args[0];
325         dynargs[1] = args[1];
326         dynargs[2] = args[2];
327         dynargs[3] = args[3];
328         return oraclize_query(datasource, dynargs);
329     }
330     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
331         string[] memory dynargs = new string[](4);
332         dynargs[0] = args[0];
333         dynargs[1] = args[1];
334         dynargs[2] = args[2];
335         dynargs[3] = args[3];
336         return oraclize_query(timestamp, datasource, dynargs);
337     }
338     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
339         string[] memory dynargs = new string[](4);
340         dynargs[0] = args[0];
341         dynargs[1] = args[1];
342         dynargs[2] = args[2];
343         dynargs[3] = args[3];
344         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
345     }
346     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
347         string[] memory dynargs = new string[](4);
348         dynargs[0] = args[0];
349         dynargs[1] = args[1];
350         dynargs[2] = args[2];
351         dynargs[3] = args[3];
352         return oraclize_query(datasource, dynargs, gaslimit);
353     }
354     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
355         string[] memory dynargs = new string[](5);
356         dynargs[0] = args[0];
357         dynargs[1] = args[1];
358         dynargs[2] = args[2];
359         dynargs[3] = args[3];
360         dynargs[4] = args[4];
361         return oraclize_query(datasource, dynargs);
362     }
363     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
364         string[] memory dynargs = new string[](5);
365         dynargs[0] = args[0];
366         dynargs[1] = args[1];
367         dynargs[2] = args[2];
368         dynargs[3] = args[3];
369         dynargs[4] = args[4];
370         return oraclize_query(timestamp, datasource, dynargs);
371     }
372     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
373         string[] memory dynargs = new string[](5);
374         dynargs[0] = args[0];
375         dynargs[1] = args[1];
376         dynargs[2] = args[2];
377         dynargs[3] = args[3];
378         dynargs[4] = args[4];
379         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
380     }
381     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
382         string[] memory dynargs = new string[](5);
383         dynargs[0] = args[0];
384         dynargs[1] = args[1];
385         dynargs[2] = args[2];
386         dynargs[3] = args[3];
387         dynargs[4] = args[4];
388         return oraclize_query(datasource, dynargs, gaslimit);
389     }
390     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
391         uint price = oraclize.getPrice(datasource);
392         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
393         bytes memory args = ba2cbor(argN);
394         return oraclize.queryN.value(price)(0, datasource, args);
395     }
396     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
397         uint price = oraclize.getPrice(datasource);
398         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
399         bytes memory args = ba2cbor(argN);
400         return oraclize.queryN.value(price)(timestamp, datasource, args);
401     }
402     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
403         uint price = oraclize.getPrice(datasource, gaslimit);
404         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
405         bytes memory args = ba2cbor(argN);
406         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
407     }
408     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
409         uint price = oraclize.getPrice(datasource, gaslimit);
410         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
411         bytes memory args = ba2cbor(argN);
412         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
413     }
414     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
415         bytes[] memory dynargs = new bytes[](1);
416         dynargs[0] = args[0];
417         return oraclize_query(datasource, dynargs);
418     }
419     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
420         bytes[] memory dynargs = new bytes[](1);
421         dynargs[0] = args[0];
422         return oraclize_query(timestamp, datasource, dynargs);
423     }
424     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
425         bytes[] memory dynargs = new bytes[](1);
426         dynargs[0] = args[0];
427         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
428     }
429     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
430         bytes[] memory dynargs = new bytes[](1);
431         dynargs[0] = args[0];
432         return oraclize_query(datasource, dynargs, gaslimit);
433     }
434 
435     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
436         bytes[] memory dynargs = new bytes[](2);
437         dynargs[0] = args[0];
438         dynargs[1] = args[1];
439         return oraclize_query(datasource, dynargs);
440     }
441     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
442         bytes[] memory dynargs = new bytes[](2);
443         dynargs[0] = args[0];
444         dynargs[1] = args[1];
445         return oraclize_query(timestamp, datasource, dynargs);
446     }
447     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
448         bytes[] memory dynargs = new bytes[](2);
449         dynargs[0] = args[0];
450         dynargs[1] = args[1];
451         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
452     }
453     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
454         bytes[] memory dynargs = new bytes[](2);
455         dynargs[0] = args[0];
456         dynargs[1] = args[1];
457         return oraclize_query(datasource, dynargs, gaslimit);
458     }
459     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
460         bytes[] memory dynargs = new bytes[](3);
461         dynargs[0] = args[0];
462         dynargs[1] = args[1];
463         dynargs[2] = args[2];
464         return oraclize_query(datasource, dynargs);
465     }
466     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
467         bytes[] memory dynargs = new bytes[](3);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         dynargs[2] = args[2];
471         return oraclize_query(timestamp, datasource, dynargs);
472     }
473     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         bytes[] memory dynargs = new bytes[](3);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         dynargs[2] = args[2];
478         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
479     }
480     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
481         bytes[] memory dynargs = new bytes[](3);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         dynargs[2] = args[2];
485         return oraclize_query(datasource, dynargs, gaslimit);
486     }
487 
488     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
489         bytes[] memory dynargs = new bytes[](4);
490         dynargs[0] = args[0];
491         dynargs[1] = args[1];
492         dynargs[2] = args[2];
493         dynargs[3] = args[3];
494         return oraclize_query(datasource, dynargs);
495     }
496     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
497         bytes[] memory dynargs = new bytes[](4);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         dynargs[2] = args[2];
501         dynargs[3] = args[3];
502         return oraclize_query(timestamp, datasource, dynargs);
503     }
504     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
505         bytes[] memory dynargs = new bytes[](4);
506         dynargs[0] = args[0];
507         dynargs[1] = args[1];
508         dynargs[2] = args[2];
509         dynargs[3] = args[3];
510         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
511     }
512     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
513         bytes[] memory dynargs = new bytes[](4);
514         dynargs[0] = args[0];
515         dynargs[1] = args[1];
516         dynargs[2] = args[2];
517         dynargs[3] = args[3];
518         return oraclize_query(datasource, dynargs, gaslimit);
519     }
520     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
521         bytes[] memory dynargs = new bytes[](5);
522         dynargs[0] = args[0];
523         dynargs[1] = args[1];
524         dynargs[2] = args[2];
525         dynargs[3] = args[3];
526         dynargs[4] = args[4];
527         return oraclize_query(datasource, dynargs);
528     }
529     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
530         bytes[] memory dynargs = new bytes[](5);
531         dynargs[0] = args[0];
532         dynargs[1] = args[1];
533         dynargs[2] = args[2];
534         dynargs[3] = args[3];
535         dynargs[4] = args[4];
536         return oraclize_query(timestamp, datasource, dynargs);
537     }
538     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
539         bytes[] memory dynargs = new bytes[](5);
540         dynargs[0] = args[0];
541         dynargs[1] = args[1];
542         dynargs[2] = args[2];
543         dynargs[3] = args[3];
544         dynargs[4] = args[4];
545         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
546     }
547     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
548         bytes[] memory dynargs = new bytes[](5);
549         dynargs[0] = args[0];
550         dynargs[1] = args[1];
551         dynargs[2] = args[2];
552         dynargs[3] = args[3];
553         dynargs[4] = args[4];
554         return oraclize_query(datasource, dynargs, gaslimit);
555     }
556 
557     function oraclize_cbAddress() oraclizeAPI internal returns (address){
558         return oraclize.cbAddress();
559     }
560     function oraclize_setProof(byte proofP) oraclizeAPI internal {
561         return oraclize.setProofType(proofP);
562     }
563     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
564         return oraclize.setCustomGasPrice(gasPrice);
565     }
566 
567     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
568         return oraclize.randomDS_getSessionPubKeyHash();
569     }
570 
571     function getCodeSize(address _addr) constant internal returns(uint _size) {
572         assembly {
573             _size := extcodesize(_addr)
574         }
575     }
576 
577     function parseAddr(string _a) internal pure returns (address){
578         bytes memory tmp = bytes(_a);
579         uint160 iaddr = 0;
580         uint160 b1;
581         uint160 b2;
582         for (uint i=2; i<2+2*20; i+=2){
583             iaddr *= 256;
584             b1 = uint160(tmp[i]);
585             b2 = uint160(tmp[i+1]);
586             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
587             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
588             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
589             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
590             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
591             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
592             iaddr += (b1*16+b2);
593         }
594         return address(iaddr);
595     }
596 
597     function strCompare(string _a, string _b) internal pure returns (int) {
598         bytes memory a = bytes(_a);
599         bytes memory b = bytes(_b);
600         uint minLength = a.length;
601         if (b.length < minLength) minLength = b.length;
602         for (uint i = 0; i < minLength; i ++)
603             if (a[i] < b[i])
604                 return -1;
605             else if (a[i] > b[i])
606                 return 1;
607         if (a.length < b.length)
608             return -1;
609         else if (a.length > b.length)
610             return 1;
611         else
612             return 0;
613     }
614 
615     function indexOf(string _haystack, string _needle) internal pure returns (int) {
616         bytes memory h = bytes(_haystack);
617         bytes memory n = bytes(_needle);
618         if(h.length < 1 || n.length < 1 || (n.length > h.length))
619             return -1;
620         else if(h.length > (2**128 -1))
621             return -1;
622         else
623         {
624             uint subindex = 0;
625             for (uint i = 0; i < h.length; i ++)
626             {
627                 if (h[i] == n[0])
628                 {
629                     subindex = 1;
630                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
631                     {
632                         subindex++;
633                     }
634                     if(subindex == n.length)
635                         return int(i);
636                 }
637             }
638             return -1;
639         }
640     }
641 
642     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
643         bytes memory _ba = bytes(_a);
644         bytes memory _bb = bytes(_b);
645         bytes memory _bc = bytes(_c);
646         bytes memory _bd = bytes(_d);
647         bytes memory _be = bytes(_e);
648         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
649         bytes memory babcde = bytes(abcde);
650         uint k = 0;
651         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
652         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
653         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
654         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
655         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
656         return string(babcde);
657     }
658 
659     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
660         return strConcat(_a, _b, _c, _d, "");
661     }
662 
663     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
664         return strConcat(_a, _b, _c, "", "");
665     }
666 
667     function strConcat(string _a, string _b) internal pure returns (string) {
668         return strConcat(_a, _b, "", "", "");
669     }
670 
671     // parseInt
672     function parseInt(string _a) internal pure returns (uint) {
673         return parseInt(_a, 0);
674     }
675 
676     // parseInt(parseFloat*10^_b)
677     function parseInt(string _a, uint _b) internal pure returns (uint) {
678         bytes memory bresult = bytes(_a);
679         uint mint = 0;
680         bool decimals = false;
681         for (uint i=0; i<bresult.length; i++){
682             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
683                 if (decimals){
684                    if (_b == 0) break;
685                     else _b--;
686                 }
687                 mint *= 10;
688                 mint += uint(bresult[i]) - 48;
689             } else if (bresult[i] == 46) decimals = true;
690         }
691         if (_b > 0) mint *= 10**_b;
692         return mint;
693     }
694 
695     function uint2str(uint i) internal pure returns (string){
696         if (i == 0) return "0";
697         uint j = i;
698         uint len;
699         while (j != 0){
700             len++;
701             j /= 10;
702         }
703         bytes memory bstr = new bytes(len);
704         uint k = len - 1;
705         while (i != 0){
706             bstr[k--] = byte(48 + i % 10);
707             i /= 10;
708         }
709         return string(bstr);
710     }
711 
712     function stra2cbor(string[] arr) internal pure returns (bytes) {
713             uint arrlen = arr.length;
714 
715             // get correct cbor output length
716             uint outputlen = 0;
717             bytes[] memory elemArray = new bytes[](arrlen);
718             for (uint i = 0; i < arrlen; i++) {
719                 elemArray[i] = (bytes(arr[i]));
720                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
721             }
722             uint ctr = 0;
723             uint cborlen = arrlen + 0x80;
724             outputlen += byte(cborlen).length;
725             bytes memory res = new bytes(outputlen);
726 
727             while (byte(cborlen).length > ctr) {
728                 res[ctr] = byte(cborlen)[ctr];
729                 ctr++;
730             }
731             for (i = 0; i < arrlen; i++) {
732                 res[ctr] = 0x5F;
733                 ctr++;
734                 for (uint x = 0; x < elemArray[i].length; x++) {
735                     // if there's a bug with larger strings, this may be the culprit
736                     if (x % 23 == 0) {
737                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
738                         elemcborlen += 0x40;
739                         uint lctr = ctr;
740                         while (byte(elemcborlen).length > ctr - lctr) {
741                             res[ctr] = byte(elemcborlen)[ctr - lctr];
742                             ctr++;
743                         }
744                     }
745                     res[ctr] = elemArray[i][x];
746                     ctr++;
747                 }
748                 res[ctr] = 0xFF;
749                 ctr++;
750             }
751             return res;
752         }
753 
754     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
755             uint arrlen = arr.length;
756 
757             // get correct cbor output length
758             uint outputlen = 0;
759             bytes[] memory elemArray = new bytes[](arrlen);
760             for (uint i = 0; i < arrlen; i++) {
761                 elemArray[i] = (bytes(arr[i]));
762                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
763             }
764             uint ctr = 0;
765             uint cborlen = arrlen + 0x80;
766             outputlen += byte(cborlen).length;
767             bytes memory res = new bytes(outputlen);
768 
769             while (byte(cborlen).length > ctr) {
770                 res[ctr] = byte(cborlen)[ctr];
771                 ctr++;
772             }
773             for (i = 0; i < arrlen; i++) {
774                 res[ctr] = 0x5F;
775                 ctr++;
776                 for (uint x = 0; x < elemArray[i].length; x++) {
777                     // if there's a bug with larger strings, this may be the culprit
778                     if (x % 23 == 0) {
779                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
780                         elemcborlen += 0x40;
781                         uint lctr = ctr;
782                         while (byte(elemcborlen).length > ctr - lctr) {
783                             res[ctr] = byte(elemcborlen)[ctr - lctr];
784                             ctr++;
785                         }
786                     }
787                     res[ctr] = elemArray[i][x];
788                     ctr++;
789                 }
790                 res[ctr] = 0xFF;
791                 ctr++;
792             }
793             return res;
794         }
795 
796 
797     string oraclize_network_name;
798     function oraclize_setNetworkName(string _network_name) internal {
799         oraclize_network_name = _network_name;
800     }
801 
802     function oraclize_getNetworkName() internal view returns (string) {
803         return oraclize_network_name;
804     }
805 
806     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
807         require((_nbytes > 0) && (_nbytes <= 32));
808         bytes memory nbytes = new bytes(1);
809         nbytes[0] = byte(_nbytes);
810         bytes memory unonce = new bytes(32);
811         bytes memory sessionKeyHash = new bytes(32);
812         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
813         assembly {
814             mstore(unonce, 0x20)
815             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
816             mstore(sessionKeyHash, 0x20)
817             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
818         }
819         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
820         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
821         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
822         return queryId;
823     }
824 
825     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
826         oraclize_randomDS_args[queryId] = commitment;
827     }
828 
829     mapping(bytes32=>bytes32) oraclize_randomDS_args;
830     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
831 
832     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
833         bool sigok;
834         address signer;
835 
836         bytes32 sigr;
837         bytes32 sigs;
838 
839         bytes memory sigr_ = new bytes(32);
840         uint offset = 4+(uint(dersig[3]) - 0x20);
841         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
842         bytes memory sigs_ = new bytes(32);
843         offset += 32 + 2;
844         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
845 
846         assembly {
847             sigr := mload(add(sigr_, 32))
848             sigs := mload(add(sigs_, 32))
849         }
850 
851 
852         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
853         if (address(keccak256(pubkey)) == signer) return true;
854         else {
855             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
856             return (address(keccak256(pubkey)) == signer);
857         }
858     }
859 
860     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
861         bool sigok;
862 
863         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
864         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
865         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
866 
867         bytes memory appkey1_pubkey = new bytes(64);
868         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
869 
870         bytes memory tosign2 = new bytes(1+65+32);
871         tosign2[0] = byte(1); //role
872         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
873         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
874         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
875         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
876 
877         if (sigok == false) return false;
878 
879 
880         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
881         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
882 
883         bytes memory tosign3 = new bytes(1+65);
884         tosign3[0] = 0xFE;
885         copyBytes(proof, 3, 65, tosign3, 1);
886 
887         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
888         copyBytes(proof, 3+65, sig3.length, sig3, 0);
889 
890         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
891 
892         return sigok;
893     }
894 
895     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
896         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
897         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
898 
899         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
900         require(proofVerified);
901 
902         _;
903     }
904 
905     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
906         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
907         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
908 
909         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
910         if (proofVerified == false) return 2;
911 
912         return 0;
913     }
914 
915     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
916         bool match_ = true;
917 
918 
919         for (uint256 i=0; i< n_random_bytes; i++) {
920             if (content[i] != prefix[i]) match_ = false;
921         }
922 
923         return match_;
924     }
925 
926     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
927 
928         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
929         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
930         bytes memory keyhash = new bytes(32);
931         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
932         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
933 
934         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
935         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
936 
937         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
938         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
939 
940         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
941         // This is to verify that the computed args match with the ones specified in the query.
942         bytes memory commitmentSlice1 = new bytes(8+1+32);
943         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
944 
945         bytes memory sessionPubkey = new bytes(64);
946         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
947         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
948 
949         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
950         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
951             delete oraclize_randomDS_args[queryId];
952         } else return false;
953 
954 
955         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
956         bytes memory tosign1 = new bytes(32+8+1+32);
957         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
958         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
959 
960         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
961         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
962             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
963         }
964 
965         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
966     }
967 
968     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
969     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
970         uint minLength = length + toOffset;
971 
972         // Buffer too small
973         require(to.length >= minLength); // Should be a better way?
974 
975         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
976         uint i = 32 + fromOffset;
977         uint j = 32 + toOffset;
978 
979         while (i < (32 + fromOffset + length)) {
980             assembly {
981                 let tmp := mload(add(from, i))
982                 mstore(add(to, j), tmp)
983             }
984             i += 32;
985             j += 32;
986         }
987 
988         return to;
989     }
990 
991     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
992     // Duplicate Solidity's ecrecover, but catching the CALL return value
993     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
994         // We do our own memory management here. Solidity uses memory offset
995         // 0x40 to store the current end of memory. We write past it (as
996         // writes are memory extensions), but don't update the offset so
997         // Solidity will reuse it. The memory used here is only needed for
998         // this context.
999 
1000         // FIXME: inline assembly can't access return values
1001         bool ret;
1002         address addr;
1003 
1004         assembly {
1005             let size := mload(0x40)
1006             mstore(size, hash)
1007             mstore(add(size, 32), v)
1008             mstore(add(size, 64), r)
1009             mstore(add(size, 96), s)
1010 
1011             // NOTE: we can reuse the request memory because we deal with
1012             //       the return code
1013             ret := call(3000, 1, 0, size, 128, size, 32)
1014             addr := mload(size)
1015         }
1016 
1017         return (ret, addr);
1018     }
1019 
1020     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1021     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1022         bytes32 r;
1023         bytes32 s;
1024         uint8 v;
1025 
1026         if (sig.length != 65)
1027           return (false, 0);
1028 
1029         // The signature format is a compact form of:
1030         //   {bytes32 r}{bytes32 s}{uint8 v}
1031         // Compact means, uint8 is not padded to 32 bytes.
1032         assembly {
1033             r := mload(add(sig, 32))
1034             s := mload(add(sig, 64))
1035 
1036             // Here we are loading the last 32 bytes. We exploit the fact that
1037             // 'mload' will pad with zeroes if we overread.
1038             // There is no 'mload8' to do this, but that would be nicer.
1039             v := byte(0, mload(add(sig, 96)))
1040 
1041             // Alternative solution:
1042             // 'byte' is not working due to the Solidity parser, so lets
1043             // use the second best option, 'and'
1044             // v := and(mload(add(sig, 65)), 255)
1045         }
1046 
1047         // albeit non-transactional signatures are not specified by the YP, one would expect it
1048         // to match the YP range of [27, 28]
1049         //
1050         // geth uses [0, 1] and some clients have followed. This might change, see:
1051         //  https://github.com/ethereum/go-ethereum/issues/2053
1052         if (v < 27)
1053           v += 27;
1054 
1055         if (v != 27 && v != 28)
1056             return (false, 0);
1057 
1058         return safer_ecrecover(hash, v, r, s);
1059     }
1060 
1061 }
1062 // </ORACLIZE_API>
1063 
1064 
1065 /**
1066  * @title SafeMath
1067  * @dev Math operations with safety checks that throw on error
1068  */
1069 library SafeMath {
1070 
1071   /**
1072   * @dev Multiplies two numbers, throws on overflow.
1073   */
1074   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1075     if (a == 0) {
1076       return 0;
1077     }
1078     uint256 c = a * b;
1079     assert(c / a == b);
1080     return c;
1081   }
1082 
1083   /**
1084   * @dev Integer division of two numbers, truncating the quotient.
1085   */
1086   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1087     // assert(b > 0); // Solidity automatically throws when dividing by 0
1088     uint256 c = a / b;
1089     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1090     return c;
1091   }
1092 
1093   /**
1094   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1095   */
1096   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1097     assert(b <= a);
1098     return a - b;
1099   }
1100 
1101   /**
1102   * @dev Adds two numbers, throws on overflow.
1103   */
1104   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1105     uint256 c = a + b;
1106     assert(c >= a);
1107     return c;
1108   }
1109 }
1110 
1111 
1112 /**
1113  * @title ERC20Basic
1114  * @dev Simpler version of ERC20 interface
1115  * @dev see https://github.com/ethereum/EIPs/issues/179
1116  */
1117 contract ERC20Basic {
1118   function totalSupply() public view returns (uint256);
1119   function balanceOf(address who) public view returns (uint256);
1120   function transfer(address to, uint256 value) public returns (bool);
1121   event Transfer(address indexed from, address indexed to, uint256 value);
1122 }
1123 
1124 
1125 /**
1126  * @title ERC20 interface
1127  * @dev see https://github.com/ethereum/EIPs/issues/20
1128  */
1129 contract ERC20 is ERC20Basic {
1130   function allowance(address owner, address spender) public view returns (uint256);
1131   function transferFrom(address from, address to, uint256 value) public returns (bool);
1132   function approve(address spender, uint256 value) public returns (bool);
1133   event Approval(address indexed owner, address indexed spender, uint256 value);
1134 }
1135 
1136 
1137 /**
1138  * @title SafeERC20
1139  * @dev Wrappers around ERC20 operations that throw on failure.
1140  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1141  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1142  */
1143 library SafeERC20 {
1144   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
1145     assert(token.transfer(to, value));
1146   }
1147 
1148   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
1149     assert(token.transferFrom(from, to, value));
1150   }
1151 
1152   function safeApprove(ERC20 token, address spender, uint256 value) internal {
1153     assert(token.approve(spender, value));
1154   }
1155 }
1156 
1157 
1158 /**
1159  * @title Contracts that should be able to recover tokens
1160  * @author SylTi
1161  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
1162  * This will prevent any accidental loss of tokens.
1163  */
1164 contract CanReclaimToken is Ownable {
1165   using SafeERC20 for ERC20Basic;
1166 
1167   /**
1168    * @dev Reclaim all ERC20Basic compatible tokens
1169    * @param token ERC20Basic The address of the token contract
1170    */
1171   function reclaimToken(ERC20Basic token) external onlyOwner {
1172     uint256 balance = token.balanceOf(this);
1173     token.safeTransfer(owner, balance);
1174   }
1175 
1176 }
1177 
1178 
1179 /**
1180  * @title Contracts that should not own Tokens
1181  * @author Remco Bloemen <remco@2π.com>
1182  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
1183  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
1184  * owner to reclaim the tokens.
1185  */
1186 contract HasNoTokens is CanReclaimToken {
1187 
1188  /**
1189   * @dev Reject all ERC223 compatible tokens
1190   * @param from_ address The address that is transferring the tokens
1191   * @param value_ uint256 the amount of the specified token
1192   * @param data_ Bytes The data passed from the caller.
1193   */
1194   function tokenFallback(address from_, uint256 value_, bytes data_) external {
1195     from_;
1196     value_;
1197     data_;
1198     revert();
1199   }
1200 
1201 }
1202 
1203 
1204 /**
1205  * @title Contracts that should not own Contracts
1206  * @author Remco Bloemen <remco@2π.com>
1207  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
1208  * of this contract to reclaim ownership of the contracts.
1209  */
1210 contract HasNoContracts is Ownable {
1211 
1212   /**
1213    * @dev Reclaim ownership of Ownable contracts
1214    * @param contractAddr The address of the Ownable to be reclaimed.
1215    */
1216   function reclaimContract(address contractAddr) external onlyOwner {
1217     Ownable contractInst = Ownable(contractAddr);
1218     contractInst.transferOwnership(owner);
1219   }
1220 }
1221 
1222 
1223 /**
1224  * @title BetexSAFT
1225  * @dev BetexSAFT is a registry contract for a
1226  * Betex Simple Agreement for Future Tokens campaign.
1227  */
1228 contract BetexSAFT is usingOraclize, HasNoContracts, HasNoTokens {
1229     using SafeMath for uint256;
1230 
1231     // start timestamp
1232     uint256 public startTime;
1233 
1234     // end timestamp
1235     uint256 public endTime;
1236 
1237     // wallet address to trasfer direct funding to
1238     address public wallet;
1239 
1240     // collector struct
1241     struct Collector {
1242         bytes3 symbol;
1243         uint8 decimals;
1244         string rateUrl;
1245     }
1246 
1247     // list of collectors
1248     // index 0 ETH
1249     // index 1 BTC
1250     Collector[] public collectors;
1251 
1252     // collectors count
1253     uint8 public collectorsCount;
1254 
1255     // tokens sold
1256     uint256 public sold;
1257 
1258     // raised by collector
1259     mapping (uint8 => uint256) public raised;
1260 
1261     // funders tokens
1262     mapping(uint128 => uint256) public purchased;
1263 
1264     // funded by funder and collector
1265     mapping (uint128 => mapping(uint8 => uint256)) public funded;
1266 
1267     // oraclize funding order
1268     struct Order {
1269         uint128 funderId;
1270         uint8 collector;
1271         uint256 funds;
1272         uint256 rate;
1273     }
1274 
1275     // oraclize funding orders
1276     mapping (bytes32 => Order) public orders;
1277 
1278     // store outer funding transactions to prevent double usage
1279     mapping (uint256 => bool) public transactions;
1280 
1281     // address to funderId mapping for direct funding;
1282     mapping (address => uint128) public direct;
1283 
1284     // addresses authorized to refill the contract (for oraclize queries)
1285     mapping (address => bool) public refillers;
1286 
1287     // list of funders who failed KYC
1288     uint128[] public failedKycList;
1289 
1290     // count of funders who failed KYC
1291     uint256 public failedKycCount;
1292 
1293     // mapping to know if KYC failed
1294     mapping(uint128 => bool) public isKycFailed;
1295 
1296     // oraclize gas limit
1297     uint256 public oraclizeGasLimit = 200000;
1298 
1299     // max collectors
1300     uint8 public MAX_COLLECTORS = 2;
1301 
1302     // rate exponent
1303     uint256 public constant RATE_EXPONENT = 4;
1304 
1305     // token price usd
1306     uint256 public constant TOKEN_PRICE = 3;
1307 
1308     // token decimals
1309     uint256 public constant TOKEN_DECIMALS = 18;
1310 
1311     // hard cap of tokens proposed to purchase
1312     uint256 public constant TOKENS_HARD_CAP = 3000000 * (10 ** TOKEN_DECIMALS);
1313 
1314     /**
1315      * event for funding order logging
1316      * @param funderId funder who has done the order
1317      * @param orderId oraclize orderId
1318      */
1319     event OrderEvent(uint128 indexed funderId, bytes32 indexed orderId);
1320 
1321     /**
1322      * event for token purchase logging
1323      * @param funderId funder who paid for the tokens
1324      * @param orderId oraclize orderId
1325      * @param tokens amount of tokens purchased
1326      */
1327     event TokenPurchaseEvent(uint128 indexed funderId, bytes32 indexed orderId, uint256 tokens);
1328 
1329     /**
1330      * event for failed KYC logging
1331      * @param funderId funder who fail KYC
1332      */
1333     event KycFailedEvent(uint128 indexed funderId);
1334 
1335     /**
1336      * event for direct funding logging
1337      * @param funderId funder who has done the payment
1338      * @param sender funder address funds sent from
1339      * @param funds funds sent by funder
1340      */
1341     event DirectFundingEvent(uint128 indexed funderId, address indexed sender, uint256 funds);
1342 
1343     /**
1344      * event for direct map logging
1345      * @param sender sender address
1346      * @param funderId funderId mapped to sender address
1347      */
1348     event DirectMapEvent(address indexed sender, uint128 indexed funderId);
1349 
1350 
1351     /**
1352      * CONSTRUCTOR
1353      *
1354      * @dev Initialize the BetexSAFT
1355      * @param _startTime start time
1356      * @param _endTime end time
1357      * @param _wallet wallet address to transfer direct funding to
1358      */
1359     function BetexSAFT(uint256 _startTime, uint256 _endTime, address _wallet) public {
1360         require(_startTime < _endTime);
1361         require(_wallet != address(0));
1362 
1363         startTime = _startTime;
1364         endTime = _endTime;
1365         wallet = _wallet;
1366     }
1367 
1368     // Accepts ether to contract for oraclize queries and direct funding
1369     function () public payable {
1370         require(msg.value > 0);
1371 
1372         address _sender = msg.sender;
1373 
1374         if (direct[_sender] != 0) {
1375             uint128 _funderId = direct[_sender];
1376             uint8 _collector = 0;
1377             uint256 _funds = msg.value;
1378 
1379             require(_funds >= 0.5 ether);
1380 
1381             DirectFundingEvent(_funderId, _sender, _funds);
1382 
1383             _order(_funderId, _collector, _funds);
1384 
1385             wallet.transfer(_funds);
1386         } else if (!refillers[_sender] && !(owner == _sender)) {
1387             revert();
1388         }
1389     }
1390 
1391     /**
1392      * @dev Makes order for tokens purchase.
1393      * @param _funderId funder who paid for the tokens
1394      * @param _collector collector index
1395      * @param _funds amount of the funds
1396      * @param _tx hash of the outer funding transaction
1397      */
1398     function order(uint128 _funderId, uint8 _collector, uint256 _funds, uint256 _tx) onlyOwner public { // solium-disable-line arg-overflow
1399         require(_tx > 0);
1400         require(!transactions[_tx]);
1401 
1402         transactions[_tx] = true;
1403 
1404         _order(_funderId, _collector, _funds);
1405     }
1406 
1407     /**
1408      * @dev Get current rate from oraclize and sell tokens.
1409      * @param _orderId oraclize order id
1410      * @param _result current rate of the specified collector's currency
1411      */
1412     function __callback(bytes32 _orderId, string _result) public {  // solium-disable-line mixedcase
1413         require(msg.sender == oraclize_cbAddress());
1414 
1415         uint256 _rate = parseInt(_result, RATE_EXPONENT);
1416 
1417         uint128 _funderId = orders[_orderId].funderId;
1418         uint8 _collector = orders[_orderId].collector;
1419         uint256 _funds = orders[_orderId].funds;
1420 
1421         uint8 COLLECTOR_DECIMALS = collectors[_collector].decimals; // solium-disable-line mixedcase
1422 
1423         uint256 _sum = _funds.mul(_rate);
1424 
1425         _sum = _sum.mul(10 ** (TOKEN_DECIMALS - COLLECTOR_DECIMALS));
1426         _sum = _sum.div(10 ** RATE_EXPONENT);
1427 
1428         uint256 _tokens = _sum.div(TOKEN_PRICE);
1429 
1430         if (sold.add(_tokens) > TOKENS_HARD_CAP) {
1431             _tokens = TOKENS_HARD_CAP.sub(sold);
1432         }
1433 
1434         orders[_orderId].rate = _rate;
1435 
1436         purchased[_funderId] = purchased[_funderId].add(_tokens);
1437         sold = sold.add(_tokens);
1438 
1439         funded[_funderId][_collector] = funded[_funderId][_collector].add(_funds);
1440         raised[_collector] = raised[_collector].add(_funds);
1441 
1442         TokenPurchaseEvent(_funderId, _orderId, _tokens);
1443     }
1444 
1445     /**
1446      * @dev Add funder to KYC failed list
1447      * @param _funderId who failed KYC
1448      */
1449     function failedKyc(uint128 _funderId) onlyOwner public {
1450         require(now <= endTime + 2 weeks); // solium-disable-line security/no-block-members
1451         require(_funderId != 0);
1452         require(!isKycFailed[_funderId]);
1453 
1454         failedKycList.push(_funderId);
1455         isKycFailed[_funderId] = true;
1456         failedKycCount++;
1457 
1458         KycFailedEvent(_funderId);
1459     }
1460 
1461     /**
1462      * @dev Add a refiller
1463      * @param _refiller address that authorized to refill the contract
1464      */
1465     function addRefiller(address _refiller) onlyOwner public {
1466         require(_refiller != address(0));
1467         refillers[_refiller] = true;
1468     }
1469 
1470     /**
1471      * @dev Add a direct funding map
1472      * @param _sender funder address funds sent from
1473      * @param _funderId funderId mapped to sender
1474      */
1475     function addDirect(address _sender, uint128 _funderId) onlyOwner public {
1476         require(_sender != address(0));
1477         require(_funderId != 0);
1478         require(direct[_sender] == 0);
1479 
1480         direct[_sender] = _funderId;
1481 
1482         DirectMapEvent(_sender, _funderId);
1483     }
1484 
1485     /**
1486      * @dev Add a collector
1487      * @param _symbol currency symbol of collector
1488      * @param _decimals currency decimals of collector
1489      * @param _rateUrl url to get collector's currency rate
1490      */
1491     function addCollector(bytes3 _symbol, uint8 _decimals, string _rateUrl) onlyOwner public {
1492         require(collectorsCount < MAX_COLLECTORS);
1493 
1494         Collector memory _collector = Collector(_symbol, _decimals, _rateUrl);
1495         collectors.push(_collector);
1496 
1497         collectorsCount++;
1498     }
1499 
1500     /**
1501      * @dev Set oraclize gas limit
1502      * @param _gasLimit a new oraclize gas limit
1503      */
1504     function setOraclizeGasLimit(uint256 _gasLimit) onlyOwner public {
1505         require(_gasLimit > 0);
1506         oraclizeGasLimit = _gasLimit;
1507     }
1508 
1509     /**
1510      * @dev Set oraclize gas price
1511      * @param _gasPrice a new oraclize gas price
1512      */
1513     function setOraclizeGasPrice(uint256 _gasPrice) onlyOwner public {
1514         require(_gasPrice > 0);
1515         oraclize_setCustomGasPrice(_gasPrice);
1516     }
1517 
1518     /**
1519      * @dev Withdraw ether from contract
1520      * @param _amount amount to withdraw
1521      */
1522     function withdrawEther(uint256 _amount) onlyOwner public {
1523         require(this.balance >= _amount);
1524         owner.transfer(_amount);
1525     }
1526 
1527     /**
1528      * @dev Makes order for tokens purchase.
1529      * @param _funderId who paid for the tokens
1530      * @param _collector collector index
1531      * @param _funds amount of transferred funds
1532      */
1533     function _order(uint128 _funderId, uint8 _collector, uint256 _funds) internal { // solium-disable-line arg-overflow
1534         require(liveSAFTCampaign());
1535         require(oraclize_getPrice("URL") <= this.balance);
1536         require(_funderId != 0);
1537         require(!isKycFailed[_funderId]);
1538         require(_collector < collectorsCount);
1539         require(_funds > 0);
1540 
1541         bytes32 _orderId = oraclize_query("URL", collectors[_collector].rateUrl, oraclizeGasLimit);
1542 
1543         orders[_orderId].funderId = _funderId;
1544         orders[_orderId].collector = _collector;
1545         orders[_orderId].funds = _funds;
1546 
1547         OrderEvent(_funderId, _orderId);
1548     }
1549 
1550     // @return true if the SAFT campaign is alive
1551     function liveSAFTCampaign() internal view returns (bool) {
1552         return now >= startTime && now <= endTime && sold < TOKENS_HARD_CAP; // solium-disable-line security/no-block-members
1553     }
1554 }