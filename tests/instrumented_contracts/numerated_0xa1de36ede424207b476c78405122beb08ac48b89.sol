1 pragma solidity ^0.4.21;
2 // Fucking kek that you read the source code 
3 // Warning this contract has an exit scam.
4 
5 contract GameState{
6     // Vote timer / Buy in round / Lowest gas round / Close time.
7     uint256[3] RoundTimes = [(5 minutes), (20 minutes), (10 minutes)]; // 5 20 10
8     uint256[3] NextRound = [1,2,0]; // Round flow order. 
9     
10 
11     // Block external calls altering the game mode. 
12 //    modifier BlockExtern(){
13  //       require(msg.sender==caller);
14   //      _;
15   //  }
16     
17     
18     uint256 public CurrentGame = 0;
19   ///  bool StartedGame = false;
20     
21     uint256 public Timestamp = 0;
22     
23     function Timer() internal view returns (bool){
24         if (block.timestamp < Timestamp){
25        //     StartedGame = false;
26             return (true);
27         }
28         return false;
29     }
30     
31     // FixTimer is only for immediate start rounds 
32     // takes last timer and adds stuff to that 
33     function Start() internal {
34     
35         Timestamp = block.timestamp + RoundTimes[CurrentGame];
36 
37        // StartedGame=true;
38     }
39     
40     function Next(bool StartNow) internal {
41         uint256 NextRoundBuffer = NextRound[CurrentGame];
42         if (StartNow){
43             //Start();
44            // StartedGame = true; 
45             Timestamp = Timestamp + RoundTimes[NextRoundBuffer];
46         }
47         else{
48            // StartedGame = false;
49         }
50         CurrentGame = NextRoundBuffer;
51     }
52     
53  //   function GameState() public {
54   //      caller = msg.sender;
55   //  }
56     
57     
58     
59     // returns bit number n from uint. 
60     //function GetByte(uint256 bt, uint256 n) public returns (uint256){
61     //    return ((bt >> n) & (1));
62    // }
63     
64 
65 
66 }
67 
68 contract ServiceStation is GameState{
69   
70     uint256 public Votes = 0;
71     uint256 public constant VotesNecessary = 6; // THIS CANNOT BE 1 
72     uint256 public constant devFee = 500; // 5%
73     
74     address owner;
75     // Fee address is a contract and is supposed to be used for future projects. 
76     // You can buy a dividend card here, which gives you 10% of the development fee. 
77     // If someone else buys it, the contract enforces you do make profit by transferring
78     // (part of) the cost of the card to you. 
79     // It will also pay out all dividends if someone buys the card
80     // A withdraw function is also available to withdraw the dividends up to that point. 
81     // The way to lose money with this card is if not enough dev fee enters the contract AND no one buys the card. 
82     // You can buy it on https://etherguy.surge.sh (if this site is offline, contact me). (Or check contract address and run it in remix to manually buy.)
83     address constant fee_address = 0x3323075B8D3c471631A004CcC5DAD0EEAbc5B4D1; 
84     
85     
86     event NewVote(uint256 AllVotes);
87     event VoteStarted();
88     event ItemBought(uint256 ItemID, address OldOwner, address NewOwner, uint256 NewPrice, uint256 FlipAmount);
89     event JackpotChange(uint256 HighJP, uint256 LowJP);
90     event OutGassed(bool HighGame, uint256 NewGas, address WhoGassed, address NewGasser);
91     event Paid(address Paid, uint256 Amount);
92     
93     
94     modifier OnlyDev(){
95         require(msg.sender==owner);
96         _;
97     }
98     
99     modifier OnlyState(uint256 id){
100         require (CurrentGame == id);
101         _;
102     }
103     
104     // OR relation 
105     modifier OnlyStateOR(uint256 id, uint256 id2){
106         require (CurrentGame == id || CurrentGame == id2);
107         _;
108     }
109     
110     // Thanks to TechnicalRise
111     // Ban contracts
112     modifier NoContract(){
113         uint size;
114         address addr = msg.sender;
115         assembly { size := extcodesize(addr) }
116         require(size == 0);
117         _;
118     }
119     
120     function ServiceStation() public {
121         owner = msg.sender;
122     }
123     
124     // State 0 rules 
125     // Simply vote. 
126     
127     function Vote() public NoContract OnlyStateOR(0,2) {
128         bool StillOpen;
129         if (CurrentGame == 2){
130             StillOpen = Timer();
131             if (StillOpen){
132                 revert(); // cannot vote yet. 
133             }
134             else{
135                 Next(false); // start in next lines.
136             }
137         }
138         StillOpen = Timer();
139         if (!StillOpen){
140             emit VoteStarted();
141             Start();
142             Votes=0;
143         }
144         if ((Votes+1)>= VotesNecessary){
145             GameStart();
146         }
147         else{
148             Votes++;
149         }
150         emit NewVote(Votes);
151     }
152     
153     function DevForceOpen() public NoContract OnlyState(0) OnlyDev {
154         emit NewVote(VotesNecessary);
155         Timestamp = now; // prevent that round immediately ends if votes were long ago. 
156         GameStart();
157     }
158     
159     // State 1 rules 
160     // Pyramid scheme, buy in for 10% jackpot.
161     
162     function GameStart() internal OnlyState(0){
163         RoundNumber++;
164         Votes = 0;
165         // pay latest persons if not yet paid. 
166         Withdraw();
167         Next(true);
168         TotalPot = address(this).balance;
169     }
170 
171     
172     uint256 RoundNumber = 0;
173     uint256 constant MaxItems = 11; // max id, so max items - 1 please here.
174     uint256 constant StartPrice = (0.005 ether);
175     uint256 constant PriceIncrease = 9750;
176     uint256 constant PotPaidTotal = 8000;
177     uint256 constant PotPaidHigh = 9000;
178     uint256 constant PreviousPaid = 6500;
179     uint256 public TotalPot;
180     
181     // This stores if you are in low jackpot, high jackpot
182     // It uses numbers to keep track how much items you have. 
183     mapping(address => bool) LowJackpot;
184     mapping(address => uint256) HighJackpot;
185     mapping(address => uint256) CurrentRound;
186     
187     address public LowJackpotHolder;
188     address public HighJackpotHolder;
189     
190     uint256 CurrTimeHigh; 
191     uint256 CurrTimeLow;
192     
193     uint256 public LowGasAmount;
194     uint256 public HighGasAmount;
195     
196     
197     struct Item{
198         address holder;
199         uint256 price;
200     }
201     
202     mapping(uint256 => Item) Market;
203     
204 
205     // read jackpots 
206     function GetJackpots() public view returns (uint256, uint256){
207         uint256 PotPaidRound = (TotalPot * PotPaidTotal)/10000;
208         uint256 HighJP = (PotPaidRound * PotPaidHigh)/10000;
209         uint256 LowJP = (PotPaidRound * (10000 - PotPaidHigh))/10000;
210         return (HighJP, LowJP);
211     }
212     
213     function GetItemInfo(uint256 ID) public view returns (uint256, address){
214         Item memory targetItem = Market[ID];
215         return (targetItem.price, targetItem.holder);
216     }
217     
218 
219     function BuyItem(uint256 ID) public payable NoContract OnlyState(1){
220         require(ID <= MaxItems);
221         bool StillOpen = Timer();
222         if (!StillOpen){
223             revert();
224             //Next(); // move on to next at new timer; 
225             //msg.sender.transfer(msg.value); // return amount. 
226             //return; // cannot buy
227         }
228         uint256 price = Market[ID].price;
229         if (price == 0){
230             price = StartPrice;
231         }
232         require(msg.value >= price);
233         // excess big goodbye back to owner.
234         if (msg.value > price){
235             msg.sender.transfer(msg.value-price);
236         }
237        
238         
239         // fee -> out 
240         
241         uint256 Fee = (price * (devFee))/10000;
242         uint256 Left = price - Fee;
243         
244         // send fee to fee address which is a contract. you can buy a dividend card to claim 10% of these funds, see above at "address fee_address"
245         fee_address.transfer(Fee);
246         
247         if (price != StartPrice){
248             // pay previous. 
249             address target = Market[ID].holder;
250             uint256 payment = (price * PreviousPaid)/10000;
251             target.transfer (payment);
252             
253             if (target != msg.sender){
254                 if (HighJackpot[target] >= 1){
255                     // Keep track of how many high jackpot items we own. 
256                     // Why? Because if someone else buys your thing you might have another card 
257                     // Which still gives you right to do high jackpot. 
258                     HighJackpot[target] = HighJackpot[target] - 1;
259                 }
260             }
261 
262             //LowJackpotHolder = Market[ID].holder;
263             TotalPot = TotalPot + Left - payment;
264             
265             emit ItemBought(ID, target, msg.sender, (price * (PriceIncrease + 10000))/10000, payment);
266         }
267         else{
268             // Keep track of total pot because we gotta pay people from this later 
269             // since people are paid immediately we cannot read this.balance because this decreases
270             TotalPot = TotalPot + Left;
271             emit ItemBought(ID, address(0x0), msg.sender, (price * (PriceIncrease + 10000))/10000, 0);
272         }
273         
274         uint256 PotPaidRound = (TotalPot * PotPaidTotal)/10000;
275         emit JackpotChange((PotPaidRound * PotPaidHigh)/10000, (PotPaidRound * (10000 - PotPaidHigh))/10000);
276         
277         
278         
279         // activate low pot. you can claim low pot if you are not in the high jackpot .
280         LowJackpot[msg.sender] = true;
281         
282         // Update price 
283         
284         price = (price * (PriceIncrease + 10000))/10000;
285         
286         // 
287         if (CurrentRound[msg.sender] != RoundNumber){
288             // New round reset count 
289             if (HighJackpot[msg.sender] != 1){
290                 HighJackpot[msg.sender] = 1;
291             }
292             CurrentRound[msg.sender] = RoundNumber;
293             
294         }
295         else{
296             HighJackpot[msg.sender] = HighJackpot[msg.sender] + 1;
297         }
298 
299         Market[ID].holder = msg.sender;
300         Market[ID].price = price;
301     }
302     
303     
304     
305     
306     // Round 2 least gas war 
307     
308     // returns: can play (bool), high jackpot (bool)
309     function GetGameType(address targ) public view returns (bool, bool){
310         if (CurrentRound[targ] != RoundNumber){
311             // no buy in, reject playing jackpot game 
312             return (false,false);
313         }
314         else{
315             
316             if (HighJackpot[targ] > 0){
317                 // play high jackpot 
318                 return (true, true);
319             }
320             else{
321                 if (LowJackpot[targ]){
322                     // play low jackpot 
323                     return (true, false);
324                 }
325             }
326             
327             
328         }
329         // functions should not go here. 
330         return (false, false);
331     }
332     
333     
334     
335     // 
336     function BurnGas() public NoContract OnlyStateOR(2,1) {
337         bool StillOpen;
338        if (CurrentGame == 1){
339            StillOpen = Timer();
340            if (!StillOpen){
341                Next(true); // move to round 2. immediate start 
342            }
343            else{
344                revert(); // gas burn closed. 
345            }
346        } 
347        StillOpen = Timer();
348        if (!StillOpen){
349            Next(true);
350            Withdraw();
351            return;
352        }
353        bool CanPlay;
354        bool IsPremium;
355        (CanPlay, IsPremium) = GetGameType(msg.sender);
356        require(CanPlay); 
357        
358        uint256 AllPot = (TotalPot * PotPaidTotal)/10000;
359        uint256 PotTarget;
360        
361 
362        
363        uint256 timespent;
364        uint256 payment;
365        
366        if (IsPremium){
367            PotTarget = (AllPot * PotPaidHigh)/10000;
368            if (HighGasAmount == 0 || tx.gasprice < HighGasAmount){
369                if (HighGasAmount == 0){
370                    emit OutGassed(true, tx.gasprice, address(0x0), msg.sender);
371                }
372                else{
373                    timespent = now - CurrTimeHigh;
374                    payment = (PotTarget * timespent) / RoundTimes[2]; // calculate payment and send 
375                    HighJackpotHolder.transfer(payment);
376                    emit OutGassed(true, tx.gasprice, HighJackpotHolder, msg.sender);
377                    emit Paid(HighJackpotHolder, payment);
378                }
379                HighGasAmount = tx.gasprice;
380                CurrTimeHigh = now;
381                HighJackpotHolder = msg.sender;
382            }
383        }
384        else{
385            PotTarget = (AllPot * (10000 - PotPaidHigh)) / 10000;
386            
387             if (LowGasAmount == 0 || tx.gasprice < LowGasAmount){
388                if (LowGasAmount == 0){
389                     emit OutGassed(false, tx.gasprice, address(0x0), msg.sender);
390                }
391                else{
392                    timespent = now - CurrTimeLow;
393                    payment = (PotTarget * timespent) / RoundTimes[2]; // calculate payment and send 
394                    LowJackpotHolder.transfer(payment);
395                    emit OutGassed(false, tx.gasprice, LowJackpotHolder, msg.sender);
396                    emit Paid(LowJackpotHolder, payment);
397                }
398                LowGasAmount = tx.gasprice;
399                CurrTimeLow = now;
400                LowJackpotHolder = msg.sender;
401             }
402        }
403        
404       
405        
406   
407     }
408     
409     function Withdraw() public NoContract OnlyStateOR(0,2){
410         bool gonext = false;
411         if (CurrentGame == 2){
412             bool StillOpen;
413             StillOpen = Timer();
414             if (!StillOpen){
415                 gonext = true;
416             }
417             else{
418                 revert(); // no cheats
419             }
420         }
421         uint256 timespent;
422         uint256 payment;
423         uint256 AllPot = (TotalPot * PotPaidTotal)/10000;
424         uint256 PotTarget;
425         if (LowGasAmount != 0){
426             PotTarget = (AllPot * (10000 - PotPaidHigh))/10000;
427             timespent = Timestamp - CurrTimeLow;
428             payment = (PotTarget * timespent) / RoundTimes[2]; // calculate payment and send 
429             LowJackpotHolder.transfer(payment);     
430             emit Paid(LowJackpotHolder, payment);
431         }
432         if (HighGasAmount != 0){
433             PotTarget = (AllPot * PotPaidHigh)/10000;
434             timespent = Timestamp - CurrTimeHigh;
435             payment = (PotTarget * timespent) / RoundTimes[2]; // calculate payment and send 
436             HighJackpotHolder.transfer(payment);
437             emit Paid(HighJackpotHolder, payment);
438         }
439         // reset low gas high gas for next round 
440         LowGasAmount = 0;
441         HighGasAmount = 0;
442         
443         // reset market prices. 
444         uint8 id; 
445         for (id=0; id<MaxItems; id++){
446             Market[id].price=0;
447         }
448         
449         if (gonext){
450             Next(true);
451         }
452     }
453     
454     
455 
456     
457     // this is added in case something goes wrong 
458     // the contract can be funded if any bugs happen when 
459     // trying to transfer eth.
460     function() payable{
461         
462     }
463     
464     
465     
466     
467     
468     
469 }