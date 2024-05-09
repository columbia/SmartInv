1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize SRL
4 Copyright (c) 2016 Oraclize LTD
5 
6 
7 
8 Permission is hereby granted, free of charge, to any person obtaining a copy
9 of this software and associated documentation files (the "Software"), to deal
10 in the Software without restriction, including without limitation the rights
11 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 copies of the Software, and to permit persons to whom the Software is
13 furnished to do so, subject to the following conditions:
14 
15 
16 
17 The above copyright notice and this permission notice shall be included in
18 all copies or substantial portions of the Software.
19 
20 
21 
22 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
25 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
28 THE SOFTWARE.
29 */
30 
31 pragma solidity ^0.4.11;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
32 
33 contract OraclizeI {
34     address public cbAddress;
35     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
36     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
37     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
38     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
39     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
40     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
41     function getPrice(string _datasource) returns (uint _dsprice);
42     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
43     function useCoupon(string _coupon);
44     function setProofType(byte _proofType);
45     function setConfig(bytes32 _config);
46     function setCustomGasPrice(uint _gasPrice);
47     function randomDS_getSessionPubKeyHash() returns(bytes32);
48 }
49 contract OraclizeAddrResolverI {
50     function getAddress() returns (address _addr);
51 }
52 contract usingOraclize {
53     uint constant day = 60*60*24;
54     uint constant week = 60*60*24*7;
55     uint constant month = 60*60*24*30;
56     byte constant proofType_NONE = 0x00;
57     byte constant proofType_TLSNotary = 0x10;
58     byte constant proofType_Android = 0x20;
59     byte constant proofType_Ledger = 0x30;
60     byte constant proofType_Native = 0xF0;
61     byte constant proofStorage_IPFS = 0x01;
62     uint8 constant networkID_auto = 0;
63     uint8 constant networkID_mainnet = 1;
64     uint8 constant networkID_testnet = 2;
65     uint8 constant networkID_morden = 2;
66     uint8 constant networkID_consensys = 161;
67 
68     OraclizeAddrResolverI OAR;
69 
70     OraclizeI oraclize;
71     modifier oraclizeAPI {
72         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork();
73         oraclize = OraclizeI(OAR.getAddress());
74         _;
75     }
76     modifier coupon(string code){
77         oraclize = OraclizeI(OAR.getAddress());
78         oraclize.useCoupon(code);
79         _;
80     }
81 
82     function oraclize_setNetwork() internal returns(bool){
83         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
84             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
85             oraclize_setNetworkName("eth_mainnet");
86             return true;
87         }
88         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
89             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
90             oraclize_setNetworkName("eth_ropsten3");
91             return true;
92         }
93         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
94             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
95             oraclize_setNetworkName("eth_kovan");
96             return true;
97         }
98         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
99             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
100             oraclize_setNetworkName("eth_rinkeby");
101             return true;
102         }
103         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
104             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
105             return true;
106         }
107         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
108             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
109             return true;
110         }
111         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
112             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
113             return true;
114         }
115         return false;
116     }
117 
118     function __callback(bytes32 myid, string result) {
119         __callback(myid, result, new bytes(0));
120     }
121     function __callback(bytes32 myid, string result, bytes proof) {
122         myid;
123         result;
124         proof;
125     }
126     
127     function oraclize_useCoupon(string code) oraclizeAPI internal {
128         oraclize.useCoupon(code);
129     }
130 
131     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
132         return oraclize.getPrice(datasource);
133     }
134 
135     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
136         return oraclize.getPrice(datasource, gaslimit);
137     }
138     
139     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
140         uint price = oraclize.getPrice(datasource);
141         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
142         return oraclize.query.value(price)(0, datasource, arg);
143     }
144     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
145         uint price = oraclize.getPrice(datasource);
146         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
147         return oraclize.query.value(price)(timestamp, datasource, arg);
148     }
149     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
150         uint price = oraclize.getPrice(datasource, gaslimit);
151         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
152         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
153     }
154     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
155         uint price = oraclize.getPrice(datasource, gaslimit);
156         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
157         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
158     }
159     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
160         uint price = oraclize.getPrice(datasource);
161         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
162         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
163     }
164     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
165         uint price = oraclize.getPrice(datasource);
166         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
167         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
168     }
169     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
170         uint price = oraclize.getPrice(datasource, gaslimit);
171         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
172         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
173     }
174     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
175         uint price = oraclize.getPrice(datasource, gaslimit);
176         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
177         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
178     }
179     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
180         uint price = oraclize.getPrice(datasource);
181         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
182         bytes memory args = stra2cbor(argN);
183         return oraclize.queryN.value(price)(0, datasource, args);
184     }
185     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
186         uint price = oraclize.getPrice(datasource);
187         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
188         bytes memory args = stra2cbor(argN);
189         return oraclize.queryN.value(price)(timestamp, datasource, args);
190     }
191     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
192         uint price = oraclize.getPrice(datasource, gaslimit);
193         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
194         bytes memory args = stra2cbor(argN);
195         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
196     }
197     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
198         uint price = oraclize.getPrice(datasource, gaslimit);
199         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
200         bytes memory args = stra2cbor(argN);
201         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
202     }
203     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
204         string[] memory dynargs = new string[](1);
205         dynargs[0] = args[0];
206         return oraclize_query(datasource, dynargs);
207     }
208     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
209         string[] memory dynargs = new string[](1);
210         dynargs[0] = args[0];
211         return oraclize_query(timestamp, datasource, dynargs);
212     }
213     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
214         string[] memory dynargs = new string[](1);
215         dynargs[0] = args[0];
216         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
217     }
218     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
219         string[] memory dynargs = new string[](1);
220         dynargs[0] = args[0];       
221         return oraclize_query(datasource, dynargs, gaslimit);
222     }
223     
224     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
225         string[] memory dynargs = new string[](2);
226         dynargs[0] = args[0];
227         dynargs[1] = args[1];
228         return oraclize_query(datasource, dynargs);
229     }
230     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
231         string[] memory dynargs = new string[](2);
232         dynargs[0] = args[0];
233         dynargs[1] = args[1];
234         return oraclize_query(timestamp, datasource, dynargs);
235     }
236     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
237         string[] memory dynargs = new string[](2);
238         dynargs[0] = args[0];
239         dynargs[1] = args[1];
240         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
241     }
242     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
243         string[] memory dynargs = new string[](2);
244         dynargs[0] = args[0];
245         dynargs[1] = args[1];
246         return oraclize_query(datasource, dynargs, gaslimit);
247     }
248     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
249         string[] memory dynargs = new string[](3);
250         dynargs[0] = args[0];
251         dynargs[1] = args[1];
252         dynargs[2] = args[2];
253         return oraclize_query(datasource, dynargs);
254     }
255     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
256         string[] memory dynargs = new string[](3);
257         dynargs[0] = args[0];
258         dynargs[1] = args[1];
259         dynargs[2] = args[2];
260         return oraclize_query(timestamp, datasource, dynargs);
261     }
262     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
263         string[] memory dynargs = new string[](3);
264         dynargs[0] = args[0];
265         dynargs[1] = args[1];
266         dynargs[2] = args[2];
267         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
268     }
269     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
270         string[] memory dynargs = new string[](3);
271         dynargs[0] = args[0];
272         dynargs[1] = args[1];
273         dynargs[2] = args[2];
274         return oraclize_query(datasource, dynargs, gaslimit);
275     }
276     
277     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
278         string[] memory dynargs = new string[](4);
279         dynargs[0] = args[0];
280         dynargs[1] = args[1];
281         dynargs[2] = args[2];
282         dynargs[3] = args[3];
283         return oraclize_query(datasource, dynargs);
284     }
285     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
286         string[] memory dynargs = new string[](4);
287         dynargs[0] = args[0];
288         dynargs[1] = args[1];
289         dynargs[2] = args[2];
290         dynargs[3] = args[3];
291         return oraclize_query(timestamp, datasource, dynargs);
292     }
293     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
294         string[] memory dynargs = new string[](4);
295         dynargs[0] = args[0];
296         dynargs[1] = args[1];
297         dynargs[2] = args[2];
298         dynargs[3] = args[3];
299         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
300     }
301     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
302         string[] memory dynargs = new string[](4);
303         dynargs[0] = args[0];
304         dynargs[1] = args[1];
305         dynargs[2] = args[2];
306         dynargs[3] = args[3];
307         return oraclize_query(datasource, dynargs, gaslimit);
308     }
309     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
310         string[] memory dynargs = new string[](5);
311         dynargs[0] = args[0];
312         dynargs[1] = args[1];
313         dynargs[2] = args[2];
314         dynargs[3] = args[3];
315         dynargs[4] = args[4];
316         return oraclize_query(datasource, dynargs);
317     }
318     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
319         string[] memory dynargs = new string[](5);
320         dynargs[0] = args[0];
321         dynargs[1] = args[1];
322         dynargs[2] = args[2];
323         dynargs[3] = args[3];
324         dynargs[4] = args[4];
325         return oraclize_query(timestamp, datasource, dynargs);
326     }
327     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
328         string[] memory dynargs = new string[](5);
329         dynargs[0] = args[0];
330         dynargs[1] = args[1];
331         dynargs[2] = args[2];
332         dynargs[3] = args[3];
333         dynargs[4] = args[4];
334         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
335     }
336     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
337         string[] memory dynargs = new string[](5);
338         dynargs[0] = args[0];
339         dynargs[1] = args[1];
340         dynargs[2] = args[2];
341         dynargs[3] = args[3];
342         dynargs[4] = args[4];
343         return oraclize_query(datasource, dynargs, gaslimit);
344     }
345     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
346         uint price = oraclize.getPrice(datasource);
347         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
348         bytes memory args = ba2cbor(argN);
349         return oraclize.queryN.value(price)(0, datasource, args);
350     }
351     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
352         uint price = oraclize.getPrice(datasource);
353         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
354         bytes memory args = ba2cbor(argN);
355         return oraclize.queryN.value(price)(timestamp, datasource, args);
356     }
357     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
358         uint price = oraclize.getPrice(datasource, gaslimit);
359         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
360         bytes memory args = ba2cbor(argN);
361         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
362     }
363     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
364         uint price = oraclize.getPrice(datasource, gaslimit);
365         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
366         bytes memory args = ba2cbor(argN);
367         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
368     }
369     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
370         bytes[] memory dynargs = new bytes[](1);
371         dynargs[0] = args[0];
372         return oraclize_query(datasource, dynargs);
373     }
374     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
375         bytes[] memory dynargs = new bytes[](1);
376         dynargs[0] = args[0];
377         return oraclize_query(timestamp, datasource, dynargs);
378     }
379     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
380         bytes[] memory dynargs = new bytes[](1);
381         dynargs[0] = args[0];
382         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
383     }
384     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
385         bytes[] memory dynargs = new bytes[](1);
386         dynargs[0] = args[0];       
387         return oraclize_query(datasource, dynargs, gaslimit);
388     }
389     
390     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
391         bytes[] memory dynargs = new bytes[](2);
392         dynargs[0] = args[0];
393         dynargs[1] = args[1];
394         return oraclize_query(datasource, dynargs);
395     }
396     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
397         bytes[] memory dynargs = new bytes[](2);
398         dynargs[0] = args[0];
399         dynargs[1] = args[1];
400         return oraclize_query(timestamp, datasource, dynargs);
401     }
402     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
403         bytes[] memory dynargs = new bytes[](2);
404         dynargs[0] = args[0];
405         dynargs[1] = args[1];
406         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
407     }
408     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
409         bytes[] memory dynargs = new bytes[](2);
410         dynargs[0] = args[0];
411         dynargs[1] = args[1];
412         return oraclize_query(datasource, dynargs, gaslimit);
413     }
414     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
415         bytes[] memory dynargs = new bytes[](3);
416         dynargs[0] = args[0];
417         dynargs[1] = args[1];
418         dynargs[2] = args[2];
419         return oraclize_query(datasource, dynargs);
420     }
421     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
422         bytes[] memory dynargs = new bytes[](3);
423         dynargs[0] = args[0];
424         dynargs[1] = args[1];
425         dynargs[2] = args[2];
426         return oraclize_query(timestamp, datasource, dynargs);
427     }
428     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
429         bytes[] memory dynargs = new bytes[](3);
430         dynargs[0] = args[0];
431         dynargs[1] = args[1];
432         dynargs[2] = args[2];
433         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
434     }
435     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
436         bytes[] memory dynargs = new bytes[](3);
437         dynargs[0] = args[0];
438         dynargs[1] = args[1];
439         dynargs[2] = args[2];
440         return oraclize_query(datasource, dynargs, gaslimit);
441     }
442     
443     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
444         bytes[] memory dynargs = new bytes[](4);
445         dynargs[0] = args[0];
446         dynargs[1] = args[1];
447         dynargs[2] = args[2];
448         dynargs[3] = args[3];
449         return oraclize_query(datasource, dynargs);
450     }
451     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
452         bytes[] memory dynargs = new bytes[](4);
453         dynargs[0] = args[0];
454         dynargs[1] = args[1];
455         dynargs[2] = args[2];
456         dynargs[3] = args[3];
457         return oraclize_query(timestamp, datasource, dynargs);
458     }
459     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
460         bytes[] memory dynargs = new bytes[](4);
461         dynargs[0] = args[0];
462         dynargs[1] = args[1];
463         dynargs[2] = args[2];
464         dynargs[3] = args[3];
465         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
466     }
467     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
468         bytes[] memory dynargs = new bytes[](4);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         dynargs[2] = args[2];
472         dynargs[3] = args[3];
473         return oraclize_query(datasource, dynargs, gaslimit);
474     }
475     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
476         bytes[] memory dynargs = new bytes[](5);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         dynargs[2] = args[2];
480         dynargs[3] = args[3];
481         dynargs[4] = args[4];
482         return oraclize_query(datasource, dynargs);
483     }
484     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
485         bytes[] memory dynargs = new bytes[](5);
486         dynargs[0] = args[0];
487         dynargs[1] = args[1];
488         dynargs[2] = args[2];
489         dynargs[3] = args[3];
490         dynargs[4] = args[4];
491         return oraclize_query(timestamp, datasource, dynargs);
492     }
493     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
494         bytes[] memory dynargs = new bytes[](5);
495         dynargs[0] = args[0];
496         dynargs[1] = args[1];
497         dynargs[2] = args[2];
498         dynargs[3] = args[3];
499         dynargs[4] = args[4];
500         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
501     }
502     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
503         bytes[] memory dynargs = new bytes[](5);
504         dynargs[0] = args[0];
505         dynargs[1] = args[1];
506         dynargs[2] = args[2];
507         dynargs[3] = args[3];
508         dynargs[4] = args[4];
509         return oraclize_query(datasource, dynargs, gaslimit);
510     }
511 
512     function oraclize_cbAddress() oraclizeAPI internal returns (address){
513         return oraclize.cbAddress();
514     }
515     function oraclize_setProof(byte proofP) oraclizeAPI internal {
516         return oraclize.setProofType(proofP);
517     }
518     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
519         return oraclize.setCustomGasPrice(gasPrice);
520     }
521     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
522         return oraclize.setConfig(config);
523     }
524     
525     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
526         return oraclize.randomDS_getSessionPubKeyHash();
527     }
528 
529     function getCodeSize(address _addr) constant internal returns(uint _size) {
530         assembly {
531             _size := extcodesize(_addr)
532         }
533         
534         _addr;
535         _size;
536     }
537 
538     function parseAddr(string _a) internal returns (address){
539         bytes memory tmp = bytes(_a);
540         uint160 iaddr = 0;
541         uint160 b1;
542         uint160 b2;
543         for (uint i=2; i<2+2*20; i+=2){
544             iaddr *= 256;
545             b1 = uint160(tmp[i]);
546             b2 = uint160(tmp[i+1]);
547             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
548             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
549             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
550             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
551             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
552             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
553             iaddr += (b1*16+b2);
554         }
555         return address(iaddr);
556     }
557 
558     function strCompare(string _a, string _b) internal returns (int) {
559         bytes memory a = bytes(_a);
560         bytes memory b = bytes(_b);
561         uint minLength = a.length;
562         if (b.length < minLength) minLength = b.length;
563         for (uint i = 0; i < minLength; i ++)
564             if (a[i] < b[i])
565                 return -1;
566             else if (a[i] > b[i])
567                 return 1;
568         if (a.length < b.length)
569             return -1;
570         else if (a.length > b.length)
571             return 1;
572         else
573             return 0;
574     }
575 
576     function indexOf(string _haystack, string _needle) internal returns (int) {
577         bytes memory h = bytes(_haystack);
578         bytes memory n = bytes(_needle);
579         if(h.length < 1 || n.length < 1 || (n.length > h.length))
580             return -1;
581         else if(h.length > (2**128 -1))
582             return -1;
583         else
584         {
585             uint subindex = 0;
586             for (uint i = 0; i < h.length; i ++)
587             {
588                 if (h[i] == n[0])
589                 {
590                     subindex = 1;
591                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
592                     {
593                         subindex++;
594                     }
595                     if(subindex == n.length)
596                         return int(i);
597                 }
598             }
599             return -1;
600         }
601     }
602 
603     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
604         bytes memory _ba = bytes(_a);
605         bytes memory _bb = bytes(_b);
606         bytes memory _bc = bytes(_c);
607         bytes memory _bd = bytes(_d);
608         bytes memory _be = bytes(_e);
609         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
610         bytes memory babcde = bytes(abcde);
611         uint k = 0;
612         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
613         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
614         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
615         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
616         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
617         return string(babcde);
618     }
619 
620     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
621         return strConcat(_a, _b, _c, _d, "");
622     }
623 
624     function strConcat(string _a, string _b, string _c) internal returns (string) {
625         return strConcat(_a, _b, _c, "", "");
626     }
627 
628     function strConcat(string _a, string _b) internal returns (string) {
629         return strConcat(_a, _b, "", "", "");
630     }
631 
632     // parseInt
633     function parseInt(string _a) internal returns (uint) {
634         return parseInt(_a, 0);
635     }
636 
637     // parseInt(parseFloat*10^_b)
638     function parseInt(string _a, uint _b) internal returns (uint) {
639         bytes memory bresult = bytes(_a);
640         uint mint = 0;
641         bool decimals = false;
642         for (uint i=0; i<bresult.length; i++){
643             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
644                 if (decimals){
645                    if (_b == 0) break;
646                     else _b--;
647                 }
648                 mint *= 10;
649                 mint += uint(bresult[i]) - 48;
650             } else if (bresult[i] == 46) decimals = true;
651         }
652         if (_b > 0) mint *= 10**_b;
653         return mint;
654     }
655 
656     function uint2str(uint i) internal returns (string){
657         if (i == 0) return "0";
658         uint j = i;
659         uint len;
660         while (j != 0){
661             len++;
662             j /= 10;
663         }
664         bytes memory bstr = new bytes(len);
665         uint k = len - 1;
666         while (i != 0){
667             bstr[k--] = byte(48 + i % 10);
668             i /= 10;
669         }
670         return string(bstr);
671     }
672     
673     function stra2cbor(string[] arr) internal returns (bytes) {
674             uint arrlen = arr.length;
675 
676             // get correct cbor output length
677             uint outputlen = 0;
678             bytes[] memory elemArray = new bytes[](arrlen);
679             for (uint i = 0; i < arrlen; i++) {
680                 elemArray[i] = (bytes(arr[i]));
681                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
682             }
683             uint ctr = 0;
684             uint cborlen = arrlen + 0x80;
685             outputlen += byte(cborlen).length;
686             bytes memory res = new bytes(outputlen);
687 
688             while (byte(cborlen).length > ctr) {
689                 res[ctr] = byte(cborlen)[ctr];
690                 ctr++;
691             }
692             for (i = 0; i < arrlen; i++) {
693                 res[ctr] = 0x5F;
694                 ctr++;
695                 for (uint x = 0; x < elemArray[i].length; x++) {
696                     // if there's a bug with larger strings, this may be the culprit
697                     if (x % 23 == 0) {
698                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
699                         elemcborlen += 0x40;
700                         uint lctr = ctr;
701                         while (byte(elemcborlen).length > ctr - lctr) {
702                             res[ctr] = byte(elemcborlen)[ctr - lctr];
703                             ctr++;
704                         }
705                     }
706                     res[ctr] = elemArray[i][x];
707                     ctr++;
708                 }
709                 res[ctr] = 0xFF;
710                 ctr++;
711             }
712             return res;
713         }
714 
715     function ba2cbor(bytes[] arr) internal returns (bytes) {
716             uint arrlen = arr.length;
717 
718             // get correct cbor output length
719             uint outputlen = 0;
720             bytes[] memory elemArray = new bytes[](arrlen);
721             for (uint i = 0; i < arrlen; i++) {
722                 elemArray[i] = (bytes(arr[i]));
723                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
724             }
725             uint ctr = 0;
726             uint cborlen = arrlen + 0x80;
727             outputlen += byte(cborlen).length;
728             bytes memory res = new bytes(outputlen);
729 
730             while (byte(cborlen).length > ctr) {
731                 res[ctr] = byte(cborlen)[ctr];
732                 ctr++;
733             }
734             for (i = 0; i < arrlen; i++) {
735                 res[ctr] = 0x5F;
736                 ctr++;
737                 for (uint x = 0; x < elemArray[i].length; x++) {
738                     // if there's a bug with larger strings, this may be the culprit
739                     if (x % 23 == 0) {
740                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
741                         elemcborlen += 0x40;
742                         uint lctr = ctr;
743                         while (byte(elemcborlen).length > ctr - lctr) {
744                             res[ctr] = byte(elemcborlen)[ctr - lctr];
745                             ctr++;
746                         }
747                     }
748                     res[ctr] = elemArray[i][x];
749                     ctr++;
750                 }
751                 res[ctr] = 0xFF;
752                 ctr++;
753             }
754             return res;
755         }
756         
757         
758     string oraclize_network_name;
759     function oraclize_setNetworkName(string _network_name) internal {
760         oraclize_network_name = _network_name;
761     }
762     
763     function oraclize_getNetworkName() internal returns (string) {
764         return oraclize_network_name;
765     }
766     
767     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
768         if ((_nbytes == 0)||(_nbytes > 32)) throw;
769         bytes memory nbytes = new bytes(1);
770         nbytes[0] = byte(_nbytes);
771         bytes memory unonce = new bytes(32);
772         bytes memory sessionKeyHash = new bytes(32);
773         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
774         sessionKeyHash_bytes32;
775         assembly {
776             mstore(unonce, 0x20)
777             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
778             mstore(sessionKeyHash, 0x20)
779             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
780         }
781         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
782         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
783         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
784         return queryId;
785     }
786     
787     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
788         oraclize_randomDS_args[queryId] = commitment;
789     }
790     
791     mapping(bytes32=>bytes32) oraclize_randomDS_args;
792     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
793 
794     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
795         bool sigok;
796         address signer;
797         
798         bytes32 sigr;
799         bytes32 sigs;
800         
801         bytes memory sigr_ = new bytes(32);
802         uint offset = 4+(uint(dersig[3]) - 0x20);
803         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
804         bytes memory sigs_ = new bytes(32);
805         offset += 32 + 2;
806         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
807 
808         assembly {
809             sigr := mload(add(sigr_, 32))
810             sigs := mload(add(sigs_, 32))
811         }
812         
813         
814         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
815         if (address(sha3(pubkey)) == signer) return true;
816         else {
817             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
818             return (address(sha3(pubkey)) == signer);
819         }
820     }
821 
822     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
823         bool sigok;
824         
825         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
826         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
827         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
828         
829         bytes memory appkey1_pubkey = new bytes(64);
830         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
831         
832         bytes memory tosign2 = new bytes(1+65+32);
833         tosign2[0] = 1; //role
834         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
835         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
836         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
837         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
838         
839         if (sigok == false) return false;
840         
841         
842         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
843         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
844         
845         bytes memory tosign3 = new bytes(1+65);
846         tosign3[0] = 0xFE;
847         copyBytes(proof, 3, 65, tosign3, 1);
848         
849         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
850         copyBytes(proof, 3+65, sig3.length, sig3, 0);
851         
852         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
853         
854         return sigok;
855     }
856     
857     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
858         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
859         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
860         
861         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
862         if (proofVerified == false) throw;
863         
864         _;
865     }
866     
867     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
868         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
869         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
870         
871         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
872         if (proofVerified == false) return 2;
873         
874         return 0;
875     }
876     
877     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
878         bool match_ = true;
879         
880         for (var i=0; i<prefix.length; i++){
881             if (content[i] != prefix[i]) match_ = false;
882         }
883         
884         return match_;
885     }
886 
887     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
888         bool checkok;
889         
890         
891         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
892         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
893         bytes memory keyhash = new bytes(32);
894         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
895         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
896         if (checkok == false) return false;
897         
898         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
899         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
900         
901         
902         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
903         checkok = matchBytes32Prefix(sha256(sig1), result);
904         if (checkok == false) return false;
905         
906         
907         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
908         // This is to verify that the computed args match with the ones specified in the query.
909         bytes memory commitmentSlice1 = new bytes(8+1+32);
910         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
911         
912         bytes memory sessionPubkey = new bytes(64);
913         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
914         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
915         
916         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
917         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
918             delete oraclize_randomDS_args[queryId];
919         } else return false;
920         
921         
922         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
923         bytes memory tosign1 = new bytes(32+8+1+32);
924         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
925         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
926         if (checkok == false) return false;
927         
928         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
929         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
930             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
931         }
932         
933         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
934     }
935 
936     
937     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
938     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
939         uint minLength = length + toOffset;
940 
941         if (to.length < minLength) {
942             // Buffer too small
943             throw; // Should be a better way?
944         }
945 
946         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
947         uint i = 32 + fromOffset;
948         uint j = 32 + toOffset;
949 
950         while (i < (32 + fromOffset + length)) {
951             assembly {
952                 let tmp := mload(add(from, i))
953                 mstore(add(to, j), tmp)
954             }
955             i += 32;
956             j += 32;
957         }
958 
959         from;
960         return to;
961     }
962     
963     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
964     // Duplicate Solidity's ecrecover, but catching the CALL return value
965     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
966         // We do our own memory management here. Solidity uses memory offset
967         // 0x40 to store the current end of memory. We write past it (as
968         // writes are memory extensions), but don't update the offset so
969         // Solidity will reuse it. The memory used here is only needed for
970         // this context.
971 
972         // FIXME: inline assembly can't access return values
973         bool ret;
974         address addr;
975 
976         assembly {
977             let size := mload(0x40)
978             mstore(size, hash)
979             mstore(add(size, 32), v)
980             mstore(add(size, 64), r)
981             mstore(add(size, 96), s)
982 
983             // NOTE: we can reuse the request memory because we deal with
984             //       the return code
985             ret := call(3000, 1, 0, size, 128, size, 32)
986             addr := mload(size)
987         }
988         
989         hash;
990         r;
991         v;
992         s;
993         return (ret, addr);
994     }
995 
996     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
997     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
998         bytes32 r;
999         bytes32 s;
1000         uint8 v;
1001 
1002         if (sig.length != 65)
1003           return (false, 0);
1004 
1005         // The signature format is a compact form of:
1006         //   {bytes32 r}{bytes32 s}{uint8 v}
1007         // Compact means, uint8 is not padded to 32 bytes.
1008         assembly {
1009             r := mload(add(sig, 32))
1010             s := mload(add(sig, 64))
1011 
1012             // Here we are loading the last 32 bytes. We exploit the fact that
1013             // 'mload' will pad with zeroes if we overread.
1014             // There is no 'mload8' to do this, but that would be nicer.
1015             v := byte(0, mload(add(sig, 96)))
1016 
1017             // Alternative solution:
1018             // 'byte' is not working due to the Solidity parser, so lets
1019             // use the second best option, 'and'
1020             // v := and(mload(add(sig, 65)), 255)
1021         }
1022 
1023         // albeit non-transactional signatures are not specified by the YP, one would expect it
1024         // to match the YP range of [27, 28]
1025         //
1026         // geth uses [0, 1] and some clients have followed. This might change, see:
1027         //  https://github.com/ethereum/go-ethereum/issues/2053
1028         if (v < 27)
1029           v += 27;
1030 
1031         if (v != 27 && v != 28)
1032             return (false, 0);
1033 
1034         return safer_ecrecover(hash, v, r, s);
1035     }
1036         
1037 }
1038 // </ORACLIZE_API>
1039 
1040 // EtherFlip v1.6
1041 
1042 contract token { function transfer(address receiver, uint amount){ receiver; amount; } }
1043 
1044 contract EtherFlip is usingOraclize {
1045     
1046     modifier ownerAction {
1047          if (msg.sender != owner) throw;
1048          _;
1049     }
1050     
1051     modifier oraclizeAction {
1052         if (msg.sender != oraclize_cbAddress()) throw;
1053         _;
1054     }
1055     
1056     //~ Events
1057     event newRandomValue(bytes, address, uint);
1058     event proofFailed(address, uint);
1059     
1060     //~ Tokens
1061     token public flipTokenReward;
1062     token public millionDollarTokenReward;
1063     token public jackpotToken;
1064     token public sponsoredJackpotToken;
1065     token public bonusToken;
1066     token public sponsoredBonusToken;
1067 
1068     //~ Base setup
1069     address public owner;
1070     
1071     //~ EtherFlip Properties
1072     uint public generatedBytes;
1073     uint public maxBet;
1074     uint public minBet;
1075     uint public oraclizeFee;
1076     uint public flipRewardAmount;
1077     uint public mdtRewardAmount;
1078     uint public jackpotAmount;
1079     uint public sponsoredJackpotAmount;
1080     uint public bonusAmount;
1081     uint public sponsoredBonusAmount;
1082     uint public callbackGas;
1083     uint public incrementFee;
1084     uint public incrementDivisor;
1085     
1086     //~ Comparables
1087     uint public baseComparable;
1088     uint public jackpotHit;
1089     uint public sponsoredJackpotMin;
1090     uint public sponsoredJackpotMax;
1091     uint public bonusMin;
1092     uint public bonusMax;
1093     uint public sponsoredBonusMin;
1094     uint public sponsoredBonusMax;
1095     uint public mdtComparable;
1096     
1097     //~ Address & Amount hashes to accurately send transactions/winnings
1098     mapping (bytes32 => address) playerAddress;
1099     mapping (bytes32 => uint) playerAmount;
1100 
1101     function EtherFlip() {
1102         owner = msg.sender;
1103         oraclize_setProof(proofType_Ledger);
1104         
1105         // Initial setup for contract
1106         //maxBet = (1000000000000000000 * 1 wei);
1107         //minBet = (100000000000000000 * 1 wei);
1108         //oraclizeFee = 6000000000000000; //API cost of Oraclize
1109         
1110         //callbackGas = 250000;
1111         //incrementFee = (194212766000000 * 1 wei);
1112         //incrementDivisor = (10000000000000000 * 1 wei);
1113         
1114         //baseComparable = 32250;
1115         //jackpotHit = 35000;
1116         //sponsoredJackpotMin = 35005;
1117         //sponsoredJackpotMax = 35006;
1118 
1119         //bonusMin = 35006;
1120         //bonusMax = 38282;
1121         //sponsoredBonusMin = 38282;
1122         //sponsoredBonusMax = 41558;
1123         //mdtComparable = 65337;
1124     }
1125     
1126     function () payable {
1127         if (msg.sender != owner) {
1128             if (msg.value > maxBet || msg.value < minBet) throw;
1129         
1130             oraclize_setProof(proofType_Ledger);
1131             uint numberOfBytes = 2;
1132             uint delay = 0;
1133             bytes32 queryId = oraclize_newRandomDSQuery(delay, numberOfBytes, callbackGas); 
1134             playerAddress[queryId] = msg.sender;
1135             playerAmount[queryId] = msg.value;
1136         }
1137     }
1138     
1139     function __callback(bytes32 _queryId, string _result, bytes _proof) oraclizeAction { 
1140         uint amount = playerAmount[_queryId];
1141         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0 || _proof.length == 0) {
1142             // the proof verification has failed
1143             proofFailed(playerAddress[_queryId], amount);
1144             playerAddress[_queryId].transfer(amount);
1145             delete playerAddress[_queryId];
1146             delete playerAmount[_queryId];
1147         } else {
1148             newRandomValue(bytes(_result), playerAddress[_queryId], amount);
1149             generatedBytes = uint(sha3(_result)) % 2**(2 *8);
1150             uint feeMultiple = amount / incrementDivisor;
1151             uint eFee = (feeMultiple - 3) * incrementFee;
1152 
1153             if (generatedBytes < baseComparable) {
1154                 playerAddress[_queryId].transfer((amount - oraclizeFee - eFee) * 2);
1155             } 
1156             
1157             if (generatedBytes >= baseComparable && flipRewardAmount > 0) {
1158                 flipTokenReward.transfer(playerAddress[_queryId], flipRewardAmount * feeMultiple);
1159             } 
1160             
1161             if (generatedBytes >= mdtComparable && mdtRewardAmount > 0) {
1162                 millionDollarTokenReward.transfer(playerAddress[_queryId], mdtRewardAmount); 
1163             }
1164         
1165             if (generatedBytes == jackpotHit && amount == maxBet) {
1166                 jackpotToken.transfer(playerAddress[_queryId], jackpotAmount);
1167             }
1168         
1169             if (generatedBytes >= sponsoredJackpotMin && generatedBytes <= sponsoredJackpotMax) {
1170                 sponsoredJackpotToken.transfer(playerAddress[_queryId], sponsoredJackpotAmount);
1171             }
1172         
1173             if (generatedBytes >= bonusMin && generatedBytes <= bonusMax) {
1174                 bonusToken.transfer(playerAddress[_queryId], bonusAmount);
1175             }
1176         
1177             if (generatedBytes >= sponsoredBonusMin && generatedBytes <= sponsoredBonusMax) {
1178                 sponsoredBonusToken.transfer(playerAddress[_queryId], sponsoredBonusAmount);
1179             }
1180         
1181             delete playerAddress[_queryId];
1182             delete playerAmount[_queryId];
1183            
1184         }
1185     }
1186     
1187     function updateMaxMinComparables(uint updatedMaxBet, uint updatedMinBet, uint updatedBaseComparable, uint updatedMDTComparable) ownerAction {
1188         maxBet = updatedMaxBet * 1 wei;
1189         minBet = updatedMinBet * 1 wei;
1190         baseComparable = updatedBaseComparable;
1191         mdtComparable = updatedMDTComparable;
1192     }  
1193     
1194     function updateOwner(address updatedOwner) ownerAction {
1195         owner = updatedOwner;
1196     }
1197     
1198     function updateFlipAndMDT(address updatedFlipToken, uint updatedFlipRewardAmount, address updatedMDTToken, uint updatedMDTRewardAmount) ownerAction {
1199         millionDollarTokenReward = token(updatedMDTToken);
1200         mdtRewardAmount = updatedMDTRewardAmount;
1201         //Swappable for initial mainnet testing & after ICO to add dummy token to indicate loss
1202         flipTokenReward = token(updatedFlipToken);
1203         flipRewardAmount = updatedFlipRewardAmount;
1204     }
1205     
1206     function refundTransfer(address outboundAddress, uint amount) ownerAction {        
1207         outboundAddress.transfer(amount);
1208     }
1209     
1210     function walletSend(address tokenAddress, uint amount, address outboundAddress) ownerAction {
1211         token chosenToken = token(tokenAddress);
1212         chosenToken.transfer(outboundAddress, amount);
1213     }
1214     
1215     function updateGameSpecifics(uint newGas, uint newOraclizeFee, uint newFee, uint newDivisor) ownerAction {
1216         callbackGas = newGas;
1217         oraclizeFee = newOraclizeFee;
1218         incrementFee = (newFee * 1 wei);
1219         incrementDivisor = (newDivisor * 1 wei);
1220     }
1221     
1222     function setJackpotToken(address newJackpotToken, uint newJackpotAmount, uint newJackpotHit, address newSponsoredJackpotToken, uint newSponsoredJackpotAmount, uint newSJackpotMin, uint newSJackpotMax) ownerAction {
1223         jackpotToken = token(newJackpotToken);
1224         jackpotAmount = newJackpotAmount;
1225         jackpotHit = newJackpotHit;
1226         
1227         sponsoredJackpotToken = token(newSponsoredJackpotToken);
1228         sponsoredJackpotAmount = newSponsoredJackpotAmount;
1229         sponsoredJackpotMin = newSJackpotMin;
1230         sponsoredJackpotMax = newSJackpotMax;
1231     }
1232     
1233     function setBonusToken(address newBonusToken, uint newBonusAmount, uint newBonusMin, uint newBonusMax, address newSponsoredBonusToken, uint newSponsoredBonusAmount, uint newSBonusMin, uint newSBonusMax) ownerAction {
1234         bonusToken = token(newBonusToken);
1235         bonusAmount = newBonusAmount;
1236         bonusMin = newBonusMin;
1237         bonusMax = newBonusMax;
1238         
1239         sponsoredBonusToken = token(newSponsoredBonusToken);
1240         sponsoredBonusAmount = newSponsoredBonusAmount;
1241         sponsoredBonusMin = newSBonusMin;
1242         sponsoredBonusMax = newSBonusMax;
1243     }
1244 }