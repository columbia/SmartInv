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
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 // <ORACLIZE_API>
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
73 //please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
74 
75 contract OraclizeI {
76     address public cbAddress;
77     function query(uint _timestamp, string _datasource, string _arg) public payable returns (bytes32 _id);
78     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) public payable returns (bytes32 _id);
79     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
80     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) public payable returns (bytes32 _id);
81     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
82     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) public payable returns (bytes32 _id);
83     function getPrice(string _datasource) public returns (uint _dsprice);
84     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
85     function useCoupon(string _coupon) public;
86     function setProofType(byte _proofType) public;
87     function setConfig(bytes32 _config) public;
88     function setCustomGasPrice(uint _gasPrice) public;
89     function randomDS_getSessionPubKeyHash() public returns(bytes32);
90 }
91 contract OraclizeAddrResolverI {
92     function getAddress() public returns (address _addr);
93 }
94 contract usingOraclize {
95     uint constant day = 60*60*24;
96     uint constant week = 60*60*24*7;
97     uint constant month = 60*60*24*30;
98     byte constant proofType_NONE = 0x00;
99     byte constant proofType_TLSNotary = 0x10;
100     byte constant proofType_Android = 0x20;
101     byte constant proofType_Ledger = 0x30;
102     byte constant proofType_Native = 0xF0;
103     byte constant proofStorage_IPFS = 0x01;
104     uint8 constant networkID_auto = 0;
105     uint8 constant networkID_mainnet = 1;
106     uint8 constant networkID_testnet = 2;
107     uint8 constant networkID_morden = 2;
108     uint8 constant networkID_consensys = 161;
109 
110     OraclizeAddrResolverI OAR;
111 
112     OraclizeI oraclize;
113     modifier oraclizeAPI {
114         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
115         oraclize = OraclizeI(OAR.getAddress());
116         _;
117     }
118     modifier coupon(string code){
119         oraclize = OraclizeI(OAR.getAddress());
120         oraclize.useCoupon(code);
121         _;
122     }
123 
124     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
125         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
126             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
127             oraclize_setNetworkName("eth_mainnet");
128             return true;
129         }
130         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
131             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
132             oraclize_setNetworkName("eth_ropsten3");
133             return true;
134         }
135         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
136             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
137             oraclize_setNetworkName("eth_kovan");
138             return true;
139         }
140         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
141             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
142             oraclize_setNetworkName("eth_rinkeby");
143             return true;
144         }
145         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
146             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
147             return true;
148         }
149         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
150             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
151             return true;
152         }
153         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
154             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
155             return true;
156         }
157         return false;
158     }
159 
160     function __callback(bytes32 myid, string result) public {
161         __callback(myid, result, new bytes(0));
162     }
163     function __callback(bytes32 myid, string result, bytes proof) public {
164     }
165 
166     function oraclize_useCoupon(string code) oraclizeAPI internal {
167         oraclize.useCoupon(code);
168     }
169 
170     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
171         return oraclize.getPrice(datasource);
172     }
173 
174     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
175         return oraclize.getPrice(datasource, gaslimit);
176     }
177 
178     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
179         uint price = oraclize.getPrice(datasource);
180         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
181         return oraclize.query.value(price)(0, datasource, arg);
182     }
183     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
184         uint price = oraclize.getPrice(datasource);
185         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
186         return oraclize.query.value(price)(timestamp, datasource, arg);
187     }
188     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
189         uint price = oraclize.getPrice(datasource, gaslimit);
190         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
191         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
192     }
193     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
194         uint price = oraclize.getPrice(datasource, gaslimit);
195         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
196         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
197     }
198     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
199         uint price = oraclize.getPrice(datasource);
200         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
201         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
202     }
203     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
204         uint price = oraclize.getPrice(datasource);
205         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
206         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
207     }
208     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
209         uint price = oraclize.getPrice(datasource, gaslimit);
210         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
211         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
212     }
213     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
214         uint price = oraclize.getPrice(datasource, gaslimit);
215         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
216         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
217     }
218     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
219         uint price = oraclize.getPrice(datasource);
220         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
221         bytes memory args = stra2cbor(argN);
222         return oraclize.queryN.value(price)(0, datasource, args);
223     }
224     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
225         uint price = oraclize.getPrice(datasource);
226         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
227         bytes memory args = stra2cbor(argN);
228         return oraclize.queryN.value(price)(timestamp, datasource, args);
229     }
230     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
231         uint price = oraclize.getPrice(datasource, gaslimit);
232         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
233         bytes memory args = stra2cbor(argN);
234         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
235     }
236     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
237         uint price = oraclize.getPrice(datasource, gaslimit);
238         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
239         bytes memory args = stra2cbor(argN);
240         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
241     }
242     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
243         string[] memory dynargs = new string[](1);
244         dynargs[0] = args[0];
245         return oraclize_query(datasource, dynargs);
246     }
247     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
248         string[] memory dynargs = new string[](1);
249         dynargs[0] = args[0];
250         return oraclize_query(timestamp, datasource, dynargs);
251     }
252     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
253         string[] memory dynargs = new string[](1);
254         dynargs[0] = args[0];
255         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
256     }
257     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
258         string[] memory dynargs = new string[](1);
259         dynargs[0] = args[0];
260         return oraclize_query(datasource, dynargs, gaslimit);
261     }
262 
263     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
264         string[] memory dynargs = new string[](2);
265         dynargs[0] = args[0];
266         dynargs[1] = args[1];
267         return oraclize_query(datasource, dynargs);
268     }
269     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
270         string[] memory dynargs = new string[](2);
271         dynargs[0] = args[0];
272         dynargs[1] = args[1];
273         return oraclize_query(timestamp, datasource, dynargs);
274     }
275     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
276         string[] memory dynargs = new string[](2);
277         dynargs[0] = args[0];
278         dynargs[1] = args[1];
279         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
280     }
281     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
282         string[] memory dynargs = new string[](2);
283         dynargs[0] = args[0];
284         dynargs[1] = args[1];
285         return oraclize_query(datasource, dynargs, gaslimit);
286     }
287     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
288         string[] memory dynargs = new string[](3);
289         dynargs[0] = args[0];
290         dynargs[1] = args[1];
291         dynargs[2] = args[2];
292         return oraclize_query(datasource, dynargs);
293     }
294     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
295         string[] memory dynargs = new string[](3);
296         dynargs[0] = args[0];
297         dynargs[1] = args[1];
298         dynargs[2] = args[2];
299         return oraclize_query(timestamp, datasource, dynargs);
300     }
301     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
302         string[] memory dynargs = new string[](3);
303         dynargs[0] = args[0];
304         dynargs[1] = args[1];
305         dynargs[2] = args[2];
306         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
307     }
308     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
309         string[] memory dynargs = new string[](3);
310         dynargs[0] = args[0];
311         dynargs[1] = args[1];
312         dynargs[2] = args[2];
313         return oraclize_query(datasource, dynargs, gaslimit);
314     }
315 
316     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
317         string[] memory dynargs = new string[](4);
318         dynargs[0] = args[0];
319         dynargs[1] = args[1];
320         dynargs[2] = args[2];
321         dynargs[3] = args[3];
322         return oraclize_query(datasource, dynargs);
323     }
324     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
325         string[] memory dynargs = new string[](4);
326         dynargs[0] = args[0];
327         dynargs[1] = args[1];
328         dynargs[2] = args[2];
329         dynargs[3] = args[3];
330         return oraclize_query(timestamp, datasource, dynargs);
331     }
332     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
333         string[] memory dynargs = new string[](4);
334         dynargs[0] = args[0];
335         dynargs[1] = args[1];
336         dynargs[2] = args[2];
337         dynargs[3] = args[3];
338         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
339     }
340     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
341         string[] memory dynargs = new string[](4);
342         dynargs[0] = args[0];
343         dynargs[1] = args[1];
344         dynargs[2] = args[2];
345         dynargs[3] = args[3];
346         return oraclize_query(datasource, dynargs, gaslimit);
347     }
348     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
349         string[] memory dynargs = new string[](5);
350         dynargs[0] = args[0];
351         dynargs[1] = args[1];
352         dynargs[2] = args[2];
353         dynargs[3] = args[3];
354         dynargs[4] = args[4];
355         return oraclize_query(datasource, dynargs);
356     }
357     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
358         string[] memory dynargs = new string[](5);
359         dynargs[0] = args[0];
360         dynargs[1] = args[1];
361         dynargs[2] = args[2];
362         dynargs[3] = args[3];
363         dynargs[4] = args[4];
364         return oraclize_query(timestamp, datasource, dynargs);
365     }
366     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
367         string[] memory dynargs = new string[](5);
368         dynargs[0] = args[0];
369         dynargs[1] = args[1];
370         dynargs[2] = args[2];
371         dynargs[3] = args[3];
372         dynargs[4] = args[4];
373         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
374     }
375     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
376         string[] memory dynargs = new string[](5);
377         dynargs[0] = args[0];
378         dynargs[1] = args[1];
379         dynargs[2] = args[2];
380         dynargs[3] = args[3];
381         dynargs[4] = args[4];
382         return oraclize_query(datasource, dynargs, gaslimit);
383     }
384     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
385         uint price = oraclize.getPrice(datasource);
386         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
387         bytes memory args = ba2cbor(argN);
388         return oraclize.queryN.value(price)(0, datasource, args);
389     }
390     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
391         uint price = oraclize.getPrice(datasource);
392         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
393         bytes memory args = ba2cbor(argN);
394         return oraclize.queryN.value(price)(timestamp, datasource, args);
395     }
396     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
397         uint price = oraclize.getPrice(datasource, gaslimit);
398         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
399         bytes memory args = ba2cbor(argN);
400         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
401     }
402     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
403         uint price = oraclize.getPrice(datasource, gaslimit);
404         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
405         bytes memory args = ba2cbor(argN);
406         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
407     }
408     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
409         bytes[] memory dynargs = new bytes[](1);
410         dynargs[0] = args[0];
411         return oraclize_query(datasource, dynargs);
412     }
413     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
414         bytes[] memory dynargs = new bytes[](1);
415         dynargs[0] = args[0];
416         return oraclize_query(timestamp, datasource, dynargs);
417     }
418     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
419         bytes[] memory dynargs = new bytes[](1);
420         dynargs[0] = args[0];
421         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
422     }
423     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
424         bytes[] memory dynargs = new bytes[](1);
425         dynargs[0] = args[0];
426         return oraclize_query(datasource, dynargs, gaslimit);
427     }
428 
429     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
430         bytes[] memory dynargs = new bytes[](2);
431         dynargs[0] = args[0];
432         dynargs[1] = args[1];
433         return oraclize_query(datasource, dynargs);
434     }
435     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
436         bytes[] memory dynargs = new bytes[](2);
437         dynargs[0] = args[0];
438         dynargs[1] = args[1];
439         return oraclize_query(timestamp, datasource, dynargs);
440     }
441     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
442         bytes[] memory dynargs = new bytes[](2);
443         dynargs[0] = args[0];
444         dynargs[1] = args[1];
445         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
446     }
447     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
448         bytes[] memory dynargs = new bytes[](2);
449         dynargs[0] = args[0];
450         dynargs[1] = args[1];
451         return oraclize_query(datasource, dynargs, gaslimit);
452     }
453     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
454         bytes[] memory dynargs = new bytes[](3);
455         dynargs[0] = args[0];
456         dynargs[1] = args[1];
457         dynargs[2] = args[2];
458         return oraclize_query(datasource, dynargs);
459     }
460     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
461         bytes[] memory dynargs = new bytes[](3);
462         dynargs[0] = args[0];
463         dynargs[1] = args[1];
464         dynargs[2] = args[2];
465         return oraclize_query(timestamp, datasource, dynargs);
466     }
467     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
468         bytes[] memory dynargs = new bytes[](3);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         dynargs[2] = args[2];
472         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
473     }
474     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
475         bytes[] memory dynargs = new bytes[](3);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         dynargs[2] = args[2];
479         return oraclize_query(datasource, dynargs, gaslimit);
480     }
481 
482     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
483         bytes[] memory dynargs = new bytes[](4);
484         dynargs[0] = args[0];
485         dynargs[1] = args[1];
486         dynargs[2] = args[2];
487         dynargs[3] = args[3];
488         return oraclize_query(datasource, dynargs);
489     }
490     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
491         bytes[] memory dynargs = new bytes[](4);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         dynargs[2] = args[2];
495         dynargs[3] = args[3];
496         return oraclize_query(timestamp, datasource, dynargs);
497     }
498     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
499         bytes[] memory dynargs = new bytes[](4);
500         dynargs[0] = args[0];
501         dynargs[1] = args[1];
502         dynargs[2] = args[2];
503         dynargs[3] = args[3];
504         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
505     }
506     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
507         bytes[] memory dynargs = new bytes[](4);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         dynargs[3] = args[3];
512         return oraclize_query(datasource, dynargs, gaslimit);
513     }
514     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
515         bytes[] memory dynargs = new bytes[](5);
516         dynargs[0] = args[0];
517         dynargs[1] = args[1];
518         dynargs[2] = args[2];
519         dynargs[3] = args[3];
520         dynargs[4] = args[4];
521         return oraclize_query(datasource, dynargs);
522     }
523     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
524         bytes[] memory dynargs = new bytes[](5);
525         dynargs[0] = args[0];
526         dynargs[1] = args[1];
527         dynargs[2] = args[2];
528         dynargs[3] = args[3];
529         dynargs[4] = args[4];
530         return oraclize_query(timestamp, datasource, dynargs);
531     }
532     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
533         bytes[] memory dynargs = new bytes[](5);
534         dynargs[0] = args[0];
535         dynargs[1] = args[1];
536         dynargs[2] = args[2];
537         dynargs[3] = args[3];
538         dynargs[4] = args[4];
539         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
540     }
541     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
542         bytes[] memory dynargs = new bytes[](5);
543         dynargs[0] = args[0];
544         dynargs[1] = args[1];
545         dynargs[2] = args[2];
546         dynargs[3] = args[3];
547         dynargs[4] = args[4];
548         return oraclize_query(datasource, dynargs, gaslimit);
549     }
550 
551     function oraclize_cbAddress() oraclizeAPI internal returns (address){
552         return oraclize.cbAddress();
553     }
554     function oraclize_setProof(byte proofP) oraclizeAPI internal {
555         return oraclize.setProofType(proofP);
556     }
557     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
558         return oraclize.setCustomGasPrice(gasPrice);
559     }
560     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
561         return oraclize.setConfig(config);
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
804         require((_nbytes != 0)||(_nbytes <= 32));
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
868         tosign2[0] = 1; //role
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
894         require((_proof[0] == "L")||(_proof[1] == "P")||(_proof[2] == 1));
895 
896         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
897         require(proofVerified == true);
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
912     function matchBytes32Prefix(bytes32 content, bytes prefix) internal pure returns (bool){
913         bool match_ = true;
914 
915         for (var i=0; i<prefix.length; i++){
916             if (content[i] != prefix[i]) match_ = false;
917         }
918 
919         return match_;
920     }
921 
922     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
923         bool checkok;
924 
925 
926         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
927         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
928         bytes memory keyhash = new bytes(32);
929         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
930         checkok = (keccak256(keyhash) == keccak256(sha256(context_name, queryId)));
931         if (checkok == false) return false;
932 
933         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
934         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
935 
936 
937         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
938         checkok = matchBytes32Prefix(sha256(sig1), result);
939         if (checkok == false) return false;
940 
941 
942         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
943         // This is to verify that the computed args match with the ones specified in the query.
944         bytes memory commitmentSlice1 = new bytes(8+1+32);
945         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
946 
947         bytes memory sessionPubkey = new bytes(64);
948         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
949         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
950 
951         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
952         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
953             delete oraclize_randomDS_args[queryId];
954         } else return false;
955 
956 
957         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
958         bytes memory tosign1 = new bytes(32+8+1+32);
959         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
960         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
961         if (checkok == false) return false;
962 
963         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
964         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
965             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
966         }
967 
968         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
969     }
970 
971 
972     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
973     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
974         uint minLength = length + toOffset;
975         require(to.length >= minLength);
976 
977         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
978         uint i = 32 + fromOffset;
979         uint j = 32 + toOffset;
980 
981         while (i < (32 + fromOffset + length)) {
982             assembly {
983                 let tmp := mload(add(from, i))
984                 mstore(add(to, j), tmp)
985             }
986             i += 32;
987             j += 32;
988         }
989 
990         return to;
991     }
992 
993     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
994     // Duplicate Solidity's ecrecover, but catching the CALL return value
995     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
996         // We do our own memory management here. Solidity uses memory offset
997         // 0x40 to store the current end of memory. We write past it (as
998         // writes are memory extensions), but don't update the offset so
999         // Solidity will reuse it. The memory used here is only needed for
1000         // this context.
1001 
1002         // FIXME: inline assembly can't access return values
1003         bool ret;
1004         address addr;
1005 
1006         assembly {
1007             let size := mload(0x40)
1008             mstore(size, hash)
1009             mstore(add(size, 32), v)
1010             mstore(add(size, 64), r)
1011             mstore(add(size, 96), s)
1012 
1013             // NOTE: we can reuse the request memory because we deal with
1014             //       the return code
1015             ret := call(3000, 1, 0, size, 128, size, 32)
1016             addr := mload(size)
1017         }
1018 
1019         return (ret, addr);
1020     }
1021 
1022     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1023     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1024         bytes32 r;
1025         bytes32 s;
1026         uint8 v;
1027 
1028         if (sig.length != 65)
1029           return (false, 0);
1030 
1031         // The signature format is a compact form of:
1032         //   {bytes32 r}{bytes32 s}{uint8 v}
1033         // Compact means, uint8 is not padded to 32 bytes.
1034         assembly {
1035             r := mload(add(sig, 32))
1036             s := mload(add(sig, 64))
1037 
1038             // Here we are loading the last 32 bytes. We exploit the fact that
1039             // 'mload' will pad with zeroes if we overread.
1040             // There is no 'mload8' to do this, but that would be nicer.
1041             v := byte(0, mload(add(sig, 96)))
1042 
1043             // Alternative solution:
1044             // 'byte' is not working due to the Solidity parser, so lets
1045             // use the second best option, 'and'
1046             // v := and(mload(add(sig, 65)), 255)
1047         }
1048 
1049         // albeit non-transactional signatures are not specified by the YP, one would expect it
1050         // to match the YP range of [27, 28]
1051         //
1052         // geth uses [0, 1] and some clients have followed. This might change, see:
1053         //  https://github.com/ethereum/go-ethereum/issues/2053
1054         if (v < 27)
1055           v += 27;
1056 
1057         if (v != 27 && v != 28)
1058             return (false, 0);
1059 
1060         return safer_ecrecover(hash, v, r, s);
1061     }
1062 
1063 }
1064 // </ORACLIZE_API>
1065 
1066 contract PriceReceiver {
1067   address public ethPriceProvider;
1068 
1069   modifier onlyEthPriceProvider() {
1070     require(msg.sender == ethPriceProvider);
1071     _;
1072   }
1073 
1074   function receiveEthPrice(uint ethUsdPrice) external;
1075 
1076   function setEthPriceProvider(address provider) external;
1077 }
1078 
1079 /**
1080  * @title SafeMath
1081  * @dev Math operations with safety checks that throw on error
1082  */
1083 library SafeMath {
1084 
1085   /**
1086   * @dev Multiplies two numbers, throws on overflow.
1087   */
1088   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1089     if (a == 0) {
1090       return 0;
1091     }
1092     uint256 c = a * b;
1093     assert(c / a == b);
1094     return c;
1095   }
1096 
1097   /**
1098   * @dev Integer division of two numbers, truncating the quotient.
1099   */
1100   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1101     // assert(b > 0); // Solidity automatically throws when dividing by 0
1102     uint256 c = a / b;
1103     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1104     return c;
1105   }
1106 
1107   /**
1108   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1109   */
1110   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1111     assert(b <= a);
1112     return a - b;
1113   }
1114 
1115   /**
1116   * @dev Adds two numbers, throws on overflow.
1117   */
1118   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1119     uint256 c = a + b;
1120     assert(c >= a);
1121     return c;
1122   }
1123 }
1124 
1125 contract PriceProvider is Ownable, usingOraclize {
1126   using SafeMath for uint;
1127 
1128   enum State { Stopped, Active }
1129 
1130   uint public updateInterval = 7200; //2 hours by default
1131 
1132   uint public currentPrice;
1133 
1134   string public url;
1135 
1136   mapping (bytes32 => bool) validIds;
1137 
1138   PriceReceiver public watcher;
1139 
1140   State public state = State.Stopped;
1141 
1142   uint constant MIN_ALLOWED_PRICE_DIFF = 85;
1143 
1144   uint constant MAX_ALLOWED_PRICE_DIFF = 115;
1145 
1146   event TooBigPriceDiff(uint oldValue, uint newValue);
1147 
1148   event InsufficientFunds();
1149 
1150   function notifyWatcher() internal;
1151 
1152   modifier inActiveState() {
1153     require(state == State.Active);
1154     _;
1155   }
1156 
1157   modifier inStoppedState() {
1158     require(state == State.Stopped);
1159     _;
1160   }
1161 
1162   function PriceProvider(string _url) public {
1163     url = _url;
1164 
1165     //update immediately first time to be sure everything is working - first oraclize request is free.
1166     update(0);
1167   }
1168 
1169   //send some funds along with the call to cover oraclize fees
1170   function startUpdate(uint startingPrice) external payable onlyOwner inStoppedState {
1171     state = State.Active;
1172 
1173     //we can set starting price manually, contract will notify watcher only in case of allowed diff
1174     //so owner can't set too small or to big price anyway
1175     currentPrice = startingPrice;
1176     update(updateInterval);
1177   }
1178 
1179   function stopUpdate() external onlyOwner inActiveState {
1180     state = State.Stopped;
1181   }
1182 
1183   function setWatcher(address newWatcher) external onlyOwner {
1184     require(newWatcher != 0x0);
1185     watcher = PriceReceiver(newWatcher);
1186   }
1187 
1188   function setUpdateInterval(uint newInterval) external onlyOwner {
1189     require(newInterval > 0);
1190     updateInterval = newInterval;
1191   }
1192 
1193   function setUrl(string newUrl) external onlyOwner {
1194     require(bytes(newUrl).length > 0);
1195     url = newUrl;
1196   }
1197 
1198   function __callback(bytes32 myid, string result, bytes proof) public {
1199     require(msg.sender == oraclize_cbAddress() && validIds[myid]);
1200     delete validIds[myid];
1201 
1202     uint newPrice = parseInt(result, 2);
1203     require(newPrice > 0);
1204     uint changeInPercents = newPrice.mul(100).div(currentPrice);
1205 
1206     if (changeInPercents >= MIN_ALLOWED_PRICE_DIFF && changeInPercents <= MAX_ALLOWED_PRICE_DIFF) {
1207       currentPrice = newPrice;
1208 
1209       if (state == State.Active) {
1210         notifyWatcher();
1211         update(updateInterval);
1212       }
1213     } else {
1214       state = State.Stopped;
1215       TooBigPriceDiff(currentPrice, newPrice);
1216     }
1217   }
1218 
1219   function update(uint delay) private {
1220     if (oraclize_getPrice("URL") > this.balance) {
1221       //stop if we don't have enough funds anymore
1222       state = State.Stopped;
1223       InsufficientFunds();
1224     } else {
1225       bytes32 queryId = oraclize_query(delay, "URL", url);
1226       validIds[queryId] = true;
1227     }
1228   }
1229 
1230   //we need to get back our funds if we don't need this oracle anymore
1231   function withdraw(address receiver) external onlyOwner inStoppedState {
1232     require(receiver != 0x0);
1233     receiver.transfer(this.balance);
1234   }
1235 }
1236 
1237 contract EthPriceProvider is PriceProvider {
1238   function EthPriceProvider() PriceProvider("json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0") {
1239 
1240   }
1241 
1242   function notifyWatcher() internal {
1243     watcher.receiveEthPrice(currentPrice);
1244   }
1245 }