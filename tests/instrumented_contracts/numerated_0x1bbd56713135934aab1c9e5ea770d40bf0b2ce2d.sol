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
42         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
43             oraclize_setNetwork(networkID_auto);
44 
45         if(address(oraclize) != OAR.getAddress())
46             oraclize = OraclizeI(OAR.getAddress());
47 
48         _;
49     }
50     modifier coupon(string code){
51         oraclize = OraclizeI(OAR.getAddress());
52         oraclize.useCoupon(code);
53         _;
54     }
55 
56     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
57         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
58             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
59             oraclize_setNetworkName("eth_mainnet");
60             return true;
61         }
62         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
63             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
64             oraclize_setNetworkName("eth_ropsten3");
65             return true;
66         }
67         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
68             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
69             oraclize_setNetworkName("eth_kovan");
70             return true;
71         }
72         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
73             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
74             oraclize_setNetworkName("eth_rinkeby");
75             return true;
76         }
77         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
78             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
79             return true;
80         }
81         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
82             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
83             return true;
84         }
85         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
86             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
87             return true;
88         }
89         return false;
90     }
91 
92     function __callback(bytes32 myid, string result) {
93         __callback(myid, result, new bytes(0));
94     }
95     function __callback(bytes32 myid, string result, bytes proof) {
96     }
97 
98     function oraclize_useCoupon(string code) oraclizeAPI internal {
99         oraclize.useCoupon(code);
100     }
101 
102     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
103         return oraclize.getPrice(datasource);
104     }
105 
106     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
107         return oraclize.getPrice(datasource, gaslimit);
108     }
109 
110     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
111         uint price = oraclize.getPrice(datasource);
112         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
113         return oraclize.query.value(price)(0, datasource, arg);
114     }
115     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
116         uint price = oraclize.getPrice(datasource);
117         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
118         return oraclize.query.value(price)(timestamp, datasource, arg);
119     }
120     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
121         uint price = oraclize.getPrice(datasource, gaslimit);
122         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
123         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
124     }
125     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
126         uint price = oraclize.getPrice(datasource, gaslimit);
127         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
128         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
129     }
130     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
131         uint price = oraclize.getPrice(datasource);
132         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
133         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
134     }
135     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
136         uint price = oraclize.getPrice(datasource);
137         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
138         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
139     }
140     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
141         uint price = oraclize.getPrice(datasource, gaslimit);
142         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
143         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
144     }
145     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
146         uint price = oraclize.getPrice(datasource, gaslimit);
147         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
148         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
149     }
150     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
151         uint price = oraclize.getPrice(datasource);
152         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
153         bytes memory args = stra2cbor(argN);
154         return oraclize.queryN.value(price)(0, datasource, args);
155     }
156     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
157         uint price = oraclize.getPrice(datasource);
158         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
159         bytes memory args = stra2cbor(argN);
160         return oraclize.queryN.value(price)(timestamp, datasource, args);
161     }
162     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
163         uint price = oraclize.getPrice(datasource, gaslimit);
164         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
165         bytes memory args = stra2cbor(argN);
166         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
167     }
168     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
169         uint price = oraclize.getPrice(datasource, gaslimit);
170         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
171         bytes memory args = stra2cbor(argN);
172         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
173     }
174     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
175         string[] memory dynargs = new string[](1);
176         dynargs[0] = args[0];
177         return oraclize_query(datasource, dynargs);
178     }
179     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
180         string[] memory dynargs = new string[](1);
181         dynargs[0] = args[0];
182         return oraclize_query(timestamp, datasource, dynargs);
183     }
184     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
185         string[] memory dynargs = new string[](1);
186         dynargs[0] = args[0];
187         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
188     }
189     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
190         string[] memory dynargs = new string[](1);
191         dynargs[0] = args[0];
192         return oraclize_query(datasource, dynargs, gaslimit);
193     }
194 
195     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
196         string[] memory dynargs = new string[](2);
197         dynargs[0] = args[0];
198         dynargs[1] = args[1];
199         return oraclize_query(datasource, dynargs);
200     }
201     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
202         string[] memory dynargs = new string[](2);
203         dynargs[0] = args[0];
204         dynargs[1] = args[1];
205         return oraclize_query(timestamp, datasource, dynargs);
206     }
207     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
208         string[] memory dynargs = new string[](2);
209         dynargs[0] = args[0];
210         dynargs[1] = args[1];
211         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
212     }
213     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
214         string[] memory dynargs = new string[](2);
215         dynargs[0] = args[0];
216         dynargs[1] = args[1];
217         return oraclize_query(datasource, dynargs, gaslimit);
218     }
219     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
220         string[] memory dynargs = new string[](3);
221         dynargs[0] = args[0];
222         dynargs[1] = args[1];
223         dynargs[2] = args[2];
224         return oraclize_query(datasource, dynargs);
225     }
226     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
227         string[] memory dynargs = new string[](3);
228         dynargs[0] = args[0];
229         dynargs[1] = args[1];
230         dynargs[2] = args[2];
231         return oraclize_query(timestamp, datasource, dynargs);
232     }
233     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
234         string[] memory dynargs = new string[](3);
235         dynargs[0] = args[0];
236         dynargs[1] = args[1];
237         dynargs[2] = args[2];
238         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
239     }
240     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
241         string[] memory dynargs = new string[](3);
242         dynargs[0] = args[0];
243         dynargs[1] = args[1];
244         dynargs[2] = args[2];
245         return oraclize_query(datasource, dynargs, gaslimit);
246     }
247 
248     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
249         string[] memory dynargs = new string[](4);
250         dynargs[0] = args[0];
251         dynargs[1] = args[1];
252         dynargs[2] = args[2];
253         dynargs[3] = args[3];
254         return oraclize_query(datasource, dynargs);
255     }
256     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
257         string[] memory dynargs = new string[](4);
258         dynargs[0] = args[0];
259         dynargs[1] = args[1];
260         dynargs[2] = args[2];
261         dynargs[3] = args[3];
262         return oraclize_query(timestamp, datasource, dynargs);
263     }
264     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
265         string[] memory dynargs = new string[](4);
266         dynargs[0] = args[0];
267         dynargs[1] = args[1];
268         dynargs[2] = args[2];
269         dynargs[3] = args[3];
270         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
271     }
272     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
273         string[] memory dynargs = new string[](4);
274         dynargs[0] = args[0];
275         dynargs[1] = args[1];
276         dynargs[2] = args[2];
277         dynargs[3] = args[3];
278         return oraclize_query(datasource, dynargs, gaslimit);
279     }
280     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
281         string[] memory dynargs = new string[](5);
282         dynargs[0] = args[0];
283         dynargs[1] = args[1];
284         dynargs[2] = args[2];
285         dynargs[3] = args[3];
286         dynargs[4] = args[4];
287         return oraclize_query(datasource, dynargs);
288     }
289     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
290         string[] memory dynargs = new string[](5);
291         dynargs[0] = args[0];
292         dynargs[1] = args[1];
293         dynargs[2] = args[2];
294         dynargs[3] = args[3];
295         dynargs[4] = args[4];
296         return oraclize_query(timestamp, datasource, dynargs);
297     }
298     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
299         string[] memory dynargs = new string[](5);
300         dynargs[0] = args[0];
301         dynargs[1] = args[1];
302         dynargs[2] = args[2];
303         dynargs[3] = args[3];
304         dynargs[4] = args[4];
305         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
306     }
307     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
308         string[] memory dynargs = new string[](5);
309         dynargs[0] = args[0];
310         dynargs[1] = args[1];
311         dynargs[2] = args[2];
312         dynargs[3] = args[3];
313         dynargs[4] = args[4];
314         return oraclize_query(datasource, dynargs, gaslimit);
315     }
316     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
317         uint price = oraclize.getPrice(datasource);
318         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
319         bytes memory args = ba2cbor(argN);
320         return oraclize.queryN.value(price)(0, datasource, args);
321     }
322     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
323         uint price = oraclize.getPrice(datasource);
324         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
325         bytes memory args = ba2cbor(argN);
326         return oraclize.queryN.value(price)(timestamp, datasource, args);
327     }
328     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
329         uint price = oraclize.getPrice(datasource, gaslimit);
330         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
331         bytes memory args = ba2cbor(argN);
332         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
333     }
334     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
335         uint price = oraclize.getPrice(datasource, gaslimit);
336         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
337         bytes memory args = ba2cbor(argN);
338         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
339     }
340     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
341         bytes[] memory dynargs = new bytes[](1);
342         dynargs[0] = args[0];
343         return oraclize_query(datasource, dynargs);
344     }
345     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
346         bytes[] memory dynargs = new bytes[](1);
347         dynargs[0] = args[0];
348         return oraclize_query(timestamp, datasource, dynargs);
349     }
350     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
351         bytes[] memory dynargs = new bytes[](1);
352         dynargs[0] = args[0];
353         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
354     }
355     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
356         bytes[] memory dynargs = new bytes[](1);
357         dynargs[0] = args[0];
358         return oraclize_query(datasource, dynargs, gaslimit);
359     }
360 
361     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
362         bytes[] memory dynargs = new bytes[](2);
363         dynargs[0] = args[0];
364         dynargs[1] = args[1];
365         return oraclize_query(datasource, dynargs);
366     }
367     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
368         bytes[] memory dynargs = new bytes[](2);
369         dynargs[0] = args[0];
370         dynargs[1] = args[1];
371         return oraclize_query(timestamp, datasource, dynargs);
372     }
373     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
374         bytes[] memory dynargs = new bytes[](2);
375         dynargs[0] = args[0];
376         dynargs[1] = args[1];
377         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
378     }
379     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
380         bytes[] memory dynargs = new bytes[](2);
381         dynargs[0] = args[0];
382         dynargs[1] = args[1];
383         return oraclize_query(datasource, dynargs, gaslimit);
384     }
385     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
386         bytes[] memory dynargs = new bytes[](3);
387         dynargs[0] = args[0];
388         dynargs[1] = args[1];
389         dynargs[2] = args[2];
390         return oraclize_query(datasource, dynargs);
391     }
392     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
393         bytes[] memory dynargs = new bytes[](3);
394         dynargs[0] = args[0];
395         dynargs[1] = args[1];
396         dynargs[2] = args[2];
397         return oraclize_query(timestamp, datasource, dynargs);
398     }
399     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
400         bytes[] memory dynargs = new bytes[](3);
401         dynargs[0] = args[0];
402         dynargs[1] = args[1];
403         dynargs[2] = args[2];
404         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
405     }
406     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
407         bytes[] memory dynargs = new bytes[](3);
408         dynargs[0] = args[0];
409         dynargs[1] = args[1];
410         dynargs[2] = args[2];
411         return oraclize_query(datasource, dynargs, gaslimit);
412     }
413 
414     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
415         bytes[] memory dynargs = new bytes[](4);
416         dynargs[0] = args[0];
417         dynargs[1] = args[1];
418         dynargs[2] = args[2];
419         dynargs[3] = args[3];
420         return oraclize_query(datasource, dynargs);
421     }
422     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
423         bytes[] memory dynargs = new bytes[](4);
424         dynargs[0] = args[0];
425         dynargs[1] = args[1];
426         dynargs[2] = args[2];
427         dynargs[3] = args[3];
428         return oraclize_query(timestamp, datasource, dynargs);
429     }
430     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
431         bytes[] memory dynargs = new bytes[](4);
432         dynargs[0] = args[0];
433         dynargs[1] = args[1];
434         dynargs[2] = args[2];
435         dynargs[3] = args[3];
436         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
437     }
438     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
439         bytes[] memory dynargs = new bytes[](4);
440         dynargs[0] = args[0];
441         dynargs[1] = args[1];
442         dynargs[2] = args[2];
443         dynargs[3] = args[3];
444         return oraclize_query(datasource, dynargs, gaslimit);
445     }
446     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
447         bytes[] memory dynargs = new bytes[](5);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         dynargs[2] = args[2];
451         dynargs[3] = args[3];
452         dynargs[4] = args[4];
453         return oraclize_query(datasource, dynargs);
454     }
455     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
456         bytes[] memory dynargs = new bytes[](5);
457         dynargs[0] = args[0];
458         dynargs[1] = args[1];
459         dynargs[2] = args[2];
460         dynargs[3] = args[3];
461         dynargs[4] = args[4];
462         return oraclize_query(timestamp, datasource, dynargs);
463     }
464     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
465         bytes[] memory dynargs = new bytes[](5);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         dynargs[2] = args[2];
469         dynargs[3] = args[3];
470         dynargs[4] = args[4];
471         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
472     }
473     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         bytes[] memory dynargs = new bytes[](5);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         dynargs[2] = args[2];
478         dynargs[3] = args[3];
479         dynargs[4] = args[4];
480         return oraclize_query(datasource, dynargs, gaslimit);
481     }
482 
483     function oraclize_cbAddress() oraclizeAPI internal returns (address){
484         return oraclize.cbAddress();
485     }
486     function oraclize_setProof(byte proofP) oraclizeAPI internal {
487         return oraclize.setProofType(proofP);
488     }
489     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
490         return oraclize.setCustomGasPrice(gasPrice);
491     }
492     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
493         return oraclize.setConfig(config);
494     }
495 
496     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
497         return oraclize.randomDS_getSessionPubKeyHash();
498     }
499 
500     function getCodeSize(address _addr) constant internal returns(uint _size) {
501         assembly {
502             _size := extcodesize(_addr)
503         }
504     }
505 
506     function parseAddr(string _a) internal returns (address){
507         bytes memory tmp = bytes(_a);
508         uint160 iaddr = 0;
509         uint160 b1;
510         uint160 b2;
511         for (uint i=2; i<2+2*20; i+=2){
512             iaddr *= 256;
513             b1 = uint160(tmp[i]);
514             b2 = uint160(tmp[i+1]);
515             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
516             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
517             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
518             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
519             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
520             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
521             iaddr += (b1*16+b2);
522         }
523         return address(iaddr);
524     }
525 
526     function strCompare(string _a, string _b) internal returns (int) {
527         bytes memory a = bytes(_a);
528         bytes memory b = bytes(_b);
529         uint minLength = a.length;
530         if (b.length < minLength) minLength = b.length;
531         for (uint i = 0; i < minLength; i ++)
532             if (a[i] < b[i])
533                 return -1;
534             else if (a[i] > b[i])
535                 return 1;
536         if (a.length < b.length)
537             return -1;
538         else if (a.length > b.length)
539             return 1;
540         else
541             return 0;
542     }
543 
544     function indexOf(string _haystack, string _needle) internal returns (int) {
545         bytes memory h = bytes(_haystack);
546         bytes memory n = bytes(_needle);
547         if(h.length < 1 || n.length < 1 || (n.length > h.length))
548             return -1;
549         else if(h.length > (2**128 -1))
550             return -1;
551         else
552         {
553             uint subindex = 0;
554             for (uint i = 0; i < h.length; i ++)
555             {
556                 if (h[i] == n[0])
557                 {
558                     subindex = 1;
559                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
560                     {
561                         subindex++;
562                     }
563                     if(subindex == n.length)
564                         return int(i);
565                 }
566             }
567             return -1;
568         }
569     }
570 
571     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
572         bytes memory _ba = bytes(_a);
573         bytes memory _bb = bytes(_b);
574         bytes memory _bc = bytes(_c);
575         bytes memory _bd = bytes(_d);
576         bytes memory _be = bytes(_e);
577         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
578         bytes memory babcde = bytes(abcde);
579         uint k = 0;
580         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
581         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
582         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
583         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
584         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
585         return string(babcde);
586     }
587 
588     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
589         return strConcat(_a, _b, _c, _d, "");
590     }
591 
592     function strConcat(string _a, string _b, string _c) internal returns (string) {
593         return strConcat(_a, _b, _c, "", "");
594     }
595 
596     function strConcat(string _a, string _b) internal returns (string) {
597         return strConcat(_a, _b, "", "", "");
598     }
599 
600     // parseInt
601     function parseInt(string _a) internal returns (uint) {
602         return parseInt(_a, 0);
603     }
604 
605     // parseInt(parseFloat*10^_b)
606     function parseInt(string _a, uint _b) internal returns (uint) {
607         bytes memory bresult = bytes(_a);
608         uint mint = 0;
609         bool decimals = false;
610         for (uint i=0; i<bresult.length; i++){
611             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
612                 if (decimals){
613                    if (_b == 0) break;
614                     else _b--;
615                 }
616                 mint *= 10;
617                 mint += uint(bresult[i]) - 48;
618             } else if (bresult[i] == 46) decimals = true;
619         }
620         if (_b > 0) mint *= 10**_b;
621         return mint;
622     }
623 
624     function uint2str(uint i) internal returns (string){
625         if (i == 0) return "0";
626         uint j = i;
627         uint len;
628         while (j != 0){
629             len++;
630             j /= 10;
631         }
632         bytes memory bstr = new bytes(len);
633         uint k = len - 1;
634         while (i != 0){
635             bstr[k--] = byte(48 + i % 10);
636             i /= 10;
637         }
638         return string(bstr);
639     }
640 
641     function stra2cbor(string[] arr) internal returns (bytes) {
642             uint arrlen = arr.length;
643 
644             // get correct cbor output length
645             uint outputlen = 0;
646             bytes[] memory elemArray = new bytes[](arrlen);
647             for (uint i = 0; i < arrlen; i++) {
648                 elemArray[i] = (bytes(arr[i]));
649                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
650             }
651             uint ctr = 0;
652             uint cborlen = arrlen + 0x80;
653             outputlen += byte(cborlen).length;
654             bytes memory res = new bytes(outputlen);
655 
656             while (byte(cborlen).length > ctr) {
657                 res[ctr] = byte(cborlen)[ctr];
658                 ctr++;
659             }
660             for (i = 0; i < arrlen; i++) {
661                 res[ctr] = 0x5F;
662                 ctr++;
663                 for (uint x = 0; x < elemArray[i].length; x++) {
664                     // if there's a bug with larger strings, this may be the culprit
665                     if (x % 23 == 0) {
666                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
667                         elemcborlen += 0x40;
668                         uint lctr = ctr;
669                         while (byte(elemcborlen).length > ctr - lctr) {
670                             res[ctr] = byte(elemcborlen)[ctr - lctr];
671                             ctr++;
672                         }
673                     }
674                     res[ctr] = elemArray[i][x];
675                     ctr++;
676                 }
677                 res[ctr] = 0xFF;
678                 ctr++;
679             }
680             return res;
681         }
682 
683     function ba2cbor(bytes[] arr) internal returns (bytes) {
684             uint arrlen = arr.length;
685 
686             // get correct cbor output length
687             uint outputlen = 0;
688             bytes[] memory elemArray = new bytes[](arrlen);
689             for (uint i = 0; i < arrlen; i++) {
690                 elemArray[i] = (bytes(arr[i]));
691                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
692             }
693             uint ctr = 0;
694             uint cborlen = arrlen + 0x80;
695             outputlen += byte(cborlen).length;
696             bytes memory res = new bytes(outputlen);
697 
698             while (byte(cborlen).length > ctr) {
699                 res[ctr] = byte(cborlen)[ctr];
700                 ctr++;
701             }
702             for (i = 0; i < arrlen; i++) {
703                 res[ctr] = 0x5F;
704                 ctr++;
705                 for (uint x = 0; x < elemArray[i].length; x++) {
706                     // if there's a bug with larger strings, this may be the culprit
707                     if (x % 23 == 0) {
708                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
709                         elemcborlen += 0x40;
710                         uint lctr = ctr;
711                         while (byte(elemcborlen).length > ctr - lctr) {
712                             res[ctr] = byte(elemcborlen)[ctr - lctr];
713                             ctr++;
714                         }
715                     }
716                     res[ctr] = elemArray[i][x];
717                     ctr++;
718                 }
719                 res[ctr] = 0xFF;
720                 ctr++;
721             }
722             return res;
723         }
724 
725 
726     string oraclize_network_name;
727     function oraclize_setNetworkName(string _network_name) internal {
728         oraclize_network_name = _network_name;
729     }
730 
731     function oraclize_getNetworkName() internal returns (string) {
732         return oraclize_network_name;
733     }
734 
735     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
736         if ((_nbytes == 0)||(_nbytes > 32)) throw;
737 	// Convert from seconds to ledger timer ticks
738         _delay *= 10; 
739         bytes memory nbytes = new bytes(1);
740         nbytes[0] = byte(_nbytes);
741         bytes memory unonce = new bytes(32);
742         bytes memory sessionKeyHash = new bytes(32);
743         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
744         assembly {
745             mstore(unonce, 0x20)
746             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
747             mstore(sessionKeyHash, 0x20)
748             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
749         }
750         bytes memory delay = new bytes(32);
751         assembly { 
752             mstore(add(delay, 0x20), _delay) 
753         }
754         
755         bytes memory delay_bytes8 = new bytes(8);
756         copyBytes(delay, 24, 8, delay_bytes8, 0);
757 
758         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
759         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
760         
761         bytes memory delay_bytes8_left = new bytes(8);
762         
763         assembly {
764             let x := mload(add(delay_bytes8, 0x20))
765             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
766             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
767             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
768             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
769             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
770             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
771             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
772             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
773 
774         }
775         
776         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
777         return queryId;
778     }
779     
780     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
781         oraclize_randomDS_args[queryId] = commitment;
782     }
783 
784     mapping(bytes32=>bytes32) oraclize_randomDS_args;
785     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
786 
787     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
788         bool sigok;
789         address signer;
790 
791         bytes32 sigr;
792         bytes32 sigs;
793 
794         bytes memory sigr_ = new bytes(32);
795         uint offset = 4+(uint(dersig[3]) - 0x20);
796         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
797         bytes memory sigs_ = new bytes(32);
798         offset += 32 + 2;
799         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
800 
801         assembly {
802             sigr := mload(add(sigr_, 32))
803             sigs := mload(add(sigs_, 32))
804         }
805 
806 
807         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
808         if (address(sha3(pubkey)) == signer) return true;
809         else {
810             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
811             return (address(sha3(pubkey)) == signer);
812         }
813     }
814 
815     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
816         bool sigok;
817 
818         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
819         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
820         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
821 
822         bytes memory appkey1_pubkey = new bytes(64);
823         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
824 
825         bytes memory tosign2 = new bytes(1+65+32);
826         tosign2[0] = 1; //role
827         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
828         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
829         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
830         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
831 
832         if (sigok == false) return false;
833 
834 
835         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
836         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
837 
838         bytes memory tosign3 = new bytes(1+65);
839         tosign3[0] = 0xFE;
840         copyBytes(proof, 3, 65, tosign3, 1);
841 
842         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
843         copyBytes(proof, 3+65, sig3.length, sig3, 0);
844 
845         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
846 
847         return sigok;
848     }
849 
850     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
851         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
852         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
853 
854         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
855         if (proofVerified == false) throw;
856 
857         _;
858     }
859 
860     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
861         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
862         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
863 
864         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
865         if (proofVerified == false) return 2;
866 
867         return 0;
868     }
869 
870     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
871         bool match_ = true;
872 	
873 	if (prefix.length != n_random_bytes) throw;
874 	        
875         for (uint256 i=0; i< n_random_bytes; i++) {
876             if (content[i] != prefix[i]) match_ = false;
877         }
878 
879         return match_;
880     }
881 
882     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
883 
884         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
885         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
886         bytes memory keyhash = new bytes(32);
887         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
888         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
889 
890         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
891         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
892 
893         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
894         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
895 
896         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
897         // This is to verify that the computed args match with the ones specified in the query.
898         bytes memory commitmentSlice1 = new bytes(8+1+32);
899         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
900 
901         bytes memory sessionPubkey = new bytes(64);
902         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
903         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
904 
905         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
906         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
907             delete oraclize_randomDS_args[queryId];
908         } else return false;
909 
910 
911         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
912         bytes memory tosign1 = new bytes(32+8+1+32);
913         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
914         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
915 
916         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
917         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
918             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
919         }
920 
921         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
922     }
923 
924 
925     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
926     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
927         uint minLength = length + toOffset;
928 
929         if (to.length < minLength) {
930             // Buffer too small
931             throw; // Should be a better way?
932         }
933 
934         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
935         uint i = 32 + fromOffset;
936         uint j = 32 + toOffset;
937 
938         while (i < (32 + fromOffset + length)) {
939             assembly {
940                 let tmp := mload(add(from, i))
941                 mstore(add(to, j), tmp)
942             }
943             i += 32;
944             j += 32;
945         }
946 
947         return to;
948     }
949 
950     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
951     // Duplicate Solidity's ecrecover, but catching the CALL return value
952     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
953 
954 
955         bool ret;
956         address addr;
957 
958         assembly {
959             let size := mload(0x40)
960             mstore(size, hash)
961             mstore(add(size, 32), v)
962             mstore(add(size, 64), r)
963             mstore(add(size, 96), s)
964 
965 
966             ret := call(3000, 1, 0, size, 128, size, 32)
967             addr := mload(size)
968         }
969 
970         return (ret, addr);
971     }
972 
973     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
974         bytes32 r;
975         bytes32 s;
976         uint8 v;
977 
978         if (sig.length != 65)
979           return (false, 0);
980 
981 
982         assembly {
983             r := mload(add(sig, 32))
984             s := mload(add(sig, 64))
985 
986 
987             v := byte(0, mload(add(sig, 96)))
988 
989 
990         }
991 
992 
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
1003 
1004 contract Dice5 is usingOraclize {
1005 
1006     uint constant pwin = 5000; //probability of winning (10000 = 100%)
1007     uint constant pwinRoll = 4; //win size comparison
1008     uint constant edge = 500; //edge percentage (10000 = 100%)
1009     uint constant reduceMulti = 1;//reduce multiples
1010     uint constant maxWin = 10000; //max win (before edge is taken) as percentage of bankroll (10000 = 100%)
1011     uint constant minBet = 100 finney;
1012     uint constant maxBet = 200 finney;
1013     uint constant maxInvestors = 10; //maximum number of investors
1014     uint constant houseEdge = 90; //edge percentage (10000 = 100%)
1015     uint constant divestFee = 50; //divest fee percentage (10000 = 100%)
1016     uint constant emergencyWithdrawalRatio = 10; //ratio percentage (100 = 100%)
1017 
1018     uint safeGas = 2300;
1019     uint constant ORACLIZE_GAS_LIMIT = 175000;
1020     uint constant INVALID_BET_MARKER = 99999;
1021     uint constant EMERGENCY_TIMEOUT = 3 days;
1022 
1023     struct Investor {
1024         address investorAddress;
1025         uint amountInvested;
1026         bool votedForEmergencyWithdrawal;
1027     }
1028 
1029     struct Bet {
1030         address playerAddress;
1031         uint amountBet;
1032         uint numberRolled;
1033     }
1034 
1035     struct WithdrawalProposal {
1036         address toAddress;
1037         uint atTime;
1038     }
1039 
1040     //Starting at 1
1041     mapping(address => uint) public investorIDs;
1042     mapping(uint => Investor) public investors;
1043     uint public numInvestors = 0;
1044 
1045     uint public invested = 0;
1046 
1047     address public owner;
1048     address public houseAddress;
1049     bool public isStopped;
1050 
1051     WithdrawalProposal public proposedWithdrawal;
1052 
1053     mapping (bytes32 => Bet) public bets;
1054     bytes32[] public betsKeys;
1055 
1056     uint public investorsProfit = 0;
1057     uint public investorsLosses = 0;
1058     bool profitDistributed;
1059 
1060     event LOG_NewBet(address playerAddress, uint amount);
1061     event LOG_BetWon(address playerAddress, uint numberRolled, uint amountWon);
1062     event LOG_BetLost(address playerAddress, uint numberRolled);
1063     event LOG_EmergencyWithdrawalProposed();
1064     event LOG_EmergencyWithdrawalFailed(address withdrawalAddress);
1065     event LOG_EmergencyWithdrawalSucceeded(address withdrawalAddress, uint amountWithdrawn);
1066     event LOG_FailedSend(address receiver, uint amount);
1067     event LOG_ZeroSend();
1068     event LOG_InvestorEntrance(address investor, uint amount);
1069     event LOG_InvestorCapitalUpdate(address investor, int amount);
1070     event LOG_InvestorExit(address investor, uint amount);
1071     event LOG_ContractStopped();
1072     event LOG_ContractResumed();
1073     event LOG_OwnerAddressChanged(address oldAddr, address newOwnerAddress);
1074     event LOG_HouseAddressChanged(address oldAddr, address newHouseAddress);
1075     event LOG_GasLimitChanged(uint oldGasLimit, uint newGasLimit);
1076     event LOG_EmergencyAutoStop();
1077     event LOG_EmergencyWithdrawalVote(address investor, bool vote);
1078     event LOG_ValueIsTooBig();
1079     event LOG_SuccessfulSend(address addr, uint amount);
1080 
1081     function Dice5() {
1082         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1083         owner = msg.sender;
1084         houseAddress = msg.sender;
1085     }
1086 
1087     //SECTION I: MODIFIERS AND HELPER FUNCTIONS
1088 
1089     //MODIFIERS
1090 
1091     modifier onlyIfNotStopped {
1092         if (isStopped) throw;
1093         _;
1094     }
1095 
1096     modifier onlyIfStopped {
1097         if (!isStopped) throw;
1098         _;
1099     }
1100 
1101     modifier onlyInvestors {
1102         if (investorIDs[msg.sender] == 0) throw;
1103         _;
1104     }
1105 
1106     modifier onlyNotInvestors {
1107         if (investorIDs[msg.sender] != 0) throw;
1108         _;
1109     }
1110 
1111     modifier onlyOwner {
1112         if (owner != msg.sender) throw;
1113         _;
1114     }
1115 
1116     modifier onlyOraclize {
1117         if (msg.sender != oraclize_cbAddress()) throw;
1118         _;
1119     }
1120 
1121     modifier onlyMoreThanMinInvestment {
1122         if (msg.value <= getMinInvestment()) throw;
1123         _;
1124     }
1125 
1126     modifier onlyMoreThanZero {
1127         if (msg.value == 0) throw;
1128         _;
1129     }
1130 
1131     modifier onlyIfBetExist(bytes32 myid) {
1132         if(bets[myid].playerAddress == address(0x0)) throw;
1133         _;
1134     }
1135 
1136     modifier onlyIfBetSizeIsStillCorrect(bytes32 myid) {
1137         if ((((bets[myid].amountBet * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000)  && (bets[myid].amountBet >= minBet) && (bets[myid].amountBet <= maxBet) ) {
1138              _;
1139         }
1140         else {
1141             bets[myid].numberRolled = INVALID_BET_MARKER;
1142             safeSend(bets[myid].playerAddress, bets[myid].amountBet);
1143             return;
1144         }
1145     }
1146 
1147     modifier onlyIfValidRoll(bytes32 myid, string result) {
1148         uint numberRolled = parseInt(result);
1149         if ((numberRolled < 1 || numberRolled > 6) && bets[myid].numberRolled == 0) {
1150             bets[myid].numberRolled = INVALID_BET_MARKER;
1151             safeSend(bets[myid].playerAddress, bets[myid].amountBet);
1152             return;
1153         }
1154         _;
1155     }
1156 
1157     modifier onlyWinningBets(uint numberRolled) {
1158         if (numberRolled < pwinRoll) {
1159             _;
1160         }
1161     }
1162 
1163     modifier onlyLosingBets(uint numberRolled) {
1164         if (numberRolled >= pwinRoll) {
1165             _;
1166         }
1167     }
1168 
1169     modifier onlyAfterProposed {
1170         if (proposedWithdrawal.toAddress == 0) throw;
1171         _;
1172     }
1173 
1174     modifier onlyIfProfitNotDistributed {
1175         if (!profitDistributed) {
1176             _;
1177         }
1178     }
1179 
1180     modifier onlyIfValidGas(uint newGasLimit) {
1181         if (ORACLIZE_GAS_LIMIT + newGasLimit < ORACLIZE_GAS_LIMIT) throw;
1182         if (newGasLimit < 25000) throw;
1183         _;
1184     }
1185 
1186     modifier onlyIfNotProcessed(bytes32 myid) {
1187         if (bets[myid].numberRolled > 0) throw;
1188         _;
1189     }
1190 
1191     modifier onlyIfEmergencyTimeOutHasPassed {
1192         if (proposedWithdrawal.atTime + EMERGENCY_TIMEOUT > now) throw;
1193         _;
1194     }
1195 
1196     modifier investorsInvariant {
1197         _;
1198         if (numInvestors > maxInvestors) throw;
1199     }
1200 
1201     //CONSTANT HELPER FUNCTIONS
1202 
1203     function getBankroll()
1204         constant
1205         returns(uint) {
1206 
1207         if ((invested < investorsProfit) ||
1208             (invested + investorsProfit < invested) ||
1209             (invested + investorsProfit < investorsLosses)) {
1210             return 0;
1211         }
1212         else {
1213             return invested + investorsProfit - investorsLosses;
1214         }
1215     }
1216 
1217     function getMinInvestment()
1218         constant
1219         returns(uint) {
1220 
1221         if (numInvestors == maxInvestors) {
1222             uint investorID = searchSmallestInvestor();
1223             return getBalance(investors[investorID].investorAddress);
1224         }
1225         else {
1226             return 0;
1227         }
1228     }
1229 
1230     function getStatus()
1231         constant
1232         returns(uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {
1233 
1234         uint bankroll = getBankroll();
1235         uint minInvestment = getMinInvestment();
1236         return (bankroll, pwin, pwinRoll, edge,reduceMulti, maxWin, minBet,maxBet, (investorsProfit - investorsLosses), minInvestment, betsKeys.length);
1237     }
1238 
1239     function getBet(uint id)
1240         constant
1241         returns(address, uint, uint) {
1242 
1243         if (id < betsKeys.length) {
1244             bytes32 betKey = betsKeys[id];
1245             return (bets[betKey].playerAddress, bets[betKey].amountBet, bets[betKey].numberRolled);
1246         }
1247     }
1248 
1249     function numBets()
1250         constant
1251         returns(uint) {
1252 
1253         return betsKeys.length;
1254     }
1255 
1256     function getMinBetAmount()
1257         constant
1258         returns(uint) {
1259 
1260         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
1261         return oraclizeFee + minBet;
1262     }
1263 
1264     function getMaxBetAmount()
1265         constant
1266         returns(uint) {
1267 
1268         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
1269         uint betValue =  (maxWin * getBankroll()) * pwin / (10000 * (10000 - edge - pwin));
1270         return betValue + oraclizeFee;
1271     }
1272 
1273     function getLossesShare(address currentInvestor)
1274         constant
1275         returns (uint) {
1276 
1277         return investors[investorIDs[currentInvestor]].amountInvested * (investorsLosses) / invested;
1278     }
1279 
1280     function getProfitShare(address currentInvestor)
1281         constant
1282         returns (uint) {
1283 
1284         return investors[investorIDs[currentInvestor]].amountInvested * (investorsProfit) / invested;
1285     }
1286 
1287     function getBalance(address currentInvestor)
1288         constant
1289         returns (uint) {
1290 
1291         uint invested = investors[investorIDs[currentInvestor]].amountInvested;
1292         uint profit = getProfitShare(currentInvestor);
1293         uint losses = getLossesShare(currentInvestor);
1294 
1295         if ((invested + profit < profit) ||
1296             (invested + profit < invested) ||
1297             (invested + profit < losses))
1298             return 0;
1299         else
1300             return invested + profit - losses;
1301     }
1302 
1303     function searchSmallestInvestor()
1304         constant
1305         returns(uint) {
1306 
1307         uint investorID = 1;
1308         for (uint i = 1; i <= numInvestors; i++) {
1309             if (getBalance(investors[i].investorAddress) < getBalance(investors[investorID].investorAddress)) {
1310                 investorID = i;
1311             }
1312         }
1313 
1314         return investorID;
1315     }
1316 
1317     function changeOraclizeProofType(byte _proofType)
1318         onlyOwner {
1319 
1320         if (_proofType == 0x00) throw;
1321         oraclize_setProof( _proofType |  proofStorage_IPFS );
1322     }
1323 
1324     function changeOraclizeConfig(bytes32 _config)
1325         onlyOwner {
1326 
1327         oraclize_setConfig(_config);
1328     }
1329 
1330     // PRIVATE HELPERS FUNCTION
1331 
1332     function safeSend(address addr, uint value)
1333         private {
1334 
1335         if (value == 0) {
1336             LOG_ZeroSend();
1337             return;
1338         }
1339 
1340         if (this.balance < value) {
1341             LOG_ValueIsTooBig();
1342             return;
1343         }
1344 
1345         if (!(addr.call.gas(safeGas).value(value)())) {
1346             LOG_FailedSend(addr, value);
1347             if (addr != houseAddress) {
1348                 //Forward to house address all change
1349                 if (!(houseAddress.call.gas(safeGas).value(value)())) LOG_FailedSend(houseAddress, value);
1350             }
1351         }
1352 
1353         LOG_SuccessfulSend(addr,value);
1354     }
1355 
1356     function addInvestorAtID(uint id)
1357         private {
1358 
1359         investorIDs[msg.sender] = id;
1360         investors[id].investorAddress = msg.sender;
1361         investors[id].amountInvested = msg.value;
1362         invested += msg.value;
1363 
1364         LOG_InvestorEntrance(msg.sender, msg.value);
1365     }
1366 
1367     function profitDistribution()
1368         private
1369         onlyIfProfitNotDistributed {
1370 
1371         uint copyInvested;
1372 
1373         for (uint i = 1; i <= numInvestors; i++) {
1374             address currentInvestor = investors[i].investorAddress;
1375             uint profitOfInvestor = getProfitShare(currentInvestor);
1376             uint lossesOfInvestor = getLossesShare(currentInvestor);
1377             //Check for overflow and underflow
1378             if ((investors[i].amountInvested + profitOfInvestor >= investors[i].amountInvested) &&
1379                 (investors[i].amountInvested + profitOfInvestor >= lossesOfInvestor))  {
1380                 investors[i].amountInvested += profitOfInvestor - lossesOfInvestor;
1381                 LOG_InvestorCapitalUpdate(currentInvestor, (int) (profitOfInvestor - lossesOfInvestor));
1382             }
1383             else {
1384                 isStopped = true;
1385                 LOG_EmergencyAutoStop();
1386             }
1387 
1388             if (copyInvested + investors[i].amountInvested >= copyInvested)
1389                 copyInvested += investors[i].amountInvested;
1390         }
1391 
1392         delete investorsProfit;
1393         delete investorsLosses;
1394         invested = copyInvested;
1395 
1396         profitDistributed = true;
1397     }
1398 
1399     // SECTION II: BET & BET PROCESSING
1400 
1401     function()
1402         payable {
1403 
1404         bet();
1405     }
1406 
1407     function bet()
1408         payable
1409         onlyIfNotStopped {
1410 
1411         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
1412         if (oraclizeFee >= msg.value) throw;
1413         uint betValue = msg.value - oraclizeFee;
1414         if ((((betValue * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000) && (betValue >= minBet) && (betValue <= maxBet)) {
1415             LOG_NewBet(msg.sender, betValue);
1416             bytes32 myid =
1417                 oraclize_query(
1418                     "nested",
1419                     "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random.data.0', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":\"${[decrypt] BGBswdF97MGb3jAJnEcbC4UXchrqNRkb9QQZj+DcSbDQlKmDVCdsNDW9d0KR1XTRqGcdBJkHhiHE9Nh/PKX60G+H7kKtwWd8K2AqS8YuDbRgllRze7THTt4j3CbjSHRh0h6zJgSNrMS4vcO7vQdgJ4NUv/v4}\",\"n\":1,\"min\":1,\"max\":6${[identity] \"}\"},\"id\":1${[identity] \"}\"}']",
1420                     ORACLIZE_GAS_LIMIT + safeGas
1421                 );
1422             bets[myid] = Bet(msg.sender, betValue, 0);
1423             betsKeys.push(myid);
1424         }
1425         else {
1426             throw;
1427         }
1428     }
1429 
1430     function __callback(bytes32 myid, string result, bytes proof)
1431         onlyOraclize
1432         onlyIfBetExist(myid)
1433         onlyIfNotProcessed(myid)
1434         onlyIfValidRoll(myid, result)
1435         onlyIfBetSizeIsStillCorrect(myid)  {
1436 
1437         uint numberRolled = parseInt(result);
1438         bets[myid].numberRolled = numberRolled;
1439         isWinningBet(bets[myid], numberRolled);
1440         isLosingBet(bets[myid], numberRolled);
1441         delete profitDistributed;
1442     }
1443 
1444     function isWinningBet(Bet thisBet, uint numberRolled)
1445         private
1446         onlyWinningBets(numberRolled) {
1447 
1448         uint winAmount = ((thisBet.amountBet * (10000 - edge)) / pwin) / reduceMulti;
1449         LOG_BetWon(thisBet.playerAddress, numberRolled, winAmount);
1450         safeSend(thisBet.playerAddress, winAmount);
1451 
1452         //Check for overflow and underflow
1453         if ((investorsLosses + winAmount < investorsLosses) ||
1454             (investorsLosses + winAmount < thisBet.amountBet)) {
1455                 throw;
1456             }
1457 
1458         investorsLosses += winAmount - thisBet.amountBet;
1459     }
1460 
1461     function isLosingBet(Bet thisBet, uint numberRolled)
1462         private
1463         onlyLosingBets(numberRolled) {
1464 
1465         LOG_BetLost(thisBet.playerAddress, numberRolled);
1466         safeSend(thisBet.playerAddress, 1);
1467 
1468         //Check for overflow and underflow
1469         if ((investorsProfit + thisBet.amountBet < investorsProfit) ||
1470             (investorsProfit + thisBet.amountBet < thisBet.amountBet) ||
1471             (thisBet.amountBet == 1)) {
1472                 throw;
1473             }
1474 
1475         uint totalProfit = investorsProfit + (thisBet.amountBet - 1); //added based on audit feedback
1476         investorsProfit += (thisBet.amountBet - 1)*(10000 - houseEdge)/10000;
1477         uint houseProfit = totalProfit - investorsProfit; //changed based on audit feedback
1478         safeSend(houseAddress, houseProfit);
1479     }
1480 
1481     //SECTION III: INVEST & DIVEST
1482 
1483     function increaseInvestment()
1484         payable
1485         onlyIfNotStopped
1486         onlyMoreThanZero
1487         onlyInvestors  {
1488 
1489         profitDistribution();
1490         investors[investorIDs[msg.sender]].amountInvested += msg.value;
1491         invested += msg.value;
1492     }
1493 
1494     function newInvestor()
1495         payable
1496         onlyIfNotStopped
1497         onlyMoreThanZero
1498         onlyNotInvestors
1499         onlyMoreThanMinInvestment
1500         investorsInvariant {
1501 
1502         profitDistribution();
1503 
1504         if (numInvestors == maxInvestors) {
1505             uint smallestInvestorID = searchSmallestInvestor();
1506             divest(investors[smallestInvestorID].investorAddress);
1507         }
1508 
1509         numInvestors++;
1510         addInvestorAtID(numInvestors);
1511     }
1512 
1513     function divest()
1514         onlyInvestors {
1515 
1516         divest(msg.sender);
1517     }
1518 
1519 
1520     function divest(address currentInvestor)
1521         private
1522         investorsInvariant {
1523 
1524         profitDistribution();
1525         uint currentID = investorIDs[currentInvestor];
1526         uint amountToReturn = getBalance(currentInvestor);
1527 
1528         if ((invested >= investors[currentID].amountInvested)) {
1529             invested -= investors[currentID].amountInvested;
1530             uint divestFeeAmount =  (amountToReturn*divestFee)/10000;
1531             amountToReturn -= divestFeeAmount;
1532 
1533             delete investors[currentID];
1534             delete investorIDs[currentInvestor];
1535 
1536             //Reorder investors
1537             if (currentID != numInvestors) {
1538                 // Get last investor
1539                 Investor lastInvestor = investors[numInvestors];
1540                 //Set last investor ID to investorID of divesting account
1541                 investorIDs[lastInvestor.investorAddress] = currentID;
1542                 //Copy investor at the new position in the mapping
1543                 investors[currentID] = lastInvestor;
1544                 //Delete old position in the mappping
1545                 delete investors[numInvestors];
1546             }
1547 
1548             numInvestors--;
1549             safeSend(currentInvestor, amountToReturn);
1550             safeSend(houseAddress, divestFeeAmount);
1551             LOG_InvestorExit(currentInvestor, amountToReturn);
1552         } else {
1553             isStopped = true;
1554             LOG_EmergencyAutoStop();
1555         }
1556     }
1557 
1558     function forceDivestOfAllInvestors()
1559         onlyOwner {
1560 
1561         uint copyNumInvestors = numInvestors;
1562         for (uint i = 1; i <= copyNumInvestors; i++) {
1563             divest(investors[1].investorAddress);
1564         }
1565     }
1566 
1567     /*
1568     The owner can use this function to force the exit of an investor from the
1569     contract during an emergency withdrawal in the following situations:
1570         - Unresponsive investor
1571         - Investor demanding to be paid in other to vote, the facto-blackmailing
1572         other investors
1573     */
1574     function forceDivestOfOneInvestor(address currentInvestor)
1575         onlyOwner
1576         onlyIfStopped {
1577 
1578         divest(currentInvestor);
1579         //Resets emergency withdrawal proposal. Investors must vote again
1580         delete proposedWithdrawal;
1581     }
1582 
1583     //SECTION IV: CONTRACT MANAGEMENT
1584 
1585     function stopContract()
1586         onlyOwner {
1587 
1588         isStopped = true;
1589         LOG_ContractStopped();
1590     }
1591 
1592     function resumeContract()
1593         onlyOwner {
1594 
1595         isStopped = false;
1596         LOG_ContractResumed();
1597     }
1598 
1599     function changeHouseAddress(address newHouse)
1600         onlyOwner {
1601 
1602         if (newHouse == address(0x0)) throw; //changed based on audit feedback
1603         houseAddress = newHouse;
1604         LOG_HouseAddressChanged(houseAddress, newHouse);
1605     }
1606 
1607     function changeOwnerAddress(address newOwner)
1608         onlyOwner {
1609 
1610         if (newOwner == address(0x0)) throw;
1611         owner = newOwner;
1612         LOG_OwnerAddressChanged(owner, newOwner);
1613     }
1614 
1615     function changeGasLimitOfSafeSend(uint newGasLimit)
1616         onlyOwner
1617         onlyIfValidGas(newGasLimit) {
1618 
1619         safeGas = newGasLimit;
1620         LOG_GasLimitChanged(safeGas, newGasLimit);
1621     }
1622 
1623     //SECTION V: EMERGENCY WITHDRAWAL
1624 
1625     function voteEmergencyWithdrawal(bool vote)
1626         onlyInvestors
1627         onlyAfterProposed
1628         onlyIfStopped {
1629 
1630         investors[investorIDs[msg.sender]].votedForEmergencyWithdrawal = vote;
1631         LOG_EmergencyWithdrawalVote(msg.sender, vote);
1632     }
1633 
1634     function proposeEmergencyWithdrawal(address withdrawalAddress)
1635         onlyIfStopped
1636         onlyOwner {
1637 
1638         //Resets previous votes
1639         for (uint i = 1; i <= numInvestors; i++) {
1640             delete investors[i].votedForEmergencyWithdrawal;
1641         }
1642 
1643         proposedWithdrawal = WithdrawalProposal(withdrawalAddress, now);
1644         LOG_EmergencyWithdrawalProposed();
1645     }
1646 
1647     function executeEmergencyWithdrawal()
1648         onlyOwner
1649         onlyAfterProposed
1650         onlyIfStopped
1651         onlyIfEmergencyTimeOutHasPassed {
1652 
1653         uint numOfVotesInFavour;
1654         uint amountToWithdraw = this.balance;
1655 
1656         for (uint i = 1; i <= numInvestors; i++) {
1657             if (investors[i].votedForEmergencyWithdrawal == true) {
1658                 numOfVotesInFavour++;
1659                 delete investors[i].votedForEmergencyWithdrawal;
1660             }
1661         }
1662 
1663         if (numOfVotesInFavour >= emergencyWithdrawalRatio * numInvestors / 100) {
1664             if (!proposedWithdrawal.toAddress.send(amountToWithdraw)) {
1665                 LOG_EmergencyWithdrawalFailed(proposedWithdrawal.toAddress);
1666             }
1667             else {
1668                 LOG_EmergencyWithdrawalSucceeded(proposedWithdrawal.toAddress, amountToWithdraw);
1669             }
1670         }
1671         else {
1672             throw;
1673         }
1674     }
1675 
1676 }