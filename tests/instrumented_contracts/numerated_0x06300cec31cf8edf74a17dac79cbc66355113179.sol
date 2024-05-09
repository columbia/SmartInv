1 pragma solidity ^0.4.21;
2 
3 // welcome to EtherWild (EthWild)
4 // game which is a simple coin toss game, you have 50% chance to win.
5 // you always play against someone else. 
6 // there are two ways to play; the auto-way by just placing a bet (only one allowed)
7 // this is the standard way to play 
8 // if you place this bet and another one places the same bet, a match occurs and a game is played 
9 // Note: you are allowed to withdraw these bets. If all offers are cancelled 0 eth is in contract. 
10 
11 // Offers: 
12 // You are allowed to create 16 offers in the game. Other people can find these offers and play with them
13 // This is doable if you do not like the suggested offers, or simply want to put on more games. 
14 // These are also cancellable. 
15 // If you play someone's offer and send to much, excess is returned. 
16 
17 contract EtherWild{
18     // GLOBAL SETTINGS //
19     uint8 constant MaxOffersPerADDR = 16; // per definition MAX 32 offers due to uint8 size
20     uint16 CFee = 500; // FEE / 10000 , only paid per PLAYED TX. Cancel / create offer is no fee, only paid after play
21     uint16 HFeePart = 5000; // Part of creator fee -> helper /10000 -> 50%
22     
23     address Owner;
24     address HelpOwner = 0x30B3E09d9A81D6B265A573edC7Cc4C4fBc0B0586;
25     
26     // SETTING BIT CONFIG: 
27     // First two bits: Owner choice of offer. 0 means offer is closed (standard) to prevent double-withdrawals.
28     // 1: blue / 2: red / 3: enemy choices. (This should not matter after infinite plays)
29 
30     // Third bit: Game also has it's neighbour available. If you create a simple game you are allowed 
31     // to create an offer too so it is visible (for manual amounts of inputs)
32     // This makes sure both items are cancelled if you decide to cancel one 
33     // Note: two items are cancelled, but double withdrawal is not availabe ;)
34     
35     // Fourth bit: Max Offers are here 16, fourth bit not used. 
36     // Fifth - Eight bit: ID of the offer in the offer market. Only available from SimpleGame, saves gas (no for loop necessary).
37 
38 
39     struct SimpleGame{
40         address Owner;   // Creator 
41         uint8 setting;  // Setting 
42 
43     }
44     
45     struct OfferGame{
46 	    uint256 amount;    // fee. 
47 	    uint8 setting;     // 0-3
48         bool SimpleGame; // Could have implemented above
49     }
50     
51     // uint256 is wei paid: note only one offer is available per wei here. 
52     mapping(uint256 => SimpleGame) public SimpleGameList;
53 
54     // address can store 16 offers. lookup is done via events, saves gas. 
55     mapping(address => OfferGame[MaxOffersPerADDR]) public OfferGameList;
56     
57 
58     // events for both to keep track 
59     event SimpleGamePlayed(address creator, address target, bool blue, bool cwon, uint256 amount);
60     event SimpleGameCreated(address creator, uint256 fee, uint8 setting);
61     event SimpleGameCancelled(uint256 fee);
62     
63         // same events, ID added to allow cancel from UI 
64     event OfferGameCreated(address creator, uint8 setting, uint256 amount, uint8 id);
65     event OfferGameCancelled(address creator, uint8 id);
66     event OfferGamePlayed(address creator, address target, bool blue, bool cwon, uint256 amount, uint8 id);
67     
68     // dont touch pls 
69     modifier OnlyOwner(){
70         if (msg.sender == Owner){
71             _;
72         }
73         else{
74             revert();
75         }
76     }
77     
78     function EtherWild() public{
79         Owner = msg.sender;
80 
81     }
82     
83     // allows to change dev fee. max is 5%
84     function SetDevFee(uint16 tfee) public OnlyOwner{
85         require(tfee <= 500);
86         CFee = tfee;
87     }
88     
89     // allows to change helper fee. minimum is 10%, max 100%. 
90     function SetHFee(uint16 hfee) public OnlyOwner {
91         require(hfee <= 10000);
92         require(hfee >= 1000);
93         HFeePart = hfee;
94     
95     }
96     
97 
98     // only used in UI. returns uint so you can see how much games you have uploaded. 
99     function UserOffers(address who) public view returns(uint8){
100         uint8 ids = 0;
101         for (uint8 i=0; i<MaxOffersPerADDR; i++){
102             if ((OfferGameList[who][i].setting & 3) == 0){
103                 ids++ ;
104             }
105         }
106         return ids;
107     }
108     
109     // lookups struct into offergamelist. only view. 
110     function ViewOffer(address who, uint8 id) public view returns (uint256 amt, uint8 setting, bool sgame){
111         var Game = OfferGameList[who][id];
112         return (Game.amount, Game.setting,Game.SimpleGame);
113     }
114     
115     // create a new offer with setting. note; setting has to be 1,2 or 3.
116     // connected to msg.sender.
117     function CreateOffer(uint8 setting) public payable{
118         require(msg.value>0);
119         require(setting>0);
120         CreateOffer_internal(setting, false);
121     }
122     
123 
124     // internal function, necessary to keep track of simple game links 
125     function CreateOffer_internal(uint8 setting, bool Sgame) internal returns (uint8 id){
126         // find id. 
127         require(setting <= 3);
128 
129         bool found = false;
130         id = 0;
131         // find available ID .
132         for (uint8 i=0; i<MaxOffersPerADDR; i++){
133             if (OfferGameList[msg.sender][i].setting == 0){
134                 id = i;
135                 found = true;
136                 break;
137             }
138         }
139         // no place? reject tx. 
140         // note: also simple tx can be released like this.
141         require(found);
142         OfferGameList[msg.sender][id] = OfferGame(msg.value, setting, Sgame);
143 
144         emit OfferGameCreated(msg.sender, setting, msg.value, id);
145         // 
146         return id;
147     }
148     
149     // public cancel offer, intern necessary for simple link 
150     // note: offer cancelled is msg.sender and ID is id (into that array of this address)
151     function OfferCancel(uint8 id) public {
152         OfferCancel_internal(id, false);
153     }
154     
155     
156     function OfferCancel_internal(uint8 id, bool skipSimple) internal {
157         var game = OfferGameList[msg.sender][id];
158         if (game.setting != 0){
159             uint8 setting; 
160             bool sgame; 
161             uint8 _notn;
162             (setting, sgame, _notn) = DataFromSetting(game.setting);
163             // reset to 0. 
164             game.setting = 0;
165             
166             emit OfferGameCancelled(msg.sender, id);
167             
168             // if simple game available cancel it. put true in so no recall to this funciton 
169             // also true will prevent to withdraw twice. 
170             if ((!skipSimple) && game.SimpleGame){
171                 CancelSimpleOffer_internal(game.amount,true);
172             }
173             
174             // not from simple cancel? then withdraw. 
175             if (!skipSimple){
176                 msg.sender.transfer(game.amount); // prevent send twice.
177             }
178         }
179         else{
180             return;
181         }
182     }
183     
184     // play offer game: target address, id, possible setting. 
185     function OfferPlay(address target, uint8 id, uint8 setting) public payable {
186         var Game = OfferGameList[target][id];
187         require(Game.setting != 0);
188         require(msg.value >= Game.amount);
189         
190         uint256 excess = msg.value - Game.amount;
191         if (excess > 0){
192             msg.sender.transfer(excess); // return too much. 
193         }
194         
195         uint8 cset;
196         bool sgame; 
197         uint8 _id;
198         
199         (cset, sgame, id) = DataFromSetting(Game.setting);
200         
201         bool creatorChoosesBlue = GetSetting(Game.setting, setting);
202         bool blue;
203         bool creatorwins;
204         (blue, creatorwins) = ProcessGame(target, msg.sender, creatorChoosesBlue, Game.amount);
205 
206         
207         // announce played. 
208         emit OfferGamePlayed(target, msg.sender, blue, creatorwins, Game.amount, id);
209         // disable offer. 
210         Game.setting = 0; // disable this offer. 
211         
212         // also sgame? then cancel this too to prevent another cancel on this one 
213         // otherwise you can always make sure you never lose money. hrm.
214         if(sgame){
215             // cancel sgame -> true prevents withdraw.
216             CancelSimpleOffer_internal(Game.amount, true);
217         }
218         
219     }
220     
221     // same as offer cancel. 
222     function CancelSimpleOffer_internal(uint256 fee, bool SkipOffer) internal {
223         uint8 setting = SimpleGameList[fee].setting;
224         if (setting == 0){
225             return;
226         }
227         if (!(SimpleGameList[fee].Owner == msg.sender)){
228             return;
229         }
230       
231         
232         bool offer;
233         uint8 id;
234         
235         (setting, offer, id) = DataFromSetting(setting);
236         SimpleGameList[fee].setting = 0; // set to zero, prevent recalling.
237         // prevent recall if offer available; 
238         // offer cancel with not withdraw. 
239         if ((!SkipOffer) && offer){
240             OfferCancel_internal(id, true);
241         }
242         
243 
244         // if first call then withdraw. 
245        if (!SkipOffer){
246             msg.sender.transfer(fee); // prevent send twice. 
247        }
248         
249         emit SimpleGameCancelled( fee);
250     }
251     
252     // false = first call for cancel offer, prevent withdraw twice 
253     // withdraws fee to owner if he owns this one 
254     function CancelSimpleOffer(uint256 fee) public {
255         
256        CancelSimpleOffer_internal(fee, false);
257     }
258     
259     //returns if creator wants blue 
260     // yeah this program has this logic behind it although not necessary. 
261     function GetSetting(uint8 setting1, uint8 setting2) pure internal returns (bool creatorChoosesBlue){
262         if (setting1 == 1){
263             return true;
264         }
265         else if (setting1 == 2){
266             return false;
267         }
268         else{
269             if (setting2 == 1){
270                 return false;
271             }
272         }
273         return true;
274     }
275     
276     // play game with setting, and a bool if you also want to create offer on the side. 
277     // (all done in one TX)
278     function PlaySimpleGame(uint8 setting, bool WantInOffer) payable public {
279         require(msg.value > 0);
280         require(setting > 0); // do not create cancelled one, otherwise withdraw not possible. 
281 
282         var game = (SimpleGameList[msg.value]);
283         uint8 id;
284         if (game.setting != 0){
285             // play game - NOT cancelled. 
286             // >tfw msg.value is already correct lol no paybacks 
287             require(game.Owner != msg.sender); // do not play against self, would send fee, unfair.
288             
289             // process logic
290             uint8 cset; 
291             bool ogame;
292             id; 
293             (cset, ogame, id) = DataFromSetting(game.setting);
294             
295             bool creatorChoosesBlue = GetSetting(cset, setting);
296             bool blue;
297             bool creatorwins;
298             //actually play and pay in here. 
299             (blue, creatorwins) = ProcessGame(game.Owner, msg.sender, creatorChoosesBlue, msg.value);
300             emit SimpleGamePlayed(game.Owner, msg.sender, blue, creatorwins, msg.value);
301             // delete , makes it unable to cancel 
302             game.setting = 0;
303             
304             // cancel the offer 
305             // is called second time: makes sure no withdraw happens. 
306             if (ogame){
307                 OfferCancel_internal(id, true);
308             }
309         }
310         else {
311             // create a game ! 
312             //require(setting != 0);
313             id = 0;
314             if (WantInOffer){
315                 // also create an offer. costs more gas 
316                 id = CreateOffer_internal(setting, true); // id is returned to track this when cancel. 
317             }
318             
319             // convert setting. also checks for setting input <= 3; 
320             // bit magic 
321             
322             setting = DataToSetting(setting, WantInOffer, id);
323             
324             // make game, push it in game , emit event 
325             var myGame = SimpleGame(msg.sender, setting);
326             SimpleGameList[msg.value] = myGame;
327             emit SimpleGameCreated(msg.sender, msg.value, setting);
328         }
329     }
330     
331         // process game 
332         // NOTE: ADRESSES are added to random to make sure we get different random results 
333         // for every creator/target pair PER block
334         // that should be sufficient, it would be weird if a block only creates same color all time. 
335     function ProcessGame(address creator, address target, bool creatorWantsBlue, uint256 fee) internal returns (bool blue, bool cWon) {
336         uint random = rand(1, creator);
337         blue = (random==0);
338       //  cWon = (creatorWantsBlue && (blue)) || (!creatorWantsBlue && (!blue)); >tfw retarded 
339         cWon = (creatorWantsBlue == blue); // check if cwon via logic.
340         if (cWon){
341             creator.transfer(DoFee(fee*2)); // DoFee returns payment. 
342         }
343         else{
344             target.transfer(DoFee(fee*2));
345         }
346     }
347     // random function via blockhas and address addition, timestamp. 
348     function rand(uint max, address other) constant internal returns (uint result){
349         uint add = uint (msg.sender) + uint(other) + uint(block.timestamp);
350         uint random_number = addmod(uint (block.blockhash(block.number-1)), add, uint (max + 1)) ;
351         return random_number;   
352     }
353     
354     
355     
356     // pay fee to owners
357     // no safemath necessary, will always be fine due to control in limits of fees. 
358     function DoFee(uint256 amt) internal returns (uint256 left){
359         uint256 totalFee = (amt*CFee)/10000; // total fee paid 
360         uint256 cFee = (totalFee*HFeePart)/10000; // helper fee paid 
361         uint256 dFee = totalFee - cFee; //dev fee paid 
362         
363         Owner.transfer(dFee); // pay 
364         HelpOwner.transfer(cFee);
365         
366         return amt-totalFee; // return excess to be paid 
367     }
368     //function SetFee(uint16) public OnlyOwner;
369     //function SetHFee(uint16) public OnlyOwner;
370 
371     // helper 
372     
373     // converts settings to uint8 using multiple bits to store this data.
374      function DataToSetting(uint8 setting, bool offer, uint8 id) pure internal returns (uint8 output){
375         require(setting <= 3);
376 
377         if (!offer){
378             return setting; // no id necessary.
379         }
380         require(id <= 15);
381         uint8 out=setting;
382         if (offer){
383             out = out + 4; // enable bit 3;
384         }
385         // shift ID bits 4 bits to right so they are on bit 5 to 8
386         uint8 conv_id = id << 4;
387         // add bits 
388         out = out + conv_id; 
389         return out;
390     }
391     
392     // from setting, 3 data to retrieve above.
393     function DataFromSetting(uint8 n) pure internal returns(uint8 set, bool offer, uint8 id){
394         // setting simpmly extract first 2 bits. 
395         set = (n & 3); 
396         // offer extract 3rd bit and convert it to bool (cannot shift and check due to ID), or might have used MOD 1 
397         offer = (bool) ((n & 4)==4); 
398         // shift n by 4 bits to extract id. throws away first 4 bits, nice.
399         id = (n) >> 4;
400         
401     }
402     
403     
404 }