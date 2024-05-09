1 pragma solidity ^0.4.11;
2 
3 // <ORACLIZE_API>
4 /*
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 
8 
9 
10 Permission is hereby granted, free of charge, to any person obtaining a copy
11 of this software and associated documentation files (the "Software"), to deal
12 in the Software without restriction, including without limitation the rights
13 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14 copies of the Software, and to permit persons to whom the Software is
15 furnished to do so, subject to the following conditions:
16 
17 
18 
19 The above copyright notice and this permission notice shall be included in
20 all copies or substantial portions of the Software.
21 
22 
23 
24 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
25 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
26 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
27 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
28 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
29 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
30 THE SOFTWARE.
31 */
32 
33 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
34 
35 contract OraclizeI {
36     address public cbAddress;
37     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
39     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
40     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
41     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
42     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
43     function getPrice(string _datasource) returns (uint _dsprice);
44     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
45     function useCoupon(string _coupon);
46     function setProofType(byte _proofType);
47     function setConfig(bytes32 _config);
48     function setCustomGasPrice(uint _gasPrice);
49     function randomDS_getSessionPubKeyHash() returns(bytes32);
50 }
51 contract OraclizeAddrResolverI {
52     function getAddress() returns (address _addr);
53 }
54 contract usingOraclize {
55     uint constant day = 60*60*24;
56     uint constant week = 60*60*24*7;
57     uint constant month = 60*60*24*30;
58     byte constant proofType_NONE = 0x00;
59     byte constant proofType_TLSNotary = 0x10;
60     byte constant proofType_Android = 0x20;
61     byte constant proofType_Ledger = 0x30;
62     byte constant proofType_Native = 0xF0;
63     byte constant proofStorage_IPFS = 0x01;
64     uint8 constant networkID_auto = 0;
65     uint8 constant networkID_mainnet = 1;
66     uint8 constant networkID_testnet = 2;
67     uint8 constant networkID_morden = 2;
68     uint8 constant networkID_consensys = 161;
69 
70     OraclizeAddrResolverI OAR;
71 
72     OraclizeI oraclize;
73     modifier oraclizeAPI {
74         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
75         oraclize = OraclizeI(OAR.getAddress());
76         _;
77     }
78     modifier coupon(string code){
79         oraclize = OraclizeI(OAR.getAddress());
80         oraclize.useCoupon(code);
81         _;
82     }
83 
84     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
85         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
86             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
87             oraclize_setNetworkName("eth_mainnet");
88             return true;
89         }
90         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
91             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
92             oraclize_setNetworkName("eth_ropsten3");
93             return true;
94         }
95         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
96             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
97             oraclize_setNetworkName("eth_kovan");
98             return true;
99         }
100         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
101             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
102             oraclize_setNetworkName("eth_rinkeby");
103             return true;
104         }
105         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
106             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
107             return true;
108         }
109         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
110             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
111             return true;
112         }
113         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
114             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
115             return true;
116         }
117         return false;
118     }
119 
120     function __callback(bytes32 myid, string result) {
121         __callback(myid, result, new bytes(0));
122     }
123     function __callback(bytes32 myid, string result, bytes proof) {
124     }
125     
126     function oraclize_useCoupon(string code) oraclizeAPI internal {
127         oraclize.useCoupon(code);
128     }
129 
130     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
131         return oraclize.getPrice(datasource);
132     }
133 
134     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
135         return oraclize.getPrice(datasource, gaslimit);
136     }
137     
138     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
139         uint price = oraclize.getPrice(datasource);
140         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
141         return oraclize.query.value(price)(0, datasource, arg);
142     }
143     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
144         uint price = oraclize.getPrice(datasource);
145         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
146         return oraclize.query.value(price)(timestamp, datasource, arg);
147     }
148     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource, gaslimit);
150         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
151         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
152     }
153     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
154         uint price = oraclize.getPrice(datasource, gaslimit);
155         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
156         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
157     }
158     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
159         uint price = oraclize.getPrice(datasource);
160         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
161         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
162     }
163     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
164         uint price = oraclize.getPrice(datasource);
165         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
166         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
167     }
168     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
169         uint price = oraclize.getPrice(datasource, gaslimit);
170         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
171         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
172     }
173     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
174         uint price = oraclize.getPrice(datasource, gaslimit);
175         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
176         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
177     }
178     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
179         uint price = oraclize.getPrice(datasource);
180         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
181         bytes memory args = stra2cbor(argN);
182         return oraclize.queryN.value(price)(0, datasource, args);
183     }
184     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
185         uint price = oraclize.getPrice(datasource);
186         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
187         bytes memory args = stra2cbor(argN);
188         return oraclize.queryN.value(price)(timestamp, datasource, args);
189     }
190     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
191         uint price = oraclize.getPrice(datasource, gaslimit);
192         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
193         bytes memory args = stra2cbor(argN);
194         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
195     }
196     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
197         uint price = oraclize.getPrice(datasource, gaslimit);
198         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
199         bytes memory args = stra2cbor(argN);
200         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
201     }
202     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
203         string[] memory dynargs = new string[](1);
204         dynargs[0] = args[0];
205         return oraclize_query(datasource, dynargs);
206     }
207     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
208         string[] memory dynargs = new string[](1);
209         dynargs[0] = args[0];
210         return oraclize_query(timestamp, datasource, dynargs);
211     }
212     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
213         string[] memory dynargs = new string[](1);
214         dynargs[0] = args[0];
215         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
216     }
217     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
218         string[] memory dynargs = new string[](1);
219         dynargs[0] = args[0];       
220         return oraclize_query(datasource, dynargs, gaslimit);
221     }
222     
223     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
224         string[] memory dynargs = new string[](2);
225         dynargs[0] = args[0];
226         dynargs[1] = args[1];
227         return oraclize_query(datasource, dynargs);
228     }
229     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
230         string[] memory dynargs = new string[](2);
231         dynargs[0] = args[0];
232         dynargs[1] = args[1];
233         return oraclize_query(timestamp, datasource, dynargs);
234     }
235     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
236         string[] memory dynargs = new string[](2);
237         dynargs[0] = args[0];
238         dynargs[1] = args[1];
239         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
240     }
241     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
242         string[] memory dynargs = new string[](2);
243         dynargs[0] = args[0];
244         dynargs[1] = args[1];
245         return oraclize_query(datasource, dynargs, gaslimit);
246     }
247     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
248         string[] memory dynargs = new string[](3);
249         dynargs[0] = args[0];
250         dynargs[1] = args[1];
251         dynargs[2] = args[2];
252         return oraclize_query(datasource, dynargs);
253     }
254     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
255         string[] memory dynargs = new string[](3);
256         dynargs[0] = args[0];
257         dynargs[1] = args[1];
258         dynargs[2] = args[2];
259         return oraclize_query(timestamp, datasource, dynargs);
260     }
261     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
262         string[] memory dynargs = new string[](3);
263         dynargs[0] = args[0];
264         dynargs[1] = args[1];
265         dynargs[2] = args[2];
266         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
267     }
268     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
269         string[] memory dynargs = new string[](3);
270         dynargs[0] = args[0];
271         dynargs[1] = args[1];
272         dynargs[2] = args[2];
273         return oraclize_query(datasource, dynargs, gaslimit);
274     }
275     
276     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
277         string[] memory dynargs = new string[](4);
278         dynargs[0] = args[0];
279         dynargs[1] = args[1];
280         dynargs[2] = args[2];
281         dynargs[3] = args[3];
282         return oraclize_query(datasource, dynargs);
283     }
284     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
285         string[] memory dynargs = new string[](4);
286         dynargs[0] = args[0];
287         dynargs[1] = args[1];
288         dynargs[2] = args[2];
289         dynargs[3] = args[3];
290         return oraclize_query(timestamp, datasource, dynargs);
291     }
292     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
293         string[] memory dynargs = new string[](4);
294         dynargs[0] = args[0];
295         dynargs[1] = args[1];
296         dynargs[2] = args[2];
297         dynargs[3] = args[3];
298         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
299     }
300     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
301         string[] memory dynargs = new string[](4);
302         dynargs[0] = args[0];
303         dynargs[1] = args[1];
304         dynargs[2] = args[2];
305         dynargs[3] = args[3];
306         return oraclize_query(datasource, dynargs, gaslimit);
307     }
308     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
309         string[] memory dynargs = new string[](5);
310         dynargs[0] = args[0];
311         dynargs[1] = args[1];
312         dynargs[2] = args[2];
313         dynargs[3] = args[3];
314         dynargs[4] = args[4];
315         return oraclize_query(datasource, dynargs);
316     }
317     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
318         string[] memory dynargs = new string[](5);
319         dynargs[0] = args[0];
320         dynargs[1] = args[1];
321         dynargs[2] = args[2];
322         dynargs[3] = args[3];
323         dynargs[4] = args[4];
324         return oraclize_query(timestamp, datasource, dynargs);
325     }
326     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
327         string[] memory dynargs = new string[](5);
328         dynargs[0] = args[0];
329         dynargs[1] = args[1];
330         dynargs[2] = args[2];
331         dynargs[3] = args[3];
332         dynargs[4] = args[4];
333         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
334     }
335     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
336         string[] memory dynargs = new string[](5);
337         dynargs[0] = args[0];
338         dynargs[1] = args[1];
339         dynargs[2] = args[2];
340         dynargs[3] = args[3];
341         dynargs[4] = args[4];
342         return oraclize_query(datasource, dynargs, gaslimit);
343     }
344     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
345         uint price = oraclize.getPrice(datasource);
346         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
347         bytes memory args = ba2cbor(argN);
348         return oraclize.queryN.value(price)(0, datasource, args);
349     }
350     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
351         uint price = oraclize.getPrice(datasource);
352         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
353         bytes memory args = ba2cbor(argN);
354         return oraclize.queryN.value(price)(timestamp, datasource, args);
355     }
356     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
357         uint price = oraclize.getPrice(datasource, gaslimit);
358         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
359         bytes memory args = ba2cbor(argN);
360         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
361     }
362     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
363         uint price = oraclize.getPrice(datasource, gaslimit);
364         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
365         bytes memory args = ba2cbor(argN);
366         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
367     }
368     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
369         bytes[] memory dynargs = new bytes[](1);
370         dynargs[0] = args[0];
371         return oraclize_query(datasource, dynargs);
372     }
373     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
374         bytes[] memory dynargs = new bytes[](1);
375         dynargs[0] = args[0];
376         return oraclize_query(timestamp, datasource, dynargs);
377     }
378     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
379         bytes[] memory dynargs = new bytes[](1);
380         dynargs[0] = args[0];
381         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
382     }
383     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
384         bytes[] memory dynargs = new bytes[](1);
385         dynargs[0] = args[0];       
386         return oraclize_query(datasource, dynargs, gaslimit);
387     }
388     
389     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
390         bytes[] memory dynargs = new bytes[](2);
391         dynargs[0] = args[0];
392         dynargs[1] = args[1];
393         return oraclize_query(datasource, dynargs);
394     }
395     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
396         bytes[] memory dynargs = new bytes[](2);
397         dynargs[0] = args[0];
398         dynargs[1] = args[1];
399         return oraclize_query(timestamp, datasource, dynargs);
400     }
401     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
402         bytes[] memory dynargs = new bytes[](2);
403         dynargs[0] = args[0];
404         dynargs[1] = args[1];
405         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
406     }
407     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
408         bytes[] memory dynargs = new bytes[](2);
409         dynargs[0] = args[0];
410         dynargs[1] = args[1];
411         return oraclize_query(datasource, dynargs, gaslimit);
412     }
413     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
414         bytes[] memory dynargs = new bytes[](3);
415         dynargs[0] = args[0];
416         dynargs[1] = args[1];
417         dynargs[2] = args[2];
418         return oraclize_query(datasource, dynargs);
419     }
420     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
421         bytes[] memory dynargs = new bytes[](3);
422         dynargs[0] = args[0];
423         dynargs[1] = args[1];
424         dynargs[2] = args[2];
425         return oraclize_query(timestamp, datasource, dynargs);
426     }
427     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
428         bytes[] memory dynargs = new bytes[](3);
429         dynargs[0] = args[0];
430         dynargs[1] = args[1];
431         dynargs[2] = args[2];
432         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
433     }
434     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
435         bytes[] memory dynargs = new bytes[](3);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         dynargs[2] = args[2];
439         return oraclize_query(datasource, dynargs, gaslimit);
440     }
441     
442     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
443         bytes[] memory dynargs = new bytes[](4);
444         dynargs[0] = args[0];
445         dynargs[1] = args[1];
446         dynargs[2] = args[2];
447         dynargs[3] = args[3];
448         return oraclize_query(datasource, dynargs);
449     }
450     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
451         bytes[] memory dynargs = new bytes[](4);
452         dynargs[0] = args[0];
453         dynargs[1] = args[1];
454         dynargs[2] = args[2];
455         dynargs[3] = args[3];
456         return oraclize_query(timestamp, datasource, dynargs);
457     }
458     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
459         bytes[] memory dynargs = new bytes[](4);
460         dynargs[0] = args[0];
461         dynargs[1] = args[1];
462         dynargs[2] = args[2];
463         dynargs[3] = args[3];
464         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
465     }
466     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
467         bytes[] memory dynargs = new bytes[](4);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         dynargs[2] = args[2];
471         dynargs[3] = args[3];
472         return oraclize_query(datasource, dynargs, gaslimit);
473     }
474     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
475         bytes[] memory dynargs = new bytes[](5);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         dynargs[2] = args[2];
479         dynargs[3] = args[3];
480         dynargs[4] = args[4];
481         return oraclize_query(datasource, dynargs);
482     }
483     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
484         bytes[] memory dynargs = new bytes[](5);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         dynargs[2] = args[2];
488         dynargs[3] = args[3];
489         dynargs[4] = args[4];
490         return oraclize_query(timestamp, datasource, dynargs);
491     }
492     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
493         bytes[] memory dynargs = new bytes[](5);
494         dynargs[0] = args[0];
495         dynargs[1] = args[1];
496         dynargs[2] = args[2];
497         dynargs[3] = args[3];
498         dynargs[4] = args[4];
499         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
500     }
501     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
502         bytes[] memory dynargs = new bytes[](5);
503         dynargs[0] = args[0];
504         dynargs[1] = args[1];
505         dynargs[2] = args[2];
506         dynargs[3] = args[3];
507         dynargs[4] = args[4];
508         return oraclize_query(datasource, dynargs, gaslimit);
509     }
510 
511     function oraclize_cbAddress() oraclizeAPI internal returns (address){
512         return oraclize.cbAddress();
513     }
514     function oraclize_setProof(byte proofP) oraclizeAPI internal {
515         return oraclize.setProofType(proofP);
516     }
517     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
518         return oraclize.setCustomGasPrice(gasPrice);
519     }
520     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
521         return oraclize.setConfig(config);
522     }
523     
524     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
525         return oraclize.randomDS_getSessionPubKeyHash();
526     }
527 
528     function getCodeSize(address _addr) constant internal returns(uint _size) {
529         assembly {
530             _size := extcodesize(_addr)
531         }
532     }
533 
534     function parseAddr(string _a) internal returns (address){
535         bytes memory tmp = bytes(_a);
536         uint160 iaddr = 0;
537         uint160 b1;
538         uint160 b2;
539         for (uint i=2; i<2+2*20; i+=2){
540             iaddr *= 256;
541             b1 = uint160(tmp[i]);
542             b2 = uint160(tmp[i+1]);
543             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
544             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
545             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
546             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
547             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
548             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
549             iaddr += (b1*16+b2);
550         }
551         return address(iaddr);
552     }
553 
554     function strCompare(string _a, string _b) internal returns (int) {
555         bytes memory a = bytes(_a);
556         bytes memory b = bytes(_b);
557         uint minLength = a.length;
558         if (b.length < minLength) minLength = b.length;
559         for (uint i = 0; i < minLength; i ++)
560             if (a[i] < b[i])
561                 return -1;
562             else if (a[i] > b[i])
563                 return 1;
564         if (a.length < b.length)
565             return -1;
566         else if (a.length > b.length)
567             return 1;
568         else
569             return 0;
570     }
571 
572     function indexOf(string _haystack, string _needle) internal returns (int) {
573         bytes memory h = bytes(_haystack);
574         bytes memory n = bytes(_needle);
575         if(h.length < 1 || n.length < 1 || (n.length > h.length))
576             return -1;
577         else if(h.length > (2**128 -1))
578             return -1;
579         else
580         {
581             uint subindex = 0;
582             for (uint i = 0; i < h.length; i ++)
583             {
584                 if (h[i] == n[0])
585                 {
586                     subindex = 1;
587                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
588                     {
589                         subindex++;
590                     }
591                     if(subindex == n.length)
592                         return int(i);
593                 }
594             }
595             return -1;
596         }
597     }
598 
599     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
600         bytes memory _ba = bytes(_a);
601         bytes memory _bb = bytes(_b);
602         bytes memory _bc = bytes(_c);
603         bytes memory _bd = bytes(_d);
604         bytes memory _be = bytes(_e);
605         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
606         bytes memory babcde = bytes(abcde);
607         uint k = 0;
608         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
609         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
610         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
611         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
612         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
613         return string(babcde);
614     }
615 
616     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
617         return strConcat(_a, _b, _c, _d, "");
618     }
619 
620     function strConcat(string _a, string _b, string _c) internal returns (string) {
621         return strConcat(_a, _b, _c, "", "");
622     }
623 
624     function strConcat(string _a, string _b) internal returns (string) {
625         return strConcat(_a, _b, "", "", "");
626     }
627 
628     // parseInt
629     function parseInt(string _a) internal returns (uint) {
630         return parseInt(_a, 0);
631     }
632 
633     // parseInt(parseFloat*10^_b)
634     function parseInt(string _a, uint _b) internal returns (uint) {
635         bytes memory bresult = bytes(_a);
636         uint mint = 0;
637         bool decimals = false;
638         for (uint i=0; i<bresult.length; i++){
639             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
640                 if (decimals){
641                    if (_b == 0) break;
642                     else _b--;
643                 }
644                 mint *= 10;
645                 mint += uint(bresult[i]) - 48;
646             } else if (bresult[i] == 46) decimals = true;
647         }
648         if (_b > 0) mint *= 10**_b;
649         return mint;
650     }
651 
652     function uint2str(uint i) internal returns (string){
653         if (i == 0) return "0";
654         uint j = i;
655         uint len;
656         while (j != 0){
657             len++;
658             j /= 10;
659         }
660         bytes memory bstr = new bytes(len);
661         uint k = len - 1;
662         while (i != 0){
663             bstr[k--] = byte(48 + i % 10);
664             i /= 10;
665         }
666         return string(bstr);
667     }
668     
669     function stra2cbor(string[] arr) internal returns (bytes) {
670             uint arrlen = arr.length;
671 
672             // get correct cbor output length
673             uint outputlen = 0;
674             bytes[] memory elemArray = new bytes[](arrlen);
675             for (uint i = 0; i < arrlen; i++) {
676                 elemArray[i] = (bytes(arr[i]));
677                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
678             }
679             uint ctr = 0;
680             uint cborlen = arrlen + 0x80;
681             outputlen += byte(cborlen).length;
682             bytes memory res = new bytes(outputlen);
683 
684             while (byte(cborlen).length > ctr) {
685                 res[ctr] = byte(cborlen)[ctr];
686                 ctr++;
687             }
688             for (i = 0; i < arrlen; i++) {
689                 res[ctr] = 0x5F;
690                 ctr++;
691                 for (uint x = 0; x < elemArray[i].length; x++) {
692                     // if there's a bug with larger strings, this may be the culprit
693                     if (x % 23 == 0) {
694                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
695                         elemcborlen += 0x40;
696                         uint lctr = ctr;
697                         while (byte(elemcborlen).length > ctr - lctr) {
698                             res[ctr] = byte(elemcborlen)[ctr - lctr];
699                             ctr++;
700                         }
701                     }
702                     res[ctr] = elemArray[i][x];
703                     ctr++;
704                 }
705                 res[ctr] = 0xFF;
706                 ctr++;
707             }
708             return res;
709         }
710 
711     function ba2cbor(bytes[] arr) internal returns (bytes) {
712             uint arrlen = arr.length;
713 
714             // get correct cbor output length
715             uint outputlen = 0;
716             bytes[] memory elemArray = new bytes[](arrlen);
717             for (uint i = 0; i < arrlen; i++) {
718                 elemArray[i] = (bytes(arr[i]));
719                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
720             }
721             uint ctr = 0;
722             uint cborlen = arrlen + 0x80;
723             outputlen += byte(cborlen).length;
724             bytes memory res = new bytes(outputlen);
725 
726             while (byte(cborlen).length > ctr) {
727                 res[ctr] = byte(cborlen)[ctr];
728                 ctr++;
729             }
730             for (i = 0; i < arrlen; i++) {
731                 res[ctr] = 0x5F;
732                 ctr++;
733                 for (uint x = 0; x < elemArray[i].length; x++) {
734                     // if there's a bug with larger strings, this may be the culprit
735                     if (x % 23 == 0) {
736                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
737                         elemcborlen += 0x40;
738                         uint lctr = ctr;
739                         while (byte(elemcborlen).length > ctr - lctr) {
740                             res[ctr] = byte(elemcborlen)[ctr - lctr];
741                             ctr++;
742                         }
743                     }
744                     res[ctr] = elemArray[i][x];
745                     ctr++;
746                 }
747                 res[ctr] = 0xFF;
748                 ctr++;
749             }
750             return res;
751         }
752         
753         
754     string oraclize_network_name;
755     function oraclize_setNetworkName(string _network_name) internal {
756         oraclize_network_name = _network_name;
757     }
758     
759     function oraclize_getNetworkName() internal returns (string) {
760         return oraclize_network_name;
761     }
762     
763     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
764         if ((_nbytes == 0)||(_nbytes > 32)) throw;
765         bytes memory nbytes = new bytes(1);
766         nbytes[0] = byte(_nbytes);
767         bytes memory unonce = new bytes(32);
768         bytes memory sessionKeyHash = new bytes(32);
769         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
770         assembly {
771             mstore(unonce, 0x20)
772             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
773             mstore(sessionKeyHash, 0x20)
774             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
775         }
776         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
777         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
778         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
779         return queryId;
780     }
781     
782     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
783         oraclize_randomDS_args[queryId] = commitment;
784     }
785     
786     mapping(bytes32=>bytes32) oraclize_randomDS_args;
787     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
788 
789     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
790         bool sigok;
791         address signer;
792         
793         bytes32 sigr;
794         bytes32 sigs;
795         
796         bytes memory sigr_ = new bytes(32);
797         uint offset = 4+(uint(dersig[3]) - 0x20);
798         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
799         bytes memory sigs_ = new bytes(32);
800         offset += 32 + 2;
801         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
802 
803         assembly {
804             sigr := mload(add(sigr_, 32))
805             sigs := mload(add(sigs_, 32))
806         }
807         
808         
809         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
810         if (address(sha3(pubkey)) == signer) return true;
811         else {
812             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
813             return (address(sha3(pubkey)) == signer);
814         }
815     }
816 
817     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
818         bool sigok;
819         
820         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
821         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
822         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
823         
824         bytes memory appkey1_pubkey = new bytes(64);
825         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
826         
827         bytes memory tosign2 = new bytes(1+65+32);
828         tosign2[0] = 1; //role
829         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
830         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
831         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
832         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
833         
834         if (sigok == false) return false;
835         
836         
837         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
838         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
839         
840         bytes memory tosign3 = new bytes(1+65);
841         tosign3[0] = 0xFE;
842         copyBytes(proof, 3, 65, tosign3, 1);
843         
844         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
845         copyBytes(proof, 3+65, sig3.length, sig3, 0);
846         
847         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
848         
849         return sigok;
850     }
851     
852     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
853         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
854         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
855         
856         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
857         if (proofVerified == false) throw;
858         
859         _;
860     }
861     
862     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
863         bool match_ = true;
864         
865         for (var i=0; i<prefix.length; i++){
866             if (content[i] != prefix[i]) match_ = false;
867         }
868         
869         return match_;
870     }
871 
872     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
873         bool checkok;
874         
875         
876         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
877         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
878         bytes memory keyhash = new bytes(32);
879         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
880         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
881         if (checkok == false) return false;
882         
883         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
884         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
885         
886         
887         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
888         checkok = matchBytes32Prefix(sha256(sig1), result);
889         if (checkok == false) return false;
890         
891         
892         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
893         // This is to verify that the computed args match with the ones specified in the query.
894         bytes memory commitmentSlice1 = new bytes(8+1+32);
895         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
896         
897         bytes memory sessionPubkey = new bytes(64);
898         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
899         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
900         
901         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
902         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
903             delete oraclize_randomDS_args[queryId];
904         } else return false;
905         
906         
907         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
908         bytes memory tosign1 = new bytes(32+8+1+32);
909         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
910         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
911         if (checkok == false) return false;
912         
913         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
914         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
915             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
916         }
917         
918         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
919     }
920 
921     
922     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
923     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
924         uint minLength = length + toOffset;
925 
926         if (to.length < minLength) {
927             // Buffer too small
928             throw; // Should be a better way?
929         }
930 
931         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
932         uint i = 32 + fromOffset;
933         uint j = 32 + toOffset;
934 
935         while (i < (32 + fromOffset + length)) {
936             assembly {
937                 let tmp := mload(add(from, i))
938                 mstore(add(to, j), tmp)
939             }
940             i += 32;
941             j += 32;
942         }
943 
944         return to;
945     }
946     
947     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
948     // Duplicate Solidity's ecrecover, but catching the CALL return value
949     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
950         // We do our own memory management here. Solidity uses memory offset
951         // 0x40 to store the current end of memory. We write past it (as
952         // writes are memory extensions), but don't update the offset so
953         // Solidity will reuse it. The memory used here is only needed for
954         // this context.
955 
956         // FIXME: inline assembly can't access return values
957         bool ret;
958         address addr;
959 
960         assembly {
961             let size := mload(0x40)
962             mstore(size, hash)
963             mstore(add(size, 32), v)
964             mstore(add(size, 64), r)
965             mstore(add(size, 96), s)
966 
967             // NOTE: we can reuse the request memory because we deal with
968             //       the return code
969             ret := call(3000, 1, 0, size, 128, size, 32)
970             addr := mload(size)
971         }
972   
973         return (ret, addr);
974     }
975 
976     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
977     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
978         bytes32 r;
979         bytes32 s;
980         uint8 v;
981 
982         if (sig.length != 65)
983           return (false, 0);
984 
985         // The signature format is a compact form of:
986         //   {bytes32 r}{bytes32 s}{uint8 v}
987         // Compact means, uint8 is not padded to 32 bytes.
988         assembly {
989             r := mload(add(sig, 32))
990             s := mload(add(sig, 64))
991 
992             // Here we are loading the last 32 bytes. We exploit the fact that
993             // 'mload' will pad with zeroes if we overread.
994             // There is no 'mload8' to do this, but that would be nicer.
995             v := byte(0, mload(add(sig, 96)))
996 
997             // Alternative solution:
998             // 'byte' is not working due to the Solidity parser, so lets
999             // use the second best option, 'and'
1000             // v := and(mload(add(sig, 65)), 255)
1001         }
1002 
1003         // albeit non-transactional signatures are not specified by the YP, one would expect it
1004         // to match the YP range of [27, 28]
1005         //
1006         // geth uses [0, 1] and some clients have followed. This might change, see:
1007         //  https://github.com/ethereum/go-ethereum/issues/2053
1008         if (v < 27)
1009           v += 27;
1010 
1011         if (v != 27 && v != 28)
1012             return (false, 0);
1013 
1014         return safer_ecrecover(hash, v, r, s);
1015     }
1016         
1017 }
1018 // </ORACLIZE_API>
1019 /// math.sol -- mixin for inline numerical wizardry
1020 
1021 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
1022 
1023 // Licensed under the Apache License, Version 2.0 (the "License").
1024 // You may not use this file except in compliance with the License.
1025 
1026 // Unless required by applicable law or agreed to in writing, software
1027 // distributed under the License is distributed on an "AS IS" BASIS,
1028 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
1029 
1030 pragma solidity ^0.4.10;
1031 
1032 contract DSMath {
1033     
1034     /*
1035     standard uint256 functions
1036      */
1037 
1038     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
1039         assert((z = x + y) >= x);
1040     }
1041 
1042     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
1043         assert((z = x - y) <= x);
1044     }
1045 
1046     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
1047         assert((z = x * y) >= x);
1048     }
1049 
1050     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
1051         z = x / y;
1052     }
1053 
1054     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
1055         return x <= y ? x : y;
1056     }
1057     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
1058         return x >= y ? x : y;
1059     }
1060 
1061     /*
1062     uint128 functions (h is for half)
1063      */
1064 
1065 
1066     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
1067         assert((z = x + y) >= x);
1068     }
1069 
1070     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
1071         assert((z = x - y) <= x);
1072     }
1073 
1074     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
1075         assert((z = x * y) >= x);
1076     }
1077 
1078     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
1079         z = x / y;
1080     }
1081 
1082     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
1083         return x <= y ? x : y;
1084     }
1085     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
1086         return x >= y ? x : y;
1087     }
1088 
1089 
1090     /*
1091     int256 functions
1092      */
1093 
1094     function imin(int256 x, int256 y) constant internal returns (int256 z) {
1095         return x <= y ? x : y;
1096     }
1097     function imax(int256 x, int256 y) constant internal returns (int256 z) {
1098         return x >= y ? x : y;
1099     }
1100 
1101     /*
1102     WAD math
1103      */
1104 
1105     uint128 constant WAD = 10 ** 18;
1106 
1107     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
1108         return hadd(x, y);
1109     }
1110 
1111     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
1112         return hsub(x, y);
1113     }
1114 
1115     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
1116         z = cast((uint256(x) * y + WAD / 2) / WAD);
1117     }
1118 
1119     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
1120         z = cast((uint256(x) * WAD + y / 2) / y);
1121     }
1122 
1123     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
1124         return hmin(x, y);
1125     }
1126     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
1127         return hmax(x, y);
1128     }
1129 
1130     /*
1131     RAY math
1132      */
1133 
1134     uint128 constant RAY = 10 ** 27;
1135 
1136     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
1137         return hadd(x, y);
1138     }
1139 
1140     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
1141         return hsub(x, y);
1142     }
1143 
1144     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
1145         z = cast((uint256(x) * y + RAY / 2) / RAY);
1146     }
1147 
1148     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
1149         z = cast((uint256(x) * RAY + y / 2) / y);
1150     }
1151 
1152     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
1153         // This famous algorithm is called "exponentiation by squaring"
1154         // and calculates x^n with x as fixed-point and n as regular unsigned.
1155         //
1156         // It's O(log n), instead of O(n) for naive repeated multiplication.
1157         //
1158         // These facts are why it works:
1159         //
1160         //  If n is even, then x^n = (x^2)^(n/2).
1161         //  If n is odd,  then x^n = x * x^(n-1),
1162         //   and applying the equation for even x gives
1163         //    x^n = x * (x^2)^((n-1) / 2).
1164         //
1165         //  Also, EVM division is flooring and
1166         //    floor[(n-1) / 2] = floor[n / 2].
1167 
1168         z = n % 2 != 0 ? x : RAY;
1169 
1170         for (n /= 2; n != 0; n /= 2) {
1171             x = rmul(x, x);
1172 
1173             if (n % 2 != 0) {
1174                 z = rmul(z, x);
1175             }
1176         }
1177     }
1178 
1179     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
1180         return hmin(x, y);
1181     }
1182     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
1183         return hmax(x, y);
1184     }
1185 
1186     function cast(uint256 x) constant internal returns (uint128 z) {
1187         assert((z = uint128(x)) == x);
1188     }
1189 
1190 }
1191 
1192 contract LedgerProofVerifyI {
1193     function external_oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) public;
1194     function external_oraclize_randomDS_proofVerify(bytes proof, bytes32 queryId, bytes result, string context_name)  public returns (bool);
1195 }
1196 
1197 contract Owned {
1198     address public owner;
1199     
1200     modifier onlyOwner {
1201         assert(msg.sender == owner);
1202         _;
1203     }
1204     
1205     function Owned() {
1206         owner = msg.sender;
1207     }
1208 }
1209 
1210 contract oraclizeSettings is Owned {
1211 	uint constant ORACLIZE_PER_SPIN_GAS_LIMIT = 6100;
1212 	uint constant ORACLIZE_BASE_GAS_LIMIT = 200000;
1213 	uint safeGas = 9000;
1214 	
1215 	event newGasLimit(uint _gasLimit);
1216 
1217 	function setSafeGas(uint _gas) 
1218 		onlyOwner 
1219 	{
1220 	    assert(ORACLIZE_BASE_GAS_LIMIT + safeGas >= ORACLIZE_BASE_GAS_LIMIT);
1221 	    assert(safeGas <= 25000);
1222 		safeGas = _gas;
1223 		newGasLimit(_gas);
1224 	}	
1225 }
1226 
1227 contract HouseManaged is Owned {
1228     
1229     address public houseAddress;
1230     bool public isStopped;
1231 
1232     event LOG_ContractStopped();
1233     event LOG_ContractResumed();
1234     event LOG_OwnerAddressChanged(address oldAddr, address newOwnerAddress);
1235     event LOG_HouseAddressChanged(address oldAddr, address newHouseAddress);
1236     
1237     modifier onlyIfNotStopped {
1238         assert(!isStopped);
1239         _;
1240     }
1241 
1242     modifier onlyIfStopped {
1243         assert(isStopped);
1244         _;
1245     }
1246     
1247     function HouseManaged() {
1248         houseAddress = msg.sender;
1249     }
1250 
1251     function stop_or_resume_Contract(bool _isStopped)
1252         onlyOwner {
1253 
1254         isStopped = _isStopped;
1255     }
1256 
1257     function changeHouse_and_Owner_Addresses(address newHouse, address newOwner)
1258         onlyOwner {
1259 
1260         assert(newHouse != address(0x0));
1261         assert(newOwner != address(0x0));
1262         
1263         owner = newOwner;
1264         LOG_OwnerAddressChanged(owner, newOwner);
1265         
1266         houseAddress = newHouse;
1267         LOG_HouseAddressChanged(houseAddress, newHouse);
1268     }
1269 
1270 }
1271 
1272 contract usingInvestorsModule is HouseManaged, oraclizeSettings {
1273     
1274     uint constant MAX_INVESTORS = 5; //maximum number of investors
1275     uint constant divestFee = 50; //divest fee percentage (10000 = 100%)
1276 
1277      struct Investor {
1278         address investorAddress;
1279         uint amountInvested;
1280         bool votedForEmergencyWithdrawal;
1281     }
1282     
1283     //Starting at 1
1284     mapping(address => uint) public investorIDs;
1285     mapping(uint => Investor) public investors;
1286     uint public numInvestors = 0;
1287 
1288     uint public invested = 0;
1289     
1290     uint public investorsProfit = 0;
1291     uint public investorsLosses = 0;
1292     bool profitDistributed;
1293     
1294     event LOG_InvestorEntrance(address investor, uint amount);
1295     event LOG_InvestorCapitalUpdate(address investor, int amount);
1296     event LOG_InvestorExit(address investor, uint amount);
1297     event LOG_EmergencyAutoStop();
1298     
1299     event LOG_ZeroSend();
1300     event LOG_ValueIsTooBig();
1301     event LOG_FailedSend(address addr, uint value);
1302     event LOG_SuccessfulSend(address addr, uint value);
1303     
1304 
1305 
1306     modifier onlyMoreThanMinInvestment {
1307         assert(msg.value > getMinInvestment());
1308         _;
1309     }
1310 
1311     modifier onlyMoreThanZero {
1312         assert(msg.value != 0);
1313         _;
1314     }
1315 
1316     
1317     modifier onlyInvestors {
1318         assert(investorIDs[msg.sender] != 0);
1319         _;
1320     }
1321 
1322     modifier onlyNotInvestors {
1323         assert(investorIDs[msg.sender] == 0);
1324         _;
1325     }
1326     
1327     modifier investorsInvariant {
1328         _;
1329         assert(numInvestors <= MAX_INVESTORS);
1330     }
1331     
1332     modifier onlyIfProfitNotDistributed {
1333         if (!profitDistributed) {
1334             _;
1335         }
1336     }
1337     
1338     function getBankroll()
1339         constant
1340         returns(uint) {
1341 
1342         if ((invested < investorsProfit) ||
1343             (invested + investorsProfit < invested) ||
1344             (invested + investorsProfit < investorsLosses)) {
1345             return 0;
1346         }
1347         else {
1348             return invested + investorsProfit - investorsLosses;
1349         }
1350     }
1351 
1352     function getMinInvestment()
1353         constant
1354         returns(uint) {
1355 
1356         if (numInvestors == MAX_INVESTORS) {
1357             uint investorID = searchSmallestInvestor();
1358             return getBalance(investors[investorID].investorAddress);
1359         }
1360         else {
1361             return 0;
1362         }
1363     }
1364 
1365     function getLossesShare(address currentInvestor)
1366         constant
1367         returns (uint) {
1368 
1369         return investors[investorIDs[currentInvestor]].amountInvested * (investorsLosses) / invested;
1370     }
1371 
1372     function getProfitShare(address currentInvestor)
1373         constant
1374         returns (uint) {
1375 
1376         return investors[investorIDs[currentInvestor]].amountInvested * (investorsProfit) / invested;
1377     }
1378 
1379     function getBalance(address currentInvestor)
1380         constant
1381         returns (uint) {
1382 
1383         uint invested = investors[investorIDs[currentInvestor]].amountInvested;
1384         uint profit = getProfitShare(currentInvestor);
1385         uint losses = getLossesShare(currentInvestor);
1386 
1387         if ((invested + profit < profit) ||
1388             (invested + profit < invested) ||
1389             (invested + profit < losses))
1390             return 0;
1391         else
1392             return invested + profit - losses;
1393     }
1394 
1395     function searchSmallestInvestor()
1396         constant
1397         returns(uint) {
1398 
1399         uint investorID = 1;
1400         for (uint i = 1; i <= numInvestors; i++) {
1401             if (getBalance(investors[i].investorAddress) < getBalance(investors[investorID].investorAddress)) {
1402                 investorID = i;
1403             }
1404         }
1405 
1406         return investorID;
1407     }
1408 
1409     
1410     function addInvestorAtID(uint id)
1411         private {
1412 
1413         investorIDs[msg.sender] = id;
1414         investors[id].investorAddress = msg.sender;
1415         investors[id].amountInvested = msg.value;
1416         invested += msg.value;
1417 
1418         LOG_InvestorEntrance(msg.sender, msg.value);
1419     }
1420 
1421     function profitDistribution()
1422         private
1423         onlyIfProfitNotDistributed {
1424 
1425         uint copyInvested;
1426 
1427         for (uint i = 1; i <= numInvestors; i++) {
1428             address currentInvestor = investors[i].investorAddress;
1429             uint profitOfInvestor = getProfitShare(currentInvestor);
1430             uint lossesOfInvestor = getLossesShare(currentInvestor);
1431             //Check for overflow and underflow
1432             if ((investors[i].amountInvested + profitOfInvestor >= investors[i].amountInvested) &&
1433                 (investors[i].amountInvested + profitOfInvestor >= lossesOfInvestor))  {
1434                 investors[i].amountInvested += profitOfInvestor - lossesOfInvestor;
1435                 LOG_InvestorCapitalUpdate(currentInvestor, (int) (profitOfInvestor - lossesOfInvestor));
1436             }
1437             else {
1438                 isStopped = true;
1439                 LOG_EmergencyAutoStop();
1440             }
1441 
1442             if (copyInvested + investors[i].amountInvested >= copyInvested)
1443                 copyInvested += investors[i].amountInvested;
1444         }
1445 
1446         delete investorsProfit;
1447         delete investorsLosses;
1448         invested = copyInvested;
1449 
1450         profitDistributed = true;
1451     }
1452     
1453     function increaseInvestment()
1454         payable
1455         onlyIfNotStopped
1456         onlyMoreThanZero
1457         onlyInvestors  {
1458 
1459         profitDistribution();
1460         investors[investorIDs[msg.sender]].amountInvested += msg.value;
1461         invested += msg.value;
1462     }
1463 
1464     function newInvestor()
1465         payable
1466         onlyIfNotStopped
1467         onlyMoreThanZero
1468         onlyNotInvestors
1469         onlyMoreThanMinInvestment
1470         investorsInvariant {
1471 
1472         profitDistribution();
1473 
1474         if (numInvestors == MAX_INVESTORS) {
1475             uint smallestInvestorID = searchSmallestInvestor();
1476             divest(investors[smallestInvestorID].investorAddress);
1477         }
1478 
1479         numInvestors++;
1480         addInvestorAtID(numInvestors);
1481     }
1482 
1483     function divest()
1484         onlyInvestors {
1485 
1486         divest(msg.sender);
1487     }
1488 
1489 
1490     function divest(address currentInvestor)
1491         internal
1492         investorsInvariant {
1493 
1494         profitDistribution();
1495         uint currentID = investorIDs[currentInvestor];
1496         uint amountToReturn = getBalance(currentInvestor);
1497 
1498         if ((invested >= investors[currentID].amountInvested)) {
1499             invested -= investors[currentID].amountInvested;
1500             uint divestFeeAmount =  (amountToReturn*divestFee)/10000;
1501             amountToReturn -= divestFeeAmount;
1502 
1503             delete investors[currentID];
1504             delete investorIDs[currentInvestor];
1505 
1506             //Reorder investors
1507             if (currentID != numInvestors) {
1508                 // Get last investor
1509                 Investor lastInvestor = investors[numInvestors];
1510                 //Set last investor ID to investorID of divesting account
1511                 investorIDs[lastInvestor.investorAddress] = currentID;
1512                 //Copy investor at the new position in the mapping
1513                 investors[currentID] = lastInvestor;
1514                 //Delete old position in the mappping
1515                 delete investors[numInvestors];
1516             }
1517 
1518             numInvestors--;
1519             safeSend(currentInvestor, amountToReturn);
1520             safeSend(houseAddress, divestFeeAmount);
1521             LOG_InvestorExit(currentInvestor, amountToReturn);
1522         } else {
1523             isStopped = true;
1524             LOG_EmergencyAutoStop();
1525         }
1526     }
1527     
1528     function forceDivestOfAllInvestors()
1529         onlyOwner {
1530             
1531         uint copyNumInvestors = numInvestors;
1532         for (uint i = 1; i <= copyNumInvestors; i++) {
1533             divest(investors[1].investorAddress);
1534         }
1535     }
1536     
1537     function safeSend(address addr, uint value)
1538         internal {
1539 
1540         if (value == 0) {
1541             LOG_ZeroSend();
1542             return;
1543         }
1544 
1545         if (this.balance < value) {
1546             LOG_ValueIsTooBig();
1547             return;
1548         }
1549 
1550         if (!(addr.call.gas(safeGas).value(value)())) {
1551             LOG_FailedSend(addr, value);
1552             if (addr != houseAddress) {
1553                 //Forward to house address all change
1554                 if (!(houseAddress.call.gas(safeGas).value(value)())) LOG_FailedSend(houseAddress, value);
1555             }
1556         }
1557 
1558         LOG_SuccessfulSend(addr,value);
1559     }
1560 }
1561 
1562 contract EmergencyWithdrawalModule is usingInvestorsModule {
1563     uint constant EMERGENCY_WITHDRAWAL_RATIO = 80; //ratio percentage (100 = 100%)
1564     uint constant EMERGENCY_TIMEOUT = 3 days;
1565     
1566     struct WithdrawalProposal {
1567         address toAddress;
1568         uint atTime;
1569     }
1570     
1571     WithdrawalProposal public proposedWithdrawal;
1572     
1573     event LOG_EmergencyWithdrawalProposed();
1574     event LOG_EmergencyWithdrawalFailed(address withdrawalAddress);
1575     event LOG_EmergencyWithdrawalSucceeded(address withdrawalAddress, uint amountWithdrawn);
1576     event LOG_EmergencyWithdrawalVote(address investor, bool vote);
1577     
1578     modifier onlyAfterProposed {
1579         assert(proposedWithdrawal.toAddress != 0);
1580         _;
1581     }
1582     
1583     modifier onlyIfEmergencyTimeOutHasPassed {
1584         assert(proposedWithdrawal.atTime + EMERGENCY_TIMEOUT <= now);
1585         _;
1586     }
1587     
1588     function voteEmergencyWithdrawal(bool vote)
1589         onlyInvestors
1590         onlyAfterProposed
1591         onlyIfStopped {
1592 
1593         investors[investorIDs[msg.sender]].votedForEmergencyWithdrawal = vote;
1594         LOG_EmergencyWithdrawalVote(msg.sender, vote);
1595     }
1596 
1597     function proposeEmergencyWithdrawal(address withdrawalAddress)
1598         onlyIfStopped
1599         onlyOwner {
1600 
1601         //Resets previous votes
1602         for (uint i = 1; i <= numInvestors; i++) {
1603             delete investors[i].votedForEmergencyWithdrawal;
1604         }
1605 
1606         proposedWithdrawal = WithdrawalProposal(withdrawalAddress, now);
1607         LOG_EmergencyWithdrawalProposed();
1608     }
1609 
1610     function executeEmergencyWithdrawal()
1611         onlyOwner
1612         onlyAfterProposed
1613         onlyIfStopped
1614         onlyIfEmergencyTimeOutHasPassed {
1615 
1616         uint numOfVotesInFavour;
1617         uint amountToWithdraw = this.balance;
1618 
1619         for (uint i = 1; i <= numInvestors; i++) {
1620             if (investors[i].votedForEmergencyWithdrawal == true) {
1621                 numOfVotesInFavour++;
1622                 delete investors[i].votedForEmergencyWithdrawal;
1623             }
1624         }
1625 
1626         if (numOfVotesInFavour >= EMERGENCY_WITHDRAWAL_RATIO * numInvestors / 100) {
1627             if (!proposedWithdrawal.toAddress.send(amountToWithdraw)) {
1628                 LOG_EmergencyWithdrawalFailed(proposedWithdrawal.toAddress);
1629             }
1630             else {
1631                 LOG_EmergencyWithdrawalSucceeded(proposedWithdrawal.toAddress, amountToWithdraw);
1632             }
1633         }
1634         else {
1635             revert();
1636         }
1637     }
1638     
1639         /*
1640     The owner can use this function to force the exit of an investor from the
1641     contract during an emergency withdrawal in the following situations:
1642         - Unresponsive investor
1643         - Investor demanding to be paid in other to vote, the facto-blackmailing
1644         other investors
1645     */
1646     function forceDivestOfOneInvestor(address currentInvestor)
1647         onlyOwner
1648         onlyIfStopped {
1649 
1650         divest(currentInvestor);
1651         //Resets emergency withdrawal proposal. Investors must vote again
1652         delete proposedWithdrawal;
1653     }
1654 }
1655 
1656 contract Slot is usingOraclize, EmergencyWithdrawalModule, DSMath {
1657     
1658     uint constant INVESTORS_EDGE = 200; 
1659     uint constant HOUSE_EDGE = 50;
1660     uint constant CAPITAL_RISK = 250;
1661     uint constant MAX_SPINS = 16;
1662     
1663     uint minBet = 1 wei;
1664  
1665     struct SpinsContainer {
1666         address playerAddress;
1667         uint nSpins;
1668         uint amountWagered;
1669     }
1670     
1671     mapping (bytes32 => SpinsContainer) spins;
1672     
1673     /* Both arrays are ordered:
1674      - probabilities are ordered from smallest to highest
1675      - multipliers are ordered from highest to lowest
1676      The probabilities are expressed as integer numbers over a scale of 10000: i.e
1677      100 is equivalent to 1%, 5000 to 50% and so on.
1678     */
1679     uint[] public probabilities;
1680     uint[] public multipliers;
1681     
1682     uint public totalAmountWagered; 
1683     
1684     event LOG_newSpinsContainer(bytes32 myid, address playerAddress, uint amountWagered, uint nSpins);
1685     event LOG_SpinExecuted(bytes32 myid, address playerAddress, uint spinIndex, uint numberDrawn);
1686     event LOG_SpinsContainerInfo(bytes32 myid, address playerAddress, uint netPayout);
1687     LedgerProofVerifyI externalContract;
1688     
1689     function Slot(address _verifierAddr) {
1690         externalContract = LedgerProofVerifyI(_verifierAddr);
1691     }
1692     
1693     //SECTION I: MODIFIERS AND HELPER FUNCTIONS
1694     
1695     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1696         externalContract.external_oraclize_randomDS_setCommitment(queryId, commitment);
1697     }
1698     
1699     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1700         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1701         //if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1702         assert(externalContract.external_oraclize_randomDS_proofVerify(_proof, _queryId, bytes(_result), oraclize_getNetworkName()));
1703         _;
1704     }
1705 
1706     modifier onlyOraclize {
1707         assert(msg.sender == oraclize_cbAddress());
1708         _;
1709     }
1710 
1711     modifier onlyIfSpinsExist(bytes32 myid) {
1712         assert(spins[myid].playerAddress != address(0x0));
1713         _;
1714     }
1715     
1716     function isValidSize(uint _amountWagered) 
1717         constant 
1718         returns(bool) {
1719             
1720         uint netPotentialPayout = (_amountWagered * (10000 - INVESTORS_EDGE) * multipliers[0])/ 10000; 
1721         uint maxAllowedPayout = (CAPITAL_RISK * getBankroll())/10000;
1722         
1723         return ((netPotentialPayout <= maxAllowedPayout) && (_amountWagered >= minBet));
1724     }
1725 
1726     modifier onlyIfEnoughFunds(bytes32 myid) {
1727         if (isValidSize(spins[myid].amountWagered)) {
1728              _;
1729         }
1730         else {
1731             safeSend(spins[myid].playerAddress, spins[myid].amountWagered);
1732             delete spins[myid];
1733             return;
1734         }
1735     }
1736     
1737 	modifier onlyLessThanMaxSpins (uint _nSpins) {
1738         assert(_nSpins <= MAX_SPINS);
1739         _;
1740     }
1741     
1742     /*
1743         For the game to be fair, the total gross payout over a large number of 
1744         individual slot spins should be the total amount wagered by the player. 
1745         
1746         The game owner, called house, and the investors will gain by applying 
1747         a small fee, called edge, to the amount won by the player in the case of
1748         a successful spin. 
1749         
1750         The total gross expected payout is equal to the sum of all payout. Each 
1751         i-th payout is calculated:
1752                     amountWagered * multipliers[i] * probabilities[i] 
1753         The resulting equation is:
1754                     sum of aW * m[i] * p[i] = aW
1755         After having simplified the equation:
1756                         sum of m[i] * p[i] = 1
1757         Since our probabilities are defined over 10000, the sum should be 10000.
1758         
1759         The contract owner can modify the multipliers and probabilities array, 
1760         but the  modifier enforces that the number choosen always result in a 
1761         fare game.
1762     */
1763     modifier onlyIfFair(uint[] _prob, uint[] _payouts) {
1764         if (_prob.length != _payouts.length) revert();
1765         uint sum = 0;
1766         for (uint i = 0; i <_prob.length; i++) {
1767             sum += _prob[i] * _payouts[i];     
1768         }
1769         assert(sum == 10000);
1770         _;
1771     }
1772 
1773     function()
1774         payable {
1775         buySpins(1);
1776     }
1777 
1778     function buySpins(uint _nSpins) 
1779         payable 
1780         onlyLessThanMaxSpins(_nSpins) 
1781 		onlyIfNotStopped {
1782             
1783         uint gas = _nSpins*ORACLIZE_PER_SPIN_GAS_LIMIT + ORACLIZE_BASE_GAS_LIMIT + safeGas;
1784         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("random", gas);
1785         
1786         // Disallow bets that even when maximally winning are a loss for player 
1787         // due to oraclizeFee
1788         if (oraclizeFee/multipliers[0] + oraclizeFee >= msg.value) revert();
1789         
1790         uint amountWagered = msg.value - oraclizeFee;
1791         uint maxNetPotentialPayout = (amountWagered * (10000 - INVESTORS_EDGE) * multipliers[0])/10000; 
1792         uint maxAllowedPayout = (CAPITAL_RISK * getBankroll())/10000;
1793         
1794         if ((maxNetPotentialPayout <= maxAllowedPayout) && (amountWagered >= minBet)) {
1795             bytes32 queryId = oraclize_newRandomDSQuery(0, 2*_nSpins, gas);
1796              spins[queryId] = 
1797                 SpinsContainer(msg.sender,
1798                                     _nSpins,
1799                                     amountWagered
1800                                 );
1801             
1802             LOG_newSpinsContainer(queryId, msg.sender, amountWagered, _nSpins);
1803             totalAmountWagered += amountWagered;
1804         } else {
1805             revert();
1806         }
1807     }
1808     
1809     function executeSpins(bytes32 myid, bytes randomBytes) 
1810         private 
1811         returns(uint)
1812     {
1813         uint amountWon = 0;
1814         uint numberDrawn = 0;
1815         uint rangeUpperEnd = 0;
1816         uint nSpins = spins[myid].nSpins;
1817         
1818         for (uint i = 0; i < 2*nSpins; i += 2) {
1819             // A number between 0 and 2**16, normalized over 0 - 10000
1820             numberDrawn = ((uint(randomBytes[i])*256 + uint(randomBytes[i+1]))*10000)/2**16;
1821             rangeUpperEnd = 0;
1822             LOG_SpinExecuted(myid, spins[myid].playerAddress, i/2, numberDrawn);
1823             for (uint j = 0; j < probabilities.length; j++) {
1824                 rangeUpperEnd += probabilities[j];
1825                 if (numberDrawn < rangeUpperEnd) {
1826                     amountWon += (spins[myid].amountWagered * multipliers[j]) / nSpins;
1827                     break;
1828                 }
1829             }
1830         }
1831         return amountWon;
1832     }
1833     
1834     function sendPayout(bytes32 myid, uint payout) private {
1835 
1836         if (payout >= spins[myid].amountWagered) {
1837             investorsLosses += sub(payout, spins[myid].amountWagered);
1838             payout = (payout*(10000 - INVESTORS_EDGE))/10000;
1839         }
1840         else {
1841             uint tempProfit = add(investorsProfit, sub(spins[myid].amountWagered, payout));
1842             investorsProfit += (sub(spins[myid].amountWagered, payout)*(10000 - HOUSE_EDGE))/10000;
1843             safeSend(houseAddress, sub(tempProfit, investorsProfit));
1844         }
1845         
1846         LOG_SpinsContainerInfo(myid, spins[myid].playerAddress, payout);
1847         safeSend(spins[myid].playerAddress, payout);
1848     }
1849     
1850      function __callback(bytes32 myid, string result, bytes _proof) 
1851         onlyOraclize
1852         onlyIfSpinsExist(myid)
1853         onlyIfEnoughFunds(myid)
1854         oraclize_randomDS_proofVerify(myid, result, _proof)
1855     {
1856 		
1857         uint payout = executeSpins(myid, bytes(result));
1858         
1859         sendPayout(myid, payout);
1860         
1861         delete profitDistributed;
1862         delete spins[myid];
1863     }
1864     
1865     // SETTERS - SETTINGS ACCESSIBLE BY OWNER
1866     
1867     // Check ordering as well, since ordering assumptions are made in _callback 
1868     // and elsewhere
1869     function setConfiguration(uint[] _probabilities, uint[] _multipliers) 
1870         onlyOwner 
1871         onlyIfFair(_probabilities, _multipliers) {
1872                 
1873         oraclize_setProof(proofType_Ledger); //This is here to reduce gas cost as this function has to be called anyway for initialization
1874         
1875         delete probabilities;
1876         delete multipliers;
1877         
1878         uint lastProbability = 0;
1879         uint lastMultiplier = 2**256 - 1;
1880         
1881         for (uint i = 0; i < _probabilities.length; i++) {
1882             probabilities.push(_probabilities[i]);
1883             if (lastProbability >= _probabilities[i]) revert();
1884             lastProbability = _probabilities[i];
1885         }
1886         
1887         for (i = 0; i < _multipliers.length; i++) {
1888             multipliers.push(_multipliers[i]);
1889             if (lastMultiplier <= _multipliers[i]) revert();
1890             lastMultiplier = _multipliers[i];
1891         }
1892     }
1893     
1894     function setMinBet(uint _minBet) onlyOwner {
1895         minBet = _minBet;
1896     }
1897     
1898     // GETTERS - CONSTANT METHODS
1899     
1900     function getSpinsContainer(bytes32 myid)
1901         constant
1902         returns(address, uint) {
1903         return (spins[myid].playerAddress, spins[myid].amountWagered); 
1904     }
1905 
1906     // Returns minimal amount to wager to return a profit in case of max win
1907     function getMinAmountToWager(uint _nSpins)
1908         onlyLessThanMaxSpins(_nSpins)
1909         constant
1910 		returns(uint) {
1911         uint gas = _nSpins*ORACLIZE_PER_SPIN_GAS_LIMIT + ORACLIZE_BASE_GAS_LIMIT + safeGas;
1912         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("random", gas);
1913         return minBet + oraclizeFee/multipliers[0] + oraclizeFee;
1914     }
1915    
1916     function getMaxAmountToWager(uint _nSpins)
1917         onlyLessThanMaxSpins(_nSpins)
1918         constant
1919         returns(uint) {
1920 
1921         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("random", _nSpins*ORACLIZE_PER_SPIN_GAS_LIMIT + ORACLIZE_BASE_GAS_LIMIT + safeGas);
1922         uint maxWage =  (CAPITAL_RISK * getBankroll())*10000/((10000 - INVESTORS_EDGE)*10000*multipliers[0]);
1923         return maxWage + oraclizeFee;
1924     }
1925     
1926 }