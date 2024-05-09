1 pragma solidity ^0.4.17;
2 
3 // Lottesy 10 ETH lottery
4 // Copyright (c) 2017 Lottesy
5 // ----------------------------------------------------
6 // Send any amount multiple of 0.01 ETH to the address
7 // shown at http://lottesy.com
8 // Win 10 ETH today!
9 // ----------------------------------------------------
10 
11 // We use Oraclize for the drawing
12 // Copyright (c) 2015-2017 Oraclize SRL
13 // Copyright (c) 2017 Oraclize LTD
14 // for more info visit https://oraclize.it
15 
16 contract OraclizeI {
17     address public cbAddress;
18     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
19     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
20     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
21     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
22     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
23     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
24     function getPrice(string _datasource) returns (uint _dsprice);
25     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
26     function useCoupon(string _coupon);
27     function setProofType(byte _proofType);
28     function setConfig(bytes32 _config);
29     function setCustomGasPrice(uint _gasPrice);
30     function randomDS_getSessionPubKeyHash() returns(bytes32);
31 }
32 contract OraclizeAddrResolverI {
33     function getAddress() returns (address _addr);
34 }
35 
36 contract usingOraclize {
37     uint constant day = 60*60*24;
38     uint constant week = 60*60*24*7;
39     uint constant month = 60*60*24*30;
40     byte constant proofType_NONE = 0x00;
41     byte constant proofType_TLSNotary = 0x10;
42     byte constant proofType_Android = 0x20;
43     byte constant proofType_Ledger = 0x30;
44     byte constant proofType_Native = 0xF0;
45     byte constant proofStorage_IPFS = 0x01;
46     uint8 constant networkID_auto = 0;
47     uint8 constant networkID_mainnet = 1;
48     uint8 constant networkID_testnet = 2;
49     uint8 constant networkID_morden = 2;
50     uint8 constant networkID_consensys = 161;
51 
52     OraclizeAddrResolverI OAR;
53 
54     OraclizeI oraclize;
55     modifier oraclizeAPI {
56         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
57         oraclize = OraclizeI(OAR.getAddress());
58         _;
59     }
60     modifier coupon(string code){
61         oraclize = OraclizeI(OAR.getAddress());
62         oraclize.useCoupon(code);
63         _;
64     }
65 
66     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
67         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
68             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
69             oraclize_setNetworkName("eth_mainnet");
70             return true;
71         }
72         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
73             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
74             oraclize_setNetworkName("eth_ropsten3");
75             return true;
76         }
77         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
78             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
79             oraclize_setNetworkName("eth_kovan");
80             return true;
81         }
82         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
83             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
84             oraclize_setNetworkName("eth_rinkeby");
85             return true;
86         }
87         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
88             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
89             return true;
90         }
91         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
92             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
93             return true;
94         }
95         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
96             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
97             return true;
98         }
99         return false;
100     }
101 
102     function __callback(bytes32 myid, string result) {
103         __callback(myid, result, new bytes(0));
104     }
105     function __callback(bytes32 myid, string result, bytes proof) {
106     }
107 
108     function oraclize_useCoupon(string code) oraclizeAPI internal {
109         oraclize.useCoupon(code);
110     }
111 
112     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
113         return oraclize.getPrice(datasource);
114     }
115 
116     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
117         return oraclize.getPrice(datasource, gaslimit);
118     }
119 
120     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
121         uint price = oraclize.getPrice(datasource);
122         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
123         return oraclize.query.value(price)(0, datasource, arg);
124     }
125     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
126         uint price = oraclize.getPrice(datasource);
127         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
128         return oraclize.query.value(price)(timestamp, datasource, arg);
129     }
130     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
131         uint price = oraclize.getPrice(datasource, gaslimit);
132         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
133         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
134     }
135     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
136         uint price = oraclize.getPrice(datasource, gaslimit);
137         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
138         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
139     }
140     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
141         uint price = oraclize.getPrice(datasource);
142         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
143         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
144     }
145     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
146         uint price = oraclize.getPrice(datasource);
147         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
148         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
149     }
150     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
151         uint price = oraclize.getPrice(datasource, gaslimit);
152         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
153         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
154     }
155     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
156         uint price = oraclize.getPrice(datasource, gaslimit);
157         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
158         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
159     }
160     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
161         uint price = oraclize.getPrice(datasource);
162         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
163         bytes memory args = stra2cbor(argN);
164         return oraclize.queryN.value(price)(0, datasource, args);
165     }
166     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
167         uint price = oraclize.getPrice(datasource);
168         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
169         bytes memory args = stra2cbor(argN);
170         return oraclize.queryN.value(price)(timestamp, datasource, args);
171     }
172     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
173         uint price = oraclize.getPrice(datasource, gaslimit);
174         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
175         bytes memory args = stra2cbor(argN);
176         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
177     }
178     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
179         uint price = oraclize.getPrice(datasource, gaslimit);
180         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
181         bytes memory args = stra2cbor(argN);
182         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
183     }
184     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
185         string[] memory dynargs = new string[](1);
186         dynargs[0] = args[0];
187         return oraclize_query(datasource, dynargs);
188     }
189     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
190         string[] memory dynargs = new string[](1);
191         dynargs[0] = args[0];
192         return oraclize_query(timestamp, datasource, dynargs);
193     }
194     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
195         string[] memory dynargs = new string[](1);
196         dynargs[0] = args[0];
197         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
198     }
199     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
200         string[] memory dynargs = new string[](1);
201         dynargs[0] = args[0];
202         return oraclize_query(datasource, dynargs, gaslimit);
203     }
204 
205     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
206         string[] memory dynargs = new string[](2);
207         dynargs[0] = args[0];
208         dynargs[1] = args[1];
209         return oraclize_query(datasource, dynargs);
210     }
211     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
212         string[] memory dynargs = new string[](2);
213         dynargs[0] = args[0];
214         dynargs[1] = args[1];
215         return oraclize_query(timestamp, datasource, dynargs);
216     }
217     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
218         string[] memory dynargs = new string[](2);
219         dynargs[0] = args[0];
220         dynargs[1] = args[1];
221         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
222     }
223     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
224         string[] memory dynargs = new string[](2);
225         dynargs[0] = args[0];
226         dynargs[1] = args[1];
227         return oraclize_query(datasource, dynargs, gaslimit);
228     }
229     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
230         string[] memory dynargs = new string[](3);
231         dynargs[0] = args[0];
232         dynargs[1] = args[1];
233         dynargs[2] = args[2];
234         return oraclize_query(datasource, dynargs);
235     }
236     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
237         string[] memory dynargs = new string[](3);
238         dynargs[0] = args[0];
239         dynargs[1] = args[1];
240         dynargs[2] = args[2];
241         return oraclize_query(timestamp, datasource, dynargs);
242     }
243     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
244         string[] memory dynargs = new string[](3);
245         dynargs[0] = args[0];
246         dynargs[1] = args[1];
247         dynargs[2] = args[2];
248         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
249     }
250     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
251         string[] memory dynargs = new string[](3);
252         dynargs[0] = args[0];
253         dynargs[1] = args[1];
254         dynargs[2] = args[2];
255         return oraclize_query(datasource, dynargs, gaslimit);
256     }
257 
258     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
259         string[] memory dynargs = new string[](4);
260         dynargs[0] = args[0];
261         dynargs[1] = args[1];
262         dynargs[2] = args[2];
263         dynargs[3] = args[3];
264         return oraclize_query(datasource, dynargs);
265     }
266     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
267         string[] memory dynargs = new string[](4);
268         dynargs[0] = args[0];
269         dynargs[1] = args[1];
270         dynargs[2] = args[2];
271         dynargs[3] = args[3];
272         return oraclize_query(timestamp, datasource, dynargs);
273     }
274     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
275         string[] memory dynargs = new string[](4);
276         dynargs[0] = args[0];
277         dynargs[1] = args[1];
278         dynargs[2] = args[2];
279         dynargs[3] = args[3];
280         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
281     }
282     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
283         string[] memory dynargs = new string[](4);
284         dynargs[0] = args[0];
285         dynargs[1] = args[1];
286         dynargs[2] = args[2];
287         dynargs[3] = args[3];
288         return oraclize_query(datasource, dynargs, gaslimit);
289     }
290     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
291         string[] memory dynargs = new string[](5);
292         dynargs[0] = args[0];
293         dynargs[1] = args[1];
294         dynargs[2] = args[2];
295         dynargs[3] = args[3];
296         dynargs[4] = args[4];
297         return oraclize_query(datasource, dynargs);
298     }
299     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
300         string[] memory dynargs = new string[](5);
301         dynargs[0] = args[0];
302         dynargs[1] = args[1];
303         dynargs[2] = args[2];
304         dynargs[3] = args[3];
305         dynargs[4] = args[4];
306         return oraclize_query(timestamp, datasource, dynargs);
307     }
308     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
309         string[] memory dynargs = new string[](5);
310         dynargs[0] = args[0];
311         dynargs[1] = args[1];
312         dynargs[2] = args[2];
313         dynargs[3] = args[3];
314         dynargs[4] = args[4];
315         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
316     }
317     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
318         string[] memory dynargs = new string[](5);
319         dynargs[0] = args[0];
320         dynargs[1] = args[1];
321         dynargs[2] = args[2];
322         dynargs[3] = args[3];
323         dynargs[4] = args[4];
324         return oraclize_query(datasource, dynargs, gaslimit);
325     }
326     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
327         uint price = oraclize.getPrice(datasource);
328         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
329         bytes memory args = ba2cbor(argN);
330         return oraclize.queryN.value(price)(0, datasource, args);
331     }
332     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
333         uint price = oraclize.getPrice(datasource);
334         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
335         bytes memory args = ba2cbor(argN);
336         return oraclize.queryN.value(price)(timestamp, datasource, args);
337     }
338     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
339         uint price = oraclize.getPrice(datasource, gaslimit);
340         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
341         bytes memory args = ba2cbor(argN);
342         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
343     }
344     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
345         uint price = oraclize.getPrice(datasource, gaslimit);
346         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
347         bytes memory args = ba2cbor(argN);
348         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
349     }
350     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
351         bytes[] memory dynargs = new bytes[](1);
352         dynargs[0] = args[0];
353         return oraclize_query(datasource, dynargs);
354     }
355     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
356         bytes[] memory dynargs = new bytes[](1);
357         dynargs[0] = args[0];
358         return oraclize_query(timestamp, datasource, dynargs);
359     }
360     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
361         bytes[] memory dynargs = new bytes[](1);
362         dynargs[0] = args[0];
363         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
364     }
365     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
366         bytes[] memory dynargs = new bytes[](1);
367         dynargs[0] = args[0];
368         return oraclize_query(datasource, dynargs, gaslimit);
369     }
370 
371     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
372         bytes[] memory dynargs = new bytes[](2);
373         dynargs[0] = args[0];
374         dynargs[1] = args[1];
375         return oraclize_query(datasource, dynargs);
376     }
377     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
378         bytes[] memory dynargs = new bytes[](2);
379         dynargs[0] = args[0];
380         dynargs[1] = args[1];
381         return oraclize_query(timestamp, datasource, dynargs);
382     }
383     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
384         bytes[] memory dynargs = new bytes[](2);
385         dynargs[0] = args[0];
386         dynargs[1] = args[1];
387         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
388     }
389     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
390         bytes[] memory dynargs = new bytes[](2);
391         dynargs[0] = args[0];
392         dynargs[1] = args[1];
393         return oraclize_query(datasource, dynargs, gaslimit);
394     }
395     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
396         bytes[] memory dynargs = new bytes[](3);
397         dynargs[0] = args[0];
398         dynargs[1] = args[1];
399         dynargs[2] = args[2];
400         return oraclize_query(datasource, dynargs);
401     }
402     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
403         bytes[] memory dynargs = new bytes[](3);
404         dynargs[0] = args[0];
405         dynargs[1] = args[1];
406         dynargs[2] = args[2];
407         return oraclize_query(timestamp, datasource, dynargs);
408     }
409     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
410         bytes[] memory dynargs = new bytes[](3);
411         dynargs[0] = args[0];
412         dynargs[1] = args[1];
413         dynargs[2] = args[2];
414         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
415     }
416     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
417         bytes[] memory dynargs = new bytes[](3);
418         dynargs[0] = args[0];
419         dynargs[1] = args[1];
420         dynargs[2] = args[2];
421         return oraclize_query(datasource, dynargs, gaslimit);
422     }
423 
424     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
425         bytes[] memory dynargs = new bytes[](4);
426         dynargs[0] = args[0];
427         dynargs[1] = args[1];
428         dynargs[2] = args[2];
429         dynargs[3] = args[3];
430         return oraclize_query(datasource, dynargs);
431     }
432     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
433         bytes[] memory dynargs = new bytes[](4);
434         dynargs[0] = args[0];
435         dynargs[1] = args[1];
436         dynargs[2] = args[2];
437         dynargs[3] = args[3];
438         return oraclize_query(timestamp, datasource, dynargs);
439     }
440     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441         bytes[] memory dynargs = new bytes[](4);
442         dynargs[0] = args[0];
443         dynargs[1] = args[1];
444         dynargs[2] = args[2];
445         dynargs[3] = args[3];
446         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
447     }
448     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
449         bytes[] memory dynargs = new bytes[](4);
450         dynargs[0] = args[0];
451         dynargs[1] = args[1];
452         dynargs[2] = args[2];
453         dynargs[3] = args[3];
454         return oraclize_query(datasource, dynargs, gaslimit);
455     }
456     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
457         bytes[] memory dynargs = new bytes[](5);
458         dynargs[0] = args[0];
459         dynargs[1] = args[1];
460         dynargs[2] = args[2];
461         dynargs[3] = args[3];
462         dynargs[4] = args[4];
463         return oraclize_query(datasource, dynargs);
464     }
465     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
466         bytes[] memory dynargs = new bytes[](5);
467         dynargs[0] = args[0];
468         dynargs[1] = args[1];
469         dynargs[2] = args[2];
470         dynargs[3] = args[3];
471         dynargs[4] = args[4];
472         return oraclize_query(timestamp, datasource, dynargs);
473     }
474     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
475         bytes[] memory dynargs = new bytes[](5);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         dynargs[2] = args[2];
479         dynargs[3] = args[3];
480         dynargs[4] = args[4];
481         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
482     }
483     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
484         bytes[] memory dynargs = new bytes[](5);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         dynargs[2] = args[2];
488         dynargs[3] = args[3];
489         dynargs[4] = args[4];
490         return oraclize_query(datasource, dynargs, gaslimit);
491     }
492 
493     function oraclize_cbAddress() oraclizeAPI internal returns (address){
494         return oraclize.cbAddress();
495     }
496     function oraclize_setProof(byte proofP) oraclizeAPI internal {
497         return oraclize.setProofType(proofP);
498     }
499     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
500         return oraclize.setCustomGasPrice(gasPrice);
501     }
502     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
503         return oraclize.setConfig(config);
504     }
505 
506     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
507         return oraclize.randomDS_getSessionPubKeyHash();
508     }
509 
510     function getCodeSize(address _addr) constant internal returns(uint _size) {
511         assembly {
512             _size := extcodesize(_addr)
513         }
514     }
515 
516     function parseAddr(string _a) internal returns (address){
517         bytes memory tmp = bytes(_a);
518         uint160 iaddr = 0;
519         uint160 b1;
520         uint160 b2;
521         for (uint i=2; i<2+2*20; i+=2){
522             iaddr *= 256;
523             b1 = uint160(tmp[i]);
524             b2 = uint160(tmp[i+1]);
525             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
526             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
527             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
528             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
529             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
530             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
531             iaddr += (b1*16+b2);
532         }
533         return address(iaddr);
534     }
535 
536     function strCompare(string _a, string _b) internal returns (int) {
537         bytes memory a = bytes(_a);
538         bytes memory b = bytes(_b);
539         uint minLength = a.length;
540         if (b.length < minLength) minLength = b.length;
541         for (uint i = 0; i < minLength; i ++)
542             if (a[i] < b[i])
543                 return -1;
544             else if (a[i] > b[i])
545                 return 1;
546         if (a.length < b.length)
547             return -1;
548         else if (a.length > b.length)
549             return 1;
550         else
551             return 0;
552     }
553 
554     function indexOf(string _haystack, string _needle) internal returns (int) {
555         bytes memory h = bytes(_haystack);
556         bytes memory n = bytes(_needle);
557         if(h.length < 1 || n.length < 1 || (n.length > h.length))
558             return -1;
559         else if(h.length > (2**128 -1))
560             return -1;
561         else
562         {
563             uint subindex = 0;
564             for (uint i = 0; i < h.length; i ++)
565             {
566                 if (h[i] == n[0])
567                 {
568                     subindex = 1;
569                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
570                     {
571                         subindex++;
572                     }
573                     if(subindex == n.length)
574                         return int(i);
575                 }
576             }
577             return -1;
578         }
579     }
580 
581     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
582         bytes memory _ba = bytes(_a);
583         bytes memory _bb = bytes(_b);
584         bytes memory _bc = bytes(_c);
585         bytes memory _bd = bytes(_d);
586         bytes memory _be = bytes(_e);
587         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
588         bytes memory babcde = bytes(abcde);
589         uint k = 0;
590         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
591         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
592         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
593         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
594         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
595         return string(babcde);
596     }
597 
598     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
599         return strConcat(_a, _b, _c, _d, "");
600     }
601 
602     function strConcat(string _a, string _b, string _c) internal returns (string) {
603         return strConcat(_a, _b, _c, "", "");
604     }
605 
606     function strConcat(string _a, string _b) internal returns (string) {
607         return strConcat(_a, _b, "", "", "");
608     }
609 
610     // parseInt
611     function parseInt(string _a) internal returns (uint) {
612         return parseInt(_a, 0);
613     }
614 
615     // parseInt(parseFloat*10^_b)
616     function parseInt(string _a, uint _b) internal returns (uint) {
617         bytes memory bresult = bytes(_a);
618         uint mint = 0;
619         bool decimals = false;
620         for (uint i=0; i<bresult.length; i++){
621             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
622                 if (decimals){
623                    if (_b == 0) break;
624                     else _b--;
625                 }
626                 mint *= 10;
627                 mint += uint(bresult[i]) - 48;
628             } else if (bresult[i] == 46) decimals = true;
629         }
630         if (_b > 0) mint *= 10**_b;
631         return mint;
632     }
633 
634     function uint2str(uint i) internal returns (string){
635         if (i == 0) return "0";
636         uint j = i;
637         uint len;
638         while (j != 0){
639             len++;
640             j /= 10;
641         }
642         bytes memory bstr = new bytes(len);
643         uint k = len - 1;
644         while (i != 0){
645             bstr[k--] = byte(48 + i % 10);
646             i /= 10;
647         }
648         return string(bstr);
649     }
650 
651     function stra2cbor(string[] arr) internal returns (bytes) {
652             uint arrlen = arr.length;
653 
654             // get correct cbor output length
655             uint outputlen = 0;
656             bytes[] memory elemArray = new bytes[](arrlen);
657             for (uint i = 0; i < arrlen; i++) {
658                 elemArray[i] = (bytes(arr[i]));
659                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
660             }
661             uint ctr = 0;
662             uint cborlen = arrlen + 0x80;
663             outputlen += byte(cborlen).length;
664             bytes memory res = new bytes(outputlen);
665 
666             while (byte(cborlen).length > ctr) {
667                 res[ctr] = byte(cborlen)[ctr];
668                 ctr++;
669             }
670             for (i = 0; i < arrlen; i++) {
671                 res[ctr] = 0x5F;
672                 ctr++;
673                 for (uint x = 0; x < elemArray[i].length; x++) {
674                     // if there's a bug with larger strings, this may be the culprit
675                     if (x % 23 == 0) {
676                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
677                         elemcborlen += 0x40;
678                         uint lctr = ctr;
679                         while (byte(elemcborlen).length > ctr - lctr) {
680                             res[ctr] = byte(elemcborlen)[ctr - lctr];
681                             ctr++;
682                         }
683                     }
684                     res[ctr] = elemArray[i][x];
685                     ctr++;
686                 }
687                 res[ctr] = 0xFF;
688                 ctr++;
689             }
690             return res;
691         }
692 
693     function ba2cbor(bytes[] arr) internal returns (bytes) {
694             uint arrlen = arr.length;
695 
696             // get correct cbor output length
697             uint outputlen = 0;
698             bytes[] memory elemArray = new bytes[](arrlen);
699             for (uint i = 0; i < arrlen; i++) {
700                 elemArray[i] = (bytes(arr[i]));
701                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
702             }
703             uint ctr = 0;
704             uint cborlen = arrlen + 0x80;
705             outputlen += byte(cborlen).length;
706             bytes memory res = new bytes(outputlen);
707 
708             while (byte(cborlen).length > ctr) {
709                 res[ctr] = byte(cborlen)[ctr];
710                 ctr++;
711             }
712             for (i = 0; i < arrlen; i++) {
713                 res[ctr] = 0x5F;
714                 ctr++;
715                 for (uint x = 0; x < elemArray[i].length; x++) {
716                     // if there's a bug with larger strings, this may be the culprit
717                     if (x % 23 == 0) {
718                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
719                         elemcborlen += 0x40;
720                         uint lctr = ctr;
721                         while (byte(elemcborlen).length > ctr - lctr) {
722                             res[ctr] = byte(elemcborlen)[ctr - lctr];
723                             ctr++;
724                         }
725                     }
726                     res[ctr] = elemArray[i][x];
727                     ctr++;
728                 }
729                 res[ctr] = 0xFF;
730                 ctr++;
731             }
732             return res;
733         }
734 
735 
736     string oraclize_network_name;
737     function oraclize_setNetworkName(string _network_name) internal {
738         oraclize_network_name = _network_name;
739     }
740 
741     function oraclize_getNetworkName() internal returns (string) {
742         return oraclize_network_name;
743     }
744 
745     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
746         if ((_nbytes == 0)||(_nbytes > 32)) throw;
747         bytes memory nbytes = new bytes(1);
748         nbytes[0] = byte(_nbytes);
749         bytes memory unonce = new bytes(32);
750         bytes memory sessionKeyHash = new bytes(32);
751         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
752         assembly {
753             mstore(unonce, 0x20)
754             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
755             mstore(sessionKeyHash, 0x20)
756             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
757         }
758         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
759         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
760         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
761         return queryId;
762     }
763 
764     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
765         oraclize_randomDS_args[queryId] = commitment;
766     }
767 
768     mapping(bytes32=>bytes32) oraclize_randomDS_args;
769     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
770 
771     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
772         bool sigok;
773         address signer;
774 
775         bytes32 sigr;
776         bytes32 sigs;
777 
778         bytes memory sigr_ = new bytes(32);
779         uint offset = 4+(uint(dersig[3]) - 0x20);
780         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
781         bytes memory sigs_ = new bytes(32);
782         offset += 32 + 2;
783         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
784 
785         assembly {
786             sigr := mload(add(sigr_, 32))
787             sigs := mload(add(sigs_, 32))
788         }
789 
790 
791         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
792         if (address(sha3(pubkey)) == signer) return true;
793         else {
794             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
795             return (address(sha3(pubkey)) == signer);
796         }
797     }
798 
799     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
800         bool sigok;
801 
802         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
803         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
804         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
805 
806         bytes memory appkey1_pubkey = new bytes(64);
807         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
808 
809         bytes memory tosign2 = new bytes(1+65+32);
810         tosign2[0] = 1; //role
811         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
812         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
813         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
814         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
815 
816         if (sigok == false) return false;
817 
818 
819         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
820         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
821 
822         bytes memory tosign3 = new bytes(1+65);
823         tosign3[0] = 0xFE;
824         copyBytes(proof, 3, 65, tosign3, 1);
825 
826         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
827         copyBytes(proof, 3+65, sig3.length, sig3, 0);
828 
829         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
830 
831         return sigok;
832     }
833 
834     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
835         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
836         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
837 
838         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
839         if (proofVerified == false) throw;
840 
841         _;
842     }
843 
844     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
845             // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
846            if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
847 
848             bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
849             if (proofVerified == false) return 2;
850 
851             return 0;
852         }
853 
854     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
855         bool match_ = true;
856 
857         for (var i=0; i<prefix.length; i++){
858             if (content[i] != prefix[i]) match_ = false;
859         }
860 
861         return match_;
862     }
863 
864     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
865         bool checkok;
866 
867 
868         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
869         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
870         bytes memory keyhash = new bytes(32);
871         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
872         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
873         if (checkok == false) return false;
874 
875         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
876         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
877 
878 
879         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
880         checkok = matchBytes32Prefix(sha256(sig1), result);
881         if (checkok == false) return false;
882 
883 
884         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
885         // This is to verify that the computed args match with the ones specified in the query.
886         bytes memory commitmentSlice1 = new bytes(8+1+32);
887         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
888 
889         bytes memory sessionPubkey = new bytes(64);
890         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
891         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
892 
893         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
894         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
895             delete oraclize_randomDS_args[queryId];
896         } else return false;
897 
898 
899         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
900         bytes memory tosign1 = new bytes(32+8+1+32);
901         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
902         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
903         if (checkok == false) return false;
904 
905         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
906         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
907             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
908         }
909 
910         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
911     }
912 
913 
914     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
915     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
916         uint minLength = length + toOffset;
917 
918         if (to.length < minLength) {
919             // Buffer too small
920             throw; // Should be a better way?
921         }
922 
923         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
924         uint i = 32 + fromOffset;
925         uint j = 32 + toOffset;
926 
927         while (i < (32 + fromOffset + length)) {
928             assembly {
929                 let tmp := mload(add(from, i))
930                 mstore(add(to, j), tmp)
931             }
932             i += 32;
933             j += 32;
934         }
935 
936         return to;
937     }
938 
939     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
940     // Duplicate Solidity's ecrecover, but catching the CALL return value
941     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
942         // We do our own memory management here. Solidity uses memory offset
943         // 0x40 to store the current end of memory. We write past it (as
944         // writes are memory extensions), but don't update the offset so
945         // Solidity will reuse it. The memory used here is only needed for
946         // this context.
947 
948         // FIXME: inline assembly can't access return values
949         bool ret;
950         address addr;
951 
952         assembly {
953             let size := mload(0x40)
954             mstore(size, hash)
955             mstore(add(size, 32), v)
956             mstore(add(size, 64), r)
957             mstore(add(size, 96), s)
958 
959             // NOTE: we can reuse the request memory because we deal with
960             //       the return code
961             ret := call(3000, 1, 0, size, 128, size, 32)
962             addr := mload(size)
963         }
964 
965         return (ret, addr);
966     }
967 
968     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
969     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
970         bytes32 r;
971         bytes32 s;
972         uint8 v;
973 
974         if (sig.length != 65)
975           return (false, 0);
976 
977         // The signature format is a compact form of:
978         //   {bytes32 r}{bytes32 s}{uint8 v}
979         // Compact means, uint8 is not padded to 32 bytes.
980         assembly {
981             r := mload(add(sig, 32))
982             s := mload(add(sig, 64))
983 
984             // Here we are loading the last 32 bytes. We exploit the fact that
985             // 'mload' will pad with zeroes if we overread.
986             // There is no 'mload8' to do this, but that would be nicer.
987             v := byte(0, mload(add(sig, 96)))
988 
989             // Alternative solution:
990             // 'byte' is not working due to the Solidity parser, so lets
991             // use the second best option, 'and'
992             // v := and(mload(add(sig, 65)), 255)
993         }
994 
995         // albeit non-transactional signatures are not specified by the YP, one would expect it
996         // to match the YP range of [27, 28]
997         //
998         // geth uses [0, 1] and some clients have followed. This might change, see:
999         //  https://github.com/ethereum/go-ethereum/issues/2053
1000         if (v < 27)
1001           v += 27;
1002 
1003         if (v != 27 && v != 28)
1004             return (false, 0);
1005 
1006         return safer_ecrecover(hash, v, r, s);
1007     }
1008 
1009 }
1010 
1011 
1012 // Main * Lottesy 10 ETH lottery * code
1013 
1014 contract Lottesy10eth is usingOraclize {
1015     address LottesyAddress = 0x1EE61945aEE02B15154AB4A5824BA80eC8Ed6F4e;
1016     address public theWinner;
1017     uint public drawingNo = 1;
1018     uint public chanceNo;
1019     uint public winningChance;
1020     uint public globalChanceNo; //hide
1021     uint public forLottesy;
1022     uint public chancesBought;
1023     uint public theWinnernumber;
1024     uint public newGlobalChanceNo;
1025     uint public oraclizeGas = 500000;
1026     uint public randomNumber;
1027     uint public maxRange = 1099;
1028     bool public previousDrawingClosed = true;
1029     bool public isClosed = false;
1030     bool public proofVerifyFailed = false;
1031     bool public gotResult = false;
1032     mapping (uint => address) public globChanceOwner;
1033     mapping (uint => address) public winners;
1034     mapping (uint => uint) public drWinChances;
1035 
1036     function () payable ifNotClosed { //sales
1037         oraclize_setCustomGasPrice(20000000000 wei);
1038         oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof in the constructor
1039         uint N = 2; // number of random bytes we want the datasource to return
1040         uint delay = 0; // number of seconds to wait before the execution takes place
1041         uint callbackGas = oraclizeGas; // amount of gas we want Oraclize to set for the callback function
1042         previousDrawingClosed = false;
1043         bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callbackGas); // this function internally generates the correct oraclize_query and returns its queryId
1044     }
1045 
1046     function __callback(bytes32 _queryId, string _result, bytes _proof) {
1047         gotResult = true;
1048         if (msg.sender != oraclize_cbAddress()) throw;
1049         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
1050           proofVerifyFailed = true;
1051           throw;
1052         } else {
1053         randomNumber = uint(sha3(_result)) % maxRange;
1054         winningChance = randomNumber + 1;
1055         theWinnernumber = (drawingNo-1)*1100 + winningChance;
1056         //theWinner = LottesyAddress; //who is the winner?
1057         //theWinner.transfer (0.001 ether); //send prize to the winner
1058         winners[drawingNo] = LottesyAddress; //winner record
1059         drWinChances[drawingNo] = winningChance; //winning chance record
1060         chanceNo++;
1061         forLottesy = (this.balance);
1062         LottesyAddress.transfer (forLottesy); //Lottesy comission
1063         drawingNo++; //next drawing begins
1064         previousDrawingClosed = true;
1065         }
1066     }
1067 
1068     modifier onlyOwner() {
1069         if (msg.sender != LottesyAddress) {
1070             throw;
1071         }
1072         _;
1073     }
1074 
1075     modifier ifNotClosed () {
1076         if (isClosed == true) {
1077             throw;
1078         }
1079         _;
1080     }
1081 
1082     function emergencyWithdrawal () onlyOwner { // for Beta version only
1083     LottesyAddress.transfer (this.balance);
1084     }
1085 
1086     function addSomeGas () onlyOwner { // for Beta version only
1087     oraclizeGas += 300000;
1088     }
1089 
1090     function closeIt () onlyOwner {
1091     isClosed = true;
1092     }
1093 
1094     function emergencyDrawingReset () onlyOwner { // for Beta version only
1095       oraclize_setProof(proofType_Ledger);
1096       uint N = 2;
1097       uint delay = 0;
1098       uint callbackGas = oraclizeGas;
1099       bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callbackGas);
1100     }
1101 
1102 }