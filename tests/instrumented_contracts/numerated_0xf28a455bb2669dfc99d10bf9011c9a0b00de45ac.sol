1 pragma solidity ^0.4.24;
2 
3  
4  
5 
6 contract OraclizeI {
7     address public cbAddress;
8     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
9     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
10     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
11     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
12     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
13     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
14     function getPrice(string _datasource) returns (uint _dsprice);
15     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
16     function useCoupon(string _coupon);
17     function setProofType(byte _proofType);
18     function setConfig(bytes32 _config);
19     function setCustomGasPrice(uint _gasPrice);
20     function randomDS_getSessionPubKeyHash() returns(bytes32);
21 }
22 contract OraclizeAddrResolverI {
23     function getAddress() returns (address _addr);
24 }
25 contract usingOraclize {
26     uint constant day = 60*60*24;
27     uint constant week = 60*60*24*7;
28     uint constant month = 60*60*24*30;
29     byte constant proofType_NONE = 0x00;
30     byte constant proofType_TLSNotary = 0x10;
31     byte constant proofType_Android = 0x20;
32     byte constant proofType_Ledger = 0x30;
33     byte constant proofType_Native = 0xF0;
34     byte constant proofStorage_IPFS = 0x01;
35     uint8 constant networkID_auto = 0;
36     uint8 constant networkID_mainnet = 1;
37     uint8 constant networkID_testnet = 2;
38     uint8 constant networkID_morden = 2;
39     uint8 constant networkID_consensys = 161;
40 
41     OraclizeAddrResolverI OAR;
42 
43     OraclizeI oraclize;
44     modifier oraclizeAPI {
45         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
46             oraclize_setNetwork(networkID_auto);
47 
48         if(address(oraclize) != OAR.getAddress())
49             oraclize = OraclizeI(OAR.getAddress());
50 
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
837     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
838         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
839         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
840         
841         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
842         if (proofVerified == false) return 2;
843         
844         return 0;
845     }
846     
847     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
848         bool match_ = true;
849         
850         for (var i=0; i<prefix.length; i++){
851             if (content[i] != prefix[i]) match_ = false;
852         }
853         
854         return match_;
855     }
856 
857     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
858         bool checkok;
859         
860         
861         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
862         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
863         bytes memory keyhash = new bytes(32);
864         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
865         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
866         if (checkok == false) return false;
867         
868         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
869         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
870         
871         
872         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
873         checkok = matchBytes32Prefix(sha256(sig1), result);
874         if (checkok == false) return false;
875         
876         
877         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
878         // This is to verify that the computed args match with the ones specified in the query.
879         bytes memory commitmentSlice1 = new bytes(8+1+32);
880         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
881         
882         bytes memory sessionPubkey = new bytes(64);
883         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
884         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
885         
886         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
887         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
888             delete oraclize_randomDS_args[queryId];
889         } else return false;
890         
891         
892         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
893         bytes memory tosign1 = new bytes(32+8+1+32);
894         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
895         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
896         if (checkok == false) return false;
897         
898         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
899         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
900             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
901         }
902         
903         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
904     }
905 
906     
907     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
908     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
909         uint minLength = length + toOffset;
910 
911         if (to.length < minLength) {
912             // Buffer too small
913             throw; // Should be a better way?
914         }
915 
916         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
917         uint i = 32 + fromOffset;
918         uint j = 32 + toOffset;
919 
920         while (i < (32 + fromOffset + length)) {
921             assembly {
922                 let tmp := mload(add(from, i))
923                 mstore(add(to, j), tmp)
924             }
925             i += 32;
926             j += 32;
927         }
928 
929         return to;
930     }
931     
932     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
933     // Duplicate Solidity's ecrecover, but catching the CALL return value
934     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
935         // We do our own memory management here. Solidity uses memory offset
936         // 0x40 to store the current end of memory. We write past it (as
937         // writes are memory extensions), but don't update the offset so
938         // Solidity will reuse it. The memory used here is only needed for
939         // this context.
940 
941         // FIXME: inline assembly can't access return values
942         bool ret;
943         address addr;
944 
945         assembly {
946             let size := mload(0x40)
947             mstore(size, hash)
948             mstore(add(size, 32), v)
949             mstore(add(size, 64), r)
950             mstore(add(size, 96), s)
951 
952             // NOTE: we can reuse the request memory because we deal with
953             //       the return code
954             ret := call(3000, 1, 0, size, 128, size, 32)
955             addr := mload(size)
956         }
957   
958         return (ret, addr);
959     }
960 
961     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
962     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
963         bytes32 r;
964         bytes32 s;
965         uint8 v;
966 
967         if (sig.length != 65)
968           return (false, 0);
969 
970         // The signature format is a compact form of:
971         //   {bytes32 r}{bytes32 s}{uint8 v}
972         // Compact means, uint8 is not padded to 32 bytes.
973         assembly {
974             r := mload(add(sig, 32))
975             s := mload(add(sig, 64))
976 
977             // Here we are loading the last 32 bytes. We exploit the fact that
978             // 'mload' will pad with zeroes if we overread.
979             // There is no 'mload8' to do this, but that would be nicer.
980             v := byte(0, mload(add(sig, 96)))
981 
982             // Alternative solution:
983             // 'byte' is not working due to the Solidity parser, so lets
984             // use the second best option, 'and'
985             // v := and(mload(add(sig, 65)), 255)
986         }
987 
988         // albeit non-transactional signatures are not specified by the YP, one would expect it
989         // to match the YP range of [27, 28]
990         //
991         // geth uses [0, 1] and some clients have followed. This might change, see:
992         //  https://github.com/ethereum/go-ethereum/issues/2053
993         if (v < 27)
994           v += 27;
995 
996         if (v != 27 && v != 28)
997             return (false, 0);
998 
999         return safer_ecrecover(hash, v, r, s);
1000     }
1001         
1002 }
1003 // </ORACLIZE_API>
1004 
1005 /*
1006  * @title String & slice utility library for Solidity contracts.
1007  * @author Nick Johnson <arachnid@notdot.net>
1008  *
1009  * @dev Functionality in this library is largely implemented using an
1010  *      abstraction called a 'slice'. A slice represents a part of a string -
1011  *      anything from the entire string to a single character, or even no
1012  *      characters at all (a 0-length slice). Since a slice only has to specify
1013  *      an offset and a length, copying and manipulating slices is a lot less
1014  *      expensive than copying and manipulating the strings they reference.
1015  *
1016  *      To further reduce gas costs, most functions on slice that need to return
1017  *      a slice modify the original one instead of allocating a new one; for
1018  *      instance, `s.split(".")` will return the text up to the first '.',
1019  *      modifying s to only contain the remainder of the string after the '.'.
1020  *      In situations where you do not want to modify the original slice, you
1021  *      can make a copy first with `.copy()`, for example:
1022  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1023  *      Solidity has no memory management, it will result in allocating many
1024  *      short-lived slices that are later discarded.
1025  *
1026  *      Functions that return two slices come in two versions: a non-allocating
1027  *      version that takes the second slice as an argument, modifying it in
1028  *      place, and an allocating version that allocates and returns the second
1029  *      slice; see `nextRune` for example.
1030  *
1031  *      Functions that have to copy string data will return strings rather than
1032  *      slices; these can be cast back to slices for further processing if
1033  *      required.
1034  *
1035  *      For convenience, some functions are provided with non-modifying
1036  *      variants that create a new slice and return both; for instance,
1037  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1038  *      corresponding to the left and right parts of the string.
1039  */
1040 library strings {
1041     struct slice {
1042         uint _len;
1043         uint _ptr;
1044     }
1045 
1046     function memcpy(uint dest, uint src, uint len) private {
1047         // Copy word-length chunks while possible
1048         for(; len >= 32; len -= 32) {
1049             assembly {
1050                 mstore(dest, mload(src))
1051             }
1052             dest += 32;
1053             src += 32;
1054         }
1055 
1056         // Copy remaining bytes
1057         uint mask = 256 ** (32 - len) - 1;
1058         assembly {
1059             let srcpart := and(mload(src), not(mask))
1060             let destpart := and(mload(dest), mask)
1061             mstore(dest, or(destpart, srcpart))
1062         }
1063     }
1064 
1065     /*
1066      * @dev Returns a slice containing the entire string.
1067      * @param self The string to make a slice from.
1068      * @return A newly allocated slice containing the entire string.
1069      */
1070     function toSlice(string self) internal returns (slice) {
1071         uint ptr;
1072         assembly {
1073             ptr := add(self, 0x20)
1074         }
1075         return slice(bytes(self).length, ptr);
1076     }
1077 
1078     /*
1079      * @dev Returns the length of a null-terminated bytes32 string.
1080      * @param self The value to find the length of.
1081      * @return The length of the string, from 0 to 32.
1082      */
1083     function len(bytes32 self) internal returns (uint) {
1084         uint ret;
1085         if (self == 0)
1086             return 0;
1087         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1088             ret += 16;
1089             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1090         }
1091         if (self & 0xffffffffffffffff == 0) {
1092             ret += 8;
1093             self = bytes32(uint(self) / 0x10000000000000000);
1094         }
1095         if (self & 0xffffffff == 0) {
1096             ret += 4;
1097             self = bytes32(uint(self) / 0x100000000);
1098         }
1099         if (self & 0xffff == 0) {
1100             ret += 2;
1101             self = bytes32(uint(self) / 0x10000);
1102         }
1103         if (self & 0xff == 0) {
1104             ret += 1;
1105         }
1106         return 32 - ret;
1107     }
1108 
1109     /*
1110      * @dev Returns a slice containing the entire bytes32, interpreted as a
1111      *      null-termintaed utf-8 string.
1112      * @param self The bytes32 value to convert to a slice.
1113      * @return A new slice containing the value of the input argument up to the
1114      *         first null.
1115      */
1116     function toSliceB32(bytes32 self) internal returns (slice ret) {
1117         // Allocate space for `self` in memory, copy it there, and point ret at it
1118         assembly {
1119             let ptr := mload(0x40)
1120             mstore(0x40, add(ptr, 0x20))
1121             mstore(ptr, self)
1122             mstore(add(ret, 0x20), ptr)
1123         }
1124         ret._len = len(self);
1125     }
1126 
1127     /*
1128      * @dev Returns a new slice containing the same data as the current slice.
1129      * @param self The slice to copy.
1130      * @return A new slice containing the same data as `self`.
1131      */
1132     function copy(slice self) internal returns (slice) {
1133         return slice(self._len, self._ptr);
1134     }
1135 
1136     /*
1137      * @dev Copies a slice to a new string.
1138      * @param self The slice to copy.
1139      * @return A newly allocated string containing the slice's text.
1140      */
1141     function toString(slice self) internal returns (string) {
1142         var ret = new string(self._len);
1143         uint retptr;
1144         assembly { retptr := add(ret, 32) }
1145 
1146         memcpy(retptr, self._ptr, self._len);
1147         return ret;
1148     }
1149 
1150     /*
1151      * @dev Returns the length in runes of the slice. Note that this operation
1152      *      takes time proportional to the length of the slice; avoid using it
1153      *      in loops, and call `slice.empty()` if you only need to know whether
1154      *      the slice is empty or not.
1155      * @param self The slice to operate on.
1156      * @return The length of the slice in runes.
1157      */
1158     function len(slice self) internal returns (uint) {
1159         // Starting at ptr-31 means the LSB will be the byte we care about
1160         var ptr = self._ptr - 31;
1161         var end = ptr + self._len;
1162         for (uint len = 0; ptr < end; len++) {
1163             uint8 b;
1164             assembly { b := and(mload(ptr), 0xFF) }
1165             if (b < 0x80) {
1166                 ptr += 1;
1167             } else if(b < 0xE0) {
1168                 ptr += 2;
1169             } else if(b < 0xF0) {
1170                 ptr += 3;
1171             } else if(b < 0xF8) {
1172                 ptr += 4;
1173             } else if(b < 0xFC) {
1174                 ptr += 5;
1175             } else {
1176                 ptr += 6;
1177             }
1178         }
1179         return len;
1180     }
1181 
1182     /*
1183      * @dev Returns true if the slice is empty (has a length of 0).
1184      * @param self The slice to operate on.
1185      * @return True if the slice is empty, False otherwise.
1186      */
1187     function empty(slice self) internal returns (bool) {
1188         return self._len == 0;
1189     }
1190 
1191     /*
1192      * @dev Returns a positive number if `other` comes lexicographically after
1193      *      `self`, a negative number if it comes before, or zero if the
1194      *      contents of the two slices are equal. Comparison is done per-rune,
1195      *      on unicode codepoints.
1196      * @param self The first slice to compare.
1197      * @param other The second slice to compare.
1198      * @return The result of the comparison.
1199      */
1200     function compare(slice self, slice other) internal returns (int) {
1201         uint shortest = self._len;
1202         if (other._len < self._len)
1203             shortest = other._len;
1204 
1205         var selfptr = self._ptr;
1206         var otherptr = other._ptr;
1207         for (uint idx = 0; idx < shortest; idx += 32) {
1208             uint a;
1209             uint b;
1210             assembly {
1211                 a := mload(selfptr)
1212                 b := mload(otherptr)
1213             }
1214             if (a != b) {
1215                 // Mask out irrelevant bytes and check again
1216                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1217                 var diff = (a & mask) - (b & mask);
1218                 if (diff != 0)
1219                     return int(diff);
1220             }
1221             selfptr += 32;
1222             otherptr += 32;
1223         }
1224         return int(self._len) - int(other._len);
1225     }
1226 
1227     /*
1228      * @dev Returns true if the two slices contain the same text.
1229      * @param self The first slice to compare.
1230      * @param self The second slice to compare.
1231      * @return True if the slices are equal, false otherwise.
1232      */
1233     function equals(slice self, slice other) internal returns (bool) {
1234         return compare(self, other) == 0;
1235     }
1236 
1237     /*
1238      * @dev Extracts the first rune in the slice into `rune`, advancing the
1239      *      slice to point to the next rune and returning `self`.
1240      * @param self The slice to operate on.
1241      * @param rune The slice that will contain the first rune.
1242      * @return `rune`.
1243      */
1244     function nextRune(slice self, slice rune) internal returns (slice) {
1245         rune._ptr = self._ptr;
1246 
1247         if (self._len == 0) {
1248             rune._len = 0;
1249             return rune;
1250         }
1251 
1252         uint len;
1253         uint b;
1254         // Load the first byte of the rune into the LSBs of b
1255         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1256         if (b < 0x80) {
1257             len = 1;
1258         } else if(b < 0xE0) {
1259             len = 2;
1260         } else if(b < 0xF0) {
1261             len = 3;
1262         } else {
1263             len = 4;
1264         }
1265 
1266         // Check for truncated codepoints
1267         if (len > self._len) {
1268             rune._len = self._len;
1269             self._ptr += self._len;
1270             self._len = 0;
1271             return rune;
1272         }
1273 
1274         self._ptr += len;
1275         self._len -= len;
1276         rune._len = len;
1277         return rune;
1278     }
1279 
1280     /*
1281      * @dev Returns the first rune in the slice, advancing the slice to point
1282      *      to the next rune.
1283      * @param self The slice to operate on.
1284      * @return A slice containing only the first rune from `self`.
1285      */
1286     function nextRune(slice self) internal returns (slice ret) {
1287         nextRune(self, ret);
1288     }
1289 
1290     /*
1291      * @dev Returns the number of the first codepoint in the slice.
1292      * @param self The slice to operate on.
1293      * @return The number of the first codepoint in the slice.
1294      */
1295     function ord(slice self) internal returns (uint ret) {
1296         if (self._len == 0) {
1297             return 0;
1298         }
1299 
1300         uint word;
1301         uint len;
1302         uint div = 2 ** 248;
1303 
1304         // Load the rune into the MSBs of b
1305         assembly { word:= mload(mload(add(self, 32))) }
1306         var b = word / div;
1307         if (b < 0x80) {
1308             ret = b;
1309             len = 1;
1310         } else if(b < 0xE0) {
1311             ret = b & 0x1F;
1312             len = 2;
1313         } else if(b < 0xF0) {
1314             ret = b & 0x0F;
1315             len = 3;
1316         } else {
1317             ret = b & 0x07;
1318             len = 4;
1319         }
1320 
1321         // Check for truncated codepoints
1322         if (len > self._len) {
1323             return 0;
1324         }
1325 
1326         for (uint i = 1; i < len; i++) {
1327             div = div / 256;
1328             b = (word / div) & 0xFF;
1329             if (b & 0xC0 != 0x80) {
1330                 // Invalid UTF-8 sequence
1331                 return 0;
1332             }
1333             ret = (ret * 64) | (b & 0x3F);
1334         }
1335 
1336         return ret;
1337     }
1338 
1339     /*
1340      * @dev Returns the keccak-256 hash of the slice.
1341      * @param self The slice to hash.
1342      * @return The hash of the slice.
1343      */
1344     function keccak(slice self) internal returns (bytes32 ret) {
1345         assembly {
1346             ret := sha3(mload(add(self, 32)), mload(self))
1347         }
1348     }
1349 
1350     /*
1351      * @dev Returns true if `self` starts with `needle`.
1352      * @param self The slice to operate on.
1353      * @param needle The slice to search for.
1354      * @return True if the slice starts with the provided text, false otherwise.
1355      */
1356     function startsWith(slice self, slice needle) internal returns (bool) {
1357         if (self._len < needle._len) {
1358             return false;
1359         }
1360 
1361         if (self._ptr == needle._ptr) {
1362             return true;
1363         }
1364 
1365         bool equal;
1366         assembly {
1367             let len := mload(needle)
1368             let selfptr := mload(add(self, 0x20))
1369             let needleptr := mload(add(needle, 0x20))
1370             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1371         }
1372         return equal;
1373     }
1374 
1375     /*
1376      * @dev If `self` starts with `needle`, `needle` is removed from the
1377      *      beginning of `self`. Otherwise, `self` is unmodified.
1378      * @param self The slice to operate on.
1379      * @param needle The slice to search for.
1380      * @return `self`
1381      */
1382     function beyond(slice self, slice needle) internal returns (slice) {
1383         if (self._len < needle._len) {
1384             return self;
1385         }
1386 
1387         bool equal = true;
1388         if (self._ptr != needle._ptr) {
1389             assembly {
1390                 let len := mload(needle)
1391                 let selfptr := mload(add(self, 0x20))
1392                 let needleptr := mload(add(needle, 0x20))
1393                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1394             }
1395         }
1396 
1397         if (equal) {
1398             self._len -= needle._len;
1399             self._ptr += needle._len;
1400         }
1401 
1402         return self;
1403     }
1404 
1405     /*
1406      * @dev Returns true if the slice ends with `needle`.
1407      * @param self The slice to operate on.
1408      * @param needle The slice to search for.
1409      * @return True if the slice starts with the provided text, false otherwise.
1410      */
1411     function endsWith(slice self, slice needle) internal returns (bool) {
1412         if (self._len < needle._len) {
1413             return false;
1414         }
1415 
1416         var selfptr = self._ptr + self._len - needle._len;
1417 
1418         if (selfptr == needle._ptr) {
1419             return true;
1420         }
1421 
1422         bool equal;
1423         assembly {
1424             let len := mload(needle)
1425             let needleptr := mload(add(needle, 0x20))
1426             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1427         }
1428 
1429         return equal;
1430     }
1431 
1432     /*
1433      * @dev If `self` ends with `needle`, `needle` is removed from the
1434      *      end of `self`. Otherwise, `self` is unmodified.
1435      * @param self The slice to operate on.
1436      * @param needle The slice to search for.
1437      * @return `self`
1438      */
1439     function until(slice self, slice needle) internal returns (slice) {
1440         if (self._len < needle._len) {
1441             return self;
1442         }
1443 
1444         var selfptr = self._ptr + self._len - needle._len;
1445         bool equal = true;
1446         if (selfptr != needle._ptr) {
1447             assembly {
1448                 let len := mload(needle)
1449                 let needleptr := mload(add(needle, 0x20))
1450                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1451             }
1452         }
1453 
1454         if (equal) {
1455             self._len -= needle._len;
1456         }
1457 
1458         return self;
1459     }
1460 
1461     // Returns the memory address of the first byte of the first occurrence of
1462     // `needle` in `self`, or the first byte after `self` if not found.
1463     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1464         uint ptr;
1465         uint idx;
1466 
1467         if (needlelen <= selflen) {
1468             if (needlelen <= 32) {
1469                 // Optimized assembly for 68 gas per byte on short strings
1470                 assembly {
1471                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1472                     let needledata := and(mload(needleptr), mask)
1473                     let end := add(selfptr, sub(selflen, needlelen))
1474                     ptr := selfptr
1475                     loop:
1476                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1477                     ptr := add(ptr, 1)
1478                     jumpi(loop, lt(sub(ptr, 1), end))
1479                     ptr := add(selfptr, selflen)
1480                     exit:
1481                 }
1482                 return ptr;
1483             } else {
1484                 // For long needles, use hashing
1485                 bytes32 hash;
1486                 assembly { hash := sha3(needleptr, needlelen) }
1487                 ptr = selfptr;
1488                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1489                     bytes32 testHash;
1490                     assembly { testHash := sha3(ptr, needlelen) }
1491                     if (hash == testHash)
1492                         return ptr;
1493                     ptr += 1;
1494                 }
1495             }
1496         }
1497         return selfptr + selflen;
1498     }
1499 
1500     // Returns the memory address of the first byte after the last occurrence of
1501     // `needle` in `self`, or the address of `self` if not found.
1502     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1503         uint ptr;
1504 
1505         if (needlelen <= selflen) {
1506             if (needlelen <= 32) {
1507                 // Optimized assembly for 69 gas per byte on short strings
1508                 assembly {
1509                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1510                     let needledata := and(mload(needleptr), mask)
1511                     ptr := add(selfptr, sub(selflen, needlelen))
1512                     loop:
1513                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1514                     ptr := sub(ptr, 1)
1515                     jumpi(loop, gt(add(ptr, 1), selfptr))
1516                     ptr := selfptr
1517                     jump(exit)
1518                     ret:
1519                     ptr := add(ptr, needlelen)
1520                     exit:
1521                 }
1522                 return ptr;
1523             } else {
1524                 // For long needles, use hashing
1525                 bytes32 hash;
1526                 assembly { hash := sha3(needleptr, needlelen) }
1527                 ptr = selfptr + (selflen - needlelen);
1528                 while (ptr >= selfptr) {
1529                     bytes32 testHash;
1530                     assembly { testHash := sha3(ptr, needlelen) }
1531                     if (hash == testHash)
1532                         return ptr + needlelen;
1533                     ptr -= 1;
1534                 }
1535             }
1536         }
1537         return selfptr;
1538     }
1539 
1540     /*
1541      * @dev Modifies `self` to contain everything from the first occurrence of
1542      *      `needle` to the end of the slice. `self` is set to the empty slice
1543      *      if `needle` is not found.
1544      * @param self The slice to search and modify.
1545      * @param needle The text to search for.
1546      * @return `self`.
1547      */
1548     function find(slice self, slice needle) internal returns (slice) {
1549         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1550         self._len -= ptr - self._ptr;
1551         self._ptr = ptr;
1552         return self;
1553     }
1554 
1555     /*
1556      * @dev Modifies `self` to contain the part of the string from the start of
1557      *      `self` to the end of the first occurrence of `needle`. If `needle`
1558      *      is not found, `self` is set to the empty slice.
1559      * @param self The slice to search and modify.
1560      * @param needle The text to search for.
1561      * @return `self`.
1562      */
1563     function rfind(slice self, slice needle) internal returns (slice) {
1564         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1565         self._len = ptr - self._ptr;
1566         return self;
1567     }
1568 
1569     /*
1570      * @dev Splits the slice, setting `self` to everything after the first
1571      *      occurrence of `needle`, and `token` to everything before it. If
1572      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1573      *      and `token` is set to the entirety of `self`.
1574      * @param self The slice to split.
1575      * @param needle The text to search for in `self`.
1576      * @param token An output parameter to which the first token is written.
1577      * @return `token`.
1578      */
1579     function split(slice self, slice needle, slice token) internal returns (slice) {
1580         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1581         token._ptr = self._ptr;
1582         token._len = ptr - self._ptr;
1583         if (ptr == self._ptr + self._len) {
1584             // Not found
1585             self._len = 0;
1586         } else {
1587             self._len -= token._len + needle._len;
1588             self._ptr = ptr + needle._len;
1589         }
1590         return token;
1591     }
1592 
1593     /*
1594      * @dev Splits the slice, setting `self` to everything after the first
1595      *      occurrence of `needle`, and returning everything before it. If
1596      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1597      *      and the entirety of `self` is returned.
1598      * @param self The slice to split.
1599      * @param needle The text to search for in `self`.
1600      * @return The part of `self` up to the first occurrence of `delim`.
1601      */
1602     function split(slice self, slice needle) internal returns (slice token) {
1603         split(self, needle, token);
1604     }
1605 
1606     /*
1607      * @dev Splits the slice, setting `self` to everything before the last
1608      *      occurrence of `needle`, and `token` to everything after it. If
1609      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1610      *      and `token` is set to the entirety of `self`.
1611      * @param self The slice to split.
1612      * @param needle The text to search for in `self`.
1613      * @param token An output parameter to which the first token is written.
1614      * @return `token`.
1615      */
1616     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1617         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1618         token._ptr = ptr;
1619         token._len = self._len - (ptr - self._ptr);
1620         if (ptr == self._ptr) {
1621             // Not found
1622             self._len = 0;
1623         } else {
1624             self._len -= token._len + needle._len;
1625         }
1626         return token;
1627     }
1628 
1629     /*
1630      * @dev Splits the slice, setting `self` to everything before the last
1631      *      occurrence of `needle`, and returning everything after it. If
1632      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1633      *      and the entirety of `self` is returned.
1634      * @param self The slice to split.
1635      * @param needle The text to search for in `self`.
1636      * @return The part of `self` after the last occurrence of `delim`.
1637      */
1638     function rsplit(slice self, slice needle) internal returns (slice token) {
1639         rsplit(self, needle, token);
1640     }
1641 
1642     /*
1643      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1644      * @param self The slice to search.
1645      * @param needle The text to search for in `self`.
1646      * @return The number of occurrences of `needle` found in `self`.
1647      */
1648     function count(slice self, slice needle) internal returns (uint count) {
1649         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1650         while (ptr <= self._ptr + self._len) {
1651             count++;
1652             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1653         }
1654     }
1655 
1656     /*
1657      * @dev Returns True if `self` contains `needle`.
1658      * @param self The slice to search.
1659      * @param needle The text to search for in `self`.
1660      * @return True if `needle` is found in `self`, false otherwise.
1661      */
1662     function contains(slice self, slice needle) internal returns (bool) {
1663         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1664     }
1665 
1666     /*
1667      * @dev Returns a newly allocated string containing the concatenation of
1668      *      `self` and `other`.
1669      * @param self The first slice to concatenate.
1670      * @param other The second slice to concatenate.
1671      * @return The concatenation of the two strings.
1672      */
1673     function concat(slice self, slice other) internal returns (string) {
1674         var ret = new string(self._len + other._len);
1675         uint retptr;
1676         assembly { retptr := add(ret, 32) }
1677         memcpy(retptr, self._ptr, self._len);
1678         memcpy(retptr + self._len, other._ptr, other._len);
1679         return ret;
1680     }
1681 
1682     /*
1683      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1684      *      newly allocated string.
1685      * @param self The delimiter to use.
1686      * @param parts A list of slices to join.
1687      * @return A newly allocated string containing all the slices in `parts`,
1688      *         joined with `self`.
1689      */
1690     function join(slice self, slice[] parts) internal returns (string) {
1691         if (parts.length == 0)
1692             return "";
1693 
1694         uint len = self._len * (parts.length - 1);
1695         for(uint i = 0; i < parts.length; i++)
1696             len += parts[i]._len;
1697 
1698         var ret = new string(len);
1699         uint retptr;
1700         assembly { retptr := add(ret, 32) }
1701 
1702         for(i = 0; i < parts.length; i++) {
1703             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1704             retptr += parts[i]._len;
1705             if (i < parts.length - 1) {
1706                 memcpy(retptr, self._ptr, self._len);
1707                 retptr += self._len;
1708             }
1709         }
1710 
1711         return ret;
1712     }
1713 }
1714 
1715 
1716 contract DSSafeAddSub {
1717     function safeToAdd(uint a, uint b) internal returns (bool) {
1718         return (a + b >= a);
1719     }
1720     function safeAdd(uint a, uint b) internal returns (uint) {
1721         if (!safeToAdd(a, b)) throw;
1722         return a + b;
1723     }
1724 
1725     function safeToSubtract(uint a, uint b) internal returns (bool) {
1726         return (b <= a);
1727     }
1728 
1729     function safeSub(uint a, uint b) internal returns (uint) {
1730         if (!safeToSubtract(a, b)) throw;
1731         return a - b;
1732     } 
1733 }
1734 
1735 
1736 
1737 contract Xdice is usingOraclize, DSSafeAddSub {
1738     
1739      using strings for *;
1740 
1741     /*
1742      * checks player profit, bet size and player number is within range
1743     */
1744     modifier betIsValid(uint _betSize, uint _playerNumber) {      
1745         if(((((_betSize * (100-(safeSub(_playerNumber,1)))) / (safeSub(_playerNumber,1))+_betSize))*houseEdge/houseEdgeDivisor)-_betSize > maxProfit || _betSize < minBet || _playerNumber < minNumber || _playerNumber > maxNumber) throw;        
1746 		_;
1747     }
1748 
1749     /*
1750      * checks game is currently active
1751     */
1752     modifier gameIsActive {
1753         if(gamePaused == true) throw;
1754 		_;
1755     }    
1756 
1757     /*
1758      * checks payouts are currently active
1759     */
1760     modifier payoutsAreActive {
1761         if(payoutsPaused == true) throw;
1762 		_;
1763     }    
1764 
1765     /*
1766      * checks only Oraclize address is calling
1767     */
1768     modifier onlyOraclize {
1769         if (msg.sender != oraclize_cbAddress()) throw;
1770         _;
1771     }
1772 
1773     /*
1774      * checks only owner address is calling
1775     */
1776     modifier onlyOwner {
1777          if (msg.sender != owner) throw;
1778          _;
1779     }
1780 
1781     /*
1782      * checks only treasury address is calling
1783     */
1784     modifier onlyTreasury {
1785          if (msg.sender != treasury) throw;
1786          _;
1787     }    
1788 
1789     /*
1790      * game vars
1791     */ 
1792     uint constant public maxProfitDivisor = 1000000;
1793     uint constant public houseEdgeDivisor = 1000;    
1794     uint constant public maxNumber = 99; 
1795     uint constant public minNumber = 2;
1796 	bool public gamePaused;
1797     uint32 public gasForOraclize;
1798     address public owner;
1799     bool public payoutsPaused; 
1800     address public treasury;
1801     uint public contractBalance;
1802     uint public houseEdge;     
1803     uint public maxProfit;   
1804     uint public maxProfitAsPercentOfHouse;                    
1805     uint public minBet; 
1806     //init discontinued contract data   
1807     uint public totalBets = 0;
1808     uint public maxPendingPayouts;
1809     //init discontinued contract data 
1810     uint public totalWeiWon = 0;
1811     //init discontinued contract data    
1812     uint public totalWeiWagered = 0; 
1813     //init discontinued contract data        
1814     uint public randomQueryID = 2;
1815     
1816 
1817     /*
1818      * player vars
1819     */
1820     mapping (bytes32 => address) playerAddress;
1821     mapping (bytes32 => address) playerTempAddress;
1822     mapping (bytes32 => bytes32) playerBetId;
1823     mapping (bytes32 => uint) playerBetValue;
1824     mapping (bytes32 => uint) playerTempBetValue;               
1825     mapping (bytes32 => uint) playerDieResult;
1826     mapping (bytes32 => uint) playerNumber;
1827     mapping (address => uint) playerPendingWithdrawals;      
1828     mapping (bytes32 => uint) playerProfit;
1829     mapping (bytes32 => uint) playerTempReward;           
1830 
1831     /*
1832      * events
1833     */
1834     /* log bets + output to web3 for precise 'payout on win' field in UI */
1835     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RewardValue, uint ProfitValue, uint BetValue, uint PlayerNumber, uint RandomQueryID);      
1836     /* output to web3 UI on bet result*/
1837     /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
1838 	event LogResult(uint indexed ResultSerialNumber, bytes32 indexed BetID, address indexed PlayerAddress, uint PlayerNumber, uint DiceResult, uint Value, int Status, bytes Proof);   
1839     /* log manual refunds */
1840     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
1841     /* log owner transfers */
1842     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);               
1843 
1844 
1845     /*
1846      * init
1847     */
1848     function Xdice() {
1849 
1850         owner = msg.sender;
1851         treasury = msg.sender;
1852         oraclize_setNetwork(networkID_auto);        
1853         /* use TLSNotary for oraclize call */
1854         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1855         /* init 990 = 99% (1% houseEdge)*/
1856         ownerSetHouseEdge(990);
1857         /* init 10,000 = 1%  */
1858         ownerSetMaxProfitAsPercentOfHouse(10000);
1859         /* init min bet (0.1 ether) */
1860         ownerSetMinBet(100000000000000000);        
1861         /* init gas for oraclize */        
1862         gasForOraclize = 235000;  
1863         /* init gas price for callback (default 20 gwei)*/
1864         oraclize_setCustomGasPrice(20000000000 wei);              
1865 
1866     }
1867 
1868     /*
1869      * public function
1870      * player submit bet
1871      * only if game is active & bet is valid can query oraclize and set player vars     
1872     */
1873     function playerRollDice(uint rollUnder) public 
1874         payable
1875         gameIsActive
1876         betIsValid(msg.value, rollUnder)
1877 	{       
1878 
1879         /*
1880         * assign partially encrypted query to oraclize
1881         * only the apiKey is encrypted 
1882         * integer query is in plain text
1883         */       
1884         randomQueryID += 1;
1885         string memory queryString1 = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BBMyVwxtiTy5oKVkRGwW2Yc094lpQyT74AdenJ1jywmN4rNyxXqidtDsDBPlASVWPJ0t8SwjSYjJvHAGS83Si8sYCxNH0y2kl/Vw5CizdcgUax1NtTdFs1MXXdvLYgkFq3h8b2qV2oEvxVFqL7v28lcGzOuy5Ms=},\"n\":1,\"min\":1,\"max\":100,\"replacement\":true,\"base\":10${[identity] \"}\"},\"id\":";
1886         string memory queryString2 = uint2str(randomQueryID);
1887         string memory queryString3 = "${[identity] \"}\"}']";
1888 
1889         string memory queryString1_2 = queryString1.toSlice().concat(queryString2.toSlice());
1890 
1891         string memory queryString1_2_3 = queryString1_2.toSlice().concat(queryString3.toSlice());
1892 
1893         bytes32 rngId = oraclize_query("nested", queryString1_2_3, gasForOraclize);   
1894                  
1895         /* map bet id to this oraclize query */
1896 		playerBetId[rngId] = rngId;
1897         /* map player lucky number to this oraclize query */
1898 		playerNumber[rngId] = rollUnder;
1899         /* map value of wager to this oraclize query */
1900         playerBetValue[rngId] = msg.value;
1901         /* map player address to this oraclize query */
1902         playerAddress[rngId] = msg.sender;
1903         /* safely map player profit to this oraclize query */                     
1904         playerProfit[rngId] = ((((msg.value * (100-(safeSub(rollUnder,1)))) / (safeSub(rollUnder,1))+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;        
1905         /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
1906         maxPendingPayouts = safeAdd(maxPendingPayouts, playerProfit[rngId]);
1907         /* check contract can payout on win */
1908         if(maxPendingPayouts >= contractBalance) throw;
1909         /* provides accurate numbers for web3 and allows for manual refunds in case of no oraclize __callback */
1910         LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId], randomQueryID);          
1911 
1912     }   
1913              
1914 
1915     /*
1916     * semi-public function - only oraclize can call
1917     */
1918     /*TLSNotary for oraclize call */
1919 	function __callback(bytes32 myid, string result, bytes proof) public   
1920 		onlyOraclize
1921 		payoutsAreActive
1922 	{  
1923 
1924         /* player address mapped to query id does not exist */
1925         if (playerAddress[myid]==0x0) throw;
1926         
1927         /* keep oraclize honest by retrieving the serialNumber from random.org result */
1928         var sl_result = result.toSlice();        
1929         uint serialNumberOfResult = parseInt(sl_result.split(', '.toSlice()).toString());          
1930 
1931 	    /* map random result to player */
1932         playerDieResult[myid] = parseInt(sl_result.beyond("[".toSlice()).until("]".toSlice()).toString());        
1933         
1934         /* get the playerAddress for this query id */
1935         playerTempAddress[myid] = playerAddress[myid];
1936         /* delete playerAddress for this query id */
1937         delete playerAddress[myid];
1938 
1939         /* map the playerProfit for this query id */
1940         playerTempReward[myid] = playerProfit[myid];
1941         /* set  playerProfit for this query id to 0 */
1942         playerProfit[myid] = 0; 
1943 
1944         /* safely reduce maxPendingPayouts liability */
1945         maxPendingPayouts = safeSub(maxPendingPayouts, playerTempReward[myid]);         
1946 
1947         /* map the playerBetValue for this query id */
1948         playerTempBetValue[myid] = playerBetValue[myid];
1949         /* set  playerBetValue for this query id to 0 */
1950         playerBetValue[myid] = 0; 
1951 
1952         /* total number of bets */
1953         totalBets += 1;
1954 
1955         /* total wagered */
1956         totalWeiWagered += playerTempBetValue[myid];                                                           
1957 
1958         /*
1959         * refund
1960         * if result is 0 result is empty or no proof refund original bet value
1961         * if refund fails save refund value to playerPendingWithdrawals
1962         */
1963         if(playerDieResult[myid] == 0 || bytes(result).length == 0 || bytes(proof).length == 0){                                                     
1964 
1965              LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 3, proof);            
1966 
1967             /*
1968             * send refund - external call to an untrusted contract
1969             * if send fails map refund value to playerPendingWithdrawals[address]
1970             * for withdrawal later via playerWithdrawPendingTransactions
1971             */
1972             if(!playerTempAddress[myid].send(playerTempBetValue[myid])){
1973                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 4, proof);              
1974                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
1975                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempBetValue[myid]);                        
1976             }
1977 
1978             return;
1979         }
1980 
1981         /*
1982         * pay winner
1983         * update contract balance to calculate new max bet
1984         * send reward
1985         * if send of reward fails save value to playerPendingWithdrawals        
1986         */
1987         if(playerDieResult[myid] < playerNumber[myid]){ 
1988 
1989             /* safely reduce contract balance by player profit */
1990             contractBalance = safeSub(contractBalance, playerTempReward[myid]); 
1991 
1992             /* update total wei won */
1993             totalWeiWon = safeAdd(totalWeiWon, playerTempReward[myid]);              
1994 
1995             /* safely calculate payout via profit plus original wager */
1996             playerTempReward[myid] = safeAdd(playerTempReward[myid], playerTempBetValue[myid]); 
1997 
1998             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 1, proof);                            
1999 
2000             /* update maximum profit */
2001             setMaxProfit();
2002             
2003             /*
2004             * send win - external call to an untrusted contract
2005             * if send fails map reward value to playerPendingWithdrawals[address]
2006             * for withdrawal later via playerWithdrawPendingTransactions
2007             */
2008             if(!playerTempAddress[myid].send(playerTempReward[myid])){
2009                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 2, proof);                   
2010                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
2011                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempReward[myid]);                               
2012             }
2013 
2014             return;
2015 
2016         }
2017 
2018         /*
2019         * no win
2020         * send 1 wei to a losing bet
2021         * update contract balance to calculate new max bet
2022         */
2023         if(playerDieResult[myid] >= playerNumber[myid]){
2024 
2025             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 0, proof);                                
2026 
2027             /*  
2028             *  safe adjust contractBalance
2029             *  setMaxProfit
2030             *  send 1 wei to losing bet
2031             */
2032             contractBalance = safeAdd(contractBalance, (playerTempBetValue[myid]-1));                                                                         
2033 
2034             /* update maximum profit */
2035             setMaxProfit(); 
2036 
2037             /*
2038             * send 1 wei - external call to an untrusted contract                  
2039             */
2040             if(!playerTempAddress[myid].send(1)){
2041                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */                
2042                playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], 1);                                
2043             }                                   
2044 
2045             return;
2046 
2047         }
2048 
2049     }
2050     
2051     /*
2052     * public function
2053     * in case of a failed refund or win send
2054     */
2055     function playerWithdrawPendingTransactions() public 
2056         payoutsAreActive
2057         returns (bool)
2058      {
2059         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
2060         playerPendingWithdrawals[msg.sender] = 0;
2061         /* external call to untrusted contract */
2062         if (msg.sender.call.value(withdrawAmount)()) {
2063             return true;
2064         } else {
2065             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
2066             /* player can try to withdraw again later */
2067             playerPendingWithdrawals[msg.sender] = withdrawAmount;
2068             return false;
2069         }
2070     }
2071 
2072     /* check for pending withdrawals  */
2073     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
2074         return playerPendingWithdrawals[addressToCheck];
2075     }
2076 
2077     /*
2078     * internal function
2079     * sets max profit
2080     */
2081     function setMaxProfit() internal {
2082         maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxProfitDivisor;  
2083     }      
2084 
2085     /*
2086     * owner/treasury address only functions
2087     */
2088     function ()
2089         payable
2090         onlyTreasury
2091     {
2092         /* safely update contract balance */
2093         contractBalance = safeAdd(contractBalance, msg.value);        
2094         /* update the maximum profit */
2095         setMaxProfit();
2096     } 
2097 
2098     /* set gas price for oraclize callback */
2099     function ownerSetCallbackGasPrice(uint newCallbackGasPrice) public 
2100 		onlyOwner
2101 	{
2102         oraclize_setCustomGasPrice(newCallbackGasPrice);
2103     }     
2104 
2105     /* set gas limit for oraclize query */
2106     function ownerSetOraclizeSafeGas(uint32 newSafeGasToOraclize) public 
2107 		onlyOwner
2108 	{
2109     	gasForOraclize = newSafeGasToOraclize;
2110     }
2111 
2112     /* only owner adjust contract balance variable (only used for max profit calc) */
2113     function ownerUpdateContractBalance(uint newContractBalanceInWei) public 
2114 		onlyOwner
2115     {        
2116        contractBalance = newContractBalanceInWei;
2117     }    
2118 
2119     /* only owner address can set houseEdge */
2120     function ownerSetHouseEdge(uint newHouseEdge) public 
2121 		onlyOwner
2122     {
2123         houseEdge = newHouseEdge;
2124     }
2125 
2126     /* only owner address can set maxProfitAsPercentOfHouse */
2127     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public 
2128 		onlyOwner
2129     {
2130         /* restrict each bet to a maximum profit of 1% contractBalance */
2131         if(newMaxProfitAsPercent > 10000) throw;
2132         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
2133         setMaxProfit();
2134     }
2135 
2136     /* only owner address can set minBet */
2137     function ownerSetMinBet(uint newMinimumBet) public 
2138 		onlyOwner
2139     {
2140         minBet = newMinimumBet;
2141     }       
2142 
2143     /* only owner address can transfer ether */
2144     function ownerTransferEther(address sendTo, uint amount) public 
2145 		onlyOwner
2146     {        
2147         /* safely update contract balance when sending out funds*/
2148         contractBalance = safeSub(contractBalance, amount);		
2149         /* update max profit */
2150         setMaxProfit();
2151         if(!sendTo.send(amount)) throw;
2152         LogOwnerTransfer(sendTo, amount); 
2153     }
2154 
2155     /* only owner address can do manual refund
2156     * used only if bet placed + oraclize failed to __callback
2157     * filter LogBet by address and/or playerBetId:
2158     * LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
2159     * check the following logs do not exist for playerBetId and/or playerAddress[rngId] before refunding:
2160     * LogResult or LogRefund
2161     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions 
2162     */
2163     function ownerRefundPlayer(bytes32 originalPlayerBetId, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public 
2164 		onlyOwner
2165     {        
2166         /* safely reduce pendingPayouts by playerProfit[rngId] */
2167         maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
2168         /* send refund */
2169         if(!sendTo.send(originalPlayerBetValue)) throw;
2170         /* log refunds */
2171         LogRefund(originalPlayerBetId, sendTo, originalPlayerBetValue);        
2172     }    
2173 
2174     /* only owner address can set emergency pause #1 */
2175     function ownerPauseGame(bool newStatus) public 
2176 		onlyOwner
2177     {
2178 		gamePaused = newStatus;
2179     }
2180 
2181     /* only owner address can set emergency pause #2 */
2182     function ownerPausePayouts(bool newPayoutStatus) public 
2183 		onlyOwner
2184     {
2185 		payoutsPaused = newPayoutStatus;
2186     } 
2187 
2188     /* only owner address can set treasury address */
2189     function ownerSetTreasury(address newTreasury) public 
2190 		onlyOwner
2191 	{
2192         treasury = newTreasury;
2193     }         
2194 
2195     /* only owner address can set owner address */
2196     function ownerChangeOwner(address newOwner) public 
2197 		onlyOwner
2198 	{
2199         owner = newOwner;
2200     }
2201 
2202     /* only owner address can suicide - emergency */
2203     function ownerkill() public 
2204 		onlyOwner
2205 	{
2206 		suicide(owner);
2207 	}    
2208 
2209 
2210 }