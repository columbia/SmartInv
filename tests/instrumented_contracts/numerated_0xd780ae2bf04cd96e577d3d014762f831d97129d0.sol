1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Safe math operations that throw error on overflow.
5  *
6  * Credit: Taking ideas from FirstBlood token
7  */
8 library SafeMath {
9 
10     /** 
11      * @dev Safely add two numbers.
12      *
13      * @param x First operant.
14      * @param y Second operant.
15      * @return The result of x+y.
16      */
17     function add(uint256 x, uint256 y)
18     internal constant
19     returns(uint256) {
20         uint256 z = x + y;
21         assert((z >= x) && (z >= y));
22         return z;
23     }
24 
25     /** 
26      * @dev Safely substract two numbers.
27      *
28      * @param x First operant.
29      * @param y Second operant.
30      * @return The result of x-y.
31      */
32     function sub(uint256 x, uint256 y)
33     internal constant
34     returns(uint256) {
35         assert(x >= y);
36         uint256 z = x - y;
37         return z;
38     }
39 
40     /** 
41      * @dev Safely multiply two numbers.
42      *
43      * @param x First operant.
44      * @param y Second operant.
45      * @return The result of x*y.
46      */
47     function mul(uint256 x, uint256 y)
48     internal constant
49     returns(uint256) {
50         uint256 z = x * y;
51         assert((x == 0) || (z/x == y));
52         return z;
53     }
54 
55     /**
56     * @dev Parse a floating point number from String to uint, e.g. "250.56" to "25056"
57      */
58     function parse(string s) 
59     internal constant 
60     returns (uint256) 
61     {
62     bytes memory b = bytes(s);
63     uint result = 0;
64     for (uint i = 0; i < b.length; i++) {
65         if (b[i] >= 48 && b[i] <= 57) {
66             result = result * 10 + (uint(b[i]) - 48); 
67         }
68     }
69     return result; 
70 }
71 }
72 
73 /**
74  * @title The abstract ERC-20 Token Standard definition.
75  *
76  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
77  */
78 contract Token {
79     /// @dev Returns the total token supply.
80     uint256 public totalSupply;
81 
82     function balanceOf(address _owner) public constant returns (uint256 balance);
83     function transfer(address _to, uint256 _value) public returns (bool success);
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
85     function approve(address _spender, uint256 _value) public returns (bool success);
86     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
87 
88     /// @dev MUST trigger when tokens are transferred, including zero value transfers.
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90 
91     /// @dev MUST trigger on any successful call to approve(address _spender, uint256 _value).
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 }
94 
95 /**
96  * @title Default implementation of the ERC-20 Token Standard.
97  */
98 contract StandardToken is Token {
99 
100     mapping (address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102 
103     modifier onlyPayloadSize(uint numwords) {
104         assert(msg.data.length == numwords * 32 + 4);
105         _;
106     }
107 
108     /**
109      * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. 
110      * @dev The function SHOULD throw if the _from account balance does not have enough tokens to spend.
111      *
112      * @dev A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created.
113      *
114      * Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
115      *
116      * @param _to The receiver of the tokens.
117      * @param _value The amount of tokens to send.
118      * @return True on success, false otherwise.
119      */
120     function transfer(address _to, uint256 _value)
121     public
122     returns (bool success) {
123         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
124             balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
125             balances[_to] = SafeMath.add(balances[_to], _value);
126             Transfer(msg.sender, _to, _value);
127             return true;
128         } else {
129             return false;
130         }
131     }
132 
133     /**
134      * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.
135      *
136      * @dev The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf. 
137      * @dev This can be used for example to allow a contract to transfer tokens on your behalf and/or to charge fees in 
138      * @dev sub-currencies. The function SHOULD throw unless the _from account has deliberately authorized the sender of 
139      * @dev the message via some mechanism.
140      *
141      * Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
142      *
143      * @param _from The sender of the tokens.
144      * @param _to The receiver of the tokens.
145      * @param _value The amount of tokens to send.
146      * @return True on success, false otherwise.
147      */
148     function transferFrom(address _from, address _to, uint256 _value)
149     public
150     returns (bool success) {
151         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
152             balances[_to] = SafeMath.add(balances[_to], _value);
153             balances[_from] = SafeMath.sub(balances[_from], _value);
154             allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
155             Transfer(_from, _to, _value);
156             return true;
157         } else {
158             return false;
159         }
160     }
161 
162     /**
163      * @dev Returns the account balance of another account with address _owner.
164      *
165      * @param _owner The address of the account to check.
166      * @return The account balance.
167      */
168     function balanceOf(address _owner)
169     public constant
170     returns (uint256 balance) {
171         return balances[_owner];
172     }
173 
174     /**
175      * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. 
176      * @dev If this function is called again it overwrites the current allowance with _value.
177      *
178      * @dev NOTE: To prevent attack vectors like the one described in [1] and discussed in [2], clients 
179      * @dev SHOULD make sure to create user interfaces in such a way that they set the allowance first 
180      * @dev to 0 before setting it to another value for the same spender. THOUGH The contract itself 
181      * @dev shouldn't enforce it, to allow backwards compatilibilty with contracts deployed before.
182      * @dev [1] https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/
183      * @dev [2] https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184      *
185      * @param _spender The address which will spend the funds.
186      * @param _value The amount of tokens to be spent.
187      * @return True on success, false otherwise.
188      */
189     function approve(address _spender, uint256 _value)
190     public
191     onlyPayloadSize(2)
192     returns (bool success) {
193         allowed[msg.sender][_spender] = _value;
194         Approval(msg.sender, _spender, _value);
195         return true;
196     }
197 
198     /**
199      * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
200      *
201      * @param _owner The address of the sender.
202      * @param _spender The address of the receiver.
203      * @return The allowed withdrawal amount.
204      */
205     function allowance(address _owner, address _spender)
206     public constant
207     onlyPayloadSize(2)
208     returns (uint256 remaining) {
209         return allowed[_owner][_spender];
210     }
211 }
212 
213 
214 // <ORACLIZE_API>
215 /*
216 Copyright (c) 2015-2016 Oraclize SRL
217 Copyright (c) 2016 Oraclize LTD
218 
219 
220 
221 Permission is hereby granted, free of charge, to any person obtaining a copy
222 of this software and associated documentation files (the "Software"), to deal
223 in the Software without restriction, including without limitation the rights
224 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
225 copies of the Software, and to permit persons to whom the Software is
226 furnished to do so, subject to the following conditions:
227 
228 
229 
230 The above copyright notice and this permission notice shall be included in
231 all copies or substantial portions of the Software.
232 
233 
234 
235 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
236 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
237 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
238 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
239 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
240 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
241 THE SOFTWARE.
242 */
243 
244 contract OraclizeI {
245     address public cbAddress;
246     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
247     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
248     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
249     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
250     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
251     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
252     function getPrice(string _datasource) returns (uint _dsprice);
253     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
254     function useCoupon(string _coupon);
255     function setProofType(byte _proofType);
256     function setConfig(bytes32 _config);
257     function setCustomGasPrice(uint _gasPrice);
258     function randomDS_getSessionPubKeyHash() returns(bytes32);
259 }
260 contract OraclizeAddrResolverI {
261     function getAddress() returns (address _addr);
262 }
263 contract usingOraclize {
264     uint constant day = 60*60*24;
265     uint constant week = 60*60*24*7;
266     uint constant month = 60*60*24*30;
267     byte constant proofType_NONE = 0x00;
268     byte constant proofType_TLSNotary = 0x10;
269     byte constant proofType_Android = 0x20;
270     byte constant proofType_Ledger = 0x30;
271     byte constant proofType_Native = 0xF0;
272     byte constant proofStorage_IPFS = 0x01;
273     uint8 constant networkID_auto = 0;
274     uint8 constant networkID_mainnet = 1;
275     uint8 constant networkID_testnet = 2;
276     uint8 constant networkID_morden = 2;
277     uint8 constant networkID_consensys = 161;
278 
279     OraclizeAddrResolverI OAR;
280 
281     OraclizeI oraclize;
282     modifier oraclizeAPI {
283         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
284         oraclize = OraclizeI(OAR.getAddress());
285         _;
286     }
287     modifier coupon(string code){
288         oraclize = OraclizeI(OAR.getAddress());
289         oraclize.useCoupon(code);
290         _;
291     }
292 
293     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
294         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
295             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
296             oraclize_setNetworkName("eth_mainnet");
297             return true;
298         }
299         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
300             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
301             oraclize_setNetworkName("eth_ropsten3");
302             return true;
303         }
304         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
305             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
306             oraclize_setNetworkName("eth_kovan");
307             return true;
308         }
309         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
310             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
311             oraclize_setNetworkName("eth_rinkeby");
312             return true;
313         }
314         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
315             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
316             return true;
317         }
318         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
319             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
320             return true;
321         }
322         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
323             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
324             return true;
325         }
326         return false;
327     }
328 
329     function __callback(bytes32 myid, string result) {
330         __callback(myid, result, new bytes(0));
331     }
332     function __callback(bytes32 myid, string result, bytes proof) {
333     }
334     
335     function oraclize_useCoupon(string code) oraclizeAPI internal {
336         oraclize.useCoupon(code);
337     }
338 
339     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
340         return oraclize.getPrice(datasource);
341     }
342 
343     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
344         return oraclize.getPrice(datasource, gaslimit);
345     }
346     
347     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
348         uint price = oraclize.getPrice(datasource);
349         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
350         return oraclize.query.value(price)(0, datasource, arg);
351     }
352     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
353         uint price = oraclize.getPrice(datasource);
354         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
355         return oraclize.query.value(price)(timestamp, datasource, arg);
356     }
357     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
358         uint price = oraclize.getPrice(datasource, gaslimit);
359         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
360         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
361     }
362     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
363         uint price = oraclize.getPrice(datasource, gaslimit);
364         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
365         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
366     }
367     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
368         uint price = oraclize.getPrice(datasource);
369         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
370         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
371     }
372     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
373         uint price = oraclize.getPrice(datasource);
374         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
375         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
376     }
377     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
378         uint price = oraclize.getPrice(datasource, gaslimit);
379         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
380         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
381     }
382     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
383         uint price = oraclize.getPrice(datasource, gaslimit);
384         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
385         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
386     }
387     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
388         uint price = oraclize.getPrice(datasource);
389         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
390         bytes memory args = stra2cbor(argN);
391         return oraclize.queryN.value(price)(0, datasource, args);
392     }
393     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
394         uint price = oraclize.getPrice(datasource);
395         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
396         bytes memory args = stra2cbor(argN);
397         return oraclize.queryN.value(price)(timestamp, datasource, args);
398     }
399     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
400         uint price = oraclize.getPrice(datasource, gaslimit);
401         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
402         bytes memory args = stra2cbor(argN);
403         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
404     }
405     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
406         uint price = oraclize.getPrice(datasource, gaslimit);
407         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
408         bytes memory args = stra2cbor(argN);
409         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
410     }
411     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
412         string[] memory dynargs = new string[](1);
413         dynargs[0] = args[0];
414         return oraclize_query(datasource, dynargs);
415     }
416     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
417         string[] memory dynargs = new string[](1);
418         dynargs[0] = args[0];
419         return oraclize_query(timestamp, datasource, dynargs);
420     }
421     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
422         string[] memory dynargs = new string[](1);
423         dynargs[0] = args[0];
424         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
425     }
426     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
427         string[] memory dynargs = new string[](1);
428         dynargs[0] = args[0];       
429         return oraclize_query(datasource, dynargs, gaslimit);
430     }
431     
432     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
433         string[] memory dynargs = new string[](2);
434         dynargs[0] = args[0];
435         dynargs[1] = args[1];
436         return oraclize_query(datasource, dynargs);
437     }
438     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
439         string[] memory dynargs = new string[](2);
440         dynargs[0] = args[0];
441         dynargs[1] = args[1];
442         return oraclize_query(timestamp, datasource, dynargs);
443     }
444     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
445         string[] memory dynargs = new string[](2);
446         dynargs[0] = args[0];
447         dynargs[1] = args[1];
448         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
449     }
450     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
451         string[] memory dynargs = new string[](2);
452         dynargs[0] = args[0];
453         dynargs[1] = args[1];
454         return oraclize_query(datasource, dynargs, gaslimit);
455     }
456     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
457         string[] memory dynargs = new string[](3);
458         dynargs[0] = args[0];
459         dynargs[1] = args[1];
460         dynargs[2] = args[2];
461         return oraclize_query(datasource, dynargs);
462     }
463     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
464         string[] memory dynargs = new string[](3);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         dynargs[2] = args[2];
468         return oraclize_query(timestamp, datasource, dynargs);
469     }
470     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
471         string[] memory dynargs = new string[](3);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         dynargs[2] = args[2];
475         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
476     }
477     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
478         string[] memory dynargs = new string[](3);
479         dynargs[0] = args[0];
480         dynargs[1] = args[1];
481         dynargs[2] = args[2];
482         return oraclize_query(datasource, dynargs, gaslimit);
483     }
484     
485     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
486         string[] memory dynargs = new string[](4);
487         dynargs[0] = args[0];
488         dynargs[1] = args[1];
489         dynargs[2] = args[2];
490         dynargs[3] = args[3];
491         return oraclize_query(datasource, dynargs);
492     }
493     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
494         string[] memory dynargs = new string[](4);
495         dynargs[0] = args[0];
496         dynargs[1] = args[1];
497         dynargs[2] = args[2];
498         dynargs[3] = args[3];
499         return oraclize_query(timestamp, datasource, dynargs);
500     }
501     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
502         string[] memory dynargs = new string[](4);
503         dynargs[0] = args[0];
504         dynargs[1] = args[1];
505         dynargs[2] = args[2];
506         dynargs[3] = args[3];
507         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
508     }
509     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
510         string[] memory dynargs = new string[](4);
511         dynargs[0] = args[0];
512         dynargs[1] = args[1];
513         dynargs[2] = args[2];
514         dynargs[3] = args[3];
515         return oraclize_query(datasource, dynargs, gaslimit);
516     }
517     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
518         string[] memory dynargs = new string[](5);
519         dynargs[0] = args[0];
520         dynargs[1] = args[1];
521         dynargs[2] = args[2];
522         dynargs[3] = args[3];
523         dynargs[4] = args[4];
524         return oraclize_query(datasource, dynargs);
525     }
526     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
527         string[] memory dynargs = new string[](5);
528         dynargs[0] = args[0];
529         dynargs[1] = args[1];
530         dynargs[2] = args[2];
531         dynargs[3] = args[3];
532         dynargs[4] = args[4];
533         return oraclize_query(timestamp, datasource, dynargs);
534     }
535     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
536         string[] memory dynargs = new string[](5);
537         dynargs[0] = args[0];
538         dynargs[1] = args[1];
539         dynargs[2] = args[2];
540         dynargs[3] = args[3];
541         dynargs[4] = args[4];
542         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
543     }
544     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
545         string[] memory dynargs = new string[](5);
546         dynargs[0] = args[0];
547         dynargs[1] = args[1];
548         dynargs[2] = args[2];
549         dynargs[3] = args[3];
550         dynargs[4] = args[4];
551         return oraclize_query(datasource, dynargs, gaslimit);
552     }
553     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
554         uint price = oraclize.getPrice(datasource);
555         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
556         bytes memory args = ba2cbor(argN);
557         return oraclize.queryN.value(price)(0, datasource, args);
558     }
559     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
560         uint price = oraclize.getPrice(datasource);
561         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
562         bytes memory args = ba2cbor(argN);
563         return oraclize.queryN.value(price)(timestamp, datasource, args);
564     }
565     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
566         uint price = oraclize.getPrice(datasource, gaslimit);
567         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
568         bytes memory args = ba2cbor(argN);
569         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
570     }
571     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
572         uint price = oraclize.getPrice(datasource, gaslimit);
573         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
574         bytes memory args = ba2cbor(argN);
575         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
576     }
577     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
578         bytes[] memory dynargs = new bytes[](1);
579         dynargs[0] = args[0];
580         return oraclize_query(datasource, dynargs);
581     }
582     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
583         bytes[] memory dynargs = new bytes[](1);
584         dynargs[0] = args[0];
585         return oraclize_query(timestamp, datasource, dynargs);
586     }
587     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
588         bytes[] memory dynargs = new bytes[](1);
589         dynargs[0] = args[0];
590         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
591     }
592     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
593         bytes[] memory dynargs = new bytes[](1);
594         dynargs[0] = args[0];       
595         return oraclize_query(datasource, dynargs, gaslimit);
596     }
597     
598     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
599         bytes[] memory dynargs = new bytes[](2);
600         dynargs[0] = args[0];
601         dynargs[1] = args[1];
602         return oraclize_query(datasource, dynargs);
603     }
604     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
605         bytes[] memory dynargs = new bytes[](2);
606         dynargs[0] = args[0];
607         dynargs[1] = args[1];
608         return oraclize_query(timestamp, datasource, dynargs);
609     }
610     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
611         bytes[] memory dynargs = new bytes[](2);
612         dynargs[0] = args[0];
613         dynargs[1] = args[1];
614         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
615     }
616     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
617         bytes[] memory dynargs = new bytes[](2);
618         dynargs[0] = args[0];
619         dynargs[1] = args[1];
620         return oraclize_query(datasource, dynargs, gaslimit);
621     }
622     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
623         bytes[] memory dynargs = new bytes[](3);
624         dynargs[0] = args[0];
625         dynargs[1] = args[1];
626         dynargs[2] = args[2];
627         return oraclize_query(datasource, dynargs);
628     }
629     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
630         bytes[] memory dynargs = new bytes[](3);
631         dynargs[0] = args[0];
632         dynargs[1] = args[1];
633         dynargs[2] = args[2];
634         return oraclize_query(timestamp, datasource, dynargs);
635     }
636     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
637         bytes[] memory dynargs = new bytes[](3);
638         dynargs[0] = args[0];
639         dynargs[1] = args[1];
640         dynargs[2] = args[2];
641         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
642     }
643     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
644         bytes[] memory dynargs = new bytes[](3);
645         dynargs[0] = args[0];
646         dynargs[1] = args[1];
647         dynargs[2] = args[2];
648         return oraclize_query(datasource, dynargs, gaslimit);
649     }
650     
651     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
652         bytes[] memory dynargs = new bytes[](4);
653         dynargs[0] = args[0];
654         dynargs[1] = args[1];
655         dynargs[2] = args[2];
656         dynargs[3] = args[3];
657         return oraclize_query(datasource, dynargs);
658     }
659     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
660         bytes[] memory dynargs = new bytes[](4);
661         dynargs[0] = args[0];
662         dynargs[1] = args[1];
663         dynargs[2] = args[2];
664         dynargs[3] = args[3];
665         return oraclize_query(timestamp, datasource, dynargs);
666     }
667     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
668         bytes[] memory dynargs = new bytes[](4);
669         dynargs[0] = args[0];
670         dynargs[1] = args[1];
671         dynargs[2] = args[2];
672         dynargs[3] = args[3];
673         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
674     }
675     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
676         bytes[] memory dynargs = new bytes[](4);
677         dynargs[0] = args[0];
678         dynargs[1] = args[1];
679         dynargs[2] = args[2];
680         dynargs[3] = args[3];
681         return oraclize_query(datasource, dynargs, gaslimit);
682     }
683     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
684         bytes[] memory dynargs = new bytes[](5);
685         dynargs[0] = args[0];
686         dynargs[1] = args[1];
687         dynargs[2] = args[2];
688         dynargs[3] = args[3];
689         dynargs[4] = args[4];
690         return oraclize_query(datasource, dynargs);
691     }
692     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
693         bytes[] memory dynargs = new bytes[](5);
694         dynargs[0] = args[0];
695         dynargs[1] = args[1];
696         dynargs[2] = args[2];
697         dynargs[3] = args[3];
698         dynargs[4] = args[4];
699         return oraclize_query(timestamp, datasource, dynargs);
700     }
701     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
702         bytes[] memory dynargs = new bytes[](5);
703         dynargs[0] = args[0];
704         dynargs[1] = args[1];
705         dynargs[2] = args[2];
706         dynargs[3] = args[3];
707         dynargs[4] = args[4];
708         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
709     }
710     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
711         bytes[] memory dynargs = new bytes[](5);
712         dynargs[0] = args[0];
713         dynargs[1] = args[1];
714         dynargs[2] = args[2];
715         dynargs[3] = args[3];
716         dynargs[4] = args[4];
717         return oraclize_query(datasource, dynargs, gaslimit);
718     }
719 
720     function oraclize_cbAddress() oraclizeAPI internal returns (address){
721         return oraclize.cbAddress();
722     }
723     function oraclize_setProof(byte proofP) oraclizeAPI internal {
724         return oraclize.setProofType(proofP);
725     }
726     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
727         return oraclize.setCustomGasPrice(gasPrice);
728     }
729     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
730         return oraclize.setConfig(config);
731     }
732     
733     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
734         return oraclize.randomDS_getSessionPubKeyHash();
735     }
736 
737     function getCodeSize(address _addr) constant internal returns(uint _size) {
738         assembly {
739             _size := extcodesize(_addr)
740         }
741     }
742 
743     function parseAddr(string _a) internal returns (address){
744         bytes memory tmp = bytes(_a);
745         uint160 iaddr = 0;
746         uint160 b1;
747         uint160 b2;
748         for (uint i=2; i<2+2*20; i+=2){
749             iaddr *= 256;
750             b1 = uint160(tmp[i]);
751             b2 = uint160(tmp[i+1]);
752             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
753             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
754             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
755             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
756             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
757             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
758             iaddr += (b1*16+b2);
759         }
760         return address(iaddr);
761     }
762 
763     function strCompare(string _a, string _b) internal returns (int) {
764         bytes memory a = bytes(_a);
765         bytes memory b = bytes(_b);
766         uint minLength = a.length;
767         if (b.length < minLength) minLength = b.length;
768         for (uint i = 0; i < minLength; i ++)
769             if (a[i] < b[i])
770                 return -1;
771             else if (a[i] > b[i])
772                 return 1;
773         if (a.length < b.length)
774             return -1;
775         else if (a.length > b.length)
776             return 1;
777         else
778             return 0;
779     }
780 
781     function indexOf(string _haystack, string _needle) internal returns (int) {
782         bytes memory h = bytes(_haystack);
783         bytes memory n = bytes(_needle);
784         if(h.length < 1 || n.length < 1 || (n.length > h.length))
785             return -1;
786         else if(h.length > (2**128 -1))
787             return -1;
788         else
789         {
790             uint subindex = 0;
791             for (uint i = 0; i < h.length; i ++)
792             {
793                 if (h[i] == n[0])
794                 {
795                     subindex = 1;
796                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
797                     {
798                         subindex++;
799                     }
800                     if(subindex == n.length)
801                         return int(i);
802                 }
803             }
804             return -1;
805         }
806     }
807 
808     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
809         bytes memory _ba = bytes(_a);
810         bytes memory _bb = bytes(_b);
811         bytes memory _bc = bytes(_c);
812         bytes memory _bd = bytes(_d);
813         bytes memory _be = bytes(_e);
814         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
815         bytes memory babcde = bytes(abcde);
816         uint k = 0;
817         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
818         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
819         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
820         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
821         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
822         return string(babcde);
823     }
824 
825     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
826         return strConcat(_a, _b, _c, _d, "");
827     }
828 
829     function strConcat(string _a, string _b, string _c) internal returns (string) {
830         return strConcat(_a, _b, _c, "", "");
831     }
832 
833     function strConcat(string _a, string _b) internal returns (string) {
834         return strConcat(_a, _b, "", "", "");
835     }
836 
837     // parseInt
838     function parseInt(string _a) internal returns (uint) {
839         return parseInt(_a, 0);
840     }
841 
842     // parseInt(parseFloat*10^_b)
843     function parseInt(string _a, uint _b) internal returns (uint) {
844         bytes memory bresult = bytes(_a);
845         uint mint = 0;
846         bool decimals = false;
847         for (uint i=0; i<bresult.length; i++){
848             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
849                 if (decimals){
850                    if (_b == 0) break;
851                     else _b--;
852                 }
853                 mint *= 10;
854                 mint += uint(bresult[i]) - 48;
855             } else if (bresult[i] == 46) decimals = true;
856         }
857         if (_b > 0) mint *= 10**_b;
858         return mint;
859     }
860 
861     function uint2str(uint i) internal returns (string){
862         if (i == 0) return "0";
863         uint j = i;
864         uint len;
865         while (j != 0){
866             len++;
867             j /= 10;
868         }
869         bytes memory bstr = new bytes(len);
870         uint k = len - 1;
871         while (i != 0){
872             bstr[k--] = byte(48 + i % 10);
873             i /= 10;
874         }
875         return string(bstr);
876     }
877     
878     function stra2cbor(string[] arr) internal returns (bytes) {
879             uint arrlen = arr.length;
880 
881             // get correct cbor output length
882             uint outputlen = 0;
883             bytes[] memory elemArray = new bytes[](arrlen);
884             for (uint i = 0; i < arrlen; i++) {
885                 elemArray[i] = (bytes(arr[i]));
886                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
887             }
888             uint ctr = 0;
889             uint cborlen = arrlen + 0x80;
890             outputlen += byte(cborlen).length;
891             bytes memory res = new bytes(outputlen);
892 
893             while (byte(cborlen).length > ctr) {
894                 res[ctr] = byte(cborlen)[ctr];
895                 ctr++;
896             }
897             for (i = 0; i < arrlen; i++) {
898                 res[ctr] = 0x5F;
899                 ctr++;
900                 for (uint x = 0; x < elemArray[i].length; x++) {
901                     // if there's a bug with larger strings, this may be the culprit
902                     if (x % 23 == 0) {
903                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
904                         elemcborlen += 0x40;
905                         uint lctr = ctr;
906                         while (byte(elemcborlen).length > ctr - lctr) {
907                             res[ctr] = byte(elemcborlen)[ctr - lctr];
908                             ctr++;
909                         }
910                     }
911                     res[ctr] = elemArray[i][x];
912                     ctr++;
913                 }
914                 res[ctr] = 0xFF;
915                 ctr++;
916             }
917             return res;
918         }
919 
920     function ba2cbor(bytes[] arr) internal returns (bytes) {
921             uint arrlen = arr.length;
922 
923             // get correct cbor output length
924             uint outputlen = 0;
925             bytes[] memory elemArray = new bytes[](arrlen);
926             for (uint i = 0; i < arrlen; i++) {
927                 elemArray[i] = (bytes(arr[i]));
928                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
929             }
930             uint ctr = 0;
931             uint cborlen = arrlen + 0x80;
932             outputlen += byte(cborlen).length;
933             bytes memory res = new bytes(outputlen);
934 
935             while (byte(cborlen).length > ctr) {
936                 res[ctr] = byte(cborlen)[ctr];
937                 ctr++;
938             }
939             for (i = 0; i < arrlen; i++) {
940                 res[ctr] = 0x5F;
941                 ctr++;
942                 for (uint x = 0; x < elemArray[i].length; x++) {
943                     // if there's a bug with larger strings, this may be the culprit
944                     if (x % 23 == 0) {
945                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
946                         elemcborlen += 0x40;
947                         uint lctr = ctr;
948                         while (byte(elemcborlen).length > ctr - lctr) {
949                             res[ctr] = byte(elemcborlen)[ctr - lctr];
950                             ctr++;
951                         }
952                     }
953                     res[ctr] = elemArray[i][x];
954                     ctr++;
955                 }
956                 res[ctr] = 0xFF;
957                 ctr++;
958             }
959             return res;
960         }
961         
962         
963     string oraclize_network_name;
964     function oraclize_setNetworkName(string _network_name) internal {
965         oraclize_network_name = _network_name;
966     }
967     
968     function oraclize_getNetworkName() internal returns (string) {
969         return oraclize_network_name;
970     }
971     
972     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
973         if ((_nbytes == 0)||(_nbytes > 32)) throw;
974         bytes memory nbytes = new bytes(1);
975         nbytes[0] = byte(_nbytes);
976         bytes memory unonce = new bytes(32);
977         bytes memory sessionKeyHash = new bytes(32);
978         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
979         assembly {
980             mstore(unonce, 0x20)
981             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
982             mstore(sessionKeyHash, 0x20)
983             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
984         }
985         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
986         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
987         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
988         return queryId;
989     }
990     
991     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
992         oraclize_randomDS_args[queryId] = commitment;
993     }
994     
995     mapping(bytes32=>bytes32) oraclize_randomDS_args;
996     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
997 
998     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
999         bool sigok;
1000         address signer;
1001         
1002         bytes32 sigr;
1003         bytes32 sigs;
1004         
1005         bytes memory sigr_ = new bytes(32);
1006         uint offset = 4+(uint(dersig[3]) - 0x20);
1007         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1008         bytes memory sigs_ = new bytes(32);
1009         offset += 32 + 2;
1010         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1011 
1012         assembly {
1013             sigr := mload(add(sigr_, 32))
1014             sigs := mload(add(sigs_, 32))
1015         }
1016         
1017         
1018         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1019         if (address(sha3(pubkey)) == signer) return true;
1020         else {
1021             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1022             return (address(sha3(pubkey)) == signer);
1023         }
1024     }
1025 
1026     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1027         bool sigok;
1028         
1029         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1030         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1031         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1032         
1033         bytes memory appkey1_pubkey = new bytes(64);
1034         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1035         
1036         bytes memory tosign2 = new bytes(1+65+32);
1037         tosign2[0] = 1; //role
1038         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1039         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1040         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1041         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1042         
1043         if (sigok == false) return false;
1044         
1045         
1046         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1047         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1048         
1049         bytes memory tosign3 = new bytes(1+65);
1050         tosign3[0] = 0xFE;
1051         copyBytes(proof, 3, 65, tosign3, 1);
1052         
1053         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1054         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1055         
1056         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1057         
1058         return sigok;
1059     }
1060     
1061     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1062         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1063         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1064         
1065         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1066         if (proofVerified == false) throw;
1067         
1068         _;
1069     }
1070     
1071     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
1072         bool match_ = true;
1073         
1074         for (var i=0; i<prefix.length; i++){
1075             if (content[i] != prefix[i]) match_ = false;
1076         }
1077         
1078         return match_;
1079     }
1080 
1081     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1082         bool checkok;
1083         
1084         
1085         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1086         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1087         bytes memory keyhash = new bytes(32);
1088         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1089         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
1090         if (checkok == false) return false;
1091         
1092         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1093         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1094         
1095         
1096         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1097         checkok = matchBytes32Prefix(sha256(sig1), result);
1098         if (checkok == false) return false;
1099         
1100         
1101         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1102         // This is to verify that the computed args match with the ones specified in the query.
1103         bytes memory commitmentSlice1 = new bytes(8+1+32);
1104         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1105         
1106         bytes memory sessionPubkey = new bytes(64);
1107         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1108         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1109         
1110         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1111         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1112             delete oraclize_randomDS_args[queryId];
1113         } else return false;
1114         
1115         
1116         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1117         bytes memory tosign1 = new bytes(32+8+1+32);
1118         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1119         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
1120         if (checkok == false) return false;
1121         
1122         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1123         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1124             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1125         }
1126         
1127         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1128     }
1129 
1130     
1131     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1132     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1133         uint minLength = length + toOffset;
1134 
1135         if (to.length < minLength) {
1136             // Buffer too small
1137             throw; // Should be a better way?
1138         }
1139 
1140         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1141         uint i = 32 + fromOffset;
1142         uint j = 32 + toOffset;
1143 
1144         while (i < (32 + fromOffset + length)) {
1145             assembly {
1146                 let tmp := mload(add(from, i))
1147                 mstore(add(to, j), tmp)
1148             }
1149             i += 32;
1150             j += 32;
1151         }
1152 
1153         return to;
1154     }
1155     
1156     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1157     // Duplicate Solidity's ecrecover, but catching the CALL return value
1158     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1159         // We do our own memory management here. Solidity uses memory offset
1160         // 0x40 to store the current end of memory. We write past it (as
1161         // writes are memory extensions), but don't update the offset so
1162         // Solidity will reuse it. The memory used here is only needed for
1163         // this context.
1164 
1165         // FIXME: inline assembly can't access return values
1166         bool ret;
1167         address addr;
1168 
1169         assembly {
1170             let size := mload(0x40)
1171             mstore(size, hash)
1172             mstore(add(size, 32), v)
1173             mstore(add(size, 64), r)
1174             mstore(add(size, 96), s)
1175 
1176             // NOTE: we can reuse the request memory because we deal with
1177             //       the return code
1178             ret := call(3000, 1, 0, size, 128, size, 32)
1179             addr := mload(size)
1180         }
1181   
1182         return (ret, addr);
1183     }
1184 
1185     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1186     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1187         bytes32 r;
1188         bytes32 s;
1189         uint8 v;
1190 
1191         if (sig.length != 65)
1192           return (false, 0);
1193 
1194         // The signature format is a compact form of:
1195         //   {bytes32 r}{bytes32 s}{uint8 v}
1196         // Compact means, uint8 is not padded to 32 bytes.
1197         assembly {
1198             r := mload(add(sig, 32))
1199             s := mload(add(sig, 64))
1200 
1201             // Here we are loading the last 32 bytes. We exploit the fact that
1202             // 'mload' will pad with zeroes if we overread.
1203             // There is no 'mload8' to do this, but that would be nicer.
1204             v := byte(0, mload(add(sig, 96)))
1205 
1206             // Alternative solution:
1207             // 'byte' is not working due to the Solidity parser, so lets
1208             // use the second best option, 'and'
1209             // v := and(mload(add(sig, 65)), 255)
1210         }
1211 
1212         // albeit non-transactional signatures are not specified by the YP, one would expect it
1213         // to match the YP range of [27, 28]
1214         //
1215         // geth uses [0, 1] and some clients have followed. This might change, see:
1216         //  https://github.com/ethereum/go-ethereum/issues/2053
1217         if (v < 27)
1218           v += 27;
1219 
1220         if (v != 27 && v != 28)
1221             return (false, 0);
1222 
1223         return safer_ecrecover(hash, v, r, s);
1224     }
1225         
1226 }
1227 // </ORACLIZE_API>
1228 
1229 
1230 /**
1231  * @title The EVNToken Token contract.
1232  *
1233  * Credit: Taking ideas from BAT token and NET token
1234  */
1235  /*is StandardToken */
1236 contract EVNToken is StandardToken, usingOraclize {
1237 
1238     // Token metadata
1239     string public constant name = "Envion";
1240     string public constant symbol = "EVN";
1241     uint256 public constant decimals = 18;
1242     string public constant version = "0.9";
1243 
1244     // Fundraising goals: minimums and maximums
1245     uint256 public constant TOKEN_CREATION_CAP = 130 * (10**6) * 10**decimals; // 130 million EVNs
1246     uint256 public constant TOKEN_CREATED_MIN = 1 * (10**6) * 10**decimals;    // 1 million EVNs
1247     uint256 public constant ETH_RECEIVED_CAP = 5333 * (10**2) * 10**decimals;  // 533 300 ETH
1248     uint256 public constant ETH_RECEIVED_MIN = 1 * (10**3) * 10**decimals;     // 1 000 ETH
1249     uint256 public constant TOKEN_MIN = 1 * 10**decimals;                      // 1 EVN
1250 
1251     // Discount multipliers
1252     uint256 public constant TOKEN_FIRST_DISCOUNT_MULTIPLIER  = 142857; // later divided by 10^5 to give users 1,42857 times more tokens per ETH == 30% discount
1253     uint256 public constant TOKEN_SECOND_DISCOUNT_MULTIPLIER = 125000; // later divided by 10^5 to give users 1,25 more tokens per ETH == 20% discount
1254     uint256 public constant TOKEN_THIRD_DISCOUNT_MULTIPLIER  = 111111; // later divided by 10^5 to give users 1,11111 more tokens per ETH == 10% discount
1255 
1256     // Fundraising parameters provided when creating the contract
1257     uint256 public fundingStartBlock; // These two blocks need to be chosen to comply with the
1258     uint256 public fundingEndBlock;   // start date and 31 day duration requirements
1259     uint256 public roundTwoBlock;     // block number that triggers the second exchange rate change
1260     uint256 public roundThreeBlock;   // block number that triggers the third exchange rate change
1261     uint256 public roundFourBlock;    // block number that triggers the fourth exchange rate change
1262     uint256 public ccReleaseBlock;    // block number that triggers purchases made by CC be transferable
1263 
1264     address public admin1;      // First administrator for multi-sig mechanism
1265     address public admin2;      // Second administrator for multi-sig mechanism
1266     address public tokenVendor; // Account delivering Tokens purchased with credit card
1267 
1268     // Contracts current state (Fundraising, Finalized, Paused) and the saved state (if currently paused)
1269     ContractState public state;       // Current state of the contract
1270     ContractState private savedState; // State of the contract before pause
1271 
1272     //@dev Usecase related: Purchasing Tokens with Credit card  
1273     //@dev Usecase related: Canceling purchases done with credit card
1274     mapping (string => Purchase) purchases;                 // in case CC payments get charged back, admins shall only be allowed to kill the exact amount of tokens associated with this payment
1275     mapping (address => uint256) public ccLockedUpBalances; // tracking the total amount of tokens users have bought via CC - locked up until ccReleaseBlock
1276     string[] public purchaseArray;                          // holding the IDs of all CC purchases
1277 
1278     // Keep track of holders and icoBuyers
1279     mapping (address => bool) public isHolder; // track if a user is a known token holder to the smart contract - important for payouts later
1280     address[] public holders;                  // array of all known holders - important for payouts later
1281     mapping (address => bool) isIcoBuyer;      // for tracking if user has to be kyc verified before being able to transfer tokens
1282 
1283     // ETH balance per user
1284     // Since we have different exchange rates at different stages, we need to keep track
1285     // of how much ether each contributed in case that we need to issue a refund
1286     mapping (address => uint256) private ethBalances;
1287     mapping (address => uint256) private noKycEthBalances;
1288 
1289     // Total received ETH balances
1290     // We need to keep track of how much ether have been contributed, since we have a cap for ETH too
1291     uint256 public allReceivedEth;
1292     uint256 public allUnKycedEth; // total amount of ETH we have no KYC for yet
1293 
1294     // store the hashes of admins' msg.data
1295     mapping (address => bytes32) private multiSigHashes;
1296 
1297     // KYC
1298     mapping (address => bool) public isKycTeam;   // to determine, if a user belongs to the KYC team or not
1299     mapping (address => bool) public kycVerified; // to check if user has already undergone KYC or not, to lock up his tokens until then
1300 
1301     // to track if team members already got their tokens
1302     bool public teamTokensDelivered;
1303 
1304     // Current ETH/USD exchange rate
1305     uint256 public ETH_USD_EXCHANGE_RATE_IN_CENTS; // set by oraclize
1306 
1307     // Everything oraclize related
1308     event updatedPrice(string price);
1309     event newOraclizeQuery(string description);
1310     uint public oraclizeQueryCost;
1311 
1312     // Events used for logging
1313     event LogRefund(address indexed _to, uint256 _value);
1314     event LogCreateEVN(address indexed _to, uint256 _value);
1315     event LogDeliverEVN(address indexed _to, uint256 _value);
1316     event LogCancelDelivery(address indexed _to, string _id);
1317     event LogKycRefused(address indexed _user, uint256 _value);
1318     event LogTeamTokensDelivered(address indexed distributor, uint256 _value);
1319 
1320     // Additional helper structs
1321     enum ContractState { Fundraising, Finalized, Paused }
1322 
1323     // Credit Card Purchase Parameters
1324     //@dev Usecase related: Purchase Tokens with Credit card
1325     //@dev Usecase related: Cancel purchase done with credit card
1326     struct Purchase {
1327         address buyer;
1328         uint256 tokenAmount;
1329         bool active;
1330     }
1331 
1332     // Modifiers
1333     modifier isFinalized() {
1334         require(state == ContractState.Finalized);
1335         _;
1336     }
1337 
1338     modifier isFundraising() {
1339         require(state == ContractState.Fundraising);
1340         _;
1341     }
1342 
1343     modifier isPaused() {
1344         require(state == ContractState.Paused);
1345         _;
1346     }
1347 
1348     modifier notPaused() {
1349         require(state != ContractState.Paused);
1350         _;
1351     }
1352 
1353     modifier isFundraisingIgnorePaused() {
1354         require(state == ContractState.Fundraising || (state == ContractState.Paused && savedState == ContractState.Fundraising));
1355         _;
1356     }
1357 
1358     modifier onlyKycTeam(){
1359         require(isKycTeam[msg.sender] == true);
1360         _;
1361     }
1362 
1363     modifier onlyOwner() {
1364         // check if transaction sender is admin.
1365         require (msg.sender == admin1 || msg.sender == admin2);
1366         // if yes, store his msg.data. 
1367         multiSigHashes[msg.sender] = keccak256(msg.data);
1368         // check if his stored msg.data hash equals to the one of the other admin
1369         if ((multiSigHashes[admin1]) == (multiSigHashes[admin2])) {
1370             // if yes, both admins agreed - continue.
1371             _;
1372 
1373             // Reset hashes after successful execution
1374             multiSigHashes[admin1] = 0x0;
1375             multiSigHashes[admin2] = 0x0;
1376         } else {
1377             // if not (yet), return.
1378             return;
1379         }
1380     }
1381 
1382     modifier onlyVendor() {
1383         require(msg.sender == tokenVendor);
1384         _;
1385     }
1386 
1387     modifier minimumReached() {
1388         require(allReceivedEth >= ETH_RECEIVED_MIN);
1389         require(totalSupply >= TOKEN_CREATED_MIN);
1390         _;
1391     }
1392 
1393     modifier isKycVerified(address _user) {
1394         // if token transferring user acquired the tokens through the ICO...
1395         if (isIcoBuyer[_user] == true) {
1396             // ...check if user is already unlocked
1397             require (kycVerified[_user] == true);
1398         }
1399         _;
1400     }
1401 
1402     modifier hasEnoughUnlockedTokens(address _user, uint256 _value) {
1403         // check if the user was a CC buyer and if the lockup period is not over,
1404         if (ccLockedUpBalances[_user] > 0 && block.number < ccReleaseBlock) {
1405             // allow to only transfer the not-locked up tokens
1406             require ((SafeMath.sub(balances[_user], _value)) >= ccLockedUpBalances[_user]);
1407         }
1408         _;
1409     }
1410 
1411     /**
1412      * @dev Create a new EVNToken contract.
1413      *
1414      *  _fundingStartBlock The starting block of the fundraiser (has to be in the future).
1415      *  _fundingEndBlock The end block of the fundraiser (has to be after _fundingStartBlock).
1416      *  _roundTwoBlock The block that changes the discount rate to 20% (has to be between _fundingStartBlock and _roundThreeBlock).
1417      *  _roundThreeBlock The block that changes the discount rate to 10% (has to be between _roundTwoBlock and _roundFourBlock).
1418      *  _roundFourBlock The block that changes the discount rate to 0% (has to be between _roundThreeBlock and _fundingEndBlock).
1419      *  _admin1 The first admin account that owns this contract.
1420      *  _admin2 The second admin account that owns this contract.
1421      *  _tokenVendor The account that creates tokens for credit card / fiat contributers.
1422      */
1423     function EVNToken(
1424         uint256 _fundingStartBlock,
1425         uint256 _fundingEndBlock,
1426         uint256 _roundTwoBlock, // block number that triggers the first exchange rate change
1427         uint256 _roundThreeBlock, // block number that triggers the second exchange rate change
1428         uint256 _roundFourBlock,
1429         address _admin1,
1430         address _admin2,
1431         address _tokenVendor,
1432         uint256 _ccReleaseBlock)
1433     payable
1434     {
1435         // Check that the parameters make sense
1436 
1437         // The start of the fundraising should happen in the future
1438         require (block.number <= _fundingStartBlock);
1439 
1440         // The discount rate changes and ending should follow in their subsequent order
1441         require (_fundingStartBlock < _roundTwoBlock);
1442         require (_roundTwoBlock < _roundThreeBlock);
1443         require (_roundThreeBlock < _roundFourBlock);
1444         require (_roundFourBlock < _fundingEndBlock);
1445 
1446         // block when tokens bought with CC will be released must be in the future
1447         require (_fundingEndBlock < _ccReleaseBlock);
1448 
1449         // admin1 and admin2 address must be set and must be different
1450         require (_admin1 != 0x0);
1451         require (_admin2 != 0x0);
1452         require (_admin1 != _admin2);
1453 
1454         // tokenVendor must be set and be different from admin1 and admin2
1455         require (_tokenVendor != 0x0);
1456         require (_tokenVendor != _admin1);
1457         require (_tokenVendor != _admin2);
1458 
1459         // provide some ETH for oraclize price feed
1460         require (msg.value > 0);
1461 
1462         // Init contract state
1463         state = ContractState.Fundraising;
1464         savedState = ContractState.Fundraising;
1465         fundingStartBlock = _fundingStartBlock;
1466         fundingEndBlock = _fundingEndBlock;
1467         roundTwoBlock = _roundTwoBlock;
1468         roundThreeBlock = _roundThreeBlock;
1469         roundFourBlock = _roundFourBlock;
1470         ccReleaseBlock = _ccReleaseBlock;
1471 
1472         totalSupply = 0;
1473 
1474         admin1 = _admin1;
1475         admin2 = _admin2;
1476         tokenVendor = _tokenVendor;
1477 
1478         //oraclize 
1479         oraclize_setCustomGasPrice(100000000000 wei); // set the gas price a little bit higher, so the pricefeed definitely works
1480         updatePrice();
1481         oraclizeQueryCost = oraclize_getPrice("URL");
1482     }
1483 
1484     //// oraclize START
1485 
1486     // @dev oraclize is called recursively here - once a callback fetches the newest ETH price, the next callback is scheduled for the next hour again
1487     function __callback(bytes32 myid, string result) {
1488         require(msg.sender == oraclize_cbAddress());
1489 
1490         // setting the token price here
1491         ETH_USD_EXCHANGE_RATE_IN_CENTS = SafeMath.parse(result);
1492         updatedPrice(result);
1493 
1494         // fetch the next price
1495         updatePrice();
1496     }
1497 
1498     function updatePrice() payable {    // can be left public as a way for replenishing contract's ETH balance, just in case
1499         if (msg.sender != oraclize_cbAddress()) {
1500             require(msg.value >= 200 finney);
1501         }
1502         if (oraclize_getPrice("URL") > this.balance) {
1503             newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1504         } else {
1505             newOraclizeQuery("Oraclize sent, wait..");
1506             // Schedule query in 1 hour. Set the gas amount to 220000, as parsing in __callback takes around 70000 - we play it safe.
1507             oraclize_query(3600, "URL", "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD", 220000);
1508         }
1509     }
1510     //// oraclize END
1511 
1512     // Overridden method to check for end of fundraising before allowing transfer of tokens
1513     function transfer(address _to, uint256 _value)
1514     public
1515     isFinalized // Only allow token transfer after the fundraising has ended
1516     isKycVerified(msg.sender)
1517     hasEnoughUnlockedTokens(msg.sender, _value)
1518     onlyPayloadSize(2)
1519     returns (bool success)
1520     {
1521         bool result = super.transfer(_to, _value);
1522         if (result) {
1523             trackHolder(_to); // track the owner for later payouts
1524         }
1525         return result;
1526     }
1527 
1528     // Overridden method to check for end of fundraising before allowing transfer of tokens
1529     function transferFrom(address _from, address _to, uint256 _value)
1530     public
1531     isFinalized // Only allow token transfer after the fundraising has ended
1532     isKycVerified(msg.sender)
1533     hasEnoughUnlockedTokens(msg.sender, _value)
1534     onlyPayloadSize(3)
1535     returns (bool success)
1536     {
1537         bool result = super.transferFrom(_from, _to, _value);
1538         if (result) {
1539             trackHolder(_to); // track the owner for later payouts
1540         }
1541         return result;
1542     }
1543 
1544     // Allow for easier balance checking
1545     function getBalanceOf(address _owner)
1546     constant
1547     returns (uint256 _balance)
1548     {
1549         return balances[_owner];
1550     }
1551 
1552      // getting purchase details by ID - workaround, mappings with dynamically sized keys can't be made public yet.
1553     function getPurchaseById(string _id)
1554     constant
1555     returns (address _buyer, uint256 _tokenAmount, bool _active){
1556         _buyer = purchases[_id].buyer;
1557         _tokenAmount = purchases[_id].tokenAmount;
1558         _active = purchases[_id].active;
1559     }
1560 
1561     // Allows to figure out the amount of known token holders
1562     function getHolderCount()
1563     public
1564     constant
1565     returns (uint256 _holderCount)
1566     {
1567         return holders.length;
1568     }
1569 
1570     // Allows to figure out the amount of purchases
1571     function getPurchaseCount()
1572     public
1573     constant
1574     returns (uint256 _purchaseCount)
1575     {
1576         return purchaseArray.length;
1577     }
1578 
1579     // Allows for easier retrieval of holder by array index
1580     function getHolder(uint256 _index)
1581     public
1582     constant
1583     returns (address _holder)
1584     {
1585         return holders[_index];
1586     }
1587 
1588     function trackHolder(address _to)
1589     private
1590     returns (bool success)
1591     {
1592         // Check if the recipient is a known token holder
1593         if (isHolder[_to] == false) {
1594             // if not, add him to the holders array and mark him as a known holder
1595             holders.push(_to);
1596             isHolder[_to] = true;
1597         }
1598         return true;
1599     }
1600 
1601 
1602     /// @dev Accepts ether and creates new EVN tokens
1603     function createTokens()
1604     payable
1605     external
1606     isFundraising
1607     {
1608         require(block.number >= fundingStartBlock);
1609         require(block.number <= fundingEndBlock);
1610         require(msg.value > 0);
1611 
1612         // First we check the ETH cap: would adding this amount to the total unKYCed eth and the already KYCed eth exceed the eth cap?
1613         // return the contribution if the cap has been reached already
1614         uint256 totalKycedAndUnKycEdEth = SafeMath.add(allUnKycedEth, allReceivedEth);
1615         uint256 checkedReceivedEth = SafeMath.add(totalKycedAndUnKycEdEth, msg.value);
1616         require(checkedReceivedEth <= ETH_RECEIVED_CAP);
1617 
1618         // If all is fine with the ETH cap, we continue to check the
1619         // minimum amount of tokens and the cap for how many tokens
1620         // have been generated so far
1621 
1622         // calculate the token amount
1623         uint256 tokens = SafeMath.mul(msg.value, ETH_USD_EXCHANGE_RATE_IN_CENTS);
1624 
1625         // divide by 100 to turn ETH_USD_EXCHANGE_RATE_IN_CENTS into full USD
1626         tokens = tokens / 100;
1627 
1628         // apply discount multiplier
1629         tokens = safeMulPercentage(tokens, getCurrentDiscountRate());
1630 
1631         require(tokens >= TOKEN_MIN);
1632         uint256 checkedSupply = SafeMath.add(totalSupply, tokens);
1633         require(checkedSupply <= TOKEN_CREATION_CAP);
1634 
1635         // Only when all the checks have passed, then we check if the address is already KYCEd and then 
1636         // update the state (noKycEthBalances, allReceivedEth, totalSupply, and balances) of the contract
1637 
1638         if (kycVerified[msg.sender] == false) {
1639             // @dev The unKYCed eth balances are moved to ethBalances in unlockKyc()
1640 
1641             noKycEthBalances[msg.sender] = SafeMath.add(noKycEthBalances[msg.sender], msg.value);
1642 
1643             // add the contributed eth to the total unKYCed eth amount
1644             allUnKycedEth = SafeMath.add(allUnKycedEth, msg.value);
1645         } else {
1646             // if buyer is already KYC unlocked...
1647             ethBalances[msg.sender] = SafeMath.add(ethBalances[msg.sender], msg.value);
1648             allReceivedEth = SafeMath.add(allReceivedEth, msg.value);
1649         }
1650 
1651         totalSupply = checkedSupply;
1652         balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
1653 
1654         trackHolder(msg.sender);
1655 
1656         // to force the check for KYC Status upon the user when he tries transferring tokens
1657         // and exclude every later token owner
1658         isIcoBuyer[msg.sender] = true;
1659 
1660         // Log the creation of these tokens
1661         LogCreateEVN(msg.sender, tokens);
1662     }
1663 
1664     //add a user to the KYC team
1665     function addToKycTeam(address _teamMember)
1666     onlyOwner
1667     onlyPayloadSize(1){
1668         isKycTeam[_teamMember] = true;
1669     }
1670 
1671     //remove a user from the KYC team
1672     function removeFromKycTeam(address _teamMember)
1673     onlyOwner
1674     onlyPayloadSize(1){
1675         isKycTeam[_teamMember] = false;
1676     }
1677 
1678     //called by KYC team 
1679     function unlockKyc(address _owner)
1680     external
1681     onlyKycTeam {
1682         require(kycVerified[_owner] == false);
1683 
1684         //unlock the owner to allow transfer of tokens
1685         kycVerified[_owner] = true;
1686 
1687         // we leave the ccLockedUpBalances[_owner] as is, because also KYCed users could cancel their CC payments
1688 
1689         if (noKycEthBalances[_owner] > 0) { // check if the user was an ETH buyer
1690 
1691             // now move the unKYCed eth balance to the regular ethBalance. 
1692             ethBalances[_owner] = noKycEthBalances[_owner];
1693 
1694             // add the now KYCed eth to the total received eth
1695             allReceivedEth = SafeMath.add(allReceivedEth, noKycEthBalances[_owner]);
1696 
1697             // subtract the now KYCed eth from total amount of unKYCed eth
1698             allUnKycedEth = SafeMath.sub(allUnKycedEth, noKycEthBalances[_owner]);
1699 
1700             // and set the user's unKYCed eth balance to 0
1701             noKycEthBalances[_owner] = 0; // preventing replay attacks
1702         }
1703     }
1704 
1705     // Refusing KYC of a user, who only contributed in ETH.
1706     // We must pay close attention here for the case that a user contributes in ETH AND(!) CC !
1707     // in this case, he must only kill the tokens he received through ETH, the ones bought in fiat will be
1708     // killed by canceling his payments and subsequently calling cancelDelivery() with the according payment id.
1709     function refuseKyc(address _user)
1710     external
1711     onlyKycTeam
1712     {
1713         // once a user is verified, you can't kick him out.
1714         require (kycVerified[_user] == false);
1715 
1716         // immediately stop, if a user has none or only CC contributions.
1717         // we're managing kyc refusing of CC contributors off-chain
1718         require(noKycEthBalances[_user]>0);
1719 
1720         uint256 EVNVal = balances[_user];
1721         require(EVNVal > 0);
1722 
1723         uint256 ethVal = noKycEthBalances[_user]; // refund un-KYCd eth
1724         require(ethVal > 0);
1725 
1726         // Update the state only after all the checks have passed
1727         allUnKycedEth = SafeMath.sub(allUnKycedEth, noKycEthBalances[_user]); // or if there was any unKYCed Eth, subtract it from the total unKYCed eth balance.
1728         balances[_user] = ccLockedUpBalances[_user]; // assign user only the token amount he has bought through CC, if there are any.
1729         noKycEthBalances[_user] = 0;
1730         totalSupply = SafeMath.sub(totalSupply, EVNVal); // Extra safe
1731 
1732         // Log this refund
1733         LogKycRefused(_user, ethVal);
1734 
1735         // Send the contributions only after we have updated all the balances
1736         // If you're using a contract, make sure it works with .transfer() gas limits
1737         _user.transfer(ethVal);
1738     }
1739 
1740     // Called in case a buyer cancels his CC payment.
1741     // @param The payment ID from payment provider
1742     function cancelDelivery(string _purchaseID)
1743     external
1744     onlyKycTeam{
1745         
1746         // CC payments are only cancelable until ccReleaseBlock
1747         require (block.number < ccReleaseBlock);
1748 
1749         // check if the purchase to cancel is still active
1750         require (purchases[_purchaseID].active == true);
1751 
1752         // now withdraw the canceled purchase's token amount from the user's balance
1753         balances[purchases[_purchaseID].buyer] = SafeMath.sub(balances[purchases[_purchaseID].buyer], purchases[_purchaseID].tokenAmount);
1754 
1755         // and withdraw the canceled purchase's token amount from the lockedUp token balance
1756         ccLockedUpBalances[purchases[_purchaseID].buyer] = SafeMath.sub(ccLockedUpBalances[purchases[_purchaseID].buyer], purchases[_purchaseID].tokenAmount);
1757 
1758         // set the purchase's status to inactive
1759         purchases[_purchaseID].active = false;
1760 
1761         //correct th amount of tokens generated
1762         totalSupply = SafeMath.sub(totalSupply, purchases[_purchaseID].tokenAmount);
1763 
1764         LogCancelDelivery(purchases[_purchaseID].buyer, _purchaseID);
1765     }
1766 
1767     // @dev Deliver tokens sold for CC/fiat and BTC
1768     // @dev param _tokens in Cents, e.g. 1 Token == 1$, passed as 100 cents
1769     // @dev param _btcBuyer Boolean to determine if the delivered tokens need to be locked (not the case for BTC buyers, their payment is final)
1770     // @dev discount multipliers are applied off-contract in this case
1771     function deliverTokens(address _to, uint256 _tokens, string _purchaseId, bool _btcBuyer)
1772     external
1773     isFundraising
1774     onlyVendor
1775     {
1776         require(_to != 0x0);
1777         require(_tokens > 0);
1778         require(bytes(_purchaseId).length>0);
1779         require(block.number >= fundingStartBlock);
1780         require(block.number <= fundingEndBlock + 168000); // allow delivery of tokens sold for fiat for 28 days after end of ICO for safety reasons
1781 
1782         // calculate the total amount of tokens and cut out the extra two decimal units,
1783         // because _tokens was in cents.
1784         uint256 tokens = SafeMath.mul(_tokens, (10**(decimals) / 10**2));
1785 
1786         // continue to check for how many tokens
1787         // have been generated so far
1788         uint256 checkedSupply = SafeMath.add(totalSupply, tokens);
1789         require(checkedSupply <= TOKEN_CREATION_CAP);
1790 
1791         // Only when all the checks have passed, then we update the state (totalSupply, and balances) of the contract
1792         totalSupply = checkedSupply;
1793 
1794         // prevent from adding a delivery multiple times
1795         require(purchases[_purchaseId].buyer==0x0);
1796 
1797         // Log this information in order to be able to cancel token deliveries (on CC refund) by the payment ID
1798         purchases[_purchaseId] = Purchase({
1799             buyer: _to,
1800             tokenAmount: tokens,
1801             active: true
1802         });
1803         purchaseArray.push(_purchaseId);
1804 
1805         // if tokens were not paid with BTC (but credit card), they need to be locked up 
1806         if (_btcBuyer == false) {
1807         ccLockedUpBalances[_to] = SafeMath.add(ccLockedUpBalances[_to], tokens); // update user's locked up token balance
1808         }
1809 
1810         balances[_to] = SafeMath.add(balances[_to], tokens);                     // safeAdd not needed; bad semantics to use here
1811         trackHolder(_to);                                                        // log holder's address
1812 
1813         // to force the check for KYC Status upon the user when he tries transferring tokens
1814         // and exclude every later token owner
1815         isIcoBuyer[_to] = true;
1816 
1817         // Log the creation of these tokens
1818         LogDeliverEVN(_to, tokens);
1819    }
1820 
1821     /// @dev Returns the current token price
1822     function getCurrentDiscountRate()
1823     private
1824     constant
1825     returns (uint256 currentDiscountRate)
1826     {
1827         // determine which discount to apply
1828         if (block.number < roundTwoBlock) {
1829             // first round
1830             return TOKEN_FIRST_DISCOUNT_MULTIPLIER;
1831         } else if (block.number < roundThreeBlock){
1832             // second round
1833             return TOKEN_SECOND_DISCOUNT_MULTIPLIER;
1834         } else if (block.number < roundFourBlock) {
1835             // third round
1836             return TOKEN_THIRD_DISCOUNT_MULTIPLIER;
1837         } else {
1838             // fourth round, no discount
1839             return 100000;
1840         }
1841     }
1842 
1843     /// @dev Allows to transfer ether from the contract as soon as the minimum is reached
1844     function retrieveEth(uint256 _value, address _safe)
1845     external
1846     minimumReached
1847     onlyOwner
1848     {
1849         require(SafeMath.sub(this.balance, _value) >= allUnKycedEth); // make sure unKYCed eth cannot be withdrawn
1850         // make sure a recipient was defined !
1851         require (_safe != 0x0);
1852 
1853         // send the eth to where admins agree upon
1854         _safe.transfer(_value);
1855     }
1856 
1857 
1858     /// @dev Ends the fundraising period and sends the ETH to wherever the admins agree upon
1859     function finalize(address _safe)
1860     external
1861     isFundraising
1862     minimumReached
1863     onlyOwner  // Only the admins calling this method exactly the same way can finalize the sale.
1864     {
1865         // Only allow to finalize the contract before the ending block if we already reached any of the two caps
1866         require(block.number > fundingEndBlock || totalSupply >= TOKEN_CREATED_MIN || allReceivedEth >= ETH_RECEIVED_MIN);
1867         // make sure a recipient was defined !
1868         require (_safe != 0x0);
1869 
1870         // Move the contract to Finalized state
1871         state = ContractState.Finalized;
1872         savedState = ContractState.Finalized;
1873 
1874         // Send the KYCed ETH to where admins agree upon.
1875         _safe.transfer(allReceivedEth);
1876     }
1877 
1878 
1879     /// @dev Pauses the contract
1880     function pause()
1881     external
1882     notPaused   // Prevent the contract getting stuck in the Paused state
1883     onlyOwner   // Only both admins calling this method can pause the contract
1884     {
1885         // Move the contract to Paused state
1886         savedState = state;
1887         state = ContractState.Paused;
1888     }
1889 
1890 
1891     /// @dev Proceeds with the contract
1892     function proceed()
1893     external
1894     isPaused
1895     onlyOwner   // Only both admins calling this method can proceed with the contract
1896     {
1897         // Move the contract to the previous state
1898         state = savedState;
1899     }
1900 
1901     /// @dev Allows contributors to recover their ether in case the minimum funding goal is not reached
1902     function refund()
1903     external
1904     {
1905         // Allow refunds only a week after end of funding to give KYC-team time to verify contributors
1906         // and thereby move un-KYC-ed ETH over into allReceivedEth as well as deliver the tokens paid with CC
1907         require(block.number > (fundingEndBlock + 42000));
1908 
1909         // No refunds if the minimum has been reached or minimum of 1 Million Tokens have been generated
1910         require(allReceivedEth < ETH_RECEIVED_MIN || totalSupply < TOKEN_CREATED_MIN);
1911 
1912         // to prevent CC buyers from accidentally calling refund and burning their tokens
1913         require (ethBalances[msg.sender] > 0 || noKycEthBalances[msg.sender] > 0);
1914 
1915         // Only refund if there are EVN tokens
1916         uint256 EVNVal = balances[msg.sender];
1917         require(EVNVal > 0);
1918 
1919         // refunds either KYCed eth or un-KYCd eth
1920         uint256 ethVal = SafeMath.add(ethBalances[msg.sender], noKycEthBalances[msg.sender]);
1921         require(ethVal > 0);
1922 
1923         allReceivedEth = SafeMath.sub(allReceivedEth, ethBalances[msg.sender]);    // subtract only the KYCed ETH from allReceivedEth, because the latter is what admins will only be able to withdraw
1924         allUnKycedEth = SafeMath.sub(allUnKycedEth, noKycEthBalances[msg.sender]); // or if there was any unKYCed Eth, subtract it from the total unKYCed eth balance.
1925 
1926         // Update the state only after all the checks have passed.
1927         // reset everything to zero, no replay attacks.
1928         balances[msg.sender] = 0;
1929         ethBalances[msg.sender] = 0;
1930         noKycEthBalances[msg.sender] = 0;
1931         totalSupply = SafeMath.sub(totalSupply, EVNVal); // Extra safe
1932 
1933         // Log this refund
1934         LogRefund(msg.sender, ethVal);
1935 
1936         // Send the contributions only after we have updated all the balances
1937         // If you're using a contract, make sure it works with .transfer() gas limits
1938         msg.sender.transfer(ethVal);
1939     }
1940 
1941     // @dev Deliver tokens to be distributed to team members
1942     function deliverTeamTokens(address _to)
1943     external
1944     isFinalized
1945     onlyOwner
1946     {
1947         require(teamTokensDelivered == false);
1948         require(_to != 0x0);
1949 
1950         // allow delivery of tokens for the company and supporters without vesting, team tokens will be supplied like a CC purchase.
1951         
1952         // company and supporters gets 7% of a whole final pie, meaning we have to add ~7,5% to the
1953         // current totalSupply now, basically stretching it and taking 7% from the result, so the 93% that remain equals the amount of tokens created right now.
1954         // e.g. (93 * x = 100, where x amounts to roughly about 1.07526 and 7 would be the team's part)
1955         uint256 newTotalSupply = safeMulPercentage(totalSupply, 107526);
1956 
1957         // give company and supporters their 7% 
1958         uint256 tokens = SafeMath.sub(newTotalSupply, totalSupply);
1959         balances[_to] = tokens;
1960 
1961         //update state
1962         teamTokensDelivered = true;
1963         totalSupply = newTotalSupply;
1964         trackHolder(_to);
1965 
1966         // Log the creation of these tokens
1967         LogTeamTokensDelivered(_to, tokens);
1968     }
1969 
1970     function safeMulPercentage(uint256 value, uint256 percentage)
1971     internal
1972     constant
1973     returns (uint256 resultValue)
1974     {
1975         require(percentage >= 100000);
1976         require(percentage < 200000);
1977 
1978         // Multiply with percentage
1979         uint256 newValue = SafeMath.mul(value, percentage);
1980         // Remove the 5 extra decimals
1981         newValue = newValue / 10**5;
1982         return newValue;
1983     }
1984 
1985     // customizing the gas price for oraclize calls during "ICO Rush hours"
1986     function setOraclizeGas(uint256 _option)
1987     external
1988     onlyOwner
1989     {
1990         if (_option <= 30) {
1991             oraclize_setCustomGasPrice(30000000000 wei);
1992         } else if (_option <= 50) {
1993             oraclize_setCustomGasPrice(50000000000 wei);
1994         } else if (_option <= 70) {
1995             oraclize_setCustomGasPrice(70000000000 wei);
1996         } else if (_option <= 100) {
1997             oraclize_setCustomGasPrice(100000000000 wei);
1998         }
1999     }
2000 }