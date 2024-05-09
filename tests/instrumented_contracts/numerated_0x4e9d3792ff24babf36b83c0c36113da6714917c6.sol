1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 //import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
62 // <ORACLIZE_API>
63 /*
64 Copyright (c) 2015-2016 Oraclize SRL
65 Copyright (c) 2016 Oraclize LTD
66 
67 
68 
69 Permission is hereby granted, free of charge, to any person obtaining a copy
70 of this software and associated documentation files (the "Software"), to deal
71 in the Software without restriction, including without limitation the rights
72 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
73 copies of the Software, and to permit persons to whom the Software is
74 furnished to do so, subject to the following conditions:
75 
76 
77 
78 The above copyright notice and this permission notice shall be included in
79 all copies or substantial portions of the Software.
80 
81 
82 
83 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
84 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
85 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
86 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
87 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
88 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
89 THE SOFTWARE.
90 */
91 
92 //please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
93 
94 contract OraclizeI {
95     address public cbAddress;
96     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
97     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
98     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
99     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
100     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
101     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
102     function getPrice(string _datasource) returns (uint _dsprice);
103     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
104     function useCoupon(string _coupon);
105     function setProofType(byte _proofType);
106     function setConfig(bytes32 _config);
107     function setCustomGasPrice(uint _gasPrice);
108     function randomDS_getSessionPubKeyHash() returns(bytes32);
109 }
110 contract OraclizeAddrResolverI {
111     function getAddress() returns (address _addr);
112 }
113 contract usingOraclize {
114     uint constant day = 60*60*24;
115     uint constant week = 60*60*24*7;
116     uint constant month = 60*60*24*30;
117     byte constant proofType_NONE = 0x00;
118     byte constant proofType_TLSNotary = 0x10;
119     byte constant proofType_Android = 0x20;
120     byte constant proofType_Ledger = 0x30;
121     byte constant proofType_Native = 0xF0;
122     byte constant proofStorage_IPFS = 0x01;
123     uint8 constant networkID_auto = 0;
124     uint8 constant networkID_mainnet = 1;
125     uint8 constant networkID_testnet = 2;
126     uint8 constant networkID_morden = 2;
127     uint8 constant networkID_consensys = 161;
128 
129     OraclizeAddrResolverI OAR;
130 
131     OraclizeI oraclize;
132     modifier oraclizeAPI {
133         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
134             oraclize_setNetwork(networkID_auto);
135 
136         if(address(oraclize) != OAR.getAddress())
137             oraclize = OraclizeI(OAR.getAddress());
138 
139         _;
140     }
141     modifier coupon(string code){
142         oraclize = OraclizeI(OAR.getAddress());
143         oraclize.useCoupon(code);
144         _;
145     }
146 
147     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
148         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
149             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
150             oraclize_setNetworkName("eth_mainnet");
151             return true;
152         }
153         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
154             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
155             oraclize_setNetworkName("eth_ropsten3");
156             return true;
157         }
158         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
159             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
160             oraclize_setNetworkName("eth_kovan");
161             return true;
162         }
163         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
164             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
165             oraclize_setNetworkName("eth_rinkeby");
166             return true;
167         }
168         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
169             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
170             return true;
171         }
172         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
173             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
174             return true;
175         }
176         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
177             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
178             return true;
179         }
180         return false;
181     }
182 
183     function __callback(bytes32 myid, string result) {
184         __callback(myid, result, new bytes(0));
185     }
186     function __callback(bytes32 myid, string result, bytes proof) {
187     }
188 
189     function oraclize_useCoupon(string code) oraclizeAPI internal {
190         oraclize.useCoupon(code);
191     }
192 
193     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
194         return oraclize.getPrice(datasource);
195     }
196 
197     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
198         return oraclize.getPrice(datasource, gaslimit);
199     }
200 
201     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
202         uint price = oraclize.getPrice(datasource);
203         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
204         return oraclize.query.value(price)(0, datasource, arg);
205     }
206     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
207         uint price = oraclize.getPrice(datasource);
208         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
209         return oraclize.query.value(price)(timestamp, datasource, arg);
210     }
211     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
212         uint price = oraclize.getPrice(datasource, gaslimit);
213         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
214         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
215     }
216     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
217         uint price = oraclize.getPrice(datasource, gaslimit);
218         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
219         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
220     }
221     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
222         uint price = oraclize.getPrice(datasource);
223         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
224         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
225     }
226     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
227         uint price = oraclize.getPrice(datasource);
228         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
229         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
230     }
231     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
232         uint price = oraclize.getPrice(datasource, gaslimit);
233         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
234         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
235     }
236     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
237         uint price = oraclize.getPrice(datasource, gaslimit);
238         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
239         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
240     }
241     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
242         uint price = oraclize.getPrice(datasource);
243         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
244         bytes memory args = stra2cbor(argN);
245         return oraclize.queryN.value(price)(0, datasource, args);
246     }
247     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
248         uint price = oraclize.getPrice(datasource);
249         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
250         bytes memory args = stra2cbor(argN);
251         return oraclize.queryN.value(price)(timestamp, datasource, args);
252     }
253     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
254         uint price = oraclize.getPrice(datasource, gaslimit);
255         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
256         bytes memory args = stra2cbor(argN);
257         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
258     }
259     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
260         uint price = oraclize.getPrice(datasource, gaslimit);
261         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
262         bytes memory args = stra2cbor(argN);
263         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
264     }
265     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
266         string[] memory dynargs = new string[](1);
267         dynargs[0] = args[0];
268         return oraclize_query(datasource, dynargs);
269     }
270     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
271         string[] memory dynargs = new string[](1);
272         dynargs[0] = args[0];
273         return oraclize_query(timestamp, datasource, dynargs);
274     }
275     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
276         string[] memory dynargs = new string[](1);
277         dynargs[0] = args[0];
278         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
279     }
280     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
281         string[] memory dynargs = new string[](1);
282         dynargs[0] = args[0];
283         return oraclize_query(datasource, dynargs, gaslimit);
284     }
285 
286     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
287         string[] memory dynargs = new string[](2);
288         dynargs[0] = args[0];
289         dynargs[1] = args[1];
290         return oraclize_query(datasource, dynargs);
291     }
292     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
293         string[] memory dynargs = new string[](2);
294         dynargs[0] = args[0];
295         dynargs[1] = args[1];
296         return oraclize_query(timestamp, datasource, dynargs);
297     }
298     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
299         string[] memory dynargs = new string[](2);
300         dynargs[0] = args[0];
301         dynargs[1] = args[1];
302         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
303     }
304     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
305         string[] memory dynargs = new string[](2);
306         dynargs[0] = args[0];
307         dynargs[1] = args[1];
308         return oraclize_query(datasource, dynargs, gaslimit);
309     }
310     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
311         string[] memory dynargs = new string[](3);
312         dynargs[0] = args[0];
313         dynargs[1] = args[1];
314         dynargs[2] = args[2];
315         return oraclize_query(datasource, dynargs);
316     }
317     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
318         string[] memory dynargs = new string[](3);
319         dynargs[0] = args[0];
320         dynargs[1] = args[1];
321         dynargs[2] = args[2];
322         return oraclize_query(timestamp, datasource, dynargs);
323     }
324     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
325         string[] memory dynargs = new string[](3);
326         dynargs[0] = args[0];
327         dynargs[1] = args[1];
328         dynargs[2] = args[2];
329         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
330     }
331     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
332         string[] memory dynargs = new string[](3);
333         dynargs[0] = args[0];
334         dynargs[1] = args[1];
335         dynargs[2] = args[2];
336         return oraclize_query(datasource, dynargs, gaslimit);
337     }
338 
339     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
340         string[] memory dynargs = new string[](4);
341         dynargs[0] = args[0];
342         dynargs[1] = args[1];
343         dynargs[2] = args[2];
344         dynargs[3] = args[3];
345         return oraclize_query(datasource, dynargs);
346     }
347     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
348         string[] memory dynargs = new string[](4);
349         dynargs[0] = args[0];
350         dynargs[1] = args[1];
351         dynargs[2] = args[2];
352         dynargs[3] = args[3];
353         return oraclize_query(timestamp, datasource, dynargs);
354     }
355     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
356         string[] memory dynargs = new string[](4);
357         dynargs[0] = args[0];
358         dynargs[1] = args[1];
359         dynargs[2] = args[2];
360         dynargs[3] = args[3];
361         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
362     }
363     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
364         string[] memory dynargs = new string[](4);
365         dynargs[0] = args[0];
366         dynargs[1] = args[1];
367         dynargs[2] = args[2];
368         dynargs[3] = args[3];
369         return oraclize_query(datasource, dynargs, gaslimit);
370     }
371     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
372         string[] memory dynargs = new string[](5);
373         dynargs[0] = args[0];
374         dynargs[1] = args[1];
375         dynargs[2] = args[2];
376         dynargs[3] = args[3];
377         dynargs[4] = args[4];
378         return oraclize_query(datasource, dynargs);
379     }
380     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
381         string[] memory dynargs = new string[](5);
382         dynargs[0] = args[0];
383         dynargs[1] = args[1];
384         dynargs[2] = args[2];
385         dynargs[3] = args[3];
386         dynargs[4] = args[4];
387         return oraclize_query(timestamp, datasource, dynargs);
388     }
389     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
390         string[] memory dynargs = new string[](5);
391         dynargs[0] = args[0];
392         dynargs[1] = args[1];
393         dynargs[2] = args[2];
394         dynargs[3] = args[3];
395         dynargs[4] = args[4];
396         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
397     }
398     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
399         string[] memory dynargs = new string[](5);
400         dynargs[0] = args[0];
401         dynargs[1] = args[1];
402         dynargs[2] = args[2];
403         dynargs[3] = args[3];
404         dynargs[4] = args[4];
405         return oraclize_query(datasource, dynargs, gaslimit);
406     }
407     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
408         uint price = oraclize.getPrice(datasource);
409         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
410         bytes memory args = ba2cbor(argN);
411         return oraclize.queryN.value(price)(0, datasource, args);
412     }
413     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
414         uint price = oraclize.getPrice(datasource);
415         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
416         bytes memory args = ba2cbor(argN);
417         return oraclize.queryN.value(price)(timestamp, datasource, args);
418     }
419     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
420         uint price = oraclize.getPrice(datasource, gaslimit);
421         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
422         bytes memory args = ba2cbor(argN);
423         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
424     }
425     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
426         uint price = oraclize.getPrice(datasource, gaslimit);
427         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
428         bytes memory args = ba2cbor(argN);
429         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
430     }
431     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
432         bytes[] memory dynargs = new bytes[](1);
433         dynargs[0] = args[0];
434         return oraclize_query(datasource, dynargs);
435     }
436     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
437         bytes[] memory dynargs = new bytes[](1);
438         dynargs[0] = args[0];
439         return oraclize_query(timestamp, datasource, dynargs);
440     }
441     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
442         bytes[] memory dynargs = new bytes[](1);
443         dynargs[0] = args[0];
444         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
445     }
446     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
447         bytes[] memory dynargs = new bytes[](1);
448         dynargs[0] = args[0];
449         return oraclize_query(datasource, dynargs, gaslimit);
450     }
451 
452     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
453         bytes[] memory dynargs = new bytes[](2);
454         dynargs[0] = args[0];
455         dynargs[1] = args[1];
456         return oraclize_query(datasource, dynargs);
457     }
458     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
459         bytes[] memory dynargs = new bytes[](2);
460         dynargs[0] = args[0];
461         dynargs[1] = args[1];
462         return oraclize_query(timestamp, datasource, dynargs);
463     }
464     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
465         bytes[] memory dynargs = new bytes[](2);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
469     }
470     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
471         bytes[] memory dynargs = new bytes[](2);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         return oraclize_query(datasource, dynargs, gaslimit);
475     }
476     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
477         bytes[] memory dynargs = new bytes[](3);
478         dynargs[0] = args[0];
479         dynargs[1] = args[1];
480         dynargs[2] = args[2];
481         return oraclize_query(datasource, dynargs);
482     }
483     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
484         bytes[] memory dynargs = new bytes[](3);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         dynargs[2] = args[2];
488         return oraclize_query(timestamp, datasource, dynargs);
489     }
490     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
491         bytes[] memory dynargs = new bytes[](3);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         dynargs[2] = args[2];
495         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
496     }
497     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         bytes[] memory dynargs = new bytes[](3);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         return oraclize_query(datasource, dynargs, gaslimit);
503     }
504 
505     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
506         bytes[] memory dynargs = new bytes[](4);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         dynargs[3] = args[3];
511         return oraclize_query(datasource, dynargs);
512     }
513     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
514         bytes[] memory dynargs = new bytes[](4);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         dynargs[3] = args[3];
519         return oraclize_query(timestamp, datasource, dynargs);
520     }
521     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
522         bytes[] memory dynargs = new bytes[](4);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         dynargs[2] = args[2];
526         dynargs[3] = args[3];
527         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
528     }
529     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
530         bytes[] memory dynargs = new bytes[](4);
531         dynargs[0] = args[0];
532         dynargs[1] = args[1];
533         dynargs[2] = args[2];
534         dynargs[3] = args[3];
535         return oraclize_query(datasource, dynargs, gaslimit);
536     }
537     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
538         bytes[] memory dynargs = new bytes[](5);
539         dynargs[0] = args[0];
540         dynargs[1] = args[1];
541         dynargs[2] = args[2];
542         dynargs[3] = args[3];
543         dynargs[4] = args[4];
544         return oraclize_query(datasource, dynargs);
545     }
546     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
547         bytes[] memory dynargs = new bytes[](5);
548         dynargs[0] = args[0];
549         dynargs[1] = args[1];
550         dynargs[2] = args[2];
551         dynargs[3] = args[3];
552         dynargs[4] = args[4];
553         return oraclize_query(timestamp, datasource, dynargs);
554     }
555     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
556         bytes[] memory dynargs = new bytes[](5);
557         dynargs[0] = args[0];
558         dynargs[1] = args[1];
559         dynargs[2] = args[2];
560         dynargs[3] = args[3];
561         dynargs[4] = args[4];
562         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
563     }
564     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
565         bytes[] memory dynargs = new bytes[](5);
566         dynargs[0] = args[0];
567         dynargs[1] = args[1];
568         dynargs[2] = args[2];
569         dynargs[3] = args[3];
570         dynargs[4] = args[4];
571         return oraclize_query(datasource, dynargs, gaslimit);
572     }
573 
574     function oraclize_cbAddress() oraclizeAPI internal returns (address){
575         return oraclize.cbAddress();
576     }
577     function oraclize_setProof(byte proofP) oraclizeAPI internal {
578         return oraclize.setProofType(proofP);
579     }
580     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
581         return oraclize.setCustomGasPrice(gasPrice);
582     }
583     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
584         return oraclize.setConfig(config);
585     }
586 
587     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
588         return oraclize.randomDS_getSessionPubKeyHash();
589     }
590 
591     function getCodeSize(address _addr) constant internal returns(uint _size) {
592         assembly {
593             _size := extcodesize(_addr)
594         }
595     }
596 
597     function parseAddr(string _a) internal returns (address){
598         bytes memory tmp = bytes(_a);
599         uint160 iaddr = 0;
600         uint160 b1;
601         uint160 b2;
602         for (uint i=2; i<2+2*20; i+=2){
603             iaddr *= 256;
604             b1 = uint160(tmp[i]);
605             b2 = uint160(tmp[i+1]);
606             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
607             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
608             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
609             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
610             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
611             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
612             iaddr += (b1*16+b2);
613         }
614         return address(iaddr);
615     }
616 
617     function strCompare(string _a, string _b) internal returns (int) {
618         bytes memory a = bytes(_a);
619         bytes memory b = bytes(_b);
620         uint minLength = a.length;
621         if (b.length < minLength) minLength = b.length;
622         for (uint i = 0; i < minLength; i ++)
623             if (a[i] < b[i])
624                 return -1;
625             else if (a[i] > b[i])
626                 return 1;
627         if (a.length < b.length)
628             return -1;
629         else if (a.length > b.length)
630             return 1;
631         else
632             return 0;
633     }
634 
635     function indexOf(string _haystack, string _needle) internal returns (int) {
636         bytes memory h = bytes(_haystack);
637         bytes memory n = bytes(_needle);
638         if(h.length < 1 || n.length < 1 || (n.length > h.length))
639             return -1;
640         else if(h.length > (2**128 -1))
641             return -1;
642         else
643         {
644             uint subindex = 0;
645             for (uint i = 0; i < h.length; i ++)
646             {
647                 if (h[i] == n[0])
648                 {
649                     subindex = 1;
650                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
651                     {
652                         subindex++;
653                     }
654                     if(subindex == n.length)
655                         return int(i);
656                 }
657             }
658             return -1;
659         }
660     }
661 
662     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
663         bytes memory _ba = bytes(_a);
664         bytes memory _bb = bytes(_b);
665         bytes memory _bc = bytes(_c);
666         bytes memory _bd = bytes(_d);
667         bytes memory _be = bytes(_e);
668         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
669         bytes memory babcde = bytes(abcde);
670         uint k = 0;
671         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
672         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
673         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
674         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
675         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
676         return string(babcde);
677     }
678 
679     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
680         return strConcat(_a, _b, _c, _d, "");
681     }
682 
683     function strConcat(string _a, string _b, string _c) internal returns (string) {
684         return strConcat(_a, _b, _c, "", "");
685     }
686 
687     function strConcat(string _a, string _b) internal returns (string) {
688         return strConcat(_a, _b, "", "", "");
689     }
690 
691     // parseInt
692     function parseInt(string _a) internal returns (uint) {
693         return parseInt(_a, 0);
694     }
695 
696     // parseInt(parseFloat*10^_b)
697     function parseInt(string _a, uint _b) internal returns (uint) {
698         bytes memory bresult = bytes(_a);
699         uint mint = 0;
700         bool decimals = false;
701         for (uint i=0; i<bresult.length; i++){
702             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
703                 if (decimals){
704                    if (_b == 0) break;
705                     else _b--;
706                 }
707                 mint *= 10;
708                 mint += uint(bresult[i]) - 48;
709             } else if (bresult[i] == 46) decimals = true;
710         }
711         if (_b > 0) mint *= 10**_b;
712         return mint;
713     }
714 
715     function uint2str(uint i) internal returns (string){
716         if (i == 0) return "0";
717         uint j = i;
718         uint len;
719         while (j != 0){
720             len++;
721             j /= 10;
722         }
723         bytes memory bstr = new bytes(len);
724         uint k = len - 1;
725         while (i != 0){
726             bstr[k--] = byte(48 + i % 10);
727             i /= 10;
728         }
729         return string(bstr);
730     }
731 
732     function stra2cbor(string[] arr) internal returns (bytes) {
733             uint arrlen = arr.length;
734 
735             // get correct cbor output length
736             uint outputlen = 0;
737             bytes[] memory elemArray = new bytes[](arrlen);
738             for (uint i = 0; i < arrlen; i++) {
739                 elemArray[i] = (bytes(arr[i]));
740                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
741             }
742             uint ctr = 0;
743             uint cborlen = arrlen + 0x80;
744             outputlen += byte(cborlen).length;
745             bytes memory res = new bytes(outputlen);
746 
747             while (byte(cborlen).length > ctr) {
748                 res[ctr] = byte(cborlen)[ctr];
749                 ctr++;
750             }
751             for (i = 0; i < arrlen; i++) {
752                 res[ctr] = 0x5F;
753                 ctr++;
754                 for (uint x = 0; x < elemArray[i].length; x++) {
755                     // if there's a bug with larger strings, this may be the culprit
756                     if (x % 23 == 0) {
757                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
758                         elemcborlen += 0x40;
759                         uint lctr = ctr;
760                         while (byte(elemcborlen).length > ctr - lctr) {
761                             res[ctr] = byte(elemcborlen)[ctr - lctr];
762                             ctr++;
763                         }
764                     }
765                     res[ctr] = elemArray[i][x];
766                     ctr++;
767                 }
768                 res[ctr] = 0xFF;
769                 ctr++;
770             }
771             return res;
772         }
773 
774     function ba2cbor(bytes[] arr) internal returns (bytes) {
775             uint arrlen = arr.length;
776 
777             // get correct cbor output length
778             uint outputlen = 0;
779             bytes[] memory elemArray = new bytes[](arrlen);
780             for (uint i = 0; i < arrlen; i++) {
781                 elemArray[i] = (bytes(arr[i]));
782                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
783             }
784             uint ctr = 0;
785             uint cborlen = arrlen + 0x80;
786             outputlen += byte(cborlen).length;
787             bytes memory res = new bytes(outputlen);
788 
789             while (byte(cborlen).length > ctr) {
790                 res[ctr] = byte(cborlen)[ctr];
791                 ctr++;
792             }
793             for (i = 0; i < arrlen; i++) {
794                 res[ctr] = 0x5F;
795                 ctr++;
796                 for (uint x = 0; x < elemArray[i].length; x++) {
797                     // if there's a bug with larger strings, this may be the culprit
798                     if (x % 23 == 0) {
799                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
800                         elemcborlen += 0x40;
801                         uint lctr = ctr;
802                         while (byte(elemcborlen).length > ctr - lctr) {
803                             res[ctr] = byte(elemcborlen)[ctr - lctr];
804                             ctr++;
805                         }
806                     }
807                     res[ctr] = elemArray[i][x];
808                     ctr++;
809                 }
810                 res[ctr] = 0xFF;
811                 ctr++;
812             }
813             return res;
814         }
815 
816 
817     string oraclize_network_name;
818     function oraclize_setNetworkName(string _network_name) internal {
819         oraclize_network_name = _network_name;
820     }
821 
822     function oraclize_getNetworkName() internal returns (string) {
823         return oraclize_network_name;
824     }
825 
826     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
827         if ((_nbytes == 0)||(_nbytes > 32)) throw;
828         bytes memory nbytes = new bytes(1);
829         nbytes[0] = byte(_nbytes);
830         bytes memory unonce = new bytes(32);
831         bytes memory sessionKeyHash = new bytes(32);
832         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
833         assembly {
834             mstore(unonce, 0x20)
835             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
836             mstore(sessionKeyHash, 0x20)
837             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
838         }
839         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
840         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
841         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
842         return queryId;
843     }
844 
845     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
846         oraclize_randomDS_args[queryId] = commitment;
847     }
848 
849     mapping(bytes32=>bytes32) oraclize_randomDS_args;
850     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
851 
852     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
853         bool sigok;
854         address signer;
855 
856         bytes32 sigr;
857         bytes32 sigs;
858 
859         bytes memory sigr_ = new bytes(32);
860         uint offset = 4+(uint(dersig[3]) - 0x20);
861         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
862         bytes memory sigs_ = new bytes(32);
863         offset += 32 + 2;
864         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
865 
866         assembly {
867             sigr := mload(add(sigr_, 32))
868             sigs := mload(add(sigs_, 32))
869         }
870 
871 
872         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
873         if (address(sha3(pubkey)) == signer) return true;
874         else {
875             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
876             return (address(sha3(pubkey)) == signer);
877         }
878     }
879 
880     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
881         bool sigok;
882 
883         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
884         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
885         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
886 
887         bytes memory appkey1_pubkey = new bytes(64);
888         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
889 
890         bytes memory tosign2 = new bytes(1+65+32);
891         tosign2[0] = 1; //role
892         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
893         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
894         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
895         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
896 
897         if (sigok == false) return false;
898 
899 
900         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
901         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
902 
903         bytes memory tosign3 = new bytes(1+65);
904         tosign3[0] = 0xFE;
905         copyBytes(proof, 3, 65, tosign3, 1);
906 
907         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
908         copyBytes(proof, 3+65, sig3.length, sig3, 0);
909 
910         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
911 
912         return sigok;
913     }
914 
915     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
916         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
917         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
918 
919         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
920         if (proofVerified == false) throw;
921 
922         _;
923     }
924 
925     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
926         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
927         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
928 
929         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
930         if (proofVerified == false) return 2;
931 
932         return 0;
933     }
934 
935     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
936         bool match_ = true;
937         
938         for (uint256 i=0; i< n_random_bytes; i++) {
939             if (content[i] != prefix[i]) match_ = false;
940         }
941 
942         return match_;
943     }
944 
945     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
946 
947         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
948         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
949         bytes memory keyhash = new bytes(32);
950         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
951         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
952 
953         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
954         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
955 
956         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
957         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
958 
959         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
960         // This is to verify that the computed args match with the ones specified in the query.
961         bytes memory commitmentSlice1 = new bytes(8+1+32);
962         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
963 
964         bytes memory sessionPubkey = new bytes(64);
965         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
966         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
967 
968         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
969         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
970             delete oraclize_randomDS_args[queryId];
971         } else return false;
972 
973 
974         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
975         bytes memory tosign1 = new bytes(32+8+1+32);
976         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
977         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
978 
979         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
980         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
981             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
982         }
983 
984         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
985     }
986 
987 
988     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
989     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
990         uint minLength = length + toOffset;
991 
992         if (to.length < minLength) {
993             // Buffer too small
994             throw; // Should be a better way?
995         }
996 
997         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
998         uint i = 32 + fromOffset;
999         uint j = 32 + toOffset;
1000 
1001         while (i < (32 + fromOffset + length)) {
1002             assembly {
1003                 let tmp := mload(add(from, i))
1004                 mstore(add(to, j), tmp)
1005             }
1006             i += 32;
1007             j += 32;
1008         }
1009 
1010         return to;
1011     }
1012 
1013     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1014     // Duplicate Solidity's ecrecover, but catching the CALL return value
1015     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1016         // We do our own memory management here. Solidity uses memory offset
1017         // 0x40 to store the current end of memory. We write past it (as
1018         // writes are memory extensions), but don't update the offset so
1019         // Solidity will reuse it. The memory used here is only needed for
1020         // this context.
1021 
1022         // FIXME: inline assembly can't access return values
1023         bool ret;
1024         address addr;
1025 
1026         assembly {
1027             let size := mload(0x40)
1028             mstore(size, hash)
1029             mstore(add(size, 32), v)
1030             mstore(add(size, 64), r)
1031             mstore(add(size, 96), s)
1032 
1033             // NOTE: we can reuse the request memory because we deal with
1034             //       the return code
1035             ret := call(3000, 1, 0, size, 128, size, 32)
1036             addr := mload(size)
1037         }
1038 
1039         return (ret, addr);
1040     }
1041 
1042     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1043     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1044         bytes32 r;
1045         bytes32 s;
1046         uint8 v;
1047 
1048         if (sig.length != 65)
1049           return (false, 0);
1050 
1051         // The signature format is a compact form of:
1052         //   {bytes32 r}{bytes32 s}{uint8 v}
1053         // Compact means, uint8 is not padded to 32 bytes.
1054         assembly {
1055             r := mload(add(sig, 32))
1056             s := mload(add(sig, 64))
1057 
1058             // Here we are loading the last 32 bytes. We exploit the fact that
1059             // 'mload' will pad with zeroes if we overread.
1060             // There is no 'mload8' to do this, but that would be nicer.
1061             v := byte(0, mload(add(sig, 96)))
1062 
1063             // Alternative solution:
1064             // 'byte' is not working due to the Solidity parser, so lets
1065             // use the second best option, 'and'
1066             // v := and(mload(add(sig, 65)), 255)
1067         }
1068 
1069         // albeit non-transactional signatures are not specified by the YP, one would expect it
1070         // to match the YP range of [27, 28]
1071         //
1072         // geth uses [0, 1] and some clients have followed. This might change, see:
1073         //  https://github.com/ethereum/go-ethereum/issues/2053
1074         if (v < 27)
1075           v += 27;
1076 
1077         if (v != 27 && v != 28)
1078             return (false, 0);
1079 
1080         return safer_ecrecover(hash, v, r, s);
1081     }
1082 
1083 }
1084 // </ORACLIZE_API>
1085 
1086 
1087 //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";
1088 
1089 
1090 
1091 /**
1092  * @title SafeMath
1093  * @dev Math operations with safety checks that throw on error
1094  */
1095 library SafeMath {
1096   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1097     if (a == 0) {
1098       return 0;
1099     }
1100     uint256 c = a * b;
1101     assert(c / a == b);
1102     return c;
1103   }
1104 
1105   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1106     // assert(b > 0); // Solidity automatically throws when dividing by 0
1107     uint256 c = a / b;
1108     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1109     return c;
1110   }
1111 
1112   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1113     assert(b <= a);
1114     return a - b;
1115   }
1116 
1117   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1118     uint256 c = a + b;
1119     assert(c >= a);
1120     return c;
1121   }
1122 }
1123 
1124 
1125 
1126 /**
1127  * @title Basic token
1128  * @dev Basic version of StandardToken, with no allowances.
1129  */
1130 contract BasicToken is ERC20Basic {
1131   using SafeMath for uint256;
1132 
1133   mapping(address => uint256) balances;
1134 
1135   /**
1136   * @dev transfer token for a specified address
1137   * @param _to The address to transfer to.
1138   * @param _value The amount to be transferred.
1139   */
1140   function transfer(address _to, uint256 _value) public returns (bool) {
1141     require(_to != address(0));
1142     require(_value <= balances[msg.sender]);
1143 
1144     // SafeMath.sub will throw if there is not enough balance.
1145     balances[msg.sender] = balances[msg.sender].sub(_value);
1146     balances[_to] = balances[_to].add(_value);
1147     Transfer(msg.sender, _to, _value);
1148     return true;
1149   }
1150 
1151   /**
1152   * @dev Gets the balance of the specified address.
1153   * @param _owner The address to query the the balance of.
1154   * @return An uint256 representing the amount owned by the passed address.
1155   */
1156   function balanceOf(address _owner) public view returns (uint256 balance) {
1157     return balances[_owner];
1158   }
1159 
1160 }
1161 
1162 
1163 /**
1164  * @title Burnable Token
1165  * @dev Token that can be irreversibly burned (destroyed).
1166  */
1167 contract BurnableToken is BasicToken {
1168 
1169     event Burn(address indexed burner, uint256 value);
1170 
1171     /**
1172      * @dev Burns a specific amount of tokens.
1173      * @param _value The amount of token to be burned.
1174      */
1175     function burn(uint256 _value) public {
1176         require(_value <= balances[msg.sender]);
1177         // no need to require value <= totalSupply, since that would imply the
1178         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1179 
1180         address burner = msg.sender;
1181         balances[burner] = balances[burner].sub(_value);
1182         totalSupply = totalSupply.sub(_value);
1183         Burn(burner, _value);
1184     }
1185 }
1186 
1187 
1188 
1189 
1190  /* ERC223 additions to ERC20 */
1191 
1192 
1193 
1194  /*
1195   ERC223 additions to ERC20
1196 
1197   Interface wise is ERC20 + data paramenter to transfer and transferFrom.
1198  */
1199 
1200 //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20.sol";
1201 
1202 
1203 
1204 
1205 
1206 
1207 /**
1208  * @title ERC20 interface
1209  * @dev see https://github.com/ethereum/EIPs/issues/20
1210  */
1211 contract ERC20 is ERC20Basic {
1212   function allowance(address owner, address spender) public view returns (uint256);
1213   function transferFrom(address from, address to, uint256 value) public returns (bool);
1214   function approve(address spender, uint256 value) public returns (bool);
1215   event Approval(address indexed owner, address indexed spender, uint256 value);
1216 }
1217 
1218 
1219 contract ERC223 is ERC20 {
1220   function transfer(address to, uint value, bytes data) returns (bool ok);
1221   function transferFrom(address from, address to, uint value, bytes data) returns (bool ok);
1222   
1223   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
1224 }
1225 
1226 
1227 
1228 /*
1229 Base class contracts willing to accept ERC223 token transfers must conform to.
1230 
1231 Sender: msg.sender to the token contract, the address originating the token transfer.
1232           - For user originated transfers sender will be equal to tx.origin
1233           - For contract originated transfers, tx.origin will be the user that made the tx that produced the transfer.
1234 Origin: the origin address from whose balance the tokens are sent
1235           - For transfer(), origin = msg.sender
1236           - For transferFrom() origin = _from to token contract
1237 Value is the amount of tokens sent
1238 Data is arbitrary data sent with the token transfer. Simulates ether tx.data
1239 
1240 From, origin and value shouldn't be trusted unless the token contract is trusted.
1241 If sender == tx.origin, it is safe to trust it regardless of the token.
1242 */
1243 
1244 contract ERC223Receiver {
1245   function tokenFallback(address _from, uint _value, bytes _data);
1246 }
1247 
1248 
1249 //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/StandardToken.sol";
1250 
1251 
1252 
1253 
1254 
1255 
1256 
1257 /**
1258  * @title Standard ERC20 token
1259  *
1260  * @dev Implementation of the basic standard token.
1261  * @dev https://github.com/ethereum/EIPs/issues/20
1262  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1263  */
1264 contract StandardToken is ERC20, BasicToken {
1265 
1266   mapping (address => mapping (address => uint256)) internal allowed;
1267 
1268 
1269   /**
1270    * @dev Transfer tokens from one address to another
1271    * @param _from address The address which you want to send tokens from
1272    * @param _to address The address which you want to transfer to
1273    * @param _value uint256 the amount of tokens to be transferred
1274    */
1275   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1276     require(_to != address(0));
1277     require(_value <= balances[_from]);
1278     require(_value <= allowed[_from][msg.sender]);
1279 
1280     balances[_from] = balances[_from].sub(_value);
1281     balances[_to] = balances[_to].add(_value);
1282     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1283     Transfer(_from, _to, _value);
1284     return true;
1285   }
1286 
1287   /**
1288    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1289    *
1290    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1291    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1292    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1293    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1294    * @param _spender The address which will spend the funds.
1295    * @param _value The amount of tokens to be spent.
1296    */
1297   function approve(address _spender, uint256 _value) public returns (bool) {
1298     allowed[msg.sender][_spender] = _value;
1299     Approval(msg.sender, _spender, _value);
1300     return true;
1301   }
1302 
1303   /**
1304    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1305    * @param _owner address The address which owns the funds.
1306    * @param _spender address The address which will spend the funds.
1307    * @return A uint256 specifying the amount of tokens still available for the spender.
1308    */
1309   function allowance(address _owner, address _spender) public view returns (uint256) {
1310     return allowed[_owner][_spender];
1311   }
1312 
1313   /**
1314    * @dev Increase the amount of tokens that an owner allowed to a spender.
1315    *
1316    * approve should be called when allowed[_spender] == 0. To increment
1317    * allowed value is better to use this function to avoid 2 calls (and wait until
1318    * the first transaction is mined)
1319    * From MonolithDAO Token.sol
1320    * @param _spender The address which will spend the funds.
1321    * @param _addedValue The amount of tokens to increase the allowance by.
1322    */
1323   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1324     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1325     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1326     return true;
1327   }
1328 
1329   /**
1330    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1331    *
1332    * approve should be called when allowed[_spender] == 0. To decrement
1333    * allowed value is better to use this function to avoid 2 calls (and wait until
1334    * the first transaction is mined)
1335    * From MonolithDAO Token.sol
1336    * @param _spender The address which will spend the funds.
1337    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1338    */
1339   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1340     uint oldValue = allowed[msg.sender][_spender];
1341     if (_subtractedValue > oldValue) {
1342       allowed[msg.sender][_spender] = 0;
1343     } else {
1344       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1345     }
1346     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1347     return true;
1348   }
1349 
1350 }
1351 
1352 
1353 contract Standard223Token is ERC223, StandardToken {
1354   //function that is called when a user or another contract wants to transfer funds
1355   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
1356     //filtering if the target is a contract with bytecode inside it
1357     if (!super.transfer(_to, _value)) throw; // do a normal token transfer
1358     if (isContract(_to)) contractFallback(msg.sender, _to, _value, _data);
1359    Transfer(msg.sender, _to, _value, _data);
1360     return true;
1361   }
1362 
1363   function transferFrom(address _from, address _to, uint _value, bytes _data) returns (bool success) {
1364     if (!super.transferFrom(_from, _to, _value)) throw; // do a normal token transfer
1365     if (isContract(_to)) contractFallback(_from, _to, _value, _data);
1366     Transfer(_from, _to, _value, _data);
1367     return true;
1368   }
1369 
1370   function transfer(address _to, uint _value) returns (bool success) {
1371     return transfer(_to, _value, new bytes(0));
1372   }
1373 
1374   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
1375     return transferFrom(_from, _to, _value, new bytes(0));
1376   }
1377 
1378   //function that is called when transaction target is a contract
1379   function contractFallback(address _origin, address _to, uint _value, bytes _data) private {
1380     ERC223Receiver reciever = ERC223Receiver(_to);
1381     reciever.tokenFallback(_origin, _value, _data);
1382   }
1383 
1384   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
1385   function isContract(address _addr) private returns (bool is_contract) {
1386     // retrieve the size of the code on target address, this needs assembly
1387     uint length;
1388     assembly { length := extcodesize(_addr) }
1389     return length > 0;
1390   }
1391 }
1392 
1393 /**
1394  * @title RefundVault
1395  * @dev This contract is used for storing funds while a crowdsale
1396  * is in progress. Supports refunding the money if crowdsale fails,
1397  * and forwarding it if crowdsale is successful.
1398  */
1399 contract RefundVault {
1400   using SafeMath for uint256;
1401 
1402   enum State { Active, Refunding, Released}
1403 
1404   mapping (address => uint256) public vault_deposited;
1405   address public vault_wallet;
1406   State public vault_state;
1407   uint256 totalDeposited = 0;
1408   uint256 public refundDeadline;
1409 
1410   event DepositReleased();
1411   event RefundsEnabled();
1412   event RefundsDisabled();
1413   event Refunded(address indexed beneficiary, uint256 weiAmount);
1414 
1415   function RefundVault() public {
1416     vault_state = State.Active;
1417   }
1418 
1419   function vault_deposit(address investor, uint256 _value) internal {
1420     require(vault_state == State.Active);
1421     vault_deposited[investor] = vault_deposited[investor].add(_value);
1422     totalDeposited = totalDeposited.add(_value);
1423   }
1424 
1425   function vault_releaseDeposit() internal {
1426     vault_state = State.Released;
1427     DepositReleased();
1428     if (totalDeposited > 0) {vault_wallet.transfer(totalDeposited);}
1429     totalDeposited = 0;
1430   }
1431 
1432   function vault_enableRefunds() internal {
1433     require(vault_state == State.Active);
1434     refundDeadline = now + 180 days;
1435     vault_state = State.Refunding;
1436     RefundsEnabled();
1437   }
1438 
1439   function vault_refund(address investor) internal {
1440     require(vault_state == State.Refunding);
1441     uint256 depositedValue = vault_deposited[investor];
1442     vault_deposited[investor] = 0;
1443     investor.transfer(depositedValue);
1444     Refunded(investor, depositedValue);
1445     totalDeposited = totalDeposited.sub(depositedValue);
1446   }
1447 }
1448 
1449 // @dev TLC Token Sale (ICO)
1450 
1451 contract TLC is usingOraclize, Ownable, RefundVault, BurnableToken, Standard223Token
1452 {
1453     string public constant name = "TrillCoin";
1454     string public constant symbol = "TLC";
1455     uint8 public constant decimals = 18;
1456     uint public constant DECIMALS_MULTIPLIER = 10**uint(decimals);
1457     
1458     uint public ICOstarttime = 1519048800;  // (GMT): Monday, February 19, 2018 2:00:00 PM          
1459     uint public ICOendtime = 1521464400;    // (GMT): Monday, March 19, 2018 1:00:00 PM      
1460     
1461     uint public minimumInvestmentInWei = DECIMALS_MULTIPLIER / 50; // .02 ETH MIN
1462     uint public maximumInvestmentInWei = 100 * 1 ether;            // 100 ETH MAX
1463     address saleWalletAddress;
1464 
1465     uint256 public constant softcapInTokens = 2000000 * DECIMALS_MULTIPLIER; 
1466     uint256 public constant hardcapInTokens = 400000000 * DECIMALS_MULTIPLIER;
1467     
1468     uint256 public totaltokensold = 0;
1469     
1470     uint public USDETH = 925;
1471     uint NumberOfTokensIn1USD = 20;
1472     
1473     //RefundVault public vault;
1474     bool public isFinalized = false;
1475     event Finalized();
1476     
1477     event newOraclizeQuery(string description);
1478     event newETHUSDPrice(string price);
1479     
1480     function increaseSupply(uint value, address to) public onlyOwner returns (bool) {
1481         totalSupply = totalSupply.add(value);
1482         balances[to] = balances[to].add(value);
1483         Transfer(0, to, value);
1484         return true;
1485     }
1486 
1487 
1488     
1489     
1490     function burn(uint256 _value) public {
1491         require(0 != _value);
1492         
1493         super.burn(_value);
1494         Transfer(msg.sender, 0, _value);
1495     }
1496     
1497 
1498     
1499     function transferOwnership(address newOwner) public onlyOwner {
1500         require(newOwner != address(0));
1501         uint256 localOwnerBalance = balances[owner];
1502         balances[newOwner] = balances[newOwner].add(localOwnerBalance);
1503         balances[owner] = 0;
1504         vault_wallet = newOwner;
1505         Transfer(owner, newOwner, localOwnerBalance);
1506         super.transferOwnership(newOwner);
1507     }
1508     
1509     function finalize() public {
1510         require(!isFinalized);
1511         require(ICOendtime < now);
1512         finalization();
1513         Finalized();
1514         isFinalized = true;
1515     }
1516   
1517     function depositFunds() internal {
1518         vault_deposit(msg.sender, msg.value * 95 / 100);
1519     }
1520     
1521     // if crowdsale is unsuccessful, investors can claim refunds here
1522     function claimRefund() public {
1523         require(isFinalized);
1524         require(!goalReached());
1525         
1526         uint256 refundedTokens = balances[msg.sender];
1527         balances[owner] = balances[owner].add(refundedTokens);
1528         totaltokensold = totaltokensold.sub(refundedTokens);
1529         balances[msg.sender] = 0;
1530         
1531         Transfer(msg.sender, owner, refundedTokens);
1532         
1533         vault_refund(msg.sender);
1534     }
1535     
1536     // vault finalization task, called when owner calls finalize()
1537     function finalization() internal {
1538         if (goalReached()) {
1539             vault_releaseDeposit();
1540         } else {
1541             vault_enableRefunds();
1542             
1543         }
1544     }
1545     
1546     function releaseUnclaimedFunds() onlyOwner public {
1547         require(vault_state == State.Refunding && now >= refundDeadline);
1548         vault_releaseDeposit();
1549     }
1550 
1551     function goalReached() public view returns (bool) {
1552         return totaltokensold >= softcapInTokens;
1553     }    
1554     
1555     function __callback(bytes32 myid, string result) {
1556         require (msg.sender == oraclize_cbAddress());
1557 
1558         newETHUSDPrice(result);
1559 
1560         USDETH = parseInt(result, 0);
1561         if ((now < ICOendtime) && (totaltokensold < hardcapInTokens))
1562         {
1563             UpdateUSDETHPriceAfter(day); //update every 24 hours
1564         }
1565         
1566     }
1567     
1568 
1569   function UpdateUSDETHPriceAfter (uint delay) private {
1570       
1571     newOraclizeQuery("Update of USD/ETH price requested");
1572     oraclize_query(delay, "URL", "json(https://api.etherscan.io/api?module=stats&action=ethprice&apikey=YourApiKeyToken).result.ethusd");
1573        
1574   }
1575 
1576 
1577   
1578 
1579   function TLC() public payable {
1580       totalSupply = 500000000 * DECIMALS_MULTIPLIER;
1581       balances[owner] = totalSupply;
1582       vault_wallet = owner;
1583       Transfer(0x0, owner, totalSupply);
1584       initializeSaleWalletAddress();
1585       UpdateUSDETHPriceAfter(0);
1586   }
1587   
1588   function initializeSaleWalletAddress() private {
1589       saleWalletAddress = 0x3Eec20A05C35868fa1E2499Fe5594eF0ab04b03f;
1590       
1591   }
1592   
1593 
1594 
1595   
1596 
1597   function () payable {
1598        if (msg.sender != owner) {
1599           buy();
1600        }
1601   }
1602   
1603   function ICOactive() public view returns (bool success) {
1604       if (ICOstarttime < now && now < ICOendtime && totaltokensold < hardcapInTokens) {
1605           return true;
1606       }
1607       
1608       return false;
1609   }
1610 
1611   function buy() payable {
1612 
1613       
1614 
1615       require (msg.value >= minimumInvestmentInWei && msg.value <= maximumInvestmentInWei);
1616 
1617       require (ICOactive());
1618       
1619       uint256 NumberOfTokensToGive = msg.value.mul(USDETH).mul(NumberOfTokensIn1USD);
1620      
1621 
1622       
1623       if(now <= ICOstarttime + week) {
1624           
1625           NumberOfTokensToGive = NumberOfTokensToGive.mul(125).div(100);
1626           
1627       } else{
1628           NumberOfTokensToGive = NumberOfTokensToGive;
1629       }
1630       
1631       uint256 localTotaltokensold = totaltokensold;
1632       require(localTotaltokensold + NumberOfTokensToGive <= hardcapInTokens);
1633       totaltokensold = localTotaltokensold.add(NumberOfTokensToGive);
1634       
1635       address localOwner = owner;
1636       balances[msg.sender] = balances[msg.sender].add(NumberOfTokensToGive);
1637       balances[localOwner] = balances[localOwner].sub(NumberOfTokensToGive);
1638       Transfer(localOwner, msg.sender, NumberOfTokensToGive);
1639       
1640       saleWalletAddress.transfer(msg.value - msg.value * 95 / 100);
1641       
1642       if(!goalReached() && (RefundVault.State.Active == vault_state))
1643       {
1644           depositFunds();
1645       } else {
1646           if(RefundVault.State.Active == vault_state) {vault_releaseDeposit();}
1647           localOwner.transfer(msg.value * 95 / 100);
1648       }
1649   }
1650   
1651 }