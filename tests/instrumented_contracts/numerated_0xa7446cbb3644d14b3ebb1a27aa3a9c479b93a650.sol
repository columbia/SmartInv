1 pragma solidity ^0.4.2;
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
1014 
1015 contract Eggfrenzy is usingOraclize {
1016 
1017   mapping(address =>bytes32[]) recordindexlist;//玩家下注索引记录
1018   mapping (bytes32 => address) playerAddress;
1019   mapping(bytes32 =>uint) playerBetAmount;//下注额
1020   mapping(bytes32 =>uint) playerWinmount;//赢的金额
1021   mapping(bytes32 =>uint) playerWinorlose;//输赢1pending,2win,3lose,0no record
1022   mapping(bytes32 =>uint) playerBetId;//选择第几个蛋
1023   mapping(bytes32 =>uint) playerBetTotalNumber;//选择总蛋数
1024   mapping(bytes32 =>uint) playerWineggno;//中奖的蛋序号
1025   mapping(bytes32 =>uint) playerbettime;//下注时间
1026 
1027   mapping(address => bytes32) betOracleid;//玩家最新一次的id
1028   uint randomarr;
1029   address public owner;
1030   uint public profit2eggs;//二个蛋倍数
1031   uint public profit3eggs;//三个蛋倍数
1032   uint public profit5eggs;//五个蛋倍数
1033 
1034   uint public maxprice;//最多金额
1035   uint public minprice;//最小金额
1036 
1037   uint public maxmoneypercent;
1038   uint public fee;
1039   uint public oraclizeFee;
1040   uint public oraclizeGasLimit;
1041 
1042   uint public maxProfit;//最高奖池
1043   uint public totalWon;
1044   uint public totalLose;
1045   uint public totalWeiWon;
1046   uint public contractBalance;
1047   uint public onoff;
1048   function Eggfrenzy() public {
1049       owner = msg.sender;
1050       profit2eggs=2;//二个蛋倍数
1051       profit3eggs=3;//三个蛋倍数
1052       profit5eggs=5;//五个蛋倍数
1053       maxprice=5000000000000000;//最多金额
1054       minprice=1500000000000000;//要最小金额比手续费大
1055       oraclizeFee=1200000000000000;
1056       maxmoneypercent=80;
1057       fee=98;
1058       oraclizeGasLimit=200000;
1059       onoff=1;
1060       contractBalance=this.balance;
1061       maxProfit=(contractBalance * maxmoneypercent)/100;
1062       /* maxmoney=(this.balance*maxmoneypercent)/100; */
1063     }
1064 
1065     modifier onlyAdmin() {
1066         require(msg.sender == owner);
1067         _;
1068     }
1069     modifier onlyOraclize {
1070         require (msg.sender == oraclize_cbAddress());
1071         _;
1072     }
1073   //初始蛋的个数，价格
1074   function openegg(uint betid,uint nums) public payable returns (bytes32) {
1075     uint betValue = msg.value;
1076     require(onoff==1);
1077     require(nums==2||nums==3 || nums==5);
1078     require(betValue >=minprice && betValue <=maxprice);
1079     uint winnums=profit2eggs;
1080     if(nums==3){
1081       winnums=profit3eggs;
1082     }else if(nums==5){
1083       winnums=profit5eggs;
1084     }
1085     require(maxProfit > (betValue*winnums));
1086     bytes32 queryId = oraclize_query("WolframAlpha", "random number between 0 and 100",oraclizeGasLimit);
1087     uint index=recordindexlist[msg.sender].length++;
1088 
1089     recordindexlist[msg.sender][index]=queryId;//index:id
1090     playerAddress[queryId]=msg.sender;//id:address
1091     playerBetAmount[queryId]=betValue;//id:betvalue
1092     playerBetId[queryId]=betid;//id:betid
1093     playerBetTotalNumber[queryId]=nums;//id:bettotalno
1094     playerWinmount[queryId]=0;//id:winvalue
1095     playerWinorlose[queryId]=1;//id:winorlose,1pending,2win,3lose
1096     playerWineggno[queryId]=999;//id:winno,default 999
1097     playerbettime[queryId]=now;//id:time
1098 
1099     betOracleid[msg.sender]=queryId;//address:id(latest id)
1100 
1101     return queryId;
1102   }
1103 
1104   function getbetresult(bytes32 _queryId) public view returns(
1105     uint _bettype,
1106     uint _selectnum,
1107     uint _winvalue,
1108     uint _winno,
1109     uint _eggnums,
1110     uint _time){
1111     _bettype=playerWinorlose[_queryId];
1112     _selectnum=playerBetId[_queryId];
1113     _winvalue=playerWinmount[_queryId];
1114     _winno=playerWineggno[_queryId];
1115     _eggnums=playerBetTotalNumber[_queryId];
1116     _time=playerbettime[_queryId];
1117   }
1118   //获取当前最新的记录
1119   function getbetresultfirst(address caccount) public view returns(
1120     uint _bettype,
1121     uint _winnum,
1122     uint _selectnums,
1123     uint _winvalue,
1124     bytes32 _queryId,
1125     uint _eggnums){
1126     _queryId=betOracleid[caccount];
1127     _bettype=playerWinorlose[_queryId];
1128     _winnum=playerWineggno[_queryId];
1129     _selectnums=playerBetId[_queryId];
1130     _winvalue=playerWinmount[_queryId];
1131     _eggnums=playerBetTotalNumber[_queryId];
1132   }
1133 
1134   function getallresutl() public view returns(uint[100],uint[100],uint[100],uint[100],uint[100]){
1135     uint len=recordindexlist[msg.sender].length;
1136     require(len>0);
1137     uint[100] memory  twinorlost;
1138     uint[100] memory tbetamount;
1139     uint[100] memory twinamount;
1140     uint[100] memory tbetid;
1141     uint[100] memory tbeteggs;
1142     uint[100] memory twineggno;
1143     // uint[100] memory ttime;
1144     uint j=0;
1145     for(uint i=0;i<len;i++){
1146       if(j<100){
1147         bytes32 _queryId=recordindexlist[msg.sender][len-i-1];
1148         twinorlost[i]=playerWinorlose[_queryId];
1149         tbetamount[i]=playerBetAmount[_queryId];
1150         twinamount[i]=playerWinmount[_queryId];
1151         tbetid[i]=playerBetId[_queryId];
1152         tbeteggs[i]=playerBetTotalNumber[_queryId];
1153         twineggno[i]=playerWineggno[_queryId];
1154         // ttime[i]=playerbettime[_queryId];
1155       }
1156       j++;
1157     }
1158       return (twinorlost,tbetamount,twinamount,tbetid,twineggno);
1159   }
1160   function senttest()public payable onlyAdmin{
1161       contractBalance=this.balance;
1162       maxProfit=(this.balance*maxmoneypercent)/100;
1163   }
1164   function updatebalance() public payable{
1165     contractBalance=this.balance;
1166     maxProfit=(this.balance*maxmoneypercent)/100;
1167   }
1168   function withdraw(uint _amount , address desaccount) public onlyAdmin{
1169         desaccount.transfer(_amount);
1170         contractBalance=this.balance;
1171         maxProfit=(contractBalance*maxmoneypercent)/100;
1172     }
1173 
1174   function __callback(bytes32 queryId, string result) public onlyOraclize {
1175       uint  weiWon;
1176       uint divnum;
1177       uint profitmul;
1178       uint eggnuns=0;
1179       if(playerBetTotalNumber[queryId]==2){
1180         divnum=50;
1181         profitmul=profit2eggs;
1182       }else if(playerBetTotalNumber[queryId]==3){
1183         divnum=33;
1184         eggnuns=2;
1185         profitmul=profit3eggs;
1186       }else{
1187         divnum=20;
1188         eggnuns=5;
1189         profitmul=profit5eggs;
1190       }
1191       randomarr=parseInt(result);
1192       if(playerWinorlose[queryId]==1){
1193           if( (parseInt(result)/divnum) == playerBetId[queryId]-eggnuns){
1194               totalWon++;
1195               weiWon=( playerBetAmount[queryId] * fee/100 )*profitmul - oraclizeFee;
1196               totalWeiWon+=weiWon;
1197               playerWinorlose[queryId]=2;
1198               playerWinmount[queryId]=weiWon;
1199               playerWineggno[queryId]=parseInt(result)/divnum+eggnuns;
1200               playerAddress[queryId].transfer(weiWon);
1201           }else{
1202               playerWinorlose[queryId]=3;//1pending,2win,3lose
1203               playerWineggno[queryId]=parseInt(result)/divnum+eggnuns;
1204               totalLose++;
1205           }
1206       }
1207 
1208 
1209       contractBalance=this.balance;
1210       maxProfit=(this.balance * maxmoneypercent)/100;
1211   }
1212 
1213   function setGameOnoff(uint _on0ff) public onlyAdmin{
1214     onoff=_on0ff;
1215   }
1216 
1217   function setGameVars(uint _profit2eggs,uint _profit3eggs,uint _profit5eggs,uint _fee,uint _oraclizeFee)public onlyAdmin{
1218       profit2eggs=_profit2eggs;//二个蛋倍数
1219       profit3eggs=_profit3eggs;//三个蛋倍数
1220       profit5eggs=_profit5eggs;//五个蛋倍数
1221       fee=_fee;
1222       oraclizeFee=(_oraclizeFee * 1 wei);
1223       maxProfit=(this.balance*maxmoneypercent)/100;
1224       contractBalance=this.balance;
1225   }
1226 
1227   function setmaxprice(uint _maxprice) public onlyAdmin(){
1228     maxprice=(_maxprice * 1 wei);//最多金额
1229   }
1230   function setminprice(uint _minprice) public onlyAdmin(){
1231     minprice=(_minprice * 1 wei);//最小金额
1232   }
1233   function setoraclegasprice(uint newGas) public onlyAdmin(){
1234     oraclize_setCustomGasPrice(newGas * 1 wei);
1235   }
1236   function setoraclelimitgas(uint _oraclizeGasLimit) public onlyAdmin(){
1237     oraclizeGasLimit=(_oraclizeGasLimit* 1 wei);
1238   }
1239 
1240   function getrandoms()public view returns (uint){
1241     return randomarr;
1242   }
1243   function getDatas() public view returns(
1244       uint _maxProfit,
1245       uint _minprice,
1246       uint _maxprice,
1247       uint _profit2eggs,
1248       uint _profit3eggs,
1249       uint _profit5eggs,
1250       uint _totalWon,
1251       uint _totalWeiWon,
1252       uint _contractbalance,
1253       uint _onoff,
1254       uint _fee,
1255       uint _oraclizeFee
1256       ){
1257           _maxProfit=maxProfit;
1258           _minprice=minprice;
1259           _maxprice=maxprice;
1260           _profit2eggs=profit2eggs;
1261           _profit3eggs=profit3eggs;
1262           _profit5eggs=profit5eggs;
1263           _totalWon=totalWon;
1264           _contractbalance=contractBalance;
1265           _totalWeiWon=totalWeiWon;
1266           _onoff=onoff;
1267           _fee=fee;
1268           _oraclizeFee=oraclizeFee;
1269 
1270 
1271       }
1272 }