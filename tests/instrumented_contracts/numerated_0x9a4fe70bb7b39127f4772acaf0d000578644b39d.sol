1 // ----------------------------------------------------------------------------------------------
2 // X Foundation token for the advancement of decentralised AI and robotics
3 // Symbol: |X|
4 // Total Supply: 1,000,000,000 Fixed.
5 // 
6 // Partly dedicated to GameKyuubi - Spartans Hodl.
7 // ----------------------------------------------------------------------------------------------
8 pragma solidity ^0.4.13;
9 
10 contract OraclizeI {
11     address public cbAddress;
12     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
13     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
14     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
15     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
16     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
17     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
18     function getPrice(string _datasource) returns (uint _dsprice);
19     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
20     function useCoupon(string _coupon);
21     function setProofType(byte _proofType);
22     function setConfig(bytes32 _config);
23     function setCustomGasPrice(uint _gasPrice);
24     function randomDS_getSessionPubKeyHash() returns(bytes32);
25 }
26 contract OraclizeAddrResolverI {
27     function getAddress() returns (address _addr);
28 }
29 contract usingOraclize {
30     uint constant day = 60*60*24;
31     uint constant week = 60*60*24*7;
32     uint constant month = 60*60*24*30;
33     byte constant proofType_NONE = 0x00;
34     byte constant proofType_TLSNotary = 0x10;
35     byte constant proofType_Android = 0x20;
36     byte constant proofType_Ledger = 0x30;
37     byte constant proofType_Native = 0xF0;
38     byte constant proofStorage_IPFS = 0x01;
39     uint8 constant networkID_auto = 0;
40     uint8 constant networkID_mainnet = 1;
41     uint8 constant networkID_testnet = 2;
42     uint8 constant networkID_morden = 2;
43     uint8 constant networkID_consensys = 161;
44 
45     OraclizeAddrResolverI OAR;
46 
47     OraclizeI oraclize;
48     modifier oraclizeAPI {
49         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
50         oraclize = OraclizeI(OAR.getAddress());
51         _;
52     }
53     modifier coupon(string code){
54         oraclize = OraclizeI(OAR.getAddress());
55         oraclize.useCoupon(code);
56         _;
57     }
58 
59     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
60         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
61             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
62             oraclize_setNetworkName("eth_mainnet");
63             return true;
64         }
65         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
66             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
67             oraclize_setNetworkName("eth_ropsten3");
68             return true;
69         }
70         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
71             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
72             oraclize_setNetworkName("eth_kovan");
73             return true;
74         }
75         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
76             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
77             oraclize_setNetworkName("eth_rinkeby");
78             return true;
79         }
80         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
81             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
82             return true;
83         }
84         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
85             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
86             return true;
87         }
88         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
89             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
90             return true;
91         }
92         return false;
93     }
94 
95     function __callback(bytes32 myid, string result) {
96         __callback(myid, result, new bytes(0));
97     }
98     function __callback(bytes32 myid, string result, bytes proof) {
99     }
100     
101     function oraclize_useCoupon(string code) oraclizeAPI internal {
102         oraclize.useCoupon(code);
103     }
104 
105     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
106         return oraclize.getPrice(datasource);
107     }
108 
109     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
110         return oraclize.getPrice(datasource, gaslimit);
111     }
112     
113     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
114         uint price = oraclize.getPrice(datasource);
115         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
116         return oraclize.query.value(price)(0, datasource, arg);
117     }
118     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
119         uint price = oraclize.getPrice(datasource);
120         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
121         return oraclize.query.value(price)(timestamp, datasource, arg);
122     }
123     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
124         uint price = oraclize.getPrice(datasource, gaslimit);
125         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
126         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
127     }
128     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
129         uint price = oraclize.getPrice(datasource, gaslimit);
130         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
131         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
132     }
133     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
134         uint price = oraclize.getPrice(datasource);
135         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
136         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
137     }
138     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
139         uint price = oraclize.getPrice(datasource);
140         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
141         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
142     }
143     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
144         uint price = oraclize.getPrice(datasource, gaslimit);
145         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
146         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
147     }
148     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource, gaslimit);
150         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
151         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
152     }
153     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
154         uint price = oraclize.getPrice(datasource);
155         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
156         bytes memory args = stra2cbor(argN);
157         return oraclize.queryN.value(price)(0, datasource, args);
158     }
159     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
160         uint price = oraclize.getPrice(datasource);
161         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
162         bytes memory args = stra2cbor(argN);
163         return oraclize.queryN.value(price)(timestamp, datasource, args);
164     }
165     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
166         uint price = oraclize.getPrice(datasource, gaslimit);
167         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
168         bytes memory args = stra2cbor(argN);
169         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
170     }
171     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
172         uint price = oraclize.getPrice(datasource, gaslimit);
173         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
174         bytes memory args = stra2cbor(argN);
175         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
176     }
177     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
178         string[] memory dynargs = new string[](1);
179         dynargs[0] = args[0];
180         return oraclize_query(datasource, dynargs);
181     }
182     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
183         string[] memory dynargs = new string[](1);
184         dynargs[0] = args[0];
185         return oraclize_query(timestamp, datasource, dynargs);
186     }
187     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
188         string[] memory dynargs = new string[](1);
189         dynargs[0] = args[0];
190         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
191     }
192     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
193         string[] memory dynargs = new string[](1);
194         dynargs[0] = args[0];       
195         return oraclize_query(datasource, dynargs, gaslimit);
196     }
197     
198     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
199         string[] memory dynargs = new string[](2);
200         dynargs[0] = args[0];
201         dynargs[1] = args[1];
202         return oraclize_query(datasource, dynargs);
203     }
204     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
205         string[] memory dynargs = new string[](2);
206         dynargs[0] = args[0];
207         dynargs[1] = args[1];
208         return oraclize_query(timestamp, datasource, dynargs);
209     }
210     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
211         string[] memory dynargs = new string[](2);
212         dynargs[0] = args[0];
213         dynargs[1] = args[1];
214         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
215     }
216     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
217         string[] memory dynargs = new string[](2);
218         dynargs[0] = args[0];
219         dynargs[1] = args[1];
220         return oraclize_query(datasource, dynargs, gaslimit);
221     }
222     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
223         string[] memory dynargs = new string[](3);
224         dynargs[0] = args[0];
225         dynargs[1] = args[1];
226         dynargs[2] = args[2];
227         return oraclize_query(datasource, dynargs);
228     }
229     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
230         string[] memory dynargs = new string[](3);
231         dynargs[0] = args[0];
232         dynargs[1] = args[1];
233         dynargs[2] = args[2];
234         return oraclize_query(timestamp, datasource, dynargs);
235     }
236     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
237         string[] memory dynargs = new string[](3);
238         dynargs[0] = args[0];
239         dynargs[1] = args[1];
240         dynargs[2] = args[2];
241         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
242     }
243     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
244         string[] memory dynargs = new string[](3);
245         dynargs[0] = args[0];
246         dynargs[1] = args[1];
247         dynargs[2] = args[2];
248         return oraclize_query(datasource, dynargs, gaslimit);
249     }
250     
251     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
252         string[] memory dynargs = new string[](4);
253         dynargs[0] = args[0];
254         dynargs[1] = args[1];
255         dynargs[2] = args[2];
256         dynargs[3] = args[3];
257         return oraclize_query(datasource, dynargs);
258     }
259     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
260         string[] memory dynargs = new string[](4);
261         dynargs[0] = args[0];
262         dynargs[1] = args[1];
263         dynargs[2] = args[2];
264         dynargs[3] = args[3];
265         return oraclize_query(timestamp, datasource, dynargs);
266     }
267     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
268         string[] memory dynargs = new string[](4);
269         dynargs[0] = args[0];
270         dynargs[1] = args[1];
271         dynargs[2] = args[2];
272         dynargs[3] = args[3];
273         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
274     }
275     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
276         string[] memory dynargs = new string[](4);
277         dynargs[0] = args[0];
278         dynargs[1] = args[1];
279         dynargs[2] = args[2];
280         dynargs[3] = args[3];
281         return oraclize_query(datasource, dynargs, gaslimit);
282     }
283     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
284         string[] memory dynargs = new string[](5);
285         dynargs[0] = args[0];
286         dynargs[1] = args[1];
287         dynargs[2] = args[2];
288         dynargs[3] = args[3];
289         dynargs[4] = args[4];
290         return oraclize_query(datasource, dynargs);
291     }
292     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
293         string[] memory dynargs = new string[](5);
294         dynargs[0] = args[0];
295         dynargs[1] = args[1];
296         dynargs[2] = args[2];
297         dynargs[3] = args[3];
298         dynargs[4] = args[4];
299         return oraclize_query(timestamp, datasource, dynargs);
300     }
301     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
302         string[] memory dynargs = new string[](5);
303         dynargs[0] = args[0];
304         dynargs[1] = args[1];
305         dynargs[2] = args[2];
306         dynargs[3] = args[3];
307         dynargs[4] = args[4];
308         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
309     }
310     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
311         string[] memory dynargs = new string[](5);
312         dynargs[0] = args[0];
313         dynargs[1] = args[1];
314         dynargs[2] = args[2];
315         dynargs[3] = args[3];
316         dynargs[4] = args[4];
317         return oraclize_query(datasource, dynargs, gaslimit);
318     }
319     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
320         uint price = oraclize.getPrice(datasource);
321         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
322         bytes memory args = ba2cbor(argN);
323         return oraclize.queryN.value(price)(0, datasource, args);
324     }
325     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
326         uint price = oraclize.getPrice(datasource);
327         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
328         bytes memory args = ba2cbor(argN);
329         return oraclize.queryN.value(price)(timestamp, datasource, args);
330     }
331     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
332         uint price = oraclize.getPrice(datasource, gaslimit);
333         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
334         bytes memory args = ba2cbor(argN);
335         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
336     }
337     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
338         uint price = oraclize.getPrice(datasource, gaslimit);
339         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
340         bytes memory args = ba2cbor(argN);
341         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
342     }
343     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
344         bytes[] memory dynargs = new bytes[](1);
345         dynargs[0] = args[0];
346         return oraclize_query(datasource, dynargs);
347     }
348     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
349         bytes[] memory dynargs = new bytes[](1);
350         dynargs[0] = args[0];
351         return oraclize_query(timestamp, datasource, dynargs);
352     }
353     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
354         bytes[] memory dynargs = new bytes[](1);
355         dynargs[0] = args[0];
356         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
357     }
358     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
359         bytes[] memory dynargs = new bytes[](1);
360         dynargs[0] = args[0];       
361         return oraclize_query(datasource, dynargs, gaslimit);
362     }
363     
364     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
365         bytes[] memory dynargs = new bytes[](2);
366         dynargs[0] = args[0];
367         dynargs[1] = args[1];
368         return oraclize_query(datasource, dynargs);
369     }
370     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
371         bytes[] memory dynargs = new bytes[](2);
372         dynargs[0] = args[0];
373         dynargs[1] = args[1];
374         return oraclize_query(timestamp, datasource, dynargs);
375     }
376     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
377         bytes[] memory dynargs = new bytes[](2);
378         dynargs[0] = args[0];
379         dynargs[1] = args[1];
380         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
381     }
382     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
383         bytes[] memory dynargs = new bytes[](2);
384         dynargs[0] = args[0];
385         dynargs[1] = args[1];
386         return oraclize_query(datasource, dynargs, gaslimit);
387     }
388     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
389         bytes[] memory dynargs = new bytes[](3);
390         dynargs[0] = args[0];
391         dynargs[1] = args[1];
392         dynargs[2] = args[2];
393         return oraclize_query(datasource, dynargs);
394     }
395     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
396         bytes[] memory dynargs = new bytes[](3);
397         dynargs[0] = args[0];
398         dynargs[1] = args[1];
399         dynargs[2] = args[2];
400         return oraclize_query(timestamp, datasource, dynargs);
401     }
402     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
403         bytes[] memory dynargs = new bytes[](3);
404         dynargs[0] = args[0];
405         dynargs[1] = args[1];
406         dynargs[2] = args[2];
407         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
408     }
409     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
410         bytes[] memory dynargs = new bytes[](3);
411         dynargs[0] = args[0];
412         dynargs[1] = args[1];
413         dynargs[2] = args[2];
414         return oraclize_query(datasource, dynargs, gaslimit);
415     }
416     
417     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
418         bytes[] memory dynargs = new bytes[](4);
419         dynargs[0] = args[0];
420         dynargs[1] = args[1];
421         dynargs[2] = args[2];
422         dynargs[3] = args[3];
423         return oraclize_query(datasource, dynargs);
424     }
425     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
426         bytes[] memory dynargs = new bytes[](4);
427         dynargs[0] = args[0];
428         dynargs[1] = args[1];
429         dynargs[2] = args[2];
430         dynargs[3] = args[3];
431         return oraclize_query(timestamp, datasource, dynargs);
432     }
433     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
434         bytes[] memory dynargs = new bytes[](4);
435         dynargs[0] = args[0];
436         dynargs[1] = args[1];
437         dynargs[2] = args[2];
438         dynargs[3] = args[3];
439         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
440     }
441     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
442         bytes[] memory dynargs = new bytes[](4);
443         dynargs[0] = args[0];
444         dynargs[1] = args[1];
445         dynargs[2] = args[2];
446         dynargs[3] = args[3];
447         return oraclize_query(datasource, dynargs, gaslimit);
448     }
449     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
450         bytes[] memory dynargs = new bytes[](5);
451         dynargs[0] = args[0];
452         dynargs[1] = args[1];
453         dynargs[2] = args[2];
454         dynargs[3] = args[3];
455         dynargs[4] = args[4];
456         return oraclize_query(datasource, dynargs);
457     }
458     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
459         bytes[] memory dynargs = new bytes[](5);
460         dynargs[0] = args[0];
461         dynargs[1] = args[1];
462         dynargs[2] = args[2];
463         dynargs[3] = args[3];
464         dynargs[4] = args[4];
465         return oraclize_query(timestamp, datasource, dynargs);
466     }
467     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
468         bytes[] memory dynargs = new bytes[](5);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         dynargs[2] = args[2];
472         dynargs[3] = args[3];
473         dynargs[4] = args[4];
474         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
475     }
476     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
477         bytes[] memory dynargs = new bytes[](5);
478         dynargs[0] = args[0];
479         dynargs[1] = args[1];
480         dynargs[2] = args[2];
481         dynargs[3] = args[3];
482         dynargs[4] = args[4];
483         return oraclize_query(datasource, dynargs, gaslimit);
484     }
485 
486     function oraclize_cbAddress() oraclizeAPI internal returns (address){
487         return oraclize.cbAddress();
488     }
489     function oraclize_setProof(byte proofP) oraclizeAPI internal {
490         return oraclize.setProofType(proofP);
491     }
492     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
493         return oraclize.setCustomGasPrice(gasPrice);
494     }
495     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
496         return oraclize.setConfig(config);
497     }
498     
499     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
500         return oraclize.randomDS_getSessionPubKeyHash();
501     }
502 
503     function getCodeSize(address _addr) constant internal returns(uint _size) {
504         assembly {
505             _size := extcodesize(_addr)
506         }
507     }
508 
509     function parseAddr(string _a) internal returns (address){
510         bytes memory tmp = bytes(_a);
511         uint160 iaddr = 0;
512         uint160 b1;
513         uint160 b2;
514         for (uint i=2; i<2+2*20; i+=2){
515             iaddr *= 256;
516             b1 = uint160(tmp[i]);
517             b2 = uint160(tmp[i+1]);
518             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
519             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
520             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
521             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
522             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
523             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
524             iaddr += (b1*16+b2);
525         }
526         return address(iaddr);
527     }
528 
529     function strCompare(string _a, string _b) internal returns (int) {
530         bytes memory a = bytes(_a);
531         bytes memory b = bytes(_b);
532         uint minLength = a.length;
533         if (b.length < minLength) minLength = b.length;
534         for (uint i = 0; i < minLength; i ++)
535             if (a[i] < b[i])
536                 return -1;
537             else if (a[i] > b[i])
538                 return 1;
539         if (a.length < b.length)
540             return -1;
541         else if (a.length > b.length)
542             return 1;
543         else
544             return 0;
545     }
546 
547     function indexOf(string _haystack, string _needle) internal returns (int) {
548         bytes memory h = bytes(_haystack);
549         bytes memory n = bytes(_needle);
550         if(h.length < 1 || n.length < 1 || (n.length > h.length))
551             return -1;
552         else if(h.length > (2**128 -1))
553             return -1;
554         else
555         {
556             uint subindex = 0;
557             for (uint i = 0; i < h.length; i ++)
558             {
559                 if (h[i] == n[0])
560                 {
561                     subindex = 1;
562                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
563                     {
564                         subindex++;
565                     }
566                     if(subindex == n.length)
567                         return int(i);
568                 }
569             }
570             return -1;
571         }
572     }
573 
574     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
575         bytes memory _ba = bytes(_a);
576         bytes memory _bb = bytes(_b);
577         bytes memory _bc = bytes(_c);
578         bytes memory _bd = bytes(_d);
579         bytes memory _be = bytes(_e);
580         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
581         bytes memory babcde = bytes(abcde);
582         uint k = 0;
583         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
584         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
585         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
586         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
587         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
588         return string(babcde);
589     }
590 
591     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
592         return strConcat(_a, _b, _c, _d, "");
593     }
594 
595     function strConcat(string _a, string _b, string _c) internal returns (string) {
596         return strConcat(_a, _b, _c, "", "");
597     }
598 
599     function strConcat(string _a, string _b) internal returns (string) {
600         return strConcat(_a, _b, "", "", "");
601     }
602 
603     // parseInt
604     function parseInt(string _a) internal returns (uint) {
605         return parseInt(_a, 0);
606     }
607 
608     // parseInt(parseFloat*10^_b)
609     function parseInt(string _a, uint _b) internal returns (uint) {
610         bytes memory bresult = bytes(_a);
611         uint mint = 0;
612         bool decimals = false;
613         for (uint i=0; i<bresult.length; i++){
614             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
615                 if (decimals){
616                    if (_b == 0) break;
617                     else _b--;
618                 }
619                 mint *= 10;
620                 mint += uint(bresult[i]) - 48;
621             } else if (bresult[i] == 46) decimals = true;
622         }
623         if (_b > 0) mint *= 10**_b;
624         return mint;
625     }
626 
627     function uint2str(uint i) internal returns (string){
628         if (i == 0) return "0";
629         uint j = i;
630         uint len;
631         while (j != 0){
632             len++;
633             j /= 10;
634         }
635         bytes memory bstr = new bytes(len);
636         uint k = len - 1;
637         while (i != 0){
638             bstr[k--] = byte(48 + i % 10);
639             i /= 10;
640         }
641         return string(bstr);
642     }
643     
644     function stra2cbor(string[] arr) internal returns (bytes) {
645             uint arrlen = arr.length;
646 
647             // get correct cbor output length
648             uint outputlen = 0;
649             bytes[] memory elemArray = new bytes[](arrlen);
650             for (uint i = 0; i < arrlen; i++) {
651                 elemArray[i] = (bytes(arr[i]));
652                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
653             }
654             uint ctr = 0;
655             uint cborlen = arrlen + 0x80;
656             outputlen += byte(cborlen).length;
657             bytes memory res = new bytes(outputlen);
658 
659             while (byte(cborlen).length > ctr) {
660                 res[ctr] = byte(cborlen)[ctr];
661                 ctr++;
662             }
663             for (i = 0; i < arrlen; i++) {
664                 res[ctr] = 0x5F;
665                 ctr++;
666                 for (uint x = 0; x < elemArray[i].length; x++) {
667                     // if there's a bug with larger strings, this may be the culprit
668                     if (x % 23 == 0) {
669                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
670                         elemcborlen += 0x40;
671                         uint lctr = ctr;
672                         while (byte(elemcborlen).length > ctr - lctr) {
673                             res[ctr] = byte(elemcborlen)[ctr - lctr];
674                             ctr++;
675                         }
676                     }
677                     res[ctr] = elemArray[i][x];
678                     ctr++;
679                 }
680                 res[ctr] = 0xFF;
681                 ctr++;
682             }
683             return res;
684         }
685 
686     function ba2cbor(bytes[] arr) internal returns (bytes) {
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
728         
729     string oraclize_network_name;
730     function oraclize_setNetworkName(string _network_name) internal {
731         oraclize_network_name = _network_name;
732     }
733     
734     function oraclize_getNetworkName() internal returns (string) {
735         return oraclize_network_name;
736     }
737     
738     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
739         if ((_nbytes == 0)||(_nbytes > 32)) throw;
740         bytes memory nbytes = new bytes(1);
741         nbytes[0] = byte(_nbytes);
742         bytes memory unonce = new bytes(32);
743         bytes memory sessionKeyHash = new bytes(32);
744         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
745         assembly {
746             mstore(unonce, 0x20)
747             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
748             mstore(sessionKeyHash, 0x20)
749             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
750         }
751         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
752         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
753         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
754         return queryId;
755     }
756     
757     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
758         oraclize_randomDS_args[queryId] = commitment;
759     }
760     
761     mapping(bytes32=>bytes32) oraclize_randomDS_args;
762     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
763 
764     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
765         bool sigok;
766         address signer;
767         
768         bytes32 sigr;
769         bytes32 sigs;
770         
771         bytes memory sigr_ = new bytes(32);
772         uint offset = 4+(uint(dersig[3]) - 0x20);
773         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
774         bytes memory sigs_ = new bytes(32);
775         offset += 32 + 2;
776         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
777 
778         assembly {
779             sigr := mload(add(sigr_, 32))
780             sigs := mload(add(sigs_, 32))
781         }
782         
783         
784         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
785         if (address(sha3(pubkey)) == signer) return true;
786         else {
787             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
788             return (address(sha3(pubkey)) == signer);
789         }
790     }
791 
792     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
793         bool sigok;
794         
795         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
796         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
797         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
798         
799         bytes memory appkey1_pubkey = new bytes(64);
800         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
801         
802         bytes memory tosign2 = new bytes(1+65+32);
803         tosign2[0] = 1; //role
804         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
805         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
806         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
807         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
808         
809         if (sigok == false) return false;
810         
811         
812         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
813         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
814         
815         bytes memory tosign3 = new bytes(1+65);
816         tosign3[0] = 0xFE;
817         copyBytes(proof, 3, 65, tosign3, 1);
818         
819         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
820         copyBytes(proof, 3+65, sig3.length, sig3, 0);
821         
822         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
823         
824         return sigok;
825     }
826     
827     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
828         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
829         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
830         
831         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
832         if (proofVerified == false) throw;
833         
834         _;
835     }
836     
837     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
838         bool match_ = true;
839         
840         for (var i=0; i<prefix.length; i++){
841             if (content[i] != prefix[i]) match_ = false;
842         }
843         
844         return match_;
845     }
846 
847     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
848         bool checkok;
849         
850         
851         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
852         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
853         bytes memory keyhash = new bytes(32);
854         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
855         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
856         if (checkok == false) return false;
857         
858         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
859         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
860         
861         
862         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
863         checkok = matchBytes32Prefix(sha256(sig1), result);
864         if (checkok == false) return false;
865         
866         
867         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
868         // This is to verify that the computed args match with the ones specified in the query.
869         bytes memory commitmentSlice1 = new bytes(8+1+32);
870         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
871         
872         bytes memory sessionPubkey = new bytes(64);
873         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
874         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
875         
876         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
877         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
878             delete oraclize_randomDS_args[queryId];
879         } else return false;
880         
881         
882         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
883         bytes memory tosign1 = new bytes(32+8+1+32);
884         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
885         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
886         if (checkok == false) return false;
887         
888         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
889         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
890             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
891         }
892         
893         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
894     }
895 
896     
897     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
898     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
899         uint minLength = length + toOffset;
900 
901         if (to.length < minLength) {
902             // Buffer too small
903             throw; // Should be a better way?
904         }
905 
906         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
907         uint i = 32 + fromOffset;
908         uint j = 32 + toOffset;
909 
910         while (i < (32 + fromOffset + length)) {
911             assembly {
912                 let tmp := mload(add(from, i))
913                 mstore(add(to, j), tmp)
914             }
915             i += 32;
916             j += 32;
917         }
918 
919         return to;
920     }
921     
922     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
923     // Duplicate Solidity's ecrecover, but catching the CALL return value
924     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
925         // We do our own memory management here. Solidity uses memory offset
926         // 0x40 to store the current end of memory. We write past it (as
927         // writes are memory extensions), but don't update the offset so
928         // Solidity will reuse it. The memory used here is only needed for
929         // this context.
930 
931         // FIXME: inline assembly can't access return values
932         bool ret;
933         address addr;
934 
935         assembly {
936             let size := mload(0x40)
937             mstore(size, hash)
938             mstore(add(size, 32), v)
939             mstore(add(size, 64), r)
940             mstore(add(size, 96), s)
941 
942             // NOTE: we can reuse the request memory because we deal with
943             //       the return code
944             ret := call(3000, 1, 0, size, 128, size, 32)
945             addr := mload(size)
946         }
947   
948         return (ret, addr);
949     }
950 
951     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
952     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
953         bytes32 r;
954         bytes32 s;
955         uint8 v;
956 
957         if (sig.length != 65)
958           return (false, 0);
959 
960         // The signature format is a compact form of:
961         //   {bytes32 r}{bytes32 s}{uint8 v}
962         // Compact means, uint8 is not padded to 32 bytes.
963         assembly {
964             r := mload(add(sig, 32))
965             s := mload(add(sig, 64))
966 
967             // Here we are loading the last 32 bytes. We exploit the fact that
968             // 'mload' will pad with zeroes if we overread.
969             // There is no 'mload8' to do this, but that would be nicer.
970             v := byte(0, mload(add(sig, 96)))
971 
972             // Alternative solution:
973             // 'byte' is not working due to the Solidity parser, so lets
974             // use the second best option, 'and'
975             // v := and(mload(add(sig, 65)), 255)
976         }
977 
978         // albeit non-transactional signatures are not specified by the YP, one would expect it
979         // to match the YP range of [27, 28]
980         //
981         // geth uses [0, 1] and some clients have followed. This might change, see:
982         //  https://github.com/ethereum/go-ethereum/issues/2053
983         if (v < 27)
984           v += 27;
985 
986         if (v != 27 && v != 28)
987             return (false, 0);
988 
989         return safer_ecrecover(hash, v, r, s);
990     }
991         
992 }
993 
994 /* Contract Ownership */
995 contract owned 
996 {
997 	address public owner;
998 
999 	function owned() 
1000 	{
1001         	owner = msg.sender;
1002 	}
1003 
1004 	modifier onlyOwner 
1005 	{
1006         	if (msg.sender != owner) throw;
1007         	_;
1008 	}
1009 
1010 	function transferOwnership(address newOwner) onlyOwner 
1011 	{
1012         	owner = newOwner;
1013 	}
1014 }
1015 
1016 /* ERC20 interface */
1017 contract ERC20Interface 
1018 {
1019 	// Get the total token supply
1020 	function totalSupply() constant returns (uint256 totalSupply);
1021 
1022 	// Get the account balance of another account with address _owner
1023 	function balanceOf(address _owner) constant returns (uint256 balance);
1024 
1025 	// Send _value amount of tokens to address _to
1026 	function transfer(address _to, uint256 _value) returns (bool success);
1027  
1028 	// Send _value amount of tokens from address _from to address _to 
1029 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
1030  
1031 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount. 
1032 	// If this function is called again it overwrites the current allowance with _value. 
1033 	// this function is required for some DEX functionality 
1034 	function approve(address _spender, uint256 _value) returns (bool success);
1035  
1036 	// Returns the amount which _spender is still allowed to withdraw from _owner
1037 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);
1038  
1039 	// Triggered when tokens are transferred.
1040 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
1041 
1042 	// Triggered whenever approve(address _spender, uint256 _value) is called. 
1043 	event Approval(address indexed _owner, address indexed _spender, uint256 _value); 
1044 }
1045 
1046 contract X is owned, ERC20Interface, usingOraclize 
1047 {
1048     event Transfer(address indexed _from, address indexed _to, uint _value);
1049     event Approval(address indexed _owner, address indexed _spender, uint _value);
1050 	mapping (address => uint256) public balances;
1051 	struct donation
1052 	{
1053         address _donationAddress;
1054         uint _donationAmount;
1055     }
1056     donation[] public _donations;
1057 	donation[] public regularDonations;
1058 	
1059 	mapping(address => mapping (address => uint256)) allowed;
1060 	
1061 	string public constant name = "X";
1062 	string public constant symbol = "|X|";
1063 	uint public constant decimals = 8;
1064 
1065 	uint _totalSupply = 100000000000000000;
1066 	uint _totalDonationSupply = 1000000000000000;
1067 	
1068 	//Ether values
1069 	uint public _totalDonations = 0;
1070 	uint public _regularDonationsTotal = 0;
1071 	
1072 	uint public _crowdSaleSupply = 100000000000000;
1073 	uint public _donationSupply = 1000000000000000;
1074 	uint public _foundationSupply = 13000000000000000;
1075 	uint public _AIExchangeSupply = 10900000000000000;
1076 	uint public _lotterySupply = 18750000000000000;
1077 	uint public _mineableSupply = 56250000000000000;
1078 	
1079 	uint _presalePrice = 0.0035 ether; //not used - here for posterity
1080 	uint _julPrice = 0.00525 ether;
1081 	uint _augPrice = 0.065 ether;
1082 	uint _sepPrice = 0.007 ether;
1083 	uint _octPrice = 0.0077 ether;
1084 	uint _novPrice = 0.00875 ether;
1085 	uint _decPrice = 0.01 ether;
1086 
1087 	uint _aug17 = 1501545600;
1088 	uint _sep17 = 1504224000;
1089 	uint _oct17 = 1506816000;
1090 	uint _nov17 = 1509494400;
1091 	uint _dec17 = 1512086400;
1092 	uint _jan18 = 1514764800;
1093 	
1094 	//gas price
1095 	uint public oraclizeGasPrice = 200000;
1096 
1097 	function X() 
1098 	{
1099 		//Addresses to send tokens to
1100 		address AIExchange = 0x0035c4C86f15ba80319853df6092C838bA9B39C8;
1101 		address preSale1 = 0x0664B21FD33865c2259d2674f75b8C2a1A4e27A7; // 11 tokens, donated 0.0015 ether
1102 		address preSale2 = 0xaA41e0F9f4A19719007C53064B6979bDB6DF8b8c; // 628 tokens, 0.002 ether
1103 		address preSale3 = 0x32Be343B94f860124dC4fEe278FDCBD38C102D88; // 80 tokens, 0 donation
1104 		address preSale4 = 0x7eD1E469fCb3EE19C0366D829e291451bE638E59; // 10 tokens, 0 donation
1105 		address preSale5 = 0x8aa50dfc95Ab047128ccDc6Af4BA2dDbA8D0A874; // Bitcoin sale, 200 tokens, 0 donation 
1106 		
1107 		//Allocation to the X Foundation and AI Exchange
1108 		balances[msg.sender] = _foundationSupply;
1109 		balances[AIExchange] = _AIExchangeSupply;
1110 		_foundationSupply -= _foundationSupply;
1111 		_AIExchangeSupply -= _AIExchangeSupply;
1112 		
1113 		//Allocation to presale addresses (before contract deployment.)
1114 		balances[preSale1] = 1100000000; 
1115 		_donations.push(donation({_donationAddress: preSale1, _donationAmount: 0.0015 ether}));
1116 		_totalDonations += 0.0015 ether;
1117 		_crowdSaleSupply -= balances[preSale1];
1118 
1119 		balances[preSale2] = 62800000000;
1120 		_donations.push(donation({_donationAddress: preSale2, _donationAmount: 0.002 ether}));
1121 		_totalDonations += 0.002 ether;
1122 		_crowdSaleSupply -= balances[preSale2];
1123 
1124 		balances[preSale3] = 8000000000;
1125 		_crowdSaleSupply -= balances[preSale3];
1126 
1127 		balances[preSale4] = 1000000000;
1128 		_crowdSaleSupply -= balances[preSale4];
1129 
1130 		balances[preSale5] = 20000000000;
1131 		_crowdSaleSupply -= balances[preSale5];
1132 	}
1133 
1134     /* Runs when Ether is sent to the contract address */
1135 	function () payable
1136 	{
1137 		uint amount = msg.value;
1138 		if (now > _jan18)
1139 		{
1140 			regularDonations.push(donation({_donationAddress: msg.sender, _donationAmount: amount}));
1141 			_regularDonationsTotal += amount;
1142 			return;
1143 		}
1144 		uint crowdSaleCost = getCurrentTokenCost();
1145 		if (amount < crowdSaleCost)
1146 		{
1147 			revert(); //whole token purchases only
1148 		}
1149 		uint wholeNumTokens = amount/crowdSaleCost; 
1150 		uint remainderEth = amount - ((amount/crowdSaleCost)*crowdSaleCost);
1151 		
1152 		if ((_crowdSaleSupply/(10**decimals)) >= wholeNumTokens)
1153 		{
1154 			balances[msg.sender] = wholeNumTokens * (10**decimals);
1155 			_crowdSaleSupply -= wholeNumTokens * (10**decimals);
1156 			if(remainderEth > 0)
1157 			{
1158 				_donations.push(donation({_donationAddress: msg.sender, _donationAmount: remainderEth}));
1159 				_totalDonations += remainderEth;
1160 			}
1161 		}
1162 		else
1163 		{
1164 			if(_crowdSaleSupply > 0 && (_crowdSaleSupply/(10**decimals)) < wholeNumTokens)
1165 			{
1166 			    balances[msg.sender] = _crowdSaleSupply;
1167 			    uint donationEth = (wholeNumTokens - (_crowdSaleSupply/(10**decimals))) * crowdSaleCost;
1168 			    _donations.push(donation({_donationAddress: msg.sender, _donationAmount: donationEth}));
1169 			    _totalDonations += donationEth;
1170 			    _crowdSaleSupply = 0;
1171 			}
1172 			else
1173 			{
1174 			    _donations.push(donation({_donationAddress: msg.sender, _donationAmount: amount}));
1175 			    _totalDonations += amount;
1176 			}
1177 		}
1178 		
1179 	}	
1180 
1181     function donationCount() returns (uint num)
1182     {
1183         return _donations.length;
1184     }
1185 	function crowdSaleDonate() payable returns (bool success)
1186 	{
1187 		if (now > _jan18)
1188 		{
1189 			revert();
1190 		}
1191 
1192 		uint amount = msg.value;
1193 		if (amount > 0)
1194 		{
1195 		    _donations.push(donation({_donationAddress: msg.sender, _donationAmount: amount}));
1196 		    _totalDonations += amount;
1197 		    return true;
1198 		}
1199 		else
1200 		{
1201 		    return false;
1202 		}
1203 	}
1204 
1205 	function getCurrentTokenCost() returns (uint crowdSaleCost)
1206 	{
1207 		if(now < _aug17)
1208 		{
1209 			return _julPrice;
1210 		}
1211 		else if(now < _sep17)
1212 		{
1213 			return _augPrice;
1214 		}
1215 		else if(now < _oct17)
1216 		{
1217 			return _sepPrice;
1218 		}
1219 		else if(now < _nov17)
1220 		{
1221 			return _octPrice;
1222 		}
1223 		else if(now < _dec17)
1224 		{
1225 			return _novPrice;
1226 		}
1227 		else
1228 		{
1229 			return _decPrice;
1230 		}
1231 	}
1232 	
1233 	function distributeDonationTokens() onlyOwner returns (bool success)
1234 	{
1235 	    if (now > _jan18)
1236 	    {
1237 	        return false;
1238 	    }
1239 	    else if (_donations.length == 0)
1240 	    {
1241 	        return false;
1242 	    }
1243 	    else
1244 	    {
1245 	        //distribute to addresses
1246 	        uint currentDistribution = 0;
1247 	        while(_donations.length - currentDistribution > 0)
1248 	        {
1249 	            donation currentDonor = _donations[_donations.length - currentDistribution - 1];
1250 	            uint transferAmount = ((_totalDonationSupply * currentDonor._donationAmount)/(_totalDonations));
1251 	            balances[currentDonor._donationAddress] += transferAmount;
1252 	            delete _donations[_donations.length - currentDistribution - 1];
1253 	            currentDistribution += 1;
1254 	        }
1255 	        return true;
1256 	    }
1257 	}
1258 	
1259 	function changeOraclizeGasPrice(uint price) onlyOwner returns (bool success)
1260 	{
1261 	    oraclizeGasPrice = price;
1262 	    return true;
1263 	}
1264 	
1265 	function withdrawFunds() onlyOwner returns (bool success)
1266 	{
1267 	    owner.call.gas(200000).value(this.balance)();
1268 	    return true;
1269 	}
1270 
1271 	/* ========== ERC20 implementations ========== */
1272 	function totalSupply() constant returns (uint256 totalSupply)
1273 	{
1274         	totalSupply = _totalSupply;
1275     } 
1276  
1277     function balanceOf(address _owner) constant returns (uint256 balance) 
1278 	{
1279         	return balances[_owner];
1280 	}
1281 
1282 	function transfer(address _to, uint256 _value) returns (bool success)
1283 	{
1284 		if (balances[msg.sender] < _value || balances[_to] + _value < balances[_to])
1285 		{
1286         	revert();
1287         	return false;
1288 		}
1289     	balances[msg.sender] -= _value;
1290     	balances[_to] += _value;
1291     	Transfer(msg.sender, _to, _value);
1292     	return true;
1293 	}
1294 
1295 	function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) 
1296 	{ 
1297         	if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) 
1298 		{
1299             		balances[_from] -= _amount; 
1300             		allowed[_from][msg.sender] -= _amount;
1301            		balances[_to] += _amount; 
1302             		Transfer(_from, _to, _amount);
1303             		return true;
1304         	} 
1305 		else 
1306 		{
1307             		return false;
1308         	}
1309     	}
1310 
1311 	function approve(address _spender, uint256 _amount) returns (bool success)
1312 	{
1313         	allowed[msg.sender][_spender] = _amount; 
1314         	Approval(msg.sender, _spender, _amount); 
1315         	return true; 
1316 	}
1317 
1318 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) 
1319 	{
1320         	return allowed[_owner][_spender]; 
1321 	}
1322     
1323     function __callback(bytes32 myid, string result) 
1324     {
1325         if (msg.sender != oraclize_cbAddress()) 
1326         {
1327             throw;
1328         }
1329         address lotteryWinner = parseAddr(result);
1330 		if (_lotterySupply >= (1 * 10**decimals))
1331 		{
1332 			_lotterySupply -= 1 * (10**decimals);
1333 			balances[lotteryWinner] += 1 * (10**decimals);
1334 		}
1335 		else
1336 		{
1337 			balances[lotteryWinner] += _lotterySupply;
1338 			_lotterySupply -= _lotterySupply;	
1339 		}
1340     }
1341 
1342 	/* ========== Block Rewards =============*/
1343 	//Miners should ensure that they pass in at least 250,000 gas
1344 	function giveBlockReward() payable returns (bool success)
1345 	{
1346 		//lottery reward - NB: Call this function with at least 
1347 		oraclize_query("URL", "json(https://digitx.io/GetLotteryWinner.aspx).winner", oraclizeGasPrice);
1348 		
1349 		//miner reward
1350 		if (_mineableSupply >= (3 * 10**decimals))
1351 		{
1352 			_mineableSupply -= 3 * (10**decimals);
1353 			balances[block.coinbase] += 3 * (10**decimals);
1354 		}
1355 		else
1356 		{
1357 		    balances[block.coinbase] += _mineableSupply;
1358 			_mineableSupply -= _mineableSupply;	
1359 		}
1360 		return true;
1361 	}
1362 	
1363 }