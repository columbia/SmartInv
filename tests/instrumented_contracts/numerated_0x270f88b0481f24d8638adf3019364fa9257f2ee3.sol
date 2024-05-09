1 pragma solidity 0.4.23;
2 
3 // File: minter-service/contracts/IICOInfo.sol
4 
5 contract IICOInfo {
6   function estimate(uint256 _wei) public constant returns (uint tokens);
7   function purchasedTokenBalanceOf(address addr) public constant returns (uint256 tokens);
8   function isSaleActive() public constant returns (bool active);
9 }
10 
11 // File: minter-service/contracts/IMintableToken.sol
12 
13 contract IMintableToken {
14     function mint(address _to, uint256 _amount);
15 }
16 
17 // File: contracts/oraclize/usingOraclize.sol
18 
19 // <ORACLIZE_API>
20 /*
21 Copyright (c) 2015-2016 Oraclize SRL
22 Copyright (c) 2016 Oraclize LTD
23 
24 
25 
26 Permission is hereby granted, free of charge, to any person obtaining a copy
27 of this software and associated documentation files (the "Software"), to deal
28 in the Software without restriction, including without limitation the rights
29 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
30 copies of the Software, and to permit persons to whom the Software is
31 furnished to do so, subject to the following conditions:
32 
33 
34 
35 The above copyright notice and this permission notice shall be included in
36 all copies or substantial portions of the Software.
37 
38 
39 
40 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
41 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
42 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
43 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
44 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
45 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
46 THE SOFTWARE.
47 */
48 
49 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
50 pragma solidity ^0.4.18;
51 
52 contract OraclizeI {
53     address public cbAddress;
54     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
55     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
56     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
57     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
58     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
59     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
60     function getPrice(string _datasource) public returns (uint _dsprice);
61     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
62     function setProofType(byte _proofType) external;
63     function setCustomGasPrice(uint _gasPrice) external;
64     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
65 }
66 contract OraclizeAddrResolverI {
67     function getAddress() public returns (address _addr);
68 }
69 contract usingOraclize {
70     uint constant day = 60*60*24;
71     uint constant week = 60*60*24*7;
72     uint constant month = 60*60*24*30;
73     byte constant proofType_NONE = 0x00;
74     byte constant proofType_TLSNotary = 0x10;
75     byte constant proofType_Android = 0x20;
76     byte constant proofType_Ledger = 0x30;
77     byte constant proofType_Native = 0xF0;
78     byte constant proofStorage_IPFS = 0x01;
79     uint8 constant networkID_auto = 0;
80     uint8 constant networkID_mainnet = 1;
81     uint8 constant networkID_testnet = 2;
82     uint8 constant networkID_morden = 2;
83     uint8 constant networkID_consensys = 161;
84 
85     OraclizeAddrResolverI OAR;
86 
87     OraclizeI oraclize;
88     modifier oraclizeAPI {
89         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
90             oraclize_setNetwork(networkID_auto);
91 
92         if(address(oraclize) != OAR.getAddress())
93             oraclize = OraclizeI(OAR.getAddress());
94 
95         _;
96     }
97     modifier coupon(string code){
98         oraclize = OraclizeI(OAR.getAddress());
99         _;
100     }
101 
102     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
103       return oraclize_setNetwork();
104       networkID; // silence the warning and remain backwards compatible
105     }
106     function oraclize_setNetwork() internal returns(bool){
107         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
108             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
109             oraclize_setNetworkName("eth_mainnet");
110             return true;
111         }
112         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
113             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
114             oraclize_setNetworkName("eth_ropsten3");
115             return true;
116         }
117         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
118             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
119             oraclize_setNetworkName("eth_kovan");
120             return true;
121         }
122         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
123             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
124             oraclize_setNetworkName("eth_rinkeby");
125             return true;
126         }
127         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
128             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
129             return true;
130         }
131         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
132             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
133             return true;
134         }
135         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
136             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
137             return true;
138         }
139         return false;
140     }
141 
142     function __callback(bytes32 myid, string result) public {
143         __callback(myid, result, new bytes(0));
144     }
145     function __callback(bytes32 myid, string result, bytes proof) public {
146       return;
147       myid; result; proof; // Silence compiler warnings
148     }
149 
150     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
151         return oraclize.getPrice(datasource);
152     }
153 
154     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
155         return oraclize.getPrice(datasource, gaslimit);
156     }
157 
158     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
159         uint price = oraclize.getPrice(datasource);
160         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
161         return oraclize.query.value(price)(0, datasource, arg);
162     }
163     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
164         uint price = oraclize.getPrice(datasource);
165         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
166         return oraclize.query.value(price)(timestamp, datasource, arg);
167     }
168     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
169         uint price = oraclize.getPrice(datasource, gaslimit);
170         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
171         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
172     }
173     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
174         uint price = oraclize.getPrice(datasource, gaslimit);
175         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
176         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
177     }
178     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
179         uint price = oraclize.getPrice(datasource);
180         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
181         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
182     }
183     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
184         uint price = oraclize.getPrice(datasource);
185         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
186         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
187     }
188     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
189         uint price = oraclize.getPrice(datasource, gaslimit);
190         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
191         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
192     }
193     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
194         uint price = oraclize.getPrice(datasource, gaslimit);
195         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
196         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
197     }
198     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
199         uint price = oraclize.getPrice(datasource);
200         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
201         bytes memory args = stra2cbor(argN);
202         return oraclize.queryN.value(price)(0, datasource, args);
203     }
204     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
205         uint price = oraclize.getPrice(datasource);
206         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
207         bytes memory args = stra2cbor(argN);
208         return oraclize.queryN.value(price)(timestamp, datasource, args);
209     }
210     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
211         uint price = oraclize.getPrice(datasource, gaslimit);
212         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
213         bytes memory args = stra2cbor(argN);
214         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
215     }
216     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
217         uint price = oraclize.getPrice(datasource, gaslimit);
218         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
219         bytes memory args = stra2cbor(argN);
220         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
221     }
222     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
223         string[] memory dynargs = new string[](1);
224         dynargs[0] = args[0];
225         return oraclize_query(datasource, dynargs);
226     }
227     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
228         string[] memory dynargs = new string[](1);
229         dynargs[0] = args[0];
230         return oraclize_query(timestamp, datasource, dynargs);
231     }
232     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
233         string[] memory dynargs = new string[](1);
234         dynargs[0] = args[0];
235         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
236     }
237     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
238         string[] memory dynargs = new string[](1);
239         dynargs[0] = args[0];
240         return oraclize_query(datasource, dynargs, gaslimit);
241     }
242 
243     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
244         string[] memory dynargs = new string[](2);
245         dynargs[0] = args[0];
246         dynargs[1] = args[1];
247         return oraclize_query(datasource, dynargs);
248     }
249     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
250         string[] memory dynargs = new string[](2);
251         dynargs[0] = args[0];
252         dynargs[1] = args[1];
253         return oraclize_query(timestamp, datasource, dynargs);
254     }
255     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
256         string[] memory dynargs = new string[](2);
257         dynargs[0] = args[0];
258         dynargs[1] = args[1];
259         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
260     }
261     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
262         string[] memory dynargs = new string[](2);
263         dynargs[0] = args[0];
264         dynargs[1] = args[1];
265         return oraclize_query(datasource, dynargs, gaslimit);
266     }
267     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
268         string[] memory dynargs = new string[](3);
269         dynargs[0] = args[0];
270         dynargs[1] = args[1];
271         dynargs[2] = args[2];
272         return oraclize_query(datasource, dynargs);
273     }
274     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
275         string[] memory dynargs = new string[](3);
276         dynargs[0] = args[0];
277         dynargs[1] = args[1];
278         dynargs[2] = args[2];
279         return oraclize_query(timestamp, datasource, dynargs);
280     }
281     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
282         string[] memory dynargs = new string[](3);
283         dynargs[0] = args[0];
284         dynargs[1] = args[1];
285         dynargs[2] = args[2];
286         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
287     }
288     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
289         string[] memory dynargs = new string[](3);
290         dynargs[0] = args[0];
291         dynargs[1] = args[1];
292         dynargs[2] = args[2];
293         return oraclize_query(datasource, dynargs, gaslimit);
294     }
295 
296     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
297         string[] memory dynargs = new string[](4);
298         dynargs[0] = args[0];
299         dynargs[1] = args[1];
300         dynargs[2] = args[2];
301         dynargs[3] = args[3];
302         return oraclize_query(datasource, dynargs);
303     }
304     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
305         string[] memory dynargs = new string[](4);
306         dynargs[0] = args[0];
307         dynargs[1] = args[1];
308         dynargs[2] = args[2];
309         dynargs[3] = args[3];
310         return oraclize_query(timestamp, datasource, dynargs);
311     }
312     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
313         string[] memory dynargs = new string[](4);
314         dynargs[0] = args[0];
315         dynargs[1] = args[1];
316         dynargs[2] = args[2];
317         dynargs[3] = args[3];
318         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
319     }
320     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
321         string[] memory dynargs = new string[](4);
322         dynargs[0] = args[0];
323         dynargs[1] = args[1];
324         dynargs[2] = args[2];
325         dynargs[3] = args[3];
326         return oraclize_query(datasource, dynargs, gaslimit);
327     }
328     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
329         string[] memory dynargs = new string[](5);
330         dynargs[0] = args[0];
331         dynargs[1] = args[1];
332         dynargs[2] = args[2];
333         dynargs[3] = args[3];
334         dynargs[4] = args[4];
335         return oraclize_query(datasource, dynargs);
336     }
337     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
338         string[] memory dynargs = new string[](5);
339         dynargs[0] = args[0];
340         dynargs[1] = args[1];
341         dynargs[2] = args[2];
342         dynargs[3] = args[3];
343         dynargs[4] = args[4];
344         return oraclize_query(timestamp, datasource, dynargs);
345     }
346     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
347         string[] memory dynargs = new string[](5);
348         dynargs[0] = args[0];
349         dynargs[1] = args[1];
350         dynargs[2] = args[2];
351         dynargs[3] = args[3];
352         dynargs[4] = args[4];
353         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
354     }
355     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
356         string[] memory dynargs = new string[](5);
357         dynargs[0] = args[0];
358         dynargs[1] = args[1];
359         dynargs[2] = args[2];
360         dynargs[3] = args[3];
361         dynargs[4] = args[4];
362         return oraclize_query(datasource, dynargs, gaslimit);
363     }
364     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
365         uint price = oraclize.getPrice(datasource);
366         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
367         bytes memory args = ba2cbor(argN);
368         return oraclize.queryN.value(price)(0, datasource, args);
369     }
370     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
371         uint price = oraclize.getPrice(datasource);
372         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
373         bytes memory args = ba2cbor(argN);
374         return oraclize.queryN.value(price)(timestamp, datasource, args);
375     }
376     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
377         uint price = oraclize.getPrice(datasource, gaslimit);
378         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
379         bytes memory args = ba2cbor(argN);
380         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
381     }
382     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
383         uint price = oraclize.getPrice(datasource, gaslimit);
384         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
385         bytes memory args = ba2cbor(argN);
386         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
387     }
388     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
389         bytes[] memory dynargs = new bytes[](1);
390         dynargs[0] = args[0];
391         return oraclize_query(datasource, dynargs);
392     }
393     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
394         bytes[] memory dynargs = new bytes[](1);
395         dynargs[0] = args[0];
396         return oraclize_query(timestamp, datasource, dynargs);
397     }
398     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
399         bytes[] memory dynargs = new bytes[](1);
400         dynargs[0] = args[0];
401         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
402     }
403     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
404         bytes[] memory dynargs = new bytes[](1);
405         dynargs[0] = args[0];
406         return oraclize_query(datasource, dynargs, gaslimit);
407     }
408 
409     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
410         bytes[] memory dynargs = new bytes[](2);
411         dynargs[0] = args[0];
412         dynargs[1] = args[1];
413         return oraclize_query(datasource, dynargs);
414     }
415     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
416         bytes[] memory dynargs = new bytes[](2);
417         dynargs[0] = args[0];
418         dynargs[1] = args[1];
419         return oraclize_query(timestamp, datasource, dynargs);
420     }
421     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
422         bytes[] memory dynargs = new bytes[](2);
423         dynargs[0] = args[0];
424         dynargs[1] = args[1];
425         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
426     }
427     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
428         bytes[] memory dynargs = new bytes[](2);
429         dynargs[0] = args[0];
430         dynargs[1] = args[1];
431         return oraclize_query(datasource, dynargs, gaslimit);
432     }
433     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
434         bytes[] memory dynargs = new bytes[](3);
435         dynargs[0] = args[0];
436         dynargs[1] = args[1];
437         dynargs[2] = args[2];
438         return oraclize_query(datasource, dynargs);
439     }
440     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
441         bytes[] memory dynargs = new bytes[](3);
442         dynargs[0] = args[0];
443         dynargs[1] = args[1];
444         dynargs[2] = args[2];
445         return oraclize_query(timestamp, datasource, dynargs);
446     }
447     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
448         bytes[] memory dynargs = new bytes[](3);
449         dynargs[0] = args[0];
450         dynargs[1] = args[1];
451         dynargs[2] = args[2];
452         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
453     }
454     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
455         bytes[] memory dynargs = new bytes[](3);
456         dynargs[0] = args[0];
457         dynargs[1] = args[1];
458         dynargs[2] = args[2];
459         return oraclize_query(datasource, dynargs, gaslimit);
460     }
461 
462     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
463         bytes[] memory dynargs = new bytes[](4);
464         dynargs[0] = args[0];
465         dynargs[1] = args[1];
466         dynargs[2] = args[2];
467         dynargs[3] = args[3];
468         return oraclize_query(datasource, dynargs);
469     }
470     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
471         bytes[] memory dynargs = new bytes[](4);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         dynargs[2] = args[2];
475         dynargs[3] = args[3];
476         return oraclize_query(timestamp, datasource, dynargs);
477     }
478     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
479         bytes[] memory dynargs = new bytes[](4);
480         dynargs[0] = args[0];
481         dynargs[1] = args[1];
482         dynargs[2] = args[2];
483         dynargs[3] = args[3];
484         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
485     }
486     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
487         bytes[] memory dynargs = new bytes[](4);
488         dynargs[0] = args[0];
489         dynargs[1] = args[1];
490         dynargs[2] = args[2];
491         dynargs[3] = args[3];
492         return oraclize_query(datasource, dynargs, gaslimit);
493     }
494     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
495         bytes[] memory dynargs = new bytes[](5);
496         dynargs[0] = args[0];
497         dynargs[1] = args[1];
498         dynargs[2] = args[2];
499         dynargs[3] = args[3];
500         dynargs[4] = args[4];
501         return oraclize_query(datasource, dynargs);
502     }
503     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
504         bytes[] memory dynargs = new bytes[](5);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         dynargs[3] = args[3];
509         dynargs[4] = args[4];
510         return oraclize_query(timestamp, datasource, dynargs);
511     }
512     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
513         bytes[] memory dynargs = new bytes[](5);
514         dynargs[0] = args[0];
515         dynargs[1] = args[1];
516         dynargs[2] = args[2];
517         dynargs[3] = args[3];
518         dynargs[4] = args[4];
519         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
520     }
521     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
522         bytes[] memory dynargs = new bytes[](5);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         dynargs[2] = args[2];
526         dynargs[3] = args[3];
527         dynargs[4] = args[4];
528         return oraclize_query(datasource, dynargs, gaslimit);
529     }
530 
531     function oraclize_cbAddress() oraclizeAPI internal returns (address){
532         return oraclize.cbAddress();
533     }
534     function oraclize_setProof(byte proofP) oraclizeAPI internal {
535         return oraclize.setProofType(proofP);
536     }
537     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
538         return oraclize.setCustomGasPrice(gasPrice);
539     }
540 
541     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
542         return oraclize.randomDS_getSessionPubKeyHash();
543     }
544 
545     function getCodeSize(address _addr) constant internal returns(uint _size) {
546         assembly {
547             _size := extcodesize(_addr)
548         }
549     }
550 
551     function parseAddr(string _a) internal pure returns (address){
552         bytes memory tmp = bytes(_a);
553         uint160 iaddr = 0;
554         uint160 b1;
555         uint160 b2;
556         for (uint i=2; i<2+2*20; i+=2){
557             iaddr *= 256;
558             b1 = uint160(tmp[i]);
559             b2 = uint160(tmp[i+1]);
560             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
561             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
562             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
563             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
564             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
565             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
566             iaddr += (b1*16+b2);
567         }
568         return address(iaddr);
569     }
570 
571     function strCompare(string _a, string _b) internal pure returns (int) {
572         bytes memory a = bytes(_a);
573         bytes memory b = bytes(_b);
574         uint minLength = a.length;
575         if (b.length < minLength) minLength = b.length;
576         for (uint i = 0; i < minLength; i ++)
577             if (a[i] < b[i])
578                 return -1;
579             else if (a[i] > b[i])
580                 return 1;
581         if (a.length < b.length)
582             return -1;
583         else if (a.length > b.length)
584             return 1;
585         else
586             return 0;
587     }
588 
589     function indexOf(string _haystack, string _needle) internal pure returns (int) {
590         bytes memory h = bytes(_haystack);
591         bytes memory n = bytes(_needle);
592         if(h.length < 1 || n.length < 1 || (n.length > h.length))
593             return -1;
594         else if(h.length > (2**128 -1))
595             return -1;
596         else
597         {
598             uint subindex = 0;
599             for (uint i = 0; i < h.length; i ++)
600             {
601                 if (h[i] == n[0])
602                 {
603                     subindex = 1;
604                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
605                     {
606                         subindex++;
607                     }
608                     if(subindex == n.length)
609                         return int(i);
610                 }
611             }
612             return -1;
613         }
614     }
615 
616     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
617         bytes memory _ba = bytes(_a);
618         bytes memory _bb = bytes(_b);
619         bytes memory _bc = bytes(_c);
620         bytes memory _bd = bytes(_d);
621         bytes memory _be = bytes(_e);
622         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
623         bytes memory babcde = bytes(abcde);
624         uint k = 0;
625         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
626         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
627         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
628         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
629         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
630         return string(babcde);
631     }
632 
633     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
634         return strConcat(_a, _b, _c, _d, "");
635     }
636 
637     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
638         return strConcat(_a, _b, _c, "", "");
639     }
640 
641     function strConcat(string _a, string _b) internal pure returns (string) {
642         return strConcat(_a, _b, "", "", "");
643     }
644 
645     // parseInt
646     function parseInt(string _a) internal pure returns (uint) {
647         return parseInt(_a, 0);
648     }
649 
650     // parseInt(parseFloat*10^_b)
651     function parseInt(string _a, uint _b) internal pure returns (uint) {
652         bytes memory bresult = bytes(_a);
653         uint mint = 0;
654         bool decimals = false;
655         for (uint i=0; i<bresult.length; i++){
656             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
657                 if (decimals){
658                    if (_b == 0) break;
659                     else _b--;
660                 }
661                 mint *= 10;
662                 mint += uint(bresult[i]) - 48;
663             } else if (bresult[i] == 46) decimals = true;
664         }
665         if (_b > 0) mint *= 10**_b;
666         return mint;
667     }
668 
669     function uint2str(uint i) internal pure returns (string){
670         if (i == 0) return "0";
671         uint j = i;
672         uint len;
673         while (j != 0){
674             len++;
675             j /= 10;
676         }
677         bytes memory bstr = new bytes(len);
678         uint k = len - 1;
679         while (i != 0){
680             bstr[k--] = byte(48 + i % 10);
681             i /= 10;
682         }
683         return string(bstr);
684     }
685 
686     function stra2cbor(string[] arr) internal pure returns (bytes) {
687             uint arrlen = arr.length;
688 
689             // get correct cbor output length
690             uint outputlen = 0;
691             bytes[] memory elemArray = new bytes[](arrlen);
692             for (uint i = 0; i < arrlen; i++) {
693                 elemArray[i] = (bytes(arr[i]));
694                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
695             }
696             uint ctr = 0;
697             uint cborlen = arrlen + 0x80;
698             outputlen += byte(cborlen).length;
699             bytes memory res = new bytes(outputlen);
700 
701             while (byte(cborlen).length > ctr) {
702                 res[ctr] = byte(cborlen)[ctr];
703                 ctr++;
704             }
705             for (i = 0; i < arrlen; i++) {
706                 res[ctr] = 0x5F;
707                 ctr++;
708                 for (uint x = 0; x < elemArray[i].length; x++) {
709                     // if there's a bug with larger strings, this may be the culprit
710                     if (x % 23 == 0) {
711                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
712                         elemcborlen += 0x40;
713                         uint lctr = ctr;
714                         while (byte(elemcborlen).length > ctr - lctr) {
715                             res[ctr] = byte(elemcborlen)[ctr - lctr];
716                             ctr++;
717                         }
718                     }
719                     res[ctr] = elemArray[i][x];
720                     ctr++;
721                 }
722                 res[ctr] = 0xFF;
723                 ctr++;
724             }
725             return res;
726         }
727 
728     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
729             uint arrlen = arr.length;
730 
731             // get correct cbor output length
732             uint outputlen = 0;
733             bytes[] memory elemArray = new bytes[](arrlen);
734             for (uint i = 0; i < arrlen; i++) {
735                 elemArray[i] = (bytes(arr[i]));
736                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
737             }
738             uint ctr = 0;
739             uint cborlen = arrlen + 0x80;
740             outputlen += byte(cborlen).length;
741             bytes memory res = new bytes(outputlen);
742 
743             while (byte(cborlen).length > ctr) {
744                 res[ctr] = byte(cborlen)[ctr];
745                 ctr++;
746             }
747             for (i = 0; i < arrlen; i++) {
748                 res[ctr] = 0x5F;
749                 ctr++;
750                 for (uint x = 0; x < elemArray[i].length; x++) {
751                     // if there's a bug with larger strings, this may be the culprit
752                     if (x % 23 == 0) {
753                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
754                         elemcborlen += 0x40;
755                         uint lctr = ctr;
756                         while (byte(elemcborlen).length > ctr - lctr) {
757                             res[ctr] = byte(elemcborlen)[ctr - lctr];
758                             ctr++;
759                         }
760                     }
761                     res[ctr] = elemArray[i][x];
762                     ctr++;
763                 }
764                 res[ctr] = 0xFF;
765                 ctr++;
766             }
767             return res;
768         }
769 
770 
771     string oraclize_network_name;
772     function oraclize_setNetworkName(string _network_name) internal {
773         oraclize_network_name = _network_name;
774     }
775 
776     function oraclize_getNetworkName() internal view returns (string) {
777         return oraclize_network_name;
778     }
779 
780     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
781         require((_nbytes > 0) && (_nbytes <= 32));
782         // Convert from seconds to ledger timer ticks
783         _delay *= 10; 
784         bytes memory nbytes = new bytes(1);
785         nbytes[0] = byte(_nbytes);
786         bytes memory unonce = new bytes(32);
787         bytes memory sessionKeyHash = new bytes(32);
788         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
789         assembly {
790             mstore(unonce, 0x20)
791             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
792             mstore(sessionKeyHash, 0x20)
793             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
794         }
795         bytes memory delay = new bytes(32);
796         assembly { 
797             mstore(add(delay, 0x20), _delay) 
798         }
799         
800         bytes memory delay_bytes8 = new bytes(8);
801         copyBytes(delay, 24, 8, delay_bytes8, 0);
802 
803         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
804         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
805         
806         bytes memory delay_bytes8_left = new bytes(8);
807         
808         assembly {
809             let x := mload(add(delay_bytes8, 0x20))
810             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
811             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
812             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
813             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
814             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
815             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
816             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
817             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
818 
819         }
820         
821         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
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
918         require(prefix.length == n_random_bytes);
919 
920         for (uint256 i=0; i< n_random_bytes; i++) {
921             if (content[i] != prefix[i]) match_ = false;
922         }
923 
924         return match_;
925     }
926 
927     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
928 
929         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
930         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
931         bytes memory keyhash = new bytes(32);
932         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
933         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
934 
935         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
936         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
937 
938         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
939         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
940 
941         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
942         // This is to verify that the computed args match with the ones specified in the query.
943         bytes memory commitmentSlice1 = new bytes(8+1+32);
944         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
945 
946         bytes memory sessionPubkey = new bytes(64);
947         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
948         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
949 
950         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
951         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
952             delete oraclize_randomDS_args[queryId];
953         } else return false;
954 
955 
956         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
957         bytes memory tosign1 = new bytes(32+8+1+32);
958         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
959         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
960 
961         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
962         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
963             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
964         }
965 
966         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
967     }
968 
969     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
970     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
971         uint minLength = length + toOffset;
972 
973         // Buffer too small
974         require(to.length >= minLength); // Should be a better way?
975 
976         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
977         uint i = 32 + fromOffset;
978         uint j = 32 + toOffset;
979 
980         while (i < (32 + fromOffset + length)) {
981             assembly {
982                 let tmp := mload(add(from, i))
983                 mstore(add(to, j), tmp)
984             }
985             i += 32;
986             j += 32;
987         }
988 
989         return to;
990     }
991 
992     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
993     // Duplicate Solidity's ecrecover, but catching the CALL return value
994     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
995         // We do our own memory management here. Solidity uses memory offset
996         // 0x40 to store the current end of memory. We write past it (as
997         // writes are memory extensions), but don't update the offset so
998         // Solidity will reuse it. The memory used here is only needed for
999         // this context.
1000 
1001         // FIXME: inline assembly can't access return values
1002         bool ret;
1003         address addr;
1004 
1005         assembly {
1006             let size := mload(0x40)
1007             mstore(size, hash)
1008             mstore(add(size, 32), v)
1009             mstore(add(size, 64), r)
1010             mstore(add(size, 96), s)
1011 
1012             // NOTE: we can reuse the request memory because we deal with
1013             //       the return code
1014             ret := call(3000, 1, 0, size, 128, size, 32)
1015             addr := mload(size)
1016         }
1017 
1018         return (ret, addr);
1019     }
1020 
1021     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1022     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1023         bytes32 r;
1024         bytes32 s;
1025         uint8 v;
1026 
1027         if (sig.length != 65)
1028           return (false, 0);
1029 
1030         // The signature format is a compact form of:
1031         //   {bytes32 r}{bytes32 s}{uint8 v}
1032         // Compact means, uint8 is not padded to 32 bytes.
1033         assembly {
1034             r := mload(add(sig, 32))
1035             s := mload(add(sig, 64))
1036 
1037             // Here we are loading the last 32 bytes. We exploit the fact that
1038             // 'mload' will pad with zeroes if we overread.
1039             // There is no 'mload8' to do this, but that would be nicer.
1040             v := byte(0, mload(add(sig, 96)))
1041 
1042             // Alternative solution:
1043             // 'byte' is not working due to the Solidity parser, so lets
1044             // use the second best option, 'and'
1045             // v := and(mload(add(sig, 65)), 255)
1046         }
1047 
1048         // albeit non-transactional signatures are not specified by the YP, one would expect it
1049         // to match the YP range of [27, 28]
1050         //
1051         // geth uses [0, 1] and some clients have followed. This might change, see:
1052         //  https://github.com/ethereum/go-ethereum/issues/2053
1053         if (v < 27)
1054           v += 27;
1055 
1056         if (v != 27 && v != 28)
1057             return (false, 0);
1058 
1059         return safer_ecrecover(hash, v, r, s);
1060     }
1061 
1062 }
1063 // </ORACLIZE_API>
1064 
1065 // File: mixbytes-solidity/contracts/ownership/multiowned.sol
1066 
1067 // Copyright (C) 2017  MixBytes, LLC
1068 
1069 // Licensed under the Apache License, Version 2.0 (the "License").
1070 // You may not use this file except in compliance with the License.
1071 
1072 // Unless required by applicable law or agreed to in writing, software
1073 // distributed under the License is distributed on an "AS IS" BASIS,
1074 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
1075 
1076 // Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
1077 // Audit, refactoring and improvements by github.com/Eenae
1078 
1079 // @authors:
1080 // Gav Wood <g@ethdev.com>
1081 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
1082 // single, or, crucially, each of a number of, designated owners.
1083 // usage:
1084 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
1085 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
1086 // interior is executed.
1087 
1088 pragma solidity ^0.4.15;
1089 
1090 
1091 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
1092 // TODO acceptOwnership
1093 contract multiowned {
1094 
1095 	// TYPES
1096 
1097     // struct for the status of a pending operation.
1098     struct MultiOwnedOperationPendingState {
1099         // count of confirmations needed
1100         uint yetNeeded;
1101 
1102         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
1103         uint ownersDone;
1104 
1105         // position of this operation key in m_multiOwnedPendingIndex
1106         uint index;
1107     }
1108 
1109 	// EVENTS
1110 
1111     event Confirmation(address owner, bytes32 operation);
1112     event Revoke(address owner, bytes32 operation);
1113     event FinalConfirmation(address owner, bytes32 operation);
1114 
1115     // some others are in the case of an owner changing.
1116     event OwnerChanged(address oldOwner, address newOwner);
1117     event OwnerAdded(address newOwner);
1118     event OwnerRemoved(address oldOwner);
1119 
1120     // the last one is emitted if the required signatures change
1121     event RequirementChanged(uint newRequirement);
1122 
1123 	// MODIFIERS
1124 
1125     // simple single-sig function modifier.
1126     modifier onlyowner {
1127         require(isOwner(msg.sender));
1128         _;
1129     }
1130     // multi-sig function modifier: the operation must have an intrinsic hash in order
1131     // that later attempts can be realised as the same underlying operation and
1132     // thus count as confirmations.
1133     modifier onlymanyowners(bytes32 _operation) {
1134         if (confirmAndCheck(_operation)) {
1135             _;
1136         }
1137         // Even if required number of confirmations has't been collected yet,
1138         // we can't throw here - because changes to the state have to be preserved.
1139         // But, confirmAndCheck itself will throw in case sender is not an owner.
1140     }
1141 
1142     modifier validNumOwners(uint _numOwners) {
1143         require(_numOwners > 0 && _numOwners <= c_maxOwners);
1144         _;
1145     }
1146 
1147     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
1148         require(_required > 0 && _required <= _numOwners);
1149         _;
1150     }
1151 
1152     modifier ownerExists(address _address) {
1153         require(isOwner(_address));
1154         _;
1155     }
1156 
1157     modifier ownerDoesNotExist(address _address) {
1158         require(!isOwner(_address));
1159         _;
1160     }
1161 
1162     modifier multiOwnedOperationIsActive(bytes32 _operation) {
1163         require(isOperationActive(_operation));
1164         _;
1165     }
1166 
1167 	// METHODS
1168 
1169     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
1170     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
1171     function multiowned(address[] _owners, uint _required)
1172         public
1173         validNumOwners(_owners.length)
1174         multiOwnedValidRequirement(_required, _owners.length)
1175     {
1176         assert(c_maxOwners <= 255);
1177 
1178         m_numOwners = _owners.length;
1179         m_multiOwnedRequired = _required;
1180 
1181         for (uint i = 0; i < _owners.length; ++i)
1182         {
1183             address owner = _owners[i];
1184             // invalid and duplicate addresses are not allowed
1185             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
1186 
1187             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
1188             m_owners[currentOwnerIndex] = owner;
1189             m_ownerIndex[owner] = currentOwnerIndex;
1190         }
1191 
1192         assertOwnersAreConsistent();
1193     }
1194 
1195     /// @notice replaces an owner `_from` with another `_to`.
1196     /// @param _from address of owner to replace
1197     /// @param _to address of new owner
1198     // All pending operations will be canceled!
1199     function changeOwner(address _from, address _to)
1200         external
1201         ownerExists(_from)
1202         ownerDoesNotExist(_to)
1203         onlymanyowners(keccak256(msg.data))
1204     {
1205         assertOwnersAreConsistent();
1206 
1207         clearPending();
1208         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
1209         m_owners[ownerIndex] = _to;
1210         m_ownerIndex[_from] = 0;
1211         m_ownerIndex[_to] = ownerIndex;
1212 
1213         assertOwnersAreConsistent();
1214         OwnerChanged(_from, _to);
1215     }
1216 
1217     /// @notice adds an owner
1218     /// @param _owner address of new owner
1219     // All pending operations will be canceled!
1220     function addOwner(address _owner)
1221         external
1222         ownerDoesNotExist(_owner)
1223         validNumOwners(m_numOwners + 1)
1224         onlymanyowners(keccak256(msg.data))
1225     {
1226         assertOwnersAreConsistent();
1227 
1228         clearPending();
1229         m_numOwners++;
1230         m_owners[m_numOwners] = _owner;
1231         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
1232 
1233         assertOwnersAreConsistent();
1234         OwnerAdded(_owner);
1235     }
1236 
1237     /// @notice removes an owner
1238     /// @param _owner address of owner to remove
1239     // All pending operations will be canceled!
1240     function removeOwner(address _owner)
1241         external
1242         ownerExists(_owner)
1243         validNumOwners(m_numOwners - 1)
1244         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
1245         onlymanyowners(keccak256(msg.data))
1246     {
1247         assertOwnersAreConsistent();
1248 
1249         clearPending();
1250         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
1251         m_owners[ownerIndex] = 0;
1252         m_ownerIndex[_owner] = 0;
1253         //make sure m_numOwners is equal to the number of owners and always points to the last owner
1254         reorganizeOwners();
1255 
1256         assertOwnersAreConsistent();
1257         OwnerRemoved(_owner);
1258     }
1259 
1260     /// @notice changes the required number of owner signatures
1261     /// @param _newRequired new number of signatures required
1262     // All pending operations will be canceled!
1263     function changeRequirement(uint _newRequired)
1264         external
1265         multiOwnedValidRequirement(_newRequired, m_numOwners)
1266         onlymanyowners(keccak256(msg.data))
1267     {
1268         m_multiOwnedRequired = _newRequired;
1269         clearPending();
1270         RequirementChanged(_newRequired);
1271     }
1272 
1273     /// @notice Gets an owner by 0-indexed position
1274     /// @param ownerIndex 0-indexed owner position
1275     function getOwner(uint ownerIndex) public constant returns (address) {
1276         return m_owners[ownerIndex + 1];
1277     }
1278 
1279     /// @notice Gets owners
1280     /// @return memory array of owners
1281     function getOwners() public constant returns (address[]) {
1282         address[] memory result = new address[](m_numOwners);
1283         for (uint i = 0; i < m_numOwners; i++)
1284             result[i] = getOwner(i);
1285 
1286         return result;
1287     }
1288 
1289     /// @notice checks if provided address is an owner address
1290     /// @param _addr address to check
1291     /// @return true if it's an owner
1292     function isOwner(address _addr) public constant returns (bool) {
1293         return m_ownerIndex[_addr] > 0;
1294     }
1295 
1296     /// @notice Tests ownership of the current caller.
1297     /// @return true if it's an owner
1298     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
1299     // addOwner/changeOwner and to isOwner.
1300     function amIOwner() external constant onlyowner returns (bool) {
1301         return true;
1302     }
1303 
1304     /// @notice Revokes a prior confirmation of the given operation
1305     /// @param _operation operation value, typically keccak256(msg.data)
1306     function revoke(bytes32 _operation)
1307         external
1308         multiOwnedOperationIsActive(_operation)
1309         onlyowner
1310     {
1311         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
1312         var pending = m_multiOwnedPending[_operation];
1313         require(pending.ownersDone & ownerIndexBit > 0);
1314 
1315         assertOperationIsConsistent(_operation);
1316 
1317         pending.yetNeeded++;
1318         pending.ownersDone -= ownerIndexBit;
1319 
1320         assertOperationIsConsistent(_operation);
1321         Revoke(msg.sender, _operation);
1322     }
1323 
1324     /// @notice Checks if owner confirmed given operation
1325     /// @param _operation operation value, typically keccak256(msg.data)
1326     /// @param _owner an owner address
1327     function hasConfirmed(bytes32 _operation, address _owner)
1328         external
1329         constant
1330         multiOwnedOperationIsActive(_operation)
1331         ownerExists(_owner)
1332         returns (bool)
1333     {
1334         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
1335     }
1336 
1337     // INTERNAL METHODS
1338 
1339     function confirmAndCheck(bytes32 _operation)
1340         private
1341         onlyowner
1342         returns (bool)
1343     {
1344         if (512 == m_multiOwnedPendingIndex.length)
1345             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
1346             // we won't be able to do it because of block gas limit.
1347             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
1348             // TODO use more graceful approach like compact or removal of clearPending completely
1349             clearPending();
1350 
1351         var pending = m_multiOwnedPending[_operation];
1352 
1353         // if we're not yet working on this operation, switch over and reset the confirmation status.
1354         if (! isOperationActive(_operation)) {
1355             // reset count of confirmations needed.
1356             pending.yetNeeded = m_multiOwnedRequired;
1357             // reset which owners have confirmed (none) - set our bitmap to 0.
1358             pending.ownersDone = 0;
1359             pending.index = m_multiOwnedPendingIndex.length++;
1360             m_multiOwnedPendingIndex[pending.index] = _operation;
1361             assertOperationIsConsistent(_operation);
1362         }
1363 
1364         // determine the bit to set for this owner.
1365         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
1366         // make sure we (the message sender) haven't confirmed this operation previously.
1367         if (pending.ownersDone & ownerIndexBit == 0) {
1368             // ok - check if count is enough to go ahead.
1369             assert(pending.yetNeeded > 0);
1370             if (pending.yetNeeded == 1) {
1371                 // enough confirmations: reset and run interior.
1372                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
1373                 delete m_multiOwnedPending[_operation];
1374                 FinalConfirmation(msg.sender, _operation);
1375                 return true;
1376             }
1377             else
1378             {
1379                 // not enough: record that this owner in particular confirmed.
1380                 pending.yetNeeded--;
1381                 pending.ownersDone |= ownerIndexBit;
1382                 assertOperationIsConsistent(_operation);
1383                 Confirmation(msg.sender, _operation);
1384             }
1385         }
1386     }
1387 
1388     // Reclaims free slots between valid owners in m_owners.
1389     // TODO given that its called after each removal, it could be simplified.
1390     function reorganizeOwners() private {
1391         uint free = 1;
1392         while (free < m_numOwners)
1393         {
1394             // iterating to the first free slot from the beginning
1395             while (free < m_numOwners && m_owners[free] != 0) free++;
1396 
1397             // iterating to the first occupied slot from the end
1398             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
1399 
1400             // swap, if possible, so free slot is located at the end after the swap
1401             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
1402             {
1403                 // owners between swapped slots should't be renumbered - that saves a lot of gas
1404                 m_owners[free] = m_owners[m_numOwners];
1405                 m_ownerIndex[m_owners[free]] = free;
1406                 m_owners[m_numOwners] = 0;
1407             }
1408         }
1409     }
1410 
1411     function clearPending() private onlyowner {
1412         uint length = m_multiOwnedPendingIndex.length;
1413         // TODO block gas limit
1414         for (uint i = 0; i < length; ++i) {
1415             if (m_multiOwnedPendingIndex[i] != 0)
1416                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
1417         }
1418         delete m_multiOwnedPendingIndex;
1419     }
1420 
1421     function checkOwnerIndex(uint ownerIndex) private pure returns (uint) {
1422         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
1423         return ownerIndex;
1424     }
1425 
1426     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
1427         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
1428         return 2 ** ownerIndex;
1429     }
1430 
1431     function isOperationActive(bytes32 _operation) private constant returns (bool) {
1432         return 0 != m_multiOwnedPending[_operation].yetNeeded;
1433     }
1434 
1435 
1436     function assertOwnersAreConsistent() private constant {
1437         assert(m_numOwners > 0);
1438         assert(m_numOwners <= c_maxOwners);
1439         assert(m_owners[0] == 0);
1440         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
1441     }
1442 
1443     function assertOperationIsConsistent(bytes32 _operation) private constant {
1444         var pending = m_multiOwnedPending[_operation];
1445         assert(0 != pending.yetNeeded);
1446         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
1447         assert(pending.yetNeeded <= m_multiOwnedRequired);
1448     }
1449 
1450 
1451    	// FIELDS
1452 
1453     uint constant c_maxOwners = 250;
1454 
1455     // the number of owners that must confirm the same operation before it is run.
1456     uint public m_multiOwnedRequired;
1457 
1458 
1459     // pointer used to find a free slot in m_owners
1460     uint public m_numOwners;
1461 
1462     // list of owners (addresses),
1463     // slot 0 is unused so there are no owner which index is 0.
1464     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
1465     address[256] internal m_owners;
1466 
1467     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
1468     mapping(address => uint) internal m_ownerIndex;
1469 
1470 
1471     // the ongoing operations.
1472     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
1473     bytes32[] internal m_multiOwnedPendingIndex;
1474 }
1475 
1476 // File: zeppelin-solidity/contracts/math/SafeMath.sol
1477 
1478 /**
1479  * @title SafeMath
1480  * @dev Math operations with safety checks that throw on error
1481  */
1482 library SafeMath {
1483   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
1484     uint256 c = a * b;
1485     assert(a == 0 || c / a == b);
1486     return c;
1487   }
1488 
1489   function div(uint256 a, uint256 b) internal constant returns (uint256) {
1490     // assert(b > 0); // Solidity automatically throws when dividing by 0
1491     uint256 c = a / b;
1492     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1493     return c;
1494   }
1495 
1496   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
1497     assert(b <= a);
1498     return a - b;
1499   }
1500 
1501   function add(uint256 a, uint256 b) internal constant returns (uint256) {
1502     uint256 c = a + b;
1503     assert(c >= a);
1504     return c;
1505   }
1506 }
1507 
1508 // File: contracts/EthPriceDependent.sol
1509 
1510 contract EthPriceDependent is usingOraclize, multiowned {
1511 
1512     using SafeMath for uint256;
1513 
1514     event NewOraclizeQuery(string description);
1515     event NewETHPrice(uint price);
1516     event ETHPriceOutOfBounds(uint price);
1517 
1518     /// @notice Constructor
1519     /// @param _initialOwners set owners, which can control bounds and things
1520     ///        described in the actual sale contract, inherited from this one
1521     /// @param _consensus Number of votes enough to make a decision
1522     /// @param _production True if on mainnet and testnet
1523     function EthPriceDependent(address[] _initialOwners,  uint _consensus, bool _production)
1524         public
1525         multiowned(_initialOwners, _consensus)
1526     {
1527         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1528         if (!_production) {
1529             // Use it when testing with testrpc and etherium bridge. Don't forget to change address
1530             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1531         } else {
1532             // Don't call this while testing as it's too long and gets in the way
1533             updateETHPriceInCents();
1534         }
1535     }
1536 
1537     /// @notice Send oraclize query.
1538     /// if price is received successfully - update scheduled automatically,
1539     /// if at any point the contract runs out of ether - updating stops and further
1540     /// updating will require running this function again.
1541     /// if price is out of bounds - updating attempts continue
1542     function updateETHPriceInCents() public payable {
1543         // prohibit running multiple instances of update
1544         // however don't throw any error, because it's called from __callback as well
1545         // and we need to let it update the price anyway, otherwise there is an attack possibility
1546         if ( !updateRequestExpired() ) {
1547             NewOraclizeQuery("Oraclize request fail. Previous one still pending");
1548         } else if (oraclize_getPrice("URL") > this.balance) {
1549             NewOraclizeQuery("Oraclize request fail. Not enough ether");
1550         } else {
1551             oraclize_query(
1552                 m_ETHPriceUpdateInterval,
1553                 "URL",
1554                 "json(https://api.coinmarketcap.com/v1/ticker/ethereum/?convert=USD).0.price_usd",
1555                 m_callbackGas
1556             );
1557             m_ETHPriceLastUpdateRequest = getTime();
1558             NewOraclizeQuery("Oraclize query was sent");
1559         }
1560     }
1561 
1562     /// @notice Called on ETH price update by Oraclize
1563     function __callback(bytes32 myid, string result, bytes proof) public {
1564         require(msg.sender == oraclize_cbAddress());
1565 
1566         uint newPrice = parseInt(result).mul(100);
1567 
1568         if (newPrice >= m_ETHPriceLowerBound && newPrice <= m_ETHPriceUpperBound) {
1569             m_ETHPriceInCents = newPrice;
1570             m_ETHPriceLastUpdate = getTime();
1571             NewETHPrice(m_ETHPriceInCents);
1572         } else {
1573             ETHPriceOutOfBounds(newPrice);
1574         }
1575         // continue updating anyway (if current price was out of bounds, the price might recover in the next cycle)
1576         updateETHPriceInCents();
1577     }
1578 
1579     /// @notice set the limit of ETH in cents, oraclize data greater than this is not accepted
1580     /// @param _price Price in US cents
1581     function setETHPriceUpperBound(uint _price)
1582         external
1583         onlymanyowners(keccak256(msg.data))
1584     {
1585         m_ETHPriceUpperBound = _price;
1586     }
1587 
1588     /// @notice set the limit of ETH in cents, oraclize data smaller than this is not accepted
1589     /// @param _price Price in US cents
1590     function setETHPriceLowerBound(uint _price)
1591         external
1592         onlymanyowners(keccak256(msg.data))
1593     {
1594         m_ETHPriceLowerBound = _price;
1595     }
1596 
1597     /// @notice set the price of ETH in cents, called in case we don't get oraclize data
1598     ///         for more than double the update interval
1599     /// @param _price Price in US cents
1600     function setETHPriceManually(uint _price)
1601         external
1602         onlymanyowners(keccak256(msg.data))
1603     {
1604         // allow for owners to change the price anytime if update is not running
1605         // but if it is, then only in case the price has expired
1606         require( priceExpired() || updateRequestExpired() );
1607         m_ETHPriceInCents = _price;
1608         m_ETHPriceLastUpdate = getTime();
1609         NewETHPrice(m_ETHPriceInCents);
1610     }
1611 
1612     /// @notice add more ether to use in oraclize queries
1613     function topUp() external payable {
1614     }
1615 
1616     /// @dev change gas price for oraclize calls,
1617     ///      should be a compromise between speed and price according to market
1618     /// @param _gasPrice gas price in wei
1619     function setOraclizeGasPrice(uint _gasPrice)
1620         external
1621         onlymanyowners(keccak256(msg.data))
1622     {
1623         oraclize_setCustomGasPrice(_gasPrice);
1624     }
1625 
1626     /// @dev change gas limit for oraclize callback
1627     ///      note: should be changed only in case of emergency
1628     /// @param _callbackGas amount of gas
1629     function setOraclizeGasLimit(uint _callbackGas)
1630         external
1631         onlymanyowners(keccak256(msg.data))
1632     {
1633         m_callbackGas = _callbackGas;
1634     }
1635 
1636     /// @dev Check that double the update interval has passed
1637     ///      since last successful price update
1638     function priceExpired() public view returns (bool) {
1639         return (getTime() > m_ETHPriceLastUpdate + 2 * m_ETHPriceUpdateInterval);
1640     }
1641 
1642     /// @dev Check that price update was requested
1643     ///      more than 1 update interval ago
1644     ///      NOTE: m_leeway seconds added to offset possible timestamp inaccuracy
1645     function updateRequestExpired() public view returns (bool) {
1646         return ( (getTime() + m_leeway) >= (m_ETHPriceLastUpdateRequest + m_ETHPriceUpdateInterval) );
1647     }
1648 
1649     /// @dev to be overridden in tests
1650     function getTime() internal view returns (uint) {
1651         return now;
1652     }
1653 
1654     // FIELDS
1655 
1656     /// @notice usd price of ETH in cents, retrieved using oraclize
1657     uint public m_ETHPriceInCents = 0;
1658     /// @notice unix timestamp of last update
1659     uint public m_ETHPriceLastUpdate;
1660     /// @notice unix timestamp of last update request,
1661     ///         don't allow requesting more than once per update interval
1662     uint public m_ETHPriceLastUpdateRequest;
1663 
1664     /// @notice lower bound of the ETH price in cents
1665     uint public m_ETHPriceLowerBound = 100;
1666     /// @notice upper bound of the ETH price in cents
1667     uint public m_ETHPriceUpperBound = 100000000;
1668 
1669     /// @dev Update ETH price in cents every 12 hours
1670     uint public m_ETHPriceUpdateInterval = 60*60*1;
1671 
1672     /// @dev offset time inaccuracy when checking update expiration date
1673     uint public m_leeway = 900; // 15 minutes is the limit for miners
1674 
1675     /// @dev set just enough gas because the rest is not refunded
1676     uint public m_callbackGas = 200000;
1677 }
1678 
1679 // File: contracts/EthPriceDependentForICO.sol
1680 
1681 contract EthPriceDependentForICO is EthPriceDependent {
1682 
1683     /// @dev overridden price lifetime logic
1684     function priceExpired() public view returns (bool) {
1685         return false;
1686     }
1687 
1688     /// @dev how long before price becomes invalid
1689     uint public m_ETHPriceLifetime = 60*60*12;
1690 }
1691 
1692 // File: contracts/IBoomstarterToken.sol
1693 
1694 /// @title Interface of the BoomstarterToken.
1695 interface IBoomstarterToken {
1696     // multiowned
1697     function changeOwner(address _from, address _to) external;
1698     function addOwner(address _owner) external;
1699     function removeOwner(address _owner) external;
1700     function changeRequirement(uint _newRequired) external;
1701     function getOwner(uint ownerIndex) public view returns (address);
1702     function getOwners() public view returns (address[]);
1703     function isOwner(address _addr) public view returns (bool);
1704     function amIOwner() external view returns (bool);
1705     function revoke(bytes32 _operation) external;
1706     function hasConfirmed(bytes32 _operation, address _owner) external view returns (bool);
1707 
1708     // ERC20Basic
1709     function totalSupply() public view returns (uint256);
1710     function balanceOf(address who) public view returns (uint256);
1711     function transfer(address to, uint256 value) public returns (bool);
1712 
1713     // ERC20
1714     function allowance(address owner, address spender) public view returns (uint256);
1715     function transferFrom(address from, address to, uint256 value) public returns (bool);
1716     function approve(address spender, uint256 value) public returns (bool);
1717 
1718     function name() public view returns (string);
1719     function symbol() public view returns (string);
1720     function decimals() public view returns (uint8);
1721 
1722     // BurnableToken
1723     function burn(uint256 _amount) public returns (bool);
1724 
1725     // TokenWithApproveAndCallMethod
1726     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public;
1727 
1728     // BoomstarterToken
1729     function setSale(address account, bool isSale) external;
1730     function switchToNextSale(address _newSale) external;
1731     function thaw() external;
1732     function disablePrivileged() external;
1733 
1734 }
1735 
1736 // File: mixbytes-solidity/contracts/ownership/MultiownedControlled.sol
1737 
1738 // Copyright (C) 2017  MixBytes, LLC
1739 
1740 // Licensed under the Apache License, Version 2.0 (the "License").
1741 // You may not use this file except in compliance with the License.
1742 
1743 // Unless required by applicable law or agreed to in writing, software
1744 // distributed under the License is distributed on an "AS IS" BASIS,
1745 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
1746 
1747 pragma solidity ^0.4.15;
1748 
1749 
1750 
1751 /**
1752  * @title Contract which is owned by owners and operated by controller.
1753  *
1754  * @notice Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
1755  * Controller is set up by owners or during construction.
1756  *
1757  * @dev controller check is performed by onlyController modifier.
1758  */
1759 contract MultiownedControlled is multiowned {
1760 
1761     event ControllerSet(address controller);
1762     event ControllerRetired(address was);
1763     event ControllerRetiredForever(address was);
1764 
1765 
1766     modifier onlyController {
1767         require(msg.sender == m_controller);
1768         _;
1769     }
1770 
1771 
1772     // PUBLIC interface
1773 
1774     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
1775         public
1776         multiowned(_owners, _signaturesRequired)
1777     {
1778         m_controller = _controller;
1779         ControllerSet(m_controller);
1780     }
1781 
1782     /// @dev sets the controller
1783     function setController(address _controller) external onlymanyowners(keccak256(msg.data)) {
1784         require(m_attaching_enabled);
1785         m_controller = _controller;
1786         ControllerSet(m_controller);
1787     }
1788 
1789     /// @dev ability for controller to step down
1790     function detachController() external onlyController {
1791         address was = m_controller;
1792         m_controller = address(0);
1793         ControllerRetired(was);
1794     }
1795 
1796     /// @dev ability for controller to step down and make this contract completely automatic (without third-party control)
1797     function detachControllerForever() external onlyController {
1798         assert(m_attaching_enabled);
1799         address was = m_controller;
1800         m_controller = address(0);
1801         m_attaching_enabled = false;
1802         ControllerRetiredForever(was);
1803     }
1804 
1805 
1806     // FIELDS
1807 
1808     /// @notice address of entity entitled to mint new tokens
1809     address public m_controller;
1810 
1811     bool public m_attaching_enabled = true;
1812 }
1813 
1814 // File: mixbytes-solidity/contracts/security/ArgumentsChecker.sol
1815 
1816 // Copyright (C) 2017  MixBytes, LLC
1817 
1818 // Licensed under the Apache License, Version 2.0 (the "License").
1819 // You may not use this file except in compliance with the License.
1820 
1821 // Unless required by applicable law or agreed to in writing, software
1822 // distributed under the License is distributed on an "AS IS" BASIS,
1823 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
1824 
1825 pragma solidity ^0.4.15;
1826 
1827 
1828 /// @title utility methods and modifiers of arguments validation
1829 contract ArgumentsChecker {
1830 
1831     /// @dev check which prevents short address attack
1832     modifier payloadSizeIs(uint size) {
1833        require(msg.data.length == size + 4 /* function selector */);
1834        _;
1835     }
1836 
1837     /// @dev check that address is valid
1838     modifier validAddress(address addr) {
1839         require(addr != address(0));
1840         _;
1841     }
1842 }
1843 
1844 // File: zeppelin-solidity/contracts/ReentrancyGuard.sol
1845 
1846 /**
1847  * @title Helps contracts guard agains rentrancy attacks.
1848  * @author Remco Bloemen <remco@2π.com>
1849  * @notice If you mark a function `nonReentrant`, you should also
1850  * mark it `external`.
1851  */
1852 contract ReentrancyGuard {
1853 
1854   /**
1855    * @dev We use a single lock for the whole contract.
1856    */
1857   bool private rentrancy_lock = false;
1858 
1859   /**
1860    * @dev Prevents a contract from calling itself, directly or indirectly.
1861    * @notice If you mark a function `nonReentrant`, you should also
1862    * mark it `external`. Calling one nonReentrant function from
1863    * another is not supported. Instead, you can implement a
1864    * `private` function doing the actual work, and a `external`
1865    * wrapper marked as `nonReentrant`.
1866    */
1867   modifier nonReentrant() {
1868     require(!rentrancy_lock);
1869     rentrancy_lock = true;
1870     _;
1871     rentrancy_lock = false;
1872   }
1873 
1874 }
1875 
1876 // File: contracts/crowdsale/FundsRegistry.sol
1877 
1878 /// @title registry of funds sent by investors
1879 contract FundsRegistry is ArgumentsChecker, MultiownedControlled, ReentrancyGuard {
1880     using SafeMath for uint256;
1881 
1882     enum State {
1883         // gathering funds
1884         GATHERING,
1885         // returning funds to investors
1886         REFUNDING,
1887         // funds can be pulled by owners
1888         SUCCEEDED
1889     }
1890 
1891     event StateChanged(State _state);
1892     event Invested(address indexed investor, uint etherInvested, uint tokensReceived);
1893     event EtherSent(address indexed to, uint value);
1894     event RefundSent(address indexed to, uint value);
1895 
1896 
1897     modifier requiresState(State _state) {
1898         require(m_state == _state);
1899         _;
1900     }
1901 
1902 
1903     // PUBLIC interface
1904 
1905     function FundsRegistry(
1906         address[] _owners,
1907         uint _signaturesRequired,
1908         address _controller,
1909         address _token
1910     )
1911         MultiownedControlled(_owners, _signaturesRequired, _controller)
1912     {
1913         m_token = IBoomstarterToken(_token);
1914     }
1915 
1916     /// @dev performs only allowed state transitions
1917     function changeState(State _newState)
1918         external
1919         onlyController
1920     {
1921         assert(m_state != _newState);
1922 
1923         if (State.GATHERING == m_state) {   assert(State.REFUNDING == _newState || State.SUCCEEDED == _newState); }
1924         else assert(false);
1925 
1926         m_state = _newState;
1927         StateChanged(m_state);
1928     }
1929 
1930     /// @dev records an investment
1931     /// @param _investor who invested
1932     /// @param _tokenAmount the amount of token bought, calculation is handled by ICO
1933     function invested(address _investor, uint _tokenAmount)
1934         external
1935         payable
1936         onlyController
1937         requiresState(State.GATHERING)
1938     {
1939         uint256 amount = msg.value;
1940         require(0 != amount);
1941         assert(_investor != m_controller);
1942 
1943         // register investor
1944         if (0 == m_weiBalances[_investor])
1945             m_investors.push(_investor);
1946 
1947         // register payment
1948         totalInvested = totalInvested.add(amount);
1949         m_weiBalances[_investor] = m_weiBalances[_investor].add(amount);
1950         m_tokenBalances[_investor] = m_tokenBalances[_investor].add(_tokenAmount);
1951 
1952         Invested(_investor, amount, _tokenAmount);
1953     }
1954 
1955     /// @notice owners: send `value` of ether to address `to`, can be called if crowdsale succeeded
1956     /// @param to where to send ether
1957     /// @param value amount of wei to send
1958     function sendEther(address to, uint value)
1959         external
1960         validAddress(to)
1961         onlymanyowners(keccak256(msg.data))
1962         requiresState(State.SUCCEEDED)
1963     {
1964         require(value > 0 && this.balance >= value);
1965         to.transfer(value);
1966         EtherSent(to, value);
1967     }
1968 
1969     /// @notice owners: send `value` of tokens to address `to`, can be called if
1970     ///         crowdsale failed and some of the investors refunded the ether
1971     /// @param to where to send tokens
1972     /// @param value amount of token-wei to send
1973     function sendTokens(address to, uint value)
1974         external
1975         validAddress(to)
1976         onlymanyowners(keccak256(msg.data))
1977         requiresState(State.REFUNDING)
1978     {
1979         require(value > 0 && m_token.balanceOf(this) >= value);
1980         m_token.transfer(to, value);
1981     }
1982 
1983     /// @notice withdraw accumulated balance, called by payee in case crowdsale failed
1984     /// @dev caller should approve tokens bought during ICO to this contract
1985     function withdrawPayments()
1986         external
1987         nonReentrant
1988         requiresState(State.REFUNDING)
1989     {
1990         address payee = msg.sender;
1991         uint payment = m_weiBalances[payee];
1992         uint tokens = m_tokenBalances[payee];
1993 
1994         // check that there is some ether to withdraw
1995         require(payment != 0);
1996         // check that the contract holds enough ether
1997         require(this.balance >= payment);
1998         // check that the investor (payee) gives back all tokens bought during ICO
1999         require(m_token.allowance(payee, this) >= m_tokenBalances[payee]);
2000 
2001         totalInvested = totalInvested.sub(payment);
2002         m_weiBalances[payee] = 0;
2003         m_tokenBalances[payee] = 0;
2004 
2005         m_token.transferFrom(payee, this, tokens);
2006 
2007         payee.transfer(payment);
2008         RefundSent(payee, payment);
2009     }
2010 
2011     function getInvestorsCount() external constant returns (uint) { return m_investors.length; }
2012 
2013     // FIELDS
2014 
2015     /// @notice total amount of investments in wei
2016     uint256 public totalInvested;
2017 
2018     /// @notice state of the registry
2019     State public m_state = State.GATHERING;
2020 
2021     /// @dev balances of investors in wei
2022     mapping(address => uint256) public m_weiBalances;
2023 
2024     /// @dev balances of tokens sold to investors
2025     mapping(address => uint256) public m_tokenBalances;
2026 
2027     /// @dev list of unique investors
2028     address[] public m_investors;
2029 
2030     /// @dev token accepted for refunds
2031     IBoomstarterToken public m_token;
2032 }
2033 
2034 // File: contracts/BoomstarterICO.sol
2035 
2036 /// @title Boomstarter ICO contract
2037 contract BoomstarterICO is ArgumentsChecker, ReentrancyGuard, EthPriceDependentForICO, IICOInfo, IMintableToken {
2038 
2039     enum IcoState { INIT, ACTIVE, PAUSED, FAILED, SUCCEEDED }
2040 
2041     event StateChanged(IcoState _state);
2042     event FundTransfer(address backer, uint amount, bool isContribution);
2043 
2044 
2045     modifier requiresState(IcoState _state) {
2046         require(m_state == _state);
2047         _;
2048     }
2049 
2050     /// @dev triggers some state changes based on current time
2051     /// @param client optional refund parameter
2052     /// @param payment optional refund parameter
2053     /// @param refundable - if false, payment is made off-chain and shouldn't be refunded
2054     /// note: function body could be skipped!
2055     modifier timedStateChange(address client, uint payment, bool refundable) {
2056         if (IcoState.INIT == m_state && getTime() >= getStartTime())
2057             changeState(IcoState.ACTIVE);
2058 
2059         if (IcoState.ACTIVE == m_state && getTime() >= getFinishTime()) {
2060             finishICO();
2061 
2062             if (refundable && payment > 0)
2063                 client.transfer(payment);
2064             // note that execution of further (but not preceding!) modifiers and functions ends here
2065         } else {
2066             _;
2067         }
2068     }
2069 
2070     /// @dev automatic check for unaccounted withdrawals
2071     /// @param client optional refund parameter
2072     /// @param payment optional refund parameter
2073     /// @param refundable - if false, payment is made off-chain and shouldn't be refunded
2074     modifier fundsChecker(address client, uint payment, bool refundable) {
2075         uint atTheBeginning = m_funds.balance;
2076         if (atTheBeginning < m_lastFundsAmount) {
2077             changeState(IcoState.PAUSED);
2078             if (refundable && payment > 0)
2079                 client.transfer(payment);     // we cant throw (have to save state), so refunding this way
2080             // note that execution of further (but not preceding!) modifiers and functions ends here
2081         } else {
2082             _;
2083 
2084             if (m_funds.balance < atTheBeginning) {
2085                 changeState(IcoState.PAUSED);
2086             } else {
2087                 m_lastFundsAmount = m_funds.balance;
2088             }
2089         }
2090     }
2091 
2092     function estimate(uint256 _wei) public view returns (uint tokens) {
2093         uint amount;
2094         (amount, ) = estimateTokensWithActualPayment(_wei);
2095         return amount;
2096     }
2097 
2098     function isSaleActive() public view returns (bool active) {
2099         return m_state == IcoState.ACTIVE && !priceExpired();
2100     }
2101 
2102     function purchasedTokenBalanceOf(address addr) public view returns (uint256 tokens) {
2103         return m_token.balanceOf(addr);
2104     }
2105 
2106     function estimateTokensWithActualPayment(uint256 _payment) public view returns (uint amount, uint actualPayment) {
2107         // amount of bought tokens
2108         uint tokens = _payment.mul(m_ETHPriceInCents).div(getPrice());
2109 
2110         if (tokens.add(m_currentTokensSold) > c_maximumTokensSold) {
2111             tokens = c_maximumTokensSold.sub( m_currentTokensSold );
2112             _payment = getPrice().mul(tokens).div(m_ETHPriceInCents);
2113         }
2114 
2115         // calculating a 20% bonus if the price of bought tokens is more than $50k
2116         if (_payment.mul(m_ETHPriceInCents).div(1 ether) >= 5000000) {
2117             tokens = tokens.add(tokens.div(5));
2118             // for ICO, bonus cannot exceed hard cap
2119             if (tokens.add(m_currentTokensSold) > c_maximumTokensSold) {
2120                 tokens = c_maximumTokensSold.sub(m_currentTokensSold);
2121             }
2122         }
2123 
2124         return (tokens, _payment);
2125     }
2126 
2127 
2128     // PUBLIC interface
2129 
2130     /**
2131      * @dev constructor
2132      * @param _owners addresses to do administrative actions
2133      * @param _token address of token being sold
2134      * @param _updateInterval time between oraclize price updates in seconds
2135      * @param _production false if using testrpc/ganache, true otherwise
2136      */
2137     function BoomstarterICO(
2138         address[] _owners,
2139         address _token,
2140         uint _updateInterval,
2141         bool _production
2142     )
2143         public
2144         payable
2145         EthPriceDependent(_owners, 2, _production)
2146         validAddress(_token)
2147     {
2148         require(3 == _owners.length);
2149 
2150         m_token = IBoomstarterToken(_token);
2151         m_deployer = msg.sender;
2152         m_ETHPriceUpdateInterval = _updateInterval;
2153         oraclize_setCustomGasPrice(40000000);
2154     }
2155 
2156     /// @dev set addresses for ether and token storage
2157     ///      performed once by deployer
2158     /// @param _funds FundsRegistry address
2159     /// @param _tokenDistributor address to send remaining tokens to after ICO
2160     /// @param _previouslySold how much sold in previous sales in cents
2161     function init(address _funds, address _tokenDistributor, uint _previouslySold)
2162         external
2163         validAddress(_funds)
2164         validAddress(_tokenDistributor)
2165         onlymanyowners(keccak256(msg.data))
2166     {
2167         // can be set only once
2168         require(m_funds == address(0));
2169         m_funds = FundsRegistry(_funds);
2170 
2171         // calculate remaining tokens and leave 25% for manual allocation
2172         c_maximumTokensSold = m_token.balanceOf(this).sub( m_token.totalSupply().div(4) );
2173 
2174         // manually set how much should be sold taking into account previously collected
2175         if (_previouslySold < c_softCapUsd)
2176             c_softCapUsd = c_softCapUsd.sub(_previouslySold);
2177         else
2178             c_softCapUsd = 0;
2179 
2180         // set account that allocates the rest of tokens after ico succeeds
2181         m_tokenDistributor = _tokenDistributor;
2182     }
2183 
2184 
2185     // PUBLIC interface: payments
2186 
2187     // fallback function as a shortcut
2188     function() payable {
2189         require(0 == msg.data.length);
2190         buy();  // only internal call here!
2191     }
2192 
2193     /// @notice ICO participation
2194     function buy() public payable {     // dont mark as external!
2195         internalBuy(msg.sender, msg.value, true);
2196     }
2197 
2198     function mint(address client, uint256 ethers) public {
2199         nonEtherBuy(client, ethers);
2200     }
2201 
2202 
2203     /// @notice register investments coming in different currencies
2204     /// @dev can only be called by a special controller account
2205     /// @param client Account to send tokens to
2206     /// @param etherEquivalentAmount Amount of ether to use to calculate token amount
2207     function nonEtherBuy(address client, uint etherEquivalentAmount)
2208         public
2209     {
2210         require(msg.sender == m_nonEtherController);
2211         // just to check for input errors
2212         require(etherEquivalentAmount <= 70000 ether);
2213         internalBuy(client, etherEquivalentAmount, false);
2214     }
2215 
2216     /// @dev common buy for ether and non-ether
2217     /// @param client who invests
2218     /// @param payment how much ether
2219     /// @param refundable true if invested in ether - using buy()
2220     function internalBuy(address client, uint payment, bool refundable)
2221         internal
2222         nonReentrant
2223         timedStateChange(client, payment, refundable)
2224         fundsChecker(client, payment, refundable)
2225     {
2226         // don't allow to buy anything if price change was too long ago
2227         // effectively enforcing a sale pause
2228         require( !priceExpired() );
2229         require(m_state == IcoState.ACTIVE || m_state == IcoState.INIT && isOwner(client) /* for final test */);
2230 
2231         require((payment.mul(m_ETHPriceInCents)).div(1 ether) >= c_MinInvestmentInCents);
2232 
2233 
2234         uint actualPayment = payment;
2235         uint amount;
2236 
2237         (amount, actualPayment) = estimateTokensWithActualPayment(payment);
2238 
2239 
2240         // change ICO investment stats
2241         m_currentUsdAccepted = m_currentUsdAccepted.add( actualPayment.mul(m_ETHPriceInCents).div(1 ether) );
2242         m_currentTokensSold = m_currentTokensSold.add( amount );
2243 
2244         // send bought tokens to the client
2245         m_token.transfer(client, amount);
2246 
2247         assert(m_currentTokensSold <= c_maximumTokensSold);
2248 
2249         if (refundable) {
2250             // record payment if paid in ether
2251             m_funds.invested.value(actualPayment)(client, amount);
2252             FundTransfer(client, actualPayment, true);
2253         }
2254 
2255         // check if ICO must be closed early
2256         if (payment.sub(actualPayment) > 0) {
2257             assert(c_maximumTokensSold == m_currentTokensSold);
2258             finishICO();
2259 
2260             // send change
2261             client.transfer(payment.sub(actualPayment));
2262         } else if (c_maximumTokensSold == m_currentTokensSold) {
2263             finishICO();
2264         }
2265     }
2266 
2267 
2268     // PUBLIC interface: misc getters
2269 
2270     /// @notice get token price in cents depending on the current date
2271     function getPrice() public view returns (uint) {
2272         // skip finish date, start from the date of maximum price
2273         for (uint i = c_priceChangeDates.length - 2; i > 0; i--) {
2274             if (getTime() >= c_priceChangeDates[i]) {
2275               return c_tokenPrices[i];
2276             }
2277         }
2278         // default price is the cheapest, used for the initial test as well
2279         return c_tokenPrices[0];
2280     }
2281 
2282     /// @notice start time of the ICO
2283     function getStartTime() public view returns (uint) {
2284         return c_priceChangeDates[0];
2285     }
2286 
2287     /// @notice finish time of the ICO
2288     function getFinishTime() public view returns (uint) {
2289         return c_priceChangeDates[c_priceChangeDates.length - 1];
2290     }
2291 
2292 
2293     // PUBLIC interface: owners: maintenance
2294 
2295     /// @notice pauses ICO
2296     function pause()
2297         external
2298         timedStateChange(address(0), 0, true)
2299         requiresState(IcoState.ACTIVE)
2300         onlyowner
2301     {
2302         changeState(IcoState.PAUSED);
2303     }
2304 
2305     /// @notice resume paused ICO
2306     function unpause()
2307         external
2308         timedStateChange(address(0), 0, true)
2309         requiresState(IcoState.PAUSED)
2310         onlymanyowners(keccak256(msg.data))
2311     {
2312         changeState(IcoState.ACTIVE);
2313         checkTime();
2314     }
2315 
2316     /// @notice withdraw tokens if ico failed
2317     /// @param _to address to send tokens to
2318     /// @param _amount amount of tokens in token-wei
2319     function withdrawTokens(address _to, uint _amount)
2320         external
2321         validAddress(_to)
2322         requiresState(IcoState.FAILED)
2323         onlymanyowners(keccak256(msg.data))
2324     {
2325         require((_amount > 0) && (m_token.balanceOf(this) >= _amount));
2326         m_token.transfer(_to, _amount);
2327     }
2328 
2329     /// @notice In case we need to attach to existent funds
2330     function setFundsRegistry(address _funds)
2331         external
2332         validAddress(_funds)
2333         timedStateChange(address(0), 0, true)
2334         requiresState(IcoState.PAUSED)
2335         onlymanyowners(keccak256(msg.data))
2336     {
2337         m_funds = FundsRegistry(_funds);
2338     }
2339 
2340     /// @notice set non ether investment controller
2341     function setNonEtherController(address _controller)
2342         external
2343         validAddress(_controller)
2344         timedStateChange(address(0), 0, true)
2345         onlymanyowners(keccak256(msg.data))
2346     {
2347         m_nonEtherController = _controller;
2348     }
2349 
2350     function getNonEtherController()
2351         public
2352         view
2353         returns (address)
2354     {
2355         return m_nonEtherController;
2356     }
2357 
2358     /// @notice explicit trigger for timed state changes
2359     function checkTime()
2360         public
2361         timedStateChange(address(0), 0, true)
2362         onlyowner
2363     {
2364     }
2365 
2366     /// @notice send everything to the new (fixed) ico smart contract
2367     /// @param newICO address of the new smart contract
2368     function applyHotFix(address newICO)
2369         public
2370         validAddress(newICO)
2371         requiresState(IcoState.PAUSED)
2372         onlymanyowners(keccak256(msg.data))
2373     {
2374         EthPriceDependent next = EthPriceDependent(newICO);
2375         next.topUp.value(this.balance)();
2376         m_token.transfer(newICO, m_token.balanceOf(this));
2377     }
2378 
2379     /// @notice withdraw all ether for oraclize payments
2380     /// @param to Address to send ether to
2381     function withdrawEther(address to)
2382         public
2383         validAddress(to)
2384         onlymanyowners(keccak256(msg.data))
2385     {
2386         to.transfer(this.balance);
2387     }
2388 
2389 
2390     // INTERNAL functions
2391 
2392     function finishICO() private {
2393         if (m_currentUsdAccepted < c_softCapUsd) {
2394             changeState(IcoState.FAILED);
2395         } else {
2396             changeState(IcoState.SUCCEEDED);
2397         }
2398     }
2399 
2400     /// @dev performs only allowed state transitions
2401     function changeState(IcoState _newState) private {
2402         assert(m_state != _newState);
2403 
2404         if (IcoState.INIT == m_state) {
2405             assert(IcoState.ACTIVE == _newState);
2406         } else if (IcoState.ACTIVE == m_state) {
2407             assert(
2408                 IcoState.PAUSED == _newState ||
2409                 IcoState.FAILED == _newState ||
2410                 IcoState.SUCCEEDED == _newState
2411             );
2412         } else if (IcoState.PAUSED == m_state) {
2413             assert(IcoState.ACTIVE == _newState || IcoState.FAILED == _newState);
2414         } else {
2415             assert(false);
2416         }
2417 
2418         m_state = _newState;
2419         StateChanged(m_state);
2420 
2421         // this should be tightly linked
2422         if (IcoState.SUCCEEDED == m_state) {
2423             onSuccess();
2424         } else if (IcoState.FAILED == m_state) {
2425             onFailure();
2426         }
2427     }
2428 
2429     function onSuccess() private {
2430         // allow owners to withdraw collected ether
2431         m_funds.changeState(FundsRegistry.State.SUCCEEDED);
2432         m_funds.detachController();
2433 
2434         // send all remaining tokens to the address responsible for dividing them into pools
2435         m_token.transfer(m_tokenDistributor, m_token.balanceOf(this));
2436     }
2437 
2438     function onFailure() private {
2439         // allow clients to get their ether back
2440         m_funds.changeState(FundsRegistry.State.REFUNDING);
2441         m_funds.detachController();
2442     }
2443 
2444 
2445     // FIELDS
2446 
2447     /// @notice points in time when token price grows
2448     ///         first one is the start time of sale
2449     ///         last one is the end of sale
2450     uint[] public c_priceChangeDates = [
2451         getTime(),  // deployment date: $0.8
2452         1534107600, // August 13th 2018, 00:00:00 (GMT +3): $1
2453         1534712400, // August 20th 2018, 00:00:00 (GMT +3): $1.2
2454         1535317200, // August 27th 2018, 00:00:00 (GMT +3): $1.4
2455         1535922000, // September 3rd 2018, 00:00:00 (GMT +3): $1.6
2456         1536526800, // September 10th 2018, 00:00:00 (GMT +3): $1.8
2457         1537131600, // September 17th 2018, 00:00:00 (GMT +3): $2
2458         1538341199  // finish: September 30th 2018, 23:59:59 (GMT +3)
2459     ];
2460 
2461     /// @notice token prices in cents during different time periods
2462     ///         starts of the time periods described in c_priceChangeDates
2463     uint[] public c_tokenPrices = [
2464         80,  // $0.8
2465         100, // $1
2466         120, // $1.2
2467         140, // $1.4
2468         160, // $1.6
2469         180, // $1.8
2470         200  // $2
2471     ];
2472 
2473     /// @dev state of the ICO
2474     IcoState public m_state = IcoState.INIT;
2475 
2476     /// @dev contract responsible for token accounting
2477     IBoomstarterToken public m_token;
2478 
2479     /// @dev address responsile for allocation of the tokens left if ICO succeeds
2480     address public m_tokenDistributor;
2481 
2482     /// @dev contract responsible for investments accounting
2483     FundsRegistry public m_funds;
2484 
2485     /// @dev account handling investments in different currencies
2486     address public m_nonEtherController;
2487 
2488     /// @dev last recorded funds
2489     uint public m_lastFundsAmount;
2490 
2491     /// @notice minimum investment in cents
2492     uint public c_MinInvestmentInCents = 500; // $5
2493 
2494     /// @notice current amount of tokens sold
2495     uint public m_currentTokensSold;
2496 
2497     /// @dev limit of tokens to be sold during ICO, need to leave 25% for the team
2498     ///      calculated from the current balance and the total supply
2499     uint public c_maximumTokensSold;
2500 
2501     /// @dev current usd accepted during ICO, in cents
2502     uint public m_currentUsdAccepted;
2503 
2504     /// @dev limit of usd to be accepted during ICO, in cents
2505     uint public c_softCapUsd = 300000000; // $3000000
2506 
2507     /// @dev save deployer for easier initialization
2508     address public m_deployer;
2509 
2510 }