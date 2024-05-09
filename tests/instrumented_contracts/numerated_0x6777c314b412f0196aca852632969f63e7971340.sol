1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani
4 
5 
6 
7 Permission is hereby granted, free of charge, to any person obtaining a copy
8 of this software and associated documentation files (the "Software"), to deal
9 in the Software without restriction, including without limitation the rights
10 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11 copies of the Software, and to permit persons to whom the Software is
12 furnished to do so, subject to the following conditions:
13 
14 
15 
16 The above copyright notice and this permission notice shall be included in
17 all copies or substantial portions of the Software.
18 
19 
20 
21 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
22 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
23 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
24 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
25 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
26 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
27 THE SOFTWARE.
28 */
29 
30 contract OraclizeI {
31     address public cbAddress;
32     function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id);
33     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id);
34     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) returns (bytes32 _id);
35     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) returns (bytes32 _id);
36     function getPrice(string _datasource) returns (uint _dsprice);
37     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
38     function useCoupon(string _coupon);
39     function setProofType(byte _proofType);
40 }
41 contract OraclizeAddrResolverI {
42     function getAddress() returns (address _addr);
43 }
44 contract usingOraclize {
45     uint constant day = 60*60*24;
46     uint constant week = 60*60*24*7;
47     uint constant month = 60*60*24*30;
48     byte constant proofType_NONE = 0x00;
49     byte constant proofType_TLSNotary = 0x10;
50     byte constant proofStorage_IPFS = 0x01;
51     uint8 constant networkID_auto = 0;
52     uint8 constant networkID_mainnet = 1;
53     uint8 constant networkID_testnet = 2;
54     uint8 constant networkID_morden = 2;
55     uint8 constant networkID_consensys = 161;
56 
57     OraclizeAddrResolverI OAR;
58     
59     OraclizeI oraclize;
60     modifier oraclizeAPI {
61         address oraclizeAddr = OAR.getAddress();
62         if (oraclizeAddr == 0){
63             oraclize_setNetwork(networkID_auto);
64             oraclizeAddr = OAR.getAddress();
65         }
66         oraclize = OraclizeI(oraclizeAddr);
67         _
68     }
69     modifier coupon(string code){
70         oraclize = OraclizeI(OAR.getAddress());
71         oraclize.useCoupon(code);
72         _
73     }
74 
75     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
76         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){
77             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
78             return true;
79         }
80         if (getCodeSize(0x9efbea6358bed926b293d2ce63a730d6d98d43dd)>0){
81             OAR = OraclizeAddrResolverI(0x9efbea6358bed926b293d2ce63a730d6d98d43dd);
82             return true;
83         }
84         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){
85             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
86             return true;
87         }
88         return false;
89     }
90     
91     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
92         uint price = oraclize.getPrice(datasource);
93         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
94         return oraclize.query.value(price)(0, datasource, arg);
95     }
96     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
97         uint price = oraclize.getPrice(datasource);
98         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
99         return oraclize.query.value(price)(timestamp, datasource, arg);
100     }
101     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
102         uint price = oraclize.getPrice(datasource, gaslimit);
103         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
104         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
105     }
106     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
107         uint price = oraclize.getPrice(datasource, gaslimit);
108         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
109         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
110     }
111     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
112         uint price = oraclize.getPrice(datasource);
113         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
114         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
115     }
116     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
117         uint price = oraclize.getPrice(datasource);
118         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
119         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
120     }
121     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
122         uint price = oraclize.getPrice(datasource, gaslimit);
123         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
124         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
125     }
126     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
127         uint price = oraclize.getPrice(datasource, gaslimit);
128         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
129         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
130     }
131     function oraclize_cbAddress() oraclizeAPI internal returns (address){
132         return oraclize.cbAddress();
133     }
134     function oraclize_setProof(byte proofP) oraclizeAPI internal {
135         return oraclize.setProofType(proofP);
136     }
137 
138     function getCodeSize(address _addr) constant internal returns(uint _size) {
139         assembly {
140             _size := extcodesize(_addr)
141         }
142     }
143 
144 
145     function parseAddr(string _a) internal returns (address){
146         bytes memory tmp = bytes(_a);
147         uint160 iaddr = 0;
148         uint160 b1;
149         uint160 b2;
150         for (uint i=2; i<2+2*20; i+=2){
151             iaddr *= 256;
152             b1 = uint160(tmp[i]);
153             b2 = uint160(tmp[i+1]);
154             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
155             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
156             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
157             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
158             iaddr += (b1*16+b2);
159         }
160         return address(iaddr);
161     }
162 
163 
164     function strCompare(string _a, string _b) internal returns (int) {
165         bytes memory a = bytes(_a);
166         bytes memory b = bytes(_b);
167         uint minLength = a.length;
168         if (b.length < minLength) minLength = b.length;
169         for (uint i = 0; i < minLength; i ++)
170             if (a[i] < b[i])
171                 return -1;
172             else if (a[i] > b[i])
173                 return 1;
174         if (a.length < b.length)
175             return -1;
176         else if (a.length > b.length)
177             return 1;
178         else
179             return 0;
180    } 
181 
182     function indexOf(string _haystack, string _needle) internal returns (int)
183     {
184         bytes memory h = bytes(_haystack);
185         bytes memory n = bytes(_needle);
186         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
187             return -1;
188         else if(h.length > (2**128 -1))
189             return -1;                                  
190         else
191         {
192             uint subindex = 0;
193             for (uint i = 0; i < h.length; i ++)
194             {
195                 if (h[i] == n[0])
196                 {
197                     subindex = 1;
198                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
199                     {
200                         subindex++;
201                     }   
202                     if(subindex == n.length)
203                         return int(i);
204                 }
205             }
206             return -1;
207         }   
208     }
209 
210     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
211         bytes memory _ba = bytes(_a);
212         bytes memory _bb = bytes(_b);
213         bytes memory _bc = bytes(_c);
214         bytes memory _bd = bytes(_d);
215         bytes memory _be = bytes(_e);
216         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
217         bytes memory babcde = bytes(abcde);
218         uint k = 0;
219         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
220         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
221         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
222         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
223         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
224         return string(babcde);
225     }
226     
227     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
228         return strConcat(_a, _b, _c, _d, "");
229     }
230 
231     function strConcat(string _a, string _b, string _c) internal returns (string) {
232         return strConcat(_a, _b, _c, "", "");
233     }
234 
235     function strConcat(string _a, string _b) internal returns (string) {
236         return strConcat(_a, _b, "", "", "");
237     }
238 
239     // parseInt
240     function parseInt(string _a) internal returns (uint) {
241         return parseInt(_a, 0);
242     }
243 
244     // parseInt(parseFloat*10^_b)
245     function parseInt(string _a, uint _b) internal returns (uint) {
246         bytes memory bresult = bytes(_a);
247         uint mint = 0;
248         bool decimals = false;
249         for (uint i=0; i<bresult.length; i++){
250             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
251                 if (decimals){
252                    if (_b == 0) break;
253                     else _b--;
254                 }
255                 mint *= 10;
256                 mint += uint(bresult[i]) - 48;
257             } else if (bresult[i] == 46) decimals = true;
258         }
259         mint *= 10 ** _b;
260         return mint;
261     }
262     
263 
264 }
265 // </ORACLIZE_API>
266 
267 /*
268 This file is part of the DAO.
269 
270 The DAO is free software: you can redistribute it and/or modify
271 it under the terms of the GNU lesser General Public License as published by
272 the Free Software Foundation, either version 3 of the License, or
273 (at your option) any later version.
274 
275 The DAO is distributed in the hope that it will be useful,
276 but WITHOUT ANY WARRANTY; without even the implied warranty of
277 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
278 GNU lesser General Public License for more details.
279 
280 You should have received a copy of the GNU lesser General Public License
281 along with the DAO.  If not, see <http://www.gnu.org/licenses/>.
282 */
283 
284 
285 /*
286 Basic, standardized Token contract with no "premine". Defines the functions to
287 check token balances, send tokens, send tokens on behalf of a 3rd party and the
288 corresponding approval process. Tokens need to be created by a derived
289 contract (e.g. TokenCreation.sol).
290 
291 Thank you ConsenSys, this contract originated from:
292 https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/Standard_Token.sol
293 Which is itself based on the Ethereum standardized contract APIs:
294 https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs
295 */
296 
297 /// @title Standard Token Contract.
298 
299 contract TokenInterface {
300     mapping (address => uint256) balances;
301     mapping (address => mapping (address => uint256)) allowed;
302 
303     /// Total amount of tokens
304     uint256 public totalSupply;
305 
306     /// @param _owner The address from which the balance will be retrieved
307     /// @return The balance
308     function balanceOf(address _owner) constant returns (uint256 balance);
309 
310     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
311     /// @param _to The address of the recipient
312     /// @param _amount The amount of tokens to be transferred
313     /// @return Whether the transfer was successful or not
314     function transfer(address _to, uint256 _amount) returns (bool success);
315 
316     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
317     /// is approved by `_from`
318     /// @param _from The address of the origin of the transfer
319     /// @param _to The address of the recipient
320     /// @param _amount The amount of tokens to be transferred
321     /// @return Whether the transfer was successful or not
322     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success);
323 
324     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
325     /// its behalf
326     /// @param _spender The address of the account able to transfer the tokens
327     /// @param _amount The amount of tokens to be approved for transfer
328     /// @return Whether the approval was successful or not
329     function approve(address _spender, uint256 _amount) returns (bool success);
330 
331     /// @param _owner The address of the account owning tokens
332     /// @param _spender The address of the account able to transfer the tokens
333     /// @return Amount of remaining tokens of _owner that _spender is allowed
334     /// to spend
335     function allowance(
336         address _owner,
337         address _spender
338     ) constant returns (uint256 remaining);
339 
340     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
341     event Approval(
342         address indexed _owner,
343         address indexed _spender,
344         uint256 _amount
345     );
346 }
347 
348 
349 contract Token is TokenInterface {
350     // Protects users by preventing the execution of method calls that
351     // inadvertently also transferred ether
352     modifier noEther() {if (msg.value > 0) throw; _}
353 
354     function balanceOf(address _owner) constant returns (uint256 balance) {
355         return balances[_owner];
356     }
357 
358     function _transfer(address _to, uint256 _amount) internal returns (bool success) {
359         if (balances[msg.sender] >= _amount && _amount > 0) {
360             balances[msg.sender] -= _amount;
361             balances[_to] += _amount;
362             Transfer(msg.sender, _to, _amount);
363             return true;
364         } else {
365            return false;
366         }
367     }
368 
369     function _transferFrom(
370         address _from,
371         address _to,
372         uint256 _amount
373     ) internal returns (bool success) {
374 
375         if (balances[_from] >= _amount
376             && allowed[_from][msg.sender] >= _amount
377             && _amount > 0) {
378 
379             balances[_to] += _amount;
380             balances[_from] -= _amount;
381             allowed[_from][msg.sender] -= _amount;
382             Transfer(_from, _to, _amount);
383             return true;
384         } else {
385             return false;
386         }
387     }
388 
389     function approve(address _spender, uint256 _amount) returns (bool success) {
390         allowed[msg.sender][_spender] = _amount;
391         Approval(msg.sender, _spender, _amount);
392         return true;
393     }
394 
395     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
396         return allowed[_owner][_spender];
397     }
398 }
399 
400 contract KissBTCCallback {
401     function kissBTCCallback(uint id, uint amount);
402 }
403 
404 contract ApprovalRecipient {
405     function receiveApproval(address _from, uint256 _amount,
406                              address _tokenContract, bytes _extraData);
407 }
408 
409 contract KissBTC is usingOraclize, Token {
410     string constant PRICE_FEED =
411         "json(https://api.kraken.com/0/public/Ticker?pair=ETHXBT).result.XETHXXBT.c.0";
412     uint constant MAX_AMOUNT =
413         0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
414     uint constant MAX_ETH_VALUE = 10 ether;
415     uint constant MIN_ETH_VALUE = 50 finney;
416     uint constant MAX_KISS_BTC_VALUE = 25000000;
417     uint constant MIN_KISS_BTC_VALUE = 125000;
418     uint constant DEFAULT_GAS_LIMIT = 200000;
419 
420     string public standard = "Token 0.1";
421     string public name = "kissBTC";
422     string public symbol = "kissBTC";
423     uint8 public decimals = 8;
424 
425     struct Task {
426         bytes32 oraclizeId;
427         bool toKissBTC;
428         address sender;
429         uint value;
430         address callback;
431         uint timestamp;
432     }
433 
434     mapping (uint => Task) public tasks;
435     mapping (bytes32 => uint) public oraclizeRequests;
436     uint public exchangeRate;
437     uint public nextId = 1;
438 
439     address public owner;
440     uint public timestamp;
441 
442     modifier onlyowner { if (msg.sender == owner) _ }
443 
444     function KissBTC() {
445         owner = msg.sender;
446     }
447 
448     // default action is to turn Ether into kissBTC
449     function () {
450         buyKissBTCWithCallback(0, DEFAULT_GAS_LIMIT);
451     }
452 
453     function buyKissBTC() {
454         buyKissBTCWithCallback(0, DEFAULT_GAS_LIMIT);
455     }
456 
457     function buyKissBTCWithCallback(address callback,
458                                     uint gasLimit) oraclizeAPI
459                                     returns (uint id) {
460         if (msg.value < MIN_ETH_VALUE || msg.value > MAX_ETH_VALUE) throw;
461         if (gasLimit < DEFAULT_GAS_LIMIT) gasLimit = DEFAULT_GAS_LIMIT;
462 
463         uint oraclizePrice = oraclize.getPrice("URL", gasLimit);
464         uint fee = msg.value / 100; // for the contract's coffers
465 
466         if (msg.value <= oraclizePrice + fee) throw;
467         uint value = msg.value - (oraclizePrice + fee);
468 
469         id = nextId++;
470         bytes32 oraclizeId = oraclize.query_withGasLimit.value(oraclizePrice)(
471             0,
472             "URL",
473             PRICE_FEED,
474             gasLimit
475         );
476         tasks[id].oraclizeId = oraclizeId;
477         tasks[id].toKissBTC = true;
478         tasks[id].sender = msg.sender;
479         tasks[id].value = value;
480         tasks[id].callback = callback;
481         tasks[id].timestamp = now;
482         oraclizeRequests[oraclizeId] = id;
483     }
484 
485     function transfer(address _to,
486                       uint256 _amount) noEther returns (bool success) {
487         if (_to == address(this)) {
488             sellKissBTCWithCallback(_amount, 0, DEFAULT_GAS_LIMIT);
489             return true;
490         } else {
491             return _transfer(_to, _amount);    // standard transfer
492         }
493     }
494 
495     function transferFrom(address _from,
496                           address _to,
497                           uint256 _amount) noEther returns (bool success) {
498         if (_to == address(this)) throw;       // not supported;
499         return _transferFrom(_from, _to, _amount);
500     }
501 
502     function sellKissBTC(uint256 _amount) returns (uint id) {
503         return sellKissBTCWithCallback(_amount, 0, DEFAULT_GAS_LIMIT);
504     }
505 
506     function sellKissBTCWithCallback(uint256 _amount,
507                                      address callback,
508                                      uint gasLimit) oraclizeAPI
509                                      returns (uint id) {
510         if (_amount < MIN_KISS_BTC_VALUE
511             || _amount > MAX_KISS_BTC_VALUE) throw;
512         if (balances[msg.sender] < _amount) throw;
513         if (gasLimit < DEFAULT_GAS_LIMIT) gasLimit = DEFAULT_GAS_LIMIT;
514 
515         if (!safeToSell(_amount)) throw;    // we need a bailout
516 
517         uint oraclizePrice = oraclize.getPrice("URL", gasLimit);
518         uint oraclizePriceKissBTC = inKissBTC(oraclizePrice);
519         uint fee = _amount / 100; // for the contract's coffers
520 
521         if (_amount <= oraclizePriceKissBTC + fee) throw;
522         uint value = _amount - (oraclizePriceKissBTC + fee);
523 
524         balances[msg.sender] -= _amount;
525         totalSupply -= _amount;
526         Transfer(msg.sender, address(this), _amount);
527 
528         id = nextId++;
529         bytes32 oraclizeId = oraclize.query_withGasLimit.value(oraclizePrice)(
530             0,
531             "URL",
532             PRICE_FEED,
533             gasLimit
534         );
535         tasks[id].oraclizeId = oraclizeId;
536         tasks[id].toKissBTC = false;
537         tasks[id].sender = msg.sender;
538         tasks[id].value = value;
539         tasks[id].callback = callback;
540         tasks[id].timestamp = now;
541         oraclizeRequests[oraclizeId] = id;
542     }
543 
544     function inKissBTC(uint amount) constant returns (uint) {
545         return (amount * exchangeRate) / 1000000000000000000;
546     }
547 
548     function inEther(uint amount) constant returns (uint) {
549         return (amount * 1000000000000000000) / exchangeRate;
550     }
551 
552     function safeToSell(uint amount) constant returns (bool) {
553         // Only allow sales when we have an extra 25 % in reserve.
554         return inEther(amount) * 125 < this.balance * 100;
555     }
556 
557     function __callback(bytes32 oraclizeId, string result) {
558         if (msg.sender != oraclize_cbAddress()) throw;
559         uint _exchangeRate = parseInt(result, 6) * 100;
560         if (_exchangeRate > 0) {
561             exchangeRate = _exchangeRate;
562         }
563 
564         uint id = oraclizeRequests[oraclizeId];
565         if (id == 0) return;
566 
567         address sender = tasks[id].sender;
568         address callback = tasks[id].callback;
569         if (tasks[id].toKissBTC) {
570             uint freshKissBTC = inKissBTC(tasks[id].value);
571 
572             totalSupply += freshKissBTC;
573             balances[sender] += freshKissBTC;
574             Transfer(address(this), sender, freshKissBTC);
575 
576             if (callback != 0) {
577                 // Note: If the callback throws an exception, everything
578                 // will be rolled back and you won't receive any tokens.
579                 // You can however invoke retryOraclizeRequest() in that case.
580                 KissBTCCallback(callback).kissBTCCallback.
581                     value(0)(id, freshKissBTC);
582             }
583         } else {
584             uint releasedEther = inEther(tasks[id].value);
585 
586             sender.send(releasedEther);
587 
588             if (callback != 0) {
589                 KissBTCCallback(callback).kissBTCCallback.
590                     value(0)(id, releasedEther);
591             }
592         }
593 
594         delete oraclizeRequests[oraclizeId];
595         delete tasks[id];
596     }
597 
598     function retryOraclizeRequest(uint id) oraclizeAPI {
599         if (tasks[id].oraclizeId == 0) throw;
600 
601         uint timePassed = now - tasks[id].timestamp;
602         if (timePassed < 60 minutes) throw;
603 
604         // Allow to retry a request to Oraclize if there has been
605         // no reply within the last hour for some reason. Because a
606         // failed callback might have been the problem, we discard those.
607         uint price = oraclize.getPrice("URL", DEFAULT_GAS_LIMIT);
608         bytes32 newOraclizeId = oraclize.query_withGasLimit.value(price)(
609             0,
610             "URL",
611             PRICE_FEED,
612             DEFAULT_GAS_LIMIT
613         );
614 
615         delete oraclizeRequests[tasks[id].oraclizeId];
616         tasks[id].oraclizeId = newOraclizeId;
617         tasks[id].callback = 0;
618         tasks[id].timestamp = now;
619         oraclizeRequests[newOraclizeId] = id;
620     }
621 
622     function whitelist(address _spender) returns (bool success) {
623         return approve(_spender, MAX_AMOUNT);
624     }
625 
626     function approveAndCall(address _spender,
627                             uint256 _amount,
628                             bytes _extraData) returns (bool success) {
629         approve(_spender, _amount);
630         ApprovalRecipient(_spender).receiveApproval.
631             value(0)(msg.sender, _amount, this, _extraData);
632         return true;
633     }
634 
635     function donate() {
636         // Send ether here if you would like to
637         // increase the contract's reserves.
638     }
639 
640     function toldYouItWouldWork() onlyowner {
641         if (now - timestamp < 24 hours) throw;  // only once a day
642 
643         uint obligations = inEther(totalSupply);
644         if (this.balance <= obligations * 3) throw;
645 
646         // Owner can withdraw 1 % of excess funds if the contract
647         // has more than three times its obligations in reserve.
648         uint excess = this.balance - (obligations * 3);
649         uint payment = excess / 100;
650         if (payment > 0) owner.send(payment);
651         timestamp = now;
652     }
653 
654     function setOwner(address _owner) onlyowner {
655         owner = _owner;
656     }
657 }