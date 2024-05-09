1 /*
2 
3    _____                  _         _____                                    
4   / ____|                | |       / ____|                                   
5  | |     _ __ _   _ _ __ | |_ ___ | |     ___  _ __   __ _ _ __ ___  ___ ___ 
6  | |    | '__| | | | '_ \| __/ _ \| |    / _ \| '_ \ / _` | '__/ _ \/ __/ __|
7  | |____| |  | |_| | |_) | || (_) | |___| (_) | | | | (_| | | |  __/\__ \__ \
8   \_____|_|   \__, | .__/ \__\___/ \_____\___/|_| |_|\__, |_|  \___||___/___/
9                __/ | |                                __/ |                  
10               |___/|_|                               |___/                   
11 
12 
13 CryptoCongress smart contract launched 15 August 2018. Official address is "cryptocongress.eth"
14 
15 Token and voting code begins on line 1028. 
16 
17 */
18 
19 pragma solidity ^0.4.10;
20 
21 contract OraclizeI {
22     address public cbAddress;
23     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
24     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
25     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
26     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
27     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
28     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
29     function getPrice(string _datasource) public returns (uint _dsprice);
30     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
31     function setProofType(byte _proofType) external;
32     function setCustomGasPrice(uint _gasPrice) external;
33     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
34 }
35 contract OraclizeAddrResolverI {
36     function getAddress() public returns (address _addr);
37 }
38 contract usingOraclize {
39     uint constant day = 60*60*24;
40     uint constant week = 60*60*24*7;
41     uint constant month = 60*60*24*30;
42     byte constant proofType_NONE = 0x00;
43     byte constant proofType_TLSNotary = 0x10;
44     byte constant proofType_Android = 0x20;
45     byte constant proofType_Ledger = 0x30;
46     byte constant proofType_Native = 0xF0;
47     byte constant proofStorage_IPFS = 0x01;
48     uint8 constant networkID_auto = 0;
49     uint8 constant networkID_mainnet = 1;
50     uint8 constant networkID_testnet = 2;
51     uint8 constant networkID_morden = 2;
52     uint8 constant networkID_consensys = 161;
53 
54     OraclizeAddrResolverI OAR;
55 
56     OraclizeI oraclize;
57     modifier oraclizeAPI {
58         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
59             oraclize_setNetwork(networkID_auto);
60 
61         if(address(oraclize) != OAR.getAddress())
62             oraclize = OraclizeI(OAR.getAddress());
63 
64         _;
65     }
66     modifier coupon(string code){
67         oraclize = OraclizeI(OAR.getAddress());
68         _;
69     }
70 
71     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
72       return oraclize_setNetwork();
73       networkID; // silence the warning and remain backwards compatible
74     }
75     function oraclize_setNetwork() internal returns(bool){
76         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
77             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
78             oraclize_setNetworkName("eth_mainnet");
79             return true;
80         }
81         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
82             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
83             oraclize_setNetworkName("eth_ropsten3");
84             return true;
85         }
86         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
87             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
88             oraclize_setNetworkName("eth_kovan");
89             return true;
90         }
91         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
92             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
93             oraclize_setNetworkName("eth_rinkeby");
94             return true;
95         }
96         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
97             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
98             return true;
99         }
100         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
101             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
102             return true;
103         }
104         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
105             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
106             return true;
107         }
108         return false;
109     }
110 
111     function __callback(bytes32 myid, string result) public {
112         __callback(myid, result, new bytes(0));
113     }
114     function __callback(bytes32 myid, string result, bytes proof) public {
115       return;
116       myid; result; proof; // Silence compiler warnings
117     }
118 
119     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
120         return oraclize.getPrice(datasource);
121     }
122 
123     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
124         return oraclize.getPrice(datasource, gaslimit);
125     }
126 
127     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
128         uint price = oraclize.getPrice(datasource);
129         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
130         return oraclize.query.value(price)(0, datasource, arg);
131     }
132     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
133         uint price = oraclize.getPrice(datasource);
134         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
135         return oraclize.query.value(price)(timestamp, datasource, arg);
136     }
137     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
138         uint price = oraclize.getPrice(datasource, gaslimit);
139         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
140         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
141     }
142     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
143         uint price = oraclize.getPrice(datasource, gaslimit);
144         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
145         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
146     }
147     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
148         uint price = oraclize.getPrice(datasource);
149         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
150         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
151     }
152     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
153         uint price = oraclize.getPrice(datasource);
154         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
155         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
156     }
157     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
158         uint price = oraclize.getPrice(datasource, gaslimit);
159         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
160         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
161     }
162     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
163         uint price = oraclize.getPrice(datasource, gaslimit);
164         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
165         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
166     }
167     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
168         uint price = oraclize.getPrice(datasource);
169         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
170         bytes memory args = stra2cbor(argN);
171         return oraclize.queryN.value(price)(0, datasource, args);
172     }
173     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
174         uint price = oraclize.getPrice(datasource);
175         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
176         bytes memory args = stra2cbor(argN);
177         return oraclize.queryN.value(price)(timestamp, datasource, args);
178     }
179     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
180         uint price = oraclize.getPrice(datasource, gaslimit);
181         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
182         bytes memory args = stra2cbor(argN);
183         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
184     }
185     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
186         uint price = oraclize.getPrice(datasource, gaslimit);
187         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
188         bytes memory args = stra2cbor(argN);
189         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
190     }
191     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
192         string[] memory dynargs = new string[](1);
193         dynargs[0] = args[0];
194         return oraclize_query(datasource, dynargs);
195     }
196     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
197         string[] memory dynargs = new string[](1);
198         dynargs[0] = args[0];
199         return oraclize_query(timestamp, datasource, dynargs);
200     }
201     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
202         string[] memory dynargs = new string[](1);
203         dynargs[0] = args[0];
204         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
205     }
206     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
207         string[] memory dynargs = new string[](1);
208         dynargs[0] = args[0];
209         return oraclize_query(datasource, dynargs, gaslimit);
210     }
211 
212     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
213         string[] memory dynargs = new string[](2);
214         dynargs[0] = args[0];
215         dynargs[1] = args[1];
216         return oraclize_query(datasource, dynargs);
217     }
218     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
219         string[] memory dynargs = new string[](2);
220         dynargs[0] = args[0];
221         dynargs[1] = args[1];
222         return oraclize_query(timestamp, datasource, dynargs);
223     }
224     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
225         string[] memory dynargs = new string[](2);
226         dynargs[0] = args[0];
227         dynargs[1] = args[1];
228         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
229     }
230     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
231         string[] memory dynargs = new string[](2);
232         dynargs[0] = args[0];
233         dynargs[1] = args[1];
234         return oraclize_query(datasource, dynargs, gaslimit);
235     }
236     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
237         string[] memory dynargs = new string[](3);
238         dynargs[0] = args[0];
239         dynargs[1] = args[1];
240         dynargs[2] = args[2];
241         return oraclize_query(datasource, dynargs);
242     }
243     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
244         string[] memory dynargs = new string[](3);
245         dynargs[0] = args[0];
246         dynargs[1] = args[1];
247         dynargs[2] = args[2];
248         return oraclize_query(timestamp, datasource, dynargs);
249     }
250     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
251         string[] memory dynargs = new string[](3);
252         dynargs[0] = args[0];
253         dynargs[1] = args[1];
254         dynargs[2] = args[2];
255         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
256     }
257     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
258         string[] memory dynargs = new string[](3);
259         dynargs[0] = args[0];
260         dynargs[1] = args[1];
261         dynargs[2] = args[2];
262         return oraclize_query(datasource, dynargs, gaslimit);
263     }
264 
265     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
266         string[] memory dynargs = new string[](4);
267         dynargs[0] = args[0];
268         dynargs[1] = args[1];
269         dynargs[2] = args[2];
270         dynargs[3] = args[3];
271         return oraclize_query(datasource, dynargs);
272     }
273     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
274         string[] memory dynargs = new string[](4);
275         dynargs[0] = args[0];
276         dynargs[1] = args[1];
277         dynargs[2] = args[2];
278         dynargs[3] = args[3];
279         return oraclize_query(timestamp, datasource, dynargs);
280     }
281     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
282         string[] memory dynargs = new string[](4);
283         dynargs[0] = args[0];
284         dynargs[1] = args[1];
285         dynargs[2] = args[2];
286         dynargs[3] = args[3];
287         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
288     }
289     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
290         string[] memory dynargs = new string[](4);
291         dynargs[0] = args[0];
292         dynargs[1] = args[1];
293         dynargs[2] = args[2];
294         dynargs[3] = args[3];
295         return oraclize_query(datasource, dynargs, gaslimit);
296     }
297     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
298         string[] memory dynargs = new string[](5);
299         dynargs[0] = args[0];
300         dynargs[1] = args[1];
301         dynargs[2] = args[2];
302         dynargs[3] = args[3];
303         dynargs[4] = args[4];
304         return oraclize_query(datasource, dynargs);
305     }
306     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
307         string[] memory dynargs = new string[](5);
308         dynargs[0] = args[0];
309         dynargs[1] = args[1];
310         dynargs[2] = args[2];
311         dynargs[3] = args[3];
312         dynargs[4] = args[4];
313         return oraclize_query(timestamp, datasource, dynargs);
314     }
315     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
316         string[] memory dynargs = new string[](5);
317         dynargs[0] = args[0];
318         dynargs[1] = args[1];
319         dynargs[2] = args[2];
320         dynargs[3] = args[3];
321         dynargs[4] = args[4];
322         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
323     }
324     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
325         string[] memory dynargs = new string[](5);
326         dynargs[0] = args[0];
327         dynargs[1] = args[1];
328         dynargs[2] = args[2];
329         dynargs[3] = args[3];
330         dynargs[4] = args[4];
331         return oraclize_query(datasource, dynargs, gaslimit);
332     }
333     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
334         uint price = oraclize.getPrice(datasource);
335         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
336         bytes memory args = ba2cbor(argN);
337         return oraclize.queryN.value(price)(0, datasource, args);
338     }
339     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
340         uint price = oraclize.getPrice(datasource);
341         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
342         bytes memory args = ba2cbor(argN);
343         return oraclize.queryN.value(price)(timestamp, datasource, args);
344     }
345     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
346         uint price = oraclize.getPrice(datasource, gaslimit);
347         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
348         bytes memory args = ba2cbor(argN);
349         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
350     }
351     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
352         uint price = oraclize.getPrice(datasource, gaslimit);
353         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
354         bytes memory args = ba2cbor(argN);
355         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
356     }
357     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
358         bytes[] memory dynargs = new bytes[](1);
359         dynargs[0] = args[0];
360         return oraclize_query(datasource, dynargs);
361     }
362     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
363         bytes[] memory dynargs = new bytes[](1);
364         dynargs[0] = args[0];
365         return oraclize_query(timestamp, datasource, dynargs);
366     }
367     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
368         bytes[] memory dynargs = new bytes[](1);
369         dynargs[0] = args[0];
370         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
371     }
372     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
373         bytes[] memory dynargs = new bytes[](1);
374         dynargs[0] = args[0];
375         return oraclize_query(datasource, dynargs, gaslimit);
376     }
377 
378     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
379         bytes[] memory dynargs = new bytes[](2);
380         dynargs[0] = args[0];
381         dynargs[1] = args[1];
382         return oraclize_query(datasource, dynargs);
383     }
384     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
385         bytes[] memory dynargs = new bytes[](2);
386         dynargs[0] = args[0];
387         dynargs[1] = args[1];
388         return oraclize_query(timestamp, datasource, dynargs);
389     }
390     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
391         bytes[] memory dynargs = new bytes[](2);
392         dynargs[0] = args[0];
393         dynargs[1] = args[1];
394         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
395     }
396     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
397         bytes[] memory dynargs = new bytes[](2);
398         dynargs[0] = args[0];
399         dynargs[1] = args[1];
400         return oraclize_query(datasource, dynargs, gaslimit);
401     }
402     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
403         bytes[] memory dynargs = new bytes[](3);
404         dynargs[0] = args[0];
405         dynargs[1] = args[1];
406         dynargs[2] = args[2];
407         return oraclize_query(datasource, dynargs);
408     }
409     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
410         bytes[] memory dynargs = new bytes[](3);
411         dynargs[0] = args[0];
412         dynargs[1] = args[1];
413         dynargs[2] = args[2];
414         return oraclize_query(timestamp, datasource, dynargs);
415     }
416     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
417         bytes[] memory dynargs = new bytes[](3);
418         dynargs[0] = args[0];
419         dynargs[1] = args[1];
420         dynargs[2] = args[2];
421         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
422     }
423     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
424         bytes[] memory dynargs = new bytes[](3);
425         dynargs[0] = args[0];
426         dynargs[1] = args[1];
427         dynargs[2] = args[2];
428         return oraclize_query(datasource, dynargs, gaslimit);
429     }
430 
431     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
432         bytes[] memory dynargs = new bytes[](4);
433         dynargs[0] = args[0];
434         dynargs[1] = args[1];
435         dynargs[2] = args[2];
436         dynargs[3] = args[3];
437         return oraclize_query(datasource, dynargs);
438     }
439     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
440         bytes[] memory dynargs = new bytes[](4);
441         dynargs[0] = args[0];
442         dynargs[1] = args[1];
443         dynargs[2] = args[2];
444         dynargs[3] = args[3];
445         return oraclize_query(timestamp, datasource, dynargs);
446     }
447     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
448         bytes[] memory dynargs = new bytes[](4);
449         dynargs[0] = args[0];
450         dynargs[1] = args[1];
451         dynargs[2] = args[2];
452         dynargs[3] = args[3];
453         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
454     }
455     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
456         bytes[] memory dynargs = new bytes[](4);
457         dynargs[0] = args[0];
458         dynargs[1] = args[1];
459         dynargs[2] = args[2];
460         dynargs[3] = args[3];
461         return oraclize_query(datasource, dynargs, gaslimit);
462     }
463     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
464         bytes[] memory dynargs = new bytes[](5);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         dynargs[2] = args[2];
468         dynargs[3] = args[3];
469         dynargs[4] = args[4];
470         return oraclize_query(datasource, dynargs);
471     }
472     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
473         bytes[] memory dynargs = new bytes[](5);
474         dynargs[0] = args[0];
475         dynargs[1] = args[1];
476         dynargs[2] = args[2];
477         dynargs[3] = args[3];
478         dynargs[4] = args[4];
479         return oraclize_query(timestamp, datasource, dynargs);
480     }
481     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
482         bytes[] memory dynargs = new bytes[](5);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         dynargs[2] = args[2];
486         dynargs[3] = args[3];
487         dynargs[4] = args[4];
488         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
489     }
490     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
491         bytes[] memory dynargs = new bytes[](5);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         dynargs[2] = args[2];
495         dynargs[3] = args[3];
496         dynargs[4] = args[4];
497         return oraclize_query(datasource, dynargs, gaslimit);
498     }
499 
500     function oraclize_cbAddress() oraclizeAPI internal returns (address){
501         return oraclize.cbAddress();
502     }
503     function oraclize_setProof(byte proofP) oraclizeAPI internal {
504         return oraclize.setProofType(proofP);
505     }
506     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
507         return oraclize.setCustomGasPrice(gasPrice);
508     }
509 
510     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
511         return oraclize.randomDS_getSessionPubKeyHash();
512     }
513 
514     function getCodeSize(address _addr) constant internal returns(uint _size) {
515         assembly {
516             _size := extcodesize(_addr)
517         }
518     }
519 
520     function parseAddr(string _a) internal pure returns (address){
521         bytes memory tmp = bytes(_a);
522         uint160 iaddr = 0;
523         uint160 b1;
524         uint160 b2;
525         for (uint i=2; i<2+2*20; i+=2){
526             iaddr *= 256;
527             b1 = uint160(tmp[i]);
528             b2 = uint160(tmp[i+1]);
529             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
530             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
531             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
532             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
533             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
534             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
535             iaddr += (b1*16+b2);
536         }
537         return address(iaddr);
538     }
539 
540     function strCompare(string _a, string _b) internal pure returns (int) {
541         bytes memory a = bytes(_a);
542         bytes memory b = bytes(_b);
543         uint minLength = a.length;
544         if (b.length < minLength) minLength = b.length;
545         for (uint i = 0; i < minLength; i ++)
546             if (a[i] < b[i])
547                 return -1;
548             else if (a[i] > b[i])
549                 return 1;
550         if (a.length < b.length)
551             return -1;
552         else if (a.length > b.length)
553             return 1;
554         else
555             return 0;
556     }
557 
558     function indexOf(string _haystack, string _needle) internal pure returns (int) {
559         bytes memory h = bytes(_haystack);
560         bytes memory n = bytes(_needle);
561         if(h.length < 1 || n.length < 1 || (n.length > h.length))
562             return -1;
563         else if(h.length > (2**128 -1))
564             return -1;
565         else
566         {
567             uint subindex = 0;
568             for (uint i = 0; i < h.length; i ++)
569             {
570                 if (h[i] == n[0])
571                 {
572                     subindex = 1;
573                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
574                     {
575                         subindex++;
576                     }
577                     if(subindex == n.length)
578                         return int(i);
579                 }
580             }
581             return -1;
582         }
583     }
584 
585     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
586         bytes memory _ba = bytes(_a);
587         bytes memory _bb = bytes(_b);
588         bytes memory _bc = bytes(_c);
589         bytes memory _bd = bytes(_d);
590         bytes memory _be = bytes(_e);
591         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
592         bytes memory babcde = bytes(abcde);
593         uint k = 0;
594         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
595         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
596         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
597         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
598         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
599         return string(babcde);
600     }
601 
602     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
603         return strConcat(_a, _b, _c, _d, "");
604     }
605 
606     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
607         return strConcat(_a, _b, _c, "", "");
608     }
609 
610     function strConcat(string _a, string _b) internal pure returns (string) {
611         return strConcat(_a, _b, "", "", "");
612     }
613 
614     // parseInt
615     function parseInt(string _a) internal pure returns (uint) {
616         return parseInt(_a, 0);
617     }
618 
619     // parseInt(parseFloat*10^_b)
620     function parseInt(string _a, uint _b) internal pure returns (uint) {
621         bytes memory bresult = bytes(_a);
622         uint mint = 0;
623         bool decimals = false;
624         for (uint i=0; i<bresult.length; i++){
625             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
626                 if (decimals){
627                    if (_b == 0) break;
628                     else _b--;
629                 }
630                 mint *= 10;
631                 mint += uint(bresult[i]) - 48;
632             } else if (bresult[i] == 46) decimals = true;
633         }
634         if (_b > 0) mint *= 10**_b;
635         return mint;
636     }
637 
638     function uint2str(uint i) internal pure returns (string){
639         if (i == 0) return "0";
640         uint j = i;
641         uint len;
642         while (j != 0){
643             len++;
644             j /= 10;
645         }
646         bytes memory bstr = new bytes(len);
647         uint k = len - 1;
648         while (i != 0){
649             bstr[k--] = byte(48 + i % 10);
650             i /= 10;
651         }
652         return string(bstr);
653     }
654 
655     function stra2cbor(string[] arr) internal pure returns (bytes) {
656             uint arrlen = arr.length;
657 
658             // get correct cbor output length
659             uint outputlen = 0;
660             bytes[] memory elemArray = new bytes[](arrlen);
661             for (uint i = 0; i < arrlen; i++) {
662                 elemArray[i] = (bytes(arr[i]));
663                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
664             }
665             uint ctr = 0;
666             uint cborlen = arrlen + 0x80;
667             outputlen += byte(cborlen).length;
668             bytes memory res = new bytes(outputlen);
669 
670             while (byte(cborlen).length > ctr) {
671                 res[ctr] = byte(cborlen)[ctr];
672                 ctr++;
673             }
674             for (i = 0; i < arrlen; i++) {
675                 res[ctr] = 0x5F;
676                 ctr++;
677                 for (uint x = 0; x < elemArray[i].length; x++) {
678                     // if there's a bug with larger strings, this may be the culprit
679                     if (x % 23 == 0) {
680                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
681                         elemcborlen += 0x40;
682                         uint lctr = ctr;
683                         while (byte(elemcborlen).length > ctr - lctr) {
684                             res[ctr] = byte(elemcborlen)[ctr - lctr];
685                             ctr++;
686                         }
687                     }
688                     res[ctr] = elemArray[i][x];
689                     ctr++;
690                 }
691                 res[ctr] = 0xFF;
692                 ctr++;
693             }
694             return res;
695         }
696 
697     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
698             uint arrlen = arr.length;
699 
700             // get correct cbor output length
701             uint outputlen = 0;
702             bytes[] memory elemArray = new bytes[](arrlen);
703             for (uint i = 0; i < arrlen; i++) {
704                 elemArray[i] = (bytes(arr[i]));
705                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
706             }
707             uint ctr = 0;
708             uint cborlen = arrlen + 0x80;
709             outputlen += byte(cborlen).length;
710             bytes memory res = new bytes(outputlen);
711 
712             while (byte(cborlen).length > ctr) {
713                 res[ctr] = byte(cborlen)[ctr];
714                 ctr++;
715             }
716             for (i = 0; i < arrlen; i++) {
717                 res[ctr] = 0x5F;
718                 ctr++;
719                 for (uint x = 0; x < elemArray[i].length; x++) {
720                     // if there's a bug with larger strings, this may be the culprit
721                     if (x % 23 == 0) {
722                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
723                         elemcborlen += 0x40;
724                         uint lctr = ctr;
725                         while (byte(elemcborlen).length > ctr - lctr) {
726                             res[ctr] = byte(elemcborlen)[ctr - lctr];
727                             ctr++;
728                         }
729                     }
730                     res[ctr] = elemArray[i][x];
731                     ctr++;
732                 }
733                 res[ctr] = 0xFF;
734                 ctr++;
735             }
736             return res;
737         }
738 
739 
740     string oraclize_network_name;
741     function oraclize_setNetworkName(string _network_name) internal {
742         oraclize_network_name = _network_name;
743     }
744 
745     function oraclize_getNetworkName() internal view returns (string) {
746         return oraclize_network_name;
747     }
748 
749     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
750         require((_nbytes > 0) && (_nbytes <= 32));
751         bytes memory nbytes = new bytes(1);
752         nbytes[0] = byte(_nbytes);
753         bytes memory unonce = new bytes(32);
754         bytes memory sessionKeyHash = new bytes(32);
755         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
756         assembly {
757             mstore(unonce, 0x20)
758             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
759             mstore(sessionKeyHash, 0x20)
760             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
761         }
762         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
763         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
764         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
765         return queryId;
766     }
767 
768     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
769         oraclize_randomDS_args[queryId] = commitment;
770     }
771 
772     mapping(bytes32=>bytes32) oraclize_randomDS_args;
773     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
774 
775     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
776         bool sigok;
777         address signer;
778 
779         bytes32 sigr;
780         bytes32 sigs;
781 
782         bytes memory sigr_ = new bytes(32);
783         uint offset = 4+(uint(dersig[3]) - 0x20);
784         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
785         bytes memory sigs_ = new bytes(32);
786         offset += 32 + 2;
787         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
788 
789         assembly {
790             sigr := mload(add(sigr_, 32))
791             sigs := mload(add(sigs_, 32))
792         }
793 
794 
795         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
796         if (address(keccak256(pubkey)) == signer) return true;
797         else {
798             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
799             return (address(keccak256(pubkey)) == signer);
800         }
801     }
802 
803     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
804         bool sigok;
805 
806         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
807         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
808         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
809 
810         bytes memory appkey1_pubkey = new bytes(64);
811         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
812 
813         bytes memory tosign2 = new bytes(1+65+32);
814         tosign2[0] = byte(1); //role
815         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
816         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
817         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
818         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
819 
820         if (sigok == false) return false;
821 
822 
823         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
824         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
825 
826         bytes memory tosign3 = new bytes(1+65);
827         tosign3[0] = 0xFE;
828         copyBytes(proof, 3, 65, tosign3, 1);
829 
830         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
831         copyBytes(proof, 3+65, sig3.length, sig3, 0);
832 
833         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
834 
835         return sigok;
836     }
837 
838     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
839         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
840         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
841 
842         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
843         require(proofVerified);
844 
845         _;
846     }
847 
848     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
849         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
850         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
851 
852         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
853         if (proofVerified == false) return 2;
854 
855         return 0;
856     }
857 
858     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
859         bool match_ = true;
860 
861 
862         for (uint256 i=0; i< n_random_bytes; i++) {
863             if (content[i] != prefix[i]) match_ = false;
864         }
865 
866         return match_;
867     }
868 
869     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
870 
871         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
872         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
873         bytes memory keyhash = new bytes(32);
874         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
875         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
876 
877         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
878         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
879 
880         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
881         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
882 
883         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
884         // This is to verify that the computed args match with the ones specified in the query.
885         bytes memory commitmentSlice1 = new bytes(8+1+32);
886         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
887 
888         bytes memory sessionPubkey = new bytes(64);
889         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
890         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
891 
892         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
893         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
894             delete oraclize_randomDS_args[queryId];
895         } else return false;
896 
897 
898         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
899         bytes memory tosign1 = new bytes(32+8+1+32);
900         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
901         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
902 
903         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
904         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
905             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
906         }
907 
908         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
909     }
910 
911     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
912     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
913         uint minLength = length + toOffset;
914 
915         // Buffer too small
916         require(to.length >= minLength); // Should be a better way?
917 
918         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
919         uint i = 32 + fromOffset;
920         uint j = 32 + toOffset;
921 
922         while (i < (32 + fromOffset + length)) {
923             assembly {
924                 let tmp := mload(add(from, i))
925                 mstore(add(to, j), tmp)
926             }
927             i += 32;
928             j += 32;
929         }
930 
931         return to;
932     }
933 
934     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
935     // Duplicate Solidity's ecrecover, but catching the CALL return value
936     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
937         // We do our own memory management here. Solidity uses memory offset
938         // 0x40 to store the current end of memory. We write past it (as
939         // writes are memory extensions), but don't update the offset so
940         // Solidity will reuse it. The memory used here is only needed for
941         // this context.
942 
943         // FIXME: inline assembly can't access return values
944         bool ret;
945         address addr;
946 
947         assembly {
948             let size := mload(0x40)
949             mstore(size, hash)
950             mstore(add(size, 32), v)
951             mstore(add(size, 64), r)
952             mstore(add(size, 96), s)
953 
954             // NOTE: we can reuse the request memory because we deal with
955             //       the return code
956             ret := call(3000, 1, 0, size, 128, size, 32)
957             addr := mload(size)
958         }
959 
960         return (ret, addr);
961     }
962 
963     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
964     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
965         bytes32 r;
966         bytes32 s;
967         uint8 v;
968 
969         if (sig.length != 65)
970           return (false, 0);
971 
972         // The signature format is a compact form of:
973         //   {bytes32 r}{bytes32 s}{uint8 v}
974         // Compact means, uint8 is not padded to 32 bytes.
975         assembly {
976             r := mload(add(sig, 32))
977             s := mload(add(sig, 64))
978 
979             // Here we are loading the last 32 bytes. We exploit the fact that
980             // 'mload' will pad with zeroes if we overread.
981             // There is no 'mload8' to do this, but that would be nicer.
982             v := byte(0, mload(add(sig, 96)))
983 
984             // Alternative solution:
985             // 'byte' is not working due to the Solidity parser, so lets
986             // use the second best option, 'and'
987             // v := and(mload(add(sig, 65)), 255)
988         }
989 
990         // albeit non-transactional signatures are not specified by the YP, one would expect it
991         // to match the YP range of [27, 28]
992         //
993         // geth uses [0, 1] and some clients have followed. This might change, see:
994         //  https://github.com/ethereum/go-ethereum/issues/2053
995         if (v < 27)
996           v += 27;
997 
998         if (v != 27 && v != 28)
999             return (false, 0);
1000 
1001         return safer_ecrecover(hash, v, r, s);
1002     }
1003 
1004 }
1005 
1006     contract SafeMath {
1007 
1008         function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
1009           uint256 z = x + y;
1010           assert((z >= x) && (z >= y));
1011           return z;
1012         }
1013 
1014         function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
1015           assert(x >= y);
1016           uint256 z = x - y;
1017           return z;
1018         }
1019 
1020         function safeMult(uint256 x, uint256 y) internal returns(uint256) {
1021           uint256 z = x * y;
1022           assert((x == 0)||(z/x == y));
1023           return z;
1024         }
1025 
1026     }
1027 
1028     contract Token {
1029         uint256 public totalSupply;
1030         function balanceOf(address _owner) constant returns (uint256 balance);
1031         function transfer(address _to, uint256 _value) returns (bool success);
1032         function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
1033         function approve(address _spender, uint256 _value) returns (bool success);
1034         function allowance(address _owner, address _spender) constant returns (uint256 remaining);
1035         event Transfer(address indexed _from, address indexed _to, uint256 _value);
1036         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
1037     }
1038 
1039     contract StandardToken is Token {
1040         uint256 public fundingEndBlock;
1041 
1042         function transfer(address _to, uint256 _value) returns (bool success) {
1043           require (block.number > fundingEndBlock);
1044           if (balances[msg.sender] >= _value && _value > 0) {
1045             balances[msg.sender] -= _value;
1046             balances[_to] += _value;
1047             Transfer(msg.sender, _to, _value);
1048             return true;
1049           } else {
1050             return false;
1051           }
1052         }
1053 
1054         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
1055           require (block.number > fundingEndBlock);
1056           if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
1057             balances[_to] += _value;
1058             balances[_from] -= _value;
1059             allowed[_from][msg.sender] -= _value;
1060             Transfer(_from, _to, _value);
1061             return true;
1062           } else {
1063             return false;
1064           }
1065         }
1066 
1067         function balanceOf(address _owner) constant returns (uint256 balance) {
1068             return balances[_owner];
1069         }
1070 
1071         function approve(address _spender, uint256 _value) returns (bool success) {
1072             require (block.number > fundingEndBlock);
1073             allowed[msg.sender][_spender] = _value;
1074             Approval(msg.sender, _spender, _value);
1075             return true;
1076         }
1077 
1078         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
1079           return allowed[_owner][_spender];
1080         }
1081 
1082         mapping (address => uint256) balances;
1083         mapping (address => mapping (address => uint256)) allowed;
1084     }
1085 
1086     contract CryptoCongress is StandardToken, SafeMath, usingOraclize {
1087         mapping(bytes => uint256) initialAllotments;
1088         mapping(bytes32 => bytes) validQueryIds; // Keeps track of Oraclize queries. 
1089         
1090         string public constant name = "CryptoCongress";
1091         string public constant symbol = "CC";
1092         uint256 public constant decimals = 18;
1093         string public constant requiredPrefix = "CryptoCongress ";
1094         string public constant a = "html(https://twitter.com/";
1095         string public constant b = "/status/";
1096         string public constant c = ").xpath(//*[contains(@class, 'TweetTextSize--jumbo')]/text())";
1097 
1098         address public ethFundDeposit; 
1099       
1100         // Crowdsale parameters
1101         uint256 public fundingStartBlock;
1102         uint256 public totalSupply = 0;
1103         uint256 public totalSupplyFromCrowdsale = 0;
1104 
1105         uint256 public constant tokenExchangeRate = 30; // 30 CC tokens per 1 ETH purchased at crowdsale
1106         uint256 public constant tokenCreationCap =  131583 * (10**3) * 10**decimals;  // 131,583,000 tokens
1107         
1108         event InitialAllotmentRecorded(string username, uint256 initialAllotment);
1109         
1110         // Oraclize events
1111         event newOraclizeQuery(string url);
1112         event newOraclizeCallback(string result, bytes proof);
1113 
1114         event InitialAllotmentClaimed(bytes username);
1115         event Proposal(string ID, string description, string data);
1116         event Vote(string proposalID, string vote, string data);
1117         
1118         // Constructor
1119         function CryptoCongress (
1120             address _ethFundDeposit,
1121             uint256 _fundingStartBlock,
1122             uint256 _fundingEndBlock) payable
1123         {                 
1124           ethFundDeposit = _ethFundDeposit;
1125           fundingStartBlock = _fundingStartBlock;
1126           fundingEndBlock = _fundingEndBlock;
1127 
1128           // Allows us to prove correct return from Oraclize
1129           oraclize_setProof(proofType_TLSNotary);
1130         }
1131 
1132         function createInitialAllotment(
1133             string username, 
1134             uint256 initialAllotment) 
1135         {
1136           require (msg.sender == ethFundDeposit);
1137           require (block.number < fundingStartBlock); 
1138           initialAllotments[bytes(username)] = initialAllotment;
1139           InitialAllotmentRecorded(username, initialAllotment);
1140         }
1141 
1142         function claimInitialAllotment(string twitterStatusID, string username) payable {
1143           bytes memory usernameAsBytes = bytes(username);
1144           require (usernameAsBytes.length < 16);
1145           require (msg.value > 4000000000000000); // accounts for oraclize fee
1146           require (block.number > fundingStartBlock);
1147           require (block.number < fundingEndBlock);
1148           require (initialAllotments[usernameAsBytes] > 0); // Check there are tokens to claim.
1149           
1150           string memory url = usingOraclize.strConcat(a,username,b,twitterStatusID,c);
1151          
1152           newOraclizeQuery(url);
1153           bytes32 queryId = oraclize_query("URL",url);
1154           validQueryIds[queryId] = usernameAsBytes;
1155         
1156         }
1157 
1158         function __callback(bytes32 myid, string result, bytes proof) {
1159             // Must be oraclize
1160             require (msg.sender == oraclize_cbAddress()); 
1161             newOraclizeCallback(result, proof);
1162           
1163             // // Require that the username not have claimed token allotment already
1164             require (initialAllotments[validQueryIds[myid]] > 0);  
1165 
1166             // Extra safety below; it should still satisfy basic requirements
1167             require (block.number > fundingStartBlock);
1168             require (block.number < fundingEndBlock);
1169           
1170             bytes memory resultBytes = bytes(result);
1171             
1172             // // Claiming tweet must be exactly 57 bytes
1173             // // 15 byte "CryptoCongress + 42 byte address"
1174             require (resultBytes.length == 57);
1175             
1176             // // First 16 bytes must be "#CryptoCongress " (ending whitespace included)
1177             // // In hex = 0x 43 72 79 70 74 6f 43 6f 6e 67 72 65 73 73 20
1178             require (resultBytes[0] == 0x43);
1179             require (resultBytes[1] == 0x72); 
1180             require (resultBytes[2] == 0x79);
1181             require (resultBytes[3] == 0x70);
1182             require (resultBytes[4] == 0x74);
1183             require (resultBytes[5] == 0x6f);
1184             require (resultBytes[6] == 0x43);
1185             require (resultBytes[7] == 0x6f);
1186             require (resultBytes[8] == 0x6e);
1187             require (resultBytes[9] == 0x67);
1188             require (resultBytes[10] == 0x72);
1189             require (resultBytes[11] == 0x65);
1190             require (resultBytes[12] == 0x73);
1191             require (resultBytes[13] == 0x73);
1192             require (resultBytes[14] == 0x20);
1193   
1194             // // Next 20 characters are the address
1195             // // Must start with 0x
1196             require (resultBytes[15] == 0x30);
1197             require (resultBytes[16] == 0x78);
1198             
1199             uint addrUint = 0;
1200             
1201             for (uint i = resultBytes.length-1; i+1 > 15; i--) {
1202                 uint d = uint(resultBytes[i]);
1203                 uint to_inc = d * ( 15 ** ((resultBytes.length - i-1) * 2));
1204                 addrUint += to_inc;
1205             }
1206         
1207             address addr =  address(addrUint);
1208             
1209             uint256 tokenAllotment = initialAllotments[validQueryIds[myid]];
1210             uint256 checkedSupply = safeAdd(totalSupply, tokenAllotment);
1211             require (tokenCreationCap > checkedSupply); // extra safe
1212             totalSupply = checkedSupply;
1213 
1214             initialAllotments[validQueryIds[myid]] = 0;
1215             balances[addr] += tokenAllotment;  // SafeAdd not needed; bad semantics to use here
1216 
1217             // Logs token creation by username (bytes)
1218             InitialAllotmentClaimed(validQueryIds[myid]); // Log the bytes of the username who claimed funds 
1219             delete validQueryIds[myid];
1220             
1221             // Logs token creation by address for ERC20 front end compatibility
1222             Transfer(0x0,addr,tokenAllotment);
1223 
1224         }
1225 
1226         // Accepts ether and creates new CC tokens.
1227         // Enforces that no more than 1/3rd of tokens are be created by sale.
1228         function buyTokens(address beneficiary) public payable {
1229           require(beneficiary != address(0)); 
1230           require(msg.value != 0);
1231           require (block.number > fundingStartBlock);
1232           require (block.number < fundingEndBlock);
1233 
1234           uint256 tokens = safeMult(msg.value, tokenExchangeRate); 
1235           
1236           uint256 checkedTotalSupply = safeAdd(totalSupply, tokens); 
1237           uint256 checkedCrowdsaleSupply = safeAdd(totalSupplyFromCrowdsale, tokens);
1238 
1239           // (1) Enforces we don't go over total supply with potential sale. 
1240           require (tokenCreationCap > checkedTotalSupply);  
1241           
1242           // (2) Enforces that no more than 1/3rd of tokens are to be created by potential sale.
1243           require (safeMult(checkedCrowdsaleSupply, 3) < totalSupply);
1244        
1245           totalSupply = checkedTotalSupply;
1246           totalSupplyFromCrowdsale = checkedCrowdsaleSupply;
1247           
1248           balances[msg.sender] += tokens;  // safeAdd not needed
1249           
1250           // Logs token creation for ERC20 front end compatibility
1251           // All crowdsale purchases will enter via fallback function
1252           Transfer(0x0, beneficiary, tokens);  
1253         
1254         }
1255 
1256         // Secure withdraw
1257         function secureTransfer(uint256 amount) external {
1258           require (msg.sender == ethFundDeposit); 
1259           assert (ethFundDeposit.send(amount));  
1260         }
1261 
1262         function propose(string _ID, string _description, string _data) {
1263           require(bytes(_ID).length < 281 && bytes(_description).length < 281 && bytes(_data).length < 281);
1264           require (balances[msg.sender] > 70000000000000000000000);
1265           Proposal(_ID, _description, _data);
1266         }
1267 
1268         function vote(string _proposalID, string _vote, string _data) {
1269           require(bytes(_proposalID).length < 281 && bytes(_vote).length < 281 && bytes(_data).length < 281);
1270           require (balances[msg.sender] > 50000000000000000000000);
1271           Vote(_proposalID, _vote, _data);
1272         }
1273 
1274         // Payable fallback to ensure privacy.
1275         function () payable {
1276             buyTokens(msg.sender);
1277         }
1278 
1279     }