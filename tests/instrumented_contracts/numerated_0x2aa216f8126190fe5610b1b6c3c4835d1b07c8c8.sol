1 pragma solidity 0.4.23;
2 
3 // File: contracts/oraclize/usingOraclize.sol
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
1051 // File: mixbytes-solidity/contracts/ownership/multiowned.sol
1052 
1053 // Copyright (C) 2017  MixBytes, LLC
1054 
1055 // Licensed under the Apache License, Version 2.0 (the "License").
1056 // You may not use this file except in compliance with the License.
1057 
1058 // Unless required by applicable law or agreed to in writing, software
1059 // distributed under the License is distributed on an "AS IS" BASIS,
1060 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
1061 
1062 // Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
1063 // Audit, refactoring and improvements by github.com/Eenae
1064 
1065 // @authors:
1066 // Gav Wood <g@ethdev.com>
1067 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
1068 // single, or, crucially, each of a number of, designated owners.
1069 // usage:
1070 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
1071 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
1072 // interior is executed.
1073 
1074 pragma solidity ^0.4.15;
1075 
1076 
1077 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
1078 // TODO acceptOwnership
1079 contract multiowned {
1080 
1081 	// TYPES
1082 
1083     // struct for the status of a pending operation.
1084     struct MultiOwnedOperationPendingState {
1085         // count of confirmations needed
1086         uint yetNeeded;
1087 
1088         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
1089         uint ownersDone;
1090 
1091         // position of this operation key in m_multiOwnedPendingIndex
1092         uint index;
1093     }
1094 
1095 	// EVENTS
1096 
1097     event Confirmation(address owner, bytes32 operation);
1098     event Revoke(address owner, bytes32 operation);
1099     event FinalConfirmation(address owner, bytes32 operation);
1100 
1101     // some others are in the case of an owner changing.
1102     event OwnerChanged(address oldOwner, address newOwner);
1103     event OwnerAdded(address newOwner);
1104     event OwnerRemoved(address oldOwner);
1105 
1106     // the last one is emitted if the required signatures change
1107     event RequirementChanged(uint newRequirement);
1108 
1109 	// MODIFIERS
1110 
1111     // simple single-sig function modifier.
1112     modifier onlyowner {
1113         require(isOwner(msg.sender));
1114         _;
1115     }
1116     // multi-sig function modifier: the operation must have an intrinsic hash in order
1117     // that later attempts can be realised as the same underlying operation and
1118     // thus count as confirmations.
1119     modifier onlymanyowners(bytes32 _operation) {
1120         if (confirmAndCheck(_operation)) {
1121             _;
1122         }
1123         // Even if required number of confirmations has't been collected yet,
1124         // we can't throw here - because changes to the state have to be preserved.
1125         // But, confirmAndCheck itself will throw in case sender is not an owner.
1126     }
1127 
1128     modifier validNumOwners(uint _numOwners) {
1129         require(_numOwners > 0 && _numOwners <= c_maxOwners);
1130         _;
1131     }
1132 
1133     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
1134         require(_required > 0 && _required <= _numOwners);
1135         _;
1136     }
1137 
1138     modifier ownerExists(address _address) {
1139         require(isOwner(_address));
1140         _;
1141     }
1142 
1143     modifier ownerDoesNotExist(address _address) {
1144         require(!isOwner(_address));
1145         _;
1146     }
1147 
1148     modifier multiOwnedOperationIsActive(bytes32 _operation) {
1149         require(isOperationActive(_operation));
1150         _;
1151     }
1152 
1153 	// METHODS
1154 
1155     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
1156     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
1157     function multiowned(address[] _owners, uint _required)
1158         public
1159         validNumOwners(_owners.length)
1160         multiOwnedValidRequirement(_required, _owners.length)
1161     {
1162         assert(c_maxOwners <= 255);
1163 
1164         m_numOwners = _owners.length;
1165         m_multiOwnedRequired = _required;
1166 
1167         for (uint i = 0; i < _owners.length; ++i)
1168         {
1169             address owner = _owners[i];
1170             // invalid and duplicate addresses are not allowed
1171             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
1172 
1173             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
1174             m_owners[currentOwnerIndex] = owner;
1175             m_ownerIndex[owner] = currentOwnerIndex;
1176         }
1177 
1178         assertOwnersAreConsistent();
1179     }
1180 
1181     /// @notice replaces an owner `_from` with another `_to`.
1182     /// @param _from address of owner to replace
1183     /// @param _to address of new owner
1184     // All pending operations will be canceled!
1185     function changeOwner(address _from, address _to)
1186         external
1187         ownerExists(_from)
1188         ownerDoesNotExist(_to)
1189         onlymanyowners(keccak256(msg.data))
1190     {
1191         assertOwnersAreConsistent();
1192 
1193         clearPending();
1194         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
1195         m_owners[ownerIndex] = _to;
1196         m_ownerIndex[_from] = 0;
1197         m_ownerIndex[_to] = ownerIndex;
1198 
1199         assertOwnersAreConsistent();
1200         OwnerChanged(_from, _to);
1201     }
1202 
1203     /// @notice adds an owner
1204     /// @param _owner address of new owner
1205     // All pending operations will be canceled!
1206     function addOwner(address _owner)
1207         external
1208         ownerDoesNotExist(_owner)
1209         validNumOwners(m_numOwners + 1)
1210         onlymanyowners(keccak256(msg.data))
1211     {
1212         assertOwnersAreConsistent();
1213 
1214         clearPending();
1215         m_numOwners++;
1216         m_owners[m_numOwners] = _owner;
1217         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
1218 
1219         assertOwnersAreConsistent();
1220         OwnerAdded(_owner);
1221     }
1222 
1223     /// @notice removes an owner
1224     /// @param _owner address of owner to remove
1225     // All pending operations will be canceled!
1226     function removeOwner(address _owner)
1227         external
1228         ownerExists(_owner)
1229         validNumOwners(m_numOwners - 1)
1230         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
1231         onlymanyowners(keccak256(msg.data))
1232     {
1233         assertOwnersAreConsistent();
1234 
1235         clearPending();
1236         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
1237         m_owners[ownerIndex] = 0;
1238         m_ownerIndex[_owner] = 0;
1239         //make sure m_numOwners is equal to the number of owners and always points to the last owner
1240         reorganizeOwners();
1241 
1242         assertOwnersAreConsistent();
1243         OwnerRemoved(_owner);
1244     }
1245 
1246     /// @notice changes the required number of owner signatures
1247     /// @param _newRequired new number of signatures required
1248     // All pending operations will be canceled!
1249     function changeRequirement(uint _newRequired)
1250         external
1251         multiOwnedValidRequirement(_newRequired, m_numOwners)
1252         onlymanyowners(keccak256(msg.data))
1253     {
1254         m_multiOwnedRequired = _newRequired;
1255         clearPending();
1256         RequirementChanged(_newRequired);
1257     }
1258 
1259     /// @notice Gets an owner by 0-indexed position
1260     /// @param ownerIndex 0-indexed owner position
1261     function getOwner(uint ownerIndex) public constant returns (address) {
1262         return m_owners[ownerIndex + 1];
1263     }
1264 
1265     /// @notice Gets owners
1266     /// @return memory array of owners
1267     function getOwners() public constant returns (address[]) {
1268         address[] memory result = new address[](m_numOwners);
1269         for (uint i = 0; i < m_numOwners; i++)
1270             result[i] = getOwner(i);
1271 
1272         return result;
1273     }
1274 
1275     /// @notice checks if provided address is an owner address
1276     /// @param _addr address to check
1277     /// @return true if it's an owner
1278     function isOwner(address _addr) public constant returns (bool) {
1279         return m_ownerIndex[_addr] > 0;
1280     }
1281 
1282     /// @notice Tests ownership of the current caller.
1283     /// @return true if it's an owner
1284     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
1285     // addOwner/changeOwner and to isOwner.
1286     function amIOwner() external constant onlyowner returns (bool) {
1287         return true;
1288     }
1289 
1290     /// @notice Revokes a prior confirmation of the given operation
1291     /// @param _operation operation value, typically keccak256(msg.data)
1292     function revoke(bytes32 _operation)
1293         external
1294         multiOwnedOperationIsActive(_operation)
1295         onlyowner
1296     {
1297         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
1298         var pending = m_multiOwnedPending[_operation];
1299         require(pending.ownersDone & ownerIndexBit > 0);
1300 
1301         assertOperationIsConsistent(_operation);
1302 
1303         pending.yetNeeded++;
1304         pending.ownersDone -= ownerIndexBit;
1305 
1306         assertOperationIsConsistent(_operation);
1307         Revoke(msg.sender, _operation);
1308     }
1309 
1310     /// @notice Checks if owner confirmed given operation
1311     /// @param _operation operation value, typically keccak256(msg.data)
1312     /// @param _owner an owner address
1313     function hasConfirmed(bytes32 _operation, address _owner)
1314         external
1315         constant
1316         multiOwnedOperationIsActive(_operation)
1317         ownerExists(_owner)
1318         returns (bool)
1319     {
1320         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
1321     }
1322 
1323     // INTERNAL METHODS
1324 
1325     function confirmAndCheck(bytes32 _operation)
1326         private
1327         onlyowner
1328         returns (bool)
1329     {
1330         if (512 == m_multiOwnedPendingIndex.length)
1331             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
1332             // we won't be able to do it because of block gas limit.
1333             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
1334             // TODO use more graceful approach like compact or removal of clearPending completely
1335             clearPending();
1336 
1337         var pending = m_multiOwnedPending[_operation];
1338 
1339         // if we're not yet working on this operation, switch over and reset the confirmation status.
1340         if (! isOperationActive(_operation)) {
1341             // reset count of confirmations needed.
1342             pending.yetNeeded = m_multiOwnedRequired;
1343             // reset which owners have confirmed (none) - set our bitmap to 0.
1344             pending.ownersDone = 0;
1345             pending.index = m_multiOwnedPendingIndex.length++;
1346             m_multiOwnedPendingIndex[pending.index] = _operation;
1347             assertOperationIsConsistent(_operation);
1348         }
1349 
1350         // determine the bit to set for this owner.
1351         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
1352         // make sure we (the message sender) haven't confirmed this operation previously.
1353         if (pending.ownersDone & ownerIndexBit == 0) {
1354             // ok - check if count is enough to go ahead.
1355             assert(pending.yetNeeded > 0);
1356             if (pending.yetNeeded == 1) {
1357                 // enough confirmations: reset and run interior.
1358                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
1359                 delete m_multiOwnedPending[_operation];
1360                 FinalConfirmation(msg.sender, _operation);
1361                 return true;
1362             }
1363             else
1364             {
1365                 // not enough: record that this owner in particular confirmed.
1366                 pending.yetNeeded--;
1367                 pending.ownersDone |= ownerIndexBit;
1368                 assertOperationIsConsistent(_operation);
1369                 Confirmation(msg.sender, _operation);
1370             }
1371         }
1372     }
1373 
1374     // Reclaims free slots between valid owners in m_owners.
1375     // TODO given that its called after each removal, it could be simplified.
1376     function reorganizeOwners() private {
1377         uint free = 1;
1378         while (free < m_numOwners)
1379         {
1380             // iterating to the first free slot from the beginning
1381             while (free < m_numOwners && m_owners[free] != 0) free++;
1382 
1383             // iterating to the first occupied slot from the end
1384             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
1385 
1386             // swap, if possible, so free slot is located at the end after the swap
1387             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
1388             {
1389                 // owners between swapped slots should't be renumbered - that saves a lot of gas
1390                 m_owners[free] = m_owners[m_numOwners];
1391                 m_ownerIndex[m_owners[free]] = free;
1392                 m_owners[m_numOwners] = 0;
1393             }
1394         }
1395     }
1396 
1397     function clearPending() private onlyowner {
1398         uint length = m_multiOwnedPendingIndex.length;
1399         // TODO block gas limit
1400         for (uint i = 0; i < length; ++i) {
1401             if (m_multiOwnedPendingIndex[i] != 0)
1402                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
1403         }
1404         delete m_multiOwnedPendingIndex;
1405     }
1406 
1407     function checkOwnerIndex(uint ownerIndex) private pure returns (uint) {
1408         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
1409         return ownerIndex;
1410     }
1411 
1412     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
1413         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
1414         return 2 ** ownerIndex;
1415     }
1416 
1417     function isOperationActive(bytes32 _operation) private constant returns (bool) {
1418         return 0 != m_multiOwnedPending[_operation].yetNeeded;
1419     }
1420 
1421 
1422     function assertOwnersAreConsistent() private constant {
1423         assert(m_numOwners > 0);
1424         assert(m_numOwners <= c_maxOwners);
1425         assert(m_owners[0] == 0);
1426         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
1427     }
1428 
1429     function assertOperationIsConsistent(bytes32 _operation) private constant {
1430         var pending = m_multiOwnedPending[_operation];
1431         assert(0 != pending.yetNeeded);
1432         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
1433         assert(pending.yetNeeded <= m_multiOwnedRequired);
1434     }
1435 
1436 
1437    	// FIELDS
1438 
1439     uint constant c_maxOwners = 250;
1440 
1441     // the number of owners that must confirm the same operation before it is run.
1442     uint public m_multiOwnedRequired;
1443 
1444 
1445     // pointer used to find a free slot in m_owners
1446     uint public m_numOwners;
1447 
1448     // list of owners (addresses),
1449     // slot 0 is unused so there are no owner which index is 0.
1450     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
1451     address[256] internal m_owners;
1452 
1453     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
1454     mapping(address => uint) internal m_ownerIndex;
1455 
1456 
1457     // the ongoing operations.
1458     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
1459     bytes32[] internal m_multiOwnedPendingIndex;
1460 }
1461 
1462 // File: zeppelin-solidity/contracts/math/SafeMath.sol
1463 
1464 /**
1465  * @title SafeMath
1466  * @dev Math operations with safety checks that throw on error
1467  */
1468 library SafeMath {
1469   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
1470     uint256 c = a * b;
1471     assert(a == 0 || c / a == b);
1472     return c;
1473   }
1474 
1475   function div(uint256 a, uint256 b) internal constant returns (uint256) {
1476     // assert(b > 0); // Solidity automatically throws when dividing by 0
1477     uint256 c = a / b;
1478     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1479     return c;
1480   }
1481 
1482   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
1483     assert(b <= a);
1484     return a - b;
1485   }
1486 
1487   function add(uint256 a, uint256 b) internal constant returns (uint256) {
1488     uint256 c = a + b;
1489     assert(c >= a);
1490     return c;
1491   }
1492 }
1493 
1494 // File: contracts/EthPriceDependent.sol
1495 
1496 contract EthPriceDependent is usingOraclize, multiowned {
1497 
1498     using SafeMath for uint256;
1499 
1500     event NewOraclizeQuery(string description);
1501     event NewETHPrice(uint price);
1502     event ETHPriceOutOfBounds(uint price);
1503 
1504     /// @notice Constructor
1505     /// @param _initialOwners set owners, which can control bounds and things
1506     ///        described in the actual sale contract, inherited from this one
1507     /// @param _consensus Number of votes enough to make a decision
1508     /// @param _production True if on mainnet and testnet
1509     function EthPriceDependent(address[] _initialOwners,  uint _consensus, bool _production)
1510         public
1511         multiowned(_initialOwners, _consensus)
1512     {
1513         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1514         if (!_production) {
1515             // Use it when testing with testrpc and etherium bridge. Don't forget to change address
1516             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1517         } else {
1518             // Don't call this while testing as it's too long and gets in the way
1519             updateETHPriceInCents();
1520         }
1521     }
1522 
1523     /// @notice Send oraclize query.
1524     /// if price is received successfully - update scheduled automatically,
1525     /// if at any point the contract runs out of ether - updating stops and further
1526     /// updating will require running this function again.
1527     /// if price is out of bounds - updating attempts continue
1528     function updateETHPriceInCents() public payable {
1529         // prohibit running multiple instances of update
1530         // however don't throw any error, because it's called from __callback as well
1531         // and we need to let it update the price anyway, otherwise there is an attack possibility
1532         if ( !updateRequestExpired() ) {
1533             NewOraclizeQuery("Oraclize request fail. Previous one still pending");
1534         } else if (oraclize_getPrice("URL") > this.balance) {
1535             NewOraclizeQuery("Oraclize request fail. Not enough ether");
1536         } else {
1537             oraclize_query(
1538                 m_ETHPriceUpdateInterval,
1539                 "URL",
1540                 "json(https://api.coinmarketcap.com/v1/ticker/ethereum/?convert=USD).0.price_usd",
1541                 m_callbackGas
1542             );
1543             m_ETHPriceLastUpdateRequest = getTime();
1544             NewOraclizeQuery("Oraclize query was sent");
1545         }
1546     }
1547 
1548     /// @notice Called on ETH price update by Oraclize
1549     function __callback(bytes32 myid, string result, bytes proof) public {
1550         require(msg.sender == oraclize_cbAddress());
1551 
1552         uint newPrice = parseInt(result).mul(100);
1553 
1554         if (newPrice >= m_ETHPriceLowerBound && newPrice <= m_ETHPriceUpperBound) {
1555             m_ETHPriceInCents = newPrice;
1556             m_ETHPriceLastUpdate = getTime();
1557             NewETHPrice(m_ETHPriceInCents);
1558         } else {
1559             ETHPriceOutOfBounds(newPrice);
1560         }
1561         // continue updating anyway (if current price was out of bounds, the price might recover in the next cycle)
1562         updateETHPriceInCents();
1563     }
1564 
1565     /// @notice set the limit of ETH in cents, oraclize data greater than this is not accepted
1566     /// @param _price Price in US cents
1567     function setETHPriceUpperBound(uint _price)
1568         external
1569         onlymanyowners(keccak256(msg.data))
1570     {
1571         m_ETHPriceUpperBound = _price;
1572     }
1573 
1574     /// @notice set the limit of ETH in cents, oraclize data smaller than this is not accepted
1575     /// @param _price Price in US cents
1576     function setETHPriceLowerBound(uint _price)
1577         external
1578         onlymanyowners(keccak256(msg.data))
1579     {
1580         m_ETHPriceLowerBound = _price;
1581     }
1582 
1583     /// @notice set the price of ETH in cents, called in case we don't get oraclize data
1584     ///         for more than double the update interval
1585     /// @param _price Price in US cents
1586     function setETHPriceManually(uint _price)
1587         external
1588         onlymanyowners(keccak256(msg.data))
1589     {
1590         // allow for owners to change the price anytime if update is not running
1591         // but if it is, then only in case the price has expired
1592         require( priceExpired() || updateRequestExpired() );
1593         m_ETHPriceInCents = _price;
1594         m_ETHPriceLastUpdate = getTime();
1595         NewETHPrice(m_ETHPriceInCents);
1596     }
1597 
1598     /// @notice add more ether to use in oraclize queries
1599     function topUp() external payable {
1600     }
1601 
1602     /// @dev change gas price for oraclize calls,
1603     ///      should be a compromise between speed and price according to market
1604     /// @param _gasPrice gas price in wei
1605     function setOraclizeGasPrice(uint _gasPrice)
1606         external
1607         onlymanyowners(keccak256(msg.data))
1608     {
1609         oraclize_setCustomGasPrice(_gasPrice);
1610     }
1611 
1612     /// @dev change gas limit for oraclize callback
1613     ///      note: should be changed only in case of emergency
1614     /// @param _callbackGas amount of gas
1615     function setOraclizeGasLimit(uint _callbackGas)
1616         external
1617         onlymanyowners(keccak256(msg.data))
1618     {
1619         m_callbackGas = _callbackGas;
1620     }
1621 
1622     /// @dev Check that double the update interval has passed
1623     ///      since last successful price update
1624     function priceExpired() public view returns (bool) {
1625         return (getTime() > m_ETHPriceLastUpdate + 2 * m_ETHPriceUpdateInterval);
1626     }
1627 
1628     /// @dev Check that price update was requested
1629     ///      more than 1 update interval ago
1630     ///      NOTE: m_leeway seconds added to offset possible timestamp inaccuracy
1631     function updateRequestExpired() public view returns (bool) {
1632         return ( (getTime() + m_leeway) >= (m_ETHPriceLastUpdateRequest + m_ETHPriceUpdateInterval) );
1633     }
1634 
1635     /// @dev to be overridden in tests
1636     function getTime() internal view returns (uint) {
1637         return now;
1638     }
1639 
1640     // FIELDS
1641 
1642     /// @notice usd price of ETH in cents, retrieved using oraclize
1643     uint public m_ETHPriceInCents = 0;
1644     /// @notice unix timestamp of last update
1645     uint public m_ETHPriceLastUpdate;
1646     /// @notice unix timestamp of last update request,
1647     ///         don't allow requesting more than once per update interval
1648     uint public m_ETHPriceLastUpdateRequest;
1649 
1650     /// @notice lower bound of the ETH price in cents
1651     uint public m_ETHPriceLowerBound = 100;
1652     /// @notice upper bound of the ETH price in cents
1653     uint public m_ETHPriceUpperBound = 100000000;
1654 
1655     /// @dev Update ETH price in cents every 12 hours
1656     uint public m_ETHPriceUpdateInterval = 60*60*12;
1657 
1658     /// @dev offset time inaccuracy when checking update expiration date
1659     uint public m_leeway = 30; // 30 seconds
1660 
1661     /// @dev set just enough gas because the rest is not refunded
1662     ///      (should be ~105000, additional 5000 just in case)
1663     uint public m_callbackGas = 110000;
1664 }
1665 
1666 // File: contracts/IBoomstarterToken.sol
1667 
1668 /// @title Interface of the BoomstarterToken.
1669 interface IBoomstarterToken {
1670     // multiowned
1671     function changeOwner(address _from, address _to) external;
1672     function addOwner(address _owner) external;
1673     function removeOwner(address _owner) external;
1674     function changeRequirement(uint _newRequired) external;
1675     function getOwner(uint ownerIndex) public view returns (address);
1676     function getOwners() public view returns (address[]);
1677     function isOwner(address _addr) public view returns (bool);
1678     function amIOwner() external view returns (bool);
1679     function revoke(bytes32 _operation) external;
1680     function hasConfirmed(bytes32 _operation, address _owner) external view returns (bool);
1681 
1682     // ERC20Basic
1683     function totalSupply() public view returns (uint256);
1684     function balanceOf(address who) public view returns (uint256);
1685     function transfer(address to, uint256 value) public returns (bool);
1686 
1687     // ERC20
1688     function allowance(address owner, address spender) public view returns (uint256);
1689     function transferFrom(address from, address to, uint256 value) public returns (bool);
1690     function approve(address spender, uint256 value) public returns (bool);
1691 
1692     function name() public view returns (string);
1693     function symbol() public view returns (string);
1694     function decimals() public view returns (uint8);
1695 
1696     // BurnableToken
1697     function burn(uint256 _amount) public returns (bool);
1698 
1699     // TokenWithApproveAndCallMethod
1700     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public;
1701 
1702     // BoomstarterToken
1703     function setSale(address account, bool isSale) external;
1704     function switchToNextSale(address _newSale) external;
1705     function thaw() external;
1706     function disablePrivileged() external;
1707 
1708 }
1709 
1710 // File: mixbytes-solidity/contracts/security/ArgumentsChecker.sol
1711 
1712 // Copyright (C) 2017  MixBytes, LLC
1713 
1714 // Licensed under the Apache License, Version 2.0 (the "License").
1715 // You may not use this file except in compliance with the License.
1716 
1717 // Unless required by applicable law or agreed to in writing, software
1718 // distributed under the License is distributed on an "AS IS" BASIS,
1719 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
1720 
1721 pragma solidity ^0.4.15;
1722 
1723 
1724 /// @title utility methods and modifiers of arguments validation
1725 contract ArgumentsChecker {
1726 
1727     /// @dev check which prevents short address attack
1728     modifier payloadSizeIs(uint size) {
1729        require(msg.data.length == size + 4 /* function selector */);
1730        _;
1731     }
1732 
1733     /// @dev check that address is valid
1734     modifier validAddress(address addr) {
1735         require(addr != address(0));
1736         _;
1737     }
1738 }
1739 
1740 // File: zeppelin-solidity/contracts/ReentrancyGuard.sol
1741 
1742 /**
1743  * @title Helps contracts guard agains rentrancy attacks.
1744  * @author Remco Bloemen <remco@2π.com>
1745  * @notice If you mark a function `nonReentrant`, you should also
1746  * mark it `external`.
1747  */
1748 contract ReentrancyGuard {
1749 
1750   /**
1751    * @dev We use a single lock for the whole contract.
1752    */
1753   bool private rentrancy_lock = false;
1754 
1755   /**
1756    * @dev Prevents a contract from calling itself, directly or indirectly.
1757    * @notice If you mark a function `nonReentrant`, you should also
1758    * mark it `external`. Calling one nonReentrant function from
1759    * another is not supported. Instead, you can implement a
1760    * `private` function doing the actual work, and a `external`
1761    * wrapper marked as `nonReentrant`.
1762    */
1763   modifier nonReentrant() {
1764     require(!rentrancy_lock);
1765     rentrancy_lock = true;
1766     _;
1767     rentrancy_lock = false;
1768   }
1769 
1770 }
1771 
1772 // File: contracts/BoomstarterPresale.sol
1773 
1774 /// @title Boomstarter pre-sale contract
1775 contract BoomstarterPresale is ArgumentsChecker, ReentrancyGuard, EthPriceDependent {
1776     using SafeMath for uint256;
1777 
1778     event FundTransfer(address backer, uint amount, bool isContribution);
1779 
1780     /// @dev checks that owners didn't finish the sale yet
1781     modifier onlyIfSaleIsActive() {
1782         require(m_active == true);
1783         _;
1784     }
1785 
1786     /**
1787      *  @dev checks that finish date is not reached yet
1788      *       (and potentially start date, but not needed for presale)
1789      *       AND also that the limits for the sale are not met
1790      *       AND that current price is non-zero (updated)
1791      */
1792     modifier checkLimitsAndDates() {
1793         require((c_dateTo >= getTime()) &&
1794                 (m_currentTokensSold < c_maximumTokensSold) &&
1795                 (m_ETHPriceInCents > 0));
1796         _;
1797     }
1798 
1799     /**
1800      * @dev constructor, payable to fund oraclize calls
1801      * @param _owners Addresses to do administrative actions
1802      * @param _token Address of token being sold in this presale
1803      * @param _beneficiary Address of the wallet, receiving all the collected ether
1804      * @param _production False if you use testrpc, true if mainnet and most testnets
1805      */
1806     function BoomstarterPresale(address[] _owners, address _token,
1807                                 address _beneficiary, bool _production)
1808         public
1809         payable
1810         EthPriceDependent(_owners, 2, _production)
1811         validAddress(_token)
1812         validAddress(_beneficiary)
1813     {
1814         m_token = IBoomstarterToken(_token);
1815         m_beneficiary = _beneficiary;
1816         m_active = true;
1817     }
1818 
1819 
1820     // PUBLIC interface: payments
1821 
1822     // fallback function as a shortcut
1823     function() payable {
1824         require(0 == msg.data.length);
1825         buy();  // only internal call here!
1826     }
1827 
1828     /**
1829      * @notice presale participation. Can buy tokens only in batches by one price
1830      *         if price changes mid-transaction, you'll get only the amount for initial price
1831      *         and the rest will be refunded
1832      */
1833     function buy()
1834         public
1835         payable
1836         nonReentrant
1837         onlyIfSaleIsActive
1838         checkLimitsAndDates
1839     {
1840         // don't allow to buy anything if price change was too long ago
1841         // effectively enforcing a sale pause
1842         require( !priceExpired() );
1843         address investor = msg.sender;
1844         uint256 payment = msg.value;
1845         require((payment.mul(m_ETHPriceInCents)).div(1 ether) >= c_MinInvestmentInCents);
1846 
1847         /**
1848          * calculate amount based on ETH/USD rate
1849          * for example 2e17 * 36900 / 30 = 246 * 1e18
1850          * 0.2 eth buys 246 tokens if Ether price is $369 and token price is 30 cents
1851          */
1852         uint tokenAmount;
1853         // either hard cap or the amount where prices change
1854         uint cap;
1855         // price of the batch of token bought
1856         uint centsPerToken;
1857         if (m_currentTokensSold < c_priceRiseTokenAmount) {
1858             centsPerToken = c_centsPerTokenFirst;
1859             // don't let price rise happen during this transaction - cap at price change value
1860             cap = c_priceRiseTokenAmount;
1861         } else {
1862             centsPerToken = c_centsPerTokenSecond;
1863             // capped by the presale cap itself
1864             cap = c_maximumTokensSold;
1865         }
1866 
1867         // amount that can be bought depending on the price
1868         tokenAmount = payment.mul(m_ETHPriceInCents).div(centsPerToken);
1869 
1870         // number of tokens available before the cap is reached
1871         uint maxTokensAllowed = cap.sub(m_currentTokensSold);
1872 
1873         // if amount of tokens we can buy is more than the amount available
1874         if (tokenAmount > maxTokensAllowed) {
1875             // price of 1 full token in ether-wei
1876             // example 30 * 1e18 / 36900 = 0.081 * 1e18 = 0.081 eth
1877             uint ethPerToken = centsPerToken.mul(1 ether).div(m_ETHPriceInCents);
1878             // change amount to maximum allowed
1879             tokenAmount = maxTokensAllowed;
1880             payment = ethPerToken.mul(tokenAmount).div(1 ether);
1881         }
1882 
1883         m_currentTokensSold = m_currentTokensSold.add(tokenAmount);
1884 
1885         // send ether to external wallet
1886         m_beneficiary.transfer(payment);
1887 
1888         m_token.transfer(investor, tokenAmount);
1889 
1890         uint change = msg.value.sub(payment);
1891         if (change > 0)
1892             investor.transfer(change);
1893 
1894         FundTransfer(investor, payment, true);
1895     }
1896 
1897 
1898     /**
1899      * @notice stop accepting ether, transfer remaining tokens to the next sale and
1900      *         give new sale permissions to transfer frozen funds and revoke own ones
1901      *         Can be called anytime, even before the set finish date
1902      */
1903     function finishSale()
1904         external
1905         onlyIfSaleIsActive
1906         onlymanyowners(keccak256(msg.data))
1907     {
1908         // next sale should be set using setNextSale
1909         require( m_nextSale != address(0) );
1910         // cannot accept ether anymore
1911         m_active = false;
1912         // send remaining oraclize ether to the next sale - we don't need oraclize anymore
1913         EthPriceDependent next = EthPriceDependent(m_nextSale);
1914         next.topUp.value(this.balance)();
1915         // transfer all remaining tokens to the next sale account
1916         m_token.transfer(m_nextSale, m_token.balanceOf(this));
1917         // mark next sale as a valid sale account, unmark self as valid sale account
1918         m_token.switchToNextSale(m_nextSale);
1919     }
1920 
1921     /**
1922      * @notice set address of a sale that will be next one after the current sale is finished
1923      * @param _sale address of the sale contract
1924      */
1925     function setNextSale(address _sale)
1926         external
1927         validAddress(_sale)
1928         onlymanyowners(keccak256(msg.data))
1929     {
1930         m_nextSale = _sale;
1931     }
1932 
1933 
1934     // FIELDS
1935 
1936     /// @notice minimum investment in cents
1937     uint public c_MinInvestmentInCents = 3000000; // $30k
1938 
1939     /// @dev contract responsible for token accounting
1940     IBoomstarterToken public m_token;
1941 
1942     /// @dev address receiving all the ether, no intentions to refund
1943     address public m_beneficiary;
1944 
1945     /// @dev next sale to receive remaining tokens after this one finishes
1946     address public m_nextSale;
1947 
1948     /// @dev active sale can accept ether, inactive - cannot
1949     bool public m_active;
1950 
1951     /**
1952      *  @dev unix timestamp that sets presale finish date, which means that after that date
1953      *       you cannot buy anything, but finish can happen before, if owners decide to do so
1954      */
1955     uint public c_dateTo = 1529064000; // 15-Jun-18 12:00:00 UTC
1956 
1957     /// @dev current amount of tokens sold
1958     uint public m_currentTokensSold = 0;
1959     /// @dev limit of tokens to be sold during presale
1960     uint public c_maximumTokensSold = uint(1500000) * uint(10) ** uint(18); // 1.5 million tokens
1961 
1962     /// @notice first step, usd price of BoomstarterToken in cents 
1963     uint public c_centsPerTokenFirst = 30; // $0.3
1964     /// @notice second step, usd price of BoomstarterToken in cents
1965     uint public c_centsPerTokenSecond = 40; // $0.4
1966     /// @notice amount of tokens sold at which price switch should happen
1967     uint public c_priceRiseTokenAmount = uint(666668) * uint(10) ** uint(18);
1968 }