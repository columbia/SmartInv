1 pragma solidity ^0.4.18;
2 
3 /**************************************************************
4 *
5 * Alteum ICO
6 * Author: Lex Garza 
7 * by ALTEUM / Copanga
8 *
9 **************************************************************/
10 
11 contract ERC223 {
12   uint public totalSupply;
13   function balanceOf(address who) public view returns (uint);
14   
15   function name() public view returns (string _name);
16   function symbol() public view returns (string _symbol);
17   function decimals() public view returns (uint8 _decimals);
18   function totalSupply() public view returns (uint256 _supply);
19 
20   function transfer(address to, uint value) public returns (bool ok);
21   function transfer(address to, uint value, bytes data) public returns (bool ok);
22   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
23   function transferFrom(address from, address to, uint value) public returns(bool);
24   
25   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
26 }
27 
28 /*
29 * Safe Math Library from Zeppelin Solidity
30 * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
31 */
32 contract SafeMath
33 {
34     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         assert(c >= a);
37         return c;
38       }
39     
40 	function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
41 		assert(b <= a);
42 		return a - b;
43 	}
44 	
45 	function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
46 		uint256 c = a / b;
47 		return c;
48 	}
49 	
50 	function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
51 		if (a == 0) {
52 			return 0;
53 		}
54 		uint256 c = a * b;
55 		assert(c / a == b);
56 		return c;
57 	}
58 }
59 
60 // <ORACLIZE_API>
61 /*
62 Copyright (c) 2015-2016 Oraclize SRL
63 Copyright (c) 2016 Oraclize LTD
64 
65 
66 
67 Permission is hereby granted, free of charge, to any person obtaining a copy
68 of this software and associated documentation files (the "Software"), to deal
69 in the Software without restriction, including without limitation the rights
70 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
71 copies of the Software, and to permit persons to whom the Software is
72 furnished to do so, subject to the following conditions:
73 
74 
75 
76 The above copyright notice and this permission notice shall be included in
77 all copies or substantial portions of the Software.
78 
79 
80 
81 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
82 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
83 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
84 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
85 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
86 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
87 THE SOFTWARE.
88 */
89 contract OraclizeI {
90     address public cbAddress;
91     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
92     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
93     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
94     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
95     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
96     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
97     function getPrice(string _datasource) public returns (uint _dsprice);
98     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
99     function setProofType(byte _proofType) external;
100     function setCustomGasPrice(uint _gasPrice) external;
101     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
102 }
103 contract OraclizeAddrResolverI {
104     function getAddress() public returns (address _addr);
105 }
106 contract usingOraclize {
107     uint constant day = 60*60*24;
108     uint constant week = 60*60*24*7;
109     uint constant month = 60*60*24*30;
110     byte constant proofType_NONE = 0x00;
111     byte constant proofType_TLSNotary = 0x10;
112     byte constant proofType_Android = 0x20;
113     byte constant proofType_Ledger = 0x30;
114     byte constant proofType_Native = 0xF0;
115     byte constant proofStorage_IPFS = 0x01;
116     uint8 constant networkID_auto = 0;
117     uint8 constant networkID_mainnet = 1;
118     uint8 constant networkID_testnet = 2;
119     uint8 constant networkID_morden = 2;
120     uint8 constant networkID_consensys = 161;
121 
122     OraclizeAddrResolverI OAR;
123 
124     OraclizeI oraclize;
125     modifier oraclizeAPI {
126         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
127             oraclize_setNetwork(networkID_auto);
128 
129         if(address(oraclize) != OAR.getAddress())
130             oraclize = OraclizeI(OAR.getAddress());
131 
132         _;
133     }
134     modifier coupon(string code){
135         oraclize = OraclizeI(OAR.getAddress());
136         _;
137     }
138 
139     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
140       return oraclize_setNetwork();
141       networkID; // silence the warning and remain backwards compatible
142     }
143     function oraclize_setNetwork() internal returns(bool){
144         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
145             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
146             oraclize_setNetworkName("eth_mainnet");
147             return true;
148         }
149         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
150             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
151             oraclize_setNetworkName("eth_ropsten3");
152             return true;
153         }
154         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
155             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
156             oraclize_setNetworkName("eth_kovan");
157             return true;
158         }
159         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
160             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
161             oraclize_setNetworkName("eth_rinkeby");
162             return true;
163         }
164         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
165             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
166             return true;
167         }
168         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
169             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
170             return true;
171         }
172         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
173             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
174             return true;
175         }
176         return false;
177     }
178 
179     function __callback(bytes32 myid, string result) public {
180         __callback(myid, result, new bytes(0));
181     }
182     function __callback(bytes32 myid, string result, bytes proof) public {
183       return;
184       myid; result; proof; // Silence compiler warnings
185     }
186 
187     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
188         return oraclize.getPrice(datasource);
189     }
190 
191     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
192         return oraclize.getPrice(datasource, gaslimit);
193     }
194 
195     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
196         uint price = oraclize.getPrice(datasource);
197         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
198         return oraclize.query.value(price)(0, datasource, arg);
199     }
200     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
201         uint price = oraclize.getPrice(datasource);
202         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
203         return oraclize.query.value(price)(timestamp, datasource, arg);
204     }
205     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
206         uint price = oraclize.getPrice(datasource, gaslimit);
207         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
208         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
209     }
210     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
211         uint price = oraclize.getPrice(datasource, gaslimit);
212         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
213         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
214     }
215     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
216         uint price = oraclize.getPrice(datasource);
217         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
218         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
219     }
220     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
221         uint price = oraclize.getPrice(datasource);
222         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
223         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
224     }
225     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
226         uint price = oraclize.getPrice(datasource, gaslimit);
227         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
228         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
229     }
230     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
231         uint price = oraclize.getPrice(datasource, gaslimit);
232         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
233         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
234     }
235     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
236         uint price = oraclize.getPrice(datasource);
237         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
238         bytes memory args = stra2cbor(argN);
239         return oraclize.queryN.value(price)(0, datasource, args);
240     }
241     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
242         uint price = oraclize.getPrice(datasource);
243         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
244         bytes memory args = stra2cbor(argN);
245         return oraclize.queryN.value(price)(timestamp, datasource, args);
246     }
247     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
248         uint price = oraclize.getPrice(datasource, gaslimit);
249         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
250         bytes memory args = stra2cbor(argN);
251         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
252     }
253     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
254         uint price = oraclize.getPrice(datasource, gaslimit);
255         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
256         bytes memory args = stra2cbor(argN);
257         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
258     }
259     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
260         string[] memory dynargs = new string[](1);
261         dynargs[0] = args[0];
262         return oraclize_query(datasource, dynargs);
263     }
264     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
265         string[] memory dynargs = new string[](1);
266         dynargs[0] = args[0];
267         return oraclize_query(timestamp, datasource, dynargs);
268     }
269     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
270         string[] memory dynargs = new string[](1);
271         dynargs[0] = args[0];
272         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
273     }
274     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
275         string[] memory dynargs = new string[](1);
276         dynargs[0] = args[0];
277         return oraclize_query(datasource, dynargs, gaslimit);
278     }
279 
280     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
281         string[] memory dynargs = new string[](2);
282         dynargs[0] = args[0];
283         dynargs[1] = args[1];
284         return oraclize_query(datasource, dynargs);
285     }
286     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
287         string[] memory dynargs = new string[](2);
288         dynargs[0] = args[0];
289         dynargs[1] = args[1];
290         return oraclize_query(timestamp, datasource, dynargs);
291     }
292     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
293         string[] memory dynargs = new string[](2);
294         dynargs[0] = args[0];
295         dynargs[1] = args[1];
296         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
297     }
298     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
299         string[] memory dynargs = new string[](2);
300         dynargs[0] = args[0];
301         dynargs[1] = args[1];
302         return oraclize_query(datasource, dynargs, gaslimit);
303     }
304     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
305         string[] memory dynargs = new string[](3);
306         dynargs[0] = args[0];
307         dynargs[1] = args[1];
308         dynargs[2] = args[2];
309         return oraclize_query(datasource, dynargs);
310     }
311     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
312         string[] memory dynargs = new string[](3);
313         dynargs[0] = args[0];
314         dynargs[1] = args[1];
315         dynargs[2] = args[2];
316         return oraclize_query(timestamp, datasource, dynargs);
317     }
318     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
319         string[] memory dynargs = new string[](3);
320         dynargs[0] = args[0];
321         dynargs[1] = args[1];
322         dynargs[2] = args[2];
323         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
324     }
325     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
326         string[] memory dynargs = new string[](3);
327         dynargs[0] = args[0];
328         dynargs[1] = args[1];
329         dynargs[2] = args[2];
330         return oraclize_query(datasource, dynargs, gaslimit);
331     }
332 
333     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
334         string[] memory dynargs = new string[](4);
335         dynargs[0] = args[0];
336         dynargs[1] = args[1];
337         dynargs[2] = args[2];
338         dynargs[3] = args[3];
339         return oraclize_query(datasource, dynargs);
340     }
341     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
342         string[] memory dynargs = new string[](4);
343         dynargs[0] = args[0];
344         dynargs[1] = args[1];
345         dynargs[2] = args[2];
346         dynargs[3] = args[3];
347         return oraclize_query(timestamp, datasource, dynargs);
348     }
349     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
350         string[] memory dynargs = new string[](4);
351         dynargs[0] = args[0];
352         dynargs[1] = args[1];
353         dynargs[2] = args[2];
354         dynargs[3] = args[3];
355         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
356     }
357     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
358         string[] memory dynargs = new string[](4);
359         dynargs[0] = args[0];
360         dynargs[1] = args[1];
361         dynargs[2] = args[2];
362         dynargs[3] = args[3];
363         return oraclize_query(datasource, dynargs, gaslimit);
364     }
365     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
366         string[] memory dynargs = new string[](5);
367         dynargs[0] = args[0];
368         dynargs[1] = args[1];
369         dynargs[2] = args[2];
370         dynargs[3] = args[3];
371         dynargs[4] = args[4];
372         return oraclize_query(datasource, dynargs);
373     }
374     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
375         string[] memory dynargs = new string[](5);
376         dynargs[0] = args[0];
377         dynargs[1] = args[1];
378         dynargs[2] = args[2];
379         dynargs[3] = args[3];
380         dynargs[4] = args[4];
381         return oraclize_query(timestamp, datasource, dynargs);
382     }
383     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
384         string[] memory dynargs = new string[](5);
385         dynargs[0] = args[0];
386         dynargs[1] = args[1];
387         dynargs[2] = args[2];
388         dynargs[3] = args[3];
389         dynargs[4] = args[4];
390         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
391     }
392     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
393         string[] memory dynargs = new string[](5);
394         dynargs[0] = args[0];
395         dynargs[1] = args[1];
396         dynargs[2] = args[2];
397         dynargs[3] = args[3];
398         dynargs[4] = args[4];
399         return oraclize_query(datasource, dynargs, gaslimit);
400     }
401     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource);
403         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
404         bytes memory args = ba2cbor(argN);
405         return oraclize.queryN.value(price)(0, datasource, args);
406     }
407     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
408         uint price = oraclize.getPrice(datasource);
409         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
410         bytes memory args = ba2cbor(argN);
411         return oraclize.queryN.value(price)(timestamp, datasource, args);
412     }
413     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
414         uint price = oraclize.getPrice(datasource, gaslimit);
415         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
416         bytes memory args = ba2cbor(argN);
417         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
418     }
419     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
420         uint price = oraclize.getPrice(datasource, gaslimit);
421         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
422         bytes memory args = ba2cbor(argN);
423         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
424     }
425     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
426         bytes[] memory dynargs = new bytes[](1);
427         dynargs[0] = args[0];
428         return oraclize_query(datasource, dynargs);
429     }
430     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
431         bytes[] memory dynargs = new bytes[](1);
432         dynargs[0] = args[0];
433         return oraclize_query(timestamp, datasource, dynargs);
434     }
435     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
436         bytes[] memory dynargs = new bytes[](1);
437         dynargs[0] = args[0];
438         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
439     }
440     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441         bytes[] memory dynargs = new bytes[](1);
442         dynargs[0] = args[0];
443         return oraclize_query(datasource, dynargs, gaslimit);
444     }
445 
446     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
447         bytes[] memory dynargs = new bytes[](2);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         return oraclize_query(datasource, dynargs);
451     }
452     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
453         bytes[] memory dynargs = new bytes[](2);
454         dynargs[0] = args[0];
455         dynargs[1] = args[1];
456         return oraclize_query(timestamp, datasource, dynargs);
457     }
458     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
459         bytes[] memory dynargs = new bytes[](2);
460         dynargs[0] = args[0];
461         dynargs[1] = args[1];
462         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
463     }
464     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
465         bytes[] memory dynargs = new bytes[](2);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         return oraclize_query(datasource, dynargs, gaslimit);
469     }
470     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
471         bytes[] memory dynargs = new bytes[](3);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         dynargs[2] = args[2];
475         return oraclize_query(datasource, dynargs);
476     }
477     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
478         bytes[] memory dynargs = new bytes[](3);
479         dynargs[0] = args[0];
480         dynargs[1] = args[1];
481         dynargs[2] = args[2];
482         return oraclize_query(timestamp, datasource, dynargs);
483     }
484     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
485         bytes[] memory dynargs = new bytes[](3);
486         dynargs[0] = args[0];
487         dynargs[1] = args[1];
488         dynargs[2] = args[2];
489         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
490     }
491     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
492         bytes[] memory dynargs = new bytes[](3);
493         dynargs[0] = args[0];
494         dynargs[1] = args[1];
495         dynargs[2] = args[2];
496         return oraclize_query(datasource, dynargs, gaslimit);
497     }
498 
499     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
500         bytes[] memory dynargs = new bytes[](4);
501         dynargs[0] = args[0];
502         dynargs[1] = args[1];
503         dynargs[2] = args[2];
504         dynargs[3] = args[3];
505         return oraclize_query(datasource, dynargs);
506     }
507     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
508         bytes[] memory dynargs = new bytes[](4);
509         dynargs[0] = args[0];
510         dynargs[1] = args[1];
511         dynargs[2] = args[2];
512         dynargs[3] = args[3];
513         return oraclize_query(timestamp, datasource, dynargs);
514     }
515     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
516         bytes[] memory dynargs = new bytes[](4);
517         dynargs[0] = args[0];
518         dynargs[1] = args[1];
519         dynargs[2] = args[2];
520         dynargs[3] = args[3];
521         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
522     }
523     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
524         bytes[] memory dynargs = new bytes[](4);
525         dynargs[0] = args[0];
526         dynargs[1] = args[1];
527         dynargs[2] = args[2];
528         dynargs[3] = args[3];
529         return oraclize_query(datasource, dynargs, gaslimit);
530     }
531     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
532         bytes[] memory dynargs = new bytes[](5);
533         dynargs[0] = args[0];
534         dynargs[1] = args[1];
535         dynargs[2] = args[2];
536         dynargs[3] = args[3];
537         dynargs[4] = args[4];
538         return oraclize_query(datasource, dynargs);
539     }
540     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
541         bytes[] memory dynargs = new bytes[](5);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         dynargs[4] = args[4];
547         return oraclize_query(timestamp, datasource, dynargs);
548     }
549     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
550         bytes[] memory dynargs = new bytes[](5);
551         dynargs[0] = args[0];
552         dynargs[1] = args[1];
553         dynargs[2] = args[2];
554         dynargs[3] = args[3];
555         dynargs[4] = args[4];
556         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
557     }
558     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
559         bytes[] memory dynargs = new bytes[](5);
560         dynargs[0] = args[0];
561         dynargs[1] = args[1];
562         dynargs[2] = args[2];
563         dynargs[3] = args[3];
564         dynargs[4] = args[4];
565         return oraclize_query(datasource, dynargs, gaslimit);
566     }
567 
568     function oraclize_cbAddress() oraclizeAPI internal returns (address){
569         return oraclize.cbAddress();
570     }
571     function oraclize_setProof(byte proofP) oraclizeAPI internal {
572         return oraclize.setProofType(proofP);
573     }
574     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
575         return oraclize.setCustomGasPrice(gasPrice);
576     }
577 
578     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
579         return oraclize.randomDS_getSessionPubKeyHash();
580     }
581 
582     function getCodeSize(address _addr) constant internal returns(uint _size) {
583         assembly {
584             _size := extcodesize(_addr)
585         }
586     }
587 
588     function parseAddr(string _a) internal pure returns (address){
589         bytes memory tmp = bytes(_a);
590         uint160 iaddr = 0;
591         uint160 b1;
592         uint160 b2;
593         for (uint i=2; i<2+2*20; i+=2){
594             iaddr *= 256;
595             b1 = uint160(tmp[i]);
596             b2 = uint160(tmp[i+1]);
597             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
598             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
599             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
600             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
601             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
602             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
603             iaddr += (b1*16+b2);
604         }
605         return address(iaddr);
606     }
607 
608     function strCompare(string _a, string _b) internal pure returns (int) {
609         bytes memory a = bytes(_a);
610         bytes memory b = bytes(_b);
611         uint minLength = a.length;
612         if (b.length < minLength) minLength = b.length;
613         for (uint i = 0; i < minLength; i ++)
614             if (a[i] < b[i])
615                 return -1;
616             else if (a[i] > b[i])
617                 return 1;
618         if (a.length < b.length)
619             return -1;
620         else if (a.length > b.length)
621             return 1;
622         else
623             return 0;
624     }
625 
626     function indexOf(string _haystack, string _needle) internal pure returns (int) {
627         bytes memory h = bytes(_haystack);
628         bytes memory n = bytes(_needle);
629         if(h.length < 1 || n.length < 1 || (n.length > h.length))
630             return -1;
631         else if(h.length > (2**128 -1))
632             return -1;
633         else
634         {
635             uint subindex = 0;
636             for (uint i = 0; i < h.length; i ++)
637             {
638                 if (h[i] == n[0])
639                 {
640                     subindex = 1;
641                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
642                     {
643                         subindex++;
644                     }
645                     if(subindex == n.length)
646                         return int(i);
647                 }
648             }
649             return -1;
650         }
651     }
652 
653     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
654         bytes memory _ba = bytes(_a);
655         bytes memory _bb = bytes(_b);
656         bytes memory _bc = bytes(_c);
657         bytes memory _bd = bytes(_d);
658         bytes memory _be = bytes(_e);
659         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
660         bytes memory babcde = bytes(abcde);
661         uint k = 0;
662         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
663         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
664         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
665         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
666         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
667         return string(babcde);
668     }
669 
670     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
671         return strConcat(_a, _b, _c, _d, "");
672     }
673 
674     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
675         return strConcat(_a, _b, _c, "", "");
676     }
677 
678     function strConcat(string _a, string _b) internal pure returns (string) {
679         return strConcat(_a, _b, "", "", "");
680     }
681 
682     // parseInt
683     function parseInt(string _a) internal pure returns (uint) {
684         return parseInt(_a, 0);
685     }
686 
687     // parseInt(parseFloat*10^_b)
688     function parseInt(string _a, uint _b) internal pure returns (uint) {
689         bytes memory bresult = bytes(_a);
690         uint mint = 0;
691         bool decimals = false;
692         for (uint i=0; i<bresult.length; i++){
693             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
694                 if (decimals){
695                    if (_b == 0) break;
696                     else _b--;
697                 }
698                 mint *= 10;
699                 mint += uint(bresult[i]) - 48;
700             } else if (bresult[i] == 46) decimals = true;
701         }
702         if (_b > 0) mint *= 10**_b;
703         return mint;
704     }
705 
706     function uint2str(uint i) internal pure returns (string){
707         if (i == 0) return "0";
708         uint j = i;
709         uint len;
710         while (j != 0){
711             len++;
712             j /= 10;
713         }
714         bytes memory bstr = new bytes(len);
715         uint k = len - 1;
716         while (i != 0){
717             bstr[k--] = byte(48 + i % 10);
718             i /= 10;
719         }
720         return string(bstr);
721     }
722 
723     function stra2cbor(string[] arr) internal pure returns (bytes) {
724             uint arrlen = arr.length;
725 
726             // get correct cbor output length
727             uint outputlen = 0;
728             bytes[] memory elemArray = new bytes[](arrlen);
729             for (uint i = 0; i < arrlen; i++) {
730                 elemArray[i] = (bytes(arr[i]));
731                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
732             }
733             uint ctr = 0;
734             uint cborlen = arrlen + 0x80;
735             outputlen += byte(cborlen).length;
736             bytes memory res = new bytes(outputlen);
737 
738             while (byte(cborlen).length > ctr) {
739                 res[ctr] = byte(cborlen)[ctr];
740                 ctr++;
741             }
742             for (i = 0; i < arrlen; i++) {
743                 res[ctr] = 0x5F;
744                 ctr++;
745                 for (uint x = 0; x < elemArray[i].length; x++) {
746                     // if there's a bug with larger strings, this may be the culprit
747                     if (x % 23 == 0) {
748                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
749                         elemcborlen += 0x40;
750                         uint lctr = ctr;
751                         while (byte(elemcborlen).length > ctr - lctr) {
752                             res[ctr] = byte(elemcborlen)[ctr - lctr];
753                             ctr++;
754                         }
755                     }
756                     res[ctr] = elemArray[i][x];
757                     ctr++;
758                 }
759                 res[ctr] = 0xFF;
760                 ctr++;
761             }
762             return res;
763         }
764 
765     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
766             uint arrlen = arr.length;
767 
768             // get correct cbor output length
769             uint outputlen = 0;
770             bytes[] memory elemArray = new bytes[](arrlen);
771             for (uint i = 0; i < arrlen; i++) {
772                 elemArray[i] = (bytes(arr[i]));
773                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
774             }
775             uint ctr = 0;
776             uint cborlen = arrlen + 0x80;
777             outputlen += byte(cborlen).length;
778             bytes memory res = new bytes(outputlen);
779 
780             while (byte(cborlen).length > ctr) {
781                 res[ctr] = byte(cborlen)[ctr];
782                 ctr++;
783             }
784             for (i = 0; i < arrlen; i++) {
785                 res[ctr] = 0x5F;
786                 ctr++;
787                 for (uint x = 0; x < elemArray[i].length; x++) {
788                     // if there's a bug with larger strings, this may be the culprit
789                     if (x % 23 == 0) {
790                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
791                         elemcborlen += 0x40;
792                         uint lctr = ctr;
793                         while (byte(elemcborlen).length > ctr - lctr) {
794                             res[ctr] = byte(elemcborlen)[ctr - lctr];
795                             ctr++;
796                         }
797                     }
798                     res[ctr] = elemArray[i][x];
799                     ctr++;
800                 }
801                 res[ctr] = 0xFF;
802                 ctr++;
803             }
804             return res;
805         }
806 
807 
808     string oraclize_network_name;
809     function oraclize_setNetworkName(string _network_name) internal {
810         oraclize_network_name = _network_name;
811     }
812 
813     function oraclize_getNetworkName() internal view returns (string) {
814         return oraclize_network_name;
815     }
816 
817     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
818         require((_nbytes > 0) && (_nbytes <= 32));
819         bytes memory nbytes = new bytes(1);
820         nbytes[0] = byte(_nbytes);
821         bytes memory unonce = new bytes(32);
822         bytes memory sessionKeyHash = new bytes(32);
823         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
824         assembly {
825             mstore(unonce, 0x20)
826             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
827             mstore(sessionKeyHash, 0x20)
828             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
829         }
830         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
831         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
832         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
833         return queryId;
834     }
835 
836     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
837         oraclize_randomDS_args[queryId] = commitment;
838     }
839 
840     mapping(bytes32=>bytes32) oraclize_randomDS_args;
841     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
842 
843     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
844         bool sigok;
845         address signer;
846 
847         bytes32 sigr;
848         bytes32 sigs;
849 
850         bytes memory sigr_ = new bytes(32);
851         uint offset = 4+(uint(dersig[3]) - 0x20);
852         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
853         bytes memory sigs_ = new bytes(32);
854         offset += 32 + 2;
855         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
856 
857         assembly {
858             sigr := mload(add(sigr_, 32))
859             sigs := mload(add(sigs_, 32))
860         }
861 
862 
863         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
864         if (address(keccak256(pubkey)) == signer) return true;
865         else {
866             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
867             return (address(keccak256(pubkey)) == signer);
868         }
869     }
870 
871     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
872         bool sigok;
873 
874         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
875         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
876         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
877 
878         bytes memory appkey1_pubkey = new bytes(64);
879         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
880 
881         bytes memory tosign2 = new bytes(1+65+32);
882         tosign2[0] = byte(1); //role
883         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
884         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
885         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
886         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
887 
888         if (sigok == false) return false;
889 
890 
891         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
892         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
893 
894         bytes memory tosign3 = new bytes(1+65);
895         tosign3[0] = 0xFE;
896         copyBytes(proof, 3, 65, tosign3, 1);
897 
898         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
899         copyBytes(proof, 3+65, sig3.length, sig3, 0);
900 
901         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
902 
903         return sigok;
904     }
905 
906     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
907         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
908         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
909 
910         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
911         require(proofVerified);
912 
913         _;
914     }
915 
916     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
917         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
918         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
919 
920         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
921         if (proofVerified == false) return 2;
922 
923         return 0;
924     }
925 
926     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
927         bool match_ = true;
928         
929 
930         for (uint256 i=0; i< n_random_bytes; i++) {
931             if (content[i] != prefix[i]) match_ = false;
932         }
933 
934         return match_;
935     }
936 
937     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
938 
939         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
940         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
941         bytes memory keyhash = new bytes(32);
942         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
943         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
944 
945         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
946         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
947 
948         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
949         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
950 
951         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
952         // This is to verify that the computed args match with the ones specified in the query.
953         bytes memory commitmentSlice1 = new bytes(8+1+32);
954         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
955 
956         bytes memory sessionPubkey = new bytes(64);
957         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
958         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
959 
960         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
961         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
962             delete oraclize_randomDS_args[queryId];
963         } else return false;
964 
965 
966         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
967         bytes memory tosign1 = new bytes(32+8+1+32);
968         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
969         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
970 
971         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
972         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
973             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
974         }
975 
976         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
977     }
978 
979     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
980     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
981         uint minLength = length + toOffset;
982 
983         // Buffer too small
984         require(to.length >= minLength); // Should be a better way?
985 
986         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
987         uint i = 32 + fromOffset;
988         uint j = 32 + toOffset;
989 
990         while (i < (32 + fromOffset + length)) {
991             assembly {
992                 let tmp := mload(add(from, i))
993                 mstore(add(to, j), tmp)
994             }
995             i += 32;
996             j += 32;
997         }
998 
999         return to;
1000     }
1001 
1002     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1003     // Duplicate Solidity's ecrecover, but catching the CALL return value
1004     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1005         // We do our own memory management here. Solidity uses memory offset
1006         // 0x40 to store the current end of memory. We write past it (as
1007         // writes are memory extensions), but don't update the offset so
1008         // Solidity will reuse it. The memory used here is only needed for
1009         // this context.
1010 
1011         // FIXME: inline assembly can't access return values
1012         bool ret;
1013         address addr;
1014 
1015         assembly {
1016             let size := mload(0x40)
1017             mstore(size, hash)
1018             mstore(add(size, 32), v)
1019             mstore(add(size, 64), r)
1020             mstore(add(size, 96), s)
1021 
1022             // NOTE: we can reuse the request memory because we deal with
1023             //       the return code
1024             ret := call(3000, 1, 0, size, 128, size, 32)
1025             addr := mload(size)
1026         }
1027 
1028         return (ret, addr);
1029     }
1030 
1031     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1032     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1033         bytes32 r;
1034         bytes32 s;
1035         uint8 v;
1036 
1037         if (sig.length != 65)
1038           return (false, 0);
1039 
1040         // The signature format is a compact form of:
1041         //   {bytes32 r}{bytes32 s}{uint8 v}
1042         // Compact means, uint8 is not padded to 32 bytes.
1043         assembly {
1044             r := mload(add(sig, 32))
1045             s := mload(add(sig, 64))
1046 
1047             // Here we are loading the last 32 bytes. We exploit the fact that
1048             // 'mload' will pad with zeroes if we overread.
1049             // There is no 'mload8' to do this, but that would be nicer.
1050             v := byte(0, mload(add(sig, 96)))
1051 
1052             // Alternative solution:
1053             // 'byte' is not working due to the Solidity parser, so lets
1054             // use the second best option, 'and'
1055             // v := and(mload(add(sig, 65)), 255)
1056         }
1057 
1058         // albeit non-transactional signatures are not specified by the YP, one would expect it
1059         // to match the YP range of [27, 28]
1060         //
1061         // geth uses [0, 1] and some clients have followed. This might change, see:
1062         //  https://github.com/ethereum/go-ethereum/issues/2053
1063         if (v < 27)
1064           v += 27;
1065 
1066         if (v != 27 && v != 28)
1067             return (false, 0);
1068 
1069         return safer_ecrecover(hash, v, r, s);
1070     }
1071 
1072 }
1073 // </ORACLIZE_API>
1074 
1075 contract AumICO is usingOraclize, SafeMath {
1076 	//uint public tokenPricePreSale = 35; //Price x100 (with no cents: $0.35 => 35)
1077 	//uint public tokenPricePreICO = 55; //Price x100 (with no cents: $0.55 => 55)
1078 	//uint public tokenPriceICO = 75; //Price x100 (with no cents: $0.75 => 75)
1079 	//uint totalAvailableTokens = 31875000; // 37,500,000 AUM's available for sale, minus 5,625,000 sold in presale 
1080 	
1081 	struct OperationInQueue
1082 	{
1083 		uint operationStartTime;
1084 		uint depositedEther;
1085 		address receiver;
1086 		bool closed;
1087 	}
1088 	
1089 	struct Contact
1090 	{
1091 		uint obtainedTokens;
1092 		uint depositedEther;
1093 		bool isOnWhitelist;
1094 		bool userExists;
1095 		bool userLiquidated;
1096 		uint depositedLEX;
1097 	}
1098 	
1099 	uint[3] public tokenPrice;
1100 	uint[3] public availableTokens;
1101 	uint public tokenCurrentStage;
1102 	bool public hasICOFinished;
1103 	
1104 	uint public etherPrice; //Price x100 (with no cents: $800.55 => 80055)
1105 	uint public etherInContract;
1106 	uint public LEXInContract;
1107 	uint public usdEstimateInContract; //With no cents and x10**8 (1usd => 10000000000)
1108 	uint public softCap = 35437500000000000; //15% of goal $3,543,750 With no cents and x10**8 (1usd => 10000000000)
1109 	uint currentSoftCapContact;
1110 	
1111 	uint public startEpochTimestamp = 1518807600; // Friday February 16th 2018 at 12pm GMT-06:00, you can verify the epoch at https://www.epochconverter.com/
1112 	uint public endEpochTimestamp = 1521093600; // Thursday March 15th 2018 at 12am GMT-06:00, you can verify the epoch at https://www.epochconverter.com/
1113 	
1114 	uint public lastPriceCheck = 0;
1115 	
1116 	uint preICOAvailableTokens = 11250000; // 11,250,000 AUM's for the pre ICO, with 8 decimals
1117 	uint ICOAvailableTokens = 20625000; // 20,625,000 AUM's for the pre ICO, with 8 decimals
1118 	
1119 	uint minAmmountToInvest = 100000000000000000; // 0.1 Ether, or 100,000,000,000,000,000 wei
1120 	uint maxAmmountToInvest = 500000000000000000000; // 500 Ether, or 500,000,000,000,000,000,000 wei
1121 	
1122 	address LEXTokenAddress; //Limited Exchange Token address, For future processing via Koinvex
1123 	address tokenContractAddress;
1124 	address tokenVaultAddress;
1125 	address admin;
1126 	address etherVault;
1127 	address etherGasProvider;
1128 	mapping(address => Contact) public allContacts;
1129 	address[] public contactsAddresses;
1130 	
1131 	bool tokenContractAddressReady;
1132 	bool LEXtokenContractAddressReady;
1133 	
1134 	ERC223 public tokenReward;
1135 	ERC223 public LEXToken;
1136 	
1137 	OperationInQueue[] public operationsInQueue;
1138 	uint public currentOperation;
1139 	
1140 	modifier onlyAdmin()
1141 	{
1142 	    require(msg.sender == admin);
1143 	    _;
1144 	}
1145 	
1146 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
1147 
1148 	function AumICO() public {
1149 	    admin = msg.sender;
1150 		etherPrice = 100055; // testing => $1,000.55
1151 		etherInContract = 0;
1152 		LEXInContract = 0;
1153 		usdEstimateInContract = 19687500000000000; //$1,968,750 in pre-sale
1154 		tokenPrice[0] = 35;//uint public tokenPricePreSale = 35; //Price x100 (with no cents: $0.35 => 35)
1155 		tokenPrice[1] = 55;//uint public tokenPricePreICO = 55; //Price x100 (with no cents: $0.55 => 55)
1156 		tokenPrice[2] = 75;//uint public tokenPriceICO = 75; //Price x100 (with no cents: $0.75 => 75)
1157 		availableTokens[0] = 0;
1158 		availableTokens[1] = preICOAvailableTokens * 10**8;
1159 		availableTokens[2] = ICOAvailableTokens * 10**8;
1160 		tokenCurrentStage = 0;
1161 		tokenContractAddressReady = false;
1162 		LEXtokenContractAddressReady = false;
1163 		etherVault = 0x1FE5e535C3BB002EE0ba499a41f66677fC383424;// all deposited ether will go to this address
1164 		etherGasProvider = 0x1FE5e535C3BB002EE0ba499a41f66677fC383424;// this address is whitelisted for sending ether to this contract without sending back tokens
1165 		tokenVaultAddress = msg.sender;
1166 		currentOperation = 0;
1167 		hasICOFinished = false;
1168 		lastPriceCheck = 0;
1169 		currentSoftCapContact = 0;
1170 	}
1171 	
1172 	function () payable {
1173 		if(msg.sender == etherGasProvider)
1174 		{
1175 			return;
1176 		}
1177 		if(!allContacts[msg.sender].isOnWhitelist || (now < startEpochTimestamp && msg.sender != admin) || now >= endEpochTimestamp || hasICOFinished || !tokenContractAddressReady)
1178 		{
1179 			revert();
1180 		}
1181         uint depositedEther = msg.value;
1182         uint currentVaultBalance = tokenReward.balanceOf(tokenVaultAddress);
1183         uint totalAddressDeposit = safeAdd(allContacts[msg.sender].depositedEther, depositedEther);
1184         uint leftoverEther = 0;
1185 		if(depositedEther < minAmmountToInvest || totalAddressDeposit > maxAmmountToInvest)
1186 		{
1187 			bool canEtherPassthrough = false;
1188 		    if(totalAddressDeposit > maxAmmountToInvest)
1189 		    {
1190 		        uint passthroughEther = safeSub(maxAmmountToInvest, allContacts[msg.sender].depositedEther);   
1191 		        if(passthroughEther > 0)
1192 		        {
1193 		            depositedEther = safeSub(depositedEther, 100000);   //Gas for the extra transactions
1194 		            if(depositedEther > passthroughEther)
1195 		            {
1196 		                leftoverEther = safeSub(depositedEther, passthroughEther);   
1197 		            }
1198 		            depositedEther = passthroughEther;
1199 		            canEtherPassthrough = true;
1200 		        }
1201 		    }
1202 		    if(!canEtherPassthrough)
1203 		    {
1204 		        revert();    
1205 		    }
1206 		}
1207 		if (currentVaultBalance > 0)
1208 		{
1209 		
1210 			if(safeSub(now, lastPriceCheck) > 300)
1211 			{
1212 				operationsInQueue.push(OperationInQueue(now, depositedEther, msg.sender, false));
1213 				updatePrice();
1214 			}else
1215 			{
1216 				sendTokens(msg.sender, depositedEther);
1217 			}
1218 		}else 
1219 		{
1220 			revert();
1221 		}
1222 		if(leftoverEther > 0)
1223 		{
1224 		    msg.sender.transfer(leftoverEther);
1225 		}
1226     }
1227     
1228 	function sendTokens(address receiver, uint depositedEther) private 
1229 	{
1230 		if(tokenCurrentStage >= 3)
1231 		{
1232 			hasICOFinished = true;
1233 			receiver.transfer(depositedEther);
1234 		}else
1235 		{
1236 			uint obtainedTokensDividend = safeMul(etherPrice, depositedEther );
1237 			uint obtainedTokensDivisor = safeMul(tokenPrice[tokenCurrentStage], 10**10 );
1238 			uint obtainedTokens = safeDiv(obtainedTokensDividend, obtainedTokensDivisor);
1239 			if(obtainedTokens > availableTokens[tokenCurrentStage])
1240 			{
1241 			    uint leftoverEther = depositedEther;
1242 				if(availableTokens[tokenCurrentStage] > 0)
1243 				{
1244 				    uint tokensAvailableForTransfer = availableTokens[tokenCurrentStage];
1245 				    uint leftoverTokens = safeSub(obtainedTokens, availableTokens[tokenCurrentStage]);
1246     				availableTokens[tokenCurrentStage] = 0;
1247     				uint leftoverEtherDividend = safeMul(leftoverTokens, tokenPrice[tokenCurrentStage] );
1248     				leftoverEtherDividend = safeMul(leftoverEtherDividend, 10**10 );
1249     				leftoverEther = safeDiv(leftoverEtherDividend, etherPrice);
1250     				
1251 				    uint usedEther = safeSub(depositedEther, leftoverEther);
1252 					etherInContract += usedEther;
1253 					allContacts[receiver].obtainedTokens += tokensAvailableForTransfer;
1254 			        allContacts[receiver].depositedEther += usedEther;
1255 			        usdEstimateInContract += safeMul(tokensAvailableForTransfer, tokenPrice[tokenCurrentStage] );
1256 					etherVault.transfer(depositedEther);
1257 					tokenReward.transferFrom(tokenVaultAddress, receiver, tokensAvailableForTransfer);
1258 				}
1259 				tokenCurrentStage++;
1260 				sendTokens(receiver, leftoverEther);
1261 			}else
1262 			{
1263 			    usdEstimateInContract += safeMul(obtainedTokens, tokenPrice[tokenCurrentStage] );
1264 				availableTokens[tokenCurrentStage] = safeSub(availableTokens[tokenCurrentStage], obtainedTokens);
1265 				etherInContract += depositedEther;
1266 				allContacts[receiver].obtainedTokens += obtainedTokens;
1267 			    allContacts[receiver].depositedEther += depositedEther;
1268 				etherVault.transfer(depositedEther);
1269 				tokenReward.transferFrom(tokenVaultAddress, receiver, obtainedTokens);
1270 			}
1271 		}
1272 	}
1273 	
1274 	
1275 	function tokenFallback(address _from, uint _value, bytes _data) public
1276 	{
1277 		if(msg.sender != LEXTokenAddress || !LEXtokenContractAddressReady)
1278 		{
1279 			revert();
1280 		}
1281 		if(!allContacts[_from].isOnWhitelist || now < startEpochTimestamp || now >= endEpochTimestamp || hasICOFinished || !tokenContractAddressReady)
1282 		{
1283 			revert();
1284 		}
1285 		uint currentVaultBalance = tokenReward.balanceOf(tokenVaultAddress);
1286 		if(currentVaultBalance > 0)
1287 		{
1288 			sendTokensForLEX(_from, _value);
1289 		}else
1290 		{
1291 			revert();
1292 		}
1293 	}
1294 	
1295 	function sendTokensForLEX(address receiver, uint depositedLEX) private 
1296 	{
1297 		if(tokenCurrentStage >= 3)
1298 		{
1299 			hasICOFinished = true;
1300 			LEXToken.transfer(receiver, depositedLEX);
1301 		}else
1302 		{
1303 			uint depositedBalance = safeMul(depositedLEX, 100000000);
1304 			uint obtainedTokens = safeDiv(depositedBalance, tokenPrice[tokenCurrentStage]);
1305 			if(obtainedTokens > availableTokens[tokenCurrentStage])
1306 			{
1307 			    uint leftoverLEX = depositedLEX;
1308 				if(availableTokens[tokenCurrentStage] > 0)
1309 				{
1310 				    uint tokensAvailableForTransfer = availableTokens[tokenCurrentStage];
1311 				    uint leftoverTokens = safeSub(obtainedTokens, availableTokens[tokenCurrentStage]);
1312     				availableTokens[tokenCurrentStage] = 0;
1313     				uint leftoverLEXFactor = safeMul(leftoverTokens, tokenPrice[tokenCurrentStage] );
1314     				leftoverLEX = safeDiv(leftoverLEXFactor, 100000000);
1315     				
1316 				    uint usedLEX = safeSub(depositedLEX, leftoverLEX);
1317 					LEXInContract += usedLEX;
1318 					allContacts[receiver].obtainedTokens += tokensAvailableForTransfer;
1319 			        allContacts[receiver].depositedLEX += usedLEX;
1320 			        usdEstimateInContract += safeMul(tokensAvailableForTransfer, tokenPrice[tokenCurrentStage] );
1321 					tokenReward.transferFrom(tokenVaultAddress, receiver, tokensAvailableForTransfer);
1322 				}
1323 				tokenCurrentStage++;
1324 				sendTokensForLEX(receiver, leftoverLEX);
1325 			}else
1326 			{
1327 			    usdEstimateInContract += depositedLEX;
1328 				availableTokens[tokenCurrentStage] = safeSub(availableTokens[tokenCurrentStage], obtainedTokens);
1329 				LEXInContract += depositedLEX;
1330 				allContacts[receiver].obtainedTokens += obtainedTokens;
1331 			    allContacts[receiver].depositedLEX += depositedLEX;
1332 				tokenReward.transferFrom(tokenVaultAddress, receiver, obtainedTokens);
1333 			}
1334 		}
1335 	}
1336 	
1337 	
1338 	
1339 	function CheckQueue() private
1340 	{
1341 	    if(operationsInQueue.length > currentOperation)
1342 	    {
1343     		if(!operationsInQueue[currentOperation].closed)
1344     		{
1345     		    operationsInQueue[currentOperation].closed = true;
1346     			if(safeSub(now, lastPriceCheck) > 300)
1347     			{
1348     				operationsInQueue.push(OperationInQueue(now, operationsInQueue[currentOperation].depositedEther, operationsInQueue[currentOperation].receiver, false));
1349     				updatePrice();
1350     				currentOperation++;
1351     				return;
1352     			}else
1353     			{
1354     				sendTokens(operationsInQueue[currentOperation].receiver, operationsInQueue[currentOperation].depositedEther);
1355     			}
1356     		}
1357     		currentOperation++;
1358 	    }
1359 	}
1360 	
1361 	function getTokenAddress() public constant returns (address) {
1362 		return tokenContractAddress;
1363 	}
1364 	
1365 	function getTokenBalance() public constant returns (uint) {
1366 		return tokenReward.balanceOf(tokenVaultAddress);
1367 	}
1368 	
1369 	
1370 	function getEtherInContract() public constant returns (uint) {
1371 		return etherInContract;
1372 	}
1373 	
1374 	function GetQueueLength() public onlyAdmin constant returns (uint) {
1375 		return safeSub(operationsInQueue.length, currentOperation);
1376 	}
1377 	
1378 	function changeTokenAddress (address newTokenAddress) public onlyAdmin
1379 	{
1380 		tokenContractAddress = newTokenAddress;
1381 		tokenReward = ERC223(tokenContractAddress);
1382 		tokenContractAddressReady = true;
1383 	}
1384 	
1385 	function ChangeLEXTokenAddress (address newLEXTokenAddress) public onlyAdmin
1386 	{
1387 		LEXTokenAddress = newLEXTokenAddress;
1388 		LEXToken = ERC223(LEXTokenAddress);
1389 		LEXtokenContractAddressReady = true;
1390 	}
1391 	
1392 	function ChangeEtherVault(address newEtherVault) onlyAdmin public
1393 	{
1394 		etherVault = newEtherVault;
1395 	}
1396 	
1397 	function ExtractEtherLeftOnContract(address newEtherGasProvider) onlyAdmin public
1398 	{
1399 		if(now > endEpochTimestamp)
1400 	    {
1401 			etherVault.transfer(this.balance);
1402 		}
1403 	}
1404 	
1405 	function ChangeEtherGasProvider(address newEtherGasProvider) onlyAdmin public
1406 	{
1407 		etherGasProvider = newEtherGasProvider;
1408 	}
1409 	
1410 	function ChangeTokenVaultAddress(address newTokenVaultAddress) onlyAdmin public
1411 	{
1412 		tokenVaultAddress = newTokenVaultAddress;
1413 	}
1414 	
1415 	function AdvanceQueue() onlyAdmin public
1416 	{
1417 		CheckQueue();
1418 	}
1419 	
1420 	function UpdateEtherPriceNow() onlyAdmin public
1421 	{
1422 		updatePrice();
1423 	}
1424 	
1425 	function CheckSoftCap() onlyAdmin public
1426 	{
1427 	    if(usdEstimateInContract < softCap && now > endEpochTimestamp && currentSoftCapContact < contactsAddresses.length)
1428 	    {
1429 	        for(uint i = currentSoftCapContact; i < 4;i++)
1430 	        {
1431 				if(i < contactsAddresses.length)
1432 				{
1433 					if(!allContacts[contactsAddresses[i]].userLiquidated)
1434 					{
1435 						allContacts[contactsAddresses[i]].userLiquidated = true;
1436 						allContacts[contactsAddresses[i]].depositedEther = 0;
1437 						contactsAddresses[i].transfer(allContacts[contactsAddresses[i]].depositedEther);
1438 					}
1439 					currentSoftCapContact++;
1440 				}
1441 	        }
1442 	    }
1443 	}
1444 	
1445 	function AddToWhitelist(address addressToAdd) onlyAdmin public
1446 	{
1447 	    if(!allContacts[addressToAdd].userExists)
1448 		{
1449     		contactsAddresses.push(addressToAdd);
1450     		allContacts[addressToAdd].userExists = true;
1451 		}
1452 		allContacts[addressToAdd].isOnWhitelist = true;
1453 	}
1454 	
1455 	function RemoveFromWhitelist(address addressToRemove) onlyAdmin public
1456 	{
1457 	    if(allContacts[addressToRemove].userExists)
1458 		{
1459 			allContacts[addressToRemove].isOnWhitelist = false;
1460 		}
1461 	}
1462 	
1463 	function GetAdminAddress() public returns (address)
1464 	{
1465 		return admin;
1466 	}
1467 	
1468 	function IsOnWhitelist(address addressToCheck) public view returns(bool isOnWhitelist)
1469 	{
1470 		return allContacts[addressToCheck].isOnWhitelist;
1471 	}
1472 	
1473 	function getPrice() public constant returns (uint) {
1474 		return etherPrice;
1475 	}
1476 	
1477 	function updatePrice() private
1478 	{
1479 		if (oraclize_getPrice("URL") > this.balance) {
1480             //LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1481         } else {
1482             //LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1483             oraclize_query("URL", "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD", 300000);
1484         }
1485 	}
1486 	
1487 	function __callback(bytes32 _myid, string _result) {
1488 		require (msg.sender == oraclize_cbAddress());
1489 		etherPrice = parseInt(_result, 2);
1490 		lastPriceCheck = now;
1491 		CheckQueue();
1492 	}
1493 }