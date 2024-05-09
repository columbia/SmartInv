1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 
30 contract OraclizeI {
31     address public cbAddress;
32     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
33     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
34     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
35     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
36     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
37     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
38     function getPrice(string _datasource) returns (uint _dsprice);
39     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
40     function useCoupon(string _coupon);
41     function setProofType(byte _proofType);
42     function setConfig(bytes32 _config);
43     function setCustomGasPrice(uint _gasPrice);
44     function randomDS_getSessionPubKeyHash() returns(bytes32);
45 }
46 contract OraclizeAddrResolverI {
47     function getAddress() returns (address _addr);
48 }
49 contract usingOraclize {
50     uint constant day = 60*60*24;
51     uint constant week = 60*60*24*7;
52     uint constant month = 60*60*24*30;
53     byte constant proofType_NONE = 0x00;
54     byte constant proofType_TLSNotary = 0x10;
55     byte constant proofType_Android = 0x20;
56     byte constant proofType_Ledger = 0x30;
57     byte constant proofType_Native = 0xF0;
58     byte constant proofStorage_IPFS = 0x01;
59     uint8 constant networkID_auto = 0;
60     uint8 constant networkID_mainnet = 1;
61     uint8 constant networkID_testnet = 2;
62     uint8 constant networkID_morden = 2;
63     uint8 constant networkID_consensys = 161;
64 
65     OraclizeAddrResolverI OAR;
66 
67     OraclizeI oraclize;
68     modifier oraclizeAPI {
69         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
70         oraclize = OraclizeI(OAR.getAddress());
71         _;
72     }
73     modifier coupon(string code){
74         oraclize = OraclizeI(OAR.getAddress());
75         oraclize.useCoupon(code);
76         _;
77     }
78 
79     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
80         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
81             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
82             oraclize_setNetworkName("eth_mainnet");
83             return true;
84         }
85         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
86             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
87             oraclize_setNetworkName("eth_ropsten3");
88             return true;
89         }
90         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
91             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
92             oraclize_setNetworkName("eth_kovan");
93             return true;
94         }
95         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
96             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
97             oraclize_setNetworkName("eth_rinkeby");
98             return true;
99         }
100         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
101             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
102             return true;
103         }
104         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
105             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
106             return true;
107         }
108         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
109             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
110             return true;
111         }
112         return false;
113     }
114 
115     function __callback(bytes32 myid, string result) {
116         __callback(myid, result, new bytes(0));
117     }
118     function __callback(bytes32 myid, string result, bytes proof) {
119     }
120     
121     function oraclize_useCoupon(string code) oraclizeAPI internal {
122         oraclize.useCoupon(code);
123     }
124 
125     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
126         return oraclize.getPrice(datasource);
127     }
128 
129     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
130         return oraclize.getPrice(datasource, gaslimit);
131     }
132     
133     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
134         uint price = oraclize.getPrice(datasource);
135         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
136         return oraclize.query.value(price)(0, datasource, arg);
137     }
138     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
139         uint price = oraclize.getPrice(datasource);
140         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
141         return oraclize.query.value(price)(timestamp, datasource, arg);
142     }
143     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
144         uint price = oraclize.getPrice(datasource, gaslimit);
145         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
146         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
147     }
148     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource, gaslimit);
150         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
151         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
152     }
153     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
154         uint price = oraclize.getPrice(datasource);
155         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
156         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
157     }
158     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
159         uint price = oraclize.getPrice(datasource);
160         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
161         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
162     }
163     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
164         uint price = oraclize.getPrice(datasource, gaslimit);
165         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
166         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
167     }
168     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
169         uint price = oraclize.getPrice(datasource, gaslimit);
170         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
171         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
172     }
173     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
174         uint price = oraclize.getPrice(datasource);
175         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
176         bytes memory args = stra2cbor(argN);
177         return oraclize.queryN.value(price)(0, datasource, args);
178     }
179     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
180         uint price = oraclize.getPrice(datasource);
181         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
182         bytes memory args = stra2cbor(argN);
183         return oraclize.queryN.value(price)(timestamp, datasource, args);
184     }
185     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
186         uint price = oraclize.getPrice(datasource, gaslimit);
187         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
188         bytes memory args = stra2cbor(argN);
189         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
190     }
191     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
192         uint price = oraclize.getPrice(datasource, gaslimit);
193         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
194         bytes memory args = stra2cbor(argN);
195         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
196     }
197     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
198         string[] memory dynargs = new string[](1);
199         dynargs[0] = args[0];
200         return oraclize_query(datasource, dynargs);
201     }
202     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
203         string[] memory dynargs = new string[](1);
204         dynargs[0] = args[0];
205         return oraclize_query(timestamp, datasource, dynargs);
206     }
207     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
208         string[] memory dynargs = new string[](1);
209         dynargs[0] = args[0];
210         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
211     }
212     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
213         string[] memory dynargs = new string[](1);
214         dynargs[0] = args[0];       
215         return oraclize_query(datasource, dynargs, gaslimit);
216     }
217     
218     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
219         string[] memory dynargs = new string[](2);
220         dynargs[0] = args[0];
221         dynargs[1] = args[1];
222         return oraclize_query(datasource, dynargs);
223     }
224     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
225         string[] memory dynargs = new string[](2);
226         dynargs[0] = args[0];
227         dynargs[1] = args[1];
228         return oraclize_query(timestamp, datasource, dynargs);
229     }
230     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
231         string[] memory dynargs = new string[](2);
232         dynargs[0] = args[0];
233         dynargs[1] = args[1];
234         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
235     }
236     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
237         string[] memory dynargs = new string[](2);
238         dynargs[0] = args[0];
239         dynargs[1] = args[1];
240         return oraclize_query(datasource, dynargs, gaslimit);
241     }
242     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
243         string[] memory dynargs = new string[](3);
244         dynargs[0] = args[0];
245         dynargs[1] = args[1];
246         dynargs[2] = args[2];
247         return oraclize_query(datasource, dynargs);
248     }
249     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
250         string[] memory dynargs = new string[](3);
251         dynargs[0] = args[0];
252         dynargs[1] = args[1];
253         dynargs[2] = args[2];
254         return oraclize_query(timestamp, datasource, dynargs);
255     }
256     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
257         string[] memory dynargs = new string[](3);
258         dynargs[0] = args[0];
259         dynargs[1] = args[1];
260         dynargs[2] = args[2];
261         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
262     }
263     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
264         string[] memory dynargs = new string[](3);
265         dynargs[0] = args[0];
266         dynargs[1] = args[1];
267         dynargs[2] = args[2];
268         return oraclize_query(datasource, dynargs, gaslimit);
269     }
270     
271     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
272         string[] memory dynargs = new string[](4);
273         dynargs[0] = args[0];
274         dynargs[1] = args[1];
275         dynargs[2] = args[2];
276         dynargs[3] = args[3];
277         return oraclize_query(datasource, dynargs);
278     }
279     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
280         string[] memory dynargs = new string[](4);
281         dynargs[0] = args[0];
282         dynargs[1] = args[1];
283         dynargs[2] = args[2];
284         dynargs[3] = args[3];
285         return oraclize_query(timestamp, datasource, dynargs);
286     }
287     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
288         string[] memory dynargs = new string[](4);
289         dynargs[0] = args[0];
290         dynargs[1] = args[1];
291         dynargs[2] = args[2];
292         dynargs[3] = args[3];
293         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
294     }
295     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
296         string[] memory dynargs = new string[](4);
297         dynargs[0] = args[0];
298         dynargs[1] = args[1];
299         dynargs[2] = args[2];
300         dynargs[3] = args[3];
301         return oraclize_query(datasource, dynargs, gaslimit);
302     }
303     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
304         string[] memory dynargs = new string[](5);
305         dynargs[0] = args[0];
306         dynargs[1] = args[1];
307         dynargs[2] = args[2];
308         dynargs[3] = args[3];
309         dynargs[4] = args[4];
310         return oraclize_query(datasource, dynargs);
311     }
312     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
313         string[] memory dynargs = new string[](5);
314         dynargs[0] = args[0];
315         dynargs[1] = args[1];
316         dynargs[2] = args[2];
317         dynargs[3] = args[3];
318         dynargs[4] = args[4];
319         return oraclize_query(timestamp, datasource, dynargs);
320     }
321     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
322         string[] memory dynargs = new string[](5);
323         dynargs[0] = args[0];
324         dynargs[1] = args[1];
325         dynargs[2] = args[2];
326         dynargs[3] = args[3];
327         dynargs[4] = args[4];
328         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
329     }
330     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
331         string[] memory dynargs = new string[](5);
332         dynargs[0] = args[0];
333         dynargs[1] = args[1];
334         dynargs[2] = args[2];
335         dynargs[3] = args[3];
336         dynargs[4] = args[4];
337         return oraclize_query(datasource, dynargs, gaslimit);
338     }
339     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
340         uint price = oraclize.getPrice(datasource);
341         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
342         bytes memory args = ba2cbor(argN);
343         return oraclize.queryN.value(price)(0, datasource, args);
344     }
345     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
346         uint price = oraclize.getPrice(datasource);
347         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
348         bytes memory args = ba2cbor(argN);
349         return oraclize.queryN.value(price)(timestamp, datasource, args);
350     }
351     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
352         uint price = oraclize.getPrice(datasource, gaslimit);
353         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
354         bytes memory args = ba2cbor(argN);
355         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
356     }
357     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
358         uint price = oraclize.getPrice(datasource, gaslimit);
359         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
360         bytes memory args = ba2cbor(argN);
361         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
362     }
363     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
364         bytes[] memory dynargs = new bytes[](1);
365         dynargs[0] = args[0];
366         return oraclize_query(datasource, dynargs);
367     }
368     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
369         bytes[] memory dynargs = new bytes[](1);
370         dynargs[0] = args[0];
371         return oraclize_query(timestamp, datasource, dynargs);
372     }
373     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
374         bytes[] memory dynargs = new bytes[](1);
375         dynargs[0] = args[0];
376         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
377     }
378     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
379         bytes[] memory dynargs = new bytes[](1);
380         dynargs[0] = args[0];       
381         return oraclize_query(datasource, dynargs, gaslimit);
382     }
383     
384     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
385         bytes[] memory dynargs = new bytes[](2);
386         dynargs[0] = args[0];
387         dynargs[1] = args[1];
388         return oraclize_query(datasource, dynargs);
389     }
390     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
391         bytes[] memory dynargs = new bytes[](2);
392         dynargs[0] = args[0];
393         dynargs[1] = args[1];
394         return oraclize_query(timestamp, datasource, dynargs);
395     }
396     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
397         bytes[] memory dynargs = new bytes[](2);
398         dynargs[0] = args[0];
399         dynargs[1] = args[1];
400         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
401     }
402     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
403         bytes[] memory dynargs = new bytes[](2);
404         dynargs[0] = args[0];
405         dynargs[1] = args[1];
406         return oraclize_query(datasource, dynargs, gaslimit);
407     }
408     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
409         bytes[] memory dynargs = new bytes[](3);
410         dynargs[0] = args[0];
411         dynargs[1] = args[1];
412         dynargs[2] = args[2];
413         return oraclize_query(datasource, dynargs);
414     }
415     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
416         bytes[] memory dynargs = new bytes[](3);
417         dynargs[0] = args[0];
418         dynargs[1] = args[1];
419         dynargs[2] = args[2];
420         return oraclize_query(timestamp, datasource, dynargs);
421     }
422     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
423         bytes[] memory dynargs = new bytes[](3);
424         dynargs[0] = args[0];
425         dynargs[1] = args[1];
426         dynargs[2] = args[2];
427         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
428     }
429     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
430         bytes[] memory dynargs = new bytes[](3);
431         dynargs[0] = args[0];
432         dynargs[1] = args[1];
433         dynargs[2] = args[2];
434         return oraclize_query(datasource, dynargs, gaslimit);
435     }
436     
437     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
438         bytes[] memory dynargs = new bytes[](4);
439         dynargs[0] = args[0];
440         dynargs[1] = args[1];
441         dynargs[2] = args[2];
442         dynargs[3] = args[3];
443         return oraclize_query(datasource, dynargs);
444     }
445     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
446         bytes[] memory dynargs = new bytes[](4);
447         dynargs[0] = args[0];
448         dynargs[1] = args[1];
449         dynargs[2] = args[2];
450         dynargs[3] = args[3];
451         return oraclize_query(timestamp, datasource, dynargs);
452     }
453     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
454         bytes[] memory dynargs = new bytes[](4);
455         dynargs[0] = args[0];
456         dynargs[1] = args[1];
457         dynargs[2] = args[2];
458         dynargs[3] = args[3];
459         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
460     }
461     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
462         bytes[] memory dynargs = new bytes[](4);
463         dynargs[0] = args[0];
464         dynargs[1] = args[1];
465         dynargs[2] = args[2];
466         dynargs[3] = args[3];
467         return oraclize_query(datasource, dynargs, gaslimit);
468     }
469     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
470         bytes[] memory dynargs = new bytes[](5);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         dynargs[2] = args[2];
474         dynargs[3] = args[3];
475         dynargs[4] = args[4];
476         return oraclize_query(datasource, dynargs);
477     }
478     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
479         bytes[] memory dynargs = new bytes[](5);
480         dynargs[0] = args[0];
481         dynargs[1] = args[1];
482         dynargs[2] = args[2];
483         dynargs[3] = args[3];
484         dynargs[4] = args[4];
485         return oraclize_query(timestamp, datasource, dynargs);
486     }
487     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
488         bytes[] memory dynargs = new bytes[](5);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         dynargs[2] = args[2];
492         dynargs[3] = args[3];
493         dynargs[4] = args[4];
494         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
495     }
496     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
497         bytes[] memory dynargs = new bytes[](5);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         dynargs[2] = args[2];
501         dynargs[3] = args[3];
502         dynargs[4] = args[4];
503         return oraclize_query(datasource, dynargs, gaslimit);
504     }
505 
506     function oraclize_cbAddress() oraclizeAPI internal returns (address){
507         return oraclize.cbAddress();
508     }
509     function oraclize_setProof(byte proofP) oraclizeAPI internal {
510         return oraclize.setProofType(proofP);
511     }
512     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
513         return oraclize.setCustomGasPrice(gasPrice);
514     }
515     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
516         return oraclize.setConfig(config);
517     }
518     
519     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
520         return oraclize.randomDS_getSessionPubKeyHash();
521     }
522 
523     function getCodeSize(address _addr) constant internal returns(uint _size) {
524         assembly {
525             _size := extcodesize(_addr)
526         }
527     }
528 
529     function parseAddr(string _a) internal returns (address){
530         bytes memory tmp = bytes(_a);
531         uint160 iaddr = 0;
532         uint160 b1;
533         uint160 b2;
534         for (uint i=2; i<2+2*20; i+=2){
535             iaddr *= 256;
536             b1 = uint160(tmp[i]);
537             b2 = uint160(tmp[i+1]);
538             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
539             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
540             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
541             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
542             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
543             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
544             iaddr += (b1*16+b2);
545         }
546         return address(iaddr);
547     }
548 
549     function strCompare(string _a, string _b) internal returns (int) {
550         bytes memory a = bytes(_a);
551         bytes memory b = bytes(_b);
552         uint minLength = a.length;
553         if (b.length < minLength) minLength = b.length;
554         for (uint i = 0; i < minLength; i ++)
555             if (a[i] < b[i])
556                 return -1;
557             else if (a[i] > b[i])
558                 return 1;
559         if (a.length < b.length)
560             return -1;
561         else if (a.length > b.length)
562             return 1;
563         else
564             return 0;
565     }
566 
567     function indexOf(string _haystack, string _needle) internal returns (int) {
568         bytes memory h = bytes(_haystack);
569         bytes memory n = bytes(_needle);
570         if(h.length < 1 || n.length < 1 || (n.length > h.length))
571             return -1;
572         else if(h.length > (2**128 -1))
573             return -1;
574         else
575         {
576             uint subindex = 0;
577             for (uint i = 0; i < h.length; i ++)
578             {
579                 if (h[i] == n[0])
580                 {
581                     subindex = 1;
582                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
583                     {
584                         subindex++;
585                     }
586                     if(subindex == n.length)
587                         return int(i);
588                 }
589             }
590             return -1;
591         }
592     }
593 
594     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
595         bytes memory _ba = bytes(_a);
596         bytes memory _bb = bytes(_b);
597         bytes memory _bc = bytes(_c);
598         bytes memory _bd = bytes(_d);
599         bytes memory _be = bytes(_e);
600         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
601         bytes memory babcde = bytes(abcde);
602         uint k = 0;
603         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
604         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
605         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
606         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
607         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
608         return string(babcde);
609     }
610 
611     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
612         return strConcat(_a, _b, _c, _d, "");
613     }
614 
615     function strConcat(string _a, string _b, string _c) internal returns (string) {
616         return strConcat(_a, _b, _c, "", "");
617     }
618 
619     function strConcat(string _a, string _b) internal returns (string) {
620         return strConcat(_a, _b, "", "", "");
621     }
622 
623     // parseInt
624     function parseInt(string _a) internal returns (uint) {
625         return parseInt(_a, 0);
626     }
627 
628     // parseInt(parseFloat*10^_b)
629     function parseInt(string _a, uint _b) internal returns (uint) {
630         bytes memory bresult = bytes(_a);
631         uint mint = 0;
632         bool decimals = false;
633         for (uint i=0; i<bresult.length; i++){
634             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
635                 if (decimals){
636                    if (_b == 0) break;
637                     else _b--;
638                 }
639                 mint *= 10;
640                 mint += uint(bresult[i]) - 48;
641             } else if (bresult[i] == 46) decimals = true;
642         }
643         if (_b > 0) mint *= 10**_b;
644         return mint;
645     }
646 
647     function uint2str(uint i) internal returns (string){
648         if (i == 0) return "0";
649         uint j = i;
650         uint len;
651         while (j != 0){
652             len++;
653             j /= 10;
654         }
655         bytes memory bstr = new bytes(len);
656         uint k = len - 1;
657         while (i != 0){
658             bstr[k--] = byte(48 + i % 10);
659             i /= 10;
660         }
661         return string(bstr);
662     }
663     
664     function stra2cbor(string[] arr) internal returns (bytes) {
665             uint arrlen = arr.length;
666 
667             // get correct cbor output length
668             uint outputlen = 0;
669             bytes[] memory elemArray = new bytes[](arrlen);
670             for (uint i = 0; i < arrlen; i++) {
671                 elemArray[i] = (bytes(arr[i]));
672                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
673             }
674             uint ctr = 0;
675             uint cborlen = arrlen + 0x80;
676             outputlen += byte(cborlen).length;
677             bytes memory res = new bytes(outputlen);
678 
679             while (byte(cborlen).length > ctr) {
680                 res[ctr] = byte(cborlen)[ctr];
681                 ctr++;
682             }
683             for (i = 0; i < arrlen; i++) {
684                 res[ctr] = 0x5F;
685                 ctr++;
686                 for (uint x = 0; x < elemArray[i].length; x++) {
687                     // if there's a bug with larger strings, this may be the culprit
688                     if (x % 23 == 0) {
689                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
690                         elemcborlen += 0x40;
691                         uint lctr = ctr;
692                         while (byte(elemcborlen).length > ctr - lctr) {
693                             res[ctr] = byte(elemcborlen)[ctr - lctr];
694                             ctr++;
695                         }
696                     }
697                     res[ctr] = elemArray[i][x];
698                     ctr++;
699                 }
700                 res[ctr] = 0xFF;
701                 ctr++;
702             }
703             return res;
704         }
705 
706     function ba2cbor(bytes[] arr) internal returns (bytes) {
707             uint arrlen = arr.length;
708 
709             // get correct cbor output length
710             uint outputlen = 0;
711             bytes[] memory elemArray = new bytes[](arrlen);
712             for (uint i = 0; i < arrlen; i++) {
713                 elemArray[i] = (bytes(arr[i]));
714                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
715             }
716             uint ctr = 0;
717             uint cborlen = arrlen + 0x80;
718             outputlen += byte(cborlen).length;
719             bytes memory res = new bytes(outputlen);
720 
721             while (byte(cborlen).length > ctr) {
722                 res[ctr] = byte(cborlen)[ctr];
723                 ctr++;
724             }
725             for (i = 0; i < arrlen; i++) {
726                 res[ctr] = 0x5F;
727                 ctr++;
728                 for (uint x = 0; x < elemArray[i].length; x++) {
729                     // if there's a bug with larger strings, this may be the culprit
730                     if (x % 23 == 0) {
731                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
732                         elemcborlen += 0x40;
733                         uint lctr = ctr;
734                         while (byte(elemcborlen).length > ctr - lctr) {
735                             res[ctr] = byte(elemcborlen)[ctr - lctr];
736                             ctr++;
737                         }
738                     }
739                     res[ctr] = elemArray[i][x];
740                     ctr++;
741                 }
742                 res[ctr] = 0xFF;
743                 ctr++;
744             }
745             return res;
746         }
747         
748         
749     string oraclize_network_name;
750     function oraclize_setNetworkName(string _network_name) internal {
751         oraclize_network_name = _network_name;
752     }
753     
754     function oraclize_getNetworkName() internal returns (string) {
755         return oraclize_network_name;
756     }
757     
758     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
759         if ((_nbytes == 0)||(_nbytes > 32)) throw;
760         bytes memory nbytes = new bytes(1);
761         nbytes[0] = byte(_nbytes);
762         bytes memory unonce = new bytes(32);
763         bytes memory sessionKeyHash = new bytes(32);
764         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
765         assembly {
766             mstore(unonce, 0x20)
767             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
768             mstore(sessionKeyHash, 0x20)
769             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
770         }
771         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
772         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
773         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
774         return queryId;
775     }
776     
777     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
778         oraclize_randomDS_args[queryId] = commitment;
779     }
780     
781     mapping(bytes32=>bytes32) oraclize_randomDS_args;
782     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
783 
784     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
785         bool sigok;
786         address signer;
787         
788         bytes32 sigr;
789         bytes32 sigs;
790         
791         bytes memory sigr_ = new bytes(32);
792         uint offset = 4+(uint(dersig[3]) - 0x20);
793         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
794         bytes memory sigs_ = new bytes(32);
795         offset += 32 + 2;
796         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
797 
798         assembly {
799             sigr := mload(add(sigr_, 32))
800             sigs := mload(add(sigs_, 32))
801         }
802         
803         
804         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
805         if (address(sha3(pubkey)) == signer) return true;
806         else {
807             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
808             return (address(sha3(pubkey)) == signer);
809         }
810     }
811 
812     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
813         bool sigok;
814         
815         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
816         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
817         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
818         
819         bytes memory appkey1_pubkey = new bytes(64);
820         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
821         
822         bytes memory tosign2 = new bytes(1+65+32);
823         tosign2[0] = 1; //role
824         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
825         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
826         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
827         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
828         
829         if (sigok == false) return false;
830         
831         
832         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
833         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
834         
835         bytes memory tosign3 = new bytes(1+65);
836         tosign3[0] = 0xFE;
837         copyBytes(proof, 3, 65, tosign3, 1);
838         
839         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
840         copyBytes(proof, 3+65, sig3.length, sig3, 0);
841         
842         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
843         
844         return sigok;
845     }
846     
847     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
848         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
849         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
850         
851         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
852         if (proofVerified == false) throw;
853         
854         _;
855     }
856     
857     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
858         bool match_ = true;
859         
860         for (var i=0; i<prefix.length; i++){
861             if (content[i] != prefix[i]) match_ = false;
862         }
863         
864         return match_;
865     }
866 
867     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
868         bool checkok;
869         
870         
871         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
872         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
873         bytes memory keyhash = new bytes(32);
874         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
875         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
876         if (checkok == false) return false;
877         
878         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
879         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
880         
881         
882         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
883         checkok = matchBytes32Prefix(sha256(sig1), result);
884         if (checkok == false) return false;
885         
886         
887         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
888         // This is to verify that the computed args match with the ones specified in the query.
889         bytes memory commitmentSlice1 = new bytes(8+1+32);
890         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
891         
892         bytes memory sessionPubkey = new bytes(64);
893         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
894         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
895         
896         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
897         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
898             delete oraclize_randomDS_args[queryId];
899         } else return false;
900         
901         
902         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
903         bytes memory tosign1 = new bytes(32+8+1+32);
904         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
905         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
906         if (checkok == false) return false;
907         
908         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
909         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
910             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
911         }
912         
913         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
914     }
915 
916     
917     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
918     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
919         uint minLength = length + toOffset;
920 
921         if (to.length < minLength) {
922             // Buffer too small
923             throw; // Should be a better way?
924         }
925 
926         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
927         uint i = 32 + fromOffset;
928         uint j = 32 + toOffset;
929 
930         while (i < (32 + fromOffset + length)) {
931             assembly {
932                 let tmp := mload(add(from, i))
933                 mstore(add(to, j), tmp)
934             }
935             i += 32;
936             j += 32;
937         }
938 
939         return to;
940     }
941     
942     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
943     // Duplicate Solidity's ecrecover, but catching the CALL return value
944     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
945         // We do our own memory management here. Solidity uses memory offset
946         // 0x40 to store the current end of memory. We write past it (as
947         // writes are memory extensions), but don't update the offset so
948         // Solidity will reuse it. The memory used here is only needed for
949         // this context.
950 
951         // FIXME: inline assembly can't access return values
952         bool ret;
953         address addr;
954 
955         assembly {
956             let size := mload(0x40)
957             mstore(size, hash)
958             mstore(add(size, 32), v)
959             mstore(add(size, 64), r)
960             mstore(add(size, 96), s)
961 
962             // NOTE: we can reuse the request memory because we deal with
963             //       the return code
964             ret := call(3000, 1, 0, size, 128, size, 32)
965             addr := mload(size)
966         }
967   
968         return (ret, addr);
969     }
970 
971     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
972     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
973         bytes32 r;
974         bytes32 s;
975         uint8 v;
976 
977         if (sig.length != 65)
978           return (false, 0);
979 
980         // The signature format is a compact form of:
981         //   {bytes32 r}{bytes32 s}{uint8 v}
982         // Compact means, uint8 is not padded to 32 bytes.
983         assembly {
984             r := mload(add(sig, 32))
985             s := mload(add(sig, 64))
986 
987             // Here we are loading the last 32 bytes. We exploit the fact that
988             // 'mload' will pad with zeroes if we overread.
989             // There is no 'mload8' to do this, but that would be nicer.
990             v := byte(0, mload(add(sig, 96)))
991 
992             // Alternative solution:
993             // 'byte' is not working due to the Solidity parser, so lets
994             // use the second best option, 'and'
995             // v := and(mload(add(sig, 65)), 255)
996         }
997 
998         // albeit non-transactional signatures are not specified by the YP, one would expect it
999         // to match the YP range of [27, 28]
1000         //
1001         // geth uses [0, 1] and some clients have followed. This might change, see:
1002         //  https://github.com/ethereum/go-ethereum/issues/2053
1003         if (v < 27)
1004           v += 27;
1005 
1006         if (v != 27 && v != 28)
1007             return (false, 0);
1008 
1009         return safer_ecrecover(hash, v, r, s);
1010     }
1011         
1012 }
1013 
1014 contract BettingControllerInterface {
1015     function remoteBettingClose() external;
1016     function depositHouseTakeout() external payable;
1017 }
1018 
1019 contract Betting is usingOraclize {
1020     using SafeMath for uint256; //using safemath
1021 
1022     uint countdown=3; // variable to check if all prices are received
1023     address public owner; //owner address
1024     
1025     uint public winnerPoolTotal;
1026     string public constant version = "0.2.2";
1027     
1028     BettingControllerInterface internal bettingControllerInstance;
1029     
1030     struct chronus_info {
1031         bool  betting_open; // boolean: check if betting is open
1032         bool  race_start; //boolean: check if race has started
1033         bool  race_end; //boolean: check if race has ended
1034         bool  voided_bet; //boolean: check if race has been voided
1035         uint32  starting_time; // timestamp of when the race starts
1036         uint32  betting_duration;
1037         uint32  race_duration; // duration of the race
1038         uint32 voided_timestamp;
1039     }
1040     
1041     struct horses_info{
1042         int64  BTC_delta; //horses.BTC delta value
1043         int64  ETH_delta; //horses.ETH delta value
1044         int64  LTC_delta; //horses.LTC delta value
1045         bytes32 BTC; //32-bytes equivalent of horses.BTC
1046         bytes32 ETH; //32-bytes equivalent of horses.ETH
1047         bytes32 LTC;  //32-bytes equivalent of horses.LTC
1048         uint customPreGasLimit;
1049         uint customPostGasLimit;
1050     }
1051 
1052     struct bet_info{
1053         bytes32 horse; // coin on which amount is bet on
1054         uint amount; // amount bet by Bettor
1055     }
1056     struct coin_info{
1057         uint256 pre; // locking price
1058         uint256 post; // ending price
1059         uint160 total; // total coin pool
1060         uint32 count; // number of bets
1061         bool price_check;
1062         bytes32 preOraclizeId;
1063         bytes32 postOraclizeId;
1064     }
1065     struct voter_info {
1066         uint160 total_bet; //total amount of bet placed
1067         bool rewarded; // boolean: check for double spending
1068         mapping(bytes32=>uint) bets; //array of bets
1069     }
1070     
1071 
1072     mapping (bytes32 => bytes32) oraclizeIndex; // mapping oraclize IDs with coins
1073     mapping (bytes32 => coin_info) coinIndex; // mapping coins with pool information
1074     mapping (address => voter_info) voterIndex; // mapping voter address with Bettor information
1075 
1076     uint public total_reward; // total reward to be awarded
1077     uint32 total_bettors;
1078     mapping (bytes32 => bool) public winner_horse;
1079 
1080 
1081     // tracking events
1082     event newOraclizeQuery(string description);
1083     event newPriceTicker(uint price);
1084     event Deposit(address _from, uint256 _value, bytes32 _horse, uint256 _date);
1085     event Withdraw(address _to, uint256 _value);
1086 
1087     // constructor
1088     function Betting() public payable {
1089         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1090         owner = msg.sender;
1091         oraclize_setCustomGasPrice(30000000000 wei);
1092         horses.BTC = bytes32("BTC");
1093         horses.ETH = bytes32("ETH");
1094         horses.LTC = bytes32("LTC");
1095         horses.customPreGasLimit = 80000;
1096         horses.customPostGasLimit = 230000;
1097         bettingControllerInstance = BettingControllerInterface(owner);
1098     }
1099 
1100     // data access structures
1101     horses_info public horses;
1102     chronus_info public chronus;
1103     
1104     // modifiers for restricting access to methods
1105     modifier onlyOwner {
1106         require(owner == msg.sender);
1107         _;
1108     }
1109 
1110     modifier duringBetting {
1111         require(chronus.betting_open);
1112         require(now < chronus.starting_time + chronus.betting_duration);
1113         _;
1114     }
1115     
1116     modifier beforeBetting {
1117         require(!chronus.betting_open && !chronus.race_start);
1118         _;
1119     }
1120 
1121     modifier afterRace {
1122         require(chronus.race_end);
1123         _;
1124     }
1125     
1126     //function to change owner
1127     function changeOwnership(address _newOwner) onlyOwner external {
1128         owner = _newOwner;
1129     }
1130 
1131     //oraclize callback method
1132     function __callback(bytes32 myid, string result, bytes proof) public {
1133         require (msg.sender == oraclize_cbAddress());
1134         require (!chronus.race_end);
1135         bytes32 coin_pointer; // variable to differentiate different callbacks
1136         chronus.race_start = true;
1137         chronus.betting_open = false;
1138         bettingControllerInstance.remoteBettingClose();
1139         coin_pointer = oraclizeIndex[myid];
1140 
1141         if (myid == coinIndex[coin_pointer].preOraclizeId) {
1142             if (coinIndex[coin_pointer].pre > 0) {
1143             } else if (now >= chronus.starting_time+chronus.betting_duration+ 60 minutes) {
1144                 forceVoidRace();
1145             } else {
1146                 coinIndex[coin_pointer].pre = stringToUintNormalize(result);
1147                 emit newPriceTicker(coinIndex[coin_pointer].pre);
1148             }
1149         } else if (myid == coinIndex[coin_pointer].postOraclizeId){
1150             if (coinIndex[coin_pointer].pre > 0 ){
1151                 if (coinIndex[coin_pointer].post > 0) {
1152                 } else if (now >= chronus.starting_time+chronus.race_duration+ 60 minutes) {
1153                     forceVoidRace();
1154                 } else {
1155                     coinIndex[coin_pointer].post = stringToUintNormalize(result);
1156                     coinIndex[coin_pointer].price_check = true;
1157                     emit newPriceTicker(coinIndex[coin_pointer].post);
1158                     
1159                     if (coinIndex[horses.ETH].price_check && coinIndex[horses.BTC].price_check && coinIndex[horses.LTC].price_check) {
1160                         reward();
1161                     }
1162                 }
1163             } else {
1164                 forceVoidRace();
1165             }
1166         }
1167     }
1168 
1169     // place a bet on a coin(horse) lockBetting
1170     function placeBet(bytes32 horse) external duringBetting payable  {
1171         require(msg.value >= 0.01 ether);
1172         if (voterIndex[msg.sender].total_bet==0) {
1173             total_bettors+=1;
1174         }
1175         uint _newAmount = voterIndex[msg.sender].bets[horse] + msg.value;
1176         voterIndex[msg.sender].bets[horse] = _newAmount;
1177         voterIndex[msg.sender].total_bet += uint160(msg.value);
1178         uint160 _newTotal = coinIndex[horse].total + uint160(msg.value); 
1179         uint32 _newCount = coinIndex[horse].count + 1;
1180         coinIndex[horse].total = _newTotal;
1181         coinIndex[horse].count = _newCount;
1182         emit Deposit(msg.sender, msg.value, horse, now);
1183     }
1184 
1185     // fallback method for accepting payments
1186     function () private payable {}
1187 
1188     // method to place the oraclize queries
1189     function setupRace(uint delay, uint  locking_duration) onlyOwner beforeBetting public payable returns(bool) {
1190         // if (oraclize_getPrice("URL") > (this.balance)/6) {
1191         if (oraclize_getPrice("URL" , horses.customPreGasLimit)*3 + oraclize_getPrice("URL", horses.customPostGasLimit)*3  > address(this).balance) {
1192             emit newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1193             return false;
1194         } else {
1195             chronus.starting_time = uint32(block.timestamp);
1196             chronus.betting_open = true;
1197             bytes32 temp_ID; // temp variable to store oraclize IDs
1198             emit newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1199             // bets open price query
1200             chronus.betting_duration = uint32(delay);
1201             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd",horses.customPreGasLimit);
1202             oraclizeIndex[temp_ID] = horses.ETH;
1203             coinIndex[horses.ETH].preOraclizeId = temp_ID;
1204 
1205             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/litecoin/).0.price_usd",horses.customPreGasLimit);
1206             oraclizeIndex[temp_ID] = horses.LTC;
1207             coinIndex[horses.LTC].preOraclizeId = temp_ID;
1208 
1209             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/bitcoin/).0.price_usd",horses.customPreGasLimit);
1210             oraclizeIndex[temp_ID] = horses.BTC;
1211             coinIndex[horses.BTC].preOraclizeId = temp_ID;
1212 
1213             //bets closing price query
1214             delay = delay.add(locking_duration);
1215 
1216             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd",horses.customPostGasLimit);
1217             oraclizeIndex[temp_ID] = horses.ETH;
1218             coinIndex[horses.ETH].postOraclizeId = temp_ID;
1219 
1220             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/litecoin/).0.price_usd",horses.customPostGasLimit);
1221             oraclizeIndex[temp_ID] = horses.LTC;
1222             coinIndex[horses.LTC].postOraclizeId = temp_ID;
1223 
1224             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/bitcoin/).0.price_usd",horses.customPostGasLimit);
1225             oraclizeIndex[temp_ID] = horses.BTC;
1226             coinIndex[horses.BTC].postOraclizeId = temp_ID;
1227 
1228             chronus.race_duration = uint32(delay);
1229             return true;
1230         }
1231     }
1232 
1233     // method to calculate reward (called internally by callback)
1234     function reward() internal {
1235         /*
1236         calculating the difference in price with a precision of 5 digits
1237         not using safemath since signed integers are handled
1238         */
1239         horses.BTC_delta = int64(coinIndex[horses.BTC].post - coinIndex[horses.BTC].pre)*100000/int64(coinIndex[horses.BTC].pre);
1240         horses.ETH_delta = int64(coinIndex[horses.ETH].post - coinIndex[horses.ETH].pre)*100000/int64(coinIndex[horses.ETH].pre);
1241         horses.LTC_delta = int64(coinIndex[horses.LTC].post - coinIndex[horses.LTC].pre)*100000/int64(coinIndex[horses.LTC].pre);
1242         
1243         total_reward = (coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total);
1244         if (total_bettors <= 1) {
1245             forceVoidRace();
1246         } else {
1247             uint house_fee = total_reward.mul(5).div(100);
1248             require(house_fee < address(this).balance);
1249             total_reward = total_reward.sub(house_fee);
1250             bettingControllerInstance.depositHouseTakeout.value(house_fee)();
1251         }
1252         
1253         if (horses.BTC_delta > horses.ETH_delta) {
1254             if (horses.BTC_delta > horses.LTC_delta) {
1255                 winner_horse[horses.BTC] = true;
1256                 winnerPoolTotal = coinIndex[horses.BTC].total;
1257             }
1258             else if(horses.LTC_delta > horses.BTC_delta) {
1259                 winner_horse[horses.LTC] = true;
1260                 winnerPoolTotal = coinIndex[horses.LTC].total;
1261             } else {
1262                 winner_horse[horses.BTC] = true;
1263                 winner_horse[horses.LTC] = true;
1264                 winnerPoolTotal = coinIndex[horses.BTC].total + (coinIndex[horses.LTC].total);
1265             }
1266         } else if(horses.ETH_delta > horses.BTC_delta) {
1267             if (horses.ETH_delta > horses.LTC_delta) {
1268                 winner_horse[horses.ETH] = true;
1269                 winnerPoolTotal = coinIndex[horses.ETH].total;
1270             }
1271             else if (horses.LTC_delta > horses.ETH_delta) {
1272                 winner_horse[horses.LTC] = true;
1273                 winnerPoolTotal = coinIndex[horses.LTC].total;
1274             } else {
1275                 winner_horse[horses.ETH] = true;
1276                 winner_horse[horses.LTC] = true;
1277                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.LTC].total);
1278             }
1279         } else {
1280             if (horses.LTC_delta > horses.ETH_delta) {
1281                 winner_horse[horses.LTC] = true;
1282                 winnerPoolTotal = coinIndex[horses.LTC].total;
1283             } else if(horses.LTC_delta < horses.ETH_delta){
1284                 winner_horse[horses.ETH] = true;
1285                 winner_horse[horses.BTC] = true;
1286                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total);
1287             } else {
1288                 winner_horse[horses.LTC] = true;
1289                 winner_horse[horses.ETH] = true;
1290                 winner_horse[horses.BTC] = true;
1291                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total) + (coinIndex[horses.LTC].total);
1292             }
1293         }
1294         chronus.race_end = true;
1295     }
1296 
1297     // method to calculate an invidual's reward
1298     function calculateReward(address candidate) internal afterRace constant returns(uint winner_reward) {
1299         voter_info storage bettor = voterIndex[candidate];
1300         if(chronus.voided_bet) {
1301             winner_reward = bettor.total_bet;
1302         } else {
1303             uint winning_bet_total;
1304             if(winner_horse[horses.BTC]) {
1305                 winning_bet_total += bettor.bets[horses.BTC];
1306             } if(winner_horse[horses.ETH]) {
1307                 winning_bet_total += bettor.bets[horses.ETH];
1308             } if(winner_horse[horses.LTC]) {
1309                 winning_bet_total += bettor.bets[horses.LTC];
1310             }
1311             winner_reward += (((total_reward.mul(10000000)).div(winnerPoolTotal)).mul(winning_bet_total)).div(10000000);
1312         } 
1313     }
1314 
1315     // method to just check the reward amount
1316     function checkReward() afterRace external constant returns (uint) {
1317         require(!voterIndex[msg.sender].rewarded);
1318         return calculateReward(msg.sender);
1319     }
1320 
1321     // method to claim the reward amount
1322     function claim_reward() afterRace external {
1323         require(!voterIndex[msg.sender].rewarded);
1324         uint transfer_amount = calculateReward(msg.sender);
1325         require(address(this).balance >= transfer_amount);
1326         voterIndex[msg.sender].rewarded = true;
1327         msg.sender.transfer(transfer_amount);
1328         emit Withdraw(msg.sender, transfer_amount);
1329     }
1330     
1331     function forceVoidRace() internal {
1332         chronus.voided_bet=true;
1333         chronus.race_end = true;
1334         chronus.voided_timestamp=uint32(now);
1335     }
1336 
1337     // utility function to convert string to integer with precision consideration
1338     function stringToUintNormalize(string s) internal pure returns (uint result) {
1339         uint p =2;
1340         bool precision=false;
1341         bytes memory b = bytes(s);
1342         uint i;
1343         result = 0;
1344         for (i = 0; i < b.length; i++) {
1345             if (precision) {p = p-1;}
1346             if (uint(b[i]) == 46){precision = true;}
1347             uint c = uint(b[i]);
1348             if (c >= 48 && c <= 57) {result = result * 10 + (c - 48);}
1349             if (precision && p == 0){return result;}
1350         }
1351         while (p!=0) {
1352             result = result*10;
1353             p=p-1;
1354         }
1355     }
1356 
1357 
1358     // exposing the coin pool details for DApp
1359     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {
1360         return (coinIndex[index].total, coinIndex[index].pre, coinIndex[index].post, coinIndex[index].price_check, voterIndex[candidate].bets[index]);
1361     }
1362 
1363     // exposing the total reward amount for DApp
1364     function reward_total() external constant returns (uint) {
1365         return ((coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total));
1366     }
1367     
1368     // in case of any errors in race, enable full refund for the Bettors to claim
1369     function refund() external onlyOwner {
1370         require(now > chronus.starting_time + chronus.race_duration);
1371         require((chronus.betting_open && !chronus.race_start)
1372             || (chronus.race_start && !chronus.race_end));
1373         chronus.voided_bet = true;
1374         chronus.race_end = true;
1375         chronus.voided_timestamp=uint32(now);
1376         bettingControllerInstance.remoteBettingClose();
1377     }
1378 
1379     // method to claim unclaimed winnings after 30 day notice period
1380     function recovery() external onlyOwner{
1381         require((chronus.race_end && now > chronus.starting_time + chronus.race_duration + (30 days))
1382             || (chronus.voided_bet && now > chronus.voided_timestamp + (30 days)));
1383         bettingControllerInstance.depositHouseTakeout.value(address(this).balance)();
1384     }
1385 }