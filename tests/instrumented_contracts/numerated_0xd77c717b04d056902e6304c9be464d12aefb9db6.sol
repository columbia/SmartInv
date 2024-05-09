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
266 
267 
268     
269 
270 
271 
272 
273 
274 
275 contract Ethereum_twelve_bagger is usingOraclize
276 {
277 
278  							//declares global variables
279 string hexcomparisonchr;
280 string A;
281 string B;
282 
283 uint8 lotteryticket;
284 address creator;
285 int lastgainloss;
286 string lastresult;
287 string K;
288 string information;
289   
290  
291 address player;
292 uint8 gameResult;
293 uint128 wager; 
294  mapping (bytes32=>uint) bets;
295 mapping (bytes32 => address) gamesPlayer;
296  
297 
298    function  Ethereum_twelve_bagger() private 
299     { 
300         creator = msg.sender; 								
301     }
302 
303     function Set_your_game_number_between_1_15(string Set_your_game_number_between_1_15)			//sets game number
304  {
305 	player=msg.sender;
306     	A=Set_your_game_number_between_1_15;
307 	wager =uint128(msg.value);
308 	
309 	lastresult = "Waiting for a lottery number from Wolfram Alpha";
310 	lastgainloss = 0;
311 	B="The new right lottery number is not ready yet";
312 	information = "The new right lottery number is not ready yet";
313 	testWager();
314 	
315 	WolframAlpha();
316 }
317 
318      	 
319 	 
320 	
321 
322 
323     
324 
325     function WolframAlpha() private {
326 	if (wager == 0) return;		//if wager is 0, abort 
327         oraclize_setNetwork(networkID_testnet);
328         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
329      	bytes32 myid =  oraclize_query(0,"WolframAlpha", "random number between 1 and 15");
330 	bets[myid] = wager;
331 	gamesPlayer[myid] = player;
332     }
333 
334  	    function __callback(bytes32 myid, string result, bytes proof) {
335         if (msg.sender != oraclize_cbAddress()) throw;
336 	
337         B = result;
338 	
339 	wager=uint128(bets[myid]);
340 	player=gamesPlayer[myid];
341 	test(A,B);
342 	returnmoneycreator(gameResult,wager);
343 	return;
344         
345 }
346  
347 function test(string A,string B) private
348 { 
349 information ="The right lottery number is now ready. One Eth is 10**18 Wei.";
350 K="K";
351 bytes memory test = bytes(A);
352 bytes memory kill = bytes(K);
353 	 if (test[0]==kill[0] && player == creator)			//Creator can kill contract. Contract does not hold players money.
354 	{
355 		suicide(creator);} 
356  
357     	
358     
359 
360 
361 if (equal(A,B))
362 {
363 lastgainloss =(12*wager);
364 	    	lastresult = "Win!";
365 	    	player.send(wager * 12);  
366 
367 gameResult=0;
368 return;}
369 else 
370 {
371 lastgainloss = int(wager) * -1;
372 	    	lastresult = "Loss";
373 	    	gameResult=1;
374 	    									// Player lost. Return nothing.
375 	    	return;
376 
377 
378  
379 	}
380 }
381 
382 
383  
384 function testWager() private
385 {if((wager * 12) > this.balance) 					// contract has to have 12*wager funds to be able to pay out. (current balance includes the wager sent)
386     	{
387     		lastresult = "Bet is larger than games's ability to pay";
388     		lastgainloss = 0;
389     		player.send(wager); // return wager
390 		gameResult=0;
391 		wager=0;
392 		B="Bet is larger than games's ability to pay";
393 		information ="Bet is larger than games's ability to pay";
394     		return;
395 }
396 
397 else if (wager < 100000000000000000)					// Minimum bet is 0.1 eth 
398     	{
399     		lastresult = "Minimum bet is 0.1 eth";
400     		lastgainloss = 0;
401     		player.send(wager); // return wager
402 		gameResult=0;
403 		wager=0;
404 		B="Minimum bet is 0.1 eth";
405 		information ="Minimum bet is 0.1 eth";
406     		return;
407 }
408 
409 
410 
411 
412 	else if (wager == 0)
413     	{
414     		lastresult = "Wager was zero";
415     		lastgainloss = 0;
416 		gameResult=0;
417     		// nothing wagered, nothing returned
418     		return;
419     	}
420 }
421 
422 
423 
424     /// @dev Does a byte-by-byte lexicographical comparison of two strings.
425     /// @return a negative number if `_a` is smaller, zero if they are equal
426     /// and a positive numbe if `_b` is smaller.
427     function compare(string A, string B) private returns (int) {
428         bytes memory a = bytes(A);
429         bytes memory b = bytes(B);
430         uint minLength = a.length;
431         if (b.length < minLength) minLength = b.length;
432         //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
433         for (uint i = 0; i < minLength; i ++)
434             if (a[i] < b[i])
435                 return -1;
436             else if (a[i] > b[i])
437                 return 1;
438         if (a.length < b.length)
439             return -1;
440         else if (a.length > b.length)
441             return 1;
442         else
443             return 0;
444     }
445     /// @dev Compares two strings and returns true iff they are equal.
446     function equal(string A, string B) private returns (bool) 
447        {
448         return compare(A, B) == 0;
449 }
450 
451 function returnmoneycreator(uint8 gameResult,uint wager) private		//If game has over 50 eth, contract will send all additional eth to owner
452 	{
453 	if (gameResult==1&&this.balance>50000000000000000000)
454 	{creator.send(wager);
455 	return; 
456 	}
457  
458 	else if
459 	(
460 	gameResult==1&&this.balance>20000000000000000000)				//If game has over 20 eth, contract will send œ of any additional eth to owner
461 	{creator.send(wager/2);
462 	return; }
463 	}
464  
465 /**********
466 functions below give information about the game in Ethereum Wallet
467  **********/
468  
469  	function Results_of_the_last_round() constant returns (uint players_bet_in_Wei, string last_result,string Last_player_s_lottery_ticket,address last_player,string The_right_lottery_number,int Player_s_gain_or_Loss_in_Wei,string info)
470     { 
471    	last_player=player;	
472 	Last_player_s_lottery_ticket=A;
473 	The_right_lottery_number=B;
474 	last_result=lastresult;
475 	players_bet_in_Wei=wager;
476 	Player_s_gain_or_Loss_in_Wei=lastgainloss;
477 	info = information;
478 	
479  
480     }
481 
482  
483     
484    
485 	function Game_balance_in_Ethers() constant returns (uint balance, string info)
486     { 
487         info = "Choose number between 1 and 15. Win pays wager*12. Minimum bet is 0.1 eth. Maximum bet is game balance/12. Game balance is shown in full Ethers.";
488     	balance=(this.balance/10**18);
489 
490     }
491     
492    
493 }