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
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42   /**
43    * @dev Allows the current owner to relinquish control of the contract.
44    */
45   function renounceOwnership() public onlyOwner {
46     emit OwnershipRenounced(owner);
47     owner = address(0);
48   }
49 }
50 
51 // <ORACLIZE_API>
52 /*
53 Copyright (c) 2015-2016 Oraclize SRL
54 Copyright (c) 2016 Oraclize LTD
55 
56 
57 
58 Permission is hereby granted, free of charge, to any person obtaining a copy
59 of this software and associated documentation files (the "Software"), to deal
60 in the Software without restriction, including without limitation the rights
61 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
62 copies of the Software, and to permit persons to whom the Software is
63 furnished to do so, subject to the following conditions:
64 
65 
66 
67 The above copyright notice and this permission notice shall be included in
68 all copies or substantial portions of the Software.
69 
70 
71 
72 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
73 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
74 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
75 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
76 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
77 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
78 THE SOFTWARE.
79 */
80 
81 //please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
82 
83 contract OraclizeI {
84     address public cbAddress;
85     function query(uint _timestamp, string _datasource, string _arg) public payable returns (bytes32 _id);
86     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) public payable returns (bytes32 _id);
87     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
88     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) public payable returns (bytes32 _id);
89     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
90     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) public payable returns (bytes32 _id);
91     function getPrice(string _datasource) public returns (uint _dsprice);
92     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
93     function useCoupon(string _coupon) public;
94     function setProofType(byte _proofType) public;
95     function setConfig(bytes32 _config) public;
96     function setCustomGasPrice(uint _gasPrice) public;
97     function randomDS_getSessionPubKeyHash() public returns(bytes32);
98 }
99 contract OraclizeAddrResolverI {
100     function getAddress() public returns (address _addr);
101 }
102 contract usingOraclize {
103     uint constant day = 60*60*24;
104     uint constant week = 60*60*24*7;
105     uint constant month = 60*60*24*30;
106     byte constant proofType_NONE = 0x00;
107     byte constant proofType_TLSNotary = 0x10;
108     byte constant proofType_Android = 0x20;
109     byte constant proofType_Ledger = 0x30;
110     byte constant proofType_Native = 0xF0;
111     byte constant proofStorage_IPFS = 0x01;
112     uint8 constant networkID_auto = 0;
113     uint8 constant networkID_mainnet = 1;
114     uint8 constant networkID_testnet = 2;
115     uint8 constant networkID_morden = 2;
116     uint8 constant networkID_consensys = 161;
117 
118     OraclizeAddrResolverI OAR;
119 
120     OraclizeI oraclize;
121     modifier oraclizeAPI {
122         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
123         oraclize = OraclizeI(OAR.getAddress());
124         _;
125     }
126     modifier coupon(string code){
127         oraclize = OraclizeI(OAR.getAddress());
128         oraclize.useCoupon(code);
129         _;
130     }
131 
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
167 
168     function __callback(bytes32 myid, string result) public {
169         __callback(myid, result, new bytes(0));
170     }
171     function __callback(bytes32 myid, string result, bytes proof) public {
172     }
173 
174     function oraclize_useCoupon(string code) oraclizeAPI internal {
175         oraclize.useCoupon(code);
176     }
177 
178     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
179         return oraclize.getPrice(datasource);
180     }
181 
182     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
183         return oraclize.getPrice(datasource, gaslimit);
184     }
185 
186     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
187         uint price = oraclize.getPrice(datasource);
188         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
189         return oraclize.query.value(price)(0, datasource, arg);
190     }
191     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
192         uint price = oraclize.getPrice(datasource);
193         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
194         return oraclize.query.value(price)(timestamp, datasource, arg);
195     }
196     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
197         uint price = oraclize.getPrice(datasource, gaslimit);
198         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
199         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
200     }
201     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
202         uint price = oraclize.getPrice(datasource, gaslimit);
203         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
204         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
205     }
206     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
207         uint price = oraclize.getPrice(datasource);
208         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
209         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
210     }
211     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
212         uint price = oraclize.getPrice(datasource);
213         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
214         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
215     }
216     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
217         uint price = oraclize.getPrice(datasource, gaslimit);
218         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
219         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
220     }
221     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
222         uint price = oraclize.getPrice(datasource, gaslimit);
223         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
224         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
225     }
226     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
227         uint price = oraclize.getPrice(datasource);
228         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
229         bytes memory args = stra2cbor(argN);
230         return oraclize.queryN.value(price)(0, datasource, args);
231     }
232     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
233         uint price = oraclize.getPrice(datasource);
234         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
235         bytes memory args = stra2cbor(argN);
236         return oraclize.queryN.value(price)(timestamp, datasource, args);
237     }
238     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
239         uint price = oraclize.getPrice(datasource, gaslimit);
240         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
241         bytes memory args = stra2cbor(argN);
242         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
243     }
244     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
245         uint price = oraclize.getPrice(datasource, gaslimit);
246         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
247         bytes memory args = stra2cbor(argN);
248         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
249     }
250     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
251         string[] memory dynargs = new string[](1);
252         dynargs[0] = args[0];
253         return oraclize_query(datasource, dynargs);
254     }
255     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
256         string[] memory dynargs = new string[](1);
257         dynargs[0] = args[0];
258         return oraclize_query(timestamp, datasource, dynargs);
259     }
260     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
261         string[] memory dynargs = new string[](1);
262         dynargs[0] = args[0];
263         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
264     }
265     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
266         string[] memory dynargs = new string[](1);
267         dynargs[0] = args[0];
268         return oraclize_query(datasource, dynargs, gaslimit);
269     }
270 
271     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
272         string[] memory dynargs = new string[](2);
273         dynargs[0] = args[0];
274         dynargs[1] = args[1];
275         return oraclize_query(datasource, dynargs);
276     }
277     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
278         string[] memory dynargs = new string[](2);
279         dynargs[0] = args[0];
280         dynargs[1] = args[1];
281         return oraclize_query(timestamp, datasource, dynargs);
282     }
283     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
284         string[] memory dynargs = new string[](2);
285         dynargs[0] = args[0];
286         dynargs[1] = args[1];
287         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
288     }
289     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
290         string[] memory dynargs = new string[](2);
291         dynargs[0] = args[0];
292         dynargs[1] = args[1];
293         return oraclize_query(datasource, dynargs, gaslimit);
294     }
295     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
296         string[] memory dynargs = new string[](3);
297         dynargs[0] = args[0];
298         dynargs[1] = args[1];
299         dynargs[2] = args[2];
300         return oraclize_query(datasource, dynargs);
301     }
302     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
303         string[] memory dynargs = new string[](3);
304         dynargs[0] = args[0];
305         dynargs[1] = args[1];
306         dynargs[2] = args[2];
307         return oraclize_query(timestamp, datasource, dynargs);
308     }
309     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
310         string[] memory dynargs = new string[](3);
311         dynargs[0] = args[0];
312         dynargs[1] = args[1];
313         dynargs[2] = args[2];
314         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
315     }
316     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
317         string[] memory dynargs = new string[](3);
318         dynargs[0] = args[0];
319         dynargs[1] = args[1];
320         dynargs[2] = args[2];
321         return oraclize_query(datasource, dynargs, gaslimit);
322     }
323 
324     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
325         string[] memory dynargs = new string[](4);
326         dynargs[0] = args[0];
327         dynargs[1] = args[1];
328         dynargs[2] = args[2];
329         dynargs[3] = args[3];
330         return oraclize_query(datasource, dynargs);
331     }
332     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
333         string[] memory dynargs = new string[](4);
334         dynargs[0] = args[0];
335         dynargs[1] = args[1];
336         dynargs[2] = args[2];
337         dynargs[3] = args[3];
338         return oraclize_query(timestamp, datasource, dynargs);
339     }
340     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
341         string[] memory dynargs = new string[](4);
342         dynargs[0] = args[0];
343         dynargs[1] = args[1];
344         dynargs[2] = args[2];
345         dynargs[3] = args[3];
346         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
347     }
348     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
349         string[] memory dynargs = new string[](4);
350         dynargs[0] = args[0];
351         dynargs[1] = args[1];
352         dynargs[2] = args[2];
353         dynargs[3] = args[3];
354         return oraclize_query(datasource, dynargs, gaslimit);
355     }
356     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
357         string[] memory dynargs = new string[](5);
358         dynargs[0] = args[0];
359         dynargs[1] = args[1];
360         dynargs[2] = args[2];
361         dynargs[3] = args[3];
362         dynargs[4] = args[4];
363         return oraclize_query(datasource, dynargs);
364     }
365     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
366         string[] memory dynargs = new string[](5);
367         dynargs[0] = args[0];
368         dynargs[1] = args[1];
369         dynargs[2] = args[2];
370         dynargs[3] = args[3];
371         dynargs[4] = args[4];
372         return oraclize_query(timestamp, datasource, dynargs);
373     }
374     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
375         string[] memory dynargs = new string[](5);
376         dynargs[0] = args[0];
377         dynargs[1] = args[1];
378         dynargs[2] = args[2];
379         dynargs[3] = args[3];
380         dynargs[4] = args[4];
381         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
382     }
383     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
384         string[] memory dynargs = new string[](5);
385         dynargs[0] = args[0];
386         dynargs[1] = args[1];
387         dynargs[2] = args[2];
388         dynargs[3] = args[3];
389         dynargs[4] = args[4];
390         return oraclize_query(datasource, dynargs, gaslimit);
391     }
392     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
393         uint price = oraclize.getPrice(datasource);
394         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
395         bytes memory args = ba2cbor(argN);
396         return oraclize.queryN.value(price)(0, datasource, args);
397     }
398     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
399         uint price = oraclize.getPrice(datasource);
400         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
401         bytes memory args = ba2cbor(argN);
402         return oraclize.queryN.value(price)(timestamp, datasource, args);
403     }
404     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
405         uint price = oraclize.getPrice(datasource, gaslimit);
406         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
407         bytes memory args = ba2cbor(argN);
408         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
409     }
410     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
411         uint price = oraclize.getPrice(datasource, gaslimit);
412         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
413         bytes memory args = ba2cbor(argN);
414         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
415     }
416     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
417         bytes[] memory dynargs = new bytes[](1);
418         dynargs[0] = args[0];
419         return oraclize_query(datasource, dynargs);
420     }
421     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
422         bytes[] memory dynargs = new bytes[](1);
423         dynargs[0] = args[0];
424         return oraclize_query(timestamp, datasource, dynargs);
425     }
426     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
427         bytes[] memory dynargs = new bytes[](1);
428         dynargs[0] = args[0];
429         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
430     }
431     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
432         bytes[] memory dynargs = new bytes[](1);
433         dynargs[0] = args[0];
434         return oraclize_query(datasource, dynargs, gaslimit);
435     }
436 
437     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
438         bytes[] memory dynargs = new bytes[](2);
439         dynargs[0] = args[0];
440         dynargs[1] = args[1];
441         return oraclize_query(datasource, dynargs);
442     }
443     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
444         bytes[] memory dynargs = new bytes[](2);
445         dynargs[0] = args[0];
446         dynargs[1] = args[1];
447         return oraclize_query(timestamp, datasource, dynargs);
448     }
449     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
450         bytes[] memory dynargs = new bytes[](2);
451         dynargs[0] = args[0];
452         dynargs[1] = args[1];
453         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
454     }
455     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
456         bytes[] memory dynargs = new bytes[](2);
457         dynargs[0] = args[0];
458         dynargs[1] = args[1];
459         return oraclize_query(datasource, dynargs, gaslimit);
460     }
461     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
462         bytes[] memory dynargs = new bytes[](3);
463         dynargs[0] = args[0];
464         dynargs[1] = args[1];
465         dynargs[2] = args[2];
466         return oraclize_query(datasource, dynargs);
467     }
468     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
469         bytes[] memory dynargs = new bytes[](3);
470         dynargs[0] = args[0];
471         dynargs[1] = args[1];
472         dynargs[2] = args[2];
473         return oraclize_query(timestamp, datasource, dynargs);
474     }
475     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
476         bytes[] memory dynargs = new bytes[](3);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         dynargs[2] = args[2];
480         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
481     }
482     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
483         bytes[] memory dynargs = new bytes[](3);
484         dynargs[0] = args[0];
485         dynargs[1] = args[1];
486         dynargs[2] = args[2];
487         return oraclize_query(datasource, dynargs, gaslimit);
488     }
489 
490     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
491         bytes[] memory dynargs = new bytes[](4);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         dynargs[2] = args[2];
495         dynargs[3] = args[3];
496         return oraclize_query(datasource, dynargs);
497     }
498     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
499         bytes[] memory dynargs = new bytes[](4);
500         dynargs[0] = args[0];
501         dynargs[1] = args[1];
502         dynargs[2] = args[2];
503         dynargs[3] = args[3];
504         return oraclize_query(timestamp, datasource, dynargs);
505     }
506     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
507         bytes[] memory dynargs = new bytes[](4);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         dynargs[3] = args[3];
512         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
513     }
514     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
515         bytes[] memory dynargs = new bytes[](4);
516         dynargs[0] = args[0];
517         dynargs[1] = args[1];
518         dynargs[2] = args[2];
519         dynargs[3] = args[3];
520         return oraclize_query(datasource, dynargs, gaslimit);
521     }
522     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
523         bytes[] memory dynargs = new bytes[](5);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         dynargs[3] = args[3];
528         dynargs[4] = args[4];
529         return oraclize_query(datasource, dynargs);
530     }
531     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
532         bytes[] memory dynargs = new bytes[](5);
533         dynargs[0] = args[0];
534         dynargs[1] = args[1];
535         dynargs[2] = args[2];
536         dynargs[3] = args[3];
537         dynargs[4] = args[4];
538         return oraclize_query(timestamp, datasource, dynargs);
539     }
540     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
541         bytes[] memory dynargs = new bytes[](5);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         dynargs[4] = args[4];
547         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
548     }
549     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
550         bytes[] memory dynargs = new bytes[](5);
551         dynargs[0] = args[0];
552         dynargs[1] = args[1];
553         dynargs[2] = args[2];
554         dynargs[3] = args[3];
555         dynargs[4] = args[4];
556         return oraclize_query(datasource, dynargs, gaslimit);
557     }
558 
559     function oraclize_cbAddress() oraclizeAPI internal returns (address){
560         return oraclize.cbAddress();
561     }
562     function oraclize_setProof(byte proofP) oraclizeAPI internal {
563         return oraclize.setProofType(proofP);
564     }
565     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
566         return oraclize.setCustomGasPrice(gasPrice);
567     }
568     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
569         return oraclize.setConfig(config);
570     }
571 
572     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
573         return oraclize.randomDS_getSessionPubKeyHash();
574     }
575 
576     function getCodeSize(address _addr) constant internal returns(uint _size) {
577         assembly {
578             _size := extcodesize(_addr)
579         }
580     }
581 
582     function parseAddr(string _a) internal pure returns (address){
583         bytes memory tmp = bytes(_a);
584         uint160 iaddr = 0;
585         uint160 b1;
586         uint160 b2;
587         for (uint i=2; i<2+2*20; i+=2){
588             iaddr *= 256;
589             b1 = uint160(tmp[i]);
590             b2 = uint160(tmp[i+1]);
591             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
592             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
593             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
594             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
595             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
596             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
597             iaddr += (b1*16+b2);
598         }
599         return address(iaddr);
600     }
601 
602     function strCompare(string _a, string _b) internal pure returns (int) {
603         bytes memory a = bytes(_a);
604         bytes memory b = bytes(_b);
605         uint minLength = a.length;
606         if (b.length < minLength) minLength = b.length;
607         for (uint i = 0; i < minLength; i ++)
608             if (a[i] < b[i])
609                 return -1;
610             else if (a[i] > b[i])
611                 return 1;
612         if (a.length < b.length)
613             return -1;
614         else if (a.length > b.length)
615             return 1;
616         else
617             return 0;
618     }
619 
620     function indexOf(string _haystack, string _needle) internal pure returns (int) {
621         bytes memory h = bytes(_haystack);
622         bytes memory n = bytes(_needle);
623         if(h.length < 1 || n.length < 1 || (n.length > h.length))
624             return -1;
625         else if(h.length > (2**128 -1))
626             return -1;
627         else
628         {
629             uint subindex = 0;
630             for (uint i = 0; i < h.length; i ++)
631             {
632                 if (h[i] == n[0])
633                 {
634                     subindex = 1;
635                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
636                     {
637                         subindex++;
638                     }
639                     if(subindex == n.length)
640                         return int(i);
641                 }
642             }
643             return -1;
644         }
645     }
646 
647     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
648         bytes memory _ba = bytes(_a);
649         bytes memory _bb = bytes(_b);
650         bytes memory _bc = bytes(_c);
651         bytes memory _bd = bytes(_d);
652         bytes memory _be = bytes(_e);
653         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
654         bytes memory babcde = bytes(abcde);
655         uint k = 0;
656         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
657         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
658         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
659         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
660         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
661         return string(babcde);
662     }
663 
664     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
665         return strConcat(_a, _b, _c, _d, "");
666     }
667 
668     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
669         return strConcat(_a, _b, _c, "", "");
670     }
671 
672     function strConcat(string _a, string _b) internal pure returns (string) {
673         return strConcat(_a, _b, "", "", "");
674     }
675 
676     // parseInt
677     function parseInt(string _a) internal pure returns (uint) {
678         return parseInt(_a, 0);
679     }
680 
681     // parseInt(parseFloat*10^_b)
682     function parseInt(string _a, uint _b) internal pure returns (uint) {
683         bytes memory bresult = bytes(_a);
684         uint mint = 0;
685         bool decimals = false;
686         for (uint i=0; i<bresult.length; i++){
687             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
688                 if (decimals){
689                    if (_b == 0) break;
690                     else _b--;
691                 }
692                 mint *= 10;
693                 mint += uint(bresult[i]) - 48;
694             } else if (bresult[i] == 46) decimals = true;
695         }
696         if (_b > 0) mint *= 10**_b;
697         return mint;
698     }
699 
700     function uint2str(uint i) internal pure returns (string){
701         if (i == 0) return "0";
702         uint j = i;
703         uint len;
704         while (j != 0){
705             len++;
706             j /= 10;
707         }
708         bytes memory bstr = new bytes(len);
709         uint k = len - 1;
710         while (i != 0){
711             bstr[k--] = byte(48 + i % 10);
712             i /= 10;
713         }
714         return string(bstr);
715     }
716 
717     function stra2cbor(string[] arr) internal pure returns (bytes) {
718             uint arrlen = arr.length;
719 
720             // get correct cbor output length
721             uint outputlen = 0;
722             bytes[] memory elemArray = new bytes[](arrlen);
723             for (uint i = 0; i < arrlen; i++) {
724                 elemArray[i] = (bytes(arr[i]));
725                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
726             }
727             uint ctr = 0;
728             uint cborlen = arrlen + 0x80;
729             outputlen += byte(cborlen).length;
730             bytes memory res = new bytes(outputlen);
731 
732             while (byte(cborlen).length > ctr) {
733                 res[ctr] = byte(cborlen)[ctr];
734                 ctr++;
735             }
736             for (i = 0; i < arrlen; i++) {
737                 res[ctr] = 0x5F;
738                 ctr++;
739                 for (uint x = 0; x < elemArray[i].length; x++) {
740                     // if there's a bug with larger strings, this may be the culprit
741                     if (x % 23 == 0) {
742                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
743                         elemcborlen += 0x40;
744                         uint lctr = ctr;
745                         while (byte(elemcborlen).length > ctr - lctr) {
746                             res[ctr] = byte(elemcborlen)[ctr - lctr];
747                             ctr++;
748                         }
749                     }
750                     res[ctr] = elemArray[i][x];
751                     ctr++;
752                 }
753                 res[ctr] = 0xFF;
754                 ctr++;
755             }
756             return res;
757         }
758 
759     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
760             uint arrlen = arr.length;
761 
762             // get correct cbor output length
763             uint outputlen = 0;
764             bytes[] memory elemArray = new bytes[](arrlen);
765             for (uint i = 0; i < arrlen; i++) {
766                 elemArray[i] = (bytes(arr[i]));
767                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
768             }
769             uint ctr = 0;
770             uint cborlen = arrlen + 0x80;
771             outputlen += byte(cborlen).length;
772             bytes memory res = new bytes(outputlen);
773 
774             while (byte(cborlen).length > ctr) {
775                 res[ctr] = byte(cborlen)[ctr];
776                 ctr++;
777             }
778             for (i = 0; i < arrlen; i++) {
779                 res[ctr] = 0x5F;
780                 ctr++;
781                 for (uint x = 0; x < elemArray[i].length; x++) {
782                     // if there's a bug with larger strings, this may be the culprit
783                     if (x % 23 == 0) {
784                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
785                         elemcborlen += 0x40;
786                         uint lctr = ctr;
787                         while (byte(elemcborlen).length > ctr - lctr) {
788                             res[ctr] = byte(elemcborlen)[ctr - lctr];
789                             ctr++;
790                         }
791                     }
792                     res[ctr] = elemArray[i][x];
793                     ctr++;
794                 }
795                 res[ctr] = 0xFF;
796                 ctr++;
797             }
798             return res;
799         }
800 
801 
802     string oraclize_network_name;
803     function oraclize_setNetworkName(string _network_name) internal {
804         oraclize_network_name = _network_name;
805     }
806 
807     function oraclize_getNetworkName() internal view returns (string) {
808         return oraclize_network_name;
809     }
810 
811     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
812         require((_nbytes != 0)||(_nbytes <= 32));
813         bytes memory nbytes = new bytes(1);
814         nbytes[0] = byte(_nbytes);
815         bytes memory unonce = new bytes(32);
816         bytes memory sessionKeyHash = new bytes(32);
817         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
818         assembly {
819             mstore(unonce, 0x20)
820             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
821             mstore(sessionKeyHash, 0x20)
822             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
823         }
824         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
825         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
826         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
827         return queryId;
828     }
829 
830     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
831         oraclize_randomDS_args[queryId] = commitment;
832     }
833 
834     mapping(bytes32=>bytes32) oraclize_randomDS_args;
835     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
836 
837     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
838         bool sigok;
839         address signer;
840 
841         bytes32 sigr;
842         bytes32 sigs;
843 
844         bytes memory sigr_ = new bytes(32);
845         uint offset = 4+(uint(dersig[3]) - 0x20);
846         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
847         bytes memory sigs_ = new bytes(32);
848         offset += 32 + 2;
849         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
850 
851         assembly {
852             sigr := mload(add(sigr_, 32))
853             sigs := mload(add(sigs_, 32))
854         }
855 
856 
857         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
858         if (address(keccak256(pubkey)) == signer) return true;
859         else {
860             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
861             return (address(keccak256(pubkey)) == signer);
862         }
863     }
864 
865     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
866         bool sigok;
867 
868         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
869         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
870         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
871 
872         bytes memory appkey1_pubkey = new bytes(64);
873         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
874 
875         bytes memory tosign2 = new bytes(1+65+32);
876         tosign2[0] = 1; //role
877         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
878         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
879         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
880         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
881 
882         if (sigok == false) return false;
883 
884 
885         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
886         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
887 
888         bytes memory tosign3 = new bytes(1+65);
889         tosign3[0] = 0xFE;
890         copyBytes(proof, 3, 65, tosign3, 1);
891 
892         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
893         copyBytes(proof, 3+65, sig3.length, sig3, 0);
894 
895         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
896 
897         return sigok;
898     }
899 
900     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
901         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
902         require((_proof[0] == "L")||(_proof[1] == "P")||(_proof[2] == 1));
903 
904         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
905         require(proofVerified == true);
906 
907         _;
908     }
909 
910     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
911         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
912         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
913 
914         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
915         if (proofVerified == false) return 2;
916 
917         return 0;
918     }
919 
920     function matchBytes32Prefix(bytes32 content, bytes prefix) internal pure returns (bool){
921         bool match_ = true;
922 
923         for (var i=0; i<prefix.length; i++){
924             if (content[i] != prefix[i]) match_ = false;
925         }
926 
927         return match_;
928     }
929 
930     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
931         bool checkok;
932 
933 
934         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
935         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
936         bytes memory keyhash = new bytes(32);
937         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
938         checkok = (keccak256(keyhash) == keccak256(sha256(context_name, queryId)));
939         if (checkok == false) return false;
940 
941         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
942         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
943 
944 
945         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
946         checkok = matchBytes32Prefix(sha256(sig1), result);
947         if (checkok == false) return false;
948 
949 
950         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
951         // This is to verify that the computed args match with the ones specified in the query.
952         bytes memory commitmentSlice1 = new bytes(8+1+32);
953         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
954 
955         bytes memory sessionPubkey = new bytes(64);
956         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
957         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
958 
959         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
960         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
961             delete oraclize_randomDS_args[queryId];
962         } else return false;
963 
964 
965         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
966         bytes memory tosign1 = new bytes(32+8+1+32);
967         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
968         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
969         if (checkok == false) return false;
970 
971         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
972         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
973             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
974         }
975 
976         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
977     }
978 
979 
980     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
981     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
982         uint minLength = length + toOffset;
983         require(to.length >= minLength);
984 
985         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
986         uint i = 32 + fromOffset;
987         uint j = 32 + toOffset;
988 
989         while (i < (32 + fromOffset + length)) {
990             assembly {
991                 let tmp := mload(add(from, i))
992                 mstore(add(to, j), tmp)
993             }
994             i += 32;
995             j += 32;
996         }
997 
998         return to;
999     }
1000 
1001     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1002     // Duplicate Solidity's ecrecover, but catching the CALL return value
1003     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1004         // We do our own memory management here. Solidity uses memory offset
1005         // 0x40 to store the current end of memory. We write past it (as
1006         // writes are memory extensions), but don't update the offset so
1007         // Solidity will reuse it. The memory used here is only needed for
1008         // this context.
1009 
1010         // FIXME: inline assembly can't access return values
1011         bool ret;
1012         address addr;
1013 
1014         assembly {
1015             let size := mload(0x40)
1016             mstore(size, hash)
1017             mstore(add(size, 32), v)
1018             mstore(add(size, 64), r)
1019             mstore(add(size, 96), s)
1020 
1021             // NOTE: we can reuse the request memory because we deal with
1022             //       the return code
1023             ret := call(3000, 1, 0, size, 128, size, 32)
1024             addr := mload(size)
1025         }
1026 
1027         return (ret, addr);
1028     }
1029 
1030     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1031     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1032         bytes32 r;
1033         bytes32 s;
1034         uint8 v;
1035 
1036         if (sig.length != 65)
1037           return (false, 0);
1038 
1039         // The signature format is a compact form of:
1040         //   {bytes32 r}{bytes32 s}{uint8 v}
1041         // Compact means, uint8 is not padded to 32 bytes.
1042         assembly {
1043             r := mload(add(sig, 32))
1044             s := mload(add(sig, 64))
1045 
1046             // Here we are loading the last 32 bytes. We exploit the fact that
1047             // 'mload' will pad with zeroes if we overread.
1048             // There is no 'mload8' to do this, but that would be nicer.
1049             v := byte(0, mload(add(sig, 96)))
1050 
1051             // Alternative solution:
1052             // 'byte' is not working due to the Solidity parser, so lets
1053             // use the second best option, 'and'
1054             // v := and(mload(add(sig, 65)), 255)
1055         }
1056 
1057         // albeit non-transactional signatures are not specified by the YP, one would expect it
1058         // to match the YP range of [27, 28]
1059         //
1060         // geth uses [0, 1] and some clients have followed. This might change, see:
1061         //  https://github.com/ethereum/go-ethereum/issues/2053
1062         if (v < 27)
1063           v += 27;
1064 
1065         if (v != 27 && v != 28)
1066             return (false, 0);
1067 
1068         return safer_ecrecover(hash, v, r, s);
1069     }
1070 
1071 }
1072 // </ORACLIZE_API>
1073 
1074 contract PriceReceiver {
1075   address public ethPriceProvider;
1076 
1077   address public btcPriceProvider;
1078 
1079   modifier onlyEthPriceProvider() {
1080     require(msg.sender == ethPriceProvider);
1081     _;
1082   }
1083 
1084   modifier onlyBtcPriceProvider() {
1085     require(msg.sender == btcPriceProvider);
1086     _;
1087   }
1088 
1089   function receiveEthPrice(uint ethUsdPrice) external;
1090 
1091   function receiveBtcPrice(uint btcUsdPrice) external;
1092 
1093   function setEthPriceProvider(address provider) external;
1094 
1095   function setBtcPriceProvider(address provider) external;
1096 }
1097 
1098 /**
1099  * @title SafeMath
1100  * @dev Math operations with safety checks that throw on error
1101  */
1102 library SafeMath {
1103 
1104   /**
1105   * @dev Multiplies two numbers, throws on overflow.
1106   */
1107   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1108     if (a == 0) {
1109       return 0;
1110     }
1111     c = a * b;
1112     assert(c / a == b);
1113     return c;
1114   }
1115 
1116   /**
1117   * @dev Integer division of two numbers, truncating the quotient.
1118   */
1119   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1120     // assert(b > 0); // Solidity automatically throws when dividing by 0
1121     // uint256 c = a / b;
1122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1123     return a / b;
1124   }
1125 
1126   /**
1127   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1128   */
1129   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1130     assert(b <= a);
1131     return a - b;
1132   }
1133 
1134   /**
1135   * @dev Adds two numbers, throws on overflow.
1136   */
1137   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1138     c = a + b;
1139     assert(c >= a);
1140     return c;
1141   }
1142 }
1143 
1144 contract PriceProvider is Ownable, usingOraclize {
1145   using SafeMath for uint;
1146 
1147   enum State { Stopped, Active }
1148 
1149   uint public updateInterval = 7200; //2 hours by default
1150 
1151   uint public currentPrice;
1152 
1153   string public url;
1154 
1155   mapping (bytes32 => bool) validIds;
1156 
1157   PriceReceiver public watcher;
1158 
1159   State public state = State.Stopped;
1160 
1161   uint constant MIN_ALLOWED_PRICE_DIFF = 85;
1162 
1163   uint constant MAX_ALLOWED_PRICE_DIFF = 115;
1164 
1165   event TooBigPriceDiff(uint oldValue, uint newValue);
1166 
1167   event InsufficientFunds();
1168 
1169   function notifyWatcher() internal;
1170 
1171   modifier inActiveState() {
1172     require(state == State.Active);
1173     _;
1174   }
1175 
1176   modifier inStoppedState() {
1177     require(state == State.Stopped);
1178     _;
1179   }
1180 
1181   function PriceProvider(string _url) public {
1182     url = _url;
1183 
1184     //update immediately first time to be sure everything is working - first oraclize request is free.
1185     update(0);
1186   }
1187 
1188   //send some funds along with the call to cover oraclize fees
1189   function startUpdate(uint startingPrice) external payable onlyOwner inStoppedState {
1190     state = State.Active;
1191 
1192     //we can set starting price manually, contract will notify watcher only in case of allowed diff
1193     //so owner can't set too small or to big price anyway
1194     currentPrice = startingPrice;
1195     update(updateInterval);
1196   }
1197 
1198   function stopUpdate() external onlyOwner inActiveState {
1199     state = State.Stopped;
1200   }
1201 
1202   function setWatcher(address newWatcher) external onlyOwner {
1203     require(newWatcher != 0x0);
1204     watcher = PriceReceiver(newWatcher);
1205   }
1206 
1207   function setUpdateInterval(uint newInterval) external onlyOwner {
1208     require(newInterval > 0);
1209     updateInterval = newInterval;
1210   }
1211 
1212   function setUrl(string newUrl) external onlyOwner {
1213     require(bytes(newUrl).length > 0);
1214     url = newUrl;
1215   }
1216 
1217   function __callback(bytes32 myid, string result, bytes proof) public {
1218     require(msg.sender == oraclize_cbAddress() && validIds[myid]);
1219     delete validIds[myid];
1220 
1221     uint newPrice = parseInt(result, 2);
1222     require(newPrice > 0);
1223     uint changeInPercents = newPrice.mul(100).div(currentPrice);
1224 
1225     if (changeInPercents >= MIN_ALLOWED_PRICE_DIFF && changeInPercents <= MAX_ALLOWED_PRICE_DIFF) {
1226       currentPrice = newPrice;
1227 
1228       if (state == State.Active) {
1229         notifyWatcher();
1230         update(updateInterval);
1231       }
1232     } else {
1233       state = State.Stopped;
1234       TooBigPriceDiff(currentPrice, newPrice);
1235     }
1236   }
1237 
1238   function update(uint delay) private {
1239     if (oraclize_getPrice("URL") > this.balance) {
1240       //stop if we don't have enough funds anymore
1241       state = State.Stopped;
1242       InsufficientFunds();
1243     } else {
1244       bytes32 queryId = oraclize_query(delay, "URL", url);
1245       validIds[queryId] = true;
1246     }
1247   }
1248 
1249   //we need to get back our funds if we don't need this oracle anymore
1250   function withdraw(address receiver) external onlyOwner inStoppedState {
1251     require(receiver != 0x0);
1252     receiver.transfer(this.balance);
1253   }
1254 }
1255 
1256 contract EthPriceProvider is PriceProvider {
1257   function EthPriceProvider() PriceProvider("json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0") {
1258 
1259   }
1260 
1261   function notifyWatcher() internal {
1262     watcher.receiveEthPrice(currentPrice);
1263   }
1264 }