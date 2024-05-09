1 pragma solidity ^0.4.21;
2 
3 contract IExchange {
4     function ethToTokens(uint _ethAmount) public view returns(uint);
5     function tokenToEth(uint _amountOfTokens) public view returns(uint);
6     function tokenToEthRate() public view returns(uint);
7     function ethToTokenRate() public view returns(uint);
8 }
9 
10 library SafeMath {
11     function add(uint a, uint b) internal pure returns (uint c) {
12         c = a + b;
13         require(c >= a);
14     }
15     function sub(uint a, uint b) internal pure returns (uint c) {
16         require(b <= a);
17         c = a - b;
18     }
19     function mul(uint a, uint b) internal pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b);
22     }
23     function div(uint a, uint b) internal pure returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 
30 contract Owned {
31     address public owner;
32     address public newOwner;
33 
34     event OwnershipTransferred(address indexed _from, address indexed _to);
35 
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address _newOwner) public onlyOwner {
46         newOwner = _newOwner;
47     }
48     function acceptOwnership() public {
49         require(msg.sender == newOwner);
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52         newOwner = address(0);
53     }
54 }
55 
56 contract IERC20 {
57     function totalSupply() public constant returns (uint);
58     function balanceOf(address tokenOwner) public constant returns (uint balance);
59     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
60     function transfer(address to, uint tokens) public returns (bool success);
61     function approve(address spender, uint tokens) public returns (bool success);
62     function transferFrom(address from, address to, uint tokens) public returns (bool success);
63 
64     event Transfer(address indexed from, address indexed to, uint tokens);
65     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
66 }
67 
68 
69 
70 
71 
72 
73 
74 // <ORACLIZE_API>
75 /*
76 Copyright (c) 2015-2016 Oraclize SRL
77 Copyright (c) 2016 Oraclize LTD
78 
79 
80 
81 Permission is hereby granted, free of charge, to any person obtaining a copy
82 of this software and associated documentation files (the "Software"), to deal
83 in the Software without restriction, including without limitation the rights
84 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
85 copies of the Software, and to permit persons to whom the Software is
86 furnished to do so, subject to the following conditions:
87 
88 
89 
90 The above copyright notice and this permission notice shall be included in
91 all copies or substantial portions of the Software.
92 
93 
94 
95 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
96 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
97 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
98 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
99 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
100 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
101 THE SOFTWARE.
102 */
103 
104 contract OraclizeI {
105     address public cbAddress;
106     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
107     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
108     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
109     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
110     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
111     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
112     function getPrice(string _datasource) public returns (uint _dsprice);
113     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
114     function setProofType(byte _proofType) external;
115     function setCustomGasPrice(uint _gasPrice) external;
116     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
117 }
118 contract OraclizeAddrResolverI {
119     function getAddress() public returns (address _addr);
120 }
121 contract usingOraclize {
122     uint constant day = 60*60*24;
123     uint constant week = 60*60*24*7;
124     uint constant month = 60*60*24*30;
125     byte constant proofType_NONE = 0x00;
126     byte constant proofType_TLSNotary = 0x10;
127     byte constant proofType_Android = 0x20;
128     byte constant proofType_Ledger = 0x30;
129     byte constant proofType_Native = 0xF0;
130     byte constant proofStorage_IPFS = 0x01;
131     uint8 constant networkID_auto = 0;
132     uint8 constant networkID_mainnet = 1;
133     uint8 constant networkID_testnet = 2;
134     uint8 constant networkID_morden = 2;
135     uint8 constant networkID_consensys = 161;
136 
137     OraclizeAddrResolverI OAR;
138 
139     OraclizeI oraclize;
140     modifier oraclizeAPI {
141         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
142             oraclize_setNetwork(networkID_auto);
143 
144         if(address(oraclize) != OAR.getAddress())
145             oraclize = OraclizeI(OAR.getAddress());
146 
147         _;
148     }
149     modifier coupon(string code){
150         oraclize = OraclizeI(OAR.getAddress());
151         _;
152     }
153 
154     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
155       return oraclize_setNetwork();
156       networkID; // silence the warning and remain backwards compatible
157     }
158     function oraclize_setNetwork() internal returns(bool){
159         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
160             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
161             oraclize_setNetworkName("eth_mainnet");
162             return true;
163         }
164         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
165             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
166             oraclize_setNetworkName("eth_ropsten3");
167             return true;
168         }
169         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
170             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
171             oraclize_setNetworkName("eth_kovan");
172             return true;
173         }
174         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
175             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
176             oraclize_setNetworkName("eth_rinkeby");
177             return true;
178         }
179         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
180             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
181             return true;
182         }
183         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
184             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
185             return true;
186         }
187         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
188             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
189             return true;
190         }
191         return false;
192     }
193 
194     function __callback(bytes32 myid, string result) public {
195         __callback(myid, result, new bytes(0));
196     }
197     function __callback(bytes32 myid, string result, bytes proof) public {
198       return;
199       myid; result; proof; // Silence compiler warnings
200     }
201 
202     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
203         return oraclize.getPrice(datasource);
204     }
205 
206     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
207         return oraclize.getPrice(datasource, gaslimit);
208     }
209 
210     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
211         uint price = oraclize.getPrice(datasource);
212         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
213         return oraclize.query.value(price)(0, datasource, arg);
214     }
215     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
216         uint price = oraclize.getPrice(datasource);
217         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
218         return oraclize.query.value(price)(timestamp, datasource, arg);
219     }
220     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
221         uint price = oraclize.getPrice(datasource, gaslimit);
222         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
223         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
224     }
225     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
226         uint price = oraclize.getPrice(datasource, gaslimit);
227         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
228         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
229     }
230     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
231         uint price = oraclize.getPrice(datasource);
232         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
233         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
234     }
235     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
236         uint price = oraclize.getPrice(datasource);
237         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
238         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
239     }
240     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
241         uint price = oraclize.getPrice(datasource, gaslimit);
242         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
243         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
244     }
245     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
246         uint price = oraclize.getPrice(datasource, gaslimit);
247         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
248         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
249     }
250     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
251         uint price = oraclize.getPrice(datasource);
252         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
253         bytes memory args = stra2cbor(argN);
254         return oraclize.queryN.value(price)(0, datasource, args);
255     }
256     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
257         uint price = oraclize.getPrice(datasource);
258         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
259         bytes memory args = stra2cbor(argN);
260         return oraclize.queryN.value(price)(timestamp, datasource, args);
261     }
262     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
263         uint price = oraclize.getPrice(datasource, gaslimit);
264         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
265         bytes memory args = stra2cbor(argN);
266         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
267     }
268     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
269         uint price = oraclize.getPrice(datasource, gaslimit);
270         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
271         bytes memory args = stra2cbor(argN);
272         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
273     }
274     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
275         string[] memory dynargs = new string[](1);
276         dynargs[0] = args[0];
277         return oraclize_query(datasource, dynargs);
278     }
279     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
280         string[] memory dynargs = new string[](1);
281         dynargs[0] = args[0];
282         return oraclize_query(timestamp, datasource, dynargs);
283     }
284     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
285         string[] memory dynargs = new string[](1);
286         dynargs[0] = args[0];
287         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
288     }
289     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
290         string[] memory dynargs = new string[](1);
291         dynargs[0] = args[0];
292         return oraclize_query(datasource, dynargs, gaslimit);
293     }
294 
295     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
296         string[] memory dynargs = new string[](2);
297         dynargs[0] = args[0];
298         dynargs[1] = args[1];
299         return oraclize_query(datasource, dynargs);
300     }
301     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
302         string[] memory dynargs = new string[](2);
303         dynargs[0] = args[0];
304         dynargs[1] = args[1];
305         return oraclize_query(timestamp, datasource, dynargs);
306     }
307     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
308         string[] memory dynargs = new string[](2);
309         dynargs[0] = args[0];
310         dynargs[1] = args[1];
311         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
312     }
313     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
314         string[] memory dynargs = new string[](2);
315         dynargs[0] = args[0];
316         dynargs[1] = args[1];
317         return oraclize_query(datasource, dynargs, gaslimit);
318     }
319     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
320         string[] memory dynargs = new string[](3);
321         dynargs[0] = args[0];
322         dynargs[1] = args[1];
323         dynargs[2] = args[2];
324         return oraclize_query(datasource, dynargs);
325     }
326     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
327         string[] memory dynargs = new string[](3);
328         dynargs[0] = args[0];
329         dynargs[1] = args[1];
330         dynargs[2] = args[2];
331         return oraclize_query(timestamp, datasource, dynargs);
332     }
333     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
334         string[] memory dynargs = new string[](3);
335         dynargs[0] = args[0];
336         dynargs[1] = args[1];
337         dynargs[2] = args[2];
338         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
339     }
340     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
341         string[] memory dynargs = new string[](3);
342         dynargs[0] = args[0];
343         dynargs[1] = args[1];
344         dynargs[2] = args[2];
345         return oraclize_query(datasource, dynargs, gaslimit);
346     }
347 
348     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
349         string[] memory dynargs = new string[](4);
350         dynargs[0] = args[0];
351         dynargs[1] = args[1];
352         dynargs[2] = args[2];
353         dynargs[3] = args[3];
354         return oraclize_query(datasource, dynargs);
355     }
356     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
357         string[] memory dynargs = new string[](4);
358         dynargs[0] = args[0];
359         dynargs[1] = args[1];
360         dynargs[2] = args[2];
361         dynargs[3] = args[3];
362         return oraclize_query(timestamp, datasource, dynargs);
363     }
364     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
365         string[] memory dynargs = new string[](4);
366         dynargs[0] = args[0];
367         dynargs[1] = args[1];
368         dynargs[2] = args[2];
369         dynargs[3] = args[3];
370         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
371     }
372     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
373         string[] memory dynargs = new string[](4);
374         dynargs[0] = args[0];
375         dynargs[1] = args[1];
376         dynargs[2] = args[2];
377         dynargs[3] = args[3];
378         return oraclize_query(datasource, dynargs, gaslimit);
379     }
380     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
381         string[] memory dynargs = new string[](5);
382         dynargs[0] = args[0];
383         dynargs[1] = args[1];
384         dynargs[2] = args[2];
385         dynargs[3] = args[3];
386         dynargs[4] = args[4];
387         return oraclize_query(datasource, dynargs);
388     }
389     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
390         string[] memory dynargs = new string[](5);
391         dynargs[0] = args[0];
392         dynargs[1] = args[1];
393         dynargs[2] = args[2];
394         dynargs[3] = args[3];
395         dynargs[4] = args[4];
396         return oraclize_query(timestamp, datasource, dynargs);
397     }
398     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
399         string[] memory dynargs = new string[](5);
400         dynargs[0] = args[0];
401         dynargs[1] = args[1];
402         dynargs[2] = args[2];
403         dynargs[3] = args[3];
404         dynargs[4] = args[4];
405         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
406     }
407     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
408         string[] memory dynargs = new string[](5);
409         dynargs[0] = args[0];
410         dynargs[1] = args[1];
411         dynargs[2] = args[2];
412         dynargs[3] = args[3];
413         dynargs[4] = args[4];
414         return oraclize_query(datasource, dynargs, gaslimit);
415     }
416     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
417         uint price = oraclize.getPrice(datasource);
418         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
419         bytes memory args = ba2cbor(argN);
420         return oraclize.queryN.value(price)(0, datasource, args);
421     }
422     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
423         uint price = oraclize.getPrice(datasource);
424         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
425         bytes memory args = ba2cbor(argN);
426         return oraclize.queryN.value(price)(timestamp, datasource, args);
427     }
428     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
429         uint price = oraclize.getPrice(datasource, gaslimit);
430         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
431         bytes memory args = ba2cbor(argN);
432         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
433     }
434     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
435         uint price = oraclize.getPrice(datasource, gaslimit);
436         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
437         bytes memory args = ba2cbor(argN);
438         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
439     }
440     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
441         bytes[] memory dynargs = new bytes[](1);
442         dynargs[0] = args[0];
443         return oraclize_query(datasource, dynargs);
444     }
445     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
446         bytes[] memory dynargs = new bytes[](1);
447         dynargs[0] = args[0];
448         return oraclize_query(timestamp, datasource, dynargs);
449     }
450     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
451         bytes[] memory dynargs = new bytes[](1);
452         dynargs[0] = args[0];
453         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
454     }
455     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
456         bytes[] memory dynargs = new bytes[](1);
457         dynargs[0] = args[0];
458         return oraclize_query(datasource, dynargs, gaslimit);
459     }
460 
461     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
462         bytes[] memory dynargs = new bytes[](2);
463         dynargs[0] = args[0];
464         dynargs[1] = args[1];
465         return oraclize_query(datasource, dynargs);
466     }
467     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
468         bytes[] memory dynargs = new bytes[](2);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         return oraclize_query(timestamp, datasource, dynargs);
472     }
473     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         bytes[] memory dynargs = new bytes[](2);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
478     }
479     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
480         bytes[] memory dynargs = new bytes[](2);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         return oraclize_query(datasource, dynargs, gaslimit);
484     }
485     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
486         bytes[] memory dynargs = new bytes[](3);
487         dynargs[0] = args[0];
488         dynargs[1] = args[1];
489         dynargs[2] = args[2];
490         return oraclize_query(datasource, dynargs);
491     }
492     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
493         bytes[] memory dynargs = new bytes[](3);
494         dynargs[0] = args[0];
495         dynargs[1] = args[1];
496         dynargs[2] = args[2];
497         return oraclize_query(timestamp, datasource, dynargs);
498     }
499     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
500         bytes[] memory dynargs = new bytes[](3);
501         dynargs[0] = args[0];
502         dynargs[1] = args[1];
503         dynargs[2] = args[2];
504         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
505     }
506     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
507         bytes[] memory dynargs = new bytes[](3);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         return oraclize_query(datasource, dynargs, gaslimit);
512     }
513 
514     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
515         bytes[] memory dynargs = new bytes[](4);
516         dynargs[0] = args[0];
517         dynargs[1] = args[1];
518         dynargs[2] = args[2];
519         dynargs[3] = args[3];
520         return oraclize_query(datasource, dynargs);
521     }
522     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
523         bytes[] memory dynargs = new bytes[](4);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         dynargs[3] = args[3];
528         return oraclize_query(timestamp, datasource, dynargs);
529     }
530     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
531         bytes[] memory dynargs = new bytes[](4);
532         dynargs[0] = args[0];
533         dynargs[1] = args[1];
534         dynargs[2] = args[2];
535         dynargs[3] = args[3];
536         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
537     }
538     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
539         bytes[] memory dynargs = new bytes[](4);
540         dynargs[0] = args[0];
541         dynargs[1] = args[1];
542         dynargs[2] = args[2];
543         dynargs[3] = args[3];
544         return oraclize_query(datasource, dynargs, gaslimit);
545     }
546     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
547         bytes[] memory dynargs = new bytes[](5);
548         dynargs[0] = args[0];
549         dynargs[1] = args[1];
550         dynargs[2] = args[2];
551         dynargs[3] = args[3];
552         dynargs[4] = args[4];
553         return oraclize_query(datasource, dynargs);
554     }
555     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
556         bytes[] memory dynargs = new bytes[](5);
557         dynargs[0] = args[0];
558         dynargs[1] = args[1];
559         dynargs[2] = args[2];
560         dynargs[3] = args[3];
561         dynargs[4] = args[4];
562         return oraclize_query(timestamp, datasource, dynargs);
563     }
564     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
565         bytes[] memory dynargs = new bytes[](5);
566         dynargs[0] = args[0];
567         dynargs[1] = args[1];
568         dynargs[2] = args[2];
569         dynargs[3] = args[3];
570         dynargs[4] = args[4];
571         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
572     }
573     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
574         bytes[] memory dynargs = new bytes[](5);
575         dynargs[0] = args[0];
576         dynargs[1] = args[1];
577         dynargs[2] = args[2];
578         dynargs[3] = args[3];
579         dynargs[4] = args[4];
580         return oraclize_query(datasource, dynargs, gaslimit);
581     }
582 
583     function oraclize_cbAddress() oraclizeAPI internal returns (address){
584         return oraclize.cbAddress();
585     }
586     function oraclize_setProof(byte proofP) oraclizeAPI internal {
587         return oraclize.setProofType(proofP);
588     }
589     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
590         return oraclize.setCustomGasPrice(gasPrice);
591     }
592 
593     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
594         return oraclize.randomDS_getSessionPubKeyHash();
595     }
596 
597     function getCodeSize(address _addr) constant internal returns(uint _size) {
598         assembly {
599             _size := extcodesize(_addr)
600         }
601     }
602 
603     function parseAddr(string _a) internal pure returns (address){
604         bytes memory tmp = bytes(_a);
605         uint160 iaddr = 0;
606         uint160 b1;
607         uint160 b2;
608         for (uint i=2; i<2+2*20; i+=2){
609             iaddr *= 256;
610             b1 = uint160(tmp[i]);
611             b2 = uint160(tmp[i+1]);
612             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
613             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
614             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
615             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
616             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
617             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
618             iaddr += (b1*16+b2);
619         }
620         return address(iaddr);
621     }
622 
623     function strCompare(string _a, string _b) internal pure returns (int) {
624         bytes memory a = bytes(_a);
625         bytes memory b = bytes(_b);
626         uint minLength = a.length;
627         if (b.length < minLength) minLength = b.length;
628         for (uint i = 0; i < minLength; i ++)
629             if (a[i] < b[i])
630                 return -1;
631             else if (a[i] > b[i])
632                 return 1;
633         if (a.length < b.length)
634             return -1;
635         else if (a.length > b.length)
636             return 1;
637         else
638             return 0;
639     }
640 
641     function indexOf(string _haystack, string _needle) internal pure returns (int) {
642         bytes memory h = bytes(_haystack);
643         bytes memory n = bytes(_needle);
644         if(h.length < 1 || n.length < 1 || (n.length > h.length))
645             return -1;
646         else if(h.length > (2**128 -1))
647             return -1;
648         else
649         {
650             uint subindex = 0;
651             for (uint i = 0; i < h.length; i ++)
652             {
653                 if (h[i] == n[0])
654                 {
655                     subindex = 1;
656                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
657                     {
658                         subindex++;
659                     }
660                     if(subindex == n.length)
661                         return int(i);
662                 }
663             }
664             return -1;
665         }
666     }
667 
668     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
669         bytes memory _ba = bytes(_a);
670         bytes memory _bb = bytes(_b);
671         bytes memory _bc = bytes(_c);
672         bytes memory _bd = bytes(_d);
673         bytes memory _be = bytes(_e);
674         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
675         bytes memory babcde = bytes(abcde);
676         uint k = 0;
677         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
678         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
679         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
680         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
681         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
682         return string(babcde);
683     }
684 
685     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
686         return strConcat(_a, _b, _c, _d, "");
687     }
688 
689     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
690         return strConcat(_a, _b, _c, "", "");
691     }
692 
693     function strConcat(string _a, string _b) internal pure returns (string) {
694         return strConcat(_a, _b, "", "", "");
695     }
696 
697     // parseInt
698     function parseInt(string _a) internal pure returns (uint) {
699         return parseInt(_a, 0);
700     }
701 
702     // parseInt(parseFloat*10^_b)
703     function parseInt(string _a, uint _b) internal pure returns (uint) {
704         bytes memory bresult = bytes(_a);
705         uint mint = 0;
706         bool decimals = false;
707         for (uint i=0; i<bresult.length; i++){
708             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
709                 if (decimals){
710                    if (_b == 0) break;
711                     else _b--;
712                 }
713                 mint *= 10;
714                 mint += uint(bresult[i]) - 48;
715             } else if (bresult[i] == 46) decimals = true;
716         }
717         if (_b > 0) mint *= 10**_b;
718         return mint;
719     }
720 
721     function uint2str(uint i) internal pure returns (string){
722         if (i == 0) return "0";
723         uint j = i;
724         uint len;
725         while (j != 0){
726             len++;
727             j /= 10;
728         }
729         bytes memory bstr = new bytes(len);
730         uint k = len - 1;
731         while (i != 0){
732             bstr[k--] = byte(48 + i % 10);
733             i /= 10;
734         }
735         return string(bstr);
736     }
737 
738     function stra2cbor(string[] arr) internal pure returns (bytes) {
739             uint arrlen = arr.length;
740 
741             // get correct cbor output length
742             uint outputlen = 0;
743             bytes[] memory elemArray = new bytes[](arrlen);
744             for (uint i = 0; i < arrlen; i++) {
745                 elemArray[i] = (bytes(arr[i]));
746                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
747             }
748             uint ctr = 0;
749             uint cborlen = arrlen + 0x80;
750             outputlen += byte(cborlen).length;
751             bytes memory res = new bytes(outputlen);
752 
753             while (byte(cborlen).length > ctr) {
754                 res[ctr] = byte(cborlen)[ctr];
755                 ctr++;
756             }
757             for (i = 0; i < arrlen; i++) {
758                 res[ctr] = 0x5F;
759                 ctr++;
760                 for (uint x = 0; x < elemArray[i].length; x++) {
761                     // if there's a bug with larger strings, this may be the culprit
762                     if (x % 23 == 0) {
763                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
764                         elemcborlen += 0x40;
765                         uint lctr = ctr;
766                         while (byte(elemcborlen).length > ctr - lctr) {
767                             res[ctr] = byte(elemcborlen)[ctr - lctr];
768                             ctr++;
769                         }
770                     }
771                     res[ctr] = elemArray[i][x];
772                     ctr++;
773                 }
774                 res[ctr] = 0xFF;
775                 ctr++;
776             }
777             return res;
778         }
779 
780     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
781             uint arrlen = arr.length;
782 
783             // get correct cbor output length
784             uint outputlen = 0;
785             bytes[] memory elemArray = new bytes[](arrlen);
786             for (uint i = 0; i < arrlen; i++) {
787                 elemArray[i] = (bytes(arr[i]));
788                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
789             }
790             uint ctr = 0;
791             uint cborlen = arrlen + 0x80;
792             outputlen += byte(cborlen).length;
793             bytes memory res = new bytes(outputlen);
794 
795             while (byte(cborlen).length > ctr) {
796                 res[ctr] = byte(cborlen)[ctr];
797                 ctr++;
798             }
799             for (i = 0; i < arrlen; i++) {
800                 res[ctr] = 0x5F;
801                 ctr++;
802                 for (uint x = 0; x < elemArray[i].length; x++) {
803                     // if there's a bug with larger strings, this may be the culprit
804                     if (x % 23 == 0) {
805                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
806                         elemcborlen += 0x40;
807                         uint lctr = ctr;
808                         while (byte(elemcborlen).length > ctr - lctr) {
809                             res[ctr] = byte(elemcborlen)[ctr - lctr];
810                             ctr++;
811                         }
812                     }
813                     res[ctr] = elemArray[i][x];
814                     ctr++;
815                 }
816                 res[ctr] = 0xFF;
817                 ctr++;
818             }
819             return res;
820         }
821 
822 
823     string oraclize_network_name;
824     function oraclize_setNetworkName(string _network_name) internal {
825         oraclize_network_name = _network_name;
826     }
827 
828     function oraclize_getNetworkName() internal view returns (string) {
829         return oraclize_network_name;
830     }
831 
832     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
833         require((_nbytes > 0) && (_nbytes <= 32));
834         // Convert from seconds to ledger timer ticks
835         _delay *= 10; 
836         bytes memory nbytes = new bytes(1);
837         nbytes[0] = byte(_nbytes);
838         bytes memory unonce = new bytes(32);
839         bytes memory sessionKeyHash = new bytes(32);
840         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
841         assembly {
842             mstore(unonce, 0x20)
843             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
844             mstore(sessionKeyHash, 0x20)
845             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
846         }
847         bytes memory delay = new bytes(32);
848         assembly { 
849             mstore(add(delay, 0x20), _delay) 
850         }
851         
852         bytes memory delay_bytes8 = new bytes(8);
853         copyBytes(delay, 24, 8, delay_bytes8, 0);
854 
855         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
856         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
857         
858         bytes memory delay_bytes8_left = new bytes(8);
859         
860         assembly {
861             let x := mload(add(delay_bytes8, 0x20))
862             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
863             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
864             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
865             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
866             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
867             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
868             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
869             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
870 
871         }
872         
873         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
874         return queryId;
875     }
876     
877     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
878         oraclize_randomDS_args[queryId] = commitment;
879     }
880 
881     mapping(bytes32=>bytes32) oraclize_randomDS_args;
882     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
883 
884     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
885         bool sigok;
886         address signer;
887 
888         bytes32 sigr;
889         bytes32 sigs;
890 
891         bytes memory sigr_ = new bytes(32);
892         uint offset = 4+(uint(dersig[3]) - 0x20);
893         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
894         bytes memory sigs_ = new bytes(32);
895         offset += 32 + 2;
896         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
897 
898         assembly {
899             sigr := mload(add(sigr_, 32))
900             sigs := mload(add(sigs_, 32))
901         }
902 
903 
904         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
905         if (address(keccak256(pubkey)) == signer) return true;
906         else {
907             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
908             return (address(keccak256(pubkey)) == signer);
909         }
910     }
911 
912     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
913         bool sigok;
914 
915         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
916         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
917         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
918 
919         bytes memory appkey1_pubkey = new bytes(64);
920         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
921 
922         bytes memory tosign2 = new bytes(1+65+32);
923         tosign2[0] = byte(1); //role
924         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
925         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
926         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
927         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
928 
929         if (sigok == false) return false;
930 
931 
932         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
933         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
934 
935         bytes memory tosign3 = new bytes(1+65);
936         tosign3[0] = 0xFE;
937         copyBytes(proof, 3, 65, tosign3, 1);
938 
939         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
940         copyBytes(proof, 3+65, sig3.length, sig3, 0);
941 
942         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
943 
944         return sigok;
945     }
946 
947     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
948         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
949         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
950 
951         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
952         require(proofVerified);
953 
954         _;
955     }
956 
957     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
958         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
959         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
960 
961         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
962         if (proofVerified == false) return 2;
963 
964         return 0;
965     }
966 
967     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
968         bool match_ = true;
969         
970         require(prefix.length == n_random_bytes);
971 
972         for (uint256 i=0; i< n_random_bytes; i++) {
973             if (content[i] != prefix[i]) match_ = false;
974         }
975 
976         return match_;
977     }
978 
979     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
980 
981         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
982         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
983         bytes memory keyhash = new bytes(32);
984         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
985         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
986 
987         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
988         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
989 
990         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
991         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
992 
993         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
994         // This is to verify that the computed args match with the ones specified in the query.
995         bytes memory commitmentSlice1 = new bytes(8+1+32);
996         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
997 
998         bytes memory sessionPubkey = new bytes(64);
999         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1000         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1001 
1002         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1003         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1004             delete oraclize_randomDS_args[queryId];
1005         } else return false;
1006 
1007 
1008         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1009         bytes memory tosign1 = new bytes(32+8+1+32);
1010         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1011         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1012 
1013         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1014         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1015             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1016         }
1017 
1018         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1019     }
1020 
1021     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1022     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1023         uint minLength = length + toOffset;
1024 
1025         // Buffer too small
1026         require(to.length >= minLength); // Should be a better way?
1027 
1028         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1029         uint i = 32 + fromOffset;
1030         uint j = 32 + toOffset;
1031 
1032         while (i < (32 + fromOffset + length)) {
1033             assembly {
1034                 let tmp := mload(add(from, i))
1035                 mstore(add(to, j), tmp)
1036             }
1037             i += 32;
1038             j += 32;
1039         }
1040 
1041         return to;
1042     }
1043 
1044     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1045     // Duplicate Solidity's ecrecover, but catching the CALL return value
1046     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1047         // We do our own memory management here. Solidity uses memory offset
1048         // 0x40 to store the current end of memory. We write past it (as
1049         // writes are memory extensions), but don't update the offset so
1050         // Solidity will reuse it. The memory used here is only needed for
1051         // this context.
1052 
1053         // FIXME: inline assembly can't access return values
1054         bool ret;
1055         address addr;
1056 
1057         assembly {
1058             let size := mload(0x40)
1059             mstore(size, hash)
1060             mstore(add(size, 32), v)
1061             mstore(add(size, 64), r)
1062             mstore(add(size, 96), s)
1063 
1064             // NOTE: we can reuse the request memory because we deal with
1065             //       the return code
1066             ret := call(3000, 1, 0, size, 128, size, 32)
1067             addr := mload(size)
1068         }
1069 
1070         return (ret, addr);
1071     }
1072 
1073     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1074     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1075         bytes32 r;
1076         bytes32 s;
1077         uint8 v;
1078 
1079         if (sig.length != 65)
1080           return (false, 0);
1081 
1082         // The signature format is a compact form of:
1083         //   {bytes32 r}{bytes32 s}{uint8 v}
1084         // Compact means, uint8 is not padded to 32 bytes.
1085         assembly {
1086             r := mload(add(sig, 32))
1087             s := mload(add(sig, 64))
1088 
1089             // Here we are loading the last 32 bytes. We exploit the fact that
1090             // 'mload' will pad with zeroes if we overread.
1091             // There is no 'mload8' to do this, but that would be nicer.
1092             v := byte(0, mload(add(sig, 96)))
1093 
1094             // Alternative solution:
1095             // 'byte' is not working due to the Solidity parser, so lets
1096             // use the second best option, 'and'
1097             // v := and(mload(add(sig, 65)), 255)
1098         }
1099 
1100         // albeit non-transactional signatures are not specified by the YP, one would expect it
1101         // to match the YP range of [27, 28]
1102         //
1103         // geth uses [0, 1] and some clients have followed. This might change, see:
1104         //  https://github.com/ethereum/go-ethereum/issues/2053
1105         if (v < 27)
1106           v += 27;
1107 
1108         if (v != 27 && v != 28)
1109             return (false, 0);
1110 
1111         return safer_ecrecover(hash, v, r, s);
1112     }
1113 
1114 }
1115 // </ORACLIZE_API>
1116 
1117 contract CoinFlip is Owned, usingOraclize {
1118     using SafeMath for uint;
1119 
1120     IERC20 public token;
1121     IExchange public exchange;
1122 
1123     enum FlipStatus {
1124         NotSet,
1125         Flipping,
1126         Won,
1127         Lost,
1128         Refunded
1129     }
1130 
1131     enum BetCurrency {
1132         NotSet,
1133         ETH,
1134         Token
1135     }
1136 
1137     bool public paused;
1138     uint8 public maxCoinSides = 2;
1139 
1140     uint public minAllowedBetInTokens = 10 ether; // 10 Token
1141     uint public maxAllowedBetInTokens = 1000 ether; // 1000 Token
1142 
1143     uint public minAllowedBetInEth = 0.01 ether;
1144     uint public maxAllowedBetInEth = 0.5 ether;
1145 
1146     uint public oracleCallbackGasLimit = 200000;
1147     uint public oracleCallbackGasPrice = 1e9;  // 1 gwei
1148 
1149     uint public tokensRequiredForAllWins; // Amount needed to pay if every bet is a win
1150 
1151     uint public ETHFee = 0.00044 ether;  
1152     uint public tokenFee = 2 ether; // 2 token
1153 
1154     bytes32[] public flipIds;
1155     mapping(bytes32 => Flip) public flips;
1156 
1157     struct Flip {
1158         address owner;
1159         BetCurrency currency;
1160         FlipStatus status;
1161         bool completed;
1162         uint8 numberOfCoinSides;
1163         uint8 playerChosenSide;
1164         uint result;
1165         uint betETH;
1166         uint etherTokenRate; // Rate at which ether was exchanged to tokens (if Ether was used to bet)
1167         uint betTokens;
1168         uint winTokens;
1169     }
1170 
1171     modifier notPaused() {
1172         require(!paused);
1173         _;
1174     }
1175 
1176     modifier senderIsToken() {
1177         require(msg.sender == address(token));
1178         _;
1179     }
1180 
1181     /// Constructor
1182     constructor() public {   
1183         paused = true;
1184         oraclize_setCustomGasPrice(oracleCallbackGasPrice);
1185     }
1186 
1187     function initialize(address _token, address _exchange) external onlyOwner {
1188         token = IERC20(_token) ;
1189         exchange = IExchange(_exchange);
1190         paused = false;
1191     }
1192 
1193     function () public payable {
1194         require(false);
1195     }
1196 
1197     function flipCoinWithEther(uint8 _numberOfCoinSides, uint8 _playerChosenSide) external payable notPaused {        
1198         require(msg.value >= minAllowedBetInEth && msg.value <= maxAllowedBetInEth);
1199 
1200         emit ETHStart(msg.sender, msg.value);
1201         uint ethValueAfterFees = msg.value.sub(ETHFee);
1202         uint rate = exchange.tokenToEthRate();
1203         uint expectedAmountOfTokens = SafeMath.div(ethValueAfterFees, rate).mul(1 ether);
1204 
1205         emit RateCalculated(rate);
1206 
1207         _checkGeneralRequirements(expectedAmountOfTokens, _numberOfCoinSides, _playerChosenSide);
1208 
1209         _initializeFlip(msg.sender, BetCurrency.ETH, expectedAmountOfTokens, ethValueAfterFees, _numberOfCoinSides, _playerChosenSide, rate);
1210     }
1211 
1212     /// @dev Called by token contract after Approval
1213     function receiveApproval(address _from, uint _amountOfTokens, address _token, bytes _data) external senderIsToken notPaused {
1214         uint8 numberOfCoinSides = uint8(_data[31]);
1215         uint8 playerChosenSide = uint8(_data[63]);
1216 
1217         require((_amountOfTokens >= minAllowedBetInTokens) && (_amountOfTokens <= maxAllowedBetInTokens), "Invalid tokens amount.");
1218 
1219         emit TokenStart(msg.sender, _from, _amountOfTokens);
1220 
1221         uint tokensAmountAfterFees = _amountOfTokens.sub(tokenFee);
1222 
1223         _checkGeneralRequirements(tokensAmountAfterFees, numberOfCoinSides, playerChosenSide);
1224 
1225         // Transfer tokens from sender to this contract
1226         require(token.transferFrom(_from, address(this), _amountOfTokens), "Tokens transfer failed.");
1227 
1228         emit TokenTransferExecuted(_from, address(this), _amountOfTokens);
1229 
1230         _initializeFlip(_from, BetCurrency.Token, tokensAmountAfterFees, 0, numberOfCoinSides, playerChosenSide, 0);
1231     }
1232 
1233     function _checkGeneralRequirements(uint _amountOfTokens, uint8 _numberOfCoinSides, uint8 _playerChosenSide) private {
1234         // Check if player selected coin side is valid
1235         require(_numberOfCoinSides >= 2 && _numberOfCoinSides <= maxCoinSides, "Invalid number of coin sides.");
1236         require(_playerChosenSide <= _numberOfCoinSides, "Invalid player chosen side");
1237 
1238         tokensRequiredForAllWins = tokensRequiredForAllWins.add(_amountOfTokens.mul(_numberOfCoinSides));
1239 
1240         // Check if contract has enough tokens to pay in case of win.
1241         // Each successful flip start adds bet value in tokens to 'tokensRequiredForAllWins'
1242         require(tokensRequiredForAllWins <= token.balanceOf(address(this)), "Not enough tokens in contract balance.");
1243     }
1244 
1245     // _numberOfCoinSides (2 - [O] obverse [1] reverse)
1246     function _initializeFlip(address _from, BetCurrency _currency, uint _amountOfTokens, uint _ethAmount, uint8 _numberOfCoinSides, uint8 _playerChosenSide, uint _rate) private {
1247         string memory query;
1248 
1249         if(_numberOfCoinSides == 2) {
1250             query = "random integer between 0 and 1"; 
1251         }
1252         else if(_numberOfCoinSides == 3) {
1253             query = "random integer between 0 and 2"; 
1254         }
1255         else {
1256             revert("Query not found for provided number of coin sides."); 
1257         }
1258         
1259         bytes32 flipId = oraclize_query("WolframAlpha", query, oracleCallbackGasLimit);  
1260 
1261         flipIds.push(flipId);
1262         flips[flipId].owner = _from;
1263         flips[flipId].betTokens = _amountOfTokens;
1264         flips[flipId].betETH = _ethAmount;
1265         flips[flipId].numberOfCoinSides = _numberOfCoinSides;
1266         flips[flipId].playerChosenSide = _playerChosenSide;
1267         flips[flipId].currency = _currency;
1268         flips[flipId].etherTokenRate = _rate;
1269         flips[flipId].status = FlipStatus.Flipping;
1270 
1271         emit FlipStarted(flipId, _from, _amountOfTokens);
1272     }
1273 
1274 
1275     /// @dev Called by oraclize to return generated random number.
1276     ///  Transaction will fail if gas limit provided earlier was too low
1277     /// @param myid FlipID which this callback was targeted to
1278     /// @param result Generated random number
1279     function __callback(bytes32 myid, string result) public {
1280         require(!flips[myid].completed, "Callback to already completed flip.");
1281         require(msg.sender == oraclize_cbAddress(), "Callback caller is not oraclize address.");
1282         flips[myid].completed = true;
1283         
1284         // Assigning received random number.
1285         // Picking only first byte because result is expected to be single ASCII char ('0' or '1' or '2')
1286         // Subtracting 48 because in ASCII table decimal 48 equals '0', 49 equals '1' etc.
1287         emit OracleResult(bytes(result)[0]);
1288         flips[myid].result = uint8(bytes(result)[0]) - 48;
1289         assert(flips[myid].result >= 0 && flips[myid].result <= flips[myid].numberOfCoinSides);
1290         
1291         if(flips[myid].result == flips[myid].playerChosenSide) {
1292             flips[myid].status = FlipStatus.Won;
1293             flips[myid].winTokens = SafeMath.mul(flips[myid].betTokens, flips[myid].numberOfCoinSides);
1294             require(token.transfer(flips[myid].owner, flips[myid].winTokens), "Tokens transfer failed.");
1295         }
1296         else {
1297             flips[myid].status = FlipStatus.Lost;
1298         }
1299         
1300         tokensRequiredForAllWins = tokensRequiredForAllWins.sub(flips[myid].betTokens.mul(flips[myid].numberOfCoinSides));
1301         emit FlipEnded(myid, flips[myid].owner, flips[myid].winTokens);
1302     }
1303 
1304     /// @dev Refund bet manually if oraclize callback was not received
1305     /// @param _flipId Targeted flip
1306     function refundFlip(bytes32 _flipId) external {
1307         require(msg.sender == flips[_flipId].owner || msg.sender == owner, "Refund caller is not owner of this flip.");
1308         require(!flips[_flipId].completed, "Trying to refund completed flip.");
1309         flips[_flipId].completed = true;
1310         
1311         if(flips[_flipId].currency == BetCurrency.ETH) {
1312             // Return ether if ether was used to bet for flip
1313             flips[_flipId].owner.transfer(flips[_flipId].betETH);
1314         }
1315         else {
1316             // Return tokens if tokens were used to bet for flip
1317             assert(token.transfer(flips[_flipId].owner, flips[_flipId].betTokens));
1318         }
1319         
1320         tokensRequiredForAllWins = tokensRequiredForAllWins.sub(flips[_flipId].betTokens.mul(flips[_flipId].numberOfCoinSides));
1321         flips[_flipId].status = FlipStatus.Refunded;
1322         emit FlipEnded(_flipId, flips[_flipId].owner, flips[_flipId].winTokens);
1323     }
1324 
1325     
1326     function setOracleCallbackGasPrice(uint _newPrice) external onlyOwner {
1327         require(_newPrice > 0, "Gas price must be more than zero.");
1328         oracleCallbackGasPrice = _newPrice;
1329         oraclize_setCustomGasPrice(oracleCallbackGasPrice);
1330     }
1331 
1332     function setOracleCallbackGasLimit(uint _newLimit) external onlyOwner {
1333         oracleCallbackGasLimit = _newLimit;
1334     }
1335 
1336     function setMinAllowedBetInTokens(uint _newMin) external onlyOwner {
1337         minAllowedBetInTokens = _newMin;
1338     }
1339 
1340     function SetMaxAllowedBetInTokens(uint _newMax) external onlyOwner {
1341         maxAllowedBetInTokens = _newMax;
1342     }
1343 
1344     function setMinAllowedBetInEth(uint _newMin) external onlyOwner {
1345         minAllowedBetInEth = _newMin;
1346     }
1347 
1348     function setMaxAllowedBetInEth(uint _newMax) external onlyOwner {
1349         maxAllowedBetInEth = _newMax;
1350     }
1351 
1352     function setMaxCoinSides(uint8 _newMax) external onlyOwner {
1353         maxCoinSides = _newMax;
1354     }
1355 
1356     function setETHFee(uint _value) external onlyOwner {
1357         ETHFee = _value;
1358     }
1359 
1360     function tokenFee(uint _value) external onlyOwner {
1361         tokenFee = _value;
1362     }
1363     
1364     //////////
1365     // Safety Methods
1366     //////////
1367     function depositETH() external payable onlyOwner {
1368     }
1369 
1370     function withdrawETH(uint _wei) external onlyOwner {
1371         owner.transfer(_wei);
1372     }
1373 
1374     function withdrawToken(uint _amount) public onlyOwner {
1375         token.transfer(owner, _amount);
1376     }
1377 
1378     function withdrawTokens(uint _amount, address _token) external onlyOwner {
1379         IERC20(_token).transfer(owner, _amount);
1380     }
1381 
1382     function pause(bool _paused) external onlyOwner {
1383         paused = _paused;
1384     }
1385 
1386 
1387     ///////////////////
1388     // STATS
1389     ///////////////////
1390 
1391     ///////////////////
1392     // FLIPS
1393     ///////////////////
1394     function getNumberOfFlips(address _account) private view returns(uint) {
1395         uint result = 0;
1396 
1397         if (_account == address(0)) {
1398             result = flipIds.length;
1399         } else {
1400             for (uint i = 0; i < flipIds.length; i++) {
1401                 if (flips[flipIds[i]].owner == _account) {
1402                     result++;
1403                 }
1404             }
1405         }
1406         
1407         return result;
1408     }
1409 
1410     function getTotalFlips() private view returns(uint) {
1411         return flipIds.length;
1412     }
1413 
1414     function getPlayerFlips(address _account, uint _number) external view returns(bytes32[]) {
1415         uint index;
1416         uint accountFlips = getNumberOfFlips(_account);
1417         uint number = _number;
1418 
1419         if (_number > accountFlips) {
1420             number = accountFlips;
1421         }
1422 
1423         bytes32[] memory playerFlips = new bytes32[](number);
1424 
1425         for (uint i = flipIds.length - 1; i >= 0; i--) {
1426             if (flips[flipIds[i]].owner == _account) {
1427                 playerFlips[index] = flipIds[i];
1428                 index++;
1429             }
1430 
1431             if (index == number || i == 0) {
1432                 break;
1433             }
1434         }
1435 
1436         return playerFlips;
1437     }
1438 
1439     function flipsCompleted() public view returns(uint) {
1440         uint result = 0;
1441         for (uint i = 0; i < flipIds.length; i++) {
1442             if (flips[flipIds[i]].status == FlipStatus.Won ||
1443                 flips[flipIds[i]].status == FlipStatus.Lost){
1444                     result++;
1445                 }
1446         }
1447         return result;
1448     }
1449  
1450 
1451     function flipsWon() public view returns(uint) {
1452         uint result = 0;
1453         for (uint i = 0; i < flipIds.length; i++) {
1454             if (flips[flipIds[i]].status == FlipStatus.Won) 
1455             {
1456                 result++;
1457             }
1458         }
1459         return result;
1460     }
1461 
1462     function flipsLost() public view returns(uint) {
1463         uint result = 0;
1464         for (uint i = 0; i < flipIds.length; i++) {
1465             if (flips[flipIds[i]].status == FlipStatus.Lost) 
1466             {
1467                 result++;
1468             }
1469         }
1470         return result;
1471     }
1472 
1473 
1474     function getTopWinners(uint _number) external view returns(bytes32[]) {
1475         uint number = _number > 5 ? _number : 5;
1476         uint[] memory topWins = new uint[](number);
1477         bytes32[] memory flipsList = new bytes32[](number);
1478 
1479         for (uint i = 0; i < flipIds.length; i++) {
1480             uint winValue = flips[flipIds[i]].winTokens;
1481 
1482             for (uint j = 0; j < number; j++) {
1483                 if (winValue > topWins[j]) {
1484                     for (uint k = number - 1; k > j; k--) {
1485                         topWins[k] = topWins[k - 1];
1486                         flipsList[k] = flipsList[k - 1];
1487                     }
1488                     topWins[j] = winValue;
1489                     flipsList[j] = flipIds[i];
1490                     break;
1491                 }
1492             }
1493         }
1494 
1495         return flipsList;
1496     }
1497 
1498     ///////////////////
1499     // BETS IN ETHER
1500     ///////////////////
1501     function avgEtherBetValue() public view returns(uint) {
1502         return totalEtherBetValue().div(flipsCompleted());
1503     }
1504 
1505     function totalEtherBetValue() public view returns(uint) {
1506         uint total = 0;
1507 
1508         for (uint i = 0; i < flipIds.length; i++) {
1509             if (flips[flipIds[i]].currency == BetCurrency.ETH) {
1510                 total = total.add(flips[flipIds[i]].betETH);
1511             }
1512         }
1513 
1514         return total;
1515     }
1516 
1517     ///////////////////
1518     // BETS IN TOKENS
1519     ///////////////////
1520     function maxTokenBetValue() external view returns(uint) {
1521         uint result = 0;
1522 
1523         for (uint i = 0; i < flipIds.length; i++) {
1524             if (flips[flipIds[i]].currency == BetCurrency.Token && 
1525                 flips[flipIds[i]].betTokens > result) {
1526                     result = flips[flipIds[i]].betTokens;
1527                 } 
1528         }
1529 
1530         return result;
1531     }
1532 
1533     function maxTokenWinValue() external view returns(uint) {
1534         uint result = 0;
1535 
1536         for (uint i = 0; i < flipIds.length; i++) {
1537             if (flips[flipIds[i]].currency == BetCurrency.Token &&
1538                 flips[flipIds[i]].status == FlipStatus.Won &&
1539                 flips[flipIds[i]].winTokens > result) {
1540                     result = flips[flipIds[i]].winTokens;
1541                 }
1542         }
1543 
1544         return result;
1545     }
1546 
1547     function maxTokenlossValue() external view returns(uint) {
1548         uint result = 0;
1549 
1550         for (uint i = 0; i < flipIds.length; i++) {
1551             if (flips[flipIds[i]].currency == BetCurrency.Token &&
1552                 flips[flipIds[i]].status == FlipStatus.Lost &&
1553                 flips[flipIds[i]].betTokens > result) {
1554                 result = flips[flipIds[i]].betTokens;
1555             }
1556         }
1557 
1558         return result;
1559     }
1560 
1561     function avgTokenBetValue() public view returns(uint) {
1562         return totalTokenBetValue().div(flipsCompleted());
1563     }
1564 
1565     function avgTokenWinValue() public view returns(uint) {
1566         return totalTokenWinValue().div(flipsWon());
1567     }
1568 
1569     function avgTokenlossValue() public view returns(uint) {
1570         return totalTokenLossValue().div(flipsLost());
1571     }
1572 
1573     function totalTokenBetValue() public view returns(uint) {
1574         uint result = 0;
1575         for (uint i = 0; i < flipIds.length; i++) {
1576             if (flips[flipIds[i]].currency == BetCurrency.Token) {
1577                 result = result.add(flips[flipIds[i]].betTokens);
1578             }
1579         }
1580         return result;
1581     }
1582 
1583     function totalTokenWinValue() public view returns(uint) {
1584         uint result = 0;
1585         for (uint i = 0; i < flipIds.length; i++) {
1586             if (flips[flipIds[i]].currency == BetCurrency.Token && 
1587                 flips[flipIds[i]].status == FlipStatus.Won) {
1588                 result = result.add(flips[flipIds[i]].winTokens);
1589             }            
1590         }
1591         return result;
1592     }
1593 
1594     function totalTokenLossValue() public view returns(uint) {
1595         uint result = 0;
1596         for (uint i = 0; i < flipIds.length; i++) {
1597             if (flips[flipIds[i]].currency == BetCurrency.Token && 
1598                 flips[flipIds[i]].status == FlipStatus.Lost){
1599                 result = result.add(flips[flipIds[i]].betTokens);
1600             }
1601         }
1602         return result;
1603     }
1604 
1605     ///////////////////
1606     // BETS IN Tokens and ETH
1607     ///////////////////
1608 
1609     function totalWinValue() public view returns(uint) {
1610         uint result = 0;
1611         for (uint i = 0; i < flipIds.length; i++) {
1612             if (flips[flipIds[i]].status == FlipStatus.Won) {
1613                 result = result.add(flips[flipIds[i]].winTokens);
1614             }            
1615         }
1616         return result;
1617     }
1618 
1619     function totalLossValue() public view returns(uint) {
1620         uint result = 0;
1621         for (uint i = 0; i < flipIds.length; i++) {
1622             if (flips[flipIds[i]].status == FlipStatus.Lost){
1623                 result = result.add(flips[flipIds[i]].betTokens);
1624             }
1625         }
1626         return result;
1627     }
1628 
1629     function totalNotCompleted() public view returns(uint) {
1630         uint result = 0;
1631         for (uint i = 0; i < flipIds.length; i++) {
1632             if (flips[flipIds[i]].completed == false){
1633                 result = result.add(1);
1634             }
1635         }
1636         return result;
1637     }
1638 
1639     function totalRefunded() public view returns(uint) {
1640         uint result = 0;
1641         for (uint i = 0; i < flipIds.length; i++) {
1642             if (flips[flipIds[i]].status == FlipStatus.Refunded){
1643                 result = result.add(1);
1644             }
1645         }
1646         return result;
1647     }
1648 
1649 
1650     event TokenStart(address indexed sender, address indexed owner, uint value);
1651     event TokenTransferExecuted(address indexed from, address indexed receiver, uint value);
1652     event ETHStart(address indexed sender, uint value);
1653     event RateCalculated(uint value);
1654     event OracleResult(bytes1 value);
1655     event FlipStarted(bytes32 indexed flipID, address indexed flipOwner, uint amountOfTokens);
1656     event FlipEnded(bytes32 indexed flipID, address indexed flipOwner, uint winTokens);
1657 }