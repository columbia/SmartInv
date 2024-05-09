1 pragma solidity ^0.4.20;
2 
3 
4 contract OraclizeI {
5     address public cbAddress;
6     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
7     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
8     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
9     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
10     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
11     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
12     function getPrice(string _datasource) public returns (uint _dsprice);
13     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
14     function setProofType(byte _proofType) external;
15     function setCustomGasPrice(uint _gasPrice) external;
16     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
17 }
18 contract OraclizeAddrResolverI {
19     function getAddress() public returns (address _addr);
20 }
21 contract usingOraclize {
22     uint constant day = 60*60*24;
23     uint constant week = 60*60*24*7;
24     uint constant month = 60*60*24*30;
25     byte constant proofType_NONE = 0x00;
26     byte constant proofType_TLSNotary = 0x10;
27     byte constant proofType_Android = 0x20;
28     byte constant proofType_Ledger = 0x30;
29     byte constant proofType_Native = 0xF0;
30     byte constant proofStorage_IPFS = 0x01;
31     uint8 constant networkID_auto = 0;
32     uint8 constant networkID_mainnet = 1;
33     uint8 constant networkID_testnet = 2;
34     uint8 constant networkID_morden = 2;
35     uint8 constant networkID_consensys = 161;
36 
37     OraclizeAddrResolverI OAR;
38 
39     OraclizeI oraclize;
40     modifier oraclizeAPI {
41         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
42             oraclize_setNetwork(networkID_auto);
43 
44         if(address(oraclize) != OAR.getAddress())
45             oraclize = OraclizeI(OAR.getAddress());
46 
47         _;
48     }
49     modifier coupon(string code){
50         oraclize = OraclizeI(OAR.getAddress());
51         _;
52     }
53 
54     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
55       return oraclize_setNetwork();
56       networkID; // silence the warning and remain backwards compatible
57     }
58     function oraclize_setNetwork() internal returns(bool){
59         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
60             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
61             oraclize_setNetworkName("eth_mainnet");
62             return true;
63         }
64         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
65             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
66             oraclize_setNetworkName("eth_ropsten3");
67             return true;
68         }
69         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
70             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
71             oraclize_setNetworkName("eth_kovan");
72             return true;
73         }
74         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
75             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
76             oraclize_setNetworkName("eth_rinkeby");
77             return true;
78         }
79         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
80             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
81             return true;
82         }
83         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
84             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
85             return true;
86         }
87         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
88             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
89             return true;
90         }
91         return false;
92     }
93 
94     function __callback(bytes32 myid, string result) public {
95         __callback(myid, result, new bytes(0));
96     }
97     function __callback(bytes32 myid, string result, bytes proof) public {
98       return;
99       myid; result; proof; // Silence compiler warnings
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
492 
493     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
494         return oraclize.randomDS_getSessionPubKeyHash();
495     }
496 
497     function getCodeSize(address _addr) constant internal returns(uint _size) {
498         assembly {
499             _size := extcodesize(_addr)
500         }
501     }
502 
503     function parseAddr(string _a) internal pure returns (address){
504         bytes memory tmp = bytes(_a);
505         uint160 iaddr = 0;
506         uint160 b1;
507         uint160 b2;
508         for (uint i=2; i<2+2*20; i+=2){
509             iaddr *= 256;
510             b1 = uint160(tmp[i]);
511             b2 = uint160(tmp[i+1]);
512             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
513             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
514             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
515             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
516             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
517             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
518             iaddr += (b1*16+b2);
519         }
520         return address(iaddr);
521     }
522 
523     function strCompare(string _a, string _b) internal pure returns (int) {
524         bytes memory a = bytes(_a);
525         bytes memory b = bytes(_b);
526         uint minLength = a.length;
527         if (b.length < minLength) minLength = b.length;
528         for (uint i = 0; i < minLength; i ++)
529             if (a[i] < b[i])
530                 return -1;
531             else if (a[i] > b[i])
532                 return 1;
533         if (a.length < b.length)
534             return -1;
535         else if (a.length > b.length)
536             return 1;
537         else
538             return 0;
539     }
540 
541     function indexOf(string _haystack, string _needle) internal pure returns (int) {
542         bytes memory h = bytes(_haystack);
543         bytes memory n = bytes(_needle);
544         if(h.length < 1 || n.length < 1 || (n.length > h.length))
545             return -1;
546         else if(h.length > (2**128 -1))
547             return -1;
548         else
549         {
550             uint subindex = 0;
551             for (uint i = 0; i < h.length; i ++)
552             {
553                 if (h[i] == n[0])
554                 {
555                     subindex = 1;
556                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
557                     {
558                         subindex++;
559                     }
560                     if(subindex == n.length)
561                         return int(i);
562                 }
563             }
564             return -1;
565         }
566     }
567 
568     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
569         bytes memory _ba = bytes(_a);
570         bytes memory _bb = bytes(_b);
571         bytes memory _bc = bytes(_c);
572         bytes memory _bd = bytes(_d);
573         bytes memory _be = bytes(_e);
574         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
575         bytes memory babcde = bytes(abcde);
576         uint k = 0;
577         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
578         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
579         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
580         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
581         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
582         return string(babcde);
583     }
584 
585     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
586         return strConcat(_a, _b, _c, _d, "");
587     }
588 
589     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
590         return strConcat(_a, _b, _c, "", "");
591     }
592 
593     function strConcat(string _a, string _b) internal pure returns (string) {
594         return strConcat(_a, _b, "", "", "");
595     }
596 
597     // parseInt
598     function parseInt(string _a) internal pure returns (uint) {
599         return parseInt(_a, 0);
600     }
601 
602     // parseInt(parseFloat*10^_b)
603     function parseInt(string _a, uint _b) internal pure returns (uint) {
604         bytes memory bresult = bytes(_a);
605         uint mint = 0;
606         bool decimals = false;
607         for (uint i=0; i<bresult.length; i++){
608             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
609                 if (decimals){
610                    if (_b == 0) break;
611                     else _b--;
612                 }
613                 mint *= 10;
614                 mint += uint(bresult[i]) - 48;
615             } else if (bresult[i] == 46) decimals = true;
616         }
617         if (_b > 0) mint *= 10**_b;
618         return mint;
619     }
620 
621     function uint2str(uint i) internal pure returns (string){
622         if (i == 0) return "0";
623         uint j = i;
624         uint len;
625         while (j != 0){
626             len++;
627             j /= 10;
628         }
629         bytes memory bstr = new bytes(len);
630         uint k = len - 1;
631         while (i != 0){
632             bstr[k--] = byte(48 + i % 10);
633             i /= 10;
634         }
635         return string(bstr);
636     }
637 
638     function stra2cbor(string[] arr) internal pure returns (bytes) {
639             uint arrlen = arr.length;
640 
641             // get correct cbor output length
642             uint outputlen = 0;
643             bytes[] memory elemArray = new bytes[](arrlen);
644             for (uint i = 0; i < arrlen; i++) {
645                 elemArray[i] = (bytes(arr[i]));
646                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
647             }
648             uint ctr = 0;
649             uint cborlen = arrlen + 0x80;
650             outputlen += byte(cborlen).length;
651             bytes memory res = new bytes(outputlen);
652 
653             while (byte(cborlen).length > ctr) {
654                 res[ctr] = byte(cborlen)[ctr];
655                 ctr++;
656             }
657             for (i = 0; i < arrlen; i++) {
658                 res[ctr] = 0x5F;
659                 ctr++;
660                 for (uint x = 0; x < elemArray[i].length; x++) {
661                     // if there's a bug with larger strings, this may be the culprit
662                     if (x % 23 == 0) {
663                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
664                         elemcborlen += 0x40;
665                         uint lctr = ctr;
666                         while (byte(elemcborlen).length > ctr - lctr) {
667                             res[ctr] = byte(elemcborlen)[ctr - lctr];
668                             ctr++;
669                         }
670                     }
671                     res[ctr] = elemArray[i][x];
672                     ctr++;
673                 }
674                 res[ctr] = 0xFF;
675                 ctr++;
676             }
677             return res;
678         }
679 
680     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
681             uint arrlen = arr.length;
682 
683             // get correct cbor output length
684             uint outputlen = 0;
685             bytes[] memory elemArray = new bytes[](arrlen);
686             for (uint i = 0; i < arrlen; i++) {
687                 elemArray[i] = (bytes(arr[i]));
688                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
689             }
690             uint ctr = 0;
691             uint cborlen = arrlen + 0x80;
692             outputlen += byte(cborlen).length;
693             bytes memory res = new bytes(outputlen);
694 
695             while (byte(cborlen).length > ctr) {
696                 res[ctr] = byte(cborlen)[ctr];
697                 ctr++;
698             }
699             for (i = 0; i < arrlen; i++) {
700                 res[ctr] = 0x5F;
701                 ctr++;
702                 for (uint x = 0; x < elemArray[i].length; x++) {
703                     // if there's a bug with larger strings, this may be the culprit
704                     if (x % 23 == 0) {
705                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
706                         elemcborlen += 0x40;
707                         uint lctr = ctr;
708                         while (byte(elemcborlen).length > ctr - lctr) {
709                             res[ctr] = byte(elemcborlen)[ctr - lctr];
710                             ctr++;
711                         }
712                     }
713                     res[ctr] = elemArray[i][x];
714                     ctr++;
715                 }
716                 res[ctr] = 0xFF;
717                 ctr++;
718             }
719             return res;
720         }
721 
722 
723     string oraclize_network_name;
724     function oraclize_setNetworkName(string _network_name) internal {
725         oraclize_network_name = _network_name;
726     }
727 
728     function oraclize_getNetworkName() internal view returns (string) {
729         return oraclize_network_name;
730     }
731 
732     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
733         require((_nbytes > 0) && (_nbytes <= 32));
734         // Convert from seconds to ledger timer ticks
735         _delay *= 10;
736         bytes memory nbytes = new bytes(1);
737         nbytes[0] = byte(_nbytes);
738         bytes memory unonce = new bytes(32);
739         bytes memory sessionKeyHash = new bytes(32);
740         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
741         assembly {
742             mstore(unonce, 0x20)
743             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
744             mstore(sessionKeyHash, 0x20)
745             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
746         }
747         bytes memory delay = new bytes(32);
748         assembly {
749             mstore(add(delay, 0x20), _delay)
750         }
751 
752         bytes memory delay_bytes8 = new bytes(8);
753         copyBytes(delay, 24, 8, delay_bytes8, 0);
754 
755         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
756         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
757 
758         bytes memory delay_bytes8_left = new bytes(8);
759 
760         assembly {
761             let x := mload(add(delay_bytes8, 0x20))
762             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
763             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
764             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
765             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
766             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
767             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
768             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
769             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
770 
771         }
772 
773         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
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
805         if (address(keccak256(pubkey)) == signer) return true;
806         else {
807             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
808             return (address(keccak256(pubkey)) == signer);
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
823         tosign2[0] = byte(1); //role
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
849         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
850 
851         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
852         require(proofVerified);
853 
854         _;
855     }
856 
857     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
858         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
859         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
860 
861         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
862         if (proofVerified == false) return 2;
863 
864         return 0;
865     }
866 
867     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
868         bool match_ = true;
869 
870         require(prefix.length == n_random_bytes);
871 
872         for (uint256 i=0; i< n_random_bytes; i++) {
873             if (content[i] != prefix[i]) match_ = false;
874         }
875 
876         return match_;
877     }
878 
879     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
880 
881         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
882         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
883         bytes memory keyhash = new bytes(32);
884         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
885         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
886 
887         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
888         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
889 
890         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
891         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
892 
893         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
894         // This is to verify that the computed args match with the ones specified in the query.
895         bytes memory commitmentSlice1 = new bytes(8+1+32);
896         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
897 
898         bytes memory sessionPubkey = new bytes(64);
899         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
900         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
901 
902         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
903         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
904             delete oraclize_randomDS_args[queryId];
905         } else return false;
906 
907 
908         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
909         bytes memory tosign1 = new bytes(32+8+1+32);
910         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
911         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
912 
913         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
914         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
915             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
916         }
917 
918         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
919     }
920 
921     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
922     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
923         uint minLength = length + toOffset;
924 
925         // Buffer too small
926         require(to.length >= minLength); // Should be a better way?
927 
928         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
929         uint i = 32 + fromOffset;
930         uint j = 32 + toOffset;
931 
932         while (i < (32 + fromOffset + length)) {
933             assembly {
934                 let tmp := mload(add(from, i))
935                 mstore(add(to, j), tmp)
936             }
937             i += 32;
938             j += 32;
939         }
940 
941         return to;
942     }
943 
944     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
945     // Duplicate Solidity's ecrecover, but catching the CALL return value
946     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
947         // We do our own memory management here. Solidity uses memory offset
948         // 0x40 to store the current end of memory. We write past it (as
949         // writes are memory extensions), but don't update the offset so
950         // Solidity will reuse it. The memory used here is only needed for
951         // this context.
952 
953         // FIXME: inline assembly can't access return values
954         bool ret;
955         address addr;
956 
957         assembly {
958             let size := mload(0x40)
959             mstore(size, hash)
960             mstore(add(size, 32), v)
961             mstore(add(size, 64), r)
962             mstore(add(size, 96), s)
963 
964             // NOTE: we can reuse the request memory because we deal with
965             //       the return code
966             ret := call(3000, 1, 0, size, 128, size, 32)
967             addr := mload(size)
968         }
969 
970         return (ret, addr);
971     }
972 
973     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
974     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
975         bytes32 r;
976         bytes32 s;
977         uint8 v;
978 
979         if (sig.length != 65)
980           return (false, 0);
981 
982         // The signature format is a compact form of:
983         //   {bytes32 r}{bytes32 s}{uint8 v}
984         // Compact means, uint8 is not padded to 32 bytes.
985         assembly {
986             r := mload(add(sig, 32))
987             s := mload(add(sig, 64))
988 
989             // Here we are loading the last 32 bytes. We exploit the fact that
990             // 'mload' will pad with zeroes if we overread.
991             // There is no 'mload8' to do this, but that would be nicer.
992             v := byte(0, mload(add(sig, 96)))
993 
994             // Alternative solution:
995             // 'byte' is not working due to the Solidity parser, so lets
996             // use the second best option, 'and'
997             // v := and(mload(add(sig, 65)), 255)
998         }
999 
1000         // albeit non-transactional signatures are not specified by the YP, one would expect it
1001         // to match the YP range of [27, 28]
1002         //
1003         // geth uses [0, 1] and some clients have followed. This might change, see:
1004         //  https://github.com/ethereum/go-ethereum/issues/2053
1005         if (v < 27)
1006           v += 27;
1007 
1008         if (v != 27 && v != 28)
1009             return (false, 0);
1010 
1011         return safer_ecrecover(hash, v, r, s);
1012     }
1013 
1014 }
1015 
1016 contract BetContract is usingOraclize {
1017   uint  maxProfit;
1018   uint  maxmoneypercent;
1019   uint public contractBalance;
1020   uint  oraclizeFee;
1021   uint  oraclizeGasLimit;
1022   uint minBet;
1023   uint onoff;
1024   address private owner;
1025   uint private orderId;
1026 
1027   event LogNewOraclizeQuery(string description,bytes32 queryId);
1028   event LogNewRandomNumber(string result,bytes32 queryId);
1029   event LogSendBonus(uint id,bytes32 lableId,uint playId,uint content,uint singleMoney,uint mutilple,address user,uint betTime,uint status,uint winMoney);
1030 
1031   mapping (address => bytes32[]) playerLableList;
1032   mapping (bytes32 => mapping (uint => uint[7])) betList;
1033   mapping (bytes32 => uint) lableCount;
1034   mapping (bytes32 => uint) lableTime;
1035   mapping (bytes32 => uint) lableStatus;
1036   mapping (bytes32 => uint[3]) openNumberList;
1037   mapping (bytes32 => string) openNumberStr;
1038   mapping (bytes32 => address) lableUser;
1039 
1040   function BetContract() public {
1041     owner = msg.sender;
1042     orderId = 0;
1043 
1044     onoff=1;
1045     minBet=1500000000000000;
1046     oraclizeFee=1200000000000000;
1047     maxmoneypercent=80;
1048     oraclizeGasLimit=200000;
1049     contractBalance = this.balance;
1050     maxProfit=(this.balance * maxmoneypercent)/100;
1051     oraclize_setCustomGasPrice(3000000000);
1052   }
1053 
1054   /*
1055     * uintToString
1056     */
1057    function uintToString(uint i) internal  returns (string){
1058        if (i == 0) return "0";
1059        uint j = i;
1060        uint len;
1061        while (j != 0){
1062            len++;
1063            j /= 10;
1064        }
1065        bytes memory bstr = new bytes(len);
1066        uint k = len - 1;
1067        while (i != 0){
1068            bstr[k--] = byte(48 + i % 10);
1069            i /= 10;
1070        }
1071        return string(bstr);
1072    }
1073 
1074 
1075   modifier onlyAdmin() {
1076       require(msg.sender == owner);
1077       _;
1078   }
1079   modifier onlyOraclize {
1080       require (msg.sender == oraclize_cbAddress());
1081       _;
1082   }
1083 
1084   function setGameOnoff(uint _on0ff) public onlyAdmin{
1085     onoff=_on0ff;
1086   }
1087 
1088   function getPlayRate(uint playId,uint level) internal pure returns (uint){
1089       uint result = 0;
1090       if(playId == 1 || playId == 2){
1091         
1092         result = 19;
1093       }else if(playId == 3){
1094         
1095         result = 11;
1096       }else if(playId == 4){
1097         
1098         result = 156;
1099       }else if(playId == 5){
1100         
1101         result = 26;
1102       }else if(playId == 6){
1103         
1104         if(level == 4 || level == 17){
1105           result = 53;
1106         }else if(level == 5 || level == 16){
1107           result = 21;
1108         }else if(level == 6 || level == 15){
1109           result = 17;
1110         }else if(level == 7 || level == 14){
1111           result = 13;
1112         }else if(level == 8 || level == 13){
1113           result = 9;
1114         }else if(level == 9 || level == 12){
1115           result = 8;
1116         }else if(level == 10 || level == 11){
1117           result = 7;
1118         }
1119       }else if(playId == 7){
1120        
1121         result = 6;
1122       }else if(playId == 8){
1123         
1124         if(level == 1){
1125           result = 19;
1126         }else if(level == 2){
1127           result = 28;
1128         }else if(level == 3){
1129           result = 37;
1130         }
1131       }
1132       return result;
1133     }
1134 
1135     function doBet(uint[] playid,uint[] betMoney,uint[] betContent,uint mutiply) public payable returns (bytes32) {
1136       require(onoff==1);
1137       require(playid.length > 0);
1138       require(mutiply > 0);
1139       require(msg.value >= minBet);
1140 
1141       /* checkBet(playid,betMoney,betContent,mutiply,msg.value); */
1142 
1143       /* uint total = 0; */
1144       bytes32 queryId;
1145 
1146         uint oraGasLimit = oraclizeGasLimit;
1147         if(playid.length > 1 && playid.length <= 3){
1148             oraGasLimit = 300000;
1149         }else if(playid.length > 3 && playid.length <= 5){
1150             oraGasLimit = 400000;
1151         }else if(playid.length > 5 && playid.length <= 10){
1152             oraGasLimit = 600000;
1153         }else if(playid.length > 10 && playid.length <= 15){
1154             oraGasLimit = 700000;
1155         }else if(playid.length > 15 && playid.length <= 20){
1156             oraGasLimit = 800000;
1157         }else{
1158             oraGasLimit = 1000000;
1159         }
1160         LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..",queryId);
1161         queryId = oraclize_query("URL", "json(https://api.random.org/json-rpc/1/invoke).result.random.data", '\n{"jsonrpc":"2.0","method":"generateIntegers","params":{"apiKey":"8817de90-6e86-4d0d-87ec-3fd9b437f711","n":3,"min":1,"max":6,"replacement":true,"base":10},"id":1}',oraGasLimit);
1162       /* } */
1163 
1164        uint[7] tmp ;
1165       for(uint i=0;i<playid.length;i++){
1166         orderId++;
1167         tmp[0] =orderId;
1168         tmp[1] =playid[i];
1169         tmp[2] =betContent[i];
1170         tmp[3] =betMoney[i]*mutiply;
1171         tmp[4] =now;
1172         tmp[5] =0;
1173         tmp[6] =0;
1174         betList[queryId][i] =tmp;
1175       }
1176       lableTime[queryId] = now;
1177       lableCount[queryId] = playid.length;
1178       lableUser[queryId] = msg.sender;
1179       uint[3] memory codes = [uint(0),0,0];
1180       openNumberList[queryId] = codes;
1181       openNumberStr[queryId] ="0,0,0";
1182       lableStatus[queryId] = 0;
1183 
1184       uint index=playerLableList[msg.sender].length++;
1185       playerLableList[msg.sender][index]=queryId;//index:id
1186 
1187       return queryId;
1188     }
1189 
1190     function checkBet(uint[] playid,uint[] betMoney,uint[] betContent,uint mutiply,uint betTotal) internal{
1191         uint totalMoney = 0;
1192       uint totalWin1 = 0;
1193       uint totalWin2 = 0;
1194       uint totalWin3 = 0;
1195       uint rate;
1196       uint i;
1197       for(i=0;i<playid.length;i++){
1198         if(playid[i] >=1 && playid[i]<= 8){
1199           totalMoney += betMoney[i] * mutiply;
1200         }else{
1201           throw;
1202         }
1203         if(playid[i] ==1 || playid[i] ==2){
1204           rate = getPlayRate(playid[i],0)-10;
1205           totalWin1+=betMoney[i] * mutiply *rate/10;
1206           totalWin2+=betMoney[i] * mutiply *rate/10;
1207         }else if(playid[i] ==3){
1208           rate = getPlayRate(playid[i],0)-1;
1209           totalWin2+=betMoney[i] * mutiply *rate;
1210           totalWin3+=betMoney[i] * mutiply *rate;
1211         }else if(playid[i] ==4 || playid[i] ==5){
1212           rate = getPlayRate(playid[i],0)-1;
1213           totalWin3+=betMoney[i] * mutiply *rate;
1214         }else if(playid[i] ==6){
1215           rate = getPlayRate(playid[i],betContent[i])-1;
1216           totalWin1+=betMoney[i] * mutiply *rate;
1217           totalWin2+=betMoney[i] * mutiply *rate;
1218         }else if(playid[i] ==7){
1219           rate = getPlayRate(playid[i],0)-1;
1220           totalWin1+=betMoney[i] * mutiply *rate;
1221           totalWin2+=betMoney[i] * mutiply *rate;
1222         }else if(playid[i] ==8){
1223           totalWin1+=betMoney[i] * mutiply *9/10;
1224           totalWin2+=betMoney[i] * mutiply *18/10;
1225           totalWin3+=betMoney[i] * mutiply *27/10;
1226         }
1227       }
1228       uint maxWin=totalWin1;
1229       if(totalWin2 > maxWin){
1230         maxWin=totalWin2;
1231       }
1232       if(totalWin3 > maxWin){
1233         maxWin=totalWin3;
1234       }
1235       require(betTotal >= totalMoney);
1236 
1237       require(maxWin < maxProfit);
1238     }
1239 
1240     function __callback(bytes32 queryId, string result) public onlyOraclize {
1241         if (lableCount[queryId] < 1) revert();
1242       if (msg.sender != oraclize_cbAddress()) revert();
1243       LogNewRandomNumber(result,queryId);
1244 
1245         bytes memory tmp = bytes(result);
1246         uint[3] memory codes = [uint(0),0,0];
1247 
1248         uint k = 0;
1249         for (uint i=0; i<tmp.length; i++){
1250             if ((tmp[i] >= 48) && (tmp[i] <= 57)) {
1251                 if(k < codes.length){
1252                     codes[k] = (uint(tmp[i]) - 48);
1253                     k++;
1254                 }
1255             }
1256         }
1257         var code0=uintToString(codes[0]);
1258         var code1=uintToString(codes[1]);
1259         var code2=uintToString(codes[2]);
1260         openNumberList[queryId] = codes;
1261         openNumberStr[queryId] = strConcat(code0,",",code1,",",code2);
1262 
1263         
1264         doCheckBounds(queryId);
1265     }
1266 
1267     function doCancel(bytes32 queryId) internal {
1268       uint sta = lableStatus[queryId];
1269       require(sta == 0);
1270       uint[3] memory codes = openNumberList[queryId];
1271       require(codes[0] == 0 || codes[1] == 0 ||codes[2] == 0);
1272 
1273       uint totalBet = 0;
1274       uint len = lableCount[queryId];
1275 
1276       address to = lableUser[queryId];
1277       for(uint aa = 0 ; aa<len; aa++){
1278         
1279         if(betList[queryId][aa][5] == 0){
1280           totalBet+=betList[queryId][aa][3];
1281         }
1282       }
1283 
1284       if(totalBet > 0){
1285         to.transfer(totalBet);
1286       }
1287       contractBalance=this.balance;
1288       maxProfit=(this.balance * maxmoneypercent)/100;
1289       lableStatus[queryId] = 1;
1290     }
1291 
1292     function doSendBounds(bytes32 queryId) public payable {
1293       uint sta = lableStatus[queryId];
1294       require(sta == 2);
1295 
1296       uint totalWin = 0;
1297       uint len = lableCount[queryId];
1298 
1299       address to = lableUser[queryId];
1300       for(uint aa = 0 ; aa<len; aa++){
1301         
1302         if(betList[queryId][aa][5] == 2){
1303           totalWin+=betList[queryId][aa][6];
1304         }
1305       }
1306 
1307       if(totalWin > 0){
1308           to.transfer(totalWin);
1309       }
1310       lableStatus[queryId] = 3;
1311       contractBalance=this.balance;
1312       maxProfit=(this.balance * maxmoneypercent)/100;
1313     }
1314 
1315     
1316     function checkWinMoney(uint[7] storage betinfo,uint[3] codes) internal {
1317       uint rates;
1318       if(betinfo[1] ==1){
1319           
1320           if(codes[0] == codes[1] && codes[1] == codes[2]){
1321             betinfo[5]=1;
1322           }else{
1323             uint sum = codes[0]+codes[1]+codes[2];
1324             if(sum >= 4 && sum < 11){
1325               sum = 4;
1326             }else if(sum >= 11 && sum < 18){
1327               sum = 17;
1328             }else{
1329               sum = 0;
1330             }
1331             betinfo[5]=1;
1332             if(sum >0 && betinfo[2] == sum){
1333                 betinfo[5]=2;
1334                 rates = getPlayRate(betinfo[1],0);
1335                 betinfo[6]=betinfo[3]*rates/10;
1336             }
1337 
1338           }
1339       }else if(betinfo[1] == 2){
1340           
1341           if(codes[0] == codes[1] && codes[1] == codes[2]){
1342             betinfo[5]=1;
1343           }else{
1344             uint sums = codes[0]+codes[1]+codes[2];
1345             if(sums % 2 == 0){
1346               sums = 2;
1347             }else{
1348               sums = 3;
1349             }
1350             betinfo[5]=1;
1351             if(sums == betinfo[2]){
1352               betinfo[5]=2;
1353               rates = getPlayRate(betinfo[1],0);
1354               betinfo[6]=betinfo[3]*rates/10;
1355             }
1356 
1357           }
1358 
1359         }else if(betinfo[1] == 3){
1360           
1361           betinfo[5]=1;
1362           if(codes[0] == codes[1] || codes[1] == codes[2] ){
1363             uint tmp = 0;
1364             if(codes[0] == codes[1] ){
1365               tmp = codes[0];
1366             }else if(codes[1] == codes[2]){
1367               tmp = codes[1];
1368             }
1369             if(tmp == betinfo[2]){
1370               betinfo[5]=2;
1371               rates = getPlayRate(betinfo[1],0);
1372               betinfo[6]=betinfo[3]*rates;
1373             }
1374 
1375           }
1376         }else if(betinfo[1] == 4){
1377 
1378           betinfo[5]=1;
1379           if(codes[0] == codes[1] && codes[1] == codes[2] ){
1380             if(codes[0] == betinfo[2]){
1381               betinfo[5]=2;
1382               rates = getPlayRate(betinfo[1],0);
1383               betinfo[6]=betinfo[3]*rates;
1384             }
1385           }
1386         }else if(betinfo[1] == 5){
1387 
1388           betinfo[5]=1;
1389           if(codes[0] == codes[1] && codes[1] == codes[2] ){
1390               betinfo[5]=2;
1391               rates = getPlayRate(betinfo[1],0);
1392               betinfo[6]=betinfo[3]*rates;
1393           }
1394         }else if(betinfo[1] == 6){
1395 
1396           if(codes[0] == codes[1] && codes[1] == codes[2]){
1397             betinfo[5]=1;
1398           }else{
1399             betinfo[5]=1;
1400             uint sum6 = codes[0]+codes[1]+codes[2];
1401             if(sum6 == betinfo[2]){
1402               betinfo[5]=2;
1403               rates = getPlayRate(betinfo[1],sum6);
1404               betinfo[6]=betinfo[3]*rates;
1405             }
1406           }
1407         }else if(betinfo[1] == 7){
1408 
1409           if(codes[0] == codes[1] && codes[1] == codes[2]){
1410             betinfo[5]=1;
1411           }else{
1412             uint[2] memory haoma = getErbutongHao(betinfo[2]);
1413             bool atmp=false;
1414             bool btmp=false;
1415             for(uint ai=0;ai<codes.length;ai++){
1416               if(codes[ai] == haoma[0]){
1417                 atmp = true;
1418                 continue;
1419               }
1420               if(codes[ai] == haoma[1]){
1421                 btmp = true;
1422                 continue;
1423               }
1424             }
1425             betinfo[5]=1;
1426             if(atmp && btmp){
1427               betinfo[5]=2;
1428               rates = getPlayRate(betinfo[1],0);
1429               betinfo[6]=betinfo[3]*rates;
1430             }
1431           }
1432         }else if(betinfo[1] == 8){
1433 
1434           uint tmpp = 0;
1435           betinfo[5]=1;
1436           if(codes[0] == betinfo[2]){
1437             tmpp++;
1438           }
1439           if(codes[1] == betinfo[2]){
1440             tmpp++;
1441           }
1442           if(codes[2] == betinfo[2]){
1443             tmpp++;
1444           }
1445           if(tmpp > 0){
1446             betinfo[5]=2;
1447             rates = getPlayRate(betinfo[1],tmpp);
1448             betinfo[6]=betinfo[3]*rates/10;
1449           }
1450         }
1451 
1452     }
1453 
1454     function getErbutongHao(uint sss) internal view returns(uint[2]){
1455       uint[2] memory result ;
1456       if(sss == 12){
1457         result = [uint(1),2];
1458       }else if(sss == 13){
1459          result = [uint(1),3];
1460       }else if(sss == 14){
1461          result = [uint(1),4];
1462       }else if(sss == 15){
1463          result = [uint(1),5];
1464       }else if(sss == 16){
1465          result = [uint(1),6];
1466       }else if(sss == 23){
1467          result = [uint(2),3];
1468       }else if(sss == 24){
1469          result = [uint(2),4];
1470       }else if(sss == 25){
1471          result = [uint(2),5];
1472       }else if(sss == 26){
1473          result = [uint(2),6];
1474       }else if(sss == 34){
1475          result = [uint(3),4];
1476       }else if(sss == 35){
1477          result = [uint(3),5];
1478       }else if(sss == 36){
1479          result = [uint(3),6];
1480       }else if(sss == 45){
1481          result = [uint(4),5];
1482       }else if(sss == 46){
1483          result = [uint(4),6];
1484       }else if(sss == 56){
1485          result = [uint(5),6];
1486       }
1487       return (result);
1488     }
1489 
1490     function getLastBet() public view returns(string,uint[7][]){
1491       uint len=playerLableList[msg.sender].length;
1492       require(len>0);
1493 
1494       uint i=len-1;
1495       bytes32 lastLable = playerLableList[msg.sender][i];
1496       uint max = lableCount[lastLable];
1497       if(max > 50){
1498           max = 50;
1499       }
1500       uint[7][] memory result = new uint[7][](max) ;
1501       var opennum = "";
1502       for(uint a=0;a<max;a++){
1503          var ttmp =openNumberStr[lastLable];
1504          if(a==0){
1505            opennum =ttmp;
1506          }else{
1507            opennum = strConcat(opennum,";",ttmp);
1508          }
1509 
1510          result[a] = betList[lastLable][a];
1511          if(lableStatus[lastLable] == 1){
1512            result[a][5]=3;
1513          }
1514 
1515       }
1516 
1517       return (opennum,result);
1518     }
1519 
1520     function getLableRecords(bytes32 lable) public view returns(string,uint[7][]){
1521       uint max = lableCount[lable];
1522       if(max > 50){
1523           max = 50;
1524       }
1525       uint[7][] memory result = new uint[7][](max) ;
1526       var opennum="";
1527 
1528       for(uint a=0;a<max;a++){
1529          result[a] = betList[lable][a];
1530          if(lableStatus[lable] == 1){
1531            result[a][5]=3;
1532          }
1533          var ttmp =openNumberStr[lable];
1534          if(a==0){
1535            opennum =ttmp;
1536          }else{
1537            opennum = strConcat(opennum,";",ttmp);
1538          }
1539       }
1540 
1541       return (opennum,result);
1542     }
1543 
1544     function getAllRecords() public view returns(string,uint[7][]){
1545         uint len=playerLableList[msg.sender].length;
1546         require(len>0);
1547 
1548         uint max;
1549         bytes32 lastLable ;
1550         uint ss;
1551 
1552         for(uint i1=0;i1<len;i1++){
1553             ss = len-i1-1;
1554             lastLable = playerLableList[msg.sender][ss];
1555             max += lableCount[lastLable];
1556             if(100 < max){
1557               max = 100;
1558               break;
1559             }
1560         }
1561 
1562         uint[7][] memory result = new uint[7][](max) ;
1563         bytes32[] memory resultlable = new bytes32[](max) ;
1564         var opennum="";
1565 
1566         bool flag=false;
1567         uint betnums;
1568         uint j=0;
1569 
1570         for(uint ii=0;ii<len;ii++){
1571             ss = len-ii-1;
1572             lastLable = playerLableList[msg.sender][ss];
1573             betnums = lableCount[lastLable];
1574             for(uint k= 0; k<betnums; k++){
1575               if(j<max){
1576                   resultlable[j] = lastLable;
1577               	 var ttmp =openNumberStr[lastLable];
1578                  if(j==0){
1579                    opennum =ttmp;
1580                  }else{
1581                    opennum = strConcat(opennum,";",ttmp);
1582                  }
1583                   result[j] = betList[lastLable][k];
1584                   if(lableStatus[lastLable] == 1){
1585                     result[j][5]=3;
1586                   }else if(lableStatus[lastLable] == 2){
1587                     if(result[j][5]==2){
1588                       result[j][5]=4;
1589                     }
1590                   }else if(lableStatus[lastLable] == 3){
1591                     if(result[j][5]==2){
1592                       result[j][5]=5;
1593                     }
1594                   }
1595                   j++;
1596               }else{
1597                 flag = true;
1598                 break;
1599               }
1600             }
1601             if(flag){
1602                 break;
1603             }
1604         }
1605         return (opennum,result);
1606     }
1607 
1608   function setoraclegasprice(uint newGas) public onlyAdmin(){
1609     oraclize_setCustomGasPrice(newGas * 1 wei);
1610   }
1611   function setoraclelimitgas(uint _oraclizeGasLimit) public onlyAdmin(){
1612     oraclizeGasLimit=(_oraclizeGasLimit);
1613   }
1614 
1615   function senttest() public payable onlyAdmin{
1616       contractBalance=this.balance;
1617       maxProfit=(this.balance*maxmoneypercent)/100;
1618   }
1619 
1620   function withdraw(uint _amount , address desaccount) public onlyAdmin{
1621       desaccount.transfer(_amount);
1622       contractBalance=this.balance;
1623       maxProfit=(this.balance * maxmoneypercent)/100;
1624   }
1625 
1626   function getDatas() public view returns(
1627     uint _maxProfit,
1628     uint _minBet,
1629     uint _contractbalance,
1630     uint _onoff,
1631     address _owner,
1632     uint _oraclizeFee
1633     ){
1634         _maxProfit=maxProfit;
1635         _minBet=minBet;
1636         _contractbalance=contractBalance;
1637         _onoff=onoff;
1638         _owner=owner;
1639         _oraclizeFee=oraclizeFee;
1640     }
1641 
1642     function getLableList() public view returns(string,bytes32[],uint[],uint[],uint){
1643       uint len=playerLableList[msg.sender].length;
1644       require(len>0);
1645 
1646       uint max=50;
1647       if(len < 50){
1648           max = len;
1649       }
1650 
1651       bytes32[] memory lablelist = new bytes32[](max) ;
1652       uint[] memory labletime = new uint[](max) ;
1653       uint[] memory lablestatus = new uint[](max) ;
1654       var opennum="";
1655 
1656       bytes32 lastLable ;
1657       for(uint i=0;i<max;i++){
1658           lastLable = playerLableList[msg.sender][max-i-1];
1659           lablelist[i]=lastLable;
1660           labletime[i]=lableTime[lastLable];
1661           lablestatus[i]=lableStatus[lastLable];
1662           var ttmp =openNumberStr[lastLable];
1663          if(i==0){
1664            opennum =ttmp;
1665          }else{
1666            opennum = strConcat(opennum,";",ttmp);
1667          }
1668       }
1669 
1670       return (opennum,lablelist,labletime,lablestatus,now);
1671     }
1672 
1673     function doCheckBounds(bytes32 queryId) internal{
1674         uint sta = lableStatus[queryId];
1675         require(sta == 0 || sta == 2);
1676         uint[3] memory codes = openNumberList[queryId];
1677         require(codes[0] > 0);
1678 
1679         uint len = lableCount[queryId];
1680 
1681         uint totalWin;
1682         address to = lableUser[queryId];
1683         for(uint aa = 0 ; aa<len; aa++){
1684 
1685           if(sta == 0){
1686            if(betList[queryId][aa][5] == 0){
1687              checkWinMoney(betList[queryId][aa],codes);
1688              totalWin+=betList[queryId][aa][6];
1689            }
1690           }else if(sta == 2){
1691               totalWin+=betList[queryId][aa][6];
1692           }
1693         }
1694 
1695         lableStatus[queryId] = 2;
1696 
1697         if(totalWin > 0){
1698           if(totalWin < this.balance){
1699             to.transfer(totalWin);
1700             lableStatus[queryId] = 3;
1701           }else{
1702               LogNewOraclizeQuery("sent bouns fail.",queryId);
1703           }
1704         }else{
1705           lableStatus[queryId] = 3;
1706         }
1707         contractBalance=this.balance;
1708         maxProfit=(this.balance * maxmoneypercent)/100;
1709     }
1710 
1711     function getOpenNum(bytes32 queryId) public view returns(string){
1712         return openNumberStr[queryId];
1713     }
1714 
1715     function doCheckSendBounds() public payable{
1716         uint len=playerLableList[msg.sender].length;
1717 
1718       uint max=50;
1719       if(len < 50){
1720           max = len;
1721       }
1722 
1723       uint sta;
1724       bytes32 lastLable ;
1725       for(uint i=0;i<max;i++){
1726           lastLable = playerLableList[msg.sender][max-i-1];
1727           sta = lableStatus[lastLable];
1728           if(sta == 0 || sta==2){
1729             doCheckBounds(lastLable);
1730           }
1731       }
1732     }
1733 
1734     function doCancelAll() public payable{
1735         uint len=playerLableList[msg.sender].length;
1736 
1737       uint max=50;
1738       if(len < 50){
1739           max = len;
1740       }
1741 
1742       uint sta;
1743       uint bettime;
1744       bytes32 lastLable ;
1745       for(uint i=0;i<max;i++){
1746           lastLable = playerLableList[msg.sender][max-i-1];
1747           sta = lableStatus[lastLable];
1748           bettime = lableTime[lastLable];
1749           if(sta == 0 && (now - bettime)>600){
1750             doCancel(lastLable);
1751           }
1752       }
1753     }
1754 
1755 }