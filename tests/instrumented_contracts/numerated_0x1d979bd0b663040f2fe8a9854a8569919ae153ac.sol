1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize SRL
4 Copyright (c) 2016 Oraclize LTD
5 
6 
7 
8 Permission is hereby granted, free of charge, to any person obtaining a copy
9 of this software and associated documentation files (the "Software"), to deal
10 in the Software without restriction, including without limitation the rights
11 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 copies of the Software, and to permit persons to whom the Software is
13 furnished to do so, subject to the following conditions:
14 
15 
16 
17 The above copyright notice and this permission notice shall be included in
18 all copies or substantial portions of the Software.
19 
20 
21 
22 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
25 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
28 THE SOFTWARE.
29 */
30 
31 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
32 
33 contract OraclizeI {
34     address public cbAddress;
35     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
36     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
37     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
38     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
39     function getPrice(string _datasource) returns (uint _dsprice);
40     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
41     function useCoupon(string _coupon);
42     function setProofType(byte _proofType);
43     function setConfig(bytes32 _config);
44     function setCustomGasPrice(uint _gasPrice);
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
55     byte constant proofStorage_IPFS = 0x01;
56     uint8 constant networkID_auto = 0;
57     uint8 constant networkID_mainnet = 1;
58     uint8 constant networkID_testnet = 2;
59     uint8 constant networkID_morden = 2;
60     uint8 constant networkID_consensys = 161;
61 
62     OraclizeAddrResolverI OAR;
63     
64     OraclizeI oraclize;
65     modifier oraclizeAPI {
66         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
67         oraclize = OraclizeI(OAR.getAddress());
68         _;
69     }
70     modifier coupon(string code){
71         oraclize = OraclizeI(OAR.getAddress());
72         oraclize.useCoupon(code);
73         _;
74     }
75 
76     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
77         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){ //mainnet
78             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
79             return true;
80         }
81         if (getCodeSize(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1)>0){ //ropsten testnet
82             OAR = OraclizeAddrResolverI(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1);
83             return true;
84         }
85         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){ //ether.camp ide
86             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
87             return true;
88         }
89         if (getCodeSize(0x93bbbe5ce77034e3095f0479919962a903f898ad)>0){ //norsborg testnet
90             OAR = OraclizeAddrResolverI(0x93bbbe5ce77034e3095f0479919962a903f898ad);
91             return true;
92         }
93         if (getCodeSize(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa)>0){ //browser-solidity
94             OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
95             return true;
96         }
97         return false;
98     }
99     
100     function __callback(bytes32 myid, string result) {
101         __callback(myid, result, new bytes(0));
102     }
103     function __callback(bytes32 myid, string result, bytes proof) {
104     }
105     
106     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
107         return oraclize.getPrice(datasource);
108     }
109     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
110         return oraclize.getPrice(datasource, gaslimit);
111     }
112     
113     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
114         uint price = oraclize.getPrice(datasource);
115         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
116         return oraclize.query.value(price)(0, datasource, arg);
117     }
118     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
119         uint price = oraclize.getPrice(datasource);
120         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
121         return oraclize.query.value(price)(timestamp, datasource, arg);
122     }
123     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
124         uint price = oraclize.getPrice(datasource, gaslimit);
125         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
126         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
127     }
128     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
129         uint price = oraclize.getPrice(datasource, gaslimit);
130         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
131         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
132     }
133     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
134         uint price = oraclize.getPrice(datasource);
135         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
136         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
137     }
138     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
139         uint price = oraclize.getPrice(datasource);
140         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
141         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
142     }
143     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
144         uint price = oraclize.getPrice(datasource, gaslimit);
145         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
146         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
147     }
148     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource, gaslimit);
150         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
151         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
152     }
153     function oraclize_cbAddress() oraclizeAPI internal returns (address){
154         return oraclize.cbAddress();
155     }
156     function oraclize_setProof(byte proofP) oraclizeAPI internal {
157         return oraclize.setProofType(proofP);
158     }
159     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
160         return oraclize.setCustomGasPrice(gasPrice);
161     }    
162     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
163         return oraclize.setConfig(config);
164     }
165 
166     function getCodeSize(address _addr) constant internal returns(uint _size) {
167         assembly {
168             _size := extcodesize(_addr)
169         }
170     }
171 
172 
173     function parseAddr(string _a) internal returns (address){
174         bytes memory tmp = bytes(_a);
175         uint160 iaddr = 0;
176         uint160 b1;
177         uint160 b2;
178         for (uint i=2; i<2+2*20; i+=2){
179             iaddr *= 256;
180             b1 = uint160(tmp[i]);
181             b2 = uint160(tmp[i+1]);
182             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
183             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
184             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
185             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
186             iaddr += (b1*16+b2);
187         }
188         return address(iaddr);
189     }
190 
191 
192     function strCompare(string _a, string _b) internal returns (int) {
193         bytes memory a = bytes(_a);
194         bytes memory b = bytes(_b);
195         uint minLength = a.length;
196         if (b.length < minLength) minLength = b.length;
197         for (uint i = 0; i < minLength; i ++)
198             if (a[i] < b[i])
199                 return -1;
200             else if (a[i] > b[i])
201                 return 1;
202         if (a.length < b.length)
203             return -1;
204         else if (a.length > b.length)
205             return 1;
206         else
207             return 0;
208    } 
209 
210     function indexOf(string _haystack, string _needle) internal returns (int)
211     {
212         bytes memory h = bytes(_haystack);
213         bytes memory n = bytes(_needle);
214         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
215             return -1;
216         else if(h.length > (2**128 -1))
217             return -1;                                  
218         else
219         {
220             uint subindex = 0;
221             for (uint i = 0; i < h.length; i ++)
222             {
223                 if (h[i] == n[0])
224                 {
225                     subindex = 1;
226                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
227                     {
228                         subindex++;
229                     }   
230                     if(subindex == n.length)
231                         return int(i);
232                 }
233             }
234             return -1;
235         }   
236     }
237 
238     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
239         bytes memory _ba = bytes(_a);
240         bytes memory _bb = bytes(_b);
241         bytes memory _bc = bytes(_c);
242         bytes memory _bd = bytes(_d);
243         bytes memory _be = bytes(_e);
244         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
245         bytes memory babcde = bytes(abcde);
246         uint k = 0;
247         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
248         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
249         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
250         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
251         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
252         return string(babcde);
253     }
254     
255     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
256         return strConcat(_a, _b, _c, _d, "");
257     }
258 
259     function strConcat(string _a, string _b, string _c) internal returns (string) {
260         return strConcat(_a, _b, _c, "", "");
261     }
262 
263     function strConcat(string _a, string _b) internal returns (string) {
264         return strConcat(_a, _b, "", "", "");
265     }
266 
267     // parseInt
268     function parseInt(string _a) internal returns (uint) {
269         return parseInt(_a, 0);
270     }
271 
272     // parseInt(parseFloat*10^_b)
273     function parseInt(string _a, uint _b) internal returns (uint) {
274         bytes memory bresult = bytes(_a);
275         uint mint = 0;
276         bool decimals = false;
277         for (uint i=0; i<bresult.length; i++){
278             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
279                 if (decimals){
280                    if (_b == 0) break;
281                     else _b--;
282                 }
283                 mint *= 10;
284                 mint += uint(bresult[i]) - 48;
285             } else if (bresult[i] == 46) decimals = true;
286         }
287         if (_b > 0) mint *= 10**_b;
288         return mint;
289     }
290     
291     function uint2str(uint i) internal returns (string){
292         if (i == 0) return "0";
293         uint j = i;
294         uint len;
295         while (j != 0){
296             len++;
297             j /= 10;
298         }
299         bytes memory bstr = new bytes(len);
300         uint k = len - 1;
301         while (i != 0){
302             bstr[k--] = byte(48 + i % 10);
303             i /= 10;
304         }
305         return string(bstr);
306     }
307     
308     
309 
310 }
311 // </ORACLIZE_API>
312 
313 
314 
315 contract mortal {
316     address owner;
317 
318     function mortal() {
319         owner = msg.sender;
320     }
321 
322     function kill() {
323         if (msg.sender == owner) suicide(owner);
324     }
325 }
326 
327 
328 contract slot is mortal, usingOraclize {
329     /** which oraclize ID belong to which player address?**/
330     mapping (bytes32 => address) players; 
331     /** the amount of gas to be sent to oraclize**/
332     uint32 public oraclizeGas;
333     /** probabilities of the different results (absolute frequency out of 1.000.000 spins)**/
334     uint32[] public probabilities;
335     /** the prize per probability (shifted by two digits -> 375 is acutually 3.75)*/
336     uint32[] public prizes;
337     /** the amount of ether per bet **/
338     mapping (bytes32 => uint) bets;
339     /** the oraclize query string**/
340     string public query;
341     /** the type of the oraclize query**/
342     string public queryType;
343     /** tell the listeners the result
344     first value: type, second value: player address, third value: oraclize ID**/
345     event gameResult(uint, address);// 0-> %5; 1 -> 80%; 2 -> loss, 3->error in callback;
346 
347     
348     /** **/
349     function slot() payable{
350         probabilities.push(4);
351         probabilities.push(50);
352         probabilities.push(200);
353         probabilities.push(600);
354         probabilities.push(1000);
355         probabilities.push(2000);
356         probabilities.push(4000);
357         probabilities.push(30000);
358         probabilities.push(90000);
359         prizes.push(5000);
360         prizes.push(2500);
361         prizes.push(2000);
362         prizes.push(1900);
363         prizes.push(1800);
364         prizes.push(1700);
365         prizes.push(1600);
366         prizes.push(1500);
367         prizes.push(375);
368         oraclizeGas = 250000;
369         query = "random number between 1 and 1000000";
370         queryType = "WolframAlpha";
371     }
372     
373     /**
374      * If more than 0.1 ether and less than 1 ether is sent and the contracts holds enough to pay out the player in case of a win, a random number is asked from oraclize.
375      * */
376 
377     function() payable {
378         if(msg.sender!=owner){//owner should be able to send funds to the contract anytime
379             if(msg.value<100000000000000000||msg.value>1000000000000000000) throw;//bet has to lie between 0.1 and 1 ETH
380             if(address(this).balance < msg.value/100*prizes[0]) throw; //make sure the contract is able to pay out the player in case he wins
381             bytes32 oid = oraclize_query(queryType, query, oraclizeGas);
382             bets[oid] = msg.value;
383             players[oid] = msg.sender;
384         }
385     }
386 
387     /**
388      * The random number from Oraclizes decides the game result.
389      * If Oraclize sends a message instead of the requested number, the bet is returned to the player.
390      * */
391     function __callback(bytes32 myid, string result) {
392         if (msg.sender != oraclize_cbAddress()) throw;
393         if (players[myid]==0x0) throw;
394         uint random = convertToInt(result);
395         if(random==0){//result not a number, return bet
396             if(!players[myid].send(bets[myid])) throw;
397             gameResult(101,players[myid]);
398             delete players[myid];
399             return;
400         }
401         uint range = 0;
402         for(uint i = 0; i<probabilities.length; i++){
403             range+=probabilities[i];
404             if(random<=range){
405                 if(!players[myid].send(bets[myid]/100*prizes[i])){
406                     gameResult(100,players[myid]);//100 -> error
407                     throw;
408                 } 
409                 gameResult(i, players[myid]);
410                 delete players[myid];
411                 return;
412             }
413         }
414 
415         //else player loses everything
416         gameResult(probabilities.length, players[myid]);
417         
418         delete players[myid];
419         
420     }
421     
422     /**
423      * sets the amount of gas to be sent to oraclize
424      * */
425     function setOraclizeGas(uint32 newGas){
426         if(!(msg.sender==owner)) throw;
427     	oraclizeGas = newGas;
428     }
429     
430     /**
431      * sets the amount of gas to be sent to oraclize
432      * */
433     function setOraclizeQuery(string newQuery){
434         if(!(msg.sender==owner)) throw;
435     	query = newQuery;
436     }
437     
438     /**
439      * sets the amount of gas to be sent to oraclize
440      * */
441     function setOraclizeQueryType(string newQueryType){
442         if(!(msg.sender==owner)) throw;
443     	queryType = newQueryType;
444     }
445     
446     /** set the probabilities of the results (absolute frequencies out of 1.000.000 spins) **/
447     function setProbabilities(uint32[] probs){
448         if(!(msg.sender==owner)) throw;
449         probabilities=probs;
450     }
451     
452     /** set the prizes of the results (shifted by 2 digits -> 375 means 3.75)**/
453     function setPrizes(uint32[] priz){
454         if(!(msg.sender==owner)) throw;
455         prizes=priz;
456     }
457     
458     /**
459      * allows the owner to collect the accumulated losses
460      * */
461     function collectFees(uint amount){
462         if(!(msg.sender==owner)) throw;
463         if( address(this).balance < amount) throw;
464         if(!owner.send(amount)) throw;
465     }
466     
467     /**
468      * converts a string to an integer (there may only be digits)
469      * */
470     function convertToInt(string _a) internal returns (uint) {
471         bytes memory bresult = bytes(_a);
472         uint mint = 0;
473         for (uint i=0; i<bresult.length; i++){
474             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
475                 mint *= 10;
476                 mint += uint(bresult[i]) - 48;
477             } else if((bresult[i] >= 58)&&(bresult[i] <= 126)) return 0;//its a message, no pure int
478         }
479         return mint;
480     }
481 }