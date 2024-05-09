1 pragma solidity ^0.4.18;
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
746         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
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
778         if (address(keccak256(pubkey)) == signer) return true;
779         else {
780             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
781             return (address(keccak256(pubkey)) == signer);
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
796         tosign2[0] = byte(1); //role
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
822         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
823 
824         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
825         require(proofVerified);
826 
827         _;
828     }
829 
830     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
831         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
832         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
833 
834         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
835         if (proofVerified == false) return 2;
836 
837         return 0;
838     }
839 
840     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
841         bool match_ = true;
842         
843 
844         for (uint256 i=0; i< n_random_bytes; i++) {
845             if (content[i] != prefix[i]) match_ = false;
846         }
847 
848         return match_;
849     }
850 
851     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
852 
853         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
854         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
855         bytes memory keyhash = new bytes(32);
856         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
857         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
858 
859         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
860         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
861 
862         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
863         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
864 
865         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
866         // This is to verify that the computed args match with the ones specified in the query.
867         bytes memory commitmentSlice1 = new bytes(8+1+32);
868         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
869 
870         bytes memory sessionPubkey = new bytes(64);
871         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
872         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
873 
874         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
875         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
876             delete oraclize_randomDS_args[queryId];
877         } else return false;
878 
879 
880         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
881         bytes memory tosign1 = new bytes(32+8+1+32);
882         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
883         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
884 
885         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
886         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
887             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
888         }
889 
890         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
891     }
892 
893     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
894     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
895         uint minLength = length + toOffset;
896 
897         // Buffer too small
898         require(to.length >= minLength); // Should be a better way?
899 
900         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
901         uint i = 32 + fromOffset;
902         uint j = 32 + toOffset;
903 
904         while (i < (32 + fromOffset + length)) {
905             assembly {
906                 let tmp := mload(add(from, i))
907                 mstore(add(to, j), tmp)
908             }
909             i += 32;
910             j += 32;
911         }
912 
913         return to;
914     }
915 
916     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
917     // Duplicate Solidity's ecrecover, but catching the CALL return value
918     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
919         // We do our own memory management here. Solidity uses memory offset
920         // 0x40 to store the current end of memory. We write past it (as
921         // writes are memory extensions), but don't update the offset so
922         // Solidity will reuse it. The memory used here is only needed for
923         // this context.
924 
925         // FIXME: inline assembly can't access return values
926         bool ret;
927         address addr;
928 
929         assembly {
930             let size := mload(0x40)
931             mstore(size, hash)
932             mstore(add(size, 32), v)
933             mstore(add(size, 64), r)
934             mstore(add(size, 96), s)
935 
936             // NOTE: we can reuse the request memory because we deal with
937             //       the return code
938             ret := call(3000, 1, 0, size, 128, size, 32)
939             addr := mload(size)
940         }
941 
942         return (ret, addr);
943     }
944 
945     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
946     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
947         bytes32 r;
948         bytes32 s;
949         uint8 v;
950 
951         if (sig.length != 65)
952           return (false, 0);
953 
954         // The signature format is a compact form of:
955         //   {bytes32 r}{bytes32 s}{uint8 v}
956         // Compact means, uint8 is not padded to 32 bytes.
957         assembly {
958             r := mload(add(sig, 32))
959             s := mload(add(sig, 64))
960 
961             // Here we are loading the last 32 bytes. We exploit the fact that
962             // 'mload' will pad with zeroes if we overread.
963             // There is no 'mload8' to do this, but that would be nicer.
964             v := byte(0, mload(add(sig, 96)))
965 
966             // Alternative solution:
967             // 'byte' is not working due to the Solidity parser, so lets
968             // use the second best option, 'and'
969             // v := and(mload(add(sig, 65)), 255)
970         }
971 
972         // albeit non-transactional signatures are not specified by the YP, one would expect it
973         // to match the YP range of [27, 28]
974         //
975         // geth uses [0, 1] and some clients have followed. This might change, see:
976         //  https://github.com/ethereum/go-ethereum/issues/2053
977         if (v < 27)
978           v += 27;
979 
980         if (v != 27 && v != 28)
981             return (false, 0);
982 
983         return safer_ecrecover(hash, v, r, s);
984     }
985 
986 }
987 // </ORACLIZE_API>
988 
989 library SafeMath {
990   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
991     if (a == 0) {
992       return 0;
993     }
994     uint256 c = a * b;
995     assert(c / a == b);
996     return c;
997   }
998 
999   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1000     // assert(b > 0); // Solidity automatically throws when dividing by 0
1001     uint256 c = a / b;
1002     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1003     return c;
1004   }
1005 
1006   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1007     assert(b <= a);
1008     return a - b;
1009   }
1010 
1011   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1012     uint256 c = a + b;
1013     assert(c >= a);
1014     return c;
1015   }
1016 }
1017 
1018 contract ERC20 {
1019     uint256 public totalSupply;
1020     function balanceOf(address who) public view returns (uint256);
1021     function transfer(address to, uint256 value) public returns (bool);
1022     function transferFrom(address from, address to, uint256 value) public returns (bool);
1023     function allowance(address owner, address spender) public view returns (uint256);
1024     function approve(address spender, uint256 value) public returns (bool);
1025     event Approval(address indexed owner, address indexed spender, uint256 value);
1026     event Transfer(address indexed from, address indexed to, uint256 value);
1027 }
1028 
1029 contract StandardToken is ERC20 {
1030     using SafeMath for uint256;
1031 
1032     mapping(address => uint256) balances;
1033     mapping (address => mapping (address => uint256)) internal allowed;
1034 
1035     /**
1036     * @dev Gets the balance of the specified address.
1037     * @param _owner The address to query the the balance of.
1038     * @return An uint256 representing the amount owned by the passed address.
1039     */
1040     function balanceOf(address _owner) public view returns (uint256 balance) {
1041         return balances[_owner];
1042     }
1043 
1044     /**
1045     * @dev transfer token for a specified address
1046     * @param _to The address to transfer to.
1047     * @param _value The amount to be transferred.
1048     */
1049     function transfer(address _to, uint256 _value) public returns (bool) {
1050         require(_to != address(0));
1051         require(_value <= balances[msg.sender]);
1052 
1053         // SafeMath.sub will throw if there is not enough balance.
1054         balances[msg.sender] = balances[msg.sender].sub(_value);
1055         balances[_to] = balances[_to].add(_value);
1056         Transfer(msg.sender, _to, _value);
1057         return true;
1058     }
1059 
1060     /**
1061     * @dev Transfer tokens from one address to another
1062     * @param _from address The address which you want to send tokens from
1063     * @param _to address The address which you want to transfer to
1064     * @param _value uint256 the amount of tokens to be transferred
1065     */
1066     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1067         require(_to != address(0));
1068         require(_value <= balances[_from]);
1069         require(_value <= allowed[_from][msg.sender]);
1070 
1071         balances[_from] = balances[_from].sub(_value);
1072         balances[_to] = balances[_to].add(_value);
1073         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1074         Transfer(_from, _to, _value);
1075         return true;
1076     }
1077 
1078     /**
1079     * @dev Function to check the amount of tokens that an owner allowed to a spender.
1080     * @param _owner address The address which owns the funds.
1081     * @param _spender address The address which will spend the funds.
1082     * @return A uint256 specifying the amount of tokens still available for the spender.
1083     */
1084     function allowance(address _owner, address _spender) public view returns (uint256) {
1085         return allowed[_owner][_spender];
1086     }
1087 
1088     /**
1089     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1090     *
1091     * Beware that changing an allowance with this method brings the risk that someone may use both the old
1092     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1093     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1094     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1095     * @param _spender The address which will spend the funds.
1096     * @param _value The amount of tokens to be spent.
1097     */
1098     function approve(address _spender, uint256 _value) public returns (bool) {
1099         allowed[msg.sender][_spender] = _value;
1100         Approval(msg.sender, _spender, _value);
1101         return true;
1102     }
1103 
1104 
1105     /**
1106     * approve should be called when allowed[_spender] == 0. To increment
1107     * allowed value is better to use this function to avoid 2 calls (and wait until
1108     * the first transaction is mined)
1109     * From MonolithDAO Token.sol
1110     */
1111     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1112         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1113         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1114         return true;
1115     }
1116 
1117     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1118         uint oldValue = allowed[msg.sender][_spender];
1119         if (_subtractedValue > oldValue) {
1120         allowed[msg.sender][_spender] = 0;
1121         } else {
1122         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1123         }
1124         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1125         return true;
1126     }
1127 }
1128 
1129 contract FiCoin is StandardToken, usingOraclize {
1130 
1131     using SafeMath for uint256;
1132 
1133     struct Contributor {
1134         address addr;
1135         uint256 amount;
1136     }
1137 
1138     mapping (bytes32 => Contributor) internal contributors;
1139 
1140     //==========================================================
1141     // TOKEN PROPERTIES
1142     //==========================================================
1143     string public constant name = "FiCoin";
1144     string public constant symbol = "FiC";
1145     uint256 public constant decimals = 18;
1146     string public version = "1.0";
1147 
1148     //==========================================================
1149     // STAGE LIMITS PROPERTIES
1150     //==========================================================
1151     uint256 public saleCap;
1152 
1153     //==========================================================
1154     // WALLETS
1155     //==========================================================
1156     address public FiCoinFundDeposit;
1157     address public CoinStorage;
1158     address public OwnerAddress;
1159 
1160     //==========================================================
1161     // CROWDSALE STAGES
1162     //==========================================================
1163     bool internal isPreSale = false;
1164     bool internal isFirstRound  = false;
1165     bool internal isSecondRound = false;
1166 
1167     uint256 public burnedTokens;
1168 
1169     //==========================================================
1170     // INTERNAL VARIABLES
1171     //==========================================================
1172     uint256 internal tokenPriceInCents;
1173     uint256 internal buyLimit;
1174     uint256 internal totalLocked;
1175     uint256 internal startDate;
1176     uint256 internal endDate;
1177     mapping(address => uint256) internal lockedTokens;
1178     mapping(address => uint256) internal buyLimitPerAddress;
1179 
1180     //==========================================================
1181     // EVENTS
1182     //==========================================================
1183     event OraclizeQuery(string description);
1184     event Burn(address indexed burner, uint256 value);
1185     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
1186     event Lock(address indexed purchaser, uint256 value);
1187 
1188     //==========================================================
1189     // MODIFIERS
1190     //==========================================================
1191     modifier onlyOwner() {
1192         require(msg.sender == OwnerAddress);
1193         _;
1194     }
1195 
1196     //==========================================================
1197     // CONSTRUCTOR
1198     //==========================================================
1199     function FiCoin() public {
1200 
1201         FiCoinFundDeposit = 0x00aa6ddfa8ADD5B1E6bCfFcbaB83c3FDBd10DA91;
1202         CoinStorage = 0x00aD59ec96C12dA4C4546383fac422fEF45a21bB;
1203         OwnerAddress = 0x00aD59ec96C12dA4C4546383fac422fEF45a21bB;
1204         
1205         totalSupply = 14930352 * 10 ** decimals;
1206 
1207         // crowdsale statistics
1208         tokenPriceInCents = 34;
1209         buyLimit = 0;
1210         saleCap = 0;
1211 
1212         // burned tokens
1213         burnedTokens = 0;
1214 
1215         // move the supply the storage
1216         balances[CoinStorage] = totalSupply;
1217 
1218         startDate = 0;
1219         endDate = 0;
1220     }
1221 
1222     //==========================================================
1223     // ONLY OWNER FUNCTIONS
1224     //==========================================================
1225     function forwardFunds() onlyOwner public {
1226         FiCoinFundDeposit.transfer(this.balance);
1227     }
1228 
1229     //==========================================================
1230     // PUBLIC FUNCTIONS
1231     //==========================================================
1232     function () public payable {
1233         buyTokens(msg.sender);
1234     }
1235 
1236     // low level token purchase function
1237     function buyTokens(address beneficiary) public payable {
1238         require(beneficiary != address(0));
1239         require(msg.value >= 1 * 10 ** 17); // minimum ETH contribution is 0.1 ETH
1240         require(startDate < now && endDate > now);
1241         
1242         // this functionallity is kept in the same function with purpose.
1243         if (oraclize_getPrice("URL") > this.balance) {
1244             OraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1245         } else {
1246             OraclizeQuery("Oraclize query was sent, standing by for the answer.");
1247             bytes32 queryId = oraclize_query("URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum).0.price_usd");
1248             contributors[queryId] = Contributor(beneficiary, msg.value);
1249         }
1250     }
1251     
1252     function lockedOf(address _owner) public view returns (uint256 locked) {
1253         return lockedTokens[_owner];
1254     }
1255     
1256     function __callback(bytes32 myid, string result, bytes proof) public {
1257         require (msg.sender == oraclize_cbAddress());
1258 
1259         uint256 etherPrice = parseInt(result, 2);
1260         uint256 purchasedTokens = getPurchasedTokens(contributors[myid].amount, etherPrice);
1261     
1262         privateTransfer(contributors[myid].addr, purchasedTokens);
1263         TokenPurchase(contributors[myid].addr, contributors[myid].amount, purchasedTokens);
1264 
1265         delete contributors[myid];
1266     }
1267 
1268 
1269     //==========================================================
1270     // INTERNAL FUNCTIONS
1271     //==========================================================
1272     function getPurchasedTokens(uint256 _weiAmount, uint256 _etherPrice) internal constant returns (uint256) { 
1273         require(_etherPrice > 0);
1274 
1275         //Formula:
1276         //( weiAmount * etherPrice (cents) ) / ( tokenPrice (cents) )
1277         uint256 purchasedTokens = _weiAmount.mul(_etherPrice);
1278         purchasedTokens = purchasedTokens.div(tokenPriceInCents);
1279 
1280         return purchasedTokens;
1281     }
1282 
1283     function privateTransfer(address _to, uint256 _value) internal returns (bool) {
1284         require(_to != address(0));
1285         require(_value <= balances[CoinStorage]);
1286         // check that sold tokens + purchase value + totalLocked is less than the saleCap
1287         require(totalSupply - balances[CoinStorage] + _value + totalLocked <= saleCap);
1288         // check that user's locked tokens + purchase value is less than the purchase limit
1289         require(buyLimitPerAddress[_to] + lockedTokens[_to] + _value <= buyLimit); 
1290 
1291         // SafeMath.sub will throw if there is not enough balance.
1292         balances[CoinStorage] = balances[CoinStorage].sub(_value);
1293         balances[_to] = balances[_to].add(_value);
1294         //===================================================================
1295         buyLimitPerAddress[_to] = buyLimitPerAddress[_to].add(_value);
1296         //===================================================================
1297         Transfer(CoinStorage, _to, _value);
1298         return true;
1299     }
1300 
1301     // Add to totalLocked
1302     // Substract from owner's balance
1303     // Init mapping.
1304     function lock(address _to, uint256 _value) onlyOwner public {
1305         require(_to != address(0));
1306         require(_value <= balances[CoinStorage]);
1307         // check that sold tokens + purchase value + totalLocked is less than the saleCap
1308         require(totalSupply - balances[CoinStorage] + _value + totalLocked <= saleCap);
1309         // check that user's locked tokens + purchase value is less than the purchase limit
1310         require(buyLimitPerAddress[_to] + lockedTokens[_to] + _value <= buyLimit);
1311         
1312         totalLocked = totalLocked + _value;
1313         balances[CoinStorage] = balances[CoinStorage].sub(_value);
1314         lockedTokens[_to] = _value;
1315     }
1316 
1317     // Unlock tokens
1318     // Transfer tokens
1319     function pay(address _to, uint256 _value) onlyOwner public {
1320         unlock(_to);
1321         privateTransfer(_to, _value);
1322     }
1323 
1324     // Substract from totalLocked
1325     // Add the locked tokens to the owner's balance
1326     // Delete mapping element
1327     function unlock(address _to) onlyOwner public {
1328         require(_to != address(0));
1329         require(lockedTokens[_to] > 0);
1330 
1331         totalLocked = totalLocked.sub(lockedTokens[_to]);
1332         balances[CoinStorage] = balances[CoinStorage].add(lockedTokens[_to]);
1333         delete lockedTokens[_to];
1334     }
1335 
1336 
1337     //==========================================================
1338     // EXTERNAL FUNCTIONS
1339     //==========================================================
1340     function switchSaleStage() onlyOwner public {
1341         require(!isSecondRound);
1342 
1343         if (!isPreSale) {
1344             isPreSale = true;
1345             tokenPriceInCents = 34;
1346             buyLimit = 5000 * 10 ** decimals;
1347             saleCap = 2178309 * 10 ** decimals;
1348         } else if (!isFirstRound) {
1349             isFirstRound = true;
1350             tokenPriceInCents = 55;
1351             buyLimit = buyLimit + 10000 * 10 ** decimals;
1352             saleCap = totalSupply - balances[CoinStorage] + 3524578 * 10 ** decimals;
1353         } else if (!isSecondRound) {
1354             isSecondRound = true;
1355             tokenPriceInCents = 89;
1356             buyLimit = buyLimit + 15000 * 10**decimals;
1357             saleCap = totalSupply - balances[CoinStorage] + 5702887 * 10 ** decimals;
1358         } 
1359 
1360         startDate = now + 1 minutes;
1361         endDate = startDate + 120 hours;
1362     }
1363     
1364     /**
1365      * @dev Burns a specific amount of tokens.
1366      * @param _value The amount of token to be burned.
1367      */
1368     function burn(uint256 _value) public {
1369         require(_value > 0);
1370         require(_value <= balances[msg.sender]);
1371         // no need to require value <= totalSupply, since that would imply the
1372         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1373 
1374         address burner = msg.sender;
1375         balances[burner] = balances[burner].sub(_value);
1376         totalSupply = totalSupply.sub(_value);
1377         burnedTokens = burnedTokens.add(_value);
1378         Burn(burner, _value);
1379     }
1380 }