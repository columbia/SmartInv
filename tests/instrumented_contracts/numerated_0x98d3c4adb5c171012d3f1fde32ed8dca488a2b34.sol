1 pragma solidity ^0.4.24;
2 
3 // File: oraclize-api/usingOraclize.sol
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
128     function __callback(bytes32 myid, string result) public{
129         __callback(myid, result, new bytes(0));
130     }
131     function __callback(bytes32 myid, string result, bytes proof) public{
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
1051 // File: contracts\Oracle.sol
1052 
1053 /**
1054 *The Oracle contract provides the reference prices for the contracts.  Currently the Oracle is 
1055 *updated by an off chain calculation by DDA.  Methodology can be found at 
1056 *www.github.com/DecentralizedDerivatives/Oracles
1057 */
1058 
1059 contract Oracle is usingOraclize{
1060     /*Variables*/
1061     //Private queryId for Oraclize callback
1062     bytes32 private queryID;
1063     string public API;
1064     string public API2;
1065     string public usedAPI;
1066 
1067     /*Structs*/
1068     struct QueryInfo {
1069         uint value;
1070         bool queried;
1071         uint date;
1072         uint calledTime;
1073         bool called;
1074     }  
1075     //Mapping of documents stored in the oracle
1076     mapping(uint => bytes32) public queryIds;
1077     mapping(bytes32 => QueryInfo ) public info;
1078 
1079     /*Events*/
1080     event DocumentStored(uint _key, uint _value);
1081     event newOraclizeQuery(string description);
1082 
1083     /*Functions*/
1084     /**
1085     *@dev Constructor, sets two public api strings
1086     *e.g. "json(https://api.gdax.com/products/BTC-USD/ticker).price"
1087     * "json(https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT).price"
1088     * or "json(https://api.gdax.com/products/ETH-USD/ticker).price"
1089     * "json(https://api.binance.com/api/v3/ticker/price?symbol=ETHUSDT).price"
1090     */
1091      constructor(string _api, string _api2) public{
1092         API = _api;
1093         API2 = _api2;
1094     }
1095 
1096     /**
1097     *@dev RetrieveData - Returns stored value by given key
1098     *@param _date Daily unix timestamp of key storing value (GMT 00:00:00)
1099     */
1100     function retrieveData(uint _date) public constant returns (uint) {
1101         QueryInfo storage currentQuery = info[queryIds[_date]];
1102         return currentQuery.value;
1103     }
1104 
1105     /**
1106     *@dev PushData - Sends an Oraclize query for entered API
1107     */
1108     function pushData() public payable{
1109         uint _key = now - (now % 86400);
1110         uint _calledTime = now;
1111         QueryInfo storage currentQuery = info[queryIds[_key]];
1112         require(currentQuery.queried == false  && currentQuery.calledTime == 0 || 
1113             currentQuery.calledTime != 0 && _calledTime >= (currentQuery.calledTime + 3600) &&
1114             currentQuery.value == 0);
1115         if (oraclize_getPrice("URL") > address(this).balance) {
1116             emit newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1117         } else {
1118             emit newOraclizeQuery("Oraclize queries sent");
1119             if (currentQuery.called == false){
1120                 queryID = oraclize_query("URL", API);
1121                 usedAPI=API;
1122             } else if (currentQuery.called == true ){
1123                 queryID = oraclize_query("URL", API2);
1124                 usedAPI=API2;  
1125             }
1126 
1127             queryIds[_key] = queryID;
1128             currentQuery = info[queryIds[_key]];
1129             currentQuery.queried = true;
1130             currentQuery.date = _key;
1131             currentQuery.calledTime = _calledTime;
1132             currentQuery.called = !currentQuery.called;
1133         }
1134     }
1135 
1136     /*
1137     * gets API used for tests
1138     */
1139     function getusedAPI() public view returns(string){
1140         return usedAPI;
1141     }
1142     
1143     /**
1144     *@dev Used by Oraclize to return value of PushData API call
1145     *@param _oraclizeID unique oraclize identifier of call
1146     *@param _result Result of API call in string format
1147     */
1148     function __callback(bytes32 _oraclizeID, string _result) public {
1149         QueryInfo storage currentQuery = info[_oraclizeID];
1150         require(msg.sender == oraclize_cbAddress() && _oraclizeID == queryID);
1151         currentQuery.value = parseInt(_result,3);
1152         currentQuery.called = false; 
1153         if(currentQuery.value == 0){
1154             currentQuery.value = 1;
1155         }
1156         emit DocumentStored(currentQuery.date, currentQuery.value);
1157     }
1158 
1159     /**
1160     *@dev Allows the contract to be funded in order to pay for oraclize calls
1161     */
1162     function fund() public payable {
1163       
1164     }
1165 
1166     /**
1167     *@dev Determine if the Oracle was queried
1168     *@param _date Daily unix timestamp of key storing value (GMT 00:00:00)
1169     *@return true or false based upon whether an API query has been 
1170     *initialized (or completed) for given date
1171     */
1172     function getQuery(uint _date) public view returns(bool){
1173         QueryInfo storage currentQuery = info[queryIds[_date]];
1174         return currentQuery.queried;
1175     }
1176 }