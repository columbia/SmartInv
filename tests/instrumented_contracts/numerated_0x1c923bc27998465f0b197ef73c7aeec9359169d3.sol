1 pragma solidity ^0.4.16;
2 
3 
4 // <ORACLIZE_API>
5 /*
6 Copyright (c) 2015-2016 Oraclize SRL
7 Copyright (c) 2016 Oraclize LTD
8 
9 
10 
11 Permission is hereby granted, free of charge, to any person obtaining a copy
12 of this software and associated documentation files (the "Software"), to deal
13 in the Software without restriction, including without limitation the rights
14 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
15 copies of the Software, and to permit persons to whom the Software is
16 furnished to do so, subject to the following conditions:
17 
18 
19 
20 The above copyright notice and this permission notice shall be included in
21 all copies or substantial portions of the Software.
22 
23 
24 
25 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
26 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
27 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
28 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
29 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
30 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
31 THE SOFTWARE.
32 */
33 
34 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
35 
36 contract OraclizeI {
37     address public cbAddress;
38     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
39     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
40     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
41     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
42     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
43     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
44     function getPrice(string _datasource) returns (uint _dsprice);
45     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
46     function useCoupon(string _coupon);
47     function setProofType(byte _proofType);
48     function setConfig(bytes32 _config);
49     function setCustomGasPrice(uint _gasPrice);
50     function randomDS_getSessionPubKeyHash() returns(bytes32);
51 }
52 contract OraclizeAddrResolverI {
53     function getAddress() returns (address _addr);
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
75         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
76         oraclize = OraclizeI(OAR.getAddress());
77         _;
78     }
79     modifier coupon(string code){
80         oraclize = OraclizeI(OAR.getAddress());
81         oraclize.useCoupon(code);
82         _;
83     }
84 
85     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
86         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
87             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
88             oraclize_setNetworkName("eth_mainnet");
89             return true;
90         }
91         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
92             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
93             oraclize_setNetworkName("eth_ropsten3");
94             return true;
95         }
96         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
97             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
98             oraclize_setNetworkName("eth_kovan");
99             return true;
100         }
101         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
102             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
103             oraclize_setNetworkName("eth_rinkeby");
104             return true;
105         }
106         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
107             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
108             return true;
109         }
110         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
111             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
112             return true;
113         }
114         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
115             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
116             return true;
117         }
118         return false;
119     }
120 
121     function __callback(bytes32 myid, string result) {
122         __callback(myid, result, new bytes(0));
123     }
124     function __callback(bytes32 myid, string result, bytes proof) {
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
533     }
534 
535     function parseAddr(string _a) internal returns (address){
536         bytes memory tmp = bytes(_a);
537         uint160 iaddr = 0;
538         uint160 b1;
539         uint160 b2;
540         for (uint i=2; i<2+2*20; i+=2){
541             iaddr *= 256;
542             b1 = uint160(tmp[i]);
543             b2 = uint160(tmp[i+1]);
544             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
545             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
546             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
547             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
548             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
549             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
550             iaddr += (b1*16+b2);
551         }
552         return address(iaddr);
553     }
554 
555     function strCompare(string _a, string _b) internal returns (int) {
556         bytes memory a = bytes(_a);
557         bytes memory b = bytes(_b);
558         uint minLength = a.length;
559         if (b.length < minLength) minLength = b.length;
560         for (uint i = 0; i < minLength; i ++)
561             if (a[i] < b[i])
562                 return -1;
563             else if (a[i] > b[i])
564                 return 1;
565         if (a.length < b.length)
566             return -1;
567         else if (a.length > b.length)
568             return 1;
569         else
570             return 0;
571     }
572 
573     function indexOf(string _haystack, string _needle) internal returns (int) {
574         bytes memory h = bytes(_haystack);
575         bytes memory n = bytes(_needle);
576         if(h.length < 1 || n.length < 1 || (n.length > h.length))
577             return -1;
578         else if(h.length > (2**128 -1))
579             return -1;
580         else
581         {
582             uint subindex = 0;
583             for (uint i = 0; i < h.length; i ++)
584             {
585                 if (h[i] == n[0])
586                 {
587                     subindex = 1;
588                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
589                     {
590                         subindex++;
591                     }
592                     if(subindex == n.length)
593                         return int(i);
594                 }
595             }
596             return -1;
597         }
598     }
599 
600     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
601         bytes memory _ba = bytes(_a);
602         bytes memory _bb = bytes(_b);
603         bytes memory _bc = bytes(_c);
604         bytes memory _bd = bytes(_d);
605         bytes memory _be = bytes(_e);
606         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
607         bytes memory babcde = bytes(abcde);
608         uint k = 0;
609         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
610         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
611         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
612         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
613         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
614         return string(babcde);
615     }
616 
617     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
618         return strConcat(_a, _b, _c, _d, "");
619     }
620 
621     function strConcat(string _a, string _b, string _c) internal returns (string) {
622         return strConcat(_a, _b, _c, "", "");
623     }
624 
625     function strConcat(string _a, string _b) internal returns (string) {
626         return strConcat(_a, _b, "", "", "");
627     }
628 
629     // parseInt
630     function parseInt(string _a) internal returns (uint) {
631         return parseInt(_a, 0);
632     }
633 
634     // parseInt(parseFloat*10^_b)
635     function parseInt(string _a, uint _b) internal returns (uint) {
636         bytes memory bresult = bytes(_a);
637         uint mint = 0;
638         bool decimals = false;
639         for (uint i=0; i<bresult.length; i++){
640             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
641                 if (decimals){
642                    if (_b == 0) break;
643                     else _b--;
644                 }
645                 mint *= 10;
646                 mint += uint(bresult[i]) - 48;
647             } else if (bresult[i] == 46) decimals = true;
648         }
649         if (_b > 0) mint *= 10**_b;
650         return mint;
651     }
652 
653     function uint2str(uint i) internal returns (string){
654         if (i == 0) return "0";
655         uint j = i;
656         uint len;
657         while (j != 0){
658             len++;
659             j /= 10;
660         }
661         bytes memory bstr = new bytes(len);
662         uint k = len - 1;
663         while (i != 0){
664             bstr[k--] = byte(48 + i % 10);
665             i /= 10;
666         }
667         return string(bstr);
668     }
669     
670     function stra2cbor(string[] arr) internal returns (bytes) {
671             uint arrlen = arr.length;
672 
673             // get correct cbor output length
674             uint outputlen = 0;
675             bytes[] memory elemArray = new bytes[](arrlen);
676             for (uint i = 0; i < arrlen; i++) {
677                 elemArray[i] = (bytes(arr[i]));
678                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
679             }
680             uint ctr = 0;
681             uint cborlen = arrlen + 0x80;
682             outputlen += byte(cborlen).length;
683             bytes memory res = new bytes(outputlen);
684 
685             while (byte(cborlen).length > ctr) {
686                 res[ctr] = byte(cborlen)[ctr];
687                 ctr++;
688             }
689             for (i = 0; i < arrlen; i++) {
690                 res[ctr] = 0x5F;
691                 ctr++;
692                 for (uint x = 0; x < elemArray[i].length; x++) {
693                     // if there's a bug with larger strings, this may be the culprit
694                     if (x % 23 == 0) {
695                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
696                         elemcborlen += 0x40;
697                         uint lctr = ctr;
698                         while (byte(elemcborlen).length > ctr - lctr) {
699                             res[ctr] = byte(elemcborlen)[ctr - lctr];
700                             ctr++;
701                         }
702                     }
703                     res[ctr] = elemArray[i][x];
704                     ctr++;
705                 }
706                 res[ctr] = 0xFF;
707                 ctr++;
708             }
709             return res;
710         }
711 
712     function ba2cbor(bytes[] arr) internal returns (bytes) {
713             uint arrlen = arr.length;
714 
715             // get correct cbor output length
716             uint outputlen = 0;
717             bytes[] memory elemArray = new bytes[](arrlen);
718             for (uint i = 0; i < arrlen; i++) {
719                 elemArray[i] = (bytes(arr[i]));
720                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
721             }
722             uint ctr = 0;
723             uint cborlen = arrlen + 0x80;
724             outputlen += byte(cborlen).length;
725             bytes memory res = new bytes(outputlen);
726 
727             while (byte(cborlen).length > ctr) {
728                 res[ctr] = byte(cborlen)[ctr];
729                 ctr++;
730             }
731             for (i = 0; i < arrlen; i++) {
732                 res[ctr] = 0x5F;
733                 ctr++;
734                 for (uint x = 0; x < elemArray[i].length; x++) {
735                     // if there's a bug with larger strings, this may be the culprit
736                     if (x % 23 == 0) {
737                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
738                         elemcborlen += 0x40;
739                         uint lctr = ctr;
740                         while (byte(elemcborlen).length > ctr - lctr) {
741                             res[ctr] = byte(elemcborlen)[ctr - lctr];
742                             ctr++;
743                         }
744                     }
745                     res[ctr] = elemArray[i][x];
746                     ctr++;
747                 }
748                 res[ctr] = 0xFF;
749                 ctr++;
750             }
751             return res;
752         }
753         
754         
755     string oraclize_network_name;
756     function oraclize_setNetworkName(string _network_name) internal {
757         oraclize_network_name = _network_name;
758     }
759     
760     function oraclize_getNetworkName() internal returns (string) {
761         return oraclize_network_name;
762     }
763     
764     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
765         if ((_nbytes == 0)||(_nbytes > 32)) throw;
766         bytes memory nbytes = new bytes(1);
767         nbytes[0] = byte(_nbytes);
768         bytes memory unonce = new bytes(32);
769         bytes memory sessionKeyHash = new bytes(32);
770         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
771         assembly {
772             mstore(unonce, 0x20)
773             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
774             mstore(sessionKeyHash, 0x20)
775             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
776         }
777         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
778         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
779         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
780         return queryId;
781     }
782     
783     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
784         oraclize_randomDS_args[queryId] = commitment;
785     }
786     
787     mapping(bytes32=>bytes32) oraclize_randomDS_args;
788     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
789 
790     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
791         bool sigok;
792         address signer;
793         
794         bytes32 sigr;
795         bytes32 sigs;
796         
797         bytes memory sigr_ = new bytes(32);
798         uint offset = 4+(uint(dersig[3]) - 0x20);
799         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
800         bytes memory sigs_ = new bytes(32);
801         offset += 32 + 2;
802         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
803 
804         assembly {
805             sigr := mload(add(sigr_, 32))
806             sigs := mload(add(sigs_, 32))
807         }
808         
809         
810         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
811         if (address(sha3(pubkey)) == signer) return true;
812         else {
813             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
814             return (address(sha3(pubkey)) == signer);
815         }
816     }
817 
818     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
819         bool sigok;
820         
821         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
822         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
823         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
824         
825         bytes memory appkey1_pubkey = new bytes(64);
826         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
827         
828         bytes memory tosign2 = new bytes(1+65+32);
829         tosign2[0] = 1; //role
830         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
831         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
832         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
833         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
834         
835         if (sigok == false) return false;
836         
837         
838         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
839         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
840         
841         bytes memory tosign3 = new bytes(1+65);
842         tosign3[0] = 0xFE;
843         copyBytes(proof, 3, 65, tosign3, 1);
844         
845         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
846         copyBytes(proof, 3+65, sig3.length, sig3, 0);
847         
848         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
849         
850         return sigok;
851     }
852     
853     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
854         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
855         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
856         
857         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
858         if (proofVerified == false) throw;
859         
860         _;
861     }
862     
863     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
864         bool match_ = true;
865         
866         for (var i=0; i<prefix.length; i++){
867             if (content[i] != prefix[i]) match_ = false;
868         }
869         
870         return match_;
871     }
872 
873     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
874         bool checkok;
875         
876         
877         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
878         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
879         bytes memory keyhash = new bytes(32);
880         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
881         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
882         if (checkok == false) return false;
883         
884         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
885         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
886         
887         
888         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
889         checkok = matchBytes32Prefix(sha256(sig1), result);
890         if (checkok == false) return false;
891         
892         
893         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
894         // This is to verify that the computed args match with the ones specified in the query.
895         bytes memory commitmentSlice1 = new bytes(8+1+32);
896         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
897         
898         bytes memory sessionPubkey = new bytes(64);
899         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
900         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
901         
902         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
903         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
904             delete oraclize_randomDS_args[queryId];
905         } else return false;
906         
907         
908         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
909         bytes memory tosign1 = new bytes(32+8+1+32);
910         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
911         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
912         if (checkok == false) return false;
913         
914         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
915         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
916             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
917         }
918         
919         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
920     }
921 
922     
923     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
924     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
925         uint minLength = length + toOffset;
926 
927         if (to.length < minLength) {
928             // Buffer too small
929             throw; // Should be a better way?
930         }
931 
932         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
933         uint i = 32 + fromOffset;
934         uint j = 32 + toOffset;
935 
936         while (i < (32 + fromOffset + length)) {
937             assembly {
938                 let tmp := mload(add(from, i))
939                 mstore(add(to, j), tmp)
940             }
941             i += 32;
942             j += 32;
943         }
944 
945         return to;
946     }
947     
948     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
949     // Duplicate Solidity's ecrecover, but catching the CALL return value
950     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
951         // We do our own memory management here. Solidity uses memory offset
952         // 0x40 to store the current end of memory. We write past it (as
953         // writes are memory extensions), but don't update the offset so
954         // Solidity will reuse it. The memory used here is only needed for
955         // this context.
956 
957         // FIXME: inline assembly can't access return values
958         bool ret;
959         address addr;
960 
961         assembly {
962             let size := mload(0x40)
963             mstore(size, hash)
964             mstore(add(size, 32), v)
965             mstore(add(size, 64), r)
966             mstore(add(size, 96), s)
967 
968             // NOTE: we can reuse the request memory because we deal with
969             //       the return code
970             ret := call(3000, 1, 0, size, 128, size, 32)
971             addr := mload(size)
972         }
973   
974         return (ret, addr);
975     }
976 
977     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
978     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
979         bytes32 r;
980         bytes32 s;
981         uint8 v;
982 
983         if (sig.length != 65)
984           return (false, 0);
985 
986         // The signature format is a compact form of:
987         //   {bytes32 r}{bytes32 s}{uint8 v}
988         // Compact means, uint8 is not padded to 32 bytes.
989         assembly {
990             r := mload(add(sig, 32))
991             s := mload(add(sig, 64))
992 
993             // Here we are loading the last 32 bytes. We exploit the fact that
994             // 'mload' will pad with zeroes if we overread.
995             // There is no 'mload8' to do this, but that would be nicer.
996             v := byte(0, mload(add(sig, 96)))
997 
998             // Alternative solution:
999             // 'byte' is not working due to the Solidity parser, so lets
1000             // use the second best option, 'and'
1001             // v := and(mload(add(sig, 65)), 255)
1002         }
1003 
1004         // albeit non-transactional signatures are not specified by the YP, one would expect it
1005         // to match the YP range of [27, 28]
1006         //
1007         // geth uses [0, 1] and some clients have followed. This might change, see:
1008         //  https://github.com/ethereum/go-ethereum/issues/2053
1009         if (v < 27)
1010           v += 27;
1011 
1012         if (v != 27 && v != 28)
1013             return (false, 0);
1014 
1015         return safer_ecrecover(hash, v, r, s);
1016     }
1017         
1018 }
1019 // </ORACLIZE_API>
1020 
1021 
1022 
1023 contract SafeAddSub {
1024     function safeAdd(uint a, uint b) internal returns (uint) {
1025         require(a + b >= a);
1026         return a + b;
1027     }
1028 
1029     function safeSub(uint a, uint b) internal returns (uint) {
1030         require(b <= a);
1031         return a - b;
1032     }
1033 }
1034 
1035 
1036 contract EtherShot is usingOraclize, SafeAddSub {
1037 
1038     //Public vars
1039     bool public gamePaused;
1040 
1041     address public owner;
1042 
1043     uint constant public TicketsInGame = 100;
1044 
1045     uint constant public WeiPerTicket = 100000000000000000; //0.1 Ether
1046 
1047     uint public TicketsSoldForThisGame;
1048 
1049     uint public GameNumber;
1050 
1051     uint public Jackpot = 0;
1052 
1053     //Regular Vars
1054 
1055     uint nBytes = 1;
1056 
1057     uint oraclizeFees = 0;
1058 
1059     address[256] tickets;
1060 
1061     enum oraclizeState {Called, Returned}
1062 
1063     mapping (bytes32 => oraclizeState) queryIds;
1064 
1065     mapping (bytes32 => uint) queriesByGame;
1066 
1067     mapping (address => uint) playerPendingWithdrawals;
1068 
1069     uint constant callbackGas = 250000;
1070 
1071     //Modifiers
1072     modifier gameIsActive {
1073         require(gamePaused != true);
1074         _;
1075     }
1076 
1077     modifier ticketsAvailable {
1078         require(TicketsSoldForThisGame < TicketsInGame);
1079         _;
1080     }
1081 
1082     modifier onlyOwner {
1083         require(msg.sender == owner);
1084         _;
1085     }
1086 
1087     modifier allTicketsSold {
1088         require(TicketsSoldForThisGame == TicketsInGame);
1089         _;
1090     }
1091 
1092     modifier onlyOraclize {
1093         require(msg.sender == oraclize_cbAddress());
1094         _;
1095     }
1096 
1097     modifier isForActiveGame(bytes32 _queryId) {
1098         //Check it's expected and uncalled
1099         require(queryIds[_queryId] == oraclizeState.Called);
1100         require(queriesByGame[_queryId] == GameNumber);
1101         _;
1102     }
1103 
1104     //Events
1105     event LogTicket(uint InGameNumber, address indexed PlayerAddress, uint TicketsPurchased);
1106 
1107     event LogResultWinner(uint InGameNumber, address indexed PlayerAddress, uint WinningTicketNumber, uint JackpotWon, bytes Proof);
1108 
1109     event LogResultNoWinner(uint InGameNumber, uint WinningTicketNumber, bytes Proof);
1110 
1111     //Constructor
1112     function EtherShot(){
1113         oraclize_setProof(proofType_Ledger);
1114         owner = msg.sender;
1115         tickets[0] = owner;
1116         GameNumber = 1;
1117         TicketsSoldForThisGame = 1;
1118     }
1119 
1120     //Receive
1121     function()
1122     payable
1123     gameIsActive
1124     ticketsAvailable
1125     {
1126         require(msg.value >= WeiPerTicket);
1127 
1128         uint iterations = (msg.value / WeiPerTicket);
1129         bool firstBet = TicketsSoldForThisGame == 1;
1130         uint playerTickets = 0;
1131         for (uint x = 0; x < (TicketsInGame - 2) && TicketsSoldForThisGame < TicketsInGame && x < iterations; x++) {
1132             tickets[TicketsSoldForThisGame++] = msg.sender;
1133             playerTickets = safeAdd(playerTickets, 1);
1134         }
1135 
1136         LogTicket(GameNumber, msg.sender, playerTickets);
1137         Jackpot = safeSub(((TicketsSoldForThisGame - 1) * WeiPerTicket), oraclizeFees);
1138         if (!firstBet) {
1139             oraclizeFees = safeAdd(oraclizeFees, oraclize_getPrice("random", callbackGas));
1140             bytes32 queryId = oraclize_newRandomDSQuery(0, nBytes, callbackGas);
1141             queryIds[queryId] = oraclizeState.Called;
1142             queriesByGame[queryId] = GameNumber;
1143         }
1144         uint refundableAmount = safeSub(msg.value, (playerTickets * WeiPerTicket));
1145         if (refundableAmount > 0 && !msg.sender.send(refundableAmount)) {
1146             playerPendingWithdrawals[msg.sender] = safeAdd(playerPendingWithdrawals[msg.sender], refundableAmount);
1147         }
1148     }
1149 
1150     function __callback(bytes32 _queryId, string _result, bytes _proof)
1151     gameIsActive
1152     onlyOraclize
1153     isForActiveGame(_queryId)
1154     oraclize_randomDS_proofVerify(_queryId, _result, _proof)
1155     {
1156         queryIds[_queryId] = oraclizeState.Returned;
1157         var result = bytesToInt(bytes(_result)) % TicketsInGame;
1158 
1159         //Result starts at zero, ticket count at one
1160         if (result > (TicketsSoldForThisGame - 1)) {
1161             //No winner yet!
1162             LogResultNoWinner(GameNumber, result + 1, _proof);
1163         }
1164         else {
1165             //Winner
1166             uint payout = ((TicketsSoldForThisGame - 1) * WeiPerTicket) - oraclizeFees;
1167             TicketsSoldForThisGame = 1;
1168             GameNumber++;
1169             oraclizeFees = 0;
1170             Jackpot = 0;
1171             var winningPlayer = tickets[result];
1172             if (!winningPlayer.send(payout)) {
1173                 playerPendingWithdrawals[winningPlayer] = safeAdd(playerPendingWithdrawals[winningPlayer], payout);
1174             }
1175             LogResultWinner(GameNumber - 1, winningPlayer, result + 1, payout, _proof);
1176         }
1177     }
1178 
1179     function bytesToInt(bytes _inputBytes) constant internal returns (uint resultInt){
1180         resultInt = 0;
1181         for (uint i = 0; i < _inputBytes.length; i++) {
1182             resultInt += uint(_inputBytes[i]) * (2 ** (i * 8));
1183         }
1184         return resultInt;
1185     }
1186 
1187     function playerWithdrawPendingTransactions() public
1188     returns (bool)
1189     {
1190         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
1191         playerPendingWithdrawals[msg.sender] = 0;
1192         /* external call to untrusted contract */
1193         if (msg.sender.call.value(withdrawAmount)()) {
1194             return true;
1195         }
1196         else {
1197             playerPendingWithdrawals[msg.sender] = withdrawAmount;
1198             return false;
1199         }
1200     }
1201 
1202     /* check for pending withdrawals  */
1203     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
1204         return playerPendingWithdrawals[addressToCheck];
1205     }
1206 
1207     function retriggerDrawOnOraclizeError() public
1208     onlyOwner
1209     allTicketsSold
1210     {
1211         oraclizeFees = safeAdd(oraclizeFees, oraclize_getPrice("random", callbackGas));
1212         Jackpot = safeSub(((TicketsSoldForThisGame - 1) * WeiPerTicket), oraclizeFees);
1213         bytes32 queryId = oraclize_newRandomDSQuery(0, nBytes, callbackGas);
1214         queryIds[queryId] = oraclizeState.Called;
1215     }
1216 
1217     function deployNewContract() public
1218     onlyOwner
1219     {
1220         selfdestruct(owner);
1221     }
1222 }