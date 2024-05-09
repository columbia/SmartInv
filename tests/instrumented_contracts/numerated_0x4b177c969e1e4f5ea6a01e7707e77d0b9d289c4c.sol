1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
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
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 }// <ORACLIZE_API>
44 /*
45 Copyright (c) 2015-2016 Oraclize SRL
46 Copyright (c) 2016 Oraclize LTD
47 
48 
49 
50 Permission is hereby granted, free of charge, to any person obtaining a copy
51 of this software and associated documentation files (the "Software"), to deal
52 in the Software without restriction, including without limitation the rights
53 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
54 copies of the Software, and to permit persons to whom the Software is
55 furnished to do so, subject to the following conditions:
56 
57 
58 
59 The above copyright notice and this permission notice shall be included in
60 all copies or substantial portions of the Software.
61 
62 
63 
64 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
65 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
66 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
67 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
68 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
69 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
70 THE SOFTWARE.
71 */
72 
73 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
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
89 contract OraclizeAddrResolverI {
90     function getAddress() public returns (address _addr);
91 }
92 contract usingOraclize {
93     uint constant day = 60*60*24;
94     uint constant week = 60*60*24*7;
95     uint constant month = 60*60*24*30;
96     byte constant proofType_NONE = 0x00;
97     byte constant proofType_TLSNotary = 0x10;
98     byte constant proofType_Android = 0x20;
99     byte constant proofType_Ledger = 0x30;
100     byte constant proofType_Native = 0xF0;
101     byte constant proofStorage_IPFS = 0x01;
102     uint8 constant networkID_auto = 0;
103     uint8 constant networkID_mainnet = 1;
104     uint8 constant networkID_testnet = 2;
105     uint8 constant networkID_morden = 2;
106     uint8 constant networkID_consensys = 161;
107 
108     OraclizeAddrResolverI OAR;
109 
110     OraclizeI oraclize;
111     modifier oraclizeAPI {
112         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
113             oraclize_setNetwork(networkID_auto);
114 
115         if(address(oraclize) != OAR.getAddress())
116             oraclize = OraclizeI(OAR.getAddress());
117 
118         _;
119     }
120     modifier coupon(string code){
121         oraclize = OraclizeI(OAR.getAddress());
122         _;
123     }
124 
125     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
126       return oraclize_setNetwork();
127       networkID; // silence the warning and remain backwards compatible
128     }
129     function oraclize_setNetwork() internal returns(bool){
130         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
131             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
132             oraclize_setNetworkName("eth_mainnet");
133             return true;
134         }
135         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
136             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
137             oraclize_setNetworkName("eth_ropsten3");
138             return true;
139         }
140         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
141             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
142             oraclize_setNetworkName("eth_kovan");
143             return true;
144         }
145         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
146             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
147             oraclize_setNetworkName("eth_rinkeby");
148             return true;
149         }
150         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
151             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
152             return true;
153         }
154         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
155             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
156             return true;
157         }
158         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
159             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
160             return true;
161         }
162         return false;
163     }
164 
165     function __callback(bytes32 myid, string result) public {
166         __callback(myid, result, new bytes(0));
167     }
168     function __callback(bytes32 myid, string result, bytes proof) public {
169       return;
170       myid; result; proof; // Silence compiler warnings
171     }
172 
173     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
174         return oraclize.getPrice(datasource);
175     }
176 
177     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
178         return oraclize.getPrice(datasource, gaslimit);
179     }
180 
181     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
182         uint price = oraclize.getPrice(datasource);
183         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
184         return oraclize.query.value(price)(0, datasource, arg);
185     }
186     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
187         uint price = oraclize.getPrice(datasource);
188         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
189         return oraclize.query.value(price)(timestamp, datasource, arg);
190     }
191     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
192         uint price = oraclize.getPrice(datasource, gaslimit);
193         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
194         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
195     }
196     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
197         uint price = oraclize.getPrice(datasource, gaslimit);
198         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
199         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
200     }
201     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
202         uint price = oraclize.getPrice(datasource);
203         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
204         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
205     }
206     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
207         uint price = oraclize.getPrice(datasource);
208         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
209         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
210     }
211     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
212         uint price = oraclize.getPrice(datasource, gaslimit);
213         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
214         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
215     }
216     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
217         uint price = oraclize.getPrice(datasource, gaslimit);
218         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
219         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
220     }
221     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
222         uint price = oraclize.getPrice(datasource);
223         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
224         bytes memory args = stra2cbor(argN);
225         return oraclize.queryN.value(price)(0, datasource, args);
226     }
227     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
228         uint price = oraclize.getPrice(datasource);
229         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
230         bytes memory args = stra2cbor(argN);
231         return oraclize.queryN.value(price)(timestamp, datasource, args);
232     }
233     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
234         uint price = oraclize.getPrice(datasource, gaslimit);
235         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
236         bytes memory args = stra2cbor(argN);
237         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
238     }
239     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
240         uint price = oraclize.getPrice(datasource, gaslimit);
241         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
242         bytes memory args = stra2cbor(argN);
243         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
244     }
245     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
246         string[] memory dynargs = new string[](1);
247         dynargs[0] = args[0];
248         return oraclize_query(datasource, dynargs);
249     }
250     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
251         string[] memory dynargs = new string[](1);
252         dynargs[0] = args[0];
253         return oraclize_query(timestamp, datasource, dynargs);
254     }
255     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
256         string[] memory dynargs = new string[](1);
257         dynargs[0] = args[0];
258         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
259     }
260     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
261         string[] memory dynargs = new string[](1);
262         dynargs[0] = args[0];
263         return oraclize_query(datasource, dynargs, gaslimit);
264     }
265 
266     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
267         string[] memory dynargs = new string[](2);
268         dynargs[0] = args[0];
269         dynargs[1] = args[1];
270         return oraclize_query(datasource, dynargs);
271     }
272     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
273         string[] memory dynargs = new string[](2);
274         dynargs[0] = args[0];
275         dynargs[1] = args[1];
276         return oraclize_query(timestamp, datasource, dynargs);
277     }
278     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
279         string[] memory dynargs = new string[](2);
280         dynargs[0] = args[0];
281         dynargs[1] = args[1];
282         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
283     }
284     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
285         string[] memory dynargs = new string[](2);
286         dynargs[0] = args[0];
287         dynargs[1] = args[1];
288         return oraclize_query(datasource, dynargs, gaslimit);
289     }
290     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
291         string[] memory dynargs = new string[](3);
292         dynargs[0] = args[0];
293         dynargs[1] = args[1];
294         dynargs[2] = args[2];
295         return oraclize_query(datasource, dynargs);
296     }
297     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
298         string[] memory dynargs = new string[](3);
299         dynargs[0] = args[0];
300         dynargs[1] = args[1];
301         dynargs[2] = args[2];
302         return oraclize_query(timestamp, datasource, dynargs);
303     }
304     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
305         string[] memory dynargs = new string[](3);
306         dynargs[0] = args[0];
307         dynargs[1] = args[1];
308         dynargs[2] = args[2];
309         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
310     }
311     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
312         string[] memory dynargs = new string[](3);
313         dynargs[0] = args[0];
314         dynargs[1] = args[1];
315         dynargs[2] = args[2];
316         return oraclize_query(datasource, dynargs, gaslimit);
317     }
318 
319     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
320         string[] memory dynargs = new string[](4);
321         dynargs[0] = args[0];
322         dynargs[1] = args[1];
323         dynargs[2] = args[2];
324         dynargs[3] = args[3];
325         return oraclize_query(datasource, dynargs);
326     }
327     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
328         string[] memory dynargs = new string[](4);
329         dynargs[0] = args[0];
330         dynargs[1] = args[1];
331         dynargs[2] = args[2];
332         dynargs[3] = args[3];
333         return oraclize_query(timestamp, datasource, dynargs);
334     }
335     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
336         string[] memory dynargs = new string[](4);
337         dynargs[0] = args[0];
338         dynargs[1] = args[1];
339         dynargs[2] = args[2];
340         dynargs[3] = args[3];
341         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
342     }
343     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
344         string[] memory dynargs = new string[](4);
345         dynargs[0] = args[0];
346         dynargs[1] = args[1];
347         dynargs[2] = args[2];
348         dynargs[3] = args[3];
349         return oraclize_query(datasource, dynargs, gaslimit);
350     }
351     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
352         string[] memory dynargs = new string[](5);
353         dynargs[0] = args[0];
354         dynargs[1] = args[1];
355         dynargs[2] = args[2];
356         dynargs[3] = args[3];
357         dynargs[4] = args[4];
358         return oraclize_query(datasource, dynargs);
359     }
360     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
361         string[] memory dynargs = new string[](5);
362         dynargs[0] = args[0];
363         dynargs[1] = args[1];
364         dynargs[2] = args[2];
365         dynargs[3] = args[3];
366         dynargs[4] = args[4];
367         return oraclize_query(timestamp, datasource, dynargs);
368     }
369     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
370         string[] memory dynargs = new string[](5);
371         dynargs[0] = args[0];
372         dynargs[1] = args[1];
373         dynargs[2] = args[2];
374         dynargs[3] = args[3];
375         dynargs[4] = args[4];
376         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
377     }
378     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
379         string[] memory dynargs = new string[](5);
380         dynargs[0] = args[0];
381         dynargs[1] = args[1];
382         dynargs[2] = args[2];
383         dynargs[3] = args[3];
384         dynargs[4] = args[4];
385         return oraclize_query(datasource, dynargs, gaslimit);
386     }
387     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
388         uint price = oraclize.getPrice(datasource);
389         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
390         bytes memory args = ba2cbor(argN);
391         return oraclize.queryN.value(price)(0, datasource, args);
392     }
393     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
394         uint price = oraclize.getPrice(datasource);
395         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
396         bytes memory args = ba2cbor(argN);
397         return oraclize.queryN.value(price)(timestamp, datasource, args);
398     }
399     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
400         uint price = oraclize.getPrice(datasource, gaslimit);
401         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
402         bytes memory args = ba2cbor(argN);
403         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
404     }
405     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
406         uint price = oraclize.getPrice(datasource, gaslimit);
407         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
408         bytes memory args = ba2cbor(argN);
409         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
410     }
411     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
412         bytes[] memory dynargs = new bytes[](1);
413         dynargs[0] = args[0];
414         return oraclize_query(datasource, dynargs);
415     }
416     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
417         bytes[] memory dynargs = new bytes[](1);
418         dynargs[0] = args[0];
419         return oraclize_query(timestamp, datasource, dynargs);
420     }
421     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
422         bytes[] memory dynargs = new bytes[](1);
423         dynargs[0] = args[0];
424         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
425     }
426     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
427         bytes[] memory dynargs = new bytes[](1);
428         dynargs[0] = args[0];
429         return oraclize_query(datasource, dynargs, gaslimit);
430     }
431 
432     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
433         bytes[] memory dynargs = new bytes[](2);
434         dynargs[0] = args[0];
435         dynargs[1] = args[1];
436         return oraclize_query(datasource, dynargs);
437     }
438     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
439         bytes[] memory dynargs = new bytes[](2);
440         dynargs[0] = args[0];
441         dynargs[1] = args[1];
442         return oraclize_query(timestamp, datasource, dynargs);
443     }
444     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
445         bytes[] memory dynargs = new bytes[](2);
446         dynargs[0] = args[0];
447         dynargs[1] = args[1];
448         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
449     }
450     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
451         bytes[] memory dynargs = new bytes[](2);
452         dynargs[0] = args[0];
453         dynargs[1] = args[1];
454         return oraclize_query(datasource, dynargs, gaslimit);
455     }
456     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
457         bytes[] memory dynargs = new bytes[](3);
458         dynargs[0] = args[0];
459         dynargs[1] = args[1];
460         dynargs[2] = args[2];
461         return oraclize_query(datasource, dynargs);
462     }
463     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
464         bytes[] memory dynargs = new bytes[](3);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         dynargs[2] = args[2];
468         return oraclize_query(timestamp, datasource, dynargs);
469     }
470     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
471         bytes[] memory dynargs = new bytes[](3);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         dynargs[2] = args[2];
475         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
476     }
477     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
478         bytes[] memory dynargs = new bytes[](3);
479         dynargs[0] = args[0];
480         dynargs[1] = args[1];
481         dynargs[2] = args[2];
482         return oraclize_query(datasource, dynargs, gaslimit);
483     }
484 
485     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
486         bytes[] memory dynargs = new bytes[](4);
487         dynargs[0] = args[0];
488         dynargs[1] = args[1];
489         dynargs[2] = args[2];
490         dynargs[3] = args[3];
491         return oraclize_query(datasource, dynargs);
492     }
493     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
494         bytes[] memory dynargs = new bytes[](4);
495         dynargs[0] = args[0];
496         dynargs[1] = args[1];
497         dynargs[2] = args[2];
498         dynargs[3] = args[3];
499         return oraclize_query(timestamp, datasource, dynargs);
500     }
501     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
502         bytes[] memory dynargs = new bytes[](4);
503         dynargs[0] = args[0];
504         dynargs[1] = args[1];
505         dynargs[2] = args[2];
506         dynargs[3] = args[3];
507         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
508     }
509     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
510         bytes[] memory dynargs = new bytes[](4);
511         dynargs[0] = args[0];
512         dynargs[1] = args[1];
513         dynargs[2] = args[2];
514         dynargs[3] = args[3];
515         return oraclize_query(datasource, dynargs, gaslimit);
516     }
517     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
518         bytes[] memory dynargs = new bytes[](5);
519         dynargs[0] = args[0];
520         dynargs[1] = args[1];
521         dynargs[2] = args[2];
522         dynargs[3] = args[3];
523         dynargs[4] = args[4];
524         return oraclize_query(datasource, dynargs);
525     }
526     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
527         bytes[] memory dynargs = new bytes[](5);
528         dynargs[0] = args[0];
529         dynargs[1] = args[1];
530         dynargs[2] = args[2];
531         dynargs[3] = args[3];
532         dynargs[4] = args[4];
533         return oraclize_query(timestamp, datasource, dynargs);
534     }
535     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
536         bytes[] memory dynargs = new bytes[](5);
537         dynargs[0] = args[0];
538         dynargs[1] = args[1];
539         dynargs[2] = args[2];
540         dynargs[3] = args[3];
541         dynargs[4] = args[4];
542         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
543     }
544     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
545         bytes[] memory dynargs = new bytes[](5);
546         dynargs[0] = args[0];
547         dynargs[1] = args[1];
548         dynargs[2] = args[2];
549         dynargs[3] = args[3];
550         dynargs[4] = args[4];
551         return oraclize_query(datasource, dynargs, gaslimit);
552     }
553 
554     function oraclize_cbAddress() oraclizeAPI internal returns (address){
555         return oraclize.cbAddress();
556     }
557     function oraclize_setProof(byte proofP) oraclizeAPI internal {
558         return oraclize.setProofType(proofP);
559     }
560     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
561         return oraclize.setCustomGasPrice(gasPrice);
562     }
563 
564     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
565         return oraclize.randomDS_getSessionPubKeyHash();
566     }
567 
568     function getCodeSize(address _addr) constant internal returns(uint _size) {
569         assembly {
570             _size := extcodesize(_addr)
571         }
572     }
573 
574     function parseAddr(string _a) internal pure returns (address){
575         bytes memory tmp = bytes(_a);
576         uint160 iaddr = 0;
577         uint160 b1;
578         uint160 b2;
579         for (uint i=2; i<2+2*20; i+=2){
580             iaddr *= 256;
581             b1 = uint160(tmp[i]);
582             b2 = uint160(tmp[i+1]);
583             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
584             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
585             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
586             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
587             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
588             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
589             iaddr += (b1*16+b2);
590         }
591         return address(iaddr);
592     }
593 
594     function strCompare(string _a, string _b) internal pure returns (int) {
595         bytes memory a = bytes(_a);
596         bytes memory b = bytes(_b);
597         uint minLength = a.length;
598         if (b.length < minLength) minLength = b.length;
599         for (uint i = 0; i < minLength; i ++)
600             if (a[i] < b[i])
601                 return -1;
602             else if (a[i] > b[i])
603                 return 1;
604         if (a.length < b.length)
605             return -1;
606         else if (a.length > b.length)
607             return 1;
608         else
609             return 0;
610     }
611 
612     function indexOf(string _haystack, string _needle) internal pure returns (int) {
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
638 
639     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
640         bytes memory _ba = bytes(_a);
641         bytes memory _bb = bytes(_b);
642         bytes memory _bc = bytes(_c);
643         bytes memory _bd = bytes(_d);
644         bytes memory _be = bytes(_e);
645         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
646         bytes memory babcde = bytes(abcde);
647         uint k = 0;
648         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
649         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
650         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
651         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
652         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
653         return string(babcde);
654     }
655 
656     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
657         return strConcat(_a, _b, _c, _d, "");
658     }
659 
660     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
661         return strConcat(_a, _b, _c, "", "");
662     }
663 
664     function strConcat(string _a, string _b) internal pure returns (string) {
665         return strConcat(_a, _b, "", "", "");
666     }
667 
668     // parseInt
669     function parseInt(string _a) internal pure returns (uint) {
670         return parseInt(_a, 0);
671     }
672 
673     // parseInt(parseFloat*10^_b)
674     function parseInt(string _a, uint _b) internal pure returns (uint) {
675         bytes memory bresult = bytes(_a);
676         uint mint = 0;
677         bool decimals = false;
678         for (uint i=0; i<bresult.length; i++){
679             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
680                 if (decimals){
681                    if (_b == 0) break;
682                     else _b--;
683                 }
684                 mint *= 10;
685                 mint += uint(bresult[i]) - 48;
686             } else if (bresult[i] == 46) decimals = true;
687         }
688         if (_b > 0) mint *= 10**_b;
689         return mint;
690     }
691 
692     function uint2str(uint i) internal pure returns (string){
693         if (i == 0) return "0";
694         uint j = i;
695         uint len;
696         while (j != 0){
697             len++;
698             j /= 10;
699         }
700         bytes memory bstr = new bytes(len);
701         uint k = len - 1;
702         while (i != 0){
703             bstr[k--] = byte(48 + i % 10);
704             i /= 10;
705         }
706         return string(bstr);
707     }
708 
709     function stra2cbor(string[] arr) internal pure returns (bytes) {
710             uint arrlen = arr.length;
711 
712             // get correct cbor output length
713             uint outputlen = 0;
714             bytes[] memory elemArray = new bytes[](arrlen);
715             for (uint i = 0; i < arrlen; i++) {
716                 elemArray[i] = (bytes(arr[i]));
717                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
718             }
719             uint ctr = 0;
720             uint cborlen = arrlen + 0x80;
721             outputlen += byte(cborlen).length;
722             bytes memory res = new bytes(outputlen);
723 
724             while (byte(cborlen).length > ctr) {
725                 res[ctr] = byte(cborlen)[ctr];
726                 ctr++;
727             }
728             for (i = 0; i < arrlen; i++) {
729                 res[ctr] = 0x5F;
730                 ctr++;
731                 for (uint x = 0; x < elemArray[i].length; x++) {
732                     // if there's a bug with larger strings, this may be the culprit
733                     if (x % 23 == 0) {
734                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
735                         elemcborlen += 0x40;
736                         uint lctr = ctr;
737                         while (byte(elemcborlen).length > ctr - lctr) {
738                             res[ctr] = byte(elemcborlen)[ctr - lctr];
739                             ctr++;
740                         }
741                     }
742                     res[ctr] = elemArray[i][x];
743                     ctr++;
744                 }
745                 res[ctr] = 0xFF;
746                 ctr++;
747             }
748             return res;
749         }
750 
751     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
752             uint arrlen = arr.length;
753 
754             // get correct cbor output length
755             uint outputlen = 0;
756             bytes[] memory elemArray = new bytes[](arrlen);
757             for (uint i = 0; i < arrlen; i++) {
758                 elemArray[i] = (bytes(arr[i]));
759                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
760             }
761             uint ctr = 0;
762             uint cborlen = arrlen + 0x80;
763             outputlen += byte(cborlen).length;
764             bytes memory res = new bytes(outputlen);
765 
766             while (byte(cborlen).length > ctr) {
767                 res[ctr] = byte(cborlen)[ctr];
768                 ctr++;
769             }
770             for (i = 0; i < arrlen; i++) {
771                 res[ctr] = 0x5F;
772                 ctr++;
773                 for (uint x = 0; x < elemArray[i].length; x++) {
774                     // if there's a bug with larger strings, this may be the culprit
775                     if (x % 23 == 0) {
776                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
777                         elemcborlen += 0x40;
778                         uint lctr = ctr;
779                         while (byte(elemcborlen).length > ctr - lctr) {
780                             res[ctr] = byte(elemcborlen)[ctr - lctr];
781                             ctr++;
782                         }
783                     }
784                     res[ctr] = elemArray[i][x];
785                     ctr++;
786                 }
787                 res[ctr] = 0xFF;
788                 ctr++;
789             }
790             return res;
791         }
792 
793 
794     string oraclize_network_name;
795     function oraclize_setNetworkName(string _network_name) internal {
796         oraclize_network_name = _network_name;
797     }
798 
799     function oraclize_getNetworkName() internal view returns (string) {
800         return oraclize_network_name;
801     }
802 
803     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
804         require((_nbytes > 0) && (_nbytes <= 32));
805         bytes memory nbytes = new bytes(1);
806         nbytes[0] = byte(_nbytes);
807         bytes memory unonce = new bytes(32);
808         bytes memory sessionKeyHash = new bytes(32);
809         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
810         assembly {
811             mstore(unonce, 0x20)
812             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
813             mstore(sessionKeyHash, 0x20)
814             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
815         }
816         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
817         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
818         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
819         return queryId;
820     }
821 
822     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
823         oraclize_randomDS_args[queryId] = commitment;
824     }
825 
826     mapping(bytes32=>bytes32) oraclize_randomDS_args;
827     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
828 
829     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
830         bool sigok;
831         address signer;
832 
833         bytes32 sigr;
834         bytes32 sigs;
835 
836         bytes memory sigr_ = new bytes(32);
837         uint offset = 4+(uint(dersig[3]) - 0x20);
838         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
839         bytes memory sigs_ = new bytes(32);
840         offset += 32 + 2;
841         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
842 
843         assembly {
844             sigr := mload(add(sigr_, 32))
845             sigs := mload(add(sigs_, 32))
846         }
847 
848 
849         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
850         if (address(keccak256(pubkey)) == signer) return true;
851         else {
852             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
853             return (address(keccak256(pubkey)) == signer);
854         }
855     }
856 
857     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
858         bool sigok;
859 
860         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
861         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
862         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
863 
864         bytes memory appkey1_pubkey = new bytes(64);
865         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
866 
867         bytes memory tosign2 = new bytes(1+65+32);
868         tosign2[0] = byte(1); //role
869         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
870         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
871         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
872         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
873 
874         if (sigok == false) return false;
875 
876 
877         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
878         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
879 
880         bytes memory tosign3 = new bytes(1+65);
881         tosign3[0] = 0xFE;
882         copyBytes(proof, 3, 65, tosign3, 1);
883 
884         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
885         copyBytes(proof, 3+65, sig3.length, sig3, 0);
886 
887         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
888 
889         return sigok;
890     }
891 
892     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
893         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
894         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
895 
896         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
897         require(proofVerified);
898 
899         _;
900     }
901 
902     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
903         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
904         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
905 
906         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
907         if (proofVerified == false) return 2;
908 
909         return 0;
910     }
911 
912     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
913         bool match_ = true;
914 
915 
916         for (uint256 i=0; i< n_random_bytes; i++) {
917             if (content[i] != prefix[i]) match_ = false;
918         }
919 
920         return match_;
921     }
922 
923     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
924 
925         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
926         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
927         bytes memory keyhash = new bytes(32);
928         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
929         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
930 
931         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
932         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
933 
934         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
935         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
936 
937         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
938         // This is to verify that the computed args match with the ones specified in the query.
939         bytes memory commitmentSlice1 = new bytes(8+1+32);
940         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
941 
942         bytes memory sessionPubkey = new bytes(64);
943         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
944         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
945 
946         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
947         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
948             delete oraclize_randomDS_args[queryId];
949         } else return false;
950 
951 
952         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
953         bytes memory tosign1 = new bytes(32+8+1+32);
954         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
955         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
956 
957         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
958         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
959             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
960         }
961 
962         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
963     }
964 
965     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
966     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
967         uint minLength = length + toOffset;
968 
969         // Buffer too small
970         require(to.length >= minLength); // Should be a better way?
971 
972         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
973         uint i = 32 + fromOffset;
974         uint j = 32 + toOffset;
975 
976         while (i < (32 + fromOffset + length)) {
977             assembly {
978                 let tmp := mload(add(from, i))
979                 mstore(add(to, j), tmp)
980             }
981             i += 32;
982             j += 32;
983         }
984 
985         return to;
986     }
987 
988     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
989     // Duplicate Solidity's ecrecover, but catching the CALL return value
990     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
991         // We do our own memory management here. Solidity uses memory offset
992         // 0x40 to store the current end of memory. We write past it (as
993         // writes are memory extensions), but don't update the offset so
994         // Solidity will reuse it. The memory used here is only needed for
995         // this context.
996 
997         // FIXME: inline assembly can't access return values
998         bool ret;
999         address addr;
1000 
1001         assembly {
1002             let size := mload(0x40)
1003             mstore(size, hash)
1004             mstore(add(size, 32), v)
1005             mstore(add(size, 64), r)
1006             mstore(add(size, 96), s)
1007 
1008             // NOTE: we can reuse the request memory because we deal with
1009             //       the return code
1010             ret := call(3000, 1, 0, size, 128, size, 32)
1011             addr := mload(size)
1012         }
1013 
1014         return (ret, addr);
1015     }
1016 
1017     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1018     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1019         bytes32 r;
1020         bytes32 s;
1021         uint8 v;
1022 
1023         if (sig.length != 65)
1024           return (false, 0);
1025 
1026         // The signature format is a compact form of:
1027         //   {bytes32 r}{bytes32 s}{uint8 v}
1028         // Compact means, uint8 is not padded to 32 bytes.
1029         assembly {
1030             r := mload(add(sig, 32))
1031             s := mload(add(sig, 64))
1032 
1033             // Here we are loading the last 32 bytes. We exploit the fact that
1034             // 'mload' will pad with zeroes if we overread.
1035             // There is no 'mload8' to do this, but that would be nicer.
1036             v := byte(0, mload(add(sig, 96)))
1037 
1038             // Alternative solution:
1039             // 'byte' is not working due to the Solidity parser, so lets
1040             // use the second best option, 'and'
1041             // v := and(mload(add(sig, 65)), 255)
1042         }
1043 
1044         // albeit non-transactional signatures are not specified by the YP, one would expect it
1045         // to match the YP range of [27, 28]
1046         //
1047         // geth uses [0, 1] and some clients have followed. This might change, see:
1048         //  https://github.com/ethereum/go-ethereum/issues/2053
1049         if (v < 27)
1050           v += 27;
1051 
1052         if (v != 27 && v != 28)
1053             return (false, 0);
1054 
1055         return safer_ecrecover(hash, v, r, s);
1056     }
1057 
1058 }
1059 
1060 contract Game is Ownable, usingOraclize {
1061   function int2str(int x) internal pure returns (string) {
1062     if (x < 0) {
1063       return strConcat("-",
1064         uint2str(uint(x * -1)), "", "", "");
1065     }
1066     return uint2str(uint(x));
1067   }
1068 
1069   function compare(string _a, string _b) internal pure returns (int) {
1070     bytes memory a = bytes(_a);
1071     bytes memory b = bytes(_b);
1072     uint minLength = a.length;
1073     if (b.length < minLength) minLength = b.length;
1074     //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
1075     for (uint i = 0; i < minLength; i ++)
1076       if (a[i] < b[i])
1077         return -1;
1078       else if (a[i] > b[i])
1079         return 1;
1080     if (a.length < b.length)
1081       return -1;
1082     else if (a.length > b.length)
1083       return 1;
1084     else
1085       return 0;
1086   }
1087 
1088   /// @dev Compares two strings and returns true iff they are equal.
1089   function equal(string _a, string _b) internal pure returns (bool) {
1090       return compare(_a, _b) == 0;
1091   }
1092 
1093   function () payable public { }
1094 }
1095 
1096 contract FiniteStateGame is Game {
1097   enum GameState {
1098       New,     // 0 Default game state for new game, bets cannot be placed since there is no moneyline
1099       Open,    // 1 Betting is open
1100       Closed,  // 2 Betting is closed since the event is about to take place
1101       Over,    // 3 Competition is over
1102       Complete // 4 Everyone is paid
1103   }
1104 
1105   GameState internal gameState = GameState.New;
1106 
1107   /**
1108    * @dev Throws if called by any other address than Oraclize.
1109    */
1110   modifier onlyOraclize {
1111     require(msg.sender == oraclize_cbAddress());
1112     _;
1113   }
1114 
1115   /**
1116    * @dev Throws if called in any state other than requiredState.
1117    */
1118   modifier onlyState(GameState requiredState) {
1119     require (gameState == requiredState);
1120     _;
1121   }
1122 
1123   /**
1124    * @dev Throws if called in any state other than requiredState.
1125    */
1126   modifier beforeState(GameState requiredState) {
1127     require (gameState < requiredState);
1128     _;
1129   }
1130 
1131   /**
1132    * @dev Throws if called in any state other than requiredState.
1133    */
1134   modifier afterState(GameState requiredState) {
1135     require (gameState > requiredState);
1136     _;
1137   }
1138 
1139   modifier advanceState() {
1140     _;
1141     advanceGameState();
1142   }
1143 
1144   function advanceGameState() internal {
1145     gameState = GameState(uint(gameState) + 1);
1146   }
1147 
1148   /**
1149    * @dev Destroy current game.
1150    */
1151   function destroy() onlyOwner onlyState(GameState.Complete) public {
1152     selfdestruct(owner);
1153   }
1154 }
1155 
1156 contract TeamGame is FiniteStateGame {
1157   event LogMoneyline(
1158     int home,
1159     int away
1160   );
1161 
1162   event LogClosed();
1163 
1164   event LogGame(
1165     string home,
1166     string away,
1167     string date,
1168     string query
1169   );
1170 
1171   event LogWinner(
1172     string winner
1173   );
1174 
1175   struct Moneyline {
1176     int home;
1177     int away;
1178   }
1179 
1180 
1181   struct Bet {
1182     address sender;
1183     uint amount;
1184     int odds;
1185   }
1186 
1187   string Date;
1188   string Home;
1189   string Away;
1190   string Query;
1191   string Result;
1192 
1193   Moneyline CurrentMoneyline;
1194   Bet[] betsHome;
1195   Bet[] betsAway;
1196   uint payoutHome;
1197   uint payoutAway;
1198 
1199   uint minBet = 10 finney;
1200   uint maxBetFixed = 5 ether;
1201 
1202   modifier onlyLessOrEqualMaximumBetHome() {
1203     if (msg.value > getMaximumBetHome()) {
1204       revert();
1205     }
1206     _;
1207   }
1208 
1209   modifier onlyLessOrEqualMaximumBetAway() {
1210     if (msg.value > getMaximumBetAway()) {
1211       revert();
1212     }
1213     _;
1214   }
1215 
1216   modifier onlyGreaterOrEqualMinimumBet() {
1217     if (msg.value < getMinimumBet()) {
1218       revert();
1219     }
1220     _;
1221   }
1222 
1223   function getMinimumBet() public view afterState(GameState.New) beforeState(GameState.Closed) returns (uint) {
1224     return minBet;
1225   }
1226 
1227   function calculateMaxBet(uint pot, int odds) internal view returns (uint) {
1228     uint maxBet = 0;
1229     if (odds < 0) {
1230       maxBet =  pot * uint(odds*-1) / 100;
1231     } else if (odds > 0) {
1232       maxBet = pot * 100 / uint(odds);
1233     }
1234     return (maxBetFixed < maxBet) ? maxBetFixed : maxBet;
1235   }
1236 
1237   function getMaximumBetHome() public view afterState(GameState.New) beforeState(GameState.Closed) returns (uint) {
1238     return calculateMaxBet(this.balance - payoutHome, CurrentMoneyline.home);
1239   }
1240 
1241   function getMaximumBetAway() public view afterState(GameState.New) beforeState(GameState.Closed) returns (uint) {
1242     return calculateMaxBet(this.balance - payoutAway, CurrentMoneyline.away);
1243   }
1244 
1245   function getMoneyline() public afterState(GameState.New) view returns (int, int) {
1246     return (CurrentMoneyline.home, CurrentMoneyline.away);
1247   }
1248 
1249   function setMoneyline(int home, int away) public beforeState(GameState.Closed) onlyOwner {
1250     CurrentMoneyline = Moneyline({
1251       home: home,
1252       away: away
1253     });
1254 
1255     if (gameState == GameState.New) {
1256       LogGame({
1257         home: Home,
1258         away: Away,
1259         date: Date,
1260         query: Query
1261       });
1262     }
1263 
1264     LogMoneyline({
1265       home: home,
1266       away: away
1267     });
1268 
1269     if (gameState == GameState.New) {
1270       advanceGameState();
1271     }
1272   }
1273 
1274   function init(string date, string home, string away, string query) public onlyOwner onlyState(GameState.New) {
1275     Date = date;
1276     Home = home;
1277     Away = away;
1278     Query = query;
1279   }
1280 
1281   function setOAR(address oar) public onlyOwner onlyState(GameState.New) {
1282     OAR = OraclizeAddrResolverI(oar);
1283   }
1284 
1285   function payout(Bet[] storage betsWin) internal onlyOwner onlyState(GameState.Over) {
1286     // Send winners their winnings
1287     for (uint i = 0; i < betsWin.length; i++) {
1288       uint thisPayout = calculatePayout(betsWin[i].amount, betsWin[i].odds);
1289       if (thisPayout > 0) {
1290         // Avoid retrancy attacks!
1291         betsWin[i].amount = 0;
1292         betsWin[i].sender.transfer(thisPayout);
1293       }
1294     }
1295     advanceGameState();
1296   }
1297 
1298   function playAway() payable public onlyState(GameState.Open) onlyGreaterOrEqualMinimumBet onlyLessOrEqualMaximumBetAway {
1299     betsAway.push(Bet({
1300       sender: msg.sender,
1301       amount: msg.value,
1302       odds: CurrentMoneyline.away
1303     }));
1304 
1305     payoutAway += calculatePayout(msg.value, CurrentMoneyline.away);
1306   }
1307 
1308   function playHome() payable public onlyState(GameState.Open) onlyGreaterOrEqualMinimumBet onlyLessOrEqualMaximumBetHome {
1309     betsHome.push(Bet({
1310       sender: msg.sender,
1311       amount: msg.value,
1312       odds: CurrentMoneyline.home
1313     }));
1314 
1315     payoutHome += calculatePayout(msg.value, CurrentMoneyline.home);
1316   }
1317 
1318   /**
1319    * @dev Returns current game metrics.
1320    */
1321   function getMetrics() public view onlyOwner returns (GameState, uint, uint, uint, uint, uint, uint) {
1322     uint betHome;
1323     uint betAway;
1324 
1325     for (uint i = 0; i < betsHome.length; i++) {
1326       betHome += betsHome[i].amount;
1327     }
1328     for (i = 0; i < betsAway.length; i++) {
1329       betAway += betsAway[i].amount;
1330     }
1331     return (gameState, betsHome.length, betsAway.length, betHome, betAway, payoutHome, payoutAway);
1332   }
1333 
1334   function calculatePayout(uint amount, int odds) public pure returns (uint) {
1335     if (amount > 0 && odds > 0) {
1336       return (amount * uint(odds)) / 100 + amount;
1337     } else if (amount > 0 && odds < 0) {
1338       return (amount * 100) / uint(odds*-1) + amount;
1339     }
1340     return 0;
1341   }
1342 
1343   function closeGame() public onlyOwner onlyState(GameState.Open) {
1344     LogClosed();
1345 
1346     advanceGameState();
1347   }
1348 
1349   /**
1350    * @dev Emergency refund all bets and refund owner seed amount.
1351    */
1352   function emergencyRefund() onlyOwner public {
1353     for (uint i = 0; i < betsHome.length; i++) {
1354       betsHome[i].amount = 0;
1355       betsHome[i].sender.transfer(betsHome[i].amount);
1356     }
1357     for (i = 0; i < betsAway.length; i++) {
1358       betsAway[i].amount = 0;
1359       betsAway[i].sender.transfer(betsAway[i].amount);
1360     }
1361 
1362     selfdestruct(owner);
1363   }
1364 }
1365 
1366 contract Football is TeamGame {
1367   function gameOver() public onlyOwner onlyState(GameState.Closed) {
1368     oraclize_query("WolframAlpha", Query);
1369   }
1370 
1371   function __callback(bytes32, string result) onlyState(GameState.Closed) onlyOraclize public {
1372     if (equal(Home, result) || equal(Away, result)) {
1373       Result = result;
1374       advanceGameState();
1375     }
1376   }
1377 
1378   function finishGame() public onlyOwner onlyState(GameState.Over) {
1379     if (equal(Home, Result)) {
1380       payout(betsHome);
1381     } else {
1382       payout(betsAway);
1383     }
1384     LogWinner(Result);
1385   }
1386 }