1 pragma solidity ^0.4.21;
2 
3 contract OraclizeI {
4     address public cbAddress;
5     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
6     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
7     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
8     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
9     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
10     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
11     function getPrice(string _datasource) public returns (uint _dsprice);
12     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
13     function setProofType(byte _proofType) external;
14     function setCustomGasPrice(uint _gasPrice) external;
15     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
16 }
17 contract OraclizeAddrResolverI {
18     function getAddress() public returns (address _addr);
19 }
20 contract usingOraclize {
21     uint constant day = 60*60*24;
22     uint constant week = 60*60*24*7;
23     uint constant month = 60*60*24*30;
24     byte constant proofType_NONE = 0x00;
25     byte constant proofType_TLSNotary = 0x10;
26     byte constant proofType_Android = 0x20;
27     byte constant proofType_Ledger = 0x30;
28     byte constant proofType_Native = 0xF0;
29     byte constant proofStorage_IPFS = 0x01;
30     uint8 constant networkID_auto = 0;
31     uint8 constant networkID_mainnet = 1;
32     uint8 constant networkID_testnet = 2;
33     uint8 constant networkID_morden = 2;
34     uint8 constant networkID_consensys = 161;
35 
36     OraclizeAddrResolverI OAR;
37 
38     OraclizeI oraclize;
39     modifier oraclizeAPI {
40         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
41             oraclize_setNetwork(networkID_auto);
42 
43         if(address(oraclize) != OAR.getAddress())
44             oraclize = OraclizeI(OAR.getAddress());
45 
46         _;
47     }
48     modifier coupon(string code){
49         oraclize = OraclizeI(OAR.getAddress());
50         _;
51     }
52 
53     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
54       return oraclize_setNetwork();
55       networkID; // silence the warning and remain backwards compatible
56     }
57     function oraclize_setNetwork() internal returns(bool){
58         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
59             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
60             oraclize_setNetworkName("eth_mainnet");
61             return true;
62         }
63         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
64             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
65             oraclize_setNetworkName("eth_ropsten3");
66             return true;
67         }
68         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
69             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
70             oraclize_setNetworkName("eth_kovan");
71             return true;
72         }
73         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
74             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
75             oraclize_setNetworkName("eth_rinkeby");
76             return true;
77         }
78         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
79             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
80             return true;
81         }
82         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
83             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
84             return true;
85         }
86         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
87             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
88             return true;
89         }
90         return false;
91     }
92 
93     function __callback(bytes32 myid, string result) public {
94         __callback(myid, result, new bytes(0));
95     }
96     function __callback(bytes32 myid, string result, bytes proof) public {
97       return;
98       myid; result; proof; // Silence compiler warnings
99     }
100 
101     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
102         return oraclize.getPrice(datasource);
103     }
104 
105     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
106         return oraclize.getPrice(datasource, gaslimit);
107     }
108 
109     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
110         uint price = oraclize.getPrice(datasource);
111         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
112         return oraclize.query.value(price)(0, datasource, arg);
113     }
114     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
115         uint price = oraclize.getPrice(datasource);
116         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
117         return oraclize.query.value(price)(timestamp, datasource, arg);
118     }
119     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
120         uint price = oraclize.getPrice(datasource, gaslimit);
121         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
122         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
123     }
124     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
125         uint price = oraclize.getPrice(datasource, gaslimit);
126         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
127         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
128     }
129     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
130         uint price = oraclize.getPrice(datasource);
131         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
132         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
133     }
134     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
135         uint price = oraclize.getPrice(datasource);
136         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
137         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
138     }
139     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
140         uint price = oraclize.getPrice(datasource, gaslimit);
141         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
142         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
143     }
144     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
145         uint price = oraclize.getPrice(datasource, gaslimit);
146         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
147         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
148     }
149     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
150         uint price = oraclize.getPrice(datasource);
151         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
152         bytes memory args = stra2cbor(argN);
153         return oraclize.queryN.value(price)(0, datasource, args);
154     }
155     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
156         uint price = oraclize.getPrice(datasource);
157         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
158         bytes memory args = stra2cbor(argN);
159         return oraclize.queryN.value(price)(timestamp, datasource, args);
160     }
161     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
162         uint price = oraclize.getPrice(datasource, gaslimit);
163         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
164         bytes memory args = stra2cbor(argN);
165         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
166     }
167     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
168         uint price = oraclize.getPrice(datasource, gaslimit);
169         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
170         bytes memory args = stra2cbor(argN);
171         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
172     }
173     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
174         string[] memory dynargs = new string[](1);
175         dynargs[0] = args[0];
176         return oraclize_query(datasource, dynargs);
177     }
178     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
179         string[] memory dynargs = new string[](1);
180         dynargs[0] = args[0];
181         return oraclize_query(timestamp, datasource, dynargs);
182     }
183     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
184         string[] memory dynargs = new string[](1);
185         dynargs[0] = args[0];
186         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
187     }
188     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
189         string[] memory dynargs = new string[](1);
190         dynargs[0] = args[0];
191         return oraclize_query(datasource, dynargs, gaslimit);
192     }
193 
194     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
195         string[] memory dynargs = new string[](2);
196         dynargs[0] = args[0];
197         dynargs[1] = args[1];
198         return oraclize_query(datasource, dynargs);
199     }
200     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
201         string[] memory dynargs = new string[](2);
202         dynargs[0] = args[0];
203         dynargs[1] = args[1];
204         return oraclize_query(timestamp, datasource, dynargs);
205     }
206     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
207         string[] memory dynargs = new string[](2);
208         dynargs[0] = args[0];
209         dynargs[1] = args[1];
210         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
211     }
212     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
213         string[] memory dynargs = new string[](2);
214         dynargs[0] = args[0];
215         dynargs[1] = args[1];
216         return oraclize_query(datasource, dynargs, gaslimit);
217     }
218     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
219         string[] memory dynargs = new string[](3);
220         dynargs[0] = args[0];
221         dynargs[1] = args[1];
222         dynargs[2] = args[2];
223         return oraclize_query(datasource, dynargs);
224     }
225     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
226         string[] memory dynargs = new string[](3);
227         dynargs[0] = args[0];
228         dynargs[1] = args[1];
229         dynargs[2] = args[2];
230         return oraclize_query(timestamp, datasource, dynargs);
231     }
232     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
233         string[] memory dynargs = new string[](3);
234         dynargs[0] = args[0];
235         dynargs[1] = args[1];
236         dynargs[2] = args[2];
237         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
238     }
239     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
240         string[] memory dynargs = new string[](3);
241         dynargs[0] = args[0];
242         dynargs[1] = args[1];
243         dynargs[2] = args[2];
244         return oraclize_query(datasource, dynargs, gaslimit);
245     }
246 
247     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
248         string[] memory dynargs = new string[](4);
249         dynargs[0] = args[0];
250         dynargs[1] = args[1];
251         dynargs[2] = args[2];
252         dynargs[3] = args[3];
253         return oraclize_query(datasource, dynargs);
254     }
255     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
256         string[] memory dynargs = new string[](4);
257         dynargs[0] = args[0];
258         dynargs[1] = args[1];
259         dynargs[2] = args[2];
260         dynargs[3] = args[3];
261         return oraclize_query(timestamp, datasource, dynargs);
262     }
263     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
264         string[] memory dynargs = new string[](4);
265         dynargs[0] = args[0];
266         dynargs[1] = args[1];
267         dynargs[2] = args[2];
268         dynargs[3] = args[3];
269         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
270     }
271     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
272         string[] memory dynargs = new string[](4);
273         dynargs[0] = args[0];
274         dynargs[1] = args[1];
275         dynargs[2] = args[2];
276         dynargs[3] = args[3];
277         return oraclize_query(datasource, dynargs, gaslimit);
278     }
279     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
280         string[] memory dynargs = new string[](5);
281         dynargs[0] = args[0];
282         dynargs[1] = args[1];
283         dynargs[2] = args[2];
284         dynargs[3] = args[3];
285         dynargs[4] = args[4];
286         return oraclize_query(datasource, dynargs);
287     }
288     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
289         string[] memory dynargs = new string[](5);
290         dynargs[0] = args[0];
291         dynargs[1] = args[1];
292         dynargs[2] = args[2];
293         dynargs[3] = args[3];
294         dynargs[4] = args[4];
295         return oraclize_query(timestamp, datasource, dynargs);
296     }
297     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
298         string[] memory dynargs = new string[](5);
299         dynargs[0] = args[0];
300         dynargs[1] = args[1];
301         dynargs[2] = args[2];
302         dynargs[3] = args[3];
303         dynargs[4] = args[4];
304         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
305     }
306     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
307         string[] memory dynargs = new string[](5);
308         dynargs[0] = args[0];
309         dynargs[1] = args[1];
310         dynargs[2] = args[2];
311         dynargs[3] = args[3];
312         dynargs[4] = args[4];
313         return oraclize_query(datasource, dynargs, gaslimit);
314     }
315     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
316         uint price = oraclize.getPrice(datasource);
317         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
318         bytes memory args = ba2cbor(argN);
319         return oraclize.queryN.value(price)(0, datasource, args);
320     }
321     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
322         uint price = oraclize.getPrice(datasource);
323         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
324         bytes memory args = ba2cbor(argN);
325         return oraclize.queryN.value(price)(timestamp, datasource, args);
326     }
327     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
328         uint price = oraclize.getPrice(datasource, gaslimit);
329         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
330         bytes memory args = ba2cbor(argN);
331         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
332     }
333     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
334         uint price = oraclize.getPrice(datasource, gaslimit);
335         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
336         bytes memory args = ba2cbor(argN);
337         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
338     }
339     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
340         bytes[] memory dynargs = new bytes[](1);
341         dynargs[0] = args[0];
342         return oraclize_query(datasource, dynargs);
343     }
344     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
345         bytes[] memory dynargs = new bytes[](1);
346         dynargs[0] = args[0];
347         return oraclize_query(timestamp, datasource, dynargs);
348     }
349     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
350         bytes[] memory dynargs = new bytes[](1);
351         dynargs[0] = args[0];
352         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
353     }
354     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
355         bytes[] memory dynargs = new bytes[](1);
356         dynargs[0] = args[0];
357         return oraclize_query(datasource, dynargs, gaslimit);
358     }
359 
360     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
361         bytes[] memory dynargs = new bytes[](2);
362         dynargs[0] = args[0];
363         dynargs[1] = args[1];
364         return oraclize_query(datasource, dynargs);
365     }
366     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
367         bytes[] memory dynargs = new bytes[](2);
368         dynargs[0] = args[0];
369         dynargs[1] = args[1];
370         return oraclize_query(timestamp, datasource, dynargs);
371     }
372     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
373         bytes[] memory dynargs = new bytes[](2);
374         dynargs[0] = args[0];
375         dynargs[1] = args[1];
376         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
377     }
378     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
379         bytes[] memory dynargs = new bytes[](2);
380         dynargs[0] = args[0];
381         dynargs[1] = args[1];
382         return oraclize_query(datasource, dynargs, gaslimit);
383     }
384     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
385         bytes[] memory dynargs = new bytes[](3);
386         dynargs[0] = args[0];
387         dynargs[1] = args[1];
388         dynargs[2] = args[2];
389         return oraclize_query(datasource, dynargs);
390     }
391     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
392         bytes[] memory dynargs = new bytes[](3);
393         dynargs[0] = args[0];
394         dynargs[1] = args[1];
395         dynargs[2] = args[2];
396         return oraclize_query(timestamp, datasource, dynargs);
397     }
398     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
399         bytes[] memory dynargs = new bytes[](3);
400         dynargs[0] = args[0];
401         dynargs[1] = args[1];
402         dynargs[2] = args[2];
403         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
404     }
405     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
406         bytes[] memory dynargs = new bytes[](3);
407         dynargs[0] = args[0];
408         dynargs[1] = args[1];
409         dynargs[2] = args[2];
410         return oraclize_query(datasource, dynargs, gaslimit);
411     }
412 
413     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
414         bytes[] memory dynargs = new bytes[](4);
415         dynargs[0] = args[0];
416         dynargs[1] = args[1];
417         dynargs[2] = args[2];
418         dynargs[3] = args[3];
419         return oraclize_query(datasource, dynargs);
420     }
421     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
422         bytes[] memory dynargs = new bytes[](4);
423         dynargs[0] = args[0];
424         dynargs[1] = args[1];
425         dynargs[2] = args[2];
426         dynargs[3] = args[3];
427         return oraclize_query(timestamp, datasource, dynargs);
428     }
429     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
430         bytes[] memory dynargs = new bytes[](4);
431         dynargs[0] = args[0];
432         dynargs[1] = args[1];
433         dynargs[2] = args[2];
434         dynargs[3] = args[3];
435         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
436     }
437     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
438         bytes[] memory dynargs = new bytes[](4);
439         dynargs[0] = args[0];
440         dynargs[1] = args[1];
441         dynargs[2] = args[2];
442         dynargs[3] = args[3];
443         return oraclize_query(datasource, dynargs, gaslimit);
444     }
445     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
446         bytes[] memory dynargs = new bytes[](5);
447         dynargs[0] = args[0];
448         dynargs[1] = args[1];
449         dynargs[2] = args[2];
450         dynargs[3] = args[3];
451         dynargs[4] = args[4];
452         return oraclize_query(datasource, dynargs);
453     }
454     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
455         bytes[] memory dynargs = new bytes[](5);
456         dynargs[0] = args[0];
457         dynargs[1] = args[1];
458         dynargs[2] = args[2];
459         dynargs[3] = args[3];
460         dynargs[4] = args[4];
461         return oraclize_query(timestamp, datasource, dynargs);
462     }
463     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
464         bytes[] memory dynargs = new bytes[](5);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         dynargs[2] = args[2];
468         dynargs[3] = args[3];
469         dynargs[4] = args[4];
470         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
471     }
472     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
473         bytes[] memory dynargs = new bytes[](5);
474         dynargs[0] = args[0];
475         dynargs[1] = args[1];
476         dynargs[2] = args[2];
477         dynargs[3] = args[3];
478         dynargs[4] = args[4];
479         return oraclize_query(datasource, dynargs, gaslimit);
480     }
481 
482     function oraclize_cbAddress() oraclizeAPI internal returns (address){
483         return oraclize.cbAddress();
484     }
485     function oraclize_setProof(byte proofP) oraclizeAPI internal {
486         return oraclize.setProofType(proofP);
487     }
488     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
489         return oraclize.setCustomGasPrice(gasPrice);
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
502     function parseAddr(string _a) internal pure returns (address){
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
522     function strCompare(string _a, string _b) internal pure returns (int) {
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
540     function indexOf(string _haystack, string _needle) internal pure returns (int) {
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
567     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
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
584     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
585         return strConcat(_a, _b, _c, _d, "");
586     }
587 
588     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
589         return strConcat(_a, _b, _c, "", "");
590     }
591 
592     function strConcat(string _a, string _b) internal pure returns (string) {
593         return strConcat(_a, _b, "", "", "");
594     }
595 
596     // parseInt
597     function parseInt(string _a) internal pure returns (uint) {
598         return parseInt(_a, 0);
599     }
600 
601     // parseInt(parseFloat*10^_b)
602     function parseInt(string _a, uint _b) internal pure returns (uint) {
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
620     function uint2str(uint i) internal pure returns (string){
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
637     function stra2cbor(string[] arr) internal pure returns (bytes) {
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
679     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
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
727     function oraclize_getNetworkName() internal view returns (string) {
728         return oraclize_network_name;
729     }
730 
731     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
732         require((_nbytes > 0) && (_nbytes <= 32));
733         // Convert from seconds to ledger timer ticks
734         _delay *= 10; 
735         bytes memory nbytes = new bytes(1);
736         nbytes[0] = byte(_nbytes);
737         bytes memory unonce = new bytes(32);
738         bytes memory sessionKeyHash = new bytes(32);
739         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
740         assembly {
741             mstore(unonce, 0x20)
742             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
743             mstore(sessionKeyHash, 0x20)
744             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
745         }
746         bytes memory delay = new bytes(32);
747         assembly { 
748             mstore(add(delay, 0x20), _delay) 
749         }
750         
751         bytes memory delay_bytes8 = new bytes(8);
752         copyBytes(delay, 24, 8, delay_bytes8, 0);
753 
754         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
755         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
756         
757         bytes memory delay_bytes8_left = new bytes(8);
758         
759         assembly {
760             let x := mload(add(delay_bytes8, 0x20))
761             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
762             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
763             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
764             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
765             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
766             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
767             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
768             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
769 
770         }
771         
772         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
773         return queryId;
774     }
775     
776     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
777         oraclize_randomDS_args[queryId] = commitment;
778     }
779 
780     mapping(bytes32=>bytes32) oraclize_randomDS_args;
781     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
782 
783     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
784         bool sigok;
785         address signer;
786 
787         bytes32 sigr;
788         bytes32 sigs;
789 
790         bytes memory sigr_ = new bytes(32);
791         uint offset = 4+(uint(dersig[3]) - 0x20);
792         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
793         bytes memory sigs_ = new bytes(32);
794         offset += 32 + 2;
795         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
796 
797         assembly {
798             sigr := mload(add(sigr_, 32))
799             sigs := mload(add(sigs_, 32))
800         }
801 
802 
803         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
804         if (address(keccak256(pubkey)) == signer) return true;
805         else {
806             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
807             return (address(keccak256(pubkey)) == signer);
808         }
809     }
810 
811     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
812         bool sigok;
813 
814         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
815         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
816         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
817 
818         bytes memory appkey1_pubkey = new bytes(64);
819         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
820 
821         bytes memory tosign2 = new bytes(1+65+32);
822         tosign2[0] = byte(1); //role
823         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
824         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
825         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
826         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
827 
828         if (sigok == false) return false;
829 
830 
831         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
832         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
833 
834         bytes memory tosign3 = new bytes(1+65);
835         tosign3[0] = 0xFE;
836         copyBytes(proof, 3, 65, tosign3, 1);
837 
838         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
839         copyBytes(proof, 3+65, sig3.length, sig3, 0);
840 
841         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
842 
843         return sigok;
844     }
845 
846     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
847         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
848         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
849 
850         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
851         require(proofVerified);
852 
853         _;
854     }
855 
856     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
857         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
858         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
859 
860         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
861         if (proofVerified == false) return 2;
862 
863         return 0;
864     }
865 
866     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
867         bool match_ = true;
868         
869         require(prefix.length == n_random_bytes);
870 
871         for (uint256 i=0; i< n_random_bytes; i++) {
872             if (content[i] != prefix[i]) match_ = false;
873         }
874 
875         return match_;
876     }
877 
878     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
879 
880         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
881         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
882         bytes memory keyhash = new bytes(32);
883         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
884         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
885 
886         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
887         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
888 
889         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
890         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
891 
892         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
893         // This is to verify that the computed args match with the ones specified in the query.
894         bytes memory commitmentSlice1 = new bytes(8+1+32);
895         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
896 
897         bytes memory sessionPubkey = new bytes(64);
898         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
899         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
900 
901         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
902         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
903             delete oraclize_randomDS_args[queryId];
904         } else return false;
905 
906 
907         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
908         bytes memory tosign1 = new bytes(32+8+1+32);
909         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
910         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
911 
912         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
913         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
914             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
915         }
916 
917         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
918     }
919 
920     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
921     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
922         uint minLength = length + toOffset;
923 
924         // Buffer too small
925         require(to.length >= minLength); // Should be a better way?
926 
927         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
928         uint i = 32 + fromOffset;
929         uint j = 32 + toOffset;
930 
931         while (i < (32 + fromOffset + length)) {
932             assembly {
933                 let tmp := mload(add(from, i))
934                 mstore(add(to, j), tmp)
935             }
936             i += 32;
937             j += 32;
938         }
939 
940         return to;
941     }
942 
943     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
944     // Duplicate Solidity's ecrecover, but catching the CALL return value
945     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
946         // We do our own memory management here. Solidity uses memory offset
947         // 0x40 to store the current end of memory. We write past it (as
948         // writes are memory extensions), but don't update the offset so
949         // Solidity will reuse it. The memory used here is only needed for
950         // this context.
951 
952         // FIXME: inline assembly can't access return values
953         bool ret;
954         address addr;
955 
956         assembly {
957             let size := mload(0x40)
958             mstore(size, hash)
959             mstore(add(size, 32), v)
960             mstore(add(size, 64), r)
961             mstore(add(size, 96), s)
962 
963             // NOTE: we can reuse the request memory because we deal with
964             //       the return code
965             ret := call(3000, 1, 0, size, 128, size, 32)
966             addr := mload(size)
967         }
968 
969         return (ret, addr);
970     }
971 
972     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
973     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
974         bytes32 r;
975         bytes32 s;
976         uint8 v;
977 
978         if (sig.length != 65)
979           return (false, 0);
980 
981         // The signature format is a compact form of:
982         //   {bytes32 r}{bytes32 s}{uint8 v}
983         // Compact means, uint8 is not padded to 32 bytes.
984         assembly {
985             r := mload(add(sig, 32))
986             s := mload(add(sig, 64))
987 
988             // Here we are loading the last 32 bytes. We exploit the fact that
989             // 'mload' will pad with zeroes if we overread.
990             // There is no 'mload8' to do this, but that would be nicer.
991             v := byte(0, mload(add(sig, 96)))
992 
993             // Alternative solution:
994             // 'byte' is not working due to the Solidity parser, so lets
995             // use the second best option, 'and'
996             // v := and(mload(add(sig, 65)), 255)
997         }
998 
999         // albeit non-transactional signatures are not specified by the YP, one would expect it
1000         // to match the YP range of [27, 28]
1001         //
1002         // geth uses [0, 1] and some clients have followed. This might change, see:
1003         //  https://github.com/ethereum/go-ethereum/issues/2053
1004         if (v < 27)
1005           v += 27;
1006 
1007         if (v != 27 && v != 28)
1008             return (false, 0);
1009 
1010         return safer_ecrecover(hash, v, r, s);
1011     }
1012 
1013 }
1014 // </ORACLIZE_API>
1015 
1016 contract EOSBetGameInterface {
1017 	uint256 public DEVELOPERSFUND;
1018 	uint256 public LIABILITIES;
1019 	function payDevelopersFund(address developer) public;
1020 	function receivePaymentForOraclize() payable public;
1021 	function getMaxWin() public view returns(uint256);
1022 }
1023 
1024 contract EOSBetBankrollInterface {
1025 	function payEtherToWinner(uint256 amtEther, address winner) public;
1026 	function receiveEtherFromGameAddress() payable public;
1027 	function payOraclize(uint256 amountToPay) public;
1028 	function getBankroll() public view returns(uint256);
1029 }
1030 
1031 contract ERC20 {
1032 	function totalSupply() constant public returns (uint supply);
1033 	function balanceOf(address _owner) constant public returns (uint balance);
1034 	function transfer(address _to, uint _value) public returns (bool success);
1035 	function transferFrom(address _from, address _to, uint _value) public returns (bool success);
1036 	function approve(address _spender, uint _value) public returns (bool success);
1037 	function allowance(address _owner, address _spender) constant public returns (uint remaining);
1038 	event Transfer(address indexed _from, address indexed _to, uint _value);
1039 	event Approval(address indexed _owner, address indexed _spender, uint _value);
1040 }
1041 
1042 contract EOSBetBankroll is ERC20, EOSBetBankrollInterface {
1043 
1044 	using SafeMath for *;
1045 
1046 	// constants for EOSBet Bankroll
1047 
1048 	address public OWNER;
1049 	uint256 public MAXIMUMINVESTMENTSALLOWED;
1050 	uint256 public WAITTIMEUNTILWITHDRAWORTRANSFER;
1051 	uint256 public DEVELOPERSFUND;
1052 
1053 	// this will be initialized as the trusted game addresses which will forward their ether
1054 	// to the bankroll contract, and when players win, they will request the bankroll contract 
1055 	// to send these players their winnings.
1056 	// Feel free to audit these contracts on etherscan...
1057 	mapping(address => bool) public TRUSTEDADDRESSES;
1058 
1059 	address public DICE;
1060 	address public SLOTS;
1061 
1062 	// mapping to log the last time a user contributed to the bankroll 
1063 	mapping(address => uint256) contributionTime;
1064 
1065 	// constants for ERC20 standard
1066 	string public constant name = "EOSBet Stake Tokens";
1067 	string public constant symbol = "EOSBETST";
1068 	uint8 public constant decimals = 18;
1069 	// variable total supply
1070 	uint256 public totalSupply;
1071 
1072 	// mapping to store tokens
1073 	mapping(address => uint256) public balances;
1074 	mapping(address => mapping(address => uint256)) public allowed;
1075 
1076 	// events
1077 	event FundBankroll(address contributor, uint256 etherContributed, uint256 tokensReceived);
1078 	event CashOut(address contributor, uint256 etherWithdrawn, uint256 tokensCashedIn);
1079 	event FailedSend(address sendTo, uint256 amt);
1080 
1081 	// checks that an address is a "trusted address of a legitimate EOSBet game"
1082 	modifier addressInTrustedAddresses(address thisAddress){
1083 
1084 		require(TRUSTEDADDRESSES[thisAddress]);
1085 		_;
1086 	}
1087 
1088 	// initialization function 
1089 	function EOSBetBankroll(address dice, address slots) public payable {
1090 		// function is payable, owner of contract MUST "seed" contract with some ether, 
1091 		// so that the ratios are correct when tokens are being minted
1092 		require (msg.value > 0);
1093 
1094 		OWNER = msg.sender;
1095 
1096 		// 100 tokens/ether is the inital seed amount, so:
1097 		uint256 initialTokens = msg.value * 100;
1098 		balances[msg.sender] = initialTokens;
1099 		totalSupply = initialTokens;
1100 
1101 		// log a mint tokens event
1102 		emit Transfer(0x0, msg.sender, initialTokens);
1103 
1104 		// insert given game addresses into the TRUSTEDADDRESSES mapping, and save the addresses as global variables
1105 		TRUSTEDADDRESSES[dice] = true;
1106 		TRUSTEDADDRESSES[slots] = true;
1107 
1108 		DICE = dice;
1109 		SLOTS = slots;
1110 
1111 		WAITTIMEUNTILWITHDRAWORTRANSFER = 6 hours;
1112 		MAXIMUMINVESTMENTSALLOWED = 500 ether;
1113 	}
1114 
1115 	///////////////////////////////////////////////
1116 	// VIEW FUNCTIONS
1117 	/////////////////////////////////////////////// 
1118 
1119 	function checkWhenContributorCanTransferOrWithdraw(address bankrollerAddress) view public returns(uint256){
1120 		return contributionTime[bankrollerAddress];
1121 	}
1122 
1123 	function getBankroll() view public returns(uint256){
1124 		// returns the total balance minus the developers fund, as the amount of active bankroll
1125 		return SafeMath.sub(address(this).balance, DEVELOPERSFUND);
1126 	}
1127 
1128 	///////////////////////////////////////////////
1129 	// BANKROLL CONTRACT <-> GAME CONTRACTS functions
1130 	/////////////////////////////////////////////// 
1131 
1132 	function payEtherToWinner(uint256 amtEther, address winner) public addressInTrustedAddresses(msg.sender){
1133 		// this function will get called by a game contract when someone wins a game
1134 		// try to send, if it fails, then send the amount to the owner
1135 		// note, this will only happen if someone is calling the betting functions with
1136 		// a contract. They are clearly up to no good, so they can contact us to retreive 
1137 		// their ether
1138 		// if the ether cannot be sent to us, the OWNER, that means we are up to no good, 
1139 		// and the ether will just be given to the bankrollers as if the player/owner lost 
1140 
1141 		if (! winner.send(amtEther)){
1142 
1143 			emit FailedSend(winner, amtEther);
1144 
1145 			if (! OWNER.send(amtEther)){
1146 
1147 				emit FailedSend(OWNER, amtEther);
1148 			}
1149 		}
1150 	}
1151 
1152 	function receiveEtherFromGameAddress() payable public addressInTrustedAddresses(msg.sender){
1153 		// this function will get called from the game contracts when someone starts a game.
1154 	}
1155 
1156 	function payOraclize(uint256 amountToPay) public addressInTrustedAddresses(msg.sender){
1157 		// this function will get called when a game contract must pay payOraclize
1158 		EOSBetGameInterface(msg.sender).receivePaymentForOraclize.value(amountToPay)();
1159 	}
1160 
1161 	///////////////////////////////////////////////
1162 	// BANKROLL CONTRACT MAIN FUNCTIONS
1163 	///////////////////////////////////////////////
1164 
1165 
1166 	// this function ADDS to the bankroll of EOSBet, and credits the bankroller a proportional
1167 	// amount of tokens so they may withdraw their tokens later
1168 	// also if there is only a limited amount of space left in the bankroll, a user can just send as much 
1169 	// ether as they want, because they will be able to contribute up to the maximum, and then get refunded the rest.
1170 	function () public payable {
1171 
1172 		// save in memory for cheap access.
1173 		// this represents the total bankroll balance before the function was called.
1174 		uint256 currentTotalBankroll = SafeMath.sub(getBankroll(), msg.value);
1175 		uint256 maxInvestmentsAllowed = MAXIMUMINVESTMENTSALLOWED;
1176 
1177 		require(currentTotalBankroll < maxInvestmentsAllowed && msg.value != 0);
1178 
1179 		uint256 currentSupplyOfTokens = totalSupply;
1180 		uint256 contributedEther;
1181 
1182 		bool contributionTakesBankrollOverLimit;
1183 		uint256 ifContributionTakesBankrollOverLimit_Refund;
1184 
1185 		uint256 creditedTokens;
1186 
1187 		if (SafeMath.add(currentTotalBankroll, msg.value) > maxInvestmentsAllowed){
1188 			// allow the bankroller to contribute up to the allowed amount of ether, and refund the rest.
1189 			contributionTakesBankrollOverLimit = true;
1190 			// set contributed ether as (MAXIMUMINVESTMENTSALLOWED - BANKROLL)
1191 			contributedEther = SafeMath.sub(maxInvestmentsAllowed, currentTotalBankroll);
1192 			// refund the rest of the ether, which is (original amount sent - (maximum amount allowed - bankroll))
1193 			ifContributionTakesBankrollOverLimit_Refund = SafeMath.sub(msg.value, contributedEther);
1194 		}
1195 		else {
1196 			contributedEther = msg.value;
1197 		}
1198         
1199 		if (currentSupplyOfTokens != 0){
1200 			// determine the ratio of contribution versus total BANKROLL.
1201 			creditedTokens = SafeMath.mul(contributedEther, currentSupplyOfTokens) / currentTotalBankroll;
1202 		}
1203 		else {
1204 			// edge case where ALL money was cashed out from bankroll
1205 			// so currentSupplyOfTokens == 0
1206 			// currentTotalBankroll can == 0 or not, if someone mines/selfdestruct's to the contract
1207 			// but either way, give all the bankroll to person who deposits ether
1208 			creditedTokens = SafeMath.mul(contributedEther, 100);
1209 		}
1210 		
1211 		// now update the total supply of tokens and bankroll amount
1212 		totalSupply = SafeMath.add(currentSupplyOfTokens, creditedTokens);
1213 
1214 		// now credit the user with his amount of contributed tokens 
1215 		balances[msg.sender] = SafeMath.add(balances[msg.sender], creditedTokens);
1216 
1217 		// update his contribution time for stake time locking
1218 		contributionTime[msg.sender] = block.timestamp;
1219 
1220 		// now look if the attempted contribution would have taken the BANKROLL over the limit, 
1221 		// and if true, refund the excess ether.
1222 		if (contributionTakesBankrollOverLimit){
1223 			msg.sender.transfer(ifContributionTakesBankrollOverLimit_Refund);
1224 		}
1225 
1226 		// log an event about funding bankroll
1227 		emit FundBankroll(msg.sender, contributedEther, creditedTokens);
1228 
1229 		// log a mint tokens event
1230 		emit Transfer(0x0, msg.sender, creditedTokens);
1231 	}
1232 
1233 	function cashoutEOSBetStakeTokens(uint256 _amountTokens) public {
1234 		// In effect, this function is the OPPOSITE of the un-named payable function above^^^
1235 		// this allows bankrollers to "cash out" at any time, and receive the ether that they contributed, PLUS
1236 		// a proportion of any ether that was earned by the smart contact when their ether was "staking", However
1237 		// this works in reverse as well. Any net losses of the smart contract will be absorbed by the player in like manner.
1238 		// Of course, due to the constant house edge, a bankroller that leaves their ether in the contract long enough
1239 		// is effectively guaranteed to withdraw more ether than they originally "staked"
1240 
1241 		// save in memory for cheap access.
1242 		uint256 tokenBalance = balances[msg.sender];
1243 		// verify that the contributor has enough tokens to cash out this many, and has waited the required time.
1244 		require(_amountTokens <= tokenBalance 
1245 			&& contributionTime[msg.sender] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp
1246 			&& _amountTokens > 0);
1247 
1248 		// save in memory for cheap access.
1249 		// again, represents the total balance of the contract before the function was called.
1250 		uint256 currentTotalBankroll = getBankroll();
1251 		uint256 currentSupplyOfTokens = totalSupply;
1252 
1253 		// calculate the token withdraw ratio based on current supply 
1254 		uint256 withdrawEther = SafeMath.mul(_amountTokens, currentTotalBankroll) / currentSupplyOfTokens;
1255 
1256 		// developers take 1% of withdrawls 
1257 		uint256 developersCut = withdrawEther / 100;
1258 		uint256 contributorAmount = SafeMath.sub(withdrawEther, developersCut);
1259 
1260 		// now update the total supply of tokens by subtracting the tokens that are being "cashed in"
1261 		totalSupply = SafeMath.sub(currentSupplyOfTokens, _amountTokens);
1262 
1263 		// and update the users supply of tokens 
1264 		balances[msg.sender] = SafeMath.sub(tokenBalance, _amountTokens);
1265 
1266 		// update the developers fund based on this calculated amount 
1267 		DEVELOPERSFUND = SafeMath.add(DEVELOPERSFUND, developersCut);
1268 
1269 		// lastly, transfer the ether back to the bankroller. Thanks for your contribution!
1270 		msg.sender.transfer(contributorAmount);
1271 
1272 		// log an event about cashout
1273 		emit CashOut(msg.sender, contributorAmount, _amountTokens);
1274 
1275 		// log a destroy tokens event
1276 		emit Transfer(msg.sender, 0x0, _amountTokens);
1277 	}
1278 
1279 	// TO CALL THIS FUNCTION EASILY, SEND A 0 ETHER TRANSACTION TO THIS CONTRACT WITH EXTRA DATA: 0x7a09588b
1280 	function cashoutEOSBetStakeTokens_ALL() public {
1281 
1282 		// just forward to cashoutEOSBetStakeTokens with input as the senders entire balance
1283 		cashoutEOSBetStakeTokens(balances[msg.sender]);
1284 	}
1285 
1286 	////////////////////
1287 	// OWNER FUNCTIONS:
1288 	////////////////////
1289 	// Please, be aware that the owner ONLY can change:
1290 		// 1. The owner can increase or decrease the target amount for a game. They can then call the updater function to give/receive the ether from the game.
1291 		// 1. The wait time until a user can withdraw or transfer their tokens after purchase through the default function above ^^^
1292 		// 2. The owner can change the maximum amount of investments allowed. This allows for early contributors to guarantee
1293 		// 		a certain percentage of the bankroll so that their stake cannot be diluted immediately. However, be aware that the 
1294 		//		maximum amount of investments allowed will be raised over time. This will allow for higher bets by gamblers, resulting
1295 		// 		in higher dividends for the bankrollers
1296 		// 3. The owner can freeze payouts to bettors. This will be used in case of an emergency, and the contract will reject all
1297 		//		new bets as well. This does not mean that bettors will lose their money without recompense. They will be allowed to call the 
1298 		// 		"refund" function in the respective game smart contract once payouts are un-frozen.
1299 		// 4. Finally, the owner can modify and withdraw the developers reward, which will fund future development, including new games, a sexier frontend,
1300 		// 		and TRUE DAO governance so that onlyOwner functions don't have to exist anymore ;) and in order to effectively react to changes 
1301 		// 		in the market (lower the percentage because of increased competition in the blockchain casino space, etc.)
1302 
1303 	function transferOwnership(address newOwner) public {
1304 		require(msg.sender == OWNER);
1305 
1306 		OWNER = newOwner;
1307 	}
1308 
1309 	function changeWaitTimeUntilWithdrawOrTransfer(uint256 waitTime) public {
1310 		// waitTime MUST be less than or equal to 10 weeks
1311 		require (msg.sender == OWNER && waitTime <= 6048000);
1312 
1313 		WAITTIMEUNTILWITHDRAWORTRANSFER = waitTime;
1314 	}
1315 
1316 	function changeMaximumInvestmentsAllowed(uint256 maxAmount) public {
1317 		require(msg.sender == OWNER);
1318 
1319 		MAXIMUMINVESTMENTSALLOWED = maxAmount;
1320 	}
1321 
1322 
1323 	function withdrawDevelopersFund(address receiver) public {
1324 		require(msg.sender == OWNER);
1325 
1326 		// first get developers fund from each game 
1327         EOSBetGameInterface(DICE).payDevelopersFund(receiver);
1328 		EOSBetGameInterface(SLOTS).payDevelopersFund(receiver);
1329 
1330 		// now send the developers fund from the main contract.
1331 		uint256 developersFund = DEVELOPERSFUND;
1332 
1333 		// set developers fund to zero
1334 		DEVELOPERSFUND = 0;
1335 
1336 		// transfer this amount to the owner!
1337 		receiver.transfer(developersFund);
1338 	}
1339 
1340 	// rescue tokens inadvertently sent to the contract address 
1341 	function ERC20Rescue(address tokenAddress, uint256 amtTokens) public {
1342 		require (msg.sender == OWNER);
1343 
1344 		ERC20(tokenAddress).transfer(msg.sender, amtTokens);
1345 	}
1346 
1347 	///////////////////////////////
1348 	// BASIC ERC20 TOKEN OPERATIONS
1349 	///////////////////////////////
1350 
1351 	function totalSupply() constant public returns(uint){
1352 		return totalSupply;
1353 	}
1354 
1355 	function balanceOf(address _owner) constant public returns(uint){
1356 		return balances[_owner];
1357 	}
1358 
1359 	// don't allow transfers before the required wait-time
1360 	// and don't allow transfers to this contract addr, it'll just kill tokens
1361 	function transfer(address _to, uint256 _value) public returns (bool success){
1362 		require(balances[msg.sender] >= _value 
1363 			&& contributionTime[msg.sender] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp
1364 			&& _to != address(this)
1365 			&& _to != address(0));
1366 
1367 		// safely subtract
1368 		balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
1369 		balances[_to] = SafeMath.add(balances[_to], _value);
1370 
1371 		// log event 
1372 		emit Transfer(msg.sender, _to, _value);
1373 		return true;
1374 	}
1375 
1376 	// don't allow transfers before the required wait-time
1377 	// and don't allow transfers to the contract addr, it'll just kill tokens
1378 	function transferFrom(address _from, address _to, uint _value) public returns(bool){
1379 		require(allowed[_from][msg.sender] >= _value 
1380 			&& balances[_from] >= _value 
1381 			&& contributionTime[_from] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp
1382 			&& _to != address(this)
1383 			&& _to != address(0));
1384 
1385 		// safely add to _to and subtract from _from, and subtract from allowed balances.
1386 		balances[_to] = SafeMath.add(balances[_to], _value);
1387    		balances[_from] = SafeMath.sub(balances[_from], _value);
1388   		allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
1389 
1390   		// log event
1391 		emit Transfer(_from, _to, _value);
1392 		return true;
1393    		
1394 	}
1395 	
1396 	function approve(address _spender, uint _value) public returns(bool){
1397 
1398 		allowed[msg.sender][_spender] = _value;
1399 		emit Approval(msg.sender, _spender, _value);
1400 		// log event
1401 		return true;
1402 	}
1403 	
1404 	function allowance(address _owner, address _spender) constant public returns(uint){
1405 		return allowed[_owner][_spender];
1406 	}
1407 }
1408 
1409 pragma solidity ^0.4.18;
1410 
1411 
1412 /**
1413  * @title SafeMath
1414  * @dev Math operations with safety checks that throw on error
1415  */
1416 library SafeMath {
1417 
1418   /**
1419   * @dev Multiplies two numbers, throws on overflow.
1420   */
1421   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1422     if (a == 0) {
1423       return 0;
1424     }
1425     uint256 c = a * b;
1426     assert(c / a == b);
1427     return c;
1428   }
1429 
1430   /**
1431   * @dev Integer division of two numbers, truncating the quotient.
1432   */
1433   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1434     // assert(b > 0); // Solidity automatically throws when dividing by 0
1435     uint256 c = a / b;
1436     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1437     return c;
1438   }
1439 
1440   /**
1441   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1442   */
1443   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1444     assert(b <= a);
1445     return a - b;
1446   }
1447 
1448   /**
1449   * @dev Adds two numbers, throws on overflow.
1450   */
1451   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1452     uint256 c = a + b;
1453     assert(c >= a);
1454     return c;
1455   }
1456 }
1457 
1458 contract EOSBetSlots is usingOraclize, EOSBetGameInterface {
1459 
1460 	using SafeMath for *;
1461 
1462 	// events
1463 	event BuyCredits(bytes32 indexed oraclizeQueryId);
1464 	event LedgerProofFailed(bytes32 indexed oraclizeQueryId);
1465 	event Refund(bytes32 indexed oraclizeQueryId, uint256 amount);
1466 	event SlotsLargeBet(bytes32 indexed oraclizeQueryId, uint256 data1, uint256 data2, uint256 data3, uint256 data4, uint256 data5, uint256 data6, uint256 data7, uint256 data8);
1467 	event SlotsSmallBet(uint256 data1, uint256 data2, uint256 data3, uint256 data4, uint256 data5, uint256 data6, uint256 data7, uint256 data8);
1468 
1469 	// slots game structure
1470 	struct SlotsGameData {
1471 		address player;
1472 		bool paidOut;
1473 		uint256 start;
1474 		uint256 etherReceived;
1475 		uint8 credits;
1476 	}
1477 
1478 	mapping (bytes32 => SlotsGameData) public slotsData;
1479 
1480 	// ether in this contract can be in one of two locations:
1481 	uint256 public LIABILITIES;
1482 	uint256 public DEVELOPERSFUND;
1483 
1484 	// counters for frontend statistics
1485 	uint256 public AMOUNTWAGERED;
1486 	uint256 public DIALSSPUN;
1487 	
1488 	// togglable values
1489 	uint256 public ORACLIZEQUERYMAXTIME;
1490 	uint256 public MINBET_perSPIN;
1491 	uint256 public MINBET_perTX;
1492 	uint256 public ORACLIZEGASPRICE;
1493 	uint256 public INITIALGASFORORACLIZE;
1494 	uint16 public MAXWIN_inTHOUSANDTHPERCENTS;
1495 
1496 	// togglable functionality of contract
1497 	bool public GAMEPAUSED;
1498 	bool public REFUNDSACTIVE;
1499 
1500 	// owner of contract
1501 	address public OWNER;
1502 
1503 	// bankroller address
1504 	address public BANKROLLER;
1505 
1506 	// constructor
1507 	function EOSBetSlots() public {
1508 		// ledger proof is ALWAYS verified on-chain
1509 		oraclize_setProof(proofType_Ledger);
1510 
1511 		// gas prices for oraclize call back, can be changed
1512 		oraclize_setCustomGasPrice(8000000000);
1513 		ORACLIZEGASPRICE = 8000000000;
1514 		INITIALGASFORORACLIZE = 225000;
1515 
1516 		AMOUNTWAGERED = 0;
1517 		DIALSSPUN = 0;
1518 
1519 		GAMEPAUSED = false;
1520 		REFUNDSACTIVE = true;
1521 
1522 		ORACLIZEQUERYMAXTIME = 6 hours;
1523 		MINBET_perSPIN = 2 finney; // currently, this is ~40-50c a spin, which is pretty average slots. This is changeable by OWNER 
1524 		MINBET_perTX = 10 finney;
1525         MAXWIN_inTHOUSANDTHPERCENTS = 333; // 333/1000 so a jackpot can take 33% of bankroll (extremely rare)
1526         OWNER = msg.sender;
1527 	}
1528 
1529 	////////////////////////////////////
1530 	// INTERFACE CONTACT FUNCTIONS
1531 	////////////////////////////////////
1532 
1533 	function payDevelopersFund(address developer) public {
1534 		require(msg.sender == BANKROLLER);
1535 
1536 		uint256 devFund = DEVELOPERSFUND;
1537 
1538 		DEVELOPERSFUND = 0;
1539 
1540 		developer.transfer(devFund);
1541 	}
1542 
1543 	// just a function to receive eth, only allow the bankroll to use this
1544 	function receivePaymentForOraclize() payable public {
1545 		require(msg.sender == BANKROLLER);
1546 	}
1547 
1548 	////////////////////////////////////
1549 	// VIEW FUNCTIONS
1550 	////////////////////////////////////
1551 
1552 	function getMaxWin() public view returns(uint256){
1553 		return (SafeMath.mul(EOSBetBankrollInterface(BANKROLLER).getBankroll(), MAXWIN_inTHOUSANDTHPERCENTS) / 1000);
1554 	}
1555 
1556 	////////////////////////////////////
1557 	// OWNER ONLY FUNCTIONS
1558 	////////////////////////////////////
1559 
1560 	// WARNING!!!!! Can only set this function once!
1561 	function setBankrollerContractOnce(address bankrollAddress) public {
1562 		// require that BANKROLLER address == 0x0 (address not set yet), and coming from owner.
1563 		require(msg.sender == OWNER && BANKROLLER == address(0));
1564 
1565 		// check here to make sure that the bankroll contract is legitimate
1566 		// just make sure that calling the bankroll contract getBankroll() returns non-zero
1567 
1568 		require(EOSBetBankrollInterface(bankrollAddress).getBankroll() != 0);
1569 
1570 		BANKROLLER = bankrollAddress;
1571 	}
1572 
1573 	function transferOwnership(address newOwner) public {
1574 		require(msg.sender == OWNER);
1575 
1576 		OWNER = newOwner;
1577 	}
1578 
1579 	function setOraclizeQueryMaxTime(uint256 newTime) public {
1580 		require(msg.sender == OWNER);
1581 
1582 		ORACLIZEQUERYMAXTIME = newTime;
1583 	}
1584 
1585 	// store the gas price as a storage variable for easy reference,
1586 	// and thne change the gas price using the proper oraclize function
1587 	function setOraclizeQueryGasPrice(uint256 gasPrice) public {
1588 		require(msg.sender == OWNER);
1589 
1590 		ORACLIZEGASPRICE = gasPrice;
1591 		oraclize_setCustomGasPrice(gasPrice);
1592 	}
1593 
1594 	// should be ~160,000 to save eth
1595 	function setInitialGasForOraclize(uint256 gasAmt) public {
1596 		require(msg.sender == OWNER);
1597 
1598 		INITIALGASFORORACLIZE = gasAmt;
1599 	}
1600 
1601 	function setGamePaused(bool paused) public {
1602 		require(msg.sender == OWNER);
1603 
1604 		GAMEPAUSED = paused;
1605 	}
1606 
1607 	function setRefundsActive(bool active) public {
1608 		require(msg.sender == OWNER);
1609 
1610 		REFUNDSACTIVE = active;
1611 	}
1612 
1613 	function setMinBetPerSpin(uint256 minBet) public {
1614 		require(msg.sender == OWNER && minBet > 1000);
1615 
1616 		MINBET_perSPIN = minBet;
1617 	}
1618 
1619 	function setMinBetPerTx(uint256 minBet) public {
1620 		require(msg.sender == OWNER && minBet > 1000);
1621 
1622 		MINBET_perTX = minBet;
1623 	}
1624 
1625 	function setMaxwin(uint16 newMaxWinInThousandthPercents) public {
1626 		require(msg.sender == OWNER && newMaxWinInThousandthPercents <= 333); // cannot set max win greater than 1/3 of the bankroll (a jackpot is very rare)
1627 
1628 		MAXWIN_inTHOUSANDTHPERCENTS = newMaxWinInThousandthPercents;
1629 	}
1630 
1631 	// rescue tokens inadvertently sent to the contract address 
1632 	function ERC20Rescue(address tokenAddress, uint256 amtTokens) public {
1633 		require (msg.sender == OWNER);
1634 
1635 		ERC20(tokenAddress).transfer(msg.sender, amtTokens);
1636 	}
1637 
1638 	function refund(bytes32 oraclizeQueryId) public {
1639 		// save into memory for cheap access
1640 		SlotsGameData memory data = slotsData[oraclizeQueryId];
1641 
1642 		//require that the query time is too slow, bet has not been paid out, and either contract owner or player is calling this function.
1643 		require(SafeMath.sub(block.timestamp, data.start) >= ORACLIZEQUERYMAXTIME
1644 			&& (msg.sender == OWNER || msg.sender == data.player)
1645 			&& (!data.paidOut)
1646 			&& data.etherReceived <= LIABILITIES
1647 			&& data.etherReceived > 0
1648 			&& REFUNDSACTIVE);
1649 
1650 		// set contract data
1651 		slotsData[oraclizeQueryId].paidOut = true;
1652 
1653 		// subtract etherReceived from these two values because the bet is being refunded
1654 		LIABILITIES = SafeMath.sub(LIABILITIES, data.etherReceived);
1655 
1656 		// then transfer the original bet to the player.
1657 		data.player.transfer(data.etherReceived);
1658 
1659 		// finally, log an event saying that the refund has processed.
1660 		emit Refund(oraclizeQueryId, data.etherReceived);
1661 	}
1662 
1663 	function play(uint8 credits) public payable {
1664 		// save for future use / gas efficiency
1665 		uint256 betPerCredit = msg.value / credits;
1666 
1667 		// require that the game is unpaused, and that the credits being purchased are greater than 0 and less than the allowed amount, default: 100 spins 
1668 		// verify that the bet is less than or equal to the bet limit, so we don't go bankrupt, and that the etherreceived is greater than the minbet.
1669 		require(!GAMEPAUSED
1670 			&& msg.value >= MINBET_perTX
1671 			&& betPerCredit >= MINBET_perSPIN
1672 			&& credits > 0 
1673 			&& credits <= 224
1674 			&& SafeMath.mul(betPerCredit, 5000) <= getMaxWin()); // 5000 is the jackpot payout (max win on a roll)
1675 
1676 		// equation for gas to oraclize is:
1677 		// gas = (some fixed gas amt) + 3270 * credits
1678 
1679 		uint256 gasToSend = INITIALGASFORORACLIZE + (uint256(3270) * credits);
1680 
1681 		EOSBetBankrollInterface(BANKROLLER).payOraclize(oraclize_getPrice('random', gasToSend));
1682 
1683 		// oraclize_newRandomDSQuery(delay in seconds, bytes of random data, gas for callback function)
1684 		bytes32 oraclizeQueryId = oraclize_newRandomDSQuery(0, 30, gasToSend);
1685 
1686 		// add the new slots data to a mapping so that the oraclize __callback can use it later
1687 		slotsData[oraclizeQueryId] = SlotsGameData({
1688 			player : msg.sender,
1689 			paidOut : false,
1690 			start : block.timestamp,
1691 			etherReceived : msg.value,
1692 			credits : credits
1693 		});
1694 
1695 		// add the sent value into liabilities. this should NOT go into the bankroll yet
1696 		// and must be quarantined here to prevent timing attacks
1697 		LIABILITIES = SafeMath.add(LIABILITIES, msg.value);
1698 
1699 		emit BuyCredits(oraclizeQueryId);
1700 	}
1701 
1702 	function __callback(bytes32 _queryId, string _result, bytes _proof) public {
1703 		// get the game data and put into memory
1704 		SlotsGameData memory data = slotsData[_queryId];
1705 
1706 		require(msg.sender == oraclize_cbAddress() 
1707 			&& !data.paidOut 
1708 			&& data.player != address(0) 
1709 			&& LIABILITIES >= data.etherReceived);
1710 
1711 		// if the proof has failed, immediately refund the player the original bet.
1712 		if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0){
1713 
1714 			if (REFUNDSACTIVE){
1715 				// set contract data
1716 				slotsData[_queryId].paidOut = true;
1717 
1718 				// subtract from liabilities and amount wagered, because this bet is being refunded.
1719 				LIABILITIES = SafeMath.sub(LIABILITIES, data.etherReceived);
1720 
1721 				// transfer the original bet back
1722 				data.player.transfer(data.etherReceived);
1723 
1724 				// log the refund
1725 				emit Refund(_queryId, data.etherReceived);
1726 			}
1727 			// log the ledger proof fail 
1728 			emit LedgerProofFailed(_queryId);
1729 			
1730 		}
1731 		else {
1732 			// again, this block is almost identical to the previous block in the play(...) function 
1733 			// instead of duplicating documentation, we will just point out the changes from the other block 
1734 			uint256 dialsSpun;
1735 			
1736 			uint8 dial1;
1737 			uint8 dial2;
1738 			uint8 dial3;
1739 			
1740 			uint256[] memory logsData = new uint256[](8);
1741 			
1742 			uint256 payout;
1743 			
1744 			// must use data.credits instead of credits.
1745 			for (uint8 i = 0; i < data.credits; i++){
1746 
1747 				// all dials now use _result, instead of blockhash, this is the main change, and allows Slots to 
1748 				// accomodate bets of any size, free of possible miner interference 
1749 				dialsSpun += 1;
1750 				dial1 = uint8(uint(keccak256(_result, dialsSpun)) % 64);
1751 				
1752 				dialsSpun += 1;
1753 				dial2 = uint8(uint(keccak256(_result, dialsSpun)) % 64);
1754 				
1755 				dialsSpun += 1;
1756 				dial3 = uint8(uint(keccak256(_result, dialsSpun)) % 64);
1757 
1758 				// dial 1
1759 				dial1 = getDial1Type(dial1);
1760 
1761 				// dial 2
1762 				dial2 = getDial2Type(dial2);
1763 
1764 				// dial 3
1765 				dial3 = getDial3Type(dial3);
1766 
1767 				// determine the payout
1768 				payout += determinePayout(dial1, dial2, dial3);
1769 				
1770 				// assembling log data
1771 				if (i <= 27){
1772 					// in logsData0
1773 					logsData[0] += uint256(dial1) * uint256(2) ** (3 * ((3 * (27 - i)) + 2));
1774 					logsData[0] += uint256(dial2) * uint256(2) ** (3 * ((3 * (27 - i)) + 1));
1775 					logsData[0] += uint256(dial3) * uint256(2) ** (3 * ((3 * (27 - i))));
1776 				}
1777 				else if (i <= 55){
1778 					// in logsData1
1779 					logsData[1] += uint256(dial1) * uint256(2) ** (3 * ((3 * (55 - i)) + 2));
1780 					logsData[1] += uint256(dial2) * uint256(2) ** (3 * ((3 * (55 - i)) + 1));
1781 					logsData[1] += uint256(dial3) * uint256(2) ** (3 * ((3 * (55 - i))));
1782 				}
1783 				else if (i <= 83) {
1784 					// in logsData2
1785 					logsData[2] += uint256(dial1) * uint256(2) ** (3 * ((3 * (83 - i)) + 2));
1786 					logsData[2] += uint256(dial2) * uint256(2) ** (3 * ((3 * (83 - i)) + 1));
1787 					logsData[2] += uint256(dial3) * uint256(2) ** (3 * ((3 * (83 - i))));
1788 				}
1789 				else if (i <= 111) {
1790 					// in logsData3
1791 					logsData[3] += uint256(dial1) * uint256(2) ** (3 * ((3 * (111 - i)) + 2));
1792 					logsData[3] += uint256(dial2) * uint256(2) ** (3 * ((3 * (111 - i)) + 1));
1793 					logsData[3] += uint256(dial3) * uint256(2) ** (3 * ((3 * (111 - i))));
1794 				}
1795 				else if (i <= 139){
1796 					// in logsData4
1797 					logsData[4] += uint256(dial1) * uint256(2) ** (3 * ((3 * (139 - i)) + 2));
1798 					logsData[4] += uint256(dial2) * uint256(2) ** (3 * ((3 * (139 - i)) + 1));
1799 					logsData[4] += uint256(dial3) * uint256(2) ** (3 * ((3 * (139 - i))));
1800 				}
1801 				else if (i <= 167){
1802 					// in logsData5
1803 					logsData[5] += uint256(dial1) * uint256(2) ** (3 * ((3 * (167 - i)) + 2));
1804 					logsData[5] += uint256(dial2) * uint256(2) ** (3 * ((3 * (167 - i)) + 1));
1805 					logsData[5] += uint256(dial3) * uint256(2) ** (3 * ((3 * (167 - i))));
1806 				}
1807 				else if (i <= 195){
1808 					// in logsData6
1809 					logsData[6] += uint256(dial1) * uint256(2) ** (3 * ((3 * (195 - i)) + 2));
1810 					logsData[6] += uint256(dial2) * uint256(2) ** (3 * ((3 * (195 - i)) + 1));
1811 					logsData[6] += uint256(dial3) * uint256(2) ** (3 * ((3 * (195 - i))));
1812 				}
1813 				else if (i <= 223){
1814 					// in logsData7
1815 					logsData[7] += uint256(dial1) * uint256(2) ** (3 * ((3 * (223 - i)) + 2));
1816 					logsData[7] += uint256(dial2) * uint256(2) ** (3 * ((3 * (223 - i)) + 1));
1817 					logsData[7] += uint256(dial3) * uint256(2) ** (3 * ((3 * (223 - i))));
1818 				}
1819 			}
1820 
1821 			// track that these spins were made
1822 			DIALSSPUN += dialsSpun;
1823 
1824 			// and add the amount wagered
1825 			AMOUNTWAGERED = SafeMath.add(AMOUNTWAGERED, data.etherReceived);
1826 
1827 			// IMPORTANT: we must change the "paidOut" to TRUE here to prevent reentrancy/other nasty effects.
1828 			// this was not needed with the previous loop/code block, and is used because variables must be written into storage
1829 			slotsData[_queryId].paidOut = true;
1830 
1831 			// decrease LIABILITIES when the spins are made
1832 			LIABILITIES = SafeMath.sub(LIABILITIES, data.etherReceived);
1833 
1834 			// get the developers cut, and send the rest of the ether received to the bankroller contract
1835 			uint256 developersCut = data.etherReceived / 100;
1836 
1837 			DEVELOPERSFUND = SafeMath.add(DEVELOPERSFUND, developersCut);
1838 
1839 			EOSBetBankrollInterface(BANKROLLER).receiveEtherFromGameAddress.value(SafeMath.sub(data.etherReceived, developersCut))();
1840 
1841 			// get the ether to be paid out, and force the bankroller contract to pay out the player
1842 			uint256 etherPaidout = SafeMath.mul((data.etherReceived / data.credits), payout);
1843 
1844 			EOSBetBankrollInterface(BANKROLLER).payEtherToWinner(etherPaidout, data.player);
1845 
1846 			// log en event with indexed query id
1847 			emit SlotsLargeBet(_queryId, logsData[0], logsData[1], logsData[2], logsData[3], logsData[4], logsData[5], logsData[6], logsData[7]);
1848 		}
1849 	}
1850 	
1851 	// HELPER FUNCTIONS TO:
1852 	// calculate the result of the dials based on the hardcoded slot data: 
1853 
1854 	// STOPS			REEL#1	REEL#2	REEL#3
1855 	///////////////////////////////////////////
1856 	// gold ether 	0 //  1  //  3   //   1  //	
1857 	// silver ether 1 //  7  //  1   //   6  //
1858 	// bronze ether 2 //  1  //  7   //   6  //
1859 	// gold planet  3 //  5  //  7   //   6  //
1860 	// silverplanet 4 //  9  //  6   //   7  //
1861 	// bronzeplanet 5 //  9  //  8   //   6  //
1862 	// ---blank---  6 //  32 //  32  //   32 //
1863 	///////////////////////////////////////////
1864 
1865 	// note that dial1 / 2 / 3 will go from mod 64 to mod 7 in this manner
1866 	
1867 	function getDial1Type(uint8 dial1Location) internal pure returns(uint8) {
1868 	    if (dial1Location == 0) 							        { return 0; }
1869 		else if (dial1Location >= 1 && dial1Location <= 7) 			{ return 1; }
1870 		else if (dial1Location == 8) 						        { return 2; }
1871 		else if (dial1Location >= 9 && dial1Location <= 13) 		{ return 3; }
1872 		else if (dial1Location >= 14 && dial1Location <= 22) 		{ return 4; }
1873 		else if (dial1Location >= 23 && dial1Location <= 31) 		{ return 5; }
1874 		else 										                { return 6; }
1875 	}
1876 	
1877 	function getDial2Type(uint8 dial2Location) internal pure returns(uint8) {
1878 	    if (dial2Location >= 0 && dial2Location <= 2) 				{ return 0; }
1879 		else if (dial2Location == 3) 						        { return 1; }
1880 		else if (dial2Location >= 4 && dial2Location <= 10)			{ return 2; }
1881 		else if (dial2Location >= 11 && dial2Location <= 17) 		{ return 3; }
1882 		else if (dial2Location >= 18 && dial2Location <= 23) 		{ return 4; }
1883 		else if (dial2Location >= 24 && dial2Location <= 31) 		{ return 5; }
1884 		else 										                { return 6; }
1885 	}
1886 	
1887 	function getDial3Type(uint8 dial3Location) internal pure returns(uint8) {
1888 	    if (dial3Location == 0) 							        { return 0; }
1889 		else if (dial3Location >= 1 && dial3Location <= 6)			{ return 1; }
1890 		else if (dial3Location >= 7 && dial3Location <= 12) 		{ return 2; }
1891 		else if (dial3Location >= 13 && dial3Location <= 18)		{ return 3; }
1892 		else if (dial3Location >= 19 && dial3Location <= 25) 		{ return 4; }
1893 		else if (dial3Location >= 26 && dial3Location <= 31) 		{ return 5; }
1894 		else 										                { return 6; }
1895 	}
1896 	
1897 	// HELPER FUNCTION TO:
1898 	// determine the payout given dial locations based on this table
1899 	
1900 	// hardcoded payouts data:
1901 	// 			LANDS ON 				//	PAYS  //
1902 	////////////////////////////////////////////////
1903 	// Bronze E -> Silver E -> Gold E	//	5000  //
1904 	// 3x Gold Ether					//	1777  //
1905 	// 3x Silver Ether					//	250   //
1906 	// 3x Bronze Ether					//	250   //
1907 	// Bronze P -> Silver P -> Gold P	//	90    //
1908 	// 3x any Ether 					//	70    //
1909 	// 3x Gold Planet 					//	50    //
1910 	// 3x Silver Planet					//	25    //
1911 	// Any Gold P & Silver P & Bronze P //	15    //
1912 	// 3x Bronze Planet					//	10    //
1913 	// Any 3 planet type				//	3     //
1914 	// Any 3 gold						//	3     //
1915 	// Any 3 silver						//	2     //
1916 	// Any 3 bronze						//	2     //
1917 	// Blank, blank, blank				//	1     //
1918 	// else								//  0     //
1919 	////////////////////////////////////////////////
1920 	
1921 	function determinePayout(uint8 dial1, uint8 dial2, uint8 dial3) internal pure returns(uint256) {
1922 		if (dial1 == 6 || dial2 == 6 || dial3 == 6){
1923 			// all blank
1924 			if (dial1 == 6 && dial2 == 6 && dial3 == 6)
1925 				return 1;
1926 		}
1927 		else if (dial1 == 5){
1928 			// bronze planet -> silver planet -> gold planet
1929 			if (dial2 == 4 && dial3 == 3) 
1930 				return 90;
1931 
1932 			// one gold planet, one silver planet, one bronze planet, any order!
1933 			// note: other order covered above, return 90
1934 			else if (dial2 == 3 && dial3 == 4)
1935 				return 15;
1936 
1937 			// all bronze planet 
1938 			else if (dial2 == 5 && dial3 == 5) 
1939 				return 10;
1940 
1941 			// any three planet type 
1942 			else if (dial2 >= 3 && dial2 <= 5 && dial3 >= 3 && dial3 <= 5)
1943 				return 3;
1944 
1945 			// any three bronze 
1946 			else if ((dial2 == 2 || dial2 == 5) && (dial3 == 2 || dial3 == 5))
1947 				return 2;
1948 		}
1949 		else if (dial1 == 4){
1950 			// all silver planet
1951 			if (dial2 == 4 && dial3 == 4)
1952 				return 25;
1953 
1954 			// one gold planet, one silver planet, one bronze planet, any order!
1955 			else if ((dial2 == 3 && dial3 == 5) || (dial2 == 5 && dial3 == 3))
1956 				return 15;
1957 
1958 			// any three planet type 
1959 			else if (dial2 >= 3 && dial2 <= 5 && dial3 >= 3 && dial3 <= 5)
1960 				return 3;
1961 
1962 			// any three silver
1963 			else if ((dial2 == 1 || dial2 == 4) && (dial3 == 1 || dial3 == 4))
1964 				return 2;
1965 		}
1966 		else if (dial1 == 3){
1967 			// all gold planet
1968 			if (dial2 == 3 && dial3 == 3)
1969 				return 50;
1970 
1971 			// one gold planet, one silver planet, one bronze planet, any order!
1972 			else if ((dial2 == 4 && dial3 == 5) || (dial2 == 5 && dial3 == 4))
1973 				return 15;
1974 
1975 			// any three planet type 
1976 			else if (dial2 >= 3 && dial2 <= 5 && dial3 >= 3 && dial3 <= 5)
1977 				return 3;
1978 
1979 			// any three gold
1980 			else if ((dial2 == 0 || dial2 == 3) && (dial3 == 0 || dial3 == 3))
1981 				return 3;
1982 		}
1983 		else if (dial1 == 2){
1984 			if (dial2 == 1 && dial3 == 0)
1985 				return 5000; // jackpot!!!!
1986 
1987 			// all bronze ether
1988 			else if (dial2 == 2 && dial3 == 2)
1989 				return 250;
1990 
1991 			// all some type of ether
1992 			else if (dial2 >= 0 && dial2 <= 2 && dial3 >= 0 && dial3 <= 2)
1993 				return 70;
1994 
1995 			// any three bronze
1996 			else if ((dial2 == 2 || dial2 == 5) && (dial3 == 2 || dial3 == 5))
1997 				return 2;
1998 		}
1999 		else if (dial1 == 1){
2000 			// all silver ether 
2001 			if (dial2 == 1 && dial3 == 1)
2002 				return 250;
2003 
2004 			// all some type of ether
2005 			else if (dial2 >= 0 && dial2 <= 2 && dial3 >= 0 && dial3 <= 2)
2006 				return 70;
2007 
2008 			// any three silver
2009 			else if ((dial2 == 1 || dial2 == 4) && (dial3 == 1 || dial3 == 4))
2010 				return 3;
2011 		}
2012 		else if (dial1 == 0){
2013 			// all gold ether
2014 			if (dial2 == 0 && dial3 == 0)
2015 				return 1777;
2016 
2017 			// all some type of ether
2018 			else if (dial2 >= 0 && dial2 <= 2 && dial3 >= 0 && dial3 <= 2)
2019 				return 70;
2020 
2021 			// any three gold
2022 			else if ((dial2 == 0 || dial2 == 3) && (dial3 == 0 || dial3 == 3))
2023 				return 3;
2024 		}
2025 		return 0;
2026 	}
2027 
2028 }