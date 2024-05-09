1 pragma solidity ^0.4.25;
2 
3 /*
4 
5     Lambo Lotto Win | Dapps game for real crypto human
6     site: https://llotto.win/
7     telegram: https://t.me/Lambollotto/
8     discord: https://discord.gg/VWV5jeW/
9     
10     Rules of the game:
11     - Jackpot from 0.1 Ether;    
12     - Jackpot is currently 1.5% of the turnover for the jackpot period;    
13     - 2.5% of the bet goes to the next jackpot;   
14     - jackpot win number 888 (may vary during games);      
15     - in case of a jackpot from 0 to 13, the player wins a small jackpot which is equal to 0.5% of the turnover during the jackpot period;
16     - when the jackpot is between 500 and 513, the player wins the small jackpot which is equal to 0.3% of the turnover during the jackpot period;
17     - цinning is the amount of interest received from the amount of random / 100 + random / 10 multiplied by the bet - the random range is from 1 to 1500;
18     - administration commission of 2.5% + 2.5% for the development and maintenance of the project;
19 
20 */
21 
22 // <ORACLIZE_API>
23 /*
24 Copyright (c) 2015-2016 Oraclize SRL
25 Copyright (c) 2016 Oraclize LTD
26 
27 
28 
29 Permission is hereby granted, free of charge, to any person obtaining a copy
30 of this software and associated documentation files (the "Software"), to deal
31 in the Software without restriction, including without limitation the rights
32 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
33 copies of the Software, and to permit persons to whom the Software is
34 furnished to do so, subject to the following conditions:
35 
36 
37 
38 The above copyright notice and this permission notice shall be included in
39 all copies or substantial portions of the Software.
40 
41 
42 
43 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
44 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
45 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
46 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
47 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
48 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
49 THE SOFTWARE.
50 */
51 
52 contract OraclizeI {
53     address public cbAddress;
54     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
55     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
56     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
57     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
58     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
59     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
60     function getPrice(string _datasource) returns (uint _dsprice);
61     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
62     function useCoupon(string _coupon);
63     function setProofType(byte _proofType);
64     function setConfig(bytes32 _config);
65     function setCustomGasPrice(uint _gasPrice);
66     function randomDS_getSessionPubKeyHash() returns(bytes32);
67 }
68 contract OraclizeAddrResolverI {
69     function getAddress() returns (address _addr);
70 }
71 contract usingOraclize {
72     uint constant day = 60*60*24;
73     uint constant week = 60*60*24*7;
74     uint constant month = 60*60*24*30;
75     byte constant proofType_NONE = 0x00;
76     byte constant proofType_TLSNotary = 0x10;
77     byte constant proofType_Android = 0x20;
78     byte constant proofType_Ledger = 0x30;
79     byte constant proofType_Native = 0xF0;
80     byte constant proofStorage_IPFS = 0x01;
81     uint8 constant networkID_auto = 0;
82     uint8 constant networkID_mainnet = 1;
83     uint8 constant networkID_testnet = 2;
84     uint8 constant networkID_morden = 2;
85     uint8 constant networkID_consensys = 161;
86 
87     OraclizeAddrResolverI OAR;
88 
89     OraclizeI oraclize;
90     modifier oraclizeAPI {
91         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
92             oraclize_setNetwork(networkID_auto);
93 
94         if(address(oraclize) != OAR.getAddress())
95             oraclize = OraclizeI(OAR.getAddress());
96 
97         _;
98     }
99     modifier coupon(string code){
100         oraclize = OraclizeI(OAR.getAddress());
101         oraclize.useCoupon(code);
102         _;
103     }
104 
105     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
106         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
107             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
108             oraclize_setNetworkName("eth_mainnet");
109             return true;
110         }
111         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
112             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
113             oraclize_setNetworkName("eth_ropsten3");
114             return true;
115         }
116         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
117             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
118             oraclize_setNetworkName("eth_kovan");
119             return true;
120         }
121         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
122             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
123             oraclize_setNetworkName("eth_rinkeby");
124             return true;
125         }
126         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
127             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
128             return true;
129         }
130         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
131             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
132             return true;
133         }
134         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
135             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
136             return true;
137         }
138         return false;
139     }
140 
141     function __callback(bytes32 myid, string result) {
142         __callback(myid, result, new bytes(0));
143     }
144     function __callback(bytes32 myid, string result, bytes proof) {
145     }
146 
147     function oraclize_useCoupon(string code) oraclizeAPI internal {
148         oraclize.useCoupon(code);
149     }
150 
151     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
152         return oraclize.getPrice(datasource);
153     }
154 
155     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
156         return oraclize.getPrice(datasource, gaslimit);
157     }
158 
159     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
160         uint price = oraclize.getPrice(datasource);
161         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
162         return oraclize.query.value(price)(0, datasource, arg);
163     }
164     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
165         uint price = oraclize.getPrice(datasource);
166         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
167         return oraclize.query.value(price)(timestamp, datasource, arg);
168     }
169     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
170         uint price = oraclize.getPrice(datasource, gaslimit);
171         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
172         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
173     }
174     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
175         uint price = oraclize.getPrice(datasource, gaslimit);
176         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
177         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
178     }
179     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
180         uint price = oraclize.getPrice(datasource);
181         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
182         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
183     }
184     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
185         uint price = oraclize.getPrice(datasource);
186         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
187         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
188     }
189     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
190         uint price = oraclize.getPrice(datasource, gaslimit);
191         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
192         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
193     }
194     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
195         uint price = oraclize.getPrice(datasource, gaslimit);
196         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
197         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
198     }
199     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
200         uint price = oraclize.getPrice(datasource);
201         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
202         bytes memory args = stra2cbor(argN);
203         return oraclize.queryN.value(price)(0, datasource, args);
204     }
205     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
206         uint price = oraclize.getPrice(datasource);
207         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
208         bytes memory args = stra2cbor(argN);
209         return oraclize.queryN.value(price)(timestamp, datasource, args);
210     }
211     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
212         uint price = oraclize.getPrice(datasource, gaslimit);
213         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
214         bytes memory args = stra2cbor(argN);
215         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
216     }
217     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
218         uint price = oraclize.getPrice(datasource, gaslimit);
219         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
220         bytes memory args = stra2cbor(argN);
221         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
222     }
223     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
224         string[] memory dynargs = new string[](1);
225         dynargs[0] = args[0];
226         return oraclize_query(datasource, dynargs);
227     }
228     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
229         string[] memory dynargs = new string[](1);
230         dynargs[0] = args[0];
231         return oraclize_query(timestamp, datasource, dynargs);
232     }
233     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
234         string[] memory dynargs = new string[](1);
235         dynargs[0] = args[0];
236         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
237     }
238     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
239         string[] memory dynargs = new string[](1);
240         dynargs[0] = args[0];
241         return oraclize_query(datasource, dynargs, gaslimit);
242     }
243 
244     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
245         string[] memory dynargs = new string[](2);
246         dynargs[0] = args[0];
247         dynargs[1] = args[1];
248         return oraclize_query(datasource, dynargs);
249     }
250     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
251         string[] memory dynargs = new string[](2);
252         dynargs[0] = args[0];
253         dynargs[1] = args[1];
254         return oraclize_query(timestamp, datasource, dynargs);
255     }
256     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
257         string[] memory dynargs = new string[](2);
258         dynargs[0] = args[0];
259         dynargs[1] = args[1];
260         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
261     }
262     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
263         string[] memory dynargs = new string[](2);
264         dynargs[0] = args[0];
265         dynargs[1] = args[1];
266         return oraclize_query(datasource, dynargs, gaslimit);
267     }
268     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
269         string[] memory dynargs = new string[](3);
270         dynargs[0] = args[0];
271         dynargs[1] = args[1];
272         dynargs[2] = args[2];
273         return oraclize_query(datasource, dynargs);
274     }
275     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
276         string[] memory dynargs = new string[](3);
277         dynargs[0] = args[0];
278         dynargs[1] = args[1];
279         dynargs[2] = args[2];
280         return oraclize_query(timestamp, datasource, dynargs);
281     }
282     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
283         string[] memory dynargs = new string[](3);
284         dynargs[0] = args[0];
285         dynargs[1] = args[1];
286         dynargs[2] = args[2];
287         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
288     }
289     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
290         string[] memory dynargs = new string[](3);
291         dynargs[0] = args[0];
292         dynargs[1] = args[1];
293         dynargs[2] = args[2];
294         return oraclize_query(datasource, dynargs, gaslimit);
295     }
296 
297     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
298         string[] memory dynargs = new string[](4);
299         dynargs[0] = args[0];
300         dynargs[1] = args[1];
301         dynargs[2] = args[2];
302         dynargs[3] = args[3];
303         return oraclize_query(datasource, dynargs);
304     }
305     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
306         string[] memory dynargs = new string[](4);
307         dynargs[0] = args[0];
308         dynargs[1] = args[1];
309         dynargs[2] = args[2];
310         dynargs[3] = args[3];
311         return oraclize_query(timestamp, datasource, dynargs);
312     }
313     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
314         string[] memory dynargs = new string[](4);
315         dynargs[0] = args[0];
316         dynargs[1] = args[1];
317         dynargs[2] = args[2];
318         dynargs[3] = args[3];
319         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
320     }
321     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
322         string[] memory dynargs = new string[](4);
323         dynargs[0] = args[0];
324         dynargs[1] = args[1];
325         dynargs[2] = args[2];
326         dynargs[3] = args[3];
327         return oraclize_query(datasource, dynargs, gaslimit);
328     }
329     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
330         string[] memory dynargs = new string[](5);
331         dynargs[0] = args[0];
332         dynargs[1] = args[1];
333         dynargs[2] = args[2];
334         dynargs[3] = args[3];
335         dynargs[4] = args[4];
336         return oraclize_query(datasource, dynargs);
337     }
338     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
339         string[] memory dynargs = new string[](5);
340         dynargs[0] = args[0];
341         dynargs[1] = args[1];
342         dynargs[2] = args[2];
343         dynargs[3] = args[3];
344         dynargs[4] = args[4];
345         return oraclize_query(timestamp, datasource, dynargs);
346     }
347     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
348         string[] memory dynargs = new string[](5);
349         dynargs[0] = args[0];
350         dynargs[1] = args[1];
351         dynargs[2] = args[2];
352         dynargs[3] = args[3];
353         dynargs[4] = args[4];
354         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
355     }
356     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
357         string[] memory dynargs = new string[](5);
358         dynargs[0] = args[0];
359         dynargs[1] = args[1];
360         dynargs[2] = args[2];
361         dynargs[3] = args[3];
362         dynargs[4] = args[4];
363         return oraclize_query(datasource, dynargs, gaslimit);
364     }
365     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
366         uint price = oraclize.getPrice(datasource);
367         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
368         bytes memory args = ba2cbor(argN);
369         return oraclize.queryN.value(price)(0, datasource, args);
370     }
371     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
372         uint price = oraclize.getPrice(datasource);
373         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
374         bytes memory args = ba2cbor(argN);
375         return oraclize.queryN.value(price)(timestamp, datasource, args);
376     }
377     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
378         uint price = oraclize.getPrice(datasource, gaslimit);
379         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
380         bytes memory args = ba2cbor(argN);
381         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
382     }
383     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
384         uint price = oraclize.getPrice(datasource, gaslimit);
385         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
386         bytes memory args = ba2cbor(argN);
387         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
388     }
389     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
390         bytes[] memory dynargs = new bytes[](1);
391         dynargs[0] = args[0];
392         return oraclize_query(datasource, dynargs);
393     }
394     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
395         bytes[] memory dynargs = new bytes[](1);
396         dynargs[0] = args[0];
397         return oraclize_query(timestamp, datasource, dynargs);
398     }
399     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
400         bytes[] memory dynargs = new bytes[](1);
401         dynargs[0] = args[0];
402         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
403     }
404     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
405         bytes[] memory dynargs = new bytes[](1);
406         dynargs[0] = args[0];
407         return oraclize_query(datasource, dynargs, gaslimit);
408     }
409 
410     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
411         bytes[] memory dynargs = new bytes[](2);
412         dynargs[0] = args[0];
413         dynargs[1] = args[1];
414         return oraclize_query(datasource, dynargs);
415     }
416     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
417         bytes[] memory dynargs = new bytes[](2);
418         dynargs[0] = args[0];
419         dynargs[1] = args[1];
420         return oraclize_query(timestamp, datasource, dynargs);
421     }
422     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
423         bytes[] memory dynargs = new bytes[](2);
424         dynargs[0] = args[0];
425         dynargs[1] = args[1];
426         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
427     }
428     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
429         bytes[] memory dynargs = new bytes[](2);
430         dynargs[0] = args[0];
431         dynargs[1] = args[1];
432         return oraclize_query(datasource, dynargs, gaslimit);
433     }
434     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
435         bytes[] memory dynargs = new bytes[](3);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         dynargs[2] = args[2];
439         return oraclize_query(datasource, dynargs);
440     }
441     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
442         bytes[] memory dynargs = new bytes[](3);
443         dynargs[0] = args[0];
444         dynargs[1] = args[1];
445         dynargs[2] = args[2];
446         return oraclize_query(timestamp, datasource, dynargs);
447     }
448     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
449         bytes[] memory dynargs = new bytes[](3);
450         dynargs[0] = args[0];
451         dynargs[1] = args[1];
452         dynargs[2] = args[2];
453         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
454     }
455     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
456         bytes[] memory dynargs = new bytes[](3);
457         dynargs[0] = args[0];
458         dynargs[1] = args[1];
459         dynargs[2] = args[2];
460         return oraclize_query(datasource, dynargs, gaslimit);
461     }
462 
463     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
464         bytes[] memory dynargs = new bytes[](4);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         dynargs[2] = args[2];
468         dynargs[3] = args[3];
469         return oraclize_query(datasource, dynargs);
470     }
471     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
472         bytes[] memory dynargs = new bytes[](4);
473         dynargs[0] = args[0];
474         dynargs[1] = args[1];
475         dynargs[2] = args[2];
476         dynargs[3] = args[3];
477         return oraclize_query(timestamp, datasource, dynargs);
478     }
479     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
480         bytes[] memory dynargs = new bytes[](4);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         dynargs[2] = args[2];
484         dynargs[3] = args[3];
485         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
486     }
487     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
488         bytes[] memory dynargs = new bytes[](4);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         dynargs[2] = args[2];
492         dynargs[3] = args[3];
493         return oraclize_query(datasource, dynargs, gaslimit);
494     }
495     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
496         bytes[] memory dynargs = new bytes[](5);
497         dynargs[0] = args[0];
498         dynargs[1] = args[1];
499         dynargs[2] = args[2];
500         dynargs[3] = args[3];
501         dynargs[4] = args[4];
502         return oraclize_query(datasource, dynargs);
503     }
504     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
505         bytes[] memory dynargs = new bytes[](5);
506         dynargs[0] = args[0];
507         dynargs[1] = args[1];
508         dynargs[2] = args[2];
509         dynargs[3] = args[3];
510         dynargs[4] = args[4];
511         return oraclize_query(timestamp, datasource, dynargs);
512     }
513     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
514         bytes[] memory dynargs = new bytes[](5);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         dynargs[3] = args[3];
519         dynargs[4] = args[4];
520         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
521     }
522     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
523         bytes[] memory dynargs = new bytes[](5);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         dynargs[3] = args[3];
528         dynargs[4] = args[4];
529         return oraclize_query(datasource, dynargs, gaslimit);
530     }
531 
532     function oraclize_cbAddress() oraclizeAPI internal returns (address){
533         return oraclize.cbAddress();
534     }
535     function oraclize_setProof(byte proofP) oraclizeAPI internal {
536         return oraclize.setProofType(proofP);
537     }
538     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
539         return oraclize.setCustomGasPrice(gasPrice);
540     }
541     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
542         return oraclize.setConfig(config);
543     }
544 
545     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
546         return oraclize.randomDS_getSessionPubKeyHash();
547     }
548 
549     function getCodeSize(address _addr) constant internal returns(uint _size) {
550         assembly {
551             _size := extcodesize(_addr)
552         }
553     }
554 
555     function parseAddr(string _a) internal returns (address){
556         bytes memory tmp = bytes(_a);
557         uint160 iaddr = 0;
558         uint160 b1;
559         uint160 b2;
560         for (uint i=2; i<2+2*20; i+=2){
561             iaddr *= 256;
562             b1 = uint160(tmp[i]);
563             b2 = uint160(tmp[i+1]);
564             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
565             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
566             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
567             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
568             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
569             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
570             iaddr += (b1*16+b2);
571         }
572         return address(iaddr);
573     }
574 
575     function strCompare(string _a, string _b) internal returns (int) {
576         bytes memory a = bytes(_a);
577         bytes memory b = bytes(_b);
578         uint minLength = a.length;
579         if (b.length < minLength) minLength = b.length;
580         for (uint i = 0; i < minLength; i ++)
581             if (a[i] < b[i])
582                 return -1;
583             else if (a[i] > b[i])
584                 return 1;
585         if (a.length < b.length)
586             return -1;
587         else if (a.length > b.length)
588             return 1;
589         else
590             return 0;
591     }
592 
593     function indexOf(string _haystack, string _needle) internal returns (int) {
594         bytes memory h = bytes(_haystack);
595         bytes memory n = bytes(_needle);
596         if(h.length < 1 || n.length < 1 || (n.length > h.length))
597             return -1;
598         else if(h.length > (2**128 -1))
599             return -1;
600         else
601         {
602             uint subindex = 0;
603             for (uint i = 0; i < h.length; i ++)
604             {
605                 if (h[i] == n[0])
606                 {
607                     subindex = 1;
608                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
609                     {
610                         subindex++;
611                     }
612                     if(subindex == n.length)
613                         return int(i);
614                 }
615             }
616             return -1;
617         }
618     }
619 
620     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
621         bytes memory _ba = bytes(_a);
622         bytes memory _bb = bytes(_b);
623         bytes memory _bc = bytes(_c);
624         bytes memory _bd = bytes(_d);
625         bytes memory _be = bytes(_e);
626         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
627         bytes memory babcde = bytes(abcde);
628         uint k = 0;
629         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
630         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
631         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
632         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
633         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
634         return string(babcde);
635     }
636 
637     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
638         return strConcat(_a, _b, _c, _d, "");
639     }
640 
641     function strConcat(string _a, string _b, string _c) internal returns (string) {
642         return strConcat(_a, _b, _c, "", "");
643     }
644 
645     function strConcat(string _a, string _b) internal returns (string) {
646         return strConcat(_a, _b, "", "", "");
647     }
648 
649     // parseInt
650     function parseInt(string _a) internal returns (uint) {
651         return parseInt(_a, 0);
652     }
653 
654     // parseInt(parseFloat*10^_b)
655     function parseInt(string _a, uint _b) internal returns (uint) {
656         bytes memory bresult = bytes(_a);
657         uint mint = 0;
658         bool decimals = false;
659         for (uint i=0; i<bresult.length; i++){
660             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
661                 if (decimals){
662                    if (_b == 0) break;
663                     else _b--;
664                 }
665                 mint *= 10;
666                 mint += uint(bresult[i]) - 48;
667             } else if (bresult[i] == 46) decimals = true;
668         }
669         if (_b > 0) mint *= 10**_b;
670         return mint;
671     }
672 
673     function uint2str(uint i) internal returns (string){
674         if (i == 0) return "0";
675         uint j = i;
676         uint len;
677         while (j != 0){
678             len++;
679             j /= 10;
680         }
681         bytes memory bstr = new bytes(len);
682         uint k = len - 1;
683         while (i != 0){
684             bstr[k--] = byte(48 + i % 10);
685             i /= 10;
686         }
687         return string(bstr);
688     }
689 
690     function stra2cbor(string[] arr) internal returns (bytes) {
691             uint arrlen = arr.length;
692 
693             // get correct cbor output length
694             uint outputlen = 0;
695             bytes[] memory elemArray = new bytes[](arrlen);
696             for (uint i = 0; i < arrlen; i++) {
697                 elemArray[i] = (bytes(arr[i]));
698                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
699             }
700             uint ctr = 0;
701             uint cborlen = arrlen + 0x80;
702             outputlen += byte(cborlen).length;
703             bytes memory res = new bytes(outputlen);
704 
705             while (byte(cborlen).length > ctr) {
706                 res[ctr] = byte(cborlen)[ctr];
707                 ctr++;
708             }
709             for (i = 0; i < arrlen; i++) {
710                 res[ctr] = 0x5F;
711                 ctr++;
712                 for (uint x = 0; x < elemArray[i].length; x++) {
713                     // if there's a bug with larger strings, this may be the culprit
714                     if (x % 23 == 0) {
715                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
716                         elemcborlen += 0x40;
717                         uint lctr = ctr;
718                         while (byte(elemcborlen).length > ctr - lctr) {
719                             res[ctr] = byte(elemcborlen)[ctr - lctr];
720                             ctr++;
721                         }
722                     }
723                     res[ctr] = elemArray[i][x];
724                     ctr++;
725                 }
726                 res[ctr] = 0xFF;
727                 ctr++;
728             }
729             return res;
730         }
731 
732     function ba2cbor(bytes[] arr) internal returns (bytes) {
733             uint arrlen = arr.length;
734 
735             // get correct cbor output length
736             uint outputlen = 0;
737             bytes[] memory elemArray = new bytes[](arrlen);
738             for (uint i = 0; i < arrlen; i++) {
739                 elemArray[i] = (bytes(arr[i]));
740                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
741             }
742             uint ctr = 0;
743             uint cborlen = arrlen + 0x80;
744             outputlen += byte(cborlen).length;
745             bytes memory res = new bytes(outputlen);
746 
747             while (byte(cborlen).length > ctr) {
748                 res[ctr] = byte(cborlen)[ctr];
749                 ctr++;
750             }
751             for (i = 0; i < arrlen; i++) {
752                 res[ctr] = 0x5F;
753                 ctr++;
754                 for (uint x = 0; x < elemArray[i].length; x++) {
755                     // if there's a bug with larger strings, this may be the culprit
756                     if (x % 23 == 0) {
757                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
758                         elemcborlen += 0x40;
759                         uint lctr = ctr;
760                         while (byte(elemcborlen).length > ctr - lctr) {
761                             res[ctr] = byte(elemcborlen)[ctr - lctr];
762                             ctr++;
763                         }
764                     }
765                     res[ctr] = elemArray[i][x];
766                     ctr++;
767                 }
768                 res[ctr] = 0xFF;
769                 ctr++;
770             }
771             return res;
772         }
773 
774 
775     string oraclize_network_name;
776     function oraclize_setNetworkName(string _network_name) internal {
777         oraclize_network_name = _network_name;
778     }
779 
780     function oraclize_getNetworkName() internal returns (string) {
781         return oraclize_network_name;
782     }
783 
784     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
785         if ((_nbytes == 0)||(_nbytes > 32)) throw;
786         bytes memory nbytes = new bytes(1);
787         nbytes[0] = byte(_nbytes);
788         bytes memory unonce = new bytes(32);
789         bytes memory sessionKeyHash = new bytes(32);
790         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
791         assembly {
792             mstore(unonce, 0x20)
793             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
794             mstore(sessionKeyHash, 0x20)
795             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
796         }
797         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
798         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
799         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
800         return queryId;
801     }
802 
803     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
804         oraclize_randomDS_args[queryId] = commitment;
805     }
806 
807     mapping(bytes32=>bytes32) oraclize_randomDS_args;
808     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
809 
810     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
811         bool sigok;
812         address signer;
813 
814         bytes32 sigr;
815         bytes32 sigs;
816 
817         bytes memory sigr_ = new bytes(32);
818         uint offset = 4+(uint(dersig[3]) - 0x20);
819         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
820         bytes memory sigs_ = new bytes(32);
821         offset += 32 + 2;
822         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
823 
824         assembly {
825             sigr := mload(add(sigr_, 32))
826             sigs := mload(add(sigs_, 32))
827         }
828 
829 
830         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
831         if (address(sha3(pubkey)) == signer) return true;
832         else {
833             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
834             return (address(sha3(pubkey)) == signer);
835         }
836     }
837 
838     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
839         bool sigok;
840 
841         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
842         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
843         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
844 
845         bytes memory appkey1_pubkey = new bytes(64);
846         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
847 
848         bytes memory tosign2 = new bytes(1+65+32);
849         tosign2[0] = 1; //role
850         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
851         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
852         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
853         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
854 
855         if (sigok == false) return false;
856 
857 
858         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
859         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
860 
861         bytes memory tosign3 = new bytes(1+65);
862         tosign3[0] = 0xFE;
863         copyBytes(proof, 3, 65, tosign3, 1);
864 
865         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
866         copyBytes(proof, 3+65, sig3.length, sig3, 0);
867 
868         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
869 
870         return sigok;
871     }
872 
873     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
874         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
875         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
876 
877         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
878         if (proofVerified == false) throw;
879 
880         _;
881     }
882 
883     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
884         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
885         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
886 
887         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
888         if (proofVerified == false) return 2;
889 
890         return 0;
891     }
892 
893     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
894         bool match_ = true;
895 
896         for (var i=0; i<prefix.length; i++){
897             if (content[i] != prefix[i]) match_ = false;
898         }
899 
900         return match_;
901     }
902 
903     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
904         bool checkok;
905 
906 
907         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
908         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
909         bytes memory keyhash = new bytes(32);
910         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
911         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
912         if (checkok == false) return false;
913 
914         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
915         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
916 
917 
918         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
919         checkok = matchBytes32Prefix(sha256(sig1), result);
920         if (checkok == false) return false;
921 
922 
923         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
924         // This is to verify that the computed args match with the ones specified in the query.
925         bytes memory commitmentSlice1 = new bytes(8+1+32);
926         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
927 
928         bytes memory sessionPubkey = new bytes(64);
929         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
930         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
931 
932         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
933         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
934             delete oraclize_randomDS_args[queryId];
935         } else return false;
936 
937 
938         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
939         bytes memory tosign1 = new bytes(32+8+1+32);
940         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
941         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
942         if (checkok == false) return false;
943 
944         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
945         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
946             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
947         }
948 
949         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
950     }
951 
952 
953     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
954     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
955         uint minLength = length + toOffset;
956 
957         if (to.length < minLength) {
958             // Buffer too small
959             throw; // Should be a better way?
960         }
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
1051 /*
1052  * @title String & slice utility library for Solidity contracts.
1053  * @author Nick Johnson <arachnid@notdot.net>
1054  *
1055  * @dev Functionality in this library is largely implemented using an
1056  *      abstraction called a 'slice'. A slice represents a part of a string -
1057  *      anything from the entire string to a single character, or even no
1058  *      characters at all (a 0-length slice). Since a slice only has to specify
1059  *      an offset and a length, copying and manipulating slices is a lot less
1060  *      expensive than copying and manipulating the strings they reference.
1061  *
1062  *      To further reduce gas costs, most functions on slice that need to return
1063  *      a slice modify the original one instead of allocating a new one; for
1064  *      instance, `s.split(".")` will return the text up to the first '.',
1065  *      modifying s to only contain the remainder of the string after the '.'.
1066  *      In situations where you do not want to modify the original slice, you
1067  *      can make a copy first with `.copy()`, for example:
1068  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1069  *      Solidity has no memory management, it will result in allocating many
1070  *      short-lived slices that are later discarded.
1071  *
1072  *      Functions that return two slices come in two versions: a non-allocating
1073  *      version that takes the second slice as an argument, modifying it in
1074  *      place, and an allocating version that allocates and returns the second
1075  *      slice; see `nextRune` for example.
1076  *
1077  *      Functions that have to copy string data will return strings rather than
1078  *      slices; these can be cast back to slices for further processing if
1079  *      required.
1080  *
1081  *      For convenience, some functions are provided with non-modifying
1082  *      variants that create a new slice and return both; for instance,
1083  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1084  *      corresponding to the left and right parts of the string.
1085  */
1086 library strings {
1087     struct slice {
1088         uint _len;
1089         uint _ptr;
1090     }
1091 
1092     function memcpy(uint dest, uint src, uint len) private {
1093         // Copy word-length chunks while possible
1094         for(; len >= 32; len -= 32) {
1095             assembly {
1096                 mstore(dest, mload(src))
1097             }
1098             dest += 32;
1099             src += 32;
1100         }
1101 
1102         // Copy remaining bytes
1103         uint mask = 256 ** (32 - len) - 1;
1104         assembly {
1105             let srcpart := and(mload(src), not(mask))
1106             let destpart := and(mload(dest), mask)
1107             mstore(dest, or(destpart, srcpart))
1108         }
1109     }
1110 
1111     /*
1112      * @dev Returns a slice containing the entire string.
1113      * @param self The string to make a slice from.
1114      * @return A newly allocated slice containing the entire string.
1115      */
1116     function toSlice(string self) internal returns (slice) {
1117         uint ptr;
1118         assembly {
1119             ptr := add(self, 0x20)
1120         }
1121         return slice(bytes(self).length, ptr);
1122     }
1123 
1124     /*
1125      * @dev Returns the length of a null-terminated bytes32 string.
1126      * @param self The value to find the length of.
1127      * @return The length of the string, from 0 to 32.
1128      */
1129     function len(bytes32 self) internal returns (uint) {
1130         uint ret;
1131         if (self == 0)
1132             return 0;
1133         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1134             ret += 16;
1135             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1136         }
1137         if (self & 0xffffffffffffffff == 0) {
1138             ret += 8;
1139             self = bytes32(uint(self) / 0x10000000000000000);
1140         }
1141         if (self & 0xffffffff == 0) {
1142             ret += 4;
1143             self = bytes32(uint(self) / 0x100000000);
1144         }
1145         if (self & 0xffff == 0) {
1146             ret += 2;
1147             self = bytes32(uint(self) / 0x10000);
1148         }
1149         if (self & 0xff == 0) {
1150             ret += 1;
1151         }
1152         return 32 - ret;
1153     }
1154 
1155     /*
1156      * @dev Returns a slice containing the entire bytes32, interpreted as a
1157      *      null-termintaed utf-8 string.
1158      * @param self The bytes32 value to convert to a slice.
1159      * @return A new slice containing the value of the input argument up to the
1160      *         first null.
1161      */
1162     function toSliceB32(bytes32 self) internal returns (slice ret) {
1163         // Allocate space for `self` in memory, copy it there, and point ret at it
1164         assembly {
1165             let ptr := mload(0x40)
1166             mstore(0x40, add(ptr, 0x20))
1167             mstore(ptr, self)
1168             mstore(add(ret, 0x20), ptr)
1169         }
1170         ret._len = len(self);
1171     }
1172 
1173     /*
1174      * @dev Returns a new slice containing the same data as the current slice.
1175      * @param self The slice to copy.
1176      * @return A new slice containing the same data as `self`.
1177      */
1178     function copy(slice self) internal returns (slice) {
1179         return slice(self._len, self._ptr);
1180     }
1181 
1182     /*
1183      * @dev Copies a slice to a new string.
1184      * @param self The slice to copy.
1185      * @return A newly allocated string containing the slice's text.
1186      */
1187     function toString(slice self) internal returns (string) {
1188         var ret = new string(self._len);
1189         uint retptr;
1190         assembly { retptr := add(ret, 32) }
1191 
1192         memcpy(retptr, self._ptr, self._len);
1193         return ret;
1194     }
1195 
1196     /*
1197      * @dev Returns the length in runes of the slice. Note that this operation
1198      *      takes time proportional to the length of the slice; avoid using it
1199      *      in loops, and call `slice.empty()` if you only need to know whether
1200      *      the slice is empty or not.
1201      * @param self The slice to operate on.
1202      * @return The length of the slice in runes.
1203      */
1204     function len(slice self) internal returns (uint) {
1205         // Starting at ptr-31 means the LSB will be the byte we care about
1206         var ptr = self._ptr - 31;
1207         var end = ptr + self._len;
1208         for (uint len = 0; ptr < end; len++) {
1209             uint8 b;
1210             assembly { b := and(mload(ptr), 0xFF) }
1211             if (b < 0x80) {
1212                 ptr += 1;
1213             } else if(b < 0xE0) {
1214                 ptr += 2;
1215             } else if(b < 0xF0) {
1216                 ptr += 3;
1217             } else if(b < 0xF8) {
1218                 ptr += 4;
1219             } else if(b < 0xFC) {
1220                 ptr += 5;
1221             } else {
1222                 ptr += 6;
1223             }
1224         }
1225         return len;
1226     }
1227 
1228     /*
1229      * @dev Returns true if the slice is empty (has a length of 0).
1230      * @param self The slice to operate on.
1231      * @return True if the slice is empty, False otherwise.
1232      */
1233     function empty(slice self) internal returns (bool) {
1234         return self._len == 0;
1235     }
1236 
1237     /*
1238      * @dev Returns a positive number if `other` comes lexicographically after
1239      *      `self`, a negative number if it comes before, or zero if the
1240      *      contents of the two slices are equal. Comparison is done per-rune,
1241      *      on unicode codepoints.
1242      * @param self The first slice to compare.
1243      * @param other The second slice to compare.
1244      * @return The result of the comparison.
1245      */
1246     function compare(slice self, slice other) internal returns (int) {
1247         uint shortest = self._len;
1248         if (other._len < self._len)
1249             shortest = other._len;
1250 
1251         var selfptr = self._ptr;
1252         var otherptr = other._ptr;
1253         for (uint idx = 0; idx < shortest; idx += 32) {
1254             uint a;
1255             uint b;
1256             assembly {
1257                 a := mload(selfptr)
1258                 b := mload(otherptr)
1259             }
1260             if (a != b) {
1261                 // Mask out irrelevant bytes and check again
1262                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1263                 var diff = (a & mask) - (b & mask);
1264                 if (diff != 0)
1265                     return int(diff);
1266             }
1267             selfptr += 32;
1268             otherptr += 32;
1269         }
1270         return int(self._len) - int(other._len);
1271     }
1272 
1273     /*
1274      * @dev Returns true if the two slices contain the same text.
1275      * @param self The first slice to compare.
1276      * @param self The second slice to compare.
1277      * @return True if the slices are equal, false otherwise.
1278      */
1279     function equals(slice self, slice other) internal returns (bool) {
1280         return compare(self, other) == 0;
1281     }
1282 
1283     /*
1284      * @dev Extracts the first rune in the slice into `rune`, advancing the
1285      *      slice to point to the next rune and returning `self`.
1286      * @param self The slice to operate on.
1287      * @param rune The slice that will contain the first rune.
1288      * @return `rune`.
1289      */
1290     function nextRune(slice self, slice rune) internal returns (slice) {
1291         rune._ptr = self._ptr;
1292 
1293         if (self._len == 0) {
1294             rune._len = 0;
1295             return rune;
1296         }
1297 
1298         uint len;
1299         uint b;
1300         // Load the first byte of the rune into the LSBs of b
1301         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1302         if (b < 0x80) {
1303             len = 1;
1304         } else if(b < 0xE0) {
1305             len = 2;
1306         } else if(b < 0xF0) {
1307             len = 3;
1308         } else {
1309             len = 4;
1310         }
1311 
1312         // Check for truncated codepoints
1313         if (len > self._len) {
1314             rune._len = self._len;
1315             self._ptr += self._len;
1316             self._len = 0;
1317             return rune;
1318         }
1319 
1320         self._ptr += len;
1321         self._len -= len;
1322         rune._len = len;
1323         return rune;
1324     }
1325 
1326     /*
1327      * @dev Returns the first rune in the slice, advancing the slice to point
1328      *      to the next rune.
1329      * @param self The slice to operate on.
1330      * @return A slice containing only the first rune from `self`.
1331      */
1332     function nextRune(slice self) internal returns (slice ret) {
1333         nextRune(self, ret);
1334     }
1335 
1336     /*
1337      * @dev Returns the number of the first codepoint in the slice.
1338      * @param self The slice to operate on.
1339      * @return The number of the first codepoint in the slice.
1340      */
1341     function ord(slice self) internal returns (uint ret) {
1342         if (self._len == 0) {
1343             return 0;
1344         }
1345 
1346         uint word;
1347         uint len;
1348         uint div = 2 ** 248;
1349 
1350         // Load the rune into the MSBs of b
1351         assembly { word:= mload(mload(add(self, 32))) }
1352         var b = word / div;
1353         if (b < 0x80) {
1354             ret = b;
1355             len = 1;
1356         } else if(b < 0xE0) {
1357             ret = b & 0x1F;
1358             len = 2;
1359         } else if(b < 0xF0) {
1360             ret = b & 0x0F;
1361             len = 3;
1362         } else {
1363             ret = b & 0x07;
1364             len = 4;
1365         }
1366 
1367         // Check for truncated codepoints
1368         if (len > self._len) {
1369             return 0;
1370         }
1371 
1372         for (uint i = 1; i < len; i++) {
1373             div = div / 256;
1374             b = (word / div) & 0xFF;
1375             if (b & 0xC0 != 0x80) {
1376                 // Invalid UTF-8 sequence
1377                 return 0;
1378             }
1379             ret = (ret * 64) | (b & 0x3F);
1380         }
1381 
1382         return ret;
1383     }
1384 
1385     /*
1386      * @dev Returns the keccak-256 hash of the slice.
1387      * @param self The slice to hash.
1388      * @return The hash of the slice.
1389      */
1390     function keccak(slice self) internal returns (bytes32 ret) {
1391         assembly {
1392             ret := sha3(mload(add(self, 32)), mload(self))
1393         }
1394     }
1395 
1396     /*
1397      * @dev Returns true if `self` starts with `needle`.
1398      * @param self The slice to operate on.
1399      * @param needle The slice to search for.
1400      * @return True if the slice starts with the provided text, false otherwise.
1401      */
1402     function startsWith(slice self, slice needle) internal returns (bool) {
1403         if (self._len < needle._len) {
1404             return false;
1405         }
1406 
1407         if (self._ptr == needle._ptr) {
1408             return true;
1409         }
1410 
1411         bool equal;
1412         assembly {
1413             let len := mload(needle)
1414             let selfptr := mload(add(self, 0x20))
1415             let needleptr := mload(add(needle, 0x20))
1416             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1417         }
1418         return equal;
1419     }
1420 
1421     /*
1422      * @dev If `self` starts with `needle`, `needle` is removed from the
1423      *      beginning of `self`. Otherwise, `self` is unmodified.
1424      * @param self The slice to operate on.
1425      * @param needle The slice to search for.
1426      * @return `self`
1427      */
1428     function beyond(slice self, slice needle) internal returns (slice) {
1429         if (self._len < needle._len) {
1430             return self;
1431         }
1432 
1433         bool equal = true;
1434         if (self._ptr != needle._ptr) {
1435             assembly {
1436                 let len := mload(needle)
1437                 let selfptr := mload(add(self, 0x20))
1438                 let needleptr := mload(add(needle, 0x20))
1439                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1440             }
1441         }
1442 
1443         if (equal) {
1444             self._len -= needle._len;
1445             self._ptr += needle._len;
1446         }
1447 
1448         return self;
1449     }
1450 
1451     /*
1452      * @dev Returns true if the slice ends with `needle`.
1453      * @param self The slice to operate on.
1454      * @param needle The slice to search for.
1455      * @return True if the slice starts with the provided text, false otherwise.
1456      */
1457     function endsWith(slice self, slice needle) internal returns (bool) {
1458         if (self._len < needle._len) {
1459             return false;
1460         }
1461 
1462         var selfptr = self._ptr + self._len - needle._len;
1463 
1464         if (selfptr == needle._ptr) {
1465             return true;
1466         }
1467 
1468         bool equal;
1469         assembly {
1470             let len := mload(needle)
1471             let needleptr := mload(add(needle, 0x20))
1472             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1473         }
1474 
1475         return equal;
1476     }
1477 
1478     /*
1479      * @dev If `self` ends with `needle`, `needle` is removed from the
1480      *      end of `self`. Otherwise, `self` is unmodified.
1481      * @param self The slice to operate on.
1482      * @param needle The slice to search for.
1483      * @return `self`
1484      */
1485     function until(slice self, slice needle) internal returns (slice) {
1486         if (self._len < needle._len) {
1487             return self;
1488         }
1489 
1490         var selfptr = self._ptr + self._len - needle._len;
1491         bool equal = true;
1492         if (selfptr != needle._ptr) {
1493             assembly {
1494                 let len := mload(needle)
1495                 let needleptr := mload(add(needle, 0x20))
1496                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1497             }
1498         }
1499 
1500         if (equal) {
1501             self._len -= needle._len;
1502         }
1503 
1504         return self;
1505     }
1506 
1507     // Returns the memory address of the first byte of the first occurrence of
1508     // `needle` in `self`, or the first byte after `self` if not found.
1509     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1510         uint ptr;
1511         uint idx;
1512 
1513         if (needlelen <= selflen) {
1514             if (needlelen <= 32) {
1515                 // Optimized assembly for 68 gas per byte on short strings
1516                 assembly {
1517                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1518                     let needledata := and(mload(needleptr), mask)
1519                     let end := add(selfptr, sub(selflen, needlelen))
1520                     ptr := selfptr
1521                     loop:
1522                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1523                     ptr := add(ptr, 1)
1524                     jumpi(loop, lt(sub(ptr, 1), end))
1525                     ptr := add(selfptr, selflen)
1526                     exit:
1527                 }
1528                 return ptr;
1529             } else {
1530                 // For long needles, use hashing
1531                 bytes32 hash;
1532                 assembly { hash := sha3(needleptr, needlelen) }
1533                 ptr = selfptr;
1534                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1535                     bytes32 testHash;
1536                     assembly { testHash := sha3(ptr, needlelen) }
1537                     if (hash == testHash)
1538                         return ptr;
1539                     ptr += 1;
1540                 }
1541             }
1542         }
1543         return selfptr + selflen;
1544     }
1545 
1546     // Returns the memory address of the first byte after the last occurrence of
1547     // `needle` in `self`, or the address of `self` if not found.
1548     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1549         uint ptr;
1550 
1551         if (needlelen <= selflen) {
1552             if (needlelen <= 32) {
1553                 // Optimized assembly for 69 gas per byte on short strings
1554                 assembly {
1555                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1556                     let needledata := and(mload(needleptr), mask)
1557                     ptr := add(selfptr, sub(selflen, needlelen))
1558                     loop:
1559                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1560                     ptr := sub(ptr, 1)
1561                     jumpi(loop, gt(add(ptr, 1), selfptr))
1562                     ptr := selfptr
1563                     jump(exit)
1564                     ret:
1565                     ptr := add(ptr, needlelen)
1566                     exit:
1567                 }
1568                 return ptr;
1569             } else {
1570                 // For long needles, use hashing
1571                 bytes32 hash;
1572                 assembly { hash := sha3(needleptr, needlelen) }
1573                 ptr = selfptr + (selflen - needlelen);
1574                 while (ptr >= selfptr) {
1575                     bytes32 testHash;
1576                     assembly { testHash := sha3(ptr, needlelen) }
1577                     if (hash == testHash)
1578                         return ptr + needlelen;
1579                     ptr -= 1;
1580                 }
1581             }
1582         }
1583         return selfptr;
1584     }
1585 
1586     /*
1587      * @dev Modifies `self` to contain everything from the first occurrence of
1588      *      `needle` to the end of the slice. `self` is set to the empty slice
1589      *      if `needle` is not found.
1590      * @param self The slice to search and modify.
1591      * @param needle The text to search for.
1592      * @return `self`.
1593      */
1594     function find(slice self, slice needle) internal returns (slice) {
1595         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1596         self._len -= ptr - self._ptr;
1597         self._ptr = ptr;
1598         return self;
1599     }
1600 
1601     /*
1602      * @dev Modifies `self` to contain the part of the string from the start of
1603      *      `self` to the end of the first occurrence of `needle`. If `needle`
1604      *      is not found, `self` is set to the empty slice.
1605      * @param self The slice to search and modify.
1606      * @param needle The text to search for.
1607      * @return `self`.
1608      */
1609     function rfind(slice self, slice needle) internal returns (slice) {
1610         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1611         self._len = ptr - self._ptr;
1612         return self;
1613     }
1614 
1615     /*
1616      * @dev Splits the slice, setting `self` to everything after the first
1617      *      occurrence of `needle`, and `token` to everything before it. If
1618      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1619      *      and `token` is set to the entirety of `self`.
1620      * @param self The slice to split.
1621      * @param needle The text to search for in `self`.
1622      * @param token An output parameter to which the first token is written.
1623      * @return `token`.
1624      */
1625     function split(slice self, slice needle, slice token) internal returns (slice) {
1626         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1627         token._ptr = self._ptr;
1628         token._len = ptr - self._ptr;
1629         if (ptr == self._ptr + self._len) {
1630             // Not found
1631             self._len = 0;
1632         } else {
1633             self._len -= token._len + needle._len;
1634             self._ptr = ptr + needle._len;
1635         }
1636         return token;
1637     }
1638 
1639     /*
1640      * @dev Splits the slice, setting `self` to everything after the first
1641      *      occurrence of `needle`, and returning everything before it. If
1642      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1643      *      and the entirety of `self` is returned.
1644      * @param self The slice to split.
1645      * @param needle The text to search for in `self`.
1646      * @return The part of `self` up to the first occurrence of `delim`.
1647      */
1648     function split(slice self, slice needle) internal returns (slice token) {
1649         split(self, needle, token);
1650     }
1651 
1652     /*
1653      * @dev Splits the slice, setting `self` to everything before the last
1654      *      occurrence of `needle`, and `token` to everything after it. If
1655      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1656      *      and `token` is set to the entirety of `self`.
1657      * @param self The slice to split.
1658      * @param needle The text to search for in `self`.
1659      * @param token An output parameter to which the first token is written.
1660      * @return `token`.
1661      */
1662     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1663         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1664         token._ptr = ptr;
1665         token._len = self._len - (ptr - self._ptr);
1666         if (ptr == self._ptr) {
1667             // Not found
1668             self._len = 0;
1669         } else {
1670             self._len -= token._len + needle._len;
1671         }
1672         return token;
1673     }
1674 
1675     /*
1676      * @dev Splits the slice, setting `self` to everything before the last
1677      *      occurrence of `needle`, and returning everything after it. If
1678      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1679      *      and the entirety of `self` is returned.
1680      * @param self The slice to split.
1681      * @param needle The text to search for in `self`.
1682      * @return The part of `self` after the last occurrence of `delim`.
1683      */
1684     function rsplit(slice self, slice needle) internal returns (slice token) {
1685         rsplit(self, needle, token);
1686     }
1687 
1688     /*
1689      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1690      * @param self The slice to search.
1691      * @param needle The text to search for in `self`.
1692      * @return The number of occurrences of `needle` found in `self`.
1693      */
1694     function count(slice self, slice needle) internal returns (uint count) {
1695         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1696         while (ptr <= self._ptr + self._len) {
1697             count++;
1698             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1699         }
1700     }
1701 
1702     /*
1703      * @dev Returns True if `self` contains `needle`.
1704      * @param self The slice to search.
1705      * @param needle The text to search for in `self`.
1706      * @return True if `needle` is found in `self`, false otherwise.
1707      */
1708     function contains(slice self, slice needle) internal returns (bool) {
1709         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1710     }
1711 
1712     /*
1713      * @dev Returns a newly allocated string containing the concatenation of
1714      *      `self` and `other`.
1715      * @param self The first slice to concatenate.
1716      * @param other The second slice to concatenate.
1717      * @return The concatenation of the two strings.
1718      */
1719     function concat(slice self, slice other) internal returns (string) {
1720         var ret = new string(self._len + other._len);
1721         uint retptr;
1722         assembly { retptr := add(ret, 32) }
1723         memcpy(retptr, self._ptr, self._len);
1724         memcpy(retptr + self._len, other._ptr, other._len);
1725         return ret;
1726     }
1727 
1728     /*
1729      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1730      *      newly allocated string.
1731      * @param self The delimiter to use.
1732      * @param parts A list of slices to join.
1733      * @return A newly allocated string containing all the slices in `parts`,
1734      *         joined with `self`.
1735      */
1736     function join(slice self, slice[] parts) internal returns (string) {
1737         if (parts.length == 0)
1738             return "";
1739 
1740         uint len = self._len * (parts.length - 1);
1741         for(uint i = 0; i < parts.length; i++)
1742             len += parts[i]._len;
1743 
1744         var ret = new string(len);
1745         uint retptr;
1746         assembly { retptr := add(ret, 32) }
1747 
1748         for(i = 0; i < parts.length; i++) {
1749             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1750             retptr += parts[i]._len;
1751             if (i < parts.length - 1) {
1752                 memcpy(retptr, self._ptr, self._len);
1753                 retptr += self._len;
1754             }
1755         }
1756 
1757         return ret;
1758     }
1759 }
1760 
1761 contract LamboLotto is usingOraclize {
1762 
1763     using SafeMath for uint;
1764     using strings for *;
1765 
1766     modifier onlyAdministrator(){
1767         
1768         address _customerAddress = msg.sender;
1769         require(administrators[_customerAddress]);
1770         _;
1771     }
1772 
1773     modifier onlyActive(){
1774         
1775         require(boolContractActive);
1776         _;
1777     }
1778 
1779 	 modifier onlyHumans() {
1780          
1781 	    require (msg.sender == tx.origin, "only approved contracts allowed");
1782 	    _;
1783 	  }
1784 
1785     address private adminGet;
1786 	address private promoGet;
1787 
1788     uint32 public gasLimitForOraclize;
1789     mapping (bytes32 => address) playerAddress;
1790     mapping (bytes32 => address) playerTempAddress;
1791     mapping (bytes32 => bytes32) playerBetId;
1792     mapping (bytes32 => uint) playerBetValue;
1793     mapping (bytes32 => uint) playerTempBetValue;
1794     mapping (bytes32 => uint) playerDieResult;
1795 
1796     uint public forAdminGift = 25;
1797     uint public randomQueryId = 13;
1798 
1799     uint public jackPot_percent_now = 15;
1800     uint public jackPot_percent_next = 25;
1801 
1802     uint public jackPotWin = 888;
1803     uint public jackPotWinMinAmount = 0.1 ether;
1804     uint public minBetsVolume = 0.05 ether;
1805     uint public maxBetsVolume = 10 ether;
1806         
1807     uint public jackPot_little_first = 5;
1808     uint public jackPot_little_first_min = 0;
1809     uint public jackPot_little_first_max = 13;
1810 
1811     uint public jackPot_little_second = 3;
1812     uint public jackPot_little_second_min = 500;
1813     uint public jackPot_little_second_max = 513;
1814 
1815     uint public rand_jmin = 0;
1816     uint public rand_jmax = 1000;
1817 
1818     uint public currentReceiverIndex;
1819     uint public totalInvested;
1820 
1821     uint public betsNum;
1822     uint public jackPot_now;
1823     uint public jackPot_next;
1824     uint public jackPot_lf;
1825     uint public jackPot_ls;
1826 
1827     uint public jackPotNum = 0;
1828     uint public jackPotLFNum = 0;
1829     uint public jackPotLSNum = 0;
1830 
1831     constructor () public {
1832 
1833         administrators[msg.sender] = true;
1834         oraclize_setNetwork(networkID_auto);
1835         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);        
1836         oraclize_setCustomGasPrice(16000000000 wei);
1837         gasLimitForOraclize = 350000;
1838     }    
1839     
1840     struct Deposit {
1841 
1842         address depositor;
1843         uint deposit;
1844         uint winAmount;
1845         uint depositJackPotValue;
1846         uint status;
1847         uint payout;
1848     }
1849 
1850     Deposit[] public queue;
1851 
1852     uint nonce;
1853 
1854     bool public boolContractActive = true;
1855     mapping(address => bool) public administrators;
1856 
1857     address mkt = 0x0;
1858     uint mktRate = 0;
1859    
1860     event LogOraclizeQuery(string description); 
1861     
1862     event bets(
1863         address indexed customerAddress,
1864         uint timestamp,
1865         uint amount,
1866         uint winAmount,
1867         uint jackPotValue,
1868         uint payout,
1869         bytes32 queryId
1870     );
1871 
1872     event betsLog(
1873         address indexed customerAddress,
1874         uint timestamp,
1875         uint amount,
1876         bytes32 queryId
1877     );   
1878     
1879     event betsRefund(
1880         bytes32 betsId,
1881         address palyerAddress,
1882         uint betValue
1883     );
1884     
1885     event jackPot(
1886         uint indexed numIndex,
1887         address customerAddress,
1888         uint timestamp,
1889         uint jackAmount
1890     );
1891 
1892     event jackPotLittleFirst(
1893         uint indexed numIndex,
1894         address customerAddress,
1895         uint timestamp,
1896         uint jackAmount
1897     );
1898 
1899     event jackPotLitteleSecond(
1900         uint indexed numIndex,
1901         address customerAddress,
1902         uint timestamp,
1903         uint jackAmount
1904     );
1905 
1906     // Query Oraclize to get random number
1907     function ()
1908         onlyActive()
1909         onlyHumans()
1910         public payable {
1911         require(msg.value >= minBetsVolume && msg.value <= maxBetsVolume);
1912 
1913         randomQueryId += 1;
1914 
1915         totalInvested += msg.value;
1916         jackPot_now += msg.value.mul(jackPot_percent_now).div(1000);
1917         jackPot_next += msg.value.mul(jackPot_percent_next).div(1000);
1918 
1919         jackPot_lf += msg.value.mul(jackPot_little_first).div(1000);
1920         jackPot_ls += msg.value.mul(jackPot_little_second).div(1000);
1921 
1922         uint adminGetValue = msg.value.mul(forAdminGift).div(1000);
1923         adminGet.transfer(adminGetValue);
1924 
1925 		uint promoGetValue = msg.value.mul(forAdminGift).div(1000);
1926         promoGet.transfer(promoGetValue);
1927 
1928         if (mkt != 0x0 && mktRate != 0){
1929 
1930             uint mktGetValue = msg.value.mul(mktRate).div(1000);
1931             mkt.transfer(mktGetValue);
1932         }
1933             
1934         string memory queryString1 = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{ \"apiKey\": \"${[decrypt] BA6wdVhxT1anzZBm6Xr5OzysSzGo2DIGH349LdmWB6igg/omCb1VnwAz49WPlrUkEP1YyaqMoqrnsN+eSVB9MFVKNdVY822THfexi+JT6ThoQGoLCDlzbKD8CbCHM0d8KpPYwzYhFvbmhOfY9Lht3eVsJDSD}\",\"n\":1,\"min\":1,\"max\":1500,\"replacement\":true,\"base\":10${[identity] \"}\"},\"id\":";
1935         string memory queryString2 = uint2str(randomQueryId);
1936         string memory queryString3 = "${[identity] \"}\"}']";
1937         string memory queryString1_2 = queryString1.toSlice().concat(queryString2.toSlice());
1938         string memory queryString1_2_3 = queryString1_2.toSlice().concat(queryString3.toSlice());
1939         bytes32 queryId = oraclize_query("nested", queryString1_2_3, gasLimitForOraclize);
1940 
1941         /* map bet id to this oraclize query */
1942         playerBetId[queryId] = queryId;
1943         /* map value of wager to this oraclize query */
1944         playerBetValue[queryId] = msg.value;
1945         /* map player address to this oraclize query */
1946         playerAddress[queryId] = msg.sender;
1947 
1948         // log that query was sent
1949         emit LogOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1950         emit betsLog(playerTempAddress[queryId], now, playerTempBetValue[queryId], queryId);
1951     }
1952 
1953 
1954     // Callback function for Oraclize once it retreives the data
1955     function __callback(bytes32 queryId, string result, bytes proof) public {
1956 
1957             // only allow Oraclize to call this function
1958             require(msg.sender == oraclize_cbAddress());
1959 
1960             if (playerAddress[queryId]==0x0) throw;
1961 
1962             playerDieResult[queryId] = parseInt(result);
1963 
1964             nonce = playerDieResult[queryId];
1965 
1966             playerTempAddress[queryId] = playerAddress[queryId];
1967             delete playerAddress[queryId];
1968 
1969             playerTempBetValue[queryId] = playerBetValue[queryId];
1970             playerBetValue[queryId] = 0;
1971 
1972             betsNum++;
1973 
1974             if(playerDieResult[queryId] == 0 || bytes(result).length == 0){
1975 
1976                 emit bets(playerTempAddress[queryId], now, playerTempBetValue[queryId], playerDieResult[queryId], 0, playerTempBetValue[queryId], queryId);
1977 
1978                 if(!playerTempAddress[queryId].send(playerTempBetValue[queryId])){
1979 
1980                     queue.push( Deposit(playerTempAddress[queryId], playerTempBetValue[queryId], playerDieResult[queryId], depositJPV, 2, 0) );
1981 
1982                     pay();
1983                 }
1984 
1985                 return;
1986 
1987             }else{
1988 
1989                 uint depositJPV = 0;
1990 
1991                 if( playerTempBetValue[queryId] >= jackPotWinMinAmount)
1992                 {
1993                     depositJPV = rand(rand_jmin, rand_jmax, nonce);
1994 
1995                     if (depositJPV == jackPotWin){
1996 
1997                             playerTempAddress[queryId].transfer(jackPot_now);
1998                             jackPotNum++;
1999 
2000                             emit jackPot(jackPotNum,  playerTempAddress[queryId], now, jackPot_now );
2001 
2002                             jackPot_now = jackPot_next;
2003                             jackPot_next = 0;
2004                     }
2005 
2006                     if ( depositJPV > jackPot_little_first_min && depositJPV <= jackPot_little_first_max){
2007 
2008                             playerTempAddress[queryId].transfer(jackPot_lf);
2009                             jackPotLFNum++;
2010 
2011                             emit jackPotLittleFirst(jackPotLFNum,  playerTempAddress[queryId], now, jackPot_lf );
2012 
2013                             jackPot_lf = 0;
2014                     }
2015 
2016                     if ( depositJPV >= jackPot_little_second_min && depositJPV <= jackPot_little_second_max){
2017 
2018                             playerTempAddress[queryId].transfer(jackPot_ls);
2019                             jackPotLSNum++;
2020                             emit jackPotLitteleSecond(jackPotLSNum,  playerTempAddress[queryId], now, jackPot_ls );
2021 
2022                             jackPot_ls = 0;
2023                     }
2024 
2025                 }
2026 
2027                 uint totalPayout = playerTempBetValue[queryId].mul(playerDieResult[queryId].div(10).add(playerDieResult[queryId].div(100))).div(100);
2028                 emit bets(playerTempAddress[queryId], now, playerTempBetValue[queryId], playerDieResult[queryId], depositJPV, totalPayout, queryId);
2029 
2030                 queue.push( Deposit(playerTempAddress[queryId], playerTempBetValue[queryId], playerDieResult[queryId], depositJPV, 1, 0) );
2031 
2032                 pay();
2033             }
2034 
2035     }
2036 
2037     function pay() internal {
2038 
2039         uint money = address(this).balance.sub(jackPot_now.add(jackPot_next).add(jackPot_lf).add(jackPot_ls));
2040 
2041         for (uint i = 0; i < queue.length; i++){
2042 
2043             uint idx = currentReceiverIndex.add(i);
2044 
2045                 if(idx <= queue.length.sub(1)){
2046 
2047                     Deposit storage dep = queue[idx];
2048 
2049                         uint totalPayout = 0;
2050 
2051                         if(dep.status == 1){
2052 
2053                            totalPayout = dep.deposit.mul(dep.winAmount.div(10).add(dep.winAmount.div(100))).div(100);}
2054                         else{
2055 
2056                             totalPayout = dep.deposit;}
2057 
2058                         if(totalPayout > dep.payout) { uint leftPayout = totalPayout.sub(dep.payout); }
2059 
2060                         if(money >= leftPayout){
2061 
2062                             if (leftPayout > 0){
2063                                 dep.depositor.transfer(leftPayout);
2064                                 dep.payout += leftPayout;
2065                                 money -= leftPayout;
2066                             }
2067 
2068                         }else{
2069                             dep.depositor.transfer(money);
2070                             dep.payout += money;
2071                             break;
2072                         }
2073 
2074                     if(gasleft() <= 55000){ break; }
2075 
2076                 }else{ break; }
2077         }
2078         currentReceiverIndex += i;
2079     }
2080 
2081     function rand(uint minValue, uint maxValue, uint nonce) returns (uint){
2082 
2083         uint nonce_ = block.difficulty.div(block.number).mul(now).mod(nonce);
2084         uint mixUint = SafeMath.sub(SafeMath.mod(uint(keccak256(abi.encodePacked(nonce_))), SafeMath.add(minValue,maxValue)), minValue);
2085         return mixUint;
2086     }
2087     
2088     function ownerRefundPlayer(bytes32 betId, address sendTo, uint betValue) 
2089         onlyAdministrator()
2090         public{ 
2091             
2092         if(!sendTo.send(betValue)) throw;
2093         emit betsRefund(betId, sendTo, betValue);        
2094     } 
2095 
2096     function ownerSetCallbackGasPrice(uint newCallbackGasPrice) 
2097         onlyAdministrator()
2098         public{
2099             
2100         oraclize_setCustomGasPrice(newCallbackGasPrice);
2101     } 
2102     
2103     function ownerSetOraclizeSafeGas(uint32 newSafeGasForOraclize) 
2104         onlyAdministrator()
2105         public{
2106             
2107     	gasLimitForOraclize = newSafeGasForOraclize;
2108     }    
2109 
2110     function donate()
2111         public payable{
2112     }
2113 
2114     function setJackPotNowValue()
2115         onlyAdministrator()
2116         public payable{
2117 
2118         require(msg.value > jackPot_now);
2119         jackPot_now = msg.value;
2120     }
2121 
2122     function setJackPotNextValue()
2123         onlyAdministrator()
2124         public payable{
2125 
2126         require(msg.value > jackPot_next);
2127         jackPot_next = msg.value;
2128     }
2129 
2130     function setJackPotLFValue()
2131         onlyAdministrator()
2132         public payable{
2133 
2134         require(msg.value > jackPot_lf);
2135         jackPot_lf = msg.value;
2136     }
2137 
2138     function setJackPotLSValue()
2139         onlyAdministrator()
2140         public payable{
2141 
2142         require(msg.value > jackPot_ls);
2143         jackPot_ls =  msg.value;
2144     }
2145 
2146     function setjackPotLillteF(uint _newJPLF)
2147         onlyAdministrator()
2148         public{
2149 
2150         jackPot_little_first = _newJPLF;
2151     }
2152     
2153     function setjackPotLillteFMinMax(uint _newJPLFMin, uint _newJPLFMax)
2154         onlyAdministrator()
2155         public{
2156 
2157         jackPot_little_first_min = _newJPLFMin;
2158         jackPot_little_first_max = _newJPLFMax;
2159     }    
2160 
2161     function setjackPotLillteS(uint _newJPLS)
2162         onlyAdministrator()
2163         public{
2164 
2165         jackPot_little_second =  _newJPLS;
2166     }
2167     
2168     function setjackPotLillteSMin(uint _newJPLSMin, uint _newJPLSMax)
2169         onlyAdministrator()
2170         public{
2171 
2172         jackPot_little_second_min =  _newJPLSMin;
2173         jackPot_little_second_max =  _newJPLSMax;
2174     } 
2175 
2176     function setMarket(address _newMkt)
2177         onlyAdministrator()
2178         public{
2179 
2180         mkt =  _newMkt;
2181     }
2182 
2183     function setMarketingRates(uint _newMktRate)
2184         onlyAdministrator()
2185         public{
2186 
2187         mktRate =  _newMktRate;
2188     }
2189 
2190     function setAdminGet(address _newAdminGet)
2191         onlyAdministrator()
2192         public{
2193 
2194         adminGet =  _newAdminGet;
2195     }
2196 
2197     function setPromoGet(address _newPromoGet)
2198         onlyAdministrator()
2199         public{
2200 
2201         promoGet =  _newPromoGet;
2202     }
2203 
2204     function setForAdminGift(uint _newAdminGift)
2205         onlyAdministrator()
2206         public{
2207 
2208         forAdminGift =  _newAdminGift;
2209     }
2210 
2211    function setJeckPotPercentNow(uint _newJeckPotPercentNow)
2212         onlyAdministrator()
2213         public{
2214 
2215         jackPot_percent_now =  _newJeckPotPercentNow;
2216     }
2217 
2218    function setJeckPotPercentNext(uint _newJeckPotPercentNext)
2219         onlyAdministrator()
2220         public{
2221 
2222         jackPot_percent_next =  _newJeckPotPercentNext;
2223     }
2224 
2225    function setJeckPotWin(uint _newJeckPotWin)
2226         onlyAdministrator()
2227         public{
2228 
2229         jackPotWin =  _newJeckPotWin;
2230     }
2231 
2232    function setRandJMax(uint _newRandJMax)
2233         onlyAdministrator()
2234         public{
2235 
2236         rand_jmax =  _newRandJMax;
2237     }
2238 
2239    function setNewMinVolume(uint _newMinVol)
2240         onlyAdministrator()
2241         public{
2242 
2243         minBetsVolume =  _newMinVol;
2244     }    
2245     
2246    function setNewMaxVolume(uint _newMaxVol)
2247         onlyAdministrator()
2248         public{
2249 
2250         maxBetsVolume =  _newMaxVol;
2251     }
2252 
2253     function setContractActive(bool _status)
2254         onlyAdministrator()
2255         public{
2256 
2257         boolContractActive = _status;
2258     }
2259 
2260     function setAdministrator(address _identifier, bool _status)
2261         onlyAdministrator()
2262         public{
2263 
2264         administrators[_identifier] = _status;
2265     }
2266 
2267     function getAllDepoIfGameStop()
2268         onlyAdministrator()
2269         public{
2270 
2271         jackPot_now = 0;
2272         jackPot_next = 0;
2273         jackPot_lf = 0;
2274         jackPot_ls = 0;
2275 
2276         uint money = address(this).balance;
2277         adminGet.transfer(money);
2278     }
2279 
2280 
2281 }
2282 
2283 library SafeMath {
2284     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2285         if (a == 0) {
2286           return 0;
2287         }
2288         uint256 c = a * b;
2289         require(c / a == b);
2290         return c;
2291     }
2292 
2293     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2294         require(b > 0);
2295         uint256 c = a / b;
2296         return c;
2297     }
2298 
2299     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2300         require(b <= a);
2301         uint256 c = a - b;
2302         return c;
2303     }
2304 
2305     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2306         uint256 c = a + b;
2307         require(c >= a);
2308         return c;
2309     }
2310 
2311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2312         require(b != 0);
2313         return a % b;
2314     }
2315 }