1 pragma solidity ^0.4.15;
2 
3 //////////////////////////////////////////////////////////
4 //
5 // Developer: www.crystal-ball.app
6 // Date: 2018-06-11
7 // author: Ray Lei
8 // email: crystalball.dapp@gmail.com
9 //
10 /////////////////////////////////////////////////////////
11 
12 contract OraclizeI {
13     address public cbAddress;
14     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
15     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
16     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
17     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
18     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
19     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
20     function getPrice(string _datasource) returns (uint _dsprice);
21     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
22     function useCoupon(string _coupon);
23     function setProofType(byte _proofType);
24     function setConfig(bytes32 _config);
25     function setCustomGasPrice(uint _gasPrice);
26     function randomDS_getSessionPubKeyHash() returns(bytes32);
27 }
28 contract OraclizeAddrResolverI {
29     function getAddress() returns (address _addr);
30 }
31 contract usingOraclize {
32     uint constant day = 60*60*24;
33     uint constant week = 60*60*24*7;
34     uint constant month = 60*60*24*30;
35     byte constant proofType_NONE = 0x00;
36     byte constant proofType_TLSNotary = 0x10;
37     byte constant proofType_Android = 0x20;
38     byte constant proofType_Ledger = 0x30;
39     byte constant proofType_Native = 0xF0;
40     byte constant proofStorage_IPFS = 0x01;
41     uint8 constant networkID_auto = 0;
42     uint8 constant networkID_mainnet = 1;
43     uint8 constant networkID_testnet = 2;
44     uint8 constant networkID_morden = 2;
45     uint8 constant networkID_consensys = 161;
46 
47     OraclizeAddrResolverI OAR;
48 
49     OraclizeI oraclize;
50     modifier oraclizeAPI {
51         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
52         oraclize = OraclizeI(OAR.getAddress());
53         _;
54     }
55     modifier coupon(string code){
56         oraclize = OraclizeI(OAR.getAddress());
57         oraclize.useCoupon(code);
58         _;
59     }
60 
61     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
62         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
63             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
64             oraclize_setNetworkName("eth_mainnet");
65             return true;
66         }
67         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
68             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
69             oraclize_setNetworkName("eth_ropsten3");
70             return true;
71         }
72         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
73             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
74             oraclize_setNetworkName("eth_kovan");
75             return true;
76         }
77         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
78             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
79             oraclize_setNetworkName("eth_rinkeby");
80             return true;
81         }
82         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
83             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
84             return true;
85         }
86         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
87             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
88             return true;
89         }
90         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
91             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
92             return true;
93         }
94         return false;
95     }
96 
97     function __callback(bytes32 myid, string result) {
98         __callback(myid, result, new bytes(0));
99     }
100     function __callback(bytes32 myid, string result, bytes proof) {
101     }
102 
103     function oraclize_useCoupon(string code) oraclizeAPI internal {
104         oraclize.useCoupon(code);
105     }
106 
107     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
108         return oraclize.getPrice(datasource);
109     }
110 
111     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
112         return oraclize.getPrice(datasource, gaslimit);
113     }
114 
115     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
116         uint price = oraclize.getPrice(datasource);
117         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
118         return oraclize.query.value(price)(0, datasource, arg);
119     }
120     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
121         uint price = oraclize.getPrice(datasource);
122         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
123         return oraclize.query.value(price)(timestamp, datasource, arg);
124     }
125     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
126         uint price = oraclize.getPrice(datasource, gaslimit);
127         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
128         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
129     }
130     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
131         uint price = oraclize.getPrice(datasource, gaslimit);
132         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
133         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
134     }
135     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
136         uint price = oraclize.getPrice(datasource);
137         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
138         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
139     }
140     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
141         uint price = oraclize.getPrice(datasource);
142         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
143         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
144     }
145     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
146         uint price = oraclize.getPrice(datasource, gaslimit);
147         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
148         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
149     }
150     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
151         uint price = oraclize.getPrice(datasource, gaslimit);
152         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
153         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
154     }
155     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
156         uint price = oraclize.getPrice(datasource);
157         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
158         bytes memory args = stra2cbor(argN);
159         return oraclize.queryN.value(price)(0, datasource, args);
160     }
161     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
162         uint price = oraclize.getPrice(datasource);
163         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
164         bytes memory args = stra2cbor(argN);
165         return oraclize.queryN.value(price)(timestamp, datasource, args);
166     }
167     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
168         uint price = oraclize.getPrice(datasource, gaslimit);
169         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
170         bytes memory args = stra2cbor(argN);
171         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
172     }
173     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
174         uint price = oraclize.getPrice(datasource, gaslimit);
175         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
176         bytes memory args = stra2cbor(argN);
177         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
178     }
179     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
180         string[] memory dynargs = new string[](1);
181         dynargs[0] = args[0];
182         return oraclize_query(datasource, dynargs);
183     }
184     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
185         string[] memory dynargs = new string[](1);
186         dynargs[0] = args[0];
187         return oraclize_query(timestamp, datasource, dynargs);
188     }
189     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
190         string[] memory dynargs = new string[](1);
191         dynargs[0] = args[0];
192         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
193     }
194     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
195         string[] memory dynargs = new string[](1);
196         dynargs[0] = args[0];
197         return oraclize_query(datasource, dynargs, gaslimit);
198     }
199 
200     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
201         string[] memory dynargs = new string[](2);
202         dynargs[0] = args[0];
203         dynargs[1] = args[1];
204         return oraclize_query(datasource, dynargs);
205     }
206     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
207         string[] memory dynargs = new string[](2);
208         dynargs[0] = args[0];
209         dynargs[1] = args[1];
210         return oraclize_query(timestamp, datasource, dynargs);
211     }
212     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
213         string[] memory dynargs = new string[](2);
214         dynargs[0] = args[0];
215         dynargs[1] = args[1];
216         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
217     }
218     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
219         string[] memory dynargs = new string[](2);
220         dynargs[0] = args[0];
221         dynargs[1] = args[1];
222         return oraclize_query(datasource, dynargs, gaslimit);
223     }
224     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
225         string[] memory dynargs = new string[](3);
226         dynargs[0] = args[0];
227         dynargs[1] = args[1];
228         dynargs[2] = args[2];
229         return oraclize_query(datasource, dynargs);
230     }
231     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
232         string[] memory dynargs = new string[](3);
233         dynargs[0] = args[0];
234         dynargs[1] = args[1];
235         dynargs[2] = args[2];
236         return oraclize_query(timestamp, datasource, dynargs);
237     }
238     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
239         string[] memory dynargs = new string[](3);
240         dynargs[0] = args[0];
241         dynargs[1] = args[1];
242         dynargs[2] = args[2];
243         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
244     }
245     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
246         string[] memory dynargs = new string[](3);
247         dynargs[0] = args[0];
248         dynargs[1] = args[1];
249         dynargs[2] = args[2];
250         return oraclize_query(datasource, dynargs, gaslimit);
251     }
252 
253     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
254         string[] memory dynargs = new string[](4);
255         dynargs[0] = args[0];
256         dynargs[1] = args[1];
257         dynargs[2] = args[2];
258         dynargs[3] = args[3];
259         return oraclize_query(datasource, dynargs);
260     }
261     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
262         string[] memory dynargs = new string[](4);
263         dynargs[0] = args[0];
264         dynargs[1] = args[1];
265         dynargs[2] = args[2];
266         dynargs[3] = args[3];
267         return oraclize_query(timestamp, datasource, dynargs);
268     }
269     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
270         string[] memory dynargs = new string[](4);
271         dynargs[0] = args[0];
272         dynargs[1] = args[1];
273         dynargs[2] = args[2];
274         dynargs[3] = args[3];
275         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
276     }
277     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
278         string[] memory dynargs = new string[](4);
279         dynargs[0] = args[0];
280         dynargs[1] = args[1];
281         dynargs[2] = args[2];
282         dynargs[3] = args[3];
283         return oraclize_query(datasource, dynargs, gaslimit);
284     }
285     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
286         string[] memory dynargs = new string[](5);
287         dynargs[0] = args[0];
288         dynargs[1] = args[1];
289         dynargs[2] = args[2];
290         dynargs[3] = args[3];
291         dynargs[4] = args[4];
292         return oraclize_query(datasource, dynargs);
293     }
294     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
295         string[] memory dynargs = new string[](5);
296         dynargs[0] = args[0];
297         dynargs[1] = args[1];
298         dynargs[2] = args[2];
299         dynargs[3] = args[3];
300         dynargs[4] = args[4];
301         return oraclize_query(timestamp, datasource, dynargs);
302     }
303     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
304         string[] memory dynargs = new string[](5);
305         dynargs[0] = args[0];
306         dynargs[1] = args[1];
307         dynargs[2] = args[2];
308         dynargs[3] = args[3];
309         dynargs[4] = args[4];
310         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
311     }
312     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
313         string[] memory dynargs = new string[](5);
314         dynargs[0] = args[0];
315         dynargs[1] = args[1];
316         dynargs[2] = args[2];
317         dynargs[3] = args[3];
318         dynargs[4] = args[4];
319         return oraclize_query(datasource, dynargs, gaslimit);
320     }
321     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
322         uint price = oraclize.getPrice(datasource);
323         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
324         bytes memory args = ba2cbor(argN);
325         return oraclize.queryN.value(price)(0, datasource, args);
326     }
327     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
328         uint price = oraclize.getPrice(datasource);
329         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
330         bytes memory args = ba2cbor(argN);
331         return oraclize.queryN.value(price)(timestamp, datasource, args);
332     }
333     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
334         uint price = oraclize.getPrice(datasource, gaslimit);
335         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
336         bytes memory args = ba2cbor(argN);
337         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
338     }
339     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
340         uint price = oraclize.getPrice(datasource, gaslimit);
341         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
342         bytes memory args = ba2cbor(argN);
343         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
344     }
345     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
346         bytes[] memory dynargs = new bytes[](1);
347         dynargs[0] = args[0];
348         return oraclize_query(datasource, dynargs);
349     }
350     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
351         bytes[] memory dynargs = new bytes[](1);
352         dynargs[0] = args[0];
353         return oraclize_query(timestamp, datasource, dynargs);
354     }
355     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
356         bytes[] memory dynargs = new bytes[](1);
357         dynargs[0] = args[0];
358         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
359     }
360     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
361         bytes[] memory dynargs = new bytes[](1);
362         dynargs[0] = args[0];
363         return oraclize_query(datasource, dynargs, gaslimit);
364     }
365 
366     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
367         bytes[] memory dynargs = new bytes[](2);
368         dynargs[0] = args[0];
369         dynargs[1] = args[1];
370         return oraclize_query(datasource, dynargs);
371     }
372     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
373         bytes[] memory dynargs = new bytes[](2);
374         dynargs[0] = args[0];
375         dynargs[1] = args[1];
376         return oraclize_query(timestamp, datasource, dynargs);
377     }
378     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
379         bytes[] memory dynargs = new bytes[](2);
380         dynargs[0] = args[0];
381         dynargs[1] = args[1];
382         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
383     }
384     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
385         bytes[] memory dynargs = new bytes[](2);
386         dynargs[0] = args[0];
387         dynargs[1] = args[1];
388         return oraclize_query(datasource, dynargs, gaslimit);
389     }
390     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
391         bytes[] memory dynargs = new bytes[](3);
392         dynargs[0] = args[0];
393         dynargs[1] = args[1];
394         dynargs[2] = args[2];
395         return oraclize_query(datasource, dynargs);
396     }
397     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
398         bytes[] memory dynargs = new bytes[](3);
399         dynargs[0] = args[0];
400         dynargs[1] = args[1];
401         dynargs[2] = args[2];
402         return oraclize_query(timestamp, datasource, dynargs);
403     }
404     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
405         bytes[] memory dynargs = new bytes[](3);
406         dynargs[0] = args[0];
407         dynargs[1] = args[1];
408         dynargs[2] = args[2];
409         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
410     }
411     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
412         bytes[] memory dynargs = new bytes[](3);
413         dynargs[0] = args[0];
414         dynargs[1] = args[1];
415         dynargs[2] = args[2];
416         return oraclize_query(datasource, dynargs, gaslimit);
417     }
418 
419     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
420         bytes[] memory dynargs = new bytes[](4);
421         dynargs[0] = args[0];
422         dynargs[1] = args[1];
423         dynargs[2] = args[2];
424         dynargs[3] = args[3];
425         return oraclize_query(datasource, dynargs);
426     }
427     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
428         bytes[] memory dynargs = new bytes[](4);
429         dynargs[0] = args[0];
430         dynargs[1] = args[1];
431         dynargs[2] = args[2];
432         dynargs[3] = args[3];
433         return oraclize_query(timestamp, datasource, dynargs);
434     }
435     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
436         bytes[] memory dynargs = new bytes[](4);
437         dynargs[0] = args[0];
438         dynargs[1] = args[1];
439         dynargs[2] = args[2];
440         dynargs[3] = args[3];
441         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
442     }
443     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
444         bytes[] memory dynargs = new bytes[](4);
445         dynargs[0] = args[0];
446         dynargs[1] = args[1];
447         dynargs[2] = args[2];
448         dynargs[3] = args[3];
449         return oraclize_query(datasource, dynargs, gaslimit);
450     }
451     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
452         bytes[] memory dynargs = new bytes[](5);
453         dynargs[0] = args[0];
454         dynargs[1] = args[1];
455         dynargs[2] = args[2];
456         dynargs[3] = args[3];
457         dynargs[4] = args[4];
458         return oraclize_query(datasource, dynargs);
459     }
460     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
461         bytes[] memory dynargs = new bytes[](5);
462         dynargs[0] = args[0];
463         dynargs[1] = args[1];
464         dynargs[2] = args[2];
465         dynargs[3] = args[3];
466         dynargs[4] = args[4];
467         return oraclize_query(timestamp, datasource, dynargs);
468     }
469     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
470         bytes[] memory dynargs = new bytes[](5);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         dynargs[2] = args[2];
474         dynargs[3] = args[3];
475         dynargs[4] = args[4];
476         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
477     }
478     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
479         bytes[] memory dynargs = new bytes[](5);
480         dynargs[0] = args[0];
481         dynargs[1] = args[1];
482         dynargs[2] = args[2];
483         dynargs[3] = args[3];
484         dynargs[4] = args[4];
485         return oraclize_query(datasource, dynargs, gaslimit);
486     }
487 
488     function oraclize_cbAddress() oraclizeAPI internal returns (address){
489         return oraclize.cbAddress();
490     }
491     function oraclize_setProof(byte proofP) oraclizeAPI internal {
492         return oraclize.setProofType(proofP);
493     }
494     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
495         return oraclize.setCustomGasPrice(gasPrice);
496     }
497     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
498         return oraclize.setConfig(config);
499     }
500 
501     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
502         return oraclize.randomDS_getSessionPubKeyHash();
503     }
504 
505     function getCodeSize(address _addr) constant internal returns(uint _size) {
506         assembly {
507             _size := extcodesize(_addr)
508         }
509     }
510 
511     function parseAddr(string _a) internal returns (address){
512         bytes memory tmp = bytes(_a);
513         uint160 iaddr = 0;
514         uint160 b1;
515         uint160 b2;
516         for (uint i=2; i<2+2*20; i+=2){
517             iaddr *= 256;
518             b1 = uint160(tmp[i]);
519             b2 = uint160(tmp[i+1]);
520             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
521             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
522             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
523             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
524             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
525             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
526             iaddr += (b1*16+b2);
527         }
528         return address(iaddr);
529     }
530 
531     function strCompare(string _a, string _b) internal returns (int) {
532         bytes memory a = bytes(_a);
533         bytes memory b = bytes(_b);
534         uint minLength = a.length;
535         if (b.length < minLength) minLength = b.length;
536         for (uint i = 0; i < minLength; i ++)
537             if (a[i] < b[i])
538                 return -1;
539             else if (a[i] > b[i])
540                 return 1;
541         if (a.length < b.length)
542             return -1;
543         else if (a.length > b.length)
544             return 1;
545         else
546             return 0;
547     }
548 
549     function indexOf(string _haystack, string _needle) internal returns (int) {
550         bytes memory h = bytes(_haystack);
551         bytes memory n = bytes(_needle);
552         if(h.length < 1 || n.length < 1 || (n.length > h.length))
553             return -1;
554         else if(h.length > (2**128 -1))
555             return -1;
556         else
557         {
558             uint subindex = 0;
559             for (uint i = 0; i < h.length; i ++)
560             {
561                 if (h[i] == n[0])
562                 {
563                     subindex = 1;
564                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
565                     {
566                         subindex++;
567                     }
568                     if(subindex == n.length)
569                         return int(i);
570                 }
571             }
572             return -1;
573         }
574     }
575 
576     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
577         bytes memory _ba = bytes(_a);
578         bytes memory _bb = bytes(_b);
579         bytes memory _bc = bytes(_c);
580         bytes memory _bd = bytes(_d);
581         bytes memory _be = bytes(_e);
582         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
583         bytes memory babcde = bytes(abcde);
584         uint k = 0;
585         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
586         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
587         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
588         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
589         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
590         return string(babcde);
591     }
592 
593     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
594         return strConcat(_a, _b, _c, _d, "");
595     }
596 
597     function strConcat(string _a, string _b, string _c) internal returns (string) {
598         return strConcat(_a, _b, _c, "", "");
599     }
600 
601     function strConcat(string _a, string _b) internal returns (string) {
602         return strConcat(_a, _b, "", "", "");
603     }
604 
605     // parseInt
606     function parseInt(string _a) internal returns (uint) {
607         return parseInt(_a, 0);
608     }
609 
610     // parseInt(parseFloat*10^_b)
611     function parseInt(string _a, uint _b) internal returns (uint) {
612         bytes memory bresult = bytes(_a);
613         uint mint = 0;
614         bool decimals = false;
615         for (uint i=0; i<bresult.length; i++){
616             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
617                 if (decimals){
618                    if (_b == 0) break;
619                     else _b--;
620                 }
621                 mint *= 10;
622                 mint += uint(bresult[i]) - 48;
623             } else if (bresult[i] == 46) decimals = true;
624         }
625         if (_b > 0) mint *= 10**_b;
626         return mint;
627     }
628 
629     function uint2str(uint i) internal returns (string){
630         if (i == 0) return "0";
631         uint j = i;
632         uint len;
633         while (j != 0){
634             len++;
635             j /= 10;
636         }
637         bytes memory bstr = new bytes(len);
638         uint k = len - 1;
639         while (i != 0){
640             bstr[k--] = byte(48 + i % 10);
641             i /= 10;
642         }
643         return string(bstr);
644     }
645 
646     function stra2cbor(string[] arr) internal returns (bytes) {
647             uint arrlen = arr.length;
648 
649             // get correct cbor output length
650             uint outputlen = 0;
651             bytes[] memory elemArray = new bytes[](arrlen);
652             for (uint i = 0; i < arrlen; i++) {
653                 elemArray[i] = (bytes(arr[i]));
654                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
655             }
656             uint ctr = 0;
657             uint cborlen = arrlen + 0x80;
658             outputlen += byte(cborlen).length;
659             bytes memory res = new bytes(outputlen);
660 
661             while (byte(cborlen).length > ctr) {
662                 res[ctr] = byte(cborlen)[ctr];
663                 ctr++;
664             }
665             for (i = 0; i < arrlen; i++) {
666                 res[ctr] = 0x5F;
667                 ctr++;
668                 for (uint x = 0; x < elemArray[i].length; x++) {
669                     // if there's a bug with larger strings, this may be the culprit
670                     if (x % 23 == 0) {
671                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
672                         elemcborlen += 0x40;
673                         uint lctr = ctr;
674                         while (byte(elemcborlen).length > ctr - lctr) {
675                             res[ctr] = byte(elemcborlen)[ctr - lctr];
676                             ctr++;
677                         }
678                     }
679                     res[ctr] = elemArray[i][x];
680                     ctr++;
681                 }
682                 res[ctr] = 0xFF;
683                 ctr++;
684             }
685             return res;
686         }
687 
688     function ba2cbor(bytes[] arr) internal returns (bytes) {
689             uint arrlen = arr.length;
690 
691             // get correct cbor output length
692             uint outputlen = 0;
693             bytes[] memory elemArray = new bytes[](arrlen);
694             for (uint i = 0; i < arrlen; i++) {
695                 elemArray[i] = (bytes(arr[i]));
696                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
697             }
698             uint ctr = 0;
699             uint cborlen = arrlen + 0x80;
700             outputlen += byte(cborlen).length;
701             bytes memory res = new bytes(outputlen);
702 
703             while (byte(cborlen).length > ctr) {
704                 res[ctr] = byte(cborlen)[ctr];
705                 ctr++;
706             }
707             for (i = 0; i < arrlen; i++) {
708                 res[ctr] = 0x5F;
709                 ctr++;
710                 for (uint x = 0; x < elemArray[i].length; x++) {
711                     // if there's a bug with larger strings, this may be the culprit
712                     if (x % 23 == 0) {
713                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
714                         elemcborlen += 0x40;
715                         uint lctr = ctr;
716                         while (byte(elemcborlen).length > ctr - lctr) {
717                             res[ctr] = byte(elemcborlen)[ctr - lctr];
718                             ctr++;
719                         }
720                     }
721                     res[ctr] = elemArray[i][x];
722                     ctr++;
723                 }
724                 res[ctr] = 0xFF;
725                 ctr++;
726             }
727             return res;
728         }
729 
730 
731     string oraclize_network_name;
732     function oraclize_setNetworkName(string _network_name) internal {
733         oraclize_network_name = _network_name;
734     }
735 
736     function oraclize_getNetworkName() internal returns (string) {
737         return oraclize_network_name;
738     }
739 
740     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
741         if ((_nbytes == 0)||(_nbytes > 32)) throw;
742         bytes memory nbytes = new bytes(1);
743         nbytes[0] = byte(_nbytes);
744         bytes memory unonce = new bytes(32);
745         bytes memory sessionKeyHash = new bytes(32);
746         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
747         assembly {
748             mstore(unonce, 0x20)
749             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
750             mstore(sessionKeyHash, 0x20)
751             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
752         }
753         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
754         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
755         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
756         return queryId;
757     }
758 
759     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
760         oraclize_randomDS_args[queryId] = commitment;
761     }
762 
763     mapping(bytes32=>bytes32) oraclize_randomDS_args;
764     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
765 
766     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
767         bool sigok;
768         address signer;
769 
770         bytes32 sigr;
771         bytes32 sigs;
772 
773         bytes memory sigr_ = new bytes(32);
774         uint offset = 4+(uint(dersig[3]) - 0x20);
775         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
776         bytes memory sigs_ = new bytes(32);
777         offset += 32 + 2;
778         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
779 
780         assembly {
781             sigr := mload(add(sigr_, 32))
782             sigs := mload(add(sigs_, 32))
783         }
784 
785 
786         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
787         if (address(sha3(pubkey)) == signer) return true;
788         else {
789             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
790             return (address(sha3(pubkey)) == signer);
791         }
792     }
793 
794     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
795         bool sigok;
796 
797         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
798         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
799         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
800 
801         bytes memory appkey1_pubkey = new bytes(64);
802         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
803 
804         bytes memory tosign2 = new bytes(1+65+32);
805         tosign2[0] = 1; //role
806         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
807         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
808         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
809         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
810 
811         if (sigok == false) return false;
812 
813 
814         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
815         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
816 
817         bytes memory tosign3 = new bytes(1+65);
818         tosign3[0] = 0xFE;
819         copyBytes(proof, 3, 65, tosign3, 1);
820 
821         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
822         copyBytes(proof, 3+65, sig3.length, sig3, 0);
823 
824         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
825 
826         return sigok;
827     }
828 
829     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
830         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
831         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
832 
833         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
834         if (proofVerified == false) throw;
835 
836         _;
837     }
838 
839     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
840         bool match_ = true;
841 
842         for (var i=0; i<prefix.length; i++){
843             if (content[i] != prefix[i]) match_ = false;
844         }
845 
846         return match_;
847     }
848 
849     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
850         bool checkok;
851 
852 
853         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
854         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
855         bytes memory keyhash = new bytes(32);
856         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
857         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
858         if (checkok == false) return false;
859 
860         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
861         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
862 
863 
864         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
865         checkok = matchBytes32Prefix(sha256(sig1), result);
866         if (checkok == false) return false;
867 
868 
869         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
870         // This is to verify that the computed args match with the ones specified in the query.
871         bytes memory commitmentSlice1 = new bytes(8+1+32);
872         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
873 
874         bytes memory sessionPubkey = new bytes(64);
875         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
876         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
877 
878         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
879         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
880             delete oraclize_randomDS_args[queryId];
881         } else return false;
882 
883 
884         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
885         bytes memory tosign1 = new bytes(32+8+1+32);
886         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
887         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
888         if (checkok == false) return false;
889 
890         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
891         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
892             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
893         }
894 
895         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
896     }
897 
898 
899     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
900     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
901         uint minLength = length + toOffset;
902 
903         if (to.length < minLength) {
904             // Buffer too small
905             throw; // Should be a better way?
906         }
907 
908         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
909         uint i = 32 + fromOffset;
910         uint j = 32 + toOffset;
911 
912         while (i < (32 + fromOffset + length)) {
913             assembly {
914                 let tmp := mload(add(from, i))
915                 mstore(add(to, j), tmp)
916             }
917             i += 32;
918             j += 32;
919         }
920 
921         return to;
922     }
923 
924     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
925     // Duplicate Solidity's ecrecover, but catching the CALL return value
926     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
927         // We do our own memory management here. Solidity uses memory offset
928         // 0x40 to store the current end of memory. We write past it (as
929         // writes are memory extensions), but don't update the offset so
930         // Solidity will reuse it. The memory used here is only needed for
931         // this context.
932 
933         // FIXME: inline assembly can't access return values
934         bool ret;
935         address addr;
936 
937         assembly {
938             let size := mload(0x40)
939             mstore(size, hash)
940             mstore(add(size, 32), v)
941             mstore(add(size, 64), r)
942             mstore(add(size, 96), s)
943 
944             // NOTE: we can reuse the request memory because we deal with
945             //       the return code
946             ret := call(3000, 1, 0, size, 128, size, 32)
947             addr := mload(size)
948         }
949 
950         return (ret, addr);
951     }
952 
953     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
954     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
955         bytes32 r;
956         bytes32 s;
957         uint8 v;
958 
959         if (sig.length != 65)
960           return (false, 0);
961 
962         // The signature format is a compact form of:
963         //   {bytes32 r}{bytes32 s}{uint8 v}
964         // Compact means, uint8 is not padded to 32 bytes.
965         assembly {
966             r := mload(add(sig, 32))
967             s := mload(add(sig, 64))
968 
969             // Here we are loading the last 32 bytes. We exploit the fact that
970             // 'mload' will pad with zeroes if we overread.
971             // There is no 'mload8' to do this, but that would be nicer.
972             v := byte(0, mload(add(sig, 96)))
973 
974             // Alternative solution:
975             // 'byte' is not working due to the Solidity parser, so lets
976             // use the second best option, 'and'
977             // v := and(mload(add(sig, 65)), 255)
978         }
979 
980         // albeit non-transactional signatures are not specified by the YP, one would expect it
981         // to match the YP range of [27, 28]
982         //
983         // geth uses [0, 1] and some clients have followed. This might change, see:
984         //  https://github.com/ethereum/go-ethereum/issues/2053
985         if (v < 27)
986           v += 27;
987 
988         if (v != 27 && v != 28)
989             return (false, 0);
990 
991         return safer_ecrecover(hash, v, r, s);
992     }
993 
994 }
995 // </ORACLIZE_API>
996 
997 library strings {
998     struct slice {
999         uint _len;
1000         uint _ptr;
1001     }
1002 
1003     function memcpy(uint dest, uint src, uint len) private pure {
1004         // Copy word-length chunks while possible
1005         for(; len >= 32; len -= 32) {
1006             assembly {
1007                 mstore(dest, mload(src))
1008             }
1009             dest += 32;
1010             src += 32;
1011         }
1012 
1013         // Copy remaining bytes
1014         uint mask = 256 ** (32 - len) - 1;
1015         assembly {
1016             let srcpart := and(mload(src), not(mask))
1017             let destpart := and(mload(dest), mask)
1018             mstore(dest, or(destpart, srcpart))
1019         }
1020     }
1021 
1022     /*
1023      * @dev Returns a slice containing the entire string.
1024      * @param self The string to make a slice from.
1025      * @return A newly allocated slice containing the entire string.
1026      */
1027     function toSlice(string self) internal pure returns (slice) {
1028         uint ptr;
1029         assembly {
1030             ptr := add(self, 0x20)
1031         }
1032         return slice(bytes(self).length, ptr);
1033     }
1034 
1035     /*
1036      * @dev Returns the length of a null-terminated bytes32 string.
1037      * @param self The value to find the length of.
1038      * @return The length of the string, from 0 to 32.
1039      */
1040     function len(bytes32 self) internal pure returns (uint) {
1041         uint ret;
1042         if (self == 0)
1043             return 0;
1044         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1045             ret += 16;
1046             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1047         }
1048         if (self & 0xffffffffffffffff == 0) {
1049             ret += 8;
1050             self = bytes32(uint(self) / 0x10000000000000000);
1051         }
1052         if (self & 0xffffffff == 0) {
1053             ret += 4;
1054             self = bytes32(uint(self) / 0x100000000);
1055         }
1056         if (self & 0xffff == 0) {
1057             ret += 2;
1058             self = bytes32(uint(self) / 0x10000);
1059         }
1060         if (self & 0xff == 0) {
1061             ret += 1;
1062         }
1063         return 32 - ret;
1064     }
1065 
1066     /*
1067      * @dev Returns a slice containing the entire bytes32, interpreted as a
1068      *      null-terminated utf-8 string.
1069      * @param self The bytes32 value to convert to a slice.
1070      * @return A new slice containing the value of the input argument up to the
1071      *         first null.
1072      */
1073     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
1074         // Allocate space for `self` in memory, copy it there, and point ret at it
1075         assembly {
1076             let ptr := mload(0x40)
1077             mstore(0x40, add(ptr, 0x20))
1078             mstore(ptr, self)
1079             mstore(add(ret, 0x20), ptr)
1080         }
1081         ret._len = len(self);
1082     }
1083 
1084     /*
1085      * @dev Returns a new slice containing the same data as the current slice.
1086      * @param self The slice to copy.
1087      * @return A new slice containing the same data as `self`.
1088      */
1089     function copy(slice self) internal pure returns (slice) {
1090         return slice(self._len, self._ptr);
1091     }
1092 
1093     /*
1094      * @dev Copies a slice to a new string.
1095      * @param self The slice to copy.
1096      * @return A newly allocated string containing the slice's text.
1097      */
1098     function toString(slice self) internal pure returns (string) {
1099         string memory ret = new string(self._len);
1100         uint retptr;
1101         assembly { retptr := add(ret, 32) }
1102 
1103         memcpy(retptr, self._ptr, self._len);
1104         return ret;
1105     }
1106 
1107     /*
1108      * @dev Returns the length in runes of the slice. Note that this operation
1109      *      takes time proportional to the length of the slice; avoid using it
1110      *      in loops, and call `slice.empty()` if you only need to know whether
1111      *      the slice is empty or not.
1112      * @param self The slice to operate on.
1113      * @return The length of the slice in runes.
1114      */
1115     function len(slice self) internal pure returns (uint l) {
1116         // Starting at ptr-31 means the LSB will be the byte we care about
1117         uint ptr = self._ptr - 31;
1118         uint end = ptr + self._len;
1119         for (l = 0; ptr < end; l++) {
1120             uint8 b;
1121             assembly { b := and(mload(ptr), 0xFF) }
1122             if (b < 0x80) {
1123                 ptr += 1;
1124             } else if(b < 0xE0) {
1125                 ptr += 2;
1126             } else if(b < 0xF0) {
1127                 ptr += 3;
1128             } else if(b < 0xF8) {
1129                 ptr += 4;
1130             } else if(b < 0xFC) {
1131                 ptr += 5;
1132             } else {
1133                 ptr += 6;
1134             }
1135         }
1136     }
1137 
1138     /*
1139      * @dev Returns true if the slice is empty (has a length of 0).
1140      * @param self The slice to operate on.
1141      * @return True if the slice is empty, False otherwise.
1142      */
1143     function empty(slice self) internal pure returns (bool) {
1144         return self._len == 0;
1145     }
1146 
1147     /*
1148      * @dev Returns a positive number if `other` comes lexicographically after
1149      *      `self`, a negative number if it comes before, or zero if the
1150      *      contents of the two slices are equal. Comparison is done per-rune,
1151      *      on unicode codepoints.
1152      * @param self The first slice to compare.
1153      * @param other The second slice to compare.
1154      * @return The result of the comparison.
1155      */
1156     function compare(slice self, slice other) internal pure returns (int) {
1157         uint shortest = self._len;
1158         if (other._len < self._len)
1159             shortest = other._len;
1160 
1161         uint selfptr = self._ptr;
1162         uint otherptr = other._ptr;
1163         for (uint idx = 0; idx < shortest; idx += 32) {
1164             uint a;
1165             uint b;
1166             assembly {
1167                 a := mload(selfptr)
1168                 b := mload(otherptr)
1169             }
1170             if (a != b) {
1171                 // Mask out irrelevant bytes and check again
1172                 uint256 mask = uint256(-1); // 0xffff...
1173                 if(shortest < 32) {
1174                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1175                 }
1176                 uint256 diff = (a & mask) - (b & mask);
1177                 if (diff != 0)
1178                     return int(diff);
1179             }
1180             selfptr += 32;
1181             otherptr += 32;
1182         }
1183         return int(self._len) - int(other._len);
1184     }
1185 
1186     /*
1187      * @dev Returns true if the two slices contain the same text.
1188      * @param self The first slice to compare.
1189      * @param self The second slice to compare.
1190      * @return True if the slices are equal, false otherwise.
1191      */
1192     function equals(slice self, slice other) internal pure returns (bool) {
1193         return compare(self, other) == 0;
1194     }
1195 
1196     /*
1197      * @dev Extracts the first rune in the slice into `rune`, advancing the
1198      *      slice to point to the next rune and returning `self`.
1199      * @param self The slice to operate on.
1200      * @param rune The slice that will contain the first rune.
1201      * @return `rune`.
1202      */
1203     function nextRune(slice self, slice rune) internal pure returns (slice) {
1204         rune._ptr = self._ptr;
1205 
1206         if (self._len == 0) {
1207             rune._len = 0;
1208             return rune;
1209         }
1210 
1211         uint l;
1212         uint b;
1213         // Load the first byte of the rune into the LSBs of b
1214         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1215         if (b < 0x80) {
1216             l = 1;
1217         } else if(b < 0xE0) {
1218             l = 2;
1219         } else if(b < 0xF0) {
1220             l = 3;
1221         } else {
1222             l = 4;
1223         }
1224 
1225         // Check for truncated codepoints
1226         if (l > self._len) {
1227             rune._len = self._len;
1228             self._ptr += self._len;
1229             self._len = 0;
1230             return rune;
1231         }
1232 
1233         self._ptr += l;
1234         self._len -= l;
1235         rune._len = l;
1236         return rune;
1237     }
1238 
1239     /*
1240      * @dev Returns the first rune in the slice, advancing the slice to point
1241      *      to the next rune.
1242      * @param self The slice to operate on.
1243      * @return A slice containing only the first rune from `self`.
1244      */
1245     function nextRune(slice self) internal pure returns (slice ret) {
1246         nextRune(self, ret);
1247     }
1248 
1249     /*
1250      * @dev Returns the number of the first codepoint in the slice.
1251      * @param self The slice to operate on.
1252      * @return The number of the first codepoint in the slice.
1253      */
1254     function ord(slice self) internal pure returns (uint ret) {
1255         if (self._len == 0) {
1256             return 0;
1257         }
1258 
1259         uint word;
1260         uint length;
1261         uint divisor = 2 ** 248;
1262 
1263         // Load the rune into the MSBs of b
1264         assembly { word:= mload(mload(add(self, 32))) }
1265         uint b = word / divisor;
1266         if (b < 0x80) {
1267             ret = b;
1268             length = 1;
1269         } else if(b < 0xE0) {
1270             ret = b & 0x1F;
1271             length = 2;
1272         } else if(b < 0xF0) {
1273             ret = b & 0x0F;
1274             length = 3;
1275         } else {
1276             ret = b & 0x07;
1277             length = 4;
1278         }
1279 
1280         // Check for truncated codepoints
1281         if (length > self._len) {
1282             return 0;
1283         }
1284 
1285         for (uint i = 1; i < length; i++) {
1286             divisor = divisor / 256;
1287             b = (word / divisor) & 0xFF;
1288             if (b & 0xC0 != 0x80) {
1289                 // Invalid UTF-8 sequence
1290                 return 0;
1291             }
1292             ret = (ret * 64) | (b & 0x3F);
1293         }
1294 
1295         return ret;
1296     }
1297 
1298     /*
1299      * @dev Returns the keccak-256 hash of the slice.
1300      * @param self The slice to hash.
1301      * @return The hash of the slice.
1302      */
1303     function keccak(slice self) internal pure returns (bytes32 ret) {
1304         assembly {
1305             ret := keccak256(mload(add(self, 32)), mload(self))
1306         }
1307     }
1308 
1309     /*
1310      * @dev Returns true if `self` starts with `needle`.
1311      * @param self The slice to operate on.
1312      * @param needle The slice to search for.
1313      * @return True if the slice starts with the provided text, false otherwise.
1314      */
1315     function startsWith(slice self, slice needle) internal pure returns (bool) {
1316         if (self._len < needle._len) {
1317             return false;
1318         }
1319 
1320         if (self._ptr == needle._ptr) {
1321             return true;
1322         }
1323 
1324         bool equal;
1325         assembly {
1326             let length := mload(needle)
1327             let selfptr := mload(add(self, 0x20))
1328             let needleptr := mload(add(needle, 0x20))
1329             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1330         }
1331         return equal;
1332     }
1333 
1334     /*
1335      * @dev If `self` starts with `needle`, `needle` is removed from the
1336      *      beginning of `self`. Otherwise, `self` is unmodified.
1337      * @param self The slice to operate on.
1338      * @param needle The slice to search for.
1339      * @return `self`
1340      */
1341     function beyond(slice self, slice needle) internal pure returns (slice) {
1342         if (self._len < needle._len) {
1343             return self;
1344         }
1345 
1346         bool equal = true;
1347         if (self._ptr != needle._ptr) {
1348             assembly {
1349                 let length := mload(needle)
1350                 let selfptr := mload(add(self, 0x20))
1351                 let needleptr := mload(add(needle, 0x20))
1352                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
1353             }
1354         }
1355 
1356         if (equal) {
1357             self._len -= needle._len;
1358             self._ptr += needle._len;
1359         }
1360 
1361         return self;
1362     }
1363 
1364     /*
1365      * @dev Returns true if the slice ends with `needle`.
1366      * @param self The slice to operate on.
1367      * @param needle The slice to search for.
1368      * @return True if the slice starts with the provided text, false otherwise.
1369      */
1370     function endsWith(slice self, slice needle) internal pure returns (bool) {
1371         if (self._len < needle._len) {
1372             return false;
1373         }
1374 
1375         uint selfptr = self._ptr + self._len - needle._len;
1376 
1377         if (selfptr == needle._ptr) {
1378             return true;
1379         }
1380 
1381         bool equal;
1382         assembly {
1383             let length := mload(needle)
1384             let needleptr := mload(add(needle, 0x20))
1385             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1386         }
1387 
1388         return equal;
1389     }
1390 
1391     /*
1392      * @dev If `self` ends with `needle`, `needle` is removed from the
1393      *      end of `self`. Otherwise, `self` is unmodified.
1394      * @param self The slice to operate on.
1395      * @param needle The slice to search for.
1396      * @return `self`
1397      */
1398     function until(slice self, slice needle) internal pure returns (slice) {
1399         if (self._len < needle._len) {
1400             return self;
1401         }
1402 
1403         uint selfptr = self._ptr + self._len - needle._len;
1404         bool equal = true;
1405         if (selfptr != needle._ptr) {
1406             assembly {
1407                 let length := mload(needle)
1408                 let needleptr := mload(add(needle, 0x20))
1409                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1410             }
1411         }
1412 
1413         if (equal) {
1414             self._len -= needle._len;
1415         }
1416 
1417         return self;
1418     }
1419 
1420     event log_bytemask(bytes32 mask);
1421 
1422     // Returns the memory address of the first byte of the first occurrence of
1423     // `needle` in `self`, or the first byte after `self` if not found.
1424     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1425         uint ptr = selfptr;
1426         uint idx;
1427 
1428         if (needlelen <= selflen) {
1429             if (needlelen <= 32) {
1430                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1431 
1432                 bytes32 needledata;
1433                 assembly { needledata := and(mload(needleptr), mask) }
1434 
1435                 uint end = selfptr + selflen - needlelen;
1436                 bytes32 ptrdata;
1437                 assembly { ptrdata := and(mload(ptr), mask) }
1438 
1439                 while (ptrdata != needledata) {
1440                     if (ptr >= end)
1441                         return selfptr + selflen;
1442                     ptr++;
1443                     assembly { ptrdata := and(mload(ptr), mask) }
1444                 }
1445                 return ptr;
1446             } else {
1447                 // For long needles, use hashing
1448                 bytes32 hash;
1449                 assembly { hash := sha3(needleptr, needlelen) }
1450 
1451                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1452                     bytes32 testHash;
1453                     assembly { testHash := sha3(ptr, needlelen) }
1454                     if (hash == testHash)
1455                         return ptr;
1456                     ptr += 1;
1457                 }
1458             }
1459         }
1460         return selfptr + selflen;
1461     }
1462 
1463     // Returns the memory address of the first byte after the last occurrence of
1464     // `needle` in `self`, or the address of `self` if not found.
1465     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1466         uint ptr;
1467 
1468         if (needlelen <= selflen) {
1469             if (needlelen <= 32) {
1470                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1471 
1472                 bytes32 needledata;
1473                 assembly { needledata := and(mload(needleptr), mask) }
1474 
1475                 ptr = selfptr + selflen - needlelen;
1476                 bytes32 ptrdata;
1477                 assembly { ptrdata := and(mload(ptr), mask) }
1478 
1479                 while (ptrdata != needledata) {
1480                     if (ptr <= selfptr)
1481                         return selfptr;
1482                     ptr--;
1483                     assembly { ptrdata := and(mload(ptr), mask) }
1484                 }
1485                 return ptr + needlelen;
1486             } else {
1487                 // For long needles, use hashing
1488                 bytes32 hash;
1489                 assembly { hash := sha3(needleptr, needlelen) }
1490                 ptr = selfptr + (selflen - needlelen);
1491                 while (ptr >= selfptr) {
1492                     bytes32 testHash;
1493                     assembly { testHash := sha3(ptr, needlelen) }
1494                     if (hash == testHash)
1495                         return ptr + needlelen;
1496                     ptr -= 1;
1497                 }
1498             }
1499         }
1500         return selfptr;
1501     }
1502 
1503     /*
1504      * @dev Modifies `self` to contain everything from the first occurrence of
1505      *      `needle` to the end of the slice. `self` is set to the empty slice
1506      *      if `needle` is not found.
1507      * @param self The slice to search and modify.
1508      * @param needle The text to search for.
1509      * @return `self`.
1510      */
1511     function find(slice self, slice needle) internal pure returns (slice) {
1512         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1513         self._len -= ptr - self._ptr;
1514         self._ptr = ptr;
1515         return self;
1516     }
1517 
1518     /*
1519      * @dev Modifies `self` to contain the part of the string from the start of
1520      *      `self` to the end of the first occurrence of `needle`. If `needle`
1521      *      is not found, `self` is set to the empty slice.
1522      * @param self The slice to search and modify.
1523      * @param needle The text to search for.
1524      * @return `self`.
1525      */
1526     function rfind(slice self, slice needle) internal pure returns (slice) {
1527         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1528         self._len = ptr - self._ptr;
1529         return self;
1530     }
1531 
1532     /*
1533      * @dev Splits the slice, setting `self` to everything after the first
1534      *      occurrence of `needle`, and `token` to everything before it. If
1535      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1536      *      and `token` is set to the entirety of `self`.
1537      * @param self The slice to split.
1538      * @param needle The text to search for in `self`.
1539      * @param token An output parameter to which the first token is written.
1540      * @return `token`.
1541      */
1542     function split(slice self, slice needle, slice token) internal pure returns (slice) {
1543         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1544         token._ptr = self._ptr;
1545         token._len = ptr - self._ptr;
1546         if (ptr == self._ptr + self._len) {
1547             // Not found
1548             self._len = 0;
1549         } else {
1550             self._len -= token._len + needle._len;
1551             self._ptr = ptr + needle._len;
1552         }
1553         return token;
1554     }
1555 
1556     /*
1557      * @dev Splits the slice, setting `self` to everything after the first
1558      *      occurrence of `needle`, and returning everything before it. If
1559      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1560      *      and the entirety of `self` is returned.
1561      * @param self The slice to split.
1562      * @param needle The text to search for in `self`.
1563      * @return The part of `self` up to the first occurrence of `delim`.
1564      */
1565     function split(slice self, slice needle) internal pure returns (slice token) {
1566         split(self, needle, token);
1567     }
1568 
1569     /*
1570      * @dev Splits the slice, setting `self` to everything before the last
1571      *      occurrence of `needle`, and `token` to everything after it. If
1572      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1573      *      and `token` is set to the entirety of `self`.
1574      * @param self The slice to split.
1575      * @param needle The text to search for in `self`.
1576      * @param token An output parameter to which the first token is written.
1577      * @return `token`.
1578      */
1579     function rsplit(slice self, slice needle, slice token) internal pure returns (slice) {
1580         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1581         token._ptr = ptr;
1582         token._len = self._len - (ptr - self._ptr);
1583         if (ptr == self._ptr) {
1584             // Not found
1585             self._len = 0;
1586         } else {
1587             self._len -= token._len + needle._len;
1588         }
1589         return token;
1590     }
1591 
1592     /*
1593      * @dev Splits the slice, setting `self` to everything before the last
1594      *      occurrence of `needle`, and returning everything after it. If
1595      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1596      *      and the entirety of `self` is returned.
1597      * @param self The slice to split.
1598      * @param needle The text to search for in `self`.
1599      * @return The part of `self` after the last occurrence of `delim`.
1600      */
1601     function rsplit(slice self, slice needle) internal pure returns (slice token) {
1602         rsplit(self, needle, token);
1603     }
1604 
1605     /*
1606      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1607      * @param self The slice to search.
1608      * @param needle The text to search for in `self`.
1609      * @return The number of occurrences of `needle` found in `self`.
1610      */
1611     function count(slice self, slice needle) internal pure returns (uint cnt) {
1612         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1613         while (ptr <= self._ptr + self._len) {
1614             cnt++;
1615             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1616         }
1617     }
1618 
1619     /*
1620      * @dev Returns True if `self` contains `needle`.
1621      * @param self The slice to search.
1622      * @param needle The text to search for in `self`.
1623      * @return True if `needle` is found in `self`, false otherwise.
1624      */
1625     function contains(slice self, slice needle) internal pure returns (bool) {
1626         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1627     }
1628 
1629     /*
1630      * @dev Returns a newly allocated string containing the concatenation of
1631      *      `self` and `other`.
1632      * @param self The first slice to concatenate.
1633      * @param other The second slice to concatenate.
1634      * @return The concatenation of the two strings.
1635      */
1636     function concat(slice self, slice other) internal pure returns (string) {
1637         string memory ret = new string(self._len + other._len);
1638         uint retptr;
1639         assembly { retptr := add(ret, 32) }
1640         memcpy(retptr, self._ptr, self._len);
1641         memcpy(retptr + self._len, other._ptr, other._len);
1642         return ret;
1643     }
1644 
1645     /*
1646      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1647      *      newly allocated string.
1648      * @param self The delimiter to use.
1649      * @param parts A list of slices to join.
1650      * @return A newly allocated string containing all the slices in `parts`,
1651      *         joined with `self`.
1652      */
1653     function join(slice self, slice[] parts) internal pure returns (string) {
1654         if (parts.length == 0)
1655             return "";
1656 
1657         uint length = self._len * (parts.length - 1);
1658         for(uint i = 0; i < parts.length; i++)
1659             length += parts[i]._len;
1660 
1661         string memory ret = new string(length);
1662         uint retptr;
1663         assembly { retptr := add(ret, 32) }
1664 
1665         for(i = 0; i < parts.length; i++) {
1666             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1667             retptr += parts[i]._len;
1668             if (i < parts.length - 1) {
1669                 memcpy(retptr, self._ptr, self._len);
1670                 retptr += self._len;
1671             }
1672         }
1673 
1674         return ret;
1675     }
1676 }
1677 
1678 library SafeMath {
1679     function safeMul(uint a, uint b) internal returns (uint) {
1680         uint c = a * b;
1681         require(a == 0 || c / a == b);
1682         return c;
1683     }
1684 
1685     function safeDiv(uint a, uint b) internal returns (uint) {
1686         require(b > 0);
1687         uint c = a / b;
1688         require(a == b * c + a % b);
1689         return c;
1690     }
1691 
1692     function safeSub(uint a, uint b) internal returns (uint) {
1693         require(b <= a);
1694         return a - b;
1695     }
1696 
1697     function safeAdd(uint a, uint b) internal returns (uint) {
1698         uint c = a + b;
1699         require(c>=a && c>=b);
1700         return c;
1701     }
1702 }
1703 
1704 library AddressSetLib {
1705 
1706     struct AddressSet {
1707         address[] values;
1708         mapping(address => bool) exists;
1709         mapping(address => uint) indices;
1710     }
1711 
1712     modifier inBounds(AddressSet storage self, uint index) {
1713         require(index < self.values.length);
1714         _;
1715     }
1716 
1717     modifier notEmpty(AddressSet storage self) {
1718         require(self.values.length != 0);
1719         _;
1720     }
1721 
1722     function get(AddressSet storage self, uint index) public constant
1723         inBounds(self, index)
1724         returns (address)
1725     {
1726         return self.values[index];
1727     }
1728 
1729     function set(AddressSet storage self, uint index, address value) public
1730         inBounds(self, index)
1731         returns (bool)
1732     {
1733         if (self.exists[value])
1734             return false;
1735         self.values[index] = value;
1736         self.exists[value] = true;
1737         self.indices[value] = index;
1738         return true;
1739     }
1740 
1741     function add(AddressSet storage self, address value) public
1742         returns (bool)
1743     {
1744         if (self.exists[value])
1745             return false;
1746         self.indices[value] = self.values.length;
1747         self.values.push(value);
1748         self.exists[value] = true;
1749         return true;
1750     }
1751 
1752     function remove(AddressSet storage self, address value) public
1753         returns (bool)
1754     {
1755         if (!self.exists[value])
1756             return false;
1757         uint index = indexOf(self, value);
1758         pop(self, index);
1759         return true;
1760     }
1761 
1762     function pop(AddressSet storage self, uint index) public
1763         inBounds(self, index)
1764         returns (address)
1765     {
1766         address value = get(self, index);
1767 
1768         if (index != self.values.length - 1) {
1769             address lastValue = last(self);
1770             self.exists[lastValue] = false;
1771             set(self, index, lastValue);
1772             self.indices[lastValue] = index;
1773         }
1774         self.values.length -= 1;
1775 
1776         delete self.indices[value];
1777         delete self.exists[value];
1778 
1779         return value;
1780     }
1781 
1782     function first(AddressSet storage self) public constant
1783         notEmpty(self)
1784         returns (address)
1785     {
1786         return get(self, 0);
1787     }
1788 
1789     function last(AddressSet storage self) public constant
1790         notEmpty(self)
1791         returns (address)
1792     {
1793         return get(self, self.values.length - 1);
1794     }
1795 
1796     function indexOf(AddressSet storage self, address value) public constant
1797         returns (uint)
1798     {
1799         if (!self.exists[value])
1800             return uint(-1);
1801         return self.indices[value];
1802     }
1803 
1804     function contains(AddressSet storage self, address value) public constant
1805         returns (bool)
1806     {
1807         return self.exists[value];
1808     }
1809 
1810     function size(AddressSet storage self) public constant
1811         returns (uint)
1812     {
1813         return self.values.length;
1814     }
1815 }
1816 
1817 contract Ownable {
1818     address public owner;
1819 
1820     function Ownable() {
1821         owner = msg.sender;
1822     }
1823 
1824     modifier onlyOwner {
1825         require(msg.sender == owner);
1826         _;
1827     }
1828 }
1829 
1830 contract MultiOwnable
1831 {
1832     mapping(address => bool) public isAdmin;
1833 
1834     event LogAddAdmin(address whoAdded, address newAdmin);
1835 
1836     function addAdmin(address admin) public onlyAdmin returns (bool ok)
1837     {
1838         require(isAdmin[admin] == false);
1839         isAdmin[admin] = true;
1840 
1841         LogAddAdmin(msg.sender, admin);
1842         return true;
1843     }
1844 
1845     modifier onlyAdmin {
1846         require(isAdmin[msg.sender]);
1847         _;
1848     }
1849 }
1850 
1851 contract IPredictionMarket {
1852     mapping(address => bool) public isAdmin;
1853 }
1854 
1855 contract Question is Ownable, usingOraclize
1856 {
1857     using SafeMath for uint;
1858     using strings for *;
1859 
1860     string public questionStr;
1861     bool public finalized;
1862     string public finalResultStr; 
1863     uint public finalResult;   // win:1,lose: 2, tie:3
1864     uint public visitorTeamScore;
1865     uint public localTeamScore;
1866     bool public firstWithdraw;
1867     address private devCutReceiver;
1868 
1869     enum Vote { None, Win, Lose, Tie }
1870 
1871     struct Bet {
1872         address bettor;
1873         mapping(uint => uint) vote;
1874         uint amount;
1875         bool withdrawn;
1876     }
1877 
1878     uint public betDeadlineBlock;
1879     uint public finalizeStartTime;
1880     uint public winFunds;
1881     uint public loseFunds;
1882     uint public tieFunds;
1883     string internal queryStr;
1884     uint public devCut;
1885 
1886     mapping(address => Bet) public bets;
1887 
1888     event LogBet(address bettor, Vote vote, uint betAmount);
1889     event LogWithdraw(address who, uint amount);
1890 
1891     event LogFinalize(address who);
1892 
1893     function Question(address _owner, string _questionStr, uint _betDeadline, uint _finalizeStartTime, string _queryStr)
1894         public
1895     {
1896         devCutReceiver = _owner;
1897         firstWithdraw = true;
1898         questionStr = _questionStr;
1899         betDeadlineBlock = _betDeadline;
1900         finalizeStartTime = _finalizeStartTime;
1901         queryStr = _queryStr;
1902     }
1903 
1904     function kill(address recipient) public onlyAdmin returns (bool ok) {
1905         selfdestruct(recipient);
1906         return true;
1907     }
1908 
1909     function resetFinalize() public onlyAdmin returns (bool ok) {
1910         finalized = false;
1911         return true;
1912     }
1913 
1914     function bet(uint yesOrNo) public payable returns (bool ok) {
1915         require(msg.value >= 0.01 ether);
1916         require(now <= betDeadlineBlock);
1917 
1918         Vote betVote;
1919         if (yesOrNo == 3) {
1920             winFunds = winFunds.safeAdd(msg.value);
1921             betVote = Vote.Win;
1922         } else if (yesOrNo == 1) {
1923             tieFunds = tieFunds.safeAdd(msg.value);
1924             betVote = Vote.Tie;
1925         } else if (yesOrNo == 0) {
1926             loseFunds = loseFunds.safeAdd(msg.value);
1927             betVote = Vote.Lose;
1928         }
1929 
1930         bets[msg.sender].bettor = msg.sender;
1931         bets[msg.sender].vote[uint(betVote)] = bets[msg.sender].vote[uint(betVote)].safeAdd(msg.value);
1932         bets[msg.sender].amount = bets[msg.sender].amount.safeAdd(msg.value);
1933 
1934         LogBet(msg.sender, betVote, msg.value);
1935 
1936         return true;
1937     }
1938 
1939     function withdraw() public returns (bool ok) {
1940         require(now > finalizeStartTime);
1941         require(finalized == true);
1942 
1943         Bet storage theBet = bets[msg.sender];
1944         require(theBet.amount > 0);
1945         require(theBet.withdrawn == false);
1946 
1947         theBet.withdrawn = true;
1948 
1949         uint totalFunds = winFunds.safeAdd(tieFunds).safeAdd(loseFunds);
1950 
1951         if (firstWithdraw) {
1952             if (totalFunds < 10 ether) {
1953                 devCut = totalFunds.safeMul(5).safeDiv(100);
1954                 devCutReceiver.transfer(devCut);
1955                 firstWithdraw = false;
1956             }
1957             else if (totalFunds < 50 ether) {
1958                 devCut = totalFunds.safeMul(4).safeDiv(100);
1959                 devCutReceiver.transfer(devCut);
1960                 firstWithdraw = false;
1961             }
1962             else {
1963                 devCut = totalFunds.safeMul(3).safeDiv(100);
1964                 devCutReceiver.transfer(devCut);
1965                 firstWithdraw = false;
1966             }
1967         }
1968 
1969         totalFunds = totalFunds.safeSub(devCut);
1970 
1971         uint winningVoteFunds;
1972         uint betFunds;
1973 
1974         if (finalResult == 1 ) {
1975             require(theBet.vote[1] > 0);
1976             betFunds = theBet.vote[1];
1977             winningVoteFunds = winFunds;
1978         } else if (finalResult == 2) {
1979             require(theBet.vote[2] > 0);
1980             betFunds = theBet.vote[2];
1981             winningVoteFunds = loseFunds;
1982         } else if (finalResult == 3) {
1983             require(theBet.vote[3] > 0);
1984             betFunds = theBet.vote[3];
1985             winningVoteFunds = tieFunds;
1986         }
1987  
1988         uint withdrawAmount = totalFunds.safeMul(betFunds).safeDiv(winningVoteFunds);
1989 
1990         msg.sender.transfer(withdrawAmount);
1991 
1992         LogWithdraw(msg.sender, withdrawAmount);
1993         return true;
1994     }
1995 
1996     function __callback(bytes32 requestId, string result) {
1997         require(msg.sender == oraclize_cbAddress());
1998         finalResultStr = result;
1999 
2000         var s = finalResultStr.toSlice();
2001         var mid = s.beyond("[".toSlice()).until("]".toSlice());
2002         var delim = ", ".toSlice();
2003         var parts = new string[](mid.count(delim) + 1);
2004         for(uint i = 0; i < parts.length; i++) {
2005             parts[i] = mid.split(delim).toString();
2006         }
2007         localTeamScore = parseInt(parts[0]);
2008         visitorTeamScore = parseInt(parts[1]);
2009 
2010         if (localTeamScore > visitorTeamScore) {
2011             finalResult = 1;
2012         } else if (localTeamScore < visitorTeamScore) {
2013             finalResult = 2;
2014         } else if (localTeamScore == visitorTeamScore) {
2015             finalResult = 3;
2016         }
2017 
2018         if (finalResult != 0) {
2019             finalized = true;
2020         }
2021     }
2022 
2023     function finalize() public payable onlyAdmin {
2024         require(!finalized);
2025         require(now > finalizeStartTime);
2026 
2027         oraclize_query("URL", queryStr);
2028         
2029         LogFinalize(msg.sender);
2030     }
2031 
2032     function getMetadata()
2033         public 
2034         view
2035         returns (string _questionStr, uint _betDeadlineBlock, uint _finalizeStartTime, uint _winFunds, uint _loseFunds, uint _tieFunds, uint _finalResult, bool _finalized, uint _localTeamScore, uint _visitorTeamScore)
2036     {
2037         return (questionStr, betDeadlineBlock, finalizeStartTime, winFunds, loseFunds, tieFunds, finalResult, finalized, localTeamScore, visitorTeamScore);
2038     }
2039 
2040     function getTheBet(address account)
2041         public 
2042         view 
2043         returns (address _bettor, uint _winFunds, uint _loseFunds, uint _tieFunds, uint _amount, bool _withdrawn)
2044     {
2045         return (bets[account].bettor, bets[account].vote[1], bets[account].vote[2], bets[account].vote[3],bets[account].amount, bets[account].withdrawn);
2046     }
2047 
2048     modifier onlyAdmin {
2049         IPredictionMarket mkt = IPredictionMarket(owner);
2050         require(mkt.isAdmin(msg.sender));
2051         _;
2052     }
2053 }
2054 
2055 contract PredictionMarket is MultiOwnable
2056 {
2057     using AddressSetLib for AddressSetLib.AddressSet;
2058 
2059     mapping(bytes32 => bool) public questionHasBeenAsked;
2060     AddressSetLib.AddressSet questions;
2061 
2062     event LogAddQuestion(address whoAdded, address questionAddress, string questionStr, uint betDeadlineBlock, uint finalizeStartTime);
2063 
2064     function PredictionMarket() {
2065         isAdmin[msg.sender] = true;
2066     }
2067 
2068     function kill(address recipient) public onlyAdmin returns (bool ok) {
2069         selfdestruct(recipient);
2070         return true;
2071     }
2072 
2073     function addQuestion(string questionStr, uint betDeadline, uint finalizeStartTime, string queryStr) 
2074         public 
2075         onlyAdmin 
2076         returns (bool ok, address questionAddr)
2077     {
2078         require(betDeadline > now);
2079         require(finalizeStartTime > betDeadline);
2080 
2081         bytes32 questionID = keccak256(questionStr);
2082         require(questionHasBeenAsked[questionID] == false);
2083         questionHasBeenAsked[questionID] = true;
2084 
2085         Question question = new Question(msg.sender, questionStr, betDeadline, finalizeStartTime, queryStr);
2086         questions.add(address(question));
2087 
2088         LogAddQuestion(msg.sender, address(question), questionStr, betDeadline, finalizeStartTime);
2089 
2090         return (true, address(question));
2091     }
2092 
2093     function removeQuestion(address addr) public onlyAdmin returns (bool ok) {
2094         questions.remove(addr);
2095         return (true);
2096     }
2097 
2098     function numQuestions() public view returns (uint) {
2099         return questions.size();
2100     }
2101 
2102     function getQuestionIndex(uint i) public view returns (address) {
2103         return questions.get(i);
2104     }
2105 
2106     function getAllQuestionAddresses() public view returns (address[]) {
2107         return questions.values;
2108     }
2109 }