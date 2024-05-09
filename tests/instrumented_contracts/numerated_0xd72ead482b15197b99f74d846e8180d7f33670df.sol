1 pragma solidity ^0.4.0;
2 
3 contract OraclizeI {
4     address public cbAddress;
5     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
6     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
7     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
8     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
9     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
10     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
11     function getPrice(string _datasource) returns (uint _dsprice);
12     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
13     function useCoupon(string _coupon);
14     function setProofType(byte _proofType);
15     function setConfig(bytes32 _config);
16     function setCustomGasPrice(uint _gasPrice);
17     function randomDS_getSessionPubKeyHash() returns(bytes32);
18 }
19 contract OraclizeAddrResolverI {
20     function getAddress() returns (address _addr);
21 }
22 contract usingOraclize {
23     uint constant day = 60*60*24;
24     uint constant week = 60*60*24*7;
25     uint constant month = 60*60*24*30;
26     byte constant proofType_NONE = 0x00;
27     byte constant proofType_TLSNotary = 0x10;
28     byte constant proofType_Android = 0x20;
29     byte constant proofType_Ledger = 0x30;
30     byte constant proofType_Native = 0xF0;
31     byte constant proofStorage_IPFS = 0x01;
32     uint8 constant networkID_auto = 0;
33     uint8 constant networkID_mainnet = 1;
34     uint8 constant networkID_testnet = 2;
35     uint8 constant networkID_morden = 2;
36     uint8 constant networkID_consensys = 161;
37 
38     OraclizeAddrResolverI OAR;
39 
40     OraclizeI oraclize;
41     modifier oraclizeAPI {
42         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
43         oraclize = OraclizeI(OAR.getAddress());
44         _;
45     }
46     modifier coupon(string code){
47         oraclize = OraclizeI(OAR.getAddress());
48         oraclize.useCoupon(code);
49         _;
50     }
51 
52     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
53         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
54             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
55             oraclize_setNetworkName("eth_mainnet");
56             return true;
57         }
58         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
59             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
60             oraclize_setNetworkName("eth_ropsten3");
61             return true;
62         }
63         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
64             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
65             oraclize_setNetworkName("eth_kovan");
66             return true;
67         }
68         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
69             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
70             oraclize_setNetworkName("eth_rinkeby");
71             return true;
72         }
73         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
74             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
75             return true;
76         }
77         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
78             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
79             return true;
80         }
81         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
82             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
83             return true;
84         }
85         return false;
86     }
87 
88     function __callback(bytes32 myid, string result) {
89         __callback(myid, result, new bytes(0));
90     }
91     function __callback(bytes32 myid, string result, bytes proof) {
92     }
93     
94     function oraclize_useCoupon(string code) oraclizeAPI internal {
95         oraclize.useCoupon(code);
96     }
97 
98     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
99         return oraclize.getPrice(datasource);
100     }
101 
102     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
103         return oraclize.getPrice(datasource, gaslimit);
104     }
105     
106     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
107         uint price = oraclize.getPrice(datasource);
108         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
109         return oraclize.query.value(price)(0, datasource, arg);
110     }
111     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
112         uint price = oraclize.getPrice(datasource);
113         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
114         return oraclize.query.value(price)(timestamp, datasource, arg);
115     }
116     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
117         uint price = oraclize.getPrice(datasource, gaslimit);
118         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
119         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
120     }
121     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
122         uint price = oraclize.getPrice(datasource, gaslimit);
123         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
124         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
125     }
126     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
127         uint price = oraclize.getPrice(datasource);
128         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
129         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
130     }
131     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
132         uint price = oraclize.getPrice(datasource);
133         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
134         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
135     }
136     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
137         uint price = oraclize.getPrice(datasource, gaslimit);
138         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
139         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
140     }
141     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
142         uint price = oraclize.getPrice(datasource, gaslimit);
143         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
144         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
145     }
146     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
147         uint price = oraclize.getPrice(datasource);
148         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
149         bytes memory args = stra2cbor(argN);
150         return oraclize.queryN.value(price)(0, datasource, args);
151     }
152     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
153         uint price = oraclize.getPrice(datasource);
154         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
155         bytes memory args = stra2cbor(argN);
156         return oraclize.queryN.value(price)(timestamp, datasource, args);
157     }
158     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
159         uint price = oraclize.getPrice(datasource, gaslimit);
160         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
161         bytes memory args = stra2cbor(argN);
162         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
163     }
164     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
165         uint price = oraclize.getPrice(datasource, gaslimit);
166         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
167         bytes memory args = stra2cbor(argN);
168         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
169     }
170     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
171         string[] memory dynargs = new string[](1);
172         dynargs[0] = args[0];
173         return oraclize_query(datasource, dynargs);
174     }
175     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
176         string[] memory dynargs = new string[](1);
177         dynargs[0] = args[0];
178         return oraclize_query(timestamp, datasource, dynargs);
179     }
180     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
181         string[] memory dynargs = new string[](1);
182         dynargs[0] = args[0];
183         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
184     }
185     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
186         string[] memory dynargs = new string[](1);
187         dynargs[0] = args[0];       
188         return oraclize_query(datasource, dynargs, gaslimit);
189     }
190     
191     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
192         string[] memory dynargs = new string[](2);
193         dynargs[0] = args[0];
194         dynargs[1] = args[1];
195         return oraclize_query(datasource, dynargs);
196     }
197     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
198         string[] memory dynargs = new string[](2);
199         dynargs[0] = args[0];
200         dynargs[1] = args[1];
201         return oraclize_query(timestamp, datasource, dynargs);
202     }
203     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
204         string[] memory dynargs = new string[](2);
205         dynargs[0] = args[0];
206         dynargs[1] = args[1];
207         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
208     }
209     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
210         string[] memory dynargs = new string[](2);
211         dynargs[0] = args[0];
212         dynargs[1] = args[1];
213         return oraclize_query(datasource, dynargs, gaslimit);
214     }
215     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
216         string[] memory dynargs = new string[](3);
217         dynargs[0] = args[0];
218         dynargs[1] = args[1];
219         dynargs[2] = args[2];
220         return oraclize_query(datasource, dynargs);
221     }
222     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
223         string[] memory dynargs = new string[](3);
224         dynargs[0] = args[0];
225         dynargs[1] = args[1];
226         dynargs[2] = args[2];
227         return oraclize_query(timestamp, datasource, dynargs);
228     }
229     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
230         string[] memory dynargs = new string[](3);
231         dynargs[0] = args[0];
232         dynargs[1] = args[1];
233         dynargs[2] = args[2];
234         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
235     }
236     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
237         string[] memory dynargs = new string[](3);
238         dynargs[0] = args[0];
239         dynargs[1] = args[1];
240         dynargs[2] = args[2];
241         return oraclize_query(datasource, dynargs, gaslimit);
242     }
243     
244     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
245         string[] memory dynargs = new string[](4);
246         dynargs[0] = args[0];
247         dynargs[1] = args[1];
248         dynargs[2] = args[2];
249         dynargs[3] = args[3];
250         return oraclize_query(datasource, dynargs);
251     }
252     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
253         string[] memory dynargs = new string[](4);
254         dynargs[0] = args[0];
255         dynargs[1] = args[1];
256         dynargs[2] = args[2];
257         dynargs[3] = args[3];
258         return oraclize_query(timestamp, datasource, dynargs);
259     }
260     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
261         string[] memory dynargs = new string[](4);
262         dynargs[0] = args[0];
263         dynargs[1] = args[1];
264         dynargs[2] = args[2];
265         dynargs[3] = args[3];
266         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
267     }
268     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
269         string[] memory dynargs = new string[](4);
270         dynargs[0] = args[0];
271         dynargs[1] = args[1];
272         dynargs[2] = args[2];
273         dynargs[3] = args[3];
274         return oraclize_query(datasource, dynargs, gaslimit);
275     }
276     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
277         string[] memory dynargs = new string[](5);
278         dynargs[0] = args[0];
279         dynargs[1] = args[1];
280         dynargs[2] = args[2];
281         dynargs[3] = args[3];
282         dynargs[4] = args[4];
283         return oraclize_query(datasource, dynargs);
284     }
285     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
286         string[] memory dynargs = new string[](5);
287         dynargs[0] = args[0];
288         dynargs[1] = args[1];
289         dynargs[2] = args[2];
290         dynargs[3] = args[3];
291         dynargs[4] = args[4];
292         return oraclize_query(timestamp, datasource, dynargs);
293     }
294     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
295         string[] memory dynargs = new string[](5);
296         dynargs[0] = args[0];
297         dynargs[1] = args[1];
298         dynargs[2] = args[2];
299         dynargs[3] = args[3];
300         dynargs[4] = args[4];
301         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
302     }
303     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
304         string[] memory dynargs = new string[](5);
305         dynargs[0] = args[0];
306         dynargs[1] = args[1];
307         dynargs[2] = args[2];
308         dynargs[3] = args[3];
309         dynargs[4] = args[4];
310         return oraclize_query(datasource, dynargs, gaslimit);
311     }
312     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
313         uint price = oraclize.getPrice(datasource);
314         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
315         bytes memory args = ba2cbor(argN);
316         return oraclize.queryN.value(price)(0, datasource, args);
317     }
318     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
319         uint price = oraclize.getPrice(datasource);
320         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
321         bytes memory args = ba2cbor(argN);
322         return oraclize.queryN.value(price)(timestamp, datasource, args);
323     }
324     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
325         uint price = oraclize.getPrice(datasource, gaslimit);
326         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
327         bytes memory args = ba2cbor(argN);
328         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
329     }
330     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
331         uint price = oraclize.getPrice(datasource, gaslimit);
332         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
333         bytes memory args = ba2cbor(argN);
334         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
335     }
336     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
337         bytes[] memory dynargs = new bytes[](1);
338         dynargs[0] = args[0];
339         return oraclize_query(datasource, dynargs);
340     }
341     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
342         bytes[] memory dynargs = new bytes[](1);
343         dynargs[0] = args[0];
344         return oraclize_query(timestamp, datasource, dynargs);
345     }
346     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
347         bytes[] memory dynargs = new bytes[](1);
348         dynargs[0] = args[0];
349         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
350     }
351     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
352         bytes[] memory dynargs = new bytes[](1);
353         dynargs[0] = args[0];       
354         return oraclize_query(datasource, dynargs, gaslimit);
355     }
356     
357     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
358         bytes[] memory dynargs = new bytes[](2);
359         dynargs[0] = args[0];
360         dynargs[1] = args[1];
361         return oraclize_query(datasource, dynargs);
362     }
363     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
364         bytes[] memory dynargs = new bytes[](2);
365         dynargs[0] = args[0];
366         dynargs[1] = args[1];
367         return oraclize_query(timestamp, datasource, dynargs);
368     }
369     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
370         bytes[] memory dynargs = new bytes[](2);
371         dynargs[0] = args[0];
372         dynargs[1] = args[1];
373         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
374     }
375     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
376         bytes[] memory dynargs = new bytes[](2);
377         dynargs[0] = args[0];
378         dynargs[1] = args[1];
379         return oraclize_query(datasource, dynargs, gaslimit);
380     }
381     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
382         bytes[] memory dynargs = new bytes[](3);
383         dynargs[0] = args[0];
384         dynargs[1] = args[1];
385         dynargs[2] = args[2];
386         return oraclize_query(datasource, dynargs);
387     }
388     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
389         bytes[] memory dynargs = new bytes[](3);
390         dynargs[0] = args[0];
391         dynargs[1] = args[1];
392         dynargs[2] = args[2];
393         return oraclize_query(timestamp, datasource, dynargs);
394     }
395     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
396         bytes[] memory dynargs = new bytes[](3);
397         dynargs[0] = args[0];
398         dynargs[1] = args[1];
399         dynargs[2] = args[2];
400         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
401     }
402     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
403         bytes[] memory dynargs = new bytes[](3);
404         dynargs[0] = args[0];
405         dynargs[1] = args[1];
406         dynargs[2] = args[2];
407         return oraclize_query(datasource, dynargs, gaslimit);
408     }
409     
410     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
411         bytes[] memory dynargs = new bytes[](4);
412         dynargs[0] = args[0];
413         dynargs[1] = args[1];
414         dynargs[2] = args[2];
415         dynargs[3] = args[3];
416         return oraclize_query(datasource, dynargs);
417     }
418     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
419         bytes[] memory dynargs = new bytes[](4);
420         dynargs[0] = args[0];
421         dynargs[1] = args[1];
422         dynargs[2] = args[2];
423         dynargs[3] = args[3];
424         return oraclize_query(timestamp, datasource, dynargs);
425     }
426     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
427         bytes[] memory dynargs = new bytes[](4);
428         dynargs[0] = args[0];
429         dynargs[1] = args[1];
430         dynargs[2] = args[2];
431         dynargs[3] = args[3];
432         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
433     }
434     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
435         bytes[] memory dynargs = new bytes[](4);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         dynargs[2] = args[2];
439         dynargs[3] = args[3];
440         return oraclize_query(datasource, dynargs, gaslimit);
441     }
442     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
443         bytes[] memory dynargs = new bytes[](5);
444         dynargs[0] = args[0];
445         dynargs[1] = args[1];
446         dynargs[2] = args[2];
447         dynargs[3] = args[3];
448         dynargs[4] = args[4];
449         return oraclize_query(datasource, dynargs);
450     }
451     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
452         bytes[] memory dynargs = new bytes[](5);
453         dynargs[0] = args[0];
454         dynargs[1] = args[1];
455         dynargs[2] = args[2];
456         dynargs[3] = args[3];
457         dynargs[4] = args[4];
458         return oraclize_query(timestamp, datasource, dynargs);
459     }
460     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
461         bytes[] memory dynargs = new bytes[](5);
462         dynargs[0] = args[0];
463         dynargs[1] = args[1];
464         dynargs[2] = args[2];
465         dynargs[3] = args[3];
466         dynargs[4] = args[4];
467         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
468     }
469     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
470         bytes[] memory dynargs = new bytes[](5);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         dynargs[2] = args[2];
474         dynargs[3] = args[3];
475         dynargs[4] = args[4];
476         return oraclize_query(datasource, dynargs, gaslimit);
477     }
478 
479     function oraclize_cbAddress() oraclizeAPI internal returns (address){
480         return oraclize.cbAddress();
481     }
482     function oraclize_setProof(byte proofP) oraclizeAPI internal {
483         return oraclize.setProofType(proofP);
484     }
485     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
486         return oraclize.setCustomGasPrice(gasPrice);
487     }
488     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
489         return oraclize.setConfig(config);
490     }
491     
492     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
493         return oraclize.randomDS_getSessionPubKeyHash();
494     }
495 
496     function getCodeSize(address _addr) constant internal returns(uint _size) {
497         assembly {
498             _size := extcodesize(_addr)
499         }
500     }
501 
502     function parseAddr(string _a) internal returns (address){
503         bytes memory tmp = bytes(_a);
504         uint160 iaddr = 0;
505         uint160 b1;
506         uint160 b2;
507         for (uint i=2; i<2+2*20; i+=2){
508             iaddr *= 256;
509             b1 = uint160(tmp[i]);
510             b2 = uint160(tmp[i+1]);
511             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
512             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
513             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
514             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
515             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
516             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
517             iaddr += (b1*16+b2);
518         }
519         return address(iaddr);
520     }
521 
522     function strCompare(string _a, string _b) internal returns (int) {
523         bytes memory a = bytes(_a);
524         bytes memory b = bytes(_b);
525         uint minLength = a.length;
526         if (b.length < minLength) minLength = b.length;
527         for (uint i = 0; i < minLength; i ++)
528             if (a[i] < b[i])
529                 return -1;
530             else if (a[i] > b[i])
531                 return 1;
532         if (a.length < b.length)
533             return -1;
534         else if (a.length > b.length)
535             return 1;
536         else
537             return 0;
538     }
539 
540     function indexOf(string _haystack, string _needle) internal returns (int) {
541         bytes memory h = bytes(_haystack);
542         bytes memory n = bytes(_needle);
543         if(h.length < 1 || n.length < 1 || (n.length > h.length))
544             return -1;
545         else if(h.length > (2**128 -1))
546             return -1;
547         else
548         {
549             uint subindex = 0;
550             for (uint i = 0; i < h.length; i ++)
551             {
552                 if (h[i] == n[0])
553                 {
554                     subindex = 1;
555                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
556                     {
557                         subindex++;
558                     }
559                     if(subindex == n.length)
560                         return int(i);
561                 }
562             }
563             return -1;
564         }
565     }
566 
567     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
568         bytes memory _ba = bytes(_a);
569         bytes memory _bb = bytes(_b);
570         bytes memory _bc = bytes(_c);
571         bytes memory _bd = bytes(_d);
572         bytes memory _be = bytes(_e);
573         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
574         bytes memory babcde = bytes(abcde);
575         uint k = 0;
576         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
577         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
578         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
579         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
580         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
581         return string(babcde);
582     }
583 
584     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
585         return strConcat(_a, _b, _c, _d, "");
586     }
587 
588     function strConcat(string _a, string _b, string _c) internal returns (string) {
589         return strConcat(_a, _b, _c, "", "");
590     }
591 
592     function strConcat(string _a, string _b) internal returns (string) {
593         return strConcat(_a, _b, "", "", "");
594     }
595 
596     // parseInt
597     function parseInt(string _a) internal returns (uint) {
598         return parseInt(_a, 0);
599     }
600 
601     // parseInt(parseFloat*10^_b)
602     function parseInt(string _a, uint _b) internal returns (uint) {
603         bytes memory bresult = bytes(_a);
604         uint mint = 0;
605         bool decimals = false;
606         for (uint i=0; i<bresult.length; i++){
607             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
608                 if (decimals){
609                    if (_b == 0) break;
610                     else _b--;
611                 }
612                 mint *= 10;
613                 mint += uint(bresult[i]) - 48;
614             } else if (bresult[i] == 46) decimals = true;
615         }
616         if (_b > 0) mint *= 10**_b;
617         return mint;
618     }
619 
620     function uint2str(uint i) internal returns (string){
621         if (i == 0) return "0";
622         uint j = i;
623         uint len;
624         while (j != 0){
625             len++;
626             j /= 10;
627         }
628         bytes memory bstr = new bytes(len);
629         uint k = len - 1;
630         while (i != 0){
631             bstr[k--] = byte(48 + i % 10);
632             i /= 10;
633         }
634         return string(bstr);
635     }
636     
637     function stra2cbor(string[] arr) internal returns (bytes) {
638             uint arrlen = arr.length;
639 
640             // get correct cbor output length
641             uint outputlen = 0;
642             bytes[] memory elemArray = new bytes[](arrlen);
643             for (uint i = 0; i < arrlen; i++) {
644                 elemArray[i] = (bytes(arr[i]));
645                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
646             }
647             uint ctr = 0;
648             uint cborlen = arrlen + 0x80;
649             outputlen += byte(cborlen).length;
650             bytes memory res = new bytes(outputlen);
651 
652             while (byte(cborlen).length > ctr) {
653                 res[ctr] = byte(cborlen)[ctr];
654                 ctr++;
655             }
656             for (i = 0; i < arrlen; i++) {
657                 res[ctr] = 0x5F;
658                 ctr++;
659                 for (uint x = 0; x < elemArray[i].length; x++) {
660                     // if there's a bug with larger strings, this may be the culprit
661                     if (x % 23 == 0) {
662                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
663                         elemcborlen += 0x40;
664                         uint lctr = ctr;
665                         while (byte(elemcborlen).length > ctr - lctr) {
666                             res[ctr] = byte(elemcborlen)[ctr - lctr];
667                             ctr++;
668                         }
669                     }
670                     res[ctr] = elemArray[i][x];
671                     ctr++;
672                 }
673                 res[ctr] = 0xFF;
674                 ctr++;
675             }
676             return res;
677         }
678 
679     function ba2cbor(bytes[] arr) internal returns (bytes) {
680             uint arrlen = arr.length;
681 
682             // get correct cbor output length
683             uint outputlen = 0;
684             bytes[] memory elemArray = new bytes[](arrlen);
685             for (uint i = 0; i < arrlen; i++) {
686                 elemArray[i] = (bytes(arr[i]));
687                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
688             }
689             uint ctr = 0;
690             uint cborlen = arrlen + 0x80;
691             outputlen += byte(cborlen).length;
692             bytes memory res = new bytes(outputlen);
693 
694             while (byte(cborlen).length > ctr) {
695                 res[ctr] = byte(cborlen)[ctr];
696                 ctr++;
697             }
698             for (i = 0; i < arrlen; i++) {
699                 res[ctr] = 0x5F;
700                 ctr++;
701                 for (uint x = 0; x < elemArray[i].length; x++) {
702                     // if there's a bug with larger strings, this may be the culprit
703                     if (x % 23 == 0) {
704                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
705                         elemcborlen += 0x40;
706                         uint lctr = ctr;
707                         while (byte(elemcborlen).length > ctr - lctr) {
708                             res[ctr] = byte(elemcborlen)[ctr - lctr];
709                             ctr++;
710                         }
711                     }
712                     res[ctr] = elemArray[i][x];
713                     ctr++;
714                 }
715                 res[ctr] = 0xFF;
716                 ctr++;
717             }
718             return res;
719         }
720         
721         
722     string oraclize_network_name;
723     function oraclize_setNetworkName(string _network_name) internal {
724         oraclize_network_name = _network_name;
725     }
726     
727     function oraclize_getNetworkName() internal returns (string) {
728         return oraclize_network_name;
729     }
730     
731     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
732         if ((_nbytes == 0)||(_nbytes > 32)) throw;
733         bytes memory nbytes = new bytes(1);
734         nbytes[0] = byte(_nbytes);
735         bytes memory unonce = new bytes(32);
736         bytes memory sessionKeyHash = new bytes(32);
737         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
738         assembly {
739             mstore(unonce, 0x20)
740             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
741             mstore(sessionKeyHash, 0x20)
742             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
743         }
744         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
745         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
746         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
747         return queryId;
748     }
749     
750     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
751         oraclize_randomDS_args[queryId] = commitment;
752     }
753     
754     mapping(bytes32=>bytes32) oraclize_randomDS_args;
755     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
756 
757     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
758         bool sigok;
759         address signer;
760         
761         bytes32 sigr;
762         bytes32 sigs;
763         
764         bytes memory sigr_ = new bytes(32);
765         uint offset = 4+(uint(dersig[3]) - 0x20);
766         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
767         bytes memory sigs_ = new bytes(32);
768         offset += 32 + 2;
769         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
770 
771         assembly {
772             sigr := mload(add(sigr_, 32))
773             sigs := mload(add(sigs_, 32))
774         }
775         
776         
777         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
778         if (address(sha3(pubkey)) == signer) return true;
779         else {
780             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
781             return (address(sha3(pubkey)) == signer);
782         }
783     }
784 
785     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
786         bool sigok;
787         
788         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
789         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
790         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
791         
792         bytes memory appkey1_pubkey = new bytes(64);
793         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
794         
795         bytes memory tosign2 = new bytes(1+65+32);
796         tosign2[0] = 1; //role
797         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
798         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
799         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
800         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
801         
802         if (sigok == false) return false;
803         
804         
805         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
806         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
807         
808         bytes memory tosign3 = new bytes(1+65);
809         tosign3[0] = 0xFE;
810         copyBytes(proof, 3, 65, tosign3, 1);
811         
812         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
813         copyBytes(proof, 3+65, sig3.length, sig3, 0);
814         
815         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
816         
817         return sigok;
818     }
819     
820     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
821         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
822         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
823         
824         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
825         if (proofVerified == false) throw;
826         
827         _;
828     }
829     
830     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
831         bool match_ = true;
832         
833         for (var i=0; i<prefix.length; i++){
834             if (content[i] != prefix[i]) match_ = false;
835         }
836         
837         return match_;
838     }
839 
840     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
841         bool checkok;
842         
843         
844         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
845         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
846         bytes memory keyhash = new bytes(32);
847         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
848         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
849         if (checkok == false) return false;
850         
851         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
852         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
853         
854         
855         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
856         checkok = matchBytes32Prefix(sha256(sig1), result);
857         if (checkok == false) return false;
858         
859         
860         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
861         // This is to verify that the computed args match with the ones specified in the query.
862         bytes memory commitmentSlice1 = new bytes(8+1+32);
863         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
864         
865         bytes memory sessionPubkey = new bytes(64);
866         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
867         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
868         
869         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
870         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
871             delete oraclize_randomDS_args[queryId];
872         } else return false;
873         
874         
875         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
876         bytes memory tosign1 = new bytes(32+8+1+32);
877         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
878         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
879         if (checkok == false) return false;
880         
881         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
882         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
883             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
884         }
885         
886         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
887     }
888 
889     
890     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
891     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
892         uint minLength = length + toOffset;
893 
894         if (to.length < minLength) {
895             // Buffer too small
896             throw; // Should be a better way?
897         }
898 
899         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
900         uint i = 32 + fromOffset;
901         uint j = 32 + toOffset;
902 
903         while (i < (32 + fromOffset + length)) {
904             assembly {
905                 let tmp := mload(add(from, i))
906                 mstore(add(to, j), tmp)
907             }
908             i += 32;
909             j += 32;
910         }
911 
912         return to;
913     }
914     
915     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
916     // Duplicate Solidity's ecrecover, but catching the CALL return value
917     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
918         // We do our own memory management here. Solidity uses memory offset
919         // 0x40 to store the current end of memory. We write past it (as
920         // writes are memory extensions), but don't update the offset so
921         // Solidity will reuse it. The memory used here is only needed for
922         // this context.
923 
924         // FIXME: inline assembly can't access return values
925         bool ret;
926         address addr;
927 
928         assembly {
929             let size := mload(0x40)
930             mstore(size, hash)
931             mstore(add(size, 32), v)
932             mstore(add(size, 64), r)
933             mstore(add(size, 96), s)
934 
935             // NOTE: we can reuse the request memory because we deal with
936             //       the return code
937             ret := call(3000, 1, 0, size, 128, size, 32)
938             addr := mload(size)
939         }
940   
941         return (ret, addr);
942     }
943 
944     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
945     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
946         bytes32 r;
947         bytes32 s;
948         uint8 v;
949 
950         if (sig.length != 65)
951           return (false, 0);
952 
953         // The signature format is a compact form of:
954         //   {bytes32 r}{bytes32 s}{uint8 v}
955         // Compact means, uint8 is not padded to 32 bytes.
956         assembly {
957             r := mload(add(sig, 32))
958             s := mload(add(sig, 64))
959 
960             // Here we are loading the last 32 bytes. We exploit the fact that
961             // 'mload' will pad with zeroes if we overread.
962             // There is no 'mload8' to do this, but that would be nicer.
963             v := byte(0, mload(add(sig, 96)))
964 
965             // Alternative solution:
966             // 'byte' is not working due to the Solidity parser, so lets
967             // use the second best option, 'and'
968             // v := and(mload(add(sig, 65)), 255)
969         }
970 
971         // albeit non-transactional signatures are not specified by the YP, one would expect it
972         // to match the YP range of [27, 28]
973         //
974         // geth uses [0, 1] and some clients have followed. This might change, see:
975         //  https://github.com/ethereum/go-ethereum/issues/2053
976         if (v < 27)
977           v += 27;
978 
979         if (v != 27 && v != 28)
980             return (false, 0);
981 
982         return safer_ecrecover(hash, v, r, s);
983     }
984         
985 }
986 
987 contract owned {
988     
989     address public owner;
990 
991     function owned() {
992         owner = msg.sender;
993     }
994 
995     modifier onlyOwner {
996         if (msg.sender != owner) revert();
997         _;
998     }
999 
1000     function changeOwner(address newOwner) onlyOwner {
1001         owner = newOwner;
1002     }
1003     
1004 }
1005 
1006 contract ProfitExchange is owned, usingOraclize  {
1007     
1008     bool public ACCEPT_EXCHANGE = true;
1009     mapping (bytes32 => address) public addresses;
1010     mapping (bytes32 => uint) public balances;
1011 
1012     modifier onlyWithValue() {
1013         if (msg.value == 0) revert();
1014         _;
1015     }
1016     
1017     modifier onlyAcceptExchange() {
1018         if (! ACCEPT_EXCHANGE) revert();
1019         _;
1020     }
1021     
1022     function ProfitExchange() {
1023         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1024     }
1025     
1026     function changeAcceptExchange(bool new_status) onlyOwner {
1027         ACCEPT_EXCHANGE = new_status;
1028     }
1029     
1030     function uintToString(uint v) constant private returns (string) {
1031         uint maxlength = 100;
1032         bytes memory reversed = new bytes(maxlength);
1033         uint i = 0;
1034         while (v != 0) {
1035             uint remainder = v % 10;
1036             v = v / 10;
1037             reversed[i++] = byte(48 + remainder);
1038         }
1039         bytes memory s = new bytes(i);
1040         for (uint j = 0; j < i; j++) {
1041             s[j] = reversed[i - j - 1];
1042         }
1043         string memory str = string(s);
1044         return str;
1045     }
1046     
1047     function stringToUint(string s) constant private returns (uint) {
1048         bytes memory b = bytes(s);
1049         uint result = 0;
1050         for (uint i = 0; i < b.length; i++) {
1051             if (b[i] >= 48 && b[i] <= 57) {
1052                 result = result * 10 + (uint(b[i]) - 48);
1053             }
1054         }
1055         return result;
1056     }
1057     
1058     function strConcats(string _a, string _b, string _c, string _d, string _e) constant private returns (string){
1059         bytes memory _ba = bytes(_a);
1060         bytes memory _bb = bytes(_b);
1061         bytes memory _bc = bytes(_c);
1062         bytes memory _bd = bytes(_d);
1063         bytes memory _be = bytes(_e);
1064         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1065         bytes memory babcde = bytes(abcde);
1066         uint k = 0;
1067         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1068         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1069         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1070         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1071         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1072         return string(babcde);
1073     }
1074 
1075     function strConcats(string _a, string _b, string _c, string _d) constant private returns (string) {
1076         return strConcat(_a, _b, _c, _d, "");
1077     }
1078 
1079     function strConcats(string _a, string _b, string _c) constant private returns (string) {
1080         return strConcat(_a, _b, _c, "", "");
1081     }
1082 
1083     function strConcats(string _a, string _b) constant private returns (string) {
1084         return strConcat(_a, _b, "", "", "");
1085     }
1086     
1087     function __callback(bytes32 myid, string result, bytes proof) {
1088         if (msg.sender != oraclize_cbAddress()) revert();
1089         if (balances[myid] <= 0) revert();
1090         address addr = addresses[myid];
1091         uint256 retBalance = stringToUint(result);
1092         if (retBalance > this.balance){
1093             if (balances[myid] > this.balance){
1094                 addr.transfer(this.balance);
1095             }else{
1096                 addr.transfer(balances[myid]);
1097             }
1098         }else{
1099             addr.transfer(retBalance);
1100         }
1101         delete addresses[myid];
1102         delete balances[myid];
1103     }
1104     
1105     function () payable onlyWithValue onlyAcceptExchange {
1106         if (oraclize.getPrice("URL") > this.balance) {
1107             msg.sender.transfer(msg.value);
1108         }else{
1109             string memory url = strConcats("https://pakho.xyz/php/ProfitExchange.php?value=", uintToString(msg.value));
1110             bytes32 myid = oraclize_query("URL", url);
1111             addresses[myid] = msg.sender;
1112             balances[myid] = msg.value;
1113         }
1114     }
1115     
1116     function deposit() payable onlyWithValue {}
1117     
1118     function withdraw(uint value) payable onlyOwner {
1119         if (value > this.balance) revert();
1120         msg.sender.transfer(value);
1121     }
1122     
1123     function withdrawAll() payable onlyOwner {
1124         msg.sender.transfer(this.balance);
1125     }
1126     
1127     function kill() onlyOwner {
1128         suicide(msg.sender);
1129     }
1130 
1131 }