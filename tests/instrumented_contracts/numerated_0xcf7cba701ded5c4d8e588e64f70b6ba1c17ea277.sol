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
259         return mint;
260     }
261     
262 
263 }
264 // </ORACLIZE_API>
265 
266 contract Dice is usingOraclize {
267 
268     uint public pwin = 5000; //probability of winning (10000 = 100%)
269     uint public edge = 200; //edge percentage (10000 = 100%)
270     uint public maxWin = 100; //max win (before edge is taken) as percentage of bankroll (10000 = 100%)
271     uint public minBet = 1 finney;
272     uint public maxInvestors = 5; //maximum number of investors
273     uint public ownerEdge = 50; //edge percentage (10000 = 100%)
274     uint public divestFee = 50; //divest fee percentage (10000 = 100%)
275     
276     uint constant safeGas = 25000;
277     uint constant oraclizeGasLimit = 150000;
278 
279     struct Investor {
280         address user;
281         uint capital;
282     }
283     mapping(uint => Investor) investors; //starts at 1
284     uint public numInvestors = 0;
285     mapping(address => uint) investorIDs;
286     uint public invested = 0;
287     
288     address owner;
289     bool public isStopped;
290 
291     struct Bet {
292         address user;
293         uint bet; // amount
294         uint roll; // result
295 	uint fee; 
296     }
297     mapping (bytes32 => Bet) bets;
298     bytes32[] betsKeys;
299     uint public amountWagered = 0;
300     int public profit = 0;
301     int public takenProfit = 0;
302     int public ownerProfit = 0;
303 
304     function Dice(uint pwinInitial, uint edgeInitial, uint maxWinInitial, uint minBetInitial, uint maxInvestorsInitial, uint ownerEdgeInitial, uint divestFeeInitial) {
305         
306         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
307         
308         pwin = pwinInitial;
309         edge = edgeInitial;
310         maxWin = maxWinInitial;
311         minBet = minBetInitial;
312         maxInvestors = maxInvestorsInitial;
313         ownerEdge = ownerEdgeInitial;
314         divestFee = divestFeeInitial;
315         
316         owner = msg.sender;
317     }
318 
319 
320     function() {
321         bet();
322     }
323 
324     function bet() {
325         if (isStopped) throw;
326         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", oraclizeGasLimit);
327         if (msg.value < oraclizeFee) throw;
328         uint betValue = msg.value - oraclizeFee;
329         if ((((betValue * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000) && (betValue >= minBet)) {
330             bytes32 myid = oraclize_query("URL", "json(https://api.random.org/json-rpc/1/invoke).result.random.data.0", 'BDXJhrVpBJ53o2CxlJRlQtZJKZqLYt5IQe+73YDS4HtNjS5HodbIB3tvfow7UquyAk085VkLnL9EpKgwqWQz7ZLdGvsQlRd2sKxIolNg9DbnfPspGqLhLbbYSVnN8CwvsjpAXcSSo3c+4cNwC90yF4oNibkvD3ytapoZ7goTSyoUYTfwSjnw3ti+HJVH7N3+c0iwOCqZjDdsGQUcX3m3S/IHWbOOQQ5osO4Lbj3Gg0x1UdNtfUzYCFY79nzYgWIQEFCuRBI0n6NBvBQW727+OsDRY0J/9/gjt8ucibHWic0=', oraclizeGasLimit); // encrypted arg: '\n{"jsonrpc":2.0,"method":"generateSignedIntegers","params":{"apiKey":"YOUR_API_KEY","n":1,"min":1,"max":10000},"id":1}'
331             bets[myid] = Bet(msg.sender, betValue, 0, oraclizeFee);
332             betsKeys.push(myid);
333         } else {
334             throw; // invalid bet size
335         }
336     }
337 
338     function numBets() constant returns(uint) {
339         return betsKeys.length;
340     }
341     
342     function minBetAmount() constant returns(uint) {
343         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", oraclizeGasLimit);
344         return oraclizeFee+minBet;
345     }
346     
347     function safeSend(address addr, uint value) internal {
348         if (!(addr.call.gas(safeGas).value(value)())){
349             ownerProfit += int(value);
350         }
351     }
352   
353     function __callback(bytes32 myid, string result, bytes proof) {
354         if (msg.sender != oraclize_cbAddress()) throw;
355         
356         Bet thisBet = bets[myid];
357         if (thisBet.bet>0) {
358             if ((isStopped == false)&&(((thisBet.bet * ((10000 - edge) - pwin)) / pwin ) <= maxWin * getBankroll() / 10000)) {
359                 uint roll = parseInt(result);
360                 if (roll<1 || roll>10000){
361                     safeSend(thisBet.user, thisBet.bet);
362                     return;    
363                 }
364 
365                 bets[myid].roll = roll;
366                 
367                 int profitDiff;
368                 if (roll-1 < pwin) { //win
369                     uint winAmount = (thisBet.bet * (10000 - edge)) / pwin;
370                     safeSend(thisBet.user, winAmount);
371                     profitDiff = int(thisBet.bet - winAmount);
372                 } else { //lose
373                     safeSend(thisBet.user, 1);
374                     profitDiff = int(thisBet.bet) - 1;
375                 }
376                 
377                 ownerProfit += (profitDiff*int(ownerEdge))/10000;
378                 profit += profitDiff-(profitDiff*int(ownerEdge))/10000;
379                 
380                 amountWagered += thisBet.bet;
381             } else {
382                 //bet is too big (bankroll may have changed since the bet was made)
383                 safeSend(thisBet.user, thisBet.bet);
384             }
385         }
386     }
387 
388     function getBet(uint id) constant returns(address, uint, uint, uint) {
389         if(id<betsKeys.length)
390         {
391             bytes32 betKey = betsKeys[id];
392             return (bets[betKey].user, bets[betKey].bet, bets[betKey].roll, bets[betKey].fee);
393         }
394     }
395 
396     function invest() {
397         if (isStopped) throw;
398         
399         if (investorIDs[msg.sender]>0) {
400             rebalance();
401             investors[investorIDs[msg.sender]].capital += msg.value;
402             invested += msg.value;
403         } else {
404             rebalance();
405             uint investorID = 0;
406             if (numInvestors<maxInvestors) {
407                 investorID = ++numInvestors;
408             } else {
409                 for (uint i=1; i<=numInvestors; i++) {
410                     if (investors[i].capital<msg.value && (investorID==0 || investors[i].capital<investors[investorID].capital)) {
411                         investorID = i;
412                     }
413                 }
414             }
415             if (investorID>0) {
416                 if (investors[investorID].capital>0) {
417                     divest(investors[investorID].user, investors[investorID].capital);
418                     investorIDs[investors[investorID].user] = 0;
419                 }
420                 if (investors[investorID].capital == 0 && investorIDs[investors[investorID].user] == 0) {
421                     investors[investorID].user = msg.sender;
422                     investors[investorID].capital = msg.value;
423                     invested += msg.value;
424                     investorIDs[msg.sender] = investorID;
425                 } else {
426                     throw;
427                 }
428             } else {
429                 throw;
430             }
431         }
432     }
433 
434     function rebalance() private {
435         if (takenProfit != profit) {
436             uint newInvested = 0;
437             uint initialBankroll = getBankroll();
438             for (uint i=1; i<=numInvestors; i++) {
439                 investors[i].capital = getBalance(investors[i].user);
440                 newInvested += investors[i].capital;
441             }
442             invested = newInvested;
443             if (newInvested != initialBankroll && numInvestors>0) {
444                 ownerProfit += int(initialBankroll - newInvested); //give the rounding error to the first investor
445                 invested += (initialBankroll - newInvested);
446             }
447             takenProfit = profit;
448         }
449     }
450 
451     function divest(address user, uint amount) private {
452         if (investorIDs[user]>0) {
453             rebalance();
454             if (amount>getBalance(user)) {
455                 amount = getBalance(user);
456             }
457             investors[investorIDs[user]].capital -= amount;
458             invested -= amount;
459             
460             uint newAmount = (amount*divestFee)/10000; // take a fee from the deinvest amount
461             ownerProfit += int(newAmount);
462             safeSend(user, (amount-newAmount));
463         }
464     }
465 
466     function divest(uint amount) {
467         if (msg.value>0) throw;
468         divest(msg.sender, amount);
469     }
470 
471     function divest() {
472         if (msg.value>0) throw;
473         divest(msg.sender, getBalance(msg.sender));
474     }
475 
476     function getBalance(address user) constant returns(uint) {
477         if (investorIDs[user]>0 && invested>0) {
478             return investors[investorIDs[user]].capital * getBankroll() / invested;
479         } else {
480             return 0;
481         }
482     }
483 
484     function getBankroll() constant returns(uint) {
485         uint bankroll = uint(int(invested)+profit+ownerProfit-takenProfit);
486         if (this.balance < bankroll){
487             log0("bankroll_mismatch");
488             bankroll = this.balance;
489         }
490         return bankroll;
491     }
492 
493     function getMinInvestment() constant returns(uint) {
494         if (numInvestors<maxInvestors) {
495             return 0;
496         } else {
497             uint investorID;
498             for (uint i=1; i<=numInvestors; i++) {
499                 if (investorID==0 || getBalance(investors[i].user)<getBalance(investors[investorID].user)) {
500                     investorID = i;
501                 }
502             }
503             return getBalance(investors[investorID].user);
504         }
505     }
506 
507     function getStatus() constant returns(uint, uint, uint, uint, uint, uint, int, uint, uint) {
508         return (getBankroll(), pwin, edge, maxWin, minBet, amountWagered, profit, getMinInvestment(), betsKeys.length);
509     }
510 
511     function stopContract() {
512         if (owner != msg.sender) throw;
513         isStopped = true;
514     }
515   
516     function resumeContract() {
517         if (owner != msg.sender) throw;
518         isStopped = false;
519     }
520     
521     function forceDivestAll() {
522         forceDivestAll(false);
523     }
524     
525     function forceDivestAll(bool ownerTakeChangeAndProfit) {
526         if (owner != msg.sender) throw;
527         for (uint investorID=1; investorID<=numInvestors; investorID++) {
528             divest(investors[investorID].user, getBalance(investors[investorID].user));
529         }
530         if (ownerTakeChangeAndProfit) owner.send(this.balance);
531     }
532     
533     function ownerTakeProfit() {
534         ownerTakeProfit(false);
535     }
536     
537     function ownerTakeProfit(bool takeChange) {
538         if (owner != msg.sender) throw;
539         if (takeChange){
540             uint investorsCapital = 0;
541             for (uint i=1; i<=numInvestors; i++) {
542                 investorsCapital += investors[i].capital;
543             }
544             if ((investorsCapital == 0)&&(this.balance != uint(ownerProfit))){
545                 owner.send(this.balance);
546                 ownerProfit = 0;
547             }
548         } else {
549             owner.send(uint(ownerProfit));
550             ownerProfit = 0;
551         }
552     }
553    
554 }