1 contract TheEthereumLottery {
2  /*
3     Brief introduction:
4     
5     To play you need to pick 4 numbers (range 0-255) and provide them sorted to Play() function.
6     To win you need to hit at least 1 number out of 4 WinningNums which will be announced once every week
7     (or more often if the lottery will become more popular). If you hit all of the 4 numbers you will win
8     about 50 milion times more than you payed fot lottery ticket. The exact values are provided as GuessXOutOf4
9     entries in Ledger - notice that they are provided in Wei, not Ether (10^18 Wei = Ether).
10     Use Withdraw() function to pay out.
11 
12 
13     The advantage of TheEthereumLottery is that it is not using any pseudo-random numbers.
14     The winning numbers are known from the announcement of next draw - at this moment the values of GuessXOutOf4,
15     and ticket price is publically available. 
16     To unable cheating of contract owner there a hash (called "TheHash" in contract ledger) 
17     equal to sha3(WinningNums, TheRand) is provided.
18     While announcing WinningNums the owner has to provide also a valid "TheRand" value, which satisfy 
19     following expression: TheHash == sha3(WinningNums, TheRand). 
20     If hashes do not match - the player can refund his Ether used for lottery ticket.
21     As by default all non existing values equal to 0, from the perspective of blockchain 
22     the hashes do not match at the moment of announcing next draw from the perspective of blockchain. 
23     This is why refund is possible only after 2 weeks of announcing next draw,
24     this moment is called ExpirencyTime on contract Ledger.
25  */
26 /*
27   Name:
28   TheEthereumLottery
29 
30   Contract Address:
31   0x7698392fff47d8d4cee21295ad1f31b6ced9ad66
32 
33   JSON interface:
34 
35 [{"constant":false,"inputs":[{"name":"MyNum1","type":"uint8"},{"name":"MyNum2","type":"uint8"},{"name":"MyNum3","type":"uint8"},{"name":"MyNum4","type":"uint8"}],"name":"Play","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"DrawNumber","type":"uint32"}],"name":"Withdraw","outputs":[],"type":"function"},{"constant":true,"inputs":[],"name":"Announcements","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":false,"inputs":[{"name":"DrawNumber","type":"uint32"}],"name":"Refund","outputs":[],"type":"function"},{"constant":true,"inputs":[],"name":"IndexOfCurrentDraw","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"ledger","outputs":[{"name":"WinningNum1","type":"uint8"},{"name":"WinningNum2","type":"uint8"},{"name":"WinningNum3","type":"uint8"},{"name":"WinningNum4","type":"uint8"},{"name":"TheRand","type":"bytes32"},{"name":"TheHash","type":"bytes32"},{"name":"Guess4OutOf4","type":"uint256"},{"name":"Guess3OutOf4","type":"uint256"},{"name":"Guess2OutOf4","type":"uint256"},{"name":"Guess1OutOf4","type":"uint256"},{"name":"PriceOfTicket","type":"uint256"},{"name":"ExpirencyTime","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"DrawNumber","type":"uint8"},{"name":"PlayerAddress","type":"address"}],"name":"MyBet","outputs":[{"name":"Nums","type":"uint8[4]"}],"type":"function"},{"inputs":[],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"IndexOfDraw","type":"uint256"},{"indexed":false,"name":"TheHash","type":"bytes32"},{"indexed":false,"name":"PriceOfTicketInWei","type":"uint256"},{"indexed":false,"name":"WeiToWin","type":"uint256"}],"name":"NewDrawReadyToPlay","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"IndexOfDraw","type":"uint32"},{"indexed":false,"name":"WinningNumber1","type":"uint8"},{"indexed":false,"name":"WinningNumber2","type":"uint8"},{"indexed":false,"name":"WinningNumber3","type":"uint8"},{"indexed":false,"name":"WinningNumber4","type":"uint8"},{"indexed":false,"name":"TheRand","type":"bytes32"}],"name":"DrawReadyToPayout","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"Wei","type":"uint256"}],"name":"PlayerWon","type":"event"},{"constant":true,"inputs":[{"name":"Num1","type":"uint8"},{"name":"Num2","type":"uint8"},{"name":"Num3","type":"uint8"},{"name":"Num4","type":"uint8"},{"name":"TheRandomValue","type":"bytes32"}],"name":"CheckHash","outputs":[{"name":"TheHash","type":"bytes32"}],"type":"function"}]
36 */
37 
38 
39   
40 //constructor
41 function TheEthereumLottery()
42 {
43   owner=msg.sender;
44   ledger.length=0;
45 }
46 modifier OnlyOwner()
47 { // Modifier
48   if (msg.sender != owner) throw;
49   _
50 }
51 address owner;
52 string public Announcements;//just additional feature
53 uint public IndexOfCurrentDraw;//starting from 0
54 struct bet_t {
55   uint8[4] Nums;
56   bool can_withdraw;//default==false
57 }
58 struct ledger_t {
59   uint8 WinningNum1;
60   uint8 WinningNum2;
61   uint8 WinningNum3;
62   uint8 WinningNum4;
63   bytes32 TheRand;
64   bytes32 TheHash;
65   mapping(address=>bet_t) bets;
66   uint Guess4OutOf4;
67   uint Guess3OutOf4;
68   uint Guess2OutOf4;
69   uint Guess1OutOf4;
70   uint PriceOfTicket;
71   uint ExpirencyTime;//for eventual refunds only, approx 2 weeks after draw announced
72 }
73 ledger_t[] public ledger;
74  
75 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
76 //@@@@@@@@@@@ Here begines what probably you want to analise @@@@@@@@@@@
77 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
78 function next_draw(bytes32 new_hash,
79 	  uint priceofticket,
80 	  uint guess4outof4,
81 	  uint guess3outof4,
82 	  uint guess2outof4,
83 	  uint guess1outof4
84 	  )
85 OnlyOwner
86 {
87   ledger.length++;
88   IndexOfCurrentDraw=ledger.length-1;
89   ledger[IndexOfCurrentDraw].TheHash = new_hash;
90   ledger[IndexOfCurrentDraw].Guess4OutOf4=guess4outof4;
91   ledger[IndexOfCurrentDraw].Guess3OutOf4=guess3outof4;
92   ledger[IndexOfCurrentDraw].Guess2OutOf4=guess2outof4;
93   ledger[IndexOfCurrentDraw].Guess1OutOf4=guess1outof4;
94   ledger[IndexOfCurrentDraw].PriceOfTicket=priceofticket;
95   ledger[IndexOfCurrentDraw].ExpirencyTime=now + 2 weeks;//You can refund after ExpirencyTime if owner will not announce winningnums+TheRand satisfying TheHash 
96 
97   NewDrawReadyToPlay(IndexOfCurrentDraw, new_hash, priceofticket, guess4outof4);//event
98 }
99 function announce_numbers(uint8 no1,
100 			  uint8 no2,
101 			  uint8 no3,
102 			  uint8 no4,
103 			  uint32 index,
104 			  bytes32 the_rand
105 			  )
106 OnlyOwner
107 {
108   ledger[index].WinningNum1 = no1;
109   ledger[index].WinningNum2 = no2;
110   ledger[index].WinningNum3 = no3;
111   ledger[index].WinningNum4 = no4;
112   ledger[index].TheRand = the_rand;
113 
114   DrawReadyToPayout(index,
115 		    no1, no2, no3, no4,
116 		    the_rand);//event
117 }
118 function Play(uint8 MyNum1,
119 	      uint8 MyNum2,
120 	      uint8 MyNum3,
121 	      uint8 MyNum4
122 	      )
123 {
124   if(msg.value != ledger[IndexOfCurrentDraw].PriceOfTicket ||//to play you need to pay 
125      ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[3] != 0)//if your bet already exist
126     throw;
127 
128   //if numbers are sorted
129   if(MyNum1 >= MyNum2 ||
130      MyNum2 >= MyNum3 ||
131      MyNum3 >= MyNum4
132      )
133     throw;//because you should sort the values yourself
134 
135   ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[0]=MyNum1;
136   ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[1]=MyNum2;
137   ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[2]=MyNum3;
138   ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[3]=MyNum4;
139   ledger[IndexOfCurrentDraw].bets[msg.sender].can_withdraw=true;
140 
141 
142   //##########################################################################3
143   //another approach - with non-sorted input 
144   /*
145   if(msg.value != ledger[IndexOfCurrentDraw].PriceOfTicket)
146     throw;
147 
148   uint8[4] memory InputData;
149   (InputData[0],InputData[1],InputData[2],InputData[3])
150     =(MyNum1,MyNum2,MyNum3,MyNum4);
151   for(uint8 n=4;n>1;n--)//check if input is sorted / bubble sort
152     {
153       bool sorted=true; 
154       for(uint8 i=0;i<n-1;i++)
155 	if(InputData[i] > InputData[i+1])//then mark array as not sorted & swap
156 	  {
157 	    sorted=false;
158 	    (InputData[i], InputData[i+1])=(InputData[i+1], InputData[i]);
159 	  }
160       if(sorted) break;//breaks as soon as the array is sorted
161     }
162   //now we can assign
163   ledger[IndexOfCurrentDraw].bets[msg.sender].Nums=InputData;
164   ledger[IndexOfCurrentDraw].bets[msg.sender].can_withdraw=true;
165   */
166 
167   
168 }
169 	
170 function Withdraw(uint32 DrawNumber)
171 {
172   if(msg.value!=0)
173     throw;//this function is free
174 
175   if(ledger[DrawNumber].bets[msg.sender].can_withdraw==false)
176     throw;//throw if player didnt played
177 
178   //by default, every non existing value is equal to 0
179   //so if there was no announcement WinningNums are zeros
180   if(ledger[DrawNumber].WinningNum4==0)//the least possible value == 3
181     throw;//this condition checks if the numbers were announced
182   //it's more gas-efficient than checking sha3(No1,No2,No3,No4,TheRand)
183   //and even if the hashes does not match then player benefits because of chance of win AND beeing able to Refund
184 
185   
186   uint8 hits=0;
187   uint8 i=0;
188   uint8 j=0;
189   uint8[4] memory playernum=ledger[DrawNumber].bets[msg.sender].Nums;
190   uint8[4] memory nums;
191   (nums[0],nums[1],nums[2],nums[3])=
192     (ledger[DrawNumber].WinningNum1,
193      ledger[DrawNumber].WinningNum2,
194      ledger[DrawNumber].WinningNum3,
195      ledger[DrawNumber].WinningNum4);
196   //data ready
197   
198   while(i<4)//count player hits
199     {//both arrays are sorted
200       while(j<4 && playernum[j] < nums[i]) ++j;
201       if(j==4) break;//nothing more to check - break loop here
202       if(playernum[j] == nums[i]) ++hits;
203       ++i;
204     }
205   if(hits==0) throw;
206   uint256 win=0;
207   if(hits==1) win=ledger[DrawNumber].Guess1OutOf4;
208   if(hits==2) win=ledger[DrawNumber].Guess2OutOf4;
209   if(hits==3) win=ledger[DrawNumber].Guess3OutOf4;
210   if(hits==4) win=ledger[DrawNumber].Guess4OutOf4;
211     
212   ledger[DrawNumber].bets[msg.sender].can_withdraw=false;
213   if(!msg.sender.send(win)) //payment
214     throw;
215   PlayerWon(win);//event
216   if(!owner.send(win/100))
217     throw;//the fee is less than 1% (fee=1/101)
218 }
219 function Refund(uint32 DrawNumber)
220 {
221   if(msg.value!=0)
222     throw;//this function is free
223 
224   if(
225      sha3( ledger[DrawNumber].WinningNum1,
226 	   ledger[DrawNumber].WinningNum2,
227 	   ledger[DrawNumber].WinningNum3,
228 	   ledger[DrawNumber].WinningNum4,
229 	   ledger[DrawNumber].TheRand)
230      ==
231      ledger[DrawNumber].TheHash ) throw;
232   //no refund if hashes match
233 
234   if(now < ledger[DrawNumber].ExpirencyTime)
235     throw;//no refund while there is still TIME to announce nums & TheRand
236   
237  
238   if(ledger[DrawNumber].bets[msg.sender].can_withdraw==false)
239     throw;//throw if player didnt played
240   
241   ledger[DrawNumber].bets[msg.sender].can_withdraw=false;
242   if(!msg.sender.send(ledger[DrawNumber].PriceOfTicket)) //refund
243     throw;
244 }
245 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
246 //@@@@@@@@@@@ Here ends what probably you wanted to analise @@@@@@@@@@@@
247 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
248 
249 function CheckHash(uint8 Num1,
250 		   uint8 Num2,
251 		   uint8 Num3,
252 		   uint8 Num4,
253 		   bytes32 TheRandomValue
254 		   )
255   constant returns(bytes32 TheHash)
256 {
257   return sha3(Num1, Num2, Num3, Num4, TheRandomValue);
258 }
259 function MyBet(uint8 DrawNumber, address PlayerAddress)
260   constant returns (uint8[4] Nums)
261 {//check your nums
262   return ledger[DrawNumber].bets[PlayerAddress].Nums;
263 }
264 function announce(string MSG)
265   OnlyOwner
266 {
267   Announcements=MSG;
268 }
269 event NewDrawReadyToPlay(uint indexed IndexOfDraw,
270 			 bytes32 TheHash,
271 			 uint PriceOfTicketInWei,
272 			 uint WeiToWin);
273 event DrawReadyToPayout(uint32 indexed IndexOfDraw,
274 			uint8 WinningNumber1,
275 			uint8 WinningNumber2,
276 			uint8 WinningNumber3,
277 			uint8 WinningNumber4,
278 			bytes32 TheRand);
279 event PlayerWon(uint Wei);
280 
281 
282 			      
283 
284 }//contract