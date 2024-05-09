1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract OraclizeI {
35     address public cbAddress;
36     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
37     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
38     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
39     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
40     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
41     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
42     function getPrice(string _datasource) returns (uint _dsprice);
43     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
44     function useCoupon(string _coupon);
45     function setProofType(byte _proofType);
46     function setConfig(bytes32 _config);
47     function setCustomGasPrice(uint _gasPrice);
48     function randomDS_getSessionPubKeyHash() returns(bytes32);
49 }
50 contract OraclizeAddrResolverI {
51     function getAddress() returns (address _addr);
52 }
53 contract usingOraclize {
54     uint constant day = 60*60*24;
55     uint constant week = 60*60*24*7;
56     uint constant month = 60*60*24*30;
57     byte constant proofType_NONE = 0x00;
58     byte constant proofType_TLSNotary = 0x10;
59     byte constant proofType_Android = 0x20;
60     byte constant proofType_Ledger = 0x30;
61     byte constant proofType_Native = 0xF0;
62     byte constant proofStorage_IPFS = 0x01;
63     uint8 constant networkID_auto = 0;
64     uint8 constant networkID_mainnet = 1;
65     uint8 constant networkID_testnet = 2;
66     uint8 constant networkID_morden = 2;
67     uint8 constant networkID_consensys = 161;
68 
69     OraclizeAddrResolverI OAR;
70 
71     OraclizeI oraclize;
72     modifier oraclizeAPI {
73         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
74         oraclize = OraclizeI(OAR.getAddress());
75         _;
76     }
77     modifier coupon(string code){
78         oraclize = OraclizeI(OAR.getAddress());
79         oraclize.useCoupon(code);
80         _;
81     }
82 
83     function oraclize_setNetwork(uint8) internal returns(bool){
84 //    function oraclize_setNetwork(uint8 networkID) internal returns(bool){
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
123     function __callback(bytes32, string, bytes) {
124 //    function __callback(bytes32 myid, string result, bytes proof) {
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
531         _size := extcodesize(_addr)
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
561         if (a[i] < b[i])
562         return -1;
563         else if (a[i] > b[i])
564         return 1;
565         if (a.length < b.length)
566         return -1;
567         else if (a.length > b.length)
568         return 1;
569         else
570         return 0;
571     }
572 
573     function indexOf(string _haystack, string _needle) internal returns (int) {
574         bytes memory h = bytes(_haystack);
575         bytes memory n = bytes(_needle);
576         if(h.length < 1 || n.length < 1 || (n.length > h.length))
577         return -1;
578         else if(h.length > (2**128 -1))
579         return -1;
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
593                     return int(i);
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
642                     if (_b == 0) break;
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
671         uint arrlen = arr.length;
672 
673         // get correct cbor output length
674         uint outputlen = 0;
675         bytes[] memory elemArray = new bytes[](arrlen);
676         for (uint i = 0; i < arrlen; i++) {
677             elemArray[i] = (bytes(arr[i]));
678             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
679         }
680         uint ctr = 0;
681         uint cborlen = arrlen + 0x80;
682         outputlen += byte(cborlen).length;
683         bytes memory res = new bytes(outputlen);
684 
685         while (byte(cborlen).length > ctr) {
686             res[ctr] = byte(cborlen)[ctr];
687             ctr++;
688         }
689         for (i = 0; i < arrlen; i++) {
690             res[ctr] = 0x5F;
691             ctr++;
692             for (uint x = 0; x < elemArray[i].length; x++) {
693                 // if there's a bug with larger strings, this may be the culprit
694                 if (x % 23 == 0) {
695                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
696                     elemcborlen += 0x40;
697                     uint lctr = ctr;
698                     while (byte(elemcborlen).length > ctr - lctr) {
699                         res[ctr] = byte(elemcborlen)[ctr - lctr];
700                         ctr++;
701                     }
702                 }
703                 res[ctr] = elemArray[i][x];
704                 ctr++;
705             }
706             res[ctr] = 0xFF;
707             ctr++;
708         }
709         return res;
710     }
711 
712     function ba2cbor(bytes[] arr) internal returns (bytes) {
713         uint arrlen = arr.length;
714 
715         // get correct cbor output length
716         uint outputlen = 0;
717         bytes[] memory elemArray = new bytes[](arrlen);
718         for (uint i = 0; i < arrlen; i++) {
719             elemArray[i] = (bytes(arr[i]));
720             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
721         }
722         uint ctr = 0;
723         uint cborlen = arrlen + 0x80;
724         outputlen += byte(cborlen).length;
725         bytes memory res = new bytes(outputlen);
726 
727         while (byte(cborlen).length > ctr) {
728             res[ctr] = byte(cborlen)[ctr];
729             ctr++;
730         }
731         for (i = 0; i < arrlen; i++) {
732             res[ctr] = 0x5F;
733             ctr++;
734             for (uint x = 0; x < elemArray[i].length; x++) {
735                 // if there's a bug with larger strings, this may be the culprit
736                 if (x % 23 == 0) {
737                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
738                     elemcborlen += 0x40;
739                     uint lctr = ctr;
740                     while (byte(elemcborlen).length > ctr - lctr) {
741                         res[ctr] = byte(elemcborlen)[ctr - lctr];
742                         ctr++;
743                     }
744                 }
745                 res[ctr] = elemArray[i][x];
746                 ctr++;
747             }
748             res[ctr] = 0xFF;
749             ctr++;
750         }
751         return res;
752     }
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
765 //        if ((_nbytes == 0)||(_nbytes > 32)) throw;
766         require(_nbytes != 0 && _nbytes < 32);
767         bytes memory nbytes = new bytes(1);
768         nbytes[0] = byte(_nbytes);
769         bytes memory unonce = new bytes(32);
770         bytes memory sessionKeyHash = new bytes(32);
771         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
772         assembly {
773         mstore(unonce, 0x20)
774         mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
775         mstore(sessionKeyHash, 0x20)
776         mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
777         }
778         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
779         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
780         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
781         return queryId;
782     }
783 
784     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
785         oraclize_randomDS_args[queryId] = commitment;
786     }
787 
788     mapping(bytes32=>bytes32) oraclize_randomDS_args;
789     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
790 
791     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
792         bool sigok;
793         address signer;
794 
795         bytes32 sigr;
796         bytes32 sigs;
797 
798         bytes memory sigr_ = new bytes(32);
799         uint offset = 4+(uint(dersig[3]) - 0x20);
800         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
801         bytes memory sigs_ = new bytes(32);
802         offset += 32 + 2;
803         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
804 
805         assembly {
806         sigr := mload(add(sigr_, 32))
807         sigs := mload(add(sigs_, 32))
808         }
809 
810 
811         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
812         if (address(sha3(pubkey)) == signer) return true;
813         else {
814             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
815             return (address(sha3(pubkey)) == signer);
816         }
817     }
818 
819     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
820         bool sigok;
821 
822         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
823         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
824         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
825 
826         bytes memory appkey1_pubkey = new bytes(64);
827         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
828 
829         bytes memory tosign2 = new bytes(1+65+32);
830 //        tosign2[0] = 1; //role
831         tosign2[0] = 0x1; //role
832         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
833         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
834         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
835         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
836 
837         if (sigok == false) return false;
838 
839 
840         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
841         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
842 
843         bytes memory tosign3 = new bytes(1+65);
844         tosign3[0] = 0xFE;
845         copyBytes(proof, 3, 65, tosign3, 1);
846 
847         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
848         copyBytes(proof, 3+65, sig3.length, sig3, 0);
849 
850         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
851 
852         return sigok;
853     }
854 
855     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
856         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
857 //        if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
858         require(_proof[0] == "L" && _proof[1] == "P" && _proof[2] == 1);
859 
860         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
861 //        if (proofVerified == false) throw;
862         require(proofVerified == true);
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
880 //        for (var i=0; i<prefix.length; i++){
881         for (var i=uint8(0); i<prefix.length; i++){
882             if (content[i] != prefix[i]) match_ = false;
883         }
884 
885         return match_;
886     }
887 
888     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
889         bool checkok;
890 
891 
892         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
893         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
894         bytes memory keyhash = new bytes(32);
895         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
896         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
897         if (checkok == false) return false;
898 
899         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
900         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
901 
902 
903         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
904         checkok = matchBytes32Prefix(sha256(sig1), result);
905         if (checkok == false) return false;
906 
907 
908         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
909         // This is to verify that the computed args match with the ones specified in the query.
910         bytes memory commitmentSlice1 = new bytes(8+1+32);
911         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
912 
913         bytes memory sessionPubkey = new bytes(64);
914         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
915         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
916 
917         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
918         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
919             delete oraclize_randomDS_args[queryId];
920         } else return false;
921 
922 
923         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
924         bytes memory tosign1 = new bytes(32+8+1+32);
925         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
926         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
927         if (checkok == false) return false;
928 
929         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
930         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
931             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
932         }
933 
934         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
935     }
936 
937 
938     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
939     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
940         uint minLength = length + toOffset;
941 
942 //        if (to.length < minLength) {
943             // Buffer too small
944 //            throw; // Should be a better way?
945 //        }
946         require(to.length > minLength);
947 
948         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
949         uint i = 32 + fromOffset;
950         uint j = 32 + toOffset;
951 
952         while (i < (32 + fromOffset + length)) {
953             assembly {
954             let tmp := mload(add(from, i))
955             mstore(add(to, j), tmp)
956             }
957             i += 32;
958             j += 32;
959         }
960 
961         return to;
962     }
963 
964     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
965     // Duplicate Solidity's ecrecover, but catching the CALL return value
966     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
967         // We do our own memory management here. Solidity uses memory offset
968         // 0x40 to store the current end of memory. We write past it (as
969         // writes are memory extensions), but don't update the offset so
970         // Solidity will reuse it. The memory used here is only needed for
971         // this context.
972 
973         // FIXME: inline assembly can't access return values
974         bool ret;
975         address addr;
976 
977         assembly {
978         let size := mload(0x40)
979         mstore(size, hash)
980         mstore(add(size, 32), v)
981         mstore(add(size, 64), r)
982         mstore(add(size, 96), s)
983 
984         // NOTE: we can reuse the request memory because we deal with
985         //       the return code
986         ret := call(3000, 1, 0, size, 128, size, 32)
987         addr := mload(size)
988         }
989 
990         return (ret, addr);
991     }
992 
993     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
994     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
995         bytes32 r;
996         bytes32 s;
997         uint8 v;
998 
999         if (sig.length != 65)
1000         return (false, 0);
1001 
1002         // The signature format is a compact form of:
1003         //   {bytes32 r}{bytes32 s}{uint8 v}
1004         // Compact means, uint8 is not padded to 32 bytes.
1005         assembly {
1006         r := mload(add(sig, 32))
1007         s := mload(add(sig, 64))
1008 
1009         // Here we are loading the last 32 bytes. We exploit the fact that
1010         // 'mload' will pad with zeroes if we overread.
1011         // There is no 'mload8' to do this, but that would be nicer.
1012         v := byte(0, mload(add(sig, 96)))
1013 
1014         // Alternative solution:
1015         // 'byte' is not working due to the Solidity parser, so lets
1016         // use the second best option, 'and'
1017         // v := and(mload(add(sig, 65)), 255)
1018     }
1019 
1020 // albeit non-transactional signatures are not specified by the YP, one would expect it
1021 // to match the YP range of [27, 28]
1022 //
1023 // geth uses [0, 1] and some clients have followed. This might change, see:
1024 //  https://github.com/ethereum/go-ethereum/issues/2053
1025 if (v < 27)
1026 v += 27;
1027 
1028 if (v != 27 && v != 28)
1029 return (false, 0);
1030 
1031 return safer_ecrecover(hash, v, r, s);
1032 }
1033 
1034 }
1035 // </ORACLIZE_API>
1036 /* solhint-enable */
1037 
1038 contract Ownable {
1039     //Variables
1040     address public owner;
1041 
1042     address public newOwner;
1043 
1044     //    Modifiers
1045     /**
1046      * @dev Throws if called by any account other than the owner.
1047      */
1048     modifier onlyOwner() {
1049         require(msg.sender == owner);
1050         _;
1051     }
1052 
1053     /**
1054      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1055      * account.
1056      */
1057     function Ownable() public {
1058         owner = msg.sender;
1059     }
1060 
1061     /**
1062      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1063      * @param _newOwner The address to transfer ownership to.
1064      */
1065     function transferOwnership(address _newOwner) public onlyOwner {
1066         require(_newOwner != address(0));
1067         newOwner = _newOwner;
1068     }
1069 
1070     function acceptOwnership() public {
1071         if (msg.sender == newOwner) {
1072             owner = newOwner;
1073         }
1074     }
1075 }
1076 
1077 contract TokenRecipient {
1078     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
1079 }
1080 
1081 
1082 contract ERC20 is Ownable {
1083 
1084     using SafeMath for uint256;
1085 
1086     /* Public variables of the token */
1087     string public standard;
1088 
1089     string public name;
1090 
1091     string public symbol;
1092 
1093     uint8 public decimals;
1094 
1095     uint256 public initialSupply;
1096 
1097     bool public locked;
1098 
1099     uint256 public creationBlock;
1100 
1101     mapping (address => uint256) public balances;
1102 
1103     mapping (address => mapping (address => uint256)) public allowance;
1104 
1105     /* This generates a public event on the blockchain that will notify clients */
1106     event Transfer(address indexed from, address indexed to, uint256 value);
1107 
1108     event Approval(address indexed _owner, address indexed _spender, uint _value);
1109 
1110     modifier onlyPayloadSize(uint numwords) {
1111         assert(msg.data.length == numwords.mul(32).add(4));
1112         _;
1113     }
1114 
1115     /* Initializes contract with initial supply tokens to the creator of the contract */
1116     function ERC20(
1117         uint256 _initialSupply,
1118         string _tokenName,
1119         uint8 _decimalUnits,
1120         string _tokenSymbol,
1121         bool _transferAllSupplyToOwner,
1122         bool _locked
1123     ) {
1124         standard = "ERC20 0.1";
1125 
1126         initialSupply = _initialSupply;
1127 
1128         if (_transferAllSupplyToOwner) {
1129             setBalance(msg.sender, initialSupply);
1130         } else {
1131             setBalance(this, initialSupply);
1132         }
1133 
1134         name = _tokenName;
1135         // Set the name for display purposes
1136         symbol = _tokenSymbol;
1137         // Set the symbol for display purposes
1138         decimals = _decimalUnits;
1139         // Amount of decimals for display purposes
1140         locked = _locked;
1141         creationBlock = block.number;
1142     }
1143 
1144     /* public methods */
1145     function totalSupply() public constant returns (uint256) {
1146         return initialSupply;
1147     }
1148 
1149     function balanceOf(address _address) public constant returns (uint256) {
1150         return balances[_address];
1151     }
1152 
1153     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
1154         require(locked == false);
1155 
1156         bool status = transferInternal(msg.sender, _to, _value);
1157 
1158         require(status == true);
1159 
1160         return true;
1161     }
1162 
1163     function approve(address _spender, uint256 _value) public returns (bool success) {
1164         if (locked) {
1165             return false;
1166         }
1167 
1168         allowance[msg.sender][_spender] = _value;
1169         Approval(msg.sender, _spender, _value);
1170 
1171         return true;
1172     }
1173 
1174     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
1175         if (locked) {
1176             return false;
1177         }
1178 
1179         TokenRecipient spender = TokenRecipient(_spender);
1180 
1181         if (approve(_spender, _value)) {
1182             spender.receiveApproval(msg.sender, _value, this, _extraData);
1183             return true;
1184         }
1185     }
1186 
1187     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1188         if (locked) {
1189             return false;
1190         }
1191 
1192         if (allowance[_from][msg.sender] < _value) {
1193             return false;
1194         }
1195 
1196         bool _success = transferInternal(_from, _to, _value);
1197 
1198         if (_success) {
1199             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
1200         }
1201 
1202         return _success;
1203     }
1204 
1205     /* internal balances */
1206     function setBalance(address _holder, uint256 _amount) internal {
1207         balances[_holder] = _amount;
1208     }
1209 
1210     function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
1211         if (_value == 0) {
1212             Transfer(_from, _to, 0);
1213             return true;
1214         }
1215 
1216         if (balances[_from] < _value) {
1217             return false;
1218         }
1219 
1220         setBalance(_from, balances[_from].sub(_value));
1221         setBalance(_to, balances[_to].add(_value));
1222 
1223         Transfer(_from, _to, _value);
1224 
1225         return true;
1226     }
1227 
1228 }
1229 
1230 contract MintingERC20 is ERC20 {
1231 
1232     using SafeMath for uint256;
1233 
1234     uint256 public maxSupply;
1235 
1236     mapping (address => bool) public minters;
1237 
1238     modifier onlyMinters () {
1239         require(true == minters[msg.sender]);
1240         _;
1241     }
1242 
1243     function MintingERC20(
1244         uint256 _initialSupply,
1245         uint256 _maxSupply,
1246         string _tokenName,
1247         uint8 _decimals,
1248         string _symbol,
1249         bool _transferAllSupplyToOwner,
1250         bool _locked
1251     )
1252         ERC20(_initialSupply, _tokenName, _decimals, _symbol, _transferAllSupplyToOwner, _locked)
1253     {
1254         minters[msg.sender] = true;
1255         maxSupply = _maxSupply;
1256     }
1257 
1258     function addMinter(address _newMinter) public onlyOwner {
1259         minters[_newMinter] = true;
1260     }
1261 
1262     function removeMinter(address _minter) public onlyOwner {
1263         minters[_minter] = false;
1264     }
1265 
1266     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
1267         if (_amount == uint256(0)) {
1268             return uint256(0);
1269         }
1270 
1271         if (totalSupply().add(_amount) > maxSupply) {
1272             return uint256(0);
1273         }
1274 
1275         initialSupply = initialSupply.add(_amount);
1276         balances[_addr] = balances[_addr].add(_amount);
1277         Transfer(0, _addr, _amount);
1278 
1279         return _amount;
1280     }
1281 }
1282 
1283 contract Node is MintingERC20 {
1284 
1285     using SafeMath for uint256;
1286 
1287     NodePhases public nodePhases;
1288 
1289     // Block token transfers till ICO end.
1290     bool public transferFrozen = true;
1291 
1292     function Node(
1293         uint256 _maxSupply,
1294         string _tokenName,
1295         string _tokenSymbol,
1296         uint8 _precision,
1297         bool _locked
1298     ) MintingERC20(0, _maxSupply, _tokenName, _precision, _tokenSymbol, false, _locked) {
1299         standard = "Node 0.1";
1300     }
1301 
1302     function setLocked(bool _locked) public onlyOwner {
1303         locked = _locked;
1304     }
1305 
1306     function setNodePhases(address _nodePhases) public onlyOwner {
1307         nodePhases = NodePhases(_nodePhases);
1308     }
1309 
1310     function unfreeze() public onlyOwner {
1311         if (nodePhases != address(0) && nodePhases.isFinished(1)) {
1312             transferFrozen = false;
1313         }
1314     }
1315 
1316     function buyBack(address _address) public onlyMinters returns (uint256) {
1317         require(address(_address) != address(0));
1318 
1319         uint256 balance = balanceOf(_address);
1320         setBalance(_address, 0);
1321         setBalance(this, balanceOf(this).add(balance));
1322         Transfer(_address, this, balance);
1323 
1324         return balance;
1325     }
1326 
1327     function transfer(address _to, uint _value) public returns (bool) {
1328         require(!transferFrozen);
1329 
1330         return super.transfer(_to, _value);
1331     }
1332 
1333     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
1334         require(!transferFrozen);
1335 
1336         return super.transferFrom(_from, _to, _value);
1337     }
1338 
1339 }
1340 
1341 contract NodeAllocation is Ownable {
1342 
1343     using SafeMath for uint256;
1344 
1345     PreICOAllocation[] public preIcoAllocation;
1346 
1347     ICOAllocation[] public icoAllocation;
1348 
1349     uint256[] public distributionThresholds;
1350 
1351     address public bountyAddress;
1352 
1353     struct PreICOAllocation {
1354         uint8 percentage;
1355         address destAddress;
1356     }
1357 
1358     struct ICOAllocation {
1359         uint8 percentage;
1360         address destAddress;
1361     }
1362 
1363     function NodeAllocation(
1364         address _bountyAddress, //2%
1365         address[] _preICOAddresses, //according - 3% and 97%
1366         address[] _icoAddresses, //according - 3% 47% and 50%
1367         uint256[] _distributionThresholds
1368     ) {
1369         require((address(_bountyAddress) != address(0)) && _distributionThresholds.length > 0);
1370 
1371         bountyAddress = _bountyAddress;
1372         distributionThresholds = _distributionThresholds;
1373 
1374         require(setPreICOAllocation(_preICOAddresses) == true);
1375         require(setICOAllocation(_icoAddresses) == true);
1376     }
1377 
1378     function getPreICOAddress(uint8 _id) public returns (address) {
1379         PreICOAllocation storage allocation = preIcoAllocation[_id];
1380 
1381         return allocation.destAddress;
1382     }
1383 
1384     function getPreICOPercentage(uint8 _id) public returns (uint8) {
1385         PreICOAllocation storage allocation = preIcoAllocation[_id];
1386 
1387         return allocation.percentage;
1388     }
1389 
1390     function getPreICOLength() public returns (uint8) {
1391         return uint8(preIcoAllocation.length);
1392     }
1393 
1394     function getICOAddress(uint8 _id) public returns (address) {
1395         ICOAllocation storage allocation = icoAllocation[_id];
1396 
1397         return allocation.destAddress;
1398     }
1399 
1400     function getICOPercentage(uint8 _id) public returns (uint8) {
1401         ICOAllocation storage allocation = icoAllocation[_id];
1402 
1403         return allocation.percentage;
1404     }
1405 
1406     function getICOLength() public returns (uint8) {
1407         return uint8(icoAllocation.length);
1408     }
1409 
1410     function getThreshold(uint8 _id) public returns (uint256) {
1411         return uint256(distributionThresholds[_id]);
1412     }
1413 
1414     function getThresholdsLength() public returns (uint8) {
1415         return uint8(distributionThresholds.length);
1416     }
1417 
1418     function setPreICOAllocation(address[] _addresses) internal returns (bool) {
1419         if (_addresses.length < 2) {
1420             return false;
1421         }
1422         preIcoAllocation.push(PreICOAllocation(3, _addresses[0]));
1423         preIcoAllocation.push(PreICOAllocation(97, _addresses[1]));
1424 
1425         return true;
1426     }
1427 
1428     function setICOAllocation(address[] _addresses) internal returns (bool) {
1429         if (_addresses.length < 3) {
1430             return false;
1431         }
1432         icoAllocation.push(ICOAllocation(3, _addresses[0]));
1433         icoAllocation.push(ICOAllocation(47, _addresses[1]));
1434         icoAllocation.push(ICOAllocation(50, _addresses[2]));
1435 
1436         return true;
1437     }
1438 }
1439 
1440 contract NodePhases is usingOraclize, Ownable {
1441 
1442     using SafeMath for uint256;
1443 
1444     Node public node;
1445 
1446     NodeAllocation public nodeAllocation;
1447 
1448     Phase[] public phases;
1449 
1450     uint256 public constant HOUR = 3600;
1451 
1452     uint256 public constant DAY = 86400;
1453 
1454     uint256 public collectedEthers;
1455 
1456     uint256 public soldTokens;
1457 
1458     uint256 public priceUpdateAt;
1459 
1460     uint256 public investorsCount;
1461 
1462     uint256 public lastDistributedAmount;
1463 
1464     mapping (address => uint256) public icoEtherBalances;
1465 
1466     mapping (address => bool) private investors;
1467 
1468     event NewOraclizeQuery(string description);
1469 
1470     event NewNodePriceTicker(string price);
1471 
1472     event Refund(address holder, uint256 ethers, uint256 tokens);
1473 
1474     struct Phase {
1475         uint256 price;
1476         uint256 minInvest;
1477         uint256 softCap;
1478         uint256 hardCap;
1479         uint256 since;
1480         uint256 till;
1481         bool isSucceed;
1482     }
1483 
1484     function NodePhases(
1485         address _node,
1486         uint256 _minInvest,
1487         uint256 _tokenPrice, //0.0032835596 ethers
1488         uint256 _preIcoMaxCap,
1489         uint256 _preIcoSince,
1490         uint256 _preIcoTill,
1491         uint256 _icoMinCap,
1492         uint256 _icoMaxCap,
1493         uint256 _icoSince,
1494         uint256 _icoTill
1495     ) {
1496         require(address(_node) != address(0));
1497         node = Node(address(_node));
1498 
1499         require((_preIcoSince < _preIcoTill) && (_icoSince < _icoTill) && (_preIcoTill <= _icoSince));
1500 
1501         require((_preIcoMaxCap < _icoMaxCap) && (_icoMaxCap < node.maxSupply()));
1502 
1503         phases.push(Phase(_tokenPrice, _minInvest, 0, _preIcoMaxCap, _preIcoSince, _preIcoTill, false));
1504         phases.push(Phase(_tokenPrice, _minInvest, _icoMinCap, _icoMaxCap, _icoSince, _icoTill, false));
1505 
1506         priceUpdateAt = now;
1507 
1508         oraclize_setNetwork(networkID_auto);
1509         oraclize = OraclizeI(OAR.getAddress());
1510     }
1511 
1512     function() public payable {
1513         require(buy(msg.sender, msg.value) == true);
1514     }
1515 
1516     function __callback(bytes32, string _result, bytes) public {
1517         require(msg.sender == oraclize_cbAddress());
1518 
1519         uint256 price = uint256(10 ** 23).div(parseInt(_result, 5));
1520 
1521         require(price > 0);
1522 
1523         for (uint i = 0; i < phases.length; i++) {
1524             Phase storage phase = phases[i];
1525             phase.price = price;
1526         }
1527 
1528         NewNodePriceTicker(_result);
1529     }
1530 
1531     function setCurrentRate(uint256 _rate) public onlyOwner {
1532         require(_rate > 0);
1533         for (uint i = 0; i < phases.length; i++) {
1534             Phase storage phase = phases[i];
1535             phase.price = _rate;
1536         }
1537         priceUpdateAt = now;
1538     }
1539 
1540     function setNode(address _node) public onlyOwner {
1541         require(address(_node) != address(0));
1542         node = Node(_node);
1543     }
1544 
1545     function setNodeAllocation(address _nodeAllocation) public onlyOwner {
1546         require(address(_nodeAllocation) != address(0));
1547         nodeAllocation = NodeAllocation(_nodeAllocation);
1548     }
1549 
1550     function setPhase(
1551         uint8 _phaseId,
1552         uint256 _since,
1553         uint256 _till,
1554         uint256 _price,
1555         uint256 _softCap,
1556         uint256 _hardCap
1557     ) public onlyOwner returns (bool) {
1558         require((phases.length > _phaseId) && (_price > 0));
1559         require((_till > _since) && (_since > 0));
1560         require((node.maxSupply() > _hardCap) && (_hardCap > _softCap) && (_softCap >= 0));
1561 
1562         Phase storage phase = phases[_phaseId];
1563 
1564         if (phase.isSucceed == true) {
1565             return false;
1566         }
1567         phase.since = _since;
1568         phase.till = _till;
1569         phase.price = _price;
1570         phase.softCap = _softCap;
1571         phase.hardCap = _hardCap;
1572 
1573         return true;
1574     }
1575 
1576     function sendToAddress(address _address, uint256 _tokens) public onlyOwner returns (bool) {
1577         return sendToAddressWithTime(_address, _tokens, now);
1578     }
1579 
1580     function sendToAddressWithTime(
1581         address _address,
1582         uint256 _tokens,
1583         uint256 _time
1584     ) public onlyOwner returns (bool) {
1585         if (_tokens == 0 || address(_address) == address(0) || _time == 0) {
1586             return false;
1587         }
1588 
1589         uint256 totalAmount = _tokens.add(getBonusAmount(_tokens, _time));
1590 
1591         require(totalAmount == node.mint(_address, totalAmount));
1592 
1593         soldTokens = soldTokens.add(totalAmount);
1594         increaseInvestorsCount(_address);
1595 
1596         return true;
1597     }
1598 
1599     function sendToAddressWithBonus(
1600         address _address,
1601         uint256 _tokens,
1602         uint256 _bonus
1603     ) public onlyOwner returns (bool) {
1604         if (_tokens == 0 || address(_address) == address(0) || _bonus == 0) {
1605             return false;
1606         }
1607 
1608         uint256 totalAmount = _tokens.add(_bonus);
1609 
1610         require(totalAmount == node.mint(_address, totalAmount));
1611 
1612         soldTokens = soldTokens.add(totalAmount);
1613         increaseInvestorsCount(_address);
1614 
1615         return true;
1616     }
1617 
1618     function getTokens() public constant returns (uint256) {
1619         return node.totalSupply();
1620     }
1621 
1622     function getSoldToken() public constant returns (uint256) {
1623         return soldTokens;
1624     }
1625 
1626     function getAllInvestors() public constant returns (uint256) {
1627         return investorsCount;
1628     }
1629 
1630     function getBalanceContract() public constant returns (uint256) {
1631         return collectedEthers;
1632     }
1633 
1634     function isSucceed(uint8 phaseId) public returns (bool) {
1635         if (phases.length < phaseId) {
1636             return false;
1637         }
1638         Phase storage phase = phases[phaseId];
1639         if (phase.isSucceed == true) {
1640             return true;
1641         }
1642         if (phase.till > now) {
1643             return false;
1644         }
1645         if (phase.softCap != 0 && phase.softCap > getTokens()) {
1646             return false;
1647         }
1648         phase.isSucceed = true;
1649         if (phaseId == 1) {
1650             allocateBounty();
1651         }
1652 
1653         return true;
1654     }
1655 
1656     function refund() public returns (bool) {
1657         Phase storage icoPhase = phases[1];
1658         if (icoPhase.till > now) {
1659             return false;
1660         }
1661         if (icoPhase.softCap < getTokens()) {
1662             return false;
1663         }
1664         if (icoEtherBalances[msg.sender] == 0) {
1665             return false;
1666         }
1667 
1668         uint256 refundAmount = icoEtherBalances[msg.sender];
1669         uint256 tokens = node.buyBack(msg.sender);
1670         icoEtherBalances[msg.sender] = 0;
1671         msg.sender.transfer(refundAmount);
1672         Refund(msg.sender, refundAmount, tokens);
1673 
1674         return true;
1675     }
1676 
1677     function isFinished(uint8 phaseId) public constant returns (bool) {
1678         if (phases.length < phaseId) {
1679             return false;
1680         }
1681         Phase storage phase = phases[phaseId];
1682 
1683         return (phase.isSucceed || now > phase.till);
1684     }
1685 
1686     function getCurrentPhase(uint256 _time) public constant returns (uint8) {
1687         if (_time == 0) {
1688             return uint8(phases.length);
1689         }
1690         for (uint8 i = 0; i < phases.length; i++) {
1691             Phase storage phase = phases[i];
1692             if (phase.since > _time) {
1693                 continue;
1694             }
1695 
1696             if (phase.till < _time) {
1697                 continue;
1698             }
1699 
1700             return i;
1701         }
1702 
1703         return uint8(phases.length);
1704     }
1705 
1706     function update() internal {
1707         if (oraclize_getPrice("URL") > this.balance) {
1708             NewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1709         } else {
1710             NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1711             oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1712         }
1713     }
1714 
1715     function buy(address _address, uint256 _value) internal returns (bool) {
1716         if (_value == 0) {
1717             return false;
1718         }
1719 
1720         uint8 currentPhase = getCurrentPhase(now);
1721 
1722         if (phases.length < currentPhase) {
1723             return false;
1724         }
1725 
1726         if (priceUpdateAt.add(HOUR) < now) {
1727             update();
1728             priceUpdateAt = now;
1729         }
1730 
1731         uint256 amount = getTokensAmount(_value, currentPhase);
1732 
1733         if (amount == 0) {
1734             return false;
1735         }
1736 
1737         amount = amount.add(getBonusAmount(amount, now));
1738 
1739         require(amount == node.mint(_address, amount));
1740 
1741         onSuccessfulBuy(_address, _value, amount, currentPhase);
1742         allocate(currentPhase);
1743 
1744         return true;
1745     }
1746 
1747     function onSuccessfulBuy(address _address, uint256 _value, uint256 _amount, uint8 _currentPhase) internal {
1748         collectedEthers = collectedEthers.add(_value);
1749         soldTokens = soldTokens.add(_amount);
1750         increaseInvestorsCount(_address);
1751 
1752         if (_currentPhase == 1) {
1753             icoEtherBalances[_address] = icoEtherBalances[_address].add(_value);
1754         }
1755     }
1756 
1757     function increaseInvestorsCount(address _address) internal {
1758         if (address(_address) != address(0) && investors[_address] == false) {
1759             investors[_address] = true;
1760             investorsCount = investorsCount.add(1);
1761         }
1762     }
1763 
1764     function getTokensAmount(uint256 _value, uint8 _currentPhase) internal returns (uint256) {
1765         if (_value == 0 || phases.length < _currentPhase) {
1766             return 0;
1767         }
1768 
1769         Phase storage phase = phases[_currentPhase];
1770 
1771         uint256 amount = _value.mul(uint256(10) ** node.decimals()).div(phase.price);
1772 
1773         if (amount < phase.minInvest) {
1774             return 0;
1775         }
1776 
1777         if (getTokens().add(amount) > phase.hardCap) {
1778             return 0;
1779         }
1780 
1781         return amount;
1782     }
1783 
1784     function getBonusAmount(uint256 _amount, uint256 _time) internal returns (uint256) {
1785         uint8 currentPhase = getCurrentPhase(_time);
1786         if (_amount == 0 || _time == 0 || phases.length < currentPhase) {
1787             return 0;
1788         }
1789 
1790         if (currentPhase == 0) {
1791             return _amount.mul(50).div(100);
1792         }
1793 
1794         if (currentPhase == 1) {
1795             return getICOBonusAmount(_amount, _time);
1796         }
1797 
1798         return 0;
1799     }
1800 
1801     function getICOBonusAmount(uint256 _amount, uint256 _time) internal returns (uint256) {
1802         Phase storage ico = phases[1];
1803         if (_time.sub(ico.since) < 11 * DAY) {// 11d since ico => reward 30%;
1804             return _amount.mul(30).div(100);
1805         }
1806         if (_time.sub(ico.since) < 21 * DAY) {// 21d since ico => reward 20%
1807             return _amount.mul(20).div(100);
1808         }
1809         if (_time.sub(ico.since) < 31 * DAY) {// 31d since ico => reward 15%
1810             return _amount.mul(15).div(100);
1811         }
1812         if (_time.sub(ico.since) < 41 * DAY) {// 41d since ico => reward 10%
1813             return _amount.mul(10).div(100);
1814         }
1815 
1816         return 0;
1817     }
1818 
1819     function allocateICOEthers() internal returns (bool) {
1820         uint8 length = nodeAllocation.getICOLength();
1821         require(length > 0);
1822 
1823         uint256 totalAmount = this.balance;
1824         for (uint8 i = 0; i < length; i++) {
1825             uint256 amount = totalAmount.mul(nodeAllocation.getICOPercentage(i)).div(100);
1826             if ((i + 1) == length) {
1827                 amount = this.balance;
1828             }
1829             if (amount > 0) {
1830                 nodeAllocation.getICOAddress(i).transfer(amount);
1831             }
1832         }
1833 
1834         return true;
1835     }
1836 
1837     function allocatePreICOEthers() internal returns (bool) {
1838         uint8 length = nodeAllocation.getPreICOLength();
1839         require(length > 0);
1840 
1841         uint256 totalAmount = this.balance;
1842         for (uint8 i = 0; i < length; i++) {
1843             uint256 amount = totalAmount.mul(nodeAllocation.getPreICOPercentage(i)).div(100);
1844             if ((i + 1) == length) {
1845                 amount = this.balance;
1846             }
1847             if (amount > 0) {
1848                 nodeAllocation.getPreICOAddress(i).transfer(amount);
1849             }
1850         }
1851 
1852         return true;
1853     }
1854 
1855     function allocate(uint8 _currentPhase) internal {
1856         if (_currentPhase == 0) {
1857             allocatePreICOEthers();
1858         }
1859         if (_currentPhase == 1) {
1860             uint8 length = nodeAllocation.getThresholdsLength();
1861             require(uint8(length) > 0);
1862 
1863             for (uint8 j = 0; j < length; j++) {
1864                 uint256 threshold = nodeAllocation.getThreshold(j);
1865 
1866                 if ((threshold > lastDistributedAmount) && (soldTokens >= threshold)) {
1867                     allocateICOEthers();
1868                     lastDistributedAmount = threshold;
1869                 }
1870             }
1871         }
1872     }
1873 
1874     function allocateBounty() internal {
1875         if (isFinished(1)) {
1876             allocateICOEthers();
1877             uint256 amount = node.maxSupply().mul(2).div(100);
1878             uint256 mintedAmount = node.mint(nodeAllocation.bountyAddress(), amount);
1879             require(mintedAmount == amount);
1880         }
1881     }
1882 
1883 }