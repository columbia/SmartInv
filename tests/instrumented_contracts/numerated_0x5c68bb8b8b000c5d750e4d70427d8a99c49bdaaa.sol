1 pragma solidity ^0.4.25;
2 
3 contract FOMOEvents {
4     // fired whenever a player registers a name
5     event onNewName
6     (
7         uint256 indexed playerID,
8         address indexed playerAddress,
9         bytes32 indexed playerName,
10         bool isNewPlayer,
11         uint256 affiliateID,
12         address affiliateAddress,
13         bytes32 affiliateName,
14         uint256 amountPaid,
15         uint256 timeStamp
16     );
17 
18     // fired at end of buy or reload
19     event onEndTx
20     (
21         uint256 compressedData,
22         uint256 compressedIDs,
23         bytes32 playerName,
24         address playerAddress,
25         uint256 ethIn,
26         uint256 keysBought,
27         address winnerAddr,
28         bytes32 winnerName,
29         uint256 amountWon,
30         uint256 newPot,
31         uint256 tokenAmount,
32         uint256 genAmount,
33         uint256 potAmount,
34         uint256 seedAdd
35     );
36 
37     // fired whenever theres a withdraw
38     event onWithdraw
39     (
40         uint256 indexed playerID,
41         address playerAddress,
42         bytes32 playerName,
43         uint256 ethOut,
44         uint256 timeStamp
45     );
46 
47     // fired whenever a withdraw forces end round to be ran
48     event onWithdrawAndDistribute
49     (
50         address playerAddress,
51         bytes32 playerName,
52         uint256 ethOut,
53         uint256 compressedData,
54         uint256 compressedIDs,
55         address winnerAddr,
56         bytes32 winnerName,
57         uint256 amountWon,
58         uint256 newPot,
59         uint256 tokenAmount,
60         uint256 genAmount,
61         uint256 seedAdd
62     );
63 
64     // fired whenever a player tries a buy after round timer
65     // hit zero, and causes end round to be ran.
66     event onBuyAndDistribute
67     (
68         address playerAddress,
69         bytes32 playerName,
70         uint256 ethIn,
71         uint256 compressedData,
72         uint256 compressedIDs,
73         address winnerAddr,
74         bytes32 winnerName,
75         uint256 amountWon,
76         uint256 newPot,
77         uint256 tokenAmount,
78         uint256 genAmount,
79         uint256 seedAdd
80     );
81 
82     // fired whenever a player tries a reload after round timer
83     // hit zero, and causes end round to be ran.
84     event onReLoadAndDistribute
85     (
86         address playerAddress,
87         bytes32 playerName,
88         uint256 compressedData,
89         uint256 compressedIDs,
90         address winnerAddr,
91         bytes32 winnerName,
92         uint256 amountWon,
93         uint256 newPot,
94         uint256 tokenAmount,
95         uint256 genAmount,
96         uint256 seedAdd
97     );
98 
99     // fired whenever an affiliate is paid
100     event onAffiliatePayout
101     (
102         uint256 indexed affiliateID,
103         address affiliateAddress,
104         bytes32 affiliateName,
105         uint256 indexed roundID,
106         uint256 indexed buyerID,
107         uint256 amount,
108         uint256 timeStamp
109     );
110 }
111 
112 //==============================================================================
113 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
114 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
115 //====================================|=========================================
116 
117 contract FFEIF is FOMOEvents {
118     using SafeMath for *;
119     using NameFilter for string;
120    
121     PlayerBookInterface  private PlayerBook;
122 
123 //==============================================================================
124 //     _ _  _  |`. _     _ _ |_ | _  _  .
125 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
126 //=================_|===========================================================
127     PoEIF public PoEIFContract;
128     address private admin = msg.sender;
129     string constant public name = "Fomo Forever EIF";
130     string constant public symbol = "FFEIF";
131     uint256 private rndExtra_ = 1 minutes;     // length of the very first ICO
132     uint256 public rndGap_ = 1 minutes;        // length of ICO phase, set to 1 year for EOS.
133     uint256 public rndInit_ = 60 minutes;      // round timer starts at this
134     uint256 public rndInc_ = 1 seconds;        // every full FFEIF purchased adds this much to the timer
135     uint256 public rndIncDivisor_ = 1;         // divides the above by this amount (useful for less than 1 second per FFEIF when setting shorter rounds)
136 	
137 	uint256 public potSeedRate = 100;		   // pot increase per hour from seedingPot (divided into seedingPot) - default 100 means 1% per hour is added
138 	uint256 public potNextSeedTime = 0;        // time for the next increase (increases by an hour each time it is processed)		
139 	uint256 public seedingPot  = 0;            // this keeps track of the amount left to feed the pot - initially has nothing but can be fed by anyone
140 	uint256 public seedingThreshold = 0 ether; // for the first x ETH (or however it is set) of each round, all pot increases go to the seeding rather than the actual pot
141 	uint256 public seedingDivisor = 2;         // after the threshold, the pot amount is divided by this and added to the seedingPot i.e. half - a higher divisor means less goes into seeding
142 	uint256 public seedRoundEnd = 1;           // if nextRoundPercentage will also add to seeding pot as normal or instead fully goes to the pot
143 	
144 	uint256 public linearPrice = 75000000000000;            // if non-zero will set a fixed price - otherwise normal fomo scaling which is fairly linear still
145 	
146 	uint256 public multPurchase = 0;	      // number of FFEIF needed to purchase for the multiplier to go up.... 0 means it has to be a qualifying purchase of the multiplier amount of FFEIF i.e. enough to make the user the winner if nobody else buys enough afterwards...
147 	uint256 public multAllowLast = 1;         // Whether the current winner (last qualifying purchaser) can increase the multiplier - this could be used as a tactic to win
148 	uint256 public multLinear = 2;            // multiplier increases linearly, if not the multiplier is multiplied rather than added to each time a sufficient amount is purchased
149 	                                          // NOTE: If the value is 2 then it is linear until multStart is reached.....
150 	
151 	uint256 public maxMult = 1000000;		  // The maximum value of multiplier (remember it is 10 times the real value);			
152 	uint256 public multInc_ = 0;              // every purchase (any amount greater than multPurchase) adds this much to the multiplier but divided by 10 - a value of 10 means a real increase of 1 per purchase
153 											  // NOTE: For non-linear increases, this real value is added to 1 and multiplied - i.e. 10 would mean it doubles each time
154 											  // NOTE2: If multInc_ is 0, the amount of FFEIF purchased is used as the value (which is still ten times more than the real value)
155 	uint256 public multIncFactor_ = 10;		  // Further factor to multiply multInc_ by before processing (this is for finer adjustments when multInc_ is set to 0)
156 	uint256 public multLastChange = now;      // stores timestamp of the last increase/decrease so the next decay can by calculated - note that for non-linear decay, the timestamp only changes to the next minute or multiple of minutes that have passed
157 	uint256 public multDecayPerMinute = 1;    // every minute the multiplier reduces by this amount (isn't X10 this time so is the true decrease per minute  - i.e. 1)
158 											  // NOTE: For non-linear decay, a value of 1 means it halves every minute (1 is added to the amount and divided rather than subtracted)
159 	uint256 public multStart = 24 hours;       // the max time that should be left for the multiplier to increase through more purchases - won't increase when timer is above this
160 	uint256 public multCurrent = 10;	      // the current multiplier times 10 - defaults to a real value of 1 and this is also the minimum allowed
161 	
162     uint256 public rndMax_ = 24 hours;      // max length a round timer can be
163     uint256 public earlyRoundLimit = 1e18;        // limit of 1ETH per player (not per purchase) until earlyRoundLimitUntil
164     uint256 public earlyRoundLimitUntil = 100e18; // when limiter ends
165     
166     uint256 public divPercentage = 65;        // max 75% and can be configured - potPercentage is implied from the rest - 5% each for PoEIF and EIF is fixed
167     uint256 public affFee = 5;                // aff fee default is 5% and max is 15%
168     uint256 public potPercentage = 20;        // 90 - divPercentage - affFee  (seeding divisor applies to this)
169     
170     uint256 public divPotPercentage = 15;     // max 50% and can be configured - winnerPercentage is implied from the rest - 5% each for PoEIF and EIF is fixed
171     uint256 public nextRoundPercentage = 25;  // max 40% and is the amount carried to the next round (since it is going to the pot, the seeding divisor ratio also applies to this if seedRoundEnd is 1)
172     uint256 public winnerPercentage = 50;     // 90 - divPotPercentage - nextRoundPercentatge
173     
174     uint256 public fundEIF = 0;               // the EasyInvestForever accumulated fund yet to be sent (5% of incoming ETH)
175     uint256 public totalEIF = 0;              // total EasyInvestForever fund already sent
176     uint256 public seedDonated = 0;           // total sent to seedingPot payable function (doesn't keep track of msg.sender)
177     address public FundEIF = 0x0111E8A755a4212E6E1f13e75b1EABa8f837a213; // Usual fund address to send EIF funds too - updateable
178     
179 
180 
181 //==============================================================================
182 //     _| _ _|_ _    _ _ _|_    _   .
183 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
184 //=============================|================================================
185     uint256 public rID_;    // round id number / total rounds that have happened
186 //****************
187 // PLAYER DATA
188 //****************
189     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
190     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
191     mapping (uint256 => FFEIFDatasets.Player) public plyr_;   // (pID => data) player data
192     mapping (uint256 => mapping (uint256 => FFEIFDatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
193     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
194 //****************
195 // ROUND DATA
196 //****************
197     mapping (uint256 => FFEIFDatasets.Round) public round_;   // (rID => data) round data
198     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
199 //****************
200 // TEAM FEE DATA
201 //****************
202     mapping (uint256 => FFEIFDatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
203     mapping (uint256 => FFEIFDatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
204 //==============================================================================
205 //     _ _  _  __|_ _    __|_ _  _  .
206 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
207 //==============================================================================
208     constructor()
209         public
210     {
211         PoEIFContract = PoEIF(0xFfB8ccA6D55762dF595F21E78f21CD8DfeadF1C8);
212         PlayerBook = PlayerBookInterface(0xd80e96496cd0B3F95bB4941b1385023fBCa1E6Ba);
213         
214     }
215 
216 //==============================================================================
217 //     _  _ _  _  .
218 //    | |(/_|/\|  .  (these are for multiplier and new functions)
219 //==============================================================================
220     
221 function updateFundAddress(address _newAddress)
222         onlyAdmin()
223         public
224     {
225         FundEIF = _newAddress;
226     }
227 
228 
229     /**
230      * @dev calculates number of FFEIF received given X eth
231      * @param _curEth current amount of eth in contract
232      * @param _newEth eth being spent
233      * @return amount of ticket purchased
234      */
235     function keysRec(uint256 _curEth, uint256 _newEth)
236         internal
237         view
238         returns (uint256)
239     {
240         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
241     }
242 
243     /**
244      * @dev calculates amount of eth received if you sold X FFEIF
245      * @param _curKeys current amount of FFEIF that exist
246      * @param _sellKeys amount of FFEIF you wish to sell
247      * @return amount of eth received
248      */
249     function ethRec(uint256 _curKeys, uint256 _sellKeys)
250         internal
251         view
252         returns (uint256)
253     {
254         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
255     }
256 
257     /**
258      * @dev calculates how many FFEIF would exist with given an amount of eth
259      * @param _eth eth "in contract"
260      * @return number of FFEIF that would exist
261      */
262     function keys(uint256 _eth)
263         internal
264         view
265         returns(uint256)
266     {
267         if (linearPrice==0)
268         {return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);}
269         else
270         {return 1e18.mul(_eth) / linearPrice;}
271     }
272 
273     /**
274      * @dev calculates how much eth would be in contract given a number of FFEIF
275      * @param _keys number of FFEIF "in contract"
276      * @return eth that would exists
277      */
278     function eth(uint256 _keys)
279         internal
280         view
281         returns(uint256)
282     {
283          if (linearPrice==0)
284         {return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());}
285         else
286         {return _keys.mul(linearPrice)/1e18;}
287     }
288 
289 
290 function payFund() public {   //Registration fee goes to EIF - function must be called manually so enough gas is sent
291     if(!FundEIF.call.value(fundEIF)()) {
292         revert();
293     }
294     totalEIF = totalEIF.add(fundEIF); fundEIF = 0; 
295 }
296 
297 
298 function calcMult(uint256 keysBought, bool validIncrease) internal returns (bool)
299 {
300     uint256 _now = now; //make local variable
301 	uint256 secondsPassed = _now - multLastChange;
302 	
303 	//stores boolean for whether time left has reached the threshold for multiplier to be active - may still be active in special case
304 	bool thresholdReached = (multStart > round_[rID_].end - _now);
305 	
306 	// work out if linear and update the last change time depending on this 
307 	// multLastChange updates all the time even when multiplier inactive or at minimum and doesn't change
308 	bool currentlyLinear = false;
309 	if (multLinear == 1 || (multLinear == 2 && !thresholdReached)) { currentlyLinear = true; multLastChange = _now;}
310 	else  multLastChange = multLastChange.add((secondsPassed/60).mul(60)); //updates every 60 seconds only
311 	// includes special case is where it changes from linear to non-linear when multLinear is set to 2 and thresholdReached
312 	
313 	//first apply the decay even when not active
314 	if (multCurrent >= 10) {
315 	    if (currentlyLinear) multCurrent = (multCurrent.mul(10).sub(multDecayPerMinute.mul(secondsPassed).mul(100)/60))/10; else multCurrent = multCurrent / (1+(multDecayPerMinute.mul(secondsPassed)/60));
316 		if (multCurrent < 10) multCurrent = 10;
317 	}
318 	
319 	
320 	// returnValue true if enough bought to be new winner - note that it is set before the increase but after the decay 
321 	bool returnValue = ((keysBought / 1e17) >= multCurrent);
322 	
323 	// now increase the multiplier if active
324 	if ((thresholdReached || multLinear == 2) && validIncrease) {
325 	    uint256 wholeKeysBought = keysBought / 1e18;
326 	    uint256 actualMultInc = multIncFactor_.mul(wholeKeysBought);
327 	    if (multInc_ != 0) actualMultInc = multInc_;
328 	    
329 	    // have enough FFEIF/keys been bought to increase multiplier
330 	    if ((wholeKeysBought >= multPurchase && multPurchase > 0) || ((wholeKeysBought >= (multCurrent / 10)) && multPurchase == 0) ) {  
331 	    //now apply increase
332 	        if (currentlyLinear) multCurrent = multCurrent.add(actualMultInc); else multCurrent = multCurrent.mul((1+(actualMultInc/10)));
333 	        if (multCurrent > maxMult) multCurrent = maxMult;
334 	    }
335     }
336 	
337 	return returnValue;
338 	
339 }
340 
341 
342 function viewMult() public view returns (uint256) // since multiplier only increases when keys are bought, this will only estimate the decay
343 {
344     uint256 _now = now; //make local variable
345 	uint256 secondsPassed = _now - multLastChange; 
346 	
347 	//stores boolean for whether time left has reached the threshold for multiplier to be active - may still be active in special case
348 	bool thresholdReached = (multStart > round_[rID_].end - _now);
349 	
350 	// work out if linear
351 	bool currentlyLinear = false;
352 	if (multLinear == 1 || (multLinear == 2 && !thresholdReached)) currentlyLinear = true;
353 	// includes special case is where it changes from linear to non-linear when multLinear is set to 2 and thresholdReached
354 	
355 	//first apply the decay even when not active
356 	uint256 _multCurrent = multCurrent; //create local 
357 	if (_multCurrent >= 10) {
358 	    if (currentlyLinear) _multCurrent = (_multCurrent.mul(10).sub(multDecayPerMinute.mul(secondsPassed).mul(100)/60))/10; else
359 	        {
360 	            //make approximation for display reasons 
361 	            uint256 proportion = secondsPassed % 60;
362 	            _multCurrent = _multCurrent / (1+(multDecayPerMinute.mul(secondsPassed)/60));
363 	            uint256 _multCurrent2 = multCurrent / (1+(multDecayPerMinute.mul(secondsPassed+60)/60));
364 	            _multCurrent = _multCurrent - proportion.mul(_multCurrent - _multCurrent2)/60;
365 	        }
366 	}
367 	
368 	
369     if (_multCurrent < 10) _multCurrent = 10;	
370     return _multCurrent;
371 }
372 
373 function viewPot() public view returns (uint256) // shows pot in realtime including proportion of seeding pot (so it rises every second)
374 {
375     uint256 _now = now;
376     uint256 _pot = round_[rID_].pot;
377     uint256 _seedingPot = seedingPot;
378     uint256 _potSeedRate = potSeedRate;
379     uint256 _potNextSeedTime = potNextSeedTime;
380     
381     // emulate seeding to also make sure potNextSeedTime is not before _now
382     while (_potNextSeedTime<now) {_pot = _pot.add(_seedingPot/_potSeedRate); _seedingPot = _seedingPot.sub(_seedingPot/_potSeedRate); _potNextSeedTime += 3600;}
383     
384     //time left for hourly real update
385     uint256 timeLeft = potNextSeedTime - _now;
386     
387    // return calculated estimate - the usually negligible sub-hour extra is not actually won at round end (waste of gas to implement) but is for display reasons
388    return ((3600-timeLeft).mul(_seedingPot/_potSeedRate)/3600 ).add(_pot);
389     
390 }
391 
392 
393 uint numElements = 0;
394 uint256[] varvalue;
395 string[] varname;
396 
397 function insert(string _var, uint256 _value) internal  {
398     if(numElements == varvalue.length) {
399         varvalue.length ++; varname.length ++;
400     }
401     varvalue[numElements] = _value;
402     varname[numElements] = _var;
403 	numElements++;
404 }
405 
406 
407 function setStore(string _variable, uint256 _value) public  {  // we used uint256 for everything here
408 
409     // add any new configuration change to array list - admin only and ignore the dummy values sent by endround function
410     if (keccak256(bytes(_variable))!=keccak256("endround") && msg.sender == admin) insert(_variable,_value);
411     
412     // if round has ended, update all variables and reset array index afterwards to effectively clear it
413     if (round_[rID_].ended || activated_ == false)  {
414        //now loop through all elements 
415     	for (uint i=0; i<numElements; i++) {
416     	   bytes32 _varname = keccak256(bytes(varname[i])); 
417 	   if (_varname==keccak256('rndGap_')) rndGap_=varvalue[i]; else 
418 	   if (_varname==keccak256('rndInit_')) rndInit_=varvalue[i]; else
419 	   if (_varname==keccak256('rndInc_')) rndInc_=varvalue[i]; else
420 	   if (_varname==keccak256('rndIncDivisor_')) rndIncDivisor_=varvalue[i]; else
421 	   if (_varname==keccak256('potSeedRate')) potSeedRate=varvalue[i]; else
422 	   if (_varname==keccak256('potNextSeedTime')) potNextSeedTime=varvalue[i]; else
423 	   if (_varname==keccak256('seedingThreshold')) seedingThreshold=varvalue[i]; else
424 	   if (_varname==keccak256('seedingDivisor')) seedingDivisor=varvalue[i]; else
425 	   if (_varname==keccak256('seedRoundEnd')) seedRoundEnd=varvalue[i]; else
426 	   if (_varname==keccak256('linearPrice')) linearPrice=varvalue[i]; else
427 	   if (_varname==keccak256('multPurchase')) multPurchase=varvalue[i]; else
428 	   if (_varname==keccak256('multAllowLast')) multAllowLast=varvalue[i]; else
429 	   if (_varname==keccak256('maxMult')) maxMult=varvalue[i]; else
430 	   if (_varname==keccak256('multInc_')) multInc_=varvalue[i]; else
431 	   if (_varname==keccak256('multIncFactor_')) multIncFactor_=varvalue[i]; else
432 	   if (_varname==keccak256('multLastChange')) multLastChange=varvalue[i]; else
433 	   if (_varname==keccak256('multDecayPerMinute')) multDecayPerMinute=varvalue[i]; else
434 	   if (_varname==keccak256('multStart')) multStart=varvalue[i]; else
435 	   if (_varname==keccak256('multCurrent')) multCurrent=varvalue[i]; else
436 	   if (_varname==keccak256('rndMax_')) rndMax_=varvalue[i]; else
437 	   if (_varname==keccak256('earlyRoundLimit')) earlyRoundLimit=varvalue[i]; else
438 	   if (_varname==keccak256('earlyRoundLimitUntil')) earlyRoundLimitUntil=varvalue[i]; else
439 	   if (_varname==keccak256('divPercentage')) {divPercentage=varvalue[i]; if (divPercentage>75) divPercentage=75;} else
440 	   if (_varname==keccak256('divPotPercentage')) {divPotPercentage=varvalue[i]; if (divPotPercentage>50) divPotPercentage=50;} else
441 	   if (_varname==keccak256('nextRoundPercentage')) {nextRoundPercentage=varvalue[i]; if (nextRoundPercentage>40) nextRoundPercentage=40;} else
442 	   if (_varname==keccak256('affFee')) {affFee=varvalue[i]; if (affFee>15) affFee=15;}
443 		}
444 		//clear elements by resetting index
445 		numElements = 0;
446 		// recalculate pot and winner percentages - assume SafeMath not needed due to max values being enforced
447 		winnerPercentage = 90 - divPotPercentage - nextRoundPercentage;
448 		potPercentage = 90 - divPercentage - affFee;  
449 		// reset multiplier to minimum
450 		multCurrent = 10;
451 		// finally update legacy arrays
452 		fees_[0] = FFEIFDatasets.TeamFee(divPercentage,10);   // rest to aff (affFee) and potPercentage
453         potSplit_[0] = FFEIFDatasets.PotSplit(divPotPercentage,10);  // also winnerPercentage to winner, nextRoundPercentage to next round
454     
455 	}
456 }
457 
458     
459     
460 //==============================================================================
461 //     _ _  _  _|. |`. _  _ _  .
462 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
463 //==============================================================================
464     /**
465      * @dev used to make sure no one can interact with contract until it has
466      * been activated.
467      */
468     modifier isActivated() {
469         require(activated_ == true);
470         // quick one-line hack to feed pot from seedingPot - adds one hour each time so may loop a few times if contract has been dormant
471         while (potNextSeedTime<now)  {round_[rID_].pot = round_[rID_].pot.add(seedingPot/potSeedRate); seedingPot = seedingPot.sub(seedingPot/potSeedRate); potNextSeedTime += 3600; }
472         _;
473     }
474 
475     /**
476      * @dev prevents other contracts from interacting with this one
477      */
478     modifier isHuman() {
479         address _addr = msg.sender;
480         uint256 _codeLength;
481         require (msg.sender == tx.origin);
482         assembly {_codeLength := extcodesize(_addr)}
483         require(_codeLength == 0);
484         
485         _;
486     }
487 
488     /**
489      * @dev sets boundaries for incoming tx
490      */
491     modifier isWithinLimits(uint256 _eth) {
492         require(_eth >= 1000000000);
493         require(_eth <= 100000000000000000000000);
494         _;
495     }
496 
497  modifier onlyAdmin()
498     {
499         require(msg.sender == admin);
500         _;
501     }
502 
503 //==============================================================================
504 //     _    |_ |. _   |`    _  __|_. _  _  _  .
505 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
506 //====|=========================================================================
507     /**
508      * @dev emergency buy uses last stored affiliate ID
509      */
510     function()
511         isActivated()
512         isHuman()
513         isWithinLimits(msg.value)
514         public
515         payable
516     {
517         // set up our tx event data and determine if player is new or not
518         FFEIFDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
519 
520         // fetch player id
521         uint256 _pID = pIDxAddr_[msg.sender];
522 
523         // buy core
524         buyCore(_pID, plyr_[_pID].laff, _eventData_);
525     }
526     
527     
528     function seedDeposit()
529         isWithinLimits(msg.value)
530         public
531         payable
532     {
533         // add to seedingPot
534         seedingPot = seedingPot.add(msg.value);
535         seedDonated = seedDonated.add(msg.value);
536     }
537 
538     /**
539      * @dev converts all incoming ethereum to FFEIF.
540      * -functionhash- 0x8f38f309 (using ID for affiliate)
541      * -functionhash- 0x98a0871d (using address for affiliate)
542      * -functionhash- 0xa65b37a1 (using name for affiliate)
543      * @param _affCode the ID/address/name of the player who gets the affiliate fee
544      */
545     function buyXid(uint256 _affCode)
546         isActivated()
547         isHuman()
548         isWithinLimits(msg.value)
549         public
550         payable
551     {
552         // set up our tx event data and determine if player is new or not
553         FFEIFDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
554 
555         // fetch player id
556         uint256 _pID = pIDxAddr_[msg.sender];
557 
558         // manage affiliate residuals
559         // if no affiliate code was given or player tried to use their own, lolz
560         if (_affCode == 0 || _affCode == _pID)
561         {
562             // use last stored affiliate code
563             _affCode = plyr_[_pID].laff;
564 
565         // if affiliate code was given & its not the same as previously stored
566         } else if (_affCode != plyr_[_pID].laff) {
567             // update last affiliate
568             plyr_[_pID].laff = _affCode;
569         }
570 
571         // buy core
572         buyCore(_pID, _affCode, _eventData_);
573     }
574 
575     function buyXaddr(address _affCode)
576         isActivated()
577         isHuman()
578         isWithinLimits(msg.value)
579         public
580         payable
581     {
582         // set up our tx event data and determine if player is new or not
583         FFEIFDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
584 
585         // fetch player id
586         uint256 _pID = pIDxAddr_[msg.sender];
587 
588         // manage affiliate residuals
589         uint256 _affID;
590         // if no affiliate code was given or player tried to use their own, lolz
591         if (_affCode == address(0) || _affCode == msg.sender)
592         {
593             // use last stored affiliate code
594             _affID = plyr_[_pID].laff;
595 
596         // if affiliate code was given
597         } else {
598             // get affiliate ID from aff Code
599             _affID = pIDxAddr_[_affCode];
600 
601             // if affID is not the same as previously stored
602             if (_affID != plyr_[_pID].laff)
603             {
604                 // update last affiliate
605                 plyr_[_pID].laff = _affID;
606             }
607         }
608         // buy core
609         buyCore(_pID, _affID, _eventData_);
610     }
611 
612     function buyXname(bytes32 _affCode)
613         isActivated()
614         isHuman()
615         isWithinLimits(msg.value)
616         public
617         payable
618     {
619         // set up our tx event data and determine if player is new or not
620         FFEIFDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
621 
622         // fetch player id
623         uint256 _pID = pIDxAddr_[msg.sender];
624 
625         // manage affiliate residuals
626         uint256 _affID;
627         // if no affiliate code was given or player tried to use their own, lolz
628         if (_affCode == '' || _affCode == plyr_[_pID].name)
629         {
630             // use last stored affiliate code
631             _affID = plyr_[_pID].laff;
632 
633         // if affiliate code was given
634         } else {
635             // get affiliate ID from aff Code
636             _affID = pIDxName_[_affCode];
637 
638             // if affID is not the same as previously stored
639             if (_affID != plyr_[_pID].laff)
640             {
641                 // update last affiliate
642                 plyr_[_pID].laff = _affID;
643             }
644         }
645 
646         // buy core
647         buyCore(_pID, _affID, _eventData_);
648     }
649 
650     /**
651      * @dev essentially the same as buy, but instead of you sending ether
652      * from your wallet, it uses your unwithdrawn earnings.
653      * -functionhash- 0x349cdcac (using ID for affiliate)
654      * -functionhash- 0x82bfc739 (using address for affiliate)
655      * -functionhash- 0x079ce327 (using name for affiliate)
656      * @param _affCode the ID/address/name of the player who gets the affiliate fee
657      * @param _eth amount of earnings to use (remainder returned to gen vault)
658      */
659     function reLoadXid(uint256 _affCode, uint256 _eth)
660         isActivated()
661         isHuman()
662         isWithinLimits(_eth)
663         public
664     {
665         // set up our tx event data
666         FFEIFDatasets.EventReturns memory _eventData_;
667 
668         // fetch player ID
669         uint256 _pID = pIDxAddr_[msg.sender];
670 
671         // manage affiliate residuals
672         // if no affiliate code was given or player tried to use their own, lolz
673         if (_affCode == 0 || _affCode == _pID)
674         {
675             // use last stored affiliate code
676             _affCode = plyr_[_pID].laff;
677 
678         // if affiliate code was given & its not the same as previously stored
679         } else if (_affCode != plyr_[_pID].laff) {
680             // update last affiliate
681             plyr_[_pID].laff = _affCode;
682         }
683 
684         // reload core
685         reLoadCore(_pID, _affCode,  _eth, _eventData_);
686     }
687 
688     function reLoadXaddr(address _affCode, uint256 _eth)
689         isActivated()
690         isHuman()
691         isWithinLimits(_eth)
692         public
693     {
694         // set up our tx event data
695         FFEIFDatasets.EventReturns memory _eventData_;
696 
697         // fetch player ID
698         uint256 _pID = pIDxAddr_[msg.sender];
699 
700         // manage affiliate residuals
701         uint256 _affID;
702         // if no affiliate code was given or player tried to use their own, lolz
703         if (_affCode == address(0) || _affCode == msg.sender)
704         {
705             // use last stored affiliate code
706             _affID = plyr_[_pID].laff;
707 
708         // if affiliate code was given
709         } else {
710             // get affiliate ID from aff Code
711             _affID = pIDxAddr_[_affCode];
712 
713             // if affID is not the same as previously stored
714             if (_affID != plyr_[_pID].laff)
715             {
716                 // update last affiliate
717                 plyr_[_pID].laff = _affID;
718             }
719         }
720 
721         // reload core
722         reLoadCore(_pID, _affID, _eth, _eventData_);
723     }
724 
725     function reLoadXname(bytes32 _affCode, uint256 _eth)
726         isActivated()
727         isHuman()
728         isWithinLimits(_eth)
729         public
730     {
731         // set up our tx event data
732         FFEIFDatasets.EventReturns memory _eventData_;
733 
734         // fetch player ID
735         uint256 _pID = pIDxAddr_[msg.sender];
736 
737         // manage affiliate residuals
738         uint256 _affID;
739         // if no affiliate code was given or player tried to use their own, lolz
740         if (_affCode == '' || _affCode == plyr_[_pID].name)
741         {
742             // use last stored affiliate code
743             _affID = plyr_[_pID].laff;
744 
745         // if affiliate code was given
746         } else {
747             // get affiliate ID from aff Code
748             _affID = pIDxName_[_affCode];
749 
750             // if affID is not the same as previously stored
751             if (_affID != plyr_[_pID].laff)
752             {
753                 // update last affiliate
754                 plyr_[_pID].laff = _affID;
755             }
756         }
757 
758         // reload core
759         reLoadCore(_pID, _affID, _eth, _eventData_);
760     }
761 
762     /**
763      * @dev withdraws all of your earnings.
764      * -functionhash- 0x3ccfd60b
765      */
766     function withdraw()
767         isActivated()
768         isHuman()
769         public
770     {
771         // setup local rID
772         uint256 _rID = rID_;
773 
774         // grab time
775         uint256 _now = now;
776 
777         // fetch player ID
778         uint256 _pID = pIDxAddr_[msg.sender];
779 
780         // setup temp var for player eth
781         uint256 _eth;
782 
783         // check to see if round has ended and no one has run endround yet
784         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
785         {
786             // set up our tx event data
787             FFEIFDatasets.EventReturns memory _eventData_;
788 
789             // end the round (distributes pot)
790             round_[_rID].ended = true;
791             _eventData_ = endRound(_eventData_);
792 
793             // get their earnings
794             _eth = withdrawEarnings(_pID);
795 
796             // gib moni
797             if (_eth > 0)
798                 plyr_[_pID].addr.transfer(_eth);
799 
800             // build event data
801             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
802             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
803 
804             // fire withdraw and distribute event
805             emit FOMOEvents.onWithdrawAndDistribute
806             (
807                 msg.sender,
808                 plyr_[_pID].name,
809                 _eth,
810                 _eventData_.compressedData,
811                 _eventData_.compressedIDs,
812                 _eventData_.winnerAddr,
813                 _eventData_.winnerName,
814                 _eventData_.amountWon,
815                 _eventData_.newPot,
816                 _eventData_.tokenAmount,
817                 _eventData_.genAmount,
818                 _eventData_.seedAdd
819             );
820 
821         // in any other situation
822         } else {
823             // get their earnings
824             _eth = withdrawEarnings(_pID);
825 
826             // gib moni
827             if (_eth > 0)
828                 plyr_[_pID].addr.transfer(_eth);
829 
830             // fire withdraw event
831             emit FOMOEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
832         }
833     }
834 
835     /**
836      * @dev use these to register names.  they are just wrappers that will send the
837      * registration requests to the PlayerBook contract.  So registering here is the
838      * same as registering there.  UI will always display the last name you registered.
839      * but you will still own all previously registered names to use as affiliate
840      * links.
841      * - must pay a registration fee.
842      * - name must be unique
843      * - names will be converted to lowercase
844      * - name cannot start or end with a space
845      * - cannot have more than 1 space in a row
846      * - cannot be only numbers
847      * - cannot start with 0x
848      * - name must be at least 1 char
849      * - max length of 32 characters long
850      * - allowed characters: a-z, 0-9, and space
851      * -functionhash- 0x921dec21 (using ID for affiliate)
852      * -functionhash- 0x3ddd4698 (using address for affiliate)
853      * -functionhash- 0x685ffd83 (using name for affiliate)
854      * @param _nameString players desired name
855      * @param _affCode affiliate ID, address, or name of who referred you
856      * @param _all set to true if you want this to push your info to all games
857      * (this might cost a lot of gas)
858      */
859     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
860         isHuman()
861         public
862         payable
863     {
864         bytes32 _name = _nameString.nameFilter();
865         address _addr = msg.sender;
866         uint256 _paid = msg.value;
867         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
868 
869         uint256 _pID = pIDxAddr_[_addr];
870 
871         // fire event
872         emit FOMOEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
873     }
874 
875     function registerNameXaddr(string _nameString, address _affCode, bool _all)
876         isHuman()
877         public
878         payable
879     {
880         bytes32 _name = _nameString.nameFilter();
881         address _addr = msg.sender;
882         uint256 _paid = msg.value;
883         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
884 
885         uint256 _pID = pIDxAddr_[_addr];
886 
887         // fire event
888         emit FOMOEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
889     }
890 
891     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
892         isHuman()
893         public
894         payable
895     {
896         bytes32 _name = _nameString.nameFilter();
897         address _addr = msg.sender;
898         uint256 _paid = msg.value;
899         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
900 
901         uint256 _pID = pIDxAddr_[_addr];
902 
903         // fire event
904         emit FOMOEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
905     }
906 //==============================================================================
907 //     _  _ _|__|_ _  _ _  .
908 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
909 //=====_|=======================================================================
910     /**
911      * @dev return the price buyer will pay for next 1 individual FFEIF.
912      * -functionhash- 0x018a25e8
913      * @return price for next FFEIF bought (in wei format)
914      */
915     function getBuyPrice()
916         public
917         view
918         returns(uint256)
919     {
920         //starting key/FFEIF price
921         uint256 _startingPrice = 75000000000000;
922         if (linearPrice != 0) _startingPrice = linearPrice;
923         
924         // setup local rID
925         uint256 _rID = rID_;
926 
927         // grab time
928         uint256 _now = now;
929 
930         // are we in a round?
931         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
932             return ( ethRec((round_[_rID].keys.add(1000000000000000000)),1000000000000000000) );
933         else // rounds over.  need price for new round
934             return ( _startingPrice ); // init
935     }
936 
937     /**
938      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
939      * provider
940      * -functionhash- 0xc7e284b8
941      * @return time left in seconds
942      */
943     function getTimeLeft()
944         public
945         view
946         returns(uint256)
947     {
948         // setup local rID
949         uint256 _rID = rID_;
950 
951         // grab time
952         uint256 _now = now;
953 
954         if (_now < round_[_rID].end)
955             if (_now > round_[_rID].strt + rndGap_)
956                 return( (round_[_rID].end).sub(_now) );
957             else
958                 return( (round_[_rID].strt + rndGap_).sub(_now) );
959         else
960             return(0);
961     }
962 
963     /**
964      * @dev returns player earnings per vaults
965      * -functionhash- 0x63066434
966      * @return winnings vault
967      * @return general vault
968      * @return affiliate vault
969      */
970     function getPlayerVaults(uint256 _pID)
971         public
972         view
973         returns(uint256 ,uint256, uint256)
974     {
975         // setup local rID
976         uint256 _rID = rID_;
977 
978         // if round has ended.  but endround has not been run (so contract has not distributed winnings)
979         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
980         {
981             // if player is winner
982             if (round_[_rID].plyr == _pID)
983             {
984                 return
985                 (
986                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(winnerPercentage)) / 100 ),
987                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
988                     plyr_[_pID].aff
989                 );
990             // if player is not the winner
991             } else {
992                 return
993                 (
994                     plyr_[_pID].win,
995                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
996                     plyr_[_pID].aff
997                 );
998             }
999 
1000         // if round is still going on, or round has ended and endround has been ran
1001         } else {
1002             return
1003             (
1004                 plyr_[_pID].win,
1005                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1006                 plyr_[_pID].aff
1007             );
1008         }
1009     }
1010 
1011     /**
1012      * solidity hates stack limits.  this lets us avoid that hate
1013      */
1014     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1015         private
1016         view
1017         returns(uint256)
1018     {
1019         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1020     }
1021 
1022     /**
1023      * @dev returns all current round info needed for front end
1024      * -functionhash- 0x747dff42
1025      * @return eth invested during ICO phase
1026      * @return round id
1027      * @return total FFEIF for round
1028      * @return time round ends
1029      * @return time round started
1030      * @return current pot
1031      * @return current team ID & player ID in lead
1032      * @return current player in leads address
1033      * @return current player in leads name
1034      * @return team eth in for round
1035      */
1036     function getCurrentRoundInfo()
1037         public
1038         view
1039         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
1040     {
1041         // setup local rID
1042         uint256 _rID = rID_;
1043 
1044         return
1045         (
1046             round_[_rID].ico,               //0
1047             _rID,                           //1
1048             round_[_rID].keys,              //2
1049             round_[_rID].end,               //3
1050             round_[_rID].strt,              //4
1051             round_[_rID].pot,               //5
1052             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1053             plyr_[round_[_rID].plyr].addr,  //7
1054             plyr_[round_[_rID].plyr].name,  //8
1055             rndTmEth_[_rID][0]             //9
1056             
1057         );
1058     }
1059 
1060     /**
1061      * @dev returns player info based on address.  if no address is given, it will
1062      * use msg.sender
1063      * -functionhash- 0xee0b5d8b
1064      * @param _addr address of the player you want to lookup
1065      * @return player ID
1066      * @return player name
1067      * @return FFEIF owned (current round)
1068      * @return winnings vault
1069      * @return general vault
1070      * @return affiliate vault
1071      * @return player round eth
1072      */
1073     function getPlayerInfoByAddress(address _addr)
1074         public
1075         view
1076         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1077     {
1078         // setup local rID
1079         uint256 _rID = rID_;
1080 
1081         if (_addr == address(0))
1082         {
1083             _addr = msg.sender;
1084         }
1085         uint256 _pID = pIDxAddr_[_addr];
1086 
1087         return
1088         (
1089             _pID,                               //0
1090             plyr_[_pID].name,                   //1
1091             plyrRnds_[_pID][_rID].keys,         //2
1092             plyr_[_pID].win,                    //3
1093             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1094             plyr_[_pID].aff,                    //5
1095             plyrRnds_[_pID][_rID].eth           //6
1096         );
1097     }
1098 
1099 //==============================================================================
1100 //     _ _  _ _   | _  _ . _  .
1101 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1102 //=====================_|=======================================================
1103     /**
1104      * @dev logic runs whenever a buy order is executed.  determines how to handle
1105      * incoming eth depending on if we are in an active round or not
1106      */
1107     function buyCore(uint256 _pID, uint256 _affID, FFEIFDatasets.EventReturns memory _eventData_)
1108         private
1109     {
1110         // setup local rID
1111         uint256 _rID = rID_;
1112 
1113         // grab time
1114         uint256 _now = now;
1115 
1116         // if round is active
1117         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1118         {
1119             // call core
1120             core(_rID, _pID, msg.value, _affID, 0, _eventData_);
1121 
1122         // if round is not active
1123         } else {
1124             // check to see if endround needs to be run
1125             if (_now > round_[_rID].end && round_[_rID].ended == false)
1126             {
1127                 // end the round (distributes pot) & start new round
1128                 round_[_rID].ended = true;
1129                 _eventData_ = endRound(_eventData_);
1130 
1131                 // build event data
1132                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1133                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1134 
1135                 // fire buy and distribute event
1136                 emit FOMOEvents.onBuyAndDistribute
1137                 (
1138                     msg.sender,
1139                     plyr_[_pID].name,
1140                     msg.value,
1141                     _eventData_.compressedData,
1142                     _eventData_.compressedIDs,
1143                     _eventData_.winnerAddr,
1144                     _eventData_.winnerName,
1145                     _eventData_.amountWon,
1146                     _eventData_.newPot,
1147                     _eventData_.tokenAmount,
1148                     _eventData_.genAmount,
1149                     _eventData_.seedAdd
1150                 );
1151             }
1152 
1153             // put eth in players vault
1154             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1155         }
1156     }
1157 
1158     /**
1159      * @dev logic runs whenever a reload order is executed.  determines how to handle
1160      * incoming eth depending on if we are in an active round or not
1161      */
1162     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, FFEIFDatasets.EventReturns memory _eventData_)
1163         private
1164     {
1165         // setup local rID
1166         uint256 _rID = rID_;
1167 
1168         // grab time
1169         uint256 _now = now;
1170 
1171         // if round is active
1172         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1173         {
1174             // get earnings from all vaults and return unused to gen vault
1175             // because we use a custom safemath library.  this will throw if player
1176             // tried to spend more eth than they have.
1177             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1178 
1179             // call core
1180             core(_rID, _pID, _eth, _affID, 0, _eventData_);
1181 
1182         // if round is not active and end round needs to be ran
1183         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1184             // end the round (distributes pot) & start new round
1185             round_[_rID].ended = true;
1186             _eventData_ = endRound(_eventData_);
1187 
1188             // build event data
1189             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1190             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1191 
1192             // fire buy and distribute event
1193             emit FOMOEvents.onReLoadAndDistribute
1194             (
1195                 msg.sender,
1196                 plyr_[_pID].name,
1197                 _eventData_.compressedData,
1198                 _eventData_.compressedIDs,
1199                 _eventData_.winnerAddr,
1200                 _eventData_.winnerName,
1201                 _eventData_.amountWon,
1202                 _eventData_.newPot,
1203                 _eventData_.tokenAmount,
1204                 _eventData_.genAmount,
1205                 _eventData_.seedAdd
1206             );
1207         }
1208     }
1209 
1210     /**
1211      * @dev this is the core logic for any buy/reload that happens while a round
1212      * is live.
1213      */
1214     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, FFEIFDatasets.EventReturns memory _eventData_)
1215         private
1216     {
1217         // if player is new to round
1218         if (plyrRnds_[_pID][_rID].keys == 0)
1219             _eventData_ = managePlayer(_pID, _eventData_);
1220 
1221         // early round eth limiter
1222         if (round_[_rID].eth < earlyRoundLimitUntil && plyrRnds_[_pID][_rID].eth.add(_eth) > earlyRoundLimit)
1223         {
1224             uint256 _availableLimit = (earlyRoundLimit).sub(plyrRnds_[_pID][_rID].eth);
1225             uint256 _refund = _eth.sub(_availableLimit);
1226             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1227             _eth = _availableLimit;
1228         }
1229 
1230         // above minimum amount for normal buys
1231         if (_eth > 1000000000)
1232         {
1233 
1234             // mint the new FFEIF
1235             uint256 _keys = keysRec(round_[_rID].eth,_eth);
1236             
1237             // calculate the new multiplier and returns true if new winner (they bought enough)
1238             bool newWinner = calcMult(_keys, multAllowLast==1 || round_[_rID].plyr != _pID);
1239 
1240             // if they bought at least 1 whole FFEIF
1241             if (_keys >= 1000000000000000000)
1242             {
1243                 updateTimer(_keys, _rID);
1244 
1245                 if (newWinner) {
1246                     // set new leaders
1247                     if (round_[_rID].plyr != _pID)
1248                     round_[_rID].plyr = _pID;
1249                     if (round_[_rID].team != _team)
1250                     round_[_rID].team = _team;
1251 
1252                     // set the new leader bool to true
1253                     _eventData_.compressedData = _eventData_.compressedData + 100;
1254                 }
1255             }
1256 
1257             // update player
1258             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1259             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1260 
1261             // update round
1262             round_[_rID].keys = _keys.add(round_[_rID].keys);
1263             round_[_rID].eth = _eth.add(round_[_rID].eth);
1264             rndTmEth_[_rID][0] = _eth.add(rndTmEth_[_rID][0]);
1265 
1266             // distribute eth
1267             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, 0, _eventData_);
1268             _eventData_ = distributeInternal(_rID, _pID, _eth, 0, _keys, _eventData_);
1269 
1270             // call end tx function to fire end tx event.
1271             endTx(_pID, 0, _eth, _keys, _eventData_);
1272         }
1273     }
1274 //==============================================================================
1275 //     _ _ | _   | _ _|_ _  _ _  .
1276 //    (_(_||(_|_||(_| | (_)| _\  .
1277 //==============================================================================
1278     /**
1279      * @dev calculates unmasked earnings (just calculates, does not update mask)
1280      * @return earnings in wei format
1281      */
1282     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1283         private
1284         view
1285         returns(uint256)
1286     {
1287         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1288     }
1289 
1290     /**
1291      * @dev returns the amount of FFEIF you would get given an amount of eth.
1292      * -functionhash- 0xce89c80c
1293      * @param _rID round ID you want price for
1294      * @param _eth amount of eth sent in
1295      * @return keys received
1296      */
1297     function calcKeysReceived(uint256 _rID, uint256 _eth)
1298         public
1299         view
1300         returns(uint256)
1301     {
1302         // grab time
1303         uint256 _now = now;
1304 
1305         // are we in a round?
1306         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1307             return keysRec(round_[_rID].eth,_eth);
1308         else // rounds over.  need FFEIF for new round
1309             return keys(_eth);
1310     }
1311 
1312     /**
1313      * @dev returns current eth price for X FFEIF.
1314      * -functionhash- 0xcf808000
1315      * @param _keys number of FFEIF desired (in 18 decimal format)
1316      * @return amount of eth needed to send
1317      */
1318     function iWantXKeys(uint256 _keys)
1319         public
1320         view
1321         returns(uint256)
1322     {
1323         // setup local rID
1324         uint256 _rID = rID_;
1325 
1326         // grab time
1327         uint256 _now = now;
1328 
1329         // are we in a round?
1330         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1331             return ethRec(round_[_rID].keys.add(_keys),_keys);
1332         else // rounds over.  need price for new round
1333             return eth(_keys);
1334     }
1335 //==============================================================================
1336 //    _|_ _  _ | _  .
1337 //     | (_)(_)|_\  .
1338 //==============================================================================
1339     /**
1340      * @dev receives name/player info from names contract
1341      */
1342     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1343         external
1344     {
1345         require (msg.sender == address(PlayerBook));
1346         if (pIDxAddr_[_addr] != _pID)
1347             pIDxAddr_[_addr] = _pID;
1348         if (pIDxName_[_name] != _pID)
1349             pIDxName_[_name] = _pID;
1350         if (plyr_[_pID].addr != _addr)
1351             plyr_[_pID].addr = _addr;
1352         if (plyr_[_pID].name != _name)
1353             plyr_[_pID].name = _name;
1354         if (plyr_[_pID].laff != _laff)
1355             plyr_[_pID].laff = _laff;
1356         if (plyrNames_[_pID][_name] == false)
1357             plyrNames_[_pID][_name] = true;
1358     }
1359 
1360     /**
1361      * @dev receives entire player name list
1362      */
1363     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1364         external
1365     {
1366         require (msg.sender == address(PlayerBook));
1367         if(plyrNames_[_pID][_name] == false)
1368             plyrNames_[_pID][_name] = true;
1369     }
1370 
1371     /**
1372      * @dev gets existing or registers new pID.  use this when a player may be new
1373      * @return pID
1374      */
1375     function determinePID(FFEIFDatasets.EventReturns memory _eventData_)
1376         private
1377         returns (FFEIFDatasets.EventReturns)
1378     {
1379         uint256 _pID = pIDxAddr_[msg.sender];
1380         // if player is new to this version of fomo3d
1381         if (_pID == 0)
1382         {
1383             // grab their player ID, name and last aff ID, from player names contract
1384             _pID = PlayerBook.getPlayerID(msg.sender);
1385             bytes32 _name = PlayerBook.getPlayerName(_pID);
1386             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1387 
1388             // set up player account
1389             pIDxAddr_[msg.sender] = _pID;
1390             plyr_[_pID].addr = msg.sender;
1391 
1392             if (_name != "")
1393             {
1394                 pIDxName_[_name] = _pID;
1395                 plyr_[_pID].name = _name;
1396                 plyrNames_[_pID][_name] = true;
1397             }
1398 
1399             if (_laff != 0 && _laff != _pID)
1400                 plyr_[_pID].laff = _laff;
1401 
1402             // set the new player bool to true
1403             _eventData_.compressedData = _eventData_.compressedData + 1;
1404         }
1405         return (_eventData_);
1406     }
1407 
1408     
1409 
1410     /**
1411      * @dev decides if round end needs to be run & new round started.  and if
1412      * player unmasked earnings from previously played rounds need to be moved.
1413      */
1414     function managePlayer(uint256 _pID, FFEIFDatasets.EventReturns memory _eventData_)
1415         private
1416         returns (FFEIFDatasets.EventReturns)
1417     {
1418         // if player has played a previous round, move their unmasked earnings
1419         // from that round to gen vault.
1420         if (plyr_[_pID].lrnd != 0)
1421             updateGenVault(_pID, plyr_[_pID].lrnd);
1422 
1423         // update player's last round played
1424         plyr_[_pID].lrnd = rID_;
1425 
1426         // set the joined round bool to true
1427         _eventData_.compressedData = _eventData_.compressedData + 10;
1428 
1429         return(_eventData_);
1430     }
1431 
1432 
1433     /**
1434      * @dev ends the round. manages paying out winner/splitting up pot
1435      */
1436     function endRound(FFEIFDatasets.EventReturns memory _eventData_)
1437         private
1438         returns (FFEIFDatasets.EventReturns)
1439     {
1440         // setup local rID
1441         uint256 _rID = rID_;
1442 
1443         // grab our winning player and team id's
1444         uint256 _winPID = round_[_rID].plyr;
1445         uint256 _winTID = round_[_rID].team;
1446 
1447         // grab our pot amount
1448         uint256 _pot = round_[_rID].pot;
1449 
1450         // calculate our winner share, community rewards, gen share,
1451         // tokenholder share, and amount reserved for next pot
1452         uint256 _win = _pot.mul(winnerPercentage) / 100;  // to winner
1453         uint256 _gen = _pot.mul(potSplit_[_winTID].gen) / 100;  // divs to FFEIF buyers
1454         uint256 _PoEIF = _pot.mul(potSplit_[_winTID].poeif) / 100;  // to PoEIF/EIF smart contracts
1455         uint256 _res = _pot.sub(_win).sub(_gen).sub(_PoEIF);  // amount for next round
1456 
1457 
1458         // calculate ppt for round mask
1459         uint256 _ppt = _gen.mul(1000000000000000000) / round_[_rID].keys;
1460         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1461         if (_dust > 0)
1462         {
1463             _gen = _gen.sub(_dust);
1464             _res = _res.add(_dust);
1465         }
1466 
1467         // pay our winner
1468         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1469 
1470         // community rewards
1471 
1472         
1473         
1474         // send ETH to PoEIF holders and to EIF contract (50% each) 
1475         address(PoEIFContract).call.value(_PoEIF.sub((_PoEIF / 2)))(bytes4(keccak256("donateDivs()"))); 
1476         fundEIF = fundEIF.add(_PoEIF / 2);
1477 
1478         // distribute gen portion to FFEIF holders
1479         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1480         
1481         uint256 _actualPot = _res;
1482         // send appropriate portion of _res to seeding pot
1483         if (seedRoundEnd==1) {
1484             // stick half into seedingPot and the remainder is the amount actually added to pot - seedingDivisor default is 2 which means half goes into seedingPot
1485             _actualPot = _res.sub(_res/seedingDivisor);
1486             // if seedingThreshold exceeds eth in the round then put all into seeding pot, else just half
1487             if (seedingThreshold > rndTmEth_[_rID][0]) {seedingPot = seedingPot.add(_res); _actualPot = 0;} else seedingPot = seedingPot.add(_res/seedingDivisor);
1488         }
1489 
1490         // prepare event data
1491         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1492         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1493         _eventData_.winnerAddr = plyr_[_winPID].addr;
1494         _eventData_.winnerName = plyr_[_winPID].name;
1495         _eventData_.amountWon = _win;
1496         _eventData_.genAmount = _gen;
1497         _eventData_.tokenAmount = _PoEIF;
1498         _eventData_.newPot = _actualPot;
1499         _eventData_.seedAdd = _res - _actualPot;   
1500              
1501 
1502         // start next round
1503         setStore("endround",0); // update any config changes
1504         rID_++;
1505         _rID++;
1506         round_[_rID].strt = now;
1507         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1508         round_[_rID].pot += _actualPot;
1509 
1510         return(_eventData_);
1511     }
1512 
1513     /**
1514      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1515      */
1516     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1517         private
1518     {
1519         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1520         if (_earnings > 0)
1521         {
1522             // put in gen vault
1523             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1524             // zero out their earnings by updating mask
1525             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1526         }
1527     }
1528 
1529     /**
1530      * @dev updates round timer based on number of whole FFEIF bought.
1531      */
1532     function updateTimer(uint256 _keys, uint256 _rID)
1533         private
1534     {
1535         // grab time
1536         uint256 _now = now;
1537 
1538         // calculate time based on number of FFEIF bought
1539         uint256 _newTime;
1540         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1541             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)/rndIncDivisor_).add(_now);
1542         else
1543             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)/rndIncDivisor_).add(round_[_rID].end);
1544 
1545         // compare to max and set new end time
1546         if (_newTime < (rndMax_).add(_now))
1547             round_[_rID].end = _newTime;
1548         else
1549             round_[_rID].end = rndMax_.add(_now); 
1550     }
1551 
1552    
1553     /**
1554      * @dev distributes eth based on fees to aff and PoEIF
1555      */
1556     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, FFEIFDatasets.EventReturns memory _eventData_)
1557         private
1558         returns(FFEIFDatasets.EventReturns)
1559     {
1560         uint256 _PoEIF;
1561      
1562         // distribute share to affiliate (default 5%)
1563         uint256 _aff = _eth.mul(affFee) / 100;
1564 
1565         // decide what to do with affiliate share of fees
1566         // affiliate must not be self, and must have a name registered
1567         if (_affID != _pID && plyr_[_affID].name != '') {
1568             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1569             emit FOMOEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1570         } else {
1571             _PoEIF = _aff;
1572         }
1573 
1574         // pay out poeif
1575         _PoEIF = _PoEIF.add((_eth.mul(fees_[_team].poeif)) / 100);
1576         if (_PoEIF > 0)
1577         {
1578             // deposit to divies contract
1579             uint256 _EIFamount = _PoEIF / 2;
1580             
1581             address(PoEIFContract).call.value(_PoEIF.sub(_EIFamount))(bytes4(keccak256("donateDivs()")));
1582 
1583             fundEIF = fundEIF.add(_EIFamount);
1584 
1585             // set up event data
1586             _eventData_.tokenAmount = _PoEIF.add(_eventData_.tokenAmount);
1587         }
1588 
1589         return(_eventData_);
1590     }
1591 
1592     /**
1593      * @dev distributes eth based on fees to gen and pot
1594      */
1595     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, FFEIFDatasets.EventReturns memory _eventData_)
1596         private
1597         returns(FFEIFDatasets.EventReturns)
1598     {
1599         // calculate gen share
1600         uint256 _gen = _eth.mul(fees_[_team].gen) / 100;
1601 
1602         // update eth balance (eth = eth - (aff share + poeif share))
1603         _eth = _eth.sub(((_eth.mul(affFee)) / 100).add((_eth.mul(fees_[_team].poeif)) / 100));
1604 
1605         // calculate pot
1606         uint256 _pot = _eth.sub(_gen);
1607         // stick half into seedingPot and the remainder is the amount actually added to pot - seedingDivisor default is 2 which means half goes into seedingPot
1608         uint256 _actualPot = _pot.sub(_pot/seedingDivisor);
1609         
1610         // if seedingThreshold exceeds eth in the round then put all into seeding pot, else just half
1611         if (seedingThreshold > rndTmEth_[_rID][0]) {seedingPot = seedingPot.add(_pot); _actualPot = 0;} else seedingPot = seedingPot.add(_pot/seedingDivisor);
1612 
1613         // distribute gen share (thats what updateMasks() does) and adjust
1614         // balances for dust.
1615         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1616         if (_dust > 0)
1617             _gen = _gen.sub(_dust);
1618 
1619         // add eth to pot
1620         round_[_rID].pot = _actualPot.add(_dust).add(round_[_rID].pot);
1621 
1622         // set up event data - pot amount excludes seeding
1623         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1624         _eventData_.potAmount = _actualPot;
1625         _eventData_.seedAdd = _pot - _actualPot;
1626 
1627         return(_eventData_);
1628     }
1629 
1630     /**
1631      * @dev updates masks for round and player when FFEIF are bought
1632      * @return dust left over
1633      */
1634     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1635         private
1636         returns(uint256)
1637     {
1638         /* MASKING NOTES
1639             earnings masks are a tricky thing for people to wrap their minds around.
1640             the basic thing to understand here.  is were going to have a global
1641             tracker based on profit per share for each round, that increases in
1642             relevant proportion to the increase in share supply.
1643 
1644             the player will have an additional mask that basically says "based
1645             on the rounds mask, my shares, and how much i've already withdrawn,
1646             how much is still owed to me?"
1647         */
1648 
1649         // calc profit per FFEIF & round mask based on this buy:  (dust goes to pot)
1650         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1651         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1652 
1653         // calculate player earning from their own buy (only based on the FFEIF
1654         // they just bought).  & update player earnings mask
1655         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1656         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1657 
1658         // calculate & return dust
1659         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1660     }
1661 
1662     /**
1663      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1664      * @return earnings in wei format
1665      */
1666     function withdrawEarnings(uint256 _pID)
1667         private
1668         returns(uint256)
1669     {
1670         // update gen vault
1671         updateGenVault(_pID, plyr_[_pID].lrnd);
1672 
1673         // from vaults
1674         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1675         if (_earnings > 0)
1676         {
1677             plyr_[_pID].win = 0;
1678             plyr_[_pID].gen = 0;
1679             plyr_[_pID].aff = 0;
1680         }
1681 
1682         return(_earnings);
1683     }
1684 
1685     /**
1686      * @dev prepares compression data and fires event for buy or reload tx's
1687      */
1688     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, FFEIFDatasets.EventReturns memory _eventData_)
1689         private
1690     {
1691         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1692         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1693 
1694        emit FOMOEvents.onEndTx
1695         (
1696             _eventData_.compressedData,
1697             _eventData_.compressedIDs,
1698             plyr_[_pID].name,
1699             msg.sender,
1700             _eth,
1701             _keys,
1702             _eventData_.winnerAddr,
1703             _eventData_.winnerName,
1704             _eventData_.amountWon,
1705             _eventData_.newPot,
1706             _eventData_.tokenAmount,
1707             _eventData_.genAmount,
1708             _eventData_.potAmount,
1709             _eventData_.seedAdd
1710         );
1711     }
1712 //==============================================================================
1713 //    (~ _  _    _._|_    .
1714 //    _)(/_(_|_|| | | \/  .
1715 //====================/=========================================================
1716     /** upon contract deploy, it will be deactivated.  this is a one time
1717      * use function that will activate the contract.  we do this so devs
1718      * have time to set things up on the web end                            **/
1719     bool public activated_ = false;
1720     function activate()
1721         public
1722     {
1723         // only team just can activate
1724         require(msg.sender == admin, "Only admin can activate");
1725 
1726 
1727         // can only be ran once
1728         require(activated_ == false, "FFEIF already activated");
1729 
1730         // update any configuration changes
1731         setStore("endround",0);
1732         
1733         // activate the contract
1734         activated_ = true;
1735 
1736         // lets start first round
1737         rID_ = 1;
1738             round_[1].strt = now + rndExtra_ - rndGap_;
1739             round_[1].end = now + rndInit_ + rndExtra_;
1740             
1741         //set potNextSeedTime to current block timestamp plus one hour 
1742         potNextSeedTime = now + 3600;
1743     }
1744     
1745     
1746     function removeAdmin()   //stops any further updates happening to make it completely autonomous
1747         public
1748     {
1749         require(msg.sender == admin, "Only admin can remove himself");
1750         admin =  address(0);  // dummy 0x000... address 
1751     }
1752     
1753     
1754 }
1755  
1756 //==============================================================================
1757 //   __|_ _    __|_ _  .
1758 //  _\ | | |_|(_ | _\  .
1759 //==============================================================================
1760 library FFEIFDatasets {
1761     
1762     struct EventReturns {
1763         uint256 compressedData;
1764         uint256 compressedIDs;
1765         address winnerAddr;         // winner address
1766         bytes32 winnerName;         // winner name
1767         uint256 amountWon;          // amount won
1768         uint256 newPot;             // amount in new pot
1769         uint256 tokenAmount;        // amount distributed to PoEIF tokenholders and EIF
1770         uint256 genAmount;          // amount distributed to gen
1771         uint256 potAmount;          // amount added to pot
1772         uint256 seedAdd;            // amount added to seedingPot
1773         
1774     }
1775     struct Player {
1776         address addr;   // player address
1777         bytes32 name;   // player name
1778         uint256 win;    // winnings vault
1779         uint256 gen;    // general vault
1780         uint256 aff;    // affiliate vault
1781         uint256 lrnd;   // last round played
1782         uint256 laff;   // last affiliate id used
1783     }
1784     struct PlayerRounds {
1785         uint256 eth;    // eth player has added to round (used for eth limiter)
1786         uint256 keys;   // FFEIF/keys
1787         uint256 mask;   // player mask
1788         uint256 ico;    // ICO phase investment
1789     }
1790     struct Round {
1791         uint256 plyr;   // pID of player in lead
1792         uint256 team;   // tID of team in lead
1793         uint256 end;    // time ends/ended
1794         bool ended;     // has round end function been ran
1795         uint256 strt;   // time round started
1796         uint256 keys;   // FFEIF/keys
1797         uint256 eth;    // total eth in
1798         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1799         uint256 mask;   // global mask
1800         uint256 ico;    // total eth sent in during ICO phase
1801         uint256 icoGen; // total eth for gen during ICO phase
1802         uint256 icoAvg; // average FFEIF price for ICO phase
1803     }
1804     struct TeamFee {
1805         uint256 gen;    // % of buy in thats paid to FFEIF holders of current round
1806         uint256 poeif;  // % of buy in thats paid to PoEIF holders and EIF
1807     }
1808     struct PotSplit {
1809         uint256 gen;    // % of pot thats paid to FFEIF holders of current round
1810         uint256 poeif;  // % of pot thats paid to PoEIF holders and EIF
1811     }
1812 }
1813 
1814 
1815 
1816 
1817 //==============================================================================
1818 //  . _ _|_ _  _ |` _  _ _  _  .
1819 //  || | | (/_| ~|~(_|(_(/__\  .
1820 //==============================================================================
1821 
1822 //Define the PoEIF token for the sending 5% divs
1823 contract PoEIF 
1824 {
1825     function donateDivs() public payable;
1826 }
1827 
1828 interface PlayerBookInterface {
1829     function getPlayerID(address _addr) external returns (uint256);
1830     function getPlayerName(uint256 _pID) external view returns (bytes32);
1831     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1832     function getPlayerAddr(uint256 _pID) external view returns (address);
1833     function getNameFee() external view returns (uint256);
1834     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1835     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1836     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1837 }
1838 
1839 
1840 library NameFilter {
1841     /**
1842      * @dev filters name strings
1843      * -converts uppercase to lower case.
1844      * -makes sure it does not start/end with a space
1845      * -makes sure it does not contain multiple spaces in a row
1846      * -cannot be only numbers
1847      * -cannot start with 0x
1848      * -restricts characters to A-Z, a-z, 0-9, and space.
1849      * @return reprocessed string in bytes32 format
1850      */
1851     function nameFilter(string _input)
1852         internal
1853         pure
1854         returns(bytes32)
1855     {
1856         bytes memory _temp = bytes(_input);
1857         uint256 _length = _temp.length;
1858 
1859         //sorry limited to 32 characters
1860         require (_length <= 32 && _length > 0);
1861         // make sure it doesnt start with or end with space
1862         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20);
1863         // make sure first two characters are not 0x
1864         if (_temp[0] == 0x30)
1865         {
1866             require(_temp[1] != 0x78);
1867             require(_temp[1] != 0x58);
1868         }
1869 
1870         // create a bool to track if we have a non number character
1871         bool _hasNonNumber;
1872 
1873         // convert & check
1874         for (uint256 i = 0; i < _length; i++)
1875         {
1876             // if its uppercase A-Z
1877             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1878             {
1879                 // convert to lower case a-z
1880                 _temp[i] = byte(uint(_temp[i]) + 32);
1881 
1882                 // we have a non number
1883                 if (_hasNonNumber == false)
1884                     _hasNonNumber = true;
1885             } else {
1886                 require
1887                 (
1888                     // require character is a space
1889                     _temp[i] == 0x20 ||
1890                     // OR lowercase a-z
1891                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1892                     // or 0-9
1893                     (_temp[i] > 0x2f && _temp[i] < 0x3a));
1894                 // make sure theres not 2x spaces in a row
1895                 if (_temp[i] == 0x20)
1896                     require( _temp[i+1] != 0x20);
1897 
1898                 // see if we have a character other than a number
1899                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1900                     _hasNonNumber = true;
1901             }
1902         }
1903 
1904         require(_hasNonNumber == true);
1905 
1906         bytes32 _ret;
1907         assembly {
1908             _ret := mload(add(_temp, 32))
1909         }
1910         return (_ret);
1911     }
1912 }
1913 
1914 /**
1915  * @title SafeMath v0.1.9
1916  * @dev Math operations with safety checks that throw on error
1917  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1918  * - added sqrt
1919  * - added sq
1920  * - added pwr
1921  * - changed asserts to requires with error log outputs
1922  * - removed div, its useless
1923  */
1924 library SafeMath {
1925 
1926     /**
1927     * @dev Multiplies two numbers, throws on overflow.
1928     */
1929     function mul(uint256 a, uint256 b)
1930         internal
1931         pure
1932         returns (uint256 c)
1933     {
1934         if (a == 0) {
1935             return 0;
1936         }
1937         c = a * b;
1938         require(c / a == b, "SafeMath mul failed");
1939         return c;
1940     }
1941   
1942 
1943     /**
1944     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1945     */
1946     function sub(uint256 a, uint256 b)
1947         internal
1948         pure
1949         returns (uint256)
1950     {
1951         require(b <= a, "SafeMath sub failed");
1952         return a - b;
1953     }
1954 
1955     /**
1956     * @dev Adds two numbers, throws on overflow.
1957     */
1958     function add(uint256 a, uint256 b)
1959         internal
1960         pure
1961         returns (uint256 c)
1962     {
1963         c = a + b;
1964         require(c >= a, "SafeMath add failed");
1965         return c;
1966     }
1967 
1968     /**
1969      * @dev gives square root of given x.
1970      */
1971     function sqrt(uint256 x)
1972         internal
1973         pure
1974         returns (uint256 y)
1975     {
1976         uint256 z = ((add(x,1)) / 2);
1977         y = x;
1978         while (z < y)
1979         {
1980             y = z;
1981             z = ((add((x / z),z)) / 2);
1982         }
1983     }
1984 
1985     /**
1986      * @dev gives square. multiplies x by x
1987      */
1988     function sq(uint256 x)
1989         internal
1990         pure
1991         returns (uint256)
1992     {
1993         return (mul(x,x));
1994     }
1995 
1996     /**
1997      * @dev x to the power of y
1998      */
1999     function pwr(uint256 x, uint256 y)
2000         internal
2001         pure
2002         returns (uint256)
2003     {
2004         if (x==0)
2005             return (0);
2006         else if (y==0)
2007             return (1);
2008         else
2009         {
2010             uint256 z = x;
2011             for (uint256 i=1; i < y; i++)
2012                 z = mul(z,x);
2013             return (z);
2014         }
2015     }
2016 }