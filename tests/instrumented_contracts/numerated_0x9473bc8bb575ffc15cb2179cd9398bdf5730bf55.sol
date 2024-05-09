1 pragma solidity ^0.4.7;
2 contract TheEthereumLottery {
3  /*
4     Brief introduction:
5     
6     To play you need to pick 4 numbers (range 0-255) and provide them sorted to Play() function.
7     To win you need to hit at least 1 number out of 4 WinningNums which will be announced once every week
8     (or more often if the lottery will become more popular). If you hit all of the 4 numbers you will win
9     about 10 million times more than you payed for lottery ticket. The exact values are provided as GuessXOutOf4
10     entries in Ledger - notice that they are provided in Wei, not Ether (10^18 Wei = Ether).
11     Use Withdraw() function to pay out.
12 
13 
14     The advantage of TheEthereumLottery is that it uses secret random value which only owner knows (called TheRand).
15     A hash of TheRand (called OpeningHash) is announced at the beginning of every draw (lets say draw number N) - 
16     at this moment ticket price and the values of GuessXOutOf4 are publicly available and can not be changed.
17     When draw N+1 is announced in a block X, a hash of block X-1 is assigned to ClosingHash field of draw N.
18     After few minutes, owner announces TheRand which satisfy following expression: sha3(TheRand)==drawN.OpeningHash
19     then Rand32B=sha3(TheRand, ClosingHash) is calculated an treated as a source for WinningNumbers, 
20     also ClosingHash is changed to Rand32B as it might be more interesting for someone watching lottery ledger
21     to see that number instead of hash of some block. 
22 
23     This approach (1) unable players to cheat, as as long as no one knows TheRand, 
24     no one can predict what WinningNums will be, (2) unable owner to influence the WinningNums (in order to
25     reduce average amount won) because OpeningHash=sha3(TheRand) was public before bets were made, and (3) reduces 
26     owner capability of playing it's own lottery and making winning bets to very short window of one
27     exactly the same block as new draw was announced - so anyone, with big probability, can think that if winning
28     bet was made in this particular block - probably it was the owner, especially if no more bets were made 
29     at this block (which is very likely).
30 
31     Withdraw is possible only after TheRand was announced, if the owner will not announce TheRand in 2 weeks,
32     players can use Refund function in order to refund their ETH used to make bet. 
33     That moment is called ExpirationTime on contract Ledger (which is visible from JSON interface).
34  */
35 /*
36   Name:
37   TheEthereumLottery
38 
39   JSON interface:
40 
41 [{"constant":true,"inputs":[],"name":"Announcements","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"IndexOfCurrentDraw","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"ledger","outputs":[{"name":"WinningNum1","type":"uint8"},{"name":"WinningNum2","type":"uint8"},{"name":"WinningNum3","type":"uint8"},{"name":"WinningNum4","type":"uint8"},{"name":"ClosingHash","type":"bytes32"},{"name":"OpeningHash","type":"bytes32"},{"name":"Guess4OutOf4","type":"uint256"},{"name":"Guess3OutOf4","type":"uint256"},{"name":"Guess2OutOf4","type":"uint256"},{"name":"Guess1OutOf4","type":"uint256"},{"name":"PriceOfTicket","type":"uint256"},{"name":"ExpirationTime","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"TheRand","type":"bytes32"}],"name":"CheckHash","outputs":[{"name":"OpeningHash","type":"bytes32"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"DrawIndex","type":"uint8"},{"name":"PlayerAddress","type":"address"}],"name":"MyBet","outputs":[{"name":"Nums","type":"uint8[4]"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"referral_fee","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"referral_ledger","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"MyNum1","type":"uint8"},{"name":"MyNum2","type":"uint8"},{"name":"MyNum3","type":"uint8"},{"name":"MyNum4","type":"uint8"}],"name":"Play","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"DrawIndex","type":"uint32"}],"name":"Withdraw","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"DrawIndex","type":"uint32"}],"name":"Refund","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"MyNum1","type":"uint8"},{"name":"MyNum2","type":"uint8"},{"name":"MyNum3","type":"uint8"},{"name":"MyNum4","type":"uint8"},{"name":"ref","type":"address"}],"name":"PlayReferred","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[],"name":"Withdraw_referral","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"Deposit_referral","outputs":[],"payable":true,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"IndexOfDraw","type":"uint256"},{"indexed":false,"name":"OpeningHash","type":"bytes32"},{"indexed":false,"name":"PriceOfTicketInWei","type":"uint256"},{"indexed":false,"name":"WeiToWin","type":"uint256"}],"name":"NewDrawReadyToPlay","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"IndexOfDraw","type":"uint32"},{"indexed":false,"name":"WinningNumber1","type":"uint8"},{"indexed":false,"name":"WinningNumber2","type":"uint8"},{"indexed":false,"name":"WinningNumber3","type":"uint8"},{"indexed":false,"name":"WinningNumber4","type":"uint8"},{"indexed":false,"name":"TheRand","type":"bytes32"}],"name":"DrawReadyToPayout","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"Wei","type":"uint256"}],"name":"PlayerWon","type":"event"}]
42 
43 */
44 //constructor
45 function TheEthereumLottery()
46 {
47   owner=msg.sender;
48   ledger.length=0;
49   IndexOfCurrentDraw=0;
50   referral_fee=90;
51 }
52 modifier OnlyOwner()
53 { // Modifier
54   if (msg.sender != owner) throw;
55   _;
56 }
57 address owner;
58 string public Announcements;//just additional feature
59 uint public IndexOfCurrentDraw;//starting from 0
60 uint8 public referral_fee;
61 mapping(address=>uint256) public referral_ledger;
62 struct bet_t {
63   address referral;
64   uint8[4] Nums;
65   bool can_withdraw;//default==false
66 }
67 struct ledger_t {
68   uint8 WinningNum1;
69   uint8 WinningNum2;
70   uint8 WinningNum3;
71   uint8 WinningNum4;
72   bytes32 ClosingHash;
73   bytes32 OpeningHash;
74   mapping(address=>bet_t) bets;
75   uint Guess4OutOf4;
76   uint Guess3OutOf4;
77   uint Guess2OutOf4;
78   uint Guess1OutOf4;
79   uint PriceOfTicket;
80   uint ExpirationTime;//for eventual refunds only, ~2 weeks after draw announced
81 }
82 ledger_t[] public ledger;
83  
84 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
85 //@@@@@@@@@@@ Here begins what probably you want to analyze @@@@@@@@@@@@
86 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
87 function next_draw(bytes32 new_hash,
88 	  uint priceofticket,
89 	  uint guess4outof4,
90 	  uint guess3outof4,
91 	  uint guess2outof4,
92 	  uint guess1outof4
93 	  )
94 OnlyOwner
95 {
96   ledger.length++;
97   ledger[IndexOfCurrentDraw].ClosingHash =
98     //sha3(block.blockhash(block.number-1));               //this, or
99     //sha3(block.blockhash(block.number-1),block.coinbase);//this adds complexity, but safety remains the same
100     block.blockhash(block.number-1);//adds noise to the previous draw
101   //if you are just checking how it works, just pass the comment below, and come back when you finish analyzing
102   //the contract - it explains how the owner could win this lottery 
103   //if the owner was about to cheat, he has to make a bet, and then use this f-n. both in a single block.
104   //its because if you know TheRand and blockhash of a last block before new draw then you can determine the numbers
105   //achieving it would be actually simple, another contract is needed which would get signed owner tx of this f-n call
106   //and just calculate what the numbers would be (the previous block hash is available), play with that nums,
107   //and then run this f-n. It is guaranteed that both actions are made in a single block, as it is a single call
108   //so if someone have made winning bet in exactly the same block as announcement of next draw,
109   //then you can be suspicious that it was the owner
110   //also assuming this scenario, TheRand needs to be present on that contract - so if transaction is not mined
111   //immediately - it makes a window for anyone to do the same and win.
112   IndexOfCurrentDraw=ledger.length-1;
113   ledger[IndexOfCurrentDraw].OpeningHash = new_hash;
114   ledger[IndexOfCurrentDraw].Guess4OutOf4=guess4outof4;
115   ledger[IndexOfCurrentDraw].Guess3OutOf4=guess3outof4;
116   ledger[IndexOfCurrentDraw].Guess2OutOf4=guess2outof4;
117   ledger[IndexOfCurrentDraw].Guess1OutOf4=guess1outof4;
118   ledger[IndexOfCurrentDraw].PriceOfTicket=priceofticket;
119   ledger[IndexOfCurrentDraw].ExpirationTime=now + 2 weeks;//You can refund after ExpirationTime if owner will not announce TheRand satisfying TheHash
120   NewDrawReadyToPlay(IndexOfCurrentDraw, new_hash, priceofticket, guess4outof4);//event
121 }
122 function announce_therand(uint32 index,
123 			  bytes32 the_rand
124 			  )
125 OnlyOwner
126 {
127   if(sha3(the_rand)
128      !=
129      ledger[index].OpeningHash)
130     throw;//this implies that if Numbers are present, broadcasted TheRand has to satisfy TheHash
131 
132 
133   bytes32 combined_rand=sha3(the_rand, ledger[index].ClosingHash);//from this number we'll calculate WinningNums
134   //usually the last 4 Bytes will be the WinningNumbers, but it is not always true, as some Byte could
135   //be the same, then we need to take one more Byte from combined_rand and so on
136 
137   ledger[index].ClosingHash = combined_rand;//changes the closing blockhash to seed for WinningNums
138     //this line is useless from the perspective of lottery
139     //but maybe some of the players will find it interesting that something
140     //which is connected to the WinningNums is present in a ledger
141 
142 
143   //the algorithm of assigning an int from some range to single bet takes too much code
144   uint8[4] memory Numbers;//relying on that combined_rand should be random - lets pick Nums into this array 
145 
146   uint8 i=0;//i = how many numbers are picked
147   while(i<4)
148     {
149       Numbers[i]=uint8(combined_rand);//same as '=combined_rand%256;'
150       combined_rand>>=8;//same as combined_rand/=256;
151       for(uint j=0;j<i;++j)//is newly picked val in a set?
152 	if(Numbers[j]==Numbers[i]) {--i;break;}//yes, break back to while loop and look for another Num[i]
153       ++i;
154     }
155   //probability that in 32 random bytes there was only 3 or less different ones ~=2.65e-55
156   //it's like winning this lottery 2.16*10^46 times in a row
157   //p.s. there are 174792640 possible combinations of picking 4 numbers out of 256
158 
159   //now we have to sort the values
160   for(uint8 n=4;n>1;n--)//bubble sort
161     {
162       bool sorted=true; 
163       for(uint8 k=0;k<n-1;++k)
164 	if(Numbers[k] > Numbers[k+1])//then mark array as not sorted & swap
165 	  {
166 	    sorted=false;
167 	    (Numbers[k], Numbers[k+1])=(Numbers[k+1], Numbers[k]);
168 	  }
169       if(sorted) break;//breaks as soon as the array is sorted
170     }
171 
172   
173   ledger[index].WinningNum1 = Numbers[0];
174   ledger[index].WinningNum2 = Numbers[1];
175   ledger[index].WinningNum3 = Numbers[2];
176   ledger[index].WinningNum4 = Numbers[3];
177   
178   DrawReadyToPayout(index,
179 		    Numbers[0],Numbers[1],Numbers[2],Numbers[3],
180 		    the_rand);//event
181 }
182 
183 function PlayReferred(uint8 MyNum1,
184 		      uint8 MyNum2,
185 		      uint8 MyNum3,
186 		      uint8 MyNum4,
187 		      address ref
188 		      )
189 payable
190 {
191   if(msg.value != ledger[IndexOfCurrentDraw].PriceOfTicket ||//to play you need to pay 
192      ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[3] != 0)//if your bet already exist
193     throw;
194 
195   //if numbers are not sorted
196   if(MyNum1 >= MyNum2 ||
197      MyNum2 >= MyNum3 ||
198      MyNum3 >= MyNum4
199      )
200     throw;//because you should sort the values yourself
201   if(ref!=0)//when there is no refferal, function is cheaper for ~20k gas
202     ledger[IndexOfCurrentDraw].bets[msg.sender].referral=ref;
203   ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[0]=MyNum1;
204   ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[1]=MyNum2;
205   ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[2]=MyNum3;
206   ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[3]=MyNum4;
207   ledger[IndexOfCurrentDraw].bets[msg.sender].can_withdraw=true;
208 }
209 // Play wrapper:
210 function Play(uint8 MyNum1,
211 	      uint8 MyNum2,
212 	      uint8 MyNum3,
213 	      uint8 MyNum4
214 	      )
215 {
216   PlayReferred(MyNum1,
217 	       MyNum2,
218 	       MyNum3,
219 	       MyNum4,
220 	       0//no referral
221 	       );
222 }
223 function Deposit_referral()//this function is not mandatory to become referral
224   payable//might be used to not withdraw all the funds at once or to invest
225 {//probably needed only at the beginnings
226   referral_ledger[msg.sender]+=msg.value;
227 }
228 function Withdraw_referral()
229 {
230   uint val=referral_ledger[msg.sender];
231   referral_ledger[msg.sender]=0;
232   if(!msg.sender.send(val)) //payment
233     throw;
234 }
235 function set_referral_fee(uint8 new_fee)
236 OnlyOwner
237 {
238   if(new_fee<50 || new_fee>100)
239     throw;//referrals have at least 50% of the income
240   referral_fee=new_fee;
241 }
242 function Withdraw(uint32 DrawIndex)
243 {
244   //if(msg.value!=0) //compiler deals with that, as there is no payable modifier in this f-n
245   //  throw;//this function is free
246 
247   if(ledger[DrawIndex].bets[msg.sender].can_withdraw==false)
248     throw;//throw if player didnt played
249 
250   //by default, every non existing value is equal to 0
251   //so if there was no announcement WinningNums are zeros
252   if(ledger[DrawIndex].WinningNum4 == 0)//the least possible value == 3
253     throw;//this condition checks if the numbers were announced
254   //see announce_therand f-n to see why this check is enough
255   
256   uint8 hits=0;
257   uint8 i=0;
258   uint8 j=0;
259   uint8[4] memory playernum=ledger[DrawIndex].bets[msg.sender].Nums;
260   uint8[4] memory nums;
261   (nums[0],nums[1],nums[2],nums[3])=
262     (ledger[DrawIndex].WinningNum1,
263      ledger[DrawIndex].WinningNum2,
264      ledger[DrawIndex].WinningNum3,
265      ledger[DrawIndex].WinningNum4);
266   //data ready
267   
268   while(i<4)//count player hits
269     {//both arrays are sorted
270       while(j<4 && playernum[j] < nums[i]) ++j;
271       if(j==4) break;//nothing more to check - break loop here
272       if(playernum[j] == nums[i]) ++hits;
273       ++i;
274     }
275   if(hits==0) throw;
276   uint256 win=0;
277   if(hits==1) win=ledger[DrawIndex].Guess1OutOf4;
278   if(hits==2) win=ledger[DrawIndex].Guess2OutOf4;
279   if(hits==3) win=ledger[DrawIndex].Guess3OutOf4;
280   if(hits==4) win=ledger[DrawIndex].Guess4OutOf4;
281     
282   ledger[DrawIndex].bets[msg.sender].can_withdraw=false;
283   if(!msg.sender.send(win)) //payment
284     throw;
285 
286   if(ledger[DrawIndex].bets[msg.sender].referral==0)//it was not referred bet
287     referral_ledger[owner]+=win/100;
288   else
289     {
290       referral_ledger[ledger[DrawIndex].bets[msg.sender].referral]+=
291 	win/10000*referral_fee;//(win/100)*(referral_fee/100);
292       referral_ledger[owner]+=
293 	win/10000*(100-referral_fee);//(win/100)*((100-referral_fee)/100);
294     }
295 
296   
297   PlayerWon(win);//event
298 }
299 function Refund(uint32 DrawIndex)
300 {
301   //if(msg.value!=0) //compiler deals with that, as there is no payable modifier in this f-n
302   //  throw;//this function is free
303 
304   if(ledger[DrawIndex].WinningNum4 != 0)//if TheRand was announced, WinningNum4 >= 3
305     throw; //no refund if there was a valid announce
306 
307   if(now < ledger[DrawIndex].ExpirationTime)
308     throw;//no refund while there is still TIME to announce TheRand
309   
310  
311   if(ledger[DrawIndex].bets[msg.sender].can_withdraw==false)
312     throw;//throw if player didnt played or already refunded
313   
314   ledger[DrawIndex].bets[msg.sender].can_withdraw=false;
315   if(!msg.sender.send(ledger[DrawIndex].PriceOfTicket)) //refund
316     throw;
317 }
318 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
319 //@@@@@@@@@@@ Here ends what probably you wanted to analyze @@@@@@@@@@@@
320 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
321 
322 function CheckHash(bytes32 TheRand)
323   constant returns(bytes32 OpeningHash)
324 {
325   return sha3(TheRand);
326 }
327 function MyBet(uint8 DrawIndex, address PlayerAddress)
328   constant returns (uint8[4] Nums)
329 {//check your nums
330   return ledger[DrawIndex].bets[PlayerAddress].Nums;
331 }
332 function announce(string MSG)
333   OnlyOwner
334 {
335   Announcements=MSG;
336 }
337 event NewDrawReadyToPlay(uint indexed IndexOfDraw,
338 			 bytes32 OpeningHash,
339 			 uint PriceOfTicketInWei,
340 			 uint WeiToWin);
341 event DrawReadyToPayout(uint32 indexed IndexOfDraw,
342 			uint8 WinningNumber1,
343 			uint8 WinningNumber2,
344 			uint8 WinningNumber3,
345 			uint8 WinningNumber4,
346 			bytes32 TheRand);
347 event PlayerWon(uint Wei);
348 
349 }//contract