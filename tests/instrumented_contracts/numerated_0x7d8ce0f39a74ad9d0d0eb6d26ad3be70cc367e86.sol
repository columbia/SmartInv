1 pragma solidity ^0.4.23;
2 
3 // File: installed_contracts/oraclize-api/contracts/usingOraclize.sol
4 
5 // <ORACLIZE_API>
6 /*
7 Copyright (c) 2015-2016 Oraclize SRL
8 Copyright (c) 2016 Oraclize LTD
9 
10 
11 
12 Permission is hereby granted, free of charge, to any person obtaining a copy
13 of this software and associated documentation files (the "Software"), to deal
14 in the Software without restriction, including without limitation the rights
15 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16 copies of the Software, and to permit persons to whom the Software is
17 furnished to do so, subject to the following conditions:
18 
19 
20 
21 The above copyright notice and this permission notice shall be included in
22 all copies or substantial portions of the Software.
23 
24 
25 
26 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
29 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
32 THE SOFTWARE.
33 */
34 
35 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
36 pragma solidity ^0.4.18;
37 
38 contract OraclizeI {
39     address public cbAddress;
40     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
41     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
42     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
43     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
44     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
45     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
46     function getPrice(string _datasource) public returns (uint _dsprice);
47     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
48     function setProofType(byte _proofType) external;
49     function setCustomGasPrice(uint _gasPrice) external;
50     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
51 }
52 contract OraclizeAddrResolverI {
53     function getAddress() public returns (address _addr);
54 }
55 contract usingOraclize {
56     uint constant day = 60*60*24;
57     uint constant week = 60*60*24*7;
58     uint constant month = 60*60*24*30;
59     byte constant proofType_NONE = 0x00;
60     byte constant proofType_TLSNotary = 0x10;
61     byte constant proofType_Android = 0x20;
62     byte constant proofType_Ledger = 0x30;
63     byte constant proofType_Native = 0xF0;
64     byte constant proofStorage_IPFS = 0x01;
65     uint8 constant networkID_auto = 0;
66     uint8 constant networkID_mainnet = 1;
67     uint8 constant networkID_testnet = 2;
68     uint8 constant networkID_morden = 2;
69     uint8 constant networkID_consensys = 161;
70 
71     OraclizeAddrResolverI OAR;
72 
73     OraclizeI oraclize;
74     modifier oraclizeAPI {
75         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
76             oraclize_setNetwork(networkID_auto);
77 
78         if(address(oraclize) != OAR.getAddress())
79             oraclize = OraclizeI(OAR.getAddress());
80 
81         _;
82     }
83     modifier coupon(string code){
84         oraclize = OraclizeI(OAR.getAddress());
85         _;
86     }
87 
88     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
89       return oraclize_setNetwork();
90       networkID; // silence the warning and remain backwards compatible
91     }
92     function oraclize_setNetwork() internal returns(bool){
93         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
94             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
95             oraclize_setNetworkName("eth_mainnet");
96             return true;
97         }
98         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
99             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
100             oraclize_setNetworkName("eth_ropsten3");
101             return true;
102         }
103         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
104             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
105             oraclize_setNetworkName("eth_kovan");
106             return true;
107         }
108         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
109             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
110             oraclize_setNetworkName("eth_rinkeby");
111             return true;
112         }
113         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
114             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
115             return true;
116         }
117         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
118             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
119             return true;
120         }
121         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
122             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
123             return true;
124         }
125         return false;
126     }
127 
128     function __callback(bytes32 myid, string result) public {
129         __callback(myid, result, new bytes(0));
130     }
131     function __callback(bytes32 myid, string result, bytes proof) public {
132       return;
133       myid; result; proof; // Silence compiler warnings
134     }
135 
136     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
137         return oraclize.getPrice(datasource);
138     }
139 
140     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
141         return oraclize.getPrice(datasource, gaslimit);
142     }
143 
144     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
145         uint price = oraclize.getPrice(datasource);
146         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
147         return oraclize.query.value(price)(0, datasource, arg);
148     }
149     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
150         uint price = oraclize.getPrice(datasource);
151         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
152         return oraclize.query.value(price)(timestamp, datasource, arg);
153     }
154     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
155         uint price = oraclize.getPrice(datasource, gaslimit);
156         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
157         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
158     }
159     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
160         uint price = oraclize.getPrice(datasource, gaslimit);
161         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
162         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
163     }
164     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
165         uint price = oraclize.getPrice(datasource);
166         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
167         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
168     }
169     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
170         uint price = oraclize.getPrice(datasource);
171         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
172         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
173     }
174     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
175         uint price = oraclize.getPrice(datasource, gaslimit);
176         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
177         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
178     }
179     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
180         uint price = oraclize.getPrice(datasource, gaslimit);
181         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
182         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
183     }
184     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
185         uint price = oraclize.getPrice(datasource);
186         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
187         bytes memory args = stra2cbor(argN);
188         return oraclize.queryN.value(price)(0, datasource, args);
189     }
190     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
191         uint price = oraclize.getPrice(datasource);
192         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
193         bytes memory args = stra2cbor(argN);
194         return oraclize.queryN.value(price)(timestamp, datasource, args);
195     }
196     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
197         uint price = oraclize.getPrice(datasource, gaslimit);
198         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
199         bytes memory args = stra2cbor(argN);
200         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
201     }
202     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
203         uint price = oraclize.getPrice(datasource, gaslimit);
204         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
205         bytes memory args = stra2cbor(argN);
206         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
207     }
208     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
209         string[] memory dynargs = new string[](1);
210         dynargs[0] = args[0];
211         return oraclize_query(datasource, dynargs);
212     }
213     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
214         string[] memory dynargs = new string[](1);
215         dynargs[0] = args[0];
216         return oraclize_query(timestamp, datasource, dynargs);
217     }
218     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
219         string[] memory dynargs = new string[](1);
220         dynargs[0] = args[0];
221         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
222     }
223     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
224         string[] memory dynargs = new string[](1);
225         dynargs[0] = args[0];
226         return oraclize_query(datasource, dynargs, gaslimit);
227     }
228 
229     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
230         string[] memory dynargs = new string[](2);
231         dynargs[0] = args[0];
232         dynargs[1] = args[1];
233         return oraclize_query(datasource, dynargs);
234     }
235     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
236         string[] memory dynargs = new string[](2);
237         dynargs[0] = args[0];
238         dynargs[1] = args[1];
239         return oraclize_query(timestamp, datasource, dynargs);
240     }
241     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
242         string[] memory dynargs = new string[](2);
243         dynargs[0] = args[0];
244         dynargs[1] = args[1];
245         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
246     }
247     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
248         string[] memory dynargs = new string[](2);
249         dynargs[0] = args[0];
250         dynargs[1] = args[1];
251         return oraclize_query(datasource, dynargs, gaslimit);
252     }
253     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
254         string[] memory dynargs = new string[](3);
255         dynargs[0] = args[0];
256         dynargs[1] = args[1];
257         dynargs[2] = args[2];
258         return oraclize_query(datasource, dynargs);
259     }
260     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
261         string[] memory dynargs = new string[](3);
262         dynargs[0] = args[0];
263         dynargs[1] = args[1];
264         dynargs[2] = args[2];
265         return oraclize_query(timestamp, datasource, dynargs);
266     }
267     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
268         string[] memory dynargs = new string[](3);
269         dynargs[0] = args[0];
270         dynargs[1] = args[1];
271         dynargs[2] = args[2];
272         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
273     }
274     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
275         string[] memory dynargs = new string[](3);
276         dynargs[0] = args[0];
277         dynargs[1] = args[1];
278         dynargs[2] = args[2];
279         return oraclize_query(datasource, dynargs, gaslimit);
280     }
281 
282     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
283         string[] memory dynargs = new string[](4);
284         dynargs[0] = args[0];
285         dynargs[1] = args[1];
286         dynargs[2] = args[2];
287         dynargs[3] = args[3];
288         return oraclize_query(datasource, dynargs);
289     }
290     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
291         string[] memory dynargs = new string[](4);
292         dynargs[0] = args[0];
293         dynargs[1] = args[1];
294         dynargs[2] = args[2];
295         dynargs[3] = args[3];
296         return oraclize_query(timestamp, datasource, dynargs);
297     }
298     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
299         string[] memory dynargs = new string[](4);
300         dynargs[0] = args[0];
301         dynargs[1] = args[1];
302         dynargs[2] = args[2];
303         dynargs[3] = args[3];
304         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
305     }
306     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
307         string[] memory dynargs = new string[](4);
308         dynargs[0] = args[0];
309         dynargs[1] = args[1];
310         dynargs[2] = args[2];
311         dynargs[3] = args[3];
312         return oraclize_query(datasource, dynargs, gaslimit);
313     }
314     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
315         string[] memory dynargs = new string[](5);
316         dynargs[0] = args[0];
317         dynargs[1] = args[1];
318         dynargs[2] = args[2];
319         dynargs[3] = args[3];
320         dynargs[4] = args[4];
321         return oraclize_query(datasource, dynargs);
322     }
323     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
324         string[] memory dynargs = new string[](5);
325         dynargs[0] = args[0];
326         dynargs[1] = args[1];
327         dynargs[2] = args[2];
328         dynargs[3] = args[3];
329         dynargs[4] = args[4];
330         return oraclize_query(timestamp, datasource, dynargs);
331     }
332     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
333         string[] memory dynargs = new string[](5);
334         dynargs[0] = args[0];
335         dynargs[1] = args[1];
336         dynargs[2] = args[2];
337         dynargs[3] = args[3];
338         dynargs[4] = args[4];
339         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
340     }
341     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
342         string[] memory dynargs = new string[](5);
343         dynargs[0] = args[0];
344         dynargs[1] = args[1];
345         dynargs[2] = args[2];
346         dynargs[3] = args[3];
347         dynargs[4] = args[4];
348         return oraclize_query(datasource, dynargs, gaslimit);
349     }
350     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
351         uint price = oraclize.getPrice(datasource);
352         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
353         bytes memory args = ba2cbor(argN);
354         return oraclize.queryN.value(price)(0, datasource, args);
355     }
356     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
357         uint price = oraclize.getPrice(datasource);
358         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
359         bytes memory args = ba2cbor(argN);
360         return oraclize.queryN.value(price)(timestamp, datasource, args);
361     }
362     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
363         uint price = oraclize.getPrice(datasource, gaslimit);
364         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
365         bytes memory args = ba2cbor(argN);
366         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
367     }
368     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
369         uint price = oraclize.getPrice(datasource, gaslimit);
370         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
371         bytes memory args = ba2cbor(argN);
372         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
373     }
374     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
375         bytes[] memory dynargs = new bytes[](1);
376         dynargs[0] = args[0];
377         return oraclize_query(datasource, dynargs);
378     }
379     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
380         bytes[] memory dynargs = new bytes[](1);
381         dynargs[0] = args[0];
382         return oraclize_query(timestamp, datasource, dynargs);
383     }
384     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
385         bytes[] memory dynargs = new bytes[](1);
386         dynargs[0] = args[0];
387         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
388     }
389     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
390         bytes[] memory dynargs = new bytes[](1);
391         dynargs[0] = args[0];
392         return oraclize_query(datasource, dynargs, gaslimit);
393     }
394 
395     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
396         bytes[] memory dynargs = new bytes[](2);
397         dynargs[0] = args[0];
398         dynargs[1] = args[1];
399         return oraclize_query(datasource, dynargs);
400     }
401     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
402         bytes[] memory dynargs = new bytes[](2);
403         dynargs[0] = args[0];
404         dynargs[1] = args[1];
405         return oraclize_query(timestamp, datasource, dynargs);
406     }
407     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
408         bytes[] memory dynargs = new bytes[](2);
409         dynargs[0] = args[0];
410         dynargs[1] = args[1];
411         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
412     }
413     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
414         bytes[] memory dynargs = new bytes[](2);
415         dynargs[0] = args[0];
416         dynargs[1] = args[1];
417         return oraclize_query(datasource, dynargs, gaslimit);
418     }
419     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
420         bytes[] memory dynargs = new bytes[](3);
421         dynargs[0] = args[0];
422         dynargs[1] = args[1];
423         dynargs[2] = args[2];
424         return oraclize_query(datasource, dynargs);
425     }
426     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
427         bytes[] memory dynargs = new bytes[](3);
428         dynargs[0] = args[0];
429         dynargs[1] = args[1];
430         dynargs[2] = args[2];
431         return oraclize_query(timestamp, datasource, dynargs);
432     }
433     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
434         bytes[] memory dynargs = new bytes[](3);
435         dynargs[0] = args[0];
436         dynargs[1] = args[1];
437         dynargs[2] = args[2];
438         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
439     }
440     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441         bytes[] memory dynargs = new bytes[](3);
442         dynargs[0] = args[0];
443         dynargs[1] = args[1];
444         dynargs[2] = args[2];
445         return oraclize_query(datasource, dynargs, gaslimit);
446     }
447 
448     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
449         bytes[] memory dynargs = new bytes[](4);
450         dynargs[0] = args[0];
451         dynargs[1] = args[1];
452         dynargs[2] = args[2];
453         dynargs[3] = args[3];
454         return oraclize_query(datasource, dynargs);
455     }
456     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
457         bytes[] memory dynargs = new bytes[](4);
458         dynargs[0] = args[0];
459         dynargs[1] = args[1];
460         dynargs[2] = args[2];
461         dynargs[3] = args[3];
462         return oraclize_query(timestamp, datasource, dynargs);
463     }
464     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
465         bytes[] memory dynargs = new bytes[](4);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         dynargs[2] = args[2];
469         dynargs[3] = args[3];
470         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
471     }
472     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
473         bytes[] memory dynargs = new bytes[](4);
474         dynargs[0] = args[0];
475         dynargs[1] = args[1];
476         dynargs[2] = args[2];
477         dynargs[3] = args[3];
478         return oraclize_query(datasource, dynargs, gaslimit);
479     }
480     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
481         bytes[] memory dynargs = new bytes[](5);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         dynargs[2] = args[2];
485         dynargs[3] = args[3];
486         dynargs[4] = args[4];
487         return oraclize_query(datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
490         bytes[] memory dynargs = new bytes[](5);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         dynargs[2] = args[2];
494         dynargs[3] = args[3];
495         dynargs[4] = args[4];
496         return oraclize_query(timestamp, datasource, dynargs);
497     }
498     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
499         bytes[] memory dynargs = new bytes[](5);
500         dynargs[0] = args[0];
501         dynargs[1] = args[1];
502         dynargs[2] = args[2];
503         dynargs[3] = args[3];
504         dynargs[4] = args[4];
505         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
506     }
507     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
508         bytes[] memory dynargs = new bytes[](5);
509         dynargs[0] = args[0];
510         dynargs[1] = args[1];
511         dynargs[2] = args[2];
512         dynargs[3] = args[3];
513         dynargs[4] = args[4];
514         return oraclize_query(datasource, dynargs, gaslimit);
515     }
516 
517     function oraclize_cbAddress() oraclizeAPI internal returns (address){
518         return oraclize.cbAddress();
519     }
520     function oraclize_setProof(byte proofP) oraclizeAPI internal {
521         return oraclize.setProofType(proofP);
522     }
523     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
524         return oraclize.setCustomGasPrice(gasPrice);
525     }
526 
527     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
528         return oraclize.randomDS_getSessionPubKeyHash();
529     }
530 
531     function getCodeSize(address _addr) constant internal returns(uint _size) {
532         assembly {
533             _size := extcodesize(_addr)
534         }
535     }
536 
537     function parseAddr(string _a) internal pure returns (address){
538         bytes memory tmp = bytes(_a);
539         uint160 iaddr = 0;
540         uint160 b1;
541         uint160 b2;
542         for (uint i=2; i<2+2*20; i+=2){
543             iaddr *= 256;
544             b1 = uint160(tmp[i]);
545             b2 = uint160(tmp[i+1]);
546             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
547             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
548             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
549             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
550             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
551             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
552             iaddr += (b1*16+b2);
553         }
554         return address(iaddr);
555     }
556 
557     function strCompare(string _a, string _b) internal pure returns (int) {
558         bytes memory a = bytes(_a);
559         bytes memory b = bytes(_b);
560         uint minLength = a.length;
561         if (b.length < minLength) minLength = b.length;
562         for (uint i = 0; i < minLength; i ++)
563             if (a[i] < b[i])
564                 return -1;
565             else if (a[i] > b[i])
566                 return 1;
567         if (a.length < b.length)
568             return -1;
569         else if (a.length > b.length)
570             return 1;
571         else
572             return 0;
573     }
574 
575     function indexOf(string _haystack, string _needle) internal pure returns (int) {
576         bytes memory h = bytes(_haystack);
577         bytes memory n = bytes(_needle);
578         if(h.length < 1 || n.length < 1 || (n.length > h.length))
579             return -1;
580         else if(h.length > (2**128 -1))
581             return -1;
582         else
583         {
584             uint subindex = 0;
585             for (uint i = 0; i < h.length; i ++)
586             {
587                 if (h[i] == n[0])
588                 {
589                     subindex = 1;
590                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
591                     {
592                         subindex++;
593                     }
594                     if(subindex == n.length)
595                         return int(i);
596                 }
597             }
598             return -1;
599         }
600     }
601 
602     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
603         bytes memory _ba = bytes(_a);
604         bytes memory _bb = bytes(_b);
605         bytes memory _bc = bytes(_c);
606         bytes memory _bd = bytes(_d);
607         bytes memory _be = bytes(_e);
608         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
609         bytes memory babcde = bytes(abcde);
610         uint k = 0;
611         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
612         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
613         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
614         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
615         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
616         return string(babcde);
617     }
618 
619     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
620         return strConcat(_a, _b, _c, _d, "");
621     }
622 
623     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
624         return strConcat(_a, _b, _c, "", "");
625     }
626 
627     function strConcat(string _a, string _b) internal pure returns (string) {
628         return strConcat(_a, _b, "", "", "");
629     }
630 
631     // parseInt
632     function parseInt(string _a) internal pure returns (uint) {
633         return parseInt(_a, 0);
634     }
635 
636     // parseInt(parseFloat*10^_b)
637     function parseInt(string _a, uint _b) internal pure returns (uint) {
638         bytes memory bresult = bytes(_a);
639         uint mint = 0;
640         bool decimals = false;
641         for (uint i=0; i<bresult.length; i++){
642             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
643                 if (decimals){
644                    if (_b == 0) break;
645                     else _b--;
646                 }
647                 mint *= 10;
648                 mint += uint(bresult[i]) - 48;
649             } else if (bresult[i] == 46) decimals = true;
650         }
651         if (_b > 0) mint *= 10**_b;
652         return mint;
653     }
654 
655     function uint2str(uint i) internal pure returns (string){
656         if (i == 0) return "0";
657         uint j = i;
658         uint len;
659         while (j != 0){
660             len++;
661             j /= 10;
662         }
663         bytes memory bstr = new bytes(len);
664         uint k = len - 1;
665         while (i != 0){
666             bstr[k--] = byte(48 + i % 10);
667             i /= 10;
668         }
669         return string(bstr);
670     }
671 
672     function stra2cbor(string[] arr) internal pure returns (bytes) {
673             uint arrlen = arr.length;
674 
675             // get correct cbor output length
676             uint outputlen = 0;
677             bytes[] memory elemArray = new bytes[](arrlen);
678             for (uint i = 0; i < arrlen; i++) {
679                 elemArray[i] = (bytes(arr[i]));
680                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
681             }
682             uint ctr = 0;
683             uint cborlen = arrlen + 0x80;
684             outputlen += byte(cborlen).length;
685             bytes memory res = new bytes(outputlen);
686 
687             while (byte(cborlen).length > ctr) {
688                 res[ctr] = byte(cborlen)[ctr];
689                 ctr++;
690             }
691             for (i = 0; i < arrlen; i++) {
692                 res[ctr] = 0x5F;
693                 ctr++;
694                 for (uint x = 0; x < elemArray[i].length; x++) {
695                     // if there's a bug with larger strings, this may be the culprit
696                     if (x % 23 == 0) {
697                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
698                         elemcborlen += 0x40;
699                         uint lctr = ctr;
700                         while (byte(elemcborlen).length > ctr - lctr) {
701                             res[ctr] = byte(elemcborlen)[ctr - lctr];
702                             ctr++;
703                         }
704                     }
705                     res[ctr] = elemArray[i][x];
706                     ctr++;
707                 }
708                 res[ctr] = 0xFF;
709                 ctr++;
710             }
711             return res;
712         }
713 
714     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
715             uint arrlen = arr.length;
716 
717             // get correct cbor output length
718             uint outputlen = 0;
719             bytes[] memory elemArray = new bytes[](arrlen);
720             for (uint i = 0; i < arrlen; i++) {
721                 elemArray[i] = (bytes(arr[i]));
722                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
723             }
724             uint ctr = 0;
725             uint cborlen = arrlen + 0x80;
726             outputlen += byte(cborlen).length;
727             bytes memory res = new bytes(outputlen);
728 
729             while (byte(cborlen).length > ctr) {
730                 res[ctr] = byte(cborlen)[ctr];
731                 ctr++;
732             }
733             for (i = 0; i < arrlen; i++) {
734                 res[ctr] = 0x5F;
735                 ctr++;
736                 for (uint x = 0; x < elemArray[i].length; x++) {
737                     // if there's a bug with larger strings, this may be the culprit
738                     if (x % 23 == 0) {
739                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
740                         elemcborlen += 0x40;
741                         uint lctr = ctr;
742                         while (byte(elemcborlen).length > ctr - lctr) {
743                             res[ctr] = byte(elemcborlen)[ctr - lctr];
744                             ctr++;
745                         }
746                     }
747                     res[ctr] = elemArray[i][x];
748                     ctr++;
749                 }
750                 res[ctr] = 0xFF;
751                 ctr++;
752             }
753             return res;
754         }
755 
756 
757     string oraclize_network_name;
758     function oraclize_setNetworkName(string _network_name) internal {
759         oraclize_network_name = _network_name;
760     }
761 
762     function oraclize_getNetworkName() internal view returns (string) {
763         return oraclize_network_name;
764     }
765 
766     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
767         require((_nbytes > 0) && (_nbytes <= 32));
768         // Convert from seconds to ledger timer ticks
769         _delay *= 10; 
770         bytes memory nbytes = new bytes(1);
771         nbytes[0] = byte(_nbytes);
772         bytes memory unonce = new bytes(32);
773         bytes memory sessionKeyHash = new bytes(32);
774         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
775         assembly {
776             mstore(unonce, 0x20)
777             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
778             mstore(sessionKeyHash, 0x20)
779             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
780         }
781         bytes memory delay = new bytes(32);
782         assembly { 
783             mstore(add(delay, 0x20), _delay) 
784         }
785         
786         bytes memory delay_bytes8 = new bytes(8);
787         copyBytes(delay, 24, 8, delay_bytes8, 0);
788 
789         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
790         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
791         
792         bytes memory delay_bytes8_left = new bytes(8);
793         
794         assembly {
795             let x := mload(add(delay_bytes8, 0x20))
796             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
797             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
798             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
799             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
800             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
801             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
802             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
803             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
804 
805         }
806         
807         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
808         return queryId;
809     }
810     
811     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
812         oraclize_randomDS_args[queryId] = commitment;
813     }
814 
815     mapping(bytes32=>bytes32) oraclize_randomDS_args;
816     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
817 
818     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
819         bool sigok;
820         address signer;
821 
822         bytes32 sigr;
823         bytes32 sigs;
824 
825         bytes memory sigr_ = new bytes(32);
826         uint offset = 4+(uint(dersig[3]) - 0x20);
827         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
828         bytes memory sigs_ = new bytes(32);
829         offset += 32 + 2;
830         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
831 
832         assembly {
833             sigr := mload(add(sigr_, 32))
834             sigs := mload(add(sigs_, 32))
835         }
836 
837 
838         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
839         if (address(keccak256(pubkey)) == signer) return true;
840         else {
841             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
842             return (address(keccak256(pubkey)) == signer);
843         }
844     }
845 
846     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
847         bool sigok;
848 
849         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
850         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
851         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
852 
853         bytes memory appkey1_pubkey = new bytes(64);
854         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
855 
856         bytes memory tosign2 = new bytes(1+65+32);
857         tosign2[0] = byte(1); //role
858         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
859         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
860         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
861         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
862 
863         if (sigok == false) return false;
864 
865 
866         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
867         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
868 
869         bytes memory tosign3 = new bytes(1+65);
870         tosign3[0] = 0xFE;
871         copyBytes(proof, 3, 65, tosign3, 1);
872 
873         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
874         copyBytes(proof, 3+65, sig3.length, sig3, 0);
875 
876         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
877 
878         return sigok;
879     }
880 
881     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
882         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
883         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
884 
885         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
886         require(proofVerified);
887 
888         _;
889     }
890 
891     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
892         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
893         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
894 
895         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
896         if (proofVerified == false) return 2;
897 
898         return 0;
899     }
900 
901     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
902         bool match_ = true;
903         
904         require(prefix.length == n_random_bytes);
905 
906         for (uint256 i=0; i< n_random_bytes; i++) {
907             if (content[i] != prefix[i]) match_ = false;
908         }
909 
910         return match_;
911     }
912 
913     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
914 
915         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
916         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
917         bytes memory keyhash = new bytes(32);
918         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
919         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
920 
921         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
922         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
923 
924         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
925         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
926 
927         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
928         // This is to verify that the computed args match with the ones specified in the query.
929         bytes memory commitmentSlice1 = new bytes(8+1+32);
930         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
931 
932         bytes memory sessionPubkey = new bytes(64);
933         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
934         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
935 
936         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
937         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
938             delete oraclize_randomDS_args[queryId];
939         } else return false;
940 
941 
942         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
943         bytes memory tosign1 = new bytes(32+8+1+32);
944         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
945         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
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
956     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
957         uint minLength = length + toOffset;
958 
959         // Buffer too small
960         require(to.length >= minLength); // Should be a better way?
961 
962         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
963         uint i = 32 + fromOffset;
964         uint j = 32 + toOffset;
965 
966         while (i < (32 + fromOffset + length)) {
967             assembly {
968                 let tmp := mload(add(from, i))
969                 mstore(add(to, j), tmp)
970             }
971             i += 32;
972             j += 32;
973         }
974 
975         return to;
976     }
977 
978     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
979     // Duplicate Solidity's ecrecover, but catching the CALL return value
980     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
981         // We do our own memory management here. Solidity uses memory offset
982         // 0x40 to store the current end of memory. We write past it (as
983         // writes are memory extensions), but don't update the offset so
984         // Solidity will reuse it. The memory used here is only needed for
985         // this context.
986 
987         // FIXME: inline assembly can't access return values
988         bool ret;
989         address addr;
990 
991         assembly {
992             let size := mload(0x40)
993             mstore(size, hash)
994             mstore(add(size, 32), v)
995             mstore(add(size, 64), r)
996             mstore(add(size, 96), s)
997 
998             // NOTE: we can reuse the request memory because we deal with
999             //       the return code
1000             ret := call(3000, 1, 0, size, 128, size, 32)
1001             addr := mload(size)
1002         }
1003 
1004         return (ret, addr);
1005     }
1006 
1007     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1008     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1009         bytes32 r;
1010         bytes32 s;
1011         uint8 v;
1012 
1013         if (sig.length != 65)
1014           return (false, 0);
1015 
1016         // The signature format is a compact form of:
1017         //   {bytes32 r}{bytes32 s}{uint8 v}
1018         // Compact means, uint8 is not padded to 32 bytes.
1019         assembly {
1020             r := mload(add(sig, 32))
1021             s := mload(add(sig, 64))
1022 
1023             // Here we are loading the last 32 bytes. We exploit the fact that
1024             // 'mload' will pad with zeroes if we overread.
1025             // There is no 'mload8' to do this, but that would be nicer.
1026             v := byte(0, mload(add(sig, 96)))
1027 
1028             // Alternative solution:
1029             // 'byte' is not working due to the Solidity parser, so lets
1030             // use the second best option, 'and'
1031             // v := and(mload(add(sig, 65)), 255)
1032         }
1033 
1034         // albeit non-transactional signatures are not specified by the YP, one would expect it
1035         // to match the YP range of [27, 28]
1036         //
1037         // geth uses [0, 1] and some clients have followed. This might change, see:
1038         //  https://github.com/ethereum/go-ethereum/issues/2053
1039         if (v < 27)
1040           v += 27;
1041 
1042         if (v != 27 && v != 28)
1043             return (false, 0);
1044 
1045         return safer_ecrecover(hash, v, r, s);
1046     }
1047 
1048 }
1049 // </ORACLIZE_API>
1050 
1051 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
1052 
1053 /**
1054  * @title SafeMath
1055  * @dev Math operations with safety checks that throw on error
1056  */
1057 library SafeMath {
1058 
1059   /**
1060   * @dev Multiplies two numbers, throws on overflow.
1061   */
1062   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1063     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1064     // benefit is lost if 'b' is also tested.
1065     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1066     if (a == 0) {
1067       return 0;
1068     }
1069 
1070     c = a * b;
1071     assert(c / a == b);
1072     return c;
1073   }
1074 
1075   /**
1076   * @dev Integer division of two numbers, truncating the quotient.
1077   */
1078   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1079     // assert(b > 0); // Solidity automatically throws when dividing by 0
1080     // uint256 c = a / b;
1081     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1082     return a / b;
1083   }
1084 
1085   /**
1086   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1087   */
1088   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1089     assert(b <= a);
1090     return a - b;
1091   }
1092 
1093   /**
1094   * @dev Adds two numbers, throws on overflow.
1095   */
1096   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1097     c = a + b;
1098     assert(c >= a);
1099     return c;
1100   }
1101 }
1102 
1103 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
1104 
1105 /**
1106  * @title Ownable
1107  * @dev The Ownable contract has an owner address, and provides basic authorization control
1108  * functions, this simplifies the implementation of "user permissions".
1109  */
1110 contract Ownable {
1111   address public owner;
1112 
1113 
1114   event OwnershipRenounced(address indexed previousOwner);
1115   event OwnershipTransferred(
1116     address indexed previousOwner,
1117     address indexed newOwner
1118   );
1119 
1120 
1121   /**
1122    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1123    * account.
1124    */
1125   constructor() public {
1126     owner = msg.sender;
1127   }
1128 
1129   /**
1130    * @dev Throws if called by any account other than the owner.
1131    */
1132   modifier onlyOwner() {
1133     require(msg.sender == owner);
1134     _;
1135   }
1136 
1137   /**
1138    * @dev Allows the current owner to relinquish control of the contract.
1139    */
1140   function renounceOwnership() public onlyOwner {
1141     emit OwnershipRenounced(owner);
1142     owner = address(0);
1143   }
1144 
1145   /**
1146    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1147    * @param _newOwner The address to transfer ownership to.
1148    */
1149   function transferOwnership(address _newOwner) public onlyOwner {
1150     _transferOwnership(_newOwner);
1151   }
1152 
1153   /**
1154    * @dev Transfers control of the contract to a newOwner.
1155    * @param _newOwner The address to transfer ownership to.
1156    */
1157   function _transferOwnership(address _newOwner) internal {
1158     require(_newOwner != address(0));
1159     emit OwnershipTransferred(owner, _newOwner);
1160     owner = _newOwner;
1161   }
1162 }
1163 
1164 // File: contracts/crowdsale/FiatContractInterface.sol
1165 
1166 /**
1167  * @title FiatContractInterface, defining one single function to get 0,01 $ price.
1168  * @dev FiatContractInterface
1169  **/
1170 contract FiatContractInterface {
1171   function USD(uint _id) view public returns (uint256);
1172 }
1173 
1174 // File: contracts/utils/strings.sol
1175 
1176 /*
1177  * @title String & slice utility library for Solidity contracts.
1178  * @author Nick Johnson <arachnid@notdot.net>
1179  *
1180  * @dev Functionality in this library is largely implemented using an
1181  *      abstraction called a 'slice'. A slice represents a part of a string -
1182  *      anything from the entire string to a single character, or even no
1183  *      characters at all (a 0-length slice). Since a slice only has to specify
1184  *      an offset and a length, copying and manipulating slices is a lot less
1185  *      expensive than copying and manipulating the strings they reference.
1186  *
1187  *      To further reduce gas costs, most functions on slice that need to return
1188  *      a slice modify the original one instead of allocating a new one; for
1189  *      instance, `s.split(".")` will return the text up to the first '.',
1190  *      modifying s to only contain the remainder of the string after the '.'.
1191  *      In situations where you do not want to modify the original slice, you
1192  *      can make a copy first with `.copy()`, for example:
1193  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1194  *      Solidity has no memory management, it will result in allocating many
1195  *      short-lived slices that are later discarded.
1196  *
1197  *      Functions that return two slices come in two versions: a non-allocating
1198  *      version that takes the second slice as an argument, modifying it in
1199  *      place, and an allocating version that allocates and returns the second
1200  *      slice; see `nextRune` for example.
1201  *
1202  *      Functions that have to copy string data will return strings rather than
1203  *      slices; these can be cast back to slices for further processing if
1204  *      required.
1205  *
1206  *      For convenience, some functions are provided with non-modifying
1207  *      variants that create a new slice and return both; for instance,
1208  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1209  *      corresponding to the left and right parts of the string.
1210  */
1211 
1212 pragma solidity ^0.4.14;
1213 
1214 library strings {
1215     struct slice {
1216         uint _len;
1217         uint _ptr;
1218     }
1219 
1220     function memcpy(uint dest, uint src, uint len) private pure {
1221         // Copy word-length chunks while possible
1222         for(; len >= 32; len -= 32) {
1223             assembly {
1224                 mstore(dest, mload(src))
1225             }
1226             dest += 32;
1227             src += 32;
1228         }
1229 
1230         // Copy remaining bytes
1231         uint mask = 256 ** (32 - len) - 1;
1232         assembly {
1233             let srcpart := and(mload(src), not(mask))
1234             let destpart := and(mload(dest), mask)
1235             mstore(dest, or(destpart, srcpart))
1236         }
1237     }
1238 
1239     /*
1240      * @dev Returns a slice containing the entire string.
1241      * @param self The string to make a slice from.
1242      * @return A newly allocated slice containing the entire string.
1243      */
1244     function toSlice(string memory self) internal pure returns (slice memory) {
1245         uint ptr;
1246         assembly {
1247             ptr := add(self, 0x20)
1248         }
1249         return slice(bytes(self).length, ptr);
1250     }
1251 
1252     /*
1253      * @dev Returns the length of a null-terminated bytes32 string.
1254      * @param self The value to find the length of.
1255      * @return The length of the string, from 0 to 32.
1256      */
1257     function len(bytes32 self) internal pure returns (uint) {
1258         uint ret;
1259         if (self == 0)
1260             return 0;
1261         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1262             ret += 16;
1263             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1264         }
1265         if (self & 0xffffffffffffffff == 0) {
1266             ret += 8;
1267             self = bytes32(uint(self) / 0x10000000000000000);
1268         }
1269         if (self & 0xffffffff == 0) {
1270             ret += 4;
1271             self = bytes32(uint(self) / 0x100000000);
1272         }
1273         if (self & 0xffff == 0) {
1274             ret += 2;
1275             self = bytes32(uint(self) / 0x10000);
1276         }
1277         if (self & 0xff == 0) {
1278             ret += 1;
1279         }
1280         return 32 - ret;
1281     }
1282 
1283     /*
1284      * @dev Returns a slice containing the entire bytes32, interpreted as a
1285      *      null-terminated utf-8 string.
1286      * @param self The bytes32 value to convert to a slice.
1287      * @return A new slice containing the value of the input argument up to the
1288      *         first null.
1289      */
1290     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
1291         // Allocate space for `self` in memory, copy it there, and point ret at it
1292         assembly {
1293             let ptr := mload(0x40)
1294             mstore(0x40, add(ptr, 0x20))
1295             mstore(ptr, self)
1296             mstore(add(ret, 0x20), ptr)
1297         }
1298         ret._len = len(self);
1299     }
1300 
1301     /*
1302      * @dev Returns a new slice containing the same data as the current slice.
1303      * @param self The slice to copy.
1304      * @return A new slice containing the same data as `self`.
1305      */
1306     function copy(slice memory self) internal pure returns (slice memory) {
1307         return slice(self._len, self._ptr);
1308     }
1309 
1310     /*
1311      * @dev Copies a slice to a new string.
1312      * @param self The slice to copy.
1313      * @return A newly allocated string containing the slice's text.
1314      */
1315     function toString(slice memory self) internal pure returns (string memory) {
1316         string memory ret = new string(self._len);
1317         uint retptr;
1318         assembly { retptr := add(ret, 32) }
1319 
1320         memcpy(retptr, self._ptr, self._len);
1321         return ret;
1322     }
1323 
1324     /*
1325      * @dev Returns the length in runes of the slice. Note that this operation
1326      *      takes time proportional to the length of the slice; avoid using it
1327      *      in loops, and call `slice.empty()` if you only need to know whether
1328      *      the slice is empty or not.
1329      * @param self The slice to operate on.
1330      * @return The length of the slice in runes.
1331      */
1332     function len(slice memory self) internal pure returns (uint l) {
1333         // Starting at ptr-31 means the LSB will be the byte we care about
1334         uint ptr = self._ptr - 31;
1335         uint end = ptr + self._len;
1336         for (l = 0; ptr < end; l++) {
1337             uint8 b;
1338             assembly { b := and(mload(ptr), 0xFF) }
1339             if (b < 0x80) {
1340                 ptr += 1;
1341             } else if(b < 0xE0) {
1342                 ptr += 2;
1343             } else if(b < 0xF0) {
1344                 ptr += 3;
1345             } else if(b < 0xF8) {
1346                 ptr += 4;
1347             } else if(b < 0xFC) {
1348                 ptr += 5;
1349             } else {
1350                 ptr += 6;
1351             }
1352         }
1353     }
1354 
1355     /*
1356      * @dev Returns true if the slice is empty (has a length of 0).
1357      * @param self The slice to operate on.
1358      * @return True if the slice is empty, False otherwise.
1359      */
1360     function empty(slice memory self) internal pure returns (bool) {
1361         return self._len == 0;
1362     }
1363 
1364     /*
1365      * @dev Returns a positive number if `other` comes lexicographically after
1366      *      `self`, a negative number if it comes before, or zero if the
1367      *      contents of the two slices are equal. Comparison is done per-rune,
1368      *      on unicode codepoints.
1369      * @param self The first slice to compare.
1370      * @param other The second slice to compare.
1371      * @return The result of the comparison.
1372      */
1373     function compare(slice memory self, slice memory other) internal pure returns (int) {
1374         uint shortest = self._len;
1375         if (other._len < self._len)
1376             shortest = other._len;
1377 
1378         uint selfptr = self._ptr;
1379         uint otherptr = other._ptr;
1380         for (uint idx = 0; idx < shortest; idx += 32) {
1381             uint a;
1382             uint b;
1383             assembly {
1384                 a := mload(selfptr)
1385                 b := mload(otherptr)
1386             }
1387             if (a != b) {
1388                 // Mask out irrelevant bytes and check again
1389                 uint256 mask = uint256(-1); // 0xffff...
1390                 if(shortest < 32) {
1391                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1392                 }
1393                 uint256 diff = (a & mask) - (b & mask);
1394                 if (diff != 0)
1395                     return int(diff);
1396             }
1397             selfptr += 32;
1398             otherptr += 32;
1399         }
1400         return int(self._len) - int(other._len);
1401     }
1402 
1403     /*
1404      * @dev Returns true if the two slices contain the same text.
1405      * @param self The first slice to compare.
1406      * @param self The second slice to compare.
1407      * @return True if the slices are equal, false otherwise.
1408      */
1409     function equals(slice memory self, slice memory other) internal pure returns (bool) {
1410         return compare(self, other) == 0;
1411     }
1412 
1413     /*
1414      * @dev Extracts the first rune in the slice into `rune`, advancing the
1415      *      slice to point to the next rune and returning `self`.
1416      * @param self The slice to operate on.
1417      * @param rune The slice that will contain the first rune.
1418      * @return `rune`.
1419      */
1420     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
1421         rune._ptr = self._ptr;
1422 
1423         if (self._len == 0) {
1424             rune._len = 0;
1425             return rune;
1426         }
1427 
1428         uint l;
1429         uint b;
1430         // Load the first byte of the rune into the LSBs of b
1431         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1432         if (b < 0x80) {
1433             l = 1;
1434         } else if(b < 0xE0) {
1435             l = 2;
1436         } else if(b < 0xF0) {
1437             l = 3;
1438         } else {
1439             l = 4;
1440         }
1441 
1442         // Check for truncated codepoints
1443         if (l > self._len) {
1444             rune._len = self._len;
1445             self._ptr += self._len;
1446             self._len = 0;
1447             return rune;
1448         }
1449 
1450         self._ptr += l;
1451         self._len -= l;
1452         rune._len = l;
1453         return rune;
1454     }
1455 
1456     /*
1457      * @dev Returns the first rune in the slice, advancing the slice to point
1458      *      to the next rune.
1459      * @param self The slice to operate on.
1460      * @return A slice containing only the first rune from `self`.
1461      */
1462     function nextRune(slice memory self) internal pure returns (slice memory ret) {
1463         nextRune(self, ret);
1464     }
1465 
1466     /*
1467      * @dev Returns the number of the first codepoint in the slice.
1468      * @param self The slice to operate on.
1469      * @return The number of the first codepoint in the slice.
1470      */
1471     function ord(slice memory self) internal pure returns (uint ret) {
1472         if (self._len == 0) {
1473             return 0;
1474         }
1475 
1476         uint word;
1477         uint length;
1478         uint divisor = 2 ** 248;
1479 
1480         // Load the rune into the MSBs of b
1481         assembly { word:= mload(mload(add(self, 32))) }
1482         uint b = word / divisor;
1483         if (b < 0x80) {
1484             ret = b;
1485             length = 1;
1486         } else if(b < 0xE0) {
1487             ret = b & 0x1F;
1488             length = 2;
1489         } else if(b < 0xF0) {
1490             ret = b & 0x0F;
1491             length = 3;
1492         } else {
1493             ret = b & 0x07;
1494             length = 4;
1495         }
1496 
1497         // Check for truncated codepoints
1498         if (length > self._len) {
1499             return 0;
1500         }
1501 
1502         for (uint i = 1; i < length; i++) {
1503             divisor = divisor / 256;
1504             b = (word / divisor) & 0xFF;
1505             if (b & 0xC0 != 0x80) {
1506                 // Invalid UTF-8 sequence
1507                 return 0;
1508             }
1509             ret = (ret * 64) | (b & 0x3F);
1510         }
1511 
1512         return ret;
1513     }
1514 
1515     /*
1516      * @dev Returns the keccak-256 hash of the slice.
1517      * @param self The slice to hash.
1518      * @return The hash of the slice.
1519      */
1520     function keccak(slice memory self) internal pure returns (bytes32 ret) {
1521         assembly {
1522             ret := keccak256(mload(add(self, 32)), mload(self))
1523         }
1524     }
1525 
1526     /*
1527      * @dev Returns true if `self` starts with `needle`.
1528      * @param self The slice to operate on.
1529      * @param needle The slice to search for.
1530      * @return True if the slice starts with the provided text, false otherwise.
1531      */
1532     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1533         if (self._len < needle._len) {
1534             return false;
1535         }
1536 
1537         if (self._ptr == needle._ptr) {
1538             return true;
1539         }
1540 
1541         bool equal;
1542         assembly {
1543             let length := mload(needle)
1544             let selfptr := mload(add(self, 0x20))
1545             let needleptr := mload(add(needle, 0x20))
1546             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1547         }
1548         return equal;
1549     }
1550 
1551     /*
1552      * @dev If `self` starts with `needle`, `needle` is removed from the
1553      *      beginning of `self`. Otherwise, `self` is unmodified.
1554      * @param self The slice to operate on.
1555      * @param needle The slice to search for.
1556      * @return `self`
1557      */
1558     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
1559         if (self._len < needle._len) {
1560             return self;
1561         }
1562 
1563         bool equal = true;
1564         if (self._ptr != needle._ptr) {
1565             assembly {
1566                 let length := mload(needle)
1567                 let selfptr := mload(add(self, 0x20))
1568                 let needleptr := mload(add(needle, 0x20))
1569                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1570             }
1571         }
1572 
1573         if (equal) {
1574             self._len -= needle._len;
1575             self._ptr += needle._len;
1576         }
1577 
1578         return self;
1579     }
1580 
1581     /*
1582      * @dev Returns true if the slice ends with `needle`.
1583      * @param self The slice to operate on.
1584      * @param needle The slice to search for.
1585      * @return True if the slice starts with the provided text, false otherwise.
1586      */
1587     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1588         if (self._len < needle._len) {
1589             return false;
1590         }
1591 
1592         uint selfptr = self._ptr + self._len - needle._len;
1593 
1594         if (selfptr == needle._ptr) {
1595             return true;
1596         }
1597 
1598         bool equal;
1599         assembly {
1600             let length := mload(needle)
1601             let needleptr := mload(add(needle, 0x20))
1602             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1603         }
1604 
1605         return equal;
1606     }
1607 
1608     /*
1609      * @dev If `self` ends with `needle`, `needle` is removed from the
1610      *      end of `self`. Otherwise, `self` is unmodified.
1611      * @param self The slice to operate on.
1612      * @param needle The slice to search for.
1613      * @return `self`
1614      */
1615     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
1616         if (self._len < needle._len) {
1617             return self;
1618         }
1619 
1620         uint selfptr = self._ptr + self._len - needle._len;
1621         bool equal = true;
1622         if (selfptr != needle._ptr) {
1623             assembly {
1624                 let length := mload(needle)
1625                 let needleptr := mload(add(needle, 0x20))
1626                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1627             }
1628         }
1629 
1630         if (equal) {
1631             self._len -= needle._len;
1632         }
1633 
1634         return self;
1635     }
1636 
1637     // Returns the memory address of the first byte of the first occurrence of
1638     // `needle` in `self`, or the first byte after `self` if not found.
1639     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1640         uint ptr = selfptr;
1641         uint idx;
1642 
1643         if (needlelen <= selflen) {
1644             if (needlelen <= 32) {
1645                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1646 
1647                 bytes32 needledata;
1648                 assembly { needledata := and(mload(needleptr), mask) }
1649 
1650                 uint end = selfptr + selflen - needlelen;
1651                 bytes32 ptrdata;
1652                 assembly { ptrdata := and(mload(ptr), mask) }
1653 
1654                 while (ptrdata != needledata) {
1655                     if (ptr >= end)
1656                         return selfptr + selflen;
1657                     ptr++;
1658                     assembly { ptrdata := and(mload(ptr), mask) }
1659                 }
1660                 return ptr;
1661             } else {
1662                 // For long needles, use hashing
1663                 bytes32 hash;
1664                 assembly { hash := keccak256(needleptr, needlelen) }
1665 
1666                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1667                     bytes32 testHash;
1668                     assembly { testHash := keccak256(ptr, needlelen) }
1669                     if (hash == testHash)
1670                         return ptr;
1671                     ptr += 1;
1672                 }
1673             }
1674         }
1675         return selfptr + selflen;
1676     }
1677 
1678     // Returns the memory address of the first byte after the last occurrence of
1679     // `needle` in `self`, or the address of `self` if not found.
1680     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1681         uint ptr;
1682 
1683         if (needlelen <= selflen) {
1684             if (needlelen <= 32) {
1685                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1686 
1687                 bytes32 needledata;
1688                 assembly { needledata := and(mload(needleptr), mask) }
1689 
1690                 ptr = selfptr + selflen - needlelen;
1691                 bytes32 ptrdata;
1692                 assembly { ptrdata := and(mload(ptr), mask) }
1693 
1694                 while (ptrdata != needledata) {
1695                     if (ptr <= selfptr)
1696                         return selfptr;
1697                     ptr--;
1698                     assembly { ptrdata := and(mload(ptr), mask) }
1699                 }
1700                 return ptr + needlelen;
1701             } else {
1702                 // For long needles, use hashing
1703                 bytes32 hash;
1704                 assembly { hash := keccak256(needleptr, needlelen) }
1705                 ptr = selfptr + (selflen - needlelen);
1706                 while (ptr >= selfptr) {
1707                     bytes32 testHash;
1708                     assembly { testHash := keccak256(ptr, needlelen) }
1709                     if (hash == testHash)
1710                         return ptr + needlelen;
1711                     ptr -= 1;
1712                 }
1713             }
1714         }
1715         return selfptr;
1716     }
1717 
1718     /*
1719      * @dev Modifies `self` to contain everything from the first occurrence of
1720      *      `needle` to the end of the slice. `self` is set to the empty slice
1721      *      if `needle` is not found.
1722      * @param self The slice to search and modify.
1723      * @param needle The text to search for.
1724      * @return `self`.
1725      */
1726     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
1727         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1728         self._len -= ptr - self._ptr;
1729         self._ptr = ptr;
1730         return self;
1731     }
1732 
1733     /*
1734      * @dev Modifies `self` to contain the part of the string from the start of
1735      *      `self` to the end of the first occurrence of `needle`. If `needle`
1736      *      is not found, `self` is set to the empty slice.
1737      * @param self The slice to search and modify.
1738      * @param needle The text to search for.
1739      * @return `self`.
1740      */
1741     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
1742         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1743         self._len = ptr - self._ptr;
1744         return self;
1745     }
1746 
1747     /*
1748      * @dev Splits the slice, setting `self` to everything after the first
1749      *      occurrence of `needle`, and `token` to everything before it. If
1750      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1751      *      and `token` is set to the entirety of `self`.
1752      * @param self The slice to split.
1753      * @param needle The text to search for in `self`.
1754      * @param token An output parameter to which the first token is written.
1755      * @return `token`.
1756      */
1757     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1758         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1759         token._ptr = self._ptr;
1760         token._len = ptr - self._ptr;
1761         if (ptr == self._ptr + self._len) {
1762             // Not found
1763             self._len = 0;
1764         } else {
1765             self._len -= token._len + needle._len;
1766             self._ptr = ptr + needle._len;
1767         }
1768         return token;
1769     }
1770 
1771     /*
1772      * @dev Splits the slice, setting `self` to everything after the first
1773      *      occurrence of `needle`, and returning everything before it. If
1774      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1775      *      and the entirety of `self` is returned.
1776      * @param self The slice to split.
1777      * @param needle The text to search for in `self`.
1778      * @return The part of `self` up to the first occurrence of `delim`.
1779      */
1780     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1781         split(self, needle, token);
1782     }
1783 
1784     /*
1785      * @dev Splits the slice, setting `self` to everything before the last
1786      *      occurrence of `needle`, and `token` to everything after it. If
1787      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1788      *      and `token` is set to the entirety of `self`.
1789      * @param self The slice to split.
1790      * @param needle The text to search for in `self`.
1791      * @param token An output parameter to which the first token is written.
1792      * @return `token`.
1793      */
1794     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1795         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1796         token._ptr = ptr;
1797         token._len = self._len - (ptr - self._ptr);
1798         if (ptr == self._ptr) {
1799             // Not found
1800             self._len = 0;
1801         } else {
1802             self._len -= token._len + needle._len;
1803         }
1804         return token;
1805     }
1806 
1807     /*
1808      * @dev Splits the slice, setting `self` to everything before the last
1809      *      occurrence of `needle`, and returning everything after it. If
1810      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1811      *      and the entirety of `self` is returned.
1812      * @param self The slice to split.
1813      * @param needle The text to search for in `self`.
1814      * @return The part of `self` after the last occurrence of `delim`.
1815      */
1816     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1817         rsplit(self, needle, token);
1818     }
1819 
1820     /*
1821      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1822      * @param self The slice to search.
1823      * @param needle The text to search for in `self`.
1824      * @return The number of occurrences of `needle` found in `self`.
1825      */
1826     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
1827         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1828         while (ptr <= self._ptr + self._len) {
1829             cnt++;
1830             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1831         }
1832     }
1833 
1834     /*
1835      * @dev Returns True if `self` contains `needle`.
1836      * @param self The slice to search.
1837      * @param needle The text to search for in `self`.
1838      * @return True if `needle` is found in `self`, false otherwise.
1839      */
1840     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
1841         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1842     }
1843 
1844     /*
1845      * @dev Returns a newly allocated string containing the concatenation of
1846      *      `self` and `other`.
1847      * @param self The first slice to concatenate.
1848      * @param other The second slice to concatenate.
1849      * @return The concatenation of the two strings.
1850      */
1851     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1852         string memory ret = new string(self._len + other._len);
1853         uint retptr;
1854         assembly { retptr := add(ret, 32) }
1855         memcpy(retptr, self._ptr, self._len);
1856         memcpy(retptr + self._len, other._ptr, other._len);
1857         return ret;
1858     }
1859 
1860     /*
1861      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1862      *      newly allocated string.
1863      * @param self The delimiter to use.
1864      * @param parts A list of slices to join.
1865      * @return A newly allocated string containing all the slices in `parts`,
1866      *         joined with `self`.
1867      */
1868     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
1869         if (parts.length == 0)
1870             return "";
1871 
1872         uint length = self._len * (parts.length - 1);
1873         for(uint i = 0; i < parts.length; i++)
1874             length += parts[i]._len;
1875 
1876         string memory ret = new string(length);
1877         uint retptr;
1878         assembly { retptr := add(ret, 32) }
1879 
1880         for(i = 0; i < parts.length; i++) {
1881             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1882             retptr += parts[i]._len;
1883             if (i < parts.length - 1) {
1884                 memcpy(retptr, self._ptr, self._len);
1885                 retptr += self._len;
1886             }
1887         }
1888 
1889         return ret;
1890     }
1891 }
1892 
1893 // File: contracts/crowdsale/MultiCurrencyRates.sol
1894 
1895 /**
1896  * @title MultiCurrencyRates
1897  * @dev MultiCurrencyRates
1898  */
1899 // solium-disable-next-line max-len
1900 contract MultiCurrencyRates is usingOraclize, Ownable {
1901   using SafeMath for uint256;
1902   using strings for *;
1903 
1904   FiatContractInterface public fiatContract;
1905 
1906   /**
1907    * @param _fiatContract Address of fiatContract
1908    */
1909 
1910   constructor(address _fiatContract) public {
1911     require(_fiatContract != address(0));
1912     fiatContract = FiatContractInterface(_fiatContract);
1913   }
1914 
1915   /**
1916   * @dev Set fiat contract
1917   * @param _fiatContract Address of new fiatContract
1918   */
1919   function setFiatContract(address _fiatContract) public onlyOwner {
1920     fiatContract = FiatContractInterface(_fiatContract);
1921   }
1922 
1923   /**
1924   * @dev Returns the current 0.01$ => ETH wei rate
1925   */
1926   function getUSDCentToWeiRate() internal view returns (uint256) {
1927     return fiatContract.USD(0);
1928   }
1929 
1930   /**
1931   * @dev Returns the current 0.01$ => BTC satoshi rate
1932   */
1933   function getUSDCentToBTCSatoshiRate() internal view returns (uint256) {
1934     return fiatContract.USD(1);
1935   }
1936 
1937   /**
1938   * @dev Returns the current 0.01$ => LTC satoshi rate
1939   */
1940   function getUSDCentToLTCSatoshiRate() internal view returns (uint256) {
1941     return fiatContract.USD(2);
1942   }
1943 
1944   /**
1945   * @dev Returns the current BNB => 0.01$ rate
1946   */
1947   function getBNBToUSDCentRate(string oraclizeResult) internal pure returns (uint256) {
1948     return parseInt(parseCurrencyRate(oraclizeResult, "BNB"), 2);
1949   }
1950 
1951   /**
1952   * @dev Returns the current BCH => 0.01$ rate
1953   */
1954   function getBCHToUSDCentRate(string oraclizeResult) internal pure returns (uint256) {
1955     return parseInt(parseCurrencyRate(oraclizeResult, "BCH"), 2);
1956   }
1957 
1958   /**
1959    * @dev Parse currency rate from oraclize response
1960    * @param oraclizeResult Result from Oraclize with currencies prices
1961    * @param _currencyTicker Currency tiker
1962    * @return Currency price string in USD
1963    */
1964   function parseCurrencyRate(string oraclizeResult, string _currencyTicker) internal pure returns(string) {
1965     strings.slice memory response = oraclizeResult.toSlice();
1966     strings.slice memory needle = _currencyTicker.toSlice();
1967     strings.slice memory tickerPrice = response.find(needle).split("}".toSlice()).find(" ".toSlice()).rsplit(" ".toSlice());
1968     return tickerPrice.toString();
1969   }
1970 
1971 }
1972 
1973 // File: contracts/crowdsale/PhaseCrowdsaleInterface.sol
1974 
1975 /**
1976  * @title PhaseCrowdsaleInterface
1977  * @dev PhaseCrowdsaleInterface
1978  */
1979 contract PhaseCrowdsaleInterface {
1980      
1981   /**
1982   * @dev Get phase number depending on the current time
1983   */
1984   function getPhaseNumber() public view returns (uint256);
1985 
1986   /**
1987   * @dev Returns the current token price in $ cents depending on the current time
1988   */
1989   function getCurrentTokenPriceInCents() public view returns (uint256);
1990 
1991   /**
1992   * @dev Returns the token sale bonus percentage depending on the current time
1993   */
1994   function getCurrentBonusPercentage() public view returns (uint256);
1995 }
1996 
1997 // File: contracts/crowdsale/CryptonityCrowdsaleInterface.sol
1998 
1999 /**
2000  * @title CryptonityCrowdsaleInterface.
2001  * @dev CryptonityCrowdsaleInterface
2002  **/
2003 contract CryptonityCrowdsaleInterface {
2004   function processPurchase(address _beneficiary, uint256 _tokenAmount) public;
2005   function finalizationCallback(uint256 _usdRaised) public;
2006 }
2007 
2008 // File: contracts/crowdsale/OraclizeContract.sol
2009 
2010 /**
2011  * @title OraclizeCrowdsale
2012  * @dev OraclizeCrowdsale
2013  */
2014 // solium-disable-next-line max-len
2015 contract OraclizeCrowdsale is usingOraclize, MultiCurrencyRates {
2016   FiatContractInterface public fiatContract;
2017   PhaseCrowdsaleInterface public phaseCrowdsale;
2018   CryptonityCrowdsaleInterface private crowdsaleContract;
2019 
2020   // Amount of each currency raised
2021   uint256 public btcRaised;
2022   uint256 public ltcRaised;
2023   uint256 public bnbRaised;
2024   uint256 public bchRaised;
2025 
2026   enum OraclizeState { ForPurchase, ForFinalization }
2027   struct OraclizeCallback {
2028     address ethWallet;
2029     string currencyWallet;
2030     uint256 currencyAmount;
2031     bool exist;
2032     OraclizeState oState;
2033   }
2034   struct MultiCurrencyInvestor {
2035     string currencyWallet;
2036     uint256 currencyAmount;
2037   }
2038   mapping(bytes32 => OraclizeCallback) public oraclizeCallbacks;
2039   mapping(bytes32 => MultiCurrencyInvestor) public multiCurrencyInvestors;
2040 
2041   event LogInfo(string description);
2042   event LogError(string description);
2043   event LogCurrencyRateReceived(uint256 rate);
2044 
2045   constructor(
2046     address _fiatContract,
2047     address _phaseCrowdsale
2048     )
2049     public
2050       MultiCurrencyRates(_fiatContract)
2051   {
2052     phaseCrowdsale = PhaseCrowdsaleInterface(_phaseCrowdsale);
2053     // warning! delete next line on production, it needs only for testing
2054     // OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
2055     oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
2056   }
2057 
2058   /**
2059    * @dev Reverts if caller isn't oraclizeContract
2060    */
2061   modifier onlyCrowdsaleContract {
2062     require(msg.sender == address(crowdsaleContract));
2063     _;
2064   }
2065 
2066   /**
2067   * @dev Charge the contract balance to spend wei as Oraclize transaction fees.
2068   */
2069   function chargeBalance() public payable onlyOwner {
2070     //nothing to be done.
2071   }
2072 
2073   function setCrowdsaleContract(address _crowdsaleContract) public onlyOwner {
2074     crowdsaleContract = CryptonityCrowdsaleInterface(_crowdsaleContract);
2075   }
2076 
2077     /**
2078    * @dev Get hashed currency address.
2079    * @param _wallet Address of currency wallet
2080    * @return Hash
2081    */
2082   function getHashedCurrencyWalletAddress(string _wallet) private pure returns(bytes32) {
2083     return keccak256(abi.encodePacked(_wallet));
2084   }
2085 
2086   /**
2087    * @dev Oraclize query
2088    * @param _oraclizeUrl query URL
2089    * @param _ethWallet Address receiving the tokens
2090    * @param _currencyWallet Currency address who paid for the tokens
2091    * @param _currencyAmount Value in currency involved in the purchase
2092    * @param _oState oraclize state for separation in callback
2093    */
2094   // solium-disable-next-line max-len
2095   function oraclizeCreateQuery(string _oraclizeUrl, address _ethWallet, string _currencyWallet, uint256 _currencyAmount, OraclizeState _oState) private {
2096     // Check if we have enough remaining funds
2097     if (oraclize_getPrice("URL") > address(this).balance) {
2098       emit LogError("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
2099       revert();
2100     } else {
2101       emit LogInfo("Oraclize query was sent, standing by for the answer..");
2102       bytes32 queryId;
2103       if(_oState == OraclizeState.ForFinalization) {
2104         queryId = oraclize_query("URL", _oraclizeUrl, 500000);
2105       } else {
2106         queryId = oraclize_query("URL", _oraclizeUrl);
2107       }
2108       // add query ID to mapping
2109       oraclizeCallbacks[queryId] = OraclizeCallback(_ethWallet, _currencyWallet, _currencyAmount, true, _oState);
2110     }
2111   }
2112 
2113     /**
2114    * @dev Token purchase with BNB
2115    * @param _ethWallet Address receiving the tokens
2116    * @param _bnbWallet BNB address who paid for the tokens
2117    * @param _bnbAmount Value in BNB involved in the purchase
2118    */
2119   function buyTokensWithBNB(address _ethWallet, string _bnbWallet, uint256 _bnbAmount) public payable onlyCrowdsaleContract {
2120     require(_ethWallet != address(0));
2121     oraclizeCreateQuery(
2122       "json(https://min-api.cryptocompare.com/data/price?fsym=BNB&tsyms=USD).USD",
2123       _ethWallet,
2124       _bnbWallet,
2125       _bnbAmount,
2126       OraclizeState.ForPurchase
2127     );
2128     bnbRaised = bnbRaised.add(_bnbAmount);
2129   }
2130 
2131   /**
2132    * @dev Token purchase with BCH
2133    * @param _ethWallet Address receiving the tokens
2134    * @param _bchWallet BCH address who paid for the tokens
2135    * @param _bchAmount Value in BCH involved in the purchase
2136    */
2137   function buyTokensWithBCH(address _ethWallet, string _bchWallet, uint256 _bchAmount) public payable onlyCrowdsaleContract {
2138     require(_ethWallet != address(0));
2139     oraclizeCreateQuery(
2140       "json(https://min-api.cryptocompare.com/data/price?fsym=BCH&tsyms=USD).USD",
2141       _ethWallet,
2142       _bchWallet,
2143       _bchAmount,
2144       OraclizeState.ForPurchase
2145     );
2146     bchRaised = bchRaised.add(_bchAmount);
2147   }
2148 
2149     /**
2150    * @dev Token purchase with BTC
2151    * @param _ethWallet Address receiving the tokens
2152    * @param _btcWallet BTC address who paid for the tokens
2153    * @param _btcAmount Value in BTC involved in the purchase
2154    */
2155   function buyTokensWithBTC(address _ethWallet, string _btcWallet, uint256 _btcAmount) public onlyCrowdsaleContract {
2156     require(_ethWallet != address(0));
2157     performPurchaseWithSpecificCurrency(_ethWallet, _btcWallet, _btcAmount, getUSDCentToBTCSatoshiRate().mul(1 ether));
2158     btcRaised = btcRaised.add(_btcAmount);
2159   }
2160 
2161   /**
2162    * @dev Token purchase with LTC
2163    * @param _ethWallet Address receiving the tokens
2164    * @param _ltcWallet LTC address who paid for the tokens
2165    * @param _ltcAmount Value in LTC involved in the purchase
2166    */
2167   function buyTokensWithLTC(address _ethWallet, string _ltcWallet, uint256 _ltcAmount) public onlyCrowdsaleContract {
2168     require(_ethWallet != address(0));
2169     performPurchaseWithSpecificCurrency(_ethWallet, _ltcWallet, _ltcAmount, getUSDCentToLTCSatoshiRate().mul(1 ether));
2170     ltcRaised = ltcRaised.add(_ltcAmount);
2171   }
2172 
2173   /**
2174    * @dev Finalization logic.
2175    * Burn the remaining tokens.
2176    * Transfer token ownership to contract owner.
2177    */
2178   function finalize() public onlyCrowdsaleContract {
2179     oraclizeCreateQuery(
2180       "json(https://min-api.cryptocompare.com/data/pricemulti?fsyms=BNB,BCH&tsyms=USD).$",
2181       address(0),
2182       " ",
2183       0,
2184       OraclizeState.ForFinalization
2185     );
2186   }
2187 
2188   /**
2189    * @dev Perform token purchase with specific currency
2190    * @param _ethWallet Address receiving the tokens
2191    * @param _currencyWallet Currency address who paid for the tokens
2192    * @param _currencyAmount Value in currency involved in the purchase
2193    * @param _rate Number of token units a buyer gets per wei
2194    */
2195   function performPurchaseWithSpecificCurrency(address _ethWallet, string _currencyWallet, uint256 _currencyAmount, uint256 _rate)
2196     private
2197   {
2198     //added multiplier 10^18 to nullify divisor from _callback
2199 
2200     uint256 token = _currencyAmount.mul(1 ether).mul(1 ether).div(_rate).div(phaseCrowdsale.getCurrentTokenPriceInCents());
2201     crowdsaleContract.processPurchase(_ethWallet, token);
2202 
2203     //add investors
2204     bytes32 hashedCurrencyWalletAddress = getHashedCurrencyWalletAddress(_currencyWallet);
2205     multiCurrencyInvestors[hashedCurrencyWalletAddress] = MultiCurrencyInvestor(
2206       _currencyWallet,
2207       multiCurrencyInvestors[hashedCurrencyWalletAddress].currencyAmount.add(_currencyAmount)
2208     );
2209   }
2210 
2211   /**
2212   * @dev Oraclizer callback
2213   * @param queryId Query ID
2214   * @param result Query result
2215   * @param proof Proof
2216   */
2217   function __callback(bytes32 queryId, string result, bytes proof) public {
2218     require(msg.sender == oraclize_cbAddress());
2219     require(oraclizeCallbacks[queryId].exist);
2220 
2221     OraclizeCallback memory cb = oraclizeCallbacks[queryId];
2222 
2223     if (cb.oState == OraclizeState.ForPurchase) {
2224       uint256 usdCentToCurrencyRate = parseInt(result, 2);
2225       uint256 currencyToUSDCentRate = uint256(1 ether).div(usdCentToCurrencyRate);
2226       emit LogCurrencyRateReceived(usdCentToCurrencyRate);
2227 
2228       performPurchaseWithSpecificCurrency(
2229         cb.ethWallet,
2230         cb.currencyWallet,
2231         cb.currencyAmount,
2232         currencyToUSDCentRate
2233       );
2234 
2235     } else if (cb.oState == OraclizeState.ForFinalization) {
2236       uint256 usdRaised = calculateCur(result);
2237       crowdsaleContract.finalizationCallback(usdRaised);
2238     }
2239 
2240     // this ensures the callback for a given queryID never called twice
2241     delete oraclizeCallbacks[queryId];
2242   }
2243 
2244   function calculateCur(string oraclizeResult) private view returns (uint256) {
2245     uint256 usdRaised = btcRaised.div(getUSDCentToBTCSatoshiRate())
2246       .add(ltcRaised.div(getUSDCentToLTCSatoshiRate()))
2247       .add(bnbRaised.mul(getBNBToUSDCentRate(oraclizeResult)))
2248       .add(bchRaised.mul(getBCHToUSDCentRate(oraclizeResult)));
2249     return usdRaised;
2250   }
2251     /**
2252    * @dev Get multi currency investor contribution.
2253    * @param _currencyWallet Address of currency wallet
2254    * @return Amount of currency contribution
2255    */
2256   function getMultiCurrencyInvestorContribution(string _currencyWallet) public view returns(uint256) {
2257     bytes32 hashedCurrencyWalletAddress = getHashedCurrencyWalletAddress(_currencyWallet);
2258     return  multiCurrencyInvestors[hashedCurrencyWalletAddress].currencyAmount;
2259   }
2260 }