1 pragma solidity ^0.4.11;
2 
3 //import "./oraclizeAPI_0.4.sol";
4 //import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
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
35 //pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
36 
37 contract OraclizeI {
38     address public cbAddress;
39     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
40     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
41     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
42     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
43     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
44     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
45     function getPrice(string _datasource) returns (uint _dsprice);
46     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
47     function useCoupon(string _coupon);
48     function setProofType(byte _proofType);
49     function setConfig(bytes32 _config);
50     function setCustomGasPrice(uint _gasPrice);
51     function randomDS_getSessionPubKeyHash() returns(bytes32);
52 }
53 contract OraclizeAddrResolverI {
54     function getAddress() returns (address _addr);
55 }
56 contract usingOraclize {
57     uint constant day = 60*60*24;
58     uint constant week = 60*60*24*7;
59     uint constant month = 60*60*24*30;
60     byte constant proofType_NONE = 0x00;
61     byte constant proofType_TLSNotary = 0x10;
62     byte constant proofType_Android = 0x20;
63     byte constant proofType_Ledger = 0x30;
64     byte constant proofType_Native = 0xF0;
65     byte constant proofStorage_IPFS = 0x01;
66     uint8 constant networkID_auto = 0;
67     uint8 constant networkID_mainnet = 1;
68     uint8 constant networkID_testnet = 2;
69     uint8 constant networkID_morden = 2;
70     uint8 constant networkID_consensys = 161;
71 
72     OraclizeAddrResolverI OAR;
73 
74     OraclizeI oraclize;
75     modifier oraclizeAPI {
76         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
77             oraclize_setNetwork(networkID_auto);
78 
79         if(address(oraclize) != OAR.getAddress())
80             oraclize = OraclizeI(OAR.getAddress());
81 
82         _;
83     }
84     modifier coupon(string code){
85         oraclize = OraclizeI(OAR.getAddress());
86         oraclize.useCoupon(code);
87         _;
88     }
89 
90     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
91         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
92             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
93             oraclize_setNetworkName("eth_mainnet");
94             return true;
95         }
96         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
97             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
98             oraclize_setNetworkName("eth_ropsten3");
99             return true;
100         }
101         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
102             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
103             oraclize_setNetworkName("eth_kovan");
104             return true;
105         }
106         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
107             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
108             oraclize_setNetworkName("eth_rinkeby");
109             return true;
110         }
111         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
112             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
113             return true;
114         }
115         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
116             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
117             return true;
118         }
119         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
120             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
121             return true;
122         }
123         return false;
124     }
125 
126     function __callback(bytes32 myid, string result) {
127         __callback(myid, result, new bytes(0));
128     }
129     function __callback(bytes32 myid, string result, bytes proof) {
130     }
131 
132     function oraclize_useCoupon(string code) oraclizeAPI internal {
133         oraclize.useCoupon(code);
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
526     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
527         return oraclize.setConfig(config);
528     }
529 
530     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
531         return oraclize.randomDS_getSessionPubKeyHash();
532     }
533 
534     function getCodeSize(address _addr) constant internal returns(uint _size) {
535         assembly {
536             _size := extcodesize(_addr)
537         }
538     }
539 
540     function parseAddr(string _a) internal returns (address){
541         bytes memory tmp = bytes(_a);
542         uint160 iaddr = 0;
543         uint160 b1;
544         uint160 b2;
545         for (uint i=2; i<2+2*20; i+=2){
546             iaddr *= 256;
547             b1 = uint160(tmp[i]);
548             b2 = uint160(tmp[i+1]);
549             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
550             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
551             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
552             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
553             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
554             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
555             iaddr += (b1*16+b2);
556         }
557         return address(iaddr);
558     }
559 
560     function strCompare(string _a, string _b) internal returns (int) {
561         bytes memory a = bytes(_a);
562         bytes memory b = bytes(_b);
563         uint minLength = a.length;
564         if (b.length < minLength) minLength = b.length;
565         for (uint i = 0; i < minLength; i ++)
566             if (a[i] < b[i])
567                 return -1;
568             else if (a[i] > b[i])
569                 return 1;
570         if (a.length < b.length)
571             return -1;
572         else if (a.length > b.length)
573             return 1;
574         else
575             return 0;
576     }
577 
578     function indexOf(string _haystack, string _needle) internal returns (int) {
579         bytes memory h = bytes(_haystack);
580         bytes memory n = bytes(_needle);
581         if(h.length < 1 || n.length < 1 || (n.length > h.length))
582             return -1;
583         else if(h.length > (2**128 -1))
584             return -1;
585         else
586         {
587             uint subindex = 0;
588             for (uint i = 0; i < h.length; i ++)
589             {
590                 if (h[i] == n[0])
591                 {
592                     subindex = 1;
593                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
594                     {
595                         subindex++;
596                     }
597                     if(subindex == n.length)
598                         return int(i);
599                 }
600             }
601             return -1;
602         }
603     }
604 
605     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
606         bytes memory _ba = bytes(_a);
607         bytes memory _bb = bytes(_b);
608         bytes memory _bc = bytes(_c);
609         bytes memory _bd = bytes(_d);
610         bytes memory _be = bytes(_e);
611         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
612         bytes memory babcde = bytes(abcde);
613         uint k = 0;
614         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
615         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
616         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
617         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
618         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
619         return string(babcde);
620     }
621 
622     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
623         return strConcat(_a, _b, _c, _d, "");
624     }
625 
626     function strConcat(string _a, string _b, string _c) internal returns (string) {
627         return strConcat(_a, _b, _c, "", "");
628     }
629 
630     function strConcat(string _a, string _b) internal returns (string) {
631         return strConcat(_a, _b, "", "", "");
632     }
633 
634     // parseInt
635     function parseInt(string _a) internal returns (uint) {
636         return parseInt(_a, 0);
637     }
638 
639     // parseInt(parseFloat*10^_b)
640     function parseInt(string _a, uint _b) internal returns (uint) {
641         bytes memory bresult = bytes(_a);
642         uint mint = 0;
643         bool decimals = false;
644         for (uint i=0; i<bresult.length; i++){
645             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
646                 if (decimals){
647                    if (_b == 0) break;
648                     else _b--;
649                 }
650                 mint *= 10;
651                 mint += uint(bresult[i]) - 48;
652             } else if (bresult[i] == 46) decimals = true;
653         }
654         if (_b > 0) mint *= 10**_b;
655         return mint;
656     }
657 
658     function uint2str(uint i) internal returns (string){
659         if (i == 0) return "0";
660         uint j = i;
661         uint len;
662         while (j != 0){
663             len++;
664             j /= 10;
665         }
666         bytes memory bstr = new bytes(len);
667         uint k = len - 1;
668         while (i != 0){
669             bstr[k--] = byte(48 + i % 10);
670             i /= 10;
671         }
672         return string(bstr);
673     }
674 
675     function stra2cbor(string[] arr) internal returns (bytes) {
676             uint arrlen = arr.length;
677 
678             // get correct cbor output length
679             uint outputlen = 0;
680             bytes[] memory elemArray = new bytes[](arrlen);
681             for (uint i = 0; i < arrlen; i++) {
682                 elemArray[i] = (bytes(arr[i]));
683                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
684             }
685             uint ctr = 0;
686             uint cborlen = arrlen + 0x80;
687             outputlen += byte(cborlen).length;
688             bytes memory res = new bytes(outputlen);
689 
690             while (byte(cborlen).length > ctr) {
691                 res[ctr] = byte(cborlen)[ctr];
692                 ctr++;
693             }
694             for (i = 0; i < arrlen; i++) {
695                 res[ctr] = 0x5F;
696                 ctr++;
697                 for (uint x = 0; x < elemArray[i].length; x++) {
698                     // if there's a bug with larger strings, this may be the culprit
699                     if (x % 23 == 0) {
700                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
701                         elemcborlen += 0x40;
702                         uint lctr = ctr;
703                         while (byte(elemcborlen).length > ctr - lctr) {
704                             res[ctr] = byte(elemcborlen)[ctr - lctr];
705                             ctr++;
706                         }
707                     }
708                     res[ctr] = elemArray[i][x];
709                     ctr++;
710                 }
711                 res[ctr] = 0xFF;
712                 ctr++;
713             }
714             return res;
715         }
716 
717     function ba2cbor(bytes[] arr) internal returns (bytes) {
718             uint arrlen = arr.length;
719 
720             // get correct cbor output length
721             uint outputlen = 0;
722             bytes[] memory elemArray = new bytes[](arrlen);
723             for (uint i = 0; i < arrlen; i++) {
724                 elemArray[i] = (bytes(arr[i]));
725                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
726             }
727             uint ctr = 0;
728             uint cborlen = arrlen + 0x80;
729             outputlen += byte(cborlen).length;
730             bytes memory res = new bytes(outputlen);
731 
732             while (byte(cborlen).length > ctr) {
733                 res[ctr] = byte(cborlen)[ctr];
734                 ctr++;
735             }
736             for (i = 0; i < arrlen; i++) {
737                 res[ctr] = 0x5F;
738                 ctr++;
739                 for (uint x = 0; x < elemArray[i].length; x++) {
740                     // if there's a bug with larger strings, this may be the culprit
741                     if (x % 23 == 0) {
742                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
743                         elemcborlen += 0x40;
744                         uint lctr = ctr;
745                         while (byte(elemcborlen).length > ctr - lctr) {
746                             res[ctr] = byte(elemcborlen)[ctr - lctr];
747                             ctr++;
748                         }
749                     }
750                     res[ctr] = elemArray[i][x];
751                     ctr++;
752                 }
753                 res[ctr] = 0xFF;
754                 ctr++;
755             }
756             return res;
757         }
758 
759 
760     string oraclize_network_name;
761     function oraclize_setNetworkName(string _network_name) internal {
762         oraclize_network_name = _network_name;
763     }
764 
765     function oraclize_getNetworkName() internal returns (string) {
766         return oraclize_network_name;
767     }
768 
769     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
770         if ((_nbytes == 0)||(_nbytes > 32)) throw;
771 	// Convert from seconds to ledger timer ticks
772         _delay *= 10; 
773         bytes memory nbytes = new bytes(1);
774         nbytes[0] = byte(_nbytes);
775         bytes memory unonce = new bytes(32);
776         bytes memory sessionKeyHash = new bytes(32);
777         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
778         assembly {
779             mstore(unonce, 0x20)
780             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
781             mstore(sessionKeyHash, 0x20)
782             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
783         }
784         bytes memory delay = new bytes(32);
785         assembly { 
786             mstore(add(delay, 0x20), _delay) 
787         }
788         
789         bytes memory delay_bytes8 = new bytes(8);
790         copyBytes(delay, 24, 8, delay_bytes8, 0);
791 
792         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
793         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
794         
795         bytes memory delay_bytes8_left = new bytes(8);
796         
797         assembly {
798             let x := mload(add(delay_bytes8, 0x20))
799             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
800             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
801             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
802             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
803             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
804             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
805             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
806             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
807 
808         }
809         
810         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
811         return queryId;
812     }
813     
814     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
815         oraclize_randomDS_args[queryId] = commitment;
816     }
817 
818     mapping(bytes32=>bytes32) oraclize_randomDS_args;
819     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
820 
821     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
822         bool sigok;
823         address signer;
824 
825         bytes32 sigr;
826         bytes32 sigs;
827 
828         bytes memory sigr_ = new bytes(32);
829         uint offset = 4+(uint(dersig[3]) - 0x20);
830         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
831         bytes memory sigs_ = new bytes(32);
832         offset += 32 + 2;
833         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
834 
835         assembly {
836             sigr := mload(add(sigr_, 32))
837             sigs := mload(add(sigs_, 32))
838         }
839 
840 
841         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
842         if (address(sha3(pubkey)) == signer) return true;
843         else {
844             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
845             return (address(sha3(pubkey)) == signer);
846         }
847     }
848 
849     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
850         bool sigok;
851 
852         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
853         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
854         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
855 
856         bytes memory appkey1_pubkey = new bytes(64);
857         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
858 
859         bytes memory tosign2 = new bytes(1+65+32);
860         tosign2[0] = 1; //role
861         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
862         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
863         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
864         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
865 
866         if (sigok == false) return false;
867 
868 
869         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
870         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
871 
872         bytes memory tosign3 = new bytes(1+65);
873         tosign3[0] = 0xFE;
874         copyBytes(proof, 3, 65, tosign3, 1);
875 
876         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
877         copyBytes(proof, 3+65, sig3.length, sig3, 0);
878 
879         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
880 
881         return sigok;
882     }
883 
884     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
885         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
886         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
887 
888         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
889         if (proofVerified == false) throw;
890 
891         _;
892     }
893 
894     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
895         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
896         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
897 
898         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
899         if (proofVerified == false) return 2;
900 
901         return 0;
902     }
903 
904     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
905         bool match_ = true;
906 	
907 	if (prefix.length != n_random_bytes) throw;
908 	        
909         for (uint256 i=0; i< n_random_bytes; i++) {
910             if (content[i] != prefix[i]) match_ = false;
911         }
912 
913         return match_;
914     }
915 
916     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
917 
918         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
919         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
920         bytes memory keyhash = new bytes(32);
921         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
922         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
923 
924         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
925         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
926 
927         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
928         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
929 
930         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
931         // This is to verify that the computed args match with the ones specified in the query.
932         bytes memory commitmentSlice1 = new bytes(8+1+32);
933         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
934 
935         bytes memory sessionPubkey = new bytes(64);
936         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
937         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
938 
939         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
940         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
941             delete oraclize_randomDS_args[queryId];
942         } else return false;
943 
944 
945         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
946         bytes memory tosign1 = new bytes(32+8+1+32);
947         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
948         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
949 
950         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
951         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
952             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
953         }
954 
955         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
956     }
957 
958 
959     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
960     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
961         uint minLength = length + toOffset;
962 
963         if (to.length < minLength) {
964             // Buffer too small
965             throw; // Should be a better way?
966         }
967 
968         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
969         uint i = 32 + fromOffset;
970         uint j = 32 + toOffset;
971 
972         while (i < (32 + fromOffset + length)) {
973             assembly {
974                 let tmp := mload(add(from, i))
975                 mstore(add(to, j), tmp)
976             }
977             i += 32;
978             j += 32;
979         }
980 
981         return to;
982     }
983 
984     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
985     // Duplicate Solidity's ecrecover, but catching the CALL return value
986     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
987         // We do our own memory management here. Solidity uses memory offset
988         // 0x40 to store the current end of memory. We write past it (as
989         // writes are memory extensions), but don't update the offset so
990         // Solidity will reuse it. The memory used here is only needed for
991         // this context.
992 
993         // FIXME: inline assembly can't access return values
994         bool ret;
995         address addr;
996 
997         assembly {
998             let size := mload(0x40)
999             mstore(size, hash)
1000             mstore(add(size, 32), v)
1001             mstore(add(size, 64), r)
1002             mstore(add(size, 96), s)
1003 
1004             // NOTE: we can reuse the request memory because we deal with
1005             //       the return code
1006             ret := call(3000, 1, 0, size, 128, size, 32)
1007             addr := mload(size)
1008         }
1009 
1010         return (ret, addr);
1011     }
1012 
1013     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1014     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1015         bytes32 r;
1016         bytes32 s;
1017         uint8 v;
1018 
1019         if (sig.length != 65)
1020           return (false, 0);
1021 
1022         // The signature format is a compact form of:
1023         //   {bytes32 r}{bytes32 s}{uint8 v}
1024         // Compact means, uint8 is not padded to 32 bytes.
1025         assembly {
1026             r := mload(add(sig, 32))
1027             s := mload(add(sig, 64))
1028 
1029             // Here we are loading the last 32 bytes. We exploit the fact that
1030             // 'mload' will pad with zeroes if we overread.
1031             // There is no 'mload8' to do this, but that would be nicer.
1032             v := byte(0, mload(add(sig, 96)))
1033 
1034             // Alternative solution:
1035             // 'byte' is not working due to the Solidity parser, so lets
1036             // use the second best option, 'and'
1037             // v := and(mload(add(sig, 65)), 255)
1038         }
1039 
1040         // albeit non-transactional signatures are not specified by the YP, one would expect it
1041         // to match the YP range of [27, 28]
1042         //
1043         // geth uses [0, 1] and some clients have followed. This might change, see:
1044         //  https://github.com/ethereum/go-ethereum/issues/2053
1045         if (v < 27)
1046           v += 27;
1047 
1048         if (v != 27 && v != 28)
1049             return (false, 0);
1050 
1051         return safer_ecrecover(hash, v, r, s);
1052     }
1053 
1054 }
1055 // </ORACLIZE_API>
1056 
1057 
1058 contract Dice is usingOraclize {
1059 
1060     //Definition of Constant======================================================================================================
1061     uint constant INVALID_BETPRICE_ID = 999999;//Invalid bet amount ID
1062     uint constant INVALID_BET_ID = 0;//Invalid bet ID
1063 
1064     //Bet Status
1065     uint constant BET_STATE_WAITPAIR = 0;//Wait for a challenger
1066     uint constant BET_STATE_WAITORACLIZE = 1;//Wait for the result
1067     uint constant BET_STATE_END = 2;//End successfully
1068     uint constant BET_STATE_CANCEL_BY_PLAYER = 3;//Canceled by the player
1069     uint constant BET_STATE_CANCEL_BY_OWNER = 4;//Canceled by the contract owner
1070     uint constant BET_STATE_CANCEL_BY_ORACLIZE_ERROR_RANDOM_NUMBER = 5;//Canceled due to random number not being verified
1071     uint constant BET_STATE_CANCEL_BY_ORACLIZE_ERROR_FEE = 6;//Canceled due to service fee is more than the bet amount
1072     uint constant BET_STATE_CANCEL_BY_RANDOM_NUMBER_A_EUQAL_B = 7;//Canceled due to ending in a draw
1073 
1074     
1075     //Variables of Contract Management===================================================================================================
1076     address public owner;//Contract Owner
1077     bool public isStopped;//Pause the Contract
1078 
1079     //Variables of Bet===================================================================================================
1080     //Definition of Bet Storage Structure
1081     struct Bet {
1082         uint betPrice;//Bet Amount
1083         uint betState;//Bet Status
1084         address playerAddressA;//Address of Player A
1085         address playerAddressB;//Address of Player B
1086         uint numberRolled;//Returned random numbers from Oraclize
1087         uint oraclizeFee;//Service fee of random number
1088     }
1089 
1090     uint public betFee = 200; //Bet Transaction Fee (10000 = 100%)
1091     uint[] public betPrices = [  200 finney , 500 finney, 1000 finney];//Bet Amount Option
1092     uint[] public waitPairBetIDs = [ INVALID_BET_ID , INVALID_BET_ID ,INVALID_BET_ID];//Current Bet ID that waiting for matching of each option
1093     uint public oraclizeCallbackGasLimit = 200000;//GasLimit of Oraclize
1094     Bet[] public bets ;//Save all bet data in chronological order
1095     mapping (bytes32 => uint) public oraclizeQueryID2BetID;// Mapping of random number query ID to Bet ID
1096     mapping (address => uint) public address2SendErrorValue;// Mapping of address to SendErrorValue
1097 
1098     //Event Notification======================================================================================================
1099     event LOG_ORACLIZE_CALLBACK(uint indexed betid , bytes32 _queryId, string _result, bytes _proof);
1100     event LOG_SEND_ERROR(uint indexed betid , address indexed player, uint value);
1101     event LOG_SET_SEND_ERROR_VALUE(address indexed player, uint value);
1102 
1103     //Constructor =====================================================================================================
1104     function Dice() {
1105         oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof in the constructor
1106         owner = msg.sender;
1107         bets.push(Bet(0,0,address(0x0),address(0x0),0,0));//Bet 0 is invalid
1108     }
1109 
1110     //Function Modification=====================================================================================================
1111     modifier onlyIfNotStopped {
1112         if (isStopped) throw;
1113         _;
1114     }
1115 
1116     modifier onlyOwner {
1117         if (owner != msg.sender) throw;
1118         _;
1119     }
1120 
1121     modifier onlyBetCanCancel(uint betid) {
1122         if((bets[betid].betState != BET_STATE_WAITPAIR)&&
1123         (bets[betid].betState != BET_STATE_WAITORACLIZE)
1124         ) throw;//Cannot cancel
1125         _;
1126     }
1127 
1128     //Contract Management=====================================================================================================
1129 
1130     function stopContract() public
1131         onlyOwner {
1132         isStopped = true;
1133     }
1134 
1135     function resumeContract() public
1136         onlyOwner {
1137         isStopped = false;
1138     }
1139 
1140     function changeOwnerAddress(address newOwner) public
1141         onlyOwner {
1142         if (newOwner == address(0x0)) throw;
1143         owner = newOwner;
1144     }
1145 
1146     //Bet Management=====================================================================================================    
1147     function setBetFee(uint newfee) public
1148         onlyOwner
1149     {
1150         betFee = newfee;
1151     }
1152 
1153     function setOraclizeCallbackGasLimit(uint newgaslimit) public
1154         onlyOwner
1155     {
1156         oraclizeCallbackGasLimit = newgaslimit;
1157     }
1158 
1159 
1160     function setOraclizeCallbackGasPrice(uint newgasprice) public
1161 		onlyOwner
1162 	{
1163         oraclize_setCustomGasPrice(newgasprice);
1164     }     
1165     
1166 
1167     //Contract Owner withdraws the profit from the contract and sent to the specific account
1168     function getProfitToAddress(uint profit , address receiver) public
1169         onlyOwner
1170     {
1171         //Cannot withdraw the pending bets
1172         if(this.balance - profit < getBetWaitEndEther()) throw;
1173 
1174         receiver.transfer(profit);
1175     }
1176 
1177     //Withdraw all profit to the owner
1178     function getProfit() public
1179         onlyOwner
1180     {
1181         owner.transfer(this.balance - getBetWaitEndEther());
1182     }
1183 
1184     //Cancel all pending bets to modify the bet options
1185     function clearWaitPairBets() public
1186         onlyOwner
1187     {
1188         for( uint i = 0 ;i<waitPairBetIDs.length;i++){
1189             //Cancel all pending bets of this amount option
1190             while(waitPairBetIDs[i] != INVALID_BET_ID){
1191                 cancelBetByOwner(waitPairBetIDs[i]);
1192             }
1193         }
1194     }
1195 
1196 
1197     function setBetPrices(uint[] newprices) public
1198         onlyOwner
1199     {
1200         //Set new amount option only while no bet pending
1201         uint i=0;
1202         for( ;i<waitPairBetIDs.length;i++){
1203             if(waitPairBetIDs[i] != INVALID_BET_ID)
1204                 throw;
1205         }
1206 
1207         //Set new bet amount option
1208         betPrices = newprices;
1209         //Reset pending bet ID after setting up new bet amount option
1210         waitPairBetIDs = new uint[](betPrices.length);
1211         for(i = 0 ;i<waitPairBetIDs.length;i++){
1212             waitPairBetIDs[i] = INVALID_BET_ID;
1213         }
1214     }
1215 
1216 
1217     function setSendErrorValue(address player , uint value) public
1218         onlyOwner
1219     {
1220         address2SendErrorValue[player] = value;
1221         LOG_SET_SEND_ERROR_VALUE(player,value);
1222     }
1223 
1224 
1225 
1226     //Place the Bet=====================================================================================================
1227     
1228     function() public
1229         payable 
1230     {
1231 
1232         bet();
1233     }
1234 
1235     function bet() public
1236         payable
1237         onlyIfNotStopped 
1238     {
1239         //Verify the Bet
1240         uint betpriceid = getBetPriceID(msg.value);
1241         if(betpriceid != INVALID_BETPRICE_ID){
1242             //Verified; place the bet
1243             doBet(betpriceid);
1244         }else{
1245             //Refund If invalid bet and not from the contract owner; if it is from the contract owner, do not refund (for funding purpose)
1246             if (owner != msg.sender) throw;
1247         }
1248     }
1249 
1250     function doBet(uint betpriceid)
1251         private
1252     {
1253 
1254 
1255         //Start matching if there is pending bet that not from you
1256         uint waitpairbetid = waitPairBetIDs[betpriceid];
1257         if ((waitpairbetid != INVALID_BET_ID )&&(bets[waitpairbetid].playerAddressA != msg.sender)){
1258 
1259             bets[waitpairbetid].betState = BET_STATE_WAITORACLIZE;
1260             bets[waitpairbetid].playerAddressB = msg.sender;
1261 
1262             uint oraclizeFee = getOraclizePrice();
1263             if (oraclizeFee > msg.value ) {
1264                 //Invalid if the service fee of random number is more than the bet amount; cancel the bet without deducting the commission
1265                 cancelBet(waitpairbetid,false,BET_STATE_CANCEL_BY_ORACLIZE_ERROR_FEE);
1266             }else{
1267                 //Random Number Query
1268                 bytes32 oraclizeQueryID = oraclize_newRandomDSQuery(0, 2, oraclizeCallbackGasLimit); // this function internally generates the correct oraclize_query and returns its queryId
1269                 oraclizeQueryID2BetID[ oraclizeQueryID ] = waitpairbetid;//Save the mapping of Query ID to Bet ID
1270                 bets[waitpairbetid].oraclizeFee = oraclizeFee;
1271 
1272                 //Update waitPairBetIDs
1273                 findNextwaitPairBetIDs(betpriceid , waitpairbetid);
1274             }
1275         }else {
1276             //Generate New Bet
1277             bets.push( Bet(
1278                 msg.value,//Bet Amount
1279                 BET_STATE_WAITPAIR,//Bet Status
1280                 msg.sender,//Address of Player A
1281                 address(0x0),//Address of Player B
1282                 0,//Random Number
1283                 0//Service Fee of Random Number Query
1284             ));
1285 
1286             //Update waitPairBetIDs    
1287             if (waitpairbetid == INVALID_BET_ID )
1288                 waitPairBetIDs[betpriceid] = bets.length - 1;
1289                         
1290         }
1291 
1292     }
1293 
1294 
1295 
1296     function getBetPriceID(uint sendvalue)
1297         private
1298         returns (uint)
1299     {
1300         for(uint i = 0;i < betPrices.length;i++){
1301             if(betPrices[i]==sendvalue)
1302                 return i;
1303         }
1304         return INVALID_BETPRICE_ID;
1305     }
1306 
1307     function findNextwaitPairBetIDs(uint betpriceid,uint betid)
1308         private
1309     {
1310 
1311         for(uint i = betid+1 ; i< bets.length ; i++){
1312             if( ( bets[i].betPrice == betPrices[betpriceid])&&(bets[i].betState == BET_STATE_WAITPAIR)){
1313                 waitPairBetIDs[betpriceid] = i;
1314                 return;
1315             }
1316         }
1317 
1318         //No new pending bet
1319         waitPairBetIDs[betpriceid] = INVALID_BET_ID;
1320     }
1321 
1322 
1323     //Callback of Oraclize Random Number=========================================================================================
1324     function __callback(bytes32 _queryId, string _result, bytes _proof) public
1325     { 
1326         //Only Oraclize can use callback
1327         if (msg.sender != oraclize_cbAddress()) throw;
1328 
1329         uint betid = oraclizeQueryID2BetID[_queryId];
1330 
1331         //Verify the Bet
1332         if(bets[betid].playerAddressA == address(0x0)) throw;
1333         if(bets[betid].playerAddressB == address(0x0)) throw;
1334         if(bets[betid].betState != BET_STATE_WAITORACLIZE) throw;
1335 
1336         //Record the log of Oraclize callback data
1337         LOG_ORACLIZE_CALLBACK(betid,_queryId,_result,_proof);
1338 
1339         if ( oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
1340             //Invalid random number; cancel the bet and deduct the service fee
1341             cancelBet(betid,false,BET_STATE_CANCEL_BY_ORACLIZE_ERROR_RANDOM_NUMBER);
1342         } else {
1343             // the proof verification has passed
1344             uint maxRange = 2**(8 * 2); // this is the highest uint we want to get. It should never be greater than 2^(8*N), where N is the number of random bytes we had asked the datasource to return
1345             uint randomNumber = uint(sha3(_result)) % maxRange; // this is an efficient way to get the uint out in the [0, maxRange] range
1346             
1347             //The left 8 digits is A’s result and the right 8 digits is B’s result
1348             //The bigger number wins; equal means a draw
1349             uint randomA = randomNumber >> 8;
1350             uint randomB = randomNumber & 0x00FF;
1351             
1352             //Save Bet Result
1353             bets[betid].numberRolled = randomNumber;
1354 
1355             //Send Prize
1356             //Prize = Bet Amount - Transaction Fee - Service Fee
1357             uint winAmount = 2 * bets[betid].betPrice  -  2 * ( bets[betid].betPrice * betFee / 10000 ) - bets[betid].oraclizeFee;
1358             bool senderror = false;
1359             if(randomA == randomB){
1360                 //A game ended in a draw will deduct the commission
1361                 cancelBet(betid,true,BET_STATE_CANCEL_BY_RANDOM_NUMBER_A_EUQAL_B);                
1362             }else{
1363                 address win;
1364                 address lose;
1365                 if(randomA > randomB){
1366                     win = bets[betid].playerAddressA;
1367                     lose = bets[betid].playerAddressB;
1368                 }else{
1369                     win = bets[betid].playerAddressB;
1370                     lose = bets[betid].playerAddressA;
1371                 }
1372 
1373                 //Send coin to the winner
1374                 if(!win.send(winAmount)){
1375                     //Failed to send coin
1376                     address2SendErrorValue[win] += winAmount;
1377                     LOG_SEND_ERROR(betid,win,winAmount);
1378                 }
1379 
1380                 //Send coin to the loser
1381                 if(!lose.send(1)){
1382                     //Failed to send coin
1383                     address2SendErrorValue[lose] += 1;
1384                     LOG_SEND_ERROR(betid,lose,1);                    
1385                 }
1386                 
1387                 //Successfully ended
1388                 bets[betid].betState = BET_STATE_END;
1389             }
1390         }
1391     }
1392 
1393     
1394 
1395     //Cancel the Bet=====================================================================================================
1396     //Player cancels the bet
1397     function cancelBetByPlayer(uint betid) public
1398             onlyBetCanCancel(betid)  
1399     {                
1400         if (bets[betid].playerAddressA == msg.sender) 
1401             cancelBetByA(betid);
1402         else if (bets[betid].playerAddressB == msg.sender)
1403             cancelBetByB(betid);
1404         else
1405             throw;
1406     }
1407 
1408     function cancelBetByA(uint betid)
1409         private
1410     {
1411         if(bets[betid].playerAddressB != address(0x0)){
1412             //If there is a Player B, the Player B turns into a Player A and waits for the matching
1413             bets[betid].playerAddressA = bets[betid].playerAddressB;
1414             bets[betid].playerAddressB = address(0x0);
1415             bets[betid].betState = BET_STATE_WAITPAIR;
1416             //Update waitPairBetIDs    
1417             uint betpriceid = getBetPriceID(bets[betid].betPrice);
1418             waitPairBetIDs[betpriceid] = betid;
1419         }else{
1420             //if there is no Player B, cancel the bet and update waitPairBetIDs
1421             bets[betid].betState = BET_STATE_CANCEL_BY_PLAYER;
1422             refreshWaitPairBetIDsByCancelBet(betid);
1423         }
1424 
1425         //Refund to Player A
1426         sendCancelValue(bets[betid].playerAddressA ,betid,false);
1427 
1428 
1429     }
1430 
1431     function cancelBetByB(uint betid)
1432         private
1433     {
1434         //If Player B cancels the bet, Player A restarts the waiting of the matching
1435         bets[betid].playerAddressB = address(0x0);
1436         bets[betid].betState = BET_STATE_WAITPAIR;
1437         //Update waitPairBetIDs
1438         uint betpriceid = getBetPriceID(bets[betid].betPrice);
1439         waitPairBetIDs[betpriceid] = betid;
1440 
1441         //Refund to Player B
1442         sendCancelValue(bets[betid].playerAddressB ,betid,false);
1443     }
1444 
1445     function cancelBetByOwner(uint betid) public
1446         onlyOwner
1447     {
1448         //Cancel the bet and update pending Bet IDs
1449         cancelBet(betid,false,BET_STATE_CANCEL_BY_OWNER);
1450     }
1451 
1452     function cancelBet(uint betid,bool fee,uint betstate)
1453         private
1454         onlyBetCanCancel(betid)        
1455     {
1456 
1457         //Cancel Player A
1458         sendCancelValue(bets[betid].playerAddressA ,betid,fee);
1459 
1460         //Cancel Player B if there is one
1461         if(bets[betid].playerAddressB != address(0x0)){
1462             sendCancelValue(bets[betid].playerAddressB ,betid,fee);
1463         }
1464 
1465         bets[betid].betState = betstate;
1466 
1467         //Update waitPairBetIDs
1468         refreshWaitPairBetIDsByCancelBet(betid);
1469     }
1470 
1471     function refreshWaitPairBetIDsByCancelBet(uint betid)
1472         private
1473     {
1474         for( uint i = 0 ;i<waitPairBetIDs.length;i++){
1475             if(waitPairBetIDs[i] == betid){                
1476                 findNextwaitPairBetIDs(i , betid);
1477                 break;
1478             }
1479         }
1480     }
1481 
1482     function sendCancelValue(address receiver,uint betid,bool fee)
1483         private
1484     {
1485         //Refund = Bet Amount – Transaction Fee – Service Fee
1486         uint cancelAmount = bets[betid].betPrice  -  bets[betid].betPrice * (fee ? betFee : 0) / 10000 - bets[betid].oraclizeFee / 2;
1487         if(!receiver.send(cancelAmount)){
1488             address2SendErrorValue[receiver] += cancelAmount;
1489             LOG_SEND_ERROR(betid,receiver,cancelAmount);            
1490         }
1491 
1492     }
1493 
1494     //Auxiliary Function of Contract Query=======================================================================================================
1495     //Get Bet Info
1496     function getBets(uint start , uint length) public
1497         constant
1498         returns(uint[])
1499     {   
1500         //Verify the Parameter
1501         if(start >= bets.length) throw;      
1502         if(length == 0) throw;  
1503 
1504         if(start+length > bets.length)
1505             length = bets.length - start;
1506 
1507         uint[] memory result = new uint[](length*6);
1508         for (uint i = 0; i < length; i++){
1509             result[i*6] = bets[start+i].betPrice;
1510 	    result[i*6+1] = bets[start+i].betState;
1511 	    result[i*6+2] = uint(bets[start+i].playerAddressA);
1512 	    result[i*6+3] = uint(bets[start+i].playerAddressB);
1513 	    result[i*6+4] = bets[start+i].numberRolled;
1514 	    result[i*6+5] = bets[start+i].oraclizeFee;
1515 	}
1516         return result;
1517     }
1518 
1519     function getBetsLength() public
1520         constant
1521         returns(uint)
1522     {
1523         return bets.length;
1524     }
1525 
1526     //Get the amount of pending bets
1527     function getBetWaitEndEther() public
1528         constant
1529         returns(uint result)
1530     {
1531         for(uint i=1; i < bets.length ; i++){
1532             if(  bets[i].betState == BET_STATE_WAITPAIR  ){
1533                 result += bets[i].betPrice;
1534             }else if ( bets[i].betState == BET_STATE_WAITORACLIZE ){
1535                 result += bets[i].betPrice * 2;                
1536             }
1537         }
1538 
1539         return result;
1540 
1541     }    
1542 
1543     //Get Service Fee of Random Number
1544     function getOraclizePrice() public
1545         constant
1546         returns (uint)
1547     {
1548         return oraclize_getPrice("random", oraclizeCallbackGasLimit);
1549     }
1550 
1551 }